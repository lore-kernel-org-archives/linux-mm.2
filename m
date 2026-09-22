Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6374C982FF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 12:50:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AE2E6B009F; Tue, 22 Sep 2026 08:50:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78BAB6B00A1; Tue, 22 Sep 2026 08:50:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69BA56B00A6; Tue, 22 Sep 2026 08:50:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 463AF6B009F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:50:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B7CCCA6224
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:50:23 +0000 (UTC)
X-FDA: 85241381526.25.2888476
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3840814000D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:50:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PJD2fWKl;
	spf=pass (imf23.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790081421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2IeG2Mx3Kg57XaeZod52dBSPgeiNTM4UZ90mALN/kFk=;
	b=vTQIRvYL4qXMSmrBBFxS2EU+AzbqKCOFXjwK2XToVeO8aq80en/0RFIGeqmlh6Zn8F7PBf
	L+ZHflgd/3Frr4cQeTPqLIZ9u/6p7YnH/tbVUt5pl/keKocULI36yULlR+5WB7TSAD/mEe
	2VREdxrJHX8vsAGhTiiqnlZxWApcRRU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790081421;
	b=11IEjfhRQmNWCQJe2H0u8ej8y0HvPDsB29tNEHacWkLeoxr9xXaAnpeXgt6d9xQ3DyKZMr
	9YgTxX05YtrFZ3/6hwcWNtZrfUzYDQ0e+nNmrOVAkfjxs02+OpdqptGMxuEAlfq0LBSx7y
	dD25Z5J0yf6nQAAh3Am1bs4r9Dh2jkw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PJD2fWKl;
	spf=pass (imf23.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d747f0135fso39414795ad.0
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790081420; x=1790686220; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2IeG2Mx3Kg57XaeZod52dBSPgeiNTM4UZ90mALN/kFk=;
        b=PJD2fWKlkupHH6xuWLae1Ne+0/EzcKGcWox4sRs1n2FSAUsjZp+2ljoAUB18Em+/uW
         TiHkfbmBNooQQ+ZYu0Ghxa2F3dphYAvfbLs6qKRALwLN470dk0kysQ7dxEF1prVoYBDB
         15g02MJLIrQkqYFlzxFpMNjijmfR5mEP+ZixUyUOhWoETthruaqcRZH6mpuCAmPCWswe
         Qb09luVT+bbEAwxC3HLU5rLOgOEnHqTofDABdADNCRDzY1adN1lWo2LfBbCPUp9SEYWY
         jnJJjlVUZPTzKyFOFG6wVUfc8kzDO5tZS+lu+aI2xPMEDm+dcPKp7t2kGj0+ULZovO0+
         WlNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790081420; x=1790686220;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2IeG2Mx3Kg57XaeZod52dBSPgeiNTM4UZ90mALN/kFk=;
        b=GT7VDRVht1Hy+OkIRBKjEjnZ3XIosxq1Vglp6HufD+qEvBjxbhCZIuaOSYfKO3YxBv
         D/DVlyas2uIMJVcnqdk+ZLgDkaRYQAaS2/TZA+umAaC59Nh6m4sRc+RsSAqI6dWGbD2U
         P0oL7O+hrK30B2z1ag2VSKsxmcFf3R7Ph5+onHZCsymRr4KvYcfXVzMlmiMX0WgyYrht
         fDgDChvvgAIA7xuIJF14eWYxxNGBm05gWosnXOj7OKDtiq2gYLO1O9Es+ziMXYi0Uvyi
         +8sUffBNr3ERiYXoh8ViBii9RP1FopKX4rceGFdGqo48m00Cjrkgwi4xc+IB48GWk4OP
         SLZw==
X-Forwarded-Encrypted: i=1; AKwUvByvL9kb7GtWu3Uxwq9llV9bGtfSrEJgVij50nFKE9jp/iaoDB3PwFy1XaI8zsRdKZ8A7uIteJseag==@kvack.org
X-Gm-Message-State: AFuF++lK90VLWoRlDTBZP/QGye/7SigZ1ijf/jLwv0QQJRlPSU0t90XO
	SS0AivNWVxDb5uuli2XMnPHuNpiM0gg89rnGip02LLj9UW6iErT0ZPwyHmfEgm4kM1I=
X-Gm-Gg: AYBFou2Y7XcEVxw12z1PhKKQv7d6y7A4nsJDcAr6Z6d0NWjpOdhjwgtARUNXGGkgG5l
	kPT2BTDHRDlDSRV77D4AjnVCEt42AGKeGHCWwTSM5U3fyyseGXzxkcUkhjj3TY59m82rmkoglnv
	JTVWwzi0zLW++pN4DeyIbSBBHIBt0OhcAp4LVu7d4Pg7U47CbOlaKPAyL4B+5XDZsSpLNxdPnmZ
	BWB67Tk0jIVmdK0M0N100gwfzUUZ6USjePK5AoV0ej5bTAPeuOFcj1drhbihU+kXzTMRjIS27do
	JqA/sgvqn+YpQNzF1Uv63HYri2yVoWFz6MDmrySLSOvCMvV3z96s5MmWeyzOHHKl4hCpJ8mUS5r
	CcWNd+t+abE8WJV3wOemrDNVdaO2vRhm9QDax3FumTF1lLfqNTtTCzKJ423A0a3T/uZv4djiIzg
	WjQNgPZlqX73FLrOyCvpB5ejajCHdlJgLyeFn3ArocJuoyw6AUqWJ1YmwBxP+8IoaLombNmLFZD
	Y8=
X-Received: by 2002:a17:902:f60c:b0:2dd:ad74:ac83 with SMTP id d9443c01a7336-2df60b2eb9emr14839105ad.30.1790081419763;
        Tue, 22 Sep 2026 05:50:19 -0700 (PDT)
Received: from localhost ([106.38.226.186])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df5d02f448sm9488505ad.34.2026.09.22.05.50.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 05:50:19 -0700 (PDT)
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
Subject: [PATCH v8 0/3] memcg,writeback: flush foreign bdev mappings separately
Date: Tue, 22 Sep 2026 20:50:12 +0800
Message-Id: <20260922125015.3435215-1-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3840814000D
X-Stat-Signature: c9effxdqrhkk14og957ku3ejxyfpkrti
X-Rspam-User: 
X-HE-Tag: 1790081420-747096
X-HE-Meta: U2FsdGVkX18NSJO8TO9azh0yWfpacIj8EdfMyD31JfDd0AWCgh062iE4F/E6q0E/6Tz4eUiVaQPAptjr88bDVhubqggYJ4nEKek//3RVDwQoz+YZYTJ9VTr25nXZo1wzIVX9IqsIuC9e94c/GRSPL/BbeFJTH6Weo+WWWmf1Wd3RNzpbnIoc4xgWxjpcfJMu4fiDi7U258asMoC7zktt6D3pzpsqen7LlzSvBdxevn/47NDr1y2KQ4SQXxkP57rzY6bPg22JIR2rTyMM3uuoRPPKUDC3C2cH0Zegh72luO2ynAd1TK6MhqShSuctN4/+j+GAeCSm1PXxCMMWnstZIswwQ0ApcF+LJYmVl3Cu1QEiHR4TJOfFxSNN5YlgeloPocpEtw7S3j8QzHarx92aA+jigJxW4bVUy5ifMS6FTx7nbwWSa3X8nN1RBHFzoN8LodPzBU+DMTF1KVHkmCEp6hjax2hQPOHD5FmOMpWOUfm2A5+RZ0tYSoRTExeCtfFUXv/3imzNxqU+KeBF8w4WYRhLAFJC2iQibMLXg5E5LTTWJPy/hGt2eteXtQaW2EtvW6zHTy8VGV/OGeXuf7QSTiY1Op1CyZkY5h4tXv7Keb8andPawMVuZ7cOWuYp7jfexkNuiqRHw3I91yvC7FHuKgVIYox7yFU7EXhZfAlOC86wDDRH+ohapIqfarKOFarjrNde8ZUwxVxjpmEU+V9kZ83Aen/+8lstNlLMnlD73CODHjCTUu9n80UdQHUAeUD0IPR4XRRHwNLdcDay7YWcknrdruTodEqVigjFQ+BRbc+eRRMzjrhjlNHFuy7Wb78c8SqkAsFo/fdctoPrEQ7jhKcAnLC63fW9MAj6hw35NMNsv1qiSAGaDDDt09VQ6VrmxGt2oTh7/yjU/6EljF8Wx8oRdmblLYZCyHhSvYjpRFwkknLsE17Ct2N80Ipp31QQ82Kk/vHFhpwX9hA53V3
 VTvUG736
 3SN/kfF0OXrtPdqT3CqjY6fZSmSU2PZg6tNU7m5ss8Yry9UGRqV0Pl23mi+Phqr/+IrvVUg2gg3xLXbIvVdqx/n9Q0/bicMXPYqk2IcvuJlhc2VCduLcn4DBSSS4E8pni6gDyGk7FViYwlue1pi3ajjXxvKNNt+kFS2FklIu9fC6TojvZ8e582TtIAkmjDE9jd+koi3NTmoeuoLs5Dgj/p4AWETTBqidM3BaR/gQCQWUQxe0YMeL+W8mSmg/oGw1/fvrvRhskQnJZNqKQ3VWg+FU5JIl+oWecjQ7Qn2MD+z5DQnPjAFqGQtnTAlhM7puKb9993tF/90eZGfW0YfevS2FPKtJ7ZCaNA/BdWX4fcRiBI1909U2FLN83bENRLH5ymr9ER72NBxHRocdbtD5gllFlToRAu/Vu3JAE8mpi+FFICP8=
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

This primarily affects filesystems that keep metadata in the bdev page
cache, such as ext4 and other buffer_head users, rather than the usual
metadata writeback paths of XFS and Btrfs. This also covers buffered
writes to raw block devices. The decision still does not account for
how much of the memcg's dirty memory belongs to the bdev: even a single
dirty bitmap block can trigger writeback of the entire bdev mapping
when the memcg enters dirty throttling.

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
  writeback: record bdev targets in foreign writeback tracepoints

 block/bdev.c                     |  18 ++++++
 include/linux/blkdev.h           |   4 ++
 include/linux/memcontrol.h       |  12 ++++
 include/trace/events/writeback.h |  22 ++++---
 mm/memcontrol.c                  | 123 +++++++++++++++++++++++++++++++++++----
 5 files changed, 160 insertions(+), 19 deletions(-)

-- 
2.39.5

