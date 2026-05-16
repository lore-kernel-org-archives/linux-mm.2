Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C89ACD4F48
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:37:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 482D86B008C; Sat, 16 May 2026 14:37:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E5A16B0092; Sat, 16 May 2026 14:37:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FC2A6B0093; Sat, 16 May 2026 14:37:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 192706B0092
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:37:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D5DA64040E
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:27 +0000 (UTC)
X-FDA: 84774140934.18.1202F9B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2886A1C0004
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ujToEn/+";
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778956646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nf3B3L1L3xefaIg9VtcZxsaI14aRnvzV+iigNKD2Big=;
	b=UXF0m4cOMBg/5kei/Bwm74OAdlmCjfZDb/4Uru6ZBLCjDyqgr4lU7+Y4J290wDEL8ANcJR
	alz945QYEnfJA8a0vriBZmGV8g9/AYiNrYVsQT5zcBSoWfZvSZpEmcGrsOIOcpxMu3MUCP
	8QgxE2BGzGUxJ7C6vNfnC2dD6MaxPsk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ujToEn/+";
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778956646; a=rsa-sha256;
	cv=none;
	b=uqoHLzRf8+JFg4mMw/oFCirnmwo6wILwY4DdbtrojRTC0j22S9EBxZRgO1XT1ESWW9hFKy
	WkIHTbhbFuMyZXuPEosOmsYjSqSN4kisyLlJES5I6gwnNSfsp+K587gm6wCbgYODMUJR5I
	OXVJIYvabFfAoo0Yr74dnflnX8iIvnU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 43C0043CBE;
	Sat, 16 May 2026 18:37:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0673C2BCF7;
	Sat, 16 May 2026 18:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778956645;
	bh=QF0mkHpsHmEpXP/r2iX52BSaeN06R/tRwxpQFk2K61w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ujToEn/+LXPvjen4/gVH6ZC5zXTz8Ibkzx/ovnKIg4fa9H0xwX+IXApmP5lOgSkDu
	 gI6eNboEwYvso67DuClyTt2Q/8guu7qk/onDnTu5WqHZLkHzzPFoEenpIE1O5oNPC2
	 lcCuaQNKVUciOqphkvcOIaGsLGZPFqJAlKWX9mA2Nmmi6Kks2v3fvr2x+jt91a4Kac
	 Z5Q4+dv0XNQC7NalqcDZPw1VVEvVyl1U5hqEGvucfCjCeXko10dPkjF6hIyK86J8RJ
	 4UWV5jaaOeiBz+tg5HdxTtfAWQbLgz9pzLbATQ+QJikwNe13r1LrMiOwU4+TEHiozt
	 Z1VrzXpJXcHDg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 02/28] mm/damon/core: embed damon_probe objects in damon_ctx
