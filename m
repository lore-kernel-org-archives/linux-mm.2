Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 535A8C982FE
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 20:39:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 636346B0005; Fri, 16 Jan 2026 15:39:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6090B6B008A; Fri, 16 Jan 2026 15:39:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 436FE6B0005; Fri, 16 Jan 2026 15:39:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 252076B0089
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:39:48 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DA11A1A025D
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 20:39:47 +0000 (UTC)
X-FDA: 84338993214.04.33AC947
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id C339180005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 20:39:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oh1Gk0wT;
	spf=pass (imf02.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768595985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PJgG6l0Amdkwy+w0l87obtGT6Q5vG5xjNv8DqWki1Kc=;
	b=xuS0GXzFiLS66PJDTCko+PTNZBJDXeI/zLou6Hd14LtklHCJxgQ2HcCQjjIG4siOaGKo/M
	uQnhv8ORp2cEPCmGVjUifjI5ZJULktygSSbBXMb/X6A3jg73ox5VtEsEtL5ki0iVG9Da2x
	3IGVTl0p/620gbTMwYmsmV6aawTwSWE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oh1Gk0wT;
	spf=pass (imf02.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768595985; a=rsa-sha256;
	cv=none;
	b=qpgMRmfSnpH4hO8IZuIZ5RrW5D2JCE6XuERXcX5bdEV2UdcKxWqjQ4H1TqXxYFMQLgx5lk
	/+hzX+xWupk0CH9p3KNl6gfxOVuVqIBf0i4BpocdF5fgz3nNxZD2PMLVd7jqgAF68qmi05
	eImpkcAi5R8gFBsgWsC7zd+egRj+Dsk=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60GKb0V73839187;
	Fri, 16 Jan 2026 20:38:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=PJgG6
	l0Amdkwy+w0l87obtGT6Q5vG5xjNv8DqWki1Kc=; b=oh1Gk0wTgKF65PBN8pz+C
	UM7mb9/uNMQo0f5mtJ4fhjKyyNOgoEYSOEBKEROxAMejQ51Cq2dTugYlodV6oaq8
	bJ5nLU96z8ESBC7qUxQKot4uU66lxZSmg/mdcCCAHkw7PQ1F7Nvlv7OH2s531xOx
	eHc/skdZeHdnNH/QGcjdTEh0vHqk2Hym0qWqgrSMCrrGrciW9Qho4fBn5ON81NcB
	oF5TI2sgbrZQcQP+1gJ9VuUY53K79ilDHMc6E/PErcKTuQrM9hkJHwu5bPi3F5jg
	hQBKsU7x2HgZdQj2Z12pvYDFVAG3o9c74mFyXsk3mrbz1VbxC9+LiAtb0dfUrUqu
	w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bqvh7g068-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 20:38:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60GKKjWI011135;
	Fri, 16 Jan 2026 20:38:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bqv9m0gh2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 20:38:53 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 60GKclNN019846;
	Fri, 16 Jan 2026 20:38:53 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4bqv9m0gen-2;
	Fri, 16 Jan 2026 20:38:53 +0000
From: Jane Chu <jane.chu@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, stable@vger.kernel.org, muchun.song@linux.dev,
        osalvador@suse.de, david@kernel.org, linmiaohe@huawei.com,
        jiaqiyan@google.com, william.roche@oracle.com, rientjes@google.com,
        akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
        Liam.Howlett@Oracle.com, rppt@kernel.org, surenb@google.com,
        mhocko@suse.com, willy@infradead.org, clm@meta.com
Subject: [PATCH v6 2/2] mm/memory-failure: teach kill_accessing_process to accept hugetlb tail page pfn
Date: Fri, 16 Jan 2026 13:38:33 -0700
Message-ID: <20260116203834.3179551-2-jane.chu@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260116203834.3179551-1-jane.chu@oracle.com>
References: <20260116203834.3179551-1-jane.chu@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_07,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601160154
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDE1NCBTYWx0ZWRfX+8DAjX7b6/G6
 uc0jAwOOjy75t+rz1RgrhZVcuzzsMvCf91Gj740HGgnRDbAI2C60LEHweDDIT3BFElGU1VIpaZ2
 IyjdHsdgJ4U/R81j76L/3ECGAOTMjQ17e8V0StRSRPQIm0l02ECZ7tgCTeOnGlJsMHr7dN4jbAz
 FuC/PE5d4U4ARVgpaV3H0UFF4pOdxF0Ca6fsgDQf31MZm3qvMWaNYITlvEuv8dWOtcKOwYGfTeC
 OaoJcOniVQuxoSWrQf0ITRWFNU+lI8tOtha+6ZF/3ehK1P59EJKs/gMa+y4RfJ+wSrGiD9nwbDY
 pFd2utEu5nO1/R1vhGmW2TVXfufX8w2s6WuMMXcXI1JBmLSbj5bt7RTJ9DXYIjeaRepPsUBObUK
 1+lyiKp1qZFui2cDK41Z3OEC7fO0oKffZM377Ko55PDEF7fyV82maDccss+Pf0HJ6aX46dmcCVY
 i7tn6x60dxovIDHEMcw==
X-Proofpoint-ORIG-GUID: co0pzrNzwGword2GpAv5iFPpblfIQj5y
X-Proofpoint-GUID: co0pzrNzwGword2GpAv5iFPpblfIQj5y
X-Authority-Analysis: v=2.4 cv=A9lh/qWG c=1 sm=1 tr=0 ts=696aa1de cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8
 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=i0EeH86SAAAA:8 a=PxEJfYR7Scfl-YKRXAAA:9
 a=1CNFftbPRP8L7MoqJWF3:22
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C339180005
X-Stat-Signature: iku8q4ua76ox9ffsf7d5c4niuyqznmca
X-HE-Tag: 1768595985-171664
X-HE-Meta: U2FsdGVkX187WDeg4o+QD4nI3YVbFu1kTjTG1xOaZuvImXflYSP8ovhuTPfEXZp3RNHMCBRUXRh/HJRmal8spKK30+L2jHMjuTip24PC4hucFa+dWRmnJlwYZk1YF1NEFewlEgVLrkYq5ueuFQG9j2Mvm9NZi5zlqO5ng8STphWB873nMqeZk2eaihVINEyq4ILEwOjeuQABbDYKSCk8kYcM6Qg+UkqGCeKiFEqdFvyMef1Qz4Z9q0XhDAV2ppz117WXudf56vPUg3+2e1RPV/TGX2XWMsprCkh4kbyRxqitAlZt31h3EPcsJncGCAE/SIYbNFJ7U5Kt4C/L5dFNIfTud9f8KUqIxuQd5IM1VkGj8lu3GZ3IVSkwcL2lin+Hg5KAIO4xRvHnvpu6GKBs5302ZO63Uc5lBTCeGvAMVPiwOzXoumnE5Y62gdgR6DyT9O9MwESe8cMPvV9KC0L31pVWoyOEY5kpDZ2h+hW7gq4Qiqd1P3QVyDMLbjEZpZDs4+SuSkftIArlVwcCa0Vr7zCpBeNjedTHoCZyB3zTuvcFapZyA3dtzVTxFpuyD5Ypzc4ZiOp05KcsSvqU2B0LeTUpL37GgkmznVQ6Hp0Qf16p52li/q/AikH76t2mCK6WO9ICe77ebUKlbqy1fPCN1kkX7ZDEAymhnR5EnAiQ9fOcqGcSd1g9mI4gFEUpoWN4NJdMzqqoYUnp9UGRHxXzXjGCPqJV3jr9Wa6QNOQhml/rswXozPVzx9lqh2jSMztXMcVuzirYyP+9n71XqcafSSIxc1WDkkA4N2NCmdpW8oo8SpplpC0LCfdzU1mzJq+tdKlW4DqpQf96PBnW0ASQ1CWP7bj7WkDjktJzIlATdHd8f9S365qA6Zwj2cdCZMh1uMuc+Y1jqDS4t7Go7wLBhpRgjSmQ6ET5t4nPYhNZ21Gks6/O3In3zDPKkXPLgZc3syO0/efVCRFXItiTc8/
 LQEjFv5u
 3J1kmfkLcYzBOAqiHhWnGum77sQ+zkJEPJeK2DIabBrSMHeN0TrOJA/G0FNc5eHQaGlf3G8RQQlvKSTryZH3aSb1tAMOyjBIhzldsAObRNiMzGGzUhcjAGUrAaEd0yFotRCmGKsMBxfzqkciTgmfP4aNY5Z1bvNpUVobNgefAqsEvcj/loBsaCslWuIK5IVopn026EURe4NxPr/JYxO47aZ3WNZ7zlP4JFGxFfPY6j0wGoCxhfyGMGCCi2a8Bmdq4HFDw1EaEM8cqGnvV6yzHrXsLjF3lnEK3kEPfA6Grr4MOkQ9OaIA8Jch/auWUdpmIh0RWx5YjSoC3qOUzjUe/VI3BMv/fWPskYvyY4DXI3sHuesnbetenyDT8ttOpGSCSUtInYNxmFi6twa1ePNKtZCO1Hg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a hugetlb folio is being poisoned again, try_memory_failure_hugetlb()
passed head pfn to kill_accessing_process(), that is not right.
The precise pfn of the poisoned page should be used in order to
determine the precise vaddr as the SIGBUS payload.

This issue has already been taken care of in the normal path, that is,
hwpoison_user_mappings(), see [1][2].  Further more, for [3] to work
correctly in the hugetlb repoisoning case, it's essential to inform
VM the precise poisoned page, not the head page.

[1] https://lkml.kernel.org/r/20231218135837.3310403-1-willy@infradead.org
[2] https://lkml.kernel.org/r/20250224211445.2663312-1-jane.chu@oracle.com
[3] https://lore.kernel.org/lkml/20251116013223.1557158-1-jiaqiyan@google.com/

Cc: <stable@vger.kernel.org>
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
---
v5 -> v6:
  comment from Miaohe, add an acked-by.
v5, v4: No change.
v2 -> v3:
  incorporated suggestions from Miaohe and Matthew.
v1 -> v2:
  pickup R-B, add stable to cc list.
---
 mm/memory-failure.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 49ced16e9c1a..2d330176364a 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -692,6 +692,8 @@ static int check_hwpoisoned_entry(pte_t pte, unsigned long addr, short shift,
 				unsigned long poisoned_pfn, struct to_kill *tk)
 {
 	unsigned long pfn = 0;
+	unsigned long hwpoison_vaddr;
+	unsigned long mask;
 
 	if (pte_present(pte)) {
 		pfn = pte_pfn(pte);
@@ -702,10 +704,12 @@ static int check_hwpoisoned_entry(pte_t pte, unsigned long addr, short shift,
 			pfn = softleaf_to_pfn(entry);
 	}
 
-	if (!pfn || pfn != poisoned_pfn)
+	mask = ~((1UL << (shift - PAGE_SHIFT)) - 1);
+	if (!pfn || pfn != (poisoned_pfn & mask))
 		return 0;
 
-	set_to_kill(tk, addr, shift);
+	hwpoison_vaddr = addr + ((poisoned_pfn - pfn) << PAGE_SHIFT);
+	set_to_kill(tk, hwpoison_vaddr, shift);
 	return 1;
 }
 
@@ -2050,10 +2054,8 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
 	case MF_HUGETLB_FOLIO_PRE_POISONED:
 	case MF_HUGETLB_PAGE_PRE_POISONED:
 		rv = -EHWPOISON;
-		if (flags & MF_ACTION_REQUIRED) {
-			folio = page_folio(p);
-			rv = kill_accessing_process(current, folio_pfn(folio), flags);
-		}
+		if (flags & MF_ACTION_REQUIRED)
+			rv = kill_accessing_process(current, pfn, flags);
 		if (res == MF_HUGETLB_PAGE_PRE_POISONED)
 			action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
 		else
-- 
2.43.5


