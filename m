Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09581CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 00:42:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 158466B008C; Wed, 27 May 2026 20:42:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E2E06B0092; Wed, 27 May 2026 20:42:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEC6C6B0093; Wed, 27 May 2026 20:42:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DCD176B008C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:42:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A371F1A06A5
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:24 +0000 (UTC)
X-FDA: 84814977408.20.1440D07
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf01.hostedemail.com (Postfix) with ESMTP id F3E2440013
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=aNqit3KB;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf01.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779928943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qtg35L2q2xRwHSsKrclbmv4EHz2zvqSPWUg8lI/YDVA=;
	b=iaXfOQfuTnSpqc/PNFAFCKqo6KEIuWrjBOatKwBk4BLKxxp/Sbtn6Tm3mpJJwcDlEjDthN
	d03yh59sfSL/Hy/LSXGrhskstFIwXoZ8mo9BxV+1HxK7yT9CDpZyOalzfIPjd1j1MfdepQ
	Hel+wrzdLSZFsnXrHutVVQtn7qQi8wE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=aNqit3KB;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf01.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779928943; a=rsa-sha256;
	cv=none;
	b=Uytruj59gRi9jeHS3FZkuQZMMNJUW2lRfySRhPFoObLRcFSI/lM7uPXTCc/gFYcnNs+INi
	+IDs27iflhhy05DfzZG6ia9zIG9QyUM1Tggep9kjWt0H4izQ0G2HDroDdBo+vm0+qwe20/
	kOskPt26iV56wPWrJKyWek4J+MMiuno=
Received: by linux.microsoft.com (Postfix, from userid 1241)
	id DC63D20B7171; Wed, 27 May 2026 17:42:11 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DC63D20B7171
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1779928931;
	bh=Qtg35L2q2xRwHSsKrclbmv4EHz2zvqSPWUg8lI/YDVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aNqit3KBt4dgCNj9E3c4pYnMmdEvIVLUR3/gOZSHXCYL/I3Gx9eMtb11nZR64Eef0
	 xgBMel7G/URxjTi/UfsmeYswamWChWlVND5cNvDETyd40iea1PcZyXwl0K9jUhbObC
	 BlXMq6HkC4/uWZNGKU2mwWcu24FF1YZZQSFHqMRI=
From: Jork Loeser <jloeser@linux.microsoft.com>
To: linux-hyperv@vger.kernel.org,
	linux-mm@kvack.org,
	kexec@lists.infradead.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Jason Miu <jasonmiu@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Baoquan He <bhe@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Kees Cook <kees@kernel.org>,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>,
	Justinien Bouron <jbouron@amazon.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Pingfan Liu <piliu@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Kelley <mhklinux@outlook.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Subject: [RFC PATCH 03/20] kho: add a struct for radix callbacks
Date: Wed, 27 May 2026 17:41:45 -0700
Message-ID: <20260528004204.1484584-4-jloeser@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
References: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F3E2440013
X-Stat-Signature: 1tiwgqp89udijjkcgmf4fg5okamcqsef
X-Rspam-User: 
X-HE-Tag: 1779928942-37709
X-HE-Meta: U2FsdGVkX1+OUhgQ/GuNSQvysbfUhcHRCIB+d7I2VkuOKokyfm/mLSKMU1THUpJz5tTDugxGQJzkLj4EmVHEj8nXRLLfe7epMWhpibRARn8N0Nfb3xW5BvoVx8ssi1yd9SkEY9Rooa0o3Z4noPuaZZTx3Z+awNVLFx3XEI58w8KZG3Cv1JCW7VJplJBdrx89A2GUsl7Q/t14k5nKt9R135da5sAvy2dcL9DTOho8T6swKxS2NzKtzKWRafRbNuElhKw279CcEA3rK8q9V6pOShB0CXoyXTe1Eyf8khK9omTBe3+yG3NuJeDzNSx+c7bzeknb38vlHs4eEyWZZ+p0Mw2Rx3s/PpAuiKP5l8ibeVS/eyV25n6RPh0S1YJfvgTqbpoAEPY1GkYwqbMOO0HRnSYxUoAEY0UEOF/tWrVeEk29jfO0a90v6KrV58hJgGgh0c6pwubgi93+iMc9i36RgeDmAyBLp1VMWNHnQ8ov+4XGO700jPzYTTLTOf0VMs8J3v/LpH9jmkNL39xv6odESFJTWxdfeyCfpEHm8HbzVryGT2NBvebxRxu4MILcDdEZokBwjRcXERLuv5Z/jt8TDJwEPElkF+ihAue/rIwG0Qr91gSYlk+Opacf767GJFaeSZoQDCMSG+HrkDWHRW+dRWW2eUVCJYbmkh1/6OlA+lyEglbYMuv+Sgtc+F44/FC5ctnfmT14UNQZckZebfvel3xOZwVHgkoiIX5Ip7mWZooE4WHJRUQnkzbTCJPWIogNQjT1YkvHoAGVb6c+vUe3IDs7A/mkx38b0u+jX9Jnmi7IbolvP3f6LaiTAlRGO2Ai+JJsME5T4sBTref29u8MwbVzEDIYp4KA0JzekHuAWAjyoBxm8Y3Pu7bYRhkz25Fmh1wt9ZlvTUveQovA6UIclNyx0rd1Ox4tIz9i2bMEixIFwAPzHp7Cob7vdiJcp8Gcw5EPpvhODJk1E0NOMvw
 eOl8yd9q
 z0ji0ph6T6ciLm4GBwkN/qRv9qV80YebH3cJSWC2I07vMeevlrwgryQbTNhfFCKo3Z0F3qZwoIcYabLwExP5zN5eYphDblWAKEu5tCTK1s4VStvoLx56adTvT0ij7+xUn7RZCDm2JmuNePsv9bQ97CGIsGWX2KSvLKPWlBnHC1wP3MDAAm0KA6tPp0GXn9pFOuNEjY86mRR9aVlafyXOHheExjfkWuK7hIMoOGQRG+CHwVBw=
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
Signed-off-by: Jork Loeser <jloeser@linux.microsoft.com>
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
index afc986845839..b22b3cec251e 100644
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
@@ -1396,10 +1396,13 @@ EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
 
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
2.43.0


