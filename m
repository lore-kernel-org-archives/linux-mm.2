Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC871C88E66
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 12:31:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A73CD6B00AF; Mon, 14 Sep 2026 08:31:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4B8B6B00B0; Mon, 14 Sep 2026 08:31:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 988856B00B1; Mon, 14 Sep 2026 08:31:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 721986B00AF
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:31:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0499B40351
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:31:44 +0000 (UTC)
X-FDA: 85212304170.06.AD7CD64
Received: from mta0.migadu.com (out-141.mta0.migadu.com [91.218.175.141])
	by imf25.hostedemail.com (Postfix) with ESMTP id E6D19A0009
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:31:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=d9WjUnY2;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.141 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789389103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5EMnGpXZdVV6iEqnxYfgPDtCGjl3w3zfhlKb+toiygw=;
	b=5l3IlP0T9pzxJS+kwcpaPfj+dKlwP16QQg9FJwiWUj5PsyDrFKPlvcVZ9A5aw9eNUAP813
	xmXlrr6QbdMfbTCvRuJRty04i9fd2rglIyIS07w/A4jbF2L5yYXMJPplvOlJfIfPkECM42
	QzwzLjgq4Gz7mQMYG/FlCQbn1WNYVxQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=d9WjUnY2;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.141 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789389103;
	b=dV2gef11M6LyXydhVQKUBh6/p/O41AQ6sO+wd2AxEdSsgDMzHiA6XvBIuuMAkOuO0HaAWW
	6xPTBWkWiQdPpgZmAQYXSJbhXTv0pHTHtgMixpYANz0QS/XqxeOyiC64pxA2DZMn3g0ICy
	zn+nRID+bVWyqGFqRCnRkL4rHPwo8nA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2eHW0y7y7uGyU1RGoY9G808x9f5l4A7c7aMBHiLQq+A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789389101; v=1; x=1789993901;
 b=d9WjUnY2evR8QgKHUj2PVKmLVy6KFGm5/nWQiO0iGSkyD3UtI0fv63IVqfX7onGpMML8L+Yp
 7SoPe0qwjpykcWqmwS2FAxk3gfajIMB+7e8/gKa0dSKCQk7ti3/Dukkh2Fj3sLJvpo4PYJKyChz
 1U87qA7KSWfsxxkobuDzjx1Q=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id d75a3d950def4de7;
	Mon, 14 Sep 2026 12:31:41 +0000
