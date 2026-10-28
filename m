Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22FD0606A329
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 18:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=EgLX+vcm
Received: by kanga.kvack.org (Postfix)
	id 925196B05B4; Wed, 28 Oct 2026 14:50:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 812566B05B6; Wed, 28 Oct 2026 14:50:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68B326B05B7; Wed, 28 Oct 2026 14:50:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 21A2E6B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:50:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7FCEEA022B
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:50:43 +0000 (UTC)
X-FDA: 85372926366.01.67E3217
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf01.hostedemail.com (Postfix) with ESMTP id B974540008
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:50:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=EgLX+vcm;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3AETiagYKCG8XhaVlhTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--kuniyu.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3AETiagYKCG8XhaVlhTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793213441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FBGgckuRPIKFzNN+9A67c3GtbE7TkM7/6OfDMvJvqJE=;
	b=pN7+gJB+75LKNxd+v3sjBpIUFJr63dWJ9h52sMtFOK3eSWwEbd+5gRhnvscM0aDmw2ezDL
	42Faxl0TdenqIOWLIk3APjnUEBQ8ooPA6mXEBN1OG8Kj+iHwTtuFvEnvN3tiSex52pPIOB
	qrIx+X9yH+WIcxAbhJObpH0IR6CmXs4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=EgLX+vcm;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3AETiagYKCG8XhaVlhTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--kuniyu.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3AETiagYKCG8XhaVlhTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793213441;
	b=Gp258JWpNLRmJpQpddsNrq7qmXnX9RGD9wn/H0a6qzzjwl38IdRQHe19MWfDVk4eHpOoHj
	W6RooDrHn6DQSQkFYBU11ySxr5AlmThVDS6/ter1McGpnVUfp7tI1stCLi07smXPhYLhnt
	fhslgrvlCjmfE7+U+lVHmSduX1nrGqo=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3ac77c3ff6aso1821702a91.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793213440; x=1793818240; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=FBGgckuRPIKFzNN+9A67c3GtbE7TkM7/6OfDMvJvqJE=;
        b=EgLX+vcmVLmAaPg3X5oSbJu4XRx2prlKHvW80pFqE+2kVOm2yQALWixJoOTOW9yQbP
         UVVrKX53+750TOwV4oRcguwhklDdTv02PVDbpwadWCuwxJWCk7ifOdjvVffTLvlsiDc7
         Q4wfsWeT3DEqI8wzT0+u5Hpz3OUjrwr0gTVDJvgIPgofUXwI/k9hsDYacZtnLRRtRrUL
         I3a8GR5XRXVLfaQPJStyZqc3n9ezcnfnjjZLM6B4nGa12onk9HmPFXZ3Gd8RTy7SRMC1
         tsVGomWgaE350qNvgAkG3bOpKl2WR7c/WQLC1x4Yet1biFqlMPPjEjVJMgm1hMAp9LHt
         OnDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793213440; x=1793818240;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FBGgckuRPIKFzNN+9A67c3GtbE7TkM7/6OfDMvJvqJE=;
        b=LauPnvI3zL2MXhGu6QMiYPEHczEMXJ2EIeDqncovnrvGxl20ewTQQpTJJNuLZ1jq2e
         f5YBLqHNlE0+Y7KR45hyLMXxuD5TccGE2YRvFTEQBSql01ZnCoj9SgqVfNxPOFD7Q+Vs
         QTkWs+5Y995nGsgtDK71KJgcQmESNM2y32hft5v1Npi71Jneexxi+3yaX2txTWfOMulm
         IZUsaDJbtJdzDnMiXsUxAwp+5wtA9ZVb72EdI2alDT5v10YcsN7weHxp63SA0Eagpd/A
         jGlaXFxOW320aCMyIbpT++DtsI6ztx3h4cfG0F2lc35JhY2eV4bJ4GzWbLuxNuWdQWn+
         Sgwg==
