Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89A0DD7495A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 06:28:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E77906B0088; Fri, 19 Dec 2025 01:28:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4FAC6B0089; Fri, 19 Dec 2025 01:28:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4E716B008A; Fri, 19 Dec 2025 01:28:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C31176B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:28:44 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 59AF258E1E
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:28:44 +0000 (UTC)
X-FDA: 84235242168.21.B7ED1C5
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 63B381C0004
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:28:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cFu1T7t0;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf18.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766125722; a=rsa-sha256;
	cv=none;
	b=s3hg+Do77MiUfimveTLwtaiDeDkTsnWKa8FWiGHRMjmsgag6U/KtRLX+3RTz1DyiQnlxzA
	mcztmjtGqeSDl0XHvSMMciTcHCVZ3O92bTEQ9G5TaX5XD81AZTYVtNZT96Ea2ixKImNh6n
	kSE+m8uYAtpIhGfoj1UNQlMP/XrzDZA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cFu1T7t0;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf18.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766125722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=I6QrtPwtlqYhnAG5c9JpOVRkSlpdeSTls/VSNXrj580=;
	b=IyWTXbDNWR1uE7KP/w8XPzEHBoCUKB6ftO8JbOwQsZfLe+Utbg6UR9rRhNXtwGqlSxWk3b
	9pfDuaPO0muAzJk7nx7dZS98FnN0lpycDZGNQXR/o1L9iDUkWeuRpLtXxMD7zmCwY1XiAq
	B2lW5N9jGMP43V2ro9QT6pLhcek/lkc=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BJ3Ec192694735;
	Fri, 19 Dec 2025 06:28:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=I6QrtPwtlqYhnAG5c9JpOVRkSlpde
	STls/VSNXrj580=; b=cFu1T7t0oEapEdpYUbK6tN3PDkBLfck8/2XxO8Ejsxw+N
	vhI6IOw4oejqjctteTymVA5pc9C2nM33e6l/UnGgunR+Lc3+U+c0ZH6pbmAbxzMu
	4Izo2+mzxhJpF46ctNi11AvxOYeyKxcB6USYhEN3HV8zqlQUORDv8jjEGm/p1yp2
	DlFn85lkxNt8ZkWCevfMXRqzJGSLmJG9aRUXw5kQTJWgBii95F0BQbCpgMot8sOi
	uJIjU7HYZprPY2JxqPOeZCZjjPzMZK/g1UJyYKuY3qZypxqFqw6K+TytI6o+GNA1
	6WakfZWy03voPgy6a5Rbc4CQ34VeYf3vA634yatSA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b4r290jan-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Dec 2025 06:28:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BJ4pwKR023986;
	Fri, 19 Dec 2025 06:28:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b4qtdrjy0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Dec 2025 06:28:30 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5BJ6STqC022140;
	Fri, 19 Dec 2025 06:28:29 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4b4qtdrjwe-1;
	Fri, 19 Dec 2025 06:28:29 +0000
From: Jane Chu <jane.chu@oracle.com>
To: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
        linmiaohe@huawei.com, jiaqiyan@google.com, william.roche@oracle.com,
        rientjes@google.com, akpm@linux-foundation.org,
        lorenzo.stoakes@oracle.com, Liam.Howlett@Oracle.com, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm/memory-failure: teach kill_accessing_process to accept hugetlb tail page pfn
