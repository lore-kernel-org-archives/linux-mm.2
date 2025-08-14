Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86B0FCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 11:39:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F062900148; Thu, 14 Aug 2025 07:39:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A2CB900023; Thu, 14 Aug 2025 07:39:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0420B900148; Thu, 14 Aug 2025 07:39:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E27E2900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:39:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 671FF83391
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:39:58 +0000 (UTC)
X-FDA: 83775168876.30.D6CDD5F
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 885CD40004
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:39:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Fg+353v4;
	spf=pass (imf04.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755171596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Y/wWKeG5u1jfnJjSbpJ5jwTxyYnLSO1DOEjsCzlhMM=;
	b=3dL3tSWAQ7gDuKJqBrzKTOU8DZgtA7GxyrNHLel7aTxXdRfBNdnXM9Ufc76PuRN2al6CIP
	fVBbXRK5+drOu8ZCPAerwY2WgWA6Q0PFyWDVKf/Y27nQ/uHQl4J2UvYspxyE9X3LRa8F2L
	zoNBIY18hi5KtDF7Mi4wCGvCuC2zVbE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Fg+353v4;
	spf=pass (imf04.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755171596; a=rsa-sha256;
	cv=none;
	b=SUeJnqSeGFOSyNPycS68GusNjS1MKSanxe/Eeh4NOKurPeJoaaDmqFDQAvXgbnWzPywhhr
	AmEFcBr5yoYiwvr6uQ4tH6oYNUq+uvv1xWLj6SsM4Q/IYDumHKPQaGJhVVmds+ZPH8J8XA
	yc5YGNekv+u3arprZXwRMS0Rxh+ssmY=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-76e2ead794eso621952b3a.2
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 04:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755171595; x=1755776395; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Y/wWKeG5u1jfnJjSbpJ5jwTxyYnLSO1DOEjsCzlhMM=;
        b=Fg+353v4XaK8At1Wm1PUg1Dcxl/kItxATZtepe2qOWQYA4rCQYdqTBQ4As2qXCNIJ6
         N70KEloVr3/QsfsPVSNU9ROjsdBFRViEP8i1zarfmqQ+Gu/Gl6o0hEpac3UWlR4+Tvgm
         6zbpIK/f74HWGeBI8ZyNvs/RnqmJYqVA5yiGdUQDQL5giSl5Qmg08nWdeYktAin+Lfwb
         +mw9FecwPxMdHZpDcxSL9H58+59FpNM1ezWyWssQ3mcxR/TZz00hWCYDIGx2YIRyktFR
         vUMIp1VR1VriUmnLspd0WiRezOaSPaVPRySWBonZMiO9ShHsYiFjVg6kFIA30afXUTeD
         CoSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755171595; x=1755776395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Y/wWKeG5u1jfnJjSbpJ5jwTxyYnLSO1DOEjsCzlhMM=;
        b=il3zN8ADT6e0kBgc9n9uHWlIfEJwVKqpFlRo6FIpvK3UTdUF3Fgi93F5zuvy+6hHAY
         Y/BXz8Lrgb/11u3l0jz4gq9QEh+rQ64S5dRea9gwxUiEPJo5bpCaiCq59Tr789I27o6b
         t/Fdn60YlSAznQ3LQsXBeOHQ67Z1C5Wxg+aCEn9t3crQFGgR0uw7+DOBU6E4NJcRQ/Q/
         1WZtLmS49wxKlJsjTybE1ykXfm803B0Vb6369OL2/IxDOSUoPhiQKFsjbkVGiv4e2NnN
         1SCbHcp5dAz2G5SOkBgDNm0nJbNVKd8jScfpR0CsE+MD7SZOaElGw5Ag2u3/R2s4wBK8
         kmeg==
X-Gm-Message-State: AOJu0Yx5HDNHa+fTGThUOUxYyD6BIAMV+icLoR2hztoLmIsLO28ccx5/
	F3eBQJ4pmweraK9UOZ8z/nwH3hup06mF6X2Dzwt7vlAW+32sbDyPBeDG
X-Gm-Gg: ASbGncsbDXhSZ4ZN5mE1VXE+WSfLnZW6N8R4jysSNWf++wEBK8ZYnyTv3QclBhpJ2CT
	yh+XwSALCrSUEVV+jTSmuqDm41kvW1DGmxAXs7j4KI/wj+9FjSFUhEc7j1tRtzP+QTuTtbG+C0y
	EHBm/bM2hnINwWUzibO+0HrSDWqh5hk5m83MB47Swixy27KhD+SKBhcB4FDbnrbSg+RO4kTg8wo
	8I3vK91BUhbahNph25VgXYJHGMWlpRF5uDjCSenzIXW7+49nG+LIS53anOMF8gA1DqDUSL29cn/
	Jv6pKgMTyp1hXpdEJYs1wuDizW6JTri5TtX5+W0N6frzIxR8Ew9taOpZMxO156ar279ATIYQXP6
	+xGT19I0ucaFjzTcw7oa+U64umcQ=
X-Google-Smtp-Source: AGHT+IGy8kcc4ceg5UXhb0CFpNNTopkMN4x+9gllnpiGFR28e2oz6pn//a1Jx3kZcmsxha16uYMXgg==
X-Received: by 2002:a17:902:d50d:b0:242:9bbc:3646 with SMTP id d9443c01a7336-244586f024bmr34369685ad.56.1755171595179;
        Thu, 14 Aug 2025 04:39:55 -0700 (PDT)
Received: from vernon-laptop ([114.232.195.227])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2430b53d504sm49046215ad.87.2025.08.14.04.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 04:39:54 -0700 (PDT)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	glider@google.com,
	elver@google.com,
	dvyukov@google.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	shuah@kernel.org,
	richardcochran@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.or,
	Vernon Yang <vernon2gm@gmail.com>
Subject: [RFC PATCH 6/7] mm: memory: add mTHP support for wp
Date: Thu, 14 Aug 2025 19:38:12 +0800
Message-ID: <20250814113813.4533-7-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250814113813.4533-1-vernon2gm@gmail.com>
References: <20250814113813.4533-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 885CD40004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: og9sgzg9ahix1rpf3c6srbfgte1d87fh
X-HE-Tag: 1755171596-219092
X-HE-Meta: U2FsdGVkX1+etqW1NObP/4G/Hs8fjDKepdVdviNHLIULQZ8X17s+Ee1UJBzOUuY4VQJBn3qpYwxYg+ivFzFd1iFAzjnKv2fZLGAPDtLkq+81GcgmvRsMidoHAjLviR3WklmiHfoATSavRdS6oEHZkN6HVT4EtZ7XgO1AzQvkDt718blz29L0u5aYrM7+tZ/RQBvbv6JvuNbPaUm/0WgteWkXsFsuqTfaWjYMzlteAw5G1ANqQ7kULAZdyfwANdgYmVcrlsX3Os4sdtRX3Rj5Gi3C7sAFKj9H8T7pbig8+EOkdZNKKHpTXGmBTshZLpJsJS5kQ/MG4aZZrbiCAaIKBbdX8g+Wu28rLMJf3VPU/4L51N2Hm0/tombs5sSHtbNkAAHs3gCHE7RKHRpTDQ58+Z7ktfyCmdVR6lBNL5jW6Z3xRd8BssxgKu8R5Jy7x6Y1cU173/TatmqHOtOeH8q/gad4mbNNYjj1uj1czNg542kYXRqFgxdBOQwTeqs26vONxKLK+85ZCzzGywJNsn0vzIRtcvlMjV9mKz2SJtvuslA6AvXM5H89jdd3ZgY0VkDiCZTW7SGnjx2jx7/hBIzZnXDZjGUIZs05Q70D9yxqkMmwDIScDU6LyORU5T7B3iEILuPQB3ywxHntJpxcWw6u9gPHJNlByDxAJtAW4LKUcbGOg1Ybc4YK5DIGDnxXLuqJnC3Oe7crN3LSsEu2vBau2FztFXhhkkANFLuRJ0BGfdEvR050SU/s8GXfhInjpWAsAUiBlGjzlZgdHF+8H9/ve1wwjql+/QtfjSUCJZNymyWAU5UlT+4/2qaXfo1HtpQKHyBFw8XSf2+KEn3QW9edWv0owQX7vebRilMZkHM21/wYhySea7O1Pzh7WiSDZ303X4o4ZkbIh1RPgnuVK30C5zE658B3j7vOrOy+yrpF9J+7Wu6IzwIZM++WXF9eyrpi31HuWXHoE0QaKsQaKxA
 D41qgRBu
 ItEHEA6KEb60rW8nHw+FipFmyrWf/3IofBGVNlmCn58m+lvqRoyXdgpOz3ecja/WaQZT5TRSdQj1YgMw6E2PFUg1itWWsdb2dgxEvdS3qSTv74DWmXpTk5ll67eUf95mn5Rpvma6h7uWnmQOCB3Uw5XvGaSXRGAudvqy8wnPNLseX8DIsIUh76Rurw+KeUs6J/XVg3M/cMATh/SsvqVGTYTz1+bhyZODlPCOinKOlsfBpHziBscLrjIj1wtzalN/Y7N9W9eUQMuo4ZiMPPbk7MVuIkDDhFNgCCk3ehqVqCSrsN803+7dWYCxI4sqqoEQ6Xt9yD0pwrc/MpRrQe2GmVAe2qEqWy3e3V1FSmerJfAQyRyHP9ETpPnO/BV0FZ+Oap+xB89+0w+WBgrz+IZwB/A6lgZhsckVCBYGUWcGkV1VXKpcg/66fjbdkGuQBDwC1HesTuN8d9z2Wkwvsz+fXASs8lg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently pagefaults on anonymous pages support mthp, and hardware
features (such as arm64 contpte) can be used to store multiple ptes in
one TLB entry, reducing the probability of TLB misses. However, when the
process is forked and the cow is triggered again, the above optimization
effect is lost, and only 4KB is requested once at a time.

Therefore, make pagefault write-protect copy support mthp to maintain the
optimization effect of TLB and improve the efficiency of cow pagefault.

vm-scalability usemem shows a great improvement,
test using: usemem -n 32 --prealloc --prefault 249062617
(result unit is KB/s, bigger is better)

|    size     | w/o patch | w/ patch  |  delta  |
|-------------|-----------|-----------|---------|
| baseline 4K | 723041.63 | 717643.21 | -0.75%  |
| mthp 16K    | 732871.14 | 799513.18 | +9.09%  |
| mthp 32K    | 746060.91 | 836261.83 | +12.09% |
| mthp 64K    | 747333.18 | 855570.43 | +14.48% |

Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
---
 include/linux/huge_mm.h |   3 +
 mm/memory.c             | 174 ++++++++++++++++++++++++++++++++++++----
 2 files changed, 163 insertions(+), 14 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 2f190c90192d..d1ebbe0636fb 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -132,6 +132,9 @@ enum mthp_stat_item {
 	MTHP_STAT_SHMEM_ALLOC,
 	MTHP_STAT_SHMEM_FALLBACK,
 	MTHP_STAT_SHMEM_FALLBACK_CHARGE,
+	MTHP_STAT_WP_FAULT_ALLOC,
+	MTHP_STAT_WP_FAULT_FALLBACK,
+	MTHP_STAT_WP_FAULT_FALLBACK_CHARGE,
 	MTHP_STAT_SPLIT,
 	MTHP_STAT_SPLIT_FAILED,
 	MTHP_STAT_SPLIT_DEFERRED,
diff --git a/mm/memory.c b/mm/memory.c
index 8dd869b0cfc1..ea84c49cc975 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3344,6 +3344,21 @@ static inline int __wp_page_copy_user(struct page *dst, struct page *src,
 	return ret;
 }
 
+static inline int __wp_folio_copy_user(struct folio *dst, struct folio *src,
+				       unsigned int offset,
+				       struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	void __user *uaddr;
+
+	if (likely(src))
+		return copy_user_large_folio(dst, src, offset, vmf->address, vma);
+
+	uaddr = (void __user *)ALIGN_DOWN(vmf->address, folio_size(dst));
+
+	return copy_folio_from_user(dst, uaddr, 0);
+}
+
 static gfp_t __get_fault_gfp_mask(struct vm_area_struct *vma)
 {
 	struct file *vm_file = vma->vm_file;
@@ -3527,6 +3542,119 @@ vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf)
 	return ret;
 }
 
+static inline unsigned long thp_wp_suitable_orders(struct folio *old_folio,
+						   unsigned long orders)
+{
+	int order, max_order;
+
+	max_order = folio_order(old_folio);
+	order = highest_order(orders);
+
+	/*
+	 * Since need to copy content from the old folio to the new folio, the
+	 * maximum size of the new folio will not exceed the old folio size,
+	 * so filter the inappropriate order.
+	 */
+	while (orders) {
+		if (order <= max_order)
+			break;
+		order = next_order(&orders, order);
+	}
+
+	return orders;
+}
+
+static bool pte_range_readonly(pte_t *pte, int nr_pages)
+{
+	int i;
+
+	for (i = 0; i < nr_pages; i++) {
+		if (pte_write(ptep_get_lockless(pte + i)))
+			return false;
+	}
+
+	return true;
+}
+
+static struct folio *alloc_wp_folio(struct vm_fault *vmf, bool pfn_is_zero)
+{
+	struct vm_area_struct *vma = vmf->vma;
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	unsigned long orders;
+	struct folio *folio;
+	unsigned long addr;
+	pte_t *pte;
+	gfp_t gfp;
+	int order;
+
+	/*
+	 * If uffd is active for the vma we need per-page fault fidelity to
+	 * maintain the uffd semantics.
+	 */
+	if (unlikely(userfaultfd_armed(vma)))
+		goto fallback;
+
+	if (pfn_is_zero || !vmf->page)
+		goto fallback;
+
+	/*
+	 * Get a list of all the (large) orders below folio_order() that are enabled
+	 * for this vma. Then filter out the orders that can't be allocated over
+	 * the faulting address and still be fully contained in the vma.
+	 */
+	orders = thp_vma_allowable_orders(vma, vma->vm_flags,
+			TVA_IN_PF | TVA_ENFORCE_SYSFS, BIT(PMD_ORDER) - 1);
+	orders = thp_vma_suitable_orders(vma, vmf->address, orders);
+	orders = thp_wp_suitable_orders(page_folio(vmf->page), orders);
+
+	if (!orders)
+		goto fallback;
+
+	pte = pte_offset_map(vmf->pmd, vmf->address & PMD_MASK);
+	if (!pte)
+		return ERR_PTR(-EAGAIN);
+
+	/*
+	 * Find the highest order where the aligned range is completely readonly.
+	 * Note that all remaining orders will be completely readonly.
+	 */
+	order = highest_order(orders);
+	while (orders) {
+		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
+		if (pte_range_readonly(pte + pte_index(addr), 1 << order))
+			break;
+		order = next_order(&orders, order);
+	}
+
+	pte_unmap(pte);
+
+	if (!orders)
+		goto fallback;
+
+	/* Try allocating the highest of the remaining orders. */
+	gfp = vma_thp_gfp_mask(vma);
+	while (orders) {
+		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
+		folio = vma_alloc_folio(gfp, order, vma, addr);
+		if (folio) {
+			if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
+				count_mthp_stat(order, MTHP_STAT_WP_FAULT_FALLBACK_CHARGE);
+				folio_put(folio);
+				goto next;
+			}
+			folio_throttle_swaprate(folio, gfp);
+			return folio;
+		}
+next:
+		count_mthp_stat(order, MTHP_STAT_WP_FAULT_FALLBACK);
+		order = next_order(&orders, order);
+	}
+
+fallback:
+#endif
+	return folio_prealloc(vma->vm_mm, vma, vmf->address, pfn_is_zero);
+}
+
 /*
  * Handle the case of a page which we actually need to copy to a new page,
  * either due to COW or unsharing.
@@ -3558,6 +3686,7 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 	vm_fault_t ret;
 	bool pfn_is_zero;
 	unsigned long addr;
+	int nr_pages;
 
 	delayacct_wpcopy_start();
 
@@ -3568,16 +3697,26 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 		goto out;
 
 	pfn_is_zero = is_zero_pfn(pte_pfn(vmf->orig_pte));
-	new_folio = folio_prealloc(mm, vma, vmf->address, pfn_is_zero);
+	/* Returns NULL on OOM or ERR_PTR(-EAGAIN) if we must retry the fault */
+	new_folio = alloc_wp_folio(vmf, pfn_is_zero);
+	if (IS_ERR(new_folio))
+		return 0;
 	if (!new_folio)
 		goto oom;
 
-	addr = ALIGN_DOWN(vmf->address, PAGE_SIZE);
+	nr_pages = folio_nr_pages(new_folio);
+	addr = ALIGN_DOWN(vmf->address, nr_pages * PAGE_SIZE);
+	old_page -= (vmf->address - addr) >> PAGE_SHIFT;
 
 	if (!pfn_is_zero) {
 		int err;
 
-		err = __wp_page_copy_user(&new_folio->page, old_page, vmf);
+		if (nr_pages == 1)
+			err = __wp_page_copy_user(&new_folio->page, old_page, vmf);
+		else
+			err = __wp_folio_copy_user(new_folio, old_folio,
+					folio_page_idx(old_folio, old_page), vmf);
+
 		if (err) {
 			/*
 			 * COW failed, if the fault was solved by other,
@@ -3593,13 +3732,13 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 			delayacct_wpcopy_end();
 			return err == -EHWPOISON ? VM_FAULT_HWPOISON : 0;
 		}
-		kmsan_copy_pages_meta(&new_folio->page, old_page, 1);
+		kmsan_copy_pages_meta(&new_folio->page, old_page, nr_pages);
 	}
 
 	__folio_mark_uptodate(new_folio);
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
-				addr, addr + PAGE_SIZE);
+				addr, addr + nr_pages * PAGE_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
 
 	/*
@@ -3608,22 +3747,26 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 	vmf->pte = pte_offset_map_lock(mm, vmf->pmd, addr, &vmf->ptl);
 	if (unlikely(!vmf->pte))
 		goto release;
-	if (unlikely(vmf_pte_changed(vmf))) {
+	if (unlikely(nr_pages == 1 && vmf_pte_changed(vmf))) {
 		update_mmu_tlb(vma, addr, vmf->pte);
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 		goto release;
+	} else if (nr_pages > 1 && !pte_range_readonly(vmf->pte, nr_pages)) {
+		update_mmu_tlb_range(vma, addr, vmf->pte, nr_pages);
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+		goto release;
 	}
 
 	if (old_folio) {
 		if (!folio_test_anon(old_folio)) {
-			sub_mm_counter(mm, mm_counter_file(old_folio), 1);
-			add_mm_counter(mm, MM_ANONPAGES, 1);
+			sub_mm_counter(mm, mm_counter_file(old_folio), nr_pages);
+			add_mm_counter(mm, MM_ANONPAGES, nr_pages);
 		}
 	} else {
 		ksm_might_unmap_zero_page(mm, vmf->orig_pte);
 		inc_mm_counter(mm, MM_ANONPAGES);
 	}
-	flush_cache_range(vma, addr, addr + PAGE_SIZE);
+	flush_cache_range(vma, addr, addr + nr_pages * PAGE_SIZE);
 	entry = folio_mk_pte(new_folio, vma->vm_page_prot);
 	entry = pte_sw_mkyoung(entry);
 	if (unlikely(unshare)) {
@@ -3642,12 +3785,14 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 	 * that left a window where the new PTE could be loaded into
 	 * some TLBs while the old PTE remains in others.
 	 */
-	ptep_clear_flush_range(vma, addr, vmf->pte, 1);
+	ptep_clear_flush_range(vma, addr, vmf->pte, nr_pages);
+	folio_ref_add(new_folio, nr_pages - 1);
+	count_mthp_stat(folio_order(new_folio), MTHP_STAT_WP_FAULT_ALLOC);
 	folio_add_new_anon_rmap(new_folio, vma, addr, RMAP_EXCLUSIVE);
 	folio_add_lru_vma(new_folio, vma);
 	BUG_ON(unshare && pte_write(entry));
-	set_ptes(mm, addr, vmf->pte, entry, 1);
-	update_mmu_cache_range(vmf, vma, addr, vmf->pte, 1);
+	set_ptes(mm, addr, vmf->pte, entry, nr_pages);
+	update_mmu_cache_range(vmf, vma, addr, vmf->pte, nr_pages);
 	if (old_folio) {
 		/*
 		 * Only after switching the pte to the new page may
@@ -3671,7 +3816,7 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 		 * mapcount is visible. So transitively, TLBs to
 		 * old page will be flushed before it can be reused.
 		 */
-		folio_remove_rmap_ptes(old_folio, old_page, 1, vma);
+		folio_remove_rmap_ptes(old_folio, old_page, nr_pages, vma);
 	}
 
 	/* Free the old page.. */
@@ -3682,7 +3827,8 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 	mmu_notifier_invalidate_range_end(&range);
 
 	if (new_folio)
-		folio_put_refs(new_folio, 1);
+		folio_put_refs(new_folio, page_copied ? nr_pages : 1);
+
 	if (old_folio) {
 		if (page_copied)
 			free_swap_cache(old_folio);
-- 
2.50.1


