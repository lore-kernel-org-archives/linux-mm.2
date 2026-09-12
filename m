Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34682C88E53
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 12:28:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D533B6B0088; Sat, 12 Sep 2026 08:28:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D03CC6B008C; Sat, 12 Sep 2026 08:28:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD5146B0092; Sat, 12 Sep 2026 08:28:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 90CE66B0088
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 08:28:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4C4761A04B4
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 12:28:36 +0000 (UTC)
X-FDA: 85205038632.07.62BF6FF
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf13.hostedemail.com (Postfix) with ESMTP id A257420002
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 12:28:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uuLEGrHc;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789216114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NJXH9rrJbZbgym50NMM/+P+67cMUDF3IUxD6O+4ZOuc=;
	b=xot65FXtHIwY0+F5iQlLXXTRwb9ekekhsOL20wJL9kzx5c9Nb+0RThK48W+N8XEBe8slfY
	kolwfAyl6zKXFp3ABRC4SCLqyrQs+prA68ZOdLqvFml6SSImYPZgQd9pm0C0s1TDGR8u+/
	L3yaGEwIz75B+S3DLkv5NJIFGqy3OkA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uuLEGrHc;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789216114;
	b=zXqH6zZ4SRRNwMgSxdmKAnyLqn+hCtT6vtXVVxEW8j6L36x/y3zVPSDzmJmUIjh4XHs0Lu
	wI/EJT4IENmulftAx2Wygak58XVH0FUo5EEckEIZrAYWKyvN5ovxcf1yLz3/Wd3fwocJEC
	Yv9SxV+O+o0EH3LYreOEu3/FY3wtYSI=
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-530c602630bso5738551cf.3
        for <linux-mm@kvack.org>; Sat, 12 Sep 2026 05:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789216114; x=1789820914; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NJXH9rrJbZbgym50NMM/+P+67cMUDF3IUxD6O+4ZOuc=;
        b=uuLEGrHcoCLri55uQwyCmJz/YKEHM5G507O3pptEfJZAObeSqChEtsyu4xRFZcA0WJ
         SRyaaa6FDdfGJS4jej3vhdgvP2ivyAnoTqOUqn+fVNsrF8KPCgHGAl/DEdLGxObToENS
         oVttDedQ1sd59P+UOt96QyVLp/1lHJilNWBAgNqrheKzc1q32oHrCgx0OiPKjWo4sDaO
         eiy752GGPUbD0PZfk8YIpyc0+MqRj+cc/qzLX2g2qt79Gjk9Je3qLEiwHSDYnY5hKfyH
         0HCxpK20d720DrS1cTOjxxLi/f9RcAtZStXMRAqJmm0Ozx+1gHopDMWvHXb8VYaYDtkP
         erKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789216114; x=1789820914;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NJXH9rrJbZbgym50NMM/+P+67cMUDF3IUxD6O+4ZOuc=;
        b=BGT59BgxYJ9KQc1w5enjzcgi/9JsdGslJG83T3meuhWKy7TGp9ciHC9VruOXTe6Tuk
         yxoYqfMoZuVr0cvXInpfaGsovkWlkz39vAck4l7NkzcpK9Pngss0LB4f9Os9fJCtf/+S
         k/v2DES7kTCXChT2FUdg5/HLwWff9j8ckQew/vpJctSGAmfvmdz7DVS/ZVbJncsOGRyz
         Lxl9F6ctPhV8ptldwtuccqYekVyTuhiJhNvvZQVvWjd+0m2KSq3oVulPY/ok6iwRPieG
         xJrHVOQ+NFZZEJiBvvnWsLmB+z98tYSJGrmIC03VSy4ONiwQXxto7AubDO0636zcmsut
         7CUw==
X-Gm-Message-State: AFuF++m2dteQv6ZD8VtkbtV2mVUfx/3Kmtt0UOQZzjqjVceGO8+g5Qa3
	n7q+BKytkoozlSkkSUwYu96SOvexvhMUr5GDR9JOPRN+PIaqCaiNhE/iaewaFCCT6f9Fo+4sy3v
	7P8HE
