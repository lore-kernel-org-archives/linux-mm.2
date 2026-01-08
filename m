Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4308CD185F9
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 13:58:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACD576B0088; Thu,  8 Jan 2026 08:58:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8EA16B0095; Thu,  8 Jan 2026 08:58:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BAAD6B0096; Thu,  8 Jan 2026 08:58:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 882606B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 08:58:46 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 30AC6437FB
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 13:58:46 +0000 (UTC)
X-FDA: 84308952252.02.922CEB1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6719F40002
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 13:58:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=IkeSLAkW;
	spf=pass (imf07.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767880724; a=rsa-sha256;
	cv=none;
	b=eBa6HbfAHdNnX6+pjcsQ+g96Hl50mhagXHLTz/FR5Sh2dYuD18QlqE1I8Nv8vDU0j2zxRr
	gXZDJrMr1RGNx7fhYZV7lC/YfZ51srp6m/zCEi4n7kRq2J00Z+ePAoZ10oqRdt/NePdRov
	8X8engod1g+irFLxEe0CBY5XioBMLIQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=IkeSLAkW;
	spf=pass (imf07.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767880724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=wWk4lBmrs0zqN2WoRXOb68EyrvZcwbCKpEBLCz2gMDo=;
	b=MTnSMkfoGBtGibTOrTvRTyvYOxzEE56EnDOZ/4DBKAnpLtAFNe3ZwcZO43vywGTrm41x7I
	aNQamssdEoLL5kYaOeLK4OD+WKFEaWuRVfqIngJHg2z8ZXrUQvPfktlqQWMZMGUpQtrMSW
	I+kuytAeC/tAG/Piw6PwSDHcj2D2OvY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 71D5541B28;
	Thu,  8 Jan 2026 13:58:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE679C116C6;
	Thu,  8 Jan 2026 13:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767880723;
	bh=H8dQU+31z+RB92+oK/SDGHzzr2/P4FoToDpSxpydonI=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=IkeSLAkWY5Vz6a+nBcXCeus1/QyZLdCjBhjmGOv6JpOsDYEk4I6AifcHrIzHZGPBa
	 uK/n/Siz/eUXgHWq5TTGnQkf7mQy7p/ksSst2xU8DmRs0HVYWcJEFP7mJXZ/tZc9Oa
	 GzhHBH2e3w6vo+NIjIqEXyspbNAoQhSntWoXJ0Ak=
Subject: Patch "mm/mprotect: use long for page accountings and retval" has been added to the 5.15-stable tree
To: Liam.Howlett@oracle.com,aarcange@redhat.com,akpm@linux-foundation.org,axelrasmussen@google.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,david@kernel.org,david@redhat.com,dev.jain@arm.com,gregkh@linuxfoundation.org,harry.yoo@oracle.com,hughd@google.com,jane.chu@oracle.com,jannh@google.com,jthoughton@google.com,kas@kernel.org,lance.yang@linux.dev,linux-mm@kvack.org,lorenzo.stoakes@oracle.com,mike.kravetz@oracle.com,nadav.amit@gmail.com,npache@redhat.com,peterx@redhat.com,pfalcato@suse.de,ryan.roberts@arm.com,songmuchun@bytedance.com,vbabka@suse.cz,ziy@nvidia.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 08 Jan 2026 14:56:34 +0100
In-Reply-To: <20260106115036.86042-2-harry.yoo@oracle.com>
Message-ID: <2026010834-cane-attire-310c@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Queue-Id: 6719F40002
X-Rspam-User: 
X-Stat-Signature: 9w7r9g7doh8fwyiauam5dzxgtgnm64f1
X-Rspamd-Server: rspam07
X-HE-Tag: 1767880724-945589
X-HE-Meta: U2FsdGVkX18dCK3BBV1Li/hg8jxq3J5xa03MuKj/obAWQxcJrrLrdwYeVFpn98759KIh24zh3B/EwYVDFyhZyYgUhlXw1mD3GqmWAIx6qW6V/uMC2U8KbLiWcDJ0G8J/DAJqA8Bp+MKOA43L1hG/X+7L5ZH0+goIyAk35FfUNe4/QF0DVNhEcoWAcv4Gv6njvFivfV62pYv592p8r7gpBOpqG949gTxBQPH/LqxjoSQQ0A4ROpZjRg+xDf5sBEGtwk1p/VQ6iE+vXzb1Q8XKT9KVsT5NRTu10jR7bcQMvkazMJvKfTDZZNda0wDgZNnT89oO5HbdMPXyK5ha2UV5B8dTi5KrA0w5GJf4CoAXVl9QRwmaZVtjQcjIPTnNQTgxC5cpNgKjl4DOy2Ktl4+HoYwzJEMkTCR/+ycHzGSebT/UJMcnemXxkfZ/eMS/jBsIJgmOxN7wN6Al5jLJFPesYEPVGdcin1+r5a8/f4QIs2Oiy8csxwMvei33B0ZAhM2e2qchxMCTiHTr9i1NEck7ui4yfJc0pPXgYkBECrkMqmyVCSL5f6XFvixGMval4URE6mh4YolQ8/PUJV6qJ5wGvkJL58G6tv3pPbLgsPPkEXpFxINZm5cpnrtn5P0g6XaqZvc5jVLDDodvIAi6b6lTCn9wi34KBd5OqeAJ/YKHJafa6fIiweBpyT+KrZRfLe5vzgUJKFVZjWG+9vsmHVOdKq5G0Yvh5n+wJ/puLlawhYU9slqq+yF2MBqXWShzWhmDu73mA+ho5oDFaL53qwD8UFjEWWM1NODJ+pSsh3JgGvEOEAPZbQmOeKcv8Duf/xziYGKw5/hdaD+BP4zSRMu2FWEYKQi1dTAhkqwIBNozcc8LZ22E+MFf9ZYiMjGLWHSKl30XtDCGbNanGlDEq16K931mFFi68CybzD1OxN4yJmIFgJjHJaxq0t6lnEf3EOCh7TUSnlCrDfOJ8tg+Q7V
 iy8adW8T
 jLIhd1MMK46hsVjh/njyqC9SDRKFoLkc7wFZ+AiUpVXTaS0TbcS6zVJL0DI3D22HYfgGOGv4ApvgN4px4IC8Aim/knSdvDOZvUdOBXfhrO2L0DMw6M67pzAlsseW1oR8I1/jaxP6eR5uTCxd3XylTXg0j14nmDScXcRYSgOcp6YV2CjJu4oVaPwYJmTCpIAl5qFKHjbldxoJCrIrVzMxOCyPuJshdph1VfW8FJm95KcSxqZmcwrl+kW4KyIc3j1k5DibcLbEf4LW99DLxOhaUD52fc3EM4NyVq4BTHFyGcxUnGDRHzq/U0l6+bi10PgSXPFWxsbUJwfJ2LMXgCZH6pGw/zlfjsFy/c9H+Dz5s/PEp4JrI7wd+MhkRxkJ0ByXMF6Wz43WV4q/ljyy8gFb+DLRjXnJ0Pr4qHnjnqQl/bA/iVQeIPx8/I8k84SIahXfZQt7e+/SAcRH8Ne4vMHLGGILftI1m5PWYVHM58pFaDqTzupszo0dZogqGdthZuXqNNX/q+JE7qnZX+/gV1fX0QuUU4wfICGCZhSfoKXrv5i5yNreBZSt7PWN7Ofhe7QU+Z3SBL/kkXYlYQl1tXNrIfvO+yN3JbN+pw3njYsBnas4VKjJ0kYqeocoJg/+fEa3u16JGtWiKFRgm7KVtjJiXw8hSqD6thi0DgENsHVGFnlKZsuD565G8PPaoU9FrLZ9rCj0MRvh+YT2w4TD5mkkh5PrAJGf78OdoDlzzABhHeLEowj8Xvw0kWHxBXnm7f0+B+UNpTTs8yq6RSlCZcX0B/Mfa4eEe5tiPDp3If2CeoLElog6iR++OcVr+wf58zbwZD6lbO1ie58oc0OjBzsb2IKJAXXAovGwUEu57pEs+a7hTZkUR2hDi0idrAg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm/mprotect: use long for page accountings and retval

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-mprotect-use-long-for-page-accountings-and-retval.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-205079-greg=kroah.com@vger.kernel.org Tue Jan  6 12:59:45 2026
From: Harry Yoo <harry.yoo@oracle.com>
Date: Tue,  6 Jan 2026 20:50:35 +0900
Subject: mm/mprotect: use long for page accountings and retval
To: stable@vger.kernel.org
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org, baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com, hughd@google.com, jane.chu@oracle.com, jannh@google.com, kas@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, npache@redhat.com, pfalcato@suse.de, ryan.roberts@arm.com, vbabka@suse.cz, ziy@nvidia.com, Peter Xu <peterx@redhat.com>, Mike Kravetz <mike.kravetz@oracle.com>, James Houghton <jthoughton@google.com>, Andrea Arcangeli <aarcange@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>, David Hildenbrand <david@redhat.com>, Muchun Song <songmuchun@bytedance.com>, Nadav Amit <nadav.amit@gmail.com>, Harry Yoo <harry.yoo@oracle.com>
Message-ID: <20260106115036.86042-2-harry.yoo@oracle.com>

From: Peter Xu <peterx@redhat.com>

commit a79390f5d6a78647fd70856bd42b22d994de0ba2 upstream.

Switch to use type "long" for page accountings and retval across the whole
procedure of change_protection().

The change should have shrinked the possible maximum page number to be
half comparing to previous (ULONG_MAX / 2), but it shouldn't overflow on
any system either because the maximum possible pages touched by change
protection should be ULONG_MAX / PAGE_SIZE.

Two reasons to switch from "unsigned long" to "long":

  1. It suites better on count_vm_numa_events(), whose 2nd parameter takes
     a long type.

  2. It paves way for returning negative (error) values in the future.

Currently the only caller that consumes this retval is change_prot_numa(),
where the unsigned long was converted to an int.  Since at it, touching up
the numa code to also take a long, so it'll avoid any possible overflow
too during the int-size convertion.

Link: https://lkml.kernel.org/r/20230104225207.1066932-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: James Houghton <jthoughton@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ Adjust context ]
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hugetlb.h |    4 ++--
 include/linux/mm.h      |    2 +-
 mm/hugetlb.c            |    4 ++--
 mm/mempolicy.c          |    2 +-
 mm/mprotect.c           |   26 +++++++++++++-------------
 5 files changed, 19 insertions(+), 19 deletions(-)

--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -208,7 +208,7 @@ struct page *follow_huge_pgd(struct mm_s
 
 int pmd_huge(pmd_t pmd);
 int pud_huge(pud_t pud);
-unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
+long hugetlb_change_protection(struct vm_area_struct *vma,
 		unsigned long address, unsigned long end, pgprot_t newprot);
 
 bool is_hugetlb_entry_migration(pte_t pte);
@@ -379,7 +379,7 @@ static inline void move_hugetlb_state(st
 {
 }
 
-static inline unsigned long hugetlb_change_protection(
+static inline long hugetlb_change_protection(
 			struct vm_area_struct *vma, unsigned long address,
 			unsigned long end, pgprot_t newprot)
 {
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1910,7 +1910,7 @@ extern unsigned long move_page_tables(st
 #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
 					    MM_CP_UFFD_WP_RESOLVE)
 
-extern unsigned long change_protection(struct vm_area_struct *vma, unsigned long start,
+extern long change_protection(struct vm_area_struct *vma, unsigned long start,
 			      unsigned long end, pgprot_t newprot,
 			      unsigned long cp_flags);
 extern int mprotect_fixup(struct vm_area_struct *vma,
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5644,7 +5644,7 @@ long follow_hugetlb_page(struct mm_struc
 	return i ? i : err;
 }
 
-unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
+long hugetlb_change_protection(struct vm_area_struct *vma,
 		unsigned long address, unsigned long end, pgprot_t newprot)
 {
 	struct mm_struct *mm = vma->vm_mm;
@@ -5652,7 +5652,7 @@ unsigned long hugetlb_change_protection(
 	pte_t *ptep;
 	pte_t pte;
 	struct hstate *h = hstate_vma(vma);
-	unsigned long pages = 0;
+	long pages = 0;
 	bool shared_pmd = false;
 	struct mmu_notifier_range range;
 
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -634,7 +634,7 @@ unlock:
 unsigned long change_prot_numa(struct vm_area_struct *vma,
 			unsigned long addr, unsigned long end)
 {
-	int nr_updated;
+	long nr_updated;
 
 	nr_updated = change_protection(vma, addr, end, PAGE_NONE, MM_CP_PROT_NUMA);
 	if (nr_updated)
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -35,13 +35,13 @@
 
 #include "internal.h"
 
-static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
+static long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long addr, unsigned long end, pgprot_t newprot,
 		unsigned long cp_flags)
 {
 	pte_t *pte, oldpte;
 	spinlock_t *ptl;
-	unsigned long pages = 0;
+	long pages = 0;
 	int target_node = NUMA_NO_NODE;
 	bool dirty_accountable = cp_flags & MM_CP_DIRTY_ACCT;
 	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
@@ -219,13 +219,13 @@ static inline int pmd_none_or_clear_bad_
 	return 0;
 }
 
-static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
+static inline long change_pmd_range(struct vm_area_struct *vma,
 		pud_t *pud, unsigned long addr, unsigned long end,
 		pgprot_t newprot, unsigned long cp_flags)
 {
 	pmd_t *pmd;
 	unsigned long next;
-	unsigned long pages = 0;
+	long pages = 0;
 	unsigned long nr_huge_updates = 0;
 	struct mmu_notifier_range range;
 
@@ -233,7 +233,7 @@ static inline unsigned long change_pmd_r
 
 	pmd = pmd_offset(pud, addr);
 	do {
-		unsigned long this_pages;
+		long this_pages;
 
 		next = pmd_addr_end(addr, end);
 
@@ -291,13 +291,13 @@ next:
 	return pages;
 }
 
-static inline unsigned long change_pud_range(struct vm_area_struct *vma,
+static inline long change_pud_range(struct vm_area_struct *vma,
 		p4d_t *p4d, unsigned long addr, unsigned long end,
 		pgprot_t newprot, unsigned long cp_flags)
 {
 	pud_t *pud;
 	unsigned long next;
-	unsigned long pages = 0;
+	long pages = 0;
 
 	pud = pud_offset(p4d, addr);
 	do {
@@ -311,13 +311,13 @@ static inline unsigned long change_pud_r
 	return pages;
 }
 
-static inline unsigned long change_p4d_range(struct vm_area_struct *vma,
+static inline long change_p4d_range(struct vm_area_struct *vma,
 		pgd_t *pgd, unsigned long addr, unsigned long end,
 		pgprot_t newprot, unsigned long cp_flags)
 {
 	p4d_t *p4d;
 	unsigned long next;
-	unsigned long pages = 0;
+	long pages = 0;
 
 	p4d = p4d_offset(pgd, addr);
 	do {
@@ -331,7 +331,7 @@ static inline unsigned long change_p4d_r
 	return pages;
 }
 
-static unsigned long change_protection_range(struct vm_area_struct *vma,
+static long change_protection_range(struct vm_area_struct *vma,
 		unsigned long addr, unsigned long end, pgprot_t newprot,
 		unsigned long cp_flags)
 {
@@ -339,7 +339,7 @@ static unsigned long change_protection_r
 	pgd_t *pgd;
 	unsigned long next;
 	unsigned long start = addr;
-	unsigned long pages = 0;
+	long pages = 0;
 
 	BUG_ON(addr >= end);
 	pgd = pgd_offset(mm, addr);
@@ -361,11 +361,11 @@ static unsigned long change_protection_r
 	return pages;
 }
 
-unsigned long change_protection(struct vm_area_struct *vma, unsigned long start,
+long change_protection(struct vm_area_struct *vma, unsigned long start,
 		       unsigned long end, pgprot_t newprot,
 		       unsigned long cp_flags)
 {
-	unsigned long pages;
+	long pages;
 
 	BUG_ON((cp_flags & MM_CP_UFFD_WP_ALL) == MM_CP_UFFD_WP_ALL);
 


Patches currently in stable-queue which might be from harry.yoo@oracle.com are

queue-5.15/mm-mprotect-delete-pmd_none_or_clear_bad_unless_trans_huge.patch
queue-5.15/mm-balloon_compaction-we-cannot-have-isolated-pages-in-the-balloon-list.patch
queue-5.15/mm-mprotect-use-long-for-page-accountings-and-retval.patch
queue-5.15/mm-balloon_compaction-convert-balloon_page_delete-to-balloon_page_finalize.patch

