Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B798FCCF2DB
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 02:11:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D46196B00E5; Sun, 18 Oct 2026 22:11:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1E256B00E6; Sun, 18 Oct 2026 22:11:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0B936B00E7; Sun, 18 Oct 2026 22:11:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C7F16B00E5
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 22:11:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EF486405BE
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:11:22 +0000 (UTC)
X-FDA: 85337748804.10.B3E705E
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 10EC7C0004
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:11:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QOVmSnoA;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792375881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ti3YkcfnTEBL5joWie6hwuLUXl2KXMMFurkAbb61S4=;
	b=uqq5sMdXF/+c/Bbx/i4R5odLpJcIAAhVzmEbXVIvvhy2OWV08jdXTH79XxErrccB3FSzEg
	BHLmS4VFHVaNoIc1W4CPwHZocKjZIvK+fTSnZpaZ/SkyxPbFtAS7RduZhdKlTlVQ4fTcUm
	upSckj4mUaCQj1uHFLpa+BECJ6GbnhI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792375881;
	b=3RU3S6xOu4/C6EkNy3GZeqEnb6J2KIg06nFEVBrcEOjTdOrnr2jesHl42eSAgpESoWAPXw
	Nu0DR3iIg4qMUgV0SecBfR/10pzZmik2JYddYrNwzOimoSOXM6TTbQYk/p2v8f25RZGSNg
	9eXmgOv0xsooDzEOgl/pMi1OnPi6jhs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QOVmSnoA;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-5eac319a6c2so545206e0c.0
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 19:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792375880; x=1792980680; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=7ti3YkcfnTEBL5joWie6hwuLUXl2KXMMFurkAbb61S4=;
        b=QOVmSnoADoPrwWkB1MNAzbo8fx3ByyAH/uuQQKInk24WgP8Td3kw0th+v2CCXvc5nZ
         Dmc94b+gch7c/oqT+N0dkeGFfmJCmBSGZv/fuS+DPiiF9Ii7v+/4jyr5dTJu4IlLS6ZE
         f9FQuBZxYrKxa5Zw/xoTSZiD3laJ6fEk66lQFa9UD7AeFB3M3ZoXNI40anEg8QdO3VwE
         L12WtgBwLX7qx8jE9MR0kUrmRl3XA+YkPGF/VaWoVhJhjfk08ZR0L60HLSt7kPfaT2r9
         G4ZXdcco/GhM9+pQaw5/xKJSf5o+jXThwJW2H/8faDFuMXg6AjYYTcStgpynIvmC8+1D
         7huA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792375880; x=1792980680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=7ti3YkcfnTEBL5joWie6hwuLUXl2KXMMFurkAbb61S4=;
        b=s2mzj6ITeh57nYt6pCC33gnvIt5/ojCsbPRpjXFnbKgotlLID6W+6JA3xQh0HDPGLU
         pFD7bWDTDTR5ukd00JsK/A6pFW/NZMWIoW8oYg9kwaqui/0yK0doC1F216xcTy2MZl7E
         rywC86S7AaM1glnBxd5cASzuJpZLoz6L3eE2/02NRIi5xkVKDzDyWDWaETOJR0kE5AW+
         hs9tOy+3l2reIQSU8DdTHbv0r/hEMwADMUOP7cnGrvGx4ejJuJT1OdpJjfLCljifXsbo
         GUS4DwDAU9aH0lT05tCyshzswnEWDgk0ghGaMUbOf8J2l+ceKiFgrfQ9EWdn6cbNHU+O
         /MoQ==
X-Forwarded-Encrypted: i=1; AKwUvBxiLmNVoRhROG/C/lvaQX3EQGHrPBqcuf/iaJ7y+p1Eg9FeLyGHjm9G3l/VpL4Gu+mQjeUQ6wkvOg==@kvack.org
X-Gm-Message-State: AFq9FYIBpzdq51XL98BtixTlcx4dbtC2ubjXzkjwgHmGBDKFM2ttKa2R
	w8EP3vkCVeH8cZb3nzq67GwZLcu6CfhlgBcCdTucxnZ6uIC08StdBII9sNSBiD7GizQ=
