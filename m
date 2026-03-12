Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E495105A591
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 12:26:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECB0C6B00A7; Thu, 12 Mar 2026 08:26:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E82ED6B00A9; Thu, 12 Mar 2026 08:26:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D24566B00AA; Thu, 12 Mar 2026 08:26:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C0C5F6B00A7
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:26:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8D9AB1601E0
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:26:36 +0000 (UTC)
X-FDA: 84537334392.23.DE32EF2
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4676A100012
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:26:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=UwNuQPq8;
	spf=pass (imf05.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773318394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wbiCeXnJUz5HQgBXo8t0Amh91hTzrPkZ2zHwkuS0zo8=;
	b=Oj1p6m6XmVlVkWg03Jg1/o3I1lZKnqnJudjsOh56zwyYGBB0GYGoVPt+3Vw4Bmj3sJEKBQ
	xV2uVvF9LgPlXXDwa3gt9Jn2S5s6TTTfC6W3L6fre7fWVulWB+63lenuaKGaLLHHesa8vF
	Ocv0SV4XgG6K5RiSH9ngYyGtNOOzHbU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=UwNuQPq8;
	spf=pass (imf05.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773318394; a=rsa-sha256;
	cv=none;
	b=VgkKUW6MqKXQvq7M/zuXLhzqEuP5HcvizLrD1lBk7r3vLCaCJPsQlbLCpMs58cj7CE4+eR
	pknHZ58YbGxiWj5i6boFImVNrKxF5MkW6hKQ/y1irv17lBecytJt+lF1Wk+pLAmmhvhYAn
	0B25SaeMTmzYMc7YPH58mMzLU/KgH6s=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62BMXQdI2308712;
	Thu, 12 Mar 2026 12:26:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=wbiCeXnJUz5HQgBXo
	8t0Amh91hTzrPkZ2zHwkuS0zo8=; b=UwNuQPq8/Sw+nATUSWgQKexlFYS95Q573
	DT8bOCfPVVaMAVSse+SUJYK1wMkhC4ohjppQ03U3f4bT8rERV6Un78151iayeqRf
	q2bPINZVwOHRD6FVDp+3vQ9h33kyhBtFvr53TR3kN1p0RxySDSDPgCDMijPh5z8p
	PreQazbfi4Bd/ni/kRTdBwVSZP3QJ7KOTM7dhCWZ27XidnRtVexwndaIDJ7VSw23
	vZ49eKsDFG/WznCOUlUdlo15tlMMXep9PljMyV15c92zJj4/95T9J2UxPqS84uH3
	yRgJ4W0mXccRwdj/wtWA9rP8GTMoXtWCiIUl7h4nhoW+Oa5gjRkMA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cuh96agtw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 12:26:28 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62C9KIKi008820;
	Thu, 12 Mar 2026 12:26:27 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cuha72986-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 12:26:27 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62CCQPgL43254092
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 12:26:25 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 740BF20043;
	Thu, 12 Mar 2026 12:26:25 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A10BE2004F;
	Thu, 12 Mar 2026 12:26:22 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.in.ibm.com (unknown [9.109.243.201])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 12 Mar 2026 12:26:22 +0000 (GMT)
From: Sayali Patil <sayalip@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org, Sayali Patil <sayalip@linux.ibm.com>
Subject: [PATCH v2 07/13] selftest/mm: register existing mapping with userfaultfd in hugepage-mremap
Date: Thu, 12 Mar 2026 17:55:34 +0530
Message-ID: <da7ec96ee85ccfdb9bec704c6dd534b419212f94.1773305677.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1773305677.git.sayalip@linux.ibm.com>
References: <cover.1773305677.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEyMDA5NSBTYWx0ZWRfX2AqLR99hroQA
 LJ1CWYLov1iGnIWH+ofXJZhMDMpVci3I6SgDmpE96rl+qfvSGWI5EZKlW8l5B7ImK+rTn7S122H
 DDae/wfimJL0e7GPSavkVXaDM0a+KixF5Dko2oSD3hcZrdK+EH6VmQibZmPh+MOpfRTWSLB/zrt
 TneZ+w6Wz+DJfPtslawIaBVFw0g/BJCWGSeLsdXExjtvAx7AMVfFZjnbG4XV5OAOFH4m3F+y0oz
 ggGhr8ManfTktzs7EGEo7X+0m1WIcl/paJ3AGwvei7bPkkAI2Asa2gvVaDUxWrFpcyehmP+Mu2Y
 Uk281lLfEJR+XdrB/CwkXCKy7GPHiztJTXaphTWomRJupo0lwaMim6QXFHK1h/vxWlHP7nGqsx8
 1iayNXGrD9df3UX1TzJb9sQJ9tve7km9TjwHPjGM9fQM4aYS5ACViEBWV7B5BzUuRPVV7jdWXET
 mCcLzUeHyMj4oVuaIQw==
X-Proofpoint-ORIG-GUID: GI0YqWGEzbxibiBHb9WoQVHeGCTXU5z5
X-Authority-Analysis: v=2.4 cv=RLO+3oi+ c=1 sm=1 tr=0 ts=69b2b0f4 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=UzeAtlymHpVVuFnOBLkA:9
X-Proofpoint-GUID: d_0rDaFF6mE7NRLcy5ipy-IbTdWeTC3h
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-12_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603120095
X-Rspamd-Queue-Id: 4676A100012
X-Rspamd-Server: rspam07
X-Stat-Signature: k7w5hkgg561tgnnricymegukmjb757dj
X-Rspam-User: 
X-HE-Tag: 1773318394-982247
X-HE-Meta: U2FsdGVkX18N1L9KSuJA0WF6DYMLPQeMVAjFBRum3rZAnE+Eudng/MQOyvbbAI67nibWXWi49dQl5kqWHbRWSpb5n1m+D7+ZqadIG+fHAifNpd7oTqap2EevTn6ro1ufajAzOLaR8MlN9eF1znmrdBBhm9V7vm2WxxdVotrrgq21XbhSrNPWMmPdD2sGJb3vAjzVkno7erBlmSpDRAQ7NLQK9KOvXWbsiCWQmad0CIWGRIhnJieNvllqc+fs3d7JkueO0FyRgp6n1e4G2TV4FH3laqj9Sm1PfZGVNy3lopocmCwGipwvasjCj+nTkGoYky9mBIN7EZfiGG/UXdw8OMIeEafYGd7y+n1b4pt3IMK9xqH+VyAjyJO6z28cREv7NHDzMKIL+otwmuX1u5c/TLAe+N6F+VoJ9eIQQJYO3its5AHnWdtNCdN7jwqq+tYIYfWLm1ym1TjndywmaQYZRtfw5W10JLN9BcuK01RSTq3bH4Vk+F0+dSkUa9kE8CmTHCXjNDiQspRXhNM6V7MbQFGNOuagxl+VHNcc8lW1JU5TqYIRCTStKl8zu/Y6DEnXG4lHpNvjpeg2zimE+jMy0HvFN0EILJYZOvcxxxie/RL2kZEvZePGwxWflvzf04FDV97zLGmUjiSwVyneWhlwGgzu9YiaiHs8tZJWrFBgzxHcLcfCJxzxFK25TxZBMVWryfi4fAgQW6NLl5MZWXt1W8yo2pc2YkBeSS3GuhjOeXXOvsre2TlgW7xcmwi5RA2iUReB++M6esIPpNWfHTPnq55pJRxohI6h3CIM7KIb4YKWrg2SaukzpqD5aooqZWuFZpYtwFbOARR6OsOl09Z01hTUHEQhGQTitpLc/Liz8vCkKs8srQv4md72echsRStzPkE5qIIeT3At2qAH+fa8d7W7f4kLcjFcefAu4+6H+dOJGHGibD5z80ItZW19qCDsLa4S09l8sX78WGWfHuK
 gHcInqlk
 eoEtg7MEhdR3Dc9AQfkBOyLwe/OfEclbGvvEirReP6kjEPA0VAuBhFZhAtYz1pnKJX8hp+5kpww8xhNKKm1BvKDmpUQpnZMYhZnkKYcwX3PmJJdt/TqwkxAeQy0oh+SoYvaLXaJYLTPfgLR0pr03JKx6GmxUY9Ojq47k8g3kgRrwTBdC2N3J099MEy0eDgwRCLlvjVHkwqVm7zJuJuxy1w0KHB7snEpwuW4C/QyEWz8eUqzptOq0OvPwyrAjWmavunC3OzwMnyxdI0Xe41+9JsEpf3Q==
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


