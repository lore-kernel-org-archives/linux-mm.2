Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A360C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 11:55:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DF186B00BF; Mon, 21 Sep 2026 07:55:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78E8B6B00D9; Mon, 21 Sep 2026 07:55:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67D376B00DB; Mon, 21 Sep 2026 07:55:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3EF066B00D9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:55:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CCBDEA3F6D
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:55:37 +0000 (UTC)
X-FDA: 85237614714.14.39CC491
Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2B7AF20002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:55:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Admyaast;
	spf=pass (imf03.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.228.43 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789991735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4yFs7aKADwEnqQrd+7DVxwZtTJDiMzxWaAyfpMFtjl0=;
	b=tA9fuKalgTm9zQVpyqrcVtxFS2Q0d68g0ey/gt7HwBhbGjqlMtOqhmR/dG1rIEXgBYisZ/
	gVlq0C5ZI7zWaSEbzAGMrZRf8shX1eZsaNBVvFy8/92LAD3zHRFLLxtpyNpQOd8QKqu8hN
	S8kyRdgo6mLNqnPVwX8dl3MlgKFhXUQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789991735;
	b=ZRbHyj3kyuqLhH6zrH2v55e+nB4MoE3IO3sKMUosfHotaZqNVYeMIne6ELwLzv6qQpIK7r
	JebTm/AE17NiSbyiO3TN24JhQCDTx/R1VF9p/MYDzdLujpcTGVrkrGHn3aiR4QhlL92mnF
	+ybp2YzTD6Qzmv9U+el6hPY+fZDH6yQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Admyaast;
	spf=pass (imf03.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.228.43 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-85469d249c5so2335126b3a.3
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 04:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789991734; x=1790596534; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4yFs7aKADwEnqQrd+7DVxwZtTJDiMzxWaAyfpMFtjl0=;
        b=Admyaastlpd832qy3HkPXdytZacv14g7K8gQJ1pNKd1NgtUovmG65ZZ0NwPt7E7XcX
         jBCyL2+BpSYCpVjj1/BE2f8m7gUDI1hz0yBKvRk5p12i/o5bzfNkl+UU+mqCxRTrwsdN
         Fl77pyMPkykwksX9DIXgSDx/FcWHfIajsIkL7Yef/7WAiXDPgXiAhFfNtS5eSQyeyObk
         t0ybOrqKcLO2W1MepLGCjRhPmPsu/l2VNawE6D6pmhpqNomWZmIYj/ids76kzWjzO5EC
         QJFQNvob8GmLgUICzz5WfC9s6ks41Pfyiq2JCMgXJHd+jz8fU88yVQvxc9Bbkn7TPZZK
         2hxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789991734; x=1790596534;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4yFs7aKADwEnqQrd+7DVxwZtTJDiMzxWaAyfpMFtjl0=;
        b=K8kBDLy5dOWoY0QuYnh65MSiwcrfYEWDqzyoz8qbTe/ez2D57j+8b75d+lTIRq1o5d
         VQPaPMa4vAvru1DMAfvzNXVQ962ui286svXPUThu5AsN0vtxMe8PD8/39a6gGNWSoiP4
         cwPodLsR4/sGOrnunendsIbEtlJdBMutgWz26icN8oVVivuuESJGs2NWKe9I48zWcQ+2
         mG57FhTRQPtGhVLAp2/4UCXVfgXT/uuHy6X4IdphSmcZQqUIXV/Yw3UnNwUrZo/INDff
         o6UIRcDiR74wiktTUQYd4dL8HI/nc9/DViAvIwdMpZeOwtZZD79laFTwFeMtelJA14YV
         S9uQ==
X-Forwarded-Encrypted: i=1; AKwUvBzv41qFilwRH/LCyyRfhm4AVuzPqY9BjiNGFDVMnRCGkKSPlqQNmZXbuSV6+gwFN3o79zRHq8Tk7g==@kvack.org
X-Gm-Message-State: AFuF++kEgNLeXZkRRHeJ7NAhqkzjAouv06+Ft8wynT62KHn0bYhVu6ET
	OSKzhCCTtiX8Sxfr+92fJhBxVHb3peeGiuzgkFt72ZN8IYLWZabsK0mkCMxm1go+R1c=
X-Gm-Gg: AYBFou2iVJ7jwhBuTln0trce3qRddvwLjS5QjkAISJFJQIERkWKC3TvPLvUw1PuCTW+
	EVGkaF1ekb0rkh6K+HtB9mvHR7L96OUxhepwEMMg/VUy/dCY6aZeDWExd7qvxKbAbIMdu0Ia/Rp
	gywobInBvAGRQfS5AH9Vf+4NUikgc0m7pg/cHPyM4RlED/jJz3q9d6rq/0MeCBnD/0Obt4xjO7K
	gzqt2SjFgl6UnCuTx8+ass/CpFGb/4b2WlI4hS1/tYcaBDjyh60Z4MAHNptYdAJmOBTnrE2w+oE
	wS9z/64mf/XX1ziuAaC+0NLHKh1sbFfW/sTr/FvMJlY5s6fsTycfLlOsO1nkAoq0RenLLk9Dm5s
	Co5zYHtlUXO4F9v24tqof8U4esGfQcCGgVdoTtQZ6/cRCsj2CcENR9StnDiTf4sFp3Xt7Hbvtz0
	5O7kDJjygA7h6IaAh4LVIhVwvoHxyHkY2aAyW6N3knnPqCOcv1sw+hqx3gJklmWQzvzSN5Neu5e
	/o=
X-Received: by 2002:a05:6a00:2e2a:b0:878:34d7:6a26 with SMTP id d2e1a72fcca58-87834d76ddfmr7083089b3a.40.1789991733620;
        Mon, 21 Sep 2026 04:55:33 -0700 (PDT)
Received: from localhost ([106.38.226.134])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-877a95f915csm3093687b3a.29.2026.09.21.04.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 04:55:33 -0700 (PDT)
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
Date: Mon, 21 Sep 2026 19:55:27 +0800
Message-Id: <20260921115530.1613717-1-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260917065759.2643940-1-sunjunchao@bytedance.com>
References: <20260917065759.2643940-1-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2B7AF20002
X-Stat-Signature: h83io53bdd4e1sdcemsn5xa951asxhuq
X-Rspam-User: 
X-HE-Tag: 1789991735-401678
X-HE-Meta: U2FsdGVkX1+NBquihXGYHrlBh6oBeS5Jdkbkuz4JA0wtxydDFk4kv5WgGBut1g5QjWXNWd5Af0j8algsA1uql4qmuNHg7AuZgNCOtTd8//sauXDxzO99LAgqZ6SN5EQc0IZT1EFZ7alX4ApH9ahz/OfaApEDV+eaPY6cDufFLn5M1fiVzMgsFPpUsF62dNZEX6S1V8U/Ohp3RpT1H6A/xpIms8DS2wpcQSKhP/OHWZB3urEMtn6oyKFhy1sOI1uTrF02SAu8caRZy9Dk2zVSXXvwILQ5WO9gBHAGGiLt/hKut12qzJ5fOKl/c9RiZrIYg1B5JMTXs84yEwnsVeYvON9zaJ4K8C4dW0rWHdN1MwieeXBUtP3ApGnXxz++b8tBrw4RiYKMH29ko7/BGFim1anInO9xYClp2Wr7lY7dGJkNVZxhR20g/+WB3884Qw6xtT4ME5EY7ie+I8tMQC7HjIPcrnprUMbLUos4PxFN4qBFMxTERKXcd9okaY6mh3xwWgerGlZrn3rm6M9XhitpuX/iLzMYRTTEkg6rQmlmmSJRxO3HZnLNW+82vgShdnN+nZk8D/y2Jj+mNP/GDJwkdw4KNk95g7YfJQ+GcLQNY/IrgFSiT28Of93YZjT8deAaBAoORBlzXMoSLiNlWO/kBhW6BWH7jUe/BbDAeN5ckF5I4WCvV/+rWKYPVUvnSSmrIAYnTYq303sAR5KRVxQrzgDX6itNC4YT7DKseImKayXDxESSSR82EluuVsru6+KfJEEeAX5hoB2+wSFYszRv32L7Y2vTp8ckQsvHACaWFXzJgI81HXIre1r1+wQ9iBoAQUZDY8ZboIeDBmyBaekI+nCwnJxBkU2HAuo51Egpt1hCYDeg8Mt0Qrf3CQX8WvnBf3159jRFL3UzblqMeEUyVYhz9sCgnWY6tPH09lm2EKEyYvKaCHRkLCD5RnczX6vzPF9/em/3qW6UwROMRUz
 BzM6Kvxy
 A56ekPG+6mHb7TtPdTl5BsZ+bIl5OujyBQaiO7DxaKYPupJL16Ogt+kgEQQgGHT9uBLrkuVrAa1F+yJiqDQrwhvwDSM86ZMGQTbVcZkphLBaG/SVz8F+PCWSK2EwBB5wnnLtGcmwElYHD24WsnyNik9ItGhWQs4XXxujIIOF2+51ZxrOaO+9xAVOIC5X0AfJ/Gd5V261dh3BBO6Fjv65hjc9no/PvXTBBNTiTzsERromR/QcL8vhno0TIvt5VPNUgrjXCNQL9oSaoE+G1IHC8WvBTWPixaVidvQw9v8yrQjfXmBWAFBLP328kUCrI+sX+toBqJheD17r2oHw=
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

