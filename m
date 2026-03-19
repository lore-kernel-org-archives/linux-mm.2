Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09B8D1088E76
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 05:22:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 245556B03E5; Thu, 19 Mar 2026 01:22:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 185FE6B03E3; Thu, 19 Mar 2026 01:22:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB9B66B03E4; Thu, 19 Mar 2026 01:22:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A56486B03E0
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:22:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2755B8AE39
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:22:10 +0000 (UTC)
X-FDA: 84561666420.13.E532412
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 813EE4000A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:22:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gwo2MNMQ;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773897728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=HtE9fROLc4qhqqgnu4llIPaacd43FaOfhxE4OWfXAqI=;
	b=JEJKMIbWVfd/akLiPoeK+f6ydp6JMtChHjDn15FxI0DRAf8eg6ds98mwdyOMVln7C1Ky8H
	teY+GUt3jyDWbN4J0BN3Y/ntzNgvuvj8i3zx4aQE20Sndz4SNUhJq+OfjiiHRKqDDXmFqq
	ZdZlQJoOZ2Tojax7SxVGdvGlNAdo4oU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gwo2MNMQ;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773897728; a=rsa-sha256;
	cv=none;
	b=OJMSFEN5juPMtSKJBEa2tfEi10mcO9CNWk346R1FIUkKtHDMROuec+4oe8qqj43h065cUf
	QVsAZc9XAS+wP3JDmgnXf9RZJaNAN8vnD8KH+qTuEy1RFUhyKvY3UeumIUHQaOHeCByp82
	0aeMA2jj9D9ry8Y9ERWnx4NHL99zkoc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4006E40727;
	Thu, 19 Mar 2026 05:22:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73F5C19425;
	Thu, 19 Mar 2026 05:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773897727;
	bh=o/Ftk1V+walX/j4lo8sRORN5eVEOzqwrT6r4WeWLY1I=;
	h=From:To:Cc:Subject:Date:From;
	b=Gwo2MNMQy0NRf6Y8NkdQ2lcm+gbTmK0nYJ0t8ghYQcdpJboAtu7xhDX6XjLOWIhtq
	 sfPJ64VoJDBlxrSHYdco5I7A+dTs0rgaSVJ+6XvEXZP2IO7rs0HEqgLNqcUDwm/F8r
	 2lR+lByE3vGGLgVy8hZFaPYpeeMCOsb2RwDJNElCOqMR4USYVRBaWjdkKDoe6p5BGN
	 GmDXh26cV++CtbxnEt/UcT/veisfqDLO5BbaQB34Ch03vaHgw7k0KhxRtvyID6YpfH
	 5c0rzPAJO1go2PcUzYbTz9H/grcCAKYtDelVquVq9QXTtCuHxBkWok6ytc+fCuen0T
	 aReCqZT4jDCYg==
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
Subject: [RFC PATCH v2 00/10] mm/damon: let DAMON be paused and resumed
Date: Wed, 18 Mar 2026 22:21:43 -0700
Message-ID: <20260319052157.99433-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 813EE4000A
X-Stat-Signature: bg5w1joe8jk6saiz7fewitmskaj3g5ey
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773897728-695398
X-HE-Meta: U2FsdGVkX19LITvPNxx+4/ET6Km3dqx0vBZ+n0yM4VXyKCB4yqvz3iP/dNWk1csKA98/Y0CKe9Q2dhP0NwtdUWatrCA1d6iIxzSv9htspxL6iib6EL44NmOErTxk5YE1uvFYZcT/aDEKQS4cVFxrcrr7VfJ9l1PhePro9bKC1+Xc3+fJgF/PK47GKYlnaQogKuYO1q7C9TojIVUnvx6AbJoTTBQPtQqL9jrWwzg8NwTS/LSJANfGa+t/bgB0qDyWP+oRWZGVYkbjIIyTIaktjTkct9fBBuVWpgo10IYNk1vADfIibuGkCtjyTdBiLHr048gAiT3HbtYXyTakM0aOhDN77I+8TEtVvm/9Tjj1r/CajF1reEkvJVVgpgr4asdk8nyvgGyohULp8tTMNy7YW8yysmM751wlU01gyDChykTf+e4To+c8ZTW99jK5tP9ElIlxmglVzJMYO0sz0Ezj5mC+e+1P43Fs7je0Yv3ZPvPbGmY7dsdVwvvFX/pnImGDxYE6kAgXeoN8CtFADzeQD84lkOuO4JGD0ALEsRUdmBzBhjP8BBMPGdrCw7ZyC8dyxnDohPMCQo4bHtXD2sq8KB/XSa/M3CHzh3xeji6h87/uEDJ5SZf3kv2rB36kPe/UCuYydgsrpMuS5dRwi5jkZ30QXCb9AassKZjzQaQg+EljleVdcLTVf+kWRbN2PDE0LCr8e5KH1kEVJVy/reN8xCGuZ9ADgQlfKTxUGQl5ljZtnaQT74WdEUMzd6MUPWh7/rmwbYTsIJuajTE1QXmkyYwVoR4IsOjLvlmtvv4g/eO3qHsvAJwEnrfKgyv7ucPZsSZDLINlODXxnHHa6ccM/00mVTk1/mcnyXplahwGVzlKGqsaFO+EUCEX7vO/cuyZnZrHBlPtJg5QY9gY/DIAocRq1m12yZIme1p+C6l9K8UWvAOKqY69jbxMAPenV2qQves3hdCFmE5rRhH6kUu
 2jhAmQ9p
 /1tKYPgTTXRJup9GfEYR1TxLEJ7poEHbPvKcldV17W25YoUm0rsWK1z1tb1FUmKb5SgpQgdOqLivktGbnxVZJWl5TBh14qH/8xhX/K7l6tmz8zjVWtfCRdLEu3iAu2QD6KsT6wzdNqWD/WSiGu+9ZHMvR+7r6PkFUCdDFqfYnKtvrqLk2tnpYr0xwI3H056mqKJ4jCXhr6uPJNWQSsE7chB74VAj9NytW12gwjGop+rH2CAs=
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
 Documentation/admin-guide/mm/damon/usage.rst  | 12 ++++---
 Documentation/mm/damon/design.rst             |  7 ++++
 include/linux/damon.h                         |  2 ++
 mm/damon/core.c                               |  9 ++++++
 mm/damon/sysfs.c                              | 31 ++++++++++++++++++
 mm/damon/tests/core-kunit.h                   |  4 +++
 tools/testing/selftests/damon/_damon_sysfs.py | 10 +++++-
 .../selftests/damon/drgn_dump_damon_status.py |  1 +
 tools/testing/selftests/damon/sysfs.py        | 32 +++++++++++++++++++
 10 files changed, 110 insertions(+), 5 deletions(-)


base-commit: 89fea69e3a636d7f4c7a0dee9c25e2b417a74c7a
-- 
2.47.3

