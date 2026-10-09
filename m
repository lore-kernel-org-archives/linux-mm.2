Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1BEACA601E
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 20:30:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF1616B008C; Fri,  9 Oct 2026 16:30:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA1896B0095; Fri,  9 Oct 2026 16:30:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A911D6B0096; Fri,  9 Oct 2026 16:30:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 87EFD6B008C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:30:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2A0B51A04B7
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:30:49 +0000 (UTC)
X-FDA: 85304231418.03.DD37685
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf01.hostedemail.com (Postfix) with ESMTP id 48CB64000C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:30:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XnyzZ8tU;
	spf=pass (imf01.hostedemail.com: domain of ehab.ababneh@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791577847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ycYy6SHf3ANuY4gUEVjU91AdwzbJc8qSnrbjYg5csvk=;
	b=E+3fKmkbybvRqT8AdosMKli6z+D1/Rimg8+elN8u0AaCnABfZLsH7uhm83Zl+yU/OGvJMu
	7G19sT9Bf2ETUXyAoZOitizTw3SS1iRcv2xZj64zeJ0J0eaKaS6wH6YEbUiZtiJr/8Eo/V
	+0KMKJjRmo4qUtfJN/NmolF0gaF8qFA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791577847;
	b=yJPOQ6IJ0DrdKCkAROMZby2FD5wpAFUWZG8Tkd4lMH4toIENo1xgqXwahvzqE9mgmeJPoN
	hlFkzvjME+h2aJ4QEf5drc5rUMadaDVwYrbzaZWE1AAUairWb4AEm16GllYSJ+vc0xKqzf
	UTtPO1CmyaBFrAPnMOt69A5huX4HcnY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XnyzZ8tU;
	spf=pass (imf01.hostedemail.com: domain of ehab.ababneh@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791577846; x=1823113846;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uPv+lkmfoZReZPQ7M8bL3x++awqz19BblcSMktgTkfc=;
  b=XnyzZ8tU+QY3U/snv8E/THYXhIKaz+wXnSQuEoRmMdhGyL2Xe2hCLNUS
   kl1ozEwD38oZu9egWJqam7mf2AaJI4MuSgaMSaOpOEJwawPzZ7BdimZwG
   d8Z5LgFrb88b1FeOVaTa/RSxE94NM4cSvqeWNICIye7A+mKwz02FealVR
   WlfTVJeAQvoc/hZmkCDrCeKD1DCLT4HDr8tJqjAxtLApEoWE4KeD4JCuZ
   7lLRWvZRkgAYBfR1FLhSvj5k2/axFS7UpIgo9aojkm4QucD8m3A5gm5Wq
   IfmrOEhkt/O28/mKXDEhqz8Gv9PngpfWFzRiiCV2Y8Gc+2/SaFCophwvu
   A==;
X-CSE-ConnectionGUID: tbcvmM5ySp+deugXfPJ+OQ==
X-CSE-MsgGUID: CADyVCt7QqOxooDXSOhvfw==
X-IronPort-AV: E=McAfee;i="6800,10657,11930"; a="284520"
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="284520"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 13:30:45 -0700
X-CSE-ConnectionGUID: 7XE8ESMGSSO3WbG4Uk6sjQ==
X-CSE-MsgGUID: FKQDT1TqTwqktiSyV0ePiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="2193152"
Received: from jf.intel.com ([10.165.154.102])
  by fmviesa012.fm.intel.com with ESMTP; 09 Oct 2026 13:30:43 -0700
From: Ehab Ababneh <ehab.ababneh@intel.com>
To: ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: buddy.lumpkin@oracle.com,
	akpm@linux-foundation.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	Ehab Ababneh <ehab.ababneh@intel.com>
Subject: [RFC PATCH v2 0/5] mm/vmscan: adaptive multi-threaded kswapd for NUMA-aware reclaim
Date: Fri,  9 Oct 2026 13:32:59 -0700
Message-ID: <cover.1791577417.git.ehab.ababneh@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <SJ1PR11MB6105E073723CFEEE8C8EDBF48C832@SJ1PR11MB6105.namprd11.prod.outlook.com>
References: <SJ1PR11MB6105E073723CFEEE8C8EDBF48C832@SJ1PR11MB6105.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 48CB64000C
X-Stat-Signature: kejuige7px7ajkzxptbbi3pkty6hr8ry
X-HE-Tag: 1791577846-979039
X-HE-Meta: U2FsdGVkX19aravhQfByoMXeZ+S45wZM704li0p1d2LBGRidVhaIbdBJOSzBj/6RcTg2qXqvYUKkOLTSUjz+dcD2tQqGdF+fjMPijs0/tj9iy+9lMpsZ33pTKS1k/92YSGMkqI0CW7op4XKMPyLk8k8fsSoM4Y/Uf996xcmO9K428GNf+qG6JIkDKnzx8GlaQ092XxzLyHErJ5UFN47DOH4DDg7Vn6Zn2EjdQYXhfULxZB1Ts2qU1TEqSpQ+/vd5viVjA3WCnAPMMOdNoWNtTZ7FRQdeH8hraMV/SCbd3Kw8F5MEWPDWEpcfFVwYXzVPhdg6Igdc7x+dMi81Z0f5aYrqmoTBi4ZOoabtUnSd8/yl5bm8MZQyShQFv1LwdX5ufaWXqoaawWT7/Glgkp2aXyqb37r0acoZsHn+qA0KMaBOXTSC7U8pj1plS+tV3QrWRTEW9o8hF/rD4ZvwwBoOAi0BrpU39MOSKJl3Z6yRUr+oMi3KyTTbw4zOWQzxEA802KGxUeBSqwU+40hovhfuoDQytcvghmoqigSLn4/YzGYvqFXFHc70T6fTmpi3NE0+WZgDzSOziWZsAI6an9tk7kHce8qG00ZnPJmQJgTm35IenKsElQhdv/DRImRSxkqCYj20T7HMecNSuL67jN4zP8bDzyLn0UvFdaqTnB41qcVoM7wC7+nBHE/7zGAo0sd0mbyrsmhVZLBDr62wpOj/reV63W6+6Z+DeJT1q0Ra8MLjyRS1JFWCLZ/MeqKHqyh8mc7+GS6cytzk0gTgUEBqn37PnVu5SM/Zj76t/PhcoU1PA7HCCpsf2rVV/iYtzWW2VGBwW3KTdJbVzZZNapWMlzD9fSPX70WDLb+1o2+29qSxxbijKBQaAz/XcG1gEEEeUYZvIh7+4jz3LM8NliZk+PFJEQjC/9pREc3G/DjOk6nCzyAdl49yISiG5venMWW2RkeJPRHBQYNSOtALTtq
 TlD1GrW9
 p1H0ZQaNMYCrMSqtyZy5bgNbdz0ngp5oToSLq7xZyMSbMejXG+rpTicBTdOgAjuDsPwEYm74Wh2wuxXtXZ1vXRixFHwyuA81pr9/p4239KKdnqrDN8+QadOU50+/wnOPRcbHV6DlvKcGGRo34z9k8S4cDKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a follow-up to the RFC for adaptive multi-threaded kswapd
on NUMA. It handles concurrent MGLRU aging, adjusts wakeups to node
CPU load, and scales the hopeless threshold for multiple workers.

Under memory pressure, an lruvec can end up with only two MGLRU
generations. That leaves an older and a younger cohort, a bit like
inactive and active LRU lists, though MGLRU tracks age differently.

Regarding the concerns raised in review:
- In the updated Cassandra comparison, four kswapd threads reduced p99
  latency from 6.5 ms to 3.35 ms (about 49%) and increased throughput by
  10.3%. We believe the latency gain comes from the reclaim design,
  not from changes to LRU locking.
- This newer result compares four kswapd threads with one. The earlier
  7.3% throughput result was measured with eight threads.

We also saw periods with zero file scans. The MIN_NR_GENS guard may
contribute: when only two generations remain, it makes scan_folios()
return without scanning the oldest one. This patch tests whether letting
kswapd scan that generation helps reclaim progress. The current traces
do not tie the zero-scan events to the same lruvec, so this remains a
hypothesis; more per-lruvec tracing is needed to compare it with lock
contention.

Changes since v1:
- Add a diagnostic kswapd scan path at MIN_NR_GENS.
- Scale the hopeless-node retry threshold by the active worker count.

Testing:
- Cassandra workload with one and four kswapd threads.

Buddy Lumpkin (1):
  vmscan: Support multiple kswapd threads per node

Ehab Ababneh (4):
  mm/vmscan: silence spurious max_seq race warning
  mm/vmscan: make kswapd wakeups NUMA load-aware
  mm/vmscan: let kswapd scan minimum-generation lruvecs
  mm/vmscan: scale hopeless threshold for kswapd workers

 include/linux/mmzone.h        |   5 +-
 include/trace/events/vmscan.h |  32 +++
 mm/compaction.c               |   8 +-
 mm/internal.h                 |   3 +
 mm/page_alloc.c               |  26 +++
 mm/vmscan.c                   | 426 ++++++++++++++++++++++++++++++++--
 6 files changed, 473 insertions(+), 27 deletions(-)

-- 
2.43.0