Date: Sat, 16 May 2026 11:36:43 -0700
Message-ID: <20260516183712.81393-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516183712.81393-1-sj@kernel.org>
References: <20260516183712.81393-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2886A1C0004
X-Rspam-User: 
X-Stat-Signature: f7inw4cyf89iimddgffqkn7rp7kkomya
X-HE-Tag: 1778956645-832075
X-HE-Meta: U2FsdGVkX18XX+bLXHnUmbAu+MJuCymnOYLptIgjfdTvZnJsxYqgPHEYcjVGY6aYcyKnTxA7MYBJcCkPEYQwsKjXJjD+yNkMWJeut3CS27Ybn80MZLtfa+Vl7XhzVAUWY5+d9SJlBjYiaAZRDrAWPhbFKuc6pUTJA5pg//esPyZK7vdC/ZbgvOvKAo2IYiHCr8glELwk9YEJMl42LHpUpdIG/pVnVKlCypDPPrZB0cfAEMlpBG4w2kWYPO4Ha7nycYgErbQ6iBFREwCJ2g3/cNNH9u/gTzDzFEOQ+J061bkTqiRL13P7bDQXIf+3cFlMpcEu5+YaFqApB2hXuhNKwZOR/FDVt/o9/vXCqASW4ag9KL2g2il9jlrG+2DLsSk9U2qe2YveObkIyS01X7tlZq26s/DdwdhnSzUyewjUo0R2/SDlXSuMACaEfpmN59Z8czgHgnhxgFOSeQpKq4QNdP78rs83kBvih7Q7fiGatHLsz2S6/y9gD1gtcCoUa5bLqOeywHt0uOmrcZm2+PBPlK1OcWhSHqb0Uo3qlx90xj+ANui4t7HLGaNX54AuEyYl30h1MlSwfarF45Wnjb6tcKJLE0nZB+zrwVpzJj8yYE1aOV3VytbEwbriI4vMDL/6vul6v2TXp2OA7wtfpXRE4lSvL5FJRmWz1PgWE9siIt4uK5mF0qswYMtNdJj4tN9FzbVcEgtCx7P3tXjAm/r4o9pBrCN0IfAorIUA8IyCIMcc81hJ6yMR/JaqMq7e9jBu3FrnZrHlWdGjpi0uP6f9UMu55vYLTASBQ4xAZnBMLsVuJQxbPxWzMt/RqRm247CLhHzL01W4GEYm4DedVWF2e16j5dHiEAiciMpao6kPDwbLsedWKsCDkSDTYzgn1omNYcikvNxFoVpjgieRFGkvOd+Y427x6v8QdNvzu3wdXxHGk0KbMpJW0drDYHcwilk9A0aBINul3vqsoGO2Xrj
 f3snvdlq
 I0xmevw4x0DSrRmMd+3Uq8es5dumkZJcLgTtUl17149kiS0gQtLG8AvQb52UoXqbRjR/9Y27UGchrvN1z8nduusyiRgYY4zJpGr27Arxd2bpKrlkUT9Jq1M76Zmi9sMYZAJNc0eLI4gkOaKbyhVuNFGtnP1im9S9/k87IALpbls2Vy+3FmPoxfTyg1R6vbdQsn4CHugq528u/qm4KzPi0cv27J3ER9rNaZYeH8D65SVxvzCZYvR9b5jgcVl/rsJx22vTDDttT+Q5DdyP1454uHyXr+w==
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
index a8fff5325b010..d15f47a321d88 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -847,6 +847,7 @@ struct damon_ctx {
 
 /* public: */
 	struct damon_operations ops;
+	struct list_head probes;
 	unsigned long addr_unit;
 	unsigned long min_region_sz;
 
@@ -879,6 +880,11 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
 	return r->ar.end - r->ar.start;
 }
 
+#define damon_for_each_probe(p, ctx) \
+	list_for_each_entry(p, &(ctx)->probes, list)
+
+#define damon_for_each_probe_safe(p, next, ctx) \
+	list_for_each_entry_safe(p, next, &(ctx)->probes, list)
 
 #define damon_for_each_region(r, t) \
 	list_for_each_entry(r, &t->regions_list, list)
@@ -921,6 +927,9 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
 
 #ifdef CONFIG_DAMON
 
+struct damon_probe *damon_new_probe(void);
+void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
+
 struct damon_region *damon_new_region(unsigned long start, unsigned long end);
 
 /*
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3dbbbfdeff719..0e55fa70fa5b6 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -109,6 +109,38 @@ int damon_select_ops(struct damon_ctx *ctx, enum damon_ops_id id)
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
@@ -601,6 +633,8 @@ struct damon_ctx *damon_new_ctx(void)
 	ctx->attrs.min_nr_regions = 10;
 	ctx->attrs.max_nr_regions = 1000;
 
+	INIT_LIST_HEAD(&ctx->probes);
+
 	ctx->addr_unit = 1;
 	ctx->min_region_sz = DAMON_MIN_REGION_SZ;
 
@@ -621,12 +655,16 @@ static void damon_destroy_targets(struct damon_ctx *ctx)
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

