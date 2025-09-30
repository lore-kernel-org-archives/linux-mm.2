Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3525DCAC5B0
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 02:45:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BB398E002F; Mon, 29 Sep 2025 22:45:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86AB28E0002; Mon, 29 Sep 2025 22:45:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 732F88E002F; Mon, 29 Sep 2025 22:45:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5ED748E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:45:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 368B91DFFC0
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:45:32 +0000 (UTC)
X-FDA: 83944375704.07.0EEFDA1
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5CBC01C0004
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:45:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TXLGiBZp;
	spf=pass (imf21.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759200330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sX4DcHmKN6k6jLli4BcDyPNAsEAGb3ORwL+dRbW7euA=;
	b=P6G238/NpHqGDqyQMQpSOgmkhk3q4pOrmwiR7p0oJOEQgVExZqJEegz0b+yDFQsocSBsaM
	VFkMuQrEQfgerD+hsYs5urbO5vs/PzbcdTjLJBcU9XOMk9rOVNeQBidOl3zNF6azIBJZwy
	mw3tTmPX4duevf2XQYM0YwF5VQPpP1U=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TXLGiBZp;
	spf=pass (imf21.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759200330; a=rsa-sha256;
	cv=none;
	b=jerg3ipIxUEE4sk11r9gqLG0Oest/xqaAgf/4B63gPSQwpUDGcdtvgiDkiQ1v8mlcKYkrL
	39rTTA/aYoHxpoVjkmk/te9ksN023mUiWRTIckXpFxs8jmopDsl++og3+LH3MleWAWI0Tb
	uAowbWu3pXU3TETCyry0BQYHPNsHNiA=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-782a77b5ec7so1927901b3a.1
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 19:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759200329; x=1759805129; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sX4DcHmKN6k6jLli4BcDyPNAsEAGb3ORwL+dRbW7euA=;
        b=TXLGiBZpUwoUAZ3t/XKfisCdRTEyyujrvM3x5/Ru0+HHJqk+AihKNMzt3RTnWeE6+y
         HP4BFOLLkaUyvDpD5d5sQfjvBF2dJRh76czHUxZhLH0khq3OMTsRJ6EOadQpQWtoO/F6
         cFmGdnCjWtTeuPkkRSrsEZ0V3x3xqFcrtqd0D7+IOXhe7I8GRZQgm3hasTMGr3cBLJqV
         /NzECwXEM2XpnydinE6w6ly57wnOG1bb7hBvk+W4/aFWUhF1betpGBJV4tAa7bt3nIBI
         B1nCmwrUN2fjX951rDgr2f5IGya1BTUYMbFzgCrVU8MSeNELYqrNQURYW/btE/pXZEJy
         HSiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759200329; x=1759805129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sX4DcHmKN6k6jLli4BcDyPNAsEAGb3ORwL+dRbW7euA=;
        b=eNKSFSle7GXx2cIp7t7b6qd12qj9eEG3yby/XHqPNOKmRKB1Dba/cGF+crTdxrbHvB
         uXLWLBpOy3uMOMmLKbvrbaqyB4h353B54WUdrihOOgT0ASpeCnsK2G20r37W9PIQwPAo
         HYmujGLRJuf6l3DGQgDn5tf3nV0BMvmSIcdZLSULYtBIO5TRcw9u4K5BKYWIstQ1t3hQ
         7dF3lMNjy0aLf3cSJmNYbUoWKX50VnrkMVUTuCj/FuoRTtZNzOnojNW6cGn5EP1Zf+lV
         XJ+SwvR554UEmcjZo3B9XyI+p20S1R2fLX0amav5FcJlu/896HzntMmnghpl9CGr/jAZ
         mgMA==
X-Forwarded-Encrypted: i=1; AJvYcCVslIOYH8CjsXReGc8sItzR0ygu4fBD7PiQZFGZu6NKAyDyLdGtWah30hfOCfCNLjCYb1Tm2qFXdQ==@kvack.org
X-Gm-Message-State: AOJu0YxURfe/2+PVrWaVlFGx3QWMHaZq3jwHXKnk/LHpndPRcNiOu0ed
	EkiEat4RTvuNwP9y0/jTmAq3UTreuWzDcSDa3Mwh1tE/rl5SD4eEH8Am
X-Gm-Gg: ASbGncuqlGPGV/snENt2PySXBgcNeD0j9hIW6PGdpRW2yRyUSRPtX0+Nf8UZk6Iulgc
	2GFwdSBE4nukrI60kOghzWuz4hy4HgnpUTX6lkBs6hjE9N1AtOO7sEHUf5iDWwgg2X8f4I24F6a
	08a57+QtuZHdoxpj389380ZjsD1XHKf9dN8bpnUq2/UOiUTC7tqa3PesZomtvmOPtJepJhOg1+i
	qXjlptIId7/BzeainISmOHmlnJl0hzqUNtDkiTXGBwopZwXm2Xa+EkKYHuisNChw/AHwdn4KZhR
	UMkzyjx60yyx8Efb3zInoZ0zxvTeaC9hah+JCDlYMOAUDZEmK22RJ47DJes62mYnCai/yB61PTx
	4rL736zConP/92inZ9OpQhIpvGFpEDECq05iCj7sWVfvI7i20Wx6mxm1L9GGehfQ70b863Hvlc3
	pHzt2p85qhul4=
X-Google-Smtp-Source: AGHT+IGTqTwXopd2ojQqxBEBkqI1vY+O5jS9ODQlBJjx1qTPcUYlj9RqM72R3p1od6/UyekDO+cXWA==
X-Received: by 2002:a05:6a00:b53:b0:76e:885a:c332 with SMTP id d2e1a72fcca58-780fcf080d2mr23371738b3a.32.1759200329155;
        Mon, 29 Sep 2025 19:45:29 -0700 (PDT)
Received: from localhost ([45.142.167.196])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-782e36c803fsm5830819b3a.38.2025.09.29.19.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 19:45:28 -0700 (PDT)
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
Subject: [PATCH v6 13/23] mm/ksw: add per-task ctx tracking
Date: Tue, 30 Sep 2025 10:43:34 +0800
Message-ID: <20250930024402.1043776-14-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250930024402.1043776-1-wangjinchao600@gmail.com>
References: <20250930024402.1043776-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5CBC01C0004
X-Stat-Signature: uzwu4s9iw6pewdyrirp4ffyk9drh7xsq
X-HE-Tag: 1759200330-884035
X-HE-Meta: U2FsdGVkX1+l9MLTr1hJt+Ox4emQiRvu6jSwLsZQsUfkRR7UOLMhWo/r9fpQuTMVNEidwJ0b+/ubwtC48HrrcUlr3t7P3GUuvuE9Vrw7G36Cyp3L/gGnLhvNNCskMv/uex+3yPyKfC1O6V6lmn2VyLtPSsscH8kazl49SqoIC6QhckpXPfqUnpdjcai5K07OLgGt1GuVS1LMonZhILPvJOf5UlilNOCKUHxHZ+fe/4Kxmi48D598SU0TWcWJhvoCg7Een1LY+zAyGzeIIjVr1VKWovh+t/sVXnyRWmcaCKkt8tELI4ihaPx/8I+Ai6IL2Zpvb8duY09p16bjEi8Leit0/yBFOJ0pQn1/jaTrl67FkWqI3eyhHr9E1Vhyhim/TdpSzCADkO4Nkvf84bNijKnlE7Hn6GNAV31LkckesYSjHfnobF3MggsrXrTOu/kqBgcLobPL+H9y/oul1m2HoxbCHTniJyC7UsgWVyHw0OvAyUhDxKTwvRyckPjXT0fBC9dTKyXV8cQAfPvIDS5cOPhlKxwXht1XJILKxdw0XKmrSSh6oGSJeb+zLY1GYP19/SFfvomGzCF3xDcpuD12g8+2y0jbNFPmUvrFRXiwa6aAYGPGDmGQOVoSNnYk9dHNDu54n3c/TxtFATUFt5fA4iP4IDxudm+sTnl62shkbHr+BGD7znfMc5tvlyudue5CEI3EUf9pA8jrQ/oY8BhcnLjJNnTRgv0Ug/KaUW75aRatyL8cMEJgCnvB05qvrKSm7k40jQHSeMnhbL/yOyxyXcGaLQFF/9ZaFeCT9XF2zzzpgWzHv77rmLkeWAEhpefLx7rSZFTfA1ueFDXKDy2Ysf1M4zsFP9wKFrGoAP+ZAYcySTz1lPypONqbV+TqEJna3pNAoHtCFXs0cv7r0fJbbbDGZ7ZbG754Bm+OnkwbP67FMmFlSppdWvm1CRH6jM/2gPBqiOisfPq0Fl22Ln4
 1qQa7q8A
 6lWctjmyxWof+ubbL/r6y62VnYpCaZihgiw0V1jtnz3qpZ22bICQC6dcYAt9OsCAB4UF/GvW10QVS+yg5b/MgTAA/x6iehwGWhEgYDK+q0wVksPhOlcjUwPtd5ZJe60lSeB1Scq0++GjWuH+VgGA0SbC1BRHYvUT6lsp+GXENdVQU4c0oEM+6qkJKfQo7wh14KailsAuGBOiw7NMWzyyTkMLbgUnmLEzSIeEDImNyTR9MiX3YP/nFC/pr8oxCTmEaCRpJ9wrleZ5gajpJHEjEvBR3Iija0Ycd/jYpD0dH/QMy1w/mXtGwgggrd/wsl1/JL3ABOlTIktHyoE/ceSnkgAzUKXV4iLy2WfeRqDQcN9Lk4A9asX3ePC2XpVdWTwtoQHcLD9//2vGD7ZlhMuL0qgxm5CHWdVD+jLvg5wSl7Drsl+YZxfYtZlhC9HnNbH7FlKStqBJAuKjaQS3z6BXssi5v/upBfkVwRfGfFnztfGxaywL9QWJy/uf2/siUH0Jw8wDmKfDGVCg10CYpE5EbL9yAZw+xTCPZ7iGFAYJhoZ0LiESTeve3ILW5Sw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Each task tracks its depth, stack pointer, and generation. A watchpoint is
enabled only when the configured depth is reached, and disabled on function
exit.

The context is reset when probes are disabled, generation changes, or exit
depth becomes inconsistent.

Duplicate arming on the same frame is skipped.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/stack.c | 67 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/mm/kstackwatch/stack.c b/mm/kstackwatch/stack.c
index 9f59f41d954c..e596ef97222d 100644
--- a/mm/kstackwatch/stack.c
+++ b/mm/kstackwatch/stack.c
@@ -12,6 +12,53 @@
 static struct kprobe entry_probe;
 static struct fprobe exit_probe;
 
+static bool probe_enable;
+static u16 probe_generation;
+
+static void ksw_reset_ctx(void)
+{
+	struct ksw_ctx *ctx = &current->ksw_ctx;
+
+	if (ctx->wp)
+		ksw_watch_off(ctx->wp);
+
+	ctx->wp = NULL;
+	ctx->sp = 0;
+	ctx->depth = 0;
+	ctx->generation = READ_ONCE(probe_generation);
+}
+
+static bool ksw_stack_check_ctx(bool entry)
+{
+	struct ksw_ctx *ctx = &current->ksw_ctx;
+	u16 cur_enable = READ_ONCE(probe_enable);
+	u16 cur_generation = READ_ONCE(probe_generation);
+	u16 cur_depth, target_depth = ksw_get_config()->depth;
+
+	if (!cur_enable) {
+		ksw_reset_ctx();
+		return false;
+	}
+
+	if (ctx->generation != cur_generation)
+		ksw_reset_ctx();
+
+	if (!entry && !ctx->depth) {
+		ksw_reset_ctx();
+		return false;
+	}
+
+	if (entry)
+		cur_depth = ctx->depth++;
+	else
+		cur_depth = --ctx->depth;
+
+	if (cur_depth == target_depth)
+		return true;
+	else
+		return false;
+}
+
 static int ksw_stack_prepare_watch(struct pt_regs *regs,
 				   const struct ksw_config *config,
 				   ulong *watch_addr, u16 *watch_len)
@@ -26,10 +73,22 @@ static void ksw_stack_entry_handler(struct kprobe *p, struct pt_regs *regs,
 				    unsigned long flags)
 {
 	struct ksw_ctx *ctx = &current->ksw_ctx;
+	ulong stack_pointer;
 	ulong watch_addr;
 	u16 watch_len;
 	int ret;
 
+	stack_pointer = kernel_stack_pointer(regs);
+
+	/*
+	 * triggered more than once, may be in a loop
+	 */
+	if (ctx->wp && ctx->sp == stack_pointer)
+		return;
+
+	if (!ksw_stack_check_ctx(true))
+		return;
+
 	ret = ksw_watch_get(&ctx->wp);
 	if (ret)
 		return;
@@ -50,6 +109,7 @@ static void ksw_stack_entry_handler(struct kprobe *p, struct pt_regs *regs,
 		return;
 	}
 
+	ctx->sp = stack_pointer;
 }
 
 static void ksw_stack_exit_handler(struct fprobe *fp, unsigned long ip,
@@ -58,6 +118,8 @@ static void ksw_stack_exit_handler(struct fprobe *fp, unsigned long ip,
 {
 	struct ksw_ctx *ctx = &current->ksw_ctx;
 
+	if (!ksw_stack_check_ctx(false))
+		return;
 
 	if (ctx->wp) {
 		ksw_watch_off(ctx->wp);
@@ -92,11 +154,16 @@ int ksw_stack_init(void)
 		return ret;
 	}
 
+	WRITE_ONCE(probe_generation, READ_ONCE(probe_generation) + 1);
+	WRITE_ONCE(probe_enable, true);
+
 	return 0;
 }
 
 void ksw_stack_exit(void)
 {
+	WRITE_ONCE(probe_enable, false);
+	WRITE_ONCE(probe_generation, READ_ONCE(probe_generation) + 1);
 	unregister_fprobe(&exit_probe);
 	unregister_kprobe(&entry_probe);
 }
-- 
2.43.0


