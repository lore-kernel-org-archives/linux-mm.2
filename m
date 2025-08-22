Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EB23CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 19:20:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FA5F8E0006; Fri, 22 Aug 2025 15:20:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D2588E0003; Fri, 22 Aug 2025 15:20:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E8A58E0006; Fri, 22 Aug 2025 15:20:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 283FC8E0003
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 15:20:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9C4EB834ED
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 19:20:46 +0000 (UTC)
X-FDA: 83805360492.23.EBCF346
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf26.hostedemail.com (Postfix) with ESMTP id CAE5B140009
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 19:20:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N5JheFWo;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755890444;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vBT9IPxJlhEe/9ODi5VB1eJFvWjsYuA43z30BW89zH0=;
	b=twxGtBZcs4b9XQwY6Gi8VEJEaR/E5GLdTUn46N/Q2I2ptoYjelW1rcdL/NBYiWZKBZgrhh
	ZTD7QdBYAJVqa9m5Wy4LX2Hv1g0XJllqBBdWHUqwRQ5CaHS01chkzPuB+qUi/5rTzkXmQy
	tzTWiQJG+PT2ZP1OWte5kU1dp+AI6Uo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N5JheFWo;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755890444; a=rsa-sha256;
	cv=none;
	b=Tq5jWpqbroxoGiAbSixTP1z4OH3pgkgpnYTfA3b1pghmM65Qr9vJKC1rV/suvRUUHSm27c
	lFXB8pt5MH5omZTH3NGmw4R0YAA43klxH/7m+ohuxdnIxTMhbf+ATiuxOEHii6+QPcag52
	NAr7XT7JmizfBy5JIpV0d7zToh0e+xU=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-70ba7aa13b3so29143476d6.1
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 12:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755890443; x=1756495243; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vBT9IPxJlhEe/9ODi5VB1eJFvWjsYuA43z30BW89zH0=;
        b=N5JheFWoFrbisrmQDdYIFXusI9BXNCKcsZIKqKDpXyyY0if0YQ6fe1OFfuxjLsVk5b
         dSIQfCYUTIohNKOQnOfnN2vGSLFL7wx6JJUKAgqRQCeerpvEz6qadkHOC0ubtPe4M1WU
         6yNfRkXqRfkCMe4+2Kh1dANOqjpKbjQgIFkGDhbuEwtLVCdhItiUPvg+6d1Bt4tKzX1k
         PYIsmSzm8TYAjO7IIFEciQyzlWA68vDqEodWKlAdQY97oJISOKELtNd1Fm+Hm+/ETmwq
         JDwq27gWJvUEkpjopXLFZlmPwV6bKht4zIccWEIXKsDQT9IjUotjlKtrnawX5MqiL7z0
         nIWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755890443; x=1756495243;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vBT9IPxJlhEe/9ODi5VB1eJFvWjsYuA43z30BW89zH0=;
        b=cV0wwvIi8cs7Ka/kYXpDzjH4zs+QaI3PhcrYllL80DjT5iNNs1ZDB2YCwP9gZMbWTV
         AdcUhlC1IFK+DQgWLcuqNT/VtUbCVyLWcw+wI32bQHS5KxIx0VQVzUxvQcSod2AMaOJh
         Wx9QW1trTJDwP7yUgOyYH5g4K6Ii52frzwA5eijEz2YaJhnq/qwdZQ+l8wPGUTMsWDv5
         Gz4Spd+MEqv/5zVRufy7vooQXPW1Q68KWYcA7qBBXoPCR5knu5VhNtpDmc0+oAXbK5bZ
         ZTSNIDt7WQbaPjtfM4HdFVxgHnz7nFLni0AyiL8PhHFvNHoQZ5pcdgmIgQXGe08iEfoO
         cYUg==
X-Gm-Message-State: AOJu0YwsjMJhwYbZN1Vh9EZS7VUvhJqpCWiDbgK5wzbyWhV480mXJh5X
	SsvY4F0EeqOmWkpnnDHCGK/lz6ytgxkKs62kFw3RNVAg3vVER/aZtlJ6/JCCykIp5FU=
