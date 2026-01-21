Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA404D262B2
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 06:57:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17EB56B0005; Wed, 21 Jan 2026 01:57:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15F376B0088; Wed, 21 Jan 2026 01:57:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 065D96B0089; Wed, 21 Jan 2026 01:57:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E8F9D6B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 01:57:55 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7BD441AF5BD
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 06:57:55 +0000 (UTC)
X-FDA: 84355066110.02.8C4F8B1
Received: from mail-dl1-f66.google.com (mail-dl1-f66.google.com [74.125.82.66])
	by imf13.hostedemail.com (Postfix) with ESMTP id D22F020003
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 06:57:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L6SPPg2U;
	spf=pass (imf13.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.66 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768978673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QfNI6YqTs0cYKPLMD89dgBVnDvHEsK2S5AP6RZaGePE=;
	b=0ItwJ+ReI6djAlfv+NPTmAHFVOLm+HwylgdX90FDIFLQyqjqk2SEklIppE8cmePxZ/ZG+6
	d/3LohvYxmrdWAo6L6jIsi8DF9PEs5C6tnPIsZ0nHvkc7T5XeO+8H6eG4o3Hn+s/O+1d7j
	yu6dCCw08Iifu9ATKGXYVvmxMZeqPno=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L6SPPg2U;
	spf=pass (imf13.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.66 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768978673; a=rsa-sha256;
	cv=none;
	b=vZO9mNOYFgGyTlEN5sY/W9OXm/wr4H2yDeY+4orLZhmPgAnjyUsAP/lrIQ1l4wKiZVpIYk
	wtO/8VlCgSbDwNbFfF22E+mGEu8NBLsDX+fQdv82m5fhPQKiVtV+tFjkGU6KiDjYUCBjEZ
	dMRyhmxOuhSRZcsnabFvcabzlamBKVM=
Received: by mail-dl1-f66.google.com with SMTP id a92af1059eb24-1233702afd3so7994619c88.0
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 22:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768978673; x=1769583473; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QfNI6YqTs0cYKPLMD89dgBVnDvHEsK2S5AP6RZaGePE=;
        b=L6SPPg2UuM8maUF6uL2PWS8u6Ut6QwZQ0pZ+zkTwIcInFwwhIiQ9PDGo43xqNBUIFA
         u1ajkUku/fUV4lWJBVtgYIrUeW3yL+18e/n6na4VJ0fMs6VNPe5XnQ2f2LnUPE8dL60Y
         0mOfskVlxuoLLpX6UDpg5hNLxC09bPAzFJG0gP6FtaOXhwk/02b25ugOLTRSVYyczS8+
         BERpEhTCijLQlFk+HSXZ09VV2fneRK6zjx3O8nUqIhTWOBcfl8GZJwtaaed+mx0Y/Tpj
         yU3ooghi9wHFDv+2neui8LMtphRGHdn6Xg3Aqk0/UvzRsZOao/oN4J2anRbAI+sZShR7
         uW2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768978673; x=1769583473;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QfNI6YqTs0cYKPLMD89dgBVnDvHEsK2S5AP6RZaGePE=;
        b=nqJswkEVy6JwGa6KOALXRpYO5Ad2cVFasM8wFUeqIcubn8zld9CowQRdNAR/e1HiSN
         DSAK5MxBRi8XBunZ6BP5GP4g7A5z5vXXCd7fWJWzOFH15IRFQgu75xlQkDZ4VYiYc0Pv
         n9YfOB/pp8hBksFEX9q+qu9F5FjdZfSJmZqw3PwlCkBbmgsuXJegoSg0nO7vThqosuwa
         2xzz0oF2tzI9bunGkajKu3JyvJgwQkVNbYJNn7u0tXQY2mkDEjcdjIitb4b0uDItrQYC
         nES+4V3qJok5Cl5Gh6Qs0L84P90kcuPbfIKryVYvdAJP4a0rN2LvPeJ0UYjO6xJLOZSG
         Rt9g==
X-Forwarded-Encrypted: i=1; AJvYcCUrwUL/+20RpAhSJKPzCUOpB23+OrgycoyzbvqBklS+zbHHwYseDxqOJ3D4zdrkGaGNwgWt5HQS2A==@kvack.org
X-Gm-Message-State: AOJu0Yzc4dRi2uEbnJLPKRQoDgQU3+xqrbumgnYiCN9fmQqxnNZiSuUq
	Gmf3vxPTi1l3NpHzTzKl6J0PS6VWbw4AB39H0T0XXxMVyUF90WatYXMw
X-Gm-Gg: AZuq6aJv0qRT/8NU+HpP6fwvyx7m/E41c66cRSFa05WC11YjZjRoSCXeQ7rZLpLZ7vj
	zfQVNc2W45vAa8Y+quYCzzB9hYqRvlYzN1gNJR0SHfQnhlcyfZXPuSA9hIYShyT/k5pmkihLlZw
	TGaRqLk1GeVZ3eRgAZ/Clmyi2+mMPiL6CxonRNzc5cWzvFf521gxeMLajmRJ47UJ5Irmhhrh2Q2
	C2vaGCMd+ypPxAnFGIgKnRKE5FxAoQWBeP5sCiweC6aTwGexDJt0UjtBiAbvRGDW+e0ytI3DZKn
	ITip79x25Pmv+mGoLS68OXOi/IHFam0AEEzuG7AGn/bVOiK2GgrCuZ8gqLSvOV/nT1bJ33J0QL4
	Q46Iqtu7WsYULFNZZjI1A2y7WKBib1cOqF5M3gXuFVpLNlamGOsTqxZJvFXDNa2H5LsA62rwvlr
	21Qbo=
X-Received: by 2002:a05:7022:2491:b0:11b:9e5e:1a40 with SMTP id a92af1059eb24-1246a9669a1mr2718620c88.15.1768978672473;
        Tue, 20 Jan 2026 22:57:52 -0800 (PST)
Received: from debian ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1244aefa7c5sm25194468c88.10.2026.01.20.22.57.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 22:57:51 -0800 (PST)
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
	Qiliang Yuan <realwujing@gmail.com>
Subject: [PATCH v5] mm/page_alloc: boost watermarks on atomic allocation failure
Date: Wed, 21 Jan 2026 01:57:40 -0500
Message-ID: <20260121065740.35616-1-realwujing@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D22F020003
X-Stat-Signature: cgtmmxek83w1ypa976gezmq4fpj43hkt
X-Rspam-User: 
X-HE-Tag: 1768978673-870772
X-HE-Meta: U2FsdGVkX1+qR4lJo9UUCFQG6m8sBLKoJ/dURszod5UY4lzGcUhwtiyegvvOtpvyHkf2NqFYwqgN8fwZjA1HHMQqm9PhsFbATgxFj92kPqr8zOasdsbY5444XrFm07zXFoCPTOR+e52GSsXkeI3OKWRhzqy/IORPVxsOP2wqiceadkab64EDfYxpDD3j3j7pmiRmKnqBROd5UF5k8CJRsDMcWaSpgaCKp9KNcv4fDIY5gbsc5j22GDIlPr51X3b+tf86qiJ439zUnTMItQTL2K90DwSw+/1iIMKtKrlDgRPg/kLTLUV42DDh5UkUTkErD4aQgZQruUsVd4L6UbQMALxgmXVRqI9OpBb8L1LXcX/cGnQl6wpofxSP8XRsdT3Rub+lGAvYgHusi5b+ZuPcObf9/ZIHHf9REoW+FbBGrILBP6b3rYEh3KtPnT5uhrfR9rJInK+d+DUsfZFvKWFQ+eb8dHRd1f9zmweIUb5UPo7bdop9vTe71kWXHd5yYHDm5kRb478xip9Xl18PqMZ3mw2YXZmVwqbp3+YUwMRLuohCE2vqqG9Km3Yzq6Eo2bvQIXWL32XaNpzhSD/2OmCBTs/RmYRWVvcgQMK/g/VX9XhWm5980afu9QfRixHYQ1KoKUepzI8TNr1gQ5IvFY0fVy0RFc85pSD7jizRyOqzOa/5Sc+npZ9Z7N9xewSpYik8r16Vkia1AfJAKq43DiwW4gSVAdvMFTMiVjNc75lhJ49+oOxN2p/xnMc/YDToQd8bCOlFhFy6UKMKI1lLEziEfCkYgYBf2ikMdsoavZrQxhDO/1qH2IM/KVAujREChgAxqXmrFJh6A92qViirkNiDcSmwcrnv/ob6kJ0tSVisltiWnMeiZXZuuVaCb2Rf3l2ug1QuyISvsf8vCJxrEPDtVlMp6YEElyGaIZJ9DKCMFgVfKzt0KemQJoSgVcAaNlfsi920yFtgfEFp37yCp/6
 nphkdd8b
 lL3VBTg8PEHIxfGBz6XqGym15FkUegI1aZZlqD7rZZ5Xe27oKbhUL573gHYJZHMxgZaBjHv91RoZIcHE3/Nj7Q9mAL/BM/Dd0apIjqrVacewy59nK04OM/gW9kgqGOr8dbRMMvzq4C1pjN2O6DAEennP/eVSpnLT6CuJQNFtmpaUwHW5RR0JrxiB1P2Ylpe9EReAB
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
---
v5:
  - Replaced custom watermark_scale_boost and manual recomputations with 
    native boost_watermark reuse.
  - Simplified logic to use existing 'boost' architecture for better 
    community acceptability.
v4:
  - Introduced watermark_scale_boost and gradual decay via balance_pgdat.
  - Added proactive soft-boosting when entering slowpath.
v3:
  - Moved debounce timer to per-zone to avoid cross-node interference.
  - Optimized candidate zone selection to reduce global reclaim pressure.
v2:
  - Added basic debounce logic and scaled boosting strength based on zone size.
v1:
  - Initial proposal: Basic watermark boost on atomic allocation failure.
---
 include/linux/mmzone.h |  1 +
 mm/page_alloc.c        | 29 ++++++++++++++++++++++++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 75ef7c9f9307..8e37e4e6765b 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -882,6 +882,7 @@ struct zone {
 	/* zone watermarks, access with *_wmark_pages(zone) macros */
 	unsigned long _watermark[NR_WMARK];
 	unsigned long watermark_boost;
+	unsigned long last_boost_jiffies;
 
 	unsigned long nr_reserved_highatomic;
 	unsigned long nr_free_highatomic;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c380f063e8b7..1faace9e2dc5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2189,12 +2189,31 @@ static inline bool boost_watermark(struct zone *zone)
 
 	max_boost = max(pageblock_nr_pages, max_boost);
 
-	zone->watermark_boost = min(zone->watermark_boost + pageblock_nr_pages,
+	zone->watermark_boost = min(zone->watermark_boost +
+		max(pageblock_nr_pages, zone_managed_pages(zone) >> 10),
 		max_boost);
 
 	return true;
 }
 
+static void boost_zones_for_atomic(struct alloc_context *ac, gfp_t gfp_mask)
+{
+	struct zoneref *z;
+	struct zone *zone;
+	unsigned long now = jiffies;
+
+	for_each_zone_zonelist(zone, z, ac->zonelist, ac->highest_zoneidx) {
+		/* 1 second debounce to avoid spamming boosts in a burst */
+		if (time_after(now, zone->last_boost_jiffies + HZ)) {
+			zone->last_boost_jiffies = now;
+			if (boost_watermark(zone))
+				wakeup_kswapd(zone, gfp_mask, 0, ac->highest_zoneidx);
+			/* Only boost the preferred zone to be precise */
+			break;
+		}
+	}
+}
+
 /*
  * When we are falling back to another migratetype during allocation, should we
  * try to claim an entire block to satisfy further allocations, instead of
@@ -4742,6 +4761,10 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	if (page)
 		goto got_pg;
 
+	/* Proactively boost for atomic requests entering slowpath */
+	if ((gfp_mask & GFP_ATOMIC) && order == 0)
+		boost_zones_for_atomic(ac, gfp_mask);
+
 	/*
 	 * For costly allocations, try direct compaction first, as it's likely
 	 * that we have enough base pages and don't need to reclaim. For non-
@@ -4947,6 +4970,10 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 		goto retry;
 	}
 fail:
+	/* Boost watermarks on atomic allocation failure to trigger kswapd */
+	if (unlikely(page == NULL && (gfp_mask & GFP_ATOMIC) && order == 0))
+		boost_zones_for_atomic(ac, gfp_mask);
+
 	warn_alloc(gfp_mask, ac->nodemask,
 			"page allocation failure: order:%u", order);
 got_pg:
-- 
2.51.0


