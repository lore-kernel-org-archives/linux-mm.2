Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF3B6CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 05:24:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07B028E0005; Wed, 10 Sep 2025 01:24:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 053128E0001; Wed, 10 Sep 2025 01:24:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAA608E0005; Wed, 10 Sep 2025 01:24:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D8BB28E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:24:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7476F13BB20
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:24:11 +0000 (UTC)
X-FDA: 83872199502.23.3CDA100
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9B9314000A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:24:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KqQ3zg5+;
	spf=pass (imf04.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757481849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=cftv6dbe1p8dhP2DYhCN2AZkHpit5y+1p22q3P/B8ik=;
	b=KdeBXsQV7Pv04M9dYfaHOEG/DUOPfGCridHHyyqePesf0kOBM3ODVPzXxYL5lvEkRaau+4
	Ze8XRkTQLl+qHYkKBk/HRGp2DosZhyf4fntxteuqqF4qKuSrwiXxRAZ1l1tu/E88+3Rzxf
	mpz4UJrQX2g8RYfbWX1rCDqv8gcmgSI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KqQ3zg5+;
	spf=pass (imf04.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757481849; a=rsa-sha256;
	cv=none;
	b=D3TSTu6/8Zz35wqqBNH5rBA0hbHECQllky1O2Na/3fBrZMG+WUdadCY70+EATT4xQIuqbC
	Thhk+qCFrJoghbJlQJipxYPkHEqDbhJp2xy6d+cl57CBtOg7q2nTUoiEg2QLVVGXA1s1sC
	B5JkuVxvSc2tCq1Q7MYau0GMuR65o3c=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b47052620a6so192971a12.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 22:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757481848; x=1758086648; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cftv6dbe1p8dhP2DYhCN2AZkHpit5y+1p22q3P/B8ik=;
        b=KqQ3zg5+uUIGgyDkpep76grIOQNhuRKkfAH+A1yXfHRahdzPLYQO/x+Had7yfj8aHe
         kUBfWSBtQBzjqm2YzWPw6OVOtfUYhcyxTD/exMvrzf9fU1mAdtryJptboHWF2b2enUGE
         OAijy84L7js9kEyXgqUhz0npMsFUx9taGELLdcwtnb2V4n5icrN3WP2bYTm3vGrF4uVT
         jUjsvFXSQqWzqGTq1iwGHgP5nJxsuxxCLW2WWiSbE7ZyQQvYe1GKZtBC1PB7tLTAVAZW
         1lUrVF3l/bJUVD5+p9QwUGDYq6veXOsTE2NJZ8oGyYGQ2M7tQuCvotE8n/mY3+A6jUyT
         4uwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757481848; x=1758086648;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cftv6dbe1p8dhP2DYhCN2AZkHpit5y+1p22q3P/B8ik=;
        b=vRdqOcbzjveM9oodIciYvDJ+plVjSPjqzrR/maYboTxOtl9ARBrMh/zMcbc2lnwHz2
         d+FvWHK0qHadlkvUOe/xd3oEyAA2Aj5BmHF5AMNqWl6u+QbUwuGxjobwwKVzarm5H6pn
         3d5nG37sFZw1ojOGiWJ0Xf9668qUj34DnjgjqNQOr3Z0WIXw1ukFX9MAkxa2C8fd0wnA
         X0qcv8vLZemRzBRZVTHMSFmzwJS5BBKVb33C3HY9P+/AzFaKXKRna/PbP8pO+2MaWOnl
         8xCUYOxygNYaFCThr6ag99N4k5+XN/RkIqdyuP+qn68ElKr2nUMN2JDfS6E2f5otDxIT
         A+yg==
X-Forwarded-Encrypted: i=1; AJvYcCURVizYdnFXYqVt1ZJD80NGHu+F2ezt4owZLO2O5BNCB3vw2PH2l0Fw6gpzdqCiduoYEpi7eo3l/A==@kvack.org
X-Gm-Message-State: AOJu0Yxk2Thxu36gFC3ok0EnvqXby7KrjgPA3LdZU0gc30MMkCCYkdLw
	Pq1+dHEwQlPbBJdcT0nNPFbqX1OnIi2tV7Lz6P1pdL79fvKl2ZBg5Zln
X-Gm-Gg: ASbGncslA8uOBR5mx38UEWshxRIKGgNemOiXgeRLPOG/+BgwXLrnRXNsDSd4RIZfOTR
	sd6jTijUV2GIx2AN/tHDhxhUGm5cXErzywrZnM6nDUHtRLrG0g4WVGbMPTR8kQU3VZ24iUXYrER
	6QJo89y28CAXFYacDFxU3Fv1DveQcQ6Wybgk/5ZLvVDr/lsXR4MFVOVr+/wTp11wrkk/DT/rQrP
	lKEEj4pyY1FHuLG6d4YWhyNxVfYhun0JCy2s0BAKOtMZg/JWEzTYMyD1Cwumux15/JCkTUiRMxO
	fDSwPsNTez6Q5DRzrzEXFO4K+tocDZoGpFcVFccxl/iJhQFT5WxUUg7ulldXGpvSqbqyxO98RJR
	rKHZuUA4OsUStgrHOCdqRE/nheQLxzHXvsw==
X-Google-Smtp-Source: AGHT+IFuloiwaEGV/DNI2axiJL2dsg2gHw5eX6v8DVF0szm1gYxcXDzTuZF1jNHa7zPM4+MQqK3LqQ==
X-Received: by 2002:a17:903:986:b0:240:417d:8166 with SMTP id d9443c01a7336-251788fd271mr178360345ad.19.1757481848399;
        Tue, 09 Sep 2025 22:24:08 -0700 (PDT)
Received: from localhost.localdomain ([2403:2c80:17::10:4007])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25a27422ebcsm14815125ad.29.2025.09.09.22.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 22:24:07 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	kasan-dev@googlegroups.com,
	"David S. Miller" <davem@davemloft.net>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH v3 00/19] mm/ksw: Introduce real-time Kernel Stack Watch debugging tool
Date: Wed, 10 Sep 2025 13:23:09 +0800
Message-ID: <20250910052335.1151048-1-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9B9314000A
X-Stat-Signature: 6rn1tijw7dcotmc376y3agwai5mxm5tg
X-HE-Tag: 1757481849-161134
X-HE-Meta: U2FsdGVkX18iRa/sdVZnVj7TeocMwfOsa9evOax2R9UvA92t6/vAszaXrwoXF2A7LVgPeZ5nwtLzwVXMDpmIt2fUeHdtNI+8lRgQpilqAs/3emNkVGXVOm8dEYQ+udkp1lKLVANQ8sTQoX9g1QN7NZCWPYagmwtd4eEqhuPxsvluygP0CeG1IzYAkSyOVLincmMa6n1hs/bosSOdvLoIWmRcx4nENj2VCSG6WWVaq81vavgz0BPB/pCNTaNSePCZsAWHYp+5W5FATSjMNoadibjf5/PMqHnZwMeuauZhey/Tpz69nJXDhY2THPVJklK+zSydVz53v/vJ/xQvjWSZvzBTwwE0XTAAtUWWibBS93sZC2M++webfRkCWWiCfWhMDxJeBYaOm8D7bxS5jGJ0ycaR/3P0Uol7XY4zq0BMqj0rkz/fY0PRhHzKjHuMCWrD+PyBV58AWWlmveCot38sPisKt6zlhwOBlKdRGYuXHfBpeVRKPesyP83bv9S93XxWgHKFZQS1wLmsunwHmPoXqMPMUAL/kpVgB2XXtU3Jmw2D8uwCMIkJ5PDOepcoGVROvBDCZzfchUraSKL7x+Ecqn1pPGZ08nLiI8FFg+pLkrk6ppmf9mLvcgTHxk6TkBJaeLhkpvdMnjbXHt446K09LOQqpdDBFesqXm4WA0YE5WzInr/HyPttB9G3UMV4USEGSiJdbkvJZRThndmJf8oYCj+7+8ZU0Tt8zhia21hy6dIn7ZSerV/kBw99VOXfsmRbTOyHNGaUMZEkF8KR8lS+ahMGlF+CrbWy05MCx29lmeRojS5sDohhP7FEA0zYQaXMsLmfuYikfLgRFMrATkMMzf/vNs49zsceDS5xW6d38qbWvLY85lSv/7E/iJf0FCvXpNq67HhcYKfqcvWkBGbs2xMs3MDab+1CRjFYyy7HPV9lC92Gz1Xn7qJj59chsFVvN01tLTDxNoS/PGG292k
 QJQQKaSM
 r2fYJE2PNC/SRm5NVlEgKsFAG0nPurr2szA+H0BX2gssl1HfrlqK6cUb9VLZ5BMjThTaCNxSGCg3L/IpTWoiadkk81fDO/X0l/pciqCk+PsIO2XBxunC7r5eAlYz/okO3jkGa+JjhUOhbZjSZu4N3GHikiMiKboyzPLtdYhmvZW5wY8VNejrZLRh/MpWZoVwEta/0zvlISzXTqbJizdelOjv8ud5eefTynoNeQUzsYphyVkL4SJXeEs8tYR7/tA9X6jU/8aEjgSILXBf0sYpx5e/joObtGghDFuzHHAlg/ub2O1a2Go6Aw5HapYUAQac8h0cNCCfCDhYvjbBMaZJblaxtd0Sk85I7AFUE8ywvyEkiD1nYjbIn2lRlWYFDuCChzOW+kLVyTi1TCWKh4YkaNPVbHnygMcbmUtoGPQ49G/CUjxntTjOZ+la29OlnV5HwzVh5LLKSlLyUZhFITSvcKSztPbYXuNpz1ErmHk4EyEpscl17SBID61H4Rg0VIYSKpJZ1turfBwf1lasZRPTU2OQFDtrr+1hj6We3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series introduces **KStackWatch**, a lightweight kernel debugging tool
for detecting kernel stack corruption in real time.

The motivation comes from scenarios where corruption occurs silently in one function
but manifests later as a crash in another. Using KASAN may not reproduce the issue due
to its heavy overhead. with no direct call trace linking the two. Such bugs are often
extremely hard to debug with existing tools.
I demonstrate this scenario in **test2 (silent corruption test)**.

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

Jinchao Wang (18):
  x86/hw_breakpoint: introduce arch_reinstall_hw_breakpoint() for atomic
    context
  mm/ksw: add build system support
  mm/ksw: add ksw_config struct and parser
  mm/ksw: add /proc/kstackwatch interface
  mm/ksw: add HWBP pre-allocation
  mm/ksw: add atomic watch on/off operations
  mm/ksw: support CPU hotplug
  mm/ksw: add probe management helpers
  mm/ksw: resolve stack watch addr and len
  mm/ksw: add recursive depth tracking
  mm/ksw: manage start/stop of stack watching
  mm/ksw: add self-debug helpers
  mm/ksw: add test module
  mm/ksw: add stack overflow test
  mm/ksw: add silent corruption test case
  mm/ksw: add recursive stack corruption test
  tools/ksw: add test script
  docs: add KStackWatch document

Masami Hiramatsu (Google) (1):
  HWBP: Add modify_wide_hw_breakpoint_local() API

 Documentation/dev-tools/kstackwatch.rst |  94 ++++++++
 MAINTAINERS                             |   7 +
 arch/Kconfig                            |  10 +
 arch/x86/Kconfig                        |   1 +
 arch/x86/include/asm/hw_breakpoint.h    |   1 +
 arch/x86/kernel/hw_breakpoint.c         |  50 +++++
 include/linux/hw_breakpoint.h           |   6 +
 kernel/events/hw_breakpoint.c           |  36 ++++
 mm/Kconfig.debug                        |  21 ++
 mm/Makefile                             |   1 +
 mm/kstackwatch/Makefile                 |   8 +
 mm/kstackwatch/kernel.c                 | 239 ++++++++++++++++++++
 mm/kstackwatch/kstackwatch.h            |  53 +++++
 mm/kstackwatch/stack.c                  | 276 ++++++++++++++++++++++++
 mm/kstackwatch/test.c                   | 259 ++++++++++++++++++++++
 mm/kstackwatch/watch.c                  | 205 ++++++++++++++++++
 tools/kstackwatch/kstackwatch_test.sh   |  40 ++++
 17 files changed, 1307 insertions(+)
 create mode 100644 Documentation/dev-tools/kstackwatch.rst
 create mode 100644 mm/kstackwatch/Makefile
 create mode 100644 mm/kstackwatch/kernel.c
 create mode 100644 mm/kstackwatch/kstackwatch.h
 create mode 100644 mm/kstackwatch/stack.c
 create mode 100644 mm/kstackwatch/test.c
 create mode 100644 mm/kstackwatch/watch.c
 create mode 100755 tools/kstackwatch/kstackwatch_test.sh

-- 
2.43.0


