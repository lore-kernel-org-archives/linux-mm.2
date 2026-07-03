Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B34A3C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 17:06:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91EF16B00B5; Fri,  3 Jul 2026 13:06:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CFD86B00B6; Fri,  3 Jul 2026 13:06:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E5FD6B00B7; Fri,  3 Jul 2026 13:06:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 447CE6B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:06:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C8F3C1A021F
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:06:12 +0000 (UTC)
X-FDA: 84948093384.22.D1B0854
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 48BD640010
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:06:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ve2ee7u6;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783098371;
	b=Gve8gJjV9GYRJQnXoUgxKdoSS+sKeGEy0EM4BYKBOJjhV6Cxe/RrFoUohiU1cp9PaGxkFw
	/1pikDpiP/iQFVuYanHHJI1Bt5f30F/u9PBVklals4SoeydpAOcIoexJKFRblMkaVjifRZ
	Mi8QgiHbAT/DCaJ1yXLluJgUnoUHRSA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783098371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KJy5PCwtKFgXV0xEcKKTT8ihzzqX9E1/Kam4u8NnZNc=;
	b=5bGwGNiNLzy385OOwdzyj3YQAWauXVrA2lABy4lamVVl9DHHMJnoRQBhhzhlvpONYDAMry
	P52i2hn/eRWPS+L/FgXteA0u7LQeqw3XKxBpXAqi1DXxuLtu6KUjOWrC3OkPgLZiFqDcWY
	SHS8FMONw38b6nx4oBXqcTWb9GRE9zc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ve2ee7u6;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9497360051;
	Fri,  3 Jul 2026 17:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40B91F000E9;
	Fri,  3 Jul 2026 17:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783098370;
	bh=KJy5PCwtKFgXV0xEcKKTT8ihzzqX9E1/Kam4u8NnZNc=;
	h=From:To:Cc:Subject:Date;
	b=Ve2ee7u65r8ZUPjBrSRGXBU/LnJFcwLhVngkHB4zjJ5/XOn4fNmEXp4e8KCK0Vhob
	 pbMbXkvDAqFEAyDsF8qsQEI1NACRu9UFFjPRPUuDiVg2KtbqowSbrdqzhR9TyGhDnY
	 KAfulYSFNAuH742OSkovW1nIVBUtcOmcsOyKm1xMRMZituOZIS8gB+PlJFZC+x3Q7v
	 fGyJuhyePTmeqthKlXfVR7mATXc8OCK1PtClZZknwKCu1RWhkyvGFmFTHczDJ1j3jd
	 ldmi9SgRIX6Zi+G/GVpop5nDjVjwKLYbk+bBRTs9kPn7g3p4n2pBodQsxzj8z7Tx5j
	 RM1mrHXLv9ueA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/3] mm/damon: provide pseudo moving sum probe_hits
Date: Fri,  3 Jul 2026 10:06:00 -0700
Message-ID: <20260703170605.94472-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 48BD640010
X-Stat-Signature: oro1ybqx9ubo95e85xrr9ke9z56bjdc3
X-HE-Tag: 1783098371-872200
X-HE-Meta: U2FsdGVkX18JiOkZF0Zpnu+swIum2AcYZEttp2VCzedF/07mMmPjiqXio/eLzid0/YmfjDaXE21rcXzY9G18mZxpTfY81QmezxjScmu/gZex/rsWO5gB/HI8UmG+TXsYtwxkBNwzZ/gSOCcJvZIa9pnxYq3UYM0aZ+V0xGXUDpTGOB+x4E4qulmM6W2otTH3CwmiGiGIB8cG0Z3PwbBsM8jvEmNdzZRtQwPxRyYK0JKPUZDcrSBVKOLvGP7XMNlFca67/VoQpquCC1+P0McxK1Bf2v+o3lkdMx0WlA2V1sjgvYeOVBix5h16q+gy2R1pYSFenBf30KRd5Rf2/In5n6Zk/yLW16DdtTbCc1u93taXVYBELJLdkFE1ctNGtpx87A2FdT5emHiOFTtn9KSgeVIs0uZrkLNV56gYYXfGIUAEqffAzX3UJjIQrUon8Nz0vJF6cCh3/imN5OY7lph7BNNYlQXw14LDNwWhy7yMitV2N9yRF6kMSEpp37lEMB+vlv3QGUu3twcunKuE2J424HeYaFJE9J5SXMRI9Kj0BZyYNbnm8R7l/63mfC8Zp6f9XkKmMNhzQ/NV/DcLgSbpUTZsNKSJd6cVcQdeDpNBN2Lhhkp3kdoNGmGezPHP7dcloZMx2JL5PankbDgekRRz0zhdPaTUndf8J8d0lCiTjgoAYOqxSADy3MI4MzikEjIW76HOPWzux1xiD3deOUyVb+TiebP/ImdjDyfnpb/uqEeBLwdhzbcSCwrBnLNO9cLsqURj6b8KVTogmkvzERM1zSsPv5xi4vtnaTr4XSVnwSbNXF8OdGeXzWKhiGQTvn7SJerQwq4uRgZ6Mm70MPUwHk1KRy1NfRBbpEQInzqbFhDSZjpXoTr/3MCrQtBm/V5+me42AxKDUy4DwoS/94pRQAAZLh1zLoNVRNJgHWYZHe0bkjhlFU465XWxTpDxg5rA+/Djqb/srej6ixTCSIR
 xQq32yLg
 cTff202KjVX2aGyTlPzzx/gRJYxEF49j1bRxpRGhLlJvfA6SWU4o27zQ5G+Mkg6kprMwDfg5nbaBAeDkvQJkwsbBF84zzGg4uqv4vkR9dicaWPuG7FrgRe25LW4IXxOLykj5Lx5O61g2Ax8KA1G8U6MKFZtc4aHqC+QiPfyPQd7TgVUQfEFIZ4VnMoIm6Mx9juMPnQ5vYyY7tAN2uoWUCayHeBP7XdduLLQKEOjVo6CZHoTPntfyuoFUY4SXCVhkHfkQfQPt0OK4G9NmCYyvlcUr5ZfIrw+V2SOeG1cZ/eyvoZBs=
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

Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260702171714.88278-1-sj@kernel.org
- Drop RFC tag.
- Rebase to latest mm-new.
Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260621214231.13449-1-sj@kernel.org
- Wordsmith cover letterr, specify damo version of the test.
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


base-commit: f0eadb83262e3eac82b67cb7fb5456c2e9db75f7
-- 
2.47.3

