Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CD78C5516D
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 21:06:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 660DC6B008A; Thu, 30 Jul 2026 17:06:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63A886B008C; Thu, 30 Jul 2026 17:06:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 528BF6B0092; Thu, 30 Jul 2026 17:06:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 34F606B008A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 17:06:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D13271A02C0
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 21:06:19 +0000 (UTC)
X-FDA: 85046676078.17.6A3ECB4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 47ABB140009
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 21:06:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nSdf2zFL;
	spf=pass (imf26.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785445578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iWMaZxjO8tD0ZcRu+I0l+25lIoRL+ColSfS0S6Qr2kU=;
	b=6pkx/IKv71XNzuPL1wtoM0mZ6i0lmW28lqHrr9BVgNr+TPpfG8RqGwnYIfgQrx+QB+d0Q1
	NHK3BwkquVMt4xzAgToii7AOpL4lJ4JdMX86cBIN/lqEIsF/ijG9LgNey519BuFfSv9YK7
	ZoM8mtcYuLzi4W8u2lDg8pTXv3UZe+M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785445578;
	b=FQCrAsTfmFfXNECw2CbbPAvaiuDRl30CFzQnEAzEQ1SsXjdpZhBN54x5LJYpTreytIc6IK
	IuisGLqHVduo/V55V0VySu7qRTPOZPJYOJf7tzZulqEdVgzHzx7ytOQS7MglTU99ODvtgj
	Eg6CXmOUkjDcLlSkhmIrZd2wopZH+5c=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nSdf2zFL;
	spf=pass (imf26.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 613E16001D;
	Thu, 30 Jul 2026 21:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F7A1F000E9;
	Thu, 30 Jul 2026 21:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785445577;
	bh=iWMaZxjO8tD0ZcRu+I0l+25lIoRL+ColSfS0S6Qr2kU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nSdf2zFLgoIx0qAMk+q9BXZuO0D15ScYgxLruXAaDkOlFIehdcR5BeqVOjM9SLP8B
	 BMeIseD2abONOVlUDmNt43p4evq61r9mFdF5bmKDwQ/9UKc1F1gAuaXT+nBkGt2IkA
	 2vpTznUYafYmBJSnxAdABc17deveM9Wvekd/aZkoUXeF3kZ+WEQtLR3IEbRZGGqP9w
	 EOf/tbdATs0MYVtoUmpdJd6gbKxa/yZGcZR5m7pzXLjfjC5jB9zSCyECy6R5MU8RDe
	 3N85N0wPqYPYOk2UdLcbM6ysuqxevWQlAV/kW5jiCZ6XaejQzffgGbcbxuBfnEOyoY
	 mb3JNT3QB1uvw==
Date: Thu, 30 Jul 2026 21:06:14 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, 
	Thomas Gleixner <tglx@kernel.org>, Patrick Bellasi <derkling@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Sean Christopherson <seanjc@google.com>, 
	Nikita Kalyazin <nikita.kalyazin@linux.dev>
Subject: Re: [PATCH v3 03/26] mm: introduce AS_NO_DIRECT_MAP
Message-ID: <amu5v-e39GKpgFG4@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-3-6f5729aa9832@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726-page_alloc-unmapped-v3-3-6f5729aa9832@google.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 47ABB140009
X-Stat-Signature: rfufsmqrn4sxgzzgfyxojthp8j1npfcr
X-Rspam-User: 
X-HE-Tag: 1785445578-735014
X-HE-Meta: U2FsdGVkX1///jIyeERYrIHnuGpNYdr/9m5A1zumDndwDwi9Kv3q/uGob0f/nJChuKzlqmtdEgCVZjVQ7ex58I3SO2aQ6+nnhk1C03DHmZQzmlTKFVoQBxK2QRhv4wIkiLEpDyEdUkHbpzrxSRV8CfNU4/d4uizb6xodpsv5wDvib9GIcv77h1PAZfi2AnJxvTgm6FxaeDKgmc7mhqaVfs3zqpdY4IpfVocW8ybaEu6rxAbr+8+KlQYjg2goLX6cUVb9uKuYkFD+WxEEfSHivmWZudbBkCGmDcgXOrNk3BuoiLecdTA3RUAekZ4ydR1wng3LZOucoT2g5weXFpmWIvNPX5v7QG1q/I0EyhGwTJTB2ftx6izQ49Z440hA6ksxiNQGJQLFHp5YMmiB+MXybknTIJnVAhdTOlBAuEivrqqDJmKq7b1pHm+BbAIVVKA+mzD2WgYJDB7rrZ0BhfaryyrdXZFhUaXo3SCSHlFEIhU7cVHITh3e3eiiojd4aL6YrJUYMahHNbbYqazBV7pimGhbhCGh8JQF+A7Wt0C9btQSU1DRMNy26hmwtzVL738vLGtTp9DOcQh7yx8PJYd7S5t5qQpvBQlw5ILTVKBn/BZYUSBiWZXPMXjaM0Xs1xvNNkIm7wCRFLXvWPJB401JU+/s3DirAyGzupmhr2bck2BKUmEkURl9YoV5mWzHaicHzPVc0tpmHS1mwKlXgtj8p2i48Mkst9r5mWUg8g1wqTd7pA4rnZABc1vdWC1X6HB+BrQyL9YKKCP+ZznGNP7wX2DCe6nEp7/NHNOUuHkV0kEnZNbPnJJVfVB9NDtkyff/QuX/Czkj0UDHUp4BHuDpRa7cLWyJBS6E2T7zkhTD0FWKbev89ff/6zZyl/r7E74Qulqjdmh78/gUxpVS9l0s1aBqdpcFazWaVwXnhcSw4kdrCegFoipO1A3CbXsNw7mYo7DQ9S9HlbU9iwNNRVI
 tvBKdFBW
 RI+5U8x75zeS+aK0LgZM1Ln5vhGf9YboYQNMWt1yEJIlf3aElT6Z0FS2O6JSXXix+jeLAP15kUDi7roUe0E6wZWmHjPKVM1yesXPNG8aO1yQJtgj7p3mwLyDC5VhtDeKTOsxFOlSFM5OKyHy8X+ulEe91QuP1MmzcGnpr/vtyyTK+3mwt0Hr7riPIdsfkFUdXXJP+3DZpLdxFW1Is144KWbTHhr7FmZwWXwcr99KxKAa9xGPbnYVdat4vLji+DOtjjQXOZby/nJwcMnOJgwvCtl5ucEBQMK9lfBQ5pKSdp1LzjLV6uscXlin5NqHcB0U/5s9l9Ap5pBf/d1NhuLbKk1+mAkprf30yWD9r9WSwkDNILa8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 26, 2026 at 10:22:36PM +0000, Brendan Jackman wrote:
> From: Patrick Roy <patrick.roy@linux.dev>
> 
> Add AS_NO_DIRECT_MAP for mappings where direct map entries of folios are
> set to not present. Currently, mappings that match this description are
> secretmem mappings (memfd_secret()). Later, some guest_memfd
> configurations will also fall into this category.
> 
> Reject this new type of mappings in all locations that currently reject
> secretmem mappings, on the assumption that if secretmem mappings are
> rejected somewhere, it is precisely because of an inability to deal with
> folios without direct map entries, and then make memfd_secret() use
> AS_NO_DIRECT_MAP on its address_space to drop its special
> vma_is_secretmem()/secretmem_mapping() checks.

I don't think this is necessarily true. See below.

> Use a new flag instead of overloading AS_INACCESSIBLE (which is already
> set by guest_memfd) because not all guest_memfd mappings will end up
> being direct map removed (e.g. in pKVM setups, parts of guest_memfd that
> can be mapped to userspace should also be GUP-able, and generally not
> have restrictions on who can access it).
> 
> Signed-off-by: Patrick Roy <patrick.roy@linux.dev>
> Signed-off-by: Nikita Kalyazin <nikita.kalyazin@linux.dev>
> [Moved zapping to page cache; removed review tags]
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
[..]
> diff --git a/lib/buildid.c b/lib/buildid.c
> index c4b7376406215..ba79bf28f7e69 100644
> --- a/lib/buildid.c
> +++ b/lib/buildid.c
> @@ -47,6 +47,10 @@ static int freader_get_folio(struct freader *r, loff_t file_off)
>  
>  	freader_put_folio(r);
>  
> +	/* reject folios without direct map entries (e.g. from memfd_secret() or guest_memfd()) */
> +	if (mapping_no_direct_map(r->file->f_mapping))
> +		return -EFAULT;
> +

The plan is to eventually have ~all user have no direct map in ASI page
tables, right? I assume this would then be problematic as paths like
this one will want to create an ephemeral mapping to access memory
rather than just fail.

Is the plan to have a separate check for ASI mappings that are present
in the unrestricted/non-sensitive address space?

>  	/* only use page cache lookup - fail if not already cached */
>  	r->folio = filemap_get_folio(r->file->f_mapping, file_off >> PAGE_SHIFT);
>  
> @@ -87,8 +91,8 @@ const void *freader_fetch(struct freader *r, loff_t file_off, size_t sz)
>  		return r->data + file_off;
>  	}
>  
> -	/* reject secretmem folios created with memfd_secret() */
> -	if (secretmem_mapping(r->file->f_mapping)) {
> +	/* reject folios without direct map entries (e.g. from memfd_secret() or guest_memfd()) */
> +	if (mapping_no_direct_map(r->file->f_mapping)) {
>  		r->err = -EFAULT;
>  		return NULL;
>  	}
[..]
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -11,7 +11,6 @@
>  #include <linux/rmap.h>
>  #include <linux/swap.h>
>  #include <linux/swapops.h>
> -#include <linux/secretmem.h>
>  
>  #include <linux/sched/signal.h>
>  #include <linux/rwsem.h>
> @@ -1216,7 +1215,7 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
>  	if ((gup_flags & FOLL_SPLIT_PMD) && is_vm_hugetlb_page(vma))
>  		return -EOPNOTSUPP;
>  
> -	if (vma_is_secretmem(vma))
> +	if (vma_has_no_direct_map(vma))

Same here, and for GUP in general. For example, KVM uses kvm_vcpu_map()
to map guest memory and access it (e.g. when running nested
virtualization), which uses GUP under the hood AFAICT. So KVM will want
GUP to succeed, and probably create an ephemeral mapping as well.

Maybe eventually we will want a GUP flag to handle creating an ephemeral
mapping, as I imagine multiple GUP users will run into the same issue?

Not sure if this is an ASI-specific issue, or if we also have use cases
where we need GUP to work guest_memfd pages (with ephemeral mappings).

>  		return -EFAULT;
>  
>  	if (write) {
> @@ -2731,7 +2730,7 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
>   * This call assumes the caller has pinned the folio, that the lowest page table
>   * level still points to this folio, and that interrupts have been disabled.
>   *
> - * GUP-fast must reject all secretmem folios.
> + * GUP-fast must reject all folios without direct map entries (such as secretmem).
>   *
>   * Writing to pinned file-backed dirty tracked folios is inherently problematic
>   * (see comment describing the writable_file_mapping_allowed() function). We
> @@ -2769,7 +2768,7 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>  	if (WARN_ON_ONCE(folio_test_slab(folio)))
>  		return false;
>  
> -	/* hugetlb neither requires dirty-tracking nor can be secretmem. */
> +	/* hugetlb neither requires dirty-tracking nor can be without direct map. */
>  	if (folio_test_hugetlb(folio))
>  		return true;
>  
> @@ -2812,7 +2811,7 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>  	 * At this point, we know the mapping is non-null and points to an
>  	 * address_space object.
>  	 */
> -	if (check_secretmem && secretmem_mapping(mapping))
> +	if (mapping_no_direct_map(mapping))
>  		return false;
>  	/* The only remaining allowed file system is shmem. */
>  	return !reject_file_backed || shmem_mapping(mapping);
> diff --git a/mm/mlock.c b/mm/mlock.c
> index efa6716e4dfbd..045b6779440b1 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -474,7 +474,7 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  	int ret = 0;
>  
>  	if (vma_flags_same_pair(&old_vma_flags, new_vma_flags) ||
> -	    vma_is_secretmem(vma) || !vma_supports_mlock(vma)) {
> +	    vma_has_no_direct_map(vma) || !vma_supports_mlock(vma)) {

I don't think this one is correct. From commit 1507f51255c9 ("mm:
introduce memfd_secret system call to create "secret" memory areas"):

  Since the secretmem mappings are locked in memory they cannot exceed
  RLIMIT_MEMLOCK.  Since these mappings are already locked independently
  from mlock(), an attempt to mlock()/munlock() secretmem range would
  fail and mlockall()/munlockall() will ignore secretmem mappings.

Seems like secretmem pages are just mlock()'d by default, hence the
check here. Maybe this also works for guest_memfd, but I don't think
it's a generalization that any pages without a direct mapping should
receive the same treatment here.

I am aware that perhaps the answer for most these cases is that it works
for guest_memfd as well as secretmem, but since the main goal of the
series is setting up ASI, ideally we don't want checks that we know
will become wrong when ASI is introduced. If the idea is that
mapping_no_direct_map() and vma_has_no_direct_map() will not be used for
ASI sensitive mappings, we should document this somewhere, or have
better localized checks (if at all possible) so that we can side-step
the whole mixup when ASI mappings come along.

>  		/*
>  		 * Don't set VMA_LOCKED_BIT or VMA_LOCKONFAULT_BIT and don't
>  		 * count.  For secretmem, don't allow the memory to be unlocked.
> diff --git a/mm/secretmem.c b/mm/secretmem.c
> index 4a4934769f8ba..c043c53687d95 100644
> --- a/mm/secretmem.c
> +++ b/mm/secretmem.c
> @@ -52,49 +52,20 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
>  	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
>  	struct inode *inode = file_inode(vmf->vma->vm_file);
>  	pgoff_t offset = vmf->pgoff;
> -	gfp_t gfp = vmf->gfp_mask;
>  	struct folio *folio;
>  	vm_fault_t ret;
> -	int err;
>  
>  	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
>  		return vmf_error(-EINVAL);
>  
>  	filemap_invalidate_lock_shared(mapping);
>  
> -retry:
> -	folio = filemap_lock_folio(mapping, offset);
> +	folio = filemap_grab_folio(mapping, offset);
>  	if (IS_ERR(folio)) {
> -		folio = folio_alloc(gfp | __GFP_ZERO, 0);
> -		if (!folio) {
> -			ret = VM_FAULT_OOM;
> -			goto out;
> -		}
> -
> -		err = folio_zap_direct_map(folio);
> -		if (err) {
> -			folio_put(folio);
> -			ret = vmf_error(err);
> -			goto out;
> -		}
> -
> -		__folio_mark_uptodate(folio);
> -		err = filemap_add_folio(mapping, folio, offset, gfp);
> -		if (unlikely(err)) {
> -			/*
> -			 * If a split of large page was required, it
> -			 * already happened when we marked the page invalid
> -			 * which guarantees that this call won't fail
> -			 */
> -			folio_restore_direct_map(folio);
> -			folio_put(folio);
> -			if (err == -EEXIST)
> -				goto retry;
> -
> -			ret = vmf_error(err);
> -			goto out;
> -		}
> +		ret = vmf_error(PTR_ERR(folio));
> +		goto out;
>  	}
> +	folio_mark_uptodate(folio);

This chunk seems like pure refactoring that should be done separately?

