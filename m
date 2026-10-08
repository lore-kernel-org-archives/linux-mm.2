Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48012CA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 15:20:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F022A6B008A; Thu,  8 Oct 2026 11:20:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8C056B008C; Thu,  8 Oct 2026 11:20:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D548C6B0092; Thu,  8 Oct 2026 11:20:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B3E436B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:20:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 40F49802DD
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 15:20:18 +0000 (UTC)
X-FDA: 85299820116.20.7EB60AE
Received: from flow-a8-smtp.messagingengine.com (flow-a8-smtp.messagingengine.com [103.168.172.143])
	by imf10.hostedemail.com (Postfix) with ESMTP id 22E4FC0006
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 15:20:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=s-joshi.in header.s=fm1 header.b="R J+trGL";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=mJqmRJjn;
	spf=pass (imf10.hostedemail.com: domain of suhaas@s-joshi.in designates 103.168.172.143 as permitted sender) smtp.mailfrom=suhaas@s-joshi.in;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791472816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ta9VTltlWRdF05/D8b/khNytMzX4AxfIKyly2vVwptM=;
	b=53x7rnusVzWx+rlBp3T7AWTKtMss3H8Wh1V1SHG3cWasqeUwHi96KxgkHhZMyFe4yJJYt3
	EI97SfdA4asSqtKgVY1RWvG84/bOzTp8k5JA8HP2ygSCqbWa+VwuTqrDT8v6DGwY1fgj1U
	G8X2nIIBjfMdpmd545aO+EjM+Rb+g+s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=s-joshi.in header.s=fm1 header.b="R J+trGL";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=mJqmRJjn;
	spf=pass (imf10.hostedemail.com: domain of suhaas@s-joshi.in designates 103.168.172.143 as permitted sender) smtp.mailfrom=suhaas@s-joshi.in;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791472816;
	b=L4lzV/kF8YCQr90tTcnzbpqLohJciXYvL6XnA3Mz7mAzUBNJkuLOCnO+FqL+C2lmv/5aqu
	KF4CvPz+BIFuVgmIL0iryrcuinre63ZUUpUZQVjnrkSeqG+lIffAx+HRsvSx+WPvsnjyJX
	BhUqspk8TcpfKh1DyrMMxR4lGEYGz3s=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.phl.internal (Postfix) with ESMTP id 8773413804B8
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:20:15 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 08 Oct 2026 11:20:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=s-joshi.in; h=cc
	:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1791472815; x=
	1791476415; bh=Ta9VTltlWRdF05/D8b/khNytMzX4AxfIKyly2vVwptM=; b=R
	J+trGLFiHc173kC7Y1WekkcSfFYMjB2Kw3FAXstAkHS5IcebYuZpeOyTTmNU6o7G
	qUnM2HSKTL9zUjozl5dG10KYoJwgcwYvNs/BwA/tlTexTr70fJN3fp7O3GtZW0Td
	VmIF+SE6Z4zdKXJNLydYlRbCC+O5mbT9CJmAgFhbzbp3n25i1Abz/AfFJc76NiZg
	KOVKrIHDnAOo8aJLT2v5Z6ME56xYGWPOIuqEkzEbVaoEWfN524j/W/3p2wBmDh+4
	Plj0GsDclBXkbuCv0VplqP9Mc0q56YUKx5HdgEQhHvSiUqZg30IEyeszTMKRb+D8
	U9umTXGu38CPZPqbJYHiw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1791472815; x=1791476415; bh=T
	a9VTltlWRdF05/D8b/khNytMzX4AxfIKyly2vVwptM=; b=mJqmRJjn+LkKdYB9o
	1JHl/NWqScBzwIygC1qBFlZcM/dQfs6/LLNwGq3STaTr/A14pPlFMgWbmGOul3Z2
	MD2C8C6YaIsV3Vllt9oWi//kDsP06zmf58IRAo2gtrwxv4BYdqgip7Mcsz6puW6f
	v6vraqFJ2YcT4gkHCzItTKucIrZqW+abQCPpZ2gMd8c9VDp7lAvkU+R05K3SLhL+
	j9gAdS3WG/l41gz3iSYZ6CR7RKoqX8e0fAanc4m1QxxGIPEAGyQiIRio0SsgetYO
	iDzzVSzMad/JtjKkYtVJjmArd19Bg3aT3A6UPKCyhk9hrovmspemqnQOLCFEL1tm
	sfMUw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=s-joshi.in a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791472815; d=s-joshi.in;
	mf=PHN1aGFhc0BzLWpvc2hpLmluPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:GWKPHNJZbarAbJr4EkWVscpeE2pVo6b46+zEiaa3WZWY8tv
	96ieKdQpi1+3hqFa0pXOFMcgweH7O6ek8i5uHq5nbKmLh2yIKOyhDPUUINScSaol
	wLpi0Nv1ghmIi+tL5EsizMXAFqv8Sk3Fg0LU+RYE6mnOfxF5InqqI5Zo8BNC39AF
	dX3pQc+XpZl7b6cWYDX3SAvYYKVStHN2S744ga0TsvL7oyNr4j4Xi9xh2Ehb6QS+
	Jzmbgh1xMjlioLSM0yVnSamRcVrM1/EXeb58mYugKYXFZKDK5ebFR7DUYOsbdk2P
	YscsDrotO1D+OqoO7K4GVOuRdmYfxux3HKPjScw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:GjaHNlPQHdzpUjaVVm1nmoHkaMenMqF0aN9KzBEuPFg=:e7ERreKHiOOv9CSbIXDAbTuNf1BLAP6Jhju1J1ZFDKM=;
