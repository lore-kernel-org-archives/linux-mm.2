Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C88C7C624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:25:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D328C6B0098; Tue,  1 Sep 2026 09:25:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBC826B0178; Tue,  1 Sep 2026 09:25:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD2DD6B0179; Tue,  1 Sep 2026 09:25:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 93B3C6B0098
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:25:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 24FC71603C8
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:17 +0000 (UTC)
X-FDA: 85165264674.08.A40BB82
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id A2530C0004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y259m33w;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788269115;
	b=QIWaL78bxUA/gDtZ7lM8gUvCey6Qq5dEOtGUWjoD7bTn2yZwbIBQOyAQzj82thIr9vuLZu
	I+wUG5gyh2sgBxQ9NFAWDpOFGSlEk+SbzRVR9xI7rtHh6UqFbUkVeB01vEgVAyAOvwVj91
	3nqJ0sGeU5R9Y+D3oX84XoNr3t9ztJk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y259m33w;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788269115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iKaykvSVFIelvzxrD/j+8wQNprXmphpbUgzmXQCwYfg=;
	b=nxzM73jRv78cu7LIxGk4nEIPjQCjn0GuWvz9IqlN6u9qFdxdpbcHtSVaogLgNRpbiEQ5rE
	NbopalcY703jFMmHcwWPHVS15t6ngmwgSqVFVnrTfuAmp3owloEiq3EY4CGtauZ4R3/Laz
	e/xvOeZwn3mLS47hQ2e0zjiU3EksgBM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 215E86053A;
	Tue,  1 Sep 2026 13:25:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356391F00ACF;
	Tue,  1 Sep 2026 13:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788269114;
	bh=iKaykvSVFIelvzxrD/j+8wQNprXmphpbUgzmXQCwYfg=;
	h=From:To:Cc:Subject:Date;
	b=Y259m33wZ0SkNhjJHqIdHrS3Nqg0mb23/qke/Cba9sSb+hfSzNVKR2g4FF0bJc5s1
	 LHrkeYApIvmhxmymyVYAmnTGsttd6xfgZTlpU/2zvB7oNgz3+stfd04PDhFYai84S0
	 fXFdfyMGQeLMQhukodYaEVn7BPz45bvzLt3F7Z90Q+kUzq7p5i0OTHf5CsJR+81yh4
	 hnLbE3g3F4kLxcOr+E85BOIshEw/0Qzt+OnHLOCXry+ERY4GsO6c9eAmRz6J727+/W
	 Lb2Qgcf+LMVFaVbjMTm5VSB8PgbwMWvKRHiVhGO8mReL2OjWtQbpO+NckOtaYFLOtm
	 xks0qJNQeu+OA==
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
Subject: [PATCH v1.1 00/17] mm/damon: introduce data access-as-a-data attribute
Date: Tue,  1 Sep 2026 06:24:47 -0700
Message-ID: <20260901132506.99243-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A2530C0004
X-Stat-Signature: rz9pcuwa1f97u9ygby8hqfg6jd194d1m
X-Rspam-User: 
X-HE-Tag: 1788269115-605093
X-HE-Meta: U2FsdGVkX18qgoLGekdJzr30k7mBVjUCnxpD8mMbjMdmLQn/DsTNc1GEIyaQic5e4nICKw/I4t1EIg1p5eKrsGiu1/MUUrl+hEkfwofAgwbIREEsfWHo0qJEEul6rA3RsV7CHU/f2xgpeNudQqWS2EzT7074cMWh3Ow/QyUC8XqN630oWDxwMNz85+GgUhwtknWGrpGqHjMAObPx7dgPP5wWLcq6m9b0JyrloWI8Sgmquh5p/hyLMSaykiuT2zfjOVPFoZG0bVUQbjNkpo3mjdf1WvKcjy8in2s6v0P6em7STxsC55K65EGuxaXiKLf8+tcMDFgYuL8R6MQY04u/xma1+pRz/ovjAtMUr5A1vFIeLCTMV2FbeCMJV9W4Y/6PkZ/c4RHwlw2dze81yq32tokPtSpZalHjZ7gpBdm10vR5Zt3xXhSINr1RaYoQiKnC3wH1GRARg7JW4FiUedpJgtTCjR2qh4RIpO80ovBUhRqOoO2iQQEMod9zb7VC/TZuuDI238p7buALxoVL+mm2XGXRX1Y1lm3Ot7Yj4i5bfmL5lqc40ceRI7xzYHtLV1vPj4+aHdOvzHtP0VSIGEOs1mFCRwGw6GX6qBpW1uIvQ0bckKjuTQ2bliRc7tQ1DgLBfB1umnQ8P0aGtrgASOpF4OXA+AdEPFqTHx5F2SIJARM+ZcbpM2ulPyNDcUachjCcjMTu6n0tFl53UMgIHAi5ideu9OnGMG4mv/4utK7JvDahBROLYg7kklkk4YLPEmIvel0OUeCugekavGlxh2YaoVi4jd+iTz7fCFK80wyllUdSOvaLliMn757yL2F2UU5Dr0Rdjo+hASmQllheZ/eCf3a7+3UTq3PzyjFcIBckSnQlYr1qGzkx0Qe/htgR+aFyKTqb3x51HK8NVWJJCMeQd36PO1zmzAU7jRYOzUleYWoiNqQXE/tqPUbR1NTgcX+ucMFZfE0lvc/T396za5J
 gcFZNyb7
 sRgCIyt/rl4I70D06Yh/OQyXRNqHh7rxwl4yE9+BK287N8D/VH8XXJrc2gjj7k6M06bOnMsh7Vu/Twuvm8baNwQ74hrj5YNGFMh/Lp1Ka2hksCVb6tUkBiRHyG78iglMaeepj1aPNUEGUT4W4Pb/dhCssezfoiicKARcfComx4TQfz0MtJQL2dS4o+Ps2LRLUkQd8kaDAlnzx84VKJZZqTHgahE1xKIwlauMRI3F8wByygQAuzYmVbfJEkJyKh/9TzMOM
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

Changes from v1
- v1: https://lore.kernel.org/20260901043417.2165-1-sj@kernel.org
- Fix the race between the prep action sysfs write and the context build.
Changes from RFC v2.2
- RFC v2.2: https://lore.kernel.org/20260728041242.187380-1-sj@kernel.org
- Update test results with latest version of damo and masim.
- Drop RFC tag.
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
 mm/damon/sysfs.c                              | 283 +++++++++++++++++-
 tools/testing/selftests/damon/sysfs.sh        |  27 ++
 8 files changed, 531 insertions(+), 14 deletions(-)


base-commit: d153c4c92de32f97b155e3b6418c29094f81b99f
-- 
2.47.3

