Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79559C4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 18:34:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70BCA6B00F5; Tue, 14 Jul 2026 14:34:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F1376B00F6; Tue, 14 Jul 2026 14:34:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D35D6B00F8; Tue, 14 Jul 2026 14:34:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2217A6B00F5
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:34:19 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A5FF8140440
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:34:18 +0000 (UTC)
X-FDA: 84988232196.17.32619FF
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf02.hostedemail.com (Postfix) with ESMTP id C952C8000B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:34:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jUA2wntH;
	spf=pass (imf02.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784054056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZmmWwuvjQogVDd2VSBmXRJatjjzPeEuGhwyiPs8S0po=;
	b=ZhZj/frTRz5A2Uyds1DUU7iArZkDx6ZmfYK8+StN40GR1jnhvyOC6F3QklF5uFj7NjwNO9
	l6rzvtxsqPbZOyJ+5E2FguSB+vL0dWuNw+0HVBwEVW6T1Ui32ri037QLHWpquQVSuYqGI6
	zfhPbtcuamCmgpjsCiKC3Am9RJ8e1CY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jUA2wntH;
	spf=pass (imf02.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784054056;
	b=NIkLzEQ0POs1K5yqcVAQzOhvpjB3gw67hAKoldkoiZVc8P9zOSUjtgjOiMfBoHy9C2fCjq
	Ed4SVZ8MOaa24YWkmV6ZIabRA5MP8P3YaK4hTXQtYCmSQuvmjB1Nn2FRCAj9SPdAcouKpu
	LDvg5SXb5MJdYynTWFvMZYn5hy10wnk=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-902e4af2d9dso11395716d6.0
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784054056; x=1784658856; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZmmWwuvjQogVDd2VSBmXRJatjjzPeEuGhwyiPs8S0po=;
        b=jUA2wntHxqT6aTpJnlXasvSQaPq0noZViCuoqwqM30r9C/TmvRs5enWwsuPQxFby23
         wgt//dfUU9zRa+M91NY1legSh+pTBs8xIA6hKArLFMTObnSAHf21IUyCiX0ZbDEZGJYl
         eu5yzb83C+UmCkVc1C9+cdeEI43uDxD5QmngZkYBpHMSn3irvp/x2Ck207BchJY1OGEs
         ee+BZqSzFTacWAlKCgpbHXSwp+KB6DjUDJfyeHXDp3oDm5UhR5mPNWS08wmuDqIpAMG2
         YjDrLmDhCB25c3sLdlUe7Cggc2m0omrRd2dW4igup9lPEF0xEhfoyv6ZzE1qAOFNtrvw
         ZEvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784054056; x=1784658856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZmmWwuvjQogVDd2VSBmXRJatjjzPeEuGhwyiPs8S0po=;
        b=ilKSLFmX1kVAqXMjk5gUBlOaWcFOfOBEYsX/Xs5XjDZeWd7PDn8AZxCJMLXAFz1jDp
         8TXQOmgZHt5XqVk2TsfulY+rN7/DhehoZAk2DCzYBOlPEsD9pAUjNYG+/hbFgQ7bvLmZ
         RrglwZJ4bRJ0/i8BquR3jZUSUCoiXwAg3uwlni0QTu5FpRkUI3nhZWAN/zTKQG2/+hxe
         u+STxQY7Pfdm33L+9Zdb4ePkRpPvaF8fCsLMLDLmQDPE2ufNNBh2XLw2/oUHLoTSv4lB
         RvYbLTXdQICo91wKCgSpjetCWKGYlWclazX3lEvf6V7wy6s2pmEEgqIhtSu7xT5rSpqx
         sAWg==
X-Forwarded-Encrypted: i=1; AHgh+Rp+i0HhJx5QOdDkr6Zbbdelo8kzwLz56kR8MmOrW0DxtMzB2t1zV/lBxQJvlT/gfbfAzduZt/9/sQ==@kvack.org
X-Gm-Message-State: AOJu0YxorXk3XtO2U9YXTXBbLU15b4IfVATB1fgraVhY8rab/Vgo6zzw
	z7n0h219Y9HvRw4Hk8qb5sKfnQ+hy2VVuSxP2jSz2CBuFpAhTPGOAUFy
X-Gm-Gg: AfdE7ckLg5w1RgTzz7OV8IUt+KfxsQC5Q+ULBO+qzY6JLAZ3bazuXjG9Os9G8NRmPY0
	b4eUtysnvpcOeUMJqiVb1ZhGBj/uV5R1EV6k/hog8BISdF5TK6s7RjXBaNoqUvWPUCwBadTFUJr
	yDkhXKZePSaqhmCtqeEedIXCCFo5JCNJHg5COz23xz/3R1oGw01Sn8QZGWaI/MbUECGdP7ehxHT
	lXgZs26lCj0DwbeooMdiWFXFnTm7ExUdzgAxbmcd89LLzHZbrWH+hnQ7fxbDl2lrr9NZKLupVYm
	XbcfcBEZe2pHcYPA4Rq915xluzUbcF+FRDJPOuM9lEcouyj1V/1he+DYxb4cYPJ6uMUttvvAO7K
	TNeIOvRDtrJwgPB+BgcQmZrmlrlzX6eotYpGnCjO4lFm7XXdb7XDX74WKaW2V5rtal9vFFXDD39
	loh1BD9Pkpk1dEtnIgzhEz6CiDO8Y8/oPGhvxZXUJIANiDqY3V2bE=
X-Received: by 2002:a05:6214:19ce:b0:8f1:77b7:9bdc with SMTP id 6a1803df08f44-90413e0a5bfmr163102536d6.1.1784054055852;
        Tue, 14 Jul 2026 11:34:15 -0700 (PDT)
Received: from localhost ([48.45.163.146])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd80fd82csm174180826d6.35.2026.07.14.11.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 11:34:14 -0700 (PDT)
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
Subject: [RFC PATCH 13/13] Documentation/dev-tools: document KWatch
Date: Wed, 15 Jul 2026 02:33:56 +0800
Message-ID: <20260714183356.13109-1-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260714182243.10687-1-wangjinchao600@gmail.com>
References: <20260714182243.10687-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C952C8000B
X-Stat-Signature: rahmxf91jf8os9njk11jzp8hs8yeyg8f
X-HE-Tag: 1784054056-845634
X-HE-Meta: U2FsdGVkX19ikID9OzjhwgkU8hrQUl+iNMk+Yugp/AX0/b6RSTuyaD1g00XsY3IhrI9x5vSsHBo633AB4fB1L5glVphwXsNqfl1yjKcHaLe8ZpO7rBMTAaDEdBDR6yjWkAM3uFkC5BAmtZMknV5ev/vi4XpPgR8sXv/wMnA2oQgwGlr9p+1lm4lJMYxYSyDQL9QNz45IpxM8Czo/t7E37vhnKmoeM/X5j2bNN/IxlSOvCqPhizCynVUy3HkO4oDfPT8ossDfoPyLiQ2kKIfy4KVvwXslGqxdQVlYrObUfFgmSwT1pkAUNHc6tdXzN2b4h/L6wbzBwBIrLqzaWy+vf97IOAQfIjVF6BSj8fX+krhRAG1FlUZiho1L1O91Tb0dHnsMOdU9Xf2YYRXwv4s9BlJ6Bzh0SfujtIXbqWLFhP/cSqjbcw7oTQXsVXjL1r+PahrJ3Hh7y25r4FNlCxnPlS7fmJOVQKeHjtJAPjbT0ctEDvzYMaJkWMJZwDz30jABsWD+IC+XIk8h4frVwxtrc+WGSg+5is9VKCKAgB2qDQliJJ75Umrsn02cvc5zBL8Lj3iE/ci//p+jiQZlsITMbdzNpD7O91KeQu3Kt3N8QZRSgF226DoomCSiwuYVBOKGWDMwmF16+JJIgKlokt16iAaNxvXYKKQ67OcKjGwpUJlBz3rh2+mzpjM70hvld6Ggyrz6egpPh/rE6YoX501Ffoi6ZGDQquYfzEiuVT4TeRdn7+3p4vX6k6/OSjuvmqTkW0GfOyVEIreP2jzNLZ0NLzwjWfKfxnjhyAPo6k3hOTGVDn1bxWpNusW1O5u0sZakOxWdTxlqgDEFxA5if2iGwFMszKSfxN88Bygyd6pKoXfIscxDtMe4p39zSJ/hUGyoFCuispB7xrlAiIqRtciv5EGC+qXoT/6KnvPtMiCSuljt1JYmz5M/lfzHglLQBPosfA7kBbweAh5AYj5Pm7A
 vcG18aH3
 f1ey/+1oZj9Epy6XMoeUcDaDlI2xc7h7iUzRlnwKBRlkRYR3A0ZUzbA3NzaNLYhPme4Fe60bTWhhqyNBD8EJzEr2SjF4brpJIH8E4JPbRcizhlJqhFLtf9SamNjWtK4lZTqP2DStTOwANCKgve3K2n7uuRuZIkRxBf2hedsBNF5EXCJkK2+lFOxZst35/OO70Knjdqv04imfsp1X7SNcOGPrxaIANrGH+IIkV4aBZOcnDMu+b2Wb8zUZ63B5Zud3L5a7SrypaNO2bl5hkkATkRxVuHAqn8/FSZmbU2YIuxQxe8VE2K2MiuXrkuK3kB+S+FF0S2UkIMzdbpsmiZvOJrUdaE+BrI8V6aYejz5qKlz7irXlviFc8zV4416Z6gu6Xr2a6j72OYK8P9MWd3XFIFRRluztifJEmRHX8bU9hlrJyMARZ6xdjMaV0EtVaEDB89hL6qAsK16Cm0MzgY7fd1v//xGaiJUXs3kBffIsVEWSFx8p9Ky/cEqDd4bptMWou1LeI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Describe what KWatch is for, how it compares with KASAN and KFENCE,
the debugfs configuration interface, the watch expression syntax,
how to read hits from the trace buffer (including after a crash),
and the current limitations.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 Documentation/dev-tools/index.rst  |   1 +
 Documentation/dev-tools/kwatch.rst | 193 +++++++++++++++++++++++++++++
 2 files changed, 194 insertions(+)
 create mode 100644 Documentation/dev-tools/kwatch.rst

diff --git a/Documentation/dev-tools/index.rst b/Documentation/dev-tools/index.rst
index 59cbb77b33ff..f4c748da63db 100644
--- a/Documentation/dev-tools/index.rst
+++ b/Documentation/dev-tools/index.rst
@@ -30,6 +30,7 @@ Documentation/process/debugging/index.rst
    ubsan
    kmemleak
    kcsan
+   kwatch
    lkmm/index
    kfence
    kselftest
diff --git a/Documentation/dev-tools/kwatch.rst b/Documentation/dev-tools/kwatch.rst
new file mode 100644
index 000000000000..8ead0beb06b6
--- /dev/null
+++ b/Documentation/dev-tools/kwatch.rst
@@ -0,0 +1,193 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+======================================
+KWatch - Kernel Memory Watchpoint Tool
+======================================
+
+Overview
+========
+
+KWatch is a runtime-configurable debugging tool for locating kernel memory
+corruption. It arms hardware breakpoints (watchpoints) on a target address
+while a chosen function is executing, and reports the exact instruction that
+touches the watched memory, together with a stack trace, through a
+tracepoint.
+
+Unlike shadow-memory sanitizers, KWatch does not detect invalid accesses in
+general; it answers a narrower but common question during corruption hunts:
+"who writes to this address?". This includes in-bounds logical overwrites
+that KASAN cannot see, because the rogue writer modifies valid memory
+through a valid pointer, just at the wrong time or with the wrong data.
+
+Comparison with other tools:
+
+* KASAN detects out-of-bounds and use-after-free accesses, but reports the
+  symptom (the invalid access), not the writer that corrupted the data
+  earlier. It requires a rebuild and has significant CPU and memory
+  overhead, and its redzones perturb memory layout, which can hide
+  timing-sensitive bugs.
+* KFENCE is a low-overhead sampling detector for slab objects; it cannot be
+  pointed at one specific address.
+* Hardware breakpoints via kgdb or perf can watch an address, but only a
+  fixed one, system-wide, for the whole run. KWatch resolves the address
+  dynamically at function entry (for example "argument 2 of this function,
+  plus offset 8, dereferenced once") and disarms it again at function exit,
+  so short-lived and per-invocation objects can be watched too.
+
+KWatch has near-zero overhead while armed: the watched function pays for
+one kprobe/kretprobe pair plus programming of the debug registers; the rest
+of the system runs at full speed.
+
+Requirements
+============
+
+* ``CONFIG_KWATCH=y`` or ``m``. The Kconfig symbol depends on
+  ``CONFIG_PERF_EVENTS``, ``CONFIG_DEBUG_FS`` and an architecture that
+  provides ``HAVE_REINSTALL_HW_BREAKPOINT`` (currently x86 only).
+* Resolving symbol names in watch expressions requires ``CONFIG_KWATCH=y``
+  (built-in); a module can only watch absolute hexadecimal addresses.
+
+Usage
+=====
+
+KWatch is configured through a single debugfs file::
+
+    /sys/kernel/debug/kwatch/config
+
+Writing a configuration string starts a watch session (stopping any previous
+one); reading the file shows the active configuration and hit-rejection
+counters. The configuration is a whitespace-separated list of ``key=value``
+tokens:
+
+=================== ==========================================================
+Key                 Meaning
+=================== ==========================================================
+``func_name``       Function whose execution opens the watch window.
+``func_offset``     Instruction offset inside ``func_name`` at which the
+                    watchpoint is armed (default 0 = function entry).
+``watch_expr``      Expression describing the address to watch (see below).
+``watch_len``       Watched length in bytes: 1, 2, 4 or 8 (default 8).
+``access_type``     0 = write (default), 1 = read, 2 = read/write,
+                    3 = execute.
+``depth``           Recursion depth at which the window opens (default 0).
+``max_watch``       Number of hardware watchpoints to preallocate
+                    (default 4).
+``max_concurrency`` Maximum number of tasks concurrently inside the watch
+                    window (default 256).
+``duration``        For global watches: seconds until automatic stop.
+=================== ==========================================================
+
+Watch expressions
+-----------------
+
+The address to watch is computed at function entry from::
+
+    watch_expr={base}[+-offset][->[+-]offset]...
+
+* ``base`` is one of:
+
+  - ``arg1`` ... ``arg6``: a function argument (register calling
+    convention),
+  - ``stack``: the kernel stack pointer at the probe point,
+  - an absolute hexadecimal address, e.g. ``0xffffffff81234567``,
+  - a global symbol name (built-in KWatch only).
+
+* ``+offset`` / ``-offset`` adjusts the current address.
+* ``->offset`` loads the pointer stored at the current address (via
+  ``get_kernel_nofault()``) and then applies the offset. Up to four chain
+  elements are supported; offsets must be explicit (``->`` alone is
+  rejected).
+
+Given::
+
+    struct some_struct {
+        struct some_struct *ptr;    /* offset 0 */
+        int num;                    /* offset 8 */
+    };
+
+    void target_function(struct some_struct *arg1);
+
+typical expressions are:
+
+=========================== ==============================================
+Expression                  Watches
+=========================== ==============================================
+``watch_expr=arg1``         ``&arg1->ptr`` (the pointer field itself)
+``watch_expr=arg1+8``       ``&arg1->num``
+``watch_expr=arg1->0``      ``&arg1->ptr->ptr`` (one dereference)
+``watch_expr=arg1->8``      ``&arg1->ptr->num``
+``watch_expr=0xffff...+8``  absolute address plus 8
+=========================== ==============================================
+
+Example: catch whoever overwrites ``arg1->num`` of a function while that
+function runs::
+
+    echo "func_name=target_function watch_expr=arg1+8 watch_len=4" \
+        > /sys/kernel/debug/kwatch/config
+
+Watching global variables
+-------------------------
+
+A global variable has no natural function window. When ``duration`` is
+given without ``func_name``, KWatch starts an internal anchor kernel thread
+that sleeps inside a dummy function, and uses that function as the window::
+
+    echo "watch_expr=jiffies_wobble duration=60 watch_len=8" \
+        > /sys/kernel/debug/kwatch/config
+
+The session tears itself down when the duration expires.
+
+Reading hits
+------------
+
+Hits are emitted as the ``kwatch:kwatch_hit`` tracepoint, which is safe in
+NMI-like contexts where printk is not. Each event carries the timestamp,
+the instruction pointer, the watched address and a short stack trace::
+
+    echo 1 > /sys/kernel/debug/tracing/events/kwatch/kwatch_hit/enable
+    cat /sys/kernel/debug/tracing/trace_pipe
+
+If the corruption crashes the machine, the ring buffer can still be
+recovered:
+
+* ``echo 1 > /proc/sys/kernel/ftrace_dump_on_oops`` (or the
+  ``ftrace_dump_on_oops`` boot parameter) dumps the buffer to the console
+  on an oops.
+* With kdump, the buffer is present in the vmcore and can be read with
+  ``crash> trace``.
+* ``CONFIG_PSTORE_FTRACE`` persists it across reboots on supported
+  platforms.
+
+Limitations
+===========
+
+* Functions that run in a genuine NMI(-like) context are rejected at
+  function entry; rejected invocations never open a watch window and are
+  counted in the ``nmi_rejected`` field of the config file. Watching
+  functions reachable from NMI handlers is out of scope.
+* The number of concurrent watchpoints is bounded by the CPU's debug
+  registers (typically 4).
+* If the target address cannot be resolved at arming time (for example a
+  ``get_kernel_nofault()`` failure on a swapped or unmapped page), the
+  watchpoint is not armed for that invocation.
+* Offsets in watch expressions are static; dynamic indexing such as
+  ``arg1->ptr[arg2]`` is not supported.
+* arm64 is not yet supported: stepping over a hit that has a custom
+  overflow handler needs a generic mechanism in the arch code, which is
+  planned as a follow-up series.
+
+Implementation notes
+====================
+
+The implementation lives in ``mm/kwatch/`` and is split into a control
+plane (``core.c``, the debugfs interface), an execution plane (``probe.c``
+and ``deref.c``: kprobe/kretprobe window management and address
+resolution), and a resource plane (``hwbp.c`` and ``task_ctx.c``).
+
+Hardware watchpoints are preallocated as perf events on every CPU and
+re-pointed at hit time with ``modify_wide_hw_breakpoint_local()``, a new
+hw_breakpoint API that updates the breakpoint on the local CPU without
+releasing its slot; other CPUs are updated by asynchronous IPIs. Per-task
+window state is kept in a fixed-size, lockless open-addressing array
+claimed with ``cmpxchg()``, so the hit path performs no allocation and
+takes no locks, which keeps it safe in atomic and NMI-like contexts.
-- 
2.53.0


