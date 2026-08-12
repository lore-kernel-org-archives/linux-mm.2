Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3142AC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:18:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D96D6B0106; Wed, 12 Aug 2026 08:18:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98AAE6B0107; Wed, 12 Aug 2026 08:18:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 851856B010A; Wed, 12 Aug 2026 08:18:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 65A8F6B0107
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:18:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 76EADA034C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:18:14 +0000 (UTC)
X-FDA: 85092519708.30.C41DBEC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id C7EFD12000D
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:18:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FY75tQDd;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786537092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zTdKsivSVml3nMVoycYBOOaMCkJqeu1cLwVQEk8xkYQ=;
	b=FZ5eEjYCoRT3+w+6HNM3YmgmJTbnCYkbw3n3a/9KE8Pwuj2soeo9BDCI1y7ehPs9dmYI+i
	TUAoOCRLZZCoVFiEKkqaQdT47IwRbSBm8umoP6PoBVVlxIaEZL31G63smCl4IjPgR2sxyZ
	DScD4Ut1WL4mkk0o6X4KMIXMA613L+0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FY75tQDd;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786537092;
	b=XwOA9HXK0PP2C7z5Q4kCFyhYKOt9+9Yy0RKi7fYKpOPoKEZ8CUdWzE5NLpUkSIFcYlogU9
	RYkgroskG0WbdcgjgI0m70O25RSdDYkH8j6zkbHcd8Gvlb87sTXrI5IZp11e/0gZi0/p9b
	lzH+X1pUcL5/h4zaMBMVHkRmftj28CU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2761B40483;
	Wed, 12 Aug 2026 12:18:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640BF1F000E9;
	Wed, 12 Aug 2026 12:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786537092;
	bh=zTdKsivSVml3nMVoycYBOOaMCkJqeu1cLwVQEk8xkYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FY75tQDd1dy7KRMYkQVZVOWKUDTzrMbOQF8/iIjIN9Otz6yx5FHINrncJKvdrVmR1
	 CWkJt1HhXEs4EKGktK9a9lKaup8GD6nadgSz1h/gZpHgSgmxrPWE2TRd15/SV+BzHn
	 HQRYrIX18vLxNtH0PDxH03qbdWd+xHCX4H2JAn1AvzrnZUNxigrMVZ0v7xP9pSewAC
	 SBQVYW2xg6yP0p4gGMM5UbZdp6rOBsdRCGDj7VQorqtUK1+DtUBrjOgmGSkhpabzNn
	 pDMmd+Urq82UZiczyGt6H82IiWhhSlB2PUaVkbcMoxpjSAZypoWP83zPnSsluFSaTg
	 jL4Fnvr1I3Lqw==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
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
	zhangbo56@xiaomi.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH v4 02/16] mm/mglru: improve scan_folios() exhaustion detection
Date: Wed, 12 Aug 2026 20:16:44 +0800
Message-Id: <20260812121658.69965-3-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260812121658.69965-1-baohua@kernel.org>
References: <20260812121658.69965-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C7EFD12000D
X-Stat-Signature: xo4h4oupur7mw13rhhpo64bf4tyoimh3
X-Rspam-User: 
X-HE-Tag: 1786537092-852925
X-HE-Meta: U2FsdGVkX19xUZu27jp0b53bGZbwGr+4NIWgE10yXZf8XE1yZIj54vVWCaRAxHKyCYR2pyAr8gQ/K45OLRQhhTsTbLD8nXjI83L4lyLA33dLLtcBcMkeSdericnP7z9XLFTGBZT8wLFKhDdZdMe80CVQ+xP/nrUA4NbVVNiOfjkUTzbw5ISgJYnDNOLp0J5j6l3u3gsrjDSU92tT21BDKVCJ+h3hhIzoN9AolatXwCtkuJkiOe5yAwBfFJUXjKkg175dphvFdeC6e+2qqwI9urukw1EbUBsFPq/PUuC3UvRfMJV6shA1qCqbuezN72Ij/M0qqnSqr6wJaabAdsyLoHPp8I/7l9xVKo/5WcblTu3ZfdwJtn1s/kVcCUHsmEyBLYcB2duTcPiigxnXk0qHMO4IHKr2IPgc02Ii0EPgtquhzVP4LAept6ZOAU14KuBKQpoVzlzjjG0VTErGEPetQEWappe/6aNA0iKR0wa2rkYeMRN7LeV2sWxIikYQvfKrGv5WPAYDxjHKVc3JhS60ArXZxO5cP7+4U+2W1fFpFht8mZ7ajEmGx/HqaI75ruGsdf9YkmxM22wjvZXQ7RhdoYTupbavtHTMFykJZbdrh7PLHcvXrTUElh+G05QGMH74/hwjfCIwW7bBKERs0FCcSKPFblo89zxTsdBRPgOZKiq2tUYBfylM6/ee7COCHbtkO4upPFZU+WVFdm036Z7w0nvPWTVBoBQdpLxcWNUC8Ukb1E0AEpd+rgfMEXwmognJA2G0psbbLZZ8xLRRFHJKHsKTv7rCNKX9l7yPZI6tgDmg0SvzlgxyG9hW1p++zP4bIFKi8bhdrvzd5oZU024Cce2hhOEFpVIwT94xFxGfaGlksQ252J31lK1e8V2Zgne5NWyA7YpyBq0rm0e0majw4kSVKrFjJd9a+UoCCXaabcFv9ol3HU/UTNP8EG5j6T3kjlbljROKpf4ljdj0xKb
 vUL6Q+qo
 PUAE/XzOnLQYPnPBvkji8KTh8lCIfG6Kh1QloZrvAe22vjWK2PrJ6VX3kr1+cpXcadb5QcvFgVT7RHKD9kVE2l+/JEXwxeJI4FzxtiEQquPwZdFIHYaNN5fTHLbswI7MdKOkKc2qjo691Xf3sLBKKcpiY9+A+54RTi5+Q7LuGGUYyr6/18+hJVmXTOsTQv6tndSPB+1fcYRUugtZc41IhZ/ACc7Cxka3MSi3v286Y5BodFPxxFN6wrEnafWPcNbUFp6I4S8JUPzlCV8D05uQXlaNg7fgVFdIo9JCn39kTEyOqQGGiToxYMUUb2DBwa0t/VIVBIPonDFTwnRtUgmoAHjOUo1VKl0Qv/nPZSH1vCsbCR9M=
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
index ea058692b9a5..0670a25d3a7e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4727,7 +4727,8 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 
 static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		       struct scan_control *sc, int type, int tier,
-		       struct list_head *list, int *isolatedp)
+		       struct list_head *list, int *isolatedp,
+		       bool *exhausted)
 {
 	int i;
 	int gen;
@@ -4738,12 +4739,15 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
 
@@ -4774,8 +4778,10 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 				skipped_zone += delta;
 			}
 
-			if (!--remaining || max(isolated, skipped_zone) >= MIN_LRU_BATCH)
+			if (!--remaining || max(isolated, skipped_zone) >= MIN_LRU_BATCH) {
+				early_stop = true;
 				break;
+			}
 		}
 
 		if (skipped_zone) {
@@ -4784,8 +4790,10 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			skipped += skipped_zone;
 		}
 
-		if (!remaining || isolated >= MIN_LRU_BATCH)
+		if (!remaining || isolated >= MIN_LRU_BATCH) {
+			early_stop = true;
 			break;
+		}
 	}
 
 	item = PGSCAN_KSWAPD + reclaimer_offset(sc);
@@ -4796,6 +4804,13 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
@@ -4853,11 +4868,12 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
@@ -4870,7 +4886,7 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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


