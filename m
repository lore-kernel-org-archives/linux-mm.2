Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E870606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 20:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ln9Nsz11
Received: by kanga.kvack.org (Postfix)
	id 507FF6B05CA; Wed, 28 Oct 2026 16:16:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B91D6B05CB; Wed, 28 Oct 2026 16:16:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A8E16B05CC; Wed, 28 Oct 2026 16:16:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1A5436B05CA
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:16:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8A3B3C01D8
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:16:04 +0000 (UTC)
X-FDA: 85373141448.05.53C82A2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id C1523180007
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:16:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ln9Nsz11;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793218562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FQrXG0hBF/E00y3DiV9ZkP9WeaYq+wc3xIIhWYQpVjE=;
	b=yFPaL+6JG/cdf2jo4mZGHktwIkLIN3jbtxJCIEpMFI45a4XPF6vtpl72nBuEpbcGeJZnvr
	WICeht22FI6dwMmq0caYnrDgO5PrE8AylP12cWYW+4ZJJnQNEgOs/ejAXZyvLN7rctILch
	Gr1Ll9hCbAQhxR8zyVCuJ87zWqFXH9s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ln9Nsz11;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793218562;
	b=m//JHd8WQp+7/gruvsy0nCoc+gR34B1A5yVzVRSdEXA5CAELW70VLUolxQGnLR2UT34jIm
	f488QfLKa7hgojZTB+MOcY/WHVdiGXKWjmHG17VB6ijlCHg3fKqvvL3kBIDEeXgM8mwj8t
	X3+m0OZu3jwH4TD5cp0Ejm0w2TDxUBw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5DF6B600C8;
	Wed, 28 Oct 2026 20:16:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE56E1F031E2;
	Wed, 28 Oct 2026 20:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793218562;
	bh=FQrXG0hBF/E00y3DiV9ZkP9WeaYq+wc3xIIhWYQpVjE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ln9Nsz11sQSofutgxCUth7eaiTXOM7ZZxeJJKJ5Aw4dW6zrblyRc0iIrcbIxTCryl
	 xyO9loKu6fYLkrAG7zRt0vsz3FH5w3yE7ICju/XFbkMXi+837UZXvZeaLdIww+RGFZ
	 0d31jdKKOX2umFntPBR+P6Lx8a4+PE4Lmp10RPbbUdtVDf94o18xpFWyYc7qiKP1ct
	 H9ysoaHkC5/gtcOVKwNhD2M9kahhlowYq+PKzUJbxmCqsHtY0G17/PrUcLj6g+pMxv
	 IrVv7XcLsK3VDroPQCB8hlyf2/p74TQdFmp7Pl8YUPygWvcfwU+KbwumpactCA0GM/
	 c6P6Ktl/wChHw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 28 Oct 2026 21:13:41 +0100
Subject: [PATCH 13/15] mm/hugetlb: fix reservation leak on min_size= mounts
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261028-fixes_hugetlb-v1-13-a0a033db180f@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8867; i=david@kernel.org;
 h=from:subject:message-id; bh=hPeu4XFgIxpqptAMkVO/zQ+wRyE3vH8v83lPlAJo1KQ=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIehZddj5v/28pLazLju38WcotL8zqZZK9Vb33MsbdD1
 f3ft7/vOkpZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZiIqDDDP8293Yk9C+dHbhLM
 vVzVn7ZpvWNfWqyste1rlSqmazmTvzMyHO/OKbnLy68ewiobHbuvpOrS78IaX5lVkQ73TwRZXFN
 iAwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C1523180007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ajahnouuggghzpjrub7frufsyfjnjxzr
