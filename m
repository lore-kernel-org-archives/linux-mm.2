Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32A39606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=VUqjK0M6
Received: by kanga.kvack.org (Postfix)
	id 12E276B072E; Tue, 27 Oct 2026 09:59:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08F8B6B0739; Tue, 27 Oct 2026 09:59:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E72676B073A; Tue, 27 Oct 2026 09:59:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7FCB36B072E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:59:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E44BEA8777
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:59:45 +0000 (UTC)
X-FDA: 85368564330.03.D8F786A
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0FFCF10000D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:59:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VUqjK0M6;
	spf=pass (imf05.hostedemail.com: domain of charsyam@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=charsyam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793109584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+PFYfGoi9f2AhMkO9c1ssgX+qWfwUcRN+0tOm5gagYw=;
	b=nbT9OKqVuHkOunpo2Gd+0ha7WrtI0+tzRrlLvGgbtFDNUzSRaqpGIuHAxQH1Ei4YE/QkeS
	VKuErZRbxYJ074ZRNgsmD4URDKMhCJpMB1m1Wv3CayE34mO6882vXEQ5p+IjZ2ms5z3CEl
	b5BHHYtIVpBm42grDmubYU3CjvG0tDg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793109584;
	b=k5ddOv16Cj2RuumC3MPZPWNxs40Csv7jqjXFn1Bq6kNhAxbbwA758pwjs7GuK4CnDe8orU
	pKhIiVRia29taPMJEKRYivPcrFuA+VyhLWCPGUJPSQBIKvlE3K7wr7H5hb1otx6qidqibf
	SGKHIV7L/BZettmZOw0j1eSd3spWU0I=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VUqjK0M6;
	spf=pass (imf05.hostedemail.com: domain of charsyam@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=charsyam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cdac52511b3so120455a12.2
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793109583; x=1793714383; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+PFYfGoi9f2AhMkO9c1ssgX+qWfwUcRN+0tOm5gagYw=;
        b=VUqjK0M6VnXFki4cLuUcYR4FE8KFVxBSSXAsnq8LVoHtsUBQ1rNqv+k1JKbSb7Uh5g
         +ZKpzSJ6Fvgdn9LGS9FEKYb0WGQVe3n92zvonwMreCygv1RmCuJqK6EAdo9osuvfmfvz
         bMHQGF0VrHz06O2VJillb/znS+oWw+3OvXyqmWUCpEBHfl/KtfV88wdzz9GDHm0Cezov
         I9gu3ExFHGrbKD7w0oKPyyavutAcwvgamz/dr/av59YqRvcaVDr2CyOx9k1hMwGbzKU4
         I0dRE3IQ/hBxEjTZJRLxGtbBn4Ugym2z7vD2Ncys+pkOLyKAQl2sadF5lEIIrIPrCQ9n
         z5JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793109583; x=1793714383;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+PFYfGoi9f2AhMkO9c1ssgX+qWfwUcRN+0tOm5gagYw=;
        b=Biwa9qX+D8ilwV+jdHZH1kk7FdrpWWgo+A6YseMWNHwy8f/0rAhJ3BHkmku8lYXkDx
         Y0MMQ9zW1GvIxgESRkkD9obVgRFqSVuKMgb4/DOiZmWwGsHVr9s18q5ZiAtD8q9lAfIo
         sJYyQqNb5Oq1NkEe3gmbgsXjnEJz1HY0x9zIIos+NOm7DgD3Et3eAnABbgm8X9+Ep2wA
         wEa8Jaw4KS4Xw5yJ7gvwH26oUr+gfTfBiInAOWLErcIc3QZtK1WvoUpSJxe5qqH3OcWz
         LPT5I4aDL3uX6FfukGb9HumcFGlQLOMqZu3tBG/6bdyE9b3AYqMzyFWGDP6Rbkm8cixi
         Vi4Q==
X-Forwarded-Encrypted: i=1; AKwUvBxdX+dJ6CtPw8sAosCviXXJdY+qCqk9jy/MyfNyrmYTHgglqEHe3maO9/RR2a0n3E9H6Ve6dsQ64Q==@kvack.org
X-Gm-Message-State: AFq9FYJaHQ6x6oiat/7whMd36/V4fuGeTaCzCJW+D6ZWF+VUtGc4U+uF
	+q9VfUaZPAdXtqmLFEU37UD2IwRANX+nYAabqO4waOQ8qM6M/eE0rDiP
X-Gm-Gg: AYBFou33z9fAvCc+NZCXVVJbncoXg0+o0C6jadNwdd7Qc3UggIUEFdFkehkhHsBtqJB
	SZ/jRdDhm7E9ozAkY2vdzPcQlVECda3MpVwgfQc8HGSHfssPoPleQzpGcZaSmHk/iMZ82PTGfrL
	ASJz5vnZjpbb9ENy6rBMiXf0prwnbVOc8SYqGNnIKyJRN7+NMneKZsvWi2v6z5phaN+MRP6BGv6
	WulIY1TXniX2xZdGvKlu4olBGzb7C3+FpjLNI0Pk6Uk97PNucDgzngq0j/2MwHSgm1UvVrJcXKn
	jnmg8cvhLf3TuG81Af/NXs3o5LKGGIvsm9LuPUVtei2+bCbH9l2O8zYGhoffvQe8jQY1MQk4MZu
	Pz36czTsFIwzAZ40ccKE7lp7hj31BUbVBrcWgP0lIAUYbvrGXFjPxIlajCmcAE7nGs4XYT6PoR6
	dji2XNdtb1yq+qgxUq1OM9TRDigq6lyENDrnMIM5jwKz8YjpSyC7aRuGm5VlbhIaNKK+i5UrO+W
	+3QqFJBqUYGQT4ursCnbQcjeoddFJAYk4pFSz1CRTBUKMn92dJiFdreUuGAyG0SXO7Q+Q==
X-Received: by 2002:a17:90b:58cd:b0:3ac:9c37:9422 with SMTP id 98e67ed59e1d1-3adea2003c9mr13980641a91.2.1793109582809;
        Tue, 27 Oct 2026 06:59:42 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae404432a5sm4243466a91.9.2026.10.27.06.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 06:59:42 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Asier Gutierrez <gutierrez.asier@huawei-partners.com>,
	DaeMyung Kang <charsyam@gmail.com>
Subject: [RFC PATCH 3/3] mm/damon/core: avoid overflows in quota goal metrics and scores
Date: Tue, 27 Oct 2026 22:59:32 +0900
Message-ID: <20261027135932.2301646-4-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261027135932.2301646-1-charsyam@gmail.com>
References: <20261027135932.2301646-1-charsyam@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0FFCF10000D
X-Stat-Signature: jojitx1n3n37dw6zucda7geynt9doysm
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793109583-113896
X-HE-Meta: U2FsdGVkX18HnIvMnje8JkpqS86wJaJxHH+UOBj4jlq7qLbJobyVpZlLNaRbBJ3xPUUXK5Chb8e33wfxPlYVM2M94MkSuG9yiZzIfOh8gYAIEWe01PqXKRCE6hNc9yYtqvVm6JD+E+Bq6wGObunSYDm5lDsNB4oHRzEMtj/0noqrEvwarD2QTuMHlwEkdF/c9dH3KxwIVe9cuciQhWU6qYlWNrv8vq+RD1VHH1CHvV5usKCKT7IAqyrJztD9lHuvmq4Z35QNdw7EVIu4SfDEBEEVxGvSFB/NXxHDlKNl3eiltgKbIpYya2PuO3umAZzNArjFIsPrlcUVfI1JSqr703LZXcdTpgjsnte9dbHqTvdQLA9SZZoDch3I0T05wx2s0yuTh4NoFGDPZsxcQCw7RtqewrY2frmCZRW9M2zGz4mN1jMk+CeKXjkXnGUlGnuoTBhoYKFcQhZyhwcbZDNcT6rAsZtos60Hxgu7zyWhmtg1W2DkOFe1NP69d3IWGAdHkRPUYtUk/edwscDBH/Jdce3zkJ4omIEboQw7LloUUWB3ecyp8dlsjt3WFPyqYsHwhdHLABPAVikq2hjGNY0b1BmXm5ZEJnLBZX1wFTHMPWP6L5lz+6lSSs14GAZIe4uhaUdfoNN0oAFeNZYRRFDlOiyWH3/9j+CTO4auEWlOKtY0yHw1NmBH1e2rCbVw8JSrzecsBBjqlPWZqdUCKJAI17/2UqK0/9OxoIcSMY6tFWTe2FPAXFuCM39H3vvoxTTEpJ3ZIxeLRWIuieNDqQwBj0GCDGKK1KcDBoiz5lxGWhUFj8roJGE0cxMJ+3iY2pbdVHpSN2FQG1bVZmmOijhLrRR8qZFd5qVLIh8sjwCjjjgfvDwsBR31y2PqzGwWo3lASur4EtGbpJsuOlfmi9sa56sBzdRISbW/1gXo0dYh0IB8PW5o9ivmGRplNZBiAa8Phzem8NMZfhZmn1Ttjst
 Xlwss2/W
 UQ/te4B/l0TcmrAUCSJ4/nLpEL6qaTBZikqGiIFXQ0Pk+39Td14Mgo7jUjEcNt2II1bhMC2ioqtxag4/oHEBmHMPWNSNEvRor5CtHJqaOMAOqFSlAWZdBWQfkNrMQgvOv3CPzX6Swk8znW6eyGC0wBjaKlUYQPN2Mu0F3B5FKtGfh1ymzo8/DgQ7ByOejGkcIP3tTBnSUBhWdfn5dyJWFGnQMFvygsRICV/PlcZDwtU2VUsuoi0/FJSDPY6MhOcdQHRD/LFFc2wBbLu94W14unPw0n4ohGmg1t0R4y60HrUqeVtL1fremFmIBQZXIkdHMGmHV8tzXq+ltxCyx02yweuvBn+GS39bGB3H9p7yPK/M1fi1CK/FzLz+dYdYzd2ZtMQHwHM0Pir19f6TpgZC5LhnXr+ziRQos7BZneUHmmxJlDPQZjna8xo8h3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The node memory, node memcg memory, LRU [in]active memory, and hugepage
memory quota goal metrics, as well as damos_quota_score(), use
mult_frac() to scale a value by 10000.  mult_frac() multiplies the
remainder by 10000 in unsigned long, which overflows on 32-bit kernels
even when the result fits:

- For the page based metrics, this happens once the numerator exceeds
  about 429,496 pages, or 1.6 GiB with 4 KiB pages.  For example, 2 GiB
  used out of 3 GiB returns 1205 bp instead of 6666 bp.  The LRU
  [in]active and hugepage metrics do not depend on NUMA.

- For quota goal scores, any current value above about 429,496 can
  overflow.  For example, a DAMOS_QUOTA_SOME_MEM_PSI_US goal with a
  target of one second and a current value of half a second returns 705
  instead of 5000.  On any architecture, mult_frac() also silently wraps
  scores that do not fit in unsigned long.

Use damon_mult_frac() for those calculations.

The node eligible memory metric counts bytes in phys_addr_t, so on
32-bit kernels it overflows once the eligible memory exceeds about
420 KiB, and it also truncates the byte counts to unsigned long with
PAE.  Use mul_u64_u64_div_u64() on the phys_addr_t values for it.  The
node eligible memory never exceeds the total, so the result fits.

Add a KUnit case for the quota goal scores.  The helper's KUnit cases
also cover the large page ratio used by the metrics.

The issues were discovered [1,2,3] by Sashiko.

[1] https://lore.kernel.org/20260901133650.EF4F71F000E9@smtp.kernel.org
[2] https://lore.kernel.org/20260626002448.975E21F000E9@smtp.kernel.org
[3] https://lore.kernel.org/20260831184956.1DA321F000E9@smtp.kernel.org

Fixes: 0e1c773b501f ("mm/damon/core: introduce damos quota goal metrics for memory node utilization")
Fixes: b74a120bcf50 ("mm/damon/core: implement DAMOS_QUOTA_NODE_MEMCG_USED_BP")
Fixes: 4835e2871321 ("mm/damon/core: introduce [in]active memory ratio damos quota goal metric")
Fixes: f465dc71aba0 ("mm/damon: introduce DAMOS_QUOTA_HUGEPAGE auto tuning")
Fixes: 9138e27a3bc3 ("mm/damon: add node_eligible_mem_bp goal metric")
Fixes: 06ba5b309ed8 ("mm/damon/core: let goal specified with only target and current values")
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
---
 mm/damon/core.c             | 18 +++++++++---------
 mm/damon/tests/core-kunit.h | 31 +++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 5cd4007cc370..cc4e010e400d 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3056,7 +3056,7 @@ static __kernel_ulong_t damos_get_node_mem_bp(
 		numerator = i.totalram - i.freeram;
 	else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
 		numerator = i.freeram;
-	return mult_frac(numerator, 10000, i.totalram);
+	return damon_mult_frac(numerator, 10000, i.totalram);
 }
 
 static unsigned long damos_get_node_memcg_used_bp(
@@ -3102,7 +3102,7 @@ static unsigned long damos_get_node_memcg_used_bp(
 		numerator = used_pages;
 	else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
 		numerator = i.totalram - used_pages;
-	return mult_frac(numerator, 10000, i.totalram);
+	return damon_mult_frac(numerator, 10000, i.totalram);
 }
 
 #ifdef CONFIG_DAMON_PADDR
@@ -3199,11 +3199,11 @@ static unsigned long damos_get_node_eligible_mem_bp(struct damon_ctx *c,
 
 	node_eligible = damos_calc_eligible_bytes(c, s, nid, &total_eligible);
 
-	if (!(unsigned long)total_eligible)
+	if (!total_eligible)
 		return 0;
 
-	return mult_frac((unsigned long)node_eligible, 10000,
-			(unsigned long)total_eligible);
+	/* node_eligible <= total_eligible, so this cannot overflow */
+	return mul_u64_u64_div_u64(node_eligible, 10000, total_eligible);
 }
 #else /* CONFIG_DAMON_PADDR */
 static unsigned long damos_get_node_eligible_mem_bp(struct damon_ctx *c,
@@ -3246,8 +3246,8 @@ static unsigned int damos_get_in_active_mem_bp(bool active_ratio)
 		global_node_page_state(NR_LRU_BASE + LRU_INACTIVE_FILE);
 	total = max(active + inactive, 1);
 	if (active_ratio)
-		return mult_frac(active, 10000, total);
-	return mult_frac(inactive, 10000, total);
+		return damon_mult_frac(active, 10000, total);
+	return damon_mult_frac(inactive, 10000, total);
 }
 
 static unsigned int damos_hugepage_mem_bp(void)
@@ -3263,7 +3263,7 @@ static unsigned int damos_hugepage_mem_bp(void)
 	thp = global_node_page_state(NR_ANON_THPS) +
 				global_node_page_state(NR_SHMEM_THPS) +
 				global_node_page_state(NR_FILE_THPS);
-	return mult_frac(thp, 10000, total_pages - free_pages);
+	return damon_mult_frac(thp, 10000, total_pages - free_pages);
 }
 
 static void damos_set_quota_goal_current_value(struct damon_ctx *c,
@@ -3329,7 +3329,7 @@ static unsigned long damos_quota_score(struct damon_ctx *c, struct damos *s)
 	damos_for_each_quota_goal(goal, quota) {
 		damos_set_quota_goal_current_value(c, s, goal);
 		highest_score = max(highest_score,
-				mult_frac(goal->current_value, 10000,
+				damon_mult_frac(goal->current_value, 10000,
 					goal->target_value));
 	}
 
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index e71e60d59400..aaf65828a5e1 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -756,6 +756,36 @@ static void damon_test_sample_ratio_large_value(struct kunit *test)
 			UINT_MAX);
 }
 
+static void damos_test_quota_score_large_value(struct kunit *test)
+{
+	struct damos s;
+	struct damos_quota_goal goal = {
+		.metric = DAMOS_QUOTA_USER_INPUT,
+		.current_value = 500000,
+		.target_value = 1000000,
+	};
+
+	memset(&s, 0, sizeof(s));
+	INIT_LIST_HEAD(&s.quota.goals);
+	INIT_LIST_HEAD(&goal.list);
+	damos_add_quota_goal(&s.quota, &goal);
+	KUNIT_EXPECT_EQ(test, damos_quota_score(NULL, &s), 5000ul);
+
+	goal.current_value = 1500001;
+	KUNIT_EXPECT_EQ(test, damos_quota_score(NULL, &s), 15000ul);
+
+	goal.current_value = ULONG_MAX;
+	goal.target_value = 1;
+	KUNIT_EXPECT_EQ(test, damos_quota_score(NULL, &s), ULONG_MAX);
+
+	/* the largest representable score, and one beyond it */
+	goal.current_value = ULONG_MAX - ULONG_MAX / 10000;
+	goal.target_value = 9999;
+	KUNIT_EXPECT_EQ(test, damos_quota_score(NULL, &s), ULONG_MAX);
+	goal.current_value++;
+	KUNIT_EXPECT_EQ(test, damos_quota_score(NULL, &s), ULONG_MAX);
+}
+
 static void damon_test_set_attrs(struct kunit *test)
 {
 	struct damon_ctx *c = damon_new_ctx();
@@ -2568,6 +2598,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_mult_frac),
 	KUNIT_CASE(damon_test_age_for_new_attrs_large_value),
 	KUNIT_CASE(damon_test_sample_ratio_large_value),
+	KUNIT_CASE(damos_test_quota_score_large_value),
 	KUNIT_CASE(damon_test_set_attrs),
 	KUNIT_CASE(damon_test_mvsum),
 	KUNIT_CASE(damon_test_nr_accesses_mvsum),
-- 
2.43.0


