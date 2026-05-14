Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15A10CD4F42
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:09:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 722C96B0095; Thu, 14 May 2026 10:09:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E40B6B0093; Thu, 14 May 2026 10:09:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 416836B0099; Thu, 14 May 2026 10:09:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 014726B0095
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:09:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AB81D140385
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:21 +0000 (UTC)
X-FDA: 84766207722.16.5A9C9AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id E9515140002
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VVdqfGs1;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778767760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6O1VKKbnI+pwmbquNv5zllPxX59GjKxrD7NQiNJkO1E=;
	b=eNMisqbt3OboixeKE+03g4HeM//S+kzM7PbjZJ5IUiA5awdokhOFTYu4sRlJvAu1PYnDyh
	hd55BBLn2jMFeHqJUlHe/LkEm9ABIOY48V/lLNhHq+ra/eNpzfzimhjqJX2KpHc9dFDqj5
	N2zT5YMeXWNYfEma01a5uxlV6/gkxZc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VVdqfGs1;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778767760; a=rsa-sha256;
	cv=none;
	b=GIZ9GPSNjctmVcBb8fCjuqhTMR2JkzPgEqvWTeLUym8hxmw02DwgZcfSqMvKsLV+/vO/kR
	laV5dI4A1wGhlUOPXPiQef3cWRttwJqqQYxZyveSmObpRQd2sDfW46kD5GJzN9YndsBHLn
	k3mIIbVNBwufLF7YUXy0HMZ2ImaSgKM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1412A414FC;
	Thu, 14 May 2026 14:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C420AC2BCC7;
	Thu, 14 May 2026 14:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778767759;
	bh=zvNnkp+6yNBQFjvFCmCTyrnoUvo/qS1CeDP5FbHiLzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VVdqfGs1wxQksNwRWcqJuVW5ydFkI7vXR6XZMrvGdSChHcdzrXyrjNAYWHwyVJnGD
	 4SCeJ0lugvVStzzuZprTF7zEOD2SNRQja8f6kMLTNYgu93vKvc6W+j2wjawHfuF+B5
	 uWFFY9YTlmeGhCHDleDe3ihGqcdlt99CyLtWOOyrTzz/mH6W9s5pS8z83pnRVAXU7a
	 k+EMPOs019JXcJUYsYgAhP3+EWKPmkM6OpI9fh/+wbJq3mkPXpQ9Hh4DQU4+sSf2O7
	 UP1V1IJqsxbBcQS5KLzSgSvTCB9SNyNLza+YtHRYQgqNg1cz7aarKqyqT+tLBT7t8X
	 s/B1VeUFpScgA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 02/28] mm/damon/core: embed damon_probe objects in damon_ctx
Date: Thu, 14 May 2026 07:08:35 -0700
Message-ID: <20260514140904.119781-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260514140904.119781-1-sj@kernel.org>
References: <20260514140904.119781-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E9515140002
X-Stat-Signature: pf1b5n7t3jcrsxj6931pm3qh3prmta8n
X-HE-Tag: 1778767759-674862
X-HE-Meta: U2FsdGVkX180A1mCUAqY6JM42nkU2XluzvLey58ve04n2FjhoUbAKWiIRNSAB0xHeqtZlTyXzy4rN1waEdd70mVSVziBK3D/HDupji/0WNaeZuOc0JL2/TqasQFMWooW4DfBvQrfnsEarzt5NhoqILOgyW7MDtkLYu3iX+CKVNseZe+59vQJQdw8LK9r/7g4ER17KyZ6Gavv+6bx9gTTav3N7bLDVyfZXvFXbXA9U2JtmAOl6rBz2z0zzycRtZyveaE/KzbBF3SSAVuuezb4Cl5HQgWcbxx3yIRj/A5S0lnt27/unRkIuNG2xKOR8VQ/WludSdyZC4ImWpmx6GH6EMtJ38spWSR7KOHZ4r+7FbOpBls4WczcIsuB4NQn1XYnR2THjzGjEK0NuPXS4EHLIbGsPnIyPuPlGRfiUoV+/vssv0OQPUoS+BWFBfXSLObl1n1PrXSOwcatfu84v5W22yzmmthlS1pVPTTGFqx5C7aviw33hFrXhbnbxjwxT32qUkSG/dJ41xX1i7uO2zWG46BVP6+l5JLIsJiqBRe9v5CIQXJB+GarM6nNrpY2/2wMRQ+cArbMk5V+enU4AWgTd7UV98CP8Cd40bToblIp+L2VPDz4HThhoVcQ9UFUVtShY6aHwbZMiZL8+IAsx9EmtfaJzJ63WkCqzJsBL0p5EtSv6pHUQRfKIKGi2daSYajchENZSgqXvD4u7pTM6+jr5+ABhlIKOCz6vLK8F1AhyC7ML/TEHNNmTIUGMg35EHf7Gknjgzcoo+c4QP5jnJq+eHKXcg5CNsyIeTZV9R0IOslCkW77snAWsAeFiPU8OWQcBXMOT1CR/qipYkzUcaXzS6Lzq8/r36yp7S3q6j/g52Mi+cvI8qozVb3x2eYMVZVYo136iY6ZQbRrqXphHsJU+Q6m9+Mm0rrp30qcX6f0Gfl2MWjKDQWHM7IySiQRcOnFuWdNAecZou0uCvIbu3D
 oI+JNsJg
 HLa9B0prBcRVURCIdCMzm2pP8vQURfSTkk4P3iD66PojyfxULbvkl3oefDgLjM2vGfBfj7kbsLeQzO70aHWNmYiZU05P6R/KYUZAl/ww7OWk5LD0d/H+8y3aD0muoFtlOSS/we5Xk238Pgs0T65JwsaN1Y57/aLVtX9eQfG+XaotVPNN7GHF2B0tEBUK9nzwZ4+b2BAW63p0G+vYmf0Nt1U6f1i+TwDfNmwlOIx191EA3dCtE1xTLq4iZ8hwbv8XUHKfOt+kbQ1qrdBFVc3tVCLd4gQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let damon_probe objects be able to be installed on a given damon_ctx, by
