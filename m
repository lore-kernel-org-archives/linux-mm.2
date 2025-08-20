Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D44E2CA0EEB
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 01:05:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB0F26B00C0; Tue, 19 Aug 2025 21:05:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D62086B00C1; Tue, 19 Aug 2025 21:05:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C51076B00C2; Tue, 19 Aug 2025 21:05:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B072B6B00C0
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:05:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 44A601A02D8
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:05:22 +0000 (UTC)
X-FDA: 83795342484.06.7FEF860
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 22A73100011
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:05:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=U49XgFJj;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf05.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755651920; a=rsa-sha256;
	cv=none;
	b=KjCVBPTyUsQkPw+Jwk1AhqFiVY/2V5tcIyNHReVSQxM6sRCQpUO8/AG3/BvY22GYNeOm/T
	Vj+mH5F6aDmWck+nCMVbd1zxt8ETL45lPstYu/RIth+LPjGGnN/NZA3UxHUQxNC7TG4CIs
	t5vx93NJ7q4AGzibeHAcAiEgMT3fwWg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=U49XgFJj;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf05.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755651920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oB/ytOrLg9T9IbRvCshxXxjR6QK8HqXJqmgz7J86k/E=;
	b=59XZCvKXs4qIjz6DXOfFn2b8uYYrD248jJlgqClqZd2zQqgJBStc4+7+JeZPK5lkfKrUo9
	2xRrGK82lS69/QNECsGjOr68NvWg/4m0DlluHyClMk+7qBAA3WOuN7ZNFuTUDrw2bT90ll
	EwnoNzMFiPr93A3Pm19pWc7w6FfA+Tg=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JLBtnv003092;
	Wed, 20 Aug 2025 01:04:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=oB/yt
	OrLg9T9IbRvCshxXxjR6QK8HqXJqmgz7J86k/E=; b=U49XgFJj6adJHiHse3EIa
	qgpjjCnYXFWOQ9Adg6dDVwdOoey/xFGy9PQS4EbYogkkQs2Jwra/TsHIFYoNC2kl
	+4KxfubFTzDWk5JkqOHF3+WYRCf26uLBw+MrUiCUZYAUkzxCdOoSlIwzS1lNrGE2
	ZQL4dZCNrgwysd1E+14or+a1JSgqIgO2Gb1stpPcBTH6mFICv9h/FFGh9nnSKfQS
	oBzR0z9GBF/GcSpvXFafEv4JWNuTGWG3+DFmBiHfc0YvWnvJYiFg88fchsKpQ2Nd
	IuLx8WqAdS3LF6HgF4bzVX99o9tJNu/rL/IWSOoC/IeZv64GMRIoVho84cqEpqS6
	g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tr0863-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:04:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57K01WpA007223;
	Wed, 20 Aug 2025 01:04:54 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48my3q29xy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:04:54 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57K14NdQ011685;
	Wed, 20 Aug 2025 01:04:53 GMT
Received: from localhost.localdomain (ca-dev60.us.oracle.com [10.129.136.27])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 48my3q29gw-12;
	Wed, 20 Aug 2025 01:04:53 +0000
From: Anthony Yznaga <anthony.yznaga@oracle.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, arnd@arndb.de,
        bp@alien8.de, brauner@kernel.org, bsegall@google.com, corbet@lwn.net,
        dave.hansen@linux.intel.com, david@redhat.com,
        dietmar.eggemann@arm.com, ebiederm@xmission.com, hpa@zytor.com,
        jakub.wartak@mailbox.org, jannh@google.com, juri.lelli@redhat.com,
        khalid@kernel.org, liam.howlett@oracle.com, linyongting@bytedance.com,
        lorenzo.stoakes@oracle.com, luto@kernel.org, markhemm@googlemail.com,
        maz@kernel.org, mhiramat@kernel.org, mgorman@suse.de, mhocko@suse.com,
        mingo@redhat.com, muchun.song@linux.dev, neilb@suse.de,
        osalvador@suse.de, pcc@google.com, peterz@infradead.org,
        pfalcato@suse.de, rostedt@goodmis.org, rppt@kernel.org,
        shakeel.butt@linux.dev, surenb@google.com, tglx@linutronix.de,
        vasily.averin@linux.dev, vbabka@suse.cz, vincent.guittot@linaro.org,
        viro@zeniv.linux.org.uk, vschneid@redhat.com, willy@infradead.org,
        x86@kernel.org, xhao@linux.alibaba.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH v3 11/22] mm: add and use unmap_page_range vm_ops hook
