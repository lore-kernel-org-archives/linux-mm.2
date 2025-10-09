Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A916CCD187
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 10:58:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF29A8E0087; Thu,  9 Oct 2025 06:58:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACA778E0002; Thu,  9 Oct 2025 06:58:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DFF98E0087; Thu,  9 Oct 2025 06:58:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 909EA8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:58:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 60B6213BBF5
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:58:14 +0000 (UTC)
X-FDA: 83978276508.03.3300C75
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7D34440004
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:58:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Nbn4di+/";
	spf=pass (imf04.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760007492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UmaGbmiuxIsK0xKTEWJ/f7gfwC2bw8p0SOLh4b9Z4FY=;
	b=tQFywyfzKoRbvnEoaVZAG4ZwsGAUGyjjhZx8L/fWlW3DPQSRXXv8xaFegVODsyNQWNqMp1
	uPWLHrRZ4RrpAok6xHC2yC+VvbB3ktGjNeK80OWp9SmnE2sCOgnvqaF9h/EEDRlXBWJztb
	4wDb0rYWWnG6F1HL97vOMySV4n+3UKc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Nbn4di+/";
	spf=pass (imf04.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760007492; a=rsa-sha256;
	cv=none;
	b=79/kRYGkcsoU3aeyHVvrh+mm+noM7pKwxNm6O7NRSNKvlMSnizgO5X8pyCSdUuJ1VKLhM7
	2/7FxC/Zd4jlGR/XuTa26BbZ6obQ/N4HwsIP2gSxFOPZNag90NO6ojbR1uYzxmLaLrelhA
	GzhK5u5wFEmY0z2Og9A/Fl1Nv/nOpGs=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2698d47e776so6122545ad.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 03:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760007491; x=1760612291; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UmaGbmiuxIsK0xKTEWJ/f7gfwC2bw8p0SOLh4b9Z4FY=;
        b=Nbn4di+/+RQuzG2XuRm1BLZPxjVwo75FVlYjab0TtC/iE+HIFfgrbi29v3dRjba9tV
         pMqB6PYfB4JhODptgXafPxrusvj/lEfbJG1znPzeV2La+ZTyfOHl5j6UuIWyei9KfVQt
         5VdZsuX4y3TmVv2jnr0mlQ1AG3ZCHeECYX5KB5tcRpB9qO4rgi+nmAokCo16LlNZPC82
         v+HeqYlnaXGC8vmUDccqNxQjI1PVis+Iqh2OxP3pwoHSXV0LtwOC7pnsgawz2BW1jSb2
         wAlk1pRhs2ZTEOZcDBHLYumGf2up4P/GbOjByZnoAgieJ09bAhQXErMF8x8rBdXn/858
         dGpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760007491; x=1760612291;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UmaGbmiuxIsK0xKTEWJ/f7gfwC2bw8p0SOLh4b9Z4FY=;
        b=LQtJgJU12LDpoc8p0nGFcI3Li1/CB/NooMHyE2F8Ma0sdUqBLKMSw4LALA1IpwY2mW
         rbe0OYpuvyLpWKMsuaEiDg9shz9TN9oURmZ4S7v298dHyC7eghZ9+FmMqzE3s49WVd+E
         +U20NyWHXzAKJ7Arts7ApvmB/tY9zYclPHoV/KfMDi4Jfyb9F1PgNxocCaQFxv1MLdXX
         4tIo9F4O2/eKHaOueKuiDrjEai5tK+oSEF3pICEPQWAiMfZLSivfZALJPgA0odalsMzY
         7u2Pc6iLqQiNMl6nKk9riy2nGy+MolFQUi45P9r8/Hu3ChoVyacnY+VJmF4yNYF+3Hxp
         fbPA==
X-Forwarded-Encrypted: i=1; AJvYcCUKhhu6WTY6xNT2KvKCWanbcBZDQmHXGGSvN1EXpEZFaFndjg0dE9u8LiztVLag1CqTHhziYxjaVg==@kvack.org
X-Gm-Message-State: AOJu0YyumAp8+YL9Dw+jeH7TYxRY4IjM+oUdw9zE6phQEluOciEfBLEL
	KS7sbQam96g1esvGOdL6NY1/QbnVg9avOwnyN7kVyitP3ogPqv0baIsn
X-Gm-Gg: ASbGncsph5rOVWmIKVik8ctMOQPn+gDelADlwZ5dykO2TTaTIqjDNM+Kjrk5s/VjBqG
	h2Idu/7ML1tYBa1srDtghGA0IccqdynzDhRKJxI5+CdfxGao5kw3+9+VTbRVVKo3V7c0aiDGerE
	6ueqm4Dgj3gNUyQ3dSLIJIAUsr3VIRQZLWkOEut4adh6N41mj2UDK0xMfUpQeU02U1BMOfibQP/
	QrdUg2u+Y0xuZmL+SUK4lWQ+cnYeZ3bW/0dH3cp2vfwceBnafw2MMiSo5qvTyC374qaoZ3/sGUF
	n7zsIoCISUIwFUhx/aQi9l0SJkYIw9uDLnhHz5Oi3CG1oW2+5In6Rx1W1QN4hwpowMtEOHv+Cp9
	6Pipa7Kry+a6PWT4nrceLtLj6mW2mmpe9ai4BJpwQSauBZj5JVfixYaFWJfD4
X-Google-Smtp-Source: AGHT+IE5mYvqRuQZ+u7IQ0srPI8O6QG8ywmWS1iS+UAE48zG0ZozJL4ZlmLiRWALZX5JRbD2vynFcw==
X-Received: by 2002:a17:903:2f45:b0:27e:f1d1:74e0 with SMTP id d9443c01a7336-290272b2bd5mr92577745ad.17.1760007491218;
        Thu, 09 Oct 2025 03:58:11 -0700 (PDT)
Received: from localhost ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6099f7ab4fsm20659266a12.44.2025.10.09.03.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 03:58:10 -0700 (PDT)
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
Subject: [PATCH v7 16/23] mm/ksw: add self-debug helpers
Date: Thu,  9 Oct 2025 18:55:52 +0800
Message-ID: <20251009105650.168917-17-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251009105650.168917-1-wangjinchao600@gmail.com>
References: <20251009105650.168917-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 54xexjnyy619xwctuzkqqzncn4kayjii
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7D34440004
X-HE-Tag: 1760007492-592925
X-HE-Meta: U2FsdGVkX1/hY7A7ca/L3iU18bjnAED2qYJMd7pxP9pbEQ3X5+au4RXJ+7mHZxGs+Uwisrui7SxSsbbdqrbDaEnH45rLnmp7Rir5SX39d2+yV92UJzHq2TQYsrgTx7kmwcPPiFOeITTqsv1gmsinYiEighsZj+C9GnZexuidFGau0XotBz7rMyUtvxmoDaaVBfZTQ3OmQZdD9i3O8gRRGUw2YHiKt/Bj6Coggy/LhuiErQPknSvytGI/FXJqBZFa1GV9wbK5a12kmQFWWITZVaoFTzJ979NiaPEL8lEoL9Na002Sd+3xoKgIZDoBL4fCczpsCvHd7pJOZgdTx3nl8cu98hAIyCOS1To3LzP1mnfkTowhQ9CXQll4Nui4qhOLfEPPC3DOW/kpyeCfwnR/8+3fQ9HSTTYqRf0br3b5yI9OuqcWT60lJ7VY6qwF9KODr+AKgNR50bKsNlk0qWIrJojvJXtwYPjyjdioAJAA9AmYoPV9E7JlQo/7WFNP+9PiznRrp39kNbotEnKEcf40lXVC3RoNHWhwLxP1doKsHynBhR4EI1f9M/ezaxNgBysvX7WkNuTQD0ReASpJa9Dmi90Qq4D7THcsl141A4IqmVZa96P3nO1RA/yKOrzM8h0tIsU31hIemOEDbLESDRKWNgMU4xvt51gYpHRP+w8ybXd2xB2wV7YelAXaIX0nJsCmq1E5/3y9e9fgl82+fOMwmzDDRvYxCJLZhF9nHz0QLBiufR6G0hPzOdug9HlpxKPT8Oenrbp0qCVSaOjutcDBK2Ko+nq5Kkj/P5oeYIZ+YLCufR0iPicloVqQsFy3OibiEqEMBt0SWvSCvl+avJEviodGiOVumv6srdTvQ40xlXKYLQoVzQaVYyMng22rNM/j4D3R60E2uF4xB3YmB74+6K35wasqXm79RL7QCdSi5/1xk1WPh4akAA4meD7Pr6JcWy9bo1YbVNIicJsZORS
 UH1bXU9Q
 H/Fh60PEPPjfak9JMrfOmSqZw5bwoAxJ3Tb+gRirc97/dh57LsdRbb6lVH1N5x/3Al60K+PGqZkX4hPOZmdEkozmJOrcZ0CJv6AtUNsEsFAxYY8gDbzXxios5r9um6D0ZksaBg8sE3usP+egWKjqfHEFv3Waa55Hj0ewCNTcz30bsT1cBtWzFd4SvoIYuoSo5DLGQX3mhDNijG0V3elAHPYE+k+mqBJs575oMrUylSNFHCi+Xh6K5UgmaI1dd7m4qzmjRMfFza+1JZx55CEAbwnQM5ldd1lVQgXzkVBSNWnr4O5BBjWz6Xn3q7LLw/IryeOJJEeNlBQ9FBIaASyHoOKrndc9laA/VF2sV9Dnhk5o/5kQGAgxYmD3KI9/jsX6140mjZxy7Q/OCy+zWVWjHe3S/LWQv5jfnryocMir/PehiF/nP7IyO0wvxFtMVc9Ld9svjrDiwEzVcOPLvACx2RdvDx67cUr8Lc8Q/azil1CV1JM5npfYandmweYU57cXo/bq3rP+CXOhfGuU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Provide two debug helpers:

- ksw_watch_show(): print the current watch target address and length.
- ksw_watch_fire(): intentionally trigger the watchpoint immediately
  by writing to the watched address, useful for testing HWBP behavior.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kstackwatch.h |  2 ++
 mm/kstackwatch/watch.c       | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index 4045890e5652..528001534047 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -52,5 +52,7 @@ void ksw_watch_exit(void);
 int ksw_watch_get(struct ksw_watchpoint **out_wp);
 int ksw_watch_on(struct ksw_watchpoint *wp, ulong watch_addr, u16 watch_len);
 int ksw_watch_off(struct ksw_watchpoint *wp);
+void ksw_watch_show(void);
+void ksw_watch_fire(void);
 
 #endif /* _KSTACKWATCH_H */
diff --git a/mm/kstackwatch/watch.c b/mm/kstackwatch/watch.c
index f32b1e46168c..9837d6873d92 100644
--- a/mm/kstackwatch/watch.c
+++ b/mm/kstackwatch/watch.c
@@ -269,3 +269,37 @@ void ksw_watch_exit(void)
 {
 	ksw_watch_free();
 }
+
+/* self debug function */
+void ksw_watch_show(void)
+{
+	struct ksw_watchpoint *wp = current->ksw_ctx.wp;
+
+	if (!wp) {
+		pr_info("nothing to show\n");
+		return;
+	}
+
+	pr_info("watch target bp_addr: 0x%llx len:%llu\n", wp->attr.bp_addr,
+		wp->attr.bp_len);
+}
+EXPORT_SYMBOL_GPL(ksw_watch_show);
+
+/* self debug function */
+void ksw_watch_fire(void)
+{
+	struct ksw_watchpoint *wp;
+	char *ptr;
+
+	wp = current->ksw_ctx.wp;
+
+	if (!wp) {
+		pr_info("nothing to fire\n");
+		return;
+	}
+
+	ptr = (char *)wp->attr.bp_addr;
+	pr_warn("watch triggered immediately\n");
+	*ptr = 0x42; // This should trigger immediately for any bp_len
+}
+EXPORT_SYMBOL_GPL(ksw_watch_fire);
-- 
2.43.0


