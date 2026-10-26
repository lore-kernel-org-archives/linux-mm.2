Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98EFD606A320
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 14:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IxP+N3i/
Received: by kanga.kvack.org (Postfix)
	id B93966B05B3; Mon, 26 Oct 2026 10:27:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1CCA6B05B4; Mon, 26 Oct 2026 10:27:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E4AE6B05B5; Mon, 26 Oct 2026 10:27:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 785D26B05B3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:27:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 11B5A1A071C
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:27:30 +0000 (UTC)
X-FDA: 85365005460.27.1934677
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5D036140008
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:27:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IxP+N3i/";
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793024848;
	b=4w5QtdQqyyJwWMeELWdDh4QiaIzBmjlw6LK+iJmNGKXppFHtd2fBDBImKON2+Nq6tGaYrW
	KNzg2zF8c8uTYRYSJFxC+0v83LmKONS9doJMhl8g5RSydgbxFHZLyuMtZP3kvohiS2uAF2
	PdXPIcqAfnFKFe0yAISEzVV1krKDlxg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IxP+N3i/";
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793024848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6gmCDvdn2nsesgNhAh+epn0sztNU7HD2eJkAnfX6dkM=;
	b=MF7/vmTKVqcOQmQZ4RGEA2tk72feNaqCrzMXl1kPLyaJv3GJCCt/J/n5j/1eemkfsihuLb
	JUT4CXts400ckv61VChMOzy4IFNATttsLX0sq/VQRLYdWadcFuuZp8eDjeGc3pgoKCNZvO
	/CnIQKJi/iS9boUx9opsejoB3MjFUbw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9744C41E5C;
	Mon, 26 Oct 2026 14:27:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B491F01825;
	Mon, 26 Oct 2026 14:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793024847;
	bh=6gmCDvdn2nsesgNhAh+epn0sztNU7HD2eJkAnfX6dkM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IxP+N3i/n2LONGGX+afxhWlsWhOTpuuACZjEFunZuKXhHM/2qN4hqqU64faaUXtI2
	 b92CvQVadIqScamGEi3o9eCIrTfxGrFzZlCrrDKgiAtx3T5/tzM1rR5eMIeW2po5Pa
	 urKkl72EYR0eQoR0RdsG8tBvJ4Ol1kKz+lj5Dtmb6mncXA0dTNhWibCCxMDWCYHhEm
	 JjcPAXaw3eOLZGJ+tQaXLV+RTDRlHI3bdmuftngAJbZneOyCTJ7Qf7FQ5aTrFkvkd/
	 ctTKXd5FH7EQpXUMrcra1UQ+oWmBwBaVAaQqPbqfNg2IdzzJuTG8DG5krtiJ1R7e/r
	 RmLfgQDjpJKJg==
Date: Mon, 26 Oct 2026 14:27:16 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, xu.xin@linux.dev, 
	chengming.zhou@linux.dev, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, jglisse@redhat.com, aarcange@redhat.com, 
	peterx@redhat.com, kas@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	bobbypowers@gmail.com, bgeffon@google.com, dplotnikov@virtuozzo.com, 
	dgilbert@redhat.com, hughd@google.com, hannes@cmpxchg.org, kirill@shutemov.name, 
	cracauer@cons.org, mcfadden8@llnl.gov, gokhale2@llnl.gov, mgorman@suse.de, 
	mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@openvz.org, riel@redhat.com, 
	shli@fb.com, jthoughton@google.com, corbet@lwn.net, pbonzini@redhat.com, 
	seanjc@google.com, sj@kernel.org, ziy@nvidia.com, stable@vger.kernel.org, 
	samarth.colleges@gmail.com, med08elkadiri@gmail.com
Subject: Re: [PATCH] mm/ksm: fix userfaultfd protection during merge and
 unmerge
