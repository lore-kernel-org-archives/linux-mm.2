Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6A30CA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 04:02:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81BA36B0392; Sat, 16 Aug 2025 00:02:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F3486B0393; Sat, 16 Aug 2025 00:02:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E2026B0394; Sat, 16 Aug 2025 00:02:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 604F06B0392
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:02:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2AFBEB8BC6
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 04:02:41 +0000 (UTC)
X-FDA: 83781274122.08.E0FDE83
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf07.hostedemail.com (Postfix) with ESMTP id BACC940003
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 04:02:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=cX3gpkWm;
	spf=pass (imf07.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755316958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nHo2SN3gcGzUExjzyKYW/0FDFz7FrPaEIlRYkrngvPI=;
	b=SSK5dbG86iOaw6sHJ7OsgTxChrVSmsKsowwK2VKeaf9gnaKnXJzhg3qSDF7CLJQx9KOP7X
	i+GOCL8JJoaaMpIsB7uRt6WClzcSrOgcuGJQ7pryP4j+Vrj+aNsdhsDTisEjtGruK4Wk3B
	iB7jXmBtByIRuPQBr/5ssX60lPtZJBw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=cX3gpkWm;
	spf=pass (imf07.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755316958; a=rsa-sha256;
	cv=none;
	b=VS+etZ3tZLKzlppoyYxrWwBb/R7DaXb5+hmocXjYqPofM6G5ur7rzsX1L/I19m2qIHXI9K
	2g4WSstZyO9l71nSjCT8TfSj5p+vtaqDNTm4bCNbmQ8VOnJaXR+0A/5NH9RyO/mQlM1F+J
	KUK66offv1K+2h6opP0Svtbf+P824eo=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57G2xJ8F018155;
	Sat, 16 Aug 2025 04:02:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=nHo2SN3gcGzUExjzy
	KYW/0FDFz7FrPaEIlRYkrngvPI=; b=cX3gpkWmwyOa3UaZ7FdMsc/g5S/kPaE3K
	aGotc2tFLjsNpp1PElaPZG+ELj18BtiHiTNYhlOJPxdvG0k4/JXfye2GCX91R7Tk
	pNNgog1oX5vzpO4Qy7UfIw9s8mNQinYZ5TR1dMADVk9EmVVDbriNgAnj9jaqHqhc
	dVt9pV7NPrWx+hiZa7+4vYtAS+hO9t9/HdquO08R0/1KoPSlZ4IwpJq5dMpMA7lq
	k+bSl/1OncLeMdALlNtq+BkjJS5iuAsGA1ItlZBCKfgUB21kNu927KxLB/rIP8qx
	uYX5mnCvXMOlSJSpX1g9iOnOOzzrTHI/+IjhZAiBhfiyFFEbMuqYQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48jfdrgf99-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 16 Aug 2025 04:02:33 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57G42XFB000377;
	Sat, 16 Aug 2025 04:02:33 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48jfdrgf96-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 16 Aug 2025 04:02:33 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57G20xAS028585;
	Sat, 16 Aug 2025 04:02:32 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48ej5nkqsk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 16 Aug 2025 04:02:32 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57G42S3053150096
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 16 Aug 2025 04:02:28 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 314C520040;
	Sat, 16 Aug 2025 04:02:28 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CD89820043;
	Sat, 16 Aug 2025 04:02:16 +0000 (GMT)
Received: from aboo.ibm.com.com (unknown [9.36.5.210])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 16 Aug 2025 04:02:16 +0000 (GMT)
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: akpm@linux-foundation.org, Liam.Howlett@oracle.com,
        lorenzo.stoakes@oracle.com, shuah@kernel.org, pfalcato@suse.de,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, richard.weiyang@gmail.com
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, donettom@linux.ibm.com,
        ritesh.list@gmail.com, aboorvad@linux.ibm.com
Subject: [PATCH v4 5/7] selftests/mm: fix child process exit codes in ksm_functional_tests
Date: Sat, 16 Aug 2025 09:31:11 +0530
Message-ID: <20250816040113.760010-6-aboorvad@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250816040113.760010-1-aboorvad@linux.ibm.com>
References: <20250816040113.760010-1-aboorvad@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TmCRbYxGb0dZO1krQqFm6IMPizm63qOO
X-Proofpoint-GUID: Wi2bis6C76syRZp2ba6H0tsiN2ypFzRn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE2MDAwMSBTYWx0ZWRfX+Oe+LBRxCe3d
 1r8z+4/YjhBB3hzbFvUSXxKzOAQPEn6Djp1CtS450SPUoJglpwbEd1uIrGC4+7ojwI043ubwXTA
 NKStX7qWPTQMKBi134X+mHO34xJf27UE4pQCLXhlr7ryrKp5aiTyoVoX0xMPrUNryeT8bYXQm19
 eKplf56tSqQoJuhTZI3abCdgpBM2Lep07Pi1VnIV8qgihhisR0tQ3mw4qA4P1D3XFBgetarAKUu
 4XsP89Gm5cKnbNHekB97h3Z38aOvvH/vS+oQvstYvToXA2bq8tTWivCdUJcyymL2bnGQmRB1A/w
 HsrVvyXgDi9Z+ER85d2aDkTqv84cAoUzL9fP20bCwSgus+m3vhZtXzM0D9sH9aqdisQEn/UK70F
 NUuDDoU6
X-Authority-Analysis: v=2.4 cv=GotC+l1C c=1 sm=1 tr=0 ts=68a002d9 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=1sOJkUf8yoZECTHbNm8A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-16_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 adultscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508160001
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BACC940003
X-Stat-Signature: jfxi691jkoyppjcrnd6p5cuhics7wibd
X-Rspam-User: 
X-HE-Tag: 1755316958-574038
X-HE-Meta: U2FsdGVkX1+ngMu/awTDXvXfdxXm+BCpSY4cbB6J1S4Pg2ukIbSfL4umNs5Q5sE1nKJ12t7ZYZfjrJMIcGitoVC3ZBBhZ+hUNoNJha46WIXnTYY6X1evUTNvhoNczuUBbeXFT3uS66BO3VqRgMdNXFYTk8HhdRhTiRs6MqyNfNxG7r/aVwwhyWZ+lgra/MRRyVuP/cQnrr/ki8asWOqkd/11OUz5perHFG7sEsrEIQ+vxSBeeaDBSY8JRIyAJGgafEQdgIpCTe+f+WqOXiXyFg3Hm5jh7/ITA6COFUfs42dvOl7Bjpij/iKMljgosA/SpD7oxJx8+NRdNEm7E44irXn3j9J21moNq0PIKPSL9ZMIoMG4o+vaBx6ZkxmfVLRZa0RwimmRlFQzd1q14kshTPLn1kpsBdiF3NpvLT7TzV7exyE4tMkk4gM1OYEvsRkyAN/Y67XXEp133o/CLbIE3on4imTEFX1wTFRqiIwh48s2N5F2Gt+5T6QJWo00bBiY7A72B7Gz9XuUXG4JA8b0FeLH6EZNXP8jhH+mzv+YBpMo/n0G61m81UaIUclrNNhfrZs9XtNglYn1N5i5qLMk5F0w66ntNuIQr51qEp07d3YIwOllhcKg57kFpwhYgI2TJhA9BrylbDGqe2q4EetrlFOJ1RvSLX6npcbOg6B4x81QKJZbTeGLR9AHz3QlSTQHtutJClWhBA8xP50ZLQKvWvK++mrvB4WUQGQHReQSfzudWCtxwoZLNTpweXfOkhresGc3YIyI6q73e5fxDjdB4yFfL0haEJnqx9fKeUePg4aQQ1OUG1ZlutLdx7PPKKrsqjU8LWnpf2BdKrllfMLe6uz/18mhFHJprLnAT9x0qPk18n4ngvNISijI+vV4TpE5eGdoOy8dFaY9zXmBoXR+hgelNhyfIDON0Aadem+cfNutoplXcy8A/OW20V6ZAdfmoqIqviDWIJLgbQIZijc
 OyDYViD1
 txvcd79tnSvsmEL3sl7KbcM2mV39E8cIIfuBIppP2awOT7DetVST8GPLhRFwq7LBUbdO+CGIOZDSJiKwOrpKUZabVT+gAuEc+T0fE9KRynBYI33VmZpz13KiL4WKpkDKBzZeYmt/FJC4uHgJpLQGJiM5jh4C3F9RUIhk1gmkZkS4hkYT9jfo6yAI5UzFj5bQiTdbgaHdNOQUSnqPTAVOYsrpi+copgNX/WSsfWgckAk/nC3qGlrexCSyU7MCkzAbx98Z3395cLgXar2jGX6iHycuL4oO8FDLqSmJ2qwM6efulOy5kYgJhEv9/rYJ1IL5K6PTKbR2jcr478fKRawRUTgRcAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In ksm_functional_tests, test_child_ksm() returned negative values to
indicate errors.  However, when passed to exit(), these were interpreted
as large unsigned values (e.g, -2 became 254), leading to incorrect
handling in the parent process.  As a result, some tests appeared to be
skipped or silently failed.

This patch changes test_child_ksm() to return positive error codes (1, 2,
3) and updates test_child_ksm_err() to interpret them correctly.
Additionally, test_prctl_fork_exec() now uses exit(4) after a failed
execv() to clearly signal exec failures.  This ensures the parent
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
Co-developed-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
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