X-Gm-Gg: AYBFou2DR4rQphy/RvPUvLwDZ2e0lWFS1/r/9Rkk5nv23n5Nd4SCklNRxa2UuQJayIg
	9ewK0gamUuoSADvsQgycuYEv/aNKqTWXU7B3AbDQkyBCaPmMSbEY7io/nRNTQu/tCO7+chLbSK3
	ivXu1Je7oXmOn3L8OUTp7wpJOoNE87OtVZ5OKopw8qO7ABXWPXTaLLPOAEav8yjw4sYeNYr46IU
	DyFeL4J9xLcYFQMUkuGz7yP5ijyhda0ARHEV/ZA6Z0sTHQGc5HOV8iHktpgSNtyl6vCn+J/g4A9
	cbma2FLtbRDOeGut/C/pjvrh7vXLT/1SMWNgSHAzddtdXSPhNZ3EqerFX3Cy/4ZRLw/zuIDW3jo
	65Sx9ZulEblw/YevsWqMj0L6GoBFooOQIo76u+/f3WeVhy6XIucMe9/J/48D39PZi/tztWELcbq
	TxgPShp0jg2Ue/pesTGEC3lU5wqEpws0W/NacVaD2dG3jlY7JtS5XLttsNvRimvcCBY6IKDyDx6
	bKus6IdYQZr1GpiCTauHrsF8qZBhZXHINYL89GklX/4uKFXKpWj0CEsOYa1
X-Received: by 2002:a05:622a:1f8b:b0:530:42e5:f3a4 with SMTP id d75a77b69052e-530e81e3f69mr37044771cf.45.1789216113681;
        Sat, 12 Sep 2026 05:28:33 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-530e64da059sm17780461cf.24.2026.09.12.05.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2026 05:28:32 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	peterx@redhat.com,
	jgg@ziepe.ca,
	david@kernel.org,
	sashiko-bot <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] proc/task_mmu: handle special PMDs in clear_refs and pagemap
Date: Sat, 12 Sep 2026 08:28:22 -0400
Message-ID: <20260912122822.3348978-1-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: wb6dgfikqfuagh45568entwh4yi4jbdz
X-Rspamd-Queue-Id: A257420002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789216114-416216
X-HE-Meta: U2FsdGVkX182ruQT3coi9P8QIYt3DnpeYdItKItwkICdWXOSPUmo8xrnRrjhmcW6SvQFMEgRT6GlfGf4XEbWHcKTJDVXwDRMCSAj6g2MBRetjIj6yPGauagjdMZThC+cwi9N7V8v3RmV4OGeVsbJIJfoCeDIDDmnOtbKwTfLZJAXnQ2PBnY0CifVNCLkybkR8dv9t3+3pY7MgrUo9FS7SNj+M/AhGhlEhcxTBs58EUikZ1z54zhLFXIk8SKBJn1i/GFXfklhSYaYmYytGAa8Tl0PTWt+olq07G3VnP4Fzsf6CdBEngVTy+vr3HYFaNzY/g7114qRu3XNA4w1TOeqelHiUio+TUcU0rV3iSzcsQ5HaelOnM8mI+yjex02dhN5WqAHSUUwKhz27ZQQ0y4EbTBdXNTgENxbHkFnoyHZrwGdVvq4MelDOqC3rMAje1s1RL4PNA7V5hbD1WKtqawbiAcxOCRsydFJmJRGU1rxfh1yQhoxgiEXIyYI3Zrry0JfI2j4agziJ56QXFUwqCNsJb57wVmh7mFfi6RpYFtPuc4RcI4qSumR9LSyHAvIUU2wUMEEvk5GSJmq0w1tjsfXxFa7qGceg/avXVj0sZhprZlDk/XI08oqS0sVw9hsCtADfponpIrQLJ0Xc4a8AQxoWnJ5tyRToP5qjJ9kQ5S292LzoT+BtoYAlG7gy7AFjBG9JrbadesUFHj5AvuLbHwLti7PEC49ZdZucb+2HSs0HHCCwkmL1O7HFpAEMrW4X7i8jDl8KxF5QhK52NZZyCcwCKnaDWEa7s36Tm0uuFXEDEtpVWJKuLxSd5R1cpfupHMvIrz1l6xlLtbIzo5s5r7k7g8rajCmD0GDDe2COqtFA6xug786hjYs/8B7eMpQ8h5Mxuen5ngaJRfTo680e7YcKRTGpz+ihtuFdbDhA+bybNW0jYqUplroJscUhirBXqCuQiii9UZ5DE8pWIFu8lm
 k+rvzbj3
 n3K8SWBp1OFhhu+iwLyFDsPEhnamliTrQL2mtGzZ/DgkM2hHGFU6CqbayfTFeAUlkK7PemScg7FLOpV28eIi+5a7SJEocJjniiCChzCpZyhnu3AllPOuYWWYmijDI5hL8iSBcVz1ekEBlL/I+uF+WOm219TSmzj3q1mxzoY4OVxwqgjIGt4GrTGzXbEB20NgiLLOsBv9QQECo1eRvlEsb0fLjwEamj2LiNRmrx/juHTBnFcInegqIA2Uk6bzc3zxmtgEde/UPBeBpVmAQIuP3a/f5OuGFMgzMZYDDJJ2Zx4YwKJ/62sD0e9ARwLnuMLmW6o2f81lWkWA63Z4I2Z1zoRZHItMs2iXCzFvt2M0cUgtaON4a/xxt1zJq1v4ekxYpqgpzr7aINJc6rtXXfgVB1WDWaV1xN8v2M6iVTlNvWkEq34pcU0HvID2g9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mshv_vtl_low can install a special PMD from a PFN supplied in the mmap file
