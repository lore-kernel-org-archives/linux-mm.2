Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7E31FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 13:39:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FDA96B0092; Wed, 29 Apr 2026 09:39:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AE8D6B0093; Wed, 29 Apr 2026 09:39:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C40B6B0095; Wed, 29 Apr 2026 09:39:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EF1E56B0092
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:39:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 91A6CC12CF
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:39:49 +0000 (UTC)
X-FDA: 84711701298.24.03CB0D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id E9B7640019
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:39:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ILHAGPKm;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777469988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BT+hYR2ZBqOBe/6kksgGIhP3GNatf01fnu+2FkPIef0=;
	b=huHD3hhUIX0rhbFR1O6nwmLaLpIx/TjijpzKXFpfcNCRDLuAh3gEyRj3SbnK+WgbyBUcRp
	JyhKujGsYa94mORXiAorWJWjTPdCa7V+LfTyyk1LhhI3TJrgX6vq3y7Q1lxRKIziBIgIlP
	Xi2GQqwwF9CM4hJxMlxRcmNw53nd/oI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ILHAGPKm;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777469988; a=rsa-sha256;
	cv=none;
	b=7i6kkiVb6Pxe0u3NURoMugWd7GECj4q1yJi6EOR+rIYtYarK3crxdQ32hrFbSe4JW6cpjg
	ZnE2Pr6fm8nOf2MxzbD5tJaBGAQ7s5+ruy7/+FttD5qOe4U4oP2PLe3qy7uXKPCPsV5ufH
	qQp4Hqx9UdRYSh25DaBFNkoD6cH3CW0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 460DB60154;
	Wed, 29 Apr 2026 13:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF34C2BCC4;
	Wed, 29 Apr 2026 13:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777469987;
	bh=W0+ckJhEsn7eIzrfoI1DnOLefqerKZn868/JiEjogVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILHAGPKmGDHyVNi0VREVibpKISkqr1yrGqw6ESB7iP3n4Gp3oz4dXodSCc8s0F2gl
	 OFB2QWRS7Rv7D6Ci9YEAApSf7xe/JTKFwPDQHleF1SaYnsqx+aLShgB0/x/Z4IFxwg
	 QIw++581Wh92oxc1GFRx/n9+QRr3hxurUmhcOCYWXLDYiPir9e9yFs+4UnRaPpsyoZ
	 +A7LH1nL/lb3KPSfxs3u0t67ClyBYzj/gsQHJ5f1A6yE4i7VaaKU86+u+h44hgNs4a
	 RukdZowS4TvZBfd/AJzpBFjvvypZ5qrwK4JbOOj0oqmA1Y5DZYm+UqXQROxciUEMd4
	 m9nj0nTdcDfDw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 01/12] kho: generalize radix tree APIs
