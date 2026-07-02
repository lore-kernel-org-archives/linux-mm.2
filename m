Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96402C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:25:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BDBE6B00C1; Thu,  2 Jul 2026 20:25:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0706E6B00C3; Thu,  2 Jul 2026 20:25:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEE9F6B00C5; Thu,  2 Jul 2026 20:25:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A68C96B00C1
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:25:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 726A11C6AC3
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:17:27 +0000 (UTC)
X-FDA: 84944492934.05.10D6BD7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id D1630A000C
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:17:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gWdy97mB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783012646;
	b=KPhW5L7AFWS5RwIyhsauzRC+vf2YH5R4lAC2JkfXHkG0gAi0UBJfAdew4rJj2S4HswG4xj
	PJY62qj9Q6pFooggEeJQQGR5h9gUb23+Zq3OY7q9HOL+3e73xLNalcNXgbGUiN6YevVjk/
	LjNyGVLkbAyroGBclDlqolwknMZi1gU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783012646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=19kUkWTcX1TUOLrO+G+Zk6bSs1QBfCPLoMUXYasiczU=;
	b=b0+NwHKYH8uIvN/TX0McKy0tiiGD3S7lcl/4n3D3WYWW908VGVDVvUmIPuheQu7TyYZ6YI
	6VKJjNct2a0FUbqNKgJxws4cSpP2ScOYOxVE5WhpCoBO6KzfH/fsorQQKrnjarOv74DFWd
	bqJErmP7zxgsLcGp+/pi6Pxiyv8ZXU0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gWdy97mB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0026C43C97;
	Thu,  2 Jul 2026 17:17:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC75F1F000E9;
	Thu,  2 Jul 2026 17:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783012644;
	bh=19kUkWTcX1TUOLrO+G+Zk6bSs1QBfCPLoMUXYasiczU=;
	h=From:To:Cc:Subject:Date;
	b=gWdy97mBnapbModTmVjqlPO2xt+mxap5ShIXKTGqM4KjkEm11gUCeuqTHaAqgidme
	 H9IaYugh0I8aPYlweHq5f1bwRNWryKyl6l2stGIBsQR2E8utDGCDtW1e4yDLPafnTn
	 YEfSNpYU5ydDNeBAFWAhWeCg0a6BoEFbGwhj3RTkG23jDJQCFR7aDBRt1VI1fa03ed
	 ELsM/si1GqL/Fwq/xvnV+CvW+qNRi7K6W5C+sybbBlqDG7rrMxl0xKvKfZ7Ohcrwcn
	 QvUERYD46o0K2YcZeiOiUni4d7Ikh+/JfgXoMx26Qv9uSyeDoG9f1xWr2RXCtvvEi4
	 8HsSM8uBAUSNg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 0/3] mm/damon: provide pseudo moving sum probe_hits
