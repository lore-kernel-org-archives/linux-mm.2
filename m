Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA8C6CD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 00:44:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB0DD6B008C; Thu, 14 May 2026 20:44:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A61E86B0092; Thu, 14 May 2026 20:44:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B4476B0093; Thu, 14 May 2026 20:44:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 782C86B008C
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:44:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 40F468F229
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:49 +0000 (UTC)
X-FDA: 84767809098.10.E03FA2C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id AA6F5A0004
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GCHKvhCv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778805887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h3CTyQvWWe+Cbe6RTk1H1RK2N2Bxlec9uZU5Pa3ALe8=;
	b=v932Foyg3r3Yic6iIdLnrKFXrcZCwEZTuFQMiwIt7D3xrR80OPvkbX6B8y0QJ0Vbdaj4P5
	e6zbNSGgzQ+Rn/4QqCZc8/s1BOpm2YPDI979G6VgvvSqdfkBEH9gJr+S2nkb54A55r9x+e
	WEfuqmT3iAw7nFZ2KlXS844rQyU2xYY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778805887; a=rsa-sha256;
	cv=none;
	b=17A3AsrhA8H5yqsyRJfALcqdulGOrQ236o6LoHm/7IZzOdpQv4eeb4nzkh64M/WmFtSt36
	fxMm1r5kydIS1mn805YCkyFVjBQ3Im8YEkXynOyMyQ8Vdo+LJQSQ7DSxJiIazA3BgumfzL
	BMRj2aiKTTqEYLHi1hdnFwIIXxR5mso=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GCHKvhCv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F94960583;
	Fri, 15 May 2026 00:44:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D291C2BCF6;
	Fri, 15 May 2026 00:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778805887;
	bh=qZfBkN0zGN2DLhW9VkA27Q3IfwaCqxHeg4H/ZiPWbqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GCHKvhCvGTpM/2XpsFz1lLNVSIvTRFQPOdAmbNK7MN01cdQtXR5ZBD0h8tE8hxPg/
	 e5eeICXUYEGBMhkKG1uN+8Emjzw0tNRvU8VdvlNu9dgpswm+srOShrdP5VDyu7MhDO
	 OMVKm5Z0QoMFCvbJ9mIYi3zG+tfsyMNpaRqmlpeFKKLtUetOB0C2onXBd9UvvmEcVs
	 v6jFEtyspHMeuQhhbxkuFWNfmaVOvO/fU1e5rzLi0va1S3k8Jczb4+HKaa7cN4Jk/9
	 aP3RVKJzp+mt9GhbzJystaLCMmpfPtSQ8S4GezdOLyAnkbrlDhh/Rl84NLa0KetHD7
	 l8K/14zCKqwrA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 03/28] mm/damon/core: introduce damon_filter
Date: Thu, 14 May 2026 17:44:04 -0700
Message-ID: <20260515004433.128933-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515004433.128933-1-sj@kernel.org>
References: <20260515004433.128933-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AA6F5A0004
X-Stat-Signature: n77o9kokesa9u8xaxfzgd9sttyfrqftf
X-Rspam-User: 
X-HE-Tag: 1778805887-476329
X-HE-Meta: U2FsdGVkX18zjoeH99qleNLJ5paEqm+RwC0mSCwsBCVgPPy705NNXcOt6qlG/6WqkWPX7QY+yTtfgPgP5Alm+UAmz6kr2v91/7IhHUoqZ2hqGpXOBfyuCUqQt0GoBjcs+AnR5Lrt8GDvePpUhCacexlnVxBAGE3gtvxJLCBmhTVdSifXOf7pAFCewxJXE5titAbW/TCoOqqiFNbkal98Z4rF4mkqokwH4D8neihHSkLsiS3+Rh+iQSqRioEb1665k/K4O041ML9S57EYzivJIpAjxPdNHPuKASiNEiX89Urks8aIARZeN99c8PiKP2pS424eLBuj+4pGl8P122QTtlbz3ZbvGRZk7bWFAJ++g1fYfeZCoXsK4UmN5P8HKS65SAngP0g2iYlXF2DKHy9IpPXh4KWHoZFZp+V8VBy+vkeRDD8/KKRL1dmAginBIjzPoFh0nuVmRRu4Gi62G8WG/aQ9KDHgCnEEHOTevc8bK54WS9944/aHA+bT2V1O/fiDQWb/7jJ99l27su1sXczn2DytIVZVN9Kv9ps5rRB9zMq+Bolj0+uH8oI+DXPWdQNXWpvcgkF1uZ6uKQ72+yuwv4xdEanLA07lq56XncW4cVB07M2+smbwdYHNzeAlgmWbc5eBWkjfw9nK6OVleMtZPA83RPL+N0kxn5qn7MEIyUOSCnd7zrNl7Aibm/7qgXKUmIH1uCwFKSQ9fE2XyYsJBH1WXPDrUi8wLqWLnBAFW8i1vuCtZIMpUSF/92qiKKvY1pDiagAfraHVdv0naTHb6YTzwo0YQHhm73W3r5+L43vTTTcHcldHY2TPUXD1B0O3Z1ca4fNafGuIF1B2ij01xaF8mPEBh/+LR6T3yddxJi+4w6BiCIDF18ojO+ME8IS7B2hPU7yPJdqYcs8mCkI9bnTWQMbDd6SiBKFbCtdOkpAI9bK7qdbPey8pkCBotO5xbz/sybhpPQGaD/Yo1hG
 yzXdCUEH
 wGFJK327KALquse5diytY7SIxldxK890xsdos7x5WyJdfFDn/E4CVrq4u+INWHTWeEhs4G1ywAXj+F8YEVwCj5A7BT19Vp4qYobKfv70GeTmsMiUNLQL1FEEWWCwef24g1DRd3r9A/GBq9AxP9WM9f7T+DgTvm517hRiohU4Y/IcU8vFEMVVOrCr7JdkPZv0oQPorGKZZ9EmN1Lk0KWmxPBsapHd7tzlvYSxrk4dYaZoNaiNQd/BUL70JQqNRW4sebVLmP/LN4DxR6+H+TBURSNXmxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Define a data structure for constructing damon_probe's attributes check,
