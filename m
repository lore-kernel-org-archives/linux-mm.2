Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 695E0CA1017
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 19:14:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B40E8E0010; Fri,  5 Sep 2025 15:14:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98C268E0001; Fri,  5 Sep 2025 15:14:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C9528E0010; Fri,  5 Sep 2025 15:14:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7CCFB8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:14:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2C53C563A0
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:14:13 +0000 (UTC)
X-FDA: 83856147186.30.D9AF113
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8381F40003
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:14:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HrMSyPC8;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757099651;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=EJovH7BGKwzLbQneMLSnavadbg6bHImsXLuOy/W6UYw=;
	b=cWdSv0RgI7JavaH8KOx4gHoxwzdFvraIdY8lJzEaaVhLfECbNu3FOF+FCL0u97Xtto7Mo+
	SbHwFubhwki9Tp1SRW/XWN6h6O4u6UdJpHVuTi3iFvwKQ237FMQcm/QRVm7L2OiVlXwDBt
	V1JNnd8pS8FynSw721neLM/1FXhDoHs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757099651; a=rsa-sha256;
	cv=none;
	b=78Lf/QXfy8lg3XbEMC9P+Qwu/ZSUfwAhl5TTFif7gUBl8jUeCVDrMMzlkSdKTujkNLJlDx
	26vxnLXPSHEwfOtS0PFLLr+nlDEfWqNFaJaDR1KwsXit4Npni/1b1AmtCSBf0tklGLycIC
	y8LKz4Dl+D+CBgLZnSCJk9b9BCBjIoY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HrMSyPC8;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-772488c78bcso2456079b3a.1
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 12:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757099650; x=1757704450; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EJovH7BGKwzLbQneMLSnavadbg6bHImsXLuOy/W6UYw=;
        b=HrMSyPC8BmlofzaxvT2swOde+iiSorNvlrzzu2jfykC+lNi9FX7LLDOt7THmvvyE9e
         3XQb0nS7DoCk9vwdmE2JEk+Mwd+vaXr7TkE1NlwNFOYYS+u0U8eNe1TS4QATZaezjoJ5
         kf7yVFyenK2JsWf17F2LdyGwHdR/DF3JsDvBhZ0bh1eC1YAOXnq/iffHcRkGgQ92W9Fe
         sYs3z4nK13ChChfbdmruWZgLaMj1SoG1q1A1V9UOzt8kpCk+tYYbkzMKsuZPelQz37wm
         PGqtHrgQ2yFbGQp3sNCnppht02AALsnLXqvLQ8jw5H4B3+SWgqIjEZpZgMjUHzgLEgJv
         77dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757099650; x=1757704450;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EJovH7BGKwzLbQneMLSnavadbg6bHImsXLuOy/W6UYw=;
        b=qKCqZrouN9Zw5QC/VeuhozrIsjgQuY6ctSlT5i86QgSPI8+Q/f3nY9Tk1mS6swxlif
         QTx872KDH89pVfg2v/kd7+PdkIbqVxvkhYdBdpGmVmGskK/Vzrz284dUPecSlxFpNnSx
         zX2jNctCJq4cnZvywGEZ4uzfNLCj1L23Lul2UMI07C2r4lzO/VxN4a6dDqitrRbyBxg3
         9cWVoSVDZUGgFEtRMM49Zsdjh26K/C6jz+9zEyeeCdE2czkvbSsFnOzOheA7HSe19qhf
         6Oa2Kb9wHoaYJ14UXbCPTAqgv1BJ9P+OxH0y6bnW8MYx0/MnE3qYqymZeGca0Uf8a/nF
         pLUw==
X-Gm-Message-State: AOJu0YzmQP6clWsr/TS2sxQAT7C+pIh0hA2VbbPqBKa9o/7AaX1VmrSJ
	WXmdqJEbhZ2Q5nwckBr8YifBLmrCFcXkEKk594I6O9gqCJnvS7ab0fxMYRY2IY8yf2Y=
