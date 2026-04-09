Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD8C6F36B97
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 23:42:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EF456B0095; Thu,  9 Apr 2026 19:42:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22D266B0096; Thu,  9 Apr 2026 19:42:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB1206B0098; Thu,  9 Apr 2026 19:42:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DA6866B0095
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 19:42:25 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9B93C8AB86
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 23:42:25 +0000 (UTC)
X-FDA: 84640643850.29.22CD906
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 58B0C100006
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 23:42:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Fl0Za/t0";
	spf=pass (imf14.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775778143; a=rsa-sha256;
	cv=none;
	b=CsVGRCL/OfzbWc70OMf62saQqzUhw8dbyEBqUp8iCPxQFgdMbCBqzjL7LGkidM1JfdcMkJ
	MDmt+XUa9FQpGxyDJJ+iz2PMq40Vw126CWlVBjCzA7wAI5vlLqSIJl75wxj8EUBoF8Jck6
	vulCBjJh0J12jJtQM+vIeEW/6VAuDbE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775778143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7/YeO55zBShWw0m6/Q0RzWzikYUqSC2B3NvyzRTPhQI=;
	b=TrA0qzTi4HJzQDjeSSjvGMU35eSWs16H9X+8RmE8qp2scRkQ0/0vR0tvCDIBHZHkZ35/X4
	5oGxwmhVmbi8hqJuRMIPx4oOX9VaU7oX2wNxBlRHyPcr3qUPEvr171+o7G93pmIdDA9oXU
	Kc5GzfgLRwGnXwgt1DmUjhW0cdgQp7I=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Fl0Za/t0";
	spf=pass (imf14.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639JtpEN3523147;
	Thu, 9 Apr 2026 23:42:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=7/YeO
	55zBShWw0m6/Q0RzWzikYUqSC2B3NvyzRTPhQI=; b=Fl0Za/t02xN2YUotd42qL
	ox46gAfI+yBOtuBqLZ/bJjlSesIg+i5tcvy1Mvro7XKivA9BGi/2dDbZGndtsarb
	mK7n2hzHK0+qsnIZwsZVi1EBWUec2VuKrq0rvKjgb+sLiIKpCPMRNsRBkqjtleVX
	bYCdAxAfmrYGQoapZ3q11kdjsXXyO7QTMpZ0veh9e0tbpKiKtslWfl0ypgB7xVlu
	SUWDrUK+qj60xCmdeX+gQD2y5PXhpF0OfVFGa7701mBd+nJWJcpEQv64s2Q6RPud
	cnovi6LF1Oncx8R5cUsxk6PBznHEzbc+VAZkJhB8ycyDxH7yD3w3xmziF9pKdCw7
	A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqb0pww-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 23:42:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 639LUgw9040070;
	Thu, 9 Apr 2026 23:42:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dcmnbj4u4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 23:42:17 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 639Ng6Yv038323;
	Thu, 9 Apr 2026 23:42:17 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4dcmnbj4pp-6;
	Thu, 09 Apr 2026 23:42:17 +0000
From: Jane Chu <jane.chu@oracle.com>
To: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev,
        osalvador@suse.de
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
        rppt@kernel.org, surenb@google.com, mhocko@suse.com, corbet@lwn.net,
        skhan@linuxfoundation.org, hughd@google.com,
        baolin.wang@linux.alibaba.com, peterx@redhat.com, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] hugetlb: make hugetlb_add_to_page_cache() use PAGE_SIZE-based index
Date: Thu,  9 Apr 2026 17:41:56 -0600
Message-ID: <20260409234158.837786-6-jane.chu@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDIxOSBTYWx0ZWRfX8dKZ2E/QAzl5
 SQlYdozwDiY7LwLRv7xnDAd6lG58vEJztmZPfQvlVphf77OzMWvVEcXotr7GNKecRE18NAEZNcO
 o+qQG/ihqJwt2BUZFadJZFPZSgDVUACLUPnlZjlGpqZP00hUb1ap4rxbP3AciJ9WTr9+HIv1qYd
 SvSO9j1JhLkB9tXA8wE4J4lToCzSTxIADZ8AmydZvlDM7lglZMRVUst65E/5OrSuaJwPnZKYQmk
 d43sNSNN661KF2cmkTGuGZ6YKmDL7ComuianEkzbRAuaPSUUzKmt/z9+gSiUIqNKOzGsoQaoJhm
 XdhColR/FO6aF9UNNL7FLDfTbXtoXyhp9uD4fGx7adBqhfLGGT9r/CtyYHW6ZE9zvL+33YbN6Dc
 sMpEaqQjuN5EVCfX5jpFSCR/ShfmID2s+F/DwLdu6FZ8TwRmTofBZqSPGbfp4iqwm6SC/IQHPnR
 8DZbblYmbRIM6U3AJIQ==
X-Proofpoint-GUID: LD18qP1N6MZncW_-3J04GyHwgy_6kl_V
X-Authority-Analysis: v=2.4 cv=Oux/DS/t c=1 sm=1 tr=0 ts=69d8395a b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yPCof4ZbAAAA:8 a=1ymFs0xJ_oQ9W5YhXmYA:9
X-Proofpoint-ORIG-GUID: LD18qP1N6MZncW_-3J04GyHwgy_6kl_V
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 58B0C100006
X-Stat-Signature: rgosnoiptx5r8ukyc51no8ykaxxr7sok
X-HE-Tag: 1775778143-622223
X-HE-Meta: U2FsdGVkX1/tXu0FKPlyR94UVe7AUHPBkIBIbvUQJgoZxk2Z4wWmjPRiXK/jr+ncJHvD1eJybI7dwislY5prgAv5wUuXghVEqP8x801yMdL8UH+bnjL8JNbFGWzO6yTJnHsYRN7EfHlKgqI+rShUx8TLnEtV2K68Kgz9NY2eYKrYxn+P4G4IligNNS1YKEkg0UZ9Zx4PlgKS4x2bcJp9QrGaaHTHb0f3S11n+Mm667VR2/262N7QnRY131i9v+/Ab1heSNFYTc/LiMPxgz+W9UkYq6TsHj05DGqbdyQ+7Jt9xY2dU9bn91c/Bif+Wojm7RKgy20fCvqVTxmth/MKl9oCxRpY9G9OYVQkPN13Rb5bWajhfPYzb0+K6Ll+Fww6swzfikXt4JCavYxlI2m43gKKbRlL+W6v6EjZk7NzTjPh6EX2tl3GtQpd3WlCezJAFCk7aVC6EyLFIOxp38inosFGjNIo5KOw2O+eiyL/ZKWLV9KMZp2epw2RDUolwyW0SJ9mm6CNKiiIRJbTtqE/d7OrlPCvBiHV1iWZxT6vAEEnxsK5gQK7EIgERHhIA3H1fMrusVeJfOJ+hvZNzi2ynweA9Chdsa+3/b/SvKytdYZ/Anuvyp+UjmriM3YDwbAWQx3R6ExoPm6FWjs57uG/nocg8e5QimzLLIdq2MP8znPQ2c6W0BSDqCszYwfvPAEMjJwxKjyyMKMhsfhb1oyEcXUCj+jK2dMg1x+xOF0nFPGme7SMQ/wNRtaH8LaVxScdHWrd/gwYD/aIqKMamQ3i2h85MZOh21ntLd+urcv9nNBaTnGA/wSoUlQ7kDe456ywgfz88sfD43XxOvifevcpylXXLH/PEbPGNS4y9Vk4lfU2ykZCZEH3rVZMqrVJeblyebjql2kjXm6wv3QvJRxF98ON7KHAyaPvSFvFGIbnyaUxifIDUlol9kPojhlQASkkp3j82yKp9CNL+31hlG/
 MpLeStWF
 3OGMfkehSuJCPa2vVrQ2jDl/hao4u58WkrnkgodK2vEXJXlWYxblOh+CraRUEtuQgPyOJyPz1QrPoE4OzqzTKUxDa67l76Axpe1beA+U/Xxv8UrkeWiA+WOCTf8gh15A8cSyKySqrNXFC79HuKLYJt7aZmBPp8yXz0gsV8W1iJWEnz9GkI/wzvzkBY6oLmwFDeY5sGwA/eZDRfBLpQMD3WDMWvchZ15bHrKZIYr+pH7TwB8naDiS3WMyFGtESgX8cryg2TA6VFXS0/5abOvg7xrGsfNTFkoEBfKxAnKurFmihuUJR0pYOx85RLEqUNbdLcT/MIxSEJGXiqp/cvuRLPkaqIguEnItkpysF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hugetlb_add_to_page_cache() currently takes a parameter named 'idx',
but internally converts it from hugetlb page units into PAGE_SIZE-based
page-cache index units before calling __filemap_add_folio().

Make hugetlb_add_to_page_cache() take a PAGE_SIZE-based index directly
and update its callers accordingly.  This removes the internal shift,
keeps the index units consistent with filemap_lock_folio() and
__filemap_add_folio(), and simplifies the surrounding code.

Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 fs/hugetlbfs/inode.c    |  2 +-
 include/linux/hugetlb.h |  2 +-
 mm/hugetlb.c            | 21 ++++++++-------------
 mm/memfd.c              |  2 +-
 4 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index e24e9bf54e14..a72d46ff7980 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -825,7 +825,7 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 		}
 		folio_zero_user(folio, addr);
 		__folio_mark_uptodate(folio);
