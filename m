Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C355C624CE
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 04:34:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF0626B00E0; Tue,  1 Sep 2026 00:34:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A63446B00DC; Tue,  1 Sep 2026 00:34:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B57B6B00E3; Tue,  1 Sep 2026 00:34:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4DA3F6B00DC
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:34:29 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B7E9CA02E4
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:28 +0000 (UTC)
X-FDA: 85163927016.14.2CD8082
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 237CB40003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g9dyY5kV;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788237267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Kl6FKJ30kHkfmj1MTuOyhkDqJxZ/bTl67RXI2xnze6w=;
	b=mzeY+/GDyXJxqJgpUeBlSPVx0MiZl3FPy6kEzytYmxZo1SuMVTqiwYBQLVnCb1DHCoF9sk
	tRfev2pjlvqi8lmP+K0nooXUdgpwYksFZv/91b6yZhqpQ05oVlVjUaDCuyxVMLR/OGRLxK
	2b9C7KUurHH4Q1iwdzDaIP91OImpt3o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788237267;
	b=RdWPfrYdlGLUUFeCby2aa0Cs1si/sVfr2E/tY0pF+tdYxNJ6viZhkJ8FWhbsKyGXIuuFay
	VwE76VgshE5EkHTFWvKEv5TwgOIF+A6uMgQfKnEBdPCVOl2f7lL8F/c+wul5ZX5GEhjy9Q
	z6lEJI+LevEqtba4ZA4NVdLva7b07Cw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g9dyY5kV;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8898040137;
	Tue,  1 Sep 2026 04:34:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57CB1F000E9;
	Tue,  1 Sep 2026 04:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788237265;
	bh=Kl6FKJ30kHkfmj1MTuOyhkDqJxZ/bTl67RXI2xnze6w=;
	h=From:To:Cc:Subject:Date;
	b=g9dyY5kVOiHk9l4WoX9AeZLi5jgIA3chtKhMIjYmnso+dER+WMjth347x1zXb6wpS
	 Ab9hJl1joi4vBM741J9svKWT4MM7jVjn9zo3CFchOSzC7+T3cx/xT76EJhAjfYmIs4
	 y6XNgTL99BcotK9uPDFN+3EJ05rtYacyiqok8w3C6HuNlutPPtO6gzws+txQ04bcTw
	 OC+ajZiJs9Xg188MV82IdcvKFu57CRq6lL5dD1SOxsGlXz2ESwHRh9bwJODkK1nvYw
	 C/YMDJrbk0hpYIEpX2Mvq1I69ntrqfHNg0+t8t78WPYLvgjzdGq5+TatIot7gwm1a5
	 tik6pN/9eUPjw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 00/17] mm/damon: introduce data access-as-a-data attribute
