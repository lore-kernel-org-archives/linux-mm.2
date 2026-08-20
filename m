Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79002C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 04:57:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 751186B0095; Thu, 20 Aug 2026 00:57:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 700CF6B0098; Thu, 20 Aug 2026 00:57:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F0826B009B; Thu, 20 Aug 2026 00:57:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C7DA6B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 00:57:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B197E80235
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 04:57:09 +0000 (UTC)
X-FDA: 85120438578.17.7CEBC99
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2167810000B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 04:57:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WEu0ANyV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787201828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L/wIz6ML7okFnhQHn92A6v7algKS0sqhHpGu7c56urE=;
	b=6vZxKCJySBrF2dkqqf3h+hVVfMm1CkZVAgYwPmy7yuEhpGme0LyGDL6P6ROxQP0d8sCHrs
	/Laui+KejlNJlElppu0lOE3hgNJ94147fzHONiCAwgFjSoFoBRHEU6r9J4ckUbabXZ6JZm
	+xBo4ked9h15emDUoEKlu+1gB8dYzS8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WEu0ANyV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787201828;
	b=Dsjw9J2uamsjQqVKXEa2G5pzL4tb7OiIiNANClN0nI4D96LOoClOOX8uL9LqhY0c/8DCUO
	UBh1sjTnXJo1qtkmbgBc6Yxmc5Uh3uMejqx3oYFMdhQOSy4ERJIToeg+Phq7ZUIO5UwEHL
	luJiSio0J7NXdSQk963VXmqJVre5DD0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BB14561890;
	Thu, 20 Aug 2026 04:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08BD1F00A3D;
	Thu, 20 Aug 2026 04:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787201827;
	bh=L/wIz6ML7okFnhQHn92A6v7algKS0sqhHpGu7c56urE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WEu0ANyVg5sufXEXgQXZ8Au81gfHVhKXozFhGTGmNlmE7UxANI9x5BG3Z2rDfPLkb
	 j/r1D31sKJvTTs4HsmlK64aOy0CzjHta2ur1HdOq37AakH4TMc+/BD1VD6sx5ZRh6c
	 sF50jzK1+3pZl/G4Z27dHqW6eh2HbvTtlPr7skKofsYJXZopMcNH1uIJu4OL7SK4XJ
	 PrUQ760Joovr8SgYju+nlsYQxwNJhGbnsAcdlKH7OGINshuSU1kiFY/+WrEYk0SjGG
	 yRV1Xv9XtG6mFWbJ9Tt6ko2TxBLG4vwKEVcktLC3MQOgt13+KAowh7VwLLlzJq3Jun
	 ra5gjG+aCJCfQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH 2/3] mm/mglru: improve scan_folios() exhaustion detection
