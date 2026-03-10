Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F082BEFCD9F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 09:51:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56A606B0098; Tue, 10 Mar 2026 05:51:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52B516B0099; Tue, 10 Mar 2026 05:51:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 421336B009B; Tue, 10 Mar 2026 05:51:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C4396B0098
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 05:51:12 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 02A201A0582
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:51:11 +0000 (UTC)
X-FDA: 84529685184.20.422C1FC
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf14.hostedemail.com (Postfix) with ESMTP id AE7B6100007
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:51:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="VS/jEMWH";
	spf=pass (imf14.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773136269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t5acmMRUsiPYplRm/dEZ1Uq6+xA3/RS8dT8Hm6Z2fKs=;
	b=Qfp/LNGtNz7DxC2+jUsmLfhSPdaLL9sZ+J2uMS5I5tNXtZHiXmvbWkMD1eBu5M5rUNGRTY
	M3cmyzHgupYeBpsQ6p/OzN7Y4Y3kgvArF0Tr9Ybvkzq+ICzwFB3NKrgXTqKTuRNKVWwORq
	y6fPQl7CGiMK0J0D72uR/dJYQk+mmNs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="VS/jEMWH";
	spf=pass (imf14.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773136269; a=rsa-sha256;
	cv=none;
	b=dx6Tv02s1HJejd8EcF3DQdxChn9VK+bSIGKxn9mws3xwf8Lt4Dki2IP6z3RCpWp3wsq1zC
	ElPA/VIHeVgU7bux7IHmGb3bABzv3lLrHmPVGsIjzI0rFCy8We8eVD7LQq4eqOTyhq5RmY
	SL/HL68ZZjIWc/GZ1zcs4Dr2iEzgXkk=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 629GNkVX1714112;
	Tue, 10 Mar 2026 09:51:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=t5acmMRUsiPYplRm/
	dEZ1Uq6+xA3/RS8dT8Hm6Z2fKs=; b=VS/jEMWHxzUBenRdSqd9Ov2CqUHl69EHY
	46ppOwTOfHF8ucvSz2eVGDUqw1I3CyWGeug+Puok5TAzziZGkfVC1BLuFRqnflnN
	diDRHanhtp+fLOBBW0jNGCKKrLi6tLk7VEOB12+dRKsgldevwwiQI0W0FcAJRUyn
	450C9zlJ2Pum12Xmt6gTonHlCLKmdbjSoSd+bBugtmZjhO8eC1U7UIoSXllADUx4
	N2Hzh0WdjL6jjTr0N2xgJ4umwU02bznFWvRRa6JRO4SS0Do6qbCgVPXKTZM85sQ9
	RdldpAlGMS3ssk6FZblraJCoiP41saM5gYgv8rwcHCHgjQxKK6KvA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4crcun9yg0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 09:51:00 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62A64YpS015581;
	Tue, 10 Mar 2026 09:51:00 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4crybn8jcm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 09:51:00 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62A9owfP31588736
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 09:50:58 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EDE462004E;
	Tue, 10 Mar 2026 09:50:57 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CA03020043;
	Tue, 10 Mar 2026 09:50:54 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.in.ibm.com (unknown [9.109.243.201])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Mar 2026 09:50:54 +0000 (GMT)
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
Subject: [PATCH 08/13] selftests/mm: ensure destination is hugetlb-backed in hugepage-mremap
Date: Tue, 10 Mar 2026 15:19:26 +0530
Message-ID: <2c8858154273159f964236810c7304dec665b28b.1773134177.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1773134177.git.sayalip@linux.ibm.com>
References: <cover.1773134177.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: NEkdMe3y-R-WEHCcZZiFrRJEe8wPgiPI
X-Authority-Analysis: v=2.4 cv=Hp172kTS c=1 sm=1 tr=0 ts=69afe985 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=D8eXOz3ApXh34wMIAzAA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDA4MSBTYWx0ZWRfX/LgSFBKQWOQ6
 fpzasiZNGCeb/IZSbgBmcDfbMQb5iuCwlNg+uUccdm5hMW0wgIk2Br4HGqx+iV+tZeMZ3JICWWl
 sqXlvnWoswVFPuKE9aNlV1KcZwqRA6NpITomIIm2NRysWlVXhivyoFfL4IsXsMOJIVLtzU2Zztp
 z5mDMtsMgK8xmaldknymlztAA6X0qxptXF31E62Dgp0DV/0vUGMH4tCIWg4DmAtVC8kvhxz1SsQ
 6aM9gDNTqIzPGe2HfOjv9pwe0ZET/7wImeGU8b4Ey3fAPXrfl0GiK8WZXCWBj/puIvWdjGFiwyc
 7vb+XGzeZ4lXLzckcz2/LvoiLGw/Zrd2a2UnW1CcLgKUOLNdgChs42sTj0AG64DgqivkyH/Iwzv
 6ZV5cwpfW/z57sqRvjQFC6qIwBOZXUh4AoVz61lFo5uGJmExvFO7Nny2Xszyv7Q4B1CYaxXmN4W
 vLMP+rShnKOFKBvRJSg==
X-Proofpoint-ORIG-GUID: cwzWHYFJO0fY-KIkZge_lNS_eucwXBtS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 spamscore=0 phishscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100081
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AE7B6100007
X-Stat-Signature: sua3zahmuwg7w7w6fn8j7b6eimz6qpyq
X-Rspam-User: 
X-HE-Tag: 1773136269-795832
X-HE-Meta: U2FsdGVkX1+8CNCnZoJlEbW/RK5rCKcPX4no2Bf1UdqMSL0ynn6nnaZJAyUezA1ddCNogbmzMbffJIFMJvxrdUDj5D2gwN+iIUicsFR00wUN1QJTaHr/wnxmaqV+Q85nSid6QX5fvwuqiLRHsrmlGENo8KsMkuysK9MfLsySWwGlBPRz0hGSp4jAXBWuxpIXWJQ5Z1Pgzpol571Duy+qnyTqbeC67TkNG4c1xUZC5mj158MZecHYtsnm8WQ9jN3RkbAmbnasy2erdaAWT6OjaQVeYgBXKJnnvmlKdCfnqZDxJfSfQvU2ENwqkgTJ2dhlHyoAYZlWRYT04b1jvl7ynQA9yI9yGuqs3FXHu1nvlzWjuLZgAIi3Uw6RjgzB4Qn/y0wCsBsFrcY0aUW1MDwlOOw4n0GT5ksAQG+HGyrgEQNcecYl2S17FUen+W4MG5t8jD1bGZ33XaLkJo+fJJY9lA2a75WwrHJy/ysgkmWPRRCljHLOcK3B2JydG6lis01rMp3nl6h+jx67WsLgNe4pqkYS9+0q5oAMt5ctYGjMxcK9cWChzTToDS/M2+oDyYGMxWQN9AUu0PFnCnx3vtvIPNdO6JNhEucUh9+RspB8ILba9EXr/irngY1ygpYDsRUE6MgGKaMIk/ifHwjyHagx7zIjPHWLbdoIaH3M54ABMpnnxYOpV7tfL4XlgUxronYHAwbJYCepc9I37hdlanHh4a8+IOLsUo94/1seqI/xBYRFgogsuwogxTQfb7UgnCAmUTyx4AolTkj8hio8fCYntfN9Iqb19uvc1fgHMxkKkJ19ao0smMwIZGJNCFjbCj76//NQSik/dCWekA2vFDxu/O7TJZtKTHTLkbIxi3qFQrAcP7qSD2GX5jR7PWCnBBY3nXugJSIz02O5d8fLdwISiK640qM+MhXhW7q4oAUEICgMRRIT/cqElMCF8nXVvrRfDwRBiOi70pJ4YLQ3FoG
 hhOG1GYf
 J5efoHQUlwx/N06Mfx7LFq6EklomV/PqagRz/74k6vuUlXzI6rFOH6Vpw/UHTxgxygj7GOb5npDWFUUN3jiHOePWCZ0Ssqe16/xnaa/4EwcmmxzFzJ5vMzJ9yjgV58mpcIo61OwF57heRLLWtExfooJQ/3lnUFwKHeEOHMBzmrfH5jm7pz6i2pRhSyTQgTc/sIUDP5qzJF5n9HnEuXhiIw8TQkEXje6LSC1A6cNw+jsf4zy5c2XUBD3aghTs4uKkVdhcnMPM1nuBzGWTZiOol4sIFCQ==
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
matching the behaviour used for other hugetlb mappiing in the test and
ensuring deterministic behaviour.

This ensures the test reliably exercises hugetlb mremap instead of
failing due to VMA type mismatch.

Fixes: 12b613206474 ("mm, hugepages: add hugetlb vma mremap() test")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/hugepage-mremap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage-mremap.c b/tools/testing/selftests/mm/hugepage-mremap.c
index e611249080d6..9558515c282d 100644
--- a/tools/testing/selftests/mm/hugepage-mremap.c
+++ b/tools/testing/selftests/mm/hugepage-mremap.c
@@ -136,8 +136,8 @@ int main(int argc, char *argv[])
 		ksft_exit_fail_msg("mmap3: %s\n", strerror(errno));
 
 	suggested_addr = 0x7faa40000000;
-	void *vaddr =
-		mmap((void *)suggested_addr, length, PROTECTION, FLAGS, -1, 0);
+	void *vaddr = mmap((void *)suggested_addr, length, PROTECTION,
+			MAP_HUGETLB | MAP_SHARED | MAP_POPULATE, fd, 0);
 	ksft_print_msg("Map vaddr: Returned address is %p\n", vaddr);
 	if (vaddr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap2: %s\n", strerror(errno));
-- 
2.52.0


