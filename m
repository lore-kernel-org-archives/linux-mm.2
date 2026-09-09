Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FECEC79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 07:47:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 062446B0096; Wed,  9 Sep 2026 03:47:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0134D6B0098; Wed,  9 Sep 2026 03:47:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6BAD6B0099; Wed,  9 Sep 2026 03:47:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C7AE16B0096
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 03:47:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CFC2C160124
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:47:19 +0000 (UTC)
X-FDA: 85193443398.21.4D90324
Received: from out28-111.mail.aliyun.com (out28-111.mail.aliyun.com [115.124.28.111])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0378040003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:47:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of yehuaisheng@open-hieco.net designates 115.124.28.111 as permitted sender) smtp.mailfrom=yehuaisheng@open-hieco.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788940038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=95zWfEmjhzDirzcYCEa7YW848gMiOajBkWPJK2r0zSA=;
	b=fgYlK6bXu0tyVd8uWy3s7ixzY1SAcyRUjO7RLzm0lC7KWfYejV8vV3ARKH3KZOUwg4PGQo
	+Whf14nDZTYRVpnxXRN3JwjdWQ97tNGddlK/gPPU+uqFLWEP0XfhLXNFUG38d+1ORsmngR
	kvGkwuMkrrTqlAt0bmiw9LJBFNXAnxs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788940038;
	b=OboGk4Fiyb4LMLSrTOPYRcpijzRll0IqiVLzrvNJ4k4ezbKl7+xXqnEXOEEfK+xsXQ5uEh
	ay0Gt4gGvs++kDQzUQcj8LjmZb2yAbhrZq5w0SH41ulTFDcbR3qQFDm2FmAJK8TX7GYR5O
	INzih1DItGciCVKLgZK4bH2smEWX8Uk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of yehuaisheng@open-hieco.net designates 115.124.28.111 as permitted sender) smtp.mailfrom=yehuaisheng@open-hieco.net;
	dmarc=none
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.07436956|-1;BR=01201311R611S83rulernew998_84748_2000303;CH=blue;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.172705-0.00782085-0.819474;FP=18101722540256330983|1|1|1|0|-1|-1|-1;HT=maildocker-contentspam033037032089;MF=yehuaisheng@open-hieco.net;NM=1;PH=DS;RN=7;RT=7;SR=0;TI=SMTPD_---.j9KD.hT_1788940023;
Received: from centos9p-03(mailfrom:yehuaisheng@open-hieco.net fp:SMTPD_---.j9KD.hT_1788940023 cluster:ay29)
          by smtp.aliyun-inc.com;
          Wed, 09 Sep 2026 15:47:11 +0800
From: Huaisheng Ye <yehuaisheng@open-hieco.net>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	linux-mm@kvack.org
Cc: david@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	Huaisheng Ye <yehuaisheng@open-hieco.net>
Subject: [PATCH] mm/hugetlb: account for allowed nodes when gathering surplus pages
Date: Wed,  9 Sep 2026 15:46:42 +0800
Message-ID: <20260909074642.7308-1-yehuaisheng@open-hieco.net>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: z96t9n9pxii5j8gkhnuoijkz1e41xesp
X-Rspamd-Queue-Id: 0378040003
X-HE-Tag: 1788940036-157896
X-HE-Meta: U2FsdGVkX18XZzIBRmWmzuZz+N+9fPAZMCqyC2K45ZkUgybsfm3msRE7lvqx4jVqEh/J7b2/mUk3vThUNZWxL/UxREKoPA/bdfSNxiIQf4omYG2CydaJ0/bBNmY+bAIBN9MTA6F2HDjMAri4lV0CNQi+NHu6XHxrYuurscZp4Sbppw59XuDj6zQje26Ba6Xe9bMSYYX5C9KazjDBbVlrrU+ea5/NyLjNX9fMXbapWfASThLx5xQrBBU3FYcWiEmk/3lapTulRoNFIXS/AXpusJ1gZg4g8DkWYrCr5Jzo9Cii11kqdFzb40lBRUTwqv92yYSqNsFSvF52oAfTFU7oOIFDvw49w9ezhm84S0KoMpUL+Dq7aCa219HZnpPfvtUh6PIp5FmN0ryRQcOIs1a1QO6Qk9/tBThlfP51REOIOp/dT9SMzAzZXMf0IM3hGBNG3FhPbGhJYQ9Ha82igdbWlFqZbujSMAjpKjvMPSU0VF9GA9a8+/wB5AjAto9cGhgaPLiz/Uso/amFWQ5kaLHj0YfpeGtVi34cp9FhETC6wd5Ad1Xm1jX9VtItW1EBkOzS2L5StpMtTPTHheSX7VbfhnsTcuk2R+Hfi7NX90ZirdatSVn+hz8aWkG8p4oLqRF5kPNcnGbuOdBoNQ1QAIWmDQGWhdN8xP9OcsZie49rTNCBL/kcApyECzUOG2DuigF1cdWSCn3fv/mlPDtS8TehqnCxTHLmP2kxBlkW4seo+UITAuxs9yQzR4vb5NUADEJRgAIviLYiGQaYGE1iq+WJmDoAFb5YcDhm3hzGmyEku84QaDH3Bb6PGB4rumI9YuBJ7hA/fomaL1ygmMx0jQkv4I2Qsxpw3S+V8hhXqb7vSVnlCBZQlldkPpl5mfI+jgf88XiRf8yTTagyZMShHvzuYS/6mffCZWsI8dKtqCKOEChjAzov8j2rs8qJKcTlu0vpGUnD+AfvbZFozeg8XLf
 Qr2lI2My
 fvcmPXpIMcPG/yiMkjfrHOQFwfPTHYC3JOUN11CnBec3vjb08HDk8wKnw6ojjO5ceIrk0K5K+BtEfIL0vFZKBc+JfCRVNDIgP7UpLwdkMGbTrOPmjpuBdCbBoEej+SQLzSwAt20zuXo1pUc6y06ciTeStO3knvBqRTuT0aKCBLmQ0uw2Okut+FHWqxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hugetlb reservations are accounted globally, but hugetlb_acct_memory()
