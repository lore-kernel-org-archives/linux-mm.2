Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A588608B7EE
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F1H9ljGU
Received: by kanga.kvack.org (Postfix)
	id 6B7DF6B0663; Mon,  2 Nov 2026 10:38:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68FD96B0664; Mon,  2 Nov 2026 10:38:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A5266B0665; Mon,  2 Nov 2026 10:38:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 365896B0663
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:38:04 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CA1151C1CDD
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:38:03 +0000 (UTC)
X-FDA: 85390584846.15.2F67DC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 25C391A0007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:38:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F1H9ljGU;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633882;
	b=aWWJgM4wG2kJ578/5rSOai0dqz3PxTBBWXimK6kJYAqnI7LSFdiOF+yhQnh1qhP52owUSf
	XZzwzoW1U8s+DyO6ev9Q4C/lXwV7eZY0/Nng0mbA7IKBotb87nZOtazwqLcMIMiKmHTzLw
	evBSGFhaxnDqMCJj8T30nFwPQtUlezY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F1H9ljGU;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z+MgUCfG+V3Anb7erI6rfwRs5z2tWPjnS6eSgen+Zus=;
	b=M+gPmpcTrPW6sEHK8GjR6MJfR/bXNg0oNTE0O07UFiI4I8nQoMD1eBOfMdl/2BvINiKFsS
	WjMaHCQgi1yrdYpQ622Ks0jqD0Rsg+YiH+2UbPk8bkXmPsVRec00SLZYuiHwk0sj1DbjFB
	dYO3K/inDCxLpmaCU5Ya0GHPA5/i6JQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 702E2401BF;
	Mon,  2 Nov 2026 15:38:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2483A1F00A1A;
	Mon,  2 Nov 2026 15:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633881;
	bh=z+MgUCfG+V3Anb7erI6rfwRs5z2tWPjnS6eSgen+Zus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F1H9ljGUVASadIr5+7Ym9zRdT/V/czLIDX4/2uWxB9FZtwDQZ67p8KfWpgs2fc1uA
	 4un8fUuEUxQPP5KYjV/e4cqrGf9Ppv6EitIT/zLprpTAQb64ZDulF+Q9EUfQ9WIzZL
	 aA6vhbj85DBX1DdquyrEEOp8H2M9lmYHa6kpcP7u2igeE6YjWBuzuGzqi4x6v6CQmf
	 H/6VTppz5j7PRUutHzYdBOHpLgZidYmnAaj2gV3O5pTxEDLLESmZA/UurAaG5oXAdv
	 JQQ5ia8DOe3mZeFi9UbE3GESeNv3dcIC12jZ7MppLPfNj4tLcS1N0/i/JwxiT9UASz
	 AXgkcf5xQxzrA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suhaas Joshi <suhaas@s-joshi.in>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v5 1/2] mm/damon/core: use only installed probe in damon_merge_two_regions()
Date: Mon,  2 Nov 2026 07:37:51 -0800
Message-ID: <20261102153753.97769-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102153753.97769-1-sj@kernel.org>
References: <20261102153753.97769-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 25C391A0007
X-Stat-Signature: fjzdxehxqmunf8ftpiscsmcdw8fordif
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793633882-829466
X-HE-Meta: U2FsdGVkX1/TfoARp4i0lJUbNYilVy2yrTdyl+TQBTsPXwkKGvm+d5b+4+DTFCyJ8TFnEFQgAPFphBfTHBNfe7Vfb1FcaaW3af6nh6a1YohCGMQI/Dzowyhhn5seGSOeamu11bffHQNBkStpQyc9usIJV7+mPuYzUyjzlelN/Lyg/t5i76LpQnZ3D/AUmm8IYUHZXvHp0U8/ZHR5n9c/KKLncthfu+JYZLOjT/y6V3/dNT6sNfyWi9kHLrgu6wYXa/GL+CpI0D5VlF0SGOq6wM65jUx/S+PBPkZStznS6m7U17ayJWYZkLUkUuHnRjS0vZ720thNbkwI4fGNdOqQgoDeVV9QSDe7NmRDfIdB+u67NiRlSMaeGG4LwU18IK9Ar6e9keT6LQ7MeVzuPHuZrXrYPkMU0a2r5xlNZQnwPyFL2ySo0pUR3H9wd8wcKTRez0wU/DaB/Ew3hppz6L1AzU9H8x3wnUkEm7XwWTl5bFe09SIuqoUNXKtW9aTRk0cuU2wvq1g5pkJa6RtECCcoOKTq5vQj8ccCt9/+X9SodNYmYaUOQykBg+BbjyaOIZXtbRpSPc2kZ7DlzuLlBS8ni3SttLVapyxIyHNRy+Y3nvg+3hOGjVGs3MXWpIqIZm8qJsfEeBubxSDMH855+BGV6zimH5lJAOu0ma3mzjttS4o1Q6bgi3A8mfq64TGAz19gWdi9BU2KD4UGz+PZpJWPYLsUqGRY6cmeLyDYmH9CqNyi+/ebUGhyz6GBJ/cY0cKw3mMaJkWuStCov0ykCrgpQyzGxGVGXWsYksaU9Wxz8LHAjDoSrukyvegHytu7IpUe2lSVSSJPqNTcIZXhT1qZdhooDQr5gRWenU6eu3MUYb7Rc5Fw8nXGEc23aBKiqN6ZsaC+/ceTXyxqmNxXnWO1FjlP/aYOTtHANfGnqSE6BGGGztdJ5nuHgS2pFDfUH/HrWIxGEyCaGW/5z9FPPnb
 EbiTry/n
 8DFzo7gR6Y6EZXfopqWnhhAGTGZqPw9IkLzX9y1HYiOTUuAzLjWlREexJKpmOfUFp5B2dxE+cvj10moJX1i/EtHP4aRCjVkb3Rx+QffWaQ7CwUJy2sW2KMdim15wvsME9Bb22G3ok73ysx/0GEr7dTuZ3ZDltjzWhlwe0XH11uxNgpQVIwOb0J4Z4X73CT/mOmTe6TPlkPAc7lz0S49S1GwE5oYPCSe44xkNnVltfjsCzNWF5FasZ/k7LxXgcgdmZZq+sE4T2UYJu7gwcI+CDyqMb3YEqV6DUGlyZB2S0YxwoDE99Cyfo2h3kVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Suhaas Joshi <suhaas@s-joshi.in>

