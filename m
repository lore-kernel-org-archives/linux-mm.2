Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 454FECD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 17:26:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C76746B0005; Wed, 17 Jun 2026 13:26:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C272F6B0088; Wed, 17 Jun 2026 13:26:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B42F86B0092; Wed, 17 Jun 2026 13:26:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8869A6B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:26:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 06B40164FAC
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:26:06 +0000 (UTC)
X-FDA: 84890082732.19.C886D88
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id B5BF08000B
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:26:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=E45PcdJT;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf02.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781717164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zDEdJauVMqtcYMksWd/HaiAwhAj1eYV9erFp/52IWEw=;
	b=cXQWhjyvtOoiIr4idWRGkC7Xr0v4YntMUz0yUyDr0rr81Slxxb9Zv0hmkFCn1adY1/bajd
	KBDABZArLCqlLOV6VPXt++aoQPT2PAQCYkx5t1T/I2Mi+kh5+nZ6UT8ybjYNxN01DGPPbN
	yy6hp0uw9+Cb2Whz/ADgLnMkVRv2BEc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=E45PcdJT;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf02.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781717164;
	b=gbOwG8O8jzRC3eC0HKBV3DKSEbehMd2GxHGZ5WZQNoF8xuMYqq/2gLyMWvHErAtlQcFVjI
	DQcE05U4TsmfWi2vEBHCySyC8ic/WJcATUR1cR1jN2Ni6e/tqaEiRw+1/RCSxNsrxqYGmC
	BLf93k+6ALIELStmhjTSy56+BW0OInA=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65HEsR4f2367895;
	Wed, 17 Jun 2026 17:25:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=zDEdJ
	auVMqtcYMksWd/HaiAwhAj1eYV9erFp/52IWEw=; b=E45PcdJT1xJEOVCzXExoo
	sJ95a+kw7K3Qd/2mdalW8S5fs/SVwqmJrOHljFAhxUR8xy/9rE5BO8t/PpMWpgcM
	Jk9wTrZ4c3lu/+EwHGtoFwC9nPDmMmd0uTEi9igdobk0IdxY3ZJzGohCxBwbF5Ag
	sm/D9mwI4MVgLuRfNb//df7WxH0f9uej3f3D4z54Y11BOoio1juUNRCquE8BT13M
	zNqc33foT9huQWVqeso82RfsmEV6aZXSiBMaIKO+6vBj7YwDiPJLnlgmTRedhWwZ
	zOfrrKbG8pJ88thH6anZBJ5QYsVzCpbGw2lGsCvi30beo7LcEfcPI3IGSg+zhlTf
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4eueg31c32-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Jun 2026 17:25:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65HHNVOj003778;
	Wed, 17 Jun 2026 17:25:49 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4eudvc0wgy-2;
	Wed, 17 Jun 2026 17:25:48 +0000 (GMT)
From: Jane Chu <jane.chu@oracle.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org, jack@suse.cz, viro@zeniv.linux.org.uk,
        brauner@kernel.org, muchun.song@linux.dev, osalvador@suse.de,
        david@kernel.org, hughd@google.com, baolin.wang@linux.alibaba.com,
        linmiaohe@huawei.com, nao.horiguchi@gmail.com, lorenzo@kernel.org,
        rppt@kernel.org, peterx@redhat.com, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 01/11] mm/memory-failure: make is_raw_hwpoison_page_in_hugepage() general purpose
