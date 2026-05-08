Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02E51CD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 06:08:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0B6E6B00F5; Fri,  8 May 2026 02:08:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE31C6B00F6; Fri,  8 May 2026 02:08:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD32D6B00F7; Fri,  8 May 2026 02:08:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A52AE6B00F5
	for <linux-mm@kvack.org>; Fri,  8 May 2026 02:08:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F08F81C152E
	for <linux-mm@kvack.org>; Fri,  8 May 2026 06:08:34 +0000 (UTC)
X-FDA: 84743223348.07.AD105F0
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1C27BC0010
	for <linux-mm@kvack.org>; Fri,  8 May 2026 06:08:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="f//YM4vt";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778220513; a=rsa-sha256;
	cv=none;
	b=lV7AJ57yXpGTD/BvTWUhwhQqwCycSvtim48xZonWrLKr+VyNqFLCsxpqrPU6RqsYz9nu5n
	imY/wEg6cPQ6jxE/bgUtEpCVNdgcaMHO1kNiI12k74GDy49v0gKN6S5OZ+up2ZWHnY6chE
	DZIPy2kR8K0wWy15AXKo8GbJo1daSFs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="f//YM4vt";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778220513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NO9fgxc/4uI9ijrHR/+VJ2Jv5ttegtV3BGSa2bNu9og=;
	b=s0nGtqq/+lOhVsoJfM2iJaejcJZC67g2oMLoZnifxX55eSA/jq9rFXDhEGUPjxUirc7VbX
	BZTwftLTw1Q6OMOfmarqLRctczXyhw2SihIpqhsct2zlOVa3r5wvLUQv8FGvd/t4ol5j0U
	GN9txaoAg91tja4XkmjRz/xfUb6pKxk=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3660daea6a5so796596a91.1
        for <linux-mm@kvack.org>; Thu, 07 May 2026 23:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778220512; x=1778825312; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NO9fgxc/4uI9ijrHR/+VJ2Jv5ttegtV3BGSa2bNu9og=;
        b=f//YM4vtfP8g81ZECtB/n//SG5NTAYZ+qOIdOfwzOjEdNRNs/mFK4J2gAj2ZZp0AcR
         k9n780aEx8fbbYqR7D+Koxi0O6QTWwDpIqa/pSe2kKgXSX8M6yFo0OgsJwlnxWiDbKz9
         +dnqi0KjOMyqIRBHXfP8fLtfQGp1LH5PFW/TnERWzIrtgDB4zt9IBMW3agGwVUksz9DT
         fPf2oBXXGFozJNqTEO/nfDawbJcVkwx6PlLhKOANeoWyfLZVTFfxiWRgyX692YhleDMI
         fEpUCnfNMw82IB7GIxqvVIGb1dlNJ74TAX+BCoxflgnA5PmQwkX0SUQ0TYQudrXEVJ2m
         lIqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778220512; x=1778825312;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NO9fgxc/4uI9ijrHR/+VJ2Jv5ttegtV3BGSa2bNu9og=;
        b=qAK9a6YlvMoCUfonR0DTAIb9IUeDckaBow4gFKlq0ZIQg4cOuWi8mtAEoZVWls8hEv
         yv1hS5lwcx3oxTL5Miy5H0PWC6I1QAunMMF5nCiziYqPmteLaotp1DyIqJNTYZo5V/A2
         KZ4ukolemfcvWaL810I0LvUSeosR58wLvXtyk+bpITnxvgxtcvlfuWOMj92SueXetsrJ
         nP3yyJlwKKDb3YCtRKhi8uaPBILN8FaNJ6eGNI3JsfMUga113mb0ieF5lEJ1C/o2qesz
         JfFSN9ITijW3cmNsQ17rhu/iZGErF6kiEcoH/gOqv03H64EnGj7EiGy0Oi2LxBcjicyQ
         +59A==
X-Forwarded-Encrypted: i=1; AFNElJ+CtCOOt/gPbuJwBb3CnxuBZo9rQMPN0zBn3DWem6wCcSEIh4j1FYb6cLnkh1xZFwXcvRoB4iYGzw==@kvack.org
X-Gm-Message-State: AOJu0YzNPGfUQ/j8wxd7yP5KdmEBwh0Xpz3/xdRPVLMwZlT5GXFkteb1
	g7B9AlW+ri6V84qffpL3TTNtJIoDwmJ8g82uXehw8+lQOUsu4nJI1DYx
X-Gm-Gg: Acq92OHWI66mr58iZWH1Q+xIEWLtonrd0NFqN5BpxPq9a8/qA7WhB7XBRQ+U+QOIPVr
	iGPvoUwCggzZTJCblpW2Mw6uBND0DQKcuucEUboBqwNu+p4GqO06BTTTfZ27BgMZV2VdT2MnwbD
	9D4DTE1NEbDhG9GeBulQ5BPb6ONJ/CkOs1YFssn0Xdvd3bXDQDBp0g9ATAzrBcYjrxLs7kltx1F
	Q3r0eQ2dyubDjzDUMLkoHMiuDiYpKfmSJttoOkD9jVvdVypFfBo+J5aIbIpiE8r2PsfHeNWeLts
	LkaGsVjappi+S9ElbNPQKz80Zb1bc5e9ye8McA7jPX9J1jtLsmMcoHEvAi1hXBd4XE0KK4NIULf
	6/u88jyB7L3V/305Yi9l8Tazomn85E9KH5Dwp/hqvPCnh/in3kqmQrLb1XUx8FikwpIgoE1sVL2
	SiimYe5FgbKwMf9wnCF1cXaXrO4jAnoaLhbJ6SjsEsek05Wq4J
