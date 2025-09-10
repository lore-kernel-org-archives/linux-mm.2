Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25170CAC58D
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 05:33:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F8DD8E001F; Wed, 10 Sep 2025 01:33:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A99F8E0001; Wed, 10 Sep 2025 01:33:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54B568E001F; Wed, 10 Sep 2025 01:33:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3FE398E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:33:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 111A71A0761
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:33:21 +0000 (UTC)
X-FDA: 83872222602.11.AF98EF0
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5FEF2C0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:33:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ezyu8Iy1;
	spf=pass (imf22.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757482399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C6BBsZfnmfgl1Jgn+pU00vd6g5c1DTmTteWqGp/Sk64=;
	b=ASCKncvmKlxGUPtMn6aE9zLG+0sfJd378seG6CU2qeO25q57nv5vYt27Sec9YsPC+GeWsW
	eoMYUHQ63FhfmRGZrHoFxTJFa3/PIAqSiA7NTp8gPCj8j2lVa/dy1gW1iCIkF12qmAp6l4
	SN+a5nwF6dgO27wz7fB7unZjGrVhTZk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ezyu8Iy1;
	spf=pass (imf22.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757482399; a=rsa-sha256;
	cv=none;
	b=GQMVzy434K6Dy+iQx2/JvLGUsE4iHoRaSqgTLgP0O/xu6bTe24ZBjw16upu1JHoM7378HJ
	GGbZMtlGFurjQOtYeHLBz3pQB7XmWYUobyADjVu4KFuIbygNsw5IdNIN84xKYMZmoj2KJJ
	bndsQ5wWUuXV05nO36DsX4HuSAq3dis=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-77459bc5d18so2191498b3a.2
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 22:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757482398; x=1758087198; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C6BBsZfnmfgl1Jgn+pU00vd6g5c1DTmTteWqGp/Sk64=;
        b=Ezyu8Iy1U9Xo28vizNxQQ3NiNx9e4WfcbhN7XS0DknkNNa7tRg9+dzR5rZC1ZRG1dx
         jsF5y3NlmXirA9o7xMMi2Orl06go/+4uT81P8LlobdjJHLnRrLNEqkT/lX7RuPHHBqUj
         rtspFtJLbLuZEGejeue5T+7DWFR+cVRVvZqBTy+XE9lH7AyB86D/9dR3MLU12WrqNe0I
         tD5M49GU8m+7As7ngtLJFWZ2XtlNU419cPguuuJpT3Tb+6uzbumI+u0X/XjwSv/YoRjg
         BZKKJupYhRIbc4pN6LfC/q4LjAxgtNfRmDSYPohO6aEMKd3AgWO2pc2z/JILeHxhbeJH
         4tig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757482398; x=1758087198;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C6BBsZfnmfgl1Jgn+pU00vd6g5c1DTmTteWqGp/Sk64=;
        b=XE7+kZQoQWPQTwN0sOC467M/PPRUKMH+uSC+4WG/4mOTt1Rj0ex/YzfNN9GdMQ5i+X
         risG3/PT/j08u66sdFsybWQHuxbkfSCFPNbEhWRvumxbpAqbhnpTx07Q4PaVFDAAAJMW
         nxrXJGEbTMKu9X4Sbumf65/9iH1OwaINW8YEeZN+dfFv16lIcx3fOiYXjjvxgAfCKoPL
         lHFoTHQwCWRh/BdTW3DWpEaAS32LNqqwKVjDR+ax7tVXbl0/9aTcmXhfRCUaLDQfrLoj
         robyokt+FhzQb73g+xBLRZur5WkCTLxyvbWU77j/eWVmbG6qJrU1+zyAXgvJBYLo1gn7
         byfA==
X-Forwarded-Encrypted: i=1; AJvYcCXVzIiFVjHZUSTytU8qTqTocDZzZlIG67QxG1X0EdGDIl4CMzWoKuyzmsq/U8EzLuNEG2jaXu9UZA==@kvack.org
X-Gm-Message-State: AOJu0YzL/zJ4GWX8YUimcsfcGlN7GGUdlx2vS8f3VEX0sd7r14VpItnv
	0y+Q8+SDJk4TXlTw7Ik/HocYeXRDqpKeADZKCXYxMrYpwvy1UaTm+VMi
X-Gm-Gg: ASbGncteLV3tnUTPQ6jzEeyKWKRi7uz2fB9JUGPzTJgy9iyetFmdGmB8yTYkLy7Jub6
	Vxl9dR7gmJXWlGjC95NX0ubXowI2tZQDALTPskqvrUvKIw6OLn9I1gSZxI0KMH7flqGCIncwGn/
	EbhRrP3hk2ny25+cVJffz74pa5pdMgbQAgv7zP4SHFO9VhlNC8RDd8AFd4Q/Xt2s0t90Qtvb6dY
	VRkZE0q6YBUo2bRKJCbc202LHxCWoCW9JsL762UMPeKKNo+C+b0UcFlHNn2iPexUTn5Ngyy7DFi
	i4yAsFgXRK5+AnT3+E86NVe8Bykc5KKQnvyXOvhHDrrJPMMMf8JRKh9MsbTP2r59Z/pk4nM1Bh4
	IZb/xxKMpYk5X0A/pNIhRRIeJLX4PXOFf7UcmklGgDq5fyC0fvw==
X-Google-Smtp-Source: AGHT+IGMlBk1siPf0LdBIVrbWn7aNbl4n5xmBmCjKUDes18u0uAwbv5aGrUaz59gciPqgZoMRDZV0A==
X-Received: by 2002:a05:6300:2189:b0:24e:3b70:978c with SMTP id adf61e73a8af0-2534756f62cmr20233577637.59.1757482398166;
        Tue, 09 Sep 2025 22:33:18 -0700 (PDT)
Received: from localhost.localdomain ([45.8.220.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7746628ffbesm3870342b3a.66.2025.09.09.22.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 22:33:17 -0700 (PDT)
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
Subject: [PATCH v3 15/19] mm/ksw: add stack overflow test
Date: Wed, 10 Sep 2025 13:31:13 +0800
Message-ID: <20250910053147.1152253-7-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250910053147.1152253-1-wangjinchao600@gmail.com>
References: <20250910052335.1151048-1-wangjinchao600@gmail.com>
 <20250910053147.1152253-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5FEF2C0002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: xgqmqh3wgkbp4obdi54k6n9p679wky8c
X-HE-Tag: 1757482399-450527
X-HE-Meta: U2FsdGVkX1/sZqbgH0mrlOpdRC6h/s50IqtaReIN0HKVIvUbCmYlK1hEBqUGaSNG2jP95O9bJ9FIa4z3e8dWG+11MTGGBhfZ4msnJjdwpCJKXBer37dM1/s5ScaksiIMQ2uCVHlmIj8Kt3grKp0qlcecYGcJIKEA158mAZatr2f23oaF+9bEdAnsIpedxz7WsVqMAi5MpT6RLL1y9dw7vqAyADLoXG2MCLK8U63y89yGdhSZjREsw+Qvu0uyAn5gaRNoq5OJ7r5ndrIeAg5ngPT266SPPjy7qQMI8+JuD5xqbHdqHbFE7E/fMtWQtpgypuM35/Bj2lRd+gmTniQUvWicNOZR3+F1CwA566NAU8UvTLtHssF/avOKcWKjKLIo2juGNjSRZTf2t2lEp1FK4dEbEcBrhntLuteMkjXXQmREgEhz6dtOaNA2TEWSVgAzJ7u0QVupse0/0vRDYIVjURqUGrAFzTkoFF0bLp9v58lCzkTXiIZKtLSZZ3D2a/mhDXznVlkqHqVY0NoKMwEJKRz5zOnGyXg56Q3nymgdSFqYtXwJcAywAAP78bG+GFFU+NqEXqQXkHYVxlr4S4pBsDEH7vSrVWo1dOWdZY4vPN37cFMH8t43ZWsXdoRFtkndyff819U7M5NIiUop+1s/fEtPqOqhPCn+VisUXVNV0RtR1Mlx1NtyWNGeP7vongL9HVZ69T4U5yE1kt/vxIOB4WRxaKNLWNaDfSfrhhIYsbzoNMj/FvN+XufSMtlqhcwX6yK1j62C+HpacpKGfcAlMdEgYHJvXCMmipAFdkhfgzxh9N5l4dob/eq5mJBYQcmQE8FNgQWSdW5XbRoBbsO+sZ7Bitx2YwRztvfHn3I2/e7Rbta5YaS3p7myOy7LUrB7MOhFVGqXtzku3brk/q+CeznQqXnK8NU4YoAa0+XlXj5tHY8TihF7I6KI4/T9FEgGlne1cz3nDvufGWuoKNo
 mDs6V3qX
 WKUep1TW5EO3wxq7Fh1Hs+++0LslaFK53jd4gcFbF3vf3Jx2rjOgdqm0GHIX7qgG5NumH1FNM8kwk36FLnuTQqPve3Lu8wACzH3aWqGZgP3DxeCGKrTUPrAgkv6lzSpFDm9QB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend the test module with a new test case (test1) that intentionally
overflows a local u64 buffer to corrupt the stack canary. This helps
validate detection of stack corruption under overflow conditions.

The proc interface is updated to document the new test:

 - test1: stack canary overflow test

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/test.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/mm/kstackwatch/test.c b/mm/kstackwatch/test.c
index 76dbfb042067..ab1a3f92b5e8 100644
--- a/mm/kstackwatch/test.c
+++ b/mm/kstackwatch/test.c
@@ -40,6 +40,27 @@ static void canary_test_write(void)
 	pr_info("canary write test completed\n");
 }
 
+/*
+ * Test Case 1: Stack Overflow (Canary Test)
+ * This function uses a u64 buffer 64-bit write
+ * to corrupt the stack canary with a single operation
+ */
+static void canary_test_overflow(void)
+{
+	u64 buffer[BUFFER_SIZE];
+
+	pr_info("starting %s\n", __func__);
+	pr_info("buffer 0x%lx\n", (unsigned long)buffer);
+
+	/* intentionally overflow the u64 buffer. */
+	((u64 *)buffer + BUFFER_SIZE)[0] = 0xdeadbeefdeadbeef;
+
+	/* make sure the compiler do not drop assign action */
+	barrier_data(buffer);
+
+	pr_info("canary overflow test completed\n");
+}
+
 static ssize_t test_proc_write(struct file *file, const char __user *buffer,
 			       size_t count, loff_t *pos)
 {
@@ -63,6 +84,10 @@ static ssize_t test_proc_write(struct file *file, const char __user *buffer,
 			pr_info("triggering canary write test\n");
 			canary_test_write();
 			break;
+		case 1:
+			pr_info("triggering canary overflow test\n");
+			canary_test_overflow();
+			break;
 		default:
 			pr_err("Unknown test number %d\n", test_num);
 			return -EINVAL;
@@ -82,7 +107,8 @@ static ssize_t test_proc_read(struct file *file, char __user *buffer,
 		"KStackWatch Simplified Test Module\n"
 		"==================================\n"
 		"Usage:\n"
-		"  echo 'test0' > /proc/kstackwatch_test  - Canary write test\n";
+		"  echo 'test0' > /proc/kstackwatch_test  - Canary write test\n"
+		"  echo 'test1' > /proc/kstackwatch_test  - Canary overflow test\n";
 
 	return simple_read_from_buffer(buffer, count, pos, usage,
 				       strlen(usage));
-- 
2.43.0


