Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7C85F433DD
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 03:39:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC1996B008A; Wed, 15 Apr 2026 23:39:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D24236B008C; Wed, 15 Apr 2026 23:39:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD9F16B0092; Wed, 15 Apr 2026 23:39:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9DE146B008A
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 23:39:53 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5745E1B83A4
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:39:53 +0000 (UTC)
X-FDA: 84663015066.22.75F54E0
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 406C620005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:39:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="mq/AAdzA";
	spf=pass (imf03.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776310791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pBs88sKOYW+KfbnSxXMfv78XajJ1iuYx3b3CfIUihUY=;
	b=RKy0YWaAARKf08Z80jP0SXr6b1JWpC3tYy6acNtVDxz7LTRM9vXrrQsTP8voANNHoPKWSQ
	p1J+Ha4VCLufkl741b25nzz+gD1IvhcGzlZm2GrZ+rFMpWrC1XXoSBcjwXb4bTKaigXSas
	8WnxEw0jiK4MfAHAe4bKeLo81vrIFZw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="mq/AAdzA";
	spf=pass (imf03.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776310791; a=rsa-sha256;
	cv=none;
	b=lbLGeCD/sIYXOaTduPtVsw7JQ8dALuD8ubCjJaGxaZooL429kL53PTKmr8qci8KMZFDqxw
	+R8tA0r7HHPiqJHxB5keeQA7rWXPpuEwR1b9BRzAY7xhA9go7qQ+BOtXawLntU4ke3ghbP
	ClzLcOVIIl/FQr9yt4zMRR136HRICuE=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63FJMQfh1959107;
	Thu, 16 Apr 2026 03:39:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=pBs88
	sKOYW+KfbnSxXMfv78XajJ1iuYx3b3CfIUihUY=; b=mq/AAdzAbvvO6Xy7YSVgx
	niXv/L7Hx+nDXAkVE/reJ3xGBwKSfrfOx128dJ4fXoKgpQKhA4lBVmEWyX0QHIgk
	VW3pDBO2QhvECwVJgwgM0SpaV+Bvt/RPgK7ZClTWwO8iwzquVK3fCA9MPLDhs03i
	SEtAglEEJ4LyQIujZ0ywMrw/eIDs67Rfu23hB5nlXUb63dVTypAJ4o84coS6Su4u
	AxnSS5nW6HtEiK7NzSVUIFg8nRkp5IOXazwazVZOb3eiQ9se+7gqYodtna18gHO5
	DsXVzXO9PIRLij6uNmsiKXFXSk8wMsZUgxtUfbYRBzB4jOTjx8+p1tkNpNYHuDys
	g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh85jpps2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Apr 2026 03:39:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63G3dXaF022498;
	Thu, 16 Apr 2026 03:39:46 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7npq7n1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Apr 2026 03:39:46 +0000 (GMT)
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 63G3dgiv023193;
	Thu, 16 Apr 2026 03:39:45 GMT
Received: from localhost.localdomain (ca-dev60.us.oracle.com [10.129.136.27])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4dh7npq7k1-3;
	Thu, 16 Apr 2026 03:39:45 +0000 (GMT)
From: Anthony Yznaga <anthony.yznaga@oracle.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
        Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de,
        Jason@zx2c4.com, shuah@kernel.org
Subject: [PATCH v4 2/3] selftests/mm: verify droppable mappings cannot be locked
Date: Wed, 15 Apr 2026 20:39:38 -0700
Message-ID: <20260416033939.49981-3-anthony.yznaga@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260416033939.49981-1-anthony.yznaga@oracle.com>
References: <20260416033939.49981-1-anthony.yznaga@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_01,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604070000 definitions=main-2604160031
X-Proofpoint-ORIG-GUID: p_OLhKqDoFZnxEqJ9iBzjEAVV7pmgN4N
X-Proofpoint-GUID: p_OLhKqDoFZnxEqJ9iBzjEAVV7pmgN4N
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDAzMSBTYWx0ZWRfXzf5wn6LWSjs5
 YX5JHpQhCUt194QIDGmu3AfGl4rmCgbYSL6i+BcyWK7TzXVa1zgYd/fggsIYXLDWSy5KBkrV4or
 GopOzT+QyV+PQ8LuBhMeu5NPV1A3vm50Ci4GhFK0HajWI11WmuTdPBTPto6BnJFsz8eBL16doD/
 7dAi4QVslU2Fxlpr06LfwKj4/I+iLTnbfvPuXR+8MPkT4MmK4C+HDUWjW3PvGSgnh0DYm3Cd27n
 I3DzQdUYbvylAJhzYhiRxzV8ZCwfJ1fIaM/mIXBi81OtATr5O7eW7uZ2sba7nT0Iev9kZixVdwB
 6r/IZ3R79b2ByXdluTGxO+DfJktYPXalHjONdl/u1xslhOhWROndL+ozti/Dy3WUADRuuUSIgoG
 +HfuXCTCzQIWu8VAYBBH/1tyFBuNFLimj1Vt86O2Lp5QtY4dxLnPNDPrUVKttU7YbrjbAFV9Ekh
 4T4T5d+Rvp3HYregSUp+fjQFpQJ7IclQ3ERyKa3I=
X-Authority-Analysis: v=2.4 cv=Co+PtH4D c=1 sm=1 tr=0 ts=69e05a02 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8
 a=_qCjRXgy2aYRKG6zBr8A:9 cc=ntf awl=host:12291
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 406C620005
X-Stat-Signature: qycfh4icfu8mxbfcoqzgeqyfpi4yrn5p
X-Rspam-User: 
X-HE-Tag: 1776310791-569153
X-HE-Meta: U2FsdGVkX1/HVx8v/RhuxpxATDSZkD0scs4MU4liSajLWpGAeYInwH7n89VN6e0JyZHtFrywiEFZp9Tjag6oQ1oycuWNWjU+jV3PdZDuCY8fv3mbBCJRKAzJZoNC61SpAvlMFNTSbVkcDBt82XzJl5xjtB+vDYczvsGnJKYawPe34OZZk5/7Y1+b+a/xHl+er+JCJdUeAoFQE20vX9p464ueqLSJn86/CYo/hpxDSFR1RFUA/dOsgVHRjUOjhjM53T9t4D0DVyIPj0KjuXNy3WJuDkPjEj56Oip0NGsPEw8mEQW5jDtYS0qhV2UVDKWDzc7xpt60I2mZbGOTLmE2nN+NrDtn21P+qszlD4gMChQURciT9/BGEQAHnOwxoIxIaAKIhSPILpEudp3lr7pCWhaioBQB8xVYkdgQhy+ee/qFn7zmSyFauSh1Yd3Cekmiwakr65qANHEBtHCssmEGLznHSxm1UQKdOVhW7OLWUaRCWy0IOb+X4KT20SNMvAU1L38Jl0EBYdZlEj+4GcjbpQh/N52EUK7obq4Fw6R/9RIV0BqHvEv3VehqK9UFQdQuEwiss95iI++/VfCeTrslyci1SQZQefsUchj3+I9OtG4uCWWxgAOhkRSHh+8h5PSIUR64pDIgu1f8kfY9nRJRUI5ur0uGlLSJTf3OUQKc6dtnxN4HyNtteQ41aFzw/FMaIsZyaADnVIG36GNbEoTY1qkTgzXwpL1LyDFwftlEyFi2o4vycXnfeFAR8mAbcEceXydN6euKRWKje3QOULIotcirXORBPsJZWj5OfnUmwy2bXciKaLnSdI14sAKLVLwykmQojlpjFZu720OQMeU/Ux58nDpSAFc44GcFYQcZAIpzLIqH9Jg8ZvEtPYCARRfh1K3FHE9B9PIFWPxLcsMoHZnZ+ExL0OTPvQMq8UlhRicAEO6W4ySW2shtc/4+yI/wr2JUDxRDiryBH0Wk9pM
 YGTYzAfA
 CbSJ74pW1hoylk/LeShHKcRiPozs4cYoubjxyBhSHvIRxRbpfua7+BBg78lQZZIf24/P3S5bLSA7U6JB8mI8b7pgW+KoUIlyenv03FccfzYdJ7YHxvAYXOC3xCLG37BcvBVWto8608DJC11j06vqdx5rmCkLMYgh1KZiC85idOoAr0O30LGg+tBFyHky6F+IsasTr7D6mh//LWknI8tUyF179kA3bATvV1TwpQmolPXKWKPlVC9pcnITaIE+fMMi4ckkcf3qGejBwRclzRLSc5dhdCUfdLtu8oiWjJUjUk4jLfgU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For configs that support MAP_DROPPABLE verify that a mapping created
with MAP_DROPPABLE cannot be locked via mlock(), and that it will not
be locked if it's created after mlockall(MCL_FUTURE).

Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 tools/testing/selftests/mm/mlock2-tests.c | 84 ++++++++++++++++++++---
 1 file changed, 75 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/mm/mlock2-tests.c b/tools/testing/selftests/mm/mlock2-tests.c
index b474f2b20def..e16e288cc7c1 100644
--- a/tools/testing/selftests/mm/mlock2-tests.c
+++ b/tools/testing/selftests/mm/mlock2-tests.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #define _GNU_SOURCE
 #include <sys/mman.h>
+#include <linux/mman.h>
 #include <stdint.h>
 #include <unistd.h>
 #include <string.h>
@@ -163,14 +164,17 @@ static int lock_check(unsigned long addr)
 	return (vma_rss == vma_size);
 }
 
-static int unlock_lock_check(char *map)
+static int unlock_lock_check(char *map, bool mlock_supported)
 {
-	if (is_vmflag_set((unsigned long)map, LOCKED)) {
+	if (!is_vmflag_set((unsigned long)map, LOCKED))
+		return 0;
+
+	if (mlock_supported)
 		ksft_print_msg("VMA flag %s is present on page 1 after unlock\n", LOCKED);
-		return 1;
-	}
+	else
+		ksft_print_msg("VMA flag %s is present on an unsupported VMA\n", LOCKED);
 
-	return 0;
+	return 1;
 }
 
 static void test_mlock_lock(void)
@@ -196,7 +200,7 @@ static void test_mlock_lock(void)
 		ksft_exit_fail_msg("munlock(): %s\n", strerror(errno));
 	}
 
