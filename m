Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22C08CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 06:48:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85AC26B009B; Thu, 21 May 2026 02:48:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8320E6B009D; Thu, 21 May 2026 02:48:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6855B6B009E; Thu, 21 May 2026 02:48:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5177A6B009B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 02:48:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E9DD1404D3
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:48:39 +0000 (UTC)
X-FDA: 84790498758.02.24EE968
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf15.hostedemail.com (Postfix) with ESMTP id ACE25A0007
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:48:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=FGrDqY6s;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf15.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779346117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A94GLQ4GcTeWPTRQGn8aC6W/mrfCd8XhQQq2VXeeAxM=;
	b=Gq1GMKwgF9QjFucuidSg8V9/zEcnDXOE/JMa42n8Rr1n7bXh+XKqiTokyQfTHdXD64FDyq
	+5/7xiWyVyGLA37H6y0+ReO2g/7lCRACdAVAkK6Q0wDJVKkQeAt+Dl08S86qp4f9L5ZtOm
	YCrhFJpXZTCYsPXt+ff5DdOmyKwzfnY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779346117; a=rsa-sha256;
	cv=none;
	b=rjlRNgJwD90SyMLWUunBPRDCC19PCr9d0ZzOheovhpcdk0EkOO9EiC2ZuULUg6Nt/ATqEn
	Yze42AU5hOjhEuZF3r5SDgznNSiS7ey/kYeTr4ZU41+aORUlRU2HmfWBt5MS9f45y4eRCv
	ORuT5zXlGk4w7b3J9V12A3r+UA3hyZY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=FGrDqY6s;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf15.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64L66Bgp3628517;
	Thu, 21 May 2026 06:48:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=A94GLQ4GcTeWPTRQG
	n8aC6W/mrfCd8XhQQq2VXeeAxM=; b=FGrDqY6sneZ31K4fdHDfNBpdYxXQU8Y3y
	tEIMqvJHF/u770HjWmjnrXc3CCk/wsWHuLQx1x89GeHTYvFCjjzrwtx2FIJWfRQ9
	kitaKld9jVMa0C1yVoAm6cQ2n0n70Pb5pVBboLTfPfp0PhVyurHQqhIkWGHhkycD
	nd3AugpPpmcVZy3kD8J+nIE/7EkMv4g+jBy/39wZ2owNSI6U4uvRzDB3OIa0jK2s
	OSfHS+aLWE7DMgPF9nL8qN37i+RZ95foHzA7YFGEH5cHulJZJTOYksXMdULzdZcN
	cuRM3L7vB9X7RPSMVr6TyOanHqkvJHyZCDAn86To8hVyumLo0pyrw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6hawcdc5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 06:48:26 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64L6dAaG009776;
	Thu, 21 May 2026 06:48:26 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e74dhtrpf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 06:48:25 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64L6mMCS50463140
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 06:48:22 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E25D320043;
	Thu, 21 May 2026 06:48:21 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9B9F820040;
	Thu, 21 May 2026 06:48:18 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 06:48:18 +0000 (GMT)
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
Subject: [PATCH v7 09/13]  selftests/mm: ensure destination is hugetlb-backed in hugetlb-mremap
Date: Thu, 21 May 2026 12:17:49 +0530
Message-ID: <367644df45c65098f23e3945c6a80f4b8a8964a6.1779296493.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1779296493.git.sayalip@linux.ibm.com>
References: <cover.1779296493.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDA2MiBTYWx0ZWRfXxK6S+CvmQwg6
 oxCp0jtK6dxsTpEEDmlPWYFjIHLlm44AvIRPuNTU7T11xe2g6518FpYFaCEgm+jicZjAlG0b60Y
 K1d4+ErvoZtfVpQD/8n6NOzLfOUk4D9J1eDvrlTQkBswnTkiFipSloV5tf/1Dq9taaMShioHwz+
 caBltjvii1IIBRtCTJJLUVd+UUJeCkzoHoS92A1jaJYbGau390tEbM6EcIIztG02rMf52VDsONa
 NWSi4Zl1CH04/Os2/P4xnn4De64ve4fyVBkq5wEAsOYAbr2n1Hir+ICsCzjEOUZMVMK4iLYrIpu
 tKg6H/tLkXnnYFKJPnZUr45QlN4NpwgkCHzQRV3baOZCRIeUrl2YvPxtmT6tELwBg7VxHAIAsQD
 WVb7f7S0ffRDm9AXtyxMmxFJyrvoram0LlDCZb5JC/7wlFvHcQwmk30Ii9lnaFqU7L3yhzYLAY8
 Yl+pZNk62AfcA+errHA==