Date: Mon, 31 Aug 2026 21:33:56 -0700
Message-ID: <20260901043417.2165-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qonugkib8rwje381tf3yn3iewe8xmizs
X-Rspamd-Queue-Id: 237CB40003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788237266-917740
X-HE-Meta: U2FsdGVkX1+F0eiRTpgjfwXliTqbbtTgxenAs7hT6BWpiN0Iw8R4wjZtet6pTlUD09mwEN9sv+KgExLogyAf7hjkR9XxpWHvSeor1dKW2hL+iFNpO0Yg/Ly5bNr48RJis2Zgqh+naxFw7Fm5MYzl0j3+jvRhaWuWPBqfT39l3342WnDTGs3LP4VW5IbkCcd3AyM9T81GscI2J3VfYd7nSDUQStn0q47dtQF4Qs0Fgxe/AFUy4nBF9qW3c7b++ajgVrXXam+u2k5pJ/ME917VZNHZBE1wCVb78yDn3vAiZ182dMX0LytjhkV6ud1knMmXpPdeEt/VckEs5tETjm1/C6MqUin/TbvQknS6y21o12PXEtJeiFm3RDeaHOroklmeKbrLoGwL0nRz1beRj6YxE9N8mUPqxWpEVrBLxVbrdT4fqKLNNL87swNCHD+bby83cZFV9CL/+YrJTU8qb5bN9bEhslKQj9YG1P8qv882d7h/gxMUNad7XpKwFNmPsA44MdyOizj2lrNoXbM0OX/QfV/yYuGTCKHPn32V1bgvHUT6uXJFS4tlRkEpYGePRUmwv0s32bISR7dgf8k1IFIzfYb1NrHnPimkQSkKlZxOrFFrSfjRHjq/gQGV6Qp4LQ4Z+mOpnRFbrKYF8Vl4F9eQmgJDLCWqpBh0l+8BEkouZ15yCrnZBMLifubHjZeDA+nruMbYw5heGxZHGpwGxLdBCshEyYhVX2MxTx/10nzWWVpzsBzo3oJXzGHKzKKRSwluudPcaort6kLhUBZm7FJyVtZJPeoHXXAxLImBTPpSH38NUPYF5qDAUufV5cj+CmKE3iVjD/UoSb8QJ0o6dP75XDoCp28EnpYqoqmCZ1W0n1PuUCixHNIR5HbIYbA3l3gG4TbvYhduTot8XtWx5hpOvM1UsHbXjhFMfUDmcUnFTrjwM1VT1f5a1Mb/D6rRYzBb63njKbhQJajSyZWN3xQ
 A9iP3I6K
 frcAbrjMahpJdvovgBwMoP/BdgNweAOug7utEMrei+BmlQ4YFjcSAbs2jhzyhOFzi8Hi3na7BZIugmJH3ow/4FLDeYd4BU2oFCy54l93GcnbLeDclk1rSlyjo2vvGc2cYIeb4eHOrV5K8AUzIReU04egjPYlLEQV5ySCYyVdU13C5GU/22tUPnmmEp0ZgUp8JWJ3oQBRNO5Yd11THgZnnIAPVdvAasDULheHQVa3OxUBDMgzNuJpBvtj5eQFYkJDTAQGK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL;DR: extend DAMON's data attributes monitoring system to support page
table accessed bit and PG_idle based access monitoring.

DAMON was initially introduced as a data access monitor.  Users found
data access pattern becomes more useful when it is combined with other
data attributes such as belonging cgroups and backing page types.  For
such cases, DAMON has extended to support such data attributes
monitoring in addition to the original data access monitoring.  The
DAMON probes system was introduced for this purpose.  Users set probes
for filtering data attributes of their interest.  For use cases where
the primary interests are the attributes but the access pattern, probe
weights system has been introduced.  When it is used, DAMON applies its
adaptive regions adjustment based on the monitored data attributes.

However, DAMON stops access monitoring when the probe weights are used.
DAMON cannot optimally help users who have interests in both data
attributes and access patterns.  Data access can also be thought of as
another data attribute, though.  Extend the probe system to support data
access as a data attribute.

Introduce a new probe filter type, pgidle_unset.  It shows if the page
is not set as idle.  Specifically, it shows the page table accessed bit
and the PG_idle flag.  It can inform if the region is ever accessed. But
it cannot say when it is accessed.  To answer the second question,
introduce a new probe feature, prep actions.  Using the features, Users
can specify what preparation actions should be made to each region for
each probe.  DAMON executes the preparation actions for each sampling
interval, like it is doing the preparation for access check in the
access monitoring mode.  To help 'pgidle_unset' probe action use case,
'set_pgidle' preparation action is introduced together.  The action does
exactly what the access monitoring was doing: clearing the page table
accessed bits and setting the PG_idle flags.

Tests
=====

I compared the access pattern monitoring results from the classic way
and the probe based way.  As expected, the probe based way shows the
results similar to that of the classic way.  More detailed test methods
and results are below.

First, do the access monitoring using the DAMON user-space tool [1] in
the classic way.  The system is idle.  It shows no access as expected.

    $ sudo ./damo/damo start
    $ sudo ./damo/damo report access
    heatmap:
    00000000000000000000000000000000000000008999999811111110000000000000000000000000
    # min/max temperatures: -640,000,000, -100,000,000, column size: 99.800
    MiB
    intervals: sample 5 ms aggr 100 ms (max access hz 200)
    0   addr 4.000 KiB    size 3.898 GiB   access 0 hz   age 6.400 s
    1   addr 3.898 GiB    size 787.301 MiB access 0 hz   age 1 s
    2   addr 4.667 GiB    size 773.457 MiB access 0 hz   age 5.800 s
    3   addr 5.423 GiB    size 2.374 GiB   access 0 hz   age 6.400 s
    memory bw estimate: 0 B per second
    total size: 7.797 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

