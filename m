Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C868CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 09:35:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8121E6B0099; Wed, 20 May 2026 05:35:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79B466B009B; Wed, 20 May 2026 05:35:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EE7B6B009D; Wed, 20 May 2026 05:35:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4FB0E6B0099
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:35:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 13A0CC0FF8
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:35:40 +0000 (UTC)
X-FDA: 84787290840.25.79B47B6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf01.hostedemail.com (Postfix) with ESMTP id D792440003
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:35:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hJYzq1qV;
	spf=pass (imf01.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779269738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ulidh9o+kQ9Hce6TxPFrArbsasuCKX5W+8P29yGhdqQ=;
	b=tmhT0Eo61WF1ZpDCCoH8VyeJWgfcr6/Q5W2iHyXh9ara9+GZE1xJHuL9vzdcExKahCdZ3R
	qQGJ+5eloQcEj4RS3uctv3kbE9h1r2EAES2A8syA0Q0i7b+FrYBGVah1CQdm1KWS1q5+Ey
	PIBdb8pRDnvgJYfK8bgdCWZYrFwLDrw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779269738; a=rsa-sha256;
	cv=none;
	b=pGOPxVEsRYt5g7ZogpZXFXQc3Xyv5S+kZLh2+dp1s4oKAyNiNWJqBXAHaHAJTJEMQfLPmi
	/T5raJvq6VtfvP6c0nGxOmD555PyGbsGNFJBlJPTWJ6zP9euVoCGD1Up2YXkB5KvwKS/uz
	g5GkSro46P3eWuJLEWatMC6qOE7FdtE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hJYzq1qV;
	spf=pass (imf01.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779269738; x=1810805738;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XavP1vUJllc7NA9zCR5LarxqZxkiJyUBCYCui0GExNc=;
  b=hJYzq1qVF0zM7Q0MW9MsejhOXKPCgrad31xFxduotJ5bWRQo9TtuPqz+
   hG37hZsJ25jxH4re70WSrQB+bpc3iEmn1Z/iqhJzRXA4/ewL56rqHHiSd
   VRYjMQubmCe43rX4RNZNuD4kekHilHCXyYLBon8X9sHNB9XkcvvNcxwne
   oF6bH5NEQ/cXt8YzElIHPW+RDZOj07gf/87goG8t/BujiGkvHWl0pEhSB
   au+qdyASz1Bx1iGKeklLsxMc1iyx+JyQdBWxAK5J9SwnNzWXmy69cWoo0
   NFysrH400epFA63fn7lTvq4EJuu3lSwMulVznm4yOXIKiCPxqaatkFgQz
   A==;
X-CSE-ConnectionGUID: bQRC2pwQRf2yjc6q0p+Zog==
X-CSE-MsgGUID: +Fe5+ysFSyqZJuYCuSl25w==
X-IronPort-AV: E=McAfee;i="6800,10657,11791"; a="80196887"
X-IronPort-AV: E=Sophos;i="6.23,244,1770624000"; 
   d="scan'208";a="80196887"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2026 02:35:35 -0700
X-CSE-ConnectionGUID: Vm3WiHyLQSmXacs/f4mnbQ==
X-CSE-MsgGUID: RAgbtuazSsGhzDvr0km2mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,244,1770624000"; 
   d="scan'208";a="235672601"
Received: from spr10.sh.intel.com (HELO localhost) ([10.239.23.75])
  by fmviesa006.fm.intel.com with ESMTP; 20 May 2026 02:35:31 -0700
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
Subject: [PATCH v5 5/5] mm/memory_hotplug: improve shrink_zone_span() subsection boundary checks
Date: Wed, 20 May 2026 05:34:57 -0400
Message-ID: <20260520093457.3719960-6-yuan1.liu@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520093457.3719960-1-yuan1.liu@intel.com>
References: <20260520093457.3719960-1-yuan1.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D792440003
X-Rspam-User: 
X-Stat-Signature: ghexkik4pjjsdj5xtsbskj67t5kryhzc
X-HE-Tag: 1779269737-397973
X-HE-Meta: U2FsdGVkX1/D9l5/Rbqa5vE1YWw6/fozW6kumWD5vQq2Cr9TeqGkI1qYulimMpVlDvumbqaQnodYLDpVIogauGiKXOX8+IXLgA9HPZf/vNfHPMb+R2d4w0WcAuc6U46lLV5C4LrG+sjWo1Kvvroap0F3LrY0CTSifD4xBjXHBSw/YPjuRW8c4Aq38S15NSX+DFx5EqGp2J/OMDl5Vmf2AgLhEWTSYVPt9zqSLXPsscc3JvKsKcQzQwjCb6WR9LjUsSPiELRPvYweQkdfQFpbAdWnvR+K7jCvMxd7N2mMTQH8dOBEI0ejLuLCHbW3+HIbD5AEYpkm43CFipYU/7Lf9edODksKQ8NdNCybChDanBYFZ638cPSIr60eanSnEG/F2sv3Jx9E4MWld/yXLJ11PabteRtl2QbWODnxj624W37uAOLOrfqnbDKB6PEiZRO3A6CX1RSgITLfRpGphFzjcemSUT7s27sepa9k5bscum7TKrjKNCj6Be+Zxa3gNURXiJ+KKc3sOTwQXfsInqhJuw/OX8FdFH3/DAj1vYXbb/wh3jP2hogLKqKLU5SLfGgChFz9hBrfsUj9lkuEYFNyd3cfsbCpVBwVN6COIxRB+Psmlnz0qNN2o63F3mKGQ0FqTvEYbYG3mxwWMPp6DAox0NebOqxnlLBTnJg8+qlE+izxSJ7raSCH0OD2KpXK+TJpuQZ1HmLACmJaBqYS9fBcyy8DfzN6/Q1C0zO+2HwM193pe1m1vBQ25ft61XIyoUVcWP92T9xJcjW9jpQP1UaQGTVGYmMQOfem14T8d+ufABiW26MoHA5uOkFQ9Z1z+FuEBUA4PK/qaa/eeHLaPQpxmjtq17L/v9j4jfdlF5WNJr8bhI4JfOhWfrcnTM/nLfRXX1Wsm0z9oQ5c49M/kuM1nzTXRo+AWUhJIdb1L0IHAWS4nF8iUicmkx1eaIcxzFnCHwoq7lcxDXlQlvnYpV1
 3CqY4NAO
 zGZtYw5Rqd1J/dPUGxcrZCn4Z5GH+qs6fZ7aY21al2OBkg7vlLvOQtIFBaz2FNpF6on3OGPS7+B6/F6Td6HE/3QlTftaavmugwrdqHsQM6xEIIrfSksogIdnr8tlypX23o277h0qwK5PlEjAC2oUgYxj64ji8+d4P0aOscLpxJFB5G/T+uG4pXRJgq3rdMs+XfI5XN6XlsJR/d/QQccvqr8cF9gqc5cCKR6WU8qYWw/4O9BmYPfb7KndT5PImb6XWaAUwfvrJjwz3JPt4RKGbB1Wn/HRX7yGKpF97s9+N8J2Fiu/EKcp1Sdq0nsoANG49ygz/IR3UCiF+h+WNL5P0G7EfUlnTz0DA6GXu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When shrinking a zone span after removing a PFN range,
find_smallest_section_pfn() and find_biggest_section_pfn()
only checked one edge PFN in each subsection for nid/zone matching.

If a memory or hole boundary falls in the middle of a subsection,
that edge PFN may belong to a different nid/zone, causing the helpers
to miss a valid PFN within that subsection.

Fix this by checking both subsection edge PFNs for nid/zone matching.
Keep a single pfn_to_online_page() check per subsection, since online
state is the same for all PFNs in a subsection.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Jason Zeng <jason.zeng@intel.com>
Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
---
 mm/memory_hotplug.c | 42 +++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index fbe863441761..20b61f70cd81 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -427,17 +427,24 @@ static unsigned long find_smallest_section_pfn(int nid, struct zone *zone,
 				     unsigned long start_pfn,
 				     unsigned long end_pfn)
 {
-	for (; start_pfn < end_pfn; start_pfn += PAGES_PER_SUBSECTION) {
-		if (unlikely(!pfn_to_online_page(start_pfn)))
-			continue;
+	unsigned long next_pfn;
 
-		if (unlikely(pfn_to_nid(start_pfn) != nid))
-			continue;
+	for (; start_pfn < end_pfn; start_pfn = next_pfn) {
+		unsigned long tail_pfn;
 
-		if (zone != page_zone(pfn_to_page(start_pfn)))
+		next_pfn = start_pfn + PAGES_PER_SUBSECTION;
+		tail_pfn = next_pfn - 1;
+
+		if (unlikely(!pfn_to_online_page(start_pfn)))
 			continue;
 
-		return start_pfn;
+		if (likely(pfn_to_nid(start_pfn) == nid) &&
+		    zone == page_zone(pfn_to_page(start_pfn)))
+			return start_pfn;
+
+		if (likely(pfn_to_nid(tail_pfn) == nid) &&
+		    zone == page_zone(pfn_to_page(tail_pfn)))
+			return start_pfn;
 	}
 
 	return 0;
@@ -448,21 +455,26 @@ static unsigned long find_biggest_section_pfn(int nid, struct zone *zone,
 				    unsigned long start_pfn,
 				    unsigned long end_pfn)
 {
-	unsigned long pfn;
+	unsigned long pfn, prev_pfn;
 
 	/* pfn is the end pfn of a memory section. */
 	pfn = end_pfn - 1;
-	for (; pfn >= start_pfn; pfn -= PAGES_PER_SUBSECTION) {
-		if (unlikely(!pfn_to_online_page(pfn)))
-			continue;
+	for (; pfn >= start_pfn; pfn = prev_pfn) {
+		unsigned long head_pfn;
 
-		if (unlikely(pfn_to_nid(pfn) != nid))
-			continue;
+		prev_pfn = pfn - PAGES_PER_SUBSECTION;
+		head_pfn = prev_pfn + 1;
 
-		if (zone != page_zone(pfn_to_page(pfn)))
+		if (unlikely(!pfn_to_online_page(pfn)))
 			continue;
 
-		return pfn;
+		if (likely(pfn_to_nid(pfn) == nid) &&
+		    zone == page_zone(pfn_to_page(pfn)))
+			return pfn;
+
+		if (likely(pfn_to_nid(head_pfn) == nid) &&
+		    zone == page_zone(pfn_to_page(head_pfn)))
+			return pfn;
 	}
 
 	return 0;
-- 
2.47.3


