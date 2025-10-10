Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D978CCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 08:52:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 912D78E001A; Fri, 10 Oct 2025 04:52:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 829978E0019; Fri, 10 Oct 2025 04:52:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 543068E0019; Fri, 10 Oct 2025 04:52:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2FE708E0018
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 04:52:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E82F5118DB3
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 08:52:09 +0000 (UTC)
X-FDA: 83981587578.14.F9F0B05
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf08.hostedemail.com (Postfix) with ESMTP id B995516000E
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 08:52:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=UI0q4ces;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf08.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760086327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KQ/aGM9rH94UftiKIale0JIwz3RTAt1rdgKxSr6lQpQ=;
	b=5Hha0Ise0ppGmQ1Qx1i6249NkvwSR1f+X6+w6w1jjBiPD0G5LRvbiC4Dn1X0AglByocNt/
	EyyHJr/Bd38a86ri8c2ue+o2hN39G9r9HbGbR767mVq6DX5R+9/7KSOZlWDubnihuNCqOp
	RNyEoQj+FfNFKjLu3OvIw1UqvjJX0FQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760086327; a=rsa-sha256;
	cv=none;
	b=wZx315CGiMM8IhQn7VFvoPS2VIItNdnH1Lxzu1ko6PoBdqm+6YTrt8GcFXO4iocz+v2C9i
	1+zcmPAV2XWBuMkg6jW6+cdusE7cx7lEOW0wMb//IEpbu8oVzNUa+mHKeWxNjluH3lDwRv
	at1GC5MmI0+i/0XDJv331bmmbZwVXCk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=UI0q4ces;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf08.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 599Ksa5R031169;
	Fri, 10 Oct 2025 08:52:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=KQ/aGM9rH94UftiKI
	ale0JIwz3RTAt1rdgKxSr6lQpQ=; b=UI0q4cesThQ2CNy40uv/IG7muqFRSOxJ0
	ib4m3/7/pIDWBf6vU4Sgt3KZGQMi1YPGGPc+j5QMIO+5pX6IcqKfi8UKKa6y6hfc
	Qn0TFwH7uCVRQxevaMLfq+Ap8uQzn++VCRUjF2vai3Y19QOueKAGxFPhuFtypqjm
	mP8Th08nEQutshbKV/a64pZAyl3VlcmM16NSZhtSwJoRqlAhcPzPXpkNjtTBaHtM
	dJL0NxExnBzKURxuAwDyd72doGI/CAfrGluOUqDh3T3B2sd+4OrXVtPT/w55So1+
	uED4M2ElaS/6GqI+kxkNtaqQ4MbGS0E50/qZJwMJ5tlwOlxTrfQug==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49nv81sfxr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Oct 2025 08:52:06 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59A80RPO020979;
	Fri, 10 Oct 2025 08:52:06 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49nv9n109m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Oct 2025 08:52:06 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59A8q2uT29557378
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Oct 2025 08:52:02 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0C9182008C;
	Fri, 10 Oct 2025 08:52:02 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CA8D620091;
	Fri, 10 Oct 2025 08:52:01 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Oct 2025 08:52:01 +0000 (GMT)
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>
Subject: [PATCH v3 4/4] mm/memory_hotplug: Remove MEM_PREPARE_ONLINE/MEM_FINISH_OFFLINE notifiers
Date: Fri, 10 Oct 2025 10:51:47 +0200
Message-ID: <20251010085147.2175918-5-sumanthk@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251010085147.2175918-1-sumanthk@linux.ibm.com>
References: <20251010085147.2175918-1-sumanthk@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NQZ6OBCpbR_KwvA3CBqGLHLSeBLUL9uv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfX9sQhrIFWT5ji
 Q/nDGehyq9f4Qgq2fZFe4OIFBLijyz9538qI+jWDYxxQUZaXurBDhNvjdEn+G3NnOVBvgsnKSuD
 zVZvW9d+KvqsWrlZ83yXnWASD45FlnFjwX6pC6y8E1mYzeuEIcR+AXpEzuM6Q86YuE5JTmZu5TB
 ZZPqzVJGNcbSFFrJtN0wRSuQB2Z2f6aq7xx1hvDp0ks4A6efIsIS5LLGZhvVX0iQE4YryhVqNuD
 pG3UWxnpdSLxeK921W3RhGlaBgUrxR1csVgluMOUpzXNFRpHtpZ2iKorkx4Y92QbDFUsOuEDbui
 CWDe7YXMPEqji+DMe3BH3bU4rHGwXccrzdmmeyrjdPZhfQ1/gyvg0F1zzlWMezfyARW7CJyhSg5
 sKlMN6DgdTjAF0f7QSBzuc2H7apZCg==
