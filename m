Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E6F2D3901B
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 21:38:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDDDE6B0089; Wed, 14 Jan 2026 16:38:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE0406B008A; Wed, 14 Jan 2026 16:38:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FB026B008C; Wed, 14 Jan 2026 16:38:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7E6486B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:38:00 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4658D160116
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 21:38:00 +0000 (UTC)
X-FDA: 84331882320.21.2C8F1B9
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2970A40003
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 21:37:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dA05Yg8Y;
	spf=pass (imf01.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768426678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/s9AighKRjqX8gVI7ACM0hWfzlx9xJSRT2Y4is2Sfcw=;
	b=oBouPwhGDlEh8q+85SWlFFyYAl96b8vcM1Mbxb2yg5ZMgWQ9dLHCAq5sME+ch4LwDxHjNa
	BdEI4hiadhvMsuXJ7ZfG+ym7919+MvISMHMMaa3c/S7eC7ogPnn6S5TZ8vUEbhzEf/56p4
	7KSWMaM4ZDFr9QNiqnjbsJP5Lt/lvxY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dA05Yg8Y;
	spf=pass (imf01.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768426678; a=rsa-sha256;
	cv=none;
	b=glYSMXJg8kNueDNv/c22KwH8kJbYMNJjrR4oJt5GHQBxZ4iv0xtMTd4jRiJN2NjXcM7B/J
	ot4xwki4aKw7i7O/US44vbsGgBTLCZydzPw72JUaacLy2eZy62bWnsC/YOAGfE7XTBB+ua
	WWpL2noLVRPYu3uFkcYVDMWd3zdy+No=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60EHxToq1362564;
	Wed, 14 Jan 2026 21:37:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=/s9Ai
	ghKRjqX8gVI7ACM0hWfzlx9xJSRT2Y4is2Sfcw=; b=dA05Yg8Y5AxwFM4CxQ8A4
	KgwQKSozt30Ms3S+/jMKBXAUkge8FbM1KxuFUDMpU0RF97h32hPyB28xPHK1FKzz
	z5fWWsIS8plV6UjJ+J1OOMCAg4744VDQYFvFqQg2J7idISMr1nIMvAbZesjPoomg
	JEVDSwHI8TGe547Il1olhklYt6F2DTehQjoN5DIhcRkun6gIwV5YzoC0Lnj65ZXf
	7QvzzA0po4TL8glkjLK9x0/xBkwoWO+epqM1S2GJv7ZfI8hYm5ZOungUze0MLNbK
	1fCCZ7P/deyvPSwNAMCJaC3BQ3A8Ngd1AV394inApFMfdlVMXgSamnCxVgkaVm9Q
	Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5vp19m7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 21:37:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60ELQwus008258;
	Wed, 14 Jan 2026 21:37:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7ab113-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 21:37:33 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 60ELbSxN024482;
	Wed, 14 Jan 2026 21:37:32 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4bkd7ab0y3-2;
	Wed, 14 Jan 2026 21:37:32 +0000
From: Jane Chu <jane.chu@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, stable@vger.kernel.org, muchun.song@linux.dev,
        osalvador@suse.de, david@kernel.org, linmiaohe@huawei.com,
        jiaqiyan@google.com, william.roche@oracle.com, rientjes@google.com,
        akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
        Liam.Howlett@Oracle.com, rppt@kernel.org, surenb@google.com,
        mhocko@suse.com, willy@infradead.org, clm@meta.com
Subject: [PATCH v5 2/2] mm/memory-failure: teach kill_accessing_process to accept hugetlb tail page pfn
Date: Wed, 14 Jan 2026 14:37:20 -0700
Message-ID: <20260114213721.2295844-2-jane.chu@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260114213721.2295844-1-jane.chu@oracle.com>
References: <20260114213721.2295844-1-jane.chu@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_06,2026-01-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601140177
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDE3NyBTYWx0ZWRfX1FYBaLflYAyE
 6Pp+i69tqY+fI64Ndv00DSkezV6n8vkIqEQyor7BdGTrPU8HHiXjGK9iBXuX6ZFDFvOC4M6ItSb
 Q0QtTutM/+gLckIOJrqIPooQR/2zO6r6Bn1dFD9jIu2DhEBJvoMDhWpQobuieP7cpmICOiZk39t
 ZlwhnRbVoa0iQJNKpy4NoWdXeslCfBAeS2f9nPNBa2NoCvwIolFIMhwriu1TDE5RFcLkZMGfpQp
 JLPXRPavEauBem6Afb2+qX8UGXvlGCWJDSN+uQT2pflU+Z+5mifLSvLVal2PpaULqGiLTFvmXR7
 h4LvW4ecKvFdou7ZdjcpA9xYpH1ZT0Nqtb9OYQpWqGpCmpFuPm0TDkwtxWZG7KTJkkS8BLoIx+Y
 Zqqo9BPePK10q8vbzscM/yXy0G5eQ8IojucIMxJc20R+HqyRKEBlLMofObddV7TE1kJprn7WasZ
 EpPx+MZUxOOvXOYntzw==
X-Proofpoint-GUID: 7wvxSWdPElon3xwNnM82G_zapD9kBtwj
X-Authority-Analysis: v=2.4 cv=aZtsXBot c=1 sm=1 tr=0 ts=69680c9e cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8
 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=DOqXzVRdv2y7BJT1fF0A:9
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-ORIG-GUID: 7wvxSWdPElon3xwNnM82G_zapD9kBtwj
X-Rspam-User: 
X-Stat-Signature: hg9mu79ji644ydrkwkjbkjxhzm45r65b
X-Rspamd-Queue-Id: 2970A40003
X-Rspamd-Server: rspam04
X-HE-Tag: 1768426678-422197
X-HE-Meta: U2FsdGVkX1+CjVAllA6UT+EjHR7DH01cpJ01XWe02hBf/oj2WhPzPEoHCYYtq8IIkqg0aaap8XKbtWjuuNRgPdN8bmLsCUTftEnawfjdwQvaYi1n2uPEHUhwplgeh0vxJg/x/myWvf6JP2bcwM+3aEeHaFymI1mZ8OFy5FsI3i1o5m6IEDLOKOwyNskq54Cj5SL5WEcSwQy4Vb+Zf9d8Fr/tDnuClP868aAleJ4q5+vYsAJfSAKfKVt4j2nrGABdCx98cDZP9gf/Tc8khUrsC4Fp+iL/DKFtXr1+tYDyT3qa56ldwljjRe4NfeDZnhAOlZYelYF4HcT3+fFukUbT1jl4ZOQldo2HHu7JuCLO2++3PZxtzeFm/h0kuHJSRmI9H3Y1LBxRxij1tVqsHVyR6Tln+e/2q5sJpC9sNuCIHm0tJA0jHcjdaDMAE+9NQhwCGrpy4KgRmloFYxc4tu3yKtrf4qkrKto45yOObty41WJT+1vVsfK/W3OJyCXqaiC/CfGidBDMI3FNjpW6Ug6k5DVopzcQj/fUhgjaPmc6wnNvuybSGEX55kkdLnUh30D2ImDf4lEJM9HGhfbWyGTOey1kg/c7Oq4RLznsvPEs4Cv8OGsMVhsuyIPCQSLaJyRM4MNPrtLnNLUHfOQ9ezqjOlrwhwgwiIJXVT30GoedKl1UB6jLC+3EUVhwm6Ydle9N2SVnDTcaqIoiLyQOewcvFSX/vrIlzubyWWslUW7U59eW/GiIpxp4wMhmLsvRvkHBcn9euv8Z4M9PHyLnO/QdZe/IBSqJeuFjACQBPYovFYbqgcA9KYt1029Uk+GBUj+0FnnCsD93UGlh5pOici2WAB4zjUaW3xxBi4uQ67xnEH5AcUwLKNgbl73zNk7qiUI0kMLi673mXh/+hLnO9pZNkTJGS9WyKyo7N8IKJD9fQ9EuQmakvBhxXgQJIv/XzSREbnHvL3VXDI9C2+E8Kc3
 hZnOjLUh
 qfgr+O63MvuIw5Rw5CWyI5C062F+gw4q/OUN/kfFIkZkg32N/7zAMLElWNIgrDF70LBxx0LpGRyE9uQXWIYXgpYFh4HyWXPbUQLkeFCkq0xM6aJCaY9WVahY9+RP/ZZYecOHoL00Dgg59C4WHVfwvzMU5A0fSx4DHctVlVbx+I8JyU5sWiU8TrzduVC0h/gGd7CwY2TNeLHttcy5xlSPsZCbS1T8RAxoGpqbjDr64Uh4+3sQl/lpx9ymTLzz6FUPZs4WCq/nKbXyM7fbexivtZJOUH4QyB3fmNY3NDQik1b85jweuLYcVW5aSdqKZ/hiCP1Hvj7RjHHPQUEKu/t0czhMYRT2DQhV6cnACZ5/9L8q6qCSsIWgkY0HwlIX6KotpUvzx
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
v5, v4: No change.
v2 -> v3:
  incorporated suggestions from Miaohe and Matthew.
v1 -> v2:
  pickup R-B, add stable to cc list.
---
 mm/memory-failure.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 2563718c34c6..f6b806499caa 100644
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
 
@@ -2055,10 +2059,8 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
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


