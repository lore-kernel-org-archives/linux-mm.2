Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9F75CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 18:44:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA1A98E0003; Tue,  9 Sep 2025 14:44:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2B158E0001; Tue,  9 Sep 2025 14:44:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 941388E0003; Tue,  9 Sep 2025 14:44:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D34E8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:44:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ECAE986DBE
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 18:44:15 +0000 (UTC)
X-FDA: 83870586870.16.F0791AE
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id BDB7340009
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 18:44:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BlJB3gnO;
	spf=pass (imf27.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757443454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IWOZ/MveQGGxyYuOsjNd57QH01BWPX4a/YbbD/2Wk+w=;
	b=bxHjv4Z1qnirB2rfEvSVJrseYAAUT781Mbi3vRWo/5trJQsUxl7BpO0y9JEieGMJ2HuUs+
	k2eyuw0Ed6EKW8FKia4mQI/oGfUWxs3mexHr8xnZPh78dqKbR3Vjn530uhF9fb2ZWN56AX
	34vDvydgMaN+bgiJOYI28MdNqnuFX8M=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BlJB3gnO;
	spf=pass (imf27.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757443454; a=rsa-sha256;
	cv=none;
	b=IkQqSBTXgjU7XSEFKTg9rpbLt5kQ++SOxqQj4M7t3Y9Pzdggy/PMqcWTQda2xOwE3vMoYR
	aKjZvxmoE7UfKUgYdvgmo8qlh7IYpbmG7cHpSjPnteDPQ3YAcEAX1zDPH8lObvwq2Y2EI8
	bsMpwmhE7XRY+GRz4fD5T8fI0fmgr9g=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589FtjZk014532;
	Tue, 9 Sep 2025 18:44:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=IWOZ/MveQGGxyYuOsjNd57QH01BWP
	X4a/YbbD/2Wk+w=; b=BlJB3gnOhm7zcxOUTuC3crwT7IbaExiui/D2JlzUPhk8m
	N+HzS/As/ZbNy0MU3kft6LekYuOo2zj8OiHonvRMKLalZlCBdhQHRQ0O4b8fKtuC
	HG6PKf7kJaWG23yydGWKV4cbxRg6lbi82pWm7+TyEDk3qtcFMvx8GDZAdD8bddc3
	51LdVXsWjJwiE1nq8jAMt90AgfiUaIJZ4eY1TYPw6ZiaVrDU/mEBqp99tA4+5Vrx
	xw2E9JUN24wh59ahKB4rUx8ihUNErlHTQYYEuwfg5wcJISpmBs0G0L18POAWISAY
	qZ2VtyH3ziZXfFPvaNV5KrtCJcDTLBnjWwfrxnOSg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921d1jse9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 18:44:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 589H8kg0033216;
	Tue, 9 Sep 2025 18:44:05 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdb0db7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 18:44:05 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 589Ii43G004503;
	Tue, 9 Sep 2025 18:44:04 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 490bdb0daf-1;
	Tue, 09 Sep 2025 18:44:04 +0000
From: Jane Chu <jane.chu@oracle.com>
To: harry.yoo@oracle.com, osalvador@suse.de, liushixin2@huawei.com,
        muchun.song@linux.dev, david@redhat.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: jane.chu@oracle.com
Subject: [PATCH] mm/hugetlb: fix copy_hugetlb_page_range() to use ->pt_share_count
Date: Tue,  9 Sep 2025 12:43:57 -0600
Message-ID: <20250909184357.569259-1-jane.chu@oracle.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_03,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509090184
X-Proofpoint-ORIG-GUID: WRSfngHTR2VCUKNIEOx5Re1gBizfe0Mp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MCBTYWx0ZWRfX7xwTxW1qSJZ0
 0IivqUUG1PWFnEgAEN0RWu1g8KqZhe2NiIx6rz4n7+JJ1aYaUfXuHrRsdAXYxUwp6PzkIv0Qjz0
 NJdsrWRlaEGBt1WhdBfuhYyExr0YuMhwpJFNWHJ3NB8YLfzYk54qsNW5gcEiT8bnxQpws5sQQh7
 ceh4VqxwTYFUa9sItnzOb3luiTwmz3LCABn1nLSgEdLfZYD3eb6WfY6wH0t7+lHb0igL0PluI90
 M0D/yKwUhj0sZ4v5iJ4vFTprw3v/zwA2h1pwq8+X8skhueE9h7AnfNWV0iztMQFS8gDyfYU5zdg
 N05Bk5xIFBtMc0gakmMNqEXYTVm5P1g1TwWDY9jQmhhz5iXEbo1dCNDPF2Dslo3CxS309vDDKsO
 1tE2oa8z
X-Authority-Analysis: v=2.4 cv=d6P1yQjE c=1 sm=1 tr=0 ts=68c07575 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=mG3bTaASnfPRmh1c64YA:9
X-Proofpoint-GUID: WRSfngHTR2VCUKNIEOx5Re1gBizfe0Mp
X-Stat-Signature: hof87755rhn4nnxnyjbgifzppzzkc4hh
X-Rspam-User: 
X-Rspamd-Queue-Id: BDB7340009
X-Rspamd-Server: rspam04
X-HE-Tag: 1757443453-636928
X-HE-Meta: U2FsdGVkX185ulDE/MPpIWre/fbAr63dVWTqQqAI41AZZoteXMa/+GrRl2kNk8mgOFSXyC3J8MwbqvDSOuclXr/opRnZeJGk2CPZL3zR7Y3/K4Ui7nwt+sA/8Vn9Mlu0bE1scH47N0MwJxnJdYz/0bZvvXvBts5kCpqexhZhkFPaNsj+G+nBDDK70NcQaQMAO3XYXm3i8W9yY1lUKK8UqjNNfjefMpi/dBNxvTwNrx3xfkEoK+CK6oOGx18vUIvp0NX7TzERihxfNJ6dI5kcaraGsE8UVEy3WMGm8/tgdrJfDOf550vp9MaGSBzFo1wCZHuS9J6KjGAiRY+Nj6+TBqDkKvg0n6aQJwTA26lXfuoU/zQ0Rv6ptarqsc0kPGRN/tqQp2aHksRXgQhBEtND6gejCq+oUdNThn4zc1U6/Uo5zuIbNKGZKAhRx1wS42D+ef/nZvC9aXdFfGoWdhxdSPNG2Q8TRRlF2Y3QVuRAVfKVrPT4oj3x7B0lJUzPnTsMUVgU92adVDQzfmkDqnTbZ8BbBXv9KOZcZ+3OGtL+QhyhZyElKnCJYGN5VXpLRGVPVnOxzy9zczYCZfiwJ7/8w3ejPhjnk46PBZP2G4x9cBFXcZv3w7vCILJ9IJWMxHPPjSprid/Pxq8+IGswHJ4ZbzdNFl9fOGZag2g6IPLM9cQiO1/6fypokS2ZmDuThu1SNzDsRwSAHMXdXvLQO2MgneiASa2DlzxHZWqiKeqlkKclZM7mkJKJxgGv2KZmiCBJRbITFRXAmbepIxPGbXlKsRoKHDE/K4dtTK2wOhxah+7/j55MhDCZ9TTgLWOsjrRD13Px4MD1dGOE1DNJklQ08l7kQHND8yoLyVlIElqNwyoFzhA9S6K4ZYol22gb/sw2tm4XKBWW8YjOrnhqATpLvo73xcWi0JVRiOwBnWRQlgTfCvmlMHpEmAXy3ijZSqMfM7z0XU15rPC6bpz5vTx
 DlDUnGUK
 TLfKgUw6B+loqJYnXfoU5LS8hH5QGbw41UHnm3hkVM+edICu/2ic12BzUGbS6xEprNZVhGqbqiHu0PVeCavq7CMDdzeNa2qzw1gfiMNBGNmtWjo1Z01C5g+qzh3M9BrJ0QK/3GMtNqgzj4C7wYeq180pAV8H9pTe77tXnBTmGKGnSa0jYXsCU6862gwShZYxx+mihgJYQe6JazMuKYoe/tJgfLiMm6pM4fk+o1vqif1OglWm64Ae7DG3NQV31H+3a2K0Jp0aMwfVnQh6BUZJ8U+I/1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

commit 59d9094df3d79 introduced ->pt_share_count dedicated to
hugetlb PMD share count tracking, but omitted fixing
copy_hugetlb_page_range(), leaving the function relying on
page_count() for tracking that no longer works.

When lazy page table copy for hugetlb is disabled (commit bcd51a3c679d),
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
  1. remove the PMD sharing awareness from copy_hugetlb_page_range(),
  2. fix it.
This patch opts for the second option.

Fixes: 59d9094df3d79 ("mm: hugetlb: independent PMD page table shared
count")

Signed-off-by: Jane Chu <jane.chu@oracle.com>
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


