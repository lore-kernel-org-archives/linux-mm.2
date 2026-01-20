Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7321DD2629F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 23:23:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FAE76B0089; Tue, 20 Jan 2026 18:23:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79E186B0088; Tue, 20 Jan 2026 18:23:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 685B96B008A; Tue, 20 Jan 2026 18:23:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 51A356B0005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 18:23:03 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A800B13BA63
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 23:23:02 +0000 (UTC)
X-FDA: 84353919804.23.D862001
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id E9104100008
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 23:22:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=b4GCU1zl;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf14.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768951380; a=rsa-sha256;
	cv=none;
	b=oIkjfizFZhdd4n7ckPETIRpnT6AM3IvSQ5+fQHW61qDDE3YHWICtv/WWHu5LaC4NcbffFG
	KXCmcAmTxNEG/ClKhrHWn8KAs25ynizOKtdRcfLEUWHQDIxCHza4B9jbE7tdnmRy7SoUIO
	K2RuPYUyZ5JW3gHbqu7C3SNYyk7zEOo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=b4GCU1zl;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf14.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768951380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Ri9LKs1GkXAginxjs10SnHgdsvzW0wJ1YxkFkXLVE7I=;
	b=mMpSlkvozaq3FUvUFqqpbAt0tX5tJQbbGv+4ygVbwG47t8BE1WWrWe+ZlmYAvs8EhgCOmi
	LEouC1/bqEdyepMuP5yUeK2KJzWFthoiERUa5t/25044EZoWTwMRpBeWMfurIkc5H9VqAu
	JNToM7qign1srRA4g351yZdSqpas2h8=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60KIcfgI3029078;
	Tue, 20 Jan 2026 23:22:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=Ri9LKs1GkXAginxjs10SnHgdsvzW0
	wJ1YxkFkXLVE7I=; b=b4GCU1zl/58MfGXoBIPxBiHrD4yOpbJTrjumVYH+/bqH9
	osx8KawcU+/r4V3y5DSmmHiAnske/WaV9x/EMETGZ7JbbTK1onnAZLirqSKm3eHo
	aS9pDabSuRDEH26BxaPScolWZ8nDUsmtgKnwcsbUYMMTCo72vnBCJmrTmqhHTjNB
	30UQYQ8sqUzYx14YiuhDzu6krHxUbyLvQxbfqaNKlpL8gufDumpfIoC+rOIevaqh
	vLIX5clAKFaTTBis32I+Hz1fGT8ghX7Ofeb4bvHF3hsrp6uNoDz6P16OKez9it90
	z1hMtzilF8I9xzwwSzBjxKuwsOF7S3vBFMIeQrXMw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br10vvq3p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 23:22:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60KLfKiX038819;
	Tue, 20 Jan 2026 23:22:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vad3e7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 23:22:40 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 60KNMHJN021675;
	Tue, 20 Jan 2026 23:22:39 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4br0vad3dm-1;
	Tue, 20 Jan 2026 23:22:39 +0000
From: Jane Chu <jane.chu@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, stable@vger.kernel.org, muchun.song@linux.dev,
        osalvador@suse.de, david@kernel.org, linmiaohe@huawei.com,
        jiaqiyan@google.com, william.roche@oracle.com, rientjes@google.com,
        akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
        Liam.Howlett@Oracle.com, rppt@kernel.org, surenb@google.com,
        mhocko@suse.com, willy@infradead.org, clm@meta.com
