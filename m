Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DBDECCD18A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 10:57:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2C948E0076; Thu,  9 Oct 2025 06:57:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A04788E0002; Thu,  9 Oct 2025 06:57:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91A518E0076; Thu,  9 Oct 2025 06:57:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 810038E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:57:10 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 37EB01A07C8
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:57:10 +0000 (UTC)
X-FDA: 83978273820.11.6C42DB0
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf17.hostedemail.com (Postfix) with ESMTP id 547B540009
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:57:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bjtDRWIx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760007428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=r/KVNrCgkP/CpH67njDEKsgcguKTfOKueucBYEp6ELs=;
	b=az008VwjDB1WaGqQdoTfFiLTH5nbm/8jBxS9rdJRX7oZt9juraMq3WTad9qCkhICVPFRIv
	JGv+xoKQyMgon+KimFcNPMrzgeXX32ZmhMVJx4ase4un4VQtrOJ+R9joQA0GqhPhLciqSB
	G/6Jy/4E/WwlDGtFZnP0I1Zcz+upht0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bjtDRWIx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760007428; a=rsa-sha256;
	cv=none;
	b=BCtS4gcDkzgVQpbvXXe2388heGXRDKPftGEGHCGL4pAnBht9S/ehYu3/wAE0pCTBM7DtpM
	SbIKoGzfRhYvUu8DI5dWK/apuxn5/gxoejI4wB6gF3p7yFtGnbwC4IQ/mZWkx/46ttKqMz
	jfy/nfapJXGCTFtF2BxLz8EHCH/b4Ac=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-78af743c232so733037b3a.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 03:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760007427; x=1760612227; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=r/KVNrCgkP/CpH67njDEKsgcguKTfOKueucBYEp6ELs=;
        b=bjtDRWIxToRB4mrlmCkj616RWMcA/OFoU4q8OpTFYKXYHVGJXl0x6+P2nF6QXM6vFx
         0UZj4UGg49dD6ts2xzC5vQN/8eQvkseF56xEg3h3qaoSqOGcRKRhvvotPbWg6WZmDEPI
         AhQ8Itdu0myeKY9px0yzuK3sU5jZL5quY9/xOhyEgWxJVV/bnV8D4d1JZ9sRV9js2XjP
         5lmLKjKnH9CZKMUWdztAKXBdW2pXqMLcxf6XlrcWEWC3SQW5CH4mbCyU27hGgmBL6zeV
         D6xuzW9/YpxEn61A+qVqz5/YFpACQtra5IuxPCoxr7YxSwfkPskYUolMfBswO2KZkHbT
         dcFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760007427; x=1760612227;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r/KVNrCgkP/CpH67njDEKsgcguKTfOKueucBYEp6ELs=;
        b=SpTOBTelawMjlCiV6IpqimtIF1xDkfSawRJiO3WUnLorsW4EWrTySaHHbSytH/vF9f
         eqHtZeU1RqM/qqUYsco/zeh7y8pULy8UDbzlZRYQzHD6TUB58Q1J5XL/D5maIPzZtwGu
         lOvSHk2BtOO2Bnz8fUFZExOliTIGbbcKuHLtjqzh39KGMUJlU+iWUmnBwVglMmE1yr6C
         QMcDRiKitr0bSWfQYthFYpObq8fIaFiRd37XZ6BunL6dMH3coMbtgnk3/7n+sDH/mmHH
         Nfm4RFPbKxsIiMORvZrixmo8U1eQSVGeQx/TRPn6WKdv56qTrN8YxdTeYZiMsBK7rihn
         h6QA==
X-Forwarded-Encrypted: i=1; AJvYcCUvik2G4TgQyNmoQIuPyDTzQ0DVbVoMXGG2K8X1jMWn0yjebwRnMzQHyqNNCoH8C9PTQ0rVotp0RQ==@kvack.org
X-Gm-Message-State: AOJu0YwS1D+qqmBal9igPXpiqc1ZjZQWVirNV13HtdmFXseudQw/Ipmr
	rxW44S5h6kZUbWB7FoBgcqAIx7cji7z0HJ1QA3ZaSGUra9hdjCVKAHdK
X-Gm-Gg: ASbGncuB5LVaVsTCsHWCAtQBwDuqcyANRpmP+LXdqLpE1j+mx2J2posw92tibdlqvtH
	CvxLi8KIxIC2LoRvGweKf97AHc3p8zMTRUSwkpoTS7GCF9A+tD9cWlbFeLjMy+EE72VQ1kuqMny
	u5afNJ0EbzH4eB0NqSxWvmhcNVRMXxMOKykswAn+TXFCHB3RAXXPV2oS02E6DivnlEAvl/WeL5N
	Z25NO9duwQp7lTstyQU/hSAQ30WHUlAQTccZj4gNKtGk9i7AtDriVApdUwi5/wHsSEZF2iLu04J
	3lRX8SDiiKNZ3l+h7s4NjcvW0wmk+7YXcjK8IpQ4XN50Sn0TFQBV6mQXwDkMRf7B8y67oZWUmFV
	6hoYb9kkanLoxDh0eTx9Hxd4KGXHH/6FCaS8VzsAkjSEefy6NDiqMr1eDK9kl
