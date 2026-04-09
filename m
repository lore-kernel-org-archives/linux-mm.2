Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 477C6F36B99
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 23:49:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BB536B0098; Thu,  9 Apr 2026 19:49:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 592E46B0099; Thu,  9 Apr 2026 19:49:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E6186B009B; Thu,  9 Apr 2026 19:49:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2D5E36B0098
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 19:49:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CA29C8AB0E
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 23:49:30 +0000 (UTC)
X-FDA: 84640661700.29.5019960
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 997D84000E
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 23:49:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=T8FEv1Mw;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf11.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775778568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q5zS4AbyfSrBrAYYwwDhm0BhvxfeDN7C2ZhJWTF0Yb8=;
	b=yGSvaxYOEb0Ht1ZUbVpE/0e7EmoAoFqFsEzCMfEmBMuoivPke0q+RpHIB+8zrpnOEyJOce
	15YyjKgAENnjt2Vdezct3ePgrjjTR8RYeiM76bcAL46JALSUGvwwbDyzcHBIAp7XqscFcd
	z4dGEkRnlw8f9hdTCKr3o0Iz8ZkKD3k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775778568; a=rsa-sha256;
	cv=none;
	b=7BI45+3a64rLyFhEaXWPqdmKs2R44HO21jZ5SVUxL/lkbX97MQEkU3JWK52NTvtjo+3IWM
	L/xjakMkZUliY1ELJYITa6kaaooLxUFnuyPXhUR7NaX7nOQW3h6PmoLOjG4NIpNqbYzjsd
	7anipSHvVSxjL98LK80P3/A0emOB7dk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=T8FEv1Mw;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf11.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639JtY2X3363830;
	Thu, 9 Apr 2026 23:49:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=Q5zS4
	AbyfSrBrAYYwwDhm0BhvxfeDN7C2ZhJWTF0Yb8=; b=T8FEv1Mw3WutcxNlPPYmx
	JhSyZFsBqGJdNaLgmChg/zpK28kobSnCrq329Q8fInSXD77k4xuWgiAwRLtAuGoM
	R9Bf/y1+GmV+gu3hNfOOpgFOVPu3JUJkomUb+YNnwhNFM6ZBRrP8pcymt0qZImQo
	7Q8ICnZA+O/nj/kc89wCZHLidfuDRpFP7iF3GWsyj4AY4ogsgrBcKu5FdHg+3xV+
	59G6Iz8sVpQyAJxXXN0MerPI722FwCxAAt7tzGbBbFYru9Se8kwQ24NaAHMlr2OI
	nsmUUdopczp29efGV7KfSHN9siDCn7YHlLN/QBomdWV8IviCfwLJqYx9UgegfLri
	Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqb0mc5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 23:49:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 639MGcdg003534;
	Thu, 9 Apr 2026 23:49:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dcn5ytg0c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 23:49:22 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 639NnIZQ019990;
	Thu, 9 Apr 2026 23:49:21 GMT
Received: from localhost.localdomain (ca-dev60.us.oracle.com [10.129.136.27])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4dcn5ytfx5-3;
	Thu, 09 Apr 2026 23:49:21 +0000
From: Anthony Yznaga <anthony.yznaga@oracle.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
        Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de,
        Jason@zx2c4.com, shuah@kernel.org
Subject: [PATCH v3 2/2] selftests/mm: verify droppable mappings cannot be locked
Date: Thu,  9 Apr 2026 16:49:15 -0700
Message-ID: <20260409234915.11723-3-anthony.yznaga@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260409234915.11723-1-anthony.yznaga@oracle.com>
References: <20260409234915.11723-1-anthony.yznaga@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_05,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604090220
X-Proofpoint-ORIG-GUID: 40N8NH5Crb0U29iL8DnzmZhoaGwOkPDW
X-Proofpoint-GUID: 40N8NH5Crb0U29iL8DnzmZhoaGwOkPDW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDIyMCBTYWx0ZWRfX50VGl0rnNXbZ
 1ftc33K+AymVbnhNtGYWP3ICw2pGO+V0Yoa4qjloVXzMyNZaafhmPFy1BH/mbKcawh4VD71RFaD
 gqW1foFGyuQjch3Itc1noKvKOECj38N+bXvRZ0vpD/KZ7KgSIUPugpP7x1O4Qr2b7H9D0yN0oAf
 xvmA8i/SbyxLVx+oOVuaSswdzkZBqMsp6a+9Yzv3HVrpaBjUZRGihF8ljxGGyezd5/mScbLHeEw
 YZ0wb30QJDYYowRoNazVtGEuUvy171no5ROLC79NGbTct6GaaXOm7DAlKt6gMaNuxi5XBOrJaNl
 YkpRbHMS3ziVclRPXvutf1M55fYwfKrbqlpizaoDedjC7WRHDapgsHDeVLomcxHbL9Hoadf/fBj
 riFMz6nQM+tcLldhPQNlvo73+oVlPfslzpun2zhcM5fMlUxYz3LOf2j+GvArqAZfywXKZfprNei
 VKuGHsVuYgPrW8cxTsKYqIeV2NBIjRzUKYRf+vpE=