X-Gm-Gg: ASbGncvMxxoMrB5G7N9xBd5l3AJ0bmhXAZZkpWFPHGea9M/K7V+e+bAwZ94e/I/Etgx
	KMFzMwlyk1sd6WwpmiRcHtomDvHC4q16mrqILLyvPAxhnsWpiB33J1w43jSH58Jzz/RbZ7/bFdv
	DsFa9wr6GlA4TUNzMvm60NwxKbeSvPS1QMZwaZVvprgxhbV/RMasM8DIhqchsRRmvZbyqbwte6l
	7liIIO+hdLiWi5mxb5uEzig0VnFNhRW7DBw2ikW0BQ3FznYO87g6GNpDolZYcugQwkY76FMc/u+
	iIcKEZEVmX9aiNPwGRwYoQvYPhU2sT90vZnHihSZhu/pb4ZMl+lN1K+avE2Cknb/wVfT0X3OIvq
	qP6fCoflE9zTW/QaqBCc1iuHoBZecBoZ0TQt0irNQDrVNBOBfyE6d4knMLg==
X-Google-Smtp-Source: AGHT+IGyvxYr1hMzzyJx2gtIDT81iIW8zy4IPomcHCY8jfhXERmURHLEOrxKdOJnEf/IWo0lgx5umg==
X-Received: by 2002:a05:6a00:3d4d:b0:76b:e868:eedd with SMTP id d2e1a72fcca58-7723e3c3156mr37125086b3a.24.1757099649704;
        Fri, 05 Sep 2025 12:14:09 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77256a0f916sm15871442b3a.63.2025.09.05.12.14.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 05 Sep 2025 12:14:09 -0700 (PDT)
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
Subject: [PATCH v2 00/15] mm, swap: introduce swap table as swap cache (phase I)
Date: Sat,  6 Sep 2025 03:13:42 +0800
Message-ID: <20250905191357.78298-1-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8381F40003
X-Stat-Signature: c7kdwuc9x4byz1a9511wf8mmgnyhg4kw
X-Rspam-User: 
X-HE-Tag: 1757099651-939053
X-HE-Meta: U2FsdGVkX1+TPl5nRVXbC/YkgdUHSRVpRFZp5vg2ZWoLKSRCP8omfh5fJHLXVrnD/3F+fXu08XBsmFJQnbfdmaifSFjOrMbCQ7gbQcp3azGvHJkPycYw9QtxhE2ufGoTTy/4Eu7v+ARYy+j41m+hBEOJqfsafPP5D20yQ5fgJc8MLiTjP2TDY1Q7VDCaGZW2lXhbB7dGUqEXtDCCbjfzi2xgOAGMM1oKK1S6YDt30OCUJKcfBvYwe3uJ73Kp+JFOeYs3bLyfEGgjmUHSbV+MkSPHs0sfN7uuyxbgmkLfbHe9MyghM8nMf/UYLrrPGuu1JenUYvAtGNdZjrnbb6SRC6tKXiL4MUtjZddN5dvdEjPaHzWkCIpOua6B1q+LezRhAwyqptp3bHcYMfDpggpiaZc9uDYm8gSkD737JVFhrvqJCjmrgNyJFwX3Zqaa/7sYayIW1KAcSXUvhNnJDJY6gqDDrmCJlATWAT2nEivdIjReGMdZj6nOOLP2kGG+HFyqNHFklKQdjq6YcTu0u0iT3QOhEFFnWGoCq7KM4z5QRFyhvPFRqdUxBX353/A7MEkFgNQKYzNtzFiHKR/C6vpWnYKDi8EJOPwr6II0VZy0CzgsV+vzvjyoBIx09IpiHpfzxxsHc0efmLZ04S6FPzMujLhRffpfDdVWtDxZLQsBU2MRsvnXCPpVrYsugYvEdblnCom/vVMDRVb6FbBTO01mDueEavAL6bqbQfveMFRqm+UVNx5QNErNKRvlOeJjnNeD2Tkq4odxXeCJIqwnoSFQEIA4FHM3drUIdZjEAHtX6ELW3UlodrAnQWdwvcp1L/nO0vAJX7/PphJtTMsfsovBgMt6xfBwkfHzAhe/7Xca4rtpiEcjxjMIYxMA0Tgilo7lq9CWI5aQGRCn+3Ek4k7qALpnw2HDDmasY6UbwQC+HgYz57+7IbIEUqPxNECwTJ3dGxo45yFLMzXIVm7jQrn
 bv8cDs+f
 3CZrwnr3c7MGNGwStzTumjyeGK+k7W/5S7qXUyct8M/xjiaIgFyrTgF01/xZgMJLL+/cX1S6eY5xh2NaogdEobeJtOz4C3husKP4xKZrua9ilBI78qQNjnAQcnLvS7jyZZc5YMuTV9teOJqP5ZX+Lu88dDqaTDq+rA0Q5YtoaoEA7xSFbI7HhwVGJvDVsivcP9x9R9AQ1r7SFcmpHn9P+QSBI/QNo02HejQekfOPuIAJKUWA/X0OG53aCCET/HF9/8ffu
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
To give credit where it is due, this is based on Chris Li's
idea and a prototype of using cluster size atomic arrays to
implement swap cache.

