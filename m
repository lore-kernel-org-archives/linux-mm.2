Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAF3AC88E63
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 17:12:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 037A26B0095; Sun, 13 Sep 2026 13:11:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00D896B0096; Sun, 13 Sep 2026 13:11:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3EAA6B0098; Sun, 13 Sep 2026 13:11:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A1D976B0095
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 13:11:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 473FF1208B1
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:11:45 +0000 (UTC)
X-FDA: 85209380970.16.F3B6C25
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id CC3BC1C0004
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:11:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jqZAw3Sv;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789319503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2ZHtfSZyRuUi4qVh2TQmjcCNtITXl+b4Bizxwjd/UP8=;
	b=kNKd7kIKLGxJtuwG4b/SFSzd7aKtyRX5CC4JvqmC0NS5aQfLpv4Ulgl8RW0wIZ+RFH8jCs
	qBOWORnhvHLvGP7pYQ6NxCjeDvK9r8i49hmU/rljCU4zqqZdKUfirPZEVhLpKc2ydxDSHJ
	ePOG3ctTtotGTWUVQ7l7MrDqaCEFKPw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789319503;
	b=O+3X0uz1LWl9jNxSR9+AhWjo/BfheFFvB5SmDQk4fa3gAlLQCxvpm6Bdl6ph0FyENi2KBI
	VEnW0twlckT8cZnwsNRgjQOgPyGQW8/4+GYihn/1QLhsqNjxobxV7Fu8xWMKXReJM4OHCv
	bp4bnZfF75V7+S7Oigp/TLmfS2DAsbQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jqZAw3Sv;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 72CF360E83;
	Sun, 13 Sep 2026 17:11:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943271F000FF;
	Sun, 13 Sep 2026 17:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789319502;
	bh=2ZHtfSZyRuUi4qVh2TQmjcCNtITXl+b4Bizxwjd/UP8=;
	h=From:To:Cc:Subject:Date;
	b=jqZAw3Svg9VeStTqsuM2WGZ+gm8UQ5KiloAG7a6ktDPvG+XICMq1upxg7wh3hAfBJ
	 CXwKLNfw3naYioZJon5rKR+hh5FyF84I/D0hUpfWnB77tR496PigKftzDqpq79B5E6
	 jv2VSCIWSQ1b5DHYE6bepvZKyt39g4Z+MCHDl6WMdQNb1HcW6OLciWpOih4E7xHpmn
	 QmUqDPfh6KvDAywF4LsNCGY6GQhO1b1YKWJPVTiCUmOcor7zRvmpSoh/UMTiqXJuyw
	 MYSnz1ogFepuEuwiZAWChIMSzzFKdNehxDA8wdDLTPQNHmGxRST1RKk2WIduca091T
	 NytkNKwAGv8AQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/8] mm/damon: introduce hugepage_size probe filter
Date: Sun, 13 Sep 2026 10:11:22 -0700
Message-ID: <20260913171133.102366-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CC3BC1C0004
X-Stat-Signature: g51cho85bq8kwwbqckc7gntk3esyufrw
X-Rspam-User: 
X-HE-Tag: 1789319503-834845
X-HE-Meta: U2FsdGVkX1/hP6BWHfhjJSlnYXfDt8DOcuihxVfk9AX7l7338idN6JCET51gGJS9RFa48BUTgE8BlU0YMabrFph34udXUrNVVPCRnZIyU+MKx4eeK6aOg0vsXwSb8LY0pExCQ8SzWcu0wCzMmGWL0wyLKLXqH4ICvukZ1ouOg2vLdVizEXct5CKNb5NihghKmuiDUPu160u4uPy0CeB6N3ZiRWL+FJQrt7FFkF17Xw/Wy4n0vSmhh6EMSMm68odRizBGYy0JtyygfEN9ePhVoKBjnrb34j6NvF8tl45+RGKjJEppV5qPDDUgXP1A5ykalOrDuceJHxxz60uamlwoVxJrm6j12owheqcHyW390+s/u3JqRt73lMHgHS3TM9S8ZC52NNB83oVU254odIige5et2wK3AIe7ufm2n7KUSPRrsRUNtwBOGHaybwgB0zyPbcd8C1AoZU1xyzMGH0CYXKy2KkCgUkHCKsCjkx9IepnFCWpzOsjlnEnn+WgdybcZi0SDMU3NCXk9AZycS2kQ0GC7Pwx7ScE9Lijfp7UV5HfIvhbudPQjEnpd6Ic8bQhWzbUVjCaBHSdDM9Qz2cqzj1MRhwJZyFmY9ldVCHjC7RzLq0B+3vzldOUj7gHvygeJ/Uy8n/DGWwgvGzsRCyym0LF2oioA5tLcWzsLjpNYCb2Lv+Q4MwyWYNmmIlb+yeEEXvj0SrhAKP48+s9Xc9BBky/oKUqx7yExiGVaxCOluqKfccJ90Bp3ns+g25LtgAm+LSy4FPkgx5ue/gyrFZRALvs3b3fUGfSxQ2MdCIgIgPqM0Yrg4XbWmz5NL6gPfB3jqaeUl/++D94jaYM7NGnloK1qz5UQvOfseBMWyG1TXrY5m+3wzLSmGjTSqxKJb69rqEYkBjug9+9Rmj+iosV1OZHmBGubbfpKZTiJ8Co6slU0fTxcmqNgl4HV8jGKwMy9Pfjux7SZsh9fVtpHbgS
 8L0+YJfj
 NxRrm16qraSdIhNAabeDvk+Ed2wELzpsId/P4e6UeDCEeeAOYL0Mw+nj79sqYcOr2E66tjscW3EoLIM58vi6svzSdcCInTea1skQv5IxNCEAB52FeCa9Z78Q8iU27XL+KdLbmNZ6WQgMcFxOiOM/vp+DIBkbcUE+9PQzmRrJeuUQyj8rSmlPYvsUtPWfmLWsxJ3Efy07ZmP+o7paAdWk2eEiXdG70/Hhy97BAnWHmyltY2FeyuogHONbnZo5Ot5nvkqfH/E/OYB7DE1jA7pQIbgb+0o7rnUBHQekZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Knowing whether a given memory is backed by a hugepage of specific size
