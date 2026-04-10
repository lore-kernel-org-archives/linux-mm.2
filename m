Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A019E9905C
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 09:24:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E0146B0005; Fri, 10 Apr 2026 05:24:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A8416B0089; Fri, 10 Apr 2026 05:24:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87F996B008A; Fri, 10 Apr 2026 05:24:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 78B1D6B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 05:24:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 299E8B8C1F
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:24:32 +0000 (UTC)
X-FDA: 84642110784.27.932D532
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf25.hostedemail.com (Postfix) with ESMTP id BE607A0009
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:24:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=V5R7x7lf;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775813070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=MYV/0duq4LOt+J5kTnYMXRFeei6PB/waIW4pRM0G3pQ=;
	b=n8lNR/F2LXse65oDHQzezLT2R7p7zr/hsHc81/JpP1zoj3Vni3JXW1/v4XgBXdsZl9zthS
	HJYS+9nc8SLLCq9M1V1BCeSF09ECLc7RDANkS5wG9iXNpzaMt0LyZ+gqB+4rSWEzVoktmI
	vUWLd9XII5+NXaGUfcLCJ2sFl7ui3ck=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775813070; a=rsa-sha256;
	cv=none;
	b=Ie2yoIZfy+nNIocmgwnyphDHhKjj4DghUq5A3IPQXS96GvKn0WKREbTzV5O/DSKBwyIuZQ
	dysDcJ+TSEQVehANGt9N0CEHtlrC5wJth05VA6yrCT670LxuzZFzHEQlSH+nB9VNjDQx4M
	0xhTBndFYWkVIMc0j0KBNf2Wr7kXTeU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=V5R7x7lf;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c76af79f029so749009a12.3
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 02:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775813068; x=1776417868; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MYV/0duq4LOt+J5kTnYMXRFeei6PB/waIW4pRM0G3pQ=;
        b=V5R7x7lfujhWS/dA4RJSM/3LdwkJG92Xde4xBsw/faO0zDmDfWPrUspbwcvR4JjH5v
         oVTGx9zb7VjFnnxZfSi8qRXWCr5vPu7Xq/o8wgKYOvl75OBjLTbCS6bY8cqqK7tLt6z9
         kh6QHNT3aXwN/GViC5ivPOp6rCY05F5oKn6eEU6/U8rZg0IWdEXkiEYfY24FpTBpiSwi
         rychAPBZKbY1sWM495+FUNdBugHF9aFjMM8NBke8Xn9Tuxy6Oy+3G4h0W31ZCsKPuKSn
         NJgnVMHJYTJcC7eZkgaRk0XJkVqlweRk/7FxYep28CVGmMNRjEyfldEo28KK2kEx20OD
         dp9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775813068; x=1776417868;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MYV/0duq4LOt+J5kTnYMXRFeei6PB/waIW4pRM0G3pQ=;
        b=qdy15QIMNpRooAH6LJm4h16pveMyEfvPCilUBiZGv85XjaQWZQXKntX+78rt6nq7p9
         I97giV9JeF1JBxGPVbEvkbAGvFowIeS3F87khru0XWWXPgl+pfL2QwTakPho5CORF3k9
         blLSET7WBF2/7XqV5XBYAuEwp6g1wbvJ/PfPP0+NYuZrBvjstjWTbsKnV19yENK7vc0W
         WYVPWDqnd5WWb5n8mdbNr4yV/eMdub7FOOtNRIekZkFF9piURw1w1wC4q18ihcGkYLqa
         Nvu7cIeIfHDgcdNPVsCbxyFb3XgfwohxV6chZ8U5AFeWOazBfFzhMbAD6TjBfDkaPVhW
         DJDg==
X-Forwarded-Encrypted: i=1; AJvYcCU3sq2IHt9B/xnte1ypsNEvg37FrdjN7YrUqwP6WEFZ+fHnUomMMwLoMaicKY+VkRbiQ1UCvNO4lQ==@kvack.org
X-Gm-Message-State: AOJu0Yxect6GgljI7r+ygvQYxa2ZpwqNsiCmQQgFp1fJ9wvwae/1xO/r
	uSIJ+GqyK26cf0O+/x2jkxzf8pcr5QbiCYb5m/Q1fh12ZDOYggRqhwrCdjyLD2s5XUQ=
X-Gm-Gg: AeBDievuahc/OnbdayN2PUQ6bGhQFm16e3ofAsUiQqUZ3daBAM6bCf9Fid5jbS2rx1x
	RW8Cb9DzcI4GuIb8GhdWp/woD8H64a1m0XkDdn1v8bw/IoxaEzPzr+Vpb7DsEG7CivALaCuU3XQ
	axFi3Ljp4ZgD7k1f2AUAd/htPf6pV6WwRD5NCMUQceluJ0BjcJmKmHZHgt9agjRsQjAd03euCZc
	Pi5PCuH74kpfAfdESOhFiqupq+cVuwATq5kVUxDIgLRtxJoeyB5eBag8UOWoVDeTaIjaUhazE8r
	OoEtvmQPVCK7rhoWXR+kC2ytxvg1f3EK7tqFl4iZKwhlhlMUyHKqj2WiSmcnWpbsccNEFDlPY7n
	sd2qc20QRJIoainOfG5lpCtnJuoZkXKdSnTFRhW+wcml35joKhxd9Rx8jkPdm+S11go0RAk2SxD
	HEZA2s9lyOq02zz+u1mh8aR72rPG1E770utPlEHIbUpsg=
