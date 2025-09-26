Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32DA1CAC5B9
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 13:15:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7865A8E0007; Fri, 26 Sep 2025 09:15:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75CB38E0001; Fri, 26 Sep 2025 09:15:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 673F58E0007; Fri, 26 Sep 2025 09:15:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5683B8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:15:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F351313B683
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 13:15:54 +0000 (UTC)
X-FDA: 83931449028.11.1CDB378
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf01.hostedemail.com (Postfix) with ESMTP id 80E9C40007
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 13:15:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=i8at7bHM;
	spf=pass (imf01.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758892552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gV/IEYO2glJLkKDxGEoo83TGM27QnjVGn/AU6yyi65I=;
	b=JsiS2Hn9OaYOJOhHHVyo45odCgJk0VdDKZJ68L8Q1d8JUlnbufUZSbT4EVC/F0n61nNH1J
	ulhoEkfmX/FW8iMZdlS/ffPNrQrBb4ayIV3n6kS7dhKTHMYBb0B3jRDWrCtPeGh2cmJ8HN
	RPyABmJFtrkuGpoQeXJAQ5aArCxK6Yw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758892552; a=rsa-sha256;
	cv=none;
	b=OtDUeXx+r/X8C1seFhnFt3/z7MUzi70RN7x84H73dnDbcMt1OXcQtnMM3lxjpDeuPuGJBI
	9zTk0ETCbGnqg/ormIq43OdFNlbMEGLUJSeyxEuMw/aUgXoty1NxpaGIIw7MaN5V/enAjM
	7KbQYho0PFmOUsVIGLkLDs6lVTtYQ74=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=i8at7bHM;
	spf=pass (imf01.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58Q6PN0W029313;
	Fri, 26 Sep 2025 13:15:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=gV/IEYO2glJLkKDxG
	Eoo83TGM27QnjVGn/AU6yyi65I=; b=i8at7bHMSmijNym+1atYYowrVL+bSKVtj
	x/4WgjfylhVAL1j3sBwCPkubLwan9v4P869/wzHdkddFpBxaaB90EIk0aeZJ3OuC
	8EldLj6YzK+MaC88//fkhpHr4B1fbSzVqT35Pz9rf9x4DgMuSV0SGy+E/AJBWuUX
	z8cBXS6jYZ3lY0jDSYvOipxqkKEsv1g6j+NbkSkZ9qWpkTlFy1hwjH/+YBXhFoUJ
	c1wE7eKu9G6bS5lW22nGfUQ7pKISSLbjIR6Km0znOHSl+Bms6Zt6D+a8O8cfsMxT
	MKp7pIheqlbOzo4tZNoQk4WtPsXHZOh2Z6av99PvXxTjNyokAooXA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49dbb3vmqf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 Sep 2025 13:15:51 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58QAS9mk025764;
	Fri, 26 Sep 2025 13:15:49 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49dawpv5ne-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 Sep 2025 13:15:49 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58QDFj7512714382
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Sep 2025 13:15:45 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3B2C920043;
	Fri, 26 Sep 2025 13:15:45 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 195CB20040;
	Fri, 26 Sep 2025 13:15:45 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 26 Sep 2025 13:15:45 +0000 (GMT)
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>
Subject: [PATCH 1/4] s390/mm: Support removal of boot-allocated virtual memory map
Date: Fri, 26 Sep 2025 15:15:24 +0200
Message-ID: <20250926131527.3260733-2-sumanthk@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250926131527.3260733-1-sumanthk@linux.ibm.com>
References: <20250926131527.3260733-1-sumanthk@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI1MDE3NCBTYWx0ZWRfX6Oh5o/lzj5MP
 UKbmwzir5HNZy/pxOsr7IuqzJr5E3LSLxG2NZCUjUBhjG3Wxy2xaQYVw5Muw1F1nj6QjnE6hiEr
 1DjAQQmBcR+l9enQqAlqehxq3IKwtLM4lbR+kMhmilqLSA22KOOvVdmbPrP8Tg3ICSfXa6Jl9KY
 1DsEnrPxLYaYhMFX3lf0qKxb1KPmQKeWLEESmqJZjsK91dSQJPGKgTDJlz7XkaE5x43afGfMXQR
 qymCMfuvcpPAvZYGLz4aGCtXkfQqSesE0xq9/soDeIjF8hTRVQNmO3gXVktsKc3a7M7YXAkbYS0
 TCFZ0sBIP7IgfjY26TPz1P8kD9hhvFOY81ZMzpGLtmRfCfsDiT44vByOuwWEwdZu4tq4EB8T/K2
 F0oLj+qEyYw7rhUUiRe09SzMwxA89Q==
X-Proofpoint-GUID: -VOXTBMVfTR0bzdJ_cUwsiAfDhyR18vo
X-Authority-Analysis: v=2.4 cv=T/qBjvKQ c=1 sm=1 tr=0 ts=68d69207 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=To8m7Vbe2ZeGRMaUrlAA:9
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: -VOXTBMVfTR0bzdJ_cUwsiAfDhyR18vo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-26_03,2025-09-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509250174
X-Stat-Signature: o4aaxq6bxm8b8puemuyqsi63ghn75p5n
X-Rspam-User: 
X-Rspamd-Queue-Id: 80E9C40007
X-Rspamd-Server: rspam10
X-HE-Tag: 1758892552-374394
X-HE-Meta: U2FsdGVkX19p9h3fPhMWPVZgGPpAVu5uAVOLw8Qxr0qCaniBGnTsIfngLxV30GPnxKmpBaaeOrMtATADR6E3eaWSTH6oTc0qRu7wZbP+Rn8JSLdBCFigMsdGXUDaGeWjpkTRC+Y4Mtqrn7WxGk3KNv4ko/wfRjlJRTjn0Bhlf1Oyt5ketIcs5l/TfoXdsAyJlU5cK2mFX3YwdRLuP0zNZdqE3+DHwQLhPK2E7Yk6R+6vi4pW3iN94uBgXa1ejJi1YGITpgG6pzNStJ0pxva0XOcMEhc6pCPYud6W20zJd3PFHqigXdqPDRZAfboLFjkNQxTQuBKVVYLzjlwM+ul3VbJ4B26q1V19vb28evmKsyRnqV9Am5comCyzQehFP1idXYAC+CMLJXa0QoCnRUqdztrCCo9/WzjBrCtHUtR4o8DaXQEL7jlvOl2GBpAvXsWXZbrIbuzpQj73+eSPS5clkEZvRX5sF2rrMaUcjt9tI6uHsljfu8557jlbnnaHUGBZI9iJtcWY+sVITtWSBgXto33sW76noRi3/AEHiY9QPVmwMBwR6zDIRV+8MJs7Cp3QQ+wEkPtmWlYIo9qOwmQXNsQSvkBrK2EyUHgVpSxR/lU92MjZjXsxBA39aIik0ilZmz7qVu8yuMY/U6nO2ZLupvsnqdtF7sFZGk859lcfjIqGoOqr/5Mb+Crok0RLoYXpAA+OYiSNKPw95rnhKSMSm+RDf6xBy6irJQbBvtlrsIQnTNQ4x4ZdOToB18jmFwcqL40mAkM9ZjlmsVRVFsIt4FCLxwsJ7SXTP+GWnA1v+J0DbDEx0fQ5s6Unp/phxHHFDh8wpb0aPz3juwcLJDIxSrnGkVgeE2oMT8t5S7GLUUYhlTCNfC7B8K2sOvU1a7aFtc+HKr+ebWUGDDQkAoRPAm2c4bGqXg6OKwGZYx0JEcf4l4Z4s2dqT2QhNi7M7+st4r+3Fh4t51tQJQoWZnl
 t3AFS/Sz
 ITlnMJPNeqJZ4Wfk59u1HoLHFs2I5TExuMqCQsZjSJ+gXsXd4mymvopfrX6S6U3vNEMiVOCujEi6fQRtNbJNuOdslG0wxx4RJ32W29dVUya6IW7WX/OrPTokgVX4FdQafQc+FLfn+WwlimnuBalIE1rLs9Lkni5ibgp1EM5OBLWjdU5O02AqmnRoL/T3d9hw+GxeZrDMBa9ErOXw87XZoDLwpQ7MzW3KiNvrZnachIGkWjaw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On s390, memory blocks are not currently removed via
arch_remove_memory(). With upcoming dynamic memory (de)configuration
support, runtime removal of memory blocks is possible. This internally
involves tearing down identity mapping, virtual memory mappings and
freeing the physical memory backing the struct pages metadata.

During early boot, physical memory used to back the struct pages
metadata in vmemmap is allocated through:

setup_arch()
  -> sparse_init()
    -> sparse_init_nid()
      -> __populate_section_memmap()
        -> vmemmap_alloc_block_buf()
          -> sparse_buffer_alloc()
            -> memblock_alloc()

Here, sparse_init_nid() sets up virtual-to-physical mapping for struct
pages backed by memblock_alloc(). This differs from runtime addition of
hotplug memory which uses the buddy allocator later.

To correctly free identity mappings, vmemmap mappings during hot-remove,
boot-time and runtime allocations must be distinguished using the
PageReserved bit:

* Boot-time memory, such as identity-mapped page tables allocated via
  boot_crst_alloc() and reserved via reserve_pgtables() is marked
  PageReserved in memmap_init_reserved_pages().

* Physical memory backing vmemmap (struct pages from memblock_alloc())
  is also marked PageReserved similarly.

During teardown, PageReserved bit is checked to distinguish between
boot-time allocation or buddy allocation.

This is similar to commit 645d5ce2f7d6 ("powerpc/mm/radix: Fix PTE/PMD
fragment count for early page table mappings")

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
---
 arch/s390/mm/pgalloc.c |  2 ++
 arch/s390/mm/vmem.c    | 21 ++++++++++++---------
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/s390/mm/pgalloc.c b/arch/s390/mm/pgalloc.c
index ad3e0f7f7fc1..596c05244ed0 100644
--- a/arch/s390/mm/pgalloc.c
+++ b/arch/s390/mm/pgalloc.c
@@ -164,6 +164,8 @@ void page_table_free(struct mm_struct *mm, unsigned long *table)
 {
 	struct ptdesc *ptdesc = virt_to_ptdesc(table);
 
+	if (pagetable_is_reserved(ptdesc))
+		return free_reserved_ptdesc(ptdesc);
 	pagetable_dtor_free(ptdesc);
 }
 
diff --git a/arch/s390/mm/vmem.c b/arch/s390/mm/vmem.c
index f48ef361bc83..d96587b84e81 100644
--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/memory_hotplug.h>
+#include <linux/bootmem_info.h>
 #include <linux/cpufeature.h>
 #include <linux/memblock.h>
 #include <linux/pfn.h>
@@ -39,15 +40,21 @@ static void __ref *vmem_alloc_pages(unsigned int order)
 
 static void vmem_free_pages(unsigned long addr, int order, struct vmem_altmap *altmap)
 {
+	unsigned int nr_pages = 1 << order;
+	struct page *page;
+
 	if (altmap) {
 		vmem_altmap_free(altmap, 1 << order);
 		return;
 	}
-	/* We don't expect boot memory to be removed ever. */
-	if (!slab_is_available() ||
-	    WARN_ON_ONCE(PageReserved(virt_to_page((void *)addr))))
-		return;
-	free_pages(addr, order);
+	page = virt_to_page((void *)addr);
+	if (PageReserved(page)) {
+		/* allocated from memblock */
+		while (nr_pages--)
+			free_bootmem_page(page++);
+	} else {
+		free_pages(addr, order);
+	}
 }
 
 void *vmem_crst_alloc(unsigned long val)
@@ -79,10 +86,6 @@ pte_t __ref *vmem_pte_alloc(void)
 
 static void vmem_pte_free(unsigned long *table)
 {
-	/* We don't expect boot memory to be removed ever. */
-	if (!slab_is_available() ||
-	    WARN_ON_ONCE(PageReserved(virt_to_page(table))))
-		return;
 	page_table_free(&init_mm, table);
 }
 
-- 
2.48.1


