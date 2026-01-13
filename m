Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED93CCF45CB
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 01:42:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FD8B6B0005; Mon, 12 Jan 2026 20:42:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BE1F6B0088; Mon, 12 Jan 2026 20:42:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A9866B008A; Mon, 12 Jan 2026 20:42:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 387956B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 20:42:10 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C8004161424
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:42:09 +0000 (UTC)
X-FDA: 84325239978.25.5104DFA
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf18.hostedemail.com (Postfix) with ESMTP id BA62D1C0007
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:42:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qQdsLnNT;
	spf=pass (imf18.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768268528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nSg0Sr0i9/iYvNCth7dJcLGX3q29Co2e1nhK6hxIKwk=;
	b=nnYVu9kgmo8saE6WCQHKWJUMS6+Q0VTv7Y1VyrqBc9Oz0vNK7PlcviP2ZXHZiHVlEyNufO
	BsSOQ9KtCeBFveLJ02n2jYE8WcFnpiHRCbqhnw4mUckgoSQNkM2LNzFdyvh1nwizfJL6Ge
	dAet147SFcrRFkNqsfU+cCXJZHU4Urk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768268528; a=rsa-sha256;
	cv=none;
	b=njroW4roJ6Tff2BZUC90rs96DF+0ua8l66XMWoXUwd5X6+U2Kih34pOF+8H2mmNu6FCb/t
	x5buznQ3SDTwjlTRD3EUPzptBl4TpW6CL+1shta9XmFrpHhfeteVrNDh8/yCJ2cZ1JgFwJ
	Wnu57sAQGZq07r6Bcvq8u/cZcYOhU3Y=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qQdsLnNT;
	spf=pass (imf18.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768268522;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nSg0Sr0i9/iYvNCth7dJcLGX3q29Co2e1nhK6hxIKwk=;
	b=qQdsLnNTTE+YrJwkG2yOWnHtvAm+Yz6NIIuLvq5zg9JTyNYbGlCgXhoeb5qUBlwb9WF/xf
	OY0BqSuNvMAROtLhxwfgff4ioqYEtWiVQa2DghEqknCoeia4Mzah4p9rNONsa1zMjqlijp
	/fh+8UELvGXP/yEGj7x6BG3MHVAL470=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Ye Liu <liuye@kylinos.cn>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH] mm: remove redundant page parameter from do_set_pmd()
Date: Tue, 13 Jan 2026 09:41:29 +0800
Message-ID: <20260113014130.922385-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BA62D1C0007
X-Rspam-User: 
X-Stat-Signature: 48m3m13ruwz3cqixu595yoxyzpecdn5y
X-HE-Tag: 1768268524-718043
X-HE-Meta: U2FsdGVkX1/a8yCtSHiO3k3Kb0/DXQBVtDcMZPgWGi2zUQ64v1PZPt63UGpg51gUOu6csnMG1HiIZjZpBq2tC3jNoUhLmbWYFwN7LDLw4Kd1cOOcAbOJNJNrUr983R9Pl66wFi+szNI04ldsr5jKhcVX7p4nChKnB4TVF6trz/UHw2CMDWzkJUvu42YOugvpIGlj3OW4R/cxUy/eCW91UTxfu3SRXj0uWzC1mwSuBQFxiQd8HeTtrCX2xdS+XFcnMLWyAuh8jR7uuPTuEHrj3r83gvRhLV2ye1+aJJTm4I97d64B0CxVJCbzwU8hEhVAIYYpCGyHeaP9kp9jUOJJoTYrUieF6Um9gl6dFPWD8QjDi32AUUDhwRxT9+zzMZuValwN0lQ/AIEb33WfTNlNxmcOwDReonC26cTJ6rFzrHFYFVZISxpxjC1rm/jcib1gGdwdYRDT/k2XShOGukq1clCGb6Qj9wI62gK4UozeF6UTBETjULP4yJJRHGbvQvjJCir9RN2Ya7cVE8vjUwcQDuMija04dx/LAgLu/x/giZsVKptTSM5ctxR0mxWQY88dqsSSqqZ30WP6RmKGLJGlNE6jHuNPJ85RfSf2tBlkCZZfRbSBKlChxLerCRx1y+DSYRBu58EKN4iUji6ArMTfttXGk/Dq50FduEJdZ8Y24P9tM8cxt1nWoxSnazvx77F4wyBE3KVWFUekwKdEznH1lW+jq1l5CTMZ4IBhDLwOcsGEqI2iu6kN3aGPuABYHZmsTzIU+CS6H5rhh2lb5hTkTiq1WpnLAS1TybyvKUepEZm7AZ4n4XzLcWnH1EFTVKfuT1fOvOjGnqL9yKWCwzhMIPJ7nm4us28ojM6cKk/q3NgzMrFTfPDpGL2XHhCFW7hLmaeF6zdCGc1QP1N3FP5WKcJ0lZecotKUm7vE7AQmZ4TA5ADgf83AeS5cK52nb4SRFueMN90vhGWqjEvRz50
 x2mJh7wm
 Nqyal3iv8i5AkAt0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

The page parameter passed to do_set_pmd() was always overwritten with
&folio->page immediately upon function entry (line 5369 in memory.c),
making the parameter completely redundant. This confused callers who
computed different page values only to have them ignored.

Changes:
- Convert page from a function parameter to a local variable
- Update function signature in both implementations and stub
- Remove unnecessary folio_file_page() calculation in filemap.c
- Update all three call sites to remove the page argument

This simplifies the API since folio already contains all the page
information needed. The function still uses &folio->page internally
for cache flushing and rmap operations.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 include/linux/mm.h | 2 +-
 mm/filemap.c       | 3 +--
 mm/khugepaged.c    | 6 +++---
 mm/memory.c        | 7 ++++---
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 710d20fc954b..cb1fe75575c3 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1490,7 +1490,7 @@ static inline pte_t maybe_mkwrite(pte_t pte, struct vm_area_struct *vma)
 	return pte;
 }
 
-vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page);
+vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio);
 void set_pte_range(struct vm_fault *vmf, struct folio *folio,
 		struct page *page, unsigned int nr, unsigned long addr);
 
diff --git a/mm/filemap.c b/mm/filemap.c
index ebd75684cb0a..4be5f3f5b8d6 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3678,8 +3678,7 @@ static bool filemap_map_pmd(struct vm_fault *vmf, struct folio *folio,
 	}
 
 	if (pmd_none(*vmf->pmd) && folio_test_pmd_mappable(folio)) {
-		struct page *page = folio_file_page(folio, start);
-		vm_fault_t ret = do_set_pmd(vmf, folio, page);
+		vm_fault_t ret = do_set_pmd(vmf, folio);
 		if (!ret) {
 			/* The page is mapped successfully, reference consumed. */
 			folio_unlock(folio);
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 9f790ec34400..2d7b23efa11b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1442,7 +1442,7 @@ static void collect_mm_slot(struct mm_slot *slot)
 
 /* folio must be locked, and mmap_lock must be held */
 static enum scan_result set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
-				     pmd_t *pmdp, struct folio *folio, struct page *page)
+				     pmd_t *pmdp, struct folio *folio)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_fault vmf = {
@@ -1470,7 +1470,7 @@ static enum scan_result set_huge_pmd(struct vm_area_struct *vma, unsigned long a
 	}
 
 	vmf.pmd = pmdp;
-	if (do_set_pmd(&vmf, folio, page))
+	if (do_set_pmd(&vmf, folio))
 		return SCAN_FAIL;
 
 	folio_get(folio);
@@ -1678,7 +1678,7 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 maybe_install_pmd:
 	/* step 5: install pmd entry */
 	result = install_pmd
-			? set_huge_pmd(vma, haddr, pmd, folio, &folio->page)
+			? set_huge_pmd(vma, haddr, pmd, folio)
 			: SCAN_SUCCEED;
 	goto drop_folio;
 abort:
diff --git a/mm/memory.c b/mm/memory.c
index 30a897018482..8b29ecbfe7fa 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5342,8 +5342,9 @@ static void deposit_prealloc_pte(struct vm_fault *vmf)
 	vmf->prealloc_pte = NULL;
 }
 
-vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page)
+vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio)
 {
+	struct page *page;
 	struct vm_area_struct *vma = vmf->vma;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
@@ -5418,7 +5419,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	return ret;
 }
 #else
-vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page)
+vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio)
 {
 	return VM_FAULT_FALLBACK;
 }
@@ -5542,7 +5543,7 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 
 	if (pmd_none(*vmf->pmd)) {
 		if (!needs_fallback && folio_test_pmd_mappable(folio)) {
-			ret = do_set_pmd(vmf, folio, page);
+			ret = do_set_pmd(vmf, folio);
 			if (ret != VM_FAULT_FALLBACK)
 				return ret;
 		}
-- 
2.43.0