Subject: [PATCH v7 1/2] mm/memory-failure: fix missing ->mf_stats count in hugetlb poison
Date: Tue, 20 Jan 2026 16:22:33 -0700
Message-ID: <20260120232234.3462258-1-jane.chu@oracle.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-20_06,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 phishscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601200194
X-Authority-Analysis: v=2.4 cv=H4nWAuYi c=1 sm=1 tr=0 ts=69700e40 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=i0EeH86SAAAA:8 a=eNCGLCvYlAB2plI-01MA:9
X-Proofpoint-GUID: 37hazrsIXyX1TmmLzKk5chTnjiE66l9b
X-Proofpoint-ORIG-GUID: 37hazrsIXyX1TmmLzKk5chTnjiE66l9b
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIwMDE5NCBTYWx0ZWRfX8SdZTa2JdLkD
 yyojOYTBjGcEYBLP6uG9N1HRN6DUj/OXJUiRu7OIoYQaPCcW3sJ/XFswCtzEDJLTI6AWiu6fm8e
 aoIoeOSRBqeTXit6/Q5Zik6jrWpCAhaP/kD9w1ygPH5So6eQpQEXVCXhWiIqMdiGwpHurO/ORN2
 CENlr8EOOBSEn7E2CoEi85A/9n2KpQ0D9qPxvt+69RfA5fiQcGV+VFCbTBuuVeXhN1AE4qRPVqC
 MbRIq6Zmbn7NTB8edhhuHn/P2z7Z2UnEKYPVM44FXjS2LUhnBbypw0F23/8PTq42jWCYxbqkLvy
 zcIqHYjHJ7ArJ5KF89CBjg+oSJ3igHJsXFdSpG3ym8wvg92J2KJwgTkNU9QSnD6Rr4HxPHeKRij
 lI3z6hNNR94wG82DD+/ifPCtCE2hSIufExLII4BhhWUWI80mbJ9h7heRiFb+/RrkXMNhzim63zt
 BQR8eF2JmZONe6bseCQ==
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E9104100008
X-Stat-Signature: 1gdduggat9gcmygched5f6aq7c7un7an
X-Rspam-User: 
X-HE-Tag: 1768951379-369918
X-HE-Meta: U2FsdGVkX1/R4buYZPmYsebrUOEK4WLQd5tDQyYb27C/6AwzVcbIHvj3xR6Yzk9UCf74zwWMcb0xW9HGo/wrzVjGsMCiLFor5Gz3YsUdJ/3gjHW83eEZuvBSeIZbWqp6/99M+XYJlMXdmEPHjudY4Vuvxr/cnuM/UifY3S0qlR7MecK+UnkdTn4BDNvMolMJ0k+UDBcY71NkWR3pnCPZW4tLtDM5vGHEwCvwTRdLZT8Q6xDtZFUzRZNWle0FyCAP23u0uNBH/hVJk2EoCivN7C7JkflJ8HRxgNN+JkZ4FRIt6Vk87HrEc9xkLQvQCQLejiMsv9G8GRsVosMVrn7sC9XsWqnMzlVZ20TbjLdNERvm43G/RR2Ho8DE3yQ+FkYS0IMIb0C6O+93/Kp0R1jJQEddCBIqsHdF2M8gnYSDJLrzBzj+hIAV/vnFUn6O2ulInzXLI2UkzJbTvEpLlk9gXjQH+c3dsWE/66uBtxD87adngs7BGTslJ1JwKIirQPTEHmXGUjJdEVrKvLFDqqdYOXXF5phSC5vNtlqFlPtCE8S/7bJnNTT0/+v7oAuq54VdXvfrKKt1VtXN6y3NA6w5pzFwyXPBMhHJro83Bm3iXK93Mj/bXgu6YhR+9mIK8gIgt8dsYdarlaOkXJCaSd3lUuAqvgTmbcepgIe40FOuOcTxQXBWHj0GePa+60jDvGnQK9A0KdJTjTbhu9VP07F3OrGS6m/Jh91ONDxtsuq1Ti6fU5yTo3ufSaOxoMDBot2SnAocOUGpOjmQ/QEeyQcSdyxtMQmDbXN9P0QcEJrm5UKnLKpQ9pyg0lvuEABBNSyAoIYNEkFjvF/+Jq6SRODG8kJoUAumvdqqOJYOlzdM4UTMQL9vVsc/s1ev7FBQKp9pKDMeClygB/FCBIffpp0nTKeGsdDRW7ppkCbZ271DeVOgG6sFvbpfg5MY/m5lNYCs71jPvpJBFClwTfOCsVT
 j1/N5iiM
 kcyyH9APf5khQfNL5oebku+Nq1n6mKAS0lBARqtNF+HUV2RU3kIcVtxaZbcNQIbCkIYdtUiM5kVFywF4lpD2JfAegWppIdbUPuhdBFFldADGBCyT1pGVbJJdA3az6Y76unPWcmVLr0T6vTQwSGi0Bk5RrVYEdzfp42LRgyWgotS1L8HVR3rCxRUNlOq5RRa6pJW1jyt4Un4sqU3511jfqXq8yxSiPiX7VlfDKny+7Fv+KsZJE7b3/YQKYC3WCaVGe7EX43Ie7Or10DGUF49fK86G0bcrjOF2oU41Dw5XoQQ75/ZBiksoE1i5Iu+gFgS3xQxl5xn5o2JdDhyys3hrSrgP16DtW/C06JIuwIBEJmU3ZJ+k=
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

