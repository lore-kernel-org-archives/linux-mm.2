Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1A11C55171
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 08:39:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7EB96B00C7; Fri, 31 Jul 2026 04:39:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B08576B00C8; Fri, 31 Jul 2026 04:39:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A9206B00C9; Fri, 31 Jul 2026 04:39:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C3566B00C7
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 04:39:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0B8B4160348
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 08:39:23 +0000 (UTC)
X-FDA: 85048422606.09.0F4EE8B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5B5D5C0002
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 08:39:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BqpESvbN;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785487161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ihmxc/uju4l+NYhonEwKFariUb9t7YQeSVnFbp6tBNE=;
	b=XftRJh61nmI5Tc/HGe4W1TO7f1CYLvMCCuZCz2xw4Z0hw1/DA87HV4yb50K+uG1pAVB/eI
	9dGWhp2bttmVRsv75nTxSpA8G6cHfBpLqpjfz3bKKqKKsHzcpyn5ZCsNITQRqMOmhZRyO0
	RuoL1iHz8SaVGTGdKoHu3Ey4bG7i6Lw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785487161;
	b=Y+AZ67KYBKTOaWmGkkbsSwDAXVRDEFYV/uVwwkhKZtPan8BUcrGoKypgDzqMoo6kLe345Q
	x0vT+VKMfDaNMCRXDg3E2/mOdARfzEMy7i8p13YGj5dLbdnfc9m+oqNr3H3bLAOZTKM46o
	or2hhPvj8B+TKCdq8DOs6yEm9YC9H8E=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BqpESvbN;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 90F0943CED;
	Fri, 31 Jul 2026 08:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D4F1F00A3D;
	Fri, 31 Jul 2026 08:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785487160;
	bh=ihmxc/uju4l+NYhonEwKFariUb9t7YQeSVnFbp6tBNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BqpESvbNDFygmGxUmbtGwn2yI5In9LieGYe0mz4gyWc2pGlqVEWaKwrz5Gs1RxeHM
	 t31hQRkpRcT+6o28KD7Mdoy4X+yKaRjtBY5HgINATIjTQ43ZfmTShoXd7cQzvyunOj
	 u0DxEQX04D0c1Vhfqdhx/MFqPDWSuqvjHrSn+udwR68kPtHDXlFXZ9ieTMy26marnc
	 HlySCWb7HtS3B9LPqpE2+3MyFwZV8ljPVo/e3Jz9DVhf0ELc7VFdVj89OsgVhS24Cl
	 YyQEUWylSNGKWnPD5/an3hDnqTzRXmRmV+tnriR4ObTxIZ2X/2tq+yweasg8BajPn/
	 XeDbpfhkNDcdQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	weixugc@google.com,
	yuanchu@google.com,
	chenridong@xiaomi.com,
	zhangbo56@xiaomi.com,
	wangzicheng@honor.com,
	lianux.mm@gmail.com,
	Barry Song <baohua@kernel.org>
