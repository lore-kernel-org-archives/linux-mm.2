Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5D57C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 17:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57F246B0093; Thu,  9 Jul 2026 13:38:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 556D96B0095; Thu,  9 Jul 2026 13:38:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46D646B0096; Thu,  9 Jul 2026 13:38:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2358F6B0093
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:38:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DA7671201F7
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:38:37 +0000 (UTC)
X-FDA: 84969947874.12.5119887
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2DB25C000B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:38:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DcieDXwB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783618716;
	b=c1cfkAGuNQRhHGXpPihlrhoVPBhrAJsCP8tsOCrS5IcF9kCdXGTSS+ffU7zeWo/QL/mk26
	zAz68Z6Ah6p2BHL9M7sl1Cq5CJpBH2ywdc88cPTfP5lys2NAoaoGHyKVfrMtWNmx5w51Ol
	Pb1oxVtTzkAThdqUOT7jOLVRrwYu97s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DcieDXwB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783618716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VACW5hpwHr3C46nVmg5oW6du7Qu5AxNqOMyuHTohAis=;
	b=ol/y4Gc43w+ctwLCsm9ubZxcEElVF44L1CijJ4Q185SkOmT/0fuwb12fzWqknwF5hCSxAc
	xZz3QnHgHUxWKXcX8QjQrXbs8i5z5hNaVCJGxqcADCAZJmBSj6XYWMSuU02EaFD4PdmsGE
	LhaHBcXYJZAeyNEKeDbvTCvLwBUyMlA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 18FCF40780;
	Thu,  9 Jul 2026 17:38:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB08C1F00A3A;
	Thu,  9 Jul 2026 17:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783618715;
	bh=VACW5hpwHr3C46nVmg5oW6du7Qu5AxNqOMyuHTohAis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DcieDXwBx1fSSb27hgRsOomRbw8lUWrVAYQCthTEjEO4zxPai/dqjLWBvvVVr5BWh
	 LOD6k4xLrhsaT83UpFmOc1BNZ1D3Rz32LyIGOcX1eL1WnUJqPwcypwjgPnE/Q/NEnG
	 X4aTbVkyaO0Gk1vaR9dl1bELpQlDGUfmqKEWpMl9hwtXHgLoZy1oLlVd4PuiYd+dL4
	 9hpm1r+kqCZ2GZTCTjB6hB/vtHZuiWUK+9nSlP8JZKtrbFIQDcigzHI8/ltXpqqiPa
	 RZbzbh8o1vr5fwDOiDRx6LyljA5xlCxz97IQ7MohxwLW4tv+y0z6aFeQzcBEG8TMl4
	 rEFsS9oL17J8w==
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
Subject: [PATCH v3 01/21] kho: generalize radix tree APIs
Date: Thu,  9 Jul 2026 19:37:50 +0200
Message-ID: <20260709173821.429921-2-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
In-Reply-To: <20260709173821.429921-1-pratyush@kernel.org>
References: <20260709173821.429921-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2DB25C000B
X-Rspam-User: 
X-Stat-Signature: pnarzee7jya7c3ij83s8pd4eau81y88z
X-Rspamd-Server: rspam03
X-HE-Tag: 1783618716-820766
X-HE-Meta: U2FsdGVkX18JunT4uG/hx4p/9CFVAMfqx/+kYmgh0/st36ngFF3jtnwml15zJ+fJgqn7ai++SvDG3ZOB4E9vkGJGMyd87DrlFtnYue6Fx5VGAF+qFBs2HNVu2w+KRvgxvVxe10+w2OTmNmZ+4PcX8OlFyuzu5sS8ekNzMb820Rtfzp8CnP7dPrqiWl+76KFa8GroHPsi/e1fvQ/6O4iEmKRr9IOQtfARNB49mKFCltyMVv46XKP92ekvxt+BM9dy1EML+MNJbsGQldLZFjdzpc+XuUrEPYMTQSKLWSyTmZ1TymN14MxtzHw7WHsujsKGyoqlAc+MWLmyQEy4ujcPJ5HiyNk8SUZzT0zx5LEqGDVCNAUtJZhxWXtsrd54TBc14rLJXEkgbljVG+qM4ShOEdymUQg/b7bPjErblMs3NfHuycHe16jWKpow5+8jjL0xUMqkD+iBRlPC1WEodVtkdzodz4L7UfGkWdQgs/xH6NeEGW31xAaTnJPva05Bjhr2KQjyqMycfPNBlg0FO21362CPXdI1YJewqpoKijGrnzV6gjkjK3oNjYxP1Ghydhb3LvzIq280H409ZQzBtzl490JfMzzbqBukVFHMcaOdJ9nEMjqpnXtGJQD66+l7O99eysAAUtUwSWWEzK0ZiYtdPfTRVH3Qby2UA7nK5XoCqq+7I6XYPuRkN3Hu0FCM6soh118o6XFR7Zsq//hN1pjohL6P4MUJzSEmmZmmbuU1ZWV9jmYo6nF08URz3j5Gg3/4T+PjFnCK9tE7UC3FHaddFqscqffIt/T2FqZBr/bDrzDmmXxrWK9rXhabtJs7Wq4IABek5VEycuXAq98/6QUiOzUYph/G3+MYCixkIyJnrFsHVLecyxe5ztwFibOZH8kAV/b2mPiY1NQeNSvmZRaN6GS6KB/OPAA5mTOR5t/WZNVGIWg6W3HXxfSy2TtzK5k8JTxQ29sbP/uYbvN64q9
 lBH3o5cS
 35CDEyyiGgMs4g9PN98h8l4lM9rSDcCCZ7y6lNJyndcPYz32iXUaWgxGbFckkEuvj4hak2aeTinHSOXOrj4DafMndXMkN0ftQUjClUUypkHQGgnmYhuBE7jNUnfVHGxRSKGUb3ptG5zAa94X3Dm/eGAdcxgLv/FEjvdrpY67ECDqTsY4+1LVwrdYmwAyWFSO94fYiIEL1rxlh/3XioAk0uDAE7tvh3osuYFzt/nXOUinB8HimaJ4FFBe+AHMAKaix+uLNAZbfUV9RsnldlO8tPVvVSeaiB1AUQPlcxcdHyO5RSQA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