Date: Wed, 17 Jun 2026 11:25:22 -0600
Message-ID: <20260617172534.1740152-2-jane.chu@oracle.com>
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
X-Authority-Analysis: v=2.4 cv=I8VVgtgg c=1 sm=1 tr=0 ts=6a32d89e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=Mb7NiH9OEEZ03nqYuncA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12312
X-Proofpoint-GUID: 592cje2o6CRkX_6JHYwFOwZa5T7CjXZw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE3MDE2NyBTYWx0ZWRfX1YtkOhEQgCUq
 GcdoVQJTP+BKkLEGPlkd0LncsiyH7jmj0W7JobTH6WmS8E1Oskl33n64G8nqHGrMw2ddPWQjS/2
 1hvmaGruGdeJIfFlGKghi4accZgdugeDL0MYokaXTH+hU5LcvUyN+6bgK97Ap7ouCDaPwSLbB9H
 qXgubHTVYYZ0bMWqtZBNEiHbnMt3iTj5lsXUBlZb9+O8BM6JfkKVXzoJf9QfTmHPxj70kN4p8hQ
 7cCcnsCa/yMcA8HBMYQzvf3ixLtaYtHGc56VyBjYqlhGw4Kaq+4ipZsruAs/8NwwLmZEvEjmffB
 Jrbarf+aP1Tfjj3T9Va+g+/TGl+9zE6WrQQ6uD5zlZEYbkHTqsQfDT4ctoBXCgc+GqYEluNPJEH
 AvnW0+H0OD+xSCsrnFFO0RRFHUy/vKLFWoJs/BGOE0+P1YPgPuctcBvFAcX9b74fbfFZlaQ4iUc
 UPvH35w2rbtyTZt2rTwfqLOpC7IiPHwNyXJhpo5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE3MDE2NyBTYWx0ZWRfXzZOd+Jkjz6C7
 j2nmXzltI73PPbg9vJ/2Z5EUP8lHyDrVA7O+jXmnrM/Tz/5NPZdt/FsMi47dXLkNdHq2K7ZW/zq
 74c/p43HUlTqk2MjuW/b+NhJzOX5g/TRp9W+XZfiSvhAxKt+jAlS
X-Proofpoint-ORIG-GUID: 592cje2o6CRkX_6JHYwFOwZa5T7CjXZw
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 9ru6tiac8sor1smpoq8s7ktxfz6eserw
X-Rspamd-Queue-Id: B5BF08000B
X-HE-Tag: 1781717163-718512
X-HE-Meta: U2FsdGVkX1/BAzveN25rcE3vVR9CjskXKFzGg3PLS8rm+sWgMRyYtHGn+nW/YvgC2b8wbuw0YrjSaVqE80AO64L97mKVYpfDb6DLOt7QyqcdCGRS8LorLKYKHdh4P0tctyQF7EVfi2eLarSZ7jP9lIH1SUZDe49OO9VsjIxCMDg9qi8/zyF+yf6lnowmVAj3mTFNl2znKu6LvZlAvtXjDA286HJ4Ik4yOHpYb9Tx24ZmtAbKOafjiglFETTY6poPSVXSls4OgBvxJNhZnwFCp9j9eZZ22My9V0ivLwtKw6mzyg/1Lx9p8B/s6N5tUEbFs5Z2UsOyokAunM059ZGa7flaGI6hThYocFIZIz8acT8mf7xm4tI711Mo3VUH7Op7o7aUZzLwFEaQNpywhxKRyZsjUyb7Rk+UP5REdp63PkDf4bL0fMQIfg90Q/kaL4roU3vqQtysK8BuJCNQ9oLhMjNa/JeGbIO+JH26BO14Rffku0rMU/WKB0oRz4gBA2x1b09VUlbOil1aiB1SQt9KaRP/b2xb5+OgU5oW5Vk+KgMzmVI3X01xmI/ZYMbMVAT4ZaahGGx0wWOI592FXKGqYUR/pcVPYMRDhURY36kgVgSz4bD/3JBmBDMur35OSjzqj6YE0o6zl2F+oxGG5JyM242LWf1lFGYLJ+RkI4xbo3CRc7hL3+PRxrkQEvb0KLCwlIabJSF0nez1676vV5wWmVl+ffk6oJZ0cXwR55AeQi37hvAxlTBPID2Rq2I5EaIrQzycBcrnxDdNBOLst2SW0Ap5ozjus59MXOTXEiZJWKFe4LOWxDz5C+l4Rr7cxukQH8CKHjivdUj+s6LiQS1pkJfYgaEFuglIVgGiXFLYKQ7HaQIOaNwMLyTit1si2F/5d4avufixp3MDKq/bXgBYfIzLZl+frpfmcIlD9ruouAjsLBXdQvCP961XsLhJwlr82Ayb0jHH8RM9XEdPcwn
 hn99i2T0
 PXKhx9cLLuwkNfs2c6W2M2yfbpH7nWdgFa6TblzVggGrOQc1A0tZu3VD4fSGQrzOs/omh/BFOxf5AVTzySiBSawVMAW2I+hbKeWJolKm77YGA05ClbtT63IG5uaJ2NsTIFuNCM6pGwBVmBrCBs6tNiPCxjP1r1xbrIVI8vG6dyzYVHQlklWdmNbWKmghsQaBYQ9D+sU7DRoYf9WsukB7jN2e1lFgipjcO1aCuJ++rzNx+9hib+vou4pubuWoddcZ0HY3nzSfnh2Yp+IhWy/DYW+ATBSEV1hdUjUK9Ps8mC3L6v1f1Dljv2p+CvUkq1sq5MuEWogEZpyvJrc1YyFTKJp01TYXG7HKS3TvsOnqOP0FQSyA2WEB+oAdqWwydhnQE8mxVrZlHg3p2CkE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make is_raw_hwpoison_page_in_hugepage() general for checking whether
