Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA650CAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 14:44:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 308328E0018; Tue,  9 Sep 2025 10:44:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28A7B8E0003; Tue,  9 Sep 2025 10:44:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1528D8E0018; Tue,  9 Sep 2025 10:44:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 013658E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:44:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7D1A2BA1E2
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:44:44 +0000 (UTC)
X-FDA: 83869983288.11.D72C9EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id D2646120014
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:44:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hTCMk9Ub;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757429082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sBeNix9VqpK+wf9aUR0F2boxcfRme4DVktd1ed8itpI=;
	b=5RD2nolCCgBES2LIdET7u7MqoCPdmjl9vZis6e4duDrI4rxSN5Gu4jshSAIiFCXsrsf2KT
	Iddn3Ctp8QOvSQOuoT0283nlFxTGbld4FSDgLTwpDGoKMmJ3nzNxBRaRZ2QjAbpeJcGoKU
	YU7jd/K+IVWDvQ5yvMDF01KEO0Sklvg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757429082; a=rsa-sha256;
	cv=none;
	b=LDcOeVJNWiYa71o2fReH3r86E/ykCe5mrybLwxdvSC7i07chYIpXtjApWr0b4fWj48+B96
	77qu7fzK9Og94CEJzsQcEbP/RvOQT/xDrWR6DOB2ybe6IGbq1KEqR3SAtgSqrC97F9RzZq
	GodXkBakZdoliABGt79ZIZ4aKlp2HjY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hTCMk9Ub;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B67A6022E;
	Tue,  9 Sep 2025 14:44:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1801C4CEF4;
	Tue,  9 Sep 2025 14:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757429082;
	bh=9MZqSQvw5qyTZgNHswRXw8wMGyHQiJ8VgjtL5Ns5Ug4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hTCMk9Ub9Ng4v+4IqxsqNkL1aWkxpzQIFyf+EXDEwI319MXSJoe6p59xW7F5cMZer
	 juosq20FywgDc+qbSFwXismNwfJE2hPy6oFtTPvDYl0BHz19MJFqdquTnx3V7eKfj3
	 QTrauj37Pq/l709vyei0pdqxuQnr69m+mdsOk7JV1+zLyX0j6w7A4Mhw6r9PlxPHEb
	 GCV3X6k1uqS+eMqGyTddkfqGpNuljywn0mPJB+gGDW5QSeOABCXFWFMBsgEbGJtaMf
	 HSI+sHNEbu369ei3q/LC0EL7G7DmDx94Jziq5At/SYHfPCI1OutZQS3WELmFc32DSh
	 YhTtId0FXEHzQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Chris Li <chrisl@kernel.org>,
	Jason Miu <jasonmiu@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/4] kho: use KHO array for preserved memory bitmap serialization
