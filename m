Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE7D6C531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 08:27:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B0A06B008A; Fri, 24 Jul 2026 04:27:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 861346B008C; Fri, 24 Jul 2026 04:27:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 776C56B0092; Fri, 24 Jul 2026 04:27:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 554286B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 04:27:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C92391602C8
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 08:27:22 +0000 (UTC)
X-FDA: 85022990724.20.663B0B8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3A8F440005
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 08:27:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dU+ar9n2;
	spf=pass (imf27.hostedemail.com: domain of arvind.yadav@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=arvind.yadav@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784881641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=EaocjWbzimqvaCTbL3/9+GGO459GIUX0kk46sIWMY/c=;
	b=k1gzVoL9RHLzEZh1ujlza8aq/5COLbuaotYmo21t2fFX0ihc++gPGIs30nbT6zskJt60l5
	nh1XTTF1LV0nDBBU7fiWqeIcdXR5a5F/Xwb7i6+LXgLADENGkkXbvYPI3D+xXGyfQ96pTF
	HRVjxBpneNFGkOBDop1a3iPdmVr0/aI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784881641;
	b=7v2ja3ASrL0oeUqYjGl0DOFZZ/KBGcSkYm/EW8zr469o/hFDvd61LmRVPZmSN0PuU9mcpa
	M2240ce4/El/+d7tx6y5MtUBIATdG2wkbh3N92IpU0FBIQ/C1Ap2AHOC/Sdr0283e4A5Q3
	6hpUtk59sSP4B/m+sRwAlh5N6miZMe4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dU+ar9n2;
	spf=pass (imf27.hostedemail.com: domain of arvind.yadav@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=arvind.yadav@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784881640; x=1816417640;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=m0kTrC2uUZ8YmP9OPjcJHDDgn6fwYkzc3W9o6qAN0fA=;
  b=dU+ar9n2GH59CgsVK9nEXhSanT195uBtzWvjhNs1kBFKQ7Vw48ElubUO
   ESqgAuNBJyW06UrcNJ0FfzwofllBbPUzWHLVwDXG+CxDTORGnXwnTV8v1
   xAxMGWmLEloHqP4qG/GmBrg1LNd9XpvNQOF4tuevE1I8QAfG9qtyWTbvC
   HHK03qNe7/FWiTjedMj2X1w3v8LjQZqOm3FhJh5nYlxqD4aDu/1v9j9l+
   tDr+DbIs4U3ngDDM2BPqAVLskdNcpgNcOzJ/uH7BmCxOPyErccxfQw6cI
   GqaM6JIHK9r4KZXwQPg2NOLbBClnqOm/h/rhFjeOs9GR3pQPAFLxJTpub
   A==;
X-CSE-ConnectionGUID: D+y4vQRpQJCyIE+vgZl7KA==
X-CSE-MsgGUID: +ubm7VU8SriX2izj4QDbrQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="108334267"
X-IronPort-AV: E=Sophos;i="6.25,182,1779174000"; 
   d="scan'208";a="108334267"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2026 01:27:19 -0700
X-CSE-ConnectionGUID: CmLsW23cSkGK5yzJmu7CDA==
X-CSE-MsgGUID: tgt31lqRSLSNjfZz0rfEHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,182,1779174000"; 
   d="scan'208";a="254714608"
Received: from varungup-desk.iind.intel.com ([10.190.238.71])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2026 01:27:15 -0700
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
Subject: [PATCH v2] mm/migrate_device: Clear stale mapping after freeing swapcache
Date: Fri, 24 Jul 2026 13:57:02 +0530
Message-ID: <20260724082702.2531024-1-arvind.yadav@intel.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3A8F440005
X-Stat-Signature: xmwrf4i6b41j84bw87kw6upyn64cuuh8
X-Rspam-User: 
X-HE-Tag: 1784881640-339134
X-HE-Meta: U2FsdGVkX18UAIOmnPqtSzybnNfY+OkrcbrI97aJa3MQQwQxX30H9nRgTc1YMSie5HvFiKtnKCkJIT1Hq5GEa05wBLOOJGYoKsr3QoeHKgsKmXlJ3f8Y5qpCupX2Up6cehr9YZvfpwBBDEExgDTMnAU3KL35FuhO9XEAar+0xGNPG0DQfrMb4Ob+xlPvbt+b0GPHRm/ekFEa9gQlLwFgyYLrZj4dtMCULrKRcjT/C7CMgjpZTj6XU8I1GwNPVhsoxh2Gg8M3qywAjg4PuXyOxgLpA51DcwwY2hAF34XQnGE37cAlpjzYVzXGtEL7nLWBkjY3rDC6IVEGkHxo9kA1VBp1WcYv3JqM3U3hSSP1Yhphb48iYJolNg8D3BJmH8o4mFVsR0hj/FCl04VxJic01+F0yGZMvF7FOMo16hqBBUCMDj2hdVshweEl0Th4LyXIzpoVxomIMUp71avr27rAKV4tjgTb7OL9oyJKnF8RaPckQrXE1RDWSFc/4DXUZKB3h6GpIMAdez+sLLAr7pYVmWDaMNT9S6/uwM6Rra/aTQ6S9B6UKnw9nfNltbYoqIDSaNrfwRPSn/Y0C4b3VfL/MV9/NTieLl6C2Y2bI6ZwZHCDYEo2QPUTvoyo31aI4H/Pg/25Fji/1ms9V16gGEjSv8QYDNVmTY0kK5B0RGKTEYXKEVsbqBDot9Fb9KZpMhPDYREfae7qYcSRyomdCaY04sTRC+0M9dcCsaskXOuWZNZIL7X/BehpmXjiRdk2fEHBuZF+rx3KTJZC7mvG8AbGlmN3Pf9Erf9KiVAIVQBmYfDwbUTQ141DlZEyaUYyEc+MNcDgVkVXbX4FSgDqOcPxjmgitCegZMGJLVEZG4JloE8+Oly6NsemeiXaXxFQucJ5t1kHXh+reWcH4QwBIwNyrEvvIMNix4oxPW5XpEFPYVsMXE/ahO4LHUqvOc3OgUjXUk9n1kMnDN7oNQXaql5
 WxlULAQ2
 ekun1EjJaR09CKxSKuAwDgZhAyZLx+SXcQ1IlGTgOwTtlGNRgplut03wLs3IkX8m0Vdr3ow5M/R7UE48pknoDx12fbQL1WYn/85Ot4SMq6+plfY0IsNQswXEms6tUjqOXxp6LnxvhhfOITTZrkKCSpUC1xpBf63D5FR2VBpndK5TTuERtrMHttvQ+891fHRbLXZ6oEbZZ/Fgi16hiSvQw4MDZk86vsGxtsdmk402HOARNIA/uLzQfeiKDi3XQqGKKXVRmea2oedGnjZd8qG3NzRM8Oyk3ayU/Fv9CkT3Hfl7ikb0CX2nGaFa1/+IkFVvq+TYkXl/6ATN4UrbBYtWbxYnVQlHTXDWND0hrXv9MObigs299+15LWPxQl1Mk/oMz89Rno75RKLFbv0UUeA5SLorYvCLtIH6medo4AtAimDxI1IOmLmDqcflbNsNs+KRbF//1FmnqfCdJRRpN0PatPmEEAlj90MJY+R6rMhOXwkS1BnX24ba/Z4HwADbVf2M4fO8phVzkdhw8DixYzQrpLpYuEaPRCn79qQR+Iw478DUdL5hWuAl2jDVTAb7lFDnREUAy
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

Refresh the saved mapping after folio_free_swap() so the current folio
state is used during migration.

v2:
- Refresh the mapping using folio_mapping(), as suggested by Zi Yan.

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
index 554754eb26ff..ae895758b72c 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -1204,6 +1204,12 @@ static void __migrate_device_pages(unsigned long *src_pfns,
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


