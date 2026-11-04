Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EA27606D814
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 23:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fkHLGzSk
Received: by kanga.kvack.org (Postfix)
	id 4AD246B00EF; Wed,  4 Nov 2026 18:30:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 437E46B05B0; Wed,  4 Nov 2026 18:30:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FF696B05B1; Wed,  4 Nov 2026 18:30:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F10E06B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:30:33 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 65DCD1A085C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:30:33 +0000 (UTC)
X-FDA: 85399033146.20.0F7B8CB
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id 886A54000F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:30:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fkHLGzSk;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793835031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=S8O6n4wkP+hVSces6SjRurqbVke5VUdfxmmLz5pPN8Y=;
	b=nKsBb9kay4Engs3k8uRqQdwDfo1R9hUQ/DiFpyvIiuQZVCyp+B3wawrqZAE/z3+sG3vBDL
	reVBTK8lOD7hd0cuKrn+2w3sJak/ir9TRR6T1Lvak6SpwTdfwyCdbfRNn/zXppJDFdscAC
	o2Kgcs+Tu0w2g4n0r0Qyrc7SP9mMNis=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793835031;
	b=B/HVTPxaHLUPTvuPgNfNlWzu0hh9NmgcJokirGgnhpw17s/TyeAStomHQTrk5zDwMjuQcW
	7TcCfVpdApM2NVi+1oOSojdPLoKyxSr67aOcHLJh6EBc8oge6fAx7j1rW71tj1KRoKOTs6
	2gJgSZEjgAsYbMHcEt5cp9gThKDOPd0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fkHLGzSk;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-8b0a921ee46so12847937b3.2
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 15:30:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793835031; x=1794439831; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=S8O6n4wkP+hVSces6SjRurqbVke5VUdfxmmLz5pPN8Y=;
        b=fkHLGzSkNscuY+Ny5QdTaWLwitzqJbyXb3LjeC9CXB3b5es6qUKi/iRse+ZC6aL9WR
         GzBxgC+6rY5QPVpl0N/7YQDG+VyDZuG00zh9wg4W+v9NLg9uN/Rt0SqbRHMFsjLyrRKL
         pm7301wMU4qVeCT9JScA6LUjROzdcSBZewtfnpEamLIx4ncttG2/Wybxfkyq9/9D6yjb
         IeQYi74LTWKP6ZCg7PhL2w/N43aYuBGkXz3kk/pAuHe9v9nAJXdDlUOXHC4B7dq2DV6U
         Fy1emM+7ndj6VDNk3yAQyiW9rwCgbrzXY5CFe1eT1S1VMF/XlQBAGeTmHvqK76CHxTiU
         dgiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793835031; x=1794439831;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S8O6n4wkP+hVSces6SjRurqbVke5VUdfxmmLz5pPN8Y=;
        b=dF7GXiab9PvNeFmCclv0c2VPKGhU2ucqvcnIdsKYPyfQnXuPR7GfQNDArOPlo0RwFp
         cYiiMqBtIQigSZg3qxlEO3rgUiH6+GZxGrPtSelKKL+l7+AtZ95awJxtr8u5bNzSPZ9b
         xYO5gE6Gjq8+9h4GMydyWfTUJp1vMUnDAF2iWC5ezvWtFxkxCyYCzrcuQ7zY/rzVDxb2
         PEY1zUspvPLSPeLKId/uE8RcmXjDIOf+6cOQdnKVesM0xkXWlyhC2qMej/6D9WWGeKRo
         lN2zXrgaY620A2IBRl/vOCN/CozK2cPS8YiXf3MPvudPkZn1WgDTzx7VF6DpCO9C3rEZ
         POIw==
X-Forwarded-Encrypted: i=1; AKwUvBwhgC9Hq1wPgdCu5wFUlvQZfSQY2K9liCSjd5CqgcW6gF7OARLozQ5oAR+Ye2dSYne0X2LhS4r6GA==@kvack.org
X-Gm-Message-State: APuU4Z9Bv1viRzlKGn2emUf1CgfGHgNUXZWg21OcayLTbdVXdusy+dIO
	+a+I53kNDi44yAFKtwGIN8AKhIryS+A1P+PoW2lmhhyPLt85KLSVS6YH
X-Gm-Gg: AYBFou2frKb972ku+wj2pRV64liZ3hf0X796Id2obTHN9Gvah3Vfo28uNA8uneF+7EM
	64QYI8lTuKULVeca7T66X+/aSrz9J5I9bT5BvZQhZ5B090QHSSzgJ0qzEjvffICR3GLO29bXhU+
	IwZPhOo9Q8+oRVLNNXPKRrUSUV5BHOdyJbavmrxPpk6n8Ix4brKd1Itn23Ss4nl10xB7E2PF20L
	Pd/K2hN9rVG2nZVv7J0e+QhxE227aemd5RD0Hv3RJpVEaklX2A8c7vmgKmWGcBPipCk9b3OuxbH
	5Tf3DN/s7X8If+ZGEBsusi/M7swuL7V/DAbmCmQsVD3qhXeIdSNq0hLJIY5m0Y6l7rNt84A3s1l
	hMSE8K8sOGcPfy7vBgRvOe9bKWTS5SqUR534l88WBYH/V0PX/7rT6GBxqKEwPbS32c1DaRy2Sqd
	oHuO4UbVOMEfMTKEnXrifPkdFVGXQrJFtkqucWzKx1DdMq20w6IM8b1FetcfPw738Kw0upVttsT
	gpA+YZWveixuBrCuOswLJ/Jupixf10lm65lmGW2b1ifWVtEf+81lDFNwAoTKns1uSD1H4Y4TIyD
	V5Gbvq71Wez9Ma4jpNqMdG2d1ZkCfd0rJnTuWJmxr3OWCPALrHW+lkQO9gfC
