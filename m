Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F917606D809
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 13:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mQHxJsjw
Received: by kanga.kvack.org (Postfix)
	id 828556B05B5; Thu,  5 Nov 2026 08:10:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D2476B05B8; Thu,  5 Nov 2026 08:10:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69A9F6B05BC; Thu,  5 Nov 2026 08:10:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D09F96B05B5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:10:41 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5BBC8808DC
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:10:41 +0000 (UTC)
X-FDA: 85401099882.28.ABFC129
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 973AD180010
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:10:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mQHxJsjw;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793884239;
	b=h6TCzrWa7N0/JQVIMolp2WfutYN1Z348eQoPZMyW1aWuZhkrvkVv9MPfsEnAvJWPGvc/84
	9Cr/w8ptatoLQdVm78lTwaAESy/g2DPczlEcSYubSoVY5hmPcFrnmpQ8XzowGod0SrRqSX
	pdQzBngaTifZ1Sv4MCFZ1vgTKL11c7Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mQHxJsjw;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793884239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1+O4mJb0ZnCTkdkPgFaj7yjDiw7BiH4z6F18NP5QRP0=;
	b=Dmh9kzWBVCU1sHqXJPQBxXI5aNN8nzBzmhqm/y3RQ7UqqiqMs77KnLUl68yBwVDySOfO97
	AuKXc3pJfFRSJEuhXcGgNPFWF5MSs+vpcbQxtw5MaG35BkVyHUoYQ/IV2QWFHuJBWYMWyu
	x86vQlrLgT74yBkqBm31iuZcPImX70Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1F78160F4E;
	Thu,  5 Nov 2026 13:10:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B1881F0093A;
	Thu,  5 Nov 2026 13:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793884238;
	bh=1+O4mJb0ZnCTkdkPgFaj7yjDiw7BiH4z6F18NP5QRP0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mQHxJsjwHmJh8tS/gg/DRAB4SOPg14GkLaveckiSt2kXjZ1scR3eq7mR2VCXqBMyj
	 dM28omtD9Xm8ICRfbe3MWHryvzjoRVgIoAu154ukXqPY7ei2T0KF/BQ23m7p7/cy04
	 HLoCcl4lVdxiPaYm3Y2Q+N++32IS5NqM9dzfdn3UKRIEnNs1M+kWdN7l/Yd0gl6JOO
	 R/1rDYpvyMVtT2kNrzStJ78MeMaq4B6WZiYAi94eH/m7ALz4RTmdxnev6XBtP5dQ8o
	 bt92Hd4fa/8XaNq0N8EGpMAEcZFyoxX0Xt6AnJ/FqqQUJQmApFQdPFIfieTZDDzSn0
	 SDLNmktdXok7w==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 05 Nov 2026 14:10:10 +0100
Subject: [PATCH 1/5] mm: limit pagecache folio refcount when mapping pages
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-refcount_overflow_stable-v1-1-70b9c655da3e@kernel.org>
References: <20261105-refcount_overflow_stable-v1-0-70b9c655da3e@kernel.org>
In-Reply-To: <20261105-refcount_overflow_stable-v1-0-70b9c655da3e@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Song Liu <songliubraving@fb.com>, 
 Rik van Riel <riel@surriel.com>, Hugh Dickins <hughd@google.com>, 
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, 
 "Joerg Roedel (AMD)" <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>, 
 Steve Sistare <steven.sistare@oracle.com>, 
 John Hubbard <jhubbard@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
 iommu@lists.linux.dev, "David Hildenbrand (Arm)" <david@kernel.org>, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=12423; i=david@kernel.org;
 h=from:subject:message-id; bh=kOhA5Lx1zfxXu5x+0Jqb6rH31dR4RmE1KXuDIwjro44=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLeNFg80zztO7EpybMjrVdPfd3iWOefHuu2xtWZv8hYf
 Grh7T7pjlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACYyTYSR4dbk7HUFwcWLts/1
 +Sl93fDezun+tm/0F9kUs5aWzV5TNI3hv4PMQp2MFo4txaIlXDEcnhHnGLjeyMyXc+y8bKl6Rns
 KPwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 973AD180010
