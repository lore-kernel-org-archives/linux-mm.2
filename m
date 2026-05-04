Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FBCBFF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 08:25:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A70386B0099; Mon,  4 May 2026 04:25:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A22506B009B; Mon,  4 May 2026 04:25:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89A086B009D; Mon,  4 May 2026 04:25:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 769616B0099
	for <linux-mm@kvack.org>; Mon,  4 May 2026 04:25:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 29A17A02DA
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:25:52 +0000 (UTC)
X-FDA: 84729054144.08.00EB0A7
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9F144180004
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:25:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=PdTov3oS;
	spf=pass (imf16.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777883149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=moIJIypDjtmZnGtHAK76laQuaSh8Y71cRRNVJavHh8k=;
	b=YgYwum4FQcDWILXXMf+7ONuEyJrbLzIDFBNobeFSFSXmhgpY6COumo+w1yYrInu8rSQMLP
	oJSlrCJyhhIeGugwqk+I8VyOUkz56tdTAor858T8Wr/+B468dAnHx1Eo5ycCGRlddpF7ic
	UTmjILXkA+nG77m9FPHR06Yoz9wBBRM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=PdTov3oS;
	spf=pass (imf16.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777883149; a=rsa-sha256;
	cv=none;
	b=N13PvPSAe9GSV7Xd9P407w5YRU3NnYltOONBrnOdMOsdgyUd6VWnsSTknDQsBjXqGJoCHX
	IkquFdqVlZxHnRsAlMCdrz8fdMGzMrUQh2mu15cj409NcGoK7mxd2IxkRhg78mPdCJDekh
	+QI/VN5cZMk+6nLHJnDzZN+GkSEmKuM=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 643InOlO2280958;
	Mon, 4 May 2026 08:25:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=moIJIypDjtmZnGtHA
	K76laQuaSh8Y71cRRNVJavHh8k=; b=PdTov3oSiXlEpY/JsU5ShLROWVd8FlVNT
	JXzIb8pHtJ1jTIuivkx8AED+4DEfEXdxf+rkIxL9HpGOATFy8f8eACteugmZSELS
	Z67i4ZxdQch7M/cpM2Qep2PUv7C+tbeEMR6SEuZrNrN48rN5udlg9B4QLgCJoQVJ
	IzIGI+3pBjAi9+Mtk/7y6WjlfmRW0aj/TXzJ22z43yes8xj6wUkc1j7oZQ8QElLp
	V9wnnhl3xddZX8KfFP3WGW7BTP6sB3YVXTC4NbMmV4S4KGFZgq/6CLdHUZHPtM89
	gSPBhPBjnzk2kFWCnhxfAQ2knAucNW/OG2iwIR0GbD1yRntFgdabQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9x4e3s1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 08:25:40 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6448OOd7023531;
	Mon, 4 May 2026 08:25:39 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dwuyvve9j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 08:25:39 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6448PatS26018426
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 May 2026 08:25:36 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 00DE22004B;
	Mon,  4 May 2026 08:25:36 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 06D7120043;
	Mon,  4 May 2026 08:25:33 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  4 May 2026 08:25:32 +0000 (GMT)
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
Subject: [PATCH v6 09/14] selftest/mm: register existing mapping with userfaultfd in hugepage-mremap
Date: Mon,  4 May 2026 13:54:46 +0530
Message-ID: <d44a6928ec374ad740e1f2b73ff059b2b680ff3b.1777877814.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1777877814.git.sayalip@linux.ibm.com>
References: <cover.1777877814.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA0MDA4NyBTYWx0ZWRfX3QI6zhoFeIPq
 Jhy3gEWfDVdNkdSQUQzVq7BcVcFRIJQ7lh8FTHqmQHoUcnRZw1dyO/46epImoRqwPemPFcdaVg2
 dL4lFQsGp8cL2gA7ZZfD7s9mLhe9l7dTRVVC4SBuK12TMK0Lra8faFC0N1Ln3X+3e5d/RW6G7JV
 87RYalSH1dAL0eYjOa5K7mFya4sACGZNkK2eXCvWtaKJ57f4gUfv1Txrh9dCkDIqm+V61nljp1y
 /+hrTQvZGx7e4BiiI5JGDAzATVwQlFeR7vzID3xZmFWMf/w0I9LaFSv0Wg5XUIYErBRflyqWJ8T
 YhDxaKCE5RTTr1QxdnXKKhJOol9eNIK2x0+En4oyT80B0SC+9bICMGTa/WKALzfspDVJ7xevssi
 mLIS/u6axU/yDY2pgZYkycnTbwhUSlWWFVwq/Zuc8jBO4NsvH5vJXkz3RkST6yyCNvVy6ZlPCjh
 vfD7RDTEEjCXTYfe/0g==
X-Proofpoint-ORIG-GUID: uPn6RHkmEbhPoeqYvp2cKeh83IV8X9Y5
X-Proofpoint-GUID: wfQhWfwlxQb2Uk9D0i_52QNHqRi6jSjT
X-Authority-Analysis: v=2.4 cv=W7UIkxWk c=1 sm=1 tr=0 ts=69f85805 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=gVE5Qc0x_BWLnb-D2gsA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-04_03,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 spamscore=0 clxscore=1015 phishscore=0 bulkscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2605040087
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9F144180004
X-Stat-Signature: t8r1bt5ht7gx871qraidda5xnootif43
X-HE-Tag: 1777883149-428677
X-HE-Meta: U2FsdGVkX189/6Ttr57FEjy0xQ4KZbBpJp3hALDWyb0ZCOZiLelTLa+e1DsTQT/XLi/RDcCuCo7UUzwEoaflGM5eaxoCoDrTyfAaYa81iGZW3YvSF4d3tZ4qbkTocjTaE5wUBeL+sqG0C88S0985MsrtZapjgjkslIIU7Yf9ATuo/I0JU75ojZkAehJYQ6IdKmrNHPAZGupaFgE3/fwG9BVIQy8Ob3lO9pXqNrfZa43DgSoDoeFAHr0yoQBlITRaRxwzPrzZsbobRvuAmw4aOe1Igg2LQNMH/d+dhog3/SD6NRpPmaRStCxV9rTDrsTGHwMUkxoKb/NkfnMPBcPXGK8/MP40bZYWHwVT6QW26XfltzJnsCxHddYUQG7KDkKPlTbsErIIhl9ntPTee9pC9clTsYVu/ijB3efXkonvY/HYov+ksy/A3yvChyS7aMkokq0I4t/af8JCuiA3VsGHWfdggvnAtT3i575z0BLOzJWXKX8IUpa7zlraRoPi34SUdxA6klwnrFJfvK/htz0atQNxpEmmk8o2QWy5CWvFptgE8zxEow6itzywCv/Jk9+gVFfD8F+V26PRN12wPIB1XJ6WLA09XGrgalQXuYduwqU+5V0lBI01S7YilQFawCYMWW3L4gM0S7Ucio31+CP+NBNlIZzBCeLAhF8hBIc2ovfdpy2nI7R5sUZf+tNT6ZYMh4HYP/FQ+nIU86eUswGBKwWn+e4c6Q0jb0o/5csfK5N7HTCApSpVF+ILJHDaWseG9v0izQs5C7SZ7Dy5siVSquQLDIa+EDI6jubdfKDtw8hQVjbvr4NGeWkMkBN6+ed148uQBLyMIhr+BllERPBGEh5x7RgbROe4HEyxsSgMl/ZAbuTz/8X+1My1sW7EtZpc1CjAv66w30p3CVMNMQzvpCkAtSn4JbOGaF6T1bGMk6Gd5uu9eDv8W7mwL1K172hGUffalhb2w7Hum4MYzSb
 SzI9rGy7
 SATIsgDrfZihUD7exOkXosVNjNO40GTrcgdO6XWApB3RspvF/4WEO9hPcCkmtEgo934r7V2VXOmlRjhbfETPjCcWbzXDDRZe7Feqsa0i4z1ju8z7+cyC2fFKsi0GGoiy4sSjP8X2LasMM0uog2kvoM2d0uMc+9cZCsw7FwNCOU4LaQ0wVdQeFNhhCkoCCl8k4sYD0f3gC8q1IqB/ijDStj529HLJgNU1FdiEZx0QXpY7MGV1Pl55KA9RNyHMsDlM+2DaNeWps3WM6IHvG4PwrLArXBazk08kHadnv7hPoQaUA2RQ=
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


