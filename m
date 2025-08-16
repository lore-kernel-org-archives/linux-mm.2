Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36C27CA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 04:02:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAE6F6B02A4; Sat, 16 Aug 2025 00:02:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C86566B02A5; Sat, 16 Aug 2025 00:02:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9CA48E0006; Sat, 16 Aug 2025 00:02:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ACBC76B02A4
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:02:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 386AE138127
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 04:02:18 +0000 (UTC)
X-FDA: 83781273156.25.763A04F
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf10.hostedemail.com (Postfix) with ESMTP id ADD06C0007
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 04:02:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=PBWlJ1n7;
	spf=pass (imf10.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755316935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eGzWIZiqMaWv4GVzOQCi1nMNGqm4yh5E7Pden64lkc4=;
	b=BE+aC7owwcgnHZypPvXWs/EO/UnwGg55yNA8FkNvuzDaWEpnVmK3le9YU0BLONdXfRAcFH
	mw8m9Z2EwU0ywbmy9fJJNReV6xEi7mBlKxttM1ImQFG6zRbE5jFOsPhbqutyptfvqU7dJb
	uMxANVsdlVVv3lgC8xoJtvyBdrfNv0s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=PBWlJ1n7;
	spf=pass (imf10.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755316935; a=rsa-sha256;
	cv=none;
	b=LG7pWDUxr8TQacZVMx89eJ6JljUW853hh2pdc0Pooch9JTamEYmeeff03nda872gS7aMRf
	1vk9Dgf3IsRUoNAD5olF+erfQYuVJ++R8n43zeDeLRg4AsFIzgKaMHe2rsP7ZEHyzhK89+
	EyDVJthDCHayesbhrVcXvns+wyQ8+e0=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57G3fHa5002575;
	Sat, 16 Aug 2025 04:02:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=eGzWIZiqMaWv4GVzO
	QCi1nMNGqm4yh5E7Pden64lkc4=; b=PBWlJ1n7VktRBBpUGfghIB9xKv/FHKpXP
	ivQnJpUCE9yA7GSm30HXF6o2DrT1X4BtPziOKwi21O/9RXrMdb41h6R0VJIT4JQa
	EijBt7iRsd6s0/gCWqhSqYS6hRR/7w1d/KBsBKemwsi6iaEjUIWnr2bWtkbyRCpV
	V46qp/f4/PAktduhYR8zR9UMujQY+kaYh9HgZ4iG5dAQ2N+ugOdqdW/t0lP7pe+q
	JUBWiWyaBer0HAqdIw7eYotLJ0DqozY+jxKSc6y64nwZrxPggqL3qpilZDkxBX/O
	9OsPuVgGhba2KHRJvF5OLo2e2Hty7khjcGsjzmMH0DoSHU9ib+3dw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48jhq9g442-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 16 Aug 2025 04:02:10 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57G40Oi1003065;
	Sat, 16 Aug 2025 04:02:09 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48jhq9g43y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 16 Aug 2025 04:02:09 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57G1hKqI028582;
	Sat, 16 Aug 2025 04:02:08 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48ej5nkqqd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 16 Aug 2025 04:02:08 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57G4244H20775218
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 16 Aug 2025 04:02:04 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 371DD20040;
	Sat, 16 Aug 2025 04:02:04 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0CE9220043;
	Sat, 16 Aug 2025 04:01:53 +0000 (GMT)
Received: from aboo.ibm.com.com (unknown [9.36.5.210])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 16 Aug 2025 04:01:52 +0000 (GMT)
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: akpm@linux-foundation.org, Liam.Howlett@oracle.com,
        lorenzo.stoakes@oracle.com, shuah@kernel.org, pfalcato@suse.de,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, richard.weiyang@gmail.com
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, donettom@linux.ibm.com,
        ritesh.list@gmail.com, aboorvad@linux.ibm.com
Subject: [PATCH v4 3/7] selftest/mm: Fix ksm_funtional_test failures
Date: Sat, 16 Aug 2025 09:31:09 +0530
Message-ID: <20250816040113.760010-4-aboorvad@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250816040113.760010-1-aboorvad@linux.ibm.com>
References: <20250816040113.760010-1-aboorvad@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=N50pF39B c=1 sm=1 tr=0 ts=68a002c2 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=yVrA2fujCtLeWmk1P3cA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE2MDAyNyBTYWx0ZWRfX8pCM/R0SBNnt
 82cyqeqxyMUvnDqpC6Wlz9ftzCjaRXh07IcDhBimcwdlQuUKYEcOawUciRCacNFmuPeZN3AfP/I
 XTARpWxPQA+apLotgcp60tGEucV2cd97RTOOZ19h/xrlmwWWEmNN1+dhmqCXq2jxLD/w8VuyGtj
 2a0zvK2ScMHcpl9HZVlDwDY2iSKMhiFyavxbyeRnLZ9jmUI1iTu2gc2PYb/p1B3OXDU3JpLYUu0
 iqMyH7A/yJdXc1wKbKBYJF5How9/Rk9VOR+51A70ePlmD+xrT03YG7cC2Mw8TCSb6IrGvOx+TDE
 KMzrVOcvEwacjchXe0s09QMTkVrzZfcn1G9iISEvB4AZbLeC9ihR4A1iEccZZ0olJis8H78sn+f
 DwrehoNc
X-Proofpoint-GUID: 4-QCN-rltZBnaB5UUevzv8HjYHCMBP0U
X-Proofpoint-ORIG-GUID: iADUmERIIYRuRT5DyeVXIzSWCbExzVxC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-16_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 suspectscore=0 impostorscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508160027
X-Rspamd-Queue-Id: ADD06C0007
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: zb8paj6mso6yn1cotpu6igokjmuyih5g
X-HE-Tag: 1755316935-10548
X-HE-Meta: U2FsdGVkX18+ZbHLjWqcahrgnnc8ySJxL0g4j7/Hwa9lhPVLemCIidqPnLJpI042MlhawOr1EsddHywD4EU8SNiVMNHWXLk3stNDR3zu3xQGtzRiZvhbw5EWmO07ETLqEcsawK4EXtextmt80WxUxC+A4nLU0JSA/lQySlEEfYsVvokYUakyueqjFXMXqZKcCEbGd4RuzhlRDJovkuS24sIZW1KJD8lDafkcxrH+CeS3hCbEoKmNWU2dPffP0hs29crhT8qnObY4aNOyELGtCuqdyxo07iGP5jONh0ikf03Y3EDQJ7sqL7+xuvyR2zszImLVolB/73WeufoETxXtsKzAEHgSJMY33kTgW9E1RqbD4O/6l1wdxFok5LypCRaUgJYPxUTurypJfx2mw7Fd8yVLtGPtxcA4M6ugbdJEUM/VeTRXgHfyJIxgf5CbiW0ZSxhTbSHcU4ez71QbA5SIwDsWVpBZOclBHALWv3EPLIvoV5PNep2Xw+QPXFTOfTFXsFd8fz/f+P77GLnJflmBorOWXbvo+u/6dX9/F5y/w5c0y2IBN0y9WcROw/CuRKUN9sf73vcEJxG2xeGHIzptkP1T+mRdLyCb+2Eg/H1C+EblokQDXqNFyxm+LILJ6LhorQEgjxQmRITluf0EhFYracAWIbUInuMSxkx0ZLefLRoTFVTbHrvvS6+x4tvbcJe9iCDr9a+YjVde4YLw+DqbBOwWnZSrlLLwFXQpQ/ayfCsXDTHkasetT0Di9GE9dfCOZOyTf+9cylmFvE2MwlHljOvQQyc1L9FVcHH7mVZx+7R+xk0zyRJOvFgo/f5ikLLDUulSatGTerXstRN4KnTTq2OqNObralzun8aI61WuoZxVceJVf2Y9k0w9zZdY2aAchXPUG88lkz0DXKo8hNksHEMDFLksZzZFk22JGRcC6aqJR4/UzzW9FabSrpMa0dLF8tEELi9JWf9pu18D7Fn
 XybEw/cA
 APGpRx7ZVvyGTT1RAy1YPv3xKaztE4NpUJL/7VPcqlJas4Q9D041nyYlHzZ0SU6+TZ9Je0js8tZ0xVcbiKPp5oA5Xpdw3HZFdrbt1ixNln7fkTC2ixObRmCjmro2fKt9jtPUMxmTQxNjcDq/R/q5K12dqk+zLtNl5NS8VYxu5aKwxCCAy8e670PrDqxgFo+kEpRjRInBtOajNhM1MfmaIsAWMRrN8fo9/kMggvYkGj+xfzI1gMMX6KsmrjX2jMQxxxA/EIl0oKRD8rOOpf4/oyLIpHYhpt7+hbISOUHKoLc+oum1HVnV4N/CuKJW/vQ/QmQXI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Donet Tom <donettom@linux.ibm.com>

This patch fixed 2 issues.

1) After fork() in test_prctl_fork, the child process uses the file
descriptors from the parent process to read ksm_stat and
ksm_merging_pages. This results in incorrect values being read (parent
process ksm_stat and ksm_merging_pages will be read in child), causing
the test to fail.

This patch calls init_global_file_handles() in the child process to
ensure that the current process's file descriptors are used to read
ksm_stat and ksm_merging_pages.

2) All tests currently call ksm_merge to trigger page merging.
To ensure the system remains in a consistent state for subsequent
tests, it is better to call ksm_unmerge during the test cleanup phase