namely damon_filter.  It is very similar to damos_filter but works only
for monitoring purposes.  Also embed that into damon_probe, implement
essential handling of the link, with fundamental helpers.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 36 ++++++++++++++++++++++++++++++++++++
 mm/damon/core.c       | 30 ++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 3ba5a31b51769..9c2576f103767 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -721,12 +721,38 @@ struct damon_intervals_goal {
 	unsigned long max_sample_us;
 };
 
+/**
+ * enum damon_filter_type - Type of &struct damon_filter
+ *
+ * @DAMON_FILTER_TYPE_ANON:	Anonymous pages.
+ */
+enum damon_filter_type {
+	DAMON_FILTER_TYPE_ANON,
+};
+
+/**
+ * struct damon_filter - DAMON region filter for &struct damon_probe.
+ *
+ * @type:	Type of the region.
+ * @matcing:	Whether this filter is for the type-matching ones.
+ * @allow:	Whether the @type-@matching ones should pass this filter.
+ * @list:	Siblings list.
+ */
+struct damon_filter {
+	enum damon_filter_type type;
+	bool matching;
+	bool allow;
+	struct list_head list;
+};
+
 /**
  * struct damon_probe - Data region attribute probe.
  *
+ * @filters:	Filters for assessing if a given region is for this probe.
  * @list:	Siblings list.
  */
 struct damon_probe {
+	struct list_head filters;
 	struct list_head list;
 };
 
@@ -880,6 +906,12 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
 	return r->ar.end - r->ar.start;
 }
 
+#define damon_for_each_filter(f, p) \
+	list_for_each_entry(f, &p->filters, list)
+
+#define damon_for_each_filter_safe(f, next, p) \
+	list_for_each_entry_safe(f, next, &p->filters, list)
+
 #define damon_for_each_probe(p, ctx) \
 	list_for_each_entry(p, &ctx->probes, list)
 
@@ -927,6 +959,10 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
 
 #ifdef CONFIG_DAMON
 
+struct damon_filter *damon_new_filter(enum damon_filter_type type,
+		bool matching, bool allow);
+void damon_add_filter(struct damon_probe *probe, struct damon_filter *f);
+
 struct damon_probe *damon_new_probe(void);
 void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 0e55fa70fa5b6..44943d654dcce 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -109,6 +109,31 @@ int damon_select_ops(struct damon_ctx *ctx, enum damon_ops_id id)
 	return err;
 }
 
+struct damon_filter *damon_new_filter(enum damon_filter_type type,
+		bool matching, bool allow)
+{
+	struct damon_filter *filter;
+
+	filter = kmalloc_obj(*filter);
+	if (!filter)
+		return NULL;
+	filter->type = type;
+	filter->matching = matching;
+	filter->allow = allow;
+	INIT_LIST_HEAD(&filter->list);
+	return filter;
+}
+
+void damon_add_filter(struct damon_probe *p, struct damon_filter *f)
+{
+	list_add_tail(&f->list, &p->filters);
+}
+
+static void damon_free_filter(struct damon_filter *f)
+{
+	kfree(f);
+}
+
 struct damon_probe *damon_new_probe(void)
 {
 	struct damon_probe *p;
@@ -116,6 +141,7 @@ struct damon_probe *damon_new_probe(void)
 	p = kmalloc_obj(*p);
 	if (!p)
 		return NULL;
+	INIT_LIST_HEAD(&p->filters);
 	INIT_LIST_HEAD(&p->list);
 	return p;
 }
@@ -132,6 +158,10 @@ static void damon_del_probe(struct damon_probe *p)
 
 static void damon_free_probe(struct damon_probe *p)
 {
+	struct damon_filter *f, *next;
+
+	damon_for_each_filter_safe(f, next, p)
+		damon_free_filter(f);
 	kfree(p);
 }
 
-- 
2.47.3

