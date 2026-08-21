Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 255C9C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:26:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23CB56B009F; Fri, 21 Aug 2026 15:26:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 213E06B00A0; Fri, 21 Aug 2026 15:26:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 129536B00A1; Fri, 21 Aug 2026 15:26:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E164D6B009F
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:26:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6E57816022E
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:26:44 +0000 (UTC)
X-FDA: 85126258728.21.249CF89
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf19.hostedemail.com (Postfix) with ESMTP id 206AA1A0007
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:26:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=32o2EnzM;
	spf=pass (imf19.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787340402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MCSEVpnnxOwqJ8ef4Eh5CcwT/xjoltglmElmLRbIhj4=;
	b=RTgPs+f81g2HNSoYcBgmtBuSMHStZqVMVPHdETZZkZXyCp7PljT3UCmUZDQIbyq8+gsKvS
	7JM6fPiCjBDnKVvZMTREj7vnket2lPftyF3TlaZaxXdtA4p/NzVOJlEGCIaaJYbI4qtRYj
	xcqnWEVfsCFhasi7ugp1pQbzd5Jf7hk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787340402;
	b=rztLJTpHJYDF/+A3gYVwaIMT18MkRJ817ElgcyGdnchOxUIh2fUeQNRuu9SUCIZREq6DWl
	urby3PfUj4hmXdg9LINqG4Av5h8euSkDXy2jwMt9DgUMzNsuoL56Duu8TYr58uqdHxfvm0
	1UgWccsSnx+zG8EHGYkSNWxSVvwyZqE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=32o2EnzM;
	spf=pass (imf19.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MCSEVpnnxOwqJ8ef4Eh5CcwT/xjoltglmElmLRbIhj4=; b=32o2EnzMAsHKO7xUxv6rnRv327
	oEbLEi1tbaA8L9OJJpQAcVJgddGmeU0x7qc2je74luSjaXmp48pdUAzzuHa+VrNkotkmisLyzja4N
	tNOVwIwdHJfXN6tPe3oeGfP3zRsjulcoWwcvdbGD3YDSgdK3cnv9H0Y2dQvg5oeFArvr6esFguWIW
	BfutAqhxw1LLY0dKzWwU+DNV0cLJ8N3zk/r5h7e8O8XZNlJw6KN2JNGWI4fGY1iPTA4zv8jQ8p6vp
	hLfnC5YiDsWqgUTvEqc0BwSlZTdabEg46xQ5B2sz/6PusO4+3IFuComVACqInRGCZG1NwvGSpoXdO
	T2CcCGtA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxUsz-0000000E0gW-0HAo;
	Fri, 21 Aug 2026 19:26:41 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH v3 01/19] maple_tree: Add rcu locking check when LOCKDEP is enabled
Date: Fri, 21 Aug 2026 15:26:09 -0400
Message-ID: <20260821192627.4085470-2-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821192627.4085470-1-liam@infradead.org>
References: <20260821192627.4085470-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 3nxrtnczaax6qkifaxnabqkq8br8t7wu
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 206AA1A0007
X-HE-Tag: 1787340401-315374
X-HE-Meta: U2FsdGVkX18eZyjUd9noGPqForaRj98D/ZowT7is70ZGkivTg+gU5HxbK2bHB2I7A5D1Aq4kv14w5Irk9FLdUxmRGg3PvjPqCYoC4ve/v28wFcPZbZKlB66A5rCGzUVqcPPwUshV3kHvyxZ1MAvCwS8JjjgHKt45LqCip8NWDQTvd3TVyiAEXQ1qjVU0RLr+1XAqqRvlatlR+tvCRiTsMwEHFX2XEporspWcgmj+lqzn+j/afyWMPnbF7aXaeTP1a3bqeBnCB/XoBrSmJglTjazuX6Vxz6+13SszPnEbF7OSABwrORoomktU81076/jL8TJpYB0Jp7TB5hZIQpHRAeFEKPNegiRYFTRVIxbUhtfk5s/Ag60JbsuMLsl6mRTqqtYeL4evZJOOarzJBsLiskTE0O/B5P4qb9n1Pl9MWAE/GLX5oZszqe7qkZUoBPkMYSeR+/QGCpe1XeGHM21sW4vYsye2/74MzJWN4USdQgHBB8RNgjxI44gtXXhq0Zx6vB53SOC0GeKIWmYzAGLjOmSLRXITxmVfjNx3w5YL7WY0diofGDn4UaZqUZY3aHKVOkKfqIDbRxjemZXKky8cHd6RDzO0XhY0DXmoKPOMqAD5pHyT9T+1hBfFf44hmMDug1bdbpKrgKk4wIkKHj6JIWquPDOMyiVQIplpskj+9oOlh7IaUIJ6gccIp7GpuKkxSBGkDuVshCQhuJNk7PbifsoLBDylqkzIDElsxljdOOYN3qkzxezOHd/gF6Zde89AjPI3V/PnnXPJwl322sIuf+5fOj9tSyQSnpFmnlqXQiIPjfBCTOywStDZp0uVoyejQggQ9VWixaTk8K6i+zThMgH6ECip5stGYRbs1VivL7B6xSflOJ3b5hrFXtnZRX5JPKcC8188KXijFg7qyR5g9Ke8znXzUeoAr9b1IKIHFCg+wZ6jhBvUkekc24Nu+5cWH2JYSEz/l6Fs168yAes
 3D111Iev
 mUT3bR621Km7gKM3F9/oz83a24VEbw8US/53MhIovTlG93KPS+f4dhL37OQFd+6F19PKt9tW8ZK0Gca5CPuliiOMjMcomh9rZR8lW4+N8ts7zNTdnedJuwuO+FaN/B5NOaqx5eGFfAE0QXYsRGIQSpVM/hK7NHrMmReJFHoO9QReDuDgkIMFaPczCXvtqdBsXVViZZn4q+QTxM+RFAjbKws56I8ohQBbs3DfX9+hSM9T3xnygRZGarJxyAkTFBTgLWcYoDrAokqBmLeTzDYSvqd6AkCAdTeFUFC6TDxPQ++PJoVAjO8uRXo4n9b8JnRT6B946BdkQtqIC/72bzU1ghnXipg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_LOCKDEP and CONFIG_RCU_STRICT_GRACE_PERIOD is enabled, check
for rcu locking issues by recording the grace period in the maple state
and checking the rcu window is still valid whenever the maple state is
reused with a state that is not MA_START or MA_PAUSED.

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 include/linux/maple_tree.h |  3 +++
 lib/maple_tree.c           | 50 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index 1b3014377105c..1acf932fcd33c 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -484,6 +484,9 @@ struct ma_state {
 	unsigned char mas_flags;
 	unsigned char end;		/* The end of the node */
 	enum store_type store_type;	/* The type of store needed for this operation */
+#if IS_ENABLED(CONFIG_LOCKDEP) && IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD)
+	unsigned long rcu_gp;
+#endif
 };
 
 struct ma_wr_state {
diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index a0542b491bc23..6d805521beddf 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1148,6 +1148,42 @@ static inline void mas_free(struct ma_state *mas, struct maple_enode *used)
 	ma_free_rcu(mte_to_node(used));
 }
 
+void mas_lock_check(struct ma_state *mas)
+{
+
+#if IS_ENABLED(CONFIG_LOCKDEP) && IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD)
+	if (!mas_is_active(mas))
+		return;
+
+	if (!mt_locked(mas->tree)) {
+		if (mt_in_rcu(mas->tree))
+			WARN_ON_ONCE(poll_state_synchronize_rcu(mas->rcu_gp));
+	}
+#endif
+
+}
+
+void mas_init_lock_check(struct ma_state *mas)
+{
+#if IS_ENABLED(CONFIG_LOCKDEP) && IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD)
+	if (!mt_locked(mas->tree)) {
+		if (mt_in_rcu(mas->tree))
+			mas->rcu_gp = get_state_synchronize_rcu();
+	}
+#endif
+
+}
+
+static void mas_may_init_lock_check(struct ma_state *mas)
+{
+#if IS_ENABLED(CONFIG_LOCKDEP) && IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD)
+	if (mas_is_start(mas) || mas_is_paused(mas))
+		mas_init_lock_check(mas);
+	else
+		mas_lock_check(mas);
+#endif
+}
+
 /*
  * mas_start() - Sets up maple state for operations.
  * @mas: The maple state.
@@ -1166,6 +1202,7 @@ static inline struct maple_enode *mas_start(struct ma_state *mas)
 	if (likely(mas_is_start(mas))) {
 		struct maple_enode *root;
 
+		mas_init_lock_check(mas);
 		mas->min = 0;
 		mas->max = ULONG_MAX;
 
@@ -4355,6 +4392,7 @@ void *mas_walk(struct ma_state *mas)
 {
 	void *entry;
 
+	mas_may_init_lock_check(mas);
 	if (!mas_is_active(mas) && !mas_is_start(mas))
 		mas->status = ma_start;
 retry:
@@ -4992,6 +5030,7 @@ static void mas_may_activate(struct ma_state *mas)
 		mas->status = ma_start;
 	} else {
 		mas->status = ma_active;
+		mas_lock_check(mas);
 	}
 }
 
@@ -5069,6 +5108,7 @@ void *mas_next(struct ma_state *mas, unsigned long max)
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_next_setup(mas, max, &entry))
 		return entry;
 
@@ -5092,6 +5132,7 @@ void *mas_next_range(struct ma_state *mas, unsigned long max)
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_next_setup(mas, max, &entry))
 		return entry;
 
@@ -5200,6 +5241,7 @@ void *mas_prev(struct ma_state *mas, unsigned long min)
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_prev_setup(mas, min, &entry))
 		return entry;
 
@@ -5223,6 +5265,7 @@ void *mas_prev_range(struct ma_state *mas, unsigned long min)
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_prev_setup(mas, min, &entry))
 		return entry;
 
@@ -5269,6 +5312,7 @@ EXPORT_SYMBOL_GPL(mt_prev);
  */
 void mas_pause(struct ma_state *mas)
 {
+	mas_lock_check(mas);
 	mas->status = ma_pause;
 	mas->node = NULL;
 }
@@ -5377,6 +5421,7 @@ void *mas_find(struct ma_state *mas, unsigned long max)
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_find_setup(mas, max, &entry))
 		return entry;
 
@@ -5404,6 +5449,7 @@ void *mas_find_range(struct ma_state *mas, unsigned long max)
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_find_setup(mas, max, &entry))
 		return entry;
 
@@ -5516,6 +5562,7 @@ void *mas_find_rev(struct ma_state *mas, unsigned long min)
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_find_rev_setup(mas, min, &entry))
 		return entry;
 
@@ -5542,6 +5589,7 @@ void *mas_find_range_rev(struct ma_state *mas, unsigned long min)
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_find_rev_setup(mas, min, &entry))
 		return entry;
 
@@ -5618,7 +5666,7 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
 	if (!mas->sheaf && !mas->alloc)
 		return false;
 
-	mas->status = ma_start;
+	mas_reset(mas);
 	return true;
 }
 
-- 
2.47.3


