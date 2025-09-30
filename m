Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4501FCAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 02:44:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 387748E0005; Mon, 29 Sep 2025 22:44:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35F8C8E0002; Mon, 29 Sep 2025 22:44:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24D5F8E0005; Mon, 29 Sep 2025 22:44:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0EE958E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:44:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 65E6D1DEF7A
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:44:20 +0000 (UTC)
X-FDA: 83944372680.12.9FE8C23
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf02.hostedemail.com (Postfix) with ESMTP id 93CBF80008
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:44:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VnduohAF;
	spf=pass (imf02.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759200258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oBLHnI+e6tAOqeHvXlDdht1mTbtW+pSP4ewzl28Opg0=;
	b=lxOXWXlJicvrIK3DQColRZF0ibRkSWrbidf33JnQ+YCI2VeVS0rmT4YD5CMO1uQcBcYG5J
	UHvLScpyMoOz/5aXutqImOLHYByf2pfXelu/0GGRl0OmoGSaD/5AsGOWJ0jwllGyEmIyrl
	JW13mxfsVi3pWwpTuh9ISlRumBwvnmo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VnduohAF;
	spf=pass (imf02.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759200258; a=rsa-sha256;
	cv=none;
	b=PnNVqJu5D4BiXtJvMKJUqoJAXw/5EAbewDv45eh+BDYeSnHJdzm00WnDOIJ4jOi+u8FqJU
	ju5gr6+u9xhhNYL7i+k0xFEZj6fMpIJu/pi7tj30zXxEMS6w/8KA+jTxPNarxHrwUJUCEd
	wXG+QOpB/1YffHuD5ik7WV7rOQvvh+o=
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b553412a19bso3820721a12.1
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 19:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759200257; x=1759805057; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oBLHnI+e6tAOqeHvXlDdht1mTbtW+pSP4ewzl28Opg0=;
        b=VnduohAF9j9FrWJEDc3qPshGlpsi4dOZiI1T071TLdepNjJxaPAu8tVDNXrlIr6vEn
         blh4eGRcpVobY7FfPUu+QTYVUq3jfXi7fWu0tjYA2E6fIgB01Uu6hq2E9Tzd7VfvDdVt
         JCQEyxYIyS3TAzS11eSY2z4KKCwJBcWc7/vM+hlpP0ABxJtAQ4PLGuyCI3sOlG8DWXGB
         ufWPLLruSnmg79S7TWJIE5TcAKOluy2BYXfqBN6F4H3yL9psgzdp2h3Q7QuM3yQwZBCO
         vQq6Uw8ZJQ5XhiXw+y8Dsk+78wFyXhPwkZHL5pczEbudZ8E3Knunh1uPNZVWcmCHHWP/
         XkjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759200257; x=1759805057;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oBLHnI+e6tAOqeHvXlDdht1mTbtW+pSP4ewzl28Opg0=;
        b=WpTP2mz73mrhxOviB1axUMfogYnsNQWCmtA9QUtGCTgnAN/dw8rfpyBT9MpuCKWhWb
         ujebsCVxrI9tfc+ZttH8HfVUVMTjhs6/+dwcmYHzMupIFDYlgf+zo2kbKQwbrmWfKUCa
         M14oUw/lGSUCVuXOJ4ZuRlwztSaCFulhwUZT386ki5eYu1epDXQgkoISq4nc2al0VKiI
         sExFX5XwFyqVuMXWKNe6A0vaGEcn0KBdV9sHPGhw355gs4KuYd+fo6dheenSlm4t5zvk
         bpo9NDTGG4Q+cKMLaSstozXrbK3W2hQnjlHEdiZh/tNi+GADacavGv9iFNTV7QrSf/u6
         bXZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbskY8inBYlCmg1bTmdDG4ORmF0AGHS4GB5WEaMqUS499W3mlOKp0NumclO/TuNO9c1u6l020Hag==@kvack.org
X-Gm-Message-State: AOJu0Yw+ajX22o69pIUEOWMhgKBNSbB8mboR55Vsh/Om9rG1Lamrz09B
	Lv6A8aE0ltzqkx5F6nSOFq8tY2fEwA+Vyfl6jNPdRiG8BN1+8BBe0jbL
X-Gm-Gg: ASbGncvI51Sn4rlpw0jkfl88wii1q871FU+Dzz6iHo/VQHbbhG5vDuEc8Q2BLRCXxXH
	3sRJmomw9eMn48no+98fxZIw98q3/gpg7YPeXPMdz78a+k15JoH7T9UJlqpj2Jj0LUXJVBnwUJ1
	sh95lgBQjQKnkHyWm2a9vW0yPVCqK/OzPrtOoFbspLPJXvqO+9X8Qwwyy9yV/phjw2GSyCX8Jld
	4N2WU3c7kWfha2iZZUuYP5LyOeJGjB/znj5vbpzuZAyxPckHJN0k3L1lwmvh+w06fIq0XUwwYX3
	bjVyluRLXVDK0WI7YGpw0G9Z91eLRj/Jg62AOEYGS0QxoTDdc7X6BRXfihJePUoxsqz7l9ZQbk7
	bivqmA0szGpNf2VPi2jABe/71DqV7zOFBczm5NqajNvkHMFbAXvAlQr7EpKxWEgs4c3zliZa2zx
	FK
X-Google-Smtp-Source: AGHT+IHr+eKlqahlH64ABrOo26g2DZtu5RbBsAa8n+SzXkmpJPz4gPjilw094eEXW9CbsMYgjx7Ytw==
X-Received: by 2002:a17:902:c409:b0:275:f156:965c with SMTP id d9443c01a7336-27ed4ade26bmr209883395ad.52.1759200257156;
        Mon, 29 Sep 2025 19:44:17 -0700 (PDT)
Received: from localhost ([45.142.167.196])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66d3acfsm146037925ad.20.2025.09.29.19.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 19:44:16 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Marco Elver <elver@google.com>,
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
Subject: [PATCH v6 00/23] mm/ksw: Introduce real-time KStackWatch debugging tool
Date: Tue, 30 Sep 2025 10:43:21 +0800
Message-ID: <20250930024402.1043776-1-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 93CBF80008
X-Stat-Signature: 8xde1h8ukxagb5zww71zm8zk7ybi7hfu
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759200258-497901
X-HE-Meta: U2FsdGVkX1/Xp3YBbKrMjChnK0wHIVjRRpaudVYn7aQS412G4okxxXXA2BUDGxCFdqam7Ak2w3DwK6osMXiPvbh2ZgCgxLHy1BeSkjCsSWeOmgRD+iyh0XDVxlCGJ2dTVXkCCzAFVzm/cWfdsNiEX48+C6DYg3GnWkSIhivmRWehbUKoqrYt2xBBqqXjzp5aFcx15uYUQpyuBXxsQKKFS7Pv+13r73bzAYg5P3V/DjUtosIV3bGzy2Ht/Q8Jcv6gyB1zEoopyBqWczTqJbtkXifhv4Y3oz50vM/bwjRzpQn/mzMNKis5ImPTzRA+dzz1sPdgU1WpFxnC7Ce55dmUpqQ4iHxzcDRQPM8T/lFrreo1fo0NB03F0nxLVZ/A4t3i+nNqawJSDblFmLd49TwEEwi2kUMAdoWYNso6jzznrsWtqBog8Qrlts9DhMmLcrkTHoJABXw4uYtURGpNvCrKBUX5vGpMlRxiVCVe5/CqrILgjKhu7p5AsPJUchZhJK/NYkkIIWqbGHqWe19ijk3+Ev1xGdiGu7ORKcgZ/xUOfigXqB+IXx/XWQEO5iFXkIlid3+Nk4FprH9fRxTejPaAuFD9nqXu3OIOssa7YsJXH09+r1nyq8kdxNJ4W3m47mdGIIEQziZmMAhjjrRl2uEYWDIvWUrcIAGYrpO7r4V/HbFKMVGocGBACIsyugkbEqaZ8rL/R3EDxMK9l1t/UXiQtWtgrZMXJSzL1bvScfK6z1nItkCdt5AZYt0eNXR/EQ6uMbCShjevW9odUA9rFTJ/ZTDDReWrtUzjUnJfvWkZ01URvCot6oeOm7QBe0Y1pigKST09Ej+UyrRauiHLtGTqXtPPxf/Wo6mm7l1dhmN15CHlgmOxOXN6W+OV/lWiBvpXdHrJ1XFJggpmQwSM1ribwkT+cMDuADg11yFuQLvzYp/Fngz1sVhVSUmmmfFg2n3z31/KFlR4nLS50IV4Ryh
 qbz+TzPM
 F6IDJoApmQgupG+dEIzoIu66bTL8q59VHm8jaDBQZ+wRYWrL8QakYoqXusMvc7Zr9Ibsuv/FI27NCwitD7W2K97OIqHY3piKlTEjMAMMaR7i677Y/4bx0T1iwvstKpLvLQyvUbl9HJkR6RW3U2V+Mz29t2209INcJFTpzCiUK/y6ON/bS6L8ORK3JXiStknoQaREHjvYCdjRlcZBAenN57B75MKTisHWeS+wMfpevYVf6uTXB+ascFeuiYHT+eobdG1M5gSV3G6s4d9+DArXMZF7ZYRzauq5gXYbSWStbwfP3y3JMLeg/Ox4zje4k3sEUwuM9hjolcfPQofqqardUHdld9OGrJev8fbIAtrQRGGMUMjRwIa8QPadOxTPxfjZh6+5ualq3N8lMQiLpnz7CTuF8G4w+eLBI04L2zIRU20aWFtFI+jfc6bFqTJvSY6DzkPibyyRSL+MR6BGDFR11DkfCy+GYvgkYF1Vt0SdgXHfn43T3gQOwzmp+ctdGFFimFQIBzaoOBUTW+f48ixeqTE4J0CG56FSLyIMqr4hn7evM6IzyV5n4IkRy78bsGtfw73yH6Bd6jXOgmAlPqKhy5E6XS/+FUhVJVXqb2960mJDBwmQcv/Mrpx2Rnw==
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

V6:
  * Replace procfs with debugfs interface
  * Fix typos

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
  mm/ksw: add singleton debugfs interface
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
 Documentation/dev-tools/kstackwatch.rst | 314 ++++++++++++++++++++++
 MAINTAINERS                             |   8 +
 arch/Kconfig                            |  10 +
 arch/x86/Kconfig                        |   1 +
 arch/x86/include/asm/hw_breakpoint.h    |   8 +
 arch/x86/kernel/hw_breakpoint.c         | 148 +++++-----
 include/linux/hw_breakpoint.h           |   6 +
 include/linux/kstackwatch_types.h       |  14 +
 include/linux/sched.h                   |   5 +
 kernel/events/hw_breakpoint.c           |  37 +++
 mm/Kconfig.debug                        |  18 ++
 mm/Makefile                             |   1 +
 mm/kstackwatch/Makefile                 |   8 +
 mm/kstackwatch/kernel.c                 | 292 ++++++++++++++++++++
 mm/kstackwatch/kstackwatch.h            |  60 +++++
 mm/kstackwatch/stack.c                  | 240 +++++++++++++++++
 mm/kstackwatch/test.c                   | 343 ++++++++++++++++++++++++
 mm/kstackwatch/watch.c                  | 305 +++++++++++++++++++++
 tools/kstackwatch/kstackwatch_test.sh   |  52 ++++
 20 files changed, 1809 insertions(+), 62 deletions(-)
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


