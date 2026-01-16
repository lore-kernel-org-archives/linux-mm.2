Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D1B5C982C3
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 20:39:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4385F6B0089; Fri, 16 Jan 2026 15:39:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DCD86B0088; Fri, 16 Jan 2026 15:39:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A3106B008A; Fri, 16 Jan 2026 15:39:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0DE666B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:39:48 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8ECA48ABE7
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 20:39:47 +0000 (UTC)
X-FDA: 84338993214.23.3BC9FDD
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id B9EE640011
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 20:39:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mG8dA9Mj;
	spf=pass (imf27.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768595985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CYhx2+L8SUPD24gntGDvUf46GCmRyG0HGntDKg/z4oU=;
	b=up23xJLBP4Dmv1PYRO4XwgTpg0vkqatreyIpt8tiUZgdBctU4zJlHSrJroJ98WGB449g6f
	hKcDTzBNx4kRm7w/M093s6gb+FNKjGhBgTDG9mkAGNUMro3w57l2HegG6IQ6Qd1EDfMfEJ
	GOYTVNDRQriZUNwX38MCWyDvNCQBiUU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mG8dA9Mj;
	spf=pass (imf27.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768595985; a=rsa-sha256;
	cv=none;
	b=WyJdbAvNW+l8ejhorVgcnElJ8HlwJvi8WMnqG7i+2LPwcy5zRmJVfKBIzakPUK5yJNZQaT
	vcc2BGNHcj9103GzcJ06jSeKfyLfuZmLWevdvQMgY42K1A6MSf9G0v24cPuW+L5CQwYgss
	LDz12LWNfJ3+VU8+LEZGSDJsvvH/krM=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60GKYTJL366908;
	Fri, 16 Jan 2026 20:38:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=CYhx2+L8SUPD24gntGDvUf46GCmRy
	G0HGntDKg/z4oU=; b=mG8dA9Mj+95gd6sAxltQwGoWswp6XZEyFxQ4rKIcrP2Wn
	WOubsOsBBaUBPtgp7QxO9AjogI+WtvWc8n1sFwpQ3/pXTKnF1fUfwxVMuX0z+JZL
	ojkvRWG6VKhyWHB5CuMXpf6aVjpGwvW1t4rcNy0Sj9WnIRTLYf2VhOaOnp/4a0wd
	tyewD5beDgOd7My+W6kHPyh22xcYFZ7cDf5VAKjdJfpEI/gUE9BfXT3uHjGIkEQV
	WVOTzmy8H2t1aB0cqXJdirJdSh+OBO3ACkafvnDv6p80jfrqMWtCtNA5L4tlfDd6
	HLZnkDQf7UoAZ8HIihDwXsDqoekXOfPwcdTIq7uNg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bqvfng0jb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 20:38:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60GKKiUE010818;
	Fri, 16 Jan 2026 20:38:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bqv9m0gfd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 20:38:48 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 60GKclNL019846;
	Fri, 16 Jan 2026 20:38:47 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4bqv9m0gen-1;
	Fri, 16 Jan 2026 20:38:47 +0000
From: Jane Chu <jane.chu@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, stable@vger.kernel.org, muchun.song@linux.dev,
        osalvador@suse.de, david@kernel.org, linmiaohe@huawei.com,
        jiaqiyan@google.com, william.roche@oracle.com, rientjes@google.com,
        akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
        Liam.Howlett@Oracle.com, rppt@kernel.org, surenb@google.com,
        mhocko@suse.com, willy@infradead.org, clm@meta.com
Subject: [PATCH v6 1/2] mm/memory-failure: fix missing ->mf_stats count in hugetlb poison
Date: Fri, 16 Jan 2026 13:38:32 -0700
Message-ID: <20260116203834.3179551-1-jane.chu@oracle.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_07,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601160154
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDE1MyBTYWx0ZWRfX6zz6xM25b7eW
 sPtKmiMzVr6wXbjHbVEqz2oxhxt7n+hJ5R9obLE5DGB2+XcdZZ+2wUSthnLQA9Dk3cZerPrw2kv
 ncE/1Xt3PoEYz4uPNtqvazj1LHI0zTmYsh3y7RIsn2Z5J8uARZ5g8mSgBUfxw/02nqTNkka8XUM
 05ioam0FIbSbuaoU/L07y1FKc1TI7g2S3uqdTf8cH8MckDlYsUVulOsz0BgTbPq4joHoKNTN9dp
 uERGy7RwBYH3eODbal3oU8aX3+/L56HVn2fixUkVxLcDLHiAOss0cnW9UCX7rY+nS6GFFNcbhUT
 Sw0HYHASnHWYuZ4ZrubwD/Kvmr5yKLiXNvIQqVRdifTXGHIQnSP1Nnp/uEQulQbxp0a3SoPHKjX
 vIm2tLRYY5rgHLOhOp/hlcjJnfecyo/ATuyEmu+iaIT033rMZN8LmV7znrFVwMCzLDOdXtUT/Xr
 IfaTkehX9alC3Hp/+cA==
X-Authority-Analysis: v=2.4 cv=POoCOPqC c=1 sm=1 tr=0 ts=696aa1d9 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=eNCGLCvYlAB2plI-01MA:9
X-Proofpoint-ORIG-GUID: 1RTaihLxBbo-OhEx4-0Yfpj5OtTcUTr_
X-Proofpoint-GUID: 1RTaihLxBbo-OhEx4-0Yfpj5OtTcUTr_
X-Rspamd-Queue-Id: B9EE640011
X-Stat-Signature: 4jdx7q5gi5ewqh6awzbs9be6niqx5azy
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768595985-250594
X-HE-Meta: U2FsdGVkX19pLTxKIi3FRHUuqQ27o2KWcHi6a+BHm3X8HtCNBJLBUTJPaTXoXUSVwhesPlhAFT5r9Vxqr4VypcQOd4H67TpQTpVpAmABDA2HBfMxpUABX7mQ1wdMqwXREc5pr7cZBIsGCMS6x6L9+/YzEme9i3dGcl93rSuKzU1pMegv0nLdV8Dqrf2P5HyYvbmNDM4yENWhi64y3rEEIKb4/HeCgBx2d3EyR8KbRXI07tDH1bnEXxZAuDMoj3vMLyj3EgdPeeO81vL5fnsXKt8hrceW+yTef6Zdbm4FhpnPW1/AoyMeHf73fkfUKHtukupmvR4kIia+mpmePMPsK2yANv0n+JhHOHutuBeJfW/IZJPUnV7QbTmX4k7sFV+n3XMItDn7Iviw1VdvKMcyhRaOyqQCTN93MwzjXmUhExOD3j2UMQl6Fzoefgwm8IIi1yrzuYr/BTvPmpWgw9IkfknjPOWSKSVVWmIOZgi96PzVnkrTmeg+61vMeiQ/9CldypDzFb2jw5kqPCtWOixqt740C8xq9HSqLTFVJ0bmcFRBWt2BPGGF42ooSpE21Wu+UHOcyCCnaVfVe4+b43JJDaaV+uogn4/8St1iz7cbQza/3+x3/mkhJ6oxHrAN0GAx2rMdSSNM/cUSnCYYMoW5WtyLaJX/vUpc51NJ7i98a/CesKACn4Izr16dXetMZUS0VPZCHvZ+nIpvc9ZGv6v4oeDSiC9C++EOxFC/jg/bfT+YPRHZBKbHr0XPvDpOHbbY7enY6dOGG6kqBzJCYgVaXoliJnr535T4btZuX159CA7mWF3BZBRfPSeicjJGOVAtd27B2SpeKUhPBCXuG/+XKnSEDp4VRjyEOL1SO4rfIXOrjmolPtqwsoaC2x1ZPH59pRMpJBiCqXJx3Ze8PicsN40649satVwoBflxY+/KrdtFZqvYnxEHINmeaETNSEQF
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
---
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
 mm/memory-failure.c | 91 +++++++++++++++++++++++++++------------------
 1 file changed, 54 insertions(+), 37 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index c80c2907da33..49ced16e9c1a 100644
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
@@ -1957,42 +1964,38 @@ void folio_clear_hugetlb_hwpoison(struct folio *folio)
 
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
+		} else
+			ret = MF_HUGETLB_FREED;
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
 
@@ -2017,10 +2020,15 @@ int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
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
@@ -2029,22 +2037,31 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
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
@@ -2055,7 +2072,7 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
 		if (migratable_cleared)
 			folio_set_hugetlb_migratable(folio);
 		folio_unlock(folio);
-		if (res == 1)
+		if (res == MF_HUGETLB_IN_USED)
 			folio_put(folio);
 		return -EOPNOTSUPP;
 	}
@@ -2064,7 +2081,7 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
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


