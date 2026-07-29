Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DA33C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:57:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86D946B0164; Wed, 29 Jul 2026 10:56:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84D6C6B0166; Wed, 29 Jul 2026 10:56:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70BF96B0167; Wed, 29 Jul 2026 10:56:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B3036B0164
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:56:49 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CC1A7A1B29
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:56:48 +0000 (UTC)
X-FDA: 85042116096.12.FFB0562
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 40CBFA0008
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:56:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oA5oYC5r;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785337007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=trIAt7Owq+NOsHv2QvCUvIybDPgpWgsD0BkrTqbEgGE=;
	b=XTKxjgitcvhmIXxHiQ3kFf08o7ItHRjOzna6XZMug06A4KBSMAKVmfLSQ6r5W1Eqox8lo5
	h275k6AvJ0SzIMQv/ZA4QrTAJZwSHt3unnY0t7y2JxxYCvtxqNOpKnjbEHdSi7aD+uB0em
	LvijKOBtgBV3XuCe0jBMmsb9pQt877E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785337007;
	b=3eXfDsrQAV8Rx99HH9aui778o+4V7w6BW0ShZ1NacjVK+fklhigkS0H5cjfwfDz1cjQ837
	aOw3PCJmxBKjZYhkO6eO7DehTY4Kputv88xHVxkCJ3Vj6lt3EPzQgu/tKKruPyrXXOk4Bs
	z3q5KFUtl9jfyZMnt0QUCkbP5ngcEvA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oA5oYC5r;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 191E460A70;
	Wed, 29 Jul 2026 14:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993101F00A3D;
	Wed, 29 Jul 2026 14:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785337005;
	bh=trIAt7Owq+NOsHv2QvCUvIybDPgpWgsD0BkrTqbEgGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oA5oYC5rABn00oqIpHOvYM0IUGUTsPngQrZEJG+UcEXc1VXTixrDXeSC/456CkzNu
	 WJ2/sZAQt13pLkbiL+KszTDDq4OnX6hwkvhEi9OtJ0utRFESSgMVzRcjGvJ3rXpILu
	 BdIUeDEXfSSHqNHInRia4LM/h34444iPjb8rS4rO1sQK9cXQVj9b5SoIxa52ZmfRd9
	 KnrZUO5+W2rwGaG/hR9uIRiJe/7HxlSE+Er7VOm1SnMksaFXGak2UQgyvJRY2VNQ6U
	 qwClm8qAnh85cmokdG09vMdu9HnM0qj1/rj6bc9ZNvv9mrft6nPQxbALXJkcmKWcuk
	 Bo0F24eJBfqhw==
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
Subject: [PATCH v5 09/22] kho: add data argument to radix walk callback
Date: Wed, 29 Jul 2026 16:55:54 +0200
Message-ID: <20260729145610.2827231-10-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <20260729145610.2827231-1-pratyush@kernel.org>
References: <20260729145610.2827231-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 40CBFA0008
X-Stat-Signature: h41sy3873yaa8m13ybhdeb9s8z9qp4cd
X-Rspam-User: 
X-HE-Tag: 1785337007-237882
X-HE-Meta: U2FsdGVkX19iUxqKkPQbTsrVV4hMeZy/T7eYKa/g4PWWWrwXSqGK855j4kDRM9lOcxxmSGUyDs2BkgPeys4DVq6hc4t948yQHMPcGaTtAkkkP77s/vQh3uAD//O38fflynX5FfhQBgw6KKJLARjpKKpmlfVOE59Sq5YFzUmrBm0tpPJZT5/SkwpgHsDyqvBhDlwlR2yTuu+nvP5gQFQWKwark65nEHWBZQWYmnLvYzZohebNRIldDcphlebSoHvghc1RAAxaUGH279LBbRqnhAXWtB+wGkLws3aR2fuyxvRCh1q8HEoQbMJ/lF9pCCLPqf2pzhIAjfM3SbJOQpXk/P9Mp4hHE7wv8zOeZ51YveDMLgrWI4B/yoPv1RlQbkzCEP18FZ6f28qRH9fSYQHp3GxLi0U7a09ixBgMWC83nL5MVhdmQ517eeCGbPClHggW294mfW6m4xfNdrn4anlq/vcuVMGgVhsX7aVG7WxA1EBxfqaJV8KcFpkrITckpThsSuUykgkI/j+G1S/6ZRvrPvvZhgpD+MtbkVuoUGPqfsVpVeD4/UtvX7cm10w6lqG8BWTK5h552HcJBezFGEO5TCovPOzlVp5rxQT+BAOlovw0K39FxQ9jrkzsBXr0plF3hyzYmiL7Jwi15zUP8+0DfPga891XJXpsaoSUhVD0O9GwTrxI08TRoMuA6JBb6CiMOEoLPcGypijH6wu63UmeIPeFunASN8L9GlP1CjhP2XD/TzKKkLp3J6z4Jdhpngs8+qMHZb9Fr50NhEpTIJBWgAcUYl8H3i98J9BGXQYuIQOmhPE8RM7OD/3UFG2HO3QGijUaHes4+CXo7+NCLfAVn5zlew+RRNpYMZNkpbH0D39TXi+g/+yZZzTYfsYkFb9WVvVt0fSCD0u9Uic0Jz8uQqHvqJbZ+FrXCUixDf1jhZ5YYFyY3nesMwtgD/Ob04sxV0o3jMck8Rr4MVq+G7A
 M07O19ui
 S/JykGcN5vHfjspQnSiEXpZOkhCswyzcTYGdfAbaFA8bX5JE9lhWdWINStD2uJUA1/5fHLNixjD8Kteye0ymc94QzTZqwhm2S4ltM8OeRcYWuwqcXJchF9uJUt8MikyM2+Wocf/gd3mlUJ0PKfOpeIV9CCuUOf425CjhuZAWofMBBpT0tyudTJ39jfWkQw3ZKbcq5ysOOu9PNe+B73wJJ6BAwKB8eb9asISEXgrtXoUueqLgIvyZX1+XDiUzBMHbrFKmgRGntNuV9wJ4VeE2wMKKDmYttKPWjTMgO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Add an opaque data pointer argument to kho_radix_walk_cb_t. This can be
