Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE892C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 09:55:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 623306B0095; Mon,  4 Aug 2025 05:55:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D3876B0096; Mon,  4 Aug 2025 05:55:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49BB96B0098; Mon,  4 Aug 2025 05:55:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 36CA86B0095
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 05:55:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CC108BEA11
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:55:42 +0000 (UTC)
X-FDA: 83738618124.14.90FC820
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf27.hostedemail.com (Postfix) with ESMTP id AB62D40008
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:55:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=JX8u+a3c;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf27.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754301340; a=rsa-sha256;
	cv=none;
	b=yqzW6yrA4wdZxcslPqYzauN/4zOpGF/zq+ltFpyeAga8D2Pdd77Fsi5tGSJV/d/CL1IueI
	Z9ch3DttKLt3YFmaCftV6sCfkpCipCquEBejcnFN8LUjkTzKkE3iw4+sR7qPJuSMQNcsqU
	tL+ZZ4qGd03yaAIU37gw1Xsx7PAe6bY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=JX8u+a3c;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf27.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754301340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DAQV0AwXeHE/PwMvOBgIQg+ASlsQc1X48WemPBpqAp8=;
	b=w5ImmGG1WjGMJm5uOKDeysN1q7UoOzD5A8We3+bNKHtVz6iAanWAW5QU2uc+qvN4wBHS7f
	a2qw6rbUsBsLM8rcF69DybbZw72Fp6Nh5QvshvJOL1/ru/Dl9/u5sR3ZzcHMTKBZxydRa5
	YofzxBiHlZHNt7XygptBO2Fs59b7pXs=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 573IecYw009060;
	Mon, 4 Aug 2025 09:55:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=DAQV0AwXeHE/PwMvOBgIQg+ASlsQc1X48WemPBpqA
	p8=; b=JX8u+a3cp4KDC/RV+NejW54b99E6nfTYDShlIaekUf1ehXchWAO2YpvP/
	tgAIFJUbMXx3+jiGiGH0PQH2a02nZWyCLNpMCrIPaRqGNN6EZiLD7sTfV0C1vNs4
	XLquDB49vtvYYvlSZjVaABXxwIg4WDEjKPow34Bc1a1I+CuqJp8wH/e2qV3mRUmq
	GXzLbIITjlyj8AvLfNr2uvyC6uX7gfQ7n8DV3Wi//saBdgVbRW9ITKSApHjdQTBF
	SCYKxFP/4ksZ4h38AJ/2KTVM0lSrlJL8qUhRON3ROTC0SdcooDEegCMqDSQes8If
	VtnxKCD4nv+oJPGeeOsTfhwW+9iHg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48983t0ggv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Aug 2025 09:55:39 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5746go6e006876;
	Mon, 4 Aug 2025 09:55:39 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 489xgmd38b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Aug 2025 09:55:38 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5749tYsA39715282
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 Aug 2025 09:55:34 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 748E420328;
	Mon,  4 Aug 2025 08:40:30 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5238D20326;
	Mon,  4 Aug 2025 08:40:30 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  4 Aug 2025 08:40:30 +0000 (GMT)
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>, sumanthk@linux.ibm.com
Subject: [PATCH] mm: fix accounting of memmap pages for early sections
Date: Mon,  4 Aug 2025 10:40:15 +0200
Message-ID: <20250804084015.270570-1-sumanthk@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA0MDA1MyBTYWx0ZWRfX9UqKj1uDacui
 qq95fm1prsbYncAw2VJR/2hLoXU2AqQa4QXuYW3LutQBIZId2CnnxZqTbXsqoAZvQjl6BNc1SyF
 Yw/4ArdNT74fBp+fXzfEaRz7j/Geihorx3YRrZskAV9y5OSvP2RuULBc+QrjyAlBVHNOD/Zg8tc
 WIQmobi9rnIrPFgtzmsueEcoKBkpMH0u/nD9Zixw0+QQ5yaFnS/7KB3OXEj8KQeimDOQ4JNrTxT
 Lbyz0xBl7SZ31ni2rxEvlS/g6NDsAzN/fE3M0yB0RclbL1pCEkxQL+mFKRmNgYomit8p+tefSVS
 Pd9+ztjHpBn1yZMC/+9aaLmQkUIU0uenFiDJye4d6x1mPiWGHQ9Xv7lJPmIULd+2t9cVzER1IeC
 L4pgNYl7iJhDxjKvQCI9BARrrl2r6dSVgZO52vAQ/dtWoFvYktlF73iDeIK2Yzms/hk/Fwio
