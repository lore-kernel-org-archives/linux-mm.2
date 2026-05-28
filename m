Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7ABCCD5BD0
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 00:42:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC6106B0088; Wed, 27 May 2026 20:42:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E741F6B008A; Wed, 27 May 2026 20:42:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC9EC6B008C; Wed, 27 May 2026 20:42:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BA54A6B0088
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:42:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08F26C2542
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:23 +0000 (UTC)
X-FDA: 84814977366.01.A287CAC
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id 44DC2C0002
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b="lct/Lzz2";
	spf=pass (imf10.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779928941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VrkPaygr2fiR9qkgZ/y5k9kPl3Y1n49OhlGz+CZ1NBk=;
	b=O+oMAt0NDL/LBUBKyix41kD+la4WcrSCiC9i69KjCyRnM57ygrgCR0/flttVjV4nCkkkth
	uJ2Y0q8xdQ+3m87/kh2T3Ibr3QR7WFmJvbWJJXRQc26G184lZMvjSfUnxNcvKRpxWhIykx
	KY1LNx/CkoBEy7MFYaD1VMqOaTZDlyo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b="lct/Lzz2";
	spf=pass (imf10.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779928941; a=rsa-sha256;
	cv=none;
	b=r137AyUVqAjwK86nEfn/zOHFh/mazQNKAwVx7DzW71GrIWJ8Nvhaywh6SW+XcznRK/dmGu
	Vaz5lMWeAsDVyyP+rezXD4w27J7SHTpyj9sZDK7hz9KVXNVwjWXrUemRYHnVlOKUoIrLBP
	o4NVko15XNkzRDY/1TFAcbNuBDRlTAg=
Received: by linux.microsoft.com (Postfix, from userid 1241)
	id 645D920B7169; Wed, 27 May 2026 17:42:09 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 645D920B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1779928929;
	bh=VrkPaygr2fiR9qkgZ/y5k9kPl3Y1n49OhlGz+CZ1NBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lct/Lzz2KArrSPa2PHBxiD3M4M7s1xzehdPn+Eg5DyiakpgnaQiilEHYfEROam0A3
	 sbgJLPBzaz2Ch5tSaFRbiy3qqs8CuiboCgQwzSZUAgwS+KUSz9ZGNTvEnrkKGrk1AO
	 vJVx+zJosYthakqsffmB5JJFqtIvRGuuS5TApLEU=
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
Subject: [RFC PATCH 01/20] kho: generalize radix tree APIs
Date: Wed, 27 May 2026 17:41:43 -0700
Message-ID: <20260528004204.1484584-2-jloeser@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
References: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 44DC2C0002
X-Stat-Signature: kigzgcqc4m9nfq3ftc3rky7xb11tj4bi
X-HE-Tag: 1779928941-953575
X-HE-Meta: U2FsdGVkX1+LZ398Ztj9a/bgbB9WwFhkGWBEjZW1VzZBQ7I0qMNETqhaC11w3bsXHxhmBBDqGa85MO4MoyI6+PVMWu8cv1ir+tIZwPDMSRjdI5Ekgy1K07629mGUILaT9SPHZjWRxIXi+3cWo7AR/A42awd5+g4mmosVRExY4fHXEq8mUg/fo54dRB9KkQl1JC9XlKMKUGGSegjnEMeRJhneelE5tEJGqseXSpMJl8nTWMQ28pQTlnQKNNAutcSZyopA1rY5YCfb7LCEfPl5Boiqk+5DGAqLxSDOv/gP8eZhLtzVfbWSN/a09ISyyLuX3GTOdgs2TpJz7gKoIN6GQlB9DL8RgTI3bYTWn/UplmZXueyU1k+PK7wj8hvmd7dGzoJOICZ+ReK6tQseDYU+3AS0+ylauowAv4PE7UrfyQ36ABbKtVllxsS1qsga7lQtoitqwHyyk7nOeOk3Oqxdf5wPv6+uueupKGYeAQDbTlrKtPvWTBGJ687vfnU+2Bqb+s+zovcsCQCUKEzmhCVm62AfydKKIeLB7wddpWBC/e/oR70goBIwEf0HYAbns59nqQtuUhzum66aGP1zHzEFEFcsobmTqIq7qRuFwm+xK22+zNCdTqVr4nR6AqR285gyDSaa90KZINmZYGwr5Ro9OwjAbCw0UA3jS/x5sKVr2Otwe3lgVcPs9wxqJq9Rf43PjEOd+RSnVO1i7HiLIxgdySFXQtbMipNjQPFvOTUcW8I8Eza/hojAiIFYy5pATm46j3nBvc4i5Qa/paF2uuEyfSz7lnuJYgehpeAQRb4jAruWNlZq3AgKr2ei+YH0Up/ZaCvZru1a9lw6pw/5HwaWB6nZKDCnR2GEGS6wlV95LUqzIm4lNyIZ68D1tnhxqo3St+NJoEULmbL6cBOaw3YIoL487+1kWkc9cM93SavRVIhjeWKHgOQxh0uUFHCzfe6joIbmB3eJwYbgz6ymhpK
 N6fJWMHf
 eucl5aX6V+jJBX0GJuVGzELXdv3bGnFAtpeeB4vOrkBdgOVl3yd25N3NorbatcUplUeTUckc+n2mcYOzqYYlYZtTr5JNeWnMVkxfb9qpghCY+eqFOY9RU9G8T+ZtCU+VHHXPSg3MRklTTmllWDCzLcL/Rdtq50pi1CH0lt4h9fQ7RVtm9GV/sk1nciGZj9oHYeb98x/CyK3OslDe8t3kilBm26AMFPKh8o6T0Xv7pchK2iivaH/FEKp7eTeBe9vt5HsUh7PuU1H8suNAPQAd0+fIZVQB8YE//WPoOX/9Mz5U2YWGTLywaFke64QHlAEmJp5+bX9aic07EZtk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

The KHO radix tree is a data structure that can track the presence or
absence of an arbitrary key, with nothing inherently tied to KHO memory
preservation tracking. This was one of the design goals of the radix
tree. This was done to enable it to be re-used by other users of KHO.

Despite that, the radix tree APIs are very closely tied to KHO memory
preservation tracking. Adding a key is done by kho_radix_add_page(),
which encodes it as a page tracking operation and takes in PFN and
order. kho_radix_del_page() does the same. These functions encode the
key internally that goes into the radix tree. kho_radix_walk_tree() does
the same by baking the PFN and order into the callback arguments.

Generalize the APIs by taking the key directly and doing the encoding at
the callers. Rename the functions to kho_radix_add_key() and
kho_radix_del_key(). In practice, this removes a line each from the
functions and moves the encoding function call to the callers.
Similarly, update kho_radix_tree_walk_callback_t to take the key
directly.

To keep the naming convention clearer, rename
kho_radix_{encode,decode}_key() to kho_{encode,decode}_radix_key().

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Jork Loeser <jloeser@linux.microsoft.com>
---
 include/linux/kho_radix_tree.h     |  18 ++---
 kernel/liveupdate/kexec_handover.c | 119 ++++++++++++++---------------
 2 files changed, 63 insertions(+), 74 deletions(-)

diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho_radix_tree.h
index 84e918b96e53..f368f3b9f923 100644
--- a/include/linux/kho_radix_tree.h
+++ b/include/linux/kho_radix_tree.h
@@ -34,30 +34,24 @@ struct kho_radix_tree {
 	struct mutex lock; /* protects the tree's structure and root pointer */
 };
 
-typedef int (*kho_radix_tree_walk_callback_t)(phys_addr_t phys,
-					      unsigned int order);
+typedef int (*kho_radix_tree_walk_callback_t)(unsigned long key);
 
 #ifdef CONFIG_KEXEC_HANDOVER
 
-int kho_radix_add_page(struct kho_radix_tree *tree, unsigned long pfn,
-		       unsigned int order);
-
-void kho_radix_del_page(struct kho_radix_tree *tree, unsigned long pfn,
-			unsigned int order);
-
+int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key);
+void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key);
 int kho_radix_walk_tree(struct kho_radix_tree *tree,
 			kho_radix_tree_walk_callback_t cb);
 
 #else  /* #ifdef CONFIG_KEXEC_HANDOVER */
 
