Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B102F36B97
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 23:42:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F84B6B0093; Thu,  9 Apr 2026 19:42:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75E836B0095; Thu,  9 Apr 2026 19:42:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C5BB6B0096; Thu,  9 Apr 2026 19:42:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 312366B0093
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 19:42:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B8CBEC1462
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 23:42:23 +0000 (UTC)
X-FDA: 84640643766.27.0A68523
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 81C0040005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 23:42:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=n5wApxqx;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf12.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775778141; a=rsa-sha256;
	cv=none;
	b=g084VtrEfpZZOIT1g4z6v1jwv+NEkd8z2O2Ut8fT78v/Yn4eny17psrdaMS/x0KPMCh6ez
	dAFESJA+5Zy9ET+yAx+0tApK+eQ++6jmDDNDCF4R0/TwPGY9KxCUVh59Jg0vRWsh5qAQuq
	HQ/f3W2V1LiadI9ZcLDhiF/ci5G3UYc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=n5wApxqx;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf12.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775778141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x6FlxiN7daQaYokQT0azTeHYnxBim6s87TcqMTHedF4=;
	b=bwvA6wXshI9TDkX76bqpD1Cu5ZGvEjmBIgD3jTtM3L8lXZSVkUD4Ao+dLRMZMjXvygJUst
	aBPQ2YHs1IG7Lwpl0Q3Z/InKa8cZV3on8ucZhmGpTSevgW1sNATnGkLFZfTu91XWstXdXQ
	7Nk2jG0VHdiAZjq47V8WTtgOZbf/88Y=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639JthRd3364073;
	Thu, 9 Apr 2026 23:42:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=x6Flx
	iN7daQaYokQT0azTeHYnxBim6s87TcqMTHedF4=; b=n5wApxqxKM8s7TTt+xvhL
	Vili2Bkh5ifRK/V1bcHLGsB8mChVV3V27julCxXPuiWqFJHzIGY4OeLOVa+AKQ36
	lbkY/nDOXaU1gztHGbrx+BUjs1GQ7U2z6NNCrRGNWZhRMqAI4QgBw3UGaUSZdSSY
	FB08lN8gIAIL1QfVfWruWneiHd75QKCZB03lx2/vZjX9hC70Z0IFFsPGQZ9816iG
	d6ViJeunJcNSHlJAimxdkpEwhOs8EbDLGWPGDrtXYPEitAUSgjUWNJkqI918MXIy
	78WCdtEu7IsmOxT9PFVG+dKtl6XaDCpe1Uyc6EcOCpzGwY4gKIE5CWJ7e0loXvnF
	Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqb0k5a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 23:42:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 639NJvov040041;
	Thu, 9 Apr 2026 23:42:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dcmnbj4tg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 23:42:16 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 639Ng6Yt038323;
	Thu, 9 Apr 2026 23:42:15 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4dcmnbj4pp-5;
	Thu, 09 Apr 2026 23:42:15 +0000
From: Jane Chu <jane.chu@oracle.com>
To: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev,
        osalvador@suse.de
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
        rppt@kernel.org, surenb@google.com, mhocko@suse.com, corbet@lwn.net,
        skhan@linuxfoundation.org, hughd@google.com,
        baolin.wang@linux.alibaba.com, peterx@redhat.com, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] hugetlb: drop vma_hugecache_offset() in favor of linear_page_index()
Date: Thu,  9 Apr 2026 17:41:55 -0600
Message-ID: <20260409234158.837786-5-jane.chu@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260409234158.837786-1-jane.chu@oracle.com>
References: <20260409234158.837786-1-jane.chu@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_04,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 spamscore=0
 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604090218
X-Proofpoint-ORIG-GUID: KN3ebLbDMF-MXMlWfg-CNCOjq8E8Mb7p
X-Proofpoint-GUID: KN3ebLbDMF-MXMlWfg-CNCOjq8E8Mb7p
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDIxOSBTYWx0ZWRfX6PrAFFxMsHg+
 tWxwwnNgcimhwsdmNzGYbg9KckBqif9pc1EmZlov1wMDhXHhuF9H4X1VNZcNS6H2tim44O/BTSy
 j94Y9vSxjCVxf2gUznb1OChc1XpZKcMbAaRuJS5FZKVLtUaQxado0YEyRAZS6jN6fsoWILKuEMm
 Rb37LmqL74C02jboElRvjiEX/JyAKO1a9zMFzSpZzbUg7HYzt90/j2sDAwrQp3Sbx8vKNPDT+Jb
 XYM+cI35gFRTY+i5V6829vK0ZszXv04curO9RNIt+bSdI+Ch9iz6TSLgo90bpB19eVn+6mZNYxW
 fkpSjTjwO9exrfUOX66miFy1QYcxtZ3hDf+NpHKlwQd5fLe/BxMj3b/pq6cAmSqS9AmN9VfMILF
 dB3Nl6ByY3N/nfBF4n8L9juiE5JvkR6RrneAEn15OeC9RSlYoq5kwYbxwm6IxwjjbdL75uuXXnA
 gbr/1gyhIiNzKZ5/yZw==
