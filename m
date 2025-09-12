Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4A64CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 10:13:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C2C36B00A8; Fri, 12 Sep 2025 06:13:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39A9C6B00AA; Fri, 12 Sep 2025 06:13:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 289476B00AB; Fri, 12 Sep 2025 06:13:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 17B476B00A8
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:13:36 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D80CFBB392
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:13:35 +0000 (UTC)
X-FDA: 83880186390.22.5AAB135
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2E7474000D
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:13:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ejd8Ggz3;
	spf=pass (imf12.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757672014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pqWZ4PXPvcwGUSVpTO1OvKWC6TpQO7QLp3apqR6W4A4=;
	b=tZ868o8dU2bwNXWq8U7WyCvrj083PESlUEH7sOyoa6WsPqAB3VW0ZRsIpe32B/tftWCosu
	phA9Ck6QjtKYZ+mFhAlU08+exZvTMd0lfyeUpcAg2296VhZZmw7m3k0N1WVkU5RZvyM9Py
	L/d/HF2dfe8OmEwrHhyVFhLYkihhPJE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ejd8Ggz3;
	spf=pass (imf12.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757672014; a=rsa-sha256;
	cv=none;
	b=6soFGaIY2hIXQIWdvSsPEdpneSjs3j6TRVqxdJEHPqYU/IjDsrGGirSavV5vwPoxp5Ot5y
	WdZDnTQLgDCxukm0s0LiJFowAl65o575FpeqJb2HflRSX+bgH8Wyhfwa4Twwz7mslPnKLc
	r0fAs8IDVdWqkalb+nmZOkHxBEIuZYI=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7726c7ff7e5so1636129b3a.3
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757672013; x=1758276813; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pqWZ4PXPvcwGUSVpTO1OvKWC6TpQO7QLp3apqR6W4A4=;
        b=ejd8Ggz3jVag3QF+BujLJUwv8Bf+vzfIxd855LjYxvmzQZqDzla+B06lMlMbQL9P3H
         xTLKbstM7g8TZbF8Mk+hn8yDIgfAzfT52am9jFg3P6KMFQ9/zLwPQfcUO9ZuuB6myFxq
         Iw/f++pa51z9q78dgFqxdROUW4CUO0uN8ex4WIEgWIb/f0ErGX2iN2GQLdq6pj9INzIT
         XtwYIKEQb/w6VGtbrffo08orMJvEX4qFlsjgOz5LVRh0OJRdAz7Mi1ow1hZVUT2CK7Q4
         /hJsF/VPhLFLlCbE9VO7MC+XtrrrskWEGamBY5jwjsMkMeiloS1jn4aiA03Uyd65dSHW
         BooA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757672013; x=1758276813;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pqWZ4PXPvcwGUSVpTO1OvKWC6TpQO7QLp3apqR6W4A4=;
        b=bVASFq+Tqlp/roOk9ukd+LXRfRvCehsl9onWC7kZRS09dJZcjwQ9erpNFDVj2vT0fQ
         i+Qi3lkdU/5+gpXRv+jaN6fjq1M9/0U2NzBxmvzYG0a1awgbhRXNLKJzF3bDMFHEcvPU
         LyKkmju7w954KLeTK2eaBU57meFv1AfoIoDoWAG3MzreCp0HOlX6SbuQHesGoEz3UQxf
         u2QtbAP2wX0eyzxtpHIqg0vPUduv9zzEJtQL3sgtJ2IqeIKLlIU5RcVjVl2piCC34+0i
         JrELqFvZC2Y61SnnjPTp0Oq9Kc4qugTDFp5zYTFTuVkwo0aCbr/rX5QTxUfUKevggUCE
         XM8Q==
X-Forwarded-Encrypted: i=1; AJvYcCVuFw0ZLK9XWqEZEi/yOIdFcMvy1mQnQKA+3m2fLakzikaW6WRttZ3VzzaKIgtER9d9H8Zsaj0pWQ==@kvack.org
X-Gm-Message-State: AOJu0YyZuynyNhaTYBrFaHW49952IIeOAYbggC2xfYp2DNNNj5sy798J
	5MQ+71jzY6FU1ZE0aBZ6huRsdd9Wn1cO/kJXZXB/2EbJbBBLED79BZoZ
X-Gm-Gg: ASbGncsgBFrHzAwv5e8T53dMLYfGDDd3rkIufBFNYO2hwzP+lIugKdPArKzzG2VuPPy
	DzBaJSg8utDAvP25YrGpDGGMtIervk6fENxVb/FbRnnEFZss8ZTGNMz62HzlOgKOu4q71zXVTdB
	iLvBzr/c13Q5iRbc4MsdwQXbEWNTxot1R3CHZtlWxODR6i0geQapOLiOs5PcF2mtO4pSezgkzur
	NqMlxVs8U911P2dxDV0cScNaExNW++AE2zboHwFJPT6gqMfhLv3QefSaEnzl7DoUsELitL685WI
	UjjII1TO/sbnaMSTinJ7ftG8MI6WrQsWHKgQLCGP4uk/RLEv96RnCSC2K4L3YOBQNhlFWfplHmI
	+qdQ4cJz+r+rkOlxAicRW8i8N2/p+IvErV7M=
X-Google-Smtp-Source: AGHT+IGdi0rU6u6yk/5j3je0obUk9yox4MEj0mpe+W9QIz9sLwr6j5n+alC3GBSeGbtzXzFiSEwqsw==
X-Received: by 2002:a17:903:37c4:b0:248:811e:f86c with SMTP id d9443c01a7336-25d26663209mr26113005ad.34.1757672012838;
        Fri, 12 Sep 2025 03:13:32 -0700 (PDT)
Received: from localhost ([185.49.34.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25c3ad33e1esm44309995ad.105.2025.09.12.03.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 03:13:32 -0700 (PDT)
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
Subject: [PATCH v4 19/21] tools/ksw: add test script
Date: Fri, 12 Sep 2025 18:11:29 +0800
Message-ID: <20250912101145.465708-20-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912101145.465708-1-wangjinchao600@gmail.com>
References: <20250912101145.465708-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2E7474000D
X-Rspamd-Server: rspam05
X-Stat-Signature: x7gecxy4okrcxpz95pt1n79o1nh5w54u
X-Rspam-User: 
X-HE-Tag: 1757672013-709504
X-HE-Meta: U2FsdGVkX194VUSAGXEnFe8e/1jjrh259FxEUO6q5s08diGNoUjDmUH0mFOaPgNLNa5iODch6bz9lQBunnBKcSpp1N4mn7yGEY1eMkWxU0Ut5ES5I2f4s8iPMIur41VT/nrPMZBLVsQxkO5h5RMhbg4obF9tSDvXQ/PaXo6bRCrYfoyhcXGD8DgiGPGwYZXzj52kT1iCodILBiz32xfRXKQOPTsNCa88WH/L4/Iu21Tmwm/VyJHeVPmNA4doOmIt60iVnxNg5c17wPoXCdY7Vwyj7DNDld5VzdSx/hsB96MtWGrB3RuHD0XVr9uLTwtldY7gT2XDtdTyFJmsGrDiY0bZOTE6fvAKyuigV9DXAEEhupKwoA3rnP4MggugcGJa2YtGVaajD7K6ZxgQ8G4/NOWyS/NuvPcU38K7bNLESYidZUkTqkSifVXdSDjzWGaZb+Xb/Y6gpt5pv9jqwu1Dxc+lsrf1TMX1/bEgIJWdcZUZUzS5bonRCtn/OVedzA7coa5ZLRhkeIt0srErnqnM3BWTDhNr8nJNYN25JdeCenNC0op5IN/HVXb3InJHrad6jcrX8xZA/7aeWcQRdo0De5000uWZY2oOHzAOnq1i+ww0Pnf0rlQ+qGqErLGbLi7X9pstmruyE8SiaNgiky74JOS8uBNO3jK1Jxpm0wY5YTxK04LoHmddg+ztKPOCtqCMPdAa8KYG67eRRHfTydJ19wfmpO0hd+KnTMfKKlhp6BSgw/RWiqh1dTjZa/XnwbDN9KWBA4+Sm4df6bGsKpo2D+EFmwSiGWuwTow1cFzPxLyhfD8JvwcEvvWl6GDjsSywmhFDtQJEYWzKBgQFft260DWrwoxCvJAMpLnU8A9Lw9Z+FqKhmRDwh/PClFdPhdLpOqrCBenzs+80+3Vciw8tkPjGxO8UFAXGWV7Gmjf3syRkjxWenYLk6Nmb3O4WOFMSAkjtibGXhunT3FHB30b
 wsd4Ffyp
 gkiAW56BRAZOkhCpS78o/gmxPI9kMi1oSctQuZrnwHpnCJ7dTRK7tcsCQmrrfk9Wn/VFvXrx6cBVmazcBtq3+4aRGO6Oalrcv1L+/lL4rO7HZhT7EdstTSHNIaZoWUzenI8lpZeahgtCRou2X1PM3OoKuDwCgq1Yw21JLUZWVcyq97NiF1+qU7hN/rQ==
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
 tools/kstackwatch/kstackwatch_test.sh | 40 +++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)
 create mode 100755 tools/kstackwatch/kstackwatch_test.sh

diff --git a/tools/kstackwatch/kstackwatch_test.sh b/tools/kstackwatch/kstackwatch_test.sh
new file mode 100755
index 000000000000..61e171439ab6
--- /dev/null
+++ b/tools/kstackwatch/kstackwatch_test.sh
@@ -0,0 +1,40 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+echo "IMPORTANT: Before running, make sure you have updated the offset values!"
+
+usage() {
+	echo "Usage: $0 [0-3]"
+	echo "  0  - Canary Write Test"
+	echo "  1  - Canary Overflow Test"
+	echo "  2  - Silent Corruption Test"
+	echo "  3  - Recursive Corruption Test"
+}
+
+run_test() {
+	local test_num=$1
+	case "$test_num" in
+	0) echo "canary_test_write+0x19" >/proc/kstackwatch
+	   echo "test0" >/proc/kstackwatch_test ;;
+	1) echo "canary_test_overflow+0x1a" >/proc/kstackwatch
+	   echo "test1" >/proc/kstackwatch_test ;;
+	2) echo "silent_corruption_victim+0x32 0:8" >/proc/kstackwatch
+	   echo "test2" >/proc/kstackwatch_test ;;
+	3) echo "recursive_corruption_test+0x21+3 0:8" >/proc/kstackwatch
+	   echo "test3" >/proc/kstackwatch_test ;;
+	*) usage
+	   exit 1 ;;
+	esac
+	# Reset watch after test
+	echo >/proc/kstackwatch
+}
+
+# Check root and module
+[ "$EUID" -ne 0 ] && echo "Run as root" && exit 1
+for f in /proc/kstackwatch /proc/kstackwatch_test; do
+	[ ! -f "$f" ] && echo "$f not found" && exit 1
+done
+
+# Run
+[ -z "$1" ] && { usage; exit 0; }
+run_test "$1"
-- 
2.43.0


