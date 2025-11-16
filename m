Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B348CCD19A
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 18:12:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F37018E000A; Sun, 16 Nov 2025 13:12:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0DD08E0005; Sun, 16 Nov 2025 13:12:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E23988E000A; Sun, 16 Nov 2025 13:12:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C759C8E0005
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 13:12:02 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1CC2D160A58
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:12:02 +0000 (UTC)
X-FDA: 84117264084.21.3306A50
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf06.hostedemail.com (Postfix) with ESMTP id 16572180006
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:11:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=m9a1qmg0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763316720; a=rsa-sha256;
	cv=none;
	b=eol33e1+zsxEgkN1W8SfXVdIy9g8RxhrvwDUU2foDvCLQvE9gkIlnYPhtp3ul/r2j8xnix
	oE2wiMEQjLwwcIiV6km5J/lJW1FWVYpc6x+YK/SDrR2DNkuUCa/OZCGOMBqFZ7kojWu2le
	a7W4yRsU0mI4uKNhVO5lxNESnltD+DE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=m9a1qmg0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763316720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=W1CPaZeVUTN1AsZnR00JSBG/VHBNQ1hRxT7ANjmtaSo=;
	b=I7yFCqfaDLFmAbYVRn/3JuaDYzApBBmouZ3HTr53xks9T+WDNin3YO6dsX7nMmox45n2ci
	zn3hFr5u0+4FRNGSVcnNRsPi3Z39Q9qPzu0sqlrkDV0hOZdjrftjlxg6XuaeUpMAiimIv+
	DBzoqNQcIHqaaBJmvaZZso2iqV6O5HQ=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8b1bfd4b3deso291338785a.2
        for <linux-mm@kvack.org>; Sun, 16 Nov 2025 10:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763316719; x=1763921519; darn=kvack.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=W1CPaZeVUTN1AsZnR00JSBG/VHBNQ1hRxT7ANjmtaSo=;
        b=m9a1qmg01yrVFdyBQ40g930esHR3RB68NYFm6GO/6xzVFXp91EL3++sSm8yzZi85VH
         CPHX7Bk0/tv1MXGMpTvomC8t+lGNwCy/hFFYvki7baHEjJOlUl0ut9fVs6T2V9EXKv2t
         VR8fkKTry+7YoOE5PpM4RRTbapf3+N4RXTvR5saUMfTBZ44Qe30bBZdMeo7/w/IZmuX+
         u6+djjHlGn6zxTgkSV9/cP0LR7TZpwhmLINKkZvGZNvt1FPtqHD0ELtfXgSDNQKHYH7i
         vdt78di7eMfX5RYFOgjNKFo4HqQSXZDgNTYe3uzusp29pYntLx6DwDBwFuO2XvGJze7G
         k5Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763316719; x=1763921519;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W1CPaZeVUTN1AsZnR00JSBG/VHBNQ1hRxT7ANjmtaSo=;
        b=f1b2TLHsmaS2u7aecWHGU/LnCRxB0uSFDsVLMuR76enr8izJR9YAE6Rb4XYAV3/DYE
         g9NMzM/SpvUZNUEj/ffRkk5cA6jHdC7wYD6rcbJKLTvTuZeQqJBCyKr7YVEIux6NRk2T
         ck/X7u3Cd4yuN8rPQZZ77+hAGkFuNllpbnaSM9ChWW21OrNlcjVz98JUD+4f/3x1U1Ra
         1ADjTkUFlRqfG0KBvR5Q5QnJ/yiUSzg+pVtWLHlZgHOlXtuM7BBW8Z2j5hSkZXMrbNrs
         dzDmUSK/30V8YKsc9qvf1j+egIScoxMVMWYQ+ktgAml6R5op8VfSX+zv41eVCy6sc4ya
         BNBA==
X-Gm-Message-State: AOJu0YztBEr+1gGeF3pb0cQIdECCfbqTbhssS9mSzFBfd/ZrBJwBlxjD
	FwTWjPAttYA6NhF4HmzsyTN4A9PCgX7ucrr2rKNMruscFmzJaQFP2U8p
