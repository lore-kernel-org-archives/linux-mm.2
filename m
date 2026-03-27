Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F37D610BA432
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 07:18:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65D596B00D9; Fri, 27 Mar 2026 03:18:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 635826B00D7; Fri, 27 Mar 2026 03:18:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 487E16B00DA; Fri, 27 Mar 2026 03:18:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 378446B00D7
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:18:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DBB0A140FE1
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:17:59 +0000 (UTC)
X-FDA: 84590988678.19.DA0DF1E
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6B3E6180009
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:17:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Cc4G0gGU;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf06.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774595877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YLh3Xo4k3v9jnrfOxk2s5YhbXein0Q02MzH6XXPveGU=;
	b=D9jHVhsRhme5doSf085ZnYNKQ5wrayyWK0NeBX0+00LUNoas0y+pqt7RUPdt89iVDCwT2J
	ML9WTZF5yHNymtshsdF/+0baU+09Y/M547ZHPCmymadW5ptMbZXPBu/XF4vU2Yb14hYme5
	ZcdlTn2CqziAvjY3FhEmGzvYHunK8wo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774595877; a=rsa-sha256;
	cv=none;
	b=HIZWOZv2+jr78vSPjzxtwJEmH4qnrV6yGzQJxSl+nmEp1EvKu2NjzFSKS8SSxTn9Y1gGbb
	AnEl48e2Jrr6HG7uSdWwrb72+pwfc5wRsh+pESVOLNHlRxK1k/68JzKU0vseV6KkTpSAxQ
	p3oKcCyacNuhiGtIqnY79kz4C2qaq1k=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Cc4G0gGU;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf06.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62QIM9Vf666646;
	Fri, 27 Mar 2026 07:17:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=YLh3Xo4k3v9jnrfOx
	k2s5YhbXein0Q02MzH6XXPveGU=; b=Cc4G0gGU2bg+qF724WYhOWAJnjhyEWc9K
	BOD3UYFRxV2vk34I9C6iEGkgq9ySyzj/ZHU3HwRcf2u2iDq9tPKk0IEO3f2lPZ6F
	cP7kxuKVcTxgh5gH/nQTBCGac83KU8SVkLsalqhwW+n9K1I7wF8GL85nEGwPJihd
	WDQ3Zzfe3zl3K9iVjSuGFfX8V+FmT5J+NOmTX0womDcFH9OaFOgZsXqPW/Lb6uGY
	hNbJ7As6jBU/2rWfdKDUQrKWA0Q9byue05R1DjSCFpljySLtw0mPnMG6ocL1czPi
	VOdFyvMea9kHIwGwjhZURHwWtoKlGWWxUWF7cMtWeSW8RwpQ1dHdw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1kty8xbq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 07:17:50 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62R6sp6T012203;
	Fri, 27 Mar 2026 07:17:49 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4d27vkeabu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 07:17:49 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62R7HklS47645004
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Mar 2026 07:17:46 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1A69720040;
	Fri, 27 Mar 2026 07:17:46 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 817DE2004D;
	Fri, 27 Mar 2026 07:17:42 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.ibm.com.com (unknown [9.124.208.5])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Mar 2026 07:17:42 +0000 (GMT)
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
Subject: [PATCH v3 08/13] selftests/mm: ensure destination is hugetlb-backed in hugepage-mremap
Date: Fri, 27 Mar 2026 12:46:02 +0530
Message-ID: <3b6ffba238a4b59de891acf896fa25d7d3193228.1774591179.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1774591179.git.sayalip@linux.ibm.com>
References: <cover.1774591179.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=IqITsb/g c=1 sm=1 tr=0 ts=69c62f1f cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=Ikd4Dj_1AAAA:8 a=VnNF1IyMAAAA:8
 a=1nRyTxe7YdkMqT3215IA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI3MDA1MyBTYWx0ZWRfX/EXoCcJATeIi
 SJh3f9tQ0OWxesW3ZFWqb1En2EOSlYMhFbPOQs3ehYdI1mclLdStSJNNwrOvZtYgBpCKlfLAFwG
 vt6bJJ3e0z9sAyuMEb1xZsiTjRZFHOyTk8BTMMzFPOesCg/POBnXSnu89JUD5vzNR0C0cdK+8Ig
 YL1PDbXtARHqnLM7H6ZBMgkORpa2rZhECgfjxTr88PhqYGotpxPkoO0/rNofGkx7Hz2nnOB5fo1
 SAkNSRKtE/HICvHqFgbFhiKWx0icX4sl8t/jSuhvO18ZCRtRA93Wa9gNJ7eY4XTizt2AIb6Qpjy
 9irjypUf2FToFuX0PDrwih6ACZatGCbC8spQabKLEb165LVNG62bSGxTjGqMAFoe2QZgHfozFm8
 HI1fjQ3r5lKgsQ18fVyXtprdt4bgXVAjveVwKrnC+uo1NvMuHeAL6ZXEDBnKEpnzqsW0nji0EcV
 0OHsGsuIEQHRaVl54/g==