X-Stat-Signature: ywad1sc67pqne1zkhh53kdamoz6r4awz
X-Rspam-User: 
X-HE-Tag: 1793884239-386943
X-HE-Meta: U2FsdGVkX1/dfKVHXzCMgq0VKj47/bK8qKI19ZKliSnQhzD+kx9b12Fm2JHwQMCZHkbPkQvEETig8QjwVA/NG92jJqaXx+DODPogWixbwVFvOKi3xqM7YDOpaJLOILHiwA0j3IK6L1kUudGmmaE8/4A4qKGiXQTyfeGuTspWrWABTpSgOKT3ENqaovNZE21jrVWFYoIl69TtlVy2x8lSdWZU4sTjI5llfi2UQAt5vv9JHT5CnmIOk5LBzmdR+EMXb5RAm8bhvUrXuYDWPiIzimiz7vG3AjuOKnin5j0Dk3p1Wl7HYHnDvJu3X55Ae49zHGqlZ4CLgcwCFg/2Ad2R3fzuz/Xrwrpiw5NMfc3A4jXi20kzUcPpal4OzRvhfgP1z3IlxDurQOkyiZukyXTlxZrLIAMJ+Z48agqaSjU2bMJsRcDKewPGTO47SC5WlVm+D7TFWY5MyRjBuBqreM6oWvFVvzJfkJ77CaMic40zKLh9EpkzTVbJuG20kFf/rcyV1L0B30yc+9U0+wqqDiotYUgXxebbpAov4f8OWz+A40QyaHuzFoxjQBn9cSIKM4a/OoTRCLSulJ2aIgaHTQF0DuV995QLa/6ibzDxiXMsta4Qfy4Gnrg1KWc4t74zf6kgZX5wUDznNfzbAvv2/MKaECInEKXkRefbV9+8SYZ9veBfRdua0zAMR9XfXZ698INQP1uQJFHWBwzfEw+fJzTTwF4hHMVucWrhz7hyQ0JG5IK0C6FGUinU4QPW8fnhrGW22ffxTsq7DSMQRaTK8phrX4COhXK8KOftii0kE74G7XbZhuHAzBjVjbIKfnNIvNzSeEm1jZSTsNI4dWPRiLmyLHZYUoi62B6JVMucK6Eafzbr3ngBw80c5g4ZbfsKgWjPiH6LjW8roQoKwW97+CrW7/yKev8dwNg1kozPjOWMErV1WYzXQZGt2TpDlRV7nsKbgIBS+M8IsT6qVXmPKkt
 OE7b2DB7
 53Q6yLstzfxwc/pTrzPsLH0UXpS1PN7SWX0jWoWvZ/7xAViPQD7AzcA3y92Fm3y5iLy9cjGb+f3Yv9FIFqLj4JzZ+6+2oUllGp9dCr9Zx6R9dYKmDUdSTq13MYGq5yzoD6Sxtr7/LsUIufRtku/OtfZl7lVRGASMs0uGZJyJwIMMtU/9sgrOdcbQR7qs+BHMfM0baVf8jyJ0ymOpDQibG4uEqOD03AD27YVl6edb/ZhdRHSwOnzOD3IX6XhEE79mEHIGkGP2McowgkQQv0rGQps+8hArsaZPs5Y+EoL+sphN6Dj+LmRIYeLWMmUYSIg3JqWIL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With large file folios, overflowing the folio mapcount and refcount
became possible. For anon folios it is currently not really an issue:
each large anon folio can only be mapped once into a process.

That's not really big news, but it's about time that we do something
about it because some modern technology might find ways to abuse it :)

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

This is far from ideal, but better than all easy alternatives we can
backport comfortably. For now it fixes the big problem: letting
the refcount (+mapcount) go negative and cause trouble.

This is only a temporary fix, we'll follow up with something better.

While the refcount checks are not required for order 0 folios, let's
just add them for consistency: each folio_add_file_rmap*() and
folio_dup_file_rmap*() needs a prior check.

Also, just document -EHWPOISON for copy_present_ptes() while at it.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mm.h | 33 +++++++++++++++++++++++++++++++++
 mm/filemap.c       |  6 ++++++
 mm/huge_memory.c   | 24 ++++++++++++++++++++++--
 mm/memory.c        | 23 ++++++++++++++++++++---
 mm/migrate.c       | 11 +++++++++++
 mm/userfaultfd.c   |  4 ++++
 6 files changed, 96 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a2dd76cc5bbfe..79ae8fc0d6bb4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -8,6 +8,7 @@
 #include <linux/gfp.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/bug.h>
