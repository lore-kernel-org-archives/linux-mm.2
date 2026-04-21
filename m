Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F450F8FA66
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 12:16:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 566FD6B0088; Tue, 21 Apr 2026 08:16:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 517F66B0089; Tue, 21 Apr 2026 08:16:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42D6B6B008A; Tue, 21 Apr 2026 08:16:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 300CD6B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 08:16:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BE2795CA6A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:16:35 +0000 (UTC)
X-FDA: 84682461150.10.8B58EBF
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf17.hostedemail.com (Postfix) with ESMTP id DE2A140006
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:16:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=i4F6CkfM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776773794; a=rsa-sha256;
	cv=none;
	b=kh6eolkuJXhOnEil9hAsSmJxZUDSMIm5vMgV68tunI3enCyj5WL+hcjfTWYYWYuMy4giFn
	o+YkBQxEMVab6X+bQJw8SV9RqiG0dzJnJAHp4aXC1cAQByq5Q9mUhQU8km2n0CtIYhEsnG
	lCSMOKbGwyxqKgs6PPcRyGnrgkdnLFs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=i4F6CkfM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776773793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XTX90kBWYPlf5c0l3p/5jjfTkLXTd7XpDQpkztEEKcw=;
	b=3EIcjreXqDsbj4bNo/B/MultV233lWotx42E2l0dMr3M0IhNYZy6CIDLq5ukxvBue50tIh
	jC3mGER1h5iAYoT/GyVzPkASQvBax1Rje51AdxFNHf/s677nbMwKsP4Vnxu0zHeKD46mIs
	rQ0epxvqF2OT02ux19Wm9PmRkCHs7Z8=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-82fcd0aa2dbso312937b3a.0
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 05:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776773793; x=1777378593; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XTX90kBWYPlf5c0l3p/5jjfTkLXTd7XpDQpkztEEKcw=;
        b=i4F6CkfM4iqyIyCNFBikaJjs7yiA5z6GjpPQa4ZzQ2ga9DmdDHMHYkbNWdy97T1p3N
         hy2ql72rnlSXTK7Lhr9CIp/jL/qpA3qhu7gPelB3mSynUnhxjw++R/WX7eWErrTg761g
         3zlPBNDqrNWAJyQ57WVKKG8YxhPdomX3KBuP85wi4SL98p3w6F0GgMr1o/3lhBneXokD
         wlo8ZeKjdNLR3SIOtfVhC9Dnvq2402Fy0T9aFpuDZnaQzxASf/K0HIn582na40KFdGvG
         7RismZ1bVZDQCUZhRjmh705kPlE5MOg2ZphLqulpxJBwtV0WaEspSvq/RuIHLQWIxR4y
         BNJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776773793; x=1777378593;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XTX90kBWYPlf5c0l3p/5jjfTkLXTd7XpDQpkztEEKcw=;
        b=VYUk6TPuyDo8zcR8tx7wMQdV3b6oM3iPfZmrW6sfxbvtNaORInqNwU/WODVVlLb6fI
         sWv8+9LghFfOvreYdVnkhzuIHsQRCR1rBn8OF5hodegFeC+I1Bs8DQM8yw13jf84CakX
         oQR2UgjmdGj500kQE4Ma3bszdYJ5xLe4ExtmdRxxHkC427F9DumAcdbyfJmb5f/2ugud
         Fd15X9yFI6j+4quUjc4fFvolllWkFsNJbwKCZEfyjsoPlMQapKBpelBm4ZxERhYgp9pt
         ryxbhoSCFDR8L6Hli8wfOx9p3evhFH/uSuC6pDqLx/dMpoiH6AdhVq/bUmxXZ0Y4YXiA
         Ktyw==
X-Forwarded-Encrypted: i=1; AFNElJ+59fgBsTYWJvUwLccOg6NCnLaJ9JNNtwVgF8ugWbuMNg1vimAjN0Lm1CIPttElT0i8Az4v3Hmk4g==@kvack.org
X-Gm-Message-State: AOJu0YzBovExRlFniei3yeIuanruO0rNpHJTJqZ9WBA+4XoUipo01cad
	2Q4FgrWTiDrqpYfw+RZLodLWvXLC+AetvM611uvsv5eN/N3ePqhH3Y3/
