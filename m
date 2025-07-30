Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C013C87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 08:15:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD3B26B0088; Wed, 30 Jul 2025 04:15:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA95F6B0089; Wed, 30 Jul 2025 04:15:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABF6E6B008A; Wed, 30 Jul 2025 04:15:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9DA4E6B0088
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 04:15:18 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4E8848027D
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 08:15:18 +0000 (UTC)
X-FDA: 83720221116.02.2AEA601
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf23.hostedemail.com (Postfix) with ESMTP id CBCA414000A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 08:15:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="I5l/yjjj";
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753863316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZfTdKUbwT+CGqRYeyNrf0eIANy7ZlcAynRZ8f/EUVM8=;
	b=rnNU+UvLGJHPNNrAXV5Hc4EnszsTQ71stnQ+xFQOFkKZWuwzaj7vnWRRTRPevsfvl3ioDs
	2gL4HPOGLBudFxW4i27S7E4lbAVxKhujS3oyRjeUYMN/eM1Xw/kqb3EDuWqd+fym/qom7Z
	doLZLkJafMKnv/cgiHVexr79LJrihmE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753863316; a=rsa-sha256;
	cv=none;
	b=DevOE/DvF5aqKX7kH++FWQ+2mwhZTAGfsi1ij7VWHDNMl+sG5ZMd4/YucJjqLJHmtqZLQP
	aFteODx4aGOkJ4ojLWfWE4+RHkrtmKpW0me+jQLpqCP1ifdd1bPiHPWzRFuieSm0pITN83
	0Xh750tXR5BKvV5ww0FE8jUpl5pi4M8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="I5l/yjjj";
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753863311; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=ZfTdKUbwT+CGqRYeyNrf0eIANy7ZlcAynRZ8f/EUVM8=;
	b=I5l/yjjjK2emIuzRqnQllFLCYdzSnsqqJa6YHBaOgINUFAq02FCj//UGFwMKyuBm+jhCW2kTAlr7s4JuG2avS6JXICqdWkhwiircm0a43mFDAqessiPmXIAxznUj7Ijj7SKimORQVXAypxjR+Z/+ZM2QualBaP9bBjsAYWgcRek=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WkUFS0K_1753863307 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 30 Jul 2025 16:15:08 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com
