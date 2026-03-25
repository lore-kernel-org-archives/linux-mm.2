Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 124E8106B504
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 21:07:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74BAB6B0088; Wed, 25 Mar 2026 17:07:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D4DE6B0089; Wed, 25 Mar 2026 17:07:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59D176B008A; Wed, 25 Mar 2026 17:07:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 431306B0088
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 17:07:57 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B8D67160A9C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 21:07:56 +0000 (UTC)
X-FDA: 84585822552.04.6EED493
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf09.hostedemail.com (Postfix) with ESMTP id E21F214000E
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 21:07:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jk34sV3c;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774472875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lqVAzvFdsUO5RW3GYgUigpuEeGhwLS5p+ajeWTq/wEU=;
	b=mjYY2yhFvaOjoW1vHDEnLPfDlvXqK3C7bhfknuK615FCx4Lism33LtOV/vGkEl5wTG09nK
	rO25wIkmdgFaMyxDzD8x+cmF2ERC0PKFzjE2aOOG+v1RXcTqsj2kltK1ortUomde4whQ4M
	whmx2LzOUsI9ohcJLfA226D5cblPMGw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774472875; a=rsa-sha256;
	cv=none;
	b=D8PPGOgaPn++Z3obSW0UPV0E29roLh3WcL/R5cfx7E2RFIflqaieJvO/wfzKSUb8lolATa
	NqFSPdVKFcQmCA2lfUUsbAZsYq4Qu9XUyC9tK9twvoIMCJxBCC5QK3jqQdFD4PgSD2JtRi
	qZjpyUdNEAb8XT7htdMlApC2adH0F1o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jk34sV3c;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774472872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lqVAzvFdsUO5RW3GYgUigpuEeGhwLS5p+ajeWTq/wEU=;
	b=Jk34sV3cQputcgV+gOHFYcr0sseiG8UbizRrm5Aanuqp35rhwigwtVLKyDDHxEZXbmG1PN
	QtnlV1RwTGkffi9/GuNjJEJDRZGzq/d/oHNJJ1Hy1CnQVAKVLVblNigKI9UyToRefw/axB
	gRX6FAghKf+meNHha2ge8MirvjDMIw8=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: lsf-pc@lists.linux-foundation.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Kairui Song <ryncsn@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Gregory Price <gourry@gourry.net>,
	Barry Song <21cnbao@gmail.com>,
	David Stevens <stevensd@google.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	David Rientjes <rientjes@google.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	wangzicheng <wangzicheng@honor.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Meta kernel team <kernel-team@meta.com>,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim (reclaim_ext)
Date: Wed, 25 Mar 2026 14:06:37 -0700
Message-ID: <20260325210637.3704220-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: E21F214000E
X-Stat-Signature: ijje714urwnnetgtykz4eobmxqadm89o
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774472874-272001
X-HE-Meta: U2FsdGVkX1/oZYqa1DoBLgl/m9Ai1+xTI22Anl1zXWdKlMLxZoyEtdrsZujAOwvq65vhpkbXRZ23xnsEoNL6TjzstHzl8C5IzQOJOA+KE8MONbMT9/r3Tntlg2HDNUG1NgWdd2Je2p9FdQgOp8Sgj2EkBRLAZXwk3sPLsAtSwngUM+pQGT7BzJt1NkR6PAB2zh7z3lw3987ofsfThsRwN2cOzteQQ39boQTsjBpupqrnB0PH2sAyn5vnBnXGsGSZahLcea5KsuWfGCX/vptMxgSaZFxSjLoDappP1jVPZ0rmB1Uw+Udvz/JBgzFn95YWw9yqBkBmiKRvhRZxopRWVI1NDSQqhOeOsIVtYdfw43SBqV24B+PMQLhqU9hlAjG/J6Q1CcEuP2umhlfxOYSwYu/9YspSpX9XOuClYgDVtRVGtFk+6my/Amg9skSqDoEPDnb024C1bXn7m08Ctu/bXbqPw/yWCgX6AQskFTXkDfaBP6iOUbbdFWkge2QKZz32krmRnBQqb0XXr5482vTEJ9rrabTdiVDczfb62DqFk5T6Y2fD0wgFOEwuEQMyQJQwKqfuZkjvxUThqw7Rt1tERTlCLqatXxcujTPGfo+7EpNXOZySUJG4zQHR65VTdA+dQhBD3pXjYIPFWJOqHiRndA0OZ67v8qodwGsRR7GtPgyceHQYy9I5UX0XzD/fcumdDqfkNoB11H428bIZ82RZ1RJZwftC7CdYkX/SeyYvVBTq3Bzh5DJboe0OLZmih0KQE/C90IiIBGobMzvr8aA/2Au+yNQ1o8u7qcVmL+YHZgoXPOHw5crrlYi/pq+j9+1zbF3g+V/6imUNQaLAImnlpu5DpMYjzWENEwjBm4VMmoEgA6utzpd08hzqA0fTPXVmnxPHxa/5cVVXnYZHnuO6aWDR0VUU2NzWp3bDtIr+FPZDn32fOiBAtBVqGMlHmAkxPCk6073clZQnTqM/HXK
 9bsflO93
 et9j+uYbKlJ1Bhj/rn62bm2JDpD1f/T+bJSC25+Vec/1Wh7BiJCMAVRmkq7KpD/3fExAfHhF2SwcxnynLh8en74vyA+wFRp3fY3NRvW+tCMt9l0ZLiwyJYHXy+ORx7cseVZQioPxDkD1cXzLz+nWp2aDLwCEtrVN5KDm3vvKSrp1W3fefADqOPihgzgSYsDvZNrfFKyL8YbxqNdMTuapUjUeDFqfkxO9Qywo7gxySCzWapnQqenO/OrsDYAcJNBCAXGM+OshTNvAhefeiayTXmw+9jA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The Problem
