Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C567C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 12:01:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E9866B00C9; Mon,  6 Jul 2026 08:01:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C1066B00CB; Mon,  6 Jul 2026 08:01:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B0C26B00CC; Mon,  6 Jul 2026 08:01:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DA6CC6B00C9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:01:14 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 39B2AC1EF0
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:01:14 +0000 (UTC)
X-FDA: 84958211268.11.872E0A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 12E00A000E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:01:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FNph2Rjj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783339272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WW0L2SZejCwRpfEhR38N28+FmcBaL+orntMxtuRFWqo=;
	b=XsmpX/EO+UHZipzJvesEC683OAvxob3af8GGaOYnbUJcBTlDOuYb0HGVB7sFU4hed5wHxO
	S6yYTBlnKnGYDYZtuoq/JDVYKUCFS2qXWcIPx2XzWLMJUbXgPORpL7pQbA2inhnz8DSTvM
	EQVLg+yHWIJvF2cgjs4xzmYX6LXdDKQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FNph2Rjj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783339272;
	b=MLPJTyHK9W+5J7RwVzoCB1vijfzrUkodt83YhHN0Iz5R1knJRmJqeq+WhHiKISnA7UGZZn
	GX8PC+/XezN3G0IyMF2HoXxtDctcTWLLpIBnHyR4maSJSvxHdygT3e29EgSA/Ry1xEz0wd
	LolNqm/oLW6s4Ep4BnCfzw5Lw41Tm30=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 03F6F42BA1;
	Mon,  6 Jul 2026 12:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7191F000E9;
	Mon,  6 Jul 2026 12:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783339270;
	bh=WW0L2SZejCwRpfEhR38N28+FmcBaL+orntMxtuRFWqo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FNph2RjjNKyXATzZlyGi9t4i8oEyjJpJy9IMpr/DL2C1UiK3yEa7e7vHQ43BpNBAx
	 B4evmQ3V4Q6iB2Ws0vnTwKz+8GfgQ3Z6KJeBOW+k/T/zsBChjgodYTIlZM9QgNkd7B
	 u57nGzqCEOBm3dRgxbOTMimfIz+zAubf2PJCITGA+ZZdEUiWyNJVxkerzh5huUzWY2
	 0CCPJ478AoioIeZBZFMsNDcuby4OcYsCFLH1wwxMGxMe1Vuk9LBJOh9D4eqvP7rjdz
	 S2VH/uxJs3EJIzcvl1ZeeNdo0Uxo6ABRrs3eEuh/yZ1kx6d7sLKNRqoW9AcrpqWb+U
	 HaHvpuhrCsewA==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 0B21DF40068;
	Mon,  6 Jul 2026 08:01:09 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Mon, 06 Jul 2026 08:01:09 -0400
X-ME-Sender: <xms:BJlLaucZk5uTZMuWajBaUJtFjTSecHNHtAUSA0xFFO0X6Fy1qOD2PA>
    <xme:BJlLavwYDifDF22hn7uzFXE8easFmz_-dPymi7uOGnO26F_p_w2qX8yNgQwXpoF3G
    R_Gjjiy-lic67Z1EBSxY64jjmcE_91lylS6AmOYHLzsdiitdgTnT0D7>
