Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91A04606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 20:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PXDJAgPT
Received: by kanga.kvack.org (Postfix)
	id 8DB8F6B05CC; Wed, 28 Oct 2026 16:16:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88A086B05CD; Wed, 28 Oct 2026 16:16:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72CF36B05CE; Wed, 28 Oct 2026 16:16:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 370DC6B05CC
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:16:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9E2E5A0275
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:16:14 +0000 (UTC)
X-FDA: 85373141868.29.F051730
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id B1A6DC0005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:16:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PXDJAgPT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793218572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YYFSf//7LtffTEdaInzbKHoueC9GaQed5S2F6XZ2m8Q=;
	b=5mP6Qgunt9wjWv8QYA54a/5kowx9gUAOPsn3ofaT3NipnyR+kNwk68buwYoTJrjvJ8T1B6
	4hgicAlKFBhFFCJ+6hb3pfTnOMFO5VWvBGDerU9W6Gqi/lX78V1QCwxw/OcZtAwR/dFM2C
	ht2W0tAlsgL/SUePRtMCAZObkZiu5Ds=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PXDJAgPT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793218572;
	b=mWzWawskr1KeUrmVM4AY+MhRR4WBHp4FDh9fBp20k+n6CSTpr3ggkJydp4bpOh+iSCAHZy
	uoNzCJUvwWba9W9kMl1BS18lv6IJjxNjqGNtcZwN84zXuMo3qBfpXaBb3VRiXE7ikapfwV
	ySncmkg76T4VlVnH4PsoqJWn/DbJZ1M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 06DA243047;
	Wed, 28 Oct 2026 20:16:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993821F031E3;
	Wed, 28 Oct 2026 20:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793218571;
	bh=YYFSf//7LtffTEdaInzbKHoueC9GaQed5S2F6XZ2m8Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PXDJAgPThItJ1aq5M+pH6y01S76Edy6t/jgE9JP0iQsIF9nXJwPANyzgeHXcnCzWF
	 9WbU2KYGlA/tTolQyfpz20oxrC5B2r//RUN+yNwmW9Wrqafi4X8fIDUDQ1synTJy3/
	 IetUwhBWDYLfW7m65Xnxg3Ye1uWdNnj+3VPqcyWCGVb3pabDO9YhheA+EQpxBPtydQ
	 hpknUPoxwEvCPWikqi8AYruhvwd50gD9PjWLudMPCCN/HDdSlH41lFNNBngZUQtOBJ
	 yAF7CwsvjPbdRP34AY9K/fOGK+s/gKBeDChuUf6HSH/Gu5rOV95F8wd/fcjkp3e23U
	 s9nN+44+zXtHg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 28 Oct 2026 21:13:42 +0100
Subject: [PATCH 14/15] RFC: mm/hugetlb: account restored reservations
 before freeing folios
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261028-fixes_hugetlb-v1-14-a0a033db180f@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9868; i=david@kernel.org;
 h=from:subject:message-id; bh=d5+zn1Hn3o3pWcjYFV3JXLw3TGIm0oEZelvRVfl19MA=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIehZcpaTl+82X3LJQ/n8zA23Qs4OK75d4RK3M4H2Q7v
 ntwIMino5SFQYyDQVZMkSUo+L7By5fraqvd+Jhh5rAygQxh4OIUgIl0BTD8U5Bcw/npDYNsFktN
 aNSUU7uPFB5ccnL9pbUF72Y9v+G4UY2RYYfriTulSxP83qYvtar3ebdPs9+rl7fTV32qsuyXfTU
 8fAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: B1A6DC0005
