Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 432D6C88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:55:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E7806B0098; Tue, 15 Sep 2026 11:55:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BED76B0099; Tue, 15 Sep 2026 11:55:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D6456B009B; Tue, 15 Sep 2026 11:55:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 160B16B0098
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:55:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 984D7C04B3
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:55:55 +0000 (UTC)
X-FDA: 85216447470.22.7EEFD88
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0143420004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:55:53 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jX7wzDGS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789487754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ck/iKy4tr4M+OoXzMpF/kel2WjhTrOUqJFUS4adZunI=;
	b=FqAUk+2fuuLFvolXEYPO/G12vxy3V5PmRD7Y9weWIX3As5mrVhoWNhFnfX9LIUlu4bkG+8
	fY+PANS2MqA32DhsPHWw8+kVCDXYu3eeWvDX52qGRHyOHtQ2j4YMzmBnyUMUHlc/Khy7Wb
	CMJhvJDyq7D97hLZZOmWYuhlh9xEqU4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789487754;
	b=omNj4udxjjUBs249XQzi+QYCxWqPtvK1wpYiKhA/t69eRzt2Z/j4QtEWJ669ycgv3xB7Fr
	28u6BV4gWFI07Tao+sdt0H/eEZ08LlRp9knUdasY8wjsbS6bvoEi4aMy9NmizLMZfxJ4cb
	U7AAMmJZBkHp3X5naZC+IIU/hqCiehY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jX7wzDGS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 67254600C8;
	Tue, 15 Sep 2026 15:55:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FEFC1F000FF;
	Tue, 15 Sep 2026 15:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789487753;
	bh=Ck/iKy4tr4M+OoXzMpF/kel2WjhTrOUqJFUS4adZunI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jX7wzDGSJXhqVbR925MIAaJe1yX9wpK9q83/+J8qU5r10cXHyAPSzaPaVae8wfyBX
	 /OBeb4ckVh6Ws2j2eD7/CvCMd8gPJNGLpdIPMXq6m/QEwwGOCrrqBH9yBH02LbQiVp
	 QSusn0MMDVidnsAimMaiwRP1W9tGttojyQC2i6tz3hjuFaV0Jkc8iMdNXjlWp6FRt/
	 KuEOoMXi0v5VT4zgNSaaL+siwyXvVnzPlpuvZkXjGYqD4c397fOIXtUO3yW70tFgEx
	 CXAADDjKSia0GY3oqhNddwHeuAUrLGuGWPzY70XsIeuDutI47lx2GAmvQ9KekOMs5I
	 iIaZ90Webon2Q==
Date: Tue, 15 Sep 2026 16:55:47 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, liam@infradead.org, david@kernel.org, vbabka@kernel.org, 
	jannh@google.com, wangjiexun@tinylab.org, sashiko-bot <sashiko-bot@kernel.org>, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/madvise: reclaim isolated folios if PTE restart fails
