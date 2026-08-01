Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52E10C54FCD
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 08:50:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A66F46B00A6; Sat,  1 Aug 2026 04:49:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3F026B00A7; Sat,  1 Aug 2026 04:49:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97BA86B00A9; Sat,  1 Aug 2026 04:49:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6F44F6B00A6
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 04:49:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CF8B712026D
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:33 +0000 (UTC)
X-FDA: 85052077026.08.77F685B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2315540007
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fBVAEnZ2;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785574172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YThpLVa0pAUWP2z3tc3d9zSsIfw3Qsor7X/X4Bi8OXs=;
	b=5lRZDx7VBDQ6586KGsVQT59am93m8wqvNyKNl3dWWHu1vPgRetU5zLYPApgCAhqmj9PVbA
	Dw6vdynfIn0kNkir8mYmIspTmSphj9LzDJt5o6CkMUvmETxbsMBU2B0VV6EMt8o4JScxAh
	UivbdKPDlh2VfqFiXLJkbkizzcWiddo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fBVAEnZ2;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785574172;
	b=eBM15v+UwBRNqAUK2AS/KRTCu2HB0mcnk1SNALJNwAHFSTFuKMWdytTrzLUbclzACA9p3f
	O9MN+cxQUawOnx8e4+2x/F08BTChoUWXawIY+aReLnbNlYlhwp33IHRKs6XoriuU3nvJCV
	GzAv6nX1Oc8IE7z8GTLfwMgiDebDruE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A4F9D452A6;
	Sat,  1 Aug 2026 08:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 543CD1F00ADB;
	Sat,  1 Aug 2026 08:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785574162;
	bh=YThpLVa0pAUWP2z3tc3d9zSsIfw3Qsor7X/X4Bi8OXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fBVAEnZ2RRAtY4Ovg2SUzbCx5Naohcmkeiixgyi2qjs2u97GdJBTnBqCB4OrCLxRC
	 4HggcfmpOi0iieeh3Ia0Ef7Qb/c9KYBX8TR8aiweFJMFRdIfA3HMKOeoR2LVIZdoAa
	 EsjtdVtjkVswMA9gP+dW0mdnlLmb2d4CBIdZUi1V2Fb/pBGEGsut4jVVFOgPKBAxXt
	 26H/+vcL9Gc/Gf3MN6gQ00MwdKz3vVskgQz2JTeZzJxt/AsW4+vGIo8eZqyVfUyUOF
	 3+LqGh3jLbZMySkeBVX8WFnkpcpzi1P0iTIXvNde6VtYdiy4YbHdATIJ4sQU3e0ERY
	 FDCJfQLpFUQdg==
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
Subject: [PATCH v6 12/22] kho: add kho_radix_init_tree()
Date: Sat,  1 Aug 2026 10:48:21 +0200
Message-ID: <20260801084833.1897543-13-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
In-Reply-To: <20260801084833.1897543-1-pratyush@kernel.org>
References: <20260801084833.1897543-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2315540007
X-Stat-Signature: zk5b88y14sqr47nra7apgy4mzfhj55g1
X-HE-Tag: 1785574172-692544
X-HE-Meta: U2FsdGVkX1+Mp5D2gKqk0BHyTgc86HJdGIDlxLMJfm9E4sTXKhUCjEZV/xez+PwpjVUNN8y9ExHBl3PMoR4TXD1f7uI0katumt9kr3afS+eGzm3vBjk+aVLqNuWDiWTHPo61s8/CAXFswfib2pz/ibGV+6ACLJ94VuVcA0AY3JC8zms1ASJY7K8xSVHtC61qnbWEW0WzGdoC08261H8sE2ujSRZ0V8UVp6vOR/cwbFBQvSVl+cxogPX85zMY4mCrcrjIHV/Udfnx13PgVkVsrHS0TKTyoG6hmFcRDrGnt0ht8zpCoiGpWVQKJrXmIjkZKS7cCtJfgDN3lXzzWTfIbkU32LvCOKK6gNoQbrZGWploQjVCj5J7D4+zfWYu2R2rGGf1RHpxcdXnsibAq4Nl4/EDLlCon/+IeJdF3GDe15J7PVVIGHmqaibh+0sVtDKDkzaBzjdxLvzXSFjCSAxu4Vdw5a1h/ZQaluab1Qug1zndaIxuJ/MSFWT9LOk3lmeSizgAmy9ldf9Y8qPCDeFqXLFuo5Pq3q2aH89n3Lwakt0P2HietfrbxFZ63+GqdjPjiUNXwqX3yEFqQkozpSj1l2tRTAUvlt0pXd0yeqtzdlZMrgRThCBXu3hrhbU7ckz4JI1vcZPkiC4L4z8upHAVkcSw40eDFiDKBcECGkYkIkY6u+uTM1E1nO8q0fO5vZitZA1/gJrP746o+lpawUCyg7iq6iDbHHMUEFNcMilSMGKtHKW9FORwU4sT6yvADdhYH7boJSHNvgnt7AItzu0gmTFvxJDJ6IMf5E4AfvlxKCTGOpuxsDXgNuFKS9NuMR5JSRKu4J7PKKuJlTs7JQlUA8gxC3IsghfoNzg/5zWqCHf5HVZoC6YWgzd9sdb6wCp/POVKO9qPm6Paz5VSK/ZHmm6UUHxoyp0p3xopyGZUlUH233xawICFaxDtLtEcsFpEFrCNMolO5pZgYxU/i1X
 n1aqt7uW
 2NfdQ+pU/xNU5/FXch5qY9XLptixDgxEm+rzlaubSGC6aYePlk15Ir1YlHkKcOS84UMxCOVLlbq8iFNXg4OyJWAFAqeZx2RnXnWtR/6SY7ttT9HzfjEqfEmh+knV8DFnY0Kf0dm5IWgmXjhiTybe8kuqqKvwCLqZvepiBa2bK2uKHXYDfdhYM3q4MEnPXBY2OcvarkaP6K4nsaVccBNwLQsfJyIpZG6uzHbySNKRgf+nAdvAedk6s+msLZCGudAtlzy4iIya/JaGe/7vBfXL3HJWyL7tnxtzpsCu4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Move the initialization logic of the radix tree into