Date: Thu, 18 Dec 2025 23:28:19 -0700
Message-ID: <20251219062819.2499399-1-jane.chu@oracle.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-19_02,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 spamscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2512190052
X-Proofpoint-ORIG-GUID: 3gq8SPjeieSOd0fhM_CRtXdX1oBwAd-h
X-Proofpoint-GUID: 3gq8SPjeieSOd0fhM_CRtXdX1oBwAd-h
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE5MDA1MSBTYWx0ZWRfX9Wq9wk/Hp6J0
 hoZvLTkEiBAa2NKJmqWlPcildrr74IVPJbQTaFISIp8tURm0DZXAGSxLUOE7u6wiThisjYR1jN6
 pVTzjwRuwp82sV0murtvwuUughyGAA1ZjDEODTUKTMlkheognJvCYLeB4e2/r8hiPT1cBn4wy75
 yE5CbbmyazhjGvZu734FHOBrlMAO81lpqdDDmormQRv+tvZvt8pIIPGKhaVwCbMiaIMBXiesz/6
 5DoFs75AHoehOGEzj14bZUIfzxRgqOH6kTuViCRBa5XmNFgQ83GUraYKWJ8aQVw/D2sq7beRm4B
 KamdFJh4oyFRRXFtFNK8VKl2FIbG5ZIv5dMxbBFEOnah8Zk+E0qymwhnqiArS2QPWQUvEpNWAkB
 7Lwtd2zWCxSN1Z0qat+Dfdt/6r5NbsCYOyZ9T+cyCaJNDUh8EikObFVfvva/Csihs5AF/OCzerz
 +vSpCjuvLtvrORdVZjw==
X-Authority-Analysis: v=2.4 cv=efkwvrEH c=1 sm=1 tr=0 ts=6944f08f b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8
 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=f-Xke4JHVjhQjhv6I2sA:9
 a=1CNFftbPRP8L7MoqJWF3:22
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 63B381C0004
X-Stat-Signature: tbfq6t96yfuxz5813zsumdc159s1n5hc
X-Rspam-User: 
X-HE-Tag: 1766125722-66691
X-HE-Meta: U2FsdGVkX1+qHRrRqjkAMpT9BuYxV1gZR40lE7fXNd9K9f2+H1WYB6KciUJlUJ8hgfLbViDn76hM5YIXLZshRKxh0UmjAcyG2XSCNItDbXUOdPO/8MW5Byotip0yOa98SCSB2CTIfwU3rZ/OB/Ux2jJOr/MOuZZkpXftkjxBRW3vxJaENc0aIciBbNDP3QlajUeevjbxHGBarALgw1COfRw7WIz59ou52l/ydxxOn6zX6pm6aU5dEtbbfaqazSXGEkkmmnCfwQHNL39gaGSYQPwb7+AqE3g8bmS4QtcFzg0hBJNEkCteMtRkRJFbIXf7IJuYe+PaXel7H3wavWSvu2Aod1Qy2LVkDhZk2haeEVIiCxXasfrZ2lzSgtM5Wwsej2LnWVCp6FESosZQtw71JB00yMoVLsl48aE5L3sl3ogKDeG6G4qFUd8sm7lga9A6/ky0c8yn6A8WAcQqr8ROLp5ulFfiyFpSDwEoaSCpmTinQJ7ufRryFY0HL4DaA1BEvg/tgQXrAKSU0MIBrtBwuOOE38He8peUaySkr7Fky7A131CPdsgFX3ykgU4+tTRXbDWZ790My6wv3/hyUUCiFKhLJj6bWiqHJCkzxcR6/wtYCVLx/UyQ3F7GKnqciGN2ucRfJ2oRGY4JVHucgwv6kpV7BSMnyxc9861NtCWAnjNizScjvawN9GwwKcWEhf4IkWJW6lan+HNIQaTalwC+D071LWgvjax7rUuWh0XzAVwmzx7yvHnJg+k1M+9B8oadgTr87n56PfMAQCY7pYciO3NyvpsjlqeO/xAQAkqzZfzP7pK89XU+dpXp5dTi6h+CFsdcaK2geBJo3Zvx+pXDSC/VBmzPUT8DQlvonbmy2lcA/l6DfqiqIWXCLtLSZmL2hZplYa59E+A11ik1kbQ7MtaOoh2zD/K1gvNkLHeBJ9z+w2H1dzt36O8lIL+hryUA
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


