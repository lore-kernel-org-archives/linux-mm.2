Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ACA4CD6E7B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 18:35:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C68806B0005; Fri,  5 Jun 2026 14:35:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C196B6B009D; Fri,  5 Jun 2026 14:35:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2ED86B009E; Fri,  5 Jun 2026 14:35:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A66246B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:35:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6E185A0289
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:34 +0000 (UTC)
X-FDA: 84846712188.21.C74F00E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id CE4FEC0002
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ThcMUXFq;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780684532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8sc/XRFrwm98oAtw7zVK819UUwz2MaF8BMTpgUqYNBE=;
	b=NPzopDdc2MrBFlIx9VSuXusrkgpp+BGDpJJ9xX1coxuRYwR4+SKZsrm5dTkfEWbRJqErDu
	+G6GBq5FotH+K+foNZtVxYLbI5QLzUvNitHXcT4FQ17k/0kkve7j/DttOmBfvkyRg481UE
	dgr3iNFr6kgm4bYaUKFmpdRAmn+ThM0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780684532;
	b=oMck6eUYUvZ5FErcXC5bELBuXAYfV4IQQYK3DW5vqrdgpaL2vn77kcINuniqLfxVRUbFCX
	c92JJJfyYkmH4vSmmbOCKJj0S26Rj4OwCVzzx2wkajbloqZ+6jqnWi2WuMGPAdfbxr/EM9
	ge9XaVDRfg5gNLLNstZKgqROA5Oa3a4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ThcMUXFq;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6A708601F3;
	Fri,  5 Jun 2026 18:35:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BAF01F0089A;
	Fri,  5 Jun 2026 18:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780684532;
	bh=8sc/XRFrwm98oAtw7zVK819UUwz2MaF8BMTpgUqYNBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ThcMUXFqJZ0AnThNzQZ/aK2AU9Xcxnfw9S4wGdBy7fsBsO8LAKZokAFOSjxWzk5sE
	 Kd1A+4xWaypjRz/sJK7jlcnUhA0B6oob+CyqswxcuwebDx5RSgI8tuA0zK4QJUEq9n
	 z0iOZAjfKbFC3oDzTVuUW/3y+OXxJ83Tjiv+teJqXxPP/Pnh7MNa7kc21xAFhFvhH9
	 PhsokDfB98GmGPz1WEuwQtz0K2ydZPOTA+rseSP09+apgqbjhcvCV1q8c/RmE/RKhA
	 22LsEmd1YPMIb29jGGOZ9D8Sey5mZv4h7ZIzv9R+jjFH8yPC5Auur1DE33jEz4aP4B
	 rGXv4/cKms9FQ==
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
Subject: [PATCH v2 08/18] kho: add data argument to radix walk callback
Date: Fri,  5 Jun 2026 20:34:41 +0200
Message-ID: <20260605183501.3884950-9-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
In-Reply-To: <20260605183501.3884950-1-pratyush@kernel.org>
References: <20260605183501.3884950-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CE4FEC0002
X-Stat-Signature: cpppge4grmfhy7a5u8om9cod9bcp745m
X-HE-Tag: 1780684532-178353
X-HE-Meta: U2FsdGVkX19t2SoLbTfbx68hzHXD/mLlQiMof5rjOzzgkX27AvtUifOfBzJpmbh2cWELsPSra/xZ06LWmxp99heY+iP1Y/ERtCuaW9VzAfrMxpVcewryuIPewidh+YGFMeDtkMhjBXwFnhjX5XWu3GGDw5SoytzN/agycQO3RHpksMNKunOIn68rhmwbl1BhxY0X5aD4CAxNpD1QwLeA0H3Py9Cakiu2CoqDLUQHDgkOPM9zYf2bVs0EnpNJuAM8oQTWjdwLCxXMKQlBoMIi4ohvGmqIo951lLaQfO7l7J5evhMXNkZZtofb5px5t0X8tzKWUjMd/efWvx2Lz4PkCsMUVKATWv0mxoXWsjpoAreKslOviS0+dS5kA8V9bG7eHf7KLXI+6JApgIWWWdbDB+A29SfOZMHmiXS+iB8gbu5s8NK4hZxA2U3ScFojfNZJrlFPa7+LFqDV7EXViNGge7kSvZmN/RNZXkNK2Uis15mqVYoHV9cs7tjJIq4wtcPOF4gFmqMqXNFLVaCcT5q9ObSV7ydJcBVEaeDrSW2MNerjeybU8HX9gY/pBFp/Jc/WTQDGiofSSubW8bYiAEv9PlQTy4THqEfNvtBmoCTJoRt6uQc3Gx3Q8Hoe5HhkGq+GtjaTrAuw243F3E4IChuvANLklYcOQsv+5nxbsPjZlA9xr9/nnixC+CVTdpQJSjOfHoH5j3xG54Re4/DYVE6ZnXFYPOZayTemaXh2MTJBf+RMENHhzxFXpLLhvdafM9W4hwNYRcjMiy0GXVHNDiAHQ+MS88EIZvIw6p442KyRTKNU6dpy1BqkLlplfZ2jl0ASmbw1gAOwGeu0yNxgR43AAHHx2zyUP1W5Uo92VvIdMkohvUDuaJC4P/eXxDN9dGjjOKqjORV8QsVS5EMVigjkuuhGCsWbCaooyrGbtRrqWHOBDd8cQKqx3QqnwRqQxKKzN/sfOCLALF8duriGJi1
 2iNGDhU5
 l0MItX+0Jkp1brQZNwE+uYROUATGMX+2C1MJbfggPjPpIPcSe0tHquI+L1D0sqzOoEULXBawhK578+9e5wKWJK7svsG1Gme2+deDKNO3uJAHOmtDmo8WP1CcPOCmveKldGsCjJiuAmhUDVrr7PkbOP6cbl2rTNwaQ2rCd4NwnBBja14o2fJvE1A0fc5eziMrpej1pIsv43fyfYZPtPknjG/hdfQBfbQ/J21laWa78fRjf4A14B45upzJyQTWv/DcQD2U19JXTq3Jh4YQ88MTzztXwSe4bR0HIuDkm
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
index 94f18fe42c4b..b890a69bddd5 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -279,14 +279,14 @@ void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key)
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
@@ -295,7 +295,7 @@ static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf, unsigned long key,
 		return 0;
 
 	for_each_set_bit(i, bitmap, PAGE_SIZE * BITS_PER_BYTE) {
-		err = cb->leaf(key | i);
+		err = cb->leaf(key | i, data);
 		if (err)
 			return err;
 	}
