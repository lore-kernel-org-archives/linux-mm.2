Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28C30EC1449
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 13:35:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D28B56B0195; Tue,  3 Mar 2026 08:35:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFCD66B0196; Tue,  3 Mar 2026 08:35:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C492A6B0197; Tue,  3 Mar 2026 08:35:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B52466B0195
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:35:00 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 83442B6A2D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 13:35:00 +0000 (UTC)
X-FDA: 84504847560.26.BC8A6D0
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8495C1A0013
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 13:34:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Q8GE5Aw3;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772544891; x=1804080891;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YYM77PWEsZvPf9BMtWUsHxAlnv4gCoCbFenb5zHX8Es=;
  b=Q8GE5Aw3C68folwpDPcmK0VaECCOouJrwiWuwDDafmkrze5F0xINPzh5
   eMYIT/1md5jgFr9MNhCfeXY62a04Ieyv+ckvd9IHcXJLyauonK3Cfyt38
   JrlIRYKmU3TF+U48vDqJeNwXEMOxgyIEVqtM76vvkxM4kEikrnsv6waw5
   +OIiTHu1JDEBzyWdjDN8GZJFBM/91+sYKiabqIdlnjozZC0V6lQDmzZy4
   FxD0VGkottv3NW97VFiaGGwFLhIrw0ImHrV6UOURx5B6aSQ9eehQE5oRO
   N3oPd2CK0z0RNWGWLunrSIng8nSQD3OtSPolspm/BCApcg8/oy9KNo6XV
   Q==;
X-CSE-ConnectionGUID: ZbEUBoJRTO6AiOWH7irAoQ==
X-CSE-MsgGUID: EmPk/FrXRcmDMiP0aNpIvA==
X-IronPort-AV: E=McAfee;i="6800,10657,11718"; a="76179726"
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="76179726"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 05:34:46 -0800
X-CSE-ConnectionGUID: 74z5+D3oTEKuhONNOtvVIA==
X-CSE-MsgGUID: i5vZ0K2jRViYn8lB0SnNTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="217947917"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO fedora) ([10.245.244.243])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 05:34:43 -0800
From: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
To: intel-xe@lists.freedesktop.org
Cc: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Dave Airlie <airlied@gmail.com>,
	Alistair Popple <apopple@nvidia.com>,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH v3 1/4] mm/mmu_notifier: Allow two-pass struct mmu_interval_notifiers
