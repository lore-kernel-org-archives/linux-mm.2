Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BEDECCD184
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 13:19:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97D968E0095; Thu,  9 Oct 2025 09:19:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E7678E0098; Thu,  9 Oct 2025 09:19:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C2078E0097; Thu,  9 Oct 2025 09:19:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 080438E0095
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 09:19:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C020811B0A8
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 13:19:04 +0000 (UTC)
X-FDA: 83978631408.27.BB3AD76
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6656E4000D
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 13:19:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=UdxRPyiQ;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf07.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760015942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IRCYsVBNlKYerMoXiWnkluUK6QHgLsXvSZKnJ1VkvWg=;
	b=ydx5QWL+M2Urj1zu3zWAc+KpcSLZgEj56cpuTjUWpGPG9eJA4JJI8/k1raZfVFcveG0fK7
	id/9j5H8Ws/z3+E3a4vzEDd1LvQyAcsQaIYCKqgqQPef3G7Sy9i+iX6qgLWpKs8GutwjW/
	xtubQIYLFDayFY63XNUc+Yj8Fqa8Y/8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760015942; a=rsa-sha256;
	cv=none;
	b=YtRHisV0rKcD/WjcQSdmtkngrvtF0rFqGLSlA6IyBCIf+AqITlGDjr9y/5VIW4TRB3lxnb
	kQZyj9jpNFNBgAX9mMgTa5uhGFPniUr8GD+GwwYtawc7kVGnYcIjdqpii5b+VWP98eBa3c
	ugD5aM+sdIGA12zHh3f8mG84GxHxaAg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=UdxRPyiQ;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf07.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 599627MN007662;
	Thu, 9 Oct 2025 13:19:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=IRCYsVBNlKYerMoXi
	WnkluUK6QHgLsXvSZKnJ1VkvWg=; b=UdxRPyiQtXsR1WJfetPPrq7v6vxFcW1Kh
	M7Dky5TDTQV/aoVXJIbdhnyowfnMEBm+MXbXwd1YbkPWT1u0Dovputnz4U5sio8W
	dkYWTEn8FBtBjhc9x+QJkMgOhxGMYa89nJcaz/TOUnJkugQIwbWZO/6fFg4vSdZD
	cm14TgwhtCs7p18/vUICgUd42+LP0XbHWjm5PpexNivmDDR/BJvaIkTRg2MZXdrX
	ENIABcrd+qyKxGjIEzyt7u2k2PQU4Q7ktjLF5eZW9mKC31POrBqoXreAtI2SRpvd
	tGrFJohOkFIU3Zah2QfU4n+uAYOW+5jcpEou94dibF8NBhbQ3r4sA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49nv804y90-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Oct 2025 13:19:00 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 599CFZFm022812;
	Thu, 9 Oct 2025 13:18:59 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49nv8vcngn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Oct 2025 13:18:59 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 599DItBB56361440
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Oct 2025 13:18:55 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B14A920040;
	Thu,  9 Oct 2025 13:18:55 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 834F72004B;
	Thu,  9 Oct 2025 13:18:55 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  9 Oct 2025 13:18:55 +0000 (GMT)
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>
Subject: [PATCH v2 1/4] s390/mm: Support removal of boot-allocated virtual memory map
Date: Thu,  9 Oct 2025 15:18:36 +0200
Message-ID: <20251009131839.3739108-2-sumanthk@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251009131839.3739108-1-sumanthk@linux.ibm.com>
References: <20251009131839.3739108-1-sumanthk@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=NsDcssdJ c=1 sm=1 tr=0 ts=68e7b644 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=x6icFKpwvdMA:10 a=VnNF1IyMAAAA:8 a=To8m7Vbe2ZeGRMaUrlAA:9
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: 0MT_MPCLfPTP8LJVQ9y6xIFGbashhyf8
X-Proofpoint-ORIG-GUID: 0MT_MPCLfPTP8LJVQ9y6xIFGbashhyf8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfX6Tea3Id5p7vv
 o3BN040OxR3h3sJ3xd3FNIb0HQysRsifcAYNwR1rI9YM1Z6J02qlpha0aPdnaZc378Y670Pdj7n
 SMt6Q4dzafF5xiFno2r30O3LS/W9HfBTsbmxPC3k6UuUAGCXFpctd9VS/ZIhlv1BO2shogShcQ9
 OVRohzbafhKapyTRAoHBncYXukai4tTWXWNPKdK6jNg95Pl37YIllAd7f7ARpn84Y5915vF1soC
 O74+qSq+EYnZYpOsOlOfFQqTVWUVLVcR4IHmWl0u7tRqayfHkUYQfV7xKo0LrdwquNXM7rF/Y5N
 Y0U+PqZke+JnbyfNc9y8fOjSZuWleBPXOUROjFTMitNRwLsB8B2KDxB86C8XEmOCxtKGvhBuJBo
 XO5RMpUyRIBAyavtPZ3s2UbZsfNOvA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-09_04,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 impostorscore=0 adultscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510020000
 definitions=main-2510080121
