Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F2FFD25B44
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 11:20:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D79E86B008C; Wed, 28 Jan 2026 06:20:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D376E6B0092; Wed, 28 Jan 2026 06:20:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C50DE6B0093; Wed, 28 Jan 2026 06:20:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B4BA26B008C
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 06:20:29 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7B7305993D
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:20:29 +0000 (UTC)
X-FDA: 84381129378.14.CB07B4D
Received: from mail-ot1-f67.google.com (mail-ot1-f67.google.com [209.85.210.67])
	by imf17.hostedemail.com (Postfix) with ESMTP id B556B40009
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:20:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SlDE+RRA;
	spf=pass (imf17.hostedemail.com: domain of realwujing@gmail.com designates 209.85.210.67 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769599227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2MWO3DKTfHPlWbWoJnbmcsmvrxuGAi/ENfoXzbGs/t0=;
	b=d8qnMAoQQ3uWjy3T1fbfFANQ7XASdOOibSExUshckaoZRO7Xokk3M0Ik3Sc5ej30rSsjrL
	/NGsvcZkLzJx9gza/hUnw6v8M4+kp1UmWiLHDOLza9qNVKGU/yg6LcVO/GYXBO8Rm09yM2
	wBWnNuDL/6SHKWzXYfEV5h/8e6iO5HI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SlDE+RRA;
	spf=pass (imf17.hostedemail.com: domain of realwujing@gmail.com designates 209.85.210.67 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769599227; a=rsa-sha256;
	cv=none;
	b=6lqavQ0H0kkE0Dg64jo23n3fdwDRlpQLXwppTFJ/9X2cH0zZ8XMTItbqsmTJmoEVGCrjFv
	FBhhN20hCWbWV5Eq7wgriQasNExR1PTMP4lH9b+kegkLFt9zawY6ha81qK4q5KMQ3AhRZI
	cjeXgdYAH3/owtItH0CwhZx86NmTxzk=
Received: by mail-ot1-f67.google.com with SMTP id 46e09a7af769-7d18d0e6d71so511304a34.1
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 03:20:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769599227; x=1770204027; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2MWO3DKTfHPlWbWoJnbmcsmvrxuGAi/ENfoXzbGs/t0=;
        b=SlDE+RRA8FLkVtra9nQG9t3pvoOmvLFDJkyetgZVswXOn6znwydsIZSyLq98lV4FGU
         EU6jtzkct+iiVR5RFtpH/MQ2mtWjeKPYpxL9+lisxseLZyerySpMuII4ZxH/eSp1JoAc
         wLpLxNOvWxef9sTd51iU8Q3tSbEqJ54OJJfSlBtk/HSvv3CsRjLCzO6sCZ6ovz4i6tSX
         UCrrJ2U8gmn85Iigr9pfMtPu9IIC+bectaxvJ+Iaheo3bDxy8pc+Ci5Hqu+ji+/l/scl
         XRsMxc4FkG/1RMg4K8xHo7MxsxRrLWez0rUawJ01uQqfGezn0FuzbZFraG6mDGnMu/Tw
         taJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769599227; x=1770204027;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2MWO3DKTfHPlWbWoJnbmcsmvrxuGAi/ENfoXzbGs/t0=;
        b=Gk6zLJz1UqLrw5fxt/FtGmzINM0FKBisem2iAVH4tBZgQIb39I3ytQrXFyhr57aSrq
         FQgBDDazMSS4JvS9vXW7f67nGFjei0WCBefsBv64KJutDLpcu0MDvCLhWbonKGoFDJCe
         OIVYYsf2sKK+5AsOgcUfii21EV5b8VSWfCxIXjG9fUMSYGv3KecZGW2AXNWcHwMfJmLn
         H+CJ8OvGJDQo8N3R1Bzl9ViILekCtuMHDYzWpGQCn6I7vXxDMBXbXVV9uqv6LmEb/Ipn
         CYeSGpjBQCKexE1/bZymeKbclN1s5H+xz93Pa7KHgrZpydCeQTDHTqeZidbIbCVK028h
         VreA==
X-Forwarded-Encrypted: i=1; AJvYcCUj2ZQtZznIJPheL6wQDzaqs6qtZqUB3cMtoWfxyFz8rwjoEckwIyv03BkzIgmwpnaYD2zSB4t9bA==@kvack.org
X-Gm-Message-State: AOJu0Yzo9M/QDqPiJrnnxLox/CB7zuZLBs370pildasGTWXf3hA+c0zX
	y49gLJXS0Noz99xPAidH1i3o3XaR68AsjDotj+OGtIBPl6NT4dDir48D8J6CiGfEhyA=
X-Gm-Gg: AZuq6aKVJlzRjViojnwutyGyEUECVXMTk7oJHASWyCb0jg+pemyN3tas0jpLqWcVk8p
	uvNu4xAvwSOiFi/oSTtDcV0D/RyAXpZpTzS7yn6HMty0ndlwFYOq8crQcMs8aDYR9Xb4WHI3vX1
	lf9vN3edKOBNvhtiuqUzKv9VxkoRq3C7g77T1K68RwLtjOXJWJvfLso3cIzxgFxQeZwwwe084gf
	fxEVDQimZvutNyZjuIhICAHiJkzyj1UZ9vwL89Mfo8wIzFZvjc/98UxIlyN9t507DNjwwCLZO+P
	OEtQM7TfadZ1UhqVVNd2sgaG+FOy76dXtQGAhUwTlbRCyMMIu4JdmQ0YQTEAIsywNyfDKQ0cVAe
	S/8JPI+NhRGVoj21kjghERnzjur1bhFldRLSZYlVruDcevdHRbT39w1ckhX62uP+UILzmLN7T7W
	ITV8tTA8tDRF3ePQ==
X-Received: by 2002:a05:7300:cc12:b0:2ab:ecd0:5221 with SMTP id 5a478bee46e88-2b78da4b7e1mr3063339eec.42.1769592801585;
        Wed, 28 Jan 2026 01:33:21 -0800 (PST)
Received: from debian ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b7a16ee7d3sm1828362eec.11.2026.01.28.01.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 01:33:21 -0800 (PST)
From: Qiliang Yuan <realwujing@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>
Cc: lance.yang@linux.dev,
	Qiliang Yuan <realwujing@gmail.com>,
	kernel test robot <oliver.sang@intel.com>,
	Qiliang Yuan <yuanql9@chinatelecom.cn>,
	Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v8] mm/page_alloc: boost watermarks on atomic allocation failure
Date: Wed, 28 Jan 2026 04:32:53 -0500
Message-ID: <20260128093258.1740809-1-realwujing@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B556B40009
X-Stat-Signature: d595u1caef6ast7r9zdzf1gawrduf3yz
X-Rspam-User: 
X-HE-Tag: 1769599227-907096
X-HE-Meta: U2FsdGVkX1+cOYHMMmkGvHyRoM6gqlf2THhrS+f54BfRrrd4Wwm39RqSGHmr2HMHS6v4ptcjEBoSjNlfCSRf/adc6kY5AkNx0WBpvUYjffrJK2pUSGpgre3USS1pkuY0w9tAvPLLXjtDeiLzH/HKnVeUmTJRGEk9GVu1jyRQtdEYUuVojI9Pm12jQZn+tJQ+wHa7MfkjT+veswmimQJHkfmXE2P2suXvHpNtAVR4ZYxZSP9c8AzjB9tHmK78DC9+dzIgnrQwXPWV+VBaSsENhVTNMLlLDW/i1Yr/7icJgrWmY17/s2iZ+H82PLFd64Eu9YuZloyxtrg4RSFU+/aJ1gHhFOKgryGT+RJIAhJTtPO1xtfk1zG0+nUFJjTc3ICdtegV9tShwadGgrcGaHyzpoc4fC5Ex0284I/rijy5zLIVNPdv170R5zzEA7A4pkf/vTv90lTiWR0uofEvsF0uwcAJfc1h9THq6Hl2ngKgV/90SvBQCt2vO8yPrsi+Y6ED/ir1ul8+aHFlBpbh0A+xnxLQfC9f8y0tIVEa3mVO5cAOJkAM3kyw3QRH5EIsZtI/AZzwaw2wPg07hI3qNBTbhh3ZbD+sAkZ4Hc8Qa4c90mGusX+Wq0rkfLZugqiTPvrXNEPk4BZFnuzOiwSJYLpmV4608IUy3aso/erA2pBEghQuHVxXxz+8sINWLOxanXwe5iN9fQgyM0m1cd2z9WHZajW1uDqIeO8GBRCZ6W2rBqbZd4e/u2U2Yybb0xH/cbLclxtKNA3KfsNMOcVeNc5XkraepAOxsvH3Vq3hgszXE096AV3oXTVOaLbUqGlO65rHuExf5nVMqiUzyO9sjn4ijwyqDC6jvBI7zyxztiHwtk/eGh3QeFdV9kOkHN/3DggRPdjKO4nfK/3w8/firOiER2Nozl3BznOZKjSgfcVQsVikAXcqVOEcZxvE1xgju7UdFGG+p/UW1TBFUf7RRsi
 H2CFTSxQ
 Q5rWuK0WRz+lQPDN/JnRVdy6opKhSaTmePKzj8Q+qWiGp05FV5LbG3yMrMGSCUhLfWmXS6ybDHhwT2Mc2IE6ppu1769ZI4l6m0ogd8Pk0cxtlfCEvnIQo/Uz44hKSXYJ66RyNFf8xhNEvyKzvHNVopii7l3fDKTacpNwUNBKe1CB2dcayzu4TQPvzRvnLPG3La8Rc4wPb/s8CSo1JcSX4PSK61atAd/kOmvcxy2KJEm4VhBi5BHFUfKTcABhW+PNA9WsKK2c3kO8gkZvuFizJxwWiylfs22ofSKpBH648oici6jmQaXBCA44IyjmkYBTL08lzp/E0GulZKUcjUzqIEwGS9xPPqv01ZP+GK8lrgwU6ZS4eNKw3ezwX+UsV4jMW1XAJ7WJFZ5e6wEiIdjhilOjNiZ7uKkhqLGhDBWFy8MTCiV4kP/ASiOY9oMUB17OR36BFI2RUyiHrbgYFYRcYQuIwkQpvTUmh3T13ryqf4GsjYuzTsrwKYCyzb09skF2Rc8iavAUu0t2jRDneZuQMCJO5V0TafwyoClFZj+a0SUpzKS6m1sQP2ZeWd5gtJeK2Orx5BVq25poCaCvHaDLg+zXGVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Atomic allocations (GFP_ATOMIC) are prone to failure under heavy memory
pressure as they cannot enter direct reclaim. This patch introduces a
watermark boost mechanism to mitigate this issue.

When a GFP_ATOMIC request enters the slowpath, the preferred zone's
watermark_boost is increased under zone->lock protection. This triggers
kswapd to proactively reclaim memory, creating a safety buffer for
future atomic allocations. A 1-second debounce timer prevents excessive
boosts during traffic bursts.

This approach reuses existing watermark_boost infrastructure with
minimal overhead and proper locking to ensure thread safety.

Allocation failure logs:
[38535644.718700] node 0: slabs: 1031, objs: 43328, free: 0
[38535644.725059] node 1: slabs: 339, objs: 17616, free: 317
[38535645.428345] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
[38535645.436888] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
[38535645.447664] node 0: slabs: 940, objs: 40864, free: 144
[38535645.454026] node 1: slabs: 322, objs: 19168, free: 383
[38535645.556122] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
[38535645.564576] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
[38535649.655523] warn_alloc: 59 callbacks suppressed
[38535649.655527] swapper/100: page allocation failure: order:0, mode:0x480020(GFP_ATOMIC), nodemask=(null)
[38535649.671692] swapper/100 cpuset=/ mems_allowed=0-1

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202601271341.5d24a59f-lkp@intel.com
Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
---
---
v8:
- Use spin_lock_irqsave() to prevent inconsistent lock state (softirq-on
  vs in-softirq) as reported by LKP.
v7:
  - Use local variable for boost_amount to improve code readability
  - Add zone->lock protection in boost_zones_for_atomic()
  - Add lockdep assertion in boost_watermark() to prevent locking mistakes
  - Remove redundant boost call at fail label due to 1-second debounce
  - Link: https://lore.kernel.org/all/20260123064231.250767-1-realwujing@gmail.com/
v6:
  - Replace magic number ">> 10" with ATOMIC_BOOST_SCALE_SHIFT define
  - Add documentation explaining 0.1% zone size boost rationale
v5:
  - Simplify to use native boost_watermark() instead of custom logic
v4:
  - Add watermark_scale_boost and gradual decay via balance_pgdat
v3:
  - Move debounce timer to per-zone; optimize zone selection
v2:
  - Add debounce logic and zone-proportional boosting
v1:
  - Initial: boost min_free_kbytes on GFP_ATOMIC failure

 include/linux/mmzone.h |  1 +
 mm/page_alloc.c        | 48 ++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 75ef7c9f9307..8e37e4e6765b 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -882,6 +882,7 @@ struct zone {
 	/* zone watermarks, access with *_wmark_pages(zone) macros */
 	unsigned long _watermark[NR_WMARK];
 	unsigned long watermark_boost;
+	unsigned long last_boost_jiffies;
 
 	unsigned long nr_reserved_highatomic;
 	unsigned long nr_free_highatomic;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c380f063e8b7..7dc1e056a082 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -218,6 +218,13 @@ unsigned int pageblock_order __read_mostly;
 static void __free_pages_ok(struct page *page, unsigned int order,
 			    fpi_t fpi_flags);
 
+/*
+ * Boost watermarks by ~0.1% of zone size on atomic allocation pressure.
+ * This provides zone-proportional safety buffers: ~1MB per 1GB of zone size.
+ * Larger zones under GFP_ATOMIC pressure need proportionally larger reserves.
+ */
+#define ATOMIC_BOOST_SCALE_SHIFT 10
+
 /*
  * results with 256, 32 in the lowmem_reserve sysctl:
  *	1G machine -> (16M dma, 800M-16M normal, 1G-800M high)
@@ -2161,6 +2168,9 @@ bool pageblock_unisolate_and_move_free_pages(struct zone *zone, struct page *pag
 static inline bool boost_watermark(struct zone *zone)
 {
 	unsigned long max_boost;
+	unsigned long boost_amount;
+
+	lockdep_assert_held(&zone->lock);
 
 	if (!watermark_boost_factor)
 		return false;
@@ -2189,12 +2199,42 @@ static inline bool boost_watermark(struct zone *zone)
 
 	max_boost = max(pageblock_nr_pages, max_boost);
 
-	zone->watermark_boost = min(zone->watermark_boost + pageblock_nr_pages,
-		max_boost);
+	boost_amount = max(pageblock_nr_pages,
+			   zone_managed_pages(zone) >> ATOMIC_BOOST_SCALE_SHIFT);
+	zone->watermark_boost = min(zone->watermark_boost + boost_amount,
+				    max_boost);
 
 	return true;
 }
 
+static void boost_zones_for_atomic(struct alloc_context *ac, gfp_t gfp_mask)
+{
+	struct zoneref *z;
+	struct zone *zone;
+	unsigned long now = jiffies;
+	bool should_wake;
+
+	for_each_zone_zonelist(zone, z, ac->zonelist, ac->highest_zoneidx) {
+		/* Rate-limit boosts to once per second per zone */
+		if (time_after(now, zone->last_boost_jiffies + HZ)) {
+			unsigned long flags;
+
+			zone->last_boost_jiffies = now;
+
+			/* Modify watermark under lock, wake kswapd outside */
+			spin_lock_irqsave(&zone->lock, flags);
+			should_wake = boost_watermark(zone);
+			spin_unlock_irqrestore(&zone->lock, flags);
+
+			if (should_wake)
+				wakeup_kswapd(zone, gfp_mask, 0, ac->highest_zoneidx);
+
+			/* Boost only the preferred zone */
+			break;
+		}
+	}
+}
+
 /*
  * When we are falling back to another migratetype during allocation, should we
  * try to claim an entire block to satisfy further allocations, instead of
@@ -4742,6 +4782,10 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	if (page)
 		goto got_pg;
 
+	/* Boost watermarks for atomic requests entering slowpath */
+	if ((gfp_mask & GFP_ATOMIC) && order == 0)
+		boost_zones_for_atomic(ac, gfp_mask);
+
 	/*
 	 * For costly allocations, try direct compaction first, as it's likely
 	 * that we have enough base pages and don't need to reclaim. For non-
-- 
2.51.0


