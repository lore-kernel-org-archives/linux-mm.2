Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFA45CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 05:06:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2402F6B0088; Thu, 14 May 2026 01:06:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C99C6B008A; Thu, 14 May 2026 01:06:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 091A16B008C; Thu, 14 May 2026 01:06:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E8ED76B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 01:06:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 506C3160729
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:06:06 +0000 (UTC)
X-FDA: 84764838732.28.DBCD9F9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9C718C0009
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:06:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mZNhI7HC;
	spf=pass (imf28.hostedemail.com: domain of justin.he@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=justin.he@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778735164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xjkVZSnS/Z2AOrtCV1R8zHEJzg8JOBixwmnFzmiqQj4=;
	b=SVpoWwrUOKI6hs2o4EfhPuUlKBS3ot/7Tzrcg+ys07hYPPzr5fL4oFHuJtg3mgLjqkDBq5
	2IfMRVFzNRwNgQ4pUVRkNE8w/wELk9doulD1CEaiO09Abafig1C6Tg8aAjY+pXbWMWAaFR
	RR5kr8wDBwIKzSC5wDcCgwA7YrBLBg0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778735164; a=rsa-sha256;
	cv=none;
	b=EzBboVJVY4zzcHtgn+knqZVKVmWVAIXnYJnvgsKMbEgKujyUFqgFBxh425L1BqdmW12jjl
	K2aSysNclkHry4euthyebJ5xMoDySH0Mm5oE+WbntleQmpUOnfGYa7zuYyFHeyQLhhEkAm
	/he4O2rin6F5D/1n5p4eJmhQiux09o4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mZNhI7HC;
	spf=pass (imf28.hostedemail.com: domain of justin.he@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=justin.he@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4FE4C1E5E;
	Wed, 13 May 2026 22:05:56 -0700 (PDT)
Received: from entos-yitian-01.Arm.com (unknown [10.168.197.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A2DE83F7B4;
	Wed, 13 May 2026 22:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778735161; bh=j2dsDIqac90jQ0WQlQWnsokHihGVSzF8CeUhj5mROUg=;
	h=From:To:Cc:Subject:Date:From;
	b=mZNhI7HCYS4q2+SIi+N5C08riKoYsINO3A33S7yvhol/OO6dezE+5jjYX7RKwuofA
	 bSBdYnLIFODZYDYgrxVxW8ydVuyjNLMKoL3Kx37X0fdSDRcmlIG+HBlNUH9+WbtRW3
	 N5kqDBjyqieeEi9Tu6pku5vc1UX/m+B+9AVo/5eQ=
From: Jia He <justin.he@arm.com>
To: linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kunit-dev@googlegroups.com,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>,
	Rae Moar <raemoar63@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jia He <justin.he@arm.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Petr Mladek <pmladek@suse.com>,
	Kees Cook <kees@kernel.org>,
	David Disseldorp <ddiss@suse.de>
Subject: [PATCH 0/7] Silence spurious warnings and crashes from kunit test suites
Date: Thu, 14 May 2026 05:04:48 +0000
Message-Id: <20260514050455.2954509-1-justin.he@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9C718C0009
X-Rspam-User: 
X-Stat-Signature: i41anhd7gsezxfsbqxfejk7hef9xsnqg
X-HE-Tag: 1778735163-931522
X-HE-Meta: U2FsdGVkX1+DDrS+w2BcD59laC8wjEOtfXFTjmyAdqg8vVcOTrakKPuoB0qw40UbqpHm1tfNvVOlIcPRrNH59FsqTvZLQ51/LWXbMzpqwn2yWN+iX+RkI+D4M/kmhf/sYkGSczphEU5+nWaMxaasZphn3koQso7NAaTWOGKi58D7Q284tO+jFTYnHqhFgGuTBsW0BpKZMiMJBeuzStmfAXmZccT+9kSvknrMP1ZpEt3/nUtigRP8MaecQrF1w7k6U1IPfoCFve1mwYZL6wz2uMfLPNAwF+K5pq6xcZqGLrjVxRBAglUd2dQH8CI6B7QJxBhypNuCytfvBdbcgwApB5aBHZcIrv+pueDbp/mz38o/dMNO8CvyGM14GDX9/n06IN+Lkv894EdbQRDzgpefSE7zQmGZeSuPA+LVDNrchLZh4fTfdQsTCjZ9cYUVxjnQEADr+vNBh1F82Vmx6NywA/EaonbbYmrEIUaUNKHotIpftWO0FBkSDJEdu8GGmBBpEhJPEMvnOmnG+jCDc6RtHSdPYjd+R5U5R6YtM+YyllLqb7ku0FulG8XlSwCgDpWpt4yLFRbRzL7RiXs5vpbPDozmq+WksAnhxMTHvcsa/piTJ7y9TMIR0ypS1LeAHIOhpILM3WENqa2AA9zQzAEK/9F35E9JGC77UwoHErZFnXSJD7W53PC2z6u3UEOaOXmVQzfga++ox104tpipenyrODEmbEqDHrIYOCgjGc5nV2mvKXreSCU3f7YLY1dGzLhJlUK86KHqLVWg/DsWSqvGQ/TYwUsiRIXE2MTCaLrMXMFBcJvTnE8O9bIxNI71PTULDMn2kEpaFsJyQ94kY8UGEWrqMVK2xat7uUZRSmL5iKWbs7249IX+i9q/OSa67JABWZYsJa3IrSJEoEm8XnlQSiGwV8cWoTFviUvFaNV1NQ7Mvmxh3hFUBQUBGg9b9Cj5t4tuHN3Y7vXW6sQ4byq
 yGXgqkO8
 g5yK2cc8YwNrUxHj48R96yWJN9ut/ZM246UwXoq/kzOYy6/oZYHbWo89/x+pQsCydGnQkWKQFlPfMZk00eXzTiO+zy6hQRI1jsOrNOCRyutWMADqPtkfIk6RK9+3YTPMYWTvVaQjo2awpgOvgN9StjJuYt/ZegoO4hE60a+WGTJvdgA0jVb4JLL9zHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Running the full kunit suite on arm64 (128-core Neoverse N2) with 7.1-rc3+
produces a handful of backtraces that are not real kernel bugs but
rather test-infrastructure issues: races with boot-time code, missing
bounds checks, resource leaks, and sysfs duplicate-name splats.

This series fixes them one by one so that a clean kunit run no longer
leaves noise in dmesg:

 1. init/initramfs_test races with the async rootfs unpacker; add
    wait_for_initramfs() in suite .init.
 2. kfence kunit cases fail outright when the pool is unavailable;
    skip them instead.
 3. intlog2(0) / intlog10(0) hit a WARN_ON that is harmless; remove it.
 4. kunit_platform_device_add() triggers sysfs_warn_dup() on the
    duplicate-registration test; catch duplicates early in the kunit
    helper (best-effort; final protection remains in driver core/sysfs).
 5. misc_register() likewise hits sysfs_warn_dup(); reject duplicate
    names explicitly. misc->name is never NULL at this point since the
    existing code already dereferences it unconditionally.
 6. hw_breakpoint test_many_cpus overflows its array on machines with
    many cores; bail out at the limit.
 7. test_ratelimit stress test checks the wrong variable for kthread
    creation, leaks memory, and races on doneflag. Use goto-based
    cleanup to guarantee all started threads are stopped on failure.

All patches are independent and can be applied/reviewed separately.
Tested on arm64 Neoverse N2 (128-core arm64) with
CONFIG_KUNIT=y and CONFIG_KUNIT_ALL_TESTS=y.

Jia He (7):
  init/initramfs_test: wait_for_initramfs() before running
  kfence: kunit: skip when no pool is available
  lib/math/int_log: drop WARN_ON for value == 0
  kunit: platform: catch duplicate (name, id) in kunit_platform_device_add()
  misc: reject duplicate names in misc_register()
  hw_breakpoint_test: fix test_many_cpus failure on large systems
  lib/tests: test_ratelimit: fix stress test thread lifecycle and leak

 drivers/char/misc.c                |  22 ++++++++++++++++++
 init/initramfs_test.c              |  17 +++++++++++++-
 kernel/events/hw_breakpoint_test.c |  12 ++++++++++
 lib/kunit/platform.c               |  36 +++++++++++++++++++++++++++++
 lib/math/int_log.c                 |   8 ++-----
 lib/tests/test_ratelimit.c         |  26 ++++++++++++++++-----
 mm/kfence/kfence_test.c            |   6 +++--
 7 files changed, 115 insertions(+), 12 deletions(-)

