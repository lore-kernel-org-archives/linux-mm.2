Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED2B8CD3440
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 03:33:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA1DC6B0092; Tue,  5 May 2026 23:33:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C032E6B0093; Tue,  5 May 2026 23:33:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96B9A6B0096; Tue,  5 May 2026 23:33:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 775D46B0092
	for <linux-mm@kvack.org>; Tue,  5 May 2026 23:33:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1D0608B8EA
	for <linux-mm@kvack.org>; Wed,  6 May 2026 03:33:14 +0000 (UTC)
X-FDA: 84735574308.15.ADAA9E5
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf01.hostedemail.com (Postfix) with ESMTP id EF9584000B
	for <linux-mm@kvack.org>; Wed,  6 May 2026 03:33:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RfDzPNpm;
	spf=pass (imf01.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778038392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uz8bIqEAYJBqCTXIHLE2rdWcmgrujJovnHVjJFamBB4=;
	b=ExzHSzsWlS7Ms1dV1YAzP/SKx1vcjdCfnN2dZ+5/9lfqfl2Se0BRSXmi6tAQbn+/lRxgis
	lH5ID7rWCvPZFSgr+zA2i1WvdL5tpYAuRruY9a/YrGuLMOQrXUqoUWkyfi9r7ztQawhwbF
	V1LQNItl6U068hEL8Hbs25oyTVeQ8u0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RfDzPNpm;
	spf=pass (imf01.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778038392; a=rsa-sha256;
	cv=none;
	b=SGkjMO83OAADon3CXQTBtfcr7DZ0Uv1nnI4quLszMgIemPxHcXJhCoVkh0yoIZ0rGvnmjx
	MI5FLD2OxkngAbLvXShM2UH/ya7dUXXADXq5me1w71sgJ3UTZUty79spb74EpOafJ8+6+J
	ITE0Z0+4N7CpXPj0+vje4GmGU+BBdU4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778038393; x=1809574393;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fhvCwpOOerNDSxVfaQALugyDzdK6DreUrRK4L1ox3PU=;
  b=RfDzPNpmaWQN7tkgv8ZKFYlpw5t0wYE08TCLRA1+jlLFR/+3p9AhZ7Ir
   o6FGpy7G3n3KAT+6ZBkuURDSNMvUAcXl1PjClSM/cukG4Z9RsVrmfCO/e
   wtY/p3IRO9E0ppkokAgcXRBI3QOsNhEqKOc6TTtDDFj/bu3gzLahQGYPW
   otbLEfNUZ2GDuctvQ4v17nXGzah2hpd4MkIm1UxUZkHFc5dkLc0kamUo8
   oA6OdGO+vQZ5RA5TI6V4i5xVCa12NS+yJbjjUATgSFl+2uhx1XRY8xf1a
   QOzFnD/goD3yTrYwYGTpO+0AxW1XlYPwS4HoEc9CSl/mIDr0xEByafTYR
   w==;
X-CSE-ConnectionGUID: bh6IZH9zTsKtKWNUgBQ19A==
X-CSE-MsgGUID: hIeUjIh3Q32JLIVYN5GVQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11777"; a="78829055"
X-IronPort-AV: E=Sophos;i="6.23,218,1770624000"; 
   d="scan'208";a="78829055"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 20:33:07 -0700
X-CSE-ConnectionGUID: lHxy+04KTjG2WxqjseVy6w==
X-CSE-MsgGUID: ukmuUaJjRm62am4oFugUjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,218,1770624000"; 
   d="scan'208";a="266342150"
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
	linux-kernel@vger.kernel.org,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Carlos Santa <carlos.santa@intel.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Daniel Colascione <dancol@dancol.org>,
	Andi Shyti <andi.shyti@linux.intel.com>
Subject: [PATCH v5 3/5] drm/ttm: Issue direct reclaim at beneficial_order
Date: Tue,  5 May 2026 20:32:58 -0700
Message-Id: <20260506033300.3534883-4-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260506033300.3534883-1-matthew.brost@intel.com>
References: <20260506033300.3534883-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6t3n75ka3h6gx9fhapktn76y5yjhcqkc
X-Rspamd-Queue-Id: EF9584000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778038391-245082
X-HE-Meta: U2FsdGVkX1+31q98QGuqoRvBURI+eN6bg5w0bBV76vRogJSZlu7q9UMC6Mc11p5QfYmv6OUyoRa/3ZVuZXoxNTBnvOyywwoQZfARjqMigl4FBkZnPi4pt8GUB3/l6+tji0oUqCgU4NY3mRIjea4hN7HFx1G2i4Au/A+owoJvv2rZwbOkTwfpEtccuMpBpoeh2IjAtkXPsbHw8SWn6GIY6xxMx2jL6MstuQXPV+J7ptZoMpQyDS8uq/kPR5tXWtvyt9eRU1LonEeIse1h/qwXhxs1ie9d79QVN4apaJrp3BfYPH04PcQt8AAi/bIWUnJhncolq0doV5Tzw9y7/GFg/IrcEBqIQMb9gEL88xxv59HLBaVGp6v8fzwZ1eIVriNNWVvqtZv4FTxL+R1AE71ccNDS9r/AuOwJ6TQVBz3ukc1jdaYO9LZHTk8oR4lubmC6CBYNnSeOZluHqYNz8lIHav2kLI6Df1BsyoR4zlyWAC5FdrqJn32t5ObB5PGdGfR55TF6D2/lI9TAk+xC9VxXIZguxx33+ZEmesLWm1feEM8QiyIHbt7UZvVGfxsxPUpoJ13fOVt/aNNSxG9l3umHbOXChcuLx7pufcgLfpOo6aE6WW9qac6p1zx9FpeekFnjQLZWIM2NtEruxrjrbGQVs+i1UdWFXycrMUrJ8qUE/3vTvl7DpzmuNHug/aBuRFvy3rO+4RjYrXXn3SpECHjuKVOj9RQBi7h4jy8V6plUQg8+6cnC8Qp0/6fgQlY3XrKbw+FBd6Fzaq6pXVvI7RtwShFb/xjv7kFcEW2YtwTH4qQu7l5avwf3AAtJioFC+H4x1ctYDx0moQFuUK0Od/DbU8uz5EQJuelQ8jcwOOK2Q6fImDNYhAr+kIFWP6se/w5KURu8fOduy4SUSZHpXp6mhfZWcTaNHS9qFF/JBVJ2EsqPhkKX7glphQl0C9sdWrohWsaKJwQ0QLtYAJ5nkpO
 CscVVbWh
 s+DoprrsNWtIrt+qzxp4YrCA1Ii8xIEk0LVq9eqb39mDEtROSW3m5FYnc8lFuYQ9pSlw313bU944ZWMMYFf1E44Nhq6sZXDRLVu0nhHjGzTLcuP66icvqQDdvIf/EoTtI8a/JyL5UqYZqRACmCORixSt6Mpl+vScGsdxKGkVxOyxpgOqPWt6125h5cRTXCYRByc5GvFPyp+oXBihssXUnhyJ8ca3Aw5EzVs+JPOcF8JSSlSjH/Ds3CaaEU8Imkqq98bjz9AcODDaefLlNt5+8nKvbCMsisp7CftWYXNRszz1WVOMfcmO263cyXam6vUDMhnLnU7mQSWTBBwN4tHbZwxWa40Htc7wbfnVwzL8WwDr9RLmuuRkyjrh7ZNfCkmwqQJ/HDBVPJIyTVv2+OQ8sB69mMzE50U9fCET7bBrbyrljn9nr4OSOXMXbf3lpaolEXehgN1woSQoQAekw++rt1IatrCLMFkLQf40QgKTxcG8GQ7shtc5Myz6bJNkwCfxKlhNHBPev9/YYuk9QYk1xTB2Kpm2QnFSLgsgnOv6Ab9LBhjTASVWIkcZFDVvPrz8xiNUiQcKkFIE/k61qol23HPmCT+5JLfVuWCVjmwygY6PwOWpDxJpdE2wiUly6eXV25vWCv+lTQ8h1vp1QPZnqjflVwZCfOJFS+MnPjsRMAiYCjEngOtxIGy00uUSLWG+k/2nA3+OOoQEL6JgSWpYIsckqCzWZD7kZxOLRMsvh0Ot/TfXmT5U+HjxKRK4+CyH5WXSmEbHOwtk+IkzPvJPYTistgQEu5AdcmYoCyDZ1H/m27HJuda+g71z/cytJjRkoHaJ8Z9J6hbOP5M8gdTuUmCaawzvTb3BTJGLocUu5/Jlai8mSoO/9+pldTMz/4HYfIiH0/Qei8jyh1aI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Triggering kswap at an order higher than beneficial_order makes little
sense, as the driver has already indicated the optimal order at which
reclaim is effective. Similarly, issuing direct reclaim or triggering
kswap at a lower order than beneficial_order is ineffective, since the
driver does not benefit from reclaiming lower-order pages.

As a result, direct reclaim should only be issued with __GFP_NORETRY at
exactly beneficial_order, or as a fallback, direct reclaim without
__GFP_NORETRY at order 0 when failure is not an option.

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
Cc: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Carlos Santa <carlos.santa@intel.com>
Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Huang Rui <ray.huang@amd.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
CC: dri-devel@lists.freedesktop.org
Cc: Daniel Colascione <dancol@dancol.org>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Christian Koenig <christian.koenig@amd.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
---
 drivers/gpu/drm/ttm/ttm_pool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_pool.c b/drivers/gpu/drm/ttm/ttm_pool.c
index 278bbe7a11ad..e76c3a5c67bd 100644
--- a/drivers/gpu/drm/ttm/ttm_pool.c
+++ b/drivers/gpu/drm/ttm/ttm_pool.c
@@ -165,8 +165,8 @@ static struct page *ttm_pool_alloc_page(struct ttm_pool *pool, gfp_t gfp_flags,
 	 * Do not add latency to the allocation path for allocations orders
 	 * device tolds us do not bring them additional performance gains.
 	 */
-	if (beneficial_order && order > beneficial_order)
-		gfp_flags &= ~__GFP_DIRECT_RECLAIM;
+	if (order && beneficial_order && order != beneficial_order)
+		gfp_flags &= ~__GFP_RECLAIM;
 
 	if (!ttm_pool_uses_dma_alloc(pool)) {
 		p = alloc_pages_node(pool->nid, gfp_flags, order);
-- 
2.34.1