Subject: [RFC PATCH v3 5/6] mm: mglru: run aging when pages are severely imbalanced across gens
Date: Fri, 31 Jul 2026 16:38:42 +0800
Message-Id: <20260731083843.37811-6-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260731083843.37811-1-baohua@kernel.org>
References: <20260731083843.37811-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5B5D5C0002
X-Stat-Signature: i1hzs7w14gf7utzhtrsxw31fqwqk5m1u
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785487161-248914
X-HE-Meta: U2FsdGVkX19eRX3YnuyL3pkbAv20PJsq4KuuZUVxBibovjpsfL/8RArm0Do6rZ0Tylpdfi4huHJaLRXdac4SXhs8qVZdvbmHRBSEBjCEHaZPOGRvnnhNKuI6TB1jKA8mFX473xFvYHhaNZViY/058G9YCXCFjHVSUTrQ43HCQJQnsOjaEVZTgjpmY8BwQdpTUVDQjHxHkHQGQcjqMSkRvx+Ql0FhU15TAmIfOsHt2lujAE8BHq8RnlvRHaMOO3V7L7ZZ8n16vOkQ7S3Eoyiv8w7YZg3elwWpNYMrK+ynH/y1IInyKamyz8dNdlepHkbHKcLlG4mrwOkNXE/70YWocIbbkJ/AG15ztRKtlWUQee0C+C8izttnBoEApDM65i9Tad5MryZFxV3S4mrINDQZQ7mEFe8HddTbbCAVZycgygd74AO/InYQ/vGgqZr6+9Tr1++2zG7TKA+CD1ajYaSg1ldFZ1cLTb9f/UecFZbgK7+xCIkaBdFnkjTlVDEPGx9e3IB7FHFNHxjQmKak3FqgiuWPC+H4CuHi/lFbO/EhEgBlSSdiZnX4wAIEoYKfVG+dtvfP1cz/+6bQQV8HIFMMfZk3q6ZovZny1iKTDneuia9+mD4+GyA74xbgyAgCuZe0KxBS352zajgd2ic+GEzet+QkcCBQSiXMRqn92kgP2/7L89CzQpDTYhSJWAvh2VpdoR3J9UwzotvxUw8gHbpy4cJ+QxB353zg2JB8OQ5BDaP+f/6ZxXhjL8Lqi3ets9LuPavmAHT+mr/0Uv98G4UTp7Smt1raimrsjeIxCKRxErZc1wVONmDs1L+RdsX6GsByckJjVMkA2fi0qLMcCIJfH2DbXiXKRoNEh00wrwy/vmudPE42so+nnrDfwzm92UuE12h4R4FPb41035jpQzsFpuLR3Xo3IGxqqDjYUOtPViRgOSxS9Ks/qHpauiWIucUXb0z6jX40FAk9n+VL3L4
 FJjv2Yf2
 QhUxJroLd6bO1+D3FyB86PtVEqJKN3knsLq9hM5xucr5ECG//94ROTn4DNMCjf/gmZAmxpLwgY3X0UjLnlt4aieBAMTnAoACyx9L/bpK0OGJiW/yl+FpRjCZBPB96mIfH7gcYwINWHUOUztDSgPc3X2ruqprP6jkhyuIE6I9v+vJXLTwgfc3jQ/ZE36yfvclIrvD5cuKh0ulnpzrGt9s3uwKO58VYVqs1D4/U7db1w1Lp36Glf/zzghGO2zUbaUT05hdkkVo5jTHxLdIxcVfjuEyDHlGQ+uSxX1V6zAL2mqQW9Qz6D3YLDM0mFdUSnsfcr2OGmh/rTriox8s=
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
contain at least old_ratio times as many folios as the older
generations. The old_ratio is derived from the lruvec size, so
larger lruvecs use a higher old_ratio. This allows aging to
keep folios of the preferred type distributed across the
reclaimable generations.

Also, imbalanced aging is only applied to non-balanced swappiness
values (for example, < 60 or > 140). For balanced swappiness values
near the middle, the swappiness bias is less of a concern, while the
slightly increased aging overhead might be unacceptable.

Signed-off-by: lyugaofei <lyugaofei@xiaomi.com>
Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 59 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 58 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2e7fef6975b6..98fd2fac90ac 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4973,9 +4973,62 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	return scanned;
 }
 
+static inline bool swappiness_is_balanced(int swappiness)
+{
+	int range = MAX_SWAPPINESS - MIN_SWAPPINESS;
+	int middle = MIN_SWAPPINESS + range / 2;
+
+	return swappiness >= middle - range / 5 &&
+	       swappiness <= middle + range / 5;
+}
+
+static bool lru_gen_imbalanced(struct lruvec *lruvec, int type,
+		unsigned long max_seq, unsigned long min_seq,
+		struct scan_control *sc, int swappiness)
+{
+	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	unsigned long young = 0, old = 0, seq;
+	unsigned long old_ratio, gb;
+
+	/* Skip swappiness bias for single-type reclaim or balanced swappiness */
+	if (is_single_type_reclaim(swappiness) || swappiness_is_balanced(swappiness))
+		return false;
+
+	/* More than two generations remain to reclaim */
+	if (min_seq + MIN_NR_GENS < max_seq)
+		return false;
+
+	/*
+	 * Run aging if the only remaining reclaimable generation
+	 * has few folios.
+	 */
+	for (seq = min_seq; seq <= max_seq; seq++) {
+		int gen = lru_gen_from_seq(seq);
+		unsigned long size = 0;
+		int zone;
+
+		for (zone = 0; zone < MAX_NR_ZONES; zone++)
+			size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+
+		if (seq + MIN_NR_GENS > max_seq)
+			young += size;
+		else
+			old += size;
+	}
+	/*
+	 * Copied from inactive_is_low(), but uses a higher old_ratio to
+	 * make aging less aggressive.
+	 */
+	gb = (young + old) >> (30 - PAGE_SHIFT);
+	old_ratio = gb ? int_sqrt(10 * gb) : 1;
+	old_ratio *= MAX_NR_GENS;
+	return young > old * old_ratio;
+}
+
 static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 			     struct scan_control *sc, int swappiness)
 {
+	int type = get_type_to_scan(lruvec, swappiness);
 	DEFINE_MIN_SEQ(lruvec);
 
 	/* have to run aging, since eviction is not possible anymore */
@@ -4987,7 +5040,11 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 		return false;
 
 	/* better to run aging even though eviction is still possible */
-	return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq;
+	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq)
+		return true;
+
+	/* Run aging if the preferred type is severely imbalanced across gens */
+	return lru_gen_imbalanced(lruvec, type, max_seq, min_seq[type], sc, swappiness);
 }
 
 static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
-- 
2.34.1


