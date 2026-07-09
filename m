Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 446B2C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 17:41:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 902666B00A2; Thu,  9 Jul 2026 13:39:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88D816B00A3; Thu,  9 Jul 2026 13:39:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CA326B00A4; Thu,  9 Jul 2026 13:39:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 482A46B00A2
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:39:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5C956C15FE
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:39:05 +0000 (UTC)
X-FDA: 84969949050.20.CE50AAE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id AA4CE10000C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:39:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f0IzsIya;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783618743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XsiwX2KU4GjCVUN88XJ1zOxK6etLsLe5sKXBgJJKO1Q=;
	b=krn8LhUOmzn4LzJPQLHa3rcypvc5Pb+mhPpMG86IFpiA5/avuASQ5CwdbLs7ze+wfpNiwD
	+1LcOfj5+EHhFDbx99Rd59GwUczHYr06IGnTt8HOf8IOjoIgk/YrVTG4CycaIybTd+CSDi
	CcsdJvstyF4xGK6WEf9nAi9sMV8SNdI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783618743;
	b=fbnidEldMCQrfDfSorvXqb+/uYCyD+VZaw23Kb7UyuwMfVUC8QrP5NhVu5+xR+9P5gLCAT
	MhAbGMZBgIHFVqPr2DllemANsEZMLKD2ZgblCzc2pfF+aeDfrSenXRWzu3ATcGOwW/lm9x
	pB/FEVpxn/LV2/YkaFaok8LIeyy0fxs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f0IzsIya;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 12EEB40D58;
	Thu,  9 Jul 2026 17:39:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48A41F00A3A;
	Thu,  9 Jul 2026 17:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783618743;
	bh=XsiwX2KU4GjCVUN88XJ1zOxK6etLsLe5sKXBgJJKO1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f0IzsIyaxLg0GbrzBRj5QkAwCzDsbsSzTbQ3gaT+icuX9JK9b3b5myQ6Q2KD2xDTH
	 7zSR7S9CjI5VeT0ZNhBqy0TwPaTD3dhLS9s35HXPUbl7k9aFapqkRBkFwV8+NTYMSe
	 KXWN0PpaWu/rgoMYYO1s/RIyQh3zlYBiA1dhYSNbHKLYBvScaIR/EQYuLNdk7UrrVb
	 bsLdO9pK1Lx6J46G5OLRx6ZszonAfooI0UIGlKxv0qC5/c8PCgIVZ4JzWFBmfP7BLl
	 gL3JaMF+kscEOBYnCxT+86XHOaCjHMMrsoB4rKo5/8SWqQ9KV7xTCddd6CYqPZYsaM
	 k3ydyvegCfI4w==
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
Subject: [PATCH v3 12/21] kho: add kho_radix_init_tree()
Date: Thu,  9 Jul 2026 19:38:01 +0200
Message-ID: <20260709173821.429921-13-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
In-Reply-To: <20260709173821.429921-1-pratyush@kernel.org>
References: <20260709173821.429921-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AA4CE10000C
X-Stat-Signature: nesfihk34cynh51gsb5q8dw59tktgw1b
X-HE-Tag: 1783618743-447544
X-HE-Meta: U2FsdGVkX1/k2N2U3ycpHAWfDZESBqBEZ+tpyPO4e2633g2ddJG3wIeU7ZSAq+I0nHB/9puAHaXvZGXHLZ7rqjlFhb45SL6FjUBB2OeFy4EZZK5YyEk49hCtdqwxhAOX5/6TutJAuhtZIG4esBu8c6UhIHIE0YFLFNbcSuxd12WiYDNrD0MOo4k3rT9rTPRvlhm76qr/3VvF+DNvAsqF9IM2AVYzBzC0trOMleLhGdKwu43Fc/fYofHVOXGyrUpFCiOM8P7jgvIGNJycRZ2H0NZk238dREFMZG2pkJVv5IxoAoriSLwau1ARxM9gQ5x/SgtqfKmDo/kHBhYdKDGw1Xb1WGXAmA/dKQDuaX5z/DQ552kC/fvRu2Z3D9J9jZt7LgwReD19Oy06jh6jqN7lJ4/m5wRsi7dK7VVEkF9CaUryi0AJUFqtZ/kMZ6Xq60vft28JMfgccPZ2c/nYqFHLa4YPuFNH1c4ShEXvqj2OY1SyBAMiNYOSdp4KECQptEP3TChbWFNGBaOLEsa8KMfqJsoekYGxcotOb2gELjUV72HFz1nA3dcYHl4VFLOACOgRmu1rUms3146G6M5cMb0iTHQyA4EyIBwUfmlOJMn6e5poUiY5N8JwMVXNzo3lWlVWwH4a/qhfBpXu9ouNSkML09Vu3RpL5tX6PrLAe4c6Ae0as/q4h4ljGofjBcU4jEm6aYRC/cBrQTrXhzvG4z99In4EROpMale51Xs8fT/wksfev1Y2Zn4Atw8NKRe3NXeqMVP7Oe9Gk8s0+T5u5pZxBocZKyEMsyNaggL+mNxWsxvlnYsmRs/2UONj9xBw5iVWT4vxEdAhYfqT/LEufYIXAqmU/ogE2k55/HmOsm8tRxIAdvooJFG41BEG+JTyVwLX6mQ2yHdyeECauNr+gt2Um2nUv/C8X2GWeJzaJx8tMG7Jv/RhNPKr7Z3vXkA+4/rUm8pzuS1Y05EyjpEKARI
 XmMnB6YD
 a7rzHIl9eF1zGyHQklqthxuz9NUSPKGI1Totz5TzcGEIorTlj8jOmgvRX1RE2sqYA/WVX+ZTZ+fRmqe8EwlSuLaHMJbaWoU3zsAySFewo6DFcPjc9cPB/ugzpWm8fs3ZbD/YBFPXrnVayZKOgp5KnCsFMZXtRp806tjdGIrAGeQlCgWxTpmvp4TLeHpunM/L4p08zxZZibny09svKo83R5KL3u1ZobHAMKZYxVrmHhoUynvh0qEDm1Ry588nOLKY6yYftGawNW5hE4fySjcPeTMl8ASb+uve6dyXO
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
2.55.0.141.g00534a21ce-goog


