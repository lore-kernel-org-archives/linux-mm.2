Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A7F9EB107C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 15:58:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 769156B00A0; Tue, 10 Mar 2026 11:58:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 740626B00A1; Tue, 10 Mar 2026 11:58:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 618AA6B00A3; Tue, 10 Mar 2026 11:58:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4F71A6B00A0
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:58:38 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E22E51A0241
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 15:58:37 +0000 (UTC)
X-FDA: 84530611074.05.5F7B66D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id A51A9180017
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 15:58:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UzaWdN9I;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf06.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773158315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KILNHPFhZkB/epKpICgOxbnFyklyzYF7FlY8WQTGTpo=;
	b=1jhK3uqD6jbsDSDCNo+VTzWvZZAnlYAYwlZH57wQYoQdf+Mx3eQuzeKyh6vlZgbRQwgdbx
	RGPk8+4nlju2Ye6I5pSQD6GnGl7Dsh/1csfwf8n1foWXTlKzTirBqqaFxjgyBjvTFPCQTJ
	5pyh5t56zrSMgdWA8Ao+sdKKjV8l2eU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UzaWdN9I;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf06.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773158315; a=rsa-sha256;
	cv=none;
	b=W0B4Af5HvjDSSmOZZRLDsg+86lX464hsj+CH14Wq6gXyXM34+4vKynvasslwByFT2f9QYr
	1SGAFSA0L4zlRUJXpCA/3DM4piJ00/MS8n9MR+EZfQQq6HPrSHMqb5zL/eMgfVp8GgWG/l
	PvUP0bbsKFcUVqDyyogBsIApGG0o1cs=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A9ovME1719663;
	Tue, 10 Mar 2026 15:58:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=KILNH
	PFhZkB/epKpICgOxbnFyklyzYF7FlY8WQTGTpo=; b=UzaWdN9I7qC4DIwxgIPFi
	iQmIVD+655Hl3pkyB6uKXxQxInsunyLlBQGBBx8Kpagek8bm6a5z1P5QKD4lA/HE
	E24rLIIS21o6Jsr2nK2Ek/4cW0oGng65qcEkPHkPPtIMOx1/PvR+u2aZLQZV1f/M
	hofmxX25UpouCzjVG8fDpsRQZA3LdZZOryE+3CnWY6/4UNF2Afz+T8LdE7siWjce
	LMvfW3l7ZFJIMjkoJga42MaJt4/N2Gdvv05SZjNp/heTE5Q5dZQkCbW3cizf5D3S
	n55c4E6uGdWT2MpTh/SKJG8annbmODnaEgm5quizhW0F0oGcxHYX9yAeT2GmQjuL
	g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cskyp350q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 15:58:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62AF4TLE022760;
	Tue, 10 Mar 2026 15:58:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4crafa9wyb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 15:58:29 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62AFwRjE027022;
	Tue, 10 Mar 2026 15:58:29 GMT
Received: from localhost.localdomain (ca-dev60.us.oracle.com [10.129.136.27])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4crafa9wu5-2;
	Tue, 10 Mar 2026 15:58:29 +0000
From: Anthony Yznaga <anthony.yznaga@oracle.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
        Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de,
        Jason@zx2c4.com, shuah@kernel.org
Subject: [PATCH v2 2/2] selftests/mm: verify droppable mappings cannot be locked
Date: Tue, 10 Mar 2026 08:58:21 -0700
Message-ID: <20260310155821.17869-2-anthony.yznaga@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260310155821.17869-1-anthony.yznaga@oracle.com>
References: <20260310155821.17869-1-anthony.yznaga@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_03,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603100139
X-Proofpoint-GUID: oyz9zc_Zust4hy0UWhisJ0Qjfd6uCtps
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDEzOSBTYWx0ZWRfX1iBG67dp9wN/
 Ll2TaXxKxOMgKFyRkxcea61Fo4AB9u85VHcLtsNfVSQtXTTxfGXMmGYlMB6naxLdPzKuHzU5lcD
 P1d/KPiQ/KdiXdHCMRxSer8jrybEWmzeHnzMzd8gYBhrNxxwrkUCK3Fv6DB+IqIFYH2mytfE/pO
 Wy2WF2jCmPvM4+HrK8korvzyS6BTyIQLbx33lbUeopILSIpOlr5BfH+IB0VeJurE7hN65eePYXd
 ZPt9Kr2R/3ALFWgx9Ee3aNsvk5QdmU1dQFgsEsLs5arUT9ITO46LJRNEXEyKZF0fY8qFX3n7dgb
 7g0LmT2Y4q654d01AwkpN4O2d4oYGNzhYRNno9bZJ6JmicUob2X9ayFM7F6+YeD4z0GsoMPB4K3
 BUJXwNKFMTIlKtqOytdsfthuz4pV+Y4VU57LVazHPQavIQrOkaatMiml6xW1VAmEV4UhTTvEIHj
 6/BsvTh+D3VP4ZD4vXg==
