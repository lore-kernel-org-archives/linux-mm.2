Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 379F8FF8862
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 20:52:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 588376B0005; Sun, 26 Apr 2026 16:52:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 508D86B0093; Sun, 26 Apr 2026 16:52:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 382546B008C; Sun, 26 Apr 2026 16:52:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1C2896B008A
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 16:52:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9831312066F
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:37 +0000 (UTC)
X-FDA: 84701905554.16.DF32904
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id EDECF140004
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="NmTB/zGa";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777236756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BTQqiZLsfnf9mosYDoXT/IcLxHhBX+sFp3Of6NpHWuE=;
	b=knpX9say+5uiaC/YG+61rIlkI0jXQA9+7SM1tqRWhnXYjQHhN3mJ13W3ci1mdqVJISnvVu
	djbiMwofSCd0H+d0MMC2MM//lwZmMa80p4bX6uXwmDjtJxJCD6yufia2AWyOerIEpudV85
	t8wCJtASMOljaJMjPUFa5ZkcaS2aUpU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777236756; a=rsa-sha256;
	cv=none;
	b=cOHmAcjFyekJXq3GrZDi8VWKyOTST7uSJm+FXue97jk3JNptHetgIDSWOgokgMYGTYU0Cy
	JDZaasHRfZraAnBC6cDlhAI1ZBnNyXAxSa3begI8OW9al5LOZ7rr3Idbhwtx30Z1+LCWuf
	xqb2BG3SmXpzKF2n8qOpayh00Cny2CQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="NmTB/zGa";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E2FDE419AC;
	Sun, 26 Apr 2026 20:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C24C2BCAF;
	Sun, 26 Apr 2026 20:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777236754;
	bh=WxWvBmm0LZfVg5AjkZ36lir3AfpAPctV6FKdU/pjfLQ=;
	h=From:To:Cc:Subject:Date:From;
	b=NmTB/zGaPmAdpd80S+HXHEDUf0uXzdPa5Dj6ei7/vnqLPdt79eZd/q2HgAgJgmZFC
	 l8iZ66IpFhH+3b0Ip3yp6L3o6KqGDioB7HBX+QTq/+C/1bMd1Evkj8KinUQtOFZ/lf
	 3Dc2EKxzRHXoxYrdZjSC+byGkLpMNCB6tuUML6Ok5qjNGevYOPpc89RRij9onvEoz+
	 Z1Xyc3i9v2XORNhfNfmCbA0b/c46fNbVX9VqCTlWKD+TqarI2uaMfSrDygxHaBNdHl
	 efOket+drnaSr197jO8hhaCZ53zyIqWFZ4IxrRyq+pQ5alwBpPFB6ZFwJBEBa4MyRo
	 KIfZYi0WhyqKQ==
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
Subject: [RFC PATCH 00/19] mm/damon: introduce data attributes monitoring
Date: Sun, 26 Apr 2026 13:52:01 -0700
Message-ID: <20260426205222.93895-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EDECF140004
X-Rspamd-Server: rspam04
X-Stat-Signature: jum3b6t3s3cuqbpmmy9d4jso89bgkhsd
X-HE-Tag: 1777236755-823076
X-HE-Meta: U2FsdGVkX19X9ogZj8X008eP5GF5Pyy5CUoJ2BNrYyfU3VR80NUmNkOPvAHEYXlFRTqZ+NoJpzl4uw5QuK7fmWFNIjXLmbMpZ2B3si5yb+vAM2hkstvwC4TuezuDGdcg+rYNY0xErAVkFcj7vdBrHmWsyA8J5aDptvfDR+NPBjt50ze3HOqS0iKHUSrgQd2Qf+OHcesyCn4zbmwIUmfuhD+fm1ZaY2DxKI2eSnWRYQEozFs8PVy/RxoA2PnpzgaLCEMNRTqiC5hOwwHlGmcxk5hnazCB8F9oFNvAcgoLA3XmbuFziqWO8pZ4mNH9pNOnJrjPgzUiFMxntJDQ5FrkpbfPpzLCrOUFK2t2sjUcpgzHLZgh29m++kd2z/s0GKlTgg0n3jM5QmLnGxidmL1GjMCnvXN8Su+b8dP6857ysediB2RgF6nzWIpzawxxl+PIigT+1xux0Tk6r8dgm7o4Cgo2RXdlFEUBpDP4KAi3EBvelhUe647bMiNNIqXu8GjVJVlToEzIzgFHl3FVsLlVZV6yxxBj+LsxH1bk98c63gQmPj2s/Y9P48mSd8RGyzO36C4bupgyN2nWevbN9FtUB/QFeFq2f95yEOR16k/7m3GQ3N32G5VtD9bhKZE9XJbzX6ArTGsUEcvz0sLZ2NPhESH72sKltnjCcrjpwHS9I7rGBxAggEX+qOmZOEt55jfVIJT9OPlrZOiTbk5pIyT+9EvlhUoWz5hakLrzidWiN81JdJvQ1n2ldFSO3On+nPzEh5pQ2l8WR1YMssPHN1sjsrgwa9eh0AcGp0m8KLDOwEu16shn3oH4YmCKA/FFqtDF+QVzLLXtC3J1wNpUQ9kjiGpIidBTw4Kxdtv6C53BVl+/ZfR5nRuNtBr8eGSl2I4u+6rTLPjt9PEz/kA4dS5Vyp6K39c8m7iChGAGobAbUGLqn1yY4QJgJQfK4Tw19VDi/5YqYh8dkIQHcur/tTP
 2Om/hfhr
 cXNa/p3k/p2GdWJtEFLvxN1L3x6+TJG44NvVO4QHDnEp/LRKbyRL8O8hiMSq/xT+HyX8d3FhI/VRHZ8bhsCSXl6o1yeT6C0Yc0U2/lHOapDV1nat2nUCA9RYpNbqjyIPAo9Dbg568FLLbxtV8RVIrzFKG2FdDSjE9Pjy4dizfo8DTRmxrJzkM+yu+FP2g9Evrrfeh+qMFintT5WRNvrW/rjg05zOHjFnvQUWRBaN7YW/+EXNd9BxfBhEZmQAoJfy8dFI8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR
======

Extend DAMON for monitoring general data attributes other than accesses.
This is for enabling light-weight page type (e.g., belonging cgroup)
aware monitoring in short term.  In long term, this will help extending
DAMON for multiple access events capture primitives (e.g., page faults
and PMU) and eventually pivotting DAMON to a "Data Attributes Monitoring
and Operations eNgine" in long term.

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
memory is belonging to cgroup A and 80 percent of the hot cgroup A
memory is backed by huge pages.

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

Eight changes for user interface (patches 9-16) come next.  Patches 9-13
implements sysfs directories and files for setting data probes, namely
probes directory, probe directory, filters directory, filter directory
and filter directory internal files, respectively.  Patch 14 connects
the user inputs that are made via the sysfs files to DAMON core.
Patch 15 implements sysfs files for showing the per-region per-probe
positive samples count, namely probe_hits.  Patch 16 introduces a new
tracepoint for showing the counts via tracefs.

Patch 14 adds a selftest for the sysfs files.

Patches 15 and 16 documents the design and usage of the new feature,
respectively.

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

The user ABI for reading probe_hits is not yet convincing.  It is
exposed to users by a tracepoint and new sysfs file.  For the
tracepoint, a new one namely damon:damon_aggregated_v2 is introduced.
The name is not convincing, and its internal mechanism seems to have
room to be improved before dropping RFC.  For the sysfs, a file under
the DAMOS-tried region directory namely 'probe_hits' is added.  Reading
it returns four probe_hits values with ',' as a separator.  With the
maximum number of data probes, this should work.  This can make future
changes of the limit difficult.  I will try to find a better way before
dropping the RFC tag.  Maybe 'probe_hits/' directory having files of
name '0' to 'N-1' for each of user-registered 'N' data probes.

I'm currently hoping to drop the RFC tag by 7.2-rc1.

Future Works: Short Term
========================

This series is introducing only a single type of data attribute:
anonymous page.  Once this is landed, I will extend it for
cgroup-belonging, so that we can do cgroup-level monitoring with low
overhead.  After that, I may further work on supporting all DAMOS filter
types.  And as demands are found, we could extend the types.

This version of implementation is limiting the maximum number of data
probes to four.  I will try to find a way to remove the limit in future,
if it is easy to do.  I personally think it should be enough for common
use cases, though, and therefore not giving high priority at the moment.

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

SeongJae Park (19):
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
  mm/damon/sysfs-schemes: implement tried_region/probe_hits file
  mm/damon: trace probe_hits
  selftests/damon/sysfs.sh: test probes dir
  Docs/mm/damon/design: document data attributes monitoring
  Docs/admin-guide/mm/damon/usage: document data attributes monitoring

 Documentation/admin-guide/mm/damon/usage.rst |  44 +-
 Documentation/mm/damon/design.rst            |  37 ++
 include/linux/damon.h                        |  60 +++
 include/trace/events/damon.h                 |  41 ++
 mm/damon/core.c                              | 182 +++++++
 mm/damon/paddr.c                             |  45 ++
 mm/damon/sysfs-schemes.c                     |  30 ++
 mm/damon/sysfs.c                             | 502 +++++++++++++++++++
 tools/testing/selftests/damon/sysfs.sh       |  48 ++
 9 files changed, 982 insertions(+), 7 deletions(-)


base-commit: 8f22aa2e28454419ed2031119ad32ea4a6c9f1f1
-- 
2.47.3

