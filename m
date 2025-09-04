Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B85E7CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 00:21:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11D5B8E0005; Wed,  3 Sep 2025 20:21:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F5538E0003; Wed,  3 Sep 2025 20:21:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00A528E0005; Wed,  3 Sep 2025 20:21:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E448E8E0003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:21:50 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7B829140955
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:21:50 +0000 (UTC)
X-FDA: 83849664780.07.61439EF
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf20.hostedemail.com (Postfix) with ESMTP id A46D11C0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:21:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nfi3VHP1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756945308; a=rsa-sha256;
	cv=none;
	b=4b8NRn1dW7msUZ4NIFvWALg7W9S8epNSOz0gpuPcGclHDZFX+AC7ENhARS84iHQEDrypmd
	A5Sy8z/Q7P/5CnFqSQMme7+HtWDiKC3ythY5KApK5nfQ9cMKn2z4YmI807FXODja1Fv9l7
	8h/as/EdB33XM1MgCtx24gxOGOCHpQo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nfi3VHP1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756945308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HHlaBgzUa1Qmmhf3CcsWTtBaw+HbaoWGOhuV0heFh9I=;
	b=S8zhuuSczCXNMr0Pro7K7ZL2FJbOsal3NQYy48wAqMClfxSHeC2RayU/TPHC/qlmSkAMao
	CEaPrfmsXy5/lNxZZfqoOCq4zBEqG2L/ziik/7jeGfekTnBRjuwbmfYxB3ixT+u9bvxfJt
	QoAIZsn+FFSBeT+pZ6zKBClCKG8mO7Y=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-772679eb358so457769b3a.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 17:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756945307; x=1757550107; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HHlaBgzUa1Qmmhf3CcsWTtBaw+HbaoWGOhuV0heFh9I=;
        b=nfi3VHP1jBbfShYymqlTwtXIyn/xSQRSekaB73Y4e/wBo56aTDcEsZWgcE+DTBO4Uq
         kggPMVv2/YkB1ZqV3uLlfaI2WbpMKITWAOWQBIKhsVqFtWf2NrET/vmq0NrwEBIT02Dn
         Lw7FUXFHz3DXIQInE8waKttCX/ZyYeJAWpz/oc1xTOWhgmFLmTOSiZaL6R9nedSns9Km
         a4c3qL0y4fQcExCl5qaKrVkvhmY+DCQ7zlpGP4aAnkxZJbn667zIej67XMDo4Uhn48ey
         pa4N7/P6knHMqlH3umVhgJ4rTF0ds8r6ZGAD19okVDg0HeZGA8ji/VxvqJWDRDHE+fc1
         b1HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756945307; x=1757550107;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HHlaBgzUa1Qmmhf3CcsWTtBaw+HbaoWGOhuV0heFh9I=;
        b=UOwvBenX3s8F20QXJoL7CoPwv82utNLSjVHDKUZJHEwK0ywPjjHE8LfmmUSugwF8hE
         vPjS0bipJNjMtbkEBOhNgIndrvhquCUIaL4jm2l9+VXpfmeuEUeFbm4p3FW8R+twBWyp
         +9Wzo3C3WuycAXfAvfQyydtExDXn/PjCThXxlGokm7rlZBDpsmd6874zEt+rp0l7tEET
         OJ9dpX1H4rnauxwVgu2hR0GsGFSUq9RXlV/SaMpFTCeOsYJsx31WI9+pJmxLgAUiTnAz
         wIYSMn7/SsBovzNkogFAKHojpxHbFhAQFvOX9nN/xLQMFLEh59aGfNAE8/l7h1aNoSpW
         EnyQ==
X-Forwarded-Encrypted: i=1; AJvYcCWH2ZuqjflhGc8g7n0tBiDqM07OV/nUZCBOj/VVP6A0+zrvTrp743aWMq1rHoyWkrMfLm1MeQiCig==@kvack.org
X-Gm-Message-State: AOJu0Yxnkl/UAjEGwAXG4kYqpuOsGUx69bpl/qO5ZdvJRFEHrW69K8Y6
	pIV7zNi67uN9s36sxdktuSnDuc9nLMTOzsSlB5+yE3s4p2xKnx3kbegG