X-Received: by 2002:a05:690c:e210:10b0:8b0:a30a:7f05 with SMTP id 00721157ae682-8b2b6774969mr71427577b3.84.1793835030478;
        Wed, 04 Nov 2026 15:30:30 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:73::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b30997aa84sm29045837b3.29.2026.11.04.15.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 15:30:29 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Harry Yoo <harry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v8 0/7] mm/page_counter: move stock from mem_cgroup to page_counter
Date: Wed,  4 Nov 2026 15:30:21 -0800
Message-ID: <20261104233029.3282438-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hkeczzkpsi9wkgtzzsciz175jxn14fsb
X-Rspamd-Queue-Id: 886A54000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793835031-451025
X-HE-Meta: U2FsdGVkX1/MHdBDIYzPCj+t2afb8rCMBhqj6R9bgF7dVeMLFyaNbWHJxkEbv+oxggBzm33m4O/90JkVW7tzgBJXe1F8uGNGICcSo/Le5nT5ynaWZX7+Lx1JIOndU3wwki4S/WMt5irFeG9l3vhUjsVDnzYpC6mKOAS/jqTWTfEUjyj7VjYnMBdtWTsLMyU2YlXEjROK+9tMiRSfn7HRLH4RFh8fr4SSKAc1hAjwv53/wMzs7rHJHpfDPV6+uXsv8/MdxHFJ3jtjpbLHnNRd6cYPP6kRkpbAreQ/jqD4bly/lKtIINyeLtE9udpFOR/sjgUwtSCnAzLEZ7hm4UfKExP+HOA40DV7EH+d5IJsERm3UjHp4BddxGlXkf8Ve04+i4Q3tFZ7i2Bqkramy+Qf4iNZ0PoO6Brl7k6LTsOhdLvGGlgw2s/z9HN/eedpLe7FoRdGsfq7Q6m/WGvg7WVSr4pSqMI9MCFpgrEYnuReBowRqhRGxlqJVCzQTtVPfJmza/nQu4N5i+6IIVyGzw+m3OgqkiaMYpOVPHHjdtcD0wNZnfLC6O0LYOVH9gYlEaOT/UrPqaecEqRfh7dSrxOkq7kCUKLqMjXrMAH/KZfdYtJN/lnK4qrSlUplL9srqqmtHFivWAIIPtv28FdnYufqPDZBKcz8T/vSzUt1E58BRgM8DGybXJIecrQy/USIZIqpbqefeSnEuuHiBL86yHMBvDP3453mums1UU+zQ59V9wY9SOwA5A++lm5Mewerkyqb1gxdlhzY6sEgu+wCXF9PQHhIKFXbQMgSjmjRJlxUXzVPhAJJbCRBPHuius4jrulxPGJpreHfcgCxXhmkDE/HVm3XXr6RRzdkYJ+y+Y8b9CuE+aqpFYLHQPraIuSXLgiBUaxhXlKs49iylVCuLLRoflOOViSyjbZ/tw6O/UozvpIpCwmAdxsvvc2QJSldKBZJXdt2oHpXJO/8YUu7ZV0
 oNlvrQS3
 BDDeZCCW7KeZ0mkKt9uV+UnpxgPQM6E9SpiskyxQGpj+zUhMeCM4T5B2mzRvist9yPMTg/52600jQsWH6P/aobtuupXxTk60oyTgIWF2KEbsqPKM8vSXeYbP7EIG6ufMekbdiN2MxkJCSFTbJlc1fQjUacNq+ZUA6SPDDbVXY9Y6Dt7Z1uYsrEMJOqgx3Wb5cpFOxA1CF6nwgj84m7sA1YaUSXnZQAeWxkZBtj5rKkavnAfNUubgIgAgXlZuPOzKIrCzQvNkbfcR8XAHBQhGRiSyRrahSgNeec375v9PmpIraDuchQVFUxa4dbic3nPUjWvTCOhy8/8Ba1PJXP5YfcN24vjLSsF7Zw9gZjkblh5XddTlgPAete5PitWQ8CgaJxIl7qVPiGitlRIXpELz5uDgRaxD6tFyLHFCjWjwguVqJJXPgxjEwl4z2gGnfDtnyGsFjulaW048uRj9EgFFADUU0qn5wMLdBFTu9x0RqRVt0cFDBH8uw30AwuCj0yclkPtXFVJAeIZoTE7ErhGowP0gdBi6rakbYz9rkk+u0L9dnEOaxiibFQui1IGrzQZ2dbHMu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