X-Gm-Gg: AeBDietn0IH3dB42sznOlvkeHE/0D7eVbnoS3ps8Ml/jRRPG750UVyvRSuO0FFMkLzv
	3yPgyaTWw8RCsRxjH+szyxbYJTc8dS/DGeqmGpyDtL44Obb5l7VXX3duby2TC6WgA3tVZoGOgbr
	0hnUlVFxHQU6wMljUaNMViDe9hqRcUyfYUVjNQ5moD0iZQSo+E1zxKFhgAcPnyU9YcEUCC2Uz0U
	7Zx6YRIvOxBGlZPwe/Fisg5T2tpCpst6s2EdVcz9enU8ru2Uo5NITrTbpKPr7pzGiHkq+1T+ywo
	05BZOvTQQIfWp+iE+1JHtmMtLnOC2jQqunLJPq31vfz0tmZx73ZPaJCx9y0oAihUdNp/WN58+vK
	u0A1Td4jcSycYe1PYkh9HpRPxPEYJ2vU0EADbh5PNhlKxYluv0J+zzAeVbIoFT/rZWQZYUFynFM
	VeNvRNHw3SaFXKPz6r7uefU0D4b4756dEsW1YfFELho4q96YY=
X-Received: by 2002:a05:6a00:9291:b0:822:69b2:7ed0 with SMTP id d2e1a72fcca58-82f8b370621mr15308948b3a.6.1776773792646;
        Tue, 21 Apr 2026 05:16:32 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ec037e1sm16371071b3a.54.2026.04.21.05.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 05:16:32 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
X-Google-Original-From: Wenchao Hao <haowenchao@xiaomi.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Minchan Kim <minchan@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Yosry Ahmed <yosry@kernel.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Barry Song <baohua@kernel.org>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	Wenchao Hao <haowenchao@xiaomi.com>
Subject: [RFC PATCH v2 0/4] mm/zsmalloc: reduce zs_free() latency on swap release path
Date: Tue, 21 Apr 2026 20:16:12 +0800
Message-Id: <20260421121616.3298845-1-haowenchao@xiaomi.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: jwssik9erodd374t5tzc5peoudnpguje
X-Rspam-User: 
X-Rspamd-Queue-Id: DE2A140006
X-HE-Tag: 1776773793-690722
X-HE-Meta: U2FsdGVkX1+R7+EH2aAnrPl+U64hz4McXcq+x1bvELpkMkBD6ynQzBNn+ZXRbFEeN8/cYKjP0jyKn4sMLsjEAOajgB1vTqe4xOioQ2vWE5/gC4bdQj7XYJ5zrm07v3NQiVMWYoNHqQZBYiUFhQpZH+4JyitDERi7jy3HPjfDEznsnH29sHBBUvuxchAn3QdxqUNuJZxe7hitFkDQYoyhbPXDu8fyLthXFCU4jo1CS85RSxkjDuG87RqBHlohxUPcQx5ux1nQn82CkxY/lzAHWXUmEJ0tIIzsKpvhPj3Nq1VqG8VW7VCbBqT0GaOV9rUo3bJK7tgKZDT2gM5/RqC+tZuhcKynJIdavniK+5hjHgb/yHuwolS1xivmZ5iHFLIDadC8Ut4vsPh0fJqRZlaYRberC4FkUmSKxG6xcBMrA4dUIaS2Qm562UumMwt5QEogyOA9QtKHraPO+IH/vdIZfcY3y/mLl8+1+Jb+qzzkDKmKrBIMgOf1JvjIxOpJ+bbD2u4zY+TGigHnPM9UfF2CuK5NFbsMX7ZfpCRnZKQkBE1QJm/vu/OcJ99VrJ+WdcqDt4Ta3oUIENV2jIMnBf51Rmnu0ecOkqZ+ZfR9iRKI4cJiRNQ1HDZFbr5YvTOFOK1tNzNyuwU86LTMLVraldQbqsBxTFV+a9lvHGYypF6D70dkAf/ozuby1M72AuGmR1mLrDoJRbhfjhVvNVUWQRxTO7vWeU+hw2TQPEFRpBPAs7aOzlnZXZiJCkpNVlaO01ydga4hRjvR/EqJts7Fzp3nn5VyrhwGlANaa9cM4kCWWFoNUoh6l8/2C1/Gt0mUhlvB9nzonVoQFoNjni1EJtiwz6e6qMWguFAIJ08eF4hLqg5oVzGyx92eKhL16odTR0DACfAMtzuLSP1pCO2/sJrWabD8/AFi1jnzf8KgRYFkT4QKzeZtlynVOOPsy7FnKkG3ehJxhWBOCAjiPI/whoD
 G4FKea3p
 xdpa5YADGom43EvkZPTf3lHrkEe8EPFS5yGPhK1TyoJV2NIgWw8SUEYbkjkZiu/3UtAZiKa6zvLUzeT0OjPwM8x6VNPwIjvz93BJ9S1BnVajggYOLE+IiJ72oLEmur73fF/DzV9q3QEdDUeGiWTGpp+ytVEa9dVe4bdxGWA5yZpvTFmfOPIUZB9yAD6WoYvpK/+nYMkJLehVDT0uUCPVZ9pytFHvvN326I6Gjc6x3dSZACDaLtqKBmJjVXGh8OH+P3TuaB0sjy3ZFskiL4lEZgLpvhKJa4PqTl+WkynEZxnr+Z3Pg/9cglrffpAE7chwyfDlaj2BdkN7zWNahKw7h4I/HunXUGc6aoVBrErgLKFWI4FVfQGFbR3FYyUl3XAiPSNwmrlDSZ978m4muReW2Kp9OxI0oB2GqM1eXsFZWYWKTd0mhW/t4DIaQb6yyfIWBeK8QoQhGWRpbCDgQzgg8qIAEdnR26ZiHq3A1n0U4MMiZeUoyGAQDLNkjAb8lBbypMzNDacf9sd1foVc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Swap freeing can be expensive when unmapping a VMA containing
