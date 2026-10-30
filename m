Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63C7C606A329
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 20:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=flNFtnST
Received: by kanga.kvack.org (Postfix)
	id 3CBCD6B00EF; Fri, 30 Oct 2026 16:54:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37DAA6B05B1; Fri, 30 Oct 2026 16:54:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 292A86B05B2; Fri, 30 Oct 2026 16:54:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 036D16B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:54:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DDCF9407B1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 20:54:30 +0000 (UTC)
X-FDA: 85380495900.27.9B34206
Received: from mta0.migadu.com (out-62.mta0.migadu.com [91.218.175.62])
	by imf23.hostedemail.com (Postfix) with ESMTP id C465D140005
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 20:54:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=flNFtnST;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.62 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793393669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=STYotNoZgg8knNd9pb1oCT8l0qfH9UiTH6m2MFo1QdM=;
	b=KdZOT5hv2sOzcoEOnpQxLEYlQNitMVI00YAprlgA9eZitQXn8unHkpvLt9qPOSALRLK3ys
	xkXPT4EG0h316W4qtKQNVNJsIs4DgvdyLGsxyd0y0pm1iOH7TYlWjE1k+Yu5Is+9HSW6y5
	c9HCNFh4nZYKk9PdZSb035AWdP366JI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=flNFtnST;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.62 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793393669;
	b=PcpB1XPARN2+UC/rsQtIxxnNBYEjQ83V2wALfapaXOrJo0S4bg75HJjT7rXATmtXMv/tqp
	zWX6AjBEQc1BFfT0oquO74ekPBx0b/m9Neclb4tlOXIuQamqeblBPc4bayPlpJ/4WOHFJ6
	82uYck+/O8Pft7SEN9iEzv7hHnn+6kA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=8clnnUmUC8q777oCgAvC8M6C04u5+OxxMaV3Uhj9mK4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793393667; v=1; x=1793998467;
 b=flNFtnSTl9wJzPFeGhajh+eZ5PWtuKFwlQJ/4gTTrkkHaepXb9UfmWHG0qxXFk/79wWXCWZV
 UjOupzlBz/SZ9J7KJSIp8hh72CLDI+TXr6HjamiM5XUCoaCrHdR55Lg+uwAeqhADvsqBek916sP
 U8SWk5gl2nGVuSnMzQs90cMA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6fa3195e4235a3b9;
	Fri, 30 Oct 2026 20:54:27 +0000
X-Mizu-Trace-ID: 6fa3195e4235a3b9
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] memcg: clean up memory.high enforcement
Date: Fri, 30 Oct 2026 13:54:11 -0700
Message-ID: <20261030205418.341214-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C465D140005
X-Stat-Signature: 8f4ux1z9fo5c4dk3g33aw16mobpqfkso
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793393668-469105
X-HE-Meta: U2FsdGVkX19ssQopH1Af7+oI36O1tjZ8TT/8mYUXJPkQadESZ86NAl1UAEEGRR2+QDXUPJOnSMdtdKIAQ7kjTGEBTPf79urF5KA2YsdZ/rGBHqG8kftkD86DzB8f+ojFhPBbca4eH0VENDEsi6WAPz1TW3bWwaUeu6pHhRlREdCSxHnjQ2Tt5R8Xpym0jp86TG+wUT9VYQJN5snaLL/QNkK5zbDmrMJChLFZXpjt/n4nlTUnIDBmaSgCQvFkMjJ3MQBqM/Q3advpPOQib29c7hXM+bFAlVB+tMgNgDdAbk2fbIv4NDvfLjlny7IyhBsrBmAFEkKQ1vmZcf5Eoqd9j1aN25NqCz/VnTmni1DBUVqg9hQtfCRgKfYxJBWO8SvfpEbsNswwlGabPF70bSXL3tG6XQt5mLYrciA7bXs3VmeAiTwGlZWIJdee7bjkOTIT0pcWORlvnG6wJvlqeZpxIbShPEuraZo937Dw7xtfLzK7sh9uJyRMl8rKS42w9MZ+YmyhGAmpWoE5wXOAmbuQZuUCrvgBJ95qOgjHDZDkT8HoP/08pySKs6wMw4NvC0C2x+K1quTXRelNsi9wR6lAe46gxc88TTWe4wmaOL+j0xvRPfH1ziuFY916MndrmXVsM7S/GT4zsoIfq9YUKH0QoIDJrssGmf3WQhVEXyAPmoPmIV97J0bmT3w7W9m59Z+ROSu5yaQ2bZu/aBua2YVlH8fvgx6Gu+/mnwwRONAvDPHwgyNJnZRZhi9xU5tqBGx9+YbCJfLAezamDIo008cmeTgnwbm4ao1jUiXaJffbD7kSRw2JJwRUb5oUPZygqu9lgxQTDhXKXgpwAsHouRZzW6ZLpt3SVnCK1JU0qIF40VvlH3Jfg29Nqyeg8VYenMH0j8eh30+ONrdNKYv5a9dJJa+4tv8v+H+V0dgjzCPAiSr/KNZluKpFeqUNJ36wXNiGlUfRral8nr+tkpLxEul
 tfIMEc5u
 BNtXxq5z9erfD9GreRzJ3gRyx1u0dVP/i4JlM8vKrAuRdhysqtbMNd4SmFVMvqAmzJtiz5Y7oWDmkVC8mV3Skh2ZNpwOBE8BBf0Sb1gBopn7oQG4Fm7uNqiBtvu28o5TYjyuGBPIPLliPqLEfDHZ47XjNf7gXPnBEKwgShycDegprH9jzIjjVVKFL/YyBx8roTkhWvxieTYvYMcu6rpbP68Z0+dbEaupTY6jqxRHgrlE7VTphwVv39rheoWfCcBDZJAFK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series cleans up memory.high enforcement and uses a worker for