X-Received: by 2002:a17:90b:4d90:b0:365:b93a:1ebc with SMTP id 98e67ed59e1d1-365b93a1fe0mr9875584a91.3.1778220511629;
        Thu, 07 May 2026 23:08:31 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36645bb9c02sm673651a91.1.2026.05.07.23.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 23:08:31 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
X-Google-Original-From: Wenchao Hao <haowenchao@xiaomi.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <21cnbao@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Minchan Kim <minchan@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Yosry Ahmed <yosry@kernel.org>
Cc: Wenchao Hao <haowenchao22@gmail.com>,
	Wenchao Hao <haowenchao@xiaomi.com>
Subject: [RFC PATCH v3 0/4] mm/zsmalloc: per-cpu deferred free to accelerate swap entry release
Date: Fri,  8 May 2026 14:07:20 +0800
Message-Id: <20260508060724.3810904-1-haowenchao@xiaomi.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: iwt31iwj7syw7quu3jt3999tjiypnwow
X-Rspam-User: 
X-Rspamd-Queue-Id: 1C27BC0010
X-Rspamd-Server: rspam07
X-HE-Tag: 1778220512-130984
X-HE-Meta: U2FsdGVkX1+d3EMAkRrvBMtsNMXUcAegaoxhwAHY7iE7IzQ7BuAF4qZ7V+9KhkXoWkeS3JMDEPplUhFei5sPKKuMIGVMM1b/vE5fgqXl2zFJ/puGfYhUFjtwZNblfN+97X/y7enrcXbw49QgdRCbY5fG1fj8w4k68cIDAuvgrcEdMkZLVuxXTYWCerPlXLfSKsbqlYJwvIcUeiHR1I0w99yzfb2Qa7WKytZY9CScEw5+zcnN079Ez8LJ7mhe6NwmIeEvtFuVzw9aQbw+jYrmlOtuHFkHgZyYR7xyG7Fonf4lUteoypO2KdA6/cPZLlTtAIOaZYQWsBiKjK4OEaWcqNSLcoMfH/2Oii6vLjR2pEsgoyUDUsLBbXa/+7vXywsEGeNZ0r+W9z/LsSmuzw/SbjLnEwkdFja2+bHZYXkpD1nOM0Z6yX0O1F6Ou67fLvGYYkXwPS9qHrKi4efMNuRJ7ZciLfJrjhcLwvcUhBJo+o2+3bZLz6593Mw2fLTQol8SeT8Ww8uKDztivTWa5oPNpTGp5XbO8/APMX1W1dp3sIBIhSFB2dAlpsLmVwaMPCf+qNcVDqwJZxG4BLaUo4AkHBbrGFIepVNYVue+t2WovcZlm6eln3daPknIAiw5oEKhKY30jX679adcKmBKzdeNnYsWfitFWkplGw9q4wSHhusxRZqrzi5XX21xfG6zM6kQQwX4ebtrJxUH84OT39A132OJmiSno8q0D7pLsFT1owASYcIJeVaMRpRBdxPfmANOFusigyygWgEXo+e2Di0+4ZbpEquZVuh3dYPNTBk0z9Z/15d7/0sWVK8AXKoTOLXwQw+M+zf3O6YeZTbOpp/ijTBK/CkU2Jl802LOUdbMBRfB2hmixeGed+jN90vAM4npfr1ZVIzigByFbyWZRJQluIwy2oQ3oCfjfMM0I4tVqq0jFCjF0MdcOi/QqN+DG3DW+UzSLA5seVxGXlZU2/I
 FL2V/P8r
 tO1axsicokkDN2AEUA+rDbr6ARrOX47dlLite7nAuWcTzvKcA1YXXZyhlVktrBgTQ+l//Z1bLyaHaV1kPuC3monR+jC/+f53sWBWXkGdTrYUdEtIn8VuH4Kull6qvlYAp++ML7qA6JwI5vzZORaFvpdmemNE/Ulzsu4+uYC5vOk+Q4jPNElq1QXIl/Jo9XxPQmW6fsyHpcfFJ+Z6tkUwFwmGy/zH89k+khux+sP1jDYaC8+gGqNNY9cYd6R1pSD7kPtAkAd7UR5ago1iFvcbAzsjov58gSXCvnQDr0V03OSRgC4r6pYNAi9P+gIIQcsOSBhOkAw0Or0wm9Kz8CJ82c/Dm5Wu49cc6HHo8acSMk1pRlLjAyVY4bfiGO3qFXTyHNn6dNYeSkaUql/ceNQ7sCU8J3hHtdzaY0H6PkhVufQJfGSWQOZ+OIafPHBdsybxYJa0fPBjmZBVB1sJLyyZNM2NNf+YaiKc0YdOw2q5Wjin1u92tvwVzkc6RI4qF7EsvdcmPVL7lVJjCMJo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Swap freeing can be expensive when unmapping a VMA containing many swap
