Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A269EF4ECA
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 09:20:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBC626B0092; Mon,  6 Apr 2026 05:20:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C44FB6B0095; Mon,  6 Apr 2026 05:20:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A94ED6B0092; Mon,  6 Apr 2026 05:20:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 987966B0092
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 05:20:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5C2625849F
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:20:40 +0000 (UTC)
X-FDA: 84627585840.24.F13AD0D
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf20.hostedemail.com (Postfix) with ESMTP id 03FAD1C0004
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:20:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=SlYAUe+A;
	spf=pass (imf20.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775467238; a=rsa-sha256;
	cv=none;
	b=8WoP+dgBTsvnnssudaV84e2XKkmMu0tKP59EruJD5fW8jfCF896kNitrn0VBdceg7K46TK
	MuUVHa3Elugz4UZxRtOc8iTh43yqUXuJ9Guw/0LYqS9frpGveXdtkWnfXeSQuOt7kq79Y8
	/QXEiV2DvChIRnT/dvorWvZnTwg9Yus=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775467238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4EhSDCaShB3rwYDRoPDml275sLaBm682LiODn0nNoJA=;
	b=8VdF7NLstt1XaY58+GnmVHZihBm1dFI0/eEKVfK3odJnDCPh6oRrGqt2w868ZDOkQ8WO4M
	++xDJddtpTZnSJVDE1lUwvH2xT6x/ILdzWWauxwqDUdF+ASrR1kQkelMq3SHE5ajjPl/Gz
	EoUpyZWSGQtJipXvMdvF1D0jiUd5MrY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=SlYAUe+A;
	spf=pass (imf20.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 635LkWpi3666020;
	Mon, 6 Apr 2026 09:20:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=4EhSDCaShB3rwYDRo
	PDml275sLaBm682LiODn0nNoJA=; b=SlYAUe+AeupJfmqPHmLhxTv4QT36LOWMi
	ohq/Wr7hohSFUcOOvuqr41B8QyTMQQvIZTkzpYtZUXTrDIPFsO+HG5PTnBDbKR6t
	N+/or0IKpaINK0iTBTIxf4EXRRFhI71sovPEIAWCsZmJiub3Lyw44y1az56RlVKm
	ZlaVFfq2cYX/xYG0ryrUDhm+9gIbh2Wv37GAks9e+9fBUgLBc0P/YsqbhAIN50Nh
	hgfvUHaIDmhjAkNd1xB1wsfbWLRsU7kFsAxV2qo2yP1GV7ktVlguAGXe7kyUbmsy
	CE+s98FhB3E90RHxRswjQAsUzH8I9aAorGtThZUMYsPceg0PvpeLw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4datap5vqn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Apr 2026 09:20:28 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 6364sT4L021109;
	Mon, 6 Apr 2026 09:20:27 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dbdbyc5hc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Apr 2026 09:20:27 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6369KN4F24052118
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Apr 2026 09:20:23 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 90ACE20043;
	Mon,  6 Apr 2026 09:20:23 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5F6F120040;
	Mon,  6 Apr 2026 09:20:20 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Apr 2026 09:20:20 +0000 (GMT)
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
Subject: [PATCH v4 11/15] selftests/mm: skip uffd-wp-mremap if UFFD write-protect is unsupported
Date: Mon,  6 Apr 2026 14:49:30 +0530
Message-ID: <80239ca37ad96216eb5d9768cf5373e7246626ff.1775466330.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1775466329.git.sayalip@linux.ibm.com>
References: <cover.1775466329.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=Bp+QAIX5 c=1 sm=1 tr=0 ts=69d37add cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=smpEqqgnm6pLQfsEXf8A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA2MDA5MCBTYWx0ZWRfXytqH8299SKPD
 PVQJKEJHCkWQbxYxPj/MoPmMhEO8RC1kHq3SmCPnK1lGXik11ZxKObaVcuWaZoyVkVAGhFfQ7Vd
 6rO4L2mg4Xfbcqd+pBX5Cp3x4Q0503GX36ok1hhEbYMDJysN1cARN5WxrSaNCCDZhLF1f92W0tn
 2DyXNa08oxLTzsCsoZzyh7k2/ujiAe5JX0h0mnbcxMGly/DpQdCg9qUxbsWBG3/cFXRbWgXq2Dp
 +5uHuk/txcYSiiQeO1rAQ0H9v41HRewWrM70Jzool8QdLz6qr5Qt+78ajPvW5oIrJ3ATQIzPNBO
 j2oQ2dGaU3hzYNcjtn4Cnj48FDEbo7MGx0TWvHEnC87q8LeDlgcPUkz8+E0UcX2uPT5nyQOmSyQ
 wOw7711hK93/86KPxFJqrG9t0wol3d9rYiCkN/m8NdoF4kSxgVpj+synVwHUh/MY+tpF3AHFTSU
 4gBehsWBAIpujgZSt5A==
X-Proofpoint-GUID: TrWGYxJH8XCEQHRv6-L2CCTECgip6Ygn
X-Proofpoint-ORIG-GUID: AFSrbBGVTCsL7NYa1mLGsp1tKkwjbZIc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-06_02,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 suspectscore=0 adultscore=0 impostorscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604060090
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 03FAD1C0004
X-Stat-Signature: d7soikbkpyahates914ubhdijwgscdwa
X-HE-Tag: 1775467237-892695
X-HE-Meta: U2FsdGVkX1+ViOROiP9FP+xzSGr74wTvSuaGZ6jex0EtW7jbT0zwKqCBxZ9HRzkfeAVHLxn1ibmqtfPtPOSbeMni6fFfgQV9xMZre+44U4PfUF3ltZCxnm9pNzzK838wMuX0r8z2kPv6Dp8veIKlbm5H7cBTezDI1TT2EQFL2JwFIWA3mTmEKC5/8NJY0pSXttxlrceUBrzmZqDMnHsmEmDVa8nTiMeolCTnroTx71q7xuufuZVYb3/zoshzEl4CFXxad+APQ0Qocp2HK6qypNm9+qkBRLJLlcEkeNGnCT47Fc6HtbpwRMxKSnum4hUr9JQN3O0wUCfh8NTW/2RmDnOl0aR5mlTcS34o0M3bCjluOxZXjr/c8+IrXkGUbzIoSVm0J9uz/+h9qR5oM72YIA4s5gu/gR4tLJL0k9SlwLSBwA9CPi2pKMUN0ll846Ny5XvzCtuoTmESh8eMeE3kWIllSpc5Qb2nE6yTXPWe3NE956s8fmE5LF4PmxRb/Jyg41vYHgOJLFlGnA4ZLMRpT+yMIOBbHQaLFyVk1B64dkId1rxRsHZd6EafDsVA66/G726cQ5GuR6YL31SGT69N5yTw9W1NSe8/jDEBvpjvXTCj0VZW8fD6bgz6duPmrXfg42GPZ+RIYh2E2OsXdaUpdNx8ECTk2MWVnw2zHNHxv3LWJ6Xe/cXX6v/g/vrcSCDmldMAGQYMxIEnITGsCShvT+7wUMohcGCpagRdE1CyPeUp+z5GmlFJtAY6ucmLeJQZPljLSRv7gA3x1LNjkM6vmxzoFeEliatG9Ji9d9C8y+Awbvmv2aVst5W4Brnxle0kY1Dz8ad4N1xfbNoRg96TB1PDfrGYJzMqAgrNvuQTbNAc4JE7sICkWbtUpNkz0AO5aiGUARJF8kV2FaPkrjuC+0TtyYfhk518xVMB15jDcgxpiZVV82TyclViVWzK1ujyr5PhRgfsjhjsnhArLtF
 Ue5DdJoG
 ifGzc3vG1si9X0j+dbIgZPT7pRn6TzskxgWiLW+faUwCJA1Rj94quqn71ay2/osFo2auLL5pcmcpOCAnpmelJje2D/gnSZOVmn3zf+FAzOB+mdXdz3AZ2oFsotcBjG6QTmkFTxlW52POOO9byq/mLdRZdyhDoBRs+MoG+DhdM1wwFoX26Y8CdLgLTGHwEJJPIERIUyoi5/xKF8/+PsnEi/QJZauodrNifnyGw1JaO6PXg6nVWXqe7xHN5KJS45WHsEUsBir4CG4QtNKoqRafvWVKa2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The uffd-wp-mremap test requires the UFFD_FEATURE_PAGEFAULT_FLAG_WP
capability. On systems where userfaultfd write-protect is
not supported, uffd_register() fails and the test reports failures.

Check for the required feature at startup and skip the test when the
UFFD_FEATURE_PAGEFAULT_FLAG_WP capability is not present,
preventing false failures on unsupported configurations.

Before patch:
 running ./uffd-wp-mremap
 ------------------------
  [INFO] detected THP size: 256 KiB
  [INFO] detected THP size: 512 KiB
  [INFO] detected THP size: 1024 KiB
  [INFO] detected THP size: 2048 KiB
  [INFO] detected hugetlb page size: 2048 KiB
  [INFO] detected hugetlb page size: 1048576 KiB
 1..24
  [RUN] test_one_folio(size=65536, private=false, swapout=false,
  hugetlb=false)
 not ok 1 uffd_register() failed
  [RUN] test_one_folio(size=65536, private=true, swapout=false,
  hugetlb=false)
 not ok 2 uffd_register() failed
  [RUN] test_one_folio(size=65536, private=false, swapout=true,
  hugetlb=false)
 not ok 3 uffd_register() failed
  [RUN] test_one_folio(size=65536, private=true, swapout=true,
  hugetlb=false)
 not ok 4 uffd_register() failed
  [RUN] test_one_folio(size=262144, private=false, swapout=false,
  hugetlb=false)
 not ok 5 uffd_register() failed
  [RUN] test_one_folio(size=524288, private=false, swapout=false,
  hugetlb=false)
 not ok 6 uffd_register() failed
 .
 .
 .
 Bail out! 24 out of 24 tests failed
  Totals: pass:0 fail:24 xfail:0 xpass:0 skip:0 error:0
 [FAIL]
not ok 1 uffd-wp-mremap # exit=1

After patch:
 running ./uffd-wp-mremap
 ------------------------
 1..0 # SKIP uffd-wp feature not supported
 [SKIP]
ok 1 uffd-wp-mremap # SKIP

Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/uffd-wp-mremap.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/testing/selftests/mm/uffd-wp-mremap.c b/tools/testing/selftests/mm/uffd-wp-mremap.c
index 17186d4a4147..8f288484d5f5 100644
--- a/tools/testing/selftests/mm/uffd-wp-mremap.c
+++ b/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -19,6 +19,17 @@ static size_t thpsizes[20];
 static int nr_hugetlbsizes;
 static size_t hugetlbsizes[10];
 
+static void check_uffd_wp_feature_supported(void)
+{
+	uint64_t features = 0;
+
+	if (uffd_get_features(&features))
+		ksft_exit_skip("failed to get available features (%d)\n", errno);
+
+	if (!(features & UFFD_FEATURE_PAGEFAULT_FLAG_WP))
+		ksft_exit_skip("uffd-wp feature not supported\n");
+}
+
 static int detect_thp_sizes(size_t sizes[], int max)
 {
 	int count = 0;
@@ -336,6 +347,8 @@ int main(int argc, char **argv)
 	struct thp_settings settings;
 	int i, j, plan = 0;
 
+	check_uffd_wp_feature_supported();
+
 	pagesize = getpagesize();
 	nr_thpsizes = detect_thp_sizes(thpsizes, ARRAY_SIZE(thpsizes));
 	nr_hugetlbsizes = detect_hugetlb_page_sizes(hugetlbsizes,
-- 
2.52.0