X-ME-Sender: <xms:r7THappW6IywW8HuOcK6XZ_s_y0cLf8D_cBLBocUrXQ88uxtOuVyqQ>
    <xme:r7THasWpYq15Lv5drFyHy5JRYDU7eq4ioTXjCPssCrnQGEDFfA3ZMmpJ6OFEc7j-M
    ZD1YuCB1Wc620EZHhM9nwLKV5oJK9ZPfBGkBg66HftcXaJzfWYtg_Co>
X-ME-Received: <xmr:r7THakYb2hba3agwsl6SGfbXcYDXjBeopfxrc7JxnQnB-RYAMBzuvoejYw>
X-ME-Proxy-Cause: dmFkZTE7Rb351G0R8SPI91T2ULiEwlsWaSN0SYjxpqHcExmMqEBVpkcJrRJdtJYJv0xU9X
    mb2RVMnxHNqAcNDo0PQgX8Lp9vq2778ObHCahwNLqEH9FxhpVir/PFIr7l2E9Hx6MFqLXZ
    fARGPVZeIUqGpiI3+4b5Mm/xAFVjCcMzfzuwKfi06QinMULzduJn8C2+CQuL1rIP7yqnw4
    6M0HZNMimgzR1Y6dUDEkpxDXLLw4pfZCCtmAls7/jI5s13b3FjAljq4c7HgfsbIf6lJK+Q
    iztD5x0JRhOi0JS/SAvuePtt6oApHrxq0VRFSciMrMdopwAYZSijolYnG2EH+6Foxnf7IL
    pyiMM/vZDikrJMxTNd/DOMWfp+R7EUZOiDsw3DHseoDDm25sWIkcyCtDPjsimSiyglO747
    gt9tz/vy/YmFObIeEoegd9cwbeHJ8skPanrdTWlX3+I8EZf5Hp4HkwZldt+uIv1szF1zAO
    ZAHkwe5PUpeIlPHhYasGMU9hkVYH1UCvt6FOHerscM3Uj55rRAp/+g1vu+SaEWoIwpaWAT
    dyafXRlvg1+Q4PLkNAIViuJ8/4cPFxMJST6ni4jsSQ+LYCUX9hF3YtTv22wlhTJpqPCZvl
    CvtxlLr09d/5bmQ2rGTrf2faDjrywWyH+vY88pEj2GSXJW6iPifDOeZR5OQg
