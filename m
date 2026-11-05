Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4232C606A32D
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 13:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C6DY1Waz
Received: by kanga.kvack.org (Postfix)
	id 5B3086B05C2; Thu,  5 Nov 2026 08:11:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53B1E6B05C3; Thu,  5 Nov 2026 08:11:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42A8A6B05C4; Thu,  5 Nov 2026 08:11:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D4436B05C2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:11:21 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AA769805BE
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:11:20 +0000 (UTC)
X-FDA: 85401101520.16.70B7D40
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id D8D4414000E
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:11:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C6DY1Waz;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793884279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O+uAOf22ku0nBzO5a3bnCrNp2btg27dwJZHDk2t3+oc=;
	b=J5eueCkLK0peW+/MuV5KI7M0Ai558vv4BAC528JbUisywp2HTyAf3TJS87sdyGbYVnn06N
	/FMwbCwD6R+9SwJx2TcH7n5I7hTSVkglJqt5+PDF5B9Lz9KnbDADo6amzI2OjNlGyhRs6c
	nuPU3V/971lJ0+GyAP0Wsah7pP4pkds=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793884279;
	b=P4IFIUAPcATd4Jjhi3cx7nmST5pANjiSzXr6bFa9UVAQN4pRKrvBEMVsNynq/xrBL/dYzc
	kFAZHeLfEmSCA3rUad3UY0eVPCvke1OO+vZOovU/YVf+kNhGz9HrVOZy3z81JgOhHpFWDB
	nGhDCWosIwonTiJFZX7uObdSAV31Fq0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C6DY1Waz;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B6C140E30;
	Thu,  5 Nov 2026 13:11:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BFA1F00A1B;
	Thu,  5 Nov 2026 13:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793884278;
	bh=O+uAOf22ku0nBzO5a3bnCrNp2btg27dwJZHDk2t3+oc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=C6DY1WazDreIp0tqngL8J96ms2jUv/PGhhduU/iK8a4K4yiFtHbCImq5yDnpJSB/i
	 MfT83/xUbBuNgTPO+k6ECz01TEg9sNUG1vuGIMo+eDHmOGuSyK/iXBga1oxUJvU6aU
	 UleLYrBcEjbSEdPFjdvQZRHBf0w+ObpAzE/dWNnyZlxsEfa1E2GGa23gAVJlVV3E2C
	 gukdedk+fcJrHXpCAgX66uTS9c7Ioybk9NhVkXaGy0WzWE98E7/aHLlU95nZJV9z19
	 Oqc96TL3rSJh9YcyeeyatdylmcGOyB3tpTtGz6gvzdl2DJExwADPbM5H/dn42p891Z
	 1EkqpbCJAaDaw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 05 Nov 2026 14:10:14 +0100