X-Mizu-Trace-ID: d75a3d950def4de7
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
Subject: [RESEND v7 16/29] mm: handle soft-dirty and uffd-wp on PMD swap entries
Date: Mon, 14 Sep 2026 05:28:06 -0700
Message-ID: <20260914122950.3283997-17-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914122950.3283997-1-usama.arif@linux.dev>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: s5yofp8yee133dwnuiqpeqxrp4tnd9ya
X-Rspamd-Queue-Id: E6D19A0009
X-Rspamd-Server: rspam07
X-HE-Tag: 1789389102-868863
X-HE-Meta: U2FsdGVkX18LMLMwMDE0SWc69PZfHQwOvBOswFAL48slBB2X6V5iTIco/rrxB1ih7XzYgc9HJ7CQL4BvdKoeeiui35kXg+dOYJuuMpHVDpH4fWJfW1od+k8Kz8kxbzBgQmU7sCZt4hUvT1J/XHip3TSw3FcuNZyIOc7Lwvy7phH+DQ9uDFdzOEAzIke21mEt9L46mo8TdyiXJSIZGSykM53OTF6IAHaXgUYMiAiusHQUpAh+wsY/sGC7ZApiSkJPlXO/fNNPvFXSxNjhzDZTFIG3CM8uP5EKyzH1g+o0Xn9MhQjp3v154YfYjEeJJTNOjPSYkgdhQ8yMvqp92J4S7LUDsXN5TsZjEKTDVAN+RD1dRK0U74jWMzmOax8amCZ31vpZ7B0C3REJrtexoOV8ZTr5ka0YZaZ3GjFWjZmWaI3TkQAFizY4dohBrPu02159Fu23MWtpgJeDwKL57CcKgzCQbMXWm+62AvFpPeEI33jE4GxFP+rkakq/8Av3z0D8h8s1ghDXlfykUipcD01N7wjlD7oTetkcUgxoVHepqd1b2evqo7+hkq75VarBG6QC2F1qk1/TY0b9huAvcqITc1RZJpYhdJyOEDvsjFWbdvDkFjQJhUSWt1E4JPaOA6w7xiLI2YlfSUKT9e6JkDqEuz5nXUyzUUv2zQnKM3bSiOsddqBHsKPzQ7vuBhnjyVULeY1o/cWiAT0qKeta+by7Fh6KmlXxGsrAeVWjOCCWp8zrx0MCjMYvclAvOkIwiKJDpJUdq27F2lsEteqtC4BdlKtPSv9THANpAsuKwZ7Vdepwt+YAxm5zfDh9jlP2gSA7mrR5VX5EVRkJIeHveb1QE/MerbsgLOtmVvk8r900XM7hMnfwq7tPNKgJcjXzXSLlZtsadLPpl942x2IhmE2ZxMb1HyyEWlvLdr6ooYY/pF/pOL5crQCxWTyCMV0HkgnIsK3fJiAFR8HdcZpnH0M
 bBRiQf/j
 3EwoTwu+9JOM/hFx6hGxQTjfN+zWkwqYpybJzYEG564j11sKWOeaAk8KaegP5GaFkl3g10WCqbstEFa9Qz02rXFPqBOa8S4h+9YKTjst0A3cX1txpketgTwSOsg3xGQbrJ5D1RT4PSdtF9/v4A060wEHSPq5EYkVxirN189brEsfXc0NhjKfERfcWzV9Y8REzpMrng4toHYVWKXNRUM/jRqMR4Sn/ypjntRXR6K0tnelRrXs=
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
index aa3f4d54a8580..ad0d4c7f0988b 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1654,7 +1654,7 @@ static void clear_soft_dirty_pmd(struct vm_area_struct *vma,
 		pmd = pmd_clear_soft_dirty(pmd);
 
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
-	} else if (pmd_is_migration_entry(pmd)) {
+	} else if (pmd_is_migration_entry(pmd) || pmd_is_swap_entry(pmd)) {
 		pmd = pmd_swp_clear_soft_dirty(pmd);
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
 	}
@@ -2480,7 +2480,7 @@ static void make_uffd_wp_pmd(struct vm_area_struct *vma,
 		old = pmdp_invalidate_ad(vma, addr, pmdp);
 		pmd = pmd_mkuffd(old);
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
-	} else if (pmd_is_migration_entry(pmd)) {
+	} else if (pmd_is_migration_entry(pmd) || pmd_is_swap_entry(pmd)) {
 		pmd = pmd_swp_mkuffd(pmd);
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
 	}
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 6dfe8ef6dd371..d3d0fec9a5ff3 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2660,7 +2660,8 @@ static inline int pmd_move_must_withdraw(spinlock_t *new_pmd_ptl,
 static pmd_t move_soft_dirty_pmd(pmd_t pmd)
 {
 	if (pgtable_supports_soft_dirty()) {
-		if (unlikely(pmd_is_migration_entry(pmd)))
+		if (unlikely(pmd_is_migration_entry(pmd) ||
+			     pmd_is_swap_entry(pmd)))
 			pmd = pmd_swp_mksoft_dirty(pmd);
 		else if (pmd_present(pmd))
 			pmd = pmd_mksoft_dirty(pmd);
@@ -2752,6 +2753,12 @@ static void change_non_present_huge_pmd(struct mm_struct *mm,
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
 
@@ -2812,7 +2819,7 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	if (!ptl)
 		return 0;
 
-	if (thp_migration_supported() && pmd_is_valid_softleaf(*pmd)) {
+	if (pmd_is_valid_softleaf(*pmd)) {
 		change_non_present_huge_pmd(mm, addr, pmd, uffd_prot,
 					    uffd_prot_resolve);
 		goto unlock;
-- 
2.53.0-Meta


