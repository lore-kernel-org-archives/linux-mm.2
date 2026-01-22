Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D048D2ED14
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 02:00:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F38F36B00A8; Wed, 21 Jan 2026 21:00:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F10186B00A9; Wed, 21 Jan 2026 21:00:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0F586B00AA; Wed, 21 Jan 2026 21:00:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CFC886B00A8
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 21:00:49 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6718C1414A3
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 02:00:49 +0000 (UTC)
X-FDA: 84357946218.24.6A2AFFF
Received: from mail-dy1-f194.google.com (mail-dy1-f194.google.com [74.125.82.194])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8AEB62000D
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 02:00:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KztHD1aD;
	spf=pass (imf13.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.194 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769047247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tg0wswL3UiVCyK8pC6Hx23JoxxNi/TA43rjgfSUgEB4=;
	b=3bbDMHzyJJ5LMT78/F334xufB+fDNgHEL/cYbHS6povURaduZTmu4dKOYIvVfEEpYwCEBm
	xBnvrXbxRtZY+4QLr6p7CX7ivRnnVW4FH9EndUd7SxyXX+FoWVsLI/sBtHnL7AZdRGMTx7
	BVQDBqeuwwy13h3ZqEOYpHzVJtkgSe8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KztHD1aD;
	spf=pass (imf13.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.194 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769047247; a=rsa-sha256;
	cv=none;
	b=GbNJfL5DyO4T8OU0aQyAAGisjWqVY0cDhXVGkGq0NDcWUV47XX9OP8XNKh/4P2tAPA+cer
	mhoL4fSJX3iwxGcJt/+1iieqDHegBhLnHxII1QkWrbNnP4J9yMi+JWONQWXxIMjoS5m5+L
	Fn9/e6VtH14Q4Wp/o5X4Wbq37uAA+d8=
Received: by mail-dy1-f194.google.com with SMTP id 5a478bee46e88-2b714f30461so448278eec.0
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 18:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769047246; x=1769652046; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tg0wswL3UiVCyK8pC6Hx23JoxxNi/TA43rjgfSUgEB4=;
        b=KztHD1aDRhcuOvv3KkqBK9LdxCsLWO8GynUG54AxGedxsZswvlzpPgsJGEs88tiikS
         C/y4g47zxhZ9AU4iitY2eBZX9YX/qfyPTilWyahcnFzR3nSEUN0JEqPVZk6C9J4DaWFv
         zlgS+yosB4YlZoa0CXzcIF3JcbAxQp6xNzc33O3O0CIl9JlzfxUx8tQ5ls7QZ3YSW02E
         WmwH+CSE2kphQQOGxwhUMY+Q0vIk1OZpIwRGVIrZE0gy6Xj1QVLJWFmByrh677sbo8Sp
         V4BSOTDLYab0pwuBJ/qe6xDK715jotRPsqi5E5E24svbDmyNffuOe78GqP2xEqKA5b/I
         K30Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769047246; x=1769652046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tg0wswL3UiVCyK8pC6Hx23JoxxNi/TA43rjgfSUgEB4=;
        b=SWsdC6mvFf0O1ORoIYz4Xxqt4iVuGKDXH9YrABMIe864/zBrBFoc9K1+08fQfy4Xu1
         Hvi5tzRF5LFLO8dt5hKWClLWs3eFmCDclF+7gyhVfOy1VWDrWvIcHGvda6perEBbqTCe
         8yeCzhf4SUtJV+XUMqCvj8kojHsTjua6t5StCWBep8ZM8zalUyNIA1i8ns8f6xxRGFnP
         8q0jm5qE7tRKPSF2IKJNNgEPNUSkK76MvQJNhag2if0ArnvMdw+uA08nIXD2AnnUZOVQ
         Gs2ZM2TsSeYSYO6ZsywLAbDzDSHl3kX+twzF/y1PA+IsV9eTOIEFn3mGUiwq6uf2y+ZZ
         TeHA==
X-Forwarded-Encrypted: i=1; AJvYcCU7WHYcz11DBl2BgmXEWUM+DEAXOIlbWqGQGtm7TPFEljerms27pEhmDAvgm05mr3mduvnz81mbwA==@kvack.org
X-Gm-Message-State: AOJu0YyDDL49KDPqP1OSbhkXFrYQTiGlrCMoV+pqCJROo4DcbGkRxheE
	Nzsdj/wTRU/c7pTBtTmDHfGFE/Jbb1xcTJX0smFNlgOSLgJh8YFL19Zh
X-Gm-Gg: AZuq6aI8pgIbXq9puevQrbVL1wYt5fCDp+1a4RZOm0ZmEVF7bXJQ7zHUlCZ8SfPlCfe
	JumerwyRMZw4/ieUJvTGPizEweGSOPhttMKtL9p4tbnOXFQIGvco0aknUhQpYcuwZdtTSyr23iN
	nXT92VNlKOUzNxrGmbD2ppITqbpVeXLKqRceUwKX8hh27m2Ib1iQqiCQ9zfi4AE8U8WLg7UFMxR
	sobX/yw9Tzs9GUUMZMWIFF/2Mn7ViaBpskMS2Yd0HzOcD3u+16X8mgSHGSKCy7W4Q7o1MqImkNc
	WJOItyZIzNVFxStiMH3zJdCExUdZ91yuXKCFDVnEWgKVtwlCvrk+zBTvx4sb8w54xmJ4E6xq1gA
	Xju1YH5s98nfLp9hzY4+jGzxdwIpFzAjS+HQxQCTvhXehIfPgJDADwPEJUUUiNxYWEinhnqLf7i
	Pu8H0=
X-Received: by 2002:a05:7300:cb05:b0:2b0:6a03:e66f with SMTP id 5a478bee46e88-2b6b3f29e91mr10715914eec.10.1769047245987;
        Wed, 21 Jan 2026 18:00:45 -0800 (PST)
Received: from debian ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b6b361f5d4sm23807434eec.17.2026.01.21.18.00.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 18:00:45 -0800 (PST)
From: Qiliang Yuan <realwujing@gmail.com>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	mhocko@suse.com,
	vbabka@suse.cz,
	willy@infradead.org,
	lance.yang@linux.dev,
	hannes@cmpxchg.org,
	surenb@google.com,
	jackmanb@google.com,
	ziy@nvidia.com,
	weixugc@google.com,
	rppt@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	edumazet@google.com,
	jis1@chinatelecom.cn,
	wangh13@chinatelecom.cn,
	liyi1@chinatelecom.cn,
	sunshx@chinatelecom.cn,
	zhangzq20@chinatelecom.cn,
	zhangjn11@chinatelecom.cn,
	Qiliang Yuan <realwujing@gmail.com>,
	Qiliang Yuan <yuanql9@chinatelecom.cn>
Subject: [PATCH] mm/page_alloc: boost watermarks on atomic allocation failure
Date: Wed, 21 Jan 2026 21:00:35 -0500
Message-ID: <20260122020035.227449-1-realwujing@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260121125603.47b204cc8fbe9466b25cce16@linux-foundation.org>
References: <20260121125603.47b204cc8fbe9466b25cce16@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: sf6w4gor1otagh75unbkchwqq49hbjez
X-Rspam-User: 
X-Rspamd-Queue-Id: 8AEB62000D
X-HE-Tag: 1769047247-19093
X-HE-Meta: U2FsdGVkX18rELeQjWnX4RqjMLC18sWeuUZoGQMSZ43Q1nBfmiVvC1vlV6wASXR4jl7tcZY4Pi6kqZqa0f3viawRXdZEONo0fRQQm8SdTBAPMN2igPkxidrhYP2Alovih0Z8iFfL4s3TBFdrvyLu872cVMkx9g1dLAAtzrY8dGA8BUZgYNR6Jeewaq5psgx4SIf9Ai8LejaOlynr5uxktf0q6G/uG6oN0eN6wsVMpG9X0nVBj8yug+O+GJgmBhJwzk9Le+hcnOw36oSGFxHah4og95OJAATlzy/11uqvFcFwT/mQK9viR0XA0MbDL896fOgOkNL0VQm/RyPVNehO6XPGYAo3dO71lJdCfqaHUA3xnVqAxg4sbF7ich7B0yJFvYEz+YUw9TlnWxZBoicMwBzPXXzGCbmbuTRA5WUTnofUUSmgsNmY0hm7HHbHbkY1+55a6gx0t1YxhytvjFm76gXgqUZGtGg7HygfwJU1x222ROL9M/vn59sPKHTpUp3fQ+2/geONAe95/fp6g1ytAeL+3Cwz/53jmCk+mPanCWOFoxYCxmwaaXY0hF43EfHqrbRPuqsFKYF2Erdd6ucdAw2pXoWBuVAlhKQXuwPxKCKyyGVSZBzRP3iUwCzu/AeVKwonPI7r33Fc/PCsbejGRBmXZubc7oaom2uiwxZp2oneivmhn6OEVwjNYtTaSAkBpymOX2R0b9aiidQ/6M/ahcZJ3iZl/wWaRI2F3KPpp4tVU9oQ74DtiQIoPr1cxIqyam0Lh8nwkWoZiDIa+B2bj2QAuFgrLB/kaFd85LaR5QIohSNOXL93EASqqkVbino8K2znCYx33B/FipErgDcP6yQye0aQTr729aMpFi5qUrrDkoZZkhmYNvKEWhClLoTOyixT+68YXNdq1NtyurBEc/bM8nhSxrXwW/7hcpymsLKYRRirGokDo0XSxqsU5XurbiRpeoi0TDIRvPuKHEz
 sc2Nkag6
 3FDtxDHbUbAUbp2NklxiSZxwVvegj9TynuzEKBn0KOXv4p8wHx+lU4Vi4yO6aE2s0t2Yc6kzVyQKI+3mipVl2Cf5DdkxJU6/C44PPv0BgPxUmDWyYnTZnjaFqB9fTYle1P92tIRUixxHPUmsZNPHr4I/tgJ8UBF6vUFW8brQlrOZdxGOQsoq5AWyACQLCHZLzaSO8T+99AgaMpLBxMrZA1dcKhELNuWZJ/Rd0l4Z9jcR8I23TUmVwTX2TSgSiWU8qLplxQcCkPb82UU5CjDwZ5bnFourGYnFIuUNOzH2cVqrx6uEG5M0Dzs6/fl2yjA6SUefWh625cKU4aTgp+2NPjFA8djj59Cl2Upe5XF4wC/zaEJwWvtO6Cg13YY+zxZB8z63T0kf23hPihxB4THMotv/rXXQFlRlexRqfFi2ES/G248uDdzRMhci7ETVz5FNb/toyN26PTnQjIOm24LU5zfxaLwfdIZxuvwefBpQb7lab5VbFTGqU3/xPnX0/hVm2wIJyTBFOEPFArfRPGbs02YAAf+wpqo6LbTif
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Atomic allocations (GFP_ATOMIC) are prone to failure under heavy memory
pressure as they cannot enter direct reclaim. This patch introduces a
'Soft Boost' mechanism to mitigate this.

When a GFP_ATOMIC request fails or enters the slowpath, the preferred
zone's watermark_boost is increased. This triggers kswapd to proactively
reclaim memory, creating a safety buffer for future atomic bursts.

To prevent excessive reclaim during packet storms, a 1-second debounce
timer (last_boost_jiffies) is added to each zone to rate-limit boosts.

This approach reuses existing watermark_boost infrastructure, ensuring
minimal overhead and asynchronous background reclaim via kswapd.

Allocation failure logs:
[38535644.718700] node 0: slabs: 1031, objs: 43328, free: 0
[38535644.725059] node 1: slabs: 339, objs: 17616, free: 317
[38535645.428345] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
[38535645.436888] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
[38535645.447664] node 0: slabs: 940, objs: 40864, free: 144
[38535645.454026] node 1: slabs: 322, objs: 19168, free: 383
[38535645.556122] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
[38535645.564576] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
[38535649.655523] warn_alloc: 59 callbacks suppressed
[38535649.655527] swapper/100: page allocation failure: order:0, mode:0x480020(GFP_ATOMIC), nodemask=(null)
[38535649.671692] swapper/100 cpuset=/ mems_allowed=0-1

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
---
v6:
  - Replace magic number ">> 10" with ATOMIC_BOOST_SCALE_SHIFT define
  - Add documentation explaining 0.1% zone size boost rationale
v5:
  - Simplify to use native boost_watermark() instead of custom logic
v4:
  - Add watermark_scale_boost and gradual decay via balance_pgdat
v3:
  - Move debounce timer to per-zone; optimize zone selection
v2:
  - Add debounce logic and zone-proportional boosting
v1:
  - Initial: boost min_free_kbytes on GFP_ATOMIC failure
---
 include/linux/mmzone.h |  1 +
 mm/page_alloc.c        | 36 +++++++++++++++++++++++++++++++++++-
 2 files changed, 36 insertions(+), 1 deletion(-)
---
 mm/page_alloc.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1faace9e2dc5..8ea2435125d5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -218,6 +218,13 @@ unsigned int pageblock_order __read_mostly;
 static void __free_pages_ok(struct page *page, unsigned int order,
 			    fpi_t fpi_flags);
 
+/*
+ * Boost watermarks by ~0.1% of zone size on atomic allocation pressure.
+ * This provides zone-proportional safety buffers: ~1MB per 1GB of zone size.
+ * Larger zones under GFP_ATOMIC pressure need proportionally larger reserves.
+ */
+#define ATOMIC_BOOST_SCALE_SHIFT 10
+
 /*
  * results with 256, 32 in the lowmem_reserve sysctl:
  *	1G machine -> (16M dma, 800M-16M normal, 1G-800M high)
@@ -2190,7 +2197,7 @@ static inline bool boost_watermark(struct zone *zone)
 	max_boost = max(pageblock_nr_pages, max_boost);
 
 	zone->watermark_boost = min(zone->watermark_boost +
-		max(pageblock_nr_pages, zone_managed_pages(zone) >> 10),
+		max(pageblock_nr_pages, zone_managed_pages(zone) >> ATOMIC_BOOST_SCALE_SHIFT),
 		max_boost);
 
 	return true;
-- 
2.51.0


