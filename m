Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7708BD3E79C
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 08:17:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA2C56B000C; Thu, 11 Dec 2025 03:17:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B52DC6B000D; Thu, 11 Dec 2025 03:17:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8FDC6B000E; Thu, 11 Dec 2025 03:17:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9A2EB6B000C
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 03:17:19 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5E0A86061E
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 08:17:19 +0000 (UTC)
X-FDA: 84206485398.30.66BF994
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf29.hostedemail.com (Postfix) with ESMTP id 63605120014
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 08:17:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="M/6xMNAk";
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765441037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EjLnRLW+ZFEC1wSW1kP4/WvU/VRHJEHcFxTUH2LMdBg=;
	b=os+UxD0Ws8A6eN2F+2UwoGxSV7C5dWFVpPGJJ8w9BHO/TO7hWSdYKOQ/ZLTpo8HT65Ig/P
	cL2t7xv5vNTSajhIvllwkf3UAWTEs7Ljf4htQm1vgVOkUj9IRPyd5dsuv8iS7cgsjZiHNS
	CGOnA2m8nN6rt6hX4wtynqYWsFOuEVs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="M/6xMNAk";
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765441037; a=rsa-sha256;
	cv=none;
	b=OYIBzm+Qx5Vzo91r5PXB/FMapfvImDq/nVM9GgGCbbFxtZXRTDgp18/eB9mMQM0K9aBhNm
	LezlDtKI8KoSe6jj2qdAlnb4a2wdiXfKtrYyjKRxrKcTeltfMWVI0WfxWSgqoxRzkRuNr2
	Pe8HcmDmUf9XwIZvI84r87mxJ7yzPOo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765441033; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=EjLnRLW+ZFEC1wSW1kP4/WvU/VRHJEHcFxTUH2LMdBg=;
	b=M/6xMNAk3VtOmis4TO/umj1T9ADTtBVXYrYJiX3hZ6EcXNZPNlUBDvYtHc+QHIEyN5yCLqGDRVtS0tWWEZ0DCcFUpdzR6345+hYXJdGjdVvf4kINkGUquBVvAzoT0CVF2nA3LcKd+Retxig3FFv8e5wruREeS+b64tFx7WIupzQ=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WuZl4H3_1765441031 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 11 Dec 2025 16:17:12 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	ryan.roberts@arm.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	willy@infradead.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] mm: rmap: support batched checks of the references for large folios
