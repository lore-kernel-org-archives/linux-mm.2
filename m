Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B57A2CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 05:33:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A3428E0022; Wed, 10 Sep 2025 01:33:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 153838E0001; Wed, 10 Sep 2025 01:33:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01B358E0022; Wed, 10 Sep 2025 01:33:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E16DA8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:33:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 90A1313BB25
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:33:57 +0000 (UTC)
X-FDA: 83872224114.17.476FE86
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf24.hostedemail.com (Postfix) with ESMTP id A99CE180004
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:33:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="YW/zmZ2C";
	spf=pass (imf24.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757482435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pqWZ4PXPvcwGUSVpTO1OvKWC6TpQO7QLp3apqR6W4A4=;
	b=a9QA03vaXuSV6Y9lfuf/CYQPJ6lCwPIo6nBXhCNOg7lK7p9fFgDPJ7xV+FxQOZzzxRuRTm
	F6HQArOSsanbxTG8fjs3HtPAkpZ65wAkITXud62sY9eeV20H1icc7pQCpNtUDxMiwv2cFN
	TMEOMgFZ8eqQuuQlz/ffm926SMy4jt0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="YW/zmZ2C";
	spf=pass (imf24.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757482435; a=rsa-sha256;
	cv=none;
	b=V1C1L8Ll7TyuZUyHGMBEl4UwDWdFyjDld/cSlIuxPMszlKTmnCC81m26RDTYaIXLHH7v3o
	IGD6Wj3FazBnlF4yZ/w3QW5ODtBr3ItnKZJLj7HsHhcnjDH4v36ZWuWzfZCpf/GYeKCEW8
	Aqya/UdwR60QF5arfcguKtxq4xvkoG0=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-772843b6057so5340074b3a.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 22:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757482434; x=1758087234; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pqWZ4PXPvcwGUSVpTO1OvKWC6TpQO7QLp3apqR6W4A4=;
        b=YW/zmZ2CF7fiWLIMJ1XSu8lEVLhExhqBhsQ1rhazYPrYryNEaOoRyBpsIjPuY+dK0O
         LqZXfGnNswp8niUsTVMBGw6mSI0XPrxfaWyyhcY29ZzwDP2ArdLIazyBXyPpfSAFFqXX
         ImY34NKQPZi1WJwwCQu8tp2+UWrSYorEyvOYGOLx+HsdR1NXEef5Gsk2G9Kca0Kn3eDA
         tk2G92x+IHl5tmhWTW9p5Uub21aIMpf3u+Y4kahEfSDEV1MCYGis257j6gqZ0XCO9w0S
         KVe5x6QkBDfmN1Y27bU2+q+WVPf+BGA/13pwc+CEiaCBw8jFlapB5wDxc7tMhqnZnXXA
         lohg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757482434; x=1758087234;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pqWZ4PXPvcwGUSVpTO1OvKWC6TpQO7QLp3apqR6W4A4=;
        b=oH8JLFatb+CQ/pnULn8oYWVwKeeMWrxguce4lutlM5HqhcqVftIllnt91vgkU6UGWc
         C++b5A0oV9FgnFL2efvEKPCF+z4JyBT9kVp4XHwkgFq1L/RbjhzTNSyekB7vFygZ5DJG
         g/7PxqBOP2s+9NfnpQZM6adokVvCaRwyhS+uFovo4U7MmGLp5SbND1xCZr9Nb/6msFxE
         R+FW4Y4Ct9OVuGpOhstXdsKZRqUmv6vix7apYPN92S/q7OiRgd4q9mqkXWXCHVsTukug
         PKyg6bdH2s8rs2RyDkKx8Ole/kCb6XY8Kvpxba9ftpX7bUD7Gv222VzpshRH+Lxw+wWU
         5rUw==
X-Forwarded-Encrypted: i=1; AJvYcCUpmq40qxsCmVOdX4DeTzUNW5I5GcxIvOaUiGPYflY/UjyfmvKkOcsdHfYb9jPVn8FE2F9TFOfSeA==@kvack.org
X-Gm-Message-State: AOJu0YytQy9k/NcevJXn6rBcjm8UtxApxuKCD9iaudxkqXoOqVihTdWJ
	qEt21FRFl/io1OwJ9kEm3AY2Bst3XoUmvt3MjYpM8SsZKVy1Iq7Yhpr8
X-Gm-Gg: ASbGncvmCO/bUkcXSeIoDdIu5UU+4v4QFYjP2LSLWqU+4kR8yL6MhqS5MbBjjUDAFf4
	aWzjG0fVngd7jqa350T6Tc2oIRJid5vO+gINVnodv37fABpJ0wjJ+7uXKmvH5cVGp9+8YRVBETU
	58fe96eD2GQSL/AZ0bbZo4Cps2EY628XRUG93VwaQObp2qkDCXbr1rllNe79O0k29Z3s05PwJ/C
	YX+8Uo5NTZ2LjD2plJ5oSKaVb3dEL1Pxf5xkLu1ikXtktOKCqxktMpAzg8snEWAvptL857pW7HX
	aMpjfPB3C2/s4sGK+mHls/M1w/JCwTXieGi+rRffDPLG3+hlLu93kRzGkiv2pAhJlCxJ2AdaRh4
	JyEcbFLg08lPEPgVwI4aEr2EAZ9yk0ZQ7EnZaAToWsrNEBCEKGHF5oKogu7OS
X-Google-Smtp-Source: AGHT+IEZNgWra/khv2n0XoAUNyfzdm90ade4Ygcmox5Pwd0/l1pQp4buy1JkzuVbOi4x7gskbJfFvw==
X-Received: by 2002:a05:6a21:339e:b0:24d:301a:79d0 with SMTP id adf61e73a8af0-25341e682eemr22538642637.38.1757482434425;
        Tue, 09 Sep 2025 22:33:54 -0700 (PDT)
Received: from localhost.localdomain ([45.8.220.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7746628ffbesm3870342b3a.66.2025.09.09.22.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 22:33:53 -0700 (PDT)
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
Subject: [PATCH v3 18/19] tools/ksw: add test script
Date: Wed, 10 Sep 2025 13:31:16 +0800
Message-ID: <20250910053147.1152253-10-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250910053147.1152253-1-wangjinchao600@gmail.com>
References: <20250910052335.1151048-1-wangjinchao600@gmail.com>
 <20250910053147.1152253-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A99CE180004
X-Stat-Signature: qs74k6rwg35rhuuwkyoukms59zogyabr
X-HE-Tag: 1757482435-305513
X-HE-Meta: U2FsdGVkX1+Crt6lEv2DMR6O6ziHBwD8QBkWNpEecaqo3HsO02EbibKtZMkCTbxI/WAjYmcHTuM1BibOABlKpuKyx3U3xi8X05BhWSYpZRIJ67Xv0MUp4IKYjqclCpZDenVvaNB+87BsG/ZYhB/xePrCvSSKXCkoVCHVKcaf/AyQrH+y4r6Bi7lbc5xcR+TwNWeYJg/cI8Mqg2qi4RSJWbpcI+l2zagxaZ4UtXe7xJjJVtSlpZ13DTmmQnJUOcufb5ujhycy/dKGF2XVeY0pfNLZcR/XFDK2j4MPDoip+PnR1VcSh9ONmuuIYZmxxTqAHBE9c3JE8W6pR2yw4btjcWVzxNIDr5TfbOCovmq3ihTbxwlSqER3YEkiloInN0A/8UeCckQF5VePuvk5hNzpQvtKi3QJurm1YhhHAXZcs3cXm0uAJy1V8YYcHDpf1g/LbrfJ87k5wRf8QuMr7H3svp9miuxG5agL6ArOH3OBreMcq40yxQxWg3G71Li3lm9/ozSH/4Kmyi4Ellv6Ntjhmjiv8bRP89dvTkPkS5aIwuyztbeoPS7rVEizjsK8RAhLagbvaMGk+PZf//PfaoKUywwPe9G25gwSGnwUkryrOKxydNNnNq+xR+2gaLq7I5/DAvv5bgY/QiBlMdNHnIHaB/9nlw5dhbtyT6bs2pxBZIVDEUbsgu4Tzm/ax6OF9nvAaCWAhRuMZ86mi9h8La9L2OOLMDCUArMmokWFOM6SG/+5PHPQbuy/3HRQDWFERV3oHDgO1jTMOwY7/IzNnnoldwBPod7pHo45AWRyro26eMy802LNBJrqv3gLN7d9ng9U2lR43zuJ4WifbrEfmwkjcHXRsKKIYgXcSi2xF6hCaO8XexDSea/gXAYTiFAAEhAZhO5Ag8RzX3beFg6S2kjQ62kcgtSnzCIZ4mxG73FOQQnOHOCXO6M793cRu55aP3qB8Q4KaX38TbOVChOGk/K
 RbncaSYc
 cqP8l37MbX0tMXMef5A7+F5WfQaOYhnLronfEG7DqPca8TVOuAIb0nBQTETCLmbQWVSNYwJId0vPLgIED04JQOAuEvthLwy4ej14m4GC//N9nuXKZA/vhSK5NLncaFbdgtBxNLnTtvYtW+mbqv3Hq1MMEJY+KZhQS6ej1vBUZJQgXGKBTGd5AU3xPbiAFIsfPwoWOvVtD9n4lJUIRtDZ6EZQpqfOAddUUnik0y0Joik7jnlMfYOJ0ZLZcTu8VCMeSdmvGHXhL8Ez8Xh4UEwQ800uOQaqmIea8fenLsym1Vo/KFKj4bWaomo5dBarZgkLQPJnRESGm50bryqwQNYXzUt3oMKh0gqNkyP4Eyh1mOyvF7qcrsNV8oo9kZgW3gw9pBZWPzjDujIfEZxMn/mX76a7ssPNdN+iHRcUTVhqqfGCVlP590F9Yb2jIFkoG0qpZKR/Br+jZPgXwO2gQukOk66wiy350RWoMHap0JW72HiIPN8LoBjztJgq+ejf4pkNv2jAE
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


