Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A056CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 19:27:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 313A28E0003; Wed, 10 Sep 2025 15:27:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C3358E0001; Wed, 10 Sep 2025 15:27:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D8938E0003; Wed, 10 Sep 2025 15:27:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0C2298E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:27:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 977ABC01C7
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 19:27:56 +0000 (UTC)
X-FDA: 83874325752.23.599FD77
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id A1A8C40002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 19:27:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=m9Ok4QJb;
	spf=pass (imf07.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757532474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+3EvZZKa0EsHJ+k17Rw45a+OlDYujNqb0fATCwyYnhA=;
	b=XcSym7NHCPmM/b8WPW1qdVMY9x1xforl5xzJJMYwwFICu8Zcv6CdOTZa+1DZKZPDtZVp2Z
	rVE4BplgPz+RGx0oz32u7zKZQbd3oH9wDXphD06i8igaHUSDMoLpOzzCzo0f1cxiYWhql3
	ONTZAD131C1WQ7qnQQ1nvguGqiiHfpg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=m9Ok4QJb;
	spf=pass (imf07.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757532474; a=rsa-sha256;
	cv=none;
	b=KUOgX3HVemXZV90CYDrG4OlUAWajh0zZuzpLEx6zdqd5rrKX01m7c3KT/zA3Ernw+2zRjH
	q+psIle1Uzgn1npe/uZFZ79rzXFa00CBiyi1p/I0TioanM2RqPvrXNV6X/Y1dXHQGg1g1K
	A+cxUk9comD+wJKQTWo5rKxd/246Y3w=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58AGfi7L009730;
	Wed, 10 Sep 2025 19:27:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=+3EvZZKa0EsHJ+k17Rw45a+OlDYuj
	Nqb0fATCwyYnhA=; b=m9Ok4QJb9k5JjO7aptMB541odBWiAzv5wXCtlrXGJVZYT
	yWCs3pzLyO18rdwT4LcDbH97QfLMsI2qSHAmXIFTY7DUD43IqCwe/BF2LsPDQNfn
	geisvrvNp79dP8vesdiDTpt5B+P5gZ/l1SoYB80L02/QV9SjLzpL59D54YcoD/xu
	nlujQhFSdetwKuFQRZKsfHhYVmG+rzFUIt8a/dNLqyvtr6hcONeAqwtwMtxSD1Bk
	KibaEyfwdIgOnq4TAv5leecYcmiy/y8DZlHzz7F6CqKzUH5jYwg+Vwpo7msLS13Z
	AURRmWR7Xxbrpr7HEEpCSkXU9VkShHU9Y/km7nuuQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922shvs4k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 19:27:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58AI8EXD030633;
	Wed, 10 Sep 2025 19:27:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdbdrsx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 19:27:44 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 58AJRiuP011847;
	Wed, 10 Sep 2025 19:27:44 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 490bdbdrsb-1;
	Wed, 10 Sep 2025 19:27:44 +0000
From: Jane Chu <jane.chu@oracle.com>
To: harry.yoo@oracle.com, osalvador@suse.de, liushixin2@huawei.com,
        muchun.song@linux.dev, david@redhat.com, akpm@linux-foundation.org,
        jannh@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm/hugetlb: fix copy_hugetlb_page_range() to use ->pt_share_count
Date: Wed, 10 Sep 2025 13:27:30 -0600
Message-ID: <20250910192730.635688-1-jane.chu@oracle.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_04,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509100180
X-Authority-Analysis: v=2.4 cv=esTfzppX c=1 sm=1 tr=0 ts=68c1d132 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=mG3bTaASnfPRmh1c64YA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2NSBTYWx0ZWRfX4oTgxgB7KWyI
 LoDkC897DT0RhsQkLREDK5nk9BaoelX0jahQNA6OfxBiQemXDoKwHeQc9IoMizAUTTX/xmpp8aT
 5uMTtDcasO85h2lGb58gK2JjNbMWIyffpiA1diPSCVXZgl1+sxKeZ3DYwOOinv3xmUkjZygb22N
 Cxx/I6rohpLeEaAOeuyR1GAoB6FAdj3mu2Fk1A3HhzzPmcnZRFk33I36G/7Mnt2T8hpbeTJEPNm
 u58GGHkjp9+Tl9g+ZNzIMt4NPp74NvjC4gTR+ElewzksbDqSp/LIMEzx7BDO10GbJwGzIAKirdj
 8SlU0G+y730OIYwFrwAJBYEd8Tz5u9D/nkEEKcG6ASD8dDCefBME0+W54BCjFNWrK2VcvEumfKq
 ReX0gwtu
X-Proofpoint-GUID: cB11w8JWxVTPS89nD9VMWUUWkk2EVzgC
X-Proofpoint-ORIG-GUID: cB11w8JWxVTPS89nD9VMWUUWkk2EVzgC
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A1A8C40002
X-Stat-Signature: j48nzh6b6k9xtkk7g3e3bazqoh5purd3
X-HE-Tag: 1757532474-522845
X-HE-Meta: U2FsdGVkX19r7pGiHW00ufrJg+zOWeoUKDYXSMtulmnBZrMxdZMLi2lcZBcMmQDCEwjIG2ueUS78EM9Z2NNRJFAitleKnimQBt67K7nSwcjo0W+bSDUTmtEAH8LKHrbTmsjYew4w89Vlu8IT23aJ1EGKD0noRdLV7nKNqNyqHnNKHpOsXDRlbQpD5dkORZc9Ic2UywPLz2PKxvMYrfQ2RojGyab5i5JNJntsBKjzqadRvUBRmTNyAy6mjoNJmzJ4E3nCzIH5AGiZ6Ww2I0K0JvPjiZ0ZQ/UqkMPHQL++8e7uD+GRe6CbcJd2eEoM1aeddidTfjyapnzxQqUFvWbwXvnt4IFSm8ixWZoc+WzGROFXdTfEy7+KSELX9ZYCecQGSRamSE3qRTUsY28YImO2vcDaK9jw0YLJy1UDbkJ4OWWNkU3V20s5RwX+OkAatxayfKYe5bGYybj1VGMmmO0pJzYUD4vPM6/HMZGzsrZdnCboRx5y20Uo7Aefmu6PdMR4hWwukX79sLgjaEM4z8P/fpmXY/ORnJWn+3d4PW5FhASgFTzzIFOAkVsz7/WZQiSveEqFroNCx/aMb7cwmYSSBpENQrQ5+zgqeeDut9rdkhRJ/VgSSUB5KwRQx4bunyIB+ZbXyqH9IlrrTB1l69AWSD0yeKdjMpPusiSqFUpEScGqhroSN4Ubnf1zfQXtQ4+aptNeytSiqD/ItvWOq+ASSyrLaWeXrcWnzuhgaEyQXNHnm9khYAZtffsHsiCi+trq4dTR8r/N9gkquSB4UqoZXW93g05InY+P2GU9eTs6tsf1EnAtza23KDAk66lnMtZ/D6S6CSn7yzSxJoCpqvmVpAG/mmhaNqC1vzAuBf2zUoQxJGy3VrMzd7u5Ib8NH1MAOFU2wR3FJthAnc/QFStUJ7mFRwcQI5eSnevdQv78nXl4JcejHWy8mHQJONLMP8DaZcJ6dUZFCrayqr8fzXb
 7vGdREBK
 no5wWolYyj1H2OfkHWEIwMOLwMnn88onsZszsS4auApzsMN4IX2CG1HAhefAgyrPxYPvZEDL9+2KBViFojU7uR+mLWdJw8O60dAIzT4+Px3UJv5C6kwIMprymhb414LwGQRO7FLA77aBR1dlxguNP3jzXk6mdnyBl4SVwuw2XfBCczEyeQl6t3YmWBtgrN7TCQyhb29C2Z/nHlPj3RhXPxuEj3mb62NjbQ9Fhge7qOfcCMsA=
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

Fixes: 59d9094df3d79 ("mm: hugetlb: independent PMD page table shared count")
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/hugetlb.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 753f99b4c718..8ca5b4f7805f 100644
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
+		/* If the pagetables are shared don't copy or take references. */
+		if (ptdesc_pmd_pts_count(virt_to_ptdesc(dst_pte)) > 0) {
 			addr |= last_addr_mask;
 			continue;
 		}
+#endif
 
 		dst_ptl = huge_pte_lock(h, dst, dst_pte);
 		src_ptl = huge_pte_lockptr(h, src, src_pte);
-- 
2.43.5


