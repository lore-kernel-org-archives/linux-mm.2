Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB24BCCD185
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 13:19:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D98878E0094; Thu,  9 Oct 2025 09:19:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D497F8E0095; Thu,  9 Oct 2025 09:19:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3B2C8E0094; Thu,  9 Oct 2025 09:19:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8EAE78E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 09:19:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4C2048855B
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 13:19:04 +0000 (UTC)
X-FDA: 83978631408.18.A051BB7
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf22.hostedemail.com (Postfix) with ESMTP id 13EA9C000C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 13:19:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=MIH19KGV;
	spf=pass (imf22.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760015942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WKN0FPCSK59HHaCWouC6GyUqvnLN2IO2zPGkGpWENm8=;
	b=WmxInTmd/mAarZcBGknqz2Ijj/qgX0yhRssnQnF4Ta/aU8RH/22DY+cKBEYGTe7GozYEOc
	H817U3Gf2f578XMfxWVoL67FlA5yWDCMAGopdznOK5j8HEoDM/ErA+qlXza/IOj30XlnlN
	k6UcSJo59iRITzF9f1y86tSBJDkU15g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=MIH19KGV;
	spf=pass (imf22.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760015942; a=rsa-sha256;
	cv=none;
	b=OhEVJH7cY/gHTycxslrE/8JFPmxVUyj5VUXPOb8d3E57/X8OSAjmDHN/+ZQS1mcxyF3TD+
	HXmQ0lTh8mlBcIbzUN+l7R+D6qK0IYzTQYqObkymM1Z6t5Wp36X1Q+ylSJbGS1Oj2xEJXI
	D6aAi41JabZ5/6dvaP9C7twPteOLd1w=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5994K5bR031890;
	Thu, 9 Oct 2025 13:19:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=WKN0FPCSK59HHaCWo
	uC6GyUqvnLN2IO2zPGkGpWENm8=; b=MIH19KGVcX+jre5boNkeewJZ0+/c6LlYH
	sYhKsSMYIfqJiOTaCHtSQO7m48EykZvuPeQMByniYbSpHlOFa7Ytayps5MuVUgor
	T586xzc4yo0XKA7WjUPaFM2uYJTthlseAgb9JMHXQHqawyma9WFXuAJbyunU6tmH
	X/ucopH20HF7fxo6bggSl6dUXT8k9+XCXuEmpDqZKCLEMr2j7X3WmMKB4OkkqpZ9
	yCAFBqc3mSZK2nVDVImwiiawszpmcLLjPENlasn3NLgrxyqYkopQgYBpy2ibMlKG
	fn7Dwx3P+BXFK2CGuxIvtoQAFEp4o4QGHlCAjzyVOrELddtqg8Deg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49nv81mube-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Oct 2025 13:19:01 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 599CGDoR022784;
	Thu, 9 Oct 2025 13:19:00 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49nv8vcngt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Oct 2025 13:19:00 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 599DIu6P15204616
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Oct 2025 13:18:56 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6E9C620040;
	Thu,  9 Oct 2025 13:18:56 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3AB7520043;
	Thu,  9 Oct 2025 13:18:56 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  9 Oct 2025 13:18:56 +0000 (GMT)
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>
Subject: [PATCH v2 4/4] mm/memory_hotplug: Remove MEM_PREPARE_ONLINE/MEM_FINISH_OFFLINE notifiers
Date: Thu,  9 Oct 2025 15:18:39 +0200
Message-ID: <20251009131839.3739108-5-sumanthk@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251009131839.3739108-1-sumanthk@linux.ibm.com>
References: <20251009131839.3739108-1-sumanthk@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: S-XrwK9RxNKLtc5UIvI2KOi1lSohAbZb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfXzIQy3uj7SYU0
 ticA8CMPXlhe01aF4bsdB6ZiMyF3qrp5km2dOdzWklTBfBaCCG8VH69v6PgPeDui9m7Ks/uoHv+
 ycrvLgfbytpjJq6O4R2ak/tIlFemtgZ4M2iuu7mDP1zmpPZ3Vj+6vYFKCM8EUAmIIyzMyR+LCUh
 D78O87s11qqFvegQrRuPDeYsZBU81TynV1o5tBIHcX5awEv2kt3kblnXZhgPrDcRZTgPbAj44kt
 uotAwL55hSuJtf7sWMFdAgqvPDZY44B/ACMiJOo774ZMhc+M8TO2mokudQrziTBWzn+nADHknzR
 CUcfb3Ely+8iAL9QRn+6uWHu86vkw8Sz6ShFetiZT1bkKlcci2TXrXMaaFau4bwEizm/pSegh1D
 3wN25CGy4zvjEhowwG+XEfkU14kMDA==
X-Authority-Analysis: v=2.4 cv=cKntc1eN c=1 sm=1 tr=0 ts=68e7b645 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=x6icFKpwvdMA:10 a=VnNF1IyMAAAA:8 a=rQaNfnSK3a-WYbhgV1gA:9
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: S-XrwK9RxNKLtc5UIvI2KOi1lSohAbZb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-09_04,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 phishscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510080121
X-Stat-Signature: q8ymyzenkktk4mfy7w1iqzeis6s8k65a
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 13EA9C000C
X-HE-Tag: 1760015941-36247
X-HE-Meta: U2FsdGVkX1+FTfPCq1P1JkKfZDGSRajxFgmoDMs8Z8hjqABazoIE3mOhEAW6ojixh/mZbBF9LxztmMoG3DA2glmPwEJuzzxnGlUfojbKQb86tWYnBZfuTD/T8vRjgrw5ELL6QoliTN6pi5lJ33QNaafAP1BhyHIdkPrEv77geh3SUFX6qmYD2G7iprmPhCQ5NBC1OpHx5qjsBKM9LvMHEjdKFWeWmXNx3BsoupYahYUlm4Tqz6bd3TDoCyiOs42CMCnW/En9sI8qyM+w9izKRv8onxGbaWjY2TyFKKjcRtijXpV0Cbc8Vflhjs9OBIt2uc/Q6izU/p+IRh0lrVz3dECnHJ8bzGZ7MVQLauq83I9hrWKk//YpzgDMde6Ux72KRZzj4L7xP1eqd/eGuchGTzbUGvKZR/5Y6XywrYBZTWG8020qXOdbYsM9WTSYUvkedk2UFOPkhj75qKEFwad9N23rHZo7npBmdxON8fS4VxzmDECPDPU8rOipD0PCmxdeHSSc3C5mvanaZQrxdbd2B+i+zA/uFbX+3EfZccWLlUB1wI3Tx/YMfsCKY34+PTk0zPL26Bd95CXnvT/B3AqJU1ixbsWPWhhj0LBL1cmqFN1XmGG8JN4MAac4WWhlo1f9AUXfFeAhEULrafOd2UPzab1iPEgRLB7SAG2Rn4oP9qy4T4bleNCzh93WoPemaRaHTzPkhlJESTfbbdMLr4LgsqFsRx7kWsRqYCvQCGJsZ/Dy10MvqL9rO16t/1IH8zXLp20wEC6oKFS4AcWTnhT32Olqd17k3KtO7wb3YnKo2BZqIIde07QjX/hGymWgYgK1Fs29T3tFQLLtTdfjHbwjAvOBBMVNgiu+nvKXMHLA7wP4S6r2zT5Mg/ATiu/gQ/nMhMoKSmIw5gSsydr36J44Z1rWwKNKqkLquRjBAtig9qEnszLOE3gdFne8W3Pi20LWPKdvvV7DsXd2jfZiEcl
 E9iTHiF9
 /E1G32q2pPGcaVmBRivhmt/MeCbwPWgQmL51ztk09pRI2AeZFuqxZiffxN625xlWJsgDIZoZXN2pIU9GYqzbIeIBJ2v0VA5io51ErOH48dYfo8zv+686V4pbYTI4GufJ73I7tLlM/djUd7vERfrCoeC1HrbhfJMrIARl8VdpbZ8+l/B25vwDLTrA5aufYelFB/nUF0TwFXWOCV3N09stHK+VGvFyteYvPbHSOJCFyjC5J2P5rzSGc+zxmIijOYwd5O4ZvnBk1zZujv8kw/L+v7I5fjw==
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