Date: Thu,  2 Jul 2026 10:17:08 -0700
Message-ID: <20260702171714.88278-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 7mt1schis9h19gtzgg6m8q5jons7m4sc
X-Rspamd-Queue-Id: D1630A000C
X-HE-Tag: 1783012645-690072
X-HE-Meta: U2FsdGVkX18yTmfZhYyoS2rcrmi73I5VnJAb40mDINP5V345UedWNu/gdS37LJeIjG7ggfFuhIxGPcSI61wBHxJHEIHLggn3JjYYT9HQqTSnhfv+pny+zKP34ZBGHY9glXlKE67pR5yk4AZ7/hRl8Q0iyvJ2a1/+JCUP0sIqyXIr8YuepuMAOJDSdvEnbAuQzEwHRVF7ZTBJK4Wjucv7nIWiA9PPQ5FS/3TSarDi2L0AjJE+od/oJZyzJeZl0oLtOxaAk5LzF4NkC32C7pGQnkOUGUDe+65ppElVAwYw0ee+QprLMFhnTw3jtLSGgWiTKwUhpOIbQZQKWGqWE3rWVEihtG3ivdwS/dYLEk4yjCKfzkWCep3F2GuPgHvslaV0T2MUQgMp8VwKZQ2PUVSj2/p+xBl0VJa7phVzh9ur6CG/MYz8VB0HHlYEMMnlCHnV6AsqEhZLRGvcgKTi5+aSqX7287bkfAiMHBuUsvA5iPWxxh7gl3hGV83q27sDq+j41MHF1fV7qZUwY5Wbvseuvdky/glU/eP/oeXFHF5pNDR7nS6bw/20RC8giLqgsvLX4qvUHNripGqN1wr3h5/BKEIXVYSNG4VHgQKLMCze0UyK7hdCqLJY52nzZKQdlMDy43WqdPjjRMDvd5XU7aU2ERQfQY/Lxrs+9vduoZVD/MnCLet0vKZTv4qROeSG86Rzhv0gMDqndIaXjmpoFH5LNuFrqjjqK25Mv/wpoC9eAm++TJ3+HXfKEj3fOJ4B/W47tY+DlGQOG1cEb0IOgaFBqy5T5eIPb8581teQ/ctZoU4pVPzzcWv4NdqR/toAmnHJk6uRAMSWE+X9NvEZVHnKj9zOj/JMdXinvFyPYhpUvj00ndq8ymys5gDL/89yKGDz095dZ7VBx6BsUSdOiAZ8Ymb9OyXk9SHhXENlE6528igaonBYzU1Q5CvQXG4Q2ymqDa2UYDScCJOvYMQLfba
 RcUJLvlI
 aVQjFgzdnHr9UTrgU4BkkENxIzJ6EWWiP9ELO0yD51eh0tgvoV6pR1cb0YE+4NnNNKOHjv/FNQWm2W4r9oO1WOpoktblv/uWvbrdDWbV/tqR/OUxin/v8O6va6QEcqXhEU5f7DOraXSI0rYBAcA1jBtEjDKoLXkGUSvKNLd6HNSl6X2mALZRm3oxQoO7/3c69QZ/ELzSYC8iQRrwVRL26wEPsGl9X4CmWHbZMHm27f1MXjbejTTVP03ru8SvuBQOcsKJS6F4CdWhETDdV0/ThySmGtrXotdCmiBl7dm2IF3QYtPM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Data attribute counters (probe_hits) of DAMON are managed in the
classical way.  The counter value is accumulated every sampling
interval, gets the complete view at the end of the aggregation interval,
and is reset when the next aggregation interval starts.  Hence, the
complete view can be retrieved only once per aggregation interval, which
can be quite long.  With the suggested intervals autotuning setup, it
becomes 2-4 seconds in common real production systems.  It can span up
to 200 seconds in theory.  This will restrict online monitoring use case
of DAMON.

Actually DAMON is already providing online monitoring of probe_hits.
DAMON sysfs interface exposes the values via schemes tried regions
directory files.  However, due to the above mentioned limitation, it
usually shows only partially accumulated hit counters and therefore not
useful.

DAMOS is not using probe_hits at the moment.  In the future, using it
can further strengthen DAMOS.  However, a recommended setup of DAMOS is
utilizing sampling/aggregation intervals auto-tuning, and having its own
DAMOS apply_interval (1 second is mostly recommended).  In the setup,
DAMOS will nearly always show incompletely accumulated probe_hits, which
will not really be useful.

Data frequency counter (nr_accesses) of DAMON solves this problem using
the pseudo moving sum value.  The infrastructure is not limited to
nr_accesses but general sampling based counters.  Maintain and provide
the pseudo moving sum of probe_hits similar to nr_accesses, using the
infrastructure.

Tests
=====

On an idle system, I ran DAMON with an attribute probe filter for
non-anonymous page, using DAMON user-space tool, damo [1], like below.

    $ sudo ./damo start --probe_filter allow non anon

Because the system is idle, nearly all memory is not an anonymous page
but a free page, so the probe_hits are expected to be nearly always
full.  In this setup, since the sampling interval is 5ms and the
aggregation interval is 100ms, the counter value is expected to always
be near 20.

