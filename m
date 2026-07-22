Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F0EEC4453C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 17:04:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 517516B00AE; Wed, 22 Jul 2026 13:04:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EDEF6B00AF; Wed, 22 Jul 2026 13:04:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42B096B00B1; Wed, 22 Jul 2026 13:04:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 166286B00AE
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:04:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8BC301A028B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 17:04:51 +0000 (UTC)
X-FDA: 85017037182.06.FB9605A
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
	by imf22.hostedemail.com (Postfix) with ESMTP id AA93DC0009
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 17:04:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.200 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784739889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CgkIZjzCIjC0p/yRO2+kWMGJF1CcLkrQ0ae6CEhG4fQ=;
	b=ebp7xiNoWPgkOhMcjzE/0XDoqKX8WH5gWjIgfbIqkvsKJ6EdpXiOZZo7rfsoMvrTKVBy8n
	g3rXIdj1mqYKetO8VUXRgMtz7TLY/yLPVTLE5XGo6TsMScRTxhnkdlgoIMTqLf2bFHau5A
	fOXWGU0HxUH62nYp0eiVblflGfDLdio=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.200 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784739889;
	b=YXJmlACBMPc0tM48f+D8lvzTBfY6wVfl44H9jIa2Kz49z0aZML96ByCLOSPqctbyW4ilLv
	ilt3W214XTffqmAzPeO5AU1pU5yhaK+tMSsJp6+cvqZmfvrHuRGH7+ojDUE2o0eWcvyXOF
	qGZpUEwVdNUZeVzF/kydH+6Q3KJxo78=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 881453ECFA;
	Wed, 22 Jul 2026 17:04:45 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com
Cc: chengming.zhou@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	ryncsn@gmail.com,
	chrisl@kernel.org,
	baohua@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v2 2/3] mm: swap: bypass synchronous readahead unless the target needs I/O
Date: Wed, 22 Jul 2026 19:04:31 +0200
Message-ID: <20260722170441.787023-1-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260722163536.773166-1-alex@ghiti.fr>
References: <20260722163536.773166-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTGD3aVNYYNWQE3hBe3q7r+fu1zag39OCRwHiEPoCAXpVNwUnVb1S6FYTlJ4A9YUgDME5vcwgtLFfeKPtwt4ozlxQKPhTm+W4N00yTbIo2R9zseeXzAhhnfc7MncXE45fvkvFobwnKyQq13VWQablpgAAdZCEGXiGa7vDxasMBsMFQ7zC45zsVZT9e49Zzulb6BLVd440EtoWsEQKVZMtCO5ne4zkeRUFK9q5LYwqIYaWizcO1Xa16+nQ8E1V3bBL6LodtcmBYxGI8HN1PVhxl2Qt3m0uIRN53ey3tUSlGaMb+WMVwRc39yhBBNL+rV+ltrrK+3pnuf9ifqvJ/2LUl/HRM+E2CTVIz7de2aguomZEjjXjVsWxaIN+ttdKJDMYG8jKhFhBXI0ENFOCQ6LSoRhfMomvtiN3Ow5h7SWonbCH9q4ajsdNqbj0bJljTBZ0UxJXqFxi5d3TiktaWpBdHRRkwpakLdHpglUnvMg+kvVN4uuUq6f5hHmR8FT6pHvem/MJeUCvQJCK9FHVtnn31LB6Z4uujrOYlKPI4ox7cVlk61gHvH6rkO76yEB6VVoAcrhOVo/M6kcKL2AfkVD3SXi1x0Mh/Lc9IXz8DZUGwGpI+KF5gGkfJA4zEWHTtDsl6Qkzv3SHookYEYJKNUgmEVCMsoc4F79ithV7V/U+f9hbw
X-GND-State: clean
X-GND-Score: 0
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AA93DC0009
X-Stat-Signature: 38s6h8kf8atjc7qmxgzhb8jdnxbya6c8
X-HE-Tag: 1784739889-831889
X-HE-Meta: U2FsdGVkX1+TcmB+XN3CnhYG+LYdalJqqSOm2b8CxyYlHA7R0aDC0Mzge3UMFQhUC+K54pl+z3h7QSvePJUxp/7NLAcIcIjO9mLaNAJSIplXCTwNfbn8qz8u2QFo4wsMZKOY4ZtAQLQC4+iTZFfCUEJfg5RIdxHlchwhYhOrU0VrV2q/Msen3hbXApcOpUdvHRGzEACvwKbJ8TYjLpMwszEeDkCQF7EuNtk1o3MBIT4nL/yff8QAOaHyZ6O3W7PzqV8cRt+UCrvZMqy3Cpnu6rvmgX/CdQR/2jSlYnTfXRbQY+Xxzz6vUkSye3znK66JmoORcRzQIwYi0JY8rp+SX+taBNDfY5MyBxwRNseH0S411dq9Sn2R7U6Rzjl1Zxrvie5tOYNH4lqH6e47xgkPlcLH87Z9oklCeKzqvVnN8oiWRWQKuvcDG/AH5sbEstAkeyYlkAXD62gtffUzew5/o8fsAetSPSjrtp5jzoe16RCqKxnCWPi7GOj3CNtoJfuPx5YvKfB7XX1l6OlWhfLQ9PLbTu+AlsDlsZPmeHYNA6zT/L0FvRat8ZtvGhHv+j1oyHoTLaOH6LW5IHSdvJkSJ36dKQbsvQVp1jhmdhkDoD8UghSWQejE2xPXWi99M4deehcXgG1VqUUhTBPl2AIYOwbxmpY0bteZMPKxj1pUWIVPXbE255bDYkPzy1T4zraOnivDYyAsI0qu0DpHgTRKFGHr//9uNGajzE+VKyc/1SwDZR3pXh7XAhDxirXioj4c56U50QAVd0sYv/wR3dFaDeiHeg20ghUdtbY61Qx9vFKsKcN6wbjONTe+tf41+fSB3AK1A+1vbHDYUUh/LgV5Ltdh5aZ37y7dKeUsXJ70j+mINhEP1QgbTrIAE57c9iOxtjvQnz9dQPU4A/GraTtHw4RYJf5xGI5F3nDiPTJGlSmsxHZr3RK6AW45qZmyCagGnVGI0HvrefzuG39LcPJ
 yw6DVJ0s
 6GvNM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The overlap pass reads the deferred synchronous neighbours while the
