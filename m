Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11F9ED637DC
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 21:57:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BB9E6B0089; Tue, 16 Dec 2025 16:57:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 169A96B008A; Tue, 16 Dec 2025 16:57:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F22006B008C; Tue, 16 Dec 2025 16:57:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E10ED6B0089
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 16:57:06 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9F15613BB10
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:57:06 +0000 (UTC)
X-FDA: 84226695252.02.240D6EB
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id ACE80180002
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:57:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Zi9gtxwH;
	spf=pass (imf24.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765922224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1maYaTCzXyFDam1/GOsNUZkqL3tqTHSS7WQOdxTEj4Q=;
	b=2IidULtsE8x2X0GZe/u1QPgykOxeyC7pBcQOvIJ5yl+OsH+54QryP8wGQvLn5o4dG3Hlbf
	GRgt9evdMc8kqRL0vTjPdZ39vjfEaYklXPQq2DcFxT9kKZCxj5+sGSa6crkvwoa7TiNmMX
	IwQLN7sdrEo5+owgxFn2YEq7XVoDw1E=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Zi9gtxwH;
	spf=pass (imf24.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765922224; a=rsa-sha256;
	cv=none;
	b=AwFxQznLzqyOV3JcgDswHAgZgRIWezMriIQ3tuHlOLAw+1DrNYr7EU2kCiJDY7TJhI/OKF
	1IYzrcvUWuZTpcQP8TjOLF9W+ShdqWc2pZxisQF9J6mzyx5VnWrbIXdJD1R1HyRfdewBNo
	SnD6T5bfROQG+g3pTBqJ6tqB66kwSOE=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BGKRDHt1141350;
	Tue, 16 Dec 2025 21:56:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=1maYaTCzXyFDam1/GOsNUZkqL3tqT
	HSS7WQOdxTEj4Q=; b=Zi9gtxwH4LDls3AoMp5OULHuEzdpD3DHg8mGpnFEQscnQ
	3Yx7krRxw7wQhpbSGrJZ5AahGPrm5Q3PpwrwLUwumnl71vq2gYImN1kCcZBBjneN
	SRgY6SkqAuxIJFqIs4rcCs1RgX39CMYUNtns2sFpF1klnJT75Uz2vhydbi9Khrft
	y0h1OBiU4ua/AJBBWOvcu6cxl3dhya0OKfWvOgLeideIkHvcpklIT6xY8Om4vf81
	9nm3uGG+fMLefDR9zucawoBm00KDy+HYBjFclJ8AgkluYe9Ndo24N+WPdLxvML5Y
	/gXIdud34Tc97/Bs/UwRmx+Acxb05bgJaZEYFI7qw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0xx2csjv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Dec 2025 21:56:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BGJjgI1029610;
	Tue, 16 Dec 2025 21:56:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkb18wv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Dec 2025 21:56:51 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5BGLuoSP021467;
	Tue, 16 Dec 2025 21:56:50 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4b0xkb18wc-1;
	Tue, 16 Dec 2025 21:56:50 +0000
From: Jane Chu <jane.chu@oracle.com>
To: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
        linmiaohe@huawei.com, jiaqiyan@google.com, william.roche@oracle.com,
        rientjes@google.com, akpm@linux-foundation.org,
        lorenzo.stoakes@oracle.com, Liam.Howlett@Oracle.com, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm/memory-failure: fix missing ->mf_stats count in hugetlb poison
Date: Tue, 16 Dec 2025 14:56:21 -0700
Message-ID: <20251216215621.920093-1-jane.chu@oracle.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-16_02,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512160186
X-Authority-Analysis: v=2.4 cv=B8W0EetM c=1 sm=1 tr=0 ts=6941d5a4 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=Z4_W6085pIye7jCVOdoA:9
X-Proofpoint-ORIG-GUID: NGtefr_kkv30ifT3GwXBgvOwh_KfBsfA
X-Proofpoint-GUID: NGtefr_kkv30ifT3GwXBgvOwh_KfBsfA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE2MDE4NiBTYWx0ZWRfX9n1/pFDsLJ9j
 prEil1jt21Qi2tIWRnXfL8UeKDkXCXfp2Jj/G12+xvvlMRubSaF7mwDOAu5ae6iIza28p5+DYOw
 YFm4FBW8zRYp5l5jP9jFmaK0wMRu4rcHbeA0L0a54RY9Pzn4auT4QvsygF2+91iKXbrIYVXvAmw
 foyjvw7qeSBd/as9HtLMyrJ1xmun8SO7EsVmcHRf8ZW2rvmuPKeRXIcLV+OSJ2OVx/w+T2Jjha9
 vBl9F7CzyhwshUN5Wc4epUNUaBHVh7yXUC3gf8217W0uJB8kon5VVqnhx6NNoGK8r/znncT9do8
 b16cvRQ9prbFBZZ/q252kt0oAMizJERfT5xT+7kWGMJZng/rRq2n0CG22kOptq8tDXsJmBm2ZFK
 oorFkUsHjwT+g0V6DywYWZJU7mbc/Q==
X-Rspamd-Server: rspam02
X-Stat-Signature: wkup9odhqsz84wdg13wz9xed8ad5n6k1
X-Rspam-User: 
X-Rspamd-Queue-Id: ACE80180002
X-HE-Tag: 1765922224-731931
X-HE-Meta: U2FsdGVkX18SPO+xiKqJSxvLqQWYp8iHd5sfWHBQtt+HC4vrU7wXj8mavT30a5U6xB1XapyWVi1xsfiqEzXZZ6pzWxWRGdpZY1rGEd79b/uRIhiDl0sZ7l6AYDyawHZw4LJvsi2Vqvd3fLtLVCiE4wG3Z5x6xEBBLU7dVPlZ9zga2jegComICq2qjEg8DUxmZLZW0GE3iWZdkYNoxDfkevCw05PpQN0AhKEIAoBb4nU5yjWgmdCZriKQ/GwiLP3jvLSBgu34fb3S8ErE+lKlMZyWuEiy+vLXL27yoiZYlXiClGCfXlAAT2RQgPU+6ZFgscHmzG7koe9A2053PgLRyQz2CFSM+AZzw/tCfW/WqAx6l6VA0CB6aKT176F2FT1LsfAvM0GaFA94xOAFoT0uWpaF87dcHlb/2tdLZQ2+ew1P62zlh5nZSEQczEtglIUK23l+eZnb6zTSPRUSzM8hfO7vxDgVc7tXtNK6Y6EVbnQgMwBjslYG4w1FVnjqoHKUHp08uMmBG5KigV4tcy4lcl0b2Azc1y+u64v8VA+rFJ4PgV6KLvnMMAB2dPaHDoetoVv+lZDpae8UCA0A+eIsAxVrXIgDoq11EA1L2wDRI1XVbs6Ctx8our3aZhvAw/af7ccGq+CXxV76tZSyDPYmpXj4eXHk0+XIwnjaxXQnpzT3XNAPpQmvVdaVBRmkN43HyCOaIczOy4vGAHLp1lXBw32viY/Pq4pPlxhqqjb/Jjdq4Xf9yaQFdChY67WhL45HnYWzENDhKeKARjzyLLME0FQf1U33wNjduOGRb38OqYlunyDJSqTj43gA8OhnytbP8ByGhCJ2gip7qsE6rnngOJj3hhXJEfKWHiEg5mKzJy+C9oGfTVNOCGtn47uog0nnWzBQkfgUrChlnlghGulIyjgvybG9U+T2W2qiC3+kwaIA57EElyvlt3d8MnbjjNRCHdhdKq1cHYGa79ORqPP
 XjkZUWJU
 84kI3ByNtYKDRHZmm5dUO83SAUZ3eERtEJznLxXXc4wRRKw6dT5fYORlwdEAgHPAeQRcJCBlf6HyxQByNT8G3X9fLpP7JgoSDGn7uxFLOhZ7H9bSNsM2FDTFNOhmKzAqqYxbmbZPOOrX2cUmf0TOfXztISPeu0NtlO2pf7R4gcRysrk5fOiPbBlh6nMmXZ/HurEqopI3Jf/PR/zNDFpFc34xwyRJ5SNSzww+C2LzydBsCQnVy4LE0FDpBiJQqj7Ha/evpX03A3Mcll3qNAqmYxFu6bZE+KrbDaqly/ZodbrqVfnC/ylgvklVPm4z1Cc0vaawSCkv/bIw0gPC+bqjoP/NVqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a newly poisoned subpage ends up in an already poisoned hugetlb
folio, 'num_poisoned_pages' is incremented, but the per node ->mf_stats
is not. Fix the inconsistency by designating action_result() to update
them both.

Fixes: 18f41fa616ee4 ("mm: memory-failure: bump memory failure stats to pglist_data")
Cc: <stable@vger.kernel.org>
Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 include/linux/hugetlb.h |  4 ++--
 include/linux/mm.h      |  4 ++--
 mm/hugetlb.c            |  4 ++--
 mm/memory-failure.c     | 22 +++++++++++++---------
 4 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 8e63e46b8e1f..2e6690c9df96 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -157,7 +157,7 @@ long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
 bool folio_isolate_hugetlb(struct folio *folio, struct list_head *list);
 int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison);
 int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
-				bool *migratable_cleared);
+				bool *migratable_cleared, bool *samepg);
 void folio_putback_hugetlb(struct folio *folio);
 void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int reason);
 void hugetlb_fix_reserve_counts(struct inode *inode);
