Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82ADDF30283
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 21:00:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2A476B00A6; Sun, 15 Mar 2026 17:00:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6550B6B00AA; Sun, 15 Mar 2026 17:00:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55B556B00A9; Sun, 15 Mar 2026 17:00:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 415D86B00A4
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 17:00:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0E41BDCE9
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 21:00:25 +0000 (UTC)
X-FDA: 84549515610.07.71B3770
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 415DAC0003
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 21:00:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pylHVRuK;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773608424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2ldPDRz+ia1mGeNTEEoTUBKBxm1Cha2qK1YiSOJRtmo=;
	b=zp2iX9z36cG9WNHe8USaUMF+u082YWWvMqyxtPxDajki9Ic0E89jAXu9pgQAPcEuArsYB2
	cWx75GpKg865eslFGXjgP6n95NFRLaq8Ljs9cymltvUVOiau9bLA2A9FGEg3S+SuBByaTQ
	EvoSpV3QFhmvLyq5cEURz4QmCC9on34=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pylHVRuK;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773608424; a=rsa-sha256;
	cv=none;
	b=DMWBzgHjkXjKYcTx69o+cIZ4UbqA5xKWWCBfXeD9fTsdt6/lSZZh83Rp6lmTHMks7rj9/m
	j/XXoSgd/9cGFr/RFzArc6YAPuJgfdif2ER28ia2x0tQujiTs7w2YD0NggM2RHvTa0sqxd
	Vkogc64+z31JJ+KVENpn3qamTP6+bSc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C1E441AFA;
	Sun, 15 Mar 2026 21:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E0DC4CEF7;
	Sun, 15 Mar 2026 21:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773608423;
	bh=XnIOlQqQj664a9OSr2rVhvLZUQiwYMWAxdX1C8eCcLc=;
	h=From:To:Cc:Subject:Date:From;
	b=pylHVRuKIp2RySkn/vjGtU/jKV1EUrVmO8HhjUb40IJr6XYVS6+PqAWYKKzNda/8O
	 y184DIjBgJEjfd5/R9qy+uV826AOyPG/T2NO+e3YcEU4PuVF7A5L0v1S8m/7bEKOFb
	 42qorg8HwSp+7e/4tT1DVBuZCUEAdVHeodEZZFd+CwGxxRbGGsLOqQztzRe1qz09GZ
	 /ChjDeMNDtuJowFl1rtPt3dGO9wUJ8gvg3tJOFoj8VPEjGhyE3rxNT77b4O/b9smkF
	 1rgPFaP0/9+0jTeOg+fasWgnxj7lDeB/7UoMmF8bjcXwAUINz7mmgy382fgs1VOxUa
	 s+7qj+322iGbg==
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
Subject: [RFC PATCH 00/10] mm/damon: let DAMON be paused and resumed
Date: Sun, 15 Mar 2026 13:59:59 -0700
Message-ID: <20260315210012.94846-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 415DAC0003
X-Rspamd-Server: rspam08
X-Stat-Signature: 6hpbm8m95tsi8yqhpnr6ztoq8y4ay7yk
X-HE-Tag: 1773608424-805783
X-HE-Meta: U2FsdGVkX18GTDHlCea2neRvn31ijUko76ec3yUCqgkru/bqkWeShX/9jml3jfeAber/a/8O0PFuW9PTITDIMjTOmeA1YbNkZbfk/S+FIefibpGNmj25z8wh4zsZynrgshq8f8OLFrduddMcTLxj8mycy5rnWjdj2GJlcj9C7Yz2RsEbnZFiAasrL/GojXRNcMMDzjczRLpf2kN09mq4tUFZugHvwdm6gCeF3+m3iOB5GSbfY7kepLYFP/u7q3K/yU1M/nX+mD4qMav0aBzmf5MEO0nu+JQrEXJUMWEM4gQNUOfwGDDduXUosNRAVd+xi/rLXi0So46ETiz8jxTt40Wm+ro5q3TtmSe+wpx7yjRsRk3piKEY4BoWs7RH85jI9wCWXs9B4q0rnPrTS9yCk9/vPU1ue6sMe7Llj+Gg20DSk41uaBfjOc8ufuLwJSTiQm8Eqomor//KC907MY8JCO/kSxxXX4MYi3ITm+esZxXRBNO0YtYEI4a+y+jQBZMewM9Hqj+h8rU0QUvG1G1k0MdzM1iBMHWPb0nHZ3eRVAqZx4WKM73LLeTJE6Bt7yzoFcDvZWbOqD/L2pJUKSd4HzXUchVRmopTL7FSp/qJkfFXSaSbt+s9ar+melEpRRq5oly4G1YxgwT/GEfn/Jj4LJEGuIEaI70Y6pGQJZJLAR+pwU7VxiVbt70Xuh5Vq1eOhG+94bKU3FiqD8zq7cdPax4VtSq78vEvO8zUgI60cI/WK+UXtzP47+yJX1pR0k8pyrHY3JVDLFkMLQJionGZQqYtIEAdYYJLYrtb7+kY3ClLfzF7zHPPEqT4xmcR/JMGD8Dgc1aoTDvjuF7KtXiyfXLDTKntPn0DdoRmEhvQ2n6wY0Tvl3gXw4eTHJYWvCbWjzPkfMWWRJuxIkWimqmfLhyUL6Rznq5nhaMLDngAsrwICdvkyHDAhobup9C7zgfw/ZdmqbCK6nZVGW227nK
 abg+QqqL
 c4B5ctVrY2TYfkKy/cot7IByGUBZPQxfh2GPqBBDhJwb3GCqO8n0OPtt6GM5qv0288HOIbn1aeSfJF7hRY7jjdkQ+0gGPSRzJ/Ivfux2a4eW4NZpB14RlacPmzw0f1c63eaaIUHM+32eEUWeu0ugu/2JIC/kK81NlAXJg5AMDEPSEofCtisAXUL1QiSZYdLyfsVve0Fl+4pv4LpyyRPSAybK2zg==
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

 .../ABI/testing/sysfs-kernel-mm-damon         |  7 +++++
 Documentation/admin-guide/mm/damon/usage.rst  | 12 +++++---
 Documentation/mm/damon/design.rst             |  7 +++++
 include/linux/damon.h                         |  2 ++
 mm/damon/core.c                               |  8 +++++
 mm/damon/sysfs.c                              | 30 +++++++++++++++++++
 mm/damon/tests/core-kunit.h                   |  4 +++
 tools/testing/selftests/damon/_damon_sysfs.py | 10 ++++++-
 .../selftests/damon/drgn_dump_damon_status.py |  1 +
 tools/testing/selftests/damon/sysfs.py        | 28 +++++++++++++++++
 10 files changed, 104 insertions(+), 5 deletions(-)


base-commit: 027cb70b08db6e3df632c49a8c7590ea830f7a96
-- 
2.47.3

