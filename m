Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BBB6C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:25:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 013F26B0184; Tue,  1 Sep 2026 09:25:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDF606B0186; Tue,  1 Sep 2026 09:25:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCD806B0187; Tue,  1 Sep 2026 09:25:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B522E6B0184
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:25:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3C7201603C0
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:19 +0000 (UTC)
X-FDA: 85165264758.08.5740458
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9B02F180005
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iwbcseoD;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788269117;
	b=QNqwjmq3yCoQ/TUG4lrtVb1AoCjWbNg0gN/fnMq4+E8rydysH3tLORmsheRDzHCuRXlDcM
	HcfOiuav9E4P+QydZcPD+gMH4MQcQqcoLRAtByN2pIpBIzgAs+NSmBevKvqg33tVoeFP5c
	7GRAxgBK4cQ8GtlUa6YkjUBDfCLnnOk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788269117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xDsh4DffQRbrA3+l3qVbLOikgSrH6WeYk4b6TXVz7Rk=;
	b=kfHmmsS9jWD9jXDOkml/quCgY9npVT41TuIHVT29uAsobzx8eBGzlVxDJs6tRQag1dpdkf
	EhQ7/aSOnwYzqfm0ItaJ2ZfTZfHXCDYXQ7jw/9eboZQpf33UqZHMRyCwGH30M54zdU7dFu
	tPEKThdCYEFdkgqSrpVmHXwBc8iBWU4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iwbcseoD;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D708442EB7;
	Tue,  1 Sep 2026 13:25:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9778E1F00A3D;
	Tue,  1 Sep 2026 13:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788269116;
	bh=xDsh4DffQRbrA3+l3qVbLOikgSrH6WeYk4b6TXVz7Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iwbcseoDJE9H3uSY+YRyMW7BS4wilTfsicxoDqMtvzgbNs1WrnDjPeb/uNQ9QIAbI
	 rBVT/tHBYRJsbW9ZaoKO7sq9pZ+mr6w/iVc0iKd/XzqUPvB8L+EcYNFb2N4Ajt7QdA
	 bWxqXngUIahnfDqddNcsiExDU3ovU1FXhiBKKHL/8gIpCsgri3NMdTjd7aJDy79fzQ
	 +NhX3fC6BcqePDgv10CXiTIz+sZxywXoQk79xhQpDRPoGGw/tX2kWhbWLcfTonCL7+
	 OX4K3Y3oj2u3DJWzbCki7n3s9CpcWc0OwNK7AVod54fzWLI2ZgA9w0il1fxbC4GYbw
	 vkFxHdU4y8vTQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v1.1 05/17] mm/damon/core: introduce damon_prep struct
Date: Tue,  1 Sep 2026 06:24:52 -0700
Message-ID: <20260901132506.99243-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901132506.99243-1-sj@kernel.org>
References: <20260901132506.99243-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9B02F180005
X-Stat-Signature: g3wwz8pf8rm66ra4agrkprz13h45boey
X-HE-Tag: 1788269117-924389
X-HE-Meta: U2FsdGVkX1+oq27sVlATvdSptJw1diE1inleXwQpc4imfV4Tyn9zGgIukQwJNimfMUkPUkV/08qqLFtMLY8MYyc2aRqelm6Vt9CZsrf7DMSwqfhfijqKJS/2LCyJiR/E/WNU8A29L4sABCIlj6SezJS6WOHrQoC1qcFzxe9zY6lDyS5xGsqMLmzYNdUMZ/IKvgDsMtz+U6mwAOBNhEnkPlC74/jjTyanPWk/YY83t0CrB4yUtIIqbTyqb8Mm6/QM7K7Hp+5TtNY8HgM/rj8bExt3kAoO4DNQ3o22LgRJJ+rNSXNEf8/lkbMq4IrJMhd4jRBTebXVzTkC5Qu9wsI0vTUPrGTfZteokjkjpc/0TPlsSw87krTLB1Bw1f0AlTaRKaocMlyICthJSNCmLvcYWbCFat4rXG/0N/fGogkYkcC3xCJhEk0JptPe4S2UVjxLZTV2EhH5NXo92iM6C5eMYIOtwY82XVGB5hXOopbTlBkiBR0EwpfaT7RNebPfJqCUejBb8kENQ7QmlY59cOF+smuXjqqAczlqLaX3/qmF2t8He/iWrukCRcQf7MJ31eiH1YO+6g2UsaX7taqlZRgK1Sg1SNQwB+nce47p765KItYxbRyG1J0gnMUzaBP0GiiwM78xx225jFLLcmKgaIvyoztNEznwmm91Ke/RThZZ1IyYAM0O//le7rPjAke8Gi2fMGc4gTdv829be6wo6s0rpcmXwVm7b2oQNtQgBnJjMWlnI8Z9a7MTOi3iFz4j9Z3ZQbJVjLcm8L2aQnFdY4Q3HTUjj7e0QChdSXHyeoU/io7L/Zqt1h8tImkht8DO70OqVjxER16zQvIDF4U4qWe9tYk4M92leh5N58PKIrAStoQiw9Lo9XZK96wzJqvL5JWmdygZM9OJ7SzhyFzk7/nQp9EB3SlSi45i/p6r50WSA3eBtT2hqgFUbo0G1Au+fO948ayjlC2p41o5jPYLw+c
 SnXw07Gi
 qiXs7lCu0wgJ6gNxHVAtswxwroI90sSD7sGR62gnUlisRv+8zni1e/8KQAwP0wr17vKseh74sGH9ZzfuI7+yUs2LBZpX2hABtDzJdDXzDX3jQyQflJ2k6PCciea3lkX5ALYcAXx1iR0ISX4q881clkamRFrrfrMvBvVTJm/E3UuIBJSL97Y51Kvnj/q0qlA4wobZQgq2JGSAJEw+9p6g71AdvCX1O1kJfrlmFCc4yL24UXq2O6GzV8DH0lmzsZB7D1WLG45SpekS1kAYHpLXkqFKu7Q==
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

