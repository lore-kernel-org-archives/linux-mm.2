Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3222BC87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 18:25:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB4C18E0002; Thu,  7 Aug 2025 14:25:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8C838E0001; Thu,  7 Aug 2025 14:25:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA2AE8E0002; Thu,  7 Aug 2025 14:25:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AB3A38E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:25:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 59C591DE148
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 18:25:51 +0000 (UTC)
X-FDA: 83750790102.12.93F8898
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0A26CC000A
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 18:25:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=PrsGrTDX;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf10.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754591149; a=rsa-sha256;
	cv=none;
	b=bM/XmA7rowsEhgFkoxCGMVaRRj6uqVFwvq/05IxycK9tfLQIPkHWdWMV1GZW/zYNCA4qyu
	XasKHzDfCSw/DjoJkWMcH5npHPWjWeh2tgeQ6OtFlS79ISGoiLSfjXwI1yHsADiOhU+rQA
	T3QVPE2hyy0MkJb6Y82s6L1hnZHkzNQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=PrsGrTDX;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf10.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754591149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=auVt1lz2iWay6o5XXEJ/LnKIhbRMpP6ex6QcUxffpC0=;
	b=xeMqfM19yPLAPYSCosjJTrWXe9q0UqarXjlIbfSRNftEURrp6o1nDGYxVh1LKEHlFgKLmG
	OTb3nUAtmI1CQzlNwIm+uveHAvaX6IZzJmUDUqMcYsocim0wfDAAt0VRTjDYaHGqwaMpXv
	7CTVb/lMOqgxGk9/bNOct2T/puodZB8=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 577EVOFJ020790;
	Thu, 7 Aug 2025 18:25:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=auVt1lz2iWay6o5XXEJ/LnKIhbRMpP6ex6QcUxffp
	C0=; b=PrsGrTDXVjz+5kGVDv2K7xVULT3dHIr/M/yPyFLK/EIxO0A+p7Fl+l1Tl
	JkFr+FxhT9G1jdQqOK4ywfq7LFJ5o7iYKWzeZQl0xVe5Nv+hZWzk4nySCDHpiP3R
	qtg+tv07AX1zh77ZBpF/6brjQuguM8TLNS915IWT6bl62HyGlqchGK13ZBTIOuxW
	8UMzXQIIgo9NyHotU39LcY2ZyveXi0HZcSTUQim6N/XzVLrQTBFd2pKZVPSCz7Uh
	of+tK89bbR5w7kSgaDNFAvhY0oec9xArc1VlIv0Aw4c0EnKTuUwdtVCCL9EbIOs6
	MGx5iOCkffH8XqTKjXt0bcKxdVyCQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48bq63bvds-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Aug 2025 18:25:47 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 577IODfN010522;
	Thu, 7 Aug 2025 18:25:47 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48bq63bvdn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Aug 2025 18:25:47 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 577GtiME007973;
	Thu, 7 Aug 2025 18:25:46 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 48bpwn23m7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Aug 2025 18:25:46 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 577IPgKA34079270
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 7 Aug 2025 18:25:43 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DAF5020043;
	Thu,  7 Aug 2025 18:25:42 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B10EF20040;
	Thu,  7 Aug 2025 18:25:42 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  7 Aug 2025 18:25:42 +0000 (GMT)
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>, richard.weiyang@gmail.com
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>, sumanthk@linux.ibm.com
Subject: [PATCH v3] mm: fix accounting of memmap pages
Date: Thu,  7 Aug 2025 20:25:31 +0200
Message-ID: <20250807182531.1321991-1-sumanthk@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=NInV+16g c=1 sm=1 tr=0 ts=6894efab cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=cUr1TRy4Y1kx_8V_9hMA:9
X-Proofpoint-GUID: xO3NKyI3t27v08fMWXj0MnD5uz8Ga3yC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA3MDE1MCBTYWx0ZWRfX1PGi2SmfgzN9
 NKAfH35HCXfyO7LyQ8+jmMeUFP8o8nYvCynw4TpG0LqAZR8psVR16yhExZ5uCtIbvvvX/h1czbF
 SXlvSf5KfCHQVI9N8w5evlJxmEcrUDCHtz6VYWDA+E3he81Ib4qdQK+7bOi4UN2cFJo4PKzIIjT
 lbWXIXbXXmIqPDUIjsdPGxid7PnxlruBgMs2LULd5Eei9uuyVKaip4E12a2jA3oqUeTAIHKskj6
 1jjQFoNgUvg7B/qktt4z+xxUxxOU/EP/1SVq+O9fbp7OX4EmDHfDkt80VGIC9sPmZ8htl3srpNw
 zg31//b1yo9Mvg21ar1bUP63tNgtcsbr7mWxLXlroO6FARUKarVNRXCvVVALCahfyyGe1AIIRKv
 FT+oCemUxGM93EEfx9NchO+OvZjeEyHQqekkFFxfYzX/Dw1EZiLG+qX1h543Hb60tDJtBo+q
