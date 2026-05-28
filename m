Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33E64CD5BC9
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 00:42:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4661A6B0093; Wed, 27 May 2026 20:42:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EFE16B0096; Wed, 27 May 2026 20:42:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 241916B0098; Wed, 27 May 2026 20:42:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E43E6B0093
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:42:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF7EB16181C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:26 +0000 (UTC)
X-FDA: 84814977492.13.12392AD
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf01.hostedemail.com (Postfix) with ESMTP id 37BFB40011
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=bp34lIni;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf01.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779928945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J0h8gL8oeiYOkTla/NXs28W2cqoxPWC9xdMqpesgNs8=;
	b=oBOFrfgg9KDqFUngSCW2qtmt4H4aUNkaFbQn+M0GLsgqpGT5saU2zD3Y4t/DGpYlLelBiB
	MY+t8I7J1pCL3nrvUo2uNHKAbPzWeaehXGoj5lHukzKQiaHR+dND8H2SD/5RYhl4nX6IA/
	CDwHFijHDfGoTOHSHNKzrLJIY8bdus8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=bp34lIni;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf01.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779928945; a=rsa-sha256;
	cv=none;
	b=h9UU3jK0N5KwpYQH58EM+b9znRbWqerB8MjQnxz3u3gORmJJK+Uw+WCSWWIs7ctoqTynPI
	1NvDrR5zqb7lM2CpD3CITsvcCCwXdY7/VbWXjTF8j8A5eJMz2spizVeQhgtsva+TcZLLXZ
	HF5NkHuJPB7YratQnBGkPq2IDaJU+bc=
Received: by linux.microsoft.com (Postfix, from userid 1241)
	id 0F05620B7172; Wed, 27 May 2026 17:42:14 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0F05620B7172
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1779928934;
	bh=J0h8gL8oeiYOkTla/NXs28W2cqoxPWC9xdMqpesgNs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bp34lIniJvhoyH3OAvlDa8UBFuDbwE4WyLr0nUq53yto3zOxzO98Nh5+zW35NQyOi
	 AWoc5aUOfSx0bpnjf9q/TWyi/sXx3cdKU9GEMor/ruRJ+UnKadXc8pz+Rwrek/nPDF
	 3LKQcLdzKcZQVEwFPsrztbrAmGTcKgX5+JVDG8SU=
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
Subject: [RFC PATCH 05/20] kho: add data argument to radix walk callback
Date: Wed, 27 May 2026 17:41:47 -0700
Message-ID: <20260528004204.1484584-6-jloeser@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
References: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 37BFB40011
X-Stat-Signature: 5ifbi688so7ps9mxnjn9zkgtjoe3m9ji
X-Rspam-User: 
X-HE-Tag: 1779928945-460495
X-HE-Meta: U2FsdGVkX19GlPqpJ8eqgfsiDy44j9k2XwFzRZE2jmJQEWSrS9ahJqzhhfofX+ptUGKR/ZadPJGq2a+EGRqvhlk9ZbYa8b01qFs+HJLNW2J4jyAJX8HsdgtS8borsbZThqOlF+BpfcaE9eJGB2dY9G7OiEJMqz2Q4kySFRKA9FAHwvQCiMGmx8eDmNxm1M5SL8Irt5AjncETOnMXjbZrmxmY21pZ19RgG2Zg7hp6ajDBRIKjYUFj2ropMx/Kt9oQKI8fICQhQ/HoHKVk60EeMZtNack+i5wZbIertNzgQ1QlhuoMxVUXMpn4/nPcth0lgoaue8BPsszuT0q62HCwrJ74SnDDC6C1j3+9OI7LU0VkGJYKzvrNd+j7oMuuZzZ9PYMqBKOzWtzLzcqfLpgdWsy/HPE7wTWixtf6O9K5AffJK5KwaT+43OEPzl5++CEijTA7D/sQzWXQUT50lSoqUcDNswQyrzv2FSugftgnnipWhal3SkJt4a1gtY+FLJCIej0g4VgQxp2bvlcJaQkZVR984JKVS/crcXrKdlpV0ZK+moGx4lfDjwEg57CEIB0c0xs6SHRJf7qzkpXhAR/YMQPCxVtSYDb89AnaWPYk1Ji7Pim5p+nw4h3Hwm9ly6w6d8LtGfYaIg+Mu4tifrI2cZsdj2klN/rXsPybWKdLnHgENflgxSdiKMbo0R88UzB32pfoQtS+x5cQDGjHZRh1avi6yUunApKm0bwI4zytsa/vTslTfVhsvyecTmVlAK30bNYhuEuXPkrtXa5NWq8lidlTHoct6ygxmdJZ5JoCdu5HO+nPE6FEksa2CUe3rrWRl8j4kVD9fMbhve0V4srjJlU7Frfxup0zbO80yq/hdjxCjNetOvjdJPehp1lkNBbQHYKHT26K3gcK8D9VlUbAymBU7GZPhIm9WopnIayJmGd3qXrT+hm28OryPoceE3/AnjuMazbMxp3h5fm+kml
 x7DGasKk
 cnklVHHwXPOZ/YMrV0/Bh0H5Au4rwnFu076+m9CibAXlPFoJHt6etLw3c+bulKvSou0ls8zYm7Pz72pbM3wHisP0NNo0DroUnEcNNgZuNg+0zO7dPrjbkYTK4FNGHfZyNpToeSzjgZDgUsTI1BwhgX/DLxsp84xgCRXeGGja12QDZF5YZnz94rR5OkoTuGBtEyESCC+eg0fDH7hU6p/Bzz5gQx5uAjBwvrbazOdMof1xBCoSi0x6QqENPOmaV85B1+sXCh+AW0EO8apqwOPVM/lunWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Add an opaque data pointer argument to kho_radix_walk_cb_t. This can be
