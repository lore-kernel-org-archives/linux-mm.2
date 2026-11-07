Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2076A606A32D
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 22:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZxAlKgYd
Received: by kanga.kvack.org (Postfix)
	id 340086B05B2; Sat,  7 Nov 2026 17:24:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 316896B05B8; Sat,  7 Nov 2026 17:24:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 206466B05BE; Sat,  7 Nov 2026 17:24:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E7FF06B05B2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:24:29 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7BCFBA03F4
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:24:29 +0000 (UTC)
X-FDA: 85409753058.27.F42D746
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id AA52E140004
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:24:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZxAlKgYd;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794090267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WtEZdA6Wi2SP26pE/qnVtNr9Wkimj3gks8WQKsUMrmY=;
	b=5n1c+oOmhS7CTIffBEq4oqfz0NaP4jby5Nl8aTfN1/ZI220QetB5jKLLpC1RVcfPTfIIXO
	WjUsjK2aAWgSxdCqTOZqgbCmnXpqz8wLsNllHckRLDS8t9BRNMyMXZXTCKXQNh+bAKQfK9
	tThRB92C+xfZeNDJ4YNAMD+7KRDey3o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794090267;
	b=K3KntsqcrqWuCCxKXIS23/+YoBMdvRHbxnd7skx0Eq1R3virWwhQhfqM9BOfuP5xH7iKrZ
	H6mlVFQ1NawLkoFSfR5TFEK9kAyZrfePGpFSFdEayhrFNhbYmtQX2wuvHSalTnRHtPcxXH
	h2d9Mi15Q7BAs6qUojpiw9TxyB/MIIs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZxAlKgYd;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F38414069E;
	Sat,  7 Nov 2026 22:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A081F008A1;
	Sat,  7 Nov 2026 22:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794090266;
	bh=WtEZdA6Wi2SP26pE/qnVtNr9Wkimj3gks8WQKsUMrmY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZxAlKgYdcsdfcplYAoaxdnR0L5kEsLy/hPVQskRyX/bGDfYFHfg1IxCJdaBNJIxF5
	 SODlq45HAhqJUA2HInlD3KYIKd6iPEv8zHqszJO8CoyhEzxYwikjSCmcZpxD5y369+
	 4NSZGfcyP9eKCSQWRhmG6eyK1K5NBETafoloJ8p66PESL+uLbkCxsHAWOVs01VpiVY
	 GthYD6JEG7+Wv4LIbXLBzDsIzto5Jqi/USai0z2hmefQ6Dx2Q+k1+s02tkFtv4/cN0
	 zUBjiVvYgsryF94hYtce/D6XkhWGsB6kCm4YV5aSDqswAChojwfGT27xP4Eepf0qUx
	 vrUoa9s+a8mEQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 07 Nov 2026 23:23:37 +0100
Subject: [PATCH v2 1/5] mm: limit pagecache folio refcount when mapping
 pages
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261107-refcount_overflow_stable-v2-1-c38f6809b106@kernel.org>
References: <20261107-refcount_overflow_stable-v2-0-c38f6809b106@kernel.org>
In-Reply-To: <20261107-refcount_overflow_stable-v2-0-c38f6809b106@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Song Liu <songliubraving@fb.com>, 
 Rik van Riel <riel@surriel.com>, Miklos Szeredi <miklos@szeredi.hu>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Hugh Dickins <hughd@google.com>, 
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
 Robin Murphy <robin.murphy@arm.com>, 
 Steve Sistare <steven.sistare@oracle.com>, 
 John Hubbard <jhubbard@nvidia.com>, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
 Josef Bacik <josef@toxicpanda.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 fuse-devel@lists.linux.dev, linux-arch@vger.kernel.org, 
 iommu@lists.linux.dev, Chris Mason <mason@kernel.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=15032; i=david@kernel.org;
 h=from:subject:message-id; bh=IKW52LWjd1mBBexmwcOzA9oiOBd77E3VRfpttg60TuY=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLeL2Xk23L0X9I27a9CiwTO7fvP+/dryEF1ffF/tSfkc
 44IcL9f1VHKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBEkgQZ/hlLJd9Xnf5dUj6P
 TYdr64odLn1f0xs/Kj0/NPf2ziVhZvMZGX5zfciafiTmpNvNHgmBIy8r/qR8Pjnb46PizUUnWBO
 13rABAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: w6egb18so19oswgob3zwrq8zeyucknb5
