Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 357AFC83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:04:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0CD06B00CE; Wed, 23 Jul 2025 10:04:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABD736B00D1; Wed, 23 Jul 2025 10:04:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ACBA6B00D4; Wed, 23 Jul 2025 10:04:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8AFCE6B00CE
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:04:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 574E48070B
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:04:16 +0000 (UTC)
X-FDA: 83695698912.20.89025E9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf30.hostedemail.com (Postfix) with ESMTP id 257A780011
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:04:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RjbRfDZj;
	spf=pass (imf30.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753279454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KNzL+kDc8WDx2KM+GCdUwHyyPTt0NCrzGFF8DO2SMwc=;
	b=f6bx7cTY10knKH+eQ5fLhXbfWQn+URpRWk1cuY7vhHgcLbZYAn0l/NHg9z1/kuT6wiRGW7
	5Jbb5YgJEdRC4lAIRxk3csD4txyKVjZzyGtNvMK1Mjhu9vtA2pt30BO12OypGVjbY1sgI7
	3c1CmXYu/lzitAxo5WT19scYOWz/r7Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753279454; a=rsa-sha256;
	cv=none;
	b=wRt7kE0CYqIOv9tsPTFqi+jOex20cOJUHMAskmcz3XlsoOHxE0tMH+4xNFVlKcLCkXpDS6
	twAMQLnJcQL4mCbCGPq37f/A6K8OsFb19zg/d3dy6HKvysY7RK5W+Pq99gqQshYByk5yBt
	Z1PjhVEwiCPH3uTvmYBmISlFmSZuTJ0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RjbRfDZj;
	spf=pass (imf30.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753279453; x=1784815453;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lC7D423FBBscRuryASHtu4WfamrsmdENxp22E1bBitw=;
  b=RjbRfDZjDkP+RNc6ivmE1KmkA4fyJG1VseDY10zVwhs4VcHPa/xEqBqW
   NEfgGGdl2dmaEWW8nx1dBPLlzKI28ZkPF3YWC0+re09iwyjjYLekhfCb9
   XmGJqZScHMuOeGbD5G+CxDFkP+uEfF7IrGWpXJv3jiC0h/pENARbrokCz
   Qxolxb0pJ0PfFutzY4YHG2ixgJssGLBJ7n40khIfakWNMF951EnNTY1pt
   uKzvElAlIkAADUp4nq8LtyFsiOM8EuofXrVxufvN15IsIFnfOT9qkfrGS
   bCo6NaYpUzqbaL3TEekEG2+ykP+7cb0WZaAYIs7tWXpZoB8d94/JfI9BS
   g==;
X-CSE-ConnectionGUID: +VqM/DzPQQO6jnfcIp3mSA==
X-CSE-MsgGUID: lgJxHcKnTNqeiaUHLWZ/MQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="55505243"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="55505243"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 07:04:11 -0700
X-CSE-ConnectionGUID: MEc0+Hk+ToyvuSHaf8ZX5A==
X-CSE-MsgGUID: agVwp6nNQBG9waDbKb6Pjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="190480304"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 07:03:57 -0700
Message-ID: <c301ec11-9d24-4cc6-9dc7-46800df4d5a8@intel.com>
Date: Wed, 23 Jul 2025 22:03:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 10/22] KVM: guest_memfd: Add plumbing to host to map
 guest_memfd pages
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, vannapurve@google.com,
 ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250723104714.1674617-1-tabba@google.com>
 <20250723104714.1674617-11-tabba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250723104714.1674617-11-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 257A780011
X-Stat-Signature: qitu13nxh93narcszehnerftxicmx7op
X-Rspam-User: 
X-HE-Tag: 1753279452-470249
X-HE-Meta: U2FsdGVkX19KzUisPfvTrrbu9yfwvmmZ6ZhB4hw0PVS1T3MhtM0XlbHBD0Grdin6/IZee3GI7kuB9Li0Z64CDG1OkaUNFOKZQyr8fN5WPRA1ycyuoB7jDeIsuH3RKKr7nc7EPi2s2B2FtAmy0LvGXPtfdN06T4Nvkq+YMyHfq9MobGxx805p3VVgXkZdc0luqcirHO54sAW+3Ie0R5OGJs9Sa3KAVVhzF7hVcqnGVPDjvjLSvanSsEdoRL0gdsKcYKZIbLvBfmGiV38QEMWyZlKX0QjnRukxccPiiIzJ+7d9Xwg+32Jbzpa8yI9BVW8GD0rlWP+0Fc8U7Ds0mg2bSijtt4saLMlz5xwi+5u0RAESmNRnGZoLp6Kw5bwYN3so0tFOI9oh8SYBOGMHpWo07ehkaXlfPjsmx7DfMOKdpA2z8AG65JJanS6aOdsuaGpewrw1Jb3+/SeHnE336D9gzAIy5dXUdoaZjzPZp2Q1O4P5wJ2EoF5TW0gAbwg8oTZLUPQ0ipWa7okQilbrX8+w3+y2gnDFEcF9vrM24bBqC6432HigXDUKC7lV0qY02EQCH557IhgJwbhN8t2zeruHk4i7mo6zyg6W86+8eh656cNf8d4TJxWVl8SepPbd3AECeOgNmbgCUOls1MosbDnhgTzqqBfev6zjUD8WHmn3YQ+twl91eyfsD9i3Me95geWoudfrvmpCLzsYRnI5cZai8szWlWgfQKH9135tkv5q4jcTsEcx/OKaVv6x1XS1dVjcTr86A6QkBApLiMa1IEWJhlA75ijlUnKGbOx+Cxy0lrx5V+8MvO7FH5HQq7K33m34Y/Drhzj7msQ2gZwBB2hEIMNu6oklTRA2hXK6MUEk0xH62CPP28h6DqSxxBH7zAQMKM6CZhxxWQkY4FyLjG8Qva0ZcYpxk1gd+/voogtMoiNFwYTIMAjDiQvO8vxqdtGdoDxNFVLViEng7ueePpX
 +i/iO234
 GlFQyiNQzw8dI4GOf50HOhSyXEscVuQdbYyd08Od3lTJAoSdtwfTtJvt8FrCim/ykGB0s4E1w27GqcNx47WWayPV7F6zYCHxilWjC8osen4O9KJGEUyPjw0tn1QWJsYoYIFqtiSwIUZ5gk8XCpt1o0+m01AclP3YUOM5nSsLNI+ShbdWQGk9BL0X4xyZ/RTh3w3BG1m4ylz9QedxJM0sAR5wO3VFkiHE0ptSmiJZvA5nW8xKJ+8noMbhqhGKvfUPtAuwWeRLSU8FeOYlDkhXolUjS8wb93aba4g4l6OSG7mBj4Bcr0zmuEXz57FDtvW+2bSiEh0TBHLEDLK3tOXAvAb0AhWJky2qybeC61OgW4HQCdY1aFlEniPKe006GXH6XnYVFLmZqYeGBg3aI9ZuA3EBHP/aL2yy+/aQBkol/jM5o0DppIXw2zJOXqqRTIKWmeG6JY1T4U5HULovZtMsrtcLldfvfG4yuP70l2y/uqnxT8bY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/23/2025 6:47 PM, Fuad Tabba wrote:
> Introduce the core infrastructure to enable host userspace to mmap()
> guest_memfd-backed memory. This is needed for several evolving KVM use
> cases:
> 
> * Non-CoCo VM backing: Allows VMMs like Firecracker to run guests
>    entirely backed by guest_memfd, even for non-CoCo VMs [1]. This
>    provides a unified memory management model and simplifies guest memory
>    handling.
> 
> * Direct map removal for enhanced security: This is an important step
>    for direct map removal of guest memory [2]. By allowing host userspace
>    to fault in guest_memfd pages directly, we can avoid maintaining host
>    kernel direct maps of guest memory. This provides additional hardening
>    against Spectre-like transient execution attacks by removing a
>    potential attack surface within the kernel.
> 
> * Future guest_memfd features: This also lays the groundwork for future
>    enhancements to guest_memfd, such as supporting huge pages and
>    enabling in-place sharing of guest memory with the host for CoCo
>    platforms that permit it [3].
> 
> Enable the basic mmap and fault handling logic within guest_memfd, but
> hold off on allow userspace to actually do mmap() until the architecture
> support is also in place.
> 
> [1] https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
> [2] https://lore.kernel.org/linux-mm/cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com
> [3] https://lore.kernel.org/all/c1c9591d-218a-495c-957b-ba356c8f8e09@redhat.com/T/#u
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Shivank Garg <shivankg@amd.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/x86.c       | 11 +++++++
>   include/linux/kvm_host.h |  4 +++
>   virt/kvm/guest_memfd.c   | 70 ++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 85 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a1c49bc681c4..e5cd54ba1eaa 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13518,6 +13518,16 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
>   }
>   EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
>   
> +#ifdef CONFIG_KVM_GUEST_MEMFD
> +/*
> + * KVM doesn't yet support mmap() on guest_memfd for VMs with private memory
> + * (the private vs. shared tracking needs to be moved into guest_memfd).
> + */
> +bool kvm_arch_supports_gmem_mmap(struct kvm *kvm)
> +{
> +	return !kvm_arch_has_private_mem(kvm);
> +}
> +

