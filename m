Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B193CC87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 15:15:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25FFF6B00A1; Mon,  4 Aug 2025 11:15:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 237C16B00A2; Mon,  4 Aug 2025 11:15:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14DFB6B00A9; Mon,  4 Aug 2025 11:15:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 00A126B00A1
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 11:15:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9B1E5135BB8
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:15:14 +0000 (UTC)
X-FDA: 83739423348.19.A71E9E3
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6A3DF20002
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:15:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=FCC2CgzF;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf13.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754320512; a=rsa-sha256;
	cv=none;
	b=u263uyWcYlzdQ6ZzQfqjwlcdcEGrJHENy3quaG/WrQXO8g9gEaEcr5Nzkhq6M4pr74ZsPD
	iE4ROWJevgbOa52kIB4AkFQmnhoISYMa3dQF6l/ZH8lIQTqKu/o+X9uz0yETSW5cVdBs15
	BMf9bPfYQfpPO7hQnfaFY0x9/LjLjFQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=FCC2CgzF;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf13.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754320512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kVlNkasbhPWtsdP92OI0TGfwW4AsNdYUXsTPRipabpI=;
	b=jLJSFqHZKJgVC8u/+iduNs5UNrHgh/O8OkAMXBwUVTWBCjfxAw1aWHIGOVtMTVpxXePOjM
	FGl1UjKDcxg6qDVDpynVs+3Jyh9cxzutshRJDhrtUeQOlp7aomevBGOo0xMnNi7qk1DG5g
	ZbKHt0sFHMoJAVpyKxmrqZl6D0Vzolk=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 574CdmVf024001;
	Mon, 4 Aug 2025 15:15:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=kVlNkasbhPWtsdP92OI0TGfwW4AsNdYUXsTPRipab
	pI=; b=FCC2CgzFcFsBVGX77lbxZR54vmSw0M3unkHxYQi5x3hSdF7awO13W38Vh
	Re0aqanh4rb8OPNM+U9NqIalxA7FweySjmlRdhzdlkAqtFyB1gNTy+ow9GKp+Z+I
	HqRfYHk/FkXVIhkNZzqVGiIMM7Xv+5TlT91FDfYkLEb8MZJtW+Tl4aQ/E4EjT3ze
	AwyfcMWbl1ON9OEmEt5Y7eVEiN8MNi9Kajv/xLvpFeT3frYSnT3NRoOu29ddZcAC
	8trj0n9icBflmVRiOgEP17HWkO9fc7HfEPgi5hXdvkgR+Yg4VsIJzLwcCzpvTvDJ
	xSXBm56sjPzqh2yAOv8fZ8qHknVSA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 489ab3hpct-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Aug 2025 15:15:11 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 574Erdtc004594;
	Mon, 4 Aug 2025 15:15:10 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 489yq2e4vq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Aug 2025 15:15:10 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 574FF6fh35258886
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 Aug 2025 15:15:06 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AE48D2004D;
	Mon,  4 Aug 2025 15:15:06 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8974A2004B;
	Mon,  4 Aug 2025 15:15:06 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  4 Aug 2025 15:15:06 +0000 (GMT)
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>, sumanthk@linux.ibm.com
Subject: [PATCH v2] mm: fix accounting of memmap pages for early sections
Date: Mon,  4 Aug 2025 17:13:27 +0200
Message-ID: <20250804151328.2326642-1-sumanthk@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Z+jsHGRA c=1 sm=1 tr=0 ts=6890ce7f cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8
 a=uDGzf9yX4s-_2kI86w8A:9
X-Proofpoint-ORIG-GUID: uZI5NuSuM-9ubMXko91dLJlnURsMaP2E
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA0MDA4MSBTYWx0ZWRfX0fQfiCy9/IHv
 LOHwzbMU0A/cp0keLF/5hC7KrDAqIcUCHra42bywBqwOpBCAAWiGwCsOjW2ifc0AUtRmFnP201u
 iKFklA9cFNvbjvtL7ueyGpafGyXUq8+TaN8VGp6XOteZ+EZ2967GKs2Mza+w/+czTTcyHjqQjjx
 nE+VLmyXFeBBEudIj99T3SXOrIPAOYNnr6cleq1C0PS+QH6tC7CO6IPLo2gtyjeLGLRP09rEHvs
 O4pDldcGwEDZx98kChISofl0coxsLKhWljdLoVI2nwsH9NkQdnldOveqiqTXr2SSDYnH4llP05F
 HSeopl1bqMUQawIKkuVAspLKcMS98gphb7rVdOg/f58s6z4rgTMhhNhlETao9yemtLlLRkKUr9f
 Aw1MzPnOs5u00BvRhxGFmgph9K7qD33u0MDyTZQfKFDt2gXb5L+YdL2LvWkF872rPkVmlvXS
X-Proofpoint-GUID: uZI5NuSuM-9ubMXko91dLJlnURsMaP2E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-04_06,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 mlxlogscore=560 adultscore=0 phishscore=0 mlxscore=0
 bulkscore=0 impostorscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2508040081