In the test_prctl_fork test, after a fork(), reading ksm_merging_pages
in the child process returns a non-zero value because a previous test
performed a merge, and the child's memory state is inherited from the
parent.

Although the child process calls ksm_unmerge, the ksm_merging_pages
counter in the parent is reset to zero, while the child's counter
remains unchanged. This discrepancy causes the test to fail.

To avoid this issue, each test should call ksm_unmerge during cleanup
to ensure the counter is reset and the system is in a clean state for
subsequent tests.

execv argument is an array of pointers to null-terminated strings.
In this patch we also added NULL in the execv argument.

Fixes: 6c47de3be3a0 ("selftest/mm: ksm_functional_tests: extend test case for ksm fork/exec")
Co-developed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
---
 tools/testing/selftests/mm/ksm_functional_tests.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
index d8bd1911dfc0..996dc6645570 100644
--- a/tools/testing/selftests/mm/ksm_functional_tests.c
+++ b/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -46,6 +46,8 @@ static int ksm_use_zero_pages_fd;
 static int pagemap_fd;
 static size_t pagesize;
 
+static void init_global_file_handles(void);
+
 static bool range_maps_duplicates(char *addr, unsigned long size)
 {
 	unsigned long offs_a, offs_b, pfn_a, pfn_b;
@@ -274,6 +276,7 @@ static void test_unmerge(void)
 	ksft_test_result(!range_maps_duplicates(map, size),
 			 "Pages were unmerged\n");
 unmap:
+	ksm_unmerge();
 	munmap(map, size);
 }
 
