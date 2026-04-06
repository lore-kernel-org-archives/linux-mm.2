Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05280EF4ECA
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 09:20:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62B9D6B009B; Mon,  6 Apr 2026 05:20:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DEEB6B009D; Mon,  6 Apr 2026 05:20:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CC626B009E; Mon,  6 Apr 2026 05:20:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3DB916B009B
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 05:20:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C1D0413A8A6
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:20:51 +0000 (UTC)
X-FDA: 84627586302.01.F662C99
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4EDE8A000F
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:20:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=eOxNig6o;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf15.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775467249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UfapbF0MIYNL4g108uLsimu5HpFg3RBNrsbl+T8DHIM=;
	b=zQ7ST8toPd9b5stdwU+GuElLWT3xiTobGIIo7NkYUPL4kunirm0XNBmlaagix15/+g+HpN
	A1v3jR2b1F/ZYxVWj+6xURXcWTNWP4osHRpp2x/OJmuBrzEEEPsu8FJUYoBJ5LhTHP1VAu
	hWztZfSTGAeQqu+p+sNgS9gY5ymxsAE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775467249; a=rsa-sha256;
	cv=none;
	b=C8OiciGPBoMlYIJY9pT/XTVIEZI1Cg79S7AfHIWToAOQUyJWStONnaGBGMWg8W7A4bYDZi
	eRr93N9lVU+oX+oyAA5i45rN7XmG3SF8F3ZnPzrbxrO1pMEfVmfGYePOYFPZ1D9LMEi8cC
	w2qiW9FhFZTpSUPnfRnei9pWxF8SfbE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=eOxNig6o;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf15.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 635GlcON3095729;
	Mon, 6 Apr 2026 09:20:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=UfapbF0MIYNL4g108
	uLsimu5HpFg3RBNrsbl+T8DHIM=; b=eOxNig6oTRdpY1BLjRBQF4rkVeX2jBYcg
	b9flBQGOk8XaoidcPn1xpY4XGvhy88CPJITjGRgTlXokARHrQ6h6m9R8GkPuRgTO
	jzpqef/ir04S1JjYZmv18kIFmH+IipYmEYWrdWSKcXBPRmhkgBA/Hqpgf6CD853F
	dPMXqTAdxMRVfEu6wrC0winXDsDKQInmIhm6JKzWyrK8jK7E4pkNXexgYERC3sBN
	UKZOdfBr5UZip5qPt4Ap6B5veoXYPTu4vyAHSkcUOvkSbZhmFl1S7kaZ+RveGtN5
	nyhIo3z46uThetBX6+oYEaHSH7cnqUX/bjOcWI2V/RAtVBP38zCqQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4datc2nwjd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Apr 2026 09:20:24 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 6366OCMV014777;
	Mon, 6 Apr 2026 09:20:23 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dbf6jux04-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Apr 2026 09:20:23 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6369KK8f57540906
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Apr 2026 09:20:20 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EFE4720043;
	Mon,  6 Apr 2026 09:20:19 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C54452004B;
	Mon,  6 Apr 2026 09:20:16 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Apr 2026 09:20:16 +0000 (GMT)
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
Subject: [PATCH v4 10/15] selftests/mm: ensure destination is hugetlb-backed in hugepage-mremap
Date: Mon,  6 Apr 2026 14:49:29 +0530
Message-ID: <a4c1dd0e2b83cc06ea84bd04e6a86ca6d51efb67.1775466330.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1775466329.git.sayalip@linux.ibm.com>
References: <cover.1775466329.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA2MDA5MCBTYWx0ZWRfX+HqQvBPdjI7l
 xJZzg1OYzfGqyyWy8z2HbMBNarIa5WnTMvJ939WW/jsPwV123cUm09LKGl0KuI41Ic2kxvHjefa
 jgzq96VCO6nWli5GgbySQsa14E5gxAZ6vbYBbFbAER4lRSUp6Af3c8Hz69/cRuXPbWIVOXCE3tt
 UZ0uVsei/lmKV8eXkBV27BononKdJR1dYATNTA1yDfgwVdSQT5YaAOFm+0CEmTSmihBzS25X5m7
 2gYGFfR43ZoyG1cfk5Ub4XEedRx2rH8W97CkfvEr39N/ZK17dGxyQBoRa+V9xnj/N68kPIr7xM7
 BMrtS1ZLqrqXvHVpIqczlPAX1AFfRBjw0RD/+Kq+3KtkpkzNHX6hsO4ISsZQIXNRoUj4qSRzU4I
 K6pLThgKBUoiUP4dVITKKCgYRs0Qry+pNw/vrucArkMjAd38NRN/fkU/0+4hE/54UlxmPEENsas
 BXoK2x8SrUAIkI0eaqg==