X-Gm-Gg: ASbGncspf/FsLVNZZ5t8Tg7DoqexCy/nO7SVLPyDhjeKnirjYTWaWRyLgLh6iWWgLEm
	0pReHzQWSo9hjgWsMPxMZxeQtOGieP+NV6mofweWp4W+PD0C4kTY2KEEA2AkekXMh2QPgfPi8Hu
	0A9yCbgCe0HLjMYiIudOYPocyF/SOWcRkennai0fE6ZUxPf/6pl7vmIoqmNFm1j8pLxMdmP8man
	Cdnau2BKlUFq7vDIrppab3WtK3HZeIdNcyE8/9QExuP9xvW/p3Pp1z1/pdJu7HIrKdlXMXymelV
	XcRbJx5noCsuYTINaCK8kh7nlNZ8YLZdXSufC6WM1D6vrmB3DquBDue3K3EXhlGjzrJmtjCFxdq
	R5662zKRdKByyBQsOzoTEjS1cR3zZYZb/Gmv2PXdwJlE=
X-Google-Smtp-Source: AGHT+IEvSelBiYusSXrYhQrgrUecjMX8dnA1XU5GX3LCuNjuniYo4XrWcavNpwySuxjAVSqXeuwwVQ==
X-Received: by 2002:a05:6214:2a84:b0:70b:afb5:9743 with SMTP id 6a1803df08f44-70d97245bffmr47189646d6.8.1755890443301;
        Fri, 22 Aug 2025 12:20:43 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70da72b04a6sm3843656d6.52.2025.08.22.12.20.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 22 Aug 2025 12:20:42 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH 0/9] mm, swap: introduce swap table as swap cache (phase I)
Date: Sat, 23 Aug 2025 03:20:14 +0800
Message-ID: <20250822192023.13477-1-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CAE5B140009
X-Rspam-User: 
X-Stat-Signature: nbumiy39idqjk6yzoper15b8844yu3kb
X-Rspamd-Server: rspam09
X-HE-Tag: 1755890444-329747
X-HE-Meta: U2FsdGVkX1+i+SWCE2IoshsMWWsSwur0U6TQDjop/Ci0QM8hGlv0N4BmvCmH+B8pnUfTOXiB06MpogqiZCI/SCkDMdsStNaDiLEXyI0X3EYV0NSipRh9VWgBLq0zM+OEVx6T+26vRYmdTMLN9lCx4Kl+E68SjTIJn77ez05XvS3fNlu8+6ad2/W9Y7Py4NyeLWq6PLpwd4nV9b8PPkvI2xo+0Y1htk+raNPaNmP/06T0/3PKsGw4P/4gcs0BFuE3O+IzXFKjxqqYLpt2gNiWTxon3V11MtN/l3//RhUXwi9Yslg6YCXVNNorM/U8WigyNlRHVhrZVQs5h4XhXhuhCcxBnJGkcCaSdYM+Yrfe7QpM+s8+0NJbo/4L2Q9tIGPRK6Qo5XsIXVp4BO3bQC182e36mA346rrCjNahG72pi/OHP8eAzcLwAEYFJGTU9IdGK+8N56Wp0J1Do0JOz4j+xk84mCzD7AQnAJmWRr1ZHtADkxoaPmyrgAe2dy8L6PpvNS/zBDEBUkYJGaCNBk9jym/69iEe6HHyRKv0KFK3gDByIRS3ExOzuofL/rX4h0p7gj7GZdABYQXf/o9VQZZ7AEhcT6n7hc4Wqkd3sAw7hZt0EGeHDGK9e8Bq1DWo0+/Q/s/N5T1Xoc+Vv1PwzCCBxFNl8zVfl+QXWAl3gDbYWgcPp6NPblcPW5yTAv1EqWdcqAc77TVFzxlatRAk/Ya/7+BjCJF5gHfXU718pVf2Wqh9kUrT2c4PrOAoHUMfArQqcZ++hko1nahR22JpdkX4R3FRa68JsTdQYh9xjPJ2Wy9pa0aNh2cSFVi2iojVgQ3eaetL3rLUCf/Q8o+Rhl2Jp2Gm+LBsPBlm/L5JM6dbLxZHWYP0maC72m/yOaSIyVPDPcb71KT5xoBYVFI/p92wn3qpgoaxkue6w3JEkbgyHzzmQELvafZa8/OE8ugAlDitQPMair/3xAaopBPngxa
 Vg1Ta/IB
 6bEfooJl4hjD198as9JA6ltJ4+lSSAKGMfaYBBjSWcKHfg5n8PcpDNgoBOSr8caO8O02v5Ak5HtCX2lWwNPqrAxKNWuksHi9VZUj2dmsrXaMdwwTq9i5eJjV8RYookVzoKDCIDK9zN0ieRAyxl95HUnQ8yUm/hI79oaFDJdM9oNeALWmg3AWgE3ou3WsVBY8FUHZlMiidR9oJT6VJmmyrjYPi6wX5PcXJACb3TH0I4TaTQH10IzYhk7Yj4EVhY3tXJZZmBfq5qmmujVI+4ra+UxTBbbbHlyMWTOH3mxdeLgMOwBRHelWOZF2pVBcM/cE2F7cdPGVolNFyRpNqouUzhM79DrU7Em+T4FrVMgVJA84sEiy78LBSPp7XsPU8OUdsZA29WLovhe+Jr2tI3s855b+EnFwtR39N6YK6lpHL8Q5i6fuHz0OcMTINXqQK7kCUUOceAkYXCwk25GBFklZ6vl8qHU1/wI8xJGsuSuQJWxB5/wErgOyk0adR8ZjlScNCiLGmaB1LAaKPwdQrYzuSkZ/iJLpIhQ/08uioQLHIsS96fx2z2ff1RQ0GXNA9kNl1mCFNQJGbWpS/Wsx2YsId/aKMrn6sWh7/Y90c6tBQoOMr8K/WlTqqTrkO5MpIkxJHHf/AY+mGCMD/UgAGfXe0mTQgdBcELIGXHy3AKX3pAPx1NkY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

