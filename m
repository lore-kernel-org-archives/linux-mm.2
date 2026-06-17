Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88C45CD98F2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 17:26:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DA6D6B009E; Wed, 17 Jun 2026 13:26:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B3026B009F; Wed, 17 Jun 2026 13:26:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A0CA6B00A0; Wed, 17 Jun 2026 13:26:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D1C866B009E
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:26:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 45B931C47EC
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:26:30 +0000 (UTC)
X-FDA: 84890083740.01.5C7EDCA
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3132020006
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:26:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DHT4wvRH;
	spf=pass (imf13.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781717188;
	b=QFFJHRJ5Blf3cJoqsA3XLV84fiy//6TCNsfUAY+Fbv12ShM7A413CT8srGVbD1SI0CGCSg
	c1DT22iYu9pbH9TdIN3ocewCG816iDcdjT8f9viNF8vFZb+OBwVXqa5QlKaIi6UD3zPyqz
	239yUQ9Jsnl8+SEHa6QsQM7n/5GhB0s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DHT4wvRH;
	spf=pass (imf13.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781717188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T0b31SaJavgiXnLsuRPpNulQ6VPeUt582qsp2XUNt2A=;
	b=TSLXZbr8ZGXp8dbrj1dIoySCicFsQIJSg7+RgEfW7YxOJpTMKU9NHXttLAH3xhFStrj6Hm
	FFm6BpqPoRLqvnAKOpDbs3QwYYOP3TnDaVqNDCo4rvLBQhTkDF1ARaUIzHDdMKWrDCIz1N
	2JNmxckt5Ctr11DnlrwPFRZHuTffJTI=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65HEsWed2367981;
	Wed, 17 Jun 2026 17:26:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=T0b31
	SaJavgiXnLsuRPpNulQ6VPeUt582qsp2XUNt2A=; b=DHT4wvRHKkxrUlFB2xrMM
	QVPuYSYQId3bWieYe2QwfiDdaVdKLnrog2zHlXAmIXvtUOWcNMSdfbajWXbqDWvU
	d6wP9KaBhKoMXbpQAG+eLkm5Vlo+PzXmkAcukCWucOahen53YVjGuEpdPQ5LFRX5
	3R9dKX5FG6ybGhiwNIYJJ4weFUHSfMZHwIle/AYSX6BUidpWzLpUCkfTsg58m1Su
	p+0+JJ7wRnogQhPvHkxDg5lw+62KJF+Wo5KtzG41LGBXiqevuVXMWmFMkdfm9X0S
	kEboK09YGXKaLX3N19FR3l3Ldbu2KWELFUuwtxdlPE30US/C34DVhm9wxA1o5iJW
	w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4eueg31c46-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Jun 2026 17:26:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65HHNVP2003778;
	Wed, 17 Jun 2026 17:26:15 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4eudvc0wgy-9;
	Wed, 17 Jun 2026 17:26:15 +0000 (GMT)
From: Jane Chu <jane.chu@oracle.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org, jack@suse.cz, viro@zeniv.linux.org.uk,
        brauner@kernel.org, muchun.song@linux.dev, osalvador@suse.de,
        david@kernel.org, hughd@google.com, baolin.wang@linux.alibaba.com,
        linmiaohe@huawei.com, nao.horiguchi@gmail.com, lorenzo@kernel.org,
        rppt@kernel.org, peterx@redhat.com, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 08/11] hugetlb: make hugetlb_add_to_page_cache() to take PAGE_SIZE granularity index
Date: Wed, 17 Jun 2026 11:25:29 -0600
Message-ID: <20260617172534.1740152-9-jane.chu@oracle.com>
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
X-Authority-Analysis: v=2.4 cv=I8VVgtgg c=1 sm=1 tr=0 ts=6a32d8b8 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=6hqxnK0FYYJkgnx9CnEA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12312
X-Proofpoint-GUID: c6fJcCKQPcH4ykaQHO81XkY-RL7sM08D
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE3MDE2OCBTYWx0ZWRfX4YV2MEW3kFCl
 X9uiFQ5e7AJpE56y2TdmL8weakmf60nGsdkEu2N/cMyRWTPhWwJC4ja9He3WgHPMR2NgA+WY0vs
 GTCNfCylWnWm2japP+xlb2Anaj3588k/+v8oRO8gWkD4hKWfXgFXxktUD/VVuVUNsCPhziywj26
 7K9MlBvCNI4BoxKpgrpbXfvWeUk6rszXPCs3hAYef4DVcnE15EiSYXD0mFzqLNpvkfY6RdS73xr
 oh6PgT9pIBzpwy+XvE6E3ijyLUr0KgWNsTpZnf+U/s+9dOhgBKIyjon8ypKyvj1t2ZVCp9RdJ7L
 X5X9wRlAfVqtCuSMINKPlX+B6fzk7F3Bg6axZBZznjVdC/4ow3ATvr120vsWbna/bAOA5eYFBhx
 Tkaq4rD8TI1coVHNQbjzUS1NY9dm/+UQ3AUuRMTDX5puhOii9kAQOahEAqHHJ5np0KAJQ40/YQA
 wOltet/jsx9JSJEdcNYek/vGgTnITd/XBaJH3tI8=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE3MDE2OCBTYWx0ZWRfX1uuRuX/y+705
 VNvakMN+FKoDwh0FChBgzjL6YTJFDJdjKbyl+ytlqZXkiH5/eYlrDSg2OqdLH5acKgAMY91Vlpy
 WLiQnecVAGz8mtChsd39e9L0ihSndw3dxXYNndCVwvGrfw1mdQ2M
X-Proofpoint-ORIG-GUID: c6fJcCKQPcH4ykaQHO81XkY-RL7sM08D
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3132020006
X-Rspam-User: 
X-Stat-Signature: 7rfu5i1qkw88ft67f7thuh81icub11h9
X-HE-Tag: 1781717187-738570
X-HE-Meta: U2FsdGVkX1/w2qm20a4pOjjUKsWGMpLfUb6hLucuvz3J39ka1LAhm7AqP8WjFqU48/TGAeO2bNOVfk2nZDYUJ1hY3TUttK082mBCZ2feXQ3guW7y+YctW6DlHLLcqrAoPRW2cRcZc3+b/CG5+sOTPwaqApU08eqffJ7IB2QiP6LahZutSpC/Tw8pH44MeA3G2hwzMgUe2zgYD7LWV60O+A3gXyRfIbgJntW+l3tL0T3pgL6H/xpad6iPfRu33SRy1qu2eXuK86DUtKk8aU3iaoCQ7Lg/4u2ol4qxBpMumeVf+TD89sytZlWPXCLbwp06O1pL9vVT7SZjz3J7X4t8B62NM4+IsM5u3YXg6m1Qgmj5zapEBJzRtxB1ZLtpmrn7x0MKpBPCv4pPbfgLV1MiFWjtevue/vVpTyqYP/kyGQigGROz2PH2nZSGyAg2WjNn9jfmPLG+sOHJIlYH1NkszCXDXcTGGmH0LuBETWc4bxTZDSl8Swfxy7zSl2qxUCWSAmGAbvkiG47sye2TiCVr/O/a2/3l7T+OckZSwrY0Yt2HPscT+hwsQ7MzgBDq7AOIbi0WP3mrGqq9EpNiqGl8PBBgrqRPs6TTOoUHCxfKew883rLYU44d4jFA/FUOm92bfYNi3PaFox/j6jJmNPAwBEcQo0dqRLELY/NuLvJtDFosJ+9vkfUsIekULKz8z5USJ+hxn7GrT04EhUzmhkLyVqYq2POIBeYHsjO2MF0wa2FjBHTufaRuZ2AWU55mpxy27gdVALD8Q7AC3yXUVesyhwrp34rZDZkPUvjWgGBDKRqsw4MobzY+816WHRWZ7jN3iSWm+oFuYppGvFegWYgiifZBxC1TeFz7W8afDJ9KqpPuYz5ffnoBpXB2ShGsFliRLfrRzS0/TtfUMxFNLJ2VUXYk3uXmtgvGwXnc5aY7POKt1oHSSiyuWTbrHdZ/J95W5v3C3ci0c4//NpVs0Ux
 Mpiydewj
 dmDRCPctMbBKqcFWBIADPJe934Ac7AItUxTuDrwv/4bAygfIdMieY+uYLozAat7Q4b4x75157Qc0dK9OebgeSBvHJC9O+pOyrirPSYMepgl2Hq4aNO8uGYlkRDUK+HQUHaJDgOGypWTsKfQO8B5kEuUPc8JgzS255OURsS/QIQCoKTMw3n5qEgXHpZRBqVpkwbLtr622nqp6kPk+s/tMppa/JpmvD12RZh/qatrmFzHvbQ0VF+xp/gYA+YFx7Ngln6qB6HkeO8QlEAzRhb0PFW+rpW77fBWh9PnXuiXrz5dhUtkYlZIgICbe/guiEriMSNND4gyY39Y6c/tJB9Z0BUGpObEUs+ZV/kVTH7o/9PvaEuP8XgWqLWJDbMzCtlXb13Ov0LUq3X5dx+WI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hugetlb_add_to_page_cache() is partly a wrapper of the generic
__filemap_add_folio() that takes in PAGE_SIZE granularity index,
hence make it consistent by taking PAGE_SIZE granularity index
as well.

Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 fs/hugetlbfs/inode.c | 13 ++++++++-----
 mm/hugetlb.c         | 18 +++++++++---------
 mm/memfd.c           |  2 +-
 3 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 6c883478f7e7..0b49a79efb08 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -599,7 +599,7 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 	struct mm_struct *mm = current->mm;
 	loff_t hpage_size = huge_page_size(h);
 	unsigned long hpage_shift = huge_page_shift(h);
-	pgoff_t start, index, end;
+	pgoff_t start, idx, end;
 	int error;
 	u32 hash;
 
@@ -639,7 +639,9 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 	vm_flags_init(&pseudo_vma, VM_HUGETLB | VM_MAYSHARE | VM_SHARED);
 	pseudo_vma.vm_file = file;
 
-	for (index = start; index < end; index++) {
+	for (idx = start; idx < end; idx++) {
+		pgoff_t index = idx << huge_page_order(h);
+
 		/*
 		 * This is supposed to be the vaddr where the page is being
 		 * faulted in, but we have no vaddr here.
@@ -659,14 +661,14 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 		}
 
 		/* addr is the offset within the file (zero based) */
-		addr = index * hpage_size;
+		addr = idx * hpage_size;
 
 		/* mutex taken here, fault path and hole punch */
-		hash = hugetlb_fault_mutex_hash(mapping, index << huge_page_order(h));
+		hash = hugetlb_fault_mutex_hash(mapping, index);
 		mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 		/* See if already present in mapping to avoid alloc/free */
-		folio = filemap_get_folio(mapping, index << huge_page_order(h));
+		folio = filemap_get_folio(mapping, index);
 		if (!IS_ERR(folio)) {
 			folio_put(folio);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
@@ -690,6 +692,7 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 		folio_zero_user(folio, addr);
 		__folio_mark_uptodate(folio);
 		error = hugetlb_add_to_page_cache(folio, mapping, index);
+
 		if (unlikely(error)) {
 			restore_reserve_on_error(h, &pseudo_vma, addr, folio);
 			folio_put(folio);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 5484e78fe72e..b41e7b8df094 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5621,15 +5621,14 @@ bool hugetlbfs_pagecache_present(struct hstate *h,
 }
 
 int hugetlb_add_to_page_cache(struct folio *folio, struct address_space *mapping,
-			   pgoff_t idx)
+			   pgoff_t index)
 {
 	struct inode *inode = mapping->host;
 	struct hstate *h = hstate_inode(inode);
 	int err;
 
-	idx <<= huge_page_order(h);
 	__folio_set_locked(folio);
-	err = __filemap_add_folio(mapping, folio, idx, GFP_KERNEL, NULL);
+	err = __filemap_add_folio(mapping, folio, index, GFP_KERNEL, NULL);
 
 	if (unlikely(err)) {
 		__folio_clear_locked(folio);
@@ -5696,7 +5695,6 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 	struct folio *folio;
 	unsigned long size;
 	pte_t new_pte;
-	pgoff_t idx = vmf->pgoff >> huge_page_order(h);
 
 	/*
 	 * Currently, we are forced to kill the process in the event the
@@ -5779,7 +5777,8 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 		new_folio = true;
 
 		if (vma->vm_flags & VM_MAYSHARE) {
-			int err = hugetlb_add_to_page_cache(folio, mapping, idx);
+			int err = hugetlb_add_to_page_cache(folio, mapping, vmf->pgoff);
+
 			if (err) {
 				/*
 				 * err can't be -EEXIST which implies someone
@@ -6170,7 +6169,8 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 	bool wp_enabled = (flags & MFILL_ATOMIC_WP);
 	struct hstate *h = hstate_vma(dst_vma);
 	struct address_space *mapping = dst_vma->vm_file->f_mapping;
-	pgoff_t idx = vma_hugecache_offset(h, dst_vma, dst_addr);
+	pgoff_t index = linear_page_index(dst_vma, dst_addr);
+
 	unsigned long size = huge_page_size(h);
 	int vm_shared = dst_vma->vm_flags & VM_SHARED;
 	pte_t _dst_pte;
@@ -6201,7 +6201,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 
 	if (is_continue) {
 		ret = -EFAULT;
-		folio = filemap_lock_folio(mapping, idx << huge_page_order(h));
+		folio = filemap_lock_folio(mapping, index);
 		if (IS_ERR(folio))
 			goto out;
 		folio_in_pagecache = true;
@@ -6297,7 +6297,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 	/* Add shared, newly allocated pages to the page cache. */
 	if (vm_shared && !is_continue) {
 		ret = -EFAULT;
-		if (idx >= (i_size_read(mapping->host) >> huge_page_shift(h)))
+		if (index >= (i_size_read(mapping->host) >> PAGE_SHIFT))
 			goto out_release_nounlock;
 
 		/*
@@ -6306,7 +6306,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 		 * hugetlb_fault_mutex_table that here must be hold by
 		 * the caller.
 		 */
-		ret = hugetlb_add_to_page_cache(folio, mapping, idx);
+		ret = hugetlb_add_to_page_cache(folio, mapping, index);
 		if (ret)
 			goto out_release_nounlock;
 		folio_in_pagecache = true;
diff --git a/mm/memfd.c b/mm/memfd.c
index b0ec0b12b98d..0b5e8f111b39 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -122,7 +122,7 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t index)
 
 			err = hugetlb_add_to_page_cache(folio,
 							memfd->f_mapping,
-							idx);
+							index);
 
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 
-- 
2.43.5


