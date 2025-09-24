Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A292ECAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 11:52:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 094198E0017; Wed, 24 Sep 2025 07:52:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 043E98E0001; Wed, 24 Sep 2025 07:52:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E270B8E0017; Wed, 24 Sep 2025 07:52:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CBF918E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 07:52:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9DD6DBB9CC
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:52:25 +0000 (UTC)
X-FDA: 83923981050.21.B6D842B
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf16.hostedemail.com (Postfix) with ESMTP id B5F9B18000B
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:52:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lrrwXhM7;
	spf=pass (imf16.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758714743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sX4DcHmKN6k6jLli4BcDyPNAsEAGb3ORwL+dRbW7euA=;
	b=2nntxKUl+yTzUbHFkNS1yuVwiMICYO9MRojU2vv5Wdoe/agOGqDqec17HnLT2kiIgRT07L
	apd8byw+lNdOGDm56Dmzz/I9+gXhu7rARoYLm0GJzTvIuufcOYt58MVcuEDCKk7XwXimtW
	6Fcey65vt/byaH2Q1ZjelUk9X9L5Iwo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lrrwXhM7;
	spf=pass (imf16.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758714743; a=rsa-sha256;
	cv=none;
	b=n1lMpcJ9XogCyYmKLAguryoad1Zw1gpt0JuME2PYf23h1CCKBfY3sC94RmtQ2+w1eh+M9z
	ijRNZEZHy7TcMAnyeY26IwGYxmn0q2aJF9qW91EIGVTKFzdTCQ/P4xy/rq5txDAkCq7U6F
	KS0kaKLmf+gC2jo6U6KI/E5fVx6xneo=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-77f3580ab80so3800367b3a.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 04:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758714743; x=1759319543; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sX4DcHmKN6k6jLli4BcDyPNAsEAGb3ORwL+dRbW7euA=;
        b=lrrwXhM7pGFsHQdo5OxuOq9qhbF0ZWAi132nwkOpuszJ3PrLw9FE/ar2Nr58IVhsei
         DDDxztLxCQy4mOZySuxWGDHTbHYHw8f8I1JmgG2AtFJmi9QbduqNMfv+kAp3s9CGv+7T
         xa1V6w04rqRJUux2mL/LLBZgpaiA/u9uY1rFkSfMe9UnIwPWHTUYQg++jIKDyDSKxXAn
         jQ+57XxpPvwe5+pIsreKN9/FU8B8q/nDHFCVvm9lbd+YhAGufuamm85N6m0eAGcLxKcO
         46DGexPaGL92a9JucBffGi9tJe+GIbU4dpHWLAb2WSgOf0p+bzPVYL1AXG/RHEEMKoPj
         XDTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758714743; x=1759319543;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sX4DcHmKN6k6jLli4BcDyPNAsEAGb3ORwL+dRbW7euA=;
        b=Szc/DtivpnNNcD20FFUGl4LP1GSsEa3oSROXkVvfS29jGu6JiJWlAgX6eHTp9qvWKt
         FH1WHzNDBynpurHE3rWcLjEWGrfu/kxV7pJsW1tDd2LsvVwnAesniGciCqcyGXTL0h5c
         H6B/TgUyQy9Ua8ebVHUw3yZHLEG8JPYqHLN1nsWsVoku0jwsYw1d9XeZBBX6nuUTisBO
         QBMSo0mSRk1wqazFZtjstZ7V8j2bF2MwLFcB4fHXIXF1SWyrghsDmbFv8gZHwyEaZwgg
         uQsxx6325c4ljtmGe1fZjp8fhJxCpGs/E/7wXNBLzj4LU/gyuu9c6sbtpKknhD2ldPcw
         0yUg==
X-Forwarded-Encrypted: i=1; AJvYcCXLbGiJtTUrnCio2Z0Woq6jQWDFgmlFj36ArxJyajZZpmJ5HTXPamPRIfpwNAB8B0FFMTA66helSw==@kvack.org
X-Gm-Message-State: AOJu0YyDhtzh+RvSp/jA0RXL455b7Z2YdubEOcU8/Cdz0T2PBs6sij9H
	qxNmIm8jyJmiIrZRZ1cRVwB+HIfK2LgfZuAWlomu2s7Pt+DtYAS1wcG7
X-Gm-Gg: ASbGncsXFpdF+urTPLcWrGmiwHLgxH1+C48+eHsf7dGWkO7y2MOvXvo9oDspf3Jsh3+
	HOBXGIDNfNleEQMyBCDiXPvlU32OMhMfdPuAuhSI/y1oBkxXvj7cuRVMhHzBPE1MwatWtvuKk3X
	juJIFLXDpXnxQif6kJMGG16iuWoUCDG4YcBHhWwmBoqulhNUaktDv2tuz6UfAJpkvnvlGiwzisJ
	L9yJXPu8ILbSC5+zpuelWA/B27pR5QaPbi59fcYp07FD8qpcFbmr0Gz+QJnUH95sHtgYvjpf+Pl
	nEk8jSHHijIBZN8rg+isUVqHUyt9fzEH8u17Pl6us0Evpop7Ul7KHacqhPli2nPrHU1+4Ie4wqv
	crxO0FFqf3KE93rQd/U3+OUdFFA==
X-Google-Smtp-Source: AGHT+IHM4OGfhR5oYYdpAC3Dd6EW1w7h66PDSvRIMWNc5YTjulef4dYL+e/NY4vhVJcodihdgSSIbA==
X-Received: by 2002:a05:6a20:e292:b0:247:65a0:822 with SMTP id adf61e73a8af0-2cff1c61c0amr8760157637.40.1758714742579;
        Wed, 24 Sep 2025 04:52:22 -0700 (PDT)
Received: from localhost ([23.142.224.65])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b551518480asm14947563a12.28.2025.09.24.04.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 04:52:21 -0700 (PDT)
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
Subject: [PATCH v5 13/23] mm/ksw: add per-task ctx tracking
Date: Wed, 24 Sep 2025 19:50:56 +0800
Message-ID: <20250924115124.194940-14-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250924115124.194940-1-wangjinchao600@gmail.com>
References: <20250924115124.194940-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B5F9B18000B
X-Stat-Signature: k9rys7exqd6e6ed87rqu5zxgahntusoi
X-HE-Tag: 1758714743-963346
X-HE-Meta: U2FsdGVkX191QKEa+48BbuB1P4rejkY7uz5x9x7BjHKPQPpJY/aIKjpBPW+JGEJJKFFK7mWj1tf3yvvDIyQ5Ub20IdNc9/wOrBuSRBDVyajVm8gJcIsnMyOcOI7zcL7D6cekbpNgqWE9jfTk2oSocQkO5V7UAqj0Hc4V165Zuors4vnaFPIANf6/ircKFrzJ1mDCIqvi/Qs3Qlq1TZpeuiq16P4EwLE/7/s1QgDc8xbp1HGJTkXZM/cTtGT9CMxWctWeD2PZaWscu5YCcSrE6U6uGeLZJ89RYH4FiGjrfrjEAYXa+jwONHdy6tEncwJLrVTXA9rjzyAHc9ZtPjKLSJtQkOSn4T546J00CoEdvsm+vvTvgc/WkAms43PxUeJuruPklt220/IyxL6xa1IzqSIzaL9zZl2RoYXRwwwMqNo7H21Ud1vhJ7Dm47CcC7kzITefdlM2b6RzXHkvHwfS58xEy4TaRzc3JQz04AW2WCwdwZEvpSJ8kJ1PDGcYKzmshagWsYkkJhAISmYn8f/uQd9/JTwoRUwbv7mtcDoobEIaOByDfpCn2iSNXNW9W3RlcnENYDTJ0BIKfwaK5wltKFWR0F47MSXLRA+tcrifmXtws85ojqaCVwjxYzEgExAuil6uUDdHvixm3eW3qxlckaPEdxZMo/D9m8AO36n4GY/JgdR7+PdnxwLgcMvR+O1zU5p8xM9h6GxQFDOGmVFQZ0ANpf7yaXqkQoGswN3w/D1YFDxuVs3CUHgvQpyWgHgZ7Ni+s9HepqERCdHTQm16IwK1qYRwCFXGzVdmKIKV8za4WXkCZ3KefN0eMRrL1eSQ87Ljgm+K9A58l6ejs9vLKtHbzX3i6rPPt0Hg/WsbeDvJl54A1sCFQ3Ay4KGtLDN/+TFjFmd4bpP3FsVX625lsbexJezeqkmGQ6I+FbEeu6NFeeuBEeEm2pBL/OLhMEepFKxyXRShyTtSBXW1pR1
 hG7UegnD
 /AAzVQOX0hC0qCPCMIBjR85kowcCMucLr+6YAZvbQY5rm3H+Pqh/VmZFEDfK2U8t9Ebyf+HOluxm3rQqHQtn1+CpMGUc18Z5nZDCJ/mvWwRL7sbevSJDcy+MVCAMRN2/ZrBeH3v67S1yHEC/LVF+zG9TdlT2fzzYV2bX3vBQKTHv5P0lTmkS66WfKUQFMT1Eon9tTVwg1nVF2rewKJZysKpqJzv8zPqAf+/DyUxU+0tlQY+5kazffdRqdHBP9+hXlJG6K0WB5aUaboVW0Icr1c1eViBAdfKp8LGn6iOYndUe0J+OyPZn4JL9cT7CjTUoOViDm1YhH4Enwll90qUCDl6dPolG8FJx7hmYyaXRUlLASpRToLo3Cu153jRZ9Cu7RyxhvBfhxN1WMq2LvhHqx0uFEjhOzyZSUFOi89Ny+3fLsTxNWqCP3lozmAPkDaHI8Sdfe3gGp7ih4LanYSXF0/a51iC4StDQ65U9fbcgaWSndlbGwW6SIuiJMjJxghr/06GQSPdNddudew1is1KucdBJSBHqVDhwP6WXZ84gCCL7rVfF6wfcrySjLZQ==
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