This phase I contains 15 patches, introduces the swap table infrastructure
and uses it as the swap cache backend. By doing so, we have up to ~5-20%
performance gain in throughput, RPS or build time for benchmark and
workload tests. The speed up is due to less contention on the swap
cache access and shallower swap cache lookup path. The cluster size
is much finer-grained than the 64M address space split, which is removed
in this phase I. It also unifies and cleans up the swap code base.

Each swap cluster will dynamically allocate the swap table, which is an
atomic array to cover every swap slot in the cluster. It replaces the swap
cache backed by XArray. In phase I, the static allocated swap_map still
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
System time:               219.12s         158.16s        (-27.82%)
Sum Throughput:            4767.13 MB/s    6128.59 MB/s   (+28.55%)
Single process Throughput: 150.21 MB/s     196.52 MB/s    (+30.83%)
Free latency:              175047.58 us    131411.87 us   (-24.92%)

usemem --init-time -O -y -x -n 32 1536M (16G memory, global pressure,
PMEM as swap)
                           Before:         After:
System time:               356.16s         284.68s      (-20.06%)
Sum Throughput:            4648.35 MB/s    5453.52 MB/s (+17.32%)
Single process Throughput: 141.63 MB/s     168.35 MB/s  (+18.86%)
Free latency:              499907.71 us    484977.03 us (-2.99%)

This shows an improvement of more than 20% improvement in most readings.

Build kernel test:
==================
The following result matrix is from building kernel with defconfig on
tmpfs with ZSWAP / ZRAM, using different memory pressure and setups.
Measuring sys and real time in seconds, less is better
(user time is almost identical as expected):

 -j<NR> / Mem  | Sys before / after  | Real before / after
Using 16G ZRAM with memcg limit:
     6  / 192M | 9686 / 9472  -2.21% | 2130  / 2096   -1.59%
     12 / 256M | 6610 / 6451  -2.41% |  827  /  812   -1.81%
     24 / 384M | 5938 / 5701  -3.37% |  414  /  405   -2.17%
     48 / 768M | 4696 / 4409  -6.11% |  188  /  182   -3.19%
With 64k folio:
     24 / 512M | 4222 / 4162  -1.42% |  326  /  321   -1.53%
     48 / 1G   | 3688 / 3622  -1.79% |  151  /  149   -1.32%
With ZSWAP with 3G memcg (using higher limit due to kmem account):
     48 / 3G   |  603 /  581  -3.65% |  81   /   80   -1.23%

Testing extremely high global memory and schedule pressure: Using ZSWAP
with 32G NVMEs in a 48c VM that has 4G memory, no memcg limit, system
components take up about 1.5G already, using make -j48 to build
defconfig:

Before:  sys time: 2069.53s            real time: 135.76s
After:   sys time: 2021.13s (-2.34%)   real time: 134.23s (-1.12%)

