Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42FA3C982CD
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 06:58:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14A136B0096; Thu, 17 Sep 2026 02:58:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 121E76B0098; Thu, 17 Sep 2026 02:58:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05FBD6B0099; Thu, 17 Sep 2026 02:58:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DA9DD6B0096
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 02:58:08 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D8F5E1C1ADC
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:58:07 +0000 (UTC)
X-FDA: 85222349814.15.F1A07B7
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf10.hostedemail.com (Postfix) with ESMTP id 139C0C0008
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:58:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Pe0kfgQB;
	spf=pass (imf10.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789628285;
	b=SrSXQTgvNz76UDDateJseXXG6s56hsh+OnCerXBsSZii9CTpOeBlmsASCLV5q+1XABUQJm
	DoNJvHOBKcIWxsQAfZ7HUqylmc8PLvuJ/whzPGNaXxHoX4RfFGkanclPUY096O8Ag/UZ5i
	YcPV76c69FJqymPfP5J+520BJ/9KJiw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Pe0kfgQB;
	spf=pass (imf10.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789628285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DNKAWCInS3ncgYsrptjrEkqpgHAtyYq0bBCMZxfKpWo=;
	b=GCFzWaBTXg5ZEpQFAixn8PioVdBNMOTmk0U795T4Hu2kvS5Mr6EclhrRBKEzg2OqRuw41D
	9+mf8cmGXlocfExj6EF2yqWqgs/Q492G0tPYXv13bCaCAfG6EM4UbfstCPCSrhWKRtBP9l
	u4iZt/g5Se7F8rYf3H4Pm+N5ImZ9Y5o=
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc1ceb47d53so72034a12.0
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 23:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789628284; x=1790233084; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DNKAWCInS3ncgYsrptjrEkqpgHAtyYq0bBCMZxfKpWo=;
        b=Pe0kfgQBeKJz9ApufdGtOZnykZpkWVRrOcTmBDNFPejJq9kzy3yN6ueHTLSqVdFWdd
         6b0APLeld9HFSZE3fqxcDq88hyeb8Sjpif94GZie5wiG5kZS9gg8WG/eNx17WaIdaszk
         2RYdkNS1eweFhR1UJ1sZhZ9EvSoLHtaZMDItRf7ZyyUsD5ttDB5+m2+tUKpvVyM+Qoer
         r7YZURE+TnQAF0saU08UPBvCdXXNfRk0spGI9EkSY4lWcIeFvduaX9YwDD8RjZkfNuN5
         DE5y4tzEHYMVoO2T5u0e3dcHsEMNueGRoj3I1xxFu0drrfRF3bmmbVz0RaBJpG/zxoli
         Drug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789628284; x=1790233084;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DNKAWCInS3ncgYsrptjrEkqpgHAtyYq0bBCMZxfKpWo=;
        b=vKwV0kekg/fSCR5u19Tkj2yVKFkxBK0NL9qBMDoFQarFHVo+l/ENyrRCHDkdkGWiDP
         6IphtpZrGEFZhtmG+dLhWUMeBxln/rZdWc+shndcN82sT0d39HUl8gmxIwfVUwJAA9Xb
         URV5Wuj6NnwSPBjSbwYqcb7vicasYn+68jcVATPmeKwnD1wK1xMSuEu1VLboMGLAD8VN
         5GYMbggKQfOWVxeLo5VkuDTGip6bsAwQ03YmUfmBktYLQH1+oGiAgH34CKz7QDW3JoTb
         44Gg6iKB3VU2+FVByQ7lszMhmuBQOhFWHLNE71gyRjc6XEN/GPz7OcpqzTPH2opNXMNf
         C9jw==
X-Forwarded-Encrypted: i=1; AKwUvBwOlj/S6dAbB14YpfhyRF5S4iiJmwq1JbQNp5bNNL8A9W93dDyEOVTrudqtexkAZdvCJATNeB7KDQ==@kvack.org
X-Gm-Message-State: AFuF++m+5j+vhH4479aOI6MQdXB1bWa2LGBevaiRCFmAEf4t7rOZ8gXM
	MXs1bXWahN46Bib17bFQCcqcPhwfJ2ROWnOYfg/T0Nl9srLrt+MxrDq2JnYJjYCnJV4=
X-Gm-Gg: AYBFou0EoUD19wf834SK2A7bk/924rOo7ZqikmgdE7cTgBbgh0movY1CnGmDpg7xSgQ
	NmXeickUSfUI7mo+5g/6iUVr+iRKW5KKQ8KrvfbhhLQU+2+AeggaWE44S3+OI/0ohe6qI7BWTZu
	7p/vh9m2kbiWY+iudo6MmF0AyraQadQMr3e84zPQlz9JaAmemlFpiSw0ohTbZ68HHKXL1KAFkew
	3mLWSIeHyygo7R1aWyPGTq8HR2P+oMzAT5bVwTxsV0WwMSdk5/migMfT18pkfCIj1+dX/z2KYul
	9DvLQNYGQd0sRierR7bsu8blCQXlDIyRD2KfZVyiecjFwE8KEhllgOyd54G5U7hA3o2BOfhvwOP
	3M3+IWFSDrLmNFqwG1IkLf6FC8NmWthIE6X01S3NaMiy2pw/vhWudUVa3CT51XUDa5E6QAJE2GV
	anL23nkmdhHV1sI+SM65Vum1lTpLj36Aer97Fuor7geLOu935glQFEGq3x0mrhs2t8UVhkD7Ql
X-Received: by 2002:a17:90b:1b06:b0:39e:429b:1e2c with SMTP id 98e67ed59e1d1-39e429b2135mr542709a91.15.1789628283519;
        Wed, 16 Sep 2026 23:58:03 -0700 (PDT)
Received: from localhost ([106.38.226.6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e35e4e0c6sm3888175a91.8.2026.09.16.23.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 23:58:02 -0700 (PDT)
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
Subject: [PATCH v6 0/3] memcg,writeback: flush foreign bdev mappings separately
Date: Thu, 17 Sep 2026 14:57:56 +0800
Message-Id: <20260917065759.2643940-1-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 139C0C0008
X-Stat-Signature: zeuhkc1ip4hwcjn9e3eqqoqa69sb8jjt
X-Rspam-User: 
X-HE-Tag: 1789628284-840519
X-HE-Meta: U2FsdGVkX1/udrKfDr8qn93WpLBHMTFMIZyTjCVlqgXLwzWos4osVV2XuM3YS0GeUnd7CizrLF2Wkby6y2VvVhdun50qkTDaQnpOu9pYIfulHVlEVWw9LyrvmRzZcx+1M5JaVKvd8IaZDaOV17OXqpkUfQ+RqQr+dvEkjmeOT3epYgXBIJfZad2vpCulxIoKFKtt55KZVL/19Yz9BsKD0StOEE20gwQxDKcvpCOBUFftbTjwTD+Fs6fxV1lgicU6UoGfmmqySuZchug9WFu51XZKlIsOkiYeUI/zmDhFEL6SiCQn8g+GzD9wO6e+Q48YjBnOMt8UwEib8igzqHcIjIz1h5xdfpQ92GV2XygCrySlUroLoYTFvBh2yj4oh3D3ICTQ45EERnBGaE0tMAX4ghJ5nEHdDPeYf9uhl79/RI5V1ZanmAIpalK0VhnZnwP+gaFR0M4O6wluADyOLbrHkdfvQKsRD9LQZOx+gFjiSt1JMYHnTJPOkJpIKtZEB56AoA9i+hBP69IApxk8joDm2KamEmdAVwK/RqyZ+eRlr33X/FyRsHx5Ephds5FDkNq+8Z58TTAgpwMswAk7DesgInBtsI5Z+h21rn0IO5UL7y4r6sxmQeGG6+6cAJGF9Ysw0CKF3v6b1FSKXI6Ky02mjRkK2KUzziQpLq1V+ivrYkEauRBVunHaF8PFnpKqaXusbcsoUdL+vzTQWrYf7s6QH6jNVII4V4yXUMXEKbvLBbXioI3J+fIFhDGCv01JdOsuF5jgmM0LrJ8aolKLAGfu+v1gHML1sPbICVYfowKDG76zT6pEl88v0KrVX48yO1CnG9ZAIEMkEL0ee6VvoqSF2SGK3osp4kwobuB24j5mLgGAQvVlRSolMNjFojylQ4uFjfBejIAqfkV1N+hWQ8qT/CUdj++6KjKRWnAcV1XLZWwVtB4lDN3prGgvqFdKYZCHrwm7xUM7/sU/l4Je/I4
 NJGYb73u
 5DyLAci6pSIBe2EuZK4FkfYJqkOGWdtz+LW87eMtHqBer2+phIVCZqgnKssPbNyqB3BlDoBET/sOs/TsfgNOQEu1bUkPOFtrLwrdcPO5n43HARGG3yGuAReRREeEfsgvGQ8wulPiS0y07mp9670JXGloiWppDUKgM4tuSsOEUXTPtvRwfT3i54quP5B4kxfPpZ7Zbs/Nw/T2MxdNwdJmnhxvnu1dquYTXXOpb9p+g656gQLsobrFm7W6a10Y5Pet7abt+S3aZ80HxvOIwNbVKKrtDliyqshtsL1E9yt9foU3xFMTiHxlBVnhMe8jipZyUedUmWJbYaweshUqKV32ybyN8eBXjxxr2Qth7sWSYNRPt5ERzE14vwATd6VqFScgSHTkmvVoLgUJi+t+NOLEmSjtqRMsXm49TtFOTwOko57Bda2w=
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

 block/bdev.c                     |  24 ++++++
 include/linux/blkdev.h           |   1 +
 include/linux/memcontrol.h       |  15 ++++
 include/trace/events/writeback.h |  22 ++++--
 mm/memcontrol.c                  | 124 ++++++++++++++++++++++++++++---
 5 files changed, 168 insertions(+), 18 deletions(-)

-- 
2.39.5

