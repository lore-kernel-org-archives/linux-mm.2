Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67395D6AB1F
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 23:59:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FA3C6B008A; Thu,  2 Apr 2026 19:59:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC9996B008C; Thu,  2 Apr 2026 19:59:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D90B36B0092; Thu,  2 Apr 2026 19:59:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C89B36B008A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 19:59:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 807EBE029B
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 23:59:48 +0000 (UTC)
X-FDA: 84615286056.14.8C2EFD3
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5FDEE1C0004
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 23:59:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Bye4XgbO;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf21.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775174386; a=rsa-sha256;
	cv=none;
	b=ylaLByubc6nDZgZqCDysULFezE0TAQRL2/IBM0RTrstMHD92Y5ehzjTSHgVq7jxQhwWgB1
	gRii7O8NJIsPPEcHNnK04HUb7BFogSW4BcUF0sUZN4MKU3RSk7KpVrx0+TMpIw4lpasVqg
	nioyMX2sXedmAXKYYdkwq7Qp3BZ/nLU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Bye4XgbO;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf21.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775174386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8r3Z9sl9oUTSLnWJ1fAH6yXNWbaC0iemvsrsKPlZqTE=;
	b=pB3/plUn5k12hyhjUYlOjG4AI3nCxCn/6BAdTtGH/94uS1RggLL8JZW+EuQBijD9jbPRa5
	5EGFcox6mCck+gr+CKAeh7uGjwD5rzKuQoXmfcqCtwGr985O1OLUmapRlzCNkUQ1BDy7nP
	04e/3J8kE74L72iUZCkzliW7JPDVyCc=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 632FBnYc2879362;
	Thu, 2 Apr 2026 23:59:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=8r3Z9
	sl9oUTSLnWJ1fAH6yXNWbaC0iemvsrsKPlZqTE=; b=Bye4XgbOU14RUw+RQe9Rr
	hly9iVhYrKSpm5cQZxN4393iuVCskcljrpVdfQ2Zl+2WOZyWGf6a4ft0w9h9qwG5
	CqsSchUWb2iiBQke9FFs60Yt++/G/a3vonRF8VfvhhOlhxl+cbT97FFIkyAXTIVE
	J1vBMPtesG5ew+GxoWFJHBwXYX8zkm/LtBSK2DBN6AKf+Bgnrjj50RB/vCj+RrN+
	kDsssGmMid9a7b4jsPyyy7YNamQ6yD1tk89TI7escz/Eiso3XIh8zNCroye6Vz2h
	G7Kn65URNmdnxeeJgk9w/BFaxva2SViD2cr+Mx4Ok2cT652kIMyoCdmRATbxRJf4
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d65s11dxw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Apr 2026 23:59:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 632KoxLQ008476;
	Thu, 2 Apr 2026 23:59:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4d65ekna89-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Apr 2026 23:59:41 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 632Nxb6R011992;
	Thu, 2 Apr 2026 23:59:40 GMT
Received: from localhost.localdomain (ca-dev60.us.oracle.com [10.129.136.27])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4d65ekna7a-3;
	Thu, 02 Apr 2026 23:59:40 +0000
From: Anthony Yznaga <anthony.yznaga@oracle.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
        Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de,
        Jason@zx2c4.com, shuah@kernel.org
Subject: [PATCH v2 2/2] selftests/mm: verify droppable mappings cannot be locked
Date: Thu,  2 Apr 2026 16:59:33 -0700
Message-ID: <20260402235933.10588-3-anthony.yznaga@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260402235933.10588-1-anthony.yznaga@oracle.com>
References: <20260402235933.10588-1-anthony.yznaga@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-02_04,2026-04-02_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2604020214
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAyMDIxNCBTYWx0ZWRfX6J72LJy+SDF/
 NybwQaUdStmI9xHGIpy2JIgK6NJux6h1L2y8cSjwsdhYHmoAmsrc+9LR2gzgmM+P6/lGFdrfgmA
 HTlvJ5HCfXSsGmOCdUWqZxHS2yVAL4hnzfJxhCU8qS90ABCS2Zn81FrYVmUkI8ZBLRgiCgTp6O8
 m7SgeoDAb9tvmGXE0O/jMSPkN7HGbtWvNlX66NRZnpoCdKo8S/LuR/YJ0ftSm13+S9WVvlUZi3E
 mxPg9nH31s8Xnk1mN9D6lfqP1hMaLYFYtbkm8wCQZmA2XuBG/F/Du1Ecx6mvrzbBf+oL0D9Tl7g
 u0I9V0X+YiAgrsGeDqfRxfijrqHV6kKPO913lv1rH54JhLrzN/Kqki2ew5HXYfXzbVSxm8txfB+
 lG9yXhKWdbT0tXy/+iKC7EgYN4zzpqoTATay5rV77+7NeMRWpBdh8ELd5bk54y5SwFMAizjnL9S
 gk2+QFP6GBr+wXSlrQi9jvopsK1Ih2iHw2GT4eYQ=
X-Proofpoint-ORIG-GUID: XLamt7WrgjBa-D-1jgURnDm02QIwO6h7
X-Authority-Analysis: v=2.4 cv=BvOQAIX5 c=1 sm=1 tr=0 ts=69cf02ee b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=_qCjRXgy2aYRKG6zBr8A:9 cc=ntf
 awl=host:12291
