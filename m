Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50185CA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 11:46:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE7D58E0047; Thu, 21 Aug 2025 07:46:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C97C88E002F; Thu, 21 Aug 2025 07:46:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAE468E0047; Thu, 21 Aug 2025 07:46:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A9B1D8E002F
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 07:46:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6B511117646
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:46:52 +0000 (UTC)
X-FDA: 83800587864.03.A725752
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf10.hostedemail.com (Postfix) with ESMTP id 22130C000A
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:46:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kUCDk1TB;
	spf=none (imf10.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 192.198.163.17) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755776810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c7xwARuY7z3dsPeNL3t1xTitwA4x4+5rDvbFkCtofXU=;
	b=ZuDAMaq5gDMbwHhI1QW882HmusIRVaMaOldIFGPIj/JPEmRbBxxeNAhdSTRaeYfAO0dIl1
	POEAzc6a5RyfnmKvKZ0fXsLBVS577858jkeOLvbibQEf6egJpaHKVbByiPkUyFoSj7fzZf
	WFuv3L4bk/EtQJpQNahvrDz4KivKfLA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kUCDk1TB;
	spf=none (imf10.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 192.198.163.17) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755776810; a=rsa-sha256;
	cv=none;
	b=8LCD6hWVyuRfhDUiWzx+ebI6RqTykgLFQTBQ+WCRVfD3hTB4HxMFo+6kKSXUabjcdvSqEh
	O5SjXm+7XRtGq7e4XzGgKj+jGetnIChSqvdbd+W1ZzBgaeeXfcdtERpVVeWgl8tvtTMrbw
	Kw/K2G88vHRTKlW7tpgQtx71IFh9b4A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755776810; x=1787312810;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ul9zx6zgdYUSqlYBtzIUybb4bVdjZ5vOSGPRmGr83Q0=;
  b=kUCDk1TBTUT2QTNqdd55ZvQ8gWH7rljEUhAMV9upLPYiZ//cA6FBTv0o
   jxyB4/xcKQTGGrLcbPK+hSxWmCo/efQszUhNbFKvG8H0UJEPMFTH5aJme
   ukJ+nT7xpcgISJoYPt/6LHuajQa3M3NdSsXlLbbhWu5XwaR5Hm0n6yc+i
   AlaRw3T3Wt+ZpVW3/IR4uiixOK4fvtjj04E3XNqPKPVdGnI14g3PHnVWc
   bAUvS70GWZOpUG048UMNBydtuyUgBZ4EHv0khct946Ii8YMTtD1hosZAe
   dPUbG4HSEfnkKYbQUQEocHSSM6Stt2d0M3LEIKjCVIz2dr6W9vX59whcn
   Q==;
