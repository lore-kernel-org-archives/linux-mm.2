Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C715CC5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:27:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DADB86B00A2; Fri, 21 Aug 2026 15:26:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5EEC6B00A3; Fri, 21 Aug 2026 15:26:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C753C6B00A4; Fri, 21 Aug 2026 15:26:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8430F6B00A2
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:26:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6DF14140220
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:26:47 +0000 (UTC)
X-FDA: 85126258854.16.D6539F3
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id DA43740006
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:26:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=QB+QLwVc;
	spf=pass (imf27.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787340405;
	b=NKLFP5E/77fmf9W1l/g/nqn0jzCA1RIVMoHoOrwpl78qKXlmrMlr/ftV2WIkBlOzimpIZ8
	wrvHj97hygRhlR9dSsOL/+rd8U5nBLOm42AgOk5YATPQq0eSASjz9xGtTazToBa5NU0baz
	YNycDOAYf7UR8gBNy71glreWwv7nuZs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=QB+QLwVc;
	spf=pass (imf27.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787340405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Lbf6JfpagQh1GCndXTynKeDQ4f9QWf34QEeyRmktqc=;
	b=kxeB2TJHmx+1sixMQwlO9dg1YlUUqEkwnVBalcltmwGwS9IrZl+DBFYaDZcZsv1tNGY4MD
	DdbabxE5CI1gMnbnZEE2gZmJyGdJldRzZXLlhrv7lFSwuLpcqrF3NaWEmmBg5SArXLGmDC
	OeAn3PaP61RV2xtHgi3xN6l3Se1O6ws=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7Lbf6JfpagQh1GCndXTynKeDQ4f9QWf34QEeyRmktqc=; b=QB+QLwVcBP3g0s6SZK3D985tGB
	mJhNSQFbbWOIviFGNjXmE4+59EKZOWbzAwlmvtGsIb0n00o+CksqqIl3SAOqViyM6VUjZb1s9dDDK
	ynKjCTul4aHj1sqeTHTAIPw8wt0tVv3KnBEVSexxjEIoHu5qjZHT+eoYb43tbSjSN9X5xBrIMa9OJ
	hm7hfObx9biFci1oPT2genYoPpgLga4wAWxwN6KM6gVUVK5WsegKcvtvWn2W6NaUJE9vE5kYWNYsn
	KBOXVT5TQ50toEY3Z/5nKwHsp1npENKNHVVDDbg48yJTQ/pMgysJ7U/1z/UZUvjHwZ8JfyedD4Fo8
	Qrd+0sVQ==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxUt2-0000000E0hD-2uyi;
	Fri, 21 Aug 2026 19:26:44 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>,
	Breno Leitao <leitao@debian.org>
Subject: [PATCH v3 03/19] maple_tree: Add write lock checking with lockdep sequence numbers
Date: Fri, 21 Aug 2026 15:26:11 -0400
Message-ID: <20260821192627.4085470-4-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821192627.4085470-1-liam@infradead.org>
References: <20260821192627.4085470-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DA43740006
X-Rspam-User: 
X-Stat-Signature: 4sbeyxtcb3xjfd7fwufy18ukf4z4zkm4
X-Rspamd-Server: rspam06
X-HE-Tag: 1787340405-783326
X-HE-Meta: U2FsdGVkX1+ofKalGtBpk432BrWNkPEgaYAcV/pNBLLkuiMy9HDVYBNpqk+MwxOhlm77lnSKYhmkcCrBf+k/VZteKLTQJNb+EpY052sRenspXR0nK0ilTQw1sG853QOM31pNtyn5c0kNXwWWmc/sFiZTTO5slSs0EGlghRtQqgf24GnEWWFoIBMD1IrphULdMGQ9nCVPQsRhLkkA0dqSDTd9KUtqYvNRBeJm/h3w+1ch5MqLkSlk4GfDbHsHofNrRxwdO+B6f5hG6nU/Qs3v1lQyVLKScZWZSAYL/3TZc63CUOaOwcKHw7nqpfVWxGag4Ar+UkMt5Be6Pc6RD6V34thydetSyBPESMon/PSfgyVpZivgmpIvJ1r6cLTQz0ufHT2fjOOwjqmlyE2OGmv3zc4WIDFlMK8T120IigeBfQxmkgkAH2A/khP4wce0FVRKLxcEBhDoJMEaRa+U5d2N4tlbMwD0vhPKxc/K6b+Ry8Py9Bbtv8wF5lm22fk86Dv/Lw5Nrraenr7jCMv45pvB1QNTosGB6831i7Sl36M7pFLerCx7qqigJoPdG7seyNA7FpLKeGqIw2yQbH7+P1/quJ07syxG2vHOlKyGaF5s+3IoQfDE0Sr4M5AijYh8LW0/BxwTvUgCP/q9q9MuiVgLr3iyMgmMuzGguhgiMFCikjtX1bsij+UAJ6qzsmqvCUJHwcisMJHCyKRnFav4CixjpdUdX5RPj3TLad38bClYxrphrBDQFXOHkLSg4ymnwVAJQLu2QXXJ2FENnv8YLVJSp2gvpuDvk0gmZgpMIjSsI6iOQgP3q47RQTEsjTaFMRmNCSZn6W7Ih+yZtDSAQRFdSPmdokOV+xJ39RGXT7JR6/VYEXiqF4pazTIKi3IVYOsdfPYC3YImDdpTympjoFF7ghOTFjJagGW3eZTCPALfgdPwiSK6cGxMs1AOFpignZJ5OoQx3O0hjZLhVAkU4oS
 hJgQ1kub
 hE/2G0nq1sCjpJ9Ciq7VTMC9uuAeIu6OdtaPZORhPYoBXIGVWakIgAcTCWRHNT9bemA6kbR/9tZQ6cGEDKi7i4OS22Bryi+CESrlfVLnvjy3zCRGPEK0cUtxq4UkUyoV0jnXXcOSNu6QoI8zsIYx3w/LS/D7GuiBwEQrK0eS9J1Pfl6a3zCCCZF0bZeTkmVwkjUq0JiTLMaURuHXlcbDPsEUYE+Y2j0dJ4B14TJ4dDKrmtcbhnNgvZaIEm4kxsGGRirwUhF8qKSEb+DeIHRq16xHgQbbWEA9rf5YOHysr9GPpI8oRNylgbRbhEq8KPbgC1KIJhlAP/fxGq7YG1ABPBf0CKIQ+2fyU8PN3Jvy+sIy4DPY=
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

When lockdep detects an issue, it sets debug_locks to 0 disabling
further reports.  __lock_sequnece() will return u32 ~0 when debug_locks
is zero, and the real sequnece count cannot return such a high value as
it is less than 32bits.

By always updating the sequence number, regardless of lock state and by
ignoring ~0 value in the sequence number will avoid ever printing a
WARN_ON when lockdep sets debug_locks to 0.

Cc: Breno Leitao <leitao@debian.org>
Tested-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 include/linux/maple_tree.h |  7 +++--
 lib/maple_tree.c           | 64 +++++++++++++++++++++++++++++++-------
 2 files changed, 57 insertions(+), 14 deletions(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index 1acf932fcd33c..d63ac92208d02 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -484,9 +484,12 @@ struct ma_state {
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
index 6d805521beddf..d8c826e1ca0cf 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1148,40 +1148,77 @@ static inline void mas_free(struct ma_state *mas, struct maple_enode *used)
 	ma_free_rcu(mte_to_node(used));
 }
 
-void mas_lock_check(struct ma_state *mas)
+
+#ifdef CONFIG_LOCKDEP
+static struct lockdep_map *mas_lockdep_map(struct ma_state *mas)
 {
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
+{
+#ifdef CONFIG_LOCKDEP
+	struct lockdep_map *map;
+	u32 seq;
 
-#if IS_ENABLED(CONFIG_LOCKDEP) && IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD)
 	if (!mas_is_active(mas))
 		return;
 
+#ifdef CONFIG_RCU_STRICT_GRACE_PERIOD
 	if (!mt_locked(mas->tree)) {
 		if (mt_in_rcu(mas->tree))
 			WARN_ON_ONCE(poll_state_synchronize_rcu(mas->rcu_gp));
 	}
-#endif
+#endif /* CONFIG_RCU_STRICT_GRACE_PERIOD */
+
+	map = mas_lockdep_map(mas);
+	if (!map)
+		return;
+
+	seq = lock_sequence(map);
+	if (seq != UINT_MAX && mas->ld_seq != UINT_MAX)
+		WARN_ON_ONCE(mas->ld_seq != seq);
+#endif /* CONFIG_LOCKDEP */
 
 }
 
-void mas_init_lock_check(struct ma_state *mas)
+static void mas_init_lock_check(struct ma_state *mas)
 {
-#if IS_ENABLED(CONFIG_LOCKDEP) && IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD)
+#ifdef CONFIG_LOCKDEP
+	struct lockdep_map *map;
+#ifdef CONFIG_RCU_STRICT_GRACE_PERIOD
 	if (!mt_locked(mas->tree)) {
 		if (mt_in_rcu(mas->tree))
 			mas->rcu_gp = get_state_synchronize_rcu();
+		return;
 	}
-#endif
+#endif /* CONFIG_RCU_STRICT_GRACE_PERIOD */
+
+	map = mas_lockdep_map(mas);
+	if (map) /* Update regardless of lock state */
+		mas->ld_seq = lock_sequence(map);
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
@@ -4864,6 +4901,7 @@ void *mas_store(struct ma_state *mas, void *entry)
 {
 	MA_WR_STATE(wr_mas, mas, entry);
 
+	mas_may_init_lock_check(mas);
 	trace_ma_write(TP_FCT, mas, 0, entry);
 #ifdef CONFIG_DEBUG_MAPLE_TREE
 	if (MAS_WARN_ON(mas, mas->index > mas->last))
@@ -4922,6 +4960,7 @@ int mas_store_gfp(struct ma_state *mas, void *entry, gfp_t gfp)
 	MA_WR_STATE(wr_mas, mas, entry);
 	int ret = 0;
 
+	mas_may_init_lock_check(mas);
 retry:
 	mas_wr_preallocate(&wr_mas, entry);
 	if (unlikely(mas_nomem(mas, gfp))) {
@@ -4952,6 +4991,7 @@ void mas_store_prealloc(struct ma_state *mas, void *entry)
 {
 	MA_WR_STATE(wr_mas, mas, entry);
 
+	mas_lock_check(mas);
 	if (mas->store_type == wr_store_root) {
 		mas_wr_prealloc_setup(&wr_mas);
 		goto store;
@@ -4984,6 +5024,7 @@ int mas_preallocate(struct ma_state *mas, void *entry, gfp_t gfp)
 {
 	MA_WR_STATE(wr_mas, mas, entry);
 
+	mas_may_init_lock_check(mas);
 	mas_wr_prealloc_setup(&wr_mas);
 	mas->store_type = mas_wr_store_type(&wr_mas);
 	mas_prealloc_calc(&wr_mas, entry);
@@ -5469,7 +5510,6 @@ EXPORT_SYMBOL_GPL(mas_find_range);
 static bool mas_find_rev_setup(struct ma_state *mas, unsigned long min,
 		void **entry)
 {
-
 	switch (mas->status) {
 	case ma_active:
 		goto active;
-- 
2.47.3