-static inline int kho_radix_add_page(struct kho_radix_tree *tree, long pfn,
-				     unsigned int order)
+static inline int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key)
 {
 	return -EOPNOTSUPP;
 }
 
-static inline void kho_radix_del_page(struct kho_radix_tree *tree,
-				      unsigned long pfn, unsigned int order) { }
+static inline void kho_radix_del_key(struct kho_radix_tree *tree,
+				     unsigned long key) { }
 
 static inline int kho_radix_walk_tree(struct kho_radix_tree *tree,
 				      kho_radix_tree_walk_callback_t cb)
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 4834a809985a..05a6eb56e176 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -85,7 +85,7 @@ static struct kho_out kho_out = {
 };
 
 /**
- * kho_radix_encode_key - Encodes a physical address and order into a radix key.
+ * kho_encode_radix_key - Encodes a physical address and order into a radix key.
  * @phys: The physical address of the page.
  * @order: The order of the page.
  *
@@ -95,7 +95,7 @@ static struct kho_out kho_out = {
  *
  * Return: The encoded unsigned long radix key.
  */
-static unsigned long kho_radix_encode_key(phys_addr_t phys, unsigned int order)
+static unsigned long kho_encode_radix_key(phys_addr_t phys, unsigned int order)
 {
 	/* Order bits part */
 	unsigned long h = 1UL << (KHO_ORDER_0_LOG2 - order);
@@ -106,17 +106,17 @@ static unsigned long kho_radix_encode_key(phys_addr_t phys, unsigned int order)
 }
 
 /**
- * kho_radix_decode_key - Decodes a radix key back into a physical address and order.
+ * kho_decode_radix_key - Decodes a radix key back into a physical address and order.
  * @key: The unsigned long key to decode.
  * @order: An output parameter, a pointer to an unsigned int where the decoded
  *         page order will be stored.
  *
- * This function reverses the encoding performed by kho_radix_encode_key(),
+ * This function reverses the encoding performed by kho_encode_radix_key(),
  * extracting the original physical address and page order from a given key.
  *
  * Return: The decoded physical address.
  */
