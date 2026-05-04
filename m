Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 845BDCD3427
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 08:25:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2B7A6B0098; Mon,  4 May 2026 04:25:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE49E6B0099; Mon,  4 May 2026 04:25:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95E676B009B; Mon,  4 May 2026 04:25:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 873F76B0098
	for <linux-mm@kvack.org>; Mon,  4 May 2026 04:25:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4DDA6140365
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:25:51 +0000 (UTC)
X-FDA: 84729054102.08.FE41532
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf24.hostedemail.com (Postfix) with ESMTP id D6B4E180009
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:25:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=o4yXdfzJ;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf24.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777883149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PIfsNgy2577DuXl0NOF1ozWvbjY8j3LLjpYwpQBtv2Q=;
	b=Jw0WvI16pyznwaIkUatZnwGEiaPpeUQA/D7JnlR19uajmWwmOFuQm5Slqs24sD8SSUHcL0
	rdCrgZVbnH/Ks8MS9aeZ5auUMstKBVakVCmDAuxZVCPsB96pm5d0mGcb3nJ/HvFC8mBsiO
	4zM8q4vg98wfIeqWwqmPqOMonaNP5Yg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777883149; a=rsa-sha256;
	cv=none;
	b=AboTlO6hk2l/TMd934MYwoFzjLMHFB07o9u5XGftXAlL5a/yKADHayn8j/GRhjSaGY3OhG
	vafJuvgMSgrd5YhPNSQInj/AkUOeihUAzMFKGEctP2qNcHLFTSx9oUY+zYiuoOjZWN1hHe
	iO6bfCntyxpLjYfc7lUMPmGufXjKL6k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=o4yXdfzJ;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf24.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 643CFGLG1531488;
	Mon, 4 May 2026 08:25:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=PIfsNgy2577DuXl0N
	OF1ozWvbjY8j3LLjpYwpQBtv2Q=; b=o4yXdfzJXEKdM9ctSbJ7nZ5nMBSxDEn2V
	UMXzSRgs69qg9PNlPGLFiR6liC7wreSTA/tf/Q10jJOJb3cTgROicAq+5YmHiHuH
	A3s8XhiOKYMOA+GM1RjDTRmMYLuk8BfNs/jmYrUAe5uwJQCWaKXw1dam23+zGbxv
	2CNQgnWvOJfeH+HShmpHVdyTtRBFQwjdg1rwOrW2PTIriGrgSh7QSvA7dZn8nPPf
	/QIM+Fdi2stovz/Oc184WbGsGzInQvZZmgikS0vFWzAGgD8d6PypGpufu15zv2GR
	+7I27oEYDAxYAJr4RId1lf+h//pZYwF2l/7IQotL++d2rbRVrBk7Q==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9x4e3rv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 08:25:37 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6448OOUR031438;
	Mon, 4 May 2026 08:25:36 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dwvkjmaag-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 08:25:36 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6448PWAD52035922
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 May 2026 08:25:32 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B54732004B;
	Mon,  4 May 2026 08:25:32 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C7AFD20043;
	Mon,  4 May 2026 08:25:29 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  4 May 2026 08:25:29 +0000 (GMT)
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
Subject: [PATCH v6 08/14] selftest/mm: align memory size to huge page size in hugepage-mremap test
Date: Mon,  4 May 2026 13:54:45 +0530
Message-ID: <e1e479b77781396af366fbb9e8dc67591f3de8dd.1777877814.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1777877814.git.sayalip@linux.ibm.com>
References: <cover.1777877814.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA0MDA4NyBTYWx0ZWRfXyaTO1JwJT2VU
 ScHvsyZW0Ghn73J7ZqVn7PaU304cb2c/cq5vGwsywHyQKdqx02GU+Uhg5HJ7nfjltsOuNVlxI1R
 q5FTF8v37N9kEptrYgEQ5QrtOfuMgq55H17yGp0a7RedDdiEu5s64RbrZlweb1Wnh06qU3aFuhq
 UoPe/Rvb4vWCOB0xbOMxkurpOt6/0+W6Hroo+isty7o9tFehuxTlZ+ngwzZSX68hkPbWbnSTnuM
 mrsbzENUUi4v2qE/YSHkqImPRgugYEqdRsRw4xBuqVX6LSXzo9xn7Ilyfi0JRFPnP+eViA9na4X
 E9UNFpaab4VBjhfJITXXzk8mBPsWtSiAr1DsLKjYDxHWYezN56e0du5YxCpeuS7ZwlL7l9GHWC5
 lzUAhHa4xuLqQS6ou+f4xzgfgSxY9rScsBwAy/KPa1SD87anpPPKNd7xa1Go55794fBjbpwoqa+
 fgjZYNHNZ/ioFi4heQA==
