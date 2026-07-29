Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B3CEC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:56:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C64A96B0160; Wed, 29 Jul 2026 10:56:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C39786B0162; Wed, 29 Jul 2026 10:56:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B05216B0163; Wed, 29 Jul 2026 10:56:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 741BA6B0160
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:56:43 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 065221605DC
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:56:43 +0000 (UTC)
X-FDA: 85042115886.24.8BCB660
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 659F820011
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:56:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l2ZTFT8W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785337001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DfNI/eg3j2X2k/CIkH0J/irJxPI8VWbcAw18DR1ugaU=;
	b=F+JIs/N9UK1dukWXHaayWDAp7VTPhn7pn+zL4YEHxVc5HdR7xmwKIbW+CaPYf698BAQlwz
	+6hbcDh03FsVkuO2AQxJkOKF3LczXabNZ/Ph6XFUpSJoazqMhlpzAIhW7DvYo1gt3CSrx6
	o55WpARR3Hv7yP5q6oEskuN7/gV9l9E=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l2ZTFT8W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785337001;
	b=ihpHwOC3gxNXDi3oqiDCZWeuhg+K4MkVhBka4D/MpBC/uHx4j+Po4oQOK4TijSMc/z4X8T
	lkEd5iHXUvF+eNjM8Sc7YN3bEm8BixYoUDhE665SorFjecbU6lyKtaU+8QuEXXAv3St0P6
	pEhtMvn3GtE3sFvcqESDMBga0r0YTs0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EF780600B0;
	Wed, 29 Jul 2026 14:56:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C5471F000E9;
	Wed, 29 Jul 2026 14:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785337000;
	bh=DfNI/eg3j2X2k/CIkH0J/irJxPI8VWbcAw18DR1ugaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l2ZTFT8WN7ZImRicWiaeYLQvUk13Ic8ciRIrgtf2MjFSCJrAy7Omv3vznmh0Ttq8A
	 6KcMQvRPHsIBjMNiiDcxfBhXUccZdbbN0XJ2mHDlSyaZQgk4KXjcpJ/x6wkOQ+WxFX
	 Lynjo6w/Ba27ba9cn6apfb1/uxNxq8pUgzbi6NvkFjvibxGOqHFQQW1LD00vXpERXc
	 X/AbkG5+nih1aHrVrL8GvE5+DrEWfG1ChVThT3o0Qfub2qQIf7j4a7WqtWfnvRRK6k
	 kdidY0sPTN3AyQSs4GtVoVhjYnBTSl9QMLthUZrH54aYQq2hqzL0chgV/j9WvQbfrG
	 SXSKayJ6IEvEA==
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
Subject: [PATCH v5 07/22] kho: add a struct for radix callbacks
Date: Wed, 29 Jul 2026 16:55:52 +0200
Message-ID: <20260729145610.2827231-8-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <20260729145610.2827231-1-pratyush@kernel.org>
References: <20260729145610.2827231-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 659F820011
X-Rspam-User: 
X-Stat-Signature: 4n3ownsxxr8sj378y5iupdrr5pepeyt4
X-HE-Tag: 1785337001-801837
X-HE-Meta: U2FsdGVkX1+Ih7bpRXD3pUwyDBLkrTpPOLem9KmLy8nLa7kTTJKnOInajOR57UrYA4L0J6apyTBh2FttQj2so9OhacR1nFHDbbLlQsJn+s7a9U1zbRFJe1jm55fcy0KtsfPqVZDKzVNoqXK8kGIfIpRIB8B0aQaGzdmJVULFGo3uvjKo3TbrFdc50uuVK+7yS+e5QvzxD+KQLBvS6n7LJvr1qoy/yK1qXEnI3KP1rHC4GBi+eCD4B+yN89AWW0gt+dIeSK0AkXLW+kVSAZ8Qg+B29DHS0GGos7rMIihC+eIH7HX9Qf1B5XSgmcnH+kcgIy/vdWhk8g3KYq6tn/mZ7FrekKxqSr6ZFQN3pOsigVV2odIBoxCfen0oLrvkz8vaUm7s4w/W/nB/ohFBC4K4ehw4mU98ZeiuwH6VRIDdHZrnGP8AYSzRd+rUGzZG6IHf1CKWfJ14tJ9vC+0VlXVPhayse+PewZYkKfsI9wLIWRjUDJ7UxjARmJoprjUaXiM0eSWiMGQB5TXK4Q61KAAdJGZ259c8tRrWe30CUSS5s9t4/A5jxKUyFyhtgxa3f6m5SIIxXX2bxEkiBKbFaJeEPmEFbIX8R8K4f240ltb3xR/lPRYLyeItcpbLhGRoJB6x47VX69ryHGqqqLDro+V0OJMLNFN5c/6fO5ZsLQ4x0saAo8LseLIcgAPw1UORIaKVI9XjxZV9DxnNcM8grQTUbzM95oilaDvMuYJKrOxlxEtRoJSxZl/a5YAVSgQlJI/laFS7gNbzO/UQtDRRs5XB4uBOb9QTIlD8oqifk3G9tuI3tS+lQ8xBoJ+barHMYDQPozJWl1Ziq8ELBkUssKbm/4oSVoobcLwhXwBwoAJVfmeM2jZEZqLPnCZdEqF8g+yPu06pKsUc2p8KnJiB5RPJms8XWSRleyD26D6I2ZTSAiNMiYO3PT2U1uL9uUEvJxZ946FdyxVojgBpy7N+b1J
 vwC+VfzV
 oknjSaE96BTPUE3p6Ulk8toc79Iuu72yniUcFfwSAyi7tsXzBjb6ihIzGNfHfYWtrV3EA6fYRr2Zl/A6SU2n5h29eC5UKFGTMhMlH7mPfdt7s/GzpuqaCELCAv0BC/re55YMidiQqkdcytqPXv7ne4Ea12BUDaBMeVbIMcP+v5IkhCcXoBXTv543Rvjoq1SYQntDM+LEl3jeW/OQ0t7N+Jnl4MNp/55l0UpVC49XcBKOwxQ4=
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
2.55.0.508.g3f0d502094-goog


