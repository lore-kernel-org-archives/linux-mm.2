Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C77F2CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 16:01:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 301E38E0002; Tue, 16 Sep 2025 12:01:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B2A28E0001; Tue, 16 Sep 2025 12:01:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C8AB8E0002; Tue, 16 Sep 2025 12:01:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 099328E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:01:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A0F31160228
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:01:15 +0000 (UTC)
X-FDA: 83895577710.18.070DD88
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf26.hostedemail.com (Postfix) with ESMTP id B2236140020
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:01:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GibpfYjc;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758038473;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=roSrBUiptUqCvo81j/12CQVCTZ4voh4/ricWVmOwqGg=;
	b=2FsmpTFEJ7mOx7GRLdlFbC50MPRoC3Vh3TtGCfSlq+r0QbaFlGj5G7GYDHOdEhMlh9Ga1T
	3BrhaqN/2B+uLxS1JoNSP1AK+8Uhl9keQ8mopDgdPlxgTgxRfkeVplB78pSIojudfHgNOT
	MCQSJZlZLBc8d7j1FnNny6sXVNnjpB4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758038473; a=rsa-sha256;
	cv=none;
	b=zDwpBeqbVgg1/3VZWZCxGIjx+mRrJwnZWGyszhR+V8oGnxFN+NXwltIay2GQo0iDidQcze
	RJ1mLkYUuDx4d3cJX9Dc6RC7Mm0Gla0VUp6JWGh7n84eb7SqoYbBaB/7fjerQaeEPrVWWa
	QfZSAMIEFOUXY8Ccqn+CSMHFOsoddSA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GibpfYjc;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-80b7a6b2b47so533294185a.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758038472; x=1758643272; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=roSrBUiptUqCvo81j/12CQVCTZ4voh4/ricWVmOwqGg=;
        b=GibpfYjcteEuHq3LDI3aJDLDHCScxKzw7O2FiGNYiC0M7Btof2/fhPD9xzNH/tg1ys
         nNRngmQiGgaubzXmdL8JWKWfUSieVcaYaRA30zSWJ2Ngu1G2Gj4DyQ7AycYOFiE+k6dr
         jCGPg8qdoQ3FbyBJNQjUWhAysh6FTYg2snONggdOjhGOAIe5sCrfLTc3w7trI7pz0/I5
         bWqseaWQ09n7Pa94bvKtyCUDzNCHIGYJjVvg0Y1nnf39XMX+jvLtCsbUP/FQ66+JeHPG
         CuEaF5cVK8XPRG09uc0M1B2gcgRHfOkwfc1KHLdLDVbxFWKkxEGNNtWoe2jw/bTIyPlG
         gbyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758038472; x=1758643272;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=roSrBUiptUqCvo81j/12CQVCTZ4voh4/ricWVmOwqGg=;
        b=XIfZVzPf+8UyuMiiuLjqXD1Bfd1P5ap9Cgkez2lcfV2Ry5L1BaUnj5IrJd0o56Z3pD
         moZXb0OQcEmCmsgJeowlHVf4wkXDk94dpDPfJgyxtyb7vHsbzZFV9a0NqzwzXCxWXesn
         BGhAiB6HmcJo7gzfEZ7rUNTxCr5ZZyHItUGDheLxs9fWv+vHmsWmfrL7QgZBTm2cpxgA
         PNl1ODcYML+hIPVoNITo+NTHdxYWGxCAHMD6inNLOpCVmdE8Dh918pjwSdD9I3V1q3Mr
         j6xr4atJoyxLi8D6C9pKs4GjTwCZUXseYWI1+64wXrMZrEALDUBVzd8Ts8kA5w2lLZGJ
         PRtw==
X-Gm-Message-State: AOJu0YzC9gEcTFPdUIHo+MO3o2r7NHEyUkLnB12CX/Z4l3EmLLf/m4W/
	JGWyN+ez6l77Shb0XboKPz+izT38FRlgE3QFfBbI6ByJo9CrbVTlEcZB4lLwl78XOS0=
