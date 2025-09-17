Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFA32CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 17:40:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36EBA280003; Wed, 17 Sep 2025 13:40:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31EA9280002; Wed, 17 Sep 2025 13:40:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20DB6280003; Wed, 17 Sep 2025 13:40:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 04600280002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:40:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ABD35C05B6
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:40:50 +0000 (UTC)
X-FDA: 83899457460.08.82BE844
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0D865100005
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:40:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YWNVC2+N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758130849; a=rsa-sha256;
	cv=none;
	b=5uivtVjQ1a5TCu9QvaA65+1PCBWroqIUzXhC80ZfbXrcx4B4AY9gnoYEazVIHWjgQy2rT8
	9+/LwClCIDla46Z3KGJmTMe4QMnga7s5LULv7k8wdNCPKnJOMLjFArHanoe/9BHxcqC93d
	WnkV9fbUzNAu9ZD4JL6wCTEU91WqLF0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YWNVC2+N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758130849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oxL33bY1eMpOBypry9V61ZfTJHnEZnydPGdbjs5GTFA=;
	b=UAecJQbm8WCrNMYvZ0QXXagn81sNQeqr/VZFU8nHDFJdlpvwg69y7BDJjQWhPgadvMYWUN
	IRtj6hXqM9NnyvRvPUZwNPiCiSmccS37yzLc5P/hzIp0d2pdWg5HHk/EJcVLjyHsRyj+Cw
	7+7B+FPrugAcfdPX6JLL0kO25C09Gn8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 81F2B60245;
	Wed, 17 Sep 2025 17:40:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD38C4CEE7;
	Wed, 17 Sep 2025 17:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758130848;
	bh=q/t3uKKPwUDe/VS493c2y7ty/sgLNnbkDT1wsgUidLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YWNVC2+NhhjJf+hD1kotVftCFqdoDZkFLt5It7TUxiKYJRf3UOOfk0X3WW8ki+GiX
	 KkU1fJdKFjt9BzSmWLeuCYwjt+e5EmLTt0jbv4eGIc44Ha62Nipr9/l+cYYwTIZ7pX
	 tItwXA4/CVyvwh6t9CLCgV2Kao+l46eSUIVQisWIuqc2ovOv6znBhwjiRvCvTE7BGa
	 W/bqshWp76kkI/KnmtBOrXYSUndLrW+96geZMRXLsVFn198LIzSNc1qw+8aBnnS/oX
	 xEVuk4XZ9Jrn29sG+OgcUNu9/KuS4NoQpBVAWeqqZibjpWtG7MXZEQWmZkcdmZbwgC
	 C0mR3JWJch7gQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Graf <graf@amazon.com>,
	Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Chris Li <chrisl@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/4] kho: replace kho_preserve_phys() with kho_preserve_pages()
Date: Wed, 17 Sep 2025 20:40:31 +0300
Message-ID: <20250917174033.3810435-3-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250917174033.3810435-1-rppt@kernel.org>
References: <20250917174033.3810435-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0D865100005
X-Stat-Signature: 31iywqxsmiaah5mkgpdsxeaoh39y94zu
X-Rspam-User: 
X-HE-Tag: 1758130848-117117
X-HE-Meta: U2FsdGVkX1/Q8uBkhhu5UB2Cy8d+pdEzhlCet8ciVXmDilLcgqnagXD8pahi4eKHUE0Tcy5foHdkYxyVI/DbTcGMqSDxM65pNfqoFfFGTOs33raOHUlagwj2uefrzVUTBdhu7u9aGOk7ef81LsSTNFa2A1lZv4/N4ZdELKh70LnFWQ7RxxB1pFUYq9M8sTX4O4K8VdDlEf3ZPbKi2VCFZ3/04fNm04RPQZocWg3Un6gqALfz1u/r4djYAncN+s4I/zkTn62i86FK+S+uyqFv9g4/3wqmtwpSB98vAzoMVBzWsRr+kX1CKM5BtdfQcRNmUQ8cTbYLdHozSasYxba54yDpdQ57jkFjkh+bbxODVYYEs4f7YWb+ko/GShks/ZHrnh930OZqQSOIkGEmeLGA8ZjpvI1jnNoL9RWNESWIQfl4l7t08ufvX9AQn+kxIlwa6zTyyn45DAvvVkkLzhty8nTmlXTiHE7Q/VCwMCdCG6B1MRLT5dWlPwtCwWINN6ZBvdKCbY+uG2xR06fMQ7qXnewhmxdiNlxVndGg6Gt/0W4BGDgdKq7C0Tx6KPdS+vPKZ4f40MwFB5mNSC3mVzkCqB9o78k4owGSWRuUa95mBK8wW/Onwn4oUjQ4qHwoHIewm6PKEvmWZU3T9q//Q/gLTP9IFLrGU5/nVuZ31Fhj/PNJrIPGFkh+xlZnglOTj/GmOB3TuyP31s/N4GW5RFPOlPVw51q4GOjOGfYuBpyQEaIHorrSSwjEGP6dRqRdQXv2FaGIYLYQ12MOsRWCjHWeY6IGmTjCEDepbB/tGfc0f1MKkspXpUxlCLV5i0us4gviFZHfaK1FB0aBmn0Opqx7nC1kNz2HvdYTSg6jCAEghkwHKbMMDNt9YxmFQtaTKfep8DrM+M7gOP54XRRLqc92VYZHYCxPCwGw8PJcM1wK1tosMkeBKqSgC8E+LuxtVyGTtJHdZHIL9lUa94IYbKQ
 pLtDl78U
 wq8farOYain9ezOTw+AzQxT1aUg9E3rpB41RvrE3zfWCeMmqSaoTcqGTG7GR2OdBv515VoCbuwdm7ckMKeZ+xBpmJkKEQR9KOrRWaWi/NypXAFHv1zGaCGzR7TtNKlsOWIGMnc0CCwuxLHuHgUiqI9T8cotfY/HLZixbJeT9Jly/o8WloT93GReJTY3E/PF1E8FSxa0pAQUq/JqWTQkymZt4fgG6zX/re3en7cvoLk/shGoaPVFEgk/td7D3X8cdB49Rebhapg1R4pc0Qdt7KRPE8y6ENR+wgT5pHvoSbMHEWhiEs7rQIzU0zUa1Rk2FItZOW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

