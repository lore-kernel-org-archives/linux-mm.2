Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C629FCCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 12:10:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78AC26B0088; Fri, 16 Oct 2026 08:10:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73B856B008A; Fri, 16 Oct 2026 08:10:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62A996B008C; Fri, 16 Oct 2026 08:10:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3AF3A6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:10:04 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9FC4BC03E9
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:10:03 +0000 (UTC)
X-FDA: 85328371086.22.F9BE0D1
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf25.hostedemail.com (Postfix) with ESMTP id D75B9A0009
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:10:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZNzrFICa;
	spf=pass (imf25.hostedemail.com: domain of chenhongfeng0212@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=chenhongfeng0212@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792152601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pLob/vRQa3c1x4TgqQCsxa5ZzEfJKY3TcYiiw4aZMIU=;
	b=k8QsxM3f4gkqMDbT4IF4qBePqtQvSRIALY4FD8wbiCdSJm6aKmok03730n2mmjY14hr7wx
	TvFnqk+aa98C1/hdIam01WYyL/5ch2IXcmjHgeuCwHr/fUYpe/vumW9Sqt1aht52EtTwqQ
	oPwSSTKXhJTeGzwjBgbao/uaofdLRG0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792152601;
	b=VJJLNYb+KEYWHnkAPsw5N2M5k3jqW1jU4d5dQAt/WtWCmQZwiwPCiWgLrsi8M4x119kzNs
	fkEdpWhiJt30RUvv+BIScFlUauDfwyiM5KEvyxBh0HCPxrnzgKhpFXbGnOShJTu+WLSeWz
	Nyt0Teed2WNzDPQ5LiRJsIo9CzB656Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZNzrFICa;
	spf=pass (imf25.hostedemail.com: domain of chenhongfeng0212@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=chenhongfeng0212@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-38d489b6b71so3498499a91.0
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 05:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792152600; x=1792757400; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pLob/vRQa3c1x4TgqQCsxa5ZzEfJKY3TcYiiw4aZMIU=;
        b=ZNzrFICatuC1c3/7ebafhg0GGrpbjLS87fuK2k9eG42KUzv/K9B0cKTxBY83j0nuwZ
         u1wMXCuI3A5gCJxHJW0wQh9yjHI0NM54pWQ6iATPqVUTYX8b3b2JwV64quTUQudHsvKa
         uScANTGaqafr580WXVzv672PAmwr6VdlCFze4H0w7nM8H/Qq0kDAEdQqiZOlZi5yCl57
         lhJIiG0hN8rwk99x1uZ8x7BlEtw969GMLzs8sBOhQRdjj3x2we3b9pa72fRyGt3QNt/f
         keRzdBMH3iOYuy6I6Yu6ReYDATazgoaZxb6p8q21aCDMDHI0mGS6TSI8sWy3+K+8p5bf
         mK2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792152600; x=1792757400;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pLob/vRQa3c1x4TgqQCsxa5ZzEfJKY3TcYiiw4aZMIU=;
        b=AYnPS2WK0BlbG6AbW8s/u0ox5gYN1TN4q9hkXWWO51MnT9zdxaee3QMJ410hVpvDUP
         UQaXPaL7sEmtogwekwxAl0RV6drqQ35XiBioElu4hA4MfaYwqU0kHX+aF+nj009CDjF+
         zVIeMxUFs/ZgAW9eAOLzGa4OUSc/hhg6vIYqcjtc/20Si6jbOi6SQUTgfoOxZ5eaNmTc
         oOYepYbdkakRZ/XuaIe47+2XKLj43POK1rwwjRg7cSBd7TUT1V6iZwHhIpdysCpOqkyy
         etxvilnWHNaYQT0VqWsyY7vD0uxIXzlQm40cGxgomSnW9iI8lDYG8zua+SoX5AYlfsRN
         FkXg==
X-Gm-Message-State: AFq9FYJwBTvoAIJJ3hh+ZCyyLIMAd55AzjWgeOUP450/AbgS9x+JkBff
	REF0Qpx+M1MPfx+JQOsrf9razofxzWJazjK8O/+XfE5KwKtfyzKv/fHZ
X-Gm-Gg: AYBFou3GCUbrzs4bYQSk4CXSeqODXlgqODJvqFYuwFYmCHdiipoXE4WqNjOUSdawMf3
	XWMGxuJ3xh012pdbqHl2RWmJWdvjzZej1UI1yTnnWY/W4diMqm66PNZmFLk7cknGugg/FTgVyU6
	RtVxNvGWCWVXWrrEZAbA3HpBadCUn9K4QrblgCpBNOvIWW5i6E5B9N7vyQDm1w+Vn96x6JSEtBz
	CGN0ce+Cr/kbroiuNPr7WGCWIDdIaCBRTSI11vTgXtvU3qXPKbVykP3rwCqg7zpiIcXwMGg7Q4S
	3B5LcrJJuLDbG0K4UWMzk92lKagaCrM9YTeryGBrux/34jq7nfHdBjSo2kB11bGaZBRubP2tr4P
	04fFlvOKRTv741J/1qQzKB3vlF0q8RlzUXv9YK0O1Z2y/aAum5zfqZkwTE/miByhxKzMeV3uwsU
	aqBrC+/Rqd/mhzpFPJvXLsHMuEWYEEQbOBJDwfjruZIqFZinET4j8drxIWddkg6YwT6WLz4gel
X-Received: by 2002:a17:90b:224e:b0:3a0:ace4:d2b4 with SMTP id 98e67ed59e1d1-3ab3a9f42aamr16804358a91.23.1792152600469;
        Fri, 16 Oct 2026 05:10:00 -0700 (PDT)
Received: from hongfeng.mioffice.cn ([43.224.245.240])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acc48f4cadsm3908912a91.12.2026.10.16.05.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 05:10:00 -0700 (PDT)
From: Hongfeng Chen <chenhongfeng0212@gmail.com>
X-Google-Original-From: Hongfeng Chen <hongfengchen@xiaomi.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Minchan Kim <minchan@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Wenchao Hao <haowenchao@xiaomi.com>,
	Wenchao Hao <haowenchao22@gmail.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	Hongfeng Chen <hongfengchen@xiaomi.com>
Subject: [RFC PATCH v4 0/2] mm/zsmalloc: defer object free to per-cpu batches
Date: Fri, 16 Oct 2026 20:09:25 +0800
Message-ID: <20261016120927.3191690-1-hongfengchen@xiaomi.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D75B9A0009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: an6z4ak9zw54dxuzqc89d7jx5ecmbdas
X-HE-Tag: 1792152601-609208
X-HE-Meta: U2FsdGVkX18Zt3nfWd6qimYDbuNWVmId8zeM8Hhs41yNDsmEUDZMOWDDFWoFKT4Hj34ZaSDmpHgNEqNNLS7wXTtHn5NJsFKS5iqpz63Xpp/NJGvwIsEgB19ebQwk1pp8uAlaZJFQp1EIiZXl7Cyetb3Q7bfixC8tJfSnGaDTc1QOfaUloWtNQjtZITEI0LuRcrfLKXf7H1dQreQsKZ4ViC9KKDGbj3NL5fhGkJbnAZWHW1oRZninXrjlxrS4SJ+SN+G3oBHwkvayUShZIfGmiBB1IPYA7wQnl1PEJRVS61du9CP0OCBZXgTS9QifHXlxCZCOt1HxC2Tsbv7946GDK7ZWnMFtQAuaAurppRZQ62Cwon8Olz7CIejIVpdArLMhjRY6jjx86trv8XarrpdqjzsPf5ouOaJwY+yaYpcmEe5NLuNrtbK1zHYqcOOhw6/aKepGHTZEDib+S4nJjlVAxy8/8j1DOctqq51nhzOTVFSLWMRDtfbT9GWCa3hMSSStuthqaVYOVhHQjubB+lgbEP68yucSmw44sd1uAo31tIeN9327IgVPrcHCkAS7wgMJy+/Qpn5fsXRCVWlyJtYFqEzpFvYdD+q/H7BQN8777hc6Vsn89A5MG5jW8hmbh0KdLaRkTK7mBgPw+81qrPRrAx47j+3BHTnDMVoiahFG3+VNcSRrJ7psTTI3AVR/2sBlWXgmv1sytYtFMMQuvhB7U5h2LljJ5K/IKe096WHtlTaiR4b/w6B6aO+YSLl4Mstb4jvg6/D2oaPSDIvjXQCV4g7YdjF1WpNieTHzRWU4wONlDEaAiijZDquzW5yCX9DesWl6HeWzdjOwpVdxSVntwk9gKETMaJgUZ7PC5U+zqbVWLeKRI4Lz+pryrUptgG6v90Zi9LEFLjfm44jpS2WGzf8pNV4eChAzUkDzNeSgAto4eOkWQBTAn/vtYmwfT/nFXPKdBrBTDIcD9bvn13h
 ihtFDQLj
 mSYnQ+N8mm47E/rvl6WvpPq/4PlQsPWR3iIxOWIrmcybQDcza33tBr6/rnriXfsSoVfMvUShsfB8yKn/WHYsw8R6O7fKhsAr167Bz40JA6kI6wKZl+wITcz73170/SL4bsKq3NV4qNtpBTleRy4dLlvT6IB/EFqDDEORczKdi3DYoTHlFP5iMt78PC7sLKbn2bscwT4L04xY3lLKQ8VDbvMA/sfToW7wpn6R2E7fLDQoXpi6LzjNq+Q+pkzZsDah3AhhethEj54irw0aQOzkYZdgGoc6gU4FXDFMWyCyFAceu1hjDGIr42Ko20Hlo7inMzYef4gIvXBHLFFMUuTDUve2hY97vw36EIK9Nyh1xijH909+wbp6gpij1/LjHi4AO+F4M4SzG0HNkPt8dalHxU+E1evUWe3hwBb81McHM+Vb5Ihw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Freeing swap entries is expensive when unmapping a VMA that holds many of
them. `zap_pte_range()` eventually calls `zram_slot_free_notify()`, which
frees one compressed object per page. As a result, the unmapping task
has to pay for every `zs_free()` itself. On Android, this slows down the
exit of a task killed to reclaim memory, precisely when that memory is
needed.

Two earlier attempts by Lei and Zhiguo introduced a new thread in the MM
core to asynchronously collect and free swap entries [1][2], which
seems overcomplicated. Wenchao's RFC v3 [3] moved the deferral into
zsmalloc, but introduced push/drain callbacks that zram and zswap had
to implement, potentially violating software layer boundaries. This v4
RFC defers freeing inside `zs_free()` itself, leaving callers unchanged.

Patch 1 makes `zs_free()` append the handle to a per-CPU batch of 64
handles instead of freeing it immediately. Once the batch is full, it
is handed to an unbound drain worker through a lockless list, and the
worker frees the objects. Releasing empty zspages is also deferred to
the worker. If the per-CPU state cannot be allocated, `zs_free()` falls
back to its original path.

With the zsmalloc work moved off the unmapping path by patch 1,
contention on atomic operations in zram statistics becomes significant.
Patch 2 moves the contended counters to per-CPU storage.


Using the following microbenchmark:

// SPDX-License-Identifier: GPL-2.0
/* Times munmap() on a region pushed out to zram: MB. */
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <time.h>
#include <unistd.h>

#ifndef MADV_PAGEOUT
#define MADV_PAGEOUT 21
#endif

static void die(const char *what)
{
	perror(what);
	exit(1);
}

static double now_ms(void)
{
	struct timespec ts;

	clock_gettime(CLOCK_MONOTONIC, &ts);
	return ts.tv_sec * 1e3 + ts.tv_nsec / 1e6;
}

/* About 2.8:1 under lzo-rle, objects in 16 size classes. */
static void fill_data(char *p, size_t bytes)
{
	size_t i, k, n;

	memset(p, 0, bytes);
	for (i = 0; i < bytes; i += 4096) {
		long *q = (long *)(p + i);

		n = 106 + i / 4096 % 16 * 8;
		for (k = 0; k < n; k++)
			q[k] = k * 8 * 2654435761UL;
	}
}

static char *prepare(size_t bytes)
{
	char *p = mmap(NULL, bytes, PROT_READ | PROT_WRITE,
		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

	if (p == MAP_FAILED)
		die("mmap");
	fill_data(p, bytes);
	if (madvise(p, bytes, MADV_PAGEOUT))
		die("madvise");
	return p;
}

int main(int argc, char **argv)
{
	size_t bytes = (argc > 1 ? strtoul(argv[1], NULL, 10) : 256) << 20;
	char *p = prepare(bytes);
	double t0, t1;

	raise(SIGSTOP);	/* ready */
	t0 = now_ms();
	munmap(p, bytes);
	t1 = now_ms();
	printf("%.6f %.6f\n", t0, t1);
	return 0;
}

Performance results:

ROCK 5B+ (RK3588: 4x Cortex-A55 at 1.8GHz, 4x Cortex-A76 at 2.4GHz,
performance governor), single process munmap on A55:

  times in ms, speedups over base
              Base       Patch1       Patch1+2
  size        time    time speedup   time speedup
  64MB       13.81    3.62   3.81x   3.28   4.21x
  128MB      28.50    7.18   3.97x   6.49   4.39x
  192MB      42.19   10.71   3.94x   9.69   4.36x
  256MB      56.06   14.26   3.93x   12.89  4.35x
  512MB     109.50   28.43   3.85x   25.66  4.27x
  1024MB    217.10   56.70   3.83x   51.15  4.24x

Same machine, single process munmap on A76:

  times in ms, speedups over base
              Base       Patch1        Patch1+2
  size        time    time speedup    time speedup
  64MB        5.59    1.58   3.54x    1.49   3.76x
  128MB      11.86    3.16   3.75x    2.95   4.02x
  192MB      17.18    4.72   3.64x    4.45   3.86x
  256MB      22.89    6.29   3.64x    5.87   3.90x
  512MB      45.15   12.52   3.61x   11.64   3.88x
  1024MB     89.16   24.75   3.60x   23.12   3.86x

x86 (Intel Core i7-14700HX, P-cores locked at 2.1GHz with turbo off),
single process munmap:

  times in ms, speedups over base
              Base       Patch1         Patch1+2
  size        time    time speedup    time speedup
  64MB        2.87    1.50   1.92x    1.14   2.53x
  128MB       6.00    2.93   2.05x    2.21   2.71x
  192MB       9.33    4.35   2.15x    3.33   2.80x
  256MB      12.51    5.78   2.17x    4.38   2.85x
  512MB      24.96   11.39   2.19x    8.62   2.90x
  1024MB     50.19   22.78   2.20x   17.05   2.94x

1-4 process munmap of 256MB each:

  times in ms, speedups over base
              Base       Patch1        Patch1+2
  mode        time    time speedup   time speedup
  1p         13.18    5.78   2.28x   4.35   3.03x
  2p         25.83   14.41   1.79x   4.57   5.65x
  3p         35.70   22.14   1.61x   4.68   7.63x
  4p         44.25   28.71   1.54x   4.75   9.31x

[1] https://lore.kernel.org/all/20240805153639.1057-1-justinjiang@vivo.com/
[2] https://lore.kernel.org/all/20250909065349.574894-1-liulei.rjpt@vivo.com/
[3] https://lore.kernel.org/linux-mm/20260508060724.3810904-1-haowenchao@xiaomi.com/

Changes since v3:
- Defer inside zs_free() only and drop the push/drain callbacks, so zram
  and zswap do not change. Yosry and Nhat objected to the layering in v3;
  Nhat also pointed out that v3 leaves torn-down entries on the zswap LRU.
- Buffer handles in per-cpu batches of 64 allocated on demand, instead of
  per-cpu pages rotated through a preallocated pool.
- New patch 2: keep the hot zram statistics per cpu.
- Link to v3: https://lore.kernel.org/linux-mm/20260508060724.3810904-1-haowenchao@xiaomi.com/

Changes since v2:
- Use per-cpu single-page buffers instead of a global list; the hot path
  only writes into the local CPU's buffer with preemption disabled
- Add a page pool for buffer rotation: when the current buffer is full,
  swap it with a free page from the pool and queue the full page for drain
- Introduce push/drain callback ops so that zram and zswap can each define
  their own element size and drain logic (zram stores u32 slot indices,
  zswap stores unsigned long handles)
- Drop the lock optimization patches it will be submitted separately as
  part of a dedicated zsmalloc lock contention series
- Link to v2: https://lore.kernel.org/all/20260421121616.3298845-1-haowenchao@xiaomi.com/

Hongfeng Chen (2):
  mm/zsmalloc: defer object free to per-cpu batches and a drain worker
  zram: keep the hot statistics per cpu

 drivers/block/zram/zram_drv.c | 171 +++++++++++++++++++++++++++-----
 drivers/block/zram/zram_drv.h |  16 ++-
 mm/zsmalloc.c                 | 182 ++++++++++++++++++++++++++++------
 3 files changed, 309 insertions(+), 60 deletions(-)


base-commit: f4e9810097537d862c128935c36216bcf0c31cb2
-- 
2.54.0


