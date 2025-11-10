Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68ADBCCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:37:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B450B8E003E; Mon, 10 Nov 2025 11:37:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF5308E0003; Mon, 10 Nov 2025 11:37:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 996EA8E003E; Mon, 10 Nov 2025 11:37:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83AC98E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:37:07 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 36F6C56C72
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:37:07 +0000 (UTC)
X-FDA: 84095252094.07.46D81ED
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4047318000A
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:37:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="NJHGVkR/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762792625; a=rsa-sha256;
	cv=none;
	b=cdJ0tGLTIqhXlpTdN4Jnc78sDNTX3XwlfwsnCD7zKkTmWTFor7ndA5d1DCBnZkYzlRDteG
	JGTOeKcjtfJt7r2kTC9P+d6krphmdJcM5ee4c06X3T2FV7ar75RxjlzDk6zSZjgYKY0T2o
	MMv3O5j4KpjUmSKDW9BZ/Vb4GqlNm1s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="NJHGVkR/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762792625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ouGNoGCEWNf78k//tY5pOloDk6SH5B0un9nqZ5MFRzI=;
	b=a5zp1zLRah/bl5Lw9RqpFqgpokfTy1rhd96oYDWw6+VtOjUgZ2hZnEXy0p7GydszMHdMfw
	b5gH+TWfSz8hUNoXKLOgghZyjpu9rnSl9A3iHHRwGOS2Cra67J3LmMW9gO1jh4P7ndFMhp
	nbNIBNTRwYapC9T0OTnRjc1Lk/DS0RE=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-29555b384acso30285185ad.1
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:37:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762792624; x=1763397424; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ouGNoGCEWNf78k//tY5pOloDk6SH5B0un9nqZ5MFRzI=;
        b=NJHGVkR//KMeZhggRDlj3hyUfGqeXOagz1fX8XU/poCHtm9jQbJ7vOzHJWYBrUaCt6
         PIJxckB2YMXWzY4zxK7p1pWyZrpIyUubktQwjXDj5aDReDcwxbXwysvapFl/1EuPiC/O
         jSUB2j6zSp6mWZgf/yT8GMR/LguICfLkiiz8hFI9UCcLAqSzgxdKv7OylqsMDauVOanM
         AK90P4s+CyXjfZgWeA33vQ/GJ64crQBjD7tSrsN8Sp3rmdhQN6FBERTFxvF387T6dVLY
         pbRs3QRODUahxcfpvmPjWn0t49t3KUSuhODEgBMBHDFnO2gRHIXBcmPy/gwN6roHgfY2
         +3Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762792624; x=1763397424;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ouGNoGCEWNf78k//tY5pOloDk6SH5B0un9nqZ5MFRzI=;
        b=kg8KzG3G455o04yJFGaY7hLE1YEnlYp2Ylf+bb66A/re/VnOVT0faQpOcLHnFAujhX
         MlBoa6aTLHOtYVkNxbJ5wcWCRB5OTEoEd4naUOe2fLmbtJhwuwY57gF90ZiFvX97zDGe
         x0qllPJtaotUhtoS5EKkKBY58Cjq39O8qsT7xVFgRR2Zc2HGmlbevjvIRLieA5Wex+Sj
         dLJcJUjYzB+VIb7/F/tGAxEkigH7umibEgZSj02QjF3TCdnnY2SquzTZv80sFK011gP4
         dVAfFlZbm7v2pPBqwgMBuFVF1VEy5PjQ1AVM00AHPNN0CF+jDEqSBSTgnFMvHO1XDwwW
         mi9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUj9lR0Z1Wuf33k4WTklioIRtxkh6y+DzwtU47J+cQbeDpwhoWfazJaAn3x6n7MAlpCbDvl4h+MCg==@kvack.org
X-Gm-Message-State: AOJu0YybA31eD0UrtgpdOcWHI4AbRHptfzW3JKhCvjEW30vj2GjOwWRH
	PQ1RfnbZzOgCYdNzMpnQEyzZi3s8E318qn6PtKHre394ieTYnV3O9Yvv