kho_radix_init_tree() instead of having users open-code it. Makes the
boundaries cleaner and reduces code duplication when a new user of the
radix tree will be added in a future commit.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/kho_radix_tree.h     |  7 ++++
 kernel/liveupdate/kexec_handover.c | 62 +++++++++++++++++++++---------
 2 files changed, 51 insertions(+), 18 deletions(-)

diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho_radix_tree.h
index b7532aff35d8..fcd69639721b 100644
--- a/include/linux/kho_radix_tree.h
+++ b/include/linux/kho_radix_tree.h
@@ -58,6 +58,7 @@ int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key);
 void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key);
 int kho_radix_walk_tree(struct kho_radix_tree *tree,
 			const struct kho_radix_walk_cb *cb, void *data);
+int kho_radix_init_tree(struct kho_radix_tree *tree, struct kho_radix_node *root);
 void kho_radix_destroy_tree(struct kho_radix_tree *tree);
 
 #else  /* #ifdef CONFIG_KEXEC_HANDOVER */
@@ -76,6 +77,12 @@ static inline int kho_radix_walk_tree(struct kho_radix_tree *tree,
 	return -EOPNOTSUPP;
 }
 
+static inline int kho_radix_init_tree(struct kho_radix_tree *tree,
+				      struct kho_radix_node *root)
+{
+	return 0;
+}
+
 static inline void kho_radix_destroy_tree(struct kho_radix_tree *tree) { }
 
 #endif /* #ifdef CONFIG_KEXEC_HANDOVER */
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 105dc0f3e691..04bfcbf9cc55 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -320,6 +320,30 @@ static void __kho_radix_destroy_tree(struct kho_radix_node *root,
 	kho_radix_free_node(root);
 }
 
+/**
+ * kho_radix_init_tree - initialize the radix tree.
+ * @tree:   the tree to initialize.
+ * @root:   root table of the radix tree.
+ *
+ * Initialize the radix tree with the given root node. If root is %NULL, an
+ * empty root table is allocated. If root is not %NULL, it is the caller's
+ * responsibility to make sure the root is valid and in the correct format.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+int kho_radix_init_tree(struct kho_radix_tree *tree, struct kho_radix_node *root)
+{
+	if (!root)
+		root = kho_radix_alloc_node();
+	if (!root)
+		return -ENOMEM;
+
+	tree->root = root;
+	mutex_init(&tree->lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kho_radix_init_tree);
+
 /**
  * kho_radix_destroy_tree - Destroy the radix tree
  * @tree: The radix tree to destroy
@@ -1499,18 +1523,23 @@ static void __init kho_mem_retrieve(void)
 	 * catches that and never sets kho_in.scratch_phys, which stops memory
 	 * retrieval.
 	 */
-	kho_in.radix_tree.root = kho_get_mem_map(fdt);
-	mutex_init(&kho_in.radix_tree.lock);
+	err = kho_radix_init_tree(&kho_in.radix_tree, kho_get_mem_map(fdt));
+	if (err)
+		goto err;
 
 	err = kho_radix_walk_tree(&kho_in.radix_tree, &cb, NULL);
-	if (err) {
-		/*
-		 * Failed to initialize preserved memory. Clear FDT and radix
-		 * so KHO users don't treat it as a KHO boot.
-		 */
-		kho_in.fdt_phys = 0;
-		kho_in.radix_tree.root = NULL;
-	}
+	if (err)
+		goto err;
+
+	return;
+
+err:
+	/*
+	 * Failed to initialize preserved memory. Clear FDT and radix so KHO
+	 * users don't treat it as a KHO boot.
+	 */
+	kho_in.fdt_phys = 0;
+	kho_in.radix_tree.root = NULL;
 }
 
 static __init int kho_out_fdt_setup(void)
@@ -1636,16 +1665,14 @@ static __init int kho_init(void)
 	if (!kho_enable)
 		return 0;
 
-	tree->root = kzalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!tree->root) {
-		err = -ENOMEM;
+	err = kho_radix_init_tree(tree, NULL);
+	if (err)
 		goto err_free_scratch;
-	}
 
 	kho_out.fdt = kho_alloc_preserve(PAGE_SIZE);
 	if (IS_ERR(kho_out.fdt)) {
 		err = PTR_ERR(kho_out.fdt);
-		goto err_free_kho_radix_tree_root;
+		goto err_free_kho_radix_tree;
 	}
 
 	err = kho_debugfs_init();
@@ -1696,9 +1723,8 @@ static __init int kho_init(void)
 
 err_free_fdt:
 	kho_unpreserve_free(kho_out.fdt);
-err_free_kho_radix_tree_root:
-	kfree(tree->root);
-	tree->root = NULL;
+err_free_kho_radix_tree:
+	kho_radix_destroy_tree(tree);
 err_free_scratch:
 	kho_out.fdt = NULL;
 	for (int i = 0; i < kho_scratch_cnt; i++) {
-- 
2.55.0.571.g244d577d93-goog


