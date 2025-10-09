Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FEB3CCD18A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 10:58:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDD628E0084; Thu,  9 Oct 2025 06:58:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8EEE8E0002; Thu,  9 Oct 2025 06:58:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A56888E0084; Thu,  9 Oct 2025 06:58:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8E3AE8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:58:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5445F4656C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:58:02 +0000 (UTC)
X-FDA: 83978276004.15.B7AC9DE
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6D83C2000C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:58:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hQnYoEYp;
	spf=pass (imf03.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760007480; a=rsa-sha256;
	cv=none;
	b=il7iNFbTZrcIlWch8fkCUwJlAB/wC/j9zT9G4erHCgl0hZS9OOQCk+uR6xoNsfTmiOBz+q
	fx8dLQ6jdb8m57A9AbdaszomLeftrUtXNo6mTLaSSWax1NC9sP4jcMGxccgzMPvifbQIol
	SuFdKPcPEroPNSpngiY4TZeIwzx0fio=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hQnYoEYp;
	spf=pass (imf03.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760007480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sX4DcHmKN6k6jLli4BcDyPNAsEAGb3ORwL+dRbW7euA=;
	b=5mjP2usdfn3PW+6GtlvYc+c9lB3D2S1FgYe4oZHqFB3UdTFY5/NYr4uUHdyo42GY+YmD6v
	/7KYJo0SmdR5UEdabe7ZzfrYFlQFPYWgk4lPJXnhBYtqkCdJ1RwRg4I1wf4Tabdt80LnJN
	bdNTjjK5apnPIeftsAjoNCz1T5o8a3Y=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2681660d604so9885285ad.0
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 03:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760007479; x=1760612279; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sX4DcHmKN6k6jLli4BcDyPNAsEAGb3ORwL+dRbW7euA=;
        b=hQnYoEYpBoMQiZIlKktGj4lJPSDwlv2YtIbXlBnLm/rW9IGNWS/xwt6T2pTXNUt5uZ
         kF9qevSm4+dPKttEEYJjrQQINcNi3bZ3ygCykGPV+gDWm8TU45jPUjUktR7oX3whQf1C
         uQ57q4Uzf99r7/hZ+JhmCvDz1asQzHM4YEVYc5zQijygDQO3W3GWYJXo3ysERT1PXl4i
         SFGQAYiGRyQKwmbtjqWF7rNHYb303irT0AkD1RVAMBap85sTuryWfjbuoS89IC4VHeyM
         V4T0IGIKCz4onD84B226Y8T4d2gaYM0s+5Mqxoy0HnVy6ktplm/OWAqHS6ssxWqHKov7
         uYaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760007479; x=1760612279;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sX4DcHmKN6k6jLli4BcDyPNAsEAGb3ORwL+dRbW7euA=;
        b=gMeHU17MiLjEazt/OipyuKGMPP5EQaBYZsJm+k8V0bZgY54oenbcEizr8jzg8krv1A
         I6Cbz9yXmcfCdgcF4PMK4L/PPWMwtMFcEb/5ab+GsNQOVSWpTOoOGa67c6Tbbxoe4iUo
         R6xPJfUmFZc7POTHYTEAj5v5v+yCivyitwpBJtLrj7bWzNcYTyxLq6fyV1UtMyQk1zlY
         7B6jB1Z6ebP0SZEBS4MaHsVRTO+7ZcpSMNY4J2GEy66R/LrztRjJgG5DwDzUq0tJIM5n
         sFo5Vc71tOYTnX2kevW9tTLF4kG0/8YeEI7D9InjQ4zUcOJbx/5kDFDQhW1Z4ZzGXxNU
         uAkA==
X-Forwarded-Encrypted: i=1; AJvYcCUMqJ8H7rwN2UyTcXIvkQPHAaz9hsNcPY0OYhvZjc4M0rHEESkOMzBNTLdTFsfNow7L+vsySCv7Xw==@kvack.org
X-Gm-Message-State: AOJu0YztKJ4ddc1gSF4rWYQUC3D8kqm7/Mm8Z5jBYzscEEDRYqXKs/7E
	ZgR09Tgux/asIFl6SD2Kdn08B5v5sh+bqZQ8PHCzpHOpLx7fynlDRidG
X-Gm-Gg: ASbGnctAAzz2LterbGr9JDW3P+M69XAUBul2LQhMHYlA1OHAGFpWqfP1l2GkaWXJE7D
	+44eOEh72ysIVBBSULsKxis22DW95wkWkz8iq3Uwja7BMt6qdR2ti58b1kjd3Qgnpuw4eNWT7PG
	TcXUjl46J6NgpjQCWdMjOvNjUXfcfOttjAaKGxMg5tA1g+82bYgjoG1CsJrf8z5tJbdQ8QONbu2
	wbdUQ9pH/ku7E3fuTvGfg5c16bCeAmks6oUQHzdmg8Phtsham8B8rvj9DdJypPdF43CZZQKW7HO
	xoiagV1ueohXpxJh8f0FHcQhAyDIsl3BD+6KRHNeEAlWw552C9XwTew60WzbORmthbJXjqlafzp
	I0udPB5+Ia2w8T3qovY0gZjEGM1+T7nb6ZpLcFtVzhmGJebGDI7VvJUhiRFLl
X-Google-Smtp-Source: AGHT+IG5Zi/tUWgv5fo5AJbJybfMI2YP3J2uv0Uwa+Uo4jUypcFGg1/JcKwmQEdKeq8TaIbn+u9v/A==
X-Received: by 2002:a17:903:2a87:b0:24a:d213:9e74 with SMTP id d9443c01a7336-290272dfbb7mr102338975ad.49.1760007479177;
        Thu, 09 Oct 2025 03:57:59 -0700 (PDT)
Received: from localhost ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034f36408sm24973055ad.91.2025.10.09.03.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 03:57:58 -0700 (PDT)
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
Subject: [PATCH v7 13/23] mm/ksw: add per-task ctx tracking
Date: Thu,  9 Oct 2025 18:55:49 +0800
Message-ID: <20251009105650.168917-14-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251009105650.168917-1-wangjinchao600@gmail.com>
References: <20251009105650.168917-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: wmiyc7tawhqpdg1gguuwi3k4mtnotpzs
X-Rspamd-Queue-Id: 6D83C2000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1760007480-227342
X-HE-Meta: U2FsdGVkX1/29uv2EGZyp6mPUw0wweAxCqIEa+PDkMktJhYMF8Ix1woBXq7DaOMPsie26ZsE/R0Wmm5rooYkdZ66pkL/qXII9q9NNPbsgVXAUpRp91BbHdmUXWh1zqlXb0riixsAS+Cx4J3Wij21PgDks23BYYgls+yhWj8KbyqVew9TCpQ/Wx+M6B5bmo459aa0JoKX+4ZkwweFN1YrgGxse3A87ycOHWWgDR4iDarWzW0JNlNjnKJxcLUybjjT+e27S+N8srmeCqOvFrMrhSy9AWnU3Z9Kg5qEBzm5jdRNM+9q7K/WDseh27sO2e5drFOT+IU//ha7JB6pCF/FxXrcGmnekAeN484sgz+nhBWpvimHi7MI/jFwz9Uc8D3b3y312b2KevT+2jee8xJT7aV0NBRGEF7IRn1OdqOtLM5TpTFIcAjLZUu5hNc+eIN+6cr7DFtcgSa5OP+MONcJiLfrJqetYvsEVspS97+z1SsPCxv90OLPEFEuZFmGb6b/AmFsaAFXdt7155pJMG2aaFwJua4xYPRLWodIi5huENueoJBIBocjVvHkzpENlI1APrnTcYVyHhgLC6VKzKDZyxrZeXh45trqxy8GE2WIrfFT22Fbp1XWptO+LlYjUt7DfoGw4clQxU6cC38igvA9zRbOEvCFvulNo67+7+jBv8cBZQNdYqibI+QsD5r92bqbG5D4o/+e7CaCUi7Vg86vSZtNLKxku7l1D/d8gdEaz5hhMVC1ilHiEvMce+KT+MNXGsGsHXndlMq/KgdVblLsqgv5ISrtJM4yBa/HZ82hltKFCmogTYiaUeBVM9zJ5/8LKcCBkwM54UdHlTOIztU446UBfGhI+ySkiQVoxYrY2Nxu9wjfcH02eKwGq5i/EAelSrXE3+L9ezaUb/NmXqaMyNDGWKzad6k4Oi4fbmxkBRjx2ofVJlHSfBNatroFhyFFk/bkVTm0VmHYT37ee23
 +nevj48x
 iN/9CM3tTxqDfF2u+J3bW6thBEzTlht3JODozO5kHQglsWOPTnz46tTVeBguBQGPy/IOyMQcRFrcfBii6V8CgrxecSJ2pBuDM9xmu3YeT9EO7O1iJRQB96WcOwyElxEp9zRKmAeoRg9U3otecUY8ln0E1uCxsZOPgQErV3p7TtTfIl59Q1ypUjvuuuGwND41qLhj4RPu6xsscA7M+gViqCzgIoTB+4A5elQRIfJMSn1niac1QsIwNcM67vNwjBzLYPVKxJlHY6xGkcnNsFLWtVluxKNrg1no7FIXKNEFYW6uU9BufYpwAisY/E06mOHB/RfqCKVIdieNMZ0q8k4Cj0J1Sy5loiWenQrQGRuzEQA7GHQBAMDXZc7MTxxN0ioH4I+wFSGfOUrPq1FhepOF1jhG9+R4cIDziZhh/9n5tSgsxF/OqYcVHxeFqY9xVvvy5UGcLLeyLo4kKcqYtUH0+jWGgO02QX58/Nu8havrGWwUFV23f/D+sjrLpaStdmC2IafjyVHpIhCIebHxKFI0lBGf5Gza8TQncAelzpoSHbxuW3M72JD1eMK98rA==
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


