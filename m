Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C14ACC5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:19:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 917CE6B0124; Wed, 12 Aug 2026 08:19:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EEBE6B0125; Wed, 12 Aug 2026 08:19:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7910A6B0126; Wed, 12 Aug 2026 08:19:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 511C86B0124
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:19:03 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E464EA0306
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:19:02 +0000 (UTC)
X-FDA: 85092521724.19.FF80E9A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 40DEDC0003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:19:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LBhdAmMP;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786537141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EjEFNnCpD4D3Lv/lQ5ONSKNhGjrzUmBvcQ2L3a1JEFU=;
	b=cp6Ibnjud7OafhQ07q2n+P302yCD0o7qwer8/RlLc5ml9g/0/gblhau/0jvS/xuGm43Odt
	11ItL4pKmiDI8jWjJVIcPORj19wFHiPZBmfh8VY94jnF63Z8hjTAnWArFzRcou58Uytmuy
	YaMvYISQGo7jyDu1v+lEn2pLoAJKuG4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786537141;
	b=ROH1iJK7VhofdR1TLo4qOLPEKzYhwAIchsJn8h5dMnyipMTp8R4rG5KXehuvWiZO4OboYp
	F3c876r4Rkkw0aN1mNWMC4JK9kVwYtYEfP3IurfS6ELbXcc2IUchQsBasPO9cUliABwdTL
	DA/a/+9eh5CoXXdeVQcyJI/lJOVrmw8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LBhdAmMP;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 74C9444F4E;
	Wed, 12 Aug 2026 12:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32641F00A3A;
	Wed, 12 Aug 2026 12:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786537140;
	bh=EjEFNnCpD4D3Lv/lQ5ONSKNhGjrzUmBvcQ2L3a1JEFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LBhdAmMPlplf3Bg92sH4iyezEuXbZq+Aty9njEgnfcU6LnlXUhz4A21zPKV9HLkMl
	 ER86pfSDbHephWBRVfUOxQvwVHdGdvrvYsrFhzgMiiCK61wNOrHku4XGoc7hmcaY/o
	 ZX7/uoYReatWEjiHsybiI12sdGVsB4Ms0nZx6VgVrbriv28ehJ8nwzBX9i5MToUJhb
	 x07/d5PhUaaUT5WGDgYJzmegz+wWP2umpkoX0Hh7gr1a0XU+3a6NmK9/M6lkkkciXo
	 FBsv1wRRSEbgWzyGCbtY/bpL1I4z3uiN07VoDfmKzkjIESjlPG09aV94gLQz9wua8X
	 FykVKjgdS6+cg==
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
	Barry Song <baohua@kernel.org>
Subject: [RFC PATCH v4 14/16] mm/mglru: run aging when pages are severely imbalanced across gens
Date: Wed, 12 Aug 2026 20:16:56 +0800
Message-Id: <20260812121658.69965-15-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260812121658.69965-1-baohua@kernel.org>
References: <20260812121658.69965-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ajhpehrqdhwfzoyo1urzy9a1ayj9cbko
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 40DEDC0003
X-HE-Tag: 1786537140-883490
X-HE-Meta: U2FsdGVkX19mF4hTrqvYN1GSuo8fh2SIOO+pJD7x9dCHEuc+baPa5RI4e78puxutElIzjK4DP7KMI9Lq8CxTcfWiLkP7BMPiKRHPFJ883N5p2Y0qfFR3X/WC5sUA1Vo4++KyJlI7pQzFPsU1936Z/4etFRJWynFAHWc/Cr4gB7dsK6v97bjh9b4fpmJ8T+h7Zg+ySwmgNTAa6NbsHI+H9b6mxmxl9FSuo1S6mvjvkxzUivUah5BLKuyGlOUUiUhlrJTzVfNqEZz3yvjVZyoJhL6rE0uMgo+EN/+EJowSvzL1KckMmcxrR/NkV9jY8prPBqszpGd8Vr0aDljGjMAMAgk0ky1hc3ejpe2O9q4IJZBbLAlAW5EGBdVRYh/6g13BqgiJQQ8X3/FtGbYr6OACG5QPQwt7wme5M5pfhV4uWLPO483vPuk01b08KXHphR1FS9IJ1qs3pEuKXJ2Pm7WyrCdNsqYuHCUexNJSNg4JBP9l5qLnKTR5eCGS5USsqYEBkD7JuGf1qkR9AYBRi9FUKRaSdxWxspb/1Uw97B9eoWdKqaQwqqCWgvzKDECXxwKAdqNSnW/m4Q6HSPWwZ6Type/NY1I0DYb8lvQPH6hjiT48AVJE9weWihcdu8okA9CIFMHS2BQw60AjhUanuoT4QuBfT6UbyMkhnj58IwJt01sZI5o6d4Pr6bnIqRDGzc0sWNcj2vD+yp/zQXY7TDJPVuf29Nzu0DzpRWvXdc8MtK5gTXLkDk4IzAZAtMbFZVqZ2F7X/PDAuxAKfhInquRDhxgH23fJx3EGAgt0sCl6y0xS6Se8YxiknRcKurEb9NrLKMEN9unR9mkTmW9eOvUoS1/t+pUYPtXaFSyj4V2zjjJmiHuw3mMSUtXQJe+IyGdNprveJU+r+ufHHiNVa17luCeB7mHYYmVyMNOHEyb9Jjuxt4n5i5SZBJNLp56JQuyCKSQoet746hLvVIGnpz3
 yXwddLYB
 TP97BCtholQsNf9IRbq8mQzx0jXNFV8uwrLjTGnEbQjdtwUaP+w0mqrwUTMA2OpT8BL+fZ4U3v5sVy9mafePBmXeKfNp+gJybzVPqsX7GzBwyAoXBPspol82FZZEWs6O3oIexzDN/8u+OAKdzn14sKvILJiZjRSiwU1L0EXvx1c9fGaH1LMSfNh9rvydcpNrJ6CF90NJKcRf++w7G9aKimQo2GlnZYekQ/ramq2yQM2zhaWEJ0qwyz7iMw7/5OhN4KF3DgXdwl6de0zUeHyyef85oUoRNW0tVEV8GzC4DAlPnhR+fkD6x6kZiZFvTRyULGe89W6MnRMuRSPzFClRd3rwbhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: lyugaofei <lyugaofei@xiaomi.com>

