Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 059E7CD6E75
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 03:32:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FC416B008A; Thu,  4 Jun 2026 23:32:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AD106B008C; Thu,  4 Jun 2026 23:32:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39B9A6B0092; Thu,  4 Jun 2026 23:32:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 25B776B008A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 23:32:52 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E32771C11F8
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 03:32:51 +0000 (UTC)
X-FDA: 84844437342.18.459BEF7
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1007F180003
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 03:32:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="g/WpxJau";
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780630370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nDO8BVEQ+LamNUz1+nh7qBThLycTY6eROvRfwZKn/hY=;
	b=qTZZ55qPwr2rHJTfC5QboI4umB/zeH+8l4rL1EGKstgloJyB5Rna48nvzoHKhWabC0NwP6
	eJVUFDlhnSjhgc36UWhFBFy9Nk73hrFdhXhWWeYPTdTQiAmPRkjNt6pzclxZbkiENQYYar
	LVG92p1gS6P10Pc4T34VV3LBEV27SDc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780630370;
	b=pErJKHExYFyI/tW6i8NFxSN1n0bk/3OMr1md8oIXVEI7tAxOfMI4nuC3uR6M3bS37mVhhv
	RuNdTUH8IWhpr5o/vERhnwfjACs41D2lgiErtKLk51nvZHn33oErk7M6EUg7SDt3w6Fx7d
	8ufc4krtJyaBCdHNIUE75HSM5r3wWG8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="g/WpxJau";
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8ce0f17a69cso10268866d6.0
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 20:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780630369; x=1781235169; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nDO8BVEQ+LamNUz1+nh7qBThLycTY6eROvRfwZKn/hY=;
        b=g/WpxJauDdHwIXKZmeuj3VYndpRa6N1HCuHbvBabAMGbMRimUOuCMNKYJwrHMONnUY
         S6F2Wo5+C1VE7zOy0moRgFRe3O1aXzk1uTBhrszZSziS/XBlzCRNFaVU7WlLYOSr2LXv
         QObwxdxcJVsilbIfW6Vurv03AM1iGZqEZExXEisSsCJKdqdndzsUjhV4yW4nh659NgIC
         E46rjQH2LOlvCM55ryU7wgYmOaSstRPRHbWxyWGPFq+LKXyKICnLla87nsTs7cESKQit
         P5dqXn2vLKexqSC+dBTmRevC0fJfVWKnKx6YgIkwIKTFVsEcxZvvsIsxDqWInBHw9MJa
         I73w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780630369; x=1781235169;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nDO8BVEQ+LamNUz1+nh7qBThLycTY6eROvRfwZKn/hY=;
        b=J+M9x9Av3kIMJhd4bMOqPNriaAwgMyk0EbCQ0wgEAA+vaw+nT1aV4FFkwGHPGYUC1v
         1KrYxdVDcIfD3ANRMgqupGSSWvUzavKzcENMigWa/o3ryqtXKvCXff0ZKemM2bp7QsBi
         XN25bkJPKq+L+4DuNoBf2svtQyV06vd1PKSoSZLkWOymVgXNpdEQYgctnN5we6FQf3Sr
         3rmzoe7e14vX8tblcJi3zb818yDJ8Ji1ANY2S4rRSaU4aN2/cCsZfWqXktOukN02veOq
         LWeSFM5PPKvWjVstlu8rOcsFNpoKBkM62WHS2PbPUpmhMduIJPlOpTcPPs5S/gdy6abh
         j0rg==
X-Forwarded-Encrypted: i=1; AFNElJ8XnmA3LmAJJ1ZN6qQkxEjV4LXbaz5HsXe3iqw0bQ7KVk8GYuIigsLvPvvivDviobPjiA6t8nUg3g==@kvack.org
X-Gm-Message-State: AOJu0YxX/7zn6f7LXG3NB/p2k89+fNrtQKiq2Z8b0a0p/kGOtAEF9+xk
	BSxFJ2GHJdVRY9SFc5dHveBmx32NZ7ShZ+Bg+EPx4R6b6+CWCH+AgcadsUeVd+7xRuQ=
