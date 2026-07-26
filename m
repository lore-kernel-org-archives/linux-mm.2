Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1491DC531C9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 17:39:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9911A6B007B; Sun, 26 Jul 2026 13:39:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91A286B0088; Sun, 26 Jul 2026 13:39:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82FF46B008A; Sun, 26 Jul 2026 13:39:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 442616B007B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 13:39:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A8EE64055C
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:46 +0000 (UTC)
X-FDA: 85031640372.01.4DDC051
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 348571A0002
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jz4U7A5q;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785087585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=eZF0ss9+g9cB5Ev9NZkvD3gx7fD3lvf0xPhKSAJkt+g=;
	b=SP0ihxPCYKZ7c3+TjwSZFjsbfJ7HCACntNKYemPD0ikRzuBzyYTWTZHk7H+dAeCZlkdP+H
	nckmkdlUSyN+jNQLTumCwdVgnXgoKzG69hy/Gqlxxyo6Gqas5XTOIsuL+O38KtzwIAZ8Ck
	U5DRrUZXxbo0R7v/uI+gmJ7REe2faJU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785087585;
	b=vm1Ufu/QXq2Sr2wbGIbhkYPTWNmTly4/WxIuCubtrXnDEOBX+pfryDPaPNSeIgJnHFCUMh
	CntORc2lx9hd9F1LMkj76GQAydSSVYj28CLS1KBQs2lJSIlvfLfF3kKl2+YPn7XjaR2IIb
	WVilCa++ZmSPKVDr51TjfBQCnwmb560=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jz4U7A5q;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6DEC960054;
	Sun, 26 Jul 2026 17:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD891F000E9;
	Sun, 26 Jul 2026 17:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785087584;
	bh=eZF0ss9+g9cB5Ev9NZkvD3gx7fD3lvf0xPhKSAJkt+g=;
	h=From:To:Cc:Subject:Date;
	b=jz4U7A5qxwSiAH6Wgo6OuAF4jeHzY9z7iCNmfO81tvM8PtJT6gBsXqvTJwxpSVKb2
	 QpUkcSYpnLj/eSi8ESFJSo2s58keD6NmqhZQua38+uQ0cTlqzgi87wdmZcsPfc5Jmy
	 yr7yNCtLuNHGulOUSBsFZRmFjWSmIGuFJuLSgKrZOOCV5WqKeY6LCiLLCXHZr7RUzM
	 aw8hJ33z/2v4De8rOsESGd3GLI4A8IfZ/zh3qEd1KugmgQsx0z/Pnpk/SyTph8GNFb
	 hyq/WKHn+lxeN7uZiOyGOD0GKNPAvTWjaelMjJIPVRUt9fkTd54VwpaD07hqdYRQOd
	 nu58U2PQydO6Q==
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
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 00/17] mm/damon: introduce data access-as-a-data attribute
Date: Sun, 26 Jul 2026 10:39:16 -0700
Message-ID: <20260726173935.94046-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pw1xccekh4e4qbnn1zaio8mxyu3b6b51
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 348571A0002
X-HE-Tag: 1785087585-814674
X-HE-Meta: U2FsdGVkX19Dfp6A0y1KoRbcdY3xZP4o8QqI6c0hn1CL82UGg//n6Fo3jDhJZSCsDy5JQVxoKXRmpGmpVCEiU0S99iyZue9VEJHLxJwKZnm5GW0V/Zmd4DBVM7Z0ygvi3H76BQ35Z4c9MRIjsgZh3RAPCvLKiVABBeazp2gPvHsH4hrxJW5QW7ktSovUoSkKoq3MlvlP2zuqhBbOJnpm97J1g41goVtHyZqgoN0enN4GbQvdroMW4OJZvEkBM0MJzD9HWnviOYy9nbzDcauAiE3E7B+ZXGFCoQqgShxxE/4Y9KrCHArOJ4JYDLaGXS953NbcEH0abcZR/fDMeR6rnTTqS9oZ56eCd6ASyx4AQgKuLexrOuqv5n6EmGhNBxbaPX7rvIAGCAanWAxRRsKUShPNbMR60dencM+smcGudlI2tkrXGTk5gCnYK/Cnpm9Lfs8aOjD2TpUMjMyTH52PrhS19Pfy+oiVstGlYkLv+nq5I90kXEfutsBUfwyVG7yw3Fem07q6gx+cfb+hwdwxS0L9H661b3WsxrhuoOslWDb06RD2a4bBw3K+W+qn6B6+5hgCRcykEQ9hveIxIZquVsbmOi7YqrHGSWjt40MugqHofb0VU1C8fGfnKG0WloEsE77DLO8JFwYdBNCPTfT0rYK+oqr9VrkjbLJaUVo2j5og4LtOTOjB6XB5xPd4D8qCYqM6iTMB35mfCTZaebUqLmCxeuwYVN/w1kVLpEUxNA8nGNFjZ4i85CgTuEQUG6purzbkKKpebyT20g9MhPM6dTJ4vnSH7rM5mCm4v0M1Yy0MIM1AnCFZ9p/NU+NbukpUSJVR5hqmsOUaBojcrLMiaCDaeY8+Ij/nJgOPlJo6qfWbSti1+LSUAHOqoOpRR/zOm5DsRe6XNMlISmTeiNETHdzimYP5iLsemf3lsHxoj0GcJFXsRIardaOJGHjQ0w0Wy74mf2hrAxQOXyw35+R
 TW7aaE8x
 54fgj5xUhwca59PKk2siaZ5ko6mJYk0J2Haf24EVf0YcH8A30OS/ThTn3pRGY3M5qRNoIX5zY7Bmc/YdMgt+uO/VY7WPuzkAZtGNKYopdec1YNapc71iYl6QhIx7BU/KxIJZCIuwmQUtxIfuHQOWIYxRLyQr7T9821aqD9zaGv6ZyAe6urymn4Ct3e9bno44LwvTguAnVFLp4BCJbrydeeaBN1TVCbnlovVSd3APZONm+zgCw9VCmmk6c7uRoiqShSpV0
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
    $ sudo ./damo report access
    heatmap: 00000000000000000000000000000000000000000000000029300000000000002222222100019000
    # min/max temperatures: -440,000,000, 0, column size: 99.800 MiB
    intervals: sample 5 ms aggr 100 ms (max access hz 200)
    0   addr 4.000 KiB    size 4.748 GiB   access 0 hz   age 4.400 s
    1   addr 4.748 GiB    size 167.664 MiB access 0 hz   age 0 ns
    2   addr 4.912 GiB    size 1.325 GiB   access 0 hz   age 4.400 s
    3   addr 6.238 GiB    size 744.301 MiB access 0 hz   age 3.200 s
    4   addr 6.964 GiB    size 438.594 MiB access 0 hz   age 4.400 s
    5   addr 7.393 GiB    size 115.883 MiB access 0 hz   age 0 ns
    6   addr 7.506 GiB    size 298.000 MiB access 0 hz   age 4.400 s
    memory bw estimate: 0 B per second
    total size: 7.797 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

