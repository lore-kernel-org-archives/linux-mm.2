Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D51ECA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 16:08:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E00498E0024; Wed, 10 Sep 2025 12:08:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAFE78E0005; Wed, 10 Sep 2025 12:08:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9F6F8E0024; Wed, 10 Sep 2025 12:08:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1D3C8E0005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:08:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6202B138162
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:08:49 +0000 (UTC)
X-FDA: 83873823978.03.3A7315C
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8057940005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:08:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gIYf66X0;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757520527;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7XeVmhbC3u/9ch1NQ549CkxoZlFi1Nwr+It6Z+wZgOY=;
	b=fOgKTyr/Ia7QxxQc4rjPhvivdky4I+of9rPoxiRWYKeizCzQdWcS9NVDVjqGVtxqCjsmOb
	TDV6ZcZYycClQqLgwKARiq0FJceHK3SY0RoCajx+nTkuxJvrDFmYlM/Epk5EPGFJrmW3YM
	jra+ot6JIlrnQsMCvQt6wOyrrqxEi2w=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gIYf66X0;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757520527; a=rsa-sha256;
	cv=none;
	b=8qXB1c/4KbK02J33nJXt5VbdsFv1hk6U6FOzm68lQCYbIgNNKRcdVFJyrYSi2qnFX6ULqg
	GPeL+GJ+4bsgTZmCFZ/Wfuaf9pAF5TCAgkpQCABxS4bmQgQBCePiQzquvhipCdnsHdU5Hr
	C67Gou0E6sxwanwguzdpIvGM/hwVB0U=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7726c7ff7e5so6084932b3a.3
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757520526; x=1758125326; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7XeVmhbC3u/9ch1NQ549CkxoZlFi1Nwr+It6Z+wZgOY=;
        b=gIYf66X0CfkSoM3ixwG8xFBGvEd2zhzNmHk41U49n83sicbWoZW2Mb8h4DaFYZ1bwp
         pzt9zS2n7/xVcmPp6aV4elcCtv1X62T9+cbhWMK2Ox8xsD9QnuJFH4Y0WcMMBq4b+s8a
         NP3MmJSuiVLDvh02w8GD4+TlqAEAGuCJ8diiyAUFpFn6V2jCk7Y1idjKGcOjosbADl+9
         0tYvm7AhOKilcmMzXm8IGDky+1TTpjGtarwRWWwzIGnXQFmHl3Rjw+CjxSSa5XBb4rtd
         Wc8AQ6sz3x6y5dyjyEoY/tHpMixjKl7JmdreQ8RPwOv5lQZLtDA38Ka1v/tAvQMbEdhB
         Jb+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757520526; x=1758125326;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7XeVmhbC3u/9ch1NQ549CkxoZlFi1Nwr+It6Z+wZgOY=;
        b=cUqpU5bz8VBhyVd0oYj1+9lR9uEmLSS4akaVqvNJQkAAoOi11KASYQ78uNksXfwCgO
         ansaifBsNzQnFD1HVobayQU2tSOdi11VLiYnBBpUV9Vy23tEypkA0g+gI6CY6lJo+2zb
         VCjltegCy9RPd04F54GETcRKDLVzXPj0K6pLxcki/FHcJULAoHvGSaYnxJ/jwVZ5Dy2E
         mZ4wpTnrydvg+mU7+jWW/renZk1fCf2GrZ8nNe9i3gelocGMBPrrhHsBReYre+Lk663D
         oc2LH1D42hBp9lJdmad36EmqxiTeJMrsgkoWC5tM1bsiXNlblhzoqB4EfL50Ws/d++Lf
         tRZw==
X-Gm-Message-State: AOJu0YyDz1LQ8ydfwGB7n+LWp5GAiZbdmNQTTHzyhPus01L8M8/VFMD7
	OSKGSj0Iij/tos27poCjtliENuVx+7mx2Ks0wJeoPGM7fENh4CdX17JQG3jnPZq5tug=
X-Gm-Gg: ASbGncs+9pNQ4W3KJybj/hl8S2+mNP1EDYIHccrlVM0w9K1bfvrPyZkkMuZCevfOROe
	raQ7pDUM1YlKOOX3xX/8mAD2/d/L4CQgdhJ1KL1kYnniOKgWiG5+2KGYVLw+MKvpjQXffphaYrm
	xeekyNrF3pM28piJtn984PA+lveneiQy4/Fje3J+AXsXcfahdJu314HF2bQN9IwMXVM2JV7a9bE
	/pKWQgreVQwReJo2vq3WNMTtG7ENfqmsttbdLvjnSatAqMdsUGXTwS6EwO1JiVAa6UfzArkvZbw
	qGKhjNtT87kv5+pJc11pB3lKCRVd+qUwv9Sutu4xg7B4tJZ2lV9GYkkVezrOGdb8No33LxNQp3m
	n8dAIsiHMqJWZp5APzv76jkZUlI3mpdSUrQCj5c0v1Vk9UyvyeELGaX3xuA==