X-Gm-Gg: Acq92OEDBZ9NuX8Ap4HL0MSTQ1KHV8J3lBzTaNNVqJJkiD7cVXiT6zNGyrVkx0glCK1
	JtUrI/TX0XDsmJ3BQIhGFMM9F82pZrlgUm3/4kvve+2q47LAfMQrFlB5iwLraBzaDuoR2hRmLFH
	V8b0vmdkXx/MKXIQwTvBf1xmYO/TpmTVhASoJ/9NYww3ktgr+oP8xds2xXhNijbP7jlcPdLVoXx
	Cs/c2Ti+YsnWN9mSTo1Wqtb54XOoLHhUqi1DxvMC8W5sy0vd7yvto8WylUz7Boqryl5ner3obcs
	p2wln6gV61FyHABk82/YYtZd+eA586DUXqVOUd4NX7uaXLYFmKnC7xmrq0N6P1tarDWmDQ06u4A
	RGyCocOjCroohSnYd2cQxyi8tbvBVLqaw/XD4KlU+kl+tHheT6NwjmsuEsd529oKpgF2cRENQyR
	GB1cK+HY4byWA6AvPj/tTXM81NzF+uDDcY4EusP7Fgux250GNv11+LaFB8D/hVMQ==
X-Received: by 2002:a05:6214:6017:b0:8cc:cf1e:1fde with SMTP id 6a1803df08f44-8cee611fb96mr32665706d6.26.1780630369028;
        Thu, 04 Jun 2026 20:32:49 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ceccdb9fc0sm70805926d6.17.2026.06.04.20.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 20:32:48 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	jasonmiu@google.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	ran.xiaokai@zte.com.cn,
	pasha.tatashin@soleen.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	graf@amazon.com
Subject: [RFC v1 1/9] kho: split out radix tree tracker into kho_radix.c
Date: Fri,  5 Jun 2026 03:32:27 +0000
Message-ID: <20260605033235.717351-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260605033235.717351-1-pasha.tatashin@soleen.com>
References: <20260605033235.717351-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1007F180003
X-Rspam-User: 
X-Stat-Signature: s5tz4c4556yh99jw334dnq8d6xx6hzkc
X-Rspamd-Server: rspam08
X-HE-Tag: 1780630369-254195
X-HE-Meta: U2FsdGVkX1+Ei1mtCYWayqY5yKe3M6PUbU//lrIluvtg+ceA35ksAyg4AAK9HqzjHgzy8djTJ5q1NcWSovBBQH1FzwTorKStk1Jji8W2qlPewV7KftSvEH71Q/IZw14ujltuCcbW15nOiqnm7y8OvMoeNq0gtUCQaJqJkewpNr56XpFhKEKMG9Ex1gn0aEHMQFfWYiNsyinNSr6UByRtnBMrxOQh/kgkIOkTh9MSzzUVs62rom+TMy6cSgR5vNTee+z5fgh6LOo94YLDac4j1xvohJ1wekaKeeCI+CJfnFtFniErj0Cob9wpf+tZaJDUmMpBQ9iKcKVJuMzxaOjPdXRcysq9ZTPV6tsWsVAdbwphWmYz0s1vfv4tsAjOM0W8c/ltuoBt+j6Rbntr/E8KTv4Y0iROnuKx+EmEBg36wxveYTSEQ9iGw+MHOKmIt+lxNPFUnL9x9ZQeDICwzuf1gtLv+axVygCwsU/+mpTyEI/OEX5dPJ1CUYUErf9JycQzfwgHQT4XSVvhJRyR8INdBdegY96jpg5deSEa+LSb6u/O7bFrNZ36FaTIdqnXe7vsIXL6M3JazRBe+COH2ZL/WKH+EBThlGndTspEgyxt+N1Jr9QX1etlcFB+pPa2wPX+DIepvp4LX7OzHBDiVe7YC4/iha8DUwsqR6aJspNSZriLi9/L8+4KCkROzfSVT9xPpldQtufVXaRkXLbbU4mMFZupBiwvz8Mlq0b01ww1o9GMj0u8+bIuPddhtTT0Pmup0aOYt3HFOpu9glAzfwJneAPXFMJuP3K/MC7hqRr5GEhAxT9tXQZg2O9DV+C9HIiXtSdJKbLbZea600tzl7ziAMZprWk0iCHYHm1gR1iukO83PEDArpoU04Y8KaHG8kr6ZCBOoptTLYvzQKEv7NyEmVs+OCFKNFkG/FyJs4pOik+bKDdKf2HRgEt9YTsSW3arJji9SUNCm5gxMkwaiAE
 btv1snxZ
 3SOGininQds6Ri92Vyb4HEjDw5F/2hZ1Y8zZyC0w9S32MNd8bFejNmL8Y5foOthakzTzZXyxBJZnoH1PQ53dLIdN/6EiywLaNS3hjoF322yLdlCksKLWcyaK8Wd3leLlFAiy4DuySlZzl9nUFn3cdkF9yOVgDgLHUQkM27eAn3YKdjrzwtWfN2I+juyvwPMJaidTbN6nLw9Ebbs3eWro/fR0/edXPwTIZcWKKBsaGNp5V2EyEEPfbvEGO3WiV+Hr6VeUTgu0DvB8mhjzv3Dxc7pEWs3wdkU3ClS+1njeHIuyPIvsC0iB9mWK+wI8l6AkvXVAX/FJDUBnRuT6Z+DqtkTV1/QPtAaRYfM0Jm0IlcMiRXlD6yTI2W2w9ffngtAzQdU7uKW1LTfa7dglABJculVWYPS2m+Tz/EDO8uRwlG59FehLw6/cqpGOC8ug4HYo/xyYFblWOhJRuAZw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the radix tree tracker implementation from the core KHO code