X-Gm-Gg: AYBFou3x+f7JRkg86WGUsS9JB5zIBznPWafcwCAUMStrYF5PeRSPYNdMK5ZFp+LaXt/
	Q9V5aceXGmZ3UjR0fh55CfCoy6trhY3TwVnitBZhOqnR8a6rlN3vJT0gTXCCmp/bkaaekJZ4vd6
	j5QIjXH6m5PHgAZVN8I7TakUXFdNkafarsHiX3RtdIbqEXmLm0Nee2ofV8skxTkcba+3y9Lxzvh
	UEtKVl1CrBvrs1R0lhdNYu3QktdFvViMmp3igvBo6/90jsR7ozqnltHeutQMsNrDfypEY91rAmR
	OrCzLUZiYFn+/Qu+LxFQ91Cxhe6RFGjJ85qtHoHx9EFfYPCkJnBrhkBYVXN0T2sOQMflVKwpejU
	aWM38ILrZZbRhAsv9R+uBrlHoVyxejXSSU78GHbdMoooRuFWwWciL4mQKm/oYVvP01orNDwoGkH
	oCdXYdzgByFK5hD6PRFbloGSegvDO1FZYc1Ix+a6tJCWthcEkBuATd1kogKjm6gjLJdTnd9Ye5T
	8DL719JFfbtOJ41/L5dBdMDZPXy9Cjez5n+57uBKJg+JPWEXtJEqw2XVENP4OoTHCdc6MkJvQ82
	PAYRWub8apbr6t/4Cvk=
X-Received: by 2002:a05:6102:26d0:b0:7cc:1192:5636 with SMTP id ada2fe7eead31-7cc36905d1emr2154033137.12.1792375880231;
        Sun, 18 Oct 2026 19:11:20 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5eabbd9ea2bsm4271383e0c.2.2026.10.18.19.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 19:11:19 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	kuba@kernel.org,
	enelsonmoore@gmail.com,
	bp@alien8.de,
	shuah@kernel.org,
	david@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	vbabka@kernel.org,
	dapeng1.mi@linux.intel.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	surenb@google.com,
	pasha.tatashin@soleen.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	elver@google.com,
	graf@amazon.com,
	lirongqing@baidu.com,
	liam@infradead.org,
	jlayton@kernel.org
Subject: [PATCH v1 2/8] kho: move radix tree, vmalloc, and FDT helpers to internal header
Date: Sun, 18 Oct 2026 22:11:05 -0400
Message-ID: <20261019021111.990394-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261019021111.990394-1-pasha.tatashin@soleen.com>
References: <20261019021111.990394-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 10EC7C0004
X-Stat-Signature: nrzot67ww7ztetuxr4gyf5qpb8tcm1x6
X-Rspam-User: 
X-HE-Tag: 1792375880-174029
X-HE-Meta: U2FsdGVkX1/hxbPdR3kVI92RUZ8WJD1vW8pkuPb9Z09ScK1X4HEPey/zmqH8trz4sgZ7JxZa6aDLjh6SilrInoiMlfQlmNcnV/JOnkSFkdh3C+0lyCQtPUsG3c2zhvYiYeqZ7kypUMQdhZ+UtDdYD1Da0E1y9Wr/SBgIVfa9EaBmRRG1ISVMPatoBwL5Js1uuVMIMVvmfMLR66OJoLKfnhVkpko+P0oiIxVdxLk2g62Hmtq8K7yEMdfn66FUdOAbTl5EtpM/Pl6TGG97A9bZ4hYvfxLszru/23Rq2WgUZB24Y1PPmlnwwOyd0tBb/wWm5nUHVJcVXM7WtSz3NUh3YzLujgMf5PcLFVXvNCaFrat2uPP4nF57UyH7Ta7vrFLOvkHTM7LuRRa1MGuAS+RcjZrpEyLU5bJ6vnurHyKJbKqoIh31yQdmK/YMdPdpQQbKNj2KZo8LQH8tXzHXVmyfmvFV6GbKXlecTnKxdL6zzDBkhh3LYUgpypJ0AfXNMAIbZD/aUzWG4CIWXEhNR8doLeOMFN9ymdc/UbAUG2i83cBEyX0X5ZvgXXFrDUtY9fDwRrz1xeY8/PRvwGueRlKEdfu5ij/fSkTaX4icDlsZHz+c3ya93/ybeqBlMDnbITOqMVZPfTTBbpsIfEMCKlOy7myvCgdaKQ4Wc+MRSLETLdpH6BJUyI41/vOitaCyCbNYO3qfax3IBZBN17p++UvQiQh0e9c0m1+DyTdsUVWD+sZA+EI0S/JCMnPzZ73GGuuCnSxdXIof9rqpTDJDXICBNhnlT2lSVizT3ikXM0dIs1/F1Xf0u7xNAwLcAiRx6Uv7sIwxcWcRs1OVorvJ4KxtKFXa5q8W4cjx/RWOy6iK59Vn6woHVSz2gnVFeJh7DIekz2RY0UymYq7tHQYASVNN3UUnNJD05J0+w8kTUUk9bs8M/+ziEf994TiFdOLeXUTlkkjzYuS2ieq+3e49FL0
 /Nu2Th2Q
 AlHadJ2bJo2ofR1ysOb1lEa6TzCHAjWJdCV1e234NCdJstLfYrOg+0ap20dRC5DpH3sL3ry2KIX7bgQJMGqsW886ny3j/lvU4Io3RfNn2ziE4xaUn6+HSYZdfGZOZ+RWsijftNSVdBrGNMs2squgjSua8qr2uFx+dF/v9ZCdkymRpGErPdlDzvMw8Hixw0oT8/7WjZW+VNAm9VYzOXoqYBbQ48qnMtEIibVltIN2cA5Sm+UUdNjNIHTPg+E3kedN1pzOaCy8/6Ee2osKoGhJoEP/nuaRvtlJ/EssSvXGR1oiTy+4qiLwPIkr29fDByN5TgHjvd3WxvTHWVqw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the shared KHO radix tree key encoding and indexing helpers,
