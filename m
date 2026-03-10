Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F76DEB1063
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 14:56:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 733CC6B00BE; Tue, 10 Mar 2026 10:56:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 714D26B00C1; Tue, 10 Mar 2026 10:56:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 668356B00C4; Tue, 10 Mar 2026 10:56:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 54EA96B00BE
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:56:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 192DE567C6
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:56:30 +0000 (UTC)
X-FDA: 84530454540.03.66E138B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6222F4000F
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:56:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BmYJxjF5;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773154588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=e2GDU9qoSm/KLo/nFV5ncI3YrUp1pEDOPoiLdBpB96I=;
	b=Zp+SoyUNzp451H/UVuHnVaGBmgIxvMbC9Bkf2EY6Zk6ZgmAznSmBqLOhwmv+OUo0L+UCUn
	+vWj44PV8hNhhLd5/KIpRNf31mZ35EJiBSsdbAFvziT4g62uokhzVQU4uoFW33VVKEPHKZ
	uOU4pty/89WgxuM6epCkEn7IutSHMx8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773154588; a=rsa-sha256;
	cv=none;
	b=bHabHGY3rXvdFW0XIUa17M1vBPKMVOH8BuYJKJmXdEPO7U0MWji0VTze16km5RiD2N1WPh
	eg7yxMlRtKxdW4UKN/pdcDFE/8fMU1e/w3enQCn4DEKrAZjXiADtjNUYk9XpvlGPDwG6oH
	+G/98NJFeSyJoefw6YrX2pQdoJrh+TU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BmYJxjF5;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5220A40E42;
	Tue, 10 Mar 2026 14:56:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9FAC19423;
	Tue, 10 Mar 2026 14:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773154587;
	bh=fE0Z/ubIZkvllDHDQoyXm3PyilLIY5Tu3AO0WZjDsTc=;
	h=From:Subject:Date:To:Cc:From;
	b=BmYJxjF5a9dvOp3Ha8UOY28eN9Ls8Tj2k9Ht30d/cMSVQDuueoydi7eHYyhEKug0P
	 7Nlx16fAGAVjuUcYJ2TifdA8RZUEW1WVE9bwxzk6xsX+LpY8pVoI4vRK7LSwKi5txn
	 TXEzAkjKCCygTWwTUJXDiJ1W7J4iNz/l+AwgclQGa3Y15wLxiZd+BOIdUxRV70lpku
	 Yb+xcr51PtPS54Gt5fizFsM4bBka1qsrUKeauVLz/PqrHs9sj2wVpJAkDrkRlREcW4
	 KDGuvIRo5jnylDD0rRfqsWWjU9OfzKITpIrGYVmZLMxWkcDeykF04Ooym+xGP7OcEp
	 HXaeEl2lsisxg==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH v2 0/2] kthread, exit: clean up kernel thread exit paths
Date: Tue, 10 Mar 2026 15:56:08 +0100
Message-Id: <20260310-work-kernel-exit-v2-0-30711759d87b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAgxsGkC/yWMWw6CMBQFt0Lut5fUkuBjK8aPthykosXcViQh7
 N1WP+fkzKwUIR6RztVKgtlHP4UMeleRG0y4gX2XmbTSrWpUy59JRh4hAQ/G4hNrHPvuBO202VP
 WXoLeL7/k5frn+LZ3uFQ65WFNBFsxwQ1lepqYIPV8qBWLa2jbvtE5QPyWAAAA
X-Change-ID: 20260306-work-kernel-exit-2e8fd9e2c2a1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org, 
 linux-nfs@vger.kernel.org, bpf@vger.kernel.org, kunit-dev@googlegroups.com, 
 linux-doc@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 netfs@lists.linux.dev, io-uring@vger.kernel.org, audit@vger.kernel.org, 
 rcu@vger.kernel.org, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, linux-mm@kvack.org, 
 linux-security-module@vger.kernel.org, 
 Christian Loehle <christian.loehle@arm.com>, linux-fsdevel@vger.kernel.org, 
 Christian Brauner <brauner@kernel.org>
X-Mailer: b4 0.15-dev-9fd7c
X-Developer-Signature: v=1; a=openpgp-sha256; l=3309; i=brauner@kernel.org;
 h=from:subject:message-id; bh=fE0Z/ubIZkvllDHDQoyXm3PyilLIY5Tu3AO0WZjDsTc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRuMBTr7bhhNqNZgWf+LzYHk0VPGot/7yk3qp6qVMf86
 r3sWbafHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABOZtoyRof32OmMzK1MvFp3i
 RLOjK2rOFX5Z+v3AGxeDj8ltGz5br2Fk2COsfshHNk+cZf2uoIUP/xl9bjn/zH4H6x9zpi1CQW+
 KGQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: c7a19r485enfujp46cuway113m4kkgim
