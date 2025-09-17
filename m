Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B3CACAC599
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 12:57:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68ADA8E001A; Wed, 17 Sep 2025 08:57:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 640DD8E0013; Wed, 17 Sep 2025 08:57:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5792E8E001A; Wed, 17 Sep 2025 08:57:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 405AE8E0013
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:57:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 03F8DB9E3F
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:57:41 +0000 (UTC)
X-FDA: 83898743964.30.A32FB06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3B791100014
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:57:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MDhxPTlL;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758113860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rysuZTNXGlhJ/pNo9I//zN6bxCAYHhYiKx0dmE9O/jQ=;
	b=TqDOIS/eRQfkrksRGxKHdakJWGZKVAtUMb0slFZKYPvdAr0WusaHdvvP+eKyKpRxuRg5Cu
	pHvlx2Si3rrCIhwkQTIswcGBObIYWMwr3Lu5iCzpJ2IEEeVsZsrlkS97MTDGQ+ro3KW8K7
	cW2+X3mthwuoi2Ok4X3W9JUU4/bZoPU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MDhxPTlL;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758113860; a=rsa-sha256;
	cv=none;
	b=Ykk0Z6DM6PeXncda0T47O8g4k7rW4JyaBoLM2063E7Qo1qGICI58B6h3/0ZZ53edaVa7F2
	Sx+Ka/qRA+hnDBT4FEgm6kSavbtp5QvoiIu7uQEe1t1hLiCtx7xKRUGUymgbMTspEF0hpT
	PZL111FwrZ9awVKnVU7VinBFJEYt8Mk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B05C44E68;
	Wed, 17 Sep 2025 12:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707FEC4CEFA;
	Wed, 17 Sep 2025 12:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758113859;
	bh=r+p/fW1qMMIwpqKIwYaP72h2rsOOsXIYd5AWK52PFjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MDhxPTlLBJEX7J3Lii/V9VX413VtE8eVKCNeBKb26X7SilRFKRMeS6RdKznIrZIwd
	 2mLPCzdmU41qnSN6vZ8XmntqKfRPB5hie55/t133keMIx5R0WSDyoxoBa5PYQHa+DQ
	 bS9al/X6rX1zlUQVFoHb2Jy7zSiDRVGyOHLvPX8WDleZw1R5t2KlSKU8NRCCzqyqjt
	 5mmwc8Ymr+ZlrYQ039KVM7csj2grE2DOVORw1MpBZjs+VzdwvGmfeRs6AQd52RfqXq
	 WSJd2tVRXZyqY808XSja7d79EhFySiEkJ6BjBW8MTcFVCDSEzQuEfWTMeSz/go9twm
	 i9+PHR6yWbvxw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Chris Li <chrisl@kernel.org>,
	Jason Miu <jasonmiu@google.com>
Cc: linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v2 2/2] kho: make sure page being restored is actually from KHO
Date: Wed, 17 Sep 2025 14:56:54 +0200
Message-ID: <20250917125725.665-2-pratyush@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917125725.665-1-pratyush@kernel.org>
References: <20250917125725.665-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rb7b6sia1pwq5bky3wqxckh739wowsc5
X-Rspam-User: 
X-Rspamd-Queue-Id: 3B791100014
X-Rspamd-Server: rspam04
X-HE-Tag: 1758113860-395801
X-HE-Meta: U2FsdGVkX1//wdoEh1RxwDNa5hhycg1IZILlTjO+54A4ZkwtJ54HKYfmiSDY244FSDXtqy7A69ahb16KeDSuCNKAM4xMeIC2+bDFzI5etRtb7M8z/y8OUo2Q6AuCV3W39ah0KJY2yHDeQq5DGfM6cLSpNIenAyailxcEvP46dwYMxnvtcsGU23tbJnsV8PKC8kUc/NOnycYZKmn07ZJYGeaaywHQyVxK9Jv05M8oDtvDQ4+ofCv7RNth4fvrCIlcf8W2ajaLWljrlwe4d8bPnsqfsLpmy3OL5uLaSlWoCGEVonh0npuERba4smNCmnDSLJhDeL6N/J0Wpu+ImOcsApZhjYACloXAeFn6KxlxV2PNlRbmJiRGJDcUaGT9M0qDNuybb7KjvxPWv3bUNPcXhTuo7lH29ZqN1oyHQpdrlGVntsyQO+pSw67aX/eMsLEmHdx9DcViYRc/uo1BA+1sjZ2kCn2g2VzZWcmog+vM29c4oL5xCITUkalPUs1Oc02Iryfo3ViVUf9gjDRYu0y2bCEwU6QD5UOQy/TUgq5UHqB/LKrGcqqtATYaGmiiBqZyqCQmcUl81zuo2tvAvcgxx9Ce2UMx+XISvt1iO0EkrhXYOV6uDuNP2oHmWaO37faWC9R6QWvbzYXAD87gmxhy+enKyKllZ5FbxFc1IlsNu0J/hVjuLxYHTaK8Xc4S35c6vOjlBEVY+gdTIzOOPmiR2oJsJXYg13J5ZdfMr5k2KvL9d9cCoL/jOD2lZUnjfFjxO27WxH9SGjq2gj7XGmeBem2ilv/YvVENbVIZuyxoVIEXGuzHbbaqSdawG21NTKiq7Kfx3eEHoct/LI6FFkU7C5hFXT0RvfUtzb7efLdZWFSyxee32H0aML+zpbgXWxSkQHHOkMk+nRhF3NG0BxIjmqwdgEvZbDW7VS615VSWAuJ9xolhdL7etNnNSJGlL0oOJCeGNdpAZC+Mf8u95R7
 GkyHmoSq
 XTZFwIqVV2RFdC7vnPtH0P3TJ+7qSShMnmD6w8udV7JEEzzlu85lruTc5KYIk9WYt0GSkSg+wy5fuNiJlAY6sZ+uicGfz3EU/pc5p/r/hc1D+I1eRnwF+Sn0brO8ht/v0uzViIKLL8banB75D04pzOM1pXD1WRKd2tcXzmFCpUnPP+00gQjW763TIuT6PhEQ0Q9Qi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When restoring a page, no sanity checks are done to make sure the page
