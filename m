Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97B08CD1297
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 13:39:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88C846B0096; Wed, 29 Apr 2026 09:39:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83DEA6B0098; Wed, 29 Apr 2026 09:39:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DF446B0099; Wed, 29 Apr 2026 09:39:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5C41D6B0096
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:39:54 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1F7BDA0258
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:39:54 +0000 (UTC)
X-FDA: 84711701508.03.85D25C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7274F40006
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:39:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=np2Qg1Og;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777469992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w43KFUkArY6lknz9gNrxkbJ9jhP+SRfZ6SXj91A9It8=;
	b=WIcCgcLcznPWwGQgtcf1P3VbSL3zcoINv8V9L+qn0ZL8jiRaAwwe1t+bB3ti09q4WQ3mHO
	Nzs6eUhR2PgumJoaBrLUC9tnLLDJqCymF43Sx0y2HA4tQ8kIQKhXKVyaRaKsmXaexS8H1T
	bm5sTQeUDBAhmCE+yaQAy6GACZ53cOg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=np2Qg1Og;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777469992; a=rsa-sha256;
	cv=none;
	b=hSEOmli0pUMn5o94mgAdXfNRmXU8bKxG5ELLEM0iqnB6fdmnWpMF/LxGHUGjKCWKjqOuGh
	uFmKlLOnKiFPvRSfrHMleIOKW6CQuae0lXM7PR0TV+XXU/h4N7O+deaEnYTacwnGqXgJ/f
	8lQ2oKHEF4Ma2m4WsCXa/8K+O0nULY8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D972860582;
	Wed, 29 Apr 2026 13:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F97AC2BCC4;
	Wed, 29 Apr 2026 13:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777469991;
	bh=tnjp4B+bCIr0sG99AF+rCD8R2O3pqFA0kGLY1BJsYzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=np2Qg1OgEt3WN2MkvhLzhwY8UbvPQFLhzjnwDrKCU8Kn62aAROgNpcfLruLLIFqp9
	 IAUL+1FxC8YHK1/fZzgVsHelhu/opytSHJgcIN+O8CD7IktoVyTXP8Gi7/xIp/S1q3
	 zGORtXd+I/acbf57qO5HQLDXDcvIvXKCf9FZKX45ThMjKe9XBNb3PiuDrRNAMuu710
	 8zu86r369RHIlhs8R0B+730jKoHmVkdqOKD+Q4dbNv3Xt1bALxSzLY0+rz2TgwMVNz
	 zoISlzkM3+pyKFBoEkeT5wnTdQ0mNdSLGezpn9lPGnEvXgMld3rJogD2+dF+fFRlaC
	 DTtiFvTKOBU+A==
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
Subject: [PATCH 03/12] kho: add a struct for radix callbacks
Date: Wed, 29 Apr 2026 15:39:05 +0200
Message-ID: <20260429133928.850721-4-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
In-Reply-To: <20260429133928.850721-1-pratyush@kernel.org>
References: <20260429133928.850721-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7274F40006
X-Stat-Signature: doc3esfzqsfgo1jrdcpc9jwhzdfhw6ei
X-HE-Tag: 1777469992-898643
X-HE-Meta: U2FsdGVkX19vknvA/8PPdUFRZEvyTg9b0KfHSRLeedzef/pHBobKs5u5BV40bsQtpWC+DcTnMyQtK7FPv0zn7s6KQtg1o73Rod6ruszsR8q/OrrxyWyVzSFO8F6CA6EuRac+QcawfiQnHujA3zpYOcodP+pQ2OPGWdcH7PQ4ApArIuTlOw1MgHdjunS8IgDolJuyVKoS7KPiHJ4WrJIBvLb+Nh3JmzeXOL78sWJnolPQ6mGb5ZH5HwhYPB31ZquMhGlzPwM85FMhFJN6VmH9HY+vBfBsL4iOGfpUzJpuvjW/C3gX9pGao+idOwC0uXLijEBH4sRmEYO7TRXTClqiW1+MDnVELs0uGLC9K82c2ULGPbySvkYk1D6gJqqXlR8lHr5zdGv6hQk0TlfY5hMCP2xgpveTGGl7+lFG/Y7nnNvEY8V9PVznqSEEGWebRnu5BvzlUyiJuZH2/I1/RLBr2mUGuz8lEpvbKBMg3vdGsxVHQ18CatMVgu7WZ0L5Jy2p/3sczsSz9z8ZffdlYVVil/p4Gns44bcjzOaqOFL+T6leDGXJdiNSKPiPfKWbOBdo1X7U9ooki8zPKDzfRKNXZX4mFeqgDiNjAqLkfEcgB9vlsW5i3nj6tsVGHr32d7g/Q4Zatd4zAcDA7NbbLLywtPggV2+v+HyyT+I+DqybeBvhFWTI3YvE14dOjHVO47NpSgapCDAN40z1Z/GcjodkGpYcY5g8ly+XXR7QUqoE704KrEob+r2XTbF/b541bqD79aUzsjLsF9HPUeD4E2ZLCe+kC73/IVmXSjgXQzVvVGK4yUNnJMpdoXY8VvmYB0T1vWPwWQYZtegdDzMYVH9pnRk1r74feQw+ltcxpjgBJdWg/w3CM3oJHtf7vtIKO8Ra+WF+BVLvFbVn4shpLivUNz6adULN9QpwFSqWcIKDslQajVRzY8AZkUU/1EBCyZ4zm+dIi9NzkGJE+j48Ncw
 3tSbxKaG
 mKWhRq+h7/O6qqlFQx3QiZ9w35xPyV8B9DLwXIZzcSZTIa2PXqads2bLVnGbvUo13q1lGw++I5pSWzJ1agL1++U96bre/PaJh7VZSs3LeWfxA3M4RlADVObBj+wXPO0kqPSn0/f3lkDy+R1vEWq93HG1wSE0uBRbUfSxMtxkdJHIkTaxVTgMcCbbYO0eGVraSETWt
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
 kernel/liveupdate/kexec_handover.c | 29 ++++++++++++++++-------------
 2 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho_radix_tree.h
