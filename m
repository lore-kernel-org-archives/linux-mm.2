Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D03DC56207
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 19:35:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDDBF6B0093; Wed,  5 Aug 2026 15:35:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8DB36B0095; Wed,  5 Aug 2026 15:35:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7C796B0096; Wed,  5 Aug 2026 15:35:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6EBB36B0093
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:35:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E5AB4A0532
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:35:48 +0000 (UTC)
X-FDA: 85068220776.11.456A2CC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf01.hostedemail.com (Postfix) with ESMTP id A091E40009
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:35:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Qk/CHIeV";
	spf=pass (imf01.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785958546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SSXUYkTyH8+58ydOFMNAVWlwL3oRA09ylaruPGHZA60=;
	b=n5Eb0393Xne96CyAMT2AnKsRpiAq2NxZaMvL1CLSBD+TLa4/ob8e+mpReW8+znenKcyqR/
	TaoqIgQVUj6RCmx7QgjRCXjhk4Z4B//PDk/DOgdu6Yh5EcArp9zR/reiU5PNwvDOUMsVlJ
	hNggQmWQoidDHIAxcHdfBCXWKd8FGMs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785958546;
	b=K6vq9f8hvlebuagIyvLs+0tbEocW/yRypZb/dWrIxUge/mYZUh/+gi8AetlGtXMSZLWlkv
	y42xa8tKRZwG0mehkqNMym97Kog5jzZ9Gmnb/0Y+WRsjkJnTnqplK5bUBe0R1UBQhFsLEk
	MPnFZnB4FBWZfmEFsqIGXbPO+iYxXE0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Qk/CHIeV";
	spf=pass (imf01.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785958546; x=1817494546;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DwXjrp0YOMKqBIa0CyQY66LJvCKzj79JzvSlROjOOxA=;
  b=Qk/CHIeVJn38sklPcAFJDamTISxuj/S4tz3BjbcDb4gCH6eTL9DMkene
   Px95NR9oh0XKdNytqH6qDNQDWkkO4lILpFVuA8RxgwW9rs/oHOZNqj55D
   Wmr7cDr3KeL+ONFrpUXoeIKKNDIXHk1YVpfY6CuuPHlY83BbArT+fA75g
   Rbhiq4YJ6twrbF0X02WA2+PUGPrDgIzIQ9jYFXqs+hlfnniqp48o6cEIh
   Q3ArWMioRNPV8aJMEJ2eCMSwVB4VtwNmfpEm/uYqrsqHiuJUFhSSRQZcB
   FgSjcQI8GqTgNTqq5q6AAFhPJ9gi7lAQT7WtKexG0s1kHkrW9zYQJyZC4
   g==;
X-CSE-ConnectionGUID: K+KeAjoJT4mdGunizHzkvw==
X-CSE-MsgGUID: 2GOmo3tKRLCZTCsgt0+a4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11866"; a="109332950"
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="109332950"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 12:35:44 -0700
X-CSE-ConnectionGUID: CujDtT0BQmaBotcPTuJkwA==
X-CSE-MsgGUID: sX6rfqqERo6FgsdinoenMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="285263527"
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 12:35:43 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
Subject: [PATCH v2 3/5] mm/migrate_device: Apply the fault reference to the correct folio
Date: Wed,  5 Aug 2026 12:35:34 -0700
Message-Id: <20260805193536.3756457-4-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260805193536.3756457-1-matthew.brost@intel.com>
References: <20260805193536.3756457-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A091E40009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 7a3y5a1euyyub8auk7fjne5g5zfafwim
X-HE-Tag: 1785958546-209616
X-HE-Meta: U2FsdGVkX18nIxOYiKSpvz+10qXULUGvLMEz6a7zGQITsxtH8qvzQUzFEKeJ3dmkz0o14w3sftCCj1YoOZhlZYUDfYKOTFv/Buv290D3JIarc0iDx7R64WwFm9hUab98Ep2M5/HO5DYQVPXOSV7oEzqzlxmhS1wEdTsqMDKOKPq41hKbgqJ6wBlfsUWKNwAF9/fCbkJ9zMruCxHrE+b7hLkMWr6h0/gsTVIiH/q8JO51ZMgvYc9Ei9omAXGPQk2hX4YePNsuPs5bg4fDdgJkjA4SsGkCOlqHAWSb1OgdboeJnNsUkf6cy7hVdcinv09fpCCQLqeP5SoA/aGOWsfwcunnLpEoZOFJeSYFiCIAaBMXqZwm51vG+5JHi7tqdA662MIsnIt3uIRxXut0kSdTAEPYmNJJZ3ldiwO3as2Rg1Y0zt9G9kuDIpElS9gUQq3VGDGJomJ9Iz2VbeEHJlGZKlR8K+jDNACmVZvA513qEWCqAmFpp7HMjIi0C0ZzP05L8XIwaQeeAE1X2/wkh4m39zvjYS7RrmJPALX99BG8uGt/uigVXacGK77LwHHqlr4HJ4fRaf7jaDX4FCvp7qT0XdW401j/OIW6wqRHfQKErnfdElc4cjqSRr12FPKgrgBaOVVhrsDPKcNEPsO6ocWLxk4tUZeOJAtlQguPLKJ/B8aUYODHtigQot3j5a5inLSchjh4etV0KlNXQmuLU7HHTJFCjoyt6NHEyczya5pmYPXPl0HL6BMXkwLgPUZd3TLAW0ChVTLAQjJijCLENq6B+4CcyjcB0GaEZXoNXnRIgkFopl/d31mFkVKcwwtUlRfgO/R5wi+nlD1lJSiU/5RSey5Klm/bQYXerCuQ6KyTmKLa0ZMpqiPDBI0QLOdeTiK1n2jhEhQolb1ybyP3wG/K1f1xGVMwRKqr+f+Ol61LOL6LIJfLIQCKpi8DXL2FGQEfLiGwev0svYoYXwg9mqw
 K0THxaE/
 O1q69iubbVtkUiPaWQA1hPmcQozX3a5iLt9Nok0NZiyZX48rxEm2rrr0ZsWVvMbIg/nqrziDNEV5wy2M17TUSY8Brd3XLSvBvAdYVqWpeK47u3qrRI3a9MWmdQ1V7ikgCfqcoPsbPo88e/M20VwQC7bFNLrPWYCl3biDAveXNDv3rpZiy+KtBdJGxEGDn1sTaEfp150VKa/p/lLTEgltm8a160vGBNqQv3SA2L3qKQIYXQNA7Em48UVy8wus0PJ2WTs08ehV1yyERwbqifLtuN/ESsZMYZ9Goz70RREj2jBUjUOCZ5Tus4EkGXgYbd0JutC93j0AIVw4QGOagTpUQ0Y9DLenV28hQBf/jsGaD1UGfSktC+xG4+kdO1cS5Z6aSPcjgB72/MTXObvW5xcqU+GiOCvP9m3Pblk+nZ3XSsIvzVGOJIhqnxotI+thSdnQUOXZkA9itif8VyC9FWzjQoumcX6InoPxoB7/+7oGqDFHSD5ITL8xGo/rmR45Ls87RR3u+g3aTNDMSoILkwIYR4b0qsXdbyd5EzTSagoAB2RrkeTZ3p2rMyFsZkVtG4eW9h4pN8pFC6+wnzv7bDVeEq0lezVX50PbysPo5EVXESFG2t31BAtGvI2NMENEU/W45DyA5PjqI3ht3HRQlx7AFRebfZNMQchk1jwd0IUbeh9MKxtV5x/RGa2JWVYVvrZVjNHGxT99Up8P5KOIXWW9daLIBX6dM6BI87MwT41Z7cKKpQBmLj5c5SQkJXtjx+Uoo1kW7N+nfjMkXEPzTWvKvwqIWRROmG637f0aqZh1xdjFKM6EPuQRjpAp7QbkuhmPch7hphZyeAexhdvAtVNT+c+k5l8FsWmEoc5faU3bEAXhK1g2BwGFI8bMPR6+/DgEFfxE2IxXHN9Ow4Cej1RX2GcahVnh+NIap+qtLGkEdnq0unDJayELAQBUcfUeGGLDLt8/Y/ctmq/MRxLQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__migrate_device_pages() computed extra_cnt once, from the head page of
the source folio, and then passed the same value to
folio_migrate_mapping() for every one of the @nr sub-folios produced by
migrate_vma_split_unmapped_folio().

The extra reference the CPU fault holds only exists on the single folio
that ends up containing the fault page. Claiming it for all of them
makes folio_migrate_mapping() expect one reference too many on every
other sub-folio, so it returns -EAGAIN and MIGRATE_PFN_MIGRATE is
cleared for them. Only the fault page would migrate; the remaining
HPAGE_PMD_NR - 1 pages would be restored to device memory, and the
faulting access would immediately fault again.

Compute extra_cnt per sub-folio instead, comparing against the source
page for that entry.

While at it, use the sub-folio's own mapping rather than the mapping
that was read from the pre-split folio.

This has been latent so far because the split it depends on could never
succeed while the fault reference was held.

Fixes: 4265d67e405a ("mm/migrate_device: add THP splitting during migration")
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
Assisted-by: GitHub_Copilot:claude-opus-5
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
---
 mm/migrate_device.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 142920a464d8..4ee09801efe6 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -1191,7 +1191,7 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 		struct page *page = migrate_pfn_to_page(src_pfns[i]);
 		struct address_space *mapping;
 		struct folio *newfolio, *folio;
-		int r, extra_cnt = 0;
+		int r;
 		unsigned long nr = 1;
 
 		if (!newpage) {
@@ -1301,13 +1301,25 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 
 		BUG_ON(folio_test_writeback(folio));
 
-		if (migrate && migrate->fault_page == page)
-			extra_cnt = 1;
 		for (j = 0; j < nr && i + j < npages; j++) {
-			folio = page_folio(migrate_pfn_to_page(src_pfns[i+j]));
+			struct page *src_page = migrate_pfn_to_page(src_pfns[i+j]);
+			int extra_cnt = 0;
+
+			folio = page_folio(src_page);
 			newfolio = page_folio(migrate_pfn_to_page(dst_pfns[i+j]));
 
-			r = folio_migrate_mapping(mapping, newfolio, folio, extra_cnt);
+			/*
+			 * The CPU fault holds an extra reference on the folio
+			 * containing the fault page. @folio may have been
+			 * split above, so the fault page only accounts for an
+			 * extra reference on the folio it actually ended up
+			 * in, not on every folio of the original THP.
+			 */
+			if (migrate && migrate->fault_page == src_page)
+				extra_cnt = 1;
+
+			r = folio_migrate_mapping(folio_mapping(folio), newfolio,
+						  folio, extra_cnt);
 			if (r)
 				src_pfns[i+j] &= ~MIGRATE_PFN_MIGRATE;
 			else
-- 
2.34.1