@@ -420,7 +420,7 @@ static inline int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb,
 }
 
 static inline int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
-					bool *migratable_cleared)
+					bool *migratable_cleared, bool *samepg)
 {
 	return 0;
 }
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7c79b3369b82..68b1812e9c0a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4036,7 +4036,7 @@ extern int soft_offline_page(unsigned long pfn, int flags);
 extern const struct attribute_group memory_failure_attr_group;
 extern void memory_failure_queue(unsigned long pfn, int flags);
 extern int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
-					bool *migratable_cleared);
+					bool *migratable_cleared, bool *samepg);
 void num_poisoned_pages_inc(unsigned long pfn);
 void num_poisoned_pages_sub(unsigned long pfn, long i);
 #else
@@ -4045,7 +4045,7 @@ static inline void memory_failure_queue(unsigned long pfn, int flags)
 }
 
 static inline int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
-					bool *migratable_cleared)
+					bool *migratable_cleared, bool *samepg)
 {
 	return 0;
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 0455119716ec..f78562a578e5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7818,12 +7818,12 @@ int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison
 }
 
 int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
-				bool *migratable_cleared)
+				bool *migratable_cleared, bool *samepg)
 {
 	int ret;
 
 	spin_lock_irq(&hugetlb_lock);
-	ret = __get_huge_page_for_hwpoison(pfn, flags, migratable_cleared);
+	ret = __get_huge_page_for_hwpoison(pfn, flags, migratable_cleared, samepg);
 	spin_unlock_irq(&hugetlb_lock);
 	return ret;
 }
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 3edebb0cda30..070f43bb110a 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1873,7 +1873,8 @@ static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
 	return count;
 }
 
