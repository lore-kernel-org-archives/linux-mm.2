Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0E03CCD18A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 10:58:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A0298E008B; Thu,  9 Oct 2025 06:58:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 572DB8E0002; Thu,  9 Oct 2025 06:58:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4622C8E008B; Thu,  9 Oct 2025 06:58:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 338BF8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:58:30 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 04D7D140829
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:58:29 +0000 (UTC)
X-FDA: 83978277180.29.F336B1C
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf01.hostedemail.com (Postfix) with ESMTP id 158B240006
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:58:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dIg9A6vB;
	spf=pass (imf01.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760007508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wSXL/rVpDaFhkpWTVL2v5h6JspYJZAfxl9VpOD0Az0s=;
	b=Q4V3lbtOnjheP5YYh2VTBApB1d+HKT89SrYcr9hkQNE81MRBZe3zP28jmuEAfuXJfvd4rL
	1wP4Ud1XfTeshJBNhwd6k6DcceOvzOwI6TRkUNPsrnJcBkE03FiKqhZb2KMfS3i0fRIt04
	RgRt2eiiqD1PEWB9/Cyw4uKZ+tjGi8M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dIg9A6vB;
	spf=pass (imf01.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760007508; a=rsa-sha256;
	cv=none;
	b=ctkHRQShMSmj0Tx7CQc6L1dydahUx1aU2A4ND8WwdRsA3a3S8asnjcuP4NX9eQyLQBoYSD
	hrFIRA7mCYzOZwM+LcwQOmsHo3nmjqYT6OswrjJW7bnT0SliF0YaONVlFZGg5y5h4121DV
	b/fofpK9KpHfOMpGDGyNAlXQUPQ17yo=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7835321bc98so826714b3a.2
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 03:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760007507; x=1760612307; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wSXL/rVpDaFhkpWTVL2v5h6JspYJZAfxl9VpOD0Az0s=;
        b=dIg9A6vBVjdMQ4AsyAQJFuNBWin3evTkq6bgrBDmZSVg7rqiVf+97RKIj7SydASWQr
         Hvay+mjRiUR0+yeKKzPH+EgLpJ8qc31kZhOSLP7Aze+IiFuCDHtkNfJVuQFMZQqc9J6A
         EypcP0ljO1JZ5xeK+mE8kKklx/OxKDAZ/fTrGlFxpvqmNs7bymiB295hym5pweuMQOXV
         +fXIk8nkMUw1oW2a3AhiJVXKaOCRBPmI1XyvTrlSvKGjCNlN4D/0SlC/qhyhG6850ZVV
         86QUyZfecjgQ1rDH/BajooSkts5ryQTonbQ/tviVuc3dThLThzIQHwwIZAIVxerJtJ1h
         rBEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760007507; x=1760612307;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wSXL/rVpDaFhkpWTVL2v5h6JspYJZAfxl9VpOD0Az0s=;
        b=G5qCN4IyxBh9V2RtqsJF3QSROK/qbASp46zUlHmeuc8FrNzjx1C7uEzuTQQfbZGzNH
         HfqHXuzpF4K0mDTNTHgmO7ctmBDMB/FZD99unbP7riiBfiJdGK7YamDdw7sD0nudoccR
         FEhhKM+ZJGs/ZNtn/UtAf/uqmreisWs4KlGTH5zkRJvET20EnwStLguOX3o5eKlkOvVH
         Xhb6We47veR6lxHSlSIZlWwMssLyPHierNQaSVLLFZyeo4f9aVEguGseVyk5nFsgFVBM
         z8xbmq4ifNmY0fnmfJ9QnrUbGrhfch3OzLKvjRv4ewGeLed9DOWPARk1crNY/iRxxXMS
         6asQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+qcx0XyLC/VZujsyHP0a5AmoiS88bMeNF+9io7aeF/rl4XglAZoVdjUtdf98thPUTzpdpkQjmXQ==@kvack.org
X-Gm-Message-State: AOJu0YxwvcDMMquUnqfleefg1KpE7O1IyMjDHUCaQK5LSCbeUF/vfIoi
	iMcYORL+RJuey/7Hd4pP7XW96xZ5vWlWH6+MMqthcbTZyWi/idsDuF5u
X-Gm-Gg: ASbGncvWDAkMHwzCsL/GZ//HNzPCZtcK6JPsQVNN/y3zaOl2OoRnmwwR4WDqlAdBdlB
	FS6VVzxuTQceLwCjxUkNTLahVw9v3ZRjKDVoVYOHohMacoHZW3ek/yDHIXzgNGA8rbhM8ftBJwy
	gqFKLE//DrsHWwHXfAPjhW89t0YbKcuQrYCfzHo/3z4ZUBt54BFiVjZeTQE2ynsPgICAXahzTiw
	FEem0jfWddQXqu5RuKquxDpDsTn26T51kOPNUx65wb0T2+t8q9YgIJmidImDGLhlLJNWghA4a/R
	xoNTrqeCEzzPELFCcp6xKEOQVOfv6H2vY12GWr0VJhSUec48IVaytvY0TkUZRtjuX1lAteVBeLA
	4a1oy5ya4hXZknIlvNsN55ft5ojZK+BseEfef+bATJS9EKRbtGnKpZYfCzdrZpdGIkFS7jyo=
X-Google-Smtp-Source: AGHT+IEdrtfCBaVdX++NMR8obZ+j2Zp5QYbbuUxxVIgukGMBBMP9I58AXgffN8wHP6MoAs7w2yTpFA==
X-Received: by 2002:a05:6a21:6d9d:b0:2b3:4f2a:d2e9 with SMTP id adf61e73a8af0-32da813936fmr7303953637.9.1760007506754;
        Thu, 09 Oct 2025 03:58:26 -0700 (PDT)
Received: from localhost ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-794e33efe73sm2503138b3a.73.2025.10.09.03.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 03:58:26 -0700 (PDT)
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
Subject: [PATCH v7 20/23] mm/ksw: add multi-thread corruption test cases
Date: Thu,  9 Oct 2025 18:55:56 +0800
Message-ID: <20251009105650.168917-21-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251009105650.168917-1-wangjinchao600@gmail.com>
References: <20251009105650.168917-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rfodt63x6ctpynt16dyrwkbrjba8koke
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 158B240006
X-HE-Tag: 1760007507-321442
X-HE-Meta: U2FsdGVkX19Vnej8j1cgiHl5ZjEuz2GKHlRKPi2MiBMn8+nzxCqkUkgvRsYuq30URUEh3LjBTHIBG3oLqYfAJpJyxt5xlbh/0Dc8M0HNLqVBxu/xiVW5fnvydWg9EKoSL4dzSAnQEVKpADW7sRNQVCX8AQakzMioewbJh8kq4ARwdWn8VnokI1Rkw8SjlRbH1cGIOOmOgBk8Ep2/ODC2j3Xx0yc9+kK+LcF18PNZX7t3HOvLROh2sF0r538Ir6fPszomxrdnIvTa+x70jn4AHTwy/pR49WDTQYirBNdoX7b8tysqrkVpLN+CrL9SVChF1baFl89SNlAiRlOlW9JwQdTUBbQ9WAZtQfLvoWKAiY7V8U2Q5c0rn+kpTBxF7xMDEOMx8/zVESpB3S2a8xHDtZ3R18/Fmj5zbcU+x6kITg67WcxGO7P4lgguWxlbcJoMzJZsuqZQ3MFVz03hNelk6rMxOV21ciRpHbcuopOHV4lV1J3k1e7vey6b+i0XqEk7fsmwttYdzMCbdO+H6gXp3qsOEITavaf4moPSPRnx+HTugRd1rfvYEGqNnKFkAEM2Zr2MmZakSbKcyaH6wdCNESigsdMvSZfi3vPX1zWbSSc/szeQRqiAKjslrEr+0JCmWggKWIDyWKULFANvg3kx2irXrNAnmMjuqi0Cu1e/zPsdPPlE686bDANAPdIhIUFmb3GiTXQSePygoeGWi1liGRH00Gu3A1gZxdhu7YTh9zAJ8Y2upLObl6v1n4aFwBm8jSu+2KZluUHnlK5tzyzaub3sn9S8joiydLXZY8aMCmZfnn5+ixrCZDpDB1Kl8rdoBxLJnMZZSVLhzX09YvjyDSpAlBfGZMqzY32RtybJ7yl2t1NcWY2IPACQP7lyGtLTvApDKx2XNp1Eahl3v/ppz/ZZWH9esHQTimrygrLOOBdt+kOxwhFPZMzBLK3aC0LsI2SZRBZYymv0t46uEE+
 +K2xpubM
 cieXEFHHzHVFAb9XZXzC262AaqygApH5FZPy5ymXwoT3QyLquItRfxPSMsOJwLKmwO1UJEjET5+dXSBa3VuUNp+YxvjRVhWU3HVM0WfOqPqsXZSfa1stK3oN8f2npHdkbN0IqXNFiNB+EHRmMMBTgYKl3xHtNyDHds1nKFBXqTo5GfWPqdDUqZ9FACwXtgwOS5WTgu3ET99l4+C7IXf9tVMvJcNUXxXvxgNf1HVq0RWCDgqdd3iERVlJwufEvNY37+HZWnYF97TcLo+d7vHUZtkNCKxUQGwiKABGtmJgRdXp60HTj4Y9i1eBz7LnZ0JJf4qFoWjRaniq+8QsXKGFlRy6myAYIqM20yHLcrrH0hBcwKGX3o8KOq0gzaIrQbsMPyB8sOu0tzZJ0VUCdwDZT0zEJLIHTKzzcyQ4NM6GLZHZVboaYf1u79pvu6liNXwh3o0Hit4xX/A/0gD4th6bnzI1cWeAO8YoVVQBxf8iB6wzCrqRJ9EmibAKuOoU3MDi7NxLrgyFk+8/qKcgXhE17zUYAaP9jg2gE5BYbJzoJFVxZ0749JUarki0CNA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These tests share a common structure and are grouped together.

- buggy():
  exposes the stack address to corrupting(); may omit waiting
- corrupting():
  reads the exposed pointer and modifies memory;
  if buggy() omits waiting, victim()'s buffer is corrupted
- victim():
  initializes a local buffer and later verifies it;
  reports an error if the buffer was unexpectedly modified

buggy() and victim() run in worker() thread, with similar stack frame sizes
to simplify testing. By adjusting fence_size in corrupting(), the test can
trigger either silent corruption or overflow across threads.

- Test 3: one worker, 20 loops, silent corruption
- Test 4: 20 workers, one loop each, silent corruption
- Test 5: one worker, one loop, overflow corruption

Test 4 also exercises multiple watchpoint instances.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/test.c | 186 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 185 insertions(+), 1 deletion(-)

diff --git a/mm/kstackwatch/test.c b/mm/kstackwatch/test.c
index 203fff4bec92..2952efcc7738 100644
--- a/mm/kstackwatch/test.c
+++ b/mm/kstackwatch/test.c
@@ -20,6 +20,20 @@ static struct dentry *test_file;
 #define BUFFER_SIZE 32
 #define MAX_DEPTH 6
 
+struct work_node {
+	ulong *ptr;
+	u64 start_ns;
+	struct completion done;
+	struct list_head list;
+};
+
+static DECLARE_COMPLETION(work_res);
+static DEFINE_MUTEX(work_mutex);
+static LIST_HEAD(work_list);
+
+static int global_fence_size;
+static int global_loop_count;
+
 static void test_watch_fire(void)
 {
 	u64 buffer[BUFFER_SIZE] = { 0 };
@@ -62,6 +76,164 @@ static void test_recursive_depth(int depth)
 	pr_info("exit of %s depth:%d\n", __func__, depth);
 }
 
+static struct work_node *test_mthread_buggy(int thread_id, int seq_id)
+{
+	ulong buf[BUFFER_SIZE];
+	struct work_node *node;
+	bool trigger;
+
+	node = kmalloc(sizeof(*node), GFP_KERNEL);
+	if (!node)
+		return NULL;
+
+	init_completion(&node->done);
+	node->ptr = buf;
+	node->start_ns = ktime_get_ns();
+	mutex_lock(&work_mutex);
+	list_add(&node->list, &work_list);
+	mutex_unlock(&work_mutex);
+	complete(&work_res);
+
+	trigger = (get_random_u32() % 100) < 10;
+	if (trigger)
+		return node; /* let the caller handle cleanup */
+
+	wait_for_completion(&node->done);
+	kfree(node);
+	return NULL;
+}
+
+#define CORRUPTING_MINIOR_WAIT_NS (100000)
+#define VICTIM_MINIOR_WAIT_NS (300000)
+
+static inline void silent_wait_us(u64 start_ns, u64 min_wait_us)
+{
+	u64 diff_ns, remain_us;
+
+	diff_ns = ktime_get_ns() - start_ns;
+	if (diff_ns < min_wait_us * 1000ULL) {
+		remain_us = min_wait_us - (diff_ns >> 10);
+		usleep_range(remain_us, remain_us + 200);
+	}
+}
+
+static void test_mthread_victim(int thread_id, int seq_id, u64 start_ns)
+{
+	ulong buf[BUFFER_SIZE];
+
+	for (int j = 0; j < BUFFER_SIZE; j++)
+		buf[j] = 0xdeadbeef + seq_id;
+	if (start_ns)
+		silent_wait_us(start_ns, VICTIM_MINIOR_WAIT_NS);
+
+	for (int j = 0; j < BUFFER_SIZE; j++) {
+		if (buf[j] != (0xdeadbeef + seq_id)) {
+			pr_warn("victim[%d][%d]: unhappy buf[%d]=0x%lx\n",
+				thread_id, seq_id, j, buf[j]);
+			return;
+		}
+	}
+
+	pr_info("victim[%d][%d]: happy\n", thread_id, seq_id);
+}
+
+static int test_mthread_corrupting(void *data)
+{
+	struct work_node *node;
+	int fence_size;
+
+	while (!kthread_should_stop()) {
+		if (!wait_for_completion_timeout(&work_res, HZ))
+			continue;
+		while (true) {
+			mutex_lock(&work_mutex);
+			node = list_first_entry_or_null(&work_list,
+							struct work_node, list);
+			if (node)
+				list_del(&node->list);
+			mutex_unlock(&work_mutex);
+
+			if (!node)
+				break; /* no more nodes, exit inner loop */
+			silent_wait_us(node->start_ns,
+				       CORRUPTING_MINIOR_WAIT_NS);
+
+			fence_size = READ_ONCE(global_fence_size);
+			for (int i = fence_size; i < BUFFER_SIZE - fence_size;
+			     i++)
+				node->ptr[i] = 0xabcdabcd;
+
+			complete(&node->done);
+		}
+	}
+
+	return 0;
+}
+
+static int test_mthread_worker(void *data)
+{
+	int thread_id = (long)data;
+	int loop_count;
+	struct work_node *node;
+
+	loop_count = READ_ONCE(global_loop_count);
+
+	for (int i = 0; i < loop_count; i++) {
+		node = test_mthread_buggy(thread_id, i);
+
+		if (node)
+			test_mthread_victim(thread_id, i, node->start_ns);
+		else
+			test_mthread_victim(thread_id, i, 0);
+		if (node) {
+			wait_for_completion(&node->done);
+			kfree(node);
+		}
+	}
+	return 0;
+}
+
+static void test_mthread_case(int num_workers, int loop_count, int fence_size)
+{
+	static struct task_struct *corrupting;
+	static struct task_struct **workers;
+
+	WRITE_ONCE(global_loop_count, loop_count);
+	WRITE_ONCE(global_fence_size, fence_size);
+
+	init_completion(&work_res);
+	workers = kmalloc_array(num_workers, sizeof(void *), GFP_KERNEL);
+	memset(workers, 0, sizeof(struct task_struct *) * num_workers);
+
+	corrupting = kthread_run(test_mthread_corrupting, NULL, "corrupting");
+	if (IS_ERR(corrupting)) {
+		pr_err("failed to create corrupting thread\n");
+		return;
+	}
+
+	for (ulong i = 0; i < num_workers; i++) {
+		workers[i] = kthread_run(test_mthread_worker, (void *)i,
+					 "worker_%ld", i);
+		if (IS_ERR(workers[i])) {
+			pr_err("failto create worker thread %ld", i);
+			workers[i] = NULL;
+		}
+	}
+
+	for (ulong i = 0; i < num_workers; i++) {
+		if (workers[i] && workers[i]->__state != TASK_DEAD) {
+			usleep_range(1000, 2000);
+			i--;
+		}
+	}
+	kfree(workers);
+
+	if (corrupting && !IS_ERR(corrupting)) {
+		kthread_stop(corrupting);
+		corrupting = NULL;
+	}
+}
+
 static ssize_t test_dbgfs_write(struct file *file, const char __user *buffer,
 				size_t count, loff_t *pos)
 {
@@ -90,6 +262,15 @@ static ssize_t test_dbgfs_write(struct file *file, const char __user *buffer,
 		case 2:
 			test_recursive_depth(0);
 			break;
+		case 3:
+			test_mthread_case(1, 20, BUFFER_SIZE / 4);
+			break;
+		case 4:
+			test_mthread_case(20, 1, BUFFER_SIZE / 4);
+			break;
+		case 5:
+			test_mthread_case(1, 1, -3);
+			break;
 		default:
 			pr_err("Unknown test number %d\n", test_num);
 			return -EINVAL;
@@ -112,7 +293,10 @@ static ssize_t test_dbgfs_read(struct file *file, char __user *buffer,
 		"echo test{i} > /sys/kernel/debug/kstackwatch/test\n"
 		" test0 - test watch fire\n"
 		" test1 - test canary overflow\n"
-		" test2 - test recursive func\n";
+		" test2 - test recursive func\n"
+		" test3 - test silent corruption\n"
+		" test4 - test multiple silent corruption\n"
+		" test5 - test prologue corruption\n";
 
 	return simple_read_from_buffer(buffer, count, ppos, usage,
 				       strlen(usage));
-- 
2.43.0


