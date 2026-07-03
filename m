Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E172C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 17:40:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C92A6B00C1; Fri,  3 Jul 2026 13:40:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 179706B00C5; Fri,  3 Jul 2026 13:40:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 069016B00C6; Fri,  3 Jul 2026 13:40:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BFDA66B00C1
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:40:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4319FC1614
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:40:09 +0000 (UTC)
X-FDA: 84948178938.12.4F0E8A2
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8CCAD14000A
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:40:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PJrZ+t2I;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783100407;
	b=i430pMnTrKU/teZtPnwyYsNC/543G0BfGm3P43g9VgXA1O+iq25usz7ag1mdgMWg59LeAg
	/u+gVD/qyGDySduIpr1EY5YtRyuEoEMkitOghWTh+/I5O2x49kKGgoCl5IzNK8IqTODmj8
	0j7PFRINB24k2VdQs/0a7bZ+q6XlFwg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783100407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Evfx+EZIIZODvoI2kp4gTxLF1s3vC5oCQ/1KwC0Scc=;
	b=NQv3JZMbDhKyxeh19j8IySHactMt64c7hNgsQ5iUux2ggvbV/Rs7eoGBvw1PpEY4axIQKJ
	jc/3GTN/OOiDdD3BW1fAtIkdu5BcmrZq26AErOQFLURGqUCJjY12GhWycPFe21HmWDNx66
	F+2KeF0R87MF5NrXNfug56TtkycLhHs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PJrZ+t2I;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783100405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2Evfx+EZIIZODvoI2kp4gTxLF1s3vC5oCQ/1KwC0Scc=;
	b=PJrZ+t2IznTBPm3Pt8HxS0sricGObKKrZHESy4NGidVmcjdcZSbd8TXViRXDqEenIXo013
	ytK1mJxtAwpTjPwFvuqG17ptRXw4mOG1IqE9uMkduTWNexkJgY0/VXk9dY4Mz61WxeFi6u
	Bg/c0FO4LMU954sCLdMe5pBUFelilqA=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v3 07/11] mm: handle PMD swap entries in MADV_WILLNEED
Date: Fri,  3 Jul 2026 10:38:24 -0700
Message-ID: <20260703173903.3789516-8-usama.arif@linux.dev>
In-Reply-To: <20260703173903.3789516-1-usama.arif@linux.dev>
References: <20260703173903.3789516-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8CCAD14000A
X-Stat-Signature: cmrtqqjwnb5i4h5mkqprrg3346s96qha
X-Rspam-User: 
X-HE-Tag: 1783100407-284169
X-HE-Meta: U2FsdGVkX1+0FyueJQ8tDaULT9YeCDcF4pRuZp55QluFlQPCPNDb4cTSXRXw8BrnUp/265e3A4xjpMbdJF4ID5rITlKD3reVtcsqc8VRkTdOduEtiMGZy6mUe6V9ewnMNA9XCpXR59tTAfhPLQwS2XM6du+R5TECoQF588CBNZ8iqbRUSN2FWXWhMGsdu+/TTSHfHmHYJRquOIguYL2I3ZB5neAGtKRAA2MQt2m/+b79v3CsJFFHWvbG7ePZByS9xZaoTqgradmFvTMwmtpdcyXzEymBUPg8w6eTZsaGI3d6DcVHOgL8vbXTGgmQco600f0VG9ZIY5xDPwI0J7VGrg9ZuD4jz/zGYQDrHuIw7eCEEPhtc5T30Ruija1XXNmZsKI5LBZphxhJUadhdelhIDs/XFpDuN+itJmVjFUM/F228kd4eSCR115Ph8uoMeQAaS7lt722F68d1zUpIsfPGrXQvE5g41uEKKngcsqVNX/vV4bpVtQVggAu1duxRlVRGLr0rpgapUfjPjcF1rdHIQl/ANPYBhzFgLi2/Vt8QPOJEJAjz+4VX0qoy+mFC19Sq3kXJVf0uvLFNoRG7Ml+7jgOtHZ4dGTmjVzcSkPoJ3CEf4QzAPNRgih8O6gkC0ceKKpgwHdsughnUGeuxSSZcRwRZOzzeMMuODubSOiR97U8PtrAn2GmGlNXQYqn7+256QO/7pG/IBXDU5Br/3tsuWOSWIhhvHAJ/HuQILkA4HQ+QmCb3FtMRf/7E8JNdpAFwteA5HSRKCd0cPy25UVOJutNFUoONpC8eVFVR3HaeMfzIdYcOSlVeOMyncOL7KoCtdE6qrFzzemtzODpGZHzVl50OQ6SE/uRyAqb77PfKigI8015WVRh7rG8BdnhwqseimffcY1KQfoORlzi/qO2dk3DTXLkOyAZH04sde67Z6QHKkb7G8gMrd0WgQwC7AHImsM5O1iQbWeDzBY9wTN
 b9QSeGLV
 3WJb44RGyMaUrXFnKVDvWd0cHnOro2wHUlvPaU9AOCOrrsjzHYAwX5leqAIn3Rl9TI0+gitN3PugVJXMNHKYSDU2/+MEKKAX17zwbnO7WOxRTfnYZAXBCS17A8RK4REep9P8yQnSgpnOBKOrpWc1LBKsbkMoYTbynYshOZTUtIg32HIbmXGjqBaRONPzbNXTtdI9kVxWOvcBjGFEcg/rF+Kp/FjIklCugZJ0aghoE/nx09MsH9DmGWE0Pug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

