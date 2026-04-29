Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1101BFF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 13:40:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D38A6B009B; Wed, 29 Apr 2026 09:40:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 335F56B009F; Wed, 29 Apr 2026 09:40:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D5EA6B009E; Wed, 29 Apr 2026 09:40:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00DD86B009D
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:40:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 33F0EC1277
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:39:59 +0000 (UTC)
X-FDA: 84711701718.03.0413D50
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 599DC20014
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:39:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BXwgQPV7;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777469997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oFI361pCC+MubIMIzirZDVSDvX03Lg5mwijXtqdZWCM=;
	b=upF5m36M7MFQmZt8S1Q2fkzkzfjNw+LRHjYgj/0jf7th/N10YlOQ9YbIkf4oBvxnGs4i5I
	R0fByne5rSA29ZhmfCD32kfaC4XIAgJ21BrgNEsEQrwcSfs8N4lSOrM8Nb96r3apdolEAu
	4Xl0zhASul3AUOxWl2OcaWHKWq4yKLM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BXwgQPV7;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777469997; a=rsa-sha256;
	cv=none;
	b=0oNIzb2gw219Ih+RrF6frnnsjOb06c8BuSLND4nuJOo3nXda/8QXxbkFn73BzkSFCRm3pP
	jGNjnIuDyJIqRsLTDlIkbm99F4MM/MJSib+PUEJ3Yq1Fbn6wpjPq2WvZ+RKkDlwO0/fHqk
	3906Fv1CQH/zlPJMbhSHo3CDJy/xyBs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 444AC4451E;
	Wed, 29 Apr 2026 13:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EEBAC2BCB8;
	Wed, 29 Apr 2026 13:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777469996;
	bh=D7e5tDuPEikjDNzEWBdawY+xK5X311huQBCQe6bYQjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BXwgQPV7TIoFRjGIb97YZI5FqIOmXTkItCH6c9HMLsleuRHsVZS1VZB/8vuxbYop6
	 w/FV6g0BomdhfWgyopnA0m8gbWh+IhyJ3j8EjEX4qVt6SL8/7w/7u9Jz5sK6YxdLC2
	 pdIib0LKc9k5daQsKL031TY1t32wUb70uUNaLzd9M9CEZtbfYZHRdAdZgozjRUBoBD
	 oC/Lmk40lrH/BlPwg+jFJEnvyAvimu5Tp5eIuvIwCoBMQBWAYcQ2k0FgMsL0OD3J+t
	 vgx9c99J+4YXwCXXKWo4MwVF++ZmUPZ1riT7jzORWf8Ns0GFmxdO4kFYRFUUPaU8eO
	 bFRaMmLwwjJEQ==
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
Subject: [PATCH 05/12] kho: add data argument to radix walk callback
Date: Wed, 29 Apr 2026 15:39:07 +0200
Message-ID: <20260429133928.850721-6-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
In-Reply-To: <20260429133928.850721-1-pratyush@kernel.org>
References: <20260429133928.850721-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 599DC20014
X-Rspam-User: 
X-Stat-Signature: kdxzz818tt1b654m6w5n7fqruhfaiktq
X-HE-Tag: 1777469997-934
X-HE-Meta: U2FsdGVkX1/reDTUf27teW9Yb7kvdArVu78PSVPAp7JEGvAYhdJc8i3PbHnLa3B96CpCjOt3S2knvPxlNO6+k3xebZjruCDZN25+WtErJqUGu+fzrkW3dWrOpBuuCdaLUxMeBs7fTAp+uRqfiJAOLbEs3n+NQ29iK+D2h5NDUWpmDloRBgSMUkcvZd04A2GQLmWzO5dkwvDF/48znH+jVtU2OxaFi8yoS3bGaM2xYFbm7tlMW5jyPa9UFztPF87xLXfxnb2c0Xil41tkLKsCsva4MpINK2nKTg9nJcciFye8s7hdIzA14FKbYBkIWnOKklkaHIobUAaqKAgunof2Q54fwfMRChYZ2R0XQfdevMiFqghY7SqWzrk+3AjalVRCe4KEdoDdJdk7ZRe113adOhlUyVlMZ8wPRW8c65UXJJ9Smi6GYJ4/lczYzX/LOKee1N06jtYHfZpsbdd9VnycF1+idleKfos2Nr8aVgxeTrp46BsdbDHGg7T+oIUAQKZ6xEOrUCkjP+uBttITZC4o4Nq82wY9mUOlbwpWaYHc63VaO++0gEVU5w4YTpGbbmtjyzT86Bce3iN4LyxhehThlaPVI2oBguR6VcAS9uRtZe+Ny/XW5lhdgLJ8qzjaF7XRpu7nyyBH0+VZAr4awVsACtcX/LlenseGjFL4dXnRyC7VR12Oe+6NqhBg1aIC+AYoG47D1XX6Kjzyv7weYXQ455ACafIlV/qiR3pKFmDsOKhv4jA2zgyeur2y119Bj9SSUUjr8wVwysL9YmlonSlFhMxWNEj3xGxRbmILWcZGw5pyYo0MdauTDqPRC0PudJhk/gWXtnmBCSM9rGFg/SRpjpxZ8i0oLdAU7GWzbyC6Mhhvedq5kNZYP4k79QpTv+sYJ3qJLcS8ZMC9L5qNpoqqkEp329CmdE9pfCbpcTMjQB+f7RKeYhm3Y0/i97fc5I/7EGAwfa2Y5+MA4lq1y6h
 yUXSetys
 MGoF/DBy/sy1tV3zLUOqoG2QnN/BUt9AAAjnGK0hL8r7ODU6wC5+BSCP1cS/zpu2V3RrGvh/ZIc/ULlhYQtyqBVC5h209AxuQ/K4IgutXFY4DmlvfPVI3HbM7nYUdQ2hwpCYtLTY3KfzmVMnQUyjIwutRvVr2iBAKbc3q1uINCKoX8WaX3koE/HCsDpFoB1C/jK7MJ5g9fyT4zFqmCtlU5mf/hvYpQ+rO3Owg0cQHZegHw8s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Add an opaque data pointer argument to kho_radix_walk_cb_t. This can be
