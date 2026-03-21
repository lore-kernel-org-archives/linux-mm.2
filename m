Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05CC11094478
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 18:13:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44DBB6B010C; Sat, 21 Mar 2026 14:13:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F7096B010E; Sat, 21 Mar 2026 14:13:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E6C66B0110; Sat, 21 Mar 2026 14:13:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1B9276B010E
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:13:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D4ED08BFF6
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:13:55 +0000 (UTC)
X-FDA: 84570868830.01.5E81389
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1B0AFA0006
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:13:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TCcQsQ3Q;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774116834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OMhVNLbTyIFjfzpHO+e1KWy2tNXjmnf5CTdMEykqlD0=;
	b=uUyu4FpPMEWYgQtQDm7d2PaJOykdkhfK+G9oSLxPdKGFBISg2MH2O4lIvUFb9wjec4PsuT
	dzRRdpaunBfD1M5+COfc5+YchlGdaOXljDUQAeZpcmYgOQdepthhmRfLXXEDkWZB1oVt+S
	gm01evI46OWCRGVuq7zj6aW4tBUrhnY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774116834; a=rsa-sha256;
	cv=none;
	b=Ibwoc2mqwuqdhVj/S3eqOsmdmeLnlweGSLpfS+c2zXWA7087FvFPYk52uJZL9sjS0OR/9b
	79SgYpzKkwKVTYyn4n+jvo99ZIhq3pAz7yeu01a04IWsgR58NVVJZnq4Z5CQTPco9tKYtW
	qaxFSlLIa7IG+ah2GDyXB/cU6cCbRnM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TCcQsQ3Q;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A17040E1A;
	Sat, 21 Mar 2026 18:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9899CC19421;
	Sat, 21 Mar 2026 18:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774116833;
	bh=gpeakB74+j4Crr+URqLOqlQGJ5CoOZSUHpFIvyVoo5k=;
	h=From:To:Cc:Subject:Date:From;
	b=TCcQsQ3QUMVcLJ9hsN3wbMqnDeQjjcDA/kssGNPkKGrsDaElXfzton47LVduAQBqW
	 hWj9a33Scp3iXtfTz4roCwTrpw2UkfQ+JPRGl7rbhgxmZU9X83MZ8+MhvKZGUF3E2b
	 n1svEBEUpYHHa59NJ7mITMExn5JlX/v6+cS/vY0HvqFPqZdCt+E/axAyf8JVUSjL+R
	 af3d7NHRvHAm/8LPBzmLOBvsRlZbc/fhRjvyttoT8qFdtk22LmGErmzMfcD2UII9Hx
	 ET5noIUGDbHaMnVonnrl5JQxVUpsa+NssDMkl3OAK4R+e9CoGgZ480Ypysq39SCnYE
	 Sp5q8FJ//jWZQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: [PATCH 00/10] mm/damon: let DAMON be paused and resumed
Date: Sat, 21 Mar 2026 11:13:30 -0700
Message-ID: <20260321181343.93971-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1B0AFA0006
X-Stat-Signature: fh5bd3c4nnr7qtirp7kj443dghy66ety
X-Rspam-User: 
X-HE-Tag: 1774116833-477452
X-HE-Meta: U2FsdGVkX1/CQ1MqkLOc6FRpB5n9TpCt14buLFH+5EVXod0kFlqWEdYFIrvWqlbsYPbJ5h/t0qSu5xIp+719LWKbeRLC60tgS2OTE1vowHXFFuvmgRHW3o3btEoqDj9Bk41yNBE0bIWhHHbzp4T8C0anRNUxpWgnH/WT9xMhiLCADWTN0i2Al96edPwU+pceSOmp6bmk0cSY6/q2dTIL0hlcWFHzfd+1zK4ZwPNe3GckMwWDvOWl22hGSpkJUVtSExX0NhGzCdlqhnxbZKtct6QemsTPtkMalxR2jsXXoei64BKhP3FLCUBwFlaavo17k7FZ5gOkgzde7OKTW5jZ/s3h6n2p4ZSKyzSRSx15ZJdSY7OMa8fsjwd64oWpf0/ZegEqfycDm6Ag55nX2/2onrFatMpB6LpK/F+vnF+U8sfZHHxvjmXJ2Ox7mGCf1nPljRWznJGUPqhrmiqm8JMLDYTtUEaYnteT3+sAmWZNFvzrZFfugpKvUhcZWogMu38K8NhA9PPIZK7V+Tx0blp0QKWHQNhG2WiznviNHte768JhFM4aHn6D9UK1ed/H0L9zzdE0dyoVZqu7Cui60s1amVyZX503BVnk/om9Pzd/bvUeO0F1D91ezglhk73KJHGkSXUarZQ5zTpV8kCQguLe1soTt97dSlJ35SD/yvmfLhpLAz3lYI06zRdCzsrVTmkS8u4ZdZzits6ljL//o60irO4lGwe/qEcMtSIXWPGEdCEXuZQBJs18r4cKNnwGoMW6w0SimOGYypNFfmjO4CBoMX/bd5279FC3Bkgja7MR2VtyxBlIMwnsk18awpc0cpkWA0QmyFDHoEam5OvvG3OwflcgBUfIdnko0l1onwpViiuc3aGFXRAqq9B5xmUZx9KItaiRd1Q76pjfc/ysIif3SmKwLD/rz1nhMFVhG5NAc5l5hLQFbwlxwrKBH7KavCdaQS4qptRv16+T6eGnVvG
 I0WeifC9
 0QcwKUbKikk0yPMJ63/EL/aQ0UTWzKr+L3suk7VenJSMty0cyA4fhkr283NjL2fYm6cwsB7wIPj9TzahjfV6GKsQXWx+hGy1GUFjWt27LPFnY6U73uavm89OiXbUJ9NFHuWRR6T7223xh5MfuVBSrb4iJpJtXzfOWLC1paiKPAjNwCA7yfw/om0G60A5tNQrstoYhm3uEZ+fVXQDlV7UvG6ZcCXtmLuQKfzFyuiJanUpibcI=
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
 mm/damon/sysfs.c                              | 31 ++++++++++++++++
 mm/damon/tests/core-kunit.h                   |  4 ++
 tools/testing/selftests/damon/_damon_sysfs.py | 10 ++++-
 .../selftests/damon/drgn_dump_damon_status.py |  1 +
 tools/testing/selftests/damon/sysfs.py        | 37 +++++++++++++++++++
 10 files changed, 115 insertions(+), 5 deletions(-)


base-commit: 7580a23dc3d9af23b4911f9cc1d9da2f519d63a5
-- 
2.47.3

