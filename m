Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF9EF606A328
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ArdHY2EY
Received: by kanga.kvack.org (Postfix)
	id 18D596B05D1; Thu,  5 Nov 2026 13:41:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 165446B05D2; Thu,  5 Nov 2026 13:41:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A1DC6B05D3; Thu,  5 Nov 2026 13:41:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4A586B05D1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:41:51 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D846280BEC
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:41:45 +0000 (UTC)
X-FDA: 85401934170.18.91A13B7
Received: from mta0.migadu.com (out-227.mta0.migadu.com [91.218.175.227])
	by imf29.hostedemail.com (Postfix) with ESMTP id E710A120004
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:41:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ArdHY2EY;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.227 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793904104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Fod23qsPbOM1tVlcHaZOrkXwIAkgiKw/W8BENTibQs=;
	b=Cu0Ptb7Mo6DH6JKrXy9W9nS1f3j79/RbV1POrTj2CtvN72KQUxPiaXOwBOvaLrhkSki3L1
	vRQPj3XlWOlRcjk0YT/xoXZHyWEROptNtJouEYZtos9FnHodXPCj0wYuUXfEMq1f5tt9TU
	RzU5o6fXl9fIbhp1MDrQ4Qi4CBjWmnI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ArdHY2EY;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.227 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793904104;
	b=zhOisw6WbHmb5wNLEQZFD/kZWxXYwBBoAl0SLbKQzL10w8/7MqBw9bxUxKQVRwDszvs3Qf
	vpUdXb7CQzWjhbC8jU7CDw5AnXSwDagprFs/P5iPjEbPGl7u9QYCqihjathEN+2P2FAHFg
	45htE9E9HxT8uwACnScT6sb2VZfH2hk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=RxoIa9gOc32/fyswBjJHft9MO4qoFCZyc3e19SH1Bt0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793904102; v=1; x=1794508902;
 b=ArdHY2EYVcLwpt7Rr10Gljn0+6DlXYyf8zrv+f8BPPmal8hDs0b2rtabJm1165Mn7AA4GtkK
 ifOJStFvWLA5l7JgAae4X5ycAk5IYSdGfM4i9FXYVx+aO1YQE4Cz8OjDThhei0GY8JEu7Msnvbw
 nRx8vz5U/Sl0rvGc3Eg2DVCY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 2423b80fe0ccb823;
	Thu, 05 Nov 2026 18:41:42 +0000
X-Mizu-Trace-ID: 2423b80fe0ccb823
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: chenhuacai@kernel.org,
	ying.huang@linux.alibaba.com,
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
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v9 19/32] mm: handle soft-dirty and uffd-wp on PMD swap entries
Date: Thu,  5 Nov 2026 10:39:03 -0800
Message-ID: <20261105183940.2236717-20-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105183940.2236717-1-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7pwsepib7nnsawfnbu48a4gofscc8daz
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E710A120004
X-HE-Tag: 1793904103-47698
X-HE-Meta: U2FsdGVkX18Qbd/XOMcBQ4ujCxWCInr2p6hmIRY6P7dCcOilN8B7CJAEZZkqW5Vwh6lbpn01CNQhA+xQHucTcBrW6XlQo0rHGlmv3b2KfX4SmzFOa8Iwq4N0R8oSaXO9mvNshZirsNuQ1wTNhngnckp+r8bN33wDc3AhIOs5ev/ttzGzx5up4dJm7d6/PhTdMaIelopknyNm7swPJDlYuxWTnO+/4wCjKFnPuUwuPJXIxs5KpnpIGGmAUe7t3HRk7rhV/mp8dZkjyvga8hLHnMrFP7vQY/MyYqc11Ai/PFJ3WvgitdKmpwPCkGuTEoOKJS2wryx1xsM++zsqJyCIk3G/4iO2ADZ1WDTlF1dZwIzuIGXJqk0NIuo+B/SGbNHeBzIuwU7k6D4pAQH04NP9iaJIlUmF/s1sv138shKF2VmcQLHdIb1m8g+grCcVQkprpm6pv6MMtY+BltY8Vvn1eh+IRL4YLhp938ZmOLa4mw4T9AjFz9cODS4G86BevVGEa8XX1frXrnoudpAW/RVLmD1AlJYGYKDzy/3n95wwSepQ+Jh21d8hVA71/tGihPobUVUbQJW/PUk8QcCTPjF5B5s/H/51Mco5RmjFbOrx95Dsujg2bi5PSsiU6VI0pJH/IEq5mVobQ1SXo0H6SGjdve85wq2HlLd79Em7PoQECShbRBhjp+YeEvh0TiYEhNv/8JN0RpH/OyZILeqAXAnL7ZI2ZRdAFojEq7G9iOksiNWp6n+7L2kjG3qpcgJplChimbG4ZrivkI6OULtR7Fex/PxEkeW2xM643GHfmaz0V2hJs0xk3ve3ghO5O+v8BOJqjbXyEARzMAhVzFCss3rxb7v7VPZtEHZ9dyGZTrVKUbGYTaQdJi+sZ2aDp8xf4E6z9iQRFbh0nGf8VYtmBw13LMB5mT03zh3zAxad0QAOcX9Yc8/aijoCdZct6zSzawxfnrcqI5kC2RcHAzXNb6M
 jSppwE9e
 w6Mx+bGc5deWutZhRgukKhBCTAsDpkFL/4+7+wDtKk/wT6NhsECUtsAl6DnC4xxakwV80ApcIta83gNLnSCUgfWStBlvG2lgeuZtarQ7uYA1/UfKgMo+jdeWoFfO8HSw9lYV5Ym4oDOG+Kr2Re4KZogggJ617BifoQaFG+fSBCgwV7DikiJc1LuzofL+StFglLDLD2zfOi1oLaoFbWi98hDhDvYRIgpmtQsd0kSCdZhKyQtE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Soft-dirty and uffd-wp live in the PMD, not in the swap entry, so every