to make it clear that KHO operates on pages rather than on a random
physical address.

The kho_preserve_pages() will be also used in upcoming support for
vmalloc preservation.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/kexec_handover.h |  5 +++--
 kernel/kexec_handover.c        | 25 +++++++++++--------------
 mm/memblock.c                  |  4 +++-
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 348844cffb13..cc5c49b0612b 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -18,6 +18,7 @@ enum kho_event {
 
 struct folio;
 struct notifier_block;
+struct page;
 
 #define DECLARE_KHOSER_PTR(name, type) \
 	union {                        \
@@ -42,7 +43,7 @@ struct kho_serialization;
 bool kho_is_enabled(void);
 
 int kho_preserve_folio(struct folio *folio);
-int kho_preserve_phys(phys_addr_t phys, size_t size);
+int kho_preserve_pages(struct page *page, unsigned int nr_pages);
 struct folio *kho_restore_folio(phys_addr_t phys);
 int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
@@ -65,7 +66,7 @@ static inline int kho_preserve_folio(struct folio *folio)
 	return -EOPNOTSUPP;
 }
 
-static inline int kho_preserve_phys(phys_addr_t phys, size_t size)
+static inline int kho_preserve_pages(struct page *page, unsigned int nr_pages)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index f421acc58c1f..3ad59c5f9eaa 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -698,26 +698,23 @@ int kho_preserve_folio(struct folio *folio)
 EXPORT_SYMBOL_GPL(kho_preserve_folio);
 
 /**
- * kho_preserve_phys - preserve a physically contiguous range across kexec.
- * @phys: physical address of the range.
- * @size: size of the range.
+ * kho_preserve_pages - preserve contiguous pages across kexec
+ * @page: first page in the list.
+ * @nr_pages: number of pages.
  *
- * Instructs KHO to preserve the memory range from @phys to @phys + @size
- * across kexec.
+ * Preserve a contiguous list of order 0 pages. Must be restored using
+ * kho_restore_page() on each order 0 page.
  *
  * Return: 0 on success, error code on failure
  */
-int kho_preserve_phys(phys_addr_t phys, size_t size)
+int kho_preserve_pages(struct page *page, unsigned int nr_pages)
 {
-	unsigned long pfn = PHYS_PFN(phys);
+	struct kho_mem_track *track = &kho_out.ser.track;
+	const unsigned long start_pfn = page_to_pfn(page);
+	const unsigned long end_pfn = start_pfn + nr_pages;
+	unsigned long pfn = start_pfn;
 	unsigned long failed_pfn = 0;
-	const unsigned long start_pfn = pfn;
-	const unsigned long end_pfn = PHYS_PFN(phys + size);
 	int err = 0;
-	struct kho_mem_track *track = &kho_out.ser.track;
-
-	if (!PAGE_ALIGNED(phys) || !PAGE_ALIGNED(size))
-		return -EINVAL;
 
 	while (pfn < end_pfn) {
 		const unsigned int order =
@@ -737,7 +734,7 @@ int kho_preserve_phys(phys_addr_t phys, size_t size)
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(kho_preserve_phys);
+EXPORT_SYMBOL_GPL(kho_preserve_pages);
 
 /* Handling for debug/kho/out */
 
diff --git a/mm/memblock.c b/mm/memblock.c
index 117d963e677c..6ec3eaa4e8d1 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2516,8 +2516,10 @@ static int reserve_mem_kho_finalize(struct kho_serialization *ser)
 
 	for (i = 0; i < reserved_mem_count; i++) {
 		struct reserve_mem_table *map = &reserved_mem_table[i];
+		struct page *page = phys_to_page(map->start);
+		unsigned int nr_pages = map->size >> PAGE_SHIFT;
 
-		err |= kho_preserve_phys(map->start, map->size);
+		err |= kho_preserve_pages(page, nr_pages);
 	}
 
 	err |= kho_preserve_folio(page_folio(kho_fdt));
-- 
2.50.1


