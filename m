Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB53EC83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 15:06:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6508B8E0008; Tue, 22 Jul 2025 11:06:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 600E58E0001; Tue, 22 Jul 2025 11:06:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 517088E0008; Tue, 22 Jul 2025 11:06:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3DC308E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:06:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0561F1A046B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:06:23 +0000 (UTC)
X-FDA: 83692226646.29.6F7A244
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4996616000F
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:06:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753196781; a=rsa-sha256;
	cv=none;
	b=66RQmg9P6d9eaG1rjjI6Yji0wgE1Vl/mFjp+cDbE34JSH0QYisVnHD2M5FY/tfZRhIhm10
	vhYYgtjbUUtcRidReVW0XcbbPr+xVyeQnVzFhQBloUFxZMxgGt4/9CtwAw28xMyXtan64R
	wiDq6hNsDfLDBRsOvB6cByptF3vDAXI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753196781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5mOzDk0Lppa/EndYaC8AJRDYvSwmdeQhoWbI92eh81U=;
	b=g5iUQ0WwdC5YKwrOm1ryV+Kz4Hj89djUKQUyo7EB3w59oeuma1mH/w122O1WsTlZRYh6ms
	pmRUVN3NN8fQlUo4+Z9dm4pkMxuPbFFB60M/7g/Aa09gIWSKF/k65XxQ1TrBm4IIPaPWQq
	w0Fqz2zP8W2Lht3tqgFddc3xNWPY2c4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BD631152B;
	Tue, 22 Jul 2025 08:06:14 -0700 (PDT)
Received: from localhost.localdomain (unknown [10.163.92.223])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 46B723F6A8;
	Tue, 22 Jul 2025 08:06:16 -0700 (PDT)
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@redhat.com
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	baohua@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH v3 1/3] mm: add get_and_clear_ptes() and clear_ptes()
Date: Tue, 22 Jul 2025 20:35:57 +0530
Message-Id: <20250722150559.96465-2-dev.jain@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250722150559.96465-1-dev.jain@arm.com>
References: <20250722150559.96465-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4996616000F
X-Stat-Signature: 85scejxuq7nrwati7rhrim5bkd1wsw5o
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753196781-196006
X-HE-Meta: U2FsdGVkX1+jHeZEvv0OaQ9zDjWJz9QDyVcpqW2mIPkJSwx9oG9Q2TAa5ViZoYCgffMUYmdL8psPjRHJYaVQtnKlE0yFCYiHSO+5HGp8bBjY1bDdMq/qaRWAcv3DRYKpIcqtepuyXLx+Xh5J5ZBrH6RPenQwL/3kE55K2VO7pg1aw4ybfZJcEWJHQXdgtQwJPe7m1/Mu0i8Vxht04DBeEzU0SDM6KM3tUwcZuhikcpEm1v9LvaGRhauabErB6nQAr5NxnMU9sN623v5kYNM3KSHu0R7grxJ1yJkciBe5gZ0fGYBPHFdxBOPriqgE2rhKZYwqj3xovZbyZd2pTEc2x9wUm/04TBqUY5Bv9Mbn+8RtSAqIk63WNWPPraed1m5oQ3Us2Tb1y19FHzWjEcyYXmqf4kcG5atv8/cWhZJoABo+lI3wWfPUz1xgF1HPx/hDe+h0DWzzqczaiTC3w5dHgKTOaCFtfipg0UoXtaPk+D5Obyc3KkK+F/ZK1rFsbo9zu+3qupM5aGEt0AOkiHfnwZht9FYA2wJhbb7ruDHy0rdtnhA4UByd15AsNK9X9W2R6XqfwhBNN86VhDR0Z54jLtvY4KOrtThPbcOt/ubZU7J79MxilgoFm+ChCAaKsf2ajIbEOKNqha3yd4+NM/wzjLBUwmroylVVfHvk081aFVSgi4Gg+eddISUiLViIWrYQwpPYSCyRwK8iexmOiKAEgSCX9lFzd21z2CgtkY+pDFPk0rO6tOm4Q3WjRJO/ayWOetAth4IJqCi9fBxjAtO051aoIFkVnA7lSpuzhqs7dyIyxd9HV1eDfK3HksLr/jz8JZkbxhSYOjmP3mM4bId8XkY9XrcpVPtYsAFKGZ30yKk7hhIWQc9lZTYuTqGTMLdydi9bqa0s4spvReyn490vq42XiMb837uBih9iNdPtadHFNATlE/1LGq0HVlCXG/CI4f/zlnJZcqxbgRyxcRA
 KhCma6sA
 ylSMwE3LdE2qzxX1QQM31DjPWJ8Ehz9h+Z+KdxfBKyFCSZLO1p6yEJrpffR/GmQPlxexog71eqSMYsLyY4livnuA8kt32sweXowdb/XTD9mo2eqAmOQeejJL16J08BBCulUABN27IUi32q46lwElwEyVdNKI3//WFYrbaeDsxBNB7XgB5llfyj4rJ2ucRmaNjgbmn0oiRRnGNGL/DHTGXZXigGyb65tu0GQXABZvIMvLLGkP3Rv9cjFBxkxpna/ftZDHh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Hildenbrand <david@redhat.com>