X-Rspam-User: 
X-Rspamd-Queue-Id: 6222F4000F
X-Rspamd-Server: rspam12
X-HE-Tag: 1773154588-719622
X-HE-Meta: U2FsdGVkX1/s2zW4j3ldvTqp55m7saJdVZhV0fB0YkXDArNFsYg6OFVoj5tD2V5cdjaxt3YEIDALJIkdztviNmOHfzTtaPk5ePBviYa51lpEFZGkoNOgwEzkCDVcGcvuk3dtokiXlMabybW6CJszfkuy8rnGjwHT735kO8E5ThrjwqkbXLGIYV74sWlF5gZEiMgBrPJo3md1/+JJwtM9lZuTw8sIOBQsMMdtfRCMSqhCsukk1O7/ez50OjKtugsyXeoW5WUnfALfPfwRMYjuevCQRt/E9ZD8c8hkC5bhyk4rFZSxUTrRTC21HUB07fw6yoGEzANWGiGsskb+K3LVy57l3UX/yjlnlj0dEno1MhoVtvx3w0q1434bvaunw69Kb3dYasblQuUEYbOnl58Qb+Ss1x2LarAVilCD5IcA2i1EOkuyeqQ+gGUCcq83mBiSyw9y6P07b57zQH58ck7H0JIJa2mjnGN82cO6xs5i9354d6ml6hHXpx0OOREIElPHeShtErTzFYagOqXanLVlDu9IuosXvT4dpTRGPvpbwm4wTZuRjx06gar7y+FcTspfevx+2naf6BXFIEiG+znZYOez9PTrAQRPG4lY7PIRo6uh+qGSmo5OGrjW1A74/xOGl5ghgdlVIiG/XS0XUOV9X2+Vlv/ydiY+mL7RGzmwn975RMZwu4QpKdytBAfzFrI0uvqnywHDcpLoLIOOI9ApkgfrjXZ8qjdkIjd//Oj67v68w0DxPScHjjEuTVIG5fPjBqSHXACL8XlPQKT4+C3g3YO9NppHl8OGezKIgAS8ed9Z9OCsBzeck26XBK36PQKKZslCrx9CKQMF52L/Ti+r3pPfWAdI3CgzuJ52g1pmRKQnEal+ksRqtQOOWDbEb9t97epouEa4Egy8qe4U90cSlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In 28aaa9c39945 ("kthread: consolidate kthread exit paths to prevent
use-after-free") we folded kthread_exit() into do_exit() to fix a UAF
bug but left kthread_exit() around as an alias. Remove it.

While at it, rename do_exit() to task_exit() to communicate that is not
just a private api.

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
Christian Brauner (2):
      kthread: remove kthread_exit()
      tree-wide: rename do_exit() to task_exit()

 Documentation/accounting/taskstats-struct.rst                |  2 +-
 Documentation/locking/robust-futexes.rst                     |  8 ++++----
 Documentation/trace/kprobes.rst                              |  2 +-
 fs/cachefiles/namei.c                                        |  2 +-
 include/linux/kernel.h                                       |  2 +-
 include/linux/kthread.h                                      |  1 -
 include/linux/module.h                                       |  2 +-
 include/linux/sunrpc/svc.h                                   |  2 +-
 io_uring/io-wq.c                                             |  2 +-
 io_uring/sqpoll.c                                            |  2 +-
 kernel/acct.c                                                |  2 +-
 kernel/auditsc.c                                             |  4 ++--
 kernel/bpf/verifier.c                                        |  2 +-
 kernel/exit.c                                                | 10 +++++-----
 kernel/futex/futex.h                                         |  2 +-
 kernel/futex/pi.c                                            |  2 +-
 kernel/futex/syscalls.c                                      |  2 +-
 kernel/kthread.c                                             |  8 ++++----
 kernel/locking/rwsem.c                                       |  2 +-
 kernel/module/main.c                                         |  2 +-
 kernel/pid_namespace.c                                       |  2 +-
 kernel/rcu/tasks.h                                           | 12 ++++++------
 kernel/reboot.c                                              |  6 +++---
 kernel/seccomp.c                                             |  8 ++++----
 kernel/signal.c                                              |  4 ++--
 kernel/time/posix-timers.c                                   |  2 +-
 kernel/umh.c                                                 |  2 +-
 kernel/vhost_task.c                                          |  2 +-
 lib/kunit/try-catch.c                                        |  2 +-
 mm/hugetlb.c                                                 |  2 +-
 security/tomoyo/gc.c                                         |  2 +-
 tools/objtool/noreturns.h                                    |  3 +--
 tools/testing/selftests/bpf/prog_tests/tracing_failure.c     |  2 +-
 tools/testing/selftests/bpf/progs/tracing_failure.c          |  2 +-
 .../selftests/ftrace/test.d/dynevent/fprobe_syntax_errors.tc |  2 +-
 .../selftests/ftrace/test.d/kprobe/kprobe_multiprobe.tc      |  2 +-
 .../selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc   |  2 +-
 37 files changed, 58 insertions(+), 60 deletions(-)
---
base-commit: 1f318b96cc84d7c2ab792fcc0bfd42a7ca890681
change-id: 20260306-work-kernel-exit-2e8fd9e2c2a1