This is the first phase of the bigger series implementing basic
infrastructures for the Swap Table idea proposed at the LSF/MM/BPF
topic "Integrate swap cache, swap maps with swap allocator" [1].

This phase I contains 9 patches, introduces the swap table infrastructure
and uses it as the swap cache backend. By doing so, we have up to ~5-20%
performance gain in throughput, RPS or build time for benchmark and
workload tests. This is based on Chris Li's idea of using cluster size
atomic arrays to implement swap cache. It has less contention on the swap
cache access. The cluster size is much finer-grained than the 64M address
space split, which is removed in this phase I. It also unifies and cleans
up the swap code base.

Each swap cluster will dynamically allocate the swap table, which is an
atomic array to cover every swap slot in the cluster. It replaces the swap
cache back by Xarray. In phase I, the static allocated swap_map still
co-exists with the swap table. The memory usage is about the same as the
original on average. A few exception test cases show about 1% higher in
memory usage. In the following phases of the series, swap_map will merge
into the swap table without additional memory allocation. It will result
in net memory reduction compared to the original swap cache.

Testing has shown that phase I has a significant performance improvement
from 8c/1G ARM machine to 48c96t/128G x86_64 servers in many practical
workloads.

The full picture with a summary can be found at [2]. An older bigger
series of 28 patches is posted at [3].

vm-scability test:
==================
Test with:
usemem --init-time -O -y -x -n 31 1G (4G memcg, PMEM as swap)
                Before:         After:
System time:    220.86s         160.42s      (-27.36%)
Throughput:     4775.18 MB/s    6381.43 MB/s (+33.63%)
Free latency:   174492 us       132122 us    (+24.28%)

usemem --init-time -O -y -x -n 32 1536M (16G memory, global pressure,
PMEM as swap)
                Before:         After:
System time:    355.23s         295.28s      (-16.87%)
Throughput:     4659.89 MB/s    5765.80 MB/s (+23.73%)
Free latency:   500417 us       477098 us     (-4.66%)

This shows an improvement of more than 20% improvement in most readings.

Build kernel test:
==================
Building kernel with defconfig on tmpfs with ZSWAP / ZRAM is looking
good. The results below show a test matrix using different memory
pressure and setups. Tests are done with shmem as filesystem and
using the same build config, measuring sys and real time in seconds
(user time is almost identical as expected):

 -j<NR> / Mem  | Sys before / after  | Real before / after
