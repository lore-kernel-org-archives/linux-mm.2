Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90056606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 18:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OVbtaiM+
Received: by kanga.kvack.org (Postfix)
	id 7CBBC6B05CA; Mon, 16 Nov 2026 13:32:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77B516B05CB; Mon, 16 Nov 2026 13:32:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 643DC6B05CC; Mon, 16 Nov 2026 13:32:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3CA136B05CA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:32:03 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C5528160271
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:32:02 +0000 (UTC)
X-FDA: 85441826484.29.B5A3EC8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 034FE140007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:32:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OVbtaiM+;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794853921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O6QjiH3+QMBK2x92QY7yh3Ml2BNK9gueerRMItUKEok=;
	b=hQHV30jtGQV1LWBquM/kdDrlBjIjxhG5iw9Wg6Bv5aHsSLh10mzVpYdEO3QnQTm3+qx4Va
	W2ArAuWUdrcer3q8mnH1YUZ4Qgo/HhOgzgLew9nU/dDAF/WFXJcBV/PtjLzSl//ihBWAht
	aBd98vXMXZX1yfpNhB57+mysInvMRIA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OVbtaiM+;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794853921;
	b=x4VBKqQ6AejW6/Spk/Nypz+pdeZe5R+MEwLSxAW7fOatGTeMlvxYauiaqHGJCmRjSuaYpP
	CtfcU101RGPvTV81fkyW+z+ov1rqLMqO2pl5BbUrU2czbWLH4SsA2eT5f299ioYbK1ebpR
	bwXNfXj6txDplB4dLhBqg37ztWwd8X0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 89B52630BD;
	Mon, 16 Nov 2026 18:32:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D101F000C4;
	Mon, 16 Nov 2026 18:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794853920;
	bh=O6QjiH3+QMBK2x92QY7yh3Ml2BNK9gueerRMItUKEok=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OVbtaiM+675yc6YAPU8/nIUErPqTSj/wb7KJxQIkG9y7Tk+ijsfEnCGYhSPPlMmYM
	 syoDz/W8jdeLmti1zElZmETFwzo+sg8mVhWuImTOezoBNR6MeTVle/kaa0ajLfGnPT
	 qPP8nCUYW1c5NJ9qgh+jeu5+4LDnvcAkXTHnDSD/Y5dF9KjBPHYpoLzure0n8hpNOd
	 hVIw03/uHJ0x40m4Vgoj6PMVp3D8towLBa+0S7Gl1krAdueLdhBoFFx3hPOVf9p2Lg
	 PVRUyS7iloBBHsYf+kMlsRRBVKR8TVTZ47VHStJ89ITKpKmxK5NTwn2iS85xaeQ99D
	 MKpKGQ/9pHnCQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 16 Nov 2026 19:29:35 +0100
Subject: [PATCH v2 14/15] mm/hugetlb: account restored reservations before
 freeing folios
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-fixes_hugetlb-v2-14-4dd9e94ea9ac@kernel.org>
References: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
In-Reply-To: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=13231; i=david@kernel.org;
 h=from:subject:message-id; bh=B1/eePvmlgf2Rj0QM04QxvVcTwdxwok858jRKcj4aqk=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLJ+e3e6aVx1erje0IGh2WpW+vxFe2do39rYoXyKR3jbv
 pPa3jfKO0pZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZhIAhMjwztN6464kHgXi62s
 olO1txqv4EpcdfP69esGrQKKaxV3vWf4w/Urj3nLHM8lWoF/s12ff9oc+PHqnlbRyMysaBupjmV
 hzAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 034FE140007
