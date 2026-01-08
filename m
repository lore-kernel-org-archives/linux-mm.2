Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62EF4D1D482
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 16:28:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC2116B0095; Thu,  8 Jan 2026 11:28:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C58916B0096; Thu,  8 Jan 2026 11:28:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5BBD6B0098; Thu,  8 Jan 2026 11:28:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A3A596B0095
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 11:28:48 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4BDAF160196
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 16:28:48 +0000 (UTC)
X-FDA: 84309330336.28.E5FC293
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 810544000A
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 16:28:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=yKXKVZpv;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf07.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767889726; a=rsa-sha256;
	cv=none;
	b=xFCyhlniHPneCXHfIWzYapz9NK0ScE11pqZz7beiR31PcSANENzTki8C+8EI/0pamhWMio
	hbH5f5jbTn1KNUJ7jLxUcopBCpm1kN3RpO4/uj+bRJcb9Ynn+kzDXhl1usnX41EJ4AMv5d
	PD1H3vQPcEvJ97kqQBVFz/ewEUlIUfA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=yKXKVZpv;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf07.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767889726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=YM7VK7rUV5mGT21+4WAE6RsQQoI6kyOMoJsjcPMk4VI=;
	b=Qlr0UHou0Onccvev0aFuaeNuVeSqrdp+VpGU87CDdR2UPOg5V1rCQSGl7+YE0Ig+/9H6Q7
	vJ5RJFAMHeafZPAxpE/wpYthfOhrXxWaFPvk9yvHWO2DLEkNhffIloYL6nMe+TLdWx4hKH
	UI7uITazsEG7HwCTIRUTlfXtrTW14gg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E1D041816;
	Thu,  8 Jan 2026 16:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3D9C116C6;
	Thu,  8 Jan 2026 16:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767889725;
	bh=FgVg1OM8KvvgA1jnKuP5d+B3bE/cWOn7s0ICq2uXKoc=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=yKXKVZpvbDLwXdfXOZHk+mKVmbdyNBJHjiKsO93C6duhNQfZmTBsBA8oZJUrpqCfC
	 rIloZbXlbhAbSQ/ZIXAyVlE98YAKqPVYqOq9IgCZW/rc6vx4tYrQOOuHloJ3d1b1vQ
	 gJhWTmN93PgVWDAghZ64czgPAeP69ehpvwBFtWLE=
