Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04709CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 02:45:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D46A8E0031; Mon, 29 Sep 2025 22:45:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55DB98E0002; Mon, 29 Sep 2025 22:45:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 425C68E0031; Mon, 29 Sep 2025 22:45:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2F54E8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:45:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EF2A613B433
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:45:39 +0000 (UTC)
X-FDA: 83944375998.15.8EECA2B
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4156FC0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:45:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RgCsCroe;
	spf=pass (imf10.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759200338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kFRia/GHfKKxxNt0IUc2kN+EVm0fmr2Lz8hq8oGCXGU=;
	b=I/gTPBHTpwe39Ajr0x4G2F54oHx07A2dNm1Q+PtefwHGztM7io+GlJYe7p975q5EgMgmZV
	G4C04MJEkXQ5PylovSzwAscWE2A5wtghnvSn/7HZzcV2SRwMhNtDnCiK1lOu27DiNKa2Tn
	FXlyH2qJ0L9g62egKux7CuXMF7fZsjA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RgCsCroe;
	spf=pass (imf10.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759200338; a=rsa-sha256;
	cv=none;
	b=GBitnKST+RDyawDfFYz8fV3kvj/wNTM2dfZA+2/rEkZyfK1rCgsufvumaYLxNNmjyARaIp
	jBJCzIAVoV2aNGZmwnhLRfVFe/h+LIOcBPUd8ihGERJ21710pbT7IiDLdyDpNzIvHeDGhH
	zJD7PmAzWvfXRv/mwvLA0WKqRZ9G9Eg=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-27edcbcd158so54692515ad.3
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 19:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759200337; x=1759805137; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kFRia/GHfKKxxNt0IUc2kN+EVm0fmr2Lz8hq8oGCXGU=;
        b=RgCsCroeTz02HT9FKdI7zxkQM47wEOn2tnl4pLZkZQn7P/5W+iWrShxoO+OAaaoyPC
         T+ZBQ7DFOA2ln1JG0Hso0XXx3yYU8s7eVzG6I4xETP1Ky5kq+aJjteTckyF5ECFzitEg
         IDSMRMYF9iViVfiqJaGfWWdj6TeVqe0lAo2FcZQ+ob6uL5F6KI4AqFiydK/qVhMp6jrs
         inqrQAJAFZ9SJkmSGFSinjzSnEfdDHLUuH76FlqZ9/n40x2SLRMvEC4YTYSq+ZODA7RS
         8DVbhb4XRSl/sJIOJPUfegny66Obi5cZyiijrN94DugZHj4HTgxYxAyGZv006Kgp+YYc
         NHqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759200337; x=1759805137;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kFRia/GHfKKxxNt0IUc2kN+EVm0fmr2Lz8hq8oGCXGU=;
        b=gqiZDOxMMMUqpF8egZDCi+y8WniN4+XZ+RQw/HSkto1w0tQo+4ckXfTAjv/25cKXcb
         6DoyfxlA/Ex4+pXbjZQGmW3G7YdegIYtN/gao1wBmwpK+c1om1kwvlSeIQetlcP2BVVP
         IYKs79gNX0ebgbKs8rabJtxnwjdTs7Rcc1xg80GZrlSofUcubgAe0Rm5hXZGhOvD1+Yp
         PH8Gp/Tq7mUqU5tKDCXfOd70C5/nqDrUOg6HxyQ8nn1sihgW1STvvs9su/ZTiAWWKL5+
         NYqFXLaX1CqPH97VkeD+d43yVZvd2hwPY7b5dKu/o5E2Pno8LkvpIVJjSP4oUME3H3e/
         RVYw==
X-Forwarded-Encrypted: i=1; AJvYcCXGAKc3S2fRGgGijY0RqYiLvsdueUpucXJtzGMBDhubEzX+XFg1RHM6R+D9aWK09+AfKV5Or8aJeg==@kvack.org
X-Gm-Message-State: AOJu0YwOq5J0/1SRmoUAQMQRAUkWQwUJ4Hwo4tV0Nz9tw0NpF03pn6Yp
	z9KVBXiqeyOX8SbBPHnSoG4zyZPxeHSFq/Ter1iwz8tRpeS98Dt6gqCI
X-Gm-Gg: ASbGncvi46MaHOaKdaXEqgZcsRDxduhxRcbRH2jobNeoPQwlKxcSqLd9l+eeDZqf9lI
	cZrsC8C6I0lFMvr9FubQc991jJySGHfmzeYrE286m01pEUOJXDSpr1wYCib/NJ5KV0IDDFTw1Y4
	lyFbedrjdFkr2wLR1UvRnP1+SbIkb4f6QMu97TmXXhhG3MwPjPi/cKT6PJsHaC336JP1Zit9RKW
	pCBZ2s9X9iWGsW/GwymJ6NFh1CvDCFr2FBIfjaFg98iiUtjXFZ8L5YIvEM/lvbI9YDia62uZdNA
	2sWHe74gbELeDvc9VIeTXCrbM5xzzXLhYmtkF8Y0qAcFZGecc09i/y56FlPEvtj5prRTVhnPRs/
	8e6gwby6tmdZDzdoiI3vKnFLJQUKfb7/ra1b2LRCWGghCqTEB1mF/8MiigHn01KLYPZaprDmcSi
	DX
X-Google-Smtp-Source: AGHT+IHKpBUnWq+gpU5Sy4KTGKE+VZZI2OvvUEv1k1IBPSw7fn6QhmyAtdZNGDjD1lnTAGMCtuFmNA==
X-Received: by 2002:a17:903:2442:b0:250:999f:31c6 with SMTP id d9443c01a7336-27ed4a3165amr204393375ad.32.1759200336891;
        Mon, 29 Sep 2025 19:45:36 -0700 (PDT)
Received: from localhost ([45.142.167.196])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b57c55bf378sm12519152a12.50.2025.09.29.19.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 19:45:36 -0700 (PDT)
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
Subject: [PATCH v6 15/23] mm/ksw: manage probe and HWBP lifecycle via procfs
Date: Tue, 30 Sep 2025 10:43:36 +0800
Message-ID: <20250930024402.1043776-16-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250930024402.1043776-1-wangjinchao600@gmail.com>
References: <20250930024402.1043776-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4156FC0002
X-Stat-Signature: wofh13r7pykwk8zi8cppcf79y1sdo83r
X-HE-Tag: 1759200338-852912
X-HE-Meta: U2FsdGVkX1/InkkRsRg9mIYGC2JQMQAvNvnDLvrzgl4T+yYEBFhkjnaeWFLPul3FshOquKue+QKy3UtrCU0p4h0wxP8YeDid/2FqAiNb8F/o9U+XHtFVVRy5WsGMf2OLu/m0DZCauyiUI1TmTLxDEYwh4exFI9fWbhhPBz85YmvpS+Md0XDZGKvoP/9R01tAQ2u3wpkIlXEASh9cEEeEXMIZQp/zBM+i6ENcinBkE0rTWSCA+CGT8v1ujBklB+uqH4m9PrUgONhsj3sdcKoyGhB98UoWNWfvrJmw2RZ2y0i+bv6zy/4ACIWaTncZv+ZvEtxlmfRtU4A+l+BBTmZ3SltDTbp+Unr2N47/1VfnU5tOJ9NTyY/ZlQ7RZLro0ekMg5dIfX90+mi+h1EMvxKdoGK8/2kgYT9WbQFTAatxDdR47I9U+KX9ZxknCoJHS3EkoA2ksm5uJHWB6Vpw2vSSCM9z1AvyUaG2BLZbAOsdVze6VbFGlNUGyYgGeX6JY2M5J28OgbFRkY+b4PR5u5+9Exm+g6iOvwyjQC7HHIZV+358JD767BGFBJ17QXRLSW9qa+fjHJkHDsp+TUZCqSouU59up8IoDxcNBmXJyFxRC0s9hZxaRdejRSJgN1cwaBj/S2T7BL5P4n+36cu9f0nvylzq3phMVcMCiw29eqpVNrb1sYn4pD8YNihqQEApqxGopY6owEmwuR8S9tZRStNQWQHqY2t9y6pOAoCxrq5nDZn1Z+XJy6622wed/U/pZ+lBm4QqqTy6pVoCSdD7WCaISNBPBYD/7Qbx9Fh7WIv6EEjsLRf4cSQwNMBKEkWIReZsnwivaFw8GJg4ycCdWZNXdWdzzbeIkrCw+hzLnKcvX0xIStCUHQ6Xg7Oo6DtKnNsB6wq9pcOshxLi0kSF5+A9NhSeSxf7xG2xZqg0ffhRoA622y53rd0ArEGPfSWBSYUCNAjaa5LpFfA4XuzCOGm
 8iNcdogd
 QDZOOXTlrZPii3oHob1GTV5KoqWjFwIGaCkPIeMKeOOGrUPPQajmMtS8D4SyYeao6m/MHmB9tT49A7JSvIqhwmlpLRiSS0FpSqlWfXB3pPhzc6DAeZc480x9kcqbFcvIkSX4yLXXaZizqvLxdhCMkl73tW9KvHvnW/jeLwqJIa7TD6z3ZO/t6y5EpsA==
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


