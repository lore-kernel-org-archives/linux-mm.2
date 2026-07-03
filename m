Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B13CC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 02:08:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E6A46B0169; Thu,  2 Jul 2026 22:08:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C5E86B016A; Thu,  2 Jul 2026 22:08:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 386FC6B016B; Thu,  2 Jul 2026 22:08:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 086F46B0169
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 22:08:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 794F21203CB
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 02:08:40 +0000 (UTC)
X-FDA: 84945831600.28.02B65FA
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf10.hostedemail.com (Postfix) with ESMTP id B9AA0C0007
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 02:08:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aEj+f79L;
	spf=pass (imf10.hostedemail.com: domain of 3pRlHagUKCE457qq3w44w1u.s421y3AD-220Bqs0.47w@flex--praan.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3pRlHagUKCE457qq3w44w1u.s421y3AD-220Bqs0.47w@flex--praan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783044518;
	b=i0GR1hPRPw1JnnoPmRpbsnjAVzzdk+qH4mx5ExOGzWtDiI5Q+r/3NX1OYZOyPNxJJvQRLE
	1nGtPuTsmOkl5N00sbOGylWeCOKwvc0V3OVg96dd7mA0BcVdTKwFban4at9pS9tpeZLO7o
	WZ9ppFZWHhkk2Bl3qxRDQuCEZNHUtiQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783044518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XM5kwFHnX+0cnGF4HO/uD9DD/Pao8oPN685wEM7A8g4=;
	b=6xeamO/fjEo3auPbrWG+qEltRxs876kwdm8g1vE0+X8lMPbfT5YX920bAFNv6UyZFj8dfS
	RbE6YR36R9IIJbDll/svBns4kLK5kjZHQMHK3d4vSri3ozVNHVKOQGJ2FF9M2rkvS7FSba
	G2ur8/T/KCXBLGR7aJ/7ZLr2/t9nbUQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aEj+f79L;
	spf=pass (imf10.hostedemail.com: domain of 3pRlHagUKCE457qq3w44w1u.s421y3AD-220Bqs0.47w@flex--praan.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3pRlHagUKCE457qq3w44w1u.s421y3AD-220Bqs0.47w@flex--praan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2c354050c34so578065ad.3
        for <linux-mm@kvack.org>; Thu, 02 Jul 2026 19:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783044518; x=1783649318; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XM5kwFHnX+0cnGF4HO/uD9DD/Pao8oPN685wEM7A8g4=;
        b=aEj+f79L4A1WOIDqrwLaSCO0znNM7b2sNNF8R8H9yuSqw/Yu+sTzrII/S/2ix+UBnq
         7SU97pjxNnO5F7KVaHzKY0wcq2pOiwudjMna85WggsJ6zTDn3iTjZw6XcZzcDJTwECfw
         zj2rVO3ujECSdvvV2O7YjkAm/5JXO8lrNBzZNIopcx7Bd8ydT1VJKloJ6q5+77AZgyt5
         2b8pG00t7Zf+etvNFbLSNh421Jkt3UmyO+0ObEsEhm8/k8M7yQU0XQTly7mVbANouYe+
         AEenikNOOEnrBdTySjuwLVLlGVogA7uIJ5BVdI5vqxC2LwNbaoDWGrUDIgihZb6NbjSv
         VudA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783044518; x=1783649318;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XM5kwFHnX+0cnGF4HO/uD9DD/Pao8oPN685wEM7A8g4=;
        b=mtvBpFLENok4Vlm8JIiew2rWL6JKz0frXUc/vmyLsv/NpqEIFcdXHGMNEIODsIfotU
         i1NMGmtDYZoGOoiajCeTUBF7qkM/Hrj7EfqAM7qoHREaKJoKt9gUZD2u7NQ2fPHpUpyk
         B4UZmrD0Uuo2R+bh6qkKkzyPyQg5cFKcpwT7v5oahtZ9+hDJy38CP78xLRcCkrR3AWxu
         JqbeYtfxSnqO7NRzfX3ltwqtdN4/MJWb6R5zl7XZ1pvyUIqhy0+yGFo+kRZkOZwT0g6X
         SSGkyg17wSBhcY7oeej04pNSM7cTEQfQUwvsTHEDpZYtYqOxMF7r/aPl3ZT5pfqcTqvm
         GtYg==
X-Forwarded-Encrypted: i=1; AHgh+RpUSyvKfTE8EP6G2i3m0n6XPXfYCKdT371gXHfVJNArLFY+hiLVfbyG9tSc66RZGq/F7VywEKdRHg==@kvack.org
X-Gm-Message-State: AOJu0Yxog5txIzxQxJJWXQ0A3J9gReH+iuRNqYMOjlSY6Obgembzmho+
	tdAnhuPv5xTugjnxM2/Bb678cHHAIaxYWpWLww+91DBt/ubU/8MyybFTXmgcUT5oufSU0M2BHEO
	OPg==
X-Received: from plpn16.prod.google.com ([2002:a17:902:9690:b0:2c8:1ded:d061])
 (user=praan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:291:b0:2c9:e86e:a9f3
 with SMTP id d9443c01a7336-2ca7e6f0ad5mr88741955ad.10.1783044517372; Thu, 02
 Jul 2026 19:08:37 -0700 (PDT)
Date: Fri,  3 Jul 2026 02:08:29 +0000
In-Reply-To: <20260703020832.1731864-1-praan@google.com>
Mime-Version: 1.0
References: <20260703020832.1731864-1-praan@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260703020832.1731864-2-praan@google.com>
Subject: [RFC PATCH 1/4] kho: Introduce infrastructure to track preserved page types
From: Pranjal Shrivastava <praan@google.com>
To: Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Samiullah Khawaja <skhawaja@google.com>, 
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Pranjal Shrivastava <praan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: qxafzt69gg7sg8zbbnnxdty59dj65my5
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B9AA0C0007
X-HE-Tag: 1783044518-799534
X-HE-Meta: U2FsdGVkX18g/dNEiyo/nn/WaUOmSRxNLOp0DLv45MnyuNJRFwXUpRIKLtJRyhpQjqscwhZyxHATTU2h4t1XIJ0a/Lep7GlMLmQrz0qwQ+Bh3+f1UAJFuKf918WBhqYwE+cYldAEdX1ur1v+Mrw38D6QizYumqGiGwhK8Rt6nMWVLTmLRp2PUO75qpiP4pw6In29bWm10cpsD8WDC/Gv1pBHJJ/NNwQCFewI5ltjln57rCkUbEnCa5kP1nvUWrtoFnWYWjZ9Jydy8XxBdI7nqJF7GApovi4r5pakZpsBgbiqygL8OfuoXK+wJo+C883tCZgvbQJO3NiAq4DVO2CFd3ITpmyPx8LgX5ZjLVQxVMs+AYjvi8Bp3gnRT6Ik6Fs8OpPN5W4AWDVciX85WX1d1UD0tTvI40I3gn9StinQyTTTsl8Nn3Hw0dFumyRaEwE1h06euedizfOkHlDZYzEGXmJfanzMuvYHmVAIMNoopM3nijHJJ7ODppDpLHrpu33TnXhvGAzyQbRjLNddMmtNKbpEreWJmjS1PFXcaoDrTUz7o9l6PFyKOfCk5kPx7/gENLBEAzcqmEjXoAdPZW52RYe8ECirK6RGdWnsBf7y+NAqu+qvGgkwHeTwaj3dPpNa95XBl1jprbKcew5regegfFbebV7i/oKCzcgVTKKmNTX9E5B1CaP4/9X/Umr5uKW6QzOU0gjg3+Aw4KOiCGTbMAk/M51LGrg2DjSJZ36GbpfIYi/qOygqcRpjC/zZsgdyvbGVpaavL51I47N6vHZxAw1N0YkNZRltzej2TLLm3BluwrHeT9lie0PYN0Ej/0xGvoXtbjnq+FH/+8wDQw9pZsvhUvei8a79wlSeBnK4ihkNrTOMZcUpHSFS6lW2Itr+Xj86iXHnSJNWWs+Rza35Nh1N6eZJsI8q1DqNcBo0bAV31xD/JIi59DQfsM3wuCxSdpsyr2In0pjpFpGcLmL
 yMi1rzjm
 HMOWG3lLq0SrJ+f05q++hXmuijYBDEMG9CNOh5/iQx2ChsKylH27wsbpwirvyNKPbBmX5hXMHc/1Mo1WeGmfWH4Yz/ZyQaWThgDRaaqoENRQG+YbSlAitC3eLUBjol50SkPIrWMYKaHE++dJ7gpiIf/l6nMkJssY2w8VDt+GoEAyFKVOLOVC5V9Zwy9v1nz51QtDUqt19DRZxE2UhmsbmSyAAxxEuk4dLXRYZS7L5FrF/Kj62ImaGfpaCQNv+E4f2Kaikx3A1tOEqnXs5SH8REUvQ2gCwC2xTSb1Pu32cdWt3yg5Fep++vsxGg7JT9574kbSdJvReNiY4FAjnsSW+zLfIT3qMzWfJ2+IpJBygzJxJr14Ql7Nc8/8c9rmqMnLGk2mEKJZM7CGFViOBBkupjtidLXiRbSbrO8jSnQbmFBZ0Jyn6/9D1cxaKUB64ovfW++Bz6RFj489Q9FR87aQAHzCUsh76zrXG45Xy2fe3MU8cqTTyyynpK8DReT/3a1sFcRdBq7V1GpUhcewU0pzHugOS+IDous/SSuOI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The KHO mechanism currently treats all multi-page blocks preserved across
a kexec as split pages during restoration, i.e. every page carries a
refcount of 1.

However, many kernel allocations, most notably DMA buffer-allocations
via dma_alloc_coherent(), return high-order non-compound pages. In this
unsplit state, only the head page has a reference count of 1, while tail
pages have a reference count of 0.

Restoring these contiguous & unsplit blocks using the current KHO
restore forces a refcount of 1 on every tail page. This causes the
buddy allocator to trigger a bad page state panic on the free path in
the new kernel when CONFIG_DEBUG_VM is enabled, as it does not expect
tail pages of a high-order block to be refcounted.

Introduce a page_type field to track the refcount pattern of preserved
pages to avoid refcounting the tails pages of high-order non-compound
pages during restore.

The type is stored in the unused high bit (bit 63) of the KHO radix tree
key to ensure it survives the kexec journey (ABI), and is stashed in the
page->private metadata during early boot of the new kernel.

Signed-off-by: Pranjal Shrivastava <praan@google.com>
---
 include/linux/kho_radix_tree.h     | 17 +++++---
 kernel/liveupdate/kexec_handover.c | 62 ++++++++++++++++++++----------
 2 files changed, 53 insertions(+), 26 deletions(-)

diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho_radix_tree.h
index 84e918b96e53..9244a3f7a2d4 100644
--- a/include/linux/kho_radix_tree.h
+++ b/include/linux/kho_radix_tree.h
@@ -34,16 +34,22 @@ struct kho_radix_tree {
 	struct mutex lock; /* protects the tree's structure and root pointer */
 };
 
+enum kho_page_type {
+	KHO_PAGE_CONTIG = 0,
+	KHO_PAGE_SPLIT,
+};
+
 typedef int (*kho_radix_tree_walk_callback_t)(phys_addr_t phys,
-					      unsigned int order);
+					      unsigned int order,
+					      enum kho_page_type type);
 
 #ifdef CONFIG_KEXEC_HANDOVER
 
 int kho_radix_add_page(struct kho_radix_tree *tree, unsigned long pfn,
-		       unsigned int order);
+		       unsigned int order, enum kho_page_type type);
 
 void kho_radix_del_page(struct kho_radix_tree *tree, unsigned long pfn,
-			unsigned int order);
+			unsigned int order, enum kho_page_type type);
 
 int kho_radix_walk_tree(struct kho_radix_tree *tree,
 			kho_radix_tree_walk_callback_t cb);
