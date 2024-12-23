// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

#pragma once

#include "core/framework/execution_provider.h"
#include "core/graph/constants.h"

namespace onnxruntime {

// Information needed to construct CPU execution providers.
struct VkExecutionProviderInfo {
  bool create_arena{true};

  explicit VkExecutionProviderInfo(bool use_arena)
      : create_arena(use_arena) {}

  VkExecutionProviderInfo() = default;
};

using FuseRuleFn = std::function<void(const onnxruntime::GraphViewer&,
                                      std::vector<std::unique_ptr<ComputeCapability>>&)>;

// Logical device representation.
class VkExecutionProvider : public IExecutionProvider {
 public:
  // delay_allocator_registration = true is used to allow sharing of allocators between different providers that are
  // associated with the same device
  explicit VkExecutionProvider(const VkExecutionProviderInfo& info);

  std::shared_ptr<KernelRegistry> GetKernelRegistry() const override;
  std::unique_ptr<IDataTransfer> GetDataTransfer() const override;
  std::vector<AllocatorPtr> CreatePreferredAllocators() override;

 private:
  VkExecutionProviderInfo info_;
  std::vector<FuseRuleFn> fuse_rules_;
};

// Registers all available CPU kernels
Status RegisterCPUKernels(KernelRegistry& kernel_registry);

}  // namespace onnxruntime