vmalloc flag conversion helpers, and FDT validation and lookup helpers
from kexec_handover.c into kexec_handover_internal.h as static inline
functions.

The radix tree and vmalloc flag helpers are small bit-manipulation
routines, and the FDT helpers are small wrappers with a single call site
per translation unit, so it is natural to inline them in the internal
header.

This is going to be used by the upcoming KHO read-only mode to walk
preserved KHO radix trees, vmalloc preservation chains, and FDT
subtrees without duplicating the implementation.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kexec_handover.c          | 115 +----------------
 kernel/liveupdate/kexec_handover_internal.h | 134 ++++++++++++++++++++
 2 files changed, 136 insertions(+), 113 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index ce5983abf181..f427cdd9a969 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -113,29 +113,6 @@ static const void *kho_get_fdt(void)
 	return kho_in.fdt_phys ? phys_to_virt(kho_in.fdt_phys) : NULL;
 }
 
-/**
- * kho_encode_radix_key - Encodes a physical address and order into a radix key.
- * @phys: The physical address of the page.
- * @order: The order of the page.
- *
- * This function combines a page's physical address and its order into a
- * single unsigned long, which is used as a key for all radix tree
- * operations.
- *
- * Return: The encoded unsigned long radix key.
- */
-static unsigned long kho_encode_radix_key(phys_addr_t phys, unsigned int order)
-{
-	/* The physical address is encoded by shifting the PFN by its order. */
-	unsigned long shift = PAGE_SHIFT + order;
-	/* Order bit goes right before the shifted PFN. */
-	unsigned long h = 1UL << (64 - shift);
-	/* Shifted PFN. */
-	unsigned long l = phys >> shift;
-
-	return h | l;
-}
-
 /**
  * kho_decode_radix_key - Decodes a radix key back into a physical address and order.
  * @key: The unsigned long key to decode.
@@ -161,20 +138,6 @@ static phys_addr_t kho_decode_radix_key(unsigned long key, unsigned int *order)
 	return phys;
 }
 
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
 static void __ref *kho_radix_alloc_node(void)
 {
 	struct kho_radix_node *node;
@@ -634,21 +597,6 @@ static int __init kho_preserved_memory_reserve(unsigned long key, void *data)
 	return 0;
 }
 
-/* Returns physical address of the preserved memory map from FDT */
-static phys_addr_t __init kho_get_mem_map_phys(const void *fdt)
-{
-	const void *mem_ptr;
-	int len;
-
-	mem_ptr = fdt_getprop(fdt, 0, KHO_FDT_MEMORY_MAP_PROP_NAME, &len);
-	if (!mem_ptr || len != sizeof(u64)) {
-		pr_err("failed to get preserved memory map\n");
-		return 0;
-	}
-
-	return get_unaligned((const u64 *)mem_ptr);
-}
-
 static void __init *kho_get_mem_map(const void *fdt)
 {
 	phys_addr_t phys = kho_get_mem_map_phys(fdt);
@@ -1287,13 +1235,6 @@ void kho_unpreserve_pages(struct page *page, unsigned long nr_pages)
 }
 EXPORT_SYMBOL_GPL(kho_unpreserve_pages);
 
