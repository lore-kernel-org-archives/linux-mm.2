Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B56DFCAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 02:44:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13E7A8E0016; Mon, 29 Sep 2025 22:44:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C7988E0002; Mon, 29 Sep 2025 22:44:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF83D8E0016; Mon, 29 Sep 2025 22:44:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DD69A8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:44:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F8F3878B0
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:44:24 +0000 (UTC)
X-FDA: 83944372848.06.3F642AF
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf11.hostedemail.com (Postfix) with ESMTP id B892640004
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:44:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ovy1uQCQ;
	spf=pass (imf11.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759200262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kk8QwiK6ueKhbPm+iybiDp/pMjWX1cNh1XEGnvIxiQI=;
	b=0G+1Ew7TPt6uWdLSHlr0b93Pqqiu9DVfDlG1nZDbFTpL7YeZil7rdqMfIghnHwI3wSjxXo
	5uioqSz1IJHz234lr+4Mi4xRENAy8+E4K1qrH/jVbVQhqKqUXzV/duJEHxNpZ/D+HnPCdK
	HQXkefebb+SnhvCl5jxxcTfycqb5etA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ovy1uQCQ;
	spf=pass (imf11.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759200262; a=rsa-sha256;
	cv=none;
	b=5R0O7BkJC9vcETo9kEf/CoN1bvxqD4UIvRCjODCxbPXBt2c2XFz5rEAnbgOrn0ehAj4alS
	Q4W4KvcNy7+LfTWCAO1legbi3CoBDkjGZVYYxKkNpsWIyaZYxN3QH9Q1uV4ISlEDdj/Fku
	707EFYRXa0go/TrQ0yAjeRYlWzr3/pM=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-78127433a32so2408665b3a.1
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 19:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759200261; x=1759805061; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kk8QwiK6ueKhbPm+iybiDp/pMjWX1cNh1XEGnvIxiQI=;
        b=Ovy1uQCQhGLFZioQmzxFBXZmDrxXV1By2X7Z6qkyOn9k1IteytTBrisDu/lQIbEN5O
         HsH0eddHq73PjQymrzy7rsLQ2T4sxS9bkT1g8w0WECEICx/7BNANaKkFYeJFSGsIrRSY
         QfQIoOz6HvxccOgiOR9D+cjpCs1VIVljM3fDNDlMXZDo+CCDJOavBJcgcqreo3KpFut2
         7VNNw6km0GgICFV7OB+gaNm+1x/SIZkoFUOwCkfWMjnj/QQs/0WoAkpV0bUy4Iq+FkxY
         hcEFUiV6M6i5lEWhHDUX7K1jJqpFQhe1Pow8ECuw3ZExcU/UB4aMCyRF9qBV5ntkP4X1
         kYZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759200261; x=1759805061;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kk8QwiK6ueKhbPm+iybiDp/pMjWX1cNh1XEGnvIxiQI=;
        b=s9UB0c+pFXiXelDqEjEBx7RgoNBrCraPXszCpXnekEkxKbeB+Le9nDP0cHvvp3E0dJ
         lTdDvM+AHgpG0GY4qZa4B1ii9xYklmfUWMqzJEqV5RA4hGHghLNUWcdKbpTG5aoHXXnW
         MrX+Agv75ThOyBudrDnj9wIAUQQlvxvovC1rb3lJvsLix3sW9Hxo0o/ibk0hPJgWMHSV
         5GqsF7OgR2jJzwLf4iXI73heW4YxXuKlwso5od1OJuvITY4ikLDyfSLEoQCB2h1dMKFY
         TQoXFBouUnNa0crRh3/n72caUPtjvgk0/Si4O3xdQC9g9mo3LDckY9FvnxdFmyOHSKqE
         S8Yw==
X-Forwarded-Encrypted: i=1; AJvYcCVLgz1Lkf2NXv5EPoWS5nQLDMS2BS6NzhkGWn+0cFW/qqmaX5waWgUa6onD2DakUdzCM6dBUi9p1A==@kvack.org
X-Gm-Message-State: AOJu0YxzoZwziDWPnVBXJ2Pg8JFuJjQnkyGJ3Lxjyyw8w6SztLmwZIYC
	chDxK7bAygYjLrVW7KJpWKtW+uR4oYX9jm0WGVIB4BZReSmlQnkZ8wXh
X-Gm-Gg: ASbGncsQ7W6AiAIskkbUkS5pySkVqqHtUjNT2YLTg9LOH6sX+UCwRp0xJUXn3u0TYjO
	MwaE+f8j/zH4crUWIZuoQ+zUjewCfPamRgi88nSg/Mpus9tywup6Lhm66jAHATK8ekwqP/sEVqH
	zeoqSCrLEV1NnciX789Qh/sVssf2POZozMnCcsN0pPlWX240Mvav93rRlWHLLLYMsK5mHSkSA3i
	Iv2NfFbZVcfyfW3A1XU4XvmwDVGZ2YQVuZND7OPK1a4lWNX+HrQKTnC7Q/GFiYWsnPGxHKUWL+q
	BrsBgjZm/35y+c9eRcXJp7fGEBGvVZWLWjyiNvIauIfjwVQ43jDmZKh/8kIHRQXkaFqpFP9ILwI
	RtOLHb8NYQ16RyIdDfUXYiHwx7vhFdab0T3umRYjGLfFEsV8/lNwZ5EKDx8PkVVNR/q7QfYbD7N
	bq
X-Google-Smtp-Source: AGHT+IEDrnXJljikPuqSeJPSpakmRAqAzuYiiAGD50MQ2/K4+bFVhmBDij8ZHMPdqyP96BrQHK5sAg==
X-Received: by 2002:a05:6a20:e29:b0:2ea:41f1:d53a with SMTP id adf61e73a8af0-2ea41f1d8femr15753456637.41.1759200261084;
        Mon, 29 Sep 2025 19:44:21 -0700 (PDT)
Received: from localhost ([45.142.167.196])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b57c55a0ef3sm12386161a12.37.2025.09.29.19.44.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 19:44:20 -0700 (PDT)
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
Subject: [PATCH v6 01/23] x86/hw_breakpoint: Unify breakpoint install/uninstall
Date: Tue, 30 Sep 2025 10:43:22 +0800
Message-ID: <20250930024402.1043776-2-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250930024402.1043776-1-wangjinchao600@gmail.com>
References: <20250930024402.1043776-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B892640004
X-Stat-Signature: w7t6xef1rrqurakowiqniabre4wzptof
X-HE-Tag: 1759200262-233605
X-HE-Meta: U2FsdGVkX1/qy5I842sDjvWWKWVm9wum4m2Ohn/jpWRVIZL0UpNoZ3md/4zyMcLkddJxIvvaRodLxD2ZTNpj91e7X74y9uIsy/6Vdc9oFgBM6Z5LJ0FB53AnbqEtNG/Fkuw7u8Bl0N1o7sR6mAvI1u6Jmw+pLCdWbATZi6VAPqzQZlPS6YVx6ZItZEvIVR2JWIIKih/hX8QT6FnaccwB7DxKe4pU/wv0d5hxWwIaZVRvfO0kdbhZ0+/iQ1RMScqOBNTOSimKe+/mMSZ3U9dFCD0NsXIDRnzx+FQLdZlqzcKaykC+PkoZTtYV8S0If3sJvkEx1BshmMBk671sUuQi610HQDzqLDpel+U+juqsJxxFVE+6ybBmxL1DjXPA2t2FO/903hhrSLvndSSZiiht61i25An+NW6KfGhBUKc3rXyaDWGqvRTnyFGXbQWrpP0flvctUq2MtoE3Q8iZwXbUIC+YtMYvM2WJgj3gvzTRwIZZqCnMrPismXcezELVs/3cHUucIH8zi1L9DtgcsLRegJ2iXVBADGESEXlFG2dKVldJ0cmvK/X0ChMFJoMElOQWDCjyYmr5Tm7Zg+vf08Hq2KS59MYZr1iHJw3yNzFpCFYqxK6lwD4Ink88l9rqHBhj2iyfe5qXiwoEBOOyX9BDghr+chSlcM7UVp1cjeIJA1xMDRgBeqbupm9qet/jsVLNwee9k99PhhTg0hsNtx1CBm3gsbeq6vlxYsoWhQIF43ax12EiIqObq3Dm9JIuIOoGBltvM3mNSBlbAflb6WOvxaKLfhEWm07degL2+3iHl6ErMmNkYOIXlXSb5HD/BIx4CE6dtjMnsXMM+i2vziuW7p88S7xK32htoGvGQEQQZUPQEa6IwJ/lxDZLTlgYLUUI+F6pWTlU0ti+9rcLk2jAJHqYy1rLPGSQEe9LCojg3E2KTGyFOEHqlSvNu1rSV6MxYAiiU1RXZmkrvctkaCU
 1YJndoqC
 KdfjHT/DFp4Vx6q0SHlbWEKmf7h69iwB1ceZ1OZouxnG7quDw4SLCOsgztB3gFYyF5//YfTc0D0A4EDaZq0nWP5FvXzf7El3zdJaoIGolDzrPRZ9Xkl68JRnABzO0eEliVd13S8Sg3CP+YF0i5O1jK5qqT5zfxUOSILlZs8JvpvEo2K5H5k/VXNvQaA1Q/17DHTGr/zQXnvT61SqKZQdoCQCMPLthEZ6sT4Y/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Consolidate breakpoint management to reduce code duplication.
The diffstat was misleading, so the stripped code size is compared instead.
After refactoring, it is reduced from 11976 bytes to 11448 bytes on my
x86_64 system built with clang.

This also makes it easier to introduce arch_reinstall_hw_breakpoint().

In addition, including linux/types.h to fix a missing build dependency.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
---
 arch/x86/include/asm/hw_breakpoint.h |   6 ++
 arch/x86/kernel/hw_breakpoint.c      | 141 +++++++++++++++------------
 2 files changed, 84 insertions(+), 63 deletions(-)

diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
index 0bc931cd0698..aa6adac6c3a2 100644
--- a/arch/x86/include/asm/hw_breakpoint.h
+++ b/arch/x86/include/asm/hw_breakpoint.h
@@ -5,6 +5,7 @@
 #include <uapi/asm/hw_breakpoint.h>
 
 #define	__ARCH_HW_BREAKPOINT_H
+#include <linux/types.h>
 
 /*
  * The name should probably be something dealt in
@@ -18,6 +19,11 @@ struct arch_hw_breakpoint {
 	u8		type;
 };
 
+enum bp_slot_action {
+	BP_SLOT_ACTION_INSTALL,
+	BP_SLOT_ACTION_UNINSTALL,
+};
+
 #include <linux/kdebug.h>
 #include <linux/percpu.h>
 #include <linux/list.h>
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index b01644c949b2..3658ace4bd8d 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -48,7 +48,6 @@ static DEFINE_PER_CPU(unsigned long, cpu_debugreg[HBP_NUM]);
  */
 static DEFINE_PER_CPU(struct perf_event *, bp_per_reg[HBP_NUM]);
 
-
 static inline unsigned long
 __encode_dr7(int drnum, unsigned int len, unsigned int type)
 {
@@ -85,96 +84,112 @@ int decode_dr7(unsigned long dr7, int bpnum, unsigned *len, unsigned *type)
 }
 
 /*
- * Install a perf counter breakpoint.
- *
- * We seek a free debug address register and use it for this
- * breakpoint. Eventually we enable it in the debug control register.
- *
- * Atomic: we hold the counter->ctx->lock and we only handle variables
- * and registers local to this cpu.
+ * We seek a slot and change it or keep it based on the action.
+ * Returns slot number on success, negative error on failure.
+ * Must be called with IRQs disabled.
  */
-int arch_install_hw_breakpoint(struct perf_event *bp)
+static int manage_bp_slot(struct perf_event *bp, enum bp_slot_action action)
 {
-	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
-	unsigned long *dr7;
-	int i;
-
-	lockdep_assert_irqs_disabled();
+	struct perf_event *old_bp;
+	struct perf_event *new_bp;
+	int slot;
+
+	switch (action) {
+	case BP_SLOT_ACTION_INSTALL:
+		old_bp = NULL;
+		new_bp = bp;
+		break;
+	case BP_SLOT_ACTION_UNINSTALL:
+		old_bp = bp;
+		new_bp = NULL;
+		break;
+	default:
+		return -EINVAL;
+	}
 
-	for (i = 0; i < HBP_NUM; i++) {
-		struct perf_event **slot = this_cpu_ptr(&bp_per_reg[i]);
+	for (slot = 0; slot < HBP_NUM; slot++) {
+		struct perf_event **curr = this_cpu_ptr(&bp_per_reg[slot]);
 
-		if (!*slot) {
-			*slot = bp;
-			break;
+		if (*curr == old_bp) {
+			*curr = new_bp;
+			return slot;
 		}
 	}
 
-	if (WARN_ONCE(i == HBP_NUM, "Can't find any breakpoint slot"))
-		return -EBUSY;
+	if (old_bp) {
+		WARN_ONCE(1, "Can't find matching breakpoint slot");
+		return -EINVAL;
+	}
+
+	WARN_ONCE(1, "No free breakpoint slots");
+	return -EBUSY;
+}
+
+static void setup_hwbp(struct arch_hw_breakpoint *info, int slot, bool enable)
+{
+	unsigned long dr7;
 
-	set_debugreg(info->address, i);
-	__this_cpu_write(cpu_debugreg[i], info->address);
+	set_debugreg(info->address, slot);
+	__this_cpu_write(cpu_debugreg[slot], info->address);
 
-	dr7 = this_cpu_ptr(&cpu_dr7);
-	*dr7 |= encode_dr7(i, info->len, info->type);
+	dr7 = this_cpu_read(cpu_dr7);
+	if (enable)
+		dr7 |= encode_dr7(slot, info->len, info->type);
+	else
+		dr7 &= ~__encode_dr7(slot, info->len, info->type);
 
 	/*
-	 * Ensure we first write cpu_dr7 before we set the DR7 register.
-	 * This ensures an NMI never see cpu_dr7 0 when DR7 is not.
+	 * Enabling:
+	 *   Ensure we first write cpu_dr7 before we set the DR7 register.
+	 *   This ensures an NMI never see cpu_dr7 0 when DR7 is not.
 	 */
+	if (enable)
+		this_cpu_write(cpu_dr7, dr7);
+
 	barrier();
 
-	set_debugreg(*dr7, 7);
+	set_debugreg(dr7, 7);
+
 	if (info->mask)
-		amd_set_dr_addr_mask(info->mask, i);
+		amd_set_dr_addr_mask(enable ? info->mask : 0, slot);
 
-	return 0;
+	/*
+	 * Disabling:
+	 *   Ensure the write to cpu_dr7 is after we've set the DR7 register.
+	 *   This ensures an NMI never see cpu_dr7 0 when DR7 is not.
+	 */
+	if (!enable)
+		this_cpu_write(cpu_dr7, dr7);
 }
 
 /*
- * Uninstall the breakpoint contained in the given counter.
- *
- * First we search the debug address register it uses and then we disable
- * it.
- *
- * Atomic: we hold the counter->ctx->lock and we only handle variables
- * and registers local to this cpu.
+ * find suitable breakpoint slot and set it up based on the action
  */
-void arch_uninstall_hw_breakpoint(struct perf_event *bp)
+static int arch_manage_bp(struct perf_event *bp, enum bp_slot_action action)
 {
-	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
-	unsigned long dr7;
-	int i;
+	struct arch_hw_breakpoint *info;
+	int slot;
 
 	lockdep_assert_irqs_disabled();
 
-	for (i = 0; i < HBP_NUM; i++) {
-		struct perf_event **slot = this_cpu_ptr(&bp_per_reg[i]);
-
-		if (*slot == bp) {
-			*slot = NULL;
-			break;
-		}
-	}
-
-	if (WARN_ONCE(i == HBP_NUM, "Can't find any breakpoint slot"))
-		return;
+	slot = manage_bp_slot(bp, action);
+	if (slot < 0)
+		return slot;
 
-	dr7 = this_cpu_read(cpu_dr7);
-	dr7 &= ~__encode_dr7(i, info->len, info->type);
+	info = counter_arch_bp(bp);
+	setup_hwbp(info, slot, action != BP_SLOT_ACTION_UNINSTALL);
 
-	set_debugreg(dr7, 7);
-	if (info->mask)
-		amd_set_dr_addr_mask(0, i);
+	return 0;
+}
 
-	/*
-	 * Ensure the write to cpu_dr7 is after we've set the DR7 register.
-	 * This ensures an NMI never see cpu_dr7 0 when DR7 is not.
-	 */
-	barrier();
+int arch_install_hw_breakpoint(struct perf_event *bp)
+{
+	return arch_manage_bp(bp, BP_SLOT_ACTION_INSTALL);
+}
 
-	this_cpu_write(cpu_dr7, dr7);
+void arch_uninstall_hw_breakpoint(struct perf_event *bp)
+{
+	arch_manage_bp(bp, BP_SLOT_ACTION_UNINSTALL);
 }
 
 static int arch_bp_generic_len(int x86_len)
-- 
2.43.0


