Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 129FDCAC5B3
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 11:52:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D51C8E0019; Wed, 24 Sep 2025 07:52:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ACA08E0001; Wed, 24 Sep 2025 07:52:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 575648E0019; Wed, 24 Sep 2025 07:52:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 446B38E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 07:52:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1653E16082C
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:52:33 +0000 (UTC)
X-FDA: 83923981386.15.C60ED3F
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf23.hostedemail.com (Postfix) with ESMTP id 35320140005
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:52:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bpb1NJhL;
	spf=pass (imf23.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758714751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CDvSRov2FamkqE0fpRbb1mATCdcadu0+ybcKu6XxB6c=;
	b=W5/S4ALCgKBwPQJhUumxfQQ74uYWoNG3JD+HaCF+Xzn5UMARjdoKGQpZ3QLhbhZpSMTFM5
	xF/FxxtBXfdS5IZhz/EtWq1XBaVmy/l+EHirBiP7otjDmzv2ftkRZcv1/1Vo0hHet/g5r4
	aRmv4ygBNZwRY4O68SAq81D+u7issrU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758714751; a=rsa-sha256;
	cv=none;
	b=l+2k1qx/vY4IS7xlvHI8tbNJtB1JYWFdVsA9Fahs930/pY5O7a7x71GO7myy3DQSRw8NMa
	U1mw+/pH2UQjIRueImKgyW1O7PoA2usk5aPXM9veadHKheBZDAVVcd/Ol/2uz3961CmL5B
	Iw++pKRjtajLt1LRu3UqjsqfW7bEhJk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bpb1NJhL;
	spf=pass (imf23.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-32b8919e7c7so7622701a91.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 04:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758714750; x=1759319550; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CDvSRov2FamkqE0fpRbb1mATCdcadu0+ybcKu6XxB6c=;
        b=bpb1NJhLKIhu4lH8RRnyAABriEzjeSFYa6expd2CDWhvPvv94kzH//5kb6QVGGMGr6
         9pOybkX1NrtW1XE++9h6bZo++6IzzpZzqS5eGR7NsogGih7JgAV6ZqLc9/iaVxnv3AUM
         ZQVtvjl0bma6kSNeF1/HYwoSQkhbr0dbirfdAVZGU25beUq28DNQfzENKXc3Z/77jtdW
         GvjSq2khCwo8K4TRDa7t0WPePe5zTQRHdKsDAOqIPhkynlM+r7LNAY/zKifeEdIIGvxJ
         eVcn2uv5Ho83o4r4zRj6OmDun8yG40KhjAacTFhOpNxUCr1MgwtqMWXIxbCYDFig8baa
         crYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758714750; x=1759319550;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CDvSRov2FamkqE0fpRbb1mATCdcadu0+ybcKu6XxB6c=;
        b=u4jB9DHAga+L6AlJcU+mcbHo8KaWoONxV5F7uoGgbNUeUyVHJsVRMT0RIPZhX76uFW
         sNHsTe8AQZWVRdvb279RT7z8x5+tEi7uP/FFhW9dZ2K8HCKCcHVV1N64qsGepGA/sw3U
         /utQUR8KnKi4RAs5XUwqMllc/j1jsmB37gN+6gfL+yH95rodGcACZ86lNmxNANvh6/UM
         bEJB9EM+DRYAmuM4hAf+x3fUNxWQC9r8vSZKZRyp8E3j/DzP5eAHnPRhucw+zcF7jRG+
         eXm4TUoKONLmctGcClNVqpXIHMO9mlkVNHHWqtWgmhak7/QbAl562hQ/ZEePKBURffNk
         wKEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUPdOIfoFHuK9hgzZW6D722J58le/uqJAhjHF7Qo4xDtd/ZtqsuBbNCUZaOch33AofjM4nxsphs9A==@kvack.org
X-Gm-Message-State: AOJu0YwcjGBMDdFAGGk/sJ34i+4riXqZpZ9P6GSmOhLWvkLc2NndapbY
	0s810f8zpZ491qOw5q6+7k+UHtDNVP+FCNO39QyH/cpAayC+f6xGmAOq
X-Gm-Gg: ASbGncslnlRO4rNE7L2gum6AxhakhD/+QP852g8gbne/P0N/EPqT74u/OYqJMws1Qu2
	1H8/FCvujJiZ2HmP4IBtT1eKpxDXN6rcEdbUv9fWQt1WBwrcK8bA7tvbfpWmJoJFEMf7mcDsu79
	DjBmMZMEJ9q5RIvUjozrRre3F3sp8/FGuMGOnx1XrTBzuEug12yrbLw0ThyF0hwuDTMVtr8Ldo+
	CTv7NEBpGtCZCsoDEsNIcfroUqwZr7lwSmCbZy5BEB+hOthBfQyNqwoQ4XTbkrMetODHxor6LvN
	Ee2rxpTWLpFEEKWYl/DD3+uAUw9QdjM8SpysUWpFQlVY9+fGa5gJBSsH4/qZvAz6VrHmhCh+TU9
	yf93TuAuEiq4jtbI+K5nlotj7LA==
X-Google-Smtp-Source: AGHT+IF5ZwoBk0ceUXLZjQvXdKYyDk7CfR+Or0oVbNtL2fgYtH3GTtcS1SuTeoBLjpovsRj6PgtdCw==
X-Received: by 2002:a17:90b:1844:b0:32e:87fa:d95f with SMTP id 98e67ed59e1d1-332a98f6f1fmr6851528a91.32.1758714749765;
        Wed, 24 Sep 2025 04:52:29 -0700 (PDT)
Received: from localhost ([23.142.224.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3341bd90587sm2190418a91.6.2025.09.24.04.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 04:52:29 -0700 (PDT)
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
Subject: [PATCH v5 15/23] mm/ksw: manage probe and HWBP lifecycle via procfs
Date: Wed, 24 Sep 2025 19:50:58 +0800
Message-ID: <20250924115124.194940-16-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250924115124.194940-1-wangjinchao600@gmail.com>
References: <20250924115124.194940-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 35320140005
X-Stat-Signature: m845hdqj53wg6cq9ea497uxzdt7nkark
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758714750-270384
X-HE-Meta: U2FsdGVkX1+zncoLY7V35q4c0EhU/94jFo+gbj+HINAAC1omcHUcc+tDj9DTlNabHmgFJ9tGBzfH1ctuzn7KnZGLw6tPMLa/RfRIikpZq/Up0HiYplfp1Cmu5wW1OU4w1FJx5GMZnD9ZfJsE971gvkgMOsGPa3LVFlH3rOmyk5qXIuv+CBxNqpdo/LZa0f6PLK/dRx7fRXOghwLOKY5Ha4r84BSXPvmgycjaxoBJ938DWtsGG7aLl2lO14RBvG8QDRp7j1rIn9PdFL3almcb6doYLi9SrJckekpkiBA5/Wwg3MpEiHM81fRhodDI3lHSS3RTnY0Rq+A/DcZthSxgMUkEwXlBP/BvcSkIV0ZkXYx+9X2BAd1Z12b7F+rGGoFMmEox3jrqwhT+dy5+VUnZO4RDAFGKg6WX5m4UZBT78ErJGXLGptp85NN8BkwLa5LpbMfTrmsb5MxG96L61jLVDHWbnDcK//StaProwh2z266iNx/JoaAPwwTg8tR1wZ1fdVBnQZANkNNYwdRC6SYQtOnLlw7QJhLuGBL9j24Nv6i6f72ylFEBBONNgBby+gyUgAjvtEqfpoBTR1KHL0UFMVWTzkjN3uSkmuLu7kQvGFmHZyf1Rryh3kf5+9Rw5vymFSma3aCOfF6JzJGNyNtj4E4FzruuzVpH7tUtgeJ4d1DsO5wFnlUrS5ddRpP8V3aqH5gVjxALs5RpaCEgdqbYxny9XYIQrk0w7XCw4w6iRatPmAyi77y1OciGq1A9WKBwMrjjRxjkl/D3KXIOrIefnKsOKKSnmv/fu+g0T386dCXMWcrwyMB2QzyD7LLLBbvCXM8tj8LerBXOMtYKA+8N6goe4+RIjV4tRILDvlA8NesIEWU5GZcuNDyWGGiMEzynUUqkUNKKvZa+ucQEfCO+Xq2c42nNVUj70ZMcmiQd8FMVn5MmVvd7Xi33Iqbd1jLIUrQHAhLiy5lQetCZUd4
 7uU/1Jf3
 q8ycIxdgOpRchupgHilRjzTRsD24xhOyL6wa3aAamVcyKwKEHu3Z4iI4x5UzJcIjXUdLukPtgUKi9tKOWIZUgUjXnbLwF4pbjPe+IsmtS9OvGWte+tVhUIRuAizwirzLN8PZAzDws2+wPN62PVDuia4VOLarWmFjNkFahCDGKhe8UQTDw8s5uOJJcdpITH6CIfJxuXFoTLjzwuN2bSLnTN5MwnEnYvas21s6FFj84zSUV4ST3R8Xz1Hq4fDXcDNUQd9TUowtw+0ZuF20LWiqjlXqOtNPZqgDxIHhusJgdJlrBnlvfNTyqyoEVe2yKmMWuu/R5vAbZd24GxnlZR63WAUrlk9ZAuJSEzVolvV8WzMJm7DUnqnF1v/6v7M4jOabKLw1lpRhOUHCh20drIr+IbMgUryHIcGM3u7Gcs/um0GOPUc4uOkoRRY2D6cja0lLB/GYy86j7VRYQwQ869QhIW9kGLEINQ4MdFpoRtBQii2JLUOoTxzvhvIeNgWQqtvB8CBcDLNJJ/66R1SLSUHmjySBjnv5Uy79gyXfGShWbAi8iG0CS2yI17F0Ddw==
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
 mm/kstackwatch/kernel.c | 55 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 54 insertions(+), 1 deletion(-)

diff --git a/mm/kstackwatch/kernel.c b/mm/kstackwatch/kernel.c
index 4a06ddadd9c7..11aa06908ff1 100644
--- a/mm/kstackwatch/kernel.c
+++ b/mm/kstackwatch/kernel.c
@@ -13,6 +13,43 @@
 static struct ksw_config *ksw_config;
 static atomic_t config_file_busy = ATOMIC_INIT(0);
 
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
@@ -126,6 +163,9 @@ static ssize_t kstackwatch_proc_write(struct file *file,
 	if (copy_from_user(input, buffer, count))
 		return -EFAULT;
 
+	if (watching_active)
+		ksw_stop_watching();
+
 	input[count] = '\0';
 	strim(input);
 
@@ -140,12 +180,22 @@ static ssize_t kstackwatch_proc_write(struct file *file,
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
 
 static int kstackwatch_proc_show(struct seq_file *m, void *v)
 {
-	seq_printf(m, "%s\n", ksw_config->user_input);
+	if (watching_active)
+		seq_printf(m, "%s\n", ksw_config->user_input);
+	else
+		seq_puts(m, "not watching\n");
+
 	return 0;
 }
 
@@ -193,6 +243,9 @@ static int __init kstackwatch_init(void)
 
 static void __exit kstackwatch_exit(void)
 {
+	if (watching_active)
+		ksw_stop_watching();
+
 	remove_proc_entry("kstackwatch", NULL);
 	kfree(ksw_config->func_name);
 	kfree(ksw_config->user_input);
-- 
2.43.0


