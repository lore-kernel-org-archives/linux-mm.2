Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B88ACD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:09:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DC256B008C; Thu, 14 May 2026 10:09:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 966026B0093; Thu, 14 May 2026 10:09:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F4B96B0096; Thu, 14 May 2026 10:09:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3628A6B0098
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:09:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EEACD8D9CE
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:21 +0000 (UTC)
X-FDA: 84766207722.27.FE0EE89
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3909EC0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XginhJKP;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778767760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YWGtfg47Se7Da40hAHGnDQn7jf9NnP4tqy+6tZ0UYZo=;
	b=nvLC0gRM5SrB/WR2GIGj8yj8qDHU+A3ll2Kp5M7j6VYF9FVt043b6qRFA9Ph3lhCegTV/2
	oIxLUOINcfUNuuvBFGDMtH+TPFHm416KmI9/G2cxKETvS3GLx4Wac90QJ+3PT79QRX3b9P
	Bv2nAy4bypPeBsFMMoc4j9JOILmHxb4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XginhJKP;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778767760; a=rsa-sha256;
	cv=none;
	b=vU+wh0fn89kZ6B6CbEoL4ZaCR0fiLyZVVPvQfFHLJTNFwgeYmFhgGBZyCd/fd2Kva9BbSz
	l9AJ44Ar7u5dUMBJaqr36yKN5gQs/tseuDkvxpbZPDQBigCgb+O/+PEOEJLrkP9ZfLKNFd
	wGIDFutP12IIuCzCViP8cAsEciTZmaY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6660A444DB;
	Thu, 14 May 2026 14:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D166C2BCF5;
	Thu, 14 May 2026 14:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778767759;
	bh=bOFWp1WguP8IVmbjiUHmaSxJjCXFrz74gfek9x1LLRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XginhJKPG2L6VcT8rP5zR3FcA0OqdZrh3UKez3tLDfENI5a4siRHiuX+eNzZwHGte
	 v5xiFd0NaaYsfbIg8xwzdoVOL2GANxW9D/MDX33CxK9Yg54fEeXXz8m9T12NPyjL51
	 5tHo+5aEHGssJyG+0rTZLvSeACGY037cQQD+OpTWYtNbpZAzNszBiAzg7W4xKzJtM0
	 fII9nUKUCdN72JiTkm5PSoPJCUqk7FdNjNDsmYjEWbJ5voSNcnwqk62BhV0Mvl5VL8
	 1LLjmINCgLHXHO24IbRrfIGHHn41i8jcbNGLsd9cv7yJ9XEE7r+723FCspsFPna+2r
	 XHlXOyiObNMvA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 03/28] mm/damon/core: introduce damon_filter
Date: Thu, 14 May 2026 07:08:36 -0700
Message-ID: <20260514140904.119781-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260514140904.119781-1-sj@kernel.org>
References: <20260514140904.119781-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3909EC0005
X-Stat-Signature: f5nnufq8oe44ggg8rn5qzp14jg7n7qeb
X-HE-Tag: 1778767760-697797
X-HE-Meta: U2FsdGVkX1/DLGxAYzCG5hC4C2B8k3Tt+ytzTF0euW0+QC867zLmpYAkJatTV1db3gtun/TFWxF17/Jw2xkT5aKX05OIoZj1bMJGOQmFRmZtzeL0Oy6x2yAerzSXTk7ZhYbOkWABTzT8gAHSQd53S7NOJ3CMkSGe09mfHjfDbKK6v6kA3NVVNMPtyOHOKQsrNS2lkRIFFHk/n4sWWrt66kNmvznzv1XV+N9ZCLiNwvuk7aT9jjXXmpq9DJRhCMBrLtdQVaxXZc6M7e7B1zItnnbQSLep6tSVKASBr4e552mvB4h4+AtEiVL2O9mEzkC08WgirHmd1AxlgtgxDlXeEto2nHAVUXHcBFMjBkv5BqKAMKgPCMq9ItLMk4emTESLrJgskD4eF7mQXh4vkAmWYHcyVClOqV3nHdQ1eLp9EZaIZLRbAx6mxLU0YW7fMkCQZtCyadt3inHLqjap2+m1QzRByAoU7ANBkqUC/YsuGNdpGkIZG2mQtwJd6AAwfOxgzkU6po2srqQBjjQQwcSEbF0cs7wDjZicQOWi0RmVqVrh+JNdAHN4/kYCjeSO+uNPAFxwPmyH1LpQKqaAu5uNEAGFjHMIJOWtDaHthuYvefvbVhyqP/XbnVrO+qaLIQZYaXV5RTnMJITrzN1k1gExAuenpW79bALkHCneCTJkbYF15JYZpqnQBnNUZNqoNHqOx1x1PIy5DLnKSiO1qqdhWieWqrNvvJbL4dJV0gjf33L1lmYNBTei6Pp0w2q2yajPDZ3qlgYPUVmjYzNjVNKNOt2rGf5rpuMSiCIFKoL2DOlIr52ZIuLGyHU3bQlH2A9jyVwW2qje0s/ZxZZH6FpCSdmSH2opZDOrD2JYPgrzVMcpmhw0vCbtCfww/3dUgR097yoABPBDruxUdJClztPiSYsWpQ1bWAehrAPDVM6nbZz46d+X1K4COh4FmQncg5yropc4Fa+tR4rxLZpifBd
 jUWeBb1+
 3tzuxOgP/KPNjQAJ8tpI5nEOIugHQwuctG2HmRkq/5KOZhFon52uxpJXLxInla04/cNwPrEZLVWbxoQ3IE2KkG9asgaOzrNeLd+covmYXC2D64iQlGzAjez55e52VuZINeC+iqsHpRQ7zpEOMYJUNqc5uNkoKnv3NJKLwCkfZUcuJNDuKnfKGZNxSGxkX/qnJP8QtLZy+5FKqZ94eYyqmvMhkjM3kC8dpSlbqXTLbgA/b1Lb1seU6iOWaUkFBZ3aLtZeQU6jsP9ROpEFFUKD+1dOSag==
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
index dc53bc3da74b3..95b2c508a63ea 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -730,12 +730,38 @@ struct damon_intervals_goal {
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
 
@@ -910,6 +936,12 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
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
 
@@ -957,6 +989,10 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
 
 #ifdef CONFIG_DAMON
 
+struct damon_filter *damon_new_filter(enum damon_filter_type type,
+		bool matching, bool allow);
+void damon_add_filter(struct damon_probe *probe, struct damon_filter *f);
+
 struct damon_probe *damon_new_probe(void);
 void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 8a55cc61d2972..d01417955a3b4 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -113,6 +113,31 @@ int damon_select_ops(struct damon_ctx *ctx, enum damon_ops_id id)
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
@@ -120,6 +145,7 @@ struct damon_probe *damon_new_probe(void)
 	p = kmalloc_obj(*p);
 	if (!p)
 		return NULL;
+	INIT_LIST_HEAD(&p->filters);
 	INIT_LIST_HEAD(&p->list);
 	return p;
 }
@@ -136,6 +162,10 @@ static void damon_del_probe(struct damon_probe *p)
 
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

