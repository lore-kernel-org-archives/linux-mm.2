Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F9FB608B7C2
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TIf+VxNt
Received: by kanga.kvack.org (Postfix)
	id CA96C6B0664; Mon,  2 Nov 2026 10:38:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0E376B0666; Mon,  2 Nov 2026 10:38:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB5F56B0664; Mon,  2 Nov 2026 10:38:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8360D6B0664
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:38:04 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0E23C140157
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:38:04 +0000 (UTC)
X-FDA: 85390584888.29.1148F88
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6A235C0003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:38:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TIf+VxNt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RDxKZCrFjBdbqjmhaMnboUOhPibC6AsFu5GphLVZVgw=;
	b=aonZiXoPrltf1e/+eIADujawYw42RZTj1txaW51/25Jh04nazG6igtXRyBVXKg3yATvnjl
	gR4Xho1Icyw9arrNLRnxn74etbntEM16YWnX59e5VlGHzW41FGvaHOihUOuLZ0GnwzMq+Z
	brOomCwbnkBS/Gpkz0IpusHaC1cOvDo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TIf+VxNt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633882;
	b=345duHkqEKD8aJgc3Zy46e1HWPmFsr+OotmEb00TWMqgJoHPPVEDtXVVnv0wqfECiCGbG5
	JFVDU9HxpvvzSNklT7K+7Nx6arWNWWhWbE9ZgaPU9jZj9/rM2d6rwJmleSMK4Yb5aKtcef
	NIljokMeERrZNMH2OJZXu/DJZLAYv2o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0484760A74;
	Mon,  2 Nov 2026 15:38:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A131F00A1C;
	Mon,  2 Nov 2026 15:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633881;
	bh=RDxKZCrFjBdbqjmhaMnboUOhPibC6AsFu5GphLVZVgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TIf+VxNt6vX8WK4EkXYcXeo2KdBpiptVru3E3/Wu43cz8k9dnAELy96Dh/Aqf/Kvs
	 ALsbp5CYcUpxp81TRPE6s6FWLh/0SWGhIW4fQdPCmT1hibpgAjOCJBcnuqacbjUWgo
	 diMVHyzgdSgH0xg9aj+6iqx+JSDrRhlMHAQ3frWLvdHsy/kBubcHToa7rbGXqa8skC
	 xgWhzmjPeT80Z01e+4pu8t0j9L9iWAIcROC84Wnx6SDTF4380bR+yODaGs+C0M/yra
	 ZDJxrYjO5lb+khLvZsznoKCXS6Pokksjwec9ZU2AgjL0H43uRj0wT+XdCYGt1QYVLe
	 I3u1AUUtrZcEA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Suhaas Joshi <suhaas@s-joshi.in>
Subject: [PATCH v5 2/2] mm/damon/core: copy only installed probe in damon_split_region_at()
Date: Mon,  2 Nov 2026 07:37:52 -0800
Message-ID: <20261102153753.97769-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102153753.97769-1-sj@kernel.org>
References: <20261102153753.97769-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6A235C0003
X-Stat-Signature: srsjhfs1a688c1rke8jz1uymdsm1h8p3
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793633882-273233
X-HE-Meta: U2FsdGVkX18GhNoHCS/MXKhog8n53wczfHRnmVnAxv5xBEOogyA+MtHaazvmcl6a/1al6SKC3GAhDY3YugDnPMfUJ8ipP758mUdXEPHkgdAyIqZvW68GKa3xCYxZtdVek1NSLpoCHitzNUq1JIor+b7O0b47EgVRnNYUPlFDv3IAPLefLlUP8S0LhBfBdfFr/GriCUnwrSGuHLjfnzUgBtxORjkZSlhPndvm8pVVLM/wnvQkDHtiu07QknqpDs3NznCdA+XDxcgFNIdhkL14BilikDebfGLTZhf+I+NTP+YRrQ5ja6/ZRMQHyC/UrSjElOlwWxyDCY69Mlrfo/5YrfkR4YehQp7sF6aZwVIX9XyFyGF92bHuaxw4U1rkfKRSAc8/Me8boANeX/K4z7t7Wj5Rd3KC7PERvPw1UaUuxqIUlTU62dRQHjGuQMaYbJJ75n9+h04QYnlrjK5qPkpnpayRxeIAlauGARtjT0Q7eTsfM5gFeFPcqdVqPr1RCRGttOQvSU4tJIi8H5+gY8rrkReNvqLEWQtoFsUCvlZuDOgaH4fb2RgS5T1+/cphBOvY8G98I1mKP+SI6CYbkxMZEICi+juDhMIOiWdVuJ80Md/z79douEbw/X0xese48QID6gQEqQIYX2syVscT8pv5fIyDnvuyn4T6E+G2Al117jmlhCTeNY4EPxiFym7HWvt+n/O2y3nihAjjU9puzn8zRAZXF5PK9UmQ/ZvimPCoIUNkDCNTP3EvoVBRQoRl9BRpVnVclDRQZLpVW9IruSPvcredFh+QpAETEF+WcqpleF+UgqbcCBeFYBTosgQ1Hi181GZY96jxRGFp82WUva7qJkHc/LCcZwDot6Bir5tY6UiXPcXoKNrdc2o7AqsgPx5XJxdG+RzCACvnNaMRMhZ2OOvxlvYBbtAnsYzgfmJB1ZLbigD+FpfJE7PMFGnvwUw2n6AS1KN2wm+3gqTaKPZ
 2sBsh3CB
 tV1+7N5xY4cEsJsdsi9lKkD5c5YgK8ToxBzTq4jmboWPAPdKEKLt9hYy7pbFr6dl0hX5yf5oNpSWS1i9Ud5H5/t7Ai6HsEy7TInVT4WkvWo2Qwp26LV93cA8qxCc7eMlVVeMVq0b/uY+2ivTag3UPk8zdCdtSpEtpoQmKtoiTiNz8113M4xfhYXctCLejbHN/3e11GL8dD+TimcaFb8qAtTq1j7654V+MeI3n9qL9iH6FwGDhQQvaRHmXPyT++zvYWfeBi0nEthJ7HyT9rQuZqO7q5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In damon_split_region_at(), we copy the entire probe_hits[] and
