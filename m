Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56AB2CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:38:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E078E8E0052; Mon, 10 Nov 2025 11:38:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDF2E8E0003; Mon, 10 Nov 2025 11:38:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA7CC8E0052; Mon, 10 Nov 2025 11:38:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B19D18E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:38:37 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 775C856D5F
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:38:37 +0000 (UTC)
X-FDA: 84095255874.28.BEBD5F3
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id A253D140006
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:38:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="iWm/AVjl";
	spf=pass (imf23.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762792715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y3GxOA64nlDPTJib953n4vjoIghnHFGUI3myXADNt+s=;
	b=c4YnhVVZyM7yiGGy9Nz6BUby+Rb4UMSDmAAigDIupHN9gHqc8QedMVqxbVdiCMQlIt6dRL
	NQyjFnt9vN3RAun0QaMbTvRKEdqbUk4THHS3NILQEgMChwSDYakEcJWGsZicnEC4p+AEA/
	cSh77bzPl7s7DReRXM7cBDgtPAdeSQ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762792715; a=rsa-sha256;
	cv=none;
	b=Ra6JRs/vuSfLptvH6iBI92sKRVAoe0qh9Pw+VhXbXcdEO+dGAdfmupqKJRpTTlas3Uv9P/
	Q0ktzL+N9r9VgNkt80tPXhf3wEybCCs2aMcuxjKbjplMVulz1K7vszh0bVU1z9EIKCaPoC
	90HrrMF3Pn5ModElmTIROlq/J2W4seE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="iWm/AVjl";
	spf=pass (imf23.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-29812589890so16333145ad.3
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:38:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762792714; x=1763397514; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y3GxOA64nlDPTJib953n4vjoIghnHFGUI3myXADNt+s=;
        b=iWm/AVjlHCbwBPq9dYHME7UpmfRyTL/s6TJ5xbUkKMkw5o2VfWvlK9UDRiCvyYPlAh
         m8KWgY6fziHHusPoSEUKWY39wVk8NNO4vk7m+BNixkqgYjr7B4ldyehQYA4lMK+3K0Kv
         N4XiXyeb+wVl390CIHMmiGL9M3rsvDjLkz07xXVPpSgd0T5aqT5Jlu5nHCUbcM6U08td
         r5lidJrYVoXdCiEsaOhe7GwAOt5FmnDB1/Bwid0ylKwNhvUdhP9B3RN8hHPLZlLOqxgy
         HCO/v2txAPFt0crSGsci1MMx6R5Z4xEkXkGq0iiAxtc1Va2F37TyIGN/4IXsjzFpnq3a
         Q7RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762792714; x=1763397514;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Y3GxOA64nlDPTJib953n4vjoIghnHFGUI3myXADNt+s=;
        b=qBf+fbGSGPdh1dngv8JHSqnnF3mWY6lBGE1Vp3fGiUO2JXktjylqvAdm+5MJJRFinW
         ekcHBxshiLQbZHkTvm7IlGnHkWnDjO5ln798BAThLzUweHEIDxyMhG2wHWgQVKNGjjl6
         QJ22H022DAMq1VKBVlxvoWnQ0y/gDTQcvxHBZZOAuP9zDIbQPfxNp7d1BGmhBrzBIzHY
         JNge1YIdO23ZmeetCVgj78M7ILK+oTr2EOoCenySXVvFD2aWuL5ZPxzNwUaQRiGLa58z
         Zp/DT8iv1ITctb3W53F9uzjDeZIWf1IcCL80GOecE56/kj/rhJiPiBSAHq8rMTBIPuIv
         2MUw==
X-Forwarded-Encrypted: i=1; AJvYcCX4xR48FsoOyX4weZnN6+wJuwt9I6SI4Fv/rkDYca/OVbG5lJYV3Iac/1oRJuUD7m+ZO7PHD3QJdw==@kvack.org
X-Gm-Message-State: AOJu0YzJ46dROW7CJP1Ryih0cVWnzG66tY6fxag2auoTjhfTsXIIIpzY
	guOGnyUqUijLMciN7DVfaI9HaxCG6NwNYQzs3MoJu0TxRCOtTjAUmIaE
X-Gm-Gg: ASbGncu/eYM/mV7K+YUb7AP+LDdhojA8YUq/4HwN/KyFeuTwVyezoRmn6ASqMHy0/lj
	+n5dw5BTjfhAo0nzUQpcZqDbgMyOAX+QTiDJYOBoYRfxVMtPmoTNzvhchnnnZeHxdP0QPIAF0ji
	73MOzOsNJXx+o9RggCYkWsziup3uK0ZgaBbDXCatXeRpLpqJNna2LJ1WrtWe3V8ykxbjmXH+N+A
	MSQl2AFm1O5Tp1WGU4aemHrb/G7psN16aaBhZt7spiN6+bQXMBcLnN0fMgrksDLiSqFNPPC0nyv
	o4ZkTRchflZkfPt7UyGdr9nd2RUtqzSeb6I/MXo5X2xjGETxxkmhQqNpbI0dzp8+i9BR834AEYG
	KQaEss6mhay6LAoey0v7/8ZXMoE+A/pix8YBzErJqMk+ySIvzNMnfkKR+iuZouFOCi7VlmhjMcg
	3RDq2m0NPsd2v66SCbBxnuGg==
X-Google-Smtp-Source: AGHT+IHJX8e0VatXnyxoY2Gj4pP23au6Z6EmKSnmcplOP/Vs7kpe6TtUClUvAMyMHtho7bQMYRxkQg==
X-Received: by 2002:a17:902:da4b:b0:295:fc0:5a32 with SMTP id d9443c01a7336-297e53e7aa7mr114885545ad.3.1762792714416;
        Mon, 10 Nov 2025 08:38:34 -0800 (PST)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2980c51b8c9sm52389295ad.47.2025.11.10.08.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:38:33 -0800 (PST)
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
Subject: [PATCH v8 25/27] tools/ksw: add arch-specific test script
Date: Tue, 11 Nov 2025 00:36:20 +0800
Message-ID: <20251110163634.3686676-26-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110163634.3686676-1-wangjinchao600@gmail.com>
References: <20251110163634.3686676-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A253D140006
X-Stat-Signature: or3yx9azy96b7mb35o5c3fgzuursirox
X-Rspam-User: 
X-HE-Tag: 1762792715-82918
X-HE-Meta: U2FsdGVkX18UctDXA3jThi3phmWQz/MChK+apXJ0+M+HUaCzpQj/u8rOWR6N6+k0uXheLR1ihkx3HwZzT9vNAiblAwYlP0q1I7Jtc4iwbbiZeGLE0o435Ndoczt0z39fnPbiLkY70IrXAo+Irg9SxgxTWpQErT0lJzw7kjt7wsxhBs66w8Y+foFzOqJ5UwWxvhqBk6FGCYvD7jr6P6eYOe0TBzRidGvQq+dHz1AW47BUAPpDwpTd+Sv9DV0IL/wC/CjFavzRrtSIBRWbFrozAWBX9sUEA+vGqHddTxvEjVdpoz4hdaf1oQcT5hTDNPZ1aXdBvPpwW1rTl4rsXULTjKTXYoMNe5uNPqjY+v3Nqw+KNnFv4b7LCBlUrditU9EVC1qjp87DmAco432apBOu/5Za3nVkmnUkQ8WRjenBLucfFGB6RTzNuGa1CH93yJibFi0s0Hq0BhlhrWBPjImLqC36Q17xC4zEQGpp1n02FyVcVNuXskD3XxWfnUfv/f4da+/UbSSddSfGrGGHL5UR+mgV/s1vR58ZB/nFynrBO9zAKJEA7dwtBKwZgr7EnDbBwODmT9ooNJh9AAYrWyC7j/Q/zKM+mU24JRXvK+T1fEP8I+lH8snTOXlsh22GU4fvhk4Z9u9QSUmWNtqY0wqPRGyH3WgyrvbR7FjgpkmeW43oRRa0YtSnCmrmN1KLTwSEsiK+ac2ZXT0ndwscUHXFUqgpcqc/1TUqkmoTX/c9Q9OIelc5Igk1wieKxOnC4sfYEtYK9QRPYZ/S0vRsK/uWUg0Dg8KVol4SQK5wMSwh8Hvr5ouqdlIVhKasso1K+2mNvbspiCCRKk98GrssOFO6tHwjwmXMiMOwGYaK+7ejdFr6qFBZsBZzsCLtrJNGj4QFk2XXr5QULXs+UkGgOCzJIFjqW4gS/Tu8Z2EXquu4OLwVG1XftEnE6RhEFRweTvGceRczXgabuuwtJsq6tAX
 Devi3H5A
 K4NtKwq7NUu2fEsWmZwa9jOiDM6zJRiFPAI4edBFQOkMtyCJMGSdSSFuziJHeEd+2G/6mVOdjC8vd3KHHFlYwu2AuNUFFkP0pdt2e9NeUWL66XA1om307W2bpgZ4Z/+65spogBIG62EhHAiOMJQMCPl8ng/wjhtOer16+tbzv4aqJklVHHLwm0k2ZNldk/hNqfsNHqDGF2Ci6CEKrUP+7tqsoF4LOIJ6SWlo6Ep8HrjHY33ScRj+gQd6CwYBMPJnrxw3pMBjfx0W59GsUCLE60hvhiHmQKiGke4/cVKlcawJ/NtmLmg0wA9b1ddzRIfXUO6h+uLINTwodbRiyXgqglZOOxlWYPDc31V2S/UPcFsZrkkgKKQPojKMX3maSb20sAMMWAwKBAHQn46gdWYzlRZqQQqxu798qqP2WZLimgTCcKGGupSpQwKa5jgOGtwaRHzFC88tfh1sCnS1Ht5Hxn6YTJOlfyhPlSNl3X1fI51TrWPkSDbH3YiAIdcdsT6PZdzu+VMLWeH5kw/Ra5z/pQp/hCjx/iu6ZM+hOQcf7urjwHHP92G0obe1QvA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a shell script under tools/kstackwatch to run self-tests such as
canary overflow and recursive depth. The script supports both x86_64
and arm64, selecting parameters automatically based on uname -m.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 tools/kstackwatch/kstackwatch_test.sh | 85 +++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)
 create mode 100755 tools/kstackwatch/kstackwatch_test.sh

diff --git a/tools/kstackwatch/kstackwatch_test.sh b/tools/kstackwatch/kstackwatch_test.sh
new file mode 100755
index 000000000000..6e83397d3213
--- /dev/null
+++ b/tools/kstackwatch/kstackwatch_test.sh
@@ -0,0 +1,85 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+echo "IMPORTANT: Before running, make sure you have updated the config values!"
+
+usage() {
+	echo "Usage: $0 [0-5]"
+	echo "  0  - test watch fire"
+	echo "  1  - test canary overflow"
+	echo "  2  - test recursive depth"
+	echo "  3  - test silent corruption"
+	echo "  4  - test multi-threaded silent corruption"
+	echo "  5  - test multi-threaded overflow"
+}
+
+run_test_x86_64() {
+	local test_num=$1
+	case "$test_num" in
+	0) echo fn=test_watch_fire fo=0x29 ac=1 >/sys/kernel/debug/kstackwatch/config
+	   echo test0 > /sys/kernel/debug/kstackwatch/test
+	   ;;
+	1) echo fn=test_canary_overflow fo=0x14 >/sys/kernel/debug/kstackwatch/config
+	   echo test1 >/sys/kernel/debug/kstackwatch/test
+	   ;;
+	2) echo fn=test_recursive_depth fo=0x2f dp=3 wl=8 so=0 >/sys/kernel/debug/kstackwatch/config
+	   echo test2 >/sys/kernel/debug/kstackwatch/test
+	   ;;
+	3) echo fn=test_mthread_victim fo=0x4c so=64 wl=8 >/sys/kernel/debug/kstackwatch/config
+	   echo test3 >/sys/kernel/debug/kstackwatch/test
+	   ;;
+	4) echo fn=test_mthread_victim fo=0x4c so=64 wl=8 >/sys/kernel/debug/kstackwatch/config
+	   echo test4 >/sys/kernel/debug/kstackwatch/test
+	   ;;
+	5) echo fn=test_mthread_buggy fo=0x16 so=0x100 wl=8 >/sys/kernel/debug/kstackwatch/config
+	   echo test5 >/sys/kernel/debug/kstackwatch/test
+	   ;;
+	*) usage
+	   exit 1 ;;
+	esac
+	# Reset watch after test
+	echo >/sys/kernel/debug/kstackwatch/config
+}
+
+run_test_arm64() {
+	local test_num=$1
+	case "$test_num" in
+	0) echo fn=test_watch_fire fo=0x50 ac=1 >/sys/kernel/debug/kstackwatch/config
+	   echo test0 > /sys/kernel/debug/kstackwatch/test
+	   ;;
+	1) echo fn=test_canary_overflow fo=0x20 so=264 >/sys/kernel/debug/kstackwatch/config
+	   echo test1 >/sys/kernel/debug/kstackwatch/test
+	   ;;
+	2) echo fn=test_recursive_depth fo=0x34 dp=3 wl=8 so=8 >/sys/kernel/debug/kstackwatch/config
+	   echo test2 >/sys/kernel/debug/kstackwatch/test
+	   ;;
+	3) echo fn=test_mthread_victim fo=0x6c so=0x48 wl=8 >/sys/kernel/debug/kstackwatch/config
+	   echo test3 >/sys/kernel/debug/kstackwatch/test
+	   ;;
+	4) echo fn=test_mthread_victim fo=0x6c so=0x48 wl=8 >/sys/kernel/debug/kstackwatch/config
+	   echo test4 >/sys/kernel/debug/kstackwatch/test
+	   ;;
+	5) echo fn=test_mthread_buggy fo=0x20 so=264 >/sys/kernel/debug/kstackwatch/config
+	   echo test5 >/sys/kernel/debug/kstackwatch/test
+	   ;;
+	*) usage
+	   exit 1 ;;
+	esac
+	# Reset watch after test
+	echo >/sys/kernel/debug/kstackwatch/config
+}
+
+# Check root and module
+[ "$EUID" -ne 0 ] && echo "Run as root" && exit 1
+for f in /sys/kernel/debug/kstackwatch/config /sys/kernel/debug/kstackwatch/test; do
+	[ ! -f "$f" ] && echo "$f not found" && exit 1
+done
+
+# Run
+[ -z "$1" ] && { usage; exit 0; }
+
+arch=$(uname -m)
+case "$arch" in
+	x86_64|aarch64) run_test_${arch} "$1" ;;
+	*) echo "Unsupported architecture: $arch" && exit 1 ;;
+esac
-- 
2.43.0