Date: Tue, 19 Aug 2025 18:04:04 -0700
Message-ID: <20250820010415.699353-12-anthony.yznaga@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250820010415.699353-1-anthony.yznaga@oracle.com>
References: <20250820010415.699353-1-anthony.yznaga@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_04,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508200007
X-Proofpoint-GUID: _PKCORV95t34utTONhSuPWPoCV8aYqY1
X-Authority-Analysis: v=2.4 cv=FY1uBJ+6 c=1 sm=1 tr=0 ts=68a51f37 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=2OwXVqhp2XgA:10 a=yPCof4ZbAAAA:8 a=viETJqx1g-7UJoe2XGoA:9
 a=UhEZJTgQB8St2RibIkdl:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=QOGEsqRv6VhmHaoFNykA:22
X-Proofpoint-ORIG-GUID: _PKCORV95t34utTONhSuPWPoCV8aYqY1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX0UFlNL3UB1MF
 a96GovBAUffpWwKC8eTw1TjY/mPb/56RFmJrZziuxYWJk/9ZUkl4E/+CP1D6304gPEy+AkPU0s/
 OYxPxjjDvVmneCGHCAAXe5y6jFUbS4t8/QjQKgSszcNBDm87JCc5v6qy/sxj1pOZDb8+t2XSbho
 PSGAMAJNldnpoObUT1hRAc5rr1/xCBPSMIXiyIC8o6VoIcX1KF+KjcBaQnA3bTxFdQmwPZ8gP18
 4bGQi3rzUBZCVcLOTCjgmFrKSWRNzawcbZl/yiQtK/odgiuqqF9uWRN6uwM8SaztWM8Hl0//1dj
 7kxYAoaDyXJLAqPPaGPWELc+cPkkOKnUiWahuCrC/szB95ixRqmfNpg2W9Qbzl1QR3yVLXiUzJZ
 5iXB9vBaThGfh3EtNbhL9PLXj+lhEw==
X-Rspamd-Queue-Id: 22A73100011
X-Stat-Signature: 1fmzmxy56zi6yjxy1aje499qb7jte6ef
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755651919-48920
X-HE-Meta: U2FsdGVkX1/q90vRLrqOBsJAEOK6YR4zZPvfRj2V/lJFngmdEensHhIWc6/DNagfHvUQzqFAlQoVEp5Sj7+78KLuqbTQjYTlFwQ+3yd1Ist+FDdS/H2MJKf8M1wbNvBa+Hp0RtoA5FOmL5EvN/cMmSgsrxUAc7RWqy7QafByKi1qFnojKrFCW5HHTjKgFDBngvqMkWY5ApBmP1l53e79n6x5fdTyeyOcI7EW9bfLkiTX6WlF/YkbT1ACvVpaP8dK9sC1zGQmrJROSrISD17s7LICl9QWGlTzEnIRAMbjzzerJObgt5wcHjWmaV14Lzkhu95Qef/wrS8l8oQFd4k8y1MIDm70HjfMbtrAPeJ3oJGdARJ018CsdfprZ3Vy1OfmCzQ7XBCLzlt1qBW8oOk9WO0PI7Diubhaz0rRTsADCfcpqwxIOMq/PXcPVJZXvObGCWrCmC63fFof/GVEO/OfYB0fIeKl7o5P6d1rlv92WUEoDoAyc8NqvGuoT1bC6TkWtLr+0ebVmCuiT8YljAMyy4XiSEBxoCit77a7F+YFM2+YX0n5gy1ve5Tkx5U1uwqr9tSu/qR72PnjBcsEUDUJ4wZRfFaRfL0dWHwQZFC5hte9KbhBuKD9GfvILz+BzuV6gzAg3rMBgx2S54H7jSyAe8GJhY02M4muVx6mBuZYDIbHMsrdZE5rPGzGAx2vvfcZaEAjBRj3/wcbzLQtOS/CECPeftrZzJIJ8TJcen9+5V+U5sIR1cs5JcHs3rIitmv9njlFgmPz4DxGQqIARSk5DphYHnQGrqbHJjvYtsGwvF//JlOWJgezXWkExGkLUZvaZr90gfD41ARbADus6Z4X0HJsLANGG0SlEzG5CWDsZaL/HEVKrWwh8iMC1Qnuc8V8wkJaBTtU3/86iioeBNUDcDbHnS/YewogSZSjqaas1luC0KU9b1Yz7cZ9GasjO9w6iKLi96KjGwWDdu8ny0w
 cdV8JouQ
 qrMb9I0EIzw7xTyy+h+Ol6D+4RbX1s9JOnaGFTRYhzl5s/b5n+8lS11rBJ01pJbf2hnyX2hpHEvq+oPSvcY8vLpzIVgAlQiGRvfJK6ngIO2Fp1YJgUQZ/wMUJowg9T6Jnnb72sJONMqOq/YK1J5mZVjS1yp2FlpLEgPuu0w4YUIdhW0G8pHL5NRjIf6ZY0wPDq96/jQ1U+nIaERCO+jaJL053jmZ4H+TKh3pywBk/GP6V0btGB07qJg4m1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Special handling is needed when unmapping a hugetlb vma and will