Message-ID: <aqloB0zm3RjJ47m1@gremlin>
References: <20260912110832.3203902-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260912110832.3203902-1-gourry@gourry.net>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0143420004
X-Stat-Signature: nsyfme5fnsm84y8joae9b545picfpj8f
X-HE-Tag: 1789487753-683907
X-HE-Meta: U2FsdGVkX19FQM2reX75LyL6a4xE/mPUCiS6GBiGg021eY65S8lFO6U14Cu3XggCJWResQpWO+MXZ8OR73xDlolAevS82HhLXEWXcISQq2/XXgHuXC5FQtxqhUPB7bWLmQAYvBkNwdX3olF+C13aUMzovQXK/nqvr0R6EanuDYCBt2H3TjVf8cqBuRr2ind6CZx9lw811DKaz38EwREutxfRjjXA/i6CFtRzMuaMJanuJTxAF1rMY+BiBRJGORh9vxtfmRHzPmJO3NZH4uhR+Syty/fL12AYNXUupw9NTfwJzoKYlQNLyVKESJYDNOKeSkAVeXQw86mO4c3sElmc8b17O0n6zGyu6/14L8Sz69qU83vqZSgBsvrrzDBJ0bg2bTwTic5lec6N4xTN/Pj/HoerX8r9qb/SoVAEdH34yTshQ6zJyduRYYnw78ajAB9lEo7wWWgNMAkz7Rgp1zadkCadCVAaexzgfLvBnyMMTwG00Igcnxa0FX8BrqifiKgj/vO7FV0temBOBYgE7+IZ7UDKNLr0I1EaBZJRztJfgbkbtDPlqbG4cPVQUyGd3FppKGQPTV9E2Y6Wd0qJxPfPq09Dx0U6DUKbtZjEDUuwqX20MKUF6NVnK73TL4Vy6b08BsUSsdYyM7k6srRX5QgNOQNC4Mg2UwF1rAq5brm2D2WS0//eWLafSI8LOvwk9u/p6VsiKa34jBeFRKo7qXMALJ5LZyrabu0wUQCRefA9CdUz5Di+ZhMItB9a65uyRfEoaTp0LvsxSsb5bw5cTRV7281p6VztF0BbDmnwsm2kk52XHozU77XdMnl0GyVOgNyGv77kFuR/qRMQ8E7g7zrWFxUjgP0cny68btmJc9W29F6vM1IBj/0/WL0+KejJhOmwfH9/qyD41KF5yyplEz7xu02SBdwA1BUhxVzynKyt89UYmG+EQf/rIzbgfsRgL0VaWmMIHU5ti32UVau55Me
 dR+TRBSc
 ZqIw2FRRo2iBAakS3MQCNsEIC0ITw6gG6iuif3gW5tYsPFOV0nn/3Eva+JNxmmbJaOtg4J9NZUx4rzjvFlLEQuFrsurBh5iQ3DXKTaxmDSeX/g7rw4oeqZImzW6Wr8HGWiyQlvpOeggg2nUAwgBD/IzP9fLGUj4hst+FaGVVePV6SWh4R25IgZ/7jfOv07VCg4d8ID6kmiM6ofZaaSY53jJjRINu7wJvquvFb3Z7FL1P4MFOoPe4gNrfdnYniHEjFZJtibGLI3aebxY2Sq0CmxtDbLQKvXezYog2G6evewlAfRdWGqiIdPHoSauLFh6Zqx7dxIB8uc7etpq5CPFUJCFWfsaDBk5TeOpqQCLuumP4syc5cq1jwr4XtUwmMymd2LpQIu6Tb4xtElfg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 12, 2026 at 07:08:32AM -0400, Gregory Price wrote:
> MADV_PAGEOUT collects isolated folios on a local list before reclaiming
> them after the PTE walk.  The reschedule path drops the PTE lock and then
> restarts the mapping with pte_offset_map_lock().

Is this reschedule path even necessary? It's pretty bloody sketchy.

I thought the modern approach (TM) was to not do cond_resched() and friends so
can we actually look at removing this?

>
> A concurrent operation can remove or replace the PTE table while the lock
> is dropped, causing pte_offset_map_lock() to return NULL.  Returning directly
> in that case bypasses reclaim_pages(), leaving the collected folios off the
> LRU with elevated references.
>
> Route the failure through the existing cleanup path so any isolated folios
> are reclaimed or put back.
>
> Simplest userland pseudo-code reproducer:
>
> p = mmap(PMD_SIZE, ANONYMOUS);
> touch_every_page(p, PMD_SIZE);
> parallel {
>    while (1) madvise(p, PMD_SIZE, MADV_PAGEOUT);
>    while (1) {
>        madvise(p, PMD_SIZE, MADV_DONTNEED);
>        touch_every_page(p, PMD_SIZE);
>    }
> }
>
> Reproduced in qemu trivially with some explicit widening of the race window.
>
> Fixes: b2f557a21bc8 ("mm/madvise: add cond_resched() in madvise_cold_or_pageout_pte_range()")
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260821150912.183976-1-gourry@gourry.net
> Cc: <stable@vger.kernel.org>
> Assisted-by: LLM
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  mm/madvise.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 574aa2bb7c7e..ba5a3d77241a 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -464,7 +464,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,

This function is truly some of the absolute worst code I've read in
mm. Shocking.

>  restart:
>  	start_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
>  	if (!start_pte)
> -		return 0;
> +		goto out;
>  	flush_tlb_batched_pending(mm);
>  	lazy_mmu_mode_enable();
>  	for (; addr < end; pte += nr, addr += nr * PAGE_SIZE) {
> @@ -568,6 +568,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
>  			folio_deactivate(folio);
>  	}
>
> +out:

Seems odd to put this here for a condition that explicitly guarantees
!start_pte? It should be before the if (pageout) reclaim_pages(...);
surely?

I honestly wonder whether, rather than adding yet another label/goto into this
absolute bloody mess, whether we should just live with a bit of duplication and do:

	if (!start_pte) {
		if (pageout)
			reclaim_pages(&folio_list);
		return 0;
	}

I actually think that'd be clearer at this point than throwing in some more
indirection.

That's for the backport but somebody needs to rework this entire bloody
function going forwards...

>  	if (start_pte) {
>  		lazy_mmu_mode_disable();
>  		pte_unmap_unlock(start_pte, ptl);
> --
> 2.55.0
>

--
Cheers, Lorenzo