X-CSE-ConnectionGUID: sa+4RIO9QaCoMJjVgbqsiQ==
X-CSE-MsgGUID: 3kqZbf96SQ6YCPK8yUfrSQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="57989440"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="57989440"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 04:46:49 -0700
X-CSE-ConnectionGUID: zuMx8QyhR1eNklrQdYSkXA==
X-CSE-MsgGUID: QE3AVlLpR16TWlYwIvGUvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="172613627"
Received: from johunt-mobl9.ger.corp.intel.com (HELO fedora) ([10.245.245.201])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 04:46:46 -0700
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
Subject: [PATCH 1/6] mm/mmu_notifier: Allow two-pass struct mmu_interval_notifiers
Date: Thu, 21 Aug 2025 13:46:21 +0200
Message-ID: <20250821114626.89818-2-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821114626.89818-1-thomas.hellstrom@linux.intel.com>
References: <20250821114626.89818-1-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j99w1gkkc5paephs8u7zcbh9z4eyg3uk
X-Rspam-User: 
X-Rspamd-Queue-Id: 22130C000A
X-Rspamd-Server: rspam05
X-HE-Tag: 1755776809-632173
X-HE-Meta: U2FsdGVkX1+RSWIAzkImBBxyhXu4RgUB9My/7Kflh8VSN9lWpL3OeSzbkUU1t+mByyz776hzryVpW4hjFEMJ9RBLWJHnquDy1Op4BHRQpgJ9ehdwksq6s9WeD8QE2ukD/Y2PCqgXbzp2jRK9/0jxZ/zVIdQAdxd/sWhObalNwaki/c5d568fl4FDRbC8b4/KwEqA87BNfeC7Jvr6DeSriT+zry+i/K4CymAA87wl6cXnurYEI+LXnjvBi9L9n5Y+juylNWVxiFsL8XNKkzLb8xKoGa4FEiT95xo5nvqaUZE4BEbdPKB62hk5hBmqUAEptSDZcSs82pxRcpoxyKysz421gniXLx8qMyit7iP8eLXjenJpuQOUULicDtktjrvHrhYuUwz8aivObeVM5XfFu7bpsaRum1OqiRfJFgywvR+5XLH+mCVJDSrhnNSOpNp2EEZ4TqDvrustxowOFbMw+9jh+lIC/k/4+S4dYMDEgjqdlzZaJ43eoAiAIbMqKnMBw7cM4uY9p0BFDHkeZfoEIXukWtSRn6wW2Miqxi3F4EVDqc7Dmx9X0xH7KovsKgvO0OMTXOiXavsSqBhpjTFel9Vj+d+YahCaO3IDEkAjTB3Ss82lk1CV6dHXD5NFCCsJT+MgsatOFOp6aXPgDmXowsp4hDB9Q95WVZIlf0neu8OxjF1oDxhmWhrp137SDkHF0viB7x3EkxuEgySoHOqzpS9yhLYRxpHouPRo6GGXuQmZW9gnkORFsYkbWhXOC4o4C/moCnEdZ+kb7VMtZL8/YX9+krPkF8B1l57mrkgU5C7pOXGaXgRLXkI3z1yZzY1rVx/SpRPpxHiPQ9m+5M7fqVLwn/gboTuCPJQyycbSvWzp94d/26bfvb2YikjKmbSN/WfGQGN49Tcs6PLa9HG8G+/pciqIHPGGO6Ad6Z0zFJjlK/11wYuxfx9HrllZHHwzI1P1/JtIquInlBDTPVQ
 goe93R0P
 Lk3DhkCWP7k9hl6F0iIYfKzV8E/KnHdfHoHttVUlEIz4cdAJFOqnvKln5N/mTaV4tQLDFEzg4kdw98OBx2ibCI7WXLaiTKvgU//HSk12rE1uo/khlmNH1VKg8VNwKM+od31NEBvTix47G1Xjl9uFydTxI0HJhVKzfvMrcQaK4VuwiPlOQcMTQmHJSb1rUDDM2vt3n6LfU1CY5lsyExgBwhWLIz2wMiaoM7yAMCfoa7c2gB547crokbh3bruidsM9rsLvnMXoWTOIjFLGD3eaAuaTz7Cdqr2W8alHY6tuNUg7vaDEjQEOIwoexULdeolGJ5Xs8KcFiVR9fQqHeo6l2zoxvkSiorbVncl7yoHT2vpNKngpzLH9CouFiOFaA2HHUxA+euXBAOp5jx0bSBqoHOVtnLsKRbQQd7CV8TjTRyGbYWZoWGBd8BFPyKZix0XZDYZiiuRlLOozCLMK6cUF+w4RsjCh3fsbgs0dUl8AyTvZVWOQtqHfOuF5BwxXK/nhlmCJZXLcfl6U7eTt680BIwRKZpQFVpZfRYhjLfz++CNZ3m9rQ9+0OYYEl9c7qWlEHhijc+s6r+xjq889nZGf0T6GNKzQ7xBPaTgO1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Simona Vetter <simona.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: <dri-devel@lists.freedesktop.org>