Date: Tue,  9 Sep 2025 16:44:22 +0200
Message-ID: <20250909144426.33274-3-pratyush@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250909144426.33274-1-pratyush@kernel.org>
References: <20250909144426.33274-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: n3csxczcuyckwfw7zumzwpcs1qq7guxu
X-Rspam-User: 
X-Rspamd-Queue-Id: D2646120014
X-Rspamd-Server: rspam10
X-HE-Tag: 1757429082-926964
X-HE-Meta: U2FsdGVkX183ud7oNdPWI1nmrUaMYhyB2J6uKmTs/b1SBl58S+ovnZptDe9ALtX2KquU54dF2Nj/bemh/ZZ+OhqWhwR7xdQELPQFKF21OJJMv+J1rSPCA8ZSZHs0THiyFKidn4m0TpdeSgrQ6lOLfVmH5JqzPkzZ7i1C4/m9W6kt16s+763JfNw48um4YtYWtnuF3KTAxpIiZmdbAp69KuK5hB8BY8mVay+JIe9f9vIgu0aMDgYqP7lCJMSzs1athuKy7BOsQemIGrCgH66qHTYR1gcPmM5CIWOD3LxoNOeJDe08kyR053lSMzJ/nSo4bsAveNTkqyNjISw4GGLmmtA3J7sx4ormAd4/SixcuNCgap8iYY1brWr/DocWhNVgvHAsBIQWBxK/TpM1CwiYs5aXDrfBTeKOk4fpOy05cRnb87jwva9sizsO9vc/QRX5RIrpsMNRyH96yrn15jmtjgtiJK2J0loqsDJrXFd7M5G5OdSmOxe3DiRDyeBNdWazjuhkIvFVusf7g34fOrFBHSVpo30OWHeylH9J+66jYLM27Z+NfQu0Ic7KfeL+WuwmZZy9eaKqCbTXMwjZgT6bA5yhxtgB7FewlX5hhCQj8wDz0ghvK6xLOuAUD4TBvqvWodOICDWaG9q1Z4YgGyGfKhZej1Ndmqp8u1Osyb136Mv5Djv/Ch2gO21zJQCc4OmIqfwN//3tbzUUJf+N1sPkfTNmGjRcPvXrGRT7W4rI/Pp6eV7bS8rGQon7e480khlhjyPllZFOzLNgw3paualDZncTiaJz9ucboys0lE9BCgAWBJg4uYv5ePxr3lcKWfFKxfTcpSz9ZoP6AjyI5Ft0sVC8mWLEeRcf8rkWhuLzQGwfPMwGLQyqAlQO5leRudDqmDmjyNFYT+gqhxYUMLYnCkWQXefw22CJWCa1OC9foxqJd1v6Lx+bp/hMBt+GJwRdZrE6TaJ9o0g2rKzMEIS
 mpwjjlKC
 9Rq12U9A2nPCJHjYOPTfC/N5GQ0WsY5GLDN6x89fHzCBy8h9155RCJ/zXLqd0dhEMyBhoSXYbTW8OsHfKImJcbBnLCHva8Yj02uBZ+Fut23iOdgyqM+KepR7VCpY0hCAuvfkcglUj0LCc+YqJvIse8Ish3bMCmZeYXL0bAqJRD8dt+jTDic5rVfKJ8MeshKNo8LLDtNo4SW5P/bU3KxN7EFLt0V4emuoWumogbMjj4aU9NRE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The preserved memory bitmap preservation creates a linked list of pages
to track the bitmaps for preserved memory. Essentially, it is a
scattered list of pointers grouped by folio order. Use a KHO array to
hold the pointers to the bitmaps instead. This moves the burden of
tracking this metadata to the KHO array layer, and makes the KHO core
simpler.

Currently, the bitmaps are held in chunks, which is a fixed-size array
of pointers, plus some metadata including the order of the preserved
folios. The KHO array holds only pointers and has no mechanism for
grouping. To make the serialization format simpler, move the folio order
from struct khoser_mem_chunk to struct khoser_mem_bitmap_ptr.

The chunks to hold the bitmaps are not KHO-preserved since they are only
used during the scratch-only phase. The same holds true with the KHO
array. The pages which track the KHO array metadata are not
KHO-preserved and thus are only valid during the scratch phase of the
next kernel. After that, they are discarded and freed to buddy.

Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
---

The diff is a bit hard to read. The final result can be found at
https://git.kernel.org/pub/scm/linux/kernel/git/pratyush/linux.git/tree/kernel/kexec_handover.c?h=kho-array-rfc-v1#n227

 kernel/kexec_handover.c | 148 +++++++++++++++++++---------------------
 1 file changed, 69 insertions(+), 79 deletions(-)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index ecd1ac210dbd7..26f9f5295f07d 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -18,6 +18,7 @@
 #include <linux/memblock.h>
 #include <linux/notifier.h>
 #include <linux/page-isolation.h>
+#include <linux/kho_array.h>
 
 #include <asm/early_ioremap.h>
 
@@ -80,15 +81,13 @@ struct kho_mem_track {
 	struct xarray orders;
 };
 
-struct khoser_mem_chunk;
-
 struct kho_serialization {
 	struct page *fdt;
 	struct list_head fdt_list;
 	struct dentry *sub_fdt_dir;
 	struct kho_mem_track track;
-	/* First chunk of serialized preserved memory map */
-	struct khoser_mem_chunk *preserved_mem_map;
+	/* Serialized preserved memory map */
+	struct kho_array *preserved_mem_map;
 };
 
 static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, size_t sz)
