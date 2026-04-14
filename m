Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F195ED7B8A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 08:23:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A0B36B0099; Tue, 14 Apr 2026 04:23:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 850456B009B; Tue, 14 Apr 2026 04:23:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F1646B009D; Tue, 14 Apr 2026 04:23:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5F8716B0099
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:23:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2268C58825
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:23:08 +0000 (UTC)
X-FDA: 84656471256.16.C37FA1F
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf08.hostedemail.com (Postfix) with ESMTP id A948E160010
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:23:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=DNzZ5UGp;
	spf=pass (imf08.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776154985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Phedwlb38O3RD9+mhV2vbvGYTlYASXZH6PBWCPj8Yfw=;
	b=3P0uLyYXvfxo7BWc2VuGSJtYbKFjs6QEvfDfXytnBEf7SGxq6EYTK5LwUcmlA6pNGpCuFH
	UmIkVW6+jkNmLHSLNpSfKKSDom0+kBYuEukW9ZWfgC0/IYLStVuSY/72d25Tmu5yEZ9VzI
	GwYo8reDpDM0Tpg03980KZY59u4X+HU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=DNzZ5UGp;
	spf=pass (imf08.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776154985; a=rsa-sha256;
	cv=none;
	b=x89D2whi15WeBGnBnwxASRL5ocpuyERaomr8/92t/Bb0LY+vg7f01NgjWilbLgH4vNm7Kv
	dTgAClWwSU4PARc0ctsuntnLfRbBEkm3aD44a1BVFvqngkHlVNaFY+EZcolwwJHRi4Np3+
	g5L2yUC0ED0fLlRl8fvplIuiNSMm1ww=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63DLID1i1842724;
	Tue, 14 Apr 2026 08:22:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Phedwlb38O3RD9+mh
	V2vbvGYTlYASXZH6PBWCPj8Yfw=; b=DNzZ5UGpwlnEvK7cQhWyM4AWihwb+RMf7
	MhFrbiLCPAQPtgkcpcPgnNSCoYXzQfKLPYWE9nMLzvev57sPuphikr7Vci8K2s0F
	c8huxwTo/wwjQ38deo1IS316rBUxttDAq6dUl+uwxSbwfeiVEObndkWcy4Au+4sm
	hMHGeedFnKox7eC5djvH0mQXJEH1XtQUG5+6kARvQ8Md9Mz9DPgJ9ciSMJ8x4VLM
	rZNxMW8sYi3TdkZB8zZWk2obQ3k/aSsTE4Lr7BF5Yhe+8z6tiVSDQZgsuvzNbysQ
	cdmMiSlPEHN7eIIHvbj4cSuuQy/JoFO2zTdo3ViZRrdeAj+fCWczw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89mhs7g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 08:22:55 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63E605Fa025862;
	Tue, 14 Apr 2026 08:22:54 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dg2ujgebj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 08:22:54 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63E8MoIl60031470
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 08:22:51 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DB74A2004E;
	Tue, 14 Apr 2026 08:22:50 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 018C120040;
	Tue, 14 Apr 2026 08:22:47 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.ibm.com.com (unknown [9.39.26.223])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Apr 2026 08:22:46 +0000 (GMT)
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
Subject: [PATCH v5 07/14] selftests/mm: free dynamically allocated PMD-sized buffers in split_huge_page_test
Date: Tue, 14 Apr 2026 13:52:01 +0530
Message-ID: <a61c264c824d140a948db64b2e1036bc4229d163.1776150071.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1776150071.git.sayalip@linux.ibm.com>
References: <cover.1776150071.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDA3NyBTYWx0ZWRfX0crGEdu5NWbh
 RJa13p2vWtI+NcjxgmPHkfcFx7sfji/vXONeoeuRwC9aW4t3cQ/9gt1csFgHgGEFdfNZvi/Zakc
 0e9VrEGhgNAP0F5b4v6QYvu0ffgxITJ4M3KRnEt0NePrQd25YlAYBlPMPde7nloy1K1A+SMfVaT
 Dbr+fucliK79x2HyznLm56qcCBiY9Ai6lxFkvwPnBpaijPlu7qee2I4cleqMRfJPTtWg7kQXWzN
 X6uPD2HUx4o7NhAxrUqqN1HknNqhQy4Ld5rBdXOYbzI+BCN2IrE8/MD2J2ieSiUWiHiHks3Rp1v
 adki0XiyRW1O8x3Z+N2fN83RuUKL0K0ahX0878P2O37BzXPN9YLefC+srS+EMNPKPwpvowfvj4a
 s6cu8+XhnjOJK3UhnxGjVg7nMHvY/VRbBlPEjbU2cUmYML7XBtK/P0nxqg/zTkn9nJ35G+ujMC5
 YronDHRsnTPHX66bYkA==
X-Authority-Analysis: v=2.4 cv=eJ4jSnp1 c=1 sm=1 tr=0 ts=69ddf960 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=Ikd4Dj_1AAAA:8 a=VnNF1IyMAAAA:8
 a=9VAv6nXQuNVwvrTyzFEA:9
X-Proofpoint-GUID: uLLRrIhLVCvz_qBdsS8EjkG5nGnn5xa_
X-Proofpoint-ORIG-GUID: C9KpqaKSN0SMC5vCZuFxHlQht529vbW5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_02,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 suspectscore=0 spamscore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604140077
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A948E160010
X-Stat-Signature: brie31izuiqnbntqbf7ryogtsowdixqg
X-Rspam-User: 
X-HE-Tag: 1776154985-421811
X-HE-Meta: U2FsdGVkX1+we/J9IlR7UYDUR4cSRmdB3KO6eaVsYsu/5uEWxYN4ZEWObYdPBLOg0FGulS+Dng8wYNJVz7b5WehGzz0hX5FOjedC2omA2+fNuWjpUPNU1CXsCyj2riYGlMoxL5s27qj7qlG42xWq/eFpu3AdWoaUUvPE35N6Io0KxVu+Mm+xRJOyDUBkYrzZ5hg6Vv/afvD/UVHIAGKhkkFSLWOVzTAYChU6nNjhMRPcZk24+53sipl/5fFLmM/tzc0jGEdknkB0gTAhQA+AG6BuHuWWL/2BBwqXA3RVQkOF/NDJO9uAGFk0tN7dMq3o2867qNDfDsCIk9hqhHjcfWRIoJOWFBl1ZkP9OC3y3ZGzjE+SQ/Y9FwmQ9w3wVJsfpan/gluD2FzIG/0lcJUhhAG8RUeYqJMAWPSqmV7ZtGIGeoGXUt5/MCqdCXoChtWoYM9jZ4Up6ztkVMePiNZVDfaM753BvRTDfxcKU8EeCnjgbNcjON0hZdrmimxX+ge2/Ly4wlVkdtJ4ZhkTiModbiMwNAgdUe11AFJJuZ1Ar5C4EaNEJup+SGd/rQZeKgGKRUV+aqrUtEO+d6xjREAkZI0irlF9nPEBQqNGKQ2WynTpVsuixxTummIPepqOJbRAR63PjsIbsu82CGKw6UNosyDEYNhIFR23fU9vpYULQi3TeX043Q944YPlVVswxhIO2aOdH4DT4wVUP2gfDof2fxpqxJe0vgimxDfCugx4vPUaCm8F5sWtGBmIvQ2zGEOKGY75vGgzdI/6g29nLSpgxgTTmtuaM/h6lOpvDLKI2urc6D/4j8mQmzou2X/xEo5j0/PTrjGaDmL2Ze6LcUbiTwzzwqToCppQeEkogJxaZc/vO4VQISPYjbr7iRhj+wPj6IYf6acVdivQP9ef4xxvAElq0R92fLV+UsJVzM2Mtu5hgXTr7/wVO2/HnXaBqZBsPilVOakzlux3igk36TR
 FxAmJdtq
 2qnz0PJvZxYY5Qli7kiBFbs5eOxi6CxjL4I8T4f4Tz6wucxkTXJBQqbefxfPPp7P8puJLUyNBiwJzKPTU5F8CAmmlMvGKxaHYjyVDytTCdYJLr4+0B1hqpnFWg1/9mpJ43BhcQsYhDKhiyDeuLJp5lothWhmoIMbqhb7mYUsk/omr+d0fLbmrq3b+GxCn0myLJvKjm50kJD/bD04sQokRUFOD5Taez3Wjrc55U3jas7LUWiIdgG7FZ3imOK5S40Hf63JJWcLGts5BmLpi7AJi5zkH7jIahZMSomYZuzmTw6uBeM3v48Iv/QIF/bv9+I1BYUY/lHZTNpAw87oTAqOgQKZsS11ci3Gm+TaTiU+Zx6TjwgB3FjW0XTI+wjurI8SOpH+8NrL2TWm4D/j63dxJjVRYz8S7UbuYlanbvz1MI+eQjBwDSTF6jAWytQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dynamically allocated buffers of PMD size for file-backed
THP operations (file_buf1 and file_buf2) were not freed on
the success path and some failure paths. Since the
function is called repeatedly in a loop for each split order,
this can cause significant memory leaks.

On architectures with large PMD sizes, repeated leaks
could exhaust system memory and trigger the OOM killer
during test execution.

Ensure all allocated buffers are freed to maintain
stable repeated test runs.

Fixes: 035a112e5fd5 ("selftests/mm: make file-backed THP split work by writing PMD size data")
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 .../selftests/mm/split_huge_page_test.c       | 22 ++++++++++++++-----
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 57e8a1c9647a..98319cfaf9a8 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -487,12 +487,15 @@ static void split_file_backed_thp(int order)
 	unsigned long size = 2 * pmd_pagesize;
 	char opts[64];
 	ssize_t num_written, num_read;
-	char *file_buf1, *file_buf2;
+	char *file_buf1 = NULL, *file_buf2 = NULL;
 	uint64_t pgoff_start = 0, pgoff_end = 1024;
 	int i;
 
 	ksft_print_msg("Please enable pr_debug in split_huge_pages_in_file() for more info.\n");
 
+	if (!tmpfs_loc)
+		ksft_exit_fail_msg("mkdtemp failed\n");
+
 	file_buf1 = (char *)malloc(pmd_pagesize);
 	file_buf2 = (char *)malloc(pmd_pagesize);
 
@@ -508,8 +511,10 @@ static void split_file_backed_thp(int order)
 	snprintf(opts, sizeof(opts), "huge=always,size=%lu", size);
 	status = mount("tmpfs", tmpfs_loc, "tmpfs", 0, opts);
 
-	if (status)
-		ksft_exit_fail_msg("Unable to create a tmpfs for testing\n");
+	if (status) {
+		ksft_print_msg("Unable to create a tmpfs for testing\n");
+		goto out;
+	}
 
 	status = snprintf(testfile, INPUT_MAX, "%s/thp_file", tmpfs_loc);
 	if (status >= INPUT_MAX) {
@@ -561,10 +566,13 @@ static void split_file_backed_thp(int order)
 
 	status = umount(tmpfs_loc);
 	if (status) {
-		rmdir(tmpfs_loc);
-		ksft_exit_fail_msg("Unable to umount %s\n", tmpfs_loc);
+		ksft_print_msg("Unable to umount %s\n", tmpfs_loc);
+		goto out;
 	}
 
+	free(file_buf1);
+	free(file_buf2);
+
 	status = rmdir(tmpfs_loc);
 	if (status)
 		ksft_exit_fail_msg("cannot remove tmp dir: %s\n", strerror(errno));
@@ -577,8 +585,10 @@ static void split_file_backed_thp(int order)
 	close(fd);
 cleanup:
 	umount(tmpfs_loc);
-	rmdir(tmpfs_loc);
 out:
+	free(file_buf1);
+	free(file_buf2);
+	rmdir(tmpfs_loc);
 	ksft_exit_fail_msg("Error occurred\n");
 }
 
-- 
2.52.0


