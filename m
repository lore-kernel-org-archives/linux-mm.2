Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68066D29DE0
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 08:08:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1ABB6B0005; Tue, 13 Jan 2026 03:08:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC83B6B0089; Tue, 13 Jan 2026 03:08:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C7366B008A; Tue, 13 Jan 2026 03:08:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8A5846B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 03:08:35 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A5D81601FC
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 08:08:35 +0000 (UTC)
X-FDA: 84326213790.30.FEB11AA
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2450918000B
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 08:08:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rfOQTQJx;
	spf=pass (imf16.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768291713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=M2pHnaFbYyc3u5HyeOUk4EYddLfH6c49c5EKg1ravXQ=;
	b=QpnK7RT8RFfQhT9rbOBpZuY/Vd/tnbcwMNQkWK8gYvo9S0qpUG/ZJUz0tubPVeJ8tfUMSe
	jrJaNmcWQKMXnIZ861UhNpOIg6Fx15yI8P2057/NLO4ZIYO2/uRxRQmPZChbI+SBacQzNY
	RvNxGxfbvLl6Awisjd4Rlpi8Xczmqkc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rfOQTQJx;
	spf=pass (imf16.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768291713; a=rsa-sha256;
	cv=none;
	b=FAciMpXXdLaUC9A5EFW3haLr8Ba1dGbaQqSCI602IhDaCDbiPJUfqmUnAeFU8JZwWLLzOr
	+JQVpWwDzMVWb/9EI/viU96L+uOfDzThJ+oRPGOkrQcYFrwP7VswqFaVfTdT2M2jaboWrC
	JsM4xBUoAK97RdibVAOkejwWS6EM338=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60D1gjdO2735854;
	Tue, 13 Jan 2026 08:08:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=M2pHnaFbYyc3u5HyeOUk4EYddLfH6
	c49c5EKg1ravXQ=; b=rfOQTQJxinXZ7v3YkpL/Ie1RD0j8nxMnvxNH1kQJs6nCu
	hahdK8CnqSAwyP4381E+9C/KkdfM5NhJLNlfj61Fe8xztDRQQbRFtk7o4/4iR65q
	z2FVjaW26GXmEnE1TxNuTcNtYIQ0eyht4xXquxaWboAKRk0HFpljmod+GG/EVGfm
	hg1vdhydlG3znQOJVbh+c211yAv6FQWF98TEmIISBZKH50yRYBnKtszU5bQmkK/s
	cGB4NiWBTbYoDyP+7D3ppcZX/PHPrSk5xi9a5LdZvNud/vyldfJOZOivJbJ69Olb
	7A7TbLRf0GZ1E+ow32zxeavaKqCszxj95s7sWziDA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkrr8ayc7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jan 2026 08:08:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60D659Zg034682;
	Tue, 13 Jan 2026 08:08:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd78ewwr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jan 2026 08:08:11 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 60D88Ahg038767;
	Tue, 13 Jan 2026 08:08:10 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4bkd78ewra-1;
	Tue, 13 Jan 2026 08:08:10 +0000
From: Jane Chu <jane.chu@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, stable@vger.kernel.org, muchun.song@linux.dev,
        osalvador@suse.de, david@kernel.org, linmiaohe@huawei.com,
        jiaqiyan@google.com, william.roche@oracle.com, rientjes@google.com,
        akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
        Liam.Howlett@Oracle.com, rppt@kernel.org, surenb@google.com,
        mhocko@suse.com, willy@infradead.org
Subject: [PATCH v4 1/2] mm/memory-failure: fix missing ->mf_stats count in hugetlb poison
Date: Tue, 13 Jan 2026 01:07:50 -0700
Message-ID: <20260113080751.2173497-1-jane.chu@oracle.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_01,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601130067
X-Proofpoint-ORIG-GUID: CWxXQq-dC-d3SGg0oam9JGVd2TezwAtx
X-Proofpoint-GUID: CWxXQq-dC-d3SGg0oam9JGVd2TezwAtx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEzMDA2NyBTYWx0ZWRfX0EUAjrIo+1eU
 d0eVnAFk3frK9PKjzaNLcBTAz4Sg0Nl8Q5LMNo7xIPk5SjdhqdfKnHR0bgop+Iz4JWVMWp+5xay
 Y3z+flZ6B5zUJe5LbYnK60noK0SIHJVOJTdBYiSkQKjj5TfOOipnzaSRVPaD7CjSi14Ac/tYa8R
 LwTMrwZlcpMh9NCnsQ8IgJ4uPB0j++Ueqxy+yNclFKLzULERWv1H3x7gbLSNiNG/gKqE4xlQOvq
 Ah/iJvMStKgASj9PKBvxFY4Omc8znOE687QOW+HD1WcCqQnRXDvY6Ow//9VDInapYWMbIWkySu2
 zbRKErKzTTrwXBIN/Q1xq3J+mugPEtp34poSFjXbscZR2CrRtvPtoihHhHXYeYpPh8Jrkuy5CQX
 kcLkxQVooZ5xxeV82Wk6xro8QKYSMvTpcIibbfOW00IqreiihxVoJmwUWpukhf63W7WgiwsGmeu
 oyZVdg9YeOvmA0Gss8g==
X-Authority-Analysis: v=2.4 cv=QIllhwLL c=1 sm=1 tr=0 ts=6965fd6c b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=8moRJLxLMB3yPiChBVEA:9
X-Rspamd-Queue-Id: 2450918000B
X-Stat-Signature: s9kpchakb8aiubhnykpxzhiddmmnc84m
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768291712-551948
X-HE-Meta: U2FsdGVkX18CSfS+pZFwinyXbVaWtq1Xn0akObtlJr3Vi7bmrpm5oYmDQ8mN3Ys50scDTjJtqDdG4jSoCNbYstesfmLeZapUwW9QC8BkujCCACpyY6ivgINpf9z8oRC8g2kENNDHwAoNpCN8ahN7u60OqaltLl/fM0jE1eKrCpcyvnkuf+t7QS8k4l9jOcpqrVpz1p2HnNzKGqZq7f+oL80PvWfvmDkeys62WhGxx2SGNtpVyvtoelcZDoGOMZfSCYpgppEMXlVsQmrQH0GEEq9Evq3E2bvfwCDl/iI4BBOPuu/jmlmo+5sX3YVEq26y+3IlHkvw92D+kOghmNzCMXLLcp2lOiCrkI0FzKT5qH+xT9dOKhcOv+MKpys3GevJRgaMile9YEgfHp8BoIN6uxHe8k7tnGjednOJr+Oiz5cr2vlIMX6z6XZ7zqtAjWEvz6Sailp41mM10SBGg3E5NoHmAfEmyOIp2yrILGPXaZA6/qjh0WoNLVrAGFko6iy1pF2eJ0dv22n8Vq8WJ9BYX+Cf6gxLgT9zmmCUmOjBh/fogUP+ZQMea4tlkPqjyvomt1l0qs9MLqDOSjTKQ4lrxHTMvlt84oK6am8RfJhE/Yal4sDczUm6NhXliQiwMTzDvEQ33Ke9QuCirZawEY38fJ9UJv4vPladbU4V2GL6NT2mykJWTetUC/Ivp/POBPtUBuNPwSWSmJrDULfBn3LKFYTOZSqt5kymM9h1Km0lyeehN1QTaO+SAXJ4UXihRrnBEynHZ8tOSCR6UrqS52HKohNuVN4ZwtxfYWAcF88uk98auPWQvIILae90VsLEPEziTMe+FnAwt3aeAREXM4gJrq2a8JnJVBtbDK+f7lEjmD5VOD6g36Aeb3rqSftEs74bJrWwCC7OZSCIXOVkewtdczN8I6rYnq/bJzrR5ZqomewZ/DEamcm37xE+UhofgwPzaOQSP+hdAG62hBPD5kJ
 G+XQMXG/
 ow0mcnoTCV3jwM5wfjb6gCcaRTuENXHjajGmzOU9LfT9pFFgDkEHsdogZUBXEB1K9YEzHd8HJBKBm0XF0BH6jVvzC+Ko7njBs+kLPlUeqdmgWFr85F6QRjVlLKMBGfE2xPBMEiIxDrYZOw6tOqSgBl49ms7XYCuevdBlW1ltS9fC3kbDwhS3fkyj/ER2XCDMzbzzEhKq3HsZRxSfEbZ0X6vs4+sUCHlAKmGogC/RpoRi12yz+n2p4GEOqbuLZ1tRE+EqFpEHe/+NLPAzanogvSWOhtwcn4H03qlfvFsR/vt+0qTWDiw/QH2wxRFZZIC7yaxDsB66ZjIg5HNUliQPKbR57/A==
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
 mm/memory-failure.c | 75 +++++++++++++++++++++++++++------------------
 1 file changed, 45 insertions(+), 30 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index fbc5a01260c8..b3e27451d618 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1883,12 +1883,24 @@ static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
 	return count;
 }
 
-static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
+#define	MF_HUGETLB_FOLIO_PRE_POISONED	3  /* folio already poisoned */
+#define	MF_HUGETLB_PAGE_PRE_POISON	4  /* exact page already poisoned */
+/*
+ * Set hugetlb folio as hwpoisoned, update folio private raw hwpoison list
+ * to keep track of the poisoned pages.
+ * Return:
+ *	0: folio was not already poisoned;
+ *	MF_HUGETLB_FOLIO_PRE_POISONED: folio was already poisoned: either
+ *		multiple pages being poisoned, or per page information unclear,
+ *	MF_HUGETLB_PAGE_PRE_POISON: folio was already poisoned, an exact
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
+			return MF_HUGETLB_PAGE_PRE_POISON;
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
 
@@ -2029,22 +2037,29 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
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
+	case MF_HUGETLB_PAGE_PRE_POISON:
+		if (flags & MF_ACTION_REQUIRED) {
+			folio = page_folio(p);
+			res = kill_accessing_process(current, folio_pfn(folio), flags);
+		}
+		if (res == MF_HUGETLB_FOLIO_PRE_POISONED)
+			action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
+		else
+			action_result(pfn, MF_MSG_HUGE, MF_FAILED);
+		return res;
+	default:
+		break;
 	}
 
 	folio = page_folio(p);
-- 
2.43.5