X-Proofpoint-GUID: V2FNifgevaR4390n-0H9S2FXFBMEu_vI
X-Proofpoint-ORIG-GUID: gl3H62yxUwUu_yrP0KNZSQ1Ea8nJuzTm
X-Authority-Analysis: v=2.4 cv=HJvO14tv c=1 sm=1 tr=0 ts=69d37ad9 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=KgDUTMtFSFkb7SMnqUgA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-06_02,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 phishscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604060090
X-Rspamd-Queue-Id: 4EDE8A000F
X-Stat-Signature: y9433oq4hgzxrupca1s94jyhf1ohd7co
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775467249-503223
X-HE-Meta: U2FsdGVkX1+/8z71KxkzWDCob3qzZuw+54haZ1gVtTvk28gn7/dcKVKqDHpgQtKeNTmqparii/TowSEXJXxiO8l0KBaqvGhTSBE6EaRhyf1vnPlRISWEuI1HkAJcUUM2u/ZOGSiVc1gDeRXiYDlNYc8m/7q+gzLHonJwMq1n3Ki2YjcAs6vGw+g4eoNSwJv9J5KSj0YEoGNdXJwW+jTCkr0L/uRD/bsHLeJJrgeY/WkiMLaQSeVTbPNWxmGOzmt0FO3Cim+TmRy8xX69FeHkV/YNh5MxTXjTFCcRgdYTq1hrh1oKdx60aavhceg9/yM88KE3w/tu51kJ9XgA239Z+UiR/2WLW9idOhky7ZGgk60AF8WGORmjLkCzajyEBgivogwefzVAGVaN6c+YtnX42BYV810Xi1NZX0LZDB7BCSBrqXgfPlwe45iUOgP9A21iAasGIrm6vVdSyoVxL0hbBN/8NMqqWiqYGpNbxekXdOGBccQ8rncQOTEuqRgTtEGDWi+Q056JACDjfiulluZ1O+B2ml+ebFoMRTQbnkFZofAUN0XoR9BxhzJ5L5BzNrCFdrg2QARgixV8N6DufQsqwEXHiykmYWa3/PwMg9S+QIMhQsb9gIkaPPLBhvwDi7vLgdmsU6MU6ZmPnnhZulVT60jE4hMrsYqRStrvnFzZb/HRAo1+nCXvk+Yer5Uq1YPegLPtjE2eJ3NTb1WxglFoX+0yMiqVZoZ5QaVHKPqCg9o0xFALSVDG7rvgo9dUcHl6wp/+5g5y9HrUa9+1WgA2WiVPSBKCYr3uXBt5+Enj70R2PBLxEu4UWnWEsRo9suC6W2dKA/cAulAY/KTMbHnYKees2HnbDt6m7Prtf1LXxzlxoWEbAtkvmRKaq09z9xkldQE3yFEjc6S6SDS3IFF9AuqXlXhnYdYTPuVWnanBokpv7ftIMIZd6xSjlyN3M3Ww/WsVpzbCMs8lnoz/P/H
 S4//70uk
 cSd0JCzuJEoLCoIMO74aP/ElWjzux9cxk3kx4h/qsChKDjrBgMfBb14qrUIuhkTCK94pETj+OEo0gDxC+YHKDiYi0r0SzvZRZ0gJClxjyB76hxSMdgXwZMzRJhxJRKjLWgJVWa5p5OvZ5/RGPIlYZtyeyiWtwXttdc/XX9XpcmD8U/mcSPO8fJWpVa7D1OM6ZAEICymBp3Kth3VHlduJt9orHLFp805h9IZLABF7yCWXhm5A7K2OG4VNnGArXs9Bpi/p7FcMTeU3vdD9W512hQX6af7OzYU4gcOQYXSKNOh/kMngs4//IGGanGiXeFfM9BaKyUy5aJ7UBq6TDfAjbpQ1Yn5IPqk7MGwyWLieybsTY1yw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hugepage-mremap selftest reserves the destination address using a
