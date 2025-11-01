Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64300CCFA00
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 14:23:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58EC98E0094; Sat,  1 Nov 2025 10:23:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56B918E008A; Sat,  1 Nov 2025 10:23:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 455288E0094; Sat,  1 Nov 2025 10:23:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2F2C48E008A
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 10:23:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CC4AC891B3
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:23:39 +0000 (UTC)
X-FDA: 84062256558.04.0A90DAD
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id E9FA44000D
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:23:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=gUJxISeP;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762007018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rpi1Z/2DyRVkKnxEHwYxahLzSNsmpU8z1Poo2lMWpYA=;
	b=8hpxu8826WFd7KAN3obHPnurgxczj0H+TvrYaT41wrLubP2P9t5eXnlXW9iqKvHmyYTjkI
	gThUs9RzxoYwCU6xoDfvVWYVtWgimKHPygFoe5+d5MShGk39p2bEOgYj9vpbb++XGt5HTM
	wbnvd5gWMIw92Hw+BbU62X43nuL3FHI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=gUJxISeP;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762007018; a=rsa-sha256;
	cv=none;
	b=cvaTK0dStmiB6lxqq4NKNub5qKOzOY8+qovEpH3YMBieBA2lduwdSZ679szORoCgBkJo6h
	HavcxAaVP/v71kIaRMbyENnPaq89BRFib1dRPY/bI+8CEkgsJ0HyOjvvzQDttqZw2xWZEn
	D9544PqrXFlZL7zPg4P7STa+Ydw3GfY=
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-54bbc2a8586so1214909e0c.2
        for <linux-mm@kvack.org>; Sat, 01 Nov 2025 07:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762007017; x=1762611817; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rpi1Z/2DyRVkKnxEHwYxahLzSNsmpU8z1Poo2lMWpYA=;
        b=gUJxISePjxzXfc9Qpbap5MD+W/cvkUYtLicxriQrT6FKyepyL2spo07IKCOr8UuMlc
         LNuY5RzLLr81rNdQFnnDwMcOWvCPvNFnyWr6PXLefmuPllpcDemtHfR7N8X9Gd5Mv7pk
         VQydrdFtFPWE/FH1Lct/teAY7spAzPE9SB5HVDUVvAvCKzow8JEudxggswdXSf2tKQ+T
         TEJ1StzDyKxL1LhG0kIKd+9s14pZ8GHeZYc0d2DmPTWiWh4Wn3opSdHa02ZvdBbPvNVm
         Hposc0lGxfcb5pmwDNCxgx7Te7abqRlKo9umG1w5FPgbWpkgGt7iguSec6JpmbkYOYV9
         sccw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762007017; x=1762611817;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rpi1Z/2DyRVkKnxEHwYxahLzSNsmpU8z1Poo2lMWpYA=;
        b=YbmEsH9u4T5NoedpuaeZgJ/a13Fcczt2BJZfmK5Rq1PiU2wESTKNoHUaNSyyyCECWO
         ib39VGbPSX02jVu1RCsL/9ki7KjlYVzRpwLDtzMr4AU4jf+bpJWXNX4i69FQtX/aVcx2
         0l9WsHV+rIWKYOlIDd0jsAOBC9C84Qb2auWHAlS4Pg73GVJP9Cnvi4uVg7NYmOJY4tdR
         8v7oIozVL/y4+j/jZWVpMMwd2tgMbaJNw5TAxjuhr+f3Pc2ZdGNxaBiNFh05kGekAOkd
         H1L0d+v1wUJsdpP6/B/BuqSUf8YAWLHl+goAf+Y31UDNFGVbp68s9Ky45zyCgYc8E83m
         /Lcw==
X-Forwarded-Encrypted: i=1; AJvYcCUnEprVuAbkvQvDf9iSYaeXlqF97n7r6a1hLTzOYsgO7ZgjEv2Dp2HDmD09ywK2RcGBQ6rAiOvM3g==@kvack.org
X-Gm-Message-State: AOJu0Yz3FllWgxWUwi9YDziFw0GPZWkxT8emxNAJvPiN/DOP7THeGABs
	BKodB8oLzmnbjB1y69RhWyBOHGt68UsMziNGvSP861Hhby3nTZzIAd3TaSbISEjOmWI=