X-Authority-Analysis: v=2.4 cv=Np/htcdJ c=1 sm=1 tr=0 ts=6a0eaabb cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=njH7lnjfnPuJvX8OOgMA:9
X-Proofpoint-ORIG-GUID: xqIuYuIF4ps_1A54LtPWGKsrPRX4ITLR
X-Proofpoint-GUID: ZdW7gwnlZ6n6TpjX7t_X8P_C2hGw29u1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210062
X-Rspam-User: 
X-Rspamd-Queue-Id: ACE25A0007
X-Rspamd-Server: rspam04
X-Stat-Signature: jm9t9ykoss6ooi1sxkc6b37wm8osujrw
X-HE-Tag: 1779346117-344727
X-HE-Meta: U2FsdGVkX1/mhEDuAkdoVvfPzeyxkcZvSJdE5OaS0HRP/bJaq1iR30e0Ec2ZFyWt7o/aXQXYtb0wOWjt5nyKweNEzF8bH6oZO8WLPPCiereMD2KoU9ygZ/eFyGTPhG3iBc7yLk8K5OQZh5XYjChPbO1NODKv79ytDCIEX+ZL87YU9H56z8Ribq4m67gjlFyhH9B+7PpBZ3gE1ixWFtS42Y/SAALJJ+wtgCdKtfSz/lplVHO4JrxMj7SbiDJ/TP3kzkAbMPET7mU5wwwCxkUrTUtk2T4ynOrRtOU12TOGmtbDIRxTtiUWQ+Q3WqWgekwNvHWgg7d15xDfztfRHcMLYr9q+ou/n3UBHzMFRe199LQ28E04R0O85C5drHjQM19HTT/V6Q5JVUk87uALxCLVB7c07rUyQ0oTAtgxcDBRKJnIsHHJXvEcUPg+SUeWm/8YJdmiqxw4UL91hyiJ5HfDnLP9MlCHAvnPl7pgpHNvB55PWPAvSxIgmJ03b1lg5hZkRbbWP/vjGkLLbebb0jDPexacWWw/XLrbeH4RxC9PlS53JURsOZmul8oG8XHMsuQIkK8LeSLsgHKaZiIPOZl3JNqlBkFhNr+Ad8HVNUxRujDX6HBrIvHhcQZZfDqucuhTx9nJdYpGGAni97fJMSEx/hUpSodTTCaXhqjGGCjG2LWKJ24Wn4LmrsARW3lguBcKa2sJTh8BLjiM4plK3nvSV9r2JY/XJFhezjlmvmFfJqMfdnvTc+WmqmpthFo2/gNJLMocqRU5rO/T/+MV6qtrVMC78/8b9tJLRB5OM5jmbg4xKdSjhsy1ts8wbnM94HAJ9OyHqa9cKJ4DR50r+bbEKflZCVzLdC/DzNfek1ecC014SEiTTBJ5VLYtI+sBgmd+BFHFx4LsBWmH+Sbct1Fi6h6PYQa6pMjsRCAclssjQavIZ+9KXxuR16sWBfq6BHrprreHIOfwp491UZpM6um
 jhiI5WFb
 GQewnGwwwWsRAvuc3Z+cCNcakixxOpOtcUDwFqibF6EBrbE5d6xpcGgvalYc+ZeEMG6GwX4PrFt9mseSNuC5zt16/rCdk4ewQEItfmkfOruCez5wI4mamGd6w8dxfKZ2uf/jkpIiCP+8bEdGKjt4pJ5Oqf1corhtiOG4UNFOybnDT51WD0QXshHoVUWoUQPENE5JCazkJd8488+syd1jvqpTWbK9K0UpGrCAR9XILiLqCgPwA8BfyKvALNOWGbcaUfKbUS6dN90rKN+VHzvvlezcyTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hugetlb-mremap selftest reserves the destination address using a
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
 tools/testing/selftests/mm/hugetlb-mremap.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb-mremap.c b/tools/testing/selftests/mm/hugetlb-mremap.c
index 00b4c2cc95a6..ed3d92e862d8 100644
--- a/tools/testing/selftests/mm/hugetlb-mremap.c
+++ b/tools/testing/selftests/mm/hugetlb-mremap.c
@@ -32,7 +32,7 @@
 #define MB_TO_BYTES(x) (x * 1024 * 1024)
 
 #define PROTECTION (PROT_READ | PROT_WRITE | PROT_EXEC)
-#define FLAGS (MAP_SHARED | MAP_ANONYMOUS)
+#define FLAGS (MAP_HUGETLB | MAP_SHARED)
 
 static void check_bytes(char *addr)
 {
@@ -132,23 +132,20 @@ int main(int argc, char *argv[])
 
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


