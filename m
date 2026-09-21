Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E2C5C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 12:07:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 534586B00D7; Mon, 21 Sep 2026 08:07:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50C166B00DD; Mon, 21 Sep 2026 08:07:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 421326B00DF; Mon, 21 Sep 2026 08:07:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0DDFD6B00D7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:07:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 954731A017A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:07:06 +0000 (UTC)
X-FDA: 85237643652.15.CFD4F28
Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0D44E20005
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:07:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="JSXk/cX0";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf13.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.228.43 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="JSXk/cX0";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf13.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.228.43 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789992424;
	b=d37yRwaCs9uJO7jKp1n+1vke8NLkaZycncSFa4Sh6Fkv19BygYELoXDDFCpk3cmRgIyHcQ
	6TMXe5Q0173cRt+3Ueg7rHMesnkAdcEj7G86cb5R4y1H3eNm3RpAW9N5usTUDBVlU0Z2h+
	vVgtT6Oj60ql773FxNTHjDT1OS6UKuI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789992424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4yFs7aKADwEnqQrd+7DVxwZtTJDiMzxWaAyfpMFtjl0=;
	b=10QJWO8rrppE8IJr1s9OGfEf+Mw3olfQDRLn7ajZ06Fl6GXa+yELBi7jqZ6twDIfKliZ0e
	mWCn9TZ2VPcCp3Ye95SCkZaqACYA02XYNE3M5v4nqZGC5IAuHT6/XceSviURagX0HmABVr
	Zdq6lBsN+8T1m6mIWWezW7iTHCdIYuE=
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-86212a185dcso3316060b3a.1
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789992422; x=1790597222; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4yFs7aKADwEnqQrd+7DVxwZtTJDiMzxWaAyfpMFtjl0=;
        b=JSXk/cX04MA/nO1vCLzxXB5oYsn73HfWB37wRFOOpXnc8T9lvC3fsg2OgRJiU0YJKM
         zzMl2qZrbB7Dlwr746OToTvTNlihtKCTw3h9NHSxu6V1nMyo60L93WVvK5+j/t8cIJ3k
         7qe7eLxTtpfx8C0G9zSrPkmeSgfnEji9f3HnNk3Inj/FHmvdzK+iOu8BHDxwj5DLGH5b
         eezEUi4VH84Yjv595ZK+OnVzfUAkGygicrTew7Dhx4AX5nUOwH+A6aZmuEljlN9axcf/
         G25WcOXQgoIK84EwTDulCsad+xzWiZOAWr7SHH2XsQmpAuzXLoc+dtM5lDp6KtZcq5Iu
         ycXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789992422; x=1790597222;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4yFs7aKADwEnqQrd+7DVxwZtTJDiMzxWaAyfpMFtjl0=;
        b=y8JfOiAr3FNKBtkkgJt8DkZUpxQCuKfL+p+O33Hh72stq1VMcXwhnZp6CqH1GBhvy6
         M2WrxPGnIQm6PlRNlObU544+HnJw0e4pkt+2+SNW/U72c2PXStq96Pw3ft6PFSZsM26k
         6aN8WsIbjZY3r3966h9KIh5D9rQJDdukF/glWIiVLCuSCxACmEm3ZYO6Fmt40x5o0zLK
         eM46gp3yc3aryujDyhFFd7UUVjHAgpgwd+Lw7vh31rgal0fqx4BOIrKp4w2VsfjkEmGG
         6J5rMZYlonq6QCaKip8mfHyCuBwIDW0uBYfJjCS9tE3ESgG7oKkghmb8n9pnVgNXl+xU
         IxnA==
X-Forwarded-Encrypted: i=1; AKwUvByqAq6iFX6G37JpaaroZAg2JIEnvgtT/EFPf46swGsihU7spjpw8PG4q433FntrrlRxB4vbGkaeyw==@kvack.org
X-Gm-Message-State: AFuF++krJ/DIZKv9FZ1tBh3wgxgBC/Eq9RJDfFVvahhDew3acwOyLrem
	5b4gOicwUyTIZ4evnanqK7f9r2PlgefI4Qa+W/KAuB60ThBI+oCC0B/o4EFtuJr+n44=
X-Gm-Gg: AYBFou3qJbs3YesvL9MvSzEia3XMZ6DSCPaYpj0zGYiVDIE+BSTwA38Qke9w8WzzbXQ
	5F6pWtFY6JYubXHjxdpnRl2bVdWi6EDWF3qpY8yzXdqQvM0otITjaQxJpJ/J8MvPJIAvpUdCMBo
	v+eCfypSjG0N3D5kg8wT4W71Hn8duodeNPnkfwsJjI4Rq0uoAcpy8MC6jEYgc2sTaw5SVdHLIdh
	YJz+zjdUT/03FezpGsalhgOh9FHImDi6fuR2MRI9KLiiLAtf0KX6Zu4a97DlRB8iP2TaNyxgxYe
	hkMf4faFqHPpV3oq8vsxw7S2Ry4D1CaX4hzJEoEwQDlhnnnfiGNiCHPfueCT2DfEVEeY/rCWjfY
	IR5baxfIKpp/CQgPjUIEI3U3178pdxy1I14ZpyMD+I/52QfchA2zz5F2Ftu1r6Bfm4DF4TlZatl
	pMs1XyHiICVvoHWW+iRjMRDB+GKKoE2O0Ck8R2wcI4KnPQOiDaKFLMmWo/qvYusB+rokfjpRFVB
	6Q=
