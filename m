Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB6D8C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 08:34:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C23FE6B0098; Tue, 15 Sep 2026 04:34:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFBEB6B0099; Tue, 15 Sep 2026 04:34:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B39DD6B009B; Tue, 15 Sep 2026 04:34:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89EC76B0098
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:34:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C703D14030E
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:34:15 +0000 (UTC)
X-FDA: 85215334470.02.0207577
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf15.hostedemail.com (Postfix) with ESMTP id 74337A0002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:34:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Ukrupzhz;
	spf=pass (imf15.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789461254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vwYuAUVTEM1KZY8XIMf3dOzuS7TDv0+6YLYzPNZ/wUM=;
	b=uwMkzPmwvrEdVPSiXu65/6G8xxG5VNVZWykGtzVgXAitbtxjrHWLhUuc4oJNzbqS4eSnYq
	g7M/FM3SzPGIrPi4wVOJiqCOsFxeP6y6Z5WDBoaYPDQTquKaZiTpdAZTlsoLVv712Fa/AH
	jIZf6QYWwdsNJHmr+MeDh6txraCFN8A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789461254;
	b=tTgtTjl1noxvxg5emGPeEtlz/+OI7eEeVSIal1yZLbHDw3wrLy/yWTuYIjRNhCtSUQ0yGr
	TKAO6fzE0DdyOPf4m2dpW9MDbtRMElkgLhFXIjO55+pbtZ+q0eIPc3kfs5e8Bo1r87bABt
	Vr4+ZLVMXIq+FZxX9vAZmF9eJZnDPQU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Ukrupzhz;
	spf=pass (imf15.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d8fe517774so37447235ad.0
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 01:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789461252; x=1790066052; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vwYuAUVTEM1KZY8XIMf3dOzuS7TDv0+6YLYzPNZ/wUM=;
        b=UkrupzhzZJuAAdoLcTOWjKIXt61iYXZmN7wBMv+G9Mev13Zua9LqAL5MY25WyiXZkV
         3Qxit6aA5cZ/cfuaQkk2esDzPeFPgtxHEHO5ujKfHbLMDsc1QAhZTXc8sO8uPEbzINOC
         gzXaLkECI31ptMCxpSzJema2F5vDSybz4i9LD/5O06S8GjiGO2T4OamrYhLs13dEtsPE
         edXv2C8Pyb/ruMrXXq6lojiqloppvpzgq7Af4T+eX9+7+EAs5RP5WEfdAijYxbLIrMpk
         mtTf8efkO1SevS4SC7cgRXK4mRK863qQkoiwc8KehkZvc774fw1QI8F8t/4kBMaPS9f8
         S2NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789461252; x=1790066052;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vwYuAUVTEM1KZY8XIMf3dOzuS7TDv0+6YLYzPNZ/wUM=;
        b=BFbOoky5JyFUtgwlGZWjd/9kpzYdRe2MhTMSCLOOJ1JBra2AZcHmVP2KjMUCycMQ4k
         IqYb4fsEwHr0iQPZuaPioc1/qd/vVAkCsBGaFvfT0FIklrPlJP1swaajGJg9BIDcU4i/
         /NzDtCuoEMZIY1u4Dz6ZeOHYyYAHmNC4S3ff0j8ICWwvLs5bSDQpAyDyWbmXG3uaKunS
         UAQNJljhaoK7QYBzETEU2ecrCmdWq11TLfdtgtN/Yc/30mO+aYTmbVCuu0/Nq7Y/wtM6
         WBxU94tRhOtHtovVwF9yRt2tRURSRpAN3gHs4q6CutgYbAqDsxQQ+0oO3h2tpTKNtv6D
         GT1g==
X-Forwarded-Encrypted: i=1; AKwUvBwf8mKTJiGRvxD6wd9QuLbm2xu6fZmVemMYfq6rWZPCAFw7NW91e+IKuDGqojlqPYUDUaefazvCeg==@kvack.org
X-Gm-Message-State: AFuF++l31rtMrkYtj1MAGZ2yJoHxQcnvQ4ifbloWf36R9ucymCqdmWvx
	mq0waA0q9+M9ld4fJK8iznuO8Ds2sGOJbRKtvLWNkqa65zG6n/rxZyl5sSGC3nHX0H0=
X-Gm-Gg: AYBFou0i453pVDU80cgxRc4SreGE/IbmTAZhbVD/i8RUay80xF2g8bHhtYSfHi3b0te
	9JQp+9BAAqsuftN2vbYLN5RHmKRDqUiecKbIwUYA5Ugob3WHBjl33AMHWZZBRmBgCS1KSM3xbBz
	lpIL2ICDuO6y5wdJCiwZXcdXVCqUbLtHk4d8grEYiu09oBDERB+rc0ZM6M1Tu3Fy8YXbpwtdjM7
	lV6tzH3vT6rSb2pvT07YVTRXz9cKmNVqUvrACS81QC09ShMW8w7ba3mzwQY75OjKUz+bChD6D6q
	xecxWMdfnsGFNBAgglUZWsIi8LRVRUcPoXllE3aqapMSAlEEEop4NnexR+j9MyvMjYYIcp1TfxG
	Hd1/dNbtU+3H4GQY56id3zVlOGxal6+J6RbvlkAiI46b9D7amKJZXTKs9ab24g55QLKs6u9Poly
	82V5ZOcqJb8xi9rFMYYWdSLUY7GktHzhcc1HWpjbg05odr1eXo0H3NeV6k8fe2QNV1C7vZxUIi
X-Received: by 2002:a17:902:fc4c:b0:2d9:123c:8c49 with SMTP id d9443c01a7336-2dd6c6db8b7mr146833195ad.14.1789461251905;
        Tue, 15 Sep 2026 01:34:11 -0700 (PDT)
Received: from localhost ([106.38.226.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd2cca268csm62498695ad.1.2026.09.15.01.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 01:34:11 -0700 (PDT)
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
Subject: [PATCH v5 0/3] memcg,writeback: flush foreign bdev mappings separately
Date: Tue, 15 Sep 2026 16:34:03 +0800
Message-Id: <20260915083406.3471036-1-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: r7wgbidiiotti8siqb1warxu9kfrfgac
X-Rspamd-Queue-Id: 74337A0002
X-HE-Tag: 1789461253-997314
X-HE-Meta: U2FsdGVkX1+1q0gdz7mMHjjFDbz0TB+Yft8qE5sGoHGnRzoYA1KtvP7sjj+jQU+3dXQRGD1NP4xUOH9nsvTfOD4g6+QUKJ2DGaERZFhpBGVhvdyGM/Xb6JFFwu55XoDLr5l8B6hfDPXm9HFsqqQ26fumn+L479tWaV6Hn/pNgVJ24JvmkOrxc9wZ3qUaqozjOv3uOX4RvoHItMixRUeagFsPc6LSp0se0iZNYAcZvIDQ1TCqf2C9yCRvQx3i1qVSK+ro7wydorNtWzwBbB7iUgp6PNoSTEGA/thUM9H+CkrO0GDuJUqq2B6Dt1gOv1Gd1e4xdH7yLldNf4hUyZ0hePJrwW47sTLrMO9eiIUNBP1Hr4f043IjK0Vu9fFSAJZxWj+GgdcIkY17/SAz48O9b5kH291jk5zCKHPhIixeHAzQrcEKMGiOZCOE0STXfFA5fZEb5QceXBaQlGxLVPAGQsTxvlfb9RrJ3Za+JnzT72C8URkV672dLS7NSfcFsNCezvVB10lxva/JtaHU/qib5oTiHZs33rbNCUZQFxNngTbJIK2/UunMlvRBSBP99JfnYtBu2BoQGRLE+jPIMF4DipP8wPX8/S6MXl1J/PgHp5rXULx7FHvITqtC77O6uqDZQd0yTQANKRmImD5Ssl8YQ3TgWTDKoLBPuVObh4bCI2bTLde1xSY++nUBnOQHaH/2YvtJQJcy6Rj+OzRRb9ACA1BJyZGA93FIBDxbnwUWsG+jmynfXYPK1PGvhp/p2FBsEPBVmipKqN2JpjXZaof9MnFqhUMmjYn3vwPMiVveQJmkOj4o/2GnhAtwvi7eRg7NlQXRpHwgTJsLUZOspISuXPUbfUgALc15tOofGEU+XJWn047QOiTW+z8vbATRcdr3vMBK0dhRHNojnwNT8Gck94KdQD+xfg8oPBlQJsRiFTZuiXiMiT3EAXc4gi1ZyRjpMUHq5W6xWfx9J01yDcS
 3hvwHZt6
 pth2dqiH0LY4Q6gukKE8J6hErlFiPpdcVaV0toI1UNXPu/Dk6A8l6VO+oM/08ZXcxzwoS2podhgaxKsMmipQgrLNLqj8zwHhzdGNksDx2sd5+c14LrxVq0pyFZfJYetBuy6CU2N99HCZOU+Rc5TetldKy1oNSXXHlU6yucuQ3sbEHI4MrmFSrIYaYGDmS7Y+203nwve+psFcV0lYam/V80TnBIOpt8oJqVQPpONK8LO6yWhnPgDh6iPV9QPxPV2N/nS+/PU+qvZIxnvYMPhgZ8JMbyQkb+P0B70yCRLQQ+sqb8na7al8Cc65Yy9jnlIq6pqy/Ey7h8XFq9KU=
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
numbers without persistent device or inode references. Closed devices
and devices with a busy open_mutex are skipped. Device removal and
device-number reuse may race with lookup.

Flushes run asynchronously on a dedicated workqueue to isolate these
frequently triggered tasks from existing workqueue users. If workqueue
allocation fails, the existing foreign-wb mechanism remains in use.

Thanks.

Julian Sun (3):
  block: introduce bdev_flush_by_dev()
  memcg,writeback: flush foreign bdev mappings separately from owner wbs
  writeback: record bdev targets in foreign writeback tracepoints

 block/bdev.c                     |  24 +++++++
 include/linux/blkdev.h           |   1 +
 include/linux/memcontrol.h       |  15 ++++
 include/trace/events/writeback.h |  22 +++---
 mm/memcontrol.c                  | 113 ++++++++++++++++++++++++++++---
 5 files changed, 157 insertions(+), 18 deletions(-)

-- 
2.39.5

