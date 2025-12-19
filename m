Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCEE2D7879F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 17:55:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15BF46B0089; Fri, 19 Dec 2025 12:55:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 101DA6B008A; Fri, 19 Dec 2025 12:55:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F19036B008C; Fri, 19 Dec 2025 12:55:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E07BE6B0089
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 12:55:46 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 942B6589C5
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 17:55:46 +0000 (UTC)
X-FDA: 84236973492.25.CDF7396
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id BC27D1C0010
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 17:55:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=C5YomseO;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf21.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766166944; a=rsa-sha256;
	cv=none;
	b=m3FLpejK3Jukewe9SNoCJjMoOIa1frhymy2XVx9ny6EhSk1cm0zrt3rXZhXz2P3hTvgDv9
	LVfZzgxNitbmjLUCVYVggTQOonpUOwMRcVHjZTxG9xu5dOl2XyLmvCwI/14zCSpLf3vjlB
	ujLPWaRaF31uAudPadjF7vJoHPbVkrs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=C5YomseO;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf21.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766166944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sNe/0MAXAOC1VNXdnuf7J8X0YhBVVBH20168b+oieb8=;
	b=7kCn+UTLMrqVorCCCF13dg9BWzHFFp/0y8ee7SxgYh4HQJiLSSQTrmPWYmaXPRKI3AvqLh
	kLHC7S+gkKJB+QERdpOa04ftO0VoRnwa+mx23w2AUFwQTGX87h8vf10on3nT1BFNDZ4A4c
	6vkzqCCKyy9J/yUVAt/rybU9VY+IGmo=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BJGaEGc2980959;
	Fri, 19 Dec 2025 17:55:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=sNe/0MAXAOC1VNXdnuf7J8X0YhBVV
	BH20168b+oieb8=; b=C5YomseOba3BQsI1NdbPM6SVMDzclhnRb/CGjwqf0gjzn
	eGS+kgNYoo0JQwopoipUM1641QraMXjNy/gdqbYOnTntqHs0z1qQzEL9V894mXbb
	yXrdPvl9fG8Tc2gYhs9PBbNGfTkW3eHyQCmNmtXHucj4KwOLHt1NoqTDtDoprjWV
	iy1Mg9XkHshXAqEhBWnSzg3Xjs3DA5MzD9f6wE01kZMcHYO73nn/u1E0nPKblC3j
	dH4Q+MVvku5yDpCJie9Hhfdrg7DVSvQWX7DjN0dJsYVaNYo5JxIQPxJ7Np1UoagE
	LtDDA10+f8O+SiYuf72z78FhYgHdvKJ+kA5PXaJlA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b4r291h5v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Dec 2025 17:55:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BJGgUiV023755;
	Fri, 19 Dec 2025 17:55:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b4qtb984y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Dec 2025 17:55:34 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5BJHtYGX015634;
	Fri, 19 Dec 2025 17:55:34 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4b4qtb9844-1;
	Fri, 19 Dec 2025 17:55:34 +0000
From: Jane Chu <jane.chu@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, stable@vger.kernel.org, muchun.song@linux.dev,
        osalvador@suse.de, david@kernel.org, linmiaohe@huawei.com,
        jiaqiyan@google.com, william.roche@oracle.com, rientjes@google.com,
        akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
        Liam.Howlett@Oracle.com, rppt@kernel.org, surenb@google.com,
        mhocko@suse.com