-static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
+static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page,
+					bool *samepg)
 {
 	struct llist_head *head;
 	struct raw_hwp_page *raw_hwp;
@@ -1889,17 +1890,16 @@ static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
 		return -EHWPOISON;
 	head = raw_hwp_list_head(folio);
 	llist_for_each_entry(p, head->first, node) {
-		if (p->page == page)
+		if (p->page == page) {
+			*samepg = true;
 			return -EHWPOISON;
+		}
 	}
 
 	raw_hwp = kmalloc(sizeof(struct raw_hwp_page), GFP_ATOMIC);
 	if (raw_hwp) {
 		raw_hwp->page = page;
 		llist_add(&raw_hwp->node, head);
-		/* the first error event will be counted in action_result(). */
-		if (ret)
-			num_poisoned_pages_inc(page_to_pfn(page));
 	} else {
 		/*
 		 * Failed to save raw error info.  We no longer trace all
@@ -1956,7 +1956,7 @@ void folio_clear_hugetlb_hwpoison(struct folio *folio)
  *   -EHWPOISON    - the hugepage is already hwpoisoned
  */
 int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
-				 bool *migratable_cleared)
+				 bool *migratable_cleared, bool *samepg)
 {
 	struct page *page = pfn_to_page(pfn);
 	struct folio *folio = page_folio(page);
@@ -1981,7 +1981,7 @@ int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 			goto out;
 	}
 
-	if (folio_set_hugetlb_hwpoison(folio, page)) {
+	if (folio_set_hugetlb_hwpoison(folio, page, samepg)) {
 		ret = -EHWPOISON;
 		goto out;
 	}
@@ -2014,11 +2014,12 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
 	struct page *p = pfn_to_page(pfn);
 	struct folio *folio;
 	unsigned long page_flags;
+	bool samepg = false;
 	bool migratable_cleared = false;
 
 	*hugetlb = 1;
 retry:
-	res = get_huge_page_for_hwpoison(pfn, flags, &migratable_cleared);
+	res = get_huge_page_for_hwpoison(pfn, flags, &migratable_cleared, &samepg);
 	if (res == 2) { /* fallback to normal page handling */
 		*hugetlb = 0;
 		return 0;
@@ -2027,7 +2028,10 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
 			folio = page_folio(p);
 			res = kill_accessing_process(current, folio_pfn(folio), flags);
 		}
-		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
+		if (samepg)
+			action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
+		else
+			action_result(pfn, MF_MSG_HUGE, MF_FAILED);
 		return res;
 	} else if (res == -EBUSY) {
 		if (!(flags & MF_NO_RETRY)) {
-- 
2.43.5