X-Rspamd-Queue-Id: AA52E140004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794090267-441402
X-HE-Meta: U2FsdGVkX189JmImGN9bCK+89kt9A1/zfTSzlLjpt/a19UTyDh62+rABFOVZ+61EZuGfDu//Z9I+jmSBcHQJO6jfMfJg+HFyqbyr7sXfAAqlzakMZWa7KtL6E5NGgN1ptWoMPhZE77m/imyr2/opOhUU64ohxeDuZIVzKr2I7ZuUSDsfz0K27EMpU12m+wdYS+NMHhINd8CXccfT+I7ijgW36771neDnlnKJb8w0AqdLuDMj0ETE8pOZBHXYJL0n3MbN/zu6eEhNwN8DFvAXjb5gx8REaUD5mB9E15+doQBWHI1KrbOBFIerZsxiNurTZVyYbyurNaA1tJX1H3GRmvJFkxe1Cj5ccYRWXVK/124WPiagHGh9ffyhm0kaYDlwF7ff/4IEodhERQQg6t0Mds42vIIIqGXKkJnFW2ER3apj0x5dpmTYup21k6yk924eaE5lwGfpH0hPS1ZVIxed4eeOlLqfYILaaKfHrMLQ9YA5N016UiKRRFngG4p8zo65JGGq7n6ZnlyuiG+HB+X7thtAe25qHkIZ7oDZpUQWUzuZ3Mz9aN9VQ/zE7HDY596gYj9Ib0XF2FwoZHZW8BewXAMFSvZ7d4lEUy3QcENBshJlX6HnNMBULFU4fdbUn3w4ElTI7hmDwyYh2iZKvvOc6cBmgv4UVmis/8Tcs00GTIIgtYA1cKw2C+sV1Wb7A+gKi1gfLUzXZ/zOFI6+qoKKGoemBf8PJTxueM9ciEXc9OL4O9pIIFX6Xd6eXURqQpPTsONpwDv5KXfbpT0wI93XHW74trlPI1QrAdaARLNmj2nYYPS/AWoJRnzoWrDDC4BdwpYp/4eZEnU39NsZfwSnXCmZYk/AU5CiJZ3j4wQzL8z814KeJn1PjagavfKyD5EPOChYTU/rO0jHmzqk8BIlwQh72YlgzBsSYB979ki0ruYFxFX/Sbx0b4nZRBATUmew0vvlIa6NxJ641Gtdb5+
 F4OLXoHm
 necPZ7DFBkHKPrUvOQGt+XvxHEKW6J3e0e4kqEY4XaB0hg+gfNr7XCIFt6mxZ8ElSjYcYYPWQkP+6J3fpi+2ouwxqbRhv87OmsETzJ5ISxmtu0zV+eWcnQMBdEb9jhI8Lfjy2wfOOCzQQ/npfkGV9tNrRClbKl2bKDTHIwDaQoeQY/OhALjjHLFQbvBo9ImtuHo4QqSlSNAPXydHWs+3C63RAN8IllhZrxbx82mshZwXttt2GkJ3ZsFSn7X3LoA11uGWfHkKOklzUenZGHpvWUjhkBZIBVP7Z7EMuDuW7jB20qVU6YcSHrcV+4IU8QZgIYK4y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With large file folios, overflowing the folio mapcount and refcount
