Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E09E8D7878A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:45:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B51B6B0092; Fri, 19 Dec 2025 10:45:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 484016B0093; Fri, 19 Dec 2025 10:45:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38C356B0095; Fri, 19 Dec 2025 10:45:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 26A2F6B0092
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:45:32 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B8EC55867F
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:45:31 +0000 (UTC)
X-FDA: 84236645262.16.3D8E353
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf18.hostedemail.com (Postfix) with ESMTP id C8EFE1C000C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:45:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hFqYZIJ9;
	spf=pass (imf18.hostedemail.com: domain of 3F3NFaQUKCGQGNXGTIQQING.EQONKPWZ-OOMXCEM.QTI@flex--elver.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3F3NFaQUKCGQGNXGTIQQING.EQONKPWZ-OOMXCEM.QTI@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZIbRhS5yAElvokIR1MvQQLNlZ/WUUA5jS9gYnuf7mNE=;
	b=D7UxxQMj13l/JZ6Hyoa7NR1ec/a4Xx40x3IbnWmEnVNn1drNuXKhjsRr4mJ8qRakFuqKgn
	lNPiBy6MkcVjQw6Q3as6cO5FLCsJQgtJcSGhen44QwiEIAD7KKGV3vRKLF1z5koQWvzm5N
	7Vj+crW9i3TB1DHinBcqaiChPOq0Myc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hFqYZIJ9;
	spf=pass (imf18.hostedemail.com: domain of 3F3NFaQUKCGQGNXGTIQQING.EQONKPWZ-OOMXCEM.QTI@flex--elver.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3F3NFaQUKCGQGNXGTIQQING.EQONKPWZ-OOMXCEM.QTI@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159129; a=rsa-sha256;
	cv=none;
	b=JOJW3GXkPBA+08AJqe9xkV/OHbRt24cKsM1RS7UIFlWJ+3bWI9y5J7wGQywXzDk9c4qj7i
	d2U5zrxtu3G5yVq8tnR9q94iQvOfwGXCT8yX1wdss9iuwqzL0TVEmy8/9n/6xfA+JnAG1Y
	uN/kAUvUCnM2d1AUBibG3uzlCz/qJ0E=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-430fcf10287so1391065f8f.0
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159128; x=1766763928; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZIbRhS5yAElvokIR1MvQQLNlZ/WUUA5jS9gYnuf7mNE=;
        b=hFqYZIJ9PJIoY6jq1FEfxWfOtajtOvYrExHhcjizu8EGRbYKBGjsUi77xUfJ+WJbgg
         00bHcrn41g2ElJ9H+hcUJtWPIyaqFe/8JrweF1vYfExo/xrZEtk8O7HYJczQhzWV8QOC
         y1GbZqnPF3oGncAnCNIdXgRf8i8Z58ky6Om9jcnCVPQf3tGOA/HxB9kC+AiB3LunxBwi
         orBfOfuIdazcG76TVQOsYIsCtfC3jfc06aCyrx2Bq+5r32QmNL6HPNNIKvxomCytjCHx
         DvB7zAZTILvaMbVjos92FDk7Izz/yROguPgsIdQ15P/yEJenS2eFvx8E2xJ5LHYAr1gY
         cd2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159128; x=1766763928;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZIbRhS5yAElvokIR1MvQQLNlZ/WUUA5jS9gYnuf7mNE=;
        b=RGK2uN6GTvXPjehU0GOCNGQTMPok2KGHM/xDxlC4pGRYKK8ANKVxG4XE6KTUMN61Rn
         DqghPKycuoZwyi09vVAAEo8gH7HqLXDoGRiJl9kHvEhzdC3Wd/InRSGmzkTxRdbMoL2B
         8DDsb6DHrVWWKrkwc92zd9CQcn5EFjCK6J/cdyRDVMs4IYax1djRR4l9jeHBjNFNTfi4
         yroxsPKu+NjEwtu3N14r4qG/KkwZVqaqbnHh4nEzj1YLFNC9WDz4urOdTEN2VmMaMPCe
         J2NJf4m3+Cb7VoPINfFvNNi1m9JEBqYRijR0Xn10qhqEjxZjjHoB3GKzFdu06AXmrP6q
         VS6A==
X-Forwarded-Encrypted: i=1; AJvYcCWCB0OBo1JTscfqnAHQedmspeLqDYNVhzrD8XF6yUE0xxPUKKLP6/m7izRfnzDEsbRJCeYGQAiZog==@kvack.org
X-Gm-Message-State: AOJu0YzXC/ltUetVg4Yuq+/2Q/29/nSj5Ww4qTLDC9k8YP3F+CHzIuMD
	h7fOlFiTzEGcAHhFMAnzSXHyctnSZbnNPlGCdvBaKcWQLKVLn+MUykgjxEObFfIAcOAlMM9211g
	Vww==
X-Google-Smtp-Source: AGHT+IEWqNQ8B2uikI0R3t/CQ7ZJwgcNL1VKKMu3VpcFkJfSPyjiMbOXjCZK3QVkgDbXUfaVN8BdAwmGKw==
X-Received: from wrbfu3.prod.google.com ([2002:a05:6000:25e3:b0:431:37f:7ba1])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5d09:0:b0:42f:a025:92b3
 with SMTP id ffacd0b85a97d-4324e4c0dd4mr3283947f8f.2.1766159127887; Fri, 19
 Dec 2025 07:45:27 -0800 (PST)
Date: Fri, 19 Dec 2025 16:39:52 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-4-elver@google.com>
Subject: [PATCH v5 03/36] compiler-context-analysis: Add test stub
From: Marco Elver <elver@google.com>
To: elver@google.com, Peter Zijlstra <peterz@infradead.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>, 
	Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Johannes Berg <johannes.berg@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Triplett <josh@joshtriplett.org>, Justin Stitt <justinstitt@google.com>, 
	Kees Cook <kees@kernel.org>, Kentaro Takeda <takedakn@nttdata.co.jp>, 
	Lukas Bulwahn <lukas.bulwahn@gmail.com>, Mark Rutland <mark.rutland@arm.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C8EFE1C000C
X-Stat-Signature: ms3fkjttqidp5opcwhztczdap1mz1yro
X-Rspam-User: 
X-HE-Tag: 1766159129-385339
X-HE-Meta: U2FsdGVkX1+loXQxB6mL04cGzGLz1wNUes2FltnZjcYA5Uj8q7vpyQp5PSL2g7g46dvmuLKGaJFfbyvsmbyL5SC9krPr8ckHV/HzSDd8tBxgvjYBlqCv2rqdQfxxLoP2kcB70eHFmfYp2EmzPUJUGuLidtXmHW8lUlS9xDTq6Jgv9PV7jGe4GMpC6FNGfkzzYvHM77Nx5mYMtGv/eF1bwozmoDKG6uQkkkwjF/gV1ObO7gChnO65k8el6BCG9dRJdGO4Yr2wdK0EE5HuKsjHSDqDTokf02c2RtlrPeuWKpev1mKzpDbDOw+bSPhAcB2eqVONMnpjUJ+oj9LMzGp4w7f5UaxeDfSqmcNlZimAODlWfJjWkRWMeX5zKrT/Q+sGQwROwqw5zFWZFTMoYfQqPv/yquVvUQK3byc+w4n1dXYdkmP10L/Y6jwjW2LFS3+NK3rGyTSOxt5rWt+gpgGnA8602h5xspYnHUqm0+VNZ46R0M9jM5I/QBhk6bq21X1XO2tZ4ItwV2TWI+l+LqCDmT2nx63kfNM283PAoPuQsVGNrM75IIs7zP544WsVQ7NCmp8ml6cybC9xh/GmGyBKeCbWOGKbntfWGyQAmNBs5rg5thr5DAAiqexPsqk1BRUtMezpY1XOamTXPIzTQkD43np0NNiQLpufSwVny/oGYczwaG54/BPzdYJZeE5qlezazdoEdQurYu5m90xmlOjhDXFwmRQWH9QGos1JttS0fvZ9EVF3m+LcXYRgyJlFJLEBtU8eHnAq10fOZptPca+vb3qQx1YTOeQ9xiYroHOuL20QZ9EPd1ExVPErqwKPikGIVekCHWgHDgqNLDbh1pFqed8CDLAC1CjiTLXvwUIbVJJrsZe5n1K6ofPDJPpsDDAA9ybG1wPDFheEzqxADbqI5a/ggaTsGZvZMxZApJfYhW9Q0SHJFhradxGxbXoMg19QJJh1CqOw4OhjXIJuu8h
 lD0eIr5P
 L3N2COXR1h/Y4exIgLATdMOTm82/6w33i632f/N17EzGrImAEkxrF775LuGKgYLlVp3lOs/QhTbI7flW+3BZLeHFGwto0sPfvB5PlTFcgzzHSzrozSwGE0ozjf04oFIZMKPDWBF25vfkkk8+LlMQgq3I4hTgRqISNwaa0vUOoAmtF3tJsvBhaU6/OwITsjsmymjZMmtAw9TygltxOSk/jj5qj5yzfjS/zwvV7Va/KWoQFcFDnXOh4wAtzSS/xWvj5Rbn5Jx5jWz7N0rP6ZF/xRztXCLXUkJV66zjCs8YTejUugCiGLQv7AQX+XHFNDe+PQSw5IuGiHuMC8BCPbEr83v50v3DfU05/hMOuOhD/P9BeheO3HRejvR+Wmaold2K7YQmILtEgo7WROJaN0Wt5psxYlAQJ6MzgmMMfV9kuYEF5QYnHCvFFAcehMJZY/BLBxEeqbbgJgz6f7cjm5Ti2QsYVtUAhv1gR/XSy7MHDqwwr8xw9JBzPBH05bsfa614qHpX0C9y4bLfKbPsMn3bqAHEIW/fGextgECADG+7+mARj5y9WjKU6zggLbYKiTCfvvEEmHTSs8TEVm3/FY+lRX0zcfq85uyPujulJ3CbvW2tQUJ0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a simple test stub where we will add common supported patterns that
should not generate false positives for each new supported context lock.

Signed-off-by: Marco Elver <elver@google.com>
---
v5:
* Rename "context guard" -> "context lock".

v4:
* Rename capability -> context analysis.
---
 lib/Kconfig.debug           | 14 ++++++++++++++
 lib/Makefile                |  3 +++
 lib/test_context-analysis.c | 18 ++++++++++++++++++
 3 files changed, 35 insertions(+)
 create mode 100644 lib/test_context-analysis.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index cd557e7653a4..8ca42526ee43 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2835,6 +2835,20 @@ config LINEAR_RANGES_TEST
 
 	  If unsure, say N.
 
+config CONTEXT_ANALYSIS_TEST
+	bool "Compiler context-analysis warnings test"
+	depends on EXPERT
+	help
+	  This builds the test for compiler-based context analysis. The test
+	  does not add executable code to the kernel, but is meant to test that
+	  common patterns supported by the analysis do not result in false
+	  positive warnings.
+
+	  When adding support for new context locks, it is strongly recommended
+	  to add supported patterns to this test.
+
+	  If unsure, say N.
+
 config CMDLINE_KUNIT_TEST
 	tristate "KUnit test for cmdline API" if !KUNIT_ALL_TESTS
 	depends on KUNIT
diff --git a/lib/Makefile b/lib/Makefile
index aaf677cf4527..89defefbf6c0 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -331,4 +331,7 @@ obj-$(CONFIG_GENERIC_LIB_DEVMEM_IS_ALLOWED) += devmem_is_allowed.o
 
 obj-$(CONFIG_FIRMWARE_TABLE) += fw_table.o
 
+CONTEXT_ANALYSIS_test_context-analysis.o := y
+obj-$(CONFIG_CONTEXT_ANALYSIS_TEST) += test_context-analysis.o
+
 subdir-$(CONFIG_FORTIFY_SOURCE) += test_fortify
diff --git a/lib/test_context-analysis.c b/lib/test_context-analysis.c
new file mode 100644
index 000000000000..68f075dec0e0
--- /dev/null
+++ b/lib/test_context-analysis.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Compile-only tests for common patterns that should not generate false
+ * positive errors when compiled with Clang's context analysis.
+ */
+
+#include <linux/build_bug.h>
+
+/*
+ * Test that helper macros work as expected.
+ */
+static void __used test_common_helpers(void)
+{
+	BUILD_BUG_ON(context_unsafe(3) != 3); /* plain expression */
+	BUILD_BUG_ON(context_unsafe((void)2; 3) != 3); /* does not swallow semi-colon */
+	BUILD_BUG_ON(context_unsafe((void)2, 3) != 3); /* does not swallow commas */
+	context_unsafe(do { } while (0)); /* works with void statements */
+}
-- 
2.52.0.322.g1dd061c0dc-goog