The KHO radix tree is a data structure that can track the presence or
absence of an arbitrary key, with nothing inherently tied to KHO memory
preservation tracking. This was one of the design goals of the radix
tree. This was done to enable it to be re-used by other users of KHO.

Despite that, the radix tree APIs are very closely tied to KHO memory
preservation tracking. Adding a key is done by kho_radix_add_page(),
which encodes it as a page tracking operation and takes in PFN and
order. kho_radix_del_page() does the same. These functions encode the
key internally that goes into the radix tree. kho_radix_walk_tree() does
the same by baking the PFN and order into the callback arguments.

Generalize the APIs by taking the key directly and doing the encoding at
the callers. Rename the functions to kho_radix_add_key() and
kho_radix_del_key(). In practice, this removes a line each from the
functions and moves the encoding function call to the callers.
Similarly, update kho_radix_tree_walk_callback_t to take the key
directly.

Now that key encoding is no longer an inherent part of the radix tree
and can be decided by the user, rename kho_radix_{encode,decode}_key()
to kho_{encode,decode}_radix_key(). This moves them out of the
"kho_radix_" name space into the "kho_" namespace. This emphasizes that
this is KHO's way of encoding the key for its radix tree.

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/kho_radix_tree.h     | 18 +++----
 kernel/liveupdate/kexec_handover.c | 76 ++++++++++++++----------------
 2 files changed, 42 insertions(+), 52 deletions(-)

diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho_radix_tree.h
index 84e918b96e53..f368f3b9f923 100644
--- a/include/linux/kho_radix_tree.h
+++ b/include/linux/kho_radix_tree.h
@@ -34,30 +34,24 @@ struct kho_radix_tree {
 	struct mutex lock; /* protects the tree's structure and root pointer */
 };
 
-typedef int (*kho_radix_tree_walk_callback_t)(phys_addr_t phys,
-					      unsigned int order);
+typedef int (*kho_radix_tree_walk_callback_t)(unsigned long key);
 
 #ifdef CONFIG_KEXEC_HANDOVER
 
-int kho_radix_add_page(struct kho_radix_tree *tree, unsigned long pfn,
-		       unsigned int order);
-
-void kho_radix_del_page(struct kho_radix_tree *tree, unsigned long pfn,
-			unsigned int order);
-
+int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key);
+void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key);
 int kho_radix_walk_tree(struct kho_radix_tree *tree,
 			kho_radix_tree_walk_callback_t cb);
 
 #else  /* #ifdef CONFIG_KEXEC_HANDOVER */
 
-static inline int kho_radix_add_page(struct kho_radix_tree *tree, long pfn,
-				     unsigned int order)
+static inline int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key)
 {
 	return -EOPNOTSUPP;
 }
 
