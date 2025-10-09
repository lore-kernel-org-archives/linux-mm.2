Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF4D6CCD18A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 10:58:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32C048E008C; Thu,  9 Oct 2025 06:58:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 302B08E0002; Thu,  9 Oct 2025 06:58:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 218658E008C; Thu,  9 Oct 2025 06:58:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 10BF98E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:58:34 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C4D7C884C8
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:58:33 +0000 (UTC)
X-FDA: 83978277306.13.BABC2FE
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id E7BEB4000C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:58:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mAERmgPR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760007512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PODRMG2Z8bUUhx/yC1VRhywhZMIHoJSOmQZCJHqYhJ8=;
	b=elZAYd6nW33QRA5nMZUKYyhvfK9LW6QGX84ICq2C9DKL3DFfx+UlTXuDURjzTj+n6Odcfg
	wVJMBAdhfv1b5JQRZuEcWKI3ViQF/SmcIAoEA8ada3eVXqUxmEt8ggaU6vGXV4kx6PuAHl
	kelDagAobkodbZvgLk+ZBO4tD1Y16wU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760007512; a=rsa-sha256;
	cv=none;
	b=CUzVIfhBPH7xKbea8Y6y+Z5ZlK6tS6Bp6HLWNIhUnP1hKszDR1qWD1GLIqoWc9pspX5dmg
	CIikYxkMo4O9RB3r3oGvl+UbeGrz+lgBDgmblB1PNMcwBKCjvt7JlfQQnv15NGEFqx1fOZ
	vpXyzG2uD2PTag+sgSuoefU6MPP5iAQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mAERmgPR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b523fb676efso569930a12.3
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 03:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760007511; x=1760612311; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PODRMG2Z8bUUhx/yC1VRhywhZMIHoJSOmQZCJHqYhJ8=;
        b=mAERmgPRmHjb1Ivtpjl201+Q20Sx4sRTYeZ/90NEMKNAF0kCpUg2v5jclWoalm1u52
         wBzjTqm+avzm7H1yv25Fg+TT6cy3oqxhtp3XozRzf4QMvcnTFXlOTcXVyo/Zp60UDX4H
         WjmeBG9DrytGFBBkfBuHWWcOfvpVdWadmNAJQXEKcomnWBirt5JvpwK7IYHCdjCs3tGs
         ZP/zQWRR9Y+3qzf/dQzHxHgRF9Hq8o1TRbEu8ltTySkC3WZ+iAwNW2MguwKdFfBW0We2
         o9SH6raQIqOpb1S0nbgktjUaA4v+4Kz7qYwzkij9htbsDj7BsVtIFSTv34T/nXaQs/lP
         SAgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760007511; x=1760612311;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PODRMG2Z8bUUhx/yC1VRhywhZMIHoJSOmQZCJHqYhJ8=;
        b=rQI6416i+QkGsusyn/EIeF1iG+nvKMBHscmviAHDIuavc1zs7MfLcPjS0X2Ut1djfv
         CScwYPDYvTxnCSb0IOQZaW4FMbzNd/etOaReaRifnEErqVQILivlY5EsE+oWp573B0xh
         Znas3SG6uOyAfQyFzDWTCSPizhvnf2HPsdkC6ei0WHgHsO+VPqJp1o6uRtWbBtNiuJVp
         cK/MFQWT8skkzRisLkEig25l7D56Xmy15ruDEW6rmEQ+8m5Hhv1mlGg7Szgy6Ogdjx2J
         wvUnLcqPplZYO/hSj+dxKHNNChvdEw1Jl5sM1/n8H3rZ8NOidXit9yq/+WFuKc2qXz0W
         dPaw==
X-Forwarded-Encrypted: i=1; AJvYcCWmYaNgJgfuChDmpSjcpgvQZ3XyrtZfuhITou3ewmnkV0BSXBUJ9uxTbdpJh2fjBH5nJKTlGxnT5g==@kvack.org
X-Gm-Message-State: AOJu0YznX4JQga2rgUzLAELnFnwU5y53Oes9wPT6QHBmY2upPBf4C70a
	xmGYmWKL2zavBAhLsHufKoQkFCjq2SS5aTeZkCrNVkq/Wkns9n6/kVMr
X-Gm-Gg: ASbGnct9BYL/uvUkjcAH1G1lCZNtXavwSMmSZRUoyrEYx/6lL5r1LidsI38Kbyru5pa
	CzH3ldB0XB1xVgbkIUw1NVnAqcfXKrKd/09j1abP0LYGfjmxSmcrKYPiDCwZGA0rjsSruEbnF6e
	SKC61ia2/mB7m6xnmipqTiMaAV/wC9rCjytZ8KLEQqcjPlncWFPYi9dde6UnmPLJ4gcsacmCRGq
	dHVlhgw/L9jgPSTsxiU+qX/MR+zy/HIMKOAJELQmNda/V/lG1Nl9NXHt6fn2aERju0c/0AeJXsN
	cKeAk/II+R3vWprAW66wMS7MkAe68HxaWM4wiZsUuxkIvTNleRn41y4Oa6z4qtSFnoP5gcfBbEA
	i3mmV9uMsMEohX+rscNZdjOYuEbbS9YdBB62GwZceEIo2o1tTvWyHc3ADZaqt
