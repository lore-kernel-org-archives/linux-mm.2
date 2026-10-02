Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC80ACA5FD9
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 08:18:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0138A6B0098; Fri,  2 Oct 2026 04:18:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F05946B0099; Fri,  2 Oct 2026 04:18:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E43546B009B; Fri,  2 Oct 2026 04:18:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C1D246B0098
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 04:18:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5B274160642
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 08:18:44 +0000 (UTC)
X-FDA: 85276984968.13.74E9ACB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id BF4E94000B
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 08:18:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UK6jrH00;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790929122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sptNDyqmlXmK1/4meQkZ0Gk1mM5t6HWPSQC9jCl7kpg=;
	b=L3UK7YgLT1rx/zUxTR4DMTT8Skcd1q0bpVySKrwtKDVB7Nou/UnXSn0W4b6jCXluaKRsCP
	lxyX4qTEs0JhoV/gey43oyaOT93mwoezFi4M4/vPWN1dgJ40u0KMlH1QCuEj04pSXPF1Wo
	oO9pcyAX/lAu0kmoHbBs2XZWRU996qM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UK6jrH00;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790929122;
	b=8jdkwV5Q9XUpi/EfDGwatfW2s7UtdDtsg7yVgfbJZUUmmYbaJaQa9lk7LVparrwehtFFt4
	6GCWHBIp+oE0MwG6rn9i0wi96zmHr6+DKeU98iOqi6peP1qKTOPuautGpkkdMVwcHFTAOB
	LWqUaTzSZvsY+qZYTYy0FGSI4GcTqk4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4433B60A5E;
	Fri,  2 Oct 2026 08:18:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522631F000FF;
	Fri,  2 Oct 2026 08:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790929122;
	bh=sptNDyqmlXmK1/4meQkZ0Gk1mM5t6HWPSQC9jCl7kpg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UK6jrH00Df4LQaMV+8HKaLesemGA9Aso9iWdTe5PapieS2cOaA97os33M5D7hv2Vv
	 sTb/0j3Utjt8MgKBiwMMhel507fxJMLVL2gPjAclVQoypPvGvaSUBloiCHjVkSriYL
	 VVpOTrETRDRlEkEFSD5MdFx1t9X1wWcQtkqbRko93z6X4Esf5VHClDsnXQ2KdiIvH1
	 fHXciRk4vA+m8ixtC+m+Z1caDsWAf1oZb4PnJOQnh+2SUsLIWLZcELQo2UxjPYW1XA
	 2D3CX5FuJ5oz9i/ghNQAtHTaZEtpJ5DuGZvrHefxkn3m2D+0omTdL/vXYEMKKg8CiX
	 JrZPKBmQgiR5A==
Date: Fri, 2 Oct 2026 10:18:35 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Cc: akpm@linux-foundation.org, peterx@redhat.com, surenb@google.com,
	aarcange@redhat.com, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, mhocko@suse.com,
	shuah@kernel.org, kirill@shutemov.name, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] userfaultfd: clear the inherited uffd bit in
 move_swap_pte()
Message-ID: <ar9o2zVvUkMUxVzv@kernel.org>
References: <20260926124145.2878520-1-donggeunyoo.kernel@gmail.com>
 <20260926124145.2878520-2-donggeunyoo.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260926124145.2878520-2-donggeunyoo.kernel@gmail.com>
