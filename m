Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5A5AEF370C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 08:18:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F38CE6B0092; Mon,  9 Mar 2026 04:18:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDF8C6B008C; Mon,  9 Mar 2026 04:18:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1D576B008A; Mon,  9 Mar 2026 04:18:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BF3B46B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 04:18:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 694E3C20BC
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:18:00 +0000 (UTC)
X-FDA: 84525821520.26.42D515D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 805734000C
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:17:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AycKyglm;
	spf=pass (imf04.hostedemail.com: domain of devnull+zippermonkey.icloud.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+zippermonkey.icloud.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773044278;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mltfqZmtiRtmBriCrDHkl5ak1WaVUs54Kxodq9Cyks0=;
	b=0awMAu1XvJNPckqAfzZmMCF0VwtyAYDchTfaPX4pF6L3aOWDlrp1ejI1sFeNe5M0nMIKxV
	wcqQBFxlNVmbLi7QBkUIC258SO2+2vjcg/GiQFOcDIo1DKHJTvMaDK5mhDEdWUlyECGdNi
	VzpTHX4+ZiHM1CD9Nzk4ABrZgMKZAvo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773044278; a=rsa-sha256;
	cv=none;
	b=mqGNqr3mkCnXbXQbDFjL1g9hOSzEtX56e2gs85CkGswkW8o7ZOxsR0j8PoJt+VvxvFp8y1
	6JQmAj9Q84r5kEqWNiMdmV8UjDPXu7/hUoHv50D4l0+pIRQ4zisrcjqoiV/EzdNFywcDP7
	0b985jMaKGFNwVFiHW4fx0dZfWqeIkM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AycKyglm;
	spf=pass (imf04.hostedemail.com: domain of devnull+zippermonkey.icloud.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+zippermonkey.icloud.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EFDFA600AE;
	Mon,  9 Mar 2026 08:17:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9426EC2BC87;
	Mon,  9 Mar 2026 08:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773044277;
	bh=Hxlyr94vhT6tceNWkfUX7FnAnLC5MO+FeAUWHj402F0=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=AycKyglm0somIajLRn1PB2ivxqYlWEQNxYn5fFpwOAdqhapuUZjCcc7d/KBg22Moq
	 o2C927nqYNReytwY+IvYZ2Xk5KIh1vcjFMVBYvurof/EVcn2099iWn5Kd3VY6VTnkG
	 kQyQzHxXcSKqKn0urVRLzs3NyIcSTgTgTpFoNIG8cK08ldboviMr90OV0WTHJkgO/f
	 spmU1CR3dD6U0xze3K5xkroZhaF2uJ82r5U0Fgnl0e1vieOa1XhAERPmxkYy+JSmkm
	 4v2hYKyws0Q/CHskqm1EkFIrK894lrzczp7RFurpJ0+L78szuBTEyQ1Ppybm0SdS8v
	 F0gdhxzC7T+sg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A109EF370C;
	Mon,  9 Mar 2026 08:17:57 +0000 (UTC)
From: Zhang Peng via B4 Relay <devnull+zippermonkey.icloud.com@kernel.org>
Subject: [PATCH 0/2] mm: batch TLB flushing for dirty folios in vmscan
Date: Mon, 09 Mar 2026 16:17:40 +0800
Message-Id: <20260309-batch-tlb-flush-v1-0-eb8fed7d1a9e@icloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIACSCrmkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDYwNL3aTEkuQM3ZKcJN20nNLiDF0LS+M0g1RTsyQTSzMloK6CotS0zAq
 widGxtbUADrHzlGEAAAA=
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773044270; l=3059;
 i=zippermonkey@icloud.com; s=20260309; h=from:subject:message-id;
 bh=Hxlyr94vhT6tceNWkfUX7FnAnLC5MO+FeAUWHj402F0=;
 b=sxFReAs8wK3VKflfARWnWgk7f6wn4fNFW99rIJrAv5x9OfnVaMTXYyL4a3bY+wRiQydi+yVgG
 mEgfk97EZfFAx4YusLrPnkMyYxiSThIU+eO6DqO9mz6vCP33ltXCVv6
X-Developer-Key: i=zippermonkey@icloud.com; a=ed25519;
 pk=tPCLpFnBfIyHsp0k7eaUTUREEa36bQNW/69X+NS8wBU=
X-Endpoint-Received: by B4 Relay for zippermonkey@icloud.com/20260309 with
 auth_id=671
X-Original-From: Zhang Peng <zippermonkey@icloud.com>
Reply-To: zippermonkey@icloud.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 805734000C
X-Stat-Signature: us1nibs8atby5zexnuyon5tu765rh6g8
X-HE-Tag: 1773044278-539462
X-HE-Meta: U2FsdGVkX19QE+94aIJzhyPybFzjYAX7AVYKkfg3ZABo0NoGLdwC3MN4Dm5O+oLBcqdvnFfBQOpfFuZBF6pJm+bhk60otOW1ckJ3ZY1UN4Rbb8LCJTgemMyRBlUbbwdYc+pynBinQnhlpxutdjoGD1y1tk0f3F9NX6gyY1C+3mv2nN3zCZ9UzxErPoWJFUlf80ntDF0TlIP2SXj+eCgtnA/zXXSAyGOmaKOFBpsEPmvqwLob1zOcsmkPXpOwk8Zy0EkPRr3R1MCw8axSx1Jd39U6NSr3xu4vV5jsY/8hy4rjhw/kdUO2XubjGoSlhmjFmP7kZWdRJMwXvoRCnLOEdf/4bTPh4y3kbsdrJftSDfvZTw8suo7m88JJOB4v5KvGkD3TRHR124h4vMuMErQJx2vHrVvSVXKifB6jRwmHr4s04swDlKX/qOFnQ4dckivLmLlQnCnLcRIDjAxLV2HSw3RFoBkUjgjkiubEhArSyyym+053vdruHxNu6+dEw5D+b6XdoBmdrnzb43ti/LaS1vfwNENLo6vOkqrPzWCVD27Dl/q71OOPbIpztXgW44r1BbfqOODjj94WkddmzwBCXzuRJDCv/zotvgUxmF/38inDFOktMTj0gMniSKRm8d31zQz5ax/+25JVS8H0JmPX/nxX1ZU6yoI4NvfoLf+hLu5KDi067ROw7G13H42bLCvZlGmMVKYcL8WWIdBh45nypuFunCfiAdNFdoqr1bVSaseizHsPOZWZ9rXWC6uo6UfwRLPO+mvKo6xaifA8oJRxDwwpJsHXkZAOCSP2YTYFZ2lH8zuwpOfEQT4/GVaeYV77qogmP6XqM/rKxFff9KQG8PG8nCf6Ovg6TXjWeraWUE2tub+jB00TZegmxH9BQ5BAWBSTsiDomNdP287zasVRkyFB6teAWzBISE4/3NwXoVkx84UTYZKKCXw2zcie8R5nxqj9vB7A76Y69MZ9LsD
 fuqUd8Aw
 UeQmp/SB9b2VIxqEktjASJuWhsCw3OXYoLrUqtff3+5LLTDrPstO+VI3W6m07SNaRS1nk0RhgkZjbmreg2TbRSS1cqI0eF8bLs8+2Vbgg9/1/4RjGpa2nlcrCNVUR/jxid8wc7kSkRoJ8umPZ02oYgxjiyIwAMXmliHy5anJv2f4UCMtfPFqlgy/2/xwfQi1C8aOf0/htVU7wzcRU1wW5T91w6VO403P8ZDXTyzwkycEySRu7RBv0jXMcmwguNoEy6tNmVa6ikqUoWTRAsacj03pOVxMcxMpnJf62EzMyPPmUUAKH/ucNdsEq27LQxaC8yLzKXZrcLnkG2VRKmVVAPYl6Zqwoh4qLsYhRTRBlue5mNMKktc66FasIl1Beh0lMJDKjwD0pGd8ICbmLOa6wQegACm0T3iothyyZ+nRL76u9EsIoiINdleCIVU0IoWOPVCZF53fKNMYGmg4=
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
Patch 1: Refactor shrink_folio_list() to improve code readability and
         maintainability by extracting common logic into helper functions:
         - folio_active_bounce(): Handle folio activation logic
         - folio_free(): Handle folio freeing logic
         - pageout_one(): Handle single folio pageout logic

Patch 2: Implement batch TLB flushing logic. Dirty folios are accumulated
         in batches and a single TLB flush is performed for each batch
         before calling pageout.

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
bruzzhang (2):
      mm/vmscan: refactor shrink_folio_list for readability and maintainability
      mm, vmscan: flush TLB for every 31 folios evictions

 include/linux/vmstat.h |   1 +
 mm/vmscan.c            | 387 +++++++++++++++++++++++++++++++------------------
 2 files changed, 245 insertions(+), 143 deletions(-)
---
base-commit: 49cb736d092aaa856283e33b78ec3afb3964d82f
change-id: 20260309-batch-tlb-flush-893f0e56b496

Best regards,
-- 
Zhang Peng <zippermonkey@icloud.com>



