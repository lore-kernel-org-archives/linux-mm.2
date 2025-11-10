Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2169ECCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:37:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B2CA8E0045; Mon, 10 Nov 2025 11:37:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 662758E0003; Mon, 10 Nov 2025 11:37:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52A378E0045; Mon, 10 Nov 2025 11:37:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3FECC8E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:37:38 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 17B4FB696C
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:37:38 +0000 (UTC)
X-FDA: 84095253396.29.E8DB6AD
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id 30B2740015
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:37:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SnBsSLde;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762792656; a=rsa-sha256;
	cv=none;
	b=Jo54tD+YNDX+lIdDLJQVMT+4cszNKDHfkzSlFgpPfQj0kExK4NapCAkCbqXmZfrxb9m4q7
	wW8d31aVkwvG8mGrjxLvqMjQsdR33vZYa+DhPnMyuE8IEBZlKkVWRYCcYaPSS9q2suE1ty
	cxp3ENZrEO1dJc9cNR3l2nXKJvJcSlk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SnBsSLde;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762792656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j+iVGEpI5Tg4S20J7P4CCPxNAttk2LGvwxP9Ue3oAtA=;
	b=ax6OCcGFt70ywMuhoTFn6sy87el5Noi8p77Ij1izVPdqc1uacYzTTMS1HRGUw4Chqv5jLu
	QQ8JXcckZrSQZBMiG8pysSuUZMBR+r5676nsksJrEFgOsY/xFBfxC/WALTZsy/ymt2riIM
	KH9DRk9Cs4sV+08qtpoyzIetukHK71M=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-782e93932ffso2676365b3a.3
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:37:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762792655; x=1763397455; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j+iVGEpI5Tg4S20J7P4CCPxNAttk2LGvwxP9Ue3oAtA=;
        b=SnBsSLdeFv7Csf4t8vbwAAInDBcJ5UYKvKINnjaD3gyJane2FI6iphVI6lsH1pBFw2
         MiDLyWkB3V/CCikUQpEPC3bbkmwWEgOr3ucYh1mdbWqkL8NhsgfwC5rQu1rWQ/kbwc5c
         onAlxSVI5t04IA4diIZmVuynen+5jT2ThrtxO/CcjUmpwNBb50IpRWC/txLpSTJpkyjz
         PXZClWRASa9i1/TxAzeeYlDCK/LaiWq6JSO9GAzQJE3ORR2ALcdp5HmDIlGBysYMTlOn
         /gwuMTbkw5CJmDHT6fV2Hc+eTaIebbg5GSrbQdSop3FPC8duS3WGQsU5vvNKyOXbuhjg
         XQPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762792655; x=1763397455;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=j+iVGEpI5Tg4S20J7P4CCPxNAttk2LGvwxP9Ue3oAtA=;
        b=eGjs73sEESnHeC/p7udP/D10KSZYyy731A1FYryKJGlelNKrAwRGg2XlM2Pmo00YT8
         nraLXTg2gOGPqeN9RNC8+QKN1L4l+RZVuN+vYdpv3lt95LVltwn3zVjaCeNvHtxJIa4U
         AcBytG0JGiY9eARYiFx5G6z+DISipr+kJa92Dk/k/khEVzV5lUKnt7dFRedTHwgMXWu5
         a9eooGobqf/8UyuPptzHx4dt+YjWIZdDAEanx7x7NKFmtv+fNHq0KTDQC3u7Fdx2fXet
         5AWAmuJNACeLdUvuBxAYaQtC149nqp/As9EyVZdTQsE4jzmmmciI593a4s4LZZCcon7i
         Z+zg==
X-Forwarded-Encrypted: i=1; AJvYcCXWQSkGxpUwGJAHv0fOGU68xerRKQW8x+Adp7Wxj5ddo0Af64pqNFALeNL0f9PBi7eI9gI/luvLag==@kvack.org
X-Gm-Message-State: AOJu0YyDsPYdonWXwjwXibXA/XoW9dBcS0WHxJINP61qdZ+XBKViVnAo
	sEVAMLPyF99Dq9gMy7bu0o/SAMKaxOxxO4tUl3tjRMRnbYBQlAJqoBnA
X-Gm-Gg: ASbGncsH3mhi/dFhxZpybnKBzuRczHawKNlZ3U+VU8/yld+R5+mTx2Hsb0x+I3JFSGj
	e2oWskrc+bkVNM4c+t5smyOxroo2vW2d5qbP4Owxu3doITVXqzRejiEdo6aY5PEJAwt+907jrCS
	mr0UqwMzROHSjDaEUt3KFP0I3UnpgWnn6B90BgkANgniwYBf7onBfFqNRfjjYumnrWVFoXGq67w
	vYR4yX8afSoIHX0lWUlpRjPxwn6XWJkh9vLbVmPMh8jzAW/HyCnZeW6QlLayI9HV4G4P7GBvKm6
	nJAi/2DgHgCMQFDrh8njcD/N9BVlhdQhgnZxoHyCbji1qE3hwhszM1dbpNC+xihI6XMu70rgojE
	IUoMAbAH42QngBmlKifBqfQGbLZgPah+2NubDFj1HmUEOaCRzTjhhVPkZuruB0d3WsNhmLnZVZE
	n3u8lFQEyj+hY=
