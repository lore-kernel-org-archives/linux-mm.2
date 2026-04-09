Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6DDFF36B98
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 23:42:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 256E46B0096; Thu,  9 Apr 2026 19:42:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B9036B0099; Thu,  9 Apr 2026 19:42:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2F0F6B0096; Thu,  9 Apr 2026 19:42:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D9C416B0096
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 19:42:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A82031B7250
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 23:42:27 +0000 (UTC)
X-FDA: 84640643934.27.D904942
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id A6CD34000A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 23:42:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PBqSoxgi;
	spf=pass (imf11.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775778145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fYPIQ1U7Ld2xaMJDsHcFPHGnifsy5elZ8+3aWycdz08=;
	b=fqmDY6HsU9taoqX3N1LLbtcITJ+Nk1TibfYcw2FmCPpVgdIRm121vTZp4YZOnRI2gKiB4v
	aIE25MKhMYcWpkZ+jDz2NNDvNPk/lRtuoqlKuCBeBL6eLe3OfqEo9HNgn39oqUqVfUiDRR
	+a8K0w0lOAQu7aUXg+7AwnKS0We4yRM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775778145; a=rsa-sha256;
	cv=none;
	b=d8Ojhbd2UAkps1PW7TahZReUsaxVvV8tBsj1ITIhhagrLut7SFye/yLWWZ7PwLFwzaa1JI
	INc36dsuiGHJGcMMMMOAx747j/euk3VQurkaA48oXNe1kRgct8x/5XvpA7eZ0fN7oQMtlU
	l90QNDV/bD9SB41VdbpCjyEJwbDnzKE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PBqSoxgi;
	spf=pass (imf11.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639JtX7I2413207;
	Thu, 9 Apr 2026 23:42:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=fYPIQ
	1U7Ld2xaMJDsHcFPHGnifsy5elZ8+3aWycdz08=; b=PBqSoxgiAv/W4eg8i7GcB
	TkVGYw2eN3H9Q2lceHz862Qx+1Ldl7K8ZSQD8uD7P68S8l3H++Nf9+2c5/H00iDA
	nviQoLKLVL4KGxpWXBz4UBLgddtAvPqJTYrwW43176IYGae7ibA2vr7r6X5Oif4X
	lM8Oe4Y9tohidTZ1BYaQVrLyr83gjbEXnuHgLvjbVG5Rm+oXq4b3KJjINwPbYmUH
	2mWxeJ0wHFgF78HANUiOeoR8rg6TYMIRMr+e/ste2aqOF87D6NlLvHggMxZ3addD
	U8DKwWt2nqBa5YCvzACiLy1fmBTMAvhZc8+IxQkedkD+R8qq52e8RDklMFRswy6i
	A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqa8rv3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 23:42:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 639NYFlE040148;
	Thu, 9 Apr 2026 23:42:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dcmnbj4v1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 23:42:20 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 639Ng6Yx038323;
	Thu, 9 Apr 2026 23:42:19 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4dcmnbj4pp-7;
	Thu, 09 Apr 2026 23:42:19 +0000
From: Jane Chu <jane.chu@oracle.com>
To: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev,
        osalvador@suse.de
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
        rppt@kernel.org, surenb@google.com, mhocko@suse.com, corbet@lwn.net,
        skhan@linuxfoundation.org, hughd@google.com,
        baolin.wang@linux.alibaba.com, peterx@redhat.com, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] hugetlb: pass hugetlb reservation ranges in base-page indices
Date: Thu,  9 Apr 2026 17:41:57 -0600
Message-ID: <20260409234158.837786-7-jane.chu@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260409234158.837786-1-jane.chu@oracle.com>
References: <20260409234158.837786-1-jane.chu@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_04,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 spamscore=0
 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604090218
X-Proofpoint-GUID: gizZC3m12z3s0TgPBjgQGNn9DGqTa4M0
X-Proofpoint-ORIG-GUID: gizZC3m12z3s0TgPBjgQGNn9DGqTa4M0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDIxOSBTYWx0ZWRfX8zuw29s5+sF+
 nuEpDRQCmz+JStfiqtO4ZM8tvUp+4b8nP7tI++/AJV6Au0mVjTYCmNJy9pZrs0b8/0tPye3poFr
 dpxri/ImgBVE4yw6LSfRqKa3uPvdCytkherMgiJ9bme/RQnTT4MsquSlgH1p3B6PdQDmstn4y8s
 RsUtiUwQof8Xoz9GPaRnX6GXTtqSChZwTPS1H91zV5sNIjWv49JOQiCCwHiouEScrB7dS6iGbd4
 0bLtgflyjlM3cc2J6yvIx/X6o9b9wBOmFnwE7Bnd9eojQQbL6eqYjUbqmmTeMS2thsB0Mb53WKr
 h9HMU2KKGMQwimMP3GVzu8r2PYQxklpYBm+x3dLDt2azUb3q9CuDNH9/I9ia8urQdCdFRyvhrc+
 iGVFN1w1cwSKrTkEjooJlvwEO0nmpSzTNXJcYJURaDB86jtOjsyMl+FyU3zMzcVMeOOKyGLnSFY
 54racietM+HAWJFwpfg==
X-Authority-Analysis: v=2.4 cv=DLS/JSNb c=1 sm=1 tr=0 ts=69d8395c b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=T4oJmI3Qyo7CCk0tri4A:9
X-Rspamd-Queue-Id: A6CD34000A
X-Stat-Signature: rm7gqu4mi9srriqe8bexzbu3t5xe8u66
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775778145-473643
X-HE-Meta: U2FsdGVkX1+1BgfbwYa9yZk1AMZs2RDWVDxpQ6iI1XzV+lc20E2ULaN5xeKJaqGZBuLs3rBdhWpTE7Fa5Qui1HJzuNFv+NkXp3bWA3bwaHThdyXDSUeyENwqxsAUUp9YkG70BgTXJFk3l0AFSf/0S8Ygh0OhqON2PC/hypa46knLv6f9RtBUngp+29KCstMDrntTlBQuIna7tEXgvvTfaD6AMJGZ23x+avPfCPLnyYqnxPrmOSfbZ6acR/M31eLKvYk6Qe6okuSb1PZJckoiAGxq52LPWC6YhseaTsWavgD6BqRtId04dUtLxnu7PZIiAFAaBb9DlYRnRPQXnOZlX5jCXwOezYHTtAJ3WnxkRBzRwjbgnj4p/nqkBr5+erCPynmJ778X6gBedw3B2IZdjGDDad19W1C2x2h8ymheasaeFwWZvhkgSrdEDkZYLnEahwDVAnTmjE9znSjOxGhX/x6nMVX9/8RWyWQ/KK+2r4nsIkGtyWn2JoGUQDqhmENiKVTXGU1cXUH586QzIGW2PjzYr03dh3okLTMKr9+GzM3X2caYlwVmmzIrxUhMu8wDhWce+Ctv4n9HNtkSMBUtJ0XO0h4LNI2siN3+C6zSuiiR7LiMxMfbrXtuXQdtrZr/rHKOqKxkB3thImtsO6wUIOkTuFqfP7RL4F6+PRihXGMGC0IUEHfcIcy/94RhUa4zeBr2g6N169CuoN224r/6gC5bn2S5qFkXHBhkh3BTccUw+x7dviEhyZAY7RngY3EK2hYcVnk+7MIBAKmMnwAi49TSscsjWAXi5L3g7FkgRS9jiUlk7SB2k9Y/1IRrSIS2VQX7kFzgBEqntgfyb7LCR53mZPAJQVVRqsOyTUcZrr/a+QdJ+mK6/nh83Yc8r7QOK7MTy0kC9B4e6X3MdaOg9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hugetlb_reserve_pages() consume indices in hugepage granularity although
some callers naturally compute offsets in PAGE_SIZE units.

Teach the reservation helpers to accept base-page index ranges and
convert to hugepage indices internally before operating on the
reservation map. This keeps the internal representation unchanged while
making the API contract more uniform for callers.

Update hugetlbfs and memfd call sites to pass base-page indices, and
adjust the documentation to describe the new calling convention. Add
alignment warnings in hugetlb_reserve_pages() to catch invalid ranges
early.

No functional changes.

Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 Documentation/mm/hugetlbfs_reserv.rst | 12 +++++------
 fs/hugetlbfs/inode.c                  | 29 ++++++++++++---------------
 mm/hugetlb.c                          | 26 ++++++++++++++++--------
 mm/memfd.c                            |  9 +++++----
 4 files changed, 42 insertions(+), 34 deletions(-)

diff --git a/Documentation/mm/hugetlbfs_reserv.rst b/Documentation/mm/hugetlbfs_reserv.rst
index a49115db18c7..60a52b28f0b4 100644
--- a/Documentation/mm/hugetlbfs_reserv.rst
+++ b/Documentation/mm/hugetlbfs_reserv.rst
@@ -112,8 +112,8 @@ flag was specified in either the shmget() or mmap() call.  If NORESERVE
 was specified, then this routine returns immediately as no reservations
 are desired.
 
-The arguments 'from' and 'to' are huge page indices into the mapping or
-underlying file.  For shmget(), 'from' is always 0 and 'to' corresponds to
+The arguments 'from' and 'to' are base page indices into the mapping or
+underlying file. For shmget(), 'from' is always 0 and 'to' corresponds to
 the length of the segment/mapping.  For mmap(), the offset argument could
 be used to specify the offset into the underlying file.  In such a case,
 the 'from' and 'to' arguments have been adjusted by this offset.
@@ -136,10 +136,10 @@ to indicate this VMA owns the reservations.
 
 The reservation map is consulted to determine how many huge page reservations
 are needed for the current mapping/segment.  For private mappings, this is
-always the value (to - from).  However, for shared mappings it is possible that
-some reservations may already exist within the range (to - from).  See the
-section :ref:`Reservation Map Modifications <resv_map_modifications>`
-for details on how this is accomplished.
+always the number of huge pages covered by the range [from, to).  However,
+for shared mappings it is possible that some reservations may already exist
+within the range [from, to).  See the section :ref:`Reservation Map Modifications
+<resv_map_modifications>` for details on how this is accomplished.
 
 The mapping may be associated with a subpool.  If so, the subpool is consulted
 to ensure there is sufficient space for the mapping.  It is possible that the
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index a72d46ff7980..ec05ed30b70f 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -157,10 +157,8 @@ static int hugetlbfs_file_mmap_prepare(struct vm_area_desc *desc)
 	if (inode->i_flags & S_PRIVATE)
 		vma_flags_set(&vma_flags, VMA_NORESERVE_BIT);
 
-	if (hugetlb_reserve_pages(inode,
-			desc->pgoff >> huge_page_order(h),
-			len >> huge_page_shift(h), desc,
-			vma_flags) < 0)
+	if (hugetlb_reserve_pages(inode, desc->pgoff, len >> PAGE_SHIFT, desc,
+				  vma_flags) < 0)
 		goto out;
 
 	ret = 0;
@@ -408,8 +406,8 @@ static void hugetlb_unmap_file_folio(struct hstate *h,
 	unsigned long v_end;
 	pgoff_t start, end;
 
-	start = index * pages_per_huge_page(h);
-	end = (index + 1) * pages_per_huge_page(h);
+	start = index;
+	end = start + pages_per_huge_page(h);
 
 	i_mmap_lock_write(mapping);
 retry:
@@ -518,6 +516,8 @@ static void remove_inode_single_folio(struct hstate *h, struct inode *inode,
 		struct address_space *mapping, struct folio *folio,
 		pgoff_t index, bool truncate_op)
 {
+	pgoff_t next_index;
+
 	/*
 	 * If folio is mapped, it was faulted in after being
 	 * unmapped in caller or hugetlb_vmdelete_list() skips
@@ -540,8 +540,9 @@ static void remove_inode_single_folio(struct hstate *h, struct inode *inode,
 	VM_BUG_ON_FOLIO(folio_test_hugetlb_restore_reserve(folio), folio);
 	hugetlb_delete_from_page_cache(folio);
 	if (!truncate_op) {
+		next_index = index + pages_per_huge_page(h);
 		if (unlikely(hugetlb_unreserve_pages(inode, index,
-							index + 1, 1)))
+						     next_index, 1)))
 			hugetlb_fix_reserve_counts(inode);
 	}
 
@@ -575,7 +576,7 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
 	struct address_space *mapping = &inode->i_data;
 	const pgoff_t end = lend >> PAGE_SHIFT;
 	struct folio_batch fbatch;
-	pgoff_t next, idx;
+	pgoff_t next;
 	int i, freed = 0;
 	bool truncate_op = (lend == LLONG_MAX);
 
@@ -592,9 +593,8 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
 			/*
 			 * Remove folio that was part of folio_batch.
 			 */
-			idx = folio->index >> huge_page_order(h);
 			remove_inode_single_folio(h, inode, mapping, folio,
-						  idx, truncate_op);
+						  folio->index, truncate_op);
 			freed++;
 
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
@@ -604,9 +604,8 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
 	}
 
 	if (truncate_op)
-		(void)hugetlb_unreserve_pages(inode,
-				lstart >> huge_page_shift(h),
-				LONG_MAX, freed);
+		(void)hugetlb_unreserve_pages(inode, lstart >> PAGE_SHIFT,
+					      LONG_MAX, freed);
 }
 
 static void hugetlbfs_evict_inode(struct inode *inode)