used by callers to pass extra information to the callback.

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/kho_radix_tree.h     |  8 ++++----
 kernel/liveupdate/kexec_handover.c | 24 +++++++++++++-----------
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho_radix_tree.h
index ac7ba7e567e1..4138621e0e87 100644
--- a/include/linux/kho_radix_tree.h
+++ b/include/linux/kho_radix_tree.h
@@ -44,8 +44,8 @@ struct kho_radix_tree {
  * return value is directly returned to the caller.
  */
 struct kho_radix_walk_cb {
-	int (*leaf)(unsigned long key);
-	int (*node)(phys_addr_t phys);
+	int (*leaf)(unsigned long key, void *data);
+	int (*node)(phys_addr_t phys, void *data);
 };
 
 #ifdef CONFIG_KEXEC_HANDOVER
@@ -53,7 +53,7 @@ struct kho_radix_walk_cb {
 int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key);
 void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key);
 int kho_radix_walk_tree(struct kho_radix_tree *tree,
-			const struct kho_radix_walk_cb *cb);
+			const struct kho_radix_walk_cb *cb, void *data);
 
 #else  /* #ifdef CONFIG_KEXEC_HANDOVER */
 
@@ -66,7 +66,7 @@ static inline void kho_radix_del_key(struct kho_radix_tree *tree,
 				     unsigned long key) { }
 
 static inline int kho_radix_walk_tree(struct kho_radix_tree *tree,
-				      const struct kho_radix_walk_cb *cb)
+				      const struct kho_radix_walk_cb *cb, void *data)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 2044f35cf1de..3dd26d5d3c09 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -282,14 +282,14 @@ void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key)
 EXPORT_SYMBOL_GPL(kho_radix_del_key);
 
 static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf, unsigned long key,