X-Forwarded-Encrypted: i=1; AKwUvBwmca5YgzkPh8mRNICRhLEpuP+B2PpFf/z6lxhFOXP3ORwOygNNVrjPYbnlUAT370ycJMv+llQwHg==@kvack.org
X-Gm-Message-State: AFq9FYJv0HbIhwqkPf/9lRXXf4qUrcaI7tbJYdJBufjmL+F5EI8tfhR0
	9K9Hx3gBE6y6hk96WhbPk/KK7+2x/UMjlMj5rC/GZlLpvn23ZaSmlrrrcDr5IrUby0QPrqYZyAa
	ANl5f0g==
X-Received: from pjvu4.prod.google.com ([2002:a17:90a:dd44:b0:3ad:ce09:ff3])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2f4f:b0:3ac:929d:ba5c
 with SMTP id 98e67ed59e1d1-3ae582c2b58mr2301735a91.45.1793213440324; Wed, 28
 Oct 2026 11:50:40 -0700 (PDT)
Date: Wed, 28 Oct 2026 18:50:16 +0000
In-Reply-To: <20261028185034.3607746-1-kuniyu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261028185034.3607746-1-kuniyu@google.com>
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261028185034.3607746-5-kuniyu@google.com>
Subject: [PATCH v2 4/6] memcg: Batch mod_memcg_state() for MEMCG_SOCK.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B974540008
X-Rspam-User: 
X-Stat-Signature: ufaczu3yippqneuir1c78kcd6q1946tj
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793213441-616352
X-HE-Meta: U2FsdGVkX192iIoxRAuHAzFKqOoE9Wnyp3g9mgiNqPn98qfvsYfWJc1VPj+nM7Ke3DteQ4SCarRWme3sSrQaiJvCBAerEpZ/oNpd2QlBBjXmhr9EicFrpzXbbn3U1pkwdV4T2r3lW2WTbwvFeqO03HSINVu1Ted5YwO0xbYA3gsWa3UMb9UVZBNo4KzHhLOotbOLNV1Hawf/Z/e6CJU00NtpJUrZCJMRYxDc4u1t/Bj94cV9u2s1iF5/Gd7vW31AHB3yiJV9iu1bUCb9LRo7RVMvCtiXqfftH30xqZoSOLNMYr4GwPIr0/RIffHNrK0DHJaxaKwzBJQk0AUJra4eVko+j+Rd3Yruav1hAmEadxYNfjy9yG4jsrrl6gWeHLqxK2SYs4b61RGeLsCug8dyL9orId6e7ascMipD0MwA04Rx9T8eF0fY6ADT6RZLydMXMffABtIzMEm3y8wG5hs46z/wFtvliK8AViu7goxfdICWdA2Qe+vma+S+MtALGClazQZKDedm7Yn6/DUvHuoIyxDYkYMCCgUW1BQBrCRpL0p4tcjX1v6zNA9FPKhw7r7aTCyR8jAkzzthdGeCBxv+TLXWc4/IQ+SD7MW4OKwdk4UCPLuamlOfEebL/M3F/pDS0aN5q8CY/oF2gw4V8CfKNPzepthODFjH+KUidRs7uS5s3DS85wVVPoeuEwDJ6UhNm2ex9zGesy+Uy/XqQWmN0FLE1RFnWJOw1p470vi1h1r4DoG6YN/I56WI+gzCI6f0HInG2hXOmOc7+UnHfL/J3X/dvv9VNKCCioj0Azy5fY06aqbwVSRcs9jTPL6Zg3Cp8Nu812sjWBQoKFZomkDs/EmWWgOwsHYXLq3AXO2Odn2TwP3FNxFDAhUh75Z62f7c8EFQWxfe8mLkBC7hc/7AwoKUDnKqQTW/NjJPdQlDFkIOol/2wpJlU9k3r3c2DVIyPtu52xXSJHxd2fdutMR
 xvSmH8Xl
 eZED3SG5pJWBSMAxOpN+06Gz1dNXxS4ABiAI2LIH4+5/dMSUnDLk+Ec0g/lR7PRKz/r201xYAHGa15QtSYotxgJhyRv2zrhEhpEMRsqH62rfpXRr6CYfBnYcW31P9YcxvsPCSL8oZIjipBm7Ej9YSN7KUD2KcI6yhRq8o5tK8PhozDXK5F3ZAfBKmUudagyBQkRRZC5WswIoJUyH7SvFHzkQQb35yPquTSpiI7iQglEdjLLhnV5nvCyEdrZ7a8WAkYB26XC1trpcBjG4KaeB0IhrS6pke36qs+o4cUv7EGHyzwWHXnRmr3g7AsR6HwFStCTyimZ6whEfScTxshh13jEHhet/9LjLWn/z5+6Yt+xmJr78H54UhBNRfJVz2F77FHRAnCq1Qb6zowukKVEaE9p4fYujWmWsBjY9ZrZweO0EjYd0+gTCPE2Q1BNngCVgCxQe2Ah9IHOEpAXv795aSyguOG2WZ/nrOIGUtte/VbPMAFw7kvtLv/jHnBEfhTgzNLkADKuZFxO+x+EAXwg1a1VAG+tiORjFQy9JOGFntg7YAdMHH36MaFegTcJKqa+qR/nvH1AMqQFJq1GDdJ6Y7H93BJR5bohoAf0o2RpIhARDjuMKV99Dhcq7hwuvbtLqKnxDj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On our production fleet, we saw mem_cgroup_sk_charge() spent over