Start an artificial memory access generator [2] and show the monitoring
results.  As expected, it captures accesses.

    $ ./masim/masim ./masim/configs/zigzag.cfg
    $ sudo ./damo report access
    heatmap: 68888888888888888888888888888886222222210017788888888888888888888888899999998777
    # min/max temperatures: -850,000,000, 40,000,500, column size: 99.800 MiB
    intervals: sample 5 ms aggr 100 ms (max access hz 200)
    0   addr 4.000 KiB    size 28.137 MiB  access 0 hz   age 4.200 s
    1   addr 28.141 MiB   size 880.000 KiB access 170 hz age 0 ns
    2   addr 29.000 MiB   size 4.000 MiB   access 0 hz   age 3.100 s
    3   addr 33.000 MiB   size 500.000 KiB access 160 hz age 0 ns
    4   addr 33.488 MiB   size 12.000 KiB  access 0 hz   age 1.700 s
    5   addr 33.500 MiB   size 40.000 KiB  access 170 hz age 0 ns
    6   addr 33.539 MiB   size 8.000 KiB   access 0 hz   age 900 ms
    7   addr 33.547 MiB   size 80.000 KiB  access 170 hz age 0 ns
    8   addr 33.625 MiB   size 32.000 KiB  access 0 hz   age 2.300 s
    9   addr 33.656 MiB   size 68.000 KiB  access 170 hz age 0 ns
    [...]
    528 addr 7.437 GiB    size 368.586 MiB access 0 hz   age 900 ms
    memory bw estimate: 28.521 GiB per second
    total size: 7.797 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

