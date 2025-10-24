Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5FD4CCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 10:24:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11BAA8E0075; Fri, 24 Oct 2025 06:24:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CC568E0042; Fri, 24 Oct 2025 06:24:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFDAC8E0075; Fri, 24 Oct 2025 06:24:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D6C918E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 06:24:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 825645B719
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:24:35 +0000 (UTC)
X-FDA: 84032623710.13.F6B26E7
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1B88740003
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:24:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761301473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=rk4x52QujASx2OITlXPc7ACmuOBr0RxjOIjy0mZeaf8=;
	b=PMNZH/2y/nPj05t/KPvI604lOzbiLlJaNdV5yzP6zFoagND3pDFXkNhh1bsqoJTzlhpcLL
	D0S8fDURAJzpeV49eTaW35E1KVWx6+3LkNHInznnfFXi5Q/ljb72qTSHqcSTXc2gLRdrCd
	9geSzfieQ0n5LWfrvKeCCJW/huCeKWg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761301473; a=rsa-sha256;
	cv=none;
	b=g7L8qA7n5kGFvZJd2D/04u7vArDxeqmmNRXu1l+wAzzljcU4bP5kc9Q4PO4SFWlRhnm92U
	OoxtRmLvU+BluFeZe1Aeto0jOwfssc3b3UuYsf3FC783+K2IjEuHKXwypeXXtm0PaTUuLQ
	g5BfJTGicoeWQFEyW6hgOm+MyxmlbBM=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4ctJs40knyzKHMM3
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 18:23:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id BF91F1A1361
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 18:24:26 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with SMTP id cCh0CgBHbVDSU_toXgS2BQ--.15501S4;
	Fri, 24 Oct 2025 18:24:25 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-mm@kvack.org
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	david@redhat.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	karol.wachowski@linux.intel.com,
	wangkefeng.wang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v2] mm: do not install PMD mappings when handling a COW fault
Date: Fri, 24 Oct 2025 18:22:37 +0800
Message-ID: <20251024102237.3332200-1-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.46.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBHbVDSU_toXgS2BQ--.15501S4
X-Coremail-Antispam: 1UD129KBjvJXoWxZw1fWw4fCFykCw13Zr13Jwb_yoW5Ww48pa
	yxGa1YkFWfWrn2yF1fuw4vkr45ZwsxGay8WFyxGryj9F15Gr1Y939Yga13A3yUGr18JFWr
	Xr45Kryq9F4q937anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWU
	tVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUZYFZUUU
	UU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B88740003
X-Rspamd-Server: rspam03
X-Stat-Signature: xce7dfwazobksey4mox3njhkmxdiff6b
X-HE-Tag: 1761301470-831381
X-HE-Meta: U2FsdGVkX187BfOvGXTlNhkMH3vUvnQj6RDFvcsYkyyDZ9jynQGTdV33GbS++db/5Ng644+AJylL3ODwRMyOGQIWdqL9/zGLxvNUVOkjIo3HvPYxUPXLtvArcB9VaBvic5+JqoYzsfd4GOm22V6PjCIzVRxT9YAC95VTUXdAbY/4d5NPMK6qShcEJpsC/c/PnhanQXOH8qyoh7NP4H4z6v6ZrMxGZTG/7BXU7wHeBinXMc1sPFyFBTK1tkN7wxQ2m9UAglzt8TTXG9nvdQZ+Sl0PSmTN7ioRD85Q6r79+Jhs2qJO6CQyuZKETlvgdikaFu1PACZCnkyBa6iELX0Hh0ziLLymZ//k9Q2uFeVy5TZoLFGURtI18pb2Oyw9ZpoUJw+fBc/2Bje3UVcZ7PplKcKlLQ6k7jP99+eCidFe56SQCgh60yy4pt4mlUkPjpzBaTR75mSFknCmIeryFVSklUyj9SDb8p2KUYzKEEOtjcffVnlluOwU57uddAFEHcN1G1sgPB+tmyTpoc9NlKMwRAbfRrSY/rA+QphWsMfoukKZ4GuNikp2kOBX75psF5EeILBeWLXT4g0uKSn5N71n0s4fjWs3EO8JtJZnWKxBMOgEJc3OWreSBwTl/evtOM0e91PUiao43FDu+J+UQiRHbait16Svpyv1jYBd6BpsefmlUl3G/GsIZqs1mXNeXTX+KncyToCbUFsMwLElytqjUTEzig5XE/Znv94doobBF61xKVUZjVa5zZ1ysiRo3Ghse8jySU9tGhMvgrafIYbEclIwh475rLpcxf8g347x83D/Q4NtgUwUC76Kj1eh+oLt8kRiOw7k4nIMKjvzV8n492rBMNlQ+a3loy8Kb731lBlpROAQ+uUXxOHxKB90Zq8OLnN8vgmroXhe0D6QriqG65imQeo4IY/6MkltxEB/XJtWTCLkhskPMz+egsl+F0x4rUfg62+vpZtVU9UwrNY
 I9nYFs2Y
 PrOdtzFzs/0tA+b8QdbpXzkCtkEwBepvuBOy/hM4VcaIrDuTsqM9MXkvcIoxXAmYdfC51erjP/CnDUONm826HPQuD29REhgDXgqFGdMGR8kc8iSICNS9MjHqZxA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhang Yi <yi.zhang@huawei.com>