Cc: willy@infradead.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH] mm: shmem: fix the strategy for the tmpfs 'huge=' options
Date: Wed, 30 Jul 2025 16:14:55 +0800
Message-ID: <701271092af74c2d969b195321c2c22e15e3c694.1753863013.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CBCA414000A
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: t34uaximsq3tm6z536ufepd5aiddr3mw
X-HE-Tag: 1753863314-877438
X-HE-Meta: U2FsdGVkX18s5S2tnHggDtbs3MLsXmrFshZjzJbY2kHA5sAA79Xr4rVpj6xVdfp643TyL+4Yd8QLG4e6P3Xv8iYP2cDJ38LOagUxfuWqCUjS/3QElzWaQNEColpigbQzf2k6Nzbs/ZFltg7QR6cDFJoHC+YBfoghqB6D0ow2tjDiB5WMNh1qRl6LQlR6mKdLu+34Y4lv0QV0Vu7M7pxbONWJmZd9VvNm4igtMyKtNaqN/HAuVoRttmI8gnuXf1TdrbxfT/OpB6viOHE1upguEMWzod0VJpuNbSFYj8XGfnXTVNLFED5xmBl1bXJEoRCEcRJQHp7tbvrtqH0ojDrOqN0KzAt2fCOPJixDOqvR86xILl2Ow9glkkv5+UoNVWPbFe++EWcqVWaVO/xxrpGgjsxRSWO30Qfopj8eRtANO2XNEeuNjBG7Ngi5QDFqtBcV+wVP19G3FNgnum4rZwvV58JT48y4laXLr9j4CI9V9B4joXPpIc5FVpCROoREtlLG2S4TsKWEF5aHu595NjTLOpv3L6LjpbCGzqzJMq7iopS0zOumVy9c2yzkV1Rw1SAzEEAY8RtfBHYZAYvDuZUB3Cnl3xsGbRZIWDxTyertyxxa8r3WfP8ESxqIWhic71edB35VSvJ0ElaH8gzXcO3PuOYa0IBV/z5FY3cqAsf8a8xYgVFccqXvhE2RP8UQmjA9b3ZXhOypOzi01iATWvsB6zhZtMS7GEDOq6XsZJVHoQyWvYhAtBI3wQmS6c/72Kor9uuMqwNR/jKt6gRrxJLA/Y/mKWeRDspP4GScwp97n7u3oirFjvba+gW3XAuN+3gDPd4AFroMfUTc0spNnvp9UQVRYIqyJd3hW00jwLiK/lagx1+A+1lcx7bEpj2wmWgFobUYU5WhHSkISOZM2oqJ1Qql/ny2qohHFL2zNYCFwDmuycE5iAlIapB6iQgG65r+4GwYwkahZwGJhI9pSZk
 HR34Ik/e
 n87nUE+I2cSRLPjLsNTRFWFkfKf7QidLvIxo0m6hcMYx5faQN6+fpjRmPFgr1tlpRpVnx3j9ZgJr8669Waef7isEDI/ZUawt7nL0i/vDjz4aiwkpZbzSLas8U3wOQQ/Dtk9oLb6Llan8HTwnd/wyZhNBCsyaXQOUxey4KtvRkBT67K96BUVd3Vn9mFRUxATOPxsGnlRiTmi+BeY6DHhyaJBHhZZTvhLa2/Wb5isZct9OUqpXfnXPedNMz43C+mhcAT9YJxSuaXgCMdJ/0PQSwAsar9BAJ/lB9L8F3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After commit acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs"),
we have extended tmpfs to allow any sized large folios, rather than just
PMD-sized large folios.

The strategy discussed previously was:

"
Considering that tmpfs already has the 'huge=' option to control the
PMD-sized large folios allocation, we can extend the 'huge=' option to
allow any sized large folios.  The semantics of the 'huge=' mount option
are:

    huge=never: no any sized large folios
    huge=always: any sized large folios
    huge=within_size: like 'always' but respect the i_size
    huge=advise: like 'always' if requested with madvise()

Note: for tmpfs mmap() faults, due to the lack of a write size hint, still
allocate the PMD-sized huge folios if huge=always/within_size/advise is
set.

Moreover, the 'deny' and 'force' testing options controlled by
'/sys/kernel/mm/transparent_hugepage/shmem_enabled', still retain the same
semantics.  The 'deny' can disable any sized large folios for tmpfs, while
the 'force' can enable PMD sized large folios for tmpfs.
"

This means that when tmpfs is mounted with 'huge=always' or 'huge=within_size',
tmpfs will allow getting a highest order hint based on the size of write() and
fallocate() paths. It will then try each allowable large order, rather than
continually attempting to allocate PMD-sized large folios as before.

However, this might break some user scenarios for those who want to use
PMD-sized large folios, such as the i915 driver which did not supply a write
size hint when allocating shmem [1].

Moreover, Hugh also complained that this will cause a regression in userspace
with 'huge=always' or 'huge=within_size'.

So, let's revisit the strategy for tmpfs large page allocation. A simple fix
would be to always try PMD-sized large folios first, and if that fails, fall
back to smaller large folios. However, this approach differs from the strategy
for large folio allocation used by other file systems. Is this acceptable?

[1] https://lore.kernel.org/lkml/0d734549d5ed073c80b11601da3abdd5223e1889.1753689802.git.baolin.wang@linux.alibaba.com/
Fixes: acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
Note: this is just an RFC patch. I would like to hear others' opinions or
see if there is a better way to address Hugh's concern.
---
 Documentation/admin-guide/mm/transhuge.rst |  6 ++-
 mm/shmem.c                                 | 47 +++-------------------
 2 files changed, 10 insertions(+), 43 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index 878796b4d7d3..121cbb3a72f7 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -383,12 +383,16 @@ option: ``huge=``. It can have following values:
 
 always
     Attempt to allocate huge pages every time we need a new page;