Start an artificial memory access generator (masim) [2] in another window.

    $ ./masim/masim.py run --config_file ./masim/configs/zigzag.cfg

Show the monitoring results.  As expected, it captures accesses.

    $ sudo ./damo/damo report access
    heatmap:
    00000000000000000000000000000000000000011111111111111118888888833378988888888888
    # min/max temperatures: -1,470,000,000, -12,482,536, column size: 99.800
    MiB
    intervals: sample 5 ms aggr 100 ms (max access hz 200)
    0   addr 4.000 KiB    size 1.542 GiB   access 0 hz   age 14.700 s
    1   addr 1.542 GiB    size 788.324 MiB access 0 hz   age 14.600 s
    2   addr 2.311 GiB    size 772.844 MiB access 0 hz   age 14.200 s
    [...]
    50  addr 6.839 GiB    size 1.742 MiB   access 0 hz   age 1.300 s
    51  addr 6.840 GiB    size 8.000 KiB   access 100 hz age 0 ns
    52  addr 6.840 GiB    size 1.496 MiB   access 160 hz age 0 ns
    [...]
    97  addr 7.162 GiB    size 1.199 MiB   access 40 hz  age 400 ms
    98  addr 7.163 GiB    size 1.199 MiB   access 20 hz  age 400 ms
    99  addr 7.164 GiB    size 2.004 MiB   access 160 hz age 0 ns
    100 addr 7.166 GiB    size 646.004 MiB access 0 hz   age 400 ms
    memory bw estimate: 26.148 GiB per second
    total size: 7.797 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

After the artificial memory access generator (masim) is terminated,
restart DAMON with the probe-based access monitoring.  As expected, it
shows no access since the system is idle again.

    $ sudo ./damo/damo stop
    $ sudo ./damo/damo start --probe_prep set_pgidle \
            --probe_filter allow pgidle_unset --probe_weight 1
    $ sudo ./damo/damo report attrs
    heatmap:
    00000000000000000000000000000000000000008999999711111100000000000000000000000000
    # min/max temperatures: -600,000,000, -430,000,000, column size: 99.800
    MiB
    probe prep: set_pgidle, filter: allow pgidle_unset (weight: 1)
    intervals: sample 5 ms aggr 100 ms (max probe hits 20)
    #   addr         size         age           probe_hits
    0   4.000 KiB    3.898 GiB    6 s           0
    1   5.285 GiB    2.512 GiB    6 s           0
    2   4.659 GiB    641.816 MiB  5.700 s       0
    3   3.898 GiB    778.375 MiB  4.300 s       0
    memory bw estimate: 0 B per second
    total size: 7.797 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

Start the artificial memory access generator [2] again.

    $ ./masim/masim.py run --config_file ./masim/configs/zigzag.cfg

Show the monitoring results.  As expected, it captures accesses similar
to the classic monitoring mode.

    $ sudo ./damo/damo report attrs
    heatmap:
    00000000000000000000000000000000000000011111110000000177777777777777878798887777
    # min/max temperatures: -1,330,000,000, 84,847,514, column size: 99.800
    MiB
    probe prep: set_pgidle, filter: allow pgidle_unset (weight: 1)
    intervals: sample 5 ms aggr 100 ms (max probe hits 20)
    #   addr         size         age           probe_hits
    0   4.000 KiB    1.508 GiB    13.300 s      0
    1   1.508 GiB    794.684 MiB  13.200 s      0
    2   2.284 GiB    764.555 MiB  13 s          0
    [...]
    50  6.711 GiB    4.625 MiB    0 ns          17
    51  6.716 GiB    2.504 MiB    0 ns          17
    52  6.732 GiB    796.000 KiB  0 ns          17
    [...]
    90  7.162 GiB    512.000 KiB  2.200 s       2
    91  7.061 GiB    700.000 KiB  2.300 s       1
    92  6.935 GiB    316.000 KiB  2.300 s       4
    memory bw estimate: 0 B per second
    total size: 7.797 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

