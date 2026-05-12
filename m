Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3187BCD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:37:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18D796B0095; Tue, 12 May 2026 10:37:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13F326B0096; Tue, 12 May 2026 10:37:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F21B26B0098; Tue, 12 May 2026 10:37:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D62346B0095
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:37:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9DA0AC1C5E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:01 +0000 (UTC)
X-FDA: 84759019842.24.04D4A93
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id DD53940006
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:36:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CFrwpjEX;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YWGtfg47Se7Da40hAHGnDQn7jf9NnP4tqy+6tZ0UYZo=;
	b=6DLOJjsOQ3wDB/PMDCl2lhGMMBCJ2mYqliexDcVQsxtdsmeuO/N+XpixdQ29hgPf36d4Fi
	Zsvnj8PM9cU9Km4JrpvtobnxQMXCcL7K+8b+QQCiYlc2G4n0rLInIMagAwfRFchKvIYI5J
	8+eN1UK3nhzFDxRKc0vIlPDPqWVJaZU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CFrwpjEX;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596620; a=rsa-sha256;
	cv=none;
	b=aycBZ9dKoSwhIicsNkZkpSqiTHWqPIqtj9d4eT7gHAma8UP+coNz00KcPsHp8LbDqyz6js
	OEwdF5dT0a1ccwLehgSAp6IKKfQKFZ9eliKWzTCfi996GGXj/zeA5ISoJTjKr0ouAEWGTo
	2Hg1aPocOxa4SlmbZ9pXkJ7UW9YLVsk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 126F144A94;
	Tue, 12 May 2026 14:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF48CC2BCF5;
	Tue, 12 May 2026 14:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778596618;
	bh=bOFWp1WguP8IVmbjiUHmaSxJjCXFrz74gfek9x1LLRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CFrwpjEXx3QjHpm3n3Wfpcr8jHjY5MblZBpGiSvjljRutze62QvaU1vckEVgeynfD
	 QdHyIZASpO0/iNJxNdJ+C1s8yMvWfJUSAwU/i5+8BhGlHYO9K9CCDiZZSg9CpeYTMX
	 cdGlodUVWGveioUSBm8rV4iPgBWIwvpk4Gg+T4UyclJRqquRhVWcU8plKdAwZxtSbw
	 eqYT6eqV6B6z+Lhq4BNd8P2AB5mbm9blirI5HMKQORw4XIV5rGSAyS3Hu1PzxPKcVp
	 Qp06UwYbzeiy8/UUkAh0XqR6ZvYXUKttvTOfSlKJpUW1zDZ7EhS6t3mdX+aOhWqdOz
	 BZry8gZ+Qvqzg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 03/28] mm/damon/core: introduce damon_filter
Date: Tue, 12 May 2026 07:36:18 -0700
Message-ID: <20260512143645.113201-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512143645.113201-1-sj@kernel.org>
References: <20260512143645.113201-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DD53940006
X-Stat-Signature: 7cdqkzcuyhjiipmg4yq4fzgns33kt76k
X-HE-Tag: 1778596619-706312
X-HE-Meta: U2FsdGVkX19g7f2Il7QEd+F8g7sJTQwHO1/jx1swpWrb3eOjDq0p8oaqm1HqidELwV15Ouvbqcwd5BQ0l0ntXP8t7kL3t1C5GbBdL0ervDH8Yua/EVTiFF0s2Ow2zjsN+++9hfOOPEYYOxo+12JN2kkRqZgTIad4g8MaROMA6O2ZtEi4H9dQKsdKewGtcIVkxyOa69CJ20m8PTkNh9HdPH9IJeRUytRKzrgFlC7l5+Yx7VzsoYYpd1fR9+mO3i+gZmQhE2zzw+7MGJLrP3FS8BTe5IJp13vc+kJshsLfY+aJe2/NT9oSHvNWbV7HKov0wrqgOCbeEuYpRSNO3PZiHPXYBnJp40QdUOPpZUlG4iUEmBrqhI17ooHBojXwE51XsRiQ+UzrNU5pQlPkSOa8nd1G20urxmfnC9WnUfFQ+J0nr3qXM6rHEWGcWegfpDe6Bx+hSAy5mjgK46HuFcfvvXScz8uCX+rATFsErzq5CgdOw2GJ5EJDphQ8Z/yop9njXtCj6F+Q+1qUfsf03UjiSE5RQi0LWWPDHMlToHudiO5tvTSF3nZIbV9FQnIL8gf86tCPlR+3Ql6zaI7tzbT6149N3J5ed2Q4MLhjDuqjFNHMiUIfNVmOjJa73RZ9knNJgj+5/GtcjPcSEKxIpbXsHCVV6yaah9HhI0zKzd56RYvOrQWnEHfZ4pt49mYTihtWImx9+qCZNRTJvX830tmHp8ujvW/kZ139hbuIZSLU9nboEn8QPhD64mkUBhKbHEe8FrZf+0LwifA+KsRuEoTyNoj3LJS6M+URhGfN385UdTWbK49AEimjybO4AQCtWYkNNdLH+tz5YK7sS5COhLzDCpJPFfn+mP/HxzzjyANZvYF0O4S/iAkKFi/bGLoiPuLOE6AOxG6qv9QLU7BZ22JoiMrCiZF7jO6/cCG5G6lNiPRPyA5eHaSMxEr/pdu6B65uZAjj75wFRKK4jMiEJf9
 4Ht7b3qZ
 0POkJpVfZX7GGK2wjank3XSX1PlqthDVW/oSGLPMfLnfb2rry4bUcp9nPk4m0oNvXy8dukbxWGR1Rx7KX2wMR258We3iRYjeOVzecnWsJb5IHbr0svD4U9MATuCfc7LJByyIARER9S4/VMqk8BjU1UxJocc46oAaL4Xs9zJBwXNrSZEdLNiU3PDYVDwWVl/YdanqFdcpFuY3dFHURO4DAJDd9nO51zHDSMSlpkkY9StNDCWQF6NKDf3aweSKVOAfqRGjtrj5AEj0gXoaFlDsblYOgTg==
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

