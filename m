Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0FBCCA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 02:39:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DF186B00B1; Sun, 17 Aug 2025 22:39:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 390176B00B2; Sun, 17 Aug 2025 22:39:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CC936B00B3; Sun, 17 Aug 2025 22:39:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1ABDD6B00B1
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 22:39:26 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C3DFE1A0816
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:39:25 +0000 (UTC)
X-FDA: 83788321890.27.0AEC500
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf11.hostedemail.com (Postfix) with ESMTP id D956740004
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:39:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m1W8EUmg;
	spf=pass (imf11.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755484764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/KGmZRweKUDZ2JbdZthO63Ztp0At0JtBfciRWpCzRtA=;
	b=wVscHdihKthiuZyWhJtuZ/hI4v8vOtC0XGFPLQJJdw6z5BqbYKcYuxKoYrxqdyHSXJQlqW
	6+QMBPGN4vTfIuWnReAv2jQpmNzcFwdMRmFYUahF2zLXp3KWbChLh5WWIwVd1VFQxmFVAi
	z/v8PkSgJ+sFOWsNAdhJvavWaCLWLF4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m1W8EUmg;
	spf=pass (imf11.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755484764; a=rsa-sha256;
	cv=none;
	b=4yCXzZA8PqZMXvVWVfQ1V61TXqU2E1j+Ne+nc1xdP8WM6cO5qGCjemVL2y5mcrE8TAgrt5
	7dLKUTZxLniJXewwzEUjHgv7o+1pqAiDSUWwu5eerQX5gsWecvYPTNZQU4oozhAG/rbNSB
	faqudA02YzIRxYuESPaH2kPQkrSe6kE=
Message-ID: <b365c8a8-efce-494d-b57d-b0aa334d73ca@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755484761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/KGmZRweKUDZ2JbdZthO63Ztp0At0JtBfciRWpCzRtA=;
	b=m1W8EUmgYYFK5ejswzI+sIVEQVjMaWZahYjv3dXqmBZSBnoCZ91vRWABw10wfZz9EbH/dd
	ac+eXLjREpFMV7lHKnLY9kMv34hcXFHcZ2fx/FnacQadIjNsSnf9l1pgOkJbH/6WZZrb5U
	V0qm9GzvjYfxliV//Yar8DDNOTp7CVs=
Date: Mon, 18 Aug 2025 10:39:14 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm:fix duplicate accounting of free pages in
 should_reclaim_retry()
To: liuqiqi@kylinos.cn, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250812070210.1624218-1-liuqiqi@kylinos.cn>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <20250812070210.1624218-1-liuqiqi@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: gx1x3k5njdp7kcwbw983kpkzrqecusa4
X-Rspam-User: 
X-Rspamd-Queue-Id: D956740004
X-Rspamd-Server: rspam05
X-HE-Tag: 1755484763-16381
X-HE-Meta: U2FsdGVkX19dmLSgWfyIvT21iR6n0P3fkkbuecwmFIWJ0WnyRwuHpR29wqdEI8f1o4hr+jThXlwKfhKpdC39+tASfdxQomh5FCqZ9Qbaa6eISeg2XCWm7XivXNPXQBXMqg+vGCw5h4m3PWCq/PVBlXgYAPOSzNOpRxQ37luH4Zfhx7tkjMRF70y61oFJANngXTJjKhSmZkI9KhC9/H4UE+GzNedCqzRWbiU44RFNPWvQDlSXGLvvrfjz8MF0rvn4LF1SGtsIdAkt4ce8qf+2KAI8284W8DHP1dhMRdhd82j/w8/YK4HNB8pHI7iOHmeHyUJn4hf5xFkuy6X5jlncw6rNZhqsVwFt7kX/iv10apt4v3odS0c1wRuDERT++AnpPyMqOIU4sI9IzAD8TLVyGwvVCQ8DP7VvJZHCoIG0Rdj2WpiY3xVT2L08whk6AsEg06VuQDdjdH+GdZJl7MJRTZbcyiZhpxF1pFM+NicSh3LrSTbTga/qA6adsLlPBvvzoBpi69mI/d5Bx/OiI7Bzj294I9pe7KY5dT2iyQ4A1K6GeBkq0KCmdaUgI4g1IzYC+BL4/O7SDiehT45Mm7oowdSG3HlBwcaixllTa5TmiPUe1A4R2mgJWJSaSFbXuqiiditgVcVmYGFJembQx0f8u/ZiIFZZDz4sL1Myvd2/AJC5DzMbsDvr+tCxQAQLGWgsTDDEXH94CXFI55hUNXwERC4c3awu1Fs9MtE8jwWfFORTtFFJZyiYXyd1CFr9n2vVWFIE3aWx/hbNhzE7ow5Ri/taj8iDAnheCKK1NSrdyaXRG2hAeXF5jXPXAIYQ7dR93JKSyCO1/x9/CWmlMTI0AsMvD6wG5bPLo3qsXkfXMv/IrgGvMS4gnH3/Lf5pLnFIjsFOL7YuvZ8XG9krKMQsge9TNF7fQ2VJO1QL3Qrty+EjzJlqxxkrVhFSNbhxH93kBF2SgsC2pQpzDiPmcM1
 yTmTeijs
 eNyQUQTYc492c8smjIIRoVh4GuHO9UUaybaKT9jYkTE2qWq+ScwxDbTBzeueUqCp5WthjwggjKxgqtTPaYqoqP3mglUGYHH4/ZS6muKDDDjpXeEW6ozu6Q30Ywttdw5QxZYSVDEvT98tqHkiuaJriJ06I2SRjGZLlnnSdOIlTYM0Q9StwJq8btWN+jarDWXn7zvVnkJznSbyKV3YBsZroHxCuz8AThq1bRwoHf4EHcAy/EQlHueFvBgDoMHYsvXUyvazsHZGfFUz49GgDn4/kFFw/SA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/8/12 15:02, liuqiqi@kylinos.cn 写道:
> From: liuqiqi <liuqiqi@kylinos.cn>
>
> In the zone_reclaimable_pages() function, if the page counts for
> NR_ZONE_INACTIVE_FILE, NR_ZONE_ACTIVE_FILE, NR_ZONE_INACTIVE_ANON,
> and NR_ZONE_ACTIVE_ANON are all zero,
> the function returns the number of free pages as the result.
>
> In this case, when should_reclaim_retry() calculates reclaimable pages,
> it will inadvertently double-count the free pages in its accounting.
>
> static inline bool
> should_reclaim_retry(gfp_t gfp_mask, unsigned order,
>                      struct alloc_context *ac, int alloc_flags,
>                      bool did_some_progress, int *no_progress_loops)
> {
>         ...
>                 available = reclaimable = zone_reclaimable_pages(zone);
>                 available += zone_page_state_snapshot(zone, NR_FREE_PAGES);
A "fixes" should be added here.                                                                                 
Fixes: 6aaced5abd32 ("mm: vmscan: account for free pages to prevent infinite Loop in throttle_direct_reclaim()")
Reviewed-by: Ye Liu <liuye@kylinos.cn>
> Signed-off-by: liuqiqi <liuqiqi@kylinos.cn>
> ---
>  mm/vmscan.c | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 34410d24dc15..a9aaefdba7a2 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -393,14 +393,7 @@ unsigned long zone_reclaimable_pages(struct zone *zone)
>  	if (can_reclaim_anon_pages(NULL, zone_to_nid(zone), NULL))
>  		nr += zone_page_state_snapshot(zone, NR_ZONE_INACTIVE_ANON) +
>  			zone_page_state_snapshot(zone, NR_ZONE_ACTIVE_ANON);
> -	/*
> -	 * If there are no reclaimable file-backed or anonymous pages,
> -	 * ensure zones with sufficient free pages are not skipped.
> -	 * This prevents zones like DMA32 from being ignored in reclaim
> -	 * scenarios where they can still help alleviate memory pressure.
> -	 */
> -	if (nr == 0)
> -		nr = zone_page_state_snapshot(zone, NR_FREE_PAGES);
> +
>  	return nr;
>  }
>  
> @@ -6417,7 +6410,7 @@ static bool allow_direct_reclaim(pg_data_t *pgdat)
>  		return true;
>  
>  	for_each_managed_zone_pgdat(zone, pgdat, i, ZONE_NORMAL) {
> -		if (!zone_reclaimable_pages(zone))
> +		if (!zone_reclaimable_pages(zone) && zone_page_state_snapshot(zone, NR_FREE_PAGES))
>  			continue;
>  
>  		pfmemalloc_reserve += min_wmark_pages(zone);

-- 
Thanks,
Ye Liu


