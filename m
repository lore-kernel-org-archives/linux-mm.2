Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E9FBCCD187
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 10:57:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B7C18E0077; Thu,  9 Oct 2025 06:57:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98FAD8E0002; Thu,  9 Oct 2025 06:57:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87E2B8E0077; Thu,  9 Oct 2025 06:57:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 779068E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:57:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 10A63C085B
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:57:14 +0000 (UTC)
X-FDA: 83978273988.27.B3FDC5C
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2CB14140006
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:57:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="XC/zMZAM";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760007432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kk8QwiK6ueKhbPm+iybiDp/pMjWX1cNh1XEGnvIxiQI=;
	b=qIsIwva5f1dqsA2cFrbN/pD2lPkxKBXZteBGCYmk++FWmW5jTh3dzje+kYiWWRV6UG1DhZ
	oq+7E0MvusSRt5qSF5hC7vrsxYb7xBSJu/CcmYgdsQOV86tTnjDiIffmdzY7+kTlEgZrO2
	f27jwj4svHFnXIDE1iHzUXeuK1OfWvI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760007432; a=rsa-sha256;
	cv=none;
	b=yVw+AOArSIExTIwYkfZ8yF/4h8isIJmAe5e6wABrrGCQ9DyPUC1XLKkCupoLATDuTSf+YB
	E0ERaLCppsPmvg92RHTpCQIfydQoEefSC0IiZhRgtBD6cRMetCN6EHZGauouIwoPNusT9m
	0SLf69iRc+s8d7594O2ZCIVj7waZk2c=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="XC/zMZAM";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-78af9ebe337so618682b3a.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 03:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760007431; x=1760612231; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kk8QwiK6ueKhbPm+iybiDp/pMjWX1cNh1XEGnvIxiQI=;
        b=XC/zMZAMIUU2IDDTfRrZ/toebi0R5lSmKCcJsCO2BLPxdtmRZGPrUrovNYn7Yk+2F+
         j8FYeulh7RJldQcCOZV8ABUjpFnYhwKg71TnaDnVk7wO4x4xBukJZfTE3n7hXJAsL9EO
         cjKv1TZ5bRi42VQ4gf6kV3HR2EM9qsyDgeNddhnLiK+xTgJ3/HhGcZNIV/+xgAEUwAPn
         MVeEs6rtNoYgpxmG1x+jG1C4twC7gxxBulBSu/fVGE/CNPA9FtTWg4il66ay3wZbgMcE
         zxsdeyn+7rjNXS4GGNKpU1KbYfOCh/IVkNCpey9He9tPTC4VC/hIZjC/kZTqL1P5oqJ/
         pCvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760007431; x=1760612231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kk8QwiK6ueKhbPm+iybiDp/pMjWX1cNh1XEGnvIxiQI=;
        b=YEJL77yXlYDAhA0/s6qEuHNc7L2mTdeWSSohFtmvPa6NDCou1zh8YgGfJdFlh//73U
         1iENkoO3EvpK2S25HS75fAWOjiv/0mC8T2omR4Hzddu1+DcABGWzgoISf6RFqM1ms2P1
         OkRYanyy0LueDrgrAeNUNH4zAX8xhRuAWilZtygkLp18u1qttfNlVYIR+y8EnmI++PLt
         NP2q/AyCKz5Io4tT5B3fGbsILp7PoXA0AhxcwTJ9qc3S7ycwGMf1Q2t0bNCH6A/PfJbN
         zvW9vEhwo9G8EDGX+e8Xlcr1LurY/dPkoeICoCnY7cgZY4PMxXnv9kNEPg02ZKFgsVE/
         30GQ==
X-Forwarded-Encrypted: i=1; AJvYcCWVsiVE4b2vt1+/TF/0tilGZagb3OoMyHSU6pB6EGxw2kZpdhhPGaPLCZ7Zk7FBvRIKoKjCzxg5aQ==@kvack.org
X-Gm-Message-State: AOJu0Yyff0dmNp1VrIeVDmgixWAhkFZIr5vy2JQJQW0eEQW+YT6dHC5P
	aKi/hxN3r3g2DbAee/R7a/gOagdINGdm7L78cLa3uN3Cvi5rBuTGIGDO
X-Gm-Gg: ASbGncumX8kv2o/BepKI6aAMbGQHOr+AiQzOi1puZqO5+4dAXu7DsWUyPGizX/7ZBar
	4SvfS8uQUVVyz5INz60ikudFpXo4WClygJlNWy/WYfccO7RlN7HbqrNbp7UM2oBzeqARzL5Ub+1
	r/o5vWPDu0Wo6lHGD4ohH70aSWcrZ1AbHTQ7CpNvNNGn0os96MU1udoH+rcdEW6H0LtWbNVs99C
	KtU7+DplBm6EweJKed1G9u5pOx2R+ytz8lfO0sS4KR5L24hic2s4V7ckAAvUJVlm+5vwHkPXl/U
	8h9wtlw8D//fiiAVqrFCXjyEwlml1l60Tj0pFpYiNvBl5lwJEBNU68L6VLj86P91o4vjJ7byUBl
	lUetWRiZw50r/VU+69Gl45kM3+/0pbulBZYdzoTsGKYFK/CORNz2FcPpLMUEY
