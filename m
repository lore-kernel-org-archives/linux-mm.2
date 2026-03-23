Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B624F4613F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:15:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F6D46B0088; Mon, 23 Mar 2026 19:15:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CDD96B0089; Mon, 23 Mar 2026 19:15:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BC9B6B008A; Mon, 23 Mar 2026 19:15:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 53B236B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:15:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0C7B4140D8D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:15:45 +0000 (UTC)
X-FDA: 84578887050.15.C525954
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6EDD2A000E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:15:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n0FHWStb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774307743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5norX/ezTeFVyI28QuZ1r0gWZenN8Ob4TmnJ8VP39UY=;
	b=EgvwnPposcaXKMGAFZZdjgxJTBxwuWcLTP55pS92VxOjGU97scqRoekT++owinuvWiTCgY
	lGPWl2JIarpjQgn4dl/5K6zevYEVzGZByVr46TEH7wRk8x2aKZ//MzDdYPl4cjB3qkouOb
	hEYiKnRVQqh8bz8mbuBjpjVd1By4Lqw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774307743; a=rsa-sha256;
	cv=none;
	b=NRAYuwi9VAiZiyUF8cIRIweQaBV7u/CGh1i34VIeQrlphxGLY9KPFiVV6NFF4rboUqPtL0
	hrZ9ZCLHZ7HJEqRwyml7C9xNxe/mKSzhUHYxRktnyaan5LGtUZLmJZ424Ndbs+XUuFPCGi
	xFtl8eiP53eOj9U8HXuU3NpdqrPe0x0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n0FHWStb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DCE53600AC;
	Mon, 23 Mar 2026 23:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41AE7C4CEF7;
	Mon, 23 Mar 2026 23:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774307742;
	bh=Gs5alGZs5TwDVSh5NRSOYqfl0A+OaN/Sxbc6fkKvCb0=;
	h=From:To:Cc:Subject:Date:From;
	b=n0FHWStbtq/NPrSOJNkA6kb3l8IPMhZ3/Y14XNDrg3Btqt7obF079X/81Vum+1dja
	 7VFnLLitb1VzESDrhepZN+f3oh+5a48+tQBVwDh2sfCJnTB7vYw9crbd/UE4TWkS1H
	 5JDMI4wwxp5NmanfJ5Gfmc3rC1TnKqQ+maHk24MTwI+Gvb2hFxuFeEM8w5Pvx1Wk6v
	 0QeE3RaRjiDSsJ7Qklq7KGwGQQHavjjpP8RsGkkX3MweHpjcNSsATF9gQ8hxNZbF2P
	 5Pl/TE/P4xBijwdtbXSZfE/Em025hpP30HJgRvZjzhiia7Znyb0zwgomJ4eQHJ/NnU
	 CnPB0Z3OXvjMQ==
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
Subject: [RFC PATCH v5 00/10] mm/damon: let DAMON be paused and resumed
Date: Mon, 23 Mar 2026 16:15:25 -0700
Message-ID: <20260323231538.84452-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6EDD2A000E
X-Stat-Signature: sswje87qrhazeiwm4hgr4e179wdh944j
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774307743-97473
X-HE-Meta: U2FsdGVkX1/s8I3OJxZLawPks1D/sETFxDS4VJYt5aPm6J6I/oixuqtgzp+IlNemQ+C7mDK1YlsQv14t8MFDx0luHq155yAtU6QQ7lVD5h6z40GEVZt5ZEjf8SZe+7tpV/m21oV+471VNRy6Wl1CaZeU/F8Mc4m8CPFcpIYYJJ7g1x+RUzk/80M75aW3qGZmt7P3rcAiNkfyQVbeDB5lUvh9CFBLK7XxL7sGyd4yLcnArRdMZnOzML1xeO2jlcWfZH3ynJb+yAABZn8RKnOnG4L0bjxrIjfGYzyYtCyG0q9enpSStVyJmYXSj3/NMO38HxN3QAQHa9xemFFdtBOtepYVF6ieD2/6WJge3LNygGrDUT5Uy8IxdJzPupwDNQgrDhObq69Xh14DqBysCchQDKYNbFg9q6zUNffQdwrGmmyGk3XAwGdf/lKhg+JmtpOEkkoWv/Vt3cQTt/gTXRRkMJSbnGzhvlwfrU+DAG4ceH+QOzPUBiEaDIRO0Hx383LxzYoVLc+913jLeh9IFK5HrzDnH/otQ4AHeY4o8E9XbPStC68mMEYpUsytfLKBuPuNwxkVW+nJrNy6ajLw8H23vWpUaBX8ZhVX0pPffTnWJuaXZC0pQ+0FNeT/Nmh0wim9RYk4RDAQyFXrWUUYdjE8hIqpDo0L4s2L/G5S5ba9n9pmpgKDhhBJb/ESXYeVB1oZXZpXl8OjFR8YMIU5fO/tTe1hiO/xnodEHh0ySHDwjYZOyKTiWp67tIh6CP5cTQ9ZdJopPYaswrkPC176QbvtGGP7nh1KoyI8b0TgNnseTemNsdVGLNkF3h5JLA+B+TFmV1n5H1MGiBfmqlR3DSPeT0mYhtev8ruTxQ/6EYoQGtTEm6DS5qTDfUtq7I0HPmSBFdmZZ2Q2oxgfy1V2jmqItUh8zDsPDiy8i6xyVaJ80W+48AhFqCOjZwmHtFuuz7fUWjvPyo9FgoQswotn/IW
 8fWcLci1
 0tzGjpvUy5iSHSkjzmeJgb9H71L99bcNZjgoNicwSW/S4bpSZ0YX930YBy2d4GPZbZX4wODJ3vAYM4pJqY0di5+R+7IrHhsuSr9l0ZdPUFAoQNS3Ai2+VfcAn2au9lo7zqDDOxp8E3FOtRJhZXq52TBPVSIcSkUW2TB/UNGfVmaqvLP6AFZY5NTIYqMqVef2Axe80sqvl0Y+dzCLeSLyIRefh9gnsJ2bqSIZFHc+s/yIqIWZihF/CxYy3EZQ0Hh6ba4nWjtNwL2oZxS26Vj4Casup/Owm96Am7zt1
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

Changes from RFC v4
(https://lore.kerneel.org/20260322155728.81434-1-sj@kernel.org)
- Fix typo: selftets.
- Fix wrong selftests kdamonds resume iteration.
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
  selftests/damon/sysfs.py: pause DAMON before dumping status

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


base-commit: 4219363684c17e8704b4fd4ceac8940924a94b3d
-- 
2.47.3