@@ -51,13 +57,14 @@ int kho_radix_walk_tree(struct kho_radix_tree *tree,
 #else  /* #ifdef CONFIG_KEXEC_HANDOVER */
 
 static inline int kho_radix_add_page(struct kho_radix_tree *tree, long pfn,
-				     unsigned int order)
+				     unsigned int order, enum kho_page_type type)
 {
 	return -EOPNOTSUPP;
 }
 
 static inline void kho_radix_del_page(struct kho_radix_tree *tree,
-				      unsigned long pfn, unsigned int order) { }
+				      unsigned long pfn, unsigned int order,
+				      enum kho_page_type type) { }
 
 static inline int kho_radix_walk_tree(struct kho_radix_tree *tree,
 				      kho_radix_tree_walk_callback_t cb)
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 4834a809985a..f829ffdd00f4 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -43,18 +43,22 @@
 
 /*
  * KHO uses page->private, which is an unsigned long, to store page metadata.
- * Use it to store both the magic and the order.
+ * Use it to store the magic, the order, and the type bit.
  */
 union kho_page_info {
 	unsigned long page_private;
 	struct {
-		unsigned int order;
+		unsigned int order : 31;
+		unsigned int type  : 1;
 		unsigned int magic;
 	};
 };
 
 static_assert(sizeof(union kho_page_info) == sizeof(((struct page *)0)->private));
 
