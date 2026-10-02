Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54216CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:57:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1A446B00B5; Fri,  2 Oct 2026 05:57:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CAD76B00B6; Fri,  2 Oct 2026 05:57:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BA706B00B7; Fri,  2 Oct 2026 05:57:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 61F446B00B5
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:57:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EF6461C3699
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:57:03 +0000 (UTC)
X-FDA: 85277232726.18.9F67B55
Received: from mta1.migadu.com (out-92.mta1.migadu.com [95.215.58.92])
	by imf07.hostedemail.com (Postfix) with ESMTP id 16DC040007
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:57:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ddw0Xtaa;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.92 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790935022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=swtn/p26fCkt4vRtcRB7X7JB8a3HUQ+ODBf7g5PQIWY=;
	b=G2kZhIpVS5x2w1GBXONI0aR4pGvEcpYNTxBn8pYIoliLpUV9KbdO9+2q3SHHJZVW9nNIgK
	1SfqflJlUQjh0AFpXhBpxRMqbLFPq5WdO3VPZG5R2noH3Ln+GBpjh6j7niXZOjNp2I1lmh
	QPJG64BAbXEGeDJzeBqio/oG9El7kf4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ddw0Xtaa;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.92 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790935022;
	b=dfRo9UaHCoioXD7uAU9Raq9HN3Zy8KTjcLIGozjV1eWfIcZwinbvVMdqdo16RDht5a3LN4
	rMHPgrduHEoYOsmDUv+ZPZarTwITRDkNkoSObZCshYlBla04fXoiPlzIcvcKzX4gnUlOOj
	ydfdg/n3J8YhBDjqUqhTdj0q8n9pJg4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=LJuxmAXZRz2ysvPto4NuVYTODe3NrwDrlQwZEMzbd3g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790935020; v=1; x=1791539820;
 b=Ddw0Xtaa+0Nt56zv4TnLqwZYk0DDENkdrozguWEy4wF7ux3qJw5FFgYGd+MfGv4J30HgdaDV
 +/s3amEH7n2F7lCJ4YDkFtvoiNode/uZAtBs8AGvrLMHYmAHOLaG3T7Fdw6r9jbjwh17aW+6P+5
 sG68annjAiBDq7si/UNypVSs=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id fda1ba0995e89929;
	Fri, 02 Oct 2026 09:57:00 +0000
