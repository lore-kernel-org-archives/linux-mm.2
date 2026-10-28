Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F0A7606A322
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 20:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Td2Z7PJG
Received: by kanga.kvack.org (Postfix)
	id 52EB86B05C2; Wed, 28 Oct 2026 16:15:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DF1F6B05C3; Wed, 28 Oct 2026 16:15:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CECC6B05C4; Wed, 28 Oct 2026 16:15:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 02BEE6B05C2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:15:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0158D1A02B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:15:15 +0000 (UTC)
X-FDA: 85373139432.17.FD4FFD0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id F178AC0002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:15:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Td2Z7PJG;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793218514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fJbEER7vzoOAwM+mPhIWBPKSIqjL5RqV9BeY0Wx0m0k=;
	b=5CL3MUKw4ri9YzVJ1izyqgYSVcezuV6ppCtcQ7xh7x4D0g2JZsdiA2jnPcQGKqUacggjb5
	xfEkiJuSOelI/aBEUZH9yE/YeyJ2ZvOtv5qB9MRMcM8z2S7SgS4lIoERA4wMRy579ek5+t
	NP23YeTZvoGn3p4ncIL1aRnCnAfviOs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793218514;
	b=eGv/Ar3E0KiUwE4fwGQ7AYVbpqOaPZfiY0o45qWihhyDQIxJlQ7Eg5pgtGQe46GnH9ytEb
	vrc+cQZWGE8YGQ3DHrIt/S+VzA7yrBYbFWe62Hl/1cfbeXNhYmOKJUDpDCUeGkCrH61WkW
	YjoLl1LKJQzMKfM0LdSC5sjsw6JJszg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Td2Z7PJG;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 84F526020F;
	Wed, 28 Oct 2026 20:15:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFAD31F031E3;
	Wed, 28 Oct 2026 20:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793218513;
	bh=fJbEER7vzoOAwM+mPhIWBPKSIqjL5RqV9BeY0Wx0m0k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Td2Z7PJG1wX0MP4iiflVKGRwmNWuqcmTi3gw8+jfO++FuDSJUd8jjBn08UWi63J2/
	 dCwBF7cTzU+cDAKM1xEwzW27ENbq/S+6TUyModUEkC8t3WaBVhs9dLRDSYavM3TJrL
	 zUy4XIkMUUP3rmQ508pm7R88laRhAxA5YlQYRHrTfy7q3Iqm59XQCmNfFu9lJj3IbU
	 JNq8xmWN3pytmAbAP0jOr15Cf+kHTeNTSA8np8GJm1LlQ5IyK5o6CsnmE3FPSv8ib9
	 QUea7AijNxg6TKXgRg/V2eSNbMniprLfbK/epuh18x4BcTELCkHnzPQMknj3TsQqAY
	 N9CmUQEHWWcDQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 28 Oct 2026 21:13:36 +0100
Subject: [PATCH 08/15] mm/hugetlb: serialize page-cache allocations with
 truncation
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261028-fixes_hugetlb-v1-8-a0a033db180f@kernel.org>
References: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
In-Reply-To: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
 Andy Whitcroft <apw@canonical.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Dave Airlie <airlied@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>, 
 Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10950; i=david@kernel.org;
 h=from:subject:message-id; bh=KYQmOO3hIaWySsr+CMtBC6qneUQ6Sjm+iDm4MQVro9M=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIehZdp7N62Lknif5/HCuP7SbfPBy6J/TLn1RQf9u97p
 rCGMJmwdJSyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjARxUJGhtcXrtTlebiFflid
 m+u/lvv7is9PexamPMv3lul2shQ72cvI8OTN5zrB80vmHWDQnlN94HCa3W2Nph9etZuYW6vCp0r
 qcwMA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F178AC0002