index f368f3b9f923..030da6399d28 100644
--- a/include/linux/kho_radix_tree.h
+++ b/include/linux/kho_radix_tree.h
@@ -34,14 +34,23 @@ struct kho_radix_tree {
 	struct mutex lock; /* protects the tree's structure and root pointer */
 };
 
-typedef int (*kho_radix_tree_walk_callback_t)(unsigned long key);
+/**
+ * struct kho_radix_walk_cb - Callbacks for KHO radix tree walk.
+ * @key:      Called on each present key in the radix tree.
+ *
+ * For each callback, a return value of 0 continues the walk and a non-zero
+ * return value is directly returned to the caller.
+ */
+struct kho_radix_walk_cb {
+	int (*key)(unsigned long key);
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
index 5758dc6fab5d..4a5d1b47799c 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -266,16 +266,18 @@ void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key)
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
 
+	if (!cb->key)
+		return 0;
+
 	for_each_set_bit(i, bitmap, PAGE_SIZE * BITS_PER_BYTE) {
-		err = cb(key | i);
+		err = cb->key(key | i);
 		if (err)
 			return err;
 	}
@@ -285,7 +287,7 @@ static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf,
 
 static int __kho_radix_walk_tree(struct kho_radix_node *root,
 				 unsigned int level, unsigned long start,
-				 kho_radix_tree_walk_callback_t cb)
+				 const struct kho_radix_walk_cb *cb)
 {
 	struct kho_radix_node *node;
 	struct kho_radix_leaf *leaf;
@@ -325,18 +327,16 @@ static int __kho_radix_walk_tree(struct kho_radix_node *root,
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
@@ -1374,10 +1374,13 @@ EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
 
 static int __init kho_mem_retrieve(const void *fdt)
 {
+	const struct kho_radix_walk_cb cb = {
+		.key = kho_preserved_memory_reserve,
+	};
+
 	kho_in.radix_tree.root = phys_to_virt(kho_get_mem_map_phys(fdt));
 	mutex_init(&kho_in.radix_tree.lock);
-	return kho_radix_walk_tree(&kho_in.radix_tree,
-				   kho_preserved_memory_reserve);
+	return kho_radix_walk_tree(&kho_in.radix_tree, &cb);
 }
 
 static __init int kho_out_fdt_setup(void)
-- 
2.54.0.545.g6539524ca2-goog