-/* vmalloc flags KHO supports */
-#define KHO_VMALLOC_SUPPORTED_FLAGS	(VM_ALLOC | VM_ALLOW_HUGE_VMAP)
-
-/* KHO internal flags for vmalloc preservations */
-#define KHO_VMALLOC_ALLOC	0x0001
-#define KHO_VMALLOC_HUGE_VMAP	0x0002
-
 static unsigned short vmalloc_flags_to_kho(unsigned int vm_flags)
 {
 	unsigned short kho_flags = 0;
@@ -1306,18 +1247,6 @@ static unsigned short vmalloc_flags_to_kho(unsigned int vm_flags)
 	return kho_flags;
 }
 
-static unsigned int kho_flags_to_vmalloc(unsigned short kho_flags)
-{
-	unsigned int vm_flags = 0;
-
-	if (kho_flags & KHO_VMALLOC_ALLOC)
-		vm_flags |= VM_ALLOC;
-	if (kho_flags & KHO_VMALLOC_HUGE_VMAP)
-		vm_flags |= VM_ALLOW_HUGE_VMAP;
-
-	return vm_flags;
-}
-
 static struct kho_vmalloc_chunk *new_vmalloc_chunk(struct kho_vmalloc_chunk *cur)
 {
 	struct kho_vmalloc_chunk *chunk;
@@ -1660,37 +1589,7 @@ EXPORT_SYMBOL_GPL(is_kho_boot);
  */
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys, size_t *size)
 {
-	const void *fdt = kho_get_fdt();
-	const u64 *val;
-	int offset, len;
-
-	if (!fdt)
-		return -ENOENT;
-
-	if (!phys)
-		return -EINVAL;
-
-	offset = fdt_subnode_offset(fdt, 0, name);
-	if (offset < 0)
-		return -ENOENT;
-
-	val = fdt_getprop(fdt, offset, KHO_SUB_TREE_PROP_NAME, &len);
-	if (!val || len != sizeof(*val))
-		return -EINVAL;
-
-	*phys = (phys_addr_t)*val;
-
-	val = fdt_getprop(fdt, offset, KHO_SUB_TREE_SIZE_PROP_NAME, &len);
-	if (!val || len != sizeof(*val)) {
-		pr_warn("broken KHO subnode '%s': missing or invalid blob-size property\n",
-			name);
-		return -EINVAL;
-	}
-
-	if (size)
-		*size = (size_t)*val;
-
-	return 0;
+	return __kho_retrieve_subtree(kho_get_fdt(), name, phys, size);
 }
 EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
 
@@ -1981,18 +1880,8 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 		pr_warn("setup: failed to memremap FDT (0x%llx)\n", fdt_phys);
 		goto report;
 	}
-	err = fdt_check_header(fdt);
-	if (err) {
-		pr_warn("setup: handover FDT (0x%llx) is invalid: %d\n",
-			fdt_phys, err);
+	if (kho_check_fdt(fdt, fdt_phys))
 		goto unmap_fdt;
-	}
-	err = fdt_node_check_compatible(fdt, 0, KHO_FDT_COMPATIBLE);
-	if (err) {
-		pr_warn("setup: handover FDT (0x%llx) is incompatible with '%s': %d\n",
-			fdt_phys, KHO_FDT_COMPATIBLE, err);
-		goto unmap_fdt;
-	}
 
 	mem_map_phys = kho_get_mem_map_phys(fdt);
 	if (!mem_map_phys)
diff --git a/kernel/liveupdate/kexec_handover_internal.h b/kernel/liveupdate/kexec_handover_internal.h
index 38181076f603..094b4917a0f1 100644
--- a/kernel/liveupdate/kexec_handover_internal.h
+++ b/kernel/liveupdate/kexec_handover_internal.h
@@ -3,8 +3,142 @@
 #define LINUX_KEXEC_HANDOVER_INTERNAL_H
 
 #include <linux/kexec_handover.h>
+#include <linux/kho/abi/kexec_handover.h>
+#include <linux/libfdt.h>
 #include <linux/list.h>
+#include <linux/mm.h>
+#include <linux/printk.h>
 #include <linux/types.h>