be needed when unmapping an msharefs vma once support is added for
handling faults in an mshare region.

Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
---
 include/linux/mm.h | 10 ++++++++++
 ipc/shm.c          | 17 +++++++++++++++++
 mm/hugetlb.c       | 25 +++++++++++++++++++++++++
 mm/memory.c        | 36 +++++++++++++-----------------------
 4 files changed, 65 insertions(+), 23 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index aca853b4c5dc..96440082a633 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -43,6 +43,7 @@ struct anon_vma_chain;
 struct user_struct;
 struct pt_regs;
 struct folio_batch;
+struct zap_details;
 
 void arch_mm_preinit(void);
 void mm_core_init(void);
@@ -681,8 +682,17 @@ struct vm_operations_struct {
 	struct page *(*find_normal_page)(struct vm_area_struct *vma,
 					 unsigned long addr);
 #endif /* CONFIG_FIND_NORMAL_PAGE */
+	void (*unmap_page_range)(struct mmu_gather *tlb,
+				struct vm_area_struct *vma,
+				unsigned long addr, unsigned long end,
+				struct zap_details *details);
 };
 
+void __unmap_page_range(struct mmu_gather *tlb,
+			struct vm_area_struct *vma,
+			unsigned long addr, unsigned long end,
+			struct zap_details *details);
+
 #ifdef CONFIG_NUMA_BALANCING
 static inline void vma_numab_state_init(struct vm_area_struct *vma)
 {
diff --git a/ipc/shm.c b/ipc/shm.c
index a9310b6dbbc3..14376b63d46a 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -588,6 +588,22 @@ static struct mempolicy *shm_get_policy(struct vm_area_struct *vma,
 }
 #endif
 
+static void shm_unmap_page_range(struct mmu_gather *tlb,
+				 struct vm_area_struct *vma,
+				 unsigned long addr, unsigned long end,
+				 struct zap_details *details)
+{
+	struct file *file = vma->vm_file;
+	struct shm_file_data *sfd = shm_file_data(file);
+
+	if (sfd->vm_ops->unmap_page_range) {
+		sfd->vm_ops->unmap_page_range(tlb, vma, addr, end, details);
+		return;
+	}
+
+	__unmap_page_range(tlb, vma, addr, end, details);
+}
+
 static int shm_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct shm_file_data *sfd = shm_file_data(file);
@@ -688,6 +704,7 @@ static const struct vm_operations_struct shm_vm_ops = {
 	.set_policy = shm_set_policy,
 	.get_policy = shm_get_policy,
 #endif
+	.unmap_page_range = shm_unmap_page_range,
 };
 
 /**
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 514fab5a20ef..3fc6eb8a5858 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5461,6 +5461,30 @@ static vm_fault_t hugetlb_vm_op_fault(struct vm_fault *vmf)
 	return 0;
 }
 
+static void hugetlb_vm_op_unmap_page_range(struct mmu_gather *tlb,
+				struct vm_area_struct *vma,
+				unsigned long addr, unsigned long end,
+				struct zap_details *details)
+{
+	zap_flags_t zap_flags = details ?  details->zap_flags : 0;
+
+	/*
+	 * It is undesirable to test vma->vm_file as it
+	 * should be non-null for valid hugetlb area.
+	 * However, vm_file will be NULL in the error
+	 * cleanup path of mmap_region. When
+	 * hugetlbfs ->mmap method fails,
+	 * mmap_region() nullifies vma->vm_file
+	 * before calling this function to clean up.
+	 * Since no pte has actually been setup, it is
+	 * safe to do nothing in this case.
+	 */
+	if (!vma->vm_file)
+		return;
+
+	__unmap_hugepage_range(tlb, vma, addr, end, NULL, zap_flags);
+}
+
 /*
  * When a new function is introduced to vm_operations_struct and added
  * to hugetlb_vm_ops, please consider adding the function to shm_vm_ops.
@@ -5474,6 +5498,7 @@ const struct vm_operations_struct hugetlb_vm_ops = {
 	.close = hugetlb_vm_op_close,
 	.may_split = hugetlb_vm_op_split,
 	.pagesize = hugetlb_vm_op_pagesize,
+	.unmap_page_range = hugetlb_vm_op_unmap_page_range,
 };
 
 static pte_t make_huge_pte(struct vm_area_struct *vma, struct folio *folio,
diff --git a/mm/memory.c b/mm/memory.c
index 002c28795d8b..dbc299aa82c2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1999,7 +1999,7 @@ static inline unsigned long zap_p4d_range(struct mmu_gather *tlb,
 	return addr;
 }
 
-void unmap_page_range(struct mmu_gather *tlb,
+void __unmap_page_range(struct mmu_gather *tlb,
 			     struct vm_area_struct *vma,
 			     unsigned long addr, unsigned long end,
 			     struct zap_details *details)
@@ -2019,6 +2019,16 @@ void unmap_page_range(struct mmu_gather *tlb,
 	tlb_end_vma(tlb, vma);
 }
 
+void unmap_page_range(struct mmu_gather *tlb,
+			     struct vm_area_struct *vma,
+			     unsigned long addr, unsigned long end,
+			     struct zap_details *details)
+{
+	if (vma->vm_ops && vma->vm_ops->unmap_page_range)
+		vma->vm_ops->unmap_page_range(tlb, vma, addr, end, details);
+	else
+		__unmap_page_range(tlb, vma, addr, end, details);
+}
 
 static void unmap_single_vma(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, unsigned long start_addr,
@@ -2037,28 +2047,8 @@ static void unmap_single_vma(struct mmu_gather *tlb,
 	if (vma->vm_file)
 		uprobe_munmap(vma, start, end);
 
-	if (start != end) {
-		if (unlikely(is_vm_hugetlb_page(vma))) {
-			/*
-			 * It is undesirable to test vma->vm_file as it
-			 * should be non-null for valid hugetlb area.
-			 * However, vm_file will be NULL in the error
-			 * cleanup path of mmap_region. When
-			 * hugetlbfs ->mmap method fails,
-			 * mmap_region() nullifies vma->vm_file
-			 * before calling this function to clean up.
-			 * Since no pte has actually been setup, it is
-			 * safe to do nothing in this case.
-			 */
-			if (vma->vm_file) {
-				zap_flags_t zap_flags = details ?
-				    details->zap_flags : 0;
-				__unmap_hugepage_range(tlb, vma, start, end,
-							     NULL, zap_flags);
-			}
-		} else
-			unmap_page_range(tlb, vma, start, end, details);
-	}
+	if (start != end)
+		unmap_page_range(tlb, vma, start, end, details);
 }
 
 /**
-- 
2.47.1


