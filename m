Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 521EEC531FA
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 01:30:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4734D6B008C; Sat, 25 Jul 2026 21:30:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 424CF6B0095; Sat, 25 Jul 2026 21:30:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 361D76B0096; Sat, 25 Jul 2026 21:30:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9CD36B008C
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:30:05 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D4DE2A147A
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 01:30:04 +0000 (UTC)
X-FDA: 85029196728.19.3D17537
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 312F140009
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 01:30:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="B/c/+WNY";
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785029403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9jhQTuuPD9KwcoX/z0WxrFRGD97WTuKY5ASJ3vGdEAY=;
	b=w1J0a1MdqnTYA8QgKpxe05m61dABlrTyFMkoEpl213yWDHbgx4T4b53pHl9VBcswOOxPG/
	EDiJ1CnyqcZt9i+xYnv/GIDwaiRKtb8UPSnzkgA4AbHphKGuq5tlFOrz8bn9HZMpd2zDb/
	RpCdaa46UosbNu6LEQCjn62wzlj+dSM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785029403;
	b=mMcdt7ZlLM6S1JGffc7SdrTGGEXNvt+IMyiN31YzVJj8earp/NKHMUo2PJB55L1qpuIZLu
	iQvP5v4ica/+JvpGI1T1Ad4AI5U2uN/XKfLtWgQ+x6/W7QBMXp/1UjKHuc8prhxvzBl+tP
	2RWOFPF430VIfZQ8Cttf3hgM2q/2x3o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="B/c/+WNY";
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8BC4341339;
	Sun, 26 Jul 2026 01:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B3B41F00A3D;
	Sun, 26 Jul 2026 01:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785029402;
	bh=9jhQTuuPD9KwcoX/z0WxrFRGD97WTuKY5ASJ3vGdEAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B/c/+WNYqFuq5bvjJiDUU4Quc1DnVZR4VWTfmaF2VYh+iwj3+SHvs6V3FzzIn9pOx
	 ZL4kZPsoiwy34n9G4rD4Luj9U28lBptb4feHZtkaLaliCIDwisAaaAw6iQQa+gW/wT
	 3w4/Tgv9gUuITSL9LSw4xGx/V8IALyw+zYoHBVtnE4NldU9UkokKt232OZiWjFBNkP
	 l/ZyEIrGXriUhJviR6u6WWYbjhrBD8gXVcTnWMNBi+k/LMtawyM6cW/U7sQ87n2N9r
	 bijwzqWyxeOgEmmcUePFVzL+703xQwK9zIo7oEIxPssrGjJaYFPe5r7L5mW1IZrTeQ
	 kgTXl+0172iXg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	linux-kernel@vger.kernel.org,
	lyugaofei@xiaomi.com,
	stevensd@chromium.org,
	Barry Song <baohua@kernel.org>