X-Gm-Gg: ASbGncvWRx2PxLGLm4PAcDMaFY/9MjfhPCJaGMe7J4gRUmixY2iHrxKKz1HmPZ3PMn4
	Vthsq6ccvayfZYwMOfx/OtHUTp+/MBhCNFE/nrxuyhL/rw2A7ZfLS/jb8u56mK7afC6D2qebXo0
	MTOfmqcS4A/fVFeWIuo+2l4Ch4m96RGNfAa3MWQnPPA0WXoEpQgsB+0NM76a4Eqh5AsK7XVIqHX
	tU2jIdafOI75Vq104wOyZWN5lchg6OAauvV+izn62nAUDJXDEI6/ddUo6ycT+tf9fqOiNlqtY3g
	G7roimJ1dgF8MZRDUMs/7L74ERicoUTtdAf22o9OEHNuY+9i3PkhLYrq2Yo2hwS2rEmth8+XWG1
	Uf8kNnX7HvNFa9Sm5HggVsM+ONE2+Q8V0QrqKzq/qKkzI7vr9SAzRH1+P/ie+gpzPXdr+78jHX+
	ee66sxljn0V7Xx74NWxhqtdARrsFA/ATeFy7h4qfZBYwF0Mt7BOsX6
X-Google-Smtp-Source: AGHT+IFE331CKiWxmYYylcJloJxeMZ2BiIyLX4dcrWxJho80PQ4NjjTu1iK8PcHMhdj8/5V0s+WO1Q==
X-Received: by 2002:a05:620a:400c:b0:89e:b3a0:bce9 with SMTP id af79cd13be357-8b2c315d2e4mr1337782085a.22.1763316718811;
        Sun, 16 Nov 2025 10:11:58 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2e089b436sm305447785a.45.2025.11.16.10.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Nov 2025 10:11:58 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Subject: [PATCH v2 00/19] mm, swap: swap table phase II: unify swapin use
 swap cache and cleanup flags
Date: Mon, 17 Nov 2025 02:11:41 +0800
Message-Id: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAN0TGmkC/13Myw6CMBCF4Vchs3ZMaeUiK9/DsChlkEm0bdoGN
 YR3txJXLv+TnG+FSIEpQlesEGjhyM7mkIcCzKztjZDH3CCFrEohGoxP7THp4U7oJTajEm1NlVG
 thvzxgSZ+7d61zz1zTC68d34pv+tPkuc/aSlRoBpPalJDTUbJSyJryKajcQ/ot237AD4WwOysA
 AAA
X-Change-ID: 20251007-swap-table-p2-7d3086e5c38a
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 linux-pm@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1763316712; l=7592;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=/P/YM4pb1/fXFf2POywLNCj1z51ehE/HU6r87l47Vdw=;
 b=EUaXCzADQCSzNT8+jGIQ3f0BDmf422WLWvvUiMFAD/rDhinkZoSugxzI7X6PaRoxbhZssy2A0
 jhMadHnaNn5DO/TTGq1sMJhahSMsNPTkABUeo+AI0NZVwB4ZGEMw8KP
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 16572180006
X-Stat-Signature: ob8w7p7tuftncw3czgo9dud6qs46pxqc
X-HE-Tag: 1763316719-335011
X-HE-Meta: U2FsdGVkX1/GriN52zhRTyhvSq1r2oIbNOM3qxhNKp4qk5LEWeXapfaeJ3xm6lJMIlSWsF+SYrfpEEnL8Z5A79NuCdGDgd2iJEgAXlMKPNfY9xcrzA5QAXqz0hgZv7br1Zb72T27k75DbjjRGlaC+p1wbWY5e2XzlOx4a97KHnSoWZehFrzZ8npy/JmzIpUiBUJDEpD+nNKYqe2/VD6P/Cwg8hKrHcxXP8LftlD0rTqt2M7zN5il3wza42fIkIHfgtF0BV8AQYyfci8wkwYoHTze+QTLhyYUMFT7AFQfLXl4rTMH+M46siJzD4ZWwIUXQ3VRIGLEM7ZnoEgi6HoqbVWCQOyKj7DAyabEsuWXWZ2kpeAqlAXWjrgNZnLDUSdAE+os+L9jpGhRLl3GFrSNZ0BaTA0VDYzw5d/McDzZ/Y6IxVJE4MI/Eg7HoRBYq6ufWfNicecclMh/gtgf5k+Szcg/3E8PZvaKfSh1MligQJhemId4mWnVSmu5Wq/M2JuGRnThoSlpP7IWFKdmpsww3U7yrjrMIW+/7v56edP7bJ1Fv+W8a0FCePno8FYejHSIc/w+JqB9W1cntGBs8UNjatKq0XIW/uq7qz3xhmwS1lMKiPjp5DHqaDxbCq+LPzCnvsFpgYGRAzf0wgkoxtOimQ40ZRL9IHGXYuQkfguj0R/CDMW3kgySTOXZmYNLfNz04YHWagyoD1jP4aH7NK8ON9QMSSj31ZF0aoBy6RWTM4K0mFuAmfsLAFYnn/IEXO75LtuTctIVRZeRvKGerjp+vYyKicxwEz4zbH7RxFBxbZG1E7cKloR90i+XWv6SGeRl5MR3q7FS761s0ziJhNdokTISY2iKSQ0JDrzkVXuUqyq3U5lTDopQDr92ZGJsCseTldQm4FGfcY7sJVijnIKEInISjGFrEua3AoVbrjsK1VEeXODQmr7Biyodb6ZXaMyf0vXsqbd/R2oPncFRGj+
 sMAhhwl4
 dP+do/hijlLZvMJeam7Kvhx/EMJdTlweIaUIxz3RUM8VsXNSW7rkaIJDDt5cNdq5TesxhjLeQ9WqF7b79qZWuxPAYFMBCL2wq6przoBbmiYQmvMEtyxj57/gtXyz/UMQGfAiZ2iQc/r1Hi2kprM9yNNg4D2RGw4pkz4+ql1R+3yweuWrwS6q7EgTjw0iMufVtglaE7Dc8kqlfl7BtK6oiYLDbz+v7gcALYRbVHps4N2uXOdo/0yzZZUmIBh/VqoacLP++RgOQvrun3wDAuEkuMLhnCH9glWc4miEDcNxBdZHUu6Ps7inHK0L1RaKFfswqJNm7eO4UwrmH+W8pOsIr0ir0aoLXkj6OYBqxYoThQEcA/ZCW1ruo+jakqWgvXItF6wnhoUB3+lh08+YAD5KAq2ktYBcEwcrC3fCxW8aCn/7d/Hj3jjkJAuS//YRY4tP7IXRW9nuz71o0svjxXW+i++4i4HLNIYmCbHbH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series removes the SWP_SYNCHRONOUS_IO swap cache bypass swapin code and
