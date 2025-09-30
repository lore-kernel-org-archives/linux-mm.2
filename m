Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90F4DCAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 02:46:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E614D8E0037; Mon, 29 Sep 2025 22:46:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E117D8E0002; Mon, 29 Sep 2025 22:46:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB2D98E0037; Mon, 29 Sep 2025 22:46:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B0B1B8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:46:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 596FB59993
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:46:10 +0000 (UTC)
X-FDA: 83944377300.04.4A05913
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 58CE81C0006
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:46:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YroXC541;
	spf=pass (imf21.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759200368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9bGi3tzoowdq7F8N73OupFeSpGLIzMxuMKRIXFA+k0I=;
	b=2lWSWM4mcL1fhwuRgGvP29zr7VmwJasLAtvYSieZ3WLVN+VhWwDR8n25yx+KJjDq2Eq2PP
	HtUZFFJR96NuR76w9SI321A4diWdQfCNoqK4w/xpEv3y4/BzTU7LLdgogwCivyKN3hne4N
	WnJNfcj8ctwt6a/cQBgKV7/Fze75FEc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YroXC541;
	spf=pass (imf21.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759200368; a=rsa-sha256;
	cv=none;
	b=nZrP+jbvI0gThrA3WkPLiuIC8Xeyp/sBzarL/uuBzJTNmqi+fncKuFG4f6SYRLfHXbePGZ
	V5zWHJ963y3zOEhmvDKKDptCQdWRqyEGP3hhIGuYJJ0Ci0q5AokUsrJg+70vjqRcrMCTS1
	S75tOEHnHfobhLDCeCTFP75jVQMkyWQ=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b5515eaefceso5236724a12.2
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 19:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759200367; x=1759805167; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9bGi3tzoowdq7F8N73OupFeSpGLIzMxuMKRIXFA+k0I=;
        b=YroXC5416rNdKre8BTYUcS6nmrzCFZsAPASCLSAWySbPS/RGjfG7XYsf4GuHVLWh2C
         WRD3d7fr2R7+6MQJHHwSsMsPYaGR+VdJ4Hwa+V/W5ugZ4J8RyS4S0iqy1kjPqj9ixdHL
         DxUXx7UHwyhpU/cJ1IDMEiV2DVFdMhz1CyzwgWSRkzD5P6TCg1IUUGJdcrtFIMbdFWuU
         zO47XewWy9Ifp8f/D3HLkXUPJC1dAv/2qCVrDim21CAdYYjfcztEiWUvuv0ez8hHZB48
         XzvUORbr/1LSab4f6RqFNcU1tTOPi/RR7swq3ONCYhnb3j75My1eV9Rp7zSICTZXSdug
         gGxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759200367; x=1759805167;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9bGi3tzoowdq7F8N73OupFeSpGLIzMxuMKRIXFA+k0I=;
        b=r+K7qHsE63el47gRDA7wzQZDN/+KaxAbqbe2RLdiHT+9uNVjwQyXFcrSsEQZOEbafm
         5kooNm7QoDMQZHEFQb0UvoUa6zokVFPEmtSk/Qvty8dRiFVS7SitzydfTyU9w1sLT68Y
         iacZsvsbXDe0E5FqpM+ZGhlpvIELJNot3Ve7WcQCy9piWGMjhw4N41zAS4gDkzC3kjpH
         I/MAX3oeHUo5zBsR3z9nSo9a6jDHl1rBHHXwWtW0Zx3BomW3ZxCS9qZemnI1D2/cL6Xy
         VPK6lG16eWK/MnvUKfmdqqljQ8LQmTgg9JUaD9YzC/fud+VTSbpxDHtkiiK+2/M9d9Ok
         JrsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVos+Ar+JAsObzdD2ews8WRZ6kUgBhJJJ5gu5zAe8syxfpLlJ0rDlETdJx/rj3NgrjFXCiD/bh8Xw==@kvack.org
X-Gm-Message-State: AOJu0YyJAys8WDZ+BSyiYKnJ/tMepT0Jq2MuDLGJZONvgB4uAEqwyIpo
	mTlsWUhzlPWEHlOTr3TtoJ79bMNqHgMSPgrG3K8mrraeOpc3OomArE+w
X-Gm-Gg: ASbGncu+y2wSTtqvsO/6QgKkLKpVEow8P/tRnRGFQ6MGfS4pgcNguf2io0TMS3TEVEU
	XRUEEz7KjSfTyIqtetEK8EpAy8kz6VMZY59VS+/9r45EkIbqnkY3mFVL6/xST76Khg6I5381VH3
	Oncxv0+qnt+a3dz/OjtryeAcgBkZX8Q9RUStwKRwcv9Q9KIrW0CT/Q2qIP0I2KIRx7gZ0uTvSaN
	GK0SUPeIgPpkzE8EVC3UjlbZbZkie+Bp5zdZ3RywnlYWd3SMFbHk6K6zVwwL5pEWPQCjZftPCMj
	oAGJyYfPLSvQdnZVQ6JQKGHDmPH9r1clHl6zckrKTJoSplccRPMU5CKL0XPlJiAYzAvjKcPSPc6
	2tB39XjRz+GvUOp5KwRtJd7IiMAt5+xi0GQjKjP6rf6tc3W6S9u/SUAo9aHZDfg7g5sI4mREGvi
	4u
X-Google-Smtp-Source: AGHT+IFoiKVgZ7dg//OuhMhm/v5is/JKhf1lFey82Z71vebCWO6695PgeZ0Sr0qvIyrxcwzNDU9ePQ==
X-Received: by 2002:a17:903:2ace:b0:268:f83a:835a with SMTP id d9443c01a7336-27ed4a64485mr174059075ad.60.1759200367052;
        Mon, 29 Sep 2025 19:46:07 -0700 (PDT)
Received: from localhost ([45.142.167.196])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed6881fcasm144484295ad.93.2025.09.29.19.46.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 19:46:06 -0700 (PDT)
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
Subject: [PATCH v6 22/23] docs: add KStackWatch document
Date: Tue, 30 Sep 2025 10:43:43 +0800
Message-ID: <20250930024402.1043776-23-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250930024402.1043776-1-wangjinchao600@gmail.com>
References: <20250930024402.1043776-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 58CE81C0006
X-Stat-Signature: czx1yaf4kpdi3ppxtw7pcc1pi7cdfzpa
X-HE-Tag: 1759200368-150284
X-HE-Meta: U2FsdGVkX1/gAcS5mKNhpQFh1KixE+Ph0gNGGr1dl0mw1AmOHCzyTwOAOhEbZoLagghn6IBCpCFg1MnsnhR+AGe9jw4W82W6ZD36JXBi2mmcXA/572zQiXA4Z13jOzZfO2K39LBaBSd6VCofLVbdX9blFIEVyptWih8tDjpjvMNz7m/+2g514jLbGPUsoC0gYXOWjPrVkfqfoFz0GJP+7TMUIR8QdWsMYxv4yfGKEmsb1hsNSv6IJIJ1ZBSvWobD5ncbudrTfx2XlQYjja3OQAF66cfXaRlcIxc2P6QdKiUmFak5hEJvh/eu/zi+0VDW+mUYXo2tZDhVgapMiHJBwf9at7wEY9LNjUucYHhuceJHjGyHYk9S+74qElJf566Vjsd8eb9ObomTY5DcgvvwCA9qEtDCrPzJ8/xKfZgJQlz1mpWvBN2erMes395isnPOfMvYjFHTyxaaP0OrXpVCG76HaNv759xGYYGQTuAklL+yyV+G01P+1E8EErnF3gBfakpRD8v1VOtvGgFcyYI0oXUDbnk+yo2clnJyxXHTjAb3HI8i7mHMSicTg00iQ30GLmLNSf3gQfl6Ky1JwZ/BZDaFU6hE96pQPWZXyVrtP1SWdxdFlIO9yPeDK1FkvMV0Y8yArUi/VdGcaEXl8tqb9AmbbGTgRxvKTF1scKoPbPJ3xk+4FQmn9rcvYJgKkhPGpFupk+/XTCLpNSi5g7m/3QVIeSLR4muVUoYOeBprvCYV/GLNLrSv6KlSAhhpkQRnUhTLPK6VTcU8MuZ4WArjymWVvN07n8CeDHa8kjmyjUs0kCvMzEh2y6a2uOogvzjyE+ob4eKP+rVh5xo8rQhkFr68p8gZimwsGHk4SHGZBTRXoNTs9auCSP8e7atrRMo3t3p7bbZc/0yxkQPDyEBo6BPCPb/uecgIdpb7+AkfQcJTr3XrS61xKM9LEavZTSDQo25jlwNXvfR0i3RyYeO
 6MwFux9Y
 1N1bmBZBfSrfz7Yd9VLwbaaa8grEI1fONzbZgpGTY++bWa00FYBstJRGOm7KeaMLFF5eky0wWZN/PYXnBMqdjWg4HtptXjVKw4zJkm4l3KJXdibyw3dteQa1q38W/7BaCkJMBKMCOr+FMEp+W/PAk56Xw2Nt4VG4DxA9MCLNlPNND/D1iAKnkoxITFL0KUCN2m6PQH62dqz2vrbImaELNlGefmOygnU3Z/lSESBaBRaA8aUEhFtfefH+h05TDatsxivlIPR9KU80VRbXkwVwo7jI0A1qlcGupqlY3dfowR7z/VONa0ewB4xwZQbrnWdH2lBy7p7LMB+TK0EdBBZqqzyzp76iUOOrODp0VCFoY10FZdY+Yf6A/d+70QOfMnLneXGdqrD7dPvYWaZhQSLhybEPViIUjpdzKlSmPcfsPyYWVdTlM3mvDmG3p7IBjvVEHJl8APwbaM+Xe4Wh86BIjq/+LkK6ve4nZ6vt0i4hbgmwNMgXO9Q0yKsDk3jQrEwNfVBmXd6mZgmp3YHylfQcWf67z2Rz3ayc5jvsVsm6xzB0xla1VR11MVTZapw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add documentation for KStackWatch under Documentation/.

It provides an overview, main features, usage details, configuration
parameters, and example scenarios with test cases. The document also
explains how to locate function offsets and interpret logs.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 Documentation/dev-tools/index.rst       |   1 +
 Documentation/dev-tools/kstackwatch.rst | 314 ++++++++++++++++++++++++
 2 files changed, 315 insertions(+)
 create mode 100644 Documentation/dev-tools/kstackwatch.rst

diff --git a/Documentation/dev-tools/index.rst b/Documentation/dev-tools/index.rst
index 65c54b27a60b..45eb828d9d65 100644
--- a/Documentation/dev-tools/index.rst
+++ b/Documentation/dev-tools/index.rst
@@ -31,6 +31,7 @@ Documentation/process/debugging/index.rst
    kcsan
    kfence
    kselftest
+   kstackwatch
    kunit/index
    ktap
    checkuapi
diff --git a/Documentation/dev-tools/kstackwatch.rst b/Documentation/dev-tools/kstackwatch.rst
new file mode 100644
index 000000000000..7100248bc130
--- /dev/null
+++ b/Documentation/dev-tools/kstackwatch.rst
@@ -0,0 +1,314 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=================================
+Kernel Stack Watch (KStackWatch)
+=================================
+
+Overview
+========
+
+KStackWatch is a lightweight debugging tool designed to detect kernel stack
+corruption in real time. It installs a hardware breakpoint (watchpoint) at a
+function's specified offset using *kprobe.post_handler* and removes it in
+*fprobe.exit_handler*. This covers the full execution window and reports
+corruption immediately with time, location, and call stack.
+
+Main features:
+
+* Immediate and precise detection
+* Supports concurrent calls to the watched function
+* Lockless design, usable in any context
+* Depth filter for recursive calls
+* Minimal impact on reproducibility
+* Flexible configuration with key=val syntax
+
+Usage
+=====
+
+KStackWatch is configured through */sys/kernel/debug/kstackwatch/config* using a
+key=value format. Both long and short forms are supported. Writing an empty
+string disables the watch.
+
+.. code-block:: bash
+
+	# long form
+	echo func_name=? func_offset=? ... > /sys/kernel/debug/kstackwatch/config
+
+	# short form
+	echo fn=? fo=? ... > /sys/kernel/debug/kstackwatch/config
+
+	# disable
+	echo > /sys/kernel/debug/kstackwatch/config
+
+The func_name and the func_offset where the watchpoint should be placed must be
+known. This information can be obtained from *objdump* or other tools.
+
+Required parameters
+--------------------
+
++--------------+--------+-----------------------------------------+
+| Parameter    | Short  | Description                             |
++==============+========+=========================================+
+| func_name    | fn     | Name of the target function             |
++--------------+--------+-----------------------------------------+
+| func_offset  | fo     | Instruction pointer offset              |
++--------------+--------+-----------------------------------------+
+
+Optional parameters
+--------------------
+
+Default 0 and can be omitted.
+Both decimal and hexadecimal are supported.
+
++--------------+--------+------------------------------------------------+
+| Parameter    | Short  | Description                                    |
++==============+========+================================================+
+| depth        | dp     | Recursion depth filter                         |
++--------------+--------+------------------------------------------------+
+| max_watch    | mw     | Maximum number of concurrent watchpoints       |
+|              |        | (default 0, capped by available hardware       |
+|              |        | breakpoints)                                   |
++--------------+--------+------------------------------------------------+
+| sp_offset    | so     | Watching addr offset from stack pointer        |
++--------------+--------+------------------------------------------------+
+| watch_len    | wl     | Watch length in bytes (1, 2, 4, 8, or 0),      |
+|              |        | 0 means automatically watch the stack canary   |
+|              |        | and ignore the sp_offset parameter             |
++--------------+--------+------------------------------------------------+
+
+Workflow Example
+================
+
+Silent corruption
+-----------------
+
+Consider *test3* in *kstackwatch_test.sh*. Run it directly:
+
+.. code-block:: bash
+
+	echo test3 >/sys/kernel/debug/kstackwatch/test
+
+Sometimes, *test_mthread_victim()* may report as unhappy:
+
+.. code-block:: bash
+
+	[    7.807082] kstackwatch_test: victim[0][11]: unhappy buf[8]=0xabcdabcd
+
+Its source code is:
+
+.. code-block:: c
+
+	static void test_mthread_victim(int thread_id, int seq_id, u64 start_ns)
+	{
+		ulong buf[BUFFER_SIZE];
+
+		for (int j = 0; j < BUFFER_SIZE; j++)
+			buf[j] = 0xdeadbeef + seq_id;
+
+		if (start_ns)
+			silent_wait_us(start_ns, VICTIM_MINIOR_WAIT_NS);
+
+		for (int j = 0; j < BUFFER_SIZE; j++) {
+			if (buf[j] != (0xdeadbeef + seq_id)) {
+				pr_warn("victim[%d][%d]: unhappy buf[%d]=0x%lx\n",
+					thread_id, seq_id, j, buf[j]);
+				return;
+			}
+		}
+
+		pr_info("victim[%d][%d]: happy\n", thread_id, seq_id);
+	}
+
+From the source code, the report indicates buf[8] was unexpectedly modified,
+a case of silent corruption.
+
+Configuration
+-------------
+
+Since buf[8] is the corrupted variable, the following configuration shows
+how to use KStackWatch to detect its corruption.
+
+func_name
+~~~~~~~~~~~
+
+As seen, buf[8] is initialized and modified in *test_mthread_victim*\(\) ,
+which sets *func_name*.
+
+func_offset & sp_offset
+~~~~~~~~~~~~~~~~~~~~~~~~~
+The watchpoint should be set after the assignment and as close as
+possible, which sets *func_offset*.
+
+The watchpoint should be set to watch buf[8], which sets *sp_offset*.
+
+Use the objdump output to disassemble the function:
+
+.. code-block:: bash
+
+	objdump -S --disassemble=test_mthread_victim vmlinux
+
+A shortened output is:
+
+.. code-block:: text
+
+	static void test_mthread_victim(int thread_id, int seq_id, u64 start_ns)
+	{
+	ffffffff815cb4e0:       e8 5b 9b ca ff          call   ffffffff81275040 <__fentry__>
+	ffffffff815cb4e5:       55                      push   %rbp
+	ffffffff815cb4e6:       53                      push   %rbx
+	ffffffff815cb4e7:       48 81 ec 08 01 00 00    sub    $0x108,%rsp
+	ffffffff815cb4ee:       89 fd                   mov    %edi,%ebp
+	ffffffff815cb4f0:       89 f3                   mov    %esi,%ebx
+	ffffffff815cb4f2:       49 89 d0                mov    %rdx,%r8
+	ffffffff815cb4f5:       65 48 8b 05 0b cb 80    mov    %gs:0x280cb0b(%rip),%rax        # ffffffff83dd8008 <__stack_chk_guard>
+	ffffffff815cb4fc:       02
+	ffffffff815cb4fd:       48 89 84 24 00 01 00    mov    %rax,0x100(%rsp)
+	ffffffff815cb504:       00
+	ffffffff815cb505:       31 c0                   xor    %eax,%eax
+		ulong buf[BUFFER_SIZE];
+	ffffffff815cb507:       48 89 e2                mov    %rsp,%rdx
+	ffffffff815cb50a:       b9 20 00 00 00          mov    $0x20,%ecx
+	ffffffff815cb50f:       48 89 d7                mov    %rdx,%rdi
+	ffffffff815cb512:       f3 48 ab                rep stos %rax,%es:(%rdi)
+
+		for (int j = 0; j < BUFFER_SIZE; j++)
+	ffffffff815cb515:       eb 10                   jmp    ffffffff815cb527 <test_mthread_victim+0x47>
+			buf[j] = 0xdeadbeef + seq_id;
+	ffffffff815cb517:       8d 93 ef be ad de       lea    -0x21524111(%rbx),%edx
+	ffffffff815cb51d:       48 63 c8                movslq %eax,%rcx
+	ffffffff815cb520:       48 89 14 cc             mov    %rdx,(%rsp,%rcx,8)
+	ffffffff815cb524:       83 c0 01                add    $0x1,%eax
+	ffffffff815cb527:       83 f8 1f                cmp    $0x1f,%eax
+	ffffffff815cb52a:       7e eb                   jle    ffffffff815cb517 <test_mthread_victim+0x37>
+		if (start_ns)
+	ffffffff815cb52c:       4d 85 c0                test   %r8,%r8
+	ffffffff815cb52f:       75 21                   jne    ffffffff815cb552 <test_mthread_victim+0x72>
+			silent_wait_us(start_ns, VICTIM_MINIOR_WAIT_NS);
+	...
+	ffffffff815cb571:       48 8b 84 24 00 01 00    mov    0x100(%rsp),%rax
+	ffffffff815cb579:       65 48 2b 05 87 ca 80    sub    %gs:0x280ca87(%rip),%rax        # ffffffff83dd8008 <__stack_chk_guard>
+	...
+	ffffffff815cb5a1:       eb ce                   jmp    ffffffff815cb571 <test_mthread_victim+0x91>
+	}
+	ffffffff815cb5a3:       e8 d8 86 f1 00          call   ffffffff824e3c80 <__stack_chk_fail>
+
+
+func_offset
+^^^^^^^^^^^
+
+The function begins at ffffffff815cb4e0. The *buf* array is initialized in a loop.
+The instruction storing values into the array is at ffffffff815cb520, and the
+first instruction after the loop is at ffffffff815cb52c.
+
+Because KStackWatch uses *kprobe.post_handler*, the watchpoint can be
+set right after ffffffff815cb520. However, this will cause false positive
+because the watchpoint is active before buf[8] is assigned.
+
+An alternative is to place the watchpoint at ffffffff815cb52c, right
+after the loop. This avoids false positives but leaves a small window
+for false negatives.
+
+In this document, ffffffff815cb52c is chosen for cleaner logs. If false
+negatives are suspected, repeat the test to catch the corruption.
+
+The required offset is calculated from the function start:
+
+*func_offset* is 0x4c (ffffffff815cb52c - ffffffff815cb4e0).
+
+sp_offset
+^^^^^^^^^^^
+
+From the disassembly, the buf array is at the top of the stack,
+meaning buf == rsp. Therefore, buf[8] sits at rsp + 8 * sizeof(ulong) =
+rsp + 64. Thus, *sp_offset* is 64.
+
+Other parameters
+~~~~~~~~~~~~~~~~~~
+
+* *depth* is 0, as test_mthread_victim is not recursive
+* *max_watch* is 0 to use all available hwbps
+* *watch_len* is 8, the size of a ulong on x86_64
+
+Parameters with a value of 0 can be omitted as defaults.
+
+Configure the watch:
+
+.. code-block:: bash
+
+	echo "fn=test_mthread_victim fo=0x4c so=64 wl=8" > /sys/kernel/debug/kstackwatch/config
+
+Now rerun the test:
+
+.. code-block:: bash
+
+	echo test3 >/sys/kernel/debug/kstackwatch/test
+
+The dmesg log shows:
+
+.. code-block:: text
+
+	[    7.607074] kstackwatch: ========== KStackWatch: Caught stack corruption =======
+	[    7.607077] kstackwatch: config fn=test_mthread_victim fo=0x4c so=64 wl=8
+	[    7.607080] CPU: 2 UID: 0 PID: 347 Comm: corrupting Not tainted 6.17.0-rc7-00022-g90270f3db80a-dirty #509 PREEMPT(voluntary)
+	[    7.607083] Call Trace:
+	[    7.607084]  <#DB>
+	[    7.607085]  dump_stack_lvl+0x66/0xa0
+	[    7.607091]  ksw_watch_handler.part.0+0x2b/0x60
+	[    7.607094]  ksw_watch_handler+0xba/0xd0
+	[    7.607095]  ? test_mthread_corrupting+0x48/0xd0
+	[    7.607097]  ? kthread+0x10d/0x210
+	[    7.607099]  ? ret_from_fork+0x187/0x1e0
+	[    7.607102]  ? ret_from_fork_asm+0x1a/0x30
+	[    7.607105]  __perf_event_overflow+0x154/0x570
+	[    7.607108]  perf_bp_event+0xb4/0xc0
+	[    7.607112]  ? look_up_lock_class+0x59/0x150
+	[    7.607115]  hw_breakpoint_exceptions_notify+0xf7/0x110
+	[    7.607117]  notifier_call_chain+0x44/0x110
+	[    7.607119]  atomic_notifier_call_chain+0x5f/0x110
+	[    7.607121]  notify_die+0x4c/0xb0
+	[    7.607123]  exc_debug_kernel+0xaf/0x170
+	[    7.607126]  asm_exc_debug+0x1e/0x40
+	[    7.607127] RIP: 0010:test_mthread_corrupting+0x48/0xd0
+	[    7.607129] Code: c7 80 0a 24 83 e8 48 f1 f1 00 48 85 c0 74 dd eb 30 bb 00 00 00 00 eb 59 48 63 c2 48 c1 e0 03 48 03 03 be cd ab cd ab 48 89 30 <83> c2 01 b8 20 00 00 00 29 c8 39 d0 7f e0 48 8d 7b 10 e8 d1 86 d4
+	[    7.607130] RSP: 0018:ffffc90000acfee0 EFLAGS: 00000286
+	[    7.607132] RAX: ffffc90000a13de8 RBX: ffff888102d57580 RCX: 0000000000000008
+	[    7.607132] RDX: 0000000000000008 RSI: 00000000abcdabcd RDI: ffffc90000acfe00
+	[    7.607133] RBP: ffff8881085bc800 R08: 0000000000000001 R09: 0000000000000000
+	[    7.607133] R10: 0000000000000001 R11: 0000000000000000 R12: ffff888105398000
+	[    7.607134] R13: ffff8881085bc800 R14: ffffffff815cb660 R15: 0000000000000000
+	[    7.607134]  ? __pfx_test_mthread_corrupting+0x10/0x10
+	[    7.607137]  </#DB>
+	[    7.607138]  <TASK>
+	[    7.607138]  kthread+0x10d/0x210
+	[    7.607140]  ? __pfx_kthread+0x10/0x10
+	[    7.607141]  ret_from_fork+0x187/0x1e0
+	[    7.607143]  ? __pfx_kthread+0x10/0x10
+	[    7.607144]  ret_from_fork_asm+0x1a/0x30
+	[    7.607147]  </TASK>
+	[    7.607147] kstackwatch: =================== KStackWatch End ===================
+	[    7.807082] kstackwatch_test: victim[0][11]: unhappy buf[8]=0xabcdabcd
+
+The line ``RIP: 0010:test_mthread_corrupting+0x48/0xd0`` shows the exact
+location where the corruption occurred. Now that the ``corrupting()`` function has
+been identified, it is straightforward to trace back to ``buggy()`` and fix the bug.
+
+
+More usage examples and corruption scenarios are provided in
+``kstackwatch_test.sh`` and ``mm/kstackwatch/test.c``.
+
+Limitations
+===========
+
+* Limited by available hardware breakpoints
+* Only one function can be watched at a time
+* Canary search limited to 128 * sizeof(ulong) from the current stack
+  pointer. This is sufficient for most cases, but has three limitations:
+
+  - If the stack frame is larger, the search may fail.
+  - If the function does not have a canary, the search may fail.
+  - If stack memory occasionally contains the same value as the canary,
+    it may be incorrectly matched.
+
+  In these cases, the user can provide the canary location using
+  ``sp_offset``, or treat any memory in the function prologue
+  as the canary.
-- 
2.43.0


