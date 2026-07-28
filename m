Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1186C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 04:13:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A81D6B0099; Tue, 28 Jul 2026 00:12:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 273C36B009E; Tue, 28 Jul 2026 00:12:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C5F36B009B; Tue, 28 Jul 2026 00:12:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C82956B0098
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 00:12:56 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 38AF28025D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:56 +0000 (UTC)
X-FDA: 85036864752.20.12BA4A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9514780006
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IAu2gUtM;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785211974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JiT6YkyM91o+wfLZyKXVvhUm3iaw44e2nwGQI7u5HEc=;
	b=KF7A5kHpETftnyGFinAcuPfVIyl4VQU/iA+kFXpSlET83wUtwEOcgHEwqrvJJD6CjB7+oL
	D+Ghh2fCtJPSwlTD/sh/IKS3o4qU3EqvH/5wxtc9nPDO2a6uFndaf/5LT21Q+v5FYIyfPv
	VQ6fUfdRKHR0q0bkmD88DMd6KBvc2uw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785211974;
	b=Xx6zvtmtxjAA/0PQsaZ/peLJGDNgJINcJQaCtBL1ciR/GLHql1rW9KRNkgeU87K57k/MDv
	FuJfzlRmL0kfSUaMxTDvnV83rsWnLJDQRYOocWUT9kdfHnbwe/1XQ6Ww9cApZGdJWikwEl
	D82F8hUDi41T6GhrUNHZlEzXpIJpo9g=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IAu2gUtM;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E851A43E7D;
	Tue, 28 Jul 2026 04:12:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45031F00AC4;
	Tue, 28 Jul 2026 04:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785211973;
	bh=JiT6YkyM91o+wfLZyKXVvhUm3iaw44e2nwGQI7u5HEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IAu2gUtMxuixtVF+yqtJAvsAOKxhe/qiXOtn0Gvsc1//PS7wsTquGQycvLlJZLfkV
	 sJFLbiI/wDG2gNea70eTR49L7Dj1Slhh0Bdnb7T+fFW5UkOGnUGahboYyiWGDjGDwl
	 gpRorHJ+EtIhxmm1xVhNhnZmxgiY9PGF4RzJnWfIzUUtRpD4yz2iD16gJDUpSvS2cr
	 9CX1Bwxkt7uggYITKa+9g3qAk5vsjE1FItnOUWeQFXi2DoUAWHRLCes0yOoQmdPlpX
	 /IE0nq7bzSNk7UiTebxG4qZ1UqCIAZ/dHmxeFKeF/3OSac4pLFMYMmut/WxwobLZCp
	 07+uxHCwV3PHw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 05/17] mm/damon/core: introduce damon_prep struct
Date: Mon, 27 Jul 2026 21:12:26 -0700
Message-ID: <20260728041242.187380-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728041242.187380-1-sj@kernel.org>
References: <20260728041242.187380-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8mbasg3ywabsgmy98tot634afday1bdb
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9514780006
X-HE-Tag: 1785211974-122212
X-HE-Meta: U2FsdGVkX1/wjtyofwH3oVWUa7PXY5MCbcynKduXYejxLfKnncztvmJ1UvKscwv56HE79R6Gb/a1kL2w29AFGFrGlrKxZqbHuvBoU2tMm9xFHHvMN7LX7RSYrQRqQ+HWmOGKLnGKFQY517mKOAZ6HckuoUK36yau44BV7tdoAl0uOEN40X7ES+I3DFC1HmCTisu2egnsaRlZgK1jyFziS9pidlH4g3nnbIbc0/9AN9xsYVe01gL10Mm0Iez1aUK4qjwT7si4DMfHg7OxhcKrB+jV4+Z2lh7oUYiQCQKAXpEacTuvbDIeyX+j90u9q5CgsDsMurWkRHeGYvUBFFxln7nJowZBMaoatJkB8GYCA9kKYxp8EGLk++sbNzLBIs8Jx1VcSK4T2660SHQlLPHNcU1HsuVLAyAz4mAjCIVzSQbmmTJGrjei6JEbrxthHZ2Zh6I/+feISXPyECcMbShOhx3Mor7VnVeXb4RXD33SKiWzo+pXGFs7hYGLbgJfkadKs8XrDoWjhQgATyWqQl8Hp9fm03HBaqNsAznQIjOghAo9qSvZVrxiY6I2yEEb6m0ndCMqHmGpbjEqEivkvQLGrWExJVJufAMLtA1oX8CWDQt/iKnelP+F7YJ+/w0NvsHJKhhhnRi/UUw11UxlFDtuuEbqPm7sG1OEjhkMn7QA8kepIKwpCoTeuQ6xHDkz9/duxHac1v4l0r1ZaELqzC0d1Wl9vBfzrY3Lu/TPOZvdoO+6T03pDDP6qfJ6581TFkGcZSOvwaV0BueQwJJX7dEeyM6IYoz9Q6pqOQ+Bl7hMtzM8VdSbv6wU8ovMeMYGZBf4GN1xr5uCkDI4cHWNk4EOyvS6mcDg8wyVvSuARLFYyV920j83SMGtPXSTYJNh+U3dL4FcsA7hx6gUPHWO1Zr9N95wjIVE2SENzexyZ3eCfuNKBwVBI/i/wTkmARo/tIibeP8UvJplCcG1L40XEoy
 IOS6dPk1
 aW4XJGr8JRwKhjEGJGs8rEeAjkuX3RmmekQNGUXc6k2z7pLI1H6BAmwxw2ZF8eABW+1oKU8qVU7thaUs7r8If6mGhDCiz1ZeWnqYH1H0kzF0jtBMfUKxYws8HnbwtTYXEBzSKVTenk5af39y1Jbl2DkZ+/9OTq2tf4/UUVMTSdI9xSCyqF41/CaZ9LZueK+R7O2PPCLdaIyCif7rw0bfnNaXBl56/RoYf3aNf0+25+rIp1iBrBrhj7p98sCNM6UDegf/5AVsMsrai1v/9XSW4IyHC5w==
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
index cee4b74761081..b86744642c9d3 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -741,6 +741,27 @@ struct damon_intervals_goal {
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
@@ -782,6 +803,8 @@ struct damon_filter {
 struct damon_probe {
 	unsigned int weight;
 /* private: */
+	/* Preparation actions to apply to each probing memory. */
+	struct list_head preps;
 	/* Filters for assessing if a given region is for this probe. */
 	struct list_head filters;
 	/* Siblings list. */
@@ -961,6 +984,12 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
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
 
@@ -1014,6 +1043,9 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
 
 #ifdef CONFIG_DAMON
 
+struct damon_prep *damon_new_prep(enum damon_prep_action action);
+void damon_add_prep(struct damon_probe *p, struct damon_prep *prep);
+
 struct damon_filter *damon_new_filter(enum damon_filter_type type,
 		bool matching, bool allow);
 void damon_add_filter(struct damon_probe *probe, struct damon_filter *f);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3632b06f1db58..e8b5e6e43f9d4 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -111,6 +111,28 @@ int damon_select_ops(struct damon_ctx *ctx, enum damon_ops_id id)
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
@@ -167,6 +189,7 @@ struct damon_probe *damon_new_probe(void)
 	if (!p)
 		return NULL;
 	p->weight = 0;
+	INIT_LIST_HEAD(&p->preps);
 	INIT_LIST_HEAD(&p->filters);
 	INIT_LIST_HEAD(&p->list);
 	return p;
@@ -184,8 +207,11 @@ static void damon_del_probe(struct damon_probe *p)
 
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

