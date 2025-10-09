Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1176FCCD187
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 10:58:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65E2B8E0085; Thu,  9 Oct 2025 06:58:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60F578E0002; Thu,  9 Oct 2025 06:58:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D69E8E0085; Thu,  9 Oct 2025 06:58:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 351DE8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:58:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E3FDC14084A
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:58:05 +0000 (UTC)
X-FDA: 83978276130.22.2ED5D46
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1761E180005
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:58:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cxd+o8Xc;
	spf=pass (imf24.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760007484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1RtyZdLa/V9peD4vyIt7vF3g+yVd+tHG9wNYuCcZNH8=;
	b=Jfp5Oxf0wZ0gk7xstsoTET/VZh2IZQUaca36jX0YagmRqQjWDvxM9+nUTjbvQgOx8hj6cE
	FF42sVTZOJE1tD6ALJHQhk1VWVptwQRvYzHJi2M0ylEIQ3FlHnjCXieK6h3w+Ud9lq4PQb
	havbjMwz7Xn1fZkY13RK6zDxEiKwj3c=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cxd+o8Xc;
	spf=pass (imf24.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760007484; a=rsa-sha256;
	cv=none;
	b=RnAEvjYNy1tmnRijpaDnaViWrDWCRPJWJHKhraUdBDPwlFGWbDUoYQ6HExitYlLDx+XS34
	lbrPWEhyCvtKSe4SDxq81UMXKTh+0LS2p3UBXGZZ+vPosnudDaiCw1V1JuGxNr0l8CFHK5
	cBvEMMR06lrRzSr+jUW+rmG6hLK9m4I=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-78115430134so563791b3a.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 03:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760007483; x=1760612283; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1RtyZdLa/V9peD4vyIt7vF3g+yVd+tHG9wNYuCcZNH8=;
        b=cxd+o8XcnwN61y5RUSJ2ycLSk53ZxzoPCz+AHSEhNILBGoEANzdZ+JG9+Zuw4JRJUf
         VW7JYmjj4HdvaeMsVXYwUfoyEXaiBnIlZ6qbg5nwRmIf8WzZ56HNefe1LRKiwkDSLSOc
         n+A6ISiJQBAg4A/PanR4fZiby8kh9EO238Q066IVZkjHF3OxOCKlsPlEOuW4Fd9Vvn76
         vytDUd21rfI3E/EFdUuWL/rxP6hB8cGFtJFvyTWOumQA+ztc6BN7p+vXF12FL8s9O366
         Qn3BIdSC/iqXCGUiC2tZ6k51+XGXvmpvs3b1ZHhU8E+0CDjJGqAyMyYbPwlEFYgyeFjg
         V+iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760007483; x=1760612283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1RtyZdLa/V9peD4vyIt7vF3g+yVd+tHG9wNYuCcZNH8=;
        b=wiIRc+iR71pzR0lZ81BN312ah3zac0mXDW4mP2A/6YrH7NuZ0cr0h2ECx+lVsmvTNi
         VgI0Vlg2QPvU0zLlXqBOxMSnTOZZpf5L1halz4/4db50VGEUM085Kt07lMJPeCdsXuEk
         iP+gJBFrJ2wlfdwieUOS3LwPgexzm58t+7MKk9tpfLc47eMx5zrHNT7YbIfv0wQrO+/g
         YH6hgfHc/Bmoygy7caaFsj8D2zqIgoKj5FKFlTJKu1UAHxTIkne5brk3NDkEHAa1Uf09
         mxHK3arUQngau5rawh6XTYDxhnA6O0aBZbaGJAMP9vYRc41+V9f+gp1Jq6tVvZKhw18u
         4Lug==
X-Forwarded-Encrypted: i=1; AJvYcCWFn/jkGKzxXiBQBNuE2bGbChODcUmpHqTXVCl2Qg7IUYwLkRGoGo4hsIlggyxICHPOpMyYOEQ2Iw==@kvack.org
X-Gm-Message-State: AOJu0YyOikn5mR+fX7FYVjk8E18bCDGRGGrg7XuJNP5RXjh4CBL8z67Z
	xxJ5fOysIZSsj6fb8SrA2HPRNtUa5k4/IhgYvDplx2m1my4f9+SODDXF
X-Gm-Gg: ASbGncvhMR7gtQ3Pi76f1i37PKx25JTyXupKQo1gnaREe5Nc282uXh2vOQUcUJTZhYc
	ZBI3R/jKVF0C0cyMTxtu0pEkI6C/ZhGzCUH2p6tx6M8uLE82mYhvDuWRFEK0qB3zXyDqW/lzylg
	4kZETkGh3nDcPQFS0cU6Cvbo1ST7Czz1hsiT9OpRSv2O/3TVKxdVlTPOmb+SiBkytp6oZGxg6jw
	pCyBgcsROYvPDU9IPIyXH89E7f8tizasCn9Qtb7kFq4cmlRcjsvaZqAPIgmUgBsh7ibuNDnQCvo
	ugiL69I8aZ8IbAn54H1VsrAFUeHZ6lmzKQW1DkOJt7/hELEPK6bSXpRex1TxoKnzVs8ZyvBRPZ6
	NlEaoS1FgplsmMfLJFfU4Xf55WSrre2hC82iDW47oA6mlPs4oYbz7U48q8XXVVz2SwMnexQ4=
X-Google-Smtp-Source: AGHT+IGV1mxHWu3pQaxCo2GAVbKHGeNdLDqI1po/b05L3G5Ejn51+25jeUHtC8qpbOYN5GwS7DtIXA==
X-Received: by 2002:a05:6a20:12cd:b0:2f8:4558:ad9e with SMTP id adf61e73a8af0-32da839ee26mr9375118637.33.1760007482826;
        Thu, 09 Oct 2025 03:58:02 -0700 (PDT)
Received: from localhost ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6099f3b041sm20711876a12.24.2025.10.09.03.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 03:58:02 -0700 (PDT)
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
Subject: [PATCH v7 14/23] mm/ksw: resolve stack watch addr and len
Date: Thu,  9 Oct 2025 18:55:50 +0800
Message-ID: <20251009105650.168917-15-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251009105650.168917-1-wangjinchao600@gmail.com>
References: <20251009105650.168917-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mmcem3g3yzz9qosu85ifhhkzzeq7dsm9
X-Rspamd-Queue-Id: 1761E180005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760007483-177753
X-HE-Meta: U2FsdGVkX1+gRqErK/fWw36vOmDdRqe0e1DQTKSmEUkWJOW2D0pAN26DchcaWOQMTEJ+1ThNghNjL0UpIjmLKyBITqUUokdku+KrDn8RjArczSObyDR8Imz8BQxqBBCwpPZZ9nu/n3ymdP4Bxy05sdBMv+dJfaqsDuR113/yXrHql4sZzJOjEZBTVKAGMDpPF4UWIOeuBPYk+Carg0pMxKk0mgb4CB6Gz5C2QxxI24KU/GDq+79jZQYQJ21hMgaXNjxGs7r2SwK6O5k+ejYdWczwOIDiiJp4Y8BFsgapX0ceqObJLpv40ptdPcnQJLo5Bfx9SJpEPib2wJamSVvq19hH1CtuyRBr7mHIVGBfZxkCRzV+Xl5RRYVsSbdUmzzaS9SeRA++PnAKZm48QFSfiV7mYSddSILB7KgRShlq1VMLcEpc7IyGh5/kquVhAyEw7otu2AtI83eXlXAPvR/xKNe/y2ygMlVgdrWR9XDveFZG9LAFD++pmXb+Aaxfsc2G2nD9hun1PkFS3aN6KFC1XIDss6HzB0My/45z9CBDM+jgOtzmDbC4S8ia6U6QPGu/hto8tR0FhgXy/kbrCh1C14nsFaRRglCEUDAoXv6yxiZ92ajZpPlgFilJxp6Bu14Uqlmgt5yWI5cL2yjBRPYY1gVdx04nahzpf6ut0jLYahBf39GgAomUUb8vA4Ho33dqx7Bg8CUJhsYArNXlDWrtIXcj9VvLbnM+Ly0EkFTxm9AcHNRwxI4RiofXmP3ab43X96ZqBzjI6jtBwL3eSuTxNxiP1rg3B9HKNQcI2dTP8JkZ0SDA2LRkzuOAW3HwggOSphWFCrBxGNS1F0hYWNsgO7gd3hHmDn1kEmGz7sw9sX4vkoA4LDBYxsn1jkFt1O6zY1wmZ8XE5+VY+gEvVc8w76sqLmVxp7jBaTrzM8zZSyfaI7p1PrdCB3XfQaF7eP30dOVLAmjiHPFQEtV6q8P
 bRRlKfQP
 AzmKrMFaPTvT6SK29E24du86WAOTGDccnHaOZAKzcV7IcYKk04adHKTsIVt0v4l4q20jpdFJoQuXdzdiTlyZxNPDmM7Q/EgVX+SIoOhRy/IKg7MP/ue5U70a6SedxB5mqaweqMhRpOnmBc8IJuiARFlb2VfMpU1jBNk/l3xLECg5jtJe00rcPzln9bba62WaZDGTSXuH/dKiEnjo591EYJ6g/JSpGtfqcG4qnnRm5Xk/g7luSXCF5jYc7W4fPjCy/GQmx44sfRPUWvmc42EqZsYhOZ95tBnce5ZC3Ic+C4LsWCqG/qQLiTR8j20GDfGA9VA1Lmj9300T4tCFERy/53HsLmmGxNQ7n6e4GXNZ0g0zyy0cphjyv6BP5hGPtHSqvoFpSdXt8GSTeoDqf087JmB3WAXlUctS7/GuIZ1LvppHLNC6R1CmLHm3bJx8eqaVIXCFxLmvny8FUZEqj1RX7qtxYTVECE7y16iMlJsV2y71Q42xbYyvmqlyj9LX45MuxwctJahP7sqwDc504DyfgJ8v/UuvYMp/EoiDpz0snJ+V7NQxtiALYyBQVs+SoIfwtG5HSxcKTFpPJ6Q9pbgs8Wl6i5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add helpers to find the stack canary or a local variable addr and len
for the probed function based on ksw_get_config(). For canary search,
limits search to a fixed number of steps to avoid scanning the entire
stack. Validates that the computed address and length are within the
kernel stack.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/stack.c | 77 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 74 insertions(+), 3 deletions(-)

diff --git a/mm/kstackwatch/stack.c b/mm/kstackwatch/stack.c
index e596ef97222d..3c4cb6d5b58a 100644
--- a/mm/kstackwatch/stack.c
+++ b/mm/kstackwatch/stack.c
@@ -9,6 +9,7 @@
 
 #include "kstackwatch.h"
 
+#define MAX_CANARY_SEARCH_STEPS 128
 static struct kprobe entry_probe;
 static struct fprobe exit_probe;
 
@@ -59,13 +60,83 @@ static bool ksw_stack_check_ctx(bool entry)
 		return false;
 }
 
+static unsigned long ksw_find_stack_canary_addr(struct pt_regs *regs)
+{
+	unsigned long *stack_ptr, *stack_end, *stack_base;
+	unsigned long expected_canary;
+	unsigned int i;
+
+	stack_ptr = (unsigned long *)kernel_stack_pointer(regs);
+
+	stack_base = (unsigned long *)(current->stack);
+
+	// TODO: limit it to the current frame
+	stack_end = (unsigned long *)((char *)current->stack + THREAD_SIZE);
+
+	expected_canary = current->stack_canary;
+
+	if (stack_ptr < stack_base || stack_ptr >= stack_end) {
+		pr_err("Stack pointer 0x%lx out of bounds [0x%lx, 0x%lx)\n",
+		       (unsigned long)stack_ptr, (unsigned long)stack_base,
+		       (unsigned long)stack_end);
+		return 0;
+	}
+
+	for (i = 0; i < MAX_CANARY_SEARCH_STEPS; i++) {
+		if (&stack_ptr[i] >= stack_end)
+			break;
+
+		if (stack_ptr[i] == expected_canary) {
+			pr_debug("canary found i:%d 0x%lx\n", i,
+				 (unsigned long)&stack_ptr[i]);
+			return (unsigned long)&stack_ptr[i];
+		}
+	}
+
+	pr_debug("canary not found in first %d steps\n",
+		 MAX_CANARY_SEARCH_STEPS);
+	return 0;
+}
+
+static int ksw_stack_validate_addr(unsigned long addr, size_t size)
+{
+	unsigned long stack_start, stack_end;
+
+	if (!addr || !size)
+		return -EINVAL;
+
+	stack_start = (unsigned long)current->stack;
+	stack_end = stack_start + THREAD_SIZE;
+
+	if (addr < stack_start || (addr + size) > stack_end)
+		return -ERANGE;
+
+	return 0;
+}
+
 static int ksw_stack_prepare_watch(struct pt_regs *regs,
 				   const struct ksw_config *config,
 				   ulong *watch_addr, u16 *watch_len)
 {
-	/* implement logic will be added in following patches */
-	*watch_addr = 0;
-	*watch_len = 0;
+	ulong addr;
+	u16 len;
+
+	// default is to watch the canary
+	if (!ksw_get_config()->watch_len) {
+		addr = ksw_find_stack_canary_addr(regs);
+		len = sizeof(ulong);
+	} else {
+		addr = kernel_stack_pointer(regs) + ksw_get_config()->sp_offset;
+		len = ksw_get_config()->watch_len;
+	}
+
+	if (ksw_stack_validate_addr(addr, len)) {
+		pr_err("invalid stack addr:0x%lx len :%u\n", addr, len);
+		return -EINVAL;
+	}
+
+	*watch_addr = addr;
+	*watch_len = len;
 	return 0;
 }
 
-- 
2.43.0


