Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CC55CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 12:57:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43E526B0099; Wed,  3 Jun 2026 08:57:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 416506B009B; Wed,  3 Jun 2026 08:57:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32C576B009D; Wed,  3 Jun 2026 08:57:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2254F6B0099
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:57:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B271D161C1A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:57:34 +0000 (UTC)
X-FDA: 84838602828.18.385C3C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1459E80004
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:57:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aD9Yx1lL;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780491453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dtMtYIOXYp6nZhFwb/fVgtiIgWg/t0b1ReYJZF7zT/A=;
	b=VEYoTpDujxU+onPWPusZVYaICPs8txts+bpNaqnjf54Idq+Ihi0jHn3q9hvYJYl1tiRegJ
	LgN2xYjYjyqzWTG7dj/O9YxdUjCyXHSRKqRCSkLmWhQbeRTw/Qpew42/MJd9NPuFh6AQPg
	nlrBuz6qZaYb59DHwqerWjy/rcbb6Wk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aD9Yx1lL;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780491453;
	b=KMtTvZH5NsdC+kkK3AMoke7I3z7Km6xKvykKLcJrUIYvhFyGi0UhaR5cqnG/wanydDUeM2
	RGnCQPbAiPxkAdoE44Tyrto+tLSD03dtBcAI72hAOj1zvzhRpC3dX2FauET80UHnjKDIT7
	oav+fB6cuFGO+uIj7pN7fcKqmkGSR18=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 935E760221;
	Wed,  3 Jun 2026 12:57:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D091F00893;
	Wed,  3 Jun 2026 12:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780491452;
	bh=dtMtYIOXYp6nZhFwb/fVgtiIgWg/t0b1ReYJZF7zT/A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aD9Yx1lLUyqm2rox24HF4tnMYIhzSk1E+1+H/BF42EIA38d7kdpLTBkAU7QY5yL1z
	 tSKVJf4LvPTt7nUCMN97oZg6kTtOFe8S3IocaJ+rqGSSMhcBhMhkDF/IfffFLi0FpV
	 R7hkzKLr5otOxmjNeEZl0ZvHi96o4q8fZYNm6ersWe6APcP71v9Zc0zRYLoz2z6mBN
	 exvP4Gu3sqUIVutv+UtTIjgdvgm0B2umqZ/3tbzZNHYl+y+1nbrb/u2eHWj9SUzbC6
	 3P+X+aXbGy7nJpO/pBAbOHKCBVdPoJGFx3Zy+I1BqVrZaF7/bSeC7n35pM2K9wyV1R
	 aQA/TOxz6IO5w==
Date: Wed, 3 Jun 2026 13:57:24 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, 
	david@kernel.org, surenb@google.com, vbabka@kernel.org, Liam.Howlett@oracle.com, 
	ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org, seanjc@google.com, 
	pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com, sj@kernel.org, 
	usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v6 08/15] mm: handle VM_UFFD_RWP in khugepaged, rmap, and
 GUP
Message-ID: <aiAkXF-x7374lZff@lucifer>
References: <20260529172716.357179-1-kas@kernel.org>
 <20260529172716.357179-9-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260529172716.357179-9-kas@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1459E80004