X-Gm-Gg: ASbGncsW7F2beRq++BefobZhduLyCWm+vRhr7MkYzrH1AmRE92+rY+yj0cOuF4QMHXx
	+or3Jr3GvtQVtgH55ZYdPBB8GHNZ0mFGdmy8JDxxusMPWs9Oijqb8cZv7bWi6krraI0rVXN1O7R
	ag5plDy/s5YOq7HSOwTl6gIR4/+HWl4jBxy3LUAxJ/QPp8XeSd7MDqaNdv9xpwkH0uLzms5JLnV
	Y+Am5EcQ1/6v2o+I+SHIhFpYTSt3sHaZB1lyd0446vVxmxISqg+IrX5jiGj3ZnYYgS9K2RTAwg4
	q6eI3Z4is9yjonHNARzah9xoGgx++6EAn8s/TOtbo5OEiTaGkpQSWDmbGlEWHEsTEKJGmPfLLVD
	b1P3lnVDkm9iUkGpEWQK8zNU5DCGCIgG66F6Vk/oYKejFNkA=
X-Google-Smtp-Source: AGHT+IHHaxQRdPG3/CL6pIcL2Su+yiJOc4pkV6nWx4yNEubxZJ6DzR4Gs7mcPWzKwFbdZ0zJmcQH9w==
X-Received: by 2002:a05:620a:1910:b0:827:3b4:181a with SMTP id af79cd13be357-82703b418afmr1490008985a.55.1758038471264;
        Tue, 16 Sep 2025 09:01:11 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-820cd703f54sm969765485a.37.2025.09.16.09.01.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Sep 2025 09:01:10 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Kairui Song <ryncsn@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Subject: [PATCH v4 00/15] mm, swap: introduce swap table as swap cache (phase I)
