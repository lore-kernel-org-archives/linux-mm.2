Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 604DBCD4F3C
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:37:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3251A6B0088; Sat, 16 May 2026 14:37:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25E976B0095; Sat, 16 May 2026 14:37:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B1CF6B008C; Sat, 16 May 2026 14:37:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E399E6B0005
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:37:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8CE371C0E28
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:27 +0000 (UTC)
X-FDA: 84774140934.24.4E86FA5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id B77AA8000E
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fk8U0nia;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778956645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uIwfwvS4toLjznXiH/+kPYss+R0nYvyBQSJS2/7Ja7A=;
	b=N0AVsCZiWnUKNw+cNt7IFlppYRoUzCm7PLxSLhePCTgRDzSgSOn+t4M3cqctKtqQ7rgTK8
	hKH0KoQpLoB7PG/Rhm6yLa+2rFwXSosCSIq7fLZv2sev2sswZQtuNwzSoo/sSzDsLEJuEH
	sSFj9bIA8dIWx8mQ9B3oJb+pgJ6jVdU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778956645; a=rsa-sha256;
	cv=none;
	b=w957Oy7ZWC3m1KC6rwvvftlWzNf3SUQPfcjOebALsNE+o4LDiQntyql1Smo8er37BaWfnj
	rRmvMqHeD2MbDO1+s+ZkTRCzuBDEbuxuATfVuU2lT4Az38Runo5aSP9RkOO1UaL8shPVWN
	xqF2y8/YdTudion/6U9ykO9gebtCCcs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fk8U0nia;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9DBD44017A;
	Sat, 16 May 2026 18:37:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB461C19425;
	Sat, 16 May 2026 18:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778956644;
	bh=iNE/SB8H53Nzextg8blBzeBIvjL6Bieyu8nHGY4bfl4=;
	h=From:To:Cc:Subject:Date:From;
	b=fk8U0niaHwU8+O663bnFtGKSIAspTm435SwxEs0Xdbsh5kW3OyPFSaOtw1ZlsVTBI
	 rarbyKZ8EEZ23lWyi5EXJVDchP5jcPV4h+cpCNrQNdpmzCxhJ37zh/e8QeHMOb9GUK
	 IAq/ZGRLHpecpiVl7kxQgDmXejLor/mjCTFhTreHJxak6SgqbBtGNwrHqelVZQrG+i
	 ObBEuLJjmycc8n6vbdor4ZV9Ue/Cm+dNLTriRFTv9n3HQq4T4DfcGiVvE05cRpRRpv
	 z4a7ZnkS9lwPmCdUCJzMG6hz38mt8JK4YrAlxzXPppHAN9DwMI6pF1/IDMVaA4h6qM
	 mJtXOlL6vgepg==
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
Subject: [RFC PATCH v3 00/28] mm/damon: introduce data attributes monitoring
Date: Sat, 16 May 2026 11:36:41 -0700
Message-ID: <20260516183712.81393-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B77AA8000E
X-Stat-Signature: 4m1g8u6oekasocq3meh4njfhfi5hnh81
X-Rspam-User: 
X-HE-Tag: 1778956645-782445
X-HE-Meta: U2FsdGVkX19QX+tcFKVfuks1sQIyur46acANFprVM0TvmNgaqgIt0n3trQYI9NaN8O+cshz5LeK2N9KPGZiHvi6LNouI+78Y9CU69JvFXYHlErIf8EPprR1TLNky4+gc8wjLyA9/qMVAwe8duIa6Jd7eeZIoapNzzaDn2BYZfhXkZ5s1I2qSDSfgCNKwD/QqlsxWZiCjWS7+TjBR2nNS47O9kzGb23XiPTq1kGQyu1JLkGK7qb1IAuGdk1YhZclpON8zcp3l/jei93owVltzntgVSB09Jc7PzH21dSHxVGV/nTuLmQ57M+qMUeSPqbKjxSPaOu9YSHY1g9ivEHo85G0roWxWzN3Nu6H9bJSB+tRJsoke+HkvTgstg9H4QcNi31tCG0s1ZJidZYoACQ3NnA5sFtb+l5Ovwc/jpqhJpw++m8L9wFSXP+wBB94osmYCZGqvndQLNM+kDwTiLseQVQXAEtU+nfISED0yrg/q8A2DGtN5dlU3Db2PAu4Y9XGalAhVpAPLfBjL3sP42Sid4jv1PaYgT8xqT3ygVOXHRqttt+dHmaLE33jzhPLh1gUnA7y2kRzLPLA4a2Kyy89Gdg+6H0wHC4kEkRe/a2Bjn6oXAkl4PE+nHWiJxCSoq1i4OEMvZcNLo7A3AGdio1zGRcA7csLZjUgMbbxk8NTDBwP3nQ5OXmKtYc5+pYsBhbNWoAgrF6Bqou36AqmsUmgf/3iYWJlpU4DRdOjUfy5Zp3WhFV9l3Qy4M6twQ529dusaLBgzjB1+suRXZCbwtRyG1ovP934IHmbjLnLts/bhxlMjZ+vCQyWaVfyOgXQAn0tKLH+2m3k+9XUhOk7c+uuH5extp5dPq3oAUJWg7SzEH/lbdfqCrJde4FDZiJ2MSaDmh+J4XzIF9GX8oI+IbT7ygf0yYeMaRxE8452ZDmmFTLSln66XLwX65kzppHiA5TJeHAL/8fSFtvlvscudFJI
 QI/uexaJ
 Yfu2Z3lty2nQJBbl3f8pSctpuYY+50ilYRavZPt8cwgLe6iY6VlDTKQuLo0ybaaERguZ5yEPr5K6PqVXCBS5cWJu9R+5Y/Mz/BkReAUqgYNBNIMuoTfUdV6icPELqy0fHVAB7hvtBBdFXiHGaoV/SJn7L3mCKPYNZUQy8HH59q6FFSSfkce1+N698jAhkD5I7pok3jaA+z4z64GIR94/a9dJvPiz9PAlFwRdLIZCrz+CfclqfYRNhy8W3cAj8SzmqhBzj
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

