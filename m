Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F68BCCFA1A
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 01:01:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A3BE8E0003; Sun,  9 Nov 2025 20:01:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7533C8E0002; Sun,  9 Nov 2025 20:01:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 643858E0003; Sun,  9 Nov 2025 20:01:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4C1288E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 20:01:06 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D85BA13C131
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 01:01:05 +0000 (UTC)
X-FDA: 84092893290.22.0546DE3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 31CE416000B
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 01:01:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=LM5epqrP;
	spf=pass (imf08.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762736464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WKv+2CQ5J5KhRg09a0yutCdYo0fgBapbY004BSt1hi4=;
	b=33S9Yd1kHg9ukmamhKkrFntVIb0OzsaCHuAp3KHPVlxLH8/zkXUlIQNHGdIQasqlthZjtM
	dawOAw4pKahdUNOqMrCPZEWCQe+QRqF4hLNPVCPJpwx97F9/UwhLsvDblJIVeuR5S/+JIH
	VYHZUXEgYMVd3aIxfdWFZWU8h3N0riY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762736464; a=rsa-sha256;
	cv=none;
	b=P0GpjzrAtQYy6uo+iPyuvYyQcVPk7DtF5wNDiEvyWHJqkHISkilT7ugGWsWk9mZBJADh7Y
	/HEt/aglrvzpbrqmu6F0hQKIlpsCw0nW+E0ZhN5LTh1WydyyZ/0wlT5M20T66AebNZlMWv
	1Av5iZX44EBtUUlJ6rYDzRCGZufk6QE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=LM5epqrP;
	spf=pass (imf08.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6E46560008;
	Mon, 10 Nov 2025 01:01:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC4AC4CEFB;
	Mon, 10 Nov 2025 01:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762736463;
	bh=VwoauO8e1RWqPBsp4AaLMfdMlCNd5t3asmKpP++k99s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LM5epqrPKqSFwJ9QHgHMn7I+tCQ+5SVLoilapiShmI9grGgqRph2Xcc3SOwNfA4V3
	 8tgMv7nIrkSxZIKcBtxYXGAFqFN8YAF//oXZce0N1vd78UuqX/MvzhC8WuNiBa/C0Z
	 oXrC3ngim/1C8weOCpqfB0hpG/HQQPFwcBrGFlf4=
Date: Mon, 10 Nov 2025 10:00:59 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Youngjun Park <youngjun.park@lge.com>,
	Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] Revert "mm, swap: avoid redundant swap device pinning"
Message-ID: <2025111053-saddlebag-maybe-0edc@gregkh>
References: <20251110-revert-78524b05f1a3-v1-1-88313f2b9b20@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110-revert-78524b05f1a3-v1-1-88313f2b9b20@tencent.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 31CE416000B
X-Stat-Signature: y1obkdje6npz3nzx4ij4sww138rbo13e
X-HE-Tag: 1762736464-151737
X-HE-Meta: U2FsdGVkX19bDLKbuWh8dAaE1JkARtQYDyzP/3yAffsCOeHXqWLotep1Pb0MO0jaVGEQB/qZsgkttid5SZdpuJsVpT0U/v3wJEiiTiarVG7KzuPWz8M5Nxvl0LSlpmM1njtioG4QDEMncTs9sBiCN1uYWm79aQmvmWnUXla4Pf+PaKuGU6J9rauFclm/04koLG0JQWxAiIVa/cbSgLTI6FGa+zh4GD84gBVKze60aLoAxlSkBrgUPN1QNAD75gmD0+1PChy7tOiVgFC9VPCO+YtD9FsDfGoEnlAQtXCt08ASWgAvmRbycKZl/0momt6BDPbGn2bC1b+e2slg7Df58z9+AwF13u8E8tcET1zWLsDHvhepiOFarSMo2r0+t7cdVWQHxD8sr0o0b6RdrznDJPnLz/HuiJrFmAydxDYW2+ZusBuPQgoRVZDKdfaJUaf5MA/H7mbbOjfcW3sIKAE2pFYmUC+YWfIsjco5xKfpUFR2rFysGPfwmDiOD8aYaBTwVwR1Bu2s5D7yFG7bY+VU7vySyehX26koLXkdiWGToHXHz8nVvFrm8CfRUnkprmMajeV1SlOD0XX7RQdgWIE+yzljSbbAB54NnlFWrErYSd+aqQ4tnmTyvFmajht30glZ4fWLTlzz0rejJ5FHIJ9hueYzc0+8d3F4HY26ytq5ERj0Fksckr52MqU5qDwpOPvsfPnDLp91Sve0yTFaJsTFyR/DDQ4nYJxIA53t2xhl1HBTxNgHAreeNSoEGlTGzgDf5xcZo+geXRxQW8Qr7JuUkHjYKEAEy9kziHJnISHG48u4fW+9H8Lp3OCtb0hHIyuap4GWVtOSDVeW/pLGCWKw+3C8nJbSpmkyhYhO9SsPnNqG6Uzi6QUwhojAcLqvCZfa+SyZ53P21M/zLIyEf7NTqoo/3FDM/x3SEiwXFEwfoVlxovW5iaNUWD4+/ywqvrGBtRx6cAiYoYrxlh1P7ol
 iOTda+Bz
 4GOGi6G+2E5l09GPY0EsSXLmN3N8YQmeyPeW39zw+6zmqjt6MpLtRX3D1wpog+jphe6JaHCSAw8Fv7UEDjJE1D0KHtQGQu1PDeaQg+8DxxLRYL6b4qgxlmTvW17y3re9l/yOKPQPbQdYdRM3rVyOEfDZfA2GhvGW169PpciknFSEqWZ3dwW7jb87fzK4AlJ5Pibvd72zNyeyMiUukOZNt4fa3HYG71Nq72mHa+RorVu6jD0KdXXiECvo97hPDc3t4Krhnwod3yrVHNYEm+ahKJ+/96vMlnw0nsLCseLgmeOPNjqZge/gMT8FnwHBgpezC832f+VtSRTQ8gnKY7v/w6QlvoVsKQzK5IzAxkDifTmT7ftnAp2zWTuD5OEGc3WRPy/BKVrmdX2ZbedXZHZddTwqqygxCh2EnZdTi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 02:06:03AM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> This reverts commit 78524b05f1a3e16a5d00cc9c6259c41a9d6003ce.
> 
> While reviewing recent leaf entry changes, I noticed that commit
> 78524b05f1a3 ("mm, swap: avoid redundant swap device pinning") isn't
> correct. It's true that most all callers of __read_swap_cache_async are
> already holding a swap entry reference, so the repeated swap device
> pinning isn't needed on the same swap device, but it is possible that
> VMA readahead (swap_vma_readahead()) may encounter swap entries from a
> different swap device when there are multiple swap devices, and call
> __read_swap_cache_async without holding a reference to that swap device.
> 
> So it is possible to cause a UAF if swapoff of device A raced with
> swapin on device B, and VMA readahead tries to read swap entries from
> device A. It's not easy to trigger but in theory possible to cause real
> issues. And besides, that commit made swap more vulnerable to issues
> like corrupted page tables.
> 
> Just revert it. __read_swap_cache_async isn't that sensitive to
> performance after all, as it's mostly used for SSD/HDD swap devices with
> readahead. SYNCHRONOUS_IO devices may fallback onto it for swap count >
> 1 entries, but very soon we will have a new helper and routine for
> such devices, so they will never touch this helper or have redundant
> swap device reference overhead.
> 
> Fixes: 78524b05f1a3 ("mm, swap: avoid redundant swap device pinning")
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/swap_state.c | 14 ++++++--------
>  mm/zswap.c      |  8 +-------
>  2 files changed, 7 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 3f85a1c4cfd9..0c25675de977 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -406,13 +406,17 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>  		struct mempolicy *mpol, pgoff_t ilx, bool *new_page_allocated,
>  		bool skip_if_exists)
>  {
> -	struct swap_info_struct *si = __swap_entry_to_info(entry);
> +	struct swap_info_struct *si;
>  	struct folio *folio;
>  	struct folio *new_folio = NULL;
>  	struct folio *result = NULL;
>  	void *shadow = NULL;
>  
>  	*new_page_allocated = false;
> +	si = get_swap_device(entry);
> +	if (!si)
> +		return NULL;
> +
>  	for (;;) {
>  		int err;
>  
> @@ -499,6 +503,7 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>  	put_swap_folio(new_folio, entry);
>  	folio_unlock(new_folio);
>  put_and_return:
> +	put_swap_device(si);
>  	if (!(*new_page_allocated) && new_folio)
>  		folio_put(new_folio);
>  	return result;
> @@ -518,16 +523,11 @@ struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>  		struct vm_area_struct *vma, unsigned long addr,
>  		struct swap_iocb **plug)
>  {
> -	struct swap_info_struct *si;
>  	bool page_allocated;
>  	struct mempolicy *mpol;
>  	pgoff_t ilx;
>  	struct folio *folio;
>  
> -	si = get_swap_device(entry);
> -	if (!si)
> -		return NULL;
> -
>  	mpol = get_vma_policy(vma, addr, 0, &ilx);
>  	folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
>  					&page_allocated, false);
> @@ -535,8 +535,6 @@ struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>  
>  	if (page_allocated)
>  		swap_read_folio(folio, plug);
> -
> -	put_swap_device(si);
>  	return folio;
>  }
>  
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 5d0f8b13a958..aefe71fd160c 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1005,18 +1005,12 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
>  	struct folio *folio;
>  	struct mempolicy *mpol;
>  	bool folio_was_allocated;
> -	struct swap_info_struct *si;
>  	int ret = 0;
>  
>  	/* try to allocate swap cache folio */
> -	si = get_swap_device(swpentry);
> -	if (!si)
> -		return -EEXIST;
> -
>  	mpol = get_task_policy(current);
>  	folio = __read_swap_cache_async(swpentry, GFP_KERNEL, mpol,
> -			NO_INTERLEAVE_INDEX, &folio_was_allocated, true);
> -	put_swap_device(si);
> +				NO_INTERLEAVE_INDEX, &folio_was_allocated, true);
>  	if (!folio)
>  		return -ENOMEM;
>  
> 
> ---
> base-commit: 02dafa01ec9a00c3758c1c6478d82fe601f5f1ba
> change-id: 20251109-revert-78524b05f1a3-04a1295bef8a
> 
> Best regards,
> -- 
> Kairui Song <kasong@tencent.com>
> 
> 
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>

