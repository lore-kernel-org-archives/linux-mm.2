Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C321BCD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 03:33:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0084C6B008C; Wed, 20 May 2026 23:33:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F22A26B0092; Wed, 20 May 2026 23:33:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E386D6B0093; Wed, 20 May 2026 23:33:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D38466B008C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:33:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 75ED41404F1
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:33:09 +0000 (UTC)
X-FDA: 84790006098.12.9E6D4BD
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf20.hostedemail.com (Postfix) with ESMTP id 705E41C0003
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:33:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=If0BSl8f;
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779334387;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uLsSWCAJMatsJJglI8Dr+/M1gsP2NlCoju4XiTRtItA=;
	b=INnNfUupJjGQgOA0QyWRMJC2/XEO6Rt/ySWJDJleMgpRe+YvDFkJsQ+HvRzRx6zcOXCRRn
	W5Ws/VWTos/QGbXkxGxeg73spN0LlRgdFE42Ij0tdsMVHQ4J5hpN2vCnuwgSgzAiufj4dq
	g9LWtDHGzp0DqF0TCpVJwYPRw7xoVh4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=If0BSl8f;
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779334387; a=rsa-sha256;
	cv=none;
	b=GwxYtGwIZ5AmgLO5Vjzp2vBLyWuXnoXjJ1JjCSzig2vBBSOiZs959wQZi+/5HTvC3bfx16
	T0MPZphOq4mwBG65bBsdT1/YGvCKOXUx7s7GruKdhxogfi/K5ZGdg6jUjkUR259M/VmgVB
	4UFbVJN4yl6pEuZggyEIT9O1ftHvZK8=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-670ab084a39so11506053a12.3
        for <linux-mm@kvack.org>; Wed, 20 May 2026 20:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779334386; x=1779939186; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uLsSWCAJMatsJJglI8Dr+/M1gsP2NlCoju4XiTRtItA=;
        b=If0BSl8fFsxahQWFy6BRmL4Ho8OYUTBu1uf3fioPRHtliOfwQed3hTVhqHshAFAmp+
         xHMle0A31574dHFyiE6K7E4GlICJSaR95W49svHcVTTJvQvVb/WMqv+7stSd5/ZOwIFU
         WvyslfsmCFjf8Mc+4ypN7V9H6d+3GPVoOibO9BI4uGDxYqBIi7HDiVAhlXe4VxWt7Qxd
         E1mNP5VvBFtdcylcTChNHOhgWVN3Rf059ioxYErVQiB8GQYF6hWth0Fq5ZBQZg5Fphrt
         WcGCg2Fmebo7y7PKF6vcQSfVKSAxi/BFUG4hSWlikfdE0gLee1RWl5NfUI59SHymeAcG
         Pj6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779334386; x=1779939186;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uLsSWCAJMatsJJglI8Dr+/M1gsP2NlCoju4XiTRtItA=;
        b=BP3mWVCpqGZLTfyD76GyuRh/g14g0nLLQtXa4w+6lQ2qwZ/w93uHC7sBslkgwBJyS3
         9dvLacFc4TBomsHUBR+LjKIjXrk/jiDHul1+iO7ebHSBzGTEQU0WmKXSeFt7PpF4FFH+
         BAxBi70X0U6gXYtvjI35K1qaZDqbRbhfR/PagnO8nK1s8z4jRuwizetDJDTcrdjKq+11
         2fKnKz5BNe/T+sJHRxpFp671YANoaqmzA9BjGxWlf+VCGffhCJ3I3XIlq0E77fLTpPnl
         vQEnMlnYrEuAXwhD1EodZg/PKq+L4iNNKn7UGNBd9ygzJeCxr7qiUycQAnRLtH2uiVEb
         HsoA==
X-Forwarded-Encrypted: i=1; AFNElJ/lUDcNl8aCT6fJy0H6XmRmmvvus6Io5n2gKlUwndu0GAfvRx88fpZ872BZjnhW5lrho9lR1X57Qw==@kvack.org
X-Gm-Message-State: AOJu0Yx3Y2P5TtlpqymmblHGFwiOFEqvDckWwrR4QzmkZtr03BfNAqxo
	MiQTsLKKCg8xY5a7AdLc1uPegUzWFdrLauWMm3GNklSEuCabIpPQd5BL