3x the cycles of try_charge_memcg() although the former should be
a thin wrapper of the latter.

Looking at perf during tcp_rr, most of the cycles were spent in
mod_memcg_state(MEMCG_SOCK), which incurred two heavy memory stalls
due to cache line misses:

  mem_cgroup_sk_charge  vmlinux [Percent: local period]
  ...
     1.74 =E2=94=82       mov     cpu_number,%esi
     0.70 =E2=94=82       movslq  %ebx,%rcx
     0.31 =E2=94=82       mov     0x518(%r14),%rdx
     8.99 =E2=94=82       add     %rcx,%gs:0x18(%rdx,%rax,8)
                  ^-- this_cpu_add(memcg->vmstats_percpu->state[i], val);
                      in mod_memcg_state()
 >> 31.21 =E2=94=82       test    %ebx,%ebx
     0.05 =E2=94=82     =E2=86=93 je      97
          =E2=94=82       mov     %r14,%rdi
          =E2=94=82     =E2=86=92 call    __css_rstat_updated
     0.31 =E2=94=82       mov     0x518(%r14),%rdx
          =E2=94=82 72:   test    %rdx,%rdx
     0.06 =E2=94=82     =E2=86=93 je      97
          =E2=94=82       mov     this_cpu_off,%rsi
     0.17 =E2=94=82       mov     0x10(%rsi,%rdx,1),%rax
     6.59 =E2=94=82       mov     0xc18(%rax),%eax
                  ^-- atomic_read(&vmstats->stats_updates)
                      in memcg_vmstats_needs_flush()
 >> 26.02 =E2=94=82       mov     __num_online_cpus,%ecx
 ...
     0.65 =E2=94=82 e5:   mov     %r14,%rdi
          =E2=94=82       mov     %edx,%esi
     1.88 =E2=94=82       mov     %ebx,%edx
          =E2=94=82     =E2=86=92 call    try_charge_memcg
     1.56 =E2=94=82       xor     %ebp,%ebp
     0.18 =E2=94=82       test    %eax,%eax
     0.22 =E2=94=82     =E2=86=91 jne     9f
          =E2=94=82     =E2=86=91 jmp     31

Even worse, after the 2nd cache line miss, the subsequent
atomic_add() for statc->vmstats->stats_updates invalidates the
cache for other CPUs.

Moreover, try_charge_memcg() returned just after consume_stock()
in most cases, but it was not inlined even with FDO.

