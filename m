Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F618CA5FC4
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 00:14:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 618B06B0092; Wed, 30 Sep 2026 20:14:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C9E26B0093; Wed, 30 Sep 2026 20:14:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B8266B0095; Wed, 30 Sep 2026 20:14:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E7786B0092
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 20:14:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7B14E140282
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 00:14:37 +0000 (UTC)
X-FDA: 85272136194.07.CA5EECC
Received: from mail-pz2-f38.google.com (mail-pz2-f38.google.com [74.125.228.38])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8A4FF18000D
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 00:14:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WQXWkYnP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.228.38 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790813675;
	b=QfYFg20OSMwnJTaeXnJ7XzJkC8M2uN2b3RULJG0Ky4gz8m3yRzT/kCoFk3rbpNlkD21Mjz
	98Oqw2VaC0V4yOlHH75+wohhk5iV0s9yNJ6IR9pPNU46m65p9qqY1rafzruOZEPfhc+i7X
	/xl9oxIqZ3pbsv0hEe70+SCfR9KX5KI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WQXWkYnP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.228.38 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790813675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DThzymHkL9wnq5SXCYvzVRPWszN2sf2yPmrh709iilw=;
	b=JngjSPMj6AWtwX66Xyl3AsW9G8r8r//6s57Y3o9EYShMxISMpPfpOVsEXdn4CPHQ06y0HU
	ngCvk5LrvjQjpmF/dll9kNrIL4H34N9/HcYe5x7S4K8EUOQWtXn6v9W5JNBSmfUl8dLwWL
	s5i7tsP8WWbzrDwIjzofOn85DK8Z2sE=
Received: by mail-pz2-f38.google.com with SMTP id d2e1a72fcca58-88379342f7fso2638027b3a.1
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 17:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790813674; x=1791418474; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DThzymHkL9wnq5SXCYvzVRPWszN2sf2yPmrh709iilw=;
        b=WQXWkYnPAsJiWUgBkt2+E4igN1FrxjM46CSfRJLGmYwqC5o6GYEmsuDS1UoFsTASeW
         K9dQThGCNLY24BiB2UXEQ56/DZr2KO3f/lXlZ2ZujifqItkkLHl+9Q0FqbLwROqfruxn
         rIeSppFtAeOXELCHr16WAZ5UbzTpQrBNbYqYF9Vbrp5yGMT7bD3CcA1uqAjzK88ScqBs
         N6N8OIzgTlRvfaH7WffsRMRlQ3ZKMrQ0/UJiRKv9hHvfHYSnioTBnnuD9OjXNYljWY14
         qGcwm7aAfjsCASYjcp+5V6P8XgiWHxIwf9fNfjFMsprBnLzIqoFb4kye446GqMQKpgya
         uLvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790813674; x=1791418474;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DThzymHkL9wnq5SXCYvzVRPWszN2sf2yPmrh709iilw=;
        b=bTTQqywfuQ/gASVPiGE5iixdayetHRz8BFFMhLK+Ebq3TRhigKTboWpNITZ3hrB2ak
         I3GZqotZYV65j59ZO1jT7uxO+3DczJdGTfR2SgFKRDAIiucYQjffVzbIY8oLP+dL+PIT
         pykLHLNyoxhnoafeC/LENwdw6A5sO2UTRqEE6DsRFU4FdUEOxCCcCNQb9wNZrk7UtzcV
         NM6S0AG2DjaEIMyIMQtqmJ4PT5Z3CRb9ZK/fEKyaExqoyhiVi8OP4ZjZ9qtpQV/ee7VZ
         LJTrZUDd21ciUkBhAuut0LGtfML1RcDEdhWDVcPyerGZBTIwSkpbPqOlLS5DP3/8GX3X
         bMIQ==
X-Forwarded-Encrypted: i=1; AKwUvBwwRzB6hHmd58Ykw4v1LJW6fVW6iskeUYA8yaKVkHE13s4IbiM4DZJEUE5ZF0N6Vccr5Hr3p+mvXQ==@kvack.org
X-Gm-Message-State: AFuF++kmuRbgd+4FSF6p5WH2P/++B+qWVjt+epqq6enQ3qVauPm0ZI+D
	L+LX7vvXqtHkve2TX0jMOqY5gEcg1rVKB1msZ+X8ALKxlUXahqDjwX4Q
