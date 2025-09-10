Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C13EACA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 05:34:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D21C8E0023; Wed, 10 Sep 2025 01:34:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1544A8E0001; Wed, 10 Sep 2025 01:34:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01C4E8E0023; Wed, 10 Sep 2025 01:34:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DF5578E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:34:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A575ABAA50
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:34:08 +0000 (UTC)
X-FDA: 83872224576.01.691D13F
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf20.hostedemail.com (Postfix) with ESMTP id C42CE1C000C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:34:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=InXhIfwk;
	spf=pass (imf20.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757482446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4LZ6B57mC2fepOM/oiVWF88xfTVcoYhpKk3jWWiDDz0=;
	b=xHERgfJR0y2sGHo89lH0ML+P54ZMYOR0P5VOtmUrp5R3ubFJgD6rCKltBBMt6J6ov2CC+Y
	4jqeb941BWS3zv8Vat0gxyX80J/Gp7RHwIEHKWwfTK8rC8MmOFyyGM4dXrH4/eWcCHLeuq
	VavMSTEFX9/qvsqRfgBSyerDs47d670=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=InXhIfwk;
	spf=pass (imf20.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757482446; a=rsa-sha256;
	cv=none;
	b=DtSIW7ieHtVLRveqLo6E1yjbuc08EhLtP0dtHn4ZwOooipA3Z/N7PxIqD3WI/LwBTaPeOy
	6x3VqgvvCevkJMEjCUX0raCbdr5/VCX1b+/JqtXuKfxYxD1yundNLQOLYvUS00jSkxXj6D
	LNkX38zyMlSMHzETbDwyPcEInTgrQ4A=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-77246079bc9so7519909b3a.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 22:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757482446; x=1758087246; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4LZ6B57mC2fepOM/oiVWF88xfTVcoYhpKk3jWWiDDz0=;
        b=InXhIfwkxZNev1viy778V0VXevm7hyIN82eKgMzEeGYaP0igj5MXwVbCs7bMKRZeWC
         Uc2tM4Jw1xSTsV2AuI5YjVTI/Ak2L0c0JhPnP97Oa5r2Pi30r+rsM7k/p9gpS2aGDndj
         1xZOHDl7FSEPMj0IWQS3sReSZWxMEZsdMMZxAr1FlT9fTUvFjQIBzrdTCh7K283mhLsD
         Cawxl2tKe9K29RCnTuOXB7MKq50fx1wDDsio06xRpONwdWhKae+KjOWsXy99PSvOqnw2
         pmK+Fq1SjtiCqkn26IDoS3g03XTK5+kmC31KWDARqxkH3Q42fGPhK9Avrpsccbgr6s2i
         5aqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757482446; x=1758087246;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4LZ6B57mC2fepOM/oiVWF88xfTVcoYhpKk3jWWiDDz0=;
        b=OshxCLYFQaujLHD5+wTARMPdbfSJKrnQZiNFWtftM/qZVBOX0wXxeMlXhuKomgtNYQ
         1UTLUV85wV/ho5b8Az4pmLzeIIiDKY2yiGTbso4qQBNp3pHDyXSSqMLoNF+rptgzdRbl
         +rgeumaz3Rdlt/YFNtM7+JDhuUwifZrXAN3vWdyrS6ZAWv9pW8yjLFwNPcnqfLePqw4v
         YKySq/UDvAhjYIwWZOgVCjHUd6RK6D5nDiPzPWcZvnWCmpfxgZRyFKty8Uhq6w3rCCsC
         Cm0YpVpWD773E/3ChTaeNGaUUUqMOXUIEuAamOUOrH4ie/zT++mZ9ePsVBgrF1VofOHd
         +NAg==
X-Forwarded-Encrypted: i=1; AJvYcCVTsFMJNbf2zNZVpXhKUfzaz0oYAd8/tYidAYBgV4zHui8o7xVdmseK9YmQo+3zJ+E0bjDN+f2VgA==@kvack.org
X-Gm-Message-State: AOJu0YyYCCgLZz7rLF6TjLlYqwKuZDAvkVzn01pPLCPZO2SnKlUV2wYv
	gGY0/kwajrdrSNwQJwkdr2xi+CF1YVhe3+EP/T75/0AQN8Qjelf33+TZ
X-Gm-Gg: ASbGncs0bgEWMWShurvXXF1yXT1ZtkK5lMC2k1XgP3gFXCz6Yj2Q12R4jQ/t3ubpQVE
	jVP6VyH0xs5YM69wnNkqTRs+UYdydqmNy6vDGMbZEGyldClsQ+u9/j/Z+Gd9+LQDbXAyKsQwpaj
	Op3+9R8WFwMIfo9XEnRu6bzhKwr3WiGW9mS/n8tG/hbTG+nl1FnYAo/nhIeVbYyF4u3HuZGVvYf
	zPZt4Ryn9wPKpgrauPUVvWVm2p0dMoPxqNszCiCUM69SO4XKS5mE3avdqq5eMtU3DHOgHPBtojD
	1DwM11yRjpQkOxwFar/a4Uydf4lsOyvPhaAAVazoAB8Ssn+8U5zR+inqa4VMYt9g6sEkafUMPgO
	/YvdEYRC95DxN2qqeLYJz6Aw54L9iVfxKV2Ntk89gK8egtt7S/2W2/Enyah5u
X-Google-Smtp-Source: AGHT+IE5Rq1rrzJXAUxF3Qk/Dgi7jghuqZ6IFego4Tk4Ip7IXws9wM59yr3GJE3aEhSdjZsId8DOtQ==
X-Received: by 2002:a05:6a20:3d8b:b0:251:7f83:11cd with SMTP id adf61e73a8af0-2533e5732famr20377356637.11.1757482445592;
        Tue, 09 Sep 2025 22:34:05 -0700 (PDT)
Received: from localhost.localdomain ([45.8.220.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7746628ffbesm3870342b3a.66.2025.09.09.22.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 22:34:05 -0700 (PDT)
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
Subject: [PATCH v3 19/19] docs: add KStackWatch document
Date: Wed, 10 Sep 2025 13:31:17 +0800
Message-ID: <20250910053147.1152253-11-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250910053147.1152253-1-wangjinchao600@gmail.com>
References: <20250910052335.1151048-1-wangjinchao600@gmail.com>
 <20250910053147.1152253-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C42CE1C000C
X-Stat-Signature: ep3om596x7us9wxnktzg9mz6mx7r7btn
X-HE-Tag: 1757482446-8041
X-HE-Meta: U2FsdGVkX19wAmg8HO+x7ipW66XlrAKRRPgkuyqrEdIDVSsdMaqAdyfANIKr7vASnB4EqyOZiEOVuNyu120uDNIE4v6w627qtUzDpDotE9wWDZzERohd3kZIbnX5yCmje9sZA+HkupbuzwBs+jRTliBKp5pgIrwcTHQHRjIhhNEhiB6a0Ua2mnP4Q6eCCD+ZmNnGCr2sBqvqiwrvrQBNI97uBvW+PVnOXo0zI4YeEn9Pwu//Uara7g2vdkO9cqvi0zBLcG3SThFfxdmu5BR2GryVCFSoScHnyZM01/ME5jRcMeypkN2YwYasX7SIdUgIO4Mh36B1koKgHOZoYC+uJYNHHdGzrTZqjoRg2tL1O2Ftq/fRe9aI28NEpPsgulqMTizu+znUtAnOUYVRxWmx59QpG8+2FI9lWScxEBQn+VH+PzPcGwUd/qGdf1/na3AogvdtgT6QEDBnkvwWmqMbPUL7Ro3HgMso3X3CvQSg+rQOD+zjwH57eOOUzciA5lwJVI/Smzc2ZDsIY1OUrbhHE7oguMm1DS38VV8nhcZj7XZ/KPZyqotq8RExz2VommOft60Xj2owj0epJiyoPql8O3r4Ka/7cByD6kEEL5aQwqui1Yld1q/PgH0Grfl38YTKahTT5W3TA0XrR/ffKgUXeHdQfQHP9KMC4Mm8RLTQ5RhX0tWEerimkzvPDzd8xkf2RXQ9QtcbautLyXiezTy2JnkFitqtPeXSm9iLjLIqHXwt+2lkheyeGU+HV8NhYA/Ha+Hc1iE3sjPjKZ9t4FK2X/q/XqEww1rrxll5qhQsPDfsy7q+orTk9wqQj1xXIg8J+IUtl33zLrdzXH4rP6nIqw7sc/DxpcDu5boPnAZFO/R0aCxXrXgnsWtjar2NvqvtZbbmMNonEL80FrERMB/SH1LAEgGM3riCBbGcvuE/wDnS/ga0/bMfzpEKGG0zYMw9kOX4V8cYDaglndB1gyN
 3IlDaDEI
 tB1AePqw/daI/Rc0Lz9d73g4YeaDGOCZ5+bxa4kXtPRCI4p9O/ZKMUIX2ILfJJ8orA4bPmhxus89mtogPt5pDvPRDExXkvqA+xvM8VejGr/YsbRDLZnwtWlXbMixnSf1RsNLOlSdej86D+TRvF4VQIthi7tiUowqh3pJV78mPhsFxXuNcFMEzvkPFQw3N5n7FkjHIb9FsjJpS+vWQ/uPLedktftDd+uXUfvExbBZU9T3T2ekwXgwUws6U+B7WP5NiClfyBJeY3UhVkzu6O3QN7YQT8kRLw9O4QKLzFXs5iucUUrirg6qlXdn1UHk9ZXIWYHh+FVbOUXYGNEWWo4lPtIincJ+XKsZNcmwiQMf/uTZnXJbG4hah/uD9V6+rVKay5d+4/2CvQNPENESf515Rdwi8/8OfDDlYTHmFoF1+lz8mNsFX/rfeCgXzeUNNDA1xQPOGi2A5s82u1jdXCjzq3qBAbULqW1hWPTBUGSzKWxRrMtNSLwzcxNwf4FBzlS0machDydpYaiknA0zX1GUPcfP/XGsojm9AObcGA+VjDswLxrctpYcgWTDqOuomPuTrj/3kz65DMeyE3yMyDBSaXxddOg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new documentation file for KStackWatch, explaining its
purpose, motivation, key features, configuration format, module parameters,
implementation notes, limitations, and testing instructions.

Update MAINTAINERS to include Jinchao Wang as the maintainer for associated
files.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 Documentation/dev-tools/kstackwatch.rst | 94 +++++++++++++++++++++++++
 MAINTAINERS                             |  7 ++
 2 files changed, 101 insertions(+)
 create mode 100644 Documentation/dev-tools/kstackwatch.rst

diff --git a/Documentation/dev-tools/kstackwatch.rst b/Documentation/dev-tools/kstackwatch.rst
new file mode 100644
index 000000000000..f741de08ca56
--- /dev/null
+++ b/Documentation/dev-tools/kstackwatch.rst
@@ -0,0 +1,94 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+====================================
+KStackWatch: Kernel Stack Watch
+====================================
+
+Overview
+========
+KStackWatch is a lightweight debugging tool designed to detect
+kernel stack corruption in real time. It helps developers capture the
+moment corruption occurs, rather than only observing a later crash.
+
+Motivation
+==========
+Stack corruption may originate in one function but manifest much later
+with no direct call trace linking the two. This makes such issues
+extremely difficult to diagnose. KStackWatch addresses this by combining
+hardware breakpoints with kprobe and fprobe instrumentation, monitoring
+stack canaries or local variables at the point of corruption.
+
+Key Features
+============
+- Lightweight overhead:
+   Minimal runtime cost, preserving bug reproducibility.
+- Real-time detection:
+  Detect stack corruption immediately.
+- Flexible configuration:
+  Control via a procfs interface.
+- Depth filtering:
+  Optional recursion depth tracking per task.
+
+Configuration
+=============
+The control file is created at::
+
+  /proc/kstackwatch
+
+To configure, write a string in the following format::
+
+  function+ip_offset[+depth] [local_var_offset:local_var_len]
+    - function         : name of the target function
+    - ip_offset        : instruction pointer offset within the function
+    - depth            : recursion depth to watch, starting from 0
+    - local_var_offset : offset from the stack pointer at function+ip_offset
+    - local_var_len    : length of the local variable(1,2,4,8)
+
+Fields
+------
+- ``function``:
+  Name of the target function to watch.
+- ``ip_offset``:
+  Instruction pointer offset within the function.
+- ``depth`` (optional):
+  Maximum recursion depth for the watch.
+- ``local_var_offset:local_var_len`` (optional):
+  A region of a local variable to monitor, relative to the stack pointer.
+  If not given, KStackWatch monitors the stack canary by default.
+
+Examples
+--------
+1. Watch the canary at the entry of ``canary_test_write``::
+
+     echo 'canary_test_write+0x12' > /proc/kstackwatch
+
+2. Watch a local variable of 8 bytes at offset 0 in
+   ``silent_corruption_victim``::
+
+     echo 'silent_corruption_victim+0x7f 0:8' > /proc/kstackwatch
+
+Module Parameters
+=================
+``panic_on_catch`` (bool)
+  - If true, trigger a kernel panic immediately on detecting stack
+    corruption.
+  - Default is false (log a message only).
+
+Implementation Notes
+====================
+- Hardware breakpoints are preallocated at watch start.
+- Function exit is monitored using ``fprobe``.
+- Per-task depth tracking is used to handle recursion across scheduling.
+- The procfs interface allows dynamic reconfiguration at runtime.
+- Active state is cleared before applying new settings.
+
+Limitations
+===========
+- Only one active watch can be configured at a time (singleton).
+- Local variable offset and size must be known in advance.
+
+Testing
+=======
+KStackWatch includes a companion test module (`kstackwatch_test`) and
+a helper script (`kstackwatch_test.sh`) to exercise different stack
+corruption scenarios:
diff --git a/MAINTAINERS b/MAINTAINERS
index cd7ff55b5d32..076512afddcc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13355,6 +13355,13 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest.git
 F:	Documentation/dev-tools/kselftest*
 F:	tools/testing/selftests/
 
+KERNEL STACK WATCH
+M:	Jinchao Wang <wangjinchao600@gmail.com>
+S:	Maintained
+F:	Documentation/dev-tools/kstackwatch.rst
+F:	mm/kstackwatch/
+F:	tools/kstackwatch/
+
 KERNEL SMB3 SERVER (KSMBD)
 M:	Namjae Jeon <linkinjeon@kernel.org>
 M:	Namjae Jeon <linkinjeon@samba.org>
-- 
2.43.0