X-Google-Smtp-Source: AGHT+IHegRF+cDkS8n8iN1wDSqYkCY6Z+zS+A83OBf5JKqfA2hExCY0UD9dxNTVbTqOQx/6S6nxYew==
X-Received: by 2002:a05:6a20:914f:b0:2c4:c85a:7da5 with SMTP id adf61e73a8af0-32da81345e5mr10045407637.6.1760007426930;
        Thu, 09 Oct 2025 03:57:06 -0700 (PDT)
Received: from localhost ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-794e34e6f17sm2514275b3a.82.2025.10.09.03.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 03:57:06 -0700 (PDT)
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
Subject: [PATCH v7 00/23] mm/ksw: Introduce real-time KStackWatch debugging tool
Date: Thu,  9 Oct 2025 18:55:36 +0800
Message-ID: <20251009105650.168917-1-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 547B540009
X-Rspamd-Server: rspam03
X-Stat-Signature: j1b9fznqktkfqhndetc74mctihqme5us
X-HE-Tag: 1760007428-283545
X-HE-Meta: U2FsdGVkX19rnsf7UNrvQZ/5DEquwgVt2KXHP2IokxfkcmQgwRx4/yJHqwcTLG628zc+IxcegxNPytzSNLpRQrCSqLrEheIDQPMsv80EpR9+hlpuzUYMsXpRwYf6S2IiO1kjxvP7TCHf1mYCX1QtixvBOt0l8v4180TZtlgctxCRE8fDVB5QnYlX3dR4e0YsumEIvdKF9UsoRDHytdzA29CenQ0YPH7U5TzUKzrem1idvu5LqTRA09pC5V+fISnRqn1mkTmN9dNp8BKhMHG4tWdInqPTwzI+r4RIy7MJTZdD+YldUveWPglzZwlo4LYgYdC8eurHhzk4AikpmPTjt9yBL+whvWkqY2604fYCx6Dnq2cwi/bEFM0eUbFVZNRwxobk9qbe/avmcKLpRFO6s2uw4czb6dbBine+Tjx2Oi0+4KgFwNxtmemGLih55aiaHEmrrHt+W3OKxgWvZ3C9CkGgnZ/ZfYqVyxsV5U2QeMrKkH44TX3JXbZU7Eilsaj1NRLWcpESuO3SQDgknPjaWu/credg/ANeF2ApcMKhEM87TMTA2TtZaFhDzzpmOkv+k0QqKahHUBhLhXgnVqCOQeKQImTIYmsa7CKNlAfKhjI3/PZY3Ilr4j3WqxbkmtTgxqNyl9jDsVnUiObwytpfH44cBiOc4qzZM3CPqjoXOl9kLLLj/+6e5ImmYwT9b6yzOKKcrRiWA7pyWkCpYMEaAQDe1/1CeBwzx3A2Wq2I+o9G8dOqIsomlfIoJsQp6J2Bcl2VfmGmc6Z7Q4RsZxRE5cNuQEHR5qrRhdn+Uy9YcVSaJ5Y1oIb/sKyXj+lEFK8o/p0a4yr2TvQEh+gAAXY/SYKHHTQb8XJeoEOyCH0QeQaVq9NFWVN6HjlezJTSwyRToz3QXEHS35AAYLwepiWBsFf0TrnqthCrQkK0RWFmTiIrYWudLjfXUB+0W66LSzf2uyakHO1n0b68rkQ6NPY
 jYLwBPZr
 WNqCV4JNOdA6Ajjd9WmEGi93ZGbO9LTbW7lZNFpkHC1X3vCZ1ugyNm+luBoRA4pdRiBUndvz4LUGjqH+HjPJdonbCo2CmfLvjv5UBe5NZl5aTpdz1So89bD6njhF8qI7kBVo0dQNBKp0l70Gaj7W3zygNYVvIHlqtpNrphBjwEJTjWxjQKGEBg7NNM9aBoN98OTM5AIZiyHHWtq0KTw5+zniBv8J3nSzcSLCo1Mk74XTepNRu6/sFSZhQfIvn1fpCe9RGcaIZHJeWl9bRZsbe/4vWclMTjM1glP5qzbnwHuKFgIBJZVgQJSgpq5CbafGq/9jgcOMNj8amlzN5hzHfUMpdDoKTy3xfzH70Dq6lOnaR82RSOeVtpSU5yIT0vxPmFLMthZy0W0z16w2jzT9Dy3slWqjq2rzp2t59tiORC9hrbLvR+ad8qOI+pa/xyZCZP9e84TPyhYVTsahHsH47u4vdgOgQ+30MlRGbzh8nbxqZ9Ke0QW8P86vPN+dZsOlAXhy3quUqtNVDFr9ehWVSDPrHgWCKbLOr6Puve5g71dxCIgA/C6dBrGcWsJpB5EM0+FpIHAdkWN3x91YJRQbbP4TXGB0zzjm84BJwqo0ZpvHdhVyh8vJKls/+aQ==
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

V7:
  * Fix maintainer entry to alphabetical position

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