X-Rspam-User: 
X-Stat-Signature: e57r7a3y5qm73ef1fbaqcmj7uek5dkbc
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794853920-334214
X-HE-Meta: U2FsdGVkX18ztyVp8MOZp3+aeV2gJUsNIxU7PS8mX22t8nfGv5ZzXy3Vwpv2fglKJErmIGOhR80zawCcIEfmvrVQIBTgkAX6Cl6y0kEV2I42m3lGcDIF64dwO1LgYWfIMz0v3CuMK7VpEg4CYq+OGCE7THXREup2eNJuqW03I4g+ZzAAeiNZ1dZ6sRVrN+AcdYi2jftncGdvVAKRU/PehftWibFTaXk0GHbkMBx0rMdt6sDNDq3YJGFs+5oAWaBCPO6RfVQyn0RsFo/5IlW7wSYoDbGNkIAbcLc2gwd4vYOXqQ2+AzObIzS9krQrhW2dAYKAhTcZlbzdA6LlHjqzV29y7/2qq5PtckpHUDkmUOu0jWIFe2wQZZRPVbRKPhy23lWgfP+XGoXzFhqpsSjq10TukF/0tsW4wNIFQE946VZ0lnfQ17JA46RjVp1FDRtP7nOx9rx/lNohw7sX1lCC4xAQg3HO2FM+RprjCV0Q7DMNTRhhJXHxvH+ZG+sbUPVmoU/CyZ64p1wpiSyw07Eo86jLVnTrvcIjGj0+C3uoObiIcxn5ARE8r/Xwfq9giEZWYmaV5cAchr1ebX425JooatGWEvvjBKe/VlBTi0tLp+DdpOLHSOyXuj1Di1SclbAqus0jpb6UgeYdPoTeTD866OWaW4YC5otwToQhyCkErGEvFb8TjhvI3QgHr2zraOXe4zM+UUM8dDsKvv3V8Hn9ntSSE5DIxZ0vytGRJbq93vrOqBohxpgaZz2OFU2f+V8Tmzc+hvoJegZOw4XPv3MrAKHNPXX45c+cJm7plHiCPV7YF0DEBg57k0zFR6bj3vGekZ55lga+wG87AdAx3wDw1getlrw9ahTjKxyzMtjTbmoBN0eJ3g1BYM/xv/rere56ekLmYA5lh/FYnOKEJA8isbAErZKBgMfrVCdEk9YcdbIEPVJ3jXXYLp31UzGFh4SbmIaBHTyyPQpd2+E7Nb8
 fqrAvmOj
 M//Ne7Remi2cncleKVLG0j/zVbK5DzPaLdC1u2UgtvjASmRwp5XGNya2IkYSWJIqR89Goi3ZAZtkA1M8SPHnUomEGSRkIImEGLC3ZAlpesbhx94KouDTNgIRHDlmzWXbN42XpBqICYbb60U25BF3x1HKoKojU61hiz2TQbjAdq4gQ5CbT011xkjhfFyg8r9OGdbTGM4dDD2fyT4KxyeZ//mL0afd7unsQlk1DYOKDf0/zWg+p3IDGUVU5VIrBeQL54Nq6D8sYatyomzKzylGyrlGvUjXhYmNIVcPjdFKpqkBWunQC1JKPiDqXSvovdwmreEqFAimrSYnt4O29UAmGwRJsoaTZoE0dCDCRzTsiYvfh6ev4pHeJAr9w+XXWWPTytGFK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Unmapping an anonymous folio restores its private VMA reservation
immediately, but the global reservation count is only restored when the
folio is freed.

If any folio reference delays freeing, closing the VMA or refaulting can
decrement resv_huge_pages before it was incremented. This can underflow
the counter or hide another mapping's reservation, allowing an unreserved
allocation to consume its backing.

Increment resv_huge_pages when restoring the reserve map instead. Detach
the folio from its subpool, since the restored reservation now owns that
charge. Leave the restore-reserve flag clear so freeing the folio does not
repeat the accounting. The folio only becomes free after its last reference
is dropped.

Reservations can now temporarily outnumber free folios. Clamp available
pages to zero in that case, including for demotion, and limit releases of
pooled surplus pages to that availability so they cannot remove backing
for remaining reservations.

Use the same clamped availability when gathering surplus pages for a new
reservation. An existing deficit can be backed by unmapped folios that
are still referenced, so do not allocate replacement backing for it as
part of the new request. Otherwise, the request can allocate unnecessary
surplus pages or fail even when the overcommit limit has room for the new
reservation.

Free unused or aborted surplus allocations directly instead of passing
them to free_huge_folio(), which could retain them to cover the existing
deficit. These isolated folios have not backed any committed reservation.
Preserve pages promoted to persistent capacity by a concurrent pool resize,
and use the bulk freeing path to retain vmemmap restoration error handling.

