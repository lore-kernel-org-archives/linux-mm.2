Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FD77CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 01:25:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9CD66B008A; Thu,  1 Oct 2026 21:25:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B74A76B008C; Thu,  1 Oct 2026 21:25:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A423E6B0092; Thu,  1 Oct 2026 21:25:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 609B86B008A
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 21:25:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 463ADA05B8
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 01:25:36 +0000 (UTC)
X-FDA: 85275943872.05.65B02EB
Received: from mail-dy2-f41.google.com (mail-dy2-f41.google.com [74.125.229.41])
	by imf15.hostedemail.com (Postfix) with ESMTP id 745BDA0008
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 01:25:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NXcEe02b;
	spf=pass (imf15.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.229.41 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790904334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vPgFvdEmNg2LQpD8kOy9w7TP6bBLZB6pMvT63vXQ9SY=;
	b=B1B/DDhve6BFB07ZA+8wQvMLgjf1msHhiVPu+0J2V5xwkXWZD3eNMCBwQmxTHNV+sIzIa0
	lXqPOdfhKM6ZkWkDRGfHyACBFvFbbO48DF10YBO/5eKrgLq5/rD5CLSaaxIEe/6KzNHEgY
	AOZNKTVJ/ycPX50zmmwOjRuRBY0FhHk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790904334;
	b=ldmQO2pJOIfIx5XYy412FoypGhDqHwdeT/63IMypWSL4SnMso5YlyxkcdhjjDmxkhon0rT
	Uz00HE0NAfEGrLduyi8TBZibU14yW5FiRMXQbYJS4gm6fJm0N8ixgenSCIWrekJpJ+t6Dq
	PYO0Wue2SPjDKbTMuEN3CA7esTlhucA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NXcEe02b;
	spf=pass (imf15.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.229.41 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy2-f41.google.com with SMTP id 5a478bee46e88-34cde269e1bso1779668eec.0
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 18:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790904333; x=1791509133; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vPgFvdEmNg2LQpD8kOy9w7TP6bBLZB6pMvT63vXQ9SY=;
        b=NXcEe02bXrV8LnA55w0GWSPJ26a/cBOUMR8urPma57tEICCAppArZH3ByPWv3FynxX
         lOc1Jr5fO/L+TcUPraddi2lB8h3cpBmJ0L+aUNHbS2Uw6W2++FwobgKvsWnCpLLkFNNn
         3Run2EHc2iHjbJgCd3GTUUNtFxIf3/6JxsMS6u4ZN883p8meyEWxa4ztaWhhIpY+INZx
         1CYO+BBbH6jiIKflm4Sc/mGYqKKQT04SfO/tl29NPUvSJlWvCfIci7T0nvYtXCi1U461
         ioPOF/Yyz3BLqncniwBFrLCD+7wiHMMByFkCWSsJMCsD5inzwBvXlh3hQqZ+51tMeJJu
         pzNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790904333; x=1791509133;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vPgFvdEmNg2LQpD8kOy9w7TP6bBLZB6pMvT63vXQ9SY=;
        b=2CkAhPGFmO15BsxQHS3om69TeDf820qelWxfw7SQJg9jrmaBg53vqpzGbdIkWZLZne
         k7TMlRFbbs5ZW9v3P+pFNZJxOsqzcRUaGYDD9SWyt4eJ4zUr6PZMSl7P+h5qXQwbVh8V
         M9owq5oqReC2hbRVdHzYbwdv+/RrMDymTYsnGqi8b6VW/Wgj7DTrNbJn+nQVBljROooI
         TdzHItpSb1rbYqw64aTueT0+n9brFUDxdFeD0N+HsHNqp5Gg9n6B3PZzFRkcRjXLxrng
         CapvAUkL81aZEr6ouP4ZOFB/BVYc+T8+cubjndOqnX73H+QyZyGGJ/7TAU/aUfm8g2vD
         +2yw==
X-Gm-Message-State: AFq9FYKyLM1xcAXKLTAuda2CU7qGuFiQrzs5tsqtnSYhiSc5/r3C425W
	Mbc5cAzzORm6URnqUE2B+9tff7612TXs+BCS6kOlJK2XSQKyas8+R+d2
X-Gm-Gg: AYBFou31u+aVqy24DO6qz2QX4iYdDCXN3a0JIqkuH9VaRqAE8kCN4dzH1e+OXHAKADM
	J08i8sc0mlxbJY7wmqM9hDl0nznsqS5SU2vvKfwcrdtQ15JewyfIwvPhcIwtTDIdGHKvAIBnfM3
	QQjF9BnBFShm5yESfKMBtGDxwdo0t6K0zTD6B1mEttN2n4SpaqHOjdk/0rKPrK98wtEiB57MyNk
	40fS1udhkaDF2nrVrOgsU/U1cmITkFmT+iRYxp6JslHL+TF3/3ngP+/xzbS+FNZW8QJwDuC51Ll
	UIHxIg+mDOa70BPL9mOWX0QT4G9BGAEWprlKQzG+fomhuA6PUrpw5kX2gCMi7CSGi/8CwTqMJ6N
	btzmkLJHg/ODMDcO0n4rK/HFSVE4HMF/55tc+IsbxHOKq2fUYZ3Y6TA95sSZi7V9hGn4+vXTMrh
	smzI0GTRFfAJX8hEud/KAWll2efrUsiwwXyZ94G79uW0icfmg2dEOBXsJHlxqVOrehGg==
X-Received: by 2002:a05:7300:828b:b0:34b:354b:79b9 with SMTP id 5a478bee46e88-34f15086754mr1109729eec.12.1790904333162;
        Thu, 01 Oct 2026 18:25:33 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34f14f984e4sm1837223eec.17.2026.10.01.18.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 18:25:32 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Fri, 02 Oct 2026 09:25:26 +0800
Subject: [PATCH v2 1/2] mm/migrate: walk runs of consecutive pages in
 do_pages_stat_array()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261002-bug-mm-move-pages-stat-batch-v2-1-f73b5d20519f@gmail.com>
References: <20261002-bug-mm-move-pages-stat-batch-v2-0-f73b5d20519f@gmail.com>
In-Reply-To: <20261002-bug-mm-move-pages-stat-batch-v2-0-f73b5d20519f@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Stat-Signature: r1amnrhymt4zyugsfg97zxk6hhwdeudn
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 745BDA0008
X-HE-Tag: 1790904334-19731
X-HE-Meta: U2FsdGVkX18zrpM0gRIoj9MXTUjGtGBqGZ73D4SE/4vC7VH5/6qZhdu0+zNVhQsyXpzq582VUszVlmIJJxJfNe7xdC5XqenspwAzNQcC4qeQpWjUzjDaemlEuoa3h4RZXK6utb8DIQAQ/ujVJgM3534pdRhdybvB6W334kyrS33Xaz/GeIgtBt0K2tVdgoJW7Mj1cyQ0bPHGXETux/PRVBSx7fIjAHCzxl7+FXR721TXPLTP04hg2JnHkoXSMkY8EvoLJ/Ljw/5kzURw1n+wAZi3seqmabiRc+ja9KIF0RPzxYU+JO60tHhUo90Ab/7ZA+MUSex6f1102BhAPfLcoJz+khpF93pqA3+bZAROpadDYqNVxGTrILWFptQYNneSa1WqMDfHyZbQ4C2FBfL3tA1+b4F8e1V6mXU4gnz32AdjeXiuCbl5rYC4op6gqvjO8UBS5Zder6eRqKkV3GOZVaFd8Ru2GTwuH8CgRC0sZ8D1oNB8iFDMINPi9FkATkR8NFvpZrVpKwhM0szEIhmDi8AoVn/eFWL/Hvp8G0/iu+Sl1RJaBmWqS5lFd6ysNFuMrQWVi7nUFDP94J7JhpjJzYYzYW+Uqz9hARroRiZ4wJGdDHNx0zaxTMtdGyEedrbGU279fpVF5rUWDlf3rzmdmvykaP8RMBOmt6k3KZY9wZA38pyWbmdrokoJ18QCt71U2W+nW38eIb1mZl48ASxI3NskAzq+iPnrn+wzEw5nbCwBq32Qqz1vAtr4O8nyDTFDadBLFybnsb19FJEVZy9g1p5RzXcluiqRkFpPFTPT2EfO1f3dX7SGfRajzMR7Dx7Zcl/Pi7tPvooZ1OIyx/Q9Hwc15AA7XwscUZ0yPq+pxvXLyzAS9TAd7WD6MQGYaYdCK3NmVVL8PsF57G5P9V1DOZ5FTtQjL+YfNF71x3Lvh7tp974xVHPk1mQ0fNYn7LSin8bJn7cfsF8cfjZgX8T
 /CrNy8X9
 vWfcPMjVEczPvwqA3dN/BHydAow8VfTv6H24/OPcUb6xbZT/0D5V6UYUHgef35simqRhg/oS1GVgyIdSOs3NQMz1dmS1JtvcGwxSK4qHuP7v/+SI/uh9bmPMnVRikVe8l9sEYuDFi98XsBplD6nMk2JNYcCUuE5Xh6k1s95uuze/cmPlWVNV39VHMf1t4Pr4QywzDAujajyhPKgLGNGYyn76pCP1qxVWiJxiS14rp2nN6+5qEZAZyoFHXghA05UMnsFehoMmZPz6UhLntHzMpewMz7y2EDC1ZvjrzcODw34gq/Z943AHwczPUD1yHomDjRiDHLHg0LSBK9z0gxEHJf3nn7u3E27WUqNY+80SuB27AL3V73VHaZIBFzdvoXoB6ovDSSxGbZvrIQfCH/ubS8P7TPb1O19xji4xf0HMIziUJ4JU36L+oJQp3868pL+2KwVq9cdLxzYKKcbEcpYo/oyVsYFNZ4BFVDWEjOMLBn3PxWOLSCG03VkZT3n0zUsGSrYsYtZqLzenM0Nw1//1NXzRdMZyLt92VPd8VtSPO691F7mCcAofk3wuZDfXyIdIPWSOT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

move_pages() with a NULL node list reports the node of each page. RDMA
and KV-cache transfer engines use it to find where large registered
buffers live, querying every 4K page of buffers that span hundreds of
gigabytes.

do_pages_stat_array() looks up the VMA and walks the page tables from
the top for every address, taking and dropping the PTE lock each time.
That costs about 105 ns per page, so a 16 GiB buffer takes 486 ms.

Callers almost always pass consecutive addresses. Group them into runs
and walk each run with walk_page_range(), which looks up each VMA and
PTE table once and answers every page under it while holding the lock.
Report pages as folio_walk_start() with FW_ZEROPAGE found them: the node
of a normal folio, -EFAULT for the zero page or an address outside any
VMA, and -ENOENT otherwise. Handle PUD and hugetlb leaves in their own
callbacks so that the walk never splits them.

On 7.3-rc5 in a 16-vCPU VM, querying every page of a populated 4 GiB
buffer:

                before    after
  4K pages      105 ns    31.9 ns
  THP           90 ns     23.1 ns

Suggested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 mm/migrate.c | 188 ++++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 162 insertions(+), 26 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 15b45832bcfa7..f4d8bfb9b7b4a 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2451,44 +2451,180 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
 	return err;
 }
 
+struct pages_stat_walk {
+	unsigned long start;
+	int *status;
+};
+
+static void pages_stat_set(struct pages_stat_walk *psw, unsigned long addr,
+			   unsigned long end, int stat)
+{
+	int *status = psw->status + ((addr - psw->start) >> PAGE_SHIFT);
+
+	/* end wraps to 0 for the last page of the address space */
+	for (; addr != end; addr += PAGE_SIZE)
+		*status++ = stat;
+}
+
+static int folio_stat(struct folio *folio)
+{
+	if (is_zero_folio(folio) || is_huge_zero_folio(folio))
+		return -EFAULT;
+	if (folio_is_zone_device(folio))
+		return -ENOENT;
+	return folio_nid(folio);
+}
+
+/* Report pages the same way folio_walk_start() with FW_ZEROPAGE finds them. */
+static int pages_stat_pud_entry(pud_t *pudp, unsigned long addr,
+				unsigned long end, struct mm_walk *walk)
+{
+	struct page *page;
+	spinlock_t *ptl;
+	pud_t pud;
+	int stat;
+
+	if (!IS_ENABLED(CONFIG_PGTABLE_HAS_HUGE_LEAVES))
+		return 0;
+	pud = pudp_get(pudp);
+	if (pud_present(pud) && !pud_leaf(pud))
+		return 0;
+
+	ptl = pud_lock(walk->mm, pudp);
+	pud = pudp_get(pudp);
+	if (pud_present(pud) && !pud_leaf(pud)) {
+		spin_unlock(ptl);
+		return 0;
+	}
+	stat = -ENOENT;
+	if (pud_present(pud)) {
+		page = vm_normal_page_pud(walk->vma, addr, pud);
+		if (page)
+			stat = folio_stat(page_folio(page));
+	}
+	pages_stat_set(walk->private, addr, end, stat);
+	spin_unlock(ptl);
+	walk->action = ACTION_CONTINUE;
+	return 0;
+}
+
+static int pages_stat_pmd_entry(pmd_t *pmdp, unsigned long addr,
+				unsigned long end, struct mm_walk *walk)
+{
+	struct vm_area_struct *vma = walk->vma;
+	struct page *page;
+	spinlock_t *ptl;
+	pte_t *ptep;
+	pmd_t pmd;
+	int stat;
+
+	pmd = pmdp_get_lockless(pmdp);
+	if (IS_ENABLED(CONFIG_PGTABLE_HAS_HUGE_LEAVES) &&
+	    (!pmd_present(pmd) || pmd_leaf(pmd))) {
+		ptl = pmd_lock(walk->mm, pmdp);
+		pmd = pmdp_get(pmdp);
+		if (pmd_present(pmd) && !pmd_leaf(pmd)) {
+			spin_unlock(ptl);
+			goto pte_table;
+		}
+		stat = -ENOENT;
+		if (pmd_present(pmd)) {
+			page = vm_normal_page_pmd(vma, addr, pmd);
+			if (page)
+				stat = folio_stat(page_folio(page));
+			else if (is_huge_zero_pmd(pmd))
+				stat = -EFAULT;
+		}
+		pages_stat_set(walk->private, addr, end, stat);
+		spin_unlock(ptl);
+		return 0;
+	}
+
+pte_table:
+	ptep = pte_offset_map_lock(walk->mm, pmdp, addr, &ptl);
+	if (!ptep) {
+		walk->action = ACTION_AGAIN;
+		return 0;
+	}
+	for (; addr < end; addr += PAGE_SIZE, ptep++) {
+		pte_t pte = ptep_get(ptep);
+
+		stat = -ENOENT;
+		if (pte_present(pte)) {
+			page = vm_normal_page(vma, addr, pte);
+			if (page)
+				stat = folio_stat(page_folio(page));
+			else if (is_zero_pfn(pte_pfn(pte)))
+				stat = -EFAULT;
+		}
+		pages_stat_set(walk->private, addr, addr + PAGE_SIZE, stat);
+	}
+	pte_unmap_unlock(ptep - 1, ptl);
+	return 0;
+}
+
+static int pages_stat_hugetlb_entry(pte_t *ptep, unsigned long hmask,
+				    unsigned long addr, unsigned long end,
+				    struct mm_walk *walk)
+{
+#ifdef CONFIG_HUGETLB_PAGE
+	spinlock_t *ptl;
+	pte_t pte;
+	int stat = -ENOENT;
+
+	ptl = huge_pte_lock(hstate_vma(walk->vma), walk->mm, ptep);
+	pte = huge_ptep_get(walk->mm, addr, ptep);
+	if (pte_present(pte))
+		stat = folio_stat(pfn_folio(pte_pfn(pte)));
+	pages_stat_set(walk->private, addr, end, stat);
+	spin_unlock(ptl);
+#endif
+	return 0;
+}
+
+static int pages_stat_pte_hole(unsigned long addr, unsigned long end,
+			       int depth, struct mm_walk *walk)
+{
+	/* No VMA at all is -EFAULT, a VMA without the page is -ENOENT */
+	pages_stat_set(walk->private, addr, end, walk->vma ? -ENOENT : -EFAULT);
+	return 0;
+}
+
+static const struct mm_walk_ops pages_stat_walk_ops = {
+	.pud_entry	= pages_stat_pud_entry,
+	.pmd_entry	= pages_stat_pmd_entry,
+	.hugetlb_entry	= pages_stat_hugetlb_entry,
+	.pte_hole	= pages_stat_pte_hole,
+	.walk_lock	= PGWALK_RDLOCK,
+};
+
 /*
  * Determine the nodes of an array of pages and store it in an array of status.
  */
 static void do_pages_stat_array(struct mm_struct *mm, unsigned long nr_pages,
 				const void __user **pages, int *status)
 {
-	unsigned long i;
+	unsigned long i, n;
 
 	mmap_read_lock(mm);
 
-	for (i = 0; i < nr_pages; i++) {
-		unsigned long addr = (unsigned long)(*pages);
-		struct vm_area_struct *vma;
-		struct folio_walk fw;
-		struct folio *folio;
-		int err = -EFAULT;
+	for (i = 0; i < nr_pages; i += n) {
+		unsigned long addr = (unsigned long)pages[i] & PAGE_MASK;
+		struct pages_stat_walk psw = {
+			.start = addr,
+			.status = status + i,
+		};
 
-		vma = vma_lookup(mm, addr);
-		if (!vma)
-			goto set_status;
+		/* Walk runs of consecutive pages in one go */
+		for (n = 1; i + n < nr_pages; n++) {
+			unsigned long next = (unsigned long)pages[i + n] & PAGE_MASK;
 
-		folio = folio_walk_start(&fw, vma, addr, FW_ZEROPAGE);
-		if (folio) {
-			if (is_zero_folio(folio) || is_huge_zero_folio(folio))
-				err = -EFAULT;
-			else if (folio_is_zone_device(folio))
-				err = -ENOENT;
-			else
-				err = folio_nid(folio);
-			folio_walk_end(&fw, vma);
-		} else {
-			err = -ENOENT;
+			if (next != addr + n * PAGE_SIZE || next < addr)
+				break;
 		}
-set_status:
-		*status = err;
-
-		pages++;
-		status++;
+		if (walk_page_range(mm, addr, addr + n * PAGE_SIZE,
+				    &pages_stat_walk_ops, &psw))
+			pages_stat_set(&psw, addr, addr + n * PAGE_SIZE, -EFAULT);
 	}
 
 	mmap_read_unlock(mm);

-- 
2.43.0