Date: Wed, 17 Sep 2025 00:00:45 +0800
Message-ID: <20250916160100.31545-1-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B2236140020
X-Stat-Signature: jnst7isi31imom84bygqoaip3qr7p8os
X-Rspam-User: 
X-HE-Tag: 1758038473-6230
X-HE-Meta: U2FsdGVkX1+STMc15C74CHwUPkgHxhBIenPgPbxR2HIizPrkliZ8z41PCKGaoWEasbag9+OwsnQWvYDQqV8ylE6Ek9hrk7icWCGQpF2+JyluGvbsZeHilxKz9DMvxPCFV+fz/8AsHJ7+y7A8VuYrCvPVKmQmmul8X/3zMs9sn4ieGDIcJSmGBojsC5W+rap/f361ermDz5BqjsYsa4+zcMwsT86t9vEqtHCUt8v4dFww+pglasLd7XELMKW8Wrpg+J5opFILjjQpE4UQq52ycjy/6h5PbdGavHyFvMVSQNiliKVhkXYCPWmYpYYK6EXWoZoVFRQ2lcmlcAK9v4CCY/YVnQj4sdbNkNP3D7ChGiVOc3pNg+dHitU8aco7TImgmVzOtujpiHddZYOWHLmQE+AiqHy2f1IspWarPO3RI1dHv3tGMYtM+qjTBB/vZgg13miLC6hIQrUzF9XVxT3FnuZ8QwurTGn7vkiILAq6FaNb3tAd+C1GU3ivG1rt7MkLegbN9gM4ydstp07/hNuRDOVBVHoSDx2Sd77qu0aBg9bi6u9w3HlZThtruKiTDzdavMKyCBZ87n5p/ktzx8B3rTihuR3ah1sSxPx2c4K8xtZdg19V8hUAVHD43m32kgpDx0lK8MJDnY1epWrhwwEgxogTkV7FyPXfwkvT2DAxsIhDu8FhWXrtPwDvoBYHHBIGGHEd9S7aaYofUwSyfDz1QEz8Jhe8sf4y+S4C8LL7QaGJDYmcMK2B62gVNqgaVdnanaxU6sdy7Kt9Vk2etUoIK7pGfTxmJYZtl/+vYTDiWFWLbhMCc2oCSET5mxsTgUQv2PKxmza8+ZFoVo2xYegytVuzFuu8NI0PNcW4o4W9Qq/WAk9CSwRA9xi3BRjv0h+D6EMwHX0kSGDSLfTjgL6KX6jEHQgSBwQgOZJDJZwr7v5Qadfca5zrDk3xn/p7ZiBQLSpM2AoqbJD8OdJxe+F
 lRaKklrQ
 DTf8W04hwT6KuDMiciTC6lZ4du5iW3lUhhqxTr7WU/nqGfOlYDyvoytLH0bmNyENh0MBlM/N4k180aasIOJU5gQKeUW1TMpTxHSimfqgKYCStXoCi9GZi5321zquZ07GAwPUIBU/c8iOjkAZXEAVfPvj/QKs0Iw4dsCMYOeU+fc7vcJvS0Wn+EWYf73IHjG+3cqQcLl1tzlflemYxv1/xjikTkq0ECfmca6d+iU3R0X3mPFKBhjtzb0bOcVeagTSTJNRukLwgu/angh84hVWD6tDa+8XKQ4hbmghVaRHJOnSoevUHukwhXY2HU+gtyEGSg0mIz9VcMoB79vKeNvwEwP+SJePAX/BqNcU/SI9RImY9wUVzwWVAmvcuTrx5bytunuXa4TuwVLzL/MihGwy0IAcjdcc0GbhaalY4ZnSy5wRxJYAhN7b7xGVTLQVz82DSKUshUl6Op6QdqUjstgrwG6EYoPQzJRvNqH0zxs7ax8Y6TqCmQcmG15V6saUrgYVRmEYp5EK2DVL3ZsBZSuYf1zJHchB3IMyJswQYuUBBQPKAky4rrekY6OWx/XKy1xHbxJNxCAbuDEj2P0WXYGcsRfpoEhvLoZ4dSHuV0kLl4d8Xe0r2CKuCN+q9XS+oQi5N4hizaqOuHO7lwefXkerh0USTpQ==
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
is set to use 2500M memory, and ZRAM swap size is set to 5G:

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

HDD swap is also ~40% faster with usemem because we removed an old
contention workaround.

Link: https://lore.kernel.org/CAMgjq7BvQ0ZXvyLGp2YP96+i+6COCBBJCYmjXHGBnfisCAb8VA@mail.gmail.com [1]
Link: https://github.com/ryncsn/linux/tree/kasong/devel/swap-table [2]
Link: https://lore.kernel.org/linux-mm/20250514201729.48420-1-ryncsn@gmail.com/ [3]

Suggested-by: Chris Li <chrisl@kernel.org>

---
V4 changes:
- Patch 14: fix potential cluster leak when attemp a sleep allocation of
  swap table: Just remove the logic that check and return the percpu
  cluster, it was trying to avoid fragmentation, which wasn't very
  successfully and may not work at all if there are multiple devices.
  The fragmentation is not a serious issue and given the chance of
  hitting that race is extremely low, let's just ignore that [ Chris Meson ].
- Patch 8 & 9: move some changes from Patch 9 to Patch 8 to avoid build
  error, no code change. [ Baolin Wang ]
- Patch 9: Fix locking section issue, should protect the shmem statistic
  update with spin lock irq. Also fix an warn on condition.
Link to V3:
- https://lore.kernel.org/linux-mm/20250910160833.3464-1-ryncsn@gmail.com/

V3 changes:
There is basically no code change, mostly clean up and comment changes.
- Renames a few variable and functions [ David Hildenbrand, Chris Li ]
- Move the folio_matches_swap_entry check under unuse_pte in patch 5
  [ David Hildenbrand ].
- Remove two redundant function params for the folio replace helper in
  patch 10, and add comment about folio setup [ David Hildenbrand ].
- Move the shmem clean up patch after the API rename patch to fix build
  error, no code change. [ Baolin Wang ]