into its own dedicated file (kho_radix.c).

This is a pure code movement patch; no logic or functional changes are
introduced.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 Documentation/core-api/kho/index.rst |   3 +
 kernel/liveupdate/Makefile           |   6 +-
 kernel/liveupdate/kexec_handover.c   | 273 -------------------------
 kernel/liveupdate/kho_radix.c        | 290 +++++++++++++++++++++++++++
 4 files changed, 298 insertions(+), 274 deletions(-)
 create mode 100644 kernel/liveupdate/kho_radix.c

diff --git a/Documentation/core-api/kho/index.rst b/Documentation/core-api/kho/index.rst
index 320914a42178..a9892c671ec3 100644
--- a/Documentation/core-api/kho/index.rst
+++ b/Documentation/core-api/kho/index.rst
@@ -83,6 +83,9 @@ Public API
 .. kernel-doc:: kernel/liveupdate/kexec_handover.c
   :export:
 
+.. kernel-doc:: kernel/liveupdate/kho_radix.c
+  :export:
+
 KHO Serialization Blocks API
 ============================
 
diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
index eec9d3ae07eb..a3ee8a5c27a2 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -7,7 +7,11 @@ luo-y :=								\
 		luo_flb.o						\
 		luo_session.o
 
-obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
+kho-y :=								\
+		kexec_handover.o					\
+		kho_radix.o
+
+obj-$(CONFIG_KEXEC_HANDOVER)		+= kho.o
 obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)	+= kexec_handover_debug.o
 obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS)	+= kexec_handover_debugfs.o
 
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 4834a809985a..041efff7ca11 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -5,7 +5,6 @@
  * Copyright (C) 2025 Microsoft Corporation, Mike Rapoport <rppt@kernel.org>
  * Copyright (C) 2025 Google LLC, Changyuan Lyu <changyuanl@google.com>
  * Copyright (C) 2025 Pasha Tatashin <pasha.tatashin@soleen.com>
- * Copyright (C) 2026 Google LLC, Jason Miu <jasonmiu@google.com>
  */
 
 #define pr_fmt(fmt) "KHO: " fmt
