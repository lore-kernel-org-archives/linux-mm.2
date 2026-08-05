Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16D48C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 23:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D91486B0096; Wed,  5 Aug 2026 19:10:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D41B06B0098; Wed,  5 Aug 2026 19:10:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C08F26B0099; Wed,  5 Aug 2026 19:10:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8CD5C6B0096
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:10:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EC379405F8
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 23:10:58 +0000 (UTC)
X-FDA: 85068762996.24.4D7E69A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf22.hostedemail.com (Postfix) with ESMTP id A217CC000D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 23:10:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="BqPaP//N";
	spf=pass (imf22.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785971454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KWswUo8z/cF0Cfizf1MovmWZZmjLpwbbTv/nvIZFLUo=;
	b=ctcwLF0YAys+4xWOmtQTaCbstNM229WS4Xg8w6gd/B9hg8ybsvOtqjPj0NEaGjzixUz5Dz
	dbA5nM67xfLa3UE1skd4Lygs8NSGMWUZy3iuNWAcoNAaAwFpC/cjtK7H9QizT9/08aaxBq
	FrvlY1AISqFvKoP1wdfOcbJ5Drvxf8g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785971454;
	b=2csRX8gUYeQsIxIK2J3+A+IW7gMNfJqkpzE5qemtmzTBto6DMqXxsxz23Nyb8+uvC22drl
	Ln6OLLmdsSvI6J3aJG21sPcLS/fx9jSMAPkIUPTmOSYBVhg0sljWvEnkFMaG92wm907rGP
	RTPJk2HCpW3c0T6bKSXqch5WiTx8A4k=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="BqPaP//N";
	spf=pass (imf22.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785971453; x=1817507453;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0lyTOIeWDhVM9+t9ZjBtctLh8tev93wX9ypZPs331q0=;
  b=BqPaP//NLpPI6kPS+RqooSAxH8YDh+ShwyowaxijWUe3D/pOM1KUPgA6
   9x21quCQPYKeCamEXcv/qAQga4YqOErfHabi5hcgJ/jmdIj4uA8kJERYy
   qFQh3JtM0sRcvsdZ1VHoqqNFdl0wm1GR1SoO1ecfyMk8pb79mwB2qyMAK
   N7Us1xK6i9vAZtlR1G796SauTW6iBqPNqMif/8n89D3yAqG6Oa2JDoJx/
   HChcCo8u+mMY0ZBEERRZZxAo8x8Xk/u6vd7s+FYtJF/m9XitygeFxBKlQ
   hRiwZpf2uTrJwtK7AO0jMy8SvseOyAvR/xJw0Og6DmoIgR1Dt9A6qPSPg
   g==;
X-CSE-ConnectionGUID: FWi4FdFrS8Wfw9VYKK4hZA==
X-CSE-MsgGUID: FU95lFRHSB+C+GFEe5X7JA==
X-IronPort-AV: E=McAfee;i="6800,10657,11866"; a="90376875"
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="90376875"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 16:10:51 -0700
X-CSE-ConnectionGUID: ioLIX4KjSZeTqDkxaD3SeA==
X-CSE-MsgGUID: 7XkeOWqkTcmRm/99NBgSrg==
X-ExtLoop1: 1
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 16:10:50 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Sashiko <sashiko-bot@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Francois Dugast <francois.dugast@intel.com>,
	stable@vger.kernel.org
Subject: [PATCH v3 4/6] drm/pagemap: dma-unmap pages before handling migration errors
Date: Wed,  5 Aug 2026 16:10:39 -0700
Message-Id: <20260805231041.3791771-5-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260805231041.3791771-1-matthew.brost@intel.com>
References: <20260805231041.3791771-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A217CC000D
X-Stat-Signature: 46mrx8tic73fctnf8kxxgpa65k5zu4y6
X-Rspam-User: 
X-HE-Tag: 1785971453-449815
X-HE-Meta: U2FsdGVkX1+KLmO301mfe8C+JwmoHza4WdOnqD7A+spDlMYrOh6Myz4qOcUlgWNDARGRW3RJoSyEXZL3e3Lo/RrUls4AjX+J6L8Jk6I4FOGVROCvs2/58KcBGiaapbrq+sH8jHv1WlT2j1GgDtGzxIvk7r+mz4pgqP+pAeJm4KL2A46m3ESlOMJnwI+/2q7qUyWPPeUhsXi4sgs+WKQhvHXjPLiOn6SXZ6jXZXt8VUj9A97aiL9nRPteN4f8zyYNEyiNgpsW/hL51ymdx2sa3S6Cvfy7YDc724XSbuGoDxfiqNisuZ5E2dm7IxI9S5x8o1gi5AOuX98nwKIGQc2NbQHbsrlMrUeGcxfhqakjspwU+8dOHTbVVC0gLibWgr76z6HR9X1nS+SUqZTXDwqGn4RwiTVB/43FCt7vjZPadDVhZAcCQrEmDv0PIHlSRG0mWndi/THJQnzfz3bXzV6rh097NV/Hxbmls2HS0+ivwKbYco2ft9duKEediwRZW85GapMx01J9pYQNA/kIYK/r7kKgghJg7HyXD8iyj5RYyIMrHgSK2WaiXmJoFx2TVoW/C0BF5JhePkpNOIPv9YYwEG42Z4zk6v/mcTRzUFEUO0jQMKbJknN/0+y0mXHRQuUorNkPdtIjs2LeUpbNsc3rmoCzgbvEBFudG9NzPc7plkDQ0ok4uEFI+WqAHLtiWuj4Q/e7CuPynOUTUeYUxdPcO1xCV5Zzzz9YgS3tGy6l872Oz3R0ipCXD1hsAw9BBgxEBjat3vq+N25u9eJfMfbGdGGbY7bedcyDRES3jZTLG6OXyqa7Lf9xuesAyK8vsH+eHARwvJ2DZovC/4heU6wDLdfq5Tw6cIGON4/UUsBQzWx5h1zq0kK8l40AvzIufyiGFJbAPUUhfRtMk1tlMfaa48hBANW6EicWndPpda+YNtEVVBzLPoouFI3YeyyHpBAdtTF69P0+C41Wm7V+q1h
 rd5byfEA
 DmaTjFYtjGFiGVFbsuivjtAZOsT4Vlw+0T7GKPIJkft8rqDsCCzGQJ4ZUa1UiMGU3sivHYr8NAO7z9KMa7rt9VmPYXc+qDPsRmQz3RsXwN5Y/tDYSOTZzihDMCOHZrpcCW3GCHZNber8jJ4EDHp3uvQek9a2qun8rTZO1ESbzH8IDTK4zRqiJvB1//KrcxmreBqTJzyHXH62ESdtAW8r9WOoZWrf7ESYdYiFTcf/Dl5z49TbL23bcpviKB/ojEcbeq0oLa9lrnD+hwY8mH9GmYl+UTtN5aP/94IGLU61YmDLNlavwYevmrV1WagCGOrVIcFtXINyOvxbkE4M96lgSOZkm1zfaz9UbGsHeINLHTtAyI0QOHI/3nLBWe9bx0MMWcC/6mEjVBocSuFffUUVmJpwbwGidZOQqkKubdZ1vr3pu5BJKo+FsqiQr4+gEuHf5U+Zd7IfvgZHYODqFc+s4j2uD+Oef2cOWUdaEt5O3y0WJ2OOgl0tn8igX397OOT5qFAnwEILzViZpI1QD0YbozOV0bSUn14weexa7dGjk9CWOPwKgIq1+ykJN9LiC/0D/M5uolN/r7Y/3a0AkVOvNbZPq0ICvvWq+2KqlT6l3/dvT001C+SwVbI1U4hFlK6Whzk3Fu8rmFGI0DnqWTByA50EnWq836yr5J57SvQEDI6YI+11K458fc5os7dRD3JCSQ3pInDNph6mbPPBGrhdQwsx8YSVuf42lBTnYV9ftac8+L8Vji7Km0NBMSTVGokCB+kibetc2+qgctTEKfedbcmWILiMdgsVDQInW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

drm_pagemap_migrate_unmap_pages() relies on the pages array to determine
which pages require DMA unmapping. However,
drm_pagemap_migration_unlock_put_pages() clears the array as part of its
cleanup, leaving drm_pagemap_migrate_unmap_pages() with no valid page
information if it is called afterward.

Call drm_pagemap_migrate_unmap_pages() before
drm_pagemap_migration_unlock_put_pages() so the pages array remains
valid during DMA unmapping.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: f86ad0ed620c ("drm/gpusvm, drm/pagemap: Move migration functionality to drm_pagemap")
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
---
 drivers/gpu/drm/drm_pagemap.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/drm_pagemap.c b/drivers/gpu/drm/drm_pagemap.c
index 892b325fa99b..aef1fcea663d 100644
--- a/drivers/gpu/drm/drm_pagemap.c
+++ b/drivers/gpu/drm/drm_pagemap.c
@@ -1175,12 +1175,12 @@ int drm_pagemap_evict_to_ram(struct drm_pagemap_devmem *devmem_allocation)
 		goto err_finalize;
 
 err_finalize:
+	drm_pagemap_migrate_unmap_pages(devmem_allocation->dev, pagemap_addr, dst, npages,
+					DMA_FROM_DEVICE, &state);
 	if (err)
 		drm_pagemap_migration_unlock_put_pages(npages, dst);
 	migrate_device_pages(src, dst, npages);
 	migrate_device_finalize(src, dst, npages);
-	drm_pagemap_migrate_unmap_pages(devmem_allocation->dev, pagemap_addr, dst, npages,
-					DMA_FROM_DEVICE, &state);
 
 err_free:
 	kvfree(buf);
@@ -1305,14 +1305,14 @@ static int __drm_pagemap_migrate_to_ram(struct vm_area_struct *vas,
 		goto err_finalize;
 
 err_finalize:
-	if (err)
-		drm_pagemap_migration_unlock_put_pages(npages, migrate.dst);
-	migrate_vma_pages(&migrate);
-	migrate_vma_finalize(&migrate);
 	if (dev)
 		drm_pagemap_migrate_unmap_pages(dev, pagemap_addr, migrate.dst,
 						npages, DMA_FROM_DEVICE,
 						&state);
+	if (err)
+		drm_pagemap_migration_unlock_put_pages(npages, migrate.dst);
+	migrate_vma_pages(&migrate);
+	migrate_vma_finalize(&migrate);
 err_free:
 	kvfree(buf);
 err_out:
-- 
2.34.1


