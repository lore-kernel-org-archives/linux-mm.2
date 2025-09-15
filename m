Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1490CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 15:03:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D814C8E000C; Mon, 15 Sep 2025 11:03:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D58878E0001; Mon, 15 Sep 2025 11:03:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6E228E000C; Mon, 15 Sep 2025 11:03:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B40C58E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:03:21 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5489513B8F7
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:03:21 +0000 (UTC)
X-FDA: 83891803002.18.2187BA2
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf27.hostedemail.com (Postfix) with ESMTP id C3B3E40022
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:03:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=i0ayDrjQ;
	spf=pass (imf27.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757948598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=cSCcHOLheBZ60BBBWDtHpgyihcu89/daUQs3juAmLY0=;
	b=DvwzrGW3OSggpkBQ0OTQbzfvctYNjiCMHWeUYG3VhHqJOGiuEvYfiwNB2ogQid9GWWRL1t
	0OKCdvLwsUZG4TDkO6/cIqDBzMUMeEm/WDXXNg2snKGljmF9TX4I7tBNSQA2xHOfIcArDH
	EhPI9h/lgNgTbjkmjVFpaAiPuWr5kJU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757948598; a=rsa-sha256;
	cv=none;
	b=aUzCyvRTKpB4WuoAQNsSoUvLzaWPUDz7KNPpsib9SflZi8KAtaxqpVjk1J4PTdZZov66TK
	yrY4WqUjpNkezlndlb1rowZrw6aq17j/BzoX2ed96KBA5cLcP2rG/78Ctoew+t2KeD5c0q
	41MGqswummbV5kQ/A/pESaousNwnSHY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=i0ayDrjQ;
	spf=pass (imf27.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58FBMpZV031871;
	Mon, 15 Sep 2025 15:03:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=cSCcHOLheBZ60BBBWDtHpgyihcu89/daUQs3juAmL
	Y0=; b=i0ayDrjQVjq0lkBxaeMVC6wcFPu8TcD1cXvypg2vjSCjz089Xlf6SeVFo
	9OCsO2aFy3KbQzrMCf5HypFpyrfWJg8atyiJWOKbaMtYWyFMA7FCv2DXpZiQKFNy
	wSDVbl4x3iOhpsMCivJXTqR3jfOAJ8CxjXsdvnZ/qhsoTOf3UOX277bvkZHjVOra
	lT4asSwhrZm5tga99VzhOdslhpkkkFqRKopdYhA7gCID5ESi8peZYiWm56UijFgu
	EduIQCBmCKb6CcTjBH7+9GmhxSS/6NMMLgCvzPHq8rp5MjkJDPD04Ajufs3qG2Ad
	ElAfFP9y+nU1sN3ot6GH0FENIHX1Q==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 494x1tb1ny-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 15:03:17 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58FF1VfG010538;
	Mon, 15 Sep 2025 15:03:17 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 494x1tb1nu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 15:03:17 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58FBdItx027308;
	Mon, 15 Sep 2025 15:03:16 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495memxxqd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 15:03:16 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58FF3Cpd51314952
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 15:03:12 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5DF5820043;
	Mon, 15 Sep 2025 15:03:12 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9897920040;
	Mon, 15 Sep 2025 15:03:09 +0000 (GMT)
Received: from li-218185cc-29b5-11b2-a85c-9a1300ae2e6e.in.ibm.com (unknown [9.109.215.183])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 15 Sep 2025 15:03:09 +0000 (GMT)
From: Donet Tom <donettom@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, Xu Xin <xu.xin16@zte.com.cn>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Wei Yang <richard.weiyang@gmail.com>,
        Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>,
        Donet Tom <donettom@linux.ibm.com>
Subject: [PATCH v2 0/3] mm/ksm: Fix incorrect accounting of KSM counters during fork.
Date: Mon, 15 Sep 2025 20:33:03 +0530
Message-ID: <cover.1757946863.git.donettom@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=OMsn3TaB c=1 sm=1 tr=0 ts=68c82ab5 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=8dabxjvEmk4eI1i_HKQA:9
X-Proofpoint-ORIG-GUID: O6Pn4dbXVKFzHep12KWTtyqNC5MstEit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAwMSBTYWx0ZWRfX6FjBQv4Cc3yL
 yXvdYlJcNW8w/DURJa/TjchGcLgafZnS657WUjiiBosfIWYiEH37DyZLczSImTdSlvBC5Gw/zzF
 TY9a9hGCFEen6mJsdk93t1jghZtfxjRAmfn9yJ1tFj8vH6EtNu+LAbo3rQZlfhdSwWSV0lGB2qc
 nFlqntk/ChiBLdGKPcwO1t/tNNFr5vdyvHpzcOs6sCQ8+E6GBdlKObdqPPBPqX331HBV65gKSFy
 6JXZEevzEu2o/8q1rfHFAc0NI4BAKdZENeWE1gAtQFsM1R1vZuTxzcIaSDWYPspozqp5zoH6wN/
 AD0CPvSKoyUsR4NnPCJEvXbizIUDg6eCUfmKIkQw89ZuMXdZTjd9nIIcb+Rpay78nSsB/KB31cF
 UAP/QrWV
X-Proofpoint-GUID: 9AwENwd4pSzlgdVpYoJ6_4Q0WypDhWZf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_05,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 spamscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509130001
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C3B3E40022
X-Stat-Signature: e1eifkjy6oxcbuew7kokj4cau1b6tnqs
X-Rspam-User: 
X-HE-Tag: 1757948598-690655
X-HE-Meta: U2FsdGVkX18mdMnFCrIlBm0gA1g6HFvKX3fNyZGMVleFNgeyIDWwvE5oF4YJrH4kxE/vEv5lLSIdc3O0J3Tgf2PaogyDRjRpXjgY0rfRP3C9PbxJV8QugandzWj56XcBwLQ8MP4U52rLfiEoj9zRXrOZrfW7h4uHIZ1eOZsH9XZn3I6QUmlc5CAOQ0Gn78BFR8Fx6xjT5cZes7L84/BNFKBSSMc/150hGEtxNxxS45p3rHKBhHYI5CkJEpx1hDTI9G/+xXnNY3DJJZJUZq9OIITsMlGE4WNy78zd0BMdK0EKaLTphQLXLaSJcGbcWgc94drjr2lssRj2OYZCZy4X64EnIDD0YfBXfBHP9Kj7Cg49asdu+lKm5sFvnwmstEwWH5zG6xfN7blYaksAmXnioOjq8sFpJu9UNz+aV/kkjFomAMBFkFoTyJPfnxUt72AcEqRb1gTmnnoVaT8b1PqEQatXS8PAc4UCLKgbL3jKCwUf5duZSdMqknfJMbpADMg8GjAfqtP/CqrkI60Empvfdg+m+dYoAPO6gv7Vh+/F1jETK5xJW91IRnfrfka9qR/PO1JrRae5ExANUnU9EOcN3E+Hf8FgTBKM6hIl8/YOWqm0lqaPBfzutsPGAmxpm1ZvOfmSrGK9ZJWHiR4KIBhKQWXCTV0hwFZZqoJly91Qx0f6GWWFbltUayTZHtU0vcVeQbrVrsNciwXWaQ0lNuFZBbxNqjB+FvS6W9ycCqy2+keAqywuds6KVZ8nwnOgak2l8DpYvQ316ag29oLOVFAVLGvltK3Qw+Mi8rlWLB0ldpe+E2qAzKpqBGGQT+eRAfSQNOCThVj34BnrPbGZCuwOABJphBMQeqzQrJwTQwFagS/ic6dPGUegfZF1X2tRuy6Q35u6pqhsji20hQA4F+OtJmaJEh8B6YC2p8n3dRqVrYXaSrtJ/oql8TPXkhDMkXAUnSm0tFrWpbekxoqbau3
 m1YnF+4Y
 bbs6yUbpVhrGCMC0/MaTEUL8a15i5cqJV44hj82C4yzIeeTo2AXCIRa+M9DSZJ2JgoVbJAs1CsFGsuXmBQ/6nWNnrpuG5y+nCnn2stW7j6io6FynRxNPi3P6TY9zG9W7qTP4d7y3anoCb1w1nRE2fqwp0/zAu6L4WfOxlLBAo8cl5KGF/oOf6kqyIlgoL35t293thCsQMy544swrI+mJnJIizq68djmWEmylOIA0f53AJ/06auq7nlLNoSi3lDCWZUsN7C+0/U4qg4FsmNMJPEvSH9HDzQ3qRbGvavLoZE/0dIfY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The first patch in this series fixes the incorrect accounting of KSM
counters such as ksm_merging_pages, ksm_rmap_items, and the global
ksm_zero_pages during fork.

The following two patches add selftests to verify that the
ksm_merging_pages counter and the global ksm_zero_pages counter are
updated correctly during fork.

Test Results
============
Without the first patch
-----------------------
# [RUN] test_fork_ksm_merging_page_count
not ok 10 ksm_merging_page in child: 32
# [RUN] test_fork_global_ksm_zero_pages_count
not ok 11 Incorrect global ksm zero page counter after fork

With the first patch
--------------------
# [RUN] test_fork_ksm_merging_page_count
ok 10 ksm_merging_pages is not inherited after fork
# [RUN] test_fork_global_ksm_zero_pages_count
ok 11 Global ksm zero page count is correct after fork

Changes:

v1 -> v2 :
 - Rebased to mm-new branch
 - Fixed incorrect global ksm_zero_pages counter issue during fork and
 added a selftest to verify it.

v1: https://lore.kernel.org/all/2e662107e01417bf9af23bc7f52863cd538419be.1756211338.git.donettom@linux.ibm.com/


Donet Tom (3):
  mm/ksm: Fix incorrect KSM counter handling in mm_struct during fork
  selftests/mm: Added fork inheritance test for ksm_merging_pages
    counter
  selftests/mm: Added fork test to verify global ksm_zero_pages counter
    behavior

 include/linux/ksm.h                           |   8 +-
 .../selftests/mm/ksm_functional_tests.c       | 114 +++++++++++++++++-
 2 files changed, 120 insertions(+), 2 deletions(-)

-- 
2.51.0


