Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83833CCD18A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 10:58:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8BBB8E0086; Thu,  9 Oct 2025 06:58:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D61E18E0002; Thu,  9 Oct 2025 06:58:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C50DD8E0086; Thu,  9 Oct 2025 06:58:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B149D8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:58:10 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7907E1A07C8
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:58:10 +0000 (UTC)
X-FDA: 83978276340.30.1D2CD49
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id 90B8E40013
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:58:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DzefW+qQ;
	spf=pass (imf11.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760007488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kFRia/GHfKKxxNt0IUc2kN+EVm0fmr2Lz8hq8oGCXGU=;
	b=vcNcHRVVR10F2lWkYu+mD05k+m9orgNxHRMpHq7OwfBWBd7/Vft4XqyeB30d+5moAslRTT
	PMu24ey1iMs5zM67FNqZRNJO40Njwb+mREHjMgxx96b0hdaLfIwhMm7sh9v7mWXDb7x9C3
	mXW5dnv7fOUZNoaI+JjWZrU9f3/lkZY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760007488; a=rsa-sha256;
	cv=none;
	b=Pcv/YehD7gtA7O9Y0C6e+4eQsz/Vyba1BJP4kAakgjOVLIZFuOwDUBvcCV6DGoR2eNxczM
	38kYKjsFcfbKKmXaMtrg4y+KE1oCnLhqbEffiM/1VC2NOsBcqPmBj4O94flnyvKqnyGSNO
	ei1bZy9A0sNsulQwgNnfixFN1P2ZRBQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DzefW+qQ;
	spf=pass (imf11.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-782e93932ffso747782b3a.3
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 03:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760007487; x=1760612287; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kFRia/GHfKKxxNt0IUc2kN+EVm0fmr2Lz8hq8oGCXGU=;
        b=DzefW+qQRT9DDpkmrmXMZu3iEDvPhjO1CILI0fmjatQXOB4klJheZbIjOpMXqRQ8Aa
         qvpbQYppcs1ZCtsSmyurbBtdY4ZQ2nigmb6CvFaFglPFjG0XaC3hj5dOr9JFfStAT3Vt
         OOB6DXbQ5Z1n+Z7qR80ZA2QdlfEaI+AWZ7XBBXHoDI5DHChCJxcqg9EYA3tmGq8MpM/k
         HJf7SwjS+x1P+WneZq3h/3CMS8pu7sM2Qce44RLEZ/0wlktLSg0ALxu81BGRGCojLHEO
         wka0X6fNKOu7VRWQKwb+RGzX+gDE0bEUbZsxa4Ha6GauBM7MT9XPnsjwSe1udAQM7jvu
         x1ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760007487; x=1760612287;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kFRia/GHfKKxxNt0IUc2kN+EVm0fmr2Lz8hq8oGCXGU=;
        b=aMbEY9qArWJa2Elb9N36SW9o8JOBuFWb8P7/VVeL5uHwZRBOBScYlaqmfLG+cPQnbl
         Z7HZJUvpTDcIT1/KOBnYk/0f2Nag+38YmwBWwTnxg1F7Ib0Q8ieTFRC0YJ1gXsJR2EkA
         NHDQNpohaeqE+DzLCbkTGcq0wivovEZjTvKI/7Fhsmf+0ZN4B9Jz+4rFLUVtGTRxLZDO
         1xEg0OaCn0Efaw39O3ysBmlN3PZTLC66Eh6Di9xYaGbG+Y5A97+fqNqCql9uWd9cTkHb
         tHCQWkS60S3B4q81SuUQr+he/QsideKmHrdwQBPKGtaG1yCthZxf5rNfUbBgC6RSm76y
         bLIQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvgpwiVyF46NiMNeoKYOZLRFU5fCPWRnBPSl9suqdyFDZfJS5XFBQHSDvb2Bhfm2FmpycbjHc+lg==@kvack.org
X-Gm-Message-State: AOJu0Yw3OV+c+Iiiy6Tm0VpynP/7pujEw6Fvw6bWszPtHfX37rf59UiM
	jBnAfEoX32A53ufZI8Yi3oHzrqNgnDDgyDr6aYGUO8tMAaAZBYS+F/EF
X-Gm-Gg: ASbGncu+bXoQFw5zy1xgTsq7cHZ9ToUInp7MS0WO7oQRUbfUklHauynC6/BK6/Uns6v
	FY9n2jR1wzS09dJDeog3t6t1fPdpzRuseT8QZts255iP/IzVhENhDFa60F1WQ/TrULBvYsfCdxs
	821TlurY1FHJcA934eNHV2lssW/xFWrm3X5nBEAxOvL9Xn+mHPGBqEL7vF9s4dMHxoSNGtIiEQm
	AIcGL+yJpkd59ADVF/hZ72Rnsd768lizeJW3dqd6wMdvshKneSMCLHddEk5gEP09x6K+8kZY4/Z
	ySln6B8i04SFrH4jiKajwSI+CfYixcFf8wqgcfoiZU8x3YdhE3sbvQGvvOqM84Ka0Nnpk6vr1Io
	jRuVL5iLeLj+AMhpTEei/WHiufSf5lX65qQNDKCDAd+aJFU1DBeQlPSlhIhMOIia3CZInm7A=
X-Google-Smtp-Source: AGHT+IEEjbaanbFet6ymw5rLaG4ER6hS8x4PnRfmIgvGUILNfBcq5r77DsCvwjAQjB7po7/MVjYJ6Q==
X-Received: by 2002:a17:902:e94e:b0:270:4aa8:2dcc with SMTP id d9443c01a7336-2902737c5e9mr92201005ad.19.1760007487406;
        Thu, 09 Oct 2025 03:58:07 -0700 (PDT)
Received: from localhost ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b51105813sm6628595a91.10.2025.10.09.03.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 03:58:06 -0700 (PDT)
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
Subject: [PATCH v7 15/23] mm/ksw: manage probe and HWBP lifecycle via procfs
Date: Thu,  9 Oct 2025 18:55:51 +0800
Message-ID: <20251009105650.168917-16-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251009105650.168917-1-wangjinchao600@gmail.com>
References: <20251009105650.168917-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: cc7wxgrox3npe9wkxjmxbqtpdpab6ijd
X-Rspam-User: 
X-Rspamd-Queue-Id: 90B8E40013
X-HE-Tag: 1760007488-712934
X-HE-Meta: U2FsdGVkX1+ONtG8jOth4a4/hZYZPjNS+M9IbbUIs5o7l7TNX6ADfjjaMPdrVBJE6e7lLq5wIXvOgLY4/k84DksZFK0BSYfO9273pnB77ypjJKd4cp/0XrBFuIT93sRMdO7jm7Wuuh2a4ueUDPfUX9c5FdEIVzCcqW+14jl/KvYEKB2hfFQ58S83nabSdFRfgu7l0ei2PPfc0QPrs8r6qSbLNrsh3vax36z0Q/P4l1frtS3e8wAjQ3Dvrrs+HJfjh70h+GeWy9TIXrvh0/0ODbPKycuxhNlDolqQ7IFX9KG/Woa/SHjpOB+uNsm1Y2dd9HhN/B8NdlRsfYe4+VQLcpBqMdeoTRTkdKgZTIznNs6Bz9HyTGIk17e42EBx1I9W1ykVLI+W6ynWxaPONNbwzprdcaUyQGVGabgsg62nCztVx+WrQp3JKOg5iWG8ZK9VfrMlCMgAeq8LXFL24U1qykZ2Hwm86yk4dA/lX8u54aUdG2pKKSzdJMNu3UEK1mlRXhfngDyIyVr+819Eviapu7ks2UFI2aMII7LD7XGzp8RhNOyPYuLGolgzAdQtLKl1InU9skOFXh0c3e0OEuuxvt3kBd2U05Er2FfgNXFEEwyqTmE6waxTiZC1WMievK1Mj0nO/a0hTkcRc9ys+zQvzYjYJp+OaYp4AwE6PunEJYGY6C880K2XEg7VtEUKmkY/9HL5NHHC0UjXwdSU3opfr9km/NSicuomkiDfPzFCy61TG7tSzp6r175bGkUnD+GIn/Eqqh7PGHQZwEZ51UW72XZjYMxKSGqwi1G5dxfpTnr9ZoY1QuOOkd9dqqdQrWJr2LU+FZSsjA3OgQkN4aNpcRPJfOrNzvPpMYOc0Y78Ww5mq8xsct25v1+Rr5IVPnBif7QXcuUX48ljKvfgYnzx3nvs/boUi5KTcDowrMjwBMYDTy/9miTqcKRSI2DN9//igif6A6j6034va5jqC6e
 oCUB3Xx6
 sxqCQ3PgJYdCF/7QiPSecfYxwFJsLtmtFgrEgIBMFFlR1W5tMifmejSsqHlja9ePITlDUf22d9ZfO9iGK4iI3NV6FgZNORb69J2WxXz7IwVHuHbRtJhHRBNWx0KFw/HxDOdwPFsuMYYTVJVHwqPFnZ8UB3IPKbc+jS9fRMGWx2GBT/jTpJcDWMvZIUm4J241vg9VIirbRvSiYSr7ORMrPBCotpNm2IdKQtJbuzngGQqDTCmffeGjmtQpvJvif9wFgO5f29JrBNZ5mi8hkx+VpxP53wqnPxNn9Ui8TFd3+EIOUjImx3LjOU12yNi8n1+PMFpl7Aef975EFxDpug6m57gPzxSePMagKOA2l3ildSuZa8JitHNRTVZRXp+TSD8QZkcp87goftTE+9H3Ge5MNlIrU704SS2DNjvbKVJPgpbbQ8BGdtosmQOa7xv0H2AJ2s/0xBWkpGS/Ff394fIIwP/1Wy7QYbEdjH9uXvCYforWAcFb7H5fbKOxE4Hh6rgi7oumNPZqvObvbrzUwCUEOAU9kVBMLojEYqz1q+KHdsAkUUIxGaZ5+JiiMYA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow dynamic enabling/disabling of KStackWatch through user input of proc.
With this patch, the entire system becomes functional.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kernel.c | 60 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 58 insertions(+), 2 deletions(-)

diff --git a/mm/kstackwatch/kernel.c b/mm/kstackwatch/kernel.c
index 898ebb2966fe..57628bace365 100644
--- a/mm/kstackwatch/kernel.c
+++ b/mm/kstackwatch/kernel.c
@@ -14,6 +14,43 @@ static struct ksw_config *ksw_config;
 static struct dentry *dbgfs_config;
 static struct dentry *dbgfs_dir;
 
+static bool watching_active;
+
+static int ksw_start_watching(void)
+{
+	int ret;
+
+	/*
+	 * Watch init will preallocate the HWBP,
+	 * so it must happen before stack init
+	 */
+	ret = ksw_watch_init();
+	if (ret) {
+		pr_err("ksw_watch_init ret: %d\n", ret);
+		return ret;
+	}
+
+	ret = ksw_stack_init();
+	if (ret) {
+		pr_err("ksw_stack_init ret: %d\n", ret);
+		ksw_watch_exit();
+		return ret;
+	}
+	watching_active = true;
+
+	pr_info("start watching: %s\n", ksw_config->user_input);
+	return 0;
+}
+
+static void ksw_stop_watching(void)
+{
+	ksw_stack_exit();
+	ksw_watch_exit();
+	watching_active = false;
+
+	pr_info("stop watching: %s\n", ksw_config->user_input);
+}
+
 struct param_map {
 	const char *name;       /* long name */
 	const char *short_name; /* short name (2 letters) */
@@ -117,8 +154,18 @@ static int ksw_parse_config(char *buf, struct ksw_config *config)
 static ssize_t ksw_dbgfs_read(struct file *file, char __user *buf, size_t count,
 			      loff_t *ppos)
 {
-	return simple_read_from_buffer(buf, count, ppos, ksw_config->user_input,
-		ksw_config->user_input ? strlen(ksw_config->user_input) : 0);
+	const char *out;
+	size_t len;
+
+	if (watching_active && ksw_config->user_input) {
+		out = ksw_config->user_input;
+		len = strlen(out);
+	} else {
+		out = "not watching\n";
+		len = strlen(out);
+	}
+
+	return simple_read_from_buffer(buf, count, ppos, out, len);
 }
 
 static ssize_t ksw_dbgfs_write(struct file *file, const char __user *buffer,
@@ -133,6 +180,9 @@ static ssize_t ksw_dbgfs_write(struct file *file, const char __user *buffer,
 	if (copy_from_user(input, buffer, count))
 		return -EFAULT;
 
+	if (watching_active)
+		ksw_stop_watching();
+
 	input[count] = '\0';
 	strim(input);
 
@@ -147,6 +197,12 @@ static ssize_t ksw_dbgfs_write(struct file *file, const char __user *buffer,
 		return ret;
 	}
 
+	ret = ksw_start_watching();
+	if (ret) {
+		pr_err("Failed to start watching with %d\n", ret);
+		return ret;
+	}
+
 	return count;
 }
 
-- 
2.43.0


