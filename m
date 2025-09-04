Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E3E2CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 13:27:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 685D78E0005; Thu,  4 Sep 2025 09:27:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 636078E0001; Thu,  4 Sep 2025 09:27:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 572598E0005; Thu,  4 Sep 2025 09:27:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46D698E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:27:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DCC2E1190C6
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:27:44 +0000 (UTC)
X-FDA: 83851645248.15.6078D0F
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf02.hostedemail.com (Postfix) with ESMTP id D3B9280005
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:27:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756992463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=gNHgUI/W/DoT0i5c3isev+NX39PPVcaxb4aXm3kcLng=;
	b=ePAZLDIYb7NbqkynOeXAarPhZlWB5O4h9eldXx9rmN4G3SGcphHXW2v4O+XlHkaMtDqFCm
	8dekCNdcTJpkn2+ckCx/yechITav96j5Jg4pKB7sw2vz0JaFAiE+RA7UakLTb0yGAoA5XZ
	hXJeA3Kh6JgIY8F+HtEgaF/qTwlWks0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756992463; a=rsa-sha256;
	cv=none;
	b=J02HsBBR0Q2Y8LFiyiJQVKWEkjDKnidqEPU8C8/wNyL63XKw6Xe+LCLCKJkwzOkFbvkc0A
	0LGS8dfUzKE7e+pfOOnEh0F3uxSkWfQcuZAWiXZULW22ESal6QbZdt8wuaITKqRJcoJn75
	jQdXyazDlPY+a5Ga8V1AuCASzBM1rVg=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4cHgDs20cHz24hvN;
	Thu,  4 Sep 2025 21:24:29 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 308261402CC;
	Thu,  4 Sep 2025 21:27:37 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 4 Sep
 2025 21:27:36 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <willy@infradead.org>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <tujinjiang@huawei.com>
Subject: [PATCH v3] filemap: optimize folio refount update in filemap_map_pages
Date: Thu, 4 Sep 2025 21:27:37 +0800
Message-ID: <20250904132737.1250368-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Queue-Id: D3B9280005
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: tysjf69eiwc513o5pqqhxrijy7m95de7
X-HE-Tag: 1756992461-934789
X-HE-Meta: U2FsdGVkX19nbgPNS4xqFYNK0mqejDo2e05CeaCZzs8vnlXGsY9KF76vPGdUVo9VQJqQ4zWfgZJ6R05Wv4eEbO8vVQsK3HgusyjjndOLyNuM8IWidL76mQrlL38dBtZQoRX4aQCTGqY/puNgdvusEKNb3sCytZtDtfIoD7kpSFKuRUCwl+FTg6B85x5GWmuaFtBCsrQd7iGFpf7XAL3F6tVO1RVf9q/PlicWlxet12BnoyDpo74c8bPQ9kVIksp3ri5zAC9NmZd04juRoIIXUR0xMlTcRCcAsceYs8BpRJl83/G83fc0KeQpHDBJcEyeozEMyLP4lONTe3a3P+fzA5P7Hoii4wDzTiT2GxMB8t1Lnui3znj8qVXFtgb4CIAJJYbfalwop/f19FyJARaTu82MuOod3ar0xFiW7Kxqc4WDB5w2Q7EaYOJ5/0ybGXFs3Iw0ss2b400g4Evp03emJ6pPBU5mif3HT0LGVOKo0Tnnsw4yFXNuaX4Z79jHWvjMz/roNHnstFMJGA9V+GVCgfFPKp69hziPNMJ85RfCfkSWnk+GVq2yXg1vhdSQN2GjeNgdrSg8x2cgiuUe8SWjmf/A1AtdTTDaqySFNVrNN6s3CqFf2H348hfOkK7W8nPctr7SAJpme9ZdLSqbP8G9hq1yKbaNHYTjx2WciQzL/+YwavKzUKelzGenjPRaGQEG91jAws6xjV8fUgo/AEhY200wi5SMK3Y1HoUZu7U3q20VBWAPKFm0wP/jPqzRdyLEZrndUi45I5x+WoRvDVEAzslpsY95m6/E2zdbUxhewNsExjqdkRQKKVRdmTiCVZSNQm7r4qEP095sdYhMs1Of3CFLh6Eii2FYburDMGy3892cdzUDjyHWYmOrN34oK01F9euW3uS5kvTmV7Jp7HyqNRiwMG7JHabyB2ccnXBwxQbx9WYJKburtC3wI6QmoY0P9pPuf8RvyP9LoRob18q
 XVf/9Hgr
 +VggOoIuBDOGtCpsJrb6TMUlK9jLpjRQcLbd0S8I1LpYlMXID9OdSGzyGE7zmrAlwlmwwYbH+ss8H7tTfJEjkPZzwqhmSquCm+NVn3n/bqXRpZWRhC5lx2RvQ22DuMK9bMWgA4ryF5KlVGPHyHL4m5PB1D9UJ1MVG4vC9/ney6sgnYEDKzK5j9X7XpBh5fF4ImInBoPJnE8JkxGDCpaXPp+W4U/SN+6uJToItahOkx3Tq9woB0F+yBgxq6mB3ttreMMynoFqBWYMKLTl9syf8cMijbOVJhFxEVZXR9lowgpEc0sqeEDli0d3ybA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are two meaningless folio refcount update for order0 folio in
