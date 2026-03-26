Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6226F106F2FC
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:36:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 939476B0092; Thu, 26 Mar 2026 04:36:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 910F76B0093; Thu, 26 Mar 2026 04:36:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 827016B0095; Thu, 26 Mar 2026 04:36:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6F9676B0092
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:36:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 018DD5C74A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:36:38 +0000 (UTC)
X-FDA: 84587558118.23.042A47B
Received: from outbound.ci.icloud.com (ci-2006i-snip4-11.eps.apple.com [57.103.90.221])
	by imf18.hostedemail.com (Postfix) with ESMTP id E88721C0015
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:36:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=hCdj+rgw;
	spf=pass (imf18.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.90.221 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774514197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TnFacVqdLEOdPbeqUWCs+TzIAEb2KkAj5Z3+qb/+C44=;
	b=admN6KbADANTXVjJA2qNYTREzKYa+O1Zj+JDqEsmo0mH2Hk3NCL5Q7t0evIFPiniHrWWzy
	JrvSB38/2JnIc8Yx+/UYCSw2ZoayBjdsEwRalLB7YR8mAjJKT6KxBTzMJj49OLoUUmpyFI
	2YH3TteOYCjQr28bLeo2H6NS8Xs5bUY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=hCdj+rgw;
	spf=pass (imf18.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.90.221 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774514197; a=rsa-sha256;
	cv=none;
	b=KMqRvIfGR+eiSuwH3mYGduafo3T4xf2NliyO5pzapYZbuDiK1MnKYTixTtNosqrZOOPEtW
	chsNKAO9KU6Nvgz5nyptxhEpCITvRMXKYXTk414VzKC9L7WAc2+05Zz7QuxkK5kzQ9KHNX
	eGL1P2FlY5q/NlXNBC6r8uKjE4J6pOE=
Received: from outbound.ci.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-11 (Postfix) with ESMTPS id 6BD98180021B;
	Thu, 26 Mar 2026 08:36:33 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1774514196; x=1777106196; bh=TnFacVqdLEOdPbeqUWCs+TzIAEb2KkAj5Z3+qb/+C44=; h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:x-icloud-hme; b=hCdj+rgwQRwFG/O9ElHxJWsAYWEyu22kZzSEVo0HdQ2nhXSsyBOr6SJRpsHcECLcHAKlY/t8XYhc+DRD/0ltZ+vRZN3MGrRaDVW+26V0zloQcw7uHbjsWfjil6cAmI/kfHBD3HUjKMQYWVdwMsDgg/kqFRINsqcNs1ba+Fee89eF7yZIlG/m5qxZQlE5vBv3GYOjkSSD+VtvezO4FyKsrh/jylv8DaZtqCyHkAu+rhv6GWSW40GRo+FCPK627j30RKgMjpn22K/znpX65XXHx/062ngr/HtdbQEHVx/4QwA8x+UVTHDgJrCi4S+R2qQoZPnPXugRFzvzi51OMG6vWw==
Received: from [21.6.122.162] (unknown [17.57.156.36])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-11 (Postfix) with ESMTPSA id 93D971800221;
	Thu, 26 Mar 2026 08:36:27 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Subject: [PATCH v2 0/5] mm: batch TLB flushing for dirty folios in vmscan
Date: Thu, 26 Mar 2026 16:36:16 +0800
Message-Id: <20260326-batch-tlb-flush-v2-0-403e523325c4@icloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAADwxGkC/3WNQQ6CMBBFr0Jm7ZgCWqkr72FY0HZqJ0FqWmg0h
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774514187; l=3652;
 i=zippermonkey@icloud.com; s=20260309; h=from:subject:message-id;
 bh=1S4mtwiSgiEXK9RkHO0cUF3Km1aYqH6AUACfPgCXzzs=;
 b=KII/Mz4IcW3cMukofh+i+NVuXjEc0BO0JHhh5A1sDytP0Cf3RYIPWe0CLAY53vYquY3Rvrm3f
 CyS6TrAdROnCEbMdP2P8gbzLEHo39VJ4cyTKYFkwNnITM8mITHaXPN/
X-Developer-Key: i=zippermonkey@icloud.com; a=ed25519;
 pk=tPCLpFnBfIyHsp0k7eaUTUREEa36bQNW/69X+NS8wBU=
X-Proofpoint-GUID: L7-WM3VWRO91kEFUKdWNbdySIh1JRmtt
X-Authority-Info-Out: v=2.4 cv=acpsXBot c=1 sm=1 tr=0 ts=69c4f013
 cx=c_apl:c_pps:t_out a=2G65uMN5HjSv0sBfM2Yj2w==:117
 a=2G65uMN5HjSv0sBfM2Yj2w==:17 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=v3ZZPjhaAAAA:8 a=GvQkQWPkAAAA:8 a=0nsp5VSLLG1NfpzbPScA:9
 a=QEXdDO2ut3YA:10 a=J82S1U87d15UFHHUFZS8:22 a=yLjSXO_LiVxs9JEHLWbQ:22
X-Proofpoint-ORIG-GUID: L7-WM3VWRO91kEFUKdWNbdySIh1JRmtt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI2MDA2MiBTYWx0ZWRfX/FdBr0XUBu41
 S2ZG2gL9rXdB+umYDZHE+B0BX51f6m9xwVz8LAby84CmttAeWrm9wTTm4uJdQU8Vb3YwjOZ1sPY
 PlK48RjYy30dUY8gZMm9koj2Oihg9qpwMBmUu6Y3gCNQnOqxgFSXKAokxzcOMCinj6PrTNpf70x
 ktXMhhxoPtEzUOd6avg3UNEUhlhYfpn9IiZemU55dKorv05zKauSM+tx/8f0dKLdCHeHYR6UqsN
 v3zXhojUk39UiuyJTwpnGdquzElLpMuYPQph5HCqGPJMoboVauYPQFVgXILOAafiUgtV0k5f0uf
 SqdhzW5xJWyjYHrmoIaiLpzjHqFxXziSMCS2J7pV5ETSajYFF5kZUuhDGBrGLc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_02,2026-03-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 clxscore=1015 mlxscore=0
 malwarescore=0 suspectscore=0 adultscore=0 lowpriorityscore=0 classifier=spam
 authscore=0 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2603260062
X-Rspamd-Queue-Id: E88721C0015
X-Stat-Signature: xpy9bq8qgoj3x95upuq6j8ojap9ddykm
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774514196-854229
X-HE-Meta: U2FsdGVkX1/S/recr/WcHBF6dc1NdDx6z4a918/AEpYN9yvCe4UC5wqdv70nQwLo2KAGGzYX/ikj0CsdGOWtv8ARW1tUMYIYOsG7jtr39I6THKrhhGfg26yc9qHnXticv0T75rjAxE8f1EqbvujmutKlfanvijsHYEGUKqHvM5vCnrBJT1rUtIgGAXUirFNFk2uYlrr2EkR5qkXCA+eFDTXowfj/A3n39+jxBGeC6py4pqz9gF8Y/PfETf+Wyg41oxBzBOkyMbbbwUNds3v/kXgv3q6+tp9yshYgQxLNN/FBEl9ggBSBtJBATEXAXSX9da4vbOo1+5Ujrp5/xIYSEnR4ZLa1HDfDLlZ2js+yb2c8/Psnmsfh1G9M6tTaMjfjhj4C/C+H9iceYraugzL9rSgdxO6n5OMP2NNrVU326IVCY+ZBcglinjRCpJNtphwkzX3OR4MekZ9Do1CuBE0jdJrypsUxXok4ONMuFsR1xnbiM4JMxnbdPbjmn4GaSWW237C5CXVSSpkI/xjQvMMo7XXZgmsgYErpJWQ8eCmwpTKV3doIkW5ar6c7JeToBM2uiXa9b2kzdiWSv5dN0bMjQrttLwFmw34X05ZiRMVP6m+zoetMh7PYCXS7QJqgPxqP4i0K5hOILvKm0+FPLZrWgkWMj2Y8F+aN+v3HMTdkh9L73N1ExLQkqrMdD63t4saWimdckmawqy8Te5TJnUjRPXZYwFvQRxI6gQSYC7nhs1l0U4MSuRMf8VguHhS3lB7MbUxDYdXZf2epaDjewpW0K18v9cxtuQotUJfnewAsUrSiVMktpqrqid0vviq2veE4/d46xunPnnOrH0gEsECrMd31DFwbeDsU8lNCR42qkERvhhREN9/dTgYiUwhgUH2PCfOW05UHOrvVaTrCPnjGFn88H/Wp+2kIJT19CfACmr6J5aLggG52LzpXTRcZAGwLXkOTSFOsrg8nQ3pftSQ
 4tmBRdZg
 2HzTxH/HIwaNPnoZ875WUMVEpsp9jSb84BlfhSQhrX+HNAK6tTRwhVN57hIafGwM1WFPhpN7VmM0mRafujloH7bfuEzxxHPKexiQ/M8huwp4OvDnaxlAjCYGnsYfC376a1mWmKsNts9ERvqZaKXIklRowPOmnzUiAi3zIh45zy9D/7eHlrFON8BXDsVIIF5GJR8ENoFtgrM75V8AY99eQIJrwLwW5LOuPXy6PsddeOIsUALMutmPLM1zqWZVSjfu1loreK3sc5swtJKhWSt2jm5tKRwMt9Ao52m+zc/9jsUTF8pd8H/RpVsHADOQYu2115M542h4UW5YZS4sDvJoBA3ZYY2353Kl75r8WvuJybgQRSCA005xXqGLZP6WERxjz5CfUmtGojBADXQTKbwEUD75Tl8DTdOKHBsDgFUyVkep0QcgAmQ48kxZZB42oPT09Sqr9
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