X-Mizu-Trace-ID: fda1ba0995e89929
X-Migadu-Flow: FLOW_OUT
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
Subject: [PATCH v8 17/30] mm: handle soft-dirty and uffd-wp on PMD swap entries
Date: Fri,  2 Oct 2026 02:52:31 -0700
Message-ID: <20261002095503.3585565-18-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002095503.3585565-1-usama.arif@linux.dev>
References: <20261002095503.3585565-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 16DC040007
X-Rspam-User: 
X-Stat-Signature: j84ogayowg8zrotnq6bucijsc8nkii5x
X-HE-Tag: 1790935021-356713
X-HE-Meta: U2FsdGVkX1+zM9mTg0Q6CCex+MtVoZ7Ss61QGMdZywehvwbt8sj4UHWM4D1Z17c6Zq+dYkzfx5IGY4NasAJ29QxDI77P//aV4eXbhAYXLOP0T0FeTA8WSycJMAQ5XFPCx68AkTpgwMU+Fb5jjtrWEfpsSbZIxu6hK+9pcmNJBjlpPirC+qckAo0VYQxDaxjKoWYnppxOcIavrOMw3ZiFGCOt5xkZ9hxlgO7LU6lgmMmtcaFYeVzozrundzlld7qHrFgwgt3VIJBpAltjDZTqM7lpdOSfd7bGMN0VTyfkPP1DT7castf18Uj9drT4qqA3vKfUf/tnmbtHwK8KYtyLExV3gqOeCH95tOx5HKWwutS3qEwcCobXj6kc13Fq7cxVi6/mJiBT7MZudhVVraVk3EtvFAUhANuCEeShE3lFhouOnrLEtt3J9f45jb3uI9UIyIl3ygGaWkKwnRea75/kXBz3s1pt22upGOPebtxOSP+tTN2ffOtZnQhHzDPVYEr/87POqkB92bGBmb2f00pCzJ8ARFD16WpgU/8ZsX2FZiITm9w3J7+ebvsEyy5R9+i7FK4YnMcVxG9uqRBWEUzQT2gv8suJxeEBsJND37vWt70Rs5MoRdUozrA92piQKZEPkHUUXBKbBmR/T2/WvLcoBSKwrZyAGReDJ9HOUMFcynJnXKdqyuJtCTxZzZwlC0LgJoGOEa6sLN1l3iCBSCUUdvo6IM2kSwsYnZTr/G048vEPVmb/dEHgBEKjY8e8dOaX/3eob1+TJx99ifLKu2bheINEjq9J5Uoirn6btaGxT1nPpiuRvDhL6xhmnjL2tB4YyWNKFPfsjft5zo/ZfvOtvgMm8wH9zKGFtx3fYNMaOSYaO3lbuSin+N1Jyv2VQO6+w8q/A5kg5K8XfwuxZ7gfsretb6taon2WM/zxz1PIgigERcinhmwyB/ZDx3ipJN8PlIhf4+PeiuOP0GOj3Ns
 6Y/4Q2lt
 w1l4rcwo18CTShCtu6PbtR52iwIXR3CB4QJLx/WkJF1ardji5d9wEXYRbBRubA/wXpIKy2ZVP0V2T5kM+nIvDCOH1JLFKyZZ8eSMgC9eCWzArEb5885nt0InR/xDK5dIXxYyfMkg+fuvj6N5QiT8g5Ozr7YvxIv1Hdy3lDSobRO6O4ETFsLhGWi44nnbU0KYOzJuQIp3esxs+NhURg1iPw5wR/h9e1qEQz1RY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
index 97c3fd7acf15d..83cf39006e5f8 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1655,7 +1655,7 @@ static void clear_soft_dirty_pmd(struct vm_area_struct *vma,
 		pmd = pmd_clear_soft_dirty(pmd);
 
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
-	} else if (pmd_is_migration_entry(pmd)) {
+	} else if (pmd_is_migration_entry(pmd) || pmd_is_swap_entry(pmd)) {
 		pmd = pmd_swp_clear_soft_dirty(pmd);
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
 	}
@@ -2481,7 +2481,7 @@ static void make_uffd_wp_pmd(struct vm_area_struct *vma,
 		old = pmdp_invalidate_ad(vma, addr, pmdp);
 		pmd = pmd_mkuffd(old);
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
-	} else if (pmd_is_migration_entry(pmd)) {
+	} else if (pmd_is_migration_entry(pmd) || pmd_is_swap_entry(pmd)) {
 		pmd = pmd_swp_mkuffd(pmd);
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
 	}
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 80d18ca972ecf..56eb87fa98376 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2637,7 +2637,8 @@ static inline int pmd_move_must_withdraw(spinlock_t *new_pmd_ptl,
 static pmd_t move_soft_dirty_pmd(pmd_t pmd)
 {
 	if (pgtable_supports_soft_dirty()) {
-		if (unlikely(pmd_is_migration_entry(pmd)))
+		if (unlikely(pmd_is_migration_entry(pmd) ||
+			     pmd_is_swap_entry(pmd)))
 			pmd = pmd_swp_mksoft_dirty(pmd);
 		else if (pmd_present(pmd))
 			pmd = pmd_mksoft_dirty(pmd);
@@ -2729,6 +2730,12 @@ static void change_non_present_huge_pmd(struct mm_struct *mm,
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
 
@@ -2789,7 +2796,7 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	if (!ptl)
 		return 0;
 
-	if (thp_migration_supported() && pmd_is_valid_softleaf(*pmd)) {
+	if (pmd_is_valid_softleaf(*pmd)) {
 		change_non_present_huge_pmd(mm, addr, pmd, uffd_prot,
 					    uffd_prot_resolve);
 		goto unlock;
-- 
2.53.0-Meta


