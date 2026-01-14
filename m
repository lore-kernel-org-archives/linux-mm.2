Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5C43D3901E
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 21:38:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 038726B0005; Wed, 14 Jan 2026 16:38:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 010306B0089; Wed, 14 Jan 2026 16:37:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7F526B008A; Wed, 14 Jan 2026 16:37:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D51606B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:37:59 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 691AB85C34
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 21:37:59 +0000 (UTC)
X-FDA: 84331882278.15.C2BDB11
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3226B20013
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 21:37:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=C53SErXl;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf03.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768426677; a=rsa-sha256;
	cv=none;
	b=mn0zWsXFoAtx1vIxtlKCKcJpf+Y27CFLTbJxiuHuEXpPRKIRJ2O1rYluFpKIczgZFK4lII
	sfqsnUWotnEauFLZAFlz53E7zwjvzEoTfr+kctpsb7ntlxSHbHXCS0dfYiJ6WnU1ptlyAd
	Tvlcm9UtHDZzMVxWzIcKIaAyqmWH3+s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=C53SErXl;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf03.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768426677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=18YzkJv+BMR4dTIOyGBahLzPOB/W8jBU2Q4X4jwASPE=;
	b=xw9sQ6MgBgR7MERxm+OhuFw55OjJb2WX/K86xZnA7NKAwtYB9VybQCFMC2odJdEFqVtzof
	eigiLY62DKAponOgvq65XG5WYPZ7VITqWgJLYR6AxsNG+hiXafbjrVfTV56wSmOHGGl8gj
	clXonrnn4SiU7UdxkTH8Log9VLkHbMU=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60EHvxI32418908;
	Wed, 14 Jan 2026 21:37:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=18YzkJv+BMR4dTIOyGBahLzPOB/W8
	jBU2Q4X4jwASPE=; b=C53SErXlLarEOaMHWn7qKy8f5naJ19hlGO68hR1GXopuI
	r8ZgX0e3Px+rIvB1wPryoxxh0rkztxxRN8I89eJlznTo2gKqlhSlic9ZD0ngyAEz
	QO7xtoKOOTBQ9GgLLZi3/iZJN68qN73JZHxBr+rxNQscO15pwgR5my9tu1eVCOsR
	WLUdrq0p0zitB8VhTKyc7VX2QpVK8VuqZHnOscZaTU7Ezm378onVFilvmQD6eRmq
	1+bEzzcEHiLGNznH5uQCLVMxotEOvBbcQre9oJFgz7PHQgH/M0HXt/TJPoRrHcDj
	LMNEKAl5gae2dSkN3YJfBbM94K9HyYP19qKV6wKoQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkre3x21c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 21:37:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60EKuCvk005627;
	Wed, 14 Jan 2026 21:37:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7ab0yk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 21:37:29 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 60ELbSxL024482;
	Wed, 14 Jan 2026 21:37:28 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4bkd7ab0y3-1;
	Wed, 14 Jan 2026 21:37:28 +0000
From: Jane Chu <jane.chu@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, stable@vger.kernel.org, muchun.song@linux.dev,
        osalvador@suse.de, david@kernel.org, linmiaohe@huawei.com,
        jiaqiyan@google.com, william.roche@oracle.com, rientjes@google.com,
        akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
        Liam.Howlett@Oracle.com, rppt@kernel.org, surenb@google.com,
        mhocko@suse.com, willy@infradead.org, clm@meta.com
Subject: [PATCH v5 1/2] mm/memory-failure: fix missing ->mf_stats count in hugetlb poison
Date: Wed, 14 Jan 2026 14:37:19 -0700
Message-ID: <20260114213721.2295844-1-jane.chu@oracle.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_06,2026-01-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601140177
X-Proofpoint-ORIG-GUID: n_Yboqb_Qr2DYdzSGGNpNI7DWm-HTnzp
X-Authority-Analysis: v=2.4 cv=YKOSCBGx c=1 sm=1 tr=0 ts=69680c9a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=eNCGLCvYlAB2plI-01MA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDE3NyBTYWx0ZWRfX21s4PQyjEzDf
 klpI48V0ittV+BUJ9q9dY9SuFGZQhZtUXfQAq+ijNPv419qIHQrFyByN7aKnV8U1zhVzYlYefiw
 SF7xiDyOcpvx48uhS12ZGYA/uV8lnfXAsGEqzksFtKAwzUpxEmdfZIBBfaVLbuXZzR2x3xXsZhq
 2CIw1kZby7AkFbfVtfTublByWvwdmCouTdqfFE3as5nsHwkL6jzX0n1HDeyNtwQaln/95+mBrSc
 8ihNQMQbEZLQb4IhKzOcuL1XsjNKtcLQT0ZWKyC8vNjHL/fzAaB8RPbeC0fACB8WACFknI8S7tL
 +RGJUYkdKrT4uhIsXIWHS3OOXaTzOOgEe7Oub95uyYw3RW0dBuoSUrsiYo2kGuLHRxGkNipRbA2
 aYQMt467Qwi+SmdVP2g9kYadjGqdgI159xXmLUFqGSmWjM7XH3tRHTe5MLLj5fV0XfrvZRd4412
 /B1rE9DkJtLvKJDBcNA==
