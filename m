Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21DEFCD342F
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 08:26:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C2716B009D; Mon,  4 May 2026 04:26:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 872D86B009E; Mon,  4 May 2026 04:26:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 762316B009F; Mon,  4 May 2026 04:26:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 668E56B009D
	for <linux-mm@kvack.org>; Mon,  4 May 2026 04:26:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3C9791C1092
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:26:02 +0000 (UTC)
X-FDA: 84729054564.07.6AF5FE9
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf05.hostedemail.com (Postfix) with ESMTP id D97DA10000D
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:25:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=NaNigRdb;
	spf=pass (imf05.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777883160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=91SGkots8hY8yhefJjvScb8bSKAk7Ka9vIM3IAFA2DQ=;
	b=HpdVku4B1wcJaeR8tIsXq5582ELJyYMPW7emnyXu8/1IM82zvJhFQTfQWsKLmVB6ln4TgZ
	Joep2TN0h7mTBBN3b1r62KeyEvC0Q9DXw6eqN7UeFXytcrWBLlSjmFOUZBAzlqiegXV8TE
	ct9e8+W4QXHm4m0hKOQfeSN4hTN20/M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777883160; a=rsa-sha256;
	cv=none;
	b=AHtp5o2xpBl06FQL6A6BqDyVOVHvdvtGUKdxYlR9x6fOlIqjuJpyb9Gp506JEmlcEaZc3N
	dKuZow1AssWuQ09aY2JxP7Lc6TJCZJ8ZbnbfIs0b7kVJhgWV85xL9dNgwpF+jb4oWsZLc6
	Au6erQmqWbee33OpwZSpD0O9KjBzEoo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=NaNigRdb;
	spf=pass (imf05.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 643Kqx2n2830434;
	Mon, 4 May 2026 08:25:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=91SGkots8hY8yhefJ
	jvScb8bSKAk7Ka9vIM3IAFA2DQ=; b=NaNigRdbzPyxnig9vAaGITXTPasczpm5i
	K6E4cAWcX9Lze3l2OOe6dSQNAWBTDqDbzI2pIUiOcHIgY7rwXLC5BtolpEVRxQX8
	L5EPOLmkw0Gn11wTpC5k5Em00EYpGnXHdn42uGNA4w/cwvNbN9f0XqxDY54CFf07
	TY0NwJPepDhGFQSG9RCHfB6AJUcCrzHysVTg42Y48on/Iql05mbsMt/jft495Fq9
	oErbdqf8fQRoEpmsizl1gamarlpJ8BdnPDQACqMigeT+r+bP3QyC9Z5DpRFppvYZ
	SmeCeX+Aqj4BRu3VV0w67TVkVVHZF6mr6hl0Kwozoa3dU4syp6/PQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9v7658a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 08:25:52 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6448OOe1023522;
	Mon, 4 May 2026 08:25:50 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dwuyvveam-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 08:25:50 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6448PlJ650856396
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 May 2026 08:25:47 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EA03E20040;
	Mon,  4 May 2026 08:25:46 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E06CD20043;
	Mon,  4 May 2026 08:25:43 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  4 May 2026 08:25:43 +0000 (GMT)
From: Sayali Patil <sayalip@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org, Miaohe Lin <linmiaohe@huawei.com>,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
        Sayali Patil <sayalip@linux.ibm.com>
Subject: [PATCH v6 12/14] selftests/mm: skip uffd-stress test when nr_pages_per_cpu is zero
Date: Mon,  4 May 2026 13:54:49 +0530
Message-ID: <2b94f0a5ed129ee1249ec522d94237d04c4f19ea.1777877814.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1777877814.git.sayalip@linux.ibm.com>
References: <cover.1777877814.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA0MDA4NyBTYWx0ZWRfX2dTsRxbftKKn
 pcF81gkaMhizAh/gzixV3wY/h0JEdQN3gGOSyIL7JjFnDsVHmMOmicl4FqBaOxE4Zs3JGveL7Dx
 c8ay9TvFj4362UNfXlIQFWYwNXefFs/tm5DAlcXXEnc6Gnh885XcUFvB8UmYRgNF7Zf6AoFveh7
 HinYUHVpgv4TvoyBqmKB0Cuhaw5OGGd5HXV0UAQeTLl4SthUZs5GgL+QHajn6uoDH+lwStp9HUz
 iLJ208A1JvOEQzruVG0OivUKWALbDX/+IPMSUNHGxgsKvkkkFd7FM1mGM1fBbBt4vpligpuCeqX
 YOUq0wcip3DJ74K+cAR/pJeXpwDlQgrIGkyZK6dBEllKTx9SAL4v/klaSzTgeAIaFliLcRyXr86
 H4O0IQbp+I2luidBNVpfED0yiD7uuisRKpGb4ADW8h1FPnGYoH+Y27T/sXq84v0wuv6SVaTmqwM
 FMkb7w2dFyeP9XlJd7A==
X-Proofpoint-GUID: j2aMVpGllcJhKq0dtmb-oSYhNVspY2WH
X-Proofpoint-ORIG-GUID: 1qdmlwcj_bL-UkijK7ccG3ksuNYRgUuT
X-Authority-Analysis: v=2.4 cv=eu/vCIpX c=1 sm=1 tr=0 ts=69f85810 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=QLFraA1qSxkZgXf6QZAA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-04_03,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605040087
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D97DA10000D
X-Stat-Signature: 5gitowupktx4ehy876i7edfankt14nn8
X-Rspam-User: 
X-HE-Tag: 1777883159-422071
X-HE-Meta: U2FsdGVkX1/egtXJ8xFMyZnZR2ED0KoENcAnUTuF/e/CVAnwBZYKuaVSjTiRuR1vELvcAdpHgjGKPKTUpYiYVD/Q0prr3FZE+sPOR1fvV20nxgI855N/tiy7/Vyuybd/zPmNI6BjS3YuCzowNZfJL3PtV1wZtkqCF5pdVL/5zapM6es92vqxNxtNQPoM2qrivWitX/Gd0pE/ajn4Fwao0LFvWOa/gykcQpWw8Q1K90OazkFNsbPPaDAO8a90x3YFDqXRGn9f5rH6YAnnb97RFcf5OCmkCnGMBpt+G79pY1nTMCKra2vP6sI4+6KeBMu/wvSL12ni6F0m83H2j21vO7hEHT4BHQJ6Zw4Q36ZeWO0El3yNIg+BbovzZlk5OwAgXxt2agMG63JfTdWH34Q63BjACnf2lMbEz6B7ydOOIhu9PkzsQbX5jjFWaQJ0FN+wKNzflgjLKAQ4ghDn5yId9k/1vHZdOpX9WBhrBzyY9l63SFXbHeoP6EUHUcIzffsMh+ePIdB2prozQ2mEsgE8ZtJQkAaOWIRGCri2NgLtnMvNFnCYRXauw2Xz1rQOq3Gt82/ApGON1+kWyg9VR44bw8tZJuL/a+fl9uaF4Sh0Fi/IcCtroODoYW6FU0hX+UUjy+82JLduPQdlZ5kbNH9993ZG+EshXU/Na7lb2pAjJp6xpwJgfrxEMHBS8HaPLOAUu7HI6mCxXDWJmBhNQ/heIgu7GL/iHj8f83yj4yyGxpqR32NU7pGq1/nMsL5eCIYMo6LD8Ti6gtJOrZHtfc4RfnSG7z9Ow3nGZHlWRGmPSr4FNYUlvugyXpaBKvTQEcW+a3XiQMqeDAGj2CFISLwhpr+fSNA9JkiGh0gPr35mMulYmSLvbBPKGnIRwDe9hWvJ4xKyYWUMTZSvWI9UsNCkFdQjeq8pVhYQ1j+Ry7CMCI20M1tgoX3871WbEuUVWUhqCJWUtRQvFlsc8mlyQV6
 9da1l5/D
 iqDnL0r0rDyMPQJ5p/eGSyANmUVzt645CaminqbtNp4u6XkLP15UMgA47WfoBa+5SB/3K/+BHjxPj8osbfq1DGbyLtZYG453jHszj2qVfgNlUMJ7OaU6WOh5fg7LEzOIDs3UmcQ8llOd08IogGBXQquIwg52qA70ZkLQd1rXfrI+cScGzdZT6KnWe/81PagHncfEhwYYmcUC5NnC4oJ40RjdndTkBvEyYqN3k9kBzcQcrC7PxSdxewdPbZpiM4U5Edze75o/H2ssMYI+kieuauLo+Fqx4ZuxVb0V1LYGcomh8bsIy8pSAoN0CSYUVD9FV6MSLuB9LtOGcexyj3oZMkrMupwASp/D+XQKb1vKBnUiN1Ew=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

uffd-stress currently fails when the computed nr_pages_per_cpu
evaluates to zero:

nr_pages_per_cpu = bytes / page_size / nr_parallel

This can occur on systems with large hugepage sizes (e.g. 1GB) and a
high number of CPUs, where the total allocated memory is sufficient
overall but not enough to provide at least one page per cpu.

In such cases, the failure is due to insufficient test resources
rather than incorrect kernel behaviour. Update the test
to treat this condition as a test skip instead of reporting an error.

Fixes: db0f1c138f18 ("selftests/mm: print some details when uffd-stress gets bad params")
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/uffd-stress.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-stress.c b/tools/testing/selftests/mm/uffd-stress.c
index 700fbaa18d44..b8f22ea859a6 100644
--- a/tools/testing/selftests/mm/uffd-stress.c
+++ b/tools/testing/selftests/mm/uffd-stress.c
@@ -491,9 +491,9 @@ int main(int argc, char **argv)
 
 	gopts->nr_pages_per_cpu = bytes / gopts->page_size / gopts->nr_parallel;
 	if (!gopts->nr_pages_per_cpu) {
-		_err("pages_per_cpu = 0, cannot test (%lu / %lu / %lu)",
-			bytes, gopts->page_size, gopts->nr_parallel);
-		usage();
+		ksft_print_msg("pages_per_cpu = 0, cannot test (%lu / %lu / %lu)\n",
+			       bytes, gopts->page_size, gopts->nr_parallel);
+		return KSFT_SKIP;
 	}
 
 	bounces = atoi(argv[3]);
-- 
2.52.0