X-Authority-Analysis: v=2.4 cv=cKntc1eN c=1 sm=1 tr=0 ts=68e8c936 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=x6icFKpwvdMA:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=rQaNfnSK3a-WYbhgV1gA:9
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: NQZ6OBCpbR_KwvA3CBqGLHLSeBLUL9uv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-10_01,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 phishscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510080121
X-Rspam-User: 
X-Rspamd-Queue-Id: B995516000E
X-Rspamd-Server: rspam02
X-Stat-Signature: wrb8wzpsno3ur5tc9qoniu4yeubnekcg
X-HE-Tag: 1760086327-844106
X-HE-Meta: U2FsdGVkX18k6EWdnMothCwWGi6b+RuIxP/YG1/OFEUOvm5StPaW2/im2npeSmm4cuIA3wxrWqzFbYHkc8IspsOW29M8JKqADTA6DFgOBQ715+bvJYiZj61FLh0G4MMTWFGlZbaEUVzGq7oW7+SliPIyF2wyui4EI0zv1Q4lliN7niD/x0sLknDmfs37TL4WxMoLY1qMho54DB9wLK9xfSeVVMhZqikzGI1hXThISBhZZIB630Ds53cXsqnewZH/CUq4Lvg6WpcXH4hllx9XqAjhfxhQYBb6z147hNSp7wFvTtdrJNCYqUug8bTj89VTtwSjB5NXCVGPsgy5mBDee9dHidCmfLa9mprMv39yY2Jdk9yZvKE5uOh/9as5r6z6bIZjRs4TNp6VqVENIuqq+lFbrDYP9nL4CP2OevBWaLxlSaHFwZle1z5D3etO7bSQNCsUS5UX8tSv/BeO/44bNqTS/32GauHPhD5TqBd3o09UeIjYfLfNC6a5Uy6/pq3OvOrMEVdBvsGWcSgp9UUlOd5FzUVdKcHnZkQfi2dF+yzR2qmjG/Of/2Xk7JW90YBRkEo+xl+qS6ZG2KLIsj5M8DFITaRRNISewnO649wtmyGshlRG1tKjbkW+smQdxRMpIqABWPEmx45zLLQ3tZDpU6wbmTDGI0OeFn0Iuz1jWMYT88ycDUA9V/IKVsuqHH1iJDYErM1H2cCJbz6lqJ/ST0XmJoCwb+9r8B61JuovRjzvQGhxUb7jxYVUHU8htDSJ0Z7O0M76bVPfADLn9AW+orFOQFFA5pUd+c41nUPGrWNJM4FnOnNUgbJ7P/e2rGyeOWs7rYUWoTwtaWRfJM6S6eazIeOpewE15xcORpi/nKoCDniqdGNaNVoEG7RizYJPByorr6xbN0jBonndAjFkKPmkJQUfMVktftM8zzohTd7YVn3OrIAGgWef2yCAdOLg7VzF8SJ+D44I9nHyqPo
 +rwyoBLd
 mPgdvta0/zP2wNT24yapArObBMBHGaOG9ceQ8RP6a8775BZVw53H/oCgXTqcU8JO1mj1RInKBUtME75KjuIdpLeHVN9S43jDx5sFHGC/CB+Ns5G4mtpc99j6LW+EWyZhX9oO4bPIb4+uG2fxdunTdJWXrpV6eB7K3whVEck0xvtoEHStY62RuYVfyIPZPDM2AZnW0ovPCuMnpowFxRs2Bihvccb/+YFI5pv/sb8UUoGjttfBfiANly77E6/ECqIiv28DYtQ494iJcTVx37COgpuR7C6R1W6N78ZlfePerjQ2K4PPpesRc+hfjBw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MEM_PREPARE_ONLINE/MEM_FINISH_OFFLINE memory notifiers were introduced
to prepare the transition of memory to and from a physically accessible
state. This enhancement was crucial for implementing the "memmap on memory"
feature for s390.

With introduction of dynamic (de)configuration of hotpluggable memory,
memory can be brought to accessible state before add_memory(). Memory
can be brought to inaccessible state before remove_memory(). Hence,
there is no need of MEM_PREPARE_ONLINE/MEM_FINISH_OFFLINE memory
notifiers anymore.