Subject: [PATCH v2] mm/memory-failure: teach kill_accessing_process to accept hugetlb tail page pfn
Date: Fri, 19 Dec 2025 10:55:16 -0700
Message-ID: <20251219175516.2656093-1-jane.chu@oracle.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-19_06,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2512190150
X-Authority-Analysis: v=2.4 cv=WZgBqkhX c=1 sm=1 tr=0 ts=69459197 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8
 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=f-Xke4JHVjhQjhv6I2sA:9
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-ORIG-GUID: i9u8nulIWI20L2djzK7Y8_P-03FJISUO
X-Proofpoint-GUID: i9u8nulIWI20L2djzK7Y8_P-03FJISUO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE5MDE1MCBTYWx0ZWRfX2SrnGd1Q1guE
 zmC0VgapUQCEqw5sPzeXeHlV+sET1e0cdKC+zAprTS3hiS8UROJKxzuU+tHRteBm1trTn1xsJji
 8VvJwEkPN4svxeGNsIksCKurKHjRmWH7gCXp3flRznry7VmET+qlUDewanBnds7dHpjxWv4wBK8
 rLlGI+qMrliSdKkICnoPegHaQI3jkR9unI1NyJQejC9DwylPYCV2Ec3vUubgcxeFCXAw+fGIId3
 cP8eZW7wnedSnOM3GP3g4ob6cK4Qumd/xW/7p+ZR1HEM6A6SwcvJTx+W23ZuoQevutlxKNVOHFN
 6q48YAoRCHfOa9P7ruNfmsyrgkWbnt6E5APd8R4v+Sv7Y+peBB17h6vBeufDohc9xy0v50OynLE
 12RdbNj1PdxvPjaRPqdQamuVqIDplV0xDyVBd6QlsPpYRkvZhWNPDxcVXDcKZkhzmPPNIavAYOR
 Vlp9HrUEH+weJOgonUQ==
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BC27D1C0010
X-Stat-Signature: c1s979rsj4zmux9phaa1wgtar3h1dkaq
X-HE-Tag: 1766166944-422912
X-HE-Meta: U2FsdGVkX18h7w0iJfwPxFR/K4d1ouU0BoFCFvSD6stRgCBSJ2p4HDuTMpQ0xFMzqJ+6sUUAGftKNc/25E6cRcWi5Jylbj1wjoRKWHrEDQEOO3yfXKiwWMBF5lhhaKFYWzkb9YL+P6sTamF/E29gjut2lCuEfkulWdarJ6I3HhPYiQ7QM469q/KRG37P5V43hbGCLC6Ooh1fbLgNRhPzorgADoZT26psj8m+6qtm9kGKn02pmJN+hTkugWjxtcQO7UTWfIUk6VNFhAstt5TFWHLp4nCGVYHttZvUD6us5C1Lh2p+GmRgKvRf+/EpCRnsjUec4X6uoC6OasxV5x4IQ+YixJUErOcYQA3gRfxgLSyMoHiq+oNbtxsSUGQjuaBH0KMPOXJjEh81/01xJfIomnVdOD3OxD4LPDJ4hrX4wHndcabu8pwByFf/G2STghVfx76oqUXeqo/IOyNxI8GiFz1ZoNcpCT5n6AfsXJya/QF3TSwuFzGQvvQ48xxUX5Lz1U9KIuuhVICTBxv7tFfSpLMfXcJH6ekKOSN9H8SydyJ/J1HcEEh5FVTf1JWRmFIng3GnhhZSQN+/vpksr4Vfrtt9NwtkR1nzU/ghtF7Q2ZXqyEapEaGBEwhzT2Ww8RtuD1i/keJUplo4yE16rYDi/o/jXw8sWWzqh9Q8kmPw02iNirHnRWR/PugS5zP9ZRY8NHFHMTvR+H0iNondObFd4OIoyyPV+m04wJEmEmgTnT+ezLCrb+PTNmtn/zX1GEiVGbtrwAJ5/Xe7kN13p+3CNuVLGD3Pz/zv0v4sj49iYJpuyHWfRgGsy3BpnWaowoa9adtsktz5ttbepbzA3op1H+UFcsl88Er750qFloFmYJTRVTX7WzSEOluxoUqo4XCvcQwwxjRU+4Nzdm0KYXKBvQQIBdre1New/yVQh2eHicyC3iuMVluDXAIhuiLOgTv7
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
---
v1 -> v2:
  pickup R-B, add stable to cc list.
---
 mm/memory-failure.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 3edebb0cda30..c9d87811b1ea 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -681,9 +681,11 @@ static void set_to_kill(struct to_kill *tk, unsigned long addr, short shift)
 }
 
 static int check_hwpoisoned_entry(pte_t pte, unsigned long addr, short shift,
-				unsigned long poisoned_pfn, struct to_kill *tk)
+				unsigned long poisoned_pfn, struct to_kill *tk,
+				int pte_nr)
 {
 	unsigned long pfn = 0;
+	unsigned long hwpoison_vaddr;
 
 	if (pte_present(pte)) {
 		pfn = pte_pfn(pte);
@@ -694,10 +696,11 @@ static int check_hwpoisoned_entry(pte_t pte, unsigned long addr, short shift,
 			pfn = swp_offset_pfn(swp);
 	}
 
-	if (!pfn || pfn != poisoned_pfn)
+	if (!pfn || (pfn > poisoned_pfn || (pfn + pte_nr - 1) < poisoned_pfn))
 		return 0;
 
-	set_to_kill(tk, addr, shift);
+	hwpoison_vaddr = addr + ((poisoned_pfn - pfn) << PAGE_SHIFT);
+	set_to_kill(tk, hwpoison_vaddr, shift);
 	return 1;
 }
 
@@ -749,7 +752,7 @@ static int hwpoison_pte_range(pmd_t *pmdp, unsigned long addr,
 
 	for (; addr != end; ptep++, addr += PAGE_SIZE) {
 		ret = check_hwpoisoned_entry(ptep_get(ptep), addr, PAGE_SHIFT,
-					     hwp->pfn, &hwp->tk);
+					     hwp->pfn, &hwp->tk, 1);
 		if (ret == 1)
 			break;
 	}
@@ -772,8 +775,8 @@ static int hwpoison_hugetlb_range(pte_t *ptep, unsigned long hmask,
 
 	ptl = huge_pte_lock(h, walk->mm, ptep);
 	pte = huge_ptep_get(walk->mm, addr, ptep);
-	ret = check_hwpoisoned_entry(pte, addr, huge_page_shift(h),
-					hwp->pfn, &hwp->tk);
+	ret = check_hwpoisoned_entry(pte, addr, huge_page_shift(h), hwp->pfn,
+				&hwp->tk, pages_per_huge_page(h));
 	spin_unlock(ptl);
 	return ret;
 }
@@ -2023,10 +2026,8 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
 		*hugetlb = 0;
 		return 0;
 	} else if (res == -EHWPOISON) {
-		if (flags & MF_ACTION_REQUIRED) {
-			folio = page_folio(p);
-			res = kill_accessing_process(current, folio_pfn(folio), flags);
-		}
+		if (flags & MF_ACTION_REQUIRED)
+			res = kill_accessing_process(current, pfn, flags);
 		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
 		return res;
 	} else if (res == -EBUSY) {
@@ -2037,6 +2038,7 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
 		return action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
 	}
 
+
 	folio = page_folio(p);
 	folio_lock(folio);
 
-- 
2.43.5


