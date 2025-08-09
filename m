Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85DC9CA0EC0
	for <linux-mm@archiver.kernel.org>; Sat,  9 Aug 2025 13:52:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0175C6B00A0; Sat,  9 Aug 2025 09:52:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F31A96B00A1; Sat,  9 Aug 2025 09:52:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAAFE6B00A2; Sat,  9 Aug 2025 09:52:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD83E6B00A0
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 09:52:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8D0A01A0221
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 13:52:17 +0000 (UTC)
X-FDA: 83757358314.27.0BB0833
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf30.hostedemail.com (Postfix) with ESMTP id 849DF80010
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 13:52:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MOO3ZX1u;
	spf=none (imf30.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 198.175.65.13) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754747535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oTtEWT/nBL8L0962EkgBZHXKgdp1EZ8YoiSbnR2jdgc=;
	b=Fw5FRN+wpqTtQag6mOPzCd/GyyQOWaYVg58VqHA5EtpAC4/9T8GOq7fCYRvHJIaPDMlqla
	e+xbOZG9DQ1Ng1n8i8hS4d2HrAbhcIwgnaXPiIiO+87LTlIp7IU6FxH6iriHUWanRCcduo
	5V6LKKToV0bsaTlkU/dtgmAHdHAoizo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MOO3ZX1u;
	spf=none (imf30.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 198.175.65.13) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754747535; a=rsa-sha256;
	cv=none;
	b=KSWDdOSgNtsNHS2J7svD3Ht6FAdrFnPYKgVdtO+0F3vszsYRU9JTG1eqfd+v99sBwN13C+
	fwKAVx8jlYVv9Q6MyNJ4SUiHYaIftzwoMsl9HuuzPb3vidclyUx95AOKC8jTVj8dQS1cMC
	99KWfLvQ7ZIcBAdHXVuO+ORWGUqNCqU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754747535; x=1786283535;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I0S46TL3ZGNQAM5NlfugwXaH73kKnXUT2H7X0Wkzjqo=;
  b=MOO3ZX1uxQk8DoMhE+m425sqEdbpks+vtCXEMrmSoFwDrTOEKvnoZJ6t
   xr9JCXwDuy0YPKguEdN9hB0CPu7J/tWcdigf+HEYuehAHuaMH6p+L8TG7
   6tfxJeJc1mhHnvUOPMDhPDz+dDLf2owzPLE3yg/HpikmOFdi0VGtpRAba
   ZlIWiIh9FYZxQi1GKvuvL34HT/nsTAGKQ77VoZF5rSKT74FmLCH0jmkfH
   aFxOBmyqSWHclgjCQoQ2GMHVrlulBw8nmk6b/sTL4aJxajg7ecoHN46Bx
   TalXAD5cHYGi/8/fTUBmtODO+tgluNYU+ktM33NyuiIZeJSBgfopf4j7i
   A==;