While merging 2 regions, we iterate over the entire probe_hits[] array,
whose size is determined by the DAMON_MAX_PROBES macro. However, it is
possible that we have fewer probes installed than DAMON_MAX_PROBES. In such
cases, we end up making redundant iterations. Therefore, to remedy this,
iterate over the list of installed probes instead of iterating over the
entire array. For doing this, start accepting a struct damon_ctx in
damon_merge_two_regions(), and update calling functions to pass this
argument.

Update the damon_test_merge_two() test to use this new signature for
damon_merge_two_regions() as well.

Signed-off-by: Suhaas Joshi <suhaas@s-joshi.in>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c             | 15 ++++++++++-----
 mm/damon/tests/core-kunit.h | 20 ++++++++++++++++++--
 2 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 9d54899004026..36d60f3e1de62 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3549,20 +3549,25 @@ static void damon_verify_merge_two_regions(
 /*
  * Merge two adjacent regions into one region
  */
-static void damon_merge_two_regions(struct damon_target *t,
-		struct damon_region *l, struct damon_region *r)
+static void damon_merge_two_regions(struct damon_ctx *ctx,
+		struct damon_target *t, struct damon_region *l,
+		struct damon_region *r)
 {
 	unsigned long sz_l = damon_sz_region(l), sz_r = damon_sz_region(r);
 	int i;
+	struct damon_probe *p;
 
 	l->nr_accesses = (l->nr_accesses * sz_l + r->nr_accesses * sz_r) /
 			(sz_l + sz_r);
 	l->age = (l->age * sz_l + r->age * sz_r) / (sz_l + sz_r);
 	l->ar.end = r->ar.end;
-	/* todo: do this for only installed probes */
-	for (i = 0; i < DAMON_MAX_PROBES; i++)
+
+	i = 0;
+	damon_for_each_probe(p, ctx) {
 		l->probe_hits[i] = (l->probe_hits[i] * sz_l + r->probe_hits[i]
 				* sz_r) / (sz_l + sz_r);
+		++i;
+	}
 	damon_verify_merge_two_regions(l, r);
 	damon_destroy_region(r, t);
 }
@@ -3615,7 +3620,7 @@ static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
 			goto set_prev_continue;
 		if (damon_sz_region(prev) + damon_sz_region(r) > sz_limit)
 			goto set_prev_continue;
-		damon_merge_two_regions(t, prev, r);
+		damon_merge_two_regions(ctx, t, prev, r);
 		continue;
 set_prev_continue:
 		prev = r;
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 43e2f950f8ff4..ca10d450f7e23 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -182,6 +182,8 @@ static void damon_test_merge_two(struct kunit *test)
 {
 	struct damon_target *t;
 	struct damon_region *r, *r2, *r3;
+	struct damon_probe *p;
+	struct damon_ctx *ctx;
 	int i;
 
 	t = damon_new_target();
@@ -206,7 +208,21 @@ static void damon_test_merge_two(struct kunit *test)
 	r2->age = 21;
 	damon_add_region(r2, t);
 
-	damon_merge_two_regions(t, r, r2);
+	p = damon_new_probe();
+	if (!p) {
+		damon_free_target(t);
+		kunit_skip(test, "probe alloc fail");
+	}
+	ctx = damon_new_ctx();
+	if (!ctx) {
+		damon_destroy_probe(p);
+		damon_free_target(t);
+		kunit_skip(test, "context alloc fail");
+	}
+	damon_add_probe(ctx, p);
+	damon_add_target(ctx, t);
+
+	damon_merge_two_regions(ctx, t, r, r2);
 	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 300ul);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, 16u);
@@ -220,7 +236,7 @@ static void damon_test_merge_two(struct kunit *test)
 	}
 	KUNIT_EXPECT_EQ(test, i, 1);
 
-	damon_free_target(t);
+	damon_destroy_ctx(ctx);
 }
 
 static struct damon_region *__nth_region_of(struct damon_target *t, int idx)
-- 
2.47.3

