Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF306CD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:37:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 118A66B0088; Tue, 12 May 2026 10:37:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F0596B008A; Tue, 12 May 2026 10:37:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F21AE6B0093; Tue, 12 May 2026 10:37:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E01826B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:37:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 89F1B1604C3
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:00 +0000 (UTC)
X-FDA: 84759019800.18.4D893CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 052E840005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:36:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZBfBTbeu;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jDC5tpZk5277BwB/FUePEiJwLXBLhzmR2dY40y6wmrc=;
	b=vItE49vIMnyxQTaOhkmg2jZCitvvJvEx3/f+0oyqAIDjHXVsHOBXpxcGWT0FK8JT9dlPES
	1FrVACm1Nqj5LzbMg7ebvOuMQpLXC0KhTogKZiruB6SDWgbJdo3UxSIio0Xie+rp7s6Pav
	jcL/UnbMmi4/E0GHUiYQQLauHLNjGpY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZBfBTbeu;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596619; a=rsa-sha256;
	cv=none;
	b=HNyV3K4PKN4kmrnQiHfSza9DsWXiJQ5LKsyju63VUXsEQfQz3EgN4R7LklSMbk2eI5QsK6
	p5vtFiDNKfxzH98sq6zeN+UvU3IVGHQoFeplkK6UBwq4/OZ3yUqmsWLDWhewH1yj2bRg/r
	+7oILhtCbHJcH9P2zufRkkToO9Vg498=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4C8A862D3F;
	Tue, 12 May 2026 14:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38AEDC2BCF5;
	Tue, 12 May 2026 14:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778596618;
	bh=7F/ryfTUPbE5rEOVFUA4IxCF/HI6Imw6cG75twUciDM=;
	h=From:To:Cc:Subject:Date:From;
	b=ZBfBTbeuXnIp4I2KxsJIxAxQ65BRZxJ2GW4rk4f3SsRM6qBaMLvqCSGx+Uy0/nAJk
	 86DWoHjTJlFIxzZlUmjLqWwWIkvv4KYxkagmTeMuksri8oWMp1pOodCfAkxa6CbGau
	 7mAnx5i7ZBzf0VNexxUx9KLpFXMsCChr+FjbkVW2b3WKbJDXepQIigxz6VZ8bp/oh/
	 xwSzDHmcIeqoRDPoqsjWSs3CMM++hzfrnZ6QK4iNDHCuC/sGH75ysOnW7bD2nCuCCs
	 eS5NCX5MUFOQEKmJ8+ZxArxL4k0PDQXox4gkyRnCmDDukSyP+C2HOvmCO8myzi+Psq
	 wSUO3AwGS5tCQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: [RFC PATCH v2 00/28] mm/damon: introduce data attributes monitoring
