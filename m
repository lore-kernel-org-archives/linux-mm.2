Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 701E6C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 17:40:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9299E6B009B; Thu,  9 Jul 2026 13:38:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DA856B009E; Thu,  9 Jul 2026 13:38:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8176E6B009F; Thu,  9 Jul 2026 13:38:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E0AF06B009B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:38:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8AA111C1F4F
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:38:52 +0000 (UTC)
X-FDA: 84969948504.02.9AB053A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id E58701A0006
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:38:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k5z1XPTE;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783618731;
	b=7I977JYp4HZmWl7V7szOKZFjCBo1yOJHk2zsMJb4Ey7grCKfhPRODjQsNZp8l1syq7xlpo
	IyjdMgAFU8ofjUTMwatd2tqzH0l9fSNAPyt8+R/fL1OyXo9ZIInqy6QAHh186rLBrqub8H
	afmk7rOEVZBwVMX22DxdiSP7W0AjK9c=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k5z1XPTE;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783618731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pcpHltz9li0iTs1WsD5eIIz6ruG9qO5py8BOvyZzad8=;
	b=GO1N+NnPaGy3OmS6ZPUKldbpIrApmxejw9EWn+hlh/wu2/fOghpubMBLkRihaesL96wh2I
	Q0Oue1Py2MTb42giQvxjzCA4WyVAAlpDk//r1m23VYWT6STtR1uqjSEPsXf/ygfMJjrdNt
	q0v2GeSOyOTCASJIG20AKQpZS/FiaZU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 56F2841FC5;
	Thu,  9 Jul 2026 17:38:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152041F00A3A;
	Thu,  9 Jul 2026 17:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783618730;
	bh=pcpHltz9li0iTs1WsD5eIIz6ruG9qO5py8BOvyZzad8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k5z1XPTEJRdBV0HODe/jQ+vpX6f+RThVFgxm6WznsGEnXwv53CwoMVJge+88qVlWp
	 Z1tyoMxl0JrOHUJrBJD4/ApBHDT4H82zBzmkh6/D2A455Y7lumK83pnewWubv2U++U
	 zo/vxYmmRYWx+H6E7d9XqmBMdR2qdDvZuDMkCUwJtW7weia1kg/guXna1KG5QFaw67
	 vOrIxucadXjuDq0Z2C4o0e8XHoBfGe17r+3eZp02lVDCBJPnNLLWNC/LRh02+nBdIJ
	 jegyG6EnJkk0noOLhISOr5a7PN+AfQZxAvqVWGIkKmAGp+PKboyQ6Kv4kKJP9xzLlS
	 xjOPA7oRHLbDg==
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
Subject: [PATCH v3 07/21] kho: add a struct for radix callbacks
Date: Thu,  9 Jul 2026 19:37:56 +0200
Message-ID: <20260709173821.429921-8-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
In-Reply-To: <20260709173821.429921-1-pratyush@kernel.org>
References: <20260709173821.429921-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E58701A0006
X-Stat-Signature: 65g3stw5tfqyoika5xh941ijmrok4hpt
X-HE-Tag: 1783618730-912744
X-HE-Meta: U2FsdGVkX18UemDr1fvYPEDAVpRhqivDsVHcPMgLfG00Hb2Cb2YYrAaLykqXQh9bqUlNv9vnHKSrmGrgY/0UchBTcb+VcbIj71QBbpjtmSBSmRV4nasFDfMYrEnvpt7ZLDjLpl7pe/JO1qc66DZV6L3/mSKh7YCSvwvM/BlpiLtEfPh1dLe0YEXBLlsdbChG1LJZbkgtJTweRNV9i21e/jVNoXxtNVQaP9XoNRyisfFvgi+h+iFYIpMYIC8V2Qyf4b+Vya5fB7K4up63mGdAV5le5lBVKU9kXZzCQNKkFof2gXGD/n10/qAmFTPGRDv0yllRjFuSCLoQT+Zh2Ie/OU7RecN6iCSMeah+gcBYIR/vA265Tokkzfr1urfF0xmRqGDsMcmYBY6bwClloOnllakKTj16s/ntVIAR20z87ilWRGl7VDN87gSVakCw6Gco07ffyHdASRBe3/fHygFt4Uxh+v9fRE6MnAHsKVRtJGcWqaLVlqKb/2yRkpYpciJ3Denmjie3ynDG2F6gxkkZOP3FcGb0bBSSIN1WuwtkpRo7PKJ7XEXyBfZH2dH6thsWX8OiZikQ1lW9MoQfhexcrG5xk4CjI2HfG1/XbbfIsLqF8YJ8NWbwF+/MxAPfMjxP1u6ywOo5u5v8vvQTHowM8cli7a4uaus5ziV8HWwvnUsdbJLVn5qvtZUdi1tJDw8ZtRZszWzzFOXCEyC0upwzPyOr415J1mCONFiKlNXETiMBTFxWxg4n56xDxYZ9loKZxa9MOgQaWXlUGXn/AiOEHaOprSywGWLhwgVuAYWNRMNdouPRHimAh54a3f9AzCFHNhrByE3UzOOsfuq7hjZf5MUEM9SisUlKjDRCHHuUgmvwrwt0u54YVLzrobD5TZj2gWMZHmCN9dCtXL1W49ZUjKrd/1IKyfEyt1vIzCJVDgprGTvM5PsQ2S6sms1bnZ1FvLsYJ9W+iBHzmRTlXJW
 QVOakMXN
 ArRlo3ASTfkKYnUHSKqvH+nZydkjTojG6XMjW74wPErwiLYij1P2eMJBAGFXB2vTpqn9PuhoheviiKiBoijvK+14t5gcVDQL8RBiNDXiRlQ79h9/F2vA7fzS3m4gAY0han2QM3usDHqYDZxsypw98FUFZp9JRXEz79PXt3hwSrAqwNq2YB9pJRqjBFa/6quSztRZj11b55DbvYPm5tclAy0eCBg36Rd7BwAevHh22ahFuQfA=
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
2.55.0.141.g00534a21ce-goog


