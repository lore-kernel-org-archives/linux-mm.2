Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8DB6CD98F2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 17:26:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE8C86B00A0; Wed, 17 Jun 2026 13:26:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9A066B00A1; Wed, 17 Jun 2026 13:26:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D61B46B00A2; Wed, 17 Jun 2026 13:26:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A458E6B00A0
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:26:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 15FF11C288F
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:26:40 +0000 (UTC)
X-FDA: 84890084160.02.A8E8E26
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id E1E81140002
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:26:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CjW8FCxN;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf23.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781717198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JzJMAwxI8MaOV9KoH9x2XioBUzWPQ1np5ZRUV6yK6M8=;
	b=cwmfL1v5ZlBYOQXfIz5nOpP68SYCFMM5Q9YLxLLWyCT1GwV6zuUnpUawdqEtOFVuQgjq8r
	yb9ki+LzOeE3Xr1arsA/MVBOHV2E0vk/y1s4WGeyoKtOcmJrGC0Deg4s50iCE9npLXf0LI
	5Ti1ny1AgY47KaYWh7Zni4ZeFYG53bg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CjW8FCxN;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf23.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781717198;
	b=oZZTczouXC5mirXVmodICt+nEgsJH96A33n71uJWSMy7f+VVvHYPwT3cOHlR5b3a6VjBwn
	uHPArqfgj3ObZnmO237D/FCgwioadyK8C2wlDstDjV+S4brPKcEu2WjcMPR2TKGgoRU2d3
	Jy0fQumjZzOEjjt4iPo9NgNO6Ua5t5s=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65HEsR4i2367895;
	Wed, 17 Jun 2026 17:26:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=JzJMA
	wxI8MaOV9KoH9x2XioBUzWPQ1np5ZRUV6yK6M8=; b=CjW8FCxNvxjqS+g9ojf60
	qZ2DFDVCcJlQw8s6XONlTJo7TQ6chdL9QQvJN7ixtNLMlI/ybDA/pYCFFvoAbI76
	P9kq1mdKse6vpN0YtTahv375t95SeF+CgF3OyabRnpW68L7+PsipusScKP7jpTOW
	kim0QQ2iUBX9npyGp71GG7wKkiaYWt+xMfgwEXHkK2d3nLLJwqJ9PH8DzQIqZRM+
	djGyRR8ECKlm1Jpc3j4w/HIEyE71rPf7pHDsEz/ehT4IIknp6cEURHs7qw0+/T/u
	liCG9TxbfInyWlWdz1DfvFkK2+myuCh+WSoEbhQPvfVrtrROEJAmj3dnowb0Vbco
	g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4eueg31c4h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Jun 2026 17:26:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65HHNVP9003778;
	Wed, 17 Jun 2026 17:26:26 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4eudvc0wgy-12;
	Wed, 17 Jun 2026 17:26:26 +0000 (GMT)
From: Jane Chu <jane.chu@oracle.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org, jack@suse.cz, viro@zeniv.linux.org.uk,
        brauner@kernel.org, muchun.song@linux.dev, osalvador@suse.de,
        david@kernel.org, hughd@google.com, baolin.wang@linux.alibaba.com,
        linmiaohe@huawei.com, nao.horiguchi@gmail.com, lorenzo@kernel.org,
        rppt@kernel.org, peterx@redhat.com, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 11/11] hugetlb: make hugetlb_[un]reserve_pages() to take PAGE granularity index