X-Gm-Gg: AYBFou00+lPs9OYOtUu5rFbDvA93G7YzMv+5u8fJA7V2jSgjzEd3kZo+L3sfsvahB7t
	Pw8TfomR9wDSppxNBIvq+EM00/VGdKqbac4FO3KqrXyPtmNwGfq+c0C9zYD5hcQPrzU0L489ogL
	IOyW89J55oga+SOkXxAftBMA5HDjTS/NAVKuGiRJjadeS64Eh/mMXSH5UnnsZlHrLS+Kr/+qBFN
	6MeeW8CFvNV45YWxLM/yS0PzMPswNYA1R7ae8cMOLHbZEwydROX0Lr3FNBEt8MwPL9x2Nm2kW8/
	DtItXdw+dMloCAkXHir76LehrE00r7q7HlRoDzN4teqa5DkhGd2kg9ACqUklMA4hWg8EtaM0g6g
	Ja11slgQejSbIkXX3YmBJXI/w4NGrIenSrcb6txsFGlmx0FcJrElBcYqH4r+kYDVCMlcquEIVNN
	BVqDV7q3/KL87ijxcO0We5YDlbEzlTUqyGZASwXIM5CZxBOnvEFcd/xbt8j5BDvV6ZIx4PC/uvs
	ZDgqIQitABgE9Fg
X-Received: by 2002:a05:6a00:4518:b0:878:1aee:fa43 with SMTP id d2e1a72fcca58-8874a7a12b3mr2206721b3a.33.1790813674273;
        Wed, 30 Sep 2026 17:14:34 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-88818814b2bsm253287b3a.19.2026.09.30.17.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 17:14:33 -0700 (PDT)
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
Subject: [RFC PATCH v2 2/4] mm: compaction: target mTHP order for proactive compaction
Date: Thu,  1 Oct 2026 08:14:10 +0800
Message-Id: <20261001001412.3837085-3-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261001001412.3837085-1-zhangbo56@xiaomi.com>
References: <20261001001412.3837085-1-zhangbo56@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: y35cwcwjzo844euaxxaiajkp6u33b1gr
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A4FF18000D
X-HE-Tag: 1790813675-987992
X-HE-Meta: U2FsdGVkX19vspBE8nxq6AmG9qGmeP9gxcZ4yWk45cGFoce2f0g2EKsK/TbaQR1s9mtVEhG7Wr9UzZk2JagP0U/RcpljUZKd+tM6AEld9qY9hsT041sH8HenZmNcREXyKZyCu8Ewp3m77O0wqNc8sCgRFoe3VV/UIODrc+QqB17YuvWvKNJp/GAZNzqluWHx4upZu12dGWTTT/hbtko0gWPKwMuOB2Mcjn94BieoOpFybiIwmaBp7YjOJ181KKufxIFRzZ5DhUjgCFzRMZUZP7Bk/8XUNe6dy1rTDH4DNhdMGqt1o5DIWw6d3e+uLAdMjWCNN1xMlzoMeSqzJeXfXlC1hA3j6i1q2gRZj4iSXbnMjL7Yz+p4+ayG9AwXVkgKngzw7bIA9/bOFxgef+dk41YUbWGB3X+3K4piKHtmHieZWOi32FTxO2YkZWmpFI4gqKgvfOgD/sv8en5ymwbSdkF3OSugk4cbnS4WM35+5E3MoV7fOY5+7/g2qW6durwtN2i6CShKYZg+CyrFKhK7KMth153iTHl2obbHSTDjg2WRE4lS8DsmTTM+GIFgm0lSttdDkc3HtdALxaOGwX6UEB03VPIECDVwRpyrr+yhJnLUVdcgzcHWh3HiQpCFd60Ovo4lxtvCi0iGMgS0l9HwAFPmB4OK5AkHdsKQAakm4hw9ts9E1zO05iMjDMAs/Ezrz7ZV3t1OCZn//cz4vPx48mgGrE6SssIRbBdINvw6fJLQ+NVrlgBufrBi3r8btV9OYs8o/aiJeUTx97RcdK/2JsBW1SGcr2lpgZbxgnflXm6CMmFw5NHhDS7FlmVgUceY55mVU6lCO5Py1tnkq8lLeTYU7777D+YTI6ir2HRPYmNZrVlguo2iSAYnxUNwDR7dJ1fq8RZOc4HtQ6cdNbdpTdxPi0E8nZ1rXLqQvMhvMH9FCv68iKIQrp4CKEqjF7JYybnsLUpw5wzQM4t4qWd
 b0/hiIdc
 TFm5mxCohb2C+d/BfmfJkfiOjGFiDyLxKZ9rN//fo6Z0kkTdwRw3hMFu0JtCenMeedyFF5rMoERdSCZDgOJK4tG3l3SQtUV43G7jrJi6N1pIfdIghVcMH+LDa1Nz2xI7JRtxzEy6cS44voy/DJ7j/Yyh6+AeVWHp655bosK6VPEA5Ouc/UjkWYXZPHmARQS0VWCDOmlHbPOuN4TxkAQWPoYQXf4Lo3Y8Rp1BpdUNQFyfvYpWaxH0HMsjViTOsZktlFc4umDGICLrITgulcNCK1rItK3BOJF3zalceeDpRZyhAAlBPxVKwIQpnSTlfHT4IGXOdBrquUDilNlKHGnJkaR5wg5C4POGFwTKkbcH8eMtH7BzkPTsufOIejA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Proactive compaction triggers against COMPACTION_HPAGE_ORDER (order-9),
