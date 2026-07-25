Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26867C531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 17:22:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA9F46B00AC; Sat, 25 Jul 2026 13:22:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D81406B00AE; Sat, 25 Jul 2026 13:22:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C97426B00AD; Sat, 25 Jul 2026 13:22:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9C28F6B00AB
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 13:22:20 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 17B01C02FB
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:22:20 +0000 (UTC)
X-FDA: 85027967640.05.BB223F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 28C9B80006
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:22:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XsaMviWT;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785000137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=emKiA6xrFIOZliOLnZcankBaWPBYScZ46CleF/fKzoc=;
	b=tF3nZGo/lBahe9auEBjwiL1iG3Z2pt1qZD8/V6oqjFG003rxNdKvCnPDiBUrI3P8S85M6p
	sBt5RhUd4Vupf0MsZ/Q4F7uR9xtRW1BZegYFEciahug4MIt4YFV3aYq7m1/NKb3daUIaYC
	+Vx/xKyp8bZdAe5UftuUzp5wcNeS2xQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785000137;
	b=bURE4eEwxnUbiXiRoVr4B0Beq1h1ZfCOpY/RkQjXa55AWDbTFDHHbHimjjJ/omPn3ZK25U
	gH28ik+bnsSwVfb8FnEyA4O/aYiAyxP6UzJe6q4HTC40DokLnNWj3XG1yKN2PcyW52KW8f
	h+/iwBoZCfkOWUVKM1HJIyi3d4YOOig=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XsaMviWT;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8BCCA41A04;
	Sat, 25 Jul 2026 17:22:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 479441F00A3D;
	Sat, 25 Jul 2026 17:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785000136;
	bh=emKiA6xrFIOZliOLnZcankBaWPBYScZ46CleF/fKzoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XsaMviWTbAehjg/bTEo8zneL+lukGZJmWsf75GVE/Itbfdrajxr80eE2kdoahrr3e
	 pwgoibI/ue6XE6h05TXZmDukSfp6yk4yZetHTkWrJz5OeZ8UdjMY52aSmgefrY6E7h
	 ayaswZjAAIktHF3YXsDSw1IDlbIYaToZyuklafCyB9KB5NT6oCzyxvOLl+ZqApkxjX
	 qVNCoTL0oy4e5QJiTjW3ONoNYxCeKQInpLI518RTE08oHj3IHn2V+LGDWNg21LjcZV
	 ph6ZZ6hVbjALbc02fXXtOZfQKEw5FWyq7Tza4z1n5U+dq+oQaXY6BT24Df7r/tX7+l
	 MZsaHoJDXrRzA==
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
Subject: [PATCH v4 12/21] kho: add kho_radix_init_tree()
Date: Sat, 25 Jul 2026 19:21:12 +0200
Message-ID: <20260725172133.4018491-13-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
In-Reply-To: <20260725172133.4018491-1-pratyush@kernel.org>
References: <20260725172133.4018491-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 28C9B80006
X-Stat-Signature: 76wk1p5a5kc3o3y7zdq3bajc3mo1fet7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785000137-939387
X-HE-Meta: U2FsdGVkX1/gjg3g+d8dq8A6fH3cRmNLPRDkAFHI4oTUfk2OgMyfYZ7DG3/YjzSu/zFj891Gt6I1O26pEZfb+md2N4N72cn7Zwab1AGFf3e8IcaJtUXO52GclCraez/K/VC4GVg8WVUieGETdfs09j3gWE90DKuNfzruArrNZXseQPC8HudLd2O/Xl1sgiir5ExjG9coWiXgITzeSW8RlKhmodfOI8KJU4q6ctIB1fztk/nmHz7D8qaYG3vC1ogcsblEkYqXvz5DqszyEbh2XdKqz9wkE+8yBrjws4Xrmz3OZ6uxTF+DeghoE/Y+xSUj+RKOW/oY1WgMfHAfXsQv8b2RrpfRaoSUqdKjUsDLTAG5maWxXrhMnxioJX0tnGac80wXTnoAiT79oBp7imCVSe9gDrwDLgF320TwKTg2BtFNfvoUCBPns4PUGRm/rpeZdUJ+qY/Jtu7TllczNrX3FG93UUq1y0GvCrykhQ6ojis+7y3cPjz2nzUlGDQeYcG7/11czatuVzWqvLo9avHaWWUSuHJl+IhpBairRGyZKrSlROuJHIjEclQIqvsV/TQfDgmah4eF/09ZykGYYhgL+MpbB4lqI8VSBHsbkJ98PsqH+6VOSUjf4bgv9fLVuwMOeYjDou/0Ed/Z7teFmYAyilF6JJrNpR+A1LB8JXkP4y8X1Z/QXZHn2+Rj8srZO9+HE4YcrfLMTLCuodnjMOlQ2nm+nSWnYxSFZMxEwpbEirsQruaQeQKNxUDrBYzxezMoOpZUZ5uHWUnofG6Qek96L7BqUHCaCoRaQAkTybW7HlT7Fnxe3tnAy0bQoiG4/lzK6OBB/vI+zuNHduMYdBZm2ATCeixW7Wisbwfne272ClynOyhMXQVrqtO5+OuJ9X39lgbcDqS9WJrYSRJPmjkV+9A0EAM9XL2jp57UoVHvQw785litMZitb2cmD+ESCNlHZe8eDm4sDqo6BZtHilt
 2kPZMjbl
 w+mK6pro8jI5Q4jp1QzK2PVKKhL68uHDYtX8CGKeQUNHLOSo4RajnSsT1bnt6ffMYuAqVvIdSs8g4K3PptN88cWjrPiWiccKQ1AnjH7KEUDXHzjTk9Gc+YsHIbHRTAVRsXBZUJTUltbn1t5ocjYie7+wIFG7PqJnjmmXUaF8lH8a/aEAiZ8hieX47thXe3qRzpEbbyZ7clo0H6App8OkIJ34xDln6zmcRihR00IdhNPyvTkiMKlxWjlqBUtFUH3WnReUrIBwx8LDbp4/tknZfglA5FNRVcFXPdmL1
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
2.55.0.229.g6434b31f56-goog


