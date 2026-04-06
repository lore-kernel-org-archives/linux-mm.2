Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C193EF4EC2
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 09:20:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62B996B0099; Mon,  6 Apr 2026 05:20:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D9C46B009B; Mon,  6 Apr 2026 05:20:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47D6F6B009D; Mon,  6 Apr 2026 05:20:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2F3C36B0099
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 05:20:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BEC5D14032F
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:20:48 +0000 (UTC)
X-FDA: 84627586176.16.60CBAFC
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4A1804000D
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:20:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Hik00wCH;
	spf=pass (imf01.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775467246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=moIJIypDjtmZnGtHAK76laQuaSh8Y71cRRNVJavHh8k=;
	b=jiz0klrNHk7YrCwapqPLIPsEV7pHYnWL9nC5X6UC+2v1fiLjYXaaI7p5XJ+esdqrFNnffE
	ioHrPQpH0yYvTRc03ZSDJGxAjx2IIeVB/MYeC6N36uNuC6PopxKR5ynk7E/+lnq9+GCXT9
	drpRZdUlH096Z4p12j+jWMoSMcMwJ3U=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Hik00wCH;
	spf=pass (imf01.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775467246; a=rsa-sha256;
	cv=none;
	b=51cBjHPVEOXa4NVnnxlg2j9xl3RjsDUePdeLpnaLsg4ytQWrwM4odUVFLF7mszVuimFsNx
	yQnLA2JD7G5upVIhJY4q1lpYz7nuUfJeQvIjYSMpWUMq6kSenYy9jiC+BU9Zd0AZYAL9U0
	ZQOiqyBtCTINwiu4d7KpGn7nvAJoB9E=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6361JjAk144608;
	Mon, 6 Apr 2026 09:20:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=moIJIypDjtmZnGtHA
	K76laQuaSh8Y71cRRNVJavHh8k=; b=Hik00wCHA2T65DOiv2FUNaKX4z0wABj7W
	L0B+fZ5LfYJKkAzIBdrZ0UMfO9sOLn2dmL6VUSFvx1iivEppwnEuC22aiZd8IT0E
	DrS/clFaHehIY+wHO/0zQoRgaTf8Ms92P7BgqsppXsELfQar7/bkLi30saVJUUnZ
	705L93ciwZpYNSIKdxEhC3KNCe4OROPQRv9Hznx7AUoKuQo00oz59zW1DZEymnd0
	EPFIe9qLPcnJ0hSBVKQ3CJAp5JBDk0Fw7wR1sA3nS19QXl1MJlACKNUUwemwYygg
	yLSWlWu9mcVPcaYtG6r8bxA8A+igRske9g2JWs4EGHUQ4cjgogyuQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dat51wxje-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Apr 2026 09:20:21 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 6365B5d8021211;
	Mon, 6 Apr 2026 09:20:20 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dbdbyc5h3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Apr 2026 09:20:20 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6369KGMV25690384
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Apr 2026 09:20:16 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7A6462004B;
	Mon,  6 Apr 2026 09:20:16 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 35B7A20040;
	Mon,  6 Apr 2026 09:20:13 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Apr 2026 09:20:13 +0000 (GMT)
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
Subject: [PATCH v4 09/15] selftest/mm: register existing mapping with userfaultfd in hugepage-mremap
Date: Mon,  6 Apr 2026 14:49:28 +0530
Message-ID: <37b8bdb379a845beaba645c104fb0cc31aca57ac.1775466330.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1775466329.git.sayalip@linux.ibm.com>
References: <cover.1775466329.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=J6anLQnS c=1 sm=1 tr=0 ts=69d37ad6 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=gVE5Qc0x_BWLnb-D2gsA:9
X-Proofpoint-GUID: bDkKYtSL7-5YYatGT3uYr5GJCOCbfYCm
X-Proofpoint-ORIG-GUID: yy50-zknC1XxWo7EBfMRsAKwxbNehDuS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA2MDA5MCBTYWx0ZWRfX0L9bzyHv8hJP
 thTEypg2qYrg7xhCXBzT5XOAaxsNXhnCI4mVYAvtMI3moASSrlVx/OoCY5qMe48PeM8c0aXZy7D
 7eQ6BpelOPag6j0HC0/nzpXqQuMPH39DiIclV6Al7Rb+1D09Fh6PgoWtc6a62H4ZI7gFUdcvvJ3
 ZBWL+Y3Y4C6+By59unOg1widV8ZlSeed3DV81mhoqD9gqAKxzlxPujeUuZFbKrw77gSXi4e25b1
 ZEGs26p/PGN6770RPDPsgEsS2FWkX0nCV2A5SteF9mqvbiyh4r5vgGKXp8S413gsC0bvaoVZNux
 DBFOz/AxLL1ONS9VDXI5Rr7/r1kGLswnMa29JS89R0BnSHuuhnDP6FT4VD8tE+3xFGK3j24uAy4
 oalUym6pSy0BIdIZ2WlIzmc5/qZFSrX/USH1pzptXTgoDtUesuCV1fZjREgroDuRu8r87a3dW/y
 zy1CdO3alpdkyVBcIpQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-06_02,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 impostorscore=0 phishscore=0 malwarescore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604060090
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A1804000D
X-Stat-Signature: 468ixzrgt6xsj6ykee4ebo1cwtk7jhxz
X-Rspamd-Server: rspam06
X-HE-Tag: 1775467246-355307
X-HE-Meta: U2FsdGVkX19v94EqOqz7/ihFKJxA3NV7t+yrYRa8k1X2Upoo1UpzbzgseFnwBxmJ3VI3x+M4+w3mz4p33OuUsDWQ8wuVhgKZvgM1Ans7UhJgGtUsJzJTQ2J++8FhskqWKOriyJD/uqgot4BkaDZgMaj1tXNO3lPfKsxBPPzVoR0uIeKb9SWlT18ZInzgTP03rzob69RldMTJChViI4KkRR2zaukZFL0Wqx7TxNO3CD/quB1qnzAJKirdZ7jE3qe2JMxOIFxDkYiUlc7VauDTkxKmf+G6nJUTZvquixr7AcLUFwyUwp6KlKLDMLArn9SLE5ex5e0gC9yKBrr638zTPEt+n5qhbk+3ZB9D3vKlG3TGmMzZWMGu/UGVoNWV+ies/T4HT61MVAWlpkmuKjvCeer1btKhdYg+8OzOXRSQpyTgr3b0+Ek3JA0AdubtLUdnS6DnKdrTB6eW/K0wZI56Ao76+aPGHWusGRL16PXcw5AmpKlCfpk0wvwDnyISHuHgCViy2aurAI3+LrElFyQWX/YgRHCKrdu5Nqh8coH/ME2V/J60so4fEUpzoabLctCQUEvZszNcaP8wjcM8vfXP9tfZpIUmsMtbT4FKJQ/0KcfpeNtWO0zX5sv/1VW8NDKplY5r3u5NVhtHnVmnG38cqV9P4wgvC01iuKfSnHyW1Cu2Xk30NrwLgo6UH64CGdFk2uskKKyKxHHuQQmBun3+urJOYG8vq3KksKme9KjGedYNUGE2wPJbbN0skbVmQUeoOvtiBQSCFtVCB8uGX6uC9J4vH1H7W0qiVHTZiPr6+zopkBWx0wKWiEyi4p/hu1mre9Lqphg3fZjxbSKCkseE5XXrg9BCaHNHw9+ueHvKkec8CFzBGfRGR7W65NUWvooElSpXW70tN7aDLzxvK8Y7n7siDbMkqJuWmE5yQxcFbtKaZQDcN0Cg0uw7mWQC9L0rV9Gxki+eTOKWMjJnxV2
 dVbKk+2q
 Bc2ySGZZPDRaBoxxFfHU19FbfIvhf5WJ0o8yMp3BpQKFYylgtu9lWYS2obqrySB7S1zTUEmbX5hJJgDoP5xc/rlde/mlB04q9k5cQZ9o6lrZxUjKJmRSZrUblwlNEzTJS5EX4v8pBLRVpCUudVHFaDLkhPMWisV2ICiBl52sh0srhqWICkeNHUzJuAUZ6ODYTZN8AlejjeQcKu2gNJeWrV0zDO7SgGmz7dWfxkXLlpCpSlFCscxtdo029ygC5f55xdpG+Gj6NiXc1HwGjr25FzlLWR9B61xNVc+X5AJZZZBnmw9U=
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


