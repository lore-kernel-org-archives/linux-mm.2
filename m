Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EF79CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 08:54:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6FE48E0003; Wed,  3 Sep 2025 04:54:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B46DF8E0001; Wed,  3 Sep 2025 04:54:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A84148E0003; Wed,  3 Sep 2025 04:54:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 94A548E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 04:54:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0F534160575
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:54:37 +0000 (UTC)
X-FDA: 83847328194.11.60D3023
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf14.hostedemail.com (Postfix) with ESMTP id 22E43100009
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:54:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="VRr/TdD1";
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756889675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gEHG9nUxE9p+ugJXn8Eg6VJXyeh53liew47f+ZzW61M=;
	b=j3+V6a5eqn5uUyB85uMWFHhWvi4WLhh590xE7GuQoaCBriAu8hFWKZNHnnNJH7ln6qAksC
	dc/PAn1z6feO+fCCbqxJv7BJcUTO/C4SmjKUabogyPXJylaHOg++rjBd3jSRkAQr+pK7BT
	ZJnryrqAAK/nDSLJ5xNNRCnLCA23TYw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="VRr/TdD1";
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756889675; a=rsa-sha256;
	cv=none;
	b=RDCS4KrpfUWKoyG8NOyL/f17o2x3CABHNCJRYnohYFQvjPQVfHBSsUfIhwZup7vb+KlMk6
	6xd6JbQNuibTZA+klf+EdNBSMKX93lMRcZSG/l3y8q9/eZ5M2dKhV/p+Vkg6dnhMx/0TXr
	WcGVm7cecbH8JplnyGg9s5auYkVyLXQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1756889669; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=gEHG9nUxE9p+ugJXn8Eg6VJXyeh53liew47f+ZzW61M=;
	b=VRr/TdD10tkspcHeBZwlXYZGZtcJ7r/beNUy8MclLMf2/fQUdRR5WIJJvk2K5GtiCJ/I9hcS2vGFHlnCeKLgMQW5yLvR45su5ZJh/aLigiR9fuvQUf/iX9/AGZhZURCKe57YncLhURdCZrIHPFUPKv4xAmD2b54rQFmJ5CI1/jg=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WnBDMmT_1756889666 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 03 Sep 2025 16:54:27 +0800
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
Subject: [PATCH] mm: shmem: fix the strategy for the tmpfs 'huge=' options
Date: Wed,  3 Sep 2025 16:54:24 +0800
Message-ID: <10e7ac6cebe6535c137c064d5c5a235643eebb4a.1756888965.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 22E43100009
X-Stat-Signature: hbinr9sspccfi6ghnq1n1z68tnx8rfgd
X-Rspam-User: 
X-HE-Tag: 1756889673-744742
X-HE-Meta: U2FsdGVkX1+wwB+y5UgyBsmCUf8CQ2zHufhT/RjYyOnKIHet0X6o0XLq0kQzuvkxAS48zApYW8RuSD+TzkrYHbSytVVShlTySzZ7oFvG+OQBAjENo1WbQUo5AChOiEPXMFI1KYvauf/1K8bj7WP8q5dMwBoLH1h0Y2KPDFjtF8+21kA0TRiHCzdYi81igSwo2EjEnGfyb+ADXnC1aTAmzQiqGR4rQWm/MulsfRisrc+7MGpgYu6G1f5DxUh7M+QK9mqMojFugd5dhdJex02MxhSdx+ZclRZ+LhbWxYHwBHFiS5KsZJDhdjT6krPUGeAgedFPktw/0pUCWewaSHkZYLqRpJtO06erHJBLQA0sLv2Qbxpxqn6jEy0Uxo9ey3paRKFHkBT5nulvxUDXi31reObNmMvboxNmUjAHqROwB/12VJP6uVQHMfCstnLsW3jgyWW6H57nNFPoiQa3VF+MS12F4HxAxHuxNc85II548K1MUt1120Fl8P0KX6yYu+4oHkkHNdfj4wSlQ1UzHDSTcINOCrogEOwei1+XpGbk9KL8147vhVUyr2NZxTYK7psC31HRwigZw6lLtyJgamsV+/D5fEHtbVGvqEIHfsbZ9Ji3APhe5vErRAv0FY73w9NgD5mm1JuJ6kOCnD9InOm+vfNdE+/e9a4YdVyHdxG2UAIwNR1EoNPr9oQupDPtuwggkDO9U37aw0Wu202YSttJe7VS8KJkttXrGtkn2tbgFA/JI1ReLg6uQnhXKSGnU2gwAltRJX/t32ORvH/bSbD8uEQWKuTLmM6YNuR8ZGQi/EubIw7OXLa5FCrzcW9XtliXhrYwv0AnGOoEfVbykg8C620eUDq1Vbds/ZtlQTMVQDpUq3ue449G/OgSWLgSZ8iF1AlUWW7YdCimVFsI0WvX8Ls4fw9jTpmP1d+BPVDFqdR5uB993nriR2ijMsVrqs+JtkNGm30iy69sP9IByOF
 5S8iMvMn
 IORqX05YRQjblyPtyHbSH3+tS8gzo2QAyPKtUH5zWsAB3z5CGCwxT9wiRJ5cAiaWoMj5ppgS39T8JAsRxRpf76cSQ/86EoQOuHC8nXWy91TLWRR4yfnGf17SaMLnVmwvezZKcqAMiR1+fnuGCym2z2i/ZVkq6epuVHRrx0DSlvNWevBYXmFrWheTpukbcC17kb6y/h0N18ovfR+QopQi6oJ94eBb/olO5wHmhcN6FpJb45H7aD0jxqaqZdKa+O+sbJwH+ePbAR6lwOlOOblUK31ennQ==
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
back to smaller large folios. This approach differs from the strategy for
large folio allocation used by other file systems, however, tmpfs is somewhat
different from other file systems, as quoted from David's opinion:
"
There were opinions in the past that tmpfs should just behave like any other fs,
and I think that's what we tried to satisfy here: use the write size as an
indication.

