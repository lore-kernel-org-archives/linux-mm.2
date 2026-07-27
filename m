Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5C60C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 05:39:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BDB76B007B; Mon, 27 Jul 2026 01:39:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66E776B0088; Mon, 27 Jul 2026 01:39:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 585E66B008A; Mon, 27 Jul 2026 01:39:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 315BE6B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 01:39:40 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8C7E712059F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 05:39:39 +0000 (UTC)
X-FDA: 85033454478.01.A475D2B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf27.hostedemail.com (Postfix) with ESMTP id BC93240007
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 05:39:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Fc21pegP;
	spf=pass (imf27.hostedemail.com: domain of arvind.yadav@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=arvind.yadav@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785130777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dljhoEgryrcl5B5MMOnkwH3F+0fLuugR6tKLdOQcC6k=;
	b=B6Kfd+/ATeOriQbGbzQaOGNwfjr1lBXF6R2+FEAo2FMAzFxR8l80idOxv4QIMgdES4wTXs
	H/Ra4osgPMcXJ4iFijeGZHKbswkno4GEeatYgqa5wmKXKlCZhKrdqW70e3oD9gFbjQYy6Y
	r/+fSthlAFGCSW5KSM2wJ1tQR0/Ezow=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785130777;
	b=Pwc6StofQhoKom0JhnBm3PeBiEoh5YO84FwGirqG+Y5z8T5fFFZ4NYPHwWhMVOonmJQB/O
	xmGj2wFRYSKd8f4ukKKPB4YagTgqYtdCm9MiwrndezGQR0tdr16XjGp3MT4iwaY/jzg8Rt
	ZCDrR29ZUP0pfHGtIa/6EKXDlwpAWJQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Fc21pegP;
	spf=pass (imf27.hostedemail.com: domain of arvind.yadav@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=arvind.yadav@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785130776; x=1816666776;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HDQMhBtH34OPq5lrFLacROh5yCkQVDcx1Q3l8xNuW9k=;
  b=Fc21pegPS9GJY/ttqH3GpQ/D4QketDtSBa9EO7KxpxT5Ji3vmpdGLCOE
   pEyJY8ZztpVED8Sl1SeY36Z3leIh8Sq986cVCJNNtCOgQcmEoHabW0/Lk
   vPJh8GYBEGdHFGr5RVDLlSd9AQ2xwKHCtDqRpf8YMcuTQG5qtG7Z0Hkzh
   oN/P6kHIduVnhiofiOF5Yi+ZZA96mSc935T+Xmcx45hREusUqQdsFwyxv
   KB1NxA48apGJLW4zjGL8NT12DQo1P6cfwRHBpU+lpd9tq7RNk/CpLMurJ
   jlBQjRenQji5pG+/Qzm4OzqewQiRO6gw01yzEFhwVv4fj8AWZKMhfx0Kk
   g==;
X-CSE-ConnectionGUID: h+Mqggc6SjC92tj2PNX8VA==
X-CSE-MsgGUID: wXG3hpS8Qj6rb556c4oSzg==
X-IronPort-AV: E=McAfee;i="6800,10657,11857"; a="103103760"
X-IronPort-AV: E=Sophos;i="6.25,187,1779174000"; 
   d="scan'208";a="103103760"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2026 22:39:35 -0700
X-CSE-ConnectionGUID: 5U4I0bmySoueg33hEVzjuA==
X-CSE-MsgGUID: R/cRy4WSQ4WRwIr8Qa+36w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,187,1779174000"; 
   d="scan'208";a="259946469"
Received: from varungup-desk.iind.intel.com ([10.190.238.71])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2026 22:39:30 -0700
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
	apopple@nvidia.com,
	balbirs@nvidia.com
Subject: [PATCH v3] mm/migrate_device: Clear stale mapping after freeing swapcache
Date: Mon, 27 Jul 2026 11:09:20 +0530
Message-ID: <20260727053920.3494211-1-arvind.yadav@intel.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BC93240007
X-Stat-Signature: jonud5nk7j7t5qpnwwjmoudt9atzwobn
X-HE-Tag: 1785130775-687852
X-HE-Meta: U2FsdGVkX1/YN4QrqtBksB6+BingdGi0Er9ZiGXQM8Ah2kyWRsUePRI7hSONjRuCaJPzvzgN3I2ttFlR6PRNTyR//v3OWEVCessl/U7M6lm8sxrLK1PAd6blLPioa38il/YmwFWzZJqlsB4+hZUAb82kDpdqCrc3ZP3LmRfdB7INjgEWyqOdGBd/hpWH44pxSdhtoy0/V78uKan5wHXyRErkdSU/4EPdFJpFBSlrg7MwnIkAr+n/PGFppYr1M1MEW/SZxBsUnPph0B7exOALv5xlw4JiU4EH+qnVQ5c//w2rzjv02nkMPFX+q3Qf4xq4ecAGt8N2spOxg0UdwCZGxYz+5beh02ojk4icPHA/z5ISoGgZt9hnFilnK50ZuA2coiix4wlAndMUq4F8Bf4nMnoZwSlp1KWBrW8h6f8c3hvxv+KBypD1lWr8tecu66lfTy400fKpdjrCI2nTuinK2Pl8W7qFS5ZRmhzLO6gOqrMuZb1ndGgfnnO7qIUVf2egkDAvaKlgW7zcKbjkmJcyt2C6+OXKo439JFPJSN3Is2vqbQaZS9KUcyiNVzu26TaCY4K6pxqE2yxV0U6bK0yvgAFZ9gyHHho+kmtldwNPY9y/dk7mfOvvPhdOTvopSeaH2I38jb7sTJuHUsvpziRQGRg4aOcNcXYFbmdSHN3cFP5IHJ/S/Xk/V3ewkaefJW6qX6FL9h4pLbZisIFf7kfVJeBoF15Sjj1F6NoC7lgvHpqUbBC1rFp4RjOAngdtfe+4ah8nL4AwgqeUJbUVh37GtMy4rAY4uEjtVOHH+z33+wWCawnnuPydZ4aYzWhWUI6es6mLAodwDpuPJeh0D7D81fTgl7prv4bBV6rIhI1xTsYKk1UkKdvebk1od12153+Gg/gLTjTv+0ImWR2zeiPgsFNmvYewIQaPqU/ZWjToEl6fmDD/aPrATM62Tt6SSN9R96myA9aQJZlgfxA4TE+
 AuvC5cxe
 hd8S6zAOIKrrKUy8GLefD4eItjM1jKyDsw1Mg8SZc0/kd2r9hX/O/KyJouYJ5unRfNPMg4Rx39x3wltsIA+sBtX06rB7JJKSba5i2oxSr6s+7HAoNo3ayobjvHFhKpzp4xyvCW68fwgJOytNLBeN5PtFP0iFE2kMVGl+ntH0OkVT2fPjGkrlFhrV9Iv/oGbY7sBfAdx0r57OKvnbA/ym1aEXV/S9YwTw/NtJYplVaULU4TaVVpVSiJcwNGkVw2SS1dcOhDl/XBKx3QJNRkHZsxu5KZwSqc5eBOOMfmll1lszFUQ4R13PfV0WmxOMAl5zMjdu/Sc3EeTZXCNlOsjrrRnTIkmEyKvk477EAmpKpHbqmy1fEg7UsE3/xRVk7w2S7FPclWyX5fmFThcOANrnmvT3g69RfRzzIWrdu5F0THveVz9U0gz2GSGY9YmLxCgO7QAZoLW46aiUQIb+J9wXTnVum/Q7Q6jHAzAq0q4dC7FchmIc6H47gAPul+mRDvpu35/VkajNDfvkb/CZks1L+6SC/diKvJgXTPzB3eUh+aWrE5ac70mLNqxKm9sVAsgRqN0v/
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

After a successful split, nr still contains the number of pages in the
original large folio, although each resulting page is now a separate
order-0 folio. Reset nr to 1 so each split folio is processed separately,
including its own swapcache removal and mapping lookup.

Refresh the saved mapping after folio_free_swap() so the current folio
state is used during migration.

v2:
- Refresh the mapping using folio_mapping(), as suggested by Zi Yan.

v3:
- Reset nr to 1 after a successful split so each resulting folio is
  processed independently, as suggested by Zi Yan.

Fixes: df263d9a7dff ("mm/migrate_device: try to handle swapcache pages")
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Signed-off-by: Arvind Yadav <arvind.yadav@intel.com>
---
 mm/migrate_device.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 554754eb26ff..74ac6651d4b3 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -1182,6 +1182,11 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 							 MIGRATE_PFN_COMPOUND);
 					goto next;
 				}
+				/*
+				 * reset nr so that only first after-split folio
+				 * is processed below
+				 */
+				nr = 1;
 			} else if ((src_pfns[i] & MIGRATE_PFN_MIGRATE) &&
 				(dst_pfns[i] & MIGRATE_PFN_COMPOUND) &&
 				!(src_pfns[i] & MIGRATE_PFN_COMPOUND)) {
@@ -1204,6 +1209,12 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 					src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
 					goto next;
 				}
+
+				/*
+				 * folio_free_swap() removed the folio from the swap
+				 * cache. Refresh the saved mapping before migration.
+				 */
+				mapping = folio_mapping(folio);
 			}
 		} else if (folio_is_zone_device(newfolio)) {
 			/*
-- 
2.43.0