Changes from RFC v2.2
- rfc v2.2: https://lore.kernel.org/20260515004433.128933-1-sj@kernel.org
- Rename damon_aggregated_v2 trace event to damon_region_aggregated.
- Address Sashiko issues.
  - Enclose arguments on damon_for_each_{probe,filter}[_safe]() macros.
  - Fix typos in comments and documents.
  - Update probe_hits for region split and merge.
  - Add more documentation for damon_operation->apply_probes() callback.
  - Reduce unnecessary folio_{get,put}() in damon_pa_apply_probes().
  - Define damon_sysfs_probe_attrs as static.
  - Link scheme tried region sysfs dir and increase the count only after
    all internal dir population success.
  - Commit damon_filter->memcg_id for newly added filters.
Changes from RFC v2.1
- rfc v2.1: https://lore.kernel.org/20260514140904.119781-1-sj@kernel.org
- Rebase to mm-stable (7.1-rc3) to avoid Sashiko patch apply failure.
Changes from RFC v2
- rfc v2: https://lore.kernel.org/20260512143645.113201-1-sj@kernel.org
- Optimize nr_probes calculation for probe_hits tracepoint.
- Use TRACE_EVENT_CONDITION() for probe_hits tracepoint.
- Rebase to latest mm-new.
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

 Documentation/admin-guide/mm/damon/usage.rst |  46 +-
 Documentation/mm/damon/design.rst            |  39 ++
 include/linux/damon.h                        |  69 +++
 include/trace/events/damon.h                 |  38 ++
 mm/damon/core.c                              | 211 +++++++
 mm/damon/paddr.c                             |  76 +++
 mm/damon/sysfs-common.c                      |  41 ++
 mm/damon/sysfs-common.h                      |   2 +
 mm/damon/sysfs-schemes.c                     | 226 ++++++--
 mm/damon/sysfs.c                             | 557 +++++++++++++++++++
 tools/testing/selftests/damon/sysfs.sh       |  48 ++
 11 files changed, 1305 insertions(+), 48 deletions(-)


base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
2.47.3

