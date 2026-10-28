Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2D62606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=c6nOvNag
Received: by kanga.kvack.org (Postfix)
	id 359486B05BA; Wed, 28 Oct 2026 11:42:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 331556B05BB; Wed, 28 Oct 2026 11:42:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21FA86B05BC; Wed, 28 Oct 2026 11:42:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E38936B05BA
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:42:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 57E2BC014E
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:42:45 +0000 (UTC)
X-FDA: 85372452690.12.36F7694
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9196410000C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:42:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=c6nOvNag;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf14.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793202163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SSuJWtylWOlDXuA/FVzzEuxLRE4GeRLbd69NBkjJQCc=;
	b=jDX50tvSnBf7VMzOHT5+UZEAIK8TdCcNY4SiSwmAqxy30bBF3TSd+7uTEw2OSJQq++DrWu
	PdXX2+nZpFV9slLFIp+MI6ljG1x2nmyLC0TCmczOCWmf3PMcwFOZr4DCXkj8GBn0URfAkQ
	AwrmgYnkepyfZ5qgDc8vh19Xf/u5Xbo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=c6nOvNag;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf14.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793202163;
	b=HAwmPDio0HN2Ha6bGMbZPNTzlOEhYfhSrwTtB+rS7F5UFpTIhhY5Zx4DRZ4DW55nSCoxma
	C8gJShOozd/xy5lndGF9zzSnRr60J9x+D8B6IIMnAViGi2qVnC4Mcjr3kZZEJ0D6jQ5lCW
	8hcaFiNUuf1l8PO6z00QV+E/nZTDVOc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SSuJWtylWOlDXuA/FVzzEuxLRE4GeRLbd69NBkjJQCc=; b=c6nOvNagGiPK6iup26/tck9kCe
	3qJUrqx6Y3DNuOkd9NZqOEI5hODGWh1m+NVdWg2qHfoxsJqewa+oVpWoN3CzUeYGC31N8QOgfODOH
	M7Wj+B9GiX/RtW+bPBLvhJprj2enTyiiyWe6tyD6l9NQhnQ4pR77gRQKrHf+VKAihmvbKlwTNHUGa
	DSYE/OY60xdhHqBIt4qTtVLfhIIHA3CC4VcD4H39UjI/Dj6FB4RgUzdfFdpwTPw+a2XIw4VpxtYry
	J57km11XeLfupsYV6AlGbXU2wo6M90P7Tg9VTmnvY0nSfhiIpNOoO24x8/UCYdLqiD0AqOaTIZHB+
	GMM5fvew==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xM5nW-00000007Qnq-1ssv;
	Wed, 28 Oct 2026 15:42:42 +0000
From: "Liam R. Howlett (Google)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	"Liam R. Howlett (Google)" <liam@infradead.org>,
	stable@vger.kernel.org
Subject: [PATCH 1/4] maple_tree: Fix rcu reader NULL dereference after the tree is emptied
Date: Wed, 28 Oct 2026 11:42:15 -0400
Message-ID: <20261028154218.1668182-2-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028154218.1668182-1-liam@infradead.org>
References: <20261028154218.1668182-1-liam@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9196410000C
X-Stat-Signature: 9go34rkpgapuih3t8jjfhxc9uweo7y8x
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793202163-229675
X-HE-Meta: U2FsdGVkX18efHeNMwto43Op3Cac2vwRhvJJROqG0B2XWu7IiDvfcdkYZ4TrIkQs2q6WQD9kN9RReCDmxjsodSF6NlYBD6hh3ac/iOG2i6aGoU+8236yxS3/iWFQrNLSgiDrY/Zk2TEBsL2inA+9KKcRrUr5BO8LmgbyLo6kKhjBzDF8eiJ5QYhWsM4Nzo7hjcnkOBtUWlITBh64M0dxr8FMCwTxxap3h4L20evfhC4BdT/7r43Lqny4q/bCnpuusdsycyCu67gdG4FPePY45g3ikWfWZLBVmXMV52MTepwBjwjeBfvNQCNCTnLnimANbeo7B5IsrMPvOtJDKnrLrtENBX6hwqPasLkqz/6Rn5vyY3zCPNuJcKGajA2hYJHxd/wD48g3v4e63dQaB+QrcYptGY/hguPO9XTpUObZSoYsN9u8NIaGnGysFVOGYxyFQQ9cb+ByIq3MiFndFp8v73zRFVwym02XypoOZjMTChmElPv18JIlkCXobwyYd+lL4nDHQjzpJm0EesYdeFExEuRH7af/ArPF4rY2sQMs7hVZr1gyYN/Zu2w5xGycr6eUG16G47YXJao1RhL0gFXtWhq8U4aVSaIlh6TGZI6U0clwVuwtWCt2YE03JZmw5o3vOoau/+yIUc7fRUY91CSdA6afbGczB0VY8EujtoaIBRxfYmoJKzJbDiWe8YaNxhQsVzjE6AjZ++beEdQVHujmZEccOA5hh7gs8q0Yx5RZK4eO/OtvXeOOWmasgTUykn62fmbkf33ZDjBN0VCf8W5Vi0u24tFQdAkHbAMrvrHZ1b9+8iSKQD9ZCtxaKBx2bGq+wYzdMvW2SuWIK8wV/R+5b+gKALojVHmK3J9rD2vufxxpAACMIiZ4tpy9nZ2vyqK11eB/okcBT674znbWHqgZKcWk0AkNYvOpp8vFsFFX8qMA/WADz4DJ/i0oj7a2hafFfi9HsQrYcqImfBj/2Oc
 1i6oWHJT
 XYXtxUzXdA87+ZWFmWmqEr73sDEUI1dp91VUn7DOh5gluOG5r6DcxuGxOCWD8LmQp1fjk3PR5R6uv8ow7Qu9o7K1fb9929QSngsicbRjv2Z1P7JJvDE4Vd6bWjY9TLr+uMSQgKIqHdXOpIR9kW6tEVO/NO3zAbtShRHSAdharKNSkD749iyZruq5wS7nUQa5nJfSQhBSRwk3co3mgNY11PngMy6bnEl0bzx3vM4z5gYV6iwpQALLbw+Gxxkfi6a0IDbnVfCaIpmwLSE2A8tU0XfeOGKkitZkTN+8994ak/xO3sFzIpMeOn7VG5D6ryqkD244THs/4D63TKirHr3xybl3zFe1imepOe3e8jGoT2usJYL5y83ezADj8QA==
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

