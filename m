Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48184CCA470
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 11:57:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 775C88E0003; Tue, 30 Sep 2025 07:57:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74D9F8E0002; Tue, 30 Sep 2025 07:57:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63C048E0003; Tue, 30 Sep 2025 07:57:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A51C8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 07:57:05 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E6723879FA
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 11:57:04 +0000 (UTC)
X-FDA: 83945765568.16.160314C
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf22.hostedemail.com (Postfix) with ESMTP id 89AAEC000B
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 11:57:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=qb3jH0OU;
	spf=pass (imf22.hostedemail.com: domain of aleksei.nikiforov@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aleksei.nikiforov@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759233422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uLYdFPrLnyCJeuiXqE24UjB9h+DlRVVlfV6Wh3glndE=;
	b=TNTpdDH/p2vOgiueZ330uATNE0sac20ftE43gNGfeS32e//Sm2DYGsYyr5s+7dlY/z2p0p
	k1cPPvTtI3S1WvHsw8i4Q0lNgYaeO3TU/+4+38g0p4SbaGYX7LhT6i1tUfuB0qzgUnpg/i
	RQbCI+i2CIahB1soktwoLSJsBlMdnyQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759233422; a=rsa-sha256;
	cv=none;
	b=fngh/qss1f6+NQJPTTqAil39247vWuC8LgH8o6P0KFH+dXFXPcZCkH8r2mKr7ko1CYhB81
	5OOTuM9cW13lN6+5UQSAq11z1Imls7RzDJMPKbTVyJpTSetbjptQ42rs6Wk6WKz7JicUI/
	jXUmO1PE9/H0125PsyiN4XhS+ADy/oE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=qb3jH0OU;
	spf=pass (imf22.hostedemail.com: domain of aleksei.nikiforov@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aleksei.nikiforov@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58U6FWuC023184;
	Tue, 30 Sep 2025 11:56:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=uLYdFPrLnyCJeuiXqE24UjB9h+DlRVVlfV6Wh3gln
	dE=; b=qb3jH0OUJthQPcD8UO1wym+j4CX6QJ63WUHSi15+9SMnlo5QwEUFrkqGH
	d4dTzFEIPEx4+6gid3cfPiuBewotnep4cHco0eDNBCdnO3aCfKBpaOH1K72kTabV
	mXUagZyAphm5z5NSfyausoImH4MEaL6e14xw9MICbpDUBClVV789bkhhaFwjkb0I
	t/yYV7s3BjX7dvGzOR8zpCGhd2D0FMr3l64IYprXxiOsOOKgsXOnVIExND00o7N0
	6bYEs2E1jZyWInu0iOd/QU3lM6jZ9TkKIg/PZ2koW4zBoejHPZLglGz6vctiwNTx
	XGpYi95maSdsSaaMvOQ7IqIZuMcGQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e7ku8npe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Sep 2025 11:56:58 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58UBspmK026015;
	Tue, 30 Sep 2025 11:56:57 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e7ku8npc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Sep 2025 11:56:57 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58UA5hWh024110;
	Tue, 30 Sep 2025 11:56:56 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 49evy12vjb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Sep 2025 11:56:56 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58UBur5x44237072
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Sep 2025 11:56:53 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1D7C320043;
	Tue, 30 Sep 2025 11:56:53 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DFA8120040;
	Tue, 30 Sep 2025 11:56:52 +0000 (GMT)
Received: from li-26e6d1cc-3485-11b2-a85c-83dbc1845c5e.boeblingen.de.ibm.com (unknown [9.155.211.236])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 30 Sep 2025 11:56:52 +0000 (GMT)
From: Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
To: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, kasan-dev@googlegroups.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
Subject: [PATCH] mm/kmsan: Fix kmsan kmalloc hook when no stack depots are allocated yet
Date: Tue, 30 Sep 2025 13:56:01 +0200
Message-ID: <20250930115600.709776-2-aleksei.nikiforov@linux.ibm.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=T7WBjvKQ c=1 sm=1 tr=0 ts=68dbc58a cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=8O52IJZf9AqgYq1AvSwA:9
X-Proofpoint-GUID: 2MlcIaOIPNuSYhLYF18xUsDti4D8uZw8
X-Proofpoint-ORIG-GUID: r2AQStiL2pyVn3dzbFpUjF4YW448Tcuo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI3MDAyNSBTYWx0ZWRfX7QSBso6vH+ZV
 XAfmtLz8OQ/2I8tdOrQn3yK5c99+12X9I71rcuJjgvhqo8+S0YHJHGkZz88TqHi0usYR85tP03Z
 VNFnCQ41hhvy/yviYH7OYZXZWJ/fmmItE7cqYYlPNsg/IbX+d+7SS1/KiMvRZWqIphB3bUIE/jk
 eEzO8gBeZMcC7jBb6zXvRv3s50do6/UnrmHUc2jI8bexjGnPw7f0je5hhgdpvg1Nt2w9vMhjOab
 2JVBhlpCHz0RlNkDxICdJFjghcUusdwmi9zD/I+6FHC99ZqZJmp5j2+nehc7TrqxPxWQuBytgTd
 wVCDqYmtmY1ag/L7jIUmnoALaIGtpWcD7pAdeujJh/8Gtd+1F5E2VBvDDQ3Eb+k3rHxf/r3FZgK
 Kram9+fp0Jq8UcFfSZuMteDhJb6LGw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-30_02,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1011 spamscore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509270025
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 89AAEC000B
X-Stat-Signature: ks69b5fq5w7g688jqpoenjdiff4i8wfb
X-Rspam-User: 
X-HE-Tag: 1759233422-117460
X-HE-Meta: U2FsdGVkX18JgiHKZ84BX8nIL3KP7Msr65JcLlcERBCY90Fa7Iv/xuC12ysse4aGu03nxW9a8hRTl0DdKs5mI1DROZp6lK/T/EvTsA7ZDJXkpNDjw6kBTpPS9OzhruEQEXNzAOGs6ivu9vWcuVDdQ7lQKlRAPqytsuM6Odk6LG5Mjagj+hOFJNbe18ux/AlXKnrlXltn4nKXvTJBRGthxlnqN9pwESlABNFJcgn/YfRY9wMXdOetk+OB/mxTCNkuyIQBSdVfqQeqly7bO0spG93/sUIGA7Azmulfom5Fr9z7kcp6ViqHwiTkR9oiAqkZ5pq7Zjx4vCiFQguhmbcHnXUVjHUa1BGR9UIz/S11OqUjCy1oa3nfB50/I5tpUaXRG9VIqqPvL/bi2lDM/SGt2XUQ2bu4WyPmXap0oODCBvZ93uhcHYZmHUOCVvatPQW9uf5RPHh8ilqWa0HYmQeWARyUWBoJjtOeclS1i+4oPsIbd+U439J0ngnWnHsbCUSzdnNeHzknmZwJvaFUpmKCqGlKrZU+qbeZ5/9e7u+uXjBs8CH9zj6eWibVJRefoU1WbsjVxU/kKOvWuTsZ4zLUG9UjRedkx7ta27mQSPjj8xeadKUrBWbmYoA+ogK2ss6NCOH351YwWEAKTNH72OBTJnXn2l1dOcqC03iCucIY0fRDr2dQglYfJTFOV1FqHie53OFuWJTdHSU9gLaDGHdxKjCVq15neO3qntJC8TYi8yEWg74Jk8pa8ZWOiDO21RSO38DWUsecZA5gYVkM0JO1lxri5OQfS96c2UIor0XXfu4FZEAI4D8OdaL8Q2yaMtS7ZZdcjvAkRs2xm5DfSm+DDHQ5+wm8Ua5ZGlTvs4tK4t5eLTTGt5CJu+ThKYk9dskLSQrNjVWqDJDX+l3STt466DeQReCsvNqTJ7pjIXfX+X3O000mBayV+G9o9jXqiUv4m9Y63o0yHwY0oYrlAHW
 kGlO1Vb7
 q7dn+GQGKFK4jbnc7qh1VCnZuWq8uOPULZymnGOdB7JjtQB83WJCwfD7CM5bMq3uv9g7dd0D3Q3suDf6e7Leima+QLc+SA+THu/S/QTfk+CztI8v3KW8jBiJZDOAcQRa94+vrOPWM4DrrowawbMhAscRFbqSCXYcDepFylVcFtkgocjxB7iFFZKQAy7/Afq/cUsrqEAS/iL3Ed4ySyPOnrH/8dkXUutG7Efq3LyL7iXe6nua7nPYPy16xarVQF3VyJwq4ZyCRbvxFG/8ub11Auo01koDa2JqwzOn4ID2ILDRjXHw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If no stack depot is allocated yet,
due to masking out __GFP_RECLAIM flags
kmsan called from kmalloc cannot allocate stack depot.
kmsan fails to record origin and report issues.

Reusing flags from kmalloc without modifying them should be safe for kmsan.
For example, such chain of calls is possible:
test_uninit_kmalloc -> kmalloc -> __kmalloc_cache_noprof ->
slab_alloc_node -> slab_post_alloc_hook ->
kmsan_slab_alloc -> kmsan_internal_poison_memory.

Only when it is called in a context without flags present
should __GFP_RECLAIM flags be masked.

With this change all kmsan tests start working reliably.

Signed-off-by: Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
---
 mm/kmsan/core.c   | 3 ---
 mm/kmsan/hooks.c  | 6 ++++--
 mm/kmsan/shadow.c | 2 +-
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/kmsan/core.c b/mm/kmsan/core.c
index 1ea711786c52..4d3042c1269c 100644
--- a/mm/kmsan/core.c
+++ b/mm/kmsan/core.c
@@ -72,9 +72,6 @@ depot_stack_handle_t kmsan_save_stack_with_flags(gfp_t flags,
 
 	nr_entries = stack_trace_save(entries, KMSAN_STACK_DEPTH, 0);
 
-	/* Don't sleep. */
-	flags &= ~(__GFP_DIRECT_RECLAIM | __GFP_KSWAPD_RECLAIM);
-
 	handle = stack_depot_save(entries, nr_entries, flags);
 	return stack_depot_set_extra_bits(handle, extra);
 }
diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
index 97de3d6194f0..92ebc0f557d0 100644
--- a/mm/kmsan/hooks.c
+++ b/mm/kmsan/hooks.c
@@ -84,7 +84,8 @@ void kmsan_slab_free(struct kmem_cache *s, void *object)
 	if (s->ctor)
 		return;
 	kmsan_enter_runtime();
-	kmsan_internal_poison_memory(object, s->object_size, GFP_KERNEL,
+	kmsan_internal_poison_memory(object, s->object_size,
+				     GFP_KERNEL & ~(__GFP_RECLAIM),
 				     KMSAN_POISON_CHECK | KMSAN_POISON_FREE);
 	kmsan_leave_runtime();
 }
@@ -114,7 +115,8 @@ void kmsan_kfree_large(const void *ptr)
 	kmsan_enter_runtime();
 	page = virt_to_head_page((void *)ptr);
 	KMSAN_WARN_ON(ptr != page_address(page));
-	kmsan_internal_poison_memory((void *)ptr, page_size(page), GFP_KERNEL,
+	kmsan_internal_poison_memory((void *)ptr, page_size(page),
+				     GFP_KERNEL & ~(__GFP_RECLAIM),
 				     KMSAN_POISON_CHECK | KMSAN_POISON_FREE);
 	kmsan_leave_runtime();
 }
diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
index 54f3c3c962f0..55fdea199aaf 100644
--- a/mm/kmsan/shadow.c
+++ b/mm/kmsan/shadow.c
@@ -208,7 +208,7 @@ void kmsan_free_page(struct page *page, unsigned int order)
 		return;
 	kmsan_enter_runtime();
 	kmsan_internal_poison_memory(page_address(page), page_size(page),
-				     GFP_KERNEL,
+				     GFP_KERNEL & ~(__GFP_RECLAIM),
 				     KMSAN_POISON_CHECK | KMSAN_POISON_FREE);
 	kmsan_leave_runtime();
 }
-- 
2.43.7


