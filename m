Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D3CBF41808
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 09:51:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DFE86B0096; Tue, 10 Mar 2026 05:51:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63F266B0098; Tue, 10 Mar 2026 05:51:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 538306B0099; Tue, 10 Mar 2026 05:51:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 41D2C6B0096
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 05:51:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DF8EB8AC75
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:51:05 +0000 (UTC)
X-FDA: 84529684890.01.AB0D8B0
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7DB031C000A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:51:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="Od/LAWI7";
	spf=pass (imf20.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773136263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wbiCeXnJUz5HQgBXo8t0Amh91hTzrPkZ2zHwkuS0zo8=;
	b=otQh63YuZB5iRfSzuXPgQFpsZ9RbjbYt7mu6rmYmEjgkf80hAJ+P1GoSnxHRyveQIynUrJ
	ZVeqH6nOSuPJHWkp1nWaCASrUJIx1vdbMHdFcScQTTd+E2aQpGgwJIoc2ePXmrzTc90Bn5
	81UrLGfchoSWow8ya7CW5QISCPjKWlA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773136263; a=rsa-sha256;
	cv=none;
	b=ozUKyEm2CQI2xsKT3vypiWMZd+F6M+tSQOpqQXPw0NPPfCOX58Omeb8M64oV52LCm8P/1C
	mKJP7dCzeR+8oIE2nrzEPg6CQly0HiYiJzeX42fLJ7yTRkacYEXj+F9FJ76Vb2tvqDe02r
	+9tAremjRa/Kh6C1Qksvf1h65sbDoYw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="Od/LAWI7";
	spf=pass (imf20.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 629FulM81671245;
	Tue, 10 Mar 2026 09:50:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=wbiCeXnJUz5HQgBXo
	8t0Amh91hTzrPkZ2zHwkuS0zo8=; b=Od/LAWI7WRmIh0yeLybSKFlJJWdYJsBhL
	ny04dw8rgYVdQXC6/96I6k/t16ek9WmmS7n1CWl9LpeihpQfeBBRbnU6c1+1LlYM
	EJFzEFUYsYGgFcBnv1Uhzl62HWfBXC8ABoBKSraTeNPL2KBwjuvnRhh95m0ofYjQ
	QnwjydsMcFaHv+B2MyPeTtS1e+FmoFb6VXa9VsU2HeEO4MhHJUUkh21+URwYe9VU
	mOZb9VJPhSIaHtOXJoCIk/6tcl0wAQh9kHkTMkBmINSlWxNHYMr4KHxrdVeX9oe1
	Skxpd4FjMHaupWk7YJQqEaNDNHyWUAS9WyD4uprGMc04yQ8l7D9pg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4crcvmab4t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 09:50:57 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62A5xUUw015633;
	Tue, 10 Mar 2026 09:50:56 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4crybn8jc0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 09:50:56 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62A9os9751511682
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 09:50:54 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 66C742004B;
	Tue, 10 Mar 2026 09:50:54 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 65BD720065;
	Tue, 10 Mar 2026 09:50:51 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.in.ibm.com (unknown [9.109.243.201])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Mar 2026 09:50:51 +0000 (GMT)
From: Sayali Patil <sayalip@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Liam.Howlett@oracle.com, Sayali Patil <sayalip@linux.ibm.com>
Subject: [PATCH 07/13] selftest/mm: register existing mapping with userfaultfd in hugepage-mremap
Date: Tue, 10 Mar 2026 15:19:25 +0530
Message-ID: <a2dbb11faee4041420620f375b2f80d43ac9e482.1773134177.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1773134177.git.sayalip@linux.ibm.com>
References: <cover.1773134177.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: 6_PfyZL8ng7jhAMBZQ3Y_N4N7PY1EbKN
X-Proofpoint-ORIG-GUID: 9bhqwaF6FFiHWTd9-SKHyrUgHZiAVG0u
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDA4MSBTYWx0ZWRfX11mMfSWgTrHf
 rFz3NNj43LBzPEz5ptPAzgbQHpDxjqhHFOKPO5DYL0Nh5g6U6MmBv1BZyZHWytsauwepxSbHEAa
 uKFlQJpFll6n7P9AXSCbXdMXHeN+J0ZVtuAklmKKtWBCxJ/FPlLQ8yEbyBgQSgTm/Kv++u9Qakr
 HbNEWQ/ww7IVkU8sInPJ2ag8wqPiLEjKPDRYZBYlElX172zx4P8Ze3gYvwat20jAl5hWRY7TI74
 HHPUQL7UdVwv0RXekLWql4OlzSRZ3PJDphl0INCMJIOSjPXoeUTHP1Kye3rowhzGt6W1GjbbXp5
 CtvFLeDlsVsL50UWlHnCv2NK+xCKcNIumOAIqEuRXkPF4evt3n5cEJIYXZMXSTGiIb7d9F5OrH5
 alOuffQKXzmM3gPq0vR5czHz30IRYcYOobASeDvZWee8j86SGO2H+IwiBNHttdfvh0jegmmYbkr
 nIwmmCgyf9bI2yLRLww==
X-Authority-Analysis: v=2.4 cv=B5q0EetM c=1 sm=1 tr=0 ts=69afe982 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=UzeAtlymHpVVuFnOBLkA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100081
X-Rspam-User: 
X-Stat-Signature: if9i3ra9ikhqut7aq8a9xbzdrk845pte
X-Rspamd-Queue-Id: 7DB031C000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1773136263-946521
X-HE-Meta: U2FsdGVkX19Bs6yILGfxDEaBtZ72QD1vgUybLSH84nFQabV+XDChY+0ZTkWHQqyrloZ6bHQcSMtrWm7AyiuLDx1f/0uwl/W257Jk/G0RV/qxsIw6uzUYbGGVHfqvp+KJUyjb8SVOtFP9iJJ+EWjQCebo6ZAswGZCJhifJ/Fr4Lhr0dvoxiTxE1Hh+CrG7xNNXEH68/byEs1vFC/Fd4hlMDds5ZmiqGPRmWSqKLrRZ1RZbthBl6Me8eJ0gGmLMmRp2y5mrw0HVOPWU+YkvhHjrdFrDy18/OG+w6J2qEWFpl1vkTrQHdjar+CqyMIqbaz6JmG4mcI6asexHhIzYkFnSpWHblrbR/JDWqrkV8etH8uhIQrYNPCpEIF8p6yeJg2uB3M2AGm5s+NFgSjo87d4IkBFvn7QMt/PX3prkkx1dtPzAe9fVxqT1PM0AGyppGdhydnnV82C8PxgibM5HaqcfM3MnXzvhmMls8a9Lp9CBpbHdqOC8oSW3itFqZNAiW6+4UHnmbHhYV8RJESinv2YrDD+qo64RVzWhotesRUuhK6/RSanbDvGCHZy6RvV5JMAnyP3L9WQZVXbXs3qCzJKDWU46JUshVI+ROTdvkgDqpz8bku68jTKkzSJNB4pNe1uqhNK7vbvhNKatvckV+E8aBX1HrelS5hXLDMzd816RYkXPUTd7Pbu1EwdlBjz3RqPNgNQBhFzwa8YsM2r51Pvj+hclnGoKTHiYPWhMxiTkJsUky3T40/Vx/2NfERID3v3T16pgk5HIMX8ML+tlfWVnvDhPVhLSsPwLs9eNK/Ii3JFNxjhBreWUFK3f1WiLOe9aPD+fU+JhqDV7f4RJXoDduQFrDUbiNOPhu+t8lUapr1mWXZxewMVczZ4+fSXwIPGhUdbYY9owrw0SEzzavbR/PMCSrUPDdUefh80pQzwXz2gDDYnwSsJ86sQr99QdRd3MDgc4Vgx5mqjNbSNwxP
 fxVgTlqW
 W90F3iO9ub2Vko9S3+D7G9nddq1Vc8noaZx8CqtQxoLPQ3N5SLxb7QnOiUA2nSrjHUCaJsxfuw96lutiKpJ4G7Ovei8t4HyNQZib96T8p/B85/CydP7sXZxx5eaOmhTq1AaYxv1MHYUNUwOCckygA8emrhZm1Cv0HqBGnyRiSuU1Q54+WPmRqHcNufOwstGKpObExlWwCh1L/X5ZUXbX7jXQ6pFiXg1jayI1Wd8VzATVUi4DHrxD8a3IZ3wsR9GvIqxMx5xP/w/53Re/HmDK+0MayZw==
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


