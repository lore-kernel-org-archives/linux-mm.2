Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F101AC624CE
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 04:34:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBA746B00E8; Tue,  1 Sep 2026 00:34:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0E626B00F0; Tue,  1 Sep 2026 00:34:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B766A6B00E8; Tue,  1 Sep 2026 00:34:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F9B26B00E8
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:34:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CBD6E802A5
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:29 +0000 (UTC)
X-FDA: 85163927058.07.115A9D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 334FF160006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kpcWyOAN;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788237268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xDsh4DffQRbrA3+l3qVbLOikgSrH6WeYk4b6TXVz7Rk=;
	b=BQyZNrgqo+81ip1wpD2HlyXxUbv06Y/8iy2chJt+tR/0vz7RqfTewMQ5JmE2gFhgh6p8E6
	7W9GRDGDs3MTrOFVJ72VXz4i9xj3tY0cYE+rvJvDs7/vx/rY1PaMjwCZy8UP4cBouDwqAz
	yEUFJEyAZRJT4f3XADEjXnwbmW6Dtlo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788237268;
	b=pnyM1GsfV6oH+ecN6J/F3QGjUX2Kh+FMKJ4KMWU99KLl29/soriON1AHjb6LleZeryv1/4
	SeobI26vba1y8JDRy7N/izuLhnhqlkmZF+Z2Aha+H4SvHT/BalaGZx6thW991y6lky5ZFn
	zjJN4zqhSfLiLLAPDJ+gEhH9VIj6ZsU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kpcWyOAN;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F83840144;
	Tue,  1 Sep 2026 04:34:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F48A1F000E9;
	Tue,  1 Sep 2026 04:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788237267;
	bh=xDsh4DffQRbrA3+l3qVbLOikgSrH6WeYk4b6TXVz7Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kpcWyOANd2C9UyiEEq20jHtCu1I241GxdMY3ac9mT0fSF/WXG3sDspeQ2tsk9C4Sn
	 cfRZGdcbL3dUKtJwS38OC+2KqCVKJSYQmxXp7DMljtgzmlsIccM9FOae7j2dy8yzNb
	 lP9tDCzo7orLFclV+Lk2omL0EMrNb+zcf8FAfNo6rBbvWy8ijcgbczTNXeG2G9CCeH
	 6fn+UcCGDIuN1WznmG39Tx4bI8SFcT+jCt4H9QDkVbQGD+n9Zn9UFfeP0Svf3bmDnH
	 anlRo3WrMLxkzTYEKQphIwXy4O2jTiPL1MUibensFsklYrFCDhXhO5xORm4SwDBnpa
	 Owluaz4yAioag==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 05/17] mm/damon/core: introduce damon_prep struct
Date: Mon, 31 Aug 2026 21:34:01 -0700
Message-ID: <20260901043417.2165-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901043417.2165-1-sj@kernel.org>
References: <20260901043417.2165-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 334FF160006
X-Stat-Signature: texqk4m7y6hsjj6d1sr1qcwztqmr8upk
X-HE-Tag: 1788237268-690607
X-HE-Meta: U2FsdGVkX1/oOs329dOjRG51oVgbUW/5dZ3qK6bS2RV7KO+hqhq0YknyWgWFmPJfR4PmcARu+jtgO+wNufT+/VACXj0Em8eNh14jqamn/gRw0PSbCHVHMnZM8VJwQ6tKA4BtYFDrcRFN0LQiIVukH2Nsh7w2qiMfq3Y7vOZZpI1MKLKkYeERPRQ5A771NE4NPucDiGs34gJFjXHe96WDn9l3IS/tRFp1zwASrQbPoXBCRgZOql2Tzyt/0EeyDCyWXghDSP4l/7uxNwdPDmBnqm3LZ1/Ng6OxIxzhZjLoztJwFRYhLZvMQY6xWnLObm3bEvd0SL/08zPJBRc4KfWZR5xkOPZaj4JD3+iLVdR4an0dfng/VABn2pB+9SQ1e8GLlxo8QvGffmW45mCF9yD1L6Jt0cchjbxwUcZ8kmp2AYjr8YV7hkg/jaZ7mQVC00MBmI39TJ9t3YoNl653bFTWOpwC+cmRB3KKmGN2Ae4C7Brs/dHnPAlvGV4beU/OUvhjZ6IcgOY/Mi0Emoi3AoOY8FZx9EOz4RUN0irbJEEZbl5oFoWyAAHOTlT6G8KKygS+yL28eD9Vv+zTrQA8ZdjLc7ERMg+gtjANuveVeUH3QHTgUn2rxUkJoOe5LDUCMdj21hmioViKudNUJqwJf3KVqYhQ9biR8daWKfO6dCntN7Ofje+A+QqwuX6KAazg+26Du5uxn3Oaj1uZgFda04nOuxDWyT+WyUQQMqfumdvXS7M5DgnjaZaI0S9SRhe++o2GY1DExIZCybB7Be2XfS6YeEXvzt7rusSGdiGZsYADGbz0nawWyOsXnmOdas0jlgFGGjYcLsRhPcmph/JHNcWX1gTr9+40i7gnW+QNKw3dkPVN4sw/FjFMq2ck5mSUOLMYdcBwzasKEmkfwnKThlIub2HUbWY29JaYCkpvWBRwKcY+xKV7eEAFGXvWlJ9EGeo00vVR1Iyv+xazCnfSPfh
 OAaXHwtR
 sUrFFAj33Ym1BxJbXbl99M7gdPttB5Po7awlbIEyTP5fShKUJ/oaytwgW2vonDBFvDatvL1Q2WwQheU8FD1d9S5VuFKWmahbrO6IXy3OHIzrroEOxOjFAeMVLKzh/ieRZaAHrEeeVZL3ensYyDRYoTlqY54g/QHj4PwKV974y3FGwjaapARmzQEPDUKOGRvp+n7k7JTASjmEAcOF85E+MzNcz9BUceoj5DG/osB0UGdvXAZVco0ySPhP+dSI8nl/37l4gwp3XY5UxXW04cBvWY/8E7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some DAMON probe filter types require preparatory actions.  For example,
