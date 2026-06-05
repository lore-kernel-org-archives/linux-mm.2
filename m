Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91900CD8C83
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 18:35:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA0616B0088; Fri,  5 Jun 2026 14:35:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D78166B008C; Fri,  5 Jun 2026 14:35:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8D986B0092; Fri,  5 Jun 2026 14:35:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE5546B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:35:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 496B040271
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:17 +0000 (UTC)
X-FDA: 84846711474.05.9C2B426
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id A23E1160007
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SXN+/qOS";
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780684515;
	b=3+tHhtaHS65d9H3UPnd4bY8YWBq9sFdjukrY38GMlH2WWu6bP2xamjswlZBsrxt2cUjs4M
	2zGV84LSDRKLEPADqICDdwUfpERHOdGpGxliiK1oV0LZSQQAsBaAz57gwmPn0JkSawEXMi
	FZZw6BVvN3LvwIHhkHaeqQ5MZQ3gPIU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SXN+/qOS";
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780684515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rkbkFtqpt3sYkBM3VkUIpTALQ213CQ+IiAxeYtzN8vI=;
	b=HjljzaZtOr9H9phz1Yt8davg19EsnchkEdnaEcZYOB8gT+w/9y7eIQ3N+6uELmcTDZMg2E
	mreuUAeZdBFR4PimO9BT2QlurMM32IUla1OIFdX7sFqhQfWDoM61JSVydAruY7UlSAYXxg
	dXe80BseLRdXTJf5rV0tsZBuK9z0NQQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2DB8E601DB;
	Fri,  5 Jun 2026 18:35:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C352D1F00898;
	Fri,  5 Jun 2026 18:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780684514;
	bh=rkbkFtqpt3sYkBM3VkUIpTALQ213CQ+IiAxeYtzN8vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SXN+/qOS0mYT0P7lGbZkzsjqLv4mH5Hg1qm196JtmR3WJzUqiAvHYpLTZMOOcor+0
	 M2H+j+K9Or619ubBiJiQo5TLVtpMx82tyvP+Wf+pwmHtR1xGFFRnc/E3iNq5IqAqFd
	 kGTsTqic+vBJjx9yq9nCeILOucactdDNjJ5oF+T6L5L/4e3tk9bW+Hax3ZKA4n0upp
	 gpcEk6hawR6o2hgbwcRZ7OnP8/xNjmxk8bhx0M8XV4WMb2VoFEq3F94d8i2GfDBdrU
	 ImeoaXqEReRH5YuNfMBswww2PXjI4s03LNominlNeVf2wKfXWz8XplSHsI1dYkbRy2
	 sK0AtL9AZ5ZWA==
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
Subject: [PATCH v2 01/18] kho: generalize radix tree APIs
Date: Fri,  5 Jun 2026 20:34:34 +0200
Message-ID: <20260605183501.3884950-2-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
In-Reply-To: <20260605183501.3884950-1-pratyush@kernel.org>
References: <20260605183501.3884950-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A23E1160007
X-Rspam-User: 
X-Stat-Signature: ei8pxyycyfk48hgaobqozghe8bioufj9
X-HE-Tag: 1780684515-128407
X-HE-Meta: U2FsdGVkX18vqERRuaS/Ogtl/WyLEpFV1QE0b9QvozBVso5QF3IjuoFt4EZZgzXWIo9p8aW2M9a/K3GwKXl9xKREN6pXuLnr10hJP6YoKVUYmZ/o+Scu+P7zmKqsKF1bj1mvoCan6ksKNUToIBE+AdMNiRzMOpGunwmYXkeeIT13zfdDDKtvRgby+KxL/vMjt0ujBLB5jXmAF/hX5J9+NP9evuO8nCesbXpBNZM8l/YY25JZJzhNU9QW1RemR3t/qJuHzJwlfm9h/HNW+yISogwYUV8N3EGfxl2ZBFObPHEBHcg47Ej6ojP9VOMu6XDWFejRvmxy4RZOsLDMAjp0g3YKXe1VpmWOVVnL4skvJBDp34yAF+bnyMTVk1G7aE3dyRs/AQwEvfTLFk/8Z8s5FXkCsB1/E+G4eJsRda4R8hcJ4/wlJxOo7vEkQf14jQGewTULv6IuIybA4oSpqZWzk/O0W183Tt8sxONczFSqjfooNLU9XbKZGylSZZgMofslHL8S4flxW4Ut2MtLRDxfrG4++6KNq706uNFe9dDfzZ+zDG0ocONCj8xJWdGTT/Zqc9DGdZKrHA9glR+tysGZiSrnxTL8gTqHHlVSsinHOaiV18JqcmTfkuwyCjYAvzonsAZROf7YY91bdCiRhoQxFeFEeZClbfenXeVv8HGkh/ajdtNovDaIQD9aChAAV8mSrS85e0uBHzJcbzuK/nuwdksqe+yEelMDqpYjub5A+ReTsrVa3KAW9OJCfM1BCwzo2U7szCvEsT3WBMj74mzTBaN4GLGiV1ARIDc5apj0AEF+fhFvZ8at5QRmLk6rD4HTDaIrIyj3XLt0wiiI0Ne3wu55sH0K4to5wr0yLSUL9lwQQO2FGdR3Jn4MfTqplKBhgvMxHKd6r99YBIYVEuQOGrXDJN2shkFBIOzzyWDnof5gu37BBW+lLNtNpkQoCBeoFE3Cu4f6r7hypYCthjp
 xvQR44BQ
 w8ukVszDf7fBu8wHhnLaBB9QqsddL8E6/v7RRnlpNbs7ua5Hf43OPWaaWK/2my6NwM7tfM0BwBHLzvUONBzEe/aFQL6tBeYJVzITMwqhrJmLzA8MFXnvA6OG3Mkt5srFTkgBoKdph8FvCfTjio0Ipd2jt890xMAe9ZSfPnXu+FlgGvkZtVQEPJqoHAe6C72D14TKIZJ0YARYjjhtBmAI9ax0e82nrnXpCppohlkWit9bx7PZNJeMNQutzl65xmNeE+WRbqseDRuuoV0vMugYhPGZb9wKvmLvBMXJy
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
2.54.0.1032.g2f8565e1d1-goog


