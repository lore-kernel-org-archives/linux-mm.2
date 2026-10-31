Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76049606A330
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XKxku93c
Received: by kanga.kvack.org (Postfix)
	id A331D6B05C7; Sat, 31 Oct 2026 05:43:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0AD56B05C8; Sat, 31 Oct 2026 05:43:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F9666B05C9; Sat, 31 Oct 2026 05:43:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 696A96B05C7
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:43:09 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 012451208E1
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:43:08 +0000 (UTC)
X-FDA: 85382432898.06.9298E40
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3FCA7140002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:43:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XKxku93c;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793439787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c8H3MH6BWdT2aUP2bxmCyTqdb38oNJ2FfQ3UjfLBqqg=;
	b=o5kqY/hKBJ5ckI8qR6mv71YEZvnk3nf7R/HB+Gf0lWBV9PrqN0Z25ZO+GQPN8rkkHe/NVv
	uh5ZUDpiRRb+WFJA8yah8FXEUxcJzanyM6rL5iwEYb79mMvGkBQ+Jq0wMOWtvSa/hTPwr9
	lykkV5MUl/GHremQxryeZGyUsZIQMIs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793439787;
	b=5gOoEEwkoQNveWZiO1mBEbdWXFfRtv7IIrRBz5fuekyY/3hRVKP1DCuCRpBjCGWW535VfB
	6fOwG0+jDD/FK666qRfGDcRukD3gesrQ3LNjqv+mTzug3nYSW3EtGNBr48pJZL0d7kUxRG
	rCfs3iUze8sITwfhSM8E8A8+GsEr90I=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XKxku93c;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C9685600C8;
	Sat, 31 Oct 2026 09:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CABA11F000C1;
	Sat, 31 Oct 2026 09:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793439786;
	bh=c8H3MH6BWdT2aUP2bxmCyTqdb38oNJ2FfQ3UjfLBqqg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XKxku93c8qqYSbfQDsRSTB03j2MAGwx1Lqs5hUQsI3c4sVWK1n2y4ro23Yhs3yX0D
	 G2R5gX3bGIgaNFqk4rGiAAmeHR1A8Z22O+UZuVKxuVnQidVfOkRKkUnmjOE8w8OlnF
	 w1WTiEptpTJlrZYoFv3Q3eElYjggt1zyAdckWVOrBUKj2UlqZxm4oBG0QRp1rSjtGi
	 sU9HajefmO9Iv/63c/2VyNxCNchdSIuMtMG3TOhjdJU37i7o+MDbZKFoEPwF2gOlOc
	 X/J80Khhp+hD6DjBpYJ2pNYgGRlwj2tKhcPYnPihqvrA0RgtumI9uuNZ6B+nKWGFUx
	 6fqVpNTsWFxFw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:39:40 +0100
Subject: [PATCH v3 11/47] mm/huge_memory: properly handle refcounted PUD
 mappings on fork
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-11-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
In-Reply-To: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 stable@vger.kernel.org, Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4524; i=david@kernel.org;
 h=from:subject:message-id; bh=AisWB7KHkrv1Z9AhryNka/aHvDbvx4kG++9kdVXIDVU=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebk97dqHknGJAm3OY3urrucx5lxhlNjFHMJi8PiD30
 u7Nh8dbOkpZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZjIuqcM/0w3N+1dlv165Zx2
 iU/tEsKH3CJmJ+jNZjBRkNtx1V41+Dsjw8KA7INaO1NsZGN4qjhjlld/fBpkvov/y/Ss39s7n6X
 VswIA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3FCA7140002
X-Stat-Signature: u183wcritz4pcwpgj7scey1s7juizuih
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793439787-550391
X-HE-Meta: U2FsdGVkX19ehpw+f0EuppU4se0pSYIyiiq8/5vyn4pkc6ZZgb/jZPJPFCKQCcLitFQvEC8aqStOawXZCgel0RrBY0GpgNocgFZys4BQVO8tb4bSgK+vxew28cNFwIwVf9oDdbHfqDnQELR8Gwa9QqInenotldLO7Q/EBJTVFBpCuTVkQ8r2jWVVjP2sF7WFz/74UdyN/jRaI3lOE1FktDbpzq820t6AT/WX6YdgQcQvjQEZbk6hd9a0BZCyYlr05LKLmdX5n93nc2UUcj3ZK0YTUw+KnteoqSYFIzJGKC9PMPmN+z2tJ3nd4xhQKuFkOlwlx7pxGBfXeewYdl0jpORcLCBthm6Mq2Yb3iqiQV31rrXiu2Gsyw+8ERXRTU8opy8jnxzgvkExnE7lsml3SRR/ryKNzdDVfbUiNkT+DVAZFx4gQnoNGztI6cAUfSEg2UUyF65pRQErMP5iHUZXG6uW2Bbiqa2+wD+CBOQHREBMYQyNj8y7mRn7vCl9e14n2dvR2K3mt4sDaV+Sjb+Xhljs8X6FzN5KUG4ILyF/e6dOiTXiuY32V+uoEQo5PA+tDJDLwFdAhQKYeNaxfdaZetBBblDai8iR8cb+oD2aGYibGp2Qahmd1xxiCt+xbqyXDR5qtVDyPZz3U9c+5QkkMfBqCmZTpQgEMWhtunrB9c5kn10LANsm62dbYU0RPgYlWWt3WXeXlv0/lkZ5T4lYowxKfEEskUG07Gi0KEhpmNI2MIRaip5WLB0S6D/sVAi593Cr1rRWQ0rYdv00SVKLDz8/Gq+MSf7VubFPuv/Spa9SAMdVwnXTwKRJ9QJ8meP75kjhiOXuq+0qRRZR9to2b+TYyep2jd/EYJKTxHNkwggxQlWc/E7c9CVFY+2GzeqowcR4nitPY0CUwxVwPl7vDMJTD3Zj2C1vQ6xDlG9wtIJ6+vLYelSm9N1+JC3v+Wc3IUOlUEPEqevHF5tnFB2
 mNH4gEv3
 ejCTKLxgJXbjAQtv+IoLdw0iQFrMwJIW0LlwYf10MRuHEbisu4GGoajI5iL8Kgy5FzjmeWRWkaMhplOtcovZyHVYTMuZL1N5xGNaIRipd5zJ0aM51s3HHLxkekFSYEha5m9iFGR80hX+5291lojCcAd8YdBCvwY1V926FrGQuMrvxcXtK69WljDxRiSQocMDsxn5vb7K5bi0FDfUlE86Td47Jjc5ooQqKhoXj38mqS6d3byja0o6PpB+ReBWRmk0Zz17zExDxeu33Q17rzR8fmRXv/jMGBeS7kowGKZpemOIE9f54NQW41fHv6XDPdMooXMUO87DfTSleIo5owTSS2RCqNQ51xxMp1CaT0ynFPzncUFB6z2gysjd06BEm+wBB+vILVARt0T3uZeUCMoWY7J9dQ2ip87kd1XePxaNgxVwRoErRLMTED7eHwaVHHmwmnQ7u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