I assume there will be workloads where either approach will be beneficial. I also
assume that workloads that use ordinary fs'es could benefit from the same strategy
(start with PMD), while others will clearly not.
"

[1] https://lore.kernel.org/lkml/0d734549d5ed073c80b11601da3abdd5223e1889.1753689802.git.baolin.wang@linux.alibaba.com/
Fixes: acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
Changes from RFC:
 - Update the commit message.
---
 Documentation/admin-guide/mm/transhuge.rst |  6 ++-
 mm/shmem.c                                 | 47 +++-------------------
 2 files changed, 10 insertions(+), 43 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index a16a04841b96..1654211cc6cf 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -419,6 +419,8 @@ option: ``huge=``. It can have following values:
 
 always
     Attempt to allocate huge pages every time we need a new page;
+    Always try PMD-sized huge pages first, and fall back to smaller-sized
+    huge pages if the PMD-sized huge page allocation fails;
 
 never
     Do not allocate huge pages. Note that ``madvise(..., MADV_COLLAPSE)``
@@ -426,7 +428,9 @@ never
     is specified everywhere;
 
 within_size
-    Only allocate huge page if it will be fully within i_size.
+    Only allocate huge page if it will be fully within i_size;
+    Always try PMD-sized huge pages first, and fall back to smaller-sized
+    huge pages if the PMD-sized huge page allocation fails;
     Also respect madvise() hints;
 
 advise
diff --git a/mm/shmem.c b/mm/shmem.c
index 640fecc42f60..85a40a5b3f2b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -573,42 +573,6 @@ static int shmem_confirm_swap(struct address_space *mapping, pgoff_t index,
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
@@ -655,22 +619,21 @@ static unsigned int shmem_huge_global_enabled(struct inode *inode, pgoff_t index
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
2.43.7


