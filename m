Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 419EAC54FCD
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 08:49:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D26606B009E; Sat,  1 Aug 2026 04:49:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD6B26B009F; Sat,  1 Aug 2026 04:49:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C148C6B00A0; Sat,  1 Aug 2026 04:49:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9FA5A6B009E
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 04:49:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0C1EF1A0266
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:24 +0000 (UTC)
X-FDA: 85052076648.23.4072277
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4ABC014000B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lIthDNSy;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785574162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XNgyD4SOWKFNe9Izm+Nzxp4NQgOd4T3wYTp8t2mLDNM=;
	b=ry+Tw0GsNQeKkFnJVyjZ9RL7TmAHKgUF3m13LvfgiDMTE9Qou1FcdzWBOhRHf/yQqkWsEg
	/ytq50CzwwxUiRt5KXOaSKUS75cpWMWwDzELTuv8Fu57oK/APV83KKeudIXSToAarfCIFl
	YxWnN2X52p8FVxbcanAk1nIzvzBmQqI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lIthDNSy;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785574162;
	b=VMsEvwN6COG2GFsUt/TQE0DnnCPQkdoEcm2MSyoU6JqIx0GoDNOo0v/J6sGkrwd+m677i/
	Qul2KjN6PiHbPQ0DlwKpwG3/F1WhFPlUssrCoHAXFKqxCkN/9FP8jgLJzf6vMzgLdeaaqa
	fhzqAL+EKsSQQuaO6niJaOsC7pyYWpg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC4AE452B5;
	Sat,  1 Aug 2026 08:49:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC5D1F00ACF;
	Sat,  1 Aug 2026 08:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785574149;
	bh=XNgyD4SOWKFNe9Izm+Nzxp4NQgOd4T3wYTp8t2mLDNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lIthDNSy0aXfb6XajVGZ/pNVTaDscF9eSGuWw+2YxyfporzOSHAp+NcDsWeWQQsMV
	 vS0sqCTwPq1zJ7Wsj0UTGoPecmOVIqAd1ZQyjs83LAiy/rldf3nIgkwEwkvJ2+TygU
	 EsvGeR+Hzt16AO7rAyyOJHe4P7VoIOYXVqnonOpYKBwEy65Wq7LA4WGiARaz1ALjp3
	 AgP96sGbaSobbJiwIGvFcIrTKvBRUW86MdBKs+JjJF/UCpRVyIzyepVhm/RFeu5xQq
	 1kFeFANT6mc/brEa6Z4RuX4+oD3D38OXABBZPSUy33vvo09bnfqNsyRaNixcLkotmx
	 fuLUQSdl4heFw==
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
Subject: [PATCH v6 07/22] kho: add a struct for radix callbacks
Date: Sat,  1 Aug 2026 10:48:16 +0200
Message-ID: <20260801084833.1897543-8-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
In-Reply-To: <20260801084833.1897543-1-pratyush@kernel.org>
References: <20260801084833.1897543-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4ABC014000B
X-Rspamd-Server: rspam01
X-Stat-Signature: 34agf34upt4i6eui6pdz4s8154ydg3bj
X-HE-Tag: 1785574162-848222
X-HE-Meta: U2FsdGVkX19n86P/XudYjzKfPHSjP7W02Ao0v/Hpdp5qQXiOLMS+YQVulcv+CwMmHQvnaQzClp7t0l4R46GHfWqd5rpKXjCSKu+rEJd+6tQ1cJHUVTNXEouWmE2TiRndV7RooFq8G+q7IgEemBN66X3wCgEMMs6sC2ZCgnK2s2Bc5JYeubjD8jQuzS3HAQbNaPQlqxcsjIBRQwzP85B4kQQhFS8/5TArR4roJ0H9f5M9hEsQn//IJdI5+vlrZfehd39RS+nErhMcRgk6vVWPP6y/wvj5NwyEOg5wT2Xdm0daz5bHqYHun3LPdci/Rx/2yV+YvWPlRZk9UQCk8gxcgK1JdcO/u6LTiFtHpiVDoZcmtALNW50Dgyj/dNw+91eWbZsW49P4Heux1NmxHxWpZQ9fP5+58QoofdT2KNbZf7DnN3SRyG0Vo9ZQZBdqG+A4b4pSnLwb3EKtfX+AD9iwMTQfpnIL9P4265fzCVNS4TglHF8FWXlcPbCF57QTMO8oHcC8U8HhM8+TYQFEZzSnk4vgbK1UxGxapAI2OwGeNxrOrrVJgYZGFsrQaKTmxth9E3cpc+QEosVEogAHPDWQMPHK0By1CRpbGQjdvhkgsFbgChDpoRNLtiGq68KkLICHuVyD/bnrTIc3Tyqw8sdrsml9RINzrvhkttI7Nqzw+fb/a67xuypJ8K2yGD0nj61ql45uvmyg9fp77t+i1bCllOvQQ5QFyzbFZOuoUdaiPqHSTPzZ+FiNgEp6+tkspmT4Dxx1Q9/SL5y1o/mh7rbrylQP1v85uN+YRUSMg7ICKWs4M781wqrGbklMIhndSIa+TlDfrZc4vZgYvWLpjf5mg8Q/06t0qMm1Lqt3AfqNhCaAaWwL2ik/BZzu/asWxc5xJOsgLU6vV5e6fBmZq86vJsRRBCbRKSVK1D0ghn4KKVmY4FMxSqNuzzgkNgMhn+R+Vitaol1t7pQKrI2d5v6
 6Cr4fWns
 WHQWGyBg08q/jM9E2EX59GARQ1NOSKkv1TTC+htT+itoMCk5HF7zZ6jwS1siLOaQZqDUJNsNQvwEPhH6PruxKRL3mLSwQZn5u0YapPYLzOf20XftAkrcILQJijI/nucfDeY2DEPVdIuGgg6FRCD7o6ZWG6xxN6e9PGcb1t4wMu5qbnMZ4WZydAKg/3xX5M9u0vj9eXMWJflq11wSpolWEnfqgpaNMIg6dN6CUD5IyLtz2zFU=
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
index 9157fe08f9ce..486e193d58f4 100644
--- a/include/linux/kho_radix_tree.h
+++ b/include/linux/kho_radix_tree.h
@@ -38,14 +38,23 @@ struct kho_radix_tree {
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
 
@@ -58,7 +67,7 @@ static inline void kho_radix_del_key(struct kho_radix_tree *tree,
 				     unsigned long key) { }
 
 static inline int kho_radix_walk_tree(struct kho_radix_tree *tree,
-				      kho_radix_tree_walk_callback_t cb)
+				      const struct kho_radix_walk_cb *cb)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index e3408e1844dc..9fb07c0ef18e 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -281,16 +281,18 @@ void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key)
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
@@ -300,7 +302,7 @@ static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf,
 
 static int __kho_radix_walk_tree(struct kho_radix_node *root,
 				 unsigned int level, unsigned long start,
-				 kho_radix_tree_walk_callback_t cb)
+				 const struct kho_radix_walk_cb *cb)
 {
 	struct kho_radix_node *node;
 	struct kho_radix_leaf *leaf;
@@ -340,18 +342,16 @@ static int __kho_radix_walk_tree(struct kho_radix_node *root,
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
@@ -1417,6 +1417,9 @@ EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
 
 static void __init kho_mem_retrieve(void)
 {
+	const struct kho_radix_walk_cb cb = {
+		.leaf = kho_preserved_memory_reserve,
+	};
 	const void *fdt = kho_get_fdt();
 	int err;
 
@@ -1430,7 +1433,7 @@ static void __init kho_mem_retrieve(void)
 	kho_in.radix_tree.root = kho_get_mem_map(fdt);
 	mutex_init(&kho_in.radix_tree.lock);
 
-	err = kho_radix_walk_tree(&kho_in.radix_tree, kho_preserved_memory_reserve);
+	err = kho_radix_walk_tree(&kho_in.radix_tree, &cb);
 	if (err) {
 		/*
 		 * Failed to initialize preserved memory. Clear FDT and radix
-- 
2.55.0.571.g244d577d93-goog