-	ksft_test_result(!unlock_lock_check(map), "%s: Unlocked\n", __func__);
+	ksft_test_result(!unlock_lock_check(map, true), "%s: Unlocked\n", __func__);
 	munmap(map, 2 * page_size);
 }
 
@@ -296,7 +300,7 @@ static void test_munlockall0(void)
 		ksft_exit_fail_msg("munlockall(): %s\n", strerror(errno));
 	}
 
-	ksft_test_result(!unlock_lock_check(map), "%s: No locked memory\n", __func__);
+	ksft_test_result(!unlock_lock_check(map, true), "%s: No locked memory\n", __func__);
 	munmap(map, 2 * page_size);
 }
 
@@ -336,7 +340,67 @@ static void test_munlockall1(void)
 		ksft_exit_fail_msg("munlockall() %s\n", strerror(errno));
 	}
 
-	ksft_test_result(!unlock_lock_check(map), "%s: No locked memory\n", __func__);
+	ksft_test_result(!unlock_lock_check(map, true), "%s: No locked memory\n", __func__);
+	munmap(map, 2 * page_size);
+}
+
+/* Droppable memory should not be lockable.  */
+static void test_mlock_droppable(void)
+{
+	char *map;
+	unsigned long page_size = getpagesize();
+
+	/* Ensure MCL_FUTURE is not set. */
+	if (munlockall()) {
+		ksft_test_result_fail("munlockall() %s\n", strerror(errno));
+		return;
+	}
+
+	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANONYMOUS | MAP_DROPPABLE, -1, 0);
+	if (map == MAP_FAILED) {
+		if ((errno == EOPNOTSUPP) || (errno == EINVAL))
+			ksft_test_result_skip("%s: MAP_DROPPABLE not supported\n", __func__);
+		else
+			ksft_test_result_fail("mmap error: %s\n", strerror(errno));
+		return;
+	}
+
+	if (mlock2_(map, 2 * page_size, 0))
+		ksft_test_result_fail("mlock2(0): %s\n", strerror(errno));
+	else
+		ksft_test_result(!unlock_lock_check(map, false),
+				"%s: droppable memory not locked\n", __func__);
+
+	munmap(map, 2 * page_size);
+}
+
+static void test_mlockall_future_droppable(void)
+{
+	char *map;
+	unsigned long page_size = getpagesize();
+
+	if (mlockall(MCL_CURRENT | MCL_FUTURE)) {
+		ksft_test_result_fail("mlockall(MCL_CURRENT | MCL_FUTURE): %s\n", strerror(errno));
+		return;
+	}
+
+	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANONYMOUS | MAP_DROPPABLE, -1, 0);
+
+	if (map == MAP_FAILED) {
+		if ((errno == EOPNOTSUPP) || (errno == EINVAL))
+			ksft_test_result_skip("%s: MAP_DROPPABLE not supported\n", __func__);
+		else
+			ksft_test_result_fail("mmap error: %s\n", strerror(errno));
+		munlockall();
+		return;
+	}
+
+	ksft_test_result(!unlock_lock_check(map, false), "%s: droppable memory not locked\n",
+			__func__);
+
+	munlockall();
 	munmap(map, 2 * page_size);
 }
 
@@ -442,7 +506,7 @@ int main(int argc, char **argv)
 
 	munmap(map, size);
 
-	ksft_set_plan(13);
+	ksft_set_plan(15);
 
 	test_mlock_lock();
 	test_mlock_onfault();
@@ -451,6 +515,8 @@ int main(int argc, char **argv)
 	test_lock_onfault_of_present();
 	test_vma_management(true);
 	test_mlockall();
+	test_mlock_droppable();
+	test_mlockall_future_droppable();
 
 	ksft_finished();
 }
-- 
2.47.3