Subject: Patch "mm/mprotect: use long for page accountings and retval" has been added to the 5.10-stable tree
To: Liam.Howlett@oracle.com,aarcange@redhat.com,akpm@linux-foundation.org,axelrasmussen@google.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,david@kernel.org,david@redhat.com,dev.jain@arm.com,gregkh@linuxfoundation.org,harry.yoo@oracle.com,hughd@google.com,jane.chu@oracle.com,jannh@google.com,jthoughton@google.com,kas@kernel.org,lance.yang@linux.dev,linux-mm@kvack.org,lorenzo.stoakes@oracle.com,mike.kravetz@oracle.com,nadav.amit@gmail.com,npache@redhat.com,peterx@redhat.com,pfalcato@suse.de,ryan.roberts@arm.com,songmuchun@bytedance.com,vbabka@suse.cz,ziy@nvidia.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 08 Jan 2026 17:27:39 +0100
In-Reply-To: <20260107032121.587629-2-harry.yoo@oracle.com>
Message-ID: <2026010839-ranch-jarring-c578@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspam-User: 
X-Stat-Signature: u1x68u9wxnr5xtwwwre5mktcb3sc6sde
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 810544000A
X-HE-Tag: 1767889726-464336
X-HE-Meta: U2FsdGVkX1+WD4qjMFDdE4e8OE598kE7R+6hLbc/H5HuGuaAWWFnyDQ5QLCeBHN6YCis9qk0nVR9k5P0vU9RvG3LLiJZWB73bem930FnmwCj1OS6xJ2ndnXVVUN4n93RiqUa5KwFHnXcIqQTkRRKLGxskuCpachv8PPc4fhuF/Ne5sGtyzTGV2Yf7TV7oDAX/1slbLS7q7uaFnnE5HMJH0kUBR/I1ROqHiJdPaF9yqwcQMy8pB6VDNPNTPebt212qU0bTUJ1+qJ7ZNrI0x9SZvWJjYbxXsQowX5STMyhC4mX3lwrmS8UQ+2ugerQ/kMrVGZwkhM/MsAIqNR4u+Uuj2fiY2Ewg5WXlOJTEB3QlhH2uvSWjac0gVIFL+rlhLT6hb7yrTIageiUW4MpaPKawZQEVzz6kwylEiRpHw8ILodg8zdxaE3YB6ZtUVSRJoQNfeYE9B+7PVyR1pvO2DDoJf1nHZczdiBJkw+/xCk8aZnww8SATnQVLkVhgOC69HIrysciFqUq/qVL/cxrSKRF5l/ZHjVyxck56bpvk5TXwN2aagoT/2JqR05+9xosLNFYNzZqnTeuwpDwsO6kS4JROwHGQDTNMzfvSHOBYoW/3ksCP/pFHXI8+Qhz4zO7EJE+kYOQPOncMFA1Shyn40UxwJGKjh7yuV0BjgF7dwSY/XcVVju7GsvoYW95XE+yNnY0zDEu/FEtBA2CXR4R96G/Y2KHTgvIGCTKaV/rGTRX7CK2HjSt61Q0r+GDEo5bj5+XEJUWvvElL19Iq2+/+985Uj/wb9Hnl2uQQJJtuDN/ke1rnVo/Kee4WGiQGQ9H9EDeRy2yzWHeWXONSdV54N8Qu1bi0f5lpgS+TVkny3h/QgaUi0GY9KwOVyUtI13rSbrkBqchwY0Su6MLpdB/8nKG3BCqzv5/KWdLftQ+m9C/JiymbCtRhmzjuvnnP6fBz4eDt5AdbQ7FcTA9ubknWbh
 jRZCppH3
 hiHhD6t20ulTGFWUsOtHFvE98VbbUNlml7QG2t5GcTLgddrV75OIH3kz5IR7bObp5UAvgU1go4S4FrHKMNiAtoDcrOQw1w5acvGOpSJUVU0zaQM2i5PJ74oZWMmO++siye14wp3ebcK3RZHnnYdT82M2AbLuC7t2QSCVQR4FHdNPzQFI6fAB6ow2vKw4cm7A7sTBVzrAmIb0iSHqWAuN5BNjPqSaoyv3MHJ+Vg46rZo1iR68uIbOECmXiIU0DUQeTt6fcD3Fdo0lqWonCc95gHxqCcQNwj4xHVh/eaqkGfGkY/Vtsy2Uw6YY+5ss2bOFKIZBnFxgt156IVvJgqapsKMSt76rdhh/ESo+oR/sQVv613AAyL2aDnGVRYgTGRqPAZ9WrQvuUWq5GLelaiRKnmZyd0FeAUriiD1pluzDMhX4LmO6MnrGJtnoirR8q+HgsxZufpcFWRVBSLU0+MGYPkpjb3ncSkmWvuErzNKjvwidU6SjJT/U4EbjB7RWblHsU+p2riVeA9/jlveyij8aO2YYyW4lmJgy5y1YlOp/JjFW1Y0JHmCnC7kdgSod340Xkm8D9+8yMThng44iWVSzgnhNsTa5/VZgNoy7AeKCKebeLhqgf5jJ59WnEd4JG1IKCSeBNY+Z7HmGKf4gGmnWlAW2/Z0FoXXn6Vu3y8fIWnFDaiRwRstfSZsoVJMh4yN98KG2APd8kch1ohfERNEc5Ykh5SYGuKmU5k575MCBc/fqJwsCLyO89YTxxqEs8obadQGgJE7ii/1Lc5wu+qZmMoWfgwCdeizzaFsN8qJrqNLqV0mfnH/zDN5/neLW2vqdAduFl8PYGhC0gzhkgTSe4vGWnYiBCNdmIn/UNwxYLkLnZMa5dX2jJZvkAfQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm/mprotect: use long for page accountings and retval

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-mprotect-use-long-for-page-accountings-and-retval.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-206084-greg=kroah.com@vger.kernel.org Wed Jan  7 04:22:20 2026
From: Harry Yoo <harry.yoo@oracle.com>
Date: Wed,  7 Jan 2026 12:21:20 +0900
Subject: mm/mprotect: use long for page accountings and retval
To: stable@vger.kernel.org
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org, baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com, hughd@google.com, jane.chu@oracle.com, jannh@google.com, kas@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, npache@redhat.com, pfalcato@suse.de, ryan.roberts@arm.com, vbabka@suse.cz, ziy@nvidia.com, Peter Xu <peterx@redhat.com>, Mike Kravetz <mike.kravetz@oracle.com>, James Houghton <jthoughton@google.com>, Andrea Arcangeli <aarcange@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>, David Hildenbrand <david@redhat.com>, Muchun Song <songmuchun@bytedance.com>, Nadav Amit <nadav.amit@gmail.com>, Harry Yoo <harry.yoo@oracle.com>
Message-ID: <20260107032121.587629-2-harry.yoo@oracle.com>

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
 mm/mprotect.c           |   34 +++++++++++++++++-----------------
 5 files changed, 23 insertions(+), 23 deletions(-)

