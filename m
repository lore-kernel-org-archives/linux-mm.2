Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4149110BA431
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 07:18:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA3976B00DA; Fri, 27 Mar 2026 03:18:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7BB16B00DB; Fri, 27 Mar 2026 03:18:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 969AE6B00DC; Fri, 27 Mar 2026 03:18:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 86FD66B00DA
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:18:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 49D6F8D050
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:18:07 +0000 (UTC)
X-FDA: 84590989014.07.BBD0E92
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf15.hostedemail.com (Postfix) with ESMTP id EF143A000D
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:18:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=LiEclG8f;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf15.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774595884; a=rsa-sha256;
	cv=none;
	b=WHffATYO8QHSEJAOqU09H1PiTH9YwkY61d/s2K1DY3tCPkiR4YdfQR1VkNOgbQ4TXFKa+5
	s+mJ06GSt6tIhgTIZSqt7qVS1v7zzyXAxmybVAD1ikQOIZJG0hDSVqhXoj02morH2U8Nm5
	Zn3ATa8AFWONmKzTVYPsR1e94aOYcBE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=LiEclG8f;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf15.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774595884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5xKgzXiNSjPsI3xL6CBUcueD9iNfMUrfEZZj3ej3r5o=;
	b=z81RmoMUU6Co2/R/vpswb2JRV2RNT0XH9ngF+jzkMdvSfDhT975PXP8l9g3xh9OPyHUzpH
	cvbLcqXJobuh4zYuZIRkgnWUtBhDz0DvT4LsECVgUkNOxkYftye6NGfpEg4zKA1zIetPjc
	pNyGHkxo4cuyn9NzTXHegp5zlAxWLPI=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62QIGcsp2477909;
	Fri, 27 Mar 2026 07:17:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=5xKgzXiNSjPsI3xL6
	CBUcueD9iNfMUrfEZZj3ej3r5o=; b=LiEclG8frPoXgeGENPcHnZcNAecW6VR0o
	eoeDqXILKxcu6T4iDDqS1zR/nYHDgUgVEAZvTwKfDJXZexoebD8SC4zULAAmM4Pr
	rj3o/+geNP0lExV7+A1nJWRFvi4KAqX7yJTYlNxIVcunkp0xX4YcTaZONiaSVe0k
	5NEpsH2zLEy3OcL0cSKZnDeTB3KRSxMNflzosAfugMwN7YxCLiePMFOcWWwQh9XG
	AB0xJxpSFk5cGIyozVT7cszuJ3VKFxijWeuf9VzhQAhB9uO9RQ6YwdzwMv8duDkE
	LbCFJ2Ji5k9CqAEVp3AP0DyM+9sF5T53GZu6Ezd8TjDFUxGEUUEeA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1kumywhm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 07:17:58 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62R6YJ43026695;
	Fri, 27 Mar 2026 07:17:58 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4d275m6dpn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 07:17:57 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62R7HrAT48890352
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Mar 2026 07:17:53 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C93342004F;
	Fri, 27 Mar 2026 07:17:53 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2A96520040;
	Fri, 27 Mar 2026 07:17:50 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.ibm.com.com (unknown [9.124.208.5])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Mar 2026 07:17:49 +0000 (GMT)
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
Subject: [PATCH v3 10/13] selftests/mm: skip uffd-stress test when nr_pages_per_cpu is zero
Date: Fri, 27 Mar 2026 12:46:04 +0530
Message-ID: <0a4106d7c594c5bb471a48ca37348883e204d295.1774591179.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1774591179.git.sayalip@linux.ibm.com>
References: <cover.1774591179.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: frLCNW1iVTSq9AaZCHJVFXBO5zcD0Dc-
X-Proofpoint-ORIG-GUID: MYRXE58sXUGpmeOMyvvjqTyXBDqY2Bzw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI3MDA1MyBTYWx0ZWRfX495l3EIu1lud
 ScaXI4PF3+Kv4YIo47PIOEjZjsSpTggeXXdCG6FWOzul3f/CVHld7wY4jwdkuM6gAJwoRYo526J
 eAyYF/xJctANrBsbxTiT8yMrvQA+mPTPx4gVKsKmhF2ESM8cIz7l4e00QceSWqx/ayRruicNJWm
 dibmHfV390a6yhay1ILqVljkYO8JELQ7FzUoiG7uH/4kSHxfw/sU+F3ImlT1lr3N5Zr637FqDM5
 09boSfNJ85wZyTCJjhHm3wl9nJE8nYvRnblkNPIXQuQASd24otUYXIebBJtqOzfKgfVRZXdzfP0
 VwFf4MhfFhAUXPTAR+gbZs6e4vHgCOpjxk2rXFklY9dqyCOrUyFstDslBZeoXEwjrJdnI9FkAhA
 Dnn3egtK6rh31R8WCFBkidRutv4ElcxN+dAmRI/dyZWVt+bVbuQoXH3NmhvVLH19eK9HVsXNPql
 KbnS5z6bi0jX4exD3Kw==
X-Authority-Analysis: v=2.4 cv=KbXfcAYD c=1 sm=1 tr=0 ts=69c62f27 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=Ikd4Dj_1AAAA:8 a=VnNF1IyMAAAA:8
 a=-JjagEEUfC1zOw73BwIA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_04,2026-03-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=0 malwarescore=0 adultscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603270053