X-Stat-Signature: e4d53zcdrcrcp9a8k87fqiaz4z84im8y
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793218572-613540
X-HE-Meta: U2FsdGVkX18oTpxQyjzKkpGMU5VEO47X2SnTgjtI++vMOIpBexmR1+i74MYOJtahJH9czvCslss9Ixbi6Sagt9XM2G1D8Civ+SRi4cqaKFDjMIhNp3sn0xQqfeS4biX9tq1j2DcCyuJs5+LuB6nPAR/HGJ+p6PuQj4PioHvd0MkbduEkPBKFxvCNajQa67tMo4HCsjKbMqQyu0PaticihdxfxDFlbjNuhRNhRxIk8M3vf0U61wObGkBRAlXQvpkaWUaOjBdhx/Nw3psdbCAfulGUKGJcxxUw3xK7EOihcHcfNpoM49nbGA/SgAuyqf1Ok+BilOP4s1yOvM4Xtx+QUMCElOi8brHH64QMaAZpr5GK0mBdIccfNrV+rbqBI+i1kOZidOlBKQITDjchy0iOgt1+bAEwFOiVuWVZZ9Mnf4gl6NZoupbyorM1AFnE9GILQGbkYZ9DH2Ke2k2WuGWi6QPPmaMGAjF1JW+WRpkQplzxcOmPmvuaD601jaA7jCGZwaz2HXBDY5MvnL7kNSzTnpNlca6KSr+d3jgJV1QlHOEcqjL/rOWZzAjswTgy4poKmBA4wsa0EL8hH3zu3NqT5BtoDQDDohh8lhko1xorB6sot8OqbBCxlUR6D/lX4Y/EpFcJjUReHU3P52FxIF37dipQQNor+ub7HlmNVSD1hkvDKDSbyZn0lE1taVMMDjrcLhF1pr4xiyVkQQvDbfhwSpwzDl+1kcxp7CA3cwK7XoEy6N1B5FPguzDtM13TGi6MH76Xf7I/GeVIP0QfcOTGNyZpYmDFXbnOO7NhM0ycHAzBKUfFI3tvfiRfSm3JTNyWMM6gNaEkVLsL57sGaTGNiGM5OjXAHVHWk6mSwN3m2Vu1vg8R3HVlBu1B8Xe8DAhZa4KyW00rFcx34D26LJCemXiDKQCfUvM0lu/LkGcLmIiV1nwuEEFuImlpQZf+7dFga6nUFnuCOhchulZEO65
 BXeu7xsW
 gbzV3iVFxOyP32lsgK/Krsq9bruCtu1+bovTfWq8B9gJ6eV4tgCEsVwWkVWiFmvFtdQPqppB/Zqqy1R/4Q4+QcIfSuocQqDvcwiGok7mQ6thOtcFkapf38BKm6av9OGgAMSOZoea7GCPSg4zvjypMhSQnbZ2++QGq87u4tIhHJ1cMBzzi6PA3uI6UQuv1XkR777Gr2fWgH4WrIAxp4Rw2AwSXWCbPbOqlCuMJx27tdKJHSzzTRM4XqwCaL3pS5xvmLx2yZrQIehVXtgdDO3cM9w+T6EcUb/+K/He2Ogo4F+WaiMG/vI1krFtOaW0jp1Ax34GVyfB3UM6a69foF9mHWVby3ukbse4WmM8FmhxJdQpEyFIahAOh63X45iHiI/8UaE2E
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
pages to zero in that case, including for demotion, and limit surplus
releases to available pages so they cannot remove backing for remaining
reservations.

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
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 Documentation/mm/hugetlbfs_reserv.rst |  5 +-
 mm/hugetlb.c                          | 90 ++++++++++++++++-------------------
 mm/hugetlb_internal.h                 | 11 +++++
 mm/hugetlb_sysfs.c                    |  2 +-
 4 files changed, 57 insertions(+), 51 deletions(-)

diff --git a/Documentation/mm/hugetlbfs_reserv.rst b/Documentation/mm/hugetlbfs_reserv.rst
index fbca6625ca50..4711029bd067 100644
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
index 69a5d2c73ee1..06ef8ba41df7 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1347,11 +1347,6 @@ static struct folio *dequeue_hugetlb_folio_nodemask(struct hstate *h, gfp_t gfp_
 	return NULL;
 }
 
-static unsigned long available_huge_pages(struct hstate *h)
-{
-	return h->free_huge_pages - h->resv_huge_pages;
-}
-
 static unsigned long persistent_huge_pages(struct hstate *h)
 {
 	return h->nr_huge_pages - h->surplus_huge_pages - h->temporary_huge_pages;
@@ -2449,7 +2444,8 @@ static void return_unused_surplus_pages(struct hstate *h,
 	 * Part (or even all) of the reservation could have been backed
 	 * by pre-allocated pages. Only free surplus pages.
 	 */
-	nr_pages = min(unused_resv_pages, h->surplus_huge_pages);
+	nr_pages = min3(unused_resv_pages, h->surplus_huge_pages,
+			available_huge_pages(h));
 
 	/*
 	 * We want to release as many surplus pages as possible, spread
@@ -5313,6 +5309,45 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
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
 void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			    unsigned long start, unsigned long end,
 			    struct folio *folio, zap_flags_t zap_flags)
@@ -5325,7 +5360,6 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	spinlock_t *ptl;
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
-	bool adjust_reservation;
 	unsigned long last_addr_mask;
 
 	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
@@ -5418,47 +5452,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
index 1d2f870deccf..d307d472137c 100644
--- a/mm/hugetlb_internal.h
+++ b/mm/hugetlb_internal.h
@@ -10,6 +10,17 @@
 #include <linux/hugetlb.h>
 #include <linux/hugetlb_cgroup.h>
 
+static inline unsigned long available_huge_pages(struct hstate *h)
+{
+	/*
+	 * Restored reservations may outnumber free folios until the folios
+	 * return to the pool.
+	 */
+	if (h->resv_huge_pages > h->free_huge_pages)
+		return 0;
+	return h->free_huge_pages - h->resv_huge_pages;
+}
+
 /*
  * Check if the hstate represents gigantic pages but gigantic page
  * runtime support is not available. This is a common condition used to
diff --git a/mm/hugetlb_sysfs.c b/mm/hugetlb_sysfs.c
index c89e4c847575..9e0c5d3d0fcb 100644
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
2.43.0


