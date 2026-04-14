Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE076ED7B84
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 08:23:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 370466B009B; Tue, 14 Apr 2026 04:23:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 320AD6B009D; Tue, 14 Apr 2026 04:23:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E8616B009E; Tue, 14 Apr 2026 04:23:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0EFDC6B009B
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:23:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 85619C1CE2
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:23:10 +0000 (UTC)
X-FDA: 84656471340.10.B954843
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2D1DC4000E
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:23:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Dy04uXgm;
	spf=pass (imf27.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776154988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PIfsNgy2577DuXl0NOF1ozWvbjY8j3LLjpYwpQBtv2Q=;
	b=Bw3tjy/zG+TXxZJDhXxI9V35LTvZGz8Q91aX1BzufEMUzdqvIRFMVPqhdJgaUoRW4EIzfK
	f2s6TJv48vUV8YoT7zlHPdEB9zU4MVD1zgpetliDg45HH7frSn0fc4VCrxqvmzR1JxWw3i
	j8k+qOwMtZ3s04uJ8AWRQmE9r4GsxD0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776154988; a=rsa-sha256;
	cv=none;
	b=n1MyJKHUjIuJjgEJFn7QZ+yLJWvKw3St6QtxHk4ZzJXlal6YlaRTnu8P5eg4kLi35DkqvU
	kY7MtLcbF6lLwC50YcTeb9Kw0pvMkicehVrTqsyXovr5pYSkFLAeCdkp6w8NOXa2aZR1XT
	nyj2cDY7C9JeU8nlszhHTDknKUCeU1s=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Dy04uXgm;
	spf=pass (imf27.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63DLIWoL1734194;
	Tue, 14 Apr 2026 08:23:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=PIfsNgy2577DuXl0N
	OF1ozWvbjY8j3LLjpYwpQBtv2Q=; b=Dy04uXgmJ6HQH2mkJWkMw48Lz+WnD5fi1
	PRe7XdJb+l7DPwFUTvRFjDxLjStHLLMsRLa7rICCG7ZsRAlmYxRt/3rnGbrYTm1U
	mo5Nxq6DfV1tR9ZNmtWp8uWhDYxiM3g/cnOc38Inhi9Mbkk+rJaXevnCpIGsQwH6
	ocOn50Chq8xKaf2cHDvO/yIocOduX3lwOqaKsPn8LGSfREm3MTKqYYuD7+bfBre/
	KiG71z+sOozqTOtYBPBbLiuGnFbqkcvO78QCwqCEG6PRJj2IJyYSpAUn9Hdr4UyK
	m0WsJOEeP8z/HthrZFVo1yBsNyOiQPAklUirAXACvIYyBws/38XlQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89m1pp6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 08:22:59 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63E605Fb025862;
	Tue, 14 Apr 2026 08:22:58 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dg2ujgec0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 08:22:58 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63E8MtOW54264088
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 08:22:55 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4A6E520043;
	Tue, 14 Apr 2026 08:22:55 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 47CFD2004B;
	Tue, 14 Apr 2026 08:22:51 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.ibm.com.com (unknown [9.39.26.223])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Apr 2026 08:22:51 +0000 (GMT)
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
Subject: [PATCH v5 08/14] selftest/mm: align memory size to huge page size in hugepage-mremap test
Date: Tue, 14 Apr 2026 13:52:02 +0530
Message-ID: <6aecfff81bd3e288e66af238f50f35eac0bd4ee7.1776150071.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1776150071.git.sayalip@linux.ibm.com>
References: <cover.1776150071.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=I/dVgtgg c=1 sm=1 tr=0 ts=69ddf964 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=Ikd4Dj_1AAAA:8 a=VnNF1IyMAAAA:8
 a=7t5IiW4R7ddU3FUDOzEA:9
X-Proofpoint-GUID: Ll73KCu9JhI0EZGDItcsvD_m4RnAukxD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDA3NyBTYWx0ZWRfXxq8CYlg+lax4
 dR6o50KfmRTv4slaMwr+lzQlXHj0GSIoVhDYBSYq70rr5BsqvGZK6TDce5pxAokFbgWucQtwV3y
 1LL9jZPWfBXF2w+tImKA8k34ShkXrj2vcMitORXDIVNqom8QD+Hg3ib2eKOFuyfkg3XgY3lDb2M
 jKVIIqImhDE9ssX+zijb0LuDmokK8JJjCfEO8rS/8ifn/PyFs2WYx2J9d0kCsMgGmWJfAC22MWe
 Y2d9txnoHD5n6kNcghnQzMlqwfU5WhbpAc4arxsiLuG4heQG3nUpKr0GrjW9ugh/h0OlFQxAjjZ
 bxavnR8jKN+3iM3ULoyMR0zY0JpxL9FSB5eqIsbCE9Y4OZsPP3BTGs/7Id9lT29kfn3j0Q8z3ie
 vzpPQb4TRKAzq0bDwwUuXqgiCjomkst3ze5WvuG7SBhXQruifkxre0AlRwQDjM7c10aW3ubC5m9
 lvikv3OGyBtsQk/OeEA==
X-Proofpoint-ORIG-GUID: RqjhDONzob-n3QKT63z9ZJOJjWZFSPJJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_02,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 phishscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604140077
X-Rspamd-Server: rspam12
X-Stat-Signature: z3cpihumsqq93hmbyktf8r97kkhbjyze
X-Rspamd-Queue-Id: 2D1DC4000E
X-Rspam-User: 
X-HE-Tag: 1776154987-113823
X-HE-Meta: U2FsdGVkX19LzZgkzpCXGl0hFGWivchI/socK5Ha3v+hOl5MeQoQjSdax35HEKAqshufsHZ8PD+CN6cRUz69gqvKkt4TjHFG7075w5+2msrIDTkg53UV5fiAnql49BNi7EK8M1O4c8YrRQMg48lnWEXq3A9xMLWDPkX/2l5ZzmEcqokxNPFKD+PjxtOZZMoZ/A2INuq26Z8eldWqeWdwxQz2VRB8LAAIp9PWMySJylrdFTWTNegPuMtHj3OyD87ns8/pcIU4MUpQSTo5/RaXNbbPOiqNcii0UpfD+Zoy2lTHQ7VNb2U4VfHwmvNNDwirqjbNIh1ZUPmTyascWY6WRD0aZQA/AwnjZYf5JodEBd7xpLaA35Crwt/CUEEo3RgIyFQOFsPBJ1WVEH7CIrZq231+l9gTngKWoPpNJnChnpuiOGEfD/mMdrbi3An6NxQ2gFIgRXHie3wCU2Fa/r51UucPmC4sseB3FTDqwLzcTTcRNH7YwEavFSUfOAk7XNqEO5TYFGhEJe8CBd0dhQgEdzl+MLPHEz9dFJJE+xykTYTZYIOA08bip1pfiXyYhN/rHkRV18/hMZ3I20NcZWXCbSd24mGIh54LIiWvqu2Aw1BE7STdvtkNyqQj6eyA9noUxKDNY1m9TajJUxh+AshGVSLlCSndESXG9mKzZl2CSYBQ9UlNvqSZ39OKjbE5Wcp/AYOdTIsHaiUgb5zbZzv/GOOgN0pFPlYEFQ9Wu+df5Y5j9GYzPpL9ldz/V41KNFCZTzgJ7XAeLVmPyTmJQtNtUSF+Zc6FPocrH7ZyjzWDhtYNPDteZ8HKo8ZUYMTYUMjwxzp2D1Gqn/+AnR3YiMNTVCDYuQKaUc9y4qWDSNlXIpRFkd6PJEhu8dTTvWsGwqtVQZM0+FXpAQGv6kx99JAS7gIA/N+AZwsEJrBByNMvUYkwWk3R9Uqs++F3BJXHrWfiTArzb0nR8PxkacfEoCu
 nqDG5oB9
 UPiwYUnx6dzUj5l74nb39RkmoS8bQ4BI8lfeUtJHmskXDI6WwrB2yHh+ZLEwOZ9c/WDuYuD846hU+8szw/Qu8oYeKehJJqTbg8j92V7cMKR41INHxBe3hc8o9eUjME592V0Z1Oe22ORjz1KZsIY+0yppIS4sh/lliJc3JbiOVahVMV8sQf2dPVb4x6/w+QAMM6JZ/JHieHGKSpS4QP1WKMO2lge/we7bhu3SRg592S3VHuDM0nMGRobIq4H+SHiw2ijd0eYEVE6cTLfUMDc2DKUr8dshhk4vNqhf/KxidQwot6B7fedwp5vZ/QgAAI0LiqP59KQv8vPnM8W4XnXUo5d+U4vxoYzyE/fNXq5+18IU/LyrN7m2jhgdy0x7yxYE3g6fj
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


