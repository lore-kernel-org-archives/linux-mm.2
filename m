Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C06E9C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 04:08:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A6EE6B008C; Tue, 21 Jul 2026 00:08:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 956E76B0092; Tue, 21 Jul 2026 00:08:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86D9F6B0093; Tue, 21 Jul 2026 00:08:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 61B786B008C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 00:08:05 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CBD6EA03D4
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:08:04 +0000 (UTC)
X-FDA: 85011450888.26.99BF88D
Received: from lgeamrelo13.lge.com (lgeamrelo13.lge.com [156.147.23.53])
	by imf14.hostedemail.com (Postfix) with ESMTP id C913B100002
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:08:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.53 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784606883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YEi3wXu4WM8zA3u8MccSHfayyhRnFPcunkb27C81hUI=;
	b=i9WFfcrzi5Qjc6b6XoQLJzWIABIfYlyPGNNgKiby2NA2MFD86MtXVOo7wAi4Qv7OpQXYIS
	vKbVS6iD8apOZnjUabMyHI03XvzHw/p3jJA3d1CIxNfmdc32L2zQmpKRDw8msQJsttxAMY
	Tb3V3cPevBkaJvBhMvv5MnJaRM2zREM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.53 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784606883;
	b=ByLlBkayUxot++14ZQF7NatquwFORDRz5pl9sE35Wl1Dsqi6EE18/dIqAXOwi3UX4QSEzt
	oHAB3WdYLVGED+7LGtsQ5V9jJ060mrRQ6fqnapV9Yi3D+NbZVP4w+n+8Fr20mKlmc8US2G
	fWzikJp24bAlLm3Pdf1v8y9yXf5GUNg=
Received: from unknown (HELO lgeamrelo04.lge.com) (156.147.1.127)
	by 156.147.23.53 with ESMTP; 21 Jul 2026 13:07:58 +0900
X-Original-SENDERIP: 156.147.1.127
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.127 with ESMTP; 21 Jul 2026 13:07:58 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 21 Jul 2026 13:07:58 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: chrisl@kernel.org, kasong@tencent.com, nphamcs@gmail.com,
	baoquan.he@linux.dev, baohua@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] mm, swap: return early from
 swap_extend_table_try_free() on first non-zero entry
Message-ID: <al7wnpZaIEA8BzOb@yjaykim-PowerEdge-T330>
References: <20260720071342.50742-1-shikemeng@huaweicloud.com>
 <20260720071342.50742-4-shikemeng@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720071342.50742-4-shikemeng@huaweicloud.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: C913B100002
X-Rspamd-Server: rspam01
X-Stat-Signature: q87igs76umipf1jo6eydqzc4kfcubn66
X-HE-Tag: 1784606881-583748
X-HE-Meta: U2FsdGVkX18C1/Yfj2Lv8EELG743BgnjwyxDd+qEOtNYv1cEe53F4cMe35FbQGO6piGVpdAJvdP9cCRrSBh/z1x0sRmuwga7bP4rNjnC9Txpka3TNcGKtY2kEF15A6yEbZO50w6vaTd7maDWAchxQvghfpa5G5oCEonLCo6NHtupE+7zMMeH7o5GOPMz+zBoYupjNsH4+3edtcb5mF08L1opEuUN+DexKRRrektETvxdG1JV1bjhTu5ha2R7ioILGoPZdJlPzaCZoT92GcVQhbdIg1K8VLEkuAHPcOWwrEPkCOsYndPfydRTZD54ZPAXx6GMC92ZczlCzXFGX9CFTP12rLjz1Z4CJnfoX2zfMPGlZSbzif0yxdIOGSJZQl0oWXOpqIlL57un9rytNfeukFfyWAb5CIXje26TKB3dl0qgftn0xMjOKWuJ+vqurXEGq658MwD4FcxF433TPXtBQD3IMCinCsDV38ygj31zny0QcaQo9sUsHkEFdLG+wTfgaSWzdpIrVwNPX+E2QHiQZRBTeQBXpWo/gWtxaIaurF8jB+HyXPzRjYP6OaUdxGmQTDn+Ee5q3vvI5GV6xhjfzITTFcdNLbJzz3DALdRmJHL5E32LJfmWiU5eb0eqJnx7kTxXNers2fRSrfqXi0eK3Y3Rz5LITYgUTHNhyjbiOrxFJg1BCyIfWdXN4lfgzXRwGCJ1IsO1qlVqbPrNKYbtZ3kX5hhqmYLnAeNQrDJlWvaciLAnCxH2E8G8rJF+kOMvtHSN9HDNsn9QShQwau8W/2Co2Nf5otrVOmP3BQCNYU5/+o6KmXNhr0zO4wgl2WWM27hO1d7qb0N3F6MpuF+elY4T/A5oBEtUJgkDHPOOT3bEP0KOBQskq4CeOloiMb7374Xk+W2PdgRgMRnV3aRuAvNbTgzaPjfY1hfFgJLU95jAZLV5ZBuTuUIlqMC1muboUGQndz4OF0HadUJMoZx
 0XEC8vB4
 Q1RIeVRaZZckAYbiF33QO5NkE4jgn/5lUumHJC3hvzGB26xc1scPIo6iJjCtPyw/8I8A7uUykeBr95PULYrT2ta7GN6PbRHNtTXJQzjiBlJiTwAXyYRhP959UiF62lcNaxU+cqB4btUOATsAsUDJkEoU8eFuhF6ztdrWCY2hha114pOc4S05Awhebg+DF+qtQeA6655mh9zbATYzRlF+irkINySncqNvYi5D3DbNqbkCvVNxscmR6VBnFT4WXhkIi2692z9A26FJjOf+wyHLHcNUFxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 03:13:41PM +0800, Kemeng Shi wrote:
> Return immediately when the first non-zero swap count is found as
> any non-zero swap count prevents freeing extend_table and further
> iteration is pointless.
> 
> Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
> ---
>  mm/swapfile.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 81c4040912be..3fcbd10c6353 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1530,20 +1530,17 @@ int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp)
>  static void swap_extend_table_try_free(struct swap_cluster_info *ci)
>  {
>  	unsigned long i;
> -	bool can_free = true;
>  
>  	if (!ci->extend_table)
>  		return;
>  
>  	for (i = 0; i < SWAPFILE_CLUSTER; i++) {
>  		if (ci->extend_table[i])
> -			can_free = false;
> +			return;
>  	}
>  
> -	if (can_free) {
> -		kfree(ci->extend_table);
> -		ci->extend_table = NULL;
> -	}
> +	kfree(ci->extend_table);
> +	ci->extend_table = NULL;
>  }
>  
>  /* Decrease the swap count of one slot, without freeing it */
> -- 
> 2.36.1
> 

LGTM :)
Thanks

Reviewed-by: Youngjun Park <youngjun.park@lge.com>

Youngjun