X-ME-Received: <xmr:BJlLasdjy0KWZQXDiLcGMyut48JV1A9484_3ZfudY6No7I4bxuyLgblw4mXCNw>
X-ME-Proxy-Cause: dmFkZTFySgqqxLA4VZcNFCd3z+XbXwnqS4PD/nBbnsy1ojGvSM/8/gbK80lPUh9NcDV0RJ
    rUO/qqcx2j2U37kdDcQHzTYAPKRAnrRouILhYPw+E+bTymwtMJsfavHaHRHOkkuVQP9i8D
    5GQ0yys9VyHQmVVefvBUhL54jcpmpq5bKoyvwDP1KdSdRHsPPnl/GPwL7OzpXKLydgINdj
    S7KcJp2WbfNiyKRPBhALsQ9yc4C0hzHM+CuLPRzHlTJmuD/NR4mpKP/tszrXUcyW9ATqpo
    TBCgMrDphtMtmp1Ew9Wt//Ze/YA/M/0KeyZVfBnqckn8uAHLpk+UCq0/6Ob8N/M6p/3PJh
    2j9KOuKtEJhHsB0L+EKej8BWJLh8ZHuwSvX8HiRScwJfpUYLxuvefaXaSIaNG+Br3ZvX30
    S8F3z6hAc4TguxEPpEAQ8ggoKYpm9HjbfJPwTNlCXdeBuZBXdYqEWQrGZY2cJeJDc8OTim
    573Sz6Gm3zGqzDkHpz3JzFC50rfUJGVEZ5Q9EREqQkEWE4FTsahLg7APRwPGgcxPo9+U1n
    m07vsXn/BiUFWEJy0bAeBSQinQqS4jyrTTeehNq7LtFgiPI0h93PNox6mBAVpyU02z5irA
    r8D9WSy+JV+jJH/naH6D/pYA1LrLq2oCmajkiMnajO+GBgGc35Khjd+FMaEA
X-ME-Proxy: <xmx:BJlLap4c_1R0AoktTsL0LgGhcScgvoB4EtnJm6nEbpXXDJWkwJci7A>
    <xmx:BJlLakYbb5bnGYTv_ubSjf6GKgqQm7lvx__piQ3mEyN1Q9riNluCuQ>
    <xmx:BJlLamxBRAaYjhhSq6a8O9VoaBMTxDF-IurOAMwi8_HCJVKpDqwrNg>
    <xmx:BJlLapQKVxzU8SWgJUclDq5MJhvcwNrZXXq45xLc-UO_E26sGtaeUw>
    <xmx:BZlLakq2bHpmKFE9eEsVOX-rNHjT3Kl27xYG0-u5ffr-hK9WUOXwUIaI>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Jul 2026 08:01:08 -0400 (EDT)
Date: Mon, 6 Jul 2026 13:01:07 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, 
	linux-mm@kvack.org, ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>, 
	willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, 
	shakeel.butt@linux.dev, alex@ghiti.fr, baohua@kernel.org, dev.jain@arm.com, 
	baolin.wang@linux.alibaba.com, npache@redhat.com, "Liam R. Howlett" <liam@infradead.org>, 
	ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev, 
	linux-kernel@vger.kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 2/6] mm: extract mm_prepare_for_swap_entries() helper
Message-ID: <akuXgognmAW0QhOX@thinkstation>
References: <20260706114320.1643046-1-usama.arif@linux.dev>
 <20260706114320.1643046-3-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260706114320.1643046-3-usama.arif@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 12E00A000E
