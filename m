Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB897CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 07:35:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 018E08E0017; Thu, 28 Aug 2025 03:35:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE4C98E0001; Thu, 28 Aug 2025 03:35:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D86618E0017; Thu, 28 Aug 2025 03:35:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C49C48E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:35:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9E001BC93E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:35:00 +0000 (UTC)
X-FDA: 83825354760.04.FBD3EFC
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id A0769C000D
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:34:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XWVhq38d;
	spf=pass (imf28.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756366498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MrzeI3EYnXpSYBJKftFAUOvxevvy4jLNuncba+XGBDk=;
	b=sh0rbdva/B7hlca2PN5uIosscLLTJRAdzaOeQ+Cm50DfhTDi6tpxh2KZQqaqjt+5TOrIbE
	q7J6PZxcaTtFpuOkGp2Ul99aa3bNlYXRHyIz/AoCnbPqlY2oRAx2myCrtGLQ4vISw8SluV
	IyXZV+3XQA/hWV7is6IVyF5ujCeYMtc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756366498; a=rsa-sha256;
	cv=none;
	b=PXNLgtWCe/q/eedWykqoj6kfZVC9c+bgYfZIZmKGxdG2j2ttNOeWuELBF45ntSE4bgS19y
	tjPuPKzukqzvFvrhdmZdd1BWvgYv0/2r7NJ/XMiehaRRMadh9Pkl1KpAf6wz41eABFZmX5
	J+cgc5XzAGJWrzBKta3WOZCurAC82ZA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XWVhq38d;
	spf=pass (imf28.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-771e15ce64eso534176b3a.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756366497; x=1756971297; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MrzeI3EYnXpSYBJKftFAUOvxevvy4jLNuncba+XGBDk=;
        b=XWVhq38dbr8ihWGcqno0STrQTIIFo9iIKXMi/g5D66OkyK3ZfuRtDzMFtd2UCrtRLT
         OcLCyc1B+E8C9jtuDwKxWBnJ4+1wypSwU5glmzA9zSSj/bVKJmfC771cnCbsPPuaDpSi
         26ip4CfLeZ7PkoX0yWPnBYmLsVYFyWzmphcQvGjUZwS2IhTPZZARuwf3f4bcQw5F/ZjY
         R2Io4FUs61TAogx+vvMqPj00A+UDsvZ1IklSy8n0Dkg8t4W/n2wJRMVbVfp4olA/I6UB
         qVbpo2Gyr6y+8irV3LFNyNGmOvcE8P9JzpZ6I3FB+/ruKuUU3Ljl/BS/EO3+7Ym3cXcJ
         BFTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756366497; x=1756971297;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MrzeI3EYnXpSYBJKftFAUOvxevvy4jLNuncba+XGBDk=;
        b=JWVMnYxkzDjEz7XgtZP+BgQaPKiu5khrr0GeTlgyAFvoVLdRpBcjkxxxTbABJOcHwo
         jSDgiUJ/li0LzM2G7eSH3V96x6+JnydMPNShxpq1bPyqfaw8fk6EWZRlqSQQXdC0l67N
         dGq5x8osojshP/EHTEobe08C4XoaNDemZ6DaEP7NDAU4X8KN1lPaQrO0fDO7mRaftZLs
         2UvwSOuq4g2Ls4/lkPJ32OaL3Yg0GbXPDeHp1FLVaNF9MPxrR7L83Pnjhi9RwmTx2IAa
         kPq1/FdVabb1Ls/K5VWmli8+RQrQcGRm7L/4grmD+4mhuPWjZngzEu+MXbx89YgLgh+5
         jGKg==
X-Forwarded-Encrypted: i=1; AJvYcCWCw86DN1fh2X4dDnp5fZQy1ykqFQdjuCbU770WtlokWn5TECtJtu6KQBiptXH/cueUgxr1fZKr4g==@kvack.org
X-Gm-Message-State: AOJu0YxLDBlAwQLM58M+L/YG5/Hdf9+hufolgX7aixK/FvDuMwKwod9O
	RUxFQV2NBvJJ2xC4y+yew1FvA05TuQ7+VQqJsIsD6+RePPBNqlGw5CFV
X-Gm-Gg: ASbGncssKj13rV83JJi2W5BgrAR7aPwjyPUQYd1UmHlHE0nFYZlQw45HWMfyQODGof4
	RCV39kLAMb/OdLdBPvECGYGZ8BnuHA3f6CFb4AFS28k0I7rWaSWDaTohPLiBCMzDsbSP3C5am1w
	lUTycKaw4F//5g0ZeD7kmrtJ5hB2+l/ShxPH/zsf4ewMGwM3TumAuzbYEJ+M5DxDnJKA7Y5KWiu
	j0AlmxI+dMXs8yt5l8QTNNsRO6dMKgf8dL9R++OIQBuMIgvGPQrmkYT5pXBi1OFgkN0Uv5kd40r
	kXlQdPQBcJZNyoTRPAfEM6GJSKp/Sfjxy60hBa0mCwnImS3eb3a317OZJd6pzXP6casbQwN+NjJ
	zZ3fUYBlK2C9fGZEZgcOmQxsh1uOZD9a5iegnb5OlQMV69CbWCQ==
X-Google-Smtp-Source: AGHT+IHD57dw5PWoE8qv8A9jbGNzXzct5VOkOCkS7MNXKbnk/+b/dQdygfPv1AzYB+6KyyshnI7WQg==
X-Received: by 2002:a05:6a21:6d84:b0:243:971d:cd84 with SMTP id adf61e73a8af0-243971dd02bmr9544389637.22.1756366497452;
        Thu, 28 Aug 2025 00:34:57 -0700 (PDT)
Received: from localhost.localdomain ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b49cb8afb7bsm13182613a12.16.2025.08.28.00.34.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 00:34:57 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH 14/17] mm/ksw: add simplified silent corruption test
Date: Thu, 28 Aug 2025 15:32:47 +0800
Message-ID: <20250828073311.1116593-15-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250828073311.1116593-1-wangjinchao600@gmail.com>
References: <20250828073311.1116593-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A0769C000D
X-Stat-Signature: yjg79m1bnijr6m3ac9gayy4poza6sjie
X-Rspam-User: 
X-HE-Tag: 1756366498-98105
X-HE-Meta: U2FsdGVkX1+Hlx+F/VDp9BgQjBSXsaqx09UiiLFDS8Q0IPdickgdX3QdJ/7TQM0cizk2blIxin2kZQ+S1i3ASpmk3hwGPMz7Nb1aWlBs6zyV9urorjuOVWMWBL7Nvi7YGjjDRJVHO39T8dU2h+6WJUEhUhEczRM7Fd+cJou0/h7D8faVtAorNNfRUe6R5zA6OXJ4sJlHVlcpzLTeV0hS1g+3ppL0hEA3r4WJlmIpcUGT8QB9LtsC31ERmOgmX9aWmzwjPjrxOOLvSvc392/PTtI8fMvQ0tp0RUZjcCumiVpXslCtWavRfjUQDnOsiJ6wyFP6tQr0rxd/RLbbWPr6p0VMWlai1Ussjg2vijZl4q1jdd5ncRK2Td8Ra+gCT3ZXJ9Hh3VL1ce1dJcsyP6IdxVSCuRjrNFs+4Z9tmIrT4NYVyrzfC8t+x8+eS8X6WUOOcA/VBG8+1A7oaKBToCPwqA8OtQj2BiX6Q1uCkoHuUYU0vTCxRHV85eeILz5j1wbMfd3vRznDXp3kUbkwI10zKTdPGO6XP7pDIVky9PfnxJ6NuL6DgahNET2zujdE/UXIjXp6gHvqmK8XkXvnGOMic+ZQsyEEiK/SKkZRMa3Fu++P7c3LvcTfTASi2phdwi/CyaCM9HANaPDYGDJA9Cwtu+Q5cTtbhooK5Ao+REeOPw0rarTMGs3etI9/sNVfv+CREd7qcOP0DMk59o3NmdjUHF6aKzE9+8CqPxnL43sXsLOzvpPtuirGpvp7diUHU6ZwpFWf7R/kvmbr1+pkql8krVswDQ6EPgDBbZ8FynNOY7zpbfDfDF4cLCKjEDN5jDu0D3f+qOnmPyhUoJxqfhSoNAXF5bFMViJIMzZqGYikPBirk67q9J4vSGW83d67D6be7MfKJ41ptcJtbS7vUnqT2ASJQnHyZcNW+tK0815VJqSGLpUwoM5bE3Gy7Wa969+9Y5+LhMu+5rlVMsKhvl6
 KQNDbMf1
 rhiSPw8uRB1FGtgQ60yX0dQRnpX6m1kYSHcsgq7rRz1Fl+wqdpedzKT2lVuhK+Pc6VxgJeBYxMLaraDq7VayaLWGo0zr+htSInewZNocfksgo2aV/0v3O6Uoz09DrkKNeeP8HfwJQLVpT0amWtiAWnW309CvwO+nfR4ZJOJOrZRnvkWoUw5XLJTUFJRVVGRvxIjy2QS3+Kc4RzI2dcEXvc4i/c9E1tLNj2W55ZpPGxaPyak7Z2peDQO78P7ys1sF/w5FCGC7oSY/ZxuV6ATi9RIsxzhBCPZsCLBnJnAlzkIlAykBq1uEp9pNEKTPJhGST1hIqtG0LM+6AQ0U5DCL/oU6onqviSM521tjIApH9xjY3Gf1BEFS38Lh0IwZCCBnWEdcM8HykdnGZRFC1t/hOYUqB76V658gGxUeqVJpLjUV4uCPy2F2mVP9pXGlJC9j2rFslaokETbJCrVQ+3t91p6okPrSpLJYf68qP
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


