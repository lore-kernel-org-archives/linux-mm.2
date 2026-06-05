Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB62ACD6E7B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 18:35:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 319A36B0099; Fri,  5 Jun 2026 14:35:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F1A86B009B; Fri,  5 Jun 2026 14:35:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22E116B009D; Fri,  5 Jun 2026 14:35:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 15E4D6B0099
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:35:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B7916A029A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:29 +0000 (UTC)
X-FDA: 84846711978.09.59458E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0C6F218000C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AJSBHGNR;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780684528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sy6ojk1d+tdK/kdjiYdwMCtmPtof9JNqEAxHhL3pkyA=;
	b=BFLZMs5Tw6eMg/d2ML+zLASMThzbaz4wEx2KLferPs8sqva54z+APlPlAvdS3o5dCw3J5E
	na9T2QUeZ/gG7/TQdeSsoWgPxtVSicTp/dggbcqYRO6vKZwvi3P5ntpi/Aomxk5UQHILvv
	ncFNhdKiaUjOEfHN3ZAZJbBkQwxS+uw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780684528;
	b=sRM7bW7NAhulEDmpWU9BVoAHHRFP4wp0iv6DC0ocb6nBEQXPiH6SnDBJuBUaYCGLxM2tEh
	XpAYlRbSyYsfznLBWeX5ovU0Ft1/MtSWExnCFHf06Fgp1NcbsQZmqW/jo1S62kZId2ARSf
	PWIfjuJlUmN9QVUmnBfmOyVzced5x74=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AJSBHGNR;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4968C42B06;
	Fri,  5 Jun 2026 18:35:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF961F0089A;
	Fri,  5 Jun 2026 18:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780684527;
	bh=sy6ojk1d+tdK/kdjiYdwMCtmPtof9JNqEAxHhL3pkyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AJSBHGNRx27gBO59IJQX64bjQPvI1lQz/ZrLOX8eFzLfRcasMMQ5o5FADulVTfKgQ
	 ttkoP2/FH7ji786zuFkiEhLxKcKDHPpsTdKxumBRrExnnUhzl5bMtXsSWvZtjcAzPG
	 J0Y+o+5bKwOjoFj63tZcCk8pPoneEoNkdE/vuo/hOix7mndykoveQ8afXIZgG6oGbA
	 zqRdEDlzG7rVlpmMiKRyV+BFZ3OaKYlMGa0cAXndLG6oy8yxnQ7kkT+qfmmFdfxxpT
	 zxf0yCmyTuKUPGSxyi7N8I22P0B+SgxUvh6PRdAtZD/OlS4vTSvK3q09waOS9rZWz0
	 WoqZbaFpehRUQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 06/18] kho: add a struct for radix callbacks
Date: Fri,  5 Jun 2026 20:34:39 +0200
Message-ID: <20260605183501.3884950-7-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
In-Reply-To: <20260605183501.3884950-1-pratyush@kernel.org>
References: <20260605183501.3884950-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0C6F218000C
X-Rspam-User: 
X-Stat-Signature: fpyg5exn35gy15o6b86pe5woha1af7no
X-Rspamd-Server: rspam08
X-HE-Tag: 1780684527-455960
X-HE-Meta: U2FsdGVkX18HYqOw4sejEmBfhDi/s+iX66nCjQaa7kAvJQ9ve6oKKYgxTLvTp3fzqwFG35lkUjCfSApmnBRJvXUJ0Y2d5UKmfTddLZsP/VC+4hNchF5V6eaOuSdlxKxwv57rvjd3YHzUlrSvUzYNHGr2oGB290KuSpWOa3IP47aC4hlRnkqQKQDYcH9tB51VP7kQKuqTXYkvr3lFwHoMTeuh+kM3sdsthM1ZydhJgE7+qBxrWTv9UFHehgQOmJ1DB+Ad9ceFgmN0Ts48V5OP0yCKe0P9q4y9n2nIc3BhlJbqE9KGwMPyQYsPPCIZlGhHTiwK1Z9V4m2BmD5H92gFrc9th89a98WNM8GbUUaw9HbsFUKsvIanZTHHKKZ5DzqndsZ6u89hIA4ni2cyQC2aL2Oj53Mj7NgacK9caYu9LeLvqZDKT9ETWhD27k3GPpW7FVx0O6AFenTBEipQ1be0cPnWYBHlMiEbeiSLauYTVj65TBav634noVkYQBVBTqK6T2GgxtRAVsLT794VRmmaWD3PTNN6wsLFqwS4bpHpswFAM4rboGy5m9H+/plxbYxL8bxmcc7UgfmXg0cUmeAqXzwXhD6grLbNM5xAQEiMuP1TcHhR2bnloju5M0MpPVGgPWbmGlNBXuJRbyrMFfow+8SeUnlLtanoa+w9P/eKBcci/6s5gzUFmLhWYNCaEfqHAhdOjJ32Ljfm1upaS/dgFtgB0pOBvHGihAS8F+scZAF2yzW9QtKk2xcBSp/kA6VBkKInqbNVTASR4btfGc5FBNvHI/RmYVpmO1v4hDc0MMPzNeuaJShW2t0l9rtGuDGYdRp0q2L8PGaXPhzn5clTqKe6RrxjS8B3i/LSDeDjY0CfRIyCYCaw1fSxudxwybXc8fD78klE4FZeH+Ph0jGY3WOvzn0KCOW1s7ReRKOpJ82lTuF/sDQTjetd/r8yndlZe3Ga/c5rzr5fBOGJCRd
 zjh0Vwuj
 +R53JO2tbt06bK/uLiXGvqu5lAq5mwCvyXirgyP4cnTPeKX9zmXLSj+zM/68GN21WHp1WXBui5z4/MLH/dQh1ZBQUhkv/faCeVMj8TeaLjG6TK77ECVN66dzc7SzZxjlC/KdQCOz+sShp/YTNfdngZ0fsXC/Dwo8OoSCNkkrvXsjHk+2TFvbjbq0Xt74AdKZDsfEokTCWXKozruI8M5OxxB9HqXbZkFllf/RhWKAnCVxC5+g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