X-Stat-Signature: zqm8z9yc1cooxy7jkyrzmm8uxyopwaus
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793218513-350702
X-HE-Meta: U2FsdGVkX1/HCgUIWUYHCvyBjt8xt1BeTF4kvfbQjfyXEBTpKTyE5XNKwB+g7cjnOXQBaUwRVGAdZMij5KQbUmQJ7LmnhsdMku0d5menraMmlrxIig46TSmR7v4n0TmO+1T3h5NDH7hfYJfHQjgErVarF+V0BuTieJEaJPBDZ7zMb2yTWvV5WyLjvIfj7P6OE5ZSyLYUYHyVbYPP3IxSMIbV2S6DALm2VGMEWkzshDFfiUMiG75Ud1OZtywMtlZN1aH04aBLFI7JcFTP40gULPgZGZFdGUd5jN9tf1vzI3+uddA2yRNccpfMFaitmyUezxGYm9td73/oRAMxFhHAIAc8OVfIo1zM45OUPQ/Db9BOs5zXp3+7jJzr2PXE8uqmpWzkLVkp9bU1CNMfJPlpE5guKKz+EBV9QBeRclye7YHiZCxwvqcFHNOH1Hb7QD6vwhzDmX5eWHvjqaHXj6wi07/3PfcevA/0RsVRykEcDKyBX9q0k1nn1jeK6y4fGT+v//dwPbx5A5tZI1jXoKVuvXEV15cE5A/62TaLhzvQepEYRayy+/LfkqEB62kR8q+nPp0mStkLogaKNfZlIJlPC9q8OonuAFBsUIEsmsAjdxSYOSjrcrSxbb1Njt0UAD6TcGmAJUe2WcaElAaH3rb703Uf1/+w3ZR/DLxm572+d+oE+HvNYo6sJrL+mn2ItJWCK6j2KB5YYVebOiic7e3B4vK232UaqSvOFjtqCyzxgfDoC1ZQjS9Cs5kZWpGll2tdoxkzB6MbC9PxcqaKK6trrG0h0CFTezpyfDzUqaiVIkaVyyn7rfFgmlT5r8TpkHeVfCHnUHgMVGLwKznfH5WWXh+en5/kOhst+xfr/XaH5ChMeb3DBozC1dR8j9VP2JS4TKOQ61kzGn527YKA9JF6xoec4Yc6g2szsU8zxZWET0h7k8YBJgFpG9JWswhFgt6c8Vw8ieq4m6neyuqtZ6F
 4V1KuTa/
 6vZL16j0M+6aEnAr5sLw81I+fjavPaZmWLwaG0WEAPTib4eTVuWoS2u7Ilo/YvtFBttZY3fYWe4O82roox1QfZNGDTFKjz29QLxvb+yDbBMNJbOw4mexirvMPiwFKpbFOaWS00vjePYTCEaCDLZTo1Bh5PJXxZNAdhPuDeREUNPdB7ipY3BupohL1IjgTo3gQZQiwPI5jfc9Ze/8OsKJSb5E4527Z3xFaLXAU2joKdgmTP5LIhJjFWrOEDPzBS/+SqT1t2Ix3PkTZj0CQEyE0Mp1Tm60uNUAuuUr1ySi1h1R4Not5zE/foIQINmmmO2gh6l05+8Q/3qjp9a2pPH/EZaQSjCMyD4O8EYi5htYsIBlwPi5bVnXX8IugxLRkmM6v6lXth+bZ5eNdPazhx9wabTNUEjGC2UzRDW1giq9zElTimRI5oug464r3tA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Truncation can remove an inode reservation while a fault is still
allocating its folio. UFFDIO_COPY and memfd pinning can also consume
reservations beyond the new i_size. This can underflow resv_huge_pages
and leave folios beyond EOF.

The main issue is that truncation takes the fault mutex for folios in
the page-cache, but it has no clue about faults that are still being
processed concurrently.

Matthew Wilcox raised mapping->invalidate_lock in a different upstream
hugetlb locking discussion:

  "although I wonder if we still need the fault mutex array, given that we
   now have mapping->invalidate_lock?"

While it likely cannot remove the mutex array entirely (concurrent page
faults have to sync ... ), we can at least use it to fix this problem.

Hold mapping->invalidate_lock shared across the size check, allocation
and page cache insertion or reservation rollback. Truncation takes it
exclusively around i_size_write() only for now: it waits for concurrent
allocations to finish updating the page-cache or rolling back reservations
before changing the size. Subsequent allocations see the updated i_size.

Let truncation release the lock for now before unmapping and removing
folios to preserve the existing lock ordering. Cached-folio faults and
private allocations do not acquire the new lock.

Use it to synchronize with truncation, keeping the fault mutexes to
serialize allocations for the same index.

Locking order is now:

  fault mutex -> hugetlb VMA lock (read) -> invalidate lock (read) ->
  folio lock -> PTE lock

And on truncation:

  i_rwsem (write) -> invalidate lock (write)

Add hugetlb_pgoff_valid() to not repeat the same size check multiple
times. Memfd needs a bit of care, as it traditionally allowed partial
folios to be pinned: the size check in memfd_pin_folios() allows for
that.