Message-ID: <at9d4XJUIM8SgBDs@gremlin>
References: <20261026130054.91461-1-lance.yang@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026130054.91461-1-lance.yang@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D036140008
X-Stat-Signature: r1jd7oxsksuzmiiupmpdzafsdyyhhc8d
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793024848-791857
X-HE-Meta: U2FsdGVkX19MVyEr5YAPea93Gn7nBf3cH0udDRclM4+sYuP/fBsC105uGYFKPupvLRd4BK2bMarFbjcswcFBcJMti2l4ypa9kBl/2lptx10jeDSrgATIIOCqIyD7ozc51XMUyejc0paUfjNYThbfnf/YpbY/h4H1Yha7vTyok4F6qHx5yvVh8N/UUZw/HI3+ivwU1+BNu0EoTaobkf7amzrKbPAk1ArQdLLGPDScgHzZN42EPN4OhnHNcZQL6Gb1dG89Svh+Em6X7LknqjI8r5d6WkeZMLF9OD9ogB+cxS0CluMtJ5N5xFcxDklRHHvWEx3i10s3yVSj2JeIqohq3YT+IhYEaUk1CYe52AT25Je4ZbR7d0LENbeCLcRqx6ZvPpRiA7/2wEOlH2g1shAsXcES904UR5K6bcb9UUnycR1FHVO9+Wn4iZGEk5swI7SbZOtYZ70W3BVmcqdkEKTc5t1QYZf5w5oa51x7aQncne+aq+FpzLB2zNE8sOo9TLR5vHBt8TbF5jBBDpp2cyReaeITBfnrpc9clQU1pog7ug3mnpKAFhRZ0L/CWS9RSmEJ3QAUIVe2h5SjIXYLqR5xH7LrIHL0da6AbeBbt1rTveMSrFlgAM2xFTZ1UJbYwbb7+Nk7M0NWIlaQ5NTZvLS45FFMTsjVckObpqeKtcjzgcF7N5mWqWQgkkGyUmEi1HLIAW0eW1Io3ITa0JLlz12s5RnI1smkw+QMuiDuTvjHbUauCC1sNz629Ul9is3q21ZPppvcORmeJpEDOPHdZ2+ouatdTzN6IbPKfrlEgpsFbZ/KRp33FH1h2sliIETGFZBVOrYAtINtMEm8OnKsJotKRn/T/ou3ZlyPx53gtQtgfFcDUlb+y8fosXvy342Xcb0QSIR/7oGLDAEYH65hWZmC9LQpgldcQXROzTvGMWN2+E41h6PEC8itxslR6/T6lyQd/iH42odUoMMkZ3hRFvw
 V4xoI2A6
 R79BRgHzqz1SKT/2/wyKEINGeUSKx6nKTHT/doFYVcFaxyFeK8DmA7VC34UBH/8FX7+X+/4pLI+1tlJPLYsJYSdFiAEc0zFPDKETyHpmAXzIhkEo7Mcsl8n6uN7TONB6PNYgxKXxvDhssjdtYxhrXNrAdWqeoFQijN7kjwY3T4vq4IHLBY9cSZEC73+NoADQ16vDcPNtJ8qNyRApstvakA8a6p8nQIVFYqfMnVqAHkY+vPhItNmihvQbdrIlG5FFCHYLPjkhF7iLuMgJXAJZB2tkW0O2hcDK6jLxkfc61rxQ2g0TP5q7gk+IJ4H7gyIQhjwuls2Kiwo9dCKpIFFqughEFtfL7k5SjZfXuoOoXr8t54PfjyizVOTclFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 09:00:54PM +0800, Lance Yang wrote:
> KSM loses userfaultfd protection when replace_page() builds a new PTE
> from vma->vm_page_prot. Dropping its uffd bit lets a subsequent write go
> through ordinary COW instead of userfaultfd write protection handling. For
> RWP, a merged page also becomes readable without faulting.

I feel we probably shouldn't have allowed an extension to UFFD while it's still
fundamentally a broken feature :))

Which is evidenced by the SLEW of AI bug reports, and human-reported bug
reports, and endless history of bug reports and it infecting the rest of mm,
etc. etc. /rant

