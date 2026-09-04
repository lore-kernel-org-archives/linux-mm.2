Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4FB6C624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 03:54:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5C446B0088; Thu,  3 Sep 2026 23:54:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0DB26B008A; Thu,  3 Sep 2026 23:54:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A23036B0098; Thu,  3 Sep 2026 23:54:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8510F6B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 23:54:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 295A81A0705
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:54:18 +0000 (UTC)
X-FDA: 85174712196.10.CAD8FDB
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5BDFF1A0006
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:54:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=FhDcHrVc;
	spf=pass (imf19.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788494056;
	b=u8sy0Nc/NAS+1zojcZ3VBbq0gxXJ7lVL+vZBrzXaxxa+cznF8OAR4R3SHljtD1NaNt5PEA
	npGd/D0E7rAyvtwiAUFdaZDQgGgzg+hm/Gme4xY+DQj4JK77iZERTjDpLcgtBrqM0kfDUE
	dBOWMj5pPit4g8hY3QvgCC2+mOS4HZM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=FhDcHrVc;
	spf=pass (imf19.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788494056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/3xAFCi4zSn+vaxb4ofxRbStLSppBczqCnom+pPRFYE=;
	b=ssF2OtenMplhBdpKkzVeiYzcZ/cu/2VYRe6cKAZWzVpqZsc+aLuvZOKCOPL29uHrFLS94E
	2A0wujwuO5fs+OLxufwJo/8NZqwXdZoSt9uWOI87pXIFwae+9qLcVD4cDVzxXZ1CWy/XzU
	VbJqAV0P1iisQaEuLFjT3N7diKNHIUc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788494052; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=/3xAFCi4zSn+vaxb4ofxRbStLSppBczqCnom+pPRFYE=;
	b=FhDcHrVcW28RuKiAhLCNOHZSXpq26rBC/E5UsXc2ZfskBNAwF99uk7z8nmd/QCW04pPVFwtSO+crmbeQ8Z8pVEyK/sTSawObouBnKuNK42ezjGA6E/SLD7rvun9PdXcHjDr08rl9+iXNf38w3nk16rgN4cE1piQm67U1AyE5DxI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=28;SR=0;TI=SMTPD_---0XAHc.cH_1788494049;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XAHc.cH_1788494049 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 04 Sep 2026 11:54:11 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Xunlei Pang <xlpang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Chris Down <chris@chrisdown.name>,
	Chuanhua Han <hanchuanhua@oppo.com>,
	Kairui Song <kasong@tencent.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: [PATCH 0/2] mm: memcg: settle memory.high debt for non-blocking THP charges
Date: Fri,  4 Sep 2026 11:54:05 +0800
Message-ID: <20260904035407.4098627-1-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: sud44bz4n3ksi8xcbbjj8fewjqkauiyn
X-Rspamd-Queue-Id: 5BDFF1A0006
X-Rspamd-Server: rspam06
X-HE-Tag: 1788494054-504029
X-HE-Meta: U2FsdGVkX1+LVTKG3x+Fgtx1W+DPWuUHlCmLqF0EAIA+B7J1v8C6xAG7qdMAzNPdMBq9B5if15fzx95IczuMr02DFud3v+4b5FTiWblBfckEIKwiU9FZGOVy88rYn7YWiM9wTRqnAZ5Zcy0vHC9mXOXiGPW1i3MxJTD3aDWEoPy8giiW59mjydwW1QNrYd5slkiaJCqr27m9x20ymxIRZU7vQYHkfCbaGqbzYIAK+AM2Wcf+AhNsfk+7o/XjZBJDClk2gE5wuDpliHSAaap8dZMDTs8iqZozHeOXQzXtFkA3s1jz6/U0gBWLBsAml7cWprXF7N8tjcjjhRENv0Ep3WetwtEbp+68XZzUPceh3ijqY6mct2eBLx/X/VjLpfo/SSM5p2/kRFkvRISospEH+PrJqrYIrGlF39DYbqswFFeS97TWRUH0Jnpgn8Hc4QfAweSs1vpibkvvqmW6LAdP1uBuZjLOwgETk823mWY7H20oYAQ3n5L7ZcWrD74Z3GHDj2j2TzVIo5KMqoKnRFHJCj1YaNd1dnbva7OnUvTE/U+YPuIhF1vGb49K/onPgh0tQ1MZm58uE5eSCTgLG8j5kb1QulJaVcGmYyHoVLJgD6KVOxs8GGyJZgUcgNUbCt93Eld1w7GHUtsbqFA+lXhrR+7exuOKSKQrYSmq0mECbb0ZUcTBnzpIBPHY2jsd6iRcpxac67g118ibUM8rGEN+EYifM5vMKXQIU5Edir3vsCzSVGAyTsLE/pK27o2hrA1pV2WA/MyREzknktqbR7xg/6coimfCUvnehdkzA4HRkFvg6pZel1UZwg9ok2hZV4SH05Z1hYcRZtB7ljvGnpwcbAAgDA+5FvPIiazt0OLrEAfDqucVCgSXAWE1x6XrcBr7KqHzrycOzHcXJ3vVpBdbrsEVnZMbohJgif98C2WeoTCwJuterj+u7TO7LKt+qRaexVdvuC93yFeZZuvgxgl
 RG7eZ577
 pajSXM3DNBsweeSE+6NIKto1JetSg2FEcisII3cFFT6d9FOzO1TVaCfc03jWu0QOvvRDYYSm1lFFjD5NFJ0LnriHJzVEg7onhDFDs01WzlA4feQrZpaCEpXB+ftfBb3DkthJnYLuxUft1xhnZZkFEhzLCfHZ704Z++9I8u5YXbjMRRg3rFNW3bmQcqq1v4npk2k1w4YvZOzwv24h84n95Y7RtCCB2H/wP8BSzU/cNQgItLms28VngQHVnh6pT5X68aayO813Suxvfeys=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memory.high is enforced at two points after a charge succeeds: on
return to userspace, and synchronously in try_charge_memcg() for
large overcharges, the latter gated on gfpflags_allow_blocking().

THP charge paths pass the physical allocation gfp from
vma_thp_gfp_mask() to the memcg charge.  With the default
defrag=madvise (and no MADV_HUGEPAGE), as well as with defrag=defer,
that gfp does not allow blocking.  This is the right allocation
policy -- a THP is not worth direct compaction, fall back to smaller
orders instead -- but the charge code also reads it as "this context
cannot sleep" and skips the synchronous enforcement, even though
fault context sleeps just fine.  Inside a single-syscall populate
loop (mlock(), MADV_POPULATE_*, any GUP-driven population) the
return-to-userspace hook is not reached between faults either, so
nothing throttles at all: a memcg's usage runs from memory.high
straight up to memory.max with zero reclaim and zero penalty sleep,
consuming the reaction window that userspace OOM handlers (oomd,
Kubernetes) depend on.

Patch 1 fixes the anonymous THP/mTHP fault path.  The pre-existing
selftest test_memcg_high_sync readily reproduces the problem: with
transparent_hugepage/enabled=always it fails without the patch and
passes with it.

Patch 2 fixes the same problem for large folio swapin on
SWP_SYNCHRONOUS_IO devices (zram) with mTHP swapin enabled.  Its
changelog carries measured before/after numbers for both the
reclaim-keeps-up regime and the penalty-sleep regime.

In both patches the charge gfp deliberately stays coupled to the
allocation gfp, so the fail-fast fallback at memory.max is fully
preserved; the over-high debt is instead settled from the fault
path, which knows its context can sleep.

A note for stable backports: mem_cgroup_handle_over_high() only
gained its gfp_mask argument in v6.6, from commit 9ea9cb00a82b ("mm:
memcontrol: fix GFP_NOFS recursion in memory.high enforcement");
older kernels take no argument.  On kernels predating the swap table
rework the swapin charge sits in alloc_swap_folio() rather than
__swap_cache_alloc(), but patch 2's fix location at the end of
do_swap_page() applies unchanged.

Qinyun Tan (2):
  mm: memcg: settle memory.high debt after THP faults with
    non-blocking gfp
  mm: memcg: settle memory.high debt after large folio swapin

 mm/huge_memory.c |  8 ++++++++
 mm/memory.c      | 10 ++++++++++
 2 files changed, 18 insertions(+)

--
2.55.0

