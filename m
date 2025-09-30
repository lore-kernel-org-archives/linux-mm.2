Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A75B4CAC5B0
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 02:46:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F31E8E000B; Mon, 29 Sep 2025 22:46:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AB288E0002; Mon, 29 Sep 2025 22:46:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E87C48E000B; Mon, 29 Sep 2025 22:46:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D43C48E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:46:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A063511A2BF
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:46:01 +0000 (UTC)
X-FDA: 83944376922.27.42FDE8C
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf30.hostedemail.com (Postfix) with ESMTP id A5EAC80011
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:45:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FgdbIue3;
	spf=pass (imf30.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759200359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wSXL/rVpDaFhkpWTVL2v5h6JspYJZAfxl9VpOD0Az0s=;
	b=wyHmFFTaUuVfgWSTH4o1e49v3Yag9UGcSUsLLzr+HF4h39x8Ni07lMhrYYt7C2VrkBTmFd
	UjbTOX210n8g51lxaRznQ+DiU1HaxOZEkOGHyfe3ns1LARAat8UUNLIqFvPyp+tluU/eEz
	ke4Nfva64dE3O3PsXNl9lBhZV26N5+A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759200359; a=rsa-sha256;
	cv=none;
	b=dkNBehVF4+XoT8CFugDwOOB/Gm2/X8ACmj+sn6uUBFtGI0IY+6zVXXfX4WXWk86A1bLiXb
	dsoSS2RQ3UtOpo3VGSlzD2BGTku5zoWQNekiQwDXxH1XkI77bds1YEAxmqEVUdmb6n4w8Z
	VC0vHUKkX3GdwAT7176A28kDGWtmmHU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FgdbIue3;
	spf=pass (imf30.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-279e2554b6fso43218115ad.2
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 19:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759200358; x=1759805158; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wSXL/rVpDaFhkpWTVL2v5h6JspYJZAfxl9VpOD0Az0s=;
        b=FgdbIue3r40b2QQUFGfX0SS/3Hb7QnvpS7XH0Jo8H16ZGs3oAQ8oO3v/PrzdTqchr+
         V3rX/y8NwRxRR4Y9IH01frgCLMdUNfjp+I4HLdFFa5OIJNX89YBbdnw3VWxPvQiom20N
         aKoTZpK6tD8/ioxs5LDQ46HFCahBnf0CqoBg5SRhJxzmGWqFBf+RDFTYa81Co3OSexdV
         xOAKkVLF1YkXHh6aFcYMzpqvL8pNFWtyfPsAyuHe8x6+ajVgosN2jU0Pned1lSbA3GRh
         fk2L42DUtTEzNFX/W2GgQvyJfvMH00FksqGo9WAlqpNMtXtI+0VtsOW1uMZuws60S0Cd
         n7JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759200358; x=1759805158;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wSXL/rVpDaFhkpWTVL2v5h6JspYJZAfxl9VpOD0Az0s=;
        b=moqACvfkuy1W6kaEMA9cb3astymEl47yk6R2t2XElmn1Kw66mdTQNz1bnp4qMBsBBy
         uNWlI00oxX0X8GEQGg3Afi/7ii6KWzrXcxTrUeEgYZeeWa+T6jW1jvabso8CJdZ1CGu/
         bl9UL5xziGTMoKlYBLaKLyzLnBafSsEafj+sut/bv2BhkjGrGRKG0BMVconePjIJjaky
         3DzSaX95y2J3TTWpWd4LZN1RwfMvXnsIDSe/12PW+hBmWwIThv2n4lmrVZ0Ypu9gEeoO
         6WGyQW676MH1hkpCksuhrxF0Ge0WqUo9uxo/oPiHun9TIy2rmeF0hy0cCRntGo+E1Uji
         twkQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYbFsiPlqLjD05ynpoRe4ich2W0eS7aQtg/mBh/1IiucCWTI3k7FXkudJfXHjetZNC4i6o1D/TWQ==@kvack.org
X-Gm-Message-State: AOJu0YxcxkkFPNPNREH79hhZJMOO9l/lJiWR0LacVYr+UrPEU3DdYcRG
	Ir+a0D4wjno4G1v0NoHhUw2gyh+S0x7OBw8BA1u1P6yLQNn2MATvlAWn
X-Gm-Gg: ASbGnct6Wu4DmbV9hHPcT4LHuvtt55K5gmtC1P1X3rsUfFoKiq6aer99drQZPrD9tj6
	6ETEIxMvDqHevEOvFiBHuzRQ02BttC/qT4jQt10JqPqYvO4K+Cv9KN5lpLorihdghuJBqSDs5dg
	0KTpmxPHcfBFjVi0HNaI9sTGmlKq2dxW1w08RLNsJnTVLiKK4poecTLIKDhlfu80aWc3qnurZcq
	bmmL2v+FSS/bwWMzvbNK+ZhWVaYshKYhuWXAk6goaA/rinNb/1maaJLVHAXjLXKIWnK8mjZAhkM
	jntScuwE4T5YbY8KPX/83RWuRK3gkmao99B6yLV4T9g/o3mgB1bMBT0s2J448I7nkAGzt+yMyZ1
	tK/Yz436K2vAx5IHoDKInu8tfVuQ3LzEsdl5e5QVNS3dH0MAHvjtO+1JkqWVHYJm2Hg==
X-Google-Smtp-Source: AGHT+IH6gM/KNPy+EKuwDpqrsR2PCtVeobdVuJ/I6iYU/PVMeQcdMhYmE/6vu80Fhzh9wbuUwcXL7Q==
X-Received: by 2002:a17:903:19f0:b0:26c:e270:6dad with SMTP id d9443c01a7336-27ed4ae51c6mr173137795ad.60.1759200358349;
        Mon, 29 Sep 2025 19:45:58 -0700 (PDT)
Received: from localhost ([45.142.167.196])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed69ba58csm144532905ad.121.2025.09.29.19.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 19:45:57 -0700 (PDT)
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
Subject: [PATCH v6 20/23] mm/ksw: add multi-thread corruption test cases
Date: Tue, 30 Sep 2025 10:43:41 +0800
Message-ID: <20250930024402.1043776-21-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250930024402.1043776-1-wangjinchao600@gmail.com>
References: <20250930024402.1043776-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ocn4ihxmu1fq7wd6icygqabkwamcarfo
X-Rspamd-Queue-Id: A5EAC80011
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759200359-77156
X-HE-Meta: U2FsdGVkX19BIkZkkSZLRP/n/7s9/1wc3t3mPfZIfURXFOk+iso6WWT8NH/J4jCSloT3ee9ss7GM4mhvVevuTiFWuFWn47WYZ/Nsmbaj6Kt2/SuBnGfUYrCQUyK8w3DHZiXQo8UWs4doYiGxNspGWZ6v/mGpiD2XeQtoIswf/ghX5X9nkJAx4AaCU4RWoCIuUB1Ot7hMUX/j10Nry6iojt/R1Pl4FfX1iGPsqH5NJl+nydh95WiAc2mx6D143wABXzK0V3+1TxhR9d3+YYWOXieZh/pvvYEy+dboLHBnKI0w3etbe1KwTMA7eqIl4bGPEOT5mU/CUJUtb6PI2YBn6LeRs17Zs4JjmAqgirFxNEkkY0VKIzQPqxSlN5oi7lBwE5/j2vazkGkh0S0qnq2EkawZzKoOoLA2jBbxekt38qkPsVgQYqIQ+dJqfcCCJS5SbZ7V2Jhgelab11KVjx2YsMHl51wvDAffkzOA+r2FYJALUgP62d05WSlhMkEwpuWUGMopO8ufRGLTngrDPr4dq2H2S7/vzd3e4PvEN8ytVc2OnLRNJxF97hQlC3ZswPEywrNsD7zzRMCzPXaIkJb7A5noJDmXP4nZoLSGn60YGJRBVN4S78BQpmyP57w8HE9r3paMQet6fFEQbbN7/T3yvoQgQfmCvH3Lyy9SWFRE+Z75f97h0+R81Gg3xWCvmHVItH430BKnZj4/o573h9l6B//4YR8l+Y6X8EE3guWuXVboDktWD+lgjcJvqlQTuAd6AwJQHJLtdwRXUVVBJuwYfxjMHdeacJO/teFipPBxLnh8DOJX8ktFCwp47FEZaqhKGGvTZQVW1imCzorAC0f94Do6HnMw4nCAFV7UBbMV1R3Hp3zXeK8Q4ds6symZAS6GTbSkpbhr/wi7yl3FM13viN1bB+pO5EH8mVA0XSMvvTfqZcvfwZX/8vBvXZcdDvOIlbOrpmTCstQVlOWCXDO
 KjW0L75m
 8EQTppO9RRSHKZbarf4k2HeOYyuvdUDUfcpQzMYxM/ia4+zQZsViQQ1MkeEAw8OvUkrHzP/3IQj5EOuvkv4B74OhljnElEZvBC5ydSCfJpu2GK8rVFvQhqZvQwKD0KaBhl3zrp2jBCknvvkQ8+H1Oww8JmFNtLj/oEHyXFft6N52aHvli8BascuTdUJnEQPEPvTIXoTB9VaDbxpE/GeF5QVF7tI4+Y2AaabukwOoxqDC0oaYqGCjfRpCMmy88EE21oZTPTbIiHglhpfBFsYYz8n1tYf58JPabfgTHIYZYb3vyDcAKHA20espcStuvSJ9w2klJQ2Ao4ut0u+Y4fiiR20A+WoSpHLNI+Cvv0lAH30uALFOd8QFfE6Lz1BjztAlAILqNITRtIdAM9gFAJ+9tYGZ/sozyXf+kCXWQy+xmMhDiLcTaLyTGgsoEfJgoD25ds/7QLbgs5nG7Y6fq5VVjnTyg3NAK7Eus7X6LfOzEfdrzI03zkIWLHsBCfrDISc+hrlRwtpqmb3/tB/4Kb6rU805bcuLq4KBl0iHSpgHnQXh68QHgN+O8wYyT1w==
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


