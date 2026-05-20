Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 948C3CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 16:36:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C39316B00E7; Wed, 20 May 2026 12:36:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C10856B00E8; Wed, 20 May 2026 12:36:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4D306B00EA; Wed, 20 May 2026 12:36:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4C9F6B00E7
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:36:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2F7A51403D4
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:36:32 +0000 (UTC)
X-FDA: 84788351424.17.86FC4F0
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id BEA8E40004
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:36:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=thingy.jp header.s=google header.b=DvCl4XJL;
	spf=pass (imf04.hostedemail.com: domain of daniel@0x0f.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=daniel@0x0f.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779294990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Vkm10lsOT14iQwI/CNWfdgpDANwu8qAoGqLZTVEsxR8=;
	b=SUFf2pE3XV5OtwjLksTOrn1TaIkABxjX8cBYw3EwxmINeG5IdAWqw26KbbSQ/y8DlcGJ+9
	4m94uOGzBKH6xHWb5+DBLOim7oWsl4G3N2FNq3uF2b3AxY6sQLwTSO61fe53GjgAibS+Yo
	SyyudQhZkUPQxFPSlocFPLYtK+GlrHQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=thingy.jp header.s=google header.b=DvCl4XJL;
	spf=pass (imf04.hostedemail.com: domain of daniel@0x0f.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=daniel@0x0f.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779294990; a=rsa-sha256;
	cv=none;
	b=e1y2GTB35+qcwpVDpCiabDS0M+C0UEhLUSYiuiIERZ2axDmCXQwqv79WtFt88x5t0cDTfa
	nw6ia5upST/2twNY3P1jrLzuPxsJAmYF7308OHsnVp5dNzAeR461KXycaDMHHaM/4pwaTq
	cFJjCwOpHotLaLl55en51KkdWzEniX4=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2b458ca2296so37413945ad.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 09:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thingy.jp; s=google; t=1779294988; x=1779899788; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Vkm10lsOT14iQwI/CNWfdgpDANwu8qAoGqLZTVEsxR8=;
        b=DvCl4XJLL0Yrn2/9qS1uEvS/NR1u53hMBTkTWz/uGu1bQteoiWo0vyvqsUPWXV2Rdz
         x/O/gKeFDwEujCrSJoy2CWcGaNOF3f+niZksFI2+CEd7obWECD88M9zRyCN9uXyQEr1H
         xOGfoRNpfXu+lpvGjzfDEDWdxxqyKYK6cKEJg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779294988; x=1779899788;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vkm10lsOT14iQwI/CNWfdgpDANwu8qAoGqLZTVEsxR8=;
        b=fwD8ji2klx+eLu+VBuqBvWHe0JUjKGb4S0hTPysM896COS4D1xXuUGfCXvQpbENIgh
         IFp7SlIXhm1JlMI65ow3Hzdbin1pW+kXjZmxQQrnHjT1hf44LGcVBGDI5f4OPIMpq2gP
         D7TB7BRQ8RSUGSkQNz2IvtByrblKlSbnivC9RJAs23MIVKvc0e5OPekcUdlao768luHZ
         p+XrtYQjbZHrrbRlwvuG3p7zg+VtESEfc9919Am4qnzk88xi9BWL94BsIMEKTWVg9fXc
         sp1gZsq/i7w74Jy8quxIQg2y/LZ9uSnN0+FNvjbMnRhRG/DZTSYSopwflQS6Wb2dzi50
         VKXQ==
X-Forwarded-Encrypted: i=1; AFNElJ9L3VgQ9sR24FiNbSuK4ecGU+K4yTtVd4jTLrKuerjGR8UmbvI8bTbQGnPNYFOmy4bhGnMv/l3xKg==@kvack.org
X-Gm-Message-State: AOJu0YxS9/sC6zNFAPpkl1UzPauACknJnmW8hCSQRYI6xUc55sIwZxSo
	M/bP+ryNf2qoVf3yapA6jYCcULsRQICMZl1yZhhXt1EQbDnduQ5BiYB6+RZx8r/5Nzg=
X-Gm-Gg: Acq92OHKgJsmd0na38yZGkKS36cHk/csj1VvPPfLiqjKGU2OL06upoVvvuNqyRabCeS
	FUUZx1ky2aN/11C/CIKSGXsHPudDidpOYX2gN+npjNJLzrw4rLpcST7afNo8rGJBcFDro3hN2+G
	Ooeo7wShih2PLzjMTZMwczuaIwA+99rZONP0g376kgnmbzYNrmk6rW0Pdv3y+LMy8rBjj3Ct+H/
	TfGIPeIltJxXTO3LcfJl8dxxvN6sOkMcI4Bf4mJzO5rzYOiwRmN7iNnWinojeDZuYvfs4OSJxWa
	qNZevQGpRZMpyvhBFaYPD1qKrW898QA0aRLdt5kvnHv/Mkbqk3a0uqkZiFYYmKvsNosceT4+Q0p
	/n6UmddMxDxOHEsiuAHFZT9k5WSSf6a/R/ojVlTNJnFN7mFuGrDVvACcGF4Eyy12V+9mixh6oKE
	jy2mHOFkF5dEReIYH+3nQacZilvqRZb4PdWQfIhe1LAqz/iRROCoBdM5qv4Jei9i3PIX2Eo23dD
	vqH8p4W7+dnOHxKW09Kpitu
X-Received: by 2002:a17:903:987:b0:2ba:5a20:1d94 with SMTP id d9443c01a7336-2bd7e8459ddmr287248235ad.13.1779294988312;
        Wed, 20 May 2026 09:36:28 -0700 (PDT)
Received: from kinako.work.home.arpa (p1620034-ipxg00d01sizuokaden.shizuoka.ocn.ne.jp. [122.29.136.34])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2bd5c0600a4sm211290525ad.30.2026.05.20.09.36.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 09:36:27 -0700 (PDT)
From: Daniel Palmer <daniel@thingy.jp>
To: 
Cc: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Daniel Palmer <daniel@thingy.jp>
Subject: [RFC PATCH] mm/nommu: Implement just enough vmap that compressed erofs can be mounted
Date: Thu, 21 May 2026 01:34:38 +0900
Message-ID: <20260520163442.1099667-1-daniel@thingy.jp>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BEA8E40004
X-Rspamd-Server: rspam06
X-Stat-Signature: 5yyj8fq8wag6nysfbni1aazthdz6sk6s
X-HE-Tag: 1779294989-235633
X-HE-Meta: U2FsdGVkX1/3S7coIuv96NvHth7j9sDBqKmzTGIPBqcCZXoQMrKIW2sX9p+JeP0x9P4n9dk4H+J5aI4f3gXr8pOnoQOYqfyaRrAskn5QAfmg5L/TxStyfB9EiJHLm5EqhL+k08uBvTK5AHSS/ZHFCX/wbnfFdu/LLnwDDhoHhwQgPTuBSmYotgw+dFSnMMs4QKBgaQ7aJRAlRpz9ieEmX9qAD8pAohl5MvHUStqUH8V9+PtBrQ/1UjXMxrYUezdR3l4cv7pJ8FAFa4wjrXXx1fekZDM2BMg1+Hv5WAdJTY+rIbkeLcibtZGKEit2igbvcmMkIeQGLSWkC4p2uZDJFjgZtZ0mJlun1aCR9J2b0SA9aha5kQLMvR4elaDe2vYkhDWWPwoQWedNHdtM9KBfsWnmNE+aC/DemyuejBtz64vRRgLsQCDPniofXn+BZg+5LbitcHHhV4B8gObALEpmdJEzFy9ylDcZsA+Wj0ViQrX0qdYSCnryQHID7DdoOyxRIk1UXRRAR5SeLfp4k0sHALHX6ieLzJ8fhrlaRkUGbdtrXLPLRBi9RNKu1FpDRLgrrvEXuEzZUAdVDIdcH5MTeOFz2rHYn/i/OKuIQMZEdDyqZuP4LlI5vvsYYacqXBnjDwTZOipR124MyELehtpmA9p2OLW2PIMfoEqU/UDuuN1uc1mvPr0rOhmgDFgOo14nM2uQn1DxUt7qTlUdQUpiWGU3i1A26OYWpdJpzAWKJdRuc246a2OUmpGpt8+BO/1SCM3VwHOaQCFQK7+vnbMFzwWN8eXcKpp88xNXouf/ZVKVxxJ7hT3eqMhAkxplvkgJYH8XlkZEXBgBibNkAJWV3p+KunkLO73E5Vj2WwSzBwquy2gs8g5Ezfl91x4zRuD5oGUi+jKhpH4kdJy+NBBv54BIm699R7olv/TVezYU+5/hV8itKTOBcgS5BWDZjnXn05InwjKe/MSnipkbD9I
 XNaWYU3P
 FJfun0+AIZSp7Jm3EPEzd9nP15Up6S+ZwveLgfTc2KwctRsW7hTwOb1PyQaTbvesRmXEDMpTPI6qUjoMRqPpmbplbSPg3MDSEea8M44kD64hU4UVttmlxuDCQtyKtXqWifSTb6Rz1rOf+a6iDa1NUD3N/C4H2VZygJYOcg2C+FvmxO9c8rShD1/2SnUSLkvITRSB8cKw0T8yybE2yLGdom1sbrRu7QEfaTcp0zFrIpPS2x4VXzQfpKTQf6QVlXZ6DFp6auLoacgWppnYosj4sOntIHVqJOADompnBVJq/Ti/Fdn74F9KHNcLROw0ZITrOT+JMeU0tA/NJYq9k2nXnv8zVBGQP68oAoDsTG+OUu0tEkss=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This implements a very poor imitation of vmap that works just
enough that compressed erofs filesystems can be mounted on nommu
machines. Right now compressed erofs filesystems trigger a BUG()
on nommu due to this missing.

This is awful, doesn't work like real vmap etc,.. but if you
really cared about stuff working you'd have an MMU I guess?

Signed-off-by: Daniel Palmer <daniel@thingy.jp>
---

Did I miss anything massive that is going to come back and bite me?
Maybe it would have made more sense just to change the erofs
code so on !CONFIG_MMU it doesn't use vmap?

Why:

I'm attempting to get a kernel and userspace into ~3.5MB
of memory without an MMU. The kernel is just a bit over
2MB so I don't have much left.

I've constructed a userspace that is completely made
up of nolibc binaries and with a bit of tweaking and all
the debugging turned off it fits into a ~64KB erofs.

 mm/nommu.c | 133 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 127 insertions(+), 6 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index ed3934bc2de4..a7dbb67b3b69 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -19,6 +19,7 @@
 #include <linux/export.h>
 #include <linux/mm.h>
 #include <linux/sched/mm.h>
+#include <linux/hash.h>
 #include <linux/mman.h>
 #include <linux/swap.h>
 #include <linux/file.h>
@@ -53,6 +54,18 @@ static struct kmem_cache *vm_region_jar;
 struct rb_root nommu_region_tree = RB_ROOT;
 DECLARE_RWSEM(nommu_region_sem);
 
+/* Tracking for our "poor man's" vmap */
+#define VMAP_HASH_BITS  6
+static struct hlist_head vmap_hash[1 << VMAP_HASH_BITS];
+static DEFINE_SPINLOCK(vmap_lock);
+
+struct nommu_vmap_area {
+	struct hlist_node node;
+	struct page **pages;
+	unsigned int count;
+	void *addr;
+};
+
 const struct vm_operations_struct generic_file_vm_ops = {
 };
 
@@ -305,29 +318,137 @@ void *vmalloc_32_user_noprof(unsigned long size)
 }
 EXPORT_SYMBOL(vmalloc_32_user_noprof);
 
-void *vmap(struct page **pages, unsigned int count, unsigned long flags, pgprot_t prot)
+static bool vmap_needs_bounce(struct page **pages, unsigned int count)
 {
-	BUG();
+	unsigned long pfn = page_to_pfn(pages[0]);
+	unsigned int i;
+
+	for (i = 1; i < count; i++)
+		if (page_to_pfn(pages[i]) != pfn + i)
+			return true;
+
+	return false;
+}
+
+static inline unsigned int vmap_key(const void *addr)
+{
+	return hash_ptr(addr, VMAP_HASH_BITS);
+}
+
+static struct nommu_vmap_area *vmap_area_find(const void *addr)
+{
+	struct nommu_vmap_area *va;
+
+	hlist_for_each_entry(va, &vmap_hash[vmap_key(addr)], node)
+		if (va->addr == addr)
+			return va;
+
 	return NULL;
 }
+
+static void *nommu_vmap_map(struct page **pages, unsigned int count)
+{
+	struct nommu_vmap_area *va __free(kfree) = NULL;
+	struct page **_pages __free(kfree) = NULL;
+	void *copy __free(kvfree) = NULL;
+	unsigned int i;
+
+	va = kmalloc_obj(struct nommu_vmap_area);
+	if (!va)
+		return NULL;
+
+	if (vmap_needs_bounce(pages, count)) {
+		copy = kvmalloc_array(count, PAGE_SIZE, GFP_KERNEL);
+		if (!copy)
+			return NULL;
+
+		_pages = kmemdup(pages, count * sizeof(*pages), GFP_KERNEL);
+		if (!_pages)
+			return NULL;
+
+		/*
+		 * Copy the original contents of the pages into the new
+		 * pages to pretend we virtually mapped them.
+		 */
+		for (i = 0; i < count; i++) {
+			void *p = copy + (i * PAGE_SIZE);
+
+			memcpy(p, page_address(pages[i]), PAGE_SIZE);
+		}
+
+		va->addr = no_free_ptr(copy);
+		va->pages = no_free_ptr(_pages);
+	} else {
+		va->addr = page_address(pages[0]);
+		va->pages = NULL;
+	}
+
+	va->count = count;
+
+	scoped_guard(spinlock, &vmap_lock) {
+		hlist_add_head(&va->node,
+			       &vmap_hash[vmap_key(va->addr)]);
+	}
+
+	return no_free_ptr(va)->addr;
+}
+
+static void nommu_vmap_unmap(const void *addr)
+{
+	struct nommu_vmap_area *va;
+	unsigned int i;
+
+	scoped_guard(spinlock, &vmap_lock) {
+		va = vmap_area_find(addr);
+		if (va)
+			hlist_del(&va->node);
+	}
+
+	if (WARN_ON_ONCE(!va))
+		return;
+
+	if (va->pages) {
+		/*
+		 * Write back the new contents of the pages to
+		 * the original ones, this is a waste of time if
+		 * the pages weren't written to but we can't tell.
+		 */
+		for (i = 0; i < va->count; i++) {
+			const void *src = addr + (i * PAGE_SIZE);
+			void *dst = page_address(va->pages[i]);
+
+			memcpy(dst, src, PAGE_SIZE);
+		}
+
+		kvfree(va->addr);
+		kfree(va->pages);
+	}
+
+	kfree(va);
+}
+
+void *vmap(struct page **pages, unsigned int count,
+	   unsigned long flags, pgprot_t prot)
+{
+	return nommu_vmap_map(pages, count);
+}
 EXPORT_SYMBOL(vmap);
 
 void vunmap(const void *addr)
 {
-	BUG();
+	nommu_vmap_unmap(addr);
 }
 EXPORT_SYMBOL(vunmap);
 
 void *vm_map_ram(struct page **pages, unsigned int count, int node)
 {
-	BUG();
-	return NULL;
+	return nommu_vmap_map(pages, count);
 }
 EXPORT_SYMBOL(vm_map_ram);
 
 void vm_unmap_ram(const void *mem, unsigned int count)
 {
-	BUG();
+	nommu_vmap_unmap(mem);
 }
 EXPORT_SYMBOL(vm_unmap_ram);
 
-- 
2.53.0



