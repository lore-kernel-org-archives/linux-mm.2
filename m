Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65B59CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 09:35:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF2D76B0095; Wed, 20 May 2026 05:35:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA3FE6B0096; Wed, 20 May 2026 05:35:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBA216B0098; Wed, 20 May 2026 05:35:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A94C46B0095
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:35:29 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 552988C2E0
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:35:29 +0000 (UTC)
X-FDA: 84787290378.30.E9E9009
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf28.hostedemail.com (Postfix) with ESMTP id E5B45C0008
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:35:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MC81Hg9J;
	spf=pass (imf28.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779269727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dbZZlysJk5wHgXCnpvRsHuaX472l/kHEcbFsXiQKcZE=;
	b=hWMr4FowJBd25PSOH9aReGIKCngAZa3biVYFNLZo3zyEXJV9C0fGm8PThGVgayvdSijLHy
	ycriP/vLVJ5n3LOXS47g7dPvtedW8TTd3yf85WDT5FtKdeWhNhU02uJDm4V4fwObDDGQ/N
	U+QefaLavcuUmErbpBb+1DI/F7dbAtw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MC81Hg9J;
	spf=pass (imf28.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779269727; a=rsa-sha256;
	cv=none;
	b=OQMgjQSpEMWDrodZZWZawrxyIqpMJuMWoaIVeDFN+EbUWyxu67TQgqIKKIdmc8oDIP65tG
	qADkXXGjhetThK+xWgfNvgvYn6qX3LLzLlfFbdSD1P3Fk0HLqAjRZ2EFQVDIdvSqzpdHQh
	yT7lzLdAXLLHbOgEQLeImPQ4T7f1P5I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779269727; x=1810805727;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MqIJN0Fy32kCmW8Oj4ICCcOYTdwWCmyNlkmwYInBsYw=;
  b=MC81Hg9JgDOLzoTbwZ8RaZJDQtw5ghkZDVfqW8V3Rv9MfGR3t69FmeHX
   qGmFo4mjPCBLMb0raYx70X7rffWDl0cjToyAV+51qUYbCmoRQ7UijsEzO
   0WL+oVpPq/+fdXmwVlJ6tiWHayx1s0bL5/PMY0Vq25u5z9QxkChoPLOv+
   M2x77Xm8/EoH1y8sqGwcnJ2kHYAyWCR1KkcIUmvQ313RoUe9wv/TGNy/f
   6Xe7BASbsQaJzwHUsqFdPsfuG0iqhV+tSinq9s4ez3M12sAg/aJFWctWL
   L6RLDjSQ+1SQ4if2/jzD0EgdYh8xoOdUr+zrZeuo2jhGWrvctbsy+ce/+
   g==;
X-CSE-ConnectionGUID: fvE5gJDORH6Yh1J1WV95+w==
X-CSE-MsgGUID: 2KU5auRWTSWEIgnlD20GMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11791"; a="90461030"
X-IronPort-AV: E=Sophos;i="6.23,244,1770624000"; 
   d="scan'208";a="90461030"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2026 02:35:26 -0700
X-CSE-ConnectionGUID: 3NbMSwL1QkG0TB/48wOTEQ==
X-CSE-MsgGUID: J2pJTsYSS1exCHtEuEvOGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,244,1770624000"; 
   d="scan'208";a="241925198"
Received: from spr10.sh.intel.com (HELO localhost) ([10.239.23.75])
  by fmviesa004.fm.intel.com with ESMTP; 20 May 2026 02:35:22 -0700
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
Subject: [PATCH v5 3/5] mm: remove the special early-section handling from pfn_valid() and for_each_valid_pfn()
Date: Wed, 20 May 2026 05:34:55 -0400
Message-ID: <20260520093457.3719960-4-yuan1.liu@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520093457.3719960-1-yuan1.liu@intel.com>
References: <20260520093457.3719960-1-yuan1.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E5B45C0008
X-Rspamd-Server: rspam06
X-Stat-Signature: 1reowiezswoheq1je4466s9c3xgb1kqf
X-HE-Tag: 1779269726-815019
X-HE-Meta: U2FsdGVkX18Jjaf4xqVVf4Klky27BsMWLn6kfWJUKirs/4X7G8XVFp+el2sAUZMt+bZPffKQFg51iruKg6BlOjkSifCneaHJvjmlwE2RU3ZxgPp/2EwJI7uVA9nrRkZkUtreVve4givpZGOj13tkBHm/xS8amVsuH5Of2FEv59U7BmTIVfnve+fiNpJrd75qgik4vcYX/EjjsKhFPOxF/F7xBAFsldVbbq3ideW6SYMyELTLre5861tf+7PcRnrDjpaeBPXqJI+DbGgYCuHCycRe2o0IUK9uqHSskn0PpeetjK7iAJl5l6MA018a5rsgXAzC1RicIRNz2Vaz6C9SRAQecKSJFT/E9G7UvKFG3k1rixbnuCDx9btQWjlFsfNwhMOeji18qAR4qqQrWRkL7rWE5oGkxbipyiHVZxjbLfvfBAcUbG/1BOM0g85JqnovEQJJJUaUPPIZ99PTeE/mHAn2OQmylhr7/XFsy7v0fLr3yUtTDNsamTNWCCVOUSBgGkNCjLJVjNgMvsjreqyy/VYcszj1aWsIgsW+dGEoHmikFapLd59VvttoQuzcfEXoP/yqdsuWsY99UIuCUUsxzJB5V5+XVI3Y2384ZFKfbPuWwzC3Rag/Vj1P6x4KQNkwkjrHoeIxGMYE3KMk2q2dobUKhcbLpefljoFzSPnLRNBohTb6UdSZEju1AraRy6zGtWKdqiJ2C8rA2GfrlELiMORjwIgum/mAyJPtkMGRhsH8I9I0LUcgIIq4D5IkUV8n5++VyJ3ACiPN27KO3aIxG8l7/R4QQkrFHR9N9b9PklMYvuDSWt++MQML2VmShlTR/Q9qo3i5qNrNqO9JWpK7p+oStfR891TZs+aAyLQzDmVv+/3hHnhDK+0OzrgLCyx6kJMcFlSfY4HZIvL5PopSfImS9I/C+B9ZaNgFsaPEphFNOmL/hDYcGUHT8mthYTpyOC4uEVfd0TJGUxl9jgH
 aUobuuHy
 x9xiaNrwZZAjKl7DAwMkzHjXFmKifurZlc+dRirXnswuMqYWzkTVO2wf0o2a/IopwqmlcBwGLb0vi6mfNwg5YU2e7/ikykUyx6zxwfgOKCRuBXOI2uCZfP7aHpF08dtnCYNXy+YrDQfdtiixzwtob9bNwIgcpuLpXMOle0C8Zkqp7UIgBMKOIjxkeSOBLC9z+37GNc9PakHMmNoBFO4c18qhQ1fDgjnoY8wAuDbvnT4k3uDPV8u8MmW+ExLZ52+nDrjOMIGYlKmEhLmp/Gu0rEHzynLXxU40KRAeZ8WqPbLPX7gaqPIld3Svkxd9MQT1U02TA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make pfn_valid() return 0 for PFNs that fall into invalid subsections
in early sections. Make for_each_valid_pfn() skip PFNs that fall into
invalid subsections in early sections.

This change is in preparation for optimizing zone contiguity checks
based on pages_with_online_memmap.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Jason Zeng <jason.zeng@intel.com>
Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
---
 include/linux/mmzone.h | 13 ++++++-------
 mm/sparse-vmemmap.c    |  4 ++--
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 9adb2ad21da5..783084f8bbfe 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2259,6 +2259,10 @@ void sparse_init_early_section(int nid, struct page *map, unsigned long pnum,
  * there is actual usable memory at that @pfn. The struct page may
  * represent a hole or an unusable page frame.
  *
+ * Note that this function returns 0 for PFNs that fall into
+ * invalid subsections as part of early sections, even though there would
+ * currently be a memmap allocated (that should not be touched).
+ *
  * Return: 1 for PFNs that have memory map entries and 0 otherwise
  */
 static inline int pfn_valid(unsigned long pfn)
@@ -2283,11 +2287,7 @@ static inline int pfn_valid(unsigned long pfn)
 		rcu_read_unlock_sched();
 		return 0;
 	}
-	/*
-	 * Traditionally early sections always returned pfn_valid() for
-	 * the entire section-sized span.
-	 */
-	ret = early_section(ms) || pfn_section_valid(ms, pfn);
+	ret = pfn_section_valid(ms, pfn);
 	rcu_read_unlock_sched();
 
 	return ret;
@@ -2303,8 +2303,7 @@ static inline unsigned long first_valid_pfn(unsigned long pfn, unsigned long end
 	while (nr <= __highest_present_section_nr && pfn < end_pfn) {
 		struct mem_section *ms = __pfn_to_section(pfn);
 
-		if (valid_section(ms) &&
-		    (early_section(ms) || pfn_section_first_valid(ms, &pfn))) {
+		if (valid_section(ms) && pfn_section_first_valid(ms, &pfn)) {
 			rcu_read_unlock_sched();
 			return pfn;
 		}
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 6eadb9d116e4..c6eefbb6013f 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -771,8 +771,8 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 	}
 
 	/*
-	 * The memmap of early sections is always fully populated. See
-	 * section_activate() and pfn_valid() .
+	 * The memmap of early sections is currently always fully populated. See
+	 * section_activate().
 	 */
 	if (!section_is_early) {
 		memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
-- 
2.47.3