Subject: [PATCH 5/5] mm/gup: limit pagecache folio refcount when grabbing
 references
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-refcount_overflow_stable-v1-5-70b9c655da3e@kernel.org>
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
 stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2098; i=david@kernel.org;
 h=from:subject:message-id; bh=IBF3fb4To5eP04NbeBZ/jj0H6jfX9PmTFRUfnhgVDek=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLeNFhOiqkz3PLwi9bq1D/7fq4JYkqqbdslJTwlJHeTN
 +MK/mNNHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEzEN4aR4YGas5mNyg05jdwp
 L5pmXlDsVHMPbzDdvbWu5rHw8ek3kxj+6X9Yrf89V7Sg1lXs6jzOC3F8x1TtJ+29GvphkYnibr/
 ZPAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D8D4414000E
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: b3kfz53aituanumkb3sfic6yhs786u3c
X-Rspam-User: 
X-HE-Tag: 1793884278-1573
X-HE-Meta: U2FsdGVkX1/8wNLnQRScmrjcSAt78h2Pd/0wfWA4INdnbRnKCp9AW8HAw579D9xlv5k6TzmbAnsemEdP/6tqjajBf6uy+7pN3GUC5g0va+x3Kmja5OBVpe4uKkrOqt1kSP/3/bz+P9kSM89V7Qt/q6ky3YcyWV9Zf16LuC9+mBLpVHs7+yz/TBtOcKE5RpmaNQ3sFgbyUvRz04h6dZ045A8iRTOWOIBWC9mf7H0F/gWViUpBZ6ld58LJ347+NG+3hEGZ6z4+aTLMO3HP4mSI5qQ3L+0GQD+jNmQ1sCQC8ttFiNEdUqEqWZsAFyN0803ivGGXOJHOrh2dPx8qc7G3iqdRELMz3j1aA2WB/H398/WjtOSuYUMAR8e7K5+v18TxUN35ooRThHC209rO6m57zsQk5MPjMLTCSCtFAI3o5mP5CSPg0v8pVpQGKP0wlQdQ/BM7+y/5YSP31ZLDVVGQzT0ups8RFIwiDqTWAtdfivlZnzp0jf1/bguwwdaIHk0YdS2mVFnc0fGd6tImCFLZea8cC/ehE8lPTgaSjXAz8wx3LuaeuYNnYtF3eQy3+khyFfcvA3vXnV8Pgqe5NPSdkd4nIxdbGPz2MlWDfwG2Is/TsOGiwzWsqfFEWoUR4uP8JDW+bCGWk6YWG7sWMefAVXcYD5K03nwbjxpOPCP8x4m4Bj9W3VNPEOIv7dT/UpSyWdWEXMzUbQyrhDjEKSEALG4yOoLL7KFNRLkHvAbe9bHgOE97yqj5seF2XoopW7xXK5Xe1xZaWLKBvh6MVQuXwD5b5RDDtKuYRSPlPw24ocB/d8UZWCA2wHjzoRefDp5Mg3GT/kXRJhoEWUg7ug/woQKoHjvsyntJnAAYoyY6kg7JEXfv7Goy/1QeeWmfHTjtRpmOuhSJAEjjSB6qW3YFhQ003q8kHwtA6XoAnR/o+Ff07H4nEcmXPpXrbmlGTZx0PmTf3MdbAGNfpbWl/Ee
 N0O3SRFA
 C+l389Ank+nvZH/CbCFb7kckX557w12nBOpVdJ/+QqeZK+ufcLon1Z21GDuDZTNfi7UWA6kPuo93IRt/RsZk2M1YivlBnfs2nKX1SNcRgkjuoh1UCzkdsMaKEnDryo+zF1JJvAuoWayzM6pUfXWPHzpGm2hK+x7XhT+uTcF/lQ8gsI2v0rwBzEpMqygj70+XNapGzSnOnNwnC1SHP53k8zxfKSBeTrkK6ChRPs2HvUuf1ucneWX6u1g13v+xTHhOudKGmzBJBw0sOYbsBzdOAwUt9+F0X98ljNFd2tdJYlBnwf/NeXwKj3ad36SnaOI4Y/1XR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Let's replace our existing safety check by the new
folio_ref_count_over_limit() check in fast and slow GUP before acquiring
additional references or pins.

Keep it simple and use the check for all folio types.

Drop the WARN_ON_ONCE(), because apparently these things can currently
happen with large pagecache folios.

Keep the zero-refcount rejection if the refcount is 0.

Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/gup.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 2ab42fc6834e5..db9db6b2a4662 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -77,7 +77,7 @@ static inline struct folio *try_get_folio(struct page *page, int refs)
 
 retry:
 	folio = page_folio(page);
-	if (WARN_ON_ONCE(folio_ref_count(folio) < 0))
+	if (unlikely(folio_ref_count_over_limit(folio)))
 		return NULL;
 	if (unlikely(!folio_ref_try_add(folio, refs)))
 		return NULL;
@@ -140,7 +140,11 @@ static void gup_put_folio(struct folio *folio, int refs, unsigned int flags)
 int __must_check try_grab_folio(struct folio *folio, int refs,
 				unsigned int flags)
 {
-	if (WARN_ON_ONCE(folio_ref_count(folio) <= 0))
+	if ((flags & (FOLL_GET | FOLL_PIN)) &&
+	    unlikely(folio_ref_count_over_limit(folio)))
+		return -ENOMEM;
+
+	if (WARN_ON_ONCE(!folio_ref_count(folio)))
 		return -ENOMEM;
 
 	if (unlikely(!(flags & FOLL_PCI_P2PDMA) && folio_is_pci_p2pdma(folio)))
@@ -1482,8 +1486,8 @@ static long __get_user_pages(struct mm_struct *mm,
 				struct folio *folio = page_folio(page);
 
 				/*
-				 * Since we already hold refcount on the
-				 * large folio, this should never fail.
+				 * Grabbing more references can fail once we
+				 * hit folio refcount limits.
 				 */
 				if (try_grab_folio(folio, page_increm - 1,
 						   gup_flags)) {

-- 
2.43.0


