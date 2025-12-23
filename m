Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 647FDE6B261
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 01:21:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCCD96B0089; Mon, 22 Dec 2025 20:21:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C50636B008A; Mon, 22 Dec 2025 20:21:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A51A06B008C; Mon, 22 Dec 2025 20:21:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 916EE6B0089
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 20:21:43 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5244CC0A75
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:21:43 +0000 (UTC)
X-FDA: 84248983686.12.9295DF9
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3AF58C000A
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:21:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bSmd0JZ7;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf22.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766452901; a=rsa-sha256;
	cv=none;
	b=OhP4CplHoLi8/bXuuZG6mTvKqRPyXvgkkeC/9K+mJlvfCp7tdYSJl62llZKKiOP9aptjo9
	RxcKD6D45gi+VW+dmRrLBGo1nGZvg8taD4sKC2N5zwMa49pAcLPFZxs9tKuMe8vhKcJTWT
	gohgpulXl4yhEcq2EEr2gu1n0hqcvEA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bSmd0JZ7;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf22.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766452901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g8vI6UeUIC5rlql2XyjZDS+hvGt7ge2waCZe4vBSUiE=;
	b=LjQoAI1rhzhDQsEQVTuIHcCkhg5xWehMUW8hyqZutS3qch9L4TnINBTFSj3/s0d69bWbDn
	DzseG/pmJ++iufPQPLvaBzpDtfDVYd6adSHZb9xUq05tTVWdaRGgSCOkOpEzH0upXGGrmO
	KlD0mGKXKRcxhMjIU0h3kFEhml+0v9A=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BN1A1u83530557;
	Tue, 23 Dec 2025 01:21:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=g8vI6
	UeUIC5rlql2XyjZDS+hvGt7ge2waCZe4vBSUiE=; b=bSmd0JZ71DQdSCrWKMh3s
	+HeHah9kkrHv9OlJnWd0eXzeGK7eHzcwynIM6g3j7AHGNrBN3GrA0h+R6dKi3RPn
	14xI7QmQDxp69bpoah4vWLRyBQnfeudpQfsROjHvT/PcnSSLhswqD8O/qebyN1GH
	Rvamc+mkH5MjvqS8Hk36Q07q7i7Ycs1vSFrotgeIurYB6Yc+RVdtui6wUOV6WCnm
	2hcf0/cZjrpLmnEivJI9CVS5vLklB6giqSrc7ft77iGZ6mDv67psAEIyqu0aBHib
	8ucBOYoP9V++zuFyxr50At1F3PVO40broEJqS+ap9+FQMHEE68Vkgy4NWfz3aOzK
	A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b7h5p007m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Dec 2025 01:21:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMM6cmQ002549;
	Tue, 23 Dec 2025 01:21:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b5j87x0fh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Dec 2025 01:21:27 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5BN1LNiE016978;
	Tue, 23 Dec 2025 01:21:26 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4b5j87x0df-2;
	Tue, 23 Dec 2025 01:21:26 +0000
From: Jane Chu <jane.chu@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, stable@vger.kernel.org, muchun.song@linux.dev,
        osalvador@suse.de, david@kernel.org, linmiaohe@huawei.com,
        jiaqiyan@google.com, william.roche@oracle.com, rientjes@google.com,
        akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
        Liam.Howlett@Oracle.com, rppt@kernel.org, surenb@google.com,
        mhocko@suse.com, willy@infradead.org
Subject: [PATCH v3 2/2] mm/memory-failure: teach kill_accessing_process to accept hugetlb tail page pfn
Date: Mon, 22 Dec 2025 18:21:12 -0700
Message-ID: <20251223012113.370674-2-jane.chu@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20251223012113.370674-1-jane.chu@oracle.com>
References: <20251223012113.370674-1-jane.chu@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-22_04,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2512230009
X-Proofpoint-ORIG-GUID: SNTz1od7Q6g2sZiLwfgm_J9kJ9Xg7Udy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDAwOSBTYWx0ZWRfX1g7XaczizzLi
 8NtApq7fTlAU8KspGhDJKWjfJ2BHFNNj3Br8fl9DNpBHZw5GEKXTrRsNy1pVQ/tIGMVYnCdU4qI
 BvN98hK5+HTTWhmtJ/NmgPypRFK81e1idkbW/2chZqdD9io5/xPqDJh7sm9uwfeqy1MHd4fjoYd
 9I5ROCxPenSkDLoUr7wHcHUZQNryWZbn+LhIuJKDF/Lx5fSpIgFmIx9wk+R46kDXhBOmVShg6y0
 9cYbD9NYU2KLijj4QCCstGkl6ZhwbuI3tcxojDAy1zJvdgqNUx0Osc/D7DoPqtA+Fvujiut/500
 YvCpNO2mOmLmS01y+ofXgJkxzNUa48ae02DmQmkaU7JSTGZIyGJfC+YV3C8K6YdImFwyNlutqDE
 g7heQh+rf0hwbk+CKp6SxnKqPjTy3XnpzVg71Er8BKHc/3oFNZl23c2e1z4akZqe6ts6F/j8zLU
 Ww6UgYTH0J8p47UsR/g==