X-Stat-Signature: ktywzirx4xutoa8oxnn74cpp9g6k53jp
X-Rspam-User: 
X-Rspamd-Queue-Id: 6A3DF20002
X-Rspamd-Server: rspam02
X-HE-Tag: 1754320512-133605
X-HE-Meta: U2FsdGVkX1/o7/kyqV5UXLEPHympMC2GXH4bgVEXWxEFJoixmgoComwVkuQLCVhwHab3MjhDEby39KNls+/KJ/KAqbS0PO1nBs07mWUAJXYK5BG5CsjX2Oj3M6vwUPgARX8psyNkVNJVHZkMSiHblXlR9rQZXFzUPjN9uOFfQ/pXpEhWDtGdswevlcMecDzdyXkV8CsdUBZwPHI2qjIbPWDINAmP393c/IWtvQPy/KyBlpzz+wKBVm33zhP7H4a+bsoP2/d7dWrhNvzZ+gz8WwNSl72zRjI8820RhfXUuJ9RTX9XB6b7AUX2sa6VG7sUe6cCC/R+ECiQjIhoNx8r6+OpwbpBEtfo5hfjL1N7+LUnpFp/YdDwKzxlDMySqtI/zmIXApH96kJXNGXwqBagIlh9THKOCzxqA5D5tp2zWnRafJupCbBTMuyNt4KpAOZhUO4mxiIQm60YELU6i9Uiah3JFJTNN/Oou/P71HHZ8hc7KOtGe9/fAl7EaZ/X9U4SAeAP9CTnapbaEc9iB8+e0kfsGr8Da4z5RDcgdWTC9Znr+DME31E50+AMIiQRhuJ7K6rUfL3P1bocNiMCy41qhmuueDCaISvtT2+9BLBtKIQlmxyYjFbgYvqNGkOAVz44f5ACpI5QTUsXu8mRNZjJ2THT18N2TmKxA+W8xzm+ltaqt4w7xQhELra1Sn6clNtlRg9mvJJrW/Lwo+NyZ2vISAQLl+oIxyPpMSoq6wV44g/DTPE/GqHjD1c7xVV6sN1Qq/CWg5pv21j7UUbO45Ke2FyGGu0xJiA3K71I49mb6iBiFCQJFW9Sh18cD6aSO+wCnFk8vO3OzXV8pfaz8HV3OdZpChT2ROSgucdlrOhAg8q+0iRJLxdCk+IA/cpQ8f2G6iplMXPhJy2kIJnD6lUeP8Q9PErR/yw6bTXED9BMgqpOFhko5aqViiBbDiSE8mbmAamD8gZc+Qxu3u8j+Ab
 1VwZY/OB
 evvehxQU2xeTywMJ38GO7J0EnvCIao9Ie2pFoyucOJxKVSGkhpz2BNBGrO+l/1Dwi8JibKFEihU1aC39TG3bKWjGcG+3R/+xF4wMNEmMJuQrRDh2QDKbcI5299ZUwLta2nYVMo6hM41BDuxzxbIjSK3w8DV80NJKremDWaNc3/FcES08LZ80NwnwLPTbgDq+RybjnrVXKYJAVP7FCt3CerRvVqFa8fKdEi5v1dAokFd/MLf+botHZQ9YONgBAQhc2mcslBSmCr7By7ibqF0BE+YOtH131X2YI3VpJ02oEnZuMJz/vq7IZFO2Fig7oeq6Mr7KXNE8PPwjHnGbtab37wT22Jw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memmap pages can be allocated either from the memblock (boot) allocator
during early boot or from the buddy allocator.

When these memmap pages are removed via arch_remove_memory(), the
deallocation path depends on their source:

* For pages from the buddy allocator, depopulate_section_memmap() is
  called, which should decrement the count of nr_memmap_pages.

* For pages from the boot allocator, free_map_bootmem() is called, which
  should decrement the count of the nr_memmap_boot_pages.

Ensure correct tracking of memmap pages for both early sections and non
early sections by adjusting the accounting in section_deactivate().

Cc: stable@vger.kernel.org
Fixes: 15995a352474 ("mm: report per-page metadata information")
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
---
v2: consider accounting for !CONFIG_SPARSEMEM_VMEMMAP.

 mm/sparse.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index 3c012cf83cc2..b9cc9e548f80 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -680,7 +680,6 @@ static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
-	memmap_pages_add(-1L * (DIV_ROUND_UP(end - start, PAGE_SIZE)));
 	vmemmap_free(start, end, altmap);
 }
 static void free_map_bootmem(struct page *memmap)
@@ -856,10 +855,14 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 	 * The memmap of early sections is always fully populated. See
 	 * section_activate() and pfn_valid() .
 	 */
-	if (!section_is_early)
+	if (!section_is_early) {
+		memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
 		depopulate_section_memmap(pfn, nr_pages, altmap);
-	else if (memmap)
+	} else if (memmap) {
+		memmap_boot_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page),
+				      PAGE_SIZE)));
 		free_map_bootmem(memmap);
+	}
 
 	if (empty)
 		ms->section_mem_map = (unsigned long)NULL;
-- 
2.48.1