kernel threads and remote charges.

Kernel threads never return to userspace to run deferred reclaim.
Reclaiming and sleeping during a charge can also delay work they do for
other tasks.

Remote charges can go to a different cgroup from the caller's mm, for
example through filesystem notifications or faults in another process's
memory. The high handler uses current->mm, so it can check the caller's
limits instead of the limits of the charged cgroup.

Use high_work to reclaim from the charged hierarchy in these cases.
mm_match_cgroup() identifies charges outside the current mm's cgroup
and its ancestors. Local user charges keep their current handling.

Before that, force charges from PF_MEMALLOC tasks before trying the
limits, so they skip memory.high enforcement. Reclaim can charge memory
itself, for example when zswap stores a page, and the high_work worker
must not queue itself from its own reclaim. These charges still raise
MEMCG_MAX for the same cgroup as before.

This is best effort. A fast allocator can keep usage well above
memory.high; memory.max stays the hard limit, as it already is for
interrupts. The worker paths also skip memory.swap.high throttling and
its high-event reporting. memory.swap.high only throttles the charging
task, and a worker has no task to throttle. The cgroup's own tasks are
still throttled on their own charges, and memory.swap.max still caps
swap.

The first patch moves enforcement into memcg_enforce_high(). The second
forces charges from reclaim before the limit checks. The next two add
kernel thread and remote charge handling. The last simplifies the scan
and comments. The first and last patches have no intended behavior
change.

Based on mm-everything-2026-10-29-04-31. v1 was tested in an x86-64 VM
with loop writes, threaded NAPI, remote faults, notifications, and both
vhost worker modes. For v2, each patch was built with GCC and Clang
(W=1). In a VM test with incompressible zswap data and remote faults,
the high_work worker queued itself from its own reclaim in 118 of 284
runs without the PF_MEMALLOC patch, and never with the series. The runs
were counted with bpftrace on queue_work_on() inside high_work_func().
In another test, a parent cgroup was over memory.max while its child
was reclaimed. The child's zswap charges raised MEMCG_MAX on the parent
7133 times with the series and 7124 times without it.

Changes in v2:
- Rebased on mm-everything-2026-10-29-04-31.
- Collected Reviewed-by and Acked-by tags.
- Patch 1: add the missing Signed-off-by (Harry).
- Patch 2 (was 4): replaced with Michal's suggestion. Charges from
  PF_MEMALLOC tasks are now forced before trying the limits, instead of
  skipping enforcement in memcg_enforce_high(). MEMCG_MAX is still
  raised for the first cgroup whose limit the charge goes over. Moved
  before the kernel thread patch, so that no commit lets the worker
  queue itself. (Michal)
- Patch 4: say more clearly which charges keep the local path.
- Patch 5: drop locals that are no longer needed, and update the
  comments.

v1: https://lore.kernel.org/20261010210957.1350874-1-shakeel.butt@linux.dev

Shakeel Butt (5):
  memcg: move memory.high enforcement out of try_charge_memcg()
  memcg: force charges from reclaim before trying the limits
  memcg: use high_work for kernel threads
  memcg: use high_work for remote charges
  memcg: simplify high limit handling after a charge

 mm/memcontrol.c | 157 +++++++++++++++++++++++++++---------------------
 1 file changed, 87 insertions(+), 70 deletions(-)


base-commit: 7e12256cff20c704fd5c0fbbd6a070fda8c341c9
-- 
2.53.0-Meta