A future commit will add more callbacks for the KHO radix tree. Add a
struct for collecting the callbacks.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/kho_radix_tree.h     | 15 ++++++++++++---
 kernel/liveupdate/kexec_handover.c | 27 +++++++++++++++------------
 2 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho_radix_tree.h
index f368f3b9f923..426a9cc9bcde 100644
--- a/include/linux/kho_radix_tree.h
+++ b/include/linux/kho_radix_tree.h
@@ -34,14 +34,23 @@ struct kho_radix_tree {
 	struct mutex lock; /* protects the tree's structure and root pointer */
 };
 
-typedef int (*kho_radix_tree_walk_callback_t)(unsigned long key);
+/**
+ * struct kho_radix_walk_cb - Callbacks for KHO radix tree walk.
+ * @leaf:      Called on each present key in the radix tree.
+ *
+ * For each callback, a return value of 0 continues the walk and a non-zero
+ * return value is directly returned to the caller.
+ */
+struct kho_radix_walk_cb {
+	int (*leaf)(unsigned long key);
+};
 
 #ifdef CONFIG_KEXEC_HANDOVER
 
 int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key);
 void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key);
 int kho_radix_walk_tree(struct kho_radix_tree *tree,
-			kho_radix_tree_walk_callback_t cb);
+			const struct kho_radix_walk_cb *cb);
 
 #else  /* #ifdef CONFIG_KEXEC_HANDOVER */
 
@@ -54,7 +63,7 @@ static inline void kho_radix_del_key(struct kho_radix_tree *tree,
 				     unsigned long key) { }
 
 static inline int kho_radix_walk_tree(struct kho_radix_tree *tree,
-				      kho_radix_tree_walk_callback_t cb)
+				      const struct kho_radix_walk_cb *cb)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 7e556afae283..dbe075348ce4 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -278,16 +278,18 @@ void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key)
 }
 EXPORT_SYMBOL_GPL(kho_radix_del_key);
 
-static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf,
-			       unsigned long key,
-			       kho_radix_tree_walk_callback_t cb)
+static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf, unsigned long key,
+			       const struct kho_radix_walk_cb *cb)
 {
 	unsigned long *bitmap = (unsigned long *)leaf;
 	unsigned int i;
 	int err;
 
+	if (!cb->leaf)
+		return 0;
+
 	for_each_set_bit(i, bitmap, PAGE_SIZE * BITS_PER_BYTE) {
-		err = cb(key | i);
+		err = cb->leaf(key | i);
 		if (err)
 			return err;
 	}
@@ -297,7 +299,7 @@ static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf,
 
 static int __kho_radix_walk_tree(struct kho_radix_node *root,
 				 unsigned int level, unsigned long start,
-				 kho_radix_tree_walk_callback_t cb)
+				 const struct kho_radix_walk_cb *cb)
 {
 	struct kho_radix_node *node;
 	struct kho_radix_leaf *leaf;
@@ -337,18 +339,16 @@ static int __kho_radix_walk_tree(struct kho_radix_node *root,
 /**
  * kho_radix_walk_tree - Traverses the radix tree and calls a callback for each key.
  * @tree: A pointer to the KHO radix tree to walk.
- * @cb: A callback function of type kho_radix_tree_walk_callback_t that will be
- *      invoked for each key in the tree.
+ * @cb:   Set of callbacks to be invoked during the tree walk.
  *
- * This function walks the radix tree, searching from the specified top level
- * down to the lowest level (level 0). For each key found, it invokes the
- * provided callback.
+ * This function walks the radix tree, searching from the top level down to the
+ * lowest level (level 0), invoking the appropriate callbacks.
  *
  * Return: 0 if the walk completed the specified tree, or the non-zero return
  *         value from the callback that stopped the walk.
  */
 int kho_radix_walk_tree(struct kho_radix_tree *tree,
-			kho_radix_tree_walk_callback_t cb)
+			const struct kho_radix_walk_cb *cb)
 {
 	if (WARN_ON_ONCE(!tree->root))
 		return -EINVAL;
@@ -1414,6 +1414,9 @@ EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
 
 static void __init kho_mem_retrieve(void)
 {
+	const struct kho_radix_walk_cb cb = {
+		.leaf = kho_preserved_memory_reserve,
+	};
 	const void *fdt = kho_get_fdt();
 	int err;
 
@@ -1427,7 +1430,7 @@ static void __init kho_mem_retrieve(void)
 	kho_in.radix_tree.root = kho_get_mem_map(fdt);
 	mutex_init(&kho_in.radix_tree.lock);
 
-	err = kho_radix_walk_tree(&kho_in.radix_tree, kho_preserved_memory_reserve);
+	err = kho_radix_walk_tree(&kho_in.radix_tree, &cb);
 	if (err) {
 		/*
 		 * Failed to initialize preserved memory. Clear FDT and radix
-- 
2.54.0.1032.g2f8565e1d1-goog


