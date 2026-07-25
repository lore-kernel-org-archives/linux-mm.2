Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2764DC531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 21:03:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB3506B0095; Sat, 25 Jul 2026 17:02:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A64196B0098; Sat, 25 Jul 2026 17:02:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92B3D6B0099; Sat, 25 Jul 2026 17:02:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 61CE26B0095
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:02:39 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C9BB716037B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:38 +0000 (UTC)
X-FDA: 85028522796.05.E6CDE65
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 48B53180003
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YYUktpPc;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785013357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vA1pWiT60A2Sjmy1IPxMrwPYIsPuAFR2O+VHNv6q4bA=;
	b=lGd7jJkzR49373UASWe/6+PxYxTVokvjo4xW0XdzTpHc4/yNBI7JcNMNJ7H6Df+q2ycvQp
	oUHv3ECmCfDSxBC1av2ioPRnKso0dJE9Hs21LI7ap78V+WrGwcUwtDiVAFysgL/Icvk7GJ
	bHBeCzDeH3VgKbi4M8NhOKF6Lm98PRE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785013357;
	b=lnPKM+ei8a/ciwV1788qiS7uXDVyLAgTAjqYteiNah3ue+ApDS1r1oE+0KDfrEYch3lnOY
	27SaDFxZhIMjt27xj8Yn8xDNR611mdvG49ySm8whQPu4oMF5Wm27JD5PVU6e6ynzZ9qtEN
	V3SC2Vb4CZbHFaJpmyflAHAlcz6rdSs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YYUktpPc;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A56D060A96;
	Sat, 25 Jul 2026 21:02:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BF01F00A3F;
	Sat, 25 Jul 2026 21:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785013356;
	bh=vA1pWiT60A2Sjmy1IPxMrwPYIsPuAFR2O+VHNv6q4bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YYUktpPc+zjCdku3g5SgxQusMFZQWDY1Vvl9Xhf0uZLY5zZPVLxBc+Agc4bmREtXt
	 0iUBK87ubiU7LGraAKSxDSxeE3bwKqIsqJfl63czF912OOUJnfkHOrxsZnvZxQ9UJ5
	 k2k2dNJ3T0g9FZq3qJAEkrmaORKU/s8p6863bX038cbIvZjFOJWOD9mtqqEe6ZnLua
	 5KXGV354KCfT2A3HFWFDm2mdgoPEuebf/2c2cCfVL3Xty29PafFcbyyO8A53byrCqB
	 Hinxlrj31RXg9c2yemdLV51B1C0xJJklLm4QkRGrKl8Ia00+Y4Ul65SfIADFeK6q0U
	 lTM/yHutjJJbQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 05/17] mm/damon/core: introduce damon_prep struct
Date: Sat, 25 Jul 2026 14:02:09 -0700
Message-ID: <20260725210225.129944-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260725210225.129944-1-sj@kernel.org>
References: <20260725210225.129944-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 48B53180003
X-Stat-Signature: w15byfpnaj9cukq8rjwks9fxdjat1wyk
X-Rspam-User: 
X-HE-Tag: 1785013357-520131
X-HE-Meta: U2FsdGVkX1/Hp6wbvTTdQpwb80dmtbfNWAooQO4/CoexCoq0E2iCwbqdp38ZyAO+GdK/Kxt/BIQEdKWIBdk9zGytrn605qqrKSNfG0ZubCqVq5mYmThHJ+/+LALUpqQ8EcSfgFfh2K20ipWemEXyPwx4JNDyr6kGDhaMnPM+2aGixk79iiOfkWe9HwRb85O/I2am96ZF171gvTcNGliw71CzitypN4yr/3RBxQo9ockGgj+qywS3kJIwqjp0VuJ/sJbBE1y7LTSDGiccHTDjMc17fUrKBsuukSfGbxoQD9Ue2fKRQb3ptnxnWUnyiKlzf/dTEooScwkrLNhBg1xhdgx+nklo83vYbAua6xVDtBDJnt19rbXFS7vgQ6O3Ja+rYJeRa85ZNr7j7IjTLG6OtmLdfe1t61XLq5OBWCMSuPS7BvRQmM59GgtQ2kqeRTW6PKSqaNpimDBClX9z+s2i/+SJjDKfm/pKXNfbZl8XS+5A+/eLOqnYlzyruIo+EJ2EGIf2WlwFxmSRClqj+1ovqf8x+vsbPwslvYHQVI3TcshMHui/IkWi1An49xWeNdZC+k3BblkFrAWyb1nvFAgrmUMBDBsOb2nrSNgWFUyZfWd9BN706me9cJXx+or1ubAYgV2NUlkwLdpDxZhH5t02cMRbECOdgmcu4N0FPv3NzMG/JqIkKNy42pF7brwbix2t3fHdofCxfvaU0QoqTgvpn02Qa6hidvTXLDc8kQ63RZ3kQ4Amye6AqL9YT2UIIuWxuII08iLFSHaBMWH6cmF5uqfnQsRwN2yNio6jFVZieC1a8wdxyGHGsCy6jyzwYG3QPo9fyEAIX68EUZjJlY2ggqLnapJZ7mMnL8kEsnqENNebNfclZnoJlBDLKaYElUw0G3FWMz+I4QriWOwkJ/5QbMLD/jxqXMVROA4L0uXi3ZiZaoMxO48JXNO1NGu4iBJwKPvyMaWAMothmNwiMzx
 7SUikAmT
 csN96C8RfexBiP3SZiogG+waQqTGlqWPZT01LjEky9JXEHMbLqv0aWxuw9L6WZZ9LsHI2AuvXLCv4oxNOuNBBnuxxfa/QTMhB6kqKLQj39KB6NROKUVffUeYogGFWB4sC/Efn3/lhfh8dlX9oj/4udw7XFmdPO8yS8HMf5daui803mcBb712ROx900nZOQYWAalNqBwZuiNWman1QwAEPmxPzB2/DV66xscmMsUglU3WbesN+x4lFJTyCIjv6+N+ucJIR0+bXPq+5dzxobFsmWoi58g==
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