X-Proofpoint-GUID: n_Yboqb_Qr2DYdzSGGNpNI7DWm-HTnzp
X-Rspamd-Queue-Id: 3226B20013
X-Rspamd-Server: rspam06
X-Stat-Signature: 1cmonuytguwhwat4ixq3ks7rkzct5kb7
X-Rspam-User: 
X-HE-Tag: 1768426677-854522
X-HE-Meta: U2FsdGVkX1/JeNjbfgpP8a9swYashDgzJzKg2XadzQ+mf4QgVP+PEOSIyhq9tQLuRk3+zhVXD41aD4O2f5+9aWc6Fh+fLG+6ryMb7lMtpqPyd5GFEWRyr1qg4ApGUwIq4LqnwJuMvVrao6mbwx1HfTK+bfo0RstE889PhCcaOnGrn4uJ/aFVHt+Zh0+avam/qWfaD25EHpvvLE1mEuEVYGC0BwULJRX5gCkFyL4nTPw5ecjg8I94pf6GUqra4Ff466pLZQ5C4kF3ie8Rll0DpGNB49q5vWtpLakWGWCDexyq9Lbzg+n3USotHGT9aK6/PgUlWwy55+R2hEk/oYJIMAFrm2jCfGrGqsYGXZWDiQLdn5HuYNof0ikLim6neZl4d5O7NT5KqvoOulWaAO2FdtwauCOLX7nR71tiaPsEk30eehWEYVIN4fR+CVnEI3YqQX1gE4UiWj6FB6DS1IhEZ4VBv4g4KLJOBFr+Dgg7cH16ozxletO5nKod3i0FFji+1UgHRvsx5eaFk4kW2eGXqEWByUegaaM4mHcCtIhUmlNN0WCZ1RKATsC+nQ/3Dx+D9MNZ/Fzd4I5Qv1egyeBqEC7ebTIPickpa0YhcjuuJ64ZPz204QePQQgpjBSW/N9SCDK7k+fMFX/joNwUIcEbdTSORfDE0qrjt67NItZwo9DOtCP0qNdMyLHvoeDrHRKlFs+M83WV9qzY/YK0pDlLkDL82XLbEJxIcoFUWkBqafMIby6loaRmBwl1nawMia8CZ7gt5U6+ocuYW1aWJVlK9IhbTmU2JhXwaWgr3qyyneNmtPNAKSJxhFH4eyOKdgZxJPOZbh0zJprYUtjVVmOjO7c4vzK8xcjUM1sN7HnmmlsW1hk4cytoFisThEbG6B6VBwAPbJWWoMrd84iSrbOnU1BnlAxYLKmsLXC0xJVd43JDqQVfMZd2i57WBLlVfiaEwz2YAtNCElXBvlY7joH
 NXhs87mX
 M3e6xLxKcaDfmE7mg7DP/e+cswx1feI3wXyMsRX86GRMMQcLRyOkZQMUY0HZzP1kXxeEXvdcN6HghzgmRID536z54mSVo8Vhjq7A+Z93XLF0zKWOJfcoBQAd/wTyq6hrSbU/r3JSsnN17SpJygAe7oxJIn07tH5A98PN1nxG490yVwB/MWgH+OkWKMAILFAIBM2RWdcoKQWh5Pzy3Cbb9Du8u5mnclc17rZoB9wKZ0/LmKhBxELlsRgI0V59gGB0rvTB+O42PBsMQ+hn8YaQI6MOVEOLwZhAPcSI9376Xi38DsGQ=
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
v5 -> v4:
  fix a bug pointed out by William and Chris, add comment.
v3 -> v4:
  incorporate/adapt David's suggestions.
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

Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 mm/memory-failure.c | 87 ++++++++++++++++++++++++++++-----------------
 1 file changed, 54 insertions(+), 33 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index fbc5a01260c8..2563718c34c6 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1883,12 +1883,24 @@ static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
 	return count;
 }
 