+#include <linux/capability.h>
 #include <linux/list.h>
 #include <linux/mmzone.h>
 #include <linux/rbtree.h>
@@ -2228,6 +2229,38 @@ vm_fault_t finish_fault(struct vm_fault *vmf);
 #define folio_ref_zero_or_close_to_overflow(folio) \
 	((unsigned int) folio_ref_count(folio) + 127u <= 127u)
 
+/* Leave separate reserves for administrators and concurrent reference gains. */
+#define FOLIO_REF_COUNT_LIMIT		(INT_MAX - (1U << 26))
+#define FOLIO_REF_COUNT_ADMIN_LIMIT	(INT_MAX - (1U << 25))
+
+/**
+ * folio_ref_count_over_limit - Check whether to refuse more folio references.
+ * @folio: The folio.
+ *
+ * Relevant for large pagecache folios (!hugetlb). For these, we have to check
+ * before adding page table mappings or other significant refcount users whether
+ * we are close to our folio ref count limit, to avoid overflows.
+ *
+ * Checking this for other folios does no harm but is mostly unnecessary.
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
+	if (ref_count >= FOLIO_REF_COUNT_ADMIN_LIMIT)
+		return true;
+	/* Background threads must not consume admin reserves. */
+	return (current->flags & PF_KTHREAD) || !capable(CAP_SYS_RESOURCE);
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
index d0e19d9e6b651..2596ff0f0e185 100644
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
@@ -5215,6 +5225,16 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct folio *folio
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
index becf53a2a0944..4800a0da14a32 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1168,6 +1168,8 @@ static __always_inline void __copy_present_ptes(struct vm_area_struct *dst_vma,
  * consecutive pages of the same folio by copying them as well.
  *
  * Returns -EAGAIN if one preallocated page is required to copy the next PTE.
+ * Returns -ENOMEM if the file folio refcount is too high.
+ * Returns -EHWPOISON if copying a page fails.
  * Otherwise, returns the number of copied PTEs (at least 1).
  */
 static inline int
@@ -1186,6 +1188,9 @@ copy_present_ptes(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma
 
 	folio = page_folio(page);
 
+	if (!folio_test_anon(folio) && unlikely(folio_ref_count_over_limit(folio)))
+		return -ENOMEM;
+
 	/*
 	 * If we likely have to copy, just don't bother with batching. Make
 	 * sure that the common "small folio" case is as fast as possible
@@ -1367,9 +1372,9 @@ copy_pte_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
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
@@ -1399,7 +1404,7 @@ copy_pte_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
 			goto out;
 		}
 		entry.val = 0;
-	} else if (ret == -EBUSY || unlikely(ret == -EHWPOISON)) {
+	} else if (ret == -EBUSY || ret == -ENOMEM || unlikely(ret == -EHWPOISON)) {
 		goto out;
 	} else if (ret ==  -EAGAIN) {
 		prealloc = folio_prealloc(src_mm, src_vma, addr, false);
@@ -2469,6 +2474,8 @@ static int insert_page_into_pte_locked(struct vm_area_struct *vma, pte_t *pte,
 	if (unlikely(is_zero_folio(folio))) {
 		pteval = pte_mkspecial(pteval);
 	} else {
+		if (unlikely(folio_ref_count_over_limit(folio)))
+			return -EOVERFLOW;
 		folio_get(folio);
 		pteval = mk_pte(page, prot);
 		if (mkwrite) {
@@ -5717,6 +5724,9 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	if (unlikely(folio_test_has_hwpoisoned(folio)))
 		return ret;
 
+	if (unlikely(folio_ref_count_over_limit(folio)))
+		return VM_FAULT_SIGBUS;
+
 	/*
 	 * Archs like ppc64 need additional space to store information
 	 * related to pte entry. Use the preallocated table for that.
@@ -5771,6 +5781,9 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
  * @page: The first page to create a PTE for.
  * @nr: The number of PTEs to create.
  * @addr: The first address to create a PTE for.
+ *
+ * For file mappings, the caller must check folio_ref_count_over_limit()
+ * before adding the mapping references and installing PTEs.
  */
 void set_pte_range(struct vm_fault *vmf, struct folio *folio,
 		struct page *page, unsigned int nr, unsigned long addr)
@@ -5937,6 +5950,10 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
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
index 6a96e3136fb2a..ca7471aa7a76a 100644
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

-- 
2.43.0


