Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 764B3CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 11:52:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF0578E0018; Wed, 24 Sep 2025 07:52:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA0438E0001; Wed, 24 Sep 2025 07:52:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B67878E0018; Wed, 24 Sep 2025 07:52:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A2D708E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 07:52:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6E21E1A07F1
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:52:29 +0000 (UTC)
X-FDA: 83923981218.04.98113C3
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf26.hostedemail.com (Postfix) with ESMTP id 823F314000A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:52:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SqxmitB5;
	spf=pass (imf26.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758714747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1RtyZdLa/V9peD4vyIt7vF3g+yVd+tHG9wNYuCcZNH8=;
	b=q5HHGlXPjT4P29otwR2yMmOYsDcsbu95LftAIcaPhIMool9ofAIX9MNOf/XUcF+L8H36FS
	h+1246sbttxNlP0Dn58/Xb0fjQhzi7NTUTgpFjJxe32GTwPY3Y1ZzGFVYrkQQB1278vYP+
	9bY5WAStf0km4ZhnV0OPmbPZ3Zc6U3g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SqxmitB5;
	spf=pass (imf26.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758714747; a=rsa-sha256;
	cv=none;
	b=N7RxLsA3SMY4UMX7k4HTK3XZB4wUj4A0TvS7sAc8mRI2Lv95wExxRyWyxNFEE9pBIMIa4J
	062ASjXI9+cXEExMsR/o9oAQTaFPLC3+8AV8t/3ZYNENx7SytDUamR83lVQRBegLqRJK1e
	mYbCJ2t0eOP6O+HAtYDmHUvrRqbXdoo=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-77f7da24397so518442b3a.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 04:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758714746; x=1759319546; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1RtyZdLa/V9peD4vyIt7vF3g+yVd+tHG9wNYuCcZNH8=;
        b=SqxmitB599Gx/oND4aKGC//rj4F7NatmFohwiPHcvnBLOuOSVo0XYsSS1ZNC6wKkjK
         nN3DW3N+8m6QwBYUnxcfufNHCoKtWodxfjpC5tHE/jCPv3MCEWMD29xTobNdQZ1OpTtU
         8ndENihvpip32ntjGyMaXplFtOw2Rbc2dfmSBHqadFTTXcRzCE91TX20gaT/2DA3YtK/
         utavYRHZMUvPpNg7XYq1hkUMU+yycUtKnJie3b4rg7rCYPqiXGGv3xmbfie43Dm7CVZo
         0b1PaJL7QTo3f7xGibVl5i1SyuAJc5SN8o4iiNx5IGPMZRs3tk4STvXFpbqZi6+KgWXk
         ZBmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758714746; x=1759319546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1RtyZdLa/V9peD4vyIt7vF3g+yVd+tHG9wNYuCcZNH8=;
        b=I5Bzc73Zfs89d/N5deXf2dsnMR9OKVG8SCeHdGpIJGg31+KzGLadkxeHvzCZhJyjRE
         3acuwsncRvG5bs0B4zx/zKI4UNYMfUoxFQt8Y3xn3zV0pye3zQIe+bggT4Jfnw5mBCxY
         f1i6Fzx7VQvPrR0+ozFDx1O2DwlDMsyP0IAhPwyfc9MzoPzu87KPnfE1M7vt+IjDrKH6
         qXOGh5sjXhevQPHu/A085DtX1XuAjRWMoOlP0rEJjf6T2eQCJepNSsxlEuDdGWijjsLb
         fbEE7FeX/4i7n4VuKnBTyYRdkZOcrP5VbVuUz0fUBvld7evq1+9/2JozZvBUcRPYgB7+
         oGVA==
X-Forwarded-Encrypted: i=1; AJvYcCV09hd/V48uLVrIOQw304R1iWtbqXu5j27lf9iwNit3lOHfLJ3P755U+UPgquHIqj49S5/FPFRoZw==@kvack.org
X-Gm-Message-State: AOJu0Yxa/g8XhjRnzJ35YiEr5xhDgisTzaMYN77IUYtMNsN2MHnq4C5V
	eaYfvY2VtosQ01MncHlrGJS+Qr2JlXNMEK43iGX613qyFSQWcTFZ83VM
X-Gm-Gg: ASbGncuTFYTsMceK+ziOluaMGRtfvTLzOLGbqDed82r/uUqeIrvazSoPmjpV54oMB1P
	/OTyopABH0So/R+jn/mUWbgjGJMxpGz+zjrzZHKBhyHctH2rivGG8iLC01/VQ3yZFXNvUcPLqge
	AHiUCL5Uk2qgRwzG9xF1a8we1muZPgYncAPSNxjcULugmFZp+F3YIGdYmPvRbX4/SxK/sXQsjsV
	lZ0oOEqIk04Yc6tG1eqMrTfhEHNrCUoSRQp9W6rfbH1WS7DS40AERa/rfZcugPO1YV4wY+c3hL8
	c66kdLWCW/R7VtGJM+mpUpLyWbMDfrk1ULAa6/7ZwZ6apgaLqT1meqk8aWL4k9BEehm+tOySSPK
	yDbfgipJIHOar8T95qWQ/ZquP4w==
X-Google-Smtp-Source: AGHT+IFd3RP0c8tCn3t4y4bSe9bOx7A5o9IS+XWa0APddLheuXvaqGIhD3jal1mya9sFq0ZjmUZBSA==
X-Received: by 2002:a05:6a00:c91:b0:77f:3018:c994 with SMTP id d2e1a72fcca58-77f53a13c02mr7705160b3a.17.1758714746084;
        Wed, 24 Sep 2025 04:52:26 -0700 (PDT)
Received: from localhost ([23.142.224.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77f0fc4cfbcsm13824080b3a.61.2025.09.24.04.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 04:52:25 -0700 (PDT)
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
Subject: [PATCH v5 14/23] mm/ksw: resolve stack watch addr and len
Date: Wed, 24 Sep 2025 19:50:57 +0800
Message-ID: <20250924115124.194940-15-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250924115124.194940-1-wangjinchao600@gmail.com>
References: <20250924115124.194940-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 823F314000A
X-Stat-Signature: 5z9wbgahox5111t1gims1di6tg8dbqth
X-HE-Tag: 1758714747-677536
X-HE-Meta: U2FsdGVkX19IvF7nwUeWd1+F2QUNhKMhCxlkE+Yv7e38RJb7aR1BDcQ6JwGssqGgt0HEqcwB4J4I/hkD6v788j1Zhslt8FUa6zeNHKcf8huJDmqeqD1YWHbVPEQFkx6D1HysPn4hECKLsxijXim4DK5VyI/Aku+aJkWIufbq4gZ9zJnxzajW8TdQIGXjq7uOTzgDNsoFMbPvtz/GhhCO5kcbdUcCErFFOIBaCXOTaFVavrwxEEBt7Oi/YFtSEzRCMkEZYdWobdd9olbqNdKcbNxksoZyOBPNM6ZUPLrBPHeLoCtDHgfVlemSy7iu5XshxF6QDZRQZVJ9so7j0sF140V81nNgjXZKqTkmXm0+IBYpxxhwQ0FeWnBWlzzy71CB28R8eBwpdBUNgAMDGP/65c3mRb5S3U4kJ5221ESA3ugCYM3/Ov4eviuaqtPB9ac0iB50xV90hCsOar7U8wHWSWpGOjyvorp9zdBtmR8A6W5kWd+XutMkUXDCS4tU57DdZH0N/Ts3yYnjrGxlHLDo6RnvoTHDienrZ+pG7AgHypVvIvLJ7t2ZvtYyUXwxU44dEG5U3L0daqp7V9+FDzZu2TVhNkfZDryJ2pWzdCtb9TFSEhEMktL3AGa1R+6HeJTBCrZ7HfgLYc0z+fXhVsYxNGPfISTt3Ja2SWjjgngPVtS2oBs2WyRqTdLUDxRk+B1FFCpsMoZUxzG+jeEfRiylusCtjp1qadikQIV71bTt3r6IKrHB4WwH/cplItEzkkxcscsTC6+IB63IP+1v8mYRLOSSuqvgfl1kLTtzcukm2Yh4OzqlfB9sRSzCV6Dw/CWLfA1xFstlLcBBkGbjWfgqIZhwTOT5CiAVi7P5kignZHL57AszE+DRHIWx3XOLG+DQ8bBqnwRVTRQAGrpQem3dxW8g9hhwBc/Gova+1L6r3yRtDLML9ujsKkZqK/AF/SrqF0SE9Ts+3NSxlN+O/xT
 KiqVRhm+
 DhkIijLChRTB34sLpY3z5ziP+/rB1f2ygLjN9V2VZ7y24E97jVokj2btJP5vcajISbgBIPnnQR9gmSYZNXTyVWQisWO2SeerF6Sk8QbN/6DGsg6NosDIm/HHvTJP+ZZn9p/wemp0EkXCfWGK+9j5bF7+lSjFJDfPBG+mPxE1SZJz/osXYwcShUiIL1iHApE6VgA7KJvm4rkwAEb9isz+/UVjO71aLxktyQ+cXYv1zqFETshKC4FGE+V0WRsG1WdMpgt26tCFWH6503wAT1F951vVbX5eYkkr8hCOfFsoBBVRVTdczZu+JjFIfXE/gs5OODMtTHwniAr58EyOa53EzGKLQIg0fCIpVSOnlVdXeU/faSfnZZzn9sQPNF5fZqsD/98R1H9DMV70ClIrOjMsuiS7d1wc57cnSWbMuItVj2lMP1lw+NTrmQk+jXyV92n+VUJN5TQhM23GKDSt0dFu4eepqBFVz4mpwtg3y/cRfoatFXtnrvpP5QF3+BI38P/mD2RcmBlpVbPC+sejnIZCqRVql9hoPsfZ0uEuIOHMMnqOLUKH3KmTgHjbvuYo5W+bRyFLeClDvQqdfmTZwIDuCX5o//w==
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