entries. This has been reported to significantly delay memory reclamation
during Android's low-memory killing, especially when multiple processes
are terminated to free memory, with slot_free() accounting for more than
80% of the total cost of freeing swap entries.

Two earlier attempts by Lei and Zhiguo added a new thread in the mm core
to asynchronously collect and free swap entries [1][2], but the design
itself is fairly complex.

When anon folios and swap entries are mixed within a process, reclaiming
anon folios from killed processes helps return memory to the system as
quickly as possible, so that newly launched applications can satisfy
their memory demands. It is not ideal for swap freeing to block anon
folio freeing. On the other hand, swap freeing can still return memory
to the system, although at a slower rate due to memory compression.

This series introduces a callback-based deferred free framework in
zsmalloc. Callers (zram, zswap) register push/drain callbacks to
define what gets buffered and how it gets drained. The entire free
path including caller-side bookkeeping (slot_free, zswap_entry_free)
is deferred to a background worker.

Implementation:
  - Each CPU owns a single-page buffer. The hot path writes a value
    via the push callback with preemption disabled (no locks).
  - When the buffer fills, it is swapped with a fresh page from a
    pre-allocated page pool. The full page is queued to a WQ_UNBOUND
    worker for drain.
  - The drain callback performs the actual expensive work (zs_free,
    slot_free, zswap_entry_free, etc.) in batch, off the hot path.
  - If no free page is available, the caller falls back to synchronous
    processing.

The speedup comes from moving expensive swap slot freeing off the
munmap hot path into a background worker, so that intact anonymous
folios are released back to the system without blocking. The worker
drains at a slower rate since compressed objects are small and freeing
a single handle may not release an entire page until the zspage is
fully empty.

Performance results (Raspberry Pi 4B, ARM64, 8GB RAM):

Test 1: munmap latency for 256MB swap-filled VMA (zram backend)

  mode        Base       Patched     Speedup
  single      61.82ms    8.62ms      7.17x
  multi 2p    94.75ms    54.11ms     1.75x
  multi 3p    154.64ms   104.83ms    1.48x

Test 2: munmap latency for different sizes (zram, single process)

  Size       Base         Patched     Speedup
  64MB       14.11ms      2.18ms      6.47x
  128MB      29.45ms      4.48ms      6.57x
  192MB      43.85ms      6.62ms      6.62x
  256MB      57.01ms      9.08ms      6.28x
  512MB      115.13ms     55.58ms     2.07x
  1024MB     229.66ms     153.28ms    1.50x

Test 3: munmap latency for 256MB swap-filled VMA (zswap backend)

  mode        Base       Patched     Speedup
  single      152.14ms   51.26ms     2.97x
  multi 2p    186.56ms   105.42ms    1.77x
  multi 3p    205.83ms   153.32ms    1.34x

Test 4: munmap latency for different sizes (zswap, single process)

  Size       Base         Patched     Speedup
  64MB       37.83ms      13.26ms     2.85x
  128MB      75.11ms      26.73ms     2.81x
  256MB      150.78ms     52.97ms     2.85x
  512MB      303.04ms     130.38ms    2.32x
  1024MB     599.95ms     287.10ms    2.09x

[1] https://lore.kernel.org/all/20240805153639.1057-1-justinjiang@vivo.com/
[2] https://lore.kernel.org/all/20250909065349.574894-1-liulei.rjpt@vivo.com/
[3] https://lore.kernel.org/linux-mm/20260412060450.15813-1-baohua@kernel.org/

Changes since v2:
- Use per-cpu single-page buffers instead of a global list; the hot
  path only writes into the local CPU's buffer with preemption disabled
- Add a page pool for buffer rotation: when the current buffer is full,
  swap it with a free page from the pool and queue the full page for
  drain
- Introduce push/drain callback ops so that zram and zswap can each
  define their own element size and drain logic (zram stores u32 slot
  indices, zswap stores unsigned long handles)
- Drop the lock optimization patches it will be submitted separately
  as part of a dedicated zsmalloc lock contention series
- Link to v2: https://lore.kernel.org/all/20260421121616.3298845-1-haowenchao@xiaomi.com/

Barry Song (1):
  zram: use zsmalloc deferred free callback for async slot free

Wenchao Hao (3):
  mm/zsmalloc: introduce deferred free framework with callback ops
  mm/zswap: use zsmalloc deferred free callback for async invalidate
  zram: batch clear flags in slot_free with single write

 drivers/block/zram/zram_drv.c |  44 ++++++-
 drivers/block/zram/zram_drv.h |   6 +
 include/linux/zsmalloc.h      |  16 +++
 mm/zsmalloc.c                 | 208 +++++++++++++++++++++++++++++++++-
 mm/zswap.c                    |  38 ++++++-
 5 files changed, 306 insertions(+), 6 deletions(-)

--
2.34.1