X-Proofpoint-ORIG-GUID: 2Uwy9H7FEZSR6yeaU5GNKtQj-CrwYhqT
X-Proofpoint-GUID: sXQvH3R5Y01GydUO8YLje9bEh_SBBbl7
X-Authority-Analysis: v=2.4 cv=W7UIkxWk c=1 sm=1 tr=0 ts=69f85802 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=Ikd4Dj_1AAAA:8 a=VnNF1IyMAAAA:8
 a=7t5IiW4R7ddU3FUDOzEA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-04_03,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 spamscore=0 clxscore=1015 phishscore=0 bulkscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2605040087
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D6B4E180009
X-Stat-Signature: mzad96z9se7x3k9dm5j1xyak698fefrh
X-Rspam-User: 
X-HE-Tag: 1777883148-532257
X-HE-Meta: U2FsdGVkX18wuVz92Eboi4i4sSFdMgsu0jrGesao3eKDa0MGZMwa34TF+Dwy048DWg3GIrzC49Ow52/yms03spTda8moxX4+0b5v1DvfRHJ4uPtNmyMdzTakuGpattUgNcynwxA/Bszm4DaAG2vzvo+87MaHhGW2PD2pGhmMptBySqryY7+PDglWNDtyhy8Hr+/4kq+MgCKeU69WZHfDzlutA/60T9/ACaK6LwbLqzNDWFkQTkcr473ERhrJKfye0w9Ag8KFzKVPG8rCJAO610gNOP7dKdD9sv8nDhE0XKn00rIYdjyFIEmuklcsXaCVImWRAlehmjwVE5anQTVI+p4KIHG3aeO1wtlHFPBzg//YQTP4mo3yvk0k62obn3zf7YtCuNiKfAyoF5D9ys6W70A/ie2dUxdIA35bUajArHI+BtQx32IMpqGw8DjEJBVsPMVoQ4P6sbh93JEEtQXrBCCBMvgi9o9AzpAY/q6p4ydElxw84kLixsZFQRs5SmqfMMhIqlgGsrwuc/FcvGVVRYDextwK1nvwKGZsXEHN+Jf1Tf5Ah6GOBjZ1CcD4QCPUTAGGb0x8wcWFIXyfkn9sAQcq/ioean9Sq+BBQXTIGz9InZwLodA0HvL78NTmH3/37BhfIiYOQ5Woa1OMHiPUMGKojF7gpoo38pt4JeMtx5ShWq8qKPqB+HJtHfY39DkUBbDtWPvD7pACOrWw6pF8UEnVcc+iddWf7D3kBR3uc6u/AoFp4uKax1VJUSRDmaxd8JWPdvHH1TUmdAf7/7OunGgBk6Y874Pig4dv/DFMTrzkPa4jmlrc4ZID1sCYphv4I59lXkVpcJ6AQxnRGd+bKHAt5kTRiHQScBMtkzhHme9MT7EOkGDmh0vxgJxCdo66Ghxi92N+3hLE2BqWQdnuidopHrKBzsBEtbFuBqMRlbCIOifV5AJdmJYAm1PCejPQ5SWOOIBUhvZx52wYU++
 h0gNd5eC
 ByWwqLNrrNfqM+DradyY9URHgWMQja+yESfvUyNdEf0n6TVWHBZXE0xYzn2hu11RZaWX4pwlXrRfIUK676dp0DnszmyeO5EWIHuELeAqd8idtvNdjq3Xa02/ClhNAMf/FNWYD1gVe6/SqA4uRnX/5Py6ruXjixQGOwacM3LILHSnGrkkwx0VGD7wxEqa/XiTFZQ4m9H2AU8NdXX6KMYhtK0as01oQCFohZBvm9byCUzyavWkiE96IwxAOLrUYVScRaIqPP6/dWA379f28sS5rQ9q4ePULLnHaGFvqASNFaEWwwxM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hugepage-mremap selftest uses a default mapping size of 10MB
