Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A34FCCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:38:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F406E8E0051; Mon, 10 Nov 2025 11:38:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF0578E0003; Mon, 10 Nov 2025 11:38:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDFDB8E0051; Mon, 10 Nov 2025 11:38:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BF39D8E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:38:32 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9713E12C2C1
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:38:32 +0000 (UTC)
X-FDA: 84095255664.21.54C75C5
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id BC0DB180013
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:38:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T5jDBYwc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762792710; a=rsa-sha256;
	cv=none;
	b=t5B6L0V3MkSm/4BL84DrG8aNxWq1jpk46+XGnNUuV9A+HEq9YIR4CrPwVlvpUjrqN4E0qi
	rgqnInrFDLshGMqLriGNPjGHLFuEJ5w4+1SMCORx2Y29SpBvdrL6rdE915c+2pZtiZwX0F
	p4jMi8x41RTxjazE9fR0mwNbdbKHc/8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T5jDBYwc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762792710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/i9Y6D84AcwkcQizXylWnD304yGUpX7AGwmA82BxIzc=;
	b=hXjnGMXJyMRquZDs3bLeIC4VnaxeFH7PvKlUPmX/0oiem4SkAYP9BUutvESCqPM9GuWJ/A
	L3uZxBY901UBp7bIBHVsVU8mEveBQFLFvKo6oi7O0I+3ZfX6tcdGecvLMy9gTeKamwaJh1
	GzefJXW/5FrXExGxORRY/x/Mq26uoD0=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-bbabfe5f2a2so251446a12.3
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:38:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762792709; x=1763397509; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/i9Y6D84AcwkcQizXylWnD304yGUpX7AGwmA82BxIzc=;
        b=T5jDBYwcR1DTGZbNc7fk1GrJV1PYaiDGq4XAxZzGZ7cpobwhGtg35n1ykDtILa7Sv9
         0qLLEivueQ2BWTy2UybOacS/qtPggdwuKMm7OsomPnrStBaw0DLn6GWdM+PBC2MsY5Z8
         KdbQ66LRUu6tr6JThZwoEmrBnoVaEqnfFTrcLMgwp+rQO/AMSgNdf4/JjboIVlA9XXme
         04R1A2ccWZW5mXtro30HWqD+5FWQHv+VeQpvhdbtdEaHoMEfFH5X0wE/ibFx4ZJCR4ES
         3Yquz7leruSbv6sSQmhJgflc8faNNHmHYJK2QLpodUQJUlhMHG+0lfqEPA0+BUkzoVeM
         cMNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762792709; x=1763397509;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/i9Y6D84AcwkcQizXylWnD304yGUpX7AGwmA82BxIzc=;
        b=OEwmRf+XPhosax1+NB15ekmLfNgHdKU8ODgT4Vk9EfHMsC0Ol/Y3dIs3RSiogVE//I
         eZNjHuqobf8As1M2M6n7b7iU35OgTY4xzX2w6md2am36F2/0oNLges0e5v6AtAbl6ks8
         lAh2wrJe8gFyWRb/8VIercfaxC7+6+jO4I+Ke0T9JjTDaBgL29nsRMVgOgzjlw+WsLb1
         pme54k9xV/FNXloOiUJqPPsGUSfiD77C/DIEBklLboV9p5YgFGi13ek73EpOgS9jfezY
         hfvZU//OS0fMVkoJF/el6aE96N1zZh7jWyeMklcnGkT+1nP2o5AoC/o7AL+U58lEQiJ8
         OVHA==
X-Forwarded-Encrypted: i=1; AJvYcCWn/ADTT4CPQuFg3ZVVsf3UiaiTieNbEt3Nwu6mgEOSubnGubzjMogVsK4iRthNGgr+GmK3HJErAA==@kvack.org
X-Gm-Message-State: AOJu0YyjRz2zyxZJmQjWRAIIOSx08H4dTplRUX7vhZNKsaLrQEyJ7WqD
	lxUFZaV17ZEbj4OwdY/zkxYQ2hhTmMBppvQbSWi0i2X5FkFRdcWtn4LI
X-Gm-Gg: ASbGnctT7MJ3yxdLNz2yp/vyomm87N4UEgYsKcnB8BXke+oHg6OJdemQMMYwCC8CeHR
	yW9DNxtrp5SJgOx3T5karEZDP2XU1e9+cMHqiPuLNl4nojpmDHNSFDBDG85MePX0YIXK9s1OD3U
	STdecMS+1tVFBQkSMnzO1es5IOGf/h+dQy07+s8qpOUKUOmRTiHqIPXJ+c12XVSwcsb/hha5r7s
	GAhr8i49s3cme6LE3bpl139r1JledtmAzXcE+9U09C6hneFYDlNGRbsKQDbjxvtceD/jvBhgphK
	MOlZ8uGARagoaAEcux/GopDqGdirOx7b5hQvM4CIxUmSzoXoVI4xpVh+rZE8vkb8j29UWX/c6F9
	cQQCC82yo5hOMofMJJk8gJVPKEvXo2+jRjjuRi8plHP5u0+fX2zFv1S8kQf3Zt9++p1/RTCV6jM
	9+8w9t3yJitc5K5L8iKbK0eA==
