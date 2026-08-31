Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4F38C624CF
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 16:38:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 157D76B008A; Mon, 31 Aug 2026 12:37:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E16C6B008C; Mon, 31 Aug 2026 12:37:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE9DE6B0092; Mon, 31 Aug 2026 12:37:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ACE1F6B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 12:37:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A308B1201A7
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:37:56 +0000 (UTC)
X-FDA: 85162121352.23.9596525
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id DD8B2100008
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:37:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A6Y+sfa1;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.51 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788194274;
	b=CF9IoQX4xtD/PteqatRwlqgDIH12zUmxrzP5z/tO8gID0P2wQoJHc/LTSMlmdQ0YzyyoqG
	vJirD6v+eExkd5OeIvqK1f8QWtQVDA8Rjnpr+qKJM7Gh+QuE7ke40uTciDaK9NxxUdhpp8
	zhqJGwPgI4NvK+c12uhZSRLtLW7zaxM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A6Y+sfa1;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.51 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788194274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jHXBYg66UBEqhTnn/X5o4cskQbf8hKecJ7lklGtPMOg=;
	b=sMt2X74vzyTl9rDDlqxHbm/E4VW3GJW1zEIaxOSxGwEBUHc3z/s3nLyVi8BlsAWcVyxAiT
	EcgHI10jXrB3QTcR3z7JPAbQWsuZZqfJ7rChOJFljNKRe0FPVliyz3gIRYxlMfqEmhxolZ
	YK+LmrTCkl6sRJnVrAbVSB89dxjh+CY=
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-6b19e291cc6so1512296eaf.2
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788194274; x=1788799074; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jHXBYg66UBEqhTnn/X5o4cskQbf8hKecJ7lklGtPMOg=;
        b=A6Y+sfa1rZ6jjDGuzwYB0xbKtJIzUXAGqV8Qo3zhECF8VP41qwIK8KTYB+5pbBUhDx
         q6J6Ng0GW5Hq9244caEKWpqW+zIR08dfNdDiNl2cVpAYO/J5myd6cPI76tiQ1t5PyLYf
         wf0RUgabzN7a9VNwkDz2LZFPstZ7Q1Bj57ZbMXyEMArjRcCZj9fzgzDuteGekEqldTKT
         VHHu/5NHKVP3BHsuHyMk6TZ4IygyFMY2uVcXXP987lYmH+4+6Y53m32EuFbi7ZFCnkv9
         36zat1Rpz8/KWm+P1+y9uMY2OWd8uexhr9k9AlESFrtFWJ+CBKx9gvizl766c3aQ+xsP
         QxIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788194274; x=1788799074;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jHXBYg66UBEqhTnn/X5o4cskQbf8hKecJ7lklGtPMOg=;
        b=Lz6lxeYkQq/j8QRZCiWWQVQEf0vAs1WB4Xgr6HuKqqPdxEDAaUdKxAq7415dw3zSFh
         jVFrfmA6behv1rxY5cw30WgAMxBUjcwLvT4uOe6W3UCjWEoZxNNYDrzyLX5YEsZU3zRB
         5zN3VFDvSoCkc4t0lVJclDF0y6h/klPnwmNAeLIwZMWQRaWGEGLf1sg/OXfy3CmV2IkA
         TQvPxBSF7XPR94ZzcbNQmdc1CdC+cB26wT9Zy81AWPLbbNzXCU8vOhDnSrnEr/VNnATO
         kAy2gLYaP2BKYiaCLNVQxh4Jzlfy/sGqD/LBB4xrQnyeInJKx/UUoCCBHurB5f221mfM
         Gvmg==
X-Forwarded-Encrypted: i=1; AHgh+RrSXo04lAN/QpMvkgVp7O+ItGQOd8rx7Nub2OojA9wApapjzChxsrmNzXfIHxZCjrQeXaQdu+LEjw==@kvack.org
X-Gm-Message-State: AFuF++nZkZHyP52s6zcCpxFR5YpuMJxoIfIrOv7qGQAqvv5D13U3s2ma
	FXvDsAiii47MV1bPEUespoNujI4DICzHcwYO7DwlXzVC+9mk9FTSuW8i