X-Received: by 2002:a05:6a00:4517:b0:872:20f2:3282 with SMTP id d2e1a72fcca58-874de507ca5mr14569283b3a.22.1789992422298;
        Mon, 21 Sep 2026 05:07:02 -0700 (PDT)
Received: from localhost ([106.38.226.177])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-877a9b0c504sm3156937b3a.33.2026.09.21.05.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 05:07:01 -0700 (PDT)
From: Julian Sun <sunjunchao@bytedance.com>
To: linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Cc: axboe@kernel.dk,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	willy@infradead.org,
	jack@suse.cz,
	tj@kernel.org,
	akpm@linux-foundation.org
Subject: [PATCH v7 0/3] memcg,writeback: flush foreign bdev mappings separately
Date: Mon, 21 Sep 2026 20:06:55 +0800
Message-Id: <20260921120658.1627992-1-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D44E20005
X-Stat-Signature: jrsa8jwhp1m448bmtwqwztappohrmf6i
X-Rspamd-Server: rspam01
X-HE-Tag: 1789992423-37661
X-HE-Meta: U2FsdGVkX1+zJi9SJERL6srC6fgfAbNlYLs5ThQau49SfufvxqmBk3DsuHVsNMoKVW7dBl5jhYu2PZHAOMyddi5/P6B7iELgtJKCImlV2FOEHM6kHZgYSOAKlR+lZd1iIHe6xLTLyR1qDD9+iVa/NXGJEifppWdUVkbB4jxJvCWUqY0C69kmkDzHJuLS/szrl3vHEM5BnqEXZzA5o+CVIP6qJxOKI8CW8qRklTLGQmblr1gKjQXdio/MuKncBoVu83rxiVemOkqMq1Wcb7xlrKg9OlMPLzYCbzrLCoEhs1cpmqWjiFuzxSkRsMr66x7V14RFcsW5Nau08PcU3idnTHh1n4+KUlqZDq8dfKWw3Sic0yXkruerWUA/SMyXPgL5gAwnxlBqBVcAauIGFkSY1uNIIOWZk2AgJpXYpDHYIdAdcFWw7+M09sN/Mh3iMmZ2Vjd1xPi9ZpntHJGPzgyAPGw04yMr6EGN+FLDZa3KGcsGIAfJlyQmmFPcoY8uBdh2EOEv8fsAfC2mFC9guBWMJgMImsfk6J00C4dcq3yDuwLqaF63BnvC8wOrviWhnOsvFW8gZ7dAIrP/oD9GMZDp3forSgnNAuRIZOEasPJAmUa7BQwnBaXAsfWofZdUaaE7+dQiqJ/5rpPmR9mi4bKSmA/KODZw/5n+oRYCx64p3jMxnrOKtFntLpMdzUicKU66EHLZ3uLliEsnZVrnAD6OaeedmdWItuqXH2CJc7ZdN22dOHqQ+ew5QYf8lV0ARToqJlmW9NcgDB58veaPi0jFLRLxUx8Y49K6yYXOQ9Rk2SROIyxDKGkhEXOQj30d1kSqkUVF9rCHI/jGEKw0zJGamCpr4WpW3MJr0VHa/LzOOrD60auXHY+b39IVjCJdLE426NjDOTTGkYZXnyIOWkinmyezdSrzJ0rgMI8qP8yzh1nFiybKalPV3CdLUWG4ttE6FsVwretnWrkNKbUr9zb
 OPs98oW5
 xZW7ucqWbMi850UDYUC5Q61vBTE3wy24muxkmcPgWhjY2KyoCicoROrw5Yo4iflvXvNqD2kF8VhKFJ44vmI9umYMr544xWUAFKrgtecx8BWZGVumGNPCRRHyplAkSHt50zfOO2rL6mXBYwnQPDosm5X0m0UqyLpp33gxguWU0GMfTcPOsWlGZhZYftC8YIkjrWqugm9oHkk2D7Ya/UdeB2XBRrIurDHl56y0NcxSMYz+yGAQNTssoFKsNlG5NepElP9zpJON4xbBAoENHoxIOnsOv+dTJdsV/9KbaudkNftjnK50xAzcjltKemtM+AaZVOz+vdzwGtLh+L7o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

This series avoids owner-wide foreign writeback triggered by dirtying
shared bdev inodes. Instead, it tracks bdev targets separately and
schedules writeback of their mappings.

Problem
=======

Bdev inodes are commonly shared by many memcgs. Dirtying their pages
can cause the owner wb to be tracked as foreign, triggering writeback
of the entire wb rather than just the bdev mapping.

