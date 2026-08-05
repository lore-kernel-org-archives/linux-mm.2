Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6D84C56205
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 23:10:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD1506B0088; Wed,  5 Aug 2026 19:10:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A828E6B008A; Wed,  5 Aug 2026 19:10:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99F276B0092; Wed,  5 Aug 2026 19:10:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3FB2F6B0088
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:10:54 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8F9C1160626
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 23:10:53 +0000 (UTC)
X-FDA: 85068762786.24.E48571F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5A3CEC000D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 23:10:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Mo0gf365;
	spf=pass (imf22.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785971451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aLoEkh3QmfT1EeiuWdoxCq4mVzE21+yh6P/F8jSPyIY=;
	b=As9fBmBg4UAgKcPKgZiqUvix4suZijK+w7UTlHBL0hEi6VjblUeZnAqG9b1hXP7xDqr4oY
	EYTFeIWwkwEqWFnlag8CdqvFN+QGlefNqZK96b5wU6t9R5pOXDcOAM0zj7Q4RN4qy+jTFn
	9oRDHyPqkJqf/qG0pGQaV85Kx/umc54=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785971451;
	b=xZT9kdW8x6j5O71dh+RR57gyiKrXD56uuQKaZZDhjcFNCC6yFBanypBTXn8fxKKguDeSI3
	kmYeIlshI9vsNFV/p8v/AmbzgZxN9BNYfq5Hsv7Fndq0QZqTeeZ7VSAhVQx42DoTqBvgWZ
	sKcuza8l1z6j2tCU16SqHHJENOb9SUg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Mo0gf365;
	spf=pass (imf22.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785971451; x=1817507451;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dNJ/oi0EebM2qITDTJ9UJ0BoOZBi/aCxva+AfF14at8=;
  b=Mo0gf365n/KhVFQsPA0udEeuRib0ao4X4g8V/J/0uVaIHjRpLr+jP1tJ
   mlNCqY9oBGv3m9ILkUIcbyoFA5qci1I2LrcMWzOtLs0jA1RdTskyijXVk
   I7UjVNxRdezAufqyZum6AQ91NkjvyX+cSeQzobGGo4GAGvg9cqc7ddiex
   zZhqD1jk7BXarm2QwlAnEc80jhiG6yvPlIxLgML1Xt1Kn30mM40C32JC5
   6DSN5ygDfbBrqw/50ShtIL49qyuLRKfBDOKJyC2rgapNC1xJCvRitsCpv
   aotU6AUEG1zSeUh6oTLHMDu+LeVOyxzg4i3FpMY8s4qeM1mVAOvGYnbgt
   g==;
X-CSE-ConnectionGUID: x9Uq9XBjQa23OvTpSWGAeg==
X-CSE-MsgGUID: Olp7m8JTT/SvHLhmb65bnQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11866"; a="90376833"
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="90376833"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 16:10:49 -0700
X-CSE-ConnectionGUID: gdzBu8tUSsWVVT+WYsw11w==
X-CSE-MsgGUID: Douz6uonSw2oqZmSx0TiGg==
X-ExtLoop1: 1
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 16:10:48 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Arvind Yadav <arvind.yadav@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>
Subject: [PATCH v3 1/6] mm/migrate_device: Clear stale mapping after freeing swapcache
Date: Wed,  5 Aug 2026 16:10:36 -0700
Message-Id: <20260805231041.3791771-2-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260805231041.3791771-1-matthew.brost@intel.com>
References: <20260805231041.3791771-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5A3CEC000D
X-Stat-Signature: gbny4i98kibq9dcwuf15a1foztmz97g6
X-Rspam-User: 
X-HE-Tag: 1785971451-612809
X-HE-Meta: U2FsdGVkX1/eudn75yfKsVPmEirO5wgmb8e5Spwfhz23oVF6cPDgKVxZUQgPyNxYx1yjTec0uhmfEUaZVr2kaAmMdWne9vuF9TKuBw54uO5GQK8QnOaXpAtMXB7+K+54wXRbaLzjtzr26BKbOn5a8/cYgyro4oyQB8v/CBmaKDbcwkCNdV1Cjqpt/x8kv5w4Ins6h0+mYnaqBzhYrVB1ae3OehAPA74uuiXYpdEwPvluIsuWl66s1WN6rvzFlysmnEEzoS1v3Nr8oblBgLzbeUSmxd0FiXGpaiPQtmRW+6Th9bLXK7A3CLxKM7HkHmhPdumzx2wpz7Ur+pRAmIwwWqazmUpXyoDkxCgFQOppOU6rbH9RktS17HyB7bqN1pLxJBfBcTELYlzsd3ToDRq5P8bw+bB/duB2koRGaivuhHj4QYQbtFjpqQIYSNyTuDLW1uOJobXIPCEBas5Qqc1syWAEjQFZGQ8pqnmNRtNIYg2c/ER3fEU6M7v4jAXBD9Qfaes7W6vcEazH/bn8M4u7SIJTA6sm1w7REhpsI6QVcbdkkrFNgBBDyVsYPuhOHD9rvpI6im0kxepDo7IR0iRVyalWGE6mqlFWDWRH6A+6fz8TvqkNOB5SjscgaGGqKfcOKm3D/L6TfPqNWo95AmvsNqMhGsuUGE9mn/l2Glolzb+RgKCpWVYGC/+x29Rlt2SjMXdrRRddaz9h/7NyGhNfkvD/swUOR1ns21VoHPRxP4FdF0HlwpmrxMqYx18O+d9EYfHoXnlmb01tG4cLu7/RHiMRrFf1admeYThl4pkwEqirxtk2mUJFLhGBZeOmvP3/ESLi8YP6NrjdMnnr416U6xwKLrvG54bCoQ9gSZGv8nDjmloNz1z1uKg+gJgR64iSovfyLeszjHPWruyVTxIqU8otyg/EpcM2rZbWRGKx2xeO9f5S44C2vu54498MqArtbLGwqaMQFoGH3pHmwXy
 CCB6I1P/
 RJR9X5wY+TVB8Leu7mQ+Ti/rdtSvPD1y0JHgfB2T7CiwDOxCBOogTN4pwCzltluGiqUtmRixtq/93LTykpJyVeaV6vQ1hdKtWMGsRuyW3NIUM6UMEjeR3XRC6bvZn1xXYYQ+t3+LwqPAR9vZPkoxyxurj+b9mIDeK11TEY1ZRXYj03sNqRe4/D4E/sXTJQiocE/I15Ta5Ij/sJiVvcvoG736DZ5YrQgHVGbtD1flQuiJ03Evk29F6/cfbY6d32RArzjRkPrfK1biuzxHBieP1IA1plYY5YA6bnyPdHvaRRfbOmdlNf7lRZiMyNbJX1SAXqBckQHKnAfursCUZ+vrq7I0CTpeFzfVfL2MPnJGJyzdQ2K7ImRmcMs2RyKPniR8BLcazevFtDwPVbCAZr9SerKLwkx/GkYhy5x825OZVo2MMgVMzZC0vrLqg8tpFcs5uYF/6YSCdv39spFskiCHr24ZhWrh27OqQr4qM9CJ2TtCj6QVZsL8mBPAN+LGleljalIYQrnEU/RBnPznlviR7apwsqhwe0SnJHWkcKnn2RVevHLBFKrZUWPKnnRSYMOB5MTh7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Arvind Yadav <arvind.yadav@intel.com>

__migrate_device_pages() reads the folio mapping before calling
folio_free_swap(). When folio_free_swap() succeeds, the folio is removed
from the swap cache, but the saved mapping still points to swap_space.

Passing the stale mapping to folio_migrate_mapping() makes it use the
mapped-folio path for a folio that is no longer in swapcache. It can
then operate on swap_space.i_pages with invalid reference accounting,
eventually triggering a folio reference count BUG.

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

v4:
- Re-read each source folio's mapping immediately before
  folio_migrate_mapping(), as suggested by Balbir Singh.
- Add a warning to validate the post-split order-0 invariant,
  as suggested by Balbir Singh.

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
 mm/migrate_device.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 908d2d4ec43a..162d29b2807a 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -1183,6 +1183,13 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 							 MIGRATE_PFN_COMPOUND);
 					goto next;
 				}
+
+				/*
+				 * reset nr so that only first after-split folio
+				 * is processed below
+				 */
+				VM_WARN_ON_ONCE(folio_test_large(folio));
+				nr = 1;
 			} else if ((src_pfns[i] & MIGRATE_PFN_MIGRATE) &&
 				(dst_pfns[i] & MIGRATE_PFN_COMPOUND) &&
 				!(src_pfns[i] & MIGRATE_PFN_COMPOUND)) {
@@ -1222,6 +1229,12 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 			folio = page_folio(migrate_pfn_to_page(src_pfns[i+j]));
 			newfolio = page_folio(migrate_pfn_to_page(dst_pfns[i+j]));
 
+			/*
+			 * folio_free_swap() removed the folio from the swap
+			 * cache. Refresh the saved mapping before migration.
+			 */
+			mapping = folio_mapping(folio);
+
 			r = folio_migrate_mapping(mapping, newfolio, folio, extra_cnt);
 			if (r)
 				src_pfns[i+j] &= ~MIGRATE_PFN_MIGRATE;
-- 
2.34.1