X-Gm-Gg: AR+sD10led7Bq+RF8Ep73bhIIQoP+KSQNJrdymchwHsFkRVEv69Ow99faBTeemfKmzc
	O+ylfOuL9+TqIV2Do8IcPHH5nq9dIr2MYYZNBuc3kPw3H2V/1/ClC0xB90oWIApCMLaWFwo4ibs
	PfzrfMdYgV/anbNW6cR3C/mB4Zk4MqdNSVeFSNhspakURawgvxlP7PBprpKAN3Lma3dP5u6dMRv
	nnvdypNL+5yNp0Bg138BF0vGX4ZqU65R4179yYnaUo0Ic8SX4Ek+GcltdFDjAnWU+BcCTgFjWwW
	NYURCpshnl6E2N60X0BYWawvZd8OQWvKQy2fMq/Xy0OBwEr1vrgi/0BR04csEe3J/1VKrn6jG8v
	6O1i4FYkvmLiBpeM4EiWD41+7lZtm2gl+QIUeNMLBgMP6HBlVRE7hYdmI/PHmrLQposqQIlj0Wx
	mHa8QGDq4wgLumljJ10B6Cjxxsb9VZsN6aBidzaPb6ZfwkeNp3/C3sDqK3sr/UkI/IAnqX3AQZk
	jICkmxpU5iQx+HIkvI=
X-Received: by 2002:a05:6820:f02d:b0:6a1:77ce:1b09 with SMTP id 006d021491bc7-6b372ca85d5mr1858404eaf.6.1788194273632;
        Mon, 31 Aug 2026 09:37:53 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:51::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-468a3535e25sm10291971fac.5.2026.08.31.09.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 09:37:53 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org
Cc: roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	dev@lankhorst.se,
	mripard@kernel.org,
	nat@pixelcluster.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	osalvador@suse.de,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	kernel-team@meta.com
Subject: [PATCH v5 0/7] move stock from mem_cgroup to page_counter
Date: Mon, 31 Aug 2026 09:37:44 -0700
Message-ID: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DD8B2100008
X-Stat-Signature: t448189sj3s38b1grqdop9zcanh1614m
X-HE-Tag: 1788194274-881872
X-HE-Meta: U2FsdGVkX18t1AiOwv7ceB/OoYydve1/2aSQJe2I/5/LvcB0w9rs2F/az/Ig4UNphocHlG6UkVrFRjyP7DhD5xYxgob7GUujbPId76MSwbGRrZ9iH6bnyH7LPVbyDgCMzx7Odp4bYItJ29tqvI3tBfT3dc5/ZXn0TfAcSNb58/o5CF4zH5wMDwlFzo1DyEtbP0NWX3KHE4qwzsfzieBPHhTErLNWx8buMJ2DIvww0Q9Fxgy0MW0DDehDJ0yuWpPRW7d2rDnzvs2V0ZVzXylb8UVcOsAcHSrrzEIU942n4in/F/Wiq8TPlar+TXbH7rb5b+JbNDSOBTzG7xr5noMBRlnX5+Dgjimd/5ysEGT/l/R9CQ6o0rbZ2NHb0wzAG3aoeCRIdOLlRgFY4XWpPZPDHrUWOtqicy6lNqNsJNY0r4D708mI/t+xsCMwZUsdYgX7lIXkruVDDaVnuTbXuIhHrSmmRRqURzAzTqJI48yX5H1cD9HAzVB1DNgXt3KdjGM+x7IX+Z4qtHZ35mu24+9ZsE2hpxXcfXyFf1hk5JPSiknwUqmHc2hUKgukQ20cMUsdqKgEhepA6g4mo7ZmofBroNE+03LkEVkDHMhC25gAuPOWlhmm6zipsv8idy85tSZ9RAcYnEy1pCDuk/yefIU7WeapKQbT9mPtt+4IeFsjoulqyyAroF8UBE+kvzlrWgw8bexgGRwh1QGAwA+/ERK0L7Si+KrNCEKkXp2ryMu+bij2tK5hq6W70ClD/SdbaRLFyIh6fBL9LGcyA6V2CwCVFiUjQkRSw5lwL1cqezJunauavW2Zv8eauBZ6sxPQ5UtR8MfzsX9pn0/ApA/Myg4LDdmm7NDkv6JzZbi/nQdT+CbM0OtbruJaT7mntw4sKU8+L0kLfwUNvW7SVcneAuWhnmXPOQwZl9c7h2hmZlNH0l/CToUdSlhpl2HyjWsUSUyInKQn3elTAvTpkedRVLs
 5ANaH0wN
 fNq7QG+JqcLsAFff0wGKiLAVg6iiz/e7VDXkSP0fnUpbw2fLzdBCU+RUAmUTtorD5habloEI4k02WLNiW1MKCznyPM5SnehfQ2NIDRLzH/TuvxISiRSoAdkRxPqa9EkV6/uSRl77gOJx3TLSUAnVyqCMAJI1NUFq+er36yC897anrEopwnSBxeVGqzifeubByHhoLWxzKLo5QX7kSLwT92v82as0YjIao7U35oTFR8cmgPBhjfvFF5TQ/x6+i7/QU3nQ0r+T+ZMQv4hRHlh/8dlvvKZOMggOooJg/4/GMiuYwh7gJSSTw5cIse9XWpp91YWSZHtWR3yviaEzgLLks083HmQ70IdFmQWAKJ7zKdvZ7DCOQpN6rBKv+wtpOI3U8HgquYi4+oilZ3aFrbxV6JTG6+gg3DZcAVqADdVCPzKBf1hT3u/DtKh3ntg9tnzVAUH62vuN/VNTDrgTf/fuVdPf1IJI4IBniBu/nr99TFmNvHahyCr0mzP+17Ttx/8i/XJHh6EFUgAG4FkGTMmk5DbZedLU5Ktn39Aol
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

