Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12CEFC43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 23:38:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C01BD6B00A2; Sat,  4 Jul 2026 19:38:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB0B36B00A4; Sat,  4 Jul 2026 19:38:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9F5A6B00A5; Sat,  4 Jul 2026 19:38:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 709D46B00A2
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 19:38:49 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D311F120582
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 23:38:48 +0000 (UTC)
X-FDA: 84952711536.17.16E79F1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 971AA160002
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 23:38:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CQASIfnk;
	spf=pass (imf08.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783208327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EWIYtnBsq4F7rpYo/ZX9uPSge+40dvarvTul1OYBIWo=;
	b=z/cMTKOlMzQ0DendQjPGRRWuazoA6liJt/QtjzdKApr+5WgJEr6R/2PAL9TYdQFyWIB040
	diB+iXyGLWH7xKf+oItWU9ZryP62O5I4jpMhby+vwqjUiHyAMpNLfjiDdsOYanUT/EzxM/
	s908HXUmNxekzrUzYWrIB8LuYCOWR+o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783208327;
	b=BuimB/8DTzvBUXQMbTJXbehTXYuUV/fOSedRwA6F7JJ8JpDsga/9H2Lu16P3JVM3Sp9w/r
	8Y15vpIp4neIqwiTvhdx+2yhSqDmq9xJBkjV0afjeCZB+VjnTxKgT1I3gK58tYmfcQH/aa
	wPEzoRn1cAh5tO7sUAOKzEZIvO1r1w4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CQASIfnk;
	spf=pass (imf08.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CEFB91CE2;
	Sat,  4 Jul 2026 16:38:35 -0700 (PDT)
Received: from [10.57.39.250] (unknown [10.57.39.250])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3B68F3F85F;
	Sat,  4 Jul 2026 16:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783208319; bh=s8K7gocsWH9rX7pANzHxIK07Z+WF9Hm5c4sGgOuC5gs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CQASIfnktKJ+nJBsa+sb+UUp/whO7qPhCX8lvNLWNHjZbzL0OZNmp18ACbtwf78sq
	 5BQyc2Gvo4iMWs88e7iwAVmUzNwMDDnMKDS5JXpoQMiHp1m54keQESKtrPapIShSsS
	 Y/fCh+eY83Tx1TDwgjWsfX8tgU4pzalslz35LonA=
Message-ID: <114e2488-97ed-4740-a8e8-1edd991f26c5@arm.com>
Date: Sun, 5 Jul 2026 00:38:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 13/46] KVM: guest_memfd: Add base support for
 KVM_SET_MEMORY_ATTRIBUTES2
Content-Language: en-GB
To: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 david@kernel.org, jmattson@google.com, jthoughton@google.com,
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com,
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com,
 shivankg@amd.com, steven.price@arm.com, tabba@google.com,
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com,
 forkloop@google.com, pratyush@kernel.org, aneesh.kumar@kernel.org,
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-13-9d2959357853@google.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-13-9d2959357853@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 971AA160002
X-Stat-Signature: idy8sopai7qunowoxkc9wsbj5j5gz9uk
X-HE-Tag: 1783208326-292891
X-HE-Meta: U2FsdGVkX1/348aj2o9djnswkhQ0kbtLKWM0FQLyEv7vEA4riDb1mpj3I2l7hduQoD0ct33vlkfF8mqHs94uD95DINkZgklN+lV8g/2yrJKR1ZN/4rWg9/EcpBSBy7pjwIyQf2Fuvu+dpc8cRoggLFuGAfkk1sWQN9zz/5hYu7CeAio7IEIRzMrjIpu29p3YISxVaCgfsPgRxiSS4uiouYOsoL2qxnfp6V9THUcdxWWrx8AWjEZd2OBLDOrl6N4ttwGLsBw9QP7SqoxyjG4xMe39hB4pExTyTtmpYXBrjhwh6NV4H2HBwW4lvckBnhS8KT4aeDDgOTrqp1VJHYxS2Rq3ezmDBKfsJDRJy927uQOsy1JcjbC8TC2IwDSy+QgcznCZ8UpInbd/15JUviXvlXIWETEWrARoMSo7tFT9CiCk3HVDJNVqHK+RQOv6NbyafFA48VEPEtMq6kBKiG4j4/38spTDZeDq8wX8ESYzOKe3HFcObQu7dthXhS0GHloKZDKDOHhfTZvZCJ7OxqJ4wOYmu8672AtortknpCGZkiI8sMX+FaD47plImhEkcFRRMZCd/lp5P388Prd4w7m3YuCK2U/fwmeEpA6UCsCQr9bc27ibO9o3a2ZVKRT/kIxRs4gz6jlvgjP2LjoY5tadrcWPqgGWwshMOYJX2Lc6EatipttEYCnhtrTcW9dU4N69AiBdPu7rWH50glVep/t7ZbOTUuakYFBDdFGsvb8ue4CRoX7vhrVFrtR8zZY4OOW8Si7ee0gSFhbb0I1lGoGzIkGB6bo1V6TGtoDasKSIHutN5LnDD3xmC5igZD8PKpjbkFiZWfycNwyEfw2txkntz6utsNU7bSM8ff306TtDdUa/M+Uz7Bt17Z4kM/lfHDjhle4wF4giA1s3QLa7M303canKF7eV8Vc4AhZMGspzmCxkQHBFSSik4DCgqirGl8sgcyHwolgbMvoa9Ietvmg
 on2BnWjD
 tee/apqepZ4uginn2MuiH2QouOtrf9vOdgzpAPBL6PPsENJDT25zCwkdiugGar5LZtyIVQyuvTcd4CvzWzbCIzF+dBaC+BPeOwwhU4OZktxoIca+zWyLhSeeBqkw+bDQkH6zwj4m+oC07o35iA1EqRoDTBZFlY4Iwkm/z8v/0QkTN7RRWBHCkRrt946Sym3fTNca56r+FoLPtvUdhC9tFPgJ3Y9OaBk4xV9tZQ3tgucjQmi0SzK6L6PVMQAdg6ShnsbkHHlSEYKPvMRA9jACC5BcE+PXylIiTo7mv2aetZ2y8YiURcIyNXSLJrhQsHc8MinC+j8ib2sk1oRE+q10b41O2O0xYy5cgHdkpyOTi6MUBJELJMZi74mu6LvEH2yqROP6hQgbftkRuemc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi

On 19/06/2026 01:31, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Introduce base support for KVM_SET_MEMORY_ATTRIBUTES2 in guest_memfd, which
> just updates attributes tracked by guest_memfd.
> 
> Validate input fields in general. Guard usage of KVM_SET_MEMORY_ATTRIBUTES2
> by making sure requested attributes are supported for this instance of kvm.
> 
> A new KVM_SET_MEMORY_ATTRIBUTES2 is defined to support writes (unlike
> KVM_SET_MEMORY_ATTRIBUTES) in addition to reads so it can provide error
> details to userspace. This will be used in a later patch.
> 
> The two ioctls use their corresponding structs with no overlap, but
> backward compatibility is baked in for future support of
> KVM_SET_MEMORY_ATTRIBUTES2 and struct kvm_memory_attributes2 in the VM
> ioctl.
> 
> The process of setting memory attributes is set up such that the later half
> will not fail due to allocation. Any necessary checks are performed before
> the point of no return.
> 
> Co-developed-by: Vishal Annapurve <vannapurve@google.com>
> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> Co-developed-by: Sean Christoperson <seanjc@google.com>
> Signed-off-by: Sean Christoperson <seanjc@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---

...


> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 65ce795c090d9..0d14548c1ed22 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -541,11 +541,127 @@ bool kvm_gmem_is_private(struct kvm *kvm, gfn_t gfn)

...

> +static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
> +				     size_t nr_pages, uint64_t attrs)
> +{
> +	struct address_space *mapping = inode->i_mapping;
> +	struct gmem_inode *gi = GMEM_I(inode);
> +	pgoff_t end = start + nr_pages;
> +	struct maple_tree *mt;
> +	struct ma_state mas;
> +	int r;
> +
> +	mt = &gi->attributes;
> +
> +	filemap_invalidate_lock(mapping);
> +
> +	mas_init(&mas, mt, start);
> +	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
> +	if (r)
> +		goto out;
> +
> +	/*
> +	 * From this point on guest_memfd has performed necessary
> +	 * checks and can proceed to do guest-breaking changes.
> +	 */
> +
> +	kvm_gmem_invalidate_start(inode, start, end);

I added support for Arm CCA KVM patches with the inplace conversion and
I am hitting the following issue.

1. I am supporting INIT_SHARED + MMAP flags.
2. VMM creates the Gmem_fd with both the flags above.
3. Uses the shared gmem-mmap to load the initial payloads (kernel, dtb).
4. At the VM finalization time, Populate the loaded regions one by one
    by
     a) copying the images to a temparory buffer - Since CCA can't really
        load the contents in-place.
     b) Set the "region" to Private in the gmem_fd (via 
SET_MEMORY_ATTRIBUTES2)
     c) Invoke CCA backend to populate the private memory via
        ioctl(KVM_ARM_RMI_POPULATE,..) [0]

