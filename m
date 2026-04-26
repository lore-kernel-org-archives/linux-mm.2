Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA961FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 20:52:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9291E6B0092; Sun, 26 Apr 2026 16:52:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 900EE6B008C; Sun, 26 Apr 2026 16:52:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 816536B0095; Sun, 26 Apr 2026 16:52:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6D8B16B008C
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 16:52:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 31F451C06A8
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:38 +0000 (UTC)
X-FDA: 84701905596.16.61E3E74
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 762ED10000A
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WFUVNBJY;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777236756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LGa9Bh+dhe92o9l8M+GlIgAH2f3t8EtaVV1MYlaD77I=;
	b=X7bGH6dURfqLc5hy4Wy18cvPJMnGO6bmACDtG9d1pdLTTSvWI6IOkNejCu6J52TSa+VGxc
	wP9U38ZbKDFR/g0/33+dPD1QFmBNvriMJEDf0RLHUlPkavrbIwx+ltsbTkJ0HJhDuTMnFd
	G4bUJ0z9XYjB7+T7mgZCr7kYthFcxcc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777236756; a=rsa-sha256;
	cv=none;
	b=xzBXkVmSX4FewhspYYWKjo0igW46GMQUfsGCNARmtUrzqxYohecyJvA8YGbD0xmhCXbnVn
	hiJyyP0yjeSYZj0GNqbj0jUPdNy3C6PXIv2TZni6hufTRZyyUo98qIWyCRI8CDQrp8BcGc
	i9PXxeXXp9VLYxZCBp/pmhJWJh0EhuA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WFUVNBJY;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8965F41AE1;
	Sun, 26 Apr 2026 20:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E900C2BCC7;
	Sun, 26 Apr 2026 20:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777236755;
	bh=MBnxsMb7aVVsu9fBOqUd4whtHJLGz98akhVkcLMVfko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WFUVNBJYGo8GJ+nlSDyoHTMLKuEEuU98keMZ2AGVXQTenj6xfcYgVLnHrj2M481eC
	 dPaja58+UYFgsTShSVrUwMLM85x/A5KpstSajf5D9sSJIBmTDUVM6xJsibDDpLeyIP
	 igJwLFtVvvtx+eKwIAe8prraRVNAyGKxhq6xrluZFcfSONUjB7+De3oe2UuGq7OO9A
	 lMusAHSUv6VV+wrhE+MpGDvcMsWdwbb27qQHF5fUJP2hHa6x1MQEzjM2mtmULWI/Jb
	 jXgTWkuI3WTDBVtDQzqGYQVukL+m8LoTQhIFpXYhRHWkh2INbD4gRRTAc3rmkM60oK
	 p5ZeWbwpnPgFA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 02/19] mm/damon/core: embed damon_probe objects in damon_ctx
