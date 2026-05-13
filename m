Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70295CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 08:57:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0C5A6B0098; Wed, 13 May 2026 04:57:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABCFE6B0099; Wed, 13 May 2026 04:57:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AC1C6B009B; Wed, 13 May 2026 04:57:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 856BB6B0098
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:57:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2969A8E4F6
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:57:05 +0000 (UTC)
X-FDA: 84761792010.27.7501F53
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7A39D2000C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:57:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=myrySgDe;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778662623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3igpV7gzcBN8HhIbThs8LU0JQ346/q/mwLYp2YFGET0=;
	b=wbmhkxgYWh0dUjkdByxFQ/jkGCgzOkOmmHlT9Op+x/j9jlJWrwhV/FXvjEgnS3Hx0Wrzu9
	hkwhjO6P8hZjvIsG016DeBpCQifi37mqbxLUJF9hn/j75WGO6iq1KDI2cx0PiH4z3v4XTE
	QWKj1v0SEPHDWisvhb7r8LL38wMjR3s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778662623; a=rsa-sha256;
	cv=none;
	b=0MOBA2o/Kjg5qhZJo6yX1NVTpdeK8+nI3S0FxSsXx312aWUmxOlNQKufPp6lRoWzubcUuc
	Pg1R4hqbQABZJWWniEGxxuTx+CmN/tRQjUttvAuZf4fudE3fSQfgp44V/ZxBIxDGqAnH2W
	JAqetN4FG5RLh1dOlvC5xkWMDpdrnHE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=myrySgDe;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 53750407CE;
	Wed, 13 May 2026 08:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF411C2BCC7;
	Wed, 13 May 2026 08:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778662622;
	bh=etQox4bpyMJaLJjIFJMcHDfNaUMAJVZYBekYtOtvN5c=;
	h=From:To:Cc:Subject:Date:From;
	b=myrySgDeekoigU8iTI7HFpk3EFlpwlbXMeCkmW3a4DJY552jlhYwDtfDyDVsnsyX6
	 CJsJrZbnFKlbTM++xJJFClY0MTnaJiyliAh8xl0O6F/I46c0qB65kIvE5+MJ5jdN9i
	 gDbDEp1vgrtrN8ZeOrwSqTIaLCROXvU3YSOG06AUnfP/1tT+uWrfU1OoB2EsrHlPen
	 1iC+lDNprwByBn/X6OQ8XBWnKGQlf3rdBPgfwoxVHeBX+4zqLCvU09cKC0HvQWv0HT
	 Fr76R/T2h8GDIP8eCqfg7iejIm5tYLCZidbD8sg/yNxCPM2F93oppFrIsOvo9Gu75C
	 RKidZefePA5Jw==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Jann Horn <jannh@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH mm-hotfixes] mm/hugetlb: avoid false positive lockdep assertion
