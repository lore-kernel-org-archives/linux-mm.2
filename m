Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1568CAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 11:51:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4893A8E0008; Wed, 24 Sep 2025 07:51:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 460D38E0001; Wed, 24 Sep 2025 07:51:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34F1C8E0008; Wed, 24 Sep 2025 07:51:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E3008E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 07:51:38 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BFFB411ABAC
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:51:37 +0000 (UTC)
X-FDA: 83923979034.08.44500E6
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id 192134000C
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:51:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Oi2g0dUS;
	spf=pass (imf27.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758714696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IkFW7ZSlDKq/LZM+zK73rBzgP1/UKF25L/8hqnEAXa4=;
	b=MizZqc8sNTntKAF1ass68Vbyd+sypBhmBBxnQ69TAxNccFqew0iN1PD4bxf0dQpa5mntzi
	sMcoLz84kPRqvUprXj1JRRDtNbiauC/AO2rUsG99EQ4Wc+MQG1Y8bZjPIIxEenDSVzUj6Q
	15lrOk5O3VRL27tRDo8Jc+UpWChtfHk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758714696; a=rsa-sha256;
	cv=none;
	b=CSiYnCrEH4qzDOEpvP9swU3J4Cchvw73DjHz74TTfu0ioqb/+wtYF2mDXcg2ENXcEGplew
	Zfe4tHpOem8zhdzDXfx0Bh1vxBFrHt1Ik1LYAu5odUPZRUEN1toQfTAUX+hERfMf1u30ps
	wujPA4uWDdQ4cMCStXBLYkUrNYcvYSQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Oi2g0dUS;
	spf=pass (imf27.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-25669596921so71878035ad.1
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 04:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758714695; x=1759319495; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IkFW7ZSlDKq/LZM+zK73rBzgP1/UKF25L/8hqnEAXa4=;
        b=Oi2g0dUSCw08Ka44Yq2ToFIYNJNQMp3W82TvJHShcge8nO1ncefMGLwGj3gcOZDvHo
         A6xqKUY+OmpbF1BZXtlORo6/n2AvoPrnG5uCkU/CepMU51YMm3PaNmZGjxrtPLW/s2b6
         aWjKTU1+nM++hLQjlsnu0lxJgO7owBfpBCrxbGuziRHFfi9Z22MNIRPASNgMJsxmFakz
         +wqjcMS7ZkLVA2CdrhtCxgv9xGEYsdtlcMJtn81E/dC3ZTKuDjepn9oUdAt0EJmxPtch
         4OMwjRyUe2EBbI3vsT6kfpdBu1SOjiAV21vK7CD+f49eC7DAC2zRXGN/Tq39F6EZCT46
         H7cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758714695; x=1759319495;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IkFW7ZSlDKq/LZM+zK73rBzgP1/UKF25L/8hqnEAXa4=;
        b=FkejqWqcOBl5JklZPdP+blQwMZh6QY4QyoVE4s8TGYf42jai5RCv+B7ocXcLqTznUl
         Wo/6tRrgXg4AksSVmIMYkidwQDskNcua6PxXWlCyaSxz7lYWf6X9i6L3M0D9I55TfGTf
         8HZjqwTZsBkJMriTEFPdHul22Pu2Kv8r+IlFji8FnPikpWt/7SGKPT7jJarkaO+C4pMI
         5YqXvQMqqzMg1i9IwfgLiFAk2XcUhRMRkNZv0EGaC1o17oK5MXSvu85TyUQvz3KZLXB4
         4u3TUfs6jmYojgDyHNoVZX/E85FKs4+IP7pDgCwkTr2XupK63Cz4emlFfv5nLc6f74pu
         N7UQ==
X-Forwarded-Encrypted: i=1; AJvYcCWpYAm1Uz3QSB/+lvOT1C8cgHmWrBMn0Wzk9BqK0uuHC5m2qX7WiEP1353fQfoay1S63hwk9uZ7jQ==@kvack.org
X-Gm-Message-State: AOJu0Yxylc0PpODszhGX60orjS+8TXL7Wss/9Zbb3H6Fg8LmBqw5zuha
	dp6ThV3vmW8isO1GymnBcniL0htWpXDoS36NhGrELvRvechVf5Gxiu83
X-Gm-Gg: ASbGncuArhkaqChJPq+8ac9fR6yxk44p2ENL1PbT4sGqt5Mpm4t1GsGUyKDLX4D2HI5
	pYcqxoUWlPmX5CErZTglc1tznNvUWuabuJSifmTQ4iOwUBxXFwSZttH/OUe+Q0i6vYwytrVlpkF
	rXXI9//WaRSl2yxinmDvIvjUJc3EBJlozaR0IS4QYAMwojjUZUM9sq1VWEd+k4f4wVrkc6A340Q
	UVoktZ1Cm6Mj3TDeASY2sqht33zhmtppQxxWUY1Rui+NnV/H3E42WcxJpPXlrGkuAue37A/QfMb
	NWvVN6j7b8ZPPLBa7iSDU4iaQUY4427Zqmh2uJdIWZBZMUuWsLorXAED5pbnru5skV7zs+iZr5j
	N1A6SIuTwUlSzChte+XSlFBAcBw==
X-Google-Smtp-Source: AGHT+IFpw5g/nyg0mjoFnafm0OORRDCd2mc5ondqV3KNE7Z5tP/VaQRZBOA+j3BmtPgUBBTfxZ4Mhg==
X-Received: by 2002:a17:903:3586:b0:240:9dd8:219b with SMTP id d9443c01a7336-27cc61bd32dmr78200575ad.49.1758714694622;
        Wed, 24 Sep 2025 04:51:34 -0700 (PDT)
Received: from localhost ([23.142.224.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-269802fe096sm189570425ad.104.2025.09.24.04.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 04:51:34 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Kees Cook <kees@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Rong Xu <xur@google.com>,
	Naveen N Rao <naveen@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Nam Cao <namcao@linutronix.de>,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	kasan-dev@googlegroups.com,
	"David S. Miller" <davem@davemloft.net>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-trace-kernel@vger.kernel.org
Cc: Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH v5 00/23] mm/ksw: Introduce real-time KStackWatch debugging tool
Date: Wed, 24 Sep 2025 19:50:43 +0800
Message-ID: <20250924115124.194940-1-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 192134000C
X-Stat-Signature: iwitbrwb1crcu873q8owg8bgzfshitag
X-Rspam-User: 
X-HE-Tag: 1758714695-287501
X-HE-Meta: U2FsdGVkX19PVEfCUGlbk05h9Z0KatkPXKGq8t0FCi6AZWddqI0Dn459e+AXEroe2tjTKx0AQDDIXvEkvhdFg1wioa2JIjo05T2H8npZLhxyHXO/Co8bB8ohsp3EEAucqvSzQcSvmMdrHHC4PLuQyPX8quTskp17+dxw6H7gxJRn6hQ3qHiJ4ugSNvijW4VRHqmt+1tsbwtiPXBQBH2s0x/9VxdCL6sY+3a60dNdgPim8XndXTG+cheRw57x/Iv4ZVaPiEcH1y7xAgK/NhrXWry/qud8hhqkb2IEmUUQMw/+AOL17x0sjeIwoZrSXdW22bCLmKets3pLal7+x1f7NMktEJHUWXKpDr6UHsFv/5N6wEmXAFppjq/Qqrpp1E6RoSkYvixlrpbaUT7NymQbmye4Em0hcYdIwQK0qBScgQx8V+zGVRER7OD270+tNL3xFU4D5vA0CnKyScS5HT2STtkuuyd5kLO11d5awfOtypSTP8XingWr9zXG2Kqwl1TCugp3WHO8PuBZ6PRqXbuxALUv3X2lHZeTr9Q3WlGsbYZwV+uYxo2zB7aRFKsBDZSf3j8UxaRmEWCJW02LNcz9K+G7bO+XRPBUYhu8KFOVn2bCQRXQ5ozc1Zi5KkO3Yo+xat+BmDzPQ44MKrJFSfFymPVkLCvOQ61YoUg6f91Nsir+WsJbDbdjlFP6zSXFvR05nOOs+KiUOUm4ChniUm/arL0Bs4Utwfp4w0C3wLR016L5zlEIxFupxTHxDylNxm8cSuxkBe6iTHz6G9YGFaX4v0rr6ariLgnuFdxXk2h3h9lJmNrWyMT8E/Y+DFBE1dgvrUAEcKIf/WaNExpaMnhQCdowHVAouSqho76lC/Y9hh1MLwEMukBwe+bZEDgfU2Q2AITODNfrUR9qniEiGJFHr6rX11GmDLVPQ0QI2Ytqu7P2LdGbymptRPJdxfKquwuNYUqLJcuYG++xhiFH0n5
 GAt1vwOp
 RJknogS62Ph1C4U3IuTx9BMBhzv+HocwQCDN4pAgZakpq7/3KwXm7DM3rgXl0uvh27/MhSgsZbq8/KTy77dnvh3UTSVF+5QcjWLtZDdqLxxYyxkqGAs2+FQ3G8XTPPrbyp5MdRcLX8E+xEvQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series introduces KStackWatch, a lightweight debugging tool to detect
kernel stack corruption in real time. It installs a hardware breakpoint
(watchpoint) at a function's specified offset using `kprobe.post_handler` and
removes it in `fprobe.exit_handler`. This covers the full execution window and
reports corruption immediately with time, location, and a call stack.

The motivation comes from scenarios where corruption occurs silently in one
function but manifests later in another, without a direct call trace linking
the two. Such bugs are often extremely hard to debug with existing tools.
These scenarios are demonstrated in test 3–5 (silent corruption test, patch 20).

Key features include:

* Immediate and precise corruption detection
* Support multiple watchpoints for concurrently called functions
* Lockless design, usable in any context
* Depth filter for recursive calls
* Minimal impact on reproducibility
* Flexible procfs configuration with key=val syntax

To validate the approach, the patch includes a test module and a test script.

There is a workflow example described in detail in the documentation (patch 22).
Please read the document first if you want an overview.

---
  Patches 1–3 of this series are also used in the wprobe work proposed by
  Masami Hiramatsu, so there may be some overlap between our patches.
  Patch 3 comes directly from Masami Hiramatsu (thanks).
---
Changelog

V5:
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

V4:
  https://lore.kernel.org/all/20250912101145.465708-1-wangjinchao600@gmail.com/
  * Solve the lockdep issues with:
    * per-task KStackWatch context to track depth
    * atomic flag to protect watched_addr
  * Use refactored version of arch_reinstall_hw_breakpoint

V3:
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

V2:
  https://lore.kernel.org/all/20250904002126.1514566-1-wangjinchao600@gmail.com/
  * Make hardware breakpoint and stack operations architecture-independent.

V1:
  https://lore.kernel.org/all/20250828073311.1116593-1-wangjinchao600@gmail.com/
  * Replaced kretprobe with fprobe for function exit hooking, as suggested
    by Masami Hiramatsu
  * Introduced per-task depth logic to track recursion across scheduling
  * Removed the use of workqueue for a more efficient corruption check
  * Reordered patches for better logical flow
  * Simplified and improved commit messages throughout the series
  * Removed initial archcheck which should be improved later
  * Replaced the multiple-thread test with silent corruption test
  * Split self-tests into a separate patch to improve clarity.
  * Added a new entry for KStackWatch to the MAINTAINERS file.

RFC:
  https://lore.kernel.org/lkml/20250818122720.434981-1-wangjinchao600@gmail.com/

---

The series is structured as follows:

Jinchao Wang (22):
  x86/hw_breakpoint: Unify breakpoint install/uninstall
  x86/hw_breakpoint: Add arch_reinstall_hw_breakpoint
  mm/ksw: add build system support
  mm/ksw: add ksw_config struct and parser
  mm/ksw: add singleton /proc/kstackwatch interface
  mm/ksw: add HWBP pre-allocation
  mm/ksw: Add atomic watchpoint management api
  mm/ksw: ignore false positives from exit trampolines
  mm/ksw: support CPU hotplug
  sched: add per-task context
  mm/ksw: add entry kprobe and exit fprobe management
  mm/ksw: add per-task ctx tracking
  mm/ksw: resolve stack watch addr and len
  mm/ksw: manage probe and HWBP lifecycle via procfs
  mm/ksw: add self-debug helpers
  mm/ksw: add test module
  mm/ksw: add stack overflow test
  mm/ksw: add recursive depth test
  mm/ksw: add multi-thread corruption test cases
  tools/ksw: add test script
  docs: add KStackWatch document
  MAINTAINERS: add entry for KStackWatch

Masami Hiramatsu (Google) (1):
  HWBP: Add modify_wide_hw_breakpoint_local() API

 Documentation/dev-tools/index.rst       |   1 +
 Documentation/dev-tools/kstackwatch.rst | 316 ++++++++++++++++++++++
 MAINTAINERS                             |   8 +
 arch/Kconfig                            |  10 +
 arch/x86/Kconfig                        |   1 +
 arch/x86/include/asm/hw_breakpoint.h    |   8 +
 arch/x86/kernel/hw_breakpoint.c         | 148 ++++++-----
 include/linux/hw_breakpoint.h           |   6 +
 include/linux/kstackwatch_types.h       |  14 +
 include/linux/sched.h                   |   5 +
 kernel/events/hw_breakpoint.c           |  37 +++
 mm/Kconfig.debug                        |  18 ++
 mm/Makefile                             |   1 +
 mm/kstackwatch/Makefile                 |   8 +
 mm/kstackwatch/kernel.c                 | 263 +++++++++++++++++++
 mm/kstackwatch/kstackwatch.h            |  58 +++++
 mm/kstackwatch/stack.c                  | 240 +++++++++++++++++
 mm/kstackwatch/test.c                   | 332 ++++++++++++++++++++++++
 mm/kstackwatch/watch.c                  | 305 ++++++++++++++++++++++
 tools/kstackwatch/kstackwatch_test.sh   |  52 ++++
 20 files changed, 1769 insertions(+), 62 deletions(-)
 create mode 100644 Documentation/dev-tools/kstackwatch.rst
 create mode 100644 include/linux/kstackwatch_types.h
 create mode 100644 mm/kstackwatch/Makefile
 create mode 100644 mm/kstackwatch/kernel.c
 create mode 100644 mm/kstackwatch/kstackwatch.h
 create mode 100644 mm/kstackwatch/stack.c
 create mode 100644 mm/kstackwatch/test.c
 create mode 100644 mm/kstackwatch/watch.c
 create mode 100755 tools/kstackwatch/kstackwatch_test.sh

-- 
2.43.0


