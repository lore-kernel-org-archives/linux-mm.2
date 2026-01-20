Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6C6CD2ECE9
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 13:33:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D2D56B03F8; Tue, 20 Jan 2026 08:33:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AAA66B03FA; Tue, 20 Jan 2026 08:33:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A9866B03FB; Tue, 20 Jan 2026 08:33:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 327E16B03F8
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 08:33:36 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DC5A5C2095
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:33:35 +0000 (UTC)
X-FDA: 84352434390.08.112A15A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf11.hostedemail.com (Postfix) with ESMTP id BF36A4000A
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:33:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RPhsg6hM;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768916014; a=rsa-sha256;
	cv=none;
	b=64pQAVZFITwzvYozDLItUKIYv6AT8h4L6Mtq5jKfgS+Jlhyg7EhlO19xroXuGNRJ6rVspq
	KyAXJ39gb78K4sM3bZ43LYfJerRNMX7PWLZly5iXH4iEFU3hIwUv4xbyxuI8mEs+XrbK+C
	dmxM6/x07fvB60fHe6o5B9AIWFWBdkM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RPhsg6hM;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768916014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WmIC4ja4n7qZeKeMS2UPTRPFaoeVh409hOfINWtfOJI=;
	b=ukGDnSRt5CTzWluIaWXfAlfw+f1vr4ypwTmpy/Xyl2r6z6vsrpKgFZzIRKB8DrU4JKuNtZ
	GXRZMDdHovrd5Ma+p3BfmpUs20A3huIM6KJ3EfqlXF5Jb5u3Et1SpZrjcNX2mnWTRyz8rJ
	rzXg0GOLech0Bg07m1wllrhGBBdG5Ko=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768916013; x=1800452013;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WxYMGLcFQNXnEaihySfQ/dWGKrp0fx37HvGdniAnji8=;
  b=RPhsg6hMZI4PShgvlHGbLQz4rf2ImEaAQhv3Qv0e4LCN3dRpGcRSgFbk
   e8l/XwzW7+RqZttsK9i3yS6r8vXPYZw5mxEU96JAtXqqlGY2hBnMZny20
   RdLfzBtkFyi9KzMDHaT5Gd63NHg1gjsEpyILuJ4cH1iGdq2xk4tcKlpwh
   +TZma6edPBQkWgFv//tD/E3HgYL1TmSY7grZFr0BCkI0+8YrFWb6LTD5k
   jKR0clBntyjmKoWD+7yDL5RZ2mYvjue5aBHFi023NUssWBSFemYjclH31
   L8JcKHmpXLLAhsKAwbpxPb1pu+94r4Jw2WbahIpiXsZZbxNELcXU218Ul
   A==;
X-CSE-ConnectionGUID: ezUwh36WR0+2HpJqTiQ/pQ==
X-CSE-MsgGUID: qTH550JpQGu1aGD3X+UOWw==
X-IronPort-AV: E=McAfee;i="6800,10657,11676"; a="81494842"
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="81494842"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 05:33:33 -0800
X-CSE-ConnectionGUID: mA9jWkbcR0uUM1E8F4F8Mw==
X-CSE-MsgGUID: wwIIa3OIQ6OdJ+5U/2xA1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="210272018"
Received: from linux-pnp-server-27.sh.intel.com ([10.239.147.41])
  by orviesa003.jf.intel.com with ESMTP; 20 Jan 2026 05:33:29 -0800
From: Tianyou Li <tianyou.li@intel.com>
To: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org,
	Yong Hu <yong.hu@intel.com>,
	Nanhai Zou <nanhai.zou@intel.com>,
	Yuan Liu <yuan1.liu@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>,
	Tianyou Li <tianyou.li@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v8 1/3] mm/memory hotplug: Fix zone->contiguous always false when hotplug