Date: Wed, 13 May 2026 09:56:58 +0100
Message-ID: <20260513085658.45264-1-ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7A39D2000C
X-Rspam-User: 
X-Stat-Signature: e5gk9go1osfqpjf67zmneuwfente9u7a
X-HE-Tag: 1778662623-905425
X-HE-Meta: U2FsdGVkX1+262ZkwQEu9ga2QIHVBOCG++9sym87BAwBZY+XBqcIJ2osv89S0zi7iRpKg5U1FzepCVBGli3o/Rf+ZxUvUI24CSgtbC9iWza597Xd7E1Pzv7vhcY20FsykQGKeWCAX9cf1A8RGPMSiS0B0nD6cZWdblpI1n3bTdhxRWty/8C281Y9CNoVmT9jkJ+fSsJB2KYstTalxySYT1Km/uIcPOzoj3zup4yztFTsGuWMgTuCvJ9tRnxHfsphgWwwGPXfSWBFQszCNyl9O7UIFRrLYvyKdWRzRdBYPKK/Gkppl7sYlD7UiLrM/OUV71o1zR32o9y0TQRhJZGD3K8ODRwr4mC75DB+w+pgM+K3pD68QFtlUkprDaJeeIxL5IGBrXmqjU2UiRYnvM07BqtBluhgUSJzYo0mnhRFcPDNIEZq4fj1+BysZMFwP8EUvGu56YE3Qa3IXkWfkFXEUv0lLVXtAJ1GST78c/Z8l+6pBqdx4mm0hoA7vjXjuwG03pgjRBEEk00GIssiiZg+bxezfFk880+82Wi+OeVTFrkspwGl6XQFjx0pMvbQJ0vWQv/tECjmzsGD4aGwyOQd+LbY4vg+y2QY4iBcy7GmO11VhDGt7pRsJpXFadNstw4II1wcQkxywWG4FDjL/FSZNNWJPZKHCGRkDmCgHas3tjvkZ3TY9X0dfvMW8+V9YFqFRcGrDGROU1+7dhbKk3yBD+sqdDNgltFqT0QF6IpIN0oXSmTTYxUpKcY6eJf4AxKZQQ+GpRttyqdcYIlK847WTMy/7/p8gRVbPfl2cl1JzqoJeY0GYVbRHFsKL/+O9/+fwgEGblDKDYh/TdouFxbbt+GcXPrAoNrNuBxkXyAxQWwxLJwZYoG3cD/VFlZm6XKnzA9wXqLn+IofdNngK5u2afvmRhNUKQpEpEYzkG+0sicnnY+14TKeqgrdVHhZT3hhmrVfdHC9lTxaikvMmOL
 26L430L7
 1TwTLKuh5TS1Q+yPujc2oX3TMDOPc5z9EVbqOr8YSOYOlBjLnF5/yyKYlwxrjU69Ff6MkSVcYI6dPYgcf8OAreSK4uJG0cyLnGg+Mzsz4PRNhlp1w4OIfvH0IXV7+lQML9xDioMGjR3psSwmN8O+KgD4+r68gxtpMG+k6uv5eLwP6DRKgyJ2o2+vyUKuK93ngwmEvPOOaXEPwRNVpKUgy4SlxKT1ZMwjnvH9oBTkiE2xTfu8Qh1H394GbIrBc8n7VLc+jSsE9NNSBRWc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 081056dc00a2 ("mm/hugetlb: unshare page tables during VMA split, not
before") changed the locking model around hugetlbfs PMD unsharing on VMA
split, but did not update the function which asserts the locks,
hugetlb_vma_assert_locked().

This function asserts that either the hugetlb VMA lock is held (if a shared
mapping) or that the reservation map lock is held (if private).

If you get an unfortunate race between something which results in one of
these locks being released and a hugetlb split and you have CONFIG_LOCKDEP
enabled, you can therefore see a false positive assertion arise when there
is in fact no issue.

Since this change introduced a new take_locks parameter to
hugetlb_unshare_pmds(), which, when set to false, indicates that locking is
sufficient, simply pass this to the unsharing logic and predicate the
lock assertions on this.

This is safe, as we already asserted the file rmap lock and the VMA write
lock prior to this (implying exclusive mmap write lock), so we cannot be
raced by either rmap or page fault page table walkers which the asserted
locks are intended to protect against (we don't mind GUP-fast).

Separate out huge_pmd_unshare() into __huge_pmd_unshare() to add a
check_locks parameter, and update hugetlb_unshare_pmds() to pass this
parameter to it.

This leaves all other callers of huge_pmd_unshare() still correctly
asserting the locks.

The below reproducer will trigger the assert in a kernel with
CONFIG_LOCKDEP enabled by racing process teardown (which will release the
hugetlb lock) against a hugetlb split.

void execute_one(void)
{
	void *ptr;
	pid_t pid;

	/*
	 * Create a hugetlb mapping spanning a PUD entry.
	 *
	 * We force the hugetlb page allocation with populate and
	 * noreserve.
	 *
	 * |---------------------|
	 * |                     |
	 * |---------------------|
	 * 0                 PUD boundary
	 */
	ptr = mmap(0, PUD_SIZE, PROT_READ | PROT_WRITE,
		   MAP_FIXED | MAP_SHARED | MAP_ANON |
		   MAP_NORESERVE | MAP_HUGETLB | MAP_POPULATE,
		   -1, 0);
	if (ptr == MAP_FAILED) {
		perror("mmap");
		exit(EXIT_FAILURE);
	}

	/*
	 * Fork but with a bogus stack pointer so we try to execute code in
	 * a non-VM_EXEC VMA, causing segfault + teardown via exit_mmap().
	 *
	 * The clone will cause PMD page table sharing between the
	 * processes first via:
	 * copy_process() -> ... -> huge_pte_alloc() -> huge_pmd_share()
	 *
	 * Then tear down and release the hugetlb 'VMA' lock via:
	 * exit_mmap() -> ... -> vma_close() -> hugetlb_vma_lock_free()
	 */
	pid = syscall(__NR_clone, 0, 2 * PMD_SIZE, 0, 0, 0);
	if (pid < 0) {
		perror("clone");
		exit(EXIT_FAILURE);
	} if (pid == 0) {
		/* Pop stack... */
		return;
	}

	/*
	 * We are the parent process.
	 *
	 * Race the child process's teardown with a PMD unshare.
	 *
	 * We do this by triggering:
	 *
	 * __split_vma() -> hugetlb_split() -> hugetlb_unshare_pmds()
	 *
	 * Which, importantly, doesn't hold the hugetlb VMA lock (nor can
	 * it), meaning we assert in hugetlb_vma_assert_locked().
	 *
	 *            .
	 * |----------.----------|
	 * |          .          |
	 * |----------.----------|
	 * 0          .     PUD boundary
	 */
	mmap(0, PUD_SIZE / 2, PROT_READ | PROT_WRITE,
	     MAP_FIXED | MAP_ANON | MAP_PRIVATE, -1, 0);
}

int main(void)
{
	int i;

	/* Kick off fork children. */
	for (i = 0; i < NUM_FORKS; i++) {
		pid_t pid = fork();

		if (pid < 0) {
			perror("fork");
			exit(EXIT_FAILURE);
		}

		/* Fork children do their work and exit. */
		if (!pid) {
			int j;

			for (j = 0; j < NUM_ITERS; j++)
				execute_one();
			return EXIT_SUCCESS;
		}
	}

	/* If we succeeded, wait on children. */
	for (i = 0; i < NUM_FORKS; i++)
		wait(NULL);

	return EXIT_SUCCESS;
}

Fixes: 081056dc00a2 ("mm/hugetlb: unshare page tables during VMA split, not before")
Cc: <stable@vger.kernel.org>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/hugetlb.c | 46 +++++++++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 19 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 31b34ca0f402..d84116f9eec0 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6906,6 +6906,31 @@ pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 	return pte;
 }

+static int __huge_pmd_unshare(struct mmu_gather *tlb,
+		struct vm_area_struct *vma, unsigned long addr, pte_t *ptep,
+		bool check_locks)
+{
+	unsigned long sz = huge_page_size(hstate_vma(vma));
+	struct mm_struct *mm = vma->vm_mm;
+	pgd_t *pgd = pgd_offset(mm, addr);
+	p4d_t *p4d = p4d_offset(pgd, addr);
+	pud_t *pud = pud_offset(p4d, addr);
+
+	if (sz != PMD_SIZE)
+		return 0;
+	if (!ptdesc_pmd_is_shared(virt_to_ptdesc(ptep)))
+		return 0;
+	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
+	if (check_locks)
+		hugetlb_vma_assert_locked(vma);
+	pud_clear(pud);
+
+	tlb_unshare_pmd_ptdesc(tlb, virt_to_ptdesc(ptep), addr);
+
+	mm_dec_nr_pmds(mm);
+	return 1;
+}
+
 /**
  * huge_pmd_unshare - Unmap a pmd table if it is shared by multiple users
  * @tlb: the current mmu_gather.
@@ -6925,24 +6950,7 @@ pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 int huge_pmd_unshare(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		unsigned long addr, pte_t *ptep)
 {
-	unsigned long sz = huge_page_size(hstate_vma(vma));
-	struct mm_struct *mm = vma->vm_mm;
-	pgd_t *pgd = pgd_offset(mm, addr);
-	p4d_t *p4d = p4d_offset(pgd, addr);
-	pud_t *pud = pud_offset(p4d, addr);
-
-	if (sz != PMD_SIZE)
-		return 0;
-	if (!ptdesc_pmd_is_shared(virt_to_ptdesc(ptep)))
-		return 0;
-	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
-	hugetlb_vma_assert_locked(vma);
-	pud_clear(pud);
-
-	tlb_unshare_pmd_ptdesc(tlb, virt_to_ptdesc(ptep), addr);
-
-	mm_dec_nr_pmds(mm);
-	return 1;
+	return __huge_pmd_unshare(tlb, vma, addr, ptep, /*check_locks=*/true);
 }

 /*
@@ -7284,7 +7292,7 @@ static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 		if (!ptep)
 			continue;
 		ptl = huge_pte_lock(h, mm, ptep);
-		huge_pmd_unshare(&tlb, vma, address, ptep);
+		__huge_pmd_unshare(&tlb, vma, address, ptep, take_locks);
 		spin_unlock(ptl);
 	}
 	huge_pmd_unshare_flush(&tlb, vma);
--
2.54.0

