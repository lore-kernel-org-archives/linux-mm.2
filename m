Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D32C4CAC597
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 00:45:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F14098E000A; Mon, 15 Sep 2025 20:45:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEC008E0001; Mon, 15 Sep 2025 20:45:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E01988E000A; Mon, 15 Sep 2025 20:45:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CCA0B8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:45:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 54BE611ABC0
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 00:45:43 +0000 (UTC)
X-FDA: 83893270566.27.9BF6DB1
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 61F7880006
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 00:45:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IbR+1mAh;
	spf=pass (imf02.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757983541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cKHMWebgaeczhOOiQ1Ar8OrapYhO7vsShzCqAQ2z+EA=;
	b=RwZGYdmPVOYQZRcJL4FlFyPVXHwgW5bnsMTzaMRC4ckbw+OxJqOtNNK4PPM6Y5o0KSk8ZE
	v+xo5rqIC9mAIAWE/Wwcu5572Tkb5CxMMXsM3LOjqDlKVnFBCM0gUwGyVlv5Hr4xWZ8PnU
	PCodjKsKbq7grVJqWCm0B02lCaQdVYo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757983541; a=rsa-sha256;
	cv=none;
	b=SsAiqh1N0+/dKYx/X5eNREDXLdXnb29n9xOspgMRChs4jiNCUpUBwE4QxsRuonVl6pTldw
	I1Xt0t6N3qzOxvRcnXVUcrs6iPrS8MLAHjbODohwCJXNQ2qzwRx+6vHt7rWBhPqPIj08hQ
	vwfK2NulVGM74UU1WQJQZERwVK7Se9U=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IbR+1mAh;
	spf=pass (imf02.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58FLfnON007323;
	Tue, 16 Sep 2025 00:45:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=cKHMWebgaeczhOOiQ1Ar8OrapYhO7
	vsShzCqAQ2z+EA=; b=IbR+1mAhszIUyWAYuy/+LVxcGRZHgQl7jvL3pJz6eBRxP
	0k43nZ5VDZc/yxVySIIsGr9WqEp9O0N9EdKAT8XnSCTAdFl+fXu5pGN+FenkOxt8
	e5GYIGK2AKAdWFnqABZGVAHBlwhwSNqOK8q8M2ck6Jca3u776zYrhNOZrRtI6fH4
	nK8eePGoaI3jUF/zXRfjxj5RRNeAOBb+TbNRqZMTDRLhjvSeRoBZG6Cc7RJtqaPw
	lhOCLB6bXFtxcqrVZ+qK4uCniwmZyux+N5/1JdiP/+O1IzXBYi4Cl8qDdsLcZtmk
	XlGYZmwZDNOp7Yw/fn9VVmdYivW77k8JH701L1esQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4950nf3k5q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 00:45:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58FLW0IU033818;
	Tue, 16 Sep 2025 00:45:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2bpqvy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 00:45:31 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 58G0jVGI031429;
	Tue, 16 Sep 2025 00:45:31 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 494y2bpqvq-1;
	Tue, 16 Sep 2025 00:45:31 +0000
From: Jane Chu <jane.chu@oracle.com>
To: david@redhat.com, harry.yoo@oracle.com, osalvador@suse.de,
        liushixin2@huawei.com, muchun.song@linux.dev,
        akpm@linux-foundation.org, jannh@google.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] mm/hugetlb: fix copy_hugetlb_page_range() to use ->pt_share_count
Date: Mon, 15 Sep 2025 18:45:20 -0600
Message-ID: <20250916004520.1604530-1-jane.chu@oracle.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_09,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509160005
X-Authority-Analysis: v=2.4 cv=S7vZwJsP c=1 sm=1 tr=0 ts=68c8b32d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=9LJWlUjqVvmiLGY7KaoA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAyOSBTYWx0ZWRfX9CsDnGVdf/sW
 SOZ1PjeYOFgwDDTc8Zb8uBepPWu4nYEG14G6YqC+wLUCWPcPfBO8LPQ0cazp9zCF96ip4GV1gWe
 mclPSJtvlsq+8p8Vi+vqIYsFrkuJW/M2n8Tu8ttdwGZ146NRn0E+OcD1oqUlOWxx8NYeZ44z9jR
 LBfvVUUoKJ9OBW8xJyygGYhJ0gbUn335XMk+Fozep1OxpN1h2GRS+YAL0UaDLGCDnmxt3Nenhfh
 Mo79b5wjdrcNSsUBUfoDuft6if7x/JtlX+NgGcBE/foGntm1K2Fe5Xa5FkesMamL7ZZ1mAVsWaL
 /Y62K24aIkjclAbnZWoMDXUOJtKQ9cGfWD8k55wEJDj78M8fq7zt/Ow0Gf5dcCwlkfws65myxSF
 2/O8Z7P/
X-Proofpoint-ORIG-GUID: 9znWzjxjMMnxGbh1T15wy8SUdChk_Nkq
X-Proofpoint-GUID: 9znWzjxjMMnxGbh1T15wy8SUdChk_Nkq
X-Rspamd-Queue-Id: 61F7880006
X-Stat-Signature: zds9yhduo41gbbajzeec9oewmn8mzzct
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757983541-323130
X-HE-Meta: U2FsdGVkX1+9I3vwPQgaDtPccuDfnUSQpCnMl9YVVn+S9UBiKEHWxMEez/ooDNaNWCJD+QN/USKuYwiOtDXWe7IaTGfFPqv0qiakZqUmkUQspJz1cCga1J6rcTE1COgu00CpQFNCiF3cgz57FTpN4Mpz8cqZ2ntEY1Mom8ch3LlF31s9KAgbZdq9I0yYJ0wXcU8eXsrGtVICiZvbubSbFpgCIfEIQynpuJ2pZdJzJHrGVKk7NL/2wxTFssJA75U7k3B2aN9SPIXyFFFdsrq9gjtK2vudEnH9FEY2UVdC2j/Ug07IVNaL/FklxL8C2ncVrRYCLaQbpAnZc+grOlk3ZP1T5w0yDUFA4IZIxBX7oKacRjW4s+xUguZOEMdSM0+pFW0uOMM2cIUNzasvSZAdhYkQi9L4yG/K5cnrMtE/0QBtpufvBoySnPoG3mNxlxlqvADnsJRtU24VNAIFVeh385jIsmuVdfyqIdCq/+gJjwrmNMNMmXs38YPY5on0G6n8clBX6GSa1UhauOAnNzrXv8shuDCesewoB3p7I+crmRL1FMA0s6TBcwJWnd39kLR60SROi0gpWce9SVW8AZe8S8ALAUfMnhxd8PKV7Zfa3M+uAFODOxDPui0bB+SG7ldp1+vPsDl0TnXIhY3RPVqjgZYAM7SGQyaCFKyAgO0YvoxG4vaM1Cgk3/ITbCzsIK5CwI6q8zlwYhtgb2y4P2gc6cPCaYxch6LGa2/s7aeiITFOyi9ZdVlhU5iI5c1AwWTa9sRdZQm/j4NSAHgxP3KAnRc18mBstmew2f5Mz+2tAzSqa4E+GizAR3A7QGL1KCQ73GbaUCuuo+fSMIRCPg/wTkFDZXJRCN/irJDDkv8M/vKtXvpe2gSeoMMck2u+kvxW3sQa1UP+b9Khrjd9fETtVHNn+A/Z3ezhtUcIHC00ctOiqp1QsuZ3xYrxQHVxG58pgnYezZQCrGF9Zhfxxtg
 4MBDT+rA
 XqqpHzY9VkvAYhai3yecU6KSc5GFUXGn2anooNy39PK/8M+qqfUU8gGpYiCTkPdHeDJzHr61HcUNsg6mJcWA8lpAwxyKmtJI+3lrV/G6v743fSebRQNHArveOj9APyEzqxzu/6h5IrDuHUROQ+o53eyV6PzdSTQNMUXKiyV/VbLicI+GDSkY3QckvMFv4bXwAvD3rkDs1hku2KoW9skiKHeYUANiVAvkHHUbN83UHZltxYajPsBsM4HfdSBc9oqA1GKB6qzDxaK4Bp/9uNZlfTlB+qPaLVaIj/FOOooqtvN3W6jZUqgceio+w5D/1KzwMP3ot3JI6bAzvVClzOt1Kqd1l4ykuE291b27y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

commit 59d9094df3d79 ("mm: hugetlb: independent PMD page table shared count")
introduced ->pt_share_count dedicated to hugetlb PMD share count tracking,
but omitted fixing copy_hugetlb_page_range(), leaving the function relying on
page_count() for tracking that no longer works.

When lazy page table copy for hugetlb is disabled, that is, revert
commit bcd51a3c679d ("hugetlb: lazy page table copies in fork()")
fork()'ing with hugetlb PMD sharing quickly lockup -

[  239.446559] watchdog: BUG: soft lockup - CPU#75 stuck for 27s!
[  239.446611] RIP: 0010:native_queued_spin_lock_slowpath+0x7e/0x2e0
[  239.446631] Call Trace:
[  239.446633]  <TASK>
[  239.446636]  _raw_spin_lock+0x3f/0x60
[  239.446639]  copy_hugetlb_page_range+0x258/0xb50
[  239.446645]  copy_page_range+0x22b/0x2c0
[  239.446651]  dup_mmap+0x3e2/0x770
[  239.446654]  dup_mm.constprop.0+0x5e/0x230
[  239.446657]  copy_process+0xd17/0x1760
[  239.446660]  kernel_clone+0xc0/0x3e0
[  239.446661]  __do_sys_clone+0x65/0xa0
[  239.446664]  do_syscall_64+0x82/0x930
[  239.446668]  ? count_memcg_events+0xd2/0x190
[  239.446671]  ? syscall_trace_enter+0x14e/0x1f0
[  239.446676]  ? syscall_exit_work+0x118/0x150
[  239.446677]  ? arch_exit_to_user_mode_prepare.constprop.0+0x9/0xb0
[  239.446681]  ? clear_bhb_loop+0x30/0x80
[  239.446684]  ? clear_bhb_loop+0x30/0x80
[  239.446686]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

There are two options to resolve the potential latent issue:
  1. warn against PMD sharing in copy_hugetlb_page_range(),
  2. fix it.
This patch opts for the second option.
While at it, simplify the comment, the details are not actually relevant
anymore.

Fixes: 59d9094df3d79 ("mm: hugetlb: independent PMD page table shared count")
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 include/linux/mm_types.h |  5 +++++
 mm/hugetlb.c             | 15 +++++----------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 08bc2442db93..a643fae8a349 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -631,6 +631,11 @@ static inline int ptdesc_pmd_pts_count(struct ptdesc *ptdesc)
 {
 	return atomic_read(&ptdesc->pt_share_count);
 }
+
+static inline bool ptdesc_pmd_is_shared(struct ptdesc *ptdesc)
+{
+	return !!ptdesc_pmd_pts_count(ptdesc);
+}
 #else
 static inline void ptdesc_pmd_pts_init(struct ptdesc *ptdesc)
 {
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index eed59cfb5d21..6cfe0b43ab8f 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5594,18 +5594,13 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 			break;
 		}
 
-		/*
-		 * If the pagetables are shared don't copy or take references.
-		 *
-		 * dst_pte == src_pte is the common case of src/dest sharing.
-		 * However, src could have 'unshared' and dst shares with
-		 * another vma. So page_count of ptep page is checked instead
-		 * to reliably determine whether pte is shared.
-		 */
-		if (page_count(virt_to_page(dst_pte)) > 1) {
+#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
+		/* If the pagetables are shared, there is nothing to do */
+		if (ptdesc_pmd_is_shared(virt_to_ptdesc(dst_pte))) {
 			addr |= last_addr_mask;
 			continue;
 		}
+#endif
 
 		dst_ptl = huge_pte_lock(h, dst, dst_pte);
 		src_ptl = huge_pte_lockptr(h, src, src_pte);
@@ -7602,7 +7597,7 @@ int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
 	hugetlb_vma_assert_locked(vma);
 	if (sz != PMD_SIZE)
 		return 0;
-	if (!ptdesc_pmd_pts_count(virt_to_ptdesc(ptep)))
+	if (!ptdesc_pmd_is_shared(virt_to_ptdesc(ptep)))
 		return 0;
 
 	pud_clear(pud);
-- 
2.43.5