+    Always try PMD-sized huge pages first, and fall back to smaller-sized
+    huge pages if the PMD-sized huge page allocation fails;
 
 never
     Do not allocate huge pages;
 
 within_size
-    Only allocate huge page if it will be fully within i_size.
+    Only allocate huge page if it will be fully within i_size;
+    Always try PMD-sized huge pages first, and fall back to smaller-sized
+    huge pages if the PMD-sized huge page allocation fails;
     Also respect madvise() hints;
 
 advise
diff --git a/mm/shmem.c b/mm/shmem.c
index 75cc2cb92950..c1040a115f08 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -566,42 +566,6 @@ static int shmem_confirm_swap(struct address_space *mapping, pgoff_t index,
 static int shmem_huge __read_mostly = SHMEM_HUGE_NEVER;
 static int tmpfs_huge __read_mostly = SHMEM_HUGE_NEVER;
 
-/**
- * shmem_mapping_size_orders - Get allowable folio orders for the given file size.
- * @mapping: Target address_space.
- * @index: The page index.
- * @write_end: end of a write, could extend inode size.
- *
- * This returns huge orders for folios (when supported) based on the file size
- * which the mapping currently allows at the given index. The index is relevant
- * due to alignment considerations the mapping might have. The returned order
- * may be less than the size passed.
- *
- * Return: The orders.
- */
-static inline unsigned int
-shmem_mapping_size_orders(struct address_space *mapping, pgoff_t index, loff_t write_end)
-{
-	unsigned int order;
-	size_t size;
-
-	if (!mapping_large_folio_support(mapping) || !write_end)
-		return 0;
-
-	/* Calculate the write size based on the write_end */
-	size = write_end - (index << PAGE_SHIFT);
-	order = filemap_get_order(size);
-	if (!order)
-		return 0;
-
-	/* If we're not aligned, allocate a smaller folio */
-	if (index & ((1UL << order) - 1))
-		order = __ffs(index);
-
-	order = min_t(size_t, order, MAX_PAGECACHE_ORDER);
-	return order > 0 ? BIT(order + 1) - 1 : 0;
-}
-
 static unsigned int shmem_get_orders_within_size(struct inode *inode,
 		unsigned long within_size_orders, pgoff_t index,
 		loff_t write_end)
@@ -648,22 +612,21 @@ static unsigned int shmem_huge_global_enabled(struct inode *inode, pgoff_t index
 	 * For tmpfs mmap()'s huge order, we still use PMD-sized order to
 	 * allocate huge pages due to lack of a write size hint.
 	 *
-	 * Otherwise, tmpfs will allow getting a highest order hint based on
-	 * the size of write and fallocate paths, then will try each allowable
-	 * huge orders.
+	 * For tmpfs with 'huge=always' or 'huge=within_size' mount option,
+	 * we will always try PMD-sized order first. If that failed, it will
+	 * fall back to small large folios.
 	 */
 	switch (SHMEM_SB(inode->i_sb)->huge) {
 	case SHMEM_HUGE_ALWAYS:
 		if (vma)
 			return maybe_pmd_order;
 
-		return shmem_mapping_size_orders(inode->i_mapping, index, write_end);
+		return THP_ORDERS_ALL_FILE_DEFAULT;
 	case SHMEM_HUGE_WITHIN_SIZE:
 		if (vma)
 			within_size_orders = maybe_pmd_order;
 		else
-			within_size_orders = shmem_mapping_size_orders(inode->i_mapping,
-								       index, write_end);
+			within_size_orders = THP_ORDERS_ALL_FILE_DEFAULT;
 
 		within_size_orders = shmem_get_orders_within_size(inode, within_size_orders,
 								  index, write_end);
-- 
2.43.5


