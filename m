Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC953CC6B2D
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 05:28:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B40376B0088; Fri, 16 Oct 2026 01:28:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC9B96B008A; Fri, 16 Oct 2026 01:28:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 991FF6B008C; Fri, 16 Oct 2026 01:28:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 621BE6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 01:28:18 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BDC99402F9
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 05:28:17 +0000 (UTC)
X-FDA: 85327358634.06.A979420
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by imf02.hostedemail.com (Postfix) with ESMTP id F124C80006
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 05:28:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QkOZki4z;
	spf=pass (imf02.hostedemail.com: domain of 37rXRagYKCP0pzsn3zlttlqj.htrqnsz2-rrp0fhp.twl@flex--kuniyu.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=37rXRagYKCP0pzsn3zlttlqj.htrqnsz2-rrp0fhp.twl@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792128496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=M4ahsKpEByLpjYwM5E8QdP6uFfaxDfM+kbphj7puBv0=;
	b=QdaFp2VSrrUOCknDD0e9lZdgL4KMXKecTT8fZdPxV7NVarlcohIMRkyw59AKa94en8K1Kh
	xtihCcIpbBzAvkLa8nHmoZrF5IxD9kXquMOKhuv7x9NARyW28aCRVBR8NTZo019viFujjf
	SSGRt7qiuuJSa+EBm4Xtkuj/7rgaeV0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QkOZki4z;
	spf=pass (imf02.hostedemail.com: domain of 37rXRagYKCP0pzsn3zlttlqj.htrqnsz2-rrp0fhp.twl@flex--kuniyu.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=37rXRagYKCP0pzsn3zlttlqj.htrqnsz2-rrp0fhp.twl@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792128496;
	b=zvJl244lbFZQSRs2xf80oHP9v72tmuU6HM7CWl3k/reeQqLo4Q/jkNRTv6oxcYC+bL3rea
	pMwL1ecEFkDbXozEDxX6/9H8JRqPKrP7GwoWlmdWbivnSjr5k2osjQAFntChTm02Z5Dlem
	U8xJcTRAJsqDt+QzjIqt3Rjyh21SBJE=
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-887c99013edso1779539b3a.3
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792128495; x=1792733295; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=M4ahsKpEByLpjYwM5E8QdP6uFfaxDfM+kbphj7puBv0=;
        b=QkOZki4zWrm2b7KjZedjMfWmG6s0rzcjwtKBXkPvoZvuM64IxrkByoTTUlnHumt58i
         Gi0lb24hyi3OGiPZ+/qtRVT//oPVRcPXbKBxtRSZa9mUpICOSCgPewYw6c3YqG+PLtMX
         NoXsM0swgrM0zQb7CqA1Z4r4GwEWaNLlmNyV1tlljz8KJaAr4WYFmUupJs+z7C6gLeut
         Hu/hZCQ5oiRxHHb/ftOvsTiM0rorWVL80ltCBKfoZe3EgFV6NoJ8kHCp8JXREztzRkOM
         boZtu3PjbNjovwEpv5oz2UUwKO4F0MNivpVj6/ShcEYhh24FHwdhuvqtaIIM2QJqLvKR
         2qbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792128495; x=1792733295;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=M4ahsKpEByLpjYwM5E8QdP6uFfaxDfM+kbphj7puBv0=;
        b=cHy8GBUz+Tzrvpp0JOQyomSfUm6g0hHFioOBBRpoOc4o4iXbQZy2de+WVtD/YCUUur
         U/5jDbpPw9WVwvTiHHBCFI6yQeYLj7E05MQEmgD5lSBBP5Ehvid0ms4b91JkhwLr9xGB
         1h1a6uDTo32SizKznniwb25PQIJpXNCZqV1Ybogx1fGgob+LB6yzEnBki/s04IAZR1jN
         uP1PZ+HrolWxtxAZlupjMTiVUIImm7s4Jpt9BbKbz+bgtQQGsWbxqby3t6Xdz1EAhSOn
         ERsHuAgONd2mImxLJcqHHFv/OlWgLXHkVBPag9iJ2DrgIWwFgJN6f5gAoEpisF7yBac1
         f8YA==
X-Forwarded-Encrypted: i=1; AKwUvBzFX/3kSylgSI0vBLg0Z0XP3cIyMoX8uVOVewsLAxJj6iOlqeM5QoJ7G8lEMDEdqHvD2kdOtvwjEA==@kvack.org
X-Gm-Message-State: AFq9FYIulFwWjWSlh5M+hMzWuLzgf4BP+Or77GllR1liax0/EWJs54xS
	dxX0P6WXNVJBvGyeuOCXefUJjj6fQdmEliXcWphvmcUE2PD+VeZql4ymPiAX41IbOC3SYP9g85S
	XRo45nA==
X-Received: from pfbcl10.prod.google.com ([2002:a05:6a00:32ca:b0:89d:8f0c:4f51])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:188c:b0:886:cae0:fb66
 with SMTP id d2e1a72fcca58-897c71084a7mr20396628b3a.16.1792128494333; Thu, 15
 Oct 2026 22:28:14 -0700 (PDT)
Date: Fri, 16 Oct 2026 05:27:44 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261016052811.3085635-1-kuniyu@google.com>
Subject: [PATCH 0/5] memcg: Batch mod_memcg_state() for MEMCG_SOCK.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F124C80006
X-Rspam-User: 
X-Stat-Signature: pb98m6djdh9e71bnq5m4jr17qf15hytq
X-HE-Tag: 1792128495-791213
X-HE-Meta: U2FsdGVkX1+E75AQ+jJT0Z6rK8F4wY3pyEHP3e4zfzqUMxGgSsNAeTSGYfjbJGDkqdavlkEqRFs5CIBNkR9m6zNlHyNzUMtNRse/Z7Cb3xarpQ7NWVQ0m4zlWza07MnGdx43DWoDqheWfAxVJByB4rAcHugYdYqsj5tUy8wTUOGAi9XyI13gq2Dad61Whf0ot78nrGKXXke0JCQtN/h76oo48z1+w0UdfhIhq6I3nAKXaXEXYNlk2EnH8QrzISfF4+HmErlQ7lJPI4BaNDYfk8J5D6JRqxWbnxKfbZO5qetVuv61QomVN4d/Q2943LkvDNszpcqltkeE94suIDgy/B1ywkwYU29TfCHUKbN6XiPcOcGlq4+UQirVBjLSAvjZNLhtTUYAbJzsWPoJCKHkve1BnMtUC8vzDThOezh66WdbG698dFXPoSiH2mSNWpJ4wtD/y0NW2CkD0LNcLp/l/WsbCCLxPKDSc4B6Lv19MLf16luqdBG/UaBiMykvls8bZYSDU8F/6F1O2LqsL+SAw4V0iP3l8Lbcq9tqQyVKAF9uWeVRJxYeJrGfuih4TKMGC6acpUxjtLEfPQebR6IFByfReiRgkiom7+c1gq4Lg2CtEOaPAkcv+YAUCFcu/gLIW9j6LxXjKN+Y7b51MStlu2fn7iggEHbVOc61+K9/AetAB149VmX0tfM5uU9w3hdRfu8bZdXNvLkLDioQXuyA6Tq2Q1II5cAZnFXNs4KuIKZIZeh0xZhdRBBi3pGFEhfJLeXfCXmP92uAl/dSNrgUMIi6KiRaKgXTH6F0XvUzQeuZKUXaPXs0aSQoDTisviYJp8vzEPMxby9/iXe262vWadxx4sy7Xl8o8TtNNttRFwITF5rNzQwN1wh5hlMqLVkE3iGlSc8PXwz7Id/Q6bQ1wegMYEd/U+TfjkOLj/t740Lf2IDiyxtbWExbES+oNB69PjDVXG44NF9UbPQWFYY
 MVVNayH5
 j7czKCBeKqsTnJCAdUo6McuI/Sww4MXQUrGIkWEbvGDZ9jkkLfU9bEaK2F4OUUyBLpbGULl7Z1qDgxDG5sqxrHC1Ehe1TPqVZ2jxehOHAFqX+vdmpqBrPmkRkVkg1uskayzyeFlLBTlOjwo9qA+vx4XfvMnXjjx9p6yJItWUJT7s5mn+8/W75MHu2z+vgfGkmGiMR0ZgzbGeFXAx7bUXOe+Dc/jfI9Hw37rA9FmvckEwMd0h2HB0rR+HkJxcUc6FKo76mVaCAT8IxCriTatsziIhcMjFcrXLJoCrI7PbZ0SCbt99g+WkJXdznKdByHPyuc7TxI1WQnkh7ntveaIyTL6QVanBdhJHF6tiFdiso4mXgux+/ve3Jq+GfOGNJOagPJpQbRfIM+VDnLKTn8ufk+JAlxpqbv9C3m030o4z2IY/kL3z1BNLQ35VKmhoRvf3+6/oA5tXTSiRXYcUbdgTmnEmS87kkoO1XVj/0VcUuBTZdOsUpQlWJ1faGX77S1P4EvJHWCR//JQe0irKZaWoklcP+mYYNUtY2tPE2DudjChXmxzIOWAq+MzjskEGAK4rSqOf1fN9MkpvVZLrsBmkBBD6xu7p/oe0w/gVJNQ60FtTFQm6uqOamQSqin0Gbtff8QyEt
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

This series adds nr_sock[] to struct memcg_stock_pcp to batch
mod_memcg_state() for MEMCG_SOCK.

With this change, tcp_rr w/ 20000 flows achieves ~9% more
throughput and the TCP stack spends far fewer cycles on memcg.

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


Kuniyuki Iwashima (5):
  memcg: Remove unnecessary READ_ONCE() under memcg_stock.lock.
  memcg: Reduce nesting in consume_stock() and refill_stock().
  memcg: Annotate slow paths in consume_stock() and refill_stock().
  memcg: Batch mod_memcg_state() for MEMCG_SOCK.
  selftests: cgroup: Deflake test_memcg_sock() in test_memcontrol.c.

 mm/memcontrol.c                               | 155 +++++++++++++-----
 .../selftests/cgroup/test_memcontrol.c        |   9 +-
 2 files changed, 118 insertions(+), 46 deletions(-)

--=20
2.56.0.212.g129ede20d9-goog