Date: Tue,  3 Mar 2026 14:34:06 +0100
Message-ID: <20260303133409.11609-2-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260303133409.11609-1-thomas.hellstrom@linux.intel.com>
References: <20260303133409.11609-1-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8495C1A0013
X-Stat-Signature: pj3dntym1o4semsidtogbkg1qr9epmo1
X-Rspam-User: 
X-HE-Tag: 1772544890-333280
X-HE-Meta: U2FsdGVkX1+O8WAVzvNagyFTmdxCiAXiTcVePXgfVxkSrd9ayVGF8D74MUKuVZCH3wStVVsZxlQ9uBH0Fphiz6ySYMXF/JSom8U7cxrCESnFifVva8GFWx9Ds/bXDyaRsWxl/NtcNmj3iS7T31hFx1gNWZY9j8GBsrT2QxXX7Bv1KO9peVnRij0VPEAxndTfCJYVsETGzyLj8OGgQUmUUMdhv0yBGRWhcZLfc3TGO7NZcH14J2gnkx2pFnp5aiBsLbdy9zDrFNe3sSlrg9qNY+EA6GgQNGf0QavEnFr9jP2Ym9KWiskntxQnAwRU3jwwBzPE2sRKMxGcXVmSz8XLprQEd/86XzQ/IAyT72xxQYN2QRHHdlJcP5b86f1uLoJl+qblM3dWHgtlvLfo1DmqsrcGeX87Qh7SfU+a5cBRbkZDmhbv0BkIDsErQjnGKQUMNTVT5zhNSnO4tEZ6rfUFm/0U9S3ZC00aKY0XPsu+pHrwyBvGdvvg1uwPc27z3OnCPYMiJYYqaTr2v2HiSi5JwuVMmRMrRYAfIcpVBjENuIjjCl94Q9kfrzgPnaBUOhYTkrkNqHdj+4oxTTz3dlF+u7Ky4u1G4zC+4GbbJb3Q+P0kOYMJ9ouIeObCPIOxtzvlMTmY7wlEdAgxXujPgZC1bn2B/VhFkUd3emvbIaim7Wuta0aE43qEulP2cZksCzP8hLZSH0XU2w6LpBHmgKac0hq3bqrn++olms3H8V7Syiv/i3RuyJnPSeVCqXmDofazpoSvsYmtrXAdHRUtTIWm+dduGRavDQBKtXzeA57aZyoQxJNdlQ/ZXEFmNA+UVmFuZgYLRgnm/qXylLmlJe844QrOGyRBC12EH/kVJzVruugZLUffeORLEXhfr6lTCgLcAUbJ3B6b6xuqu0sLD8GHhXC4mtbchx21GnYzg/+0imcfXtYQa5VZrusGE/p0StHM5t07H+QnP1CAVjz3O/8
 Mmub0I3F
 iYQm7Gk7tvSa7a4kYbxeOQyO25a/ZLdKBrGSHYQJ28BAxkGE7w8j7urT1WGnA+WhDpZH0zcpXDHdBuTUrF1sFuVKMWBvWKOEKfHB96UUP2xhNUb3vkqw/H/Mv0gMwf29SH5CEXeIc6BwJZHeZro4f1VmhkvIwu5wYV+MLBguCdfFcQTTXu9CAgkOv0psDFJMwfOnVscOdoxhtDsg+F0j27xum1+eeEw9WxKX6uDIqsaht/TtyXgNjWGSU8Hbn3m0cL4T5UeSbHVqX3hDoHaHaQ3GiHoROKdccBXDhXzVVeOI++37VDFO46MHvbFj+jl++Oy+PMXxKcHJ0S9PkxbZzQRFhuNIyhU2Kvvr/iKuIweSr+KGlErsQZ/18udnkbwry6ilsDDhtVv4r8/9PNo0xgWBj79q8ZezWSqruO9Hcqg+8uP5Zho37hQ6yy9i+X5XU4mn1lAGtJLEl40dN76VGVGetQdfz7vxVfh6JMJNw6cOMAubW1i5I342lyFkS3wIjsycUm+QQBqgsrreMh0EPUqAjCtubV/OMH1Xg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

GPU use-cases for mmu_interval_notifiers with hmm often involve
starting a gpu operation and then waiting for it to complete.
These operations are typically context preemption or TLB flushing.

With single-pass notifiers per GPU this doesn't scale in
multi-gpu scenarios. In those scenarios we'd want to first start
preemption- or TLB flushing on all GPUs and as a second pass wait
for them to complete.

One can do this on per-driver basis multiplexing per-driver
notifiers but that would mean sharing the notifier "user" lock
across all GPUs and that doesn't scale well either, so adding support
for multi-pass in the core appears to be the right choice.

Implement two-pass capability in the mmu_interval_notifier. Use a
linked list for the final passes to minimize the impact for
use-cases that don't need the multi-pass functionality by avoiding
a second interval tree walk, and to be able to easily pass data
between the two passes.

v1:
- Restrict to two passes (Jason Gunthorpe)
- Improve on documentation (Jason Gunthorpe)
- Improve on function naming (Alistair Popple)
v2:
- Include the invalidate_finish() callback in the
  struct mmu_interval_notifier_ops.
- Update documentation (GitHub Copilot:claude-sonnet-4.6)
- Use lockless list for list management.
v3:
- Update kerneldoc for the struct mmu_interval_notifier_finish::list member
  (Matthew Brost)