This basically reverts commit
c5f1e2d18909 ("mm/memory_hotplug: introduce MEM_PREPARE_ONLINE/MEM_FINISH_OFFLINE notifiers")
Additionally, apply minor adjustments to the function parameters of
move_pfn_range_to_zone() and mhp_supports_memmap_on_memory() to ensure
compatibility with the latest branch.

Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
---
 drivers/base/memory.c          | 23 +----------------------
 include/linux/memory.h         |  9 ---------
 include/linux/memory_hotplug.h | 18 +-----------------
 include/linux/memremap.h       |  1 -
 mm/memory_hotplug.c            | 17 +++--------------
 mm/sparse.c                    |  3 +--
 6 files changed, 6 insertions(+), 65 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 6d84a02cfa5d..fc43f2703ae0 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -226,7 +226,6 @@ static int memory_block_online(struct memory_block *mem)
 	unsigned long start_pfn = section_nr_to_pfn(mem->start_section_nr);
 	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
 	unsigned long nr_vmemmap_pages = 0;
-	struct memory_notify arg;
 	struct zone *zone;
 	int ret;
 
@@ -246,19 +245,9 @@ static int memory_block_online(struct memory_block *mem)
 	if (mem->altmap)
 		nr_vmemmap_pages = mem->altmap->free;
 
-	arg.altmap_start_pfn = start_pfn;
-	arg.altmap_nr_pages = nr_vmemmap_pages;
-	arg.start_pfn = start_pfn + nr_vmemmap_pages;
-	arg.nr_pages = nr_pages - nr_vmemmap_pages;
 	mem_hotplug_begin();
-	ret = memory_notify(MEM_PREPARE_ONLINE, &arg);
-	ret = notifier_to_errno(ret);
-	if (ret)
-		goto out_notifier;
-
 	if (nr_vmemmap_pages) {
-		ret = mhp_init_memmap_on_memory(start_pfn, nr_vmemmap_pages,
-						zone, mem->altmap->inaccessible);
+		ret = mhp_init_memmap_on_memory(start_pfn, nr_vmemmap_pages, zone);
 		if (ret)
 			goto out;
 	}
@@ -280,11 +269,7 @@ static int memory_block_online(struct memory_block *mem)
 					  nr_vmemmap_pages);
 
 	mem->zone = zone;
-	mem_hotplug_done();
-	return ret;
 out:
-	memory_notify(MEM_FINISH_OFFLINE, &arg);
-out_notifier:
 	mem_hotplug_done();
 	return ret;
 }
@@ -297,7 +282,6 @@ static int memory_block_offline(struct memory_block *mem)
 	unsigned long start_pfn = section_nr_to_pfn(mem->start_section_nr);
 	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
 	unsigned long nr_vmemmap_pages = 0;
-	struct memory_notify arg;
 	int ret;
 
 	if (!mem->zone)
@@ -329,11 +313,6 @@ static int memory_block_offline(struct memory_block *mem)
 		mhp_deinit_memmap_on_memory(start_pfn, nr_vmemmap_pages);
 
 	mem->zone = NULL;
-	arg.altmap_start_pfn = start_pfn;
-	arg.altmap_nr_pages = nr_vmemmap_pages;
-	arg.start_pfn = start_pfn + nr_vmemmap_pages;
-	arg.nr_pages = nr_pages - nr_vmemmap_pages;
-	memory_notify(MEM_FINISH_OFFLINE, &arg);
 out:
 	mem_hotplug_done();
 	return ret;
diff --git a/include/linux/memory.h b/include/linux/memory.h
index 0c214256216f..ba1515160894 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -96,17 +96,8 @@ int set_memory_block_size_order(unsigned int order);
 #define	MEM_GOING_ONLINE	(1<<3)
 #define	MEM_CANCEL_ONLINE	(1<<4)
 #define	MEM_CANCEL_OFFLINE	(1<<5)
-#define	MEM_PREPARE_ONLINE	(1<<6)
-#define	MEM_FINISH_OFFLINE	(1<<7)
 
 struct memory_notify {
-	/*
-	 * The altmap_start_pfn and altmap_nr_pages fields are designated for
-	 * specifying the altmap range and are exclusively intended for use in
-	 * MEM_PREPARE_ONLINE/MEM_FINISH_OFFLINE notifiers.
-	 */
-	unsigned long altmap_start_pfn;
-	unsigned long altmap_nr_pages;
 	unsigned long start_pfn;
 	unsigned long nr_pages;
 };
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 23f038a16231..f2f16cdd73ee 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -58,22 +58,6 @@ typedef int __bitwise mhp_t;
  * implies the node id (nid).
  */
 #define MHP_NID_IS_MGID		((__force mhp_t)BIT(2))