X-ME-Proxy: <xmx:r7THapfgM9pdLtjlCCC0Cjak3uzUmFgaaC2M7yYGSUIdWHkisy_hHA>
    <xmx:r7THau2l7PQSk-d5yGK_olQMGcZOWbw187JOoy-HyrdWXPL4d9hhYQ>
    <xmx:r7THagKPuvAFTYEtiqAsVAq4C6eoYSfOUcL-gLtifWbLgGVHTeLXOQ>
    <xmx:r7THatFtT0HZkRmHpc8x3_5imTDX7O0VgI__wNHNP5NR22Us9TliIg>
    <xmx:r7THav9wo9cNfVkSin9GLWmD2c59Xsi_KN3ya9T_Hivulgf_kuSFeN1k>
Feedback-ID: ia9504abf:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 8 Oct 2026 11:20:13 -0400 (EDT)
From: Suhaas Joshi <suhaas@s-joshi.in>
To: sj@kernel.org,
	akpm@linux-foundation.org,
	aethernet65535@gmail.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] mm/damon/core: Use only installed probe in damon_merge_two_regions()
Date: Thu,  8 Oct 2026 20:49:25 +0530
Message-ID: <20261008151944.113714-2-suhaas@s-joshi.in>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261008151944.113714-1-suhaas@s-joshi.in>
References: <20261008151944.113714-1-suhaas@s-joshi.in>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 22E4FC0006
X-Rspam-User: 
X-Stat-Signature: twmfch5kwu4juruzya6gxipj64797cgq
X-HE-Tag: 1791472815-168552
X-HE-Meta: U2FsdGVkX1+cRIsRtRyCmQEBiYHKvjNXzNeGtweQ/P8oLr1O244D1XkQAHd8hGDz2Os1VvqRxsLnBZ93wT3II8C8rsR1lZHgVn24dawePalgpbvmjV+eopjqAGC4YJyCrZoc2td60OA+3DnowMqZJJY/RcP7kTOwEwYnn8UJOnRS/sCqhTfOMF2K8nrqe/oXxSLW8k9BQFsQlKJJFqscwVX5Q+dCRXo6TDLAck6bJ6rf9G3apGg3YCp4QFQWb+h5sSGBbIlEeeSEeXZTBpz1Jf5+cf4K2KHlX4xv4mMaRBbz9bjBLo/Qtp4nza32MosjheDnD8lKOvvD8s3KuAJOdKGtHrR+uKTWSPVvs8fvIo3W5TwD3IEPlJSP7Y9V5CGHc8TaeRluEqG94sUponFMujMQ9aNRDyNg9LXO+8LxV2e3kMGBafTn89+Y3DWJgsWVdHJCxZJlG8D0un7hThGLqKCFXdPbudt0OeBFQjKOfPhAEaHs0SsrwNsUEgwytfH1GiBzIC+sZ6o84CIhIjs6MbXGfZOS3pcX76I1uqn4a9pPMz60kERBwT59hVVicvpNFdojgax0b+zzJxzrBf6k2t5pXg1iYXaxpqn38vqg+GGA6JxmJsAz5vcGpEn0yXa6c/CejixQaKTNCCTBL+uWZRCMxdkzuvkAUZqzdJCysUNzIhxjDi3T46GFjlIPN3dO7GEK+UCmJvRtPvbRCLLYtp4uX61GX/MZ1uBNedL60WhicToG/3Hmckk9QSCp9UwCY05Tr2HKSmezJhCwonVMOvx/blXomKbpP19uGbazd2KW7d9F4WgaC3M7SebizrZ9ytwVVOpLFWF4gQ6MsUD7PK+xlil2TQRyjSiF+QXys2SVv3B0TZaxn6pzJOra6Ds9Nv7dBSZp/GbiY0woBEUdkyoprMS92LZkrZts7xzgXgz2gP1Jcjj04aB7KKvvtuHgSbtUt0JaHic/KMnd7Of
 lLjtoKhc
 jpiGyP9PqoRc0I/Qorz6J0VMAma50fKJo7daDe3t0mc4NEa8RuSsjjsA3dIRkj9B51ulsjZlaV3no+B7u0XVDDzXnM7+BO2lJq/Iucn8wnHdTJFA0XtpJIu3UcAnvvPpe+mnj+IObSOBJTcI1vU+jBxcgHMwq9mLMNtoFpHuLBjBVW+rUdTBZGSoLanj0N/+mTc/IKum50wfzIamlkTWhuC2TbC9d3lkmSISbkQXT59NtJ9DjzwwNbgaE0iG9OdsuCS+1UfsP6jfUleDlEs8hoo8gsK6XAHFE3MBmOrgyw9dbn6mpTE3Kng3EVe85wGtSrJ3z3jno3iOUrp7J4myS3DvCQaP6kTfsGoSvz3kHzLqcpBOKO9TiYA6K0M2nVjMu+d0PcNN8ds+zp0DDbm+ADCML5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