In production, almost all the foreign dirtying we traced came from bdev
inodes. Across our observations, a bdev mapping had as little as about
10 MiB of dirty pages, yet foreign flushes targeted the entire owner
wb. On one machine, we observed 599 such works queued on one wb, with
an average request budget of about 43 GiB per work.

Measured impact
===============

The synthetic test used a VM with 4 vCPUs, 8 GiB RAM, ext4 and cgroup
v2, with device write bandwidth capped at 200 MiB/s. Background fio
repeatedly overwrote a 256 MiB file using buffered I/O, while
foreground fio performed sequential direct writes. Four memcgs
generated metadata and buffered writes to trigger foreign flushes.

We measured completed block writes to the background fio file,
including final sync, and foreground fio bandwidth, latency and
completion time.

Across three runs per kernel, mean background file write I/O decreased
by 72.7%, foreground bandwidth increased by 23.0%, and completion time
decreased by 18.8%.

Metric                         Baseline    Patched     Change
Background file write I/O (GiB)    6.154      1.680     -72.7%
Foreground bandwidth (MiB/s)      150.29     184.81     +23.0%
Foreground completion time (s)   109.203     88.652     -18.8%
Foreground mean latency (ms)      212.84     172.74     -18.8%

How it helps
============

Frequent writeback of the file overwritten by background fio reduces
the opportunity to coalesce buffered writes in the page cache.
Several overwrites of the same page can otherwise result in a single
write of its latest contents. Flushing between updates instead writes
the same page repeatedly, generating more device I/O for the same
application writes.

This additional I/O makes the device reach its performance limit
more easily and competes with foreground I/O for device bandwidth.

The benefit is expected to be most pronounced when these conditions
occur together on the same device:

1. Limited device bandwidth, as with an HDD, makes the additional
   writeback I/O more likely to saturate the device.
2. Multiple cgroups perform buffered overwrites. Frequent foreign
   writeback reduces write coalescing and increases device I/O.
3. Concurrent direct I/O bypasses the page cache and competes directly
   with writeback I/O for device bandwidth.

Approach
========

Following Jan's suggestion, this series records foreign bdev targets
separately and flushes their mappings instead of their owner wbs. This
preserves a way for dirty throttling to initiate bdev writeback while
avoiding owner-wide writeback triggered by these records. The existing
foreign-wb mechanism remains unchanged for other inodes.

Tracking is best effort: each memcg keeps a bounded set of device
numbers without persistent device or inode references. Recording runs
under mapping->i_pages with IRQs disabled, while dropping a device
reference can sleep. A memcg that never enters dirty throttling could
also retain an unused record and pin the device object indefinitely.
Recording only dev_t avoids these lifetime constraints. Device removal
and device-number reuse may cause an unintended best-effort flush,
which is an accepted trade-off.

Writeback submission may block for a long time, with up to four work
items outstanding per memcg. A dedicated unbound workqueue provides
a separate max_active budget so these flushes do not exhaust active
slots on a shared workqueue and delay unrelated work. If allocation
fails, the existing foreign-wb mechanism remains in use.

This primarily affects filesystems that keep metadata in the bdev page
cache, such as ext4 and other buffer_head users, rather than the usual
metadata writeback paths of XFS and Btrfs. The decision still does not
account for how much of the memcg's dirty memory belongs to the bdev:
even a single dirty bitmap block can trigger writeback of the entire
bdev mapping when the memcg enters dirty throttling.

Changes since v6:
- Drop open_mutex and the openers check from bdev_flush_by_dev(), and
  add a !CONFIG_BLOCK stub.
- Follow the existing foreign-wb tracking policy: use timestamps for
  oldest-first replacement and expiry, and allow dirtying during an
  in-flight flush to re-arm the record.
- Replace frn_lock with an atomic in-flight flag.
- Drop WQ_MEM_RECLAIM and explain the separate max_active budget.
- Guard bdev work submission when workqueue allocation has failed.
- Expand the dev_t lifetime rationale and filesystem scope, update
  the foreign-dirty overview, and drop the Fixes tag.

Changes since v5:
- Fix repeated overwriting of slot 0 in patch 2 and add comments.

Changes since v4:
- Add before-and-after performance comparisons to the cover letter.

Changes since v3:
- Flush foreign-dirtied bdev inode mappings separately, as suggested
  by Jan.

Thanks.

Julian Sun (3):
  block: introduce bdev_flush_by_dev()
  memcg,writeback: flush foreign bdev mappings separately from owner wbs
  writeback: record bdev targets in foreign writeback tracepoints

 block/bdev.c                     |  18 +++++
 include/linux/blkdev.h           |   4 +
 include/linux/memcontrol.h       |  12 +++
 include/trace/events/writeback.h |  22 ++++--
 mm/memcontrol.c                  | 124 ++++++++++++++++++++++++++++---
 5 files changed, 160 insertions(+), 20 deletions(-)

-- 
2.39.5