-----------

Memory reclaim in the kernel is a mess. We ship two completely separate
eviction algorithms -- traditional LRU and MGLRU -- in the same file.
mm/vmscan.c is over 8,000 lines. 40% of it is MGLRU-specific code that
duplicates functionality already present in the traditional path. Every
bug fix, every optimization, every feature has to be done twice or it
only works for half the users. This is not sustainable. It has to stop.

We should unify both algorithms into a single code path. In this path,
both algorithms are a set of hooks called from that path. Everyone
maintains, understands, and evolves a single codebase. Optimizations are
now evaluated against -- and available to -- both algorithms. And the
next time someone develops a new LRU algorithm, they can do so in a way
that does not add churn to existing code.

How We Got Here
---------------

MGLRU brought interesting ideas -- multi-generation aging, page table
scanning, Bloom filters, spatial lookaround. But we never tried to
refactor the existing reclaim code or integrate these mechanisms into the
traditional path. 3,300 lines of code were dumped as a completely
parallel implementation with a runtime toggle to switch between the two.
No attempt to evolve the existing code or share mechanisms between the
two paths -- just a second reclaim system bolted on next to the first.

To be fair, traditional reclaim is not easy to refactor. It has
accumulated decades of heuristics trying to work for every workload, and
touching any of it risks regressions. But difficulty is not an excuse.
There was no justification for not even trying -- not attempting to
generalize the existing scanning path, not proposing shared
abstractions, not offering the new mechanisms as improvements to the code
that was already there. Hard does not mean impossible, and the cost of
not trying is what we are living with now.

The Differences That Matter
---------------------------

The two algorithms differ in how they classify pages, detect access, and
decide what to evict. But most of these differences are not fundamental
-- they are mechanisms that got trapped inside one implementation when
they could benefit both. Not making those mechanisms shareable leaves
potential free performance gains on the table.

Access detection: Traditional LRU walks reverse mappings (RMAP) from the
page back to its page table entries. MGLRU walks page tables forward,
scanning process address spaces directly. Neither approach is inherently
tied to its eviction policy. Page table scanning would benefit
traditional LRU just as much -- it is cache-friendly, batches updates
without the LRU lock, and naturally exploits spatial locality. There is
no reason this should be MGLRU-only.

Bloom filters and lookaround: MGLRU uses Bloom filters to skip cold
page table regions and a lookaround optimization to scan adjacent PTEs
during eviction. These are general-purpose optimizations for any
scanning path. They are locked inside MGLRU today for no good reason.

Lock-free age updates: MGLRU updates folio age using atomic flag
operations, avoiding the LRU lock during scanning. Traditional reclaim
can use the same technique to reduce lock contention.

Page classification: Traditional LRU uses two buckets
(active/inactive). MGLRU uses four generations with timestamps and
reference frequency tiers. This is the policy difference --
how many age buckets and how pages move between them. Every other
mechanism is shareable.