Using 16G ZRAM with memcg limit:
     12 / 256M | 6475 / 6232  -3.75% | 814 / 793   -2.58%
     24 / 384M | 5904 / 5560  -5.82% | 413 / 397   -3.87%
     48 / 768M | 4762 / 4242  -10.9% | 187 / 179   -4.27%
With 64k folio:
     24 / 512M | 4196 / 4062  -3.19% | 325 / 319   -1.84%
     48 / 1G   | 3622 / 3544  -2.15% | 148 / 146   -1.37%
With ZSWAP with 3G memcg (using higher limit due to kmem account):
     48 / 3G   |  605 /  571  -5.61% |  81 /  79   -2.47%

For extremely high pressure global pressure, using ZSWAP with 32G
NVMEs in a 48c VM that has 4G memory globally, no memcg limit, system
components take up about 1.5G so the pressure is high, using make -j48:

Before:  sys time: 2061.72s            real time: 135.61s
After:   sys time: 1990.96s (-3.43%)   real time: 134.03s (-1.16%)

All cases are faster, and no regression even under heavy global
memory pressure.

Redis / Valkey bench:
=====================
The test machine is a ARM64 VM with 1.5G memory, redis is set to
use 2.5G memory:

Testing with:
redis-benchmark -r 2500000 -n 2500000 -d 1024 -c 12 -P 32 -t get

                no BGSAVE                with BGSAVE
Before:         433015.08 RPS            271421.15 RPS
After:          431537.61 RPS (-0.34%)   290441.79 RPS (+7.0%)

Testing with:
redis-benchmark -r 2000000 -n 2000000 -d 1024 -c 12 -P 32 -t get
                no BGSAVE                with BGSAVE
Before:         446339.45 RPS            274845.19 RPS
After:          442697.29 RPS (-0.81%)   293053.59 RPS (+6.6%)

With BGSAVE enabled, most Redis memory will have a swap count > 1 so
swap cache is heavily in use. We can see a >5% performance. No BGSAVE
is very slightly slower (<1%) due to the higher memory pressure of the
co-existence of swap_map and swap table. This will be optimzed into a
net gain and up to 20% gain in BGSAVE case in the following phases.

Link: https://lore.kernel.org/CAMgjq7BvQ0ZXvyLGp2YP96+i+6COCBBJCYmjXHGBnfisCAb8VA@mail.gmail.com [1]
Link: https://github.com/ryncsn/linux/tree/kasong/devel/swap-table [2]
Link: https://lore.kernel.org/linux-mm/20250514201729.48420-1-ryncsn@gmail.com/ [3]

Kairui Song (9):
  mm, swap: use unified helper for swap cache look up
  mm, swap: always lock and check the swap cache folio before use
  mm, swap: rename and move some swap cluster definition and helpers
  mm, swap: tidy up swap device and cluster info helpers
  mm/shmem, swap: remove redundant error handling for replacing folio
  mm, swap: use the swap table for the swap cache and switch API
  mm, swap: remove contention workaround for swap cache
  mm, swap: implement dynamic allocation of swap table
  mm, swap: use a single page for swap table when the size fits

 MAINTAINERS          |   1 +
 include/linux/swap.h |  42 ----
 mm/filemap.c         |   2 +-
 mm/huge_memory.c     |  16 +-
 mm/memory-failure.c  |   2 +-
 mm/memory.c          |  30 +--
 mm/migrate.c         |  28 +--
 mm/mincore.c         |   3 +-
 mm/page_io.c         |  12 +-
 mm/shmem.c           |  56 ++----
 mm/swap.h            | 268 +++++++++++++++++++++----
 mm/swap_state.c      | 404 +++++++++++++++++++-------------------
 mm/swap_table.h      | 136 +++++++++++++
 mm/swapfile.c        | 456 ++++++++++++++++++++++++++++---------------
 mm/userfaultfd.c     |   5 +-
 mm/vmscan.c          |  20 +-
 mm/zswap.c           |   9 +-
 17 files changed, 954 insertions(+), 536 deletions(-)
 create mode 100644 mm/swap_table.h

---

I was trying some new tools like b4 for branch management, and it seems
a draft version was sent out by accident, but seems got rejected. I'm
not sure if anyone is seeing duplicated or a malformed email. If so,
please accept my apology and use this series for review, discussion
or merge.

-- 
2.51.0