+#define KHO_KEY_TYPE_SHIFT 63
+#define KHO_KEY_TYPE_MASK  BIT(KHO_KEY_TYPE_SHIFT)
+
 static bool kho_enable __ro_after_init = IS_ENABLED(CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT);
 
 bool kho_is_enabled(void)
@@ -85,42 +89,52 @@ static struct kho_out kho_out = {
 };
 
 /**
- * kho_radix_encode_key - Encodes a physical address and order into a radix key.
+ * kho_radix_encode_key - Encodes a physical address, order and type into a radix key.
  * @phys: The physical address of the page.
  * @order: The order of the page.
+ * @type: The page type.
  *
- * This function combines a page's physical address and its order into a
+ * This function combines a page's physical address, its order, and its type into a
  * single unsigned long, which is used as a key for all radix tree
  * operations.
  *
  * Return: The encoded unsigned long radix key.
  */
-static unsigned long kho_radix_encode_key(phys_addr_t phys, unsigned int order)
+static unsigned long kho_radix_encode_key(phys_addr_t phys, unsigned int order,
+					  enum kho_page_type type)
 {
 	/* Order bits part */
 	unsigned long h = 1UL << (KHO_ORDER_0_LOG2 - order);
 	/* Shifted physical address part */
 	unsigned long l = phys >> (PAGE_SHIFT + order);
+	/* Type bit part */
+	unsigned long t = (unsigned long)type << KHO_KEY_TYPE_SHIFT;
 
-	return h | l;
+	return h | l | t;
 }
 
 /**
- * kho_radix_decode_key - Decodes a radix key back into a physical address and order.
+ * kho_radix_decode_key - Decodes a radix key back into physical address, order, and type.
  * @key: The unsigned long key to decode.
  * @order: An output parameter, a pointer to an unsigned int where the decoded
  *         page order will be stored.
+ * @type: An output parameter, a pointer to where the decoded type will be stored.
  *
  * This function reverses the encoding performed by kho_radix_encode_key(),
- * extracting the original physical address and page order from a given key.
+ * extracting the original physical address, page order, and type from a given key.
  *
  * Return: The decoded physical address.
  */