became possible. For anon folios it is currently not really an issue:
each large anon folio can only be mapped once into a process; on 4k
kernels it would be more processes than usually allowed on a system, and
on 16k or 64k kernels the processes alone would consume hundreds of GiB.
Something to be sorted out at some point, but it's not as urgent.

Being able to overflow the refcount is not really big news, but it's about
time that we do something about it because some modern technology might
find ways to abuse it :)

One of the enablers for that was commit ddc58f27f9ee ("mm: drop tail page
refcounting"), however, file thp support was added later.

File folios can be mapped multiple times into the same process, allowing
for processes to hold many references to the same folio.

As a short-term solution, let's introduce two folio refcount limits:
one for ordinary consumers and one for admins. Leave some headroom
before the refcount goes negative, which we really don't want (having
the mapcount go negative is also not expected).

Start reporting SIGBUS if we run into limits. When restoring mappings
from migration entries, instead zap the pte/pmd entry. We allow for
slightly exceeding the limit to keep things simpler.

During fork(), prefer not copying page table entries over failing fork.
Export __folio_ref_count_over_limit() right away as that will be needed
from fuse code next. Use has_capability_noaudit(current, CAP_SYS_RESOURCE),
so filesystem credential overrides do not affect access to the admin
reserve, and to not generate auditing messages simply because we access
optional reserves.

This is far from ideal, but better than all easy alternatives we can
backport comfortably. For now it fixes the big problem: letting
the refcount (+mapcount) go negative and cause trouble.

This is only a temporary fix, we'll follow up with something better.

Check order 0 folios as well for consistency: each
folio_add_file_rmap*() and folio_dup_file_rmap*() needs a prior check.

Also, just document -EHWPOISON for copy_present_ptes() while at it.

Note: When zapping file migration entries, uffd-wp is preserved using PTE
markers, but uffd-rwp protection is lost because there is no corresponding
marker. try_to_unmap() already has the same problem when unmapping file
folios, so we'll happily ignore it.

Note2: For now we don't let migration or PTE table collapse exceed any
limits. Admins can always refault, and if we are already operating in
admin reserves, something is already off.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mm.h | 30 ++++++++++++++++++++++++++++++
 mm/filemap.c       |  6 ++++++
 mm/huge_memory.c   | 29 +++++++++++++++++++++++++++--
 mm/memory.c        | 35 +++++++++++++++++++++++++++++++----
 mm/migrate.c       | 11 +++++++++++
 mm/userfaultfd.c   |  4 ++++
 mm/util.c          | 12 ++++++++++++
 7 files changed, 121 insertions(+), 6 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6a34dd3800f56..3356f7a670d1e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2232,6 +2232,36 @@ vm_fault_t finish_fault(struct vm_fault *vmf);
 #define folio_ref_zero_or_close_to_overflow(folio) \
 	((unsigned int) folio_ref_count(folio) + 127u <= 127u)
 