X-Proofpoint-ORIG-GUID: c_54YO-ButEEpLxgOidf--WW4FqE9DBw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-07_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 impostorscore=0 mlxlogscore=748
 lowpriorityscore=0 malwarescore=0 clxscore=1015 adultscore=0 mlxscore=0
 bulkscore=0 priorityscore=1501 spamscore=0 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508070150
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0A26CC000A
X-Stat-Signature: q587e1inm976g54hkn8gmyfyqkttkhnq
X-HE-Tag: 1754591148-794109
X-HE-Meta: U2FsdGVkX19R9siNu8mnGs0b6cYR0iZbG5al2vnHZ4ZO+uGjPwnBocOzioQ7cqSra76LzFPD8VWmTT1tNXiMQKU1ueXpAtKdMZcyTR12CwMHLS/1iq8xatZFMzI8ZNvkIe9L68c5qe6NP0gn7teNWDLyrOJfkSYxfmYgU2em1B2oLRZSxz300cOYV6SBdJOWFSoz1mAc8xvkxR0LRHRaZUgjptww3T2P8YLoO3KFgGQU2m8N6S6sYSU7PN8HXWAEftcwCtTm+tmU6YFWO8dMCVc/35bd91WKXtUmWDki6J7nRO+/Cz5g+WiDKa17aPVf4e8Cw30ggzMIgwV1aVprr9e7l10DGoyvFDmyel8+rFEf1aA73f9i+iGlxzfRA3DnGTwAsUdcpLKIiEfoC3y+N5IjRAkLGTTsYE/EjZemtjFlM0TWz8MJELUFtB78wILeIWmA6OHh0n3XL5sE8Fj3zfgAkecuPC3m51PpThyZ5uo8/3FTJpaSy8bbr7PVG/lU2r2CJqAJrDfHuFq5JhY7Gvqa7CwM0Ntg+KW7z/GwGX74IMaKVt0BXtMj5wKpqxP6RggFi2V6aqVVBtFvyas6i+AnYjjCoug1dBfywxP28npAKIaa7GOw8ge1NrJ7HkWa9xokwMaAMzfj8FiZrR5xrRV2EKEDOy/1JfoQQzwzGem0l3znBZwBv9OOGtMIuI30EzuALC1/1qzbbEGlojowX4tzyWvOjrPWR6bo8QGOPXSm1ThqnQ2gBw9sHJBLF+xWJ4Z3FD759v9/CdPih9RWB9vdnaKs8F/8twUXMWfVnuJUazD9/s7/4w1Rfw7LIEJFanQspbHGmxfaRGgyWCWISrpdarKR+ygDCoASN6xzHLOi6AgLFYcDumBnaJ+uUVJfMlMmuWVFPkJRbyyl4AL0t0PAJzidOg9wVt1ZlUWyemy+nGcEJ51LqfIvN0RJFyiJfDx3dyQSnpPngfiYHG8
 KH8bcyAa
 npYDTPzVECuWB/cD6aPn6hQ4G4hxKRY6DFtfcgVdt3hwMCH+4djuQ4Dg9kwEH7fID/i2piAPBQSEvzcH4F+Suo8IuQ/rwUy8raek3H7icWQPTTowVfIFiq6ZJxbBbPwCeBCarepJU5gKRn1ptjuA0D5hlt2EtcbMRoZ7Gfi3AWv4EqBli/rox7nX6Fxngqaw/nbZ8Jd3Q7LZCHc15YuqRnBqXjrPBFnUbEVTfF1cOOKoUYFugGBQyrrCPojk04A6PyVxa/ntq5uc9v8jfsB/iUCIDteFc3SeCenPX++wDiAQyfMvWuduX3bcy4tr4EiNmjAO+OOq+Fy1oj/IR6AhRepiIni9vWdG1KyltpgRIXPzV6xS8sZLRQuEiANbhFpt9bheu3KwjlDqSfxg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For !CONFIG_SPARSEMEM_VMEMMAP, memmap page accounting is currently done