- Add a WARN_ON_ONCE() checking for NULL invalidate_finish() op if
  if invalidate_start() is non-NULL. (Matthew Brost)

Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Simona Vetter <simona.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: <dri-devel@lists.freedesktop.org>
Cc: <linux-mm@kvack.org>
Cc: <linux-kernel@vger.kernel.org>

Assisted-by: GitHub Copilot:claude-sonnet-4.6 # Documentation only.
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
---
 include/linux/mmu_notifier.h | 38 +++++++++++++++++++++
 mm/mmu_notifier.c            | 65 +++++++++++++++++++++++++++++++-----
 2 files changed, 94 insertions(+), 9 deletions(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index 07a2bbaf86e9..37b683163235 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -233,16 +233,54 @@ struct mmu_notifier {
 	unsigned int users;
 };
 
+/**
+ * struct mmu_interval_notifier_finish - mmu_interval_notifier two-pass abstraction
+ * @link: Lockless list link for the notifiers pending pass list
+ * @notifier: The mmu_interval_notifier for which the finish pass is called.
+ *
+ * Allocate, typically using GFP_NOWAIT in the interval notifier's first pass.
+ * If allocation fails (which is not unlikely under memory pressure), fall back
+ * to single-pass operation. Note that with a large number of notifiers
+ * implementing two passes, allocation with GFP_NOWAIT will become increasingly
+ * likely to fail, so consider implementing a small pool instead of using
+ * kmalloc() allocations.
+ *
+ * If the implementation needs to pass data between the two passes,
+ * the recommended way is to embed struct mmu_interval_notifier_finish into a larger
+ * structure that also contains the data needed to be shared. Keep in mind that
+ * a notifier callback can be invoked in parallel, and each invocation needs its
+ * own struct mmu_interval_notifier_finish.
+ */
+struct mmu_interval_notifier_finish {
+	struct llist_node link;
+	struct mmu_interval_notifier *notifier;
+};
+
 /**
  * struct mmu_interval_notifier_ops
  * @invalidate: Upon return the caller must stop using any SPTEs within this
  *              range. This function can sleep. Return false only if sleeping
  *              was required but mmu_notifier_range_blockable(range) is false.
+ * @invalidate_start: Similar to @invalidate, but intended for two-pass notifier
+ *                    callbacks where the call to @invalidate_start is the first
+ *                    pass and any struct mmu_interval_notifier_finish pointer
+ *                    returned in the @finish parameter describes the final pass.
+ *                    If @finish is %NULL on return, then no final pass will be
+ *                    called.
+ * @invalidate_finish: Called as the second pass for any notifier that returned
+ *                     a non-NULL @finish from @invalidate_start. The @finish
+ *                     pointer passed here is the same one returned by
+ *                     @invalidate_start.
  */
 struct mmu_interval_notifier_ops {
 	bool (*invalidate)(struct mmu_interval_notifier *interval_sub,
 			   const struct mmu_notifier_range *range,
 			   unsigned long cur_seq);
+	bool (*invalidate_start)(struct mmu_interval_notifier *interval_sub,
+				 const struct mmu_notifier_range *range,
+				 unsigned long cur_seq,
+				 struct mmu_interval_notifier_finish **finish);
+	void (*invalidate_finish)(struct mmu_interval_notifier_finish *finish);
 };
 
 struct mmu_interval_notifier {
diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index a6cdf3674bdc..4d8a64ce8eda 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -260,6 +260,15 @@ mmu_interval_read_begin(struct mmu_interval_notifier *interval_sub)
 }
 EXPORT_SYMBOL_GPL(mmu_interval_read_begin);
 
+static void mn_itree_finish_pass(struct llist_head *finish_passes)
+{
+	struct llist_node *first = llist_reverse_order(__llist_del_all(finish_passes));
+	struct mmu_interval_notifier_finish *f, *next;
+
+	llist_for_each_entry_safe(f, next, first, link)
+		f->notifier->ops->invalidate_finish(f);
+}
+
 static void mn_itree_release(struct mmu_notifier_subscriptions *subscriptions,
 			     struct mm_struct *mm)
 {
@@ -271,6 +280,7 @@ static void mn_itree_release(struct mmu_notifier_subscriptions *subscriptions,
 		.end = ULONG_MAX,
 	};
 	struct mmu_interval_notifier *interval_sub;
+	LLIST_HEAD(finish_passes);
 	unsigned long cur_seq;
 	bool ret;
 
@@ -278,11 +288,27 @@ static void mn_itree_release(struct mmu_notifier_subscriptions *subscriptions,
 		     mn_itree_inv_start_range(subscriptions, &range, &cur_seq);
 	     interval_sub;
 	     interval_sub = mn_itree_inv_next(interval_sub, &range)) {
-		ret = interval_sub->ops->invalidate(interval_sub, &range,
-						    cur_seq);
+		if (interval_sub->ops->invalidate_start) {
+			struct mmu_interval_notifier_finish *finish = NULL;
+
+			ret = interval_sub->ops->invalidate_start(interval_sub,
+								  &range,
+								  cur_seq,
+								  &finish);
+			if (ret && finish) {
+				finish->notifier = interval_sub;
+				__llist_add(&finish->link, &finish_passes);
+			}
+
+		} else {
+			ret = interval_sub->ops->invalidate(interval_sub,
+							    &range,
+							    cur_seq);
+		}
 		WARN_ON(!ret);
 	}
 
+	mn_itree_finish_pass(&finish_passes);
 	mn_itree_inv_end(subscriptions);
 }
 
@@ -430,7 +456,9 @@ static int mn_itree_invalidate(struct mmu_notifier_subscriptions *subscriptions,
 			       const struct mmu_notifier_range *range)
 {
 	struct mmu_interval_notifier *interval_sub;
+	LLIST_HEAD(finish_passes);
 	unsigned long cur_seq;
+	int err = 0;
 
 	for (interval_sub =
 		     mn_itree_inv_start_range(subscriptions, range, &cur_seq);
@@ -438,23 +466,41 @@ static int mn_itree_invalidate(struct mmu_notifier_subscriptions *subscriptions,
 	     interval_sub = mn_itree_inv_next(interval_sub, range)) {
 		bool ret;
 
-		ret = interval_sub->ops->invalidate(interval_sub, range,
-						    cur_seq);
+		if (interval_sub->ops->invalidate_start) {
+			struct mmu_interval_notifier_finish *finish = NULL;
+
+			ret = interval_sub->ops->invalidate_start(interval_sub,
+								  range,
+								  cur_seq,
+								  &finish);
+			if (ret && finish) {
+				finish->notifier = interval_sub;
+				__llist_add(&finish->link, &finish_passes);
+			}
+
+		} else {
+			ret = interval_sub->ops->invalidate(interval_sub,
+							    range,
+							    cur_seq);
+		}
 		if (!ret) {
 			if (WARN_ON(mmu_notifier_range_blockable(range)))
 				continue;
-			goto out_would_block;
+			err = -EAGAIN;
+			break;
 		}
 	}
-	return 0;
 
-out_would_block:
+	mn_itree_finish_pass(&finish_passes);
+
 	/*
 	 * On -EAGAIN the non-blocking caller is not allowed to call
 	 * invalidate_range_end()
 	 */
-	mn_itree_inv_end(subscriptions);
-	return -EAGAIN;
+	if (err)
+		mn_itree_inv_end(subscriptions);
+
+	return err;
 }
 
 static int mn_hlist_invalidate_range_start(
@@ -976,6 +1022,7 @@ int mmu_interval_notifier_insert(struct mmu_interval_notifier *interval_sub,
 	struct mmu_notifier_subscriptions *subscriptions;
 	int ret;
 
+	WARN_ON_ONCE(ops->invalidate_start && !ops->invalidate_finish);
 	might_lock(&mm->mmap_lock);
 
 	subscriptions = smp_load_acquire(&mm->notifier_subscriptions);
-- 
2.53.0


