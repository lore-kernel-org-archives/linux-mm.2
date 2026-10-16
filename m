Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ACBFCC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 05:28:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D632B6B0092; Fri, 16 Oct 2026 01:28:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEF7B6B0098; Fri, 16 Oct 2026 01:28:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF05B6B0092; Fri, 16 Oct 2026 01:28:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D92A6B0095
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 01:28:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C29051C3099
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 05:28:20 +0000 (UTC)
X-FDA: 85327358760.23.026A744
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by imf14.hostedemail.com (Postfix) with ESMTP id 09068100007
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 05:28:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="kP/rVzZb";
	spf=pass (imf14.hostedemail.com: domain of 38bXRagYKCAImwpk0wiqqing.eqonkpwz-oomxcem.qti@flex--kuniyu.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=38bXRagYKCAImwpk0wiqqing.eqonkpwz-oomxcem.qti@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792128499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gCK0TeJ6d1zzXk3Slxk1+vePgTXc6/apx1KzOf+3M8E=;
	b=zvyeVlHzNSYTeIQ5yLHKRu0cd5FtyMS1jMkRUYRFTGjTRQr8e+JXbloMRJPI60xB1e5cjn
	OKxqVo1avaryHQkJH0XyW3tOmPPKzjRtvUN5FTwg3YuJjoSGyn/zxgQI7aIt1Nu/3DRP/s
	tbYx/rDI0RxT9R/YbZkS5jaIuEUcjrg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792128499;
	b=PKBhOepPxmHtukDjf7Npz/AzzF9p8+MNJmEPjKss/IBMMEyPgtEjDaZPDAls9JX0GI9ymA
	ZTKv28nQ2IbCuQ49/q/5vafGV2pwW7gedgrEiFqqgZ5qY34SVU3dwIxN4w9v40sNC0HO77
	6lXsytiMxeW8nx5wJQ32hZwxAQvg/7s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="kP/rVzZb";
	spf=pass (imf14.hostedemail.com: domain of 38bXRagYKCAImwpk0wiqqing.eqonkpwz-oomxcem.qti@flex--kuniyu.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=38bXRagYKCAImwpk0wiqqing.eqonkpwz-oomxcem.qti@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-886129276ccso3194756b3a.2
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792128498; x=1792733298; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=gCK0TeJ6d1zzXk3Slxk1+vePgTXc6/apx1KzOf+3M8E=;
        b=kP/rVzZbj57KoziwRQceKuJ4LT8wYS3FElOq03HVsj6yhO14knRjB1QH1HGYX6VTXH
         B1EIKAkC5CVfzjdavoz+ExGlbzpDB/hCVi/27hBiPNZiWRIZP9vUcDd6TiS0i3LbU2wc
         7s/MUUVMWBK/e82Qjaltm5jUVtkaTtk8LN0xRScq1L0bSL2DbmdV5LQXUlYKMdUeU5Fk
         Xxx/oAyHL5EZtH9a6dCL+FUjpPyKxit/2z3Ck87NhS/1DBBOhb7f54c2PiMO5WnCnebP
         D8G/Qoxjyd7IXFKmo0/C4p2mk6mfowmnW7zURG6tA3vJwuVlzDRvgp+wCmYt0PIGPm9S
         53WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792128498; x=1792733298;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gCK0TeJ6d1zzXk3Slxk1+vePgTXc6/apx1KzOf+3M8E=;
        b=edxopMPi4ZjUMwKi4tzbvNihJ03rpA97mIvmIZuoIGDE1CY6xhsBFXY+az3EgWhMFm
         4cYVTyEFjVesjJmFXHA18lj67bcNNt4dCQPo7z3CZUsqPExFh446V+tlXOGbccFJJ3X8
         zXAO30BoxWECa+P1+pn71H2tADUlQe2cKD3hlTUYNQzpxL2iXE2VxB7l1bxiVoJjQQEU
         mAdZR/d6g7V+i6EaYZXR9i/YW32MhHJmSdSJpwzHg2Hjw1I1LGHJaoD30OERrqhWo6Ks
         uDauiGO0btRNrsCQw2lMU4kQgTWQLkpx6IXuY4cERTL5s6n5eJDkdWUXvE6R3CGtIX0Z
         Uiqg==
X-Forwarded-Encrypted: i=1; AKwUvBxR+uqGzCTpavI6MCeYTGp+hIWTob3WcqPmxEEEy5Roz9xeADew6cxjJt1kWBQQ/L9XI++SlEYjAA==@kvack.org
X-Gm-Message-State: AFq9FYKjNL+fzUGBgOlY2Bku7n0Lx09ze4+W71ysnihgTiatnr2qOlVa
	Y+S3EMEglpWSp21HAENy/0GrqB98vHBYcAMm8thnJyOi0QKqB2cQW5lhfH+Q61+7v8IiECE4f3T
	oiI+YSA==
X-Received: from pfeu12-n1.prod.google.com ([2002:a05:6a00:c0cc:10b0:88d:74fb:fa56])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3004:b0:87c:f67f:f7d3
 with SMTP id d2e1a72fcca58-897c14ead54mr15295762b3a.0.1792128497673; Thu, 15
 Oct 2026 22:28:17 -0700 (PDT)
Date: Fri, 16 Oct 2026 05:27:48 +0000
In-Reply-To: <20261016052811.3085635-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20261016052811.3085635-1-kuniyu@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261016052811.3085635-5-kuniyu@google.com>
Subject: [PATCH 4/5] memcg: Batch mod_memcg_state() for MEMCG_SOCK.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 09068100007
X-Stat-Signature: 9uamzpkpdoxkpgpkc5e3ffcxse34b4xn
X-HE-Tag: 1792128498-314437
X-HE-Meta: U2FsdGVkX18J0/oGdsgzv9aefepqhlltmOXyMjmDD9gTCLJTBHL+jNXUSJly3Zj5pypi4y28VBARUxwdxiKQn3gmbGnitAAMNzv++5mIi/WBarnLgMSIi/7+asf8dYOAm4gyYOPSV7cq6Q9z7srJraf/eHbL913NprbCMQ2345kXA9f+weSEt9F4AzIMipEbVEnHyB3tjaN/dvAedORyP8PJSXLns5JHLxiQ6MnS/WpDDah2JNKIsVXhje/ReNv6D+kX45prqiIKMlM5Otm62pGafhVAvqb8bH2vv7BcUCrQqBZKnSsFVYBbFfTsDIpHy1GWkwsxeI/l6QSZaMUoUuVzJZkh9kIFEwUdKVIY/gf47JPsQEmphN72RtAzfgzPJJIULSwoQa8hP1Rx0ZPoTF6hVkEYIL7RevdAJnPhs+Ezbaji//rWaJcYYogjTXIAA94utpq6b1e4kwC/NVYuUTe3CXmvp20I7HeSLiAt7S3K5GkfPvDTHImgV5NqJIupfasqSZuE5s8G1wBZ/sB/nxDr/BGS8/wQlV/txvQfnHZgAFb2aIIzGdsSgPLhBsd0+5kWYexJNdVSFwewuDmIIiZ5cbxwzg6M4JWy8GSAGRHPYQy3ZObVG0AN8OIshjPTOVDq8C9RG3fd7hzPiU52x7Rz1ocRhdPjpz6PTqtN+ePHfF/MEmG9hVy6gaA5SX//Yn7M//wMj/MD+wzQZU5ve9OYkrw3RwZxwRmjVksw2qtgxuxebSmSyQCXOLodl9kTwHf3E+L9VqM6Hy5bO+OTeq+0C6XZp9x6py/hs9ke5+yYJe6yltz+il5w7junawAzUjY/fnDn0ubCJT66kpsn7u8sC3ZoiW5807UO2vUtaMlT0oJTA0juOFX3LEaSYtmNh9rvM1iJYmTw6MuzL+0pgcebWW3HmM88YXHHqI7I8fqZhZN0HDd9uYRpCGPgWlb2KcWU77ji3LSP4s8kwvJ
 sIHDqkQz
 TdiWbew0Va1rDEG8bXtMkcF3svZJ+nSr5/rLdsGcKTSdJ9vsKWUzPeN6Et226ygT6KtHj9Bi1ULaPKnBj8qCKLBAgkvd9gzHetpkJI9kryuFzottLUPX/rE9FZn5HMou2tQdYprEuLUf5ILzleFUmAEbAYv7suDQQIWALobHXlaseevtu+sqIZw/wcqymubP3HtfrDTs4BUpJiHjtgKM8gRWHLoyH/zH+MzT5bJHXTqag4o1HY7jUco4q352ZUsp9eLTlsDKzGZ2uPVXxTDen3sNT3BY/epEzB8ZPK2M3gYXncrd13tCdGeJIix8p3KqQuOSrn4sp86nJ+3bd5ESL5Xy7RibpU+ecPRLB4O+DfWdII7ql4EiLfq1JXP28TgpC1XMbWhGWFF1gh0fNE0VzT1SCDLHqESR7Sx5/UasVlHiNrPNaLhYHhQOKwCFz6Ib0wX2y7QnRHk6o+ZfbATXBgrCCJngrcqhVrKX41jhCrLQBPjEWoc+wxCky03pADUh7xXeSNj1mHDiukPphxE7l7kteuzoID82NmywUTPaJtiOBnqbPiyRrom5NKwW42Efli2uR0q/2TiCHN2uHcUqvfBOVXo8LynvZ8vhaLnU8YOYDz2ZJHJpA0cBjHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
single cacheline of struct memcg_stock_pcp, inline the stock
fast path, and batch mod_memcg_state() for MEMCG_SOCK (-64, 64).

With this change, tcp_rr w/ 20000 flows achieves ~9% more
throughput and the TCP stack spends far fewer cycles on memcg.
Note that p90 latency improves only slightly because batching
amortises mod_memcg_state() and drain_stock() into every 64th
page.

  tcp_rr (20000 flows, 128 threads, 60s, average of 3 runs):

  Metric                     |       Baseline |        Patched |    Diff
  ---------------------------+----------------+----------------+--------
  Throughput (RPS)           |     22,408,523 |     24,360,262 |  +8.71%
  Latency Mean (us)          |         891.92 |         820.31 |  -8.03%
  Latency p50 (us)           |         877.22 |         744.10 | -15.18%
  Latency p90 (us)           |       1,085.43 |       1,082.02 |  -0.31%

  perf cycles (20000 flows, 10s, average of 3 runs):

  Server (M cycles / %)      |           Baseline |            Patched |   =
 Diff
  ---------------------------+--------------------+--------------------+---=
-----
  Host Total Cycles          |        4,994,342 M |        4,793,242 M |   =
-4.0%
  tcp_rcv_established()      | 213,968 M (4.283%) | 210,418 M (4.390%) |   =
-1.7%
  mem_cgroup_sk_charge()     |  12,322 M (0.247%) |   6,390 M (0.133%) |  -=
48.1%
  try_charge_memcg()         |   8,326 M (0.167%) |       0 M (0.000%) | -1=
00.0%
  mem_cgroup_sk_uncharge()   |   7,492 M (0.150%) |   5,752 M (0.120%) |  -=
23.2%
  refill_stock()             |   7,988 M (0.160%) |       0 M (0.000%) | -1=
00.0%
  Charge Total               |  20,648 M (0.413%) |   6,390 M (0.133%) |  -=
69.1%
  Uncharge Total             |  15,480 M (0.310%) |   5,752 M (0.120%) |  -=
62.8%
  Memcg Sock Total           |  36,128 M (0.723%) |  12,142 M (0.253%) |  -=
66.4%

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
 mm/memcontrol.c | 84 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 73 insertions(+), 11 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index cc3d78938b34..52831ae7fd0f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2045,13 +2045,14 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *=
memcg)
=20
 /*
  * The value of NR_MEMCG_STOCK is selected to keep the cached memcgs and t=
heir
- * nr_pages in a single cacheline. This may change in future.
+ * nr_pages and nr_sock in a single cacheline. This may change in future.
  */
-#define NR_MEMCG_STOCK 7
+#define NR_MEMCG_STOCK 6
 #define FLUSHING_CACHED_CHARGE	0
 struct memcg_stock_pcp {
 	local_trylock_t lock;
 	uint8_t nr_pages[NR_MEMCG_STOCK];
+	int8_t nr_sock[NR_MEMCG_STOCK];
 	struct mem_cgroup *cached[NR_MEMCG_STOCK];
=20
 	struct work_struct work;
@@ -2111,9 +2112,10 @@ static bool obj_stock_flush_required(struct obj_stoc=
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
@@ -2121,10 +2123,13 @@ static bool obj_stock_flush_required(struct obj_sto=
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
@@ -2144,7 +2149,19 @@ static bool consume_stock(struct mem_cgroup *memcg, =
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
 			css_put(&memcg->css);
 			WRITE_ONCE(stock->cached[i], NULL);
 		}
@@ -2155,9 +2172,17 @@ static bool consume_stock(struct mem_cgroup *memcg, =
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
@@ -2172,6 +2197,7 @@ static void drain_stock(struct memcg_stock_pcp *stock=
, int i)
 {
 	struct mem_cgroup *old =3D stock->cached[i];
 	uint8_t stock_pages;
+	int stock_sock;
=20
 	if (!old)
 		return;
@@ -2182,6 +2208,12 @@ static void drain_stock(struct memcg_stock_pcp *stoc=
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
 	css_put(&old->css);
 	WRITE_ONCE(stock->cached[i], NULL);
 }
@@ -2226,12 +2258,15 @@ static void drain_local_obj_stock(struct work_struc=
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
 	uint8_t stock_pages;
 	int empty_slot =3D -1;
+	int stock_sock =3D 0;
 	int i;
=20
 	/*
@@ -2250,7 +2285,7 @@ static void refill_stock(struct mem_cgroup *memcg, un=
signed int nr_pages)
 		 * lock the percpu memcg_stock.lock, uncharge memcg directly.
 		 */
 		memcg_uncharge(memcg, nr_pages);
-		return;
+		goto update_sock;
 	}
=20
 	stock =3D this_cpu_ptr(&memcg_stock);
@@ -2264,10 +2299,26 @@ static void refill_stock(struct mem_cgroup *memcg, =
unsigned int nr_pages)
=20
 		stock_pages =3D stock->nr_pages[i] + nr_pages;
 		WRITE_ONCE(stock->nr_pages[i], stock_pages);
+
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
 		if (unlikely(stock_pages > MEMCG_CHARGE_BATCH))
 			drain_stock(stock, i);
=20
 		local_unlock(&memcg_stock.lock);
+
+		if (unlikely(stock_sock))
+			mod_memcg_state(memcg, MEMCG_SOCK, stock_sock);
+
 		return;
 	}
=20
@@ -2284,6 +2335,15 @@ static void refill_stock(struct mem_cgroup *memcg, u=
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
@@ -2299,7 +2359,8 @@ static bool is_memcg_drain_needed(struct memcg_stock_=
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
@@ -5629,6 +5690,9 @@ bool mem_cgroup_sk_charge(const struct sock *sk, unsi=
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
@@ -5651,9 +5715,7 @@ void mem_cgroup_sk_uncharge(const struct sock *sk, un=
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
2.56.0.212.g129ede20d9-goog