Date: Wed, 17 Jun 2026 11:25:32 -0600
Message-ID: <20260617172534.1740152-12-jane.chu@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260617172534.1740152-1-jane.chu@oracle.com>
References: <20260617172534.1740152-1-jane.chu@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-17_02,2026-06-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606150000 definitions=main-2606170167
X-Authority-Analysis: v=2.4 cv=I8VVgtgg c=1 sm=1 tr=0 ts=6a32d8c3 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=yHGXro-o_ZvKznPa7vkA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12312
X-Proofpoint-GUID: 4z_6LYTeuHgG3mJtU6XoEPj8BQDDRmP0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE3MDE2OCBTYWx0ZWRfX59p4of+bEfsl
 mRXJ2w0HfKklFcyPuMsVA5JYitMs9UjXzmqRWyAkcovsCtba4Na7Uq4dz7NI3VTA0A8M843oE+z
 Nd6tZJYYKZ/NBlwrE6CfXU4moCkYCL8Hjh94QGc5KbiFh5xeMTus1tZrGuTFArKGzcFm7tl+SdL
 RP6wEO/v/3Tf/TvIL7SkvHHi82mNdfwdk4x6B9unA+J9hXtihNNFKBJ7HfrGyYaW0+JB4N2tN+m
 VY2X4rV0MObqr3mAjrXNyssJnY2ZkVvV8meRy56kpasOIXKS5Boo9G39qL+WrwsraP915yXEngA
 pChLyeCZQYCSgNQuXKK1PaY7stl9vp0LpfCVZsqCpCgEb+x6IYdfR08eo1iwk7zBTVT+91dyBeD
 GuzfyXcecJ+G58Mqqz2EOA7CPjJLXs8dpg3j+C1yRSRZswjgN/kTtFktD+VDgOr2ApQN4dHjmdP
 Y2CcoHrH2qmR0fTbycG1AhqKRCINuy6qeSklrmy4=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE3MDE2OCBTYWx0ZWRfX7IakPwS9wq+H
 UguJV3pMlw68ZSF0Xa9EmSsYd15kciF0sCORFcpSdOfFfbq63zPVBRxTnLhUq7rShOBoVwJ0/0c
 B14vcDI6xTaP2HmPXUEXVmVfYg0jhgIzJysqhvaWr5gD4G2UYsL2
X-Proofpoint-ORIG-GUID: 4z_6LYTeuHgG3mJtU6XoEPj8BQDDRmP0
X-Rspamd-Queue-Id: E1E81140002
X-Rspam-User: 
X-Stat-Signature: nuzffpmxqi46a9jugoynd43e5tru9c9b
X-Rspamd-Server: rspam09
X-HE-Tag: 1781717197-100492
X-HE-Meta: U2FsdGVkX18g3vUBVBt8k3KhvSrXNPUZkSixG19h+wVyORbNYKTcJe11vgcG9jU0G08fWiF6ntr7zLt5v96sq0IF0J+QwSc5lIqCNEv3GPKQmnUuQAao2xW4odVGlg2QjW39AQyfUlpg4zoQnnc++lk/wpffpBN15B98/FeDFCdyJmVBwoQ5TSzCDSYEMyNxYpP+PysL1wG9/vtfJN2ZgFQOp7axDNJRrwnJEAOnRJJVcMA/lK2L8W9Cs28CrvLd0g5n11k5/yzB9XF85wj4C0y3gU1nz987nsm7lNTILbcRdhHMjYoCy+t4zwIEsC3e6jqEytMy0rV/wMoiFiUhNTLJUNi3ZE+w6+1CjsvHUajzFwfOub7e4wPFwFfjGMpzmsS/+9iFfOH1iiu2Pt9voPQ7J9OheYYCLoO39F6FbN4ksXl/oOsHSWg33CqcOfWh8QgHQbqN/apfwIg/1QHM7GEcX6KxhxqTAMV6DOPqfPsFNLkoONLMrWE59F7zx41CztAeY0DvAcbBMSQrHVHWFdv7CynIFL8L9177lE3bHnqG1SNFjSAB2wRoz1a+wamk6ZdouB3kPgx201An39ccLQDvrS35nS9MCyvLLttlUQa/aWFPs2IOZ6m8YO6yOKFuUL9LNOgRO751rfkpP8YdSUs+1ZuxPlv2rpTVjM+1j2YbZZULcaaHE0QZQnpz9OWMM+G57PlDreNBLud2p9eZ2czQ5+gJbfQi3SBHN3J47yYe+VFNPs0lzICFbLVPRYRUTSg6Gdb/8Xf2KQibyejh4dxezPdPsFbEl9dh2ygw4aHnUk6YGsC1Yr4A3r5fxRG7+8t1zb9xIH66x9tq8gfAVF9tMKuar+4sXRkoSJyGvPQ79dUr36oH1Of5Kuw1hr4e7b8TSvejicX+wZMh3/bkMggyrovNuStOtQyU5Y8Q7z/U58af4yxayD7dPb32pmvHsMcdTCPp5uCI01u6s7G
 W8gKv1i9
 At4sgyxytW+91bJfTmKse3M3gL7X/KY3PlyFLOW/FFpcmgptmJYGn+qF6NcfP5YcY4M9Cl9yooDlqE9WakDk6DKSYCC+4J4fZ7Io6q5weBjodFwxkHYaSSR6jLLYoau46wACf3OH/1nEo76p5WY6T35bVLDYgOrWSLxyczwqunVncca0QFpLkPecS7zbd6YtqNN1x8Vpb5OxVAvT0ONGebyvi5IIgNbhsOTJCZdkY2mLcF93G3BC3q/fjnczGYTuszb6/VteMkjUoIeEN6rZ9+9T3iY3OGlpf1tcYq6JFnMhormeIlUmJgpYyCDTbkO4WZ9AG5Ywj+Qqjk0DwFxr5BTzQTeqBEZU8LdWPV0eN5ThoeN5OgQ35knL1CZQqsDnDwwKSzLUQFBsYcJY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hugetlb_reserve_pages / hugetlb_unreserve_pages have two callers and