X-Rspamd-Server: rspam01
X-Stat-Signature: 5ninqwjo6eizhnnxzibzkixeu5chc4qf
X-Rspam-User: 
X-Rspamd-Queue-Id: 6656E4000D
X-HE-Tag: 1760015942-332740
X-HE-Meta: U2FsdGVkX19j7/5T8I4af8dDvuLJXF8NkSv2OjOP6Oy1PdgFOQ7I/QDZ7AhMvpyKOMbrbQTiX7NUzYxLddKJf1ihObsYer5rlmzzZKSHmsaeHoqoAanSbrPLnLdK7kr0GhERdBCsdurbYOFgHsITjgkg9+FU7ps2tcVJrfOMeGr3he4fTr5saSsn1Q5rywW7iC+ySpF5YGbICSMsF+oYs25U6Z1bU+QTYtcg1X3nZ5XzIW34L2xDnmFMs8cTJUjaHPVuzkTuCbk0wF8O3WLE1oDwutbftHzioCVKO2zZZ1t6mhX73qQo6YEeeCHIixiGHpkHTrSWIDfDMqC1lixdnzIXfpSTraKDYExpJJKfrJmPS380iZRUi59+b+LKiGXUxQDQ2C9eUZFzF/jxkRTgkBs6/Fgc9wwBgty1MmZkIF3ESIZBgtvPVGvRybvQx8sXzYUbcMVxfVnNq0s8IxQayeJqJiSQMXUdQBF8k4cO9fGf5uhBbF2FOPz576FRHFWjygn95HvKk+l9zsMVzD00Vi7v6CBv7o1W0sR+eoQEoDk7AwotznyWItMeIJeEZbjes3DJFU8ilcP/y587Jq20tmdyDekU/VpAGoHNJDbPZslO/v6iQKTln3LQt5hxIEbZhluDEluwbkddTxGKNkcsJOQUPwGGwT6ha2g6bvWKkG+ehFCWbwGhtGKQZkWmdWS+szJOypfkZaxVmOtWGIifVPGISAxNXCNoIlZn3JXU1Lc2Yd9eolTvpbFqNNTUH3UUVJvqQ2qM92K5EvtCR5IeRMi1RpqZti6l81cmt6J735hzkIZUaK0HHZBfMPrNa6rRHq2nsJ95/tomaGm1hCVjfx3RJxbOY34XqVBLF8Ac1x2ANoPKtQ17toGryD93ITyJksiUfii+01LbHVVnXQ4v1qm4gJ8x0Qq4xshpIs0isZ9FS880gb6/3uPh4/84rk216sJToaHX+sXGx9nZRwu
 JRyDv9jf
 qC/ZvckEI6ynw9vB4vQYfwJyVcD2myGXeHzgIiY3QOZjvQGZJknhltmKjQFnpmOAYIU8ErG7Vr162oPHKp8DY+Gmj1eKWS4EvChMEWILzTu9GZB89YjSSygIVLaFnXDp24ZssQgrPfq/Kcs/oQUiFgsyXj4Ts4HnVAu4PHDtTv82ceMyfD9vh/e2J5jL7EHh/1NAQXl4sBNo4eio=
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
index 626fca116cd7..7df23528c01b 100644
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


