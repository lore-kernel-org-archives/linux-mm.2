Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 256BBF531F1
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 07:20:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7574B6B0088; Tue, 14 Apr 2026 03:20:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 707FD6B008A; Tue, 14 Apr 2026 03:20:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F6606B0092; Tue, 14 Apr 2026 03:20:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F08D6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:20:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D9508C1CDE
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:20:34 +0000 (UTC)
X-FDA: 84656313588.21.B57DDD5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id F107340004
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:20:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LwMpWIBH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776151233; a=rsa-sha256;
	cv=none;
	b=PEl/jb5MWJhfNiDFjXHX0Sy6VJbM+rdQkEVV/iib5+bhXGEdypmALFHTWiBCm5C9Wkajxd
	p5eMRw+coYiyFIMIXtF1ugeCf/blnqCFrMIiU+noYid+qW6PABmryBSuMIaKESkKKdtSDq
	8TY0hL37/LduCsr3bDZcdaaz0NWyD90=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LwMpWIBH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776151233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GzpUAT4StgsEcgwWsj96cDVhpYkqkPA/pDpxx336f+U=;
	b=DajABL8n0705kBSQsPR29imF9qBxSZpbZNC07k+/EVs7GYdHPF7ADsQixwiCIKLnDeI799
	PorO6QZTP/SKp2U773pYOobaUMnV2bexpkwrcBaJXyPxeHd+MUYmkC8KphchheSWDJvpWI
	4z5Yd8JVpZchfGt1iRktAIGAkGiGAWY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BC3284379B;
	Tue, 14 Apr 2026 07:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737E7C19425;
	Tue, 14 Apr 2026 07:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776151231;
	bh=ROcL0Ax/9HIDfTXMPTJFEEgwD3u2oJr3p1yQIodv5TI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LwMpWIBHOtgSKW/PkenJ2SX4pvgOIrGM68t435fiq5y/qZVDMpXR/c8VDxPVrGUhD
	 cKHEACGz8/et2gFcRHGL25ix3FB9tb7L9h31YzYWnEAnfRL4xyubkLPQTddceYOdgC
	 Q+K3xDBzY1sgw4NUe1QpxOvViColPDQUNjVQV2yWHHEomDI5mIs/WA3os9/hesdstL
	 0ydiJ/jgTXnFpsw6rLawcHulTEwF3RN7NqOOlpMOttcJkGlf7sRKLleiBEKIngRWPm
	 yUjEVgs/3ix8jOSs2KgCMDXMdff4Z1R23JoqHTaK3sAo3WzUG1ZhjREKuay7gGSBuN
	 BGvAIDWnaYKYA==
Message-ID: <0c22f74a-ff3d-405b-8d9e-a7222f5b9dfe@kernel.org>
Date: Tue, 14 Apr 2026 09:20:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 2/3] mm: process_mrelease: skip LRU movement for exclusive
 file folios
To: Minchan Kim <minchan@kernel.org>, akpm@linux-foundation.org
Cc: mhocko@suse.com, brauner@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, surenb@google.com, timmurray@google.com
References: <20260413223948.556351-1-minchan@kernel.org>
 <20260413223948.556351-3-minchan@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260413223948.556351-3-minchan@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F107340004
