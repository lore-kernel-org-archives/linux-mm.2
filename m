Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 629ECCAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 02:45:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C172C8E0030; Mon, 29 Sep 2025 22:45:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEDBB8E0002; Mon, 29 Sep 2025 22:45:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADC5C8E0030; Mon, 29 Sep 2025 22:45:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9CED28E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:45:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5FE7659917
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:45:36 +0000 (UTC)
X-FDA: 83944375872.02.6A4550C
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id 829A9140002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:45:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lGoMIUdn;
	spf=pass (imf23.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759200334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1RtyZdLa/V9peD4vyIt7vF3g+yVd+tHG9wNYuCcZNH8=;
	b=HgSQOmBfPNvaTf3mZ9ejhM0lRmNL7oIuC+eo2nAXFtnNSuaDpl7BqHNKjR+hCRsAqezBom
	A/G0Vfvm+cHPxdBmknjcI7Pk6+226Tu7Neg97wev1vMXOhFWETOI1bs+FlmgmwNQLPWAyw
	HE/ZwMXjCxU97ZMyj1MO/U72iXh/+jI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759200334; a=rsa-sha256;
	cv=none;
	b=W7ug/mplHHpjiy+ZOOeveUi7ofJPtgM54GMFUfkCd5OPN+L7tCDxgaWqwmqiBc+BEGvqz3
	I0jhGBJDhfJoNCmBWyBnVvaw825SRV7cU7ADilAqeJmiSW8xKd0M0N3TdweYfRajG0YAeJ
	D+dUHKoMs1haQGpzF9Rbys8/pFIdEwM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lGoMIUdn;
	spf=pass (imf23.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-781206cce18so3597495b3a.0
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 19:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759200333; x=1759805133; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1RtyZdLa/V9peD4vyIt7vF3g+yVd+tHG9wNYuCcZNH8=;
        b=lGoMIUdnhEAQiihIIMoSoLq8XFqQY8mki3H8nhsbmOWgHX7/id/6+3MGshnp6go0mu
         xOf7HxMY2LUgrQbudYQp1DEb4KK09VVNW+4ibp1BwZsbdnOEW0ERlxHab9t2pFVLU13n
         O3d+DtGWqFsCePiyJ12NWz5/2nXpDMIZE+ApF3q3kMImeGil8MwJEuGq1cCmMiLtCevy
         k/KGQi93cdZ4c2N7WKZ5lc13FCbFvZAIyLD8f0huzp3U/CPk4D9I4Ie6X7HhYJA3KtqC
         YUn/VkfTnaWjPuy5wVtTTD7HgZdGlVd2v1+6FGPrBHww8GNhwR9DJhrKjqPxYT8YtwyM
         /nIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759200333; x=1759805133;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1RtyZdLa/V9peD4vyIt7vF3g+yVd+tHG9wNYuCcZNH8=;
        b=g5U0uOdWw3S943dI00mGPc+tlKShOYR+nF4MGubj0I8mebBykqv4AiNoerVOSbYEq1
         zCJ+n9no4rxz0RfaD5gug2FposXchoPJqNChCni/KwYUfS4p2/ariNAYDbljj2Lqz+Mx
         E2XUo67ci/48/sI/t3Hc8sy4kCNqCKrVAbefCcqPcBgCfxLN3+0FkXewH7Z3CrHOSKNT
         5cIF0Wz1LfbfEz/LjF3EQwCP4LZ57QY6IHPpcGuTqTinvZQYT1bm/rQdqETnyTO2pcSu
         RjpNJ1Jn6Nk2RImi1bid3dTQiLX54xofIQu5kb+xUzfW2aHI+5DktN28NeexT1t4EeDq
         yleA==
X-Forwarded-Encrypted: i=1; AJvYcCWToa+rTjOUHNK45s3NxtWqhZqcyezQ+JcRocvNqD1t8cURATRtgsUA9KlLF8oujhU1iFAJsBTAXA==@kvack.org
X-Gm-Message-State: AOJu0YyL0cdPPygZClquZ6+itpeOrfBlhtNaX8PAL9UO7bO3p8AEYqPa
	9B4zbW2gabH+h7sdU2Es1L1WV2GBvGnIYB35cEwvzDfpRRF3nX0fYeEu
X-Gm-Gg: ASbGnctukx+XOUtN/EsjYZJTeBhEp3lfvrMxc2oE2tplN0HKjprVOf4NTopDF6GNjcO
	7HPYUDme+PaRI69Hpnt683cbYarDA/xeQsQcyFVZlf7C67KbU8eX7f7pLrxLwTgHx2XH9HTgHcV
	tvn6KaovWoicwBDhPwNRistlwdDDVcm+LRMLdptk0dXA1bnGrUaPl+k0aAEsfoB/Oyk9i0NK17G
	WZe1r1BayEGrZTjfq3KmcSVpmjFjOa7xrXuq8nZigh+KWxRy2N6Fwkj/AqKJfJlFmB0MG6xc+09
	uF4t6RL/YneXrquJgxIv0HnoSD4/nm509TOcyNho4QY07fe9Gpli7z4x+Cc1UxoAPCXA5do8uoB
	zYwTuqvrtBGWu2R9MkE9OBXQsPDggPM3dvHnGgPmXHJIe1zppw8vQRuqrnUquKTjR1t+YAruTh7
	6U
X-Google-Smtp-Source: AGHT+IEsif2bxHXvYWWChBgM/szcD1tJlw9HGin9oZWPM2Y8lHrYniUGiEidosj0MGkcbXMNhwhy+Q==
X-Received: by 2002:a05:6a20:9c8c:b0:248:ef8:66df with SMTP id adf61e73a8af0-317732b6b3cmr3072325637.30.1759200333340;
        Mon, 29 Sep 2025 19:45:33 -0700 (PDT)
Received: from localhost ([45.142.167.196])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b57c53bb255sm12683002a12.5.2025.09.29.19.45.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 19:45:32 -0700 (PDT)
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
Subject: [PATCH v6 14/23] mm/ksw: resolve stack watch addr and len
Date: Tue, 30 Sep 2025 10:43:35 +0800
Message-ID: <20250930024402.1043776-15-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250930024402.1043776-1-wangjinchao600@gmail.com>
References: <20250930024402.1043776-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 829A9140002
X-Stat-Signature: g141qnhz356ozxaexmred5193kki14yw
X-Rspam-User: 
X-HE-Tag: 1759200334-292750
X-HE-Meta: U2FsdGVkX1+8GJcI4uI99YeUsb0MbCO+CAAfMEGvYnZO1zfvr4BkNWmKWsGrDFGPhT7HRlprSKgqRcHRrwRBOuNbAIxZsIYh950e0Z6lN/ZYD1Y9YEnqMDmhWCnEEhqIizCVNZPj6O8SPTIz1dGatp/KgFHISE5cSiH2lBr65nsOClgTaoyruympayikBtt25BLtH+Ti0SCdp8eycmi4jfnPuPeBtQ8dBCCzDpYzKNbQ1rOgJScZpxavhsNqQ4+yJpwX1BFJbiFU3svvOBRJPJ44UnqwsdWLtajtXg6ew8wF+uTGw4bLHkr90hqBLoY9H00C1cPrVfuO4epihuVFCeFR0npX73wKSKPB4MEASwSAQGjSn3b84jDQDaLABdEXmSGhEiznzht/y7JJUfmplPZ4+7UGYsOhZYBh5KK+eF2jTZpBXnLnOK6DXE917VllfuLZETNLrhTILu+vH+vLEVfRjKSJuE0CaVjC6m2rwdtBzFN0FCWpO3QBysIexQZ1FF8Yr7YFf/7lzBHEzh3YgLzOoRM+fY/WvguhPENF6NdOc/ptXCES1+vFlqA2WmS8OHWqTXT25E01xcolmERKhrQVPt8tKubbpXFG+gNL4vaDtyXhwQEwmap+EP/QK71cBQ3wPp7h6bQ2xCJDlDjDZOSKu01GOORNnDn5x1eTB/UQPGZFn+mivKnYv8isJvHeSKqg2NbloDOjyPt5YhHuYtNLm85btOWio5DYs5MYSq9dK1yc9muzxWLKp3pfhmxIOUyyUdPgCMimKzy82owwtNQXge02PA+6f2HSo3vzarj0+rINg5k/5SYqe38HExlW8MDn/BjT/v/vGlSUxhAevWv4oqIUrH4MvXoAcRWmKSOy1+2HsE+gMZYCbrFkr6Ot3+Zksqc7poRfwcDMhw7Im/xrmHgM/oIgWgFR4Po95MsPjRFuoRhMoFzaF3FEg/febvwgkD1M2dxB3LDZUse
 dn6EK/Hx
 H1dvqnqaCIFbAvs+rqG60q/LcSyoJAlBYZ+AyzxwyIlHIKh9u2IWjogsyCA9orJxhY6F8w+E/PtdaHGn2jE9Z90KZ8nZ++UsaEKX/PF8fNGyDON+cH7LfDQFH8MUp/pxwgpDAUoNH6iPXhVasxjUTL84FfmNwpQuRGRVJ7MPw6rRpQIa45UcSfeMu03r1h9BfWCAAPiTA6BYyxmaRQ5NRucVr7u9jC9tfePbldyTQ8NhVtpddc4c0nWr+175LGE5Y75wDTO98T5Cz9bhvv2CZk6RzxH3CQ8ut45Ef6lIcudwn4bVMrctM24Obti5KVlkEPNWArIyde1KaDFN9X7sgqhB6RAV1ABMLzVkgoJf+Q/5e67LDRSbMr/36EX0UC4zZrwYAEc7LM02amK3tmf5J9DyjiQZeaINTkLcLnL4D+bzjruSmh2zA5S0y909ZQAOJjdtUiuYxh+IHt4xzuN+M49tASJavXwwI6SJ8WFVnkwTEQ0KxmoS0EFfqv1eQhr0jFPjq4puwaWOz6KaLXaMiJmLBuJneCnJKj0/JMSVyNxcN1XGdg6n2ZUhNj+4ctW7KbX5cSbf3hjD7YuuT8GB5xg9q4A==
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