-static phys_addr_t kho_radix_decode_key(unsigned long key, unsigned int *order)
+static phys_addr_t kho_radix_decode_key(unsigned long key, unsigned int *order,
+					enum kho_page_type *type)
 {
-	unsigned int order_bit = fls64(key);
+	unsigned int order_bit;
 	phys_addr_t phys;
 
+	*type = (key & KHO_KEY_TYPE_MASK) >> KHO_KEY_TYPE_SHIFT;
+	key &= ~KHO_KEY_TYPE_MASK;
+
+	order_bit = fls64(key);
 	/* order_bit is numbered starting at 1 from fls64 */
 	*order = KHO_ORDER_0_LOG2 - order_bit + 1;
 	/* The order is discarded by the shift */
@@ -148,6 +162,7 @@ static unsigned long kho_radix_get_table_index(unsigned long key,
  * @tree: The KHO radix tree.
  * @pfn: The page frame number of the page to preserve.
  * @order: The order of the page.
+ * @type: The page type.
  *
  * This function traverses the radix tree based on the key derived from @pfn
  * and @order. It sets the corresponding bit in the leaf bitmap to mark the
@@ -157,11 +172,12 @@ static unsigned long kho_radix_get_table_index(unsigned long key,
  * Return: 0 on success, or a negative error code on failure.
  */
 int kho_radix_add_page(struct kho_radix_tree *tree,
-		       unsigned long pfn, unsigned int order)
+		       unsigned long pfn, unsigned int order,
+		       enum kho_page_type type)
 {
 	/* Newly allocated nodes for error cleanup */
 	struct kho_radix_node *intermediate_nodes[KHO_TREE_MAX_DEPTH] = { 0 };
-	unsigned long key = kho_radix_encode_key(PFN_PHYS(pfn), order);
+	unsigned long key = kho_radix_encode_key(PFN_PHYS(pfn), order, type);
 	struct kho_radix_node *anchor_node = NULL;
 	struct kho_radix_node *node = tree->root;
 	struct kho_radix_node *new_node;
@@ -231,15 +247,16 @@ EXPORT_SYMBOL_GPL(kho_radix_add_page);
  * @tree: The KHO radix tree.
  * @pfn: The page frame number of the page to unpreserve.
  * @order: The order of the page.
+ * @type: The page type.
  *
  * This function traverses the radix tree and clears the bit corresponding to
  * the page, effectively removing its "preserved" status. It does not free
  * the tree's intermediate nodes, even if they become empty.
  */
 void kho_radix_del_page(struct kho_radix_tree *tree, unsigned long pfn,
-			unsigned int order)
+			unsigned int order, enum kho_page_type type)
 {
-	unsigned long key = kho_radix_encode_key(PFN_PHYS(pfn), order);
+	unsigned long key = kho_radix_encode_key(PFN_PHYS(pfn), order, type);
 	struct kho_radix_node *node = tree->root;
 	struct kho_radix_leaf *leaf;
 	unsigned int i, idx;
@@ -277,14 +294,15 @@ static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf,
 			       kho_radix_tree_walk_callback_t cb)
 {
 	unsigned long *bitmap = (unsigned long *)leaf;
+	enum kho_page_type type;
 	unsigned int order;
 	phys_addr_t phys;
 	unsigned int i;
 	int err;
 
 	for_each_set_bit(i, bitmap, PAGE_SIZE * BITS_PER_BYTE) {
-		phys = kho_radix_decode_key(key | i, &order);
-		err = cb(phys, order);
+		phys = kho_radix_decode_key(key | i, &order, &type);
+		err = cb(phys, order, type);
 		if (err)
 			return err;
 	}
@@ -485,7 +503,8 @@ static struct page *__init kho_get_preserved_page(phys_addr_t phys,
 }
 
 static int __init kho_preserved_memory_reserve(phys_addr_t phys,
-					       unsigned int order)
+					       unsigned int order,
+					       enum kho_page_type type)
 {
 	union kho_page_info info;
 	struct page *page;
@@ -499,6 +518,7 @@ static int __init kho_preserved_memory_reserve(phys_addr_t phys,
 	memblock_reserved_mark_noinit(phys, sz);
 	info.magic = KHO_PAGE_MAGIC;
 	info.order = order;
+	info.type = type;
 	page->private = info.page_private;
 
 	return 0;
@@ -859,7 +879,7 @@ int kho_preserve_folio(struct folio *folio)
 	if (WARN_ON(kho_scratch_overlap(pfn << PAGE_SHIFT, PAGE_SIZE << order)))
 		return -EINVAL;
 
-	return kho_radix_add_page(tree, pfn, order);
+	return kho_radix_add_page(tree, pfn, order, KHO_PAGE_CONTIG);
 }
 EXPORT_SYMBOL_GPL(kho_preserve_folio);
 
@@ -877,7 +897,7 @@ void kho_unpreserve_folio(struct folio *folio)
 	const unsigned long pfn = folio_pfn(folio);
 	const unsigned int order = folio_order(folio);
 
-	kho_radix_del_page(tree, pfn, order);
+	kho_radix_del_page(tree, pfn, order, KHO_PAGE_CONTIG);
 }
 EXPORT_SYMBOL_GPL(kho_unpreserve_folio);
 
@@ -906,7 +926,7 @@ static void __kho_unpreserve(struct kho_radix_tree *tree,
 	while (pfn < end_pfn) {
 		order = __kho_preserve_pages_order(pfn, end_pfn);
 
-		kho_radix_del_page(tree, pfn, order);
+		kho_radix_del_page(tree, pfn, order, KHO_PAGE_CONTIG);
 
 		pfn += 1 << order;
 	}
@@ -939,7 +959,7 @@ int kho_preserve_pages(struct page *page, unsigned long nr_pages)
 	while (pfn < end_pfn) {
 		unsigned int order = __kho_preserve_pages_order(pfn, end_pfn);
 
-		err = kho_radix_add_page(tree, pfn, order);
+		err = kho_radix_add_page(tree, pfn, order, KHO_PAGE_CONTIG);
 		if (err) {
 			failed_pfn = pfn;
 			break;
-- 
2.55.0.rc0.799.gd6f94ed593-goog


