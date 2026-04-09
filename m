Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62EF2F36B98
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 23:42:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3F8D6B0089; Thu,  9 Apr 2026 19:42:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC9A86B008A; Thu,  9 Apr 2026 19:42:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A90A46B008C; Thu,  9 Apr 2026 19:42:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 95A5A6B0089
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 19:42:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3E330E1FC1
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 23:42:18 +0000 (UTC)
X-FDA: 84640643556.17.2884E77
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id EECB81C0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 23:42:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DrXSUpVl;
	spf=pass (imf21.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775778136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ANkcepWXUmYG6h8e17sKwrzzrSXFOc0Or3OEFDDFn/4=;
	b=sAwNGrZA95sKpHqyBOKJRxSwox2/PdgHpui5jGXq84xqYYwPcP1rjrkNKN+qIUTdJqF85g
	RgFuTsDKmQqPKyAfjOXmSjsM3PgaZVmCFYzXgJJbm8lf2NGDnRkxSNq+eKTy/VwJrihv1X
	KiKmUwVO5N36V9Wnpd2o1zOCz2qUlbY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DrXSUpVl;
	spf=pass (imf21.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775778136; a=rsa-sha256;
	cv=none;
	b=R+MPsBasA+2Xhu2fDTkanIS46t/tsM4sUrX2BzxaNicm+vVFHG2t1pUz4wxc+FRSk9gr5u
	uHMZro24qhdrT/oAbjFdSvys+1M3Uxtpt4UgzI97bcBP9Hs5vjfjXXMrxCKjktNzNbnLKB
	99d04E9qL7EVEeaI3S2gNl4HH7Vy4GQ=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639JtbDa3363957;
	Thu, 9 Apr 2026 23:42:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=ANkce
	pWXUmYG6h8e17sKwrzzrSXFOc0Or3OEFDDFn/4=; b=DrXSUpVl/dUApNGEUSS9B
	cJCnEXTU85RWH709hR4/gCzeOJV9U+v8/JSv0FADy3T2oQztoSEzT1zTmERPW1y7
	0KP0wodxPipqn5QMJcJOaYDL0juTJkTxejQTWOq4p32VgKN9+GX/r5jmyWxLrKas
	lBN+ik14E5RYcXkdcZn9c9ApFd+endsEFH5EikIOhfdm5hjO2QuRx78VfuXqSOoF
	6wtD7CaH4Sr4GMux95utNaM1yYJqpSK4cxIAhKqObicm9wTIfILQeYCi7D0xqQgj
	egZa38mKPVXGB7klX3FlnV0vKbISmma57l82ptNpq8trp0GKWk0poXlUQOcHuY5r
	g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqb0k4w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 23:42:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 639Mb0HN040079;
	Thu, 9 Apr 2026 23:42:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dcmnbj4rf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 23:42:10 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 639Ng6Yn038323;
	Thu, 9 Apr 2026 23:42:09 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4dcmnbj4pp-2;
	Thu, 09 Apr 2026 23:42:09 +0000
From: Jane Chu <jane.chu@oracle.com>
To: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev,
        osalvador@suse.de
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
        rppt@kernel.org, surenb@google.com, mhocko@suse.com, corbet@lwn.net,
        skhan@linuxfoundation.org, hughd@google.com,
        baolin.wang@linux.alibaba.com, peterx@redhat.com, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] hugetlb: open-code hugetlb folio lookup index conversion
Date: Thu,  9 Apr 2026 17:41:52 -0600
Message-ID: <20260409234158.837786-2-jane.chu@oracle.com>
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
X-Proofpoint-ORIG-GUID: pPZKF_5FsimjiTNNfVXi-JQjw1ekjlQx
X-Proofpoint-GUID: pPZKF_5FsimjiTNNfVXi-JQjw1ekjlQx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDIxOSBTYWx0ZWRfXwCwmfFmQSokX
 2CP96S84bs3ZqJmlDKT4TjB6TuA7LXjORWRkgfXB9AxYImaPD5xNtEolmxJkVd9PBtaZdnVLXbF
 p6utf/WtPGYEPUc7C6dAPjo98yHsWu1w/atOA1tKJXwvoj1DVCuU2UcIfQNedEXHU9M3vOVJWo3
 GSSKPk7YCZ+8/U9fv264MdUzR3CL4ApgAXKrd4uBe/lq//uYAgk59vTp+BJbjGPFACBKM/XDavr
 ofwmVrC62xz4hVXibOTg+1zgRHUt2WdAN/RiuW5yfU1aFKZxMpoKlv8hMYVyM/jBcgUHZtvUce7
 JN3l3k+UeNJtD4Fz0oCZAalN2FpU61OY3PB3FrD3M/nbPX8u5b2uki8M7YT7qFlWHqhykTiGih2
 WNyip70Pc/yvPC1AS7ytd1C99N+gMFhMr3cg8o2qLnkgQCUcS3i13sKuSmiX11jjuZO6FNuaW/Q
 E3ld3FfKLolIyxAhwOg==
X-Authority-Analysis: v=2.4 cv=NZXWEWD4 c=1 sm=1 tr=0 ts=69d83953 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=Nz7dlPl4-TdBfESK5NoA:9
X-Rspamd-Queue-Id: EECB81C0005
X-Stat-Signature: e5ap5gsbi3y8e1n6p8ho4ynmthsf1r6q
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775778135-249027
X-HE-Meta: U2FsdGVkX18DPnMsnKaoeR4fWAuwMh8o2difhXeN3BlJJGySWA9Egzsk1sDkU21zxUMoXLWsqgWRVbH7+d//dO/mdgk0sY2KGW6L7f102DVO0aYqFGeK5DrJ7LMr+F8EgjdhsFEnJTSwS1vnA1tQ+vzAa/F6/9j95PcqNf/D4leUsq6/Dj7NSs9hdpGgp1/fL5LNh9HQBzl1FQcVz9lh54EItPkUdx1Ux2+bq0NhtqnTTsHMz02H/fEog2kcQ9+1Kv1dqJ/qxWWCha9BityUE/5xbd6uGr7AmJ7BODY46WCi/bgsJKvYxijdBVt1FqQlgHr3dAsbTKsCK+ypYpvdaaaQvhkhxSzjw5Q37MhI9pNekTQJ8sSRgKHW0qY6sAIVwOReGFifL3jVsAdnJrgxGGjeTXJRkPbrV0vF1JwO7zo8vURKG/M38oRxK5Cvd0e5tNpTm4GMyLy/f7uqfUZQcaLzxLu64mo/3ZMuOXIfK8F5cVO15/7A5W5PgpyXVFausbVrAChiSYctlbcbdidprhc4zdq2wij5sLhx1rhhjcD38U/7wLULKUGxp6jqTID0tbfXWjGdGddbibX/lacHS/WEcSBsJTRA51r6qiE2aR6bCXJQ8fYDy47aUOAC0x055wa7u5usGlE8Q8SeSU7dpnyHQorVy3OvTWEexsfE+VWzVn3Fwjt5ENmutXlt8fCm60ApdjYMRn8yrTjDOPFH41mOAgkk9rkJ6tOXRB/CGVTtE6P3uh0quYeS33eA6k+nUAntHAUUfZQbcODyXTG0EglEXnNWx+IBuBcOLAJr/8IItlsYBBeKHcPU5UDeENWrg5/0fOUR0N1AoSKNSe82z/Zzh15COUAHajxUQq60QR2OmzcOM4fkIkrDfbecMoJkb1Zfjr0hDTw5eTntZ6YigavzaEdIQMTxFYOm0A60cgif37YS0irW0dXRQSqC+SuZZr6guU+iK0+5iQZve+L
 w7St5k/e
 e0kQA0YwTe1Jl3ui5Jur21FkHVqvobRzouq190ZCnjQwF3OZqlS960KakluEJb8Vk19EHmRy1+JcIKfhmksERPDGsEDpH5nk+/N50Rl3kstpUZ0wlsA1+NodOS+aRf7plc+yc2yioGhNfCqJryZW4x20VroaFEjrCCKHXftW6ZwjDQoWoAB856Ib73ESQ9UdEqQ6bghMZI8rw9EF9HuxIJY6H4AkViQk6YoW+ONcJLIj/9+T5FPbIzYHc1DuGv9lRgPXvEDK92Nz8teFDnGvpv98DMIiW87QtPzJj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch removes `filemap_lock_hugetlb_folio()` and open-codes
the index conversion at each call site, making it explicit when
hugetlb code is translating a hugepage index into the base-page index
expected by `filemap_lock_folio()`.  As part of that cleanup,
it also uses a base-page index directly in `hugetlbfs_zero_partial_page()`,
where the byte offset is already page-granular. Overall, the change
makes the indexing model more obvious at the call sites and avoids
hiding the huge-index to base-index conversion inside a helper.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 fs/hugetlbfs/inode.c    | 20 ++++++++++----------
 include/linux/hugetlb.h | 12 ------------
 mm/hugetlb.c            |  4 ++--
 3 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index cd6b22f6e2b1..cf79fb830377 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -242,9 +242,9 @@ static ssize_t hugetlbfs_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	struct hstate *h = hstate_file(file);
 	struct address_space *mapping = file->f_mapping;
 	struct inode *inode = mapping->host;
-	unsigned long index = iocb->ki_pos >> huge_page_shift(h);
+	unsigned long idx = iocb->ki_pos >> huge_page_shift(h);
 	unsigned long offset = iocb->ki_pos & ~huge_page_mask(h);
-	unsigned long end_index;
+	unsigned long end_idx;
 	loff_t isize;
 	ssize_t retval = 0;
 
@@ -257,10 +257,10 @@ static ssize_t hugetlbfs_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		isize = i_size_read(inode);
 		if (!isize)
 			break;
-		end_index = (isize - 1) >> huge_page_shift(h);
-		if (index > end_index)
+		end_idx = (isize - 1) >> huge_page_shift(h);
+		if (idx > end_idx)
 			break;
-		if (index == end_index) {
+		if (idx == end_idx) {
 			nr = ((isize - 1) & ~huge_page_mask(h)) + 1;
 			if (nr <= offset)
 				break;
@@ -268,7 +268,7 @@ static ssize_t hugetlbfs_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		nr = nr - offset;
 
 		/* Find the folio */
-		folio = filemap_lock_hugetlb_folio(h, mapping, index);
+		folio = filemap_lock_folio(mapping, idx << huge_page_order(h));
 		if (IS_ERR(folio)) {
 			/*
 			 * We have a HOLE, zero out the user-buffer for the
@@ -307,10 +307,10 @@ static ssize_t hugetlbfs_read_iter(struct kiocb *iocb, struct iov_iter *to)
 				retval = -EFAULT;
 			break;
 		}
-		index += offset >> huge_page_shift(h);
+		idx += offset >> huge_page_shift(h);
 		offset &= ~huge_page_mask(h);
 	}
-	iocb->ki_pos = ((loff_t)index << huge_page_shift(h)) + offset;
+	iocb->ki_pos = ((loff_t)idx << huge_page_shift(h)) + offset;
 	return retval;
 }
 
@@ -652,10 +652,10 @@ static void hugetlbfs_zero_partial_page(struct hstate *h,
 					loff_t start,
 					loff_t end)
 {
-	pgoff_t idx = start >> huge_page_shift(h);
+	pgoff_t index = start >> PAGE_SHIFT; 
 	struct folio *folio;
 
-	folio = filemap_lock_hugetlb_folio(h, mapping, idx);
+	folio = filemap_lock_folio(mapping, index);
 	if (IS_ERR(folio))
 		return;
 
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 9c098a02a09e..c64c6e5e50f5 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -829,12 +829,6 @@ static inline unsigned int blocks_per_huge_page(struct hstate *h)
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
@@ -1106,12 +1100,6 @@ static inline struct hugepage_subpool *hugetlb_folio_subpool(struct folio *folio
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
index a786034ac95c..38b39eaf46cc 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5724,7 +5724,7 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 	 * before we get page_table_lock.
 	 */
 	new_folio = false;
-	folio = filemap_lock_hugetlb_folio(h, mapping, vmf->pgoff);
+	folio = filemap_lock_folio(mapping, vmf->pgoff << huge_page_order(h));
 	if (IS_ERR(folio)) {
 		size = i_size_read(mapping->host) >> huge_page_shift(h);
 		if (vmf->pgoff >= size)
@@ -6208,7 +6208,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 
 	if (is_continue) {
 		ret = -EFAULT;
-		folio = filemap_lock_hugetlb_folio(h, mapping, idx);
+		folio = filemap_lock_folio(mapping, idx << huge_page_order(h));
 		if (IS_ERR(folio))
 			goto out;
 		folio_in_pagecache = true;
-- 
2.43.5