when no argument is provided. This size is not guaranteed to be
aligned to the system hugepage size, which can cause munmap() to fail
and mremap() to succeed where a failure is expected.

Align the mapping length to the runtime hugepage size using
default_huge_page_size() to ensure the mapping is properly
aligned. Also handle the case where
default_huge_page_size() returns 0 by skipping the test.

Before patch:
  running ./hugepage-mremap
  ------------------------------
  TAP version 13
  1..1
  Map haddr: Returned address is 0x7eaa40000000
  Map daddr: Returned address is 0x7daa40000000
  Map vaddr: Returned address is 0x7faa40000000
  Address returned by mmap() = 0x7fffaa600000
  Mremap: Returned address is 0x7faa40000000
  First hex is 0
  First hex is 3020100
  Bail out! mremap: Expected failure, but call succeeded
  Planned tests != run tests (1 != 0)
  Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
  [FAIL]
not ok 1 hugepage-mremap # exit=1

After patch:
  running ./hugepage-mremap
  -------------------------
  TAP version 13
  1..1
  Map haddr: Returned address is 0x7eaa40000000
  Map daddr: Returned address is 0x7daa40000000
  Map vaddr: Returned address is 0x7faa40000000
  Address returned by mmap() = 0x7fff13000000
  Mremap: Returned address is 0x7faa40000000
  First hex is 0
  First hex is 3020100
  ok 1 Read same data
  Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
  [PASS]
ok 1 hugepage-mremap

Fixes: f77a286de48c ("mm, hugepages: make memory size variable in hugepage-mremap selftest")
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/hugepage-mremap.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/mm/hugepage-mremap.c b/tools/testing/selftests/mm/hugepage-mremap.c
index b8f7d92e5a35..f66e4d806477 100644
--- a/tools/testing/selftests/mm/hugepage-mremap.c
+++ b/tools/testing/selftests/mm/hugepage-mremap.c
@@ -32,6 +32,7 @@
 
 #define PROTECTION (PROT_READ | PROT_WRITE | PROT_EXEC)
 #define FLAGS (MAP_SHARED | MAP_ANONYMOUS)
+#define ALIGN(x, a) (((x) + ((a) - 1)) & ~((a) - 1))
 
 static void check_bytes(char *addr)
 {
@@ -110,6 +111,7 @@ int main(int argc, char *argv[])
 {
 	size_t length = 0;
 	int ret = 0, fd;
+	size_t hpage_size;
 
 	ksft_print_header();
 	ksft_set_plan(1);
@@ -126,6 +128,14 @@ int main(int argc, char *argv[])
 		length = DEFAULT_LENGTH_MB;
 
 	length = MB_TO_BYTES(length);
+
+	hpage_size = default_huge_page_size();
+	if (!hpage_size)
+		ksft_exit_skip("Unable to determine huge page size\n");
+
+	/* Ensure length is hugepage aligned */
+	length = ALIGN(length, hpage_size);
+
 	fd = memfd_create(argv[0], MFD_HUGETLB);
 	if (fd < 0)
 		ksft_exit_fail_msg("Open failed: %s\n", strerror(errno));
-- 
2.52.0


