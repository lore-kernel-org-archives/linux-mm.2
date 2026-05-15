Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4593CCD4F39
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 00:44:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C26D6B008A; Thu, 14 May 2026 20:44:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 299A26B0092; Thu, 14 May 2026 20:44:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14C1F6B008A; Thu, 14 May 2026 20:44:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ED9A96B008A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:44:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B504B1C0642
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:48 +0000 (UTC)
X-FDA: 84767809056.12.6BC0DED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id D931DC0003
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f9IAxz97;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778805887; a=rsa-sha256;
	cv=none;
	b=yWk9v081ncYFst54QKescyokEc/aicNJUMntk90SGOy971pdCZSmJQHJZ4tQd6Xl03u9SB
	mUa2xay1uLwYaBF1uhpA1K6bjLEbI9lLKooG4jcbTUQja40fSsFa+G/Cqo3JA/eHLMfxi0
	87MavMH41K5mFfOvkNsJWo/vecYNkkE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f9IAxz97;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778805887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C8/5T+isptWq4Nutme7XRRR+B1BuZKffbUH7g0Q10iQ=;
	b=ARCnjdYbJxVBThPfuQgQisDADz7aH/0qbpc62E0v2LXtJz4NWTZiQjD0g+qcvj7WSRJgho
	qtMg5lpVmLELFrWosFZWliMlOILOPCxrupaJDbklRLG2n+wNZll82LT4vyiyKXVRVYfWNu
	5iSBiKqK6dj+7ddQJBLMoVsTM0ZUfNY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2147B44704;
	Fri, 15 May 2026 00:44:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5301BC2BCB3;
	Fri, 15 May 2026 00:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778805886;
	bh=01iJIEtk8jxRwVFE50bS/u85msL+GIHF9+n6SYfgnN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f9IAxz9732L+u2X9kM2t69E546JI98VBHv0tsyapmY9RJYt/jVZV7oev1lQPmg1Nx
	 XeC23/5wRZ0RuVW0bj6kI73EKTbOMKkT0PQ2OoJzKnQAqrqdoAEW3FKHoDk8Yl660E
	 x4jDmpOurHwpT70ZQug1LjqszY8spxtHjFb6WM8kuSXHUq8xbySEjzy56ajGUKALb0
	 6yy1WX77ObnEJwQ6u+9GNCh9dpva4aMcbME2LVPKfr1+MgnlgSzv2Srm/gAR+vhfjT
	 8YoTBGUyhBHvda2d+dI7OZB+Ix+mfBwjkcLMqMCGOKQ3RPEyyh7+4eNuIwDCMdRo8x
	 Us0S36xE6pTpQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 02/28] mm/damon/core: embed damon_probe objects in damon_ctx
Date: Thu, 14 May 2026 17:44:03 -0700
Message-ID: <20260515004433.128933-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515004433.128933-1-sj@kernel.org>
References: <20260515004433.128933-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ent1ntczi8zippttj9eocpjepbcbdzy9
X-Rspam-User: 
X-Rspamd-Queue-Id: D931DC0003
X-Rspamd-Server: rspam07
X-HE-Tag: 1778805886-948014
X-HE-Meta: U2FsdGVkX1/Rmrg1GTaIl5QIOjvKTF2TRqVD67SXviO1R29FlyKBuRZOrcmOmbCfM0GSzGPU3WkCHHm89DbuQWp+yB7gtflexjqe0cbiuxz/iAu2tVTYU2H1GD+uPviPvwO/MAqtJbCJbc9+gY94kHykny7Rk+LNeLdCCjOp7G+fpp6AusN/jKv1DbdMgsLlrggU7ePz8069KAxwPUmGJV7taibHLyDNu6172srm6+hNVqih+dRN50jk9P6Lw5AA8I4X4giBU6qzoxqRHCW5uVfG/3k4dNUIcDDKMCHD7z1QfiPy4qH/W1foK+YES29aHXhclPTRdcVyQEYUWb42lXfnmlV6900AvlelkHAt3Lp/j0w35YcNxzqysiKXjGN2tp3Po+xtigId8frUtqCLqFvxJOpIR4/L0bwZMLDX9DkJh5QPUHJ86gJ1HiEeNnr8L2sdiYyIzuL7Wwf9ayyXMjxa8hpkiENVh2I4YzAbUmJHsUGa1Wqve6TI3oukUhBytcnAp5A4OioZH/dYIum9Dut9UnXUOt+38pMb/g1DSCW8rQLX6HQf0e2NLMat8IKD5IDYJdrwNpN8mzlBmw/YCVCXAtVdxyZK7m5T4kf6kbyj1vuA2RZjeAlFWlpmJd9ZyLztNYMH71XRkErpt+cYAPXd9N7+TibP8DieY37R9x87dxv6JZdBgPJFE+osQ0690raBaMqhTDDZqr8KZ6ErqBnzTDZwyDY3CnkrXo8NKfBdBefNfQw5co87py5kI12nfkuR3R3nyw0MgXjn9ZOPzrDpzsMllb+2TzGb7GSeJx71N6kEMN/hPftauGEZTMMM4KCnszRHTKyOVDiEubBLqwJN+EMtOxiVn0kWvpGssUf6VgMVGHmnJWb0xYbHvCuWlauK3dJMyQyAgOEkVyHvBz95j71h7sL9lI+5euamlzGH6SuS8UV4Ejb4ujkmj1Ios7i+5HOBqNYLhsjjeWZ
 4QntTgkz
 f6KeH+TPQpJDstGMHsBL9vc1+TTz/mawVxYmu7WIsFoWioVpQNoKgWvXEMemdMmTUo686eyF7LtOLz61vyACcsWgVdqjrZ7rb7g256+LFVCaAN9P7zOY10DR9iVtnwxq34fQOhLKl6lOquFvYYYc1TxQp+rgzGZNzSaeGpjvNqwaemJLLLQWm6/HNHPM930MlnQRHp1c5mrgk3Fxwc8A3H0uO/CEaFL0RkmDaCKgrFXIPgQ5HrRDtqLo5UW4MLZwOXBucEACwmh9z8JnH2fmGaGl5/w==
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
index a8fff5325b010..3ba5a31b51769 100644
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
+	list_for_each_entry(p, &ctx->probes, list)
+
+#define damon_for_each_probe_safe(p, next, ctx) \
+	list_for_each_entry_safe(p, next, &ctx->probes, list)
 
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

