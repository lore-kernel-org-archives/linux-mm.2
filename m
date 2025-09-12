Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE9C8CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 10:12:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B27B8E0029; Fri, 12 Sep 2025 06:12:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45BD28E0005; Fri, 12 Sep 2025 06:12:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3245D8E0029; Fri, 12 Sep 2025 06:12:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1D6EA8E0005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:12:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D9D2113BAE4
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:12:53 +0000 (UTC)
X-FDA: 83880184626.10.370E2F0
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2C6E31C000F
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:12:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HDK1FHTt;
	spf=pass (imf20.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757671972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bEzQtMPq9PK+5+yYtP/oNug9OWMsSiZGEa798p9Mz9w=;
	b=ojdy6AY7vTGqdxCm7pbWTNB8DTAGsxRxomRX3b75S3cNH7YVnyUbrT3jrGOiCqMYMERzUY
	95eVim6dqJjNX1eD7CI8bGGNGbMgpJ6wNyhpdd8pKuRT0mrM+6IknpsHIvCE2/m2eyQP9c
	CNNRJadVmFC701RYiHodxCHcZdHGh1I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757671972; a=rsa-sha256;
	cv=none;
	b=uXKXCNpRrR0lzzfJ6kLw9HbqHOlt+zzcudGKTcVMf0VCijM3sBNWGl0+7QaetUn08I0pdo
	6/vOQ5iqHUHx7SlY7+eNp+6btmpjR4zl1noapCaRBrdIUMMdfVVm7LXc4/JWcbp1zZgyWo
	gOiDn5wvLzFDzQjPp4Q2zadoxPrujEQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HDK1FHTt;
	spf=pass (imf20.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-24458272c00so18778345ad.3
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757671971; x=1758276771; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bEzQtMPq9PK+5+yYtP/oNug9OWMsSiZGEa798p9Mz9w=;
        b=HDK1FHTtijACCVs1kreyJNWOqkx22pzJsxJucUxKB3WuQmB0v8F6uTKmY0F4KYqd+0
         kwa/sWYtaF3CmZxLjC7RTOy0k27w512dXg3zUYAy4o4PdIKP3TD/+VsgfxxMw4lkKhy5
         KdEZi7xUfhhC4snH9oNCajFEKxl0Uc+UvvyWH9TBmu4CfpilTHC3bejpNDVO4SYdSAoe
         myB0y0Xpkd3xUJP6unmYwt+rriAs8BZ+w/ikCUYBkILKpTd3C3sLtEWst3l/xqZliaAn
         KuZZXxOKn88vSuIrQ3nJY3z/ZqdYQhIGelB2D/j3IJLvDTH+2/6j83hgWV3UJQjOaTbf
         V18A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757671971; x=1758276771;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bEzQtMPq9PK+5+yYtP/oNug9OWMsSiZGEa798p9Mz9w=;
        b=fkg2nGCKR8wN4S6AnSDt4yAY+np67EjSmkkdrc0mzRdt643x9QnmQobNv32UE5m2Wl
         6SVSBiPQ+bZ/4Fp2s/0eOI1JrUr/5BF+dPGheiBKGfWLf0RHgexzH37jCDH33A7tym5R
         5ERo4k0bN2WzjDgW1+/FcAO/rFYM9HNbhSLOtD/4375Jxhp6NScVUHR7gVMq6ZH4DUHz
         Sr5CBfBYHtL9wJV/BdBke2Nh/+wOa5m5LhbejeXAEheSIezGf2jlBL3fa9tIIlGN99oo
         QBMUb1RTAxyPJLr7UtjREcr5jG/VpmGAj/fPtYI5pR0oOtijkdfH5ggjZIm6Tu3RfrDH
         g9MA==
X-Forwarded-Encrypted: i=1; AJvYcCUvi/DlAcbSBfz1N2NQJVtcX0fSPJ0vb/2cpuj7W+X3cE/u+EXQPmLSLfDOtpwWeS1s//fSX9L81Q==@kvack.org
X-Gm-Message-State: AOJu0YzTbVkjDbDBi1eQizKqC6reP6SOiDbzkY12vr7ywBIw4/lvq7Gz
	kO3lc/aCE/P31H+3rPtMUcJDbta8trNfQC3D2d4r5tInS6XvZa6eK+Hf
X-Gm-Gg: ASbGncvFYvajfDp5NSUHE93oqB7lg9RpN/v7sAskdPfOmXzuc1oZIdgPk7iYCsUOQhJ
	Q3acd/DmNBYQwJ8/v2cTQjGlqcq/aB81Uus/VakI51nWcwk09t0BX7emuaO+ZdppzW6Q0gde+JT
	pDsazFq6mqWrzquR5XJ05BjZxCkwsiNb0hVb5oCyY/bEgSEBIKCFOb3X2Gn8u3ja0LDv6eGou4p
	AafR6fxDAWi45jHdz2mXaa7qtghuXrpKI9xch+cjHyWoH0lOZkwnRkCJgAXSOCvIKHJSgcilYTt
	THvVYiXiwGswH4S0+ieVjbGNbYs+VeMtbVKPhxKxbEpGDVnkT+Db0z/Te8nQb42qhlO516aru/V
	eVGMoccMANqVxAkq23/bmOXoFE9oezArsN+EJGbqMxl34FAlYs4AOt4PzBazk
X-Google-Smtp-Source: AGHT+IFjzeds5aG6Wb+p60MOU157xCW/uyAMBkC8kYhjKV3VQWNhWnO7RA/JWobHVFlYljAoloxrVg==
X-Received: by 2002:a17:902:d490:b0:25c:18d:893 with SMTP id d9443c01a7336-25d24bb33f9mr25149495ad.22.1757671970918;
        Fri, 12 Sep 2025 03:12:50 -0700 (PDT)
Received: from localhost ([185.49.34.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25c37293f0asm45159835ad.43.2025.09.12.03.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 03:12:50 -0700 (PDT)
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
Subject: [PATCH v4 11/21] mm/ksw: add probe management helpers
Date: Fri, 12 Sep 2025 18:11:21 +0800
Message-ID: <20250912101145.465708-12-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912101145.465708-1-wangjinchao600@gmail.com>
References: <20250912101145.465708-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qouosp7wo6pnrarpc98p7zef6b7eywwr
X-Rspamd-Queue-Id: 2C6E31C000F
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757671971-759094
X-HE-Meta: U2FsdGVkX19iDREB1eqx5y510GCEVsfxKosRfZkLjvI7GwEB5/denQN/y4q4QuXoqRmIrf7iNx49ZEnXwB5KIdDRi5t0xZC1dRP3McENUgCCQB4jk+6jFnKn+r+J9GZ7OjxDzQAaa4sg+HA7bMrg21iTH54vvP9qGoIc6E5WWyoxxn3IhllZcdolRM/7BKTj/BCwR69UTP1OyInZKVstUPllfvx/T1VBh/g+JWGO7nb43mG2PYZ01X12YV/D4PcNMbx6igZ/AGxi56cE6dzXsjuAHeEuKr8oWFiTJ9698ajWm/i9RZ5FPIdS4aNBFPK+0MBeNC6Sa9lWe8SyXd6Yk24Q6nZi+QG587ck9joQq79fP9UO2yaVzBdPuVEzImdS9Cy02gwbIuMxhwpWv6kJgQCFifahLdkbfiZWuW21+9R+lGhEQyfMhhCJmjWObi6JOH5efxq+ZZZCH+OdVFazdTQREeeL4Ywkrdyp4KMnWXtnFWoaMsKFNhGhH/RQTFdo5ofayPPP/WnAge9nzS8xlyDiWAurTIzAGuGe+Ak83vl2Hf04+mTIKv8YCwJXnPIJ3gdchr4SbUY2w7m3myiOxgQOxp0PG023O95rpnDFDF7t/WcaQu+x64d+7Dgt9YYWmBnyFpFRWOSRjWZetHw9GhFEyj17TZAdRNaHYxnKNZlPpIyJ+zqclpKSNG8tg3C03yD3vvsZcNrw0VQLJSDJHCx+/oscM4zEMkKxfmeXPO520YD5NMvJ8uCmBikujLS9NVlNRTs8VxznXFPAKNo8x3KEhHrSs6MHLZWNLsSUKEhaGTFEmHO4sT2URQZIVLuDR2pImdkyCaowDl5PJWGbp3DU9H3io/kQfbAlgDGGVCkMxIV7eK/hPg2X3ZIsiVZoHJ9SgZhq/Y6RQdXpcn3KSQGiG0qqIcZZ7/214LHoZZykTnFRtxoSiMN3dzPn6KknBGp+55GLCqwWQIaiUMI
 W5ahhqDn
 qcN7+SLXUJc0ZiziI6GG/vdnaCPpzyAth1ObZv/IHfcsykBeWO6Ab8YYMZMOM5tXrftOyQQqMVRC/yjs515rSu05tJE5YvLzZkbWQScnRkVaXk/scYl7z/KvC5JIMyhi9582VwPmdmYeD8D8p4HgBpeyfyEhghE0PH5Z6cCvM0eBrwLDV77n5h3BCrNSH6ZoqI2J+kiknnzSJZfNLhAJHjjC8Aw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Provide ksw_stack_init() and ksw_stack_exit() to manage entry and
exit probes for the target function from ksw_get_config().

The entry/exit probe handlers use atomic ksw_stack_pid to ensure a
singleton watch and current->kstackwatch_ctx.depth to track
recursion depth. A watch is set up only when depth reaches the
configured value.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kstackwatch.h |   4 ++
 mm/kstackwatch/stack.c       | 113 +++++++++++++++++++++++++++++++++++
 2 files changed, 117 insertions(+)

diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index 0786fa961011..5ea2db76cdfb 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -38,6 +38,10 @@ struct ksw_config {
 // singleton, only modified in kernel.c
 const struct ksw_config *ksw_get_config(void);
 
+/* stack management */
+int ksw_stack_init(void);
+void ksw_stack_exit(void);
+
 /* watch management */
 int ksw_watch_init(void);
 void ksw_watch_exit(void);
diff --git a/mm/kstackwatch/stack.c b/mm/kstackwatch/stack.c
index cec594032515..ac52a9f81486 100644
--- a/mm/kstackwatch/stack.c
+++ b/mm/kstackwatch/stack.c
@@ -1 +1,114 @@
 // SPDX-License-Identifier: GPL-2.0
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/atomic.h>
+#include <linux/fprobe.h>
+#include <linux/kprobes.h>
+#include <linux/kstackwatch_types.h>
+#include <linux/printk.h>
+
+#include "kstackwatch.h"
+
+static struct kprobe entry_probe;
+static struct fprobe exit_probe;
+#define INVALID_PID -1
+static atomic_t ksw_stack_pid = ATOMIC_INIT(INVALID_PID);
+
+static int ksw_stack_prepare_watch(struct pt_regs *regs,
+				   const struct ksw_config *config,
+				   ulong *watch_addr, u16 *watch_len)
+{
+	/* implement logic will be added in following patches */
+	*watch_addr = 0;
+	*watch_len = 0;
+	return 0;
+}
+
+static void ksw_stack_entry_handler(struct kprobe *p, struct pt_regs *regs,
+				    unsigned long flags)
+{
+	struct kstackwatch_ctx *ctx = &current->kstackwatch_ctx;
+	ulong watch_addr;
+	u16 watch_len;
+	int ret;
+
+	if (ctx->depth++ != ksw_get_config()->depth)
+		return;
+
+	if (atomic_cmpxchg(&ksw_stack_pid, INVALID_PID, current->pid) !=
+	    INVALID_PID)
+		return;
+
+	ret = ksw_stack_prepare_watch(regs, ksw_get_config(), &watch_addr,
+				      &watch_len);
+	if (ret) {
+		atomic_set(&ksw_stack_pid, INVALID_PID);
+		pr_err("failed to prepare watch target: %d\n", ret);
+		return;
+	}
+
+	ret = ksw_watch_on(watch_addr, watch_len);
+	if (ret) {
+		atomic_set(&ksw_stack_pid, INVALID_PID);
+		pr_err("failed to watch on depth:%d addr:0x%lx len:%u %d\n",
+		       ksw_get_config()->depth, watch_addr, watch_len, ret);
+		return;
+	}
+
+	ctx->watch_addr = watch_addr;
+	ctx->watch_len = watch_len;
+	ctx->watch_on = true;
+}
+
+static void ksw_stack_exit_handler(struct fprobe *fp, unsigned long ip,
+				   unsigned long ret_ip,
+				   struct ftrace_regs *regs, void *data)
+{
+	struct kstackwatch_ctx *ctx = &current->kstackwatch_ctx;
+
+	if (--ctx->depth != ksw_get_config()->depth)
+		return;
+
+	if (atomic_read(&ksw_stack_pid) != current->pid)
+		return;
+	WARN_ON_ONCE(!ctx->watch_on);
+	WARN_ON_ONCE(ksw_watch_off(ctx->watch_addr, ctx->watch_len));
+	ctx->watch_on = false;
+
+	atomic_set(&ksw_stack_pid, INVALID_PID);
+}
+
+int ksw_stack_init(void)
+{
+	int ret;
+	char *symbuf = NULL;
+
+	memset(&entry_probe, 0, sizeof(entry_probe));
+	entry_probe.symbol_name = ksw_get_config()->function;
+	entry_probe.offset = ksw_get_config()->ip_offset;
+	entry_probe.post_handler = ksw_stack_entry_handler;
+	ret = register_kprobe(&entry_probe);
+	if (ret) {
+		pr_err("Failed to register kprobe ret %d\n", ret);
+		return ret;
+	}
+
+	memset(&exit_probe, 0, sizeof(exit_probe));
+	exit_probe.exit_handler = ksw_stack_exit_handler;
+	symbuf = (char *)ksw_get_config()->function;
+
+	ret = register_fprobe_syms(&exit_probe, (const char **)&symbuf, 1);
+	if (ret < 0) {
+		pr_err("register_fprobe_syms fail %d\n", ret);
+		unregister_kprobe(&entry_probe);
+		return ret;
+	}
+
+	return 0;
+}
+
+void ksw_stack_exit(void)
+{
+	unregister_fprobe(&exit_probe);
+	unregister_kprobe(&entry_probe);
+}
-- 
2.43.0