Usually, skb is charged and uncharged immediately, and caching
the counter in struct memcg_stock_pcp helps.

Let's reduce NR_MEMCG_STOCK from 7 to 6 to fit nr_sock[] in the
single cacheline of struct memcg_stock_pcp, inline the fast path
of consume_stock(), and batch mod_memcg_state() for MEMCG_SOCK
(-64, 64).

With this change, tcp_rr w/ 10000 flows achieves ~29% more
throughput with lower latency on machine w/ AMD EPYC 7B12 64-Core
Processor (Zen 2 Rome, 2 sockets, 256 vCPU), and the TCP stack
spends far fewer cycles on memcg.

  tcp_rr (10000 flows, 128 threads, 60s, average of 3 runs):

  Metric                     |       Baseline |        Patched |    Diff
  ---------------------------+----------------+----------------+--------
  Throughput (RPS)           |     20,884,499 |     26,960,730 | +29.09%
  Latency Mean (us)          |         478.46 |         370.50 | -22.56%
  Latency p50 (us)           |         453.96 |         361.80 | -20.30%
  Latency p90 (us)           |         669.00 |         482.98 | -27.81%
  Latency p99 (us)           |         969.38 |         622.92 | -35.74%

  perf cycles (10000 flows, 10s, average of 3 runs):

  Server (M cycles / %)      |           Baseline |            Patched |   =
 Diff
  ---------------------------+--------------------+--------------------+---=
-----
  Host Total Cycles          |        4,566,914 M |        4,575,636 M |   =
+0.2%
  tcp_rcv_established()      | 158,009 M (3.460%) | 152,520 M (3.333%) |   =
-3.5%
  mem_cgroup_sk_charge()     |  18,420 M (0.403%) |   7,474 M (0.163%) |  -=
59.4%
  mem_cgroup_sk_uncharge()   |  16,593 M (0.363%) |   8,541 M (0.187%) |  -=
48.5%
  __css_rstat_updated()      |   3,502 M (0.077%) |       0 M (0.000%) | -1=
00.0%
  Memcg Sock Total           |  38,515 M (0.843%) |  16,015 M (0.350%) |  -=
58.4%

As a side effect, "sock" in memory.stat can be off by up to
MEMCG_CHARGE_BATCH pages per CPU until the slot is drained,
like memory.current with nr_pages[].  This is acceptable, as
flushing nr_sock[] every 2 seconds (FLUSH_TIME) across all CPUs
would rather cause cache line invalidation and hurt performance.

Note that MEMCG_CHARGE_BATCH is unsigned int, so (int) cast is
needed, and stock_sock is declared as int rather than int8_t
to avoid potential overflow for MEMCG_CHARGE_BATCH > 64 and to
generate better asm without 8-bit partial-register operations
or extra sign-extension before mod_memcg_state().

Also, __always_inline is needed for both __consume_stock() and
__refill_stock(), otherwise, FDO branch weight is calculated
from two callers with mixed states (nr_sock =3D=3D 0 vs nr_sock !=3D 0).

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
v2
  * Benchmark again after rebase and update numbers
  * Check in_nmi() in __refill_stock()
---
 mm/memcontrol.c | 85 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 74 insertions(+), 11 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a04b44656b38..b92e952c076a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2065,9 +2065,9 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *me=
mcg)
=20
 /*
  * The value of NR_MEMCG_STOCK is selected to keep the cached memcgs and t=
heir
- * nr_pages in a single cacheline. This may change in future.
+ * nr_pages and nr_sock in a single cacheline. This may change in future.
  */
