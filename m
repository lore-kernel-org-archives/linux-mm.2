Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD756EFB811
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 07:48:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42D966B008A; Tue, 24 Feb 2026 02:48:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 405876B008C; Tue, 24 Feb 2026 02:48:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DD5E6B0092; Tue, 24 Feb 2026 02:48:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 17F496B008A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:48:45 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B330C1C4D7
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:48:44 +0000 (UTC)
X-FDA: 84478573368.29.965173D
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf20.hostedemail.com (Postfix) with ESMTP id 341971C000D
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:48:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf20.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771919323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2WAjskGqB9628fznyGO9lB+1gzxmnIE6adtDnm1O7Vw=;
	b=7EVRGGJ66swKzXl7d7BCw68I3wwip49ITTworsZUPPYealBSZOvPoP2oicNVZzutkNrC5O
	7QByeFLmru/YIwIWx0s9Kw3haZkjeVk9I9cQ5cIAVeOgdVgVKHCoZfzj77mPcWvTLspC05
	KeQKOxvoRkcqdldPZT+z1X1pg/Qu+t8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf20.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771919323; a=rsa-sha256;
	cv=none;
	b=abPsQeLcPwWd6e7MxfFtTR4fEMskgqqL5n8F0DgUk9okr/XysFDqM95HX/nxWsyCE8+0ra
	0vjdBtUYIa4/zNEkA1sm/WVKJZbBwVQyFDKarjO+86p91EBAy+n1HDXMyUjGhCbQ1we43n
	XPhFnsVuI7pe6hagicYZbUaf6EH3P+w=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 24 Feb 2026 16:48:36 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 24 Feb 2026 16:48:36 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Carsten Grohmann <mail@carstengrohmann.de>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	linux-kernel@vger.kernel.org,
	"open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>,
	taejoon.song@lge.com,
	"hyungjun.cho@lge.com Carsten Grohmann" <carstengrohmann@gmx.de>,
	stable@vger.kernel.org
Subject: Re: [PATCH v4 1/3] mm, swap: speed up hibernation allocation and
 writeout
Message-ID: <aZ1X1OwbAUq1k+C6@yjaykim-PowerEdge-T330>
References: <20260216-hibernate-perf-v4-0-1ba9f0bf1ec9@tencent.com>
 <20260216-hibernate-perf-v4-1-1ba9f0bf1ec9@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260216-hibernate-perf-v4-1-1ba9f0bf1ec9@tencent.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 341971C000D
X-Stat-Signature: u8dnopwjrqaqpuskjsngxgzfsgzb43ep
X-HE-Tag: 1771919320-463102
X-HE-Meta: U2FsdGVkX1809LTfhv2fvUFZnmtzw3mTX9asQODOBxAzxm8SIyvGxxHtlGRAkj58XY9+WTijTsJycfJfeK+8353LJvZfyK62d0Ajx1+YV/UuK8crsAdQCTEZKwJYxSNO10ST2QyGVEzvNbj2Pw08rjKukuznlK34xcdS0Ka/EX/jLo3igJuAqDJRgj/lnKPnZcADbVIS9j8ki8ENW4FTIncLObUuIlfc+jy+caEkwrpW6idvdA75/jmt0M2MC87SzdjiIuyTva1KNZlrxkME4XfM+hXCIhcIwcPL0tRUqsXrNTmiHfXicRES2Xj8YWIi8sljoTe7lqhxw2Yntlyq20cujWmL0D/pNXZO2ZH3vSgzB0RdN7hz7ee9ZphGE2RuJo5xY41EP3XO2pgU9HKiTu3d7E22KHhPhgCnLZTnWKKKv4xrNJ8QGaB9RRuMUBN6quMn/+13Wqq+p/84FKVC7CEoNaUV9kBttjQ1/5KeJbWQlKswnkex92uMcexTxikLjcM+HqusaRwxvj2m3gG16sCqPtKK45ujKEhr4FvjQBoe/RRp7HH2XTKxjKKm0J1Rxjrk3gWX3nq9gOuvaOqdgavR7op12thIXqf2YOfBaLkhosm56vxZ7wbWedWiY9x1yTgHwDSDUxu/M0ok81vwPGy7A510CiGxGzyG/k2V7+zCjwLMvmeaa1CR+V8CmjdNOVfgjCttdBVUbEqKMgb1jfkv7cEZoavS8JdKAuNBloUhAl0iUFIuf1CLy/mQWqeAqIJntPoABC56LzyP4ZcaaGy1cMdjo9LvAAbnU3Ef+OubeIHc9o70D6PNMkV+tVYolzqdngnXNDpBGRBsYgE4U8SRMyZCSzN+1s9S1zTTw0qKcsgNxfcaZpfXPojbxdw5qfSQgawHX+MEM7G7ihllWJwgDrAWB4IM8jH+GXeysK+SZrSuveicLhDbEYQbSfoaF/8IBWyRH2MtUN/H2ql
 eqhPwOcc
 D0sJGm0Hhj/kpBr3xbTrI5PlqryreKhLC8K202i1oCihbpvY5G4CzMkXdIobwZ88Ahy7u9/di48K2TnRMVVSceA7nrO8DZOVwCzE9c/YSeVSpQadVOTwH+Z4PJVt8fZ2nDR5ya337nS+NsqgvE8MvdoITxgqqQrttaPztm/oMnfuqjl3vfp+SxHeSi4uFH3skXSQYb9RtKxIAlvXJek2eBkPnQ7RCw40yM6XOMkzFF7B+Lr0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 10:58:02PM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song &lt;kasong@tencent.com&gt;