- Fix build error with !SWAP and !SHMEM config. [ Klara Modin, SeongJae Park ]
- Fix a few typo and blank lines [ David Hildenbrand ]
- Minor code style change [ Chris Li ].
- Fix documentation warning from bot. [ Chris Li ]
Link to V2:
- https://lore.kernel.org/linux-mm/20250905191357.78298-1-ryncsn@gmail.com/

V2 main updates:
- Added some more non-debug atomic sanity checks, which very slightly
  slow down the performance by a bit compared to V1 for some tests. But
  let's be more cautious in phase I, in case there is any hidden bug in
  swap, since it has a rather complex historical baggage. And phase I is
  a critical step for follow up swap table series [ Chris Li ].
  These sanity checks can be removed very easily later or wrapped with
  a DEBUG_VM_SWAP as more swap table features land in.
- The code is basically same as V1, except one missing shmem statistic
  fixed thanks to [ Baolin Wang ]
- Added a lot of kernel docs, and more constify of sturct folio
  arguments, and better function names, thanks to [ David Hildenbrand ]
  and [ Chris Li ].
- Removed the arguable readahead change thanks to [ Chris Li ].
- Add an IRQ sanity check, have been testing with this check on for a
  long time but forgot to include it in V1.
Other updates:
- One VM_WARN_ON_ONCE to VM_WARN_ON_ONCE_FOLIO and minor adjust [ Barry Song ]
- Split out 4 patches from the old patches. The end result is still
  the same but should be easier to review [ Chris Li, David Hildenbrand ]
- Avoid some trivial blank line or variable name changes and comment fix
  [ Baoquan He, Chris Li, David Hildenbrand ]
- Added HDD test benchmark result [ Chris Li ]
- Rename and simplified folio_matches_swap_entry a little bit.
Link to V1:
- https://lore.kernel.org/linux-mm/20250822192023.13477-1-ryncsn@gmail.com/


Chris Li (1):
  docs/mm: add document for swap table

Kairui Song (14):
  mm, swap: use unified helper for swap cache look up
  mm, swap: fix swap cache index error when retrying reclaim
  mm, swap: check page poison flag after locking it
  mm, swap: always lock and check the swap cache folio before use
  mm, swap: rename and move some swap cluster definition and helpers
  mm, swap: tidy up swap device and cluster info helpers
  mm, swap: cleanup swap cache API and add kerneldoc
  mm/shmem, swap: remove redundant error handling for replacing folio
  mm, swap: wrap swap cache replacement with a helper
  mm, swap: use the swap table for the swap cache and switch API
  mm, swap: mark swap address space ro and add context debug check
  mm, swap: remove contention workaround for swap cache
  mm, swap: implement dynamic allocation of swap table
  mm, swap: use a single page for swap table when the size fits

 Documentation/mm/index.rst      |   1 +
 Documentation/mm/swap-table.rst |  72 +++++
 MAINTAINERS                     |   2 +
 include/linux/swap.h            |  42 ---
 mm/filemap.c                    |   2 +-
 mm/huge_memory.c                |  15 +-
 mm/memory-failure.c             |   2 +-
 mm/memory.c                     |  27 +-
 mm/migrate.c                    |  28 +-
 mm/mincore.c                    |   3 +-
 mm/page_io.c                    |  12 +-
 mm/shmem.c                      |  59 ++---
 mm/swap.h                       | 311 +++++++++++++++++++---
 mm/swap_state.c                 | 450 ++++++++++++++++---------------
 mm/swap_table.h                 | 130 +++++++++
 mm/swapfile.c                   | 451 +++++++++++++++++++++-----------
 mm/userfaultfd.c                |   5 +-
 mm/vmscan.c                     |  20 +-
 mm/zswap.c                      |   9 +-
 19 files changed, 1106 insertions(+), 535 deletions(-)
 create mode 100644 Documentation/mm/swap-table.rst
 create mode 100644 mm/swap_table.h

-- 
2.51.0