Date: Wed, 29 Apr 2026 15:39:03 +0200
Message-ID: <20260429133928.850721-2-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
In-Reply-To: <20260429133928.850721-1-pratyush@kernel.org>
References: <20260429133928.850721-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E9B7640019
X-Stat-Signature: g6n3h41udif6p46cta53rmacrihcz3sh
X-HE-Tag: 1777469987-959317
X-HE-Meta: U2FsdGVkX19lyo88o0vqnSClUHXX24oqedkl2nFjTLp13BiSC+4lZ6HHPp3QPPqdWivgQ7hDEBWrL70+cBUjoxHQh7qUWT73HHQYC+Mfi2sto2aBukDYxE/d9j14AgD5BuvHE5Vr3xr4+Y1UiHzv/ceoODVJoRirSlro6hHnm9N7QFjDnIvTWZFu+L0CTNsNn4KWbrVDk3Izkln9mLMcvWGwq8LwLuupXKDVRSKFFAPEeBqKo3dwDHcb0GHGX2J+7jxN459TIjF1ZuOIqD86CMvZewLuSydsmgTo4hkW66xK/fm0QBVf2H8utOaRNqjBNFkQKEtvo+XM30ay0lv5/KP+oeiQx59HKPoX/zsx+qLlwYCkGUn5gpjmtLe4TqPNGI8J9YINJBCiaeBIrXq//MZJ3YB8x/HF1GOl8F9pLtvnWMw8XuMiBi+//hxdKgZdcMv1TBjdASRmS3XN1wgNp99xLNLMYv6+eVKofo5d7jvgOcROsbOx1jkOtN8CGcMra7AqNlropA05nxfWXq0TvnMkrppTr6i1xJsw9ZK4i4ZdMbCiYQpsTxB12Ay6VWEtF8KGn1ZelBoGfoQX73nuNHUqsZWv6db442bd20J08UVP+jU/aiHJPUSeRLY402O7SiBtUWjSUz26vf0IOHLZ5uEIRdsaedOiQMz8hVb3F2iyLR0vGB2hrcn7jTu1ltiCUT+jDOOZmGx1Qcx0d7tnLAn0SaDIJUPoHkLjw+nDypf8VYwYG9MDB1La0ByVqVEdPBCsUbcbzdDJtY7y0jxdWKUaf2pdv51noofMx7L9ZcptXQdu5YTWJQLpRh8tj9a2xYwO1a+SUTJ4QKZ1rY42vcuXaWH0/K+LYnX4TmpW+eK6pwuWRgBe81iOtro85qbRugNGssuc0tbeoyc1GLjj2xgRExVY7Y2j85oR4JYg2PQER/jjU7mTyamCpeCltkBdJoWGdAmk80gOA+7YC1o
 LlMhF8Cb
 /cCxz5BXiZ45utxQhkIe2u+0jvS+dRG9guI/9IljqYhxDfuM4dQvKKwNbWuimDs9bkNiJKdDwmaIppiZa8U2U5UnwWU8/mBE9hiL6kXfXcuhElZDxTvSqr6ArJPhueCBumptCo+E1PLjUh2GAvXVbROi+Q8FVEab/dhVLljDQ9YsstQssoCIfh3ZXfaRKYNoCxmm3yKpFoSAdaW+1D/xXXSAsraX/rDjnfAV98gD4ina/awK3vOfEWkZnqqGhPed6VRM8/aTy9khQozY=
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

To keep the naming convention clearer, rename
kho_radix_{encode,decode}_key() to kho_{encode,decode}_radix_key().

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
index 33fcf848ef95..ba568d34c5b4 100644
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
+ * This function traverses the radix tree based on the key provided. It sets the
+ * corresponding bit in the leaf bitmap to mark the key as present. If
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
+ * the key, effectively removing it from the tree. It does not free the tree's
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
@@ -365,7 +355,8 @@ static void __kho_unpreserve(struct kho_radix_tree *tree,
 	while (pfn < end_pfn) {
 		order = min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
 
-		kho_radix_del_page(tree, pfn, order);
+		kho_radix_del_key(tree, kho_encode_radix_key(PFN_PHYS(pfn),
+							     order));
 
 		pfn += 1 << order;
 	}
@@ -498,13 +489,16 @@ static struct page *__init kho_get_preserved_page(phys_addr_t phys,
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
 
@@ -858,7 +852,8 @@ int kho_preserve_folio(struct folio *folio)
 	if (WARN_ON(kho_scratch_overlap(pfn << PAGE_SHIFT, PAGE_SIZE << order)))
 		return -EINVAL;
 
-	return kho_radix_add_page(tree, pfn, order);
+	return kho_radix_add_key(tree, kho_encode_radix_key(PFN_PHYS(pfn),
+							    order));
 }
 EXPORT_SYMBOL_GPL(kho_preserve_folio);
 
@@ -876,7 +871,7 @@ void kho_unpreserve_folio(struct folio *folio)
 	const unsigned long pfn = folio_pfn(folio);
 	const unsigned int order = folio_order(folio);
 
-	kho_radix_del_page(tree, pfn, order);
+	kho_radix_del_key(tree, kho_encode_radix_key(PFN_PHYS(pfn), order));
 }
 EXPORT_SYMBOL_GPL(kho_unpreserve_folio);
 
@@ -916,7 +911,8 @@ int kho_preserve_pages(struct page *page, unsigned long nr_pages)
 		while (pfn_to_nid(pfn) != pfn_to_nid(pfn + (1UL << order) - 1))
 			order--;
 
-		err = kho_radix_add_page(tree, pfn, order);
+		err = kho_radix_add_key(tree, kho_encode_radix_key(PFN_PHYS(pfn),
+								   order));
 		if (err) {
 			failed_pfn = pfn;
 			break;
-- 
2.54.0.545.g6539524ca2-goog