-		error = hugetlb_add_to_page_cache(folio, mapping, idx);
+		error = hugetlb_add_to_page_cache(folio, mapping, index);
 		if (unlikely(error)) {
 			restore_reserve_on_error(h, &pseudo_vma, addr, folio);
 			folio_put(folio);
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 71691a2b6855..a51a5e12859c 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -713,7 +713,7 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 					  nodemask_t *nmask, gfp_t gfp_mask);
 
 int hugetlb_add_to_page_cache(struct folio *folio, struct address_space *mapping,
-			pgoff_t idx);
+			pgoff_t index);
 void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
 				unsigned long address, struct folio *folio);
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 138e5ecf818e..47ef41b6fb2e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5625,15 +5625,14 @@ bool hugetlbfs_pagecache_present(struct hstate *h,
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
@@ -5724,7 +5723,7 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 	 * before we get page_table_lock.
 	 */
 	new_folio = false;
-	folio = filemap_lock_folio(mapping, vmf->pgoff << huge_page_order(h));
+	folio = filemap_lock_folio(mapping, index);
 	if (IS_ERR(folio)) {
 		size = i_size_read(mapping->host) >> huge_page_shift(h);
 		if (vmf->pgoff >= size)
@@ -5788,8 +5787,7 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 		new_folio = true;
 
 		if (vma->vm_flags & VM_MAYSHARE) {
-			int err = hugetlb_add_to_page_cache(folio, mapping,
-							vmf->pgoff);
+			int err = hugetlb_add_to_page_cache(folio, mapping, index);
 			if (err) {
 				/*
 				 * err can't be -EEXIST which implies someone
@@ -6173,7 +6171,6 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 			     uffd_flags_t flags,
 			     struct folio **foliop)
 {
-	pgoff_t idx;
 	spinlock_t *ptl;
 	struct folio *folio;
 	pte_t _dst_pte, dst_ptep;
@@ -6183,13 +6180,11 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 	struct mm_struct *dst_mm = dst_vma->vm_mm;
 	bool wp_enabled = (flags & MFILL_ATOMIC_WP);
 	int vm_shared = dst_vma->vm_flags & VM_SHARED;
+	pgoff_t index = linear_page_index(dst_vma, dst_addr);
 	struct address_space *mapping = dst_vma->vm_file->f_mapping;
 	bool is_continue = uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE);
 	int ret = -ENOMEM;
 
-	idx = linear_page_index(dst_vma, dst_addr);
-	idx >>= huge_page_order(h);
-
 	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_POISON)) {
 		ptl = huge_pte_lock(h, dst_mm, dst_pte);
 
@@ -6211,7 +6206,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 
 	if (is_continue) {
 		ret = -EFAULT;
-		folio = filemap_lock_folio(mapping, idx << huge_page_order(h));
+		folio = filemap_lock_folio(mapping, index);
 		if (IS_ERR(folio))
 			goto out;
 		folio_in_pagecache = true;
@@ -6307,7 +6302,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 	/* Add shared, newly allocated pages to the page cache. */
 	if (vm_shared && !is_continue) {
 		ret = -EFAULT;
-		if (idx >= (i_size_read(mapping->host) >> huge_page_shift(h)))
+		if (index >= (i_size_read(mapping->host) >> PAGE_SHIFT))
 			goto out_release_nounlock;
 
 		/*
@@ -6316,7 +6311,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 		 * hugetlb_fault_mutex_table that here must be hold by
 		 * the caller.
 		 */
-		ret = hugetlb_add_to_page_cache(folio, mapping, idx);
+		ret = hugetlb_add_to_page_cache(folio, mapping, index);
 		if (ret)
 			goto out_release_nounlock;
 		folio_in_pagecache = true;
diff --git a/mm/memfd.c b/mm/memfd.c
index 911ff8220d05..56c8833c4195 100644
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