many swap entries. This has been reported to significantly
delay memory reclamation during Android's low-memory killing,
especially when multiple processes are terminated to free
memory, with slot_free() accounting for more than 80% of
the total cost of freeing swap entries.

Two earlier attempts by Lei and Zhiguo added a new thread in the mm core
to asynchronously collect and free swap entries [1][2], but the
design itself is fairly complex.

When anon folios and swap entries are mixed within a
process, reclaiming anon folios from killed processes
helps return memory to the system as quickly as possible,
so that newly launched applications can satisfy their
memory demands. It is not ideal for swap freeing to block
anon folio freeing. On the other hand, swap freeing can
still return memory to the system, although at a slower
rate due to memory compression.

Therefore, we introduce a GC worker to allow anon
folio freeing and slot_free to run in parallel, since
slot_free is performed asynchronously, maximizing the rate at
which memory is returned to the system.

This series takes two complementary approaches to reduce zs_free()
latency:

- Shrink zs_free() class->lock critical section by moving zspage
  freeing outside the lock.
- Defer zs_free() to a workqueue via zs_free_deferred(), benefiting
  both zram and zswap.

The deferred free approach builds on Barry Song's earlier RFC [1] with
changes based on community feedback: optimization moved to zsmalloc
layer instead of zram; fixed array storing handles (not indices) with
O(1) enqueue to avoid memory allocation on the exit path and data
consistency issues on slot reuse; size-based capacity scaling with
PAGE_SIZE.

Xueyuan's test on RK3588 with Barry's RFC v1 [3] shows that unmapping
a 256MB swap-filled VMA becomes 3.4x faster when pinning tasks to CPU2,
reducing the execution time from 63,102,982 ns to 18,570,726 ns.

A positive side effect is that async GC also slightly improves
do_swap_page() performance, as it no longer has to wait for
slot_free() to complete.

Xueyuan's test with Barry's RFC v1 [3] shows that swapping in 256MB of
data (each page filled with repeating patterns such as "1024 one",
"1024 two", "1024 three", and "1024 four") reduces execution time from
1,358,133,886 ns to 1,104,315,986 ns, achieving a 1.22x speedup.

[1] https://lore.kernel.org/all/20240805153639.1057-1-justinjiang@vivo.com/
[2] https://lore.kernel.org/all/20250909065349.574894-1-liulei.rjpt@vivo.com/
[3] https://lore.kernel.org/linux-mm/20260412060450.15813-1-baohua@kernel.org/

Xueyuan Chen (1):
  mm:zsmalloc: drop class lock before freeing zspage

Barry Song (Xiaomi) (1):
  zram: defer zs_free() in swap slot free notification path

Wenchao Hao (2):
  mm/zsmalloc: introduce zs_free_deferred() for async handle freeing
  mm/zswap: defer zs_free() in zswap_invalidate() path

 drivers/block/zram/zram_drv.c |  37 ++++++---
 include/linux/zsmalloc.h      |   2 +
 mm/zsmalloc.c                 | 141 ++++++++++++++++++++++++++++++++--
 mm/zswap.c                    |  16 ++++-
 4 files changed, 177 insertions(+), 19 deletions(-)

--
2.34.1


