Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E2C8CAC58C
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 05:33:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C78458E0020; Wed, 10 Sep 2025 01:33:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C27D18E0001; Wed, 10 Sep 2025 01:33:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF0238E0020; Wed, 10 Sep 2025 01:33:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 94C538E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:33:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 49C4413BB05
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:33:32 +0000 (UTC)
X-FDA: 83872223064.24.ED9DCA3
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6F12E40015
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:33:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RYLafukx;
	spf=pass (imf11.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757482410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nFJjjziwY/SMZUE7K7JOobhYkWwkFReGMU9dNIU9Js8=;
	b=6S3gMDkUE8QTED6dpxep5udYCqPsUQXeJn1sZCBFO/CzmuT9fb33ld8yDeVccouk578gRi
	2Nw/xK/krChZq9rR6ymybhSXOrmxJMBxw2wqXHpjZP8N2v7D6ErISwOtf0R0nLVDVPybu3
	sbVVglrfGsvNozMBUXCF+sDa+qVyQl0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RYLafukx;
	spf=pass (imf11.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757482410; a=rsa-sha256;
	cv=none;
	b=hUTjiZ57MsYwQ1dXAmO0/eUHpzX7YkZ0ezIiKhvqwpSksWhuiv1Cdw5xF/GFFKouA+QRLh
	HyeWE6mgqL9Kx5YFsaerwq547+pRC5oYL/5xu4FTwe41NqxhbjjlWLwRsidXYPUyAQ2GiD
	+SkQJLeY9gLhGpvIl6uCpz6ruX0pnxM=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7704f3c46ceso5375202b3a.2
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 22:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757482409; x=1758087209; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nFJjjziwY/SMZUE7K7JOobhYkWwkFReGMU9dNIU9Js8=;
        b=RYLafukxYfDShs8HJsoiY775Aw4Mo6rfRswpbHEoY/5K/vaJNSSPaJmvHR2PrgZ4b/
         9GaOswFd3JWAcyGgnK8QHUbsc19wMXnoxR2I17mDz354jwXHuOyDFkj90rueKpprjDFn
         i2CcymsMb66oNgypxanRCtTQ48rrSgWnk3qCBRgEeskrlAJ+NamZFu7uP3BqZrPSPUFH
         GinQlscBCGfZFLqRoSt80+/qkwNE+b4+AWIvY2kV2hGUFjP4RZPQX1gH9x+IC8IteChm
         8/qMvfmH17rU4AQU0/t3vXq/SgOklHYBibY9dDEHeoNLIB/GUqa7E8LXBsz2smMLfQi7
         erpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757482409; x=1758087209;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nFJjjziwY/SMZUE7K7JOobhYkWwkFReGMU9dNIU9Js8=;
        b=Jh11sHE3I6E2dachJAPLCAWaEJNGCPaRSc6WU4AnN4JSkA+qFJZsKJmVCglL8H1+lZ
         z8bWPaUGx+d2ROIm5wrSyTtIWvrKa4DRRgApmopmYYNOyYg7W1ycXNAWWHwxZJ7dF7sY
         l7bMWIrrVA0U90xYkstXQWIt9AGgIO1zJpE9KuopfhtlT0/K6O04xqRcA3fRFqfDdtZA
         i0Tl1k2aGuT7O6OkkNNSutsfYIvubp54fgSp8Xm93/uAhzgIetZI1bc6eMhqnmc7hXoK
         BvbKlx2tjoIzTQSoj6U5XFxdiuh35cELPASExLhPfursjl4lYx3Iu3CggMvC+QhgFxmN
         Ir0w==
X-Forwarded-Encrypted: i=1; AJvYcCXvf5xsxYrx+D9Oq7hAZ4ZEXZjnT8d6VFQ3rYUgs+33FJg/7t5G1SRf6AGJx/Q/Qn6ZBXnsFjmn7A==@kvack.org
X-Gm-Message-State: AOJu0YyR5hu1Wf+wevDjPgAsCIY5Gi5aTqWkXf46IZyobMNf9tE9oxDY
	WorpGXtAF+gTm8EXi2732d61B3HgUIsGjZwHqwETlxLgy1OTBdsLUjiR
X-Gm-Gg: ASbGncucQvMAoApJM5IQTEzHlZsbANzE2d1b1Q06oCecdrBURAWF/ltS0YYjy7SnkrM
	CRLn3cuXv3VAqkee2EKPq2LdtdEB0yg7c4xYHvXaiJjMWxyadFlIN9AQ1l9pJ2lcQjfnwNsuQno
	yy/EiqITA+GU4LtTpBuAAAf4pYw5fJvV2Fd4PnsA312dDyy00cbBSzXMXSjT6aoTbOrx8zqzMQj
	qqZOzFdcIsqN2qY0tZgwde7rABIXcSpDYexGM/NYeyVcql4qX6Y8P+tskX7/Yrr5lxm1/S08hlc
	DO4e3chq7IMQtsuQ6udSoy0bpQBeuDPDvDQJq6hDiePeCmT/8bH6ZX1613asQX94xwzqelo0BFe
	qyl/Px73+9/k2yTvh3VAHavWUdv0Uh1op81+R2WRGwrXPSWfS1yzdcClFA1fK
X-Google-Smtp-Source: AGHT+IFSzMJtTgRp6G6+ynwQIuI7wFxwrcxpY0ttE5gtXrdyaN2igD3J3QxBSKtHfOz9fDuR2ISq9Q==
X-Received: by 2002:a05:6a00:3c8a:b0:772:4d52:ce5a with SMTP id d2e1a72fcca58-7742de4244cmr15474546b3a.26.1757482409245;
        Tue, 09 Sep 2025 22:33:29 -0700 (PDT)
Received: from localhost.localdomain ([45.8.220.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7746628ffbesm3870342b3a.66.2025.09.09.22.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 22:33:28 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	kasan-dev@googlegroups.com,
	"David S. Miller" <davem@davemloft.net>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH v3 16/19] mm/ksw: add silent corruption test case
Date: Wed, 10 Sep 2025 13:31:14 +0800
Message-ID: <20250910053147.1152253-8-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250910053147.1152253-1-wangjinchao600@gmail.com>
References: <20250910052335.1151048-1-wangjinchao600@gmail.com>
 <20250910053147.1152253-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6F12E40015
X-Rspamd-Server: rspam05
X-Stat-Signature: y6msfpkcjr3bar41s6cq4mw5mtbhuj6f
X-Rspam-User: 
X-HE-Tag: 1757482410-576327
X-HE-Meta: U2FsdGVkX1+jceJAw5U/DkWXWm1ktA/O/pMw1SibH3IJxUP2/jxFzG8ejroRSqKeh0jCKuz33vB8iiSQgzGnNvJfaQIO6EcdjjfldsBzszTU2FYrIPJsTCbq5YG/tMf47MlnzOrzJ5/kvZFlmAHREXVPNOLaw88XG+OVxXFi5J8d9v3Vnaz52V8watpWL063lcJr5+dwV2gW3dTCbYrayo0CU1iaxtZKEn5LdJ1BzAOzfxQKZR1UAeYnQ96vTrDBdwDFFVWQmu5HP7Tn1UZM1E89GMwOzX6hE5pcbzPv8t7YfsvWl9vxr4K2mGOV6QQiXtt0AWfalw/GIIKhdOkdZNBpDwt/0S9ygrvauM9Nu4eFkb3BLCgG6Bohwr2bW9rl2M242wAR4Tqtgj2uWF1x8IMxC7AKD8Qdx6jTnOuDy240HZ1sDqdQKmG3Q+CXmK3uNarfX9SS1KurtNRNx7c4T2FYI4e9MlfHRpWiAgJdDrq0BF5Lxde7lFKPkixoT+JBPbdMpb5DGpubu/uAmL+/6R8N7emZ9CZA9PYXvkrj7oEeorDlMIbv7aBnIqqd0C6RyRwXAJwjyE7j9iv2tCryvaFTZjjNaNO7H5k7UM3YFIYCs/r7v0dz3cOs4Cvga8idtohpxkyNkAEf0wiNmuY5xQlpVoxKcaWtlb7RbxiaZTnIGADTgR2B5Jy+nuUPF68o0g4j8ajNqSTucTCUb/5/tjEA79EokXuLkTSMFTwTcFEFgRYf+jGakWdX38gsraZq6UG3dMX4PTGzigWHtXoyuCzHS3f2nFfzeOHdzVcoxqK/cY62HsL8tzYIRVoy/DyaP0bdkvXJve9Xlkav5H8Ppg9FWUY6XCKaJMfTIiN1eVkRTMMKZNEAC3TBoNY046K95Fo0hbdJxwyqgobbhHY3Emr8OdQA7W6zpG5s8iiV8ViMVpbRHxLxcX0zRIR5+ExIBHrW/c9fSwKTQtkFZ5o
 P65qpMR1
 Z/ymmzPLXemD0x/mb4x4gp14HXW4PWBcgx50t7rzy4aRGSYbZWpXwRfrTZFOrwhA0koB/7AV21ywrJ7b8wpPfoVaQpA8Tb72LPWHoz4KQC7MaOcdxCRl412opTw0XUKeouEr3z0yhEKQPrbz0W1B4UwrS/RgMU/BBVIXn8Pq+Tkcf1YQ95I4nJ9Mg8yuAJmx6CSUzCdU3JXjmDne1GJW98oxNuGgMkyAE/wn2bV8ass+uzF6UxTLSYiTA1+pkzOerD1UkQwFf6I1jgI4E4LOZLwW9RT+7smpmuPs4Ht2jiQOUaHSxSEJDueCUY9I6gO0e7jKlLAim0yU6c3ZM6BpNikx4MkE0muVLbgzFHEtkpbWOuZFWhicx8nhVfAGDCwnTl3H5orQuLqAtWj1ZHXfjHzcQJyqhRJI2q9cc7gBsctKTjg0QoS9mKgMFGRKTb26NrFpuA2rNK4HuB5y0S50nbUV5Ssphdn1DoZcgJHIK72a/yvueoXKG2gHHyr5Nzzj1E/dP
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
 mm/kstackwatch/test.c | 93 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 92 insertions(+), 1 deletion(-)

diff --git a/mm/kstackwatch/test.c b/mm/kstackwatch/test.c
index ab1a3f92b5e8..b10465381089 100644
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
@@ -61,6 +64,89 @@ static void canary_test_overflow(void)
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
+	do_something(0, 300);
+	//buggy: return without resetting g_corrupt_ptr
+}
+
+static int silent_corruption_unwitting(void *data)
+{
+	u64 *local_ptr;
+
+	pr_debug("starting %s\n", __func__);
+
+	do {
+		local_ptr = READ_ONCE(g_corrupt_ptr);
+		do_something(0, 300);
+	} while (!local_ptr);
+
+	local_ptr[0] = 0;
+
+	return 0;
+}
+
+static void silent_corruption_victim(int i)
+{
+	u64 local_var;
+
+	pr_debug("starting %s %dth\n", __func__, i);
+
+	/* local_var random in [0xff0000, 0x100ffff] */
+	get_random_bytes(&local_var, sizeof(local_var));
+	local_var = 0xff0000 + local_var & 0xffff;
+
+	pr_debug("%s local_var addr: 0x%lx\n", __func__,
+		 (unsigned long)&local_var);
+
+	do_something(0, 100);
+
+	if (local_var >= 0xff0000 && local_var <= 0xffffff)
+		pr_info("%s %d happy with 0x%llx\n", __func__, i, local_var);
+	else
+		pr_info("%s %d unhappy with 0x%llx\n", __func__, i, local_var);
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
+	for (int i = 0; i < 10; i++)
+		silent_corruption_victim(i);
+}
+
 static ssize_t test_proc_write(struct file *file, const char __user *buffer,
 			       size_t count, loff_t *pos)
 {
@@ -88,6 +174,10 @@ static ssize_t test_proc_write(struct file *file, const char __user *buffer,
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
@@ -108,7 +198,8 @@ static ssize_t test_proc_read(struct file *file, char __user *buffer,
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


