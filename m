Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1624DFC72A9
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 15:57:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13E3F6B0088; Sun, 22 Mar 2026 11:57:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C75E6B008A; Sun, 22 Mar 2026 11:57:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED16F6B008C; Sun, 22 Mar 2026 11:57:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D74D66B0088
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 11:57:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 67C3B1B8AB1
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:57:40 +0000 (UTC)
X-FDA: 84574154280.18.5306D71
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id E6DE0140002
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:57:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lbjLpwIo;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774195058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=f/uZL3fv9gbTWXqb7PF0/1nWd04tZdPW/KBZkgxqcGY=;
	b=tWMtWKU4tSOIFUBgb2+34NvO2r7FWhgA47lEEaj7eNHUwV++7ewejV3i3kENiJTEztUZvV
	hkD7F1Ku9EM+VIqCEzZ/aiQKMlutAQ5VxLQi0JSZWqRofVrUwcx1Uh2e+oxYdgjFEfeg7S
	OC1SCxnVRvQaQSfztOQVe1it03A1iWE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774195058; a=rsa-sha256;
	cv=none;
	b=qDjd/EzmsFbc057BzB20nfQ596HnSv1vXbviyrkdAERRN18Xq8xrKS8JCfkerTSUl4/WNT
	U+OdKQSkAW0n2IWOvcrgELM6hp9sQN3XTbKdtj6wWRG6hqDEvMVj/Wtx7ewhTEAy5Nq98d
	LUigXnLbuYHQ3y1N3nzdsLs5nkHt8gE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lbjLpwIo;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3BA23600CB;
	Sun, 22 Mar 2026 15:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861CEC19424;
	Sun, 22 Mar 2026 15:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774195057;
	bh=kNBlfQ9BMryWCDLSof5c0AnaZNkUW/9xniKl1T8LsGY=;
	h=From:To:Cc:Subject:Date:From;
	b=lbjLpwIoQvNwpilqkomdgyk+iTQWRCG1hJrZAr5MAZtAB86a8kefddN1aapFc8azw
	 tlGXxROU6LlJJazUYpY7RhLPk59I9Tw7i+tUa+NETKm4A2155WjBfFRNyn336B9Sfb
	 NxpAA2w7uS0lzqtwcbdWUJp8dcp3ezMIRACThiKoBf3pRRFXKGjlx3YInuxzr4vOTS
	 OsZWgMf4rTqWQob27+ItDqHqwqU/JkTrq6srQzHLJ7qDsGYDHhQ9ioF85HV309V4oO
	 Hvetg46+6brMnA9DCy9LZTYeasFRKtzWNjkxZDqEp560FVEeEwBrDSHHqQLh/mdcU7
	 Wnvy3edQBTNog==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
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
	kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 00/10] mm/damon: let DAMON be paused and resumed