v7 --> v8
=========
- Rebase onto mm-new as of 11/03/2026. This picks up two memcg series
  that required some rework:
  - Kuniyuki Iwashima's memcg stock cleanups were worked into the
    series, so the changes now live in page_counter code instead.
  - Shakeel Butt's memory.high rework. Commit 4/7 folds in his
    PF_MEMALLOC change into the page_counter checks. This change was
    suggested by Shakeel.
- Commit 7/7 is new. It brings back an optimization from an earlier
  version of the series to let stock charge only accumulate on leaf
  cgroups.
  - To accommodate this change, sprinkle in READ_ONCE() for
    counter->stock reads since the pointer can change at runtime now.
- Cover letter rework as suggested by Michal Hocko.

INTRODUCTION
============
Memcg keeps a per-CPU stock of precharged pages so that small and
frequent allocations do not walk the page_counter hierarchy every time.
Today, the stock implementation lives in memcontrol code, even though
the operation it caches is a page_counter charge. This makes it
difficult to add new page_counters to a memcg and preserve the fast path
behavior.

This series moves the stock into the page_counter layer.
page_counter_try_charge() consumes the stock, charges a batch to the
hierarchy on a miss, and refills the stock with the surplus. Memcg no
longer manages the stock in try_charge_memcg.

So the stock keeps the existing layout, which is still a per-CPU bank
of 7 slots, each holding a count of precharged pages that it hands out.
It maintains exclusion using local locks on each CPU, and for remote
drains we schedule on the memcg workqueue.

This change gives us the following benefits:
- Separate charge caching (page_counter) from charge policy (memcg).
- Makes it simple to keep stock out of interior cgroups on cgroup v2.
- Prepares for future work for stock improvement, which can now be
  isolated from memcg changes.

With this change, make sure to preserve:
- All locking behavior is unchanged from before.
- Non-leaf cgroups do not hold stock. Specifically, their stock is
  drained when they become a parent, and remaining stock (isolated CPUs,
  concurrent refills, etc.) gets drained lazily on future stock misses.
- Exact charging for non-spinning callers.
- Stocks only exist for the memory and memsw page_counters as before.
  Other page_counters (swap, v1 kmem, v1 tcpmem, hugetlb_cgroup, dmem)
  don't stock as before.

EFFECT ON CGROUP V2 USERS
=========================
Currently when a cgroup becomes a parent, it doesn't drain the stock.
Rather, it just prevents new charges from accumulating by nature of
parent cgroups not having processes. Here, we can do a little better.
When a cgroup becomes a parent, schedule drains right away, in addition
to making sure parents don't accumulate new charges.

Everything else is preserved. We preserve all draining, refilling,
and (un)charging behavior, including the uncharge path's refills
and direct uncharges.

EFFECT ON CGROUP V1 USERS
=========================
The memory and memsw counters now have separate stocks, which can hit,
evict, and drain independently. Their raw values can therefore drift
apart by the stocked amounts, even though every charge is applied to
both.

To preserve the user-visible property that
memory.usage_in_bytes <= memory.memsw.usage_in_bytes, the memory
value reports the smaller of the two values. Both raw values are already
upper bounds on real usage, so this stays within the fuzz that
usage_in_bytes always had (and this is also already documented, see
section 5.5 usage_in_bytes in Documentation/admin-guide/cgroup-v1/
memory.rst).

TESTING
=======
This series should not have big changes to performance, so I ran some
benchmarks to verify that. I did testing on a 16-CPU, 32G machine VM.
I ran repeated anonymous memory faults and MADV_DONTNEED to measure the
CPU time spent per page. So + number is worse. I ran each experiment
5 times, with 4 workers.

+-----------+-----------+--------------+-------+
|           | base (ns) | patched (ns) | delta |
+-----------+-----------+--------------+-------+
| cgroup v1 |     890.6 |        901.8 | +1.2% |
| cgroup v2 |     893.5 |        902.2 | +1.0% |
+-----------+-----------+--------------+-------+

Based on mm-new as of 11/03/26:
74d73ffcffe03 "riscv: mm: fix concurrency in mark_new_valid_map()"

Joshua Hahn (7):
  mm/memcontrol: flatten try_charge_memcg control flow
  mm/page_counter: introduce per-CPU stock
  mm/page_counter: make page_counter_try_charge() stock-aware
  mm/memcontrol: check PF_MEMALLOC after trying the limits
  mm/memcontrol: move memory stock to page counters
  mm/memcontrol: add stock to the memsw page counter
  mm/memcontrol: restrict memory stock to leaf cgroups on v2

 include/linux/page_counter.h |  35 ++-
 kernel/cgroup/dmem.c         |   2 +-
 mm/hugetlb_cgroup.c          |   2 +-
 mm/memcontrol-v1.c           |  17 +-
 mm/memcontrol.c              | 430 +++++++++++++----------------------
 mm/page_counter.c            | 233 ++++++++++++++++++-
 6 files changed, 430 insertions(+), 289 deletions(-)

-- 
2.53.0-Meta


