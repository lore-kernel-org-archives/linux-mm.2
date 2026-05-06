Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11275CD3427
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 03:33:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9460E6B0096; Tue,  5 May 2026 23:33:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CE796B009B; Tue,  5 May 2026 23:33:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 796A26B0099; Tue,  5 May 2026 23:33:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 63B836B0095
	for <linux-mm@kvack.org>; Tue,  5 May 2026 23:33:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 03EAC406E8
	for <linux-mm@kvack.org>; Wed,  6 May 2026 03:33:14 +0000 (UTC)
X-FDA: 84735574350.27.5BB17F5
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf29.hostedemail.com (Postfix) with ESMTP id C9A31120007
	for <linux-mm@kvack.org>; Wed,  6 May 2026 03:33:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RzHKAiSz;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=matthew.brost@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778038393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qqNH3T+gCWiKBUwOcOaFW7LMdwb6Ktz+0gk8u+xZ7Y4=;
	b=wd5j88C+Ko+fC4iJa07fnczcR/xZEnlbgFVA2auDS2GsNDuN5fJ4LfYpH3G/0bUYJOUNjM
	BYgnEHCNdIAUoGd28zVbs1o+CyQ0q7sM4wZgPNsRqh8Q+0JqMBYibEj6pwfw463MZml0GS
	GAr2E5uRA1G887i6ZXxj37Q54XRKWbY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778038393; a=rsa-sha256;
	cv=none;
	b=BOe7rfnICnjpVw8XeK+enXhkWk/RMw7IHDt0NdTD2yvyfAoupBw+QaMztfG/sCtTkW+p32
	3rlsa0K6aF14HM9dW8u4MKPrQYbOPQBbnlo4H3QP+PhKLoz5g0G/IgnnT4E+6DczIGa9ZC
	42D/AsT1dUlWyvdxfnLcWn1YwC/bgxY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RzHKAiSz;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=matthew.brost@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778038393; x=1809574393;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=D1dzh1JcLACqd1t8TArobnoPQTlNfPM6sRXopWPpBeA=;
  b=RzHKAiSzBsEB/CeqipzxqpKdN+uvjb0AiohJIkrkPKpMqxTRHvDz4hHZ
   SCEv71exX6AQ0DYgKgC9palkRuHtZNRLXOF0L2+FHEXwAHB62t9tD8DGn
   3Iz0X9UScldi1Hlex03M6O8xFHY5K3RWgD9DzrDYakw+tgEVL7+8k5NnI
   tSO4w1rU62m+LUO0yaebCsm9eyWZZ7t2qlIKwYNBk/dvd/ebZvEt+CfX9
   oUN4qBz16W9dE/uAPV1CNnOxFRkTkcs+Mz9wGg2KPlKHd3dJs3W3ugQdV
   LOWocc6fwIxnIejThwkgJV6RexMzrzUVIDnX2mraE3A0YA2/FnFmZCIcV
   A==;
X-CSE-ConnectionGUID: mNrbn3Y1QjOD7SrbF5kNgg==
X-CSE-MsgGUID: da3tdcSmR4G5Xl+Y52IQwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11777"; a="78829072"
X-IronPort-AV: E=Sophos;i="6.23,218,1770624000"; 
   d="scan'208";a="78829072"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 20:33:07 -0700