X-Stat-Signature: abab4rrkm76ssjg7fptiox3ws59st7s5
X-HE-Tag: 1783339271-305128
X-HE-Meta: U2FsdGVkX18YuolYnx1MMth4mM9Oe83sU02dkYMOzVCqlJAedFJDr8IvmpMevpvtMVUwnySnNsYLE5K+H+/u54yjyfJ7HWWEMIaSUVzIvkl2PDwTnNjCAxvNkNwLr1AoVaYXde522NlFj6xinFysMJNeBNOLRb7ZMO8KrXWknt7qk5TnMLhix7YT7eWEgwg+Pxu/InXJya3mb544Y5MEvu46cVEXfzs4Zmk2OaD/FZLIoFBdKNaP131ZHXr02jUH+VJ/lUydB8+HO2fgHTDjOhdps14zLsh47g9ERS9+HLXV79yDvTuAgjiCiYSPyQiZ3pHVAHQZ4RPlZ4qrjFC/s36SeY/Htt8LqbHPdWtjER78TPs6gkZpk2TTNGgYnNrx7cFikE7Hqd5QIzCiQ5mb0H7kWOO8l4JDDPsF8K1iEmyVz4yewpS3SmebbtjlSfRhzBt6/PyLUg1OhMB1SuW40Mv30pE75Kg900S1uJVT3G4hxKeKoyZdJtHPmscFYZz92kxk0Z1zyhK9xJNt06J2SMhR1AynUeBBsjvmD5cOq82cMvAx7aTNYYj1M5nvKDm3So0sR+EyTG7auCdQ4w4fl0REXqAmIGO68WOch2k9dEI0RWC6sTb8ITBUGyLEjBDTSTz6fAeg2jMAQ7Hsu0i8WcIi3zZMP416qrBoSnvNocyAqIXayeHvUEEWutTL8xK8Y0Ja+69RnaMREu3px5VOyoanwGmGGhJyAZlvUXmAYit4p06nWEn8p9oE15sl2XtysDV/PvrpkM6pr7l/1RfpmoMqZE2bUopPZzSAsng6bYnBDidQFq6fmeHc1Vx2iR6T6SG2fOamsxVyihHDYacqRFY2P8Xkk3SgVQzoQShnY/R/Yb9DjZTkQeAH5Sjw76Du6FgDqzBIMa4bhakNdTBb3MIZutXLVx3TSQvsc4LPyb4iqyQkslxl3jllCB0iLypf9dmAP2+8MmJ56XLZj4c
 qZ1dE6y+
 6Dlhtb02T33Ujj8g3U8Et2XToSpUaYRwGnM26+r+HFpw4CnN2C7bCV2w/kY0VlGBKgoo/kZQIKYxwQynJ0rGeYQz2MGfS7B7JyS8DZxf0Nnad/Uuv9IAoNMJ8sBCxSJo/NDdVstpUb93ogbrNpzWv4Obcyl0cafJY8krSC5INJ2GwgNOAMpT0/hT9AAdZqNTSM3/30pym3mggswUaCUaRtY66eLBb3BBk38z82a92LS/VlYNkvZN208P5c7Fl9zitPirDqlpISNWPH8w5b9zUzWlDUpPycN2LIwPChhHbteJYnWjzAz4Pcex+5s+dMUomJ/x28rKGynj7uD+gbp8Ku6Gs0+Zik+wHngWj7J6uhOqdzP7NfOQlYm+eiX05e31TY49ARJIBH6r4XNvBzRAzl6bx0/GrPBbMBezbNK1FfNTIlgG+tvkbno+VIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 06, 2026 at 04:42:04AM -0700, Usama Arif wrote:
> When a swap entry is installed in a page table, the mm must be added
> to init_mm.mmlist so that swapoff can find and unuse its swap entries.
> This double-checked locking pattern is currently open-coded in
> try_to_unmap_one() and copy_nonpresent_pte().
> 
> Move it into mm_prepare_for_swap_entries() in mm/internal.h and convert
> both callers so it can be reused by upcoming PMD-level swap entry code
> paths that also need to register the mm with swapoff.
> 
> copy_nonpresent_pte() previously inserted into &src_mm->mmlist rather
> than &init_mm.mmlist, but the insertion point is irrelevant, mmlist
> is a circular list and swapoff walks it entirely from init_mm.mmlist,
> so only membership matters, not position.
> 
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/internal.h | 10 ++++++++++
>  mm/memory.c   |  9 +--------
>  mm/rmap.c     |  7 +------
>  3 files changed, 12 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 430aa72a4575..0360648e5726 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1955,4 +1955,14 @@ static inline int get_sysctl_max_map_count(void)
>  bool may_expand_vm(struct mm_struct *mm, const vma_flags_t *vma_flags,
>  		   unsigned long npages);
>  
> +static inline void mm_prepare_for_swap_entries(struct mm_struct *mm)
> +{
> +	if (list_empty(&mm->mmlist)) {
> +		spin_lock(&mmlist_lock);
> +		if (list_empty(&mm->mmlist))
> +			list_add(&mm->mmlist, &init_mm.mmlist);

The patch is fine, but the name of the field is awful. Seeing mmlist I
assumed it listed all mm_structs. It has to have "swap" somewhere in the
field name.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

