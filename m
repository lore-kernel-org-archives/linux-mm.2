Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E712CCAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 19:13:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EEF88E0005; Tue, 16 Sep 2025 15:13:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39F9F8E0001; Tue, 16 Sep 2025 15:13:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B5518E0005; Tue, 16 Sep 2025 15:13:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1ABC88E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:13:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BBE371402F4
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 19:13:26 +0000 (UTC)
X-FDA: 83896062012.01.698DCBE
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7E2AD180004
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 19:13:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CSijAOus;
	spf=pass (imf24.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758050004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MunF14CLFqIG3RSLyPiI8/fZ9x1E9YDtogF7TGE4kB0=;
	b=qE8EW69URB/SnMzaF3N5yFQN75mgo1jSFVqbBw+UrI/V4Jy0Pz4KyGNE509JBDdBgHY++9
	mhsx8XKXZLhnRlJ4twjiX2LcK7tdpyw7dTnSnDHNS1PnhrIdfdOcDNeT+bVEp89PnKaaUa
	3zq2nDJLr5hkMGy0QO0s/b8uf+G2CtI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758050004; a=rsa-sha256;
	cv=none;
	b=c6eA9j1kiQiUwxi+TPzQTtRdYSF2Nn8QE4aaXV/EZ5k0GkSbC+CUSmbD7rPlhfm1a+5NIp
	faTF64FiFr+WTc4vhqv5ET9XnrJJy/iXdh3fgjjI2E2QqzJI6iIYtTBmwQR8wNmJtmQE+k
	Td3UesuiMAJ5bEzZa1V32kuzFsm/gVw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CSijAOus;
	spf=pass (imf24.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58GIMnjx029335;
	Tue, 16 Sep 2025 19:13:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=MunF14CLFqIG3RSLyPiI8/fZ9x1E9
	YDtogF7TGE4kB0=; b=CSijAOusNkY6bysbvzvfqMCAWo5ffK9ZnIbgpPvLz7UOX
	P4LN/brN1622cX8q+Tl7O/w5amX7j29Xq9WNVZv7VAtJnls/1fKBFtcRgVhjVxck
	6by7khLUWsl/5rn3/vGAolXHAKkUAVAFc1U5NQ1tH1LB6uRulnuJAE47TILXvPqg
	YfKrJIFbMHMWTpLHJnsFLe9xGCOYAqPixxdochi83qpGADsocuLs4I2YCIgdZ3Xo
	sjHPe1m31sOx5bJIKQgF6pB+WZ1O6r+ZapgGgwGk2hj1wRXmo6FgdMrccLXxknbO
	n2ZHBzGJVtplSL/13C7s7eMZpgfzD9n2Yxqp/xyxQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4950gbnb16-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 19:13:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58GILDXC027241;
	Tue, 16 Sep 2025 19:13:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2k3j0b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 19:13:14 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 58GJDDqG000676;
	Tue, 16 Sep 2025 19:13:13 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 494y2k3htk-1;
	Tue, 16 Sep 2025 19:13:13 +0000
From: Jane Chu <jane.chu@oracle.com>
To: david@redhat.com, harry.yoo@oracle.com, osalvador@suse.de,
        liushixin2@huawei.com, muchun.song@linux.dev,
        akpm@linux-foundation.org, jannh@google.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 RESEND] mm/hugetlb: fix copy_hugetlb_page_range() to use ->pt_share_count
Date: Tue, 16 Sep 2025 13:12:52 -0600
Message-ID: <20250916191252.1653993-1-jane.chu@oracle.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-16_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=926 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509160179
X-Proofpoint-GUID: jDbrp8mDSSrnQmOt6l0GCFpGavaTTqlE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAyNyBTYWx0ZWRfX6em316BjdP3l
 Zwi2STcgv2DglaxLU2IojuA8M5CBYmEJCXha6GXlscNAXcNf6kR3Bx2xw17AM5bBZopX0ceB/lN
 cS7mOy/pYdeOUpGjLznSLN4VkTKhj+d6NgasMwzrl38/Mp107adgQMG3kY4Xe1fsFijDwlpOPfj
 bmfN9zvSHytPHkoFb3lLF2rep9DKlEDXYHPRtzSUEnwiawljxtB+mtetWuhY62bOtXesy5m6udP
 zRLXZ8/Rh9nbqzmCW/X+xsws90fJ2lwJpqPWOKtgxOpfSrzC/TBDTTM8nuIO6FNGA62EdICZaW1
 eEchO7B5Jy4TjquhOjusS3q8fZncPndTzBz+qdRKKWw2jXzXzKtpTib1agdy5gC/obnK2jsabxS
 0zP41C4rspn69IuqIhO0eaXTENol7w==
X-Authority-Analysis: v=2.4 cv=QIloRhLL c=1 sm=1 tr=0 ts=68c9b6cc b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=9LJWlUjqVvmiLGY7KaoA:9 cc=ntf
 awl=host:12083
X-Proofpoint-ORIG-GUID: jDbrp8mDSSrnQmOt6l0GCFpGavaTTqlE
X-Rspamd-Queue-Id: 7E2AD180004
X-Stat-Signature: j9317jhg3u6gx91j86abfdmnmssmpujn
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758050004-949728
X-HE-Meta: U2FsdGVkX1/XB+OwVtx2sKE0t6vyg9dJfHvgx1yxSU61RQ0yzWTpqkldoiG2F4qpVxkmL5KM3GEON7UHH7r3g6XUx70jikmgc3JKYzexExCxPVbfFRivgq9xFJkCblzct2ulN7m9ytT+qPUtrepRgL7J2/1EU7o6uNlOaJDQxeRsQ6+Ti/CYahtn8k6EdDXaJbDNz+5lb0pDM/4EJv9fNnu/SU+1KupsSed1wQdMnIqUbqqZ7+Nv5dQAn2Nz6rJT7ksEobTCaSgunHgyMN9hBLWxhZmaao8ZOCEJdF80kvuV4r/vXQgjyaI3vu7/SnE+InzKqMXQUHUXG07RIXKFFni8k7o3LxmDC/mCXCpbFUjHIIen41SOp7q/yR2DuFlOG40uCykrs8G6A1PIzEhO4G4sp2UsBNcb0QRgx1xnG9mn7HmA1SJQjPqqcre8jaGxWncYIMhfguWQvq7PGrRJKd+XyfDsYMoOYoKojZLiFyQb8r4Hx/iN0OyDC++ZK1+S5pdX5CpNZewyB3qLsJjWKkqNBVrDtz4NkPagOBV0shguA9Q7zLPUYVdlveeen7+c2wR1GmEl8MdJ7MlgUQrf8UwDWCPexmfhdhhk5f0nLkrRNwcqYeHcOC2oJzvTIyBEPqEQe7e6tzxxrJ3wgKXrRoWoZH0lO1TSxYInuVtNRTIgCtf83r3CHHC2K5LH5+m8QJ7mGrwSRD9DqS5/LEpb7mm5zDA6mGh5lXfYwsamPb7SZ4obPcI40CHEJKq3IG29+n2/WLdCFCQD8SVwNIpynZltXpQG0Q3MRAx9AuJrjIku/L8Lh+8L8ncWuINz4fRQFmGFKSISwim9zprtNAXzK7dhVdiUAYg0yt5Ne/lSbqphdVcMm5k0VPUTfpZ2ITPKq6obJGl0kRozCThKvTyhn4YTUTB9TcEKxy+l0ONMpxT0mRBGady7xEFQvjIDUPjse2DjD0w7EesFSmpPSQh
 CHuKMapY
 Sh18Lvz9dGf3UHpsqrs2ZO4LThAXMj3pYK3PuCJzzJRdIIH9gQu2bGcl5tr1vfoGLTUxbNvs9S9pxLC2QqLPCaJAExTsMUsnpfxssPvCjWvTTMnQA2DNrxBRSJPZ6d6ZIzPOKqfjpNFSC+vncBh05RfkJ941f/bouqk40CGs9Y5Jow8zNDrQ7v1yROPaWKGGfXWB7skbCFih9ycMTiqjnSOP94Dg5KyimcZckfhd8W3tdMgiiEcvwq9ID3MdzeS1FHzbD+tTjwXE22O9cnLUpWAmNx85quRgtVTDRsj/O8atcqbAJlXCkUUqzupFnbZxF/ARzLUJqaDjf08LsYN3mC+Wp0x1Ye4S+ECp0
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
v2 -> v3:
  Comments from David: 1. provide wrapper ptdesc_pmd_is_shared() wrapper for
  ptdesc_pmd_pts_count(), 2. mention comment simplification.
v1 -> v2:
  Comments from Harry: explain why backport to stable isn't needed.
  Fix the sha lines.
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


