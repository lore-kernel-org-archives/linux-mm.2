Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A918AEF4EC2
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 09:20:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E50E6B008C; Mon,  6 Apr 2026 05:20:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 195E76B0092; Mon,  6 Apr 2026 05:20:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ABDF6B0093; Mon,  6 Apr 2026 05:20:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EF1D36B008C
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 05:20:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 87BE0B85A9
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:20:39 +0000 (UTC)
X-FDA: 84627585798.13.E177611
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1EA6F1C000E
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:20:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="A+KaU/rW";
	spf=pass (imf21.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775467237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nw9ZkZ2qtFm5sEpfNZ2VZDGfra/1UI4dbSFUj9UhCgY=;
	b=tmqzssq9yqnfJauxMvCgj4JY2x5coV+Y5wm1pXxk4B8JxUmokbEA29PZzt3o+gma3mY0et
	L3VlnVapTMtcoehIH5pnFbYonVEjfzYgo+4C7tp7i85jmxxIfAhKPyixXHbBhgf/OdUQ3J
	4B40b1a7IsIi7mlPZZOsYhsf6BTMyos=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="A+KaU/rW";
	spf=pass (imf21.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775467237; a=rsa-sha256;
	cv=none;
	b=Jjj5cvsiB6H/y8oscbfZcWTCG32Hq/FUbocmaXSIOQ74oQVpAF0AUHX6IKOWzy/RP2ymQE
	Nj8XI7+A/k3D7HpaIpHQaCHKc8IDW0AG88POKz1UbnxXNEIz3/0lhIIQvtGum+asodC1AV
	nNajhBbVaxb3EfD4afSjpcj8QrDLsgU=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6362uv93052743;
	Mon, 6 Apr 2026 09:20:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Nw9ZkZ2qtFm5sEpfN
	Z2VZDGfra/1UI4dbSFUj9UhCgY=; b=A+KaU/rWjoLfdC8ACThoftGnORpTPLVja
	pHYFrxRX5bHxIvIbuUKx9LnMHtySTAv/6EuE4weo2+ZfSYkWW1KiFxSdgqdQzjGE
	iuNucuotCttsCZXCcRODfUwguf5m1kdgFXOg/VzgYZpU9CcDSBsNksUG1W2EN9rh
	fz5VbeIjOo8wWj+1VgefvKOpax63zfCO/RydZD1zX6T2kJAEhtBCTNyJnXyk3f7J
	NU+dMHbxx9dBYbtU0EaKE/Ul8z2TH/BB9aF6wihLh6+irx8ZHUuLw6m0hdTVRqD1
	oIWS2yd2JDAFga0x1u3bQUKNey6paO0E8Qw6mLvmtD1DOg0TK+YvA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4datap5vq2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Apr 2026 09:20:17 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63671mJO006367;
	Mon, 6 Apr 2026 09:20:16 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dbfp1kv2u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Apr 2026 09:20:16 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6369KDi454264174
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Apr 2026 09:20:13 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E0BB720043;
	Mon,  6 Apr 2026 09:20:12 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7E36C20040;
	Mon,  6 Apr 2026 09:20:09 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Apr 2026 09:20:09 +0000 (GMT)
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
Subject: [PATCH v4 08/15] selftest/mm: align memory size to huge page size in hugepage-mremap test
Date: Mon,  6 Apr 2026 14:49:27 +0530
Message-ID: <6aecfff81bd3e288e66af238f50f35eac0bd4ee7.1775466330.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1775466329.git.sayalip@linux.ibm.com>
References: <cover.1775466329.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=Bp+QAIX5 c=1 sm=1 tr=0 ts=69d37ad2 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=7t5IiW4R7ddU3FUDOzEA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA2MDA5MCBTYWx0ZWRfX93HuP0OgvJW/
 c3p7A5qwju1Z5Im4P47rbK2t2YTssBP286ygxm9qeuUI+rw+Wg/JxWQyCwYtNgbvFRUvKGnRYEJ
 fGGaGvppjaeuRof9RdXJowRqDHKWVhMPnJtGoTK14zTZkH7Nud/didk5UuXpXN0Pqfj6IXtmsZ6
 /Vx+7kHPAfMjhFiYxA2LemJfRkOYoNneWuUVBcHpmattn61DxmGyO2py55DIpvJ7xiYcPlJ89lf
 VrJtGjpLkcVaT9KgPhmRDAbzmg55R43zX24nlJ/+T8EWiL8MFxwNI2h7OqWxvWqFqEs16RZyXIT
 dIKqfokn1HYZS0xsCOjQL6nTbGgOC/kZglOANHOAgnbgStT5bADF4bZBv3CpZSG4Gr3pxNbzhbC
 rdoAH08Trc9ZiTbXQ4R+iWLJaa4tgXId5O3i0nM1S8pFkvvA/jSVJlMI+A9AMSgg1DZbZo6ZDN1
 kTi4Jvtk83segJsY0hA==
X-Proofpoint-GUID: YE8RH6-T8ap1Ln54ZpQjoOMHN1rEKJNh
X-Proofpoint-ORIG-GUID: eqEvO35RqkYaRN0wbx7743G22Ks-VQsN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-06_02,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 suspectscore=0 adultscore=0 impostorscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604060090
X-Rspam-User: 
X-Stat-Signature: 5kqydicmof9d766dahdihjapu8eip7kg
X-Rspamd-Queue-Id: 1EA6F1C000E
X-Rspamd-Server: rspam09
X-HE-Tag: 1775467236-822275
X-HE-Meta: U2FsdGVkX182qjifgDJP/3WARgCOhL0lNV57uCw0VblHZGZ7JOZZdWCJJ61qDI7WwJSO0rZvEMonJ5Hk7kYEuD+cuI1GLLx6l8fgoe7PZbGN/+tqwWGDj1V2R0VTNd3m+P1XyyrtURed6RxLjEOLNYJgWbxJWx9ympZV98XQ6ktWTYu3X/uSLyakZMGnAZmTq/19ZktiZQp0kUnxT3lA/DSBmSxRUaN2bLF50hUZnOCwzp4gzsgJjeN2hArmtdAGB1Mp9/7WtsvPkJZb/yGg5n/QZ2ISpMqHCOWsVlbcr643aaDnklej5DXbtRsxxTxhaijIszsmadFVnmW9XBLDaT7rvKEDZlQBQJqBwxwncsFxl2Qjh8/NH09CQAQLN8tmXOUjYlp+/vAd7o724gX+k69aECqOf1N41XQJgwWlf0Dc8LJD8dfRSyVA3ULJK2HmGxZUVhokPNvxDBqnYJLvt7xFUhzGqxVBm/g6UoqROVnn1ErEt+5Cmz+q2KEnFDkjJCagBJsCnp4CN7Li+7Z9mMWbKEdi9nQmW0V/sL8AUZfI9t+cKDp7URqWp0+UKu6cwVOJwyZhQxiyrbCnAM7AUyYqj8uO3DOmghheIiZOT2fI2vAPtYXBbEtnlyk4Dc8xCugJ4sRbTzxnNNfiVuTcquKP4AYIQuyZwIDzeoYDqBy4bLkKLafrI2UHxM5ucnmP+qdXDAPE72/n1wyLm3oJqH5FQa9zzol9UW8zH0F96JugTOM2riTUKhRm4tOVw8DJFlM4eFowmiJf6pVc1pVCEJfGPtbEXYLvcVGfUSrqo1Xac3NNYqeWgNlvon595vTxVESsFE3KprL5VzBLJee2FiEw31KHgOLDSQVTnvfjFm4yr9QNKQVR3VEucFaEORV+nW/L67mh1RUU31CseU7l5L56cxhQmwqQUR78fDgRu2/0GiPu+DOehhIYRZHi482TxrO/uXrIxelmeCsofiz
 J8UKQwSz
 UtqyNQykxzrNCAMbz1ABFwvCdntviZ9s1neintEVB9ODiL7GUXHEllwh7LDMIDBqg7INIghVU7qmzO8C3f+kOWPNjPe1rGMokIip28AO9h4SsBfXihFMxUTFdA/uLHeFV80itSBfOBye5nDDkkUZ/WPRio8sJM55fK/aB33TNlp+hF7buXQV+SteYjUemRehhs2OLhGABsIGEuSaDF+M56caXJZDtt5xNGcoerDY9gY8T13Wwf/rmbBID4Fd1yvevJe6Gx6V88h/tbIJREBwTbHmfo1+kGTXGvIFo55LnSMEdW0v/ZVFtDECTAAWTQaq75keilAZJgw+dTrgDJw6phTpO6henCmrVeZe+wXawgpZfB84=
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