X-Proofpoint-ORIG-GUID: oyz9zc_Zust4hy0UWhisJ0Qjfd6uCtps
X-Authority-Analysis: v=2.4 cv=XP89iAhE c=1 sm=1 tr=0 ts=69b03fa6 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=_qCjRXgy2aYRKG6zBr8A:9
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A51A9180017
X-Stat-Signature: 77pcjgk3df9dxrp5nhp1hhifit41f917
X-Rspam-User: 
X-HE-Tag: 1773158315-458096
X-HE-Meta: U2FsdGVkX1+TwAeXhXC/vWfavTXzPONrFDv1ZpkpAUEstO3e0vF+rIpPREePLC/1TdwmXVYSaxhxJ2pOQDcZkn76O0ZRUXMpt7CdosVtoIMO6ZjbslmmhKKkJIzjMnlDEk3XYWHR/ihotYKCNN/mJDHWIYKp1+bGH/1kavjxRc3yANa25raOLZ1/bXaBtdk7TR0b++WgADesV+C/5J0ap+7KA6IFIPJYOL0+e3z36BG10FnJKPXWEg4fkiO/VKf7ABOkp+lNHhscVRVNUdvO46E+9D4vLzAc/gUkoMD9zU9zCM+xeLC3gBEyfjfKSzRSt1XC9yBy/8pZ/FrrhPKNDQOiyTWeHUPI3MRifOjFdxhPOKjtgIUk37We1vGyAmPLaz9ZkrYQGpUI0slxkReoRM6sZBqtmL2hxeb0mnF3TNGVvZunp/VYf3wB3/37lmYGNlcWqZLkKhZHJ27HeJbk4c80wpQClBByQFp2ZbwlrJ33j41EQKxi4SmGb0qkkHsJ/Tb8YKPlz1/ogBG7YYsT5eEqq7POD3Qzd2FYzbZwLDDVRvYGNwYpfsXA6gZq85xLvMy4wSqtgZ1Kxh2oLhpcAePPV6A7/qczm4gYWSFpLkmm/uuaBwiVwbVj7KK5zlYHSxqvEzrXDotZJjEhqPmpDhmVMPCz2PIyxdjweTt2JnAitpCpGw5uD70tYM5Bujoz9i7sxYfwsH+DahmNNutTkHYvp/BG8CKSFCrCR7WGZWkXuX8Xgu2pRg7hhl04bBLYumy/v5Fq2akasisNveKq4/I9nU0JSMqn2p6xbJxHBZzPyewoaS14ANHfsfrhVs2+GHgmnSJzRORUMtmIxBGLyrq5RRlRmHwmk5Kcjv2FW4Zz3utLanO0wd9heVPyX88PqJpE+2bA2GOYIv+e9Gp2PEMdeqlJNM+TzzPqwLJqMS6cSuNTM2xGglZ3M8LBw9QQm5Q0U+HS6DXirDdz1cA
 B/CHLkta
 yK1UMWTK0UqDZMxJXYeUqZRvXdNy1loB8+XQRWPqFPI6FUmJSEfhLwws1yJIaN2Xp00fq1fZ+Tc4YjLfAxYTUJwjHyKi9hOzqli0MuJ3eoTH1q+UNV56Fjh7Esgg31iBXzojJtXBWW19Ruck4+uKj68wGqhrbDuBdm2WocF8Y8jEzZoZxVt7IQbEK8FNj/ofOl55dctzHyso1zkAkCrSyfINFpLsSC/g5GkpmaGmdjaNvH10=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Verify that a mapping created with MAP_DROPPABLE cannot be locked
via mlock(), and that it will not be locked if it's created after
mlockall(MCL_FUTURE).

Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
---
 tools/testing/selftests/mm/mlock2-tests.c | 78 ++++++++++++++++++++---
 1 file changed, 69 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/mm/mlock2-tests.c b/tools/testing/selftests/mm/mlock2-tests.c
index b474f2b20def..b5790e717dd6 100644
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
 
@@ -336,7 +340,61 @@ static void test_munlockall1(void)
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
+	if (mlockall(MCL_CURRENT))
+		ksft_exit_fail_msg("mlockall(MCL_CURRENT): %s\n", strerror(errno));
+	if (munlockall())
+		ksft_exit_fail_msg("munlockall() %s\n", strerror(errno));
+
+	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANONYMOUS | MAP_DROPPABLE, -1, 0);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap error: %s", strerror(errno));
+
+	if (mlock2_(map, 2 * page_size, 0)) {
+		munmap(map, 2 * page_size);
+		ksft_exit_fail_msg("mlock2(0): %s\n", strerror(errno));
+	}
+
+	ksft_test_result(!unlock_lock_check(map, false), "%s: droppable memory not locked\n",
+			__func__);
+
+	munmap(map, 2 * page_size);
+}
+
+static void test_mlockall_future_droppable(void)
+{
+	char *map;
+	unsigned long page_size = getpagesize();
+
+	if (mlockall(MCL_CURRENT | MCL_FUTURE))
+		ksft_exit_fail_msg("mlockall(MCL_CURRENT | MCL_FUTURE): %s\n", strerror(errno));
+
+	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANONYMOUS | MAP_DROPPABLE, -1, 0);
+
+	ksft_test_result(!unlock_lock_check(map, false), "%s: droppable memory not locked\n",
+			__func__);
+
+	if (munlockall()) {
+		munmap(map, 2 * page_size);
+		ksft_exit_fail_msg("munlockall() %s\n", strerror(errno));
+	}
+
 	munmap(map, 2 * page_size);
 }
 
@@ -442,7 +500,7 @@ int main(int argc, char **argv)
 
 	munmap(map, size);
 
-	ksft_set_plan(13);
+	ksft_set_plan(15);
 
 	test_mlock_lock();
 	test_mlock_onfault();
@@ -451,6 +509,8 @@ int main(int argc, char **argv)
 	test_lock_onfault_of_present();
 	test_vma_management(true);
 	test_mlockall();
+	test_mlock_droppable();
+	test_mlockall_future_droppable();
 
 	ksft_finished();
 }
-- 
2.47.3