X-Received: by 2002:a17:903:3d54:b0:2b0:c90f:449d with SMTP id d9443c01a7336-2b2d5974e97mr19644455ad.19.1775813068134;
        Fri, 10 Apr 2026 02:24:28 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.98])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2d4dd7faasm23159065ad.26.2026.04.10.02.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 02:24:27 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm/sparse: Remove sparse buffer pre-allocation mechanism
Date: Fri, 10 Apr 2026 17:24:19 +0800
Message-Id: <20260410092419.2446420-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BE607A0009
X-Stat-Signature: 4qz47b3run1r3h89pjmbg1cdrj6ri3as
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775813069-175589
X-HE-Meta: U2FsdGVkX18I1cTYuZOpGHKvBUt3sK1pbOTik+KQZsLzhOnjDKvx8Ezem4/yjqJy9IKCpQj81AISquqr/mxmRpj66HbUwo2htn3ZlISHVztSSV/5bR9b/VQG4mpc5pyXqu4qes0Zt6zyZcvqDSlPBHdIgzuEafXSFwjLPZgY28JhXMNMYrQWQ6Sg78NSwEoYDZJbX6cFqkWorzZn70cvPHcTvOYdK2rIiUE2aPlM7+h2vn05DFH/QVza5rvedzuY5yEMKf0+KWGw6NlKNBLlN2pbgxQG/A82fZpFXpLY8BIOKys+8hYZ3Uubx2mXxRn4CnXFHPigV1hFOa8wQIZJweg2L+L+W6m5KYXLHG+VuEGg/NGWwxAYPmQvtlF4eOrhW3AGYls8+8HtoSSpGMD6oCHwMC2nmAgu6w5zhrFwXrX67S0BWZZzE+7d1ItNt6dXsA8DoWmtBVlDknNJxkZiivW1mDfAcWTBo67czBoF72lUy+HOuUPwjTdu1wvsVVVXBflDnNavpPDjL6CZh5JQIA43Mx6FK3+dAilT1JFser/QYCKRGwnP4BNxF2avBvf3UtgYAYKiYGjpZXNOm72P1FzmlYkovp/HvifAC74qV/+/2txv/tPe6nBqJkTV1+XAtyakF7GYf6DI56G/3MFYnSDnp9/AUxhwlQILqr4eFJhu0IcJqnTrkA1Od3E8V2eV1jjMKRrOiDxYbQSW0SrPuznWmMStm3rWOMs0YtfvxncJB85U5QqZfbYY79pgob/0eDLcYwQcmcw0YThEfL4vDmyNhFQa8kBW6XA9pxC6VCW0mF7Rn0D915t9KVTy4lFum1PhGV14QtF89+vvR6CvxrZZxX4i7yEar9G7VxEW94n/8q3rAMBsxv4hpLZDDNe6Set4QPRB226uG7ygGjfMh6NMrHZ3FsitsX8XC4g+dhXJIBGOaoGBOH/PZ0GjYiSjwIYtUyH5gqMrr4V/JUb
 3U65snhm
 MBt4sh7bir5dNBviGU1XGswyxJUTZ+0B1v4l7xP9nwmgar2X8R2W8fsVmEXG51C4hAKl5ImneSieDRd5aGMdPv1YtsOWTHpokmA8PixTvHcGT4UjGB0qlHG6KBPFw0h6LfDXoV69UnxVfQIEfjf7qJrjNhiz1ZbCynOVkeNrFl+BNVzXXPYmg7nXrRGAGEhyj0nITDYrqsAz7Ccg+eWQhYqO4WAIbtaphtRqKbE482mZ/gHHMwh7ZKJFf7/+sNJdC3pjwr6VQYqt22bejSn+YXujEot24jrHIfm5uzjMiJFewG5PP3heT8KpsWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 9bdac9142407 ("sparsemem: Put mem map for one node together.")
introduced a mechanism to pre-allocate a large memory block to hold all
memmaps for a NUMA node upfront.

However, the original commit message did not clearly state the actual
benefits or the necessity of explicitly pre-allocating a single chunk
for all memmap areas of a given node.

One of the concerns about removing this pre-allocation is that the
subsequent per-section memmap allocations could become scattered around,
and might turn too many memory blocks/sections into an "un-offlinable"
state. However, tests show that even without the explicit node-wide
pre-allocation, memblock still allocates memory closely and
back-to-back. When tracing vmemmap_set_pmd allocations, the physical
chunks allocated by memblock are strictly adjacent to each other in a
single contiguous physical range (mapped top-down). Because they are
packed tightly together naturally, they will at most consume or pollute
the exact same number of memory blocks as the explicit pre-allocation
did.

Another concern is the boot performance impact of calling memmap_alloc()
multiple times compared to one large node-wide allocation. Tests on a
256GB VM showed that memmap allocation time increased from 199,555 ns
to 741,292 ns. Even though it is 3.7x slower, on a 1TB machine, the
entire memory allocation time would only take a few milliseconds. This
boot performance difference is completely negligible.

Since no negative impact on memory offlining behavior or noticeable
boot performance regression was found, this patch proposes removing
the explicit node-wide memmap pre-allocation mechanism to reduce the
maintenance burden.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
Changes in v2:
 - Addressed David Hildenbrand's and Mike Rapoport's concerns from the
   v1 discussion by incorporating the detailed memblock contiguous
   allocation analysis and the boot performance measurements directly
   into the commit message.
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


