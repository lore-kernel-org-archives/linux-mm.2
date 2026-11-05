Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A208A606D806
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 17:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=psgrxQYp
Received: by kanga.kvack.org (Postfix)
	id E138A6B05CB; Thu,  5 Nov 2026 12:01:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DECB86B05CD; Thu,  5 Nov 2026 12:01:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD13E6B05CB; Thu,  5 Nov 2026 12:01:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E52E6B05CB
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:01:10 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3405980B82
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:01:10 +0000 (UTC)
X-FDA: 85401680700.15.5F52D5C
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf19.hostedemail.com (Postfix) with ESMTP id 20D4B1A0008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:01:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=psgrxQYp;
	spf=pass (imf19.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793898068;
	b=yv0zC20VdzgBrwfEC1IHSwmeTRXxtd1UZUHvAi6pvTGdYp06mPLxDWSTdIlp19ubygmxJw
	fUKH7ZpkXYZlAxykLDyfGtwHleupoeI9QykJqSyU3QxRudl1RT3hX+zmivfi87/ErUO95i
	IeaOO2v0DegkyjGci0B720eFxepk/DU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=psgrxQYp;
	spf=pass (imf19.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793898068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oul5LzoTaxn4S4nj0ooYPspeFyDzR2KYL9b0OuQrBQE=;
	b=UYmUztiiZJ9LzFiiB18OX0UBCnroIxPTFfXSZ2YbTDw9YgvN8wSiRGTa2XSid7MTd8Eyy+
	cn3swAZpvGqjdRqWg1QC8JBCtL5Rum36vrYv9jHBeTS3tWGWea9TqjM4vPigjG+Ov5Rc2j
	LPKIo4uryms0tIfTvHl7DSdvcW06b6g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=oul5LzoTaxn4S4nj0ooYPspeFyDzR2KYL9b0OuQrBQE=; b=psgrxQYpIsvmwAZTbTw
	mY70HdYmt/6f9iaYSvYKjrnsNWVx7DhPqT8mkYN0ALhKnaEYqNwNgNjBdAi1S/i55dt2Em2VPub4p
	IFj88LVzC7eTLI6s3U2kgOtbmtMn7dlcf0/nqsPesyex3+3WDw/SxchOzIcpthlW0ycX8ZiIedKEm
	N4Z8cUg8X9tNppGagEzTI1+zJZsPcjSnN4msCLYGeShPavmI7KTW0giCKlxuKf7ON95+opxTLrFmm
	+FqPqul5UpuMBWypUmDZYqT3AdT19G9P1lVOa22domA37hE2hezRbLgOqNbpJ69S100RBmvdTUFBG
	AsumZzIGVhJWlZw==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xP0li-005CiT-1d;
	Thu, 05 Nov 2026 18:00:58 +0100
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Thu, 05 Nov 2026 18:00:55 +0100
Subject: [PATCH v2 1/2] mm/huge_memory: take a reference on a folio PUD
 copied by fork
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-1-2828fe5a51ed@virtuozzo.com>
References: <20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-0-2828fe5a51ed@virtuozzo.com>
In-Reply-To: <20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-0-2828fe5a51ed@virtuozzo.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Alistair Popple <apopple@nvidia.com>, 
 Dan Williams <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Konstantin Khorenko <khorenko@virtuozzo.com>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6089;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=bARHY+HB017mGvDOpDMt65sYbsWWieKoZi+OZ4Py+mM=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq7LZLEaNBpFnwbXUorCQS3YF24tEdyvFX+Urke
 AAZFaGCigGJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCauy2SwAKCRBRlgpH+WFc
 KtCUEACh4LOREJ/asuuFGTmv6Fw69+jGI8H6InZvyE1AiYGOBnp2NeCV/y7ZkZRY19DEzZb1Mj5
 l2qTRhBqHVlwqe5WWbKgdyvVnOff68kalP6KpnrjAJN288t1k8c/0aEfWRMbmK/758UnDjDz88+
 tnMdJY3lV194a0PZZQDkSuAYd3ij6TdqY93LB97sESi+GfbAM04k8g9sFAu9Yvvbc4A80DmZsrw
 K6vtkYWqb7YQ0ODttwH8W/DNevcTvj/iztnJaFo4/lu2HzkZ4xd+vKSQuVBcJKYOu+mOud33v8n
 9zWHPL/dbzhyMbEPsPolaFHgdAQlKg1pDnGjaXFuFJGKkY1QJP7p64YKY9Bemxiupufrqi+vrZx
 TkUGz+e4EmWk4K0H9Nmx9bWELj2y4Gk913aCGjTaeDkYOX6mo+18aimtzoQI/9enYCsSfvzpnJe
 +HkiRD8jCbOAl6LiGdL6t8oXW0LbfhPWV9RP8ioVISLsqQEUj2ohTLDfHUwolNkYhbOHOg220pv
 Q2tYz9Kymj3SsXepcO8B/EOEGUI0GiqZQlTqbu8VB9FgObTsdXdLjGJbRwS6/ase3BEx5HseD1n
 BktX5qE56T6mISieeCFSNzgQgF/+w19utct6xCDPztOSmqgsdqIMdAQbbzjebzDMFQv0sLafKMf
 YIOgxQlf/RZYN/w==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 20D4B1A0008
X-Stat-Signature: swqhczosufo4c54tc3mszraxc5stgzxj
X-Rspam-User: 
X-HE-Tag: 1793898067-600617
X-HE-Meta: U2FsdGVkX1+shCtgIUZrHcuLpN6T9MXvjuO8sLzWaANzlEKZFIOb9eryzt1MapiO7sRLB2ImdMXRfUpgs4jNA3n3doEjKLLUABv2lnWmPsO+psh8QIgrbZ/WyRijZYuzIZg2K/b4MKX/5q1XN/m9B8ZSXm0gHtm+VWow6tGtVUl2N1CY4BcA9pG8jGUhKJatDkheKS58uF/sOVfa2thEPMiZTSZppTtP3iJt0QWplrXHUypQ0IG63Kvs4pKfPStmrCzVfDFAmNN4LRFClcqkhsecii9qf4axQyM1CCKo6ECvynMFPnlpbnfwK4Yo/K9vD3oK/oWe9gZTOs9rPLSCnZ0msrlxhQ6xbvcDrrojegFlYS5JolyYQEL66hZjNK3MoZckOlJ6k+vKIhxeU5Afp8j09dP4gu7a+RvURjTz35GuGSJyPIqjS9YiGGS/AmiODR4SFTRKNuaY2DYe2MWmyLfMa/bir8Udmmf5G3hBCVKj2Yb8hzY1PNqzRJUBHo1r5m/fg4aw5QHQF5saDsGkFpr5z6spRVIiZ4PJ+sbQEA3SM96AWWbQFWhldiUr4VYLIk6jh6IsX/2Eb+1Qjny5YHfzIxUpZtZ3/d9fA4sRFXnhtqGKZLh3zsuLedWF/5cM19Rveoxi88MuYT6MQHYeWim4e8EDWlPX4U7+WYKQ23u8YRAkaHyGuCTR8vYp0kCHZwTSovfIMwstX2Y6yMRThYB+WWm55qWs4ZjFT/NzX5Kc9YNGly8QblNxzwSFlWbdqJY4mvHMEg5h1O2xu7GIzEZ/npGtr5FrfNzFeTHcT0Q2qmIktU59HsohHGkOkN9WMzrwctt1s/HqROuL1+ovRn6HVxcmfcr2DK/Am7vvZT2yRvLowYUCE3NuAbuCodimKUR5oYohGKXx/i26KXWD4xTa+fvoRueQ3BxmGOoUwk35SkR6pX9TBg6LoLuxWHCRmtxg/a4Ku49CRYC7qHP
 xj5SPkOW
 Of9r/KbpRDeHnTkusx/9dhghbEkLIVL/Ipw7W3BmI7W6i2OC5Wfo321i460Va3MgBXF6IwNaHmXJwfHSJg8uAMIrLCcGckGvGutgBHzOudkOSCFfi12+k9zxCk7b8Hn2o40urv/ACYeh4/ToAG82LIqGGrxvKXcLXDEuTXtjYlBIRhrERZKqcR1YCo0iAUkNyHeooA2z0zruqlgoBcQneIk7Ao+UF8oNbwBfhVLhGLTQpbzBBvrga55XBBNAz1/Ozo9EjAek1Ynj14nBey+Gwao3FiBVKf4OhUuLXA47XC1juv/ziXgnW2sdqgNGLSJzZpA2j7Xk77l2QGq4pxKhuCfD4m9aprzWzoXMm5OsugPzg5So=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Device DAX maps its memory with vmf_insert_folio_pud(), which takes a
folio reference, adds a PUD rmap and accounts the pages to the mm.
zap_huge_pud() drops all three, but copy_huge_pud() copies the PUD into
the child without taking any of them. Each child's unmap then drops
what the parent took:

- the folio is a reference short, so with two children its refcount
  drops to zero and free_zone_device_folio() runs while the parent
  still maps it;
- the child's file counter goes negative, "Bad rss-counter state" when
  its mm is freed;
- the parent's unmap drives the entire mapcount below zero.

fork copies the page tables of a device DAX mapping that has a guard
region, and commit f807123d578d ("mm: allow guard regions in file-backed
and read-only mappings") allowed MADV_GUARD_INSTALL there.

Take the reference, the rmap and the counter for a PUD that
vm_normal_page_pud() resolves to a page, as copy_present_ptes() does for
a PTE, with a new folio_dup_file_rmap_pud() helper. copy_huge_pud() now
needs both VMAs, so pass only them and take the mms from them.

Fixes: aed877c2b425 ("device/dax: properly refcount device dax pages when mapping")
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 include/linux/huge_mm.h |  5 ++---
 include/linux/rmap.h    | 22 ++++++++++++++++++++++
 mm/huge_memory.c        | 27 +++++++++++++++++++--------
 mm/memory.c             |  4 +---
 4 files changed, 44 insertions(+), 14 deletions(-)

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
diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 74cca0e3c7264..52fff8dc74213 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -564,6 +564,28 @@ static inline void folio_dup_file_rmap_pmd(struct folio *folio,
 #endif
 }
 
+/**
+ * folio_dup_file_rmap_pud - duplicate a PUD mapping of a page range of a folio
+ * @folio:	The folio to duplicate the mapping of
+ * @page:	The first page to duplicate the mapping of
+ * @dst_vma:	The destination vm area
+ *
+ * The page range of the folio is defined by [page, page + HPAGE_PUD_NR)
+ *
+ * The caller needs to hold the page table lock.
+ */
+static inline void folio_dup_file_rmap_pud(struct folio *folio,
+		struct page *page, struct vm_area_struct *dst_vma)
+{
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
+	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
+	__folio_dup_file_rmap(folio, page, HPAGE_PUD_NR, dst_vma,
+			      PGTABLE_LEVEL_PUD);
+#else
+	WARN_ON_ONCE(true);
+#endif
+}
+
 static __always_inline int __folio_try_dup_anon_rmap(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *dst_vma,
 		struct vm_area_struct *src_vma, enum pgtable_level level)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 14599d0fff013..30c21e85d21bf 100644
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
+		folio_dup_file_rmap_pud(folio, page, dst_vma);
+		add_mm_counter(dst_mm, mm_counter_file(folio), HPAGE_PUD_NR);
+	}
+
+	if (vma_is_cow_mapping(src_vma) && pud_write(pud)) {
 		pudp_set_wrprotect(src_mm, addr, src_pud);
 		pud = pud_wrprotect(pud);
 	}
diff --git a/mm/memory.c b/mm/memory.c
index b65b56fe97148..66fbe8ed5bac0 100644
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


