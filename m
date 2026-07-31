Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C91D6C55173
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 19:28:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 791C36B0088; Fri, 31 Jul 2026 15:28:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 742556B008A; Fri, 31 Jul 2026 15:28:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67FBF6B008C; Fri, 31 Jul 2026 15:28:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3DA726B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 15:28:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AD1FB1A0121
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 19:28:05 +0000 (UTC)
X-FDA: 85050057330.16.9F80060
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 14D5BC0002
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 19:28:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eTDIwone;
	spf=pass (imf10.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785526084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DJcJcfSp8qFT3XBaz1dhInzTEmvps3KjtvVR2urkqlg=;
	b=6SKZY8fe0dXEcoPUuBYs/09ld8mjfY7hQrF78fYiRecE0xxtJRD6h+Fy+EVT4+iTnsotTY
	JGAy42WZ+rUulCBYa6ybWpQWo71iHYKn+35N7B9WhMVjuX1sLS0bXSCsNp5WfVtNjTjfcI
	40c4EBIyj4mY45tXI6QyfdWTnDqpGr0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eTDIwone;
	spf=pass (imf10.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785526084;
	b=i1ua9r1L8K8x5xBk9ksIgp70u5Xu8Fp+oQQLV/ZenTGq6lhEaxw5R6Cq13cCGYUzK02VTY
	E2JfM4ZrkdtB0hy/5ru3n7AgBbqPlRnIwESMAHApBu+ols7yufyZjogb25ZdsFoYsQcTs8
	cvl593bE7k06nLf9vAOySR6KC2ZaBrM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2BCC560A5D;
	Fri, 31 Jul 2026 19:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01641F00AC4;
	Fri, 31 Jul 2026 19:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785526082;
	bh=DJcJcfSp8qFT3XBaz1dhInzTEmvps3KjtvVR2urkqlg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eTDIwone+FUJc19+BJBx3DJ5lBw74iYtCWJ/DX2Y8Dkd4SlO+H+CSDNFXD8MKl0Ww
	 yzvUNvhH02URDNkaBw2cxcfTKnZ9RGt1gpJ0VedFapUogk8q3AECg0APVudQrlHFMH
	 47cmer8rNiqkrdtV8UPHNJHVJZdtxZfAyxoJFDYLrNCTrj38Pa3tLCb3YVy/OLpqDO
	 x/vA79EBRHD8JufXVt9loA1C4LWMMsaiA73NylAikqNiY9jkb0LPRyo8sSRaeuz8qQ
	 K2phP+OArfIIpxxPV2+l32a9DC/exLjO6l5LCiLmwDbhSH6AYFeB1pc4lCUxMYq8Gt
	 yN51+GjzCcFpg==
Date: Fri, 31 Jul 2026 19:28:00 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, rientjes@google.com, 
	patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, 
	Thomas Gleixner <tglx@kernel.org>, Patrick Bellasi <derkling@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Sean Christopherson <seanjc@google.com>, 
	Nikita Kalyazin <nikita.kalyazin@linux.dev>, Ackerley Tng <ackerleytng@google.com>
Subject: Re: [PATCH v3 03/26] mm: introduce AS_NO_DIRECT_MAP
Message-ID: <amz0jzVPZo_eBeRV@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-3-6f5729aa9832@google.com>
 <amu5v-e39GKpgFG4@google.com>
 <DKCQZ9JTKRIO.1K61106YF38GW@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DKCQZ9JTKRIO.1K61106YF38GW@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 14D5BC0002
X-Stat-Signature: 5qnrq8y4un1pdnpawmdmdr131gyc3oxy
X-HE-Tag: 1785526083-305273
X-HE-Meta: U2FsdGVkX19sOo9rrBij6wNt7cWFjjEjN/RT0OgK4gqlWHoSEJJCiLNGj+/KhKbotLk0f4+3hs20Ej+i9rvf/NoljM/Fgj6IhKY41G5jVLeabBYkunWTkreMYg0wTA/HdrT8wtk+NogUqjzhviuqgCJeqKrvtgJqG4mjNEvDImUYvc1KniZwOkeUq3eG0PBF8GTmljkVpfyKIz+fwcfbwBVRSWBkFy8RaMArCmvJD7Ao42ur1KPuPrr3nN4JO9SZeCWE/0PbzmXRzaW97u9XZ3do/+Kayyf7xnYq4KBAe9a7bAh3D9jYusE6JoeaGXAzbtvN6K1kwJvUeSXzQPPXbzlQlSQbMu/1T9VBYF/RmN1WoRbR3avELOF59nfVALconK5RWFxoo6x9iPKBkwQBzWPV2aNHyoXm57v23MVYDmF4tuIoQLVYXoL1M54BCO6wGnvjjOIhnLBYoyPI5cjlrJmz4Fu7teLEuupIPjR4+YJDWlHQbtTeiNuYRMbKwqSiQXz/GCiItAaz6RSxjA1dlBpzRul7mw3Dn8pAz/Px/OWrFO4Un+Uj9PSwD7bTd8pcUjSZ211RsCDuFX1jdga3XfRc7iOW2SVaRGCTe68vZV9734k8d4oSZQyzYq/CW5hBVReY2CBNYicEujyyNbqbBahyCpbU3iBHKugA2E+N2ceQK/1L35KJcFCRYN2tuN7Kujj2ZBePxWcAGRt2SJAt2MqTtLuMzdQ3+EsnlVtwgeaY2aVy6tywsQmSwFD1RR21lPuvM9dZ+KDOoDmxAwASq+SJZQPdB9kLyR0u9s/R82/sfhVDxrpnp7Qycahtw9meLLiADStijzCFS5rCygd9IRczDhnL1aIDvbR6ogawI3My2zqQOtJFHTR2fVxIgW+lxvBBWlHXxP09F7D8X91E9ACUPaSUuOEWfB7/o9ywIJDzLecfPabRg8vu0vHvZoMHg0qANie/Tq1Xes/pKp7
 q3hTX/6e
 RVPhVmNpFIUscjY5HkJ4bvDG7rXILU/Ak9gA+9mVgWmInRyuW5yreoALWGx7G+n4EbQDyaWH4aXx8sQQJsqa62Yghx8+a9s4SVhIHvx9/qPeRLmZFhYqiRLu3CbpJOBuuf50mavWOvIPNT2z5OMRzRXCQ30yNPIPUOWvUJCZXZxjI+TZ7U1aqcS9/pATazb33el3+SX2DyTodCjOzutP62w0asDDtjZsML3DIWjw9PbEq/5SJCGFBqXSMRU80YeHsOqQ3S4lwl01RctmsX74kE1xIsUe5V1mShbGHlxDifvcbSyd66liRcxm6LNCVD1JAOnYjm1pySQu2bFk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > [..]
> >> --- a/mm/gup.c
> >> +++ b/mm/gup.c
> >> @@ -11,7 +11,6 @@
> >>  #include <linux/rmap.h>
> >>  #include <linux/swap.h>
> >>  #include <linux/swapops.h>
> >> -#include <linux/secretmem.h>
> >>  
> >>  #include <linux/sched/signal.h>
> >>  #include <linux/rwsem.h>
> >> @@ -1216,7 +1215,7 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
> >>  	if ((gup_flags & FOLL_SPLIT_PMD) && is_vm_hugetlb_page(vma))
> >>  		return -EOPNOTSUPP;
> >>  
> >> -	if (vma_is_secretmem(vma))
> >> +	if (vma_has_no_direct_map(vma))
> >
> > Same here, and for GUP in general. For example, KVM uses kvm_vcpu_map()
> > to map guest memory and access it (e.g. when running nested
> > virtualization), which uses GUP under the hood AFAICT. So KVM will want
> > GUP to succeed, and probably create an ephemeral mapping as well.
> >
> > Maybe eventually we will want a GUP flag to handle creating an ephemeral
> > mapping, as I imagine multiple GUP users will run into the same issue?
> >
> > Not sure if this is an ASI-specific issue, or if we also have use cases
> > where we need GUP to work guest_memfd pages (with ephemeral mappings).
> 
> Similar to above, this shouldn't affect ASI at all.

But outside of ASI, aren't there any cases where the kernel (e.g. KVM)
needs to access guest_memfd memory?

Maybe Sean or David can help us out here.

> >>  		return -EFAULT;
> >>  
> >>  	if (write) {
> >> @@ -2731,7 +2730,7 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
> >>   * This call assumes the caller has pinned the folio, that the lowest page table
> >>   * level still points to this folio, and that interrupts have been disabled.
> >>   *
> >> - * GUP-fast must reject all secretmem folios.
> >> + * GUP-fast must reject all folios without direct map entries (such as secretmem).
> >>   *
> >>   * Writing to pinned file-backed dirty tracked folios is inherently problematic
> >>   * (see comment describing the writable_file_mapping_allowed() function). We
> >> @@ -2769,7 +2768,7 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
> >>  	if (WARN_ON_ONCE(folio_test_slab(folio)))
> >>  		return false;
> >>  
> >> -	/* hugetlb neither requires dirty-tracking nor can be secretmem. */
> >> +	/* hugetlb neither requires dirty-tracking nor can be without direct map. */

Is this necessarily true? I know there were discussions/proposals about
using some of the hugetlb infrastructure for guest_memfd. I am not sure
if those folios would remain hugetlb folios though.

Adding Ackerley here.

> >>  	if (folio_test_hugetlb(folio))
> >>  		return true;
> >>  
> >> @@ -2812,7 +2811,7 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
> >>  	 * At this point, we know the mapping is non-null and points to an
> >>  	 * address_space object.
> >>  	 */
> >> -	if (check_secretmem && secretmem_mapping(mapping))
> >> +	if (mapping_no_direct_map(mapping))
> >>  		return false;
> >>  	/* The only remaining allowed file system is shmem. */
> >>  	return !reject_file_backed || shmem_mapping(mapping);
> >> diff --git a/mm/mlock.c b/mm/mlock.c
> >> index efa6716e4dfbd..045b6779440b1 100644
> >> --- a/mm/mlock.c
> >> +++ b/mm/mlock.c
> >> @@ -474,7 +474,7 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
> >>  	int ret = 0;
> >>  
> >>  	if (vma_flags_same_pair(&old_vma_flags, new_vma_flags) ||
> >> -	    vma_is_secretmem(vma) || !vma_supports_mlock(vma)) {
> >> +	    vma_has_no_direct_map(vma) || !vma_supports_mlock(vma)) {
> >
> > I don't think this one is correct. From commit 1507f51255c9 ("mm:
> > introduce memfd_secret system call to create "secret" memory areas"):
> >
> >   Since the secretmem mappings are locked in memory they cannot exceed
> >   RLIMIT_MEMLOCK.  Since these mappings are already locked independently
> >   from mlock(), an attempt to mlock()/munlock() secretmem range would
> >   fail and mlockall()/munlockall() will ignore secretmem mappings.
> >
> > Seems like secretmem pages are just mlock()'d by default, hence the
> > check here. Maybe this also works for guest_memfd, but I don't think
> > it's a generalization that any pages without a direct mapping should
> > receive the same treatment here.
> 
> Ack, yeah this sounds correct to me.
> 
> I guess you could argue something like "the reason secretmem is
> implicitly mlocked is that it can't be reclaimed, because there's no
> direct map". But that doesn't generalise IMO, you could imagine letting
> the user say "remove this memory from the direct map, but I trust my
> swap system, you can swap it" and then use the mermap to implement
> reclaim.

Exactly, I don't think no direct mapping implicitly means unreclaimable.
I don't think you actually need a direct mapping to read/write from
disk to memory?

> 
> > I am aware that perhaps the answer for most these cases is that it works
> > for guest_memfd as well as secretmem, but since the main goal of the
> > series is setting up ASI, 
> 
> [Aside]
> 	Well, the main reason for Google to pay me for it is as a
> 	stepping stone for ASI, but I do actually think
> 	GUEST_MEMFD_FLAG_NO_DIRECT_MAP[0] is valuable and prefer to
> 	think of that as the "main goal" of this patchset. (I didn't
> 	include it here since Sean asked[1] for the KVM bits to be
> 	separate, but it's basically just a repeat of the secretmem.c
> 	changes).

Right, I understand this is the goal of the series and it is valuable
without ASI. Perhaps "motivation" was the correct word :)

> 
> 	[0] https://lore.kernel.org/all/20260410151746.61150-1-kalyazin@amazon.com/
> 	[1] https://lore.kernel.org/all/akw1lZDEv8_Ub1zQ@google.com/
> 
> > ideally we don't want checks that we know
> > will become wrong when ASI is introduced. If the idea is that
> > mapping_no_direct_map() and vma_has_no_direct_map() will not be used for
> > ASI sensitive mappings, 
> 
> (I said this above but just to be clear: that is not the idea).
> 
> > we should document this somewhere, or have
> > better localized checks (if at all possible) so that we can side-step
> > the whole mixup when ASI mappings come along.
> 
> BUT yes I still totally agree that we should not unnecessarily overload
> vma_has_no_direct_map() here.

Right, that was essentially what I meant. We shouldn't just current
secretmem checks with no direct map checks without thinking them
through.

> 
> >>  		/*
> >>  		 * Don't set VMA_LOCKED_BIT or VMA_LOCKONFAULT_BIT and don't
> >>  		 * count.  For secretmem, don't allow the memory to be unlocked.
> >> diff --git a/mm/secretmem.c b/mm/secretmem.c
> >> index 4a4934769f8ba..c043c53687d95 100644
> >> --- a/mm/secretmem.c
> >> +++ b/mm/secretmem.c
> >> @@ -52,49 +52,20 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
> >>  	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
> >>  	struct inode *inode = file_inode(vmf->vma->vm_file);
> >>  	pgoff_t offset = vmf->pgoff;
> >> -	gfp_t gfp = vmf->gfp_mask;
> >>  	struct folio *folio;
> >>  	vm_fault_t ret;
> >> -	int err;
> >>  
> >>  	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
> >>  		return vmf_error(-EINVAL);
> >>  
> >>  	filemap_invalidate_lock_shared(mapping);
> >>  
> >> -retry:
> >> -	folio = filemap_lock_folio(mapping, offset);
> >> +	folio = filemap_grab_folio(mapping, offset);
> >>  	if (IS_ERR(folio)) {
> >> -		folio = folio_alloc(gfp | __GFP_ZERO, 0);
> >> -		if (!folio) {
> >> -			ret = VM_FAULT_OOM;
> >> -			goto out;
> >> -		}
> >> -
> >> -		err = folio_zap_direct_map(folio);
> >> -		if (err) {
> >> -			folio_put(folio);
> >> -			ret = vmf_error(err);
> >> -			goto out;
> >> -		}
> >> -
> >> -		__folio_mark_uptodate(folio);
> >> -		err = filemap_add_folio(mapping, folio, offset, gfp);
> >> -		if (unlikely(err)) {
> >> -			/*
> >> -			 * If a split of large page was required, it
> >> -			 * already happened when we marked the page invalid
> >> -			 * which guarantees that this call won't fail
> >> -			 */
> >> -			folio_restore_direct_map(folio);
> >> -			folio_put(folio);
> >> -			if (err == -EEXIST)
> >> -				goto retry;
> >> -
> >> -			ret = vmf_error(err);
> >> -			goto out;
> >> -		}
> >> +		ret = vmf_error(PTR_ERR(folio));
> >> +		goto out;
> >>  	}
> >> +	folio_mark_uptodate(folio);
> >
> > This chunk seems like pure refactoring that should be done separately?
> 
> This is the adoption of AS_NO_DIRECT_MAP, i.e. the removal of the
> explicit folio_zap_direct_map() call. We could certainly separate out
> "create AS_NO_DIRECT_MAP" from "adopt it in secretmem" but the previous
> version of this patchset was on v12 and it hadn't split them so I assume
> nobody was calling for this split.

Oh sorry I wasn't clear. I meant switching from folio_lock_folio() and
the rest of the logic to folio_grab_folio(). There are some subtle
differences AFAICT so this conversion shouldn't really be part of this
patch.

I think maybe just drop the
folio_zap_direct_map()/folio_restore_direct_map() calls for this patch?

