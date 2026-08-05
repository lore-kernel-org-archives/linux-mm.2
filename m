Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26C8AC55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 11:33:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 326B06B0092; Wed,  5 Aug 2026 07:33:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D0646B0093; Wed,  5 Aug 2026 07:33:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 172A16B0096; Wed,  5 Aug 2026 07:33:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E40AD6B0092
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:33:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7B2B8140465
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:33:53 +0000 (UTC)
X-FDA: 85067006346.11.F5E17B8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf16.hostedemail.com (Postfix) with ESMTP id B4D24180009
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:33:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iY49MRD9;
	spf=pass (imf16.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785929631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pkFLM2KZ6nsoGzQg5oepjsQvC9Ru7KiRDLQSg+5PJnk=;
	b=fao1xoOOb3jfq2fvnvnh3XOq6W7qOm+elmavTG/taXHrWYgQOcY2nrwwelzkT2AC0EkaCf
	IdERHsIW5Jd1a53/+vHB/yWwEtCqHGkrrnn0QdZWahrucd4ugg0iSbnINPUbMRF3ujls3Y
	C+tuo5ILQQ9BpWGWRuDq2GNiOQiHaFM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785929631;
	b=etiEP6+c4UFNLcbFTk5v0/wuK+QS1Yuo6QRDQ362Mc/xM+yfFimDo+wRfuSghlCokLvcW4
	+zvfMmGpL5wJ79Lcb1DKh6MFnrNACZJlTe+BmvvoxX5tC1UR6PsYaElu3jrsnXRjgtjInN
	ctZ020msS52WcH6R8a58U0GahzkCAPA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iY49MRD9;
	spf=pass (imf16.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785929631; x=1817465631;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZxPU7quEySN5Hl4qRC5WeOO+MTXBZUcrGg6kx4/kNtY=;
  b=iY49MRD9UDgPHe0mDt6U1xFH9sxfnXCAL1C59qOpeahGvRHheOMBBtpz
   ffFLjmfuYObL48ECjsgRDsOh/X8KbPRoGQ7yXI7O7lh9g+cR0bP1qOTGP
   hqdeC28puFMgcP0waaGqNbgqOKnjS10VUNeXPIySrcgONXgVaeCHNLQTa
   HklWdE/1TtQbLZwgYW8dngd8bxIrj6HujXClQO2Ru2oRDBIzZZC/1lEb5
   63vS7bIHyXjRQ46O7o6mX7cODB6dpIiKfG/4k2YP++GPQEHp8IKPCPEnQ
   jjpiDffjsf7vSGqWykfzme8PprPvFQdv00iVGzzgpjO6f1iK9wCD3CXcB
   A==;
X-CSE-ConnectionGUID: H9iq8qsdRKCwb81A3/ca1g==
X-CSE-MsgGUID: 9w1Ntr7WRoOFNpO5XqU5PQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11865"; a="86358181"
X-IronPort-AV: E=Sophos;i="6.25,206,1779174000"; 
   d="scan'208";a="86358181"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 04:33:45 -0700
X-CSE-ConnectionGUID: TlTSTTbZQ92hntgr1WOfMQ==
X-CSE-MsgGUID: X+D8wfZAS76OZrI13c7G0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,206,1779174000"; 
   d="scan'208";a="265289747"
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 04:33:45 -0700
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
Subject: [PATCH 2/4] mm/migrate_device: Apply the fault reference to the correct folio
Date: Wed,  5 Aug 2026 04:33:36 -0700
Message-Id: <20260805113338.3742178-3-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260805113338.3742178-1-matthew.brost@intel.com>
References: <20260805113338.3742178-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B4D24180009
X-Stat-Signature: p9u6emz9eeq8eweph4ewt1799hyhghdm
X-HE-Tag: 1785929630-385333
X-HE-Meta: U2FsdGVkX18UfG28YvLVmmbm00l6q0U7WjO14YPKK6e5UOvEssnuTtPBiYi2xf9c1bdzKfI5U2xYIz4GudlQDDnkVGzkcQStXwE/O1IZxlW4+HycnUKxFWMS0QlAcn3cSsVzjjGeJnZmRZzLNRNu8a7aqDvO/p9QM6BR1razgjRd0ujGbUK+G2UCC5v8ImeLn0C92f2ToIjoGnGSLAZ38nCRYF0TeyVMpYXD+eoDSdsEpo5yDzx0yNmN9GF+26+1UMWkBPGnMY3cnfEBIiSK/NtnppGNwLMprIX4QU9DPK/RbmLSGhW/IblWBHWo6qrGmYjq4zYoeHIgfg7VPfTS+j2EC/u7oBGs+vsHp76acLv6qb2moiDrweTCcjafw8whdy3VLjIzu0ex1bikS4uBVcxaBLZc4MiPELD9XAt7nI/v1AlopSgaidUDB5HwUAtS6kMEcKgizZy/qPyK8gVlWJg861MATkK/Ji620xF0/Z+bvG2Ke67dyvVLCSmMXtKWFn6fRRMOhAjyF5dGIRBPgVE+/k/Th09/7omDOu0aQII9pXX/MsmxhA/iyBamGB3052geAi5eC+IsxLIyzAspD3uVyD+6k0JwdFaohrCcHoJ7uwg0/Cq2Qi+hvAkGR94xBtKER8TrPawnw7BarmYp8g5LGFdg05cG7XxOboOgKFheEQKVmt95PH/LrtA6FFuz9nSik4YT92kkXgQKnsQgf9p+k148VzzEAnq3w6915k1SBvN+PArAFVqrwoiNdSfQw7bSqKXv0IGZOZy+dw3uyjmKVTx0c9H9QEsbfG7Y/NSO0oyW8VHqhpWIEih9rekdBq5kU+JPViP5wVtpsMZLDCTj4LHyX7Dta73cbcSKfOExBVhFE8exTF4ol6PaYm2SyvwZR3AtcfyyL1FAhGmbgVHXjmExvNhpXR2ACJa4Y7cD8kU2HSMCFkisGkFF+pPzQWv1wjqYsetnVOcZo2G
 DV+Y3SQV
 gwk36N7IQIicUFKmfTn+65lJBFJdLEXnWLLlEdamnFF9CVE4bozrY2J2J/2W1/apx/spTmayQTWpda1a/moyd4K95XoKxgOdhXGvJXxUBzFJKxcSpHogYn5gmCSjUepuUr5D/loW7l+rxPTFHOoP9s4aShMpgFQYDYLP02ss8RL4AP1eSkkNkBrBbpO/SJfbaECg1Fq8AP1SEz8OShL1l/DHEzSr+mjCaObDmrcT8exIFoVPkL7mvj2tEaFP8JP5NwyJ3gYK7fFbrX+9X6IpL0G2GWqLnWta3LYD2vMHyH7r7jT6ar6pBg4TpEH9zCLBI/SvCEzVoL657IRsVryhULBDkar13MMXCYEri7tf5tmnoBvCiDKSN4+NDNIqgMQ8dQwPh4ww+VDcEKkNWM0+zJSTcPXsyqwhu3iZHUxpCO/VeMo6h0NiZxSfMLh1ZjuNoGVagbOvzt0ncA7DDzP6mLXYwBDLesb77FVfiE+VA0KFUZS+Xk3+4tMoFXtfL8RQHxNZXE2CR/QWgynbkvxTHy+K3vj0Y/w79v5/miqNAs/vqAE3uGrHop3KnN/VCa3D2osf1hPIFM5OAHB9rySLDvutPFbFO3+hqdcDRrRmX3ct6zgS37h7xYp/kYVmiYdc/PBaMiuJbRqI6HMSlZXkqYFX9xltoJlQlBVJNtiWCZzo5SbwHw8/VcUTiZqrKTCvtJ/OE+cSuCi7+1fAfh4GxmkX6PTXxqpsxYsk6UBbZ7AUGVMgAVsA1AAkLiyZKyrThFSIiBdfpzwJvaUL0f9mTKbidRlYLiHHWN6Qe5in3YcuAy/dfUQ7vxPGdsQ3oKaDDw0tKa6XnoBRl0OC2fIn+F9Q3dA==
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
Assisted-by: GitHub Copilot:claude-opus-5
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
---
 mm/migrate_device.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index d1d81bbbf795..65a6a15dba4d 100644
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
@@ -1296,13 +1296,25 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 
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