X-Stat-Signature: fqqbtas5zsyrwapaqjkjkxonfw3uespw
X-Rspam-User: 
X-HE-Tag: 1780491452-153903
X-HE-Meta: U2FsdGVkX18rPPzWAWqe3j5ST1x+Vft29IWqGR1X8NF/ryskQmYhfUdhVgFxJ/8qxHV5arW/Sub8mPoQu/I7wKUyZYSJY50ZCFPkSsN7wJgegpu6D3TVJqFsrKq0ebDmEI4RtVciLwPwUIhz8u2bLfzmcAsGYJTrRqGRZ8FiKXEuhrnlO7iE0uVtyeGnGEK+LCACdjPLA8CqRCO5dDFwguGDbvMSErqR1Xm2S4LjhjwBrChXFWfOjkxiyXri9OyOgO92M/Vb8UVCykZLv1vCKoM/emmXODiIlTIGaEbBsbCa2sCu82uz8xffYVBom9TRqSo3epjnKYdghV2xIbY/80D08Mf/4tJ5J/zNnzj+g6YWvQHxyQ+em7Rf8kePJ5Jd8MHTuTbYgFNbNHMJRuFUcTu/R2OTTMhexIAAwxPSbkC2/GClEtT5TFLSzgFtq4AJoNabmlt//7//qCLl7XxToiuoViPoX+znY2ubI8ZXR9jOgp2ANo0YLCHVuTjvJIPmCpawyUzxh3zVJ3ACvyUhozjUsYOJipli9Zyi3V2YLu0CfEDs7x7h2wkJD1bxRI64Zrov3M/JdvzK0VyevUNRJpLu7ysGlWXqjaxyUQ4O45oIr4+75APldOMXZDht9mf0/+8y2edjy4x2u4X3gsd7BNxKYa7/i+/210R4FAQoHInw15CuSeOnywlJpWgxFAZ8iGhWnc9WsSZG6gQnLGWQBYXpy0593Nl7TAIKx654/vFp3f4Yi7tCXDAIjLL4/+rHzU4RG2rjNy5k479zSwK5sJrc8p6s58ggZ3oh9GfCWJV4ApF9Vh0HtK48CX+5yfNQDeRJwS+IayMXTT2ogxYhrpVafHfbD5NngnllwLqHRE45IKwxs1x2d3gY52miDKbJ3FssJ5AMPoxg8Rm7T7C8zsy4v+iaYzt2b03qKEtXXzc29qKPvkzCDVv0ltFIfrPc/G+ShZ0e8MVOSMjdsWH
 6pxvsIAT
 wntAEx1OQzdzOCUKh4aUe9nVjgPGxwxYYm9rnLdwV5rHyMg2mxMYULGmAEwf1F/9GdfDfWny0t9photgEkWaEqtwCw2Z2NA/G0dJ5U2cM9thbI/Zd8Fu7Xwhj8Vnul7M6OoRm2v8LtBKCr5IdtCa1aQpzKmsvEvhf+O5XhEwahTr2KcgjdWRDpIqp/fbRUKqItOOdFrD1uji+Km9oF+/3ZKuIFS39qOFwGbcxZ9hsfhzOUmGhdv8COVGwcqes4X1lGKOLGvf48NFufjdcTYr+PliMSgY92eeHaHeVB5/7JN2orGFRWRSVv1MmizUjOCq+deiAggE0Qilb1vADYNXA/tlkMEwNN9ih3AuxsFZ2lEn9jMsZr3giDBSFUp4OLQs8LhwG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 06:26:37PM +0100, Kiryl Shutsemau (Meta) wrote:
> Three mm paths outside the fault handler gate on the uffd PTE bit
> today: khugepaged (skip collapse on ranges carrying markers), rmap
> (cap unmap batching), and GUP (force a fault through
> gup_can_follow_protnone). Extend each to treat VM_UFFD_RWP the same
> as VM_UFFD_WP; otherwise per-PTE RWP state is silently destroyed or
> bypassed.
>
> khugepaged: try_collapse_pte_mapped_thp() and
> file_backed_vma_is_retractable() already refuse to collapse or
> retract page tables on ranges carrying the uffd PTE bit. Broaden the
> VMA predicate from userfaultfd_wp() to userfaultfd_protected() so
> VM_UFFD_RWP ranges get the same protection. hpage_collapse_scan_pmd()
> needs no change — its existing pte_uffd() check already catches an
> RWP PTE because it carries the uffd bit.
>
> rmap: folio_unmap_pte_batch() caps batching at 1 for VM_UFFD_RWP so
> the restore path handles each PTE with its own marker.
>
> GUP: gup_can_follow_protnone() forces a fault on VM_UFFD_RWP VMAs
> regardless of FOLL_HONOR_NUMA_FAULT. RWP uses protnone as an
> access-tracking marker, not for NUMA hinting, so any GUP — read or
> write — must go through the userfaultfd fault path.
>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Assisted-by: Claude:claude-opus-4-6
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Nit below but LGTM, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  include/linux/mm.h | 16 +++++++++++++++-
>  mm/khugepaged.c    | 18 +++++++++++-------
>  mm/rmap.c          |  2 +-
>  3 files changed, 27 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 3d4d5f9a6f1b..2b04f690b516 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4644,11 +4644,25 @@ static inline int vm_fault_to_errno(vm_fault_t vm_fault, int foll_flags)
>
>  /*
>   * Indicates whether GUP can follow a PROT_NONE mapped page, or whether
> - * a (NUMA hinting) fault is required.
> + * a (NUMA hinting or userfaultfd RWP) fault is required.
>   */
>  static inline bool gup_can_follow_protnone(const struct vm_area_struct *vma,
>  					   unsigned int flags)
>  {
> +	/*
> +	 * VM_UFFD_RWP uses protnone as an access-tracking marker, not for
> +	 * NUMA hinting. GUP must always take a fault so the access is
> +	 * delivered to userfaultfd, regardless of FOLL_HONOR_NUMA_FAULT.
> +	 *
> +	 * Only do so while the VMA is accessible. If it has been made
> +	 * inaccessible (e.g. mprotect(PROT_NONE)), fall through to the guard
> +	 * below: forcing a fault there would loop, as handle_mm_fault() makes
> +	 * no progress on protnone in an inaccessible VMA, and the access is
> +	 * denied regardless of RWP anyway.
> +	 */
> +	if ((vma->vm_flags & VM_UFFD_RWP) && vma_is_accessible(vma))
> +		return false;

Can be:

	if (vma_test_single_mask(vma, VMA_UFFD_RWP) && vma_is_accessible(vma))
		return false;

> +
>  	/*
>  	 * If callers don't want to honor NUMA hinting faults, no need to
>  	 * determine if we would actually have to trigger a NUMA hinting fault.
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index afa218be15de..4f3fedcd75cf 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1895,8 +1895,11 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
>  	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
>  		return SCAN_VMA_CHECK;
>
> -	/* Keep pmd pgtable for uffd-wp; see comment in retract_page_tables() */
> -	if (userfaultfd_wp(vma))
> +	/*
> +	 * Keep pmd pgtable while the uffd bit is in use; see comment in
> +	 * retract_page_tables().
> +	 */
> +	if (userfaultfd_protected(vma))
>  		return SCAN_PTE_UFFD;
>
>  	folio = filemap_lock_folio(vma->vm_file->f_mapping,
> @@ -2109,13 +2112,14 @@ static bool file_backed_vma_is_retractable(struct vm_area_struct *vma)
>  		return false;
>
>  	/*
> -	 * When a vma is registered with uffd-wp, we cannot recycle
> +	 * When a vma is registered with uffd-wp or RWP, we cannot recycle
>  	 * the page table because there may be pte markers installed.
> -	 * Other vmas can still have the same file mapped hugely, but
> -	 * skip this one: it will always be mapped in small page size
> -	 * for uffd-wp registered ranges.
> +	 * VM_UFFD_RWP ranges similarly rely on per-PTE uffd state
> +	 * and cannot be recycled to a shared PMD. Other vmas can still
> +	 * have the same file mapped hugely, but skip this one: it will
> +	 * always be mapped in small page size for these registrations.
>  	 */
> -	if (userfaultfd_wp(vma))
> +	if (userfaultfd_protected(vma))
>  		return false;
>
>  	/*
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 546bc1cf9391..9fb733489898 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1965,7 +1965,7 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>  	if (pte_unused(pte))
>  		return 1;
>
> -	if (userfaultfd_wp(vma))
> +	if (userfaultfd_protected(vma))
>  		return 1;
>
>  	/*
> --
> 2.54.0
>