-#define NR_MEMCG_STOCK 7
+#define NR_MEMCG_STOCK 6
=20
 /*
  * Watermarks for a charge stock slot, in the spirit of pcp->high and
@@ -2081,6 +2081,7 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *me=
mcg)
 struct memcg_stock_pcp {
 	local_trylock_t lock;
 	uint8_t nr_pages[NR_MEMCG_STOCK];
+	int8_t nr_sock[NR_MEMCG_STOCK];
 	struct mem_cgroup *cached[NR_MEMCG_STOCK];
=20
 	struct work_struct work;
@@ -2140,9 +2141,10 @@ static bool obj_stock_flush_required(struct obj_stoc=
k_pcp *stock,
 				     struct mem_cgroup *root_memcg);
=20
 /**
- * consume_stock: Try to consume stocked charge on this cpu.
+ * __consume_stock: Try to consume stocked charge on this cpu.
  * @memcg: memcg to consume from.
  * @nr_pages: how many pages to charge.
+ * @nr_sock: how many pages to account for MEMCG_SOCK.
  *
  * Consume the cached charge if enough nr_pages are present otherwise retu=
rn
  * failure. Also return failure for charge request larger than
@@ -2150,10 +2152,13 @@ static bool obj_stock_flush_required(struct obj_sto=
ck_pcp *stock,
  *
  * returns true if successful, false otherwise.
  */
-static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
+static __always_inline bool __consume_stock(struct mem_cgroup *memcg,
+					    unsigned int nr_pages,
+					    unsigned int nr_sock)
 {
 	struct memcg_stock_pcp *stock;
 	uint8_t stock_pages;
+	int stock_sock =3D 0;
 	bool ret =3D false;
 	int i;
=20
@@ -2173,7 +2178,19 @@ static bool consume_stock(struct mem_cgroup *memcg, =
unsigned int nr_pages)
=20
 		stock_pages -=3D nr_pages;
 		WRITE_ONCE(stock->nr_pages[i], stock_pages);
-		if (unlikely(!stock_pages)) {
+
+		if (nr_sock) {
+			stock_sock =3D stock->nr_sock[i] + nr_sock;
+
+			if (likely(stock_sock < (int)MEMCG_CHARGE_BATCH)) {
+				WRITE_ONCE(stock->nr_sock[i], stock_sock);
+				stock_sock =3D 0;
+			} else {
+				WRITE_ONCE(stock->nr_sock[i], 0);
+			}
+		}
+
+		if (unlikely(!stock_pages && !stock->nr_sock[i])) {
 			WRITE_ONCE(stock->cached[i], NULL);
 			css_put(&memcg->css);
 		}
@@ -2184,9 +2201,17 @@ static bool consume_stock(struct mem_cgroup *memcg, =
unsigned int nr_pages)
=20
 	local_unlock(&memcg_stock.lock);
=20
+	if (unlikely(stock_sock))
+		mod_memcg_state(memcg, MEMCG_SOCK, stock_sock);
+
 	return ret;
 }
=20
+static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
+{
+	return __consume_stock(memcg, nr_pages, 0);
+}
+
 static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages=
)
 {
 	page_counter_uncharge(&memcg->memory, nr_pages);
@@ -2201,6 +2226,7 @@ static void drain_stock(struct memcg_stock_pcp *stock=
, int i)
 {
 	struct mem_cgroup *old =3D stock->cached[i];
 	uint8_t stock_pages;
+	int stock_sock;
=20
 	if (!old)
 		return;
@@ -2211,6 +2237,12 @@ static void drain_stock(struct memcg_stock_pcp *stoc=
k, int i)
 		WRITE_ONCE(stock->nr_pages[i], 0);
 	}
=20
+	stock_sock =3D stock->nr_sock[i];
+	if (stock_sock) {
+		mod_memcg_state(old, MEMCG_SOCK, stock_sock);
+		WRITE_ONCE(stock->nr_sock[i], 0);
+	}
+
 	WRITE_ONCE(stock->cached[i], NULL);
 	css_put(&old->css);
 }
@@ -2255,12 +2287,15 @@ static void drain_local_obj_stock(struct work_struc=
t *dummy)
 	local_unlock(&obj_stock.lock);
 }
