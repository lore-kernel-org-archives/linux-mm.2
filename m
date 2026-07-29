Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE44DC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:57:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75BB76B0168; Wed, 29 Jul 2026 10:56:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E4DD6B016C; Wed, 29 Jul 2026 10:56:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FD016B016D; Wed, 29 Jul 2026 10:56:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 33D5F6B0168
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:56:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AE1951206DB
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:56:55 +0000 (UTC)
X-FDA: 85042116390.23.867C3AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2797F40009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:56:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LWMlKbgR;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785337014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D0bt1o210iXmViyiyNbB4BNWFBk/sfgz+44p5RtjcWg=;
	b=3kfdtpYrubZlHtChWHiHtcVMy4V1WSK2qwipY+wT1yM4FDHOpSeeBK0HN9y3Q61U+xnQo9
	CGyfd/lhuBbVcckaBjjlduZBC3lGKcddKUcotN6r7uK9tdfO9RKKr1MRVJ0Td7/VDPgqPm
	bd1ci/Qp4buNhSuublJFQ2gsMVegM20=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785337014;
	b=mJElaHlMb4yWuaaPgxxeVot5BRQKffL712t0Yr7oB+jfFj4nXsVEDc/R+dqTRzr/yQ8eG+
	T3jMvDZOGxZQh/l76ahHrPB6UxARHmPdWLJrKxSnrjGf/c0rKgnh7MzTLhNGnREKKppCDu
	l0TsoIoYihVmFTsQyitFEL+ZceDZdBw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LWMlKbgR;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C0CB560A65;
	Wed, 29 Jul 2026 14:56:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7141F00A3E;
	Wed, 29 Jul 2026 14:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785337013;
	bh=D0bt1o210iXmViyiyNbB4BNWFBk/sfgz+44p5RtjcWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LWMlKbgRPxIR+JDr60bu3jSG9bGtGKUoDP0Huk78ZNntzaepLzQF/wAAZS5ml2L3Y
	 htBlP8Lkyk2p9Fr63GxPeL9FCXbmxu7rOQ/a7av9kkDjYSxjVTJL0hv6YxeNuo3e8Z
	 cpIb99H2zX8DEIadusffkWVx56B32TIwb6TUUcZcYf443f+K+yWXzCB5IQSqBqk6RM
	 2rCSxz81FYTEreXHdgZ6r/mHwsZzI8tqF0z5o8UBVSopFbF2F5wpgdSvcAOr/i8plb
	 YGr/oXxrJcJ0UldE2lpEYWLw+pFvGGW/JMt9tMddjgm0gv1vkyUERmNStKp3lOecQA
	 Pscqwjrm4k8oA==
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
Subject: [PATCH v5 12/22] kho: add kho_radix_init_tree()
Date: Wed, 29 Jul 2026 16:55:57 +0200
Message-ID: <20260729145610.2827231-13-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <20260729145610.2827231-1-pratyush@kernel.org>
References: <20260729145610.2827231-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2797F40009
X-Stat-Signature: o6jjq85ehtzkj9t3hgpz6sqtkw46hp8r
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785337014-56396
X-HE-Meta: U2FsdGVkX1+YAKmSGdKfqBPaMzGAbshMFPULKq139Ds3pTzVpL6cXEtSRNoVRStqYthndrzqx0P3mbKapEXHsRp67RPSwPRPsWgbpO7+QWwwrecgPttS6mxlAaFtCh6HSS7oX4l81L3d6w4zf+cjf/0ZAVsAmlRJDd7y3QiHgeKtRX/h84Ahe8ELjF4/sHZHFxxXzMGcIDdrb+f7jBCLmNPUq67zUbN/4DHTZdG407WTICgmMcIR0TAgB+7tMYmFQ3xKFnRXCelJNsZCLNSc+tifXqIhj1iKNmCHGzI1aDnOOKs3AC0/idn5iPKFvJbENlrzZH/BiLsGSg5fw1nhWfHwtmG0TTSLTa2zBStS4QLw2jBHhCHroD5eqAcgNVuQPQBOQM6cjhoJAUu7E3d98TTRTurCE4WG0f9mSUkcCu7q5tYeEoGHbcGJBFwaHkItjpN0IbWRF48cbVIxETRnM4TEKTcKsEmAKbHgb+tWyJbgrNSouYoUoIqAVlR+BjoGPmOyV27F4gyrTk2/LqpxA6CaiguZEQpTfmYEXnBpdzeZEoXAkcOPcwbU+bc59afZ2tn47RoGw1LGg8eotmvvb0Cc97B7T9++ZNZ73cTX1k9p72MMVMlmuxm/gkIbFtF4zrADN/ycCyZvej+mbm++GstcUkxta5ovXXbeiQeS56402ny2kvGowHKht6KmRP0WxlLQCc8gl7zEEPiS2eY3M/D8fEPKaF1tjo9IZNNNYwNlW7M3ShQIaN/AgClo38UqQxq89TdePh2obcuCOWYnMP7H39A5WZOwe2Me4jn/ULtPhmeBwg4xe6K4vbpEMCqJGR5zfq3OodQ60jSYKM4GFYicszVoK8+89xl1QMwvPS78NOogdkdlMVhcQfJ1LMSTD5v/o8xl5zfWj5XVK2ul+WFiJROkN8Qkmba1j0tSv2EvH98MxN3GnPPumMJ31IQ4ayeEKIyKh9vp3MoK5o1
 ciSFsm90
 1i9v2MS91rurU0nIOMDSjaOUnE2q7u/HrJChw1brNFFSp2mKmbdx9iGh0ACI8asGK5zqoLg0/EpqCkOnCAfwX0JiR6PMRho9R+1g0hkEfLeP0q1spe+ori7Mh9YAgmrv/xy3fDmbR5qnfZWjYCvp8hQSIuDh2H5rggx8jmAfohbP71uTVt/ztjLTIuGCvuJywnydIv+P8ZkCVaWkiNFpHNQG565mHLaTWo1yuV8wFKVLDAYeddV21aFm5XSmwGJx9SOWBanuNxC7Ww1sNF6wH9d7HCQ==
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
2.55.0.508.g3f0d502094-goog