[0] 
https://lore.kernel.org/all/20260513131757.116630-27-steven.price@arm.com/


5. Additionally, VMM can mark the entire RAM to be private before the VM
    starts running, again via SET_MEMORY_ATTRIBUTES2. On CCA, this 
action is measured and doesn't require the Host to "commit" memory to 
the VM.
Instead the host can lazily donate memory on a fault.

But step (5) triggers the invalidation of both private and shared
mappings of the gmem area, from the kvm_gmem_invalidate_start()
above.

This is because, the entire DRAM now has, some portions PRIVATE (the 
loaded regions) and the rest are SHARED (from the Gmem_fd creation).
  Thus, kvm_gmem_get_invalidate_filter(Dram_start, Dram_end) causes the 
invalidation of both "PRIVATE" and "SHARED" regions, which results
in the destruction of the already loaded data and things go south.

When we know that the kvm_gmem_invalidate_xx is triggered by a 
conversion, we don't need to invalidate the existing pages that
are in the requested state. i.e., the following patch on top of
this series does the trick for me :


diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index a97fcac34a0e..62e0427a49f4 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -250,16 +250,23 @@ static void __kvm_gmem_invalidate_start(struct 
gmem_file *f, pgoff_t start,
                 KVM_MMU_UNLOCK(kvm);
  }