On another 48c 4G memory VM, using 16G ZRAM as swap, testing make
-j48 with same config:

Before:  sys time: 1756.96s            real time: 111.01s
After:   sys time: 1715.90s (-2.34%)   real time: 109.51s (-1.35%)

All cases are more or less faster, and no regression even under
extremely heavy global memory pressure.

Redis / Valkey bench:
=====================
The test machine is a ARM64 VM with 1536M memory 12 cores, Redis
is set to use 2500M memory, and ZRAM swapfile size is set to 5G:

Testing with:
redis-benchmark -r 2000000 -n 2000000 -d 1024 -c 12 -P 32 -t get

                no BGSAVE                with BGSAVE
Before:         487576.06 RPS            280016.02 RPS
After:          487541.76 RPS (-0.01%)   300155.32 RPS (+7.19%)

Testing with:
redis-benchmark -r 2500000 -n 2500000 -d 1024 -c 12 -P 32 -t get
                no BGSAVE                with BGSAVE
Before:         466789.59 RPS            281213.92 RPS
After:          466402.89 RPS (-0.08%)   298411.84 RPS (+6.12%)

With BGSAVE enabled, most Redis memory will have a swap count > 1 so
swap cache is heavily in use. We can see a about 6% performance gain.
No BGSAVE is very slightly slower (<0.1%) due to the higher memory
pressure of the co-existence of swap_map and swap table. This will be
optimzed into a net gain and up to 20% gain in BGSAVE case in the
following phases.

HDD swap is also about 40% faster with usemem test because we removed
an old contention workaround.

Link: https://lore.kernel.org/CAMgjq7BvQ0ZXvyLGp2YP96+i+6COCBBJCYmjXHGBnfisCAb8VA@mail.gmail.com [1]
Link: https://github.com/ryncsn/linux/tree/kasong/devel/swap-table [2]
Link: https://lore.kernel.org/linux-mm/20250514201729.48420-1-ryncsn@gmail.com/ [3]

Suggested-by: Chris Li <chrisl@kernel.org>

Chris Li (1):
  docs/mm: add document for swap table

Kairui Song (14):
  mm, swap: use unified helper for swap cache look up
  mm, swap: fix swap cahe index error when retrying reclaim
  mm, swap: check page poison flag after locking it
  mm, swap: always lock and check the swap cache folio before use
  mm, swap: rename and move some swap cluster definition and helpers
  mm, swap: tidy up swap device and cluster info helpers
  mm/shmem, swap: remove redundant error handling for replacing folio
  mm, swap: cleanup swap cache API and add kerneldoc
  mm, swap: wrap swap cache replacement with a helper
  mm, swap: use the swap table for the swap cache and switch API
  mm, swap: mark swap address space ro and add context debug check
  mm, swap: remove contention workaround for swap cache
  mm, swap: implement dynamic allocation of swap table
  mm, swap: use a single page for swap table when the size fits

 Documentation/mm/swap-table.rst |  72 +++++
 MAINTAINERS                     |   2 +
 include/linux/swap.h            |  42 ---
 mm/filemap.c                    |   2 +-
 mm/huge_memory.c                |  16 +-
 mm/memory-failure.c             |   2 +-
 mm/memory.c                     |  27 +-
 mm/migrate.c                    |  28 +-
 mm/mincore.c                    |   3 +-
 mm/page_io.c                    |  12 +-
 mm/shmem.c                      |  58 ++--
 mm/swap.h                       | 307 ++++++++++++++++++---
 mm/swap_state.c                 | 447 +++++++++++++++++--------------
 mm/swap_table.h                 | 130 +++++++++
 mm/swapfile.c                   | 455 +++++++++++++++++++++-----------
 mm/userfaultfd.c                |   5 +-
 mm/vmscan.c                     |  20 +-
 mm/zswap.c                      |   9 +-
 18 files changed, 1103 insertions(+), 534 deletions(-)
 create mode 100644 Documentation/mm/swap-table.rst
 create mode 100644 mm/swap_table.h

-- 
2.51.0