used for callers to pass extra information to the callback.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/kho_radix_tree.h     |  8 ++++----
 kernel/liveupdate/kexec_handover.c | 24 +++++++++++++-----------
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho_radix_tree.h
index fe7151d89361..6c0f7d82716b 100644
--- a/include/linux/kho_radix_tree.h
+++ b/include/linux/kho_radix_tree.h
@@ -44,8 +44,8 @@ struct kho_radix_tree {
  * return value is directly returned to the caller.
  */
 struct kho_radix_walk_cb {
-	int (*key)(unsigned long key);
-	int (*table)(phys_addr_t phys);
+	int (*key)(unsigned long key, void *data);
+	int (*table)(phys_addr_t phys, void *data);
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
index 94ca831b41c9..d0a4f78eccfe 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -267,14 +267,14 @@ void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key)
 EXPORT_SYMBOL_GPL(kho_radix_del_key);
 
 static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf, unsigned long key,
-			       const struct kho_radix_walk_cb *cb)
+			       const struct kho_radix_walk_cb *cb, void *data)
 {
 	unsigned long *bitmap = (unsigned long *)leaf;
 	unsigned int i;
 	int err;
 
 	if (cb->table) {
-		err = cb->table(virt_to_phys(leaf));
+		err = cb->table(virt_to_phys(leaf), data);
 		if (err)
 			return err;
 	}
@@ -283,7 +283,7 @@ static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf, unsigned long key,
 		return 0;
 
 	for_each_set_bit(i, bitmap, PAGE_SIZE * BITS_PER_BYTE) {
-		err = cb->key(key | i);
+		err = cb->key(key | i, data);
 		if (err)
 			return err;
 	}
@@ -293,7 +293,7 @@ static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf, unsigned long key,
 
 static int __kho_radix_walk_tree(struct kho_radix_node *root,
 				 unsigned int level, unsigned long start,
-				 const struct kho_radix_walk_cb *cb)
+				 const struct kho_radix_walk_cb *cb, void *data)
 {
 	struct kho_radix_node *node;
 	struct kho_radix_leaf *leaf;
@@ -302,7 +302,7 @@ static int __kho_radix_walk_tree(struct kho_radix_node *root,
 	int err;
 
 	if (cb->table) {
-		err = cb->table(virt_to_phys(root));
+		err = cb->table(virt_to_phys(root), data);
 		if (err)
 			return err;
 	}
@@ -323,10 +323,10 @@ static int __kho_radix_walk_tree(struct kho_radix_node *root,
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
@@ -340,6 +340,7 @@ static int __kho_radix_walk_tree(struct kho_radix_node *root,
  * kho_radix_walk_tree - Traverses the radix tree and calls a callback for each key.
  * @tree: A pointer to the KHO radix tree to walk.
  * @cb:   Set of callbacks to be invoked during the tree walk.
+ * @data: Opaque data pointer passed to each callback in @cb.
  *
  * This function walks the radix tree, searching from the top level down to the
  * lowest level (level 0), invoking the appropriate callbacks.
@@ -348,14 +349,15 @@ static int __kho_radix_walk_tree(struct kho_radix_node *root,
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
@@ -1392,7 +1394,7 @@ static int __init kho_mem_retrieve(const void *fdt)
 
 	kho_in.radix_tree.root = phys_to_virt(kho_get_mem_map_phys(fdt));
 	mutex_init(&kho_in.radix_tree.lock);
-	return kho_radix_walk_tree(&kho_in.radix_tree, &cb);
+	return kho_radix_walk_tree(&kho_in.radix_tree, &cb, NULL);
 }
 
 static __init int kho_out_fdt_setup(void)
-- 
2.54.0.545.g6539524ca2-goog


