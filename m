Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C7B7CD4F3C
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:37:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAB326B0092; Sat, 16 May 2026 14:37:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFB906B0093; Sat, 16 May 2026 14:37:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9C766B0095; Sat, 16 May 2026 14:37:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 89A0C6B0092
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:37:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4F4081403F9
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:28 +0000 (UTC)
X-FDA: 84774140976.07.95371DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9072840011
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bw6wvPQL;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778956646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a9SY8AMyGtlTpaI0ovWPuJ/UVNtki2q6SfKewXhffqw=;
	b=JHhtWfDaJQlva5ddp4ggUbSo2D5AzIIH/nHggmnFERO1E5bnWNM9nmkbOGh9R+jpwPoHQi
	HhwEns3WOGDnygxkuu5zy77uRHyt2dnsLvZVh7KL1W7tekfoIA0RxVAZkL08OKZAtzUl7i
	ts0DwmfpG4xMhy86YmcpLAzipFc6n/0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bw6wvPQL;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778956646; a=rsa-sha256;
	cv=none;
	b=3S6T+kQU6Zamnb6K5KPR8ORsmEaRLJy46Ra/pF3227v60aaSkWOhWfw3yix7syKgb/nOEy
	m8Z9hUDPDzkbqkcgshkOzog3V55WYR6nWQjqA/dAb9gizquPrZ5VCts3CXU26ngwLs8ONF
	34kZlAm8Fe43wSpjebNT6gDUguH1Q5E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A730D43589;
	Sat, 16 May 2026 18:37:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BDBC2BCB8;
	Sat, 16 May 2026 18:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778956645;
	bh=9qp2MHSM8s3w0sFukfKdtDY+4dXqqo1Od1wtQQBaYpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bw6wvPQLdsJaJizOt333zj+YEXZGuQp/R+IN+ZGEEyhPIguIJLOM3+JgFBFxg+ZJd
	 0kURv5jMOCCe0Mx/2aRuuEKYYM/xxQKUqhfhwnuzOFNFUwz4xwggQ9k4IiKKy/2dZ6
	 7rdD3Iet4yMtKXu45uWakL4NFH1V7wueUvx1gQmivjJzEZ+KaMD03FywtERAVTF7E7
	 6r5yfG9OMXVlYx7ovBZwNcfxw2PeAMX3xI0O6Pj+Ee8aNtiRCE+b/BSzx+8dAiPQR9
	 VGqpHtGEZQToRKE7bSDTYpa0VcAvnjNKmwJsVGPswoDuzqX3oEbiMOSYXsZH56EdlR
	 azn6CgVwxd9Eg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 03/28] mm/damon/core: introduce damon_filter
Date: Sat, 16 May 2026 11:36:44 -0700
Message-ID: <20260516183712.81393-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516183712.81393-1-sj@kernel.org>
References: <20260516183712.81393-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qtruibfoicxkk8bih77mj7t4tpre5p9i
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9072840011
X-Rspam-User: 
X-HE-Tag: 1778956646-835977
X-HE-Meta: U2FsdGVkX1+FIstmlOW/TEYQyTHisDtpeRoT2lIdPwDcv3yUdVgBSahmoRpp7PRcUjitXx6bsXvilCnWR+XG9zJ6Co4PC4IRxdDk8t47b3iyNJeMPTxSo7W5l3SqHi0voPuGG+ijr564BzjmscD4v0db4Wx08G0K3od/qthYsxHk89cQlWR0JJNsBKCfztSUt1dxuAeJ8+dkUAOJikzWQj9GRZ1e/hN06Ugder/RGKehTm34IanM5satM0m2TLhyNahvGTQEh4Jbb+1uq1XIQc2wontujst0kBNHlB+mCjwL/qK24d/6qX0fTd433klxi9QKNWt1LkNZnzNVSyRgbVBQeo1E1yNryAt+x2mpMNGIiVu541W+sgYNrsW26UmkLVVAcvPjLo4p6JGMAIsUOh0YF3KM2KGCuAMh9+t7GWFawUr6IMGZQj/EQFva694Ax0j739/GwruBVo+c8mptBBuKJK0RuGPRZlru2maiJjje/ucaE+DNE2oDslo2Z/gisVWd0T5/3u+bpvFC+mCiNFbZgcsf9pptK/AR7gqLL35+505T1ukZQarW3VeK30b/gH5vLIChHHGd07WSJWeD0L6bXgrmN/PIjrgZp23pivBhJkclmjK93pq/jJ7EqVe3oigEA3srrCUPiLaoFm3+9YpIrwVmOy/s7cQf67QKWIaN0iUOaEEOkGmufUvbqj6mnepKtMkWUH+S/LxrGqX/TwRtj2RzBkSgm3m+acWyrz5SElDvdRD6dSWMkSOBCNn298qNbyifdk73TuzQ8dtGniqSJeAl7rVbPbqg1ZYgFG2lOx24kGIwuuCSnqHNjATt+iXZLyS2pmnWJT2eBf4jY3IwvL8fxbXzDjwM8ZX8PUZrpQmdmIeio61I84FmvO7KAfyBWd4m5EYWcXltBhMJ4phQCM3WUQoLXR9Lvk/K4jH/AiS1SZqSufcd6XLhwX4y7Fdtob6C8FKppvsbhV2
 DTMJlO8T
 XEpJMvm6AqYEsboUrud9nRy9Qvzqs/fk/g14vQXRuezRiXgNscj8yp63Rr95WJT7gtCOtz149KWsfZL53CXBMcp4qvYwXZ6s/0Mr+wcCRcE/l1e9ED0x/QTzozBbbVZHAsD6nZrfWq4MGTphEUMYpyzszmG1bF6hIQdYsf1s98Bm2H2lICXkM3IDKhCkjHFeSoppF0jffv47uT08R9r6ojkSYuzN5c/hJLYI6tEr0/TuA+Dvt/zTNVv2X5P3wdj5VuROvno9lH45i6mYU1SqCJAiiGw==
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
index d15f47a321d88..32005b8b1f8cd 100644
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
+ * @matching:	Whether this filter is for the type-matching ones.
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
+	list_for_each_entry(f, &(p)->filters, list)
+
+#define damon_for_each_filter_safe(f, next, p) \
+	list_for_each_entry_safe(f, next, &(p)->filters, list)
+
 #define damon_for_each_probe(p, ctx) \
 	list_for_each_entry(p, &(ctx)->probes, list)
 
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