@@ -1561,9 +1560,7 @@ struct file *hugetlb_file_setup(const char *name, size_t size,
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
index 47ef41b6fb2e..eb4ab5bd0c9f 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6532,10 +6532,11 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 }
 
 /*
- * Update the reservation map for the range [from, to].
+ * Update the reservation map for the range [from, to) where 'from' and 'to'
+ * are base-page indices that are expected to be huge page aligned.
  *
- * Returns the number of entries that would be added to the reservation map
- * associated with the range [from, to].  This number is greater or equal to
+ * Returns the number of huge pages that would be added to the reservation map
+ * associated with the range [from, to).  This number is greater or equal to
  * zero. -EINVAL or -ENOMEM is returned in case of any errors.
  */
 
@@ -6550,6 +6551,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 	struct resv_map *resv_map;
 	struct hugetlb_cgroup *h_cg = NULL;
 	long gbl_reserve, regions_needed = 0;
+	long from_idx, to_idx;
 	int err;
 
 	/* This should never happen */
@@ -6558,6 +6560,12 @@ long hugetlb_reserve_pages(struct inode *inode,
 		return -EINVAL;
 	}
 
+	VM_WARN_ON(!IS_ALIGNED(from, 1UL << huge_page_order(h)));
+	VM_WARN_ON(!IS_ALIGNED(to,   1UL << huge_page_order(h)));
+
+	from_idx = from >> huge_page_order(h);
+	to_idx = to >> huge_page_order(h);
+
 	/*
 	 * Only apply hugepage reservation if asked. At fault time, an
 	 * attempt will be made for VM_NORESERVE to allocate a page
@@ -6580,7 +6588,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 		 */
 		resv_map = inode_resv_map(inode);
 