---
 mm/damon/core.c             | 16 +++++++++++-----
 mm/damon/tests/core-kunit.h | 20 ++++++++++++++++++--
 2 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index b63e60ef8990..fc202f90991b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3524,20 +3524,26 @@ static void damon_verify_merge_two_regions(
 /*
  * Merge two adjacent regions into one region
  */
-static void damon_merge_two_regions(struct damon_target *t,
-		struct damon_region *l, struct damon_region *r)
+static void damon_merge_two_regions(struct damon_ctx *ctx,
+				    struct damon_target *t,
+				    struct damon_region *l,
+				    struct damon_region *r)
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
@@ -3590,7 +3596,7 @@ static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
 			goto set_prev_continue;
 		if (damon_sz_region(prev) + damon_sz_region(r) > sz_limit)
 			goto set_prev_continue;
-		damon_merge_two_regions(t, prev, r);
+		damon_merge_two_regions(ctx, t, prev, r);
 		continue;
 set_prev_continue:
 		prev = r;
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index ef146ca2ae8a..4e380c6c5eb2 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -182,13 +182,27 @@ static void damon_test_merge_two(struct kunit *test)
 {
 	struct damon_target *t;
 	struct damon_region *r, *r2, *r3;
+	struct damon_probe *p;
+	struct damon_ctx *ctx;
 	int i;
 
+	p = damon_new_probe();
+	if (!p)
+		kunit_skip(test, "probe alloc fail");
+	ctx = damon_new_ctx();
+	if (!ctx) {
+		damon_destroy_probe(p);
+		kunit_skip(test, "context alloc fail");
+	}
+	damon_add_probe(ctx, p);
 	t = damon_new_target();
-	if (!t)
+	if (!t) {
+		damon_destroy_ctx(ctx);
 		kunit_skip(test, "target alloc fail");
+	}
 	r = damon_new_region(0, 100);
 	if (!r) {
+		damon_destroy_ctx(ctx);
 		damon_free_target(t);
 		kunit_skip(test, "region alloc fail");
 	}
@@ -198,6 +212,7 @@ static void damon_test_merge_two(struct kunit *test)
 	damon_add_region(r, t);
 	r2 = damon_new_region(100, 300);
 	if (!r2) {
+		damon_destroy_ctx(ctx);
 		damon_free_target(t);
 		kunit_skip(test, "second region alloc fail");
 	}
@@ -206,7 +221,7 @@ static void damon_test_merge_two(struct kunit *test)
 	r2->age = 21;
 	damon_add_region(r2, t);
 
-	damon_merge_two_regions(t, r, r2);
+	damon_merge_two_regions(ctx, t, r, r2);
 	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 300ul);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, 16u);
@@ -220,6 +235,7 @@ static void damon_test_merge_two(struct kunit *test)
 	}
 	KUNIT_EXPECT_EQ(test, i, 1);
 
+	damon_destroy_ctx(ctx);
 	damon_free_target(t);
 }
 
-- 
2.55.0