X-Google-Smtp-Source: AGHT+IEuwnWSq8ZZ4EHKHlNwEJkHdJdrIBRSfvkX0R0DdFErKxG7/KQSiXw4jR9Uc4uj/8G8mLxc4Q==
X-Received: by 2002:a05:6300:210a:b0:249:ba7b:e361 with SMTP id adf61e73a8af0-25345e31d98mr20945271637.49.1757520525670;
        Wed, 10 Sep 2025 09:08:45 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54998a1068sm1000142a12.31.2025.09.10.09.08.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 10 Sep 2025 09:08:45 -0700 (PDT)
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
Subject: [PATCH v3 00/15] mm, swap: introduce swap table as swap cache (phase I)
Date: Thu, 11 Sep 2025 00:08:18 +0800
Message-ID: <20250910160833.3464-1-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8057940005
X-Stat-Signature: ycy6cdmu889bw3pyxthz764q1chn6rn5
X-HE-Tag: 1757520527-144226
X-HE-Meta: U2FsdGVkX19p5VSnD7jSkhTCdhmaS6En07YYvTYWLhNZ7ZNMMxZ/gWUiVnpL6SYImPFSrHEq5akkCb2DJN580CukAAtC1K2iKEKKEoTm6Q3bSK13TWaDwLNVhQKaj7RP6hbXmD/ettnnM8Cx4j3/E/k31Qcx9A9exObxfRLILLr3w1IJ79s474ldu0PfzhT5i8zq9meeIXAEZrwkqZvgffNJEHwWWixOn8lZ7LIHt4845YnvFSR7j4sSl3Jpy/K/yf8+tvAnlmH2ysKd6OqO0XUqrzu0mBXbpXDZuLjdobR93oBUZehygA/uWs9n3aV6OS3VdIZN7f0T8wedSy9p6nZ//3F3CZgotTurzYTMCdPULnyokcqPd+c5C9ogy99DhUjxTnhffqdoEfJ3Y9GD57OkSg/kBk9gOPKfElgdWBobt2BqIHtclO26b0gfZhJCl8Der7DbKKJe8Zik3bknST7q/TfLPaYidz/2HCVoYXk46W/EvXaSFw8VlPo4EtqEG3Dm4OPyK9v6YD5H+nUZCYT42vUrS/tG0Lud4vFmq85IMNaLb6bUhG9WXNut+Xjnf0cuexfdCwzZcB3xuGi1d5mw8DruCZ8h3bnDQtEWQ91QbGdJ/J8ceTNYBT2dGJC6DeCdCiZ4sX1lpaJvtuPybvNwL/WV0EuCXqRq83WGYLX3RwkEOYpmOfC/oYEwJII1e4KnAcAvyhk1N/OGYcfST99brSOcVIKYJGk7IQMLnSu8g7t9o3YGJo9kA6ZXDLSByoiLT6J4KTNYGayHYxBs87rwkD++sam8sQJ/Hsa49Mb0cPkrbkr1X01W1mXv+XLBIbM4OTjM0CFEGs8LH7yuVKQNLfMWF4W78Sq0Trbfe/8YDyDsFXriTzEuHmnjSZhGP2OaxswXbioW+qkMO5hVcZfoj5Stz6qXmsT7cOAR7MVDT1QgkTK8Pgvoi1sge0bdR4/wploFmbRaNSsBObX
 Kh5z5+0y
 nbyVwcJ90F1/SDKxvILtSB4ojU3mBs5kkwDRJQRu8IEpiQmv398s6zt7j+eYsSpMt3Pd8FVVtY5gU/IVKeMuZvcXjJW/01P8ZxE67T6JFLbQVms27xLduUzdB9sOoaKUSDNoaCADdhfXnR/XfMqDKgvyBABmWNt3TyxkXu8u7DSaHzbfAN/5krSHd2vAsyMHdbHWQC4lmAlbuq8mYa9WD0SIAwmizJM9nmKOoI7/O3yjDb1xqIM/tOe36ApTnYgVUBXq2M20z1Y4YUOiTQFelmfc2Qot79c8QzD6EI4wu/UZYOOjtDGq5/8rOrWkA0qRNPIjIRn9UWUJr+A7FUhoiV0qkKrgqKA0KZ3JC7rCh+Rw8YP/AU7EXQCa0H3OWIiPZyAtSU9v4Y/zBRcSsO9uBQyQpcKfe4jSHShf/Np0AZBfedcXgKcticU1Q/A8Jr66lyTR9EK6XrNUwRnDTexY1F5y2JZWNgAb8/ckvSMJOL6W9C/SwTxBfOWd45Gkt4RDOY0PvJ6UOVerKfvigQ3EGQUm4X0lnWQsGhi7ilNpxnzcb0tWWb8b65agnOYWEbWzshwy+OYHQ4MS+7NLzj7snjR5JVDlUkCofGidfPCrv6fEANpAP38Eir2oRjOUKJMVeUAkPF5HCKBjkVILH1IZ1WXmlASbIKxk9+B3Q
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
 mm/shmem.c                      |  58 ++--
 mm/swap.h                       | 311 +++++++++++++++++++---
 mm/swap_state.c                 | 450 +++++++++++++++++--------------
 mm/swap_table.h                 | 130 +++++++++
 mm/swapfile.c                   | 458 +++++++++++++++++++++-----------
 mm/userfaultfd.c                |   5 +-
 mm/vmscan.c                     |  20 +-
 mm/zswap.c                      |   9 +-
 19 files changed, 1112 insertions(+), 535 deletions(-)
 create mode 100644 Documentation/mm/swap-table.rst
 create mode 100644 mm/swap_table.h

-- 
2.51.0


