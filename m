Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E41BC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 17:40:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E80A36B009D; Thu,  9 Jul 2026 13:38:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5EDD6B009E; Thu,  9 Jul 2026 13:38:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D95A56B009E; Thu,  9 Jul 2026 13:38:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 735A56B009B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:38:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A71B1168D2F
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:38:57 +0000 (UTC)
X-FDA: 84969948714.16.407606C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 121751A0004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:38:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HEpny4QW;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783618736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9LMYnoR5UOfAzKTRDA0X1BjzCjLF6Srn3sMzOnAMfpQ=;
	b=K7hV22PhzXUGZcUoTZ4HFd/FEs9+foIc2fRV90/dS3AC+PME0gSHodohT98nJifh7+3Tr2
	t6JOFLngkZJfDh1vz4aoGpZosYAGAwtPgzp4yM8kFM01iY8IJkf3NhDAYlZSL7zh21cRLz
	zYujofO9MxKszRHNHFY9a8fyzEW2mQw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HEpny4QW;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783618736;
	b=S0QMCnvZXZ9P8/95FbYvHQSK3u+/aj8y0l5tP4J5i6isBnoreewcDYp90k56PzIiGlkthR
	qliDPHc7rfARGHWOYoOYKNF51zoeiVMsUJw+B5A5WtKA8y2Y3YPvU75dlm2gUi03+yN3Rg
	w2pUcb6i4ArwbDX7b0dK2oN0hNkD0JU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B29943987;
	Thu,  9 Jul 2026 17:38:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2963F1F00A3F;
	Thu,  9 Jul 2026 17:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783618735;
	bh=9LMYnoR5UOfAzKTRDA0X1BjzCjLF6Srn3sMzOnAMfpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HEpny4QWGDc9Mg1urk7F8ysOTwHcJzus9AxyO2SB8stA0GPqaOSCwaZIDEUfPZd6i
	 SwQ51Bu2ZlWUHeyh76PWAdQPDkiwJccrIpbBE+HP6fAcpnXz0hg1IzYDf2Rx3Dpzc1
	 Aht2VtmjD6zFVZmd0+xq3JO1+EvKVuK21xBk2PmCyJN+Hs5v5WxeOHB97a7vjV5MmS
	 d4qbIqyKgksbdRQv20PUj0TEp0B2+GvoBtuCXsdB0vDhbPDtPj36SbLQPx6e9WSkPR
	 HVur+vqqb6yA3YKWEbBPg6EGV1G/+vs/oxgK+NnDhtM2y+BFCFpL0egMfIotm2rDgU
	 aT1mFDVcS2zZA==
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
Subject: [PATCH v3 09/21] kho: add data argument to radix walk callback
Date: Thu,  9 Jul 2026 19:37:58 +0200
Message-ID: <20260709173821.429921-10-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
In-Reply-To: <20260709173821.429921-1-pratyush@kernel.org>
References: <20260709173821.429921-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 378oe4sx45xrbw66oaj7bpkxojfggrpk
X-Rspamd-Queue-Id: 121751A0004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783618735-88545
X-HE-Meta: U2FsdGVkX19QaaAfCHDHjOnFxa43m8lDejXlvoKDx+SUGvFhMfxH0k0YkyAO5NVRLl/CwraelidReOeMuuSw7NF5jTFSd3NvD4yfnlNtMSzKF3wBCFm12nux/KngdEg1nKgRtF+VrBgYN1GFvtifUfqk3IjkkBn17zlFhIgSyMANOg0Y9w0D8mMZpHTSKwsvxeW04/YypRF6XgXW1NhoA46h4mkwXiZUrK2WUF3JGn5Y5LUSuqQ2z/3qS9SMs4IPOOu0eVARFSyMTi7w2ckBTY8T3K6iq8Y7IE4oNpP00ka5CsxbDi254Azc2UAg3D3aPB0af35TFA0tQhm4W8nRV++2KGAfDQoOUP4FUfXV2sFUR53P2OKZa5E2PQ4qMP1lhGUaSt1f1L2AkkX2II5E7bNe8tcE2vfjG+ZeTVXUCyhJtQPt1JGUgJeibzlVtRwYaWkHnQIVsoDk9YNmoqCPkTmsc/pNqQ44X2iy4VF11YsqqdSTttzO41+RjVrwbrLGd1mtZj+MLoy4+5bkVpjwBhOjN+xed38ZnBIbyBkNUzTuFPzknWCGDCdi8n/ebLdEYBkb9FtzTIYu2/37PvIttatAbSrAPqLHgwBUQkB5O2WMFUhnnPWbb1nYh4Z+Umqzd9+tJgCXQREdEbcf2EQR5jN3sPTLM3XrWJJysGCihUPX45HYCZVNLsUe27F9bOgV7lmARl2W3eejuCFCNe3CTkM1roftMNg7fwePgUOTzzOFIPudDyxSYfnN+yBuYQGaxYFW5Pf/TzXHTaJMG8NbnD5MX3NOkeIQ6FNBJeM9lBGhZ8j5pcUBvrpwxI3kixxhBYQM9vb+o6Kk0t+Rsjm9ul2Qw+cQCnXkLW75SmeXMnUqxN8jI+4JFonRqZd+qAMDN1DSIUuwJV3r/zmCEuMfRkIEIOWAfZwo2JX8wUulfG4Szu+APQdbRZGBItami8IE2Z73swaMcji2KN8uW5T
 fezO4J8q
 xKwIaqlKcpx7W/1/E2WWFdnNDnWdjd8xxWLuqPCeJOEds872Cj83oI/2zUQFbcJwJc6HUf4Klh6hgPafrfHbff4J3p6lwHLtb4OWTOs/dn/EG5F3Pl61su8/jsqm9/eU7IC6P3DTt6HeuVlDUuefdR99HmdLR+NdhkjdExTzkwWxFfY/sILVbVXSYREWfcmP0dP0mFaATGMDl8jUiseTrRpnQcHLIRro5ZFuI4cu7+HWPUiJY2aVQlCpTD8sLYI3FQPpTCgb/RFNk0MCNjpp9igrY7GHm755XcsBqicGqOXJZmKA=
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
2.55.0.141.g00534a21ce-goog