Date: Sun, 26 Apr 2026 13:52:03 -0700
Message-ID: <20260426205222.93895-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260426205222.93895-1-sj@kernel.org>
References: <20260426205222.93895-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 762ED10000A
X-Stat-Signature: ryirk8briksq3widsrph9t8ysg4k65n3
X-Rspam-User: 
X-HE-Tag: 1777236756-213223
X-HE-Meta: U2FsdGVkX19ePKMXnbdN9oTjnQmwuQ1xJ8yMBc9hVsRogl0kwrTqdDluFNNpp/JAjjiOYnbgfHcwJaXkARzKR4+qgEqhY/5I1HSkJLfjQ52BAj+PCSEcjTdN+INJ3++QMJ4w4lQAQ4B7NjSAzcGdxwc5RKnMlgJIIXPrBYn7dhNND5x/UJXieLqQqua3Xb0UBDprOifR7/OzUNjrpXL6FETj2SuSjwU8UFPdP/voje15VkbO+1/dzdJFa11f5i6Ik/OlORqqYZiwvHg30jx+ldkpH/XeAIdzra6EILhSH/xG+Egjw1w1rCT8jpi7Exq5scL/826hazsYXNz75htVamgXbdv/naFfc4QmhnVDb47WFZXPjayINeSq5kGmh/KQ1MY2IKT8roNt5MjMlLpweSr5AXf8DghFLUgTF/0/yLtE7PZ/O/XwGhx5lN/R197MxQpyRzrlMzO2qfj9Kdu6kw67eE/b1p+6ZqI+jMT8fpcpvZhBlb7CY3CvIh2JbGPyFfuuVQNo86NJjknUN45maTFSyylVj2X2YzOAId5bcHzdH8ArWD9e/Kb9OCgM1mcRch1/nJUAk9uCqoQ5kPvt7gRgB9az4cRdkWGynfeVwAHj+fAzY6BoQZzbKuXjZsgae2fk6MRKqCLMM0+tOjjew7b37XXHDncLSGEp75JqQoIEJABapoe9YbQKjZ/p6cBr8wIBpNCOwb6ROVWFEROTRI2wtfWGq/cE1HVnXf0AqHqOUBpGDWrCktQpKqYPj2N+TYiVDWY8/kS/eukzdKUTACPpsVlZ9yJKYh2ebHrAQpJw5mXNPaAINBAc+2cMNdWMOKbz7tv5OoG0VNhjTg/9vEwq5dVUNf8JgIlBR1EgrAlTHILQJXQVskekWY0M06quel7F5c+C18vcF13Avg80dFpTC8isIyhlpVebrxLegYeNSTXJX9a5gFD/xN30wROIyb2d6/Kqpi7HskO1bSn
 HWgi78xK
 C39gYoxoYHl4kXwZlKlVT6eXuh/FMbjiTgA2aG2XEt7ZN8lsdVKNWpGCNA7ALiXPBUVxTYRM2d2Yrjhka5sQ+cSIi5Vieuj+QnoG27NkpftSrnLoaYVC8pinI7IPMA9LJI4aOnCeyq0+r0x+kCiYiDGAoeau1kTbtPabMvxmds8YKIaMUxfKcvrNQri9yTqOPB4+HAQ7AGCrJ1MNL4bLVx3NE9Ywhdt2Hws7IzSkriBoavTF3Y7j8gAPiCam+uvnk/7ejgzWIXS9OXz3xPpZ0kgjeEw==
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
index da2f026eac725..65d7ee0a70ac0 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -859,6 +859,7 @@ struct damon_ctx {
 
 /* public: */
 	struct damon_operations ops;
+	struct list_head probes;
 	unsigned long addr_unit;
 	unsigned long min_region_sz;
 	bool pause;
@@ -892,6 +893,11 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
 	return r->ar.end - r->ar.start;
 }
 
+#define damon_for_each_probe(p, ctx) \
+	list_for_each_entry(p, &ctx->probes, list)
+
+#define damon_for_each_probe_safe(p, next, ctx) \
+	list_for_each_entry_safe(p, next, &ctx->probes, list)
 
 #define damon_for_each_region(r, t) \
 	list_for_each_entry(r, &t->regions_list, list)
@@ -934,6 +940,9 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
 
 #ifdef CONFIG_DAMON
 
+struct damon_probe *damon_new_probe(void);
+void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
+
 struct damon_region *damon_new_region(unsigned long start, unsigned long end);
 
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
diff --git a/mm/damon/core.c b/mm/damon/core.c
index f556786597c83..861ab977d1edf 100644
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
@@ -633,6 +665,8 @@ struct damon_ctx *damon_new_ctx(void)
 	ctx->attrs.min_nr_regions = 10;
 	ctx->attrs.max_nr_regions = 1000;
 
+	INIT_LIST_HEAD(&ctx->probes);
+
 	ctx->addr_unit = 1;
 	ctx->min_region_sz = DAMON_MIN_REGION_SZ;
 
@@ -653,12 +687,16 @@ static void damon_destroy_targets(struct damon_ctx *ctx)
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

