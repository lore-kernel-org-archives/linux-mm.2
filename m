Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAF8EC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 06:59:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83E0A6B008C; Wed,  8 Jul 2026 02:59:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C8A46B0092; Wed,  8 Jul 2026 02:59:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 640D56B0093; Wed,  8 Jul 2026 02:59:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 282FF6B008C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 02:59:40 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 96744169045
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 06:59:39 +0000 (UTC)
X-FDA: 84964708878.21.1A22CB7
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3CB0FC0006
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 06:59:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=dkuEZmhT;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf28.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783493977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TsZVxA7BjJ3emCSF8jcHeodL8J9hqmMJ403jQnMFE4Y=;
	b=t0vkiJNL8B/0WA9D3xOeIK6iVUU+Sm3P1bs0hvG2l382BgfegmEHDrjzVpXdTXgiEqvAAT
	4c96Xf3VDqEh6JCpoPqizp2lUJCHJ4tpiDlsIueeCLXue2jA6fkRxquZMJbVeEmJzRkDvE
	9KFSP+E6hb8v6aftWEqp9cslsonn+/M=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=dkuEZmhT;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf28.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783493977;
	b=D7oMZsxEGMQmGK3OdbX53oVN9p4h/38xhM8/BudCRJy9BMSLFB5GEZphYaFG/P+uaiLoFs
	OnwJMYN9YkFjGGGu5O0tNeKysznt7imQrNJGkloL8JdNKas65XGUZvgZYBniIG2nTj5UvG
	gdTFIedaJKKtOM407l2JprQvHQLe7qY=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 667MmjCZ820438;
	Wed, 8 Jul 2026 06:59:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=TsZVxA7BjJ3emCSF8
	jcHeodL8J9hqmMJ403jQnMFE4Y=; b=dkuEZmhTVIBPbCgXa4GNAYqVlZwt1h25J
	/eZvOrNPhxjTIWUDTd+Ubk6zEchmtT4spSbomg4Y3YmSa5QpbEdpe4BV8UeEphCN
	6gg8va9WykMSo29E4Mg9GHQks3Kq2UOtZ0yYtzlQoL4hk3MBb3XS7gb9MzYJvBvp
	ZK5oGzIQsIs43/NfFm+s0A3C6JNF9JSQP4aFo3ymdX6gDhL0H8JCBKwpPyw97JGJ
	988zrKKeSx+gY7wRdjKY5zKsaEbi7TXKNArcIbsJrX8wnbL16gOy3SIVlctAzGQJ
	6kzJJouylOOENwC1zKcpTLmVL/XjiLJlfUXMgUFheCZoTyfmmbEnw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4f6sw4u3kq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jul 2026 06:59:23 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6686nh1a003930;
	Wed, 8 Jul 2026 06:59:22 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4f7eqg6786-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jul 2026 06:59:22 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6686xIKI30606014
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Jul 2026 06:59:18 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 79EFB2004B;
	Wed,  8 Jul 2026 06:59:18 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ACFBA20043;
	Wed,  8 Jul 2026 06:59:14 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Jul 2026 06:59:14 +0000 (GMT)
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
Subject: [PATCH v3 1/3] selftests/mm: handle EINVAL when configuring gigantic hugepages
Date: Wed,  8 Jul 2026 12:29:05 +0530
Message-ID: <2e3b585cbb30b2fc495dcd49d75de6f6da61861c.1783446924.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1783446924.git.sayalip@linux.ibm.com>
References: <cover.1783446924.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: ioicNcoU_7qVXelEbhiWeOPRPalrLy6A
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDA2MyBTYWx0ZWRfX8b0dPl/ZlKPk
 P17jlU4zkouRIxlLlCDFIMuvHVdE/I9JM3e8kYbdU+rDWfNSaOSgrmeBSiu0tqF27VhU/sbuAOJ
 b+KkxDQtokpkYs1S4UWsus+ZVDAOx11QF7of8Z1P/JpD5rHDfNA7K/1KfyRxaGzps9QK1Eql6Jo
 uk6E+WJ4Ndm7A/QtNEWLyZft2/VwOuu+chYPs0osTCjfxxMl2LRjxdr2/BXKvBi88aqMBMAUgyt
 hv0IcO9NXzIRuQHWu2d/lgURnJjH9sVt8+/6htXk5u9JYcXSrL45e6m1/MPRpFxqwfB9bNTSOj9
 PqMQzK5KVdOZpzc3bpz2PSh0c+siF/ilQpl5qUPathRNwgqT1CySYOIFNjRi8abvlHpXMxa6wCZ
 sRj6kzHJ3A6db/uxxQwDHHGjNnrR2DdpSEIgf3Q+/dmBJi57wZcLd0C6q0cUsbdYMXTkn/IZNVl
 A1Mfq/uU1UVskXNvSAw==
