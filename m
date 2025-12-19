Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DBD7D78770
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 19:16:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1B7C6B0089; Fri, 19 Dec 2025 14:16:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC2196B008C; Fri, 19 Dec 2025 14:16:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC09F6B0092; Fri, 19 Dec 2025 14:16:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B973B6B0089
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:16:27 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2D140B83AE
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:16:27 +0000 (UTC)
X-FDA: 84237176814.21.82C8A0F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 39C7F120012
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:16:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EAvUJWcz;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf29.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766171785; a=rsa-sha256;
	cv=none;
	b=THoOrUC/9X/IOM+ysLXqFsVEDwuz9Je8vX+H47EiybfCswX6BYrkLarDmxOZPd/Ky0RbdI
	yEQt4V68m64M7yXFKTQxI8y8iqhCBJjcoOw3a5uWxX+lFz4jAPdbBUPa4KyJ9EjSiEhb1h
	njJxLsxfGV9zU/Ko/6SzwDD29JgZx0c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EAvUJWcz;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf29.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766171785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xQZOjOLqndItDxSuuICusJe4gUprjMDmTGesnzlyh7Y=;
	b=YV6kPQFPQbHzk4m54PdEA4w1h6WS3NWXA8IIlXhWWWcJqBum1aZkLDfmengw5USMwQLR0H
	xSwhkv+tbkrgWzgZD6kx39o28s2NB2dDsS8HTucb7k7j1hSZjuw2EMyElwpdI85B4YiP2x
	tzT3d5x1NhzYYA9hPF/EYccMIP26nF4=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BJJCG1M239035;
	Fri, 19 Dec 2025 19:16:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=xQZOjOLqndItDxSuuICusJe4gUprj
	MDmTGesnzlyh7Y=; b=EAvUJWczU3KZmpDENoU1rVm6BEmCh/lADK3UGE3pYCJfm
	gYkMewkWHn4bSU269POXPIr6RYGSdklt2zDgBlbdbw86Ao4fu8DzjvhWkn/RP9Di
	XOOPA3ICDUFGfqShJJjNtmaD1V9ta/SGhs1SMdRUlGCJF3Dj9gH97zFbcEB+MHV/
	JoE9Dy5gHBeKBvOAkC/BzskCAlvOgjGUiulH5Er/DuXeL7V3d55ZwEPArrTlagSg
	/V1xv7wu6zkb1p45Z6wwKPKMfRlbdjyHyR7Wah7ai6GMOTfOkEdWKBjLxaALIfrN
	071T0oH0pgNyzdwDgYVusbMDtnUHVzNiK85lu8y+A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b4r291mtw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Dec 2025 19:16:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BJJBerX034854;
	Fri, 19 Dec 2025 19:16:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b4qtdvjju-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Dec 2025 19:16:13 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5BJJGDK4028211;
	Fri, 19 Dec 2025 19:16:13 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4b4qtdvjj1-1;
	Fri, 19 Dec 2025 19:16:13 +0000
From: Jane Chu <jane.chu@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, stable@vger.kernel.org, muchun.song@linux.dev,
        osalvador@suse.de, david@kernel.org, linmiaohe@huawei.com,
        jiaqiyan@google.com, william.roche@oracle.com, rientjes@google.com,
        akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
        Liam.Howlett@Oracle.com, rppt@kernel.org, surenb@google.com,
        mhocko@suse.com