actually came from a kexec handover. The caller is trusted to pass in
the right address. If the caller has a bug and passes in a wrong
address, an in-use page might be "restored" and returned, causing all
sorts of memory corruption.

Harden the page restore logic by stashing in a magic number in
page->private along with the order. If the magic number does not match,
the page won't be touched. page->private is an unsigned long. The union
kho_page_info splits it into two parts, with one holding the order and
the other holding the magic number.

Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
---

Notes:
    Changes in v2:
    
    - Add a WARN_ON_ONCE() if order or magic is invalid.
    - Add a comment explaining why the magic check also implicitly makes
      sure phys is order-aligned.
    - Clear page private to make sure later restores of the same page error
      out.
    - Move the checks to kho_restore_page() since patch 1 now moves sanity
      checking to it.

 kernel/kexec_handover.c | 41 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 69cab82abaaef..911fda8532b2e 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -32,6 +32,22 @@
 #define PROP_PRESERVED_MEMORY_MAP "preserved-memory-map"
 #define PROP_SUB_FDT "fdt"
 
+#define KHO_PAGE_MAGIC 0x4b484f50U /* ASCII for 'KHOP' */
+
+/*
+ * KHO uses page->private, which is an unsigned long, to store page metadata.
+ * Use it to store both the magic and the order.
+ */
+union kho_page_info {
+	unsigned long page_private;
+	struct {
+		unsigned int order;
+		unsigned int magic;
+	};
+};
+
+static_assert(sizeof(union kho_page_info) == sizeof(((struct page *)0)->private));
+
 static bool kho_enable __ro_after_init;
 
 bool kho_is_enabled(void)
@@ -186,16 +202,24 @@ static int __kho_preserve_order(struct kho_mem_track *track, unsigned long pfn,
 static struct page *kho_restore_page(phys_addr_t phys)
 {
 	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
-	unsigned int nr_pages, order;
+	union kho_page_info info;
+	unsigned int nr_pages;
 
 	if (!page)
 		return NULL;
 
-	order = page->private;
-	if (order > MAX_PAGE_ORDER)
+	info.page_private = page->private;
+	/*
+	 * deserialize_bitmap() only sets the magic on the head page. This magic
+	 * check also implicitly makes sure phys is order-aligned since for
+	 * non-order-aligned phys addresses, magic will never be set.
+	 */
+	if (WARN_ON_ONCE(info.magic != KHO_PAGE_MAGIC || info.order > MAX_PAGE_ORDER))
 		return NULL;
-	nr_pages = (1 << order);
+	nr_pages = (1 << info.order);
 
+	/* Clear private to make sure later restores on this page error out. */
+	page->private = 0;
 	/* Head page gets refcount of 1. */
 	set_page_count(page, 1);
 
@@ -203,8 +227,8 @@ static struct page *kho_restore_page(phys_addr_t phys)
 	for (unsigned int i = 1; i < nr_pages; i++)
 		set_page_count(page + i, 0);
 
-	if (order > 0)
-		prep_compound_page(page, order);
+	if (info.order > 0)
+		prep_compound_page(page, info.order);
 
 	adjust_managed_page_count(page, nr_pages);
 	return page;
@@ -341,10 +365,13 @@ static void __init deserialize_bitmap(unsigned int order,
 		phys_addr_t phys =
 			elm->phys_start + (bit << (order + PAGE_SHIFT));
 		struct page *page = phys_to_page(phys);
+		union kho_page_info info;
 
 		memblock_reserve(phys, sz);
 		memblock_reserved_mark_noinit(phys, sz);
-		page->private = order;
+		info.magic = KHO_PAGE_MAGIC;
+		info.order = order;
+		page->private = info.page_private;
 	}
 }
 
-- 
2.47.3


