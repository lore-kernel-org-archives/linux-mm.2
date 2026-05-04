Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73FA6CD3427
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 08:25:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84D856B009B; Mon,  4 May 2026 04:25:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D7806B009D; Mon,  4 May 2026 04:25:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A0246B009E; Mon,  4 May 2026 04:25:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 54ADD6B009B
	for <linux-mm@kvack.org>; Mon,  4 May 2026 04:25:56 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1EFFE1C06E6
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:25:56 +0000 (UTC)
X-FDA: 84729054312.04.F0E3999
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf09.hostedemail.com (Postfix) with ESMTP id D2387140005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:25:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=fdpEIssm;
	spf=pass (imf09.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777883153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G5jNpn3lA4nxxcFeRR2Yggf97NPpXqcmij/yD8SCbb8=;
	b=BlvGFAEO2WYC0iSIH6ztZTwPDKumGVHaauro9+xN8W0zkujbCT0qlD7faQglE5l/ENcUBa
	PCzo8DyKTNNnXfng+fqAZ7+OiBPACnVaTbu142ZzARq/UhjLba5TmapEumMC23HJd1LEr/
	HxSOnbqNIKSLDD4xLXDTu0vsUALdIcs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777883153; a=rsa-sha256;
	cv=none;
	b=ZCtkANdZD31MzCqnDRdvizh45XqFUNcIisvmCm13/USUwUMxFtu1kgxIWbT1vTv2p+a+Il
	uovlXf6FSYRpQNGNcoetZEZXjmC+2D5xPIIA6MNwXeZTm+frQFF0YKhBUjegQ3CPoH2N2O
	fGSa+H4Lv3lPa3h1BI9l83FnzVjBsG0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=fdpEIssm;
	spf=pass (imf09.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 643AG0hQ2080466;
	Mon, 4 May 2026 08:25:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=G5jNpn3lA4nxxcFeR
	R2Yggf97NPpXqcmij/yD8SCbb8=; b=fdpEIssmMNtdlwy3Wip1UaEfEj8kV8NuV
	bsWp7l2i9dLwf3CUSa/pNxrJ81fkJEXiYDKZqTfHAE2L7adrq8ZmmXum+ZuPkLmO
	tA4+ITI+CdRPkz6pWOJCPes8EZpvVefHI7DU/1hxbFnnh22xCEzTAz7uTO4OGJmT
	pG9jSOABMtadKPhj3bW5bTdgy5nzd9AJ05wp1Zo0bQ9mwv9GINh6lOZ4/GMcGg7/
	mYbtWg3hE4j2zPw9Jkd4Tabll9krdVRJuzMkhpNT/JDN/ow+e6R1neHhAa/2vhXM
	wlG/Z14PvZolEcs+o6G2Tvk0735plbqPHXjNm1S2bcmG69wbxqxRQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9xxdwmv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 08:25:44 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6448OOIt024707;
	Mon, 4 May 2026 08:25:43 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dww3gv84a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 08:25:43 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6448PeTs59179492
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 May 2026 08:25:40 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0B5DE20040;
	Mon,  4 May 2026 08:25:40 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4D95720043;
	Mon,  4 May 2026 08:25:36 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  4 May 2026 08:25:36 +0000 (GMT)
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
Subject: [PATCH v6 10/14] selftests/mm: ensure destination is hugetlb-backed in hugepage-mremap
Date: Mon,  4 May 2026 13:54:47 +0530
Message-ID: <021c74ee2bf9d6dcc5416458d387cc7a1e58b003.1777877814.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1777877814.git.sayalip@linux.ibm.com>
References: <cover.1777877814.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA0MDA4NyBTYWx0ZWRfX7NUPgzU6H5aG
 dTG8ZrM9LvVfEr09/1tuWZc+ZJlOEs2duSjOQrieGtZJ4mCi1O2j2P0l9BvUewURhWIjwoTkE37
 z8M6zlRGLVz9MYzFPN9XmfmgTh4movrEUL556YRqC0wjpp/LJ/Y8IhloxcSG3JV290P5/yYf7ev
 vbdFXeaz1PqhEneSAmU+GgLojyAZxm/HdPg44wtDWaPQ+I+Nzonw86O6doRMcFTaJYJsApg00Ci
 NpiBPCFnBrusMC+zQEMXM5a7TaNkWN0HJszFb2qsmdYt7qwA5A+K+pdiZygonRH84+akNZtB+j2
 ifBXBRhcFmodgHNaqLacM2DRu+7WycuqnsOdhQGAWC/9GM4OSnGfH7t3VruU2gmmrBXkKn6MbqD
 YU7ATuzOmYJ2G7EqjNIGeyaxOl2czMq3g045wRaIWIwk6uj88XtXFVUKgUREG7vpC7h/6z6xMZh
 w6DxVtOGMJPgYrBZGhA==
X-Proofpoint-ORIG-GUID: 2K6-qwYb5JWf8NZfbzS7aBOIcQC1HM3Z
X-Proofpoint-GUID: JwLyZOHRS8xhKuQzWUSCdZ6pX2UG6At2
X-Authority-Analysis: v=2.4 cv=ctWrVV4i c=1 sm=1 tr=0 ts=69f85808 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=gVE5Qc0x_BWLnb-D2gsA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-04_03,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 clxscore=1015
 suspectscore=0 impostorscore=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2605040087
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D2387140005
X-Stat-Signature: 7bgoqowxdbnyj4x8856bp6hhked9nkkn
X-Rspam-User: 
X-HE-Tag: 1777883153-252190
X-HE-Meta: U2FsdGVkX18Lo+sjCIqmmaQ0mZ0TMaZvTNPriuXFirlKJkKIcBYzjOiscTuD0IhUKIuhYW21s0dT4eBUryTsKBaaSCAR5bUVU9wcWyHyYvOAn8jK+f+FwH6kv2vsmbs5vEmZYD4BS/TygWj+K6Yrf1sQcgKxaS2t9qY/ETBt1wfhPwiWkfQ/J9m998sProhiHOkRhxhxwgzNfQNmSBbhZK7im6e38a76hjcgS6Gg2CgTBLBYwkvkgi53rMJDo2b7G6nv8LjvK/z5TjVazFt3ZvWDUANjPU/ROtg1YOtiHpgkdJQuZng4gmVzwcPhtj5Qf9FjiPN10cx4gC96N0QfzY4/DxcSDESYZJP2OOAXxzFX9mV+wmkDX9L7LTB4Txy2BDtVPcQSq6xLCbcaEPHFhVOLduAlsQnhVun6Nycet0eYNL8XKRPrUFa+a/saLm0h3C25IK22hNbsBJFCvKcxJZPWaN53rKi/PjQU2v603wCHDN6S1Uw6ZKAybGr8erC8SuiDTFyIxIG3sSQNUlQPZJwvCuxr790+TfubLPEBLxEEYS/sI+aGl1Sr4p9LXJ9mrbo6erM/oTPSM94SXu6QS8RjavEf/Z2lpDcFH81RMA2O/DFegCO4bYAf1EYA8MXkwXio3C94xk5EW0y8goYbHJais7bYBOUR+JcUyih8j1nbAOjKHkdKfCFXZgEgxwymMGD3zbUeB/3LC0tnpZky3QpHKUFNjmMrQwnLG/R0SBWsdntmz4ZY7Hd+zc14Y63z+kTLfo5r7GLdao5DDvjSxRuXsmXxc9dXATMEMLoy2UtAPQLO72gnCd2LIH3j1Aa/7LAxYj/GZi6o1D0msNyxJ2RrMVmVJJUNcOdMTTrSkV2+kYBvKbWq9av8StdmjIbczdriTgF021n+EkPnwF2Ix1e42bv57CenCO4AbOhe74X0AgPfLdFqZL0tr69gMnS+5ypJPtMN2y3w83u1jCh
 RCm+PfaF
 5MoxkglCWlNqDrvTybhef1D+xBCyFyWO/F6RBxCe2gAmK0qqoKAYvwZZY2EvY76e95toCaxKuTXjNJj3F/YjEZoWvJBT7qcz4tIMFQKy/OD5DX0qeIGn4SL6bVO+47AyfEb09KvXI9KtBvQoSbDzjm3E4xM+sD1vi77helg4h7SvHhLvYuVqH20+ZaOkuG/UlYP9FvozbXuQ3nzw4FT6Th8o182/IrEfIYz+kgkBZEBj/5hvz3N0uSsikuj6x1B1WK33pzU288GiT2tnRVfJ2RIVvcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hugepage-mremap selftest reserves the destination address using a
anonymous base-page mapping before calling mremap() with MREMAP_FIXED,
while the source region is hugetlb-backed.

When remapping a hugetlb mapping into a base-page VMA may fail with:

    mremap: Device or resource busy

This is observed on powerpc hash MMU systems where slice constraints
and page size incompatibilities prevent the remap.

Ensure the destination region is created using MAP_HUGETLB so that both
source and destination VMAs are hugetlb-backed and compatible.

Update the FLAGS macro to include MAP_HUGETLB | MAP_SHARED
so that both mappings are hugetlb-backed and compatible.
Also use the macro for the mmap() calls to avoid repeating
the flag combination.

This ensures the test reliably exercises hugetlb mremap instead of
failing due to VMA type mismatch.

Fixes: 12b613206474 ("mm, hugepages: add hugetlb vma mremap() test")
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/hugepage-mremap.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage-mremap.c b/tools/testing/selftests/mm/hugepage-mremap.c
index 68c35d1d8a5f..a442d01908cc 100644
--- a/tools/testing/selftests/mm/hugepage-mremap.c
+++ b/tools/testing/selftests/mm/hugepage-mremap.c
@@ -31,7 +31,7 @@
 #define MB_TO_BYTES(x) (x * 1024 * 1024)
 
 #define PROTECTION (PROT_READ | PROT_WRITE | PROT_EXEC)
-#define FLAGS (MAP_SHARED | MAP_ANONYMOUS)
+#define FLAGS (MAP_HUGETLB | MAP_SHARED)
 #define ALIGN(x, a) (((x) + ((a) - 1)) & ~((a) - 1))
 
 static void check_bytes(char *addr)
@@ -131,23 +131,20 @@ int main(int argc, char *argv[])
 
 	/* mmap to a PUD aligned address to hopefully trigger pmd sharing. */
 	unsigned long suggested_addr = 0x7eaa40000000;
-	void *haddr = mmap((void *)suggested_addr, length, PROTECTION,
-			   MAP_HUGETLB | MAP_SHARED | MAP_POPULATE, fd, 0);
+	void *haddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
 	ksft_print_msg("Map haddr: Returned address is %p\n", haddr);
 	if (haddr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap1: %s\n", strerror(errno));
 
 	/* mmap again to a dummy address to hopefully trigger pmd sharing. */
 	suggested_addr = 0x7daa40000000;
-	void *daddr = mmap((void *)suggested_addr, length, PROTECTION,
-			   MAP_HUGETLB | MAP_SHARED | MAP_POPULATE, fd, 0);
+	void *daddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
 	ksft_print_msg("Map daddr: Returned address is %p\n", daddr);
 	if (daddr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap3: %s\n", strerror(errno));
 
 	suggested_addr = 0x7faa40000000;
-	void *vaddr =
-		mmap((void *)suggested_addr, length, PROTECTION, FLAGS, -1, 0);
+	void *vaddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
 	ksft_print_msg("Map vaddr: Returned address is %p\n", vaddr);
 	if (vaddr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap2: %s\n", strerror(errno));
-- 
2.52.0