also verifies that the current cpuset and MPOL_BIND policy contain enough
free huge pages to add a new reservation.

gather_surplus_pages() calculates its allocation shortfall from the global
free and reserved counters. If the global pool has enough free pages, but
those pages reside outside the nodes allowed by the task, it allocates no
surplus pages. The subsequent allowed_mems_nr() check then rejects the
reservation and mmap() fails with ENOMEM, even when
nr_overcommit_hugepages permits allocating surplus pages on the allowed
nodes.

Calculate both the global shortfall and the shortfall within the allowed
nodes, and allocate the larger of the two. Include surplus pages allocated
outside hugetlb_lock in both calculations when rechecking after reacquiring
the lock. These pages are constrained by alloc_nodemask, so they satisfy
both shortages.

Easy way to reproduce this issue with 2+ NUMA nodes system:

  # echo 0 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepage
  # echo 3 > /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages
  # echo 1 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_overcommit_hugepages
  # cd tools/testing/selftests/mm
  # numactl --membind=1 ./hugetlb-mmap 2 21
  TAP version 13
  # [INFO] detected hugetlb page size: 2048 KiB
  # [INFO] detected hugetlb page size: 1048576 KiB
  # 2048 kB hugepages
  1..2
  # Mapping 2 Mbytes
  Bail out! mmap: Cannot allocate memory (12)
  # Planned tests != run tests (2 != 0)
  # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0

This fixes hugetlb mappings when, for example, a task runs with
MPOL_BIND on Node 1 while the existing free huge pages are on Node 0.

Similar issue also could be found in ltp if the free pages of global pool
reside outside the nodes allowed by the application.
  # cd ltp/testcases/kernel/mem/hugetlb/hugemmap/
  # numactl --cpunodebind=0 --membind=1 ./hugemmap10

Signed-off-by: Huaisheng Ye <yehuaisheng@open-hieco.net>
---
 mm/hugetlb.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 7857728457952..b078953099fe5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -116,6 +116,7 @@ struct mutex *hugetlb_fault_mutex_table __ro_after_init;
 
 /* Forward declaration */
 static int hugetlb_acct_memory(struct hstate *h, long delta);
+static unsigned int allowed_mems_nr(struct hstate *h);
 static void hugetlb_vma_lock_free(struct vm_area_struct *vma);
 static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma);
 static void __hugetlb_vma_unlock_write_free(struct vm_area_struct *vma);
@@ -2224,6 +2225,19 @@ static nodemask_t *policy_mbind_nodemask(gfp_t gfp)
 	return NULL;
 }
 
+/*
+ * Reservations are globally accounted, but they must also be backed by free
+ * pages on nodes allowed by the current cpuset and MPOL_BIND policy.
+ */
+static long surplus_pages_needed(struct hstate *h, long delta, long allocated)
+{
+	long global_free = (long)h->free_huge_pages + allocated;
+	long allowed_free = (long)allowed_mems_nr(h) + allocated;
+
+	return max((long)h->resv_huge_pages + delta - global_free,
+		   delta - allowed_free);
+}
+
 /*
  * Increase the hugetlb pool such that it can accommodate a reservation
  * of size 'delta'.
@@ -2246,7 +2260,7 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 		alloc_nodemask = cpuset_current_mems_allowed;
 
 	lockdep_assert_held(&hugetlb_lock);
-	needed = (h->resv_huge_pages + delta) - h->free_huge_pages;
+	needed = surplus_pages_needed(h, delta, 0);
 	if (needed <= 0) {
 		h->resv_huge_pages += delta;
 		return 0;
@@ -2277,11 +2291,10 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 
 	/*
 	 * After retaking hugetlb_lock, we need to recalculate 'needed'
-	 * because either resv_huge_pages or free_huge_pages may have changed.
+	 * because either resv_huge_pages or the free page counts may have changed.
 	 */
 	spin_lock_irq(&hugetlb_lock);
-	needed = (h->resv_huge_pages + delta) -
-			(h->free_huge_pages + allocated);
+	needed = surplus_pages_needed(h, delta, allocated);
 	if (needed > 0) {
 		if (alloc_ok)
 			goto retry;
-- 
2.52.0


