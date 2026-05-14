Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1271BCD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:09:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 792E16B0005; Thu, 14 May 2026 10:09:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71BCC6B008C; Thu, 14 May 2026 10:09:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EB796B0093; Thu, 14 May 2026 10:09:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D39B6B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:09:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EAF24402BC
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:20 +0000 (UTC)
X-FDA: 84766207680.16.1EF0498
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 760891C0012
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uwxnnCwK;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778767759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=C/mUh9ADrL/N6C8xn8vBtMS6PWkaaregRiQgMq7T+0w=;
	b=YUMok5siOKTdX2PCn1nbAAanMn/tYjH9CWSSp4vEdAi37uv0PZGDqcTGL1mWiiqNsxl7ZU
	7gz+uBEpTiM9nTUzBradjmN86A9vX0kOO4ceyB/fsqUtJP2GYGBEjrLHELhY8ueTzZRWld
	xl+d68dFoPeubu2b5GILZM/Eogl+U0k=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uwxnnCwK;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778767759; a=rsa-sha256;
	cv=none;
	b=wc3GcHcy/XmiE0UgXr1hcuzyfPSWvpBz2ClEL1hyLVmdGUcc0lwu2nPCeYlqPCuaJY1A3T
	+8Gf5JUJKdkrI2b8d6YKtkHfvAPJpbITkKo0+VfAilDUKiohcazbC2jDfROBZBI66Z6vUe
	9ov7bpmtij2nGXEsjTukdHAp6y+MnNE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A0A6860132;
	Thu, 14 May 2026 14:09:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A7BC2BCB3;
	Thu, 14 May 2026 14:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778767758;
	bh=crS/vJ0l9jNtTLZIgHpYMSSvA7GQ12UlRLojwsyXt1c=;
	h=From:To:Cc:Subject:Date:From;
	b=uwxnnCwKtnnkKSHPkK/qVx5GWZzQjfDEc54rcYlcpQplJE7Xn/GVYWgFlHRH/4ZVG
	 mQ4CNyY7RPd615tbEbCfceeFsvFYyZyl5qCh8RhY43qHplhXaiocJyt+BFzKncO8hw
	 nmX1Ctqp6fZM7Q18umcdZ+f3cVUtU0vrV/u1pYJD7H/1mXyWIwyAzFMsKOvuMs4q06
	 f1n/bljpxJb4cnTtVYAP2ujZjoAnnpoLUbmPLPEZSUYC8X0z/kIZBgzITeWIGMk39W
	 yuQz24c3mxmGGMBQRY38NNw+gFiQVo04Wg2h0dOX961yyRqK5PWYvXad08Rwa5IWSj
	 AlVGjsImb186g==
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
Subject: [RFC PATCH v2.1 00/28] mm/damon: introduce data attributes monitoring
Date: Thu, 14 May 2026 07:08:33 -0700
Message-ID: <20260514140904.119781-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 760891C0012
X-Stat-Signature: 5ezigjff33poyxmerfwkyyzr97c3r9kk
X-HE-Tag: 1778767759-678786
X-HE-Meta: U2FsdGVkX19zpVjGB0yPokChU1/BXDaGSFvR7UjTWxVMONNOKpqJ6Tx0qnYlu3mlxoKS8u3ZXOoLCJOe7zRFQC3HjSj+JJk9A5++wjciwXLJE6xzxtnbI3cTal3OLaPzcpg2Vp/5LA9o7O4V+Z2XFIee1q2YknEqHL1+RM6bz647JIZHku3ewi12vu/gRMBeRpYlTc9dHMstIhDEz8Cu4CdGT+MY29yREBQSuRQ1evNnQ9L1vNk/JVdQ87aDix4pIUzoPPzipV94Uvi7d2Q/4zW6Ex12/O55J2t1QjCYZ9r1uOk+dL1q86N+y5Bbl8SpcczT0Nuu++w2euNN/8MpOebd6kvH5OVqDx3xUTEgLlEmmkDdRr0fmRMYX9mZ5AJcUmAJkMaN2RERBqR9mMeiqrnjvMzGaOrwXQdbjD/MaGjLuVP0qbwbymd8hznLndVwJAOjkrwNO/Grjuv8eIqFQ/M+XSZFVL8A8AO883JkLLlYr/8IsMWuBE/qF0HL2a9g2Wn30gwnAkD4PkOZot9UyQKibWYvjjm2DiGldQt8arS4CHG2VDCHxIUXQNeu2JQ4k3KZTI2ynliHelCs4Qwc7SA5R29ZnodYFxpw29qd5W+r2q9BV9J/RTYn2n5xmquaMOx0BCcQH084KnM3t7d0AKTFFRQVOkYIvb5uHPu628d9bUJLhMAlK9JLlQ3VJ9opELhbAR/TXGuISB9hTbN3FRpvX+/f0d5q0T8bTSvwcBcvW5LPDtk0Qar8EQbaedeGk0IJ05E8QHAv6LQEH0ZBKCnQDwxLJ1JXG1ClrBhxRRi42ufCENPxY9GrEeBMQjjWxgsLcFEAcNTwTgGGrnKp6ZGB9LxoGlWb/Po2C9YUiIUbRhsK2d20bafXdU4uXsRYjW27Neyd0+NtBAAB0Kn8uQ2WtIdD2ILfWq4DItLWeeeI+2s7WH6dwcuEAYv0f1n/oO7knPeyaDY0tsHdBhC
 CwxpcC/Q
 8QnkAHNN9J3+6Wdk46HBNNdbLMHhmwrIOOFsluV2uPm/LSmttwxFMZQc7ZbcR95fQjFm2AqG2aC2NSBI6/munffWknTcRBrTlA119tL5c00JX35lj9xeuWTzALW6xj/ZJSGXyEZ67uB4uLBB3vw6uZqMkT05cF7dveJULs/DUn76RvVeoDhebcXSWyKcsEVgB9sT4aTRvjjDfufrJ9GPZp+IyGqjfzSrIrdPT3VCIwjAybUWFdwSd1e+0XvASTKbHVd2t
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

 Documentation/admin-guide/mm/damon/usage.rst |  48 +-
 Documentation/mm/damon/design.rst            |  39 ++
 include/linux/damon.h                        |  67 +++
 include/trace/events/damon.h                 |  38 ++
 mm/damon/core.c                              | 197 +++++++
 mm/damon/paddr.c                             |  76 +++
 mm/damon/sysfs-common.c                      |  41 ++
 mm/damon/sysfs-common.h                      |   2 +
 mm/damon/sysfs-schemes.c                     | 222 ++++++--
 mm/damon/sysfs.c                             | 557 +++++++++++++++++++
 tools/testing/selftests/damon/sysfs.sh       |  48 ++
 11 files changed, 1284 insertions(+), 51 deletions(-)


base-commit: 678b6bc7ce120b8c51d4e05fcb8eb0a92f9be3f6
-- 
2.47.3

