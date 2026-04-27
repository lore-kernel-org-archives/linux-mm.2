Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9DE0FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:30:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BA886B0088; Mon, 27 Apr 2026 11:30:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2926B6B008A; Mon, 27 Apr 2026 11:30:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CF406B008C; Mon, 27 Apr 2026 11:30:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0AA3D6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:30:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 18F4916041B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:12:43 +0000 (UTC)
X-FDA: 84704677806.10.935A63E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 571424001B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:12:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TJH0uQrr;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777302761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YsgDC/iwN/qD3Kdp5vYSL1/lwsA0zcSIqFWisvUaVFs=;
	b=yKOcjjCrSox8xeVloUx6LevVw67dSlAmIfulkBVlG8m1zV7zE9p2wxUWZuVob5Bt0HdDlQ
	J9yopAg5OAXB7zbfAShARf0jo/mz9u/IlBp2YlmfxCqnA5GqiCXbAUaBm5NTIOHWGennMe
	C4gAXzd4yrRLPlMSQTONc831VS/WJww=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TJH0uQrr;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777302761; a=rsa-sha256;
	cv=none;
	b=Xa/Cl7s6Hu72py14qjS3+HRQh4dRz1ha6ifEaJ+IPxf9HHcdZtHhGYphom9E/0+5LD1yOT
	7CzAnOiti7Qq5yl/nWZ7UjnF38zaVHMtEhqc0Px8YsmMbGm6DYAhlimEXEC7ZiqzCmH3d2
	jK9Pn1B4o355MuJgxeQQ9ybeyXB0i44=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 090D94197A;
	Mon, 27 Apr 2026 15:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26352C2BCB4;
	Mon, 27 Apr 2026 15:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777302759;
	bh=zI5vHsvRGeABhz8+PYlJ/EahgR6YXI9rVwoXD7+ThEw=;
	h=From:To:Cc:Subject:Date:From;
	b=TJH0uQrr4r3lQ4SuRm8wQheI46NGHnjW0QSkdAQJJsu2EKy+VSXazj2JF1TM4hI+/
	 y2J5lRBaWoR34EDo5PTi/ir2Xwo0j1Ajr/SEEE/bOpV6XpNQ803wlXUP1NP9sl02mr
	 Bw1MWIzuC9PCYv23QUAJnAyAFqF70+0jE9QvtK9kskHcnV55eFAhsKFhu/FQFHi7X5
	 k5OFiJomVq6+m/bmS6qpa9l9qkkSKHuUVWpEWQnxWCtU/b822T8eq9k5tctOtnVvJG
	 9m8LLjyNgoAchDQzm1+gt+Vc5bQPrD7JuEyjSD/Rg0+c6wth3tgA3OZPEKZW191Wfb
	 hq3vYfKKtkRjw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
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
Subject: [PATCH v2 00/10] mm/damon: let DAMON be paused and resumed
Date: Mon, 27 Apr 2026 08:12:19 -0700
Message-ID: <20260427151231.113429-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 571424001B
X-Rspamd-Server: rspam06
X-Stat-Signature: geo4px74cg1a4dhtsf99mg47pr5fyuqs
X-HE-Tag: 1777302761-946518
X-HE-Meta: U2FsdGVkX19gc/Ng/Tn5po5tBy26h4zpFgSyiI1ZcqZ20JzoIoF+q62KBACYQ4SPVBwBc/6AZaABKqAsBUJ8VVl7jmwpabSIiEl0kpMdlUBimI8uNnxohaI7OJsxiZym1i+NmbdpLg1a15PMJCUrS1k37bhitR/H+Tsy3Mnum+BxAkyQDdiW0x3qMEno5XGcv3F8pJS9yjJXaxr3Ms96ciyszvdrZO53kn1Q98tU/Pb5zBdwWB5Fq6PfpH1WzUVvDFRwu2bNMrlNH0eBVn305V1ExkQ6O1Q+WxbwkfQBp5yYbZrp3AGEji7AFhgrzo8eb0lGks5EA2txGlH9zkOmgQNGgRg+K9jANTMFoOfZ5inlGAY9uRc1KZM0+VxKnchwSFh2j4vPVZ/O0aJLWSQ0Y7j3QCniof3DGTCG/VQVj4gX4dr5+pbLJxM6uBNPwJ43j11psjIOY3zBvufMhS6ijDBlpYdIZ8kL+fkUyaHYONot2aXn7yBG3IuMq5eHZ+Cnns8dTboRboNuW3dhv71P8qS3YzUQiQxGwxEysofDE8KFkx3yLY393Wi8RD6klRe98rTBlN9X1pBhFjC8TJEea6h2kCS09RssgWoERFEZJF8JZMrnWhdHRGtiZsFWayjE20g8/oBtndP3pnaR/DscG4eIQQyzhdXvLWDu/MaMyoJ1p8cmvvGoZtQn5hmINeU2rmP/Jja52eMdGLReFfY16frgwc4gkA5atIqsM5+Bl7fHOOrRNceLlrr/wJvcsdVxLF4/MzLx+6jFwkwnzN/jaYzyTD+SXppblJQGM8L489RU9cC0aJjKiPWXXBgyw1Q0x4+5HRBfoIEh1xe4g+w74LMe3BqNdsm0l24ILW81e627WgW0dfhxwlzfjOiqFUEQfTWSUwbmPrzTYaYkDJ6gqpfd9kjPl9ql5aeb1xM/K0jz6k4lSxpuWTbPUitj40kPi4jbHg1IHNBaSmyF/Zq
 lWK+hjm+
 RPBl8SQUnYJHwACpETmX/hy/lCjyf8NfJFlNnRfy834RXVrMBAT6JnkeNDjS55VjbP9c8mT5CHp0j0cOLVIDIdk/O2pwE6lnxn+0PYCtdq/fdQ6AyPUqtKLhjmphD3QDQOko5AjEyLrmatawlemQSgOgt+rDZV46AYlMdBWkm3pmk79dqXlV6Efi6BF0evIWv8sSEN8ZNZ0NO21r1y0lotVxt6g8H1wmn5iJJbsXWI9LivsA=
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

Changes from RFC v5
(https://lore.kernel.org/20260323231538.84452-1-sj@kernel.org)
- Rebase to latest mm-new.
- Drop RFC tag again.
Changes from RFC v4
(https://lore.kernel.org/20260322155728.81434-1-sj@kernel.org)
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


base-commit: c12c06c4198f28d4d2bb48cc9608dbbfb020bf43
-- 
2.47.3

