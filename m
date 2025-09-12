Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DBFDCAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 10:12:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC45E8E000D; Fri, 12 Sep 2025 06:12:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9BAD8E0005; Fri, 12 Sep 2025 06:12:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98A808E000D; Fri, 12 Sep 2025 06:12:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 87DA28E0005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:12:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 381A785694
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:12:01 +0000 (UTC)
X-FDA: 83880182442.19.0C1CEC6
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id 56E29120006
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:11:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TiuT0A2I;
	spf=pass (imf29.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757671919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=a0RAur8Marng0nhbSNOQRJYXrBS2GdOE60OklyU/Dxo=;
	b=I4e2dHvKhWOTb3xN5atrWx2P7nluKMH3I6y8f2hzPhS9kz+xTiAMRYUi+BFFX1WY0EZbHf
	M+/j1ttrcnYth3m0dEYvnyzBcMYGs5ZtX8wekuTWckbYircx0T4RP1FSYUdwLfPw8hJh3h
	b2TAl2bdeysbXA34N6tnydTLv3ul6EI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757671919; a=rsa-sha256;
	cv=none;
	b=ao5Sa0Ov2i1NcvYFYokepr3GZ0Kl61vuwzUzHXVFUyJEbxzkhPpProHMlg09pTEFsau8iq
	lHkWlOja1XqGuXdhsaAd3mXCanJd07wpbEloEvivdXTJrzOsYXDFhWe1Et0HllpVg7qvZL
	AaTFZZsIjtud5Wjkhr6dumGyJoUrdMQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TiuT0A2I;
	spf=pass (imf29.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-77251d7cca6so1706802b3a.3
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757671918; x=1758276718; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=a0RAur8Marng0nhbSNOQRJYXrBS2GdOE60OklyU/Dxo=;
        b=TiuT0A2IlryU95is9GDfw3GCIgqZB4vDTZl7Dr3EV6Tq4oc5xgTjnkLJsqaKPiPOVc
         0YCcm4w/2G9fyXfnDJeoaceL5WckPiugsiP0Ff/IGQcbnOv5y3iL4w98B4fricU56wvJ
         UblMtt9iJvaAA+V3793h5qsZHNoyOfPNT5Ho31wArqwDNbInB0FwVb4BGemObLz43/o7
         zjg3/GpAfnbKy27ZXD0gRuDFlI3Mqd5InC5oHtRDYigZqVOljHtPvKR2wxS+Zn70Zvhw
         y1EAlCmsPR4O0Qtgw4uL6ln3p8vYP+pgpEr8l3JuBvmhPz/NitTSWIwjC5bZKTIlYkBW
         vC+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757671918; x=1758276718;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a0RAur8Marng0nhbSNOQRJYXrBS2GdOE60OklyU/Dxo=;
        b=TVxfVk0erJAK03kTi0lxka7qnq9OLE/NJBg2/+D1dUgG8xdhf+Tt3V9ZYeOfStmF+R
         MiLp68DLXSGILhi4473yiC5HJEwDW3GZdHVqsCDzrcXrpXy7wEPp6UTVwO8MFxuaHPWs
         G/nJa73BLYnKtlB1Hp0nQ7LLtXYxKaVR2FDd0WmBjalbwvC3whny/UHWegEhw3646t3V
         xPiZ9WTiGfFfrmutbF4F7PPMLRSYSNzvsHKhjqPJiKSdx+tHlbscvCHaPLy59XjVp2uY
         Zo7EhBQNNJplI7eyCgC3n2CBOU7qHNyoVB01OER7dGRPeU/tCKxoRuhucAZhbt/AWk0m
         Tk9w==
X-Forwarded-Encrypted: i=1; AJvYcCUpz6oWMdAJgWU8AF5xWWuDH1rmIX5tfn7wv5z8E2UP6BkB5UilSQecDNrQhcaIdfXTAHJ90eHmMg==@kvack.org
X-Gm-Message-State: AOJu0Yx+Xuq3u4dBGLqaXyh9Hs7ob1B2PzTRbRZ0mCQUgOMvhjqdPoIF
	WN/6SoxAxhat82UfJYoxHaOBZUy6CIGE7/QhCfIuuhDu9obVjtDSqJVe
X-Gm-Gg: ASbGncsTh4I1wLkKhS54B0ONOqfL9LvPCFwWoeOaakRtMfVbvA33u3A3cXoehY0rWc/
	SxeTVh5W/p+5aV3h3xJ0a5WFZOsFqyUbZB4Y39izxeLGuIshqIEKphFK5qTBJvxuFWqu4WRmR1K
	DnLSmXI6L+3XkSFFvP538+xee6hMC2p0ScKfIHLk4A52PpzZuJqrjUdZrIsw4Kz9L2cEFUny/Dh
	Fv4RbTVI0KnYNTCHfum9St/3bH5Etr6D8YYdN45xh+IjzPuI6fpxOwkteCMbuuOpQtpQrl1mT+k
	j9T/63+3luDVRq6pG3owuT+8CaxC0uCQspicOIvRwHNKertjPzlx9KUGA6obDKerd/umjfnvBk2
	MOCem+O1XVAszsTJZXpUF3bdtsijuqGeRAsXfgm5MWRDM0kjeWw==
X-Google-Smtp-Source: AGHT+IFPwbQYuxjB7a0ey4JvHITRQZqedavu3i0Y8Nu7EBQTFjbU8//ZN1py4iYXafr0IzmJIdbrVA==
X-Received: by 2002:a05:6a00:194b:b0:772:5271:d1ba with SMTP id d2e1a72fcca58-77612061e2emr3147992b3a.7.1757671917940;
        Fri, 12 Sep 2025 03:11:57 -0700 (PDT)
Received: from localhost ([185.49.34.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77607b18371sm5059816b3a.49.2025.09.12.03.11.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 03:11:57 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
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
Subject: [PATCH v4 00/21] mm/ksw: Introduce real-time KStackWatch debugging tool
Date: Fri, 12 Sep 2025 18:11:10 +0800
Message-ID: <20250912101145.465708-1-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j4w3hfqb5yp5yhtbxof3ahua5kft6obi
X-Rspamd-Queue-Id: 56E29120006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757671919-860144
X-HE-Meta: U2FsdGVkX18epSnZh+gmGeHiP5b8a6BWo+0ylXRo0FTikPX0XzNh4+OLtWFxQyvErWpDqcVJgZSn73OjDxhgY7j1S8AfWLWJ4WT0WhoNAeFFH211KYmtACHkvxQyCwv6QqbyJMPqwqxkQsvywtKz43DH0Y07b8DHIpVOxt2J5QrdcsBG5yVyHPywW4iaYXIH6OjNkn/Dvv9+MtHJj9FE5RrdK1YzoCV+kVm7uPotWnAeSlssCVFoUv61/N9LUP+/zwrox0vI4zDZUglx4VeRSnGSd9TrsYB/utnECJ+F/8Uu6/UCN8Sh9/SgOBGGzXAH4mnw6EHt3GebynH6pDBQC8tJWfa0gzXZXXcEfOxgCYSX/gFLwgt4dis+Xr22/tuKz0I8Pv8XiE9r2yMYVn1VX9hpVFIjyRjAfQFsG97NnpvsCPr9BTjioTDAwQMbjtqJTxkJJdbFVtpi3aqcQttt81g7+NpvqRJClM8bI75MPvKsyLzZI2neYtmEp4WJQyUtjALwb+v6fS7YHSU1Vp51MSIoncgFN8i74eXv+SQc6k0C46A57d3d//nX1LYaglzbiTvYQs6UAeDf1BjCi/V6FFG7iTFtTB/fkStn9piVEXmf/pg7/B1urD12L4gp0r/XIbbh5sxQdNOnZH3I27irM6LuBtvrnth9LqfJZ7CBvTwN4evpLW3ieRNOeVMNe34agYzKcgmiWCYQ5SgSZDJXLAK5SKC5U/X6EMr6j7G1xtZqzdAq9zSXz29RiZj4oyY7/sZUVgsLJFyZOlpTXMbn7cM6Ocejv//vbmbBeqIw4onNC3Xm1E6OYPYHlXKC0ERzXyWMlKYak+TtdoQQXqHNs5z5Ld88MUMKU85iLvhK+ygAc8+iiPNbudhqZ2fg74zvEX/ZGmtkRpnTFe22GCFb93eMClX1lpAhvGLFpRC4aRJOzMXry7B0HmchA6oAFFMUcCERLfccda4oW5gEbgf
 Ko4uQR8A
 RTCbFARptIj21IA10RcDrtiiYdKh+jPRqp0VjqzAX1x9SszYYqCaFZUCiveqMvRBbIFXkYBRiF3JAuoJyoKP260PjpjBqalFXgcCP6RFzU1lPLvOeI1jskw6KDdThGTX4iB4G5cBuVWkJA2FctC2WdOfVdSA0HYbdpHnxv+FplGdMF+qB17sj/GP3wMDPgV5NlijwAdGPFmFrAKCdNSqgJ70FYANosXqrwH/FPKKoZj6fPJFcSQo2WKKkKatELiVTV0ElXAqgfXbLFeMZFEdKuAbgm2SGPd9gyUnkfAPfdSmQi/8YbUqNDQsSZC2FhOEIum3rG9olXFbJ8RhJnNWNGZp+QGOSMIxnhUHOxe9jMHySoExoUF0bpCmxZ/hB06LTkO6juT1Bja1mSjOGuoEbkx1rtYFZCO6eNfgLLARsZfMOdgtWIAMli4qdKPs9NfOV514qjdI7ShRA7YmdlERcyt/UPYm8mAcCAJpV/xLO6/9eUd+xHSrrnFT/YFF3cGRxEMpuMh5oo61X0DqXqt7wx2MFpjM4+yB0jE2CtbKM+kLlWdcQoxSvAM5j8N2CunQDp3PPTOs8dVj/9bDwoaApdmJYtWN8bGM+rY6a4J8J/Vd8ZAK6+g4kPPEQQg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series introduces KStackWatch, a lightweight kernel debugging tool
for detecting kernel stack corruption in real time.

The motivation comes from scenarios where corruption occurs silently in one function
but manifests later as a crash in another. Using other tools may not reproduce the
issue due to its heavy overhead. with no direct call trace linking the two. Such bugs
are often extremely hard to debug with existing tools.

I demonstrate this scenario in test2 (silent corruption test).

KStackWatch works by combining a hardware breakpoint with kprobe and fprobe.
It can watch a stack canary or a selected local variable and detects the moment the
corruption actually occurs. This allows developers to pinpoint the real source rather
than only observing the final crash.

Key features include:

  - Lightweight overhead with minimal impact on bug reproducibility
  - Real-time detection of stack corruption
  - Simple configuration through `/proc/kstackwatch`
  - Support for recursive depth filter

To validate the approach, the patch includes a test module and a test script.

---
Changelog

V4:
  * Solve the lockdep issues with:
    * per-task KStackWatch context to track depth
    * atomic flag to protect watched_addr
  * Use refactored version of arch_reinstall_hw_breakpoint

  Patches 1–3 of this series are also used in the wprobe work proposed by
  Masami Hiramatsu, so there may be some overlap between our patches.
  Patch 3 comes directly from Masami Hiramatsu (thanks).

V3:
  Main changes:
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

  Cleanups:
    * Reduce logging and comments
    * Format logs with KBUILD_MODNAME
    * Remove unused headers

  Documentation:
    * Add new document

V2:
  https://lore.kernel.org/all/20250904002126.1514566-1-wangjinchao600@gmail.com/
  * Make hardware breakpoint and stack operations architecture-independent.

V1:
  https://lore.kernel.org/all/20250828073311.1116593-1-wangjinchao600@gmail.com/
  Core Implementation
    *   Replaced kretprobe with fprobe for function exit hooking, as suggested
        by Masami Hiramatsu
    *   Introduced per-task depth logic to track recursion across scheduling
    *   Removed the use of workqueue for a more efficient corruption check
    *   Reordered patches for better logical flow
    *   Simplified and improved commit messages throughout the series
    *   Removed initial archcheck which should be improved later


  Testing and Architecture

    *   Replaced the multiple-thread test with silent corruption test
    *   Split self-tests into a separate patch to improve clarity.

  Maintenance
    *   Added a new entry for KStackWatch to the MAINTAINERS file.

RFC:
  https://lore.kernel.org/lkml/20250818122720.434981-1-wangjinchao600@gmail.com/
---

The series is structured as follows:

Jinchao Wang (20):
  x86/hw_breakpoint: Unify breakpoint install/uninstall
  x86/hw_breakpoint: Add arch_reinstall_hw_breakpoint
  mm/ksw: add build system support
  mm/ksw: add ksw_config struct and parser
  mm/ksw: add singleton /proc/kstackwatch interface
  mm/ksw: add HWBP pre-allocation
  mm/ksw: Add atomic ksw_watch_on() and ksw_watch_off()
  mm/ksw: support CPU hotplug
  sched: add per-task KStackWatch context
  mm/ksw: add probe management helpers
  mm/ksw: resolve stack watch addr and len
  mm/ksw: manage probe and HWBP lifecycle via procfs
  mm/ksw: add self-debug helpers
  mm/ksw: add test module
  mm/ksw: add stack overflow test
  mm/ksw: add silent corruption test case
  mm/ksw: add recursive stack corruption test
  tools/ksw: add test script
  docs: add KStackWatch document
  MAINTAINERS: add entry for KStackWatch

Masami Hiramatsu (Google) (1):
  HWBP: Add modify_wide_hw_breakpoint_local() API

 Documentation/dev-tools/kstackwatch.rst |  94 +++++++++
 MAINTAINERS                             |   8 +
 arch/Kconfig                            |  10 +
 arch/x86/Kconfig                        |   1 +
 arch/x86/include/asm/hw_breakpoint.h    |   8 +
 arch/x86/kernel/hw_breakpoint.c         | 148 +++++++------
 include/linux/hw_breakpoint.h           |   6 +
 include/linux/kstackwatch_types.h       |  13 ++
 include/linux/sched.h                   |   5 +
 kernel/events/hw_breakpoint.c           |  36 ++++
 mm/Kconfig.debug                        |  21 ++
 mm/Makefile                             |   1 +
 mm/kstackwatch/Makefile                 |   8 +
 mm/kstackwatch/kernel.c                 | 239 +++++++++++++++++++++
 mm/kstackwatch/kstackwatch.h            |  53 +++++
 mm/kstackwatch/stack.c                  | 194 ++++++++++++++++++
 mm/kstackwatch/test.c                   | 262 ++++++++++++++++++++++++
 mm/kstackwatch/watch.c                  | 181 ++++++++++++++++
 tools/kstackwatch/kstackwatch_test.sh   |  40 ++++
 19 files changed, 1266 insertions(+), 62 deletions(-)
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


