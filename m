Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 936EDCA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 00:14:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A9366B008A; Wed, 30 Sep 2026 20:14:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37F1A6B008C; Wed, 30 Sep 2026 20:14:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F8926B0092; Wed, 30 Sep 2026 20:14:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E52B16B008A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 20:14:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5FE8D120284
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 00:14:32 +0000 (UTC)
X-FDA: 85272135984.05.AF2DEF1
Received: from mail-pz2-f37.google.com (mail-pz2-f37.google.com [74.125.228.37])
	by imf30.hostedemail.com (Postfix) with ESMTP id 89FA080004
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 00:14:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="GO++oe/Q";
	spf=pass (imf30.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.228.37 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790813670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9y30WpELg39m0gWRlLIOMYQuYZ98WLf1dAoujzXj64A=;
	b=zImWmVjc6tUBxU9JafDXMS4TOh3HYjA+ewYItEQbX40sbbb56lF5+QlVhd7GyfKKxc/yDX
	2q68lhCn8RWhXvYM7Sl0qxH0iLFl0lrVBVvlbrdbo6CmK2sH62TDfVcNAtOMmrcADsD/4f
	LsyDr/uc4lKCP2rKWs8CM2EGGqSw0F0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790813670;
	b=a2EwSVEy0Mp1XtW1kNHftMnCxF/cB5N7caLDVHRKbUxFONi0wcXTy0vJNa/gkea3OuNh+y
	VaVZRImZTsSQvgcGfgOjhybFtxwA6jf65KsQI1UeifmJyGauaBOU8moSeMFSRVQAdPI86i
	lHDv1L5NrNQ5PlpSZ5dxFf15Ov2iUEs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="GO++oe/Q";
	spf=pass (imf30.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.228.37 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pz2-f37.google.com with SMTP id d2e1a72fcca58-88732460a36so766877b3a.2
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 17:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790813669; x=1791418469; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9y30WpELg39m0gWRlLIOMYQuYZ98WLf1dAoujzXj64A=;
        b=GO++oe/QjIeNaHtDn5gLKBKtMapV+3W+vzJFbaI93SQ26aUrCllWqUEkw8DvK/CByY
         6Dsuaivnq3v7FXb40223Q+ed9depe8p7Xi8ztWFeSjUslSjTqOjUoGFe79SjDyrGvjra
         Jyse3558aayh8Su05361IRcomMkfQbrlQxheaA4psu6oFysKpZkqUlfHnjQaP8Xq2wt8
         0b2gPGbkb9VSxpKg5AsxIBWeVc55//mpuDKdV2POv7obBNjie6cyqyXL3vUDLdkq9mgV
         xaStQ8YuOPszV8X5av4GkhEkTETOEG41JiZ8Z98jahtuG8qigBYF4j+C77ymCwOovpTS
         nNPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790813669; x=1791418469;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9y30WpELg39m0gWRlLIOMYQuYZ98WLf1dAoujzXj64A=;
        b=xTZiHkZInhmdnfAjv0lbgrNLx5jDRceweZulnKioheFBvURUl0GWVHP22rMMusSsxM
         s94ocvrlSb2HAh2NRiCoX2mwRT/fuR047oX0Z7DO1YT3Otekwa4B2Rm4L1uqgwO96iZr
         tWK943S654WG0oSyDD63HasFNvelRn5IA/ZqC+pXUEDs/DGf63wW/lN0253gxAYdT/SA
         vbhXE/835YUcQshiXSIp/9Q8G2I8JPH6117+H9SWq/Bcq2uV6Oj/jojDJREkm0RwuSJO
         B4FbrLFRzItyI+iqhpoqvUPzAPtxTCFqz19zmFJnRMaauFCR329uDZubcedbZujcagf8
         mTGA==
X-Forwarded-Encrypted: i=1; AKwUvBxU3TbbDjN76taAqI9ju08ke9wFC29560mLW2Q8ONSta7/DI3vLehYpqTmxCTTDjlk4UhNHF1Yp/g==@kvack.org
X-Gm-Message-State: AFuF++mBiM5hBx6w2pZBW5PAGipNGJqd1huBbnibLkfOYAmS/wYygemu
	cSyYQ2Bj+ryxn3CMzQ3wbdx4aVSL0+o1u7zsr8znQtmlMn6Z5N8EUMmH
X-Gm-Gg: AYBFou0sPgSWy4UB7Qk3VPIwvxAlwIRjH/hlB+7Kxtzt1hfo5HPtp+6OkWcxczOJdq3
	VoPt7yNREqXFnw7bg6BGiwthiayNxhMx3IfLCrq5grn5ZMz7c/juCsq/6/Sr7KxXFZZyzl5kI4F
	0/ABcOstUOHBNpHXTS+UAIURppy7cfyQCca7ZIwWBKmT6jSG5H8ZOBEzxJ89rm6ZKNK7yTJYo2/
	SBXQUOWmSPvp6Z7yj9PzltwlS7Y0MYqhdnl5ZrWxefMJ7C6/vZGTkJ8Nx2/PoYpS3kBM3ibffe2
	jUYU9dWDdKe/egf/ExwWrp9O99TlLBC54hCBdMdQlwviKgW6gx0hrIGaFcAhvFVipUHjhhanHA8
	Z7/iUUJCls31h9DnqmAniAtbUskRxhbfIVDylJOlxR0V+sVRV69a6ZYFDqrPDdcimSD4jDjw+gn
	HRs6kkVI9rnOqY5j0XTcv6iE0jzN86Go7YKfr3ZHDXoyjOXAb9YvD1Z8k1RCt5WcnbTv18qHtV8
	CV+JNrYThANtUnp5+379xoWw5E=
X-Received: by 2002:a05:6a00:3019:b0:857:726d:2e96 with SMTP id d2e1a72fcca58-8874c4dc5b1mr2481627b3a.19.1790813669343;
        Wed, 30 Sep 2026 17:14:29 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-88818814b2bsm253287b3a.19.2026.09.30.17.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 17:14:29 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: akpm@linux-foundation.org,
	vbabka@kernel.org,
	david@kernel.org
Cc: surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhaonanzhe@xiaomi.com,
	lipengfei28@xiaomi.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Bo Zhang <zhangbo56@xiaomi.com>
Subject: [RFC PATCH v2 1/4] mm: compaction: parameterize fragmentation score by order
Date: Thu,  1 Oct 2026 08:14:09 +0800
Message-Id: <20261001001412.3837085-2-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261001001412.3837085-1-zhangbo56@xiaomi.com>
References: <20261001001412.3837085-1-zhangbo56@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: exzkfcpexpe3grpchjb89tupm1sdnfmi
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 89FA080004
X-HE-Tag: 1790813670-524180
X-HE-Meta: U2FsdGVkX1/bbJbieXHEYBREpxX/pzVu2HqWaUttZSeKqBJ1YNeyMb4zwtyGrL/3R7zh648Aolk+h4Yiwfji4Uc9sDp7J43g5q9ecM0Ks74fm+XO2icxNnB59pIINSt+gnmYn1cfBzfUOKEBynp/48ltU4PYC8HDtHsdv3Z62moa/ib9tJ4BlhHPIejqG6Bv5QdXyykcpwgMkCIGorh7GFsdchYy4g3flKDTeLv/tL1xNuYfLk1AuPaTtcBiVMeMzx5rGqcwhGFsaCoGiTMnGh8fr3Rv6pa21BPtK/ByILgd+VdVi+/slCVylz8VQXrc2bysQhtsOJnYpiC+09/yMGfgRF/l+/kO0HOypjNQKyClSeaETCSJ3XmNB8MsjAA4oCVXyJmIs18WKFJAbBXJnycQ7yZ3orSu4lO/QxXWgt7KuR/iEt54sP2Eas9Gscbe5N6h3B5a7GlPSg7R2eN3O6xSfuKT9Y3WvBtNWt4jxKflXwqZeA6X8o8nXKe46U22ai9zLxy5y5KEhAeQSfN1Isg4ZnR2HA9vXVQKMHPlyjJmxJWgRGSX6eE6gPEdtDjWXkS3EyCtclDQ7KQ+xefsrAy/JdsEcCITw9jXjyudhNX7FDbCro6Aglp7vLHTOv6iuLPYzAktiL/bN2lb8yEXdFZ95BvXAFtqrMzHKf0PEsfjHYan4aXpnp+TXRagLJf8yVgxALgdTnNoW23+h8NtVylNov96seWpSmmyjoyukPR2rtpZCsgIOyfXzgdwlmKYRfx8w38FuH1WNGhP7OxLgej53wwP5SLEHM1pIKVLeldkMyEMVjp3Fadig4hjVwmZqLEWy1pEJiS3FG5ggxiUG/9Au9xbDMhYRihe753BxWM+izLOSY5aLxru7Z5WU+7urtbFfUkG8CIZuD2qx+RbqpV8G46fHEwZ1wk3NT2LdIsDN01KrtnuuQNqAV0Kxfray9m0eZF6W/v3a+BW2lL
 GZlu00fm
 IHeL5lg1AQfXQP8SJci+8udeIHAqcqfUz7aI76AT7NCWdgy3NZ5wtga4K8+gMMiCIjh5Jn8CHMHXkvxAP4ha67fYW/HlgOBogLMHZKmVzQMqEcdh8Y/nzEMaGx5NQMlWV3CbqHvxPM36jtSMS/IGs92e+2NhyIHIOgFZN+mBXUHtTbp19Hr4GWmWY40FrZXWnuQF2/BjcM1ZeMKzrVb7YQkrU+FxFcPoncr4PRtvMhUqaXRZMM08F15yAbFx4/4vw6HvfL4/sDytOhJgk8PFiy5vgiwSHz9Q/JhlJgBUoBMmzJTapg2UpJB6fmgXXG3OxtM4HBT3PHtuOvguwgzFqZKjKIYuiN7DwkhvCD+skTBVwppXNfX/nsGuZ+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The proactive compaction fragmentation score functions are hardwired to
COMPACTION_HPAGE_ORDER (typically order-9 for 2MB THP). To later allow
proactive compaction to target other orders (e.g. smaller mTHP orders),
generalize these helpers to take an explicit order argument:

  - fragmentation_score_zone(zone, order)
  - fragmentation_score_zone_weighted(zone, order)
  - fragmentation_score_node(pgdat, order)

All callers pass COMPACTION_HPAGE_ORDER, so this patch is a pure
refactor with no functional change.

Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
---
 mm/compaction.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 4994e200bbec..ecd3e6cf54fc 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2208,16 +2208,16 @@ static bool kswapd_is_running(pg_data_t *pgdat)
 
 /*
  * A zone's fragmentation score is the external fragmentation wrt to the
- * COMPACTION_HPAGE_ORDER. It returns a value in the range [0, 100].
+ * given order. It returns a value in the range [0, 100].
  */
-static unsigned int fragmentation_score_zone(struct zone *zone)
+static unsigned int fragmentation_score_zone(struct zone *zone, unsigned int order)
 {
-	return extfrag_for_order(zone, COMPACTION_HPAGE_ORDER);
+	return extfrag_for_order(zone, order);
 }
 
 /*
  * A weighted zone's fragmentation score is the external fragmentation
- * wrt to the COMPACTION_HPAGE_ORDER scaled by the zone's size. It
+ * wrt to the given order scaled by the zone's size. It
  * returns a value in the range [0, 100].
  *
  * The scaling factor ensures that proactive compaction focuses on larger
@@ -2225,11 +2225,11 @@ static unsigned int fragmentation_score_zone(struct zone *zone)
  * ZONE_DMA32. For smaller zones, the score value remains close to zero,
  * and thus never exceeds the high threshold for proactive compaction.
  */
-static unsigned int fragmentation_score_zone_weighted(struct zone *zone)
+static unsigned int fragmentation_score_zone_weighted(struct zone *zone, unsigned int order)
 {
 	unsigned long score;
 
-	score = zone->present_pages * fragmentation_score_zone(zone);
+	score = zone->present_pages * fragmentation_score_zone(zone, order);
 	return div64_ul(score, zone->zone_pgdat->node_present_pages + 1);
 }
 
@@ -2240,7 +2240,7 @@ static unsigned int fragmentation_score_zone_weighted(struct zone *zone)
  * the node's score falls below the low threshold, or one of the back-off
  * conditions is met.
  */
-static unsigned int fragmentation_score_node(pg_data_t *pgdat)
+static unsigned int fragmentation_score_node(pg_data_t *pgdat, unsigned int order)
 {
 	unsigned int score = 0;
 	int zoneid;
@@ -2251,7 +2251,7 @@ static unsigned int fragmentation_score_node(pg_data_t *pgdat)
 		zone = &pgdat->node_zones[zoneid];
 		if (!populated_zone(zone))
 			continue;
-		score += fragmentation_score_zone_weighted(zone);
+		score += fragmentation_score_zone_weighted(zone, order);
 	}
 
 	return score;
@@ -2269,12 +2269,13 @@ static unsigned int fragmentation_score_wmark(bool low)
 static bool should_proactive_compact_node(pg_data_t *pgdat)
 {
 	int wmark_high;
+	unsigned int order = COMPACTION_HPAGE_ORDER;
 
 	if (!sysctl_compaction_proactiveness || kswapd_is_running(pgdat))
 		return false;
 
 	wmark_high = fragmentation_score_wmark(false);
-	return fragmentation_score_node(pgdat) > wmark_high;
+	return fragmentation_score_node(pgdat, order) > wmark_high;
 }
 
 static enum compact_result __compact_finished(struct compact_control *cc)
@@ -2305,13 +2306,14 @@ static enum compact_result __compact_finished(struct compact_control *cc)
 
 	if (cc->proactive_compaction) {
 		int score, wmark_low;
+		unsigned int order = COMPACTION_HPAGE_ORDER;
 		pg_data_t *pgdat;
 
 		pgdat = cc->zone->zone_pgdat;
 		if (kswapd_is_running(pgdat))
 			return COMPACT_PARTIAL_SKIPPED;
 
-		score = fragmentation_score_zone(cc->zone);
+		score = fragmentation_score_zone(cc->zone, order);
 		wmark_low = fragmentation_score_wmark(true);
 
 		if (score > wmark_low)
@@ -3237,10 +3239,11 @@ static int kcompactd(void *p)
 		timeout = default_timeout;
 		if (should_proactive_compact_node(pgdat)) {
 			unsigned int prev_score, score;
+			unsigned int order = COMPACTION_HPAGE_ORDER;
 
-			prev_score = fragmentation_score_node(pgdat);
+			prev_score = fragmentation_score_node(pgdat, order);
 			compact_node(pgdat, true);
-			score = fragmentation_score_node(pgdat);
+			score = fragmentation_score_node(pgdat, order);
 			/*
 			 * Defer proactive compaction if the fragmentation
 			 * score did not go down i.e. no progress made.
-- 
2.34.1


