Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E5361088E6E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 09:23:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56C156B0361; Fri, 20 Mar 2026 05:23:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51CD16B0364; Fri, 20 Mar 2026 05:23:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40C496B0366; Fri, 20 Mar 2026 05:23:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2EBB16B0361
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 05:23:23 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B19C31E1E9
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:23:22 +0000 (UTC)
X-FDA: 84565903044.12.84CEAF1
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf02.hostedemail.com (Postfix) with ESMTP id 289368000E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:23:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=QPPFzL4T;
	spf=pass (imf02.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773998600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mbS3UVgCzuA4zI9381p/w8C4+NheOUI5iPHz4JjpKUw=;
	b=lvS88cuIFM1/uGBiMa3w8C1FrjzHnVTtBefmRF6DU77XAETg8HGdF+V5bu2ZYhmVo6nOrl
	d5OTG/ApABHqXfw++geRVwbwIgHt533geqKthdclafYI7DRqIpS7et6uSO+cRt621QiGxX
	s4UAeO5YD7J4uBouEsGUroPtvmDPLv8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=QPPFzL4T;
	spf=pass (imf02.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773998600; a=rsa-sha256;
	cv=none;
	b=hy4wKsCrcjIXM+iqgm7cqIlL2sK8PnZHLb2NsGoh32P2hpYaXUhgE+baYX57psbskrsgjo
	L7hudPYdj0R8MPVR2mmjufRAJy2VbY+cwx/aqaizFcKYuygVDPD/eH6nBbBTbmQAVt2lOB
	XDOd7zr9m9YgvuJZULEib/MGWnqb0D0=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62JLSrZt3931551;
	Fri, 20 Mar 2026 09:23:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=mbS3UVgCzuA4zI9381p/w8C4+NheOUI5iPHz4JjpK
	Uw=; b=QPPFzL4T3bOhPGYygVjm6//0ROdK3plNSoLFTjCLFiONE1DHIexPQl+0h
	zV2kaOc8jrG8e6Ok1HCZ6GHgBsoL5EFLmDFKBOCXdHkhVNyr1LhQBztU3yLogKC/
	zgZQfD49EGbV8+umFiWUhlgZrcZGGzb8LR4XqQYn2g7GovPucJc5Te4SrQZjNwl2
	0nVyZC9+/VZ+jZPr5MMw8Cbvis5vtzr1AruAxpwM6z7sgk70aB70PxYTBXVpKwAc
	haALVyFiCPGkRgt7d/nCCo2FCCX7n2RI0R7v+FHgGGB45FtivcanOA+rxb+RQqiu
	XaLmQrmZ5VpCC68qi2Md/RPV+AuSw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cvyaut0ua-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Mar 2026 09:23:03 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62K7IwaU015662;
	Fri, 20 Mar 2026 09:23:03 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cwk0npjb5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Mar 2026 09:23:03 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62K9N1AF53019110
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Mar 2026 09:23:01 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 02C6D2004D;
	Fri, 20 Mar 2026 09:23:01 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 544E120040;
	Fri, 20 Mar 2026 09:22:57 +0000 (GMT)
Received: from li-218185cc-29b5-11b2-a85c-9a1300ae2e6e.ibm.com.com (unknown [9.39.27.18])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 20 Mar 2026 09:22:57 +0000 (GMT)
From: Donet Tom <donettom@linux.ibm.com>
To: David Hildenbrand <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ying Huang <huang.ying.caritas@gmail.com>,
        Juri Lelli <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Donet Tom <donettom@linux.ibm.com>
Subject: [PATCH] memory tiering: Do not allow promotion if NUMA_BALANCING_MEMORY_TIERING is disabled
Date: Fri, 20 Mar 2026 14:52:51 +0530
Message-ID: <20260320092251.1290207-1-donettom@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIwMDA3MCBTYWx0ZWRfX783uuiwJEYNd
 /y9O2VM8VDTcmju7Uk+1G408TMNnjsToVLyfSGgE03XEUE/ebUyXZTyKU0B8qprzQh6OGB8E2on
 a3cnd4MPnfMOOmTmG/DzbkoeAzw6qeG6fQyJOZ0XeiQPs66cG/XCSGsGNO6MrYA6uEIn7xKZ358
 3q4YYotDe++mTmklPG8wC1UPUS6tnmv69aZeP/6QPetjT0Ya8ShqK3mL1oZdQ+XDYQQWlNeSp1J
 O/eJwv8wIVQhUgB/P477JqVKoAXfOaxnf6ncVw8EoSEOFnhWKA71f+yZLXIn8XBqu9bkQVrzpQV
 KzG+RQF9l5rJzncE7mVbtGtgpoDB2cC11BQTLkDzQScQ3z5GJsLyw+KFu3aouzeHYOi0Z8pYNGo
 8IJx8voY1EsuxjdSLWb/INXM0NHt5c+x76jH7V3sqQCCVf+EO+jCeYt6UVzY/0q5rXYO9gbgj/T
 80uC4l/7uqMAstP8fzg==
X-Authority-Analysis: v=2.4 cv=GIQF0+NK c=1 sm=1 tr=0 ts=69bd11f8 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=EDtrt_EyerUz7RPuDBsA:9
X-Proofpoint-ORIG-GUID: tL12GTi9JSsEwz_sD2JLx8WeCkAJHT4q
X-Proofpoint-GUID: 3yc6RQnl1X3ABDGaExsKxDrcN8-W7ZJb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-20_01,2026-03-19_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 bulkscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 impostorscore=0 suspectscore=0 adultscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603200070
X-Stat-Signature: ahk3pqup9njspbnocyfakupx14myrh81
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 289368000E
X-HE-Tag: 1773998599-593084
X-HE-Meta: U2FsdGVkX18PNqMvIU13BxuMx3joXk844f5oswwSqore8BgbCprjMjO9SHNt9iYvexcwghIiTiGuB/nyfz4GztZS7ooqNWK1pbypE4UEDcWw6ibjMZwq+FvGpZTYo52B2aC9+VBy6tqoSJjv/z+7KKqxz8T0GM8CMvqfDb3MpplJT2daEjadigAFg247LCwnhF+ByZzOPjUpVeqmHNRfZklWh2v58+lSXgX8g0CFNKL+erSItSgk51xKq64Olzfc4bKCva+MsVd0G6j+fsyJkSKIj8HBa+wEtRIF4F5HNQJlfbRIH4kpLUK9EnWL0zv71NJS3cOxX/QhWAsL/ZpbnjFURGjD8jEDDdr3/S5seiMXv8KP6QHG/BnnvHjwV6R45Dx6yqXVK9GYn4lVpT8VtLvUaaRDsQGaK1c4FOjh2ppy7zDgVJ25uQCJ+hOjDYhUQY1/lGPmmasuUPazylNbtPh+9DyuMdXZw1Ksc8MLahLl7KJquUsa+ODtmAfsRuYM7MGnU9soYJa+pDpGeMz9qGF1Q0qaj9+uX+jHZtR/lnsZbyo/vZf3l6W0IXjztG6pMh1d+av8kLP45q+L6Z+y4Y8NwqOcAATAzoxdXcBoqMeIgd2mrcqBXn0qDX36El4FVytvWIh9OWhtx8aBhwZ7S3OIhNduZM77SR3oiDLtfwYD/hmDgmxT2NGxM+4ccXGrXafh8Hj/c9LQuJTrrJmvm22zU3rwDLKfictRZ3TbUBz5qTBjjKG39SV5sBz2PXt6B8B3d2inQ0J9JETLk7XdjH5FMzbVNWU0sbvQevVX7aL3TirbxQXACrnAP9vAuPGSECBpLCUozfLGlxGdsokddy6jTTqUsjZuZRnmVVw1cWTpSoX8YFddaopkRmr5KQoYTv4Okb9916rf8ly9nDkAqKhIQXsnVr0mzAEEuIokmEY0hg4dE0nBO5J6T/oDfhQ6MmQbWOn8HbQBAFeTYrU
 4HOJNE6V
 evCKJ2Uhba7jEAQA54Z1AbQqLETGzmveTC7fOT9T8ZWNQ1O2JlvXG6AWsnPN/RW0KRrZFqCHy4lPbECjFtpeEcVlKCwVskO4+PygGkDqmKPwayCADvKOlbQWSKFnq4JE2KNDnMA1j19BxnZCFuemhI0sy8u1DgiibucP5xbqRDfYy9L7WyaKYxNWG9PGxGbWfzRD/46glp9XQg/1AVrSZRK33CyC92pYY7i8qTkkWsG04begTTYOTkCR0e5rla/PW9BjW0hlXeDAQ6HcXy20YcPl58m0Ex5XJ9EajzFpmm/HuYTuElTA08Owbq5t0ym79fULf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the current implementation, if NUMA_BALANCING_MEMORY_TIERING is
disabled and the pages are on the lower tier, the pages may still be
promoted.

This happens because task_numa_work() updates the last_cpupid field to
record the last access time only when NUMA_BALANCING_MEMORY_TIERING is
enabled and the folio is on the lower tier. If
NUMA_BALANCING_MEMORY_TIERING is disabled, the last_cpupid field
retains a valid last CPU id.

In should_numa_migrate_memory(), the decision checks whether
NUMA_BALANCING_MEMORY_TIERING is disabled, the folio is on the lower
tier, and last_cpupid is invalid. However, since last_cpupid remains
valid when NUMA_BALANCING_MEMORY_TIERING is disabled, the condition
evaluates to false and migration is allowed.

This patch prevents promotion when NUMA_BALANCING_MEMORY_TIERING is
disabled and the folio is on the lower tier.

Also, when NUMA_BALANCING_MEMORY_TIERING is enabled, last_cpupid is always
invalid. Therefore, the !cpupid_valid(last_cpupid) check in
task_numa_fault() is redundant. Removed the unnecessary check and simplify
the condition.

Behavior before this change:
============================
  - If NUMA_BALANCING_NORMAL is enabled, migration occurs between
    nodes within the same memory tier, and promotion from lower
    tier to higher tier may also happen.

  - If NUMA_BALANCING_MEMORY_TIERING is enabled, promotion from
    lower tier to higher tier nodes is allowed.

Behavior after this change:
===========================
  - If NUMA_BALANCING_NORMAL is enabled, migration will occur only
    between nodes within the same memory tier.

  - If NUMA_BALANCING_MEMORY_TIERING is enabled, promotion from lower
    tier to higher tier nodes will be allowed.

  - If both NUMA_BALANCING_MEMORY_TIERING and NUMA_BALANCING_NORMAL are
    enabled, both migration (same tier) and promotion (cross tier) are
    allowed.

Fixes: 33024536bafd ("memory tiering: hot page selection with hint page fault latency")
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
---
 kernel/sched/fair.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bf948db905ed..39e860fce85a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1990,6 +1990,13 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 	 */
 	if (!node_state(dst_nid, N_MEMORY))
 		return false;
+	/*
+	 * Do not allow promotion if NUMA_BALANCING_MEMORY_TIERING is disabled
+	 * and the pages are on the lower tier.
+	 */
+	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
+	    !node_is_toptier(src_nid))
+		return false;
 
 	/*
 	 * The pages in slow memory node should be migrated according
@@ -2024,10 +2031,6 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
 	last_cpupid = folio_xchg_last_cpupid(folio, this_cpupid);
 
-	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
-	    !node_is_toptier(src_nid) && !cpupid_valid(last_cpupid))
-		return false;
-
 	/*
 	 * Allow first faults or private faults to migrate immediately early in
 	 * the lifetime of a task. The magic number 4 is based on waiting for
@@ -3242,8 +3245,7 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 	 * node for memory tiering mode.
 	 */
 	if (!node_is_toptier(mem_node) &&
-	    (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING ||
-	     !cpupid_valid(last_cpupid)))
+	    (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING))
 		return;
 
 	/* Allocate buffer to track faults on a per-node basis */
-- 
2.52.0


