Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3E58E6B261
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 01:21:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 424E26B0088; Mon, 22 Dec 2025 20:21:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FC616B0089; Mon, 22 Dec 2025 20:21:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 308106B008A; Mon, 22 Dec 2025 20:21:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2168B6B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 20:21:41 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DC45313ABCA
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:21:40 +0000 (UTC)
X-FDA: 84248983560.29.1DDC48E
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id C4AD780008
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:21:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mWT+8AQE;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf02.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766452898; a=rsa-sha256;
	cv=none;
	b=dmCGcBvyRLF+ipDb34cg/HkluREOh3lmtx0qzqgL11bCokhoBzDuPE2QSfCdFqMowQKM4A
	VE4wyuWSu5AmoC3wDye8fHchGo5M6AtioAA2wzvZwkRFWIsbQeYFArPE4YIXsNFel6RIYZ
	ZSoScv5jyWnVsjN0l6RLDxY4xMKgtcQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mWT+8AQE;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf02.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766452898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UnzJUYZBEsWJFG5paNuHbrUsuHHsv7hIatCncppAjXo=;
	b=RmrWzi9h2nKcU1S1KUsNZIhGvGMBqaAyzUd/5fO6ha1ItcXEolO9AwY1LxBd/TyodXkguK
	zwhCzegN7LzbKXrAg4IFLYWzHDuUYyypngAgf+t3bSYvrkjgbQtcpRiAM+UkOdfRJ7sc3X
	jT71PesNmSiHYPOr1f0pl+kd1TjUzGE=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BN18pPj3528396;
	Tue, 23 Dec 2025 01:21:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=UnzJUYZBEsWJFG5paNuHbrUsuHHsv
	7hIatCncppAjXo=; b=mWT+8AQE5Ia17dtR98K33BGPCYt4nZdLEbOYA+5Q/VG/k
	Z+3TM3s0/z3uYc1GxFmZlSqKWineNHamccMW6Q9mE3l1a/wsbSMVWNSWwCjApbIB
	6MtqmqybSyqnTZyQDnYWFNSx2U4PolrATOjAT8fO28YPPBMSvkMM/sV6+UK23oh6
	hGuK2JQZs2fTcUwjjdq5Kqrv2P2Jns6bmympfaREJix/Zk53aSNatpyLgFbqv52y
	RiUMWBAI4jJtGX7gqZIQWZdXdm7fzVJTw7XnIiaYuqk2iOV+KT3dmqtfELG1jvml
	G+hrGbXtDnC2uPT0bLiOhgijAkWpCKr8HM8WgjXaA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b7h5p007j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Dec 2025 01:21:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMMjDmL001818;
	Tue, 23 Dec 2025 01:21:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b5j87x0dx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Dec 2025 01:21:24 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5BN1LNiC016978;
	Tue, 23 Dec 2025 01:21:23 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4b5j87x0df-1;
	Tue, 23 Dec 2025 01:21:23 +0000
From: Jane Chu <jane.chu@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, stable@vger.kernel.org, muchun.song@linux.dev,
        osalvador@suse.de, david@kernel.org, linmiaohe@huawei.com,
        jiaqiyan@google.com, william.roche@oracle.com, rientjes@google.com,
        akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
        Liam.Howlett@Oracle.com, rppt@kernel.org, surenb@google.com,
        mhocko@suse.com, willy@infradead.org
Subject: [PATCH v3 1/2] mm/memory-failure: fix missing ->mf_stats count in hugetlb poison
Date: Mon, 22 Dec 2025 18:21:11 -0700
Message-ID: <20251223012113.370674-1-jane.chu@oracle.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-22_04,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2512230009
X-Proofpoint-ORIG-GUID: -oFl7g_-F8DkPV5WNQf7l7Ig8btqXkOX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDAwOSBTYWx0ZWRfX+iNC4LzzLn9N
 ygaS+gPftlpuBhs4Yi6F7c2W4zcNEbPdzNJYX6LYDiEi3Req4sWuKrfndB2GoUkxNY1xTfTMbUN
 fBkmDkwmbmJOwjSB/B2SM9tigcV7j5Dy2NndO+Lbqsi8/r4FrZax4XqnLbxAXmW4R62WEy+P+GG
 KJfEbdVZ1HtKCgCijtQiQ28yXOh/VYevoYlP7PC9HedxH0I6yudddGTdXemsLgeY8mdRUNnebWG
 nPfe4J9pOMoL0Hzp4+LgBwBdOMUpa0gdoM2L2DVcmlUVqJtWcOk9CwGuEZ6KY0hlETi9QQnc6Za
 Juvz/Q5L9dx2B8JD0Fg7SY2S4Ac37KoG1wB2rugE0nEdhb9apGxKqKejH3RS1ZVoi/40VZHLJhe
 mcs3Qc0HpFNnypQplYPXkd9rDyLIzIS5P5utJaGoHaXW9Xmp2HZemsDbaMvCPA5H9KiQF/kSuNx
 X6RbBUIK9uWfbbuIrgg==
