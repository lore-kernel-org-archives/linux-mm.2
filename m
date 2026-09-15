Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2E1DC88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:24:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFB846B009F; Tue, 15 Sep 2026 11:24:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAD136B00A4; Tue, 15 Sep 2026 11:24:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B25EC6B00A7; Tue, 15 Sep 2026 11:24:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 953FC6B009F
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:24:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 230A516043D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:24:24 +0000 (UTC)
X-FDA: 85216368048.04.68CFE5D
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6273BC0005
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:24:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=RRHRd0NT;
	spf=pass (imf22.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789485862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xu5Nis9Fy2g0jTkf2lh9NOxXBZCd0nEic7P0WemrVuw=;
	b=EJgFg6ahQC1IsIIzi3CVR9v4eqfoc9Etg71d2xGBLxAbTabrAjMM9o/9L9ffhMohFnddTJ
	tWAb25zCGvsf4SLKFCcjgTO9AoJLzYI4GNZSwMlcmuNCM1dsAQNJjJZ2uc6menCiQ19Oxq
	APpkOL65AQR1cqBhGGrNQwWxSatVsj0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789485862;
	b=6sGi6cfnTzYIsiCljvF9mhlrWgGq6fxkOnK400jGsUy1H8zy8b0DX9DgtUFi9SO0NgYSDP
	cvodPJiPiZLS1e8mAdZzFfP/YMIilKf/3M1IMIXqDmITz/TOtjH7wnptSd8QS+NRUdGmTc
	FcvCLlPOeGUTpymnPiE1WE+wJJakcj0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=RRHRd0NT;
	spf=pass (imf22.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Xu
	5Nis9Fy2g0jTkf2lh9NOxXBZCd0nEic7P0WemrVuw=; b=RRHRd0NTVaD+w5oNbI
	CUDrJxEGXYIpd3Sdv/4Wy0hWN7eOpoqjW7JO86FAiwKKamvtKuuOv7gGKi8wUiKB
	Mvo+GhjM7/E3v2Fgmh+v64W/ETTAqPYj4yeMlg/wQ5UMBzOc2SkPCVA/GEhW8cVM
	/AgKFvoht248hcYg0wBaXQU5o=
Received: from VM-0-3-ubuntu.. (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wDHvVwYY6lqm28iAw--.18968S3;
	Tue, 15 Sep 2026 23:24:09 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Longlong Xia <xialonglong@kylinos.cn>,
	David Hildenbrand <david@kernel.org>,
	Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 12/14] mm/ksm: take the ksm folio in try_to_merge_one_page()
Date: Tue, 15 Sep 2026 23:23:48 +0800
Message-ID: <20260915152351.7955-2-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260915152351.7955-1-xialonglong2025@163.com>
References: <20260915151236.5200-1-xialonglong2025@163.com>
 <20260915152351.7955-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDHvVwYY6lqm28iAw--.18968S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxXF48AryfZFy5JF48Cw17Jrb_yoW5Cr1UpF
	Z2kasrCrW7JFWruryxAr4qyr1ak3sxtay0yF13J3y3Aa43t340kFyfKa4rArW3XrWrCa1f
	tw4UAF1jgay5AwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jzwZcUUUUU=
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC+Bnj3GqpYxl+CwAA3S
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6273BC0005
X-Stat-Signature: po95krubbog4cbycy64wd5yqudjzi8tq
X-Rspam-User: 
X-HE-Tag: 1789485860-805560
X-HE-Meta: U2FsdGVkX1+/9uCIz6IdQmvoP5xuemhkDUewgfYaX0q+SQRlaNkbwzvyyj6Ncx/P8tFFoZcMRD5ygpG5wF/2t+WPp72nOl13ljBN7/EzxAd3n/4QfCDNmDrAXfOrlSG3J2PskMrIhsQOjswOGqbaS9VKsd/SFywMkwn/PN3LsRgkvQmuxmvBTCze7ZzkuYEGBBopC1B9cBidx9VUJbWnV1p7j7TNuWh/76ZqMy49VZWmiKpaTIdXSPFAYYFJDkc032i9ciU10zI6sqSdKt9pxnEa7qy1eBRybdVAvoD1tMKxDNVSfCJXstTJKWL1nfrUJ4aA0LLEunDr58/7ymlpWdRCgnsSnLL+DCn1Oo4qxQiLRcUS6V+7ss/i4jVXXf8ZMicTAB0e/P8x85SdobjqeP/JTBenc/b7jNqWp6nXn2p/H1rBkDlJ532CqILHmi/8lSGXadXzMyGhhxitTrs+Vuvz0iBVU0H6va+/VAa5Jn+BU1qolPliDayzA8VmFryoK8S9v9fspfC0TosVka73tqdFmUZQQqgxu1M+Chd+T2YDbycOFG0ZVDx0kAuTWFuxsIlTuxVd8RuiWxhynJygrF+Kp4iwohQc+hQ3nz9hW9HDUlioFLfwn0XVjUQFkF02J6UtYGp3DWicdtGCEkIXqVypJabHUH8nyjGTu6hth2g0dABLFJK8/iwTUn1S7dJ1muc2a7Y88krpWyEIabObDdKHVaXzIWFpDI9wJAsVq4YnaSqDL1gXwT8qgissKAQE17akwsL3OG7VEmWWZOXFc29I2tusUJqD6RP4d0zmX5KtUlJ4iNpyy1Dm0OlEk28B36x6dMWebLw1sS5owsPYvno4EC+oB/0FUp0eZ1m8YU6kCUx5JG5LGcgWZ+ja/CZS/ieF0jeHmMbowClWb9qR5PnkM8cfs2Olgq+pv/rOMeFCeJO7xDMejfYTlAGyWBPTI0AdDgQiEKRCg+Zej2p
 PVky5fYU
 VOzLXTprHJo7uS3qZ96StWfHuz/0IhaOj3BNUhT/8UEL60IoEN/5E259uSKNk4aJpmrcCtAGkaaKU+RMdUUXcIZ9DrvHdi/PgPj56iLN73MjrhOExSHXPer+IiZQQcSAJ2n+dcjJR+sPpB8afZaz+oCONxrmKTvun/SQ8G/Plj9nPuLq2pbeYrZvFxQ9kz4eugyTj7A19nzksb5IetEs/NQeKHHCuUOidpWr0AkrhPsIlcE+fZgwckZRm0okI/dnuB3SO3m6DPyudT/BlINurnUkdniPMwMDLjzNr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

Pass the order-0 KSM or zero-page target as a folio, preserving NULL
for the initial KSM upgrade. Keep the source as struct page because
it may be a tail page of a large folio that is split before merging.

No functional change intended.

Assisted-by: Zcode:GLM-5.3
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>

---
 mm/ksm.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 4a4347e9ce39..10fcae7132b1 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1556,20 +1556,20 @@ static int replace_page(struct vm_area_struct *vma, struct folio *folio,
 /*
  * try_to_merge_one_page - take two pages and merge them into one
  * @vma: the vma that holds the pte pointing to page
- * @page: the PageAnon page that we want to replace with kpage
- * @kpage: the KSM page that we want to map instead of page,
- *         or NULL the first time when we want to use page as kpage.
+ * @page: the PageAnon page that we want to replace with kfolio
+ * @kfolio: the ksm folio that we want to map instead of page,
+ *          or NULL the first time when we want to use page as ksm page.
  *
  * This function returns 0 if the pages were merged, -EFAULT otherwise.
  */
 static int try_to_merge_one_page(struct vm_area_struct *vma,
-				 struct page *page, struct page *kpage)
+				 struct page *page, struct folio *kfolio)
 {
 	struct folio *folio = page_folio(page);
 	pte_t orig_pte = __pte(0);
 	int err = -EFAULT;
 
-	if (page == kpage)			/* ksm page forked */
+	if (kfolio && page == &kfolio->page)	/* ksm page forked */
 		return 0;
 
 	if (!folio_test_anon(folio))
@@ -1597,7 +1597,7 @@ static int try_to_merge_one_page(struct vm_area_struct *vma,
 	 * case, we need to lock and check page_count is not raised.
 	 */
 	if (write_protect_page(vma, folio, &orig_pte) == 0) {
-		if (!kpage) {
+		if (!kfolio) {
 			/*
 			 * While we hold folio lock, upgrade folio from
 			 * anon to a NULL stable_node with the KSM flag set:
@@ -1612,9 +1612,8 @@ static int try_to_merge_one_page(struct vm_area_struct *vma,
 			if (!folio_test_dirty(folio))
 				folio_mark_dirty(folio);
 			err = 0;
-		} else if (pages_identical(page, kpage))
-			err = replace_page(vma, folio, page_folio(kpage),
-					   orig_pte);
+		} else if (pages_identical(page, &kfolio->page))
+			err = replace_page(vma, folio, kfolio, orig_pte);
 	}
 
 out_unlock:
@@ -1644,7 +1643,8 @@ static int try_to_merge_with_zero_page(struct ksm_rmap_item *rmap_item,
 		mmap_read_lock(mm);
 		vma = find_mergeable_vma(mm, rmap_item->address);
 		if (vma) {
-			err = try_to_merge_one_page(vma, page, zero_page);
+			err = try_to_merge_one_page(vma, page,
+						     page_folio(zero_page));
 			trace_ksm_merge_one_page(page_to_pfn(zero_page),
 						 rmap_item, mm, err);
 		} else {
@@ -1678,7 +1678,7 @@ static int try_to_merge_with_ksm_page(struct ksm_rmap_item *rmap_item,
 	if (!vma)
 		goto out;
 
-	err = try_to_merge_one_page(vma, page, kpage);
+	err = try_to_merge_one_page(vma, page, page_folio(kpage));
 	if (err)
 		goto out;
 
-- 
2.43.0


