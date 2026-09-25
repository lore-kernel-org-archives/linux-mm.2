Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4E2BC98306
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 06:44:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24D616B0088; Fri, 25 Sep 2026 02:44:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B0E26B008A; Fri, 25 Sep 2026 02:44:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09E816B008C; Fri, 25 Sep 2026 02:44:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D786E6B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 02:44:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4CD6FC0502
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:44:51 +0000 (UTC)
X-FDA: 85251346782.07.6193FB4
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf06.hostedemail.com (Postfix) with ESMTP id B7C5C180002
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:44:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=FXEFIpos;
	spf=pass (imf06.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790318689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2CDje0QwiVgx6IbktJTGL2P21t+Ebt9LY+FLAFXNJ+o=;
	b=i6vkFdDkxV9wiygbXtH1yhzBGB2TV/pRN1HTu/eH6QDgcLB4lljPfawd3xdn7bVXYUIsZQ
	KB/R+MU/uz93BJtLizWhW3o+UV1CzzXZ1RMjwHrfMLjnVl1fhRBNq0/K+ca4TfLpSQvF8G
	tfBpEaZoc30x9Af2qerB3PzRxIaxBB4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790318689;
	b=3b5cYFdYzsFTt5HShc4ZyVqI3QQg9EqIn89SFpxtdXqsuprwavLICcHWnF/VR19sU36n33
	rooZ6UFbNOfYOGHiuYifq28dbiVibaAZZ2Fxqfp65Qqs4P7R2oKk+6rxTgKmuj9ujMQ3Uf
	3Q0HluWJee9fQFMwoX+V50kJY6Nj+qU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=FXEFIpos;
	spf=pass (imf06.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85469d249c4so469663b3a.2
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 23:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790318687; x=1790923487; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2CDje0QwiVgx6IbktJTGL2P21t+Ebt9LY+FLAFXNJ+o=;
        b=FXEFIpos6SXjSkdRfELo814iJN1FSp9vBzrrV2HuTZfGaJQh4UJD03/uqcr7/LwlEE
         93Z6yBlvWP0UuORWSF0C1UYA5+s4KoEFvZY3pXSZkG+JUq7B5YGSvscla0Jyf6SNP322
         I07HRyrvLMKxynToomXpgwEho/c0Sw37sOEn/EFwCBw2LTuGgMl1vk66j0ayoewdASqO
         3JSaQZFQGvP2/MsZEo2Z2CqHQ2SAxAB/Np8a7uc3AQ2lRxeMoj72TnZAVES/uvrey0SK
         rbgIUA9Au9Mwt/lXpw0B39aFSLofVaHys9/P8YtAqiYr77ZO/pL6BzVp+SxhxcxJtwrH
         ssPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790318687; x=1790923487;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2CDje0QwiVgx6IbktJTGL2P21t+Ebt9LY+FLAFXNJ+o=;
        b=aBYh8mGdvVKGXoCnURwo9kSx9rr/eI5dy/kCb+zMa3SfqcD8dS1j2DuDPpcjQ6giv3
         hP+Axu6ltroFgB6I9r22c4zh/G8ce0nAHi5mFIrgshkCVgmyEp4t7MKaLnOEAdNH83Ag
         2uQgdeeCUaqmIUUxMJYW/z1xSWHnGcZkRbOEYp71UYuBMdUDMTscQmo8U+LiXJZF9wNv
         EPkVc37aAqoSE5VdQl6u5r/4BN4/3YJ0QJzB0zuizj/loGh/ZJfIqlWlF1Ylhz80ZVq8
         Z+xjQpRbqbvHO1rPD4hwXjoxZNokdcp9Xbf6F74BXKq7ijLmfgkcI2faLEV09ZniONCq
         hTmw==
X-Forwarded-Encrypted: i=1; AKwUvBxkFZJla3Ec9a6s4l2yPKSfV/+4lYHYV/0HJGFRd1b17R9IbyeS71lcZbmyqo7Dr1+1p68DLB8V2w==@kvack.org
X-Gm-Message-State: AFuF++nhHaVhX0VUTVngW224jiGQmbsq0fhb7QTyeiW468AWQ4yiG5nF
	yD/F9FEemXbtV1wOGfWH5Ig90mILMNqYMRwdCUnLq6H3d3MDkr2vOCebOw6gLy3q+JE=
X-Gm-Gg: AYBFou3S/tF6akOf++E2EqS5kSXlNhL2/r5Yszo4IHRY8ti72n/t0EaeEyCbjev55uX
	I+bMGdET6L0eeg77gpnv5WKEP9447mACABXr/OZOIdWIn1zhP6IHKNgvgHwI6H/XlXUvEpqJ7qj
	lm0Ms/bc3nWXWlUEL3/n14HCMU/MrFX05jbM8uuwj/ZCkM3TquuZKL99y6ckmJ/btkgKyoTgAxf
	2iI4bqlv/FR2vjSHEce2MaooJ+iAInrwpTHuETTIH/9qRmakJfAihvKmtL+W0demAtRPwy01xqB
	RDxbdyZnxRPBIfV0ES308U9LSRCiKIeOhrTJquwaaZuqJEx4nLh9V85QLJN6MYzS5QCbEO6l4XR
	M9sn15qR5SHBbWeVoatjtNQ+i+QyWnfEpj02kgPhGkKXvvIIE/cbj3sOpIrEN4sKyRxnFY/adp/
	J7J9aVaqyIsi4xsKi0QmrE0xkbTPSq+eb01cHYgGhg5A27ei/kdLmBbBj4yamt25ITbWgyv70c4
	qxh9FXEnBcFRA==
X-Received: by 2002:a05:6a00:6088:b0:871:2152:980e with SMTP id d2e1a72fcca58-87e9995d1c6mr3952766b3a.23.1790318687288;
        Thu, 24 Sep 2026 23:44:47 -0700 (PDT)
Received: from localhost ([106.38.226.167])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87feb57e56csm575244b3a.48.2026.09.24.23.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 23:44:46 -0700 (PDT)
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
Subject: [PATCH v9 0/3] memcg,writeback: flush foreign bdev mappings separately
Date: Fri, 25 Sep 2026 14:44:41 +0800
Message-Id: <20260925064444.3944820-1-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B7C5C180002
X-Stat-Signature: ffw5mwm6c719978ncd6jyo3xpfjghtfd
X-HE-Tag: 1790318688-26402
X-HE-Meta: U2FsdGVkX1/3PCKWU/6piwPGBECfDIz2PwPHve3y+9EHrp+fCMUw6hlZSEqtngjFFA2Q0DaEuM08SpgbkpSP84LzGDJUJroEv/gyqRepyBuo84ePk/vmeLpt+CUElkix6O+j0+WBXHrYYno+wIa2E1VTE0qbyz0ubpID8AfrxD44d74zcn8cv1VzEUz3szQFwAQr83D7bahlQHZ8ev7EjFJMDNaodKql4Y0zZkLCn9//0RS7pLNI9obSWOrcGFW6XVed4lN9hxh5T4Mo1lOwHoPcZQ+cDsCLpyOgK9zGJ5XWBFDPZ4f0klLQkCTYfUHpX+/h5wpAyo+qYRUVQHxctJ9dP118eqtrBIgbYwv/hLpXXmno24YUAEbCLtENFWpeobX7csyH67WncIBB1NyF+1P2yuf73f21yx3hBKcqjwtvSg8eOor0ssKFBQKUAzETxnJqkd2qQlng634NtoaVWY0OQpsbExsnJZtgJvL/vi3lCoIkGpamO8lPyhDCwnPLdaNLCw7nxeqskXXAlj85+NMoKNsHRLQmmNh8WWbON8dcZnFXeh3l9uSuFGtW/L2t1IaDxIoofkfisX15oxt5zm3I4yoPdovuOdCxDJC+RcGoEKFHBQdj6CiKjxCIZToaDi1UjXRlCYmIMeIcvuVGAEeUO1gDQn5fwEUw2Wqe2Dr6xVvmgsrQojyUQYGUjm0aKKbpHLdeTxamWDIdPKbnZKNlxEoEGqC7JFaCkxZNY1N8pErpTOCHlYVTdqqyIzR81XqU9N4ActqawdpEN084DrhDZfm8cfB3fE7Y5Tkj0BI5UhTp2mE2K80Gyh9i2oHOWBsDMaoHKOrigfERI7laYX8vjXPblFGaktInRrMt3bfjc9jx2Kla1GcNywgi1h1ENULd7zUaXhDsOgDevLWXFJTj3UaosPDpfGSj9pa2qn5cHPIFdFB7DCC6pr+87oSen4TDguz4ae/aLddfqJ8
 NowcjC4+
 MYDNVP+l65GHNLuE2s570NsJZmMvoCS5bOMcWy3cBwzqgqUWjHgS7c5Ywh1ISJxdk5fJYsHbn4bowHbzUAjUIlUcGHz43o/3UWaNmrlGkC2miuGqdh2nGQkEBJWdwZ8IKUAbZpmMe9aYQS/nBwACw7+AU4n+ky/Qe0/FYyIfvtD2/OFep3kfXWYl0ABnv4KWZ5BFUKH/LNPRk8q7wmH9wAiWLDA8sSFdcTZwD3qzlp+WmIXKz4SCObbxvjpVI+uSNhxqpiETMHcsW47RM2maDH8c1s1e229opahdu8NCo3Qiapn2oGsmFN1LB762p2NOrOWWkL68r6e8P26c=
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

Tracking uses oldest-first replacement and expiry after
dirty_expire_interval. Further dirtying during an ongoing flush can
trigger another flush after it finishes.

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
slots on a shared workqueue and delay unrelated work. If the workqueue
cannot be allocated at boot, bdev inodes continue to use the existing
foreign-wb path.

Flushes use write_inode_now() with WB_SYNC_NONE to skip inodes already
under writeback, avoiding competing writeback passes on the same bdev
inode.

This primarily affects filesystems that keep metadata in the bdev page
cache, such as ext4 and other buffer_head users, rather than the usual
metadata writeback paths of XFS and Btrfs. This also covers buffered
writes to raw block devices. The decision still does not account for
how much of the memcg's dirty memory belongs to the bdev: even a single
dirty bitmap block can trigger writeback of the entire bdev mapping
when the memcg enters dirty throttling.

Changes since v8:
- Use write_inode_now() with WB_SYNC_NONE to avoid competing writeback
  passes on the same bdev inode.
- Fix a race in foreign bdev tracking.
- Add separate tracepoints for foreign bdev tracking and flushing.

Changes since v7:
- Update comments and commit messages as suggested by Tejun Heo.

Changes since v6:
- Drop open_mutex and the openers check from bdev_flush_by_dev(), and
  add a !CONFIG_BLOCK stub.
- Follow the existing foreign-wb tracking policy: use timestamps for
  oldest-first replacement and expiry, and allow dirtying during an
  in-flight flush to re-arm the record.
- Replace frn_lock with an atomic in-flight flag.
- Drop WQ_MEM_RECLAIM and explain the separate max_active budget.
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
  writeback: add tracepoints for foreign bdev writeback

 block/bdev.c                     |  19 +++++
 include/linux/blkdev.h           |   4 +
 include/linux/memcontrol.h       |  12 +++
 include/trace/events/writeback.h |  67 ++++++++++++++++
 mm/memcontrol.c                  | 127 ++++++++++++++++++++++++++++---
 5 files changed, 220 insertions(+), 9 deletions(-)

-- 
2.39.5