@@ -226,11 +225,11 @@ EXPORT_SYMBOL_GPL(kho_restore_folio);
 
 /* Serialize and deserialize struct kho_mem_phys across kexec
  *
- * Record all the bitmaps in a linked list of pages for the next kernel to
- * process. Each chunk holds bitmaps of the same order and each block of bitmaps
- * starts at a given physical address. This allows the bitmaps to be sparse. The
- * xarray is used to store them in a tree while building up the data structure,
- * but the KHO successor kernel only needs to process them once in order.
+ * Record all the bitmaps in a KHO array for the next kernel to process. Each
+ * bitmap stores the order of the folios and starts at a given physical address.
+ * This allows the bitmaps to be sparse. The xarray is used to store them in a
+ * tree while building up the data structure, but the KHO successor kernel only
+ * needs to process them once in order.
  *
  * All of this memory is normal kmalloc() memory and is not marked for
  * preservation. The successor kernel will remain isolated to the scratch space
@@ -240,118 +239,107 @@ EXPORT_SYMBOL_GPL(kho_restore_folio);
 
 struct khoser_mem_bitmap_ptr {
 	phys_addr_t phys_start;
-	DECLARE_KHOSER_PTR(bitmap, struct kho_mem_phys_bits *);
-};
-
-struct khoser_mem_chunk_hdr {
-	DECLARE_KHOSER_PTR(next, struct khoser_mem_chunk *);
 	unsigned int order;
-	unsigned int num_elms;
-};
-
-#define KHOSER_BITMAP_SIZE                                   \
-	((PAGE_SIZE - sizeof(struct khoser_mem_chunk_hdr)) / \
-	 sizeof(struct khoser_mem_bitmap_ptr))
-
-struct khoser_mem_chunk {
-	struct khoser_mem_chunk_hdr hdr;
-	struct khoser_mem_bitmap_ptr bitmaps[KHOSER_BITMAP_SIZE];
+	unsigned int __reserved;
+	DECLARE_KHOSER_PTR(bitmap, struct kho_mem_phys_bits *);
 };
 
-static_assert(sizeof(struct khoser_mem_chunk) == PAGE_SIZE);
-
-static struct khoser_mem_chunk *new_chunk(struct khoser_mem_chunk *cur_chunk,
-					  unsigned long order)
+static struct khoser_mem_bitmap_ptr *new_bitmap(phys_addr_t start,
+						struct kho_mem_phys_bits *bits,
+						unsigned int order)
 {
-	struct khoser_mem_chunk *chunk;
+	struct khoser_mem_bitmap_ptr *bitmap;
 
-	chunk = kzalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!chunk)
+	bitmap = kzalloc(sizeof(*bitmap), GFP_KERNEL);
+	if (!bitmap)
 		return NULL;
-	chunk->hdr.order = order;
-	if (cur_chunk)
-		KHOSER_STORE_PTR(cur_chunk->hdr.next, chunk);
-	return chunk;
+
+	bitmap->phys_start = start;
+	bitmap->order = order;
+	KHOSER_STORE_PTR(bitmap->bitmap, bits);
+	return bitmap;
 }
 
-static void kho_mem_ser_free(struct khoser_mem_chunk *first_chunk)
+static void kho_mem_ser_free(struct kho_array *ka)
 {
-	struct khoser_mem_chunk *chunk = first_chunk;
+	struct khoser_mem_bitmap_ptr *elm;
+	struct ka_iter iter;
 
-	while (chunk) {
-		struct khoser_mem_chunk *tmp = chunk;
+	if (!ka)
+		return;
 
-		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
-		kfree(tmp);
-	}
+	ka_iter_init_read(&iter, ka);
+	ka_iter_for_each(&iter, elm)
+		kfree(elm);
+
+	kho_array_destroy(ka);
+	kfree(ka);
 }
 
 static int kho_mem_serialize(struct kho_serialization *ser)
 {
-	struct khoser_mem_chunk *first_chunk = NULL;
-	struct khoser_mem_chunk *chunk = NULL;
 	struct kho_mem_phys *physxa;
-	unsigned long order;
+	unsigned long order, pos = 0;
+	struct kho_array *ka = NULL;
+	struct ka_iter iter;
+
+	ka = kzalloc(sizeof(*ka), GFP_KERNEL);
+	if (!ka)
+		return -ENOMEM;
+	ka_iter_init_write(&iter, ka);
 
 	xa_for_each(&ser->track.orders, order, physxa) {
 		struct kho_mem_phys_bits *bits;
 		unsigned long phys;
 
-		chunk = new_chunk(chunk, order);
-		if (!chunk)
-			goto err_free;
-
-		if (!first_chunk)
-			first_chunk = chunk;
-
 		xa_for_each(&physxa->phys_bits, phys, bits) {
 			struct khoser_mem_bitmap_ptr *elm;
+			phys_addr_t start;
+
+			start = (phys * PRESERVE_BITS) << (order + PAGE_SHIFT);
+			elm = new_bitmap(start, bits, order);
+			if (!elm)
+				goto err_free;
 
-			if (chunk->hdr.num_elms == ARRAY_SIZE(chunk->bitmaps)) {
-				chunk = new_chunk(chunk, order);
-				if (!chunk)
-					goto err_free;
-			}
-
-			elm = &chunk->bitmaps[chunk->hdr.num_elms];
-			chunk->hdr.num_elms++;
-			elm->phys_start = (phys * PRESERVE_BITS)
-					  << (order + PAGE_SHIFT);
-			KHOSER_STORE_PTR(elm->bitmap, bits);
+			ka_iter_setpos(&iter, pos);
+			if (ka_iter_setentry(&iter, elm))
+				goto err_free;
+			pos++;
 		}
 	}
 
-	ser->preserved_mem_map = first_chunk;
+	ser->preserved_mem_map = ka;
 
 	return 0;
 
 err_free:
-	kho_mem_ser_free(first_chunk);
+	kho_mem_ser_free(ka);
 	return -ENOMEM;
 }
 
-static void __init deserialize_bitmap(unsigned int order,
-				      struct khoser_mem_bitmap_ptr *elm)
+static void __init deserialize_bitmap(struct khoser_mem_bitmap_ptr *elm)
 {
 	struct kho_mem_phys_bits *bitmap = KHOSER_LOAD_PTR(elm->bitmap);
 	unsigned long bit;
 
 	for_each_set_bit(bit, bitmap->preserve, PRESERVE_BITS) {
-		int sz = 1 << (order + PAGE_SHIFT);
+		int sz = 1 << (elm->order + PAGE_SHIFT);
 		phys_addr_t phys =
-			elm->phys_start + (bit << (order + PAGE_SHIFT));
+			elm->phys_start + (bit << (elm->order + PAGE_SHIFT));
 		struct page *page = phys_to_page(phys);
 
 		memblock_reserve(phys, sz);
 		memblock_reserved_mark_noinit(phys, sz);
-		page->private = order;
+		page->private = elm->order;
 	}
 }
 
 static void __init kho_mem_deserialize(const void *fdt)
 {
-	struct khoser_mem_chunk *chunk;
+	struct khoser_mem_bitmap_ptr *elm;
 	const phys_addr_t *mem;
+	struct kho_array *ka;
+	struct ka_iter iter;
 	int len;
 
 	mem = fdt_getprop(fdt, 0, PROP_PRESERVED_MEMORY_MAP, &len);
@@ -361,15 +349,17 @@ static void __init kho_mem_deserialize(const void *fdt)
 		return;
 	}
 
-	chunk = *mem ? phys_to_virt(*mem) : NULL;
-	while (chunk) {
-		unsigned int i;
-
-		for (i = 0; i != chunk->hdr.num_elms; i++)
-			deserialize_bitmap(chunk->hdr.order,
-					   &chunk->bitmaps[i]);
-		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
+	ka = *mem ? phys_to_virt(*mem) : NULL;
+	if (!ka)
+		return;
+	if (!kho_array_valid(ka)) {
+		pr_err("invalid KHO array for preserved memory bitmaps\n");
+		return;
 	}
+
+	ka_iter_init_read(&iter, ka);
+	ka_iter_for_each(&iter, elm)
+		deserialize_bitmap(elm);
 }
 
 /*
-- 
2.47.3


