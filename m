Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7B72CD98F2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 17:26:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCCD76B009D; Wed, 17 Jun 2026 13:26:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C01436B009E; Wed, 17 Jun 2026 13:26:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A54996B009F; Wed, 17 Jun 2026 13:26:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 616C16B009D
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:26:27 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C443814047A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:26:26 +0000 (UTC)
X-FDA: 84890083572.22.B25E298
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf31.hostedemail.com (Postfix) with ESMTP id B246F20002
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:26:24 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MQvsvO6d;
	spf=pass (imf31.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781717184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bJqO5j89RevMNiZ+aQEzjbYrz/l5E1nZ80jmdhRo+NA=;
	b=FBldRJSys+RL+mGaremoW7Y2aE9af3O9kroCcy0ipKDrFfN/Nzrdq9DTk0y8eI4bYI5RSZ
	GT7hRB/LUBFtj2Fupvzx8oZaXGRK6yDpW9KVL72FJJ+lSfChUlSA/AvJ4AMF1qzIKJIflj
	jRQn9Blcm4isTtm5wxpVbFQ81W6UJHE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MQvsvO6d;
	spf=pass (imf31.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781717184;
	b=oephFXBM758vkefgZYuQwI7Oa9NUcrYJmqN1pZl1cB4skXpNoTe2/BmFJOxXXdF1gaDWNT
	hOhupnbtLwXa8wQmIj3kf+iGzAUkhche1W+e/3s6ZlVEKqs+tvzZtFB9ODSAa1GvEIJTWM
	pe9PacDkQYWQub86ScIUbVK6yj3sYiI=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65HEsR2u2367890;
	Wed, 17 Jun 2026 17:26:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=bJqO5
	j89RevMNiZ+aQEzjbYrz/l5E1nZ80jmdhRo+NA=; b=MQvsvO6dGAlctPle1MySc
	PV2G+uHUAF9VPsDq312QWrLkHZeNygZEivhTE+10lWufGcCvf/jG7gMmF0R+mOjg
	xS1QATS+iW/nR0hQ2ptdk7k6SDFAVnHClwQ749jnZWsBuhOjIv97+GQZz+glDb9r
	dt8qXoU+iNKTz0sFCQQ9atQNXpXA45lZ00nIOO9G8O0cJif60SCVlJ+Z1PS0X0fT
	5TSqAQSfgl6HCi7Qkce5Mkb+n6m60zmJLi2YqWGu44VSUvs6plVgX23Mq1U8xhhZ
	eHbjN+cmculbXSz42ZQ0WfJgTP9RSjp9AIP311Yl2vX8NHNWsNe2pV3CGNKLyc2+
	g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4eueg31c41-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Jun 2026 17:26:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65HHNVP0003778;
	Wed, 17 Jun 2026 17:26:11 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4eudvc0wgy-8;
	Wed, 17 Jun 2026 17:26:11 +0000 (GMT)
From: Jane Chu <jane.chu@oracle.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org, jack@suse.cz, viro@zeniv.linux.org.uk,
        brauner@kernel.org, muchun.song@linux.dev, osalvador@suse.de,
        david@kernel.org, hughd@google.com, baolin.wang@linux.alibaba.com,
        linmiaohe@huawei.com, nao.horiguchi@gmail.com, lorenzo@kernel.org,
        rppt@kernel.org, peterx@redhat.com, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 07/11] hugetlb: replace filemap_lock_hugetlb_folio with filemap_lock_folio
Date: Wed, 17 Jun 2026 11:25:28 -0600
Message-ID: <20260617172534.1740152-8-jane.chu@oracle.com>
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
X-Authority-Analysis: v=2.4 cv=I8VVgtgg c=1 sm=1 tr=0 ts=6a32d8b4 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=FRHgpwYkufxqq0dH4jgA:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12312
X-Proofpoint-GUID: j23aEEVfp7e5rJ6HrmdclfWpIL4KwnkK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE3MDE2OCBTYWx0ZWRfX3x0t1wV30z5R
 Lj9AFYRoMKgo+U1nr7n7g0b1HcjdnorYBd/DilCQuNw1xwaTS/eQE3K5p3aKl0QxfqO4p4aGiV6
 E18io8rwrhek+dnaGEAKbWknReZwHZwexIfhwusQDF40+p2ROUiClk8nqN/OGlCZg1aFkC+jIRf
 yjzOeEb6KqEZXebgNQm+rc+A2bW1VGjvF+h6V6kYlx6dLOuFevgs1F06nTbrJ+0ai4DwZq7YgsJ
 kecMWB6BsMa41/VwMKqEeie/gwV7HBHNFsLxzslU0PelS+jNWz+XWn/yhLw+Tkoc1lP9kWxjKXf
 yqrz6SJT4btFkZlbPegfwoeI29/TRCI5GhJgPjsRCF8QAB8xeIY1x1WzmBrARcAW6xBK82ERMDI
 TeST/T/OXpJ5RH8TNUsfgqSo99OqB9wWzHJ8nyXpLeHBDxADocYn/ZkK/UUgAeRHxYd6Yyuhztx
 9qaYO6CN3jHY0qqEbqCz3KgNgawH8SNcVZtFCtTQ=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE3MDE2OCBTYWx0ZWRfX6cR4pX/6SkdK
 bzWdPkpbFGxGWP8d0yBNDNMZ7FKqXKMjvlC//OfHl5Hutm4MN0reMR5A+neXEPS258IYQ8MjUx8
 koHHsbcm0C7Unvo9BjwPiKu6sjTeGuyjr02mOlptn3EQgBUQMI8r
X-Proofpoint-ORIG-GUID: j23aEEVfp7e5rJ6HrmdclfWpIL4KwnkK
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B246F20002
X-Stat-Signature: 656ofohnipomj59s5b7hrbn5qcbupzpp
X-Rspam-User: 
X-HE-Tag: 1781717184-321987
X-HE-Meta: U2FsdGVkX190NAIhUA1XcmZfgm09yTJAFxiRFj9Le/T6OU3nXTZmZM0xMjldfD/WyHvsFKa9TJ3qXmSUlv4jaU3NAfmWTsI4QvRVulBLsFgtgewNrB3FKYku3j7SB4McMDBopQQLmbXm9pBffpCt5/Zsr2NR7qjQCNrUuE1HVZVCM7dDb3wg+oESrqaUNEOdVQ/n0fChzi0WQu1KP70LWNFsBupP8VvPaWsQKTisJzY09vVCS3pIgRboVcQ1hVwP4PhT7gsG/sLYKk1lMIYaiAsNVrDj9nXxQ7M7NuzfV1Qy8kcXJcLI2Kcz3MLrq5QUPA5+RDrDpwWkVjc3O59SzRiVy7K7YY/SLpVG1ftb5SPPRDSKNkHFbfnCjYl68VjE9ETR6AXIe+HOWlC+R2Enduepcxd8na7HujwF09ZxoPY9WLi/mkIrDJpfI8nL0ZFssJ+YLA7OVRFubjkDUhesngwmFALpv8r96gZ7eP5GF4DjPu+pCBvUj2gWn7dLGDPSz5hX9uGwKL9RaD0FvkrjvyUlkOfa2okIWt81uok2ManKObJkKpsb5NYVjFeHr99VVhfB/YafNcTLkHpdlX+uyw+Frx6ORAAtbhsROoreknVLYFhwguHzGwGVLTSD+mnO8EKZXNZ7hKUwGBc8rHeuzgmZfT5DSg5RpJThoZCGjXtnchocoWc1YCTo4k53sL8jym2pofWQhAHpEcxHu2Z2d0F4nbSNoyyIo3/66Rhoh+6nPzDA/HagjsuV2cD/9Wc6uNwnqrgEU63M2JgZlCoCxJC1JQQahl9/61NYJ6hVSlO4TULG13heA7Kd4il5L4zNJaMMGcJjJS5p6iTEqChfl0/FjZKxJ5o/7t0oD/px39HM8jjOb66XAWHvSu/69OGTyfX2t4ooZ9WHPa120WmNmH5V9JWTpX/LVPUZ9tV0O6zyQCb46mMDYhl7AeDt3Shk3spYOvii7qiyrydvGTV
 PsQn+ZAM
 Pmmg5bgfvc2qAp5s4TdrdoTqII/sRSYYzkkrbIvNPBDFcXOImiFfhsG11jcq5m/9vgDtEGWgZJ8+JvYy5Y9v9C1L4Rr8wtdHl31svvwGZKaO8+ZBRQ+N7RSVO/CGa7AO66ncWlFcS7aP09iz2bF6+3YXHCey+95Fi26589ZXDEBGdj0Semz+FQg4b6gn1IkzvDcu8yx4AfM165MBPhdVdhYdUDingJGDepClXKUW57M5SpsDoLfkAJutEpnseAu2QqouFAs8YaeGD+Zjn03vsqz8NV5dgIzy1Mf98vOjvdL8YBNGJjF/0Dvqv1Ytk62l6VAcs9JYExbrkMWScoQ45xZCUeVZe1Ka+fQMNaBgt9cdmHBKUq05/cLCU4z6MOj4iHulOq6yb3Akhnn7mAiuuLvHukm4OerKF2d6L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The problem with filemap_lock_hugetlb_folio() is redundancy, replace
it with the generic filemap_lock_folio().

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 fs/hugetlbfs/inode.c    |  3 +--
 include/linux/hugetlb.h | 12 ------------
 mm/hugetlb.c            |  4 ++--
 3 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 02cb265a580e..6c883478f7e7 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -518,10 +518,9 @@ static void hugetlbfs_zero_partial_page(struct hstate *h,
 					loff_t start,
 					loff_t end)
 {
-	pgoff_t idx = start >> huge_page_shift(h);
 	struct folio *folio;
 
-	folio = filemap_lock_hugetlb_folio(h, mapping, idx);
+	folio = filemap_lock_folio(mapping, start);
 	if (IS_ERR(folio))
 		return;
 
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index cae5cdd3ea00..e78d0f706681 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -824,12 +824,6 @@ static inline unsigned int blocks_per_huge_page(struct hstate *h)
 	return huge_page_size(h) / 512;
 }
 
-static inline struct folio *filemap_lock_hugetlb_folio(struct hstate *h,
-				struct address_space *mapping, pgoff_t idx)
-{
-	return filemap_lock_folio(mapping, idx << huge_page_order(h));
-}
-
 #include <asm/hugetlb.h>
 
 #ifndef is_hugepage_only_range
@@ -1096,12 +1090,6 @@ static inline struct hugepage_subpool *hugetlb_folio_subpool(struct folio *folio
 	return NULL;
 }
 
-static inline struct folio *filemap_lock_hugetlb_folio(struct hstate *h,
-				struct address_space *mapping, pgoff_t idx)
-{
-	return NULL;
-}
-
 static inline int isolate_or_dissolve_huge_folio(struct folio *folio,
 						struct list_head *list)
 {
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ecd1d1322fda..5484e78fe72e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5715,7 +5715,7 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 	 * before we get page_table_lock.
 	 */
 	new_folio = false;
-	folio = filemap_lock_hugetlb_folio(h, mapping, idx);
+	folio = filemap_lock_folio(mapping, vmf->pgoff);
 	if (IS_ERR(folio)) {
 		size = i_size_read(mapping->host) >> PAGE_SHIFT;
 		if (vmf->pgoff >= size)
@@ -6201,7 +6201,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 
 	if (is_continue) {
 		ret = -EFAULT;
-		folio = filemap_lock_hugetlb_folio(h, mapping, idx);
+		folio = filemap_lock_folio(mapping, idx << huge_page_order(h));
 		if (IS_ERR(folio))
 			goto out;
 		folio_in_pagecache = true;
-- 
2.43.5