is useful for efficient utilization of hugepages.  For easy monitoring
of the information, introduce a new data attribute probe filter type,
hugepage_size.  It works similar to the DAMOS filter of the same name.
It works for memory that is backed by a hugepage of a given size range.

Patch 1 introduces the new probe filter type to DAMON API and extends
related data structures.  Patch 2 updates probe filter commit logic to
handle the size range.  Patch 3 Updates the filtering logic to support
the new type.  Patch 4 adds new DAMON sysfs files for the size range.
Patch 5 updates DAMON sysfs interface to fully support the new filter
type.  Patches 6-8 updates design, usage and ABI documents for the new
feature.

Test
====

Set THP always and start a test workload using masim [1].

    $ echo always | sudo tee /sys/kernel/mm/transparent_hugepage/enabled
    $ ./masim.py run --config_file ./configs/stairs-500mb.cfg --repeat 10

Using the DAMON user-space tool, damo [2], start DAMON with two probes.
The primary probe monitors access.  The secondary probe monitors 2 MiB
sized hugepages.  The region adjustment weight is given to only the
primary probe.  That is, this setup is for showing access temperature
and additionally how many 2 MiB hugepages are being used for the region
of the access temperature.

    $ sudo ./damo start $(pidof masim) \
            --probe_prep set_pgidle --probe_filter allow pgidle_unset \
            --probe_filter allow hugepage_size 2M 2M --probe_weight 1 0 \
            --nr_probe_preps 1 0 --nr_probe_filters 1 1 --nr_probes 2

Show the monitoring results.

    $ sudo ./damo report attrs
    heatmap: 000004[...]666666668988888888888844444430000000000000000000000000000000000000000000014[...]8
    # min/max temperatures: -470,000,000, 10,000,500, column size: 64.119 MiB
    probes
    - prep: set_pgidle, filter: allow pgidle_unset (weight: 1)
    - allow hugepage_size [2.000 MiB, 2.000 MiB] (weight: 0)
    intervals: sample 5 ms aggr 100 ms (max probe hits 20)
    #   size         address       age           probe_hits
    0   354.039 MiB  85.833 TiB    4.700 s       0 0
    1   1.843 GiB    127.724 TiB   4.700 s       0 6
    2   936.781 MiB  127.726 TiB   4.600 s       0 16
    [...]
    25  44.000 KiB   127.723 TiB   0 ns          15 20
    26  11.492 MiB   127.723 TiB   0 ns          16 20
    27  2.160 MiB    127.723 TiB   0 ns          19 20
    [...]
    47  376.000 KiB  127.723 TiB   300 ms        1 20
    48  48.000 KiB   127.723 TiB   400 ms        2 20
    49  812.000 KiB  127.723 TiB   500 ms        9 20
    memory bw estimate: 0 B per second
    total size: 5.009 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

The first probe_hits count and the age show the access temperature of
each region.  The second probe_hits count shows the ratio of 2 MiB
hugepages in the region.

For example, region 2, which has 936 MiB size, is quite cold (not
accessed for 4.6 seconds) but uses 2 MiB THP for ~80% (16/20) of the
region.  Maybe not a very efficient use of THP.

On the other hand, region 49, which is 812 KiB size, is somewhat hot
(accessed about 9 times per 100 ms for the last 500 ms) and fully backed
by 2 MiB hugepage.  Maybe this is a good use of THP.

[1] https://github.com/sjp38/masim
[2] https://github.com/damonitor/damo

SJ Park (8):
  mm/damon/api: introduce DAMON_FILTER_TYPE_HUGEPAGE_SIZE
  mm/damon/core: commit hugepage_size type damon filter
  mm/damon/ops-common: support hugepage_size damon filter matching
  mm/damon/sysfs: add min,max files under probe filter directory
  mm/damon/sysfs: support hugepage_size probe filter
  Docs/mm/damon/design: update for hugepage_size probe filter
  Docs/admin-guide/mm/damon/usage: update for hugepage_size
  Docs/ABI/damon: update for hugepage_size probe filter

 .../ABI/testing/sysfs-kernel-mm-damon         | 14 +++++
 Documentation/admin-guide/mm/damon/usage.rst  |  4 +-
 Documentation/mm/damon/design.rst             |  2 +
 include/linux/damon.h                         |  8 +++
 mm/damon/core.c                               | 20 +++++--
 mm/damon/ops-common.c                         | 10 ++++
 mm/damon/sysfs.c                              | 55 +++++++++++++++++++
 7 files changed, 107 insertions(+), 6 deletions(-)


base-commit: 91c120b49e83b867e29684fd229c3e1f07190071
-- 
2.47.3