X-Gm-Gg: Acq92OHsQCVuk2hguVFEI9ULFuV/WHndNJS8QwvotWtkQDImqa9gSs1ancA8SQnfzXe
	lR/qXmKsOdS+I4Z7ZyX/AENXNWKlpFnbAPLAi1pYEKMJaFb13Y8M+6Ovk0k5PH7t/txxy/PPJ3C
	TkOaqsf1oxnll8naOXGap352rZzOrDQpUN76VDfVurg/9CJ1Aao/lx2WKKU87IC4KNs0wQiXc5f
	uAQ9yikIHXRHHNNioAdDeQc3mFA6nekNgBL2rhX/gN3rgjDXKcgXu++aZ24sp0dCgPvLttrRK0/
	ra5iu2uOB7VGGkxbbOHzlAFN0R8arbB15ppbHPUhPZWl82F3U2pnZJNsWjsK82kRMG4B1Cx3IuJ
	yNIik4P2kuBjl66cPLgnuQgbkJdHLaSniJI4rgVSu/yZiMgGC9deGtibZOB3qZY1wg+YHbQrrxv
	dzQ0PA9SWdd55Y0Smah2Lx5A==
X-Received: by 2002:a05:6402:2343:b0:687:325e:748d with SMTP id 4fb4d7f45d1cf-688363dcabfmr376916a12.17.1779334385781;
        Wed, 20 May 2026 20:33:05 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-68311670a00sm8382754a12.20.2026.05.20.20.33.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 May 2026 20:33:04 -0700 (PDT)
Date: Thu, 21 May 2026 03:33:03 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Yuan Liu <yuan1.liu@intel.com>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	Yong Hu <yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>,
	Jason Zeng <jason.zeng@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/5] mm: move mirrored memory overlap checking to the
 outer loop
Message-ID: <20260521033303.7jg66h4sxwi4l3cm@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260520093457.3719960-1-yuan1.liu@intel.com>
 <20260520093457.3719960-2-yuan1.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520093457.3719960-2-yuan1.liu@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 705E41C0003
X-Stat-Signature: hhjsyzsab84u8bme98phi1xu44zbuw9q
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779334387-333853
X-HE-Meta: U2FsdGVkX1/R3U1U646ulHusrgwHSkTcXzFowFXHUxEhaEC09/cFnqzjnNz7bNKiOYcT6HnGF4PBL+b5jHPj6/FRT/bS5W0ZNSAYIBQfshFxETAD2gZx4eU0yAhPJk/qG6t97rJlgYZhAtzhgw24gK5XBKgRzHJ+skBasGgUGdpdVgb/brhXogOr0126t52RSy/1m7z7dOtaMN6Nj7NNg6vdoCht9p7t4+ywMGlq5DdEEqi0yodR5beqDiiNn+QEZrvhGDCFS5GzaBu1obt6VOMWHRMGd9j+baN6hKqMzxxlPski1KCA/zgiP57lDWynNKryDEcjBx+9qtOtHmL2Zt76Zr1HIYk5XunGogf2NoDlSXNCyhxhddeF2Ww6RpuUbOmxgP5Nk+rLCpxea4kE8b2IRO0bAxmRZJzvOusev8vsE+ch6/AyLaLdIwTfy8rf8j54ay4EpQriLCiLBjzI2e6VKxfGldBhwXrUCDcO9lgdd+D3Vf/bfMNih5+yzJIl2x0fYJs4AHswxEZ2ToE7UuFdhUb9JtiBs6vpmRZWKHM0CajkC9O+RxbBiXXuQf3BXH9KqZ0cMQtfgSlJWU1Slp33CNBVO0cVXv03uu60dleDpRBzu0F8dGd1HIYr0AgFNMDPcRVxZhX8a1GhzxJmeA4tgS1xZS+hKAbRNTDvGPKMwmvqKc0HjHRs9l/Bu8mg7dLsVUWTR7b/g7asS+BIkyhIxk8C1hYqN8Ft5Gjlc4Vxzaae3VDbDT7BdzPuUcHX3esPRzKvIUCid+7ZUs46UxPpKb24B74Qh8eLp7Q5swgBYBCvq4CTq4qYT6AI+n8JaIyUFdpQhr/09d29t+4+gPuK1dfGiV426I9plP8xNTuXuU7FZMmQWSN+jBzsbf/LV6t1JN4HZfYX828etZScoRjnqwpUdmxHJOidu8N8VoDkgOwgEOGEckGAUVTvGZV7bTT6F4orGVx0m8Czias
 6eiN5B0M
 JN/Esqj6O5nxeaus0IafjgsuOI+0KJRwSUr8f4apNWLZKcRzK5QxKjS50k5hoLnUdbXh2AoBf+YeJly2PwgcHI/rdaHI7+5i1WTRiec0ZV3ixDkYoMg862lP3nvHr2D1Koah63BS+jisRLSaO4u+5laJm5czSWJRvR7c5Q5Rpw2hy+bbOczMQPGEvgrQkWQypqJcZctH1jgJRiN22YJXIKaK2VpIOsrIYTjDraG323U0iAhZtVwhFit6jDKN0El2D/U+EzfBC73Bk7biB4Ju5ouCdkmYFtR/Eh9h91SMH4PQvcqdmoP/neG6zSTGHhauSngHqYFouTC9vcMbxHs5+jEO2MN5z7eTNR4BECPbtV++F69q4r1KBz1FQlXhTZlG7CSBglCmV1eJHhutI6ZH/itgHkmOtUMC/85m/i6FtRlGmgLyTBRH3zIWYb7cK/XX+yqVbwOM+NqgROc291JmhKn3OGAn/mrzKsjFq9osiB99ttaLd/swz0MWVvGYCf3u55FCSynE5x7qMz7c26L1k7SMloo0L4fBKu/krseoxQQvjao7143MLNcEOFthqfRRJZwDLVEt97otABewxofszvn9GRvgeRMxRGMQfkK3YBctvmoFnE7qOBen78wzHhYvGDOT5P4Q+anFW+VVje3SLVq5LEcZZqaA7hP04I8+k0sBhUP21FKLNP6J2ihQFjskhMqLhTt4csUVZxKtEp5XhH1azoTiXhmOwDuVhOcHICYObEek+L5OMOS4OtbKONefj4NfL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 05:34:53AM -0400, Yuan Liu wrote:
