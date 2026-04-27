Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBEDFFF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 10:36:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DB0D6B008A; Mon, 27 Apr 2026 06:36:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B2B66B008C; Mon, 27 Apr 2026 06:36:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47AB46B0092; Mon, 27 Apr 2026 06:36:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33F066B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 06:36:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E83691A0109
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:36:01 +0000 (UTC)
X-FDA: 84703980522.07.22F8D5E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf05.hostedemail.com (Postfix) with ESMTP id A6823100006
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:35:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nWEdUpAT;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777286159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XXSk08zMbuCYz3sHbrBfgkOX2iAw4JJcZ4Entot1ZS0=;
	b=eivAisvoUm29koNyaXAFEmhnTXHM4fc5UA80uvEy7PyUmyWnmrwssx7yd6iQ2xCRn3tj33
	QlEQncyifzT8po6hPzU9GYSnYSeropIn0pqmrvuKPrOiF1d1lTglWu7/Vs0aa+W5drq1+m
	RGirxnaskteTAda6IaJZIY+Y4QTks/I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777286159; a=rsa-sha256;
	cv=none;
	b=keALPGltYhLAeUBdDAQtNj5zABvCjuxLOvSMz41RqdGF6uErO29t7slbkuTfnHixAq7XYJ
	oy1FdjeKJurcxemAu/1/XQDwyzxxvbLmYCWcE0XZv2L6Cr9J8wZ55Vkld8HWaL6+qpTPoY
	KEeQ0Q2K+aouutXpZs1Am00t4othHSo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nWEdUpAT;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777286160; x=1808822160;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eNfYJi8qFB0xftXT3xe60DzRPizbftXxkLkbsak0mmk=;
  b=nWEdUpATMw+ITN1zJAOa+Or/Nymya2jv5SMIz43nX8xVDyUgdS9X+we5
   jCaJwcRnmaJlAgIGXnGB0vH0hgvg3NXtfN3x5cnyjwvD0A91LEWESRsPT
   GvHBR82m0dIyHGc+h8uHR8m+gRbNx9LTTHpuAuw46FDWM2ZhcuRv3HbVa
   xtZJeQFG5g1jZX/iOSlTCSiAxj9uiQX06VQZwK3y3bBBGgkc6JrTDq9fI
   GNq3azf5YSTfbKeWdLXOeeMdBTO7+//RCr+G6UYQU/0aE8uJOpnGFVd66
   /HeQ1HGKSC1TdFxgPZ4gEm9c8jEEZs/UJxTXQbJiyiN2MfN4mRtNyQwfT
   Q==;
X-CSE-ConnectionGUID: JEcleivJT4qVVm1xa4i54g==
X-CSE-MsgGUID: R7y+mpsoRfW3S0jS3UFlhQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11768"; a="100826048"
X-IronPort-AV: E=Sophos;i="6.23,201,1770624000"; 
   d="scan'208";a="100826048"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2026 03:35:59 -0700
X-CSE-ConnectionGUID: vAErtvypRGWcE36nxLgz8w==
X-CSE-MsgGUID: jlmqFKliQ/iOOrfYHjHg3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,201,1770624000"; 
   d="scan'208";a="264017016"
Received: from egrumbac-mobl6.ger.corp.intel.com (HELO fedora) ([10.245.244.36])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2026 03:35:56 -0700
From: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
To: intel-xe@lists.freedesktop.org
Cc: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Brian Geffon <bgeffon@google.com>,
	Steven Barrett <steven@liquorix.net>,
	Oleksandr Natalenko <oleksandr@natalenko.name>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/1] mm: vmscan: keep anon scanning enabled when swapcache folios are present
Date: Mon, 27 Apr 2026 12:35:32 +0200
Message-ID: <20260427103532.5623-2-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260427103532.5623-1-thomas.hellstrom@linux.intel.com>
References: <20260427103532.5623-1-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A6823100006
X-Stat-Signature: 658jhe6gkepzejjzbi4hw4o85s7zwr7o
X-Rspam-User: 
X-HE-Tag: 1777286159-418445
X-HE-Meta: U2FsdGVkX19WuKxpVXhDVDE9oWE/qjDQJNr0tcWcysCB2HD0Hsp47AOz0g0oVEZA7aLQ4VA7riW21UErk4SiFEuu4DmKCciF6mmX5s4+OAbS4X5RqzdfndZGmVproQ13QekkEA03Ek5fVksxDmfeznfmIxADJFudLlelaM+m0wNda/xdy1KU2uXXG5LQUHtFk2XeSIDbQALhaxWHhna4A8Zja88dfgpvRhVd+PSI2YuyYV37mR85mtVJPjFT1OCHrJgp3AYvugaKMRvtz6cIwUz2Ms/9YqkIEfYdbMvbTlp5K0zHInMsWPTKkF6o92gPa8+qpwYeD2YMWy0rxZwUK4cz1IzzHTm0bolUzcpnjncOGf7PtvD85bNcE3WbP77ZjSVk0bknW0+BQJt72KlQnW4ZCdQEzx/+K9MLcEztW+281kk4S4vnLkfE8/UmRQmbQCCCXQ5HHRHw6gXaZspD37YL6z4UwF3YPmZR8Y/j7JUegZv2+pAVP+nZetaPCts0lSciqKrr7Z8ZCBJL/29Yrej+BUpYPmWzCADaD8dQPAL5JMd4p2TJG6KCciM6X1stF+MNtSsmTttWb9MPSTcvWev/OyU1tq+O8Ylor/FLA8HnyiPUBh8ZO7ySkEJ86ZGuX0vZ4xIvg7k3OFjR9hgIwn+DE+uV3sMdfxeSTyxHrEcnRs1U48hcaOE3oP63RIg8RFoNvoz5f1UpDW4INpTJcZ3N3O/B7gNNuze5f7GZSpYfjJkachZwzfk2w1bFx4ONmao4ztEBYuDS7xOxs+rV54t4LjHC6REINUt9evv/ba0ZMdhrPdj3xsV2mAu1E3oJ/A9zyeQ+VEc7r05TnszYT+iPHtNghOdCAAKLDM1cgHk3xGyLrOwmo4jgV+RxJD2d+1hPdOWLvmbGCFNalwianjPwamI3Lcw1BYPgWFmqJE2jSnUpt9GKvuEh3nao3nb+bEI9dQY2HPp5X7TuP+u
 xdZKsyus
 /YtJyD/2KlJ231zr26romO1/HCWjtwXDfWNNiZhth3kdmoXLWK15FS4sQd6LHtpD1QkjQv7Kj5ifw3KAbBk4pXf2ts1mil3dgRNyCgrmF5JRYfVZuNtl6lBE916aohrxABhNdWFn1pj1cJdvPjGRV1GLS4RoxxHL3BMYSajUcjw5+mWP05zD9X1repMNl0BwHKMgXU6Cd3iK+c2w7NN2Y/5hDae4bU4JTEMkPYXDNiP4hi8faJ0Gd3SLurqvz5negq/fIIWI0x5jIpsya8Sm2DK5YgMHW4xWG7dhEmSUwwBD0cC8qjs6miOHk1VatVfeh4HSRcKHjhLvqY3Lr9SyXmbAinfR3PS1DwojU66pQsl5renfoLMgCCXmwGebBg7MKHyrET2+Nu7xdWG11FDGbWVxvAYiT7d0J0ctc14DiNFox9yMgLKu2vWauni4mOYa/6bhtupTMNkFKM90SOnkzvdXaizm/B0sjUrELX8ix02fJvOVJGbiGztvEOhVUCVv9o6kQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Two separate guards in the reclaim path suppress all anon-LRU scanning
