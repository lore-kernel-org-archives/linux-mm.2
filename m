Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37BEC606A329
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 18:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VxhYX70n
Received: by kanga.kvack.org (Postfix)
	id 24C406B05C9; Mon, 16 Nov 2026 13:31:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FD0A6B05CA; Mon, 16 Nov 2026 13:31:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ED406B05CB; Mon, 16 Nov 2026 13:31:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC0386B05C9
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:31:53 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6C7201202C8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:31:53 +0000 (UTC)
X-FDA: 85441826106.24.C52A73C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8D631120010
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:31:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VxhYX70n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794853911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=40+f4QuNSW0++o/iC/1vcBICb3HnVuDw0SMbdiMn5P4=;
	b=4haEKWJgEuKno5gg48meZAo01rFfaGLodMMwYBndh6eF0dEW/uQG+F6mThNfa7CLD943el
	OAAzRt/vD6l8vB9FemnqEyu1VAWTzdWXNTNIZqOvZkuIH7ytGex13Ss1X+/pj/XHV3ojiJ
	Pq0i0FRE/+pxllz9V6y1pOncCgyH2s4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VxhYX70n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794853911;
	b=yl3Ehnqk/WD7xJ958u+ZMrecKTe2XEKnxZXs0HyIGRF5rMQsMb7K1DdUv7JIQExoa4ds/t
	herlQ2CG/9ONkQav47aXwgZwMcYNFEzLjTl99LrbD5hhwslh+JSaPuViah2wXKX0wEEii+
	o9Zlne0RpMTKAMUOcXxMYFoGbvaYB34=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CFA6F40397;
	Mon, 16 Nov 2026 18:31:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6601F000CD;
	Mon, 16 Nov 2026 18:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794853910;
	bh=40+f4QuNSW0++o/iC/1vcBICb3HnVuDw0SMbdiMn5P4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VxhYX70n1QrgyHw3scGz2CoJ2HRvaAVURv/MD3hl8jgGp2LSDLRDhTY6yKlFLsm40
	 kWS8HOjXD6DVTxKCRRkup2fu5aFiP/s/1lL+76TfXgaE59mLRi4JGR6pz/+XquVpjO
	 vnlF97Dnt1ZEEInz15ToX9HN9ghP2epqbwNnulWiRC6RTYof3wWXIZSU/1hA18y4wD
	 r0eEMEDwcwtkhk7fsCArQ2GobMuq5yIQGM2oKcJxlEqZLghMpGvMCjUZ5T8IRaWY28
	 8o/riVs7Y7cxXiJ8Qpi4wrk69XBhfFpGXUcRijLabp2lfLGQq7mSIVL8ke2uzNM9pe
	 PQM6nwenLf9rg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 16 Nov 2026 19:29:34 +0100
Subject: [PATCH v2 13/15] mm/hugetlb: fix reservation leak on min_size=
 mounts
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-fixes_hugetlb-v2-13-4dd9e94ea9ac@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Chris Mason <mason@kernel.org>, stable@kernel.org, 
 "Gregory Price (Meta)" <gourry@gourry.net>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9045; i=david@kernel.org;
 h=from:subject:message-id; bh=s2srOwA6u1UL2T7LEsRbLfWZDz6Pv4AD/KYyoxPSgsk=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLJ+e3feXHV8v3rwvJnm9+OS3M4v0epq05Xzbf74UfBaw
 lLhrNiNHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEwks4mRoe1WQQvTi+SDf2NK
 qg92eB3Mlsn8G8hW3tpy/0OuqqKeL8Nf8f/Tvv6fJvT9m0zRZIZzLzbbnNyy8nHEquh/M1YdFtp
 +gR8A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8D631120010
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 13j5ybbs7z3uy96woihb3u5618zbdyst
X-HE-Tag: 1794853911-762413
X-HE-Meta: U2FsdGVkX19Eb7vGAajHHyMaR73lfxghhAAAb5uG6IkqWrYGleg13FFS6+5bMM3HgoPrK4N9o4QzvuBJsqAvYp7E3YhfIm8CvV5+GPB26aMXM49ybcc2tOAli25H8jw1qFTwJngxbJnIljFOy1mp4T+f86ShcSCnETV9M3YDWudj7i9mGJyXw9zn0AyLjMJJt6tTpYN/uZBiTG8VgtPvrLGFDF4iyLr6ZzcK8HxyAFDR7iHq6OKs0aEjJHhkbH4C4dVy1yuF4FOwW42r+Stb1WqzdUAWb+2JDuR3NtXDv28LA7PorXFEHJy4DgZ+16ImF7N479OUtGj7hsJpqP2LTqzYS252gtZBpfdBnsR3j6g8y+kocVudTdB1vlHXK1nkEGFw0+tljLmZm+vGUP0a8M2HejNJSZCY5CNtS+wB8MEZ2LVGOe2hNP8esO20NH6WLDrM1beR85EgvjR+mLLnLCNpgeZotG/IpU38ozh5CJvIjct58667PcUUYZg9t2dW7FHt7H2U1PFN5Ny0R0uNPw5eLjR+Spbf5RRwhj8Pxj57hNSYO1NFnU5uunFjCRXKHDOu6CpSF7kMG31FO3b3jlwfHl5hRSm1OzVebtZLIdF5I3P06BEdJVP/cGMOKGH5n7vuXWPUZg/9YgvAZURK5PqMwxk0nWX1NSTZ1QtFB2km2oL4L/aF6+q/CsjyRubwwAFSrxfz5dqgRMLlj4+whVohKWFKXpYRLKKTW2FtmY4ErObV2fUcmbVP8/bP2WR37g6CHvMljuN5wmB+9/bCzyF6JKK9M4EgIq7UNYyY56qw/XrLrL+/A1ILxbaMNZMrISlkQQmX+V5kjj5m++asDrlhMeFHFxKvp+uHkBMbFRMA16fLHGwJfyFmF3nVyc9xc0EKkksKUmb405Tjbn04HmXhRgk5hf8iPDiq3qalkNcNLXZ69dN6fRqQMsi/4vFAAVEytUPsgSmkNdcyz0w
 PQQydUfi
 6tQOqijWwSn3v218b/D1Dvl8AkuxOa9jU+JwmQga5Pul43b02JRuA9aZd/Xx2kTHqKZjyt8DeoT+fXYnGvzTyETn/VQdl2riAiMmulOchVxQa3wKp3czpC0B+zAVWY4C0nISwwzYBRDlPhSdcixYICgijp14zXSn0dScHzkSQBFs9zuphDR7vWZ4ohFTWxJEeq792giDTob/BI5AawbGkIr1sbhqJ/ItQzpR4O74CEIkgvT8YPmqK9yIX5zDk7qKbq67bGwCDqhW2s/t6wHz/xzCTB69/haS+/IIOoJO1eGveOhGILZrB3cmbgbSqLEAVLaftLyN9BeVi76CjcbCvwU4eAmdmWnkrv/3oLEToXzb9khyg0j7r5FBQMtKKXZ7WBq5QEziDXVjJxYsMZuIEcHAy1fK0hounBIjuJ/wcbJt6/tY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

