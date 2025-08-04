Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D74CC87FDA
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 09:09:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3BAB6B0093; Mon,  4 Aug 2025 05:09:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEC4E6B0095; Mon,  4 Aug 2025 05:09:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A01AA6B0096; Mon,  4 Aug 2025 05:09:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8DD0A6B0093
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 05:09:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 17028160985
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:09:28 +0000 (UTC)
X-FDA: 83738501616.14.2D74ECB
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1B1CE14000F
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:09:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=fWb3SHUg;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf09.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754298566; a=rsa-sha256;
	cv=none;
	b=qPbZ89tMXddkBwKUwssDZwGUWoOdZzawsjpyO6kChppVB28/rd0/6B8sPs0h8ahGAtEE8+
	ZBpzC822VmomkhpNOV/y1pso1oMo3fijc7A6Kfi2kx9GeRqV27gKtOB/GwukxXKITL9jmo
	nV9sdmyH4xplJMdZulJuLdZbM5nO77A=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=fWb3SHUg;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf09.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754298566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DAQV0AwXeHE/PwMvOBgIQg+ASlsQc1X48WemPBpqAp8=;
	b=cPzNV+4l9SzT8vwjKTniuNX1fsIZCtGcLh2CWEhysyFoQS7SkSxntHU0wkLN4ns67ifAw3
	praZ55r6CYAqQPlcn12YIBlAkSUx7HcZ3/cZc4nQdNUkPpl53J+TgX25iNKJ1f1ZPa1KQQ
	kQxIHLd8DBeLe9jpqhLdKpO4cm15ZqY=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 573Kfcls029457;
	Mon, 4 Aug 2025 09:09:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=DAQV0AwXeHE/PwMvOBgIQg+ASlsQc1X48WemPBpqA
	p8=; b=fWb3SHUg47YjoUVNywFxRPTsnu/Wezkhd2rU3UvNgA/pAP9FTpxFEjxPP
	Agd74NEokr2BHiA6vSZJMZgYBju4FucUXFjPRAzUZwyrx+KPfsM1gu4UhYThI71s
	YV3FCGqacauCfc6SfG79AT+Wx9yUaRNMDtdng+I2y6tEw1MIJR2ArWXQ+5Adk8EO
	7ebYvx4Ef+xuMq0qx/jl3D4jZysMZ5OASnA7UH3YbM5UPdrrDPM93GSr0Qyvfkth
	6MNukVXhEZWT/NnbBeUZ2Oj3L7MJWls/vEFLGOcGUum9r5i3H2Ke9wBuH61bGe5l
	fnJ5ObrkB2Be0iVkRbHr3YmM3FLsQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 489ab3fxj8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Aug 2025 09:09:25 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5745fU3C002484;
	Mon, 4 Aug 2025 09:09:24 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 489wcyw3qq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Aug 2025 09:09:24 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57499Kxs47776186
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 Aug 2025 09:09:20 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1CC542033F;
	Mon,  4 Aug 2025 09:09:20 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3C95B2034D;
	Mon,  4 Aug 2025 09:09:14 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  4 Aug 2025 09:09:14 +0000 (GMT)
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>, sumanthk@linux.ibm.com
Subject: [PATCH] mm: fix accounting of memmap pages for early sections
Date: Mon,  4 Aug 2025 11:08:59 +0200
Message-ID: <20250804090859.727207-1-sumanthk@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Z+jsHGRA c=1 sm=1 tr=0 ts=689078c5 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=KawUSfIWrfKEQJWuwW8A:9
X-Proofpoint-ORIG-GUID: Mqcg8VsFLq_ouAd6ooDn7elCav4_qeSW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA0MDA0NyBTYWx0ZWRfX69T6gTqLTtTk
 gNMtzS5VDmmjbCVGiGeAdc3H4texRhpBLJQusvAaX1ZmQNPnsBfeEAR5VHx7tNOeOwFAWyiCbhn
 QU48qNiDoEWQr+TkTLD2/mO4hRvUJBIGQ9dFDBjp4gwhhS0WSifIZpx2HigXqXM/xoDS4OkhfhL
 tfNHl+IvS2r75+pLnwBMV0jGKqia+H7O2gzwgEk0LmlqxS1N9mqO++gpN5jYcxDTZPDCz8epJmW
 puCNvnRlC46oejNbzP5yjH1OBJresuJWBv70SZQSZ6OCzxpCjkEDG0UsciM/93/CebN27iOtrIB
 BZiQnu+gV6MA7dQgAVr9TAYCVhgUIHzZGK9xsswwHO8n7rFKSCWoP+BtZndpSOkU0OGqQ2zHRG0
 ZEkd2KVmhWrOjPBx6Gk4VSb08FA274TH4Hw3huVDjJA9D7wyV1nrx4S7t4Hd5He5rZJlajS8
X-Proofpoint-GUID: Mqcg8VsFLq_ouAd6ooDn7elCav4_qeSW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-04_03,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 clxscore=1011 suspectscore=0
 priorityscore=1501 mlxlogscore=434 adultscore=0 phishscore=0 mlxscore=0
 bulkscore=0 impostorscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2508040047
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1B1CE14000F
X-Stat-Signature: 93i5cq1cossryid57ae7pkezjnmi6t54
X-HE-Tag: 1754298565-541637
X-HE-Meta: U2FsdGVkX1/kPKSLv918NyJJ0ceY/nuLREm3fFg/99UHKQ523nWss/a9jFxx+ffMKC4o+xEuscErGHP+n0yUSuMlB0tRgopz/kBCyTVYUl38lPmFnvUSt8VP+xQNSkJoqpJB2Zwiv02NjkFfOnwq0yNrzFcRPVWq1RRk/ps6Xg2gdywj9ursE9RUzhR7rRlRoQ6CYLPOLBKcQMT/puYV4QHRGkbZPbWk5gHR4IWDyMAyv41nPbP1me7AXfxeVLFfq6hc3eCE/JqetZRouU+imKV/hvlZ+rKhX9lngZF1fGblcbYnXEX7yWOAhRMixz8saNaekxk35Wrn+pGgr/agJpveUpR79TZ6Fk7dJhysvN9BdJyUAl3vgkYnZGG/G5fAFU1J/gCQYGh/DGKT0nZb/nFoIYd5PLYtWolLPYX7JzyuJzLjZpAA+KMx5yA1CyhDuNrDEq3J3Ux7BeOsl0d5g1Dae5R93BWSdgzCbNlnLSAmajRTRnPneWXSz/Nc44e0w6LsCXQwZxQkdgt++v5qplsDdY49p11K/N64PmHzjDYkjvmtEHu+koUwmxQYqrR00XszzikKvzzT3VBIgg38VQpvFJLGO83otVbFbjPTMpamEMs63C+wg+FU0zUnb8ogsSP2QQSkchB5lnicYHOMLwn9ddq1zgs+KhnIQorPUvFOm6eJEIP+OhqnFD+/WGHd2OlJDMrHMfSTOeSe6Ag//YEylGoLRhdii3HFuIvuIGNWHtJzS6rSFItawy6wquNfanVb4m+pw3PQ7fFqScEe6Ao4EHuDNkxyvZJI9evpeFurIP06yPZDlFayRK8p1DbyOo7BfCJSjUYF3TJjCbtTQumcaP8YN/XMs6wxtonZjBqDfmv4nDQ+5TeHHtwhTV91Fv5o9qNsqECnPWnJ2bPbrA==
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


