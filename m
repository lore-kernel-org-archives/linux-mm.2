Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A3C8C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 23:41:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D312E6B00A7; Wed, 22 Jul 2026 19:41:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF7546B00AD; Wed, 22 Jul 2026 19:41:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 912536B00AA; Wed, 22 Jul 2026 19:41:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 490CF6B00AC
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 19:41:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ACE101602D3
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:41:25 +0000 (UTC)
X-FDA: 85018036530.19.455F071
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id A92E1A000F
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:41:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hy7Ze70k;
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784763683;
	b=pA5F8JedjsmORaabqPEEuNQsAWtLdc3pE9v2TMJFBpnHtFh2Ohz1+wB+sPRQQz0N/qokcg
	Sc1AJh3JEM8bKBENPStus2VlJYpdCw1hs/sSm6Msmcyuwd088/U4VLu3qCIPqPxGNtjhVN
	pUVO2IWa6qiLJPGa9eykb0NzXpcTijA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hy7Ze70k;
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784763683;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ff/NBvas2XnMWM+bqq0pnA9Uob9MRX17+eBOkRWJTus=;
	b=GFi/BQDw4YrQd9kbObb75LORyO0L7Yrzf58oECqrsBZP/pXIXKuT70guealcZdDR9U3zDu
	ZSRjLiF/iwwnTCUwC6iA5HeTCRCKYDdySbFgCCMFxEZAcPliGG/rm82+XtL1daRx5NwU9V
	9XaQePRXRnG/PBfLxIHvgnDlOLfVxxo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8AE494513D;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6B6C0C2BCFA;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784763680;
	bh=MilV9fZJGpzCk1sO4io/oFZaBmMxYeYIbPlBrtI2loQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Hy7Ze70keZSOblWcDNHKSB1QMiRhBvw2OW8lMbPuPpfzf/JEFPzupHNDwhMNxd/be
	 vPh+IYCvdEIJHXK6GV52PLXhAOiy7gdRcx3s31KrC/2UAm/InxVPMroJmvP5Adf3we
	 HM2mvn2zXr1aZspnfQxHshSSO21o6LYqy+s8jJZ2I67GF6xMpmHRU7vW5q7uyfMtgZ
	 uTB9EPiiBI7R2cP/RAXHMtWjycx3zc70kT6+Tg3KlsOjGNnuRWzRy+JjXBoAyslaSQ
	 lLCKnkdxwhvuaN9y/w3E0CGS2/q/+5obAGa04+8WOtyIOTbb9SOiUMi5H00BwP81ge
	 T013GpNMF+TqQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 572E6C4453F;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 22 Jul 2026 16:41:17 -0700
Subject: [PATCH v4 09/16] WIP: mm: hugetlb: Move subpool functions to
 hugetlb_subpool.c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-hugetlb-alloc-failure-fixes-v4-9-88e8b81970dc@google.com>
