Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBE1DCD6E7B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 18:35:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D9886B00A0; Fri,  5 Jun 2026 14:35:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49FC96B00A1; Fri,  5 Jun 2026 14:35:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 319B86B00A2; Fri,  5 Jun 2026 14:35:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 16A2B6B00A0
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:35:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CE75814028A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:41 +0000 (UTC)
X-FDA: 84846712482.30.C6A3FC6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2B6B640014
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TXKNcMEK;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780684540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZkWvf8Em4F4xpQ20Sn9ei7Pk/pLFMxxTuWJ2jy/x258=;
	b=PJmrPDaPz8PAiP/vfC7qR9HM2rBmN/pJd3F+gvss0bbtdI5Bu0PnoaSeMQB4i2bZQ62L1n
	W/sgCdd20cX/Kp+LPS7BVkpSroMMLoy1KB3DvqOHjMq46oYUZBAu0SxlSDpVct9qKFnDYA
	FVTAbSR2t5+h0Af2LV2LxBHsP9GAwJA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780684540;
	b=q8bM2zB3YIn77LfRkK7j24SM491rNt5cKJvGDiRKc7J64oVm+xZ9CwRiGGXC4SemXCTYXb
	GFrQP5/2f/3iVGbB2nga+0TMKGnWsu1HWEz8SrpGOb+xVa1VM01MGT1ftAxU4Mmh1pn/ls
	yxnywkpQrSBTqHfKuiTFdF+USjeJD6c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TXKNcMEK;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C9D2A601F2;
	Fri,  5 Jun 2026 18:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9811F00893;
	Fri,  5 Jun 2026 18:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780684539;
	bh=ZkWvf8Em4F4xpQ20Sn9ei7Pk/pLFMxxTuWJ2jy/x258=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TXKNcMEK8ZHWObM629hgW5Sx/MnPTwMvjNI5ep5QCLxUwosJq3IHU+PK8DMXF0K+X
	 nZ5jVgzl1ww8zJaj5c/HwyY1iOrlm8X6ygGSsszb/sqBbYLsABo9zI/r4nR6JN1+O6
	 AcYhdl4OvZw+wwDBZQ3t8kZPD3ro8dMdpuh0M50mSFJIpf43lAhtxxnfwXTf58U5N5
	 TRtIu0qUUY2HBJiekh/uJo0gNTV8bbDOiDOvc/NGbCBrOuLNWz1V/lbZnw57RrLB3L
	 YAXVcnYpOB39Dz4G/t0GD38KXJ3JC22B7GiOkDPSPHRJxH4YApZddskdrzbZD2YRwt
	 oTOz7+fqNCcew==
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
Subject: [PATCH v2 11/18] kho: add kho_radix_init_tree()
Date: Fri,  5 Jun 2026 20:34:44 +0200
Message-ID: <20260605183501.3884950-12-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
In-Reply-To: <20260605183501.3884950-1-pratyush@kernel.org>
References: <20260605183501.3884950-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2B6B640014
X-Stat-Signature: xnp4gp7w74fy7tfu5qfh53j8gugn6rjw
X-HE-Tag: 1780684540-388888
X-HE-Meta: U2FsdGVkX1+CHzO4bouSMMqhuJM1Od9WX5CTo6unGR33lnp9/lgnjtf07nIdaw4v8x6sGJ4qTH3IdfOpp4R3gRfATm27v8yewC/mGBuAWNfermHENYyPtZcsBcuCyBkoP2PFGfNihVF4PWGqdDXPnDSuHKBI4oxFTgBLCFJ3KyobmolNfV5gkr9o8BLiW0xxgFVingFcC6btkUAdqia1fukZHwK27YMDaciscndX+/OH7KV84Cy1RGu4HCXwo5xFOLsw3Z5wRg4b/p7wHFlD6oVTWP2FSYT9zUfa+vfQI0fzoDYLxj6NhnfppthShwaeIXc3uPZbjCfFzpbu3pcJQBH62AQRe/7t51yriqASNDaOR761SDK7c0ZBLdDAcWwWH564gnU21KFVYS0SgZMYmvyD0oRCl2pCqS0zWEXnuoLfiADVdKgtrc8uf4VEdluCFkF8OCxU8D/vX6uRYaVp4is5wX91cHskc9rC7ZeC+bmzJd6VSQFJ/Mxg2mI0P9HkEKnw8xn/ycfx8BKUT9jFHI8FwptYbR++3VS2Yd9j+d48bvO5OH9Y6NTO/1WHq3sfvjpP39cPlv5gI/QLsqp+CG5XfRyUccFwCywlOWXx1XvQrU+kdRvVWe3LjzU2tU0dwuwr9VDb8A08G2Lqvr8J6TcNLsHjcRuXDFQIALtAEkUqnlv2K7LtahkMnf5OP4lYOjgoe/5CWJAiOtjfZSYG5ui98NKOFZVe6mtFUq8lLB/8QqoR6Wzm4o5utLR/E2Je8LRp+GWnrP2gKAA50V2vQy5JJeLPCGm5j+PTlr5NtZeEaaUp3hV4j8Q5VlCnt5T5IpOEnizRJ+Xxz31lLWZMRA2KoEceHYlIrxBXD8K126FiU0UBHL5lEdxr77t6wtvHT9s53IpM30Z9KCXjWHnuQdDw6npFTMS+vU+iodceewJAMZjtLWJSmQxB9AUs9CtGvtj7UbVh9WmBIzKAWYX
 vYq8EUMo
 lfOA5oAeZn5/7dvTwSRVGHbSvH6r4gBrf8WOS/k1f5GR99NmwRKf3M2laVE2NmgtF8VUFZS7pVMaSh5k0zVT/XptO8LOFt9hg6ZGj3H0vuy/ofa3yPWUMLNSsHKjxGHXpObCm0XuMW1MNid2aoRDTdJtfqY0uxtHp2T1wtRfM39YNvODDq+P6Kyf0E+hPKtblQh8eR+1XwKGsK3eUAfeJhvNKvPXBaq4l6kI+42e8TL0zJHqArNmk0oovnQ==
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
 kernel/liveupdate/kexec_handover.c | 66 ++++++++++++++++++++++--------
 2 files changed, 55 insertions(+), 18 deletions(-)

diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho_radix_tree.h
index 66ca936b3f06..5d6ae2893684 100644
--- a/include/linux/kho_radix_tree.h
+++ b/include/linux/kho_radix_tree.h
@@ -54,6 +54,7 @@ int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key);
 void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key);
 int kho_radix_walk_tree(struct kho_radix_tree *tree,
 			const struct kho_radix_walk_cb *cb, void *data);
+int kho_radix_init_tree(struct kho_radix_tree *tree, struct kho_radix_node *root);
 void kho_radix_destroy_tree(struct kho_radix_tree *tree);
 
 #else  /* #ifdef CONFIG_KEXEC_HANDOVER */
@@ -72,6 +73,12 @@ static inline int kho_radix_walk_tree(struct kho_radix_tree *tree,
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
index df3f5eb01bf1..8ab2c7e234e1 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -317,6 +317,34 @@ static void __kho_radix_destroy_tree(struct kho_radix_node *root,
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
+	/* Already initialized. */
+	if (tree->root)
+		return 0;
+
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
@@ -1496,18 +1524,23 @@ static void __init kho_mem_retrieve(void)
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
@@ -1633,16 +1666,14 @@ static __init int kho_init(void)
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
@@ -1693,9 +1724,8 @@ static __init int kho_init(void)
 
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
2.54.0.1032.g2f8565e1d1-goog