last_probe_hits[] arrays of DAMON_MAX_PROBES size. However it is possible
that the number of probes installed is less than DAMON_MAX_PROBES, in which
case one or more iterations is/are redundant. To remedy this, iterate over
only as many times as the number of installed probes. To do so, accept a
struct damon_ctx pointer in damon_split_region_at(), and update all
invocations of the function to pass the new argument.

Also update damon_test_split_at() and damos_test_filter_out() in
core-kunit.h to supply a context to function paths that call
damon_split_region_at().

Signed-off-by: Suhaas Joshi <suhaas@s-joshi.in>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c             | 42 +++++++++++++-----------
 mm/damon/tests/core-kunit.h | 64 +++++++++++++++++++++++++++++++------
 2 files changed, 78 insertions(+), 28 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 36d60f3e1de62..d36823f4d0928 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2046,8 +2046,8 @@ static unsigned long damon_region_sz_limit(struct damon_ctx *ctx)
 	return sz;
 }
 
-static int damon_split_region_at(struct damon_target *t,
-				  struct damon_region *r, unsigned long sz_r);
+static int damon_split_region_at(struct damon_ctx *ctx, struct damon_target *t,
+		struct damon_region *r, unsigned long sz_r);
 
 /*
  * damon_apply_min_nr_regions() - Make effect of min_nr_regions parameter.
@@ -2072,7 +2072,7 @@ static unsigned long damon_apply_min_nr_regions(struct damon_ctx *ctx)
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region_safe(r, next, t) {
 			while (damon_sz_region(r) > max_region_sz) {
-				if (damon_split_region_at(t, r, max_region_sz))
+				if (damon_split_region_at(ctx, t, r, max_region_sz))
 					goto out;
 				r = damon_next_region(r);
 			}
@@ -2469,6 +2469,7 @@ static bool damos_valid_target(struct damon_ctx *c, struct damon_region *r,
 /*
  * damos_skip_charged_region() - Check if the given region or starting part of
  * it is already charged for the DAMOS quota.
+ * @ctx: The pointer to the context.
  * @t:	The target of the region.
  * @rp:	The pointer to the region.
  * @s:	The scheme to be applied.
@@ -2491,8 +2492,8 @@ static bool damos_valid_target(struct damon_ctx *c, struct damon_region *r,
  *
  * Return: true if the region should be skipped, false otherwise.
  */
-static bool damos_skip_charged_region(struct damon_target *t,
-		struct damon_region *r, struct damos *s,
+static bool damos_skip_charged_region(struct damon_ctx *ctx,
+		struct damon_target *t, struct damon_region *r, struct damos *s,
 		unsigned long min_region_sz)
 {
 	struct damos_quota *quota = &s->quota;
@@ -2520,7 +2521,7 @@ static bool damos_skip_charged_region(struct damon_target *t,
 				}
 				sz_to_skip = min_region_sz;
 			}
-			damon_split_region_at(t, r, sz_to_skip);
+			damon_split_region_at(ctx, t, r, sz_to_skip);
 			skip = true;
 		}
 	}