References: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
In-Reply-To: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com, Mike Kravetz <mike.kravetz@oracle.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Alex Shi <alexs@kernel.org>, 
 Yanteng Si <si.yanteng@linux.dev>, Dongliang Mu <dzm91@hust.edu.cn>, 
 Hongxiang Lou <louhongxiang@huawei.com>, Miaohe Lin <linmiaohe@huawei.com>
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784763678; l=12908;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=2bVmicF4jARvFucIodaWUi9UAIbjHPAM78oVUl0zi9M=;
 b=WyTseG1sFPnebaIiiv+7bEgnrhySfmRN5qmhMCio1eCAO5c2bvWJb+tCGB/+zz4bKjC8h+nJE
 hndmaqutKDPBDn/Tx8v4ymim5itrUBAqU935xcjRPsCkCwLmhNDs6lP
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A92E1A000F
X-Stat-Signature: jgfs4q54op693iepa8hwb9agi65s9nzs
X-Rspam-User: 
X-HE-Tag: 1784763683-816995
X-HE-Meta: U2FsdGVkX192Dwfq7cacY6jwJnFiyGRzsb0YiiNZ825ZbWJocRZJnzliqU96olHX8wBYyDEaVEbaNV6CWt+ZbWmvli8QkosovRkLu799yhPGO6vWYgzoaiTWw8dB8nD97SSkJOmY32MUM3kXBjH+LnoA/gBr1UB8NANy3bAf54X5c/4J9k3BIWVoZqVKL7hWeGUBwTQlcuAp9FqgGgMbHfven2N7DuHOAL5vTGMMHNvAe00prh6F7FRo3Ms/dGHdfhyIskysI2yY9spWWWTESUhhuku1FsQ3IH79MGstdOwW2g/IgwWAK0BtX+ou7Nsjr5Qaa3xekBtbaMyewCWZd+gaVmPiVFOfY87tnaSIqArMXTnNFZRBIi+64Suhddu/A7wvt3pEww7HrxO9ivsg+1iWio4R2XirU46JCUGRtHKZjkgiPuLER1AQGgPj2naI+bxt8Jrvh00xbPamtr/mxGk2BEVYV+ygevmXy3DON/rcICc1lnQk5Nd5d2vTFPBPNJilN9iquqbD3KmF8nEBbWMDo78kXmKzcdKi1CJNRSac0+O+EW8swjS4Q3S2XW8ew89CfQ7BDvNXOZYDU+xr88F8l1yu6fNtlIuI0beD5G0tAO1XQkXy5KET+nxk/JL7//iGexmLH9HS7U4ariIDJlQXxJrsKn5ubs6JeNIqhyKBv6h0QXkCXCGX4RO/QgSBP/5WZxdutZm5qkag8O5PeEt8RD59pBre1XT6Ay0lGu/UYp7EBvIv16YXtPw1RvYCk4iPNx7GHgp79As8Ua0HTNwRsHp1/RSmJ4JfEBo573CdJ3+kkyn8gPwjZZvgTf6n/lV42ITOED60ntQ+kZpvU2QQH8aamNHMM8JYkf1djggck050DjdKySA/JkHREgGI0bvckBERrFYM3b6S8XJhuqllXY59Uy5plO1/GFgMXZ+xl3uDZFvbCTOkfFyGL9lLa4PVmpEb2Z+WZHvpyfP
 eDmlv+7A
 RTm4YyOzGihGk3grlUtGiz+5CV1g8/BMGbQwcco5sx30Y6GSgFaZUJlZkVUfLJwmIpFwTv/flleTbz8ni72ZaOtzHpAxN5+tsjlH+VPmca6NrU5azLA70SQ9OFZZV6T+t3pGg/nxnqJBw1xnGVOQf0ktYXdLzbnemmEsBbBUZxgDmijLoU0BlF9eKTuc8CxrsCuHIGmKh2P4q5ydLNGqwukju0dZkiAL+CxBRI4K3lpJ+ajtj88eEamtxSsU8xkV7wBKv33rNjIYzRwpDB1DbZ7FKI556uu9LATsdcrLa0fj3u6+dM80ZJXv6EjKi28HK7PbCKUVZXl7oPRVruckdZW2qycHtsoR0uAOWFmk45vtzlCNvx0dPaiHWocoEwejCt5wq2CghmmpJtmtNfRQkuPFwVfrTPBgePmRi5qDqzEvFgSOWyMZ9eAOaiK+mhPicbzfLU8ldICe7GUmBa9UCeUVtGmwO7gK3BLhRQFcz19pbLeHz44TsIa/1GLghucdOIDhHdqyvZGbYr6wGro/mgD0ZTT7gO2Rrf7o5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Move all HugeTLB subpool lifecycle, page reservation, and accounting
routines out of mm/hugetlb.c and into their own dedicated, encapsulated
translation unit at mm/hugetlb_subpool.c.

Also introduces the internal mm/hugetlb_subpool.h header for holding the
subpool-local APIs, allowing fs/hugetlbfs and mm/ to access the subpool
functions cleanly.  The subpool internal layout structures remain in
include/linux/hugetlb.h until getters are introduced.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 fs/hugetlbfs/inode.c    |   1 +
 include/linux/hugetlb.h |   4 +-
 mm/Makefile             |   2 +-
 mm/hugetlb.c            | 166 +-------------------------------------------
 mm/hugetlb_subpool.c    | 181 ++++++++++++++++++++++++++++++++++++++++++++++++
 mm/hugetlb_subpool.h    |  17 +++++
 6 files changed, 202 insertions(+), 169 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index e5d86f31eba5b..86c21f8272470 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -25,6 +25,7 @@
 #include <linux/ctype.h>
 #include <linux/backing-dev.h>
 #include <linux/hugetlb.h>
+#include "../../mm/hugetlb_subpool.h"
 #include <linux/folio_batch.h>
 #include <linux/fs_parser.h>
 #include <linux/mman.h>
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 34b9a3e1be0fa..f36be371c6e88 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -114,9 +114,7 @@ extern int hugetlb_max_hstate __read_mostly;
 #define for_each_hstate(h) \
 	for ((h) = hstates; (h) < &hstates[hugetlb_max_hstate]; (h)++)
 