path that manipulates them for a PMD migration entry has to do the same for
a PMD swap entry. Otherwise clearing soft-dirty skips a swapped-out THP,
UFFDIO_WRITEPROTECT does not arm it, and mremap does not mark the
destination.

change_huge_pmd() needs nothing beyond dropping its
thp_migration_supported() gate: a PMD swap entry encodes no write
permission, so it falls into the default arm of
change_non_present_huge_pmd() and picks up only the uffd-wp update.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 fs/proc/task_mmu.c |  4 ++--
 mm/huge_memory.c   | 11 +++++++++--
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index bfe9d6af76d5a..aa0c8c1be9b0d 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1663,7 +1663,7 @@ static void clear_soft_dirty_pmd(struct vm_area_struct *vma,
 		pmd = pmd_clear_soft_dirty(pmd);
 
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
-	} else if (pmd_is_migration_entry(pmd)) {
+	} else if (pmd_is_migration_entry(pmd) || pmd_is_swap_entry(pmd)) {
 		pmd = pmd_swp_clear_soft_dirty(pmd);
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
 	}
@@ -2491,7 +2491,7 @@ static void make_uffd_wp_pmd(struct vm_area_struct *vma,
 		old = pmdp_invalidate_ad(vma, addr, pmdp);
 		pmd = pmd_mkuffd(old);
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
-	} else if (pmd_is_migration_entry(pmd)) {
+	} else if (pmd_is_migration_entry(pmd) || pmd_is_swap_entry(pmd)) {
 		pmd = pmd_swp_mkuffd(pmd);
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
 	}
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index acb540235e5a9..101ec72944cbf 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2626,7 +2626,8 @@ static inline int pmd_move_must_withdraw(spinlock_t *new_pmd_ptl,
 static pmd_t move_soft_dirty_pmd(pmd_t pmd)
 {
 	if (pgtable_supports_soft_dirty()) {
-		if (unlikely(pmd_is_migration_entry(pmd)))
+		if (unlikely(pmd_is_migration_entry(pmd) ||
+			     pmd_is_swap_entry(pmd)))
 			pmd = pmd_swp_mksoft_dirty(pmd);
 		else if (pmd_present(pmd))
 			pmd = pmd_mksoft_dirty(pmd);
@@ -2718,6 +2719,12 @@ static void change_non_present_huge_pmd(struct mm_struct *mm,
 	pmd_t newpmd;
 
 	VM_WARN_ON(!pmd_is_valid_softleaf(*pmd));
+
+	/*
+	 * Note that a PMD swap entry falls into the default branch below: it
+	 * does not encode write permission in the entry type, so only the
+	 * uffd_wp flag update at the end applies to it.
+	 */
 	if (softleaf_is_migration_write(entry)) {
 		const struct folio *folio = softleaf_to_folio(entry);
 
@@ -2778,7 +2785,7 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	if (!ptl)
 		return 0;
 
-	if (thp_migration_supported() && pmd_is_valid_softleaf(*pmd)) {
+	if (pmd_is_valid_softleaf(*pmd)) {
 		change_non_present_huge_pmd(mm, addr, pmd, uffd_prot,
 					    uffd_prot_resolve);
 		goto unlock;
-- 
2.53.0-Meta


