Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C655DCAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 12:00:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 254888E001E; Wed, 24 Sep 2025 08:00:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22C608E0001; Wed, 24 Sep 2025 08:00:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11AD98E001E; Wed, 24 Sep 2025 08:00:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F35008E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:00:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AF34113BC23
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:00:43 +0000 (UTC)
X-FDA: 83924001966.02.BE20F35
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf25.hostedemail.com (Postfix) with ESMTP id BAF6BA0003
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:00:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Tk3fFblP;
	spf=pass (imf25.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758715241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1NT8+IPFZig8CTJZJveFgxRKV2ZOTWE6XU6N/gZkl8A=;
	b=DcN09zzJT1DR9bH0/M0eldQYgBnASh9DxC35s/kHzVHk6XqMJhXMkD+Csh4jOTsp3AnFCi
	Aq2Ol0DxUzLnOUmrHOi5UBIr3pkUeokMxoy8IHYzoTSI1VoVkG5WG2Z93xJk3Q0tp5A8zO
	8ypxQQAoA5n4FkYY0r3pYlciLpEXVgc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Tk3fFblP;
	spf=pass (imf25.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758715241; a=rsa-sha256;
	cv=none;
	b=V1AkSgAxWjIkn8lqMikLAe1Z+vWCLKx2hQj9NW9p6LJRzG8EiSdipLKUhQcz/ARxzzMx0R
	WqeXqZ52jxoQm7Na5qqXiI5Xyu2SXm1/+haxC8lNbsqXwpNJoa0FD4ABkwxJD5iUuO+LYJ
	ytI+RE+kfZnrOR87Ad1NTExPQExlUac=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b557367479eso826241a12.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758715240; x=1759320040; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1NT8+IPFZig8CTJZJveFgxRKV2ZOTWE6XU6N/gZkl8A=;
        b=Tk3fFblPHSW+97c8j59H2n/MfU6dsp7WoKGgcXRQTNC8qCRdZ+BCwe4JQ64OS0mg0Z
         rt7u4oStavdYdi8an0qObmXOuS2Aah86XaHj53hKrR6rNU/Gfo6WPxib7k9eKUcfamsA
         2Yr4cJjFxF9FgMYuKaIvaGJ4ji4Zo+ts/lcL/YdzVKB2x94PtXcZYhWSI4ynSHIH4VqY
         U7E7Ah6y6NBa2Hdew0KQD2YUHXtW/bi60Cl1YNIhEiXkXh9yok4pczAm8v+jMggE6gWD
         5c/XLdp8QB/O92sr+vrcCkH87oE9wS6dKNUpHasd3P0jnoMmecf+f6BAW1G1jO/aDL3Q
         iqfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758715240; x=1759320040;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1NT8+IPFZig8CTJZJveFgxRKV2ZOTWE6XU6N/gZkl8A=;
        b=sFbNoPCe3mV3uiuqJ2Q4jeaI0AhDWrPaN7hFdFY+ywnXuGwnJIMk9O8zgeNWxRIieJ
         WgMNfNLGYAng2o9n9Zn4d4js4taXSUsi0fXiRrH+J5olXsHWB1kuk/bIPD/F0RuiQDAV
         b6U77MvoMopB7pZflS/6QdBmOBlFTWtWLWnB/9rwydWlyvX3Q+jKKqVLM7M8Jqd+xU4B
         muY1ub4EY1h3DcoqljiYMrFy2uhnExa1kpzxhU622wx1JZ/FJrCBHorgwxsR62KwranG
         4PRtMJ0sGKLvBK2BkGLVJRe1ovJRyDKSiRsMvAViPv6Y6ONO+t9H6q4rQBvAtJ5BgHPO
         WTBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKlGO1M4JvxXlAaiGB7glA8mJusvlarcLERfUg2Ied5qB2tHtMkQjZGwbgk+EdEG405o900B986g==@kvack.org
X-Gm-Message-State: AOJu0YxyScMAXyFsd0vg0jjaT1nxGk8sfr603uNCqnr5snHW+yIc206w
	kVzHbOTG5tA6yQ++Z52MvcLwXYHTlXhTBKZ0iA92fc7YqPb2SgQSFa0m
X-Gm-Gg: ASbGncsvYjrylsACZx5VCfPZSjzb7VN9uuisiDAkx9oboo4bkkXEJwYuLu3Ei/cqs+N
	eACCDt5JTyI7xjVZvHUmoPX5aCkZL/wFoJhW6v8XsGnO2BKbR9CdF1iq7KreBaxdYPKL0t01Gb3
	yS0slSo3NMH/Yc08Tk5pBBJF2no8g/oTtyM7SJR1+s2MonYjpvG6ArgPwWIftugKjN9KWk/iwLN
	fR28jDbKfb9gIxE2lwmxHuOgkUOGi576Gf9fridzdkOWAXQVSqH7qnbK9WO+XFaMJ+moTvDNKqk
	UofrGXIAmt093gxNNS/JsK8wz4sfH3Ekj2D1PxdnpRpR7QfUhKR4wv2rL3i1ky036To95jAGgKT
	z04yBmnixAQgrAnNZwqz4Y1o=
X-Google-Smtp-Source: AGHT+IGJCq+xdBPSr2vtJBFYvbOJmXpJTBrhRvUSRvlU56ancTzpxVdVezOYXQvlboR8hlHSETgwdw==
X-Received: by 2002:a17:902:e5d0:b0:267:a231:34d0 with SMTP id d9443c01a7336-27cc5623567mr72404795ad.42.1758715239864;
        Wed, 24 Sep 2025 05:00:39 -0700 (PDT)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-269800531e8sm191473635ad.29.2025.09.24.05.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 05:00:39 -0700 (PDT)
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
Subject: [PATCH v5 20/23] mm/ksw: add multi-thread corruption test cases
Date: Wed, 24 Sep 2025 19:59:26 +0800
Message-ID: <20250924115931.197077-5-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250924115931.197077-1-wangjinchao600@gmail.com>
References: <20250924115124.194940-1-wangjinchao600@gmail.com>
 <20250924115931.197077-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BAF6BA0003
X-Stat-Signature: d138ejbt4mdr7spt1mreujy1rgpkrcrz
X-HE-Tag: 1758715241-713942
X-HE-Meta: U2FsdGVkX18PHtRpSBiJS8SbeaH2XnwbNCRzYrfq46j+7jBHmy5rf8sDvcUgyK1CPYsUirMSFalSjT7VCUAP4kXYrtXZgVOpNEGF8p5h6qAcc8hkbKk+jvAS+2EtUjm44j4kLx8uNixVDuNIaPza7xA1x+2jfIT1h21ap+ty3jCarxwuxl07tu/gah2Nz/tqzZRo5sQdlwYZxe9l/dmWbutPf5lY/8XNzXgrkPr2PG2kVgMtr0idsk+3tjiZWkCNS6nPrLwjTc5ntcaj5eCcDCysyfDMqPeCm7XlIstO1vW8rMHOnllVpgum6RY8bhwmMCGZGVC9JVBbSuMa57nuYl5QRo/WWbumDrto9mkMWsjcsLLyfcJ4gCNseTy5PfRQu3LZkvWVKGZI1qPOP/+o/NM7dT/rTM+BQAtdsxIqh8zGdoDKMKyue6Abo0KjYC7Kle0SxIS4QUcDIepPnrWsH3lUslpX+pNhGNwr/ne3uG+etrdcMEQs3dleRqryywJxFzM89PRvfYuadyylUILlbwSiCNUvBFkjPF5xBsvHZk+N3nZElbBtDDv1wjrw2zSMbxIl58SW7/vn8uur5/xh3QSyjTk43URPs1TIGQiCh4wxIb8Sr3uYEeGL/T0nTvmbJEE7cXtsxtrIkpjk/tkzS/maOL/UylBrxDp19TkDntnXN0CDOPuhqEfccTaFPRq5VsmaG4nupjfKCB9TxM5ItNSs56tZGyCJKG7cCCE04bsHXi+/WDMo7jxZBHR6Fj09wdvEuDU7CcFHuLRWk/07iP5prC9LeDAoXqpww0PJMU4PTfO/QwUCE5lP1W1vW7nsLT+26S4ErSW8T+xie/mwuZ4vSAFX0LK1T7CA4IKulgBHTUQL0RZ7ndUe8jUSEjII0F7DPYq/eXKxMgMqQlLJXaBtmfSqj8NtXTF4+h1Xyt+uuVxRXwqJCC8gkmHUP8ipY0z9Mtn8x2FEi46iVnN
 YgmUE4Lc
 W0Ng5hY+yMDVbGWuLtPbGWbkW1128lfn8VIdxLMJ7xDpeDtMgxzRhm0peS3RPFdIQm5liKXRCrBLW4cWAvnwyjrU/1jTApNN9i5raBhq9sXndWykU5M4+YJ70iW+vNIvljOaHeqB0pAl2JPqeoSxYHX5CuK/8/WtO1P22HLf1zCqqWLHoaZBTgWa0A3fbway8PWcMh5NWY3qzK5YUNtF2KyMZ0zc+Zsi5YlqyJCYxz7BrC1ySLthy7y8EhhXZurB/zUc4dvHCBDDyB1V9HyxNfQs/HlElqEZuLbh8nkP8lyeD/oJFVasU+I8xPhHoI+sl4L7Fypv2RVrG59xolzurkSYDjW4JMAwv4HBqSjdZUxX0Bt0AAYwvQMDczTxwz2JDQlfxEHt+f2JIC6+Z19HZYb5I3p6A1WlCT765jiPRKUJ3XAaWx3aK1krsfsqCrgjaP2xv4m356JJIRZ8alkz1b01p/0L0VsnU7oJPH295+qdSw3GLWZAW/0WjOJicmRKEVHwkSBWBamwFYjuryl+gXaH0U/TS/uFIeAaQVvv0IcC7nI6EtzMzghPbpg==
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
 mm/kstackwatch/test.c | 178 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 176 insertions(+), 2 deletions(-)

diff --git a/mm/kstackwatch/test.c b/mm/kstackwatch/test.c
index 08e3d37c4c04..859122bbbdeb 100644
--- a/mm/kstackwatch/test.c
+++ b/mm/kstackwatch/test.c
@@ -17,11 +17,12 @@
 
 static struct proc_dir_entry *test_proc;
 
-#define BUFFER_SIZE 16
+#define BUFFER_SIZE 32
 #define MAX_DEPTH 6
 
 struct work_node {
 	ulong *ptr;
+	u64 start_ns;
 	struct completion done;
 	struct list_head list;
 };
@@ -30,6 +31,9 @@ static DECLARE_COMPLETION(work_res);
 static DEFINE_MUTEX(work_mutex);
 static LIST_HEAD(work_list);
 
+static int global_fence_size;
+static int global_loop_count;
+
 static void test_watch_fire(void)
 {
 	u64 buffer[BUFFER_SIZE] = { 0 };
@@ -72,6 +76,164 @@ static void test_recursive_depth(int depth)
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
 static ssize_t test_proc_write(struct file *file, const char __user *buffer,
 			       size_t count, loff_t *pos)
 {
@@ -100,6 +262,15 @@ static ssize_t test_proc_write(struct file *file, const char __user *buffer,
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
@@ -121,7 +292,10 @@ static ssize_t test_proc_read(struct file *file, char __user *buffer,
 				    "echo test{i} > /proc/kstackwatch_test\n"
 				    " test0 - test watch fire\n"
 				    " test1 - test canary overflow\n"
-				    " test2 - test recursive func\n";
+				    " test2 - test recursive func\n"
+				    " test3 - test silent corruption\n"
+				    " test4 - test multiple silent corruption\n"
+				    " test5 - test prologue corruption\n";
 
 	return simple_read_from_buffer(buffer, count, pos, usage,
 				       strlen(usage));
-- 
2.43.0