-struct hugepage_subpool *hugepage_new_subpool(struct hstate *h, long max_hpages,
-						long min_hpages);
-void hugepage_put_subpool(struct hugepage_subpool *spool);
+int hugetlb_acct_memory(struct hstate *h, long delta);
 
 void hugetlb_dup_vma_private(struct vm_area_struct *vma);
 void clear_vma_resv_huge_pages(struct vm_area_struct *vma);
diff --git a/mm/Makefile b/mm/Makefile
index eff9f9e7e061c..3965c959e5099 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -78,7 +78,7 @@ endif
 obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o
 obj-$(CONFIG_ZSWAP)	+= zswap.o
 obj-$(CONFIG_HAS_DMA)	+= dmapool.o
-obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o hugetlb_sysfs.o hugetlb_sysctl.o
+obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o hugetlb_subpool.o hugetlb_sysfs.o hugetlb_sysctl.o
 ifdef CONFIG_CMA
 obj-$(CONFIG_HUGETLBFS)	+= hugetlb_cma.o
 endif
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 90ec015a11181..4d44a9720a971 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -51,6 +51,7 @@
 #include "hugetlb_vmemmap.h"
 #include "hugetlb_cma.h"
 #include "hugetlb_internal.h"
+#include "hugetlb_subpool.h"
 #include <linux/page-isolation.h>
 
 int hugetlb_max_hstate __read_mostly;
@@ -126,171 +127,6 @@ static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end, bool take_locks);
 static struct resv_map *vma_resv_map(struct vm_area_struct *vma);
 
