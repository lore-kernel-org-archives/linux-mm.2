Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0399CD98F0
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 21:42:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6173C6B0088; Sun, 21 Jun 2026 17:42:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A06A6B008A; Sun, 21 Jun 2026 17:42:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 468B86B008C; Sun, 21 Jun 2026 17:42:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 10A436B0088
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 17:42:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 69507120500
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 21:42:45 +0000 (UTC)
X-FDA: 84905244690.22.8F07259
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id E06BD140005
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 21:42:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QdC1fX2T;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782078163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6CzYrLF00ygQ4iPvC+zTr5yElH0SDeqaQIEXKc18dDQ=;
	b=iIrUW7SW3ZC30Fel2o4nb/3jj+J84qyA0MsZNAHu3SymxzP6xsp9RiNB6rEDtIZKyI29It
	Ag6rTPQpvmoZEc5YQ9gQ4jm/ubMnEqfVLiv+bqUURRUayTo8170jdJvSIrnT23l6yDXDG+
	U5+TtUmL0aIxlMYlAqqWBlv7+L8gScw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782078163;
	b=mWvWHMoT6mOuEosiwEcaa+S0JtAIBKu/a9l/pZocHe3VAQ5GrxmBWHRmEiS2mIxTFtkUmZ
	cOZiAYPIY8ZDQFH9Uur4CkYvko1qG5K7FXEYZ1fQIch57bjGcwwrhBIoK5qmBOMFUSDayn
	8sZMHY2fz315GWcnFBxQ9slMc5GS6VQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QdC1fX2T;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 418CD60051;
	Sun, 21 Jun 2026 21:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659641F000E9;
	Sun, 21 Jun 2026 21:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782078162;
	bh=6CzYrLF00ygQ4iPvC+zTr5yElH0SDeqaQIEXKc18dDQ=;
	h=From:To:Cc:Subject:Date;
	b=QdC1fX2T4mf5OiO4uDSz5sUHx7PfyhyHoQb24Mii+55CNI2DljGxCGCCFCTFBk8cc
	 UsSXgAaGrbg422AFkK5dKeA+EoQxw7gGIy6jncfBxsbqKJVgbMGjz4peTgEEaIYkL1
	 E30+5DIs7RaJkDdH8rt76DHzPDYDr9yajqI2I5utL3pNC/fGaFu+C66Jof3tX2kRYj
	 BR6QSBeUuhlrXsdCJy2Bcnu3az6Q7EqwrMsVbpKG4YBcg9zl3CC3GxoWX3LhfUP1Te
	 tQsdjdPUii9kC5Uf3FhnYxQJdNAzpEwaS70bnEYlv4s+3DC3dTjpZVfeBJSi5DeM7a
	 l84KRPdMer9qg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/3] mm/damon: provide pseudo moving sum probe_hits
Date: Sun, 21 Jun 2026 14:42:27 -0700
Message-ID: <20260621214231.13449-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mogbxmojfkx6ipmsbf3u73satw75yo7c
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E06BD140005
X-HE-Tag: 1782078163-766689
X-HE-Meta: U2FsdGVkX18saJKeUaFq+Drhl39QfbzDa9gfPJ/b43BpGc96VpYM6R7ENPPwgVqzJ6oN01TzQs8KNPSU+ZgCD4Jqe1u3F007ie27CWMep580e3NvoLINf61PG6iHLoM1efAYddMBZz7lQlPLaXTvRX+gwidK4IQO9d/HL/LMQ5NzVyyie2T5OXNQD1Akm/AbT2tUy4j03AOSpGwQ3RLjXWTkit2+HdFbQJfWRPSJKtqvyQowGg5AyiZUDLCXk35yKYVKIbSx8LaM2uRytnijXlTyEoCQkHn5PAGn5Jc0FYETCI7WXL4eGHDMIvBAUw3WGNcTTfLwGqtrG7zdpI3pdjl2MUEp7V2UGJsiy7RbQ5Ji3JCj04LJZC/c8jpDGLRIKyOGvC0uzR0KereSLcJD7bF+WFCwBi4/0yg7H49Wwa6yRyjcTV3mjhTaUCmeHIUFaCHsQE3SCI+sltbUX/VKqnLivitYnDKusfHRpK/3S0d60XeLMHTW4LgvfR5h4fDwMtPUYjN665VyhRof5qye3yHYgof0Iyj1D69Hlr3AkEc1DY20iTT5HIT+rF7seV1ebFZ2C8lazrsRGBxjv/fffDxgDIqlSfDvS7G6a3d+Ud4iXrJXMV8J0kmLQhCYgLAeu/AIgbLW6O4j9Vkr2CPnoscfW4Ee7cSXXTo82jvXYDZ3u4uOmG0dFisN9mAes3GboBDltJOKwUJvrQiY7kIIww7adjlLwvtywGcqAf00cWWsh+vtrPEIMmD/AswLItJEdAqY8vME/spQWn8Z2cKGPrJAqcm+8uPGiuBbXxgk+JvnOnH5yQfM4vo5tDTNKlOrZd8hTmTsd4LsRnVCNic3SQSr/NTX6xkwtYwIdRVERxrsgtiTeyFhME3HxdmkRNnI7Vyzlz0uLZKrKocTjPOhdqEX9sysu8KN1MCKL1tMDfLFXEs0bViZIg27GNxC/6XlHgj8cnebcXKzNVsP3D7
 bC9su27Q
 KzOGLGgGN7aQhguTOhRogXiANiKqPnI0tXMexSY2HI0c5O9tsS7XEAVKubOWWTgoOQvL0cRoAw0WMuZW75w2nWXo7U3hIawiFX5Yje5Qz5os9bJKC5SkTVxZ+xXm44rADsEfuSd6DE2Z9I//E8pN5a7/Q7dpYevg/LpF7pgJ92Rcvtn7UsJ/NYY8PK9Ozykf++L8G3BBFjq3WR4C4y5s5DKmBjUVbKKKbx4oAJKzuSWH83OsD3GVhn2gLeLxk6LWEBt1L
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
non-anonymous page, using DAMON user-space tool, like below.

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

Patches Sequence
================

Patch 1 adds probe_hits counters for values that fully accumulated in
the last aggregation interval.  This is required for using the moving
sum infrastructure.  Patch 2 introduces a function for getting the
moving sum values on demand, using the infrastructure.   Finally, patch
3 updates the DAMON sysfs interface to expose the moving sum values to
the schemes tried regions directory.

SeongJae Park (3):
  mm/damon: add damon_region->last_probe_hits
  mm/damon/core: introduce damon_probe_hits_mvsum()
  mm/damon/sysfs-schemes: set probe hits as pseudo moving sums

 include/linux/damon.h    |  4 +++-
 mm/damon/core.c          | 31 +++++++++++++++++++++++++++++--
 mm/damon/sysfs-schemes.c |  3 ++-
 3 files changed, 34 insertions(+), 4 deletions(-)


base-commit: 2c13bf619ad5282c48f178288dc632822d0629da
-- 
2.47.3

