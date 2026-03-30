Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBFF71061B22
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 22:42:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED0DB6B008C; Mon, 30 Mar 2026 18:42:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E81F36B0095; Mon, 30 Mar 2026 18:42:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D97ED6B0096; Mon, 30 Mar 2026 18:42:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC5E56B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:42:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8AC82160985
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 22:42:30 +0000 (UTC)
X-FDA: 84604204860.13.80D98F8
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf16.hostedemail.com (Postfix) with ESMTP id AD17618000D
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 22:42:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="o/wcvl81";
	spf=pass (imf16.hostedemail.com: domain of rientjes@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774910548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tISSsPnc5j391XAZvj80zu48QZMM8bzoocK5g49wH/o=;
	b=EushgbMbpSc99auoUXH041+w7kojMF2vnoEIjVFESoOm4K6Q5tSCm5r1y4iZTzjwuRNDD6
	bT1DxGMaNf36sHLmIjOJDTIcZLYHlBZ1Jo0KUGjl4mqG1illLySOxemtUoSNwodifa45jC
	7Ee9oRaTMUZ2kfevtpiJRjLx2FRzteI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774910548; a=rsa-sha256;
	cv=none;
	b=cGCVApeKumzXsfNm7/joA/v1dWlOZF45G0RYXKRaTK4KR0/BMCsSQwMzKiQGzYuxOMQem5
	BA3cV8NPF9laEOQPrUH3PxiWAofTUPOk8wt+savdZUL4QTwyYK3hGYsjmsxfhP8vvrVrN+
	Lbgivn3RzmyXM4ppZ8pc+wUi06ikOIA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="o/wcvl81";
	spf=pass (imf16.hostedemail.com: domain of rientjes@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2b0b260d309so15695ad.1
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774910547; x=1775515347; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tISSsPnc5j391XAZvj80zu48QZMM8bzoocK5g49wH/o=;
        b=o/wcvl813q8hu43K2M885NLYv9dbyy5uQh1c9kkmMkiZqTRMukTFO4GhpSq2owVsC7
         ULbS2hBc2TQAJwM3szVwp+8jf/Ko1GenFLuUF2jl63xceWJ6Fi3c2KkVz5w7m5Y4fTsc
         oOW38KF9Q9f7NYaj9wVzuPS/W942V9E+hVNuS2Dtebp6hGZIwn/mtd5lqqRdPxHmjVRy
         5nZ4UopYrCyF7tdbpdfITnMjlAM4tUndJeBo77dCWPcvoISMGmaN7yD5ptDRPL1yQieA
         1RgQYVFBe+ocKx9R/Amxp8cU2l0CkOLmpMVnVnLiaCquet82DDaHjsDwMs/dzc2w8ZHo
         fUag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774910547; x=1775515347;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tISSsPnc5j391XAZvj80zu48QZMM8bzoocK5g49wH/o=;
        b=eOmeCgl+8ARGBsV2cXHDJDINjgFNTJKH9tWb6DPW3JqiIdBTuGUzx5DPPwc//5Ja/s
         RVMsnzKUfHNFH5/axc7YzS9hpwjs2wy8kOwKoowKy4+H/ZvAWUbvJTpKbnYgl+nf89ZX
         rJqWRpmtb9bI7rY7PDnjNZlNme/bAwSEcFLV1rSJC+YlYU2EBXOtrjttZfsFkaVhHy5g
         43eZ0c9+O35q5JCbyEMWyCeH6rJDURucsezGbRqETi/Yp45GKo9G+shPa7//hQbPEas/
         Jgz4gWT+mTAB8KhprXMZ891HX0RPZWROPoMDyZjRW21vXG6pNo8A/R6Tuai/+cZbwumo
         alhQ==
X-Forwarded-Encrypted: i=1; AJvYcCWlvaicQFWOSvvt/TKRtxX4a7zGouY+lDB9PsmEkgsMLQ06cJGyXSgcAKm2ve5gE0NCw9JU4nwsLQ==@kvack.org
X-Gm-Message-State: AOJu0Yw6Hi3CM3+MohC18/l/Ofge9yuPTtFCl+iPehVBa34pzZHIZMoR
	3BYDXswErHgLfxql38ynNxt1FiPrYOPd/m7jMvBp7eL2gtuF+UWXZC5ODX1NcXc21w==
X-Gm-Gg: ATEYQzzSIBSCYoQ9wP3rT1qf12xJEkxFfHyTSQqmK/c+jh9EkuDSvxhcpNx2EciJu4n
	1vlzvzxHwL4GfW69Sj9VXskDgoxyLl4Ea0YhUuKsQ/mVopxa8G7rUxuLm2ar5tFUoJa5WE5PlSz
	sccGz+/UBF5OBmepL+5TFtCVpWZefh+a+NyRc1XQcYZIUDzmkL78i6fof34msV9CK5LNmrea9Jm
	3tz5BhvtJjpjDM46Zxxd4UuVir7Uf2zxVARCH/OFwGSMA/fcJigUol3k6Y/7wruW1xyEVh41EEM
	jawE01ajrPmoEnfvhFvb5M1dSG6q3Q8POMoxHkFF2oy0B4LUNqUuyqqIpt1WokSkLyaSKFq19sR
	LWTv6cK/6IdHn3wyQs29SOvpL6QdP84WZBux4xwvD3/GOg/F1pnAg7SU9/AkgH3AT9QbxdPmVmu
	bn/4IndBZPGFsoBuVgQwcBMnGll8cT+0wE2ju5dCYm54ZbivQIBwgZPvBh1TQnn1jfgaD8OzBTX
	bFY1IGWhTZ1jZT9PNzTzmBUpukw72TRGMDJr7yKdQIiTUxGfkJwmQ==
X-Received: by 2002:a17:903:22d1:b0:2ae:575f:3755 with SMTP id d9443c01a7336-2b25f78bbcemr1493575ad.20.1774910546781;
        Mon, 30 Mar 2026 15:42:26 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:bec3:8e5e:fca2:7852] ([2a00:79e0:2eb0:8:bec3:8e5e:fca2:7852])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b242765c7bsm92505995ad.49.2026.03.30.15.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 15:42:26 -0700 (PDT)
Date: Mon, 30 Mar 2026 15:42:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
    Vlastimil Babka <vbabka@kernel.org>
cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
    Brendan Jackman <jackmanb@google.com>, 
    Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
    Petr Mladek <pmladek@suse.com>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: [patch v2] mm, page_alloc: reintroduce page allocation stall
 warning
In-Reply-To: <231154f8-a3c3-229a-31a7-f91ab8ec1773@google.com>
Message-ID: <58a10940-e44c-a120-dd6e-ee9f480c4946@google.com>
References: <30945cc3-9c4d-94bb-e7e7-dde71483800c@google.com> <231154f8-a3c3-229a-31a7-f91ab8ec1773@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: AD17618000D
X-Stat-Signature: wmu51z7jtcreioq84fjygwxuy7r4pmk3
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774910548-281251
X-HE-Meta: U2FsdGVkX19RhI5RHSiIJ5KQPt3mo5OyZYsr2FwrsU4mOJ0jJ4RJxULnv+3OCYi9fpIi1ndzgK3bDuzJ49oLLLQf2wPySI5c6lXMlh+y9P4ZV6X9tI37CZZ7TGSDsbIi0KG7S9SgppWAyXcu4a2uwGBHu6pmzDdzO54RQ/PZJADvB7RRekvmNCg/xeXH2pac94obSesK8JNdC+iY2Mqlwk5tp4o+UhWaAszZC6VqX+u4inYdqnyRYrMaiUqvNh3rUsgExdYBP7Hn3U6243EAEc2G/qXOW/pfV87sw5jIMvCZqGgxi4wNXYtEgMgrEQZpI/L71zeXhyiJfsB0wYLE3/E8JRprudpFxlgLdRDCQqcQHnsKdGUehY8OA6eOd4rw3lKZxzrYUeQI8k1gM97YvDT/4hvJ944sMKDfCrJvWgJJ6c5taOjbTls6KdZO8OfHWbfbRkdmIWROAcs5WEp9V1EESwHOnw9PO/0W9TezRAFrOqrzThmagKpFqjq3LfJGUlfMhbMvIPocHN2zv4g5G7ccdjwhmDbk4UPfYaY0NWuElfBnAN67v9Os6Y68bGCLsLg8ybeoWc+pfepAGBzhNp9wt6s5hIDUbt79YVMVwQwlaxj4twGFuuRpcvH014rYRKkUG+AcwFIRBdTmujxrv/833lTHVHe38iyjd25W7Q+G6yeovQ1j4WeWQS81Y3/LGhyzZzSpoyAHciK4YvzCKPX4zidFLN4Af0q0AjOXOO9iTs+yipsaKpILCo6xKCRiT13S9exzMaswRFq2dP+cCrN/e/liBwXcJ9hCKeeXzXqMOE5C6yVOWNaFbaBOYXSiv13nZFC6aTNL8019zJgMBCIA7dhk07cbK2xZy//5/Rk50esa0iD2FJeDW1eTM+LjZfOUh++6L2pO5RHUaUHOhfGTUnOsvAs+DGYnhR/ZMKjLfpoZQ5LEuP8nowP5YJvN9CD5un6smclSHXTF26L
 EZF3cS/T
 EsBwK6Ww16NBLHgenwKN1f3FYo9blV9LajgWHXgmKA2q6KOoylNMRL2eJ6AqB5SFKX5sbqHqcIgEWJOITLleTcdNrcyMhcU/95lJrxGA9uCPeWNSn+fDk4/Errydn48vQyOLPcm0OJ3Q9FbKGoveoQjzJ+iLIBPGbM9mAAXMJI2Kq94OPBVu0Yke2SX18MOXdTkxJ/1VtoAW/Tp3ps6i0lapqmlAy5KRSaRt/z9neKeddYxi5sQ5ol9SSnX8VjfO/oRQNBK0it1tayXSWCUCjxRP1hkErGiqZ7AOfp98XYvM5327+zdWTNNMO9/bYf1DHCRKkiADb7MOGRRSqVngNVaSOWUrXM1xO/sMAlDd4FtEvfreCIwzILU0y9xdE5CiEbU6Qd0VMETwFXoXajy+MXOK2bPDxD0OLIcCT+mLL3Og7n60=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Previously, we had warnings when a single page allocation took longer
than reasonably expected.  This was introduced in commit 63f53dea0c98
("mm: warn about allocations which stall for too long").

The warning was subsequently reverted in commit 400e22499dd9 ("mm: don't
warn about allocations which stall for too long") because it was possible
to generate memory pressure that would effectively stall further progress
through printk execution.

Page allocation stalls in excess of 10 seconds are always useful to debug
because they can result in severe userspace unresponsiveness.  Adding
this artifact can be used to correlate with userspace going out to lunch
and to understand the state of memory at the time.

There should be a reasonable expectation that this warning will never
trigger given it is very passive, it will only be emitted when a page
allocation takes longer than 10 seconds.  If it does trigger, this
reveals an issue that should be fixed: a single page allocation should
never loop for more than 10 seconds without oom killing to make memory
available.

Unlike the original implementation, this implementation only reports
stalls once for the system every 10 seconds.  Otherwise, many concurrent
reclaimers could spam the kernel log unnecessarily.  Stalls are only
reported when calling into direct reclaim.

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 v2:
  - commit message update per Michal
  - check_alloc_stall_warn() cleanup per Vlastimil

 mm/page_alloc.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -316,6 +316,14 @@ EXPORT_SYMBOL(nr_node_ids);
 EXPORT_SYMBOL(nr_online_nodes);
 #endif
 
+/*
+ * When page allocations stall for longer than a threshold,
+ * ALLOC_STALL_WARN_MSECS, leave a warning in the kernel log.  Only one warning
+ * will be printed during this duration for the entire system.
+ */
+#define ALLOC_STALL_WARN_MSECS (10 * 1000UL)
+static unsigned long alloc_stall_warn_jiffies;
+
 static bool page_contains_unaccepted(struct page *page, unsigned int order);
 static bool cond_accept_memory(struct zone *zone, unsigned int order,
 			       int alloc_flags);
@@ -4706,6 +4714,40 @@ check_retry_cpuset(int cpuset_mems_cookie, struct alloc_context *ac)
 	return false;
 }
 
+static void check_alloc_stall_warn(gfp_t gfp_mask, nodemask_t *nodemask,
+				unsigned int order, unsigned long alloc_start_time)
+{
+	static DEFINE_SPINLOCK(alloc_stall_lock);
+	unsigned long stall_msecs = jiffies_to_msecs(jiffies - alloc_start_time);
+
+	if (likely(stall_msecs < ALLOC_STALL_WARN_MSECS))
+		return;
+	if (time_before(jiffies, READ_ONCE(alloc_stall_warn_jiffies)))
+		return;
+	if (gfp_mask & __GFP_NOWARN)
+		return;
+
+	if (!spin_trylock(&alloc_stall_lock))
+		return;
+
+	/* Check again, this time under the lock */
+	if (time_before(jiffies, alloc_stall_warn_jiffies)) {
+		spin_unlock(&alloc_stall_lock);
+		return;
+	}
+
+	WRITE_ONCE(alloc_stall_warn_jiffies, jiffies + msecs_to_jiffies(ALLOC_STALL_WARN_MSECS));
+	spin_unlock(&alloc_stall_lock);
+
+	pr_warn("%s: page allocation stall for %lu secs: order:%d, mode:%#x(%pGg) nodemask=%*pbl",
+		current->comm, stall_msecs / MSEC_PER_SEC, order, gfp_mask, &gfp_mask,
+		nodemask_pr_args(nodemask));
+	cpuset_print_current_mems_allowed();
+	pr_cont("\n");
+	dump_stack();
+	warn_alloc_show_mem(gfp_mask, nodemask);
+}
+
 static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 						struct alloc_context *ac)
@@ -4726,6 +4768,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	int reserve_flags;
 	bool compact_first = false;
 	bool can_retry_reserves = true;
+	unsigned long alloc_start_time = jiffies;
 
 	if (unlikely(nofail)) {
 		/*
@@ -4841,6 +4884,9 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	if (current->flags & PF_MEMALLOC)
 		goto nopage;
 
+	/* If allocation has taken excessively long, warn about it */
+	check_alloc_stall_warn(gfp_mask, ac->nodemask, order, alloc_start_time);
+
 	/* Try direct reclaim and then allocating */
 	if (!compact_first) {
 		page = __alloc_pages_direct_reclaim(gfp_mask, order, alloc_flags,