Restore reservations even when surplus pages exist. free_huge_folio()
already retains pages needed to back them. It is unclear why that was
really added. The comment about i_mmap_lock_write can go as well, that
doesn't really help for anonymous folios.

Two existing problems remain:

1) Anonymous hugetlb migration temporarily drops the mapcount. A concurrent
   unmap can observe zero and restore a reservation even though migration
   will reinstall a mapping. i_mmap_lock_write() does not protect anonymous
   folio mapcounts, so it does not prevent this race. This change fixes the
   resulting counter underflow, but leaves premature restoration possible,
   leading to (2). Maybe that anon_vma lock can help?

2) A fault can allocate a replacement folio using the restored
   reservation before the old folio is freed. Repeated vmsplice(),
   MADV_DONTNEED and refaults can retain multiple folios for one
   reservation and consume pages backing other reservations. This was
   already possible; counter accounting is now fixed, but early reuse
   remains. Removing the surplus check also allows it after unmaps that
   previously skipped restoration.

Deferring reservation-map restoration until the final put is tricky:
free_huge_folio() has no VMA context to update the private reserve map, and
that VMA may already have been destroyed.

Fixes: df7a6d1f6405 ("mm/hugetlb: restore the reservation if needed")
Cc: stable@kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 Documentation/mm/hugetlbfs_reserv.rst |   5 +-
 mm/hugetlb.c                          | 125 ++++++++++++++++++----------------
 mm/hugetlb_internal.h                 |  24 +++++++
 mm/hugetlb_sysfs.c                    |   2 +-
 4 files changed, 95 insertions(+), 61 deletions(-)

diff --git a/Documentation/mm/hugetlbfs_reserv.rst b/Documentation/mm/hugetlbfs_reserv.rst
index fbca6625ca50d..4711029bd067d 100644
--- a/Documentation/mm/hugetlbfs_reserv.rst
+++ b/Documentation/mm/hugetlbfs_reserv.rst
@@ -34,7 +34,8 @@ resv_huge_pages
 	This is a global (per-hstate) count of reserved huge pages.  Reserved
 	huge pages are only available to the task which reserved them.
 	Therefore, the number of huge pages generally available is computed
-	as (``free_huge_pages - resv_huge_pages``).
+	as (``free_huge_pages - resv_huge_pages``), clamped to zero when
+	reservations outnumber free huge pages.
 Reserve Map
 	A reserve map is described by the structure::
 
@@ -155,7 +156,7 @@ are enough free huge pages to accommodate the reservation.  If there are,
 the global reservation count resv_huge_pages is adjusted something like the
 following::
 