> 
> Since commit 0ff67f990bd4 ("mm, swap: remove swap slot cache"),
> hibernation has been using the swap slot slow allocation path for
> simplification, which turns out might cause regression for some
> devices because the allocator now rotates clusters too often, leading to
> slower allocation and more random distribution of data.
...
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index c6863ff7152c..32e0e7545ab8 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1926,8 +1926,9 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
>  /* Allocate a slot for hibernation */
>  swp_entry_t swap_alloc_hibernation_slot(int type)
>  {
> -	struct swap_info_struct *si = swap_type_to_info(type);
> -	unsigned long offset;
> +	struct swap_info_struct *pcp_si, *si = swap_type_to_info(type);
> +	unsigned long pcp_offset, offset = SWAP_ENTRY_INVALID;
> +	struct swap_cluster_info *ci;
>  	swp_entry_t entry = {0};
>  
>  	if (!si)
> @@ -1937,11 +1938,21 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
>  	if (get_swap_device_info(si)) {

Hi Kairui :)

Reading through the patch, I have some thoughts and review comments regarding
the hibernation slot allocation logic. I'd like to discuss potential
improvements. (Somewhat long... lot of thoughts come up on my mind)

First, regarding the race with swapoff and refcounting.

The code identifies the swap type before allocation, so a swapoff could
occur in between. It seems safer to acquire the reference when identifying
the type (e.g., find_first_swap). Also, instead of repeating get/put for
every slot (allocation and free), could we hold the reference once during
the initial lookup and release it after the image load? This avoids
overhead since swapoff is effectively blocked once hibernation slots are
allocated.

>  		if (si->flags & SWP_WRITEOK) {
>  			/*
> -			 * Grab the local lock to be compliant
> -			 * with swap table allocation.
> +			 * Try the local cluster first if it matches the device. If
> +			 * not, try grab a new cluster and override local cluster.
>  			 */
>  			local_lock(&percpu_swap_cluster.lock);

Second, regarding local_lock:

It seems mandatory now because distinguishing the lock context during swap
table allocation is tricky (e.g., GFP_KERNEL allocation assumes a local
locked context). Have you considered modifying the swap table allocation
logic to handle this specifically? This might allow us to avoid holding the
local_lock, especially if the device is not SWP_SOLIDSTATE.

> -			offset = cluster_alloc_swap_entry(si, NULL);
> +			pcp_si = this_cpu_read(percpu_swap_cluster.si[0]);
> +			pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
> +			if (pcp_si == si && pcp_offset) {
> +				ci = swap_cluster_lock(si, pcp_offset);
> +				if (cluster_is_usable(ci, 0))
> +					offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
> +				else
> +					swap_cluster_unlock(ci);
> +			}
> +			if (!offset)
> +				offset = cluster_alloc_swap_entry(si, NULL);
>  			local_unlock(&percpu_swap_cluster.lock);
>  			if (offset)
>  				entry = swp_entry(si->type, offset);

Third, regarding cluster allocation:

1. If hibernation targets a lower-priority device, the per-cpu cluster
usage might cause priority inversion (though minimal).

2. Have you considered treating clusters as a global resource for this
case? For instance, caching next_offset in si(using union on global_cluster or new field) or allowing the
allocator to calculate the next value directly, rather than splitting
clusters per CPU.

Finally, regarding readahead and freeing:

Hibernation slots might be read during cluster-based readahead. Can we
avoid this (e.g., by checking for a NULL fake shadow entry or adding a specific
check for hibernation slots)? If so, we could also avoid triggering
try_to_reclaim when freeing these slots.

Thanks for your work!

Youngjun Park