X-Authority-Analysis: v=2.4 cv=S5/UAYsP c=1 sm=1 tr=0 ts=6949ee95 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=0f2F8jj5qo72ZdTnQt8A:9
X-Proofpoint-GUID: -oFl7g_-F8DkPV5WNQf7l7Ig8btqXkOX
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C4AD780008
X-Stat-Signature: qfswuaut1w3f18k6sayk1df5qqxh4cg4
X-Rspam-User: 
X-HE-Tag: 1766452898-992672
X-HE-Meta: U2FsdGVkX1/d3/MkHJtBrW3f5XtKQI3efMdXBJ3pocLLlhWDJdQXOjgYpxaYxaxTwxWskm/sjHuj+ioQdmeNip2wxYLsLG7Oesx4uqsq0bvubc84GVlESgjFA/oT1p5NLvOSdk3lS9EGiSYH71TMw4cgmmoTHb+IoAVLu3MrAf9E875a8jBL5CldxgpbAui2yvtoK8K81nE4JPAXCp/fn0wS+QE5m7HPPkQv0tJ/B8xgNAX7y400yUyYJ3cj8tE7/Cof9W6NdozI9R5O6BkcrW65AJ1vFm58v53rWD4hNP33YT9l5bv+Wd8vYlVYTpi6Ts46zz5N0UeThXQVFH8uEedxQsdGq61iNDMuKOsUJqb4WJLxlwkqx4LRYk+GvbOsIjvx7/c9HrF/brHr62pY7c9tvPYKaxamkRLhdHQjdzhXFXR3FCvR5ZbVJH/6nOjdth2vLnOOAn8F1qUixHSkiiL9MDg9dSRgM19eqxRSgFhu9k/YB8FebqlcHzGONZ1DWGOuqC9YBE5tgDgwbKKIk9IfvMHrLisJFRhF5xJbdzCN/w8TCxxmdT0hFzLVmymAGWYyUJF+tcVQBSjFUL6W1S7Y3stzMhpV4bdtqme3wAg9TN9LkkgKtxxcT0rfonPzP7rfQcz9wYpVGMCIjlmifR+IEdsS9RTW1+NRSlQrJh3NUficinPHl47Qbles+BWbGXwFfG/QyZEiUDU5AxhF/FXIQiHjaFI5Bhpa7sJWW49/B3O/mVrKK5QAg7/ERA/hgCRbfA/NxFZEgoX+NgDLWq/Ls3wYvWAhH3jL6NLuaUsCLEKzdYZMmcmyu9K99GB9m+WtYWcbr8ut+Y7NjfhrwR4edU6ytDGvJ/MMGdQ+BAolc5iTc37RbAcwLZguevbc9n0nF1/WpBHmPKyDYA0x63z+w+Kc7YhE7D5A136AXk9FA7OKBW2cxoSg1I40ZKbUSbdZOqShltYHEl+38ZC
 Yrp3Owk5
 QoJ2VrlxreGuIPFjsQ4/vSelLAlACHtevZDSlyw9WJZend/f/3hCFOtoSq6O4yfuaSILTaxTPiVutJv24wJMFziW1vYgMTypJJlPH2OPDPAfGYB/6JxWZzmt+ta1xqnArkg4LzQAoQtf4I0Cesu93c6KD3npg+IHC0l/p4N4DbBTy427QxKW+ld0NsrEFJou7BtzD83Z+jp21kYF5HIiPCo4lHUvQfFWjFwUlmSdBwpk2l8V9IXUzgCzUPrAVZerkI1nnB1FFAkwj5p/ADXORpfV96O5vgZxip1R8m0bogCC9oJU=
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

While at it, define __get_huge_page_for_hwpoison() return values in terms
of symbol names for better readibility. Also rename
folio_set_hugetlb_hwpoison() to hugetlb_update_hwpoison() since the
function does more than the conventional bit setting and the fact
three possible return values are expected.

Fixes: 18f41fa616ee4 ("mm: memory-failure: bump memory failure stats to pglist_data")
Cc: <stable@vger.kernel.org>
Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
v2 -> v3:
  No change.
v1 -> v2:
  adapted David and Liam's comment, define __get_huge_page_for_hwpoison()
return values in terms of symbol names instead of naked integers for better
readibility.  #define instead of enum is used since the function has footprint
outside MF, just try to limit the MF specifics local.
  also renamed folio_set_hugetlb_hwpoison() to hugetlb_update_hwpoison()
since the function does more than the conventional bit setting and the
fact three possible return values are expected.