Initial fix was generated by LLM and sent by Chris Mason in private.

Cc: <stable@vger.kernel.org>
Fixes: fff4a58cc00b ("maple_tree: introduce mas_next_slot() interface")
Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: Liam R. Howlett (Google) <liam@infradead.org>
---
 lib/maple_tree.c | 110 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 83 insertions(+), 27 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 0b0036c9f8489..22812ed49be5a 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3891,14 +3891,54 @@ static __always_inline void mas_rewalk(struct ma_state *mas, unsigned long index
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
+ * @min: The lowest index to return
+ *
+ * The arrival here is either because there is a root value or nothing.  With
+ * nothing, leave the limits mas_walk() sets for an empty tree.  A root value
+ * sits at 0, before the saved index: stop on it as mas_prev_setup() does.
+ *
+ * Return: The root entry if @min allows it, NULL otherwise.  A node if the
+ * root changed again since the walk; the caller restarts.
+ */
+static inline void *mas_prev_no_node(struct ma_state *mas, unsigned long min)
+{
+	mas->index = 0;
+	if (mas_is_none(mas)) {
+		mas->last = ULONG_MAX;
+		return NULL;
 	}
-	return false;
+
+	mas->last = 0;
+	if (min)
+		return NULL;
+
+	return mas_root(mas);
 }
 
 /*
@@ -4006,14 +4046,14 @@ static void *mas_prev_slot(struct ma_state *mas, unsigned long min, bool empty)
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
@@ -4028,10 +4068,8 @@ static void *mas_prev_slot(struct ma_state *mas, unsigned long min, bool empty)
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
@@ -4045,8 +4083,8 @@ static void *mas_prev_slot(struct ma_state *mas, unsigned long min, bool empty)
 
 	slots = ma_slots(node, type);
 	entry = mas_slot(mas, slots, mas->offset);
-	if (unlikely(mas_rewalk_if_dead(mas, node, save_point)))
-		goto retry;
+	if (unlikely(ma_dead_node(node)))
+		goto dead;
 
 	if (likely(entry))
 		return entry;
@@ -4063,6 +4101,17 @@ static void *mas_prev_slot(struct ma_state *mas, unsigned long min, bool empty)
 underflow:
 	mas->status = ma_underflow;
 	return NULL;
+
+dead:
+	mas_rewalk(mas, save_point);
+	if (likely(mas_is_active(mas)))
+		goto retry;
+
+	entry = mas_prev_no_node(mas, min);
+	if (unlikely(xa_is_node(entry))) /* The root changed again */
+		goto dead;
+
+	return entry;
 }
 
 /*
@@ -4176,8 +4225,8 @@ static void *mas_next_slot(struct ma_state *mas, unsigned long max, bool empty)
 	node = mas_mn(mas);
 	type = mte_node_type(mas->node);
 	pivots = ma_pivots(node, type);
-	if (unlikely(mas_rewalk_if_dead(mas, node, save_point)))
-		goto retry;
+	if (unlikely(ma_dead_node(node)))
+		goto dead;
 
 	if (mas->max >= max) {
 		if (likely(mas->offset < mas->end))
@@ -4185,8 +4234,8 @@ static void *mas_next_slot(struct ma_state *mas, unsigned long max, bool empty)
 		else
 			pivot = mas->max;
 
-		if (unlikely(mas_rewalk_if_dead(mas, node, save_point)))
-			goto retry;
+		if (unlikely(ma_dead_node(node)))
+			goto dead;
 
 		if (pivot >= max) { /* Was at the limit, next will extend beyond */
 			mas->status = ma_overflow;
@@ -4208,10 +4257,8 @@ static void *mas_next_slot(struct ma_state *mas, unsigned long max, bool empty)
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
@@ -4226,8 +4273,8 @@ static void *mas_next_slot(struct ma_state *mas, unsigned long max, bool empty)
 
 	slots = ma_slots(node, type);
 	entry = mt_slot(mas->tree, slots, mas->offset);
-	if (unlikely(mas_rewalk_if_dead(mas, node, save_point)))
-		goto retry;
+	if (unlikely(ma_dead_node(node)))
+		goto dead;
 
 	if (entry)
 		return entry;
@@ -4244,6 +4291,13 @@ static void *mas_next_slot(struct ma_state *mas, unsigned long max, bool empty)
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
@@ -5450,7 +5504,9 @@ void *mas_find(struct ma_state *mas, unsigned long max)
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