X-Stat-Signature: tnecffay3oirf1dhpi3b5sm97q65bko9
X-Rspamd-Queue-Id: EF143A000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774595883-541937
X-HE-Meta: U2FsdGVkX19UtAoMWtk+YnzYcZggvfNp2E8nG94XcOOjiKqCFB01wMvAUKLsWsyK1bekIts8VGuU8D613ymCGHDm80T3anvx5JmJ8ZuccomYK8t3QRHMj/YCPXw+SHP7zdreQIRbxRrv9TDAU2gozt7D09LFl1lqh52by/W01JnMjOQROnjrpbZFU9nfomUyuEGEJjh0SB/H5wc4yoC80L79a6mqj8/8oX1ScFZ4c7bfQZjQHDlTjO+HATdIUPB5cedfhR8P6YSYYPQINeIxeAn1OV/2sUgcQBnhW9i1u+zYtRH081uEyCG1+6PpoIZOVZmMeSyGWdGWr3Q6gJj4xHfuz+uQe6ZQa6guPnRJJf2RM6HjFNWIQOlwwYbJbTIoscQgGX/l5QL8XR5E/YJ7J4ZuNMnUaddIgiHPYJUwK1grlrCqB7XbHXijQDe0VVY+U8hTLg6vP/4K3AWWMmO9PIEdlAFMh/JIzDfJAAmAm3B35WLgyzX8OwVtYdxEAZyQ6jQDgLz96PZP7cGmemcKT1B5KVqLEZ75F21WMvC3kdykX4L3eMVOAdp9U8xsV3LbAwFhLTk+APskIrWlFU7jGmq4bxPWMTFJ9zbjjUL9bxy968LF6evKp1C4OtSgLm5vla5AhrciHnTj4/qT/bq9cXdlY7WuB7Wjmkp+awkkDNk5RhnLPQArHkPjgUi7kJJyhiHQClLgSO/U5Ja2TkxKylN76LaXiBock1WqFDytvSdPuYiW8vIpNn3HdZyR7E+J27NRW9zb8tMKVut+2JLA72mgTohtLlesbmzdtPMvFcPuDBzmLmR2l1RvAkZsjPmkn09bSGyS2hJka9lvv5B03gSEjskZL0Sfmx7Z5zye2oBZebf0I/2EMiv3mTSuPDY5F3qbhlhtVYCG0vgDJ3GOkor7TL2wTLKZ2RgD4Dle1t0u2IFATebHX0rQXdTMswXTYEr3/peY/n6TMg4e6u/
 1HWZAag6
 1TbfSJ4XFyYbkS83JKk5YHKy2oHxiiSZh7PCr+ejAnYdUja82YwBRCqtcuYLrcDH8m4vBk0bW1krcSVe5VgpZgZRBHW58eNR+f5aEd/pdgkTAGVrM6GSQAh1KTmFy3D8BB9bmBhPc0pzHoqsCfOwWN0IXQ6c8xxr9EIdxvmISVbOgjPTBg2GocqyOExW2WHctjuoYTO62/1ZgG+bcZHQVO50NNovdy//s2NeKQ+osLYR/LKzC0/bei6rfVWKtIg0vf9EWIpKUYIbW98EXkM3U7kgjVpDM0X3hLKe4G23HTK1kQrpJK1IQd1BJcmnobQ7jDH/djQEakxvx9tVsvMiUsqZtAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

uffd-stress currently fails when the computed nr_pages_per_cpu
evaluates to zero:

nr_pages_per_cpu = bytes / page_size / nr_parallel

This can occur on systems with large hugepage sizes (e.g. 1GB) and a
high number of CPUs, where the total allocated memory is sufficient
overall but not enough to provide at least one page per cpu.

In such cases, the failure is due to insufficient test resources
rather than incorrect kernel behaviour. Update the test
to treat this condition as a test skip instead of reporting an error.

Fixes: db0f1c138f18 ("selftests/mm: print some details when uffd-stress gets bad params")
Acked-by: Zi Yan <ziy@nvidia.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/uffd-stress.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-stress.c b/tools/testing/selftests/mm/uffd-stress.c
index 700fbaa18d44..b8f22ea859a6 100644
--- a/tools/testing/selftests/mm/uffd-stress.c
+++ b/tools/testing/selftests/mm/uffd-stress.c
@@ -491,9 +491,9 @@ int main(int argc, char **argv)
 
 	gopts->nr_pages_per_cpu = bytes / gopts->page_size / gopts->nr_parallel;
 	if (!gopts->nr_pages_per_cpu) {
-		_err("pages_per_cpu = 0, cannot test (%lu / %lu / %lu)",
-			bytes, gopts->page_size, gopts->nr_parallel);
-		usage();
+		ksft_print_msg("pages_per_cpu = 0, cannot test (%lu / %lu / %lu)\n",
+			       bytes, gopts->page_size, gopts->nr_parallel);
+		return KSFT_SKIP;
 	}
 
 	bounces = atoi(argv[3]);
-- 
2.52.0


