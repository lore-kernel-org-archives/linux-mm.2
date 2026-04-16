Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 436DFF433D9
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 03:40:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EFC66B008C; Wed, 15 Apr 2026 23:39:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B7756B0092; Wed, 15 Apr 2026 23:39:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77F806B0093; Wed, 15 Apr 2026 23:39:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66AFA6B008C
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 23:39:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 07FBA8AF07
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:39:58 +0000 (UTC)
X-FDA: 84663015276.03.8BE8948
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id C496DC0003
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:39:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="PM73/e+J";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf28.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776310796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U6fbpR9CDoyVurd/f9MPbrloEFchPIBsm3lgsFhp4b8=;
	b=b0FzZ7T4eT8VLNxVS9ZxMKpx5FsB/x80NPj91NPRC414UlN5tItDnoDfhzhwTT2OpzLlQR
	OQFtMzVjUdUqIstMD4tNa8Uomdqhd+g2AQvuZa2OZi+gqXVnkOebFGkdhlXAr8Qkt3L8um
	8yzYml7WDRpuT4SKcwsOl3OIakgtVyQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="PM73/e+J";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf28.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776310796; a=rsa-sha256;
	cv=none;
	b=TiFz6UImO7aLsPswwOoASTPZTs8098fOoC0yPZ6pT5NTyzweWhdQHuwpiO7WVtSuFHNjmI
	TUqyIBxzKsA0Oh3qfDDxdC4BWFWBIBCcwWagIy4A7ijSmiIFFR0CS4TGvFViAH7jR8mBz5
	zxMym2XQRq1u1ZdHLsOaerdoGivrqhk=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63FJMVTt1531147;
	Thu, 16 Apr 2026 03:39:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=U6fbp
	R9CDoyVurd/f9MPbrloEFchPIBsm3lgsFhp4b8=; b=PM73/e+JZKo7ie8chBWz6
	NgAEIm1yAJsKVE3VVbppOsLOu58hSTgu9JvjjMXFw025+oSvN+8HKl7gYGC2Ok3+
	jMEI5jx3obzBOoqIYW1gpJEWr+kBOYiZSe1YG4wn3TxWyNdha+TXCaMNB810S3KC
	d2xJLGb48y8qUStpzWdojXX5+tSINvbt3fS23XAvTUxvAnj+1GM3EjFea/wY3mzn
	N1gJK8fYQYdINT4ZnqcAx5XFokW1m0NA7Wy8xJRifVh9zRtNcnf6lWqYex1vJLmF
	+tur/+NEt1rLbz8dxPqqSSg1eHDhXMxy9R7R9Xnv68uf8MD7rdPKlUT1PRxEFLRI
	Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh85qppg8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Apr 2026 03:39:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63G3dXWJ022486;
	Thu, 16 Apr 2026 03:39:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7npq7nb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Apr 2026 03:39:48 +0000 (GMT)
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 63G3dgix023193;
	Thu, 16 Apr 2026 03:39:47 GMT
Received: from localhost.localdomain (ca-dev60.us.oracle.com [10.129.136.27])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4dh7npq7k1-4;
	Thu, 16 Apr 2026 03:39:47 +0000 (GMT)
From: Anthony Yznaga <anthony.yznaga@oracle.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
        Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de,
        Jason@zx2c4.com, shuah@kernel.org
Subject: [PATCH v4 3/3] selftests/mm: run the MAP_DROPPABLE selftest
Date: Wed, 15 Apr 2026 20:39:39 -0700
Message-ID: <20260416033939.49981-4-anthony.yznaga@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260416033939.49981-1-anthony.yznaga@oracle.com>
References: <20260416033939.49981-1-anthony.yznaga@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_01,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=973 bulkscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604070000 definitions=main-2604160031
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDAzMSBTYWx0ZWRfX2od9frh2jRWU
 7PhbDYEKsqCIYDP658JgAI+MeSaczQ9/z9LheVW3dW4OOqg4iIK/ZnGgYxkbZeWlcJelezeikX7
 45guNaQPOtrYRlwLKnbyCD/fokbzzMg7tYEmabc7v1RWkX0zDtUhZT4xNZhdgXGb/VUEgKGThb8
 +ALEFmFH3BgZm64dnV4f1rRVPQzXS98wth4Vzb3iyCmMNCdoFbzW+jENAp2czanC/9MNHk6ILI/
 s0C44/l5oZUrBXNlDvJLL7CXC1/AZnIqr+7DHo0QapIvZVQDFM+WPrLQiPGtLSgdLRyNlMY9oA1
 26YYAfa+NJq4TXzPMOArm4chNlLSEG9kPQBguLgK7YDoTqZ70O9r30jL0vMWPUD9DCbQVHA/jKx
 BhsnUcY85l7jdpNAFsEBLiyhUJcnB+w1QWKt1Y9DxqLcfXLpZOnqkPbj6ebT2KyDhTSz6UulvdT
 aIz3V9oKquEAzVlvTSpYDTVRB92E9RbgZoa5itfg=
X-Authority-Analysis: v=2.4 cv=Lo6iDHdc c=1 sm=1 tr=0 ts=69e05a05 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yPCof4ZbAAAA:8 a=HQNw1OOOmXzmZ2LHhSgA:9 cc=ntf
 awl=host:12291