used for callers to pass extra information to the callback.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Jork Loeser <jloeser@linux.microsoft.com>
---
 include/linux/kho_radix_tree.h     |  8 ++++----
 kernel/liveupdate/kexec_handover.c | 24 +++++++++++++-----------
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho_radix_tree.h
index fe7151d89361..6c0f7d82716b 100644
--- a/include/linux/kho_radix_tree.h
+++ b/include/linux/kho_radix_tree.h
@@ -44,8 +44,8 @@ struct kho_radix_tree {
  * return value is directly returned to the caller.
  */
 struct kho_radix_walk_cb {
-	int (*key)(unsigned long key);
-	int (*table)(phys_addr_t phys);
+	int (*key)(unsigned long key, void *data);
+	int (*table)(phys_addr_t phys, void *data);
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
index 0f8d058f1a27..f6de6bf63226 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -267,14 +267,14 @@ void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key)
 EXPORT_SYMBOL_GPL(kho_radix_del_key);
 
 static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf, unsigned long key,
-			       const struct kho_radix_walk_cb *cb)
+			       const struct kho_radix_walk_cb *cb, void *data)
 {
 	unsigned long *bitmap = (unsigned long *)leaf;
 	unsigned int i;
 	int err;
 
 	if (cb->table) {
-		err = cb->table(virt_to_phys(leaf));
+		err = cb->table(virt_to_phys(leaf), data);
 		if (err)
 			return err;
 	}
@@ -283,7 +283,7 @@ static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf, unsigned long key,
 		return 0;
 
 	for_each_set_bit(i, bitmap, PAGE_SIZE * BITS_PER_BYTE) {
-		err = cb->key(key | i);
+		err = cb->key(key | i, data);
 		if (err)
 			return err;
 	}
@@ -293,7 +293,7 @@ static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf, unsigned long key,
 
 static int __kho_radix_walk_tree(struct kho_radix_node *root,
 				 unsigned int level, unsigned long start,
-				 const struct kho_radix_walk_cb *cb)
+				 const struct kho_radix_walk_cb *cb, void *data)
 {
 	struct kho_radix_node *node;
 	struct kho_radix_leaf *leaf;
@@ -302,7 +302,7 @@ static int __kho_radix_walk_tree(struct kho_radix_node *root,
 	int err;
 
 	if (cb->table) {
-		err = cb->table(virt_to_phys(root));
+		err = cb->table(virt_to_phys(root), data);
 		if (err)
 			return err;
 	}
@@ -323,10 +323,10 @@ static int __kho_radix_walk_tree(struct kho_radix_node *root,
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
@@ -340,6 +340,7 @@ static int __kho_radix_walk_tree(struct kho_radix_node *root,
  * kho_radix_walk_tree - Traverses the radix tree and calls a callback for each key.
  * @tree: A pointer to the KHO radix tree to walk.
  * @cb:   Set of callbacks to be invoked during the tree walk.
+ * @data: Opaque data pointer passed to each callback in @cb.
  *
  * This function walks the radix tree, searching from the top level down to the
  * lowest level (level 0), invoking the appropriate callbacks.
@@ -348,14 +349,15 @@ static int __kho_radix_walk_tree(struct kho_radix_node *root,
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
 
@@ -486,7 +488,7 @@ static struct page *__init kho_get_preserved_page(phys_addr_t phys,
 	return pfn_to_page(pfn);
 }
 
-static int __init kho_preserved_memory_reserve(unsigned long key)
+static int __init kho_preserved_memory_reserve(unsigned long key, void *data)
 {
 	union kho_page_info info;
 	struct page *page;
@@ -1414,7 +1416,7 @@ static int __init kho_mem_retrieve(const void *fdt)
 
 	kho_in.radix_tree.root = phys_to_virt(kho_get_mem_map_phys(fdt));
 	mutex_init(&kho_in.radix_tree.lock);
-	return kho_radix_walk_tree(&kho_in.radix_tree, &cb);
+	return kho_radix_walk_tree(&kho_in.radix_tree, &cb, NULL);
 }
 
 static __init int kho_out_fdt_setup(void)
-- 
2.43.0