X-Google-Smtp-Source: AGHT+IGGLWsP+rKIukfYRL1IHqALzr1SjL54Nbxq/1zFc3pjrCTHbWmU7///o0j0mRvG3+5kbWDS4Q==
X-Received: by 2002:a17:902:da4b:b0:295:512f:5060 with SMTP id d9443c01a7336-297e540dc24mr116769525ad.7.1762792709436;
        Mon, 10 Nov 2025 08:38:29 -0800 (PST)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29651ccec04sm151070875ad.102.2025.11.10.08.38.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:38:28 -0800 (PST)
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
Subject: [PATCH v8 24/27] mm/ksw: add multi-thread corruption test cases
Date: Tue, 11 Nov 2025 00:36:19 +0800
Message-ID: <20251110163634.3686676-25-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110163634.3686676-1-wangjinchao600@gmail.com>
References: <20251110163634.3686676-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BC0DB180013
X-Rspamd-Server: rspam07
X-Stat-Signature: f6ofuc9k1f6ek5mkfqzaje8wpty9a3y4
X-Rspam-User: 
X-HE-Tag: 1762792710-804862
X-HE-Meta: U2FsdGVkX1/BGilxHa7/S+Cz2GBAxHfFurC9VmOkw0Aij2LrFcGjiMaxGizruOx92ylOQQ9yGqbgxLwv6xi+epcYsDd1qaCZXKejOZ13USHbmwPbgShtx5LI2yO4aLOvsceEG67hATtarzEGquxcTmhV3+XJsRZWQn38+jhkxwQHmwKpGyG7bhpVeaAkfwTtlgwv8KO0ghxQxzKp09oSdSBa6tcWSA4HRBMgOX54wXNw0xkUjph3HgWmG9mpEol8AWM32EbOe1smQ7Wvv1Nexm6P7CeTw7V7MCW7pOlf42btXQf2LzUbIIDR2axVGdrGvXQUDVf2JlhtxhAj/BXMLw9VGZqOXPhUYviuCnjaqMUhro8VvyY4CAXnuVVlNn+bdsGHRF9p3Px4+tdLoLx9SsAcX4ahQpo8nf5lZy1uuewfBxYckkbO9xUgcUwylAgIZ/+LCipb6H1gFZbrWxQGIyMa1InRF1bWTIrqETU1yIFT3lDOFaWXGbBsAkw/Byjg2ptyRaaNKFD7SmmHNYe7gsaVlzcpUdFnUZ7GgN3HLpLjiZi0csofAAeFicrV3CKUdpSd/D1Yhrac4yA5Tp/xgKB2Wv3QS/RT9png+Sb2lvooscWWDT2EjmCdnYe24+uPm/vVe49z6aLVF/T9nrGVfLmax5yNeL+1PIW6a4bsom28U+tDS7kOIbd54euMnr0LmS2LAICEG/IXOM/fTvgb1ksYuerD9iDpsmN0b9C44wJbgxgDdp6sON+szwjlet35IkAUyY4Dou2HmTAUuvHv74jPvE2UXvGai2kG2206XVK3fMS7UnCtTryiRcAcR9pAooyQLtbnkiYJBbx6M+jHVkw0hNoY633T/18wxxuVAM6XyIg1dF3JSNzSGbrUjOZ3/B9LEOwwoqK175JDtBCV1oe0d5uzyzDpXJIA9iVbuK9oYFAbqfMhN1peQmNjvQ+vQE678cTGCKY5cX9TcsH
 pQUAbQqr
 Nntkkoy6TaVVNvWJyU3dJyilCBpCu/N23ixe5MdjLuZ4JZaWxcszi2Cj7Lfo64sYgmbYKof6lanBe7FWsSb9efijiQLCYaWHYY/LFce2S5QB7HG+can3omQhWfk/FZ17hW4wSlBVyhsVVil0thDyJuFALQhAAOM0Fw4lFa4kI1OZtyAXfRnbiQQTbumU31cSgWuZ654WQZNa2p2mJPXKHkvfK+w8fHG5wxFemz9I32CG4L6xqjtYyT/rMe2adB6LKrWvITt7GzVnBq9R0RTSScN2ZVoS1mBNoZ6nEsuTYtUQOW+i0TSxP9abti4wCC4kvobo8VukDmBZIEoOOnJyAHoaeUObIEtYi2FWnoDzp7DK0IvSFsHQhyYhRUL4utw4RLdISwL1AMypupXBSXPGcrtamDJ/BlS9VrM1CFI4s03yqog1NubWGpESNp12CDUSkEDhkJD2WHcxJ2A+g91uVMMGOMK25OAaa1mRLuReTxPsF8jjFVGtHqRN8mIAKNdxGxw76wG78oa5tKVg5fv13lzR1ZhpclVWXHUhgbo7QUfn2VYpshE1SAktQ6Q==
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

mm/ksw: add KSTACKWATCH_PROFILING to measure probe cost

Introduce CONFIG_KSTACKWATCH_PROFILING to enable optional runtime
profiling in KStackWatch. When enabled, it records entry and exit
probe latencies (in nanoseconds and CPU cycles) and reports averaged
statistics at module exit.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/test.c | 186 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 185 insertions(+), 1 deletion(-)

diff --git a/mm/kstackwatch/test.c b/mm/kstackwatch/test.c
index 1d196f72faba..4bd0e5026fd9 100644
--- a/mm/kstackwatch/test.c
+++ b/mm/kstackwatch/test.c
@@ -19,6 +19,20 @@ static struct dentry *test_file;
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
@@ -64,6 +78,164 @@ static void test_recursive_depth(int depth)
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
@@ -92,6 +264,15 @@ static ssize_t test_dbgfs_write(struct file *file, const char __user *buffer,
 		case 2:
 			test_recursive_depth(0);
 			break;
+		case 3:
+			test_mthread_case(1, 20, BUFFER_SIZE / 4);
+			break;
+		case 4:
+			test_mthread_case(200, 1, BUFFER_SIZE / 4);
+			break;
+		case 5:
+			test_mthread_case(1, 1, -3);
+			break;
 		default:
 			pr_err("Unknown test number %d\n", test_num);
 			return -EINVAL;
@@ -114,7 +295,10 @@ static ssize_t test_dbgfs_read(struct file *file, char __user *buffer,
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


