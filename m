Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0AE2CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:41:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 305C96B009E; Mon, 18 May 2026 19:41:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B6206B00A0; Mon, 18 May 2026 19:41:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17E6F6B00A1; Mon, 18 May 2026 19:41:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F11156B009E
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:41:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8DC84120A8B
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:26 +0000 (UTC)
X-FDA: 84782164572.08.1A621F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id F2AC74000E
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p+gfMcym;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PjB8oNoXOUfuQ//pi7viD3y35BwM9ddT/bRo+kcqNfA=;
	b=LCGZsHEgCFeFpv82IhQgI6gL2C2Y3FCWJa9a43iUzgp5IRrZ97tC3/D6D/wVDeTT1SVjl8
	NTEaFLGA2j7sKrUUUm7dwozt5XFuKkO5jEAII/LDtwYvkRKPfmJL7yvFRekOrWWqeKdPia
	J+k1KT1dB+LbU62o3ukN7prm5FgHxew=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p+gfMcym;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147685; a=rsa-sha256;
	cv=none;
	b=mJmgXGUjoIS6KA2l1jT3Wd53kUONaZXbnKsQ3PhMA8GR+LQvvssSwICuAJ4R4TPAqKnD3g
	+lcRT+YvWmy3o2RI4vknZw1vCQ5NycXK5Uv+ZOggF/06uM9vhgWLsHRDgJX676q7Mob1KC
	I4wxmbsbOOHBz2Ni35OQI17eo4MeBWI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 55DCE60120;
	Mon, 18 May 2026 23:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23052C2BCB7;
	Mon, 18 May 2026 23:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779147684;
	bh=+UVNLwm/E3CMO6tDmNKQr9wGx/8Ji4oKVLhQWJQz8T8=;
	h=From:To:Cc:Subject:Date:From;
	b=p+gfMcym9MmCahY6flskwcuLHsBvE014rcKXEUZbfmRvKzOedbuqddrOCtSszOLZe
	 zcmviOAIxwVkT8KB1eEf+V/sNxP+Jb5ebx3CK1MHXWZLpZs5/Io7fhUnRnVITI/1xq
	 csqlPy/x6PhX0RVx4P38vSbEsFqCScjjvAYftiKw7ogYxdzw2ztTgmR/9MYdh+ZYs1
	 IuJ4R1CFZck53hukueH74pnYpYUNHwxeLaLOXJKUKL/bMqXydkoOjIUEf2Oi6skuzm
	 xkvi33ItKDdWoHU8SWkQv5BhmliS3+KunEO1M7HxX1CEhEjlu/wzVgmJ4hyvlZY82A
	 FtRgrVeoEpKhg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: [PATCH 00/28] mm/damon: introduce data attributes monitoring
Date: Mon, 18 May 2026 16:40:48 -0700
Message-ID: <20260518234119.97569-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F2AC74000E
X-Stat-Signature: gfxanoywabr8eqy4h18f951rgmpeg6wk
X-HE-Tag: 1779147684-461492
X-HE-Meta: U2FsdGVkX1/FW3VsZIDJffjGpQcVf4bUmRT44UAl6rM/PggPghfBuRGkOanHkakiEx6hU+jy+12S7dRYzPIEIwgcwjaxDqjgnmtEcJBMfBCPgvLbFASwOwQjcIEjpZEnW+gHPfvEPc9mJkvlbDuDHCYo+RlHNEKVd91n1H7f7qfAaak9bSrkaSy8oVpgTWAWU24JnXJgLTYL003IBhTK2JCu/NBcV+9GonBWyigGQVdNNogWrgRKrqM9j4hEYhmqQVPYre3cQr1DND55Gt/qQqz8y7q9O1ihguTsqD4hWxBaJ9brTAPwNuDQLLjdiiNvyjWvCs/2cvfkWodO1XzXH3uyz9WVDTFLVm+7rbnhAq8IHCgJUDYHNDYPLAKj+y5MwKWYq3LACsVxaelIFkteH4mT/YxPBqtzT4l+vAMB40drBAX87rWqt0+U2unw7tClaydrKHHgfUk2QAKpurQkF7TkhI5AEg++qSWroCPVm7WfSruN6Y5tV9dQABGoIWUUmewbEydRyMxJaemtiZeKNCoGXDS750Nz8F6ck1zZKLR3J7f+vAEmlN395sPD5iwcU/581VyLkPoVu4kAyHgw6GuxdsNaTL9suRF+PszVMJflQRBz9JS5AKjYZHZgetXmn9Sy/MBi99AyhNOYJmVlv5X/RINt7XJXmnEriTvXi1ZhKIVIfgvHV0fRM09XtyxhsJBaGVD9Y3eajZsqC8JGCfP8u65tS/UUtrUE8Da8oU7Pe40ScWgUmYEpElXJmc7eevaOLg7Pfe2k6cP3lkpKpFy2dmDys1tX59YVBIYs112oVqY0ks667AIgWf0HxnQ/2nXSwWSuxvxKqxEvjgp9RJtuTW9bRC2+R1SX4Y3ExpXkq6v4EVZIEWifmBnq2Nic3YxPmR9JzfbElXBGua1oF9FzP514F5RnCzrW3LoraNyJh9jHa5v4kXDMy0GEATFKoLDZRfaVZqKigGN58H+
 V7sLxeYz
 rrb7tEHBD9HCe1/ASZyBVeOX0ukOW4mityi3pEMEix2DiPwx7VQr7GBmjHegFrOXU17NID3NcXLJcvMrZZrXqgJZXYyRiPvH8LvDuQI3vhd0AGpzLTMRQh2AwWVl0v8ore2RMEgzZ6chhuYwbJYr/q2DVWjzJ/odH945UUMBx9kmlphA6xwVFtt4pJaweVWsEt5yqZ8HsaUVoEGTbteOt64JIt/iFbTv80/B6Ogv2keeY8LB9X8XxGIghjWzwAVriomEK
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

Changes from RFC v3
- rfc v3: https://lore.kernel.org/20260516183712.81393-1-sj@kernel.org
- Wordsmithing documentation.
- Drop RFC tag.
- Rebase to mm-new.
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
 mm/damon/sysfs-schemes.c                     | 224 ++++++--
 mm/damon/sysfs.c                             | 557 +++++++++++++++++++
 tools/testing/selftests/damon/sysfs.sh       |  48 ++
 11 files changed, 1303 insertions(+), 48 deletions(-)


base-commit: b491d3b062a367a23fdc98def7fe3a8cf21bb3b0
-- 
2.47.3

