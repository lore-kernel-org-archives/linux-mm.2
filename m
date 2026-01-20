Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2035ED262AB
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 23:23:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F5DD6B0005; Tue, 20 Jan 2026 18:23:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AD6A6B008A; Tue, 20 Jan 2026 18:23:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F85E6B0005; Tue, 20 Jan 2026 18:23:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 645BE6B0089
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 18:23:03 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2D0DA1AF56F
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 23:23:03 +0000 (UTC)
X-FDA: 84353919846.27.8F35164
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id EAE49C0008
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 23:23:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hvnBP7nZ;
	spf=pass (imf10.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768951381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AqttTnIZtlZO/bGL5IJXyLaXtCEWGzGA1ZjZF+Z04GE=;
	b=y3whgsJuuFfRitg3pIS5RpEM3s15Xx/4f6FSqQMyyWH6GQTt372KPwPR/XcbcvGdYV0J0x
	9zT7UXIcbTW5Y1Xa7lXXPTj1iZkYj/FKAui5JJEv0CRvaIRfBvzJoGuakcN1fjEcv1ept4
	C0KF9jBxrj0VFm80jN4jVuh85+Ue+LA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hvnBP7nZ;
	spf=pass (imf10.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768951381; a=rsa-sha256;
	cv=none;
	b=tJi5wryIQ3kvKC02xaDDntaUqb1tgv4VIexzAnTItitcVrk9AThZmVDQh9qN2U40uHKBGC
	m2woIAFngNZ1e0x5pPXmphFn7P3b/Bp1e7k6K1sELWRRrjp52IHEXjRSfHPG8NcGjn6cz+
	qoXlL478p+Du+AqLGT1iq34PNLLIyNc=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60KIRhpT3264873;
	Tue, 20 Jan 2026 23:22:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=AqttT
	nIZtlZO/bGL5IJXyLaXtCEWGzGA1ZjZF+Z04GE=; b=hvnBP7nZ6Fs7j2N9E+oCb
	qciBtk8wXAcIPS7Jqe/80zqoc7G1Lgz7t84BR70Mk3jWkV0lN6Ydf+fjgYeGQX+K
	Tt1zzw2kVxHg9MzlMauCTN9qP5PzVpWsijeMrth0mcHOj9+hyjvVOUdHhAcsERZc
	03qaMCNAx6bIOzkHA/NBtjTq09hlY3qFlJvDrz/Qobv89e3GTQQvnt+ziC8kbCr9
	u/X16bqIA1lU4Sa3cSH9BqqC7RnIGxDwoEPqxzOjNrHc32pXdXgPszHezwIVBUNx
	1BsAR7PqrN8BIlHQBNXELoi6lcExtF2Blz9jdwh/b8qp3pGBOO+RUfc8NK/mqpoh
	g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br1b8cqkj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 23:22:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60KMP2pG038729;
	Tue, 20 Jan 2026 23:22:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vad3f3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 23:22:42 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 60KNMHJP021675;
	Tue, 20 Jan 2026 23:22:41 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4br0vad3dm-2;
	Tue, 20 Jan 2026 23:22:41 +0000
From: Jane Chu <jane.chu@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, stable@vger.kernel.org, muchun.song@linux.dev,
        osalvador@suse.de, david@kernel.org, linmiaohe@huawei.com,
        jiaqiyan@google.com, william.roche@oracle.com, rientjes@google.com,
        akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
        Liam.Howlett@Oracle.com, rppt@kernel.org, surenb@google.com,
        mhocko@suse.com, willy@infradead.org, clm@meta.com
Subject: [PATCH v7 2/2] mm/memory-failure: teach kill_accessing_process to accept hugetlb tail page pfn
Date: Tue, 20 Jan 2026 16:22:34 -0700
Message-ID: <20260120232234.3462258-2-jane.chu@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260120232234.3462258-1-jane.chu@oracle.com>
References: <20260120232234.3462258-1-jane.chu@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-20_06,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 phishscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601200194
X-Authority-Analysis: v=2.4 cv=WbcBqkhX c=1 sm=1 tr=0 ts=69700e43 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8
 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=i0EeH86SAAAA:8 a=PxEJfYR7Scfl-YKRXAAA:9
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIwMDE5NCBTYWx0ZWRfX3gVGkzcRt2SQ
 98e8PI5EAvbOuz+PmmyvV/KL7LAwny8VM4GcR/G1e0VFlnTwoR8jE/KdxOJSxekhH8vVl/7yZTB
 yZ/xV9Pwf6ttmhiAlG2FpHZVHit5VsHj8G43wEnkivuTrcAZs028eF1pC3b5YKVxq9W98w5OVbj
 JbyUsDJC1fCyImotQxmyBg70gNe9VLPBjkRhGscnYcvyiwdjg2yXU36SC9pmQx9e9+K2QIHVjLL
 Ov84cBSMjkqiTh7k5ER0JQHmUqY5cck9y/yhfsklBpq/lPdOSwsBniYi3Gp9jBV++SFyfQ0RDQV
 nAvT/frVzEht+WVI7V5qaa8BsG1Mh1SFXv6UQQZdJMzLyghANrvI+bP84VU+IiyjSu45Mnqokpy
 /soIx8sfuHnQi4sMvocQZzBUW7iTmM/TYWCPQZFCY4M23JSuQsr89z0Hf4iigPQyTEmJdm5CiAF
 CxoXh6XCNBcUn6wjSjQ==
X-Proofpoint-ORIG-GUID: rKZ-HgulsFA6zVF5N_wZi_Mu9NZZoBvi
X-Proofpoint-GUID: rKZ-HgulsFA6zVF5N_wZi_Mu9NZZoBvi
X-Rspamd-Queue-Id: EAE49C0008
X-Stat-Signature: o9e8tz4hpuyi3bbpo8zzg51jgyy8deij
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768951380-110222
X-HE-Meta: U2FsdGVkX1+spUvTkuKdLAtpBfneyBYhGcFv+CNmTbBAXBaKv2B/Z/qYo7P5du5XFX6WMp4PnBecST12DtmUbnU/jeQt5Uwapbt8sKV4A36cPMBuCkhcDTTNoi0XjF5rtmU0lZ47RxEqz2MQFAeaeKgc+UXbUOBLzbA1ezMAWENfphT+crB8vKTBsAxc8IKxcwEq64JdpDUARj7V6of5w3OC6dR+r0iH3ya/AQBU2Zcxdc/8UYoOpMW1xzy6YrPs69C6Go+DUOM42QCP6gGfjsJtmrlGD3GZ58lr3TGKtAakJI9xe+YlIHwShOF0oucjr8F7GxJsi+LkYfOqZdJ70PSZNKMylVxx1OZQuYZAtLEpYawBTL03OnjYt9a33Cu4o1Yfbk1RrJi5qw6cj7ZL02M+zh/2G8JpxxBB8rqf/t13GBbeYMR5v7ywSjUzR6DCK2Usb7wOH06l2xPhDZNGiUOJXj+m2Z65L3UHaa0pteUjsiIgYpfPjJtiGWKNjGE+rfx0NI53XV24JoekBwQA9WlJmnd6nBhPSGidj5m7B5/3d+ELU0iZoAcQyiyVLaNB8kZ4BYKAJ2mPk6V4Yg49cfRqOWojuQsODmFJokAkw0CswdUVVW/f9QxA4SFZU5uuAFkUurXqceIpkmcZXTRkQ5QoXVGY0AGq/SZUi72FHrlPmvbuRAmoBvoRARgMHRDSBkVgvBtbruJzjUg2O1XSbacC8Z2PxHjz0js+1PaXYfMzfdctzeAD+ZBMBoozerskhocZiUSwHZ10560KLWNmMKn41gSBHQEjdXLuWlQQ7d8rmvLn9rO/wS3J+RU5HBGEtOgIGjl7F3xi6jqvlYxXylkKukN/Is2W7EysLiThF/eDz+L0oxnBtNuN7jscGyCYffGDtBRvS+CMQV6fq2tC9vXdW0VXHFbPlRr9SE0jzBJ3SSND+O40c0GVNHGAlRLgHJlp3fb3QBDfnJ2+Fze
 JDN2mMte
 1BUP815luPlzPKCntEEy0/SzAYVmgXpX3+xYtLKvF+SUxChiZahVIHlL3lS0b01ojb8S0f3Z8y1SV+fyikxnEo3grcjIQPzMvQu76NFIOicl2nZcb3XeJAThxPySAUu6OcLxDDTIQXK1QlKzpz6lyn4pxhpgfz0gEs/P5gzLiRF9zcMm1E130jU3pW5Q0rUuFpoScVeVj9lb8pgEEjtMGibAgAbiI4iSeVyfEvau0pCX17I/NZbL2PwoUPb99fYj0wH1LMYpB06oEIX+Rz7its7t/KTXBg7i9uF2h9DV+kmB2souBDfuI7oQkeZVHgcU+sRAjXMDnB5M1d2t72uc5lb9Th4sQ8pqrbWtN8CJUKuNlh+9M3rL4X4JT1LHWpzw/SO1WV9EtaU1nkFnq0kkx4tu1+P60dG8grVdsQDIaqEtp1g3l6H3hnJ6aioBBx0XuArs+
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
v6 -> v7: No change.
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
index 473204359e1f..cf0d526e6d41 100644
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
 
@@ -2052,10 +2056,8 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
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


