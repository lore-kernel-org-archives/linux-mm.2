Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49933D47CD0
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 11:22:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 975256B0098; Fri, 16 Jan 2026 06:22:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91F0A6B009D; Fri, 16 Jan 2026 06:22:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84C876B009E; Fri, 16 Jan 2026 06:22:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6810D6B0098
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 06:22:34 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2FF598C167
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:22:34 +0000 (UTC)
X-FDA: 84337589028.20.A0A9DD1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 693C31C0009
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:22:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r0p+LPou;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768562552; a=rsa-sha256;
	cv=none;
	b=TXzSiieb4bs8NwMeKTX4GXRFRkHc7LEiGO1iOrtgszEwYyz8OHnrRwhdcU/nUqLltge8nr
	sOgezr9QL+OPYmOfDPh6WhQJoJRP/V34MjLBgv/RsClj7INf/83+CB5ek+MJ3A7MvajNhY
	2JI4FsO9H6M9jn+rNZ/MEXCESa8Td/M=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r0p+LPou;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768562552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WQowesb/8YsfOv/DKmWEb8eNP0xlm20yGa3uGhlbhQo=;
	b=mzdkkY1jyZB95ThuYP4yS7CZCu8ZenG2vQusaVM5946OI+skTVhSTlX5mYdmNcQqrDLj5X
	3zM95gl6vz08GPeHgbaUBpPgKFeuLc/mJM8Wvv5KLE5QDr5UompbpWGGOT+fFMye2/teaP
	hgPy7s83W8bv8rM2jdGlJA2ZMGlrLP8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 663BB43C78;
	Fri, 16 Jan 2026 11:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA12C116C6;
	Fri, 16 Jan 2026 11:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768562551;
	bh=tCtXq7BO4v6qCmECL0o+wXPIF7pMwPBxgUjHzekhM/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r0p+LPouc1TxNkjL5n0a74F/8lySb/XPmBfoo4ophrABJu1LgZzCLRDHzCAQ+efhx
	 CDJSH4lDGs4vhv9P+8W5YyZoi5mcssI9wzDQlhD61aZ3v8KJo9D/AO/kfw5WnvxrVy
	 rvFDWih5VS8rXd+FEH904ritvGEl5GyaEPCTC5/JHHHtG4reFM8IvZiL6iDVZiRGis
	 6iMdZr5ZvnZS+i7l74B48UkDvmbfzZeJGDTqD0uZeyJxQHI2gvhP0XAwHQsFbMmckP
	 k/wyduWnsawJFxv5WctNrWJmU/9y8HO8yQWb7DH9KMQZW5cbe0aBJBl0L6e57vdWqo
	 6VZ1624Z8eLPg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH v2 1/2] kho: use unsigned long for nr_pages
Date: Fri, 16 Jan 2026 11:22:14 +0000
Message-ID: <20260116112217.915803-2-pratyush@kernel.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
In-Reply-To: <20260116112217.915803-1-pratyush@kernel.org>
References: <20260116112217.915803-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 693C31C0009
X-Stat-Signature: w63kzkbnhapgji5ctgokmpsb8h4d5tre
X-Rspam-User: 
X-HE-Tag: 1768562552-518034
X-HE-Meta: U2FsdGVkX1+PhV569d/mrqzJesuHJCHahD6t24/jKQvm0CFr1J5bHmi9JH1EQAiwN225D4094WclAyogPatflwcSNTUzgEts+3Qv47aHAWZ0zp4C1X+XnUWJAhLQr3UoNVAcXdJti+R0zjwKyk2a84N4hiSfUlrfnBBTYbQZqJpsymDhM9K6wyMib7Gd83P3vnwlmGFioqpKW30tbxNunlVGoDvoEQcDUFQgz7lVchVonGLQ33BW8Gw19zAp51PzlmwXmK5pt4tGFf/649A9vNg2GnS7eDVim2SAQphMaatz4SxGMGyAW82UBX6tFl9p6lomLEREGmO66oGWpa2APoeXuh9PXm0nl1jzhpgXLC58Ed1VL8nT473GK05iVy1oVQbU4oOcrAsGhJRyPfI4oQLjfnhxRrJTiL89h3zUxphm8daATKC4XYK13rQCGDoyiVZ4l2PDtm9ot7TUwn72TKjtcT4EiBrmlwposV1V9JWBWq08b7nc9Xa3U4KB0PXdk7WCMtBcVChSSREteSvuPZotmXI6a6VXeXiIkiKPyWGSx9U3jddn1SlH3mtuzzE2/D9OoK9qLzb4QeC87a36uR4oD/e7GGnWJatzHwjUZLDX9OsaCyJepBJpL54Hu9gKz/4ZSfYd/oBY6Qg57NYW7vD9vZB/ptlzLoPtG2XneBpB38J9Ojl5pUYBJiI6v56a2HAGstu5FSkOFT2oovhwOXuoliizyttDDU/FOAOy9IqSKEibFFwOV4nsWe976+HzXkOxFA5a3Xv/i1vBA+JT8OX6LqAV22ETvcvaR9NMFG4Bpf9KvmnAfa63LtRimJ1KC3iyDzEYfwApeMRAJeS0keJ1qLJVKnTdKKkvjJNWx1dCQD29kD9AXG89N12QlYKfQL8MWmxFJGoRsLHQ/WxoL36EctLvtK0FSuT6eXENvAlNnNPpZ8VzlFkhw7mTXJUC9Deid6th68Kg7cPN5na
 whgdbSeM
 FXJlkXzQkOjJtmfS6vRFsxZjUAAgyb60ByHbPK2OX8ZocEOrneBECr15g72Ey0DU6ufY+RVzWu4LXj0HnLwfOg6/3eLXywWHGhUSA+ifhpsr4QR2KJc6hx9TcFl6wSpBuUBQYU6Hk3x/nfMfy6qMd14IeVAQH4UX9l5PmUr9ajyG1Jd7+s0bjqSK1OvP0mEc0Tyui5OZuGbUnZWJdVu1BqI3c3sa9k47i1n3zq/DQ4dkEOkN4q6jMNdzpOgl3nWCbVUubsVCwU74QQvkTZ7TEEWdXA+2iP/ZAkbnomsa2sFADi1/bE7hPr/w12Dusqgw+x5wJDm9s/Y41MOFE7JicQjONNw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With 4k pages, a 32-bit nr_pages can span up to 16 TiB. While it is a
