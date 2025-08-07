Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7349C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 18:36:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C04F8E0002; Thu,  7 Aug 2025 14:36:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74A3D8E0001; Thu,  7 Aug 2025 14:36:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6123B8E0002; Thu,  7 Aug 2025 14:36:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D0368E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:36:11 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 119011374BE
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 18:36:11 +0000 (UTC)
X-FDA: 83750816142.11.82A25E8
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf14.hostedemail.com (Postfix) with ESMTP id 975DA100006
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 18:36:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=mof9kBKP;
	spf=pass (imf14.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754591768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=aKhneyAzDdfZGjI0wau8ksWW5iYO6xcbL43ns9QOCZs=;
	b=ozoQ3+jK17Uv+6YQQ4DBwDg2+im6UmI/crEA6CKqf+AG5afyNqJ38nVel2Op4go6Paeqd7
	ifCI+1GJhq23DuniknuxQ9nr1yvLGYw5ToqMO9VzMCYIoDg8VZOad7IvYXo7Df0WbKtsBT
	UuWYOyJ5QGvx8wRaWu3yftxtl/9PEX4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754591768; a=rsa-sha256;
	cv=none;
	b=H82onrS0U/CMx3Ky54GV/rkUK7HbwWnrHvCBm01QS5pAgL7XeHDW+o+gI5dHgNqIK3BkX7
	dTTejb6TA1SAxSSHdozf8cVNeLjQj6Z4+u9BMPI+d+mpfXcGcO/C/sA5/yYntIJOELWAux
	Y6kZhvd3GXdpf/Z2OK2kj7dnVpIhI1Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=mof9kBKP;
	spf=pass (imf14.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 577FK01Y019425;
	Thu, 7 Aug 2025 18:36:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=aKhneyAzDdfZGjI0wau8ksWW5iYO6xcbL43ns9QOC
	Zs=; b=mof9kBKPdjsZeCBrQDBVlm/p4u6oxZBgLpqgrk/EIf/EqANKdmzqXnWdp
	np5K+dxnbK3XyYO7kAAawTkhyYwl7b/53NMwuVpbSDqwQSsoPF8zSQKs0aBx23Pi
	/8oQUHDTxgNz2jPIQVye7btQtlouYVStUoGxA1IHEX8l3vkjFVWlmB+ZJ9Rcrk3N
	l/4R3aZ5+BSMVc5FPesHA0jts/hVMs+EQd0tpCiKFqfbFXtfaeqgnh4+PzNPS4ps
	6u/JJJe7Lw/gnvk1dJVDuYfZM3B+3F5H1NpqS4u/AWmc+k31lwf7BlmdZqCvqziJ
	E/9DeyfwwL/Ffn+F8HfSV9rAQkmQQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48c26u1ef0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Aug 2025 18:36:07 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 577ITA8c029483;
	Thu, 7 Aug 2025 18:36:06 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48c26u1eeu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Aug 2025 18:36:06 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 577Gq7Yf022661;
	Thu, 7 Aug 2025 18:36:05 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48bpwqj5pn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Aug 2025 18:36:05 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 577Ia19l48890134
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 7 Aug 2025 18:36:01 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4CEBB20043;
	Thu,  7 Aug 2025 18:36:01 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2259A20040;
	Thu,  7 Aug 2025 18:36:01 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  7 Aug 2025 18:36:01 +0000 (GMT)
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>, richard.weiyang@gmail.com
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>, sumanthk@linux.ibm.com
Subject: [PATCH v4] mm: fix accounting of memmap pages
Date: Thu,  7 Aug 2025 20:35:45 +0200
Message-ID: <20250807183545.1424509-1-sumanthk@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Q6gTKsj0jKKFacG6gPQXzsemAJFWNtlj
X-Authority-Analysis: v=2.4 cv=F/xXdrhN c=1 sm=1 tr=0 ts=6894f217 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8
 a=cUr1TRy4Y1kx_8V_9hMA:9
X-Proofpoint-GUID: zyRnUKR7nx37eiBWiP3FzLDWANvrDLTR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA3MDE1MCBTYWx0ZWRfXxAj55tLiecDX
 ZawhDJzPQ98PWwrQ282eCqurzzmouxKExGZuL82WEpF/C1GtVaqMUjm1TFyJVCeKZ8GehrrSvlO
 foGcE4RTwsTs5KABA/ZBr/j6a4PYQ7JloGXYU7GpSSDZ6ojC6iN+7x3K+r66RoyU7qdypCM/kuk
 wthcc89EeopQhctjFvnHcf7PZFQ0u+i3eSBEIjP7eHE67DPhw3u+7M//QLeoiJAiFDagdssVabA
 2MA2kDG2a/Nfz+iZrvFaBC1BQOsGQiknUiiPrJoaSDyugq+mWDsPo54QMcFN5H/OPdtmvbH4E0i
 FF6O5W6bOMJw9D02JgYfbgRwz6ppmTf7gvG6a2fef6lYpMsaRSBODafigN3kBwOw9Z2/3CrH0gU
 Bi1cnXU0KVYeJwnbP47DvN0HFGIa5Oa4tv4BT5bwiVS19M5StY+eafBU6uvBU3bttjGISXPe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-07_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxscore=0 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 clxscore=1015 spamscore=0 bulkscore=0 adultscore=0 mlxlogscore=737
 malwarescore=0 phishscore=0 suspectscore=0 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508070150
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 975DA100006
X-Stat-Signature: ze8y3unn61x6cr1m3mqyjsj8k4omx7an
X-Rspam-User: 
X-HE-Tag: 1754591768-180056
X-HE-Meta: U2FsdGVkX18tGPRBH4UBQTxTKpzj8lc6Lz/cu8sAwDYyFV/jyUerQoS6LmWAR8s9HVhiZ+hGUxW8D5ULZ47r0xGMflrIBxUZAKpUtygydqEt/RQWS83EwG1W9Jw+e0vuKNRp1eKlE3huN8wFuDOEanbd/8g2vC4/kV3G/KTmR6Q7P/CHTxnfD+KHu/PF92ESnK6oBYPkFJSrto9PqnMhOQUscKWXnO2yv0zO3l/g2/rZjfGTIYjKXyxur9LEbG+40gSOMA6ZOLc679aduDLb/sIUgnVpxUvVYs66MR8u73TBlnkWGOrzcrLrISdbRDTZcvIspE9s/CrBoRhck1w3dIYiw6SlBkW8t1BZMExovfnFXPU1C4myt85p5GubN3ConnlJE7J7GJxlL0oqGL0+yQLdvLbDYIvsgCQP7ting0sbK6FFZyikrYYhutH+ksELv0DGw/ggxAIBm8X+TWWRU7ihEzeCU948vAnBrQS+/knOwH82BTO2TZWrF4J4hX1exC323CCp01QU5UxIKNFzqaFnwFZaqT6//MMHTCHF5sY5N7wzJFUbpXDUhdcfjU3aR21F1bPbpB1TX0qqtnJ6i+Fhs02l89ilc+0Yd9WN3h0ZPVWEJOVdPSKDinnyPC0er1UzHGZp89mZLRhfIr4R3dVY8tJ0VCEJjKPkB4hFIR2e36oeQ6Q/gwwKkTv1ZKavjkVQA/qZMUZTucuVtVfzPGVOmF6ioTYkOw1yWB9cCRrcJx3tPr92LysI8HtkOL+IhQ9tJIxG+OB75HkXmtQCxIjAXLD2GNgyTaIhXkyiH1zihj8eIV9HHoVMIHMkHu1U0RqWvDia1fYv2dxd8SCBMJTpepGmHFKuC5FZL8Ujerikcw3+HrNKxoZHrxDcVPBONmEuZARpWoFyyPumiu2AShKP4AVswtmYDLzieK5FJM21aKYQRPEVViS70OKffQmq02+7pzPpEL+GnzI16Fh
 unYPSsE6
 Ifob49yhun0vM+vYmdT8ofcThIOH6kfy7VMYVGQoppAE0MUigOrESw56x5eCOu9QYYygQ9H4aH+HZJnFAhASk9Hy3w4Ise+GuLMsDyV+Rkv29+zHkDuADszcew5s+IeK5JvGGBkAsYx5JNubM5oi/Dh0h/YDwwC935PHtoSsMDgcWO4anfIcDhRcHAmybpC4cKNi3G58zgHA1qp4TFk0VcmEeGr/RO9Wm3cAzYrE/vu85WxlClg4lt8AgOkrNp4cS2b2f1PnAYbRxtPsgb4leDMKaZmEuyrSPDIvX7ORoqBLYASdWu9MBgKFCrk7P3mNivz6ZjPouLHMCYcvwJO7msvG58CCecEdDsXPX
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

Cc: stable@vger.kernel.org
Fixes: 15995a352474 ("mm: report per-page metadata information")
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
---
v4:
* Add fixes and suggested-by.

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