v4 --> v5
=========
- The stock is now a raw_spinlock_t and an unsigned long to more closely
  match the original semantics of the stock code.
- Draining is asynchronous again, we add a work_struct per-page_counter
  (not percpu) that walks every cpu. This eliminates the concerns
  of doing a synchronous drain.
- page_counter_try_charge transparently handles stock.
- Addressed the netperf regression by reworking the refill path to match
  the vanilla uncharge path more closely.
- Correctness fixes for the percpu pointer access usage
- More testing to demonstrate that this series achieves its goal.
- Included Shakeel's stock watermarks from [1].
- Wordsmithing

INTRO
=====
Memcg currently keeps a "stock" of 64 pages per-cpu to cache pre-charged
allocations, allowing small and frequent allocations to avoid walking
the expensive mem_cgroup hierarchy traversal each time. This fastpath
offers real improvements, but there is room for improvement:
1. Currently, each CPU tracks up to 7 (NR_MEMCG_STOCK) mem_cgroups. When
   more than 7 mem_cgroups have stock present on a single CPU, a random
   victim is evicted and its associated stock is drained.
2. When one cgroup runs out of memory and needs to drain stock across
   all CPUs it has stock cached in, those CPUs will drain all other
   memcgs' stock present in that CPU. This leads to inefficient stock
   caching and cross-memcg interference under memory pressure.
3. Stock management is tightly coupled to struct mem_cgroup, which makes
   it difficult to add a new page_counter to mem_cgroup and have
   multiple sources of stock management.

This series moves the per-cpu stock down into page_counter, so that
page_counter_try_charge() transparently serves a charge from the stock
and refills it, and each counter owns and drains its own cache. This
eliminates the 7 memcg-per-cpu slot limit, the random cross-memcg stock
drains, and the slot traversal.

In turn, we can add independent stock management for additional
page_counters in each memcg, which is used in my tiered memory limits
series to add a new page_counter to track toptier usage [2]. Patch 7
uses it to give memsw its own stock.

Because the stock is now a property of the counter rather than of the
cpu, it is also reachable remotely, so draining no longer has to run on
the cpu that owns the cache.

This series preserves as much of the old semantics as possible,
including non-spinning safety by using trylocks for stock access.
The old !allow_spinning semantics in try_charge_memcg are slightly
different now though; outside NMI, page_counter_try_charge may perform
a speculative batch charge and a refill.

TRADEOFFS
=========
These are disclosed in the individual changelogs, I've also accumulated
them here so we can discuss them in one place.
1. The bound on pre-charged-but-unused memory is raised, from
   NR_MEMCG_STOCK * 64 * nr_cpus pages system-wide to
   nr_memcgs * 64 * nr_cpus. Because a child's stock is charged all the
   way up the hierarchy, an ancestor's memory.current -- and therefore
   its limit enforcement -- includes whatever its descendants cached.
   These are not "real" allocated pages and are returned under pressure,
   but the ceiling the old 7-slot design provided is gone.
2. struct page_counter grows from 192 to 256 bytes to accommodate the
   new struct work_struct.
3. cgroup v1 only: memsw.usage - memory.usage is no longer exactly swap
   usage, since the batch charges may go out of sync.
4. The stock lock is a raw_spinlock_t taken with trylock, where the memcg
   stock used local_trylock_t. Two cpus can now contend for the same
   counter's stock.
5. drain_all_stock() now queues work per-memcg, instead of per-CPU.

