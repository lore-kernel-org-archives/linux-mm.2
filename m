Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18671CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 09:35:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48E7F6B008C; Wed, 20 May 2026 05:35:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43F596B0092; Wed, 20 May 2026 05:35:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 355926B0095; Wed, 20 May 2026 05:35:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 290196B008C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:35:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA8B01A0230
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:35:24 +0000 (UTC)
X-FDA: 84787290168.12.3608F58
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf28.hostedemail.com (Postfix) with ESMTP id C91FDC0003
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:35:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CqkouKHZ;
	spf=pass (imf28.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779269723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YeLHZd53LEbiG0nrH9ZT06EDtQlKVuQQ8+IHrFNZWew=;
	b=v0kcA1EgJnPmc0hXicsT5xhry6wJ8U9akWbbRTF0xqYivbW2q0+YhLIDGn7JQkrdZ/0Eqj
	GFFFpryVvYHV7BpOPLdMUdxZ9jXOgwmgHat/YDG1cTq1y048DHQLUzjrmj3MIUos08MNwR
	Btqgpn36OVAanWAuGg/LC1HIbSlOckM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CqkouKHZ;
	spf=pass (imf28.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779269723; a=rsa-sha256;
	cv=none;
	b=DxxMch4jStR/Fd3ApHrn/ZKaicIyjcGgtxMx6Yya/32RZQ1SmeDQ81ofJEo2iIeVmrVmFF
	kfHjFNugUTF7/1af3bQQb8L/N4vfQfN1HK7xHQ65bWKt0Aufe2oPc+MVeYA1I5CFLKj3A+
	kprhQwWMOfBlF2XampgmtT3lKoUfoxQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779269723; x=1810805723;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6ohoYsGOhjBP3A4hNjgXYU3ZasHnjBPl+8YWmnesUfo=;
  b=CqkouKHZt8OBsF7SROg2dWYh+YgRUTyHSup1fxhC5F6MtCVh7XiWBV12
   iAIgRE+Yeim97TxKbvyfaC9hMvk5Q9krQkg2G3OI5wxSmhPKDP+9i0A1V
   EDxUUU3nwdDZOEe4utyz65eKYqN1WDLumd3T3FZwuxVRt9eYH8L1G8Db1
   TM94NytJ5khd+wFb/17IjT6DPVOfDocYtDcsn5B+BVJNt+rsmhb77Jrs6
   Wkv6gOXPmaGFSMnWyJR5EPyEoG4XJ4FPmh0Gg5TeZLB/riyEVeZTGJqiu
   E7zYZiVkTV7bOgSQxp5NsFjk33gl5H/TdowQsK/7r3tCAWrmwMP3yxCBK
   w==;
X-CSE-ConnectionGUID: b/GQ/kfHT5CKnuaMNff4VA==
X-CSE-MsgGUID: bUkROLOeTLCzFlcdxh9+Bg==
X-IronPort-AV: E=McAfee;i="6800,10657,11791"; a="79187301"
X-IronPort-AV: E=Sophos;i="6.23,244,1770624000"; 
   d="scan'208";a="79187301"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2026 02:35:21 -0700
X-CSE-ConnectionGUID: vfvG5KIgSrK0SiSF4N0twQ==
X-CSE-MsgGUID: JQszQG3USpew1dD8Mt0OkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,244,1770624000"; 
   d="scan'208";a="278207294"
Received: from spr10.sh.intel.com (HELO localhost) ([10.239.23.75])
  by orviesa001.jf.intel.com with ESMTP; 20 May 2026 02:35:18 -0700
From: Yuan Liu <yuan1.liu@intel.com>
To: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>
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
	Jason Zeng <jason.zeng@intel.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 2/5] mm: skip non-mirrored ZONE_NORMAL memory map init when kernelcore=mirror
Date: Wed, 20 May 2026 05:34:54 -0400
Message-ID: <20260520093457.3719960-3-yuan1.liu@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520093457.3719960-1-yuan1.liu@intel.com>
References: <20260520093457.3719960-1-yuan1.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xd3377ugmasmryqi8yocf17zkycuxf1f
X-Rspamd-Queue-Id: C91FDC0003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779269722-399166
X-HE-Meta: U2FsdGVkX1+j6ntDnokwmA5vhbIOeWAyD8VBuiXFdDBHZYiV8D8rQAs8b28WA2PMeGFT14y0gfiO9gHcbApw/zNFN7nWk2IMSpPXRMh4zBTtN/N8/eFiUGuBkXd74oCgwctseJK+WEkMHNRAZONz/kHEdw97XUi2h/bPz62S7weNbHa7ARjgeJuYubyNvrkljP1h3TG/jTngPkv663PpvQQxHRxcGP4lAY4GeWrni3kbH1jdPWoN0Me5fWtjV4U3+kfReG8vD3zrUQBCZnsy6XRILRXfl+PKdGkBlvQJUHId4UjYcut3BErLJ5UYm4eMO+5fcQZTBwrdfbrZUc38jZ/kCWbWGfXRgJAxhkI76HzZq+YxybSAgqEqzD3XY52zeOL0LfX8+lYTG2KUOCFUpZa55ytqJoGFJdror11ztFbL3pyvVudZO4PnMqShIbdstaD8PIh7lWwNpw9APlpxYW1RawCwur9vGn3qAa4rWAzrZzwUhzcOkXjBhLGpQyi8El2qNAvu42dE4Php99CGDNHh9cYcp6/S5cEHcL4ejNbYJdZG5llUw0C7gR0Fluav7s3n3oJsodxbamIU2stvNhSSCvMvaRXlrqwx54FlhdTP9ntclXWsrSdnKlIQAwPMvorBPgLzmGRU3z4eI50uZ2xu/idyUr+m8vXZBehXXJZyPrS9t/gBI5Si63ZBJ1HNoi8VXEUS5U46HflfrQsh9617EuMckIHNbgKYiAx1VB+0scUNowdnNdJQbeP2af/v5Yduh2QDUWHdvV4qpPX/zvi7d9CiOadQL0fFt9porqBEqqt3EiQWWhbohV6YhHD9HhwaNN1SyD9MNWAchEeGUWsPti/R6lGE4/U18kQdQDTUXvuN1wnnnzf73uQDvGIHjOE/BhlBpLHD7322wrMHoqPMMbXIjv7eo3vL1PEIOTDoVjPEdDmLnZ487azSH0R5ndMvvXSXRm3Ums017tQ
 BLYiP2PS
 dgpekhhHHHNbfIg7ilaUnu4SJJpFGVN5DuBoKhKD6tsAPACHfCf3UtoFwVaAd1A3dmXz0aB2mdYyBwW+TGlQDDnEyodh8fKKextX0FLLQexTYcmqdXWmG9Jbb8Xcg50ZyTrMjE1TWFSoOLNTIRzfRGecv/r8bDRu/048xoG6lkar5zPcp24rv6UQNegyoSSD5mIkd/GLSn4v+WMhfYMFWGQWZ4BTGJbCc5ya0q+aNbw5fn1BggwYJoigXnKSLgsgC/FU4IZa+t4nE8bdQFIbTO5lfeeGUFumGpjiglgbX7hUOrXVo024Dlo/PcXqNlR6NM9xj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mirrored regions are already skipped when initializing ZONE_MOVABLE, but
overlapping PFNs can still be initialized from the ZONE_NORMAL path when
ZONE_MOVABLE is present on the node.

When zone_movable_pfn[nid] is set, skip ZONE_NORMAL initialization for
non-mirrored regions, keep skipping mirrored regions for ZONE_MOVABLE.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Jason Zeng <jason.zeng@intel.com>
Co-developed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
---
 mm/mm_init.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 24e103a402b0..2a5ac175d5dd 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -941,9 +941,18 @@ static void __init memmap_init(void)
 			if (!populated_zone(zone))
 				continue;
 
-			if (mirrored_kernelcore && j == ZONE_MOVABLE &&
-			    memblock_is_mirror(r))
-				continue;
+			if (mirrored_kernelcore) {
+				/*
+				 * Avoid double initialization of PFNs that overlap
+				 * between Normal and Movable zones.
+				 */
+				if (j == ZONE_NORMAL && !memblock_is_mirror(r) &&
+				    zone_movable_pfn[nid])
+					continue;
+
+				if (j == ZONE_MOVABLE && memblock_is_mirror(r))
+					continue;
+			}
 
 			memmap_init_zone_range(zone, start_pfn, end_pfn,
 					       &hole_pfn);
-- 
2.47.3