X-CSE-ConnectionGUID: Ad8XuGX8RhirQshFca/13g==
X-CSE-MsgGUID: u4GeBei+RjS5wRV9N3m5Bg==
X-IronPort-AV: E=McAfee;i="6800,10657,11515"; a="68153542"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="68153542"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2025 06:52:14 -0700
X-CSE-ConnectionGUID: q0EFfHMxTtm9eDHUSNIpJA==
X-CSE-MsgGUID: Qrzeux62Rea+AK85jOp5yg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="165903744"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO fedora) ([10.245.244.28])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2025 06:52:11 -0700
From: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
To: intel-xe@lists.freedesktop.org
Cc: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Dave Airlie <airlied@gmail.com>,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [RFC PATCH 1/6] mm/mmu_notifier: Allow multiple struct mmu_interval_notifier passes
Date: Sat,  9 Aug 2025 15:51:32 +0200
Message-ID: <20250809135137.259427-2-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250809135137.259427-1-thomas.hellstrom@linux.intel.com>
References: <20250809135137.259427-1-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 849DF80010
X-Rspamd-Server: rspam06
X-Stat-Signature: uytgg1mihdwpex1dmfq1pup11xxi9xh8
X-HE-Tag: 1754747535-478017
X-HE-Meta: U2FsdGVkX19zocKWr0nmnxZgcGeLLVgbwrSfxi6wItnqvqGyjafaf5/PHt934F15Ox53O8pBiPhfpVArE2KPysEIKRY8SePAcQlJAYH/oYE6oWXIZgA/uobQHxw22TFAK1ip4PsOnUqrzzOG2+5lqEZnB80Z7CkWnKIa9187JBpgkjVHtjxPyaudbMauI3Kjd2Ar0/I6uJ9m+CQ7EALR1PElO0RmNWXQz2rKJUjjBagUu1x5AFFXJ9K5adAyMtRBl8SFAazScwJUd/i7e/pqUDB8h+k+y34nUj10puIG+tVSLtX6sh/q1im36c3bzVpr6P96lfP7bDUJGSWP1v4joYrWTZroQzL89HWovOWc82b43lrZIjsIgTqpOX6K/weyOy2RgS6dVCEasfG9y5k+6h5DfGtrrIDoDPsHobbfDYAvPi35hZybn/KX2AnFwPbvS++AUg61Z0hpxgOdNrC7YtLegYCFDMrhLq3E004s36AVNTRSFECvvAZW7TyqjS3ULBq65d0SbX763oM6MfcP+7s2FFUFtv8+D/oZ8qxx/y4+IYiOUr6LkzBQ7m6ZWJNfDjaYVMOwaJ1llOXnCoZRG5QMrRas/Z8EerL/g/nA6AocFquqryxNfsDEfjeCYhrJBfOUNYfQTmVA1e/DMXhQAd+M429GaDtg5g+wN5U6H8oVAWvD4ZiUjlM6NTzzXjUA7gnt7IhrTuWszi3Mkw8Iu8CdCNu9o1XhGHYfXD5On5gzNX5FOOvMYfbUw0UXnXJzuwBCe+Vo/8X1IllCbW8IScOF7FHUQoVom7Ka3T67eGbMw26DiU9gDHosNrwzraIum+uRI0/LiukMpvRz4FFhkfK6A63AT1yPTh75b+mH/yMNsehtZSsHBA==
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
for them to complete on all gpus.

One can do this on per-driver basis multiplexing per-driver
notifiers but that would mean sharing the notifier "user" lock
across all GPUs and that doesn't scale well either, so adding support
for multi-pass in the core appears like the right choice.