anonymous base-page mapping before calling mremap() with MREMAP_FIXED,
while the source region is hugetlb-backed.

When remapping a hugetlb mapping into a base-page VMA may fail with:

    mremap: Device or resource busy

This is observed on powerpc hash MMU systems where slice constraints
and page size incompatibilities prevent the remap.

Ensure the destination region is created using MAP_HUGETLB so that both
source and destination VMAs are hugetlb-backed and compatible.

Update the FLAGS macro to include MAP_HUGETLB | MAP_SHARED
so that both mappings are hugetlb-backed and compatible.
Also use the macro for the mmap() calls to avoid repeating
the flag combination.

This ensures the test reliably exercises hugetlb mremap instead of
failing due to VMA type mismatch.

Fixes: 12b613206474 ("mm, hugepages: add hugetlb vma mremap() test")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/hugepage-mremap.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage-mremap.c b/tools/testing/selftests/mm/hugepage-mremap.c
index 68c35d1d8a5f..a442d01908cc 100644
--- a/tools/testing/selftests/mm/hugepage-mremap.c
+++ b/tools/testing/selftests/mm/hugepage-mremap.c
@@ -31,7 +31,7 @@
 #define MB_TO_BYTES(x) (x * 1024 * 1024)
 
 #define PROTECTION (PROT_READ | PROT_WRITE | PROT_EXEC)
-#define FLAGS (MAP_SHARED | MAP_ANONYMOUS)
+#define FLAGS (MAP_HUGETLB | MAP_SHARED)
 #define ALIGN(x, a) (((x) + ((a) - 1)) & ~((a) - 1))
 
 static void check_bytes(char *addr)
@@ -131,23 +131,20 @@ int main(int argc, char *argv[])
 
 	/* mmap to a PUD aligned address to hopefully trigger pmd sharing. */
 	unsigned long suggested_addr = 0x7eaa40000000;
-	void *haddr = mmap((void *)suggested_addr, length, PROTECTION,
-			   MAP_HUGETLB | MAP_SHARED | MAP_POPULATE, fd, 0);
+	void *haddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
 	ksft_print_msg("Map haddr: Returned address is %p\n", haddr);
 	if (haddr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap1: %s\n", strerror(errno));
 
 	/* mmap again to a dummy address to hopefully trigger pmd sharing. */
 	suggested_addr = 0x7daa40000000;
-	void *daddr = mmap((void *)suggested_addr, length, PROTECTION,
-			   MAP_HUGETLB | MAP_SHARED | MAP_POPULATE, fd, 0);
+	void *daddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
 	ksft_print_msg("Map daddr: Returned address is %p\n", daddr);
 	if (daddr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap3: %s\n", strerror(errno));
 
 	suggested_addr = 0x7faa40000000;
-	void *vaddr =
-		mmap((void *)suggested_addr, length, PROTECTION, FLAGS, -1, 0);
+	void *vaddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
 	ksft_print_msg("Map vaddr: Returned address is %p\n", vaddr);
 	if (vaddr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap2: %s\n", strerror(errno));
-- 
2.52.0


