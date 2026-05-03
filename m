Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35785FF886F
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 16:50:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E4306B0005; Sun,  3 May 2026 12:50:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 395216B008A; Sun,  3 May 2026 12:50:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 283486B008C; Sun,  3 May 2026 12:50:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 13CC56B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 12:50:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8BAEA12071F
	for <linux-mm@kvack.org>; Sun,  3 May 2026 16:50:54 +0000 (UTC)
X-FDA: 84726698028.18.B166BC6
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9FDCB100007
	for <linux-mm@kvack.org>; Sun,  3 May 2026 16:50:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Ejhda/27";
	spf=pass (imf05.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777827052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TS2sd/8o5RJAjVUI5sxoWuY3InAZTHu0PH6QjJRWXc8=;
	b=FXoKtwEhLkej6m6MMOVwC8wNmQTh9rJb6wFhaDp92VUO+08qUP1Si+vaSMY8XUwmlEQfgJ
	goc3xVt08VnZ9bP6w43Jwv/lJhQvHvXYr9yt7Z4dklitd83TfOZR5s9fOI0ZHeac2upGpI
	VuVzBheuSrug7faTK2xJ7/6anYShMcM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777827052; a=rsa-sha256;
	cv=none;
	b=Q3Y6oR1vy/O4iSkYNRgqVxqk+QvkFS0rao4KDz4FPR0fkRqOGH1bkVPDP/wlrTrgIQXLom
	/h05yK6cZeUMqSMp9MS3YmFfV9fHhCFx0xlObvwYX4+Xv1KDdyJdPHn67YYfJS2ccB+UZi
	5TdrPOpLEbpYzDyV5kMP5rbpyOGJKGQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Ejhda/27";
	spf=pass (imf05.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c795f441ff7so2200885a12.2
        for <linux-mm@kvack.org>; Sun, 03 May 2026 09:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777827051; x=1778431851; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TS2sd/8o5RJAjVUI5sxoWuY3InAZTHu0PH6QjJRWXc8=;
        b=Ejhda/27t9KHP9CmWkb8UPUaBGCmsENUYR5nC2SvB0MM0+mEfs98mF6ah9eJCGeFxZ
         tAD4Io9X4RwtZ93eAOCPTsqCcw+w2XOwAFMKBJ6Stxf0HHfUYNsidrsv0Eki9P7AYp67
         qcPswG4q1eu8F0WyPLd6wDU0AErt6bhlJSM0JSwtK0o5JUmeB31VzinpqEwM7Sqw0tSa
         kO5PqYgQEv8vg6fsMbA6efyO0NRWowijxo7geIWH8W3dYABjCFO4Mv0ekV1cuqZlcI+4
         LLGMCaJENUNfQEkTNrH80mati+pQP58TIjO0GtBJBdS/XR3IxkTZ2nJvtlEUC9JKxZ8i
         PqiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777827051; x=1778431851;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TS2sd/8o5RJAjVUI5sxoWuY3InAZTHu0PH6QjJRWXc8=;
        b=KfhhsjfnNFCutDrN/QA5BvK22MmKt10oNg41NKiEaE+V9kD7bfoh5x2sEnxNsYzpOD
         5nLrxpjnqiCY70D2paueOGeRmnqteZbkF7GP4NG9Fx70gy+4MpOTA7Q+m3OCYC7psgrF
         XMAzzqhLrO7sD6NEzamCx7AoUhLh+aQEHHy2LESl2+mL4qS7zvbfurH31CNFMg7dDckp
         65zXAgJmYIoLHLIRHCUFl70J2cOFHGbtugG/igRwPsT0Pe7pIZVqdbq8zo31L96aeE6Q
         bOv0DAfmwy7x6LbkqhEXmOKJfbI5u1NkMCX5Z2MJ3jGgu0Y0AFitXQA9eICxwoIayNrw
         d/zw==
X-Forwarded-Encrypted: i=1; AFNElJ8wzhIEvfZCzHWqOLDQrGKF9q2Uh4Zvmncx3OsqV6RTjgDzs1RlrIU2flnS+Qa+Cc7oCmlvS1PgVw==@kvack.org
X-Gm-Message-State: AOJu0YzQkMwuH5iQzpPP9FahOQI6oxmejHIjp0+TOBK5Y0UxXLoMLAZL
	3aPrHGjaBVM+eaz9QrqOTpt9qScyppfvJkvxyUfGCs0SaQipzVBQlmxFSqr7Oc/2qSg4nw==
X-Gm-Gg: AeBDiev6GuTdMstuNTnanLoba0U/+UqJSN0W11mXpCr0g2p24EPCy1o30iob1kMXiWf
	4RRBBXN3VxsNZ3ZPYl09onRk0WZs8IX6GYwetRcqzkalRAT2Zca/205bkhMv+fOGPy6z9fsSKsE
	JsOXHWRc7MEs+ocWbOlPTJT+1prOPMC95MNeHDAue0QlYXGGf+4n2s5C5DCBh1aLAgRigWj+w7W
	393PllqvgochOfr8fpUoJXFX2lEQrqH/YR/ZAOEABxRVHdpxNZO3B7XPf1pMrPwsLPpmMiwRVyg
	1qbJF+JzGtxkKkyxvPaez4j0O03uYH6oPj8qeu00uu7SyaQmR5ZWqjCEl6zLCR/ZKHhzVaxrnbg
	bL6Ehpp60MEtw+CNKTFI3rZTo7jHah6hkjOEvxTc8Ms2huMF8bmIphlLaO3Dh/vnlrSlzysYIcf
	hsYJoG9Gw1GhA1VYq+d7LbjDMi5B3+hR9gipxT+sf9Z5Yuhl4=
X-Received: by 2002:a05:6a20:7491:b0:3a2:d838:bfdb with SMTP id adf61e73a8af0-3a7f1f1de5amr6999048637.29.1777827051325;
        Sun, 03 May 2026 09:50:51 -0700 (PDT)
Received: from localhost.localdomain ([114.231.84.174])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83707fab756sm1494277b3a.44.2026.05.03.09.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2026 09:50:50 -0700 (PDT)
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
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	baohua@kernel.org,
	lance.yang@linux.dev,
	dev.jain@arm.com,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH 0/4] mm: introduce mthp_ext via cgroup-bpf to make mTHP more transparent
Date: Mon,  4 May 2026 00:50:20 +0800
Message-ID: <20260503165024.1526680-1-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9FDCB100007
X-Rspam-User: 
X-Stat-Signature: upka8ajidkgqtbw3h43tdtib5n5465fb
X-HE-Tag: 1777827052-369403
X-HE-Meta: U2FsdGVkX19ZUixVJfH/Zd4pXeZZkD3rWBT46TeBtDvJRHrDKJ2tbqwlmjC4t2CM+I/0XoAoXeSev2l8qlKvo9ecsOp7EHEUaGhu3zPmVmC2NtAxMzhgQ9QUL6IdG71GuQGqDiX4L9qU9Q3Mxda1t9SfBt4jUWnDSy+SwTOQUfznAhbsnAfHkNFxpfYoIPX1HFM/C/qWoblbQQPCZDjgJkTyPh3+2WabGk74QVTNNS8u4f73OqTp9klAfX3sj8R2wxGnC0vmQtkMOSgNogHc2YkxaTn9nPEkT3eOT1cxFDgULijdKNbkW3zeSsmncldYGfxo+AV9Dkm+tFozFTY7dV9RBfHy1Gnq0IAItWbyedMSb9KKUJF08WqZdjoyCcpaBGXTYhSW3suNqeZFfXr5Iul020mV0YCRi5l/4xKJKUGPDnMjykn47Iau4RL8mbt7MbR6caZJdBw+1OmheZT/2u0KTBIL1JRY3zfxtt4+tN6wG5aGWxSvC5VkVjy4MT+6JEysMUUVsIJBIay//Qd5v45nkP2XMLye5ILv29bfTQcJ90eji1+n3RTFcHeuR+GkCWS1D1AsHxWYcCjsCQtdm2WsBo00MIu+z063O3m4ROD11TXmvNZA8MqyBntfDE6VZFTQDC+PhBJ4P0Q3Vv8tXkDRie9ECgvo/p0GAHUiLdDgNcF5iwJ98YaajOMjYrnrM1fI4654AXy0titQFl3P3ZIPST2BNV07OJ3y1ZmtvD3sdHXz+X/ZC0heQIJfkL6iYNo/JcL1EVG2jzS7SFmcribu4rSPN+CJ14NckxsAwodG1fPgWgd8bN34uuXeRs4YzuvElfLxMj36uOSEnEZYQOWqOjXtoFmRpy/VJu59DXjpl5wDhJFR8vOXbaf7/P4v0Q7IYc51RcUD6h4ZLHqi1sl6fzJDac56bt8k2e9ZB7KNx5hcMzmletj+uawg3k/Mgfd454qJOby7EMXsg8g
 nUemVlWn
 6U8ayp5T+fcEVc4ylrIis/iBa3z8ps5EAKcXh6mo7M0OR/0uSa8/lptQJPxaTLjgjjefdayLpsTP+s6hhGYHPBXIlzVqpH7Iii7O5XCQ4G4Lwpl0Sfs4dD3OzRzH94BvFEIPOQzBKI+sq6ee7FVwY311Oht/umRbx1T3j0KUcU51XDZSuYrH9cWesENicxe1w2ERyTNsxn8g38NdAaKVpTxvei4x9vUJC+30kEYkII4762jviyz9deZkOPWPFiEKzWsGaf9TwkFHKJgYgM2V4KWY+oDnWRXbXEcttrVXHnXaBNgVeXN/BZe3VNba52HLSVFmQcg+vKN5O8CPO3DaaiJ9bjA3capu66CbAWlE4zqBHR79sFGDJHV30EJqK9XxdBG44NPenNc3/qkjKjovEAKo7u2oGuT0VoDCRSYa6OAgvJwEfu2uHd4quO1knKygmhN2V//svB+r2Y5HDbfoZfCLLUTnm8LDtgqOtQvyLjYqIDCD2u9FBCTVsTyyRvORRDHhXtYLxiju4GQ9osASI9b2G3yCJbPZBmhZk3Vfb3hk+6VMSJNpJRgI3GRYtr2RMT0gxEByRY6NShkjaG+42QaCL0t1mf5toRmAwaauzbeh0rnr69YohDTd6mCP8ZMb7xxocVhDG1rzaNWhSoq4GLcuAvQ==
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
4. Design mthp_ext case to address real workload issues.

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

When cgroup memory.high=max.

| redis-noBGSAVE | always      | never                | always+mthp_ext      |
|----------------|-------------|----------------------|----------------------|
| rps            | 1410824.167 | 1210387.500 (-14.2%) | 1265659.833 (-10.3%) |
| avg_latency_ms | 0.220       | 0.259       (-17.7%) | 0.247       (-12.3%) |
| p95_latency_ms | 0.618       | 0.708       (-14.6%) | 0.676       (-9.40%) |
| p99_latency_ms | 0.687       | 0.818       (-19.1%) | 0.756       (-10.0%) |

| redis-BGSAVE   | always      | never                | always+mthp_ext      |
|----------------|-------------|----------------------|----------------------|
| rps            | 1418032.127 | 1212306.873 (-14.5%) | 1261069.373 (-11.1%) |
| avg_latency_ms | 0.218       | 0.259       (-18.8%) | 0.248       (-13.8%) |
| p95_latency_ms | 0.620       | 0.714       (-15.2%) | 0.687       (-10.8%) |
| p99_latency_ms | 0.684       | 0.828       (-21.1%) | 0.756       (-10.5%) |

When cgroup memory.high=2G.

| redis-noBGSAVE | always    | never                 | always+mthp_ext       |
|----------------|-----------|-----------------------|-----------------------|
| rps            | 24813.980 | 1049254.583 (4128.5%) | 1063171.270 (4184.6%) |
| avg_latency_ms | 13.317    | 0.302       (  97.7%) | 0.298       (  97.8%) |
| p95_latency_ms | 23.220    | 0.754       (  96.8%) | 0.828       (  96.4%) |
| p99_latency_ms | 369.492   | 1.154       (  99.7%) | 1.615       (  99.6%) |

| redis-BGSAVE   | always    | never                 | always+mthp_ext       |
|----------------|-----------|-----------------------|-----------------------|
| rps            | 48373.433 | 1058403.500 (2088.0%) | 1070805.707 (2113.6%) |
| avg_latency_ms | 6.884     | 0.300       (  95.6%) | 0.296       (  95.7%) |
| p95_latency_ms | 16.474    | 0.743       (  95.5%) | 0.820       (  95.0%) |
| p99_latency_ms | 326.058   | 1.170       (  99.6%) | 1.586       (  99.5%) |

When the redis is under no memory pressure, RPS drops by 10.3% (from 1.4M to
1.2M, Is this within the acceptable range?).

However, under high memory pressure, RPS improve by 4184.6% (from 24K to 1M),
while significantly reducing the tail latency by 99%.

unixbench results
~~~~~~~~~~~~~~~~~

command: ./Run -c 1 shell8

| unixbench shell8 | always  |      never      | always+mthp_ext |
|------------------|---------|-----------------|-----------------|
| Score            | 23019.4 | 24378.3 (5.90%) | 24314.5 (5.63%) |

mthp_ext improved by 5.63%.

kernbench results
~~~~~~~~~~~~~~~~~

When cgroup memory.high=max, mthp_ext no regression.

                            always                 never               always+mthp_ext
Amean     user-32    19666.44 (   0.00%)    18464.56 *   6.11%*    19650.13 *   0.08%*
Amean     syst-32     1169.16 (   0.00%)     2235.17 * -91.18%*     1169.42 (  -0.02%)
Amean     elsp-32      702.51 (   0.00%)      699.90 *   0.37%*      702.15 (   0.05%)
BAmean-95 user-32    19665.93 (   0.00%)    18461.86 (   6.12%)    19647.61 (   0.09%)
BAmean-95 syst-32     1168.68 (   0.00%)     2234.27 ( -91.18%)     1169.20 (  -0.04%)
BAmean-95 elsp-32      702.34 (   0.00%)      699.80 (   0.36%)      702.04 (   0.04%)
BAmean-99 user-32    19665.93 (   0.00%)    18461.86 (   6.12%)    19647.61 (   0.09%)
BAmean-99 syst-32     1168.68 (   0.00%)     2234.27 ( -91.18%)     1169.20 (  -0.04%)
BAmean-99 elsp-32      702.34 (   0.00%)      699.80 (   0.36%)      702.04 (   0.04%)

When cgroup memory.high=2G, mthp_ext improved by 20.98%.

                            always                 never               always+mthp_ext
Amean     user-32    20459.89 (   0.00%)    18517.24 *   9.49%*    19963.73 *   2.43%*
Amean     syst-32    11890.63 (   0.00%)     6681.95 *  43.80%*     9395.94 *  20.98%*
Amean     elsp-32     1305.29 (   0.00%)      928.13 *  28.89%*     1109.37 *  15.01%*
BAmean-95 user-32    20439.38 (   0.00%)    18510.65 (   9.44%)    19957.89 (   2.36%)
BAmean-95 syst-32    11789.99 (   0.00%)     6679.03 (  43.35%)     9381.77 (  20.43%)
BAmean-95 elsp-32     1302.18 (   0.00%)      927.89 (  28.74%)     1108.65 (  14.86%)
BAmean-99 user-32    20439.38 (   0.00%)    18510.65 (   9.44%)    19957.89 (   2.36%)
BAmean-99 syst-32    11789.99 (   0.00%)     6679.03 (  43.35%)     9381.77 (  20.43%)
BAmean-99 elsp-32     1302.18 (   0.00%)      927.89 (  28.74%)     1108.65 (  14.86%)

TODO
====

- Do not destroy the cgroup hierarchy property. If an eBPF program
  already exists in the sub-cgroup, trigger an error and clear the
  already set bpf_mthp_ops data.
- mthp_ext handles different "enum tva_type" values. For example, for
  small-memory processes, only 4KB is used in TVA_PAGEFAULT, while
  TVA_KHUGEPAGED/TVA_FORCED_COLLAPSE continues to collapse all mthp
  size. Under high memory pressure, only 4KB is used for
  TVA_PAGEFAULT/TVA_KHUGEPAGED, while TVA_FORCED_COLLAPSE continues to
  collapse all mthp size.
- selftest

If there are additional scenarios, please let me know as well, so I can
conduct further prototype verification tests to make mTHP more
transparent.

If any of the above the strategies can be integrated into the kernel,
please let me know. I would be delighted to incorporate these strategies
into the kernel.

This series is based on linux v7.1-rc1 (26fd6bff2c05) + "mm: BPF OOM"[3]
first four patches.

Thank you very much for your comments and discussions.

[1] https://lore.kernel.org/linux-mm/20241030083311.965933-1-gutierrez.asier@huawei-partners.com
[2] https://lore.kernel.org/linux-mm/20251026100159.6103-1-laoar.shao@gmail.com
[3] https://lore.kernel.org/linux-mm/20260127024421.494929-1-roman.gushchin@linux.dev
[4] https://github.com/vernon2gh/app_and_module/tree/main/mthp_ext

Vernon Yang (4):
  psi: add psi_group_flush_stats() function
  bpf: add bpf_cgroup_{flush_stats,stall} function
  mm: introduce bpf_mthp_ops struct ops
  samples: bpf: add mthp_ext

 MAINTAINERS                     |   3 +
 include/linux/bpf_huge_memory.h |  35 ++++
 include/linux/cgroup-defs.h     |   1 +
 include/linux/huge_mm.h         |   6 +
 include/linux/psi.h             |   1 +
 kernel/bpf/helpers.c            |  29 +++
 kernel/sched/psi.c              |  34 +++-
 mm/Kconfig                      |  14 ++
 mm/Makefile                     |   1 +
 mm/bpf_huge_memory.c            | 169 ++++++++++++++++
 samples/bpf/.gitignore          |   1 +
 samples/bpf/Makefile            |   7 +-
 samples/bpf/mthp_ext.bpf.c      | 142 +++++++++++++
 samples/bpf/mthp_ext.c          | 340 ++++++++++++++++++++++++++++++++
 samples/bpf/mthp_ext.h          |  30 +++
 15 files changed, 804 insertions(+), 9 deletions(-)
 create mode 100644 include/linux/bpf_huge_memory.h
 create mode 100644 mm/bpf_huge_memory.c
 create mode 100644 samples/bpf/mthp_ext.bpf.c
 create mode 100644 samples/bpf/mthp_ext.c
 create mode 100644 samples/bpf/mthp_ext.h

--
2.53.0