+#include <linux/unaligned.h>
+#include <linux/vmalloc.h>
+
+/* vmalloc flags KHO supports */
+#define KHO_VMALLOC_SUPPORTED_FLAGS	(VM_ALLOC | VM_ALLOW_HUGE_VMAP)
+
+/* KHO internal flags for vmalloc preservations */
+#define KHO_VMALLOC_ALLOC	0x0001
+#define KHO_VMALLOC_HUGE_VMAP	0x0002
+
+static inline unsigned int kho_flags_to_vmalloc(unsigned short kho_flags)
+{
+	unsigned int vm_flags = 0;
+
+	if (kho_flags & KHO_VMALLOC_ALLOC)
+		vm_flags |= VM_ALLOC;
+	if (kho_flags & KHO_VMALLOC_HUGE_VMAP)
+		vm_flags |= VM_ALLOW_HUGE_VMAP;
+
+	return vm_flags;
+}
+
+/**
+ * kho_encode_radix_key - Encodes a physical address and order into a radix key.
+ * @phys: The physical address of the page.
+ * @order: The order of the page.
+ *
+ * This function combines a page's physical address and its order into a
+ * single unsigned long, which is used as a key for all radix tree
+ * operations.
+ *
+ * Return: The encoded unsigned long radix key.
+ */
+static inline unsigned long kho_encode_radix_key(phys_addr_t phys,
+						 unsigned int order)
+{
+	/* The physical address is encoded by shifting the PFN by its order. */
+	unsigned long shift = PAGE_SHIFT + order;
+	/* Order bit goes right before the shifted PFN. */
+	unsigned long h = 1UL << (64 - shift);
+	/* Shifted PFN. */
+	unsigned long l = phys >> shift;
+
+	return h | l;
+}
+
+static inline unsigned long kho_radix_get_bitmap_index(unsigned long key)
+{
+	return key % (1 << KHO_BITMAP_SIZE_LOG2);
+}
+
+static inline unsigned long kho_radix_get_table_index(unsigned long key,
+						      unsigned int level)
+{
+	int s;
+
+	s = ((level - 1) * KHO_TABLE_SIZE_LOG2) + KHO_BITMAP_SIZE_LOG2;
+	return (key >> s) % (1 << KHO_TABLE_SIZE_LOG2);
+}
+
+static inline int kho_check_fdt(const void *fdt, phys_addr_t fdt_phys)
+{
+	int err;
+
+	err = fdt_check_header(fdt);
+	if (err) {
+		pr_warn("handover FDT (0x%llx) is invalid: %d\n",
+			(unsigned long long)fdt_phys, err);
+		return err;
+	}
+
+	err = fdt_node_check_compatible(fdt, 0, KHO_FDT_COMPATIBLE);
+	if (err) {
+		pr_warn("handover FDT (0x%llx) is incompatible with '%s': %d\n",
+			(unsigned long long)fdt_phys, KHO_FDT_COMPATIBLE, err);
+		return err;
+	}
+
+	return 0;
+}
+
+/* Returns physical address of the preserved memory map from FDT */
+static inline phys_addr_t kho_get_mem_map_phys(const void *fdt)
+{
+	const void *mem_ptr;
+	int len;
+
+	mem_ptr = fdt_getprop(fdt, 0, KHO_FDT_MEMORY_MAP_PROP_NAME, &len);
+	if (!mem_ptr || len != sizeof(u64)) {
+		pr_err("failed to get preserved memory map\n");
+		return 0;
+	}
+
+	return get_unaligned((const u64 *)mem_ptr);
+}
+
+static inline int __kho_retrieve_subtree(const void *fdt, const char *name,
+					 phys_addr_t *phys, size_t *size)
+{
+	const u64 *val;
+	int offset, len;
+
+	if (!fdt)
+		return -ENOENT;
+
+	if (!phys)
+		return -EINVAL;
+
+	offset = fdt_subnode_offset(fdt, 0, name);
+	if (offset < 0)
+		return -ENOENT;
+
+	val = fdt_getprop(fdt, offset, KHO_SUB_TREE_PROP_NAME, &len);
+	if (!val || len != sizeof(*val))
+		return -EINVAL;
+
+	*phys = (phys_addr_t)get_unaligned(val);
+
+	val = fdt_getprop(fdt, offset, KHO_SUB_TREE_SIZE_PROP_NAME, &len);
+	if (!val || len != sizeof(*val)) {
+		pr_warn("broken KHO subnode '%s': missing or invalid blob-size property\n",
+			name);
+		return -EINVAL;
+	}
+
+	if (size)
+		*size = (size_t)get_unaligned(val);
+
+	return 0;
+}
 
 #ifdef CONFIG_KEXEC_HANDOVER_DEBUGFS
 #include <linux/debugfs.h>
-- 
2.56.0.176.g3575e65682-goog