X-Google-Smtp-Source: AGHT+IGtiWcQfJK4Ygp04b6O0toULhQ9ivsVDr7hyiasnMUnwDIgBXPDlxiRxSR9lhapVrMC+QPG1w==
X-Received: by 2002:a05:6a20:72a0:b0:342:378e:44af with SMTP id adf61e73a8af0-353a39633e5mr12501946637.41.1762792654931;
        Mon, 10 Nov 2025 08:37:34 -0800 (PST)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0ccc59de7sm12250750b3a.65.2025.11.10.08.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:37:34 -0800 (PST)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Marco Elver <elver@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ben Segall <bsegall@google.com>,
	Bill Wendling <morbo@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	David Kaplan <david.kaplan@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jinchao Wang <wangjinchao600@gmail.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	Justin Stitt <justinstitt@google.com>,
	kasan-dev@googlegroups.com,
	Kees Cook <kees@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Liang Kan" <kan.liang@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nam Cao <namcao@linutronix.de>,
	Namhyung Kim <namhyung@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Naveen N Rao <naveen@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Rong Xu <xur@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	workflows@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v8 12/27] mm/ksw: add entry kprobe and exit fprobe management
Date: Tue, 11 Nov 2025 00:36:07 +0800
Message-ID: <20251110163634.3686676-13-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110163634.3686676-1-wangjinchao600@gmail.com>
References: <20251110163634.3686676-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 30B2740015
X-Stat-Signature: r5b1do16nkrw63iqu4qb1ojrzb7i1exb
X-HE-Tag: 1762792656-899710
X-HE-Meta: U2FsdGVkX1/6psBnFw/ESHV68C2N3/WlxbFcdmNuqQG0J580drhOtkaNZDnuphdwlNzGlb4WKe030Nflsn+wNN8gsY2zMbFhKr3d3c6u9yDy/QRMoTYmY1lUi0Yi2ppV79H+hbTbfY/1LGCj526L/MtIJ2GOJSi2Ex4IAqdtBLhcDPqg+Fd4GRegaK5PPa20nR+dPD09lGIvGJvA2Re+hADOjyy+EdGqFMfVU8o6+Otp1OMUHwH00ZXlFM5VAMX3ZlgELjYHKk1RnFGsiBtxdrM8hJc+MpDcVMT69zye1QoxVcoNwF1s2XshIynfMuXiBJkmHAWgOlGMh2XZ5uYZRvmC5X1D/wpJcZY/Wgyu8A6gQhL72ztrA48y4q6yd7kAu3urr7PpucvjtsNH6hvLDNawbhlDThSdCTdLwprKdFs/BxlOMcVunnmC8CwVbqK1B1z/H9cCSyCA3tUSBeJLLsgQnFDrSC00ByuRYaBo5FXXDZ7n4bD486Mk4CPnQ9lWCM307rwHOgkdo4XybH3TGKjwW/btyVDo0xWOFO8dz3GkB2+GZ6cVkmhDFpIjtXVjMmb62e+xJUNckOMITTdvLZFzcwhTe3INr9w9sxV0R49+uWmwac2cE81GK6u7b93Vitn4m4wmdEtRXq7fEGPdOT3DtqEPjAz4Z9aqa2EWsx97qbRWYjaQkh5NKi4Z3B1UI8Xo48XRmsS2aXveekDCntzaDLhBnST+5w8/Ou5ZjUv7tEz9bPt+GZPCb6c0Av0bqmluxIuiUp0jX2Wkr2oTibOnxus3TWg0Btq13hT+F+x3KwO5pizXOokIhH8TanU1lqvPYdf9F4tznR5dytIyuMwWL6L+IdDUNAuXBLryWn3UBoiJ7WacDUwJmA4Bb0/G61NB5os63iETrX2XAI4PdPEuRiR9c+zYEEgM3usmmI2wr6GzRuibhSfRcbfoDHwwfVxcuOUKif67X2t8Kfx
 O98qU6Ic
 Me5u/LdoPHyJbgezyT7V7l2M839gHgqFvzvl44HZ2lmPnmbAuq0atcGDO4EjvcOFLqqji1N9QNnHJVg3SABkgy3NQIm/DYgKeYOagOEJZveYWzh0sEPFVv45FPc1lWRrEVAoY5bCm2AeLles0CBEtFrr3Po5S6MtTrVIue5t0iNVvCQ7pPk4awIQJKB6OLfONbDrAAuEMOueTnv29HVtHnvZL2RHEu29lOcL+2AD7eMUGjfCxq4vYiYPOesNkx8oJhpcEcD6j8HF69gFspBNUqd6wuwnovHHhLp3OKGkSZmoX9KFRqiBNEQEfVZP87CxrCZiSR4HUJvDYWgfqk535haXmxexyMZbglRfKa9PMw40iMa7VI4+Kag767h/BR/ljHK6FoROyX67yhkKBcUbUIYvRB0yAr1+SskAgsJHzvA5FpdX24bOmePC3dWrFQcYd5bCTIwH6TnOqs6uPNWoCMbsP/b5NpzTsXpfjlleAZKyK9VAl5UiRKSlVNjwb8Lq5viiYelrj0MaKvGBlZulqa1XhCLZZaXPthlecfGK8okdoUTyZac11KhVh5zOvXwLiKbcII7DHD2zAu88tJCSAXawbSw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Provide ksw_stack_init() and ksw_stack_exit() to manage entry and exit
