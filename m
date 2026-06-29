Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3D4EC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:42:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC4596B0093; Mon, 29 Jun 2026 10:42:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4F146B00D0; Mon, 29 Jun 2026 10:42:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A63BF6B00D6; Mon, 29 Jun 2026 10:42:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 79A836B0093
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:42:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CFA0940161
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:36 +0000 (UTC)
X-FDA: 84933216312.24.3D1FC94
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf18.hostedemail.com (Postfix) with ESMTP id D7CBB1C000B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=2ceBgokA;
	spf=pass (imf18.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744155;
	b=GH3HnepCnhLZtyNfM4IOq4xuEyw29HdvZ6OWMu/jlsDpN2/xBjEO7g3fi7N8AfNAcj1I8S
	+SWQBLd4/CBzDJ9nNO2mUwHXzFdO/k7LUnc/nhG/sL+MUN7pCxJOC+sHJsY0ZhYNSYyhxi
	AiQECZG32JhHQHLYWuYG40d9Z0weVw4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4R5GovYD71G+9QwVQQZzRjIyhjlLbCBytKM8BD23Org=;
	b=NqFsQcrwOkTk8yOLyRbeh3BY1o/vJ501ssVrh/IbZ/BbTWXMC4hkj4W1d/5w1n9sTaG5GN
	HqGeodb+X/g6ArjQutKzg9NA2hTU/KrEX+u0l8e3TtPPh77DEVW9/c/GT9+WdkyT8CmfD6
	FL7zqoRKHfZL3zdSLUDaqYAojK+BT+U=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=2ceBgokA;
	spf=pass (imf18.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4R5GovYD71G+9QwVQQZzRjIyhjlLbCBytKM8BD23Org=; b=2ceBgokA5iOE0hJeBIqEyKca6L
	pIRyU7m7MaJwiwX41UjSEIqT/BZp8PqAZX+Ns5hN1ISMZfp3hYeJbMVp49nF+jxGUEa4/0sGTEH84
	OuRk1RG/i9oseq1OWmFOoVLK9e3KV4j+1+yBaG04PptBnEVT91aCq7MOnhPqIu/NP9j10PhdkEi6s
	K5eu0mEDLkikDgodSCm05a2pWyIJfOtBpoJDDytOwblYcU8x6V+wcxYmRCx4Ir9Fvt+yFh+Swi/LA
	bzWmCFuyJZvl054WlePta9tdlfpSGnGZEk7Cdm7RkTpLBjnQtJtyRx+csq1dA7W+8jcpOKJPRktvx
	c/LpBELg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weDBx-0000000EuWc-3C1F;
	Mon, 29 Jun 2026 14:42:33 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH 01/18] maple_tree: Add rcu locking check when LOCKDEP is enabled
Date: Mon, 29 Jun 2026 10:41:28 -0400
Message-ID: <20260629144145.1572283-2-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629144145.1572283-1-liam@infradead.org>
References: <20260629144145.1572283-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D7CBB1C000B
X-Stat-Signature: z8j3jwue1ew34a84xo6kzgr1mcuhpo6b
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782744154-156778
X-HE-Meta: U2FsdGVkX18LwgLOLq9uhAHWs0Zqfwezn1mLf5DAfZSqwRUSIrSjT47n50PVuQjNyjM3+F3I3kQHwTa9VdZRoUmCdC6xH9g4WaI0iqUg9Hu7laYCkkX1Wjy/g4g84jTgC4dCVAWmDkBTjYDR+XHa2z+BR+dGM0XDIqYp7ehCBE1lJUhoFDe5F1jO+UV945gvoddIhXQ6X35cXlIJ8ygq8HAjPrLEZWInY52vTWrs785HAQ6Q9CLfNvgpuKLYrGFmVBGPYWuzbU6MBJoiWa+NDIaUp8uqs3pYnk8zGFWYyca+/tOnLzDAkDq1A6TALoP0tTAlJ27IQdIbn++BBGwY23p1LAyTBTrP5HmUuHGXx2EYsOu8VfrPrFi1BbDWl7SfdsydYTxWHFztBpxE/aDM8ZemzXKODfL1NYne91o7yTYs66ABxNYznsfjNgWjm1cYGgerKhm5rUPYB3Pk9f5PNLS1TdSZ69ruzyQQZpNFgcjOdY+L3Ywqu6nzQUnd4AcEcT169VVjK6/T7PZorhELgfvm8YeHKu3n6JfLApas72uaOcOAiqRrgSo30zhfUYl1OQcvvuSwzZpMAtn9fB2kfLdxpsULJMuc32toqUK6nlwNLL3HSXv71HmMJfJSLh+XyYGCfmw8q1iU0zVwWEdk0+LLe7SLQaeILyfS37ByeqaAaRrT+jY4Og9ySTYtS0nD+faoNcqopY9XdLmiYz817UDbW79rfo3BNovZ+uDTPtYfwCH6sgv2v72Ayc1qzZXJZ2Fkht9GednWxy2W9fyX+yEPNgj36lQ7fXM+DC+sx2s9F3r8u5QE9hrvC6svlZvNg28m7wXv6QQ0fs8P535qtOixxNWWD8GtBVk0hSOtvSFoj3d81fOqzKAY8q4npRk2NmgcT7HQIa26/Ocn/JfWgJsNV2XsQVxE+99h40q14DM+BpzI7azbS71lMXYiM1QDh+7E3/pcJYUMIcHVXLJ
 pih+fVT1
 YlPwg5VK6rEATuQ3Wwc1Qjd9dyGdALLabH7JorKkCJ6aRH6r7S6lq2XSP/B78E91kA70usuSXdah2DCf0kqujA1tabDFvA89pna8IRXX16MXkjCO2tCzHbmr33hItUxeHaPa+8OVMaD3XX84DWjavqKRb7QCaO5rJFrpDwYnOTHmWCNCWUYtM7RrcSZeyGvtwy36kw02dL3majKuw0znzzk76nfuWXADj1jf0vSNEg3amsy/RLq9s4rjR+UjRZswojiObO+fI7t5NYJsn8KUsyjnOIId/nRjXOgI5GE2b7LD3P988rK0e0jXD6BH9Uo4dMeZ/27bmQNbJDGgZf1iCMUtyUA==
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
 lib/maple_tree.c           | 49 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index 4a5631906affb..11a16c3508dc0 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -485,6 +485,9 @@ struct ma_state {
 	unsigned char mas_flags;
 	unsigned char end;		/* The end of the node */
 	enum store_type store_type;	/* The type of store needed for this operation */
+#if IS_ENABLED(CONFIG_LOCKDEP) && IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD)
+	unsigned long rcu_gp;
+#endif
 };
 
 struct ma_wr_state {
diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index e52876435b77f..7f310e8641669 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1153,6 +1153,42 @@ static inline void mas_free(struct ma_state *mas, struct maple_enode *used)
 	ma_free_rcu(mte_to_node(used));
 }
 
+void mas_lock_check(struct ma_state *mas)
+{
+
+#if IS_ENABLED(CONFIG_LOCKDEP) && IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD)
+	if (!mas_is_active(mas))
+		return;
+
+	if (!mt_lock_is_held(mas->tree)) {
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
+	if (!mt_lock_is_held(mas->tree)) {
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
@@ -1171,6 +1207,7 @@ static inline struct maple_enode *mas_start(struct ma_state *mas)
 	if (likely(mas_is_start(mas))) {
 		struct maple_enode *root;
 
+		mas_init_lock_check(mas);
 		mas->min = 0;
 		mas->max = ULONG_MAX;
 
@@ -4360,6 +4397,7 @@ void *mas_walk(struct ma_state *mas)
 {
 	void *entry;
 
+	mas_may_init_lock_check(mas);
 	if (!mas_is_active(mas) && !mas_is_start(mas))
 		mas->status = ma_start;
 retry:
@@ -5074,6 +5112,7 @@ void *mas_next(struct ma_state *mas, unsigned long max)
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_next_setup(mas, max, &entry))
 		return entry;
 
@@ -5097,6 +5136,7 @@ void *mas_next_range(struct ma_state *mas, unsigned long max)
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_next_setup(mas, max, &entry))
 		return entry;
 
@@ -5205,6 +5245,7 @@ void *mas_prev(struct ma_state *mas, unsigned long min)
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_prev_setup(mas, min, &entry))
 		return entry;
 
@@ -5228,6 +5269,7 @@ void *mas_prev_range(struct ma_state *mas, unsigned long min)
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_prev_setup(mas, min, &entry))
 		return entry;
 
@@ -5274,6 +5316,7 @@ EXPORT_SYMBOL_GPL(mt_prev);
  */
 void mas_pause(struct ma_state *mas)
 {
+	mas_lock_check(mas);
 	mas->status = ma_pause;
 	mas->node = NULL;
 }
@@ -5382,6 +5425,7 @@ void *mas_find(struct ma_state *mas, unsigned long max)
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_find_setup(mas, max, &entry))
 		return entry;
 
@@ -5409,6 +5453,7 @@ void *mas_find_range(struct ma_state *mas, unsigned long max)
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_find_setup(mas, max, &entry))
 		return entry;
 
@@ -5521,6 +5566,7 @@ void *mas_find_rev(struct ma_state *mas, unsigned long min)
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_find_rev_setup(mas, min, &entry))
 		return entry;
 
@@ -5547,6 +5593,7 @@ void *mas_find_range_rev(struct ma_state *mas, unsigned long min)
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_find_rev_setup(mas, min, &entry))
 		return entry;
 
@@ -5623,7 +5670,7 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
 	if (!mas->sheaf && !mas->alloc)
 		return false;
 
-	mas->status = ma_start;
+	mas_reset(mas);
 	return true;
 }
 
-- 
2.47.3