offset.  That PFN need not have a memmap entry.  Reading /proc/PID/pagemap
or writing /proc/PID/clear_refs for such a mapping oopses the kernel.

With a test driver mapping the PFN at the 1 TiB mark:

  echo 1 > /proc/self/clear_refs

  BUG: unable to handle page fault for address: fffffb5b80000008
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  RIP: 0010:clear_refs_pte_range+0xb1/0x1e0
  Call Trace:
   walk_pgd_range+0x50a/0xad0
   __walk_page_range+0x6a/0x1d0
   walk_page_range_mm_unsafe+0x193/0x230
   clear_refs_write+0x18e/0x3f0

  pread(pagemap_fd, buf, 512 * 8, addr / PAGE_SIZE * 8)

  BUG: unable to handle page fault for address: fffff57840000008
  RIP: 0010:pagemap_pmd_range+0x3cf/0x6b0
  Call Trace:
   walk_pgd_range+0x50a/0xad0
   __walk_page_range+0x6a/0x1d0
   walk_page_range_mm_unsafe+0x193/0x230
   pagemap_read+0x1dc/0x350

clear_refs_pte_range() passes the PMD to pmd_folio(), while
pagemap_pmd_range_thp() uses pmd_page() followed by page_folio().

Both paths assume the PFN has a struct page and dereference bad address.

Use vm_normal_folio_pmd() and vm_normal_page_pmd() so clear_refs skips
folio operations and pagemap skips folio-derived flags for special PMDs.
This matches the PTE paths, which already use vm_normal_folio() and
vm_normal_page().

User-facing notes:
 - Pagemap still reports PM_PRESENT and the PFN to a CAP_SYS_ADMIN reader.

 - For a special PMD backed by a valid memmap entry and for the huge
   zero PMD, PM_FILE changes from set to clear.

 - PM_MMAP_EXCLUSIVE is already clear in both cases.

 - The output for an anonymous THP is unchanged.

Tested in QEMU with the test driver on broken and fixed kernels.  Both proc
operations oops before the fix and return 0 after it.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260912034833.2952750-1-gourry%40gourry.net
Fixes: 3c8e44c9b369 ("mm: mark special bits for huge pfn mappings when inject")
Cc: <stable@vger.kernel.org> # v6.19+
Assisted-by: LLM
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 fs/proc/task_mmu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 24425e230895..501cd038b4e4 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1671,7 +1671,9 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 		if (!pmd_present(*pmd))
 			goto out;
 
-		folio = pmd_folio(*pmd);
+		folio = vm_normal_folio_pmd(vma, addr, *pmd);
+		if (!folio)
+			goto out;
 
 		/* Clear accessed and referenced bits. */
 		pmdp_test_and_clear_young(vma, addr, pmd);
@@ -1991,7 +1993,7 @@ static int pagemap_pmd_range_thp(pmd_t *pmdp, unsigned long addr,
 		goto populate_pagemap;
 
 	if (pmd_present(pmd)) {
-		page = pmd_page(pmd);
+		page = vm_normal_page_pmd(vma, addr, pmd);
 
 		flags |= PM_PRESENT;
 		if (pmd_soft_dirty(pmd))
-- 
2.55.0