X-HE-Tag: 1793218562-471936
X-HE-Meta: U2FsdGVkX19J0l469NsdcxHDDb+Dn9iWVgbQ+RBFkfwbfYo+4V11s0i92eDItzIOxYyfwJYeGFRhOf7mcKaX4engq7SCAg/zSFnGFFcyqhO3c+eD2Dih4YWF5WaI8WQY2L+wxhoW3Hc4T8x5Q3X36oKeRW81FFgfnWqUVYjLf7/EDDNPFRCUFLRFAtOVbar1fyPUKIdzbgnv6hnr/FUMt0Xw/rRIqgT4DsKloOqMGDq0TzzLEungUkiNTfaSku4FLTbJ+zSps8kBdnacOBK5+PmTBo+FtG2xdi9h/SLKXQC/+fzMwZ6CXJsWTXB2VBu43bnhnd1vHt3IBijJ5pqIwu/ZTR9+YjUXONgOiMQVIYUooDvFWy3QxBhjSsZidNtAVVUPke9hw7c0y1NWcfY9ujohbG+vZtKYpH6yiSH80ChinYP6DZT7aYw5wcwu/Kmo8M4ygJXXHMogL2n0lzNW4MkJKGBr1oCOPOEqmaHEGLFi0MMdrqHs7GbRgpvDKU3XBQQSoAYrTqkiT3CeLbXQTehIpHpiWlwh/E5qevMHhhrP7iQewtaHw6Mg1JygEAef9XmEEGVSujt7N6/W85U19QffSKsTLbcuQVyeetn5TBP05cRyCtX3M/uOMSrHGB/heoyA19CvwCqCFghtCAY4t008L4ZdiZjG7qXl/TqddevdZkg+2tVgkFEl7YYO3U6CoZZUE7Y2joFf9JLNkPgQUVUaC7or0OmX00ZngR/vzKXM3AquKPCrm3utL7kkVHHQ8hK7RPTWXwDsHKUj4VGuvt3Up/JfTe8xmXdONkF7Va/eWH4hILITdiww+wgKDzF5hJZH+MC5hBZ6QF7o7UX4yV4EXEBNZZadJ53ENvvShj4pVlk9l2n6+BOnHB6nV0XJqgIgofRSdAwkUVCRCq6YJlsjwp1QAD9t1naLItaOjyV+9xEfL0y/jE8jA86jQfOCbn06xTwKVk3eLNaySMa
 2d8QZ33q
 gRwPaw5TUq6sFR7+qjQMW0iy4VNFLqrLPf2l9uBroU61qLFb8XgqWpfI89bRA4q1L6qGO+vPZfCVnaEULWNNXN06jNrymB1R4urXNYIGrMkhJCHebVToQJHMiHH9ForjF8TTb6ttc0rDbwAUBn77wJ0WMzKoyJuyPmiR/QHXGmrwaphDvlMOh9lrF+z0P9o99LyufxbsUKGP5IKxC2a8fKHAbyxZMgBNHS1VPNPZeX1ez2loPWJSvX2njpc610ju9RwE3aEk9fknw2FJyex89XYD+Zzbi/OMvLujGFQX2evRS+GPEwTw1qwCdajP4WTQyv6X3N3FTeWGy7aj7YkjRRMloJhYLNm9coHEuqMsTohXJWtZsMz+xxIdfIg==
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
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
[ david: simplify comments and improve description; updated Fixes ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 Documentation/mm/hugetlbfs_reserv.rst | 25 ++++++++++++++-----------
 include/linux/hugetlb.h               |  2 ++
 mm/hugetlb.c                          | 34 +++++++++++++++-------------------
 3 files changed, 31 insertions(+), 30 deletions(-)

diff --git a/Documentation/mm/hugetlbfs_reserv.rst b/Documentation/mm/hugetlbfs_reserv.rst
index a49115db18c7..fbca6625ca50 100644
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
index 2a3fde411d74..badb8790653e 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -593,6 +593,8 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
  * HPG_restore_reserve - Set when a hugetlb page consumes a reservation at
  *	allocation time.  Cleared when page is fully instantiated.  Free
  *	routine checks flag to restore a reservation on error paths.
+ *	Cleared when allocating for a CoW mapping using a subpool
+ *	reservation, which the free routine returns to the subpool.
  *	Synchronization:  Examined or modified by code that knows it has
  *	the only reference to page.  i.e. After allocation but before use
  *	or when the page is being freed.
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 32ecac4e0d3e..69a5d2c73ee1 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2631,7 +2631,7 @@ static long vma_del_reservation(struct hstate *h,
  * 1) A reservation was in place and the folio consumed the reservation.
  *    hugetlb_restore_reserve is set in the folio.
  * 2) No reservation was in place for the page, so hugetlb_restore_reserve is
- *    not set.  However, alloc_hugetlb_folio always updates the reserve map.
+ *    not set.  However, alloc_hugetlb_folio may have updated the reserve map.
  *
  * In case 1, free_huge_folio later in the error path will increment the
  * global reserve count.  But, free_huge_folio does not have enough context
@@ -2641,6 +2641,10 @@ static long vma_del_reservation(struct hstate *h,
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
@@ -2688,25 +2692,9 @@ void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
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
@@ -3161,6 +3149,14 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
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
2.43.0