+/* Leave separate reserves for administrators and concurrent reference gains. */
+#define FOLIO_REF_COUNT_LIMIT		(INT_MAX - (1U << 26))
+#define FOLIO_REF_COUNT_ADMIN_LIMIT	(INT_MAX - (1U << 25))
+
+bool __folio_ref_count_over_limit(unsigned int ref_count);
+
+/**
+ * folio_ref_count_over_limit - Check whether to refuse more folio references.
+ * @folio: The folio.
+ *
+ * Check before adding page table mappings or other significant refcount users
+ * to large pagecache folios (!hugetlb), to avoid overflows.
+ *
+ * Checking other folios does no harm.
+ *
+ * This check is an approximation; we leave some headroom such that concurrent
+ * increments, batches and temporary references are not a problem.
+ *
+ * Return: True if the caller should refuse additional references, false
+ * otherwise.
+ */
+static inline bool folio_ref_count_over_limit(const struct folio *folio)
+{
+	const unsigned int ref_count = folio_ref_count(folio);
+
+	if (likely(ref_count < FOLIO_REF_COUNT_LIMIT))
+		return false;
+	return __folio_ref_count_over_limit(ref_count);
+}
+
 /**
  * folio_get - Increment the reference count on a folio.
  * @folio: The folio.
diff --git a/mm/filemap.c b/mm/filemap.c
index 86297841f9955..920bbf86dfdff 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3968,6 +3968,11 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 		unsigned long end;
 		vm_fault_t map_ret;
 
+		if (unlikely(folio_ref_count_over_limit(folio))) {
+			folio_ref_dec(folio);
+			goto next;
+		}
+
 		addr += (xas.xa_index - last_pgoff) << PAGE_SHIFT;
 		vmf->pte += xas.xa_index - last_pgoff;
 		last_pgoff = xas.xa_index;
@@ -4009,6 +4014,7 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 					   mmap_miss - 1);
 		}
 
+next:
 		folio_unlock(folio);
 	} while ((folio = next_uptodate_folio(&xas, mapping, end_pgoff)) != NULL);
 	add_mm_counter(vma->vm_mm, folio_type, rss);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d0e19d9e6b651..7cae95070841a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1626,6 +1626,7 @@ static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pgtable_t pgtable = NULL;
+	vm_fault_t ret = VM_FAULT_NOPAGE;
 	spinlock_t *ptl;
 	pmd_t entry;
 
@@ -1662,6 +1663,10 @@ static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
 		if (is_huge_zero_folio(fop.folio)) {
 			entry = pmd_mkspecial(entry);
 		} else {
+			if (unlikely(folio_ref_count_over_limit(fop.folio))) {
+				ret = VM_FAULT_SIGBUS;
+				goto out_unlock;
+			}
 			folio_get(fop.folio);
 			folio_add_file_rmap_pmd(fop.folio, &fop.folio->page, vma);
 			add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PMD_NR);
@@ -1688,7 +1693,7 @@ static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
 	spin_unlock(ptl);
 	if (pgtable)
 		pte_free(mm, pgtable);
-	return VM_FAULT_NOPAGE;
+	return ret;
 }
 
 /**
@@ -1759,6 +1764,7 @@ static vm_fault_t insert_pud(struct vm_area_struct *vma, unsigned long addr,
 		pud_t *pud, struct folio_or_pfn fop, pgprot_t prot, bool write)
 {
 	struct mm_struct *mm = vma->vm_mm;
+	vm_fault_t ret = VM_FAULT_NOPAGE;
 	spinlock_t *ptl;
 	pud_t entry;
 
@@ -1784,6 +1790,10 @@ static vm_fault_t insert_pud(struct vm_area_struct *vma, unsigned long addr,
 	if (fop.is_folio) {
 		entry = folio_mk_pud(fop.folio, vma->vm_page_prot);
 
+		if (unlikely(folio_ref_count_over_limit(fop.folio))) {
+			ret = VM_FAULT_SIGBUS;
+			goto out_unlock;
+		}
 		folio_get(fop.folio);
 		folio_add_file_rmap_pud(fop.folio, &fop.folio->page, vma);
 		add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PUD_NR);
@@ -1799,7 +1809,7 @@ static vm_fault_t insert_pud(struct vm_area_struct *vma, unsigned long addr,
 	update_mmu_cache_pud(vma, addr, pud);
 out_unlock:
 	spin_unlock(ptl);
-	return VM_FAULT_NOPAGE;
+	return ret;
 }
 
 /**
@@ -2095,6 +2105,11 @@ int copy_huge_pud(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma
 	if (page) {
 		struct folio *folio = page_folio(page);
 
+		if (unlikely(folio_ref_count_over_limit(folio))) {
+			/* Skip this PUD; it can be faulted in later. */
+			ret = (dst_vma->vm_flags & VM_MIXEDMAP) ? -ENOMEM : 0;
+			goto out_unlock;
+		}
 		folio_get(folio);
 		/*
 		 * TODO: once we support anonymous pages, use
@@ -5215,6 +5230,16 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct folio *folio
 	if (!(pvmw->pmd && !pvmw->pte))
 		return;
 
+	if (!folio_test_anon(folio) && unlikely(folio_ref_count_over_limit(folio))) {
+		/* Leave the file mapping absent so it can be faulted in. */
+		pmd_clear(pvmw->pmd);
+		if (arch_needs_pgtable_deposit())
+			zap_deposited_table(mm, pvmw->pmd);
+		update_hiwater_rss(mm);
+		add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
+		return;
+	}
+
 	entry = softleaf_from_pmd(*pvmw->pmd);
 	folio_get(folio);
 	pmde = folio_mk_pmd(folio, READ_ONCE(vma->vm_page_prot));