X-Gm-Gg: ASbGncvkQ2YLh2a0i8wukcTi1RuZWh6VACK7N9QWcS8BVXBjeL7aMSM7tqaWplUbCr2
	hLSpDWKJqkVu/yHFn7wsw7G7RNAg+mHCLbWt8Iiva2SLhz/6GhkfOi2rjUqMulTw/bqXW+XVfV4
	DGitG08dCP9zo93ouJFY4+09ivZ/xEb3qqXqD/K8I9Kn0AXtbi7+kEhIHTKQYj8JoSbu/f1o695
	kGtGu9wFdLqB2Z9jwTvenhyB1jA62kuK1a9xzGfkxQA39MIGW8lgKCDXXppnYYo5iaCvHie2AJ4
	u/22oEdFpvN/5P/PM6QM56Jl/X0ZctkDvNKKFFgBNL6uJaFGBf4TtvEuFFIfftcQRJJGb+9gY4W
	8NGd1mzq9VVbG4SJoXk0m0bBSaW3u6Tg/IlUgE3+Cc1eIJ1Rsy2RrOcoK2oaw0lcHC/2+nEZtxn
	i1llTuLEDx0LrNzLMfzgCuPA==
X-Google-Smtp-Source: AGHT+IEv35u8inwf//3hNgNcTHKrbkmcMG/RxR47Sb7uiTU4vtvIQ3hgGu7aTHTaitcgX4VFQg+h0Q==
X-Received: by 2002:a17:902:ecc6:b0:294:f1fa:9097 with SMTP id d9443c01a7336-297e56d621cmr108081745ad.34.1762792623885;
        Mon, 10 Nov 2025 08:37:03 -0800 (PST)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-297df996d31sm88101695ad.13.2025.11.10.08.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:37:03 -0800 (PST)
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
Subject: [PATCH v8 05/27] mm/ksw: add ksw_config struct and parser
Date: Tue, 11 Nov 2025 00:36:00 +0800
Message-ID: <20251110163634.3686676-6-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110163634.3686676-1-wangjinchao600@gmail.com>
References: <20251110163634.3686676-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4047318000A
X-Stat-Signature: 1wnnocqxs8w81es6654nib6xsmur5fma
X-HE-Tag: 1762792625-665526
X-HE-Meta: U2FsdGVkX1+JQlykDCEiqU2cdHLZ8Bk1/dgrLWHJs8bPJZnyctz7kuB8+t5iaKVUjxI4Z/Mu++sCbU2qSqh7wb4FoBesxmfKnF3MeFYXgG65Z7vl9WlJ23h77Qer2ma5qA91egB5esQzLQgvcnPyHyBtKwE+D2uQ5Ah2W5A44BbPngvpC8nD80qTr3B+/sXLDvnJNkm+xfgJb1WJCyVDxziWlY7g8XoKOOU3EenRKdLUcmUjiTZLp6p7Iq5jp9SJCZevda/7n7nuHRYhQexXNh2rzOkiB3Q7nz2MFIYKd3eTinGm+wsW7QwnF8lhxP5J/R3QSLO8oPTg5GuywHB3wyT9kUJa5v3CZ+7dsDW6KKMWCyOpxWkgqK+kkiNyo81MMhVDMGfTUZSXxFfYVDhqMnzENzBB74i3M1OWL0IoOOEUbMAhmWheg9FHEVgRlXo0O9ZBa6EU3bw2yhmYXcv7HZzKROM0HcEp/PN+tDgnYP7Ac4W2ce3y/fiHn9lf3wdb58v/Kf6+J2oInniiU8FDHJSE8jZIzvzPxZDye3v6Uh/YkgurPhesbLH++1U9dtt2WynejRfFbG92dnKgJMhKEP30/8wRFECi4j6LBgvyQnDV+7yhIvgKjX9tmsg73ga0rgWK+VgAQ3BsrbJhon9iw0rXx6vCsSj26La/SMXjlL/auICB3jj41rrSVxmjxKSgd1K75AMM1G3c/qTuiqW+xcdKkUwLvpO403ovmdUvVQLuBY7BDyV/aIcz4zTspDF3USAyYg086piqiVdYcPcFXxMC3woH4WR2rWv/k73to+AwjGL9HZ1895YqEIlgmmM1aIpEC/rznPUGXF8H/Re7OkuZDzWcqTSW0vwtX0VjVr94WryButXYO58OktCxt9jJA8sZDsqCfoqx3Ywny+f+eQAXKq64h8g/i1NTsnJFlA2VBqQUUzX5LypUMZngHj/ckwrsOjn1M7VkRU8yov3
 QOMcSfjZ
 MwNFI+zpGLIKxajZCJ8utOBO6W3NlpFK3dDhLCvbeiWWuOQd7MtDPVJtE6pE/Bu5Wo9WnVx6J5S5K0wt4YNoWeLC+Jc+6gdtQJjgtbZHdIFuhXUyrTUZXMEJmAuOKsLnhPuvb5VpKU0LftFb9fIo+WR0qLc+TWvIYLSthTM74Oqu/5JAJJhK/4xn99QiZhJ3x7aiZGuqGehFQJVQLQhB4KJEtzVANreUW290k/Vy6sbAp3ylc1DSYhNkMQvnwZCKfR56XL5S2IMrcOC/6V32DPFsekf95l0492ibTMiTUIVczdhtZU5DyepshKIL7Z97mikN/2BNz/HtfJBy1OfOrpmjQru6C1IBri7kjiWZv4igEWumu4VF5dNq8anYCzalfzTXGem+FlzXo2IPThrV6My9Y0lwGTW8D/5HSKDPseOy+3AUX+RydPCHJFikoAG1afb+UDsvyv4IGOMiUXd1BK2j/32Nvkq/pDpMpJRQxDDNX9L+dEZxf1NtGgiLO72lEATF43Q5X0oeE+SmzhKFWGS7q59gTBEQAVik1dyHafFOwglQFVWzTFSluK8wUtxs5kVX1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add struct ksw_config and ksw_parse_config() to parse user string.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 include/linux/kstackwatch.h |  33 +++++++++++
 mm/kstackwatch/kernel.c     | 114 ++++++++++++++++++++++++++++++++++++
 2 files changed, 147 insertions(+)

