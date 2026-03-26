Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54B1C106F302
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:35:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD02A6B0088; Thu, 26 Mar 2026 04:35:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B80DF6B0089; Thu, 26 Mar 2026 04:35:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6FD66B008C; Thu, 26 Mar 2026 04:35:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 92E976B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:35:56 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 29BAB8CE15
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:35:56 +0000 (UTC)
X-FDA: 84587556312.04.C8FEF87
Received: from outbound.ci.icloud.com (ci-2001j-snip4-1.eps.apple.com [57.103.91.94])
	by imf11.hostedemail.com (Postfix) with ESMTP id 321394000E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:35:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=vfLk1hpJ;
	spf=pass (imf11.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.91.94 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774514154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TnFacVqdLEOdPbeqUWCs+TzIAEb2KkAj5Z3+qb/+C44=;
	b=b1bA9Rz2gimskoxQ5rV4c1IGWNI78Ay4r+/ZkkK3n7hGMLLiCeZhxWc5b2R1Bdtx5xQ/0L
	UBPFzw85oHU0ngvHo4tok/MkZMNkScoVWHrMh9cugy2/HC2fTYVW00xVVqDYe+UVkgupBq
	gFCT5/muo8GI4aivWOV5Do0ZRLO1k1M=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=vfLk1hpJ;
	spf=pass (imf11.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.91.94 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774514154; a=rsa-sha256;
	cv=none;
	b=vdrQP6sq8R0EZiLkZs8tifHckBMiIr+lLc8SGMrTy5DQWaSZmKTvFIqDbMY5NLxqkcSP7M
	kG2Qjo8Mt5fQZc3e+rI6Fg9Yy+XDSq62Cyt0HKPsLqReOTNPHbsiuRIEUVFmy6D3JbzwuJ
	Flk0bxkGEzwkzzojH2BqdKgT+trwRiA=
Received: from outbound.ci.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-central-1k-60-percent-5 (Postfix) with ESMTPS id 5A8311800099;
	Thu, 26 Mar 2026 08:35:51 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1774514153; x=1777106153; bh=TnFacVqdLEOdPbeqUWCs+TzIAEb2KkAj5Z3+qb/+C44=; h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:x-icloud-hme; b=vfLk1hpJx5drEyisk2Axujy+9Qp9RrOGShXp4nusuC0UeiLSxyKUYTcFpvet6W4gNsG91qG9isbEc53Ef1HnbkESdl20wUYBMJs2FiOn77Ujoz7VtgT+tVY3x99aTC+hH6aZyyRN1xbemLvjKQGXo1QU36hFkN2LLr+pzAyAu6y+gavk1t6VBLnEgCOGWz6b2C71zm7hcPXKEGbyFXyRXx1fHutXNhTAQCkxF+UJHOG4mMBuslwbmUG/8BGsBq6wtUYOIsskJmaFQ2Yu+H1Hc+XTMsHxYZTkYR17OvRv40bWO7sO3TvfyuE/i3eT9gGJ690V0eBW1+VGeTyFF68Kxw==
Received: from [21.6.122.162] (unknown [17.57.156.36])
	by p00-icloudmta-asmtp-us-central-1k-60-percent-5 (Postfix) with ESMTPSA id 4FC981800167;
	Thu, 26 Mar 2026 08:35:46 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Subject: [PATCH v2 0/5] mm: batch TLB flushing for dirty folios in vmscan
Date: Thu, 26 Mar 2026 16:35:33 +0800
Message-Id: <20260326-batch-tlb-flush-v2-0-989ba60f970d@icloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANXvxGkC/3WNQQ6CMBBFr0Jm7ZgCWqkr72FY0HZqJ0FqWmg0h
 Ltb2bt8L/nvr5AoMiW4VitEypw4TAWaQwXGD9ODkG1haEQjRSsU6mE2HudRoxuX5LFTrRN0lvq
 kJJTVK5Lj916894U9pznEz36Q65/938o1CiTdObIXWw+KbmzGsNijCU/ot237AjSbtcCvAAAA
X-Change-ID: 20260309-batch-tlb-flush-893f0e56b496
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, Zhang Peng <bruzzhang@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774514145; l=3652;
 i=zippermonkey@icloud.com; s=20260309; h=from:subject:message-id;
 bh=1S4mtwiSgiEXK9RkHO0cUF3Km1aYqH6AUACfPgCXzzs=;
 b=7lJx20nI1Zoi+8Zmcww8Z4JTuVwbzT44J4i57tORiO/vubcR3diXcmV6vIfFhftrgxB2unYtY
 YzzLQ/G+I3IC7X4rqCPgA20eeWTjOXva/E0nheAByNk2gsChrKmPxbz
X-Developer-Key: i=zippermonkey@icloud.com; a=ed25519;
 pk=tPCLpFnBfIyHsp0k7eaUTUREEa36bQNW/69X+NS8wBU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI2MDA2MiBTYWx0ZWRfXwXwMgcvl3dZR
 BdR8pwlZJsiPXtLtoMsgDBlj+/gOHVMCfFPttgEn4xuHOfr9sWED42rVsQNPLPVSGZZ+v81HiIp
 Jz5sxT5nrL97mqeVPFpl1Zz4a1sUN6lf03TBNZNjTtaR4i2qWX0fnKEB5yVqKUJsftpj6W1j+eu
 LKUm3iDwmnqTt9LF+QKG+XxvaXg0E9+ou+blc++xXQgzBOlzWI8Lsb/K72V1YaeW94243MenOhx
 dXj4AvTSyWMnJtNVP6REMDeG546/vkywrEUi/rKnrpq7vNxn2/Ht4J1b9FLDSu3/SsDG8iIpanN
 ZA8pczipRaaWumwE9KVjMsb3avHGedBbgeqQuo8bu/P4SEiPKQ4QWw1+7OYq0U=
X-Authority-Info-Out: v=2.4 cv=deWNHHXe c=1 sm=1 tr=0 ts=69c4efe8
 cx=c_apl:c_pps:t_out a=2G65uMN5HjSv0sBfM2Yj2w==:117
 a=2G65uMN5HjSv0sBfM2Yj2w==:17 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=v3ZZPjhaAAAA:8 a=GvQkQWPkAAAA:8 a=0nsp5VSLLG1NfpzbPScA:9
 a=QEXdDO2ut3YA:10 a=J82S1U87d15UFHHUFZS8:22 a=yLjSXO_LiVxs9JEHLWbQ:22
X-Proofpoint-GUID: Rs6VvbBLaY2M1IFXpa2SMfafmOye5Ufk
X-Proofpoint-ORIG-GUID: Rs6VvbBLaY2M1IFXpa2SMfafmOye5Ufk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_02,2026-03-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 phishscore=0 spamscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 mlxscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999 classifier=spam
 authscore=0 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2603260062
X-Rspamd-Queue-Id: 321394000E
X-Stat-Signature: xpy9bq8qgoj3x95upuq6j8ojap9ddykm
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774514153-141047
X-HE-Meta: U2FsdGVkX1/51ehxWu4rZcjElbJW13uwxK3x7uD+AegjIj7t/92sorMykE16/xa5DguNCkLM3+HpaabijReOiNxWdPTvAZekuluzVr2H7YRJDWNwjVFoRuL1OCUKhyQj5kVCSo+Rr57SJPy7FYrCxuviBjUSjxMSNQGHTZus2PFbgD6Auu199iNjFJ2Pa5DRztN2wCJ6uQUzzbkIGfUYWSVtzcorf9JsfUTn2eMxbQLaZrowW8WXyUdoxCUhNc52E8QLS7wp5+LmWFX3/L0gCyZLNMk7xZBV2fyKaQrGAGD+VyG0Tp5fRgzf4gNkOBPqgQBuWlz9gLVyHtF1OIhFl84Z6UC3J/Q42OcRRqQ3nw+ZyibLHiqsmImDz7zGddk82afdmIK9epG022E6EhCUwsrJLkx2rcsiSR8LoadU/rS58qUNm7VQ0EoDXZEtvlRLEEYwZNJN926B/y8EFocufSgbm8GR1GLG43hErtVJh7cXhiyXUBIs63Qn4wvMRzRvXa9kHAk7VEcBcoy9AcYNVNkApfvYkRZtWwiaG1mySmDxZ5TLGRKLrWwIqlo+Hoy4xYFsDxGUoXIqHRUkUFIuDj43PxAfdq4BjUklp8Nq+OAz3WhU3dqo22EkMoqb5YfTJA+gh/HC0nIBzV8Pa9HrVGF3Q4H45ygbSZgvFV/kJ3LKHo42CGkSmEU8AJ8LNtSp9SB4iTWq74z9w14KER6yuWDDuVFAYvGnU6f5CC9TghzCwjx4l3pWSq5dMbG2HHXvbMoarNLHSwvR4UEncTdYltPF5MVqMjZ+2z7X+Kxa+gfCoF/hYOYe8BVnmLB72AwW/dMl6IEPa/RuhzRvAGjvQI4eCGu6iRTkMOtSzQLT3yHtwvQm66tWwovw/qALSUgoNDqB0cnaQ61gVnKCpW1wfRmXRNi454gukji45c8p2rK6j8bwcY9ffWabGwEGPo1H9ahjaR5HYldRFa4SST0
 GvsHXmx6
 Jn65CIgnSmXMMnihlpC10fzI1bSFRm++6ZSXXJ4n7oG7nLi8BfsO121xPD2AflAlqTeahZfwB3nZ0Xi0c+N3jfpL/K9WQwgFwaThx4xrvm6A7WualyAuOWiaUMURav/yFBT82kijNMVm9RrvMoEjvOadR+NpqzwpH+/9st0ALvrEZND3+x0pXZcs8VsVmD1DQVnzd+7IOv15kXNU+J4dQwZOUDBwByX4p0D7sQ/a0arRUZxhflkR/YrAbNFU5r0yyBAY96IswWsFF4nAlqIqYJZnGZ4EYeVUIHDWCZuVDMstwIB6BRK2cSbAUH8ywJxEqOZV0BfJGR+JurMKvbTNAMTs71B8GFbfcHNttOnpgbNKvTN1TS9YNzdi3wHs3iPVoybSD/oH0GESOWu/p1ZwtRMgCSffpQAMOs/uPWDM8khvlv7Tq4XCNtSOxcVk2lG51AbEs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series introduces batch TLB flushing optimization for dirty folios
during memory reclaim, aiming to reduce IPI overhead on multi-core systems.

Background
----------
Currently, when performing pageout in memory reclaim, try_to_unmap_flush_dirty()
is called for each dirty folio individually. On multi-core systems, this causes
frequent IPIs which can significantly impact performance.

Approach
--------
This patch series accumulates dirty folios into batches and performs a single
TLB flush for the entire batch, rather than flushing for each individual folio.

Changes
-------
Patch 1: Add nr_reclaimed to reclaim_stat so shrink_folio_list() can be changed
         to void, giving a consistent interface where all per-pass statistics
         are reported through reclaim_stat.
Patch 2: Extract the folio activation block at activate_locked into
         folio_active_bounce().
Patch 3: Extract the pageout() dispatch state machine and the folio-freeing path
         into pageout_one() and folio_free() respectively.
Patch 4: Extract the TTU setup and try_to_unmap() block into folio_try_unmap().
Patch 5: Implement batch TLB flushing logic. Dirty folios are accumulated in
         batches and a single TLB flush is performed for each batch before
         calling pageout.

Testing
-------
The benchmark script uses stress-ng to compare TLB shootdown behavior before and
after this patch. It constrains a stress-ng workload via memcg to force reclaim
through shrink_folio_list(), reporting TLB shootdowns and IPIs.

Core benchmark command: stress-ng --vm 16 --vm-bytes 2G --vm-keep --timeout 60

==========================================================================
                 batch_dirty_tlb_flush Benchmark Results
==========================================================================
  Kernel: 7.0.0-rc1+   CPUs: 16
  MemTotal: 31834M   SwapTotal: 8191M
  memcg limit: 512M   alloc: 2G   workers: 16   duration: 60s
--------------------------------------------------------------------------
Metric                 Before        After             Delta (abs / %)
--------------------------------------------------------------------------
bogo ops/s             28238.63      35833.97          +7595.34 (+26.9%)
TLB shootdowns         55428953      17621697          -37807256 (-68.2%)
Function call IPIs     34073695      14498768          -19574927 (-57.4%)
pgscan_anon (pages)    52856224      60252894          7396670 (+14.0%)
pgsteal_anon (pages)   29004962      34054753          5049791 (+17.4%)
--------------------------------------------------------------------------

Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
---
Changes in v2:
- Fix incorrect comment about page_ref_freeze
- Add folio_maybe_dma_pinned() check in pageout_batch()
- Link to v1: https://lore.kernel.org/r/20260309-batch-tlb-flush-v1-0-eb8fed7d1a9e@icloud.com

---
Zhang Peng (5):
      mm/vmscan: track reclaimed pages in reclaim_stat
      mm/vmscan: extract folio activation into folio_active_bounce()
      mm/vmscan: extract folio_free() and pageout_one()
      mm/vmscan: extract folio unmap logic into folio_try_unmap()
      mm/vmscan: flush TLB for every 31 folios evictions

 include/linux/vmstat.h |   1 +
 mm/vmscan.c            | 456 +++++++++++++++++++++++++++++++------------------
 2 files changed, 287 insertions(+), 170 deletions(-)
---
base-commit: 7c5507fca017a80ece36f34e36c77e2bee267517
change-id: 20260309-batch-tlb-flush-893f0e56b496

Best regards,
-- 
Zhang Peng <zippermonkey@icloud.com>