I think it's better to move the kvm_arch_supports_gmem_mmap() stuff to 
patch 20. Because we don't know how kvm_arch_supports_gmem_mmap() is 
going to be used unitll that patch.

>   #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
>   int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order)
>   {
> @@ -13531,6 +13541,7 @@ void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
>   	kvm_x86_call(gmem_invalidate)(start, end);
>   }
>   #endif
> +#endif
>   
>   int kvm_spec_ctrl_test_value(u64 value)
>   {
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 4d1c44622056..26bad600f9fa 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -726,6 +726,10 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
>   }
>   #endif
>   
> +#ifdef CONFIG_KVM_GUEST_MEMFD
> +bool kvm_arch_supports_gmem_mmap(struct kvm *kvm);
> +#endif
> +
>   #ifndef kvm_arch_has_readonly_mem
>   static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
>   {
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index a99e11b8b77f..67e7cd7210ef 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -312,7 +312,72 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
>   	return gfn - slot->base_gfn + slot->gmem.pgoff;
>   }
>   
> +static bool kvm_gmem_supports_mmap(struct inode *inode)
> +{
> +	return false;
> +}
> +
> +static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
> +{
> +	struct inode *inode = file_inode(vmf->vma->vm_file);
> +	struct folio *folio;
> +	vm_fault_t ret = VM_FAULT_LOCKED;
> +
> +	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
> +		return VM_FAULT_SIGBUS;
> +
> +	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> +	if (IS_ERR(folio)) {
> +		int err = PTR_ERR(folio);
> +
> +		if (err == -EAGAIN)
> +			return VM_FAULT_RETRY;
> +
> +		return vmf_error(err);
> +	}
> +
> +	if (WARN_ON_ONCE(folio_test_large(folio))) {
> +		ret = VM_FAULT_SIGBUS;
> +		goto out_folio;
> +	}
> +
> +	if (!folio_test_uptodate(folio)) {
> +		clear_highpage(folio_page(folio, 0));
> +		kvm_gmem_mark_prepared(folio);
> +	}
> +
> +	vmf->page = folio_file_page(folio, vmf->pgoff);
> +
> +out_folio:
> +	if (ret != VM_FAULT_LOCKED) {
> +		folio_unlock(folio);
> +		folio_put(folio);
> +	}
> +
> +	return ret;
> +}
> +
> +static const struct vm_operations_struct kvm_gmem_vm_ops = {
> +	.fault = kvm_gmem_fault_user_mapping,
> +};
> +
> +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	if (!kvm_gmem_supports_mmap(file_inode(file)))
> +		return -ENODEV;
> +
> +	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
> +	    (VM_SHARED | VM_MAYSHARE)) {
> +		return -EINVAL;
> +	}
> +
> +	vma->vm_ops = &kvm_gmem_vm_ops;
> +
> +	return 0;
> +}
> +
>   static struct file_operations kvm_gmem_fops = {
> +	.mmap		= kvm_gmem_mmap,
>   	.open		= generic_file_open,
>   	.release	= kvm_gmem_release,
>   	.fallocate	= kvm_gmem_fallocate,
> @@ -391,6 +456,11 @@ static const struct inode_operations kvm_gmem_iops = {
>   	.setattr	= kvm_gmem_setattr,
>   };
>   
> +bool __weak kvm_arch_supports_gmem_mmap(struct kvm *kvm)
> +{
> +	return true;
> +}
> +
>   static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>   {
>   	const char *anon_name = "[kvm-gmem]";