one of them is outside hugetlb. Make both functions to take PAGE granularity
index to be consistent with the rest of MM.

Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 Documentation/mm/hugetlbfs_reserv.rst | 19 ++++++++++---------
 fs/hugetlbfs/inode.c                  | 25 +++++++++++--------------
 mm/hugetlb.c                          | 23 ++++++++++++++++++-----
 mm/memfd.c                            | 20 ++++++--------------
 4 files changed, 45 insertions(+), 42 deletions(-)

diff --git a/Documentation/mm/hugetlbfs_reserv.rst b/Documentation/mm/hugetlbfs_reserv.rst
index a49115db18c7..880e9ccd5b57 100644
--- a/Documentation/mm/hugetlbfs_reserv.rst
+++ b/Documentation/mm/hugetlbfs_reserv.rst
@@ -112,11 +112,12 @@ flag was specified in either the shmget() or mmap() call.  If NORESERVE
 was specified, then this routine returns immediately as no reservations
 are desired.
 
-The arguments 'from' and 'to' are huge page indices into the mapping or
-underlying file.  For shmget(), 'from' is always 0 and 'to' corresponds to
-the length of the segment/mapping.  For mmap(), the offset argument could
-be used to specify the offset into the underlying file.  In such a case,
-the 'from' and 'to' arguments have been adjusted by this offset.
+The arguments 'from' and 'to' are base page indices into the mapping or
+underlying file that must be huge page aligned.  For shmget(),
+'from' is always 0 and 'to' corresponds to the length of the segment/mapping.
+For mmap(), the offset argument could be used to specify the offset into
+the underlying file.  In such a case, the 'from' and 'to' arguments have been
+adjusted by this offset.
 
 One of the big differences between PRIVATE and SHARED mappings is the way
 in which reservations are represented in the reservation map.
@@ -136,10 +137,10 @@ to indicate this VMA owns the reservations.
 
 The reservation map is consulted to determine how many huge page reservations
 are needed for the current mapping/segment.  For private mappings, this is
