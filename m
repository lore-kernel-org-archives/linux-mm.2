Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59041ED7B84
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 08:23:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFC146B00A5; Tue, 14 Apr 2026 04:23:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BABEE6B00A6; Tue, 14 Apr 2026 04:23:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A25E16B00A7; Tue, 14 Apr 2026 04:23:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8B0406B00A5
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:23:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2ABA213AFA0
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:23:18 +0000 (UTC)
X-FDA: 84656471676.27.DD1EDA3
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf21.hostedemail.com (Postfix) with ESMTP id D7D171C0003
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:23:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=M3q6BCcj;
	spf=pass (imf21.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776154995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=moIJIypDjtmZnGtHAK76laQuaSh8Y71cRRNVJavHh8k=;
	b=cwWrIFOjY7HKnbnd4Z1GrY5sNsOgjmSaNsuYR+LiK+NWzyVe+/9hRx/T6asw5io/zpsJBR
	2WoDwuQWaA9M8fel35fkkEanuuOz2HBWznbHpDTw5aJLTMDPIb+1Kp7aY8sCFKeoSyXboF
	pFydxC9szll0P/a2lstp+8FZr7ejVpk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776154995; a=rsa-sha256;
	cv=none;
	b=rt7oVBqOn/QkvuHtPAn6VXr+n3tR773/9z8vdYtNYimnBC0CgdbL2Kk068KKIqtpNIQP6v
	ZVIlAL8LcvhxKWQna+6TtKUd02SIPtS4qMWNxoy8ioFUz/CoGS7g/dg8RVGphaEDuzjw5o
	9mrQqvCYWLLOJaFrLiXKJVEqs6FLRms=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=M3q6BCcj;
	spf=pass (imf21.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63E3nCwF2487108;
	Tue, 14 Apr 2026 08:23:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=moIJIypDjtmZnGtHA
	K76laQuaSh8Y71cRRNVJavHh8k=; b=M3q6BCcjcAQU4EFVdESnk3nTncbxCZUlM
	1zb1t5qahYkaw33q8wJhAJOEXZviguMXWixw6/o7zlVwziqzq7oHzS0LP2FEVILf
	yOp32o1FgYwaCogMvPT+JV/csybaC1mYWMgwAAQDlwYg/MGFJtv9pjuqKthexe4S
	7v39FH4/upCBRBE4kc7b66DlrWvKCRW+DetzRy6Spdeh9TCOUu7TTUE21ZEq4h1C
	UGVuVUkQvJpzQQ0/1ziOhS3Kfn7sZzkpCV+RCuna7Iibw+BnBZAKlO3w9OpzVzah
	Hk2m8wJH4GHymeY0dAo+XtQSo3nmkNvFWLs4bp1eKXiJyu8qfUEZA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89m1ppj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 08:23:05 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63E6E6jt025803;
	Tue, 14 Apr 2026 08:23:04 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dg3b1gce7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 08:23:04 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63E8N02A42992012
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 08:23:00 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C6BE22004B;
	Tue, 14 Apr 2026 08:22:59 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AD62F20043;
	Tue, 14 Apr 2026 08:22:55 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.ibm.com.com (unknown [9.39.26.223])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Apr 2026 08:22:55 +0000 (GMT)
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
Subject: [PATCH v5 09/14] selftest/mm: register existing mapping with userfaultfd in hugepage-mremap
Date: Tue, 14 Apr 2026 13:52:03 +0530
Message-ID: <37b8bdb379a845beaba645c104fb0cc31aca57ac.1776150071.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1776150071.git.sayalip@linux.ibm.com>
References: <cover.1776150071.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=I/dVgtgg c=1 sm=1 tr=0 ts=69ddf969 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=gVE5Qc0x_BWLnb-D2gsA:9
X-Proofpoint-GUID: TfL428gbz9wY0OGEa0YNiF696CJtIz0I
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDA3NyBTYWx0ZWRfX0IHV8b100D7a
 BPxPYmJFDKnRm2Brk98k8pxEgIkMSssYwMzoexj05OtaYCHQTzCGiBinQfX54BjvfO1MD8FvJSu
 HAaxNnRBRB61TwCab3HxBR/pJbzPs1aAGBPSEDq35Rdf4YsBOwirUIw0N65qf5z4h+d0p0qtPIR
 FXmbBO1maiIwmzAHF4UsUlfGA9CUlMsYtJq75SlT5548tGdcmlUvh9xycrk9MFwxs04x8/MSYuP
 5hwe1J/C0/sPzal1vBJ/n3BW8aNYN8UVW1opXBFdM67fQM4xysAcF/LcFakaink06PwfGmKPRyg
 cu63y1vdRwrcmYE4S9KCV/9E2spkp+QRZEiRE/Ct1q14nu4cSbzHpxfGa/+PpSuI0WwvMkWjCuc
 PxubKnzfj2o8m5kmMKNNTFBmWyNFU4Ocaq7xjsnyiQSr8FSH+YwVfUTcMLBcJYF/9h2NmDS7FYB
 rso24PSTam64o4brI3A==
X-Proofpoint-ORIG-GUID: qMABBfHeIhCOuLcikZRA_GA1scV5rCuK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_02,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 phishscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604140077
X-Rspamd-Server: rspam12
X-Stat-Signature: ecwzpcw1shgyjq5yuzt3qcp8jpqs7nj3
X-Rspamd-Queue-Id: D7D171C0003
X-Rspam-User: 
X-HE-Tag: 1776154995-756086
X-HE-Meta: U2FsdGVkX1+CwZbY58N1y9aCwXk8Kcbe9muUzfixW+GwlG2mlLsNwj9hRFSZNNNJ9aHnbwKyTHNsqbdWZvyFkEgEhYxhL8j8sLgP6qdisI1JOm6Mjo+fTXYe79MzJ6EfgHDedsGpRFvKW5qmXELegVHh0VJ1a+p+IpOabb/qjlmDmn5la3tRufFi07s/I1F+ChMieUAiOL0ZlI1w62T0dsJqOER41UuWujIvEupGc2qSDMsNZlE3HV0a/mXsp7ZBVfpeZ8kUc+jZmmgh3S3tk7p9pwKI837smqgeWINvmZD7yqyTaJrlXkx5UT7mqoOhvIcbrcvX6znVz5SKyhq6z1dqaZ6OPjOz89WYP24UqgdiLvvZsgfBCs9GTDfOeVbYIlbiJOOykNn26Q/Qk1pVnzZ8wuve2QP7UYbxwhJzd/JmSC80rCfJ+We+Tga2o8/r6Fsjwo8FgtB5FcdtNKPExg6P48bs9e2u1GlxUCwLmfWwP/XKS4AY1rW54krmfLrKL03IgdpFdhbmfVO5IN4qUBO5dHHN7QWEKRby8mnEgNQdbRpnFeVMd3Dcvevw02aGxPo1GokR4fUzSjrW+V2S3LGPo8Wz6LGj37uix4G4gzpZnfWDGPXcdEDamDX1lvASJsRNMwwPSI/dxEmCrymVT+CdHQ0zf8hutGBoqMhpg0GY5FrHsx+SSEpE5ERVlxyUx/Pb+R2nMyk+a6r/TAh99vu2xFYhnzKUIZTdeEgYtQ6aPTTuBtOoPjWe181VHlesoJFhiBvVKbgf+p+pgy88O/z93/qgjdo516JwN0gRIiRHIrsoKGKCLUB6NAUTjss7s6RVM3nzoWc94MAGy+ByExFOtB1rHY2ECr+3wBUArw9s49DbTcLyy21yjtZyP0EsTkdY6mWx1odguR2fzbjDnKDYdTvxXzPkuj/XJrNq/CPMKHW9OUgrqo8RnxvUWQ82fB50D7iQgmoGq4pgeZ/
 FaDZNN8l
 yOnva84tvuj1jhBdccqlXQRkC8Z6RH7c3tAUpq/IHx8Bptkna44W9i5iXoThEwTOqdkzTIBm9k67Vz11RySskxlHRmTq/uvfkkywsK/ce1QuoPURw2FkfaD5OO9Ax5JgntsUaNMWvRQaQaabPv8t5xOiQWrkfVJ4PBiVrwn+niuIv5+IjmZDzRVai4yekmVwE+SHTZAe3i+9jrKqnLd5HGvPNVJka4xjyGugwDYxvN9TI5fFMVQgLUAP2ervmD8nSAjetPTIAGqmirmlv3ZX+bGxPNl8up7ze0CkkMLRF5NxmeqW0K3Wiy8D8k3tO80MpItGRaBsDziI2kxRGY2iBAHjoo9wbgla6X7yGnIHg4viZDsMOTCOiGR5dR+94wIRF6vQ1wRu0XSi5Pqs=
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
 running ./hugepage-mremap
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
 ok 1 hugepage-mremap

After patch:
 running ./hugepage-mremap
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
 ok 1 hugepage-mremap

Fixes: 12b613206474 ("mm, hugepages: add hugetlb vma mremap() test")
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/hugepage-mremap.c | 21 +++++---------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage-mremap.c b/tools/testing/selftests/mm/hugepage-mremap.c
index f66e4d806477..68c35d1d8a5f 100644
--- a/tools/testing/selftests/mm/hugepage-mremap.c
+++ b/tools/testing/selftests/mm/hugepage-mremap.c
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


