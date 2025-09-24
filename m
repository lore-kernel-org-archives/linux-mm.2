Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61EB9CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 12:00:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF1C38E001F; Wed, 24 Sep 2025 08:00:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC98C8E0001; Wed, 24 Sep 2025 08:00:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADF168E001F; Wed, 24 Sep 2025 08:00:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9850D8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:00:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5798B5B639
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:00:51 +0000 (UTC)
X-FDA: 83924002302.12.062C06C
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id 84D00A0011
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:00:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lII+AaKW;
	spf=pass (imf25.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758715249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l3XGYZ1mTVo1cX+yb2z67UYPJCwM1YcVlAKDPd0GQ2Q=;
	b=YnYCInHirTJm5TX65KRaKEgRsP46CyI4mMbnFww2cRRkj648ANE/XHntQQv0JBNKZ08S67
	woBWKfiqNY9zbA4NdffILulUcK+NLn27lta3VR+ZD6G1Rh9t2E/NrFRRrb+X40OvH0X4Db
	8J/tWU1SPHr7aAiI/ZXJpSCktocL2n8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lII+AaKW;
	spf=pass (imf25.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758715249; a=rsa-sha256;
	cv=none;
	b=XZbXCSLT5YWZJToLql92dBtIa78kTN6DfwCku5apJ6IfodNah0dysq+Q15/2fzeovdzWP9
	Iy3OUlNPtRCfQpMTvv3pI111gPpS6a+u3+PMnQgMoSd1ZNxfdDgJjGgOuTlVlOjM9/O2mC
	8CkK8vh6RkWqrqPb2KSmkDJZw+nGASQ=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-77f7da24397so525446b3a.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758715248; x=1759320048; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l3XGYZ1mTVo1cX+yb2z67UYPJCwM1YcVlAKDPd0GQ2Q=;
        b=lII+AaKWfVId0qNSqro/am0Fi/9D336+Dquja/mHMcds5qMUsbZ/hoT+Yqp3HhhCCt
         wP+JpfmhgWOQ6BE1NCyxlwt7Eogf3FhSCmOzX+xCAKCY18v0A/XkMUZCfrFooezcrK0d
         z1tOAyBuwVuyWGeZj4dkvo3LjntpGp+/DIv2nHo5Ak3hne9wVv9eYCvvRcj5LYzINEKd
         Ti2eDiy9JdW4vVwlMt6GANtFbNzFNeIIk/gUAuT2WPx/JWW7Mtoi9nkZ7XzX3rmocWey
         3F0Wed9QoRJilNB/0FTWj7QcF+MCfTLH4abk3lVjC3r/DzjFF6zANhF//Gm8RImmpuHT
         NdrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758715248; x=1759320048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l3XGYZ1mTVo1cX+yb2z67UYPJCwM1YcVlAKDPd0GQ2Q=;
        b=uAH2BhT5fOaEyOTa5177D3S1kUK0V8n+0ShChN276PC9G5h8PuPuxC7ieev9USG6Ld
         +EvZQ4qM7y3cfw7hZFaa2TV8aQrhEx/u0fMAJA3o55+lpmNMtKDm02qkn8tqUZ9qR5m3
         NSmt5vCtBA1issIkXjTOADeLJf4VErv9GvXqQmSmh/7ZVmDzGcMS9nVxWrjk1joxAgyU
         J+d7B/hefuTQEoQRdjAAmUZbUyogbdd4npaFYf7NrryVv1HW74FRH2XLbdiAxdjUcgQw
         dXFUNJnHtSikYS5lhg2u4LOh5+cSrkmvDFpyLAW6du9f5ZKrgxoTA+8iAAvfjZwSISzP
         ziBw==
X-Forwarded-Encrypted: i=1; AJvYcCXitLZ2Z5AlGsqBc2VZGMGAEiPVNm8E5H7k9LNTo1eZG5vECujuoqGUS4RnVBfXPW4ntSnxtWyhMw==@kvack.org
X-Gm-Message-State: AOJu0YyzW1Mp+KbqoC30lxE2O0r17+GCKkydbDAra9Pn1CVp+A/3cepC
	pPxJ0sNr0ZHv27sBTTkeRK7gJ7V12DDrG/m89hR1doEV+VNNZ9YZ8kYx
X-Gm-Gg: ASbGnctdEnBazM1Ce5M73uSHle5//6NBkVDrzE4jY13mCKLo9X22yjxHErynVqwN3jI
	si8kSLmSMGoPGwygxrGrLGpI9TAMXcR2lCUvpNjh89NmBrHZgln2SP/7TdUHD99KWzL5H8fmmP8
	JWWTK53RdpAJ2LKJ9PoE/SwIq1+tIEAqjO/CSYaBxfDKWdgkGJx5BSphMOEdsoC17nRKYuzs35n
	Tw0ASIVr/ky6azwlc4BBafKcLah+YyqfJEtryjZkpgDTfHXXT2x/v4K5iLnnik4hCJSrkAnGYb4
	axVrBhI4bAlc/iNvSq18+nlqee/GENSM8dVSP1Anx35qNnOieLL8IBGv1L5Ls9X3KKPisOJ4Bi/
	jfuX7fqIbS0KEB32jCG7NsYU=
X-Google-Smtp-Source: AGHT+IFjwxI+PhtV7jgjoa1gOIc2i5iuKeq4ASvkc/Bz/cNSIoBtm/vDSyxk5EpYVIU5WEV3bOsalQ==
X-Received: by 2002:a17:902:d113:b0:269:82a5:f9e9 with SMTP id d9443c01a7336-27cc79cb20bmr41740315ad.29.1758715248144;
        Wed, 24 Sep 2025 05:00:48 -0700 (PDT)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ec0d14344sm19610475ad.126.2025.09.24.05.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 05:00:47 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
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
Subject: [PATCH v5 21/23] tools/ksw: add test script
Date: Wed, 24 Sep 2025 19:59:27 +0800
Message-ID: <20250924115931.197077-6-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250924115931.197077-1-wangjinchao600@gmail.com>
References: <20250924115124.194940-1-wangjinchao600@gmail.com>
 <20250924115931.197077-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 84D00A0011
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ewk91ztzrxgqhdrqpssx1r17wn8sq1zp
X-HE-Tag: 1758715249-66348
X-HE-Meta: U2FsdGVkX1+z/UthOzlNRAwo5bKWA7licZldE+xUGdrcHFIAL36mxyjaxX7HjYBofrNcm2jSRBJJxu/gI6W6jjJeIWyNpqRfaBVFUpHw7I2yp5EHFloB/wQO4uHKyCWUPXmJsv+7zjbEXzWVexl4ewEm9TG1XlOrpROyPj7Bvo3ASsQ3ExL38KhvOhyK5wdjxptuzfS5lMnrN2hrBhW7dDOAbpLbNT/bax3IbSk2mSGV8EG1R4dbXE+jSd+ClsYXKmU5AaGbxqtP6EJ/cbRN1XKAQ7yaoI67UScCA4ZAkiUYZ0ko/j+mfzz/a4dVwZETcUNKvUAowrY43NKh+a4eGzzK/gIeIfw5LiyqGcRBct86X30AuvGo9ZkALC1VBoJv6CoxM+4TCJsVnUBDxE/O0w6KVgO+fbMAq4io/lOecfUSw3HmfKIH/f5cJgwFcwT1dexfRBMqvRO7e8m849yWQ50uguYh5D4PmEpsUpW86azq9gAzlfJ/vwGWu0tSrTI6kSCPzsk/ARgEuejxbmQkSYZ+3n/TTklbXgPq2bTChcK0R9A9tP/6b8jlzouXDYiqSKnp6TjWWTYDep9OTc5h4lRgAHcC/y0yDwnK8ythqrwOJyoIJRk0LASskpVj/r5/krwEs3ejEtN4+AvvIdC1TfmbxW3aC1z+E/Z2PJBdwy1LC5lAPCf4MmztZx3Rdx5wLRdzk4PSjUA9I1aUvVLbdbxXU7+krUg84Xpo3pC56MU0hY13gE1CPyWNCar1SQT/85iHu3L8vhg6C+fWYZpK9kjnU7TVkqbJSdgmNxjonJL14XUnOG8nYMHEJnn1qB8PemMnOhOT9Fvr7vniINlQbwN1aaMSNq61Zq1h2foL8Ds7Dre5/o4b6ARXQPvPWnypAxJNhuwvv6KCIHroE+CG95H5mPTh8Sw8RbV28ByZWZhOZ+NLFvYoVMq500khdAX5+rHXBRMMITZIidT+LLX
 jPTDRp8G
 yY6Id1K8Z2JzyoH7Ni+m2a5gC7IuJcNmBgvN6o3NInTNTTChKiOyX7dv0K/dD224e6Ovzh+YDua+R3rS2KSDA5V8BWQPYh+x1gAnfB0vSfyUoLnrJ0/m+s9MIiuDljPgAVrTtfd+sYKrgz4+pivB3jqnkChcJ8Bp/xP1bnQxlJXDbS90gfJWh15ydBA==
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
index 000000000000..aede35dcb8b6
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
+	0) echo fn=test_watch_fire fo=0x29 wl=8 >/proc/kstackwatch
+	   echo test0 > /proc/kstackwatch_test
+	   ;;
+	1) echo fn=test_canary_overflow fo=0x14 >/proc/kstackwatch
+	   echo test1 >/proc/kstackwatch_test
+	   ;;
+	2) echo fn=test_recursive_depth fo=0x2f dp=3 wl=8 so=0 >/proc/kstackwatch
+	   echo test2 >/proc/kstackwatch_test
+	   ;;
+	3) echo fn=test_mthread_victim fo=0x4c so=64 wl=8 >/proc/kstackwatch
+	   echo test3 >/proc/kstackwatch_test
+	   ;;
+	4) echo fn=test_mthread_victim fo=0x4c so=64 wl=8 >/proc/kstackwatch
+	   echo test4 >/proc/kstackwatch_test
+	   ;;
+	5) echo fn=test_mthread_buggy fo=0x16 so=0x100 wl=8 >/proc/kstackwatch
+	   echo test5 >/proc/kstackwatch_test
+	   ;;
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


