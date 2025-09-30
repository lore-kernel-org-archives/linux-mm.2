Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68F65CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 02:46:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C17EB8E0036; Mon, 29 Sep 2025 22:46:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC75A8E0002; Mon, 29 Sep 2025 22:46:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A41A18E0036; Mon, 29 Sep 2025 22:46:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 91F798E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:46:06 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2C98B599D3
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:46:06 +0000 (UTC)
X-FDA: 83944377132.21.8D280A0
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf16.hostedemail.com (Postfix) with ESMTP id 45E51180005
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:46:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rbw+sLSR;
	spf=pass (imf16.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759200364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PODRMG2Z8bUUhx/yC1VRhywhZMIHoJSOmQZCJHqYhJ8=;
	b=IIh/R9riIyl44O12yg75I69z5GQtJoo4vrDc6OKTF7RHLfoYjzIA2vKCmsjfJM2X44Htmi
	em6/P8QOnfMwvAoc6vIJjmOVRmynMtsXGeG8u+ibzMM8WmCXZvkTIdoo2duPk+UYYm8rvP
	9W4bsvMR+5W2yEJ7a8nZPlaex58+OSI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759200364; a=rsa-sha256;
	cv=none;
	b=d9tolHrA/cynDjssZwgSIRi4kNR1b9zI2pugxOWCsl5SIUrqTi7217ulX7OGlV2SGkfD4v
	cxYd94P7zAZQ1HMUcRDmcfShu488R6z766TIuPa50EXxW2GyTBbIQsdqVSIe9aX4i/9HwS
	qp1t4MF9vToplPrVSNcp1Z5J+ia9aRU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rbw+sLSR;
	spf=pass (imf16.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3305c08d9f6so4086221a91.1
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 19:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759200363; x=1759805163; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PODRMG2Z8bUUhx/yC1VRhywhZMIHoJSOmQZCJHqYhJ8=;
        b=Rbw+sLSRrDI4kVQ3ZPco2b7H9noO/EyqlUh1OXFr573ItH9mvQoj6ikgwDGPHiWrJF
         N4IkKO9RaCLqwxIJDzeBDqhoIgE2AwK7EcjZlJvcguVsLDb9j6okmWOmyT7XSdgDtR73
         5KZfBtp3Ng7CYqM6nSxzVMRY6s06UN1Q7VYcGWQWq3pmaBJ5rjy/1mpMpiZNcpzhHZhL
         RraCJZnT74hxOWBfLG/gVW+uY4VhZRP4heJEjFAfF3823XhyjwWa6+0hO2oSpbj1bTMg
         aTlpb0qy5x7tctIhjpQYP0v8nppMU8YQnvlHaDdjjgIUNyidmHvzRKCtYo0wKjEktRxE
         EZfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759200363; x=1759805163;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PODRMG2Z8bUUhx/yC1VRhywhZMIHoJSOmQZCJHqYhJ8=;
        b=vnLax8imJESb8ZWHur6ZTyxroZ+7lECfjVxKRz04YtrwWv4qnAqiKS3+hfvZ4+l0/a
         TJNinkKKHE7tRLNRtOrMTidDPhgHbRFnNLalkc+r0tkRlYVOkvu1y+yZBVwGpcEJWJuy
         F7BxGGk6W/s+/ZHfQR97jCRQL8nv36KRT4WGLOxtJn/uw+WNhrsFjzr8EKTt8Ajw4XTT
         tDc9f6hC7GIjLqndEDnWwUzYqjZxAiGWwb2gpay4NV1eZ/tnY8Qij3Bg7VIse0gmiE8e
         1uhH5zJxPTSMJI2rL1+vmrCKNIRom4ZR8xNScHMl3mcsEPkQyh2+TSVs2Gh9DwHxmgUc
         pp5w==
X-Forwarded-Encrypted: i=1; AJvYcCVnnM6PBJW+KoI6d6ldcJVFkfvHWZ5Ql27fgfNJ0FFx2DaAk0bC9o0P2XMF3Aif0BnC/yBR6RIg5g==@kvack.org
X-Gm-Message-State: AOJu0YyYx4wwTPpr+0lyLxhN06fWid1e7SUe4EMuLvcGNPur8nmwHVSm
	U9yCUcJ9TmMmSYavhoF8lBGwH+uQnHS3Ju3B3Ju8R0H8EK5inKE0UzII
X-Gm-Gg: ASbGncvT4gfep/yaCKe0a61IKqIxTYPVQbL5Xj5E+x5Ou4alCko7UEjuxZ7sI/UedTw
	PPhhdDTt2phYj63LijXvcYYs0IBEf8GSD+lJHhiEknmj3M5RrT9BSqSWdRX85WBbn5TviLPhM7u
	IyK5pBD0rXiBcfkABOlRy1kNhAJHrHyXZS7KXrMbCLJ5z1h66AWUyZzeBZSOrzW9xc88scByPIy
	HDgkRXLFdlH2CYKBuj40eEkrXC/WcwmZWUtL5cyovpEaWd+NF4kEGxFcs0v9MkesDh0O/lpAnZL
	eLyVPPaQeIiMH1Xd0qtQlf9HPLW9oAPnLJTsk/eYe+9FPCiyzesCAlCLuzf1ON5l6yLr1Lu3rvR
	ylJW0zbZstwoXFMKZgigB+qrs5NYqTDYxMuxCJBnZFQGuWWVSZWUN6hFh45PKD/Tz5iHdlQ5G4N
	Kk
X-Google-Smtp-Source: AGHT+IHP7Td3KbhlqylvVUhjonZ8jqxOR18BBallTWQed6L2+fSp22hmPw3ChS33nbn+ktPyuhPsHw==
X-Received: by 2002:a17:90b:264a:b0:32e:64ed:c20a with SMTP id 98e67ed59e1d1-3383aa8b143mr3140082a91.0.1759200362962;
        Mon, 29 Sep 2025 19:46:02 -0700 (PDT)
Received: from localhost ([45.142.167.196])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-338387099d6sm2786368a91.10.2025.09.29.19.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 19:46:02 -0700 (PDT)
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
Subject: [PATCH v6 21/23] tools/ksw: add test script
Date: Tue, 30 Sep 2025 10:43:42 +0800
Message-ID: <20250930024402.1043776-22-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250930024402.1043776-1-wangjinchao600@gmail.com>
References: <20250930024402.1043776-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 45E51180005
X-Stat-Signature: 3zdn5ucw48srp5fyjc3wu35roaofpyer
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759200364-259969
X-HE-Meta: U2FsdGVkX19e85fvcAWSKyH05Aq+uQL8WCZYNn2O9ap4EgEmuu3sqjUEXekmhMrTl4rzPp/Sc6WQIgh6c8ep2UFYwkPUUFTNnIIsPkv3T/41J9LMZ6gKXh437a25ZWG1GYYZ7lbwneSKhHQ5nACPR8MhRAhPA96spZRraccNsMdCRyy8AWdpuiWBCg8e2jLGibduLQapABT/hLrhBZDPCO8kjTagByu6RK6Zk7AcN0vrOetifjot7/un2U2aPsPEPYGjTiy2nTme/UL1cUvLq5oIN1pA0VfGK+hUA3HM7NVItZVmaBwNrTys7bqD304CmYNSa+sVibQhj8XmLRdEsmWh0aCSFgJAfRzK9qEVZ+6lFY82xXHf+RDM0wKfjx6xvNA8QrQtlqSBVycO2oifFtVJFyZLXgNO7ry0i/ytctkr7FFu0bCMj4lu8oUy8hIpBnaZnYy6DIPuKLLRr3YDyLJTikrpcvrLNKZePDRTqbBT7bThsbjfCHeh9EHQmpBkvDzdbxRelRnEXM7SYqb/zHfXVP4KJS1m1UkmRjtdJZ62poxhQlpfD1R0YhONY9wFe7Os9Td8tKN35v8EIJjtACTDP2yb4bYGIDHeyq6OnkA0XxFFD6eCoHE4ZVm4QhzrsgxCBNkoPFlRqq5em/eeEqO5OcOdDfTG7l7tzViz96xO6YrUlQ//i03SB1hwRzTG6C8RPTgovFlGdwxdYmFrLOQUnuWbn5sbyJ/UWVm51FVrh4rCMdpFDStka8eBZqJgD0vBLW1fF7WIkI+Ly1UA7fPQJ1HFyEeMC9dN/n5pSQAiqe9yrVqXXtEhJKDunWsWC23QjV0qrEqwQCh+i1cjgnpvRG5HvEckRgILda0DqEPRxe5pIpjNPWk0oTt6wfV52zjhfOiu8knqmW1PMkX2CbUcKrjoqJn0+S69u2Yx0HzxFgZp/Fio9kdgCj9eUyNoCDBB5TSADk6lJLJ3Mgr
 L8SIVSfa
 vcbDyL7rGFYo6zChMMrEW7T/it6bJmxFrJcTc/jD/rxR331mzyXF/5WXVlHyTkfu3NsGHkwTFP4Wk6p45P+aD+zTu1HMkB+Vo7hY+oyaXkAXx7tj38pfv2PIw2QoYKjBWa2JuXOgN9nGipfuCv5gB0NxWr2/uot+rAaLBjAhdHMMFRx7ImkaS7Krli3YIFg213TVUUtI1PHiGekh3RW2SDn2DdPOycXer/hUjBFs/0xAu3gl1P+mVTahPUOWzrY68DswV8UCeyc0ofTolna39GiKvkIIXB1m2SIx+KZluklEt4u3ssBgk93Zg3/26jXQje8lBw3/MTFDHVv61zzRjnwLRl2tB7viSNp9Zzzyao5GwjWVPuBkpeBKCrgq/7767bQMANkQVfw7FWT0/9P4TH9PpCdgPnq7bEjbRx6/XWr8j8AXOxdE6io6OFuYmq0KQeX9n6WWs8hnI6DkOBS7OirRCLyZvAc7ApkxP0MDvvXe19hO/fEhNhfqwbc551hrbJiveGCyCiZkdCNQpoQLeFFBaoIVi6ogqFZ7SmMVQNsdeR6EPEGwVLdyfcw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Provide a shell script to trigger test cases.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 tools/kstackwatch/kstackwatch_test.sh | 52 +++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)
 create mode 100755 tools/kstackwatch/kstackwatch_test.sh

diff --git a/tools/kstackwatch/kstackwatch_test.sh b/tools/kstackwatch/kstackwatch_test.sh
new file mode 100755
index 000000000000..35cad036ecee
--- /dev/null
+++ b/tools/kstackwatch/kstackwatch_test.sh
@@ -0,0 +1,52 @@
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
+run_test() {
+	local test_num=$1
+	case "$test_num" in
+	0) echo fn=test_watch_fire fo=0x29 wl=8 >/sys/kernel/debug/kstackwatch/config
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
+# Check root and module
+[ "$EUID" -ne 0 ] && echo "Run as root" && exit 1
+for f in /sys/kernel/debug/kstackwatch/config /sys/kernel/debug/kstackwatch/test; do
+	[ ! -f "$f" ] && echo "$f not found" && exit 1
+done
+
+# Run
+[ -z "$1" ] && { usage; exit 0; }
+run_test "$1"
-- 
2.43.0


