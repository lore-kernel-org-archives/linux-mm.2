Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E669CA0EF8
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 09:07:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6F068E0040; Wed, 20 Aug 2025 05:07:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAA298E003E; Wed, 20 Aug 2025 05:07:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4ADF8E003F; Wed, 20 Aug 2025 05:07:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 873EA8E0009
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:07:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1373BB97FA
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:07:44 +0000 (UTC)
X-FDA: 83796558048.23.69409A4
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1D8BE1C0006
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:07:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=xrpJYgPT;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755680862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ei9u2YF++6MO0lYBeBOSJFHTc0M7jUeUTkqRnIOPTM8=;
	b=CGwFz3yEo1Su5Jc/gQ68xTWn94dCCjDGxyURCQ+mc9WvkySvVEd8SaHx/pcSVawQlVr1lJ
	/wQCasBfWVEI5eQFPrDhqJgaupxeZAf0JqSO5dkhHK3MWovUB9WoNCtP4d0HXu+W9jpavK
	20GQxYBz7lbPnaqpMZYrNUO4gQyfCJk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755680862; a=rsa-sha256;
	cv=none;
	b=Y3Wg/JeETqto3HSe3leP4xk/20x6CzF7fc3XUTK42pRrMyXboGa31tYG+ELoAOpdCDoouz
	cZMsiAOKVzqr1+A+d4cBpvKQmLoUKaoFL2BUf4I5We6CudA5ZeC/fkgv/YNm8F/KpSYydt
	ZAEh6/GkQZPdwRP49HIzytcqCVysJ4Y=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=xrpJYgPT;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755680856; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Ei9u2YF++6MO0lYBeBOSJFHTc0M7jUeUTkqRnIOPTM8=;
	b=xrpJYgPTaQo7Q6rDSbM1KZX3XDCmznbywwzdc8gJemvJJieGYkBUWmtgKEagR/oJh0IDHQXvYNPS0olbDJ2Al17Q39RIYRQsth4Kkv3bpsdGoZw8I9JfF5fvFV4IkEZ6bb3LFhzhM/5Y9JLooiKBXz7yAsHlgdKBuiSh+bO+CVs=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WmBICrd_1755680855 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 20 Aug 2025 17:07:35 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 02/11] mm: khugepaged: generalize collapse_file for mTHP support
Date: Wed, 20 Aug 2025 17:07:13 +0800
Message-ID: <6a2f28b4541bbbc56ea9e07f24b67cef87899a50.1755677674.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1755677674.git.baolin.wang@linux.alibaba.com>
References: <cover.1755677674.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1D8BE1C0006
X-Stat-Signature: tyz4z8eoojb13ntycedsexzdp8rnagrf
X-HE-Tag: 1755680861-223561
X-HE-Meta: U2FsdGVkX1+PfqvlQTyNKE23m86KFekXcTtWJngr2pKvZ0wKwgREK3ezc7Rxy28vEn/ZcaQhapJOLUjEMc//5eah7m1dY2pqYtAOwmRmcfLHQFH1RQfgzFmKDpWs9HxMa7N6kC0IiaxfSQKItpkNoUl91b0lFH+o6Tyg77a88g5zp/vlVQdIr6gVMN2xECUTIotvjZSbuP7pLq07OF1TdFUlwcFkgeOnpGE0Qj/9fo6MMQHLcXaQXeXzGadR5gAiX+9PivFJbIZK0a7ohfRoBwMrcz8mJIZsLS3pFvDrTKeIGIq7uAcqzOrovMvEq/dGwAwKJH4GCrKWe3vdCuRx6sDigiyIjdWcja5UkHWGW9Z0X7Rjcho51BCbmvPtw/m6zOoxV3seFMraiP0u5ILT1gxezWmvD8O0QkifFBGiisJdnfnku40A0z5vesR4YoWXqT/BT3v+dHO607OV4Fp39ozJNK5vVwkoS0vOUFeIGcajfRC1sL/Emp8/hqrErC+NYPjuTPdqElKhsxgF7W6UZRX03zumSdb7XvjYd2/B9/doVfDLnBxSGlIR+JAq90uk0DnZuYelrj0dPiW86tbWiA5hlL5OTXFpUgQAJH8a+8n8EitqLNwr9C/zjeZWgCHStMZtDuJxE8Tzx+xoErcCinMFvPCGT4VYMkUmTSqOpwr/8vThyfioWo1xcEd4Sc9tH3jG3p0oNPo0xqAZn24Q6KlUgS1SgFT+Ps3++RZDvrsT0WMmfObi5lzScOieVA9FzoIL6fFh+mUaR98NgWpzWE+ry5vQtXki3KHmwmqIcQifNmF3PH1nmXEOu0RknYCneBtH1OoHFuDeFWpr0D/MsJeE4MboJA0YHwHbQR4uIe7IyW5xqh3S89jh5ZiwiyVaBCcuPpAc3Ccjf8s1+xIxHtIsSaM8053n99c5aUmyv8SI5zPaJ7U7jobPiN90d6yLJDnKiuvxcJZFLBmWCW/
 ZcMs18tP
 eoUBsbph3rx/sT9wz5kwlwXd0NMKXzo2Q3GOIcZ8BPO/ypauwgBrKog8Iu6q/ZFphtRqAAkq+jCe0JegYLWVB1UeTC8CGs1R210TDJhyLVodHGvtzD7fkYIKIc3SxB/owCT8zXXAPsX3Tz7QEI4XQxB5i8i6I2AV/lczw+OaMlKKLMYClUtR0cdDDvF6z0qqCPNOVj6dJgPMyS6F7dRNBP6qo4U+QFiyyHx0kPgwBWGWEl6EV/8J80pR3bdLiVMSfm/m3awZ80SiI0E4qZjDvjN+qnrhJwuzSqb52L1fm56BEgYkMeeU0e2Ni8ktih7ceR7dF9GcHUrbp2vg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Generalize the order of the collapse_file() function to support future