This partially restores the reclaim behavior introduced in Yu
Zhao's initial MGLRU commit, ac35a4902370 ("mm: multi-gen LRU:
minimal implementation"):
	/*
	 * It's also ideal to spread pages out evenly, i.e., 1/(MIN_NR_GENS+1)
	 * of the total number of pages for each generation. A reasonable range
	 * for this average portion is [1/MIN_NR_GENS, 1/(MIN_NR_GENS+2)]. The
	 * aging cares about the upper bound of hot pages, while the eviction
	 * cares about the lower bound of cold pages.
	 */
	if (young * MIN_NR_GENS > total)
		return true;
	if (old * (MIN_NR_GENS + 2) < total)
		return true;

But with a stricter condition: the younger generations must
contain at least MAX_NR_GENS times as many folios as the older
generations.
We also consider the cost of inc_min_seq(). If the oldest generation
of the other type has fallen significantly behind, pulling those
folios from the oldest generation to the second oldest generation
can be very expensive. In this case, skip imbalance aging unless
extreme swappiness is in use.

Signed-off-by: lyugaofei <lyugaofei@xiaomi.com>
Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 50 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a276560bc66b..d6fac5b91ac1 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4219,20 +4219,28 @@ static void set_initial_priority(struct pglist_data *pgdat, struct scan_control
 	sc->priority = clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
 }
 
+static inline unsigned long lruvec_gen_size(struct lru_gen_folio *lrugen,
+		int type, unsigned long seq)
+{
+	int gen = lru_gen_from_seq(seq);
+	unsigned long size = 0;
+
+	for (int zone = 0; zone < MAX_NR_ZONES; zone++)
+		size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+	return size;
+}
+
 static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int swappiness)
 {
-	int gen, type, zone;
+	int type;
 	unsigned long seq, total = 0;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	DEFINE_MAX_SEQ(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
 	for_each_evictable_type(type, swappiness) {
-		for (seq = min_seq[type]; seq <= max_seq; seq++) {
-			gen = lru_gen_from_seq(seq);
-			for (zone = 0; zone < MAX_NR_ZONES; zone++)
-				total += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
-		}
+		for (seq = min_seq[type]; seq <= max_seq; seq++)
+			total += lruvec_gen_size(lrugen, type, seq);
 	}
 
 	return total;
@@ -5092,6 +5100,37 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	return scanned;
 }
 
+static bool lru_gen_imbalanced(struct lruvec *lruvec, unsigned long max_seq,
+		struct scan_control *sc, int type, int swappiness)
+{
+	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	unsigned long young = 0, old = 0, lag = 0;
+	DEFINE_MIN_SEQ(lruvec);
+
+	/* we still have enough generations to reclaim */
+	if (min_seq[type] + MIN_NR_GENS < max_seq)
+		return false;
+
+	/*
+	 * Trigger aging if the preferred type is running low on reclaimable
+	 * folios, provided the generation lag of the other type remains small
+	 * enough that inc_min_seq() introduces negligible overhead
+	 */
+	for (unsigned long seq = min_seq[type]; seq <= max_seq; seq++) {
+		unsigned long size = lruvec_gen_size(lrugen, type, seq);
+
+		if (seq + MIN_NR_GENS > max_seq)
+			young += size;
+		else
+			old += size;
+	}
+	if (min_seq[!type] + MAX_NR_GENS == max_seq + 1)
+		lag += lruvec_gen_size(lrugen, !type, min_seq[!type]);
+
+	return young > old * MAX_NR_GENS && (lag < MAX_LRU_BATCH ||
+	       (is_extreme_swappiness(swappiness) && sc->priority > 2));
+}
+
 static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 			     struct scan_control *sc, int swappiness)
 {
@@ -5110,7 +5149,11 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 		return false;
 
 	/* better to run aging even though eviction is still possible */
-	return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq;
+	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq)
+		return true;
+
+	/* Run aging if the preferred type is severely imbalanced across gens */
+	return lru_gen_imbalanced(lruvec, max_seq, sc, type, swappiness);
 }
 
 static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
-- 
2.34.1