Patches Sequence
================

First four patches (patches 1-4) introduce the new probe filter type for
knowing if a region is accessed.  Patch 1 defines the new type in the
core.  Patch 2 implements the execution of the new filter in the
physical address space DAMON operation set.  Patch 3 implements a user
interface on DAMON sysfs interface.  Patch 4 updates the documentation
for the new filter type.

Following 13 patches (patches 5-17) introduce the probe preparation
actions feature.  Patch 5 defines the data structure for specifying the
preparation actions.  Patch 6 completes setup of the API parameter for
the prep.  Patch 7 extends the DAMON operation set callback list to
connect the parameter with the underlying operation set.  Patch 8
implements the execution of the prep in the physical address space DAMON
operation set.

Following five patches (patches 9-13) extends DAMON sysfs interface for
the new prep feature.  Patch 14 adds simple selftest for basic file
operations of the new sysfs files.  Final three patches (patches 15-17)
respectively update design, usage and ABI documents for the new feature
and its interface.

[1] https://github.com/damonitor/damo
[2] https://github.com/sjp38/masim

Changelog
=========

Changes from RFC v2.2
- RFC v2.2: https://lore.kernel.org/20260728041242.187380-1-sj@kernel.org
- Update test results with latest version of damo and masim.
- Rebase to latest mm-new.
Changes from RFC v2.1
- RFC v2.1: https://lore.kernel.org/20260727143829.86236-1-sj@kernel.org
- Evaluate ops.prep_probes first for do_prep.
- Rebase to the latest mm-new.
Changes from RFC v2
- RFC v2: https://lore.kernel.org/20260726173935.94046-1-sj@kernel.org
- Rename prep iterator macro param names to make more sense.
- Document set_samples param of prep_probes().
- Set do_prep after kdamond_wait_activation().
- Use const keyword for sysfs prep action-name structure fields.
- Fix typos in documents.
- Restructure sysfs interface patches for no build warning.
- Rebase to the latest mm-new.
Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260725210225.129944-1-sj@kernel.org
- Fix wrong sample_addr setup condition.
- Fix build warnings from sysfs part.
- Fix typos.
- Rebase to latest mm-new.
- Add the tests section to the cover letter.

SJ Park (17):
  mm/damon/core: introduce DAMON_FILTER_TYPE_PGIDLE_UNSET
  mm/damon/paddr: support PGIDLE_UNSET probe filter type
  mm/damon/sysfs: support pgidle_unset probe filter type
  Docs/mm/damon/design: document pgidle_unset probe filter type
  mm/damon/core: introduce damon_prep struct
  mm/damon/core: commit preps
  mm/damon/core: introduce damon_operations->prep_probes()
  mm/damon/paddr: support damon_prep
  mm/damon/sysfs: implement preps directory
  mm/damon/sysfs: implement preps/nr_preps file
  mm/damon/sysfs: create directories for nr_preps writes
  mm/damon/sysfs: implement prep_action file
  mm/damon/sysfs: pass preps to DAMON core
  selftests/damon/sysfs.sh: test probe prep sysfs files
  Docs/mm/damon/design: document probe preps
  Docs/admin-guide/mm/damon/usage: document probe preps sysfs files
  Docs/ABI/damon: document probe prep sysfs files

 .../ABI/testing/sysfs-kernel-mm-damon         |  13 +
 Documentation/admin-guide/mm/damon/usage.rst  |  18 +-
 Documentation/mm/damon/design.rst             |  15 +-
 include/linux/damon.h                         |  43 ++-
 mm/damon/core.c                               | 105 ++++++-
 mm/damon/paddr.c                              |  41 +++
 mm/damon/sysfs.c                              | 280 +++++++++++++++++-
 tools/testing/selftests/damon/sysfs.sh        |  27 ++
 8 files changed, 528 insertions(+), 14 deletions(-)


base-commit: 559cf8fac9b5af8d8d8c350fcf338e21aa049a31
-- 
2.47.3