@@ -338,6 +341,7 @@ static void test_unmerge_zero_pages(void)
 	ksft_test_result(!range_maps_duplicates(map, size),
 			"KSM zero pages were unmerged\n");
 unmap:
+	ksm_unmerge();
 	munmap(map, size);
 }
 
@@ -366,6 +370,7 @@ static void test_unmerge_discarded(void)
 	ksft_test_result(!range_maps_duplicates(map, size),
 			 "Pages were unmerged\n");
 unmap:
+	ksm_unmerge();
 	munmap(map, size);
 }
 
@@ -452,6 +457,7 @@ static void test_unmerge_uffd_wp(void)
 close_uffd:
 	close(uffd);
 unmap:
+	ksm_unmerge();
 	munmap(map, size);
 }
 #endif
@@ -515,6 +521,7 @@ static int test_child_ksm(void)
 	else if (map == MAP_MERGE_SKIP)
 		return -3;
 
+	ksm_unmerge();
 	munmap(map, size);
 	return 0;
 }
@@ -548,6 +555,7 @@ static void test_prctl_fork(void)
 
 	child_pid = fork();
 	if (!child_pid) {
+		init_global_file_handles();
 		exit(test_child_ksm());
 	} else if (child_pid < 0) {
 		ksft_test_result_fail("fork() failed\n");
@@ -595,7 +603,7 @@ static void test_prctl_fork_exec(void)
 		return;
 	} else if (child_pid == 0) {
 		char *prg_name = "./ksm_functional_tests";
-		char *argv_for_program[] = { prg_name, FORK_EXEC_CHILD_PRG_NAME };
+		char *argv_for_program[] = { prg_name, FORK_EXEC_CHILD_PRG_NAME, NULL };
 
 		execv(prg_name, argv_for_program);
 		return;
@@ -644,6 +652,7 @@ static void test_prctl_unmerge(void)
 	ksft_test_result(!range_maps_duplicates(map, size),
 			 "Pages were unmerged\n");
 unmap:
+	ksm_unmerge();
 	munmap(map, size);
 }
 
@@ -677,6 +686,7 @@ static void test_prot_none(void)
 	ksft_test_result(!range_maps_duplicates(map, size),
 			 "Pages were unmerged\n");
 unmap:
+	ksm_unmerge();
 	munmap(map, size);
 }
 
-- 
2.47.1