-static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
+#define	MF_HUGETLB_FOLIO_PRE_POISONED	3  /* folio already poisoned */
+#define	MF_HUGETLB_PAGE_PRE_POISONED	4  /* exact page already poisoned */
+/*
+ * Set hugetlb folio as hwpoisoned, update folio private raw hwpoison list
+ * to keep track of the poisoned pages.
+ * Return:
+ *	0: folio was not already poisoned;
+ *	MF_HUGETLB_FOLIO_PRE_POISONED: folio was already poisoned: either
+ *		multiple pages being poisoned, or per page information unclear,
+ *	MF_HUGETLB_PAGE_PRE_POISONED: folio was already poisoned, an exact
+ *		poisoned page is being consumed again.
+ */
+static int hugetlb_update_hwpoison(struct folio *folio, struct page *page)
 {
 	struct llist_head *head;
 	struct raw_hwp_page *raw_hwp;
 	struct raw_hwp_page *p;
-	int ret = folio_test_set_hwpoison(folio) ? -EHWPOISON : 0;
+	int ret = folio_test_set_hwpoison(folio) ? MF_HUGETLB_FOLIO_PRE_POISONED : 0;
 
 	/*
 	 * Once the hwpoison hugepage has lost reliable raw error info,
@@ -1896,20 +1908,17 @@ static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
 	 * so skip to add additional raw error info.
 	 */
 	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
-		return -EHWPOISON;
+		return MF_HUGETLB_FOLIO_PRE_POISONED;
 	head = raw_hwp_list_head(folio);
 	llist_for_each_entry(p, head->first, node) {
 		if (p->page == page)
-			return -EHWPOISON;
+			return MF_HUGETLB_PAGE_PRE_POISONED;
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
@@ -1955,44 +1964,43 @@ void folio_clear_hugetlb_hwpoison(struct folio *folio)
 	folio_free_raw_hwp(folio, true);
 }
 
+#define	MF_HUGETLB_FREED		0	/* freed hugepage */
+#define	MF_HUGETLB_IN_USED		1	/* in-use hugepage */
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
+	int ret = -EINVAL;
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
-		ret = folio_try_get(folio);
-		if (ret)
+		if (folio_try_get(folio)) {
+			ret = MF_HUGETLB_IN_USED;
 			count_increased = true;
+		} else
+			ret = MF_HUGETLB_FREED;
 	} else {
 		ret = -EBUSY;
 		if (!(flags & MF_NO_RETRY))
 			goto out;
 	}
 
-	if (folio_set_hugetlb_hwpoison(folio, page)) {
-		ret = -EHWPOISON;
+	rc = hugetlb_update_hwpoison(folio, page);
+	if (rc >= MF_HUGETLB_FOLIO_PRE_POISONED) {
+		ret = rc;
 		goto out;
 	}
 
@@ -2017,10 +2025,15 @@ int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
  * with basic operations like hugepage allocation/free/demotion.
  * So some of prechecks for hwpoison (pinning, and testing/setting
  * PageHWPoison) should be done in single hugetlb_lock range.
+ * Returns:
+ *	0		- not hugetlb, or recovered
+ *	-EBUSY		- not recovered
+ *	-EOPNOTSUPP	- hwpoison_filter'ed
+ *	-EHWPOISON	- folio or exact page already poisoned
  */
 static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb)
 {
-	int res;
+	int res, rv;
 	struct page *p = pfn_to_page(pfn);
 	struct folio *folio;
 	unsigned long page_flags;
@@ -2029,22 +2042,30 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
 	*hugetlb = 1;
 retry:
 	res = get_huge_page_for_hwpoison(pfn, flags, &migratable_cleared);
-	if (res == 2) { /* fallback to normal page handling */
+	switch (res) {
+	case -EINVAL:	/* fallback to normal page handling */
 		*hugetlb = 0;
 		return 0;
-	} else if (res == -EHWPOISON) {
-		if (flags & MF_ACTION_REQUIRED) {
-			folio = page_folio(p);
-			res = kill_accessing_process(current, folio_pfn(folio), flags);
-		}
-		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
-		return res;
-	} else if (res == -EBUSY) {
+	case -EBUSY:
 		if (!(flags & MF_NO_RETRY)) {
 			flags |= MF_NO_RETRY;
 			goto retry;
 		}
 		return action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
+	case MF_HUGETLB_FOLIO_PRE_POISONED:
+	case MF_HUGETLB_PAGE_PRE_POISONED:
+		rv = -EHWPOISON;
+		if (flags & MF_ACTION_REQUIRED) {
+			folio = page_folio(p);
+			rv = kill_accessing_process(current, folio_pfn(folio), flags);
+		}
+		if (res == MF_HUGETLB_PAGE_PRE_POISONED)
+			action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
+		else
+			action_result(pfn, MF_MSG_HUGE, MF_FAILED);
+		return rv;
+	default:
+		break;
 	}
 
 	folio = page_folio(p);
@@ -2055,7 +2076,7 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
 		if (migratable_cleared)
 			folio_set_hugetlb_migratable(folio);
 		folio_unlock(folio);
-		if (res == 1)
+		if (res == MF_HUGETLB_IN_USED)
 			folio_put(folio);
 		return -EOPNOTSUPP;
 	}
@@ -2064,7 +2085,7 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
 	 * Handling free hugepage.  The possible race with hugepage allocation
 	 * or demotion can be prevented by PageHWPoison flag.
 	 */
-	if (res == 0) {
+	if (res == MF_HUGETLB_FREED) {
 		folio_unlock(folio);
 		if (__page_handle_poison(p) > 0) {
 			page_ref_inc(p);
-- 
2.43.5


