Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2990CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:36:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 048728E0039; Mon, 10 Nov 2025 11:36:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01F5E8E0003; Mon, 10 Nov 2025 11:36:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E50C68E0039; Mon, 10 Nov 2025 11:36:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CBBAF8E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:36:44 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 720FC140197
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:36:44 +0000 (UTC)
X-FDA: 84095251128.24.BAD34B5
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf14.hostedemail.com (Postfix) with ESMTP id D1B21100019
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:36:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lFRVYmvO;
	spf=pass (imf14.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762792602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OmF3ZiRo+z3/MUzNtC1wwNg9IEmuUusZSisJNz5BISs=;
	b=jpFoz3WPNuPiutQ+TWLjMmUbY5FSmAGr/2+aZa05Lxvd66lWrZpNhxLECpxQ7iB2SX88g+
	XPj/mm4pDXQX+bB01awMHgGfZ4qdF0fOV4kGWogVe7LHvRoaGMK0yDstpD9qkh2/6wsAsz
	g39yzJhRlv5VvgQNHJDdNLIcbOjMii8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lFRVYmvO;
	spf=pass (imf14.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762792602; a=rsa-sha256;
	cv=none;
	b=XNQdQfr0uUiEgObpG9QAtV5LtW0uF6gkgQt91rSi/lvgOY1UgwpqL/Ls1/bYIG2l2dkSoK
	FdNNqDqORgR7+9NZTZpSja7ezr5TufWw8qJPbS2qCXiVxSSi6dhQnW2rWSt4+UsMBwuqag
	A1YcOz8RcjakPR3AjEi18Y+/po3b0/g=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3410c86070dso2128719a91.1
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:36:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762792602; x=1763397402; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=OmF3ZiRo+z3/MUzNtC1wwNg9IEmuUusZSisJNz5BISs=;
        b=lFRVYmvOoG36rrZHzL4vaaC2ycGBop5cFTTZJZxnN3ZZcCxDbsxIIREzTRry9Nr6vR
         /CupSR8Qu/h7YYO/tn395Jxw5G7NvtMjoM9c51HOmm+ieTNlVhvVI8WO6r8owufcx9B0
         CxgIyi2EzhaeE772wqiTPWpF61qSQMUtdMJ9HePl3sO/+ZRs3xGYFdtMUE5AuhB0mp6f
         o4VtlJIWsBngNm8rM4z1dOW0tkEkopcrD8okYFmtIo5PqUcOkUXskaFoekSGvbWJ/MOu
         9dUkovinH9A7HmsJL/SXALCllaUhorFpw5EUXjXRq1uKoPna2V9t22j4blKA/vuUStlw
         q5IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762792602; x=1763397402;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OmF3ZiRo+z3/MUzNtC1wwNg9IEmuUusZSisJNz5BISs=;
        b=J/qmYnIUGFyZUwu1Jxd/GBfXD97TDPHLVYnOc/gPSMcxulJg08C7K4xOkw4GRX15cn
         7kF5CYng51Rhcsifv8MMi7GUbB+fZ/FUKfuucZhydGzzhQydJxij21o12zCkwj6zT/0v
         KvGHKViiHsVAEINTlnii5X64ujn2AaUpL4EAWxLsYddd1eHLZO/o/U/qk0gG2xLyGfFR
         +QhUqq6moRdTo/Zzys/9pFCbBhY5DF2WjZLuVQnc4J4llmH3HbU0UTwFxmcXNOJ5mr7Y
         YPz2K2cX4XzUeJ2j7hsLhelf3tLdx2aZlCRHe6xvaKTKJ2oOERTZ3WI78c/Q2TprjmlJ
         GUmA==
X-Forwarded-Encrypted: i=1; AJvYcCWub60GYzk/7/gBRTzUAW5/wzH0JsgEnvacGFg6CGJ/KgvlTFHQBqqWfQWzBQ1W93hZi6S3VkaRAg==@kvack.org
X-Gm-Message-State: AOJu0YyvjDdAmxfOpnipUkPu3upSdWSYoREtsz17qiaCZmzk1XctY9uL
	vbZOKRiiJUV/iDZCEo4ljqqrwPpzO43BkByR3wb0AcrMkJf4bDUwtLvN
X-Gm-Gg: ASbGncv/CIWhVK0UB/Q0H2x3YKfsuLfRp5PzqaNApyledZl+2fNNmSCrz3aXWqGfnoq
	iTPO46aIAoL6z1GH62wbZfOu+C4pWQXNuQJhwMYLch21MEMXwoe+piO/msnTM2tHmQX0iYpdHcW
	VFzEsHGnqH0UPnTEaH5Xa4Nt/4XX6DTMYg9qBJUHlhGjKpd7t4qBwcEO+D1yAnA8eaIFv9HRsQI
	SWCPTv6y6S53HcqBETcB1i+euqHwhtZ3BdAQIZt0UcxWH6MB/CioCcQJuGl6bYrgQN07cL3Eh32
	hVhuDbOAVzSRYXNNpWqiZiuLw3Pn1vHm1BUHpe1enFsbEyZQDFcMi+jdA2lCUzyRa8dReoD45Nk
	eHTrCXFZ4agkOE/68fUFEOFonxBndFiD/eF1syfEwMFG1WsZnEJJn6aO5/GCmvLcn81zJ9XMhWv
	z+F2ml5bQx2bQ=
X-Google-Smtp-Source: AGHT+IG4Ijd1mOBZgcS8rSNiAG+x0vPHrGAlLEBJfBng2UjtGnnQoMVk98YfwkoPNv3aujC54bkU+A==
X-Received: by 2002:a17:90b:2d0d:b0:340:bfcd:6af8 with SMTP id 98e67ed59e1d1-3436cb73a21mr10515621a91.4.1762792601393;
        Mon, 10 Nov 2025 08:36:41 -0800 (PST)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ba8faf1dc06sm13055990a12.16.2025.11.10.08.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:36:40 -0800 (PST)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Marco Elver <elver@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ben Segall <bsegall@google.com>,
	Bill Wendling <morbo@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	David Kaplan <david.kaplan@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jinchao Wang <wangjinchao600@gmail.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	Justin Stitt <justinstitt@google.com>,
	kasan-dev@googlegroups.com,
	Kees Cook <kees@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Liang Kan" <kan.liang@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nam Cao <namcao@linutronix.de>,
	Namhyung Kim <namhyung@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Naveen N Rao <naveen@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Rong Xu <xur@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	workflows@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v8 00/27] mm/ksw: Introduce KStackWatch debugging tool
Date: Tue, 11 Nov 2025 00:35:55 +0800
Message-ID: <20251110163634.3686676-1-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D1B21100019
X-Stat-Signature: y1gnngexz5i3i676mbmh3a9x9nwu9oqw
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762792602-372056
X-HE-Meta: U2FsdGVkX19EnjF8WZg4QCaJaSLv2K9dN1s8uQwqZ09RMoWkCcWVPQEv+DPTIoOXyzS1BC53hk9H/wGn6On8LHZBmF+w33WigxxNkS/gZXqHtsgVtbQoueXhHjhuqUQ+d5ci1dx5R1/qXQlWADQpJJ7iQHWpnSGH/DYiczniFyCdlY0ffY8u64u2tTAeOWN5rRkuDyn5gt+mENz8CfmYgfWV64Ikn0McJFUyRVftt+GopROHTEHyIPsB22/nb73T+kpOCDhjScTWzPqZTHZ8LgWBtlYscmPYhqlM04hxH9F/F3oDhZPT0I/ktmLId0j4F3Z5wWzXSC4dQj9EPHJtEe5WWmTkGqgoJZAxHDsYXGpwRx/dihkDk64YvClzdlLB1FphXyjWXQjgUmxUlKZRIOd68TCsrryWF0uiMb0fmPyma7+/483VuLJfVuMueAEntyhcSfvC6Pp+GhcTmIGkWvNfQ5dLyBDWPE66Vz8TAOjwBqy/81QhUypD7Xl3c7FHCtIc+/JMPPGQ5DKdtxlEIvgQm8f79e3sIsFegk6w1Eoeo7Z2uNvXoBpTZqxeNawzBEck/tNFMncL8g9gdwDGHvIDKHnUwqUvplqKe8YgYqTzIyypvWKV4+4InoC1bE66CMnbcuW8Z7+TGHV6K4SOIZcsQ6tZIMvkyc2nHSQ71AGYnhufz8pUWR8KRk7bGd3fUULuzTC59Cbq6zeykMMXskchveWy+2xRkCngPH3ejv52yoaVSlH9alDUsqEnjdItMgkZes1bUx6RFSfWc6SyQwIMQLZCE++A0g0LnjoHeRjbLord8EV7X6ZmKgNBehl4OR/OhvpZnNICuOn+JGjkStyPZqWRzLv8v6xiVJRiTiYDr8oU+pZr4e2j6UDM1oKYY2BAnIZYRmnLwji1lW97SYxeVyP1fCoTRBqlxnwQ3gY8ADkb2pjwlrFPrT0tnsh0p/pwd44yEy5FdUgMnZB
 3bYLt62o
 0IxeHzuZjS1YPKku6DvPhrNmhsYf+3yR5DYTaFhrStUqRo+LwBB32kxFD6JwQhOlT2hZXV98KYP7+gvPwFOnyXgyk8eOSfdr0BHw8cP+Zx8VqGKQY7j9CTYJ/MJIFfwyoG16xTZNTogyq0TI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Earlier this year, I debugged a stack corruption panic that revealed the
limitations of existing debugging tools. The bug persisted for 739 days
before being fixed (CVE-2025-22036), and my reproduction scenario
differed from the CVE report—highlighting how unpredictably these bugs
manifest.

The panic call trace:

<4>[89318.486564]  <TASK>
<4>[89318.486570]  dump_stack_lvl+0x48/0x70
<4>[89318.486580]  dump_stack+0x10/0x20
<4>[89318.486586]  panic+0x345/0x3a0
<4>[89318.486596]  ? __blk_flush_plug+0x121/0x130
<4>[89318.486603]  __stack_chk_fail+0x14/0x20
<4>[89318.486612]  __blk_flush_plug+0x121/0x130
...27 other frames omitted
<4>[89318.486824]  ksys_read+0x6b/0xf0
<4>[89318.486829]  __x64_sys_read+0x19/0x30
<4>[89318.486834]  x64_sys_call+0x1ada/0x25c0
<4>[89318.486840]  do_syscall_64+0x7f/0x180
<4>[89318.486847]  ? exc_page_fault+0x94/0x1b0
<4>[89318.486855]  entry_SYSCALL_64_after_hwframe+0x73/0x7b
<4>[89318.486866]  </TASK>

Initially, I enabled KASAN, but the bug did not reproduce. Reviewing the
code in __blk_flush_plug(), I found it difficult to trace all logic
paths due to indirect function calls through function pointers.

I added canary-locating code to obtain the canary address and value,
then inserted extensive debugging code to track canary modifications. I
observed the canary being corrupted between two unrelated assignments,
indicating corruption by another thread—a silent stack corruption bug.

I then added hardware breakpoint (hwbp) code, but still failed to catch
the corruption. After adding PID filters, function parameter filters,
and depth filters, I discovered the corruption occurred in
end_buffer_read_sync() via atomic_dec(&bh->b_count), where bh->b_count
overlapped with __blk_flush_plug()'s canary address. Tracing the bh
lifecycle revealed the root cause in exfat_get_block()—a function not
even present in the panic call trace.

This bug was later assigned CVE-2025-22036
(https://lore.kernel.org/all/2025041658-CVE-2025-22036-6469@gregkh/).
The vulnerability was introduced in commit 11a347fb6cef (March 13, 2023)
and fixed in commit 1bb7ff4204b6 (March 21, 2025)—persisting for 739
days. Notably, my reproduction scenario differed significantly from that
described in the CVE report, highlighting how these bugs manifest
unpredictably across different workloads.

This experience revealed how notoriously difficult stack corruption bugs
are to debug: KASAN cannot reproduce them, call traces are misleading,
and the actual culprit often lies outside the visible call chain. Manual
instrumentation with hardware breakpoints and filters was effective but
extremely time-consuming.

This motivated KStackWatch: automating the debugging workflow I manually
performed, making hardware breakpoint-based stack monitoring readily
available to all kernel developers facing similar issues.

KStackWatch is a lightweight debugging tool to detect kernel stack
corruption in real time. It installs a hardware breakpoint (watchpoint)
at a function's specified offset using kprobe.post_handler and removes
it in fprobe.exit_handler. This covers the full execution window and
reports corruption immediately with time, location, and a call stack.

Beyond automating proven debugging workflows, KStackWatch incorporates
robust engineering to handle complex scenarios like context switches,
recursion, and concurrent execution, making it suitable for broad
debugging use cases.

## Key Features

* Immediate and precise stack corruption detection
* Support for multiple concurrent watchpoints with configurable limits
* Lockless design, usable in any context
* Depth filter for recursive calls
* Low overhead of memory and CPU
* Flexible debugfs configuration with key=val syntax
* Architecture support: x86_64 and arm64
* Auto-canary detection to simplify configuration

## Architecture Support

KStackWatch currently supports x86_64 and arm64. The design is
architecture-agnostic, requiring only:
* Hardware breakpoint modification in atomic context

Arm64 support required only ~20 lines of code(patch 18,19). Future ports
to other architectures (e.g., riscv) should be straightforward for
developers familiar with their hardware breakpoint implementations.

## Performance Impact

Runtime overhead was measured on Intel Core Ultra 5 125H @ 3 GHz running
kernel 6.17, using test4 from patch 24:

     Type                 |   Time (ns)  |  Cycles
     -----------------------------------------------
     entry with watch     |     10892    |   32620
     entry without watch  |       159    |     466
     exit  with watch     |     12541    |   37556
     exit  without watch  |       124    |     369

Comparation with other scenarios:

Mode                        |  CPU Overhead (add)  |  Memory Overhead (add)
----------------------------+----------------------+-------------------------
Compiled but not enabled    |  None                |  ~20 B per task
Enabled, no function hit    |  None                |  ~few hundred B
Func hit, HWBP not toggled  |  ~140 ns per call    |  None
Func hit, HWBP toggled      |  ~11–12 µs per call  |  None

The overhead is minimal, making KStackWatch suitable for production
environments where stack corruption is suspected but kernel rebuilds are not feasible.

## Validation

To validate the approach, this series includes a self-contained test module and
a companion shell script. The module provides several test cases covering
scenarios such as canary overflow, recursive depth tracking, multi-threaded
silent corruption, retaddr overwriten. A detailed workflow example and usage
guide are provided in the documentation (patch 26).

While KStackWatch itself is a new tool and has not yet discovered production
bugs, it automates the exact methodology that I used to manually uncover
CVE-2025-22036. The tool is designed to make this powerful debugging technique
readily available to kernel developers, enabling them to efficiently detect and
diagnose similar stack corruption issues in the future.

---
Patches 1–3 of this series are also used in the wprobe work proposed by
Masami Hiramatsu, so there may be some overlap between our patches.
Patch 3 comes directly from Masami Hiramatsu (thanks).
---

Changelog:
v8:
* Add arm64 support
  * Implement hwbp_reinstall() for arm64.
  * Use single-step mode as default in ksw_watch_handler().
* Add latency measurements for probe handlers.
* Update configuration options
  * Introduce explicit auto_canary parameter.
  * Default watch_len to sizeof(unsigned long) when zero.
  * Replace panic_on_catch with panic_hit ksw_config option.
* Enable KStackWatch in non-debug builds.
* Limit canary search range to the current stack frame when possible.
* Add automatic architecture detection for test parameters.
* Move kstackwatch.h to include/linux/.
* Relocate Kconfig fragments to the kstackwatch/ directory.

v7:
  https://lore.kernel.org/all/20251009105650.168917-1-wangjinchao600@gmail.com/
  * Fix maintainer entry to alphabetical position

v6:
  https://lore.kernel.org/all/20250930024402.1043776-1-wangjinchao600@gmail.com/
  * Replace procfs with debugfs interface
  * Fix typos

v5:
  https://lore.kernel.org/all/20250924115124.194940-1-wangjinchao600@gmail.com/
  * Support key=value input format
  * Support multiple watchpoints
  * Support watching instruction inside loop
  * Support recursion depth tracking with generation
  * Ignore triggers from fprobe trampoline
  * Split watch_on into watch_get and watch_on to fail fast
  * Handle ksw_stack_prepare_watch error
  * Rewrite silent corruption test
  * Add multiple watchpoints test
  * Add an example in documentation

v4:
  https://lore.kernel.org/all/20250912101145.465708-1-wangjinchao600@gmail.com/
  * Solve the lockdep issues with:
    * per-task KStackWatch context to track depth
    * atomic flag to protect watched_addr
  * Use refactored version of arch_reinstall_hw_breakpoint

v3:
  https://lore.kernel.org/all/20250910052335.1151048-1-wangjinchao600@gmail.com/
  * Use modify_wide_hw_breakpoint_local() (from Masami)
  * Add atomic flag to restrict /proc/kstackwatch to a single opener
  * Protect stack probe with an atomic PID flag
  * Handle CPU hotplug for watchpoints
  * Add preempt_disable/enable in ksw_watch_on_local_cpu()
  * Introduce const struct ksw_config *ksw_get_config(void) and use it
  * Switch to global watch_attr, remove struct watch_info
  * Validate local_var_len in parser()
  * Handle case when canary is not found
  * Use dump_stack() instead of show_regs() to allow module build
  * Reduce logging and comments
  * Format logs with KBUILD_MODNAME
  * Remove unused headers
  * Add new document

v2:
  https://lore.kernel.org/all/20250904002126.1514566-1-wangjinchao600@gmail.com/
  * Make hardware breakpoint and stack operations
    architecture-independent.

v1:
  https://lore.kernel.org/all/20250828073311.1116593-1-wangjinchao600@gmail.com/
  * Replaced kretprobe with fprobe for function exit hooking, as
    suggested by Masami Hiramatsu
  * Introduced per-task depth logic to track recursion across scheduling
  * Removed the use of workqueue for a more efficient corruption check
  * Reordered patches for better logical flow
  * Simplified and improved commit messages throughout the series
  * Removed initial archcheck which should be improved later
  * Replaced the multiple-thread test with silent corruption test
  * Split self-tests into a separate patch to improve clarity.
  * Added a new entry for KStackWatch to the MAINTAINERS file.
---

Jinchao Wang (26):
  x86/hw_breakpoint: Unify breakpoint install/uninstall
  x86/hw_breakpoint: Add arch_reinstall_hw_breakpoint
  mm/ksw: add build system support
  mm/ksw: add ksw_config struct and parser
  mm/ksw: add singleton debugfs interface
  mm/ksw: add HWBP pre-allocation
  mm/ksw: Add atomic watchpoint management api
  mm/ksw: ignore false positives from exit trampolines
  mm/ksw: support CPU hotplug
  sched/ksw: add per-task context
  mm/ksw: add entry kprobe and exit fprobe management
  mm/ksw: add per-task ctx tracking
  mm/ksw: resolve stack watch addr and len
  mm/ksw: limit canary search to current stack frame
  mm/ksw: manage probe and HWBP lifecycle via procfs
  mm/ksw: add KSTACKWATCH_PROFILING to measure probe cost
  arm64/hw_breakpoint: Add arch_reinstall_hw_breakpoint
  arm64/hwbp/ksw: integrate KStackWatch handler support
  mm/ksw: add self-debug helpers
  mm/ksw: add test module
  mm/ksw: add stack overflow test
  mm/ksw: add recursive depth test
  mm/ksw: add multi-thread corruption test cases
  tools/ksw: add arch-specific test script
  docs: add KStackWatch document
  MAINTAINERS: add entry for KStackWatch

Masami Hiramatsu (Google) (1):
  HWBP: Add modify_wide_hw_breakpoint_local() API

 Documentation/dev-tools/index.rst       |   1 +
 Documentation/dev-tools/kstackwatch.rst | 377 +++++++++++++++++++++
 MAINTAINERS                             |   9 +
 arch/Kconfig                            |  10 +
 arch/arm64/Kconfig                      |   1 +
 arch/arm64/include/asm/hw_breakpoint.h  |   1 +
 arch/arm64/kernel/hw_breakpoint.c       |  12 +
 arch/x86/Kconfig                        |   1 +
 arch/x86/include/asm/hw_breakpoint.h    |   8 +
 arch/x86/kernel/hw_breakpoint.c         | 148 +++++----
 include/linux/hw_breakpoint.h           |   6 +
 include/linux/kstackwatch.h             |  68 ++++
 include/linux/kstackwatch_types.h       |  14 +
 include/linux/sched.h                   |   5 +
 kernel/events/hw_breakpoint.c           |  37 +++
 mm/Kconfig                              |   1 +
 mm/Makefile                             |   1 +
 mm/kstackwatch/Kconfig                  |  34 ++
 mm/kstackwatch/Makefile                 |   8 +
 mm/kstackwatch/kernel.c                 | 295 +++++++++++++++++
 mm/kstackwatch/stack.c                  | 416 ++++++++++++++++++++++++
 mm/kstackwatch/test.c                   | 345 ++++++++++++++++++++
 mm/kstackwatch/watch.c                  | 309 ++++++++++++++++++
 tools/kstackwatch/kstackwatch_test.sh   |  85 +++++
 24 files changed, 2130 insertions(+), 62 deletions(-)
 create mode 100644 Documentation/dev-tools/kstackwatch.rst
 create mode 100644 include/linux/kstackwatch.h
 create mode 100644 include/linux/kstackwatch_types.h
 create mode 100644 mm/kstackwatch/Kconfig
 create mode 100644 mm/kstackwatch/Makefile
 create mode 100644 mm/kstackwatch/kernel.c
 create mode 100644 mm/kstackwatch/stack.c
 create mode 100644 mm/kstackwatch/test.c
 create mode 100644 mm/kstackwatch/watch.c
 create mode 100755 tools/kstackwatch/kstackwatch_test.sh

-* 
2.43.0