X-Proofpoint-GUID: PFTZoDSImDPPihjzNlw7i8WSy-lbRLhl
X-Proofpoint-ORIG-GUID: PFTZoDSImDPPihjzNlw7i8WSy-lbRLhl
X-Authority-Analysis: v=2.4 cv=AZSxH2XG c=1 sm=1 tr=0 ts=6890839b cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=KawUSfIWrfKEQJWuwW8A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-04_04,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 impostorscore=0 bulkscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=434 adultscore=0 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2508040053
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AB62D40008
X-Stat-Signature: 5ort7fyuhs15couje6ey7zmjuzkx656k
X-HE-Tag: 1754301340-526019
X-HE-Meta: U2FsdGVkX18jUdhGkrbdAEyGT479DjhGn3xIZ6O0cSsP1r7yPqgw+afFtj/4PfegoI06Tv6VWSDcjuBl4zjp80z9hxdMPVkLhBAmBpZFEz3iMJvg+DCIwrsYtyHUHJs8ItECc335TaX56Ey1FlCZgLcPxjytq4kjml+xVPRDrzniF05QKXh8lABk5be5KaQ1hmRVxxDKI85Bo3VC6OUW0PzClPrg1+foDzsV0F5zxNmjRB3iDwTB/FHk/vLZiaZ/hAbHaQB+EySTdSLdEVc/T7Q0T61ydLoCkUTErGFUJGoSk5i4IERIlsLEvaWf3e2BO+iPtGq4sVlk3p+vT7A197lZG79b/Blct3AP5E1SAc0BbevMC2pZRqdZIxOxzxxfObLcQxYIWLNJ1mG399fMP2Xf9I6P5ijF86wva3Rf6eWUHWhcIxBdJYVC6tp44hEG16+lyutvTjOOA1iQumgn8GdLbRq6gcQSlnocr1iXn+4sGPIaAuPwleUN+gmDRafW7ow9PIQyXQVybf2oZNylTUM4r3rxhkToql9FGcvrK0b0Phafhmqshj3jcCLa1DPv97FZwYdHOoFd6yVGdwqwZvg4VaxMUQAam+DW8nTqrXdHkgP6mrR+j/GfH0VKzLkO+Kp2qrU3x31S3S8r1mxHvW3x8VKI2QxDeKeWxKy1WHbg3jcc6/xEOcyI+mhAC5XnyLI22oQtWeuPPpTDS4slk3ZeTF+KPPZQIdOSRMvITjBzoYbxVcP5bRO8+ruJBlC/qBOJcGJuHeqhi19Xjkq9lfM/ICWA+8ryB63/kaDbzqBsZGnmZwAM2734MFwsxoqOxsdRm4vs1yUBJGZ9n+emz19SKSAJgxBLTXK6SAGkSCmtnb4PD9xGHO+Y2pdHAEPFl4AUomowLXAplYGRElsGKP9MPqysryZS6KwU96DknmFebnk8vcuanm8iRSSDs4Y/MgS0RpC8mqwBbg+e+bB
 +R9fRZvt
 PY5KseruNu4AyqToc6OmQanCHXzMoSajm8FdHSGQCzqpTKn0nvjh+IQDH0AlO5nZhnbG9C8HbQvDRxRvecH0+fF6K7BhcXUPTlBHuS9WQ41HTPJqvBBSmyf4W9xrH1Z24Wk/44se0+gSmD0gHIXiNFcm3ic2qzwO83HhTeqyj2On062Ev8GiVB9JNmY+0nSyajhLsHwHHiihaoCYLqLf/uNiacNrRfIr8JfSWQlHAzs2Uy/bzCLDOpH5k3+tteMZsUx6k
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memmap pages  can be allocated either from the memblock (boot) allocator
during early boot or from the buddy allocator.

When these memmap pages are removed via arch_remove_memory(), the
deallocation path depends on their source:

* For pages from the buddy allocator, depopulate_section_memmap() is
  called, which also decrements the count of nr_memmap_pages.

* For pages from the boot allocator, free_map_bootmem() is called. But
  it currently does not adjust the nr_memmap_boot_pages.

To fix this inconsistency, update free_map_bootmem() to also decrement
the nr_memmap_boot_pages count by invoking memmap_boot_pages_add(),
mirroring how free_vmemmap_page() handles this for boot-allocated pages.

This ensures correct tracking of memmap pages regardless of allocation
source.

Cc: stable@vger.kernel.org
Fixes: 15995a352474 ("mm: report per-page metadata information")
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
---
 mm/sparse.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/sparse.c b/mm/sparse.c
index 3c012cf83cc2..d7c128015397 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -688,6 +688,7 @@ static void free_map_bootmem(struct page *memmap)
 	unsigned long start = (unsigned long)memmap;
 	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
 
+	memmap_boot_pages_add(-1L * (DIV_ROUND_UP(end - start, PAGE_SIZE)));
 	vmemmap_free(start, end, NULL);
 }
 
-- 
2.48.1