probes for the target function from ksw_get_config().

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 include/linux/kstackwatch.h |   4 ++
 mm/kstackwatch/stack.c      | 100 ++++++++++++++++++++++++++++++++++++
 2 files changed, 104 insertions(+)

diff --git a/include/linux/kstackwatch.h b/include/linux/kstackwatch.h
index d7ea89c8c6af..afedd9823de9 100644
--- a/include/linux/kstackwatch.h
+++ b/include/linux/kstackwatch.h
@@ -41,6 +41,10 @@ struct ksw_config {
 // singleton, only modified in kernel.c
 const struct ksw_config *ksw_get_config(void);
 
+/* stack management */
+int ksw_stack_init(void);
+void ksw_stack_exit(void);
+
 /* watch management */
 struct ksw_watchpoint {
 	struct perf_event *__percpu *event;
diff --git a/mm/kstackwatch/stack.c b/mm/kstackwatch/stack.c
index cec594032515..3aa02f8370af 100644
--- a/mm/kstackwatch/stack.c
+++ b/mm/kstackwatch/stack.c
@@ -1 +1,101 @@
 // SPDX-License-Identifier: GPL-2.0
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/atomic.h>
+#include <linux/fprobe.h>
+#include <linux/kprobes.h>
+#include <linux/kstackwatch.h>
+#include <linux/kstackwatch_types.h>
+#include <linux/printk.h>
+
+static struct kprobe entry_probe;
+static struct fprobe exit_probe;
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
+	struct ksw_ctx *ctx = &current->ksw_ctx;
+	ulong watch_addr;
+	u16 watch_len;
+	int ret;
+
+	ret = ksw_watch_get(&ctx->wp);
+	if (ret)
+		return;
+
+	ret = ksw_stack_prepare_watch(regs, ksw_get_config(), &watch_addr,
+				      &watch_len);
+	if (ret) {
+		ksw_watch_off(ctx->wp);
+		ctx->wp = NULL;
+		pr_err("failed to prepare watch target: %d\n", ret);
+		return;
+	}
+
+	ret = ksw_watch_on(ctx->wp, watch_addr, watch_len);
+	if (ret) {
+		pr_err("failed to watch on depth:%d addr:0x%lx len:%u %d\n",
+		       ksw_get_config()->depth, watch_addr, watch_len, ret);
+		return;
+	}
+
+}
+
+static void ksw_stack_exit_handler(struct fprobe *fp, unsigned long ip,
+				   unsigned long ret_ip,
+				   struct ftrace_regs *regs, void *data)
+{
+	struct ksw_ctx *ctx = &current->ksw_ctx;
+
+
+	if (ctx->wp) {
+		ksw_watch_off(ctx->wp);
+		ctx->wp = NULL;
+		ctx->sp = 0;
+	}
+}
+
+int ksw_stack_init(void)
+{
+	int ret;
+	char *symbuf = NULL;
+
+	memset(&entry_probe, 0, sizeof(entry_probe));
+	entry_probe.symbol_name = ksw_get_config()->func_name;
+	entry_probe.offset = ksw_get_config()->func_offset;
+	entry_probe.post_handler = ksw_stack_entry_handler;
+	ret = register_kprobe(&entry_probe);
+	if (ret) {
+		pr_err("failed to register kprobe ret %d\n", ret);
+		return ret;
+	}
+
+	memset(&exit_probe, 0, sizeof(exit_probe));
+	exit_probe.exit_handler = ksw_stack_exit_handler;
+	symbuf = (char *)ksw_get_config()->func_name;
+
+	ret = register_fprobe_syms(&exit_probe, (const char **)&symbuf, 1);
+	if (ret < 0) {
+		pr_err("failed to register fprobe ret %d\n", ret);
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