first pass' device I/O is in flight, hiding the synchronous work behind
it. That only holds when the faulting target is itself served
asynchronously from a device.

When the target is synchronous too, the fault has no in-flight I/O to
hide behind, so reading the neighbours in the second pass is pure added
latency on the fault's own critical path, so skip it in that case to
preserve initial fault latency, this is a trade-off that slightly
impacts the throughput gain from patch 1.

Results [vm-scalability mix-rw-seq, 4G memcg / 8G region, ~256M zswap
cap (~73% disk), unthrottled NVMe, zswap=zstd, shrinker off, n=3]:

  metric                  mm-new    +patch    delta
  swap-in tput (KB/s)    118946    130364     +9.6%
  major faults           261471    396648      +52%
  swap_ra (pages)          1.56M     1.42M      -9%

The other gain is from bypassing readahead entirely for zswap (like it
is already done for SWP_SYNCHRONOUS_IO devices).

Results [kbuild make -j16, 768M memcg, sustained pure-zswap thrash,
Sapphire Rapids, zswap=zstd, shrinker off, n=3]:

  metric                  mm-new    +patch    delta
  build time (s)             410       354    -13.7%
  swap readahead (pages)    6.69M     0.28M      -96%
  zswap-in (GB)             83.3      56.5       -32%
  zswap-out (GB)           152.4     123.2       -19%

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/swap_state.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 3ff2896dd6d2..23137714d7cb 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -844,7 +844,7 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 	blk_finish_plug(&plug);
 	swap_read_unplug(splug);
 
-	if (!has_sync)
+	if (!has_sync || swap_entry_synchronous(entry))
 		goto drain;
 
 	/* Overlap the in flight IOs with the synchronous neighbours reads */
@@ -990,7 +990,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 	blk_finish_plug(&plug);
 	swap_read_unplug(splug);
 
-	if (!nr_sync)
+	if (!nr_sync || swap_entry_synchronous(targ_entry))
 		goto drain;
 
 	/* Overlap the in flight IOs with the synchronous neighbours reads */
-- 
2.53.0-Meta


