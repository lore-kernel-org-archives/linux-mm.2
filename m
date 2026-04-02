Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63785111224B
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 00:34:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAF756B008A; Wed,  1 Apr 2026 20:34:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A38FD6B008C; Wed,  1 Apr 2026 20:34:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 912326B0092; Wed,  1 Apr 2026 20:34:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5EE706B008A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 20:34:30 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 22048E04DA
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:34:30 +0000 (UTC)
X-FDA: 84611744700.15.ED629E1
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id DBC69180003
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:34:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lVxwTYd5;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf06.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775090068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Me0BpJOlB7O0BrueD43DcxauGjQY/pO0ZdxEUpg3QAw=;
	b=YvDOgZ0KkjoO9pRHbU2GisKG9eP1LXcZ+7PRFkmiTN7O1QOeDpZAxfnouk2NZXs9HhSsz5
	fcKV9jmDWhpNRhO1p4IbmZIHrD1ez5WCYUHsB2wcRdFjsIJG5Qxbq+cA7oXgRIbkQLlGTy
	hAqwME4GM+aeCJH3SaUGrGdX2PgFMVg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775090068; a=rsa-sha256;
	cv=none;
	b=CemT/9nSWlMkd1zxDi5FrSsaZ65OBdVIv8DaDFKk5tMZ4VUQFLdObM+Vtn07CpnZzEx/1a
	bHhmVMgyqpIBJ22QG8hYwru0lXxmgOjWhHLj3ev1v5lf0F1lpHI/+JUeFjt5ptAb4GCYkA
	7pMnxUQfacdRgPREMo2iA4uvrIDzzpA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lVxwTYd5;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf06.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 631LEB8E3541794;
	Thu, 2 Apr 2026 00:34:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=Me0Bp
	JOlB7O0BrueD43DcxauGjQY/pO0ZdxEUpg3QAw=; b=lVxwTYd5qchdIVlferPYm
	cpO58gKou6Z48o6dDYudb/oFUC/fjcGxwJ1gJJP7DghpOzMkBRI0mpiN0rtvpnCL
	xTYjCnpNH0T8uKz/YWta9MbFizlW9hmLaHKtyzOER21ckYq6IqScXth4CRal4bLm
	FNJpSgBvojk1CTJ4/1GMjpWOXDyvD8pXfnKdTX+0p7Q3Z8tv8UP0+YEx3WUQCkVX
	8Q87nwJWTdszfjc3q8+1M3imWnPdTWcResIHIRQ3wZFNn0kGkNXG6JJr1hzWycHv
	+HYt8+ZhkDpA7BnjlXA6toBvC/KK4cxLYrEtnSth1ROktYXkAwsG1PUtsqadvNWe
	Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d65jwfkrk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Apr 2026 00:34:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 631NLOHt025930;
	Thu, 2 Apr 2026 00:34:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d65ec2236-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Apr 2026 00:34:22 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 6320YJ7g001596;
	Thu, 2 Apr 2026 00:34:21 GMT
Received: from localhost.localdomain (ca-dev60.us.oracle.com [10.129.136.27])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4d65ec221n-3;
	Thu, 02 Apr 2026 00:34:21 +0000
From: Anthony Yznaga <anthony.yznaga@oracle.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
        Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de,
        Jason@zx2c4.com, shuah@kernel.org
Subject: [PATCH 2/2] selftests/mm: verify droppable mappings cannot be locked
Date: Wed,  1 Apr 2026 17:34:17 -0700
Message-ID: <20260402003417.438037-3-anthony.yznaga@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260402003417.438037-1-anthony.yznaga@oracle.com>
References: <20260402003417.438037-1-anthony.yznaga@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-01_05,2026-04-01_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2604020003
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAyMDAwMyBTYWx0ZWRfXzmBo9cHKpg4r
 MvbNBRyjylwVFShn0iDCX/AEGf1i+gOu9ziWm+ViW8I6oiG1evprwHnGb75d1DwF+ZzmitWWJdi
 7Zii/5QMi1olp1aLlWqmuuyTCrbyrs49v1IXNvg7RH1EgQVQ15jSszLRmpas6Ae2z8gQ/+Q5YS+
 akkxlarB0fmHIa+G1YnfDes6/H0NpZzhsiv2pk3hK8KGR3eOMKYHUfhJioTM1njfTGGo62U5qyK
 JTqD/lalM40Has7UpIzMR71m21mHOAVTcUeUdMTh+rkNTjyZRZIrw5gIr+Yihh8JdYbDwdjBsyB
 RCn+h7Cg46DPFCX+H4xkh99wg1TXoAyLnpivTSNNf/+F+HFfsrn0/s3p1jkHUQHPyFdsU+747I3
 aV8k0LUmFyAvc294Ti8qhh/g1BkIMriaxd4If8m+QuvjpNGYAZJk/E3ZMBiqfTY38XyLfmeqPOG
 gEhWw1z4c6S1/jhhWbw==