X-Authority-Analysis: v=2.4 cv=S5/UAYsP c=1 sm=1 tr=0 ts=6949ee98 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8
 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=DOqXzVRdv2y7BJT1fF0A:9
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-GUID: SNTz1od7Q6g2sZiLwfgm_J9kJ9Xg7Udy
X-Rspam-User: 
X-Rspamd-Queue-Id: 3AF58C000A
X-Rspamd-Server: rspam10
X-Stat-Signature: ets1pom7a1i1f4g6t8ibx88khixog8b3
X-HE-Tag: 1766452901-282125
X-HE-Meta: U2FsdGVkX1+iSPYHtp+unr7EowYo/uqLgqPkep/hymy1ldUJHOkz1owEfIg9khwW+RWr7WXCeKtSi/Pto73IinmOTytbM0hzoRtMik8WQixea5/VeIPrLJuYIJI/yNeyqF6tqGcuDR+FuQzyTXrOyp5Q9L2vGAU2JswolgwRKely4FalSDU7xR6MKVibHajxXdQA9mNtLmb4yy11RvSaISyG0URLp+3KHf6nx/JKSMCqewjzeZiuuQTyyB3mDUwP+majvygOUyDy80caK1KF0/wsFQE+6mKnpNHQObDpfEcRSibN2E0oLBHRkfFjtOpapZpRkQW6xs3NttEEfHJ0Sj5lQC+RDI8L9zNvgYWcVJ5Ir8Cf+9yjOstL6TnohixaLXH1XiegT9512JK0EsmzsN4bD100vyogczEQCQZN4bMNM5OqytyvjBcePhL5qoz8mRYfkduUxT+X7Uz8Tfn4HLLN1iExnTAlzhXWbm7KSNY8AX9fuc6no8slp5+rESsvvM0+OxNznOG8SYWwyzYnEP7LpAQbFtUKCF7cwYaH9xG7XzuPGztfGi2IRJu8CHmACh1pVWMUqK9d5aomGim6ACi8jpOSGvQ8bRpwiKOcg0fRTzYiyF8YhH/zdqml4U5SGeCzdm59Me7xX88yPE8yeDBlvceQ3bxOrtLvui4/vwuFNKIQ7Nxj61hXIcDq678io77gkEpMEEnkLvFC2mY1aphpKGgdsE8pPgI31Zu2UMGvYcD64b+upELVlNL0fI0q/ijRc7GkZqqTXv4I0U0kKdBU5zMNKp5IUxvm/ZU6MpISnCotoGtEoA4W8kvj0PD2UTuY3R2CjVPBcFFdv0UlnmeExYQ4pKqRnBzfDyaFLYCWGyqFaUIcl8cUasqd9ChfnAMhLpop0tRFxZPf7X8daVukP2LdsEqB1c96uYhb3V5UZm21ckX33imBZyazeFvWkZ6CBbqaqnbOF3PFbgq
 Y4452bJR
 rZORvSHyw4z6lgYv6K552uaaFqp9TPcZwTIw9mJOwib4TX1DhIKOlzJWcbA9c1/ZnkZNa+qrGQR/2CBg+4IqHXdxhBamX7wuWSb7B1z+MpplobrcmQOrU9w1vPBaBtg5n5xl9BVGO6YAtnSRb8B8I/zVa5EogUXeTi9mOBitOunvEgIHmpIyygzneBeiH4gIO2NlcZQPG/Y2sSQPbqnoxO9VwSW4ZIWCJfvPajqtpziERSjhWZGCpq2FvGilktAoZvvpYVAFQt6omWHEm3BbZxntAXPXrHEqMCtt28v5ewjhvZD17VdNdiIqnktA29fkzUiLaAzW54qBmY/Fs4hzQRWhsazyPQZbBpQBvOzF75PPWp37VM+FU9b5jFiL9TdBvWAv7
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
v2 -> v3:
  incorporated suggestions from Miaohe and Matthew.
v1 -> v2:
  pickup R-B, add stable to cc list.
---
 mm/memory-failure.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 8b47e8a1b12d..98612ac961b0 100644
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
+	if (!pfn || ((pfn & mask) != (poisoned_pfn & mask)))
 		return 0;
 
-	set_to_kill(tk, addr, shift);
+	hwpoison_vaddr = addr + ((poisoned_pfn - pfn) << PAGE_SHIFT);
+	set_to_kill(tk, hwpoison_vaddr, shift);
 	return 1;
 }
 
@@ -2038,10 +2042,8 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
 		return 0;
 	case MF_HUGETLB_ALREADY_POISONED:
 	case MF_HUGETLB_ACC_EXISTING_POISON:
-		if (flags & MF_ACTION_REQUIRED) {
-			folio = page_folio(p);
-			res = kill_accessing_process(current, folio_pfn(folio), flags);
-		}
+		if (flags & MF_ACTION_REQUIRED)
+			res = kill_accessing_process(current, pfn, flags);
 		if (res == MF_HUGETLB_ALREADY_POISONED)
 			action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
 		else
-- 
2.43.5


