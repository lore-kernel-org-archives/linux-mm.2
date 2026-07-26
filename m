Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E77DC531F9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 17:40:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DED16B0095; Sun, 26 Jul 2026 13:39:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B6F56B0096; Sun, 26 Jul 2026 13:39:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CCED6B0098; Sun, 26 Jul 2026 13:39:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3EBD96B0095
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 13:39:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8FD351C0CA4
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:48 +0000 (UTC)
X-FDA: 85031640456.28.66F7539
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id E0A5740002
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YUq4OHmU;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785087587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vA1pWiT60A2Sjmy1IPxMrwPYIsPuAFR2O+VHNv6q4bA=;
	b=6wzCnMwlv9Rrl7XtERyJm+jW22FGjPLZhK5zXdg6aHwzdL6zPyXtaRC92IRoxltPtMqa6Z
	AfqMI6dsxQOaxhmIkd/c4br0zzMOnLyAfjX75mjMqy07MNXOD0d82VVq3cRNbBAymeWV5w
	OepwW+/4IktLNPLUPVrhrO6ylA9BY5g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785087587;
	b=wesQmeiQU5+0D1vsFwgPmiIbjbIcl2DPScyaAgQtC8sCb33b0zWwQCYpGvyxsOfEyL/pT3
	QX4eVgEle+QGiDLpf0usj5HrWvM+TCpi7I9+UivMsvBcSdoQluvzzRzIF3dH2kvJIRZm4q
	YxP3M04079B18mJW+e3bT1FaibnDHlM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YUq4OHmU;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 433CE45148;
	Sun, 26 Jul 2026 17:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED52C1F000E9;
	Sun, 26 Jul 2026 17:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785087586;
	bh=vA1pWiT60A2Sjmy1IPxMrwPYIsPuAFR2O+VHNv6q4bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YUq4OHmUTQCdSYrB/KWNSjzdEckIpS0QhuOSAqLFiZPJVozJMfEJgc+hNFJ50Prsg
	 SoooqX4Y3dJ3DiAeMY7eaIpe+1sqPCFVofjLkHtYQ05U+GCmCpoP7C5NjXbNOeurkf
	 cwEYYCr/JCTdHdXoUWkMfxk7/hioIOrfziL7d4LA1Rn9grHKUAOVpUGZ/Cj5CnRrs2
	 6aMUbNAI+puutijacp1QvuwBly5D93Y9XI8k/WDC1swxHD3hQDYBi3XCduta+hlwZT
	 7TNIo+5fEjS1dQkZa1pjYepG8oSSZtHsMNhaWp++nNCeGjePm88zteyZ+iXOfKFzoO
	 Kf1K/NkA3seQA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 05/17] mm/damon/core: introduce damon_prep struct
Date: Sun, 26 Jul 2026 10:39:21 -0700
Message-ID: <20260726173935.94046-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260726173935.94046-1-sj@kernel.org>
References: <20260726173935.94046-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E0A5740002
X-Stat-Signature: 38x7pckcnbjk1o3k7chp5wbox6ndhgik
X-Rspam-User: 
X-HE-Tag: 1785087586-759197
X-HE-Meta: U2FsdGVkX19lk72f9v6AcVij5iEKIicWLA4QfM2yAqM/b3TR5rD7vVH2PVwdg/R+xHI6DH1lwLZ+lYrIXilRz2exfSxwAIfRx1tQ7GnNYiU9vrt2uO+KxU/KPKoTgrwhYddfPw9qY4q9Zqygf1GPcZleBQv9t7YKADi/afoxZsHzoK4v2SQJT8YHNtenqdfviwexQWizadQqiakzne1Nba/UnknZqP2d9cLvaoEKZ/RmcO/Vo4Bod6cNxZ+WHC/7nqjxQUeUuc6SHAgnPCpdtEg2YEnpZ29QFoldO7AYfxDojRgCWA/DKnpjDOc+No3R59yxjDt/py9sajeJCSGUu7Ae5Er+buJ1EBZF+2Q8rN3wS8lHRqK55DCu3ZBMlLu4NPe3KCGpXwFDCyjcsc2LIHLU5EB6eA3EEpnzfAc86SaI910GDX0sbpD3J/5Rcj79+583btwRhR3JF+XcRHpfGR0rjKK0YfA/5kJgIQZ34QRpBUy91u5ljLa/2xyg87Pqy3UaK0smlSKUNyLcaotrF4FgO6u4T26ujDcfVTodaUspVsv3iAg443LYVhxfqa1ZSqmLn+0KynahuLRqEa1SUx7UGtn9zc+vfIS2oveWyRAlinaijHHjXGdCzP27XNq1po8jvrfawiY4vVP452ZjyQdbedJ2XkNGRKft+XR42PFeYg9aU4+rnD/1NzjKUqspYa9tUxfS25fEfmJE+pyIqMQ7fFXLYJyQwmAnVRxjJqOffVm7aCi7R3yvPyAy9PoE9PczChmnn7nnTlE8CygzkYpPvdsKJuOuCDCQV0Sil6FWZGlzD7dN5wIV8XGBnnZ3Zr3TbsO1OCn/xHyH7AMeeS3QW6vPSfIf5gZYPPepCXSyw+k8ga9KmwJ4kJMg/yNFprcWkYc+sFVZNJhFhFHNO/dZohoIEsuoaMrAxp+pbtD5cp6KykaCziCEK3aW3Kbi0/fh87RRSIpDn+ocTRk
 nd69T0PL
 ET6ad3CRK6wiEHePqlVzSKk9uyhEEu+v24pfXDkMrn2S5IyB1RbGVUGHdS+4YbNS/iob5nDkCWzlY2Ao0mH2D5RqZzmT8pjocZvQIbFCf43wK+7COtBR3kUBEKiRpS3j6dtL9mb6OVGIda1hf7vkB8UN/IRI29/cJkOsx0Kj+g5a9FSmnQ2wzCA1V8P3gr+AV+e1O0hEhlwDkZ6cYS3Lnu2ui6sEdCBoYncKe1A/b+6tiuK6LvZ3n1lbQnI5xy0yAJzaByEsmXaFJ9PB7+FLINBZZzg==
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
index cee4b74761081..255b20e44287f 100644
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
 
+#define damon_for_each_prep(p, prep) \
+	list_for_each_entry(p, &(prep)->preps, list)
+
+#define damon_for_each_prep_safe(p, next, prep) \
+	list_for_each_entry_safe(p, next, &(prep)->preps, list)
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
index 5eb0400d5ce16..bda61f9ec0266 100644
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

