Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4886BF30924
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 09:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2A2A6B0092; Thu,  5 Mar 2026 04:39:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD85A6B0093; Thu,  5 Mar 2026 04:39:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D9FC6B0095; Thu,  5 Mar 2026 04:39:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 910156B0092
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 04:39:52 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 243198C6AF
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:39:52 +0000 (UTC)
X-FDA: 84511512624.30.28523F5
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf27.hostedemail.com (Postfix) with ESMTP id D038D40004
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:39:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PSocFVS8;
	spf=pass (imf27.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772703590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0/TpceiNX+u/GIhvybfnutzsa7AEQ491tu+4e00K93Q=;
	b=TddrIrXYz7NTfBJY//hzOcYEZDTNS2OIOdOx1B5bvk0B2iz/dZaVJQSYhM9GAo/e+WCdfI
	8HquP6ELtsZMCWZ1vYhAjLaMoQXefb89a/HbPDqkQcZa6/bWW2XOrkSg/NRurxv07ys4pb
	n+yH3ACKw2OWvO1HJz1sI6SI6euzxGc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PSocFVS8;
	spf=pass (imf27.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772703590; a=rsa-sha256;
	cv=none;
	b=vifcg1TSsuDLWgbEMOQCPV3vPZ8PBFSMbDqQSKu+7miLsyJJ4S1L49JCbbm1ZycJR27nP/
	YtPsbihig2+yJbSCB4KZvsSoAK11yhkphTvEkTVFg1QhqDXiu5dKgoOVqdrBn8gAp82MKY
	CP17scsycrb9/4H5+Et4aCmchOOy++s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772703590; x=1804239590;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=P1HvCqMdm4NZrhz2qfIQ6WDOE/LToL9MrwGTxNicvOI=;
  b=PSocFVS8uzNRpjTsXiIiv7Wgv7Bpac/ZcUAqgV+za2rvaJZ/oTcLw+cI
   ilrb3lnLNI6EF8Gsb6D7KyzinDFRWah4cyyHbiZWa/1xxXCHY0lKwFdGs
   1UicSzh9DH3qSlZovhGjE/iKC8XZXF9besL53vCWcivGiEO6JBHoYA1eq
   haBtyEei7LMHXpVPWRXYVad65tekRl1am/dfd79djAwaWJG5cF23O9Dtb
   HRKsBZxxE2IHo+NKJ7yXAvHt+8mJlv62vmc6Nl+HeYIoIt36PeHZoAgTG
   KAT6ZLpZjBgW01wF5S/B0oXU5hE4HOy3ZJ/Q1V3PUkVE3ERKoc4BQmPFZ
   w==;
X-CSE-ConnectionGUID: D1Idm/cWRHWZic564e3BrA==
X-CSE-MsgGUID: VMMIL4X9Q6+zD8FVOvtuvQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="84870955"
X-IronPort-AV: E=Sophos;i="6.23,102,1770624000"; 
   d="scan'208";a="84870955"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 01:39:48 -0800
X-CSE-ConnectionGUID: +uBdXiXbRQOX7B8MyuSWYQ==
X-CSE-MsgGUID: JU/2s9FxTmqGmrqqaWLtQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,102,1770624000"; 
   d="scan'208";a="214684978"
Received: from vpanait-mobl.ger.corp.intel.com (HELO fedora) ([10.245.244.71])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 01:39:44 -0800
From: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
To: intel-xe@lists.freedesktop.org
Cc: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Dave Airlie <airlied@gmail.com>,
	Alistair Popple <apopple@nvidia.com>,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/4] mm/mmu_notifier: Allow two-pass struct mmu_interval_notifiers
Date: Thu,  5 Mar 2026 10:39:06 +0100
Message-ID: <20260305093909.43623-2-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260305093909.43623-1-thomas.hellstrom@linux.intel.com>
References: <20260305093909.43623-1-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D038D40004
X-Stat-Signature: 6oncuwgqjbmr4e95xr3jo5oxdqfam9go
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772703589-752511
X-HE-Meta: U2FsdGVkX1/vkYDb+9txgW7bWWjTaocUMTyq7HWal5b+muTu5fFdqsURs36YSPKGOn7EB/W3FKIoS5cK7TiiSo5/qFpd/6Px716fRGOKoGSIjDQnvzDj87Rn4cI1lhboR2/uF/tyLiRpubupATvBYT3Kd0ILPULu/Lu98oA20xwoRTwc2SvRwD+VLyx+5qHF266Xg3VVpkhaVux4YbYNXbLkHSovDQOblg+5D3std+B0YKSzfIoLNNlAnqqX93xyn315KQIRkXO1XNXjF5YQ95w4GqSjrziphoDn5qnEefmtufEcMAkOM7Siv6+GsfN3jMyzoCY9tROQzZOO6hDJWvO82h8/LiYvfCTy3sdPwAjMoIwYdKhTTllydKubHM/1ifekKKBXGVhH0tr3/4DSy3NBjP9xxC1V+LJMFfVvZWRWULeCRHovTLwBvdnQlKjK8Ybh39Y/KDjG1oRMlCA+tFxKNIhAfvmV7BpUzK6qC8jABCilnZHnWUxj74+qxM6fWoKQGkQQlAtZ1Qs7pxQVnrXCu+xi669y+Y08+kCQKlfPGTGd+4oohWzDZkgF4PbyawYKyNY1LWzaiLU6NJVbJFZo1RBZemSOPhmhHM+Fcv7VV+rnVk2RCOhFgkdBq4ObaeprLJjxAGHQIy61fUy0MdkYUiG2lFVFJ2nK5PqDHtd5mItdBhglqDzDIGd/N58MppRq+hWXFRoUzGcB/ISg0KyKb1oHo815BoeY3UkYmfdVSKD3U6L4DKJTKxB7/1zj8bEC2++3BiXgn4DC9OnU5XM0sn8D/gMWG4cGF0aDPmhlQgnk2L9JyP8zCXJ5evzoFT8ETajagwQDVilJZEXOp6nN+Vxr8UAJf9At4RUvR/1zMLEefkPkPv9mxt+kgLaAH2mvsA0EfI5rroaAoRN2C8+BWyk+ucpZcM6tIsWBBwbpIXLXFIGpByLEanjuLCElEcDGR/kJGeWphwVTXoa
 b6T9K7do
 TJ1SLmkdeYRXqKpua+SSBeygTCgP6Alhykdk5EBjY3dzJiY4IYqmcOGn0QPaXMoJTnv5OIg1Yyz30Dwq4qbLzKCn+9QZmAm/C+T1EYaQEr+jQSxvT7MnglUmn//1JjdYECKxzdJqelluxVZdistjuKfnALJximweXWQM3a1NXHgU43jcS/ax4lGMTP8p3Jxhvy4j/I/x63Egy0ujZMdQs3n+DjhehHw2xwv0oLXfnSvU48xOYR4QtmMg7CCQmz9ZYkzznyalTELLZ/DksTG/rQZx4PecCtDzPda3SSBG1Dd7McDK01FgJyulgFMIObKreQWXUkbZ10oKRoCVnP8KGH7O+UaoM3dxnYC/N/k/2uCEkhyXSHaIMa6cgAzww2AYtLOwNUzy0A/uLHNjz4wtZib8gB+0KzKP+kbTvBcTazmGc6wSajDpfMTQ6R0RK4Slsz4a0CU3nHbwdXbW1v44X0cOneBgX1pCWYcsOHWmWt38QxWfpuhIrORNh7OsfZ3T7c4jHPYPI3r5SxJLe1G1GfMbbclT+lk+2r0/LWzO3Rug6xtt4mI8xOVc2DIxA9ydpKlPxQsKeEJt38XYJKYhQoSMWUmKiPBemHKRK5Aqe+lc5DOIiKI//4vFGzbqV5/dtEctwpiVOC31sJCQZGggiuKPs81T4bMcGabmxsvdyU8UE48lI5krHLCkpk/Xz3OzWyLC2oPzPVc/hIS5xCfn45zyyBe/tkP/E1grIQeoVMdAAHWM=
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
v4:
- Addressed documentation review comments by David Hildenbrand.

Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
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
 include/linux/mmu_notifier.h | 42 +++++++++++++++++++++++
 mm/mmu_notifier.c            | 65 +++++++++++++++++++++++++++++++-----
 2 files changed, 98 insertions(+), 9 deletions(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index 07a2bbaf86e9..dcdfdf1e0b39 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -233,16 +233,58 @@ struct mmu_notifier {
 	unsigned int users;
 };
 
+/**
+ * struct mmu_interval_notifier_finish - mmu_interval_notifier two-pass abstraction
+ * @link: Lockless list link for the notifiers pending pass list
+ * @notifier: The mmu_interval_notifier for which the finish pass is called.
+ *
+ * Allocate, typically using GFP_NOWAIT in the interval notifier's start pass.
+ * Note that with a large number of notifiers implementing two passes,
+ * allocation with GFP_NOWAIT will become increasingly likely to fail, so consider
+ * implementing a small pool instead of using kmalloc() allocations.
+ *
+ * If the implementation needs to pass data between the start and the finish passes,
+ * the recommended way is to embed struct mmu_interval_notifier_finish into a larger
+ * structure that also contains the data needed to be shared. Keep in mind that
+ * a notifier callback can be invoked in parallel, and each invocation needs its
+ * own struct mmu_interval_notifier_finish.
+ *
+ * If allocation fails, then the &mmu_interval_notifier_ops->invalidate_start op
+ * needs to implements the full notifier functionality. Please refer to its
+ * documentation.
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
+ *                    returned in the @finish parameter describes the finish pass.
+ *                    If *@finish is %NULL on return, then no final pass will be
+ *                    called, and @invalidate_start needs to implement the full
+ *                    notifier, behaving like @invalidate. The value of *@finish
+ *                    is guaranteed to be %NULL at function entry.
+ * @invalidate_finish: Called as the second pass for any notifier that returned
+ *                     a non-NULL *@finish from @invalidate_start. The @finish
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


