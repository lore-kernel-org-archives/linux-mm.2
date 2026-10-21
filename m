Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB75A606A324
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 18:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=czntJg33
Received: by kanga.kvack.org (Postfix)
	id B9E676B0758; Wed, 21 Oct 2026 14:11:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7C306B075A; Wed, 21 Oct 2026 14:11:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8C7E6B0759; Wed, 21 Oct 2026 14:11:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C8B66B0757
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 14:11:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E97C01605FB
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:11:18 +0000 (UTC)
X-FDA: 85347425436.10.DE01E5F
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf21.hostedemail.com (Postfix) with ESMTP id 347171C000C
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:11:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=czntJg33;
	spf=pass (imf21.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792606277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M1dTXl83utElj4WNg2krvHUULoFFNoYTsd5aEDSTt+o=;
	b=DfQTZVM2hvW3UJr9rqzXyQNrEFcCRD/0EtEaAfhYyvJcDqxwEOJro3bcqsQWSomBEVIKzY
	tM1eDhN2sRBpBDzEJEwveeFTGStAr94nXgQQsrGZkKNwAh9YYg2p5X1dP/wrQc/DyivUeY
	t2PEFJ0CJ/Zxxc4XrncaOUrfepMqZf0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792606277;
	b=3FmKRNv7zaRWhJZeJvT4xt4KphV2d6MIWI7S+WBu/CglFhGc22ELWZbdCdH3EXgDJAKBL7
	73JetitVs/0WDtXAEEUsQAsOCEjg4fbMZyWXXrSLbI+GtsqZ4EydPao3xg96u+eZ70RaqI
	7jh5Z5KUjx9mjNLlqVGpW3kdc3ZCRag=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=czntJg33;
	spf=pass (imf21.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=M1dTXl83utElj4WNg2krvHUULoFFNoYTsd5aEDSTt+o=; b=czntJg33/EH3MMahMSC
	1zvgpqrY+bEcrs6XioefvtHFzDegujHA6tzNNsD0HbCXPAnNe/+NXy+O4EOj+Z8J8i9qBWYYo+Hm3
	dHja8IcQ9WD1pC1CIYc4YHGZ61dnlw9hjmlQDnS8VlrUGSPRlfJt3KuPpaygqcWsyxe6EUV/3EDo/
	Mfe8LuQSmd3H5b4Qmi07j33h71BkbvKJe5d1awB5Qs87J2M72l0eJ4d2qu6+jWlKsbGny2ahZ1vES
	LZdLx4WpW8zCBJkZHWzVCs0cRbyOnmws2fIV0vIMGZugW6Wdnfw+uLrjscLzM/FJ6ZTXQ3DtqI8PM
	J18dTxWC65XAV9A==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xJaif-00ANvl-23;
	Wed, 21 Oct 2026 20:11:04 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Wed, 21 Oct 2026 20:10:53 +0200
Subject: [PATCH 1/2] mm/huge_memory: take a reference on a folio PUD copied
 by fork
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261021-vstor-150143-copy_huge_pud-folio-refcount-v1-1-8bd88551f9be@virtuozzo.com>
References: <20261021-vstor-150143-copy_huge_pud-folio-refcount-v1-0-8bd88551f9be@virtuozzo.com>
In-Reply-To: <20261021-vstor-150143-copy_huge_pud-folio-refcount-v1-0-8bd88551f9be@virtuozzo.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Dan Williams <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Konstantin Khorenko <khorenko@virtuozzo.com>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5104;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=8M/OBpw5Os7GQ5/io4vjGbxC7NEnaAM1Ho77x2Uuv5k=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq2QA4FTU+mgpWgG2VBPoT3uxOpKYeA855gQISj
 xeMgsIspaiJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCatkAOAAKCRBRlgpH+WFc
 KsgVEACL10FRNeije/yqAfWx2B8jti5tdDDN2wsI0M0g179SDXeDTbLAeu2gHI8pnzThXf40fIs
 VUuSj6BKWmGXdBNyIYC5xVTHgz56FIGFwfTJPlDfqK6JSnwd9PcRdxiaPFkjXBhS45Il028W8TZ
 u+uQEZJfGOD/P9Ip8RKNaK77929JrfrxAPTscCoii/p+axeaTtHXDsuklsRh+7Nh41QZJVeK0CT
 ULwvKwXAZzmLCJY8r2fLHcBCOg0RODrThi7JRKyrHw1om6j3jwHkjH4j0QxfUskRWRWeTC5G8k4
 F22rl0GSDzlnYxl5809cy/qM73ab9NOka42WUbvlc+L1wnAtk1nSHec8qi/rLclP07bHUrXPZCG
 s0NYBcTjHOe52RoPa0n522Oos6+ORwk+D4hFJEo1PTlQKkq143nIpWgSOnyHD31Ss+XRxqszmZJ
 +x1EsjSsYkyW12xcRj4JMKB2e6wQTaihik2IxgH8KquDiYH/dw/UFNUwxMWXSvk5EnCOQznMKAr
 T5Yw+09lK0b+YycYvaswvEkOQTBu5mVY2v1o52T4hHc2do1fCR37HaFUHGr0KTZh1sQ7kwGR+3j
 MH4/Ks+qnauXMCODsdgvEvV797fk1aW612Uql1754xviqlKhmIZhJls9TKrQWyqM+qrLPts4fDC
 q92bVHoAslG6NXA==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 347171C000C
X-Stat-Signature: zeirs8x85a3f481pmme5emxe5yqcndga
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792606277-813172
X-HE-Meta: U2FsdGVkX18hITCV23D3kJdT3NHNKDOKb2v+Up58uo92PfQfcZi4mPARIm6dK0u/cruGcSjYmVIKUR5tXr0R/S1RTOsrCYmyPRaubm+jr48aVk6LgToOzpFvtTummM5ZH9mMA8mnu8yHbWvqFaLcjdav1Dk8dvXMf8afmGS1O2W/4A9K9S9sVd7yMxmBjcvWwByMW8uRGMsRNLBwqRVbtKtvByqpJJkdpLVkd120hh4brQ1DXN5JcvwLH7Z+TnzmDtNCcXxPMmCvwtXnx8mkGqfvoJItxuYsJsdRTy2/T3gfIN/+iJUe2SCikW772HU6aP5yBExI+K63WhTDvT0XNNiWgkc8i5iq81Pi7yK76IqjtwBrdc2OJkzVZjSTcn0o7Ew68pxeSlL7xQcRJztFpZ7WqwNge0E7Vbw2HwbgMKceJYFpTtmRRhREGc6p6Ve6Dj1FyAFepKqqMEysjzBsqjjdgiY4Rnte9NnKnhlRY6ITduJnuHBDETJDudR1OP7oKp7nUMElOXsch53ipyOQ97PW7kL/JpAZHad22ZYPHcElnWWWEpV/N8KphtbePFH/Vo7VX++SidCW2MNNP3m1sHopzeFfZb2iJqHK8AkWzpAl0R7LG9Mf+4mA/dyOvfjXDJti+fVaT2yYGLn0ja1rIIdqbNKgTjzxtO0cz+Driw6cWnhg92gip+dbB7fiB/I2K3lEZgn2huNKsimZ9Vh9YMLK6mgvkjCg1YKgzoc2c0iS7Zq3uKDW8cCpkXelCOqeJjTUvv1G0co8pl1u77zWi9WNprU1wEIVzrJxEnSR1OvhGTB+z1Wtf7DBmm+uhH8SEAQx2T2UwUNr9/byBRRa9eZcmQgv1u3zLXFdugN43K/+0tL3rK3vQpH09T72xuI2+XQ94PFWa0+09J2+lWcEwV/wxV9jjPem9a5dqIWzdJrs6+LcuqpcqgHUlQ0ql+4aQpCCPOHurLU+oT9Znzb
 D8jTSufe
 vYm00QHzFrvTkYMbfBXpEn8w9Sn6436k3Q9Z8AFuvTTJ4Mn6wBMsZyeXeM5f44f9h3JloolGhcYcAQG2uTIKTyYxw7V4xCWH7pSc3kgQ+ou2ctn+hFkfatiyNe5FrSiGytsp5FYF11jJqflwXkm6JwTH8k08vgia20SzQc3nGIQKNIFn3hTjE6WW9lpMmYRWx72X2rJGsqekFI2+6xKZqqwDkPATfAm6rQpYUvIgvC4rJgKR2kcv6pCtKQ8cQOhSEhDOsmHhHSmta65AzUrN7FseBbaEkqyFPPuDr0El7Vb+dWFG+oJB/PdAAA2kvoYrRepMEd8BOSqq1vQYEZ43y7eLCqZ2So6+Y+HhM
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
region: commit f807123d578d ("mm: allow guard regions in file-backed and
read-only mappings") allowed MADV_GUARD_INSTALL there, and it makes fork
copy the VMA.

Take the reference, the rmap and the counter for a PUD that
vm_normal_page_pud() resolves to a page, as copy_huge_pmd() does for a
PMD, with a new folio_dup_file_rmap_pud() helper.

Fixes: aed877c2b425 ("device/dax: properly refcount device dax pages when mapping")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 include/linux/huge_mm.h |  2 +-
 include/linux/rmap.h    | 22 ++++++++++++++++++++++
 mm/huge_memory.c        | 13 +++++++++++--
 mm/memory.c             |  4 ++--
 4 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index c745f7ad22987..c5094f9d95ba9 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -14,7 +14,7 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 bool huge_pmd_set_accessed(struct vm_fault *vmf);
 int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		  pud_t *dst_pud, pud_t *src_pud, unsigned long addr,
-		  struct vm_area_struct *vma);
+		  struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma);
 
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 void huge_pud_set_accessed(struct vm_fault *vmf, pud_t orig_pud);
diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 0b332770abeed..3c9ed8e27f0e4 100644
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
index 1e5d68acf62a5..7e8b41f293a49 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2075,9 +2075,10 @@ void touch_pud(struct vm_area_struct *vma, unsigned long addr,
 
 int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		  pud_t *dst_pud, pud_t *src_pud, unsigned long addr,
-		  struct vm_area_struct *vma)
+		  struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 {
 	spinlock_t *dst_ptl, *src_ptl;
+	struct page *page;
 	pud_t pud;
 	int ret;
 
@@ -2094,7 +2095,15 @@ int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	 * TODO: once we support anonymous pages, use
 	 * folio_try_dup_anon_rmap_*() and split if duplicating fails.
 	 */
-	if (vma_is_cow_mapping(vma) && pud_write(pud)) {
+	page = vm_normal_page_pud(src_vma, addr, pud);
+	if (page) {
+		struct folio *folio = page_folio(page);
+
+		folio_get(folio);
+		folio_dup_file_rmap_pud(folio, page, dst_vma);
+		add_mm_counter(dst_mm, mm_counter_file(folio), HPAGE_PUD_NR);
+	}
+	if (vma_is_cow_mapping(src_vma) && pud_write(pud)) {
 		pudp_set_wrprotect(src_mm, addr, src_pud);
 		pud = pud_wrprotect(pud);
 	}
diff --git a/mm/memory.c b/mm/memory.c
index 8b0c2c735d3de..8acd4d5bb2310 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1514,8 +1514,8 @@ copy_pud_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
 			int err;
 
 			VM_BUG_ON_VMA(next-addr != HPAGE_PUD_SIZE, src_vma);
-			err = copy_huge_pud(dst_mm, src_mm,
-					    dst_pud, src_pud, addr, src_vma);
+			err = copy_huge_pud(dst_mm, src_mm, dst_pud, src_pud,
+					    addr, dst_vma, src_vma);
 			if (err == -ENOMEM)
 				return -ENOMEM;
 			if (!err)

-- 
2.43.0


