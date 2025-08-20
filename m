Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A60ACA0EEB
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 01:05:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B67286B00BC; Tue, 19 Aug 2025 21:05:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B17566B00BD; Tue, 19 Aug 2025 21:05:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B7956B00BE; Tue, 19 Aug 2025 21:05:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 82FD76B00BC
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:05:18 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 46E701602C8
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:05:18 +0000 (UTC)
X-FDA: 83795342316.02.54752DD
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1C43D4000D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:05:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=f9rqNDyW;
	spf=pass (imf07.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755651916; a=rsa-sha256;
	cv=none;
	b=CM+w1bZfRI9N+PPMc1epUlvVBDgfY3pDjDbSSIVugUabujlMpBdLUlWBv1r3NqoSz//Vu3
	ITnNwuIxkKxMUU6exF0S9GBemZc++DebrcMTaxOir656baw+UGF1f9Cc2AFkPBurM3gboD
	J1FkmDJgBuRl1ko5sRnTn8iqz1tJIkk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=f9rqNDyW;
	spf=pass (imf07.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755651916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/DmF+MuOx9lfBDmRRC8FPNiO57MW57fL18nJmrC16ww=;
	b=i6/QIaF0VbUwboDZzaROJbG9a9itMt2Nwu7J+hDT72Axfpx4w0vjychXwtPVgNxrn+/Lup
	WJB+f9P7+S1r/tbdJEJuYkLVhtmvGIk0g0oue/t4mTwzUFifb0enu/ScDKxSBVwgVxAZ+z
	ZALMWHKsPEKh/2aoFb8xOv7r4KPkd+M=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JLE2Aa008324;
	Wed, 20 Aug 2025 01:04:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=/DmF+
	MuOx9lfBDmRRC8FPNiO57MW57fL18nJmrC16ww=; b=f9rqNDyWguXWS8I3hcAkX
	X1+oBex+YWZjxY0OjWF3weAMJoB2p1d19UfDHmEMJ/Zd3EPCw7YnMRAdlWBkUa+I
	XzW12RSIvzijTDDl/J5h+i5AKTKm4492PkE8He4GFKmTXv3kdmE3ZmWkYnl+u/tH
	IS1f4fSsd8YOBXg4UzcF47uMhW13LpiE11UpOIJI/juZcUfTIfzDxH07Fy5UkVX2
	AACD+gZjoNaxb8+Tv5/EU+pyFh7aCo/10g4hyCk5xOeeM5sHZH1Ktzt0ob4HyEtM
	uydW/XfgTuxCWSPo3dcGI3vpj918cf/PQZvm2LVNkLUtN45uFsWR3CcohbQN/LRI
	Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0ts88gk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:04:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57JNZVeL007332;
	Wed, 20 Aug 2025 01:04:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48my3q29w3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:04:49 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57K14NdM011685;
	Wed, 20 Aug 2025 01:04:48 GMT
Received: from localhost.localdomain (ca-dev60.us.oracle.com [10.129.136.27])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 48my3q29gw-10;
	Wed, 20 Aug 2025 01:04:48 +0000
From: Anthony Yznaga <anthony.yznaga@oracle.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, arnd@arndb.de,
        bp@alien8.de, brauner@kernel.org, bsegall@google.com, corbet@lwn.net,
        dave.hansen@linux.intel.com, david@redhat.com,
        dietmar.eggemann@arm.com, ebiederm@xmission.com, hpa@zytor.com,
        jakub.wartak@mailbox.org, jannh@google.com, juri.lelli@redhat.com,
        khalid@kernel.org, liam.howlett@oracle.com, linyongting@bytedance.com,
        lorenzo.stoakes@oracle.com, luto@kernel.org, markhemm@googlemail.com,
        maz@kernel.org, mhiramat@kernel.org, mgorman@suse.de, mhocko@suse.com,
        mingo@redhat.com, muchun.song@linux.dev, neilb@suse.de,
        osalvador@suse.de, pcc@google.com, peterz@infradead.org,
        pfalcato@suse.de, rostedt@goodmis.org, rppt@kernel.org,
        shakeel.butt@linux.dev, surenb@google.com, tglx@linutronix.de,
        vasily.averin@linux.dev, vbabka@suse.cz, vincent.guittot@linaro.org,
        viro@zeniv.linux.org.uk, vschneid@redhat.com, willy@infradead.org,
        x86@kernel.org, xhao@linux.alibaba.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH v3 09/22] sched/numa: do not scan msharefs vmas
Date: Tue, 19 Aug 2025 18:04:02 -0700
Message-ID: <20250820010415.699353-10-anthony.yznaga@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250820010415.699353-1-anthony.yznaga@oracle.com>
References: <20250820010415.699353-1-anthony.yznaga@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_04,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508200007
X-Proofpoint-GUID: kkX1jrsmAmAWOAdgPkvoTgAV_QB4TK5z
X-Proofpoint-ORIG-GUID: kkX1jrsmAmAWOAdgPkvoTgAV_QB4TK5z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX0BPSeq4GrA/L
 zcO7Tgz46CTrssMsJV5wS1/futixs+GLOYvakk8NrmOdZlica8nXpVsUSRCkA2eufd8HR3A7ZGu
 WtfGhUo7KPw1v4ADEbD1xtPqCJN5vIyzRB9ac4rYNSMoh9Xf6GrckvYH9Rgps/DdSoAyuGQ0Ec9
 YHfvbvxxYuoolnI0WT2SMefEJjoO25LD7Z64ZnQV6HYfm9Vb9u5vSUrbw1wnLThPSrKkDshpYGr
 miZcYEJY5ZQbPMEIKle2JH2tFBGURcNhgLj5EOVLXCGXWHaL4yiv+CnPJV+gkZsBDPqvILdjQmu
 73cvbt3i2u/bDVPuI8y7M48qB0CmuupNGTgM0hugejYo7jfAjySQyqij8MdACSaDDCl8RJSjBvq
 02W20G4UPnLctmK5FXLCr4Lt7Xbh5w==
X-Authority-Analysis: v=2.4 cv=HKOa1otv c=1 sm=1 tr=0 ts=68a51f32 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=2OwXVqhp2XgA:10 a=yPCof4ZbAAAA:8 a=2OwiNFxuFh20pgB9HS0A:9
 a=UhEZJTgQB8St2RibIkdl:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=QOGEsqRv6VhmHaoFNykA:22
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1C43D4000D
X-Stat-Signature: 9g58ophthkka9hmaysfctmty87i98ame
X-Rspam-User: 
X-HE-Tag: 1755651915-984694
X-HE-Meta: U2FsdGVkX1/6yuAEZnOV15GeHyQZiZ+IDWeh/kqiW+fvehZFiPdpJi3kLKxarvzrymC2+iEN+5u7AZctN8UKfsCQcNRA7knmPxfmkTjmYpNJn+ak7OwsOGfskct6m//Cr/XnKRcFtkr2qSGBgLvX8ZaUGK4lcTcNASEF1+0OhaLTAojyJVyE1CTpcmb/iyAa0mNS8fjiQD9UiG9Jn1Y7KEwHaTOczlueyceNGHuct1URVoai9EaF8MQRg5cM3S4uXbtfql+HAWBN2P0CNg9tKfXnA5zX6yv6Fii9sfyqIo3Gq50PKOuNMz7yp7JdgLYKSKzODof1zPtorXevZ1rxEysJyrh8JZaQYwqKXuVtap8SkFPbNIP/RDBzpO/jsvQpZYon+Q1YhmqboEksdMmgu/j8uaDvQTNvE1lnrG9U91n2rBvVQojJnTzeoYyBQuQYgw7yv1oK79LKyztb5iVuQGeCQdYZ3VFaN5wQhOI5PNcWygqYdV6FCNhYxckojj0xgwgb4MGuJ2VlCaP63hhaPvkiqfV9W/YO3aUO2PurNdEVaIm829FnzT0SzWdGLSw7TS3+NOlOtQcX1pVoXDPuPJSgKVRq7mEAayK00xqaMijY/8y+Z5p198ynkpzWDLPrkXe4bfLMguqaoRyJblkwHWpPzkZMxul1cwnCX0Iv19Nc6dOQeyU0psa+LhCwFCepx86GaG9DhRFdLYzZQuCkW0l3ggdS0N59kMPeK5E22JolZedeE3JauQEZc9CF5X/aadObcO5ngC1JM3rRzhn+nP/Xwm2Uzb+cQLlO+xkAhxzxg5HAmFfVoYDNojVTj/KvbbG+HuDlkMzkecIhATf390vV2b9tnpKOjLhDILqzLrheT7MPeSsnY6oOgfGEFziu1T4ooy82aZVvbBRKg/AmpGZqgPUwD3Syfnmg9otz2Qm2ll9HpyDAJJtPF0EOMo2XNW5wf3MmKU0uGxFI3Nz
 UccXbOYc
 gYRw1LHug3F74iEMm/nfNte/4I6zwhwi4mUX0xWNmcdO7dSlmQq9vcd4+feM6JdMVP23pBHfOsR3a5CRhmI5Qw7N1W6hTbi/DGvL1/3Iud63Y2fQqkIBz3UqvP7wOwWjVkaq6EiKbaFwvNVoQ2YHUBjZMk2JXtAA4AOV1ECczPcr8J8zbTO3nlM9N2LwehKSRGgkQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Scanning an msharefs vma results in changes to the shared page
table but with TLB flushes incorrectly only going to the process
with the vma.

Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
---
 kernel/sched/fair.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e256793b9a08..6f28395991cd 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3379,7 +3379,8 @@ static void task_numa_work(struct callback_head *work)
 
 	for (; vma; vma = vma_next(&vmi)) {
 		if (!vma_migratable(vma) || !vma_policy_mof(vma) ||
-			is_vm_hugetlb_page(vma) || (vma->vm_flags & VM_MIXEDMAP)) {
+			is_vm_hugetlb_page(vma) || (vma->vm_flags & VM_MIXEDMAP) ||
+			vma_is_mshare(vma)) {
 			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_UNSUITABLE);
 			continue;
 		}
-- 
2.47.1