when swap space is exhausted or nearly so:

  can_reclaim_anon_pages()   –  returns false when get_nr_swap_pages()==0
                                 (or the memcg swap limit is reached);
                                 used by the non-MGLRU get_scan_count() and
                                 several MGLRU helper estimations.

  get_swappiness() [MGLRU]   –  returns 0 when the above condition holds AND
                                 the per-memcg free-swap count drops below
                                 MIN_LRU_BATCH, causing for_each_evictable_type()
                                 to skip LRU_GEN_ANON entirely.

Both guards exist for a good reason: if there is no swap space, trying to
write out an anon folio is pointless because folio_alloc_swap() will fail
before a slot can be assigned.  The scan overhead is wasted and may delay
reclaiming more useful file-backed pages.

However, both guards conflate two conceptually different populations of
anon pages:

  1. Anon pages that have never been backed by swap.
     These require a free slot before they can be reclaimed.
     The guards are correct for this group.

  2. Anon folios that are already in the swap cache (PG_swapcache set).
     These carry a pre-allocated swap slot.  Writing them back and
     dropping their RAM backing does NOT consume a new slot: the slot
     already exists and its map-count is held at >= 1 (via
     folio_dup_swap()) until the content has been safely stored.
     Reclaiming such a folio frees nr_pages of RAM while leaving the
     slot count unchanged.

Because the two guards do not distinguish between these groups, they
suppress anon scanning for the entire LRU once swap becomes scarce,
even when swapcache folios are present that could be reclaimed for free.
The practical consequence is that those folios remain in RAM,
blocking forward progress under memory pressure.

Fix this by continuing the scan while there are pages in the swap cache

RFC:
This might actually be intentional: accepting a presumably small number
of freeable pages in the swap cache to avoid costly LRU scans?

There might also be more efficient fixes, like introducing a separate
LRU list for swapcache pages?

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Steven Barrett <steven@liquorix.net>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Fixes: ac35a4902374 ("mm: multi-gen LRU: minimal implementation")
Fixes: a2a36488a61c ("mm/vmscan: Consider anonymous pages without swap")
Assisted-by: GitHub Copilot:claude-sonnet-4.6
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
---
 mm/vmscan.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0fc9373e8251..f50a5fc99fc9 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -377,6 +377,15 @@ static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
 			return true;
 	}
 
+	/*
+	 * Even with no free swap slots, anon folios already in the swap cache
+	 * carry a pre-allocated slot and can be written back and freed from RAM
+	 * without consuming a new one.  Do not suppress anon scanning when such
+	 * folios are present on this node.
+	 */
+	if (node_page_state(NODE_DATA(nid), NR_SWAPCACHE) > 0)
+		return true;
+
 	/*
 	 * The page can not be swapped.
 	 *
@@ -2736,8 +2745,16 @@ static int get_swappiness(struct lruvec *lruvec, struct scan_control *sc)
 		return 0;
 
 	if (!can_demote(pgdat->node_id, sc, memcg) &&
-	    mem_cgroup_get_nr_swap_pages(memcg) < MIN_LRU_BATCH)
-		return 0;
+	    mem_cgroup_get_nr_swap_pages(memcg) < MIN_LRU_BATCH) {
+		/*
+		 * Even with few free swap slots, folios already in the swap
+		 * cache carry a pre-allocated slot and can be written back and
+		 * freed from RAM without consuming a new one.  Keep anon
+		 * scanning enabled while such folios remain in this lruvec.
+		 */
+		if (!lruvec_page_state(lruvec, NR_SWAPCACHE))
+			return 0;
+	}
 
 	return sc_swappiness(sc, memcg);
 }
-- 
2.53.0


