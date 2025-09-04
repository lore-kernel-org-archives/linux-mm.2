Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88000CA1010
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 00:24:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E416D6B0005; Wed,  3 Sep 2025 20:24:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E19298E001B; Wed,  3 Sep 2025 20:24:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2F5F8E0003; Wed,  3 Sep 2025 20:24:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BF6BA6B0005
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:24:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8BC29C0966
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:24:06 +0000 (UTC)
X-FDA: 83849670492.03.E90286F
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf14.hostedemail.com (Postfix) with ESMTP id A1E0C10000A
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:24:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zit4sXXz;
	spf=pass (imf14.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756945444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MrzeI3EYnXpSYBJKftFAUOvxevvy4jLNuncba+XGBDk=;
	b=B2uVejskFHkxA0Z0hPDr1mGdXReOCWkAfHdGAQf+HoEI6MMVY7LieBVXEnKdUaOvq15ii4
	c2LWN29yNcCVKLhyPEX+xTNJwIE3LyKcvDROIvrt4CQgYoFtdcNXAbW38KCzQq2qhFVL2V
	wbGl+oVDiiFX9/NeU9TAhIWRQ4vNWjA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zit4sXXz;
	spf=pass (imf14.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756945444; a=rsa-sha256;
	cv=none;
	b=60JFMB8SkoG93bnZcJrCKvruBhE74oNXuN+ODE/B3qm4e9hq/f0fFLkED+hZzbKtLia13u
	17ogm9EK47OMQGJvO5c8n1cwwwz4OJiNMwLoeY3Gr+ePF6f8LkgULDNL6s5wZEzt1eg5jb
	KWNxCphRsFUsGL3SBlNl2ywrRvRz9Gs=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-329b76008c6so315772a91.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 17:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756945443; x=1757550243; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MrzeI3EYnXpSYBJKftFAUOvxevvy4jLNuncba+XGBDk=;
        b=Zit4sXXzem3cOR1As3c58oF69IFD53s9ATddnHiz2P3qcGXDLyRMkEAnKTR9FOf+Ar
         1sdFNwAjGx128VALQqZ6V2asmiW7RqgFBsyg6UYWHKcBtHQqrXSFbIWXyd6v7edSGKvD
         mzAO3EumDjbK7QL6XRdSjZzfv6zPitGLDQDEC1JbLbHtpJh/epteqgPNkvFy2/epzuK5
         27idgrznkd2nCnTy/rYRVrdXmYirkDUpjt8/PsYSC4ELKK5TTVaDiZQcJfQ2jLi4WKv7
         ZZ1vc0e1TmmVEXve2SrhyXxI7TuPMiAOwNZ6Q57E6orPm7gHcGPBHdDjSNisAaJn27d6
         qDJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756945443; x=1757550243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MrzeI3EYnXpSYBJKftFAUOvxevvy4jLNuncba+XGBDk=;
        b=UiCts/9+X5an4GxbxcBaEH+E5GKv5H6apJp/zFVUTYsf+EeDTFjnkQiW3kSwwjy3Lw
         W7dXcZlo0XolgtIjpGdcQkHO8YL5QviR2TXtvgJQyUvTEkVAS9ShPr7dVh7NhBqqZUlI
         OHj1WoSq95jnh5QfjBov2vYArW83uCJ03iUawbbxDKqa+kuFPAND0SiPMXht2wzHQrBd
         guI8SUy/r27FUBv4TXpBQt1epa3xkELtfNk5Y66TkTMx35bqkIpic4wJmqgZU468vSKL
         vcjxnJK52rGB1+7vLg3IL/luRqgo8/TzRxU3+6UqoLmw1Er1NQ2KEazOjdbIOJNILzXN
         mS/w==
X-Forwarded-Encrypted: i=1; AJvYcCXhgmsH+nwbV9Sv9wR1oU3/XcrL7S4rYvmbficsU8HLFKdaTzFvYcSR2Gy1hVRuz5SNgcT8XIKhcA==@kvack.org
X-Gm-Message-State: AOJu0Yzinv83+IkU5QfrgWnLKE90k/ghIpKm84O7eB0PTojWRLHSxE1Q
	Enmr/ywuq+p6EJx7iBNH7uID1NBKbSrGKRJPgH9yXSCck7W7/LkvTPMK
X-Gm-Gg: ASbGncsSFz1mAG74NW+keJFkw/SDEwZ+vMnuGjVTkzHPrXBafpdp9I2MDb9HwcDwcSn
	KTUWvBGc9fJq9/F/wAUITREj5L9f+TnXE4GkH9Ly+/jy2fcom4BZqkBYSXMUvy9UiU0lzV6EDbq
	4CiadQBJDn6aw2oBx3NLGIFg1asRnnN6oKIQrssp/DVVVkmagyFkaYILdPh8h5mEBPhETSqP7gI
	bjnSbSgDcqTDsiB9iym37SsoDJfdaCFG5c4W84PlLqVyZWEpOLqAjwhTfESmLKlYPTUkXfUELBJ
	BflTLvViK+4n0JYTtupzAZF5+LCC8uAO419lGJhJQzOFsClDmklWC3KC90NPH+a3/LrZHRBCdNe
	qrLVLzq/Hjp6kCqH4snnDT+6/8H384HAUbKucfNglCgRb5d9mukxEpbD19lzgy0Y=
X-Google-Smtp-Source: AGHT+IF59l6Y6il6sWe+ojfk5O2VEV4/iuJ8NUJrR5PDNiGZHhFNdzPEip0wnBYNg8k9w5p76AV22A==
X-Received: by 2002:a17:90b:2e04:b0:32b:5195:d124 with SMTP id 98e67ed59e1d1-32b5195d364mr5800597a91.11.1756945443320;
        Wed, 03 Sep 2025 17:24:03 -0700 (PDT)
Received: from localhost.localdomain ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4bd2aesm17579551b3a.48.2025.09.03.17.23.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 17:24:02 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
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
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH v2 15/18] mm/ksw: add simplified silent corruption test
Date: Thu,  4 Sep 2025 08:21:12 +0800
Message-ID: <20250904002126.1514566-16-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250904002126.1514566-1-wangjinchao600@gmail.com>
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A1E0C10000A
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: s6476rt1oebjx4ked7iu1rn95468m43s
X-HE-Tag: 1756945444-720994
X-HE-Meta: U2FsdGVkX18Pv0qhkR3jDYRrYdE26wat9CqmKiu8wTZdGA/htVBmZFELYJCUhw53yudl8YFMe8Uou/KB4sTEarWNAbJZ49j3Zl1CMRTXM/n2TYX1dd2A98dH14cK3X+fD7/Af9LKsLvAxoYQ9tsOOwYtWWEooqfpqu2RuM78EsozaChqhPpaWMha37Sg1eVgCflSlt+DHHlQ5NCHMpfjE0f79OPMzat+k0tbu0AfWITGGQ52EHXcslRBJ6eIvhck+YQynNjqBP9hCRDRUGGEjXkApO03lT7eGoxheTFE7Qp0mI+djb7RrCVHsFcb6B8KpS2nHZH7mTt1PDuVAVY3v8eIBQ3Xm8IvE+E8QSoyRCbDBcLSw9AWeGVkEwMlXasCMYDdPzJuhB+v3GmGVg/Ko3tPGKQi5j46L042nayRHHQSREdo4FrV9Y7+8eXX9ssPHwvLTE4SqH1uWCG10q7WeXcvyL5RfeQU5DvR+OBrgtndJ5nzn5oh5uUD7byV1OhnGc0b1WtfOm4p+DUS1vhcjNixlnPfuzW8xCpl5vvyn6cLiRtAjOAugxub9boFvPXQ7qJzE/aPyjxXRpqOoL0t15QEjraomK+J1hna0SF5N+P3gD6NhZHVUM3G2JozY7XOFjU+rojvHiHgLnHZD2aYjQXA6NEwln+Ig1S6VHKBWqKxJIFe1IRtXdzKgAr2LU8VcFo1rChZJ7xWaPOt9l+WWGdkZXTmPfENInjzikBb/xHTpRmII/0FHZHh562RcSJIxfK5zx3vM7wcAMeWlCfOZQjOZnRia3OnzqoElrmej5wY+/Aj01fWhAfq7CFL2nZjw9Ayl2Z6f7zDweGINao7R+EAG5sOEy+NtnS3wS0kiklsyJtRndW/UGL1/20wcxVUcvr9aFamqfzs9zKlYnIcO7yeYUmryWNmu3rqvjbEXla+0UGHLEk1MAMu5yOUzai6yPRYfngxSNzDvZ0OF2Z
 umF9o6o6
 e9He+F6DfkUsfX+4y/G2RlXnJ5JRv3vijfIHt+0VZRJXgJdqNiLxSqZFXrprUhHhxB+sQI+45d7NWUuBWIxQWJnU4ZrGcZknT0kvzLCpyVJ5apllKELemUlmBrPUZZ/tyoM8Bz0mQhFatZQPtYQ2l+4o/EDQhNrK7AIEBqY+coJEAD80MpD3o2XQCxfyqBXZ61jqlcKembR9lC/I+ZKTPeqaUbFlHWXMIGb52UCIQGRD1fb+5HJ/iNicfv6xa5BdOGkrjf8ldwwfTJCV5edAke7Awm9/nCtgBMtVWpCiZwIZIA6+Q8ZBZyYt8Mdh86dgy2iGeLwLnropr+AQwhkSNGnZMq4pNoYVseO/LQ4mi0wDVeQZIFz+T0i8f/8F1H3I2dCqLCwMhiqGgw4WfdyNpCCqcNW92dZP/qZ3qkLZb+sahcG30Ki0P/bPvPwdDYUWgQmreCm54LpIbxe0wxD/y2PblLn05e9zYskm5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a lightweight test case simulating “silent” stack corruption
where hapless() is unaware its local variable may have been modified.
This test is much simpler than real production scenarios but demonstrates
the core logic.

Test logic:
- buggy(): exposes a local variable via a global pointer without resetting
  it, creating a dangling reference.
- unwitting(): a background kernel thread accesses the global pointer and
  modifies the pointed memory.
- hapless(): operates on its local variable, unaware it may be modified.

This controlled, minimal scenario provides a simple way to validate
KStackWatch’s detection of unintended stack modifications or silient
corruption.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kstackwatch_test.c | 90 ++++++++++++++++++++++++++++++-
 1 file changed, 89 insertions(+), 1 deletion(-)

diff --git a/mm/kstackwatch/kstackwatch_test.c b/mm/kstackwatch/kstackwatch_test.c
index 138163472b03..1f0d616db7c5 100644
--- a/mm/kstackwatch/kstackwatch_test.c
+++ b/mm/kstackwatch/kstackwatch_test.c
@@ -22,6 +22,9 @@ static struct proc_dir_entry *test_proc;
 #define BUFFER_SIZE 4
 #define MAX_DEPTH 4
 
+/* global variables for silient corruption test */
+static u64 *g_corrupt_ptr;
+
 /*
  * Test Case 0: Write to the canary position directly (Canary Test)
  * use a u64 buffer array to ensure the canary will be placed
@@ -63,6 +66,86 @@ static void canary_test_overflow(void)
 	pr_info("KSW: test: canary overflow test completed\n");
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
+	pr_info("KSW: test: starting %s\n", __func__);
+
+	pr_info("KSW: test: %s %d local_var addr: 0x%px\n", __func__, i,
+		&local_var);
+	WRITE_ONCE(g_corrupt_ptr, &local_var);
+
+	//buggy: return without reset g_corrupt_ptr
+}
+
+static int silent_corruption_unwitting(void *data)
+{
+	pr_debug("KSW: test: starting %s\n", __func__);
+	u64 *local_ptr;
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
+static void silent_corruption_hapless(int i)
+{
+	u64 local_var;
+
+	pr_debug("KSW: test: starting %s %d\n", __func__, i);
+	get_random_bytes(&local_var, sizeof(local_var));
+	local_var = 0xff0000 + local_var % 0xffff;
+	pr_debug("KSW: test: %s local_var addr: 0x%px\n", __func__, &local_var);
+
+	do_something(50, 150);
+	if (local_var >= 0xff0000)
+		pr_info("KSW: test: %s %d happy with 0x%llx", __func__, i,
+			local_var);
+	else
+		pr_info("KSW: test: %s %d unhappy with 0x%llx", __func__, i,
+			local_var);
+}
+
+/*
+ * Test Case 2: Silient Corruption
+ * buggy() does not protect its local var correctly
+ * unwitting() simply does its intended work
+ * hapless() is unaware know what happened
+ */
+static void silent_corruption_test(void)
+{
+	struct task_struct *unwitting;
+
+	pr_info("KSW: test: starting %s\n", __func__);
+	WRITE_ONCE(g_corrupt_ptr, NULL);
+
+	unwitting = kthread_run(silent_corruption_unwitting, NULL,
+				"unwitting");
+	if (IS_ERR(unwitting)) {
+		pr_err("KSW: test: failed to create thread2\n");
+		return;
+	}
+
+	silent_corruption_buggy(0);
+	for (int i = 0; i < 10; i++)
+		silent_corruption_hapless(i);
+}
+
 static ssize_t test_proc_write(struct file *file, const char __user *buffer,
 			       size_t count, loff_t *pos)
 {
@@ -90,6 +173,10 @@ static ssize_t test_proc_write(struct file *file, const char __user *buffer,
 			pr_info("KSW: test: triggering canary overflow test\n");
 			canary_test_overflow();
 			break;
+		case 2:
+			pr_info("KSW: test: triggering silent corruption test\n");
+			silent_corruption_test();
+			break;
 		default:
 			pr_err("KSW: test: Unknown test number %d\n", test_num);
 			return -EINVAL;
@@ -110,7 +197,8 @@ static ssize_t test_proc_read(struct file *file, char __user *buffer,
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


