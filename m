Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79807CD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 15:01:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 358B56B016C; Fri,  8 May 2026 11:01:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 308746B016D; Fri,  8 May 2026 11:01:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F7346B016E; Fri,  8 May 2026 11:01:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B0636B016C
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:01:13 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 89F8C1A0175
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:01:12 +0000 (UTC)
X-FDA: 84744565584.24.70B7A75
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id 95F764000B
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:01:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QAKGQikb;
	spf=pass (imf11.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778252470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7EGp7niBWwqJ9Vew3F2l6FPvJLRzLHlL4w2Cc5pfngc=;
	b=UcQd5IeWUnk3z4sOSb7rRpfoSZUVS5DXqaE8DYHDGxqU7TINsOEyjbo6wb6IJvjrUrk3Qr
	VbJm0D1yrPDcIMaz5CBUm6oMF4j4pFh9ibzYA3fRH+wTYZs7NKx4L/y1Keqs/G600bayu4
	Ucwfar/K8jFOsPPNyXfPmb5YY+UaSy0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QAKGQikb;
	spf=pass (imf11.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778252470; a=rsa-sha256;
	cv=none;
	b=5TsoTjIHM6KK8mas36rfQbS7lUq8df64GeoyAyv2uwE4b8MG1UCinuRYnGMDWrRac1ce2n
	1p+uxFAkEV26X2NMgwCrRa+25lmS2Djbd4piY2DJeM2iis3p254ze9Oq2jZTnwiD/C8zsN
	R8ccYqvUUngHjy+0KnkOZPgGrVKiI/w=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-835386ff122so1833552b3a.3
        for <linux-mm@kvack.org>; Fri, 08 May 2026 08:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778252469; x=1778857269; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7EGp7niBWwqJ9Vew3F2l6FPvJLRzLHlL4w2Cc5pfngc=;
        b=QAKGQikbgORBcQhpS1z6/K82UmppoDWPpzEpOYdCCof0S73eTRyaauA/6PM7tCeRGF
         kH6GSMGNIDaRgxSfLNXeNgCE+SzjMB5QsGmWXn7FSWsmMx8+YY3B1jsBBnVl4gfS+OAz
         YhIuLxcqcx44ggqnTZKEm5n9wcmNI2N2JGxA7CT9FVGU5V8sddZE/E6BiE/Yb6ooNy36
         pCHwT51cF06pBgm2uCipOJO/yK29lvF26dME02YWXNXgWdc28DuFqCnx8+UZWSQqDbJ6
         DpsxBOJZx/B7rFzCvuUjWKa5m2j9Z/xMVxuM9T/3nVj/Vk6OayTZWOfKoKax+TRL/V9M
         nzVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778252469; x=1778857269;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7EGp7niBWwqJ9Vew3F2l6FPvJLRzLHlL4w2Cc5pfngc=;
        b=TOOg1+dVcJl/lk2o8NbvfJmRtm0EiNkArKjxkjpgI8TsJMPvYbFSxXu5RXg0sLchcW
         TkW+4InEvAJjxVYPpqb3ZQjAxcrCiU4rgSiWmfIRSJzWGwD0FGRtm1ixWQkG8Ba3OMjw
         PgDQGK5v1Z1LF+fi0rGqGeyHtpPxglnOwj6/mmx4vshCY/rKXJl/1HfeBt9jZCCzMmkY
         Hnq6V4rR9PwDPWchEilxY+CDSJcoQyMZ/BBV8FGYY8zARetYbBaQWz2EGPs9KWisdVyQ
         VmknnyPWET2AyHMd3tlWKS2ZBSVyeuisC/mK/fClimHjuFnmETYExsKEb349qxceAcGE
         FSGg==
X-Forwarded-Encrypted: i=1; AFNElJ8CsNmg61txNLwU7+t+Wvvq76Pa/hq9nXZUgrn7Sdbnwu/QGxS1KMtUSj4g1h9Uoi5xYDnnfo/b/A==@kvack.org
X-Gm-Message-State: AOJu0Yy78mxjQFnmhOZz7IM7WRYHjwD+avFbPxIlxNtajYdMYDgU2Ixe
	uVP+NuHrKMrCLih1IepNRcOg8QbOBpgrcDDmOaMFtZXjdAXT2SWtEQMQ
X-Gm-Gg: Acq92OEeg/fwc5BYr4H6e/Z7i5xjNi0u9BfMmcPs51XwbqPRqhm+7jVxfRGgsAXAOnp
	+WiQsXmF/uoujCc4oeX5eB9DBWSf7FWH/LXYGmFe4rjY4KUh0LeIMH0gfZdTckqvvg8oPKMvE5U
	F+62nbT8cz34gxgZs6OleKI+yMF1wex4yGmSmkIF9EUgp4hqLg5RYKMdUlJL70dZ9HtLKiEa1on
	RzxS/nLIiivEgYPHcHEWyqZWYbjq/M0ybVJSak0h56Dmob5qi+e3zUS8SXvABR2ilX2Ca6Clfcu
	krGS7Uk6fZtxuZsBOBKUmLRwF2wt8V7RHZ83K4WqhmxUjPLKxZfpBLtC9Rphs9uu4GVCEkfvyjS
	+JYkenpfYcXCAhI9DV8ZNOXLSBuaWDIm1iU/a7lg2VLc0aw7ypaZjQwUhQrG9T+lWtrFrpETweR
	YaA+aH3B8n/V1VgRI0+M07NtBQHDBsQlIuipkcH18IkQd7Dh0=
X-Received: by 2002:a05:6a00:1ace:b0:82f:9d21:d352 with SMTP id d2e1a72fcca58-83a5bad9376mr12442499b3a.9.1778252468020;
        Fri, 08 May 2026 08:01:08 -0700 (PDT)
Received: from localhost.localdomain ([114.231.84.174])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83965945c1bsm13110064b3a.15.2026.05.08.08.01.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2026 08:01:07 -0700 (PDT)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	roman.gushchin@linux.dev,
	inwardvessel@gmail.com,
	shakeel.butt@linux.dev,
	ast@kernel.org,
	daniel@iogearbox.net,
	surenb@google.com
Cc: tz2294@columbia.edu,
	baohua@kernel.org,
	lance.yang@linux.dev,
	dev.jain@arm.com,
	laoar.shao@gmail.com,
	gutierrez.asier@huawei-partners.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH v2 0/4] mm: introduce mthp_ext via cgroup-bpf to make mTHP more transparent
Date: Fri,  8 May 2026 23:00:51 +0800
Message-ID: <20260508150055.680136-1-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 95F764000B
X-Stat-Signature: 5ar6wsqz5ytja39cq1zpoybk1jyuhbd4
X-HE-Tag: 1778252470-913575
X-HE-Meta: U2FsdGVkX1+sUXiFRG72Sfy4fwpghCPX6WARwcm3MVJ+zr8xNEblYjTInXQGu6gDA1pFyrHVAVihbWYVUREldbIeeQGTb4yevjp6158ycS2uGa6vHXpBzrnATbs81A4gh6QMS5mA7x4gmtdg/hYaUIcy9B+8H5ii5dfBOXhSysHbPHHt4mM22mzSyMRKz701mxa+ai8U1pHOhwl4SLHyPbZKWrOqbA0jxJK4JKZQeWt3c/4Lk0DDqcu5bLqTXGj4D+G3vg1rGEmkoxYhK5vlKtA2Q81vUaC3U0kmiy4ACk0MXJ1iH+gpHVI9kAnxJYrUwRU+o/SUOSt3oSEkVFuWjFE/oepsyXc0z9fNUtse6ifjn/HZtF5EJDcc/A1+7gMpjqNvUk/E8T/Qw/QHgKFkqlotPMctFfZw0HB9dcaJQ8tZ97TKu/QFvYG/3lVJA4vtBI3NDdPFLjaUw7UsRlU4iuHeHMvpsROD3ANZZfAgDVzIVeUu5ha4SWMpCo4C612Zt6Pt1VQi3DDYlOl1pOc2VvPdDpQrJSrB9MIdfDGVpmTVmsmXXIs7zAbaZA1CovOpT8Khro/OlDk3HXy77T4qZx7o1lF+eNlggdIHTPNs8vwSC2ao8yW6uvMvESkHECnLjIgmlAKH9Up9lvgpb3vAp9bztaUvg14AiHdHXLfNXB/IbPbHEM1B7P1Y+XYcH+9ZwDzuZ52H9Q8Ptbv4XlZ+rhWC7tjYLhon+JNCFIfmNeE2UOmBq1HChEJTyJc8RMZB3vzIxeY4BUhloHOzJRHnooW1+WWH/hOgX5VRDbDWCWsb1HuvShYDY04m7PIPqYOROsQXKG6VkyJCo6W8p4tI5cxmvD4kmpc5VpJzt6Z9nGG+ueziN3tqHADe48/F6dZFnCBe0A1LMhMKlu9OfbPzuz8avxoZ+B2xBVjncHD8mBZlKy5mzIg2TyY6l80TQGO7d9PBeLt1E6Jr5ls2lEI
 c3BBLTE6
 zbrHAiiCY9qXqGLMSqb54ExcWygT/GGMW8s1mDaLsSxbJ1ZmcvGbDuwpyDFeQf/B3z3E3RvNzFpqEJQM4I41+H56SZ5B/cz5+3EaeUcxej/Hy7fh+gmpRetItMMlpZU3GXKqHbDUeBaAqav0jxFg0mwzA+Vxnlm2UoFWeBU/PYIKhuk9nC23imWkAXO0ZOdpDzsU3XWRWT7beBToMB1m1+DRiT5lbOODx6M9MVmkEb5/tL1PN8yTvvZr9664MofqGrvRKULLAkrrXMtEXYC+PRk9Lc8Klo1kYcvplcIXJoaFgt95ChlsHcg8/CgOCNgbXqfwGZXA24/Z8iCqOwTIaeOOjflxRktX3zOEJvo4425q9rhBpalOr1S8J0uRSmFgNGbQVpUtVQ/+UHE5tpI02PdCubDOAjibPhx9a71uuuW/b53g5sV2Mlvkx4EkKjOaCxge1X+c7GTj8D637tT/YhLkMxZgNDMcoMopC4LW7Qz8ylzu/qshEwN6LgicacU6LfJ/uM0ti16+H+MFTi5olQUMo1pnaTclkCHNNMDSeV1ZBhFD3qWn/bySk7UKRPbWSWW1b2xRcipC5PNpmcoFB9ViijyFPT5teyuJqnOyxfnM/3rseaULOT5GjS7pQ6ILXDV8k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

Hi all,

Background
==========

As is well known, a system can simultaneously run multiple different
scenarios. However, THP is not beneficial in every scenario — it is only
most suitable for memory-intensive applications that are not sensitive
to tail latency. For example, Redis, which is sensitive to tail latency,
is not suitable for THP. But in practice, due to Redis issues, the
entire THP functionality is often turned off, preventing other scenarios
from benefiting from it.

There are also some embedded scenarios (e.g. Android) that directly use
2MB THP, where the granularity is too large. Therefore, we introduced
mTHP in v6.8, which supports multiple-size THP. In practice, however, we
still globally fix a single mTHP size and are unable to automatically
select different mTHP sizes based on different scenarios.

After testing, it was found that

- When the system has a lot of free memory, it is normal for Redis to
  use mTHP. performance degradation in Redis only occurs when the system
  is under high memory pressure.
- Additionally, when a large number of small-memory processes use mTHP,
  memory waste is prone to occur, and performance degradation may also
  happen during fast memory allocation/release.

Previously, "Cgroup-based THP control"[1] was proposed, but it had the
following issues.

- It breaks the cgroup hierarchy property.
- Add new THP knobs, making sysadmin's job more complex

Previously, "mm, bpf: BPF-MM, BPF-THP"[2] was proposed, but it had the
following issues.

- It didn't address the issue on the per-process mode.
- For global mode, the prctl(PR_SET_THP_DISABLE) has already achieved
  the same objective, there is no need to add two mechanisms for the
  same purpose.
- Attaching st_ops to mm_struct, the same issues that cgroup-bpf once
  faced are likely to arise again, e.g. lifetime of cgroup vs bpf, dying
  cgroups, wq deadlock, etc. It is recommended to use cgroup-bpf for
  implementation.
- Unclear ABI stability guarantees.
- The test cases are too simplistic, lacking eBPF cases similar to real
  workloads such as sched_ext.

If I miss some thing, please let me know. Thanks!

Solution
========

This series will solve all the problems mentioned above.

1. Using cgroup-bpf to customize mTHP size for different scenarios
2. Use a cgroup eBPF program to monitor all sub-cgroups. Sub-cgroups
   under the same parent-cgroup adopt the same eBPF program. Only multiple
   sibling-cgroups (where the parent-cgroup has no attached eBPF program)
   are supported to attach multiple different eBPF programs without
   breaking the hierarchy property of the cgroup.
3. Automatically select different mTHP sizes for different cgroups,
   let's focus on making them truly transparent.
4. Design mthp_ext case to address real workload issues and further
   clear/stabilize the ABI.

The main functions of the mthp_ext are as follows:

- When sub-cgroup is under high memory pressure (default, full 100ms 1s),
  it will automatically fallback to using 4KB.
- When the anon+shmem memory usage of sub-cgroup falls below the minimum
  memory (default 16MB), small-memory processes will automatically
  fallback to using 4KB.
- Under normal conditions, when there is no memory pressure and the
  anon+shmem memory usage exceeds the minimum memory, all mTHP sizes
  shall be utilized by kernel.
- Monitor the root-cgroup (/sys/fs/cgroup) directory by default, with
  support for specifying any cgroup directory.

Performance
===========

The below is some performance test results, testing on x86_64 machine
(AMD Ryzen9 9950X 16C32T, 32G memory, 8G zram).

NOTE: The following always/never labels indicate setting all mTHP sizes
to always/never. Detailed test script reference[4].

redis results
~~~~~~~~~~~~~

command: redis-benchmark --csv -r 3000000 -n 3000000 -d 1024 -c 16 -P 32 -t set

When cgroup memory.high=max, no memory pressure, seems only noise level
changes, mthp_ext no regression.

| redis-noBGSAVE | always      | never                | always+mthp_ext     |
|----------------|-------------|----------------------|---------------------|
| rps            | 1431307.083 | 1224004.250 (-14.5%) | 1420053.873 (-0.8%) |
| avg_latency_ms | 0.216       | 0.256       (-18.5%) | 0.218       (-0.9%) |
| p95_latency_ms | 0.612       | 0.708       (-15.7%) | 0.615       (-0.5%) |
| p99_latency_ms | 0.682       | 0.812       (-19.1%) | 0.692       (-1.5%) |

| redis-BGSAVE   | always      | never                | always+mthp_ext    |
|----------------|-------------|----------------------|--------------------|
| rps            | 1429093.707 | 1231569.587 (-13.8%) | 1431075.330 (0.1%) |
| avg_latency_ms | 0.216       | 0.255       (-18.1%) | 0.216       (0.0%) |
| p95_latency_ms | 0.618       | 0.706       (-14.2%) | 0.615       (0.5%) |
| p99_latency_ms | 0.684       | 0.823       (-20.3%) | 0.684       (0.0%) |

When cgroup memory.high=2G, high memory pressure, mthp_ext RPS improve by
3450%, while significantly reducing the tail latency by 99%.

| redis-noBGSAVE | always    | never                | always+mthp_ext      |
|----------------|-----------|----------------------|----------------------|
| rps            | 24932.790 | 976610.893 (3817.0%) | 885337.250 (3450.9%) |
| avg_latency_ms | 13.173    | 0.326        (97.5%) | 0.367        (97.2%) |
| p95_latency_ms | 23.028    | 0.786        (96.6%) | 1.511        (93.4%) |
| p99_latency_ms | 366.762   | 1.183        (99.7%) | 2.975        (99.2%) |

| redis-BGSAVE   | always    | never                 | always+mthp_ext      |
|----------------|-----------|-----------------------|----------------------|
| rps            | 50551.567 | 1026720.293 (1931.0%) | 892643.707 (1665.8%) |
| avg_latency_ms | 6.581     | 0.310         (95.3%) | 0.365        (94.5%) |
| p95_latency_ms | 16.730    | 0.772         (95.4%) | 1.447        (91.4%) |
| p99_latency_ms | 311.551   | 1.140         (99.6%) | 2.988        (99.0%) |

unixbench results
~~~~~~~~~~~~~~~~~

command: ./Run -c 1 shell8

mthp_ext improved by 5.99%.

| unixbench shell8 | always  | never           | always+mthp_ext |
|------------------|---------|-----------------|-----------------|
| Score            | 22916.8 | 24304.0 (6.05%) | 24289.9 (5.99%) |

kernbench results
~~~~~~~~~~~~~~~~~

When cgroup memory.high=max, no memory pressure, seems only noise level
changes, mthp_ext no regression.

                            always                 never               always+mthp_ext
Amean     user-32    19702.39 (   0.00%)    18428.90 *   6.46%*    19706.73 (  -0.02%)
Amean     syst-32     1159.55 (   0.00%)     2252.43 * -94.25%*     1177.48 *  -1.55%*
Amean     elsp-32      703.28 (   0.00%)      699.10 *   0.59%*      703.99 *  -0.10%*
BAmean-95 user-32    19701.79 (   0.00%)    18425.01 (   6.48%)    19704.78 (  -0.02%)
BAmean-95 syst-32     1159.43 (   0.00%)     2251.86 ( -94.22%)     1177.03 (  -1.52%)
BAmean-95 elsp-32      703.24 (   0.00%)      698.99 (   0.61%)      703.88 (  -0.09%)
BAmean-99 user-32    19701.79 (   0.00%)    18425.01 (   6.48%)    19704.78 (  -0.02%)
BAmean-99 syst-32     1159.43 (   0.00%)     2251.86 ( -94.22%)     1177.03 (  -1.52%)
BAmean-99 elsp-32      703.24 (   0.00%)      698.99 (   0.61%)      703.88 (  -0.09%)

When cgroup memory.high=2G, high memory pressure, mthp_ext improved by 26%.

                            always                 never               always+mthp_ext
Amean     user-32    20250.65 (   0.00%)    18368.91 *   9.29%*    18681.27 *   7.75%*
Amean     syst-32    12778.56 (   0.00%)     9636.99 *  24.58%*     9392.65 *  26.50%*
Amean     elsp-32     1377.55 (   0.00%)     1026.10 *  25.51%*     1019.40 *  26.00%*
BAmean-95 user-32    20233.75 (   0.00%)    18353.57 (   9.29%)    18678.01 (   7.69%)
BAmean-95 syst-32    12543.21 (   0.00%)     9612.28 (  23.37%)     9386.83 (  25.16%)
BAmean-95 elsp-32     1367.82 (   0.00%)     1023.75 (  25.15%)     1018.17 (  25.56%)
BAmean-99 user-32    20233.75 (   0.00%)    18353.57 (   9.29%)    18678.01 (   7.69%)
BAmean-99 syst-32    12543.21 (   0.00%)     9612.28 (  23.37%)     9386.83 (  25.16%)
BAmean-99 elsp-32     1367.82 (   0.00%)     1023.75 (  25.15%)     1018.17 (  25.56%)

TODO
====

- mthp_ext handles different "enum tva_type" values. For example, for
  small-memory processes, only 4KB is used in TVA_PAGEFAULT, while
  TVA_KHUGEPAGED/TVA_FORCED_COLLAPSE continues to collapse all mthp
  size. Under high memory pressure, only 4KB is used for
  TVA_PAGEFAULT/TVA_KHUGEPAGED, while TVA_FORCED_COLLAPSE continues to
  collapse all mthp size.
- selftest

If there are additional scenarios, please let me know as well, so I can
conduct further prototype verification tests to make mTHP more
transparent and further clear/stabilize the BPF-THP ABI.

If any of the above the strategies can be integrated into the kernel,
please let me know. I would be delighted to incorporate these strategies
into the kernel.

This series is based on mm-new + "mm: BPF OOM"[3] first four patches.

Thank you very much for your comments and discussions.

[1] https://lore.kernel.org/linux-mm/20241030083311.965933-1-gutierrez.asier@huawei-partners.com
[2] https://lore.kernel.org/linux-mm/20251026100159.6103-1-laoar.shao@gmail.com
[3] https://lore.kernel.org/linux-mm/20260127024421.494929-1-roman.gushchin@linux.dev
[4] https://github.com/vernon2gh/app_and_module/tree/main/mthp_ext

V1 -> V2:
- Rebase on mm-new, run all performance tests again.
- Register eBPF programs only when no mthp_ops exists in all sub-cgroup, do not
  destroy the cgroup hierarchy property.
- Fix newly created cgroups silently bypass the hierarchical BPF mTHP policy.
- Fix bpf_mthp_choose() UAF due to improper SRCU locking.
- Add bounds check in bpf_cgroup_stall() and fix return type to u64.
- Check cgroup_psi() return value.
- Fix spurious mTHP fallback during initial cgroup scan due to zero-init
  info->stall.
- Fix info->order being set to 0 when no processes are running in the cgroup.
- Fix Compilation fails when CONFIG_CGROUPS=y && CONFIG_PSI=n.
- Fix NULL pointer dereference of st_link.
- FIx infinite loop in trigger_scan() when read() returns an error.
- Fix integer overflow in FROM_MB() macro.
- Fix setup_psi_trigger() fail, but masks the error code.

V1 : https://lore.kernel.org/linux-mm/20260503165024.1526680-1-vernon2gm@gmail.com/

Vernon Yang (4):
  psi: add psi_group_flush_stats() function
  bpf: add bpf_cgroup_{flush_stats,stall} function
  mm: introduce bpf_mthp_ops struct ops
  samples: bpf: add mthp_ext

 MAINTAINERS                     |   3 +
 include/linux/bpf_huge_memory.h |  52 +++++
 include/linux/cgroup-defs.h     |   1 +
 include/linux/huge_mm.h         |   6 +
 include/linux/psi.h             |   5 +
 kernel/bpf/helpers.c            |  34 ++++
 kernel/cgroup/cgroup.c          |   2 +
 kernel/sched/psi.c              |  34 +++-
 mm/Kconfig                      |  14 ++
 mm/Makefile                     |   1 +
 mm/bpf_huge_memory.c            | 168 ++++++++++++++++
 samples/bpf/.gitignore          |   1 +
 samples/bpf/Makefile            |   7 +-
 samples/bpf/mthp_ext.bpf.c      | 148 ++++++++++++++
 samples/bpf/mthp_ext.c          | 339 ++++++++++++++++++++++++++++++++
 samples/bpf/mthp_ext.h          |  30 +++
 16 files changed, 836 insertions(+), 9 deletions(-)
 create mode 100644 include/linux/bpf_huge_memory.h
 create mode 100644 mm/bpf_huge_memory.c
 create mode 100644 samples/bpf/mthp_ext.bpf.c
 create mode 100644 samples/bpf/mthp_ext.c
 create mode 100644 samples/bpf/mthp_ext.h

--
2.53.0