---
 mm/memory-failure.c | 56 ++++++++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 23 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index fbc5a01260c8..8b47e8a1b12d 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1883,12 +1883,18 @@ static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
 	return count;
 }
 
-static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
+#define	MF_HUGETLB_ALREADY_POISONED	3  /* already poisoned */
+#define	MF_HUGETLB_ACC_EXISTING_POISON	4  /* accessed existing poisoned page */
+/*
+ * Set hugetlb folio as hwpoisoned, update folio private raw hwpoison list
+ * to keep track of the poisoned pages.
+ */
+static int hugetlb_update_hwpoison(struct folio *folio, struct page *page)
 {
 	struct llist_head *head;
 	struct raw_hwp_page *raw_hwp;
 	struct raw_hwp_page *p;
-	int ret = folio_test_set_hwpoison(folio) ? -EHWPOISON : 0;
+	int ret = folio_test_set_hwpoison(folio) ? MF_HUGETLB_ALREADY_POISONED : 0;
 
 	/*
 	 * Once the hwpoison hugepage has lost reliable raw error info,
@@ -1896,20 +1902,18 @@ static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
 	 * so skip to add additional raw error info.
 	 */
 	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
-		return -EHWPOISON;
+		return MF_HUGETLB_ALREADY_POISONED;
+
 	head = raw_hwp_list_head(folio);
 	llist_for_each_entry(p, head->first, node) {
 		if (p->page == page)
-			return -EHWPOISON;
+			return MF_HUGETLB_ACC_EXISTING_POISON;
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
@@ -1955,32 +1959,30 @@ void folio_clear_hugetlb_hwpoison(struct folio *folio)
 	folio_free_raw_hwp(folio, true);
 }
 
+#define	MF_HUGETLB_FREED			0	/* freed hugepage */
+#define	MF_HUGETLB_IN_USED			1	/* in-use hugepage */
+#define	MF_NOT_HUGETLB				2	/* not a hugepage */
+
 /*
  * Called from hugetlb code with hugetlb_lock held.
- *
- * Return values:
- *   0             - free hugepage
- *   1             - in-use hugepage
- *   2             - not a hugepage
- *   -EBUSY        - the hugepage is busy (try to retry)
- *   -EHWPOISON    - the hugepage is already hwpoisoned
  */
 int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 				 bool *migratable_cleared)
 {
 	struct page *page = pfn_to_page(pfn);
 	struct folio *folio = page_folio(page);
-	int ret = 2;	/* fallback to normal page handling */
+	int ret = MF_NOT_HUGETLB;
 	bool count_increased = false;
+	int rc;
 
 	if (!folio_test_hugetlb(folio))
 		goto out;
 
 	if (flags & MF_COUNT_INCREASED) {
-		ret = 1;
+		ret = MF_HUGETLB_IN_USED;
 		count_increased = true;
 	} else if (folio_test_hugetlb_freed(folio)) {
-		ret = 0;
+		ret = MF_HUGETLB_FREED;
 	} else if (folio_test_hugetlb_migratable(folio)) {
 		ret = folio_try_get(folio);
 		if (ret)
@@ -1991,8 +1993,9 @@ int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 			goto out;
 	}
 
-	if (folio_set_hugetlb_hwpoison(folio, page)) {
-		ret = -EHWPOISON;
+	rc = hugetlb_update_hwpoison(folio, page);
+	if (rc >= MF_HUGETLB_ALREADY_POISONED) {
+		ret = rc;
 		goto out;
 	}
 
@@ -2029,22 +2032,29 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
 	*hugetlb = 1;
 retry:
 	res = get_huge_page_for_hwpoison(pfn, flags, &migratable_cleared);
-	if (res == 2) { /* fallback to normal page handling */
+	switch (res) {
+	case MF_NOT_HUGETLB:	/* fallback to normal page handling */
 		*hugetlb = 0;
 		return 0;
-	} else if (res == -EHWPOISON) {
+	case MF_HUGETLB_ALREADY_POISONED:
+	case MF_HUGETLB_ACC_EXISTING_POISON:
 		if (flags & MF_ACTION_REQUIRED) {
 			folio = page_folio(p);
 			res = kill_accessing_process(current, folio_pfn(folio), flags);
 		}
-		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
+		if (res == MF_HUGETLB_ALREADY_POISONED)
+			action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
+		else
+			action_result(pfn, MF_MSG_HUGE, MF_FAILED);
 		return res;
-	} else if (res == -EBUSY) {
+	case -EBUSY:
 		if (!(flags & MF_NO_RETRY)) {
 			flags |= MF_NO_RETRY;
 			goto retry;
 		}
 		return action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
+	default:
+		break;
 	}
 
 	folio = page_folio(p);
-- 
2.43.5


