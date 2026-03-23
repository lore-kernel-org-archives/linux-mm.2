Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A31AAEC01B4
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 09:39:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A97E6B0005; Mon, 23 Mar 2026 05:39:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1818B6B0088; Mon, 23 Mar 2026 05:39:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 070306B0089; Mon, 23 Mar 2026 05:39:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E72DD6B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 05:38:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7FAE28CAE6
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:38:59 +0000 (UTC)
X-FDA: 84576828798.28.8E8E749
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf21.hostedemail.com (Postfix) with ESMTP id 50BC71C000A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:38:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=rK5tnbcD;
	spf=pass (imf21.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774258737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FrpeyILK0ENmphnVW0EZaBCf4uaQTSWsxG6M7lM7YJQ=;
	b=We0II/29xuL0EHjKWiKE622Vm3fJwqbAZetc3ajeyLNp7rTyJbbzI7Bcr86vEgORM+t0dl
	AbevNy0pgN7XyzbKLv/3O4yw+veqLbQS8rlxvSpciVFN+2ADnGInwu7HQNYpZB5S+A1mL3
	svJcwv+vnKwSqlCS0j5gVRVEzmOvUIQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=rK5tnbcD;
	spf=pass (imf21.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774258737; a=rsa-sha256;
	cv=none;
	b=gXOfv+pAXmw8445vCPCaBejO9OBCuw/Txn+oIY42MdiEMZz3adXrM7tYLmFgQ1d1OuWWcL
	vsVC6jgeFvnD0f+/xlaEz7J7B6UuaYmgX1Tcab06/BfEXyFjDFHFv6oQbqWQSRLadmvezn
	iazHySaF+oyVjKBAfpgrrxS31xK/IcE=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62MBxw0l3556089;
	Mon, 23 Mar 2026 09:38:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=FrpeyILK0ENmphnVW0EZaBCf4uaQTSWsxG6M7lM7Y
	JQ=; b=rK5tnbcD1XsxX4nJnFJAEw2rb01jIsVi7VR+XpEjF5SHBGZU2mVdp6Ild
	Xedn1vFX6uSHzVZR5gEVkOaxqX+gjrkphLVM8hi/YgWD5FC0RgON91KtjxGAUBrO
	jFIHxx8Un+0VoNvPvkf3v/yHO6LiBnoQObWjZbe7Lrd/J6BcOlPsEz9D58JGklJi
	4aaUyvRNAlnhViAPE2v9/NY0OSZxDLqGoHQHeCBR0a4NgFW/ztIYEq2H6CJDBzve
	dNtzG7ZMF0USb3brrfbTmMtw9XrGPi4QOx6eBWpG/Li2haZvN9sAcrCkOEWCDB5E
	6hwwqAmwmRCT7PNHw2RfSorYsJu4Q==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1kumdydg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Mar 2026 09:38:46 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62N8ntjB004387;
	Mon, 23 Mar 2026 09:38:45 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4d28c1vhyg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Mar 2026 09:38:45 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62N9chNh51183914
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 09:38:44 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D650520043;
	Mon, 23 Mar 2026 09:38:43 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B7FAC20040;
	Mon, 23 Mar 2026 09:38:41 +0000 (GMT)
Received: from ltczz402-lp1.aus.stglabs.ibm.com (unknown [9.5.7.39])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 23 Mar 2026 09:38:41 +0000 (GMT)
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
Subject: [PATCH v2] memory tiering: Do not allow promotion if NUMA_BALANCING_MEMORY_TIERING is disabled
Date: Mon, 23 Mar 2026 04:48:49 -0500
Message-ID: <20260323094849.3903-1-donettom@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: YhatTrWyUVC7CbINhBnzn3MhOaw8FOAv
X-Proofpoint-ORIG-GUID: jwABisIW9S4xwDLhWOiqrNHnbGO6tMt8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDA3MSBTYWx0ZWRfXy6a1k2bOriWK
 97kXvapesY0kHE+7oYb4XC/qsn0DiEzXjDRsqMBPF6tVcZNKXsZ3XNYDkhlHBdM/xrAaOlS7d2x
 Zd+qz3TqkgPdRGCbThqP2quywtQlErAlPZSwomslAIEfY1L8EoorQ/PBYCep5ycbNZPoI6J567W
 hnEGc5HEfwe3h6HqAVEv65DL7gWj2ZY8pcO/XZlC87Pra2zvm3+Xz6ORfYtoIakXSFHIJB8RcPr
 TNeNYGW9u33ql8EYYxC1qjybActRkw08YzfCXSG4pLaTgqifaU+mv2H9cvTOVGoMkid3Epz8rs7
 XA2v3sGm/aclKazOweZd/L1eRx06+TVILNvx4aDNj/Lxb5QwQbwV7s1y5NqVinuK3mppa2CXW5g
 gnevMDA1JkD2U0n9FBCznPNO9c8+oA0HxQwAPp7MReck3hbPYAFJlonARxpPK2lJBBlfoFg/Il8
 p533qi8g/Kwhjzt778g==
X-Authority-Analysis: v=2.4 cv=KbXfcAYD c=1 sm=1 tr=0 ts=69c10a26 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=z67VAb8CozsjbE2CDLsA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_02,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=0 malwarescore=0 adultscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603230071
X-Rspamd-Queue-Id: 50BC71C000A
X-Rspamd-Server: rspam07
X-Stat-Signature: y4z1hnm6oxec9bm457mi6gokyz51mdut
X-Rspam-User: 
X-HE-Tag: 1774258737-513967
X-HE-Meta: U2FsdGVkX18h+cr0JlW34lIWtFPjuGARSueZx+kXX/nULR5qtv6GKbXQkA1d3wYRqqamGObXXvcbGnQfZ5rz/VkoFVDNUnVg9RBEqSF7lQfG+jMa+iMMUWA1EXJ9Bt5iZ1UOW7JdWz0m+DYKt8XPutcwnvUKrT3WI98KOzqQ4RM9Ho5/Xqwg5t3KWIIyCO1jdvA7mgqXN6m435jJEvIVkLw1Y3jWvGYHOw3r+lCR0NGzc1qG13ePx0nGOf9L49z9wj4v8QNmJ5K+iH4xPL4VQKAE+nNWB1qNiC/0JObluoT1RAcMrHw9usWt+LRcfxfVJB8/q1AngANvpvGuMD6sllIObvNbBThTDDFBVUWDH7qY+XmfnEvm3D7PvZ4dg20xUm+oeyPvrXHfM2MVQYnWOkGMKq0flmGLmsYf1UDDhzQ0ADDk6X7W6U3/qIVJk4KpMJGV4ayy7L47J2lF9LiuvQa9C7xJXGj5Y/qa5MNYdaeBke7uFmTkja+On3XnC4AuTUfrnCE16aKzl5eTNXh8wYx1bUhXokR1dyy2VBQgC+TCIPT3+feAYcJpnmNcymQfdcN9WRSfvfjJPyc6rHwAq9n25+HTMnN3MOsOHuBwaDaw67do45KCJIK73utYnCs2FSWwyj/eda9shLlwvFog6zZsYG+QrgiegzNc/OouoBv9F3Qabw8EIJMDrtfxBc4rblYjrGmN7z9Tuw6WJ0SoA3MIqohCYDdq/HlDQ0eonhFQd3Qkj5IfeTwSxF34lqHDdsNnWJU3IdNPZZkloRexqMey7jxUAaRg1u03FiZLlTVYmaxwulrVTF4Deq7HTFjfOVDkMOzvWnaOulTTYCOZurOkHqtoidUdMaxmUA5kIs0d2qUZ1HWM9V6odyT6nDQ07b5ct7wYzOJcXEwp4kY+xFiqOLJZzKf8685sadKnZMj/YfNy24yf3yFdfxiR8SKN530I+B5hT6K3Fo0GhPG
 61kjLlt8
 uVc68U2NvIwxxj5+afr+NNZ3eUkm69TLoUbeQ93zwwAnyAi/L1Uf6VvSig+tEdsqJB7uZRuBTv/ntpWawt7Br1dZ2nX3N26H9y0KqcYiuv+Kn3FkYYvviIkTLTV6wX+MqMX3/vPFxffvoZnFV73EOzU2OVIuTU0OcRvdo2AJ2qZHto1rOkdOox/UacmTZBi8tPNSET0nHUwe/E4IUtmZtPWMrkieAVkWqRPHpHFvZ7YdJpzHZWPXMbbCzJ4Pu6IiO5rf4Aj+44sf5+dLR3KYJqPRLTr6ulElyxONWT0tBZK1wTOyWrgUlgu3xWO9BRun0nRuKNVL/f6z6m5noMaO/MnddsUT0/SpmeY0GMH2nvAQYbrZnMI0EYKPoTthKtfDj6HSSxtGlgQkItSYyT3K2FjP3gpgDIeYGK/0S2EZhZMC+sXYbmQn/Nli+jQ==
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
can retains a valid last CPU id.

In should_numa_migrate_memory(), the decision checks whether
NUMA_BALANCING_MEMORY_TIERING is disabled, the folio is on the lower
tier, and last_cpupid is invalid. However, the last_cpupid can be
valid when NUMA_BALANCING_MEMORY_TIERING is disabled, the condition
evaluates to false and migration is allowed.

This patch prevents promotion when NUMA_BALANCING_MEMORY_TIERING is
disabled and the folio is on the lower tier.

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
v1 -> v2
========
1. Dropped changes in task_numa_fault() since the original changes
   already handle runtime disabling of NUMA_BALANCING_MEMORY_TIERING.

v1 -> https://lore.kernel.org/all/20260320092251.1290207-1-donettom@linux.ibm.com/
---
 kernel/sched/fair.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bf948db905ed..4b43809a3fb1 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2024,8 +2024,12 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
 	last_cpupid = folio_xchg_last_cpupid(folio, this_cpupid);
 
+	/*
+	 * Do not allow promotion if NUMA_BALANCING_MEMORY_TIERING is disabled
+	 * and the pages are on the lower tier.
+	 */
 	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
-	    !node_is_toptier(src_nid) && !cpupid_valid(last_cpupid))
+	    !node_is_toptier(src_nid))
 		return false;
 
 	/*
-- 
2.47.1


