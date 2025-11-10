Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06A0BCCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:38:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04BA48E004F; Mon, 10 Nov 2025 11:38:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEFD88E0003; Mon, 10 Nov 2025 11:38:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D90528E004F; Mon, 10 Nov 2025 11:38:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B937A8E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:38:22 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6AD0D12C2E2
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:38:22 +0000 (UTC)
X-FDA: 84095255244.24.8C0432D
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9AC194000E
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:38:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="bRC2mTT/";
	spf=pass (imf27.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762792700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tu+j4Ql3fqr3I/4VuukNZy9fUe1HehKP0k0yDQPRfsM=;
	b=XD2iD1ctloUr9Y4eXVUPPrPkxa9d/1mlQxDz4RTolf6Gy8ZH5MXAvDekoVObB50Svjvx0+
	PRP8aWZZkLMmIni9lX6o3BL7Hq0miUyF9y79UGaGBjOlZh2zp2NpNXn/+kAdXDFFAiy85m
	KKu1Rt/HnFGFAgI7tFeNupgxMcsWZqI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="bRC2mTT/";
	spf=pass (imf27.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762792700; a=rsa-sha256;
	cv=none;
	b=yq55SmCuRW1RG36BkrDancF3NQbOYdVvxUH+jeLRBL6pF61S3K/6nEnkt6R+ooEllSbUgQ
	699k5mHwTN2/gQgHnXe/tY5HjInYvLfDEP6WCpObQc8lX1LkyxN/znshhxAbQ7XcxIi7Yz
	FC6rDLQf4n+q5sp1bfzuLwpyV5B1WZE=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7af603c06easo2976873b3a.0
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:38:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762792699; x=1763397499; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tu+j4Ql3fqr3I/4VuukNZy9fUe1HehKP0k0yDQPRfsM=;
        b=bRC2mTT/2iIVswu4wJhgVDuhDqVklQEPccus2t8qOALvClx3lW+lznw5zLcLpwuhvZ
         iKGVpH/6AitAQCDVnCCIzwpUCZgvQw+bNcjGsSZrE5CvIIzWlZdNXL5dDZLzl9vLU7sO
         GodOWCEkN/VPXA8cMuMFt197tOGLNOe1SjAR1W8g5WOzbMZrfbc2Rw27bHnyQNWHArGw
         6+TcYc3NCtgbbHqDLjYyC42Q2K4qZF8fdbrOentGJeifCDlPIOPZVp49Ssd6dPBdZVpC
         FicZ19lbGnlAqNZ6dlYOozsWA3uNQQaJdB5rkqaSFXq54VmKypXo2uJ5HnHLfRIIgSOT
         LJKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762792699; x=1763397499;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Tu+j4Ql3fqr3I/4VuukNZy9fUe1HehKP0k0yDQPRfsM=;
        b=jVy2jtL5XJ88ywkMDqECaY5Lk2k5yl4Zv1teCJVZ4sPMXejkvD4pGY0Zcp7+iKRpzZ
         V4/p8X4n2sAEUOU0A9hzNMUVePTYekRHSz6yHnoyiHqIZ67Gl352P1X4rA5D6GUAModY
         DRqk9mrs93iB3iE/gwxKVaiBxUP/v0HBjSN8SlXxt1so+NEKjlKAPqXOp+kCtqMQzpKK
         GE8iQtcPDirhE3spBKqbJBUQVxd1ANA1O/t3IHJqJuEUmqxpl6NFftC5SKtczxucDim4
         RxrDqBsHG09jVRn6OiSQrOhz77MOsUxfmfkk/MAnSMV8NtaPSctedSS9lHT4lnssTXVL
         eaMA==
X-Forwarded-Encrypted: i=1; AJvYcCW+JXmrzE1cRxndQKtOpyLi7QHSxYy7YthCAfvvk5k4CKtAFAMJeZv7wOXD0GoNTQds1eEabj88hg==@kvack.org
X-Gm-Message-State: AOJu0Yz++zTs2O9xvm90Yf8XQwDs2F1dvXii2UbDk5UrZ0gvUDrXA5Mq
	oGSEoJQdkqmS6cCtbvluWjekTRnsbC26nN6KC5mZgfkKYacc2OoHNlZ+
X-Gm-Gg: ASbGncvv5R5mmM1IPTSt17j090BXa6PKdFtmusoyGQcroTMLn7MucUDKzbGht7WaFI1
	AuXouSXEyykENO+69VKklWZAUVdJQYoNnGes+RisKicI+568iOtBxA96YVtvuVEfzte5zGPBiUB
	+vIgT+BOf5xXSNm9HDadHZ2srzloiE/EIwbmmY1nJPfbDuCsj83+FbclvO8rCSMIDOcK+HRgRu/
	Q990OgseahayDyoNH7BJm6FQDPnp2n/yxFCeDNy0zMhhbh6tbe/WNSCtTFqNihoW8Pand7v7w0y
	GAH2Mp0jfhTAPxRHcHyyklQgmMF9dKfznnF6CSas5pJdFO2cBM8bukl+iu/OxbE6kheEO2XDuFE
	1BVVLX6ZT+D1p/Qx3ghXf4Ftiv6JaM5WYzAC7DiD5Gw6ua1eiYQEvit1l3UcDAWx+wX7cxC649G
	T8KZj9v6ND1QMhZNHNlkaF9w==
X-Google-Smtp-Source: AGHT+IGLmwDIGeljEZq6Ek3cMIcpWBuZ761zCA9XCLHpvBlYPJFK2olRS54fuUcN9DoThdB4AXP5Bg==
X-Received: by 2002:a05:6a00:9510:b0:7aa:d1d4:bb7b with SMTP id d2e1a72fcca58-7b21a285a43mr11992599b3a.16.1762792699318;
        Mon, 10 Nov 2025 08:38:19 -0800 (PST)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0ccb5c823sm12295899b3a.62.2025.11.10.08.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:38:18 -0800 (PST)
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
Subject: [PATCH v8 22/27] mm/ksw: add stack overflow test
Date: Tue, 11 Nov 2025 00:36:17 +0800
Message-ID: <20251110163634.3686676-23-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110163634.3686676-1-wangjinchao600@gmail.com>
References: <20251110163634.3686676-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9AC194000E
X-Stat-Signature: 1rpgxpgjrs4myw658on9z77anfd5bo5c
X-Rspam-User: 
X-HE-Tag: 1762792700-672
X-HE-Meta: U2FsdGVkX1/D4Ehp+FlkBrIN0AAKgBXOZS2aeKRMqDjZBv2wMlzEMJnsbDuRWMZDYv9ciMf7XO51BXkPWahgJzf1s3KRHw3wU/wx7BnFwhEN3OUyJz6Ft1wwZsiOEa49RmapxKpBE/9goSVLQWL1cguBgYyaK8n6qbJ39zbt9wzYhcNiKKKUw8/Zb4Svc8MTZsRKoKJFdSALfRrVoWoI69IzBw4eujQy0vk4l+9I44BeHGjeB/yMHIcIQTD6lNO9bS1UJf8Wa9szFzr8VaeELWvxcyY09EzDWeOWDOlAgDR2CBm1Rp8sid5LMSnWWA+RUhgW6jkEfEj4uj39dnTjDwqglB2KRMMbDeAXj3MfvX9lmZK9ONxBoCBTMmhe9eOW1bd+plzUwh8Stbq55MbnR2zpFYny94R9EXCgODMf4aQ2WKaoAG9znzN0fMy1XDjCC38ISo+x9+scefUy2/NaQEq6vOI2KaA2Hg4WQ6p/e5lwF0OJj2N3J8M32XqHuBqThXmcZVMwFm5cS2ItrpcjElnuyfmafRhC3BZv5nrJ3J2TBC0WWchbn5ZP7ANLBL9vZ190Yd0dOBUMy96Gt9GFmmm1m5LGUfaOCEa7AuPEO/aMCibIKEZOzvMEp33U1VceDG5ioSl3jFnU0qYg8a5Ab56pbY6xY/lLOPqS/EyX8yUyxtyb/zmh4Uz5Gk0GVg4J9ICjS4Ewows8dEnP0ge2m0NKZeT3o9paC47HAftrMEGqpZoUKR8jdTtfOhpOcxbOkRrWd/ByAyDUmdLHw2K98yuL3z71FuLnZOeWciiWRD0XDhn4pNssskvyHlxPOLyB9ojqQUw/u48DyQ65/JScF88JiGPhAGj6R14BZitjsIDjLttLov7Seo5QNTC+UpEo126hudgBevdMQw/q6LRZInInxiJZ6fVHwhZ36+V+Lb4HRf76MVA4rdpFMB0MXdOrhIijHQPaoYQvLtkQZRB
 DFv6q+m7
 TgiwSSE5q5BB0jaT0w1QmGdEajQkAt34KR0xzZnXfti9iYrqIjVbaNrCwA4GK8c8ccl1KjSJt/Guoo4e/ZE4lU4MiVRD9Mqidsf847N3NifTlThu0LvPcfwVbspRZBFMZHxq03xWarFvWoQd2yrAovxaHY3GnjK2D8Fncwor5ObpuYCwaiQueKmwz9qwrxWYvdJRvuErbXZrNf63tvnsR4Hbb1oFMJB83NJUyU7Bp/kawuh9hhlCLXY1CbQhN5g7pBoGta4ehdPY+EJHvlzirDMs4vcLyS4SiydxEZk1QPSbKvMFbnEst1J0QO75ct/Kmv6ObzHLZDuCoXNXCVlZLQxGq5z0lFTHmnqtvXqEEGaqwpg9DpkKubI5ySPxSqfoDkquIQlS7HXb5emQjsMfVJmVT6AUtggl7XLSI4Zqk9JKi8AZwlC9KqW9czeCOgMiUO7YhaxXGcQX9tOjj9a/7S0buj0nWsKzBpDKraxRP+kHDHbMR+jpvrkIlYHHBd7pgbgrt3G7P+SgnmJUHlk96l+UABHCKucfxOtmwfmSITWRKty71mxS2/a9JpQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend the test module with a new test case (test1) that intentionally
overflows a local u64 buffer to corrupt the stack canary.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>

show addr of buf and watch_addr of test case
---
 mm/kstackwatch/test.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/mm/kstackwatch/test.c b/mm/kstackwatch/test.c
index 2969564b1a00..b3f363d9e1e8 100644
--- a/mm/kstackwatch/test.c
+++ b/mm/kstackwatch/test.c
@@ -32,6 +32,22 @@ static void test_watch_fire(void)
 	pr_info("exit of %s\n", __func__);
 }
 
+static void test_canary_overflow(void)
+{
+	u64 buffer[BUFFER_SIZE];
+
+	pr_info("entry of %s\n", __func__);
+	ksw_watch_show();
+	pr_info("buf: 0x%px\n", buffer);
+
+	/* intentionally overflow */
+	for (int i = BUFFER_SIZE; i < BUFFER_SIZE + 10; i++)
+		buffer[i] = 0xdeadbeefdeadbeef;
+	barrier_data(buffer);
+
+	pr_info("exit of %s\n", __func__);
+}
+
 static ssize_t test_dbgfs_write(struct file *file, const char __user *buffer,
 				size_t count, loff_t *pos)
 {
@@ -54,6 +70,9 @@ static ssize_t test_dbgfs_write(struct file *file, const char __user *buffer,
 		case 0:
 			test_watch_fire();
 			break;
+		case 1:
+			test_canary_overflow();
+			break;
 		default:
 			pr_err("Unknown test number %d\n", test_num);
 			return -EINVAL;
@@ -74,7 +93,8 @@ static ssize_t test_dbgfs_read(struct file *file, char __user *buffer,
 		"============ usage ===============\n"
 		"Usage:\n"
 		"echo test{i} > /sys/kernel/debug/kstackwatch/test\n"
-		" test0 - test watch fire\n";
+		" test0 - test watch fire\n"
+		" test1 - test canary overflow\n";
 
 	return simple_read_from_buffer(buffer, count, ppos, usage,
 				       strlen(usage));
-- 
2.43.0


