Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D5EECD5BAB
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 06:48:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 108006B0098; Thu, 21 May 2026 02:48:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E0926B0099; Thu, 21 May 2026 02:48:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F36866B009B; Thu, 21 May 2026 02:48:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E23AB6B0098
	for <linux-mm@kvack.org>; Thu, 21 May 2026 02:48:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B5E498DDCF
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:48:35 +0000 (UTC)
X-FDA: 84790498590.09.A48FB85
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8173520004
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:48:33 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=C6D3I+33;
	spf=pass (imf31.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779346113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eo/px+osxzXbvD5x79rFpcV6MacGwZaroZw3vt7lgbU=;
	b=tjJogOFKNQUffPeR8x7WOTFYGZHv3rb+KEFJ3bnvt9uDlWmOJf7bThEVIIIwG8WcXprFEP
	IaCTzkG2ISKbRGyFlkAJOvQo1ACZe9z666eILdaASvKZEjvwikpgh3UZQOB+4bvVQKWRO6
	4x9pVFIggfRaEGCFcZFr7BUmA8lS2M8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=C6D3I+33;
	spf=pass (imf31.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779346113; a=rsa-sha256;
	cv=none;
	b=NN21qSkktFnmweZCztVWfMNCDJoVecGHiFuOQpOIQpG5tTqFO7hzLNLBsV73Fladkk6jh8
	iW5VIUeB/qngU3PeA2LmaSlnMJsavtOl19bIW67PAYJO0+caeFhI6wnwUg3L5EBKvNREV4
	Ibgp94uK5GN+uzYjwOnBF/OktXVsS/U=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KG6lUI730699;
	Thu, 21 May 2026 06:48:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=eo/px+osxzXbvD5x7
	9rFpcV6MacGwZaroZw3vt7lgbU=; b=C6D3I+33wKUb95AlyJb5gEuDX02tN5gCf
	gubv8vxLGHYm7mZVvuh924FeOjXikkXNJDPhybdIPRQR2+yeqUzBPtCEEMMsNq9Y
	TE9MgkddLZoGOzBauCUnMFwUOY54EchfXcBY61CM1Vzzaid9/KLSEoDT1HHNHL/V
	g08zBtqeLCG+2cBpHU34oLFq5wssZf68dKmL1K+GYKyUabs3V7GAljVHpCc5VMTL
	B8UtgQwjT7LWfQZXuSaIBB56lTe2LmnwpJNSkDL9gJqbWSnmf80+HvSyL6w7Domi
	k2B+V3uLsocE/PjHOSKRmNAiL8k+KphloaBvTy8yb7fs6QWeByY3A==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6hawcdbt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 06:48:22 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64L6d4A8013509;
	Thu, 21 May 2026 06:48:22 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e72wqb26h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 06:48:21 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64L6mIPJ33423678
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 06:48:18 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5442A20043;
	Thu, 21 May 2026 06:48:18 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6345820040;
	Thu, 21 May 2026 06:48:15 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 06:48:15 +0000 (GMT)
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
Subject: [PATCH v7 08/13] selftest/mm: register existing mapping with userfaultfd in hugetlb-mremap
Date: Thu, 21 May 2026 12:17:48 +0530
Message-ID: <13845da872ed174316173e8996dbb5f181994017.1779296493.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1779296493.git.sayalip@linux.ibm.com>
References: <cover.1779296493.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDA2MiBTYWx0ZWRfX3JWUZB8iIVFj
 nFl4qeHz8zh4hCJW8cqDX1HIdJB1iJmbMa23xEKuR2YGKh6gU6L8DrJ1+BDBng2ZjB00oak24Gh
 lQxi8N29yA1/W8BipXqWjsYCfGbnPpPXSLzUW16t3fByvSqSNZUmx1NMYJgFUBRZT/TLMXBxf8y
 MYltzTIpfegefC09wCCxVAw3OVg/f1AFZu7Wy7gxGEzKsUC+o1ZXWU8J7im9I/UFBJtwSUB4n4N
 bH/GuzR2xA/PLIBh2dmymBLm06aDmAuTVlh6DuE5UK4+pEoiqDD4UDZYH6Wx/YK07U5N25/Rjun
 3dzRvAHGfJ8BZ/Rg9q6qzPfOQCBft8AvSWOafWtIn5HVeYXlcIbbII9r+Yx1yY8+KezTlV29A79
 1riosCYSQ9e+G/bAhOAOFevB4vE0w7b5QnDApF7j1z4mFomy6ZcJKXqx/fLtVNbTO1GMy2QCRkA
 9xYy4KFYqmi8dz991fw==
X-Authority-Analysis: v=2.4 cv=Np/htcdJ c=1 sm=1 tr=0 ts=6a0eaab7 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=gVE5Qc0x_BWLnb-D2gsA:9
X-Proofpoint-ORIG-GUID: fkKLQw64dHTeX5od5XGIYddJsny1HIgv
X-Proofpoint-GUID: Vo6N1Uabd546SMOG7gbBTt9oz9wwn6XY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210062
X-Stat-Signature: gof1z83b4p5z8mmadpt5buogwcdznwmb
X-Rspamd-Queue-Id: 8173520004
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779346113-167857
X-HE-Meta: U2FsdGVkX19jG+JJNh3vleSFE+vFW3jLwnBbh/zvi2j30V1T9vbpZcEikUWNXQP1hyq4DwkyhBdBIaJKSs+boU6Y0lUJi6JNQpvaqv2Wf/hB64p2pdLZwzRaeo9Eh9GdK1mSNODUeDjZgNQazgQK5BPjMtcc8HnXfDth5keWazh1snEr28biwx9gYX70yrGQGZifyTMg7Q08zw4TNfR72an5gyx+xHA9N/IxvGT/qiJ3czc9wkSRajky4bq3oP2iGXr+1m5stzbUs9NjgkgYLqBzT942HeHh7wG+SPLSLiVJgcZ18OgPoP1UQ1/8l8rDSHlR1mgyRtCgibEF11IAci5gHQWRFkfHL4kTxU+QGXADFz3hDeQYpTIWFApMxVVcayZA2p55TK91qABZUq1bqQm7cXLnRyaxcl9vKAM/wLb1Yfg/3gsD+WVkoXLZk2mAhwide2TlhuoteqJRW2e3BrdFIqB69/noHMd2hn0MyKXHhVSmJLsQOrPf9S36HhsFUoGNJs9jFRPtbD0f8GYFXxEZppZhEStvLInKQrupGnwR4DZtAPdNRSEOAxgzurU/E+pmqxnhGaJsVqkYB3be8AbnqViBWLXU+dn2ucsk8EKnYQ3Aq3VP/0RdMQSN280fYa5HXuOLneXdTmMfMJyEnY1tEwpl4m6JdclumiQ6GrW335Cmm+RLu/RkpdF2UlMLsqjNeqreGpq+PGiiXyxKsN66NoZ4gL5AOrulKuBt0a+DtkhDsdHk+r2zH+gI++pBSRpzhZjpJyxbA5PowOLgOKzxwsdzYna99qjzBg58Ry/mk7pTgO96/RknbPvwLrCYRdbmKIFeQkwcOGdXn0QBtr3rae7eOVzdIYDL4tcNcNyV4+h1uWNOXgENm4RlN9N8JLem70XlomwiLw2UL+8AwjA6gPechErkgjs9FiKy9Ww0BUxURVQGsIthhVWD4IPPMLqRxeJ+emfhiDIO8TR
 4eZ1p0xo
 3SefRJVPRzEEf7HkCUb5i3sncAXNASqFsPjUnUD/xskBiF8mqd1+B408+CnuVhRoeDoQuWafm8k0q3k+ocKLYvFgGd/regLPEPsliXHH8p6+DvPyLcCdacBlOrKOckzrS5YE05/ip9zFjw2pldKXcNjkXcwJH+FfKbdT+xWOBLx2T7bQAQ2PZmOp35pDTeYDhkVGHnfQ8jCaIkmZqE+OrqyvQiHKJ1L6aPqhEUB3tMixOPDJQDS0Kr9nAP6X+hZ4+XOq4jOmnxUmVpEE+2MB/B3IXg1JzBJkzyfYtsTumPVWkjHQaFYPZ9PudK22S5ASKq82j8nzLX+WjGokmSIRWqNPWUa7ArjQ/cb3oR4Of9TUFfZJqZNhJ6mNf8znqXy5SXfkzWa9P2nQdoIQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Previously, register_region_with_uffd() created a new anonymous
mapping and overwrote the address supplied by the caller before
registering the range with userfaultfd.

As a result, userfaultfd was applied to an unrelated anonymous mapping
instead of the hugetlb region used by the test.

Remove the extra mmap() and register the caller-provided address range
directly using UFFDIO_REGISTER_MODE_MISSING, so that faults are
generated for the hugetlb mapping used by the test.

This ensures userfaultfd operates on the actual hugetlb test region and
validates the expected fault handling.

Before patch:
 running ./hugetlb-mremap
 -------------------------
 TAP version 13
 1..1
  Map haddr: Returned address is 0x7eaa40000000
  Map daddr: Returned address is 0x7daa40000000
  Map vaddr: Returned address is 0x7faa40000000
  Address returned by mmap() = 0x7fff9d000000
  Mremap: Returned address is 0x7faa40000000
  First hex is 0
  First hex is 3020100
 ok 1 Read same data
 Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
 [PASS]
 ok 1 hugetlb-mremap

After patch:
 running ./hugetb-mremap
 -------------------------
 TAP version 13
 1..1
  Map haddr: Returned address is 0x7eaa40000000
  Map daddr: Returned address is 0x7daa40000000
  Map vaddr: Returned address is 0x7faa40000000
  Registered memory at address 0x7eaa40000000 with userfaultfd
  Mremap: Returned address is 0x7faa40000000
  First hex is 0
  First hex is 3020100
 ok 1 Read same data
 Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
 [PASS]
 ok 1 hugetlb-mremap

Fixes: 12b613206474 ("mm, hugepages: add hugetlb vma mremap() test")
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/hugetlb-mremap.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb-mremap.c b/tools/testing/selftests/mm/hugetlb-mremap.c
index d239905790dd..00b4c2cc95a6 100644
--- a/tools/testing/selftests/mm/hugetlb-mremap.c
+++ b/tools/testing/selftests/mm/hugetlb-mremap.c
@@ -86,25 +86,14 @@ static void register_region_with_uffd(char *addr, size_t len)
 	if (ioctl(uffd, UFFDIO_API, &uffdio_api) == -1)
 		ksft_exit_fail_msg("ioctl-UFFDIO_API: %s\n", strerror(errno));
 
-	/* Create a private anonymous mapping. The memory will be
-	 * demand-zero paged--that is, not yet allocated. When we
-	 * actually touch the memory, it will be allocated via
-	 * the userfaultfd.
-	 */
-
-	addr = mmap(NULL, len, PROT_READ | PROT_WRITE,
-		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
-	if (addr == MAP_FAILED)
-		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
-
-	ksft_print_msg("Address returned by mmap() = %p\n", addr);
-
-	/* Register the memory range of the mapping we just created for
-	 * handling by the userfaultfd object. In mode, we request to track
-	 * missing pages (i.e., pages that have not yet been faulted in).
+	/* Register the passed memory range for handling by the userfaultfd object.
+	 * In mode, we request to track missing pages
+	 * (i.e., pages that have not yet been faulted in).
 	 */
 	if (uffd_register(uffd, addr, len, true, false, false))
 		ksft_exit_fail_msg("ioctl-UFFDIO_REGISTER: %s\n", strerror(errno));
+
+	ksft_print_msg("Registered memory at address %p with userfaultfd\n", addr);
 }
 
 int main(int argc, char *argv[])
-- 
2.52.0