X-Stat-Signature: 69zhcbt5gq6dcwhwr5j48imxybapdex8
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776151232-545364
X-HE-Meta: U2FsdGVkX18zoWCjCafgZ7DYWGQzd5i78lfiBaHRX9rK00pPZ37qACka49wlk1AMNXf8e0/pJCUNuvUyXIF3nj0tfyEg+yO0MtQ2sidRbUe7fIMYFtZduPpBNnYWEjEv8fSlS3w2MuGz27goTtLqaS0aXvLwRv5qRIJ1QIrtprO4JffVkc3NwWQvOth7vG3S5Icx5b+C8PxSD/iygyzoZ136tyaqol+rkKlApGm6h7pPY8uyT7a47DyJGlitEqjluujm15lec/vMa4nIqMbBbiPgkwqxXBVWFc5NZiNCj87IqaKdfcnFA7z0CInVSzcGNeDxmUP3vU36cadQ8wjCOdkLYKKYRRQG+eKBb2V/5oc81wOl65cj3F9n+1qyjgOJfK3Zj8aVPbAyDCPZeQKh+iZ8qzNuP1eTymvf6WKqFXLUEvKbKzCNUBxnVNkOXlF4BiFRAIYhl88UTyk6dveM1uCS17fvA1oFpzhP8wyk8zGeIX96V9+7NbjoykGrwtBIaG25pNt948oL9Lnm6dPLne8fWPzpbN7cOYae8n8HPAo3t3AvU+28soNf4l27Tl3OuiBtmP92Y77tkX2EjGgk7ir6P95O0BzwLZr4iCMTyM6jLBHf8ynmmiIhA6VJP+L7KWHGzcpOAe2TY9yKnM6Rrcl0DSYwqcPhlo0RyBGkMj0/XAzEntdB2aHHN/PxZ2ydbApdOBHzRQpO9hCtfwk05Fyz4hxzH+KaUsV/S/DD8VDrs9CVqMHlJBKiwQlMn16ApXbjohMQdXCcPqcknqfAoKNRLX2Lebx+WVPYXau8TSk36oPPyXACOK1/i4xo9A2pPGujCtC0G1yw26kSBEE8BTd342ADduHk1fVq45rG6C0lW9fl7nhyF1SuULK04EOVpy/cs7p9I1dwlt1ayKKZQLjUdcweMWdBDPchWdQN+HaAuxxJganB7puqt4jz/+4B0vDUa+jEIPUkC2Nx8pi
 MzjXqrPH
 YkLAfpkSpcO9klWJP7UGWvclu5hyb+rBNFIE3xCuUs+EuKwMfoDDd61rBFCbSx2GDrgNS6h6tt6Tm2/Jll1XSeV5Fu3JqnSoJt4zLu2zflPz6ndBvNfHpWlFyeyNfq9LZhS5Vl3ztaJ9EOK9kQEH4ek71GiHyRunHymk6FiUacq1t/bsrXv7DvGQ8iYOLjCXo6pZBu7TzwB+rfzYDh4tyJ7GZV0jgw8InQiGq0WLKWuYyRIHATfkzf5MgLGJ4atzWGqQOnfFEI0bErEIPA2ZUDtvN5YDLwi0A1aOcnoflMA6AAMaQCIyBG8JN4JQzSeXS8OPwA2P3t3Qu6d8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/14/26 00:39, Minchan Kim wrote:
> For the process_mrelease reclaim, skip LRU handling for exclusive
> file-backed folios since they will be freed soon so pointless
> to move around in the LRU.
> 
> This avoids costly LRU movement which accounts for a significant portion
> of the time during unmap_page_range.
> 
> -   91.31%     0.00%  mmap_exit_test   [kernel.kallsyms]  [.] exit_mm
>      exit_mm
>      __mmput
>      exit_mmap
>      unmap_vmas
>    - unmap_page_range
>       - 55.75% folio_mark_accessed
>          + 48.79% __folio_batch_add_and_move
>            4.23% workingset_activation
>       + 12.94% folio_remove_rmap_ptes
>       + 9.86% page_table_check_clear
>       + 3.34% tlb_flush_mmu
>         1.06% __page_table_check_pte_clear
> 
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  mm/memory.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 2f815a34d924..25e17893c919 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1640,6 +1640,8 @@ static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
>  	bool delay_rmap = false;
>  
>  	if (!folio_test_anon(folio)) {
> +		bool skip_mark_accessed;
> +
>  		ptent = get_and_clear_full_ptes(mm, addr, pte, nr, tlb->fullmm);
>  		if (pte_dirty(ptent)) {
>  			folio_mark_dirty(folio);
> @@ -1648,7 +1650,16 @@ static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
>  				*force_flush = true;
>  			}
>  		}
> -		if (pte_young(ptent) && likely(vma_has_recency(vma)))
> +
> +		/*
> +		 * For the process_mrelease reclaim, skip LRU handling for exclusive
> +		 * file-backed folios since they will be freed soon so pointless
> +		 * to move around in the LRU.
> +		 */
> +		skip_mark_accessed = mm_flags_test(MMF_UNSTABLE, mm) &&
> +				     folio_mapcount(folio) < 2;

folio_mapcount() is most certainly the wrong thing to use if you want to
handle large folios properly.

Maybe !folio_likely_mapped_shared() is what you are looking for. Maybe.

-- 
Cheers,

David