Fixes: 1c9e8def43a3 ("userfaultfd: hugetlbfs: add UFFDIO_COPY support for shared mappings")
Fixes: 188a39725ad7 ("hugetlbfs: revert use i_mmap_rwsem to address page fault/truncate race")
Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
Cc: stable@kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Link: https://lore.kernel.org/all/ajMfdQf-Fspwmstr@casper.infradead.org/
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 fs/hugetlbfs/inode.c    | 15 +++++++++++----
 include/linux/hugetlb.h | 12 ++++++++++++
 mm/hugetlb.c            | 45 +++++++++++++++++++++++++++++++++------------
 mm/memfd.c              |  8 ++++++++
 4 files changed, 64 insertions(+), 16 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index fa367fc9e019..174455e10d0f 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -545,10 +545,9 @@ static void remove_inode_single_folio(struct hstate *h, struct inode *inode,
  * truncation is indicated by end of range being LLONG_MAX
  *	In this case, we first scan the range and release found pages.
  *	After releasing pages, hugetlb_unreserve_pages cleans up region/reserve
- *	maps and global counts.  Page faults can race with truncation.
- *	During faults, hugetlb_no_page() checks i_size before page allocation,
- *	and again after obtaining page table lock.  It will 'back out'
- *	allocations in the truncated range.
+ *	maps and global counts.  hugetlb_vmtruncate() updates i_size under
+ *	invalidate_lock to synchronize with new page cache allocations from
+ *	page faults, uffd, etc.
  * hole punch is indicated if end is not LLONG_MAX
  *	In the hole punch case we scan the range and release found pages.
  *	Only when releasing a page is the associated region/reserve map
@@ -622,7 +621,15 @@ static void hugetlb_vmtruncate(struct inode *inode, loff_t offset)
 	BUG_ON(offset & ~huge_page_mask(h));
 	pgoff = offset >> PAGE_SHIFT;
 
+	filemap_invalidate_lock(mapping);
 	i_size_write(inode, offset);
+	/*
+	 * The size check now prevents new page-cache allocations in the
+	 * truncated range. Existing folios and reservations are cleaned up
+	 * below.
+	 */
+	filemap_invalidate_unlock(mapping);
+
 	i_mmap_lock_write(mapping);
 	if (mapping_mapped(mapping))
 		hugetlb_vmdelete_list(mapping, pgoff, 0, ZAP_FLAG_DROP_MARKER);
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index d49cb15d13e6..2a3fde411d74 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -823,6 +823,18 @@ static inline unsigned huge_page_shift(struct hstate *h)
 	return h->order + PAGE_SHIFT;
 }
 
+static inline bool hugetlb_pgoff_valid(struct address_space *mapping,
+		pgoff_t idx, bool partial)
+{
+	struct hstate *h = hstate_inode(mapping->host);
+	u64 size = i_size_read(mapping->host);
+
+	if (partial)
+		size = round_up(size, huge_page_size(h));
+
+	return idx < (size >> huge_page_shift(h));
+}
+
 /**
  * hugetlb_linear_page_index() - linear_page_index() but in hugetlb
  *				 page size granularity.
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 2fdd72897db8..7f240cd7dea0 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5869,6 +5869,7 @@ static bool hugetlb_pte_stable(struct hstate *h, struct mm_struct *mm, unsigned
 static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 			struct vm_fault *vmf)
 {
+	const bool pagecache_folio = vmf->vma->vm_flags & VM_MAYSHARE;
 	u32 hash = hugetlb_fault_mutex_hash(mapping, vmf->pgoff);
 	bool new_folio, new_anon_folio = false;
 	struct vm_area_struct *vma = vmf->vma;
@@ -5877,7 +5878,6 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 	vm_fault_t ret = VM_FAULT_SIGBUS;
 	bool folio_locked = true;
 	struct folio *folio;
-	unsigned long size;
 	pte_t new_pte;
 
 	/*
@@ -5899,8 +5899,7 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 	new_folio = false;
 	folio = filemap_lock_hugetlb_folio(h, mapping, vmf->pgoff);
 	if (IS_ERR(folio)) {
-		size = i_size_read(mapping->host) >> huge_page_shift(h);
-		if (vmf->pgoff >= size)
+		if (!hugetlb_pgoff_valid(mapping, vmf->pgoff, /* partial= */ false))
 			goto out;
 		/* Check for page in userfault range */
 		if (userfaultfd_missing(vma)) {
@@ -5930,10 +5929,17 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 							VM_UFFD_MISSING);
 		}
 
-		if (!(vma->vm_flags & VM_MAYSHARE)) {
+		if (!pagecache_folio) {
 			ret = __vmf_anon_prepare(vmf);
 			if (unlikely(ret))
 				goto out;
+		} else {
+			/* Recheck EOF before consuming an inode reservation. */
+			filemap_invalidate_lock_shared(mapping);
+			if (!hugetlb_pgoff_valid(mapping, vmf->pgoff, /* partial= */ false)) {
+				filemap_invalidate_unlock_shared(mapping);
+				goto out;
+			}
 		}
 
 		folio = alloc_hugetlb_folio(vma, vmf->address, false);
@@ -5954,13 +5960,15 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 				ret = vmf_error(PTR_ERR(folio));
 			else
 				ret = 0;
+			if (pagecache_folio)
+				filemap_invalidate_unlock_shared(mapping);
 			goto out;
 		}
 		folio_zero_user(folio, vmf->real_address);
 		__folio_mark_uptodate(folio);
 		new_folio = true;
 