X-Rspamd-Queue-Id: BF4E94000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 55i6ujxgjnddhnugyhmcod5hrhazjzbj
X-HE-Tag: 1790929122-349111
X-HE-Meta: U2FsdGVkX1+dtp0uzzxPijaP5pY3vJ3i4KW1UXr4glIVV/GLjo8TJdZRk0DlSqAGKp+sUQRMrKnmLia9mV5vTPjaSRRaSm2am9t4YynB0YiRKP7iOIkWckGp8jDo9sEirpHuPz7WyGdSM5Xg/+m7AyHN1dGAYir9M5sXgy9Kk4/zsZFQhiAxXqMoK0q9I1UeVESJHgA/dKCgf5pztufqCuFS1TkytHl6id3jepPYrEseATqaUksS176Gpg4AICU+0ooMRNCaR+IDOXBMH52GHQd6rPEGQvSV1wn1msJ3SRCjv1zmiki6SjkXSnBMeiR38tSE2YNLdL45SF6VwfZcx5ACnVFpmQQ6bvwGMIS7atnUs5GLyuDj0C1+ZT6dlpy7pbMDDee+IYvFdCSlLp3oLypN2YezDsCEU2hiqIHICOrZ3rYs3IRAEP2aMl3LMbUlFnsElyLzTba3Dr9j+znTuQZiOJa9m8tRZxjbehG1lI4o8yu5j+rxxG7tz/oahu+flF4r7vhj9ibAUzg4FMe6URjNyWwKmg6+8E8ibPzNIIMUm4/S8NvY0NA+yZ3h69cHkUxdGLbjgJ6a2eGVyjTVxRLps3shBRQMZfq9UxRXtBR0r2bltAlJviWhGgB33nHhd//CugcV5XM7aOyzYA1Nu27CQPb1KNj5YJkTnbNGLx19kFy0dCPSj6tV+n4bV1iUjEZAh6XzE2RKdVj3SVzL7BG0gWt1blGPyu7Rq9SqBmje5UojyXqD2+/kVaYn9ChUJS1WETC8aVncNUlUGrTgc+YZmLrM1F3WlwOHqqrBom3H4br816EMrkK3J4A9ojN+R0gKPviblvwHX5Y479iTySQ+/SzcbaWehdKxkj4gtjK+oV/SIRuSs1WiXnPxJwQBMOk8krv7YGqOYlmGtpU8YaUhZLOMVuuvfBYyxr7gdkQxoam259Ai+wkmrDFE6Bzw0KA1vhmFBfdsXVLBEVW
 NYe6+7UB
 Xm7m1zMrVdORwhYNbaqoVL5Xr2Aca4LHEHiD/QwvpfCogeWSpuSR6v9FDWpzRXIwXYFcGLVLPglcIDweSknUNJcPsW/X9rbGlt5EzTQfdGmnfW73qguF84o8xO4/a2aXSzTVD3AV4j4ZwkazCwKsf3yV3vfOO7UdiGDpRMRlFHY3GnARRr0S8TO6FIh+TJl5reRS6XUc2huRCUlL2KKtOFcO/v4OmqZ/Sk5czUgSv70zMFRlwoKkHsdhETpE6EW/9x14nxDuf8/M1phOMt6CEcbEgdvminN4iqsKPWzqAc0F0iJNm/IgL6QWs+33GLT3BjOWgAXMMnhJSu05Uecfnd/h9TW9VZrMiKQ508yusUh2IoRxDAtOZBhosS5eVSsu0PuWCHgm6FI4RQGe74w4gUQA7qOVL1WWpf0hzi2En9oAz53g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 26, 2026 at 09:41:44PM +0900, Donggeun Yoo wrote:
> UFFDIO_MOVE on a swapped-out page installs the source PTE at the
> destination unchanged, so a uffd bit set on a write-protected or
> RWP-protected source lands in a destination VMA that was never
> registered for either.  Nothing clears it there, and userspace sees:
> 
>  - /proc/<pid>/pagemap reports the page as uffd-tracked (bit 57), both
>    while it is swapped out and after it is faulted back in.
>  - MADV_COLLAPSE fails with EINVAL on a range containing it, because the
>    collapse scan bails on a swap entry with the uffd bit set.
>  - With CONFIG_PAGE_TABLE_CHECK, faulting the page in warns.
>    do_swap_page() carries the bit into the present PTE and, since the
>    destination isn't WP-registered, also makes it writable:
> 
>    WARNING: mm/page_table_check.c:202 at __page_table_check_ptes_set+0x185/0x1e0
>    Call Trace:
>     set_ptes+0x67/0xc0
>     do_swap_page+0x990/0xfe0
>     __handle_mm_fault+0x7d0/0xeb0
>     handle_mm_fault+0x9c/0x250
>     do_user_addr_fault+0x207/0x650
>     exc_page_fault+0x65/0x150
>     asm_exc_page_fault+0x26/0x30
> 
> Reaching it takes UFFDIO_MOVE out of a WP- or RWP-protected area into
> one that isn't, on a page that is swapped out at the time.  It hasn't
> been seen in practice.
> 
> A resident page doesn't carry the bit, because move_present_ptes() builds
> the destination PTE from dst_vma->vm_page_prot.  Clear it on the moved
> swap entry as well, then re-arm it if the destination is RWP-registered.
> 
> The WP case has been there since v6.8, where UFFDIO_MOVE was added.
> 
> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> Cc: <stable@vger.kernel.org>
> Assisted-by: LLM
> Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>


> ---
>  mm/userfaultfd.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 74f04c323c50f..f39f109f17989 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1449,6 +1449,7 @@ static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
>  	orig_src_pte = ptep_get_and_clear(mm, src_addr, src_pte);
>  	if (pgtable_supports_soft_dirty())
>  		orig_src_pte = pte_swp_mksoft_dirty(orig_src_pte);
> +	orig_src_pte = pte_swp_clear_uffd(orig_src_pte);
>  	/* Re-arm RWP on the moved swap entry if dst_vma is RWP-registered. */
>  	if (userfaultfd_rwp(dst_vma))
>  		orig_src_pte = pte_swp_mkuffd(orig_src_pte);
> -- 
> 2.53.0
> 

-- 
Sincerely yours,
Mike.