Date: Tue, 12 May 2026 07:36:15 -0700
Message-ID: <20260512143645.113201-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ui4t3w3pt1g69x4m7xtf4anxdf9yh4i3
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 052E840005
X-Rspam-User: 
X-HE-Tag: 1778596618-210125
X-HE-Meta: U2FsdGVkX19MpAJaI6RvgqxD2JGxq7R5NkBt5nylJTFa5XGzbO+53uMbNxs+37woHcb1XSCuJaGEgp4dmPH1Hlv7RTKe5Q33T/AwbIIYPbrw/DELGlctXLrN53Irjun3yI7btpagp79nAdjIecO9g/Mf604fFzCzS48N8uUDjobO621yVPjsql9XyHKhyJedu8AvF3SWKUCzVPGg7q2F6F6qlpWedms93+dCRu0OAlmN2T3Qxj0ShkS9HCcq3zm8QwO8fuM1PHuEFie8FGADICGnr0CogzpAuaeYoFf3aAiB5UAgkQK1dsrDBxmNprUF9vQMW5EOf28ekDu+744LjqZBIPRNNoTFb3hGGFV2H4VIeVTAyDjkm48GECBEaAEbZ5HLSDQb7JrpZ39p6Khi1RKiTQEcLL7sBeS84Y5wCPB2XqXPPJKVxoAY7JW0TNtZu0p8ZODcxUF9XbTw0ZYl1VSj5kBDVsAN0eXjKTDPeaLZTlWwlKvRikWkHOo4opMl7bsqL3ckq3XwL2GJtFIjXHBkqIuTsYwUC9JFKOJyvpFAB+WGtnmXbqOBjYQ7k/cqOjDuYWZ62vBeOKf5Lyh7GR4RfABD4lZieQCsvvfi41SZ8jA7xHLMBEXGuxzZGziEjPa3srmSFDOlpPrGgwk6n0uTJNN0azh/H6Zx1QDuv5Z9y65+x/hoAGbHysAyT8RREJXtVO9sVHyCA9qXlrFBqKL3FuY9S7s1MPzADgi+P+NHH1levymQlVLM1B9kuPSiaEOUq+F2rrcAT1lXZeiPslh4adjS5lEn4aQWy+mzKFiRCF+4b8oAIp04Zv+Sb2gNnqbIHBY7s5j0BPn2cU7yN34L0wGVuPbWObGQDbL03Uwgq+WTWdI5xQ30rlOSGvT0JMfdylqRCQCg43OgGl8rl4Dk6/PvR5g5KmPEX/jewvkmO7hlfbcP8eycGUKZgrexUwEB7/ELOMWCodkykj7
 VVZPs3pD
 zhY+5ASFsfT1rJW9azOY2t2ljj/1ZKGzib+QLfwiUnSq4CIWB0NxTXOE3pE0fpCOYt8hvCbU7s/IJSRf9Ie6jRjuqo024981l+spzagDOdS21dBiHvrfMJ3Gu1srLoO/KnMTKCsNWRY24dvAURBBmZNni6vNC/JuA2QpICxWMj7JGSCDgVPVMqnKUF49R5O7kCe4VUOVEplYnRgocnGG2qChdxUcmFGiUvaVgl0qPZWWOr2v2gp7l+kOe50bjsLLWqM6O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR
======

Extend DAMON for monitoring general data attributes other than accesses.
The short term motivation is lightweight page type (e.g., belonging
cgroup) aware monitoring.  In long term, this will help extending DAMON
for multiple access events capture primitives (e.g., page faults and
PMU) and eventually pivotting DAMON to a "Data Attributes Monitoring and
Operations eNgine" in long term.

Background: High Cost of Page Level Properties Monitoring
=========================================================

DAMON is initially introduced as a Data Access MONitor.  It has been
extended for not only access monitoring but also data access-aware
system operations (DAMOS).  But still the monitoring part is only for
data accesses.

Data access patterns is good information, but some users need more
holistic views.  Particularly, users want to show the access pattern
information together with the types of the memory.  For example, users
who work for making huge pages efficiently want to know how much of
DAMON-found hot/cold regions are backed by huge pages.  Users who run
multiple workloads with different cgroups want to know how much of
DAMON-found hot/cold regions belong to specific cgroups.

For the user demand, we developed a DAMOS extension for page level
properties based monitoring [1], which has landed on 6.14.  Using the
feature, users can inform the page level data properties that they are
interested in, in a flexible format that uses DAMOS filters.  Then,
DAMON applies the filters to each folio of the entire DAMON region and
lets users know how many bytes of memory in each DAMON region passed the
given filters.

This gives page level detailed and deterministic information to users.
But, because the operation is done at page level, the overhead is
proportional to the memory size.  It was useful for test or debugging
purposes on a small number of machines.  But it was obviously too heavy
to be enabled always on all machines running the real user workloads.
For real world workloads, it was recommended to use the feature with
user-space controlled sampling approaches.  For example, users could do
the page level monitoring only once per hour, on randomly selected one
percent of machines of their fleet.  If the runtime and the  size of the
fleet is long and big enough, it should provide statistically meaningful
data.

But users are too busy to implement such controls on their own.

Data Attributes Monitoring
==========================

Extend DAMON to monitor not only data accesses, but also general data
attributes.  Do the extension while keeping the main promise of DAMON,
the bounded and best-effort minimum overhead.

Allow users to specify what data attributes in addition to the data
access they want to monitor.  Users can install one 'data probe' per
data attribute of their interest for this purpose.  The 'data probe'
should be able to be applied to any memory, and determine if the given
memory has the appropriate data attribute.  E.g., if memory of physical
address 42 belongs to cgroup A.  Each 'data probe' is configured with
filters that are very similar to the DAMOS filters.

