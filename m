Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D9ABCCFA1A
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:37:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA9E08E0046; Mon, 10 Nov 2025 11:37:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A81DA8E0003; Mon, 10 Nov 2025 11:37:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 949BB8E0046; Mon, 10 Nov 2025 11:37:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 80A008E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:37:42 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 493C813965B
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:37:42 +0000 (UTC)
X-FDA: 84095253564.23.57DC368
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6EB21180005
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:37:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fQBubWy+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762792660; a=rsa-sha256;
	cv=none;
	b=tJekjbch46L0JwYoBut56Ct+S+kgGBv+He68sOCQBL4KGxcllKmkwaj8S8W8ABiU1gedsV
	/niBE/loqQ5btol1h1wnVoJjQO+nL1gdHBTioCJrwINq/0JhyEV7W8r46pJgjxLiMTNmeA
	4LgkmxYa1tYR2zhfSqF51TE/vuX6Rq0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fQBubWy+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762792660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qY+qINpaOz0cBrftmlOPWeh/tDbDV+8hjCudsDUPv3w=;
	b=jR8RT+amNvv1IoDLlQqOlVxFzHKM5dmORRi0RSIWpUe64flWMVq/yBpCUmCFAhH1lzyWfK
	mwlVgb72UIHozab+jku9NXu0bbgyE9R00uXdQwJrR3DHXtXYaL10QXjBXc1ZVx+SmG3KxA
	IyCMpHg9p0xvi4eQqLaOqSz/HEARKvg=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7aad4823079so2902541b3a.0
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:37:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762792659; x=1763397459; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qY+qINpaOz0cBrftmlOPWeh/tDbDV+8hjCudsDUPv3w=;
        b=fQBubWy+17VkwHYdqEBz2+qoTiHBwX2zl34zcAWM3qC2GZDwjHOLf+Xou2y1n12Qsc
         mIN8T6c/0Y3bVp4664jrn2xDPDzlLyALXyCJaCUkKZ9Tf0CnDgjmpJLRoC/HuCfpxFCu
         LZ9RlNnYrew57ZWbbl9mNl/QZz3iJefYW4RDGEP2So1qBAKZHaH0Qi6qpoCbq+XDJlEh
         udIiB68zObqT+40SA7fvgUOD4AZWOFdcO/Zi/yZ6kmMkeIjrOgNL88F4zGToSWMRCFnZ
         keJ3/bmT8YEKYHqshzfUdQwLk2qqEisjpQquzv2mxZn9jFQldnnHULwoC0fDnFycE7/A
         zoYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762792659; x=1763397459;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qY+qINpaOz0cBrftmlOPWeh/tDbDV+8hjCudsDUPv3w=;
        b=lXazHORPoeP+C9TwD6dnX3ZZqc5/yyelB1YnA7Yu9qtDuHWQc41BOpkFSWHyqUPq7/
         06R1JYT4xv7+E5Fz9SV1ubopjNruQrcfPoyR68zr8qyuc4kPCU91CCW1r4/0+KlCNYwv
         biqCWZU2fOEcS22rn7LKWwJqowVuULp2UuggxT42QP0p1UsRqruqCZIitY9XsEja6Hxm
         map3E3bcwUti5oQsL/JijTX+hGX+LlCxYKsFUOLv2Vvtyl/mKPexvKWXA60D1zNex+++
         UhdoxSmu6U4+zPUnTD6+Vq5o8Omxx5lHXoaQqRcXYyRHz8DDKGK/NWW671P2Q1nnOgFt
         qodQ==
X-Forwarded-Encrypted: i=1; AJvYcCUCfNA6aY0U194OO6XyVIdL/oGAGzYO1AyuvfCrxTqTJVqDeoRKYR/845K72nyOsye1E4e3eT/ryw==@kvack.org
X-Gm-Message-State: AOJu0YwprioeGqgeX+1tckPr3/VyHCUzLmwhdhGx157K/zvtgkC/9qaG
	DHWVikK2fMEg/2lPupkFNXGdpZz3qQpIpXaDvnNZJhoTuSdNHca0GiW9
X-Gm-Gg: ASbGncvmlICo1YM1Bn7D72Vh4ALh6eTI7Nin/Dy6eTcFyc+M2e9xMItvEFvZIVQRK7B
	TQjqJx95lf7Wsob55e1iElhQnOyDaeuw/O3/lMGiRX/eDug3eUswwvlTuCZkBg8K/i4eQ6sgvEb
	zeZt3GCmz4dnHFlPTl/KLxQEWRubU+PYaTXmm5qWY9Xn0Moz0DGOdswnPWMurHgxzkRjBnrxPka
	xbYXp79ZiMBB6vG1shIjugvFPGcpJQbKaO1WppYw4OPXD0IOi8/7FpManzc9gWzCn7WwcL9A7pk
	LYd8V2YlTJMYSLIBDc1YGeNmpy45//qFmx16T230NUseoZWQTPZPhbUznzbN2BapY/OVkSXpGZQ
	qDxsA7MG5lOsu+EVTDKakCS0urTlys6cvtX6EQ2k+WATFrpEkoSTMgwT7FtJpsV/9uJV/qkddDV
	4BNLh8mheIuF1L9okktCZkUw==
