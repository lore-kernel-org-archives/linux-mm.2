Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6AFBCCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:37:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BB1F8E0049; Mon, 10 Nov 2025 11:37:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26BEC8E0003; Mon, 10 Nov 2025 11:37:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10D588E0049; Mon, 10 Nov 2025 11:37:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EED6B8E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:37:55 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AFF62C01A0
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:37:55 +0000 (UTC)
X-FDA: 84095254110.15.EAD47B3
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf13.hostedemail.com (Postfix) with ESMTP id D0EAB20007
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:37:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KzCpRBgd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762792673; a=rsa-sha256;
	cv=none;
	b=AdW1i83renFZ/k006HGSqfckIoDRnPYrnfzQy4wzGU/TZLelrk1EZjUSPLYm8hD8Dv0YVy
	7+UA+8F4/DXwRHZ+RHuj1yIF0O4DLYOaVDue6mprhXAoQXzO9LTyD+7in9z1zqqKXiUj6F
	JICvWuoQ8R6Dg6nb3bd+tct0qrs8W20=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KzCpRBgd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762792673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z475VFvVTEIt4JwZ3YGODDVB/J4Mi7oiMRjRIDfUacs=;
	b=Xra97rPpPGNj9jvzfNPVFN+f+Eec3mb6PvmvbKglGQ10lKIkq06tVcvCfaMvyVuustJA3H
	wtzNIi8uacYtg56XobcuTqlfaORJEU03CFDIzzEf5an61LciPpJX9YXzWHRj/efZ1BjeNg
	ShFkhu/RLZkcj5df65vdcotnznGkGLI=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3434700be69so4345183a91.1
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:37:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762792673; x=1763397473; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z475VFvVTEIt4JwZ3YGODDVB/J4Mi7oiMRjRIDfUacs=;
        b=KzCpRBgdI/EmLanUrEIybhQnLxTnYbWCPaZ0mmRltkAkRVm4uVUkm7vduiSkwUUi8s
         nATDc6wqSlNR4g5GI/Awi+JsVSxcVZRvpI/BjkziQrmDjNHUfv2APwm8fvIZLHMYeT9z
         yUXtWl4R5kNpgvJAvb1O7O6P9UiFJmBzmSNJJJk2IWSIngfkp+1y8YtlkYmmWcP40/Uj
         dkNNumnTEPQgQO2BZzdXY0NO3NSWEsZMQ+KBQVtmUIhYGwtD6fXfM3aiWrQkw/txMc4l
         OPbSGgLQ9ckvctuaGJsRMTvKm/Kp22opBgRNFcYHMYpX+RjwD+ENPbCxZOPVOR/HQnGM
         jIeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762792673; x=1763397473;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Z475VFvVTEIt4JwZ3YGODDVB/J4Mi7oiMRjRIDfUacs=;
        b=c+RXUs4LjE6VYsHVvjbTRHzJhJ4S3eMkDJ17UHnvSP4lbX27KJQt2w5G2IK7EomitY
         yfgKKu6eH6VnOC83ZQG4tjx9BIIY3nAaaUiKUXocXI8VmZUGXFbtURPaN9hofrdwPs5p
         rxalovTfTg39eSnJjvdZlasrEI2fjYcA15ZSUcD9Rk9PbVwYNE1h1Ys/f+9X9iOZcsAR
         qZChioshGGDbehNJRvHV/Qc7dutFMwcXh/NquhH8N9VeYfwdr2XlybGMG9nTkyUcZdsC
         uDLbvepOc5Xaa8XYKJt+MaPjPL63eoR3WFlyV9xvgmDU2XjFFQfvyLoN5axXaEAVCeUZ
         QOEA==
X-Forwarded-Encrypted: i=1; AJvYcCUoatDcGgoENFzvnTDCTCwO6LHDU3CuG4fLD4PCVFhgQPYnQAyelokfivHor+zi4CiphxLCfffkXg==@kvack.org
X-Gm-Message-State: AOJu0Yw1SwsJBj9sm0M++8GgKlchRj7L8tkyEIkBA/WPAOsrj5U1gZcc
	LmMUQ+UzEWfT+tdU45LaMkUiDAajqUoV5iN0iVa+ir51OoySqqT6sYYk
X-Gm-Gg: ASbGncsLub6Gg8u0nun04kxWHujkwhy1BkIFaX2Qi7wrEFYDVdSLXl51jcGgaXLVV+j
	YKl1T6/0I1WfC89KopkZOIh3JTp8jYBu/ghx7bKcFlW9mLo0q813M1MPHbl5UZUjfr5cZ6VHOg1
	DKx99QJhWiFPDkRRFn0y5IEY8HyZ+fBshAHucG3Jd6wzeMsElrFWO37FLyE+oFsOskgob3jvEiS
	iqsDh/kesZRgJWlFSRF9Whf2OljSRjhhzf5GjSY4QZLY1aY+vMo7xIAA6Tns6B1j0cWapbBGKYq
	xinoyEEGiQZGg5/qfOVIe7s++hvJuYtXvk68P7nCP0s1HejnL2/L695yGZw4vn/4gGiU508Zoji
	EyLbNye4X7KthVTcb6z93Hk9QUnaRU+v7OoTDKUyXPwi1kdBhJYt15SVm2RxSJng0hYf2q3ch2v
	VKiC0le9gStbQ=
