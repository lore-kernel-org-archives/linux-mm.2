Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2712109E55C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 07:02:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEDC96B0005; Thu, 26 Mar 2026 03:02:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9F1C6B0088; Thu, 26 Mar 2026 03:02:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8DC96B0089; Thu, 26 Mar 2026 03:02:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB9D36B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:02:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3AC675C65B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:02:24 +0000 (UTC)
X-FDA: 84587320608.25.01AF60B
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf30.hostedemail.com (Postfix) with ESMTP id D3E0B80003
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:02:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=NyZijGO2;
	spf=pass (imf30.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=NyZijGO2;
	spf=pass (imf30.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774508542; a=rsa-sha256;
	cv=none;
	b=fH7KR4zldt8jMZFNxt4TrEegcbSdKZQKBMu2poZwDMXr8m4rylwAynOYVr52kCsna7j+y2
	V20X/QkFkN7Fppg8hzDLB32PI5+qWj8wJzuYILxwcUh3z+Ze/wvamqD1KhZyg3ZLk63f8Q
	kHjKXHqikhhykF88jvq1G3oNYIiwPhI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774508542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iwOs1prUtDH/XXF+qcPJFyqmEClbbuY8YtWyndnlklI=;
	b=K4QNPDRVuPyVln3KNh8s+fd6YTbF18mhQlT13211E+q2BfEfjTqyv2Ka3zOljMJq6sCHMd
	3Fy31NltgoTqaFmF8OkO89reflSyAvX5+7o+CuyGTXuhVcYzca93dF3B17W4MXm34TvtBb
	vlei9dO52QRC6KqEKvF+VTpOPatIWAU=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62PITX5m3850414;
	Thu, 26 Mar 2026 07:01:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=iwOs1prUtDH/XXF+qcPJFyqmEClbbuY8YtWyndnlk
	lI=; b=NyZijGO2c2j3Kbddb/FXGSB8VopJyvTvvhC81oGNm325gJrBFMuyU6PnQ
	ZyAUr88u9GqlbhB1oB4EweJdWac/G8Eq+VAGwpGMfiT0/sCWqIR0JiTvRFik0Pyw
	5w4h27JDq+hL9ZRe2HunJSpAwsynxUcj16m6ePcO53FvyZBQa8vWpf3S7rtG8zsv
	2pR3YCJW3ONBnH2UyOosGcbNdLm/HbUngyKmQ1BYN7kpeT5dyztOvb0bVjt4fJSN
	9LO1E+rhrRz1xFiyDXLCrgTMjOpaXkxZf2WkZzXEjrp+u3PVZP5xbJP8oySR5KGZ
	pYxN7wR4BCcW5VRHB6Ht4QmcCjvXQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1kxqm1q1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Mar 2026 07:01:46 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62Q1wAnW026771;
	Thu, 26 Mar 2026 07:01:45 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4d275m1s73-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Mar 2026 07:01:45 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62Q71hxL31588750
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Mar 2026 07:01:43 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 841762005A;
	Thu, 26 Mar 2026 07:01:43 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D40D42004D;
	Thu, 26 Mar 2026 07:01:40 +0000 (GMT)
Received: from ltczz402-lp1.aus.stglabs.ibm.com (unknown [9.5.7.39])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 26 Mar 2026 07:01:40 +0000 (GMT)
From: Donet Tom <donettom@linux.ibm.com>
To: David Hildenbrand <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ying Huang <huang.ying.caritas@gmail.com>,
        Juri Lelli <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Donet Tom <donettom@linux.ibm.com>
Subject: [PATCH] sched/numa, mm: Skip page promotion if cpu pid is valid
Date: Thu, 26 Mar 2026 02:12:16 -0500
Message-ID: <20260326071216.11883-1-donettom@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: CiaSF-H1fnPPyV5xXc-MOYz_Qk5Hvnp8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI2MDA0OSBTYWx0ZWRfX4KLfaAC6v9T5
 PRpSrbBqH09ZlYLbFNG3BZ6ZBuoLbcHwrQrVnCIrVtpPdFjb0blSvwXRjcT6NtxbHSqGvZsQA5Y
 zhNPEUdV2i1fkRfSyr7QMiNMlenU3qjN92lBESP9Q6GfMuMA4Jt+iMvrcvK2mNR6pP3TfbLetbG
 U4pVtmFM+zAoLf/zLIxVmBXj0L+PLa17xYnSGWZvJzzvXMKuAagOIGeX/AVRyqHDQMyEAYWm8Bz
 M6C41n6axuXvqCGuOR5Ux9kitHlWmFBqQzhUMH1eLAjnMZpfhbaWqkV1Yz0XO38uDunhDjdCjnu
 Dt7d16reyiOaFFNoGMUewV1F50jYOtm6HJ/2zRgY6wdpV5zzMdQxlqTEnWr8he4keo8a7QXxsak
 r9hJTEWew0hOVVOdwrXweTNmRBGfF6QN1eeyUWnbVPdSZFShm+xQmeciL8KXbYB12/l4tNbYemC
 EF8L2fPYf9j26oWAx7A==
X-Authority-Analysis: v=2.4 cv=bLEb4f+Z c=1 sm=1 tr=0 ts=69c4d9db cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=BU45FUZf6EOTpP1Kgp0A:9
X-Proofpoint-GUID: MJCi38OmNnXbfplKA4HoCHDbAQwVLJJo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_02,2026-03-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 clxscore=1011 phishscore=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603260049
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D3E0B80003
X-Stat-Signature: fe5na7dj49n7rpahfn77cx3qej45fzkn
X-Rspam-User: 
X-HE-Tag: 1774508541-695481
X-HE-Meta: U2FsdGVkX1/2+AvpAQMwpNTvfYdxNKPyJdoWDZFyil2wAYiBbJiEVWDnPtVJYMlGJzfa4/yTcdQyqRY0hbsvnI1TI3fbhH/tFhny1RM8mZrp4CY8lbRGQZIeaBKLmAc1id415oS5GRY+HYwViarWdl1BGiTS7H3ut/yOuRr6NBuqSkiCEU5aSJmr7TgNdoKXLqOmSq4JTIXxWg7CVz7REtzTxNEXr90QVTm9/Xfw+EgvnnSSQofPZ0KOxEeFnf1zXoNkHhb29/poTRJ2WNNy9QgukUXjber/IxwvgaWhc1W81D3f43YHDcA7ne6kG+s97CLmSrH4qHye4lVm6sgN6jHTZI398vz1aKK2cg2twkD5AphavRNxbZfXVrSA6DO1Zpin072PiHBl3t6kgXXyw+chw7MMHIRTGItYyyamGYE2AQXz1OAUOEtE/CEpTfpuWPpcP+UOAzgK4pcWebiLD/nhcRMypBMF4TaXYM/QlVqeLPNJR/zKXIL65sRNL+2XkBTwIhoQ4Mj4e9CUzBnix4Oo7DvpWNJhkophESKTSK/QqFBG2GYYmieSjh1t+Jbp0o8L3KRQtodl7a5hSnVPfiB6t9ZbqWzPuAD8ImnGug2gG7a5czY/Gx9Zylg+X+t1E5MsBhwlwtQe834A14Nr+zd9uVD1VzU4w2ad35OfBTQzslABql9BTekrrY1QAoMhdownWvpwCBgrVQukmF4v7A4bbVmpLD0xw9X8ySskm1ubJRXpW5JLhD0rZnaHzehQDoBxDzCFpmBhuKJ8Vsqrz7akPMBK3C1Ykx1vMQQxII7QfF8axogKQps0Mkhun6fs+CdD2rVPp3WVzgWhHNw1Fj2XVepZxCx7bdmY1Am57lhWDp/JtVQFCem49PFsM7qNGCis4ulPL8XICfzuGZqbwxYHsqHB+V3o7Fv7OHQzUXflhHXecZ5OR5R+hlh54EcOcQ/76/6/1MBQyBadug0
 e2lqV7O/
 OI3iKpsNmuRZ7IRJ88KuUs4mZ+jH434MjrBbWluAhie54PVrF+YvuTDEhK18OvjdJCFJWRn67K/++ezAoVVV31ZnbNCEgituw26HNLkFxy809hZm06LiWIsH/Xx0C79wj0uIzu2QEqL2Z95wA89G8JKQvBhzbHpdWx75HGbxMV2+mcLU+SRamPqIbNmqb055NTNxQy8Ps+zD2LIQrP2GKFDnAdSUpnyI1JMmMwHbo6pyXOM4VS/3JmjK0jxKa9Dvz/mTLx/3N/LdXCPmbwT184vSQpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If memory tiering is disabled, cpupid of slow memory pages may
contain a valid CPU and PID. If tiering is enabled at runtime,
there is a chance that in should_numa_migrate_memory(), this
valid CPU/PID is treated as a last access timestamp, leading
to unnecessary promotion.

Prevent this by skipping promotion when cpupid is valid.

Signed-off-by: Donet Tom <donettom@linux.ibm.com>
---
 kernel/sched/fair.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4b43809a3fb1..f5830a5a94d5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2001,6 +2001,13 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 		unsigned int latency, th, def_th;
 		long nr = folio_nr_pages(folio);
 
+		/* When tiering is enabled at runtime, last_cpupid may
+		 * hold a valid cpupid instead of an access timestamp.
+		 * If so, skip page promotion.
+		 */
+		if (cpupid_valid(folio_last_cpupid(folio)))
+			return false;
+
 		pgdat = NODE_DATA(dst_nid);
 		if (pgdat_free_space_enough(pgdat)) {
 			/* workload changed, reset hot threshold */
-- 
2.47.1