X-Proofpoint-GUID: GMEoH09uQRJ5KOSvRWe1V8OzqY_11NR5
X-Proofpoint-ORIG-GUID: 8o4VFoIcaVw4PPgEDSc_mCNYsQ2Bg4aD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_04,2026-03-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 spamscore=0 impostorscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603270053
X-Rspamd-Queue-Id: 6B3E6180009
X-Stat-Signature: 6jmzn1rjhsfiahb8radfpwhrbkquqkdm
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774595877-817716
X-HE-Meta: U2FsdGVkX1/0NBh7qjNL4CqwKtMXP0yO5/h/EzdT8FsR0huase86C5abWj1hoHgMz0hT4RJX28kdAtbeU0ihmLEhhGst8ezktHQQrNK73WJysQnO8lUjFzG/UiIc/6fNwIihoTdccdZptoDxrZATxlIwii5hNBV4dAdDzSSfEtg6kXaobKlpEuu/51UDO1Zbjc8F9+op7/ZDf7EHTcy/8elEvW9Wt24G19wX9yLnVLHjzM6kGXLBcgeUZNt79crmlB676VVpmGcGiGt+iW9ewklhkLs+IPD1NCIOuCuvAdlPwNacOwFt7Fh40dxM1oTeY9SV3sVo7QYHr/4lyhStOjXpuwSYS1BKmd+eTmjyaRxyUUvlnmbjeqzaGJE9HhtiIb194KAXI6F++DvUyMfEeZiZQ1g9DNMG0O6J6ujpjbfP74Cc0gMVG8F6oMXJcN0cn+du5lvwjpc/lmkrODXKBBaUMpmYYKCufKTwrX65SpiIHHTh/cnidGhDDBQVsBYqRPPYk8A2Vbwubx1JhZayOEjlAacWlahcsquWn5q6sCVKxQCYy0Om+gq80tuC3XTh1rvsUaPsOlR+7cUs+PULW3opQ1EFPtoPGN/hk93t6dtwv5VBeswSEJXeJTk9rbj9IezdOpI7Kd1dhZYKgaeqHnxjBTEA2cpXvD3qWyORXqDdqKKPKItF3mJ4t2q9L8FXRMw41NfmM2YlCxa9J5p7KiLWr0mSLyE36yogtBwUuY533bg0LfBX5iegg613pYx6X4G0a1gqmZ7JLnczn1JrBPS0d+0rCt1a0uckzfv5XxvmxaqlLpj5E4W71EaZHqBt2f3y5fQxbis8cSV6rR/WJsMst1dXMKawUmXU6kT6qP1OpxH4bvp9JEXXTmOfbT5fgxUGdfgg9zDoTC0cxHFmwQipKjPO41dKSQaIThTSNsmuAyUfeCKQiZMzk+amA7PN9wIX5FAWQ05D3c2NvMU
 SwKEVrPe
 RzifHCO4rqOFiypbLgA19cJmBrUDUHDPYLSWJHoD7Yz7RKb12wouHVuWsxYGtTR/gNC7+2PYs5mJMrn2993aU6sasPoX/GPA4Ug0uvhGqWGZldWI2VmY2MpZ9hHMh0LASkIEQDBdRIa5zRKPlj6yXwmP1EPnQkA8rzsywO1JPYSNO89Qwu05H7CQdsbYpg91gI5uXAHqCia64SswOBRaFMYdS8NpQxPr+VBVYxZ4/i9iQ0bRq5Mt7tmtuOdIykoVDBL09efD3C0m3xIakeEpRCkjxQD+z9lnYedoO9gTXyInzEHopfOloF5cjysc68VFOLJ3947GW9FB6oQnEMHH6C8oCK6kKMzZnStry91DldF63ANxvP+whiECkAfW3CdQ3vTT+
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
source and destination VMAs are hugetlb-backed and compatible. Also add
MAP_POPULATE to the destination mapping to prefault hugepages,
matching the behaviour used for other hugetlb mapping in the test and
ensuring deterministic behaviour.

Update the FLAGS macro to include MAP_HUGETLB | MAP_SHARED |
MAP_POPULATE so that both mappings are hugetlb-backed and compatible.
Also use the macro for the mmap() calls to avoid repeating
the flag combination.

This ensures the test reliably exercises hugetlb mremap instead of
failing due to VMA type mismatch.

Fixes: 12b613206474 ("mm, hugepages: add hugetlb vma mremap() test")
Acked-by: Zi Yan <ziy@nvidia.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/hugepage-mremap.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage-mremap.c b/tools/testing/selftests/mm/hugepage-mremap.c
index e611249080d6..48c24a4ba9a7 100644
--- a/tools/testing/selftests/mm/hugepage-mremap.c
+++ b/tools/testing/selftests/mm/hugepage-mremap.c
@@ -31,7 +31,7 @@
 #define MB_TO_BYTES(x) (x * 1024 * 1024)
 
 #define PROTECTION (PROT_READ | PROT_WRITE | PROT_EXEC)
-#define FLAGS (MAP_SHARED | MAP_ANONYMOUS)
+#define FLAGS (MAP_HUGETLB | MAP_SHARED | MAP_POPULATE)
 
 static void check_bytes(char *addr)
 {
@@ -121,23 +121,20 @@ int main(int argc, char *argv[])
 
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