lot, there exist systems with terabytes of RAM. gup is also moving to
using long for nr_pages. Use unsigned long and make KHO future-proof.

Suggested-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
---

Changes in v2:
- New in v2.

 include/linux/kexec_handover.h     |  6 +++---
 kernel/liveupdate/kexec_handover.c | 11 ++++++-----
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 5f7b9de97e8d..81814aa92370 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -45,15 +45,15 @@ bool is_kho_boot(void);
 
 int kho_preserve_folio(struct folio *folio);
 void kho_unpreserve_folio(struct folio *folio);
-int kho_preserve_pages(struct page *page, unsigned int nr_pages);
-void kho_unpreserve_pages(struct page *page, unsigned int nr_pages);
+int kho_preserve_pages(struct page *page, unsigned long nr_pages);
+void kho_unpreserve_pages(struct page *page, unsigned long nr_pages);
 int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation);
 void kho_unpreserve_vmalloc(struct kho_vmalloc *preservation);
 void *kho_alloc_preserve(size_t size);
 void kho_unpreserve_free(void *mem);
 void kho_restore_free(void *mem);
 struct folio *kho_restore_folio(phys_addr_t phys);
-struct page *kho_restore_pages(phys_addr_t phys, unsigned int nr_pages);
+struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages);
 void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
 int kho_add_subtree(const char *name, void *fdt);
 void kho_remove_subtree(void *fdt);
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 9dc51fab604f..709484fbf9fd 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -222,7 +222,8 @@ static int __kho_preserve_order(struct kho_mem_track *track, unsigned long pfn,
 static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
 {
 	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
-	unsigned int nr_pages, ref_cnt;
+	unsigned long nr_pages;
+	unsigned int ref_cnt;
 	union kho_page_info info;
 
 	if (!page)
@@ -249,7 +250,7 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
 	 * count of 1
 	 */
 	ref_cnt = is_folio ? 0 : 1;
-	for (unsigned int i = 1; i < nr_pages; i++)
+	for (unsigned long i = 1; i < nr_pages; i++)
 		set_page_count(page + i, ref_cnt);
 
 	if (is_folio && info.order)
@@ -283,7 +284,7 @@ EXPORT_SYMBOL_GPL(kho_restore_folio);
  *
  * Return: 0 on success, error code on failure
  */
-struct page *kho_restore_pages(phys_addr_t phys, unsigned int nr_pages)
+struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages)
 {
 	const unsigned long start_pfn = PHYS_PFN(phys);
 	const unsigned long end_pfn = start_pfn + nr_pages;
@@ -829,7 +830,7 @@ EXPORT_SYMBOL_GPL(kho_unpreserve_folio);
  *
  * Return: 0 on success, error code on failure
  */
-int kho_preserve_pages(struct page *page, unsigned int nr_pages)
+int kho_preserve_pages(struct page *page, unsigned long nr_pages)
 {
 	struct kho_mem_track *track = &kho_out.track;
 	const unsigned long start_pfn = page_to_pfn(page);
@@ -873,7 +874,7 @@ EXPORT_SYMBOL_GPL(kho_preserve_pages);
  * kho_preserve_pages() call. Unpreserving arbitrary sub-ranges of larger
  * preserved blocks is not supported.
  */
-void kho_unpreserve_pages(struct page *page, unsigned int nr_pages)
+void kho_unpreserve_pages(struct page *page, unsigned long nr_pages)
 {
 	struct kho_mem_track *track = &kho_out.track;
 	const unsigned long start_pfn = page_to_pfn(page);
-- 
2.52.0.457.g6b5491de43-goog