X-Gm-Gg: ASbGncsav4nOgIMTU55BCcOMpWh+5T9xypS/LT98KL50OHEkkEOUWAkzmcGsu/gHJyz
	y19QT1gwA8UKNuqLjqh20Gw5Wy61PnJL+bHCw7y+C2ADAnWtd5JtkW1OrGKgM+JsOeuT76je7lu
	jeLKc+CvojMriiNBF+U8vYZ5J1ISkg4/rV1NHLex7fO8S1QV9zTFaFXu6QpPxYqTRNbL+c1ofIk
	Hwa3eR8nueHnbKHOpSPSAv33SkOA2OwxACENA6FMIHUI9DbFoSBiNrq92XZdmjegoTu5BWH0T5H
	qYQ3rY8aNK0vMsMOjPN3CGqoJnVvpk6Rpd1ekHd57aBY525PsmddvU4S0onG9/cX6ukp1/v8EK+
	fJZD9+YbpKLSJiXkHa7xxRPcKP5b+7cLNY/LOhPTKBIgwoMM+bKSG
X-Google-Smtp-Source: AGHT+IE2Rm0qq4WLXUHC72wTGZQAf9KHWheCu6SFRXozAz2xgm8zzpEZ+y20XdO59dgoeGrCi7nsVQ==
X-Received: by 2002:a05:6a00:9285:b0:772:5836:741 with SMTP id d2e1a72fcca58-772583608e0mr15901990b3a.11.1756945307314;
        Wed, 03 Sep 2025 17:21:47 -0700 (PDT)
Received: from localhost.localdomain ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4bd2aesm17579551b3a.48.2025.09.03.17.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 17:21:46 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
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
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH v2 00/18] mm/ksw: Introduce real-time Kernel Stack Watch debugging tool
Date: Thu,  4 Sep 2025 08:20:57 +0800
Message-ID: <20250904002126.1514566-1-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A46D11C0002
X-Stat-Signature: ceae499wa4tbm7ufb1odp7bfg7e8ife9
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756945308-500125
X-HE-Meta: U2FsdGVkX18o4YZ/UyWyHuHhq4dZOfqa9xBwkAjfx5/0HE3Al9eTTGJrAVMsyWeZ03AmOIt6OIZ6kk4tzuz23uMcer8HvsnYbQBYSLC4GvdG6pqXlWoK5IEKsmvG4BDKQlaTVq+NVPSzAT4rCqebjiUOsqmd0cB/fFeOlvioHFsbcIKDJuxRs8BIor6jQnRUF16YdlrG4gVEqTtgP4yz7i+6B4f87V6Wa4ui2mqQgqbz8BWo//TwC5OD9TybVVmYaKlBSatj3vtrRoUJVKZ5Zzvj8Ck9f5VWIq3b2UU5IOGXdCHoHsntSj0pCFlwLuwah3oedjlKUCaAEuC61RtQnld1Ag4e++Y4ByfNbxhzZ11U4xZx9as3E0029mDLdDpcaShxiaBK0coP1JxDRrEqu0vPPuxGE0jbltkA0TZW5+Ls3KbC8fMDalCriTF6iWmmRIm1J11dZWXaliKL7crz8CqQ7ejlynAb/4GWwzHkyhsAtxy3BvGAxgIBoiSabs9d7Ik8ViUZ3vfKLrMoubrgpwfL6NEVEODpxbI6Zgo9Cjz4qcOJ4hRAsDzwmsv6V/2hyEfdr14ipPmXu1dLOi5DXvIbQ7u1I43MAhtHCPpvmFodV0ZlMbDyokFEF5cUeYKZHwA4y2gUsjKS812aWiYoF8AmtP/+5DrxzYtzd5PPzd9PPk0wuw+Vb/OaC1vzCYCR87pqaxC0PWv/THwuQSGUY3IhLdTreYzWXgBLOi2bqfcMHxDU0Zfjlyp9t60w4irf0DTxaMqh4wzv78r1ZajgbOmFP+nzmMJ156hFuQpQWkkrWdVVJSbe3Fch8O/W7fe/0S2lkF3XJtuJShO2obVpzt8RFlFXDI5hhCo4Ke4kNIC8tZ66vXi4GUFxPSMZmKFBkYCerifE3b0iQB5bd4N2sttPbWnr8VK8YxkKQpvn616Q7FsZYjhaRwX6/PXN/8/K0GQcgNcPh+z/tz6WVUN
 7TsIn+Dc
 oWHgf87BjHEPDXnwCTcRw0wDKQKDg8QOC6dZct8C8hrYpoLyAQG2StuKTpKAe+9bpcrt1+4MKk0wKXtloao0gOaONbKL1qlwxaFWqnjjv5EC8uoO8fsuw1vnLBMbwQOqrkvj+SPyJmWvEKsQ3jhKaySo26q1Ab+MilUNQoBnvQ0jj0ah7CepwC2UmAkH2T8NrNo6JBau1sjgb341rpAU041xcTUk5pPO3ZVzxfvgKXGGVn0ch9e6opTXLEUOOYTZG1fHwUgjFVH28XNGXl7BQewJQiEsS5Ty67PfUCwVy1KKtg8A4F5WSNImNWnj610Ae793rOKi7ZfttMSpJbI+aGd7uLHGKatzhbznOfeGtzP/mN0chLIyBLfv4NuenkTdHM3XulgwOqVNk5r0gWpZ02cAoBEWhhysR1JnpoEdwLYzvRnAD97KWI+iZJoKlwQAQwxNQb7cAVQhJcLOchRF4d7iSvg==
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
V2 incorporates feedback and builds on the previously proposed RFC [1] and V1 [2].
The changes are as follows:
V2:
  * Make hardware breakpoint and stack operations architecture-independent.