X-Authority-Analysis: v=2.4 cv=NZXWEWD4 c=1 sm=1 tr=0 ts=69d83958 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8 a=Dt03dsiUf5UwWsjHOLQA:9
X-Rspamd-Queue-Id: 81C0040005
X-Stat-Signature: pi1zehc1i5rb4nzxn8rsbz4eofdtwcsr
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775778141-623654
X-HE-Meta: U2FsdGVkX1+Ueda7N7lXE6Tr6I8INErHcETdZn/dFT19+XkHbC1djFxIagCIqAKrAi8KxXHOBSmL97h6aKEfB9C+IOnE5wp6o0gecVKWXhwLLIbjtdmhn8TL5UGf8Y+JhNXxz/NLQ/mkbFWJseJaz90wBIVC+zPkIA2BCDgpoDJlJFZsDRt+RfpyCymPwb7bUu1Z7pSfvOAxKgW0LLwF7RToKyuVqsk4SZdLUqmfHBQ3ZI7DeUJRcpbFbkqOflMUHaCJVJZ21la99KUAJe3MwtVRXEFBNKgxTHS2M64fAJzvEew92qQULw3+XIQxBcEzcCV5Wl3XpWO5kI241S76DUcl/0+fSNtP8QNWLQfZhqpQ9BhxHBHJBwhXNX63jIpdS7O+yPEt0+dtn5Z3HIVSyCxHr/o5fm6y0TthLuEnonHBtbCppS8WOP3z6ysV4t9prZDAghShKk1XWNt0QKWHSpnrWOnTH3RBGh0N/UhiAhdRMVpdFLdKMcumQ+JlVOMDg5Ddz6nTIX0vrGa3PH+Y1zIZEC93CPb/D8uw2DlzFo4jKyLne4sJeYcTrlBdhauJM06qANcWeOa7m6uNUo9lXHOccoquFkpTw7rA8HxGZvUP1mKaXTaOH0J4WLKfkN1dWAkW3Xr8nujPt/CpD5OmNgkD8MdG1RNMCQ69Ua/27T6RbpICuVQb5GVKy0s4X5LYV7YdCwnp3yK8RKVRtpqvd4Wzr4J3ivNTNiiGL0NIZPXaBcBTZKAPny/D+jXjx6ARzltMni6Qti+T2NGOAOGJV9zg/+wefmNTOD52WnHFqF+mitWlVbS/xN7pn1aY8URUDuVXpT3YX+wmHtZJW+gntkukHD80UxTabrBzL1y9z3xSx3lJ3H59RrUaXQ+gVTrJhztCyEJUHHtN2cqx2WQLqLguS/Cefam1A1dwntL/oSovHADd39Tbbv/TOjeG6EL+Ln1W6Q+q6qs8oUCq1KZ
 Na/G7SAU
 /uxhr2UaMcfxIZsyElwHk+YZDqUwpn0ysVKLUEPMyuOJ9Zcdngnwr1HU5MKHILTYsw9RByLVUnL3JUAJ4H1TMvSMJWA50joa34PILGm08IGmMj1L/SNBzQXVsNyQYwzYSMiRR7G9HLaVoTzQXgYq2KzueCz+6tTvM14A4GNHPCIHbLlmhx0xHOcsNd7RWlvoe01xV93F52UC5FDPbiC7Xo/lhbCDX1Ka6iHVz80nlyjeZp8bOYYZ/C7RNPUC/JXpg/j3NPNxNpZEbU8LLTLTksA5XbgQgekQLu9zpYaSL7gOTT1XryqWWMPws16eF7cXjhU+jBjE723IwFFzb9VNL/AIAmlIX/GPFdTZc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vma_hugecache_offset() converts a hugetlb VMA address into a mapping
offset in hugepage units. While the helper is small, its name is not very
clear, and the resulting code is harder to follow than using the common MM
helper directly.

Use linear_page_index() instead, with an explicit conversion from
PAGE_SIZE units to hugepage units at each call site, and remove
vma_hugecache_offset().