-always the value (to - from).  However, for shared mappings it is possible that
-some reservations may already exist within the range (to - from).  See the
-section :ref:`Reservation Map Modifications <resv_map_modifications>`
-for details on how this is accomplished.
+always the number of huge pages covered by the range [from, to).
+However, for shared mappings it is possible that some reservations may already
+exist within the range [from, to).  See the section :ref:`Reservation Map
+Modifications <resv_map_modifications>` for details on how this is accomplished.
 
 The mapping may be associated with a subpool.  If so, the subpool is consulted
 to ensure there is sufficient space for the mapping.  It is possible that the
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 0b49a79efb08..fe1ebfd604dc 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -150,10 +150,8 @@ static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	if (inode->i_flags & S_PRIVATE)
 		vma_flags_set(&vma_flags, VMA_NORESERVE_BIT);
 
-	if (hugetlb_reserve_pages(inode,
-				vma->vm_pgoff >> huge_page_order(h),
-				len >> huge_page_shift(h), vma,
-				vma_flags) < 0)
+	if (hugetlb_reserve_pages(inode, vma->vm_pgoff, len >> PAGE_SHIFT,
+				  vma, vma_flags) < 0)
 		goto out;
 
 	ret = 0;
@@ -389,7 +387,7 @@ hugetlb_vmdelete_list(struct rb_root_cached *root, pgoff_t start, pgoff_t end,
  */
 static void remove_inode_single_folio(struct hstate *h, struct inode *inode,
 		struct address_space *mapping, struct folio *folio,
-		pgoff_t index, bool truncate_op)
+		pgoff_t idx, bool truncate_op)
 {
 	/*
 	 * If folio is mapped, it was faulted in after being
@@ -401,7 +399,7 @@ static void remove_inode_single_folio(struct hstate *h, struct inode *inode,
 	 */
 	folio_lock(folio);
 	if (unlikely(folio_mapped(folio)))
-		hugetlb_unmap_file_folio(h, mapping, folio, index);
+		hugetlb_unmap_file_folio(h, mapping, folio, idx);
 
 	/*
 	 * We must remove the folio from page cache before removing
@@ -413,8 +411,10 @@ static void remove_inode_single_folio(struct hstate *h, struct inode *inode,
 	VM_BUG_ON_FOLIO(folio_test_hugetlb_restore_reserve(folio), folio);
 	hugetlb_delete_from_page_cache(folio);
 	if (!truncate_op) {
-		if (unlikely(hugetlb_unreserve_pages(inode, index,
-							index + 1, 1)))
+		pgoff_t index = idx << huge_page_order(h);
+		pgoff_t next = index + pages_per_huge_page(h);
+
+		if (unlikely(hugetlb_unreserve_pages(inode, index, next, 1)))
 			hugetlb_fix_reserve_counts(inode);
 	}
 
@@ -476,9 +476,8 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
 	}
 
 	if (truncate_op)
-		(void)hugetlb_unreserve_pages(inode,
-				lstart >> huge_page_shift(h),
-				LONG_MAX, freed);
+		(void)hugetlb_unreserve_pages(inode, lstart >> PAGE_SHIFT,
+					      LONG_MAX, freed);
 }
 
 static void hugetlbfs_evict_inode(struct inode *inode)
@@ -1429,9 +1428,7 @@ struct file *hugetlb_file_setup(const char *name, size_t size,
 	inode->i_size = size;
 	clear_nlink(inode);
 
-	if (hugetlb_reserve_pages(inode, 0,
-			size >> huge_page_shift(hstate_inode(inode)), NULL,
-			acctflag) < 0)
+	if (hugetlb_reserve_pages(inode, 0, size >> PAGE_SHIFT, NULL, acctflag) < 0)
 		file = ERR_PTR(-ENOMEM);
 	else
 		file = alloc_file_pseudo(inode, mnt, name, O_RDWR,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a677ea774143..302f9cf9ef6b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6528,7 +6528,7 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
  */
 
 long hugetlb_reserve_pages(struct inode *inode,
-		long from, long to,
+		long from_idx, long to_idx,
 		struct vm_area_struct *vma,
 		vma_flags_t vma_flags)
 {
@@ -6538,14 +6538,21 @@ long hugetlb_reserve_pages(struct inode *inode,
 	struct resv_map *resv_map;
 	struct hugetlb_cgroup *h_cg = NULL;
 	long gbl_reserve, regions_needed = 0;
+	long from, to;
 	int err;
 
+	VM_WARN_ON(!IS_ALIGNED(from_idx, 1UL << huge_page_order(h)));
+	VM_WARN_ON(!IS_ALIGNED(to_idx,   1UL << huge_page_order(h)));
+
 	/* This should never happen */
-	if (from > to) {
+	if (from_idx > to_idx) {
 		VM_WARN(1, "%s called with a negative range\n", __func__);
 		return -EINVAL;
 	}
 
+	from = from_idx >> huge_page_order(h);
+	to = to_idx >> huge_page_order(h);
+
 	/*
 	 * vma specific semaphore used for pmd sharing and fault/truncation
 	 * synchronization
@@ -6715,14 +6722,20 @@ long hugetlb_reserve_pages(struct inode *inode,
 	return err;
 }
 
-long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
-								long freed)
+long hugetlb_unreserve_pages(struct inode *inode, long start_idx,
+			     long end_idx, long freed)
 {
 	struct hstate *h = hstate_inode(inode);
 	struct resv_map *resv_map = inode_resv_map(inode);
 	long chg = 0;
 	struct hugepage_subpool *spool = subpool_inode(inode);
-	long gbl_reserve;
+	long gbl_reserve, start, end;
+
+	VM_WARN_ON(!IS_ALIGNED(start_idx, 1UL << huge_page_order(h)));
+	VM_WARN_ON(!IS_ALIGNED(end_idx,   1UL << huge_page_order(h)));
+
+	start = start_idx >> huge_page_order(h);
+	end = end_idx >> huge_page_order(h);
 
 	/*
 	 * Since this routine can be called in the evict inode path for all
diff --git a/mm/memfd.c b/mm/memfd.c
index 0b5e8f111b39..24fefb1d2761 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -79,22 +79,19 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t index)
 		 */
 		struct inode *inode = file_inode(memfd);
 		struct hstate *h = hstate_file(memfd);
-		pgoff_t idx;
+		pgoff_t next;
 		int err = -ENOMEM;
 		long nr_resv;
 
 		gfp_mask = htlb_alloc_mask(h);
 		gfp_mask &= ~(__GFP_HIGHMEM | __GFP_MOVABLE);
-		idx = index >> huge_page_order(h);
+		next = index + pages_per_huge_page(h);
 
-		nr_resv = hugetlb_reserve_pages(inode, idx, idx + 1, NULL, EMPTY_VMA_FLAGS);
+		nr_resv = hugetlb_reserve_pages(inode, index, next, NULL, EMPTY_VMA_FLAGS);
 		if (nr_resv < 0)
 			return ERR_PTR(nr_resv);
 
-		folio = alloc_hugetlb_folio_reserve(h,
-						    numa_node_id(),
-						    NULL,
-						    gfp_mask);
+		folio = alloc_hugetlb_folio_reserve(h, numa_node_id(), NULL, gfp_mask);
 		if (folio) {
 			u32 hash;
 
@@ -119,13 +116,8 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t index)
 			 */
 			hash = hugetlb_fault_mutex_hash(memfd->f_mapping, index);
 			mutex_lock(&hugetlb_fault_mutex_table[hash]);
-
-			err = hugetlb_add_to_page_cache(folio,
-							memfd->f_mapping,
-							index);
-
+			err = hugetlb_add_to_page_cache(folio, memfd->f_mapping, index);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
-
 			if (err) {
 				folio_put(folio);
 				goto err_unresv;
@@ -137,7 +129,7 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t index)
 		}
 err_unresv:
 		if (nr_resv > 0)
-			hugetlb_unreserve_pages(inode, idx, idx + 1, 0);
+			hugetlb_unreserve_pages(inode, index, next, 0);
 		return ERR_PTR(err);
 	}
 #endif
-- 
2.43.5


