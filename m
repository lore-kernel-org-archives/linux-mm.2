Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20322C55175
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 08:49:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D39A6B00A0; Sat,  1 Aug 2026 04:49:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 584446B00A1; Sat,  1 Aug 2026 04:49:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C17A6B00A2; Sat,  1 Aug 2026 04:49:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2A4986B00A0
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 04:49:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9B5F7C0272
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:27 +0000 (UTC)
X-FDA: 85052076774.07.8028B02
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7E32740009
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YiOwLVgS;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785574166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2z5E/Y7doyLHo0XBU2qeh1Fkrrfbqz8ulL5I/cCW2Bc=;
	b=YWG2sW9f3NthZ4AE43+CnS2YpyHRZgsEej3kVX15SWacWIIowx033eE61ANpuDo4CWuX/y
	mNK7Ek2UQg1F6T0yO5tO9DkS97q8Lij1dRVGadK+pxp+uegLk1T9DcOBfxTXN9lAWZQx2x
	wxtchDcdu6buWhtA73Rass23jFqvJrw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YiOwLVgS;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785574166;
	b=eJcDRLpP1WXOXCdVIpkR9E14zhbNJRrkbX7zxCCj3ol/zeN1/GSSqn0JRz5AYKoqKEkpBk
	VGtz3eIlznCSYUiE5qlbY+UlBj5z2VLh935oPz1bSz7Sxagao1XZs3gTgTc85FFdEPkfYF
	N4qfdf/NVkOjnQg9OVly9YWQxnzdmU0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EC96245294;
	Sat,  1 Aug 2026 08:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E5F1F00ADB;
	Sat,  1 Aug 2026 08:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785574154;
	bh=2z5E/Y7doyLHo0XBU2qeh1Fkrrfbqz8ulL5I/cCW2Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YiOwLVgS4sgFN0WTFk1AD9raXZzU84HdiMayfF87mPwL/vG2uFBXlKsl5RJNnAauO
	 3O1WnYSCSmt0N91lRfFmuDUABXphovkeo6tGRLo71l5PVdy+IKwffbVB/j0GD/y5/d
	 Kw1rg5A2wwHP+aomtUSNMlSLSP2/pYMyvEfL53rwPnkfByBRiUIgXgQZYhOd7rNK58
	 TU5YW0ez0/XIfwt2yJVsJ7ZuB3ksExKPQY0k+Pp7jubX81UjxjPi9dkkShJxvcxb60
	 GBRMYT/o7Ab+sNPr6Lpx72sToTYbmmi9yZqtLnEqvQwEDQHbJyk7wNLGlh3UyxdN0r
	 Ehd4iZlWuP+nA==
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
Subject: [PATCH v6 09/22] kho: add data argument to radix walk callback
Date: Sat,  1 Aug 2026 10:48:18 +0200
Message-ID: <20260801084833.1897543-10-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
In-Reply-To: <20260801084833.1897543-1-pratyush@kernel.org>
References: <20260801084833.1897543-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7E32740009
X-Stat-Signature: ai3z9qomx39it8p4afknmmfciyhjkafw
X-HE-Tag: 1785574165-638739
X-HE-Meta: U2FsdGVkX19dtiUlpqM7F8vQPRUlFgkxiDgij643SVZyR9NnJID1+x/qauHOqvuMNcEH9e9T1kFzWkvXT2avPcqi1T5Jz5FOz+IGejgVIWygyE3NcmjnaAiLMF1JTGX16CHNv0zICubdtN33VeYJV6mgUlu7Kbn/zXmddSvnqORSFxhK73NkYaUDDCq2i6/Qmkimfup3JgPgJ2+xom04b/zg6X9cw+Z4zOHO2wZbMuj+9i9lBDDCUbGo4xU/7jtySaBYktiwIrHY4quwsxK9LwsdHMYK4Mfo1XUMqDAezNG1HvJLQz9NX3WaUuC/oZvbnlCxUm4bLNU5IjSiT9Xp6PmdMQndLnoKgC4plv9QLK3aNF3ugq2scnhKPvMgiGJjKtbxLC71N11FZQgpCY1eaZoX5eIjJ9k13DFtXm6hUo1MtHdXBbwKK/wkGyx8xxBNONNEmEqHqDD2/LMnEd22aV/AhRoHSDDsWFi7f51xuI6uwd0K/kAlzH+XUTnWO9cqkxMovrN+70pVY2ZPCCxyKvTvz+PKEQ7HFqnu8/UGdT9doGUbGh98e0aG7ptvf6uDfRDpy7cFbC15jzNSAPU6T0aLPmgLGcciwZXOa4o+XDiDI9ig1EtcD80AELGp9v40POPoHHKq1nMx+hgWWOkQTCwTpttPgTQTclyz05ABzkamFthNofhA/UQsY3ScPRMg3nh649L4dhnGHLjfNmCkvaIX6Dx++N1QWm/K3tffSk4OoIH+hAGecqICYEcAA0pJbxFySOw0VZ8fvgS6Mdc6Zo1rSGZ/KHPl1FtPybNUuv062LzJghZ4GGPfirSPrVQ0+7MBPxIZVDq5f+uNkI5GBKDX33+p4Tf+J/+rty26frRuHZ1YzeaoLtB6z7lecfDAWxt18NCA7nROD0J+Sl9KR2Z6AuHCuWCKMoMKNpxjNx+HypBTU9LTYCFq49JtKiy+ynmAqfnkQODeNp3v8BF
 oNFxTmSh
 +6NZneyFacQHp+B1plgYxHQHRqEGqe/l/0aqGNeX1pWWHZH0Winy7V+DbfN+Y85gc8XOsI62vvsQFlsbRDTnFwrsAO9vhIC+yRtCG+pFr19s8HunoecWdLZxNx+UVcuzLA9pV9M83Dl+DClHTXz+t/r4VjeYTX7jPJh++I51QCJd/5w3P9wRCY7U4uPbJYJnS2fL7OYuFjDWdb955FxUtNDWw/SfZmeEB/+flmQPkbwXdhY90sS1Iws3bqAwnFsfj1+GN/6dLu379b5p3pRyzSB7vwY4Z4RKXdSpaLeYyBIeKRB0=
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
index 902bbeddcbb7..60c1246a9101 100644
--- a/include/linux/kho_radix_tree.h
+++ b/include/linux/kho_radix_tree.h
@@ -48,8 +48,8 @@ struct kho_radix_tree {
  * return value is directly returned to the caller.
  */
 struct kho_radix_walk_cb {
-	int (*leaf)(unsigned long key);
-	int (*node)(phys_addr_t phys);
+	int (*leaf)(unsigned long key, void *data);
+	int (*node)(phys_addr_t phys, void *data);
 };
 
 #ifdef CONFIG_KEXEC_HANDOVER
@@ -57,7 +57,7 @@ struct kho_radix_walk_cb {
 int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key);
 void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key);
 int kho_radix_walk_tree(struct kho_radix_tree *tree,
-			const struct kho_radix_walk_cb *cb);
+			const struct kho_radix_walk_cb *cb, void *data);
 
 #else  /* #ifdef CONFIG_KEXEC_HANDOVER */
 
@@ -70,7 +70,7 @@ static inline void kho_radix_del_key(struct kho_radix_tree *tree,
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
2.55.0.571.g244d577d93-goog