-static inline bool subpool_is_free(struct hugepage_subpool *spool)
-{
-	if (spool->count)
-		return false;
-
-	return spool->used_hpages == 0;
-}
-
-static inline void unlock_or_release_subpool(struct hugepage_subpool *spool,
-						unsigned long irq_flags)
-{
-	bool is_free = subpool_is_free(spool);
-
-	spin_unlock_irqrestore(&spool->lock, irq_flags);
-
-	if (is_free) {
-		if (spool->min_hpages != -1)
-			hugetlb_acct_memory(spool->hstate,
-						-spool->min_hpages);
-		kfree(spool);
-	}
-}
-
-struct hugepage_subpool *hugepage_new_subpool(struct hstate *h, long max_hpages,
-						long min_hpages)
-{
-	struct hugepage_subpool *spool;
-
-	spool = kzalloc_obj(*spool);
-	if (!spool)
-		return NULL;
-
-	spin_lock_init(&spool->lock);
-	spool->count = 1;
-	spool->max_hpages = max_hpages;
-	spool->hstate = h;
-	spool->min_hpages = min_hpages;
-
-	if (min_hpages != -1 && hugetlb_acct_memory(h, min_hpages)) {
-		kfree(spool);
-		return NULL;
-	}
-	spool->rsv_hpages = min_hpages;
-
-	return spool;
-}
-
-void hugepage_put_subpool(struct hugepage_subpool *spool)
-{
-	unsigned long flags;
-
-	if (!spool)
-		return;
-
-	spin_lock_irqsave(&spool->lock, flags);
-	BUG_ON(!spool->count);
-	spool->count--;
-	unlock_or_release_subpool(spool, flags);
-}
-
-/**
- * hugepage_subpool_get_pages - Get pages from a subpool
- * @spool: pointer to subpool structure (may be NULL)
- * @delta: number of pages to allocate or reserve
- *
- * Check and update subpool page usage counts when allocating or
- * reserving @delta hugepages.
- *
- * Context: Takes spool->lock using spin_lock_irq().
- * Return: Non-negative number of reservations that cannot be
- *         satisfied by the subpool, or -ENOMEM if the subpool maximum
- *         limit would be exceeded.
- */
-static long hugepage_subpool_get_pages(struct hugepage_subpool *spool,
-				      long delta)
-{
-	long ret = delta;
-
-	if (!spool)
-		return ret;
-
-	spin_lock_irq(&spool->lock);
-
-	if (spool->max_hpages != -1 &&
-	    spool->used_hpages + delta > spool->max_hpages) {
-		ret = -ENOMEM;
-		goto unlock_ret;
-	}
-
-	spool->used_hpages += delta;
-
-	/* minimum size accounting */
-	if (spool->min_hpages != -1 && spool->rsv_hpages) {
-		if (delta > spool->rsv_hpages) {
-			/*
-			 * Asking for more reserves than those already taken on
-			 * behalf of subpool.  Return difference.
-			 */
-			ret = delta - spool->rsv_hpages;
-			spool->rsv_hpages = 0;
-		} else {
-			ret = 0;	/* reserves already accounted for */
-			spool->rsv_hpages -= delta;
-		}
-	}
-
-unlock_ret:
-	spin_unlock_irq(&spool->lock);
-	return ret;
-}
-
-/**
- * hugepage_subpool_put_pages - Release pages back to a subpool
- * @spool: pointer to subpool structure (may be NULL)
- * @delta: number of pages to free or unreserve
- *
- * Check and update subpool page usage counts when freeing or
- * unreserving @delta hugepages.
- *
- * Context: Takes spool->lock using spin_lock_irqsave(). May release
- *          and free @spool if its usage count and references reach
- *          zero.
- * Return: Non-negative number of reservations that the subpool cannot
- *         absorb.
- */
-static long hugepage_subpool_put_pages(struct hugepage_subpool *spool,
-				       long delta)
-{
-	long ret = delta;
-	unsigned long flags;
-
-	if (!spool)
-		return delta;
-
-	spin_lock_irqsave(&spool->lock, flags);
-
-	spool->used_hpages -= delta;
-
-	 /* minimum size accounting */
-	if (spool->min_hpages != -1 && spool->used_hpages < spool->min_hpages) {
-		/*
-		 * limit is the maximum number of reservations that
-		 * can be restored to this subpool.
-		 */
-		long limit = spool->min_hpages - spool->used_hpages;
-
-		if (spool->rsv_hpages + delta <= limit)
-			ret = 0;
-		else
-			ret = spool->rsv_hpages + delta - limit;
-
-		spool->rsv_hpages += delta;
-		if (spool->rsv_hpages > limit)
-			spool->rsv_hpages = limit;
-	}
-
-	/*
-	 * If hugetlbfs_put_super couldn't free spool due to an outstanding
-	 * quota reference, free it now.
-	 */
-	unlock_or_release_subpool(spool, flags);
-
-	return ret;
-}
-
 static inline struct hugepage_subpool *subpool_vma(struct vm_area_struct *vma)
 {
 	return subpool_inode(file_inode(vma->vm_file));
diff --git a/mm/hugetlb_subpool.c b/mm/hugetlb_subpool.c
new file mode 100644
index 0000000000000..6184860ed7374
--- /dev/null
+++ b/mm/hugetlb_subpool.c
@@ -0,0 +1,181 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Subpool and reserve accounting for HugeTLB folios.
+ * Extracted from mm/hugetlb.c
+ */
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#ifdef __KERNEL__
+#include <linux/hugetlb.h>
+#endif
+#include <linux/spinlock.h>
+#include <linux/bug.h>
+
+#include "hugetlb_subpool.h"
+
+static inline bool subpool_is_free(struct hugepage_subpool *spool)
+{
+	if (spool->count)
+		return false;
+
+	return spool->used_hpages == 0;
+}
+
+static inline void unlock_or_release_subpool(struct hugepage_subpool *spool,
+						unsigned long irq_flags)
+{
+	bool is_free = subpool_is_free(spool);
+
+	spin_unlock_irqrestore(&spool->lock, irq_flags);
+
+	if (is_free) {
+		if (spool->min_hpages != -1)
+			hugetlb_acct_memory(spool->hstate,
+						-spool->min_hpages);
+		kfree(spool);
+	}
+}
+
+struct hugepage_subpool *hugepage_new_subpool(struct hstate *h, long max_hpages,
+						long min_hpages)
+{
+	struct hugepage_subpool *spool;
+
+	spool = kzalloc_obj(*spool);
+	if (!spool)
+		return NULL;
+
+	spin_lock_init(&spool->lock);
+	spool->count = 1;
+	spool->max_hpages = max_hpages;
+	spool->hstate = h;
+	spool->min_hpages = min_hpages;
+
+	if (min_hpages != -1 && hugetlb_acct_memory(h, min_hpages)) {
+		kfree(spool);
+		return NULL;
+	}
+	spool->rsv_hpages = min_hpages;
+
+	return spool;
+}
+
+void hugepage_put_subpool(struct hugepage_subpool *spool)
+{
+	unsigned long flags;
+
+	if (!spool)
+		return;
+
+	spin_lock_irqsave(&spool->lock, flags);
+	BUG_ON(!spool->count);
+	spool->count--;
+	unlock_or_release_subpool(spool, flags);
+}
+
+/**
+ * hugepage_subpool_get_pages - Get pages from a subpool
+ * @spool: pointer to subpool structure (may be NULL)
+ * @delta: number of pages to allocate or reserve
+ *
+ * Check and update subpool page usage counts when allocating or
+ * reserving @delta hugepages.
+ *
+ * Context: Takes spool->lock using spin_lock_irq().
+ * Return: Non-negative number of reservations that cannot be
+ *         satisfied by the subpool, or -ENOMEM if the subpool maximum
+ *         limit would be exceeded.
+ */
+long hugepage_subpool_get_pages(struct hugepage_subpool *spool,
+				      long delta)
+{
+	long ret = delta;
+
+	if (!spool)
+		return ret;
+
+	spin_lock_irq(&spool->lock);
+
+	if (spool->max_hpages != -1 &&
+	    spool->used_hpages + delta > spool->max_hpages) {
+		ret = -ENOMEM;
+		goto unlock_ret;
+	}
+
+	spool->used_hpages += delta;
+
+	/* minimum size accounting */
+	if (spool->min_hpages != -1 && spool->rsv_hpages) {
+		if (delta > spool->rsv_hpages) {
+			/*
+			 * Asking for more reserves than those already taken on
+			 * behalf of subpool.  Return difference.
+			 */
+			ret = delta - spool->rsv_hpages;
+			spool->rsv_hpages = 0;
+		} else {
+			ret = 0;	/* reserves already accounted for */
+			spool->rsv_hpages -= delta;
+		}
+	}
+
+unlock_ret:
+	spin_unlock_irq(&spool->lock);
+	return ret;
+}
+
+/**
+ * hugepage_subpool_put_pages - Release pages back to a subpool
+ * @spool: pointer to subpool structure (may be NULL)
+ * @delta: number of pages to free or unreserve
+ *
+ * Check and update subpool page usage counts when freeing or
+ * unreserving @delta hugepages.
+ *
+ * Context: Takes spool->lock using spin_lock_irqsave(). May release
+ *          and free @spool if its usage count and references reach
+ *          zero.
+ * Return: Non-negative number of reservations that the subpool cannot
+ *         absorb.
+ */
+long hugepage_subpool_put_pages(struct hugepage_subpool *spool,
+				       long delta)
+{
+	long ret = delta;
+	unsigned long flags;
+
+	if (!spool)
+		return delta;
+
+	spin_lock_irqsave(&spool->lock, flags);
+
+	spool->used_hpages -= delta;
+
+	 /* minimum size accounting */
+	if (spool->min_hpages != -1 && spool->used_hpages < spool->min_hpages) {
+		/*
+		 * limit is the maximum number of reservations that
+		 * can be restored to this subpool.
+		 */
+		long limit = spool->min_hpages - spool->used_hpages;
+
+		if (spool->rsv_hpages + delta <= limit)
+			ret = 0;
+		else
+			ret = spool->rsv_hpages + delta - limit;
+
+		spool->rsv_hpages += delta;
+		if (spool->rsv_hpages > limit)
+			spool->rsv_hpages = limit;
+	}
+
+	/*
+	 * If hugetlbfs_put_super couldn't free spool due to an outstanding
+	 * quota reference, free it now.
+	 */
+	unlock_or_release_subpool(spool, flags);
+
+	return ret;
+}
diff --git a/mm/hugetlb_subpool.h b/mm/hugetlb_subpool.h
new file mode 100644
index 0000000000000..be1f1cf012c9c
--- /dev/null
+++ b/mm/hugetlb_subpool.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _MM_HUGETLB_SUBPOOL_H
+#define _MM_HUGETLB_SUBPOOL_H
+
+#include <linux/spinlock.h>
+#include <linux/types.h>
+
+struct hstate;
+struct hugepage_subpool;
+
+struct hugepage_subpool *hugepage_new_subpool(struct hstate *h, long max_hpages,
+						long min_hpages);
+void hugepage_put_subpool(struct hugepage_subpool *spool);
+long hugepage_subpool_get_pages(struct hugepage_subpool *spool, long delta);
+long hugepage_subpool_put_pages(struct hugepage_subpool *spool, long delta);
+
+#endif /* _MM_HUGETLB_SUBPOOL_H */

-- 
2.55.0.229.g6434b31f56-goog