When pinning a page with FOLL_LONGTERM in a CoW VMA and a PMD-aligned
(2MB on x86) large folio follow_page_mask() failed to obtain a valid
anonymous page, resulting in an infinite loop issue. The specific
triggering process is as follows:

1. User call mmap with a 2MB size in MAP_PRIVATE mode for a file that
   has a 2MB large folio installed in the page cache.

   addr = mmap(NULL, 2*1024*1024, PROT_READ, MAP_PRIVATE, file_fd, 0);

2. The kernel driver pass this mapped address to pin_user_pages_fast()
   in FOLL_LONGTERM mode.

   pin_user_pages_fast(addr, 512, FOLL_LONGTERM, pages);

  ->  pin_user_pages_fast()
  |   gup_fast_fallback()
  |    __gup_longterm_locked()
  |     __get_user_pages_locked()
  |      __get_user_pages()
  |       follow_page_mask()
  |        follow_p4d_mask()
  |         follow_pud_mask()
  |          follow_pmd_mask() //pmd_leaf(pmdval) is true because the
  |                            //huge PMD is installed. This is normal
  |                            //in the first round, but it shouldn't
  |                            //happen in the second round.
  |           follow_huge_pmd() //require an anonymous page
  |            return -EMLINK;
  |   faultin_page()
  |    handle_mm_fault()
  |     wp_huge_pmd() //remove PMD and fall back to PTE
  |     handle_pte_fault()
  |      do_pte_missing()
  |       do_fault()
  |        do_read_fault() //FAULT_FLAG_WRITE is not set
  |         finish_fault()
  |          do_set_pmd() //install a huge PMD again, this is wrong!!!
  |      do_wp_page() //create private anonymous pages
  <-    goto retry;

Due to an incorrectly large PMD set in do_read_fault(),
follow_pmd_mask() always returns -EMLINK, causing an infinite loop.

David pointed out that we can preallocate a page table and remap the PMD
to be mapped by a PTE table in wp_huge_pmd() in the future. But now we
can avoid this issue by not installing PMD mappings when handling a COW
and unshare fault in do_set_pmd().

Fixes: a7f226604170 ("mm/gup: trigger FAULT_FLAG_UNSHARE when R/O-pinning a possibly shared anonymous page")
Reported-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Closes: https://lore.kernel.org/linux-ext4/844e5cd4-462e-4b88-b3b5-816465a3b7e3@linux.intel.com/
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
 mm/memory.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 0ba4f6b71847..0748a31367df 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5212,6 +5212,11 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
 		return ret;
 
+	/* We're about to trigger CoW, so never map it through a PMD. */
+	if (is_cow_mapping(vma->vm_flags) &&
+	    (vmf->flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)))
+		return ret;
+
 	if (folio_order(folio) != HPAGE_PMD_ORDER)
 		return ret;
 	page = &folio->page;
-- 
2.46.1