filemap_map_pages(). First, filemap_map_order0_folio() adds folio refcount
after the folio is mapped to pte. And then, filemap_map_pages() drops a
refcount grabbed by next_uptodate_folio(). We could remain the refcount
unchanged in this case.

As Matthew metenioned in [1], it is safe to call folio_unlock() before
calling folio_put() here, because the folio is in page cache with refcount
held, and truncation will wait for the unlock.

Optimize filemap_map_folio_range() with the same method too.

With this patch, we can get 8% performance gain for lmbench testcase
'lat_pagefault -P 1 file' in order0 folio case, the size of file is 512M.

[1]: https://lore.kernel.org/all/aKcU-fzxeW3xT5Wv@casper.infradead.org/

Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---

v3:
 * use folio_ref_dec() and optimize large folio case too, suggested by
David Hildenbrand.

v2:
 * Don't move folio_unlock(), suggested by Matthew.

 mm/filemap.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 751838ef05e5..0c067c811dfa 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3639,6 +3639,7 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
 			unsigned long addr, unsigned int nr_pages,
 			unsigned long *rss, unsigned short *mmap_miss)
 {
+	unsigned int ref_from_caller = 1;
 	vm_fault_t ret = 0;
 	struct page *page = folio_page(folio, start);
 	unsigned int count = 0;
@@ -3672,7 +3673,8 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
 		if (count) {
 			set_pte_range(vmf, folio, page, count, addr);
 			*rss += count;
-			folio_ref_add(folio, count);
+			folio_ref_add(folio, count - ref_from_caller);
+			ref_from_caller = 0;
 			if (in_range(vmf->address, addr, count * PAGE_SIZE))
 				ret = VM_FAULT_NOPAGE;
 		}
@@ -3687,12 +3689,16 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
 	if (count) {
 		set_pte_range(vmf, folio, page, count, addr);
 		*rss += count;
-		folio_ref_add(folio, count);
+		folio_ref_add(folio, count - ref_from_caller);
+		ref_from_caller = 0;
 		if (in_range(vmf->address, addr, count * PAGE_SIZE))
 			ret = VM_FAULT_NOPAGE;
 	}
 
 	vmf->pte = old_ptep;
+	if (ref_from_caller)
+		/* Locked folios cannot get truncated. */
+		folio_ref_dec(folio);
 
 	return ret;
 }
@@ -3705,7 +3711,7 @@ static vm_fault_t filemap_map_order0_folio(struct vm_fault *vmf,
 	struct page *page = &folio->page;
 
 	if (PageHWPoison(page))
-		return ret;
+		goto out;
 
 	/* See comment of filemap_map_folio_range() */
 	if (!folio_test_workingset(folio))
@@ -3717,15 +3723,18 @@ static vm_fault_t filemap_map_order0_folio(struct vm_fault *vmf,
 	 * the fault-around logic.
 	 */
 	if (!pte_none(ptep_get(vmf->pte)))
-		return ret;
+		goto out;
 
 	if (vmf->address == addr)
 		ret = VM_FAULT_NOPAGE;
 
 	set_pte_range(vmf, folio, page, 1, addr);
 	(*rss)++;
-	folio_ref_inc(folio);
+	return ret;
 
+out:
+	/* Locked folios cannot get truncated. */
+	folio_ref_dec(folio);
 	return ret;
 }
 
@@ -3785,7 +3794,6 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 					nr_pages, &rss, &mmap_miss);
 
 		folio_unlock(folio);
-		folio_put(folio);
 	} while ((folio = next_uptodate_folio(&xas, mapping, end_pgoff)) != NULL);
 	add_mm_counter(vma->vm_mm, folio_type, rss);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
-- 
2.43.0