X-Google-Smtp-Source: AGHT+IHshqX+A1UBtsFjq9ppqRSHMn4X/cwBt945tWHGnCo2CaDOAkzF5ffG9Jlb6C7BXt3C9t6MkA==
X-Received: by 2002:a05:6a20:2584:b0:2e5:655c:7f8f with SMTP id adf61e73a8af0-32da83e6319mr10105263637.46.1760007430823;
        Thu, 09 Oct 2025 03:57:10 -0700 (PDT)
Received: from localhost ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6326d3af86sm6576895a12.14.2025.10.09.03.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 03:57:10 -0700 (PDT)
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
Subject: [PATCH v7 01/23] x86/hw_breakpoint: Unify breakpoint install/uninstall
Date: Thu,  9 Oct 2025 18:55:37 +0800
Message-ID: <20251009105650.168917-2-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251009105650.168917-1-wangjinchao600@gmail.com>
References: <20251009105650.168917-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: jnagzh1fo81tx8e5w9zduy4ntpuw67bj
X-Rspam-User: 
X-Rspamd-Queue-Id: 2CB14140006
X-HE-Tag: 1760007431-989578
X-HE-Meta: U2FsdGVkX1+giV1ils2iT1NQFEUpQDj+gTnybO21pZS0y6fYeJIgm0evgeDydHabfvi7hqMTd9aJalES3MxNrzSacq4IzMTQpFWAi+YsuSyPUGpVXuoFg0xHdtgiNJnahrBHeN9kxCsOOV3jIRaEUB/7vnbjyUK1J5o/2dl6SyfL+peUeMV8mkdK97nyS1qj05uG1hQtDIE7mD+0gxjLtrGxgcvh9I/gnT9XYD33cW2GxL6Rkz2wSx72fN5PzGTNyXNS1UN92v8xx3o8NihpXy/moNsW4s/SF0zGtmiJ2ZTfoAk7PiXvR3bVWKZt7EGhKSKDuN30VX2L7WiiyhUjuKNe4CjMABMJRbdGPZ0IUxDncAG5HpEGJLUwJR9U3m7y05FnM4m4dN+qJ340ndLYL9nY9RK5uTx5IGJHSWtSEFJ7ZTbbtGGVHr9uLSQKUx9a/TkOD17HoPi6knm1wpBOBu8HRGvoO/pbfiMje3agz/IJl+Au5qXg9SmLL+4jwzwWXDU+dtI0b0l2efgaTblhwEiZ2bpLGLvJ/l3EQ3NsRBwLh+ZxelRQqxANFyyPZ6RsCa8XE+6b6Pdx/4X3txbLS5wa5hVUEyUeJ09QxiO/uKLmESBP0js2PuoByQo0UfekfAPG8D8wkOYsULmCeu2Bo1GDUBS49+ZHkxv3wQzE5dh7A1mnC3f8vnyPmHnkXnTa+VhprWMsI6DNXXylLl13Aui7nP0M7pzP8hw/Tzc1pPbWTasBatxYKExTxI79CFSXD6uH/rHCeZ7hCRKBrRpm2Lgx3nRqy3Gd4c7OdLrGSGXNA7k2FlsNyld/t7PCMfVce7ptDK+igfRoyysaQRf+Q1lgZrdC83gk5mI1WnUUU40Mnpt3aw3Zk+dgQDENPTiJubZRg/Px+IXOd/5is3K+p4zJhlMOdNXjJ1EuDeQdfMP/F14wI1zFswvzlKtxVzU86702uFGaov4JazY8gH1
 zTgK7spW
 19I0EHE+afn10gwUwotJ7Eq1BLkdcoLfWLxO91bwBgvZl4YD7i/fCOaRT8nYRjUBgK9gFvaccjQ12BshwlhsC1a3wy+bq7rD+9RdH6GyDWRgD+Kl2WVJd7mrJGJ3JOOyLlu/MwjYL64AGF9Rca9pgclYOVonqUIbIv9XKiYd6XF6eeK9oDbTZHwi45lKSf0ZLHGnEvKg6MGUBZGrkj6cXvezTq3tElb7EJneh+lZywNHxrPN5bMNg4/yPsAFi+6uouThUV/XIVCWYBAJCdLHNEIqDhaHimlS31RIWFRYL2UzxzLUOqi61zlp/Dk5BISRS3UDfEBJcH5+qC7WhSh6SEQeDtTzZn4Hjlis5aWCYWCHDv4njFEOJ/2yBHs6YiPRL/KhxkdLYgvE3vY6BQ/VXWGLKImmALK1pQCeMt4YP827eBowLfHcDbZuPu0Y4IbtN0Kj47+NkNDhN5vRjZN9tr/H8aoGKkaVTPli/iMKbBDCPR2R0bRs/gbFgXuQlSeafCKGcOrSQ/2H+9F6q1VLXKB9M3nqo60IaTNp741jHZBb49Xl6IzdpTz9/nQyRUD0jcEfrMr+0L4L5QKcp+/fZsmVn2Q6EEOeeZHo2w/BA5EG0yvlDqmhCjRLdxcEb2jrvA73S
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


