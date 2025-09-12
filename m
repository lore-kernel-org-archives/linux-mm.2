Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A97D1CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 10:13:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DDA86B00A4; Fri, 12 Sep 2025 06:13:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08C8F8E0005; Fri, 12 Sep 2025 06:13:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E96B26B00A7; Fri, 12 Sep 2025 06:13:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D3D646B00A4
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:13:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 946ED86FC9
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:13:26 +0000 (UTC)
X-FDA: 83880186012.19.512A834
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf30.hostedemail.com (Postfix) with ESMTP id B289280006
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:13:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QUlaA7XV;
	spf=pass (imf30.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757672004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VbQZ2RA/ceP/Xd/vXrNH7xFxG1mfw2BEk3J2LPmN1HA=;
	b=1qT2SeGKWsRnE8HryVkv6+PB+jFcdzkuw5tLhbmIYu2/ledkOkBckLI32bwrCbQL0QDQaN
	qBs4SEJ1qXTvqmfGALRz8i0ceGbPIJF3h/wUrR0S9W1lG9mTwCtoQwvAkxmjSCufsrtKtk
	EblWtC2jRKJg02PLBh6b93upFBR3QLg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QUlaA7XV;
	spf=pass (imf30.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757672004; a=rsa-sha256;
	cv=none;
	b=IlwvdT2iuxzDAxGVpr73i0F7Lz7LLFT0S++YuwdjA4GbxZhF3Q2s3+ORmMFybCPZ9IrVZw
	zcLrVEw4XA6J+LaTDpSbfdFXNU7Okb+bT7Vg7XrlHjxcvEb4mGpREmi43TdkqeOCEKgXXV
	73S+eX6yKZkUpe2TkI05SalgpWH9eSQ=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-32d9086276eso1731079a91.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757672003; x=1758276803; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VbQZ2RA/ceP/Xd/vXrNH7xFxG1mfw2BEk3J2LPmN1HA=;
        b=QUlaA7XVYoGPFog+v3/W8iqG5kh+AdGvgaT+468Bs1zZ9ScjJsJ9t8wNs0hkbxUMj5
         nnURAs++fmfgJbqPmCyoYzajcOi+wmUsaRWVTG1U3OiUH7uaJUBsWTFIKhs1xJkLP9aM
         RAw2Nos8vCU2/eJQ7Ml87OFTLzOu5P1lMJ/8Q89xqLetgLwFYhF1fnUZGww6K4WDDsma
         dvRkq/j4nOE7Z+2mOQZleMIO0vimPxDGfg9ayxecci2uQudPqGVzd+lahrc7r8DCpHhN
         /evwvvxp+Q1r/kC8Z8MUvnHc0S2v7FeGpoA6RZxB7LnhSY/o+DbBqqUYEosWXDRBCjTz
         1Mdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757672004; x=1758276804;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VbQZ2RA/ceP/Xd/vXrNH7xFxG1mfw2BEk3J2LPmN1HA=;
        b=IT+qDlc/DiI6Sj29nLoyPHdi9YmUJXGmPderbF8/769eQ6CInGaGDe99Z03eZXtyng
         3tlzRQCV/OtO8lAQSYcHMhJyq6LQEipXb9oFgkPqfONxgzkVNleqFg9CONmlo+kJSlL7
         ouOlG037Ewx3GnVLZKzNx4ineHidP//TtcxBkEGKaZjQwlBE4h80RwCG0Iqig1cRk/ry
         CAjDh9AV+JSGZ8MALyVWd5SNYzPe3eBBgDTR1QN2hMCndW3jTuF5PBHxfSYWCeLeZS6n
         rqCmWZ9kLvJFDsUArrLawGhvvPCP6cjcAE35F6GirujGnjU6KHv2NYnL9JiA+mleOAUd
         WKyw==
X-Forwarded-Encrypted: i=1; AJvYcCWKnQ8ZX6WDPIQBBTwhT5cAVK3y0RGNsZ2nbk4AHmQIO/wvb3Zl+l/c0dKHBfjo05G++dzOdRIlLA==@kvack.org
X-Gm-Message-State: AOJu0YxixsyFEZtKSlU/ILMJt2xEqODNdFVhtQ+IcIrkj4C3yMqHBNnn
	k+oHyxtuz5jlg+/kgke3Uveq3zIK72S02fS6cv4EGwBKCKex1JIj1Snc
X-Gm-Gg: ASbGncvG0kfYuShhVU40MvezfJeH+/xPzGQm+LmWheH5QCwd39P/KQM67ITDgxZiJHj
	v4ia4T0Wsiha3jLHnUrTqMnGQg5ccskZVRKAxD6jhYaXC0kzcp6ERKez/oAH5tCDpXSuJeQ2osM
	TIUvRWxDYxTdNvmzKWz2P5s4O1aU4PpyNB0pS6I/ILiKnlCgpCeLQsEkS7ZYh6wmRhixkp1aLMA
	LlueZIvjW2Zug8sUVSQuG+u//3oWTU71HE95l582h5sA4elPrPfBLHSn2HZY54KjEMRG3le6axw
	NgepZjnsFuf3aPc2MHflQ23qAOnhL1/dU4JR8ak6wWt+i1fTmh95koQjBfr3BlJlU2uVKQlGdjp
	3+6tNTRzo9dNrntXHCp62fAi/xVsz0mtu1j8=
X-Google-Smtp-Source: AGHT+IF25l3C1E8p5GHeNvlIVkbp0kOIYt1wPzTaRq0s8H1fBwmcnKLuf8G6T/dCuiyhKBgfSsTJeA==
X-Received: by 2002:a17:90b:2b46:b0:32d:7093:7f6b with SMTP id 98e67ed59e1d1-32de4f96188mr2888054a91.30.1757672003490;
        Fri, 12 Sep 2025 03:13:23 -0700 (PDT)
Received: from localhost ([185.49.34.62])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dd98b3ea0sm5091462a91.18.2025.09.12.03.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 03:13:22 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
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
Subject: [PATCH v4 17/21] mm/ksw: add silent corruption test case
Date: Fri, 12 Sep 2025 18:11:27 +0800
Message-ID: <20250912101145.465708-18-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912101145.465708-1-wangjinchao600@gmail.com>
References: <20250912101145.465708-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B289280006
X-Stat-Signature: fzfbgzrusdcgxxdu8e8rr846marwpppz
X-HE-Tag: 1757672004-661417
X-HE-Meta: U2FsdGVkX1/CGJ7jSK+R3YkmCa7BDu5j9JhXMZPdOKeuLP6FZ6wQZZTG2eJNS3g4qB2pl/Gz+3zDVD+j0IomdhSbcESFSCGXZ0EAbtXLBBYx1ed+YLFcX3pSNMrq4L0/rYKM67A7CgRW8VEgyR91OcSU64k6fXKc7fGaCfDeq8nWD9trRpKqzgFa2ZaUq1s6IKtLQ5Yn4PsyTVOTqKmFQV3l6Ia7gIVj/s2vuPnqrF147QMF0XLW7vrqMueKgJi5zCCbxqcpylucREG5zYS6xr/jluirUomE685YByEDR2whcyz7bNSqORn6hPZa5T7HL56sJcrSM3EmfqyhjkScUAwZ+FpDbo6MAgiCClpLPmJarI1h4zcldWVPqvMgIcz41Xkn47zrT8Q+6xMDlHQNjSUfi9Yzf7nVF7C94CZ22ISyPcdtDi4c2WVTqxjvq7qA77M07cJEYa+4ygTkponYBFxZWJa7eLAHy+oS1fRrN5R5bGnDm06+P/HRZYXVOnUxvaPRAbZwnQV0roiLXHaY/Tew+PVo/RkE+h8fxtkmTglxzN35gz8PQBq47kApyqh72JWjKZrYab8Tj8acsk4etYdynq15Sovk4F+aybrvzC3+oECvjsUIWMZ3PCE5tj75pA7+pNjA69m2v1wZHCaQG8XA1qkkWgqr9bkODmakYzubVgAPo05gY74qQxFTmcShxrPof61UhFLZsUppht6Xhivbkcit4CHKwkaYWtXmpbC0KCkWwjifuhTwD1O5jn64uSF2OFSbBHQjDdBfcINKVwBfcdo/2w2bCOFIAkMgFwlcjDgo2smJx4ysB9t70KGDJxOfx562KQMIO7WVx5NEl7FWxT3gqZWeKvVV7cLDqHgFE3ARypXzFRz3PfNYMO3D3oSO+wB13eBfDtsdrIAew0MLaZoB9Q62Dy3wnJvanoAKq9dFBLkrg9qy+hzkduA0zWtoAY5CLz2tWQgen9i
 BG2YVaSA
 evmr+CL10T8vCYZc7thahYLZsGcqeYUtqwRcoLaOK8RY84siuy7DbWSCkIhAekUQFoyXgeWR5TLbHcFxLRwgqe1T7nzozJMcyicoX+iizrjzW1LwWJ3t+NGp+beWPtUyNQpPPqXd4Sh/Wwdb3E33ZpzCekishLyKxsJOygb09N61Fbveb+31C4sRQohzTRT24WRuKteYigFfGvmoAtw69OjLMVIkk9uAQ1Spx1xX1wMNrocMG4lUYsZv9bZf0DQ/285N7mQFoAshnjJhhqclCUxuhPpYxkDKflmWVkdAo+T1bfBjEHov42wB4077QS+Aj0kitJDpw8qiORk8hcvim8C7t0r7dba9ityc3xVbJik8kP46HwgDF76oLAMSOtmZyqqpAdp2UhuyT9VQ5K7BadskGoQwqpfK3zOk66amfP2V7ZnWpmdjLPtL6dfgvGtgDjBaRENMWQE25VrADerssKN6E+ouLgQh/cmCBqTF5rg0WeZ01XWfakg5WszK7gJ4QMpC82Qy6kGaUwDduRA46KyIU8ibKfZRCNXE9q8XHZNJjk7xMuHOT032KZA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new test scenario to simulate silent stack corruption:

- silent_corruption_buggy():
  exposes a local variable address globally without resetting it.
- silent_corruption_unwitting():
  reads the exposed pointer and modifies the memory, simulating a routine
  that unknowingly writes to another stack frame.
- silent_corruption_victim():
  demonstrates the effect of silent corruption on unrelated local variables.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/test.c | 96 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 95 insertions(+), 1 deletion(-)

diff --git a/mm/kstackwatch/test.c b/mm/kstackwatch/test.c
index ab1a3f92b5e8..2b196f72ffd7 100644
--- a/mm/kstackwatch/test.c
+++ b/mm/kstackwatch/test.c
@@ -20,6 +20,9 @@ static struct proc_dir_entry *test_proc;
 #define BUFFER_SIZE 4
 #define MAX_DEPTH 6
 
+/* global variables for Silent corruption test */
+static u64 *g_corrupt_ptr;
+
 /*
  * Test Case 0: Write to the canary position directly (Canary Test)
  * use a u64 buffer array to ensure the canary will be placed
@@ -61,6 +64,92 @@ static void canary_test_overflow(void)
 	pr_info("canary overflow test completed\n");
 }
 
+static void do_something(int min_ms, int max_ms)
+{
+	u32 rand;
+
+	get_random_bytes(&rand, sizeof(rand));
+	rand = min_ms + rand % (max_ms - min_ms + 1);
+	msleep(rand);
+}
+
+static void silent_corruption_buggy(int i)
+{
+	u64 local_var;
+
+	pr_info("starting %s\n", __func__);
+
+	pr_info("%s %d local_var addr: 0x%lx\n", __func__, i,
+		(unsigned long)&local_var);
+	WRITE_ONCE(g_corrupt_ptr, &local_var);
+
+	do_something(50, 150);
+	//buggy: return without resetting g_corrupt_ptr
+}
+
+static void silent_corruption_victim(int i)
+{
+	u64 local_var;
+
+	local_var = 0xdeadbeef;
+	pr_info("starting %s %dth\n", __func__, i);
+	pr_info("%s local_var addr: 0x%lx\n", __func__,
+		(unsigned long)&local_var);
+
+	do_something(50, 150);
+
+	if (local_var != 0)
+		pr_info("%s %d happy with 0x%llx\n", __func__, i, local_var);
+	else
+		pr_info("%s %d unhappy with 0x%llx\n", __func__, i, local_var);
+}
+
+static int silent_corruption_unwitting(void *data)
+{
+	u64 *local_ptr;
+
+	pr_info("starting %s\n", __func__);
+
+	do {
+		local_ptr = READ_ONCE(g_corrupt_ptr);
+		do_something(500, 1000);
+	} while (!local_ptr);
+
+	local_ptr[0] = 0;
+
+	return 0;
+}
+
+/*
+ * Test Case 2: Silent Corruption
+ * buggy() does not protect its local var correctly
+ * unwitting() simply does its intended work
+ * victim() is unaware know what happened
+ */
+static void silent_corruption_test(void)
+{
+	struct task_struct *unwitting;
+
+	pr_info("starting %s\n", __func__);
+	WRITE_ONCE(g_corrupt_ptr, NULL);
+
+	unwitting = kthread_run(silent_corruption_unwitting, NULL, "unwitting");
+	if (IS_ERR(unwitting)) {
+		pr_err("failed to create thread2\n");
+		return;
+	}
+
+	silent_corruption_buggy(0);
+
+	/*
+	 * An iteration-based bug: The unwitting thread corrupts the victim's
+	 * stack. In a twist of fate, the victim's subsequent repetitions ensure
+	 * the corruption is contained, protecting the caller's stack.
+	 */
+	for (int i = 0; i < 20; i++)
+		silent_corruption_victim(i);
+}
+
 static ssize_t test_proc_write(struct file *file, const char __user *buffer,
 			       size_t count, loff_t *pos)
 {
@@ -88,6 +177,10 @@ static ssize_t test_proc_write(struct file *file, const char __user *buffer,
 			pr_info("triggering canary overflow test\n");
 			canary_test_overflow();
 			break;
+		case 2:
+			pr_info("triggering silent corruption test\n");
+			silent_corruption_test();
+			break;
 		default:
 			pr_err("Unknown test number %d\n", test_num);
 			return -EINVAL;
@@ -108,7 +201,8 @@ static ssize_t test_proc_read(struct file *file, char __user *buffer,
 		"==================================\n"
 		"Usage:\n"
 		"  echo 'test0' > /proc/kstackwatch_test  - Canary write test\n"
-		"  echo 'test1' > /proc/kstackwatch_test  - Canary overflow test\n";
+		"  echo 'test1' > /proc/kstackwatch_test  - Canary overflow test\n"
+		"  echo 'test2' > /proc/kstackwatch_test  - Silent corruption test\n";
 
 	return simple_read_from_buffer(buffer, count, pos, usage,
 				       strlen(usage));
-- 
2.43.0