>
> Keeping the uffd bit and restoring PAGE_NONE fixes merging, but we also
> have to handle unmerging. An existing KSM page can be protected with RWP
> before MADV_UNMERGEABLE, so unmerging already needs fixing independently
> of preserving RWP during merging.
>
> Unsharing replaces a shared page with a private one and should leave
> userfaultfd protection in place, as do_wp_page() already does for write
> protection. Currently, an unshare fault reaches do_uffd_rwp() before it
> can proceed to do_wp_page().
>
> - With synchronous RWP, handle_userfault() returns VM_FAULT_SIGBUS.
>   break_ksm() then reports success with a KSM page still merged.
>
> - With asynchronous RWP, protection is cleared before unsharing.
>
> Preserve the uffd bit when merging, and restore PAGE_NONE for RWP. Let
> FAULT_FLAG_UNSHARE skip RWP fault handling and keep PAGE_NONE on each
> private copy as well. Unsharing can then complete with RWP still armed
> for a subsequent access.
>
> Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
> Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")
> Link: https://lore.kernel.org/all/20261019010934.697895-1-samarth.colleges@gmail.com/
> Link: https://lore.kernel.org/all/20261020055518.36087-1-lance.yang@linux.dev/
> Cc: stable@vger.kernel.org
> Co-developed-by: Samarth Narang <samarth.colleges@gmail.com>
> Signed-off-by: Samarth Narang <samarth.colleges@gmail.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>

Looks sensible to me so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/ksm.c    |  8 +++++++-
>  mm/memory.c | 14 ++++++++++----
>  2 files changed, 17 insertions(+), 5 deletions(-)
>
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 910a1307ac9f..d6f736a1aa2f 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -34,6 +34,7 @@
>  #include <linux/memory.h>
>  #include <linux/mmu_notifier.h>
>  #include <linux/swap.h>
> +#include <linux/userfaultfd_k.h>
>  #include <linux/ksm.h>
>  #include <linux/hashtable.h>
>  #include <linux/freezer.h>
> @@ -1463,9 +1464,14 @@ static int replace_page(struct vm_area_struct *vma, struct page *page,
>  		dec_mm_counter(mm, MM_ANONPAGES);
>  	}
>
> -	/* Preserve soft-dirty when replacing the page. */
> +	/* Preserve soft-dirty and uffd protection when replacing the page. */
>  	if (pte_soft_dirty(orig_pte))
>  		newpte = pte_mksoft_dirty(newpte);
> +	if (pte_uffd(orig_pte)) {
> +		newpte = pte_mkuffd(newpte);
> +		if (userfaultfd_rwp(vma))
> +			newpte = pte_modify(newpte, PAGE_NONE);

OK, so by definition, RWP pages are protnone, and this resets it correctly.

> +	}
>
>  	flush_cache_page(vma, addr, pte_pfn(ptep_get(ptep)));
>  	/*
> diff --git a/mm/memory.c b/mm/memory.c
> index 6a93b7fa48b2..99439a7afa63 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4122,8 +4122,11 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
>  		if (unlikely(unshare)) {
>  			if (pte_soft_dirty(vmf->orig_pte))
>  				entry = pte_mksoft_dirty(entry);
> -			if (pte_uffd(vmf->orig_pte))
> +			if (pte_uffd(vmf->orig_pte)) {
>  				entry = pte_mkuffd(entry);
> +				if (userfaultfd_rwp(vma))
> +					entry = pte_modify(entry, PAGE_NONE);
> +			}

Could this be abstracted? You're doing the same pattern here, which also exists
in copy_present_page() and presumably many other places.

But maybe that's one for a follow up?

>  		} else {
>  			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
>  		}
> @@ -6659,9 +6662,12 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
>  		 * VM_UFFD_RWP VMA, a protnone PTE without the uffd bit is
>  		 * NUMA hinting and must still fall through to do_numa_page().
>  		 */
> -		if (userfaultfd_pte_rwp(vmf->vma, vmf->orig_pte))
> -			return do_uffd_rwp(vmf);
> -		return do_numa_page(vmf);
> +		if (userfaultfd_pte_rwp(vmf->vma, vmf->orig_pte)) {
> +			if (!(vmf->flags & FAULT_FLAG_UNSHARE))
> +				return do_uffd_rwp(vmf);
> +		} else {
> +			return do_numa_page(vmf);
> +		}
>  	}
>
>  	spin_lock(vmf->ptl);
> --
> 2.49.0
>

--
Cheers, Lorenzo

