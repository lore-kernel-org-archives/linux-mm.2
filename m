Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4C95C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 05:34:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 680EF6B009C; Tue, 29 Jul 2025 01:34:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60AC46B009D; Tue, 29 Jul 2025 01:34:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F9736B009E; Tue, 29 Jul 2025 01:34:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3763A6B009C
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 01:34:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D52F3133D60
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 05:34:54 +0000 (UTC)
X-FDA: 83716188108.15.9BFDDCB
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf08.hostedemail.com (Postfix) with ESMTP id 70F4816000B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 05:34:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=WxMPC0bO;
	spf=pass (imf08.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753767292; a=rsa-sha256;
	cv=none;
	b=nc65u2Yl+O92mRy5l3NgmSUv67XyakaDoCtEoI7SEFDwbEodO/1edmv58X80ugLpUx/YMc
	lFaynRH7Y9/hBGXEfKbV26qs+OfUpc+hl5j/8m8doJG03D4qYeFN0Ah87qs2D2/f/0pZ7k
	QHoho3+jG01GXMuhzbP1OXkliPBkkVI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=WxMPC0bO;
	spf=pass (imf08.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753767292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3yFkLfqgrcBFNMFUB9G/stlH32cp6n7wPoj7eA1zvgo=;
	b=mCIsJq7S3pvUclEhf+cPZvuDqIcM90m9dZMyaQNyPqY7jPE9AR/jnLZhK2SPztnvWQV5Jf
	aTW4DjrFrAVqntW4UgXc0UunnCcghojbGbvU/QMVPDBceM1jDmoh5s2Rri1cE3Z2Npn9qI
	2NhT91/+pzKJtrG2jOZwyyhdr4rmt5Q=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56T4Yu14015119;
	Tue, 29 Jul 2025 05:34:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=3yFkLfqgrcBFNMFUB
	9G/stlH32cp6n7wPoj7eA1zvgo=; b=WxMPC0bOTHVD3BTqHC9hrOtortH0sdi6y
	Ir8QLqRUCQVtNsqOwRgBZ/DQ9JfmnBiXwbccmRd6lhTvmmU/D87+JfdpJntxIfpA
	Nyv77S4+NQnY4Dt1ZqlpJkMZVqnBid1JmsaGB1rSKRbm2V73MB3qZ4fL/ZLLdYBN
	Ckid5yA6FBohkuHpGtv5PblvLwO/m9Ux3pDNniuAapc311UlUzCjX+fonCH7TKYx
	XPraZI/wung4KYXMrsHZwXLpO35nLUGN/sjE/EmQOGPKUgppd4KhoJ3cG5hXtq2K
	3JO5v3deTyaET5yfpvNzKjTq1Q+eX1IVad6ATC004WoowGhW173Kw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 484qfqmqc3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 29 Jul 2025 05:34:46 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 56T5PRxq014173;
	Tue, 29 Jul 2025 05:34:46 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 484qfqmqc1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 29 Jul 2025 05:34:46 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56T4CDsG018312;
	Tue, 29 Jul 2025 05:34:44 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 485abp1161-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 29 Jul 2025 05:34:44 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56T5Yf0549086910
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 05:34:41 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DEE1220043;
	Tue, 29 Jul 2025 05:34:40 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8F29D20040;
	Tue, 29 Jul 2025 05:34:35 +0000 (GMT)
Received: from aboo.ibm.com.com (unknown [9.150.11.63])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 29 Jul 2025 05:34:35 +0000 (GMT)
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: akpm@linux-foundation.org, Liam.Howlett@oracle.com,
        lorenzo.stoakes@oracle.com, shuah@kernel.org, pfalcato@suse.de,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, donettom@linux.ibm.com,
        ritesh.list@gmail.com, aboorvad@linux.ibm.com
Subject: [PATCH v3 5/7] selftests/mm: Fix child process exit codes in ksm_functional_tests
Date: Tue, 29 Jul 2025 11:04:01 +0530
Message-ID: <20250729053403.1071807-6-aboorvad@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250729053403.1071807-1-aboorvad@linux.ibm.com>
References: <20250729053403.1071807-1-aboorvad@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI5MDAzOCBTYWx0ZWRfXwtHsrPX0ZlnV
 vRDMd7q+XRCHF7r6JFqYgtZO9I20t5GiZColslgjn4/kXFPkBF7LA6cupJBTxlEQ/4aV5ASvCmD
 0o55URyGD+mm/TOUIj9qhb3KO7wBBoKS51W7Ujl8i1/s1a4CXV3TiDgpi4kNFQrMNLBElP/iYCA
 +BJqDoBU3Q2JECIRFXeAaAv93zAfehQz5iDowMdY29ybffV8myd2h8QGa6rezG3ttM2k9ekVdu+
 tIIHXO0p9aA/KjBs7nea/dxUIPXVsirFMNOP7vd7BiuJ81RrjGmL11ZWno32OnLBrclhcCufWG0
 OgpJrUstaLkjAq8hgdQ9oQT3BwrU18mioL6sB9v43u+roROEeTRTEDG4Z085PhE5Pg42Yzz50eY
 u0TwuTI7aTWMlrnzcPNAsjMoeiRAhv6jBKLYHjm/0jOHbOKNqYusVVB9UbZ/EciNLjF0/kuM
X-Authority-Analysis: v=2.4 cv=Je28rVKV c=1 sm=1 tr=0 ts=68885d76 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=Wb1JkmetP80A:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=1sOJkUf8yoZECTHbNm8A:9
X-Proofpoint-GUID: XAjm13B9EvkL-PDJgVkodk-s46CQDaIv
X-Proofpoint-ORIG-GUID: jLhF2rdmaYKlif9AHFjNC0WJm1TiEGk-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-29_01,2025-07-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 spamscore=0 adultscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 priorityscore=1501 phishscore=0
 mlxscore=0 impostorscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507290038
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 70F4816000B
X-Stat-Signature: 7t93ssxqs455cjeark46or5zqwisbnq5
X-HE-Tag: 1753767292-782488
X-HE-Meta: U2FsdGVkX1+J3HvABYR6cjCd8jTqRbNYJH6MzOFqlscXL4UwdaT/akeGDlUQx51U0HumB2giU2upOz0cEW7qGiYHU3LZZ9XXo9JuFvc3h5gmZyjE6mYMLBrGT0Hn/ejV+Ub7an386n+W8eMZjJJ+kFUzoGwrR9VoRnmn53aSghIBgb+DyyONI/X/1YZ7uoA46Eknf3gGTxhY/HfwenxErL77A23/ZG9AEFw9CcysS79XIZENMcemRws6T8pW8aVRhbeHU99/TAWonOEVlZSdCR76P8PuSOl/QxRCYM82WAtGMWlWZyfQXvyU6TR3rZYvhHH7I629ifvzowoxKtB90UuyZEmCJVJlog6Wq0jqAl76XGUqOkpB+T2tNBtHO+AjReZTPBh1a+wqNXlbJWqoxT7Hk9OtoUCT+w955b6MIZUfkabVxlT32KvD/tCKT/4TXaI81qkfVLGVAhN3+ikvoOW9a9nEADmYykCHcfDF4NicgtnuAhrVLc6bxerGGYFVGPDL7E+q141FngnF9QlB3yMqyiTWfJ3SMlkHqpO3gUm0j88Gg8Z5jt5lcizx4oqwki17w20z8Uv/w7igyAraOF+1qWeHKgj/zzLJd0qXQa0JbfvWtfaeKKIBqhPOclLP2ZHPXr3RPjMtFy1Pu2sX3PjCwJrlQzXwUkKxSjWn/LvLXgVA7oQYDIqodcYFKIMhb8Gk0l1q8/B+qHNkFm7Tou2zL8vLui+PCgoCsLJhc8D5q0QIviHLcNS5iQcCbVMNFKkBChUFa9BRSHWc0lsDzy/gpWM7et7HNWlYK6DAiz0dNY1pXbkxgYQW26L1Fgpf7MnGDAhc7c2TJsYqjxjhDWUS8Utw4Wb51A9GQziSbsLQtLDKk/ReJf1k1XCs/aP1uwi9xbHI6tEfHR4pjEA84vStwuk+LZbkGUWXbuPmJTkt/JQ6iKwlwtZf2EmrVkCJIr67FOL3dT46MK5RmJp
 JKD8FMrE
 ST8AmH8clIX+U7QMaGemO8N1KLfk7PYtjBh9cHE7dmimeBGeJNXsRE3oWreWjr7pG6u8GvgfbYrb2qRG2PQFRtqpmCZwc1y7W3XiPeDpoyqOnrImbQgavBwMYh3DzIME5+Ux1jF0v7k8WhZraO3CohAVgEr6nf2obr5WggsJFOCHpTbWO7EYGFi/+xpgdeFOcDH1qMvO4rqZrFQkxZZV726nPc1XKBsMXtDoN+dKnZI6f/+TCqq/y17+eQaEOAQEaOXxbmAesmqIGXRHOVGuv1prAQjHxQ8xRm2sOSgzDewUBgpyBW6jYbeN8FGERaob6JkAdbLf7LbgV1pkUxgp95wYIMg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In ksm_functional_tests, test_child_ksm() returned negative values
to indicate errors. However, when passed to exit(), these were
interpreted as large unsigned values (e.g, -2 became 254), leading to
incorrect handling in the parent process. As a result, some tests
appeared to be skipped or silently failed.

This patch changes test_child_ksm() to return positive error codes
(1, 2, 3) and updates test_child_ksm_err() to interpret them correctly.
Additionally, test_prctl_fork_exec() now uses exit(4) after a failed
execv() to clearly signal exec failures. This ensures the parent
accurately detects and reports child process failures.

--------------
Before patch:
--------------
- [RUN] test_unmerge
ok 1 Pages were unmerged
...
- [RUN] test_prctl_fork
- No pages got merged
- [RUN] test_prctl_fork_exec
ok 7 PR_SET_MEMORY_MERGE value is inherited
...
Bail out! 1 out of 8 tests failed
- Planned tests != run tests (9 != 8)
- Totals: pass:7 fail:1 xfail:0 xpass:0 skip:0 error:0

--------------
After patch:
--------------
- [RUN] test_unmerge
ok 1 Pages were unmerged
...
- [RUN] test_prctl_fork
- No pages got merged
not ok 7 Merge in child failed
- [RUN] test_prctl_fork_exec
ok 8 PR_SET_MEMORY_MERGE value is inherited
...
Bail out! 2 out of 9 tests failed
- Totals: pass:7 fail:2 xfail:0 xpass:0 skip:0 error:0

Fixes: 6c47de3be3a0 ("selftest/mm: ksm_functional_tests: extend test case for ksm fork/exec")
Acked-by: David Hildenbrand <david@redhat.com>
Co-developed-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
---
 .../testing/selftests/mm/ksm_functional_tests.c  | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
index 996dc6645570..534aa405cac7 100644
--- a/tools/testing/selftests/mm/ksm_functional_tests.c
+++ b/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -512,14 +512,14 @@ static int test_child_ksm(void)
 
 	/* Test if KSM is enabled for the process. */
 	if (prctl(PR_GET_MEMORY_MERGE, 0, 0, 0, 0) != 1)
-		return -1;
+		return 1;
 
 	/* Test if merge could really happen. */
 	map = __mmap_and_merge_range(0xcf, size, PROT_READ | PROT_WRITE, KSM_MERGE_NONE);
 	if (map == MAP_MERGE_FAIL)
-		return -2;
+		return 2;
 	else if (map == MAP_MERGE_SKIP)
-		return -3;
+		return 3;
 
 	ksm_unmerge();
 	munmap(map, size);
@@ -528,12 +528,14 @@ static int test_child_ksm(void)
 
 static void test_child_ksm_err(int status)
 {
-	if (status == -1)
+	if (status == 1)
 		ksft_test_result_fail("unexpected PR_GET_MEMORY_MERGE result in child\n");
-	else if (status == -2)
+	else if (status == 2)
 		ksft_test_result_fail("Merge in child failed\n");
-	else if (status == -3)
+	else if (status == 3)
 		ksft_test_result_skip("Merge in child skipped\n");
+	else if (status == 4)
+		ksft_test_result_fail("Binary not found\n");
 }
 
 /* Verify that prctl ksm flag is inherited. */
@@ -606,7 +608,7 @@ static void test_prctl_fork_exec(void)
 		char *argv_for_program[] = { prg_name, FORK_EXEC_CHILD_PRG_NAME, NULL };
 
 		execv(prg_name, argv_for_program);
-		return;
+		exit(4);
 	}
 
 	if (waitpid(child_pid, &status, 0) > 0) {
-- 
2.47.1