Date: Tue, 20 Jan 2026 22:33:44 +0800
Message-ID: <20260120143346.1427837-2-tianyou.li@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260120143346.1427837-1-tianyou.li@intel.com>
References: <20260120143346.1427837-1-tianyou.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BF36A4000A
X-Rspamd-Server: rspam06
X-Stat-Signature: j9sfhb39e5663kcbpkwuq6fb5myf7zt5
X-Rspam-User: 
X-HE-Tag: 1768916013-798826
X-HE-Meta: U2FsdGVkX19kjUgzNtNO07skaFuJUAoTgcyZ49uALsHJv5Litz+cn8Agmc84USAekxC8ltBzzd+rmBsDaq4tLm0Dx974zw3Z8itjGqbA8WhGXEtP+5mNJ2PO1uSX77a4zw7/iFMyuaYnZR0zMR4cXKksW48ANr3nRWMJ94qjN7gBkmIOwPZG7mcXbzqM5u9RQ/lD1z3cw2mxGJpzU003bd9PdKc4ze95OB/Fsk8L1zMrYPrZYdkdMPeLzqlqcOFXoFw/N+VZug9DN8fH1uZR4kHFiMrklZXoZbN3r+93j9iOE07GgkRQ9OKHDA3aH4+7cUN+tWbmMPLtHxOXYPY/5hGqe2SWjgiKLr65tybJPr8oSc8uNCX2dA9iLP+uo9xYNhUaTfoMZ1Y29YEWynV4n8ayHl0SaYZ8DxFtwPZeFLs7sJDd6i0nhXBtxWvjYLIK1Mj9Q4UzKtHQLyuUy80UMFiIkuafo4ir/tUKJGlsCxyd3mO1hZUM/HcOzC9giAKAtIq/oHWnpDXoCYhk2GoWQXK4M2huFP2nxTTS8muRw/zhf1JubziS+Jq9jShyr7V2Np+5/+AywJj8nUQHyYQ5Ix79nM53g2b2h5VDpF7I3QPjXjzeDFuK8A1hXgfsesslYk57tdDfWEicwsaiFAadlhge0uhrWfavtF9S+ZAZQh1xyK6nG84BT6tRyaearRleqGzUecqRzxR1q8oeRkMGZvUBL7GFAcR1Ze5RMOVwf4B118RFfsrmRrpPmDcJ+SiQqPrDSHslrnTjIvoT7B4OX7WSs3KsLEmhTXjaZ5ZudGK7snoKa1HWEl6wviYXJ2aGDA7fch0D/exjeWB0aLr1Z0wYTu4226Pglo9Nw2hS/kKgTJjGjxuuPlwhvvVTy7t/1vrgnN9QI783jsnHTeXDwUtLzv5zSNerO59G1ET3j3cM/2Yy/EAagtS+DkQiy4x41D37PIoT/Ft6RhPJ+lB
 KkowCFMa
 ZPDKnBHIzwvmZFwhDPWobTXh02KwJxvI/693Pti8cVPsc9i4iIq0HWL1hn+flx6VBuxIMEPlozmkjJ+Q1cEqcCvIeP91XToe/9pK2JPVSIvrCCJPPgkvZomIFdhRHuPpxeEnk7sgIAz1FhsO18zuGA9XaZ24gq86JcHMvKI7DcC1MlT8PB30nWKmbHQFHnlNaFRjCh/Kpgb9ItrNBAIrfAS0C0d1UAtf909d1fVVgVbnDdABf0DI47gSib6tNFxA2A1AdARy7NUMCX6tAUAP/b17LujLxfCduoMKLjb3QUupr3SjvG5q4tN0xFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yuan Liu <yuan1.liu@intel.com>

set_zone_contiguous() uses __pageblock_pfn_to_page() to detect
pageblocks that either do not exist (hole) or that do not belong
to the same zone.

__pageblock_pfn_to_page(), however, relies on pfn_to_online_page(),
effectively always returning NULL for memory ranges that were not
onlined yet. So when called on a range-to-be-onlined, it indicates
a memory hole to set_zone_contiguous().

Consequently, the set_zone_contiguous() call in move_pfn_range_to_zone(),
which happens early during memory onlining, will never detect a
zone as being contiguous. Bad.

To fix the issue, move the set_zone_contiguous() call to a later
stage in memory onlining, where pfn_to_online_page() will succeed:
after we mark the memory sections to be online.

Fixes: 2d070eab2e82 ("mm: consider zone which is not fully populated to have holes")
Cc: Michal Hocko <mhocko@suse.com>
Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
Signed-off-by: Tianyou Li <tianyou.li@intel.com>
---
 mm/memory_hotplug.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index a63ec679d861..c8f492b5daf0 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -782,8 +782,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 	memmap_init_range(nr_pages, nid, zone_idx(zone), start_pfn, 0,
 			 MEMINIT_HOTPLUG, altmap, migratetype,
 			 isolate_pageblock);
-
-	set_zone_contiguous(zone);
 }
 
 struct auto_movable_stats {
@@ -1205,6 +1203,13 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 	}
 
 	online_pages_range(pfn, nr_pages);
+
+	/*
+	 * Now that the ranges are indicated as online, check whether the whole
+	 * zone is contiguous.
+	 */
+	set_zone_contiguous(zone);
+
 	adjust_present_page_count(pfn_to_page(pfn), group, nr_pages);
 
 	if (node_arg.nid >= 0)
-- 
2.47.1