diff --git a/include/linux/kstackwatch.h b/include/linux/kstackwatch.h
index 0273ef478a26..dd00c4c8922e 100644
--- a/include/linux/kstackwatch.h
+++ b/include/linux/kstackwatch.h
@@ -2,4 +2,37 @@
 #ifndef _KSTACKWATCH_H
 #define _KSTACKWATCH_H
 
+#include <linux/types.h>
+
+#define MAX_CONFIG_STR_LEN 128
+
+struct ksw_config {
+	char *func_name;
+	u16 depth;
+
+	/*
+	 * watched variable info:
+	 * - func_offset : instruction offset in the function, typically the
+	 *                 assignment of the watched variable, where ksw
+	 *                 registers a kprobe post-handler.
+	 * - sp_offset   : offset from stack pointer at func_offset. Usually 0.
+	 * - watch_len   : size of the watched variable (1, 2, 4, or 8 bytes).
+	 */
+	u16 func_offset;
+	u16 sp_offset;
+	u16 watch_len;
+
+	/* max number of hwbps that can be used */
+	u16 max_watch;
+
+	/* search canary as watch target automatically */
+	u16 auto_canary;
+
+	/* panic on watchpoint hit */
+	u16 panic_hit;
+
+	/* save to show */
+	char *user_input;
+};
+
 #endif /* _KSTACKWATCH_H */