adding a linked list header for storing the objects.  Add initialization
and cleanup of the new field with helper functions, too.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  9 +++++++++
 mm/damon/core.c       | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 4794931fa2ea3..dc53bc3da74b3 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -857,6 +857,7 @@ struct damon_ctx {
 
 /* public: */
 	struct damon_operations ops;
+	struct list_head probes;
 	unsigned long addr_unit;
 	unsigned long min_region_sz;
 	bool pause;
@@ -909,6 +910,11 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
 	return r->ar.end - r->ar.start;
 }
 
+#define damon_for_each_probe(p, ctx) \
+	list_for_each_entry(p, &ctx->probes, list)
+
+#define damon_for_each_probe_safe(p, next, ctx) \
+	list_for_each_entry_safe(p, next, &ctx->probes, list)
 
 #define damon_for_each_region(r, t) \
 	list_for_each_entry(r, &t->regions_list, list)
@@ -951,6 +957,9 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
 
 #ifdef CONFIG_DAMON
 
+struct damon_probe *damon_new_probe(void);
+void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
+
 struct damon_region *damon_new_region(unsigned long start, unsigned long end);
 
 /*
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3a8725e400c6b..8a55cc61d2972 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -113,6 +113,38 @@ int damon_select_ops(struct damon_ctx *ctx, enum damon_ops_id id)
 	return err;
 }
 
+struct damon_probe *damon_new_probe(void)
+{
+	struct damon_probe *p;
+
+	p = kmalloc_obj(*p);
+	if (!p)
+		return NULL;
+	INIT_LIST_HEAD(&p->list);
+	return p;
+}
+
+void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe)
+{
+	list_add_tail(&probe->list, &ctx->probes);
+}
+
+static void damon_del_probe(struct damon_probe *p)
+{
+	list_del(&p->list);
+}
+
+static void damon_free_probe(struct damon_probe *p)
+{
+	kfree(p);
+}
+
+static void damon_destroy_probe(struct damon_probe *p)
+{
+	damon_del_probe(p);
+	damon_free_probe(p);
+}
+
 #ifdef CONFIG_DAMON_DEBUG_SANITY
 static void damon_verify_new_region(unsigned long start, unsigned long end)
 {
@@ -605,6 +637,8 @@ struct damon_ctx *damon_new_ctx(void)
 	ctx->attrs.min_nr_regions = 10;
 	ctx->attrs.max_nr_regions = 1000;
 
+	INIT_LIST_HEAD(&ctx->probes);
+
 	ctx->addr_unit = 1;
 	ctx->min_region_sz = DAMON_MIN_REGION_SZ;
 
@@ -627,12 +661,16 @@ static void damon_destroy_targets(struct damon_ctx *ctx)
 void damon_destroy_ctx(struct damon_ctx *ctx)
 {
 	struct damos *s, *next_s;
+	struct damon_probe *p, *next_p;
 
 	damon_destroy_targets(ctx);
 
 	damon_for_each_scheme_safe(s, next_s, ctx)
 		damon_destroy_scheme(s);
 
+	damon_for_each_probe_safe(p, next_p, ctx)
+		damon_destroy_probe(p);
+
 	kfree(ctx);
 }
 
-- 
2.47.3