X-Proofpoint-ORIG-GUID: 49F5ztNCHHM6IidBwiFDF6EODmsos4U4
X-Authority-Analysis: v=2.4 cv=FqQ1OWrq c=1 sm=1 tr=0 ts=6a4df54b cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=PxWHJGSCjing4dSroFoA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDA2MyBTYWx0ZWRfX0iM9bqS9iCw8
 sFB+RMAXD4CGQKfmOqyU+2X/BjqW85s3yjFMZFIUpFAavvpM2IOuT0yP87AmBOIdRXoTcpmSna0
 hwJV9h8nkw2weXAVb4UWgspEuvzuD9Y=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_06,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607080063
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3CB0FC0006
X-Stat-Signature: txs1d6bdheyjdyswaw8yf7na5tk88wm9
X-HE-Tag: 1783493977-502956
X-HE-Meta: U2FsdGVkX1/RmSB0kRodnOqHgeiDB9bQ/QxsnEgG9+F5SIgUHq0LwCisMiVt6580vlHA7L4aLdiTunstTZE/emDCzlfuqgr+qrFvtNEQpmjMWKKmMCU+Wi2StI0Z7hm/keBDkzIulT+FAziZR4yTqX+ScSJf6ufufCp7qYUgsaFo/6C4DR+KnzG0No7L1y24iYm1ckRnxNpMZlUu29ndzMt0NidfgqOksOnbWKe7m3FFHfl0mX3ORRtSOLs2msc/bTbAfVCpsOXqFWKtQsIPl+6WFxBpVH84Xz2NwEN2FiHq9co8YwyOtyqiUlrF8i5LpJjUwg6VxAtJvOUi/28oDxpFCfwwy3MtFe0ddRwqGuG36iqDjqkxbQAHMIikzg2hQ5z7dBC/2TDn47BXLecmA9jptufzHVmL6nnfkgSz4ay8iF2xy7AYyKamdewnIW/OJCUN8tJwWD72N+3ZGZWpVyN11cQJqlpRa4vYh5jWUgfySxfF+lkzlRmyJi5Tj6nsaT/vt5CC9HGd3rqE+d2UxES91wWn2QPokd+5xfIULhBaZ3MZhl3XJb5SvLf6GBQEDZ+U6hMCVhhbV6FZLXj7dip07rOFKt5c/58TFkibXmodGKNzhxhC5wYk2QfcR1od+22UV4wW1K0mZRkphgpp3l6w9hUrnt6deWWg3IXdu+si6BImovCFyRVU0NgLjYIZvaS924j8rjY0n97jCx9/yUvXyOmvLC6cArQGzqrcK1gICfrCw2RNz008gs5s2v7sOWjP/uYkDe+WoeNRbE/BIkEi4K2zjT6IuSQaJBduS+M7a/pQDppWgU3etkfRjKd0GEiyQul1XVREW3NhNYZy/2rW8+bUYE5B+CZtv9V5L28GhUtTiXsXjXHa2y6JzYKKat+ue7PYytBn9x7EU9Dk17jaeIWI0vLfdKw75egqR5KcILv9YGgxOsyrzdfwTQOXRmPJ83dYwwiQJj/HN+y
 aObYOddk
 LP/fugGidPlWdRzlpT8rKoJL6kKxl/Rd+JcY2HiomiTksyZjjKxOwXgtGXK///NanbBz3TZHJt75eXhWALjcxlCofh1QdNAQb/h7xXp3UGSPiMMbSidO4zeshmisKXd8q3HCvt9dTSdEd61YQnkwO1oOEohkC9QHOiyU/aLm0SROZoEX7tFfGcvlvgEQnHuJWaQ0oNOZyg9+GRLKsmtys7VuwG5+aTLU7wJqDgxMcPE4EmKuBWvs0yFaegFMDEBC4+bPIZqb+RQuqifhupr07Nq4Tl2OqFzlNC/yktkriZHVxNG5b8PYSDacrzVWWrOEssMv/Z6LCLBkTLCIrq+FPoSLggDtOvtBFJSyYJv10gc4v4BstsVHPGe9nZeG37WJL0mX96MEy/fEZw2w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some MM selftests attempt to configure the amount of
HugeTLB pages of different sizes by writing to nr_hugepages.

PowerPC hash MMU pSeries systems advertise gigantic hugepage sizes
but do not support runtime allocation of such pages, writes
to the corresponding nr_hugepages file fail with -EINVAL.
This causes the test to bail out even though the failure is due
to a platform limitation rather than the
functionality being tested.