-		if (vma->vm_flags & VM_MAYSHARE) {
+		if (pagecache_folio) {
 			int err = hugetlb_add_to_page_cache(folio, mapping,
 							vmf->pgoff);
 			if (err) {
@@ -5975,8 +5983,10 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 							folio);
 				folio_put(folio);
 				ret = VM_FAULT_SIGBUS;
+				filemap_invalidate_unlock_shared(mapping);
 				goto out;
 			}
+			filemap_invalidate_unlock_shared(mapping);
 		} else {
 			new_anon_folio = true;
 			folio_lock(folio);
@@ -6401,14 +6411,15 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 			     uffd_flags_t flags,
 			     struct folio **foliop)
 {
+	const int vm_shared = dst_vma->vm_flags & VM_SHARED;
+	const bool is_continue = uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE);
+	const bool alloc_pagecache_folio = vm_shared && !is_continue;
 	struct mm_struct *dst_mm = dst_vma->vm_mm;
-	bool is_continue = uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE);
 	bool wp_enabled = (flags & MFILL_ATOMIC_WP);
 	struct hstate *h = hstate_vma(dst_vma);
 	struct address_space *mapping = dst_vma->vm_file->f_mapping;
 	pgoff_t idx = vma_hugecache_offset(h, dst_vma, dst_addr);
 	unsigned long size = huge_page_size(h);
-	int vm_shared = dst_vma->vm_flags & VM_SHARED;
 	pte_t _dst_pte;
 	spinlock_t *ptl;
 	int ret = -ENOMEM;
@@ -6435,6 +6446,18 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 		return 0;
 	}
 
+	if (alloc_pagecache_folio) {
+		filemap_invalidate_lock_shared(mapping);
+		if (!hugetlb_pgoff_valid(mapping, idx, /* partial= */ false)) {
+			if (*foliop) {
+				folio_put(*foliop);
+				*foliop = NULL;
+			}
+			ret = -EFAULT;
+			goto out;
+		}
+	}
+
 	if (is_continue) {
 		ret = -EFAULT;
 		folio = filemap_lock_hugetlb_folio(h, mapping, idx);
@@ -6532,11 +6555,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 		WARN_ON_ONCE(!folio_test_uptodate(folio));
 
 	/* Add shared, newly allocated pages to the page cache. */
-	if (vm_shared && !is_continue) {
-		ret = -EFAULT;
-		if (idx >= (i_size_read(mapping->host) >> huge_page_shift(h)))
-			goto out_release_nounlock;
-
+	if (alloc_pagecache_folio) {
 		/*
 		 * Serialization between remove_inode_hugepages() and
 		 * hugetlb_add_to_page_cache() below happens through the
@@ -6607,6 +6626,8 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 	spin_unlock(ptl);
 	ret = 0;
 out:
+	if (alloc_pagecache_folio)
+		filemap_invalidate_unlock_shared(mapping);
 	return ret;
 out_release_unlock:
 	spin_unlock(ptl);
diff --git a/mm/memfd.c b/mm/memfd.c
index 0f6fff004f5e..4650a69aa7a6 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -96,6 +96,12 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 		hash = hugetlb_fault_mutex_hash(memfd->f_mapping, idx);
 		mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
+		filemap_invalidate_lock_shared(memfd->f_mapping);
+		if (!hugetlb_pgoff_valid(memfd->f_mapping, idx, /* partial= */ true)) {
+			err = -EINVAL;
+			goto out_unlock;
+		}
+
 		nr_resv = hugetlb_reserve_pages(inode, idx, idx + 1, NULL, EMPTY_VMA_FLAGS);
 		if (nr_resv < 0) {
 			err = nr_resv;
@@ -131,6 +137,7 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 
 			hugetlb_set_folio_subpool(folio, subpool_inode(inode));
 			folio_unlock(folio);
+			filemap_invalidate_unlock_shared(memfd->f_mapping);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			return folio;
 		}
@@ -138,6 +145,7 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 		if (nr_resv > 0)
 			hugetlb_unreserve_pages(inode, idx, idx + 1, 0);
 out_unlock:
+		filemap_invalidate_unlock_shared(memfd->f_mapping);
 		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 		return ERR_PTR(err);
 	}

-- 
2.43.0


