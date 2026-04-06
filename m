Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D6E9EF4EC2
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 09:20:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C94596B0095; Mon,  6 Apr 2026 05:20:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6B346B0096; Mon,  6 Apr 2026 05:20:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B81516B0098; Mon,  6 Apr 2026 05:20:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A3D916B0095
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 05:20:45 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 745D7C18AE
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:20:45 +0000 (UTC)
X-FDA: 84627586050.09.08F03C7
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf24.hostedemail.com (Postfix) with ESMTP id 403F9180002
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:20:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=aqapI5eK;
	spf=pass (imf24.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775467243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=91SGkots8hY8yhefJjvScb8bSKAk7Ka9vIM3IAFA2DQ=;
	b=Sb6ErxzngYTc/yShtJoaCuN9+8xGlQwdnSVdhmFAwdY+kROO14Kgmcy5Ps4SEguquCf/5V
	LVoI31K0PWuG5YiX/2TIpnEzLf9Dq75NTf1Kg6EiBXRunJCwoLwM6AJAYOwUmoN8LyRihs
	ctcqjUUwFnvlKJxcpTrvc0Z4IsLlPjA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775467243; a=rsa-sha256;
	cv=none;
	b=K6daBaqZq/jHI8n0biZ1FdzxCeLP1pX52B/vKcRpFZY0kmYJC1A7Mg0BAPAkFb8r5GY06Y
	0tAjdyeP8c4L1FsbTSxPtYOEkDQ8lehskuody0l5bapfmRJsKhl0qhZapAQUzAwRuMMTkn
	24xwfvvfbS8XupOW0JZDAxO9iriVXAs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=aqapI5eK;
	spf=pass (imf24.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6359UZdO2282153;
	Mon, 6 Apr 2026 09:20:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=91SGkots8hY8yhefJ
	jvScb8bSKAk7Ka9vIM3IAFA2DQ=; b=aqapI5eK9ROn/lrlrGy6Ncg7Mg6S/2CFZ
	i4fGft00WkxkfmJ8QdF4K20sWQpT17ft2qwrfGXPFZ4SnVtpLkQ4+6RXQdjBmLR1
	jb6BgiHs/ySFf6vWR2GXxpG6K6pGn2MsLqEpL+6yFhfd04GGlkhYFA/ALM/W/0Wc
	SIKhW2E+UF49DASVUs8ijTqEEgpN+U58T4QGP7NKUI6hAt2U6Syl+wvld+/pxaeY
	DtlpbdobGsq7x9S/NqpGVvVMeFWmu7BowgsSIp8kHPy+7M6wWUoq/y4qC7v5ICw2
	jyVOa2N54NafKnQRVEfmuM1pPDFVxlnnrx0pi1gQrbhPOBwpTABHg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4datc2nwjv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Apr 2026 09:20:32 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63650WHb021114;
	Mon, 6 Apr 2026 09:20:31 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dbdbyc5hj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Apr 2026 09:20:31 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6369KRgv52101384
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Apr 2026 09:20:27 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 56CD220043;
	Mon,  6 Apr 2026 09:20:27 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EDC9020040;
	Mon,  6 Apr 2026 09:20:23 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Apr 2026 09:20:23 +0000 (GMT)
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
Subject: [PATCH v4 12/15] selftests/mm: skip uffd-stress test when nr_pages_per_cpu is zero
Date: Mon,  6 Apr 2026 14:49:31 +0530
Message-ID: <395d3477a67919780887afcfd15e49bfe3816060.1775466330.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1775466329.git.sayalip@linux.ibm.com>
References: <cover.1775466329.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA2MDA5MCBTYWx0ZWRfX1uBR/g/Ju67E
 KM0qtT5TEPdXeNwYFpkT6Wqs5AY8EwQwOY9OpiXXXQNpeGF/78qV2gKuQXDEhIvOsA++V7f0Elm
 m2Xdl6q3MzBYZji+Za7P1hRLntfGCim1bl5B5QgCEDwb5RA+YyeFe+siRWcxWxA9qJZiuE4IFhm
 3at75vbjdXAhNldgBUTfxeqwmDD2sIOeea2k8cMApF6A9nZPq0yHC4kLeW66kn4KsSCVZqqm+wr
 9r0GD9uTgDxxNndchFbBr0tbMg3U/9qn8qlXFIO9XKnudD8rInBQUTSXtvKZK5rlugVjEjDuxNr
 EKzkrpYJJodtCmyQC2VbUE09Ew/487O6oAbtylkUEClL1J4ZrJA0URViHO57W+AAHLfg+lXIWpK
 jeky3JqOcN73UZjKisp8y/tbxcWn1UgUsq7T/XTg4qX+13cpBaw3HPyP/Pe+Q/nChQY9/66CU35
 utlxDhnEaQsWNAbHcrg==
X-Proofpoint-GUID: BeuKlNyW_UFkVd0o30p-tyNjXBC1eCgw
X-Proofpoint-ORIG-GUID: YOuuTzIDeHU92HsbRTKRRMr_bKZc-JuX
X-Authority-Analysis: v=2.4 cv=HJvO14tv c=1 sm=1 tr=0 ts=69d37ae1 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=QLFraA1qSxkZgXf6QZAA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-06_02,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 phishscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604060090
X-Rspamd-Server: rspam12
X-Stat-Signature: erbk6b9f75fnc1xfs3fjgukumzeoqown
X-Rspamd-Queue-Id: 403F9180002
X-Rspam-User: 
X-HE-Tag: 1775467243-923533
X-HE-Meta: U2FsdGVkX1+96B/1e0pLIfHUW9hbNH03XkmmLnOahbmjyJgdFMvj7UKGr8KJDGBu1QctcqEJOv5s2z5UsVEKlHTuPQMxy4JuKhcZpYH0No+6a7tsxk/DNLvx3vDE14ItKVGgH+P4xjhkBD2xK78fbAyCbO6FM/sWdnh6wtlbr9czs0nJs/luQdXMQAhovBJigG3vmRTT4JIgCx/5UyvhQo51qW4kjGLxcSgbQDAnIUOg/mKcI6byNGQo80jnjgRGFbkAo0YMTakloXVMhAUZznhJGHEo1xIpjvg3gESjnRViYawQJYaka7ZLkpNiq+NpBmUEXsC8xHW0cyQjw2FJktfhS/9qy6xVLQECRvD5fGV2wkorVvkX2spbsyjDCQ43L0Qnr9ref0GVghSLZ3KNXoxIUfamJb9pZLUv/iz06SW0wB41PsOxSbhB41hQJ7ulcWC7t0U1ejb9oVUIpvreiWyS9Ib8Xi1DBLy+syDOzTk522aZcmR0xogipZoRU801bJA0kVBNVaS1s8UuGpCKp20M37mU3DEau6tlyzRBaVewyckeIV9rxou1Sz7XZg2MkMUYpCNK3iNVM6EArkjNTcoih0Mq/ao+WL4AKxXiUSxFmQbMycxTng1EoVaEWJF+kV3z1Q87Z1Y3khFu0UaoPBFPHBw9OJmBQkd/GZIgsEvkgmIclAts1RQvIH05ZZ51Sos1t0RrGiHUa2spuAzhL9MEwGlPZ/pLCK8t2NgtPPtFECl25SjB/Y0Iar6mQbaZtp8lixrvD62EpRJ/LpUHYXxv5a9sxc3fB+Ro2YJCTfd1gNgpioxAYyXdlmhvXPG+iFmZRoAvWsGW6NdDh4/1fpgu6u8+wTCZ4nheWvzpoy+i9jaMTpVoEjjBlmv5oD5rJLzL17gSjuIqVdOY3gbWjcoQletYV7S4oavx5k+nac3JEW1vqbrSAt2pqiL7gfHUIHAR5NqNuUb32lntCCs
 6Lpknewb
 S//B3pRryeCgtqcI=
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