Ignore -EINVAL when configuring nr_hugepages so that tests continue to
run on systems where gigantic hugepage allocation is unsupported.

Before patch:
   -------------------------
   running ./hugetlb-madvise
   -------------------------
   TAP version 13
   1..1
     [INFO] detected hugetlb page size: 16777216 KiB
     [INFO] detected hugetlb page size: 16384 KiB
    ok 1 MADV_DONTNEED and MADV_REMOVE on hugetlb
    Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
    Bail out! /sys/kernel/mm/hugepages/hugepages-16777216kB/nr_hugepages
    write(0) failed: Invalid argument
    Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
    [FAIL]

After patch:
   -------------------------
   running ./hugetlb-madvise
   -------------------------
   TAP version 13
   1..1
    [INFO] detected hugetlb page size: 16777216 KiB
    [INFO] detected hugetlb page size: 16384 KiB
   ok 1 MADV_DONTNEED and MADV_REMOVE on hugetlb
   Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
   [PASS]

Fixes: 27477b28b74f ("selftests/mm: hugepage_settings: add APIs to get and set nr_hugepages")
Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 .../testing/selftests/mm/hugepage_settings.c  |  2 +-
 tools/testing/selftests/mm/vm_util.c          | 26 ++++++++++++++++---
 tools/testing/selftests/mm/vm_util.h          |  1 +
 3 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
index 2eab2110ac6a..d7917dce3aba 100644
--- a/tools/testing/selftests/mm/hugepage_settings.c
+++ b/tools/testing/selftests/mm/hugepage_settings.c
@@ -437,7 +437,7 @@ void hugetlb_set_nr_pages(unsigned long size, unsigned long nr)
 
 	hugetlb_sysfs_path(path, sizeof(path), size, "nr_hugepages");
 
-	write_num(path, nr);
+	write_num_ignore_einval(path, nr);
 }
 
 unsigned long hugetlb_free_pages(unsigned long size)
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 311fc5b4513e..ef1ea11981a7 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -719,7 +719,7 @@ int read_file(const char *path, char *buf, size_t buflen)
 	return (unsigned int) numread;
 }
 
-void write_file(const char *path, const char *buf, size_t buflen)
+static void __write_file(const char *path, const char *buf, size_t buflen, bool ignore_einval)
 {
 	int fd, saved_errno;
 	ssize_t numwritten;
@@ -735,14 +735,22 @@ void write_file(const char *path, const char *buf, size_t buflen)
 	saved_errno = errno;
 	close(fd);
 	errno = saved_errno;
-	if (numwritten < 0)
+	if (numwritten < 0) {
+		if (ignore_einval && errno == EINVAL)
+			return;
 		ksft_exit_fail_msg("%s write(%.*s) failed: %s\n", path, (int)(buflen - 1),
 				buf, strerror(errno));
+	}
 	if (numwritten != buflen - 1)
 		ksft_exit_fail_msg("%s write(%.*s) is truncated, expected %zu bytes, got %zd bytes\n",
 				path, (int)(buflen - 1), buf, buflen - 1, numwritten);
 }
 
+void write_file(const char *path, const char *buf, size_t buflen)
+{
+	__write_file(path, buf, buflen, /* ignore_einval = */ false);
+}
+
 unsigned long read_num(const char *path)
 {
 	char buf[21];
@@ -753,12 +761,22 @@ unsigned long read_num(const char *path)
 	return strtoul(buf, NULL, 10);
 }
 
-void write_num(const char *path, unsigned long num)
+static void __write_num(const char *path, unsigned long num, bool ignore_einval)
 {
 	char buf[21];
 
 	sprintf(buf, "%lu", num);
-	write_file(path, buf, strlen(buf) + 1);
+	__write_file(path, buf, strlen(buf) + 1, ignore_einval);
+}
+
+void write_num(const char *path, unsigned long num)
+{
+	return __write_num(path, num, /* ignore_einval = */ false);
+}
+
+void write_num_ignore_einval(const char *path, unsigned long num)
+{
+	return __write_num(path, num, /* ignore_einval = */ true);
 }
 
 static unsigned long shmall, shmmax;
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index ea8fc8fdf0eb..7799154b67ee 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -168,6 +168,7 @@ void write_file(const char *path, const char *buf, size_t buflen);
 int read_file(const char *path, char *buf, size_t buflen);
 unsigned long read_num(const char *path);
 void write_num(const char *path, unsigned long num);
+void write_num_ignore_einval(const char *path, unsigned long num);
 
 void shm_limits_prepare(unsigned long length);
 void __shm_limits_restore(void);
-- 
2.52.0


