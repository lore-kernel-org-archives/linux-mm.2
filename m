Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3633CA9EBB
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 20:31:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E89B6B0099; Fri,  9 Oct 2026 16:30:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 671926B009B; Fri,  9 Oct 2026 16:30:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44F576B009D; Fri,  9 Oct 2026 16:30:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 237766B0099
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:30:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B42BF1A04E4
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:30:53 +0000 (UTC)
X-FDA: 85304231586.16.2E871C8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf02.hostedemail.com (Postfix) with ESMTP id 61E5F80007
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:30:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=A0N9NLt3;
	spf=pass (imf02.hostedemail.com: domain of ehab.ababneh@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791577851;
	b=7LQrxc/T7RgdkhJYJp2cELOFuyREXIxeKcHnWAGuXxexVB0wgbFxH34tTlFT28nA3fFaqX
	bo1s8WCDjGBOXFauDvMi1rlXoeQZmfu/8NQLHBRgnQCx5wTouzsvXWTpeW7u/TM8R1ag15
	qrMvMP0aZjRbx19a8VJ2tNzWz8A4pLY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=A0N9NLt3;
	spf=pass (imf02.hostedemail.com: domain of ehab.ababneh@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791577851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cjog8TFeq5/ANMeN8EIBZBOVHlkhxty95LRxWGJpWnY=;
	b=0cA6n8O7YzTb1gZjNp3MrFYW+k88roYPBJJElV1GMbmKyny4KnIiWARaicYgOpVpP+wqZh
	vT1xJG9IHxj54L+yfMyD3ak/j9tA8VdLWBRhaXt1+Yp8QNuk1UNCnbvoF1PF2sgEQJgotV
	Nh6+f+8ImHiemW/6wua8qFNZAKNqCXk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791577851; x=1823113851;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IFIInZQhNe0bdNDONN0itzEk/3PUJZn9inDx3VVu3Es=;
  b=A0N9NLt3yrOHq+i/fpxBxgcx97n+rFCtTGGMe07QT1fJPYMze9XoJ7Yw
   5Dgswpv7wPdh8Ufxf4TEiKVPVaCRN5uUPpWnOVKREbIuplnyGkqX4HW9Q
   Y02gTNsp6kKEnfyAC+ZrgYW3CDilYUXb2gHjzzu5QnRTiywCUwg5UCCxE
   3Om2KZrxGOqx8Ht4LRI9dizgklETy8H74LJPfrUqNpEU+tiMy0HlouNS9
   oGnRccUnZg/GXpMTYDG4amEBXq1oLbHII/qXQKgc+pE25J9SXz9PcLmY5
   MJl9eOGLhFibVk2TcqHINj8QlTAdztLcflm9iFk7vkf2/ZmRTUeYnmRLR
   w==;
X-CSE-ConnectionGUID: U+zCQ1/gTZucQu8Hph38FQ==
X-CSE-MsgGUID: /tFywSVBTquXSeg/xi565Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11930"; a="284584"
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="284584"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 13:30:51 -0700
X-CSE-ConnectionGUID: EK7VJCYxTf+XBcOm2hSGbg==
X-CSE-MsgGUID: 0oiAbEXpR+yHG6ULyitaKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="2193207"
Received: from jf.intel.com ([10.165.154.102])
  by fmviesa012.fm.intel.com with ESMTP; 09 Oct 2026 13:30:50 -0700
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
Subject: [RFC PATCH v2 4/5] mm/vmscan: let kswapd scan minimum-generation lruvecs
Date: Fri,  9 Oct 2026 13:33:03 -0700
Message-ID: <ef298caa858b365641b23367316e5dbfcc2a89b0.1791577417.git.ehab.ababneh@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791577417.git.ehab.ababneh@intel.com>
References: <SJ1PR11MB6105E073723CFEEE8C8EDBF48C832@SJ1PR11MB6105.namprd11.prod.outlook.com> <cover.1791577417.git.ehab.ababneh@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bqkxeu7qp6myr6c177cbjg5xzow3hyrn
X-Rspamd-Queue-Id: 61E5F80007
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791577851-254893
X-HE-Meta: U2FsdGVkX181HHQ2/pdcpp4EfEu+fluaw+YXlrL2Y4T/S02kMXWJRAb8bKQW5v/48OZQbC4EMopikXKO/S9kLZUJKB7Fr7ta3/A9Ut1zRwtv8p76D4Q2ZQccxB4sPJxRQCe2XzdnXmfmBGFOaWfWPuHt+YsnTK7BQxyLzSgEgZohdnajJkfXLEQc9MIr2rOzADFS0lo3+Bh0lFoqxWTHn27edG7pxwkEyCRZloUi2zdRedEJOhc7pFCzNbWYnLhCZuJ3rRhHQ/SbGSRzpjKf3fssrJ4NH04uljn2fEH2T/Hyl7a+yu/Hm0+65U9WcB4q/fdk8ApOl1hBSdG45kYNTS7ryqd/kG1EW3HpSJZy7mmMpPbC8wISTx+C6BBAQ7PCBbIh3wF3Mrgm/01xAyGWavblE/KS2U5IDeOkIHDetI+aW50sNV6+tQq6RMJpRha7F+OPPh+XKgwnFUpxgqw+HzV+2jw8jsQ3cpYS7D8LtkOARuBiUM1x6p7sNi+U0EBwEGnybjRSre4xgb4UjFiP+qzHnnIpNqeeVDGa7gF2WPf/AqqDtPi9mRHnWA6RW3/ioflf8OYfQ+ppzBfsjJVHHv0VMc3Lf+x0zJTmp/v4CrVOpR7iCk+MxH+XIwodxyxWgZLW7WVwFkGGv2TypH9Uelhx0rfnJUazJF/Xt5rlPs7c69zFrZZPSmHFhYkAuuavlWsIKTNBLCdY4BA5rkIYLYUOZ4UDBAiLYp8nTQo1jCyeNBLzaA3kmuEdHMPTLlgdGDtPI4yTcksjI5UEcufeddfgPPP+xvTY4cswdP/7bMVhnNKiMvaMT4iTm0UbtwAjpH/h0ewvIbHvG9erClEuNH98jw3zFeRQrStJeFqsJfVeXKPWdu6NbjBAKghO8j4DjjrKpqMTPiY1UnW53R9X212kWf8ra72bQNbNG5IAaQGrCKs5XGxdXRKze+W2brFELKMDd231Oav+QKPczvE
 7CPYAcxN
 IF/2KY44LAYbYQTI95XRmZb5x2YtEFWfrEf1NWJ8eeRoGOklxw7cIGrupwZzNC075vmvre3YrNC92BQc2+7Yoji+ZYdYDDqsxYNDghBORBQCFA1x0LpIW+xRCVrunHdY0z0vqbnm+MZ4dgm8QEsf0J7pjbYzOkORdy2lwRjm7xI21ElWNKklOrfuGJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When an lruvec has only MIN_NR_GENS generations, scan_folios()
returns without scanning that type. Let kswapd scan the oldest
generation while keeping the early return for other reclaimers.

Under memory pressure, an lruvec can end up with only two generations.
That leaves an older and a younger cohort, a bit like inactive and
active LRU lists, though MGLRU tracks age differently.

This is a diagnostic change to see whether kswapd can reclaim from
the oldest remaining generation when aging does not advance.

Signed-off-by: Ehab Ababneh <ehab.ababneh@intel.com>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 95cf20183efc..9e051aac2203 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5017,7 +5017,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
 	VM_WARN_ON_ONCE(!list_empty(list));
 
-	if (get_nr_gens(lruvec, type) == MIN_NR_GENS)
+	if (!current_is_kswapd() && get_nr_gens(lruvec, type) == MIN_NR_GENS)
 		return 0;
 
 	gen = lru_gen_from_seq(lrugen->min_seq[type]);
-- 
2.43.0


