Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E475C531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 10:09:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FAA26B00AF; Thu, 23 Jul 2026 06:09:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AB7F6B00B0; Thu, 23 Jul 2026 06:09:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C4CE6B00B1; Thu, 23 Jul 2026 06:09:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 30C426B00AF
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 06:09:15 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ADEB41C063E
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:09:14 +0000 (UTC)
X-FDA: 85019618628.22.478D4C7
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf31.hostedemail.com (Postfix) with ESMTP id 530E020007
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:09:12 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lKETDs2m;
	spf=pass (imf31.hostedemail.com: domain of arvind.yadav@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=arvind.yadav@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784801352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=T5/OOy9PepPZMF6ldXr0cCJHwqLGzbNL2lAXDRMQszE=;
	b=ymvYCyHZlJ15qcHi3wL94SP7odC3knFqemyirEKuX2k8mRx46mqY9WH4QjS5Wm9ZdgrG2I
	BPulxNUjHA2+KL/yT8wr2XMGJBcgyefmWwWaA8durCUyrdk5HYuNISARMpYGgHCcWi1z4y
	PERMqm4IfFxL33HapldWLQ65iTu0/zY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784801352;
	b=sp3zF0+r4S/5yKERQQ0m7RIvabVWB8MI0dpqcPbaxSh32tiNuuVHnewEFl0/Aqsyh9NvzG
	n45FbDP3vZrPRNhn+2bj1x/qrfrTVxEwYYtmBJXtHCOtk68eBxi55lZyTnXkIyTYDqjcqO
	CknmoQDXTBHptU9vVp+QJ8KPjYcRsOA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lKETDs2m;
	spf=pass (imf31.hostedemail.com: domain of arvind.yadav@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=arvind.yadav@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784801352; x=1816337352;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Pd+h33cBRehgFOQwH2D+JNwQdZnkSg99+8xh6je/0rQ=;
  b=lKETDs2mfR2PNRPDXmS5JpqCRCb172L0IbU3oknLehRFTAtvfNPPBwf0
   +Y/9SfH4fKzijA1ux3I7tbcdq7gK5Rl/IMfXY5seVod8W8OWvrIFHpIrX
   2ckonGY7iplwuQ8Ar47O41yQrXTLAYoQyXlQGDB6I3ZBMR9bYqbCi3xaQ
   XDusr7NCuIZnQj5jObzWH0gbu8iD9iHAXCebsvE0KDwkNCDwMZA5mnVmF
   pmcBXCk1x9ltqGgcHAEFYVwTKFlY8t3kBlsm1qKjH2HeooPbNrDHMN/uL
   zPjxyW1n6hyJMhYuAaWYYpaAAu5tRaRqkacNOl0iFs/b+9IWPTHP+0VvW
   A==;
X-CSE-ConnectionGUID: zju87f5JQoirxG7cYMRAag==
X-CSE-MsgGUID: mu3dSfxeT5+ZIAZ9a1s2ng==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="96826892"
X-IronPort-AV: E=Sophos;i="6.25,180,1779174000"; 
   d="scan'208";a="96826892"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 03:09:11 -0700
X-CSE-ConnectionGUID: nMq8FJj4SZmLDhwzODYFKA==
X-CSE-MsgGUID: e/1xGqGiSbGpXSOyn4peDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,180,1779174000"; 
   d="scan'208";a="254018301"
Received: from varungup-desk.iind.intel.com ([10.190.238.71])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 03:09:07 -0700
From: Arvind Yadav <arvind.yadav@intel.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	ziy@nvidia.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com
Subject: [PATCH] mm/migrate_device: Clear stale mapping after freeing swapcache
Date: Thu, 23 Jul 2026 15:38:46 +0530
Message-ID: <20260723100846.1880865-1-arvind.yadav@intel.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 530E020007
X-Stat-Signature: y3ucq48efxux5y5nahqghs9jqzkwc91h
X-HE-Tag: 1784801352-770982
X-HE-Meta: U2FsdGVkX1++fhsYl0GDBiVNH8uqmAYhuBWSDQMaUiarVbxieFX/LAY/mk7C55obPKmqHl1pEeUE1QljOHRd4+EUa7cNkhW8aNeaaxSopKRwQukgaabgB24VEbVtpie71HYbNmROMd21Wa9FqubfwqfE0gPYDOD9vP26UO44iOGNmqLTYBWWsd4Oa3V1LOXmdXCBnLplTYJM4Tfoa33rWasw0tPCSDpTCSA2DM2WhtmJ65h+86XR49LnCHfas0CATtoPH0kIOWMPcp/LYjz5rV8sepbTjq4ViNDm6Lul3M1wTephTglasRrYvglBjZfH8zhRhP/QHUSq28ysv+ZaeNoZu2XsmhGxnNGNMAIgppK0UFQR0KpZZcexjtuBzOEcZJq20Sk20EesIHwx/JfTbmKZxH6tp0VsMb5dYe4MguNltx1dxzbEmrB/fu5QTerRJAN7FqixVjKIsrGSpk59gMhYFin+zq9pn3pRKq7X5QVP2dwqjdopSwzwgMINvsneDjBaGisqhIInVAkStpQ1t3lHKhyEq9MnN5DRWmtJrumwp1XLjmkGcNje7Qlwg+nFtT7DUO6/JhTs51KLrmNoCgcI3/ABbe/Oq+4S2J8Tux3CAHi+V/JA2pZs0IH98/Vkarm1kZPwDszVPZcwv1rGPb4g5ttJAlwoP5373zDSCx7pdJ5KxbI/nT/zM35z+MSPI80KkKftAySF6rh9ishOZY1Ah+34bGpJSQH4Gn8kO9RMggGe8c3q+pxNRpx3hChbac9YvZ2tOJ76iJP9LzG2TfD4iTHBmrthpToQZNX6/qR0+xKDNUiSoK9lH8FCIgANoShPgoMWMnFjV+8wfckrKiIaqCpzGmd0GcAYFo5Zg6Cf4XYQysIookScdeR6TT/BUQT+5oJ19xjAH3UFhSmEwRvRX/4zdI07sl5eWiK3TCLk9f+fq54K/NgJ+C+4VQeTf9eks1F9DAZSwJPlMmT
 A0aF40k4
 jnArAdjo1WDOptethhAcMUqTRhdJoRtMot7sdAYneN4+1AZRspAJhst2px83Q7NE1qffsoA9c3/dTCDSxq1EzzYs3FwLhR/56WpIRJQRc1IS+eaXXOhErzxIBIJW4ENOvOUUhwu0e1jhOhPO7BwhQLk+7oY7OjhpV/7I17xJl572WOvjjP236l/uPfLmq6JngF/9gSzMXhH1DOINVXjyALjhR3l2g0fBykQ+9dcvqm+PP0pX3E43RkV4dWFVM0KusO/XU3+QVB8uCQaAs3PM+dfL3vsE49HQhXFFlBLJjer4oswLH9dFjAbUEzBd5Zwa+K4lyR63trGVYlP1v7gnz9TITltqKtJ5Xt1bU0VOKmToS61QWlXQNzEmCAuigwLLtFn9irfCdl9bnRQIR03GcFJap4l8cIdnAjVSYplaofcepgc4HCluSqKaCqP0v8orfOiHNFxQ1T/SuI62gIGSW/e00tp3iPdK9dC6E71oOiRSFY6oBkuG8XnmtDQ2OgZGhBO9IICiwGd+7PypdZw4paoro2jHEkwUVeZbHaWqzajdyF8evQ1H2SdIxgWOyilacNKPb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__migrate_device_pages() reads the folio mapping before calling
folio_free_swap(). When folio_free_swap() succeeds, the folio is removed
from the swap cache, but the saved mapping still points to swap_space.

Passing the stale mapping to folio_migrate_mapping() makes it take the
mapped-folio path after the swapcache reference has been dropped. This can
cause an invalid swap_space lock access followed by a folio reference
count BUG.

Clear the saved mapping so the source is migrated as a mappingless
anonymous folio.

Fixes: df263d9a7dff ("mm/migrate_device: try to handle swapcache pages")
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Arvind Yadav <arvind.yadav@intel.com>
---
 mm/migrate_device.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 554754eb26ff..fa7fbacac514 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -1204,6 +1204,12 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 					src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
 					goto next;
 				}
+
+				/*
+				 * folio_free_swap() removed the folio from the swap
+				 * cache. Migrate it as a mappingless anonymous folio.
+				 */
+				mapping = NULL;
 			}
 		} else if (folio_is_zone_device(newfolio)) {
 			/*
-- 
2.43.0


