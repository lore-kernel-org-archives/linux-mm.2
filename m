Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A6DD606A33A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ccajB90x
Received: by kanga.kvack.org (Postfix)
	id 32DDA6B05C2; Thu, 29 Oct 2026 16:36:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DD476B05C3; Thu, 29 Oct 2026 16:36:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A5E06B05C4; Thu, 29 Oct 2026 16:36:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EB7536B05C2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:36:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 635F5A0560
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:36:15 +0000 (UTC)
X-FDA: 85376821110.08.5115E67
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id A9353160007
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:36:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ccajB90x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8FhHny9mHzITD4CyW6Cx5He8UZdbQ/QXgTkMZkuawzE=;
	b=v8BUgoTeMwbYpnSYSHkBI1lkbnK0AW6qIO3ubYsz2zJ16wrv9nEcQR3oIRE4MaOk6pVTTg
	rL+rTu5YJWs7sit3AAJMEHDmLb351KtBpe4wMH5RsQXY990ZYFSKk1uZf4vZcqKycrmZdd
	5anynAJMJLnDZ4ACcUG+92KUukmSjcw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ccajB90x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306173;
	b=U7RiCiU5sPEBkpgo8ovA6KCh5+yYvtelxyLT9F97YyoL3JVkU7V8eeHqAC4nFmkrDWslYw
	VXMyLbNYQDxf8lOwPtzyALryugDkfYbSNqFJ2lpXZyTxpvF8CmSEfgQoqTs6IMEPAfPVNn
	GniMlT3GyP+Nvxb8WBi/kHkjIJIJyGo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C9E46061B;
	Thu, 29 Oct 2026 20:36:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241201F031E0;
	Thu, 29 Oct 2026 20:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306172;
	bh=8FhHny9mHzITD4CyW6Cx5He8UZdbQ/QXgTkMZkuawzE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ccajB90xcKYAJCG+pfTeSfTQgjX/IGEu5IjSG5+Pjf3i6QHQbNF5DXftMaJFL6HVu
	 /5+C09DE+AnR3J0PzYmM64letPIG7IW7jp2VxHhPVYsO1JYzLZGMyx3TgxYn+mTvXr
	 p8xeUBk5TFgRSbPLFEUwrqVA2cHXP0EM5NyVUnDQjpsdjAsOCHovHoLpu9i/boW5oK
	 9GGuAoMMCHI5Rx065d5OV5gaX1z11Po9mfCcEkr2eKbTHlSvJUubujMoX+E1fhzo1y
	 47li6wryfeTWOH5R1QNgs2QcsRkR30gorcsJRsx5oWXrcZCkesEr7cPVm+WYu7sVTV
	 wUHHbmk+/tizg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:06 +0100
Subject: [PATCH v2 11/47] mm/huge_memory: properly handle refcounted PUD
 mappings on fork
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-11-a64ce7f83abb@kernel.org>
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
In-Reply-To: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
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
 stable@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4463; i=david@kernel.org;
 h=from:subject:message-id; bh=ziCtV5F1IAav4zC3aLs97NPTL1M7KSjISagzm3G8GUM=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer231ehEbUXtgUrZPiXR+i9qhrnuRX7zX+C11mGzxY
 mHX826XjlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACai8oiRoelaWFaAxWKDlINn
 1p2TPMcSULDb4rmTwC6PhZ0821oesjP8Fd36sWvXfC9JTqmgSbwbUpYvrVbv+qZ465tMtvHWGwV
 hXAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A9353160007
X-Stat-Signature: um3sqsrzwx5rgxfdy48w6bm67fc4pszc
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793306173-871287
X-HE-Meta: U2FsdGVkX1/9filCYme6jtMa34VYy/j1Ck9c2famHucyS8V+yuwuCtHZ462MIP9tz/Ul9caGDEMM1Ejb1ikHAPpfYWRsiiik2T08kHFG2HgXK3Yxn+HdfG3LMkXK5v2hWl3ELaFXj/gmgmIyTcf2HWIXYMXsMxNRTdHdM7Dha5+MLg1hWwT2FL/5z57rHhNsGjG9N/OwIhW7PN5qZ978yH25qwfDrSdkwmx9K7ifgR3Zu6ZjSwuIhCn0kpmtGq5wVaWdbwhUpV57pNGQOCBozlnYaLQi4i/c+Vl7GjUiRnqFk0c5SU3GYYRUVeNQTi1U4kiQVHcuBULaS7tSwt9uzH01P6r62Y9E0F3yLUr72hApQsdZbRfG9YYERVOHRuVNMlRBMmV0jljt2YQ3imz1/oI6jJJgXU6UvjyuLHGNSdJS1xQjaQAc+BKyEOORx/WkfZjABWFsfzlepcsEXoNcP186GH6/oFg60g6lQ6IW0nAmydAFFIXz9Mc2TXzT0yrVxy5yO6bHnAsCiPjO8gwfMLGqTyd5W7b8X1MCU9PnAO0YhuxnxvFdYVb7E9sXThYBwYTRmzfLCCnqb96PZSGDNos0dnW/zHoDS24kBKLYK7/4AC1+VTWHlUCnBVAcdKuGhRSgIKOUCdVwPe0K4/N9pM4SnKM81LB5b/LXMyPJ8tekB8HP3GsViXyri1VmbN973Yf0jdo5VoPnFYb3wZK95o8Peg7vnmQNXaUo6gFnTkSYfQvkHLDm8m5E+pQvC54rHMl7458otXEh6YdimU1/iWYnm8Vqzd4WT0U3mQUMPbTylxd5BiGUROMw/13MChCIuRYZjSu3lNbqRKZvEbstlAUJcEkZgEPwVdrUxsKZPWfAelAmd0CiDLNcC5qcmnfD6TRRjuSawV8xNTUCI34u+lTWFSXe/wYwpTIgSIvdh8BgrFbXn5S9DV8FSZocwaHvBP+9AxeRSvaKsBJFt/M
 J7sOgyKm
 WZFXX8iNxzSdXfbNNSdkKY1tDYRrHcfclw12yAAvooRvJivSne+nHPzP8OKQn9wRi5INm/SqzKreWjuvDl/3S9cmYr1THJGTgVFGm2J/dQHESb1mAzIaLKuT9vsfh4PYSe1AoCzGgJ8IbT+BaYLG6JQR5sD15m49dSNHO9ziOceJE0lWYKF2stpKAN5MZM265+EzN/aAw/gLP5aPsiEfvBSP9ZBSTGQlhctOSpBne9K1lx/W44H4HL+Qxd+3ruG5WJ+aPjtXhyeCWXkhsyDO5x4DgVaGAN1LbpDKaNlWFxrEeQgGsCPusRMIP494yYi1XGEEnx0lB0tV+HtGKZaq1Wsa3/iz2gOOQbY8eibRtkuLqBTgW8La2SO0xXhMO7Agjs+3xBjJYu3jW1N4=
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
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/huge_mm.h |  5 ++---
 mm/huge_memory.c        | 27 +++++++++++++++++++--------
 mm/memory.c             |  4 +---
 3 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index c745f7ad2298..fac05120ab77 100644
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
index 4c0194af9016..283c4bc8b927 100644
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
index 0fb676dd2bd6..5392bcb1d24d 100644
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