Subject: [RFC PATCH 3/4] mm: mglru: run aging when pages are severely imbalanced across gens
Date: Sun, 26 Jul 2026 09:29:45 +0800
Message-Id: <20260726012946.18684-4-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260726012946.18684-1-baohua@kernel.org>
References: <20260726012946.18684-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 312F140009
X-Stat-Signature: zzjn78t5zi8oihx331kecgfto8adqura
X-HE-Tag: 1785029403-147526
X-HE-Meta: U2FsdGVkX1+gZYXLYkpqUGf5QYdKRfVDfIP2fYUShG/ePyeCGMNeHy+C6NQWdCq3RdRGiw+rFPlaEG+UTaPNHE4BJleGqWlY/8WXOlyarUF0gmduc8ovWpFPK0P+8cGlj5nYVaKvp+5jTe8dtAloLiv3/XyUO5HeOD7tm6aLX2h2NEaZyHyOfb+D5inwQZUF81l9PHnEZAx3oTS0OPxS596IBKLXuccxdiWdLbN5jpNmjRtgJtma+JE5kmiRuPbCNJcDqm5yX99ovhVFdlo6X5wSQKfjMQWUU4hYj/AXnKOBZLMHqc8fCJzw4LrNcouLemlWAvz0azDLh9vTEMxoU1k/zvxhNF6GvwI23/NeOf6z78WC3h5kARDdSFpEUahdH10/TPArqc9EUZhjF7LrrykfhSRM3GpkiEvs/uxB7jliBy8oLtdA04AB9llHsFUnoyYvR4ff/7zkXqICbI1hy9vWhZbAAcgFwmEsG5yG6p7PolYcmWtSk8eh4HijA2+USMKDcjGSRAiL/Z1gSlMt2NnefymWH0wJWmRT7O3c6L2W8jArGBt5ZyOkg9U3pW3j7fDVj1zOKTDxWYW0F7V4b+0dmArOgC6IlQH/cuxcyivaitZMerJ+TjjdkBCnKIZbpYbKQoNVmJMsuSpz73dmnpcwuWOnqjutoUcUGX6GpoMk+W8GmI44t1f9sS6T3Jn2VDvUFa0RLBecAYb9po8RlC7aRoqAjYAQ3utM7U0Xu6ObNOdJW6T8BKmuanInJ6I6+Bp0AHkFxQu6QnEsvt24EazXXb98tGM1vgnsN6ozwZTGST1joRmcC76IgrJlACJIxndTQxNiRhrrPPWj8i1OEhYLmgwJbkqkWrJTf/2S95Dg6JHqX7/qsfC5JR3BykKNJTDg1ubiqiW9f5tvuMgOypJjBFCDkMvJgG0x2XRaRFpRKztZbQbzWx1nZPfovjOrDEzVhhejMxYX8eFZCgM
 V+SE6rYh
 YiQYPVJ9j+HligSFdH3byYdiLoCwLsaJxyjEYzI/16/1+Rd21O8YDkWpgRq2D++JL3Wy/NFD/FIII95DcFOxHQUNNOgYrBBHdINt406dXz9lCUHkkgTMKcV0cvF+fwNNfIhNJtnW62korX/lyS+Pwm6sTtOVwl9u5N+yk5XThUVyA8owOklud4JYGLSCTK0X1fbltetdsF7MBIQCtbdQeymzVvNEa053NGPxmk09rInz+BY2jENQ/+qLxLfSX1BdcCj0Y
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

But with a stricter condition: the youngest gen must have at
least four times as many folios as the oldest. This helps keep
folios of the preferred type distributed across the reclaimable
gens.

Signed-off-by: lyugaofei <lyugaofei@xiaomi.com>
Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 4f3a375de86e..9aac4febc206 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4963,9 +4963,37 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	return scanned;
 }
 
+static bool lru_gen_imbalanced(struct lruvec *lruvec, int type,
+		unsigned long max_seq, unsigned long min_seq,
+		int swappiness)
+{
+	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	unsigned long young = 0, old = 0, seq;
+
+	if (swappiness == MIN_SWAPPINESS || swappiness > MAX_SWAPPINESS)
+		return false;
+
+	for (seq = min_seq; seq <= max_seq; seq++) {
+		int gen = lru_gen_from_seq(seq);
+		unsigned long size = 0;
+		int zone;
+
+		gen = lru_gen_from_seq(seq);
+		for (zone = 0; zone < MAX_NR_ZONES; zone++)
+			size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+
+		if (seq + MIN_NR_GENS > max_seq)
+			young += size;
+		else
+			old += size;
+	}
+	return young > old * 4;
+}
+
 static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 			     struct scan_control *sc, int swappiness)
 {
+	int type = get_type_to_scan(lruvec, swappiness);
 	DEFINE_MIN_SEQ(lruvec);
 
 	/* have to run aging, since eviction is not possible anymore */
@@ -4977,7 +5005,11 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 		return false;
 
 	/* better to run aging even though eviction is still possible */
-	return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq;
+	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq)
+		return true;
+
+	/* Run aging if the preferred type is severely imbalanced across gens */
+	return lru_gen_imbalanced(lruvec, type, max_seq, min_seq[type], swappiness);
 }
 
 static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
-- 
2.39.3 (Apple Git-146)