a given raw page within any kind of folio is HW poisoned. Thus,
replace folio_test_hwpoison() with folio_contain_hwpoisoned_page().
Also rename to is_raw_hwpoison_page_in_folio().

Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 fs/hugetlbfs/inode.c    |  4 ++--
 include/linux/hugetlb.h |  4 ++--
 mm/memory-failure.c     | 12 ++++++++++--
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 78d61bf2bd9b..66520f7c53c6 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -198,7 +198,7 @@ static size_t adjust_range_hwpoison(struct folio *folio, size_t offset,
 	struct page *page = folio_page(folio, offset / PAGE_SIZE);
 	size_t safe_bytes;
 
-	if (is_raw_hwpoison_page_in_hugepage(page))
+	if (is_raw_hwpoison_page_in_folio(page))
 		return 0;
 	/* Safe to read the remaining bytes in this page. */
 	safe_bytes = PAGE_SIZE - (offset % PAGE_SIZE);
@@ -206,7 +206,7 @@ static size_t adjust_range_hwpoison(struct folio *folio, size_t offset,
 
 	/* Check each remaining page as long as we are not done yet. */
 	for (; safe_bytes < bytes; safe_bytes += PAGE_SIZE, page++)
-		if (is_raw_hwpoison_page_in_hugepage(page))
+		if (is_raw_hwpoison_page_in_folio(page))
 			break;
 
 	return min(safe_bytes, bytes);
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 5957bc25efa8..a9846f043712 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1079,9 +1079,9 @@ void hugetlb_unregister_node(struct node *node);
 #endif
 
 /*
- * Check if a given raw @page in a hugepage is HWPOISON.
+ * Check if a given raw @page is HWPOISON in a folio of any kind
  */
-bool is_raw_hwpoison_page_in_hugepage(struct page *page);
+bool is_raw_hwpoison_page_in_folio(struct page *page);
 
 static inline unsigned long huge_page_mask_align(struct file *file)
 {
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index ee42d4361309..40129e0b8213 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1834,14 +1834,21 @@ static inline struct llist_head *raw_hwp_list_head(struct folio *folio)
 	return (struct llist_head *)&folio->_hugetlb_hwpoison;
 }
 
-bool is_raw_hwpoison_page_in_hugepage(struct page *page)
+/**
+ * is_raw_hwpoison_page_in_folio - answers the question whether a given
+ * page is indeed hwpoisoned.
+ * @page: given page, maybe base page, part of a large folio or hugetlb.
+ *
+ * Return: true if @page is the raw hwpoisoned page; else, false.
+ */
+bool is_raw_hwpoison_page_in_folio(struct page *page)
 {
 	struct llist_head *raw_hwp_head;
 	struct raw_hwp_page *p;
 	struct folio *folio = page_folio(page);
 	bool ret = false;
 
-	if (!folio_test_hwpoison(folio))
+	if (!folio_contain_hwpoisoned_page(folio))
 		return false;
 
 	if (!folio_test_hugetlb(folio))
@@ -1868,6 +1875,7 @@ bool is_raw_hwpoison_page_in_hugepage(struct page *page)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(is_raw_hwpoison_page_in_folio);
 
 static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
 {
-- 
2.43.5