upfront in sparse_buffer_init(). However, sparse_buffer_alloc() may
return NULL in failure scenario.

Also, memmap pages may be allocated either from the memblock allocator
during early boot or from the buddy allocator. When removed via
arch_remove_memory(), accounting of memmap pages must reflect the
original allocation source.

To ensure correctness:
* Account memmap pages after successful allocation in sparse_init_nid()
  and section_activate().
* Account memmap pages in section_deactivate() based on allocation
  source.

Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
---
v3: 
* Account memmap pages for !CONFIG_SPARSEMEM_VMEMMAP and only when memmap
  allocation succeeds. Thanks Wei Yang.

v2: 
* Account memmap pages for  !CONFIG_SPARSEMEM_VMEMMAP in
  section_deactivate().  Thanks David.
* https://lore.kernel.org/all/20250804151328.2326642-1-sumanthk@linux.ibm.com/

v1: 
* Account memmap pages for early sections.
* https://lore.kernel.org/all/20250804084015.270570-1-sumanthk@linux.ibm.com/

 mm/sparse-vmemmap.c |  5 -----
 mm/sparse.c         | 15 +++++++++------
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index fd2ab5118e13..41aa0493eb03 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -578,11 +578,6 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
 	if (r < 0)
 		return NULL;
 
-	if (system_state == SYSTEM_BOOTING)
-		memmap_boot_pages_add(DIV_ROUND_UP(end - start, PAGE_SIZE));
-	else
-		memmap_pages_add(DIV_ROUND_UP(end - start, PAGE_SIZE));
-
 	return pfn_to_page(pfn);
 }
 
diff --git a/mm/sparse.c b/mm/sparse.c
index 066cbf82acb8..24323122f6cb 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -454,9 +454,6 @@ static void __init sparse_buffer_init(unsigned long size, int nid)
 	 */
 	sparsemap_buf = memmap_alloc(size, section_map_size(), addr, nid, true);
 	sparsemap_buf_end = sparsemap_buf + size;
-#ifndef CONFIG_SPARSEMEM_VMEMMAP
-	memmap_boot_pages_add(DIV_ROUND_UP(size, PAGE_SIZE));
-#endif
 }
 
 static void __init sparse_buffer_fini(void)
@@ -567,6 +564,8 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 				sparse_buffer_fini();
 				goto failed;
 			}
+			memmap_boot_pages_add(DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
+							   PAGE_SIZE));
 			sparse_init_early_section(nid, map, pnum, 0);
 		}
 	}
@@ -680,7 +679,6 @@ static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
-	memmap_pages_add(-1L * (DIV_ROUND_UP(end - start, PAGE_SIZE)));
 	vmemmap_free(start, end, altmap);
 }
 static void free_map_bootmem(struct page *memmap)
@@ -856,10 +854,14 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
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
+							  PAGE_SIZE)));
 		free_map_bootmem(memmap);
+	}
 
 	if (empty)
 		ms->section_mem_map = (unsigned long)NULL;
@@ -904,6 +906,7 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 		section_deactivate(pfn, nr_pages, altmap);
 		return ERR_PTR(-ENOMEM);
 	}
+	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
 
 	return memmap;
 }
-- 
2.48.1


