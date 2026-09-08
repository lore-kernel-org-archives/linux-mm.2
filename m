Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D30CBC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:57:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAE566B008A; Tue,  8 Sep 2026 08:57:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E83C96B0099; Tue,  8 Sep 2026 08:57:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC2166B00B5; Tue,  8 Sep 2026 08:57:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B7BF16B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:57:31 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 512D9A4FD6
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:57:31 +0000 (UTC)
X-FDA: 85190596302.21.99063D0
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf21.hostedemail.com (Postfix) with ESMTP id C94E41C000C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:57:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=b9+D5S5R;
	spf=pass (imf21.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788872249;
	b=VatXRPSorv9seZTIj29vaJnvhv2nJGuIXcGvz8H9rWAf/aNxENPMQ/8cm+CGZiyj5kbxYA
	NuqGtzdcxdqh+/MiCDO7w7EbCWHhT0IqfWCJS1e0iQafcwhiGFW35BuJFPY7uaKFTSvvX7
	XNSJhkfUuEzjTOQFKVxx2IXST6227YI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=b9+D5S5R;
	spf=pass (imf21.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788872249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SV6xMwmmrZQnCx9dfDDCxRN048EGq4DPyEZOR9zCHZw=;
	b=qaANDvQcI4Y/yoxCAXAqIJMjfM3ERxuOHhvQIye22oSd9wxlBBOvBFORkn+W3s/TC3ar7r
	yBAFkmWj98UTlFtpA5Zw/ncKCN/+KWGq/f3Qz8h5oGl7AFeGwIPOkwff+cLQMWVf5gueGb
	vSFM7FvB+qR7I8iVH2jx8NI6U4Oyjwo=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=SV6xMwmmrZQnCx9dfDDCxRN048EGq4DPyEZOR9zCHZw=;
	b=b9+D5S5ReV4rsu/H1b4TlHTlUdSAhHRIpXducNvYcsxB9zPk9lsQOmO6qFk9evmxV6QtUjx9K
	7SZHCI7sNOXLo1WwwLCHUUPc5FjllQlWsYxII2s5ZYnGeqqm6AWxm499TX5CnB83OT6MCPLoDDp
	wLQQA9LUwMQjB+wavEIBfQg=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hfNwh3DLyzcbMk;
	Tue,  8 Sep 2026 20:46:28 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 62BEA40575;
	Tue,  8 Sep 2026 20:57:25 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 8 Sep
 2026 20:57:24 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
	<lance.yang@linux.dev>, <riel@surriel.com>, <liam@infradead.org>,
	<vbabka@kernel.org>, <harry@kernel.org>, <jannh@google.com>,
	<minchan.kim@gmail.com>, <lwoodman@redhat.com>,
	<kamezawa.hiroyu@jp.fujitsu.com>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH v2] mm/rmap: fix missing barrier between anon_vma init and vma->anon_vma publish
Date: Tue, 8 Sep 2026 20:29:24 +0800
Message-ID: <20260908122924.554373-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C94E41C000C
X-Stat-Signature: paj4t3cfn1b7mj3a8ikn7gfjk6616sta
X-HE-Tag: 1788872248-511299
X-HE-Meta: U2FsdGVkX19vawvZJK9Zr8urHIVuYac4FzUjbyJC5mZktfscjmqloTilRdaZxdQnoj5kg5eYIjdQLVgmZjoHS2Dzf1OM5V26U3DdVL56SC+yMYiCNTLu+hxlVZm3vr/CKw7LtP/6l1eCfJvaXyEGu8Sl7bD5vzve97c2ON2z+lgsY1xW3vbqdGhsYYCMTkmZsj6xqwIMvISPzQ6VZC7fcqny37XvTsAqZwGkh6M7Jb/velUe/hHlONR2bpyaIPaEh2v2OX+iVkTC3xNkrxJnnw4iSRoIHat4E5u7iHnbXMUv2H8z7rewjyNAwQm4lsCUn3RdJ7vB8kTw9PueI5DoRK9St8irlwKm04RaDk1aX0Nd+sYvpX1PTB22L8Dc69010004vjcB+6FNZ/2WP8l7eSsVkgNbOPYo/W3Aqwp0IOVceYeVFP4kpiXvsvBKBoty29e7jPYgTjEGqmMFPLYC7gMW0SuFs4bV1+xlmOEZU4nUHLOP7GJb7lYjDU7c1O1u6tphQZi7hsZGmnxeL7IxpqxUhpIrPfnTYiOe0JlfwVZckPDBdd9VeJrgbZpvj0KcJDrTxVkHWasxLonKXB9ulCjEg627J4ekmHkKpfP3antbZiDcDzsNkfwWtab9Ke+i3U2h+AcvJWnh8bTApOt4HrntXeCrqO5/3iuhDkyh0ImmitqqfAjKgcFm1pg6kcwrTrJ5goigCMuBTywwV6Ux7c6mSgZp3+WFQi/bUjVUaXrXRhFV5HZNcAnIw9NJd/7z0nhkVgHmtnzV/g3AxFPB0rWy2ZVJrlFReIQe2RR3RizYUW63WZGtTfm1i0iPzi4pgzBZNcNTAnh2ejduqBAjHJXNVlQhuyuazI8SEvDkumLxwtCB17ig7jsMhpIyCE6qzgxfQGFM/vRadNgUMFd4mJEG648Az/zVP7OoSKYfDYxLzKyDmpnv0ldO3FoqnC9Dt8rY4pFd3kCcwPS4Tm6
 zrSvS9Zb
 U2Buw/VDBJ4BPBmRQ9N16NCBidti2oawS72GNK2viWgsE23/N7bSx1Iz8jYy0+L/onzwcQ7/4wWs+xLK63Y621cFedd9ygAIX8ZSLiblgHjFOqS66o5RiUSk4x9YlfGubqDGNuVHYvAZyWECzb3lEHQGLmpnCBjzX3v3uFmZW7F2e5dhMFkaDFrW3ZqKYG5k9iHP104dSxFqaIz3QuCXkwdqTa9hitL44f0ctsshF0ZkO564KoaLVgKDpvobZj91eQu/Za56UJxvQl6zjH7SdEjr9TwcA/zJHeJG+FO6gCUJABHuyeBJVOp15f/tGOgQDkjY6h3R20y3HreKp8++kFuj3Yrp+9sDeuoRdQyZ9jWGlnyEGwjbBSjbhvOxcdrHED2VpBdJpuDvmMsVI8B7pHgOyaxBpxFmoF7CZMsEw52J+/0+7oFOzOG5XwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On arm64 server, we find that a task trying to grab the anon_vma lock
triggers hungtask.

INFO: task main:2354726 blocked for more than 120 seconds.
      Tainted: G            E     5.10.0-0021.aarch64 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:main            state:D stack:    0 pid:2354726 ppid:2350673 flags:0x00000a01
Call trace:
 __switch_to+0x7c/0xbc
 __schedule+0x3b4/0x8a0
 schedule+0x50/0xe0
 rwsem_down_write_slowpath+0x3cc/0x6cc
 down_write+0x60/0x260
 __anon_vma_prepare+0x6c/0x210
 do_anonymous_page+0x258/0x660
 handle_pte_fault+0x188/0x214
 __handle_mm_fault+0x1b0/0x380
 handle_mm_fault+0xf4/0x284
 do_page_fault+0x19c/0x494
 do_translation_fault+0xcc/0xf8
 do_mem_abort+0x48/0xac
 el0_da+0x44/0x80
 el0_sync_handler+0x88/0xb4
 el0_sync+0x160/0x180

After analyzing the vmcore, we found the anon_vma->root->rwsem.count is -1.
There is another anon_vma whose anon_vma->root->rwsem.count is 1, the
anon_vma->root->rwsem.owner shows the lock is held, but the stack of the
task shows the task doesn't hold the anon_vma lock.

After adding more debugging info, we found __anon_vma_prepare() reuses
anon_vma and triggers the UAF of anon_vma->root due to missing memory
barrier, leading to locking and unlocking two different anon_vma->root,
thus leading to an anon_vma will never be unlocked, and another anon_vma
couldn't be locked anymore.

This race requires two adjacent VMAs that are not merged but are
anon_vma-compatible (e.g., they differ in VMA_ACCESS_FLAGS that can be
changed by mprotect()). Two threads fault on each VMA concurrently, both
calling __anon_vma_prepare() with only mmap_lock held for reading.

    THREAD A                             THREAD B
__anon_vma_prepare                __anon_vma_prepare
 find_mergeable_anon_vma() -> NULL
 anon_vma = anon_vma_alloc();
   anon_vma->root = anon_vma;
 // the two stores may be reordered
 vma->anon_vma = anon_vma;
                                   // finds A's anon_vma
                                   anon_vma = find_mergeable_anon_vma(vma);
                                   anon_vma_lock_write(anon_vma);
                                     // may still see the old root
                                     down_write(&anon_vma->root->rwsem);
                                   anon_vma_unlock_write(anon_vma);
                                     // see the new root, never unlock old
                                     up_write(&anon_vma->root->rwsem);

thread A triggers page fault and calls __anon_vma_prepare() to prepare
anon_vma for the faulting vma. __anon_vma_prepare() allocates and
initializes a new anon_vma, and then publishes it to the vma with a plain
store. anon_vma_prepare() only requires the mmap_lock to be held for
reading, so two threads can fault on adjacent VMAs at the same time. While
thread A publishes a new anon_vma, thread B could find the anon_vma via
find_mergeable_anon_vma() and then locks anon_vma->root->rwsem.

The store to anon_vma->root in anon_vma_alloc() and the store to
vma->anon_vma can be reordered. The anon_vma_lock_write() and spin_lock()
only provide acquire semantics, which do not prevent prior stores from
being reordered after them. The release semantics of the corresponding
spin_unlock() and anon_vma_unlock_write() come too late, the store to
vma->anon_vma is already published before they take effect. As a result,
thread B can observe the following order:

    vma->anon_vma = anon_vma;
    anon_vma->root = anon_vma;

The anon_vma slab is SLAB_TYPESAFE_BY_RCU, so a newly allocated anon_vma
may reuse memory from a previously freed one. The constructor
(anon_vma_ctor) does not reset anon_vma->root, and __put_anon_vma()
doesn't clear it either, so the old root value persists until
anon_vma_alloc() overwrites it. If that store isn't visible, thread B
reads a root that points to the old anon_vma and locks it.

As a result, thread B can call anon_vma_lock_write() with the old root,
and call anon_vma_unlock_write() with the new root, leading to an anon_vma
will never be unlocked, and another anon_vma couldn't be locked anymore
(its count is dropped from 0 to -1 due to wrong unlock).

To fix it, change the plain store `vma->anon_vma = anon_vma` to store
release, so that the fields of anon_vma are visible before anon_vma is
published to vma->anon_vma.

At read side, the load of anon_vma and anon_vma->root have address
dependency. According to Documentation/memory-barriers.txt and some
investigations, only Alpha needs address-dependency barriers and it has
been handled by READ_ONCE() in reusable_anon_vma().

We reproduced this issue in v5.10 with KSM enabled. The kernel doesn't
merge commit cf7e7a3503df ("mm: prevent KSM from breaking VMA merging for
new VMAs"), so there are many adjacent VMAs that aren't merged but are
compatible for anon_vma.

Without this fix, our production environment could reproduce this issue
about 2-5 times each month. After adding a smp_mb() before
anon_vma_lock_write(anon_vma) in __anon_vma_prepare(), which is different
to this patch, this issue hasn't been reproduced for one month.

Cc: stable@vger.kernel.org
Fixes: 5c341ee1dfc8 ("mm: track the root (oldest) anon_vma")
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
Change since v1:
 * correct the fix tag (Lance Yang)
 * rework commit message and update comment (Lorenzo Stoakes)
 * collect Reviewed-by

 mm/rmap.c | 6 +++++-
 mm/vma.c  | 8 ++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index d1819fd69938..f3b21aaa34ee 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -209,7 +209,11 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 	/* page_table_lock to protect against threads */
 	spin_lock(&mm->page_table_lock);
 	if (likely(!vma->anon_vma)) {
-		vma->anon_vma = anon_vma;
+		/*
+		 * Make anon_vma fields visible before anon_vma is published.
+		 * Paired with an address dependency in reusable_anon_vma().
+		 */
+		smp_store_release(&vma->anon_vma, anon_vma);
 		anon_vma_chain_assign(vma, avc, anon_vma);
 		anon_rmap_tree_insert(avc, anon_vma);
 		anon_vma->num_active_vmas++;
diff --git a/mm/vma.c b/mm/vma.c
index 35e7a64855fa..ec4101250d71 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2094,6 +2094,13 @@ static int anon_vma_compatible(struct vm_area_struct *a, struct vm_area_struct *
  * acceptable for merging, so we can do all of this optimistically. But
  * we do that READ_ONCE() to make sure that we never re-load the pointer.
  *
+ * The READ_ONCE() establishes an address dependency between anon_vma and
+ * any access to its fields, which pairs with the assignment to
+ * vma->anon_vma performed with release semantics in __anon_vma_prepare().
+ *
+ * This is especially important as anon_vma's are SLAB_TYPESAFE_BY_RCU so
+ * accessing an uninitialised anon_vma's fields may result in a UAF.
+ *
  * IOW: that the "list_is_singular()" test on the anon_vma_chain only
  * matters for the 'stable anon_vma' case (ie the thing we want to avoid
  * is to return an anon_vma that is "complex" due to having gone through
@@ -2108,6 +2115,7 @@ static struct anon_vma *reusable_anon_vma(struct vm_area_struct *old,
 					  struct vm_area_struct *b)
 {
 	if (anon_vma_compatible(a, b)) {
+		/* Paired with a memory barrier in __anon_vma_prepare(). */
 		struct anon_vma *anon_vma = READ_ONCE(old->anon_vma);
 
 		if (anon_vma && list_is_singular(&old->anon_vma_chain))
-- 
2.43.0


