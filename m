Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6A7DD29DE8
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 08:08:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39D6A6B0089; Tue, 13 Jan 2026 03:08:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33D846B008A; Tue, 13 Jan 2026 03:08:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 125506B008C; Tue, 13 Jan 2026 03:08:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0049D6B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 03:08:35 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 139EA5708E
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 08:08:35 +0000 (UTC)
X-FDA: 84326213790.08.F984FE1
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id ECE93A0007
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 08:08:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Y6Xn65lq;
	spf=pass (imf25.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768291713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=texge5LwbT7wQEHYVdtPM4RdyChOR+/v4clnE+Ul5cw=;
	b=Rwg7bdA8Rp41ln59pZkWpo9PVV86/+otVpNiZ2TW6/i/ldqHpihtUbbQV5IAZ8xoou15+h
	/0heaYDMsiKsmia2hp0g8NBVPPNHPVxXxgWrmwuZyyXU1MMY4crD2qNuXuU4gzipZIkNYE
	pGwBn536+aOq7QtElvGPZmnd7V9FuIM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Y6Xn65lq;
	spf=pass (imf25.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768291713; a=rsa-sha256;
	cv=none;
	b=NjQtrVMiAlCTXALAsake99BTQUqhsQYb/DzFNrXlqa1yH3XkiakUPimALKseLbEJFKuZnX
	bY3jp1Mc3X7EAdL44P71ATq/5u6YBMpkMRzFzoTGYvy9mywwbItiBIlgdG9RTcUv/z3ufH
	3cvW+a6+2jfAwOrhhf8sUBltdAhfusk=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60D1gc9m2735700;
	Tue, 13 Jan 2026 08:08:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=texge
	5LwbT7wQEHYVdtPM4RdyChOR+/v4clnE+Ul5cw=; b=Y6Xn65lq13OjtF//AHdIt
	jeEpMuuU7f4iCROaMst2ctjTex2rWr9nyvxNEFcI7Lx0jKFLER1VTNaG6/PpHk9L
	0RvjwuG6Q6ppt6nLmVV+PKaM3uYCrjp/EQQh6qZH1Vxsd2UzXixVaavY7rL1Q43W
	QtLwTsv6ji+UZdTBDgwdbnzksEBsDhaH1JlBsN8jvkL5bHMoQrOyGsNX7KQigoZr
	LYGcRuMFcD22v8XbWsgOVAdkqYh+uI6U7ZXbZQkwLwervJVbFFH0W0+ggP+XuGtJ
	3mc4eoNK6GvgdDJDjo16cB2uKUl/9MB5md2KxMRuYMw0mYt4SR43z0JMLpSRkU1k
	A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkrr8ayca-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jan 2026 08:08:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60D696cG035299;
	Tue, 13 Jan 2026 08:08:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd78ewyx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jan 2026 08:08:16 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 60D88Ahi038767;
	Tue, 13 Jan 2026 08:08:15 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4bkd78ewra-2;
	Tue, 13 Jan 2026 08:08:15 +0000
From: Jane Chu <jane.chu@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, stable@vger.kernel.org, muchun.song@linux.dev,
        osalvador@suse.de, david@kernel.org, linmiaohe@huawei.com,
        jiaqiyan@google.com, william.roche@oracle.com, rientjes@google.com,
        akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
        Liam.Howlett@Oracle.com, rppt@kernel.org, surenb@google.com,
        mhocko@suse.com, willy@infradead.org
Subject: [PATCH v4 2/2] mm/memory-failure: teach kill_accessing_process to accept hugetlb tail page pfn
Date: Tue, 13 Jan 2026 01:07:51 -0700
Message-ID: <20260113080751.2173497-2-jane.chu@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260113080751.2173497-1-jane.chu@oracle.com>
References: <20260113080751.2173497-1-jane.chu@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_01,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601130067
X-Proofpoint-ORIG-GUID: Xqyk_lGVSiW9PUEfVr1-L7_4BEe1nbSX
X-Proofpoint-GUID: Xqyk_lGVSiW9PUEfVr1-L7_4BEe1nbSX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEzMDA2NyBTYWx0ZWRfX/uVFYipRxRcq
 tbQeeZm9Dufx0wHeEy+sBKwvjWQYpDyj1REYaWQguXLvP/J07RHX0VEBjTIyt4pa/FITGHODl8m
 PK0GFG5y1/bLF9HcwD0BRWl83ttjmNKn25dHMl+LTnZkxLW0URXkQf+HdtuvQ8Sk/6QLhTudnYd
 vZSUvXcEWgKbFfnS02yymB5YJXPzw5aAR4P4NuA1SJ2+jN2TICd/hbt0NRPk6lt8SKPQm4BKMOJ
 snrzl0k4Ncbqyn6Ld+FMhKLS+8kQ2MxlLKBdetm5cmyXY9Equr8rnSt3hWOeTBHCXWrBrMSixHL
 VdW3yO6TUDDbbFSKcSyakmpRzEUC9Ri+i1idpWz1QcHgN0L5eUP1qVH9yDefT/Q1ViWWhWR2WS2
 ZMSJ1fqhU3YBynh14OfqvXlRMQQhN9CdYmQ21XS89oCKt7upMXMp1aC9JPFexAgdo+z6KZxb6QZ
 AHzosOoXyHaZ6Q6lZEw==
X-Authority-Analysis: v=2.4 cv=QIllhwLL c=1 sm=1 tr=0 ts=6965fd71 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8
 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=DOqXzVRdv2y7BJT1fF0A:9
 a=1CNFftbPRP8L7MoqJWF3:22
X-Stat-Signature: y7ajsaekzrsku59jzsz6zypjdn8fur8p
X-Rspam-User: 
X-Rspamd-Queue-Id: ECE93A0007
X-Rspamd-Server: rspam08
X-HE-Tag: 1768291712-57670
X-HE-Meta: U2FsdGVkX1+EMQanZFbw3HYrz2xykGLvUe/hRYDkRa27ICrbllcrHXIlWRDaVl3ysKhC7M8zMLaFJ2cw5V1qvUw+8VGgewjVRajsU+xkFXNvD4PCJY+Zes7UZl7Y1RNhRhA+b9ETXyVoQ2hSynLtx5PlnGG8KNGTtxwK7kwDllvHDGV6qp1G6nRnTiBp66sBa0RqeJq2O7K6Lu3GEU8GqyBk9TGoFELAmRn1hJ1Mky6GlzionAP3fM+k8tDhx3Da3ifKG5ts/Gw5T4ks2b0Leq8jBYkZxPSJJUhUy1hDkRiwOTbN1cBtEx3Mw7hWG0KBCkjUzxjUYCpyeTMydHoAlRh9oO/GWLcaY7pD5/s9ZW/GAzDyYDeV4UinRG8imcPEmc2Wu6YXBBuBs9r6m/mIZNjfGlpWWuAZqRc+E1m7BSEbqxyiJ1fnwcLLa5HvBi9h6Cuzb+rdfet9l/3Ek6Wg/QcesCfVsF7G4T8dxZUAR6QXCQRlujtRM3R2r8rAsq5lc0l8bccwnP4luSihlrCDgVastQEWbopLCkMfAEEQaxmFKxtEnVw2gZAi38tn4bvjjabCR/a4gY/q8ADJ17J87gMxK04CW3+Yp5l1TdvCC2KreLjqP4lBCB0novOl2XxH3bfKXJIt5tvB5jl4hzMel9eGNsw4ZJRUgLT5cfwdsQJJJTHge32kX5EInBAx0pycJQvO7qvnQgO+T/bKaKzQAch5yTbpspgj69Z1GlRGloe8JnF2sSm1gCPsIYIyVVoksuTfYolwe4i/vFvtJkXx+V3pxPQyNbraeab08D6UhTe+4VemwFOBOodq9dQpsW/diwBwF0zqdI0W/Gwz2tJ4/ZToG2JLUQhuSEAOUIC+aUJ4UgWwksi+OJyxbfg0s/0L+Bj/rBHeA65bs7zYKo2V8qBj35SpRD6cgmhKaqEpowXy2N56kYxsbwVidqiKo3yGU4KipHbJm0wHLjqrNuT
 X2Y3Ua/x
 QsmUYGKdUFR07M64SdnsO4fsGM1zuPsDB50IChS7H6yuOu9teoQ82zuGkSVISCcYM28xmO6MfxpJrkHoyhMZm2h3oHpBMrr/zkXfpFpQlm8FXWETAjbo8+jYh+9Hs+edI2M3goRuwVbZstBv50Ce98BmuMSuylNHI10QrgiRTzy1HY3SmAQLTx9/M3VJqfdZf8rfb5nQKvPv+vq3PnPMZ8CTkOe/uj2/u8NFSba8D+/qaIgiusQNfRd1Pf/OznFSuF0PAhzwdrWd9nZbvGcNznrqt3s6A5n/9wH9E2QTAenancCrtGRtUSQNirK4EdD+j7GyMrzqZvBPW1iRgF+/5yg0vzQgvzWJHLKkMIFj5jl4VV0A1w3YbqscvwvN+RKroowMz8z2ES7zrZXwwW6IrS28pLwRQkti9/wiMCN14CC2Jzlc=
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
v4 -> v3: No change.
v2 -> v3:
  incorporated suggestions from Miaohe and Matthew.
v1 -> v2:
  pickup R-B, add stable to cc list.
---
 mm/memory-failure.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index b3e27451d618..885dc1d4f212 100644
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
 
@@ -2049,10 +2053,8 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
 		return action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
 	case MF_HUGETLB_FOLIO_PRE_POISONED:
 	case MF_HUGETLB_PAGE_PRE_POISON:
-		if (flags & MF_ACTION_REQUIRED) {
-			folio = page_folio(p);
-			res = kill_accessing_process(current, folio_pfn(folio), flags);
-		}
+		if (flags & MF_ACTION_REQUIRED)
+			res = kill_accessing_process(current, pfn, flags);
 		if (res == MF_HUGETLB_FOLIO_PRE_POISONED)
 			action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
 		else
-- 
2.43.5