+static void kvm_gmem_invalidate_start_filter(struct inode *inode, 
pgoff_t start,
+                                            pgoff_t end,
+                                            enum kvm_gfn_range_filter 
attr_filter)
+{
+       struct gmem_file *f;
+
+       kvm_gmem_for_each_file(f, inode)
+               __kvm_gmem_invalidate_start(f, start, end, attr_filter);
+}
+
  static void kvm_gmem_invalidate_start(struct inode *inode, pgoff_t start,
                                       pgoff_t end)
  {
         enum kvm_gfn_range_filter attr_filter;
-       struct gmem_file *f;
-
         attr_filter = kvm_gmem_get_invalidate_filter(inode, start, end);

-       kvm_gmem_for_each_file(f, inode)
-               __kvm_gmem_invalidate_start(f, start, end, attr_filter);
+       kvm_gmem_invalidate_start_filter(inode, start, end, attr_filter);
  }

  static void __kvm_gmem_invalidate_end(struct gmem_file *f, pgoff_t start,
@@ -724,9 +731,14 @@ static int __kvm_gmem_set_attributes(struct inode 
*inode, pgoff_t start,
         /*
          * From this point on guest_memfd has performed necessary
          * checks and can proceed to do guest-breaking changes.
+        * Also, we don't have to invalidate the regions that
+        * may already be in the requested state. Hence, we could
+        * explicitly filter the invalidations to the opposite
+        * state.
          */

-       kvm_gmem_invalidate_start(inode, start, end);
+       kvm_gmem_invalidate_start_filter(inode, start, end,
+                                       to_private ? KVM_FILTER_SHARED : 
KVM_FILTER_PRIVATE);

         if (!to_private)
                 kvm_gmem_invalidate(inode, start, end);


Thoughts ?

Suzuki


> +	mas_store_prealloc(&mas, xa_mk_value(attrs));
> +	kvm_gmem_invalidate_end(inode, start, end);
> +out:
> +	filemap_invalidate_unlock(mapping);
> +	return r;
> +}
> +
> +static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
> +{
> +	struct gmem_file *f = file->private_data;
> +	struct inode *inode = file_inode(file);
> +	struct kvm_memory_attributes2 attrs;
> +	size_t nr_pages;
> +	pgoff_t index;
> +	int i;
> +
> +	if (copy_from_user(&attrs, argp, sizeof(attrs)))
> +		return -EFAULT;
> +
> +	if (attrs.flags)
> +		return -EINVAL;
> +	for (i = 0; i < ARRAY_SIZE(attrs.reserved); i++) {
> +		if (attrs.reserved[i])
> +			return -EINVAL;
> +	}
> +	if (!kvm_arch_has_private_mem(f->kvm))
> +		return -EINVAL;
> +	if (attrs.attributes & ~KVM_MEMORY_ATTRIBUTE_PRIVATE)
> +		return -EINVAL;
> +	if (attrs.size == 0 || attrs.offset + attrs.size < attrs.offset)
> +		return -EINVAL;
> +	if (!PAGE_ALIGNED(attrs.offset) || !PAGE_ALIGNED(attrs.size))
> +		return -EINVAL;
> +
> +	if (attrs.offset >= i_size_read(inode) ||
> +	    attrs.offset + attrs.size > i_size_read(inode))
> +		return -EINVAL;
> +
> +	nr_pages = attrs.size >> PAGE_SHIFT;
> +	index = attrs.offset >> PAGE_SHIFT;
> +	return __kvm_gmem_set_attributes(inode, index, nr_pages,
> +					 attrs.attributes);
> +}
> +
> +static long kvm_gmem_ioctl(struct file *file, unsigned int ioctl,
> +			   unsigned long arg)
> +{
> +	switch (ioctl) {
> +	case KVM_SET_MEMORY_ATTRIBUTES2:
> +		if (!gmem_in_place_conversion)
> +			return -ENOTTY;
> +
> +		return kvm_gmem_set_attributes(file, (void __user *)arg);
> +	default:
> +		return -ENOTTY;
> +	}
> +}
> +
>   static struct file_operations kvm_gmem_fops = {
>   	.mmap		= kvm_gmem_mmap,
>   	.open		= generic_file_open,
>   	.release	= kvm_gmem_release,
>   	.fallocate	= kvm_gmem_fallocate,
> +	.unlocked_ioctl	= kvm_gmem_ioctl,
>   };
>   
>   static int kvm_gmem_migrate_folio(struct address_space *mapping,
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 01761f6e25d25..a08b518cdb175 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -105,6 +105,18 @@ module_param(allow_unsafe_mappings, bool, 0444);
>   bool __ro_after_init gmem_in_place_conversion = false;
>   #endif
>   
> +#define MEMORY_ATTRIBUTES_MATCH(one, two)				\
> +	static_assert(offsetof(struct kvm_memory_attributes, one) ==	\
> +		      offsetof(struct kvm_memory_attributes2, two));	\
> +	static_assert(sizeof_field(struct kvm_memory_attributes, one) ==\
> +		      sizeof_field(struct kvm_memory_attributes2, two))
> +
> +/* Ensure the common parts of the two structs are identical. */
> +MEMORY_ATTRIBUTES_MATCH(address, address);
> +MEMORY_ATTRIBUTES_MATCH(size, size);
> +MEMORY_ATTRIBUTES_MATCH(attributes, attributes);
> +MEMORY_ATTRIBUTES_MATCH(flags, flags);
> +
>   /*
>    * Ordering of locks:
>    *
> 