swapin_walk_pmd_entry() walks PTEs and skips non-present PMDs, so
MADV_WILLNEED is a no-op on a PMD swap entry.

Handle PMD swap entries under pmd_trans_huge_lock(). If the covered
swap-cache range already has a PMD-sized folio, there is nothing left
to prefetch. If the range has split cache state, or any covered slot
currently has a zswap entry, split the PMD swap entry and ask the
walker to retry so the PTE path can handle the individual slots.

Otherwise pin the swap device and read the folio in at PMD order via
swapin_sync(BIT(HPAGE_PMD_ORDER)). This keeps the subsequent fault on
the do_huge_pmd_swap_page() path and avoids order-0 readahead
needlessly splitting the PMD swap entry. If PMD-order swapin races
with per-slot swap-cache population after dropping the PMD lock, split
and retry through the PTE path instead.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/madvise.c | 75 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index 0d6aa0608f70..78a08039e173 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -32,6 +32,7 @@
 #include <linux/leafops.h>
 #include <linux/shmem_fs.h>
 #include <linux/mmu_notifier.h>
+#include <linux/zswap.h>
 
 #include <asm/tlb.h>
 
@@ -193,6 +194,79 @@ static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
 	spinlock_t *ptl;
 	unsigned long addr;
 
+	ptl = pmd_trans_huge_lock(pmd, vma);
+	if (ptl) {
+		pmd_t pmdval = *pmd;
+
+		if (pmd_is_swap_entry(pmdval)) {
+			softleaf_t entry = softleaf_from_pmd(pmdval);
+			struct vm_fault vmf = {
+				.vma = vma,
+				.address = start,
+				.real_address = start,
+				.pmd = pmd,
+			};
+			struct swap_info_struct *si;
+			struct folio *folio;
+			enum swap_pmd_cache cache_state;
+			bool split = false;
+
+			cache_state = swap_pmd_cache_lookup(entry, &folio);
+			if (cache_state == SWAP_PMD_CACHE_HUGE) {
+				folio_put(folio);
+				spin_unlock(ptl);
+				goto ret;
+			}
+			if (cache_state == SWAP_PMD_CACHE_SPLIT ||
+			    zswap_range_has_entry(entry, HPAGE_PMD_NR)) {
+				spin_unlock(ptl);
+				__split_huge_pmd(vma, pmd, start, false);
+				walk->action = ACTION_AGAIN;
+				goto ret;
+			}
+
+			/*
+			 * Pin the swap device under the PMD lock so the
+			 * PMD-swap-entry observation keeps the entry valid for
+			 * swapin_sync().
+			 */
+			si = get_swap_device(entry);
+			spin_unlock(ptl);
+			if (!si)
+				goto ret;
+
+			folio = swapin_sync(entry, GFP_HIGHUSER_MOVABLE,
+					    BIT(HPAGE_PMD_ORDER), &vmf,
+					    NULL, 0);
+			/*
+			 * The empty-cache observation was made under the PMD
+			 * lock, but swap cache can change after dropping it. If
+			 * PMD-order swapin lost a race to per-slot cache state,
+			 * retry through the PTE path.
+			 */
+			if (IS_ERR(folio)) {
+				if (PTR_ERR(folio) == -EBUSY)
+					split = true;
+			} else if (folio) {
+				if (folio_nr_pages(folio) != HPAGE_PMD_NR)
+					split = true;
+				else if (!folio_test_locked(folio) &&
+					 !folio_test_uptodate(folio) &&
+					 zswap_range_has_entry(entry,
+							       HPAGE_PMD_NR))
+					split = true;
+				folio_put(folio);
+			}
+			put_swap_device(si);
+			if (split) {
+				__split_huge_pmd(vma, pmd, start, false);
+				walk->action = ACTION_AGAIN;
+			}
+			goto ret;
+		}
+		spin_unlock(ptl);
+	}
+
 	for (addr = start; addr < end; addr += PAGE_SIZE) {
 		pte_t pte;
 		softleaf_t entry;
@@ -221,6 +295,7 @@ static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
 	if (ptep)
 		pte_unmap_unlock(ptep, ptl);
 	swap_read_unplug(splug);
+ret:
 	cond_resched();
 
 	return 0;
-- 
2.53.0-Meta