X-Authority-Analysis: v=2.4 cv=NZXWEWD4 c=1 sm=1 tr=0 ts=69d83b03 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8 a=RvmZQwE64T_oa5h20bIA:9 cc=ntf
 awl=host:12291
X-Rspamd-Queue-Id: 997D84000E
X-Stat-Signature: skp39qdapcspitzanwkq9hdxk8tt1sub
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775778568-524309
X-HE-Meta: U2FsdGVkX1/owC+/MOqx3VPWatjvyqAMpTJ5wO30p4xGZUmdiKTzywU5iICuVAEcMxu6+O084Wno71dxq9HCvpyyOW/9KmCTSpavdvdrZPGzst6NuaX9nU67OzsaRXt9UXy3gSguqm60IBWk7qmpPy7S/GIjJkO0UzOsdA2PoLKbLXk/qM9tfrMKEWil/lr71w870iz4JJgP954cbk3ajRISNcN0mtTZNv33VEJFp+gkzQfjvtQI0/kccHWnEYFlMKWzVYWAQEqZrID/Lzy9oZZlKY0eY3Wf5wqLs6xLUwwXemIexCP5h86BRVyqq4GaiugNJ7hvCpTRlHXrN7Aa3ZbydqQ0HtQoaV1jnwcFNgIDr5O5P1+fwozlAfbhjafJQY9OhjWpDIQ76wl1BecMHDbXIEnfxHnoPI1Hc/dC1dqK4BHGCDuQZVPbGJZp3IWCrH0uYElZDTTNElzg82WLwaTQcINaDMM9n/DYLu3j5Yb1x0LvFdiNR2zC6lfH93NTbWhHhpte6hspW5Nccahk127kgf8lErJBXHmcST+Qb/z3dBXaO2MBnTrD3gnubl5ADbEj+zTX4vbifveIWXY2Fap3LoIoVIdqG7oSVmPM4o/zfLwaSbTWzy28whUnAzE47JgQdJtagVPBzOMjh0sZ27pGADnXndrCWgtX9yt9a0uQuyM1dAd5mIzWRDGMXfVs4iuwIPUtUeLvTS7CPVV5nLWS/OQP0z33tJ5S3Zf2v+mTgVYMMIZpUAZI24yLyiWmbShl0zVjtZihMTkrTECWj6ecm2ZkcVctuHVapiXYmQ6bIuUhf+cCJC8NicyeCwyRW7Z1tpIlYzSlsnfokG9jmTKzocXsrg5gNJgQMbvvmMgLmdNNuZ4+BNqR7REkaAFsbLVCZcCTMUylIqRzEUF12yXryC9rVizKgjVDubILUnXRXUDAK2fRSN03tzjMe0SgZTiCIvE1bjIYVrpcK+J
 SU1ElPnl
 y+e4cLxi+VDnS2drChlHtdo6CFX5hfrmK71F0qB0BrOz11ehi44gjzvb6HuyRoQ6Ds0fSUqAHDIv7u6X0cJO8DIzV24+JSu5fHJSojnkxb/zBc1WGELOwVk1hcKzn9ki0ITZNheJklTYTWiGpWiHoP3HS60xTVb1viL+kTNv/qB5lU/5837uejv885+ZqlyN5PqpuWxBR/D7TE1U86VdokqIow4May7SBdW4yZypdiV4nIDYk/5BSOFYGsoDVfS49AyJs0gVwZKiIC7A=
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
 tools/testing/selftests/mm/mlock2-tests.c | 100 ++++++++++++++++++++--
 1 file changed, 91 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/mm/mlock2-tests.c b/tools/testing/selftests/mm/mlock2-tests.c
index b474f2b20def..47da1a05c243 100644
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
 
@@ -336,9 +340,85 @@ static void test_munlockall1(void)
 		ksft_exit_fail_msg("munlockall() %s\n", strerror(errno));
 	}
 
-	ksft_test_result(!unlock_lock_check(map), "%s: No locked memory\n", __func__);
+	ksft_test_result(!unlock_lock_check(map, true), "%s: No locked memory\n", __func__);
+	munmap(map, 2 * page_size);
+}
+
+#ifdef MAP_DROPPABLE
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
+#else
+static void test_mlock_droppable(void)
+{
+	ksft_test_result_skip("%s: MAP_DROPPABLE not supported\n", __func__);
+}
+
+static void test_mlockall_future_droppable(void)
+{
+	ksft_test_result_skip("%s: MAP_DROPPABLE not supported\n", __func__);
+}
+#endif /* MAP_DROPPABLE */
 
 static void test_vma_management(bool call_mlock)
 {
@@ -442,7 +522,7 @@ int main(int argc, char **argv)
 
 	munmap(map, size);
 
-	ksft_set_plan(13);
+	ksft_set_plan(15);
 
 	test_mlock_lock();
 	test_mlock_onfault();
@@ -451,6 +531,8 @@ int main(int argc, char **argv)
 	test_lock_onfault_of_present();
 	test_vma_management(true);
 	test_mlockall();
+	test_mlock_droppable();
+	test_mlockall_future_droppable();
 
 	ksft_finished();
 }
-- 
2.47.3


