Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F7ADC55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:48:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D68A6B009D; Mon,  3 Aug 2026 09:48:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 586E76B00A7; Mon,  3 Aug 2026 09:48:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 477016B00A9; Mon,  3 Aug 2026 09:48:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FC2D6B009D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:48:36 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BB3ABA20D0
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:48:35 +0000 (UTC)
X-FDA: 85060088190.07.1322333
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id 13E9F20006
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:48:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="svrG/gCk";
	spf=pass (imf03.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785764914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gSjlnclITsfEniWZnfioDPIZpAfFUZWebTMKBU3cmxA=;
	b=kX9UvF+zJTZfXh86QSMBsi3wrbTDi2YrJnDyyHzTHd1FtUDOL+Q6I+YFOXV1X3bKh+/UDP
	FTSKzhLD3nels4GpbNLTNw6Y1x91tWhVdaE2GWn49FkTg+m2Lh3tJmfEAjPKdc4bC1YuRv
	JSuwoRG4KP8J63wLj42aRB9z4LRcH7I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785764914;
	b=QBOoL5e2fFKWdcAAnv8Qaxxh7IZ3e1yFQMvA764LVyokyqrqXcLG7D9YOZtCw5vpEkVYDf
	hMflVL6+s8NUQ8wdYPlkOn6zgO/QI5QyjGp96xHR5P1kU6iepsVVRrHezxICXRlAQQWeN6
	DxjjlWXk2983FJr3aINyfumSIdtuc4k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="svrG/gCk";
	spf=pass (imf03.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-38f620399a0so2697713a91.2
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 06:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785764913; x=1786369713; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gSjlnclITsfEniWZnfioDPIZpAfFUZWebTMKBU3cmxA=;
        b=svrG/gCkeSuFDoGUHj60V24tG9vwcf4l5yyNjAeYPduHH4GAszdOJ+9rjtataQaF3k
         Rj/SxB4cHVbI0oCQATBtLoef4FF2o7wcC6fHGOYuIfjKqWDtkDJLL7XBejxbKd9PDuIr
         GdP9K3fA7Yhj2MLcP0kYIw7lrBO2ymdQJAOwUCamh8r5elaCtLWILFLkU8C51bVquDiX
         ra141QGpYvB+WlqJRSiBWrPTMN5YJN5NzM7XNTE9bdiGQIiTK5hk3y4i1DZnDYP1+8O8
         ZXGq2gP6lMztn6rjOrseCzN9FtRF8RYTecac55Shob2s2CKGZlAIcmeo7ur67pXtBsdF
         HZdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785764913; x=1786369713;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gSjlnclITsfEniWZnfioDPIZpAfFUZWebTMKBU3cmxA=;
        b=Us8lXYrqfUX9wQkmRYhxIDJXl5j/9c+EVnMT6s4W1KX2SNsgMYBW8tvUjsjd0Tusj9
         0jCgy3I1OQ1syKAT64fU7GxGwIwpbGWAAsOpm8xw26PQ2gSjg79+hsP7acwkrB0b391T
         OepBiSpuNlW0OLBoTQfbDh8Qzics3r6omaJphdOgQijpwmxafRlTXS+LfUzj3C23+KRC
         nq3HtoemMeAs6PeVCQr4BmOZcxJytTNQ+acmvRpJLRjumMwxbvhw0ITiViVHbvpbDEnB
         yeWHakjlNDAIcYaILJV6xJhLM5FosqGOZseyhq0CQQVYPP6u8U5OVTXbXTTOl93cj4a0
         DGRg==
X-Forwarded-Encrypted: i=1; AHgh+RpYPKxOJI6lzLBbkvCYZ2YeCDW8JeamdDLXqa2rOjgwlzuveefoPWHsE9Ay4weLxQinmkZLISvTkQ==@kvack.org
X-Gm-Message-State: AOJu0YwBwJ9+VUu7LYNBFH0S5oO36VFgDdca4Y27oCLChOowhBJ9BoVn
	Ij3dK2f2Cm2WERz92Nh8Jq7mv39DrNvTWIMKEp1D0pQe2bqjbJ5G902Q
X-Gm-Gg: AR+sD10Hswh/tx0AVQD1mecq9VKAhaXiy2/ipHorodkZSVK8jqyEoVMQelDNlsXV0K9
	uyd7voBciSXYVz2CkOeFfiEwABuphQC2dMWTRHOo79TqJDSNvNJVdVL6JrMeo96g0Qej85F/vyF
	T+YW3VBPkfT3N9D80EqdINB3pHOci969IC359J1gitlxHsPDHGm9Di+k2yFlhQpzZN9X8ax5LAi
	yDPrAe+CHKwtw8C0jGdUj8v8T2fr8AfRX8rutT5fS/VqQ6sP1k70qT90A0F9TTKV6RFmccy7gid
	8OC6CbYwl73c5+L4XGoOmvWRG8Rw3L6myzkjMYansFCnJLh4VR+sOMzoxjHelk0DqbSFfgp56/Y
	CHlSYF7dnTYhapbmawWshnbbzMSMvBM8Oh/0QuEM9dONhLmK6BwDUpEDFFzzakU4D5IlZUoTXUf
	XJm+MMXal3DFkkqBM9G1ZIM30KWhXCTLVVGD0b4ziz5DFDjB87cpXMPa4=
X-Received: by 2002:a17:90b:4cce:b0:38e:4cb:51f with SMTP id 98e67ed59e1d1-38fbc422a55mr9123754a91.11.1785764912679;
        Mon, 03 Aug 2026 06:48:32 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38fb2962928sm3987415a91.3.2026.08.03.06.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 06:48:32 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH] mm/page_ext: remove pgdat_page_ext_init()
Date: Mon,  3 Aug 2026 22:48:21 +0900
Message-ID: <20260803134822.2568766-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 13E9F20006
X-Stat-Signature: 93y9i6eynbxkffe5mw9kq3e19o9tweun
X-Rspam-User: 
X-HE-Tag: 1785764913-330702
X-HE-Meta: U2FsdGVkX1+xjfhFw9Auh6AAbtKxBLaH++Vd4JCEWvrthcFbLcFEgeVBy4r7vIyxAjwYAsiAr2DHm0kUN/bz5I4+jpswAQu9kcEgJkIYr1ln+bY2EwpswajehJGl6C0a9vexQ7xrrHYWOnMubgmGLvtw8+AVUyUQ4zGtYtJ+jSYok8oGoIlgxOFauWr2+byngrNao7+/1txBEvVQpm3sSHeyzVEWlxYBvEAQpiw089L2zlNtZOHUpsZmrHa+auscA5j+fN1xWvShalJxHq2Ppd0UsjRH0U2rEsbZBRqMKSRX3Wm0x77yf1gzGR2XGuFEHbrRsqLYk6kXBrCL6A8a6ToH3BAGYHS+RwB2VeL7Pr980TUnsgWrsKLsmKRNIY+aAV5ExM1IFMhj8hetyeu+GyxLv2RILintf/ehzeUjxPl3F7gx7hW4EE62yDMX7B0xZYOBzjtStF2YQ8uZ3AKemERdhVg4oNJqDGOQwJgWMERhgfi1+IslfQRm+vgksUPyUlcHYA+DI5g3saGsPYxn/4rU78gxgT4p7L7FvHbjkH9rgVJfgqnNCyryJOkl6KI/KOdBWIpkO2wpRTCFQdxQSI6ZMWt8fojmBcB/1FCTSh64VTELI8RgnbYHB9ml6bRIYS7E/EMq/+lxOAoFUDF0tXO4Q503Btkc5M8C28F9kluCdw40LZDwMG9zHTNEPdhajy6AFLcTUMwEw/3TNvYh8c7ENtUBVmX3nN6zo8/Jx/mxRyq5lnw6y4NUbe+mgW7j5hYcmv8+sOa4gtcsTV1dGgjlfb2iIvtpND+BXAhY1gpMhtfYpjPS8MpfNrVrsYkwIKUPRwNc0NqrAGYL2OklCka3cP8zR2tjaT0fUWkC4EMMOjXMsENhW9NmEU92BAq48qOJutc3EJOW0qYyvO2w/quFLDcJSyMtaKUOivAeu2IKT2e/v0Zyc4ZVvQ/3dtRu4qi+6ou2pB8S9C2VlZ8
 GgSbM8Jw
 YOhFAvwhHJIPKX7T28iwjfDgIFhAmhSXSIDQHwqVa+Ecdy/9XPRmaBOEP1AzGb/XSOmYyj1ec9pBThRp2xjUPVRYyo/2ZuiP5LzcXw1fHH8HSJyzaqe0PwgHPMSgb7/CJ0yvttZGpid7uJgAQGdYEtmI7hJlKIvkuE3bj2uTBbK9996Xd/T8s3WJ2vVv55ZPUN45gp7wtHdCCwYeOxCPN/5Uo7CB+b3GrXvIDU2Yp1HKohwHARAZUyFT76xVwkPdO/fH/LY/Lkt4ob3UrHQPbe3gkgWamSydhN/UoQtmXeGqGgNE3RN4Bl0YOynF08ygCZuDfkFL3W6JF2Oo3nr5Auzs+2J4PvhOp4ZvGlXQtN4IaV35jH8DpBeucc1M9Xf73I3BOunEuknccIk+bu5Y7Wb1jsiPQLiHYDmTcqaWEzpu4FVJY9IHYLTZrorDHI2nXo6FvcyB5smgZcqc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pgdat_page_ext_init() sets pgdat->node_page_ext to NULL only on
FLATMEM. FLATMEM depends on !NUMA on every architecture, so the
pgdat is always the zero-initialized contig_page_data and the store
has no effect.

So remove the call site, the unused function and its declaration.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 include/linux/page_ext.h | 5 -----
 mm/mm_init.c             | 1 -
 mm/page_ext.c            | 9 ---------
 3 files changed, 15 deletions(-)

diff --git a/include/linux/page_ext.h b/include/linux/page_ext.h
index f23d4b218da0..79c53ec45dfa 100644
--- a/include/linux/page_ext.h
+++ b/include/linux/page_ext.h
@@ -55,7 +55,6 @@ struct page_ext {
 
 extern bool early_page_ext;
 extern unsigned long page_ext_size;
-extern void pgdat_page_ext_init(struct pglist_data *pgdat);
 
 static inline bool early_page_ext_enabled(void)
 {
@@ -202,10 +201,6 @@ static inline bool early_page_ext_enabled(void)
 	return false;
 }
 
-static inline void pgdat_page_ext_init(struct pglist_data *pgdat)
-{
-}
-
 static inline void page_ext_init(void)
 {
 }
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 711f821f7b3c..e9c4204b73ad 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1394,7 +1394,6 @@ static void __meminit pgdat_init_internals(struct pglist_data *pgdat)
 	for (i = 0; i < NR_VMSCAN_THROTTLE; i++)
 		init_waitqueue_head(&pgdat->reclaim_wait[i]);
 
-	pgdat_page_ext_init(pgdat);
 	lruvec_init(&pgdat->__lruvec);
 }
 
diff --git a/mm/page_ext.c b/mm/page_ext.c
index e2e92bd27ebd..b679a8c1f7d7 100644
--- a/mm/page_ext.c
+++ b/mm/page_ext.c
@@ -164,11 +164,6 @@ void __init page_ext_init_flatmem_late(void)
 	invoke_init_callbacks();
 }
 
-void __meminit pgdat_page_ext_init(struct pglist_data *pgdat)
-{
-	pgdat->node_page_ext = NULL;
-}
-
 static struct page_ext *lookup_page_ext(const struct page *page)
 {
 	unsigned long pfn = page_to_pfn(page);
@@ -494,10 +489,6 @@ void __init page_ext_init(void)
 	panic("Out of memory");
 }
 
-void __meminit pgdat_page_ext_init(struct pglist_data *pgdat)
-{
-}
-
 #endif
 
 /**
-- 
2.43.0