Date: Thu, 20 Aug 2026 12:56:02 +0800
Message-Id: <20260820045603.68809-3-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260820045603.68809-1-baohua@kernel.org>
References: <20260820045603.68809-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2167810000B
X-Stat-Signature: gypchg1zj9p6xzxok9qd5nc5kfpkq1mq
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787201827-304400
X-HE-Meta: U2FsdGVkX18KljCWevlMPGK5wUhqw9HIX7LucP79+N1XtWKcwmMDypn8yo2+/cXzm+ssuT/P3B2xILvewjLgR0FiokSgD1t0CvN8krxL33ezb8zWDBGRCdY/fFtReIueE8zPzGUdRGobiVPrLBCYeM35PXAXp1Di8xAROAyCJE7A/D/ceZcPSe8llGHkf2R4/Cy66md2zaHzcibhcz3G2Uefbqfbb4rmfO2gHM1XDoXdBvmc37o5adt4hChPfmVo2gX7/OGheIHKEH9qAHF4MIPHSYpagAo6Avltf50Ok9gxIghR4QJWSSnegzG4XwfAikoQcPLL1q7DvZwKzlHf9fxXF0boRyuqX/lNGxNoR72A0PzXbi6p5lIfRIyGOYODurubmVpw1l1SwE4stwxJlatZwrCkrybfBR9vvduNI2zWtLWixsU6HHovvy0Llzk792r8vqhHkXq0c1Tt10D/SULfa3TcKMo68XFcA86vPOfPOkAB4f8uS7+k4MhNM/5cHY2dSZM0BNSqBMTwMrrzmqtnVeAzrWBgxNAEVXrjcY+IXabO3653Glj4bp5HzJaHjx54O1lGAV2Twn3PiLpAX+iX7A0krOTJQty+94R4FZCO6/vyBJGSSSlp+Q8pVoK48NnWzaGBa0r311ZXrDcan5e0Eox84YJJ7KH37fCuB3i2rcvGaP2cYRkVOUs1VAwvt9bWXVoz8gI6xgTIwmhe1GQivRLSEcridu8XFHALXfN4wj8h9ptUNy7r2b9/u0goVbXFNWst44SHj8JSQsxphe6rH8yO3tJRN3mkqtPPWC1lOzkxYQQIrZZFIVDK3rE5KXw5IG6WKV6cgLDQmXQFbtP1kK5BOwCliFVIpEZh80/i2bJfpVzeO1ZGkG5dHlmsgjUZZf4/rbIbYHtJxc/vBlo+Ow1Om4zkpm7r9Hb+HKvQ+rVdt/KlegxIUDpJkzEZ0C1MewY/FN3R7e+jpH5
 nJi08rnM
 l81JhUkiaQSUeBx+xRriNgfIijBpClrcwPJoT9LFxsAndeK1EW9Oi5AO4NRyNFmEz79LnpBRK/Wu4mxWmAW9TZcvxfuwXtuefqRp6ut1l70GV2kUmMyBs1+9SM3KXPWNoF3sClsCnn5yNt/OSNgZ3Cj+qpybJvm4/zWKR3jsIp4Tdu52TbyDPpD4GJzByCRAj0wvpXJJF9wiU1bDlKXiQeW6Yi5lWLoTHLnouFJaVhCm4JLvynj7QAhn4vEK1XjoPM6P/BG2lXM183iynHBWKAfrwhn47tuBHDbADKtUMeRMHPEqEtWx8ubegIv5PGla1W6P2opM+R6YQTQRGGftY7wC8ETPpX4BVwd28WDwP2KBnXgI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 16b475d2ac3c ("mm/mglru: avoid reclaim type fall back when
isolation makes no progress") uses scanned == 0 to determine
whether scan_folios() has exhausted a reclaim type. However,
this is not always sufficient. It is possible for scanned > 0,
while the oldest reclaimable generation is exhausted after the
first scan_folios() call.

We detect early_stop in scan_folios(). If we stop early for any reason,
it means the current reclaim type is not exhausted yet. If early_stop is
never reached, it means we have exhausted the current oldest generation
without hitting any scanning limit.

Another issue is that if the lruvec has 4 generations, we might have
exhausted the oldest generation while the second oldest generation is
still reclaimable. In that case, this type is not exhausted yet.

Add an exhausted output argument to scan_folios() so it can
explicitly report whether the reclaimable lists for the current
type have been exhausted.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index d5cc30b667ad..1f2e574b0061 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4721,7 +4721,8 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 
 static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		       struct scan_control *sc, int type, int tier,
-		       struct list_head *list, int *isolatedp)
+		       struct list_head *list, int *isolatedp,
+		       bool *exhausted)
 {
 	int i;
 	int gen;
@@ -4732,12 +4733,15 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	int skipped = 0;
 	unsigned long remaining = nr_to_scan;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	bool early_stop = false;
 
 	VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
 	VM_WARN_ON_ONCE(!list_empty(list));
 
-	if (get_nr_gens(lruvec, type) == MIN_NR_GENS)
+	if (get_nr_gens(lruvec, type) == MIN_NR_GENS) {
+		*exhausted = true;
 		return 0;
+	}
 
 	gen = lru_gen_from_seq(lrugen->min_seq[type]);
 
@@ -4768,8 +4772,10 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 				skipped_zone += delta;
 			}
 
-			if (!--remaining || max(isolated, skipped_zone) >= MIN_LRU_BATCH)
+			if (!--remaining || max(isolated, skipped_zone) >= MIN_LRU_BATCH) {
+				early_stop = true;
 				break;
+			}
 		}
 
 		if (skipped_zone) {
@@ -4778,8 +4784,10 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			skipped += skipped_zone;
 		}
 
-		if (!remaining || isolated >= MIN_LRU_BATCH)
+		if (!remaining || isolated >= MIN_LRU_BATCH) {
+			early_stop = true;
 			break;
+		}
 	}
 
 	item = PGSCAN_KSWAPD + reclaimer_offset(sc);
@@ -4790,6 +4798,13 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 				scanned, skipped, isolated,
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
+	/*
+	 * If we didn't stop early, all reclaimable folios in the current
+	 * generation have been scanned. We are exhausted if this is the last
+	 * reclaimable generation.
+	 */
+	*exhausted = !early_stop &&
+		     lrugen->min_seq[type] + MIN_NR_GENS == lrugen->max_seq;
 	*isolatedp = isolated;
 	return scanned;
 }
@@ -4847,11 +4862,12 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	bool type_fallback_allowed = !is_single_type_reclaim(swappiness);
 	int type = get_type_to_scan(lruvec, swappiness);
 	int total_scanned = 0, scanned, tier;
+	bool exhausted;
 
 retry:
 	tier = get_tier_idx(lruvec, type);
 	scanned = scan_folios(nr_to_scan, lruvec, sc,
-			      type, tier, list, isolated);
+			      type, tier, list, isolated, &exhausted);
 
 	total_scanned += scanned;
 	if (*isolated) {
@@ -4864,7 +4880,7 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	 * We are running out of the current reclaim type. Fall back to
 	 * the other type if allowed.
 	 */
-	if (!scanned && type_fallback_allowed) {
+	if (exhausted && type_fallback_allowed) {
 		type = !type;
 		type_fallback_allowed = false;
 		goto retry;
-- 
2.34.1