After the artificial memory access generator is terminated, restart
DAMON with the probe-based access monitoring.  Note that DAMON
user-space tool [1] gained the support of probe-based access monitoring
as an experimental feature, starting from v3.3.3.  As expected, it shows
no access since the system is idle again.

    $ sudo ./damo/damo start --probe_prep set_pgidle --probe_filter allow pgidle_unset
    $ sudo ./damo report attrs
    heatmap:
    99999999999999999999899866666664000000000000000277777775333333333333333333333332
    # min/max temperatures: -2,250,000,000, -1,690,000,000, column size:
    99.800 MiB
    intervals: sample 5 ms aggr 100 ms (max access hz 200)
    #   addr         size         age           probe_hits
    0   4.000 KiB    2.316 GiB    16.900 s      0
    1   2.316 GiB    790.730 MiB  18.400 s      0
    2   3.088 GiB    794.406 MiB  22.200 s      0
    3   3.864 GiB    796.473 MiB  22.500 s      0
    4   4.642 GiB    786.223 MiB  17.600 s      0
    5   5.410 GiB    2.326 GiB    20.600 s      0
    6   7.736 GiB    62.773 MiB   20.700 s      0
    memory bw estimate: 0 B per second
    total size: 7.797 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

Start the artificial memory access generator [2] again and show the
monitoring results.  As expected, it captures accesses similar to the
classic monitoring mode.

    $ ./masim/masim ./masim/configs/zigzag.cfg
    $ sudo ./damo report attrs
    heatmap:
    88888888888888899999999888888888400000003888888888888888888888888888888888888888
    # min/max temperatures: -2,100,000,000, 500, column size: 99.800 MiB
    intervals: sample 5 ms aggr 100 ms (max access hz 200)
    #   addr         size         age           probe_hits
    0   4.000 KiB    23.414 MiB   3.500 s       0
    1   23.418 MiB   35.121 MiB   3.500 s       1
    2   58.539 MiB   264.000 KiB  1.600 s       19
    3   58.797 MiB   16.000 KiB   0 ns          0
    4   58.812 MiB   92.000 KiB   1.400 s       20
    5   58.902 MiB   996.000 KiB  600 ms        0
    6   59.875 MiB   32.000 KiB   1.600 s       20
    7   59.906 MiB   24.000 KiB   6.900 s       0
    8   59.930 MiB   72.000 KiB   1.600 s       20
    9   60.000 MiB   160.000 KiB  0 ns          0
    [...]
    316 6.641 GiB    754.949 MiB  1.300 s       0
    317 7.378 GiB    428.676 MiB  1.500 s       0
    memory bw estimate: 11.633 GiB per second
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

Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260725210225.129944-1-sj@kernel.org
- Fix wrong sample_addr setup condition.
- Fix build warnings from sysfs part.
- Fix typos.
- Rebase to latest mm-new.
- Add tests section to the cover letter.

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
  mm/damon/sysfs: create probe preps directory
  mm/damon/sysfs: implement probe prep directory
  mm/damon/sysfs: create probe prep files for preps/nr file write
  mm/damon/sysfs: pass preps to DAMON core
  selftests/damon/sysfs.sh: test probe prep sysfs files
  Docs/mm/damon/design: document probe preps
  Docs/admin-guide/mm/damon/usage: document probe preps sysfs files
  Docs/ABI/damon: document probe prep sysfs files

 .../ABI/testing/sysfs-kernel-mm-damon         |  13 +
 Documentation/admin-guide/mm/damon/usage.rst  |  18 +-
 Documentation/mm/damon/design.rst             |  15 +-
 include/linux/damon.h                         |  42 ++-
 mm/damon/core.c                               | 103 ++++++-
 mm/damon/paddr.c                              |  41 +++
 mm/damon/sysfs.c                              | 280 +++++++++++++++++-
 tools/testing/selftests/damon/sysfs.sh        |  27 ++
 8 files changed, 525 insertions(+), 14 deletions(-)


base-commit: 4737efca4039cb5fe50569ea3ffb18c389483810
-- 
2.47.3