When DAMON checks if each sampling address memory of each region is
accessed since the last check, it applies data probes if registered.
Same to the number of access check-positive samples accounting
(nr_accesses), it accounts the number of each data probe-positive
samples in another per-region counters array, namely 'probe_hits'. When
DAMON resets nr_accesses every aggregation interval, it resets
'probe_hits' together.

Users can read 'probe_hits' just before the values are reset.  In this
way, users can know how many hot/cold memory regions have data
attributes of their interest.  E.g., 30 percent of this system's hot
memory is belonging to cgroup A, and 80 percent of the cgroup
A-belonging hot memory is backed by huge pages.

Patches Sequence
================

First eight patches implement the core feature, interface and the
working support.  Patch 1 introduces data probe data structure, namely
damon_probe.  Patch 2 extends damon_ctx for installing data probes.
Patch 3 introduces another data structure for filters of each data
probe, namely damon_filter.  Patch 4 updates damon_ctx commit function
to handle the probes.  Patch 5 extends damon_region for the per-region
per-probe positive samples counter, namely probe_hits.  Patch 6 extends
damon_operations for applying probes on the underlying DAMON operations
implementation.  Patch 7 updates kdamond_fn() to invoke the probes
applying callback.  Patch 8 finally implements the probes support on
paddr ops.

Ten changes for user interface (patches 9-18) come next.  Patches 9-13
implements sysfs directories and files for setting data probes, namely
probes directory, probe directory, filters directory, filter directory
and filter directory internal files, respectively.  Patch 14 connects
the user inputs that are made via the sysfs files to DAMON core.
Following three patches (patches 15-17) implement sysfs directories and
files for showing the probe_hits to users, namely probes directory,
probe directory and hits files, respectively.  Patch 18 introduces a new
tracepoint for showing the probe_hits via tracefs.

Patch 19 adds a selftest for the sysfs files.

Patches 20 and 21 documents the design and usage of the new feature,
respectively.

Seven additional patches (patches 22-28) for monitoring belonging memory
cgroup follow.  Depending on the feedback, this part might be separated
to another series in future.  Patch 22 defines the DAMON filter type for
the new attribute, namely DAMON_FILTER_TYPE_MEMCG.  Patch 23 add the
support on paddr ops.  Patch 24 updates the sysfs interface for setup of
the target memcg.  Patch 25 move code for easy reuse of the filter
target memcg setup.  Patch 26 connects the user input to the core layer.
Finally, patches 27 and 28 update the design and usage documents for the
memcg attribute monitoring support.

Discussions
===========

This allows the page properties monitoring with overhead that is low
enough to be enabled always on real world workloads.  Because the
sampling time for access check is reused for data attributes check,  the
upper-bounded and best-effort minimum overhead of DAMON is kept.
Because the sampling memory for access check is reused for data
attributes check, additional overhead is minimum.

Still DAMOS-based page level properties monitoring should be useful,
because it provides a deterministic page level information.  When in
doubt of the sampling based information, running DAMOS-based one
together and comparing the results would be useful, for debugging and
tuning.

Plan for Dropping RFC tag
=========================

I'm considering renaming the tracepoint for exposing probe_hits
(damon_aggregated_v2).

Making changes for feedback from myself, humans and Sashiko should be
the major remaining work.

I'm currently hoping to drop the RFC tag by 7.2-rc1.

Future Works: Mid Term
========================

This version of implementation is limiting the maximum number of data
probes to four.  I will try to find a way to remove the limit in future.
I personally think it should be enough for common use cases, though, and
therefore not giving high priority at the moment.

Future Works: Long Term
=======================

There are user requests for extending DAMON with detailed access
information, for example, per-CPUs/threads/read/writes monitoring.  For
that, I was working [2] on extending DAMON to use page fault events as
another access check primitives, and making the infrastructure flexible
for future use of yet another access check primitive.  Actually there is
another ongoing work [3] for extending DAMON with PMU events.  The
motivation of the work is reducing the overhead, though.

In my work [2], I was introducing a new interface for access sampling
primitives control.  Now I think this data probe interface can be used
for that, too.  That is, data access becomes just one type of data
attribute.  Also, pg_idle-confirmed access, page fault-confirmed access,
and PMU event-confirmed access will be different types of data
attributes.