-	if (resv_needed <= (free_huge_pages - resv_huge_pages)
+	if (resv_needed <= available_huge_pages(h))
 		resv_huge_pages += resv_needed;
 
 Note that the global lock hugetlb_lock is held when checking and adjusting
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6e79dedfc0fd6..94de63529cbc5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1351,11 +1351,6 @@ static struct folio *dequeue_hugetlb_folio_nodemask(struct hstate *h, gfp_t gfp_
 	return NULL;
 }
 
-static unsigned long available_huge_pages(struct hstate *h)
-{
-	return h->free_huge_pages - h->resv_huge_pages;
-}
-
 static unsigned long persistent_huge_pages(const struct hstate *h)
 {
 	return h->nr_huge_pages - h->surplus_huge_pages - h->temporary_huge_pages;
@@ -2321,11 +2316,13 @@ static nodemask_t *policy_mbind_nodemask(gfp_t gfp)
  */
 static long surplus_pages_needed(struct hstate *h, long delta, long allocated)
 {
-	long global_free = (long)h->free_huge_pages + allocated;
-	long allowed_free = (long)allowed_mems_nr(h) + allocated;
+	const long available = min(available_huge_pages(h), allowed_mems_nr(h));
 
-	return max((long)h->resv_huge_pages + delta - global_free,
-		   delta - allowed_free);
+	/*
+	 * Restored reservations can still be backed by folios that were not
+	 * freed yet.
+	 */
+	return delta - available - allocated;
 }
 
 /*
@@ -2336,6 +2333,7 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 	__must_hold(&hugetlb_lock)
 {
 	LIST_HEAD(surplus_list);
+	LIST_HEAD(free_list);
 	struct folio *folio, *tmp;
 	int ret;
 	long i;
@@ -2415,14 +2413,26 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 		enqueue_hugetlb_folio(h, folio);
 	}
 free:
-	spin_unlock_irq(&hugetlb_lock);
-
 	/*
-	 * Free unnecessary surplus pages to the buddy allocator.
-	 * Pages have no ref count, call free_huge_folio directly.
+	 * These folios are not required for any reservation. Don't use
+	 * free_huge_folio(), otherwise it might decide to keep them for
+	 * reservations that were restored before the original folios were
+	 * freed.
 	 */
-	list_for_each_entry_safe(folio, tmp, &surplus_list, lru)
-		free_huge_folio(folio);
+	list_for_each_entry_safe(folio, tmp, &surplus_list, lru) {
+		/*
+		 * If the pool was resized concurrently, these folios might now
+		 * count as persistent and we must keep them.
+		 */
+		if (!h->surplus_huge_pages_node[folio_nid(folio)]) {
+			enqueue_hugetlb_folio(h, folio);
+			continue;
+		}
+		remove_hugetlb_folio(h, folio, true);
+		list_add(&folio->lru, &free_list);
+	}
+	spin_unlock_irq(&hugetlb_lock);
+	update_and_free_pages_bulk(h, &free_list);
 	spin_lock_irq(&hugetlb_lock);
 
 	return ret;
@@ -2453,7 +2463,8 @@ static void return_unused_surplus_pages(struct hstate *h,
 	 * Part (or even all) of the reservation could have been backed
 	 * by pre-allocated pages. Only free surplus pages.
 	 */
-	nr_pages = min(unused_resv_pages, h->surplus_huge_pages);
+	nr_pages = min3(unused_resv_pages, h->surplus_huge_pages,
+			available_huge_pages(h));
 
 	/*
 	 * We want to release as many surplus pages as possible, spread
@@ -5328,6 +5339,45 @@ unsigned long move_hugetlb_page_tables(struct vm_area_struct *vma,
 	return len + old_addr - old_end;
 }
 
+/* Must be called after rmap removal. */
+static void hugetlb_folio_restore_rsv_on_unmap(struct vm_area_struct *vma,
+		struct folio *folio)
+{
+	struct hstate *h = hstate_vma(vma);
+	unsigned long address;
+	long rc;
+
+	/*
+	 * Restore only on the last unmap, otherwise the owner could reuse
+	 * the reservation while the folio is still mapped by a child.
+	 *
+	 * TODO: Handle migration temporarily dropping the mapcount to zero.
+	 * TODO: Prevent reservation reuse before the folio is freed.
+	 */
+	if (!folio_test_anon(folio) || !__vma_private_lock(vma) ||
+	    folio_mapped(folio))
+		return;
+
+	address = vma_anon_address(vma, folio->index, 1);
+	rc = vma_needs_reservation(h, vma, address);
+	if (!rc)
+		vma_end_reservation(h, vma, address);
+	if (rc <= 0)
+		return;
+
+	rc = vma_add_reservation(h, vma, address);
+	if (rc < 0)
+		return;
+
+	/* The restored reservation owns the subpool charge. */
+	hugetlb_set_folio_subpool(folio, NULL);
+
+	/* Account before the VMA can close or fault again. */
+	spin_lock_irq(&hugetlb_lock);
+	h->resv_huge_pages++;
+	spin_unlock_irq(&hugetlb_lock);
+}
+
 static void hugetlb_unmap_range(struct mmu_gather *tlb,
 				struct vm_area_struct *vma, unsigned long start,
 				unsigned long end, struct folio *folio,
@@ -5341,7 +5391,6 @@ static void hugetlb_unmap_range(struct mmu_gather *tlb,
 	spinlock_t *ptl;
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
-	bool adjust_reservation;
 	unsigned long last_addr_mask;
 
 	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
@@ -5427,47 +5476,7 @@ static void hugetlb_unmap_range(struct mmu_gather *tlb,
 		hugetlb_remove_rmap(folio);
 		spin_unlock(ptl);
 
-		/*
-		 * Restore the reservation for anonymous page, otherwise the
-		 * backing page could be stolen by someone. Restore only on the
-		 * last unmap, otherwise the owner could empty its resv map
-		 * while the folio is still mapped by a child. Note that holding
-		 * i_mmap_lock_write is needed to check the number of mappings.
-		 * If there we are freeing a surplus, do not set the restore
-		 * reservation bit.
-		 */
-		adjust_reservation = false;
-
-		spin_lock_irq(&hugetlb_lock);
-		if (!h->surplus_huge_pages && __vma_private_lock(vma) &&
-		    !folio_mapped(folio) && folio_test_anon(folio)) {
-			folio_set_hugetlb_restore_reserve(folio);
-			/* Reservation to be adjusted after the spin lock */
-			adjust_reservation = true;
-		}
-		spin_unlock_irq(&hugetlb_lock);
-
-		/*
-		 * Adjust the reservation for the region that will have the
-		 * reserve restored. Keep in mind that vma_needs_reservation() changes
-		 * resv->adds_in_progress if it succeeds. If this is not done,
-		 * do_exit() will not see it, and will keep the reservation
-		 * forever.
-		 */
-		if (adjust_reservation) {
-			int rc = vma_needs_reservation(h, vma, address);
-
-			if (rc < 0)
-				/* Presumably allocate_file_region_entries failed
-				 * to allocate a file_region struct. Clear
-				 * hugetlb_restore_reserve so that global reserve
-				 * count will not be incremented by free_huge_folio.
-				 * Act as if we consumed the reservation.
-				 */
-				folio_clear_hugetlb_restore_reserve(folio);
-			else if (rc)
-				vma_add_reservation(h, vma, address);
-		}
+		hugetlb_folio_restore_rsv_on_unmap(vma, folio);
 
 		tlb_remove_page_size(tlb, folio_page(folio, 0),
 				     folio_size(folio));
diff --git a/mm/hugetlb_internal.h b/mm/hugetlb_internal.h
index 1d2f870deccfe..201028e08a46a 100644
--- a/mm/hugetlb_internal.h
+++ b/mm/hugetlb_internal.h
@@ -10,6 +10,30 @@
 #include <linux/hugetlb.h>
 #include <linux/hugetlb_cgroup.h>
 
+/**
+ * available_huge_pages - number of free huge pages not needed for reservations
+ * @h: huge page size state
+ *
+ * Global number of free huge pages that are not needed for existing
+ * reservations, available for allocations without reservations. Things like
+ * NUMA placement, cpusets, mempolicy and the usability of individual folios can
+ * further restrict allocation.
+ *
+ * Reservations of anon folios may be restored before their backing folios are
+ * actually freed, so the number of reserved pages can be bigger than the
+ * number of free pages. In such a scenario, the result is clamped to 0.
+ *
+ * Return: The number of free huge pages not needed for reservations.
+ */
+static inline unsigned long available_huge_pages(const struct hstate *h)
+{
+	lockdep_assert_held(&hugetlb_lock);
+
+	if (h->resv_huge_pages > h->free_huge_pages)
+		return 0;
+	return h->free_huge_pages - h->resv_huge_pages;
+}
+
 /*
  * Check if the hstate represents gigantic pages but gigantic page
  * runtime support is not available. This is a common condition used to
diff --git a/mm/hugetlb_sysfs.c b/mm/hugetlb_sysfs.c
index c89e4c8475756..9e0c5d3d0fcb6 100644
--- a/mm/hugetlb_sysfs.c
+++ b/mm/hugetlb_sysfs.c
@@ -211,7 +211,7 @@ static ssize_t demote_store(struct kobject *kobj,
 		 * Check for available pages to demote each time thorough the
 		 * loop as demote_pool_huge_page will drop hugetlb_lock.
 		 */
-		nr_available = h->free_huge_pages - h->resv_huge_pages;
+		nr_available = available_huge_pages(h);
 		if (nid != NUMA_NO_NODE)
 			nr_available = min(nr_available,
 					   h->free_huge_pages_node[nid]);

-- 
2.56.1