-static phys_addr_t kho_radix_decode_key(unsigned long key, unsigned int *order)
+static phys_addr_t kho_decode_radix_key(unsigned long key, unsigned int *order)
 {
 	unsigned int order_bit = fls64(key);
 	phys_addr_t phys;
@@ -144,24 +144,21 @@ static unsigned long kho_radix_get_table_index(unsigned long key,
 }
 
 /**
- * kho_radix_add_page - Marks a page as preserved in the radix tree.
+ * kho_radix_add_key - Add a key to the radix tree.
  * @tree: The KHO radix tree.
- * @pfn: The page frame number of the page to preserve.
- * @order: The order of the page.
+ * @key: The key to add.
  *
- * This function traverses the radix tree based on the key derived from @pfn
- * and @order. It sets the corresponding bit in the leaf bitmap to mark the
- * page for preservation. If intermediate nodes do not exist along the path,
- * they are allocated and added to the tree.
+ * This function traverses the radix tree based on the key provided. It sets the
+ * corresponding bit in the leaf bitmap to mark the key as present. If
+ * intermediate nodes do not exist along the path, they are allocated and added
+ * to the tree.
  *
  * Return: 0 on success, or a negative error code on failure.
  */
-int kho_radix_add_page(struct kho_radix_tree *tree,
-		       unsigned long pfn, unsigned int order)
+int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key)
 {
 	/* Newly allocated nodes for error cleanup */
 	struct kho_radix_node *intermediate_nodes[KHO_TREE_MAX_DEPTH] = { 0 };
-	unsigned long key = kho_radix_encode_key(PFN_PHYS(pfn), order);
 	struct kho_radix_node *anchor_node = NULL;
 	struct kho_radix_node *node = tree->root;
 	struct kho_radix_node *new_node;
@@ -224,22 +221,19 @@ int kho_radix_add_page(struct kho_radix_tree *tree,
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(kho_radix_add_page);
+EXPORT_SYMBOL_GPL(kho_radix_add_key);
 
 /**
- * kho_radix_del_page - Removes a page's preservation status from the radix tree.
+ * kho_radix_del_key - Removes the key from the radix tree.
  * @tree: The KHO radix tree.
- * @pfn: The page frame number of the page to unpreserve.
- * @order: The order of the page.
+ * @key: The key to remove.
  *
  * This function traverses the radix tree and clears the bit corresponding to
- * the page, effectively removing its "preserved" status. It does not free
- * the tree's intermediate nodes, even if they become empty.
+ * the key, effectively removing it from the tree. It does not free the tree's
+ * intermediate nodes, even if they become empty.
  */
-void kho_radix_del_page(struct kho_radix_tree *tree, unsigned long pfn,
-			unsigned int order)
+void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key)
 {
-	unsigned long key = kho_radix_encode_key(PFN_PHYS(pfn), order);
 	struct kho_radix_node *node = tree->root;
 	struct kho_radix_leaf *leaf;
 	unsigned int i, idx;
@@ -270,21 +264,18 @@ void kho_radix_del_page(struct kho_radix_tree *tree, unsigned long pfn,
 	idx = kho_radix_get_bitmap_index(key);
 	__clear_bit(idx, leaf->bitmap);
 }
-EXPORT_SYMBOL_GPL(kho_radix_del_page);
+EXPORT_SYMBOL_GPL(kho_radix_del_key);
 
 static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf,
 			       unsigned long key,
 			       kho_radix_tree_walk_callback_t cb)
 {
 	unsigned long *bitmap = (unsigned long *)leaf;
-	unsigned int order;
-	phys_addr_t phys;
 	unsigned int i;
 	int err;
 
 	for_each_set_bit(i, bitmap, PAGE_SIZE * BITS_PER_BYTE) {
-		phys = kho_radix_decode_key(key | i, &order);
-		err = cb(phys, order);
+		err = cb(key | i);
 		if (err)
 			return err;
 	}
@@ -332,15 +323,14 @@ static int __kho_radix_walk_tree(struct kho_radix_node *root,
 }
 
 /**
- * kho_radix_walk_tree - Traverses the radix tree and calls a callback for each preserved page.
+ * kho_radix_walk_tree - Traverses the radix tree and calls a callback for each key.
  * @tree: A pointer to the KHO radix tree to walk.
  * @cb: A callback function of type kho_radix_tree_walk_callback_t that will be
- *      invoked for each preserved page found in the tree. The callback receives
- *      the physical address and order of the preserved page.
+ *      invoked for each key in the tree.
  *
  * This function walks the radix tree, searching from the specified top level
- * down to the lowest level (level 0). For each preserved page found, it invokes
- * the provided callback, passing the page's physical address and order.
+ * down to the lowest level (level 0). For each key found, it invokes the
+ * provided callback.
  *
  * Return: 0 if the walk completed the specified tree, or the non-zero return
  *         value from the callback that stopped the walk.
@@ -484,13 +474,16 @@ static struct page *__init kho_get_preserved_page(phys_addr_t phys,
 	return pfn_to_page(pfn);
 }
 
-static int __init kho_preserved_memory_reserve(phys_addr_t phys,
-					       unsigned int order)
+static int __init kho_preserved_memory_reserve(unsigned long key)
 {
 	union kho_page_info info;
 	struct page *page;
+	unsigned int order;
+	phys_addr_t phys;
 	u64 sz;
 
+	phys = kho_decode_radix_key(key, &order);
+
 	sz = 1 << (order + PAGE_SHIFT);
 	page = kho_get_preserved_page(phys, order);
 
@@ -618,30 +611,20 @@ early_param("kho_scratch", kho_parse_scratch_size);
 
 static void __init scratch_size_update(void)
 {
-	/*
-	 * If fixed sizes are not provided via command line, calculate them
-	 * now.
-	 */
-	if (scratch_scale) {
-		phys_addr_t size;
+	phys_addr_t size;
 
-		size = memblock_reserved_kern_size(ARCH_LOW_ADDRESS_LIMIT,
-						   NUMA_NO_NODE);
-		size = size * scratch_scale / 100;
-		scratch_size_lowmem = size;
+	if (!scratch_scale)
+		return;
 
-		size = memblock_reserved_kern_size(MEMBLOCK_ALLOC_ANYWHERE,
-						   NUMA_NO_NODE);
-		size = size * scratch_scale / 100 - scratch_size_lowmem;
-		scratch_size_global = size;
-	}
+	size = memblock_reserved_kern_size(ARCH_LOW_ADDRESS_LIMIT,
+					   NUMA_NO_NODE);
+	size = size * scratch_scale / 100;
+	scratch_size_lowmem = round_up(size, CMA_MIN_ALIGNMENT_BYTES);
 
-	/*
-	 * Scratch areas are released as MIGRATE_CMA. Round them up to the right
-	 * size.
-	 */
-	scratch_size_lowmem = round_up(scratch_size_lowmem, CMA_MIN_ALIGNMENT_BYTES);
-	scratch_size_global = round_up(scratch_size_global, CMA_MIN_ALIGNMENT_BYTES);
+	size = memblock_reserved_kern_size(MEMBLOCK_ALLOC_ANYWHERE,
+					   NUMA_NO_NODE);
+	size = size * scratch_scale / 100 - scratch_size_lowmem;
+	scratch_size_global = round_up(size, CMA_MIN_ALIGNMENT_BYTES);
 }
 
 static phys_addr_t __init scratch_size_node(int nid)
@@ -859,7 +842,8 @@ int kho_preserve_folio(struct folio *folio)
 	if (WARN_ON(kho_scratch_overlap(pfn << PAGE_SHIFT, PAGE_SIZE << order)))
 		return -EINVAL;
 
-	return kho_radix_add_page(tree, pfn, order);
+	return kho_radix_add_key(tree, kho_encode_radix_key(PFN_PHYS(pfn),
+							    order));
 }
 EXPORT_SYMBOL_GPL(kho_preserve_folio);
 