diff --git a/mm/kstackwatch/kernel.c b/mm/kstackwatch/kernel.c
index 78f1d019225f..50104e78cf3d 100644
--- a/mm/kstackwatch/kernel.c
+++ b/mm/kstackwatch/kernel.c
@@ -1,16 +1,130 @@
 // SPDX-License-Identifier: GPL-2.0
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/kstackwatch.h>
+#include <linux/kstrtox.h>
+#include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/string.h>
+
+static struct ksw_config *ksw_config;
+
+struct param_map {
+	const char *name;       /* long name */
+	const char *short_name; /* short name (2 letters) */
+	size_t offset;          /* offsetof(struct ksw_config, field) */
+	bool is_string;         /* true for string */
+};
+
+/* macro generates both long and short name automatically */
+#define PMAP(field, short, is_str) \
+	{ #field, #short, offsetof(struct ksw_config, field), is_str }
+
+static const struct param_map ksw_params[] = {
+	PMAP(func_name,   fn, true),
+	PMAP(func_offset, fo, false),
+	PMAP(depth,       dp, false),
+	PMAP(max_watch,   mw, false),
+	PMAP(sp_offset,   so, false),
+	PMAP(watch_len,   wl, false),
+	PMAP(auto_canary, ac, false),
+	PMAP(panic_hit,   ph, false),
+};
+
+static int ksw_parse_param(struct ksw_config *config, const char *key,
+			   const char *val)
+{
+	const struct param_map *pm = NULL;
+	int ret;
+
+	for (int i = 0; i < ARRAY_SIZE(ksw_params); i++) {
+		if (strcmp(key, ksw_params[i].name) == 0 ||
+		    strcmp(key, ksw_params[i].short_name) == 0) {
+			pm = &ksw_params[i];
+			break;
+		}
+	}
+
+	if (!pm)
+		return -EINVAL;
+
+	if (pm->is_string) {
+		char **dst = (char **)((char *)config + pm->offset);
+		*dst = kstrdup(val, GFP_KERNEL);
+		if (!*dst)
+			return -ENOMEM;
+	} else {
+		ret = kstrtou16(val, 0, (u16 *)((char *)config + pm->offset));
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * Configuration string format:
+ *    param_name=<value> [param_name=<value> ...]
+ *
+ * Required parameters:
+ * - func_name  |fn (str) : target function name
+ * - func_offset|fo (u16) : instruction pointer offset
+ *
+ * Optional parameters:
+ * - depth      |dp (u16) : recursion depth
+ * - max_watch  |mw (u16) : maximum number of watchpoints
+ * - sp_offset  |so (u16) : offset from stack pointer at func_offset
+ * - watch_len  |wl (u16) : watch length (1,2,4,8)
+ */
+static int __maybe_unused ksw_parse_config(char *buf, struct ksw_config *config)
+{
+	char *part, *key, *val;
+	int ret;
+
+	kfree(config->func_name);
+	kfree(config->user_input);
+	memset(ksw_config, 0, sizeof(*ksw_config));
+
+	buf = strim(buf);
+	config->user_input = kstrdup(buf, GFP_KERNEL);
+	if (!config->user_input)
+		return -ENOMEM;
+
+	while ((part = strsep(&buf, " \t\n")) != NULL) {
+		if (*part == '\0')
+			continue;
+
+		key = strsep(&part, "=");
+		val = part;
+		if (!key || !val)
+			continue;
+		ret = ksw_parse_param(config, key, val);
+		if (ret)
+			pr_warn("unsupported param %s=%s", key, val);
+	}
+
+	if (!config->func_name) {
+		pr_err("Missing required parameters: function or func_offset\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
 
 static int __init kstackwatch_init(void)
 {
+	ksw_config = kzalloc(sizeof(*ksw_config), GFP_KERNEL);
+	if (!ksw_config)
+		return -ENOMEM;
+
 	pr_info("module loaded\n");
 	return 0;
 }
 
 static void __exit kstackwatch_exit(void)
 {
+	kfree(ksw_config);
+
 	pr_info("module unloaded\n");
 }
 
-- 
2.43.0