TESTING
=======
We can demonstrate the effects of the finer-grained stock draining by
creating a synthetic workload which allocates a batch of pages, then
yields. This is meant to demonstrate that prior to this series, a 4 page
charge could refill 64 pages worth of stock, but have it stolen away
if it didn't use all of it before yielding.

In the table below, the "batch" parameter is how many pages a workload
allocates before yielding. The measured metric shows how many refills
are needed to fault 64 pages. A higher number indicates more work needs
to be done to fault (charge) the same number of pages.

	+-------------------+
	| refills/64 faults |
+-------+----------+--------+
| batch | baseline | series |
+-------+----------+--------+
|     4 |    14.34 |      1 |
|     8 |     7.12 |      1 |
|    16 |     3.56 |      1 |
|    32 |     1.78 |      1 |
|    64 |        1 |      1 |
+-------+----------+--------+

This is reflected in throughput in this microbenchmark:

        +---------------------+
	|      faults/s       |
+-------+----------+----------+-------+
| batch | baseline |  series  | delta |
+-------+----------+----------+-------+
|     4 | 11487696 | 23825483 | +107% |
|     8 | 18408472 | 25869537 | +41%  |
|    16 | 24882465 | 26915403 | +8.2% |
|    32 | 27987869 | 27912912 | -0.3% |
|    64 | 29096451 | 28853936 | -0.8% |
+-------+----------+----------+-------+

Throughout testing outside this edge case across 4 to 64 memcgs per-cpu
led to negligible (within 1%) performance deltas. The microbenchmarks
above are just to demonstrate that refills become more efficient as we
do round-robin evictions less often.

CHANGELOG
=========
v3 --> v4:
- Reduced memory footprint by 4x, from 16 bytes per-(cpu x memcg) to
  4 bytes per-(cpu x memcg). Each page_counter_stock is a thin wrapper
  around an atomic_t.
- Removed locking completely and uses atomic operations to use stock.
- Removed synchronous work_on_cpu. All work is done via remote
  atomic_xchgs.
- Added a patch to flatten page_counter charging in try_charge_memcg
- Split page_counter_try_charge into stocked and non-stocked variants.

v2 --> v3:
- Dropped the cgroup v2 optimization, since it could indeed lead to too
  much time held with the cgroup_mutex. Instead we let the stock
  accumulate in the parent cgroups, which is not so bad; charges can
  still land on these cgroups, and if we ever reach the mem_cgroup
  limit, we can easily return those charges.
- page_counter_disable_stock no longer drains, just prevents
  accumulating stock. The actual draining is done in the free_stock
  variant, where we know for sure there are no in-flight charges.
- Reordering the page_counter_disable_stock path to disable before
  draining as to prevent accumulating stock first.
- Skip isolated CPUs when draining synchronously
- Rebase on newest mm-new
- Wordsmithing

v1 --> v2:
- Dropped stock returning on uncharge to preserve same behavior as memcg
  stock. This resolves some race conditions present in v1.
- Fixed many race conditions between disabling page_counter_stock and
  in-flight charges
- Restructured drain_all_stock to iterate over all CPUs first before
  memcgs, to reduce the number of synchronous CPU work scheduling
- Optimized cgroup v2 further to drain only on the first child and skip
  the root mem_cgroup
- Dropped RFC
- Wordsmithing cover letter

Based on latest mm-new as of August 31, 2026: "da6c37ed8beb2
mm/swap, PM: hibernate: atomically replace hibernation pin"

[1] https://lore.kernel.org/linux-mm/20260820012010.2016086-1-shakeel.butt@linux.dev/
[2] https://lore.kernel.org/all/20260423203445.2914963-1-joshua.hahnjy@gmail.com/

Joshua Hahn (7):
  mm/memcontrol: flatten try_charge_memcg control flow
  mm/page_counter: report the number of pages charged
  mm/page_counter: introduce per-page_counter stock
  mm/page_counter: use stock in page_counter_try_charge
  mm/page_counter: introduce an asynchronous drainer
  mm/memcontrol: convert memcg to use page_counter_stock
  mm/memcontrol: add stock to the memsw page_counter

 include/linux/page_counter.h |  23 ++-
 kernel/cgroup/dmem.c         |   2 +-
 mm/hugetlb_cgroup.c          |   2 +-
 mm/memcontrol-v1.c           |   2 +-
 mm/memcontrol.c              | 308 ++++++-----------------------------
 mm/page_counter.c            | 272 +++++++++++++++++++++++++++++--
 6 files changed, 334 insertions(+), 275 deletions(-)

-- 
2.53.0-Meta