X-Gm-Gg: ASbGncuRa07NIzEDvtJWH9UCW8QuGrXqW/1NQvfgpb4xT1Pmb7x2O6ZoWiWlFi/X8gs
	/I1d2Uo2Gt/27616cYmXn5ZEodtRoDwwvD/x/u6lzc28dLoOm10BAr79dnDFTa2YZe7lFPSfnxx
	zh8uGttvVGOxyCycd+5gwjqhNyry0iDTRwkz3+UqEBHwD6VGDQyHR20MVcdKH9vjEUL8Ysp1cU6
	nMcRcMKPsnf7HqYxlMe2QB8hgfWpj3bA/Z1FIna36KmfQteYZG6m35wzJuBaRTNTJXCWI/v2AzT
	fuAn/8NT2S2d9bMOktqqzpjGOd5xqnvUFrZ/fiQsajny5xKEZtdnHx+liPYxpMe5oZcsfKgN1jo
	yQINNYEYcl2zysxBipBFKm/nUpvBSFFzmkgKhKauYHWbelExGcuzZh/iEIj3yT2qsNT/MY4plO8
	SrMU3VgS6kmEL6yoTUn/yJc1bXsGlx8E0cJwBSbQoJSXDYYpkeaaHyoQly2u4bFqOntZfygFE=
X-Google-Smtp-Source: AGHT+IEMu4ntr1ofdj6Iu9NM0kSW7ODJm45DTBvuQgzydqOGurQZxTtybUZHECZqoshEfoiQa/oT9Q==
X-Received: by 2002:a05:6122:4591:b0:558:251:f0e8 with SMTP id 71dfb90a1353d-5593e4ef501mr2376540e0c.11.1762007016891;
        Sat, 01 Nov 2025 07:23:36 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-559449647e0sm1776242e0c.3.2025.11.01.07.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Nov 2025 07:23:35 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	brauner@kernel.org,
	corbet@lwn.net,
	graf@amazon.com,
	jgg@ziepe.ca,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	masahiroy@kernel.org,
	ojeda@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	rppt@kernel.org,
	tj@kernel.org,
	yanjun.zhu@linux.dev
Subject: [PATCH v9 3/9] kho: add interfaces to unpreserve folios, page ranges, and vmalloc
Date: Sat,  1 Nov 2025 10:23:19 -0400
Message-ID: <20251101142325.1326536-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
In-Reply-To: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
References: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E9FA44000D
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: d6xpf4nu6z5knpwfcey56ho6o97gz7jb
X-HE-Tag: 1762007017-774010
X-HE-Meta: U2FsdGVkX1/uJjREz8d0fo2/p2nk+1hUSIs19YNZ8vntePuoxmaUoOh3qNgYm4VpBggpiDEGxrKXkjp/p1+hLFQjysF4imnwdOvhlgFGrIDGUmVj3xXfn4ON14exv51Xo74CA9fkaAz93dcr7TLqIcPnwhF0m/gPLaCgM1mTRiwOA2kZApnijiL4BwIGtGJ3Bi2XHZXl6qQ5zkDZAYapMC5tPPCuXapRSdQpcosa3X2RCDI2N2fKl+dNoy0FM2vXWiasbKyRWvm49a/curdLc8X5BZ4ROiEi5xusoJh/AJYVWnSddnD5avQ1kM8s4pihjmy6ly10YgNpllMZQXlbYhhopbWcJ6hfQ33fRNXQGjloC1jFmnkCQGJvAg6S+PCp8dFORqphKxBzilBmJ8/YGQqVylthTTMas7OC3z0l88TP3xr9gJ+T/fc345z48X1tz3JpvIKIYz1du7BLkGeLzcIQ/OIP08fGHiO83H3NhuP7kRB+eZfnZXKNMDpxVJYY6TY62cImG5UTcOWsgCL2DbCd2a1V2Goat+5eQMTSBGh3sVwEmzTLqPzyJkqH24eYo4uMzDje78ltqD08tnqyyAByAqztsLjuFg4ELnBhtebfwH6jqiVPqOxkurytq+Ka7sCku9Dpjr8aFraFCMMaPaUD4R9PADPXuGNms/BstMDb8o7hHCdKBWntTMz3G+/QmiU7M2owo2wL2t4c8njNJhnzt5I8nZ7aiyTA+vwyuampt3GVn+6mTJ+OSVZL3pJH5D6G9mes0kZkdnDg2mlaS8Rgtok4399a9t+aZxEb79wAw8/HEMbnlWYiX1Vb5I7KxQ3gc7AKHoMMw6zfDzeWqwgOZqZjNvs/FW77HppO8TBX4MpsnPtlCgqTCrTojwG48FOTCoRaLM93ABRghBafN+14m58V1vYCr8UbvOwYh8FAvrsoqPHqy5CjRQ+dqFf7lR6U+c/8S3BYcBtL69o
 e0EWv3Rt
 K2CyNJTz/zuHVF0fWEugS8AwsjbtNNDdAwdVLXzlrbVkjtgUPvL1mGCOfmBVvSpzc3d9sksmnbXh2IZca6ph23OosN2Ipo1VxcWPqhHXbfFZcWO82dUiQ6l1kAORHXL1TMtR8vTPCiMc02ttv6O6URclCrY0Q3ae4TkJ4Wyx2g42jbKTuluxtwBGjZP1CQXQ3BVAt51hbCbKjZnFhl+BkKHWlKtOSpCv8OR2fPTugEhqW0q4CSCv9551mI43LMx2rOaE6C2ZnFy4R8MmYexHSzWTpy04J3nWkNDGMQIR4JREMCf8D4Amtm/2kwvQqobxi5nkducyox0LyLVSUuGqVly+HgYVtIYbWeRtiYwbQ8+MJYcrvCHgO232uL5pTvmS3OXBb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow users of KHO to cancel the previous preservation by adding the
