Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F424CD13D2
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:38:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10F848E0053; Mon, 10 Nov 2025 11:38:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F191C8E0003; Mon, 10 Nov 2025 11:38:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D92178E0053; Mon, 10 Nov 2025 11:38:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB41C8E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:38:41 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F344C0185
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:38:41 +0000 (UTC)
X-FDA: 84095256042.01.8DB8CA6
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9660F40015
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:38:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JLWjEBts;
	spf=pass (imf17.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762792719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1OccL0Sq4R/RA62B7XB61l1HOYHt90e9E66Mfl8uInY=;
	b=BppFGeUV4XVMe/wxzPRF8SyXea5y/OprsEXrtd3tZvT/qJ3FW8rUKOsn8QQ2VKANEinJpH
	H/x2XRtwSM5GlTKXjj8FEogyDSGsrbbpEmY6n7/+zmqV8zQCELhEs1zyWUfJhqPi2Rbwqo
	5hicZIyQe4vuYytmJK0vjV9OZcY/qDY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762792719; a=rsa-sha256;
	cv=none;
	b=Lx/NCdt0RfOlmhHAMxAVMotFQJEEYLkt6RQfF5bht9nJYOjMaxp7gT6d4fI8taI+R1yym2
	pwS8qIWNig6xHAOHdaGb5qoRda1ayXYStvNQuWxDHywqekD5FleMPT88/O6DuXWNT7Ixpa
	mo0wa5YeaEj+hX9LUu+XHRP1Jxx7wsY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JLWjEBts;
	spf=pass (imf17.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7aab7623f42so3677126b3a.2
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:38:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762792718; x=1763397518; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1OccL0Sq4R/RA62B7XB61l1HOYHt90e9E66Mfl8uInY=;
        b=JLWjEBtsfFGBYqZQGinYOwMxoBad7bNUzsFwO3nzftvx0Ai5sodls4m7W0Em+dq2lo
         JIHgy/i1nLbrIwf614Wd7TajV4dVINeOMnpryn+5ttl1zyA1KfyR7qlY1MRUKwxhzU6w
         M0GIGTWHkEk2x/4DZaMKII0/5VtVId2iseVQ2xZ/QbNdaDIyD3zPJXylioTRA7cfGNV9
         P1K2NTzg/sr7BdSKCH/nIpZLvUAgIRj9chACtSQmY8R58l1XzUS1rn/1HHeIkSAR3Gm2
         X3ZHG+CEY4QJuBiMLYQNtlHsfAKwdyWcjokbFeD2JxKWJZjbVwmaeq+ike8voGPJ9bwr
         ppTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762792718; x=1763397518;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1OccL0Sq4R/RA62B7XB61l1HOYHt90e9E66Mfl8uInY=;
        b=Tf2XgZwnws1KbN+ElJNvodn3wDZuVC7L0KnG0XjVpeOU3kqoLx7yiq12RLYbr8IPWm
         4jTt+uNkPCZ6v5g61lNY7iZVKlUTVZtEoRFcB64JMUSYQ4vV/aTmogYGl1tsqXI6R2Vj
         jMdRXOsywnkmdEpiBnFWeaV1B+iYHOqKEM8MPeNZuWZZKeyhfqDdYB77mfqBwP4akPJR
         uHzuqexWMsHFzS8TQjvdB3TX4cuQxAFp4VOZ556trAqAG+8LCmmZM54TLZwHoUxCc8JC
         RySEnQVn5D9OBlHIqb5+Mp4Z9oRfUY/MsjOrT/2pn1mE+fRbns6+w2JumOVxRHBTDco3
         nIrQ==
X-Forwarded-Encrypted: i=1; AJvYcCVEeVJkHo4SGbuf6iaHMlpvqiLxIz2zSsQLGnKs9vLaEs19wg5UMWXUlw/39oC4efaCeY7b+u2OEw==@kvack.org
X-Gm-Message-State: AOJu0YwXzuLpf39pmXMkYBMV/gNw8bWskaHOVYQzI+vF0EJ7pP9QrniI
	NOLxs81qkTsAG0kVf7dMzPPakz/bLIrqjfKp2kl6PDl9GbbvxCUMBmR1
X-Gm-Gg: ASbGnctdGR/5UUCGRX3txa4XbZxh9ZTXD4EYfYTV48O/gubuKa9tj2ZLpubBUwxqsHM
	OMU6QhZgZY5VvrirmHRhUPZpm+gMBb+Ti8gBrYg9P8Gka8MzAWf5Y7g1c2xmF4s3/+0rEJNR4C8
	3oy4JI1tLb+uCaubNhXMvLYmsNJI6RBYhTe+DB1rQ9DVAlU6aeuQSUzNfYNAInYbH62knBAS61M
	3jQHouy6b+nvSF8NEuCe64WyUr9oiWTTYE2M0gYXdrlk2Aoq1ST2JhsHRu21KxBnbylpm0Ed1W3
	fSUhDwSiJ+KwkxQXpOwLERJ9A/3haqPi2ElEQC9HE2leZ/KDjP+GmM5YHC+4GbANgevjNZyL2tl
	la35zUsS/AlM1oLdMyZJvNwkiFGLHNW63F9Ooqyi+qmMDNU27JsH08HF8T2geQFbI5mgOC5c8RI
	vngBrZNWCxNAg=
X-Google-Smtp-Source: AGHT+IExIQBwxVCTQRLrox7JMc34uETHKbl/Z36VlnkqJ0Z8ANoAeswbWItT/aZ29+cnLxMDYj5a3A==
X-Received: by 2002:a17:902:cec7:b0:295:9db1:ff32 with SMTP id d9443c01a7336-297e56dc7b2mr114908455ad.48.1762792718180;
        Mon, 10 Nov 2025 08:38:38 -0800 (PST)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29650c5e5bdsm150563255ad.39.2025.11.10.08.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:38:37 -0800 (PST)
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
Subject: [PATCH v8 26/27] docs: add KStackWatch document
Date: Tue, 11 Nov 2025 00:36:21 +0800
Message-ID: <20251110163634.3686676-27-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110163634.3686676-1-wangjinchao600@gmail.com>
References: <20251110163634.3686676-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9660F40015
X-Stat-Signature: w3gyqp9ew6c689br96dgmk5b8cxmt8wm
X-Rspam-User: 
X-HE-Tag: 1762792719-970322
X-HE-Meta: U2FsdGVkX1+NmWDQtPE5QFNDbyQo1ZQqaVnva4XTol1YtzdSJKh4k7p4j+OgQcdKfhNQBJbkxAqm4zSaL4Wug8Ejcsy+YfLx4nONkw4Ur37hrclBtcXHdKejeKLkU3VablrpT16vXkdimeAfz30ErhbJirxQ03fUmXVRdYi9yvuv2oTrQgYBnazx1h7zBQUMJE6EVmvjTZZMeXv+mYA2c1Wz2rjEVBKmFc44lTyQrlAE39onBWkvh+CCogW8Uv3vMSqnWvm4YK8nRbpbNxi6BghKlfOkO0bTKEbwwch8Vqzh8KLq/BCGOsWZxfZCzLAkhtO+uDM6QrYeUAkda3RSvzr2i9fRs/gpSaC3nTMpW4BLUC4kwgDKHB9qDRRFe+qnEDBc7tl9nZinikcyoB1221ZJj60XquoaNxl9EWI6SKxaz9TCPtdzrnZUIGJ1jOdp8/iP/93dtANHySQmRyahWKo70XKpr+7AVUzE4fqlMX/c8Vg8FMQAWPzoQYWdXVC90q2N9nwyfaDLoIOLAgJQHW1U3dAW1YnGTIpX8ENCQdwy08gJ2MrWRAL+0Bml7aixpgTe8qtsdH8vAotBphEX9szC+z8EILunoeeMhCxo22LDNi/Kmp3ShpylPy0taGQjDoO1ZA7kpFYRy/4GsE6vZufDBu1Ho+rhp9OYscSFJqzPkY3Zc81JCdtK6oAhQDa4gfQYFNXhqKJDOLFGez3m9Y3eWvQfH8i9+c8xarlE23V3LYJWUG5HA3RDtT1VJ4xK/R+ClibzK59JJ/PcxljG5/FJiqIlhjJkOMIqNjTOp+7zMKoOFDUE+bjKDpPhMg+eNG5B/3bQGwGw7wP2mBrXD3SbIsL7HgajTbeuuNdHayNdhmdg8JBbeUvvdGMV66fTjMEC1ARa9O5kHSLb9/oGeIABk+ymxD+hn+IaFzEhNs+4NTfPs0HHXE+s9D5L0aoTw2/RnoA9p90IFotGlvP
 IIw/zwUZ
 EGqT8eT16frqafA/Gy8dYZu9H7fO2sxfAl4mqRqbQj7VZ4U/Io7dBmUFj8o0m3RR96E2ruHRroLJHmLIiW39BMSDXEiSsmHopgSXIejf708UXYnY6hQ+/HtMnpCPGSWO5ufrR0R8ZmPgKHuuZLBhNQSvBhwd+2mx94cqjKNDkid4lJaYRogSpVloEfBSQgfkuhI0k4XiSIpj6uJodbcfec1kKiyEZVHQ6/QmJndJPMEUcbmFJ4hkZEWQY0TwYlJu4UTs1GWoC05fTaT9ydvMy0hf5JfaWLktdyxyCnbIfSEB7PnbTartxdl0KNLsTqk9fsf6zmWHFk3R4SuS2KYFezZjv7wCP2+lynVdiZTXIzfm0CncFoUKC+I4TevF+Rj+4UHGHuT+WibbCLEHX9dDyvLw0KE1PxZ+TMKOjAaz/l6I2lpsd77ZGlpqfyhUxcUfDCVZYp2R9CahThUabTHvT9/6NJ5mQqN5OjDgQbIrKU1HTENLsAnZmWaZ9fOTkrLerwlkrSKWMRFWq4lp1N/0tNwxJYI+EHcTXhChOniJDVxpYApJlUySAXV7iWIdXPMWzXG/3OB3rqE0fcL37TqJl6QPBLQ==
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
 Documentation/dev-tools/kstackwatch.rst | 377 ++++++++++++++++++++++++
 2 files changed, 378 insertions(+)
 create mode 100644 Documentation/dev-tools/kstackwatch.rst

diff --git a/Documentation/dev-tools/index.rst b/Documentation/dev-tools/index.rst
index 4b8425e348ab..272ae9b76863 100644
--- a/Documentation/dev-tools/index.rst
+++ b/Documentation/dev-tools/index.rst
@@ -32,6 +32,7 @@ Documentation/process/debugging/index.rst
    lkmm/index
    kfence
    kselftest
+   kstackwatch
    kunit/index
    ktap
    checkuapi
diff --git a/Documentation/dev-tools/kstackwatch.rst b/Documentation/dev-tools/kstackwatch.rst
new file mode 100644
index 000000000000..9b710b90e512
--- /dev/null
+++ b/Documentation/dev-tools/kstackwatch.rst
@@ -0,0 +1,377 @@
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
+* Immediate and precise stack corruption detection
+* Support for multiple concurrent watchpoints with configurable limits
+* Lockless design, usable in any context
+* Depth filter for recursive calls
+* Low overhead of memory and CPU
+* Flexible debugfs configuration with key=val syntax
+* Architecture support: x86_64 and arm64
+* Auto-canary detection to simplify configuration
+
+Performance Impact
+==================
+
+Runtime overhead was measured on Intel Core Ultra 5 125H @ 3 GHz running
+kernel 6.17, using test4:
+
++------------------------+-------------+---------+
+| Type                   | Time (ns)   | Cycles  |
++========================+=============+=========+
+| entry with watch       | 10892       | 32620   |
++------------------------+-------------+---------+
+| entry without watch    | 159         | 466     |
++------------------------+-------------+---------+
+| exit with watch        | 12541       | 37556   |
++------------------------+-------------+---------+
+| exit without watch     | 124         | 369     |
++------------------------+-------------+---------+
+
+From a broader perspective, the overall comparison is as follows:
+
++----------------------------+----------------------+-------------------------+
+| Mode                       | CPU Overhead (add)   | Memory Overhead (add)   |
++============================+======================+=========================+
+| Compiled but not enabled   | None                 | ~20 B per task          |
++----------------------------+----------------------+-------------------------+
+| Enabled, no function hit   | None                 | ~few hundred B          |
++----------------------------+----------------------+-------------------------+
+| Func hit, HWBP not toggled | ~140 ns per call     | None                    |
++----------------------------+----------------------+-------------------------+
+| Func hit, HWBP toggled     | ~11–12 µs per call   | None                    |
++----------------------------+----------------------+-------------------------+
+
+The overhead is minimal, making KStackWatch suitable for production
+environments where stack corruption is suspected but kernel rebuilds are not
+feasible.
+
+Kconfig Options
+===============
+
+The following configuration options control KStackWatch builds:
+
+- CONFIG_KSTACKWATCH
+
+  Builds the kernel with KStackWatch enabled.
+
+- CONFIG_KSTACKWATCH_PROFILING
+
+  Measures probe runtime overhead for performance analysis and tuning.
+
+- CONFIG_KSTACKWATCH_TEST
+
+  Builds a test module to validate KStackWatch functionality.
+
+Usage
+=====
+
+KStackWatch provides optional configurations for different use cases.
+CONFIG_KSTACKWATCH enables real-time stack corruption detection using hardware breakpoints and probes.
+CONFIG_KSTACKWATCH_PROFILING allows measurement of probe latency and overhead for performance analysis.
+CONFIG_KSTACKWATCH_TEST builds a test module for validating KStackWatch functionality under controlled conditions.
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
+| auto_canary  | ac     | Automatically calculated canary sp_offset      |
++--------------+--------+------------------------------------------------+
+| depth        | dp     | Recursion depth filter                         |
++--------------+--------+------------------------------------------------+
+|              |        | Maximum number of concurrent watchpoints       |
+| max_watch    | mw     | (default 0, capped by available hardware       |
+|              |        | breakpoints)                                   |
++--------------+--------+------------------------------------------------+
+| panic_hit    | ph     | Panic system on watchpoint hit (default 0)     |
++--------------+--------+------------------------------------------------+
+| sp_offset    | so     | Watching addr offset from stack pointer        |
++--------------+--------+------------------------------------------------+
+| watch_len    | wl     | Watch length in bytes (1, 2, 4, 8 onX86_64)    |
++--------------+--------+------------------------------------------------+
+
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


