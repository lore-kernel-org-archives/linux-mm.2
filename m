Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89386EDB7CA
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 08:40:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4AEC6B0089; Tue,  7 Apr 2026 04:40:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D225C6B008A; Tue,  7 Apr 2026 04:40:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C37DD6B008C; Tue,  7 Apr 2026 04:40:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B30566B0089
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 04:40:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 40E5E160714
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:40:05 +0000 (UTC)
X-FDA: 84631112370.14.CEF9ECC
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf02.hostedemail.com (Postfix) with ESMTP id 307458000B
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:40:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="Z4/fnkf4";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775551203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=O4bUAcw60BufFG8grCHM7B/gjvGCGM8MGOE43IA5CTQ=;
	b=64IOVJkwcCnX2FaFr7GxkZ8QKQXXkmlTFM9sdJ5n74H5GUAebjx4CFIJIz4C9klZiH3XjE
	AXevX78Jdoc1pmzn0tK/bABadxBh+URLYDqyKw203NVyGmc6fUgyDIjw7TtT0XNWzf6WVq
	H/gCvhIv2U95ls0aSprjpVZdjDOjovU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775551203; a=rsa-sha256;
	cv=none;
	b=m40aWihcCDiqo8QMMJ9isJzAYgCqZjmxNnPuqOyPyYcgmaZRlOqBBEn23CuAK8++XQ63pJ
	f46Z1IZ7R8geN2UFTHqm1Xm4Fs8+78L56OYKg4yemDIrO8PYlChxYGiNXVGLYYTJ3bFjzc
	l3S1rwvSPJZnod1lDQTKk4gzNZwYuS4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="Z4/fnkf4";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-35d9c7bf9a1so4293371a91.3
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 01:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775551201; x=1776156001; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=O4bUAcw60BufFG8grCHM7B/gjvGCGM8MGOE43IA5CTQ=;
        b=Z4/fnkf4PZ8DDLfKWk+lBmKWbgWcWuvW21zSwCH2KJL92HB5A8b43Svtb3g4xJlD2q
         7lFT06tvhKdx6QyIK9YJhcqixRhEdYfCxmiIq/3XCI8w9nzS+1KH7ailuOVAw4qaedb6
         30h3zoUtbZk9KG60i0Odacm5+H7Gr/V7ItPtlC+FWPLNAWyagS+TZ7bJ2UcW6dOgQD7e
         NXGf56arQBwOhJ1yQQvYn5Ic/Ipb25MEg3Fqt3EX5kWmfWWwN6mhd8em5wn8UtV06mR3
         CnJl9QnJPkuDU3w3ErtpTvreUqrrK6sPIXXtHCmkmARLXlut3eNnCuBwPWqXhb6uOHOG
         k+Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775551201; x=1776156001;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O4bUAcw60BufFG8grCHM7B/gjvGCGM8MGOE43IA5CTQ=;
        b=KVpLUjnSVOKglFaEQdZCfyzA0EKFbkwgWrUO/ySCitMkp4/eYPlvu5tDUEHFJqd7ft
         9h5jk+DnMfIAXRX1308QivAJjRSCsDTfKEV/ausVhcRMYJonkq26ifaXuah7IyWm0pPM
         /nLLN3F6HhKn3Z+HgqiH0+xd2E68H5BUgGmAXdjsvnKBu5glXU4UxZVteG0gLazTiuTc
         jjtUcIjg4KsTQzaA6rBgoZpo+KADypgLzzOeE/f0wEj7ccQwo8y+xLkx3Jnr3DxILwwI
         AbhxbJ3vMdWU4PqVzc9uYt9DBOaSEKt3mgbCveDF/4/vlAjYFtzPfFP7VRUGQYt5jqA0
         v3yQ==
X-Forwarded-Encrypted: i=1; AJvYcCUMErBpkCGvzT5wUmrd8mu5AcrE/XYfEtmzDzfFSt4TyOGwav5r4+uQ/iPB/7K6cu9iHYe3dyJE6Q==@kvack.org
X-Gm-Message-State: AOJu0YwTCZGYGrkGgAWEBP9wh2cneZtAHkJqhORJf4dne+6WH43rDCmY
	A12FXnXmLpHkpwf58NVqG+vz23LAm8wvDhZjTGJZ8eR+y3ebfGT3hSPWKBKLmQYhuxU=
X-Gm-Gg: AeBDiesYks+u4ls61WjpSk0DcvaYz/oJtwaI3JXXxx5T19FAUROojL/zEnZy3jw2ALo
	ja/ZUOmmt7duUV13eRL5DEyBLNDcu368YgxwGt9MzsSo6UTQEksAQaoepjpl9vEHYeSnNXYzMTt
	2VVr4E60W4e7D2fXl7D8yUcDcgd2EDaNJxfyDOx2akxYbfZZyz1754GValJmjaT36Qoalo28K5t
	YE1NLHCgIAk1mp0oTjO7nMnzt2Tm+tEUPtf0gtoidPF5M705H1ScQ7saZGEZ1GDFWMCARelajR8
	ZHXMnDIZoYalhjmmTW2Vhdzha5aghZ5FCx9p/9hka1ndT2pcu4vyocDfA7BS6fgMBXtnIqna3wa
	apmp+hSG6TgSiMfdG8m+9MEb4Jz1sbrTD9EpTiyM+M7VI4uFVIaxnWl3s8LxfGnBrQoVHpl4fp6
	eFiikeqQWRiN9+wkpSPh8aos8EnddYWeCDfJt7c8ZDGuTKQH+s19PAEeU=
