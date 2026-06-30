Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 526DFC43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 19:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DDFD6B00AB; Tue, 30 Jun 2026 15:08:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 067316B00AC; Tue, 30 Jun 2026 15:08:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E23046B00AD; Tue, 30 Jun 2026 15:08:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BF4B86B00AB
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:08:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 44796C259A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:08:54 +0000 (UTC)
X-FDA: 84937516188.04.53905C0
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf10.hostedemail.com (Postfix) with ESMTP id B90D8C000D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:08:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=1WM+4YXQ;
	spf=pass (imf10.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782846532;
	b=VyyggmYDeG6/cZJ4r7b6pbiV0Q2w/4gxGwTzfrWE0+bBm7lF0LwCx5leziYrPjFkLa0siW
	ZbSd3SzZF23iM/hYDgD0uhfX451h0irJjDCntSXutV/V9buvQhFaP1kKe2n/gA4c9Gp6yR
	q4m0frexAg80FgY8o9B2Mp5prUiIXSw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782846532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aXIlw04Se2hX/aKthZw8BiKv6Mt5ehHJi6aH4pkx9RI=;
	b=1+J99nJey+RXsVBt2EFNRP5tDt6Ax7DzBfqiRE8FSBc+RjhBxTpwshsN+kWbttZPZD8kYq
	lQx+CjE9UQosvAawl38PWPxNJUJwFVk4H7VrpmX8TserYGdhlECkLuhmdKmrMwqZvK4T/8
	wcVoDV0onn9ZXjDQ/Na1f1u95RqktQo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=1WM+4YXQ;
	spf=pass (imf10.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=aXIlw04Se2hX/aKthZw8BiKv6Mt5ehHJi6aH4pkx9RI=; b=1WM+4YXQPJPDbRIjTk0M/7bztQ
	8Rlm2vWDXi20vNo0Aq7WtexVEwkrv27reISMuwEo1JMw4YhJitzGe1H6XaHDlEC2WQdZ0lJ85nbxx
	okvNe/+NkHquTN+2niWGnBXRFSixWYa4ziGT4m3S6Z+FMx+QfjP1ci+jV9kYxD0R4QJW5hKEBQUOV
	9xZRyz1337Y4+QHdx3NKYM2h8ueA0DrMwkMJVjEt/4xXl/ub3t/KS/rqmG++ShtT4xiY8cdO9fQTJ
	js52qWWgvWR0L251ZtPzmVfo0phdSOCDLM9km8AxMPc4Ysen0+A/Cj32tb/NHQZx6Df13jn7R0+VO
	mvUTwosQ==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wedpD-000000005pU-2sLJ;
	Tue, 30 Jun 2026 19:08:51 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH v2 03/19] maple_tree: Add write lock checking with lockdep sequence numbers
Date: Tue, 30 Jun 2026 15:08:27 -0400
Message-ID: <20260630190843.3563858-4-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630190843.3563858-1-liam@infradead.org>
References: <20260630190843.3563858-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9uyfmwm139hyyz3pe73dzbq517zth7d6
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B90D8C000D
X-HE-Tag: 1782846532-315224
X-HE-Meta: U2FsdGVkX182NfZ4q5SbliQIqaw4pICVJnemWrKuKHg6LlnN+E3wmrVRJUr4HwEWlxmz5F5XFdY5a5PU6H4/wM5D/4dyjCB6rLEIZeZZ9SzqYYa+wU99tE8DibBoNkAoQQcqO9aYuUzg2MKk9R1ztGyXz05UEHJScLRoa3xUlai5uwHcjVtuAtFHZRX+7tiw/SlB670dt439205xcCqMS3AhXZh2lQ7Z4WYmvJxjo34TEB++qeh94cVuy2RueBrL3xdpg9xXMUyzo2mpkN1BhdKUdytmJ1HeroAjLcGVbQkheMUWGwIqpHqhPLbnF4aUGV6tg2N36uNnWwn4ytcuBBW2uNtaOsFRuu01ysYLWUMUFV+qIwKaHCUoaHjgw1Bz2a8j+9Oikmz/Y2FUvVJtddV5XgDqEPqWGEfcEjPXXskj0f5+awaaYD7MTjBnXDQAAWC8iwIV+shLv2dpGecz25eTaM+Gy1QLKvxNS6VRL3FzPLU67COE3Rlokcy7pT531SYhKTfMF1cBPNIUcc/Z2g4W5IBM1NgZcskVvRi0hj7McFabSf0O7hiK2a60KzvDrKFlc0jVFfHGi3Z8M9j1m19woE4M6KsH/kc0uF3ZXhE4ToMIcpYRjqqhM+jVyD/6rbPvJlk7sWilGYtGFzzAKIo68H9DpoxnkDxYj4TwHfn8UAx4ySWMeWM6LacTWfStzYHJaFyj3hLPt0OFAIxwZNVnmt4jKgQftUFZyntyZ9LGmgfUf38zo+3r0Fep176cghUSxk5fPdlq5JHJU5KDGZDoLwywAJ4r9ND7WqFGGIFmZVJFqYZuV1BHyg02iCKmxLyeZMG1NBiEztaqG4kcW8ypvlkwW1dwzyHEswMnSkKcPpPSiRsAOKsw3PBoAzXcXlI4IJx+bzHaZAsCOyko+DSfXKmfWnTwXhophZxJtEzOni3MAUa0F13ycPjWs/ErMHjh6SX/4++Rr16tLJG
 OHRk4Aor
 wSpSzZnBilGtdxtTJ84TVevRBgRJ/KcKhNBAWeD6zh98PzOpucKVtTNE876u44399j6PTxlL6O/W1Zc6QxTJW3Y1mXzjtZ8sUGqbMjdk4z0mSwQXi39XzF5WLlQj1bA42paruLLrtg1vmrapUAikRchq/L4nWa2GyqawXOs3SHm6/MaiOZc8/WlMO3aP8JzGVcXIfJVijSY0E99L1Y8aJW11I/7LUbYlxXtYKVFB9v/8om1/JfuzrqJvRy1/VtNvxuOSAozaaVn4rFvT/jDbD1V44Aq6TfALwmzjsZPHjoXguVrSfqT2qQ5acWomY4viy5mp2JIHOj8S8jK+S7AKfXCT/wA==
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
 lib/maple_tree.c           | 58 ++++++++++++++++++++++++++++++--------
 2 files changed, 51 insertions(+), 14 deletions(-)

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
index 3dff0435c13a7..e2f7474572319 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1153,40 +1153,71 @@ static inline void mas_free(struct ma_state *mas, struct maple_enode *used)
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
 
-#if IS_ENABLED(CONFIG_LOCKDEP) && IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD)
+static void mas_lock_check(struct ma_state *mas)
+{
+#ifdef CONFIG_LOCKDEP
+	struct lockdep_map *map;
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
+	if (map && lock_is_held(map))
+		WARN_ON_ONCE(mas->ld_seq != lock_sequence(map));
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
+	if (map && lock_is_held(map))
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
@@ -4869,6 +4900,7 @@ void *mas_store(struct ma_state *mas, void *entry)
 {
 	MA_WR_STATE(wr_mas, mas, entry);
 
+	mas_may_init_lock_check(mas);
 	trace_ma_write(TP_FCT, mas, 0, entry);
 #ifdef CONFIG_DEBUG_MAPLE_TREE
 	if (MAS_WARN_ON(mas, mas->index > mas->last))
@@ -4927,6 +4959,7 @@ int mas_store_gfp(struct ma_state *mas, void *entry, gfp_t gfp)
 	MA_WR_STATE(wr_mas, mas, entry);
 	int ret = 0;
 
+	mas_may_init_lock_check(mas);
 retry:
 	mas_wr_preallocate(&wr_mas, entry);
 	if (unlikely(mas_nomem(mas, gfp))) {
@@ -4957,6 +4990,7 @@ void mas_store_prealloc(struct ma_state *mas, void *entry)
 {
 	MA_WR_STATE(wr_mas, mas, entry);
 
+	mas_lock_check(mas);
 	if (mas->store_type == wr_store_root) {
 		mas_wr_prealloc_setup(&wr_mas);
 		goto store;
@@ -4989,6 +5023,7 @@ int mas_preallocate(struct ma_state *mas, void *entry, gfp_t gfp)
 {
 	MA_WR_STATE(wr_mas, mas, entry);
 
+	mas_may_init_lock_check(mas);
 	mas_wr_prealloc_setup(&wr_mas);
 	mas->store_type = mas_wr_store_type(&wr_mas);
 	mas_prealloc_calc(&wr_mas, entry);
@@ -5474,7 +5509,6 @@ EXPORT_SYMBOL_GPL(mas_find_range);
 static bool mas_find_rev_setup(struct ma_state *mas, unsigned long min,
 		void **entry)
 {
-
 	switch (mas->status) {
 	case ma_active:
 		goto active;
-- 
2.47.3