X-Proofpoint-GUID: XLamt7WrgjBa-D-1jgURnDm02QIwO6h7
X-Rspamd-Queue-Id: 5FDEE1C0004
X-Stat-Signature: rx3acgi49ifra9n768cwkm7bgb4mfr76
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775174386-345605
X-HE-Meta: U2FsdGVkX1+BQP9FwyHS/A1b8p0PMHyAcD4jFJa20+BreVwGiwmZk/9x9ff7cMTaqWTU3Nibd5oRxxAt9Cds+ryLHTxEMCDWwzwCuVUeSo15RJBl00C3kU1mQ1oKT8GphDg5QgeEpWjvJFpwpqGauG8b3i/1B3YEjwGeWcDM86UWaLuHGsYymkiOoTXpup6rOIB3YNWM4Op/m5FkHzOeM29HUcsaCe/QVzMKoSuC14D2jgorc0/Rz1FjYWHl/U7oBtQz+hIbFxRWs3/FuOlbGeG4AErW3W/wkk14QEzKQvKkKZ7gQac30YnzHg9joAVzFIgbx4kumZ1EqFsdhyrbaQqnd/s+X5JIIx+GyEpDuPFAIu2JDtbVz1aDavUut5OwV1KJGYWbdfVucjB2ZmwwiVfXALL/JFB60h5rfVUld1P1DXV3Zmgo2o3QF6kBhCeTF9X/CPr1INI4NEiAJ9fWEXa2qbw08U42lGEa4OgJglZLjwVJz5KSM3C7dS2MZJDDchLy404Udu/8zm5i6hYSihzsFhC9rg+uYL1dUXg8aCicsldH53VKxguqMQeR1DHAIXU2YRAMgywP2okc33gK0mVPUMzmvkDNB489kad5qcfVJzb6AWIFjvuG2lYA2W9tyIWZucNyamIX1KUf3XeDzv5RXh27VMe5THCLh3dxcGYsCbAEmuer0dtEPegvMlHh9VLJOmJ4KHKdau/a2Ql4JMQ643JQZsV/q0Ft99rikvopW3kVlNxJMGKf9pUAV66XeEtP+4HmYha51W1KA6fxgOm6rKAjDzcenpvkaNz79m76cMNTWcXdcDp8NWs/h6GH7m/CpkEFsB+xC8cs+m7oTMu/ckz6SuPkodZilkQAPzqziQ8NB2SKsZoLUup8bnErH/yw0MoBSnhon3HUuyPlMK54pR5dDqLexuWvK28BG0zF0pcpCUbw3s769B3scYkCiX4uiX+UgciqPooCjj+
 tOtnK/fT
 /lXZMKu06JNSfupDuvoXE/OavZ/BdRA2jaUKxccXAXDMpy8F6f/j30+Y+/6278eViqRk1LAcwc3RYtij5JTao5bnCLM66G9ux4CZLCwRlOVY2RAvhV4RI1nbInJYjC6hZKLAoo1kEeTElpzU1eskdT/CAe66hpwDCqCOxV8D7Blr2Y2Vv4/VCG0wAoBuAvdVt4kdKB6sFaot7mdMKf6TKYbhzufsvhA4S9JduE1mFoVkItLtKfs8U+fz0eu+OMETKl0/fmq1f4N152YV69iP0trO5MQ==
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
---
 tools/testing/selftests/mm/mlock2-tests.c | 87 ++++++++++++++++++++---
 1 file changed, 78 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/mm/mlock2-tests.c b/tools/testing/selftests/mm/mlock2-tests.c
index b474f2b20def..353d0e5daa44 100644
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
 
@@ -336,7 +340,70 @@ static void test_munlockall1(void)
 		ksft_exit_fail_msg("munlockall() %s\n", strerror(errno));
 	}
 
-	ksft_test_result(!unlock_lock_check(map), "%s: No locked memory\n", __func__);
+	ksft_test_result(!unlock_lock_check(map, true), "%s: No locked memory\n", __func__);
+	munmap(map, 2 * page_size);
+}
+
+/*
+ * Droppable memory should not be lockable.
+ */
+static void test_mlock_droppable(void)
+{
+	char *map;
+	unsigned long page_size = getpagesize();
+
+	/*
+	 * Ensure MCL_FUTURE is not set.
+	 */
+	if (munlockall()) {
+		ksft_test_result_fail("munlockall() %s\n", strerror(errno));
+		return;
+	}
+
+	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANONYMOUS | MAP_DROPPABLE, -1, 0);
+	if (map == MAP_FAILED) {
+		if (errno == EOPNOTSUPP)
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
+		if (errno == EOPNOTSUPP)
+			ksft_test_result_skip("%s: MAP_DROPPABLE not supported\n", __func__);
+		else
+			ksft_test_result_fail("mmap error: %s\n", strerror(errno));
+		return;
+	}
+
+	ksft_test_result(!unlock_lock_check(map, false), "%s: droppable memory not locked\n",
+			__func__);
+
+	munlockall();
 	munmap(map, 2 * page_size);
 }
 
@@ -442,7 +509,7 @@ int main(int argc, char **argv)
 
 	munmap(map, size);
 
-	ksft_set_plan(13);
+	ksft_set_plan(15);
 
 	test_mlock_lock();
 	test_mlock_onfault();
@@ -451,6 +518,8 @@ int main(int argc, char **argv)
 	test_lock_onfault_of_present();
 	test_vma_management(true);
 	test_mlockall();
+	test_mlock_droppable();
+	test_mlockall_future_droppable();
 
 	ksft_finished();
 }
-- 
2.47.3