copy_huge_pud() copies device-DAX entries without taking a folio reference
or updating mapcounts and the child's RSS.

For example, MADV_GUARD_INSTALL sets VM_MAYBE_GUARD on a device-DAX VMA,
forcing copy_page_range() to traverse the whole VMA on fork. Any remaining
huge PUDs are then copied without accounting for the new mappings.
Unmapping them in the child decrements accounting that was never added.

Use vm_normal_page_pud() to identify refcounted mappings. Take a folio
reference and add the child's PUD rmap and RSS accounting before installing
the copied entry. Pass src and dst VMAs consistently instead of src and
dst MM. Move the TODO.

Fixes: aed877c2b4257 ("device/dax: properly refcount device dax pages when mapping")
Cc: stable@vger.kernel.org
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/huge_mm.h |  5 ++---
 mm/huge_memory.c        | 27 +++++++++++++++++++--------
 mm/memory.c             |  4 +---
 3 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index c745f7ad22987..fac05120ab774 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -12,9 +12,8 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		  pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
 		  struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma);
 bool huge_pmd_set_accessed(struct vm_fault *vmf);
-int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-		  pud_t *dst_pud, pud_t *src_pud, unsigned long addr,
-		  struct vm_area_struct *vma);
+int copy_huge_pud(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
+		pud_t *dst_pud, pud_t *src_pud, unsigned long addr);
 
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 void huge_pud_set_accessed(struct vm_fault *vmf, pud_t orig_pud);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 4c0194af9016d..283c4bc8b927c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2072,11 +2072,13 @@ void touch_pud(struct vm_area_struct *vma, unsigned long addr,
 		update_mmu_cache_pud(vma, addr, pud);
 }
 
-int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-		  pud_t *dst_pud, pud_t *src_pud, unsigned long addr,
-		  struct vm_area_struct *vma)
+int copy_huge_pud(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
+		pud_t *dst_pud, pud_t *src_pud, unsigned long addr)
 {
+	struct mm_struct *dst_mm = dst_vma->vm_mm;
+	struct mm_struct *src_mm = src_vma->vm_mm;
 	spinlock_t *dst_ptl, *src_ptl;
+	struct page *page;
 	pud_t pud;
 	int ret;
 
@@ -2089,11 +2091,20 @@ int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	if (unlikely(!pud_trans_huge(pud)))
 		goto out_unlock;
 
-	/*
-	 * TODO: once we support anonymous pages, use
-	 * folio_try_dup_anon_rmap_*() and split if duplicating fails.
-	 */
-	if (vma_is_cow_mapping(vma) && pud_write(pud)) {
+	page = vm_normal_page_pud(src_vma, addr, pud);
+	if (page) {
+		struct folio *folio = page_folio(page);
+
+		folio_get(folio);
+		/*
+		 * TODO: once we support anonymous pages, use
+		 * folio_try_dup_anon_rmap_*() and split if duplicating fails.
+		 */
+		folio_add_file_rmap_pud(folio, page, dst_vma);
+		add_mm_counter(dst_mm, mm_counter_file(folio), HPAGE_PUD_NR);
+	}
+
+	if (vma_is_cow_mapping(src_vma) && pud_write(pud)) {
 		pudp_set_wrprotect(src_mm, addr, src_pud);
 		pud = pud_wrprotect(pud);
 	}
diff --git a/mm/memory.c b/mm/memory.c
index 0fb676dd2bd63..5392bcb1d24d6 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1463,7 +1463,6 @@ copy_pud_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
 	       unsigned long end)
 {
 	struct mm_struct *dst_mm = dst_vma->vm_mm;
-	struct mm_struct *src_mm = src_vma->vm_mm;
 	pud_t *src_pud, *dst_pud;
 	unsigned long next;
 
@@ -1477,8 +1476,7 @@ copy_pud_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
 			int err;
 
 			VM_BUG_ON_VMA(next-addr != HPAGE_PUD_SIZE, src_vma);
-			err = copy_huge_pud(dst_mm, src_mm,
-					    dst_pud, src_pud, addr, src_vma);
+			err = copy_huge_pud(dst_vma, src_vma, dst_pud, src_pud, addr);
 			if (err == -ENOMEM)
 				return -ENOMEM;
 			if (!err)

-- 
2.43.0