Subject: [PATCH v2] mm/memory-failure: fix missing ->mf_stats count in hugetlb poison
Date: Fri, 19 Dec 2025 12:15:58 -0700
Message-ID: <20251219191559.2962716-1-jane.chu@oracle.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-19_07,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2512190161
X-Authority-Analysis: v=2.4 cv=WZgBqkhX c=1 sm=1 tr=0 ts=6945a47e cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=0f2F8jj5qo72ZdTnQt8A:9
X-Proofpoint-ORIG-GUID: AJaM2KpF6RXVrX7m5onzSgpPauQZeLvK
X-Proofpoint-GUID: AJaM2KpF6RXVrX7m5onzSgpPauQZeLvK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE5MDE2MSBTYWx0ZWRfX4IhXefT2nOw0
 JivMV3mtwoxrk0TbHY4W6YiyYW5BlptMqmYvVUi5ZeOxoC8+EAtk3kh1Y8plPQfPz9yDQGZAG0G
 L3lgLFPMPZTuPYhAVHytjWLo+VFt16TGrt3kNa04nO/XFtcJyf3wcoXAOFZfiPk3ZYGE/eYv3xK
 JVUeBi9sqdpJPqajn7P/cLCZPbSHQGTlBVdwXz7JuFCVpxQKkNVt92u/ENUHfVfhy3fjXWe4Um0
 Y6SQ/QFL4u5nuFvZi3YMUDGThezskxIEGZ5z5xeROCfIX+p6UDVwylFd1erYuR621AuqLhV5U/B
 WM6rFHN+zin7eZ622EDb+ut+prihC4YmCZjUT2/1BK3FPeUDO1R+mBFD7swSZmmGzMkRZoJYJ1X
 0NkRkJX4w/0pWdR3rXfUK1JLHkWbHx21zOZB92aKq0o7CipDXM1pIf3/1Uq8aXg8rDAupo8+GCT
 6EzwRq0R5sw6+IFuohA==
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 39C7F120012
X-Stat-Signature: 88bbkuw838aisxnrxidn75sx7ngsdkme
X-HE-Tag: 1766171785-336460
X-HE-Meta: U2FsdGVkX18wsbImK9XQMRntKhBYFT3Oalw4ne9hliM9WAa02N+DNBGHmJTM39aagJHFvBMZp1c5hgpqc6S8XUmOlh+hkKJumrBpc/USeK7sN//kAISHwPriJ0GM1SIgy4H6mlPU5UqyDf3PZUsq0venmfhcu9VYf2RC+SUMzzdMgFLh2neeARZYRVHvikHjP7jWmU1hKKB4rfcFTGL0Stmzai0drPjYTkm6xKw+AjavTCO3NZhUC74yCthkwxn25qk5Zh9n0bTeSgy/F69DdbAAJwpCe84g0Nz8yhc59y7SVLxe0UpLi85qnqfaLHDz22qy9ZjseLY9DokptE6a/9ca2bdHq3lsMvmF9y0PJTRUxw6Tr9c1cCnnLzoe3LsEDHzL2B1CpO9RZjpfcCNouVoXYwHOiIRs3TdHLnz+S7PkhJICc8eyJ5DGcPYB19GFsL7iMo76e8JHcoBUUM0FqV5FxI+nOjrNEvg01Kdc75mO+JAqEdNfSoqmbmKBJEeLf+mFIHMJj3wliWPUWf6Dx2AqM6P1tnFWcSpQAew1SBcN5b17f7pN2VoCfYhv0ldHjzQ1BgD8mLlk0DRlwoQe0zwNdZbk88nDGAKN4tf/oWppiO3506G3OccNHuUEsufYVYRjS0DdRRNkDfwH5xfo7OSoOMVd1sG2OwRmVPWyTyJRqWRy2RzdYj/IFRKt0Qh8kXcXDaXkyI9HHnlqt5IV0I+34H0hcHutbjdu79yUQJPFfpt4hb2laql2SBj8VGPu+gnP4ppV9pxMc4rf6OSfckYMvS3jVnnZnfkccc2ihRe6UZZia+QdmlCurlkJqdvn3b2C98dLSELX3G/BTJlQETDfeaD+SHF2XHxtIx1ij3BEzsWikkT/9+0FOiioDAcMD84BKKQ4VW7BvvdQvk5QmqqPIawn9YdbIJd2iuqCNOpRKtN5opxqtqhVrxEaB8Dmh2JnX4fKKr46qN1tMV4
 lTWWD1jg
 jWBZICc4dYFliZFnxrsUM+ijAHzFOo3vnP63bd+00OeQm4Jj18ieL6m0gXAAGn0ess1EyGa0GZMOel9jUTZ7JUCP7IZZoWrqcgD39+dxr1gWYlBTvV14ZA8b7AWMYYIwo0ksNy2WDuo2nORKWJFk0z1tKxwL8DDCQnDlhHPsmAoqlMnHid4loEBFLQ9TcM7DE5dyA/LbwbWasbd5xa2mF8nSwALwxfsDWFepMR39wJM3PJoMe5rdwpZW2d0qP1OrgPBuFBuD46efNd/Se/ss8TOiVrfN1iPOoct5MEslUQOZNxig=
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
index 3edebb0cda30..3eb9d23a4ad0 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1873,12 +1873,18 @@ static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
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
@@ -1886,20 +1892,18 @@ static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
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
@@ -1945,32 +1949,30 @@ void folio_clear_hugetlb_hwpoison(struct folio *folio)
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
@@ -1981,8 +1983,9 @@ int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 			goto out;
 	}
 
-	if (folio_set_hugetlb_hwpoison(folio, page)) {
-		ret = -EHWPOISON;
+	rc = hugetlb_update_hwpoison(folio, page);
+	if (rc >= MF_HUGETLB_ALREADY_POISONED) {
+		ret = rc;
 		goto out;
 	}
 
@@ -2019,22 +2022,29 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
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


