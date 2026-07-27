Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 811B0C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:38:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55C7E6B00B4; Mon, 27 Jul 2026 10:38:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 506C26B00B7; Mon, 27 Jul 2026 10:38:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E43D6B00B5; Mon, 27 Jul 2026 10:38:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 023546B00B4
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:38:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 852681A074A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:36 +0000 (UTC)
X-FDA: 85034812632.12.27EAF7C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0104F8000C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oA5to5uA;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785163115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xn7z1VfKK9Pqq9Y6JKkxjkK90zeUs8MzLh/EEjXoI28=;
	b=tERHVoJkSJOdVC8XIyBhmoiKAtL8NWK923Vr8FaJKSHtifDsNcT0kN8olrd1q849K0ADj8
	rfH/+Z/2F2/G0vnEO7qA2cztxOVgsI4tIqQqRQcJeW+O4mV8SV85IptzOXHk5yvq8c6x5H
	H175DQIbVmqDPUidhbyrSGfNK2njFmM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oA5to5uA;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785163115;
	b=SVPg9u88/ciClim5WmjiaJ1vzgykHDk9DH5Fb3vXddfjkjBmcbsBYIu1WLN44209kA1uBM
	mXS97v+ljm3RRqsFspSbkBkrDpby3rDj8t0mtl+w4tsVf7oz1r19VixvFfEVMJ4jNWjcmh
	v+50smqEXfsep+qlYGiuwFnT4WFnyi8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9556660A59;
	Mon, 27 Jul 2026 14:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405FA1F000E9;
	Mon, 27 Jul 2026 14:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785163114;
	bh=xn7z1VfKK9Pqq9Y6JKkxjkK90zeUs8MzLh/EEjXoI28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oA5to5uAISndVjmAMZ7lA0ihHvsdAxX4vWSJ5iTUc9hUOqVD0RKL9PRQaf+V8H0IB
	 CQZAyndbJ7o8Yt9cs2NwaaJja2hWe2SGG5Qy5JdoT0SYH+4m1r67uIqdR1zbfPKjxD
	 Dyg6clIzgv0LZkawSnafkNzObU8uKbnX9v2QTB8fYWs+WHlqyCkyfUpzgQyHhh8vmq
	 8t7f8Pf5oeNOU3fZeK9icu7rOZHFbj8ybp114BqQ24yB0wTxLCPx1d2pECTHLocsk7
	 hqxFzkR40GaOrH0HdcMGo7qnxWalQfMKyRXHMt61u1pmMYdZml9J5xUDAjYDErT/rL
	 WGpmPBQvhaOUQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 05/17] mm/damon/core: introduce damon_prep struct
Date: Mon, 27 Jul 2026 07:38:14 -0700
Message-ID: <20260727143829.86236-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727143829.86236-1-sj@kernel.org>
References: <20260727143829.86236-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0104F8000C
X-Stat-Signature: keomss1proc3daxtfy8wbrbgfios9zf8
X-HE-Tag: 1785163114-695530
X-HE-Meta: U2FsdGVkX18vRI0IrhNS9fGPEK2VIElOhjtBEyT32FmUpKZ+5n9R1V8CKn8m2ju0viCGJzOYCjCUzj/cE6rxwVkQvi++a49C1e6hYsHlpJn5nky3ZyBfC1G3VR257XQ0KBq4x+eQe0TYwDJMYYvpbBmhk2X63RiZktkQEocsG/8Su22dz5S1+iLHnBUoyX5FUtpft8bJcotQ1Yn1ddtOiPVIuUU+Vyxcz60JevBXE8e9v1lS/z0cjaO4kYH3xIwsoLZU4h+Y25B5biHcVA78X7VAYGv9OzW3+hQoMAoB9qaUmdYkva+JOsnq8ZPJBloAw4KqoAwkSJLdDAzmRcFWNhfeWyZf19fuL4Ye4l2k+YUsnANaQJMLJ0ng9v55ZhpJHiV0MavRYKlgRnjRMnE+/YNOL5yF/ler6B5wv8P1UYhc0vJZWBvZmJfwtpaXFyl5ky5pv/8z/2ogsmic65EDCHvlk6b1+GqJmsYn+oIY+tkLWMEcFwBo+4TCb2Ao+ldmKz2bg3C24R3mSU3AHslg9Di7pMtxNVyloMjE0bWclaC4Uxuor2PRItu1UcWvWqU6oMo9M7mOzhjd5wl3BbncPhd/ZzfQ7uRSW99cIs1QBI3kBouoS8Y2CmGEClsi9C3bDWJwwbT8WKxbW9A1KZJ2xZQIpd2oHvJkYUgoHlGbNAcTh0VLUvBlRACYz35liDHdov5+6AMqhxguMOSO5cAVMFtamDh7NjSGcUxWi/6OK9IfmScdRIuSH7VtBdpBjtQ7xLP2XRhoANU8MVcHbUnoxxuwwFUFg+IiOYppX4090tYnDQf69a1rdzkMV2qYnbVM6QE4JufcMUNFitetVzg68nxhU3gOytZ93ARc+MoK43CVChzKy/aNJFH3F+fyMAmPWFjW1Xf+PHbHPLci7FyShOhv29uBNsK7N3pWQRyFa7s9F8E50BuRa1PDbltQaSsdwq6Hw9vfhpQAB2YAzbq
 vZ7dQACh
 WCB9k2iO5VKAC6V+7UCdYAPXQPPMoLRjfDZMVGpdxLzwDiYOS5mtJdgaqVveGcbnQpL21aXCTgVrOylbLzU6FddlRq5WWzCfZWll490Wt8dKpwc6SHlAqvLPetH7YMnxHFyT6NafF607VUhYdt+w9Kre8deGaMAZ2m8dcT3gnmW2TWcC1hrY5/V2FUbctgxfCINyB2Vex8bYeD2pOWRC8yydEBrgpUW20LFb22FveaJpYo4ez9+sqO88Fw5qvO0iKZzkdvgnTVT/jRj1FFnGh15KDJA==
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