diff --git a/mm/memory.c b/mm/memory.c
index d33a2e1512f74..7e1cdaa80b75f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1166,9 +1166,14 @@ static __always_inline void __copy_present_ptes(struct vm_area_struct *dst_vma,
 /*
  * Copy one present PTE, trying to batch-process subsequent PTEs that map
  * consecutive pages of the same folio by copying them as well.
+ * PTEs mapping an over-limit file folio can be skipped if a fault in the
+ * child will reconstruct them.
  *
  * Returns -EAGAIN if one preallocated page is required to copy the next PTE.
- * Otherwise, returns the number of copied PTEs (at least 1).
+ * Returns -ENOMEM if the file folio refcount is too high and the PTE must
+ * be copied.
+ * Returns -EHWPOISON if copying a page fails.
+ * Otherwise, returns the number of processed PTEs (at least 1).
  */
 static inline int
 copy_present_ptes(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
@@ -1186,6 +1191,16 @@ copy_present_ptes(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma
 
 	folio = page_folio(page);
 
+	if (!folio_test_anon(folio) && unlikely(folio_ref_count_over_limit(folio))) {
+		if (dst_vma->vm_flags & VM_MIXEDMAP)
+			return -ENOMEM;
+		if (userfaultfd_pte_rwp(dst_vma, pte))
+			return -ENOMEM;
+		/* Preserve uffd-wp protection when faulting the page back in. */
+		cond_install_uffd_wp_ptes(dst_vma, addr, dst_pte, pte, 1);
+		return 1;
+	}
+
 	/*
 	 * If we likely have to copy, just don't bother with batching. Make
 	 * sure that the common "small folio" case is as fast as possible
@@ -1367,9 +1382,9 @@ copy_pte_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
 		/*
 		 * If we need a pre-allocated page for this pte, drop the
 		 * locks, allocate, and try again.
-		 * If copy failed due to hwpoison in source page, break out.
+		 * Other errors abort the copy after releasing the page table locks.
 		 */
-		if (unlikely(ret == -EAGAIN || ret == -EHWPOISON))
+		if (unlikely(ret < 0))
 			break;
 		if (unlikely(prealloc)) {
 			/*
@@ -1399,7 +1414,7 @@ copy_pte_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
 			goto out;
 		}
 		entry.val = 0;
-	} else if (ret == -EBUSY || unlikely(ret == -EHWPOISON)) {
+	} else if (ret == -EBUSY || ret == -ENOMEM || unlikely(ret == -EHWPOISON)) {
 		goto out;
 	} else if (ret ==  -EAGAIN) {
 		prealloc = folio_prealloc(src_mm, src_vma, addr, false);
@@ -2474,6 +2489,8 @@ static int insert_page_into_pte_locked(struct vm_area_struct *vma, pte_t *pte,
 	if (unlikely(is_zero_folio(folio))) {
 		pteval = pte_mkspecial(pteval);
 	} else {
+		if (unlikely(folio_ref_count_over_limit(folio)))
+			return -EOVERFLOW;
 		folio_get(folio);
 		pteval = mk_pte(page, prot);
 		if (mkwrite) {
@@ -5752,6 +5769,9 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	if (unlikely(folio_test_has_hwpoisoned(folio)))
 		return ret;
 
+	if (unlikely(folio_ref_count_over_limit(folio)))
+		return VM_FAULT_SIGBUS;
+
 	/*
 	 * Archs like ppc64 need additional space to store information
 	 * related to pte entry. Use the preallocated table for that.
@@ -5806,6 +5826,9 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
  * @page: The first page to create a PTE for.
  * @nr: The number of PTEs to create.
  * @addr: The first address to create a PTE for.
+ *
+ * For file mappings, the caller must check folio_ref_count_over_limit()
+ * before adding the mapping references and installing PTEs.
  */
 void set_pte_range(struct vm_fault *vmf, struct folio *folio,
 		struct page *page, unsigned int nr, unsigned long addr)
@@ -5972,6 +5995,10 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 		goto fallback;
 	}
 
+	if (!is_cow && unlikely(folio_ref_count_over_limit(folio))) {
+		ret = VM_FAULT_SIGBUS;
+		goto unlock;
+	}
 	folio_ref_add(folio, nr_pages - 1);
 	set_pte_range(vmf, folio, page, nr_pages, addr);
 	type = is_cow ? MM_ANONPAGES : mm_counter_file(folio);
diff --git a/mm/migrate.c b/mm/migrate.c
index 092fca80927a7..153a93b0c38d7 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -385,6 +385,17 @@ static bool remove_migration_pte(struct folio *folio,
 		    try_to_map_unused_to_zeropage(&pvmw, folio, old_pte, idx))
 			continue;
 
+		if (!folio_test_anon(folio) && !folio_test_hugetlb(folio) &&
+		    unlikely(folio_ref_count_over_limit(folio))) {
+			/* File contents remain available for a later fault. */
+			pte_clear(vma->vm_mm, pvmw.address, pvmw.pte);
+			cond_install_uffd_wp_ptes(vma, pvmw.address,
+						  pvmw.pte, old_pte, 1);
+			update_hiwater_rss(vma->vm_mm);
+			dec_mm_counter(vma->vm_mm, mm_counter_file(folio));
+			continue;
+		}
+
 		folio_get(folio);
 		new = folio_page(folio, idx);
 		pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 169f681f9849b..89853c157fa91 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -373,6 +373,10 @@ static int mfill_atomic_install_pte(pmd_t *dst_pmd,
 		goto out_unlock;
 
 	if (page_in_cache) {
+		if (unlikely(folio_ref_count_over_limit(folio))) {
+			ret = -ENOMEM;
+			goto out_unlock;
+		}
 		folio_add_file_rmap_pte(folio, page, dst_vma);
 	} else {
 		folio_add_new_anon_rmap(folio, dst_vma, dst_addr, RMAP_EXCLUSIVE);
diff --git a/mm/util.c b/mm/util.c
index 80f6c714844f2..a906dfa755ff1 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -791,6 +791,18 @@ int folio_mc_copy(struct folio *dst, struct folio *src)
 }
 EXPORT_SYMBOL(folio_mc_copy);
 
+bool __folio_ref_count_over_limit(unsigned int ref_count)
+{
+	if (ref_count >= FOLIO_REF_COUNT_ADMIN_LIMIT)
+		return true;
+	/* Background threads must not consume admin reserves. */
+	if (current->flags & PF_KTHREAD)
+		return true;
+	/* Use the task's credentials, which filesystem overrides cannot change. */
+	return !has_capability_noaudit(current, CAP_SYS_RESOURCE);
+}
+EXPORT_SYMBOL_GPL(__folio_ref_count_over_limit);
+
 int sysctl_overcommit_memory __read_mostly = OVERCOMMIT_GUESS;
 static int sysctl_overcommit_ratio __read_mostly = 50;
 static unsigned long sysctl_overcommit_kbytes __read_mostly;

-- 
2.56.0