X-Proofpoint-GUID: yBpgBB91JwOy9-qq_rjPgMvFHfvO5krH
X-Proofpoint-ORIG-GUID: yBpgBB91JwOy9-qq_rjPgMvFHfvO5krH
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C496DC0003
X-Stat-Signature: xh6c7uaswcier76mgq48qwqa4ecoet68
X-HE-Tag: 1776310795-79444
X-HE-Meta: U2FsdGVkX197VUVNlnRhnh5LE1ZrBU6J8K2Re9h0cjpWQ3/kbvsFbjd+ghH9Q6nHOZ3/wfYe7R8zrIoexPnOUCVCvE3SiSjtutkUgDQK5nqf+P33QuLDLBsA2sfImyt0IwAHzLaUu4WV4qMWR7KU1aqIL51RoUca8yRWQZFobQzhop3s8EG9g33ValKaJk+1XKBN2UylDF0UZjkGNap1VjBE9kbcaDlSgJmQPPKYu3CKVld6OFtRfHOofdZ4BjV0TUN600rzi2+3EW2fatakvjzEG5YhtqCzV3T2ilF80fS7VKR45rs9xW6TOmWB/0l3z/TC1EYS9aNjcEnH6YRsPJTU4nAjHEjhyDFUFm3XSHgAXGI0tLgT37TyGPq6s+vxrqTkRPmGsJBsOD2ughrEKB5Woq9CyAsu2l7U/RLh156EmEA/aB7fWPDyjPH1RZCEg3dVCqaEI4hMNHdj0sd3mPT5SnK5BSGGa6Km9GySsZ3GXun928j1PvKtoQ4ZXg36g3ytlM2A9WacUd5+XpKqUKIYiWzYhPWBHlSpBsvn/avSDk5/UBv79o337BeCxEIfrVEnIsvwReDYHyGlZexNut3HRCNqRJ6p6hdBK1VHJbvI/b7NhvOr7xoJgdf4ZNDRNiKjwO8bFF14sCTtOgSTC9MoB6YPbcfly6PHlyqqAwJXhniyFwi3nbJezqoVZU0xTVzSZj51s878+K2tKjNoIrINNk5+TapeCUyTbTBcdMtXEvvStlpVfG/2yKkwMl349JBM2KgQPFqjPIu6LnWAh7QnIamQ0rdCDKl6KXC04azv6oyhUPuhJVhZwrK6gQI0/ztK89JemJwgmbkgjjc/v2omKP3eNLdEzrxcr/77evGt+mMCN7VvRb/9u8i+q6sb6jFxgGuhQoJw3bkpm3vbEEmzKRJQw0AeTfD/7JfGP+OwRKNJeHLmm8s5p5ZkFM62ymNw4pisNR+5aGgBEuk
 nTRbjYyo
 yciWErqXR7BUoUwrNzak10sBp2F12z1C0q9wjkVCwL7uA9r6wgr0p9QhlORAer1v09xNH34s+ABjYy7ejDF9W0oGzOIRNYdXzKdF2pQCOm0KzFPZfmmpw4qNOSmeIgRzylnzjVVljkCZB74xARYB6LXqBEGd/WJT9iSMcCzgF09ZHCpzXr47aWSIyHUyqjYp1odId/fKrxph0d4HyyrYUsaQe6xhfS1yIjmj0h6Csp6mXm5lm20jF4nmYf7m2rHCHW+NckNW2A08/fPILcWB3vIMrG5wkYoX7YnK+2F7++DShKQb+jqQJGenstFvx/1Mjeaox
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The test was not being run by the selftest framework so it was never
noticed that it would fail with an assertion failure on configs without
support for MAP_DROPPABLE. Update the test so that it is skipped instead
when MAP_DROPPABLE is not supported, and add it to the mmap category so
that the test is run by the framework.

Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
---
 tools/testing/selftests/mm/droppable.c    | 9 ++++++++-
 tools/testing/selftests/mm/run_vmtests.sh | 1 +
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/droppable.c b/tools/testing/selftests/mm/droppable.c
index 44940f75c461..30c8be37fcb9 100644
--- a/tools/testing/selftests/mm/droppable.c
+++ b/tools/testing/selftests/mm/droppable.c
@@ -26,7 +26,14 @@ int main(int argc, char *argv[])
 	ksft_set_plan(1);
 
 	alloc = mmap(0, alloc_size, PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_DROPPABLE, -1, 0);
-	assert(alloc != MAP_FAILED);
+	if (alloc == MAP_FAILED) {
+		if ((errno == EOPNOTSUPP) || (errno == EINVAL)) {
+			ksft_test_result_skip("MAP_DROPPABLE not supported\n");
+			exit(KSFT_SKIP);
+		}
+		ksft_test_result_fail("mmap error: %s\n", strerror(errno));
+		exit(KSFT_FAIL);
+	}
 	memset(alloc, 'A', alloc_size);
 	for (size_t i = 0; i < alloc_size; i += page_size)
 		assert(*(uint8_t *)(alloc + i));
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index d8468451b3a3..e1e355d50e65 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -382,6 +382,7 @@ else
 fi
 
 CATEGORY="mmap" run_test ./map_populate
+CATEGORY="mmap" run_test ./droppable
 
 CATEGORY="mlock" run_test ./mlock-random-test
 
-- 
2.47.3