pgilde_unset probe filter can say if the page was accessed but when.  To
answer the second question, the PG_Idle flag should be set at a specific
time.  It can make life much easier if DAMON can do such preparatory
actions.  Introduce a new data type called damon_prep.  It specifies
each of the preparation actions for each probe.  DAMON will execute the
action for each region per sampling interval, like it clears page table
accessed bits and unsets PG_Idle flag for access monitoring.

Also introduce DAMON_PREP_SET_PGIDLE as the initial prep action.  As the
name says, it will do exactly what DAMON was doing as the preparation
action for the access monitoring.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 32 ++++++++++++++++++++++++++++++++
 mm/damon/core.c       | 26 ++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 7a42cbe791845..1780c14942e63 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -742,6 +742,27 @@ struct damon_intervals_goal {
 	unsigned long max_sample_us;
 };
 
+/**
+ * enum damon_prep_action - DAMON probing preparation action.
+ *
+ * @DAMON_PREP_SET_PGIDLE:	Set the probing memory as idle page.
+ */
+enum damon_prep_action {
+	DAMON_PREP_SET_PGIDLE,
+};
+
+/**
+ * struct damon_prep - DAMON probing preparation request.
+ *
+ * @action:	Action to do to the probing memory for the preparation.
+ */
+struct damon_prep {
+	enum damon_prep_action action;
+/* private: */
+	/* siblings list. */
+	struct list_head list;
+};
+
 /**
  * enum damon_filter_type - Type of &struct damon_filter
  *
@@ -783,6 +804,8 @@ struct damon_filter {
 struct damon_probe {
 	unsigned int weight;
 /* private: */
+	/* Preparation actions to apply to each probing memory. */
+	struct list_head preps;
 	/* Filters for assessing if a given region is for this probe. */
 	struct list_head filters;
 	/* Siblings list. */
@@ -962,6 +985,12 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
 	return r->ar.end - r->ar.start;
 }
 
+#define damon_for_each_prep(p, probe) \
+	list_for_each_entry(p, &(probe)->preps, list)
+
+#define damon_for_each_prep_safe(p, next, probe) \
+	list_for_each_entry_safe(p, next, &(probe)->preps, list)
+
 #define damon_for_each_filter(f, p) \
 	list_for_each_entry(f, &(p)->filters, list)
 
@@ -1015,6 +1044,9 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
 
 #ifdef CONFIG_DAMON
 
+struct damon_prep *damon_new_prep(enum damon_prep_action action);
+void damon_add_prep(struct damon_probe *p, struct damon_prep *prep);
+
 struct damon_filter *damon_new_filter(enum damon_filter_type type,
 		bool matching, bool allow);
 void damon_add_filter(struct damon_probe *probe, struct damon_filter *f);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 53c3f97e3f126..85774dbca64b8 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -112,6 +112,28 @@ int damon_select_ops(struct damon_ctx *ctx, enum damon_ops_id id)
 	return err;
 }
 
+struct damon_prep *damon_new_prep(enum damon_prep_action action)
+{
+	struct damon_prep *prep;
+
+	prep = kmalloc_obj(*prep);
+	if (!prep)
+		return NULL;
+	prep->action = action;
+	INIT_LIST_HEAD(&prep->list);
+	return prep;
+}
+
+void damon_add_prep(struct damon_probe *p, struct damon_prep *prep)
+{
+	list_add_tail(&prep->list, &p->preps);
+}
+
+static void damon_free_prep(struct damon_prep *p)
+{
+	kfree(p);
+}
+
 struct damon_filter *damon_new_filter(enum damon_filter_type type,
 		bool matching, bool allow)
 {
@@ -168,6 +190,7 @@ struct damon_probe *damon_new_probe(void)
 	if (!p)
 		return NULL;
 	p->weight = 0;
+	INIT_LIST_HEAD(&p->preps);
 	INIT_LIST_HEAD(&p->filters);
 	INIT_LIST_HEAD(&p->list);
 	return p;
@@ -185,8 +208,11 @@ static void damon_del_probe(struct damon_probe *p)
 
 static void damon_free_probe(struct damon_probe *p)
 {
+	struct damon_prep *prep, *prep_next;
 	struct damon_filter *f, *next;
 
+	damon_for_each_prep_safe(prep, prep_next, p)
+		damon_free_prep(prep);
 	damon_for_each_filter_safe(f, next, p)
 		damon_free_filter(f);
 	kfree(p);
-- 
2.47.3