X-Google-Smtp-Source: AGHT+IFMkp6mzspl/QeVRsUZzdmIZ1SaB55q2G1mEh95QyGe2qx8u+PVoYkCuCMgJ33eu6H6IlXxoQ==
X-Received: by 2002:a17:90b:2d0d:b0:341:d326:7354 with SMTP id 98e67ed59e1d1-3436cbda0e8mr11097915a91.37.1762792672604;
        Mon, 10 Nov 2025 08:37:52 -0800 (PST)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-341a68ad143sm18023453a91.3.2025.11.10.08.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:37:51 -0800 (PST)
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
Subject: [PATCH v8 16/27] mm/ksw: manage probe and HWBP lifecycle via procfs
Date: Tue, 11 Nov 2025 00:36:11 +0800
Message-ID: <20251110163634.3686676-17-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110163634.3686676-1-wangjinchao600@gmail.com>
References: <20251110163634.3686676-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D0EAB20007
X-Rspamd-Server: rspam07
X-Stat-Signature: 97dxhii7jzrnihu4jxihu6aern1ykacp
X-Rspam-User: 
X-HE-Tag: 1762792673-740527
X-HE-Meta: U2FsdGVkX1+zn4kBRSN33bA9sAHsLNMcA1E3QKg4L6K2ev139Dz3Vzl3XxdIZHjYn172xBIxBWBVkPPNV3Gol7XbvOphEs3uQ1YZtwx3dWYj7pUV/SeNdVG0tDD02tM9RE/fie0kfvNKRJdE7ACp+FQY8VaNp8EP11HCV2V3EnHLkIGy7smK38R+P+O3GWFC8EQQYS80WX4ibeBmIvsZHJOiI4optOXceHw7kQxzLzDZQljgaVQo8f/YjTrLrdMYr9Rj2IYD9pM5lWdVrn/a3zy8qvMqbOti6plbP69kGi8Lg//ycR+HB3y5HNbSKZfDZk0wx9omfFtn7kJOrbuvDIvY8RwYYq8xPKVNPOWwfkTaFJZ9Fo1hYH7530QWziXDoiisBK+IYTjvp3DIy9gOGr35Qf4H6REdyEzYVeAsqfX1xDYW+UpO+RQHte5Oj2ZBG5AP7fjhrdLvHZxoBGf8bFpLEzlzxOreNO6SzC3A9FjgWUiah81YIvl5+39uOgmPyqYA0NL8Rlh8norTRsjYmOqrn0iRoF5Lopf1GfhyE/6nhL44SHHxnuEz5ycMK/4I/nlJ3S08BJ7OG9Tt2yYKaLupqDVv+S8vMNYm4nCVkDazFKT9JOkEkLZxj8Ah8guNmeC9laqjEsKOz33XVW59/aS7UP1OO8pYeuOBz+4Xy62gn6hizeTBSwsUbWQ96zUfACF73LgCltiGiND78HqK8P/h8MGOd9A75B0bHbydEqcm/IVJvM1+QyKglDUfAvJXfNw7gGpAvEZNfzQhAGSb+Fo3WnXQllQWpjIRDCxvD0WhGBx7ohLk17sSJPq4dqjRRajeStMeHjFCihS/YHBUF/JJj8Im+Y8zs0L3vH5J5sjQOteB1sPJDDKFsN3HKJnriTq0hDQm+D3aOOTQ0ZpoNA3qAJ39PRrEBcnmAyeqwAP7K70S5rg12+ekGNk5ApxrYodhmcuQebQUEb7bnGP
 rMXh5YYy
 a4OhbTHcEcJqKLdZCleXfvtQVBy2cBmcdvug17KABUQpSAB92fnqGL6EtLutp6dQvxuOsHSYjcVDsE4BpqwnGoolkXmlz4SgMu3gRI/sUpI443LNlP1/TQMiq9BBg6zOxo+UZja+nygQSOYkrUCLLk/s9rd8tgGzQ79sW8oFCtuZ6ZFAX+znCF25JahBJMJUdm3S2semDs1iNlsXX/Wn2pCsm5Q37eXtL3ciQC1smhxPs9azTLvHmBOw9d25YEHl0vJUho39y5yqWiFDUddXlvubqpNOgW/YvyCbkr1KrygDdfRF7RuuOEySGaEr3UrkMqaEJSBfSvTlyEhpkKl84cGB+r1WaFN6aNMiuYf1Ip6sBtUeKQ4DdHZpgdoTtYi4RLjx8ifjd2OvDgNj3HU7F8xW803S1UUS6/74xk9uPeh/J1lXSR+KCXBrvz6d2aP6GLnEBmpx+MJoGWV6PdYi8PlUY20d1v/6fhLKZLaOh6OJ73wseavPkRZOicSLG73XT/OSNGLQbSxgKHXEiQcwzAfDCEe+W3YsGOjBRnPdSHFJBhSjMUO0yyWU72g==
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
index 87fef139f494..a0e676e60692 100644
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
@@ -119,8 +156,18 @@ static int ksw_parse_config(char *buf, struct ksw_config *config)
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
@@ -135,6 +182,9 @@ static ssize_t ksw_dbgfs_write(struct file *file, const char __user *buffer,
 	if (copy_from_user(input, buffer, count))
 		return -EFAULT;
 
+	if (watching_active)
+		ksw_stop_watching();
+
 	input[count] = '\0';
 	strim(input);
 
@@ -149,6 +199,12 @@ static ssize_t ksw_dbgfs_write(struct file *file, const char __user *buffer,
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