X-Authority-Analysis: v=2.4 cv=CJEnnBrD c=1 sm=1 tr=0 ts=69cdb98f b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=_qCjRXgy2aYRKG6zBr8A:9
X-Proofpoint-ORIG-GUID: o1k3CGPI2nIAo32t0s9A_thexrj4u8Bs
X-Proofpoint-GUID: o1k3CGPI2nIAo32t0s9A_thexrj4u8Bs
X-Rspamd-Queue-Id: DBC69180003
X-Stat-Signature: bcdyontd9azwnchybt7pzx6hpgeawchg
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775090067-572439
X-HE-Meta: U2FsdGVkX18eoDfDrKHwppQ4Wyt0ItKrDWuTxdcZDRgFQsAbWUFW8gntlBM00hrGytFfBM4LgRkg7luc7wMs033QAOBMegWE/46928mI+qRCAXNQQw9wGEENcfnlncfF6flBndJ7yudk/2HaGOVNq2QN9VeXFvLC16fuEK624Wg1QIqrknI2o8KvhWo8+FxCtEv5IFd+Cugnw6oJtl/Ow+/ajNbKxM0v5afnVMPVI6AKNS1nDNzFiJGkxWu8C/j/m/oV6s6qbc1dEtBV3ZaJh6McqA7198R+iL4OiM6AquLjxfQTYJ/mHAt9yhsVM+l+yqUq59Ip0DeIREevUY4kGEEqZy6zt8GdrU6UVEQKYTIO+ohtDlpt7zUZT6pPNSUhNsvqFeGdvGkaLE/opZSp9+o/uzYybQJ7iw9xwCQSO5Bd6l6THGcQlgaN7hSnGbQDd3flGmgreGxPpWLEaNzguk040dFb8Zs8eSh9X/Zt2V5vd7huuZU/EStIWCUNKBl1u9DCVNarW/aM/zeg8yfX4KHcS0N94bh565JHosJ/sT5j0gusBlj0+Cfil4pTSR1azZDrHso+qw/a60DSYkYwvIQI4qU8Ww9v+KEbshv6GIy6pSPA3tzOf8RnT/K4Gtad/ngyxnycJCteh2NLvfancsbiE8rsolb+4n2yo4TT8sqZgZjYZH1bvQpSfrgMNOcgw2J0aKCaHIAAUigbp75q6TEvMoUqq6AO6oddBmbxlKQpRZ9UFywQ5nTvO7AW9e6qjDbXOQ1i/hgA6LvwvLXc4tMh0cviXpi89nzqNYsS48/8OAok2S5yQseKzO2shpDeFCX1HFzuXD649I3268CvcLSyxi/62mwiycuVUrcoZuFH3i926vPaOVnXNuIzB6sOjnK51syCCfJSq0hhEBPfZJh1PwjgAtV9xlQRTi+Vntxsi/MUbkwmm4VGCFr7fEDs3YzgINZ8sAWjNu7kGJP
 vNT813uy
 rz69VK21r4zgtJHU6x/09o9v6S86h1lYbj3KXNm1ijfW7dPcPlIodGPX2MFSWj4WZMC/IGW1Cw/P65OS+x4MUAzrNPs4l/7cPxetmqpL0dnob9otMG4QnOxzI6LSXelPadfA/1BdUDQtiDeZfSEOWaEZpJCkA3Vtkw0GWJT0MY195wkr+crGi2+jhbWwc1hQ9KsCNuhS1nF9hOTiWGJMVeFLTEY0be4QVl6rDqy+hMKK/g4DCqSF7HHHcs3fvsFaTgpqEqesXTDCNhu4=
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
 tools/testing/selftests/mm/mlock2-tests.c | 91 ++++++++++++++++++++---
 1 file changed, 82 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/mm/mlock2-tests.c b/tools/testing/selftests/mm/mlock2-tests.c
index b474f2b20def..2750a3d6e8e4 100644
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
 
@@ -336,7 +340,74 @@ static void test_munlockall1(void)
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
+	if (map == MAP_FAILED) {
+		if (errno == EOPNOTSUPP) {
+			ksft_test_result_skip("%s: MAP_DROPPABLE not supported\n", __func__);
+			return;
+		}
+		ksft_exit_fail_msg("mmap error: %s\n", strerror(errno));
+	}
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
+	if (map == MAP_FAILED) {
+		if (errno == EOPNOTSUPP) {
+			ksft_test_result_skip("%s: MAP_DROPPABLE not supported\n", __func__);
+			return;
+		}
+		ksft_exit_fail_msg("mmap error: %s\n", strerror(errno));
+	}
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
 
@@ -442,7 +513,7 @@ int main(int argc, char **argv)
 
 	munmap(map, size);
 
-	ksft_set_plan(13);
+	ksft_set_plan(15);
 
 	test_mlock_lock();
 	test_mlock_onfault();
@@ -451,6 +522,8 @@ int main(int argc, char **argv)
 	test_lock_onfault_of_present();
 	test_vma_management(true);
 	test_mlockall();
+	test_mlock_droppable();
+	test_mlockall_future_droppable();
 
 	ksft_finished();
 }
-- 
2.47.3