V1:
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

[1] https://lore.kernel.org/lkml/20250818122720.434981-1-wangjinchao600@gmail.com/
[2] https://lore.kernel.org/all/20250828073311.1116593-1-wangjinchao600@gmail.com/
---

The series is structured as follows:

Jinchao Wang (18):
  mm/ksw: add build system support
  mm/ksw: add ksw_config struct and parser
  mm/ksw: add /proc/kstackwatch interface
  mm/ksw: add HWBP pre-allocation support
  x86/hw_breakpoint: introduce arch_reinstall_hw_breakpoint() for atomic
    context
  perf/hw_breakpoint: add arch-independent hw_breakpoint_modify_local()
  mm/ksw: add atomic watch on/off operations
  mm/ksw: add stack probe support
  mm/ksw: implement stack canary and local var resolution logic
  mm/ksw: add per-task recursion depth tracking
  mm/ksw: coordinate watch and stack for full functionality
  mm/ksw: add self-debug functions for kstackwatch watch
  mm/ksw: add test module
  mm/ksw: add stack overflow test
  mm/ksw: add simplified silent corruption test
  mm/ksw: add recursive corruption test
  tools/kstackwatch: add interactive test script for KStackWatch
  MAINTAINERS: add entry for KStackWatch (Kernel Stack Watch)

 MAINTAINERS                           |   6 +
 arch/x86/include/asm/hw_breakpoint.h  |   1 +
 arch/x86/kernel/hw_breakpoint.c       |  50 +++++
 include/linux/hw_breakpoint.h         |   1 +
 kernel/events/hw_breakpoint.c         |  18 ++
 mm/Kconfig.debug                      |  20 ++
 mm/Makefile                           |   1 +
 mm/kstackwatch/Makefile               |   8 +
 mm/kstackwatch/kernel.c               | 260 +++++++++++++++++++++++
 mm/kstackwatch/kstackwatch.h          |  53 +++++
 mm/kstackwatch/kstackwatch_test.c     | 261 +++++++++++++++++++++++
 mm/kstackwatch/stack.c                | 286 ++++++++++++++++++++++++++
 mm/kstackwatch/watch.c                | 175 ++++++++++++++++
 tools/kstackwatch/kstackwatch_test.sh | 118 +++++++++++
 14 files changed, 1258 insertions(+)
 create mode 100644 mm/kstackwatch/Makefile
 create mode 100644 mm/kstackwatch/kernel.c
 create mode 100644 mm/kstackwatch/kstackwatch.h
 create mode 100644 mm/kstackwatch/kstackwatch_test.c
 create mode 100644 mm/kstackwatch/stack.c
 create mode 100644 mm/kstackwatch/watch.c
 create mode 100755 tools/kstackwatch/kstackwatch_test.sh

-- 
2.43.0