-		chg = region_chg(resv_map, from, to, &regions_needed);
+		chg = region_chg(resv_map, from_idx, to_idx, &regions_needed);
 	} else {
 		/* Private mapping. */
 		resv_map = resv_map_alloc();
@@ -6589,7 +6597,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 			goto out_err;
 		}
 
-		chg = to - from;
+		chg = to_idx - from_idx;
 
 		set_vma_desc_resv_map(desc, resv_map);
 		set_vma_desc_resv_flags(desc, HPAGE_RESV_OWNER);
@@ -6644,7 +6652,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 	 * else has to be done for private mappings here
 	 */
 	if (!desc || vma_desc_test(desc, VMA_MAYSHARE_BIT)) {
-		add = region_add(resv_map, from, to, regions_needed, h, h_cg);
+		add = region_add(resv_map, from_idx, to_idx, regions_needed, h, h_cg);
 
 		if (unlikely(add < 0)) {
 			hugetlb_acct_memory(h, -gbl_reserve);
@@ -6712,7 +6720,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 		 * region_add failed or didn't run.
 		 */
 		if (chg >= 0 && add < 0)
-			region_abort(resv_map, from, to, regions_needed);
+			region_abort(resv_map, from_idx, to_idx, regions_needed);
 	if (desc && is_vma_desc_resv_set(desc, HPAGE_RESV_OWNER)) {
 		kref_put(&resv_map->refs, resv_map_release);
 		set_vma_desc_resv_map(desc, NULL);
@@ -6728,13 +6736,15 @@ long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
 	long chg = 0;
 	struct hugepage_subpool *spool = subpool_inode(inode);
 	long gbl_reserve;
+	long start_idx = start >> huge_page_order(h);
+	long end_idx = end >> huge_page_order(h);
 
 	/*
 	 * Since this routine can be called in the evict inode path for all
 	 * hugetlbfs inodes, resv_map could be NULL.
 	 */
 	if (resv_map) {
-		chg = region_del(resv_map, start, end);
+		chg = region_del(resv_map, start_idx, end_idx);
 		/*
 		 * region_del() can fail in the rare case where a region
 		 * must be split and another region descriptor can not be
diff --git a/mm/memfd.c b/mm/memfd.c
index 56c8833c4195..59c174c7533c 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -80,14 +80,15 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t index)
 		struct inode *inode = file_inode(memfd);
 		struct hstate *h = hstate_file(memfd);
 		long nr_resv;
-		pgoff_t idx;
+		pgoff_t next_index;
 		int err = -ENOMEM;
 
 		gfp_mask = htlb_alloc_mask(h);
 		gfp_mask &= ~(__GFP_HIGHMEM | __GFP_MOVABLE);
-		idx = index >> huge_page_order(h);
+		next_index = index + pages_per_huge_page(h); 
 
-		nr_resv = hugetlb_reserve_pages(inode, idx, idx + 1, NULL, EMPTY_VMA_FLAGS);
+		nr_resv = hugetlb_reserve_pages(inode, index, next_index, NULL,
+						EMPTY_VMA_FLAGS);
 		if (nr_resv < 0)
 			return ERR_PTR(nr_resv);
 
@@ -137,7 +138,7 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t index)
 		}
 err_unresv:
 		if (nr_resv > 0)
-			hugetlb_unreserve_pages(inode, idx, idx + 1, 0);
+			hugetlb_unreserve_pages(inode, index, next_index, 0);
 		return ERR_PTR(err);
 	}
 #endif
-- 
2.43.5


