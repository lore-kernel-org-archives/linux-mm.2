Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEC0BEF48C2
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 03:18:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF02B6B0005; Thu, 12 Feb 2026 22:18:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9D656B0089; Thu, 12 Feb 2026 22:18:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D80186B008A; Thu, 12 Feb 2026 22:18:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C6CAA6B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 22:18:10 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 762011B3E97
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 03:18:10 +0000 (UTC)
X-FDA: 84437974740.05.0A75489
Received: from mail-dl1-f65.google.com (mail-dl1-f65.google.com [74.125.82.65])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8FF0F1C000E
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 03:18:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jBiA2ZC4;
	spf=pass (imf21.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.65 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770952688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=uzinu5cvWSVigsPPlyALTMaWKR2jEut1B9F+0mvA3UE=;
	b=6FaYIIdILCqoTQnnDNzlbgu4H9qkktglz/FsD9qYYF8M+DUjmAfMDOJeP7PsfnGqS06u7/
	jmzdqEnaa2+KZe0M2crLthUfSG8hoqbwrcOip2I/ixC92mQ6FelTN00o6a5aMuQ/1S+67J
	LNC59QxuUkFRCN7/TKmIXMsuJUFHLPo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jBiA2ZC4;
	spf=pass (imf21.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.65 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770952688; a=rsa-sha256;
	cv=none;
	b=XtwxCLbya9OXMT8cpvdoO08ac6Ow7yH5f5ukqgZPACcAl/4JUh4NCFWLm5vGX+PeSa2HW9
	BZRFyQRSbRp1+aW7Ejvi9x/YUVnrLHTVwspC/21yWB4BwXPIyJUFjvFCNiPflcztV4mEK1
	vcEX/PebODmkdZP0yjI3YwvEmdNH3vo=
Received: by mail-dl1-f65.google.com with SMTP id a92af1059eb24-124899ee9d3so384888c88.0
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 19:18:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770952687; x=1771557487; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uzinu5cvWSVigsPPlyALTMaWKR2jEut1B9F+0mvA3UE=;
        b=jBiA2ZC4EAfkQ2CwZXT9exVJoUm9sGbPvzfVxYMPt5hylZ6LbJEAykcpnGm6YEFVS0
         AQyxO4CXXXCE7TGxIGnikvH5+dGdxmHNfD7YtTZfkwuGte8PL7RMn67SZR/PKcsiiU+z
         cLKSHyDHxlPI3fpdtqCj/mkMZpppp/cbdBp3K4xuhjISMN/Bj8NmjiGHQNPdKDfYLnfz
         RZNStm1p98lKlXfEiiRmbJF9wBtX3yZ9MjyLeF+W9LAwTDkoXc119Ug9CO/QBNsaUrjM
         5bPYNlUZ0Xp2HtW3fevXKGbKqshnGbQV/xu7i3CiIITZXuHKZWELijd2WlDFGIlCGyPJ
         woZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770952687; x=1771557487;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uzinu5cvWSVigsPPlyALTMaWKR2jEut1B9F+0mvA3UE=;
        b=EskybhvdS0xJiFzRGHshL2q5C/loFzBqHWRu/EiN1cdzjePYW3C2AlLGa4o4FgGC7N
         gntgXB7r8O4YGb5tgbdzq9vBdr3taiAWVWETlh0pIGPXJvwOcMrRuOXlU7W3S6tzPjq6
         JUozs4wMT6EXOM18E59zvPsyq5qic74tMlGqc5UNNVzXTVEF9AqqBUejSzQbDeR1M+qR
         JGILXW93D26F/7XodmgZbR74kr2Xk18MFmLLIsGZC6ZfupiFtVe+e+Bu8LE0Fvdgo4q1
         AI7BE2W6/1OU2KboV8b9ApmGOpAbLluirc2xB4favGdT8RBWKxKuI8m8g4cUb3/+xD9H
         9ClQ==
X-Gm-Message-State: AOJu0YxEw9gRrrcyWa2xnwr3FyUXU/Wj0EZGhmauMvx5CQCD64cIkw7B
	N1SgFuPC+wCcMobMFJhrQPftZl289MKGWV3AtANklbYnP0U3/HZXse0n
X-Gm-Gg: AZuq6aJH5We2tSKxWZ3dS8aW/Lnjm1YSugttT9DNSErvGXMtASBTwNBe30p0sBdfCLU
	qdEMU01K+sJvBBvOi6IykVRRlJJi8ZUNK2lXSkjVzyY810nHmZG8Z/Rv0nSR6lpWTWxIbTTonuU
	9QMII0cWG0Idk7W5elWOFnD8tTLfILnJaRcHrYMp5TXbVoIPja3J2c2sScLK1iGcVST3ttEDhlN
	RRNuepcWs6EnOE6jUIM8YWNa6dZRL4BhlgwMoavwnaSpItbK+qpNllS2G3nwsZ0I+aYFbkG+uPA
	uEUL5fuIRjmryYw8NRAxQPcrfRAgfzUYStDIpxLz43dsVfnTLZpLksSmFNnsP0VZf94/5WuDAKZ
	OlTval3OCjiVfpUGcPRUKSHl9QWnvA4/trIBXMBRv4696qlU6/2U9TgkgSK/cRoYd0CzJsyySnR
	1ncLlxg38mQZzUHhCM+XjRj+WmEn0=
X-Received: by 2002:a05:7022:51b:b0:119:e569:f86c with SMTP id a92af1059eb24-1273a909415mr204652c88.9.1770952687193;
        Thu, 12 Feb 2026 19:18:07 -0800 (PST)
Received: from wujing. ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1272a694059sm6802187c88.2.2026.02.12.19.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Feb 2026 19:18:06 -0800 (PST)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Fri, 13 Feb 2026 11:17:59 +0800
Subject: [PATCH v9] mm/page_alloc: boost watermarks on atomic allocation
 failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260213-wujing-mm-page_alloc-v8-v9-1-cd99f3a6cb70@gmail.com>
X-B4-Tracking: v=1; b=H4sIAOaXjmkC/3WNwQqDMBBEf0X23C0xgjU99T9Eyhpj3GKMJK1tE
 f+9qfRamMsbmDcrRBPYRDhnKwSzcGQ/JVCHDPRAkzXIXWKQQpZCihKfjxtPFp3Dmay50jh6jUu
 FfZurk2pJl72BtJ6D6fm1m+sm8cDx7sN7P1qqb/tz5vKvMyXHjloqKqWE7oqLdcTjUXsHzbZtH
 0Sfo/++AAAA
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Lance Yang <lance.yang@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <realwujing@gmail.com>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam11
X-Stat-Signature: rab6djj3sj5go39ob4yycpbyzxg7r9ng
X-Rspam-User: 
X-Rspamd-Queue-Id: 8FF0F1C000E
X-HE-Tag: 1770952688-487168
X-HE-Meta: U2FsdGVkX1/TRsq7atOZwZkTcdSNE8Sg5a2QuW2XI2N5dzMvdeet2dkMSbU4ppkfhkVJK1ULOcRpxCZ910p8MuLLNfoj/3s4dfxnbsVg2C9f/Lgs5k/JVupeXLflkkdg7LCxbAyxEGnLVbr/H0P5DsvZwe5ckW5DhwGwd+kuPwb0kqe+vVzxaqwZmvD3geezCWW1GGVtZ0WX/yzqxSI5htLXW6BjRz2ldREZkQv02Sa1Oc1jq0jVc/xKEGPDsq1yDqhksAqCOWUedmIESWEFjXXIKmZElg9R7PrM0hcHTUwxFV7CLsct+DMDhz9bc8mKy7EIS8kQCXYNGTwLJWrTESwAAbFjg5jzNZA8CDqi6CYInFr0CHnFIvM8KZP93qNdqtfX+r8bO1uw3+nxL0YGWcdAJchcP2DtwtIKjNPtFvS5AOtuYiTN/jzZvyn6NCuPouigsDOaOQGMr0+JLEBQYiicR0sOBHWrDBYLEMA3TdNtp5+co8woF31/GFl6KE/Zsrv+XT8DhKeeFx8Mmt/kBsmqh+wJlONr/5KZe8Ff/Fw14wlHHFxH+32Q/STsFDIADNmlqFNxk2VjzE7d8vDDna9I0ZUU+Pdfu9dCn/BP2SSi2bFuQCO3ht7sv3N83/MYevN36puIL35OQluJj0quA/oYt4Kwz5QbGGIYW3IPTVeRdAEiyVDAJXxPhKdvqjPC2pfcSKLW6sM6N4q7IlC19Gr8pHkTTRf4sxoJ2ySp8cb3wHkDeRa5258wSq4X+0vT/jW/DutAhdC0Lu++2mwyh+OyKcxnN940L47r8SdLtMOsY3mBRxJNUh4dnLUMgejELb1ATTkZuH9237R/fr1OqB++7ZJlxDc51zfYdh3gfFfzJOgd9y73uNgx0yqvShdghM1wwsxTehz6u2QylsDm1SxWN5Oqs8DGWdFwvdkKgrU0IgBUrT3BcaauINKTo5X6ruQgU08JhBlKtVtKBSn
 UMxYTXkY
 V2/nhBVMVCeemv6IqHCf2hRHJbIlN3PFdht+e68t963YSkdOErV7hYk8r8L+whGlv6qZd6aKaRyQpk8fGrIBLH8HNEe/y/R5HB0yuaLZhvscD9ZJgI5TYVdjoIiqSK4QJ9pTn19BoNMkIIq5pUD+kbjuK3Pk9FUN4FIh2uTJrAqqUPAz08oWgbCeAKUufSeeS0yOri8dvzX0PFXo248H4lgFVktroc1NmoKQlj6Wco7/02qS+FFcN9lGHDsjqUGaTXSwVSwQbjdEhnPEhHFd2t73LJZ3LZXE/GZffo1w0pSvEFKxVJYT7frgwvrlosB54a9WDCv7+kyFy8ReQUdHW0X1t/0Jmg/d9+1ORNTJi+CpnVq2IJgp8SOQ3xVsBKUDHhRmwe7egt+icXWrX0oBREAw+wvBF2ddN3GuAhGmoIlctzkSgzzSxvCxvNDSC7yK1aArBYNxZlPPnPFngysIZmax6R2u9SlEK74bDES62AuoT0BI3OkN9dM0r7SBmofTdA1qkdFK+YbeqVKkBpib3dWVzA669jy6ATHMPJlx2Y1GQxsQ2AXAD8cPZlJlxj4X25co+jbuUq/RSgME=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Atomic allocations (GFP_ATOMIC) are prone to failure under heavy memory
pressure as they cannot enter direct reclaim. This patch introduces a
watermark boost mechanism to mitigate this issue.

When a GFP_ATOMIC request enters the slowpath, the preferred zone's
watermark_boost is increased under zone->lock protection. This triggers
kswapd to proactively reclaim memory, creating a safety buffer for
future atomic allocations. A 1-second debounce timer prevents excessive
boosts during traffic bursts.

This approach reuses existing watermark_boost infrastructure with
minimal overhead and proper locking to ensure thread safety.

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

Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
---
v9:
- Use mult_frac() for boost calculation. (SJ)
- Add !can_direct_reclaim check. (Vlastimil)
- Code cleanup: naming, scope, and line limits. (SJ)
- Update tags: Add Vlastimil's Acked-by.

v8:
- Use spin_lock_irqsave() to prevent inconsistent lock state.

v7:
- Use local variable for boost_amount.
- Add zone->lock protection.
- Add lockdep assertion.

v6:
- Use ATOMIC_BOOST_SCALE_SHIFT define.
- Add documentation for 0.1% rationale.

v5:
- Use native boost_watermark().

v4:
- Add watermark_scale_boost and gradual decay.

v3:
- Per-zone debounce timer.

v2:
- Debounce logic and zone-proportional boosting.

v1:
- Initial version.
---
Link to v8: https://lore.kernel.org/r/20260212-wujing-mm-page_alloc-v8-v8-1-daba38990cd3@gmail.com
---
 include/linux/mmzone.h |  1 +
 mm/page_alloc.c        | 49 +++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 48 insertions(+), 2 deletions(-)

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
index c380f063e8b7..8af88584a8bd 100644
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
+#define ATOMIC_BOOST_FACTOR 1
+
 /*
  * results with 256, 32 in the lowmem_reserve sysctl:
  *	1G machine -> (16M dma, 800M-16M normal, 1G-800M high)
@@ -2161,6 +2168,9 @@ bool pageblock_unisolate_and_move_free_pages(struct zone *zone, struct page *pag
 static inline bool boost_watermark(struct zone *zone)
 {
 	unsigned long max_boost;
+	unsigned long boost_amount;
+
+	lockdep_assert_held(&zone->lock);
 
 	if (!watermark_boost_factor)
 		return false;
@@ -2189,12 +2199,43 @@ static inline bool boost_watermark(struct zone *zone)
 
 	max_boost = max(pageblock_nr_pages, max_boost);
 
-	zone->watermark_boost = min(zone->watermark_boost + pageblock_nr_pages,
-		max_boost);
+	boost_amount = max(pageblock_nr_pages,
+			   mult_frac(zone_managed_pages(zone), ATOMIC_BOOST_FACTOR, 1000));
+	zone->watermark_boost = min(zone->watermark_boost + boost_amount,
+				    max_boost);
 
 	return true;
 }
 
+static void boost_zone_for_atomic(struct alloc_context *ac, gfp_t gfp_mask)
+{
+	struct zoneref *z;
+	struct zone *zone;
+	unsigned long now = jiffies;
+
+	for_each_zone_zonelist(zone, z, ac->zonelist, ac->highest_zoneidx) {
+		/* Rate-limit boosts to once per second per zone */
+		if (time_after(now, zone->last_boost_jiffies + HZ)) {
+			unsigned long flags;
+			bool should_wake;
+
+			zone->last_boost_jiffies = now;
+
+			/* Modify watermark under lock, wake kswapd outside */
+			spin_lock_irqsave(&zone->lock, flags);
+			should_wake = boost_watermark(zone);
+			spin_unlock_irqrestore(&zone->lock, flags);
+
+			if (should_wake)
+				wakeup_kswapd(zone, gfp_mask, 0,
+					      ac->highest_zoneidx);
+
+			/* Boost only the preferred zone */
+			break;
+		}
+	}
+}
+
 /*
  * When we are falling back to another migratetype during allocation, should we
  * try to claim an entire block to satisfy further allocations, instead of
@@ -4742,6 +4783,10 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	if (page)
 		goto got_pg;
 
+	/* Boost watermarks for atomic requests entering slowpath */
+	if ((gfp_mask & GFP_ATOMIC) && order == 0 && !can_direct_reclaim)
+		boost_zone_for_atomic(ac, gfp_mask);
+
 	/*
 	 * For costly allocations, try direct compaction first, as it's likely
 	 * that we have enough base pages and don't need to reclaim. For non-

---
base-commit: b54345928fa1dbde534e32ecaa138678fd5d2135
change-id: 20260206-wujing-mm-page_alloc-v8-fb1979bac6fe

Best regards,
-- 
Qiliang Yuan <realwujing@gmail.com>