-static inline void kho_radix_del_page(struct kho_radix_tree *tree,
-				      unsigned long pfn, unsigned int order) { }
+static inline void kho_radix_del_key(struct kho_radix_tree *tree,
+				     unsigned long key) { }
 
 static inline int kho_radix_walk_tree(struct kho_radix_tree *tree,
 				      kho_radix_tree_walk_callback_t cb)
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 4834a809985a..7349cc82f6dc 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -85,7 +85,7 @@ static struct kho_out kho_out = {
 };
 
 /**
- * kho_radix_encode_key - Encodes a physical address and order into a radix key.
+ * kho_encode_radix_key - Encodes a physical address and order into a radix key.
  * @phys: The physical address of the page.
  * @order: The order of the page.
  *
@@ -95,7 +95,7 @@ static struct kho_out kho_out = {
  *
  * Return: The encoded unsigned long radix key.
  */
-static unsigned long kho_radix_encode_key(phys_addr_t phys, unsigned int order)
+static unsigned long kho_encode_radix_key(phys_addr_t phys, unsigned int order)
 {
 	/* Order bits part */
 	unsigned long h = 1UL << (KHO_ORDER_0_LOG2 - order);
@@ -106,17 +106,17 @@ static unsigned long kho_radix_encode_key(phys_addr_t phys, unsigned int order)
 }
 
 /**
- * kho_radix_decode_key - Decodes a radix key back into a physical address and order.
+ * kho_decode_radix_key - Decodes a radix key back into a physical address and order.
  * @key: The unsigned long key to decode.
  * @order: An output parameter, a pointer to an unsigned int where the decoded
  *         page order will be stored.
  *
- * This function reverses the encoding performed by kho_radix_encode_key(),
+ * This function reverses the encoding performed by kho_encode_radix_key(),
  * extracting the original physical address and page order from a given key.
  *
  * Return: The decoded physical address.
  */