>Move the overlap memmap initialization check from memmap_init_range()
>to memmap_init(), and replace the per-PFN check with a memblock-based
>check.

The description is a little simple.

Even I know the purpose, I feel confused at the first glance.

>
>Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
>Reviewed-by: Jason Zeng <jason.zeng@intel.com>
>Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
>---
> mm/mm_init.c | 29 +++++------------------------
> 1 file changed, 5 insertions(+), 24 deletions(-)
>
>diff --git a/mm/mm_init.c b/mm/mm_init.c
>index f9f8e1af921c..24e103a402b0 100644
>--- a/mm/mm_init.c
>+++ b/mm/mm_init.c
>@@ -783,28 +783,6 @@ void __meminit init_deferred_page(unsigned long pfn, int nid)
> 	__init_deferred_page(pfn, nid);
> }
> 
>-/* If zone is ZONE_MOVABLE but memory is mirrored, it is an overlapped init */
>-static bool __meminit
>-overlap_memmap_init(unsigned long zone, unsigned long *pfn)
>-{
>-	static struct memblock_region *r __meminitdata;
>-
>-	if (mirrored_kernelcore && zone == ZONE_MOVABLE) {
>-		if (!r || *pfn >= memblock_region_memory_end_pfn(r)) {
>-			for_each_mem_region(r) {
>-				if (*pfn < memblock_region_memory_end_pfn(r))
>-					break;
>-			}
>-		}
>-		if (*pfn >= memblock_region_memory_base_pfn(r) &&
>-		    memblock_is_mirror(r)) {
>-			*pfn = memblock_region_memory_end_pfn(r);
>-			return true;
>-		}
>-	}
>-	return false;
>-}
>-
> /*
>  * Only struct pages that correspond to ranges defined by memblock.memory
>  * are zeroed and initialized by going through __init_single_page() during
>@@ -891,8 +869,6 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
> 		 * function.  They do not exist on hotplugged memory.
> 		 */
> 		if (context == MEMINIT_EARLY) {
>-			if (overlap_memmap_init(zone, &pfn))
>-				continue;
> 			if (defer_init(nid, pfn, zone_end_pfn)) {
> 				deferred_struct_pages = true;
> 				break;
>@@ -956,6 +932,7 @@ static void __init memmap_init(void)
> 	int i, j, zone_id = 0, nid;
> 
> 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
>+		struct memblock_region *r = &memblock.memory.regions[i];
> 		struct pglist_data *node = NODE_DATA(nid);
> 
> 		for (j = 0; j < MAX_NR_ZONES; j++) {
>@@ -964,6 +941,10 @@ static void __init memmap_init(void)
> 			if (!populated_zone(zone))
> 				continue;
> 
>+			if (mirrored_kernelcore && j == ZONE_MOVABLE &&
>+			    memblock_is_mirror(r))
>+				continue;
>+

So you have figured out the memory layout of mirror memory?

Would you mind elaborate?

> 			memmap_init_zone_range(zone, start_pfn, end_pfn,
> 					       &hole_pfn);
> 			zone_id = j;
>-- 
>2.47.3

-- 
Wei Yang
Help you, Help me