On kernels not having this series, if we retrieve the probe hits in an
arbitrary time that is likely not aligned to the aggregation interval,
the values are usually much lower than the expectation like below.  This
is because the tool is showing the incompletely aggregated values.

    $ sudo ./damo report access --format append region "probe_hits: <probe hits>"
    heatmap: 00000000000000000000000000000000000000008999999711111111000000000000000000000000
    # min/max temperatures: -1,630,000,000, 0, column size: 99.800 MiB
    intervals: sample 5 ms aggr 100 ms (max access hz 200)
    0   addr 4.000 KiB    size 3.898 GiB   access 0 hz   age 16.300 s     probe_hits: 11
    1   addr 3.898 GiB    size 77.859 MiB  access 0 hz   age 1.500 s      probe_hits: 11
    2   addr 3.974 GiB    size 700.770 MiB access 0 hz   age 0 ns         probe_hits: 11
    3   addr 4.659 GiB    size 791.078 MiB access 0 hz   age 13.700 s     probe_hits: 11
    4   addr 5.431 GiB    size 1.472 GiB   access 0 hz   age 15.800 s     probe_hits: 11
    5   addr 6.903 GiB    size 915.059 MiB access 0 hz   age 15.300 s     probe_hits: 11
    memory bw estimate: 0 B per second
    total size: 7.797 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

After applying this series, I was able to reliably show the expected
results like below.

    $ sudo ./damo report access --format append region "probe_hits: <probe hits>"
    heatmap: 00000000333333330000000166666665111111139999999855555555333333333333333444444444
    intervals: sample 5 ms aggr 100 ms (max access hz 200)
    0   addr 4.000 KiB    size 790.496 MiB access 0 hz   age 1 m 33.300 s probe_hits: 20
    1   addr 790.500 MiB  size 791.160 MiB access 0 hz   age 1 m 15.400 s probe_hits: 19
    2   addr 1.545 GiB    size 792.316 MiB access 0 hz   age 1 m 32.400 s probe_hits: 19
    3   addr 2.318 GiB    size 795.465 MiB access 0 hz   age 1 m 2.600 s  probe_hits: 19
    4   addr 3.095 GiB    size 797.102 MiB access 0 hz   age 1 m 23.500 s probe_hits: 20
    5   addr 3.874 GiB    size 797.293 MiB access 0 hz   age 47.900 s     probe_hits: 20
    6   addr 4.652 GiB    size 787.516 MiB access 0 hz   age 1 m 3.800 s  probe_hits: 20
    7   addr 5.421 GiB    size 784.461 MiB access 0 hz   age 1 m 14.400 s probe_hits: 19
    8   addr 6.187 GiB    size 795.621 MiB access 0 hz   age 1 m 15.700 s probe_hits: 20
    9   addr 6.964 GiB    size 798.000 MiB access 0 hz   age 1 m 10.200 s probe_hits: 20
    10  addr 7.744 GiB    size 54.566 MiB  access 0 hz   age 1 m 9.300 s  probe_hits: 20
    memory bw estimate: 0 B per second
    total size: 7.797 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

FYI, 'damo report access' output format has changed on v3.3.0.  Above
outputs can be reproduced on <3.3.0 versions of damo.

Patches Sequence
================

Patch 1 adds probe_hits counters for values that fully accumulated in
the last aggregation interval.  This is required for using the moving
sum infrastructure.  Patch 2 introduces a function for getting the
moving sum values on demand, using the infrastructure.   Finally, patch
3 updates the DAMON sysfs interface to expose the moving sum values to
the schemes tried regions directory.

Changelog
=========

Chnges from RFC v1
- RFC v1: https://lore.kernel.org/20260621214231.13449-1-sj@kernel.org
- Rebase to the latest mm-new.

[1] https://github.com/damonitor/damo

SJ Park (3):
  mm/damon: add damon_region->last_probe_hits
  mm/damon/core: introduce damon_probe_hits_mvsum()
  mm/damon/sysfs-schemes: set probe hits as pseudo moving sums

 include/linux/damon.h    |  4 +++-
 mm/damon/core.c          | 31 +++++++++++++++++++++++++++++--
 mm/damon/sysfs-schemes.c |  3 ++-
 3 files changed, 34 insertions(+), 4 deletions(-)


base-commit: 863594ffd4066f35cc62893902c843b0c2a87c65
-- 
2.47.3