X-Google-Smtp-Source: AGHT+IH2fkExOiw2xx23499QoJR+0QVGEltJ2Kq069nEQ8OMBF3QJ74WPA0vkc5LrwSnkN3SgQQOIA==
X-Received: by 2002:a05:6a21:6d97:b0:334:8d0b:6640 with SMTP id adf61e73a8af0-353a13aaf66mr12767757637.8.1762792659125;
        Mon, 10 Nov 2025 08:37:39 -0800 (PST)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ba8f8e750c1sm13193534a12.1.2025.11.10.08.37.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:37:38 -0800 (PST)
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
Subject: [PATCH v8 13/27] mm/ksw: add per-task ctx tracking
Date: Tue, 11 Nov 2025 00:36:08 +0800
Message-ID: <20251110163634.3686676-14-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110163634.3686676-1-wangjinchao600@gmail.com>
References: <20251110163634.3686676-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6EB21180005
X-Stat-Signature: s3wn8rakksyz98wi9yop3c1meb88hpiq
X-HE-Tag: 1762792660-635742
X-HE-Meta: U2FsdGVkX1953bmHPAVqAsW/lSB9SRUXiNp41rfGvn+pxvl7g1OdRCfeiSwIpHwSWeZEVSccd7HKajFbhO0UugTVzazlYiIFjfnm5HpIKWONatD5M3mznbr92cKVm8RjoewMHv4iKNLyWkED4kpaSgbk6KuC0uO2QIgtNUnxReMXxXUv0lGQUcOOYofwcxwW0kIRFr+JZxmSQRe9olSXuWS5gfbO9u7PMM1K0EofYoJLaIiMJHwv9YZtK5MbYcjO9kKiZQt1o4s+nA8gIU6nYCgs8OcyRzAE36Ar1EK0MTF+x5GF6azaT9P3e7yv55z8SVSNtQtuMVxwvQNGGo7eLKsj5OqnqtuZqR8ouXDHDzNfH1zZ8KMQCUMFL3sVYjhRGHy6Zwg8XG56eYja3tGi58L1s2T/VuT3e6RE/0xylp63TXZmfTCdm8W1Kr0W0gjEx7hUgENSHEb6qBUxsAqJc/DyhpGS7s5+MwhsLB4If4sTc3xYuwL9Y3wtG0urCOd+AsQdgRV/aU0JeC3orDeas4HeqdGbalv64FzV1hOW09QppgkuCEX8zO7fm0NgFmVNQVer2vb27Hwmhas9qCYuf59Ot+g+A0PAtheHxw84PsL4n2jGhQu2cde5csuFWp+Y/B75BPkqmnUI+FZsHCxIKFKVLYm6c+yRdMXUM+ZeTsKgSmK0PqEoPvmYGwLjwznUMDXafII41XmvKdZPzTcosMh9w1IiCzu0mthEX9RiGXuaaHeUev0uV4e2T7UL7hCQLd0gLDWysqC5DpBQipGBWYCMzi2ZzgX+md9kc79a9VPzn3/VhSePbXh5FQYjqIROH/w0KtaTLNc0usG5ssyOSSPsNjUq0+X3aELy3aMIeMmqQtV0XQTzAygJfIy7xnfc7/x6rAshrjz//L8n8cYVlQue1ujoQ6V5DI5I/iG5uOxB3tz1evOMNv5QCqWJkIjE9AejVQrxjc4CIyyTy5W
 z8/ucUz6
 +Hnvz84LjFnY+U3N1a674LcvgosK/V1KYOWo2IToiFFp+eqR/xEbvZ43qyoqcCi8TSD5TTILhA57bsO03iQgXTdYVpZx9SCQPgFouDkzZz7Pb5Dj2MT2JpmzMUSaTsUSFz2UvczQ8YgwWVxco1yBktPDB3928+JEUDpOqujzz/DhDNtFI83p6tOfGiFkr0BRpHB1OfhFE0Sd0viGKfl5Rh7PpfNfcoR5EPiqGqlR2NzGBbt99qqY3cN1AJQLYoeSAWR8/qWNF53Po75SFwEDBuTHHvWuEtnhaLBKAcuKtTNGPgmpefPD3/rJjBQZfhtRDp/OuXbuif/zn1W9ui/3wXyH72Tm55A+fX7CgUFJxhuR6a7fTjMS+r6zLdpEyvHRdKEcxXinAxWegLbkm+gCq3rVloVPbzEZ0Q9UyDMOsLZM3rcZYyte3FCdKNnWnCacyO+01LK723NSz/OS2sDXflaQOkxQvCLjcgqrXM99jq3ce0kgep9ROvFrcopg6O4k6YjqeJf8rVmSc2HZG+LCQOZ8SSJjlxSpwwAdPK3UP/QmONPONTxcgbaVsKw==
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
index 3aa02f8370af..96014eb4cb12 100644
--- a/mm/kstackwatch/stack.c
+++ b/mm/kstackwatch/stack.c
@@ -11,6 +11,53 @@
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
@@ -25,10 +72,22 @@ static void ksw_stack_entry_handler(struct kprobe *p, struct pt_regs *regs,
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
@@ -49,6 +108,7 @@ static void ksw_stack_entry_handler(struct kprobe *p, struct pt_regs *regs,
 		return;
 	}
 
+	ctx->sp = stack_pointer;
 }
 
 static void ksw_stack_exit_handler(struct fprobe *fp, unsigned long ip,
@@ -57,6 +117,8 @@ static void ksw_stack_exit_handler(struct fprobe *fp, unsigned long ip,
 {
 	struct ksw_ctx *ctx = &current->ksw_ctx;
 
+	if (!ksw_stack_check_ctx(false))
+		return;
 
 	if (ctx->wp) {
 		ksw_watch_off(ctx->wp);
@@ -91,11 +153,16 @@ int ksw_stack_init(void)
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