necessary interfaces to unpreserve folio, pages, and vmallocs.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/kexec_handover.h |  18 ++++++
 kernel/kexec_handover.c        | 104 ++++++++++++++++++++++++++++-----
 2 files changed, 109 insertions(+), 13 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 0d860d793b66..80ece4232617 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -43,8 +43,11 @@ bool kho_is_enabled(void);
 bool is_kho_boot(void);
 
 int kho_preserve_folio(struct folio *folio);
+int kho_unpreserve_folio(struct folio *folio);
 int kho_preserve_pages(struct page *page, unsigned int nr_pages);
+int kho_unpreserve_pages(struct page *page, unsigned int nr_pages);
 int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation);
+int kho_unpreserve_vmalloc(struct kho_vmalloc *preservation);
 struct folio *kho_restore_folio(phys_addr_t phys);
 struct page *kho_restore_pages(phys_addr_t phys, unsigned int nr_pages);
 void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
@@ -72,17 +75,32 @@ static inline int kho_preserve_folio(struct folio *folio)
 	return -EOPNOTSUPP;
 }
 
+static inline int kho_unpreserve_folio(struct folio *folio)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int kho_preserve_pages(struct page *page, unsigned int nr_pages)
 {
 	return -EOPNOTSUPP;
 }
 
+static inline int kho_unpreserve_pages(struct page *page, unsigned int nr_pages)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int kho_preserve_vmalloc(void *ptr,
 				       struct kho_vmalloc *preservation)
 {
 	return -EOPNOTSUPP;
 }
 
+static inline int kho_unpreserve_vmalloc(struct kho_vmalloc *preservation)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline struct folio *kho_restore_folio(phys_addr_t phys)
 {
 	return NULL;
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 82137eba1474..c514b300ebe6 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -157,26 +157,33 @@ static void *xa_load_or_alloc(struct xarray *xa, unsigned long index)
 	return no_free_ptr(elm);
 }
 
