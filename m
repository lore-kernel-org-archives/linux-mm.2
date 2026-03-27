Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9197210BA435
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 07:17:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4D056B00D4; Fri, 27 Mar 2026 03:17:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E241E6B00D5; Fri, 27 Mar 2026 03:17:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3ACB6B00D6; Fri, 27 Mar 2026 03:17:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C40986B00D4
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:17:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6E6375D05A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:17:51 +0000 (UTC)
X-FDA: 84590988342.27.BDF6842
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf19.hostedemail.com (Postfix) with ESMTP id 147BC1A0007
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:17:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=qOuLJrgJ;
	spf=pass (imf19.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774595869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t+6DwwlR9UdzBRLUYUT8hsxyw/0+r3+JFoRe2sMRrZo=;
	b=v3GTP5Y1x2C0551vRnImhnowy4+mIRGrfWzOTDk/ud3A4UHc9GvM32prPMdcmKtH1GUi25
	wo/LqjomI+7M2ODOfyza7K6dwjmaWAVmy0Qht0siDCgcraq5Vjd58I/KWUr7ug9teZmloN
	Cf+QuidOl65DmkKwzH7ZZUuzXnJYHa0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774595869; a=rsa-sha256;
	cv=none;
	b=HV3flndJZNyDEv0ZiM9aO8Irij7fQsjG9vJuI0IvqYjDRRUcH0H9IGRuVg4WYsawu6v1xj
	u5jjEIiCi/ywzoucbrOd5k6ZY3BQ31oIhU9vQKLP1XY/Ac6agy/o5EofCfQ3AwoDjbvdHZ
	srigcwBVZZzy2VGlrZCP7eANdO8qrqY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=qOuLJrgJ;
	spf=pass (imf19.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62R4nIZJ504443;
	Fri, 27 Mar 2026 07:17:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=t+6DwwlR9UdzBRLUY
	UT8hsxyw/0+r3+JFoRe2sMRrZo=; b=qOuLJrgJgIwLIdMzQuyTmq/iZFEoj2q7q
	A8RAS1ekZk52W2Eu1/F71oxeHyMh0iBdUyxcMKDEWOT19EuKf4jmqobSHBg+G0Ur
	Lu49IlG382vIm833rRRiRSjTt1upiA8t2+9SBnIbTqNs893wCzAafKNOu+X6mNfm
	hXyVIqtL5MyUabP0SmWaWuxUzEXqkEb0p0YHlkUSM19TzFbxtq3Zew9DMyTOwlaq
	+/RcvV87Y6AT+J5WyTyGQq3AtJmIzwXlyBkV5qXpH+dDSUEDkeuOkVqkeQ8/u4HU
	loJu/Mnll3EHaE/WJOVGK7+hCPIpuaQ3w6FL2hrMHfwb2dHDmBHXw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1kxqs19c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 07:17:43 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62R6YJ3u026695;
	Fri, 27 Mar 2026 07:17:42 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4d275m6dn9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 07:17:42 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62R7HcOd58458370
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Mar 2026 07:17:38 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3F40920040;
	Fri, 27 Mar 2026 07:17:38 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BCFA02005A;
	Fri, 27 Mar 2026 07:17:34 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.ibm.com.com (unknown [9.124.208.5])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Mar 2026 07:17:34 +0000 (GMT)
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
Subject: [PATCH v3 06/13] selftest/mm: adjust hugepage-mremap test size for large huge pages
Date: Fri, 27 Mar 2026 12:46:00 +0530
Message-ID: <fd252496169a91c80e339910978f21c3f4aac9f7.1774591179.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1774591179.git.sayalip@linux.ibm.com>
References: <cover.1774591179.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: L5swmakLYAAb2i1yttyT_RRgNGQ3yBaE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI3MDA1MyBTYWx0ZWRfX6/BORxD/4xpe
 PBhUm+p5K/KQwGqlOoEIq+o4Jf2X7QVQ4vQ7/AFlJgwg3mhXW2LL9kvDhBqTsGdZO2qZbm2XUZf
 AmWINRue8qSGBKepB/fem0obBpaPEgPamTRgVyLFTyWevy7gwsQVkd74QDoXwtcyZ06Czq+MEpp
 oHLdJpqjIxwBB43TVirAZwO0jkH88zsMM92yHcpWRwqXDMgzFkL5NukaqS9ecgNXxP6yjeE+RVA
 Ri246/8nP7/5U0Ob+h9VB42Mbt5T+vCiY5K35sf5PDXeO8wRp6GH4ID7AkezIX532gRKyx+NBER
 sAFAzIAa5516K1rivz53O5b+SRROtvcodoyAsXkskO1v+6stPGFuYz/ek/+TJfd0tVmpmxWWG+z
 Bk0cUjtigckJqpMCVku5sPxroQdoYKHuHu5eUiY7W+aWGRQMYS+MLkNuyX7RNTIVOwJit1l3+lx
 /GwKVa9W/qjPOdDdOTA==
X-Authority-Analysis: v=2.4 cv=bLEb4f+Z c=1 sm=1 tr=0 ts=69c62f17 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=Ikd4Dj_1AAAA:8 a=VnNF1IyMAAAA:8
 a=JhalB4xO2WXAR1P85RoA:9 a=aORTNHwJY3_lF7LJ:21
X-Proofpoint-GUID: 1NJj7SxDloow8wpbQh8JR6ygMBA_lmwo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_04,2026-03-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 clxscore=1015 phishscore=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603270053
X-Rspamd-Server: rspam12
X-Stat-Signature: fczuzoxo9o4us3zfcuanubuo18fertdm
X-Rspamd-Queue-Id: 147BC1A0007
X-Rspam-User: 
X-HE-Tag: 1774595868-315538
X-HE-Meta: U2FsdGVkX18HtM+hEZeSoOuP9FzmFtG2LVntarJS914k61Ni3MIoDKZIfRAEXyzi+EcPgwiywVxwBiWWDlhrF/czxN7C+o36opN1gPMIoR3FRPbH91pWj4ucS/HD6D/ZO9UijCWtgjlrhuJ+KFvG8VXmMccg/Q0bSxBgTr9pYlFTvIfSTgIL+h3LzvoNa3YHczl4xUhfgPfbv1FZjCUVtqLMTXM+sRbOl4zVKylW9bUwcTeJTuMnecMjImXIX321qxcTB+EyAYAddmK6mEWh1dsDBDRlwI6sxcI2S0IyuR+E/YzuHzgTx0mxBebFip4Hojkuu0qyrtKU1kGMkNu3eTsJC4bXjtI0IZkeSr6hUvBz5d1ZCxMJaZlvUnhI1luXXputkOlnf2RC4VIxbwMNCVFGQI9ok21dSLXP3Mujgoz1rF1pKLEKNk6ojfPRPy9ZUZwU7iPHRs6i3jDoi0rL5fBFcAfF3zfMCoMs0aw0EjFtuWRbW38BrMVnMXbL1Psvjnfcb4JYMcXW04ecDwUYvWC+RPYxdFOMMQtP5YEX5vTZsjStU4AzeEKostp1LLr4xI3oW58XWbMH3XtbF1EIbnjGvxGEIel///ftuWWytlNfM93WetE95A2tfDAeGJUu2dS/3CVWFkdvL9cRPG2aBnc1sPC2kZCk5YKZfbL7n0qv18WtEclMiOF3biOMt/trA0aNSdso8uo4Q1ASWQ4JIDh4IDpISVf8IbYxeyo7+ckyNHxwBth23Ez5vHzb7MfWtRamWxx3MuhLXxeoLGO/63/yD5Zfdr/rMIVGwcaHoy0y94wgwNwPFrgzPUEJm0+TJqGa3ckN6ZX07a8SHzMEjFfuuvqMzAn+o6fSDQmWSuTlqHLT4H5x7cxPFX12djr5cj8+JmJJrl2ful/6jVnHiWhOE1vmLMJi7kTR+oAY4W3ldZE/Y3Kkil0G5s0aPRFtWR694F5DeLWeBwCNJGn
 U/ESP04H
 OZ938OuSGnqREUEp4Ag8UHPfZRb0puYUmDxOy/pgiIpWwlqqs3kFQspoohlXVaDJj9SWsNYdBJCe2IzmNos11OGy7orFPJvWxeIRn8IQimpL8IsRtjrRQ51Vm/rlHKNh6hq6HJ5LI2zqKuHWwQ3A+W3dfg0WNZEn+s6xxGbfi9lGnueJdtpT8iW23bSyyPF8F3kLooENf5tRaWXqYwhXbNC+g0p+FnW0v/gHNCnaO5lq7QU0wPd1l8f2IFvUGngN49qZOyxAN2vbFlP+x9poyfXav4mnZ+2kPjnx5USTqK3LtqaMe849k3DaQtiUSWOCg6B3z7So6iV2PNjY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hugepage-mremap selftest uses a default size of 10MB, which is
sufficient for small huge page sizes. However, when the huge page size
is large (e.g. 1GB), 10MB is smaller than a single huge page.
As a result, the test does not trigger PMD sharing and the
corresponding unshare path in mremap(), causing the
test to fail (mremap succeeds where a failure is expected).

Update run_vmtest.sh to use twice the huge page size when the huge page
size exceeds 10MB, while retaining the 10MB default for smaller huge
pages. This ensures the test exercises the intended PMD sharing and
unsharing paths for larger huge page sizes.

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
 running ./hugepage-mremap 2048
 ------------------------------
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
 ok 1 hugepage-mremap 2048

Fixes: f77a286de48c ("mm, hugepages: make memory size variable in hugepage-mremap selftest")
Acked-by: Zi Yan <ziy@nvidia.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/run_vmtests.sh | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index afdcfd0d7cef..eecec0b6eb13 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -293,7 +293,18 @@ echo "$shmmax" > /proc/sys/kernel/shmmax
 echo "$shmall" > /proc/sys/kernel/shmall
 
 CATEGORY="hugetlb" run_test ./map_hugetlb
-CATEGORY="hugetlb" run_test ./hugepage-mremap
+
+# If the huge page size is larger than 10MB, increase the test memory size
+# to twice the huge page size (in MB) to ensure the test exercises PMD sharing
+# and the unshare path in hugepage-mremap. Otherwise, run the test with
+# the default 10MB memory size.
+if [ "$hpgsize_KB" -gt 10240 ]; then
+	len_mb=$(( (2 * hpgsize_KB) / 1024 ))
+	CATEGORY="hugetlb" run_test ./hugepage-mremap "${len_mb}"
+else
+	CATEGORY="hugetlb" run_test ./hugepage-mremap
+fi
+
 CATEGORY="hugetlb" run_test ./hugepage-vmemmap
 CATEGORY="hugetlb" run_test ./hugetlb-madvise
 CATEGORY="hugetlb" run_test ./hugetlb_dio
-- 
2.52.0


