Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8DFACD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:37:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEED26B0093; Tue, 12 May 2026 10:37:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7A026B0096; Tue, 12 May 2026 10:37:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A193E6B0093; Tue, 12 May 2026 10:37:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B53F6B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:37:01 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5326D1A045C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:01 +0000 (UTC)
X-FDA: 84759019842.02.3CC6BD0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 91E59120002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:36:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CNyq5rfb;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6O1VKKbnI+pwmbquNv5zllPxX59GjKxrD7NQiNJkO1E=;
	b=qYJFtj7omWD0h3kv3itmJDnlYCPg/NyCbgb7bAdYsZAHW98DQqlv9RvW+MP7zXWUcm2cpe
	Q772y47wDP9RUG8MhqbIvavwVZVDLugHpUJXiUqAiMF7smaAP6KRrSMxUgyX7u92C1pgQU
	Ef9zIwRizWxGN+KFgvcP/ShbUN5WWJw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CNyq5rfb;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596619; a=rsa-sha256;
	cv=none;
	b=dYe9omfTntw2qXjLuiCPYpcLaa+m4TBkMq+uzTP0rgG072sIQAYWIj6kBsu3/U6nokMhiP
	dR0ttvSsy2hDJq9mnQWhump2vHPLIJfSZxPmXS7wlpuhty8vAGVvAVsWH0INmspuMNeFFE
	E2Puk5E5BLu/O/QPUtCoMHKpmYzCLpU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B1AC444A9E;
	Tue, 12 May 2026 14:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3A5C2BCFD;
	Tue, 12 May 2026 14:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778596618;
	bh=zvNnkp+6yNBQFjvFCmCTyrnoUvo/qS1CeDP5FbHiLzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CNyq5rfbKZVfqc1DB9XZ1pKACnvfOTmEVeiW63YXgyMw1dXW89CybvQRdmrglQ55n
	 YxrYuJBxxVgZbCGHdfxOTaS+4cL4gDYu1BYwjDnqEhcNMUzmXUnmu8rL5ApI1jUU4R
	 diO6iridatd4jHFtZEoPCa8ny5RaNHMJH5xtnzlI4HnOiOG4RqRb5jSUeecdPJxh7r
	 AC8mKvNdOWrsFT4f0KGSz989+AWuvM7uYMceGhd+e2hEN4hTURMZsKgVYCUnav73tq
	 W3nCOJtz1Bl7Ajeom8XXfEnY+W8V+Z1by0C9wZ543Fa9HZq1omDkmHa4ApBIiRw7qP
	 x53DFlZ53CeDw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 02/28] mm/damon/core: embed damon_probe objects in damon_ctx
Date: Tue, 12 May 2026 07:36:17 -0700
Message-ID: <20260512143645.113201-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512143645.113201-1-sj@kernel.org>
References: <20260512143645.113201-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 91E59120002
X-Stat-Signature: zhhf498sfn3m7pbmuy4f7rwcx6o3qwm7
X-HE-Tag: 1778596619-839026
X-HE-Meta: U2FsdGVkX1/i8EVf7Cph2jWLeU3Ao0h8l4wtjxLc9oqb1GKLsYuCLRxxxizVhE6Gy3YbTuDqIouWUoPwIEhidv/lG086e8U6ivTiX602yuv035C2vxqIPdonJ4L7/t9kCQYkYJdf6HICyckLsQ5m0tMXltms5Hptcz28DHFZra0LGe+K/GfzP6vPhxvu0M4d6Z50SnkyT07SsoWqoZFPyi646o+msTvgQ+O7PGFkszm8tTreSQ5296jna/StjLd/D/SXn3jHTuiO9nAQ9ENcmusrFOWdnK4v3gpVvzr9/CGHlL8KOe5pkARXwe/WazdzdAtZgf6Y4B22zT9AZo64rAepH+ACgH5YMoRQsD6covwL5WQ1WpeCsyziRd5eH1DdQ1S0Blt+sfSX5l397wSUDA32D8BuTwfPBvbIlIhy8ObcWJSpXTY+npJIV7nHDbNsuS0/aL7rxoDdxCtJx//OXwSunX0/XccmlQjV9fr51/PPG5nXy5JG686i6Whs//Q1EueZfLx2VvMSCeaKa9RrG2ccD48FfAEFCRqBqV4jnoLzVUejMolodcJZr7AdNF1aaEGNyTDgCjFN02CiQ9Po6N6BkUau/FAx3N4Kgnt8pks6hTHgBBNWPmnHTS9bkN3DdwCc+1psRWdRU1raTqfGfarBqVYD1FOPPL57vFeuFqRxxZ3ilqccAbvMliBviF1rNK4/X4YJH0+G+eLFSnJTLspJKKPW+C7rgynIkwl/GxIp4u99Ikq0RIT/gEfXerz2K8nP6QL8x1NWhlLb7CJp0XxhGCpN9qu5+RQ6p9l2mtJn3Ci4QtoMcT1JPNcLytk32s2PzV60t9AckJeksn27Og3HiYPuh1/6yGIG0xPF61uSyaQfSjqbe17wd+Tz0C1zPbEkrKcJbe8nxUzJ303LIBK0hZ2tLQwBn4PzVMMUkIAhqy/U+TNe/ocPUucMxyuAcQQc1wKsTpnF7isey50
 bOFmJOzi
 Q/Z+UijYaErhTw8LShvDZqwsdirWfxOCHFIjLEf2n+MwAmlBMDEK8ZfymlAzF3OvcRHblEcbbXqRt2rquLKgMzXu0Ozs9WUYzaH44vugnsgYpDIW/DpP/HhUGda5N5LCxXEQ74+M3Bf1QyleCLtmCyZyBrvvvseytouHURFLONYqGgOljxzXkvXIr7ruqLquP6wCjeQbXEL5vKNNPKR0/f87CYEJKlULc2pcVSKz3UM88KxzMzOLNizVcWNS/GcH0c9So/PVHzhlEYHTkn3ubfwdlvQ==
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

