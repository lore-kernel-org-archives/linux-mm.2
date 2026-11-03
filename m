Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5570C606D804
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 02:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=TGDbtYWA
Received: by kanga.kvack.org (Postfix)
	id C68316B05B1; Mon,  2 Nov 2026 21:07:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD1376B05B2; Mon,  2 Nov 2026 21:07:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A7166B05B3; Mon,  2 Nov 2026 21:07:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 604336B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:07:45 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4C411A7873
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:07:44 +0000 (UTC)
X-FDA: 85392171648.23.154035B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8D304C0006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:07:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=TGDbtYWA;
	spf=pass (imf22.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793671662;
	b=ZLTBEe7KyRyK8U1E3SkWL/Hpbo+n6GuJA79FlMHci5wH6+Fqh0lyXMmUO2PwuXKmXUJcol
	5y8iwkMLGQA5O0isCXt4N34tk690nRoz+tzHngrczMb/A1QV+B54FSz4ADXU67pJtSPOI+
	zHCs98LFkMp55EUiOUUa/MGKA7bOep4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=TGDbtYWA;
	spf=pass (imf22.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793671662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MEV4XsnTYsJd2QIYPZzwGFBH4RUpwBZrt7qJP+LJW+Q=;
	b=dfquEVG9D7tfk1uqc5SMjoui0dpdmGk1uPwM7H0x9TuX7IroH6pgGklLYbxlnZ8WMTzqQd
	xucGEGnTJiBo1MfnCPF7TD87T6BvWGITFur6EvWjiQ7XVaEqixw5j9Wj9yRPWbVF29n1IB
	Riy0CKJrfV87st0SYeuwb3suG6IlsCU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MEV4XsnTYsJd2QIYPZzwGFBH4RUpwBZrt7qJP+LJW+Q=; b=TGDbtYWArsJWmFb3FBdvGRXq3y
	/zTPL8JTSu6IehKB5dEpwTQ3TwVAhCCB5zNGmOs70Z5ij93fulZLIICFFuyt9iUgrWqPaHQOr1tVI
	EuJZeVW7fckP3OUzsI+yliQd7k2wv9YRdoOH2vi11EDtIdp7SPFIpyYSkujEdbKvDi/LrPpV/BV7A
	qj9Db6H5/buO58CT8FkDvpACZ3B3HhFlYpWRNXkY79KlwPfyk/BZFFzdUIuKgk+gjc2dOPydy9EXj
	QyGbi0UBLgYirKwL/x9SU36GILoO5SU2nu0UxIx/adPYhOrlDoB5yGqKnj/Aswu0vIzQPG3bghHSA
	jJ+pM5bA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xO3w4-00000000quQ-0vQ8;
	Tue, 03 Nov 2026 02:07:40 +0000
From: "Liam R. Howlett (Google)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	"Liam R. Howlett (Google)" <liam@infradead.org>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/3] maple_tree: Fix rcu reader NULL dereference after the tree is emptied
Date: Mon,  2 Nov 2026 21:07:22 -0500
Message-ID: <20261103020724.2614498-2-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261103020724.2614498-1-liam@infradead.org>
References: <20261103020724.2614498-1-liam@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8D304C0006
X-Stat-Signature: n3js338i1iy9jcmujpza4nqqu58tn1sx
X-Rspam-User: 
X-HE-Tag: 1793671662-325870
X-HE-Meta: U2FsdGVkX181yk6Mi7RZSmUM0d/WhLyTpGomEE1/ejNa/7eFKcuLJg+D+5cddyBnbmspcIS4fLK+lsEFIOy302b4d/ccder7vs/+k6BuQnM5BvmR/wH7+1MMVByGcW5H0viUZLnVxNlFLIPSTj8SB+wJyDQtlkB1Fqnt+YqktyP7MKFhx6Btf5lhIy9pFJj17DWWFpd9xguh68UjVY/pPldkE7naq7hyj861YTr/Rcjn/GNVuR4fWUsKb6J+Em4DnGEvg15DIWEVOLeCkYy4+vcllK6rOJtfnwnZZHnXKm36Wq28dMxHhSGy0vMtWNrESXJ8UA8XEBRxfCKPMLJCpMLaUkgGbiA5ktGxk3NVI5ECGlRKa1qqAP2vW+l8i1+dqs+XsiyNOzxy6O0AeBBYy/ZxiRmJgDKtXhof5z6H6aw8UxdztRIIp3I0W0y7TIP5zWPU70508Jf6Js88PS2ftLzY/byAtpJnQl35d0AT7OvguAtHXO66UO+xb898mjFeWnCvImoriXsowS6T7AAdRCTBFr5NckqNcMv6fjZQmNfpvtThzbjDKYfBr1+TFFM5qXwgFbRrkv97jstaO2eSsAUh3qlBPJrQQqjpw27HerDQvVWq5WyXrZVD7QhK3Td2/zCGZ2eTyvvsPkhAoGT/CPFBoFAjCCzAZk/lsY4tBu8mRzx22ivwNAmqcOhMmnVOnX10Xzjn9va/q02nCGJewmdTI3CXCQj+Nc2dbTQqol57C4HUp1HYLa15hBm5OXvFZDAGJFvK4O4EoL0+Qv+rhWeBKp2UcgZ4RMIknRAA9PXbGTQS8n0Oet1oUAmx5CluTI9hgqFIwvG1S/t4sPs7MT5IEr/Z/IR4w2DLZypKKcrXVXWZxL3EgP+GR53VHbNNIMwhJXpax4hMRusxMAPHrdr6ZxJ3sNOFQA31psPCXfItCysAuk4NourjqchoSiF5lu4YCzfkLAe9mx+yg5o
 BohEmMBu
 SvszoEMjXA1QzEVBfstdu1wY3mdFonTWL0VSpjPWK1Qb0JBlTqhaKER6wuE79lw8m4hpYapzFlCx/9Uj/4MwHLgw5UDuyXplnDbVuem+wFgrU4lhl1N8hXCeNl5L4axmFxvK+JSTnnBaNPUbnRqb/D6HoNeYxBSLwHXEW1CYKsfzv74u6YthPQYFZHGb96DOH3kF9DsO/JnvQzqyhBIYpk6Zh5cw97LPCtMGebtCUJtp5k5ayilzvcNq3cyPdIT5US3f65ew/yQsjekCUOP33LHk6goy3G3ObGCrXkxc5F24rX/HS06kvaqScI//4201BerZJ0uPhTYskRHbgxQNFWKWCWFK5TTwQBVDxQQo+etRT8IXA3u7KieNfyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

RCU readers may hit a NULL dereference if the tree is emptied while the
walker is restarted from a dead node.  Avoid the NULL dereference by
checking for an emptied/pointer tree (0->ptr, 1-ULONG_MAX -> NULL) and
set the maple state limits correctly.

A reader of /proc/<pid>/maps racing with an munmap() of the whole
address space can hit this.  The first implementation has the same
problem in both directions.

Initial fix was generated by LLM and sent by Chris Mason in private.

Cc: <stable@vger.kernel.org>
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: Liam R. Howlett (Google) <liam@infradead.org>
---
 lib/maple_tree.c | 112 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 85 insertions(+), 27 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 0b0036c9f8489..a36dc20af84c4 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3891,14 +3891,56 @@ static __always_inline void mas_rewalk(struct ma_state *mas, unsigned long index
 		goto retry;
 }
 
-static __always_inline bool mas_rewalk_if_dead(struct ma_state *mas,
-		struct maple_node *node, const unsigned long index)
+/*
+ * mas_next_no_node() - Finish a next walk that restarted into a tree without
+ * nodes.
+ * @mas: The inactive maple state (ma_none or ma_root)
+ *
+ * The arrival here is either because there is a root value or nothing.  Either
+ * way, the next entry is nothing.  So set the limits and overwrite the status.
+ *
+ * Return: NULL
+ */
+static inline void *mas_next_no_node(struct ma_state *mas)
 {
-	if (unlikely(ma_dead_node(node))) {
-		mas_rewalk(mas, index);
-		return true;
+	if (mas_is_ptr(mas))
+		mas->index = 1;
+	else
+		mas->index = 0;
+
+	mas->last = ULONG_MAX;
+	mas->status = ma_none;
+	return NULL;
+}
+
+/*
+ * mas_prev_no_node() - Finish a prev walk that restarted into a tree without
+ * nodes.
+ * @mas: The inactive maple state (ma_none or ma_root)
+ * @index: The start of the range the walk left
+ * @min: The lowest index to return
+ *
+ * The arrival here is either because there is a root value or nothing.  With
+ * nothing, leave the limits mas_walk() sets for an empty tree.  A root value
+ * sits at 0: stop on it as mas_prev_setup() does, unless the walk was at 0.
+ *
+ * Return: The root entry if @index and @min allow it, NULL otherwise.  A node
+ * if the root changed again since the walk; the caller restarts.
+ */
+static inline void *mas_prev_no_node(struct ma_state *mas, unsigned long index,
+		unsigned long min)
+{
+	mas->index = 0;
+	if (mas_is_none(mas)) {
+		mas->last = ULONG_MAX;
+		return NULL;
 	}
-	return false;
+
+	mas->last = 0;
+	if (!index || min)
+		return NULL;
+
+	return mas_root(mas);
 }
 
 /*
@@ -4006,14 +4048,14 @@ static void *mas_prev_slot(struct ma_state *mas, unsigned long min, bool empty)
 	node = mas_mn(mas);
 	type = mte_node_type(mas->node);
 	pivots = ma_pivots(node, type);
-	if (unlikely(mas_rewalk_if_dead(mas, node, save_point)))
-		goto retry;
+	if (unlikely(ma_dead_node(node)))
+		goto dead;
 
 	if (mas->min <= min) {
 		pivot = mas_safe_min(mas, pivots, mas->offset);
 
-		if (unlikely(mas_rewalk_if_dead(mas, node, save_point)))
-			goto retry;
+		if (unlikely(ma_dead_node(node)))
+			goto dead;
 
 		if (pivot <= min)
 			goto underflow;
@@ -4028,10 +4070,8 @@ static void *mas_prev_slot(struct ma_state *mas, unsigned long min, bool empty)
 		if (mas->index <= min)
 			goto underflow;
 
-		if (mas_prev_node(mas, min)) {
-			mas_rewalk(mas, save_point);
-			goto retry;
-		}
+		if (mas_prev_node(mas, min))
+			goto dead;
 
 		if (WARN_ON_ONCE(mas_is_underflow(mas)))
 			return NULL;
@@ -4045,8 +4085,8 @@ static void *mas_prev_slot(struct ma_state *mas, unsigned long min, bool empty)
 
 	slots = ma_slots(node, type);
 	entry = mas_slot(mas, slots, mas->offset);
-	if (unlikely(mas_rewalk_if_dead(mas, node, save_point)))
-		goto retry;
+	if (unlikely(ma_dead_node(node)))
+		goto dead;
 
 	if (likely(entry))
 		return entry;
@@ -4063,6 +4103,17 @@ static void *mas_prev_slot(struct ma_state *mas, unsigned long min, bool empty)
 underflow:
 	mas->status = ma_underflow;
 	return NULL;
+
+dead:
+	mas_rewalk(mas, save_point);
+	if (likely(mas_is_active(mas)))
+		goto retry;
+
+	entry = mas_prev_no_node(mas, save_point, min);
+	if (unlikely(xa_is_node(entry))) /* The root changed again */
+		goto dead;
+
+	return entry;
 }
 
 /*
@@ -4176,8 +4227,8 @@ static void *mas_next_slot(struct ma_state *mas, unsigned long max, bool empty)
 	node = mas_mn(mas);
 	type = mte_node_type(mas->node);
 	pivots = ma_pivots(node, type);
-	if (unlikely(mas_rewalk_if_dead(mas, node, save_point)))
-		goto retry;
+	if (unlikely(ma_dead_node(node)))
+		goto dead;
 
 	if (mas->max >= max) {
 		if (likely(mas->offset < mas->end))
@@ -4185,8 +4236,8 @@ static void *mas_next_slot(struct ma_state *mas, unsigned long max, bool empty)
 		else
 			pivot = mas->max;
 
-		if (unlikely(mas_rewalk_if_dead(mas, node, save_point)))
-			goto retry;
+		if (unlikely(ma_dead_node(node)))
+			goto dead;
 
 		if (pivot >= max) { /* Was at the limit, next will extend beyond */
 			mas->status = ma_overflow;
@@ -4208,10 +4259,8 @@ static void *mas_next_slot(struct ma_state *mas, unsigned long max, bool empty)
 			return NULL;
 		}
 
-		if (mas_next_node(mas, node, max)) {
-			mas_rewalk(mas, save_point);
-			goto retry;
-		}
+		if (mas_next_node(mas, node, max))
+			goto dead;
 
 		if (WARN_ON_ONCE(mas_is_overflow(mas)))
 			return NULL;
@@ -4226,8 +4275,8 @@ static void *mas_next_slot(struct ma_state *mas, unsigned long max, bool empty)
 
 	slots = ma_slots(node, type);
 	entry = mt_slot(mas->tree, slots, mas->offset);
-	if (unlikely(mas_rewalk_if_dead(mas, node, save_point)))
-		goto retry;
+	if (unlikely(ma_dead_node(node)))
+		goto dead;
 
 	if (entry)
 		return entry;
@@ -4244,6 +4293,13 @@ static void *mas_next_slot(struct ma_state *mas, unsigned long max, bool empty)
 	}
 
 	return entry;
+
+dead:
+	mas_rewalk(mas, save_point);
+	if (likely(mas_is_active(mas)))
+		goto retry;
+
+	return mas_next_no_node(mas);
 }
 
 /*
@@ -5450,7 +5506,9 @@ void *mas_find(struct ma_state *mas, unsigned long max)
 	/* Retries on dead nodes handled by mas_next_slot */
 	entry = mas_next_slot(mas, max, false);
 	/* Ignore overflow */
-	mas->status = ma_active;
+	if (mas_is_overflow(mas))
+		mas->status = ma_active;
+
 	return entry;
 }
 EXPORT_SYMBOL_GPL(mas_find);
-- 
2.47.3