From: David Hildenbrand <david@redhat.com>

Let's add variants to be used where "full" does not apply -- which will
be the majority of cases in the future. "full" really only applies if
we are about to tear down a full MM.

Use get_and_clear_ptes() in existing code, clear_ptes() users will
be added next.

Should we make these inline functions instead and add separate docs?
Probably not worth it for now.

Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 arch/arm64/mm/mmu.c     | 2 +-
 include/linux/pgtable.h | 6 ++++++
 mm/mremap.c             | 2 +-
 mm/rmap.c               | 2 +-
 4 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index abd9725796e9..20a89ab97dc5 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1528,7 +1528,7 @@ early_initcall(prevent_bootmem_remove_init);
 pte_t modify_prot_start_ptes(struct vm_area_struct *vma, unsigned long addr,
 			     pte_t *ptep, unsigned int nr)
 {
-	pte_t pte = get_and_clear_full_ptes(vma->vm_mm, addr, ptep, nr, /* full = */ 0);
+	pte_t pte = get_and_clear_ptes(vma->vm_mm, addr, ptep, nr);
 
 	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_2645198)) {
 		/*
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index e3b99920be05..e45986b54277 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -736,6 +736,9 @@ static inline pte_t get_and_clear_full_ptes(struct mm_struct *mm,
 }
 #endif
 
+#define get_and_clear_ptes(_mm, _addr, _ptep, _nr) \
+	get_and_clear_full_ptes(_mm, _addr, _ptep, _nr, 0)
+
 #ifndef clear_full_ptes
 /**
  * clear_full_ptes - Clear present PTEs that map consecutive pages of the same
@@ -768,6 +771,9 @@ static inline void clear_full_ptes(struct mm_struct *mm, unsigned long addr,
 }
 #endif
 
+#define clear_ptes(_mm, _addr, _ptep, _nr) \
+	clear_full_ptes(_mm, _addr, _ptep, _nr, 0)
+
 /*
  * If two threads concurrently fault at the same page, the thread that
  * won the race updates the PTE and its local TLB/Cache. The other thread
diff --git a/mm/mremap.c b/mm/mremap.c
index ac39845e9718..677a4d744df9 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -280,7 +280,7 @@ static int move_ptes(struct pagetable_move_control *pmc,
 							 old_pte, max_nr_ptes);
 			force_flush = true;
 		}
-		pte = get_and_clear_full_ptes(mm, old_addr, old_ptep, nr_ptes, 0);
+		pte = get_and_clear_ptes(mm, old_addr, old_ptep, nr_ptes);
 		pte = move_pte(pte, old_addr, new_addr);
 		pte = move_soft_dirty_pte(pte);
 
diff --git a/mm/rmap.c b/mm/rmap.c
index f93ce27132ab..568198e9efc2 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2036,7 +2036,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			flush_cache_range(vma, address, end_addr);
 
 			/* Nuke the page table entry. */
-			pteval = get_and_clear_full_ptes(mm, address, pvmw.pte, nr_pages, 0);
+			pteval = get_and_clear_ptes(mm, address, pvmw.pte, nr_pages);
 			/*
 			 * We clear the PTE but do not flush so potentially
 			 * a remote CPU could still be writing to the folio.
-- 
2.30.2