--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -184,7 +184,7 @@ struct page *follow_huge_pgd(struct mm_s
 
 int pmd_huge(pmd_t pmd);
 int pud_huge(pud_t pud);
-unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
+long hugetlb_change_protection(struct vm_area_struct *vma,
 		unsigned long address, unsigned long end, pgprot_t newprot);
 
 bool is_hugetlb_entry_migration(pte_t pte);
@@ -342,7 +342,7 @@ static inline void move_hugetlb_state(st
 {
 }
 
-static inline unsigned long hugetlb_change_protection(
+static inline long hugetlb_change_protection(
 			struct vm_area_struct *vma, unsigned long address,
 			unsigned long end, pgprot_t newprot)
 {
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1876,7 +1876,7 @@ extern unsigned long move_page_tables(st
 #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
 					    MM_CP_UFFD_WP_RESOLVE)
 
-extern unsigned long change_protection(struct vm_area_struct *vma, unsigned long start,
+extern long change_protection(struct vm_area_struct *vma, unsigned long start,
 			      unsigned long end, pgprot_t newprot,
 			      unsigned long cp_flags);
 extern int mprotect_fixup(struct vm_area_struct *vma,
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5051,7 +5051,7 @@ same_page:
 #define flush_hugetlb_tlb_range(vma, addr, end)	flush_tlb_range(vma, addr, end)
 #endif
 
-unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
+long hugetlb_change_protection(struct vm_area_struct *vma,
 		unsigned long address, unsigned long end, pgprot_t newprot)
 {
 	struct mm_struct *mm = vma->vm_mm;
@@ -5059,7 +5059,7 @@ unsigned long hugetlb_change_protection(
 	pte_t *ptep;
 	pte_t pte;
 	struct hstate *h = hstate_vma(vma);
-	unsigned long pages = 0;
+	long pages = 0;
 	bool shared_pmd = false;
 	struct mmu_notifier_range range;
 
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -653,7 +653,7 @@ unlock:
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
@@ -209,13 +209,13 @@ static inline int pmd_none_or_clear_bad_
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
 
@@ -223,7 +223,7 @@ static inline unsigned long change_pmd_r
 
 	pmd = pmd_offset(pud, addr);
 	do {
-		unsigned long this_pages;
+		long this_pages;
 
 		next = pmd_addr_end(addr, end);
 
@@ -281,13 +281,13 @@ next:
 	return pages;
 }
 
-static inline unsigned long change_pud_range(struct vm_area_struct *vma,
-		p4d_t *p4d, unsigned long addr, unsigned long end,
-		pgprot_t newprot, unsigned long cp_flags)
+static inline long change_pud_range(struct vm_area_struct *vma, p4d_t *p4d,
+		unsigned long addr, unsigned long end, pgprot_t newprot,
+		unsigned long cp_flags)
 {
 	pud_t *pud;
 	unsigned long next;
-	unsigned long pages = 0;
+	long pages = 0;
 
 	pud = pud_offset(p4d, addr);
 	do {
@@ -301,13 +301,13 @@ static inline unsigned long change_pud_r
 	return pages;
 }
 
-static inline unsigned long change_p4d_range(struct vm_area_struct *vma,
-		pgd_t *pgd, unsigned long addr, unsigned long end,
-		pgprot_t newprot, unsigned long cp_flags)
+static inline long change_p4d_range(struct vm_area_struct *vma, pgd_t *pgd,
+		unsigned long addr, unsigned long end, pgprot_t newprot,
+		unsigned long cp_flags)
 {
 	p4d_t *p4d;
 	unsigned long next;
-	unsigned long pages = 0;
+	long pages = 0;
 
 	p4d = p4d_offset(pgd, addr);
 	do {
@@ -321,7 +321,7 @@ static inline unsigned long change_p4d_r
 	return pages;
 }
 
-static unsigned long change_protection_range(struct vm_area_struct *vma,
+static long change_protection_range(struct vm_area_struct *vma,
 		unsigned long addr, unsigned long end, pgprot_t newprot,
 		unsigned long cp_flags)
 {
@@ -329,7 +329,7 @@ static unsigned long change_protection_r
 	pgd_t *pgd;
 	unsigned long next;
 	unsigned long start = addr;
-	unsigned long pages = 0;
+	long pages = 0;
 
 	BUG_ON(addr >= end);
 	pgd = pgd_offset(mm, addr);
@@ -351,11 +351,11 @@ static unsigned long change_protection_r
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

queue-5.10/mm-mprotect-delete-pmd_none_or_clear_bad_unless_trans_huge.patch
queue-5.10/mm-balloon_compaction-we-cannot-have-isolated-pages-in-the-balloon-list.patch
queue-5.10/mm-mprotect-use-long-for-page-accountings-and-retval.patch
queue-5.10/mm-balloon_compaction-convert-balloon_page_delete-to-balloon_page_finalize.patch