@@ -84,278 +83,6 @@ static struct kho_out kho_out = {
 	},
 };
 
-/**
- * kho_radix_encode_key - Encodes a physical address and order into a radix key.
- * @phys: The physical address of the page.
- * @order: The order of the page.
- *
- * This function combines a page's physical address and its order into a
- * single unsigned long, which is used as a key for all radix tree
- * operations.
- *
- * Return: The encoded unsigned long radix key.
- */
-static unsigned long kho_radix_encode_key(phys_addr_t phys, unsigned int order)
-{
-	/* Order bits part */
-	unsigned long h = 1UL << (KHO_ORDER_0_LOG2 - order);
-	/* Shifted physical address part */
-	unsigned long l = phys >> (PAGE_SHIFT + order);
-
-	return h | l;
-}
-
-/**
- * kho_radix_decode_key - Decodes a radix key back into a physical address and order.
- * @key: The unsigned long key to decode.
- * @order: An output parameter, a pointer to an unsigned int where the decoded
- *         page order will be stored.
- *
- * This function reverses the encoding performed by kho_radix_encode_key(),
- * extracting the original physical address and page order from a given key.
- *
- * Return: The decoded physical address.
- */
-static phys_addr_t kho_radix_decode_key(unsigned long key, unsigned int *order)
-{
-	unsigned int order_bit = fls64(key);
-	phys_addr_t phys;
-
-	/* order_bit is numbered starting at 1 from fls64 */
-	*order = KHO_ORDER_0_LOG2 - order_bit + 1;
-	/* The order is discarded by the shift */
-	phys = key << (PAGE_SHIFT + *order);
-
-	return phys;
-}
-
-static unsigned long kho_radix_get_bitmap_index(unsigned long key)
-{
-	return key % (1 << KHO_BITMAP_SIZE_LOG2);
-}
-
-static unsigned long kho_radix_get_table_index(unsigned long key,
-					       unsigned int level)
-{
-	int s;
-
-	s = ((level - 1) * KHO_TABLE_SIZE_LOG2) + KHO_BITMAP_SIZE_LOG2;
-	return (key >> s) % (1 << KHO_TABLE_SIZE_LOG2);
-}
-
-/**
- * kho_radix_add_page - Marks a page as preserved in the radix tree.
- * @tree: The KHO radix tree.
- * @pfn: The page frame number of the page to preserve.
- * @order: The order of the page.
- *
- * This function traverses the radix tree based on the key derived from @pfn
- * and @order. It sets the corresponding bit in the leaf bitmap to mark the
- * page for preservation. If intermediate nodes do not exist along the path,
- * they are allocated and added to the tree.
- *
- * Return: 0 on success, or a negative error code on failure.
- */
-int kho_radix_add_page(struct kho_radix_tree *tree,
-		       unsigned long pfn, unsigned int order)
-{
-	/* Newly allocated nodes for error cleanup */
-	struct kho_radix_node *intermediate_nodes[KHO_TREE_MAX_DEPTH] = { 0 };
-	unsigned long key = kho_radix_encode_key(PFN_PHYS(pfn), order);
-	struct kho_radix_node *anchor_node = NULL;
-	struct kho_radix_node *node = tree->root;
-	struct kho_radix_node *new_node;
-	unsigned int i, idx, anchor_idx;
-	struct kho_radix_leaf *leaf;
-	int err = 0;
-
-	if (WARN_ON_ONCE(!tree->root))
-		return -EINVAL;
-
-	might_sleep();
-
-	guard(mutex)(&tree->lock);
-
-	/* Go from high levels to low levels */
-	for (i = KHO_TREE_MAX_DEPTH - 1; i > 0; i--) {
-		idx = kho_radix_get_table_index(key, i);
-
-		if (node->table[idx]) {
-			node = phys_to_virt(node->table[idx]);
-			continue;
-		}
-
-		/* Next node is empty, create a new node for it */
-		new_node = (struct kho_radix_node *)get_zeroed_page(GFP_KERNEL);
-		if (!new_node) {
-			err = -ENOMEM;
-			goto err_free_nodes;
-		}
-
-		node->table[idx] = virt_to_phys(new_node);
-
-		/*
-		 * Capture the node where the new branch starts for cleanup
-		 * if allocation fails.
-		 */
-		if (!anchor_node) {
-			anchor_node = node;
-			anchor_idx = idx;
-		}
-		intermediate_nodes[i] = new_node;
-
-		node = new_node;
-	}
-
-	/* Handle the leaf level bitmap (level 0) */
-	idx = kho_radix_get_bitmap_index(key);
-	leaf = (struct kho_radix_leaf *)node;
-	__set_bit(idx, leaf->bitmap);
-
-	return 0;
-
-err_free_nodes:
-	for (i = KHO_TREE_MAX_DEPTH - 1; i > 0; i--) {
-		if (intermediate_nodes[i])
-			free_page((unsigned long)intermediate_nodes[i]);
-	}
-	if (anchor_node)
-		anchor_node->table[anchor_idx] = 0;
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(kho_radix_add_page);
-
-/**
- * kho_radix_del_page - Removes a page's preservation status from the radix tree.
- * @tree: The KHO radix tree.
- * @pfn: The page frame number of the page to unpreserve.
- * @order: The order of the page.
- *
- * This function traverses the radix tree and clears the bit corresponding to
- * the page, effectively removing its "preserved" status. It does not free
- * the tree's intermediate nodes, even if they become empty.
- */
-void kho_radix_del_page(struct kho_radix_tree *tree, unsigned long pfn,
-			unsigned int order)
-{
-	unsigned long key = kho_radix_encode_key(PFN_PHYS(pfn), order);
-	struct kho_radix_node *node = tree->root;
-	struct kho_radix_leaf *leaf;
-	unsigned int i, idx;
-
-	if (WARN_ON_ONCE(!tree->root))
-		return;
-
-	might_sleep();
-
-	guard(mutex)(&tree->lock);
-
-	/* Go from high levels to low levels */
-	for (i = KHO_TREE_MAX_DEPTH - 1; i > 0; i--) {
-		idx = kho_radix_get_table_index(key, i);
-
-		/*
-		 * Attempting to delete a page that has not been preserved,
-		 * return with a warning.
-		 */
-		if (WARN_ON(!node->table[idx]))
-			return;
-
-		node = phys_to_virt(node->table[idx]);
-	}
-
-	/* Handle the leaf level bitmap (level 0) */
-	leaf = (struct kho_radix_leaf *)node;
-	idx = kho_radix_get_bitmap_index(key);
-	__clear_bit(idx, leaf->bitmap);
-}
-EXPORT_SYMBOL_GPL(kho_radix_del_page);
-
-static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf,
-			       unsigned long key,
-			       kho_radix_tree_walk_callback_t cb)
-{
-	unsigned long *bitmap = (unsigned long *)leaf;
-	unsigned int order;
-	phys_addr_t phys;
-	unsigned int i;
-	int err;
-
-	for_each_set_bit(i, bitmap, PAGE_SIZE * BITS_PER_BYTE) {
-		phys = kho_radix_decode_key(key | i, &order);
-		err = cb(phys, order);
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
-static int __kho_radix_walk_tree(struct kho_radix_node *root,
-				 unsigned int level, unsigned long start,
-				 kho_radix_tree_walk_callback_t cb)
-{
-	struct kho_radix_node *node;
-	struct kho_radix_leaf *leaf;
-	unsigned long key, i;
-	unsigned int shift;
-	int err;
-
-	for (i = 0; i < PAGE_SIZE / sizeof(phys_addr_t); i++) {
-		if (!root->table[i])
-			continue;
-
-		shift = ((level - 1) * KHO_TABLE_SIZE_LOG2) +
-			KHO_BITMAP_SIZE_LOG2;
-		key = start | (i << shift);
-
-		node = phys_to_virt(root->table[i]);
-
-		if (level == 1) {
-			/*
-			 * we are at level 1,
-			 * node is pointing to the level 0 bitmap.
-			 */
-			leaf = (struct kho_radix_leaf *)node;
-			err = kho_radix_walk_leaf(leaf, key, cb);
-		} else {
-			err  = __kho_radix_walk_tree(node, level - 1,
-						     key, cb);
-		}
-
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
-/**
- * kho_radix_walk_tree - Traverses the radix tree and calls a callback for each preserved page.
- * @tree: A pointer to the KHO radix tree to walk.
- * @cb: A callback function of type kho_radix_tree_walk_callback_t that will be
- *      invoked for each preserved page found in the tree. The callback receives
- *      the physical address and order of the preserved page.
- *
- * This function walks the radix tree, searching from the specified top level
- * down to the lowest level (level 0). For each preserved page found, it invokes
- * the provided callback, passing the page's physical address and order.
- *
- * Return: 0 if the walk completed the specified tree, or the non-zero return
- *         value from the callback that stopped the walk.
- */
-int kho_radix_walk_tree(struct kho_radix_tree *tree,
-			kho_radix_tree_walk_callback_t cb)
-{
-	if (WARN_ON_ONCE(!tree->root))
-		return -EINVAL;
-
-	guard(mutex)(&tree->lock);
-
-	return __kho_radix_walk_tree(tree->root, KHO_TREE_MAX_DEPTH - 1, 0, cb);
-}
-EXPORT_SYMBOL_GPL(kho_radix_walk_tree);
 
 /* For physically contiguous 0-order pages. */
 static void kho_init_pages(struct page *page, unsigned long nr_pages)
diff --git a/kernel/liveupdate/kho_radix.c b/kernel/liveupdate/kho_radix.c
new file mode 100644
index 000000000000..c836783a1376
--- /dev/null
+++ b/kernel/liveupdate/kho_radix.c
@@ -0,0 +1,290 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * kho_radix.c - KHO radix tree tracker for preserved memory pages
+ * Copyright (C) 2025 Microsoft Corporation, Mike Rapoport <rppt@kernel.org>
+ * Copyright (C) 2025 Pasha Tatashin <pasha.tatashin@soleen.com>
+ * Copyright (C) 2026 Google LLC, Jason Miu <jasonmiu@google.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/gfp.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/kho/abi/kexec_handover.h>
+#include <linux/kho_radix_tree.h>
+#include <linux/mm.h>
+#include <linux/mutex.h>
+#include <linux/types.h>
+
+/**
+ * kho_radix_encode_key - Encodes a physical address and order into a radix key.
+ * @phys: The physical address of the page.
+ * @order: The order of the page.
+ *
+ * This function combines a page's physical address and its order into a
+ * single unsigned long, which is used as a key for all radix tree
+ * operations.
+ *
+ * Return: The encoded unsigned long radix key.
+ */
+static unsigned long kho_radix_encode_key(phys_addr_t phys, unsigned int order)
+{
+	/* Order bits part */
+	unsigned long h = 1UL << (KHO_ORDER_0_LOG2 - order);
+	/* Shifted physical address part */
+	unsigned long l = phys >> (PAGE_SHIFT + order);
+
+	return h | l;
+}
+
+/**
+ * kho_radix_decode_key - Decodes a radix key back into a physical address and order.
+ * @key: The unsigned long key to decode.
+ * @order: An output parameter, a pointer to an unsigned int where the decoded
+ *         page order will be stored.
+ *
+ * This function reverses the encoding performed by kho_radix_encode_key(),
+ * extracting the original physical address and page order from a given key.
+ *
+ * Return: The decoded physical address.
+ */
+static phys_addr_t kho_radix_decode_key(unsigned long key, unsigned int *order)
+{
+	unsigned int order_bit = fls64(key);
+	phys_addr_t phys;
+
+	/* order_bit is numbered starting at 1 from fls64 */
+	*order = KHO_ORDER_0_LOG2 - order_bit + 1;
+	/* The order is discarded by the shift */
+	phys = key << (PAGE_SHIFT + *order);
+
+	return phys;
+}
+
+static unsigned long kho_radix_get_bitmap_index(unsigned long key)
+{
+	return key % (1 << KHO_BITMAP_SIZE_LOG2);
+}
+
+static unsigned long kho_radix_get_table_index(unsigned long key,
+					       unsigned int level)
+{
+	int s;
+
+	s = ((level - 1) * KHO_TABLE_SIZE_LOG2) + KHO_BITMAP_SIZE_LOG2;
+	return (key >> s) % (1 << KHO_TABLE_SIZE_LOG2);
+}
+
+/**
+ * kho_radix_add_page - Marks a page as preserved in the radix tree.
+ * @tree: The KHO radix tree.
+ * @pfn: The page frame number of the page to preserve.
+ * @order: The order of the page.
+ *
+ * This function traverses the radix tree based on the key derived from @pfn
+ * and @order. It sets the corresponding bit in the leaf bitmap to mark the
+ * page for preservation. If intermediate nodes do not exist along the path,
+ * they are allocated and added to the tree.
+ *
+ * Return: 0 on success, or a negative error code on failure.
+ */
+int kho_radix_add_page(struct kho_radix_tree *tree,
+		       unsigned long pfn, unsigned int order)
+{
+	/* Newly allocated nodes for error cleanup */
+	struct kho_radix_node *intermediate_nodes[KHO_TREE_MAX_DEPTH] = { 0 };
+	unsigned long key = kho_radix_encode_key(PFN_PHYS(pfn), order);
+	struct kho_radix_node *anchor_node = NULL;
+	struct kho_radix_node *node = tree->root;
+	struct kho_radix_node *new_node;
+	unsigned int i, idx, anchor_idx;
+	struct kho_radix_leaf *leaf;
+	int err = 0;
+
+	if (WARN_ON_ONCE(!tree->root))
+		return -EINVAL;
+
+	might_sleep();
+
+	guard(mutex)(&tree->lock);
+
+	/* Go from high levels to low levels */
+	for (i = KHO_TREE_MAX_DEPTH - 1; i > 0; i--) {
+		idx = kho_radix_get_table_index(key, i);
+
+		if (node->table[idx]) {
+			node = phys_to_virt(node->table[idx]);
+			continue;
+		}
+
+		/* Next node is empty, create a new node for it */
+		new_node = (struct kho_radix_node *)get_zeroed_page(GFP_KERNEL);
+		if (!new_node) {
+			err = -ENOMEM;
+			goto err_free_nodes;
+		}
+
+		node->table[idx] = virt_to_phys(new_node);
+
+		/*
+		 * Capture the node where the new branch starts for cleanup
+		 * if allocation fails.
+		 */
+		if (!anchor_node) {
+			anchor_node = node;
+			anchor_idx = idx;
+		}
+		intermediate_nodes[i] = new_node;
+
+		node = new_node;
+	}
+
+	/* Handle the leaf level bitmap (level 0) */
+	idx = kho_radix_get_bitmap_index(key);
+	leaf = (struct kho_radix_leaf *)node;
+	__set_bit(idx, leaf->bitmap);
+
+	return 0;
+
+err_free_nodes:
+	for (i = KHO_TREE_MAX_DEPTH - 1; i > 0; i--) {
+		if (intermediate_nodes[i])
+			free_page((unsigned long)intermediate_nodes[i]);
+	}
+	if (anchor_node)
+		anchor_node->table[anchor_idx] = 0;
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(kho_radix_add_page);
+
+/**
+ * kho_radix_del_page - Removes a page's preservation status from the radix tree.
+ * @tree: The KHO radix tree.
+ * @pfn: The page frame number of the page to unpreserve.
+ * @order: The order of the page.
+ *
+ * This function traverses the radix tree and clears the bit corresponding to
+ * the page, effectively removing its "preserved" status. It does not free
+ * the tree's intermediate nodes, even if they become empty.
+ */
+void kho_radix_del_page(struct kho_radix_tree *tree, unsigned long pfn,
+			unsigned int order)
+{
+	unsigned long key = kho_radix_encode_key(PFN_PHYS(pfn), order);
+	struct kho_radix_node *node = tree->root;
+	struct kho_radix_leaf *leaf;
+	unsigned int i, idx;
+
+	if (WARN_ON_ONCE(!tree->root))
+		return;
+
+	might_sleep();
+
+	guard(mutex)(&tree->lock);
+
+	/* Go from high levels to low levels */
+	for (i = KHO_TREE_MAX_DEPTH - 1; i > 0; i--) {
+		idx = kho_radix_get_table_index(key, i);
+
+		/*
+		 * Attempting to delete a page that has not been preserved,
+		 * return with a warning.
+		 */
+		if (WARN_ON(!node->table[idx]))
+			return;
+
+		node = phys_to_virt(node->table[idx]);
+	}
+
+	/* Handle the leaf level bitmap (level 0) */
+	leaf = (struct kho_radix_leaf *)node;
+	idx = kho_radix_get_bitmap_index(key);
+	__clear_bit(idx, leaf->bitmap);
+}
+EXPORT_SYMBOL_GPL(kho_radix_del_page);
+
+static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf,
+			       unsigned long key,
+			       kho_radix_tree_walk_callback_t cb)
+{
+	unsigned long *bitmap = (unsigned long *)leaf;
+	unsigned int order;
+	phys_addr_t phys;
+	unsigned int i;
+	int err;
+
+	for_each_set_bit(i, bitmap, PAGE_SIZE * BITS_PER_BYTE) {
+		phys = kho_radix_decode_key(key | i, &order);
+		err = cb(phys, order);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int __kho_radix_walk_tree(struct kho_radix_node *root,
+				 unsigned int level, unsigned long start,
+				 kho_radix_tree_walk_callback_t cb)
+{
+	struct kho_radix_node *node;
+	struct kho_radix_leaf *leaf;
+	unsigned long key, i;
+	unsigned int shift;
+	int err;
+
+	for (i = 0; i < PAGE_SIZE / sizeof(phys_addr_t); i++) {
+		if (!root->table[i])
+			continue;
+
+		shift = ((level - 1) * KHO_TABLE_SIZE_LOG2) +
+			KHO_BITMAP_SIZE_LOG2;
+		key = start | (i << shift);
+
+		node = phys_to_virt(root->table[i]);
+
+		if (level == 1) {
+			/*
+			 * we are at level 1,
+			 * node is pointing to the level 0 bitmap.
+			 */
+			leaf = (struct kho_radix_leaf *)node;
+			err = kho_radix_walk_leaf(leaf, key, cb);
+		} else {
+			err  = __kho_radix_walk_tree(node, level - 1,
+						     key, cb);
+		}
+
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+/**
+ * kho_radix_walk_tree - Traverses the radix tree and calls a callback for each preserved page.
+ * @tree: A pointer to the KHO radix tree to walk.
+ * @cb: A callback function of type kho_radix_tree_walk_callback_t that will be
+ *      invoked for each preserved page found in the tree. The callback receives
+ *      the physical address and order of the preserved page.
+ *
+ * This function walks the radix tree, searching from the specified top level
+ * down to the lowest level (level 0). For each preserved page found, it invokes
+ * the provided callback, passing the page's physical address and order.
+ *
+ * Return: 0 if the walk completed the specified tree, or the non-zero return
+ *         value from the callback that stopped the walk.
+ */
+int kho_radix_walk_tree(struct kho_radix_tree *tree,
+			kho_radix_tree_walk_callback_t cb)
+{
+	if (WARN_ON_ONCE(!tree->root))
+		return -EINVAL;
+
+	guard(mutex)(&tree->lock);
+
+	return __kho_radix_walk_tree(tree->root, KHO_TREE_MAX_DEPTH - 1, 0, cb);
+}
+EXPORT_SYMBOL_GPL(kho_radix_walk_tree);
-- 
2.53.0