=20
-static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
+static __always_inline void __refill_stock(struct mem_cgroup *memcg,
+					   unsigned int nr_pages,
+					   unsigned int nr_sock)
 {
 	struct memcg_stock_pcp *stock;
 	struct mem_cgroup *cached;
 	unsigned int stock_pages;
 	int empty_slot =3D -1;
+	int stock_sock =3D 0;
 	int i;
=20
 	/*
@@ -2274,13 +2309,15 @@ static void refill_stock(struct mem_cgroup *memcg, =
unsigned int nr_pages)
 	VM_WARN_ON_ONCE(mem_cgroup_is_root(memcg));
=20
 	if (unlikely(nr_pages > MEMCG_CHARGE_BATCH ||
+		     (IS_ENABLED(CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC) &&
+		      in_nmi()) ||
 		     !local_trylock(&memcg_stock.lock))) {
 		/*
 		 * In case of larger than batch refill or unlikely failure to
 		 * lock the percpu memcg_stock.lock, uncharge memcg directly.
 		 */
 		memcg_uncharge(memcg, nr_pages);
-		return;
+		goto update_sock;
 	}
=20
 	stock =3D this_cpu_ptr(&memcg_stock);
@@ -2301,7 +2338,22 @@ static void refill_stock(struct mem_cgroup *memcg, u=
nsigned int nr_pages)
=20
 		WRITE_ONCE(stock->nr_pages[i], stock_pages);
=20
+		if (nr_sock) {
+			stock_sock =3D stock->nr_sock[i] - nr_sock;
+
+			if (likely(stock_sock > -(int)MEMCG_CHARGE_BATCH)) {
+				WRITE_ONCE(stock->nr_sock[i], stock_sock);
+				stock_sock =3D 0;
+			} else {
+				WRITE_ONCE(stock->nr_sock[i], 0);
+			}
+		}
+
 		local_unlock(&memcg_stock.lock);
+
+		if (unlikely(stock_sock))
+			mod_memcg_state(memcg, MEMCG_SOCK, stock_sock);
+
 		return;
 	}
=20
@@ -2318,6 +2370,15 @@ static void refill_stock(struct mem_cgroup *memcg, u=
nsigned int nr_pages)
 	WRITE_ONCE(stock->nr_pages[i], nr_pages);
=20
 	local_unlock(&memcg_stock.lock);
+
+update_sock:
+	if (nr_sock)
+		mod_memcg_state(memcg, MEMCG_SOCK, -nr_sock);
+}
+
+static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
+{
+	__refill_stock(memcg, nr_pages, 0);
 }
=20
 static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
@@ -2333,7 +2394,8 @@ static bool is_memcg_drain_needed(struct memcg_stock_=
pcp *stock,
 		if (!memcg)
 			continue;
=20
-		if (READ_ONCE(stock->nr_pages[i]) &&
+		if ((READ_ONCE(stock->nr_pages[i]) ||
+		     READ_ONCE(stock->nr_sock[i])) &&
 		    mem_cgroup_is_descendant(memcg, root_memcg)) {
 			flush =3D true;
 			break;
@@ -5798,6 +5860,9 @@ bool mem_cgroup_sk_charge(const struct sock *sk, unsi=
gned int nr_pages,
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return memcg1_charge_skmem(memcg, nr_pages, gfp_mask);
=20
+	if (likely(__consume_stock(memcg, nr_pages, nr_pages)))
+		return true;
+
 	if (try_charge_memcg(memcg, gfp_mask, nr_pages) =3D=3D 0) {
 		mod_memcg_state(memcg, MEMCG_SOCK, nr_pages);
 		return true;
@@ -5820,9 +5885,7 @@ void mem_cgroup_sk_uncharge(const struct sock *sk, un=
signed int nr_pages)
 		return;
 	}
=20
-	mod_memcg_state(memcg, MEMCG_SOCK, -nr_pages);
-
-	refill_stock(memcg, nr_pages);
+	__refill_stock(memcg, nr_pages, nr_pages);
 }
=20
 void mem_cgroup_flush_workqueue(void)
--=20
2.56.0.313.g2479322e68-goog