X-Google-Smtp-Source: AGHT+IF84UQdi8SdjzjP27Uzxv11ATZ55/94M/TwFF9mJGTJWLkmx5AoAZTRAV1cVi0ppq51LJs5Aw==
X-Received: by 2002:a17:90b:38cc:b0:329:e2b1:def3 with SMTP id 98e67ed59e1d1-33b51168d95mr9160007a91.10.1760007510612;
        Thu, 09 Oct 2025 03:58:30 -0700 (PDT)
Received: from localhost ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b510e91d4sm6644930a91.1.2025.10.09.03.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 03:58:30 -0700 (PDT)
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
Subject: [PATCH v7 21/23] tools/ksw: add test script
Date: Thu,  9 Oct 2025 18:55:57 +0800
Message-ID: <20251009105650.168917-22-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251009105650.168917-1-wangjinchao600@gmail.com>
References: <20251009105650.168917-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E7BEB4000C
X-Rspamd-Server: rspam02
X-Stat-Signature: dzn8gxywonkkiebct4yjfsehendbw8ew
X-HE-Tag: 1760007511-250379
X-HE-Meta: U2FsdGVkX1/HE6oEioLYjFkU7ZnsYj6Ia2FKTHkedGoRIKINeKyw+ssD7r6Yt2Pn5c1sBp3Eyo4elouVh4k4ss8dIBd5ohObmcavM8sU8+Irw8xXXfTKpbyA4ebxRpnpOOApYKNVoiqbscL69osf3QB6ivvuTuz30Ym7zl9Izv5TPUGQAJ3bBFCHjEv0FlruUnkKdHatUg5JeVObR8AFgyKeWLdUwhRCHl+Xq+F61FcO8kF3c/RDEd69iQBd+d3dcRodJSbNX8mgHA7htQERRaPy0wz89oxM5W9o89693DHeOIAS9F+W0UP/Q94LmhDTksLmBT9y83bemWkc+oi7pnAeYr6eCZ+pSgWvZdwSSik+t1BiYd8Gz9PP0Rgabl2SFGEFVu+1w2XlnA4ESGt6bc5Ca3o0QzRJUsBvm+Qs0lttl9OKME5/ShNgdwK0wSizmbITyHRDoR0/la8vyk0r+3dFaSa+m+pSqPpYEijgEYp+7Pc3Xs1ZgFd+2lfEj7mhO409MZ5sFY5UoMTXBZwRUelmsXmZBCN/eihj4CtjEQsPXL3XOWS5CMfj3+h3HK1e9YMnwIHJxg7LFQQ5RNAxLBJs+TDE5M56k67ExULtCv2oZXNUTTsuGSOCd68EnIrEzD8g5RZyU518AITq4DhSCzB31gPsR2wgzenAv0Dc9+8VeGvVMB/3ri9ZdahBJ9kg2pSnK1P8FhwbpKloUuUhSlRLtm1cnEY/iXLDnE14QnplBOuqu5hVuehxFTo1+Gd6/Bp6Lq3mh5KrsBCCDt0gnEt97kismx380fYK3U4M9REvgTCPX0/MQc/y436RmRLpM0CuDbSJIhtwO0GAqJUTRNPLPn9ed9zg/4KZthhIG+I85KPhUU/t+xVzrKWSurZL/19pbRq7GC8cB80KC4di2OlpuOb2i8rFmNHOjhlkyZMpfLlAiaG/HTNSdwHq2qqd+gvkTrzre+rLX7dw9AL
 e5kT+gj7
 Qn+yo47JOva5Ia6YAUDOqDYTm1qcOgoIWR99/zq0JmADM47VqJcFPXRK33vvxGH8mIS61N6A1YMd7+KOgPEq1mxcxgIGBnTUgAyIPJ/mBXquNEuypDWIZN0BmIyUxk0dEfbSHfevlJa8c6EOa3ghJoOKzyH0mbQgrPNxfEwHf92SIiCg1UFCb41IQh3KkYPvnmVZbprT2Mc5B6X1qgI/t12DD0cj3UeT3j6ASMoYNMsGxgVb3P3y+lAOQDsOF9ejD20RoEMWeTfew0M+fqss0K4Zq2mgZaug5/cETSXC1IQRTF2dOc9cI4jrLtIzTL+DuAKEGDEyURKDDMxYbNe8K9VDs5k6/qAWo29Uloj5i5hvVwHjxbst7TXVDLXQUWfzbxibSKqyrdKwi1qB247HnZJGkVT5gINZe/VXYtGZCueqJMVlwSPaTDYjWCvvKkNLooxoDL8NIlbmY3Q01n5FLmR/QK4Rb8SOUKWa4CKpFnSGMUipzW6CxMmpXnDqv0Ox3L9z6UyrNHXOomhCJVFx3jdb1w+TtABJWqFTaq2ONoZ/Nhshyy0CQYoQgGA==
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