Date: Sun, 22 Mar 2026 08:57:14 -0700
Message-ID: <20260322155728.81434-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E6DE0140002
X-Stat-Signature: zf7umr55jpwwdmyg1gfdg7pk1q7o9k7f
X-HE-Tag: 1774195058-974115
X-HE-Meta: U2FsdGVkX1+RmFWhYMHBhxobiLJa3hUUHLZUStLPUdxEHW/1UM78KCPFljw4m1sq6JJn1Zo0hcIwY0S9VsgKK8l3ibZy9GQwJtfr39Tg1jcb7PJ4s8Tm59HS3wIp0Fn2tFa7l8mzPnVxu3/w2EZ7wcNNisM1Vr23OGVtrfgxmBSJXNCz/RDfRY0rc6vfe9FJZxd9bVX3dgR5bTS3b4xQEkTpwWPkSMj943yLLP01QDFIFSXpd9Cd16BZ2k81TmyAXEDFNs5A/8rB65ybjXZsVlNtkyt+nTEcvcyUmFTFzZyLCwcUYikWLqUdy1wfZw/Lyygfvubp9DJtpMKhwP4GAqJasD0FUVxhvRYK1c09mTdMFIk+JQVxSaPFFCnZYxo8ZKtibl69zgXkVL5DCExRBHKl22s7cVS/UUqQ8qHztmEbGv/bkMZwBkim5rG80EuHM84qCcLB4e+Qd/4l3g1TM5NKrK3lcKpff/MCyva4d8iEsqczBuJalD5LBZ8KpNcf4+nUcKU+RDj21aAtYtbq13sG1LXRpLcBn5RVpPfmTkvWaDV4A46OHY7kSy/5bKTz5/Z1qtsz8LALGxnpO+Wqsmt4vrIAml+LR8zAREjjv1vLz2hE5d1F1U58L+emlWTKytDkE0Cob9PPbXQUFanzD5PxIGFUF5I6fvfio0dFEtnDZu+ySZRX9cFDvstNb+N90O91ElYk0TfYHkSWXuHdC1UfqLRb+/umh3HIbx3Uc7oBn/hFm5UmL/qwizWp7+8S8OoDZuy4lbzUDVVIETdpib9h5xfvfu7h+dNedCwWvcJc/VxqtpcBd5Zb3JwvFzMwMF2X0lp4iDFGN0OHk/SX264Ua37NbQqQI0EiTZbQBQo4N4xp37lbptn0WWEQHL+owJ2oFkkSc0AlyeIEv6zJveEevVyxHSAQyRW6lPfVZ5gbsTu3y5Yrh41O1JWvagziC8WeVAI/PJy/mPaQqaL
 Mo4Uvsvh
 sJOS+slWldfdik6t1defMTSfA2QAO+VV6hke8R8bhS4g4uF4nlQfrFNOoUwfdNgB18wttGykxqlRuS4QkJePArn0gWhUfds5I6QMfQWOXsOy8spnHkpMrVA0kvGvHc4gGS2/S51oxAcwYCGWGHJJeVsBhrq+Z01ZDXMPExqJmUluDURuzUGbLw1/bXZjtYdqavtI73/0+4QzeKqPMajaoNiVrv6MRJZjvwbDcQ1IeR+Nm42s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON utilizes a few mechanisms that enhance itself over time. Adaptive
regions adjustment, goal-based DAMOS quota auto-tuning and monitoring
intervals auto-tuning like self-training mechanisms are such examples.
It also adds access frequency stability information (age) to the
monitoring results, which makes it enhanced over time.

Sometimes users have to stop DAMON.  In this case, DAMON internal state
that enhanced over the time of the last execution simply goes away.
Restarted DAMON have to train itself and enhance its output from the
scratch.  This makes DAMON less useful in such cases.  Introducing three
such use cases below.

Investigation of DAMON.  It is best to do the investigation online,
especially when it is a production environment.  DAMON therefore
provides features for such online investigations, including DAMOS stats,
monitoring result snapshot exposure, and multiple tracepoints.  When
those are insufficient, and there are additional clues that could be
interfered by DAMON, users have to temporarily stop DAMON to collect the
additional clues.  It is not very useful since many of DAMON internal
clues are gone when DAMON is stopped.  The loss of the monitoring
results that improved over time is also problematic, especially in
production environments.

Monitoring of workloads that have different user-known phases.  For
example, in Android, applications are known to have very different
access patterns and behaviors when they are running on the foreground
and the background.  It can therefore be useful to separate monitoring
of apps based on whether they are running on the foreground and on the
background.  Having two DAMON threads per application that paused and
resumed for the apps foreground/background switches can be useful for
the purpose.  But such pause/resume of the execution is not supported.

Tests of DAMON.  A few DAMON selftests are using drgn to dump the
internal DAMON status.  The tests show if the dumped status is the same
as what the test code expected.  Because DAMON keeps running and
modifying its internal status, there are chances of data races that can
cause false test results.  Stopping DAMON can avoid the race.  But,
since the internal state of DAMON is dropped, the test coverage will be
limited.