X-Received: by 2002:a17:90b:314d:b0:359:f43d:4a6e with SMTP id 98e67ed59e1d1-35de662f67fmr15869369a91.0.1775551200600;
        Tue, 07 Apr 2026 01:40:00 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.103])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de697b0c9sm4681861a91.7.2026.04.07.01.39.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 01:40:00 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: yinghai@kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH] mm/sparse: remove sparse_buffer
Date: Tue,  7 Apr 2026 16:39:50 +0800
Message-Id: <20260407083951.2823915-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 307458000B
X-Stat-Signature: gx11qx6keurnenqpik9yritxrzi8d8d4
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775551201-126298
X-HE-Meta: U2FsdGVkX19Dbm66ksRiy/M76B7mYNxGl5+geVB2xYhg7tVv5fTIPwUPycODQyfhA8jDBGdLNbS4lviuF4NJuf96EsPRR6R/4UGqK/7AG5sct1J6gursJpvFId2o9pK78Zo1XGw0pdlWqObGbfIpr8nDCGcOabNxo4XEO1HBR2r6wrY8AIefWlH+/6lmk4urV57/EcZQVSZQv6ct3Zk9qXD/WZNrik15pQHqYI4oOeijQFmQcB3JZB3ETLPCLvYTwbtTPecmpcY3xakCqifL9ilXeVq8j83H504mDoIYgiWskyBwnaevvqmvr+nZ3BVvUogF9vRVk83RP1V5ijcDW3CYiyiwvqsAIFvrM7bsGIRlcN3uvEawtSbpIT0tb6g6Nh1fRtUT5WMvMhoszNzYpahTWYxbAOtXxODL0VcTH8yAp4vRbtl9ylkFj8IXkhMDX+gYF3ZSBq29aD+lw14b8UN+jD5Wcfkowx716IaS3wt+McwUIBvgrvxTr0KNlY4u95prbYg8F/YykLrI7lRohl+nhrkR2cnl2cQK652ZbKrDMjOHv2zog1GXZTYdfbQ1B813QvcyGgDKsGtINeWj2BGZkhpDjQHrFs9Q+73eCZwNu2HtTvlwSrO5MDS2c54kIcu91zFGVCncSG6sU1sJvCwU5VLsM8RsjBbQUsMYAmToKGw4iW5+B8+g4NDaW7On3lniRKfTq4qt5N5ZWw0JAyW2BThBxSUO3RrZ/Eq7kBL4SrjvokgFDkyz96pj156MOyOedpULgtBo1IvISbV3ogE0RfC65wCfoHWG4LySSa2gspJ219oCCm1U9ohOzxyZrZUeM9JXJG3aJJQqhyj07nSDyykG8A+rhqru4Kb0SOqY2lnK4RzbWMHuo0Qvyqo0zrV8c5XsRfwsNWWTM1akx9UnNQ77vjG5jbJMUBcWoYYgf4fpR8N2RKxmAokhPyDLKdyN0+QjgkxCgZKN4Xe
 D/EMqrqe
 OUcCoLLTmgp1Py2Oa/8VZ9LFKtUfs5ULJMQBVg6xkC74ossqQtvE+PFb2wM9w0E/fjy6CcICHex+U4srTqUo5ARifVoAse98/aRKlRyCRFy/qN1nusRGnb+AXWEJwzJ8WfzF6lsYfTEbZfH6RXhS1QOPbLpuM1wZ/wRJFgL+fXSoeOXF3bU2ltFomZjPCC/Z32zW0iVehItgFBlwt1bkRQBgokOtoV4Rk2r8DbYU5YlSfT5tGbjTYtYEidlwFeAq01k+qlzUBmzO+Lj2RGYvOXjjzt4+sfsfFrCtwhtJa4nz6fP2zQPJYvVX5483W78fTua6YQKx/DhDIqNuHk70mHXB/uDek2vYmuTHjNRazVILp4Gh9KJ/nZAAY5xkk5fozJdWBDGfxisXCfvw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The sparse_buffer was originally introduced in commit 9bdac9142407
("sparsemem: Put mem map for one node together.") to allocate a
contiguous block of memory for all memmaps of a NUMA node.

However, the original commit message did not clearly state the actual
benefits or the necessity of keeping all memmap areas strictly
contiguous for a given node.

With the evolution of memory management over the years, the current code
only requires a 2MB contiguous allocation to support huge page mappings
for CONFIG_SPARSEMEM_VMEMMAP. Thus, it seems we no longer need such
complex logic to keep all memmap allocations completely contiguous
across the entire node.