Fixes: 18f41fa616ee ("mm: memory-failure: bump memory failure stats to pglist_data")
Cc: <stable@vger.kernel.org>
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
---
v6 -> v7:
  collect acked-by, fix nits pointed out by Miaohe
v5 -> v6:
  comments from Miaohe.
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

---
 mm/memory-failure.c | 93 +++++++++++++++++++++++++++------------------
 1 file changed, 56 insertions(+), 37 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index c80c2907da33..473204359e1f 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1883,12 +1883,22 @@ static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
 	return count;
 }
 
-static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
+#define	MF_HUGETLB_FREED		0	/* freed hugepage */
+#define	MF_HUGETLB_IN_USED		1	/* in-use hugepage */
+#define	MF_HUGETLB_NON_HUGEPAGE		2	/* not a hugepage */
+#define	MF_HUGETLB_FOLIO_PRE_POISONED	3	/* folio already poisoned */
+#define	MF_HUGETLB_PAGE_PRE_POISONED	4	/* exact page already poisoned */
+#define	MF_HUGETLB_RETRY		5	/* hugepage is busy, retry */
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
+	int ret = folio_test_set_hwpoison(folio) ? MF_HUGETLB_FOLIO_PRE_POISONED : 0;
 
 	/*
 	 * Once the hwpoison hugepage has lost reliable raw error info,
@@ -1896,20 +1906,17 @@ static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
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
@@ -1957,42 +1964,39 @@ void folio_clear_hugetlb_hwpoison(struct folio *folio)
 
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
 	bool count_increased = false;
+	int ret, rc;
 
-	if (!folio_test_hugetlb(folio))
+	if (!folio_test_hugetlb(folio)) {
+		ret = MF_HUGETLB_NON_HUGEPAGE;
 		goto out;
-
-	if (flags & MF_COUNT_INCREASED) {
-		ret = 1;
+	} else if (flags & MF_COUNT_INCREASED) {
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
+		} else {
+			ret = MF_HUGETLB_FREED;
+		}
 	} else {
-		ret = -EBUSY;
+		ret = MF_HUGETLB_RETRY;
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
 
@@ -2017,10 +2021,16 @@ int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
  * with basic operations like hugepage allocation/free/demotion.
  * So some of prechecks for hwpoison (pinning, and testing/setting
  * PageHWPoison) should be done in single hugetlb_lock range.
+ * Returns:
+ *	0		- not hugetlb, or recovered
+ *	-EBUSY		- not recovered
+ *	-EOPNOTSUPP	- hwpoison_filter'ed
+ *	-EHWPOISON	- folio or exact page already poisoned
+ *	-EFAULT		- kill_accessing_process finds current->mm null
  */
 static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb)
 {
-	int res;
+	int res, rv;
 	struct page *p = pfn_to_page(pfn);
 	struct folio *folio;
 	unsigned long page_flags;
@@ -2029,22 +2039,31 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
 	*hugetlb = 1;
 retry:
 	res = get_huge_page_for_hwpoison(pfn, flags, &migratable_cleared);
-	if (res == 2) { /* fallback to normal page handling */
+	switch (res) {
+	case MF_HUGETLB_NON_HUGEPAGE:	/* fallback to normal page handling */
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
+	case MF_HUGETLB_RETRY:
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
+		WARN_ON((res != MF_HUGETLB_FREED) && (res != MF_HUGETLB_IN_USED));
+		break;
 	}
 
 	folio = page_folio(p);
@@ -2055,7 +2074,7 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
 		if (migratable_cleared)
 			folio_set_hugetlb_migratable(folio);
 		folio_unlock(folio);
-		if (res == 1)
+		if (res == MF_HUGETLB_IN_USED)
 			folio_put(folio);
 		return -EOPNOTSUPP;
 	}
@@ -2064,7 +2083,7 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
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