which is too heavyweight and misdirected for mTHP systems where the
pressure is on smaller orders like order-2.

Add compact_hpage_order() to return the highest always-enabled anonymous
mTHP order, and use it as the proactive compaction target in
should_proactive_compact_node(), __compact_finished() and kcompactd().

Fragmentation scores are not comparable across orders, a small order
scores much lower for the same state, so scale the proactive watermarks
down in proportion to the target order, otherwise order-2 would rarely
reach the order-9 threshold.

Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
---
 mm/compaction.c | 40 ++++++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index ecd3e6cf54fc..3928a5483efc 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -24,6 +24,7 @@
 #include <linux/page_owner.h>
 #include <linux/psi.h>
 #include <linux/cpuset.h>
+#include <linux/huge_mm.h>
 #include "page_alloc.h"
 #include "internal.h"
 
@@ -81,6 +82,17 @@ static inline bool is_via_compact_memory(int order) { return false; }
 #define COMPACTION_HPAGE_ORDER	(PMD_SHIFT - PAGE_SHIFT)
 #endif
 
+static inline int compact_hpage_order(void)
+{
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	unsigned long orders = READ_ONCE(huge_anon_orders_always);
+
+	if (orders)
+		return __fls(orders);
+#endif
+	return COMPACTION_HPAGE_ORDER;
+}
+
 static struct page *mark_allocated_noprof(struct page *page, unsigned int order, gfp_t gfp_flags)
 {
 	post_alloc_hook(page, order, __GFP_MOVABLE, ALLOC_DEFAULT);
@@ -2257,24 +2269,36 @@ static unsigned int fragmentation_score_node(pg_data_t *pgdat, unsigned int orde
 	return score;
 }
 
-static unsigned int fragmentation_score_wmark(bool low)
+/*
+ * Fragmentation scores are not comparable across orders: a lower order
+ * scores much lower than a higher order for the same fragmentation state.
+ * Scale the watermark proportionally to the target order so a small order
+ * can still trigger proactive compaction; COMPACTION_HPAGE_ORDER keeps the
+ * original threshold.
+ */
+static unsigned int fragmentation_score_wmark(bool low, unsigned int order)
 {
-	unsigned int wmark_low, leeway;
+	unsigned int wmark_low, leeway, wmark;
 
 	wmark_low = 100U - sysctl_compaction_proactiveness;
 	leeway = min(10U, wmark_low / 2);
-	return low ? wmark_low : min(wmark_low + leeway, 100U);
+	wmark = low ? wmark_low : min(wmark_low + leeway, 100U);
+
+	if (order < COMPACTION_HPAGE_ORDER)
+		wmark = wmark * order / COMPACTION_HPAGE_ORDER;
+
+	return wmark;
 }
 
 static bool should_proactive_compact_node(pg_data_t *pgdat)
 {
 	int wmark_high;
-	unsigned int order = COMPACTION_HPAGE_ORDER;
+	unsigned int order = compact_hpage_order();
 
 	if (!sysctl_compaction_proactiveness || kswapd_is_running(pgdat))
 		return false;
 
-	wmark_high = fragmentation_score_wmark(false);
+	wmark_high = fragmentation_score_wmark(false, order);
 	return fragmentation_score_node(pgdat, order) > wmark_high;
 }
 
@@ -2306,7 +2330,7 @@ static enum compact_result __compact_finished(struct compact_control *cc)
 
 	if (cc->proactive_compaction) {
 		int score, wmark_low;
-		unsigned int order = COMPACTION_HPAGE_ORDER;
+		unsigned int order = compact_hpage_order();
 		pg_data_t *pgdat;
 
 		pgdat = cc->zone->zone_pgdat;
@@ -2314,7 +2338,7 @@ static enum compact_result __compact_finished(struct compact_control *cc)
 			return COMPACT_PARTIAL_SKIPPED;
 
 		score = fragmentation_score_zone(cc->zone, order);
-		wmark_low = fragmentation_score_wmark(true);
+		wmark_low = fragmentation_score_wmark(true, order);
 
 		if (score > wmark_low)
 			ret = COMPACT_CONTINUE;
@@ -3239,7 +3263,7 @@ static int kcompactd(void *p)
 		timeout = default_timeout;
 		if (should_proactive_compact_node(pgdat)) {
 			unsigned int prev_score, score;
-			unsigned int order = COMPACTION_HPAGE_ORDER;
+			unsigned int order = compact_hpage_order();
 
 			prev_score = fragmentation_score_node(pgdat, order);
 			compact_node(pgdat, true);
-- 
2.34.1


