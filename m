Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B0B1EA4E3F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 16:33:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EA126B0089; Mon,  2 Mar 2026 11:33:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63FB36B008A; Mon,  2 Mar 2026 11:33:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39C056B0092; Mon,  2 Mar 2026 11:33:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B3B96B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:33:16 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E98141B6E33
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:33:15 +0000 (UTC)
X-FDA: 84501667950.07.4F5B06F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf30.hostedemail.com (Postfix) with ESMTP id 826728000A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:33:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Px5RJ27u;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772469193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bzxdyxr5fMzjILh7ZrLFMuYDXIsd3Y8BQZBtrjNZH1I=;
	b=LkQGrylQeXFJy3B1mXLk/iyHZ8xcmm1VssRgzsu/iRFPE1dGq8ojDqLJeUIiwXn3N2g7+T
	i4EqrRLJT5xBseiY1yc9CeN4p28lU8PQ2GSi0/krmoi0lU/VgimLYsRrWHS22WDl8ooxPG
	8MlG/fCZh+cN+V7/hsuAH3FlMSqSznY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Px5RJ27u;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772469193; a=rsa-sha256;
	cv=none;
	b=bHUpq79RRz0OeQDuXK8/cBXakLp4Nzcd3FbX+Jmx5IJ7L0Oa3r50F1RfkFKQdofn8Qf36M
	2Yl3aAZSLqxGKzMKf1kQkX8zGqcx8w5LecAcDoSmr6WQlBnglTalaffSFbin4SjWSeFtT2
	zWSnNY2Fe7KR+eHS14BTfRf94UAe4wc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772469193; x=1804005193;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+dB6I97jnF3C+kz4LYr+QDqcLMSjhH89nLttR0xMEkA=;
  b=Px5RJ27uSpVK7LyQjXcGMV2UI6MjEvHimn3nZ/Y4zOG4JeRdNXs9Siir
   x+wsdeLhBgpmtignAWbKo2K95oHH9pz17WFQQkOh7S1FOVrPI2eR9EYbx
   dvAsk+Lqdl/5OYD5cbuITEgGtsiXxM4iOHtbpPDnYMNlQXkhF2G3uBXWc
   83TmUpL5YNibZ+CcNO7rjZ0X3QgzF2lCeExhkcDEY2wKttSlrERK3PM0y
   ZqJPKc52ZcMj3f3GKjhZ3V9I/T09IFjjvN+FEM2htgcTOcitpYsytxb0b
   ulN8zvtmrb+4GT6GBIZAG0oOeD6Mbnluo8YFDxFAKdzhKpJ9oz3ty+5JD
   g==;