Since the original commit was merged 16 years ago and no additional
context regarding its original intention could be found, this patch
proposes removing this mechanism to reduce the maintenance burden.

If anyone knows the historical background or if there are specific
architectures (Note that the mechanism implemented in 9bdac9142407 was
restricted to x86_64. Therefore, I doubt there are any functional
dependencies for other architectures.) or edge cases that still
rely on this, sharing that context would be highly appreciated.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/mm.h  |  1 -
 mm/sparse-vmemmap.c |  7 +-----
 mm/sparse.c         | 58 +--------------------------------------------
 3 files changed, 2 insertions(+), 64 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0b776907152e..1d676fef4303 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4855,7 +4855,6 @@ static inline void print_vma_addr(char *prefix, unsigned long rip)
 }
 #endif
 
-void *sparse_buffer_alloc(unsigned long size);
 unsigned long section_map_size(void);
 struct page * __populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 6eadb9d116e4..aca1b00e86dd 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -87,15 +87,10 @@ static void * __meminit altmap_alloc_block_buf(unsigned long size,
 void * __meminit vmemmap_alloc_block_buf(unsigned long size, int node,
 					 struct vmem_altmap *altmap)
 {
-	void *ptr;
-
 	if (altmap)
 		return altmap_alloc_block_buf(size, altmap);
 
-	ptr = sparse_buffer_alloc(size);
-	if (!ptr)
-		ptr = vmemmap_alloc_block(size, node);
-	return ptr;
+	return vmemmap_alloc_block(size, node);
 }
 
 static unsigned long __meminit vmem_altmap_next_pfn(struct vmem_altmap *altmap)
diff --git a/mm/sparse.c b/mm/sparse.c
index effdac6b0ab1..672e2ad396a8 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -241,12 +241,9 @@ struct page __init *__populate_section_memmap(unsigned long pfn,
 		struct dev_pagemap *pgmap)
 {
 	unsigned long size = section_map_size();
-	struct page *map = sparse_buffer_alloc(size);
+	struct page *map;
 	phys_addr_t addr = __pa(MAX_DMA_ADDRESS);
 
-	if (map)
-		return map;
-
 	map = memmap_alloc(size, size, addr, nid, false);
 	if (!map)
 		panic("%s: Failed to allocate %lu bytes align=0x%lx nid=%d from=%pa\n",
@@ -256,55 +253,6 @@ struct page __init *__populate_section_memmap(unsigned long pfn,
 }
 #endif /* !CONFIG_SPARSEMEM_VMEMMAP */
 
-static void *sparsemap_buf __meminitdata;
-static void *sparsemap_buf_end __meminitdata;
-
-static inline void __meminit sparse_buffer_free(unsigned long size)
-{
-	WARN_ON(!sparsemap_buf || size == 0);
-	memblock_free(sparsemap_buf, size);
-}
-
-static void __init sparse_buffer_init(unsigned long size, int nid)
-{
-	phys_addr_t addr = __pa(MAX_DMA_ADDRESS);
-	WARN_ON(sparsemap_buf);	/* forgot to call sparse_buffer_fini()? */
-	/*
-	 * Pre-allocated buffer is mainly used by __populate_section_memmap
-	 * and we want it to be properly aligned to the section size - this is
-	 * especially the case for VMEMMAP which maps memmap to PMDs
-	 */
-	sparsemap_buf = memmap_alloc(size, section_map_size(), addr, nid, true);
-	sparsemap_buf_end = sparsemap_buf + size;
-}
-
-static void __init sparse_buffer_fini(void)
-{
-	unsigned long size = sparsemap_buf_end - sparsemap_buf;
-
-	if (sparsemap_buf && size > 0)
-		sparse_buffer_free(size);
-	sparsemap_buf = NULL;
-}
-
-void * __meminit sparse_buffer_alloc(unsigned long size)
-{
-	void *ptr = NULL;
-
-	if (sparsemap_buf) {
-		ptr = (void *) roundup((unsigned long)sparsemap_buf, size);
-		if (ptr + size > sparsemap_buf_end)
-			ptr = NULL;
-		else {
-			/* Free redundant aligned space */
-			if ((unsigned long)(ptr - sparsemap_buf) > 0)
-				sparse_buffer_free((unsigned long)(ptr - sparsemap_buf));
-			sparsemap_buf = ptr + size;
-		}
-	}
-	return ptr;
-}
-
 void __weak __meminit vmemmap_populate_print_last(void)
 {
 }
@@ -362,8 +310,6 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 		goto failed;
 	}
 
-	sparse_buffer_init(map_count * section_map_size(), nid);
-
 	sparse_vmemmap_init_nid_early(nid);
 
 	for_each_present_section_nr(pnum_begin, pnum) {
@@ -381,7 +327,6 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 				       __func__, nid);
 				pnum_begin = pnum;
 				sparse_usage_fini();
-				sparse_buffer_fini();
 				goto failed;
 			}
 			memmap_boot_pages_add(DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
@@ -390,7 +335,6 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 		}
 	}
 	sparse_usage_fini();
-	sparse_buffer_fini();
 	return;
 failed:
 	/*
-- 
2.20.1