-static void __kho_unpreserve(struct kho_mem_track *track, unsigned long pfn,
-			     unsigned long end_pfn)
+static void __kho_unpreserve_order(struct kho_mem_track *track, unsigned long pfn,
+				   unsigned int order)
 {
 	struct kho_mem_phys_bits *bits;
 	struct kho_mem_phys *physxa;
+	const unsigned long pfn_high = pfn >> order;
 
-	while (pfn < end_pfn) {
-		const unsigned int order =
-			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
-		const unsigned long pfn_high = pfn >> order;
+	physxa = xa_load(&track->orders, order);
+	if (!physxa)
+		return;
 
-		physxa = xa_load(&track->orders, order);
-		if (!physxa)
-			continue;
+	bits = xa_load(&physxa->phys_bits, pfn_high / PRESERVE_BITS);
+	if (!bits)
+		return;
 
-		bits = xa_load(&physxa->phys_bits, pfn_high / PRESERVE_BITS);
-		if (!bits)
-			continue;
+	clear_bit(pfn_high % PRESERVE_BITS, bits->preserve);
+}
+
+static void __kho_unpreserve(struct kho_mem_track *track, unsigned long pfn,
+			     unsigned long end_pfn)
+{
+	unsigned int order;
+
+	while (pfn < end_pfn) {
+		order = min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
 
-		clear_bit(pfn_high % PRESERVE_BITS, bits->preserve);
+		__kho_unpreserve_order(track, pfn, order);
 
 		pfn += 1 << order;
 	}
@@ -745,6 +752,30 @@ int kho_preserve_folio(struct folio *folio)
 }
 EXPORT_SYMBOL_GPL(kho_preserve_folio);
 
+/**
+ * kho_unpreserve_folio - unpreserve a folio.
+ * @folio: folio to unpreserve.
+ *
+ * Instructs KHO to unpreserve a folio that was preserved by
+ * kho_preserve_folio() before. The provided @folio (pfn and order)
+ * must exactly match a previously preserved folio.
+ *
+ * Return: 0 on success, error code on failure
+ */
+int kho_unpreserve_folio(struct folio *folio)
+{
+	const unsigned long pfn = folio_pfn(folio);
+	const unsigned int order = folio_order(folio);
+	struct kho_mem_track *track = &kho_out.track;
+
+	if (kho_out.finalized)
+		return -EBUSY;
+
+	__kho_unpreserve_order(track, pfn, order);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kho_unpreserve_folio);
+
 /**
  * kho_preserve_pages - preserve contiguous pages across kexec
  * @page: first page in the list.
@@ -789,6 +820,33 @@ int kho_preserve_pages(struct page *page, unsigned int nr_pages)
 }
 EXPORT_SYMBOL_GPL(kho_preserve_pages);
 
+/**
+ * kho_unpreserve_pages - unpreserve contiguous pages.
+ * @page: first page in the list.
+ * @nr_pages: number of pages.
+ *
+ * Instructs KHO to unpreserve @nr_pages contiguous pages starting from @page.
+ * This must be called with the same @page and @nr_pages as the corresponding
+ * kho_preserve_pages() call. Unpreserving arbitrary sub-ranges of larger
+ * preserved blocks is not supported.
+ *
+ * Return: 0 on success, error code on failure
+ */
+int kho_unpreserve_pages(struct page *page, unsigned int nr_pages)
+{
+	struct kho_mem_track *track = &kho_out.track;
+	const unsigned long start_pfn = page_to_pfn(page);
+	const unsigned long end_pfn = start_pfn + nr_pages;
+
+	if (kho_out.finalized)
+		return -EBUSY;
+
+	__kho_unpreserve(track, start_pfn, end_pfn);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kho_unpreserve_pages);
+
 struct kho_vmalloc_hdr {
 	DECLARE_KHOSER_PTR(next, struct kho_vmalloc_chunk *);
 };
@@ -949,6 +1007,26 @@ int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation)
 }
 EXPORT_SYMBOL_GPL(kho_preserve_vmalloc);
 
+/**
+ * kho_unpreserve_vmalloc - unpreserve memory allocated with vmalloc()
+ * @preservation: preservation metadata returned by kho_preserve_vmalloc()
+ *
+ * Instructs KHO to unpreserve the area in vmalloc address space that was
+ * previously preserved with kho_preserve_vmalloc().
+ *
+ * Return: 0 on success, error code on failure
+ */
+int kho_unpreserve_vmalloc(struct kho_vmalloc *preservation)
+{
+	if (kho_out.finalized)
+		return -EBUSY;
+
+	kho_vmalloc_free_chunks(preservation);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kho_unpreserve_vmalloc);
+
 /**
  * kho_restore_vmalloc - recreates and populates an area in vmalloc address
  * space from the preserved memory.
-- 
2.51.1.930.gacf6e81ea2-goog