X-CSE-ConnectionGUID: zhVJIoGoTja8tPnhcrzC3A==
X-CSE-MsgGUID: c/FFShbwSZqeqghbS59zqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="73447822"
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="73447822"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 08:33:12 -0800
X-CSE-ConnectionGUID: pUth11IySXeudJp5F/KqPA==
X-CSE-MsgGUID: nOQS+yt6QGaZqsL5agaPdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="255564512"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO fedora) ([10.245.244.81])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 08:33:10 -0800
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
Subject: [PATCH v2 1/4] mm/mmu_notifier: Allow two-pass struct mmu_interval_notifiers
Date: Mon,  2 Mar 2026 17:32:45 +0100
Message-ID: <20260302163248.105454-2-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260302163248.105454-1-thomas.hellstrom@linux.intel.com>
References: <20260302163248.105454-1-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 826728000A
X-Stat-Signature: zbhi1nmbxji6etcggpmixbwoowy9ujyy
X-Rspam-User: 
X-HE-Tag: 1772469193-894783
X-HE-Meta: U2FsdGVkX1+2IF+x5iXZaPE9mOp78hwEmoD6sniBkA6cXALrrs6ev+SDHNw6L0CA90fOO8OhO35Uvr65uImyL/FT51/nD756Eyk3nc1kdmvf2oqZE7h/49pmD3zNuLy44Gg4Z50jFeoUzC/s7p5G2y+Rku41nS6SiyEzzWTk+LITq8qJBQJvb+T+uJP9VhL8yfkxrZ0cAv18jhARRNq2hsrRfKmFoDZWjpkEXFonZM/jJQDe29UCr87epVDzAeKxQbpPmjqX5za6OzMdx0LaCtcj8I76P71lLoS+jNNmxjauAcb0OTCX/VbXdZ/t2J7kxbGxWmqTSKwHxdeocnBopW/1r/YASk7UbwACX1oLxD2L7DKEIn/S+eCDK5zi1Bw+A6esPR4BA3JaL5YKyB7lMCHqqPq8uu8BVQHzEQnJ0zOUcQyB7rKw/2IexIURMqIw6U9xosjeSLHSCUzGkLT4R5v9kM2AGPtmcJT6FSdxSD4QZ1qlp3n3ADJqAASjeB8ohpLrEfHdWrtD1iIgOrAhjxUMpmqS/LjHBqESzLc1EjpfDtnVDkjRChY2ICVMc8wjQL6lYKwfVxkNMu8yBsLSfkwGs9YWnEgihpVswyaqrk7S8uky8eNofRpxWCxWwzMENiQXUPXr9bUo4853mSCDyQlcTDxNRX6WjGoivngk6kTrv0ZRabF6gq6IDJ/+rBpJwnyoJRoG1dUdhySkxJ8IDwmvK9X4PX82EihSFDqzxilXSpH1X+Jl1+FD8DFtv0gdY79A/LmT1kHfgjB0HWXiQ5AT9/m5p6rb4l39zyvOyoSNFmahK1lHzIYg2HnqhbdXh3WKd6jBmHcWbSpQ0XyVBGPuTn+/PPg6M1d7qJvjlN8O1yg2/C7bAZngtz7+r6ADBOj9JgiM6QNRji3W7WAaK+VJWFUxySF7hyjheqY5eltK/OB7JycuuQEWAA2v0B1j/hKUkAkrMqOiczmPVsE
 0z0l0K3D
 NucRJHfku+MHILI2y92EZ69QnpwFqZjfjLFha4d3rzVjmk09RoU0mG2MbafUCXiK8yT6gaEbXNAd88rBoDsD6avUJ2imShwwRarK3dQ8zbYXxzDoE9AF0XZ34p7gn9elijKVR5eJUwRFoF3taldtBRUlIXTxMlQLdGx8aCXmhfoIMBOD+WOyew/QGuFtMCunY8KzilMpVDoLwxFnpOx6mOrMpbLKD0bDEaCD6Q7yHge3C7m9MX9ZCCcgOwOVsKPkbecB5ZBoY6xopXO8GnmZ7MDmX9uI0xJT7s3pn1/Sdse5Od/8oCg6vDognle3nwtfSU/MyVNUPtxA3SEW5sQidm8bjdK3+Qt42R29ylOaVWihmpOTahtSLoF4CJDQFXulIjPBeTaW4rRQJppoZItMDNu2V5WpgpegP3mVt0pP/X5d/olO8LRqRsAYQPnrrmWzuvTlNFTzdLoDdQ+vUpWZyGSsr5oG4on+znXQDw+tDM4W9F/yoPmL9S7AbjdGrE+dJ7LobSTYK1w9DH1GYqoezcZ4qRs2rjtUtHaJYIKfQDqNb7H954EXph6hDDPz6z+EnGAzqBnmDTZUbkZQ/aL/+C9ECdqixu4RKt/QUDgjeIXrJ1xo=
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
 mm/mmu_notifier.c            | 64 +++++++++++++++++++++++++++++++-----
 2 files changed, 93 insertions(+), 9 deletions(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index 07a2bbaf86e9..de0e742ea808 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -233,16 +233,54 @@ struct mmu_notifier {
 	unsigned int users;
 };
 
+/**
+ * struct mmu_interval_notifier_finish - mmu_interval_notifier two-pass abstraction
+ * @link: List link for the notifiers pending pass list
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
index a6cdf3674bdc..38acd5ef8eb0 100644
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
-- 
2.53.0


