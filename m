Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F0A7CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:41:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F4D16B00A0; Mon, 18 May 2026 19:41:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A7836B00A5; Mon, 18 May 2026 19:41:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDD3F6B00A0; Mon, 18 May 2026 19:41:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B9AB66B00A4
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:41:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8A62616180C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:27 +0000 (UTC)
X-FDA: 84782164614.01.7EFCFCF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id E130F80003
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qxLCnyTT;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wylqbKRjjctQGtcihDfbobQYEaCG9SduZfwHZs528JI=;
	b=Jtde8qdiN4m/5JbeZTjXJ5+nCb3qLXvHffE6h924CO4wQF6j1xp2evQz91eVYBaZCEWEXC
	xovTWXCfKzH7wZZ2KQMFweMYnQFhWTIbDyww54fiZG2x0gq/n3re5T3n4HiZWqjgj8jEaK
	B9wwPPdo3HzdZ1+neCEGt0ZTogHrM7w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qxLCnyTT;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147686; a=rsa-sha256;
	cv=none;
	b=Dl05fqrhLjl+R+xuyqzLSMtCGOdBE1+K17aCcNi2AMv+rmzHL/ixYVfCW+EPX7cMgMjlMZ
	oVIFTUZHvzgHbnSOgzUUuX8olWlO/ueDkTuYAqRc7wz3CxtAHKSfi44DPlydIouiW3ztcv
	BwlTLgRDertxt+UnSlXe5uel8GSe7N8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D5D844366;
	Mon, 18 May 2026 23:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC1AC2BCF5;
	Mon, 18 May 2026 23:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779147685;
	bh=bf/w6G1Oz26zbX7WatE2cZ1YXPddmn7MtSESl1T9sTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qxLCnyTT5UlEzwdnpnmd2/EeZJAcwhJjx/sgWGqm9JU+OvQA5SU8JTYEZBWjnQUy+
	 POQ7oGyTNhcIZZP3nKet9oC/IRADspR6c6pNoFC5/rkHQHMnjowDIELTYUMyhXO5IF
	 MoeaIDKEVLkgOiPJHxuNgq8/wAEK+9XK54G8LmsCdqt5tfuVYIV27eykNBfiOl42nb
	 0a9lvnbRJMwOfqRvuyoejjOz+WpgUW6bHIadbYEMG98iQMBXwWK7aIufyXXJhMQTLT
	 gmcK+Dab82FVsyC5Xx7tm8Q1uQApDxqqCfGEh6vXcjAVsGQS49c82xZ/Dxj9hVQEnc
	 RqOTn1LGiyb0A==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 03/28] mm/damon/core: introduce damon_filter
Date: Mon, 18 May 2026 16:40:51 -0700
Message-ID: <20260518234119.97569-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518234119.97569-1-sj@kernel.org>
References: <20260518234119.97569-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E130F80003
X-Rspamd-Server: rspam06
X-Stat-Signature: oh3h9s73aj8zdm114sk7jg4beum6yn4t
X-HE-Tag: 1779147685-902359
X-HE-Meta: U2FsdGVkX181A0xdFlBOOEoDiXAaps0dXg2Hd/LrYEdtHvMp4nwps6MbMxXNNaZzCfVACARgbP6kTFaGo6zFW4TAJyntJF+UtO16PToytxxforSiysZKACoOv78JhNmJY7IuOzT8fqb6ntRmXj8DxJ/1o3AJlGX8Odkh1pMnp9CA2f/7nvT6qvgjj1SGFf5EEyzNaJo1HEcalzYnMgSGPwQc0pDxGbyLhNH5ZiVesGHgMmFkSqNVrFK/5zxzd5sY96qXZejTTGUFVh2my2E2h0l9eLLTR5JBlRPHNHDDRATe8xP9obhsPwxsApC7UrxdjlR+iB6Zib3Cfo4DuUY7cP6vyohghuWSWe0MIm87uzDRkf4J/M0r4K6MN3cYkWkOT9PjOQa6wihLTXgUmVEpJgOIKP4F0PNdf4gBwApWe/PdfXawLYfh9j4j9TZ+pB3LtFG2lJ3dOY+Mb+1Ad8Z2mEmG1nFoJ09DC6D+pmiE4iU3fxGPQh+cEKDrWMMffir6plQ7MqI/3Fw9gBzEsZlOMruQN0zEI07UNc9TFwQrziPbIMTxNCfxncjFoyYPIIP23i+CQlr+fe1F5G/qFG0fs1fC+SaJElLst2oX/JWLRvnCOrVmvfJioogxVEwJbodgfnkwmCxU5nSHeENto/fgB04GgobJ8DZiWUKBrWFeLRP75v2n+Z8Q5PTUiTFd6pHYiL+zJF5eOEdU1YBKx+q6/b2CfXhbgCJkGiSU0DjSA+yR0h0runuNuI6vIKPcjwDj0qfV4my1ybZ72f2b6hvQWvd8xnqOo4h4Cpoo8QE1MkNu0jMee6BlyA7RRZt30q7mG/JNo3qq8dv7NFgGcZuSK0Uy6BRO12j8DOs/+TNK+JaDroineOosaN7mPgEu3/zYe8E4Hm/53huf4dRWhcviOqor9ahng6kV4c0FyFN3iu7owCnYsDd1izdD6bVBw2HIRusoJDmRqFB3rsaFGSb
 7281iytf
 6UFdISo1V1LMQsUxwUOT0WmwH9PvAehv5KvlDflIQhkig7hSew0k5PqtyMJjy+29o6XCAakJ4oE9tClA0y+e1mFqvmwzEM+xg+5Oyx4ibBfFQEdfe0Awl+8AbJ98kuoLJUdHaIhKrAfrYAMZbO/Z2MAPHpLoiEk8VTlt354Om5Rn8hudJx9CJh7N6JMYHxYPeCxQgX93G5xR3T/mOl1b+n+p8aYWWUzIcX/fOjwGvV14IYk3PxwyFYIyeqglRfDnrlFBVnrQCFvD8pvwvfVHS3GXgHg==
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
index 43d71eb24ccb6..f8b679dd944d9 100644
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
 
@@ -910,6 +936,12 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
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
 
@@ -957,6 +989,10 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
 
 #ifdef CONFIG_DAMON
 
+struct damon_filter *damon_new_filter(enum damon_filter_type type,
+		bool matching, bool allow);
+void damon_add_filter(struct damon_probe *probe, struct damon_filter *f);
+
 struct damon_probe *damon_new_probe(void);
 void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 6ce1b949efaa7..516368fbf1de3 100644
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

