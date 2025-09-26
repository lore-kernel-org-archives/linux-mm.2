Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF9E7CAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 13:16:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 402678E000C; Fri, 26 Sep 2025 09:16:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B40B8E0001; Fri, 26 Sep 2025 09:16:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 254458E000C; Fri, 26 Sep 2025 09:16:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 148A38E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:16:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C417911AA82
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 13:15:59 +0000 (UTC)
X-FDA: 83931449238.25.3C64B38
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf16.hostedemail.com (Postfix) with ESMTP id 669E2180010
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 13:15:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=I8s2oBiz;
	spf=pass (imf16.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758892557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lH43ym57j6oeb9QqSBHnLDAMK6emsEJ0+JYF/U+O3AU=;
	b=6r6dslAV9Piux7Ak+ajtKD2MlaMRFHxIZpsKgphIEkyVa4UO04gP2Kwo7YQ+N4whRlQE6d
	lc43MT62AtPpC00tR8S5h+VyqeyM+ARqbLIc+2FygZbuGufsvI0bAYdUqSb0pBY1oDtlKs
	52LA/kfRrLjksYaYx32VXFF3QziCfxE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758892557; a=rsa-sha256;
	cv=none;
	b=OAbJ98rsEqfzShbmpVT4zdtA1CZPlLDm7q1nTDgLJsEJxoy+uWChsKSpMAuEuQHvzEwPUp
	Cj+/lMMlTLflhVNcxuNfwjjPkkvZ4FEdCLIX40yOpGT4DG+9qSrqKMP1rUqc21dz2r+EyM
	70mE1bWYy39uH4gp1f9UsvY4rVGcbs4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=I8s2oBiz;
	spf=pass (imf16.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58Q7Va1M017943;
	Fri, 26 Sep 2025 13:15:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=lH43ym57j6oeb9QqS
	BHnLDAMK6emsEJ0+JYF/U+O3AU=; b=I8s2oBizyYzr8Gm62B9PYypKw4IMdmFsU
	o7p2moc7cMcP6VHKAfySeaLp0lv74XjVcD7gtvNLKKPSy18AL+6+05Sy2N5bbauB
	yT9QAE8iN38XrggyX+S7Cr0SII5E1cBnsdeveRdMMuWOi+X7CD4KKzVV8RanYD/F
	wNQ6mEiVmwSzVzRN4hOg5EGy63HftyU8vOCgRTmx5/p2u3tDlppaSEwIUglqUs90
	KnVpN/yMPjsojL7BvptMACjC63ZkvUzV0be3ymmFXgEleLUb4Qg//AZKxL14lNIX
	t6IghYmkfAz9pKzzkMyb/yYiYbWJfP7KCunRrTW1aZ2JTZ1Grk4uw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49dbbdcqcd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 Sep 2025 13:15:55 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58Q9qEa8023724;
	Fri, 26 Sep 2025 13:15:54 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49ddbd3dsu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 Sep 2025 13:15:54 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58QDFoaU62521654
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Sep 2025 13:15:50 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B9DEA20043;
	Fri, 26 Sep 2025 13:15:50 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 90F2B20040;
	Fri, 26 Sep 2025 13:15:50 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 26 Sep 2025 13:15:50 +0000 (GMT)
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>
Subject: [PATCH 4/4] mm/memory_hotplug: Remove MEM_PREPARE_ONLINE/MEM_FINISH_OFFLINE notifiers
Date: Fri, 26 Sep 2025 15:15:27 +0200
Message-ID: <20250926131527.3260733-5-sumanthk@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250926131527.3260733-1-sumanthk@linux.ibm.com>
References: <20250926131527.3260733-1-sumanthk@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=F/Jat6hN c=1 sm=1 tr=0 ts=68d6920c cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=rQaNfnSK3a-WYbhgV1gA:9
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI1MDE3NCBTYWx0ZWRfX0hjtkqhGmUCt
 bd6Gg5GGexm8M2i0HtXWlmTWzhEURzPt1XNWNjmCJ5adV5cp0mBi4Kdnii373Dlp/G7wao2fxBK
 y/r7EJuNQ5Y+2MTYEFMVGXje5u5w+bpDsvLajE3c/yEuawpqOYdusFm57fuNiyI15+eBTslD3ji
 PxxBO2/uOXhTVcc1qHEzlpWpJf1Dx887sSE6sLsEpLj/GCVO76gUDUtcUvB4G+Q6DKXY2inSJn0
 Y6ZOsa6v5BYqHqpC3UycwArZQQ5dNN6UGkuviMFoEaI2a/j8xNKCa6eM3h66WhF9exHgQTT87XD
 LPtM1Kid7COtUzHeU5Uiy5n3cOPkqUCo9EDlGiwQWaPwkOo1Vxejz5C+K8Y+N6fSpOGcnETGQlT
 q2x9FWA7lZZFj2SIy/dd24pOFZqcfQ==
X-Proofpoint-GUID: M4_GZJeR_0qDItlTmbLDGVsgp0Ovpx-3
X-Proofpoint-ORIG-GUID: M4_GZJeR_0qDItlTmbLDGVsgp0Ovpx-3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-26_04,2025-09-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 malwarescore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509250174
X-Rspamd-Queue-Id: 669E2180010
X-Stat-Signature: 19ngqhbe3xwgfo4j3u6e1p1p7ba1tpeo
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758892557-5237
X-HE-Meta: U2FsdGVkX1+HzAT694QRE2Q1df9rHPGuk0C5nGmq2aLZ8YKtoWI5+hlO2LcLiUgtWiSrxnAS7EFrv296BnMGgUdtiIeLntl3df5n1oXIhwMCX8c7Qqz7s3JxriJIo1Aca4yk+yjeCwCoNicMCrFDu+fYLAagoF9SwdptTVaRSuan0OmDiRPytN5jw9jvxG6zrU0IEMiFfnK4nrOCANH6rTJ4mg6yQYtdAZgn2mTK4gngLhZhE1VQu8Jhogij6NgBD6/EgOArB6bVE3ZWLE5hHydPulWn5N4Ndo90URVTV+0gB1zbjUKfnqBbuFn4IkLqFNLzsoYViXOKWVStyAoYzDvL+lnlae9Inkk2J0LXZJpT3zs4REZYw5T4D67WGYAiq8+D3D+llU8K+wrGpLjUqtc68ZWzHZsEceLroWIyVJ3ovR/6YZoCgyZYmCrc6zEQhF0ejNFrfJJNWoCPQDXk0Ii+U1UKfZwqpBnXK6vud1eBY5hDHaAjxWSZ8EHcav21L/kXeIrv1e5BsHPwKFwIGTmoXBKnKP1EZwi42xZ7HBxdnQeQHoIrdzN3eGW3l2wtPu9pMX1pBVFvpO2vXynGj7HMLzBoKsSp/P9mhD7rDRZsXyze3g4d095VuDn4rW3GTPcP36pE6xBYA9u9p9cRmGdyth8CubH1vSC2iMIfbt/sDXddr3CBfb+e9lZHAPvAk9mS83j1vPpR0Jsg2cP0OXFcBbVc9snMAUVkwFtsGABo7Gkuwa/yDCGDABJEp8ONczARYxU6hvsJ/3fAxAwvvN+c71CLySx+uvy+9hyM6ojV7FAV/rHa9kMY1hb21j9HfP6JgUuSR3NHeX5DOOc3Kscxkgdp8b8h8/Ew3yb4heX1XnoJq2PA0sB9nOZ1nHeVYkg/ohJ4NmoOq/H626VzW9hIp2zNifX625CDQclfG/RDv3ChpAD7bdM6pCZcUCPpWMmDdPc2BX16k5sFfUZ
 8uhOf4R0
 HLrK8D6Vhp5gDAugUDklCn5RNd+eSMVnAEI4xV0EZQA9j0LYP+tKmGLJCMrVOSDMiNq396jyHmQovFhnrtUUVRMtZaPEdyHPjovr1aNfr7ijkgg9vuq4AgdQ7teTCR4z3HsKRB+VDZYeB1yQQzTPg0CHqWGWkM41Tdksia8Nx1xaAQJdyKJswBFAByMgT00JhUFqldt1MjnaRtUM6Gajr4I3L4TDCNFRnNJUP+s+vTWxZPaV+5EtG20cT8BuIARk80CdTSoUAMpDaIxyX77/ksfKWJA==
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
index 5c6c1d6bb59f..67a41575ac77 100644
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
index 40eb70ccb09d..e42534b5c5ec 100644
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
index 4aa151914eab..7467035d4f29 100644
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
index 74318c787715..db95933daa4c 100644
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
@@ -1547,7 +1536,7 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 	 */
 	if ((mhp_flags & MHP_MEMMAP_ON_MEMORY) &&
 	    mhp_supports_memmap_on_memory()) {
-		ret = create_altmaps_and_memory_blocks(nid, group, start, size, mhp_flags);
+		ret = create_altmaps_and_memory_blocks(nid, group, start, size);
 		if (ret)
 			goto error;
 	} else {
diff --git a/mm/sparse.c b/mm/sparse.c
index e6075b622407..24323122f6cb 100644
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


