Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41195CA1010
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 00:24:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D5A38E001C; Wed,  3 Sep 2025 20:24:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AD1C8E0003; Wed,  3 Sep 2025 20:24:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C3138E001C; Wed,  3 Sep 2025 20:24:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B7988E0003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:24:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 47DC51DF19E
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:24:25 +0000 (UTC)
X-FDA: 83849671290.13.32F3335
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf20.hostedemail.com (Postfix) with ESMTP id 65AEC1C0007
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:24:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Jb1OP6kU;
	spf=pass (imf20.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756945463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=incKrp2UiMRL1bfFYHRaGnhm/dsia+B968fzxhF99tc=;
	b=JGuubf8Fx0F+tFgvBkTexQOTgg/3YtGE/gsEMd4Dx6Pu886kOTDbkQuACukcUQy6Sgp6Pt
	5YRC1st2veyEdxCHNhaSAens6aQYAK81HHaVcvmGDTUgNh1KsNx6KQo3oP+sBt2BjYX7Qo
	8+iQLNCw5bVqj1738fUexPyZq0ELuMg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756945463; a=rsa-sha256;
	cv=none;
	b=R6WmsQExHALE6SxzxbslxTVq4lGWJELcJ5XXr7aExzEIWqILXILhSmfwYNR7CtPinuwhNG
	lTp5exRbV7LkROMCnJBgk1Kj9vCa//nPdvo/L5hdmS/4HXlZ0XO+ws0VtYaaq5Aft8II2q
	BneGnLBHwipdYpoImRybAIwKocpjHzE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Jb1OP6kU;
	spf=pass (imf20.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-329b76008c6so315887a91.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 17:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756945462; x=1757550262; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=incKrp2UiMRL1bfFYHRaGnhm/dsia+B968fzxhF99tc=;
        b=Jb1OP6kUqdID1GXkRuNL2oNQfUVbkDCOwxvul2Qluu1FkQj9wdCxln2jcFlw/fLUDF
         6bAGiTUetiVVgHzWbr+TUOjdbMYcWP7onYJxMiIZn+TzJTWzEl4Cemt4MH+3QLfqYkTL
         gZbvILSfgQ2GUM+/7E1iaiyyUo8N3HSt/8JIJmpMKSakCjdAvJ+XM2mB40eZAzXSJAyZ
         KzOwn+dSnWfQBZ0IM259HK9jAyl+1ysVvzCQDa3/O/uRmojrifzRAUO3jkeGPPYe6/nA
         2boQ0eTdC6IKiIZWzM0iPwAOleWsUk2mGwZASjz4FOF9rBnVxPzuYS+bhPK5JjAQDzR1
         ko2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756945462; x=1757550262;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=incKrp2UiMRL1bfFYHRaGnhm/dsia+B968fzxhF99tc=;
        b=PypurfsXG6zsb3m1sYXspoO2cJTze/zDccv9fs9s6BBkGIideRcVLoqlGa5q1VFtw0
         xv7uMHc7ndUDDvtyX20IFJoeEEdFiDG8chPHE0s4Y5su//uWIhuEqbn1jsqhLDYxJweJ
         okI4/BhEJRxEdVMZ5gJC461JtkAQ5JkZrO9dTxiUYX16Ox2k08K2gBB+5twhFND9k9yx
         fAAJh5GDPTG8/S55uVni9JSzGvrQIZ9Tj62QmybADe1b+KcqCfJfAwVywSGcwJPRC25w
         Jxf6NY+lMP2AfkAHi/lxdy0ldDdpIQv1IaMeE41wZg8eplEq+jK/GSWVTnkIySUwTDcO
         JqaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUCWtWdoplYitGld+Ia6mM8rZjdLTS+si+ecX2DGbIvbioTlHu9mJCowRqG7oxuZY4pMMiOb417Iw==@kvack.org
X-Gm-Message-State: AOJu0YxXIO+vVbNAKTmD0+s4UkinfyzFRdFVWNDoQKvjG0SDNVuy+in+
	PDPoVjueTcG+ejRnLZEG13NQ1heN9n+MLjo5iqJQ+QlRe9KVHBX7cju5
X-Gm-Gg: ASbGncvkZlzoUwmuINL1FCAf6JQSDYoCMu6Qhskb0qiEDkfVeqJXWWewIJRQFFTpuD8
	sMv8Lx4DLP/QhW6Z8RwIziCJWSwUDiphpg+eu3ewid6G46jEcXmQE79Y0QfJWyCFZRidXFvHet/
	xj6/PRBMiCZIIbnvNapigrjOv1Z7bV35FacgQIqkgVsHswHL4izF9D9chObDNRqtmOf7AeRoEqs
	S8CYUhbqlk9Yg1U32sXCKovfxe5JcImOZ5R2ixw4DnU8eMJyNE7NJF2YFSIPPbWP17b/Fq6KZT7
	+TBYLFZ2JaTIGU4J5fgqSFrKar8jVkddfLj4g0ShErf5RbfKS7+6LiAVWufecLmKO0b/ihLAsAi
	+hv/w35eVQzn3fnHMwBJT4t2j/efc1os5fWF0VHZjD7m3iZ2IxhjH
X-Google-Smtp-Source: AGHT+IEWdRv7pWRXFkXZkWNxZkP18IvQb4vEl1O/0LufV3mWJr4v4vPlNk8x7dizzsCLeMOYBwD13g==
X-Received: by 2002:a17:90b:3c8d:b0:327:ea30:4 with SMTP id 98e67ed59e1d1-328156e0093mr20349272a91.30.1756945462223;
        Wed, 03 Sep 2025 17:24:22 -0700 (PDT)
Received: from localhost.localdomain ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4bd2aesm17579551b3a.48.2025.09.03.17.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 17:24:21 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
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
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH v2 17/18] tools/kstackwatch: add interactive test script for KStackWatch
Date: Thu,  4 Sep 2025 08:21:14 +0800
Message-ID: <20250904002126.1514566-18-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250904002126.1514566-1-wangjinchao600@gmail.com>
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 65AEC1C0007
X-Stat-Signature: dquyrbkcid85d5k77k6t66pkbmuoxz4i
X-Rspam-User: 
X-HE-Tag: 1756945463-914649
X-HE-Meta: U2FsdGVkX18MogPMpBIV8G7Ao2lgjNu08bvxHcw0Zx8l9hUOR9FXo//c3GF8j0RgCcDe3MuQ6fGNy23JBJjRypw1LdU2eTfUqGDzChaGRkwIItHMejjMxzGPVh/pCAt5+IHJG/BpOy3S2a69gcK/ydFuFB/dlLbK2YJ/PWSANFnC0RMnRG9GZ2HBKA3SMB2x/CEMNfJPe6t1msYwD0h4Oj2JiST3pBH8S9Lok+FIDw9VUaPTIYBP5oYm9/NIbp2kC/pxCgmsnOs/fq/JFSd9YkEa3YCS1YVWbyU4iDO5abDA+n9lRt2Sr6MKvvVpi06CIa2BeEJGHV5gT9NuR/rs5liejyWeP/B2u5HDwtULTgJ7PMbUG4BKj7g8j1UCHyfdzB2QB0O95G3/Tl+7OnkrTaCqznjTwKmDmZ2oFi65l8mAdCY+R3ebmOGpjmV4jA6QeiGsQqE5kJsRZqyXVpmW3HHYJJ5ayJZsm1xsecRre9ut3BRgP2RjQm06EFTEtcyRLQtthCu34uuaMbmv1DY8BOvW9yvTavyJMlrJQR83sIURVLWxJhpWjTo7y9I+XXIlXjvxQJVo2tlsNJe8yIrlVmRLkqdVjy+up2gtGTsEkyaK5c86DV3eXXseGY6u+//b3FonY0rTRJfO3/kfhPxqOvxsV+y6eqdBbfyidhOlk4/sGYOnpWe9VdD7eDlBfFfoWTorWzHvA/ULoEqUnA7jjL89ZYzhtvGC3tjHgSIfNfN6WE8kwoUHKT/oKk7crZ6Kk0lZuDMuV0K+46TPQgI1Trr971zf26eJDDjIJKmp1dH2ttnoIx0dcCOiFgYpQlg1Q94hqggSx8oJcnMhYIri/o9L6EHHjxy16BL9zkB0E6Lg3yFLH+NYBWyRznk0rEfNDTMugoD6vs29D7+msikN73JPDOvFja8GuN/+83+jxnGosn2bBBJLQRDRRTF2u0x7xv0YDUBwjelOSzlojwc
 uC89yFA+
 ySQy5E54GGqjDbR9d42Zd0LUm91al1j4s3ugJTnWGbbLAOWXxSEfdhHSFEJsCmx/YAFdz4XRUOPpUge5s9s29fco0I6MBoBqKVI0eYNYncQBgR6Pe7segWojKN02sfgcnFatTX+6ZemvIEhtU8cyENzUqwge61CqFlKhPY9BbnvgTA3uDhMBG0vHHP8gG3BL7bBhGXpsYN3CTaCU4a578K+It+oCDE1ozuI3mhoengGUsH0twH9KcjY9pQfNnYbCarmM8VvQ4nlPCO37BO63qh9YuBO2aNUzCvgXnUlJuVdROnnUKjQyEklJmhcol6WsjnQlfp8CLOO2QS4ABbynPPVSe5U9MojIPGlwsuA4ijyyZCHigxLT4dPIGcAH+HoQqPHskxCnqQ9EH/5cVsaqVIeg2BxsqCwlyF5rfX3SjCEXj+be9THyX4DBiKA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce kstackwatch_test.sh, a shell script to facilitate running various
test scenarios interactively or via command-line arguments.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 tools/kstackwatch/kstackwatch_test.sh | 118 ++++++++++++++++++++++++++
 1 file changed, 118 insertions(+)
 create mode 100755 tools/kstackwatch/kstackwatch_test.sh

diff --git a/tools/kstackwatch/kstackwatch_test.sh b/tools/kstackwatch/kstackwatch_test.sh
new file mode 100755
index 000000000000..fcdb5ac9b607
--- /dev/null
+++ b/tools/kstackwatch/kstackwatch_test.sh
@@ -0,0 +1,118 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# --- Usage function ---
+usage() {
+	echo "======================================"
+	echo "  KStackWatch Test Script Usage"
+	echo "======================================"
+	echo ""
+	echo "IMPORTANT: Before running, make sure you have updated the offset values!"
+	echo ""
+	echo "To find your offsets, use objdump:"
+	echo "  objdump -S --disassemble=canary_test_write vmlinux"
+	echo ""
+	echo "Then search for your function names to find the instruction addresses."
+	echo "- Instruction offset: address relative to function's start"
+	echo "- Stack var offset: distance from stack base (%rbp) to the variable"
+	echo ""
+	echo "Usage: $0 [test_case_number]"
+	echo ""
+	echo "Available test cases:"
+	echo "  0  - Canary Write Test"
+	echo "  1  - Canary Overflow Test"
+	echo "  2  - Silent Corruption Test"
+	echo "  3  - Recursive Corruption Test"
+	echo ""
+	echo "======================================"
+	echo ""
+}
+
+# --- Interactive menu ---
+show_menu() {
+	echo "Select a test case to run:"
+	echo "  0) Canary Write Test"
+	echo "  1) Canary Overflow Test"
+	echo "  2) Silent Corruption Test"
+	echo "  3) Recursive Corruption Test"
+	echo "  q) Quit"
+	echo ""
+	echo "WARNING: Each test may cause system crash/hang!"
+	echo ""
+	read -p "Enter your choice [0-3/q]: " choice
+	echo ""
+
+	case "$choice" in
+	0) test0 ;;
+	1) test1 ;;
+	2) test2 ;;
+	3) test3 ;;
+	q | Q)
+		echo "Exiting..."
+		exit 0
+		;;
+	*)
+		echo "Invalid choice. Please try again."
+		echo ""
+		show_menu
+		;;
+	esac
+}
+
+# --- Test Case 0: Canary Write ---
+test0() {
+	echo "=== Running Test Case 0: Canary Write ==="
+	# function+instruction_off[+depth] [local_var_offset:local_var_len]
+	echo "canary_test_write+0x12" >/proc/kstackwatch
+	echo "test0" >/proc/kstackwatch_test
+	echo >/proc/kstackwatch
+}
+
+# --- Test Case 1: Canary Overflow ---
+test1() {
+	echo "=== Running Test Case 1: Canary Overflow ==="
+	# function+instruction_off[+depth] [local_var_offset:local_var_len]
+	echo "canary_test_overflow+0x12" >/proc/kstackwatch
+	echo "test1" >/proc/kstackwatch_test
+	echo >/proc/kstackwatch
+
+}
+
+# --- Test Case 2: Silent Corruption ---
+test2() {
+	echo "=== Running Test Case 2: Silent Corruption ==="
+	# function+instruction_off[+depth] [local_var_offset:local_var_len]
+	echo "silent_corruption_hapless+0x7f 0:8" >/proc/kstackwatch
+	echo "test2" >/proc/kstackwatch_test
+	echo >/proc/kstackwatch
+}
+
+# --- Test Case 3: Recursive Corruption ---
+test3() {
+	echo "=== Running Test Case 3: Recursive Corruption ==="
+	# function+instruction_off[+depth] [local_var_offset:local_var_len]
+	echo "recursive_corruption_test+0x1b+3 0:8" >/proc/kstackwatch
+	echo "test3" >/proc/kstackwatch_test
+	echo >/proc/kstackwatch
+}
+
+# --- Main ---
+if [ -z "$1" ]; then
+	usage
+	echo ""
+	show_menu
+else
+	case "$1" in
+	0) test0 ;;
+	1) test1 ;;
+	2) test2 ;;
+	3) test3 ;;
+	help | --help | -h) usage ;;
+	*)
+		echo "Error: Invalid argument '$1'"
+		echo ""
+		usage
+		exit 1
+		;;
+	esac
+fi
-- 
2.43.0