@@ -2579,13 +2580,13 @@ static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
 		}
 		/* start before the range and overlap */
 		if (r->ar.start < start) {
-			*err = damon_split_region_at(t, r,
+			*err = damon_split_region_at(ctx, t, r,
 					start - r->ar.start);
 			matched = false;
 			break;
 		}
 		/* start inside the range */
-		*err = damon_split_region_at(t, r, end - r->ar.start);
+		*err = damon_split_region_at(ctx, t, r, end - r->ar.start);
 		matched = true;
 		break;
 	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
@@ -2784,7 +2785,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 					c->min_region_sz);
 			if (!sz)
 				goto update_stat;
-			if (damon_split_region_at(t, r, sz))
+			if (damon_split_region_at(c, t, r, sz))
 				goto update_stat;
 		}
 		if (damos_core_filter_out(c, t, r, s))
@@ -2831,7 +2832,7 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 		if (damos_quota_is_full(quota, c->min_region_sz))
 			continue;
 
-		if (damos_skip_charged_region(t, r, s, c->min_region_sz))
+		if (damos_skip_charged_region(c, t, r, s, c->min_region_sz))
 			continue;
 
 		if (s->max_nr_snapshots &&
@@ -3690,15 +3691,18 @@ static void damon_verify_split_region_at(struct damon_region *r,
 /*
  * Split a region in two
  *
+ * ctx		pointer to the region's context
  * r		the region to be split
  * sz_r		size of the first sub-region that will be made
  *
  * Return: 0 on success, negative error code otherwise.
  */
-static int damon_split_region_at(struct damon_target *t,
-				  struct damon_region *r, unsigned long sz_r)
+static int damon_split_region_at(struct damon_ctx *ctx, struct damon_target *t,
+		struct damon_region *r, unsigned long sz_r)
 {
 	struct damon_region *new;
+	struct damon_probe *p;
+	int i;
 
 	damon_verify_split_region_at(r, sz_r);
 	new = damon_new_region(r->ar.start + sz_r, r->ar.end);
@@ -3710,11 +3714,13 @@ static int damon_split_region_at(struct damon_target *t,
 	new->age = r->age;
 	new->last_nr_accesses = r->last_nr_accesses;
 	new->nr_accesses = r->nr_accesses;
-	/* todo: do this for only installed probes */
-	memcpy(new->probe_hits, r->probe_hits, sizeof(r->probe_hits));
-	memcpy(new->last_probe_hits, r->last_probe_hits,
-			sizeof(r->last_probe_hits));
 
+	i = 0;
+	damon_for_each_probe(p, ctx) {
+		new->probe_hits[i] = r->probe_hits[i];
+		new->last_probe_hits[i] = r->last_probe_hits[i];
+		++i;
+	}
 	damon_insert_region(new, r, damon_next_region(r), t);
 	return 0;
 }
@@ -3743,7 +3749,7 @@ static void damon_split_regions_of(struct damon_ctx *ctx,
 			if (sz_sub == 0 || sz_sub >= sz_region)
 				continue;
 
-			damon_split_region_at(t, r, sz_sub);
+			damon_split_region_at(ctx, t, r, sz_sub);
 			sz_region = sz_sub;
 		}
 	}
@@ -3776,7 +3782,7 @@ static void damon_split_some_regions(struct damon_ctx *ctx,
 			if (sz_sub == 0 || sz_sub >= sz_region)
 				continue;
 
-			damon_split_region_at(t, r, sz_sub);
+			damon_split_region_at(ctx, t, r, sz_sub);
 		}
 	}
 }
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index ca10d450f7e23..a5ca4bfe2f0db 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -141,6 +141,8 @@ static void damon_test_split_at(struct kunit *test)
 {
 	struct damon_target *t;
 	struct damon_region *r, *r_new;
+	struct damon_ctx *ctx;
+	struct damon_probe *p;
 
 	t = damon_new_target();
 	if (!t)
@@ -150,13 +152,29 @@ static void damon_test_split_at(struct kunit *test)
 		damon_free_target(t);
 		kunit_skip(test, "region alloc fail");
 	}
+	p = damon_new_probe();
+	if (!p) {
+		damon_free_region(r);
+		damon_free_target(t);
+		kunit_skip(test, "probe alloc fail");
+	}
+	ctx = damon_new_ctx();
+	if (!ctx) {
+		damon_destroy_probe(p);
+		damon_free_region(r);
+		damon_free_target(t);
+		kunit_skip(test, "context alloc fail");
+	}
+	damon_add_probe(ctx, p);
+	damon_add_target(ctx, t);
+
 	r->nr_accesses = 42;
 	r->last_nr_accesses = 15;
 	r->probe_hits[0] = 7;
 	r->last_probe_hits[0] = 3;
 	r->age = 10;
 	damon_add_region(r, t);
-	damon_split_region_at(t, r, 25);
+	damon_split_region_at(ctx, t, r, 25);
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
 	if (damon_nr_regions(t) != 2)
 		goto out;
@@ -175,7 +193,7 @@ static void damon_test_split_at(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, r->age, r_new->age);
 
 out:
-	damon_free_target(t);
+	damon_destroy_ctx(ctx);
 }
 
 static void damon_test_merge_two(struct kunit *test)
@@ -1799,6 +1817,8 @@ static void damos_test_filter_out(struct kunit *test)
 	struct damon_target *t;
 	struct damon_region *r, *r2;
 	struct damos_filter *f;
+	struct damon_ctx *ctx;
+	struct damon_probe *p;
 	int err;
 
 	f = damos_new_filter(DAMOS_FILTER_TYPE_ADDR, true, false);
@@ -1819,28 +1839,44 @@ static void damos_test_filter_out(struct kunit *test)
 	}
 	damon_add_region(r, t);
 
+	p = damon_new_probe();
+	if (!p) {
+		damon_free_target(t);
+		damos_destroy_filter(f);
+		kunit_skip(test, "probe alloc fail");
+	}
+	ctx = damon_new_ctx();
+	if (!ctx) {
+		damon_destroy_probe(p);
+		damon_free_target(t);
+		damos_destroy_filter(f);
+		kunit_skip(test, "context alloc fail");
+	}
+	damon_add_probe(ctx, p);
+	damon_add_target(ctx, t);
+
 	/* region in the range */
-	KUNIT_EXPECT_TRUE(test, damos_filter_match(NULL, t, r, f, 1, &err));
+	KUNIT_EXPECT_TRUE(test, damos_filter_match(ctx, t, r, f, 1, &err));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region before the range */
 	r->ar.start = 1;
 	r->ar.end = 2;
 	KUNIT_EXPECT_FALSE(test,
-			damos_filter_match(NULL, t, r, f, 1, &err));
+			damos_filter_match(ctx, t, r, f, 1, &err));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region after the range */
 	r->ar.start = 6;
 	r->ar.end = 8;
 	KUNIT_EXPECT_FALSE(test,
-			damos_filter_match(NULL, t, r, f, 1, &err));
+			damos_filter_match(ctx, t, r, f, 1, &err));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region started before the range */
 	r->ar.start = 1;
 	r->ar.end = 4;
-	KUNIT_EXPECT_FALSE(test, damos_filter_match(NULL, t, r, f, 1, &err));
+	KUNIT_EXPECT_FALSE(test, damos_filter_match(ctx, t, r, f, 1, &err));
 	/* filter should have split the region */
 	KUNIT_EXPECT_EQ(test, r->ar.start, 1);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 2);
@@ -1856,7 +1892,7 @@ static void damos_test_filter_out(struct kunit *test)
 	r->ar.start = 2;
 	r->ar.end = 8;
 	KUNIT_EXPECT_TRUE(test,
-			damos_filter_match(NULL, t, r, f, 1, &err));
+			damos_filter_match(ctx, t, r, f, 1, &err));
 	/* filter should have split the region */
 	KUNIT_EXPECT_EQ(test, r->ar.start, 2);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 6);
@@ -1869,7 +1905,7 @@ static void damos_test_filter_out(struct kunit *test)
 	damon_destroy_region(r2, t);
 
 out:
-	damon_free_target(t);
+	damon_destroy_ctx(ctx);
 	damos_free_filter(f);
 }
 
@@ -2459,6 +2495,7 @@ static void damos_test_esz_goal_temporal(struct kunit *test)
 static void damon_test_last_region_quota_reset(struct kunit *test)
 {
 	struct damos s = {0};
+	struct damon_ctx *ctx;
 	struct damon_target *t;
 	struct damon_region *r1, *r2;
 	unsigned long min_region_sz = 1;
@@ -2485,7 +2522,14 @@ static void damon_test_last_region_quota_reset(struct kunit *test)
 	s.quota.charge_target_from = t;
 	s.quota.charge_addr_from = r1->ar.end;
 
-	skipped = damos_skip_charged_region(t, r2, &s, min_region_sz);
+	ctx = damon_new_ctx();
+	if (!ctx) {
+		damon_free_target(t);
+		kunit_skip(test, "ctx alloc failed");
+	}
+	damon_add_target(ctx, t);
+
+	skipped = damos_skip_charged_region(ctx, t, r2, &s, min_region_sz);
 
 	/* 'r2' is not processed, it should not skip */
 	KUNIT_EXPECT_EQ(test, skipped, false);
@@ -2494,7 +2538,7 @@ static void damon_test_last_region_quota_reset(struct kunit *test)
 	KUNIT_EXPECT_PTR_EQ(test, s.quota.charge_target_from, NULL);
 	KUNIT_EXPECT_EQ(test, s.quota.charge_addr_from, 0);
 
-	damon_free_target(t);
+	damon_destroy_ctx(ctx);
 }
 
 static struct kunit_case damon_test_cases[] = {
-- 
2.47.3