Implement multi-pass capability in the mmu_interval_notifier. Use a
linked list for the additional passes to minimize the impact for
use-cases that don't need the multi-pass functionality.

Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Simona Vetter <simona.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@gmail.com>
Cc: <dri-devel@lists.freedesktop.org>
Cc: <linux-mm@kvack.org>
Cc: <linux-kernel@vger.kernel.org>

Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
---
 include/linux/mmu_notifier.h | 30 ++++++++++++++++
 mm/mmu_notifier.c            | 67 +++++++++++++++++++++++++++++++-----
 2 files changed, 88 insertions(+), 9 deletions(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index d1094c2d5fb6..1107a8eafd8a 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -233,6 +233,32 @@ struct mmu_notifier {
 	unsigned int users;
 };
 
+/**
+ * struct mmu_interval_notifier_pass - mmu_interval_notifier multi-pass abstraction
+ * @link: List link for the notifiers pending pass list
+ *
+ * Allocate, typically using GFP_NOWAIT in the interval notifier's first pass.
+ * If allocation fails (which is not unlikely under memory pressure), fall back
+ * to single-pass operation.
+ */
+struct mmu_interval_notifier_pass {
+	struct list_head link;
+	/**
+	 * @pass: Driver callback for additionall pass.
+	 * @additional_pass: Pointer to the mmu_interval_notifier_pass structure.
+	 * @range: The mmu_notifier_range.
+	 * @cur_seq: The current sequence set by the first pass.
+	 *
+	 * Return: Either a pointer to a valid mmu_interval_notifier_pass for
+	 * another pass to be called, or %NULL if processing is complete for this
+	 * notifier. There is no error reporting mechanism for additional passes.
+	 */
+	struct mmu_interval_notifier_pass *
+	(*pass) (struct mmu_interval_notifier_pass *additional_pass,
+		 const struct mmu_notifier_range *range,
+		 unsigned long cur_seq);
+};
+
 /**
  * struct mmu_interval_notifier_ops
  * @invalidate: Upon return the caller must stop using any SPTEs within this
@@ -243,6 +269,10 @@ struct mmu_interval_notifier_ops {
 	bool (*invalidate)(struct mmu_interval_notifier *interval_sub,
 			   const struct mmu_notifier_range *range,
 			   unsigned long cur_seq);
+	bool (*invalidate_multipass)(struct mmu_interval_notifier *interval_sub,
+				     const struct mmu_notifier_range *range,
+				     unsigned long cur_seq,
+				     struct mmu_interval_notifier_pass **pass);
 };
 
 struct mmu_interval_notifier {
diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index 8e0125dc0522..dd6af87db103 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -260,6 +260,22 @@ mmu_interval_read_begin(struct mmu_interval_notifier *interval_sub)
 }
 EXPORT_SYMBOL_GPL(mmu_interval_read_begin);
 
+static void mn_itree_additional_passes(struct list_head *additional_passes,
+				       const struct mmu_notifier_range *range,
+				       unsigned long cur_seq)
+{
+	struct mmu_interval_notifier_pass *p, *next;
+
+	while (!list_empty(additional_passes)) {
+		list_for_each_entry_safe(p, next, additional_passes, link) {
+			list_del_init(&p->link);
+			p = p->pass(p, range, cur_seq);
+			if (p)
+				list_add_tail(&p->link, additional_passes);
+		}
+	}
+}
+
 static void mn_itree_release(struct mmu_notifier_subscriptions *subscriptions,
 			     struct mm_struct *mm)
 {
@@ -272,17 +288,32 @@ static void mn_itree_release(struct mmu_notifier_subscriptions *subscriptions,
 	};
 	struct mmu_interval_notifier *interval_sub;
 	unsigned long cur_seq;
+	LIST_HEAD(additional_passes);
 	bool ret;
 
 	for (interval_sub =
 		     mn_itree_inv_start_range(subscriptions, &range, &cur_seq);
 	     interval_sub;
 	     interval_sub = mn_itree_inv_next(interval_sub, &range)) {
-		ret = interval_sub->ops->invalidate(interval_sub, &range,
-						    cur_seq);
+		if (interval_sub->ops->invalidate_multipass) {
+			struct mmu_interval_notifier_pass *second = NULL;
+
+			ret = interval_sub->ops->invalidate_multipass(interval_sub,
+								      &range,
+								      cur_seq,
+								      &second);
+			if (ret && second)
+				list_add_tail(&second->link, &additional_passes);
+
+		} else {
+			ret = interval_sub->ops->invalidate(interval_sub,
+							    &range,
+							    cur_seq);
+		}
 		WARN_ON(!ret);
 	}
 
+	mn_itree_additional_passes(&additional_passes, &range, cur_seq);
 	mn_itree_inv_end(subscriptions);
 }
 
@@ -431,6 +462,8 @@ static int mn_itree_invalidate(struct mmu_notifier_subscriptions *subscriptions,
 {
 	struct mmu_interval_notifier *interval_sub;
 	unsigned long cur_seq;
+	LIST_HEAD(additional_passes);
+	int err = 0;
 
 	for (interval_sub =
 		     mn_itree_inv_start_range(subscriptions, range, &cur_seq);
@@ -438,23 +471,39 @@ static int mn_itree_invalidate(struct mmu_notifier_subscriptions *subscriptions,
 	     interval_sub = mn_itree_inv_next(interval_sub, range)) {
 		bool ret;
 
-		ret = interval_sub->ops->invalidate(interval_sub, range,
-						    cur_seq);
+		if (interval_sub->ops->invalidate_multipass) {
+			struct mmu_interval_notifier_pass *second = NULL;
+
+			ret = interval_sub->ops->invalidate_multipass(interval_sub,
+								      range,
+								      cur_seq,
+								      &second);
+			if (ret && second)
+				list_add_tail(&second->link, &additional_passes);
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
+	mn_itree_additional_passes(&additional_passes, range, cur_seq);
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