special swap flag bits including SWAP_HAS_CACHE, along with many historical
issues. The performance is about ~20% better for some workloads, like
Redis with persistence. This also cleans up the code to prepare for
later phases, some patches are from a previously posted series.

Swap cache bypassing and swap synchronization in general had many
issues. Some are solved as workarounds, and some are still there [1]. To
resolve them in a clean way, one good solution is to always use swap
cache as the synchronization layer [2]. So we have to remove the swap
cache bypass swap-in path first. It wasn't very doable due to
performance issues, but now combined with the swap table, removing
the swap cache bypass path will instead improve the performance,
there is no reason to keep it.

Now we can rework the swap entry and cache synchronization following
the new design. Swap cache synchronization was heavily relying on
SWAP_HAS_CACHE, which is the cause of many issues. By dropping the usage
of special swap map bits and related workarounds, we get a cleaner code
base and prepare for merging the swap count into the swap table in the
next step.

Test results:

Redis / Valkey bench:
=====================

Testing on a ARM64 VM 1.5G memory:
Server: valkey-server --maxmemory 2560M
Client: redis-benchmark -r 3000000 -n 3000000 -d 1024 -c 12 -P 32 -t get

        no persistence              with BGSAVE
Before: 460475.84 RPS               311591.19 RPS
After:  451943.34 RPS (-1.9%)       371379.06 RPS (+19.2%)

Testing on a x86_64 VM with 4G memory (system components takes about 2G):
Server:
Client: redis-benchmark -r 3000000 -n 3000000 -d 1024 -c 12 -P 32 -t get

        no persistence              with BGSAVE
Before: 306044.38 RPS               102745.88 RPS
After:  309645.44 RPS (+1.2%)       125313.28 RPS (+22.0%)

The performance is a lot better when persistence is applied. This should
apply to many other workloads that involve sharing memory and COW. A
slight performance drop was observed for the ARM64 Redis test: We are
still using swap_map to track the swap count, which is causing redundant
cache and CPU overhead and is not very performance-friendly for some
arches. This will be improved once we merge the swap map into the swap
table (as already demonstrated previously [3]).

vm-scabiity
===========
usemem --init-time -O -y -x -n 32 1536M (16G memory, global pressure,
simulated PMEM as swap), average result of 6 test run:

                           Before:         After:
System time:               282.22s         283.47s
Sum Throughput:            5677.35 MB/s    5688.78 MB/s
Single process Throughput: 176.41 MB/s     176.23 MB/s
Free latency:              518477.96 us    521488.06 us

Which is almost identical.

Build kernel test:
==================
Test using ZRAM as SWAP, make -j48, defconfig, on a x86_64 VM
with 4G RAM, under global pressure, avg of 32 test run:

                Before            After:
System time:    1379.91s          1364.22s (-0.11%)