file/shmem mTHP collapse.

No functional changes in this patch.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/khugepaged.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 5d4493b77f3c..e64ed86d28ca 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2064,21 +2064,23 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
  */
 static int collapse_file(struct mm_struct *mm, unsigned long addr,
 			 struct file *file, pgoff_t start,
-			 struct collapse_control *cc)
+			 struct collapse_control *cc,
+			 int order)
 {
 	struct address_space *mapping = file->f_mapping;
 	struct page *dst;
 	struct folio *folio, *tmp, *new_folio;
-	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
+	int nr_pages = 1 << order;
+	pgoff_t index = 0, end = start + nr_pages;
 	LIST_HEAD(pagelist);
-	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
+	XA_STATE_ORDER(xas, &mapping->i_pages, start, order);
 	int nr_none = 0, result = SCAN_SUCCEED;
 	bool is_shmem = shmem_file(file);
 
 	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
-	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
+	VM_BUG_ON(start & (nr_pages - 1));
 
-	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
+	result = alloc_charge_folio(&new_folio, mm, cc, order);
 	if (result != SCAN_SUCCEED)
 		goto out;
 
@@ -2426,14 +2428,14 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	 * unwritten page.
 	 */
 	folio_mark_uptodate(new_folio);
-	folio_ref_add(new_folio, HPAGE_PMD_NR - 1);
+	folio_ref_add(new_folio, nr_pages - 1);
 
 	if (is_shmem)
 		folio_mark_dirty(new_folio);
 	folio_add_lru(new_folio);
 
 	/* Join all the small entries into a single multi-index entry. */
-	xas_set_order(&xas, start, HPAGE_PMD_ORDER);
+	xas_set_order(&xas, start, order);
 	xas_store(&xas, new_folio);
 	WARN_ON_ONCE(xas_error(&xas));
 	xas_unlock_irq(&xas);
@@ -2496,7 +2498,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	folio_put(new_folio);
 out:
 	VM_BUG_ON(!list_empty(&pagelist));
-	trace_mm_khugepaged_collapse_file(mm, new_folio, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
+	trace_mm_khugepaged_collapse_file(mm, new_folio, index, addr, is_shmem, file, nr_pages, result);
 	return result;
 }
 
@@ -2599,7 +2601,7 @@ static int collapse_scan_file(struct mm_struct *mm, unsigned long addr,
 			result = SCAN_EXCEED_NONE_PTE;
 			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
 		} else {
-			result = collapse_file(mm, addr, file, start, cc);
+			result = collapse_file(mm, addr, file, start, cc, HPAGE_PMD_ORDER);
 		}
 	}
 
-- 
2.43.5


