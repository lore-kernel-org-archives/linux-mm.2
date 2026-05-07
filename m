Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12E2ACD342C
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 03:46:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F9ED6B0088; Wed,  6 May 2026 23:46:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4839F6B008A; Wed,  6 May 2026 23:46:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34B746B008C; Wed,  6 May 2026 23:46:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1ECC86B0088
	for <linux-mm@kvack.org>; Wed,  6 May 2026 23:46:48 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B9EF0A03B2
	for <linux-mm@kvack.org>; Thu,  7 May 2026 03:46:47 +0000 (UTC)
X-FDA: 84739237254.09.6913E3D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf18.hostedemail.com (Postfix) with ESMTP id DFC461C0003
	for <linux-mm@kvack.org>; Thu,  7 May 2026 03:46:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=aODkj6ZG;
	spf=none (imf18.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778125606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LFhQhkh41UePai+TD3hLFI5QjWkx+fFqVjyduNFwnjk=;
	b=jtqPnRPdnnE48zWV5zuU/NjREmnzrm442bT6YyOhQxPHorG3UpnaUJG0tN8ODVuqFvBVkt
	xL0d/QLwA+Tbu67fTxOqhTsjSg4s2RQ52/ynMtiz3Ol2WWiuZ0AsHFOUs4bZAJcPM7pJ9e
	4duJ8rABnc40HNeuC8labSFt6RanZMc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778125606; a=rsa-sha256;
	cv=none;
	b=Wf8gmIuLFkNb2kZxJ7fc92OBDykzk7ZUaj2ggM+KkHHm7j6nfkLMQgIKrnqRXtfltuTp5l
	rG5xqkltUTsn7L0Hd07AyFwx0M/Vh28eQQkg0mwXlKc6RdOIhgFSDQrjlFWepBUfa/UKQS
	sHHjUlZPeevdtpAB0p0oFjVKFlDRx24=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=aODkj6ZG;
	spf=none (imf18.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LFhQhkh41UePai+TD3hLFI5QjWkx+fFqVjyduNFwnjk=; b=aODkj6ZGpdU9IY0LeVaYF/frYm
	/DoQPAz37gHhg16BeWUko4CcjIQ5bMs198GG9t4zoGR8E244k4HrfRF+k1S3GqyivqRbLH2IL0Hnm
	0pcb6b5ElyCzPiko/s/xRyKmTc0x67HTBdLBNwzJOT2QkieLCKJNeNgHqxWF6e6Ky2FgNeNFESqk5
	pLge4I1B7HNF3hrw6SAcrdO9+r0o80YqrhIO31/tXJbChU6BaPbJA4zHmStpf7ngYYEqECoo+Dvpe
	+5+Lyv8DGXmSzvR56zkyHbAsHuApJTOBoTKeUhLnZw1Svjef38xyl3FYUn7WB8TcVBygW+dR5lTlu
	6LuBxKCA==;
Received: from [213.147.98.98] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wKpgm-00000002fOB-39IP;
	Thu, 07 May 2026 03:46:17 +0000
Date: Thu, 7 May 2026 05:46:04 +0200
From: "Liam R. Howlett" <liam@infradead.org>
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, steven.price@arm.com, 
	tabba@google.com, willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>, 
	Vishal Annapurve <vannapurve@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Subject: Re: [PATCH RFC v5 10/53] KVM: guest_memfd: Add basic support for
 KVM_SET_MEMORY_ATTRIBUTES2
Message-ID: <n5ce32wumzeiqqyqutom4apy2kqfetbvusc6j4k2xarsska5mw@klp5bmy7qhfm>
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
 <20260428-gmem-inplace-conversion-v5-10-d8608ccfca22@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428-gmem-inplace-conversion-v5-10-d8608ccfca22@google.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DFC461C0003
X-Stat-Signature: kxbxpyix16bbeps47xhtigumadr9w8t8
X-Rspam-User: 
X-HE-Tag: 1778125605-955264
X-HE-Meta: U2FsdGVkX18uA9UayoiNivmvyajFyj6P15LDUnAfv/JLwclvtnNpLjSUi1u7DxHvHKkwP6IwP1TttCEWbnC17nvCKGi6rjtYrtdQXScDNOP0zm06t5kqlrfBEGPSuGW+qv3H+46rNzRA8j+9gbnwckndetRGKw5y92bYrqXmUEhwM1t+28J0xyMI8mc2XlO62p3+kn3DJmGEwbmg/BnIT5rFLhx/QFQ2Okogm8DzEIfOyI6zWJioUuLkqqSAmdz6zw/jh9u2m43GfsqWt36p2deJ5W+VBQBtek69I24QM9l95eeIGicl+53jDLiSev6l0usEbKSN3PJ7X1WgksiumpXUNtYsmFk8u6BqfL7OntXjVqYrV3us5TpxqjqCOhl8hbwoO/JTsPcRaddhJW0rlPnckwVsY5bPov/TjbijtuKL4RrD9zVAnsITibnVyeGiLGuJaynfkjpfSw/jA1434ZjYfQNuS8UmExZgb7XxBdPv977gSJRTqaNhnqZzhBbsrLIHmyET5e0E+31fAd8+xA3tfEa46LcCyeqA1ZzAcK6PqNWODAsSecKR32hxTIJIl90Nxr+J656YakdcGadvPqKdW+7EzMpsYJvGPcaLBRpga6gmyyi9HWRFKUlE3OyzX9dxNakt7MJOMlmvKLs3xEciVGDE9pCNgnMfOI3R54UnSD8fgVyPVcPmfQ6vzm3ngPftBABs6uu9ZqaqVVhne27L27piqfA1UTQntgZ3oEiMeCye2u0dv834MPZC2qwOvizt1GoHFhXAgrA/AwbDMJiOZCk/fUd+Bz3osZgt3Ud4XTjswjy5vynlhvXfI19o+BwfxM8Auzy3Fm6pHZXMYlP2QEancz2cwC8vbAMmElX0W3QuK2zjVsCCcya9N979hvt9AfhRdL6IFHswNFWgwBhckDElFGt9GREMskwO/KoFT+Tl21OYdcsx/GT/NnWE30JC+wY56687t02okIt
 NZGnrZMl
 63++ZdkpSkyP3H1EPrWYNz+EEQwTTtsSEpNKIxor4f9xkWC0Z6VgRI2DavTGzKu88EBq9nSI7lsqndhHFCGh6fc4ZxxtbhIYaTvAH8XXg0dFr6jsbd3sP5MXaCoV+QfqzXnD3KSqi9qx5ibUyGAvTyatVvbY8volvYLLZxsdWWF0FlWTdMgWKOMfi6O8TOprC7hBZ6Fqm3ZHM07kqxmKbSqchuPUbZdubrSwtfcvHXw0OuHtMBOjHwm9qF7I11ET8lm67M7NQxsAbAZ/jmRVCLr89MzPPLgr0zBW4qjyrnGfMfVh/n+RP/3f41Zvg+dpz5lKSS8/u3BzVA9a15x3qi3ifPTxeJR0O4rMFYXHD44DfqPU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/04/28 04:25PM, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Introduce basic support for KVM_SET_MEMORY_ATTRIBUTES2 in guest_memfd,
> which just updates attributes tracked by guest_memfd.
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
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Co-developed-by: Vishal Annapurve <vannapurve@google.com>
> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> Co-developed-by: Sean Christoperson <seanjc@google.com>
> Signed-off-by: Sean Christoperson <seanjc@google.com>
> ---
>  include/uapi/linux/kvm.h |  13 ++++++
>  virt/kvm/Kconfig         |   1 +
>  virt/kvm/guest_memfd.c   | 114 +++++++++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c      |  12 +++++
>  4 files changed, 140 insertions(+)
> 
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 6c8afa2047bf3..e6bbf68a83813 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1648,6 +1648,19 @@ struct kvm_memory_attributes {
>  	__u64 flags;
>  };
>  
> +#define KVM_SET_MEMORY_ATTRIBUTES2              _IOWR(KVMIO,  0xd2, struct kvm_memory_attributes2)
> +
> +struct kvm_memory_attributes2 {
> +	union {
> +		__u64 address;
> +		__u64 offset;
> +	};
> +	__u64 size;
> +	__u64 attributes;
> +	__u64 flags;
> +	__u64 reserved[12];
> +};
> +
>  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
>  
>  #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 3fea89c45cfb4..e371e079e2c50 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -109,6 +109,7 @@ config KVM_VM_MEMORY_ATTRIBUTES
>  
>  config KVM_GUEST_MEMFD
>         select XARRAY_MULTI
> +       select KVM_MEMORY_ATTRIBUTES
>         bool
>  
>  config HAVE_KVM_ARCH_GMEM_PREPARE
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 506219e2359eb..9a26eca717047 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -552,11 +552,125 @@ unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
>  }
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_memory_attributes);
>  
> +/*
> + * Preallocate memory for attributes to be stored on a maple tree, pointed to
> + * by mas.  Adjacent ranges with attributes identical to the new attributes
> + * will be merged.  Also sets mas's bounds up for storing attributes.
> + *
> + * This maintains the invariant that ranges with the same attributes will
> + * always be merged.
> + */
> +static int kvm_gmem_mas_preallocate(struct ma_state *mas, u64 attributes,
> +				    pgoff_t start, size_t nr_pages)
> +{
> +	pgoff_t end = start + nr_pages;
> +	pgoff_t last = end - 1;
> +	void *entry;
> +
> +	/* Try extending range. entry is NULL on overflow/wrap-around. */
> +	mas_set_range(mas, end, end);
> +	entry = mas_find(mas, end);

Please read the documentation as I believe you have a bug here.  What
happens if there is another range stored higher than end + 1?

Do you have testing of these functions somewhere?

> +	if (entry && xa_to_value(entry) == attributes)
> +		last = mas->last;
> +
> +	if (start > 0) {
> +		mas_set_range(mas, start - 1, start - 1);
> +		entry = mas_find(mas, start - 1);
> +		if (entry && xa_to_value(entry) == attributes)
> +			start = mas->index;
> +	}
> +
> +	mas_set_range(mas, start, last);
> +	return mas_preallocate(mas, xa_mk_value(attributes), GFP_KERNEL);
> +}
> +
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
> +	kvm_gmem_invalidate_begin(inode, start, end);
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
> +	if (attrs.attributes & ~kvm_supported_mem_attributes(f->kvm))
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
> +		if (vm_memory_attributes)
> +			return -ENOTTY;
> +
> +		return kvm_gmem_set_attributes(file, (void __user *)arg);
> +	default:
> +		return -ENOTTY;
> +	}
> +}
> +
>  static struct file_operations kvm_gmem_fops = {
>  	.mmap		= kvm_gmem_mmap,
>  	.open		= generic_file_open,
>  	.release	= kvm_gmem_release,
>  	.fallocate	= kvm_gmem_fallocate,
> +	.unlocked_ioctl	= kvm_gmem_ioctl,
>  };
>  
>  static int kvm_gmem_migrate_folio(struct address_space *mapping,
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index ff20e63143642..4d7bf52b7b717 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -110,6 +110,18 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(STATIC_CALL_KEY(__kvm_get_memory_attributes));
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(STATIC_CALL_TRAMP(__kvm_get_memory_attributes));
>  #endif
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
>  /*
>   * Ordering of locks:
>   *
> 
> -- 
> 2.54.0.545.g6539524ca2-goog
> 
> 
> 

