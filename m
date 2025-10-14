Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A5E4CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 15:39:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88B518E00CB; Tue, 14 Oct 2025 11:39:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 863068E0090; Tue, 14 Oct 2025 11:39:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 751868E00CB; Tue, 14 Oct 2025 11:39:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6254D8E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:39:43 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0079F11B0FC
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:39:42 +0000 (UTC)
X-FDA: 83997129846.21.185A016
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf13.hostedemail.com (Postfix) with ESMTP id BE83520007
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:39:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=YtYiM+us;
	spf=pass (imf13.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760456381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Wm5at7iaF5OGO9aI3neMRU6XnOo7cGQsqGNFW19C7S8=;
	b=rezH0+OrWqlmhsA/LV7h0V/QQugnVena/1O2zJVigyXmKM76S+r/aXqdmrnyHzFWCk1/pJ
	s8wSBOUtK+3Q8ySy33LajJDJVAfmavcfrmoQrIP0OK9IJNxcsElmC/0veG73BK7JVU1sZ6
	oivERDaOP4ZGFK2RPB1e+m56ySeqLUA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760456381; a=rsa-sha256;
	cv=none;
	b=6GIpRV1+oTNWKp/epKwxazcOsINkDNBo8Yh9Jp4hPUd9xuXB1wwEvV/rVwva1eaFbve9cZ
	oYpKWgg2tjcQlQogkoTQncI9MTTFNYXM7bjpp5GWhBRgUJpPW2sSbdFAStWE21U+YtFZ3r
	ZCovKqQS+o0814g6lpUfOdou+LB02B0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=YtYiM+us;
	spf=pass (imf13.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59E8vWNQ004069;
	Tue, 14 Oct 2025 15:39:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=Wm5at7iaF5OGO9aI3neMRU6XnOo7cGQsqGNFW19C7
	S8=; b=YtYiM+usk2dliwQ9wY1Ttg6Vz30kBdvXd7xQpBkaGNNaCNU5Iocco9arR
	/zoiwRurRhOWxII6Eu4rgGaZTbOwHRcUkKDMqXgxysGxDB+LarsP+9DcpMIy6pcg
	qX4TTCm/WZ7Q9GdPZf1+8KLTejLkcQ4C86Q3xQLpmnzdHP5jy1lmMG4SQE6EJGuv
	LlDrBhS+5dapvjtarDDyMi3tiabHQpimcM+gk7zhq//pGJZ25dNWiJVoDrzFQVUm
	Sjidg+oSbKf3LTA9ksqg1f84nSpn0apxp9GLHPOI87vG8mJ2EARRPtpGM39GRwm4
	rQDKCOmOnWSDG8YxfN682IPOuaJNA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49qey8qkxf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Oct 2025 15:39:29 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59EFckni019003;
	Tue, 14 Oct 2025 15:39:29 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49qey8qkxc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Oct 2025 15:39:29 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59ECQl1M015466;
	Tue, 14 Oct 2025 15:39:28 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 49r3sjbf1v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Oct 2025 15:39:27 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59EFdOoX25362978
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 15:39:24 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1554D20071;
	Tue, 14 Oct 2025 15:39:24 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ABCF12004D;
	Tue, 14 Oct 2025 15:39:20 +0000 (GMT)
Received: from li-218185cc-29b5-11b2-a85c-9a1300ae2e6e.in.ibm.com (unknown [9.109.215.183])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Oct 2025 15:39:20 +0000 (GMT)
From: Donet Tom <donettom@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@kernel.org>,
        Oscar Salvador <osalvador@suse.de>
Cc: Ritesh Harjani <ritesh.list@gmail.com>,
        Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        rafael@kernel.org, Danilo Krummrich <dakr@kernel.org>,
        Dave Jiang <dave.jiang@intel.com>, Donet Tom <donettom@linux.ibm.com>
Subject: [PATCH v2 0/2] drivers/base/node: fold node register and unregister functions
Date: Tue, 14 Oct 2025 21:09:15 +0530
Message-ID: <cover.1760097207.git.donettom@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: L4v7lPQ9NJXjKRFesvdVP-_Mfj59bHgr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxMSBTYWx0ZWRfX0CFUNLWjuH/O
 ZqGm2OlE1jWu1cjapFjLibDl2hRXHQjB0+CnGlHiVkCUYoEg4lf2MHma3Eutk+4FWCkdj5x6SdE
 AUMWUnb8rQ+f+EYvL7QmROE4Mp/KGo52oXe7ZPDv49j8VEhPAQs2KiaSyLShR6u45YKnf3FEGFv
 g2L52lndA/7NCtbZ12KGoyThd7+XJPe/3GnJhuNuS4YIRxPs5aK3dBUQXu8qVE7vCMGGkD3vzFi
 sS46jfuXhg2ScLJcWrgfxG+rOzcRGeXL7bwz3j56M5ybOdQXcxca+IEbuLmrCHDm6Zhom+nvgdU
 iHyHhkhbXtarSUqaquZg7hne5n/5CiNcHmedW0YzNP/hDaE4K3EKDncXlSxn5n325M3rvjTA7G3
 B4B+4/YQIUyUeRBtDVoQoDHpqturbw==
X-Proofpoint-GUID: f2YuwwXFcjJ6pCQGE8fsU_vrHwabf42l
X-Authority-Analysis: v=2.4 cv=QZ5rf8bv c=1 sm=1 tr=0 ts=68ee6eb1 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
 a=VnNF1IyMAAAA:8 a=KFY20ALy1DZ1KhuY3mYA:9 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-14_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 bulkscore=0 suspectscore=0
 spamscore=0 malwarescore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510110011
X-Rspamd-Server: rspam05
X-Stat-Signature: tf5waxq3oqzp7xpdrzu6aojchjs16z35
X-Rspam-User: 
X-Rspamd-Queue-Id: BE83520007
X-HE-Tag: 1760456380-806754
X-HE-Meta: U2FsdGVkX18agKRYZH9DVlPPRifhDlXPSXt9Ag65GcrkQZd6lr9cVOOSxT+a/XsiRfH7BNLZTVZYnTTIix5Ts26zjuW+IsGGd302yVSWFt4lUa5wLANjgDhtS5lpLiR1TZkCb+T5fZtNPyuJjOW4N5PFb2JM4umY1swEhgpi+NI9UQ6mAN/zuUMYEuQ2yic9x7hFOPTw208GmDvqQFjZITVd+TpXH8LEzV+b/LgPBnwWl47dim80a4ofHTbH4jFa0OKTOo5MAm2AApgFCGgFlwq99L18j8ZUP4BHWuncEcrndZW0gopAvoPD9/KZ+/14P8NcvVxhmsmeDQTl60eWyL6Y2EkAIsL6D+NolZjRCChfWklb0B1syLKOoBdYCI0iyPpLLwTLtXoVocWRnH9T/z3SkmBDE765/VVIA3pSmqI5m4wacJjJbNixMy5OjIYrxopjPA4brV9DH+oVaOjUf2NoJPTt/dV+r/jWZ7WcrLz3F7aC+ao4K91bcZm04MgTM96wqCUNO3+NyCMDe3ughBnVHwLJ3rflA0YxYd++VSKSM5InTPAOQr8TteqTQdYOdn9xNQOXoEb4caF68qTK4i6M0wurrvp/hRx5hLRZWd3JjXKFtxVcmferLCCGvJib9O6KxInC2ud11Ljwv6/W9SEcTkomAreDNXSnpHjt+dQgxvmDaYobnhkYKrlXgncxpjIXQ2BG5sYXMj13a9X/9PCAo8c65CeRk3WwBcOOZwyhRZcz7xEimbjPSjSo7phGMs3f7hGQ5ClwLPAeZlZOMFsR4arM0us0oDPyuHRRpzo4BcXKBNhx/kkesCi+gJQ5om4rK3dkbIYFRiVNfxJ3tWKlZtMpZe/mJ8DIbeWMqLKXUNBbuAgl4xXvQHReJ6qCbTPVx2UPYHfkvgdhO/ZRyaXxFeosAQonrkA+H9BxTk3Oh4OJZWh+hiXIYBnhm+FNbtLCi6gcBPIGs6ijo2m
 X+/6Xgnj
 0rdcMSuTSE06vFv3/dC7/znk/C1L98E/R67wqiumh0QVFB9jbP/7jE52zVw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This change came from the discussion in [1]. It consists of two patches:

The first patch merges register_one_node() and register_node(), leaving a
single register_node() function.

The second patch merges unregister_one_node() and unregister_node(), leaving
a single unregister_node() function.

There is no functional change in these patches.

[1] https://lore.kernel.org/all/5512b1b6-31f8-4322-8a5f-add8d1e9b22f@redhat.com/

---
v1 -> v2
- Changed commit description
- Removed extern from the function declarations of register_node() and unregister_node().

v1 - https://lore.kernel.org/all/cover.1758736423.git.donettom@linux.ibm.com/

Donet Tom (2):
  drivers/base/node: Fold register_node() into register_one_node()
  drivers/base/node: Fold unregister_node() into unregister_one_node()

 arch/powerpc/platforms/pseries/pci_dlpar.c |  2 +-
 arch/x86/mm/numa.c                         |  4 +-
 drivers/base/node.c                        | 90 +++++++++-------------
 include/linux/node.h                       | 10 +--
 mm/memory_hotplug.c                        |  8 +-
 mm/mm_init.c                               |  2 +-
 6 files changed, 49 insertions(+), 67 deletions(-)

-- 
2.47.1