-/*
- * The hotplugged memory is completely inaccessible while the memory is
- * offline. The memory provider will handle MEM_PREPARE_ONLINE /
- * MEM_FINISH_OFFLINE notifications and make the memory accessible.
- *
- * This flag is only relevant when used along with MHP_MEMMAP_ON_MEMORY,
- * because the altmap cannot be written (e.g., poisoned) when adding
- * memory -- before it is set online.
- *
- * This allows for adding memory with an altmap that is not currently
- * made available by a hypervisor. When onlining that memory, the
- * hypervisor can be instructed to make that memory available, and
- * the onlining phase will not require any memory allocations, which is
- * helpful in low-memory situations.
- */
-#define MHP_OFFLINE_INACCESSIBLE	((__force mhp_t)BIT(3))
 
 /*
  * Extended parameters for memory hotplug:
@@ -123,7 +107,7 @@ extern void adjust_present_page_count(struct page *page,
 				      long nr_pages);
 /* VM interface that may be used by firmware interface */
 extern int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
-				     struct zone *zone, bool mhp_off_inaccessible);
+				     struct zone *zone);
 extern void mhp_deinit_memmap_on_memory(unsigned long pfn, unsigned long nr_pages);
 extern int online_pages(unsigned long pfn, unsigned long nr_pages,
 			struct zone *zone, struct memory_group *group);
diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index e5951ba12a28..30c7aecbd245 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -25,7 +25,6 @@ struct vmem_altmap {
 	unsigned long free;
 	unsigned long align;
 	unsigned long alloc;
-	bool inaccessible;
 };
 
 /*
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 0be83039c3b5..238a6712738e 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1088,7 +1088,7 @@ void adjust_present_page_count(struct page *page, struct memory_group *group,
 }
 
 int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
-			      struct zone *zone, bool mhp_off_inaccessible)
+			      struct zone *zone)
 {
 	unsigned long end_pfn = pfn + nr_pages;
 	int ret, i;
@@ -1097,15 +1097,6 @@ int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
 	if (ret)
 		return ret;
 
-	/*
-	 * Memory block is accessible at this stage and hence poison the struct
-	 * pages now.  If the memory block is accessible during memory hotplug
-	 * addition phase, then page poisining is already performed in
-	 * sparse_add_section().
-	 */
-	if (mhp_off_inaccessible)
-		page_init_poison(pfn_to_page(pfn), sizeof(struct page) * nr_pages);
-
 	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_UNMOVABLE,
 			       false);
 
@@ -1444,7 +1435,7 @@ static void remove_memory_blocks_and_altmaps(u64 start, u64 size)
 }
 
 static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
-					    u64 start, u64 size, mhp_t mhp_flags)
+					    u64 start, u64 size)
 {
 	unsigned long memblock_size = memory_block_size_bytes();
 	u64 cur_start;
@@ -1460,8 +1451,6 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
 		};
 
 		mhp_altmap.free = memory_block_memmap_on_memory_pages();
-		if (mhp_flags & MHP_OFFLINE_INACCESSIBLE)
-			mhp_altmap.inaccessible = true;
 		params.altmap = kmemdup(&mhp_altmap, sizeof(struct vmem_altmap),
 					GFP_KERNEL);
 		if (!params.altmap) {
@@ -1555,7 +1544,7 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 	 */
 	if ((mhp_flags & MHP_MEMMAP_ON_MEMORY) &&
 	    mhp_supports_memmap_on_memory()) {
-		ret = create_altmaps_and_memory_blocks(nid, group, start, size, mhp_flags);
+		ret = create_altmaps_and_memory_blocks(nid, group, start, size);
 		if (ret)
 			goto error;
 	} else {
diff --git a/mm/sparse.c b/mm/sparse.c
index 17c50a6415c2..b5b2b6f7041b 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -951,8 +951,7 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
 	 * Poison uninitialized struct pages in order to catch invalid flags
 	 * combinations.
 	 */
-	if (!altmap || !altmap->inaccessible)
-		page_init_poison(memmap, sizeof(struct page) * nr_pages);
+	page_init_poison(memmap, sizeof(struct page) * nr_pages);
 
 	ms = __nr_to_section(section_nr);
 	set_section_nid(section_nr, nid);
-- 
2.48.1