-static phys_addr_t kho_radix_decode_key(unsigned long key, unsigned int *order)
+static phys_addr_t kho_decode_radix_key(unsigned long key, unsigned int *order)
 {
 	unsigned int order_bit = fls64(key);
 	phys_addr_t phys;
@@ -144,24 +144,21 @@ static unsigned long kho_radix_get_table_index(unsigned long key,
 }
 
 /**
- * kho_radix_add_page - Marks a page as preserved in the radix tree.
+ * kho_radix_add_key - Add a key to the radix tree.
  * @tree: The KHO radix tree.
- * @pfn: The page frame number of the page to preserve.
- * @order: The order of the page.
+ * @key: The key to add.
  *
- * This function traverses the radix tree based on the key derived from @pfn
- * and @order. It sets the corresponding bit in the leaf bitmap to mark the
- * page for preservation. If intermediate nodes do not exist along the path,
- * they are allocated and added to the tree.
+ * This function traverses the radix tree based on the @key provided. It sets the
+ * corresponding bit in the leaf bitmap to mark the @key as present. If
+ * intermediate nodes do not exist along the path, they are allocated and added
+ * to the tree.
  *
  * Return: 0 on success, or a negative error code on failure.
  */
-int kho_radix_add_page(struct kho_radix_tree *tree,
-		       unsigned long pfn, unsigned int order)
+int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key)
 {
 	/* Newly allocated nodes for error cleanup */
 	struct kho_radix_node *intermediate_nodes[KHO_TREE_MAX_DEPTH] = { 0 };
-	unsigned long key = kho_radix_encode_key(PFN_PHYS(pfn), order);
 	struct kho_radix_node *anchor_node = NULL;
 	struct kho_radix_node *node = tree->root;
 	struct kho_radix_node *new_node;
@@ -224,22 +221,19 @@ int kho_radix_add_page(struct kho_radix_tree *tree,
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(kho_radix_add_page);
+EXPORT_SYMBOL_GPL(kho_radix_add_key);
 
 /**
- * kho_radix_del_page - Removes a page's preservation status from the radix tree.
+ * kho_radix_del_key - Removes the key from the radix tree.
  * @tree: The KHO radix tree.
- * @pfn: The page frame number of the page to unpreserve.
- * @order: The order of the page.
+ * @key: The key to remove.
  *
  * This function traverses the radix tree and clears the bit corresponding to
- * the page, effectively removing its "preserved" status. It does not free
- * the tree's intermediate nodes, even if they become empty.
+ * the @key, effectively removing it from the tree. It does not free the tree's
+ * intermediate nodes, even if they become empty.
  */
-void kho_radix_del_page(struct kho_radix_tree *tree, unsigned long pfn,
-			unsigned int order)
+void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key)
 {
-	unsigned long key = kho_radix_encode_key(PFN_PHYS(pfn), order);
 	struct kho_radix_node *node = tree->root;
 	struct kho_radix_leaf *leaf;
 	unsigned int i, idx;
@@ -270,21 +264,18 @@ void kho_radix_del_page(struct kho_radix_tree *tree, unsigned long pfn,
 	idx = kho_radix_get_bitmap_index(key);
 	__clear_bit(idx, leaf->bitmap);
 }
-EXPORT_SYMBOL_GPL(kho_radix_del_page);
+EXPORT_SYMBOL_GPL(kho_radix_del_key);
 
 static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf,
 			       unsigned long key,
 			       kho_radix_tree_walk_callback_t cb)
 {
 	unsigned long *bitmap = (unsigned long *)leaf;
-	unsigned int order;
-	phys_addr_t phys;
 	unsigned int i;
 	int err;
 
 	for_each_set_bit(i, bitmap, PAGE_SIZE * BITS_PER_BYTE) {
-		phys = kho_radix_decode_key(key | i, &order);
-		err = cb(phys, order);
+		err = cb(key | i);
 		if (err)
 			return err;
 	}
@@ -332,15 +323,14 @@ static int __kho_radix_walk_tree(struct kho_radix_node *root,
 }
 
 /**
- * kho_radix_walk_tree - Traverses the radix tree and calls a callback for each preserved page.
+ * kho_radix_walk_tree - Traverses the radix tree and calls a callback for each key.
  * @tree: A pointer to the KHO radix tree to walk.
  * @cb: A callback function of type kho_radix_tree_walk_callback_t that will be
- *      invoked for each preserved page found in the tree. The callback receives
- *      the physical address and order of the preserved page.
+ *      invoked for each key in the tree.
  *
  * This function walks the radix tree, searching from the specified top level
- * down to the lowest level (level 0). For each preserved page found, it invokes
- * the provided callback, passing the page's physical address and order.
+ * down to the lowest level (level 0). For each key found, it invokes the
+ * provided callback.
  *
  * Return: 0 if the walk completed the specified tree, or the non-zero return
  *         value from the callback that stopped the walk.
@@ -484,13 +474,16 @@ static struct page *__init kho_get_preserved_page(phys_addr_t phys,
 	return pfn_to_page(pfn);
 }
 
-static int __init kho_preserved_memory_reserve(phys_addr_t phys,
-					       unsigned int order)
+static int __init kho_preserved_memory_reserve(unsigned long key)
 {
 	union kho_page_info info;
 	struct page *page;
+	unsigned int order;
+	phys_addr_t phys;
 	u64 sz;
 
+	phys = kho_decode_radix_key(key, &order);
+
 	sz = 1 << (order + PAGE_SHIFT);
 	page = kho_get_preserved_page(phys, order);
 
@@ -859,7 +852,8 @@ int kho_preserve_folio(struct folio *folio)
 	if (WARN_ON(kho_scratch_overlap(pfn << PAGE_SHIFT, PAGE_SIZE << order)))
 		return -EINVAL;
 
-	return kho_radix_add_page(tree, pfn, order);
+	return kho_radix_add_key(tree, kho_encode_radix_key(PFN_PHYS(pfn),
+							    order));
 }
 EXPORT_SYMBOL_GPL(kho_preserve_folio);
 
@@ -877,7 +871,7 @@ void kho_unpreserve_folio(struct folio *folio)
 	const unsigned long pfn = folio_pfn(folio);
 	const unsigned int order = folio_order(folio);
 
-	kho_radix_del_page(tree, pfn, order);
+	kho_radix_del_key(tree, kho_encode_radix_key(PFN_PHYS(pfn), order));
 }
 EXPORT_SYMBOL_GPL(kho_unpreserve_folio);
 
@@ -906,7 +900,8 @@ static void __kho_unpreserve(struct kho_radix_tree *tree,
 	while (pfn < end_pfn) {
 		order = __kho_preserve_pages_order(pfn, end_pfn);
 
-		kho_radix_del_page(tree, pfn, order);
+		kho_radix_del_key(tree, kho_encode_radix_key(PFN_PHYS(pfn),
+							     order));
 
 		pfn += 1 << order;
 	}
@@ -939,7 +934,8 @@ int kho_preserve_pages(struct page *page, unsigned long nr_pages)
 	while (pfn < end_pfn) {
 		unsigned int order = __kho_preserve_pages_order(pfn, end_pfn);
 
-		err = kho_radix_add_page(tree, pfn, order);
+		err = kho_radix_add_key(tree, kho_encode_radix_key(PFN_PHYS(pfn),
+								   order));
 		if (err) {
 			failed_pfn = pfn;
 			break;
-- 
2.55.0.141.g00534a21ce-goog


