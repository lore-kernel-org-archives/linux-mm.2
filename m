Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5E54C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:42:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B01886B00D6; Mon, 29 Jun 2026 10:42:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8C536B00D8; Mon, 29 Jun 2026 10:42:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C9256B00D9; Mon, 29 Jun 2026 10:42:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6FDAF6B00D6
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:42:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ED83FA010E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:39 +0000 (UTC)
X-FDA: 84933216438.02.8FB126D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6A20940012
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=QPuBn3cM;
	spf=pass (imf12.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744158;
	b=Oo80/oCqTbq/Mll3/pDvclVeSWUWwyxqAhfbEPhysNObhF0uruFMvUG8F8gTDe/fy7zokL
	ugAVnGysMn++OEgTGH15PDuHWS/bKh91u9xNbBCZntvyt8/3sUgKBRm4bEs1rsza7+M45n
	R45yZ+nU5+zY6scFCJTy5nSZ7Prbllg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B95MfNDuKErpokpFpBmzqpApTgeaUWZPys6hlukXD38=;
	b=8S1LHAnUwZObxer89Fv6xtWaiokum5RV1jiP/8e7Hf6w5wbeYqftc7XnXpDnr+dybRQs9O
	Guxs+lsZcN6T4TWky1YKr4OL5eA4Z91hG9iGkMmfcxRIwAGOBdNhW+CZg4gN6VA71XH+Ov
	uYlbhIskNqO+Zkq5GvU743t7+YIyE9g=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=QPuBn3cM;
	spf=pass (imf12.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=B95MfNDuKErpokpFpBmzqpApTgeaUWZPys6hlukXD38=; b=QPuBn3cMtGB9jYFhukSjaEXDjD
	w3q268f1WUe/5RBj2vETKou9zt4PuWeTTiu5U/cgw1CrvMZHKHQPsHLH5IVxWmz8evF4IO8v5iDV1
	iBkb4WQsDAgAWB1faaoedeLxKeyGsv0nCIv5+JxIl4vFfOHsOtZJTRvyf13aEWebLuJutIicWwvnx
	kpEUuRN0MY8Ot8vgRhomQT8QGd8anzIOpJptfJLSfVp0um07QokxlTarTdWDYXPRWHa4A95Vw/ZpW
	z27s236luJe3c441BCShExB+FCqDIGupeDy/zwEeVYHi+OxU4gESHprZThxcPBv8wpD/77rs1bBix
	Zja9qAkQ==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weDC1-0000000EuXN-178s;
	Mon, 29 Jun 2026 14:42:37 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH 03/18] maple_tree: Add write lock checking with lockdep sequence numbers
Date: Mon, 29 Jun 2026 10:41:30 -0400
Message-ID: <20260629144145.1572283-4-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629144145.1572283-1-liam@infradead.org>
References: <20260629144145.1572283-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6A20940012
X-Stat-Signature: tksbmb5yrwzekfstn7hr1hc79o6nyr3i
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782744158-825557
X-HE-Meta: U2FsdGVkX18ZClfw/1WpC1mjRwRXAqGG5OdC2zA9SpNl2nzFHz+f411hMU9yHGisOP8ix8SEj3OVHyLgExYa3IIYFS2DJ05gVy4HF2irSQ1P3yFJP0ilLv3o3A+Lk5sOWbI+y6677wmmmv0pwhbxnz9KzC5awa5g199htq1uwiIchi8ikzK6XL9Tt5rG6y79yicWQtt0I+iDbvtXew9gf9TJztjzUz1FMIZu+yUlshtBver6yhsvdjO7Qo7tcBN5SwkIhx7H4cIvLdH2VWH3d6VELk7kQaR19G5O5RUrUYDL0IKsE7X4hiXANLmjyMLiHcKhMrUvC/qmrT5wAMbWrf/PkpdTxIgoNscuti3THivVIym0+Z2+gzr0nuo4IiBMwCWEWtG2gFQO4OjNfoQzGyHkCOOpuoBtYj61OP4hBnq/1fLOftww5GYGp8VF5q95XB9tk8xNH6QNPK+mw6L36qXZ922P25Jzgj5WbqFPc0Dv4wnYjAZxMt73iNUQNGEfmtOXZSGqse6twEG0u2m1KShUSKjhoSLh5SUdTGHH9bx3LqC4O+xh5OdwBcrEAklFBaREXD+Zjci1kCEAIp5hyExFAdl+TnydZtwbj6iE0WLDAGHnA7CRwMktl0J3SST6RE6Foh8WYftszdaPOS3iV6GYVNlTUkwMFSY+VOGK203hkLkMjP+ubKTP9KMEUTq/By+iji6lYSIUy/fWeyVKHcF2kn/oVfBaRXt/9GaQzMzqd3VIthX2wV/Ii+9bxtXE5TkgEoQ4pMdcVcZLWpBO71Q8/6CWkB0jTkurTHpT75TMVsRsMi5QwDgK65xEWoKSIBXQE6ubcrqJBjm4ZrrV0n8hSJ99g/08GKu6Jle7qYIsYbsqI/TagnCpXlotT0sZW3YI++Xgf+1sCKwEZidgUGhsJOjeQW9AiVX5M7pAqXwRrw2unmj2iSVtmLxYuwes5OlOpvLfhcVBG6OZ90z
 9KInhC1L
 oS7h3BEL/AZnfOewZntPqEQcAjSXUNlT5NwLAa3CUtkzrxCkRqIC8jQQxsSamE69aNwhqLfiL1CRMLJqb0B4QMKXVvA5zXcKnxXbzRueOO/pyqCr/5vLBIcBSk1bt341ZWJSQQ6YXK9zkVsjuQWFRbFdB9drYd958t/nzMb5j3K9i6rbOZMBqqBV6zwiyeHbCJj16F/8JND9PS9gntnafpiQNy6dni/s0775S9Bb+ewnTgUV93divBNQILloxM45QbEisLnUNSWTiScXQsP1KEW7HweD7Ey94eIClSyz1VLJ1kUZgs8jkgHi0pAcqOuUqnNK3cnoAVagHU1tc7weKom3/kw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the lockdep sequence numbers to ensure the write lock is not dropped
between write operations.  The lockdep sequence is recorded on any walk
that starts from the top of the tree and re-checked prior to any
operation using an active node.

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 include/linux/maple_tree.h |  7 +++--
 lib/maple_tree.c           | 55 +++++++++++++++++++++++++++++---------
 2 files changed, 48 insertions(+), 14 deletions(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index 11a16c3508dc0..220b380cdd491 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -485,9 +485,12 @@ struct ma_state {
 	unsigned char mas_flags;
 	unsigned char end;		/* The end of the node */
 	enum store_type store_type;	/* The type of store needed for this operation */
-#if IS_ENABLED(CONFIG_LOCKDEP) && IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD)
+#ifdef CONFIG_LOCKDEP
+	u32 ld_seq;
+#ifdef CONFIG_RCU_STRICT_GRACE_PERIOD
 	unsigned long rcu_gp;
-#endif
+#endif /* CONFIG_RCU_STRICT_GRACE_PERIOD */
+#endif /* CONFIG_LOCKDEP */
 };
 
 struct ma_wr_state {
diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 7f310e8641669..1b2713190675d 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1153,40 +1153,68 @@ static inline void mas_free(struct ma_state *mas, struct maple_enode *used)
 	ma_free_rcu(mte_to_node(used));
 }
 
-void mas_lock_check(struct ma_state *mas)
+
+#ifdef CONFIG_LOCKDEP
+struct lockdep_map *mas_lockdep_map(struct ma_state *mas)
+{
+	struct maple_tree *mt = mas->tree;
+
+	if (mt_external_lock(mt))
+		return mt->ma_external_lock;
+
+	return &(mt->ma_lock).dep_map;
+}
+
+#endif
+
+static void mas_lock_check(struct ma_state *mas)
 {
 
-#if IS_ENABLED(CONFIG_LOCKDEP) && IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD)
+#ifdef CONFIG_LOCKDEP
 	if (!mas_is_active(mas))
 		return;
 
+#ifdef CONFIG_RCU_STRICT_GRACE_PERIOD
 	if (!mt_lock_is_held(mas->tree)) {
 		if (mt_in_rcu(mas->tree))
 			WARN_ON_ONCE(poll_state_synchronize_rcu(mas->rcu_gp));
 	}
-#endif
+#endif /* CONFIG_RCU_STRICT_GRACE_PERIOD */
+
+	if (mt_lock_is_held(mas->tree))
+		WARN_ON_ONCE(mas->ld_seq != lock_sequence(mas_lockdep_map(mas)));
+#endif /* CONFIG_LOCKDEP */
 
 }
 
-void mas_init_lock_check(struct ma_state *mas)
+static void mas_init_lock_check(struct ma_state *mas)
 {
-#if IS_ENABLED(CONFIG_LOCKDEP) && IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD)
+#ifdef CONFIG_LOCKDEP
+#ifdef CONFIG_RCU_STRICT_GRACE_PERIOD
 	if (!mt_lock_is_held(mas->tree)) {
 		if (mt_in_rcu(mas->tree))
 			mas->rcu_gp = get_state_synchronize_rcu();
+		return;
 	}
-#endif
+#endif /* CONFIG_RCU_STRICT_GRACE_PERIOD */
+
+	if (mt_lock_is_held(mas->tree))
+		mas->ld_seq = lock_sequence(mas_lockdep_map(mas));
+#endif /* CONFIG_LOCKDEP */
 
 }
 
 static void mas_may_init_lock_check(struct ma_state *mas)
 {
-#if IS_ENABLED(CONFIG_LOCKDEP) && IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD)
-	if (mas_is_start(mas) || mas_is_paused(mas))
+#ifdef CONFIG_LOCKDEP
+#ifdef CONFIG_RCU_STRICT_GRACE_PERIOD
+	if (mas_is_start(mas) || mas_is_paused(mas)) {
 		mas_init_lock_check(mas);
-	else
-		mas_lock_check(mas);
-#endif
+		return;
+	}
+#endif /* CONFIG_RCU_STRICT_GRACE_PERIOD */
+	mas_lock_check(mas);
+#endif /* CONFIG_LOCKDEP */
 }
 
 /*
@@ -4869,6 +4897,7 @@ void *mas_store(struct ma_state *mas, void *entry)
 {
 	MA_WR_STATE(wr_mas, mas, entry);
 
+	mas_may_init_lock_check(mas);
 	trace_ma_write(TP_FCT, mas, 0, entry);
 #ifdef CONFIG_DEBUG_MAPLE_TREE
 	if (MAS_WARN_ON(mas, mas->index > mas->last))
@@ -4927,6 +4956,7 @@ int mas_store_gfp(struct ma_state *mas, void *entry, gfp_t gfp)
 	MA_WR_STATE(wr_mas, mas, entry);
 	int ret = 0;
 
+	mas_may_init_lock_check(mas);
 retry:
 	mas_wr_preallocate(&wr_mas, entry);
 	if (unlikely(mas_nomem(mas, gfp))) {
@@ -4957,6 +4987,7 @@ void mas_store_prealloc(struct ma_state *mas, void *entry)
 {
 	MA_WR_STATE(wr_mas, mas, entry);
 
+	mas_lock_check(mas);
 	if (mas->store_type == wr_store_root) {
 		mas_wr_prealloc_setup(&wr_mas);
 		goto store;
@@ -4989,6 +5020,7 @@ int mas_preallocate(struct ma_state *mas, void *entry, gfp_t gfp)
 {
 	MA_WR_STATE(wr_mas, mas, entry);
 
+	mas_may_init_lock_check(mas);
 	mas_wr_prealloc_setup(&wr_mas);
 	mas->store_type = mas_wr_store_type(&wr_mas);
 	mas_prealloc_calc(&wr_mas, entry);
@@ -5473,7 +5505,6 @@ EXPORT_SYMBOL_GPL(mas_find_range);
 static bool mas_find_rev_setup(struct ma_state *mas, unsigned long min,
 		void **entry)
 {
-
 	switch (mas->status) {
 	case ma_active:
 		goto active;
-- 
2.47.3