Test using ZSWAP with NVME SWAP, make -j48, defconfig, on a x86_64 VM
with 4G RAM, under global pressure, avg of 32 test run:

                Before            After:
System time:    1822.52s          1803.33s (-0.11%)

Which is almost identical.

MySQL:
======
sysbench /usr/share/sysbench/oltp_read_only.lua --tables=16
--table-size=1000000 --threads=96 --time=600 (using ZRAM as SWAP, in a
512M memory cgroup, buffer pool set to 3G, 3 test run and 180s warm up).

Before: 318162.18 qps
After:  318512.01 qps (+0.01%)

In conclusion, the result is looking better or identical for most cases,
and it's especially better for workloads with swap count > 1 on SYNC_IO
devices, about ~20% gain in above test. Next phases will start to merge
swap count into swap table and reduce memory usage.

One more gain here is that we now have better support for THP swapin.
Previously, the THP swapin was bound with swap cache bypassing, which
only works for single-mapped folios. Removing the bypassing path also
enabled THP swapin for all folios. The THP swapin is still limited to
SYNC_IO devices, the limitation can be removed later.

This may cause more serious THP thrashing for certain workloads, but that's
not an issue caused by this series, it's a common THP issue we should resolve
separately.

Link: https://lore.kernel.org/linux-mm/CAMgjq7D5qoFEK9Omvd5_Zqs6M+TEoG03+2i_mhuP5CQPSOPrmQ@mail.gmail.com/ [1]
Link: https://lore.kernel.org/linux-mm/20240326185032.72159-1-ryncsn@gmail.com/ [2]
Link: https://lore.kernel.org/linux-mm/20250514201729.48420-1-ryncsn@gmail.com/ [3]

Suggested-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
Series is almost identical to V1, mostly comment update and build fix, and
rebase to resolve conflicts and for easier review. Stress test and
performance test is looking good and basically same as before.

Changes in v2:
- Rebased on latest mm-new to resolve conflicts, also appliable to
  mm-unstable.
- Imporve comment, and commit messages in multiple commits, many thanks to
  [Barry Song, YoungJun Park, Yosry Ahmed ]
- Fix cluster usable check in allocator [ YoungJun Park]
- Improve cover letter [ Chris Li ]
- Collect Reviewed-by [ Yosry Ahmed ]
- Fix a few build warning and issues from build bot.
- Link to v1: https://lore.kernel.org/r/20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com

---
Kairui Song (18):
      mm, swap: rename __read_swap_cache_async to swap_cache_alloc_folio
      mm, swap: split swap cache preparation loop into a standalone helper
      mm, swap: never bypass the swap cache even for SWP_SYNCHRONOUS_IO
      mm, swap: always try to free swap cache for SWP_SYNCHRONOUS_IO devices
      mm, swap: simplify the code and reduce indention
      mm, swap: free the swap cache after folio is mapped
      mm/shmem: never bypass the swap cache for SWP_SYNCHRONOUS_IO
      mm, swap: swap entry of a bad slot should not be considered as swapped out
      mm, swap: consolidate cluster reclaim and check logic
      mm, swap: split locked entry duplicating into a standalone helper
      mm, swap: use swap cache as the swap in synchronize layer
      mm, swap: remove workaround for unsynchronized swap map cache state
      mm, swap: sanitize swap entry management workflow
      mm, swap: add folio to swap cache directly on allocation
      mm, swap: check swap table directly for checking cache
      mm, swap: clean up and improve swap entries freeing
      mm, swap: drop the SWAP_HAS_CACHE flag
      mm, swap: remove no longer needed _swap_info_get

Nhat Pham (1):
      mm/shmem, swap: remove SWAP_MAP_SHMEM

 arch/s390/mm/pgtable.c |   2 +-
 include/linux/swap.h   |  77 ++---
 kernel/power/swap.c    |  10 +-
 mm/madvise.c           |   2 +-
 mm/memory.c            | 275 ++++++++--------
 mm/rmap.c              |   7 +-
 mm/shmem.c             |  75 ++---
 mm/swap.h              |  70 +++-
 mm/swap_state.c        | 340 +++++++++++++-------
 mm/swapfile.c          | 848 +++++++++++++++++++++----------------------------
 mm/userfaultfd.c       |  10 +-
 mm/vmscan.c            |   1 -
 mm/zswap.c             |   4 +-
 13 files changed, 842 insertions(+), 879 deletions(-)
---
base-commit: 41218ede767f6b218185af65ce919d0cade75f6b
change-id: 20251007-swap-table-p2-7d3086e5c38a

Best regards,
-- 
Kairui Song <kasong@tencent.com>


