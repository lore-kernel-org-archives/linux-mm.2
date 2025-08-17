Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D91BECA0EE4
	for <linux-mm@archiver.kernel.org>; Sun, 17 Aug 2025 19:00:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15A456B00A1; Sun, 17 Aug 2025 15:00:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10BC86B00A2; Sun, 17 Aug 2025 15:00:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 048806B00A3; Sun, 17 Aug 2025 15:00:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E423F6B00A1
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 15:00:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9C15DBADD6
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 19:00:20 +0000 (UTC)
X-FDA: 83787165000.26.4E13BA7
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf14.hostedemail.com (Postfix) with ESMTP id C28EA10001A
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 19:00:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=n3PyGRtm;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755457218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qds2Hi175aEZH6AmJepGrS2VSABSRliWtChM0T7Y5hw=;
	b=aO+S6N74VxKUsT0MG+4rXYnt2r1BVGy3rjSgw+K6Rh0SJDxkkB6/TLhc2+gjTGQ2yoy79b
	Xcnc1hgPtl4wLLFO5Jk5l4ExM2U8wG/javjEsMCQjoleua3R6wHhgNC2Jd43gCIOtRNvJl
	XqflUW090vQTAYUW+ORJqY+jm0tiGKs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=n3PyGRtm;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755457218; a=rsa-sha256;
	cv=none;
	b=0t0xwfucwLDkyLzZQxAFtBNL6ygzm3QNuUVeCtIMWwzZ+TWVSs7qjJcqeIcN7wEXgv35dO
	YaytRtQ83BQx3PdRa/LJcnkMQUVI3plM2XXkWXXmGRXU/6Q833oCTAH3NVNUj6z1L4/xH1
	4aXQGOnG97zeJu64m+/bhWfg+O4EVIs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id AACE05C0553;
	Sun, 17 Aug 2025 19:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3833DC4CEEB;
	Sun, 17 Aug 2025 19:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755457217;
	bh=csRlLWwAyxG0z9swGUI1LX969xN6gyudBnqkJnmj/TI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=n3PyGRtmeAXUTAe/pUJ76L1k5xR1uEZ934ueomG3TwPMOeKePCAseCwTWc9NkFZUb
	 6JTxGToVVVORz5Mh0kc0u6CAlLsBnepzuhrWVHc2vhvivsRsoCe+lMSm2CPkKPW8Cx
	 jYS/+9cd3z4UZisvN9BrPaPDyPLdeL0sF/PFHaqY=
Date: Sun, 17 Aug 2025 12:00:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: liuqiqi@kylinos.cn
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm:fix duplicate accounting of free pages in
 should_reclaim_retry()
Message-Id: <20250817120016.8dcc091c5b7114d6993a29ae@linux-foundation.org>
In-Reply-To: <20250812070210.1624218-1-liuqiqi@kylinos.cn>
References: <20250812070210.1624218-1-liuqiqi@kylinos.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1xot5er5cs1p7kj7rp5omzfn9pzkgcnb
X-Rspam-User: 
X-Rspamd-Queue-Id: C28EA10001A
X-Rspamd-Server: rspam01
X-HE-Tag: 1755457218-535915
X-HE-Meta: U2FsdGVkX18C6KZFBbNlrmSXDcjgwjZdqaUn19LMMCi+gDlzubWwTuXpPPVdayuo6qwfWZ5RjCF1GPAUCb9F5pHSE0Bo3eRxPRSuFDXCVuy4U9ow3EtQQb4/Ofubghn8nrm3H748FCThN2dhk6+eipOA/ItGWsoGUk4kSXq4UPbAJXW0XeouvrieFsCedD8ndXqKtf9Hj4DHdMv9h79aBL/iAkyXWjdnRpj1GZSyireCI/00UWA0DXzYZOu4PZUksoIz27CUc+xjJkL3jXNVs2mLw5myZhhzxAIRxw9eiNH5YmTNSxZs/27p0+R9Yv7kI/DS/mMEoq5NRNs09yj8ZWHTxjitw9gimSAJWWS8J3CgWbHLO0PUhVUdp0Zb8juyDwIyP6vQj/5yK3YngZbMBw5n6vVQikbnCjHB++ENsXFTFFfHJRDbf3mhfNrPSZW3kV7WmKVOpbY/1EDFbyIctZ9RQi/VmyHAWtpEUAvXyk1EbZR202Mpn3bGMFgNcOdmgPtfm5v1bM/PV7v/KqThTPN8WFfVRQVe1vW14GQbus0blCh9FbDwCaJY4xGJV+i0Ebvswln62E3V0yNPomObx+VMCJ3OGY6e5ubUeZsygd/wugEHOijD334OERurB0q2YJZzmm2fa6F2a5I3pd2GjmU+T2+f7KPg7EThYjiz1W8fDR6PtIT4J8KXmEt+Hh0+lZmQ5Zx1H9SlSa2Sc3k7Y6aV5eNIVp6AmbRbOK6yTWYAT2mgSYUkp0VOZn4ebTwh+ThQU0ADVvQhEX5S1D+zGEpBDs4tBG/0KqvXxaNC8axnyyk+lRwe+9fQKXAYghGspoMkLjD6A31N2SYwbzWAJRTkS40JtadecssPn9ZZi/113DzSifW64JlNiDJim9nxS2Mriya+7mJ4M7QZ7WSyEBNLLyzb8EHBfvOdfUwQG3MGOhln+ChU4K3pE7bb8NEQ7FIAKHOcXyBgjcF0ZMX
 mZaJJHNS
 JyoR8+DpppOwzpWQwy/9TYqk79sM8Dj5Gzo+qg7ZCLW0idDf0HPSPHXwRdjo2IsrDaEGcSEfh3KMygETJ2CpFS6AZVmJkWfUyXLlGfDsZwYBplzcnn9dNS+CQ8CD+PvmVeMs0Vh5AAOVgZgkYICCZVMu6D0a1OABr2RF+9uFvHctDnCSfND5u/2APMw9PJJSuFQfIS2IigH628DRO2krhhkOYrb/q2u2HP8I7ofZ/Eyjv3QlvqRyXVdiIGkasIMHa6nLBgDPD36MVLvD0/lpvyF0FuHo3ZcU0iT4YfhdckbwCxYQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 12 Aug 2025 15:02:10 +0800 liuqiqi@kylinos.cn wrote:

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

Thanks.  Does this have any significant runtime effects?

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