Cc: <linux-mm@kvack.org>
Cc: <linux-kernel@vger.kernel.org>

Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
---
 include/linux/mmu_notifier.h | 42 ++++++++++++++++++++++++
 mm/mmu_notifier.c            | 63 ++++++++++++++++++++++++++++++------
 2 files changed, 96 insertions(+), 9 deletions(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index d1094c2d5fb6..14cfb3735699 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -233,16 +233,58 @@ struct mmu_notifier {
 	unsigned int users;
 };
 
+/**
+ * struct mmu_interval_notifier_finish - mmu_interval_notifier two-pass abstraction
+ * @link: List link for the notifiers pending pass list
+ *
+ * Allocate, typically using GFP_NOWAIT in the interval notifier's first pass.
+ * If allocation fails (which is not unlikely under memory pressure), fall back
+ * to single-pass operation. Note that with a large number of notifiers
+ * implementing two passes, allocation with GFP_NOWAIT will become increasingly
+ * likely to fail, so consider implementing a small pool instead of using
+ * kmalloc() allocations.
+ *
+ * If the implementation needs to pass data between the two passes,
+ * the recommended way is to embed strct mmu_interval_notifier_finish into a larger
+ * structure that also contains the data needed to be shared. Keep in mind that
+ * a notifier callback can be invoked in parallel, and each invocation needs its
+ * own struct mmu_interval_notifier_finish.
+ */
+struct mmu_interval_notifier_finish {
+	struct list_head link;
+	/**
+	 * @finish: Driver callback for the finish pass.
+	 * @final: Pointer to the mmu_interval_notifier_finish structure.
+	 * @range: The mmu_notifier_range.
+	 * @cur_seq: The current sequence set by the first pass.
+	 *
+	 * Note that there is no error reporting for additional passes.
+	 */
+	void (*finish)(struct mmu_interval_notifier_finish *final,
+		       const struct mmu_notifier_range *range,
+		       unsigned long cur_seq);
+};
+
 /**
  * struct mmu_interval_notifier_ops
  * @invalidate: Upon return the caller must stop using any SPTEs within this
  *              range. This function can sleep. Return false only if sleeping
  *              was required but mmu_notifier_range_blockable(range) is false.
+ * @invalidate_start: Similar to @invalidate, but intended for two-pass notifier
+ *                    callbacks where the callto @invalidate_start is the first
+ *                    pass and any struct mmu_interval_notifier_finish pointer
+ *                    returned in the @fini parameter describes the final pass.
+ *                    If @fini is %NULL on return, then no final pass will be
+ *                    called.
  */
 struct mmu_interval_notifier_ops {
 	bool (*invalidate)(struct mmu_interval_notifier *interval_sub,
 			   const struct mmu_notifier_range *range,
 			   unsigned long cur_seq);
+	bool (*invalidate_start)(struct mmu_interval_notifier *interval_sub,
+				 const struct mmu_notifier_range *range,
+				 unsigned long cur_seq,
+				 struct mmu_interval_notifier_finish **final);
 };
 
 struct mmu_interval_notifier {
diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index 8e0125dc0522..fceadcd8ca24 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -260,6 +260,18 @@ mmu_interval_read_begin(struct mmu_interval_notifier *interval_sub)
 }
 EXPORT_SYMBOL_GPL(mmu_interval_read_begin);
 
+static void mn_itree_final_pass(struct list_head *final_passes,
+				const struct mmu_notifier_range *range,
+				unsigned long cur_seq)
+{
+	struct mmu_interval_notifier_finish *f, *next;
+
+	list_for_each_entry_safe(f, next, final_passes, link) {
+		list_del(&f->link);
+		f->finish(f, range, cur_seq);
+	}
+}
+
 static void mn_itree_release(struct mmu_notifier_subscriptions *subscriptions,
 			     struct mm_struct *mm)
 {
@@ -271,6 +283,7 @@ static void mn_itree_release(struct mmu_notifier_subscriptions *subscriptions,
 		.end = ULONG_MAX,
 	};
 	struct mmu_interval_notifier *interval_sub;
+	LIST_HEAD(final_passes);
 	unsigned long cur_seq;
 	bool ret;
 
@@ -278,11 +291,25 @@ static void mn_itree_release(struct mmu_notifier_subscriptions *subscriptions,
 		     mn_itree_inv_start_range(subscriptions, &range, &cur_seq);
 	     interval_sub;
 	     interval_sub = mn_itree_inv_next(interval_sub, &range)) {
-		ret = interval_sub->ops->invalidate(interval_sub, &range,
-						    cur_seq);
+		if (interval_sub->ops->invalidate_start) {
+			struct mmu_interval_notifier_finish *final = NULL;
+
+			ret = interval_sub->ops->invalidate_start(interval_sub,
+								  &range,
+								  cur_seq,
+								  &final);
+			if (ret && final)
+				list_add_tail(&final->link, &final_passes);
+
+		} else {
+			ret = interval_sub->ops->invalidate(interval_sub,
+							    &range,
+							    cur_seq);
+		}
 		WARN_ON(!ret);
 	}
 
+	mn_itree_final_pass(&final_passes, &range, cur_seq);
 	mn_itree_inv_end(subscriptions);
 }
 
@@ -430,7 +457,9 @@ static int mn_itree_invalidate(struct mmu_notifier_subscriptions *subscriptions,
 			       const struct mmu_notifier_range *range)
 {
 	struct mmu_interval_notifier *interval_sub;
+	LIST_HEAD(final_passes);
 	unsigned long cur_seq;
+	int err = 0;
 
 	for (interval_sub =
 		     mn_itree_inv_start_range(subscriptions, range, &cur_seq);
@@ -438,23 +467,39 @@ static int mn_itree_invalidate(struct mmu_notifier_subscriptions *subscriptions,
 	     interval_sub = mn_itree_inv_next(interval_sub, range)) {
 		bool ret;
 
-		ret = interval_sub->ops->invalidate(interval_sub, range,
-						    cur_seq);
+		if (interval_sub->ops->invalidate_start) {
+			struct mmu_interval_notifier_finish *final = NULL;
+
+			ret = interval_sub->ops->invalidate_start(interval_sub,
+								  range,
+								  cur_seq,
+								  &final);
+			if (ret && final)
+				list_add_tail(&final->link, &final_passes);
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
+	mn_itree_final_pass(&final_passes, range, cur_seq);
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
-- 
2.50.1