Failed allocations for CoW mappings can leak reservations on hugetlbfs
mounts with min_size= and no size=. The leaked reservations survive
unmount.

Note that this is only an accounting error and not a memory leak.

HPG_restore_reserve makes free_huge_folio() restore the global
reservation without returning it to the subpool. This assumes the
reserve map holds the reservation. However, a CoW mapping may have no
reserve map, or the map may already account for another folio at the
same index.

Commit 58db7c5fbe7d ("mm/hugetlb: fix avoid_reserve to allow taking
folio from subpool") allowed owner CoW allocations to consume subpool
reservations. Commit 51e1de00acdb ("mm/hugetlb: simplify
vma_has_reserves()") later extended this to CoW mappings without a
reserve map.

For example, with a subpool minimum of one page and a
MAP_PRIVATE|MAP_NORESERVE mapping:

                                      subpool       global
                                      rsv_hpages    resv_huge_pages
  1. Mount                             1             1
  2. Allocate using subpool reserve    0             0
  3. Free on error with flag set       0             1
  4. Allocate without a reservation    0             1
  5. Free and return to subpool        1             2

Call folio_clear_hugetlb_restore_reserve() for CoW mappings when
map_chg != MAP_CHG_REUSE, meaning no reserve-map reservation was consumed.
This lets free_huge_folio() return subpool reservations to the subpool
on error.

Do not set the flag again if region-cache allocation fails during
rollback: that would undo the flag clearing and skip returning the
reservation to the subpool. This also fixes the older case where setting
the flag invents a reservation for an unreserved allocation for a CoW
mapping.

The doc still mentions PagePrivate at various places: future work should
clean that up.

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: 846be08578ed ("mm/hugetlb: expand restore_reserve_on_error functionality")
Fixes: 58db7c5fbe7d ("mm/hugetlb: fix avoid_reserve to allow taking folio from subpool")
Cc: stable@kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
[ david: simplify comments and improve description; updated Fixes ]
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 Documentation/mm/hugetlbfs_reserv.rst | 25 ++++++++++++++-----------
 include/linux/hugetlb.h               |  2 ++
 mm/hugetlb.c                          | 34 +++++++++++++++-------------------
 3 files changed, 31 insertions(+), 30 deletions(-)

diff --git a/Documentation/mm/hugetlbfs_reserv.rst b/Documentation/mm/hugetlbfs_reserv.rst
index a49115db18c76..fbca6625ca50d 100644
--- a/Documentation/mm/hugetlbfs_reserv.rst
+++ b/Documentation/mm/hugetlbfs_reserv.rst
@@ -201,10 +201,10 @@ The value returned from vma_needs_reservation() is generally
 If a reservation does not exist, and there is a subpool associated with the
 mapping the subpool is consulted to determine if it contains reservations.
 If the subpool contains reservations, one can be used for this allocation.
-However, in every case the avoid_reserve argument overrides the use of
-a reservation for the allocation.  After determining whether a reservation
-exists and can be used for the allocation, the routine dequeue_huge_page_vma()
-is called.  This routine takes two arguments related to reservations:
+However, avoid_reserve only applies to reservations from the reservation map.
+After determining whether a reservation exists and can be used for the
+allocation, the routine dequeue_huge_page_vma() is called.  This routine takes
+two arguments related to reservations:
 
 - avoid_reserve, this is the same value/argument passed to
   alloc_hugetlb_folio().
@@ -256,6 +256,10 @@ compensate.  See the section
 :ref:`Reservation Map Helper Routines <resv_map_helpers>` for more
 information on these routines.
 
+For CoW mappings, alloc_hugetlb_folio() calls
+folio_clear_hugetlb_restore_reserve() if the reservation came from the subpool.
+This makes free_huge_folio() return the reservation to the subpool on error.
+
 
 Instantiate Huge Pages
 ======================
@@ -284,14 +288,13 @@ be adjusted (see the section
 :ref:`Consuming Reservations/Allocating a Huge Page <consume_resv>`
 for information on how these are set).
 
-The routine first calls hugepage_subpool_put_pages() for the page.  If this
-routine returns a value of 0 (which does not equal the value passed 1) it
-indicates reserves are associated with the subpool, and this newly free page
-must be used to keep the number of subpool reserves above the minimum size.
-Therefore, the global resv_huge_pages counter is incremented in this case.
+If folio_test_hugetlb_restore_reserve() is false, hugepage_subpool_put_pages()
+returns the page to the subpool.  A return value of 0 means the page must restore
+a subpool reservation, so the global resv_huge_pages counter is incremented.
 
-If the PagePrivate flag was set in the page, the global resv_huge_pages counter
-will always be incremented.
+Otherwise, resv_huge_pages is incremented without calling
+hugepage_subpool_put_pages(): the restored reservation still counts as used in
+the subpool.
 
 .. _sub_pool_resv:
 
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 1d2dd10074d7a..0d5414392d870 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -590,6 +590,8 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
  * HPG_restore_reserve - Set when a hugetlb page consumes a reservation at
  *	allocation time.  Cleared when page is fully instantiated.  Free
  *	routine checks flag to restore a reservation on error paths.
+ *	Cleared when allocating for a CoW mapping using a subpool
+ *	reservation, which the free routine returns to the subpool.
  *	Synchronization:  Examined or modified by code that knows it has
  *	the only reference to page.  i.e. After allocation but before use
  *	or when the page is being freed.
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 2fd5a5e585ad5..6e79dedfc0fd6 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2635,7 +2635,7 @@ static long vma_del_reservation(struct hstate *h,
  * 1) A reservation was in place and the folio consumed the reservation.
  *    hugetlb_restore_reserve is set in the folio.
  * 2) No reservation was in place for the page, so hugetlb_restore_reserve is
- *    not set.  However, alloc_hugetlb_folio always updates the reserve map.
+ *    not set.  However, alloc_hugetlb_folio may have updated the reserve map.
  *
  * In case 1, free_huge_folio later in the error path will increment the
  * global reserve count.  But, free_huge_folio does not have enough context
@@ -2645,6 +2645,10 @@ static long vma_del_reservation(struct hstate *h,
  * reserve map indicates there is a reservation present.
  *
  * In case 2, simply undo reserve map modifications done by alloc_hugetlb_folio.
+ *
+ * For CoW mappings, allocations using a subpool reservation leave the
+ * flag clear and the reserve map unchanged.  free_huge_folio returns the
+ * reservation to the subpool.
  */
 void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
 			unsigned long address, struct folio *folio)
@@ -2692,25 +2696,9 @@ void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
 				folio_set_hugetlb_restore_reserve(folio);
 		} else if (rc < 0) {
 			/*
-			 * Rare out of memory condition from
-			 * vma_needs_reservation call.  Memory allocation is
-			 * only attempted if a new entry is needed.  Therefore,
-			 * this implies there is not an entry in the
-			 * reserve map.
-			 *
-			 * For shared mappings, no entry in the map indicates
-			 * no reservation.  We are done.
+			 * Region cache allocation can fail even if an entry exists.
+			 * Leave the flag and reserve map unchanged.
 			 */
-			if (!(vma->vm_flags & VM_MAYSHARE))
-				/*
-				 * For private mappings, no entry indicates
-				 * a reservation is present.  Since we can
-				 * not add an entry, set hugetlb_restore_reserve
-				 * on the folio so reserve count will be
-				 * incremented when freed.  This reserve will
-				 * be consumed on a subsequent allocation.
-				 */
-				folio_set_hugetlb_restore_reserve(folio);
 		} else {
 			/*
 			 * No reservation present, do nothing
@@ -3165,6 +3153,14 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		}
 	}
 
+	/*
+	 * Return subpool reservations to the subpool on error. A CoW mapping
+	 * might not have a reserve map, or it might already account for
+	 * another folio at this index.
+	 */
+	if (map_chg != MAP_CHG_REUSE && vma_is_cow_mapping(vma))
+		folio_clear_hugetlb_restore_reserve(folio);
+
 	return folio;
 
 out_subpool_put:

-- 
2.56.1


