Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DAAF606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 19:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=T4lXIsnx
Received: by kanga.kvack.org (Postfix)
	id E8CD86B05B3; Thu, 29 Oct 2026 15:44:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E63FE6B05B4; Thu, 29 Oct 2026 15:44:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA1776B05B5; Thu, 29 Oct 2026 15:44:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 996596B05B3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:44:57 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0275E80181
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:44:56 +0000 (UTC)
X-FDA: 85376691834.13.68858F7
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf29.hostedemail.com (Postfix) with ESMTP id 57A5D12000A
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:44:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=T4lXIsnx;
	spf=pass (imf29.hostedemail.com: domain of 3NqLjagYKCGcPZSNdZLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--kuniyu.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3NqLjagYKCGcPZSNdZLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793303095;
	b=PxzqQf8P7JRHcq2A63qvEcUH7fk8VDf0xW/qIn7vrQiiba4mj9dIRP8R+4djnMksg9vPx/
	MqFe4aOM756a1Iim91w4aVcMNH+1EZiv1G9V3k6ilAQD4IE+I1nzY9qL4zVwK2vxT0AMlU
	cYR+SKuIejvJKMKlqY0/I40WTY4vvl8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=T4lXIsnx;
	spf=pass (imf29.hostedemail.com: domain of 3NqLjagYKCGcPZSNdZLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--kuniyu.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3NqLjagYKCGcPZSNdZLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793303095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xzpdASVHedhqOKgMw1KD3RU+Tfm1fLmwQdc26sVHTJY=;
	b=C1EcV+Zl2qTzGbhgTEbAXLjj/F/z3NZvkyDCQzzsch3D4SASW/4TJcYgC7zTMoDazmW+Mx
	10QDnksK3m/8jYPfDf2G3FBCvfPPNY1964OsZf/o7JffSg21i8B/Oue+L9vNqYRI1rJZn3
	CFoBcb6Cuxlu//EyjKq1wRKIFGWAYLk=
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3adeba76cadso1780234a91.1
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793303094; x=1793907894; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xzpdASVHedhqOKgMw1KD3RU+Tfm1fLmwQdc26sVHTJY=;
        b=T4lXIsnxlrBYGjFmV8GpPoLGPvAphkHU8GufEQXILQHarGYcZ2CfiQQH4pVpLztMaw
         PD+SD+QiNjjZ/hSxUGKIHFySdIj6zUAnoMUKjzEJdGqU1Gi6w1M3QkzPC041SWGvbDKF
         KTH2ml8HCIIKKzwQtlKPyqx/ZfKLDDfO8/m+fU7wmte8TAGOONIIQgpcJupu3o9RVCHe
         T19rFmIFtQrxrQumZjoYwFfs4kDES3QrzxRmSRzeKZPsO2Ledzxa/H5eSKis2IRINLaK
         Fa+gJa7LJ6Zdrm8rJiF34qsvaKIGsm9bP3dCJ5UZOlG2I7tNTlIUPVs1pBLga4qVtZMs
         1TBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793303094; x=1793907894;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xzpdASVHedhqOKgMw1KD3RU+Tfm1fLmwQdc26sVHTJY=;
        b=PhUIWQ6R3lhYITaPRLElFBtIu/UO0FflJtBXwBRkT7fmRPS75gOmB4w8whihEb6p72
         ykuEACggBK8qq2lz8aPYy0p4GoTTJdeOSepfeoYm43kjqALq+Mt3Ytqf/zoEbGbwABb1
         5bsGvI7SRyiAhEePJmk/A6e65eeYICE2gIfeQIS6S+0EMtDi1A95PTEOliRaqYLeez6a
         OBkAK0L3w5Q1unv4JxCxolwhBAAA8mnlvnbR3Axi2M5AXTokKWNkXqtZKVU4rs9kNPab
         qkwHp/TXpWCGm2bFkFtgb7kMHLlBjC5H0jHndWNA+1YJjuIBapkCtGLhzPGuUOw7dJQ5
         GBzA==
X-Forwarded-Encrypted: i=1; AKwUvBwjB05fcvT4tuaNdd9UdViwjwFj/5+a7YLw4zeY6w+wX0tqxDL1tWdKdKtBHFvdwy7XcECKmdVN5w==@kvack.org
X-Gm-Message-State: AFq9FYLc/EdT5LyTtFjjc0QOzXdSD2D1B2itpEvy73qA1wGAlV6OT0xF
	gfVhv/N4lXFWI4PcURXu4FJYDnvfY2frZm9/9SL6sWtx3gIb7sN8Z5qd1Ef0NOL3mfSdkULgQI5
	mPQ1LDg==
X-Received: from pjl16.prod.google.com ([2002:a17:90b:2f90:b0:3ae:825a:57e3])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4e83:b0:3aa:f4af:1e0f
 with SMTP id 98e67ed59e1d1-3ae89536c2emr24913a91.8.1793303094029; Thu, 29 Oct
 2026 12:44:54 -0700 (PDT)
Date: Thu, 29 Oct 2026 19:44:11 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261029194452.3189365-1-kuniyu@google.com>
Subject: [PATCH v3 0/4] memcg: Misc cleanup and perf improvement for TCP.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 7p6byceo6wqiq1b88r349una68myop1b
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 57A5D12000A
X-Rspam-User: 
X-HE-Tag: 1793303095-827571
X-HE-Meta: U2FsdGVkX18WGXQsB0cadUzOFdgDSL98Me/IidNKt7Z+u7NYIr2AXrnLtHgHU4ahW37OYVstQ/rllC6G9Igy8y2nu6/6/rkU88ob5kfdee6b2eWiiUgi1JgwyQlbGxDRpp4wQ33CtnjCBK7Nal6spYJZvvjk7yZtwdvoXgDvgURSxBfqrJd233wwfUXV92p2ctPQsp4uK17mzqfAhRrEfOlPblb7XqNlfjgKhVcHBMICnNF1no0xm1ZEiEZj57PDeF8qZL2aAPTN2H+/JARqDwv8JhgnLllRWz6Waus4kULp3nC1Dv8KW9wW6jAyqa7G1zu0SKki/6Mb+JuyeHC7Z7d7+QoLCqVj+7jQnf+c2YszN+MLu1ZeryUZgQU5eDsPFOgBm9IMQX4dJuWxFM0U+nKN38Zi8aheNuA1JuU6rBJoW6lhJCkFmXtMWK3A6s8x3x79eLyHAQYakTtUcRrskGcYSbdlfUc1YXNeFoYvl5Bkl776auGQUPzn5gnuhU+BqYvbNx3itzPr10DXF9TnvRAH4VKQrUuo6YYfkdDVyyjKXGBjW19g65Wo+UXUTaKFIl10Eugme4M/KpsJbsXhQ3gggpKuomKosG/ej4QJs6ecVHvO24TUpWf3AJJpBfacZN0gIi9giO+Hg4Cg2AbiEflb9e8gs2LNxDxBXp1aF179eihhovE2LyFYcfhuGAXSUpvgn2L+fimSBX9gcTPflLJy4RC2mU0+wnOqaLXiAmO3ZyqRvGMWym+lKdRQwca4aXPZqt1ypGMWTkWUexlWzI2eBN4BZf4TDyaUPFNYlp9YyVJWijPs7cdMWOcgvdw/OxOt8noQJapdHSiWvfRw+t6qV06WoyoBnE8MHBQ8mrsO1f0HlRIui5XCSB66sjnNE7bwGpmUQso8adWQCPff1MuzT2x+wjermPXPCoOy+tNfY7stSGeZJ4pSsSnLWhZmMSv730dTxgiebf14GYh
 QhBNnZyh
 4P48jODuGXWT9v3Im2Rn39uujwCSD+rzHV1IpGvV3HNaHjbvIrr9+wgI3Noj1KNMUmtW6ZNqcg0HktGCv/NRFrwCb6Ti2M8PetdxOS0QsgJy6mXClKYu9tVvqaf3lmj2aKLeUqAEffCLKIjMuyFRqFaoR548FGV/6T/Pyo/TNApnnJm3VtcNxCv/tweIVTe7LUGO7edMHG6DN3cuSDYO64SwLUdEfgTXrV6w0iMrmayf3oWlzyyWHvRjTPWk0hV68mn2wX3mJetsJT1SUKh9FQGNPn45Qu32U4V7NYz7rCMI4lsd2aj6WJ1F0uAeRssD/+n/vzekYbI7U+qN369em8u12T5Qg0c634v6lq5uUD9PovTF+KhBoHPjuxDfAsaACrqo4QxwrAU4ZOikFnQfZR0qqXcm76p9CGXiSKfW6oP6lrjv9mQgU/5e4IHsNMYpIGB8XZOks5st3W7pn1NzYgnFqeLz+m03sAHTzjVjgeuhJQ9JTdyLQY21Tkw9MwZ/6fTYYt5n+fXXzIv+i0aA6ZfnTEJ0mjC+PaNXebypg6TjFdjXuyrQhJ0mfX5ZRth3qjO9K4CvkYsJmR50IX7u5wj2kkrV0H5chc7+e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On host w/ AMD EPYC 9B45 128-Core Processor (Zen 5 Turin,
2 sockets, 512 vCPUs), tcp_rr w/ 20000 flows throughput often
degrades by ~50%, 32M -> 17M~27M.

In the bad case, the number of involuntary context switches
was extremely high by 12x (241733 -> 3093367).

The root cause was that refill_stock() calls memcg_uncharge()
or drain_stock() while holding memcg_stock.lock.

Patch 1~3 are misc cleanup for better asm output and patch 4
moves heavy operations to out of local_lock(&memcg_stock.lock).

This series removes the flakiness and gives ~3% gain on the
512 vCPU platform.

In addition, on machine w/ AMD EPYC 7B12 64-Core Processor
(Zen 2 Rome, 2 sockets, 256 vCPU), tcp_rr w/ 10000 flows achieves
36% more throughput with lower latency.

  tcp_rr (10000 flows, 128 threads, 60s, average of 3 runs):

  Metric                     |       Baseline |    Patched |    Diff
  ---------------------------+----------------+------------+--------
  Throughput (RPS)           |     20,884,499 | 28,453,051 | +36.24%
  Latency Mean (us)          |         478.46 |     351.07 | -26.63%
  Latency p50 (us)           |         453.96 |     343.04 | -24.43%
  Latency p90 (us)           |         669.00 |     479.57 | -28.32%
  Latency p99 (us)           |         969.38 |     593.92 | -38.73%


Changes:
  v3:
    * Drop MEMCG_SOCK batching patch
    * Patch 1: Be more specific in sentence 1
    * Patch 3: Mention Clang 23 and restore asm output
    * Patch 4: Add a new benchmark result without batching stats patch.

  v2: https://lore.kernel.org/linux-mm/20261028185034.3607746-1-kuniyu@google.com/
    * Rebased on mm.git/mm-new
    * Add patch 5 for flaky throughput issue
    * Patch 4:
      * Benchmark again after rebase and update numbers
      * Check in_nmi() in __refill_stock()

  v1: https://lore.kernel.org/linux-mm/20261016052811.3085635-1-kuniyu@google.com/


Kuniyuki Iwashima (4):
  memcg: Remove unnecessary READ_ONCE() under memcg_stock.lock.
  memcg: Reduce nesting in consume_stock() and refill_stock().
  memcg: Annotate slow paths in consume_stock() and refill_stock().
  memcg: Uncharge pages outside memcg_stock.lock in refill_stock().

 mm/memcontrol.c | 95 +++++++++++++++++++++++++++++--------------------
 1 file changed, 57 insertions(+), 38 deletions(-)

-- 
2.56.0.317.g454f8302e1-goog