The regions adjustment mechanism is currently working based on the
access information.  That's because DAMON is designed for data access
monitoring.  That is, data access information is the primary interest,
and therefore DAMON adjusts regions in a way that can best-present the
information.

Once data access becomes just one of data attributes, there is no reason
to think data access that special.  There might be some users not
interested in access at all but want to know the location of memory of
specific type.  Data probes interface will allow doing that.  Further,
we could extend the interface to let users set any data attribute as the
'primary' attribute.  Then, DAMON will split and merge regions in a way
that can best-present the 'primary' attributes.

DAMOS will also be extended, to specify targets based on not only the
data access pattern, but all user-registered data attributes.  From this
stage, we may be able to call DAMON as a "Data Attributes Monitoring and
Operations eNgine".

[1] https://lore.kernel.org/20250106193401.109161-1-sj@kernel.org
[2] https://lore.kernel.org/20251208062943.68824-1-sj@kernel.org/
[3] https://lore.kernel.org/20260423004211.7037-1-akinobu.mita@gmail.com

Changes from RFC
- rfc: https://lore.kernel.org/all/20260426205222.93895-1-sj@kernel.org/
- Support memcg DAMON filter.
- Use per-probe probe_hits sysfs file.
- Use dynamic_array for probe_hits tracing.
- Fix filter matching field.
- Fix folio leaking in damon_pa_filter_pass().
- Move nr_regions of damon_aggregated_v2 tracepoint after end.
- Rename DAMON_TEST_TYPE_ANON to DAMON_FILTER_TYPE_ANON.

SeongJae Park (28):
  mm/damon/core: introduce struct damon_probe
  mm/damon/core: embed damon_probe objects in damon_ctx
  mm/damon/core: introduce damon_filter
  mm/damon/core: commit probes
  mm/damon/core: introduce damon_region->probe_hits
  mm/damon/core: introduce damon_ops->apply_probes
  mm/damon/core: do data attributes monitoring
  mm/damon/paddr: support data attributes monitoring
  mm/damon/sysfs: implement probes dir
  mm/damon/sysfs: implement probe dir
  mm/damon/sysfs: implement filters directory
  mm/damon/sysfs: implement filter dir
  mm/damon/sysfs: implement filter dir files
  mm/damon/sysfs: setup probes on DAMON core API parameters
  mm/damon/sysfs-schemes: implement tried_regions/<r>/probes/
  mm/damon/sysfs-schemes: implement probe dir
  mm/damon/sysfs-schemes: implement probe/hits file
  mm/damon: trace probe_hits
  selftests/damon/sysfs.sh: test probes dir
  Docs/mm/damon/design: document data attributes monitoring
  Docs/admin-guide/mm/damon/usage: document data attributes monitoring
  mm/damon/core: introduce DAMON_FILTER_TYPE_MEMCG
  mm/damon/paddr: support DAMON_FILTER_TYPE_MEMCG
  mm/damon/sysfs: add filters/<F>/path file
  mm/damon/sysfs-schemes: move memcg_path_to_id() to sysfs-common
  mm/damon/sysfs: setup damon_filter->memcg_id from path
  Docs/mm/damon/design: update for memcg damon filter
  Docs/admin-guide/mm/damon/usage: update for memcg damon filter

 Documentation/admin-guide/mm/damon/usage.rst |  48 +-
 Documentation/mm/damon/design.rst            |  39 ++
 include/linux/damon.h                        |  67 +++
 include/trace/events/damon.h                 |  36 ++
 mm/damon/core.c                              | 195 +++++++
 mm/damon/paddr.c                             |  76 +++
 mm/damon/sysfs-common.c                      |  41 ++
 mm/damon/sysfs-common.h                      |   2 +
 mm/damon/sysfs-schemes.c                     | 222 ++++++--
 mm/damon/sysfs.c                             | 557 +++++++++++++++++++
 tools/testing/selftests/damon/sysfs.sh       |  48 ++
 11 files changed, 1280 insertions(+), 51 deletions(-)


base-commit: 610724cfd93c1c413faf9e5bb63926fe54849887
-- 
2.47.3

