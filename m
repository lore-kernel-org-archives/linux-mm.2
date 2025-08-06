Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8383C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 22:31:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 592FC6B0092; Wed,  6 Aug 2025 18:31:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 543DF6B0093; Wed,  6 Aug 2025 18:31:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 459836B0095; Wed,  6 Aug 2025 18:31:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 364766B0092
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:31:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D412211546E
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 22:31:49 +0000 (UTC)
X-FDA: 83747781138.24.A7D677F
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf24.hostedemail.com (Postfix) with ESMTP id 20740180009
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 22:31:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0vWdZQZb;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754519508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H6ZYfeHGiuZymsYsr00fo099XI4ohwrRn4FFd54cL1s=;
	b=mYNyYSi0MHnaYDWi60MFxu9flMpTrc4SfJAiaBPRpHeKjH3rgNH7iRNETmBMl7iwZ7rdln
	lxTc0GO6/1sGI2lvmCfnz7Nxuy4gF4Wybdrm/2eEd68g3LFJnZAQPCiSKubzwe+8eEqUX4
	WgBrHArKlNX+f9ILuZ51z2Tirgv9SD0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754519508; a=rsa-sha256;
	cv=none;
	b=AKUAk0B4toIyN8TJyJFkTvOPECe+XrfysdC0aMFxoSuvy4zbgsi5UVIUgzwlGL1EQqhET/
	rOQgxqRcVbYo2NdleTAcXGC/QUs+CeEoXQetm7pCyyPRzx7NgAGl+IosUf1liBX9K5+ILI
	i3s/ielAnmqWXFPUBoOz+rjnGNIzWhk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0vWdZQZb;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 31B6C5C5432;
	Wed,  6 Aug 2025 22:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960D5C4CEE7;
	Wed,  6 Aug 2025 22:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754519506;
	bh=T6+uShLeoY6F/m9tC6dyztroVw6fvcKgFR56j+bfdJM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=0vWdZQZbYxNhpejmITKVe/DBQt4Jetkt6LpIKRdMA7af/7GIYi3igR6VNlHLc4RLx
	 QNSAZ9Cb4VXzQonlKiMkFGr63gY2ITaCvdCnn71Qd2g6HeF3VgGTsVJHKfuv1RDuJE
	 YgnTESkgX8U/sOoKL/NmcBu7KCA0dWsIsMdz4LFw=
Date: Wed, 6 Aug 2025 15:31:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song
 <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <bhe@redhat.com>, Barry Song <baohua@kernel.org>, "Huang, Ying"
 <ying.huang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/swapfile.c: introduce function
 alloc_swap_scan_list()
Message-Id: <20250806153146.ee1ee22dc8f6381ff5a6d882@linux-foundation.org>
In-Reply-To: <20250806-swap-scan-list-v1-1-a5fe2d9340a2@kernel.org>
References: <20250806-swap-scan-list-v1-1-a5fe2d9340a2@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 20740180009
X-Stat-Signature: o51kwd54qjezr54zid5ugpf8ds8ic1xd
X-Rspam-User: 
X-HE-Tag: 1754519507-191936
X-HE-Meta: U2FsdGVkX18kXKDldH7tmRlH7uFuiF3secomSBNLc3AU5Ldiez0xF3Mo6oZUwRdkvdhHnlYlcmepVIdadMDrJKp7Y1h1JUHJ/WV28uA3O1oWzZpjruX4oRXPr1RqXk5nmIDshynn5mfoCuvdWpkaeY6jbcHwJ4oVWXA4Wpe1WsLqtxOcHMZRa2ew9LVoB10hlhViV59SdC7ixHyuOSdHCFhihu15TwpTodzeq3w3lIs82fgF12YvaqekgplJtfueS+B0bl3MxhLn+OrYBKIU8CljKqV2YbDsCrMAXrllt7Ce++uduPq2ec2R1xqR7rlI9Locr9xbObmKQTS8Mgg294dhj5OD4VDbL/OjBeD5sEOw1j3jbdZMg9pq1LkpQPROaCgrqLtdcgBiJxMURePm/un5eCtC8TCLKoYxG6Qcdqc325ZyOiNs5EccGsfb6uRRhs/AFvn2K4L5HIfvCZIY94IcVAoiqLggvhVBAQKxNtpu1zXwf/MHLXBF2BwcwztYqsCZIqHM6Rj4vnK/L9w5z/nlT9qoBGK9MgKptcPyl/66GGuwwyILiAwdzddlk1TP1WpApI7yRG5tn3J8kuAerakI1o+FzKDOcz8xpAuP+fHd/skikZrThBrRtHQ1kSwCNBudyq0RxbMnojtQg/cVbTAxBMqKynpygxMTYK3xpDl96ybbPd/tE9wK3d42I/0mzpSVOMm1yGaRgm9w6A/LhTdXP6W9blFsJ54jlkCfEbhBevH5GpND4wWO1BJwY1VUZx2pbJVXz+WA0bBAPItp+oEHRl9eLfSgRdJ3h7vUZX8FJnk19tLyv3DpiooiddY1s6KilpyrnV3NnXQOOmPMS82v+ZDapi+Gx0C4sVofMQhCw6xAgNEqwOGanYpnps6oaNjeB5MJWnSwblAVorsNMI+wvrCSREhqGuvWwFxAodDpIbDlMdMBMKhKFVWpgXR62epi8Ea6dzKohaR9mV5
 5UJR8vVN
 iYAf+Z7JQY571AApKw4VnSY9wtBMDqEf4DVXAO3hiCTEMwbGhnJLxHvQRj6A8+Ml/w5cXlMyvcdwAlGljY+x4ZzVFWonVP59u6V+adirt75Pnd/z5YOaUuu2FIG6eWPHTldYXTG65jV/MpC/Es58VvWusO8sIPIsvVe/VZr2ZLFm2XqGOCaNJ/xqek+2wXcJPME7WlEyCAxg/sh94nyMw13qmuoTatZn9LynMMEJPTVLAAwbvpFJXXzm3rODwbvJX37CQ2ho/mdR/KrrkIO/10CPCf2CI/tQfxMGhNcrkvWi4SP+Qx9YFw8Np7NynU73MmfKa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 06 Aug 2025 10:34:45 -0700 Chris Li <chrisl@kernel.org> wrote:

> This the alloc_swap_scan_list() will scan the whole list or the first
> cluster.
> 
> This reduces the repeat patterns of isolating a cluster then scanning
> that cluster. As a result, cluster_alloc_swap_entry() is shorter and shallower.
> 
> No functional change.
> ...
>
> ---
>  mm/swapfile.c | 86 ++++++++++++++++++++++++++++++++---------------------------
>  1 file changed, 47 insertions(+), 39 deletions(-)

A nice little patch.

> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 4a0cf4fb348d..fcb1e57d8108 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -820,6 +820,29 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
>  	return found;
>  }
>  
> +static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
> +					 struct list_head *list,
> +					 unsigned int order,
> +					 unsigned char usage,
> +					 bool scan_all)
> +{
> +	int found = SWAP_ENTRY_INVALID;

but this function returns an unsigned int

> +
> +	do {
> +		struct swap_cluster_info *ci = isolate_lock_cluster(si, list);
> +		unsigned long offset;
> +
> +		if (!ci)
> +			break;
> +		offset = cluster_offset(si, ci);
> +		found = alloc_swap_scan_cluster(si, ci, offset, order, usage);

so does that one

> +		if (found)
> +			return found;

`break' here.  To avoid multiple return points and for consistency.

> +	} while (scan_all);
> +
> +	return found;
> +}
> +
>  static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
>  {
>  	long to_scan = 1;