X-CSE-ConnectionGUID: bOHXU/EHQYKUuqtDmh0h9A==
X-CSE-MsgGUID: VN7DFizKTnCFe1wgehyRvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,218,1770624000"; 
   d="scan'208";a="266342153"
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
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Carlos Santa <carlos.santa@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>
Subject: [PATCH v5 4/5] drm/xe: Set TTM device beneficial_order to 9 (2M)
Date: Tue,  5 May 2026 20:32:59 -0700
Message-Id: <20260506033300.3534883-5-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260506033300.3534883-1-matthew.brost@intel.com>
References: <20260506033300.3534883-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C9A31120007
X-Stat-Signature: hjuuyoo15ctdcs6abkgqjynfoqi8ty6e
X-Rspam-User: 
X-HE-Tag: 1778038392-674849
X-HE-Meta: U2FsdGVkX1+9TecMAt0dbCXY71F3179G+YZaqb4I+WU3HmqVJQF2mBxr45KkO4xQ4Er/g57hR+nX/gaihzXl7oe35ZNUmbz2dBo2b+bgs4YUQMxJZu2xzF5zZKqbuXTQjebATo/uUxlDErxcOOJgews5sQQ/9BlIUPu2SGlbEl/5B3bhyKDp0j6ljMtSc8XuPWJRFyanG2gCBgR0TTw6+Jz9w5v4/cyUz1XVL71KL6KPHTMGQ8YfXNFquLIMINbFPz/eLJArbcOxO+317dp7bE+OKZxgLxzEhpuBfBSMayLAxfMEdR1BaQXJOIMHZNYsgQ5C2DbYmWl85TxGbFxIzGbTFBOV0heNbSu/DOSD3gcuYfbnkaGReJ11J2jZ8woK1PUvisEWOt0skPwEV38sxkSiWf3O0jCLsCDB9rzTLOk78IPkG1K9V0z3DXbRASJNxg7ry2VhijjsTUGnBSMQEn1I9RJNh3WOMGGoq+mi9hBS68QCy7skpC/+YXJ7rww2FJamylTulipxPNzWO198a/2oWtsAYr74tkBBvKuT/tBf55NkxLMQk02u1jFxgoGN1Jv9L28HMVwfcBJH6MgtR9MReP9Qy+A7y8TBuY6Gub5qcBsWL1MPnevS/TMqT9YlJeXeUK5nGj/n1GAste7cPsZNaIDEtn5yAql+xGEgID3gqPcEvTg46CpNKuJobl/V8Oe/BIY0nPACBMqOkOneZ5ugfP5w/0UmxkvDEqiT4gLKQ9LdtJ0LNPs+rN31xfAJgUm9hF16epXQZmzUe4dAyOd6b/zuVxY4Bwyrajq8Ltj4Fgz2xv2PYo2MSQEvHwcpvoRKOyxFjsnpz31J5z37WcU+yI57E8s+I+hLpDBA9cbDUdlgMi8jxOQRawviY/uEJsIxIbPKeIs76iFim5u5o6yJJ5JDxkGNylTy9mSpeI62+Cf149fcL1w4O+vHoGWv2uFnhpYAtim6cqRpGEa
 eOAeLyyI
 j9t+rvMsqIwBGchMlBMDgEL+26YyNbtsqgtBOqXB6b8gbCLnD0qJWeuiHTsn2opvJaADp4lNZJenjLTYICz3DH4qJcM2ZEQifwrWrV3itO5lAjlUcwqaXjZVh4nEdV0lxJMhqElV47cYTP/Y1OuVZnbEJZ841ZbHAByOtgGpz0OJH5FOFLWiWYDLaOlbFGyDtkWBntYjkpyrt2TuqrDrG7HVesfo+9Tm6ssHRpDgcdfkGce0c/6FRvcia2moyPvAO0cETzIvzLjAUGHuwSkcO+rBxy0CebWviLR7f5saQJgsrOZEJ0Q1f+x7eUWDbH7fY9eWJ4E8VwnpSfv48DdMiuGOB3xKcZvXLbZaUqe/Ydw1Wu0BrtkH/MUyS/g+46+F7nISi1V/RI4Y+myTiUAmtQo/tO52SdVXtYRvTj8uG/XEvo3yOayP81iY05FpxKbFLlV10DH8bk9w/Qt6SmLxsUDXrIamS1oq9RYhtz17/H5X7wuBJ90D5+In1IIpi6aw7KOQQFuGqkXri0McsMsMUz/YCUJKrGMoiRWLeva1/V+MiOM3jCafvgGZtG4mE2Szlv537vXPqggI5BYFsHCnf0tnKxE/ez5CwYtes1IZTmxAh2cP+zfMDEMWNnprS7zmoBJl+uS1ZhmQZow3mB9W4ixPZrDTvrAXRnfuFOV+6L6YJBus=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Set the TTM device beneficial_order to 9 (2M), which is the sweet
spot for Xe when attempting reclaim on system memory BOs, as it matches
the large GPU page size. This ensures reclaim is attempted at the most
effective order for the driver.

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
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Carlos Santa <carlos.santa@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
---
 drivers/gpu/drm/xe/xe_device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_device.c b/drivers/gpu/drm/xe/xe_device.c
index 4b45b617a039..3f719ab08d1c 100644
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -500,7 +500,8 @@ struct xe_device *xe_device_create(struct pci_dev *pdev,
 
 	err = ttm_device_init(&xe->ttm, &xe_ttm_funcs, xe->drm.dev,
 			      xe->drm.anon_inode->i_mapping,
-			      xe->drm.vma_offset_manager, 0);
+			      xe->drm.vma_offset_manager,
+			      TTM_ALLOCATION_POOL_BENEFICIAL_ORDER(get_order(SZ_2M)));
 	if (WARN_ON(err))
 		return ERR_PTR(err);
 
-- 
2.34.1