@@ -877,7 +861,7 @@ void kho_unpreserve_folio(struct folio *folio)
 	const unsigned long pfn = folio_pfn(folio);
 	const unsigned int order = folio_order(folio);
 
-	kho_radix_del_page(tree, pfn, order);
+	kho_radix_del_key(tree, kho_encode_radix_key(PFN_PHYS(pfn), order));
 }
 EXPORT_SYMBOL_GPL(kho_unpreserve_folio);
 
@@ -906,7 +890,8 @@ static void __kho_unpreserve(struct kho_radix_tree *tree,
 	while (pfn < end_pfn) {
 		order = __kho_preserve_pages_order(pfn, end_pfn);
 
-		kho_radix_del_page(tree, pfn, order);
+		kho_radix_del_key(tree, kho_encode_radix_key(PFN_PHYS(pfn),
+							     order));
 
 		pfn += 1 << order;
 	}
@@ -937,9 +922,19 @@ int kho_preserve_pages(struct page *page, unsigned long nr_pages)
 	}
 
 	while (pfn < end_pfn) {
-		unsigned int order = __kho_preserve_pages_order(pfn, end_pfn);
+		unsigned int order =
+			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
+
+		/*
+		 * Make sure all the pages in a single preservation are in the
+		 * same NUMA node. The restore machinery can not cope with a
+		 * preservation spanning multiple NUMA nodes.
+		 */
+		while (pfn_to_nid(pfn) != pfn_to_nid(pfn + (1UL << order) - 1))
+			order--;
 
-		err = kho_radix_add_page(tree, pfn, order);
+		err = kho_radix_add_key(tree, kho_encode_radix_key(PFN_PHYS(pfn),
+								   order));
 		if (err) {
 			failed_pfn = pfn;
 			break;
-- 
2.43.0


