Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA3ABCAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 10:13:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 262F46B00AA; Fri, 12 Sep 2025 06:13:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 213DF6B00AC; Fri, 12 Sep 2025 06:13:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1029B8E0005; Fri, 12 Sep 2025 06:13:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EECF66B00AA
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:13:41 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B47011407B0
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:13:41 +0000 (UTC)
X-FDA: 83880186642.29.B7F1CC1
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id C7DE218000A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:13:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UYIcSWW6;
	spf=pass (imf06.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757672019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bn+/3FE5CmsLxOS0M5YahrLvDpar54OOYFHjkWGVE7o=;
	b=fk+fEw0ddAEAvt9/APT2WdKYlkxQfvfhRxmmo2TVEbmHRYsKEoW1gmA+jBI0WcaYomzSsu
	T8MaXxpFcbJMovQjDkQ5doDBi6FKdaJhgmBC29zrYkpfjlFgoDedUCo2gQsdzR3QMwh4jr
	ZSBMpqHSl7uZ3Gb3Y8ENKAWwJ6XN56Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UYIcSWW6;
	spf=pass (imf06.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757672019; a=rsa-sha256;
	cv=none;
	b=b/KlikuIAqeUHVE+lvXdKvqNdjzdJ2GOtD8aIXXFgOJOPM9xZUKERmHxgWvnQOQzPsVtKU
	7F0IDNwUM2tnea4ArxDrKZoLH8WewiKLxfm2xIDW6YVsY7JO02gvC5wEkFMu5x8lML5JnH
	D/+xP2sxKuNXKKiOiLq5Bsvbqquu15U=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-772627dd50aso3215358b3a.1
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757672019; x=1758276819; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bn+/3FE5CmsLxOS0M5YahrLvDpar54OOYFHjkWGVE7o=;
        b=UYIcSWW6wnezvjWV6ytqhZ7X7uCOYH8FRdQaG6jsr0YV5WCVK9R8HhO0mWrBWbz4Va
         XV3PKjRej26dJuLsAtEK35Okzb0RGsWXLK5ZtG6WhktAccp7loyvSKZpnA2+WyS/OV09
         Tc7rmZlQwyj0ahWUjmqBNSk7EGFKyzNYVZnYPDzWbKgrz5343rLL3Fixn8/P0NjzZSqq
         8RUocHnN60EMy1ef2qvjXns6ENh2GJqlz1unUMLmCaL/PbzmDlqSBWd8GGA74TFwZIEp
         S/BjIV6v7GwNGcHPM5biTp4j97tWg+c782D91w4p/ZrXO85KEEpLqovFJrylUIUa5xaD
         Sy3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757672019; x=1758276819;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bn+/3FE5CmsLxOS0M5YahrLvDpar54OOYFHjkWGVE7o=;
        b=kf8RrYaBZwNJ/fQIriCJty1AYNF8+GZs1yQfICPmmgRizTEi9ZeTrJUzB/csbmotT2
         t3B17s8VouIumhT7qSItOznXTEQZsa51H9uIXZjT8LzadQsR/WGfCVF4cmvr4eaZAaQd
         IPttwI4tBRleAeUT4dMHfZMNhpV1gl2LLWtro0P/k4tl7Lb8piF7JlX/oTfeNAAgQuqp
         HNGVUXrw1UIECyiU9UqfjmhH+LSnReHcLS6Hgqy2pCECiuHmGYW0BwFZNi9Y+recZGsl
         0r62+DOevgDM2bt7N7lxfK7rdSTcGjT9NkxURYbx6Id9xnM7ID3N9K7DG0H5T04Rw216
         BGbw==
X-Forwarded-Encrypted: i=1; AJvYcCUy/hWHqtwaGhVdwXS02rr4O9q53cW0PCqi1dHhOq53crgJxx//zE6aoLBZu/NPbXYQMqWW1R8fqw==@kvack.org
X-Gm-Message-State: AOJu0YykUGLebHz4j7jI7CJjd1KiM1Rqypo7tqv6U77+i4KlpDLnzoVD
	YuZC5lLiPZ5o4b6VxYTJJ+RYoiqBFUKbCpZsVt34Bl8yH9pt0nInVa/r
X-Gm-Gg: ASbGncsi0Qms8BEOv0kNK7TH8qAPTUtYEWZgpq41v+E4XfD+P4908AkT0bl8bgTHh6/
	lD1jvS6ua0WM62HvCUQlIenT7UDyMNIl+Iq0EQO1kondPyQ6R2P0qEThitQPxPOd3PhS8LiaWfX
	uFDkWM/R6V0fs0ymrREbEcKG5u+mJ4dglPmW84+Ctf50lta7Id0BYzieFQPqTqT8rttvsbpYgWU
	eMsxddd7gCjnzoxrWrI6ANpWoT71aVTAgShDEMLwRnYQHnlF3bF14LpYPSJ2fd/fLAq2UBly5ya
	54N7yetWXZG9DZbJqBYyfp8VsKIPh++mG5J8KLOTuMEi/+n4CeGdojY6IbSWO0HCSW/xXf+yJJ7
	A4rDsY6vR1uD66WT3kNfie5xNlX/8mpzgO5q/eroAuVMzMaH3nnKqlzGC
X-Google-Smtp-Source: AGHT+IE9hLw78GXki+Z9/2VgA5oux+LKfhhFZu5WvV1JUasShceVOJ3liaB3nQw7f//NCPosPLRn+w==
X-Received: by 2002:a17:902:ef46:b0:246:571:4b51 with SMTP id d9443c01a7336-25d2da1100dmr32684915ad.29.1757672018598;
        Fri, 12 Sep 2025 03:13:38 -0700 (PDT)
Received: from localhost ([185.49.34.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25c37293f0asm45182095ad.43.2025.09.12.03.13.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 03:13:37 -0700 (PDT)
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
Subject: [PATCH v4 20/21] docs: add KStackWatch document
Date: Fri, 12 Sep 2025 18:11:30 +0800
Message-ID: <20250912101145.465708-21-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912101145.465708-1-wangjinchao600@gmail.com>
References: <20250912101145.465708-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C7DE218000A
X-Stat-Signature: 6dnjq5f657hcg8zfy4cd631fyugh8kni
X-HE-Tag: 1757672019-641500
X-HE-Meta: U2FsdGVkX1+m/kyU4X2VdjJTJam+uNUKzgVp1A+QD7qehgf2oVp8DHzkyjF405/OPrjAQhLVsWJnK6jXvZkH7nC6c1M3MuP4XOUI75LjjydFLQwfCgfwUmBi0iOA+TV9a5xlSdOrzurh8RiQr48zpSp6IQL7Cg+Tch2CYCx5JS4zsy6rhazTima6varra5pN0fNXW8ZJUJnKwlGKAcCi8j5DoyZC5a2tnSnl3gts/CLm8cdFnR6i/6O+EpKvND/PbOAjCAJoSnLB20qm0lNoKaNzX9938JLNJwpox1nRgotIufwTl1DdOp9W66OTas80Iz5JQoNI0tklVVUrTugN4d8XBVLzTNR0t3cUsAuOujZTZR0t1zETKYS7gFs3fla9U3H2Y69E+H8p8QZB7GXxgra+2ToKWcv1AGiwg1SVqfCauX+ykBFsxpN9oz8be+uGbNSNKRdrIej6FVbjJ6SXllpwnS2/I5UJg/QNdgBdSK5fK+74ScwCA6y5HiIasgdEyKmAhEjdX10S8OC/3Q/6v/WbnNQP3m85fY2CR2iI2yj4UpDfq5TO7HWl5Dyb5osYHGBcQIv2zWanfc4Ha4GFmUUJYBnaMLah1k2NWD6HSxa8UqaI1/I9w5aAHImp+sfB6jG+BIExVb3jrXu8naj++RRq+LaTivYxR9Frv3KhF9ODzMPO+breonsBsFa9vQP+RYG8xSS/U60V4WYoBfADFuQhpIzA+tQYUbgy2vWXKw8libtzRC9KInQTMi7yCim9/Wg3cTyfjU5D4HbVoKwQWfhyes4pSDb0RYOOF/2pu2jXLO+A9EgIrQZda08pIFwDREPFPjuABTIwh+5v8ULFE0vAYyI4LlP2gEzMJKYqy8cUGf2cnflY3RNTv5In3KIPIkkyXJDNHlBqvN9NyV24siDbAdj9lXtB4GvJuWnAKiO7xhj+J7rwZTESC1FlJ2GdZuy/S/A3ocmAPvHZh7L
 7f8n0cc8
 QU5PMYBTQQih82PTf4RXTu5HqNs8r756+6nUwopGpYTDD3RhmIzXDeDpXDs3/mfilfp1K3DVyPVdLp4hO0i2+/8n59jp8g5bXezEyl/YzPcCQXUqmDqYYvcjfXmMvmH0JlTNONgCQXBET0i4KnbqNBXH41NfHpU9YAgwHI6/Sj3SjsItjBhqYFOlSsSmz4hBfVUdZlcL+exguTwpXYgQ61cBf45ACLisqFbwkW+ZHAQfoGFu61hzGlWiPa/oF6G9SCq6jwtO9XcCqU+uS93rGZ7QF4T+6F6BGi74p8u3cVs/Ex5Uf8nhSRclsdVaArrLx6HXCMPwDfwtOMvZ9w8TRj4Y6m+xGnoi0KG7NGdlFSM9AIgKydsKJf+Df6tKAU+lCZ7s2kTn2uum1BxPt5Wl+Q2OExNmFisv7+YXZ5RlxH/z4YIg97mGW00kQVrjADtfqn5AjoKmEh+P4/f/d8DJotGM335b6tRqTXnfn4o0pyePx9ojwV4GBSq/1jHaaQHrQCxwJpuC0JyaFMAN4lv44/ofp9wefRYIrij2/PDPiQhw7+TyPgdoKsVvKoMz5xtGZt3+tdyVonKowbNpC2FNuo6lo1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new documentation file for KStackWatch, explaining its purpose,
motivation, key features, configuration format, module parameters,
implementation notes, limitations, and testing instructions.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 Documentation/dev-tools/kstackwatch.rst | 94 +++++++++++++++++++++++++
 1 file changed, 94 insertions(+)
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
-- 
2.43.0


