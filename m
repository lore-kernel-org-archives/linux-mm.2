Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAE01CCA464
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 18:17:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C730B6B00B4; Thu, 15 Oct 2026 14:16:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C24816B00B5; Thu, 15 Oct 2026 14:16:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC3C06B00B6; Thu, 15 Oct 2026 14:16:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6E12F6B00B4
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:16:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DAD62C0114
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:16:04 +0000 (UTC)
X-FDA: 85325664648.03.4052357
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id D1DC040008
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:16:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="M/VSqVM9";
	spf=pass (imf27.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792088162;
	b=hxND0fmZmnczaFvsSRfFCfqV411ugxnDPcvFcMSg6CjeUB2VEifEYW3+RnBD/NFDYSSvWj
	FMKRx/Nnk4yk4bHZh+Omg3PV8vBUO+tnHajqkFnSSQjAtJUHsKXHggAOodu7s2CJgMnJ0O
	tAZKrEv10d/yg8dTOfVmVemzGiEK+Zg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="M/VSqVM9";
	spf=pass (imf27.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792088162;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v6pb7UxVtgposJ3+DhzVqYCobAnMOtPeZwr7Kf17zVw=;
	b=0v1vzwgfgfa3CClHSMABS03laM+bsX/ysih4tdPQ9CFnUD4loliOLAKHKjxrB6tgRoASxO
	F09QZFbukFQ9OSoczucx0JQL6cAYEeotbuDkhjw9cyRWenYd5buvOd3svi/j9Zz9zOpxOL
	BzRcUYURcMwyRVKTicYNdnJE8PaZFeE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 965DA447B9;
	Thu, 15 Oct 2026 18:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 76DCAC2BD05;
	Thu, 15 Oct 2026 18:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792088156;
	bh=9vYadqVkh4WrhDMsH1jX5lN/XH9JwLR+fwEjQqvXr+8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=M/VSqVM9jJUGAMm2rmzaGRTlfA1KecX+avNavtRyTAfdlsSBYSzUgFtLcsq4XD3aS
	 wU3RIHerSYc+iW5yiW8PxYF4E+++seprkzUMoLXA8hCUq7GBle9n5VW6wY24yxhG+q
	 gteyIE0lOqQYcw6X87lY46GlqqfRSA3DT74VvWOpjCksfA6vqR4uHuEyx4soGNYKZ4
	 JNkUdGDRr+mFbPMImkog47DofQrw9N2LmqNU43+r5RpvKJp6331Xgq8kX5EgKDqqsj
	 W0V3LUjXEeSDEWXPtMem3RwzrwPbPJ3xaPggetVITO0wHJn9957FMFd20Gz9q96B2M
	 LTvlP1bXbY35g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63007CC6B38;
	Thu, 15 Oct 2026 18:15:56 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 16 Oct 2026 02:16:06 +0800
Subject: [PATCH v4 17/17] Documentation/mm: multi-gen LRU: update for
 frequency guided promotion
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mglru-fg-v4-17-2106750c0bfa@tencent.com>
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
In-Reply-To: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
To: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, 
 SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
 Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 damon@lists.linux.dev, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792088152; l=5953;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=H9ePyPxQfKEyJG8pjQryA22Bu9URRS7jnmN2RCV298Y=;
 b=Vb9KmjNNstGoNvaMOwNk7ofyjEq/gP8OVY3K9CwFsX4iWIUxqEgFFz0bvwWvH+Y2p0iByDKlP
 wZqWyoquQutCr8DLLctzG4RU7bhi8F6VKDcrlaEAi+LHGq3mAiOnAnb
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: bxpeh6swg7wjfb44zhzjc9rwizze8it8
X-Rspamd-Queue-Id: D1DC040008
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792088162-290253
X-HE-Meta: U2FsdGVkX192BEP5Jq1CM4170LZ1iC6WXtjRf+3WwQebTQubsZa6MqwLII6EkucHYDVExJrMph/i+RpuqvUlfcvaDms/9xS4/ARvEkjlT59upHjqwgTERLzcIj2Q8yKZNEIygurXTEsixIFYpuhr86IlcUXFcaYVmvqJvucmwlmN9A/E3ZYlPR5ZJ0DGFv15J2SJE1bXnd8seppo0x7N0wlLhN7jADhj7axly5tuAUa5famdPuvjmmzhIF6QBkzqN9C9Mz8byMYQYsiCCR21i/epCTWPdLLHlcbLFT3z4F//fxNaBRX3qktPOycBKmLc7LaR9cluWZ2yak6EO+JmvA1OVD/Rrp5xo2LZA/YJiEZH+rOhA86hSsOTpWg9i1E5USJdM9rxkmdRU9zfBXqLx0eGnoyjqUKbezbCDpMSKAgeP1NKXSq86pK5Sc/l04CYTSShJtH9tk3NyOMF2PQW/ijtiGDxAaMZyUUsYQanGBvR9zyX2intUwKkHMMyZjNpzjb5f+Bv2QtFduiGfK7XcBO0FtqO7+LJ/ins3xZznyc18LHulq+uOyC4Lg5PaIDAKQZaPzFmGXIUq1TzAc3waNa1/Q6nVXtoJp7g+ZVTSkT4F5Smct3uL22fNIctMRzCRyIYgf5hS1BMUr+Is6LCcD8DI8aEhAjwhZRZEcc9mMPYhzdOpSiPNrNzXrTp/p6jfzNUjU4FYqRjJKN2IDzWFri4+PXEXL1lhXdJa9joIwYPl/JTKQw9XW35uGiHyMrOEFWV+O0g1iSpENKNC99UBsupHQ4iynJ+JtxqYFvRB7WQvNlF3GMIvXSTRyRflPe+eobugVsZRs0P9ceh79PYcXkZvCI+nUCMslWmicy9kGG7UezrLzyqEAMgLycoR14WsF1h2Lfj+hI/Blz+kBmldBuBmPs9XCh4+cRZz6NjUx8t7eNfmPoYkQdqINozyuRFi6sA7x2DGVa7/3I8v1P
 eI6I7dsq
 GegERutwwDHGWSZ6RuLSRNH1ySTyx9ESAobUJcX6H9Y4aisiV+uEHzH3KkAA6b+PNBCjhjtJZ345DVthmpBaxjmKpStjT+DE/5DU+GTpEON7pkGzflgRalcmjbkkap2zWJaivjD/USY9etup75zFPMbt9LAn7INqR/4SpCb14g4oOlQ0ikHOD4pKPPejMGnRhjBIvlCfkwSj7RyKfwAaouPkRsX7Vow67IhUi82Wc+PId76pySMRhtRDRPeJDSeWQ3D1/edfKGFbrI/1JQ7Z8HjDxH0G3a0AW9kOXqqElX+apRHDLyColtDCBkE/5XQdrTuL/q0QY4/4YcGP+3u6m1SmxJnvkTb0ex9KTzysvPT8YfXZm4xNnMreGtyLE5e6/nwS9NK/qFubUf/zjFWzzNOkrv8/ltMNyWMo5D3A3kDiJVYRhUOz8kTLtUn9GU/KmJVXm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The design doc still describes the old tier and promotion model:

- Tiers are no longer order_base_2() of the file descriptor accesses.
  A folio's tier is derived from its referenced count, which counts
  accesses from both page tables and file descriptors.

- A young PTE no longer always promotes a folio to the newest
  generation.  The first access only moves a folio one generation
  forward if it is at the tail of its LRU, i.e., in one of the two
  oldest generations of its type, a second access promotes it, and
  executable file folios are promoted on their first access.

- The eviction no longer uses the first tier as the only baseline.
  The type is selected by comparing all tiers of each type, and a tier
  is protected by comparing it against the tiers below it.

Update the aging and eviction sections accordingly.

Assisted-by: LLM
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 Documentation/mm/multigen_lru.rst | 57 ++++++++++++++++++++++-----------------
 1 file changed, 33 insertions(+), 24 deletions(-)

diff --git a/Documentation/mm/multigen_lru.rst b/Documentation/mm/multigen_lru.rst
index 52ed5092022f..ec8744c1f42c 100644
--- a/Documentation/mm/multigen_lru.rst
+++ b/Documentation/mm/multigen_lru.rst
@@ -95,16 +95,19 @@ at most ``MAX_NR_GENS`` generations. The gen counter stores a value
 within ``[1, MAX_NR_GENS]`` while a page is on one of
 ``lrugen->folios[]``; otherwise it stores zero.
 
-Each generation is divided into multiple tiers. A page accessed ``N``
-times through file descriptors is in tier ``order_base_2(N)``. Unlike
-generations, tiers do not have dedicated ``lrugen->folios[]``. In
-contrast to moving across generations, which requires the LRU lock,
-moving across tiers only involves atomic operations on
-``folio->flags`` and therefore has a negligible cost. A feedback loop
-modeled after the PID controller monitors refaults over all the tiers
-from anon and file types and decides which tiers from which types to
-evict or protect. The desired effect is to balance refault percentages
-between anon and file types proportional to the swappiness level.
+Each generation is divided into multiple tiers. A page's tier is
+derived from its referenced count, which counts the accesses collected
+from both channels above and is capped at ``LRU_REFS_MAX``: pages
+accessed at most once are in the lowest tier, and the tiers above hold
+pages accessed at least twice. Unlike generations, tiers do not have
+dedicated ``lrugen->folios[]``. In contrast to moving across
+generations, which requires the LRU lock, updating the referenced
+count only involves atomic operations on ``folio->flags`` and
+therefore has a negligible cost. A feedback loop modeled after the PID
+controller monitors refaults over all the tiers from anon and file
+types and decides which tiers from which types to evict or protect.
+The desired effect is to balance refault percentages between anon and
+file types proportional to the swappiness level.
 
 There are two conceptually independent procedures: the aging and the
 eviction. They form a closed-loop system, i.e., the page reclaim.
@@ -122,25 +125,31 @@ and calls ``walk_page_range()`` with each ``mm_struct`` on this list
 to scan PTEs, and after each iteration, it increments ``max_seq``. For
 the latter, when the eviction walks the rmap and finds a young PTE,
 the aging scans the adjacent PTEs. For both, on finding a young PTE,
-the aging clears the accessed bit and updates the gen counter of the
-page mapped by this PTE to ``(max_seq%MAX_NR_GENS)+1``.
+the aging clears the accessed bit and bumps the referenced count of
+the page mapped by this PTE. A second access promotes the page by
+updating its gen counter to ``(max_seq%MAX_NR_GENS)+1``; the first
+access only moves a page one generation forward if it is at the tail
+of its LRU, i.e., in one of the two oldest generations of its type,
+so that the next time it becomes the oldest one, its accessed bit
+reflects whether it has been used again. Executable file pages are
+promoted on their first access, since reclaiming them causes typical
+I/O thrashing.
 
 Eviction
 --------
 The eviction consumes old generations. Given an ``lruvec``, it
 increments ``min_seq`` when ``lrugen->folios[]`` indexed by
-``min_seq%MAX_NR_GENS`` becomes empty. To select a type and a tier to
-evict from, it first compares ``min_seq[]`` to select the older type.
-If both types are equally old, it selects the one whose first tier has
-a lower refault percentage. The first tier contains single-use
-unmapped clean pages, which are the best bet. The eviction sorts a
-page according to its gen counter if the aging has found this page
-accessed through page tables and updated its gen counter. It also
-moves a page to the next generation, i.e., ``min_seq+1``, if this page
-was accessed multiple times through file descriptors and the feedback
-loop has detected outlying refaults from the tier this page is in. To
-this end, the feedback loop uses the first tier as the baseline, for
-the reason stated earlier.
+``min_seq%MAX_NR_GENS`` becomes empty. To select a type to evict from,
+it first compares ``min_seq[]`` to select the older type. If both
+types are equally old, it compares the refault percentages of all the
+tiers of each type proportional to the swappiness level. To select a
+tier to protect, it compares the refault percentage of each tier
+against that of the tiers below it. The lowest tier contains pages
+accessed at most once, which are the best bet. The eviction sorts a
+page according to its gen counter if the aging or an access has
+updated its gen counter. It also moves a page to the next generation,
+i.e., ``min_seq+1``, if the feedback loop has detected outlying
+refaults from the tier this page is in.
 
 Working set protection
 ----------------------

-- 
2.56.0