@@ -305,7 +305,7 @@ static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf, unsigned long key,
 
 static int __kho_radix_walk_tree(struct kho_radix_node *root,
 				 unsigned int level, unsigned long start,
-				 const struct kho_radix_walk_cb *cb)
+				 const struct kho_radix_walk_cb *cb, void *data)
 {
 	struct kho_radix_node *node;
 	struct kho_radix_leaf *leaf;
@@ -314,7 +314,7 @@ static int __kho_radix_walk_tree(struct kho_radix_node *root,
 	int err;
 
 	if (cb->node) {
-		err = cb->node(virt_to_phys(root));
+		err = cb->node(virt_to_phys(root), data);
 		if (err)
 			return err;
 	}
@@ -335,10 +335,10 @@ static int __kho_radix_walk_tree(struct kho_radix_node *root,
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
@@ -352,6 +352,7 @@ static int __kho_radix_walk_tree(struct kho_radix_node *root,
  * kho_radix_walk_tree - Traverses the radix tree and calls a callback for each key.
  * @tree: A pointer to the KHO radix tree to walk.
  * @cb:   Set of callbacks to be invoked during the tree walk.
+ * @data: Opaque data pointer passed to each callback in @cb.
  *
  * This function walks the radix tree, searching from the top level down to the
  * lowest level (level 0), invoking the appropriate callbacks.
@@ -360,14 +361,15 @@ static int __kho_radix_walk_tree(struct kho_radix_node *root,
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
 
@@ -498,7 +500,7 @@ static struct page *__init kho_get_preserved_page(phys_addr_t phys,
 	return pfn_to_page(pfn);
 }
 
-static int __init kho_preserved_memory_reserve(unsigned long key)
+static int __init kho_preserved_memory_reserve(unsigned long key, void *data)
 {
 	union kho_page_info info;
 	struct page *page;
@@ -1442,7 +1444,7 @@ static void __init kho_mem_retrieve(void)
 	kho_in.radix_tree.root = kho_get_mem_map(fdt);
 	mutex_init(&kho_in.radix_tree.lock);
 
-	err = kho_radix_walk_tree(&kho_in.radix_tree, &cb);
+	err = kho_radix_walk_tree(&kho_in.radix_tree, &cb, NULL);
 	if (err) {
 		/*
 		 * Failed to initialize preserved memory. Clear FDT and radix
-- 
2.54.0.1032.g2f8565e1d1-goog


