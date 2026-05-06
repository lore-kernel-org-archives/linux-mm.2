Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57CF2CD342F
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 03:33:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 352036B009B; Tue,  5 May 2026 23:33:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32AF66B009D; Tue,  5 May 2026 23:33:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CA976B009E; Tue,  5 May 2026 23:33:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0596D6B009B
	for <linux-mm@kvack.org>; Tue,  5 May 2026 23:33:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CB56C1606D9
	for <linux-mm@kvack.org>; Wed,  6 May 2026 03:33:16 +0000 (UTC)
X-FDA: 84735574392.30.97F6683
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf01.hostedemail.com (Postfix) with ESMTP id 37DDB40005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 03:33:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RHPQJ3QF;
	spf=pass (imf01.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778038394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pqsz09tE9Mxjelv17fDu2gNfI5JnmEJJW30xv5h92XA=;
	b=SHOO7Ar+PjlhonTNCDNk5/wtiajUVH1XSXQDtGY9UgRDefSXXzhBVYo/Goa0VWZC2LERoz
	x5UCVNqIhhz6DqaDnU2JvU2MaDeaI5/SiuUpEi7tndFvMIWfQfkLNRuv/RGMbcnvmFJyGS
	TbE8gXwwLgWGd1MiVnDjMq1ssbMo68c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RHPQJ3QF;
	spf=pass (imf01.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778038394; a=rsa-sha256;
	cv=none;
	b=K0VJE2AQUnwo1j7Te9J9ravNyze7vszx3ZZWHhX7m+MSoqoupvEXmefJyE+4yMpI1mOdvR
	no0mJQMzbSJ01meWdOxAwVPXBrVJ9ErbkJq3klAXTvUGPo2n7B3n3XgQUisif4u0sjwqez
	+w9sUcXG/PGs18JOuwSlgUeqNgxAsmQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778038395; x=1809574395;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hKs2r/SZ8fBLPzoHgcugkqcKmbZtBIMZ80SyreZA8i4=;
  b=RHPQJ3QF4zENWw2HIb5nRngk84yX9izhhf3jfgYe8+wlT/9YpA+zLR+h
   pylvb+0C9hbgSMyCuVzacF1tt2LTEoqS6VhJByG/OL0yf2Bhj2ykoIx6D
   YJKJgPZCDi5iHk6Eie3hDGoOtzhbXzRs3bhI5eBPAPfMlfmPizI1pu9UO
   BBBdRY3OZaPJExG4aYgtsRgNwEZeoY4brj4p3DeVVovKr0p+bPIYjRXpl
   lplfIRkFA3vDwmz5rC3ofpwATdOWDi3heKzEJsobDIUIbP9o77hcgZokZ
   /JPtokrAxluWBlMGPcuF8d+DLSCw9cmJxAqaGegnE7jnyJR3xVU3c+5yw
   w==;
X-CSE-ConnectionGUID: X0/CRDorRWuQZFBqoscNZw==
X-CSE-MsgGUID: y6PfEqkHQ2eAf5NV0d9u5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11777"; a="78829093"
X-IronPort-AV: E=Sophos;i="6.23,218,1770624000"; 
   d="scan'208";a="78829093"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 20:33:07 -0700
X-CSE-ConnectionGUID: 7i4b2G9rRAKaRcC7Cv6/qw==
X-CSE-MsgGUID: El8a7KdFSaqIsFbWl9ZtuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,218,1770624000"; 
   d="scan'208";a="266342154"
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 20:33:07 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 5/5] drm/xe: Make use of shrink_control::opportunistic_compaction hint
Date: Tue,  5 May 2026 20:33:00 -0700
Message-Id: <20260506033300.3534883-6-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260506033300.3534883-1-matthew.brost@intel.com>
References: <20260506033300.3534883-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: thg94d1g9auh3zk4kcg3m7ehciprc8xz
X-Rspamd-Queue-Id: 37DDB40005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778038394-11926
X-HE-Meta: U2FsdGVkX1+hrajhA9u2BKDENNVNAw6B+ubGgpT5IkevpFs9Sc77X4f1B/YaW6mLX5kYVnAM71LvT6ng0U+jCA11ZacTOQTGgvYQafNhGkCk6i0CcIa8f4kI6ftqAyPkaWUhurGakG9A7xTD9h1ELpi3Gm2Oq15yFiIturYfXkEqds1UMrIDovjiwZCSFD3wpA1S86w0G4iKn3Im1Wz6jFpgSmU6bWwxA4Eg8PLrtaoE3fViJRTAO4cp0B0BdQFaCztrJzD0Z6L1y1NbGcIOyoxgnmWkydRiPOvE/BPpeGUNQqtByI/88JQICNLVR/DhSye4qypjQv+xcWEuIq6At6cKkgStsXriCiWpmC8o7P1PRoYvO7dSzg412kVwUPrwzNrFfGeuPkj0RZTGWxloxGchrQ5t6yScMaT5R+3CDQ6IC6/a7vkTIse0FmLclMLCjq4mf7f8O3GUjPYm1w2bMsW5Wn/9odXz2yQiWBURC0l5KLjaVDiXlZ4iJJiyD6uyiTotfoP3nDNitIKLQhi22xX8apXTqgsoBAFCK+j4nPDz+s78I28Qg18ZgY3OszgrLTxT+8qhz1iUgCNSHKZKn1DhOpV93b4z1MrFjNqNdu5Bc2u9SFcUjEZBqyH0x7FOjWF0zBP6PBgwPkDHYXIiN2zzOqw7vRyC93vlcJCHEcMdiw+/d/a92zVt39KD36JpIdZ6rlMG0hRd90DhEER+NNAgj1R0qNVj2MbvU9RYOJuJAakKe57LhPGXAe+XpPPd1SJ2nuTern1LgMBclo2He4fGErUQnkNdVQXEQccPg0ZqOnIHueATNaQG0nWTlp6vZ1n7W6m15sCaOJhqKnLXNIYSqsNYB2qByE2IjeQ8f38TGcUkHJNhxJuZn5AXnGMfS9IeXvheOcc3k2LO0RJnz7D3ZnxvPv3KiwAOUYnHdW8uKYyeKSbcBJSqrstYDfc8GXtgL6Nn1HlCNk5fupf
 Hn3tOcVX
 9OfwcDwcopjukGWcFTyZqFR8Q887q+5pDJ9bUbQCLbejD1sVNY0bvtFphA5/467f6UXwW/OugdL1tjdKTh6/DK/NrvQBT4/y+Z81e+adYFHFhIQulF2TnRsXLNICBGLhLOCgCm1wHsQ3EfJx5xVLH4I/WtCacMKr5WWurtE7aS2mzfdy1tq97fijxzyZ0H0ultNsO3M9iazbUNdxUQFcC4A7e1XMQsspnVD8a6ChDb3EIL0vxOXm9Ne9nRp8AxwJ+Zu+uE5rM62WYLXy6VIHFg28Zzri3KBAhHKToJV14GR/3Vwlf+wvQmWVKi9tyfZsSesZEBO/ONQL0m6pG2b26ZnbJWGup4qb5ySi1LuiRCEXesYryb1m11qBpkaFoiBhw5h+6/Vr+lHHjdvIvMiR76KgwsD6+UKBgskEYmC6eLj2zLEJykD0fJ/fPrgfrcWch+EqzXFbpOBDWlK5afVQQY0dWnKlAx/yJyI595d3yY/Jg8r0m1KaYKiCk/dps2eBMnglKmMqF9ZtweVmQgqQKsFbpEOqlFR+P/ac2jgcKACPG1Ms1pVNb7Zyfe1mq00hgdSJNOco9BeZWtY6PVL/8KG2uN9tcd4qxPiLO7HB6Yy9l4zx91YEW5lcHebhYXcataPMb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Xe/TTM backup reclaim can be extremely expensive under fragmentation
pressure as reclaim may migrate or destroy actively used GPU working
sets despite the system still having substantial free memory available.

Under high-order opportunistic reclaim, repeatedly backing up GPU
memory can lead to reclaim/rebind ping-pong behavior where active GPU
working sets are continuously torn down and reconstructed without
materially improving allocation success.

Use the new shrink_control::opportunistic_compaction hint to avoid Xe
backup reclaim during fragmentation-driven high-order reclaim attempts.
In this mode the shrinker skips advertising backup-backed reclaimable
memory and avoids initiating backup operations entirely.

Order-0 and non-opportunistic reclaim behavior remain unchanged, so
Xe backup reclaim still participates normally during genuine memory
pressure.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
---
 drivers/gpu/drm/xe/xe_shrinker.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_shrinker.c b/drivers/gpu/drm/xe/xe_shrinker.c
index 83374cd57660..4646b0f5b82b 100644
--- a/drivers/gpu/drm/xe/xe_shrinker.c
+++ b/drivers/gpu/drm/xe/xe_shrinker.c
@@ -139,10 +139,17 @@ static unsigned long
 xe_shrinker_count(struct shrinker *shrink, struct shrink_control *sc)
 {
 	struct xe_shrinker *shrinker = to_xe_shrinker(shrink);
-	unsigned long num_pages;
+	unsigned long num_pages = 0;
 	bool can_backup = !!(sc->gfp_mask & __GFP_FS);
 
-	num_pages = ttm_backup_bytes_avail() >> PAGE_SHIFT;
+	/*
+	 * Skip accounting backup-able pages when this is an opportunistic
+	 * high-order pass: TTM backup work shrinks at native page granularity
+	 * and is unlikely to produce the contiguous block the caller wants,
+	 * so don't advertise it as reclaimable for this hint.
+	 */
+	if (!sc->order || !sc->opportunistic_compaction)
+		num_pages = ttm_backup_bytes_avail() >> PAGE_SHIFT;
 	read_lock(&shrinker->lock);
 
 	if (can_backup)
@@ -233,7 +240,14 @@ static unsigned long xe_shrinker_scan(struct shrinker *shrink, struct shrink_con
 	}
 
 	sc->nr_scanned = nr_scanned;
-	if (nr_scanned >= nr_to_scan || !can_backup)
+	/*
+	 * Stop after the purge pass for opportunistic high-order reclaim:
+	 * the subsequent backup/writeback pass works at native page order
+	 * and is unlikely to free a contiguous high-order block, so doing
+	 * it here would just churn working sets for no compaction benefit.
+	 */
+	if (nr_scanned >= nr_to_scan || !can_backup ||
+	    (sc->order && sc->opportunistic_compaction))
 		goto out;
 
 	/* If we didn't wake before, try to do it now if needed. */
-- 
2.34.1