Both systems already share the core reclaim mechanics -- writeback,
unmapping, swap, NUMA demotion, and working set tracking. The shareable
mechanisms listed above should join that common core. What remains after
that is a thin policy layer -- and that is all that should differ between
algorithms.

The Fix: One Reclaim, Pluggable and Extensible
-----------------------------------------------

We need one reclaim system, not two. One code path that everyone
maintains, everyone tests, and everyone benefits from. But it needs to
be pluggable as there will always be cases where someone wants some
customization for their specialized workload or wants to explore some
new techniques/ideas, and we do not want to get into the current mess
again.

The unified reclaim must separate mechanism from policy. The mechanisms
-- writeback, unmapping, swap, NUMA demotion, workingset tracking -- are
shared today and should stay shared. The policy decisions -- how to
detect access, how to classify pages, which pages to evict, when to
protect a page -- are where the two algorithms differ, and where future
algorithms will differ too. Make those pluggable.

This gives us one maintained code path with the flexibility to evolve.
New ideas get implemented as new policies, not as 3,000-line forks. Good
mechanisms from MGLRU (page table scanning, Bloom filters, lookaround)
become shared infrastructure available to any policy. And if someone
comes up with a better eviction algorithm tomorrow, they plug it in
without touching the core.

Making reclaim pluggable implies we define it as a set of function
methods (let's call them reclaim_ops) hooking into a stable codebase we
rarely modify. We then have two big questions to answer: how do these
reclaim ops look, and how do we move the existing code to the new model?

How Do We Get There
-------------------

Do we merge the two mechanisms feature by feature, or do we prioritize
moving MGLRU to the pluggable model then follow with LRU once we are
happy with the result?

Whichever option we choose, we do the work in small, self-contained
phases. Each phase ships independently, each phase makes the code
better, each phase is bisectable. No big bang. No disruption. No
excuses.

Option A: Factor and Merge

MGLRU is already pretty modular. However, we do not know which
optimizations are actually generic and which ones are only useful for
MGLRU itself.

Phase 1 -- Factor out just MGLRU into reclaim_ops. We make no functional
changes to MGLRU. Traditional LRU code is left completely untouched at
this stage.

Phase 2 -- Merge the two paths one method at a time. Right now the code
diverts control to MGLRU from the very top of the high-level hooks. We
instead unify the algorithms starting from the very beginning of LRU and
deciding what to keep in common code and what to move into a traditional
LRU path.

Advantages:
- We do not touch LRU until Phase 2, avoiding churn.
- Makes it easy to experiment with combining MGLRU features into
  traditional LRU. We do not actually know which optimizations are
  useful and which should stay in MGLRU hooks.

Disadvantages:
- We will not find out whether reclaim_ops exposes the right methods
  until we merge the paths at the end. We will have to change the ops
  if it turns out we need a different split. The reclaim_ops API will
  be private and have a single user so it is not that bad, but it may
  require additional changes.

Option B: Merge and Factor

Phase 1 -- Extract MGLRU mechanisms into shared infrastructure. Page
table scanning, Bloom filter PMD skipping, lookaround, lock-free folio
age updates. These are independently useful. Make them available to both
algorithms. Stop hoarding good ideas inside one code path.

Phase 2 -- Collapse the remaining differences. Generalize list
infrastructure to N classifications (trad=2, MGLRU=4). Unify eviction
entry points. Common classification/promotion interface. At this point
the two "algorithms" are thin wrappers over shared code.

Phase 3 -- Define the hook interface. Define reclaim_ops around the
remaining policy differences. Layer BPF on top (reclaim_ext).
Traditional LRU and MGLRU become two instances of the same interface.
Adding a third algorithm means writing a new set of hooks, not forking
3,000 lines.

Advantages:
- We get signals on what should be shared earlier. We know every shared
  method to be useful because we use it for both algorithms.
- Can test LRU optimizations on MGLRU early.

Disadvantages:
- Slower, as we factor out both algorithms and expand reclaim_ops all
  at once.

Open Questions
--------------

- Policy granularity: system-wide, per-node, or per-cgroup?
- Mechanism/policy boundary: needs iteration; get it wrong and we
  either constrain policies or duplicate code.
- Validation: reclaim quality is hard to measure; we need agreed-upon
  benchmarks.
- Simplicity: the end result must be simpler than what we have today,
  not more complex. If it is not simpler, we failed.
-- 
2.52.0