Date: Thu, 11 Dec 2025 16:16:55 +0800
Message-ID: <545dba5e899634bc6c8ca782417d16fef3bd049f.1765439381.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <cover.1765439380.git.baolin.wang@linux.alibaba.com>
References: <cover.1765439380.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hikgs7xs89ixqkwidhkgkdpn5b4s791d
X-Rspamd-Queue-Id: 63605120014
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765441037-514176
X-HE-Meta: U2FsdGVkX19rr+uG30ZYhXhMWcsU94Fo4saNo4Qtua9Y6DplxLw4T3j5HGU+MkV094uYyRlICN8NbL7tM2ayf3NwHXyhvejrnjqZD8ghQrlNkbsuthsK05jKqYyNIT1fX/K46OYyrrgizJTkh1qVzBdT5pN7NH2L78D+hR87IVqUVOWuXUFLSm2kia5JHAHJlX8qIMVdMMDFpY15vfchSuXb+QQouTOjwYzdrO6GalbbukgIUVOkL7PzYjQl2U754s+1nMv4GF8xDnERj6a8cW1naoU5FPyR3aoxYwMQkKHHSVFV66JPsyEp1NI4OkaoYCxBjo7VR4J7OWoc0Yh4mA07yC7VKvdDY88vNZrvav0Ewb5Sc2SjnA9YZAhQQmNzID88y6SDplYlUCvDYplBIsEKMbB6KD8x2pj1eWxICfHi8eUxn79gHf56+hJrC2v1pGWfD0KwUIPmXWzSHamoiT3vJZSduUqgypeUmMWJOtlJmGochuRNdtar0bbeZlscu7Hmv9NtLGU9b+LWIydCv+CqTS1O+QZnb5yhMDXb9NEBiYp96awA+6NZadBL0aw8KkiBkT3m+mak+8+hSspG6pmVZYzpD5XZMl7266D7D+3nm+L7dpis0n6cFFa6KeScFT+t96wD3Bfgpq3A0LKbltF6Ju28o5zh0NfRbnlGUiwAA3iRxroAdJ5KNYxoyZJak3XJOJ/p3RWf5Ds7FbeBQR7iRe8JNJPvTZsGFxkJWcwKB+F5tnYCcCHYxDtWKw7NOPyAZAiEkYAYZTvcaKD1AGqOSi+iqLwQHeUhTV9yNr8Y4yUgNcV8J8EqpdtHT7LFMKA1UttO0T0/o0EaO3Nw7Ui9GQFTsCfOVBbPFy5ftnwFuJ9GDhBFkTCkMDh+Sv5v1Dg7Rqf8g+K7+OSPr2c3M0rBm11nr1LvxdAhb2QaqcWt16TEXJRq2hUgXBrLc9a5EUNg02KXGyXtxpS5z36
 OJYUlDi/
 nwnV5a8qiqYaG6tbmAdA1Rd2ZMmY8Hc4Cp9WDPx4pFspNHEwvYh0N02YiGNEiMaVrT9V570XmOn+3ebWO8RL+TrEkcc9n2V3JtjD/14nAWpi+NTaH8l8JedMNRo4/08BIrLVTH6sfgBJaXC7uK8wmSO5lDhrhg8OPcBCTY9ddI0UiYCeaQYX0sXNGI7GfV526ZzupDvcjg7nXb2HVhnv0ucFNBAqTtackzNumjBC16GVcSiyLpxIYwUhjkW91ij6uWYfh/iOzHUmZaQiChktkBpeoughip0lxT2Dn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, folio_referenced_one() always checks the young flag for each PTE
sequentially, which is inefficient for large folios. This inefficiency is
especially noticeable when reclaiming clean file-backed large folios, where
folio_referenced() is observed as a significant performance hotspot.

Moreover, on Arm architecture, which supports contiguous PTEs, there is already
an optimization to clear the young flags for PTEs within a contiguous range.
However, this is not sufficient. We can extend this to perform batched operations
for the entire large folio (which might exceed the contiguous range: CONT_PTE_SIZE).

Introduce a new API: clear_flush_young_ptes() to facilitate batched checking
of the young flags and flushing TLB entries, thereby improving performance
during large folio reclamation.

Performance testing:
Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and try to
reclaim 8G file-backed folios via the memory.reclaim interface. I can observe
33% performance improvement on my Arm64 32-core server (and 10%+ improvement
on my X86 machine). Meanwhile, the hotspot folio_check_references() dropped
from approximately 35% to around 5%.

W/o patchset:
real	0m1.518s
user	0m0.000s
sys	0m1.518s

W/ patchset:
real	0m1.018s
user	0m0.000s
sys	0m1.018s

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 arch/arm64/include/asm/pgtable.h | 11 +++++++++++
 include/linux/mmu_notifier.h     |  9 +++++----
 include/linux/pgtable.h          | 19 +++++++++++++++++++
 mm/rmap.c                        | 22 ++++++++++++++++++++--
 4 files changed, 55 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index e03034683156..a865bd8c46a3 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1869,6 +1869,17 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
 	return contpte_clear_flush_young_ptes(vma, addr, ptep, CONT_PTES);
 }
 
+#define clear_flush_young_ptes clear_flush_young_ptes
+static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
+					unsigned long addr, pte_t *ptep,
+					unsigned int nr)
+{
+	if (likely(nr == 1))
+		return __ptep_clear_flush_young(vma, addr, ptep);
+
+	return contpte_clear_flush_young_ptes(vma, addr, ptep, nr);
+}
+
 #define wrprotect_ptes wrprotect_ptes
 static __always_inline void wrprotect_ptes(struct mm_struct *mm,
 				unsigned long addr, pte_t *ptep, unsigned int nr)
diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index d1094c2d5fb6..be594b274729 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -515,16 +515,17 @@ static inline void mmu_notifier_range_init_owner(
 	range->owner = owner;
 }
 
-#define ptep_clear_flush_young_notify(__vma, __address, __ptep)		\
+#define ptep_clear_flush_young_notify(__vma, __address, __ptep, __nr)	\
 ({									\
 	int __young;							\
 	struct vm_area_struct *___vma = __vma;				\
 	unsigned long ___address = __address;				\
-	__young = ptep_clear_flush_young(___vma, ___address, __ptep);	\
+	unsigned int ___nr = __nr;					\
+	__young = clear_flush_young_ptes(___vma, ___address, __ptep, ___nr);	\
 	__young |= mmu_notifier_clear_flush_young(___vma->vm_mm,	\
 						  ___address,		\
 						  ___address +		\
-							PAGE_SIZE);	\
+						nr * PAGE_SIZE);	\
 	__young;							\
 })
 
@@ -650,7 +651,7 @@ static inline void mmu_notifier_subscriptions_destroy(struct mm_struct *mm)
 
 #define mmu_notifier_range_update_to_read_only(r) false
 
-#define ptep_clear_flush_young_notify ptep_clear_flush_young
+#define ptep_clear_flush_young_notify clear_flush_young_ptes
 #define pmdp_clear_flush_young_notify pmdp_clear_flush_young
 #define ptep_clear_young_notify ptep_test_and_clear_young
 #define pmdp_clear_young_notify pmdp_test_and_clear_young
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index b13b6f42be3c..c7d0fd228cb7 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -947,6 +947,25 @@ static inline void wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
 }
 #endif
 
+#ifndef clear_flush_young_ptes
+static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
+					 unsigned long addr, pte_t *ptep,
+					 unsigned int nr)
+{
+	int young = 0;
+
+	for (;;) {
+		young |= ptep_clear_flush_young(vma, addr, ptep);
+		if (--nr == 0)
+			break;
+		ptep++;
+		addr += PAGE_SIZE;
+	}
+
+	return young;
+}
+#endif
+
 /*
  * On some architectures hardware does not set page access bit when accessing
  * memory page, it is responsibility of software setting this bit. It brings
diff --git a/mm/rmap.c b/mm/rmap.c
index d6799afe1114..ec232165c47d 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -827,9 +827,11 @@ static bool folio_referenced_one(struct folio *folio,
 	struct folio_referenced_arg *pra = arg;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
 	int ptes = 0, referenced = 0;
+	unsigned int nr;
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		address = pvmw.address;
+		nr = 1;
 
 		if (vma->vm_flags & VM_LOCKED) {
 			ptes++;
@@ -874,9 +876,21 @@ static bool folio_referenced_one(struct folio *folio,
 			if (lru_gen_look_around(&pvmw))
 				referenced++;
 		} else if (pvmw.pte) {
+			if (folio_test_large(folio)) {
+				unsigned long end_addr = pmd_addr_end(address, vma->vm_end);
+				unsigned int max_nr = (end_addr - address) >> PAGE_SHIFT;
+				pte_t pteval = ptep_get(pvmw.pte);
+
+				nr = folio_pte_batch(folio, pvmw.pte, pteval, max_nr);
+			}
+
+			ptes += nr;
 			if (ptep_clear_flush_young_notify(vma, address,
-						pvmw.pte))
+						pvmw.pte, nr))
 				referenced++;
+			/* Skip the batched PTEs */
+			pvmw.pte += nr - 1;
+			pvmw.address += (nr - 1) * PAGE_SIZE;
 		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 			if (pmdp_clear_flush_young_notify(vma, address,
 						pvmw.pmd))
@@ -886,7 +900,11 @@ static bool folio_referenced_one(struct folio *folio,
 			WARN_ON_ONCE(1);
 		}
 
-		pra->mapcount--;
+		pra->mapcount -= nr;
+		if (ptes == pvmw.nr_pages) {
+			page_vma_mapped_walk_done(&pvmw);
+			break;
+		}
 	}
 
 	if (referenced)
-- 
2.47.3