-			       const struct kho_radix_walk_cb *cb)
+			       const struct kho_radix_walk_cb *cb, void *data)
 {
 	unsigned long *bitmap = (unsigned long *)leaf;
 	unsigned int i;
 	int err;
 
 	if (cb->node) {
-		err = cb->node(virt_to_phys(leaf));
+		err = cb->node(virt_to_phys(leaf), data);
 		if (err)
 			return err;
 	}
@@ -298,7 +298,7 @@ static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf, unsigned long key,
 		return 0;
 
 	for_each_set_bit(i, bitmap, PAGE_SIZE * BITS_PER_BYTE) {
-		err = cb->leaf(key | i);
+		err = cb->leaf(key | i, data);
 		if (err)
 			return err;
 	}
@@ -308,7 +308,7 @@ static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf, unsigned long key,
 
 static int __kho_radix_walk_tree(struct kho_radix_node *root,
 				 unsigned int level, unsigned long start,
-				 const struct kho_radix_walk_cb *cb)
+				 const struct kho_radix_walk_cb *cb, void *data)
 {
 	struct kho_radix_node *node;
 	struct kho_radix_leaf *leaf;
@@ -317,7 +317,7 @@ static int __kho_radix_walk_tree(struct kho_radix_node *root,
 	int err;
 
 	if (cb->node) {
-		err = cb->node(virt_to_phys(root));
+		err = cb->node(virt_to_phys(root), data);
 		if (err)
 			return err;
 	}
@@ -338,10 +338,10 @@ static int __kho_radix_walk_tree(struct kho_radix_node *root,
 			 * node is pointing to the level 0 bitmap.
 			 */
 			leaf = (struct kho_radix_leaf *)node;
-			err = kho_radix_walk_leaf(leaf, key, cb);
+			err = kho_radix_walk_leaf(leaf, key, cb, data);
 		} else {
 			err  = __kho_radix_walk_tree(node, level - 1,
-						     key, cb);
+						     key, cb, data);
 		}
 
 		if (err)
@@ -355,6 +355,7 @@ static int __kho_radix_walk_tree(struct kho_radix_node *root,
  * kho_radix_walk_tree - Traverses the radix tree and calls a callback for each key.
  * @tree: A pointer to the KHO radix tree to walk.
  * @cb:   Set of callbacks to be invoked during the tree walk.
+ * @data: Opaque data pointer passed to each callback in @cb.
  *
  * This function walks the radix tree, searching from the top level down to the
  * lowest level (level 0), invoking the appropriate callbacks.
@@ -363,14 +364,15 @@ static int __kho_radix_walk_tree(struct kho_radix_node *root,
  *         value from the callback that stopped the walk.
  */
 int kho_radix_walk_tree(struct kho_radix_tree *tree,
-			const struct kho_radix_walk_cb *cb)
+			const struct kho_radix_walk_cb *cb, void *data)
 {
 	if (WARN_ON_ONCE(!tree->root))
 		return -EINVAL;
 
 	guard(mutex)(&tree->lock);
 
-	return __kho_radix_walk_tree(tree->root, KHO_TREE_MAX_DEPTH - 1, 0, cb);
+	return __kho_radix_walk_tree(tree->root, KHO_TREE_MAX_DEPTH - 1, 0, cb,
+				     data);
 }
 EXPORT_SYMBOL_GPL(kho_radix_walk_tree);
 
@@ -501,7 +503,7 @@ static struct page *__init kho_get_preserved_page(phys_addr_t phys,
 	return pfn_to_page(pfn);
 }
 
-static int __init kho_preserved_memory_reserve(unsigned long key)
+static int __init kho_preserved_memory_reserve(unsigned long key, void *data)
 {
 	union kho_page_info info;
 	struct page *page;
@@ -1445,7 +1447,7 @@ static void __init kho_mem_retrieve(void)
 	kho_in.radix_tree.root = kho_get_mem_map(fdt);
 	mutex_init(&kho_in.radix_tree.lock);
 
-	err = kho_radix_walk_tree(&kho_in.radix_tree, &cb);
+	err = kho_radix_walk_tree(&kho_in.radix_tree, &cb, NULL);
 	if (err) {
 		/*
 		 * Failed to initialize preserved memory. Clear FDT and radix
-- 
2.55.0.508.g3f0d502094-goog


