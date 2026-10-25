Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 258FC606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 01:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=GbaX+Xlv
Received: by kanga.kvack.org (Postfix)
	id CF2FB6B05B0; Sat, 24 Oct 2026 21:31:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7CAA6B05B1; Sat, 24 Oct 2026 21:31:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1EC86B05B2; Sat, 24 Oct 2026 21:31:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 786D86B05B0
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 21:31:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D2E651205AF
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 01:31:17 +0000 (UTC)
X-FDA: 85359420594.15.F905399
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf20.hostedemail.com (Postfix) with ESMTP id 08A9D1C0009
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 01:31:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GbaX+Xlv;
	spf=pass (imf20.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792891876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NjK0kx7CGIZMdCtURm6ydpz5eb+27HR4F80VrSkDz3k=;
	b=GhNuBj3hFVZukJC/sbedFw5jh0kTUA93dEgwQF/WDLjL69w9JQ6GbQvvhDjxz2+YNmVAyH
	XEZi7xr6jzbLtjZATsr8jenVrSQkJKsjd8Y9CBi4Z+/RxUUFhhb903W+4jsYHPSX3FGT/m
	kCms4P1BB/Td2eseKCO+2nOEOh6vgp4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792891876;
	b=gkf+1Z+ulJPMfpGDreL0gL2f6sECXiSDzi0fD5IbPpYhOKTcaKsPme/IzgfMfETOTFuCCc
	cfeIFqiUMm8TC8feW5xd7kJpWf3MrcytRDcbkRlOAphn1Ri2847v6kwE6ZTO+6kcm3VnoR
	aags1nEU2Szv8VLS20C2b3MsKcDWhOU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GbaX+Xlv;
	spf=pass (imf20.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2e99b1e5b4cso10509985ad.0
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 18:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792891875; x=1793496675; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NjK0kx7CGIZMdCtURm6ydpz5eb+27HR4F80VrSkDz3k=;
        b=GbaX+XlvkXy5sw5mXzGBFiVo/usSa/tSgqqEBm+xT0JO9ha4dmURtY7IhdaThoqERv
         gqDSehbv9LzURKtWEcqH0/0cJKcN79H37A9wbhY+8EABuUL4XAGr17+7Rg4jVbnEKvKv
         tAcPLDMIRs643wQAGTrUcrk8wRBlllNSXtWqbn/DkAI4UMSu392BpeWZx2ao/v9QRzsY
         byrBn4dMe+Sck3Lfj122EgHO3SshqW2Bj8NPWjZJasz5LrTzoNGA330ll65DYZexfun8
         CKtLNilJ47EwJ8R65UZw00S00ihn+dUgvGK8dSqyDFsty/MorAjKsoP40fcd0IM8FJMK
         /ccQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792891875; x=1793496675;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NjK0kx7CGIZMdCtURm6ydpz5eb+27HR4F80VrSkDz3k=;
        b=IqxtVuMzmSSueaMWDLZtPvKw1dgRuctd1KFalMDez/IKZMSnfaWNOn9ZkDD5Su/W9r
         wpPgH9H/DqjWQhDBBlzPtbZrM9uTwwca0shrVXbYtPbCQeNty73YCxc/aMVvBb2a4C9p
         BGbMHwf9DMSX7iaXcvptkcJa9GI8Fyuf29S+NstS2PMZm+T3GI+n12p42WW9VahoCQbx
         3ebm4KNW3qmDSKXEKUxTZz6INQLIkpZugGd0oEwNugUR2GI5TR3aUTfoDtfRh2Ombwpp
         KQ+beVl7gdy28/IZlZDYMyLZsb8EVZ0xJtJFlokynUCEIalkvRefAg1a6gh5guAjPDiQ
         HTMw==
X-Forwarded-Encrypted: i=1; AKwUvBzpRFTArc4eix+r1TVzPpvMrZmuvqodlJ5JkL506JNtwvNQwy1H1K2NXBHgij2o2q3IXQki7VAhcg==@kvack.org
X-Gm-Message-State: AFq9FYLVi/jfOLZsgu1U8tFAR0PZ3plJGQGOTTQZd1xeu4UcX8EUZtYO
	L6pG4w3hKwUXp+5z2SN2A0EEXp9zjrjmyaFvE1tEmV0zuJ0SXse9rtXJ
X-Gm-Gg: AYBFou1m7UP5p35eaSkYI+H5DQ1LOnSGpmN4jB5y5IZGhLGnNHzFhKDjoj/y9bl0/57
	coRVitsLm3zZmZBH+uOdx2MWPsR3hfk1/j7qyOrNMkkYGn3XYIliLma7MoSiRDD1+8D39mFKwiT
	LGqk9x5DWowGWlxvbbhS6ADfWlhJJJ+7y7onxqWtGqfVwFCfIaWXvrohpdgHAFq7dMEmVnVriEP
	Jsf3/MdBTdq50+39aHKI8vJ59lscb0w1Ay+rZAr+qv5TIRhMlkm4+MwFXNyds5f7LV3Iv9rz68d
	I7aKzb9dJSi/atDvLb77W+wTUXx0QbHuRpYkRVxlKF2g/OZOtzx2PxWO6+uQZGydkE/DbK63f0X
	GlGR+K9lUca7KYECz+Cz9TBeuJfYmQvM+KRGSnEBrdv/ZnH0+rGYc+/n0UoltlwLPomLrlilxcK
	PwQ/uHyaowqJ51sQAIlVkhs8k+W2Mg5VBlxmBh2ab5mbJ5lQalFHhTXltw9Db1uFoupoeLrdGJo
	38QV8x/YB77czrbwcgQBXqLjsp5YGhoBI0r2upX0BM2+fmGpNl8qEOvwC+6o7gupW1PqUe3SjM=
X-Received: by 2002:a17:903:15c7:b0:2e6:2868:e576 with SMTP id d9443c01a7336-2ea9c87defamr24585005ad.31.1792891874848;
        Sat, 24 Oct 2026 18:31:14 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea9b1a1c00sm7197805ad.45.2026.10.24.18.31.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 18:31:14 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: sashiko-bot@kernel.org
Cc: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	david@kernel.org,
	hannes@cmpxchg.org,
	hui.zhu@linux.dev,
	kasong@tencent.com,
	kunwu.chan@gmail.com,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-mm@kvack.org,
	liuxiang.277@bytedance.com,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	ridong.chen@linux.dev,
	rppt@kernel.org,
	ryncsn@gmail.com,
	sashiko-reviews@lists.linux.dev,
	shakeel.butt@linux.dev,
	surenb@google.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	zhuhui@kylinos.cn
Subject: Re: [RFC PATCH v5 14/14] mm/mglru: Avoid scan anon while swapcache is low for GFP_NOIO allocation
Date: Sun, 25 Oct 2026 09:31:03 +0800
Message-Id: <20261025013103.2742885-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <sashiko-outbox-183280@kernel.org>
References: <sashiko-outbox-183280@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 08A9D1C0009
X-Stat-Signature: cyoaxcyze7p8q5bo3dpex5sm1q14yh8w
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792891875-116232
X-HE-Meta: U2FsdGVkX18zyBJ8Oh8sHIVaLl92So+K8Yt7fUVUF8gObpCjmpWOxjM6acxy68czZ1e8fhQBqEomGlIyR07uoecoFiy5sdMtsK9Glr7ThjiDRtd7RjSFKIy+8joAW1otPWaPyOFQq4xh3fuioYmkh0d9txjNRTGjkSwfcOgLL9PVlrRQ23q5VAmOzBwRU1SMrIFhU1WmnwpeLt8L58Sxeg5PbYaGiy8bgDNzxYMwt85aZdjkwCBPO3iWAQ/A+BQYF7Y1UMIXA3dRKjEBtAneWdfGLfFahj6fgCMXDDryYNRJQXV88NA4BUue05mhDuPAtUFIGRpJL/9yjWxQ8Y/ANzvMk/CiSV6TOu7mrdAXnC898lPFQ6yJtr9fXPvaWmoyw6PS21BzdIidpNpIemzfJDxuf+VYLPMwfvfTOUpuFhQh5/atreMYWmcqLv6I0O/e7TIwi18q1Y16dExHxFaoHtrusopJn2FIWHN6vPGce02CHJKep9ZEGJ8uP6aGXDrcftWeHDCRqAYza/LXOYuK4SnLRtrGTcUEAiuQnld+RaFIZcmHSoIiKTJCNE0fFE7ceVra7701PcHizP3Jz/d/GgPEMzptWfObuA0+cUNfla1z7EyygZdvmQSWsEScRLjYHikW8SUQwd86yZduGI9gCB7gMUBZMi/ZiAYyFgobHGMou5ngKWZwqDVUI9G5YJXY9fEKnA8wFAdpom9GqB6NUWI3o81+WWs8BqoFDl954GFRP0b+UlJ716dh1XX4s0eGs+bypamBzKjfZmwPPubGOg7bmLXO59zzT7P/iyp6D29bXBoiwFK5ohffJts0WPMzRoklLugc7lsS2l4i1rk3Mu43Z9lVMpprzgen+PkApJHW/oTjxK1Ol5//Vi0NxA5tcmXS2ldp3bsautVMecB786vw03Fn0xaI9+K3z2am1cX7qzd7fvrxarohP47iKxbzPChWrgTZ11F8ucCciQH
 zxqlt3NX
 5CSZfRdqRxh1tOmH/fXF8fLRG8rFNKvFyQIZ0Yoc6PET6JJDuTWA/BuhuhrpeIDqni4x7BjSDW22k0kWBa6KmyYKpaR3i2UxG5mcRm4RIgcMAQ27nKBb51ZnldL7zxg60iQmB9gdx5l/jubHVUeoK7LobI7qIaqQjHkTGf8j94awvOAAn43YTlbJfLL77fhzAfoWHJqKf/+4Uz4iA3X34aB1EU0xG9/iFvetDeCfSnpJvEzyBNB4FV12MSjyhsdTIqc1dbL0fc/hlbTL0KDECKJjcxY2Di9ZJ+bUSSK+QIX8diobyJ5tSWeJ9NE5VAIqfAA4bJ7FcY4DNzDzjZ5TfwtAF/8yVcQqOf3VtLU1X+YbprdiCiaJ8wyp2mqAjlQjRJqNhxnwzjpY8qrgDPuSRgupCNnUpyiS9frn3MahpAyAonpH4EYHV6akW4RcTcuQBeFBEoZpdUAvstL3wHMkbiTlNeHgbhPhvBqwmo99tNkc1ebpqk6yxsrY81A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

I have checked the two sub-issues separately. Both issues are valid and
the root cause is the same: patch 14 skips anon scanning but leaves
swappiness non-zero, so every path that still treats anon as evictable
(scan budget, aging, lruvec_is_sizable()) misbehaves.

> [High] unclamped scan budget on early return in lru_gen_balance_scan()

Confirmed. With 1 <= swappiness <= MAX_SWAPPINESS and if one of the type's 
nr is 0, the early return left the other type at its full unscaled evictable
size, bypassing priority scaling, memory.low protection and nr_to_reclaim.
Note this is not specific for GFP_NOIO, an lruvec that naturally has only
one type has the same problem.

> [Medium] inconsistent swappiness state when anon reclaim is skipped
> Would checking can_reclaim_anon_pages() in get_swappiness() ... avoid both?

Confirmed for both sub-issues, stalled aging via evictable_min_seq(), and
lruvec_is_sizable() counting unreclaimable anon.

Rather than forcing swappiness to 0 in get_swappiness() (which, as Barry
noted in [1], wrongly allows anon cold/hot inversion for the temporary
GFP_NOIO case), I keep swappiness not changed and fix the evictable view at
its source, lruvec_evictable_size():

1. It now filters out anon here when it cannot be reclaimed (e.g. GFP_NOIO
   with low swapcache), so nr[LRU_GEN_ANON] is 0 for all consumers. This
   drops the per-caller zeroing and lets lruvec_is_sizable() ignore
   unreclaimable anon.

2. lru_gen_balance_scan() clamps the remaining type to total_scan before
   the single-type early return.

3. should_run_aging() forces aging when file gens run low and anon is
   unreclaimable, so a stalled min_seq[LRU_GEN_ANON] no longer blocks aging.

Proposed fix on top of patch 14:

[1] https://lore.kernel.org/lkml/20261022102726.56682-1-baohua@kernel.org/

---
 mm/vmscan.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index d72a5aef3a0f..32bd9c0fef5d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4350,12 +4350,14 @@ static inline unsigned long lruvec_gen_size(struct lru_gen_folio *lrugen,
 	return size;
 }

-static void lruvec_evictable_size(struct lruvec *lruvec, int swappiness,
-				  unsigned long nr[])
+static void lruvec_evictable_size(struct lruvec *lruvec, struct scan_control *sc,
+				  int swappiness, unsigned long nr[])
 {
 	int type;
 	unsigned long seq;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+	int nid = lruvec_pgdat(lruvec)->node_id;
 	DEFINE_MAX_SEQ(lruvec);
 	DEFINE_MIN_SEQ(lruvec);

@@ -4363,6 +4365,8 @@ static void lruvec_evictable_size(struct lruvec *lruvec, int swappiness,
 	nr[LRU_GEN_FILE] = 0;

 	for_each_evictable_type(type, swappiness) {
+		if (type == LRU_GEN_ANON && !can_reclaim_anon_pages(memcg, nid, sc))
+			continue;
 		for (seq = min_seq[type]; seq <= max_seq; seq++)
 			nr[type] += lruvec_gen_size(lrugen, type, seq);
 	}
@@ -4374,7 +4378,7 @@ static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
 	int swappiness = get_swappiness(lruvec, sc);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);

-	lruvec_evictable_size(lruvec, swappiness, sizes);
+	lruvec_evictable_size(lruvec, sc, swappiness, sizes);
 	total = sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];

 	/* whether the size is big enough to be helpful */
@@ -5058,18 +5062,17 @@ static void lru_gen_balance_scan(struct lruvec *lruvec, struct scan_control *sc,
 	u64 anon_weight, file_weight;
 	int size_bias;

-	if (swappiness <= MIN_SWAPPINESS) {
+	if (swappiness <= MIN_SWAPPINESS)
 		nr[LRU_GEN_ANON] = 0;
-		nr[LRU_GEN_FILE] = min_t(u64, total_scan, nr[LRU_GEN_FILE]);
-	}

-	if (swappiness == SWAPPINESS_ANON_ONLY) {
+	if (swappiness == SWAPPINESS_ANON_ONLY)
 		nr[LRU_GEN_FILE] = 0;
-		nr[LRU_GEN_ANON] = min_t(u64, total_scan, nr[LRU_GEN_ANON]);
-	}

-	if (!nr[LRU_GEN_ANON] || !nr[LRU_GEN_FILE])
+	if (!nr[LRU_GEN_ANON] || !nr[LRU_GEN_FILE]) {
+		nr[LRU_GEN_ANON] = min_t(u64, total_scan, nr[LRU_GEN_ANON]);
+		nr[LRU_GEN_FILE] = min_t(u64, total_scan, nr[LRU_GEN_FILE]);
 		return;
+	}

 	for (int type = LRU_GEN_ANON; type <= LRU_GEN_FILE; type++) {
 		int hist = lru_hist_from_seq(READ_ONCE(lrugen->min_seq[type]));
@@ -5271,12 +5274,19 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 			     struct scan_control *sc, int swappiness,
 			     bool do_balance)
 {
+	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	DEFINE_MIN_SEQ(lruvec);

 	/* have to run aging, since eviction is not possible anymore */
 	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
 		return true;

+	/* run aging when GFP_NOIO limits anon reclaim with few swapcache folios */
+	if (swappiness && min_seq[LRU_GEN_FILE] + MIN_NR_GENS > max_seq &&
+	    reclaimable_anon_is_low(memcg, pgdat->node_id, sc))
+		return true;
+
 	/* try to avoid aging, do gentle reclaim at the default priority */
 	if (sc->priority == DEF_PRIORITY)
 		return false;
@@ -5295,9 +5305,7 @@ static void lru_gen_prepare_scan(struct lruvec *lruvec, struct scan_control *sc,
 {
 	unsigned long total;

-	lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
-	if (!can_reclaim_anon_pages(memcg, lruvec_pgdat(lruvec)->node_id, sc))
-		nr_to_scan[LRU_GEN_ANON] = 0;
+	lruvec_evictable_size(lruvec, sc, swappiness, nr_to_scan);
 	total = nr_to_scan[LRU_GEN_ANON] + nr_to_scan[LRU_GEN_FILE];

 	/* Just scrape all pages calculated above if this memcg was deleted */
@@ -6050,7 +6058,7 @@ static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_co
 		if (sc->nr_reclaimed >= nr_to_reclaim)
 			return 0;

-		lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
+		lruvec_evictable_size(lruvec, sc, swappiness, nr_to_scan);
 		lru_gen_balance_scan(lruvec, sc, swappiness,
 				     nr_to_reclaim - sc->nr_reclaimed, nr_to_scan);

--
2.34.1