This makes the code a bit more direct and avoids a hugetlb-specific helper
whose behavior is already expressible with existing MM primitives.

Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 mm/hugetlb.c | 49 +++++++++++++++++++++----------------------------
 1 file changed, 21 insertions(+), 28 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 9d5ae1f87850..138e5ecf818e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1006,17 +1006,6 @@ static long region_count(struct resv_map *resv, long f, long t)
 	return chg;
 }
 
-/*
- * Convert the address within this vma to the page offset within
- * the mapping, huge page units here.
- */
-static pgoff_t vma_hugecache_offset(struct hstate *h,
-			struct vm_area_struct *vma, unsigned long address)
-{
-	return ((address - vma->vm_start) >> huge_page_shift(h)) +
-			(vma->vm_pgoff >> huge_page_order(h));
-}
-
 /*
  * Flags for MAP_PRIVATE reservations.  These are stored in the bottom
  * bits of the reservation map pointer, which are always clear due to
@@ -2465,7 +2454,9 @@ static long __vma_reservation_common(struct hstate *h,
 	if (!resv)
 		return 1;
 
-	idx = vma_hugecache_offset(h, vma, addr);
+	idx = linear_page_index(vma, addr);
+	idx >>= huge_page_order(h);
+
 	switch (mode) {
 	case VMA_NEEDS_RESV:
 		ret = region_chg(resv, idx, idx + 1, &dummy_out_regions_needed);
@@ -4718,8 +4709,10 @@ static void hugetlb_vm_op_close(struct vm_area_struct *vma)
 	if (!resv || !is_vma_resv_set(vma, HPAGE_RESV_OWNER))
 		return;
 
-	start = vma_hugecache_offset(h, vma, vma->vm_start);
-	end = vma_hugecache_offset(h, vma, vma->vm_end);
+	start = linear_page_index(vma, vma->vm_start); 
+	start >>= huge_page_order(h);
+	end = linear_page_index(vma, vma->vm_end); 
+	end >>= huge_page_order(h);
 
 	reserve = (end - start) - region_count(resv, start, end);
 	hugetlb_cgroup_uncharge_counter(resv, start, end);
@@ -5960,14 +5953,13 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	struct hstate *h = hstate_vma(vma);
 	struct address_space *mapping;
 	bool need_wait_lock = false;
-	pgoff_t index;
+	pgoff_t index = linear_page_index(vma, address & huge_page_mask(h));
 	struct vm_fault vmf = {
 		.vma = vma,
 		.address = address & huge_page_mask(h),
 		.real_address = address,
 		.flags = flags,
-		.pgoff = vma_hugecache_offset(h, vma,
-				address & huge_page_mask(h)),
+		.pgoff = index >> huge_page_order(h),
 		/* TODO: Track hugetlb faults using vm_fault */
 
 		/*
@@ -5981,7 +5973,6 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * get spurious allocation failures if two CPUs race to instantiate
 	 * the same page in the page cache.
 	 */
-	index = linear_page_index(vma, vmf.address);
 	mapping = vma->vm_file->f_mapping;
 	hash = hugetlb_fault_mutex_hash(mapping, index);
 	mutex_lock(&hugetlb_fault_mutex_table[hash]);
@@ -6182,20 +6173,22 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 			     uffd_flags_t flags,
 			     struct folio **foliop)
 {
-	struct mm_struct *dst_mm = dst_vma->vm_mm;
-	bool is_continue = uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE);
-	bool wp_enabled = (flags & MFILL_ATOMIC_WP);
+	pgoff_t idx;
+	spinlock_t *ptl;
+	struct folio *folio;
+	pte_t _dst_pte, dst_ptep;
+	bool folio_in_pagecache = false;
 	struct hstate *h = hstate_vma(dst_vma);
-	struct address_space *mapping = dst_vma->vm_file->f_mapping;
-	pgoff_t idx = vma_hugecache_offset(h, dst_vma, dst_addr);
 	unsigned long size = huge_page_size(h);
+	struct mm_struct *dst_mm = dst_vma->vm_mm;
+	bool wp_enabled = (flags & MFILL_ATOMIC_WP);
 	int vm_shared = dst_vma->vm_flags & VM_SHARED;
-	pte_t _dst_pte;
-	spinlock_t *ptl;
+	struct address_space *mapping = dst_vma->vm_file->f_mapping;
+	bool is_continue = uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE);
 	int ret = -ENOMEM;
-	struct folio *folio;
-	bool folio_in_pagecache = false;
-	pte_t dst_ptep;
+
+	idx = linear_page_index(dst_vma, dst_addr);
+	idx >>= huge_page_order(h);
 
 	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_POISON)) {
 		ptl = huge_pte_lock(h, dst_mm, dst_pte);
-- 
2.43.5


