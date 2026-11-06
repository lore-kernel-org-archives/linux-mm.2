Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34C08606A329
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 10:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=r3RaGep5
Received: by kanga.kvack.org (Postfix)
	id 3F0756B05B3; Fri,  6 Nov 2026 05:05:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C8B16B05B6; Fri,  6 Nov 2026 05:05:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 305986B05B9; Fri,  6 Nov 2026 05:05:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B5086B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:05:56 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 92D6F1A0D2D
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:05:56 +0000 (UTC)
X-FDA: 85404263112.29.AFB7A31
Received: from mta0.migadu.com (out-106.mta0.migadu.com [91.218.175.106])
	by imf10.hostedemail.com (Postfix) with ESMTP id 412BEC0003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:05:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r3RaGep5;
	spf=pass (imf10.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.106 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793959553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3ZdWxtf70irIWN0cdRiIhxuODBDNKO9FqOy4Rvd9tt8=;
	b=OImUQXoZHKtgWWydluE2oYXDCwHJXv8/3ZMuxfC8Hy9I9V1ktjss6H39xpmcApNMzK2LO/
	3Yw2g/mJwjcYX4ljSwNNnlk/K1rLZkK9d+Y2Yv8IqPo1XNLw8tUwoyFttEc7g2UrjNd1FW
	39BnYnD16N8QDm06jY/9acjSL6pz6Z8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793959553;
	b=SDqYsaKxHMQiXvZWI+exaNwFE5uGY4Rr5I1BPUHrmsd159jGIMZ9UeQZ5Kyakzlufjy9c7
	gnpKuoFZrzeKXq1fA9p7buFJDQme+Hb3ccJd3TpgYF+tNbSWeXj9RkeBj/0h28VkdhCbmK
	Cv/449BfAsgFumcgDFaicxndZryUABU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r3RaGep5;
	spf=pass (imf10.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.106 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=boaUt3lXNw1pWwnwHBSwxbjYyF1gcSAqeO7ntekMlU8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793959551; v=1; x=1794564351;
 b=r3RaGep5JhGWK48CC7c+ZdtY9AKSMfoGKGSq3N4YUhR0x1YS1zocXQLHa6VzQXjQRmoLFn5X
 pFIS+p6Jl3AUIu7s5BJ8i5ru6g5hym4Nm2YKi7inFfhzMYN3iU21gmZX9jvvQADCT98Nc3IyNU8
 E2BOGSML7okv9hFyKuz1+5uY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5c9245ec463c574a;
	Fri, 06 Nov 2026 10:05:48 +0000
X-Mizu-Trace-ID: 5c9245ec463c574a
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Mani Tofigh <mt4022@columbia.edu>,
	Zi Yan <ziy@nvidia.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Frank van der Linden <fvdl@google.com>,
	Chris Down <chris@chrisdown.name>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH v3 0/4] Subject: [PATCH v3 0/4] mm/hugetlb: Fix CMA parsing, flags and usage accounting
Date: Fri,  6 Nov 2026 18:05:17 +0800
Message-ID: <20261106100521.30099-1-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 412BEC0003
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: r95hk4dmmio655bmt6ixgyoksm3ttwon
X-Rspam-User: 
X-HE-Tag: 1793959552-116669
X-HE-Meta: U2FsdGVkX19/y/zsqzRNl0VK0Wbrlc0D+y0QMVzgA3iiinFOxBSurwlwMKxJkwuARSvmXxYYObCFfavUL9mHyxhAOIVSxDN8TnLc8LVu43oJw2JGaW2dPmkrdBVsux+MRljV6IkYnxoDy4sU/1a6jnRVoWj5Ht5FjukmfC+DaVj8xWVgjpxyhUi1S0v2MdwOQbtBSoPGw8WTATM1/5S39RvBkbF80mh7uTa0+kck/Eq1M16c89EaZODEDx5DRX9q9Rm7yKNt2vXyasAgvtdYPCFcyUoSZan876uzebvDPa7bVAhsXdZoXruH8/43SU5FN1p3TNfIuxhC0dsG9HoQ6ITxoWueiPa4iyIqR7aLwOWxz+3KaaoF4ML0u4K04USzVNt2REXLOYhMvvq4pKSRRlAE6hEqsaGy4bPkyPXfQwjZPl8YqwVwT7K+DiHWfIVSeLtOkb2/aNasJ+JDTMbR6n4iM9iWcDHiwy2jOO8E1Wql1Qx5V9LsyaUtaJ9fl3m29Qy3vVQnOfIT2gk7B60VezYMOegMkyffCvmEAnVm9m78Wpg3rrAz1F10hXQkTOc+sl392S4sCZHrLhBwRcI9pBXGTXprXWI/uK/nPQZae7Ve+/PY0qTrQIr/5SrCqsRYFlk8kIsf3gJI+epk7DzjqA40Szmk8bqkhfObrXq3zwH+sGqsIkLUdHaHwnzeJaWSAbq2WqWm2VbfOV6QOt3bthiJBUxxITlUMs1BzuMy4oY1TyM7dSip1GrNxzxFEBQC5l/6EOEH8fjrfXrjyWlz2J4tpFJRSC9TmorIhMcJCdV8PVGbsByjtnpfAl/xJBAmXf2QBXUVfN4VqVcCT4y6oKmMrFgnHS0YfC9Pnxd+otVS/yCowXZNZlbxq7pXM/sWEw4691l4Wj8ExQLJxWcgTd4Iij/M/MpELA8SE9TdjR1G/EfiH2ONGSiqq3HsrF/2ukXGYuB2RaMd9ZF29wg
 BI3P+ZNo
 naR53arL6Hp1Y+OSwk/ZCuGtC6BzX45qX3KxcQg6wd+PDGhZYzhFzAiP0nKW8pQIoIOOOpX74fXgVuazRJtksnS4RNjUIfAStC+BxegzBxaXDMdos3UCuWzO0KHmxeTj1k/myIUPag9FGXMajavjepaVynqCnxVrgzba0S3NDzsj2jo/PtjTwXodiaMuSKVifCeuaXBZFmJo4tKWLZu88+OBl2fp1CKXgEt6tb0WBGQ2aPvJ2TfM9w/Z275XodBk1+++joQ74FBxQGRtJvTkMx3PcTxtXKr10M/Qph3rHevOmRc7Kb3Y4g9TU3D9xONUONnOwV2Qun44+mqw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kaitao Cheng <chengkaitao@kylinos.cn>

This series fixes three independent HugeTLB issues reported by Sashiko
and includes a follow-up cleanup of NR_HUGETLB accounting.

Patch 1 rejects a global hugetlb_cma size following node-specific entries.
This prevents malformed input from overwriting valid per-node reservations
with an incorrectly parsed global size.

Patch 2 preserves persistent folio flags when a failed vmemmap restore
returns a folio to the pool. This retains CMA allocation tracking and
raw hardware poison information, while ensuring transient flags are
cleared before returning the folio.

Patch 3 retains the minimal NR_HUGETLB accounting fix, as suggested by
Muchun Song, to keep it straightforward to backport. It balances the
counter before freeing unused surplus folios during reservation
gathering or after a failed overcommit recheck.

Patch 4 moves NR_HUGETLB node accounting to the underlying folio state
transitions and separates it from memcg statistics. This cleans up
the accounting in the allocation and surplus cleanup paths.

Changes in v3:
- Retain patch 3/3 from v1.
- Fix code alignment.

Changes in v2:
- Patch 2: Preserve persistent flags, clear transient flags, and warn
  about unexpected flags.
- Patch 3: Account at folio state transitions and separate node and
  memcg statistics.

Link to v2:
https://lore.kernel.org/all/20261102024910.31486-1-kaitao.cheng@linux.dev/

Link to v1:
https://lore.kernel.org/all/20261028113319.38544-1-kaitao.cheng@linux.dev/

Kaitao Cheng (4):
  mm/hugetlb_cma: fix incorrect hugetlb_cma_size assignment on malformed
    input
  mm/hugetlb: Preserve persistent flags when returning folios to the
    pool
  mm/hugetlb: fix NR_HUGETLB accounting for unused surplus folios
  mm/hugetlb: Account NR_HUGETLB at folio state transitions

 mm/hugetlb.c     | 52 +++++++++++++++++++++++++++++++-----------------
 mm/hugetlb_cma.c |  3 +++
 mm/memcontrol.c  |  6 +-----
 3 files changed, 38 insertions(+), 23 deletions(-)

-- 
2.53.0