Let DAMON execution be paused and resumed without loss of the internal
state, to overhaul the limitations.  For this, introduce a new DAMON
context parameter, namely 'pause'.  API callers can update it while the
context is running, using the online parameters update functions
(damon_commit_ctx() and damon_call()).  Once it is set, kdamond_fn()
main loop will do only limited works excluding the monitoring and DAMOS
works, while sleeping sampling intervals per the work.  The limited
works include handling of the online parameters update.  Hence users can
unset the 'pause' parameter again.  Once it is unset, kdamond_fn() main
loop will do all the work again (resumed).  Under the paused state, it
also does stop condition checks and handling of it, so that paused DAMON
can also be stopped if needed.  Expose the feature to the user space via
DAMON sysfs interface.  Also, update existing drgn-based tests to test
and use the feature.

Tests
=====

I confirmed the feature functionality using real time tracing ('perf
trace' or 'trace-cmd stream') of damon:damon_aggregated DAMON
tracepoint.  By pausing and resuming the DAMON execution, I was able to
see the trace stops and continued as expected.  Note that the pause
feature support is added to DAMON user-space tool (damo) after v3.1.9.
Users can use '--pause_ctx' command line option of damo for that, and I
actually used it for my test.  The extended drgn-based selftests are
also testing a part of the functionality.

Patches Sequence
================

Patch 1 introduces the new core API for the pause feature.  Patch 2
extend DAMON sysfs interface for the new parameter.  Patches 3-5 update
design, usage and ABI documents for the new sysfs file, respectively.
The following five patches are for tests.  Patch 6 implements a new
kunit test for the pause parameter online commitment.  Patches 7 and 8
extend DAMON selftest helpers to support the new feature.  Patch 9
extends selftest to test the commitment of the feature.  Finally, patch
10 updates existing selftest to be safe from the race condition using
the pause/resume feature.

Changelog
=========

Changes from v1 (or, RFC v3)
(https://lore.kernel.org/20260321181343.93971-1-sj@kernel.org)
- Add RFC tag again.
- Handle maybe_corrupted inside pause-loop.
- Reduce unnecessary commits in sysfs.py selftest.
Changes from RFC v2
(https://lore.kernel.org/20260319052157.99433-1-sj@kernel.org)
- Move damon_ctx->pause to public fields section.
- Wordsmith design doc change.
- Fix unintended resume of contexts in multiple contexts use case.
- Rebase to latest mm-new.
Changes from RFC v1
(https://lore.kernel.org/20260315210012.94846-1-sj@kernel.org)
- Continuously cancel new damos_walk() requests when paused.
- Initialize damon_sysfs_context->pause.
- Make sysfs.py dump-purpose pausing to work for all contexts.

SeongJae Park (10):
  mm/damon/core: introduce damon_ctx->paused
  mm/damon/sysfs: add pause file under context dir
  Docs/mm/damon/design: update for context pause/resume feature
  Docs/admin-guide/mm/damon/usage: update for pause file
  Docs/ABI/damon: update for pause sysfs file
  mm/damon/tests/core-kunit: test pause commitment
  selftests/damon/_damon_sysfs: support pause file staging
  selftests/damon/drgn_dump_damon_status: dump pause
  selftests/damon/sysfs.py: check pause on assert_ctx_committed()
  selftets/damon/sysfs.py: pause DAMON before dumping status

 .../ABI/testing/sysfs-kernel-mm-damon         |  7 ++++
 Documentation/admin-guide/mm/damon/usage.rst  | 12 ++++--
 Documentation/mm/damon/design.rst             |  7 ++++
 include/linux/damon.h                         |  2 +
 mm/damon/core.c                               |  9 +++++
 mm/damon/sysfs.c                              | 31 +++++++++++++++
 mm/damon/tests/core-kunit.h                   |  4 ++
 tools/testing/selftests/damon/_damon_sysfs.py | 10 ++++-
 .../selftests/damon/drgn_dump_damon_status.py |  1 +
 tools/testing/selftests/damon/sysfs.py        | 39 +++++++++++++++++++
 10 files changed, 117 insertions(+), 5 deletions(-)


base-commit: 73b971e012fbe1b2e8cd4992602898d5c9633ca4
-- 
2.47.3

