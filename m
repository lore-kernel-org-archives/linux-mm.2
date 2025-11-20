Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50E5BCFA452
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 23:08:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AC056B0026; Thu, 20 Nov 2025 18:08:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45BFC6B0029; Thu, 20 Nov 2025 18:08:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 324416B002A; Thu, 20 Nov 2025 18:08:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 240876B0026
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 18:08:39 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B705012FBA8
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 23:08:36 +0000 (UTC)
X-FDA: 84132526632.24.73E1165
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf13.hostedemail.com (Postfix) with ESMTP id B225720007
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 23:08:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=oFN7vsH+;
	spf=pass (imf13.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763680114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eCJOgkSJ6ZGna1PwC3xDMubFoD+mnfJl2YuMnHiasZ0=;
	b=Riut+rXOdZCTIT+OrP23n7L8l8fBIO2cDyJ2ovcH4viJLTqgO71gXbcqrGuB7QMvoPZM+m
	iAhiyzsr2efenPnpHZXdoxYueIFfetmiZaPSv9iXOT6uz/xXsocb2CtqZqtmilBZa1VMKA
	g3A+w1Q9CFZSUou6gjbFOJ/mTdloXxg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=oFN7vsH+;
	spf=pass (imf13.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763680114; a=rsa-sha256;
	cv=none;
	b=D5gyWfa1tVmnIJ/+BRsTcjAA518PGJ5aOErsSALGSSGGGLwBoAB6Ej1TyhrIsURv7N/JuW
	nidgoanVKEmpGMGKljxX6XPkBZJNQGG5kEv01IderficesaDp3NHABDe5JsigQo0cjA0Ii
	E6GtG5UW4FjThN6NljFNpLPa8Dk25ww=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763680115; x=1795216115;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=St5MxBUCZJcinOju0ZzS80vPNdzerp0xVZDJj547ddw=;
  b=oFN7vsH+vRhMRt8RcBkw9H4X7Z657qvJTitSUNEWAeEkUDB9qUPW0JW7
   +WvNgQBBxtLh1R30AYEQPs3NO3eDVY+XURTorEeYoKeu77IDR05Za8z/A
   ap9Gs1kKaRAJzhVGOgwoAdS2bhiVYEqCZsY8OFU0FX6ZrVL6dmAX7aCOk
   2MM2b9KiJ43mAK+oxJvwA0xEIIgRrxFESwLJBDG4YbufRD+AptvtJFYxU
   dvQrq4rA7TXhNwsJqG7Z+NmpTHQW3DqCMSTdeAXzlOBPZT/KTVQTcmMlO
   Vz7ZUG8pGa4BVptZ2dBVVum35APv8Gxc4AbA/igEjWjdskTRdqV6NP538
   Q==;
X-CSE-ConnectionGUID: rlpTDpJFQQudd+9jA4oBAg==
X-CSE-MsgGUID: 81OF109VTB6jxVfSm2FIEQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="65699778"
X-IronPort-AV: E=Sophos;i="6.20,214,1758610800"; 
   d="scan'208";a="65699778"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 15:08:31 -0800
X-CSE-ConnectionGUID: lG0PZyxFTOKLYOhE+/99iw==
X-CSE-MsgGUID: MjqUGEr1ROq7Z6UP56tBDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,214,1758610800"; 
   d="scan'208";a="191364908"
Received: from lstrano-desk.jf.intel.com ([10.54.39.91])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 15:08:30 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Ralph Campbell <rcampbell@nvidia.com>,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	Francois Dugast <francois.dugast@intel.com>,
	Balbir Singh <balbirs@nvidia.com>
Subject: [PATCH v2 2/2] fixup: mm/migrate_device: add THP splitting during migration
Date: Thu, 20 Nov 2025 15:08:25 -0800
Message-Id: <20251120230825.181072-2-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251120230825.181072-1-matthew.brost@intel.com>
References: <20251120230825.181072-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B225720007
X-Stat-Signature: 1noek6rcohe77d9zsgkentqb4q5dgoqt
X-Rspam-User: 
X-HE-Tag: 1763680114-175539
X-HE-Meta: U2FsdGVkX1/IXRdpk9nRIgBwKdUQwhk37uBI5GpMaxnt4CWKxMOI0aJa8JSV1RExlivhUzT1yIznp+PmYpBl7d6vWcpGMOT7bn2GaQ2UZnBYvgNIvu4sN0rTZTxdCVmhfG17um4FaECfCofsMvFC8lx2LCse88vgeG0sDI/XFTx5LyU+2RWsOTXLIkFbUavc5CX2vIttmb0DiziZz3IeBoSQA2KU5dRs1SyhitzQ4CvMKSYjkp9pm5gBaPtE7C5DLMHa8o2AYpJHY4MoAzNw/2CJDpGsytof8dOPL9GI+8G589Q+QUl4sntTtwDzFWrqZVOTACfmhbNKYn0evOX+IPEwOqZh/Ygb0N0g7iimS+HLd3v4JBwZpYusSSC8v7NKtRBVZZrHZEwa8qbhSNBBVpUsP3heIJAScF/Z61JbwrOyzJr9PdG29IwriC1UrcfmiJueGr6bTHz+L7Frsing9TtZ4VVZWzKF/kPl0FnRj6UqwP0l+ABbvMQbRsu9rAdC/E55pjQ7m3GGsF3V9pMW/KzAh/n6GFao2+4F157zQytIoFacOKN0moJbB03wjSDtXyq3jwjImnDzUM+qAbEf+8yBskKeeo0DI6ti3tbeVXtDt3GFcvDw4yH+46HDWpsKv/4FRGmuy21wuQVs25T28w2PrYbADCrjtrtpi31G769UGdKa7WqEfBRB4enkDDaqppHCsP2Cyu53REMa1zzwPcImcyyDQf9YAAmGccZKmicPAoW9R+4wTeua4pGUzC4XzvoOfcnl5NJDrw2uDBfX9LAAio5GZkECjo9wgKkytrY7VFe/bPLB50hVNWz6LhjnNg975D1nqth8oH5CCqiLgNb7nyfx6/wkDjan8v9If2NbhFCuNHfYHC3ZelyHpej6EyNJ4Hm4SNBfRi1be4NRB4Sbw4o26RXjG42RFw3adppgf+mg5ZckMTPAcyoE1kRd5b7ZGdakEdU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix splitting a folio in PMD collection to collect a skip on folio split
failure and continue the loop at the current position on success. This
fixes an issue where migration entries that had already been collected
could accidentally be left behind.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Francois Dugast <francois.dugast@intel.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>

---
This fixup should be squashed into the patch "mm/migrate_device: add THP
splitting during migration" in mm/mm-unstable
---
 mm/migrate_device.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 4506e96dcd20..ab373fd38961 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -313,16 +313,18 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 			if (folio_test_large(folio)) {
 				int ret;
 
+				arch_leave_lazy_mmu_mode();
 				pte_unmap_unlock(ptep, ptl);
 				ret = migrate_vma_split_folio(folio,
 							  migrate->fault_page);
 
 				if (ret) {
-					ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
-					goto next;
+					if (unmapped)
+						flush_tlb_range(walk->vma, start, end);
+
+					return migrate_vma_collect_skip(addr, end, walk);
 				}
 
-				addr = start;
 				goto again;
 			}
 
-- 
2.34.1


