Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1D7BC61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 19:26:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72D2A6B008A; Tue, 25 Aug 2026 15:26:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DDB86B0092; Tue, 25 Aug 2026 15:26:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CCA46B0095; Tue, 25 Aug 2026 15:26:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 36CA76B008A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:26:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BC938A23D0
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 19:26:24 +0000 (UTC)
X-FDA: 85140773088.07.D5345C3
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf31.hostedemail.com (Postfix) with ESMTP id 290A420003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 19:26:23 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="li/5IxCA";
	spf=pass (imf31.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787685983;
	b=F46jsa5rjWYGXxstKDvRKVIR8M01IxCuQaN0ekey5+b/UltzbGPgOMXfnUdqQp/g2LO2Qk
	f0LcpQS6t+Nqq0tkqHGR6g/D1CpeqqXgn/BBKI5+JJ4TL7oImw/luQRwaMM9j3g/LjfZPW
	lzYvzDQr4SBBdNlc3QDL5ThpK0RDshI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="li/5IxCA";
	spf=pass (imf31.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787685983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1U8nGdXZuPfk1UQh5qcey6Ikj7KRt3cnTMOthCd71Jo=;
	b=xllk8u++/DjAx76B4mCn8KXqK1776ahJPzZ8jAdmHZ+D5DolZfPjt5YiFgX0kdk5Gq1N3U
	AHtHKav6s9q5aOAr8nZCPONWZFECJbzSBh/trtou13Kd65okZAkv/VJ9AuvXJ5y70qmL0U
	HbxGVvmFH4TV3qP/AMFWkdC83rsxBq8=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ce7d2adef4so3128635ad.3
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787685982; x=1788290782; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1U8nGdXZuPfk1UQh5qcey6Ikj7KRt3cnTMOthCd71Jo=;
        b=li/5IxCAQcAxwAtwMb2G8lqrN/ana+5YsgcG/a0mF8EEojYjw5i3pWsxB5qbvHTd3D
         BTODi9bQtusez0F6ECagcObQH3BBfkajf0wDXIiqBh5Im+NkaIAqoWbYXvdw4eFXnklI
         uOoJwKgX0dqMlA79XvgaItMHFnPvixx+rIWOtGB0W1OuBiLa4TP28rZ/Q7QdkbYuc4tk
         HSINPkfYrC+K47edoV7tLhbOoO8v4P91pWpDP7XZzhswSx+zSvMkrad6JD0QE3XdOVQ0
         iAA3iTzt0u13QCChYj9bLSqhFXLRewGypgVWTh4hxROVtdyqbT+ONvroyokThr/g/Hs7
         jRXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787685982; x=1788290782;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1U8nGdXZuPfk1UQh5qcey6Ikj7KRt3cnTMOthCd71Jo=;
        b=C72Yu7pDDvcfE72L4NivyiuGmd2/kKLjfM/nhFW/jqbzpPCXlF2fgHWpvJqRzTld64
         1lEy1YGbNuLKlx1sB1zPMpnkUYDp1uXuPxxTXfSdejve74Aqv3RBhnHC5AGFSw5QQ2+O
         OP4dHQVx9TAiru9BpjFJelu12ZoN/BZFdSUGqnPBQJHAIQ7Gb2m2cji9KkmlK93WL/B4
         q5FtgFTLVeXoegyl1O659+yfqp3ordCr0et6a1s92FRVVM4HIMi3A3csBvsY69jVTSwb
         FBoKE96bVS8Hxfrq25ogJTs7sSAuY3wFDCO73yXSXxKx/NhNfcdcSy58gb/Qnuc1+I3c
         j3VA==
X-Gm-Message-State: AFuF++k4rU14QLBBOwEUxCOF0ZNPYAX33m35MDuDvf5CXW6YhSUT+NcM
	E3ddGL6WrrqmOxphuGfqPuS0Ak/bUlUgi5vJAwX3csxmvCgrPqP5Hrf6
X-Gm-Gg: AR+sD13laLx867LZ9ynFSk5XTyTpdbVEj6IrKFXGKPnsUegUMGdLn8ZMg+GJOAnUrqv
	HiG6n7sNpq/W/3wLNeStVl7eTGsHldcCtXLWvccwuFkOgBTWlm88C3yi8lszRt/uHxwAK4wr8rc
	KpN879ojiv6E2Y6iPWiJqBLqv6hjVf9UQt/fodUG23POtLS0lYnVJlGHvH4+D8jsOeKPccVflGD
	hU/7eSuQJf5XNdrP6iBwyIiTtJNQ+1rZk064n1tXiTANj+LuXo86EcITQlRMsfr+WHHykSXy25U
	Gqb2a7cLwUc/8mhiYAdVOfRvX8Vef7G6Za8LaLeYuIptMiR2VeTRQwCRuwxxcvSHtVifGDWRrDa
	A43Qfi9O/JJReL7+JvV7dJ+DFsVMbdUfiKd5kfvALGzKHyIxFhuHf6kr0NYBqa14paI2GSmTJEv
	Bc7/eW2+zrNnF+ExorbDWvqd6JK5UXtBW42Mf9sd/GVVDssA0JA0fZirhqZWm9quEyP00AuA1UH
	u0XCyAoQBq0URPaBJZSht9U
X-Received: by 2002:a17:903:350c:b0:2bf:dd0:c8b1 with SMTP id d9443c01a7336-2d707756922mr12042135ad.0.1787685981686;
        Tue, 25 Aug 2026 12:26:21 -0700 (PDT)
Received: from fedora ([2804:30c:1f03:a800:30b7:8d7b:fa5e:4825])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3283da25c8asm1249833eec.30.2026.08.25.12.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 12:26:21 -0700 (PDT)
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: [PATCH mm-stable] mm/khugepaged: avoid unnecessary checking for swap entries when collapsing a mTHP
Date: Tue, 25 Aug 2026 16:24:33 -0300
Message-ID: <20260825192433.3185880-1-pedrodemargomes@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 290A420003
X-Stat-Signature: djptk6bfdscuknsws8aewib4qzztcf5n
X-Rspam-User: 
X-HE-Tag: 1787685983-136839
X-HE-Meta: U2FsdGVkX1/d3bLq1oYZkIe7VG8n0CHZBF/AWtAr26BjshKGOYbx+oJmZir26KUxJqXaJj61nF/GJbkeHGNoV7satMDsueTIBAeTzOoKO+satNVWrVegUlUvk9cJJu59pnVPNuGpLRDQSGuUrCeGoIsbT/gutA6GAcbwNy40X3O+o+7CeSqpMqR1GuempdAWIVWL4N/dxyc5Yoz/uTmO3bH0nnXhTdLG3VSj6hPfTPjcWuqOF4Ujj7Lz2PiA6fkuyuzNU5p9IYLV23I8o18KqeZaNvb90w7ojDu2KpZvLw1TGA0OELZ/kTJNiLtGZKNL1jk2OqMnd0S97u4bEpk8al5ezCvp9RPCQr+uccvBuB6eCSVGtw9HN/JMjFG4fyFkkgIXuaXfiSzrh5fhd/T0v4eLiOorEovBwWkS6/oyEc/bE/GgN1yCY0vTmZfyziO3RGuLI59IR9c6NBXzGyesvpSSVYUPWmJVHcWuJj2ZFhtAF8rq25SVmmRy4MJMw0BW0V8xeGIJsjwnBmiaa2QX0rxCBmFGiqJlus8UksLKWvEDc6j86XlixAI/HaGSWw7HlNp+Vng95P/6AE/FtlFoNIQfAj3awFtVJFpbrhZkc3vqqYYhEiz30YSk2+2lx5nN3ww5ZggEnY3m84qiKPhXXWJ4CmbD+T8Rdz01YuGGBJw6dOjKu44GkCW5vi+z9CljFFO7UihI6tLOktHTVltH+Jz4/OYLSfEfQOI4ZBOCvIqE442CE1H/tzqYLtfDxKNwGAX3cPTeJBdsW+mQH081w8eR2olO4JxHR6vQXVWBHYBl5ZMCbPH3gAteUj9CU7eWTK5MfMkhnPFZ4SQHgVS59QYD7TupwT92wSSj9lYsjt/9jx1cDwoGGBYSzwHkcwhwnok7YgubO2KcQ26UC1T77dJNPx7rlaHy8y3Bj3A9tm55sOzKcRRcshAirdhTEVk7LQUPN4yA3aifWBDf9mG
 RhFDBfNB
 UqwW5dwnqZAyjrf6xUdNqSlOrKlppynX/x4o6xj54PsbNXSzT+LPvL4B4m4kdr5DbK0Pkg15/HWqIsKUHi62cpJJVuI9i+1gMUZMpWdGyJiKIeDdTWl24Ddyp86KxMr9XSh4KKw0wBX/HZ6iKo5HScmG09NPBW2MnJtuehRpsJFpHMjDuHjj7eBAYNkJexTzdm4CgKcuxXmicS4BczY6czw28DzuMuxQchlIzFbDgYs2jVVT1CnNu11++GpKykVmqvyQXrJ1z71ju5nkkVvYeKBXX1Ob6HBO28fejIAdIhgrPIpVxdu1wvT3IqvIRzsmO6h/UCo/phByU6bFxYUa6VZ60YVXkx9h3pcxS/GDhSR72yPykyFvIMruK0yLpbVaqcFz1zXtg9iKJ6c4FY95p6qIBcKuLB3/ZCyxu9fqgci0VOkg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mthp_collapse() tries to swap in PTEs when collapsing a mTHP if there are any
swap PTEs in the PMD range, even if none of those swap PTEs are
actually part of the mTHP's range.

Track swap PTEs in cc->mthp_unmapped_ptes so that mthp_collapse() can
tell whether the mTHP's own range contains a swap PTE, and skip the
swapin check when it doesn't.

Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
---
 mm/khugepaged.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 11ff98d55c76..38596172f7dc 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -117,6 +117,9 @@ struct collapse_control {
 
 	/* Each bit represents a single occupied (!none/zero) page. */
 	DECLARE_BITMAP(mthp_present_ptes, MAX_PTRS_PER_PTE);
+
+	/* Each bit represents a single not present and not none/zero pte. */
+	DECLARE_BITMAP(mthp_unmapped_ptes, MAX_PTRS_PER_PTE);
 };
 
 /**
@@ -634,6 +637,7 @@ static void collapse_control_init_scan(struct collapse_control *cc)
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
 	bitmap_zero(cc->mthp_present_ptes, MAX_PTRS_PER_PTE);
+	bitmap_zero(cc->mthp_unmapped_ptes, MAX_PTRS_PER_PTE);
 }
 
 static void release_pte_folio(struct folio *folio)
@@ -1291,7 +1295,7 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
  * Note that the VMA must be rechecked after grabbing the mmap_lock again.
  */
 static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long start_addr,
-		int referenced, int unmapped, struct collapse_control *cc,
+		int referenced, bool swapin, struct collapse_control *cc,
 		unsigned int order)
 {
 	const unsigned long pmd_addr = start_addr & HPAGE_PMD_MASK;
@@ -1330,7 +1334,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 		goto out_nolock;
 	}
 
-	if (unmapped) {
+	if (swapin) {
 		/*
 		 * __collapse_huge_page_swapin() will return with mmap_lock
 		 * released when it fails. So we jump out_nolock directly in
@@ -1502,10 +1506,10 @@ static unsigned int max_order_from_offset(unsigned int offset)
  * mTHP.
  */
 static enum scan_result mthp_collapse(struct mm_struct *mm,
-		unsigned long address, int referenced, int unmapped,
+		unsigned long address, int referenced,
 		struct collapse_control *cc, unsigned long enabled_orders)
 {
-	unsigned int nr_occupied_ptes, nr_ptes, max_ptes_none;
+	unsigned int nr_occupied_ptes, nr_unmapped_ptes, nr_ptes, max_ptes_none;
 	enum scan_result last_result = SCAN_FAIL;
 	int collapsed = 0;
 	bool alloc_failed = false;
@@ -1522,21 +1526,25 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
 		max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
 		nr_occupied_ptes = bitmap_weight_from(cc->mthp_present_ptes, offset,
 						      offset + nr_ptes);
+		nr_unmapped_ptes = bitmap_weight_from(cc->mthp_unmapped_ptes, offset,
+						      offset + nr_ptes);
+
 
 		/*
-		 * Swap PTEs accepted during the scan are counted in @unmapped,
-		 * not in the present-PTE bitmap. Account them for the PMD-order
-		 * candidate.
+		 * Swap PTEs accepted during the scan are counted in
+		 * nr_unmapped_ptes, not in the present-PTE bitmap. Account
+		 * them for the PMD-order candidate.
 		 */
 		if (is_pmd_order(order))
-			nr_occupied_ptes += unmapped;
+			nr_occupied_ptes += nr_unmapped_ptes;
 
 		if (nr_occupied_ptes >= nr_ptes - max_ptes_none) {
 			enum scan_result ret;
+			bool swapin = nr_unmapped_ptes > 0;
 
 			collapse_address = address + offset * PAGE_SIZE;
 			ret = collapse_huge_page(mm, collapse_address, referenced,
-						 unmapped, cc, order);
+						 swapin, cc, order);
 
 			switch (ret) {
 			/* Cases where we continue to next collapse candidate */
@@ -1667,6 +1675,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 			continue;
 		}
 		if (!pte_present(pteval)) {
+			__set_bit(i, cc->mthp_unmapped_ptes);
 			if (++unmapped > max_ptes_swap) {
 				result = SCAN_EXCEED_SWAP_PTE;
 				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_SWAP_PTE,
@@ -1785,7 +1794,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		/* collapse_huge_page() expects the lock to be dropped before calling */
 		mmap_read_unlock(mm);
 		result = mthp_collapse(mm, start_addr, referenced,
-				       unmapped, cc, enabled_orders);
+				       cc, enabled_orders);
 		/* mmap_lock was released above, set lock_dropped */
 		*lock_dropped = true;
 	}
-- 
2.55.0


