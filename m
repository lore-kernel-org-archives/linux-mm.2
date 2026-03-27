Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B2DC10BA432
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 07:17:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F5816B00D5; Fri, 27 Mar 2026 03:17:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CC9A6B00D7; Fri, 27 Mar 2026 03:17:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E2BA6B00D8; Fri, 27 Mar 2026 03:17:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6AD1D6B00D5
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:17:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2419FC3F0D
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:17:54 +0000 (UTC)
X-FDA: 84590988468.15.1D88ABA
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf19.hostedemail.com (Postfix) with ESMTP id D4AA61A0007
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:17:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=tVU1eHce;
	spf=pass (imf19.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774595871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kvSwsyZV69210VfD5D6z5SjcmWJKFD/pQTO5CUFcjLA=;
	b=Otjnsm7JhlwdbKY1exSX2Nua9epNCnnJa4Ev6aGJgUiGsu/F7Uyyt53fDrMXf1y7S+ooV2
	okO3savhIhANF+Te9F1OJ6BGW06epCpnXLw7reRoP7L1i4D4n9KIvAutEBumcG3q0EBh7h
	1yX1QQdX8lK3E5pJ2t4hwMV01SGqNBE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=tVU1eHce;
	spf=pass (imf19.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774595871; a=rsa-sha256;
	cv=none;
	b=ZN1fzTQCAQQg4Ou5fNX58VW2wmT7Lnirp0DJum31wwRbZ5JhnsJkSYHioVXciKpsE01qg1
	4C7lGqMRMZAxd4VKUcyrTGTzXMi+TIFOU6zDmqpjzmXKRn+3pTuvf9yVKbivHv9X27+e+x
	OW3wAq7RQREEYO7mN5YWCkP1FpP80Ek=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62R1ApXr3826166;
	Fri, 27 Mar 2026 07:17:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=kvSwsyZV69210VfD5
	D6z5SjcmWJKFD/pQTO5CUFcjLA=; b=tVU1eHceyLRQIBEdrfDYvfJrkEFvg00n/
	QtHlsPk1q7iFQh5hFjJ6pdUryI/WeGMpz1wf9E5qDaxsg2tEE6RDtO+MSnI4eb4X
	IkiJXmtpBaksfUtrj1AeqbSfaHie6Um+fQBg+ZP8HD1AZ9QSvSPxTg7xtsEBVFY8
	sWWHCPNOvjNsJNTIiocx8iyC5ZQGCxBfrPNK34XYU6f9z9zTMxGzTd2Hnp14t4eU
	dMXqgHnU211OnFWVIK++dVI76EOwujW9nUFgwnHo/KqhWwM+gCIdUDv8cjQM9fsQ
	5ZaImWKkNyc6yxy6jYoTU5BghEe2EAJXNrr91y62Rkdadvh8Ugebw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1ky0fs8j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 07:17:46 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62R60MmM031605;
	Fri, 27 Mar 2026 07:17:45 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4d25nt6mde-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 07:17:45 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62R7Hg7h45351208
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Mar 2026 07:17:42 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 131C120043;
	Fri, 27 Mar 2026 07:17:42 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9457D20040;
	Fri, 27 Mar 2026 07:17:38 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.ibm.com.com (unknown [9.124.208.5])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Mar 2026 07:17:38 +0000 (GMT)
From: Sayali Patil <sayalip@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org, Sayali Patil <sayalip@linux.ibm.com>,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: [PATCH v3 07/13] selftest/mm: register existing mapping with userfaultfd in hugepage-mremap
Date: Fri, 27 Mar 2026 12:46:01 +0530
Message-ID: <b3a1760e4583340e767d4045b90784ee41c8773e.1774591179.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1774591179.git.sayalip@linux.ibm.com>
References: <cover.1774591179.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI3MDA1MyBTYWx0ZWRfX9u1XtTDz0RtJ
 /saUCpfsKs7W7mk5N9aN+b87pTZSvNDm13ecjtz1LVkEP+Az1h7rBAkMir94QlVaS/HvL1zzlhB
 ulyMdhaFWMSUUPtBzH6Z7ilIbJp3eOwC1bsXeR4d4jPDjBosx7GCAYOjF77nrugQG3YxuFVtgHb
 tyHj9fWpjCYFXet/oqx9hI0+So1pquz9MyWV50if+AqXB2joHpqL0AgbKhpUgbHArkI1Huk0i7S
 bZnyLlfvagvKz0s1rJfTwVyLrWAUZNn52qJJeUywgUTxVywseQ48bVprqw7fGLqCzj/uv8huGbT
 ar0eEXZDrs8/bT9//C28BTxTU2v0/GB65RncN2S0r4SvQ4Uhepxj1K4sLS3k2C5CrOq+t2h18J7
 E9wu2gRQSsJx9mfjko99U6Rk9KPrcchUS/O6nBNwvWfy6xRCd19al1hxltR/lCfBulIVe0fZApk
 7JLqjphAHeO8QTYtNqg==
X-Authority-Analysis: v=2.4 cv=JK42csKb c=1 sm=1 tr=0 ts=69c62f1b cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=gVE5Qc0x_BWLnb-D2gsA:9
X-Proofpoint-ORIG-GUID: BMMudRGFsuH85Xm8ZG_c2ep1t4brN6U8
X-Proofpoint-GUID: yWI22mCS8ME-p-jVV4eQGUqcWpR8TQff
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_04,2026-03-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 priorityscore=1501 malwarescore=0 adultscore=0
 spamscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603270053
X-Rspam-User: 
X-Rspamd-Queue-Id: D4AA61A0007
X-Stat-Signature: gre1idixntrn75kkp7uxi5nj7eoaihct
X-Rspamd-Server: rspam06
X-HE-Tag: 1774595871-722382
X-HE-Meta: U2FsdGVkX18c132psRLSRTLRaZZpp+y+fksBr0XCe+o1H80IZEtONjrwj+JTeSghyjkcvlyrZ10NrEk/lh8cLQ0ubzNuGfRPy7nU6IFnW3rse+xdehkuPewUJxFGPtuWsaLsobpFJSSVfkdzccEnYOCdNK1ixSs3ZvZY8gBjH7QCtcMMBHz0JbqKVug0pYcQDWf3zuMMLLfiD7dtWnvJG/nG/GyQ9DfIw66adusaY5ffxxYAMI2FNW7aeeq+gGeKGT4lIks+OG36B4W7jJsOam037QRkxsPHRT32XCaYjMXJ6/OM8soS9Ze+fp5igrGG2hMHV2k73Nr0lRt3MR1CAQ8rok50QDBZmNx7SbhovN5/M/Ts0/HuSG5QhE/efjs+cykT/bpx6OPpujFGsPOwZmOrFnZA/JEqExQ0Kn6tusrXbxdUcHxSkuhs9IafDfcEAkuHJEk2NtLonbZ1hLUAFm6qdFEprJe8G6bXrJOQp8aSy9bLc8W3K5TeCBvNUfUtzOloPuTb5uDSepn13+ZBYpHsARCHrOlTpnkeuzx25hAtBxlwp3uO/kseu9VbUGLWF8EVIM0ucpezon6tspM6noNEgfc3svzMtOuciPNRgKhld/t8SbtvLX4drdVJkJBvCJfnLeMwGcNn4JMq090jvNN1jj6P/iwRJrFsPqExEUA+D+VggmcsXZc01LqdweduOk7kvYtRMvOMw9pAaQZ2QQX9rwo5/zg3EUyKSTW/97bDGPN8S4yIzbC/CsGuzDGMHoECR2xQgTZyI5zzs6IL+GB85xNGpFlI66S3yqU4SHQ2dEnI+FvZHNo5aBfCbcUfatHLHgH0AcwJVCEtgvVLkmZlAaGtHZOU885F/DPsCAXTfWblzLZghrEdhUVt/hoNMKwqxqPnuxVHR4cGr6mu0PMF4FPMPOrTPYQ1EQ29OaNhDjkjs3A/uW6VtJMSECI/VTZfI/OM8e5WFf2Bmwi
 g4MEJGZU
 wVuOtYxDNCFpHOXEpbMFbzpkuqUTQwisWdXjRj7i9Dt3CgMiWnAa7LmBfRJqyWGp/x9Uv3pPsK7dZ54JRj9O4l8RZyEwCxAsRl5QGBYEqBNvuDeYJQE5jkcCzjTxZ/mW1Xg8Emzy+m9lSOyw3VroKAb7wspqezLemMocl+famSUuuuej0iYuRBGHHXHTJkFaPDyFQhyCRNsFNGptnADl5HmTnY7CrKInnlqEG/ffEo+VjkToARk0yuG6N9XZKVknx9Jst65hlB+venH2IOPbWf2Q7hLE8a3D4ajdoBVMgBtOBF2db1RevSD3ZkDXszPsG3tcUTSwd/LnggnkqyUDea80JyGqh2xg5Y30BZSF9LBiLO34=
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
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/hugepage-mremap.c | 21 +++++---------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage-mremap.c b/tools/testing/selftests/mm/hugepage-mremap.c
index b8f7d92e5a35..e611249080d6 100644
--- a/tools/testing/selftests/mm/hugepage-mremap.c
+++ b/tools/testing/selftests/mm/hugepage-mremap.c
@@ -85,25 +85,14 @@ static void register_region_with_uffd(char *addr, size_t len)
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


