Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43E90C4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 18:23:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0887C6B00E1; Tue, 14 Jul 2026 14:23:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 038AC6B00E2; Tue, 14 Jul 2026 14:23:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E90816B00E3; Tue, 14 Jul 2026 14:23:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A719D6B00E1
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:23:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 71D14120482
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:23:04 +0000 (UTC)
X-FDA: 84988203888.12.2F1EDEB
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf04.hostedemail.com (Postfix) with ESMTP id BCA6640002
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:23:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HNIB+i02;
	spf=pass (imf04.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784053382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KnIZOQELkUux/iVcCPOwRBkQ6Ntjw2d8jEKYPylt2bg=;
	b=rOl44g47Aszy3Tf2EXvKnHuuyzcPcvRu5Esqx4NEkzb8qwpm+IxAI4oIYi1dgauyBTWSrU
	VoSAjNFXjMpTfxldS0hrAc8qdsu3UUl2ZYWZ/9UGuEajfRG7AQA9pEA8yVk11FyWzzc++w
	Yz1hhkqJCYGmCWxlVminU+8OSYrnIfg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HNIB+i02;
	spf=pass (imf04.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784053382;
	b=6Tef0nU1eFOK8+hNPmq5OpPaFZ/8mt4S65jQVYwGxi0Jpk79p8yhCDZi5YHzo09Zr6+/7X
	4VCij9iePJew1jXy5vUIvLc05YWkutO+5zx4SUv8XwtM+tWyWBmcdqpKwv99ywrnt3wahD
	WmTDYHM+gRH6+EZECdk6oJ3cvNlyn0Y=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8efcef23d21so43474446d6.2
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784053382; x=1784658182; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KnIZOQELkUux/iVcCPOwRBkQ6Ntjw2d8jEKYPylt2bg=;
        b=HNIB+i022xTKU18yDJxKLvuy0ki05niivR0PZ/oCmHjmHp4NNCuDShm/96ilP+mbyI
         qjY5IVCRbtgifayZcbpvXXbLo88ZAQYF/j4TBGS59vcC9X9OzcPOzaphlYZWJn+qmMo5
         a0poigWPk4GYtPbFOBgCGHBPIiphqO4Dosr2hpFB45zpQe3u9Qj1Nap61EjFS4YHH95r
         MbEJ63fSk8zJAM/baDxf9RYY1lwnvX3B7CdV8B6z2fEuS12K6dyfk7oRdSTXYbrCddL5
         5jSWgcVzIIxd9HyFeHSv9YjpJdVeXa4RfgZPd8UQ8lBT3ABo1CuUlE0xn0uGR6YSueTF
         P4Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784053382; x=1784658182;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KnIZOQELkUux/iVcCPOwRBkQ6Ntjw2d8jEKYPylt2bg=;
        b=SV7HTnPwR+PixRI+nLGyfVvL7SgGpOplRcOiLYow9T9/oxr9K5Y877tkcw9rKxdW1C
         xLs6nbxa0Y9FbLr8G7uWnyPiMUN0orHUIgUqqUz0MiX48F5eI4w7/DIsqDQxXEhFhJZM
         3bav84hYxm/rIj3R9C6fQzKdJoI2x2MW0J6oIMlcVPFWC1KStUPnmxVtlHj8YQ32AgkI
         ikLGuxsSGTCS/5k7n5twCuHS9pZLgAIsqjYZJK1ZhJzijQeTYCQ9dWUJPL8vFPTRSC2B
         i44QUqz6KE1a4nAxYcoGhfT/8UY7/06FC10btz9sQ43Oz+6IoXgwfsxitYfBFFJ4ZKCb
         1RYw==
X-Forwarded-Encrypted: i=1; AHgh+RpjIIKqDBD4yk29L9JHdCnzYe6kLAtY+wFN+x1GZDz+xrcKzwzBxf07uWgN52DRcA299MDajKfdjg==@kvack.org
X-Gm-Message-State: AOJu0Yz6KG+XJRFX7Ze9V2SYIGBwanKoHXjhNxnN6DVTPim+zUGxo8KG
	rJ3zVSPUm5QJf8mr/CWEuMXup0z2jGOGTX32vptF7wwT0a65YqgBP/si
X-Gm-Gg: AfdE7ckw0SmoeT4dk4iZ9nDg5IG0cDkwgWgKVXLR7CygSyrcGxYA7mlfenmxwYqanMn
	j4ULiwFd1AOo6CzXyeWQbEtiQhcp/PEX4BuK1nIBcZZ7RbNJXSbDEQkCae+XfYBs/UpYBgLwwBE
	QXoqhth9dCHUhI0htrbhnaPulgugvfsiUkZhrDSZXHh+1Y4eFRjMF3vMJVUXCzrN8BmACnT2U3J
	n0b73mYLo8qKG686gGA1JEOAq3TfeMWLbSljchy9K5m5tlkzUdErl/EiPmmkCSISXcCOfWTXKVj
	1lMxWv77fUm/j9si1yzbGEElNlAdW67UR5WKYISBTpw7ecw3Xzzmq0txtpD6FiZDqPQNJF/B6Wh
	yL2rf2XsZm3iMgcymp8u4dKqAJQKkNUCTqGtyaSdOPRwgbLdb8VnRw2M3ihukWnClp+ovzNQT8Q
	f59Z1ZYZmGr3Hni12ZYJa8085OxEYGMqqvDvaWJLbj6JcIdZuvgwo=
X-Received: by 2002:a05:620a:288b:b0:92e:eeb6:b879 with SMTP id af79cd13be357-93086a8fbf5mr351375685a.41.1784053381649;
        Tue, 14 Jul 2026 11:23:01 -0700 (PDT)
Received: from localhost ([48.45.163.146])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d61facsm1539300585a.42.2026.07.14.11.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 11:23:01 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Matthew Wilcox <willy@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [RFC PATCH 00/13] mm/kwatch: dynamic hardware watchpoints for hunting memory corruption
Date: Wed, 15 Jul 2026 02:22:30 +0800
Message-ID: <20260714182243.10687-1-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BCA6640002
X-Stat-Signature: 45teqw5ac1ysye3kwriuaq8jua53mfed
X-HE-Tag: 1784053382-865442
X-HE-Meta: U2FsdGVkX19ICodqiel4pZx+RXrxo986GTMD00+atdXXR5OeFFeYRkPW1b1RrRgONTzmPSuHAnO6OsLO1pAyT8sAOS51rPp7jJF4F8Z1SXmeM60Y9AH2NfGHW0QPuKLX5vr9rrtu1NDXom3AUpEVmm7RlBpiJ1M9F9gZy9bIBnhK95D6TMaQrT335xxGQGekCRo306Ld38z6fEOZz1i3RxnUK5tg4zo9FfVx+shJ0R6nhkCRD7Usww6mNeT5i+FXa4q0kGkXfeES+BaOOaXc7KyDg6EUkIV9rZ2t4YwIKi6I3Kx5c2UrS0KxnCny/gZ9nf3vPrZeMYMQlB8ogGBpAFmu+48XTODvfGePrIlDNtgYHYh9vJy03va3W+DLDGoR2sS6DA8XSACSfaJk+LHgeOq8iS/0SpfIFYi/aUOSLFWEaUjeb9HPvg6w/77wM1d/c1OO3xKNJbcJELj1NlAUjY1TRpSIORA8to/HjvIJUQYL00ZEXh2CJ1x3+byKWlNyUz85mP+PP4qwe6Ak6lTlDHRZxHJCrplk86iuPTge61tWJVwfqcHgpiaTwX+p83p6me9+IPRlsqTEf8klUqI1dLTEXZk9zU1itl/jxT+o6XLHgidZ1aBwQmQ9N6mzDNKnPzsFE0j7WlkGy450YwQ9TqrooPrdoFVGVBjHzjornUyYXfN2tt1YQAcZokLwSw16w69owjqHY0lyHOr7jaJBgT/jy/zBCJpYZ98kL1i3cT0Gv+Pd4CfM6WwOZh5w8JNdsJ/0NUJ0DGJWA9QcRoU3vhIwOvCcjsaMX7BqCIbp2H9KPz2HwUsTXwqarpdNKLSui6T7/hFPQCkWzLtHF+OBZCKBGbwv/SW94HOpW624gaMscVT8f0qukawnHXtDU39J7XJXcjPFUX4vl85xszWxmx/oII5dF9K+v2zh4dq6ec9/IKlL+c8vDsFVURiblBGFc1/85fBMFvxciwp4sJO
 4sYLi6xs
 vLXACymR7EfaB+F92mFked32TkBswEVkmKPRo7I4XpkG8Zgn7V3EPBplI5/u83p3R8G22qfUTMUkkimX+dsLJLG2Zou8gpIl72h11YStYSsn+4MkTqkr5dvFyNQ7j7Wvr8I0mgOedNzTf41XD49rQAcpYdGUi+ZsyEH6c5awZA8vG2Plx3gmm+n93rPQQiRornsy+qaaj2VuYNhjO75guJ8p5QjwDTx5tselybHc1kSzA2utUU9J7NXnaz3MyfK0fwL16IjK1F1zxd6yX8Tv/CHgvbmGwfLZ/a7z/fSnMYK8cBh42YmatSmV9QgbWluo7khxFv4raePSIHP+D9zF4sj9FVC0NCDdEn3ZLN/Q5qfNNog/watoURn1gyTMrJrdC+i7GQcJyJlgulcSfswkFDl48bv5uqG5j+BbKy6G9RuGOjckwQkhJFm/+TshL002gWqUZmChGW6AfscU+1Qc6nT6rM9y9kf+9yqtp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Motivation
==========

The hardest memory corruption bugs are the silent ones: a rogue writer
scribbles over a live object through a stale pointer or a race, and
the victim crashes in a code path far away from the culprit. Any
single developer hits such a bug rarely, but across the kernel's code
base and install base they keep arriving, and each one is
disproportionately expensive to localize. The existing tools report
the symptom, not the writer:

 - KASAN/KFENCE catch invalid accesses, but a targeted use-after-free
   or an in-bounds logical overwrite (a *valid* pointer written at the
   wrong time) never violates memory safety, so they stay silent - and
   KASAN's rebuild, overhead and redzones often perturb the bug away.
 - Hardware watchpoints via kgdb or perf can watch one fixed address,
   system-wide, for the whole run. But the interesting address is
   usually per-object and per-invocation ("field X of the object this
   function is currently operating on"), which cannot be expressed.

Design
======

KWatch implements two key mechanisms: a function-scoped watch window
that decides when the hardware breakpoint is armed and released, and
a flexible expression engine that resolves which address it guards.
A watch is configured through debugfs with a single line; hits are
reported through a tracepoint, carrying the writing instruction and
a stack trace.

The window: a kretprobe pair opens the watch at function entry and
closes it on return; inside, a per-CPU hardware breakpoint from a
preallocated pool is re-pointed at the target address. The pool is
managed locklessly, so a window can open in whatever context the
watched function runs in - real NMI excepted - and a hit can fire
and be handled in any context.

The window is also what makes the scarce hardware affordable: x86
has only four hardware breakpoint slots per CPU, and every corruption
happens within some execution context, so a breakpoint is armed only
while that context runs. The rest of the system runs at full speed and
only the watched function pays the kprobe cost, which keeps KWatch
usable on busy, highly concurrent systems. Global variables can also
be watched without a window, in a time-bounded anchor session.

The expression engine: at each entry it evaluates the configured
watch expression to resolve that invocation's target address. The
base can be a function argument, the stack pointer, a symbol or an
absolute address; offsets and pointer dereferences chain on top, so
heap fields reachable from an argument, globals and stack slots are
all expressible - no objdump session needed.

KWatch is also designed for painless deployment: it is fully
self-contained and can be built as a module, loaded only when a
corruption hunt needs it. It is just a debugfs entry until a watch
is configured, then just a kprobe on the watched function, with the
breakpoint armed only when needed.

A real case: dummy_hcd
======================

Gadget requests were completing through a clobbered req->complete.
Months of KASAN-enabled syzkaller runs produced only downstream
symptoms, with no lead on the root cause. Watching the victim field
with KWatch:

  func_name=usb_gadget_giveback_request watch_expr=arg2+56 \
  watch_len=8 access_type=0

caught the writer in the act:

  kwatch_hit: KWatch HIT: time=370.399836 ip=memcpy+0xc/0x30
              addr=0xffff888109cf5218
   => usb_ep_queue+0xf1/0x3c0
   => raw_process_ep_io+0x5e4/0xd80
   => raw_ioctl+0x251c/0x41c0
   => __se_sys_ioctl+0xfc/0x170
   => do_syscall_64+0x174/0x580
   => entry_SYSCALL_64_after_hwframe+0x77/0x7f

on the same request that crashed an instant later - the crash RIP was
the just-written garbage value. Root cause: dummy_queue()'s single
shared fifo_req is struct-copied over while dummy_timer() is
mid-giveback. Neither a use-after-free nor list corruption, so KASAN
and CONFIG_DEBUG_LIST are blind to it by design. A fix based on this
diagnosis is under review [1] - KWatch's part was pinpointing the
root cause: who clobbers the pointer, and from where.

Series layout
=============

Patches 1-4: a minimal "reinstall" operation for hw_breakpoint.
Re-pointing an already-installed breakpoint from a kprobe handler is
not possible with the current API (register/unregister may sleep and
rebalances constraints); reinstall lets the arch rewrite a slot it
already owns, and modify_wide_hw_breakpoint_local() exposes that for
the local CPU - cross-CPU propagation is the caller's job (KWatch
uses async IPIs). Patch 4 is Masami Hiramatsu's work, carried
unchanged.

Patches 5-11: KWatch itself, in mm/kwatch/ (patch 7 exports
stack_trace_save_regs() for the modular build).

Patches 12-13: KUnit tests and documentation.

Testing
=======

The dummy_hcd hunt above exercised the function-window path against
a live reproducer. Global watching, session auto-stop and the KUnit
parser suite were verified end to end under QEMU on x86_64. Both
KWATCH=y and KWATCH=m build.

arm64
=====

This RFC deliberately targets x86 only. On arm64 the watchpoint
exception fires before the access, so the arch must single-step over
hits, and today it only does that for the default overflow handler.
Rather than hardcoding a KWatch hook into arm64 core code, I plan a
follow-up that adds a generic way for in-kernel breakpoint consumers
to request stepping, and arm64 support on top of it (a prototype
exists).

Relationship to KStackWatch
===========================

KWatch grew out of KStackWatch [2], an earlier tool aimed at stack
corruption only, and has been substantially reworked since. The
hw_breakpoint prerequisites are carried over from that series.

Major changes since the KStackWatch v8 posting:

 - The watch expression engine widens the watchable range from the
   stack to any address expressible via function arguments, globals
   or stack addresses plus pointer dereference chains.
 - The task_struct and scheduler hooks are gone; KWatch is now fully
   self-contained, as described above.
 - A time-bounded anchor context was added for watching global
   variables (duration=N, auto-stop on expiry).
 - Hits are reported through a tracepoint carrying a stack trace
   instead of printk: safe in NMI-like contexts, and recoverable
   after a crash (ftrace_dump_on_oops, kdump, pstore).
 - Invocations in real NMI(-like) context are detected and rejected,
   with a visible nmi_rejected counter.
 - arm64 support and the auto-canary, profiling and test-module
   extras were dropped from this first posting to keep it reviewable.

Feedback on the design, the implementation or the usage is welcome;
if you are staring at a corruption that KASAN and friends cannot
attribute, give KWatch a try, or simply Cc me - I am glad to help.

[1] https://lore.kernel.org/all/20260714064829.172098-1-wangjinchao600@gmail.com/
[2] https://lore.kernel.org/all/20251110163634.3686676-1-wangjinchao600@gmail.com/

Jinchao Wang (12):
  arch: add HAVE_REINSTALL_HW_BREAKPOINT
  x86/hw_breakpoint: Unify breakpoint install/uninstall
  x86/hw_breakpoint: Add arch_reinstall_hw_breakpoint
  mm/kwatch: add watch expression parser and dereference engine
  mm/kwatch: add lockless per-task context pool
  stacktrace: export stack_trace_save_regs()
  mm/kwatch: add hardware breakpoint backend
  mm/kwatch: add probe lifecycle runtime
  mm/kwatch: add anchor thread for global watchpoints
  mm/kwatch: add debugfs control plane
  mm/kwatch: add KUnit tests for the watch expression parser
  Documentation/dev-tools: document KWatch

Masami Hiramatsu (Google) (1):
  HWBP: Add modify_wide_hw_breakpoint_local() API

 Documentation/dev-tools/index.rst    |   1 +
 Documentation/dev-tools/kwatch.rst   | 193 +++++++++++++++
 MAINTAINERS                          |   8 +
 arch/Kconfig                         |  10 +
 arch/x86/Kconfig                     |   1 +
 arch/x86/include/asm/hw_breakpoint.h |   8 +
 arch/x86/kernel/hw_breakpoint.c      | 151 ++++++-----
 include/linux/hw_breakpoint.h        |   6 +
 include/trace/events/kwatch.h        |  57 +++++
 kernel/events/hw_breakpoint.c        |  37 +++
 kernel/stacktrace.c                  |   2 +
 mm/Kconfig                           |   1 +
 mm/Makefile                          |   1 +
 mm/kwatch/.kunitconfig               |   9 +
 mm/kwatch/Kconfig                    |  27 ++
 mm/kwatch/Makefile                   |   4 +
 mm/kwatch/anchor.c                   |  82 ++++++
 mm/kwatch/core.c                     | 325 ++++++++++++++++++++++++
 mm/kwatch/deref.c                    | 174 +++++++++++++
 mm/kwatch/deref_test.c               | 137 ++++++++++
 mm/kwatch/hwbp.c                     | 358 +++++++++++++++++++++++++++
 mm/kwatch/kwatch.h                   | 107 ++++++++
 mm/kwatch/probe.c                    | 263 ++++++++++++++++++++
 mm/kwatch/task_ctx.c                 | 105 ++++++++
 24 files changed, 2005 insertions(+), 62 deletions(-)
 create mode 100644 Documentation/dev-tools/kwatch.rst
 create mode 100644 include/trace/events/kwatch.h
 create mode 100644 mm/kwatch/.kunitconfig
 create mode 100644 mm/kwatch/Kconfig
 create mode 100644 mm/kwatch/Makefile
 create mode 100644 mm/kwatch/anchor.c
 create mode 100644 mm/kwatch/core.c
 create mode 100644 mm/kwatch/deref.c
 create mode 100644 mm/kwatch/deref_test.c
 create mode 100644 mm/kwatch/hwbp.c
 create mode 100644 mm/kwatch/kwatch.h
 create mode 100644 mm/kwatch/probe.c
 create mode 100644 mm/kwatch/task_ctx.c

-- 
2.53.0


