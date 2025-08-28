Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BE3CCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 07:34:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC3168E0016; Thu, 28 Aug 2025 03:34:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C740C8E0001; Thu, 28 Aug 2025 03:34:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3B3B8E0016; Thu, 28 Aug 2025 03:34:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9DE4F8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:34:57 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 69EC2C09F7
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:34:57 +0000 (UTC)
X-FDA: 83825354634.02.B61972D
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7ECA74000B
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:34:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E8sTLWxS;
	spf=pass (imf12.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756366495; a=rsa-sha256;
	cv=none;
	b=LckTtx/2PPxg4fh/orv/mNAbRwTQsDiofd1LvZn8RoNDzrWW2EqHaQqbyEgc+NFwx23AEM
	+hof25YkrXFSr8KxSws411fIpoPy1QxY2bhZNw4skObuEbPcxCIWLsoPj/0ITgdIR637aj
	QbKsYagpCrSnq5iA37xMZfwQYbmrAyA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E8sTLWxS;
	spf=pass (imf12.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756366495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Or2e3wHrlUvOPFgjfY3GC0NcILvcAZ+AmyV41U5R5a8=;
	b=A2dKKp74ao8W3vf5yOjvUiLpzUqn+2ENjpH2u0tZhJa8yoS8xTkRQUU/dML4QkuPE+19yJ
	FbbJ563r3nUq43KOdrbSIb6LO9kjIZ7boRBWt7A5P2/ErI514kX2gYa2Uw9/SGRe7ZD9Aa
	pWScSy25OvEO8COEf0hXRbPWLAqYw7U=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-32326793a85so566665a91.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756366494; x=1756971294; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Or2e3wHrlUvOPFgjfY3GC0NcILvcAZ+AmyV41U5R5a8=;
        b=E8sTLWxSk03YQ9W0BzOprosUYimIcnnBaukoc68EQVa0rMa0ApFyHWDyWQq0eY0jEP
         dAyHBKffsIeD78nas2KCKvt4Iv+iNnFwz5xV3EasXgo2AfYp0ye+DsKPimOAIymHgeZ5
         Ff+GmkFJGsLzHAQND6reFGUmV7VbjrCNqpm2UDHi7W1W0VJZurREhdUymFgM7xXnFQ7S
         gIl1s/3vu7VIMNtPqbMpWZJBz0sMJXy49uaohuA16Dar1ytK5zT240dGFGNyUjn4pz1l
         LTq2UQkAibsWJKmMnffNoYII8E/OVzTBm8FG/LcsgLJcs47b0g48rk0xEgr0rrsZFC6v
         vVpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756366494; x=1756971294;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Or2e3wHrlUvOPFgjfY3GC0NcILvcAZ+AmyV41U5R5a8=;
        b=ZeS2PdOzvSwT37FyXVBUXCthbTt8mdoR872U1k6WtFEtoOzfLkS0nKUaXuqjwGuA16
         8K+EZ1CViAD+g43/oHsv3OziZsT/R1OrrwZ8Wlyn6XMEL+XbmtDVB2GclIn46qwAmm44
         443s4rINR/S3Lrkd39ZDYynnVfYiHST0R4tDkv5yBn+n7XuPIO2ZF0xlnfoUU+mYmcC/
         +bXQinsCuW2lRt2sIoBVNrbyXhrPlYOnxL2dKCxrQBgHnye2gOoAzlROui5gWqwT06mv
         1rxiLGrVrNOnjRnt/ebRf+kPzFcVV8d9bIi3s1g7uUmBYKNieJr/Cf/B+yjwJVy+6WlU
         Whtg==
X-Forwarded-Encrypted: i=1; AJvYcCVuvWkJ1+RA7F2aU4x8EzE3P6nm8IhTe+aj+bTWspy4rMYvgCcP1+hupaDCgA7Zit2NxJG+X/9OiQ==@kvack.org
X-Gm-Message-State: AOJu0YzP7sJAHq4aaPg64J6WyFno1ZvCne9EjTdzRY6wz2GIKB0ikxOV
	4gjTC60iyaiBn0lXXds3ooGFkxFi8sit3vUC1EIi6w0CtCgQdJ9CYC0PHzeRU6L3qMI=
X-Gm-Gg: ASbGncvjHtC5C+4TJuz08j04jYiSWcsJSjVWZW19f8Rm/zFstkxE6GYXCgTeaOSSIa0
	N+Gnu+hUUjC3RhAip0R/CZ1Fl5laH4yJYwYOqLpZjbJD2yrszBmWvRuZQxLerUQXzSJHQ/ukg1q
	yK5Cat6lhFpj8YO3RzR/DzGL+e01663XKCMngDxcF2F/T5i7kEcKApJGtfK/bMr1uF99WSNEUS6
	4l6cbC0LcRaxj/rs3GU2fhXJs3ctSvCnOZ61064qSomihzgK7EBA1M+9Wrdenb+SgefFmRMt9Ip
	bDHgZ11bDUVNOscrQbgNtZ5cwEtgPn01aRq90iZCj4TGB0S83J434ms//l5+lRlgnEu29WYhnGb
	vVPt+RCxb9BM8lR3bO5POfa06h12TTEMzx/c70+pz+19/8IWaynVPjPlmZLr2JBUoPJ48M7A=
X-Google-Smtp-Source: AGHT+IHB1bGrZQkRWWOeTcaD9yBKG+Jt7AaKjMTGJ6v8jmWN0++u4eqV5qBUc+XfK8W7V9oke139Hg==
X-Received: by 2002:a17:90a:fc46:b0:327:5461:51ce with SMTP id 98e67ed59e1d1-32754615342mr10004212a91.35.1756366494136;
        Thu, 28 Aug 2025 00:34:54 -0700 (PDT)
Received: from localhost.localdomain ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b49cb8afb7bsm13182613a12.16.2025.08.28.00.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 00:34:53 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH 13/17] mm/ksw: add stack overflow test
Date: Thu, 28 Aug 2025 15:32:46 +0800
Message-ID: <20250828073311.1116593-14-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250828073311.1116593-1-wangjinchao600@gmail.com>
References: <20250828073311.1116593-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7ECA74000B
X-Stat-Signature: 5w6xccz7sybg7aeqdfy4k61dokgj3rxf
X-Rspam-User: 
X-HE-Tag: 1756366495-525311
X-HE-Meta: U2FsdGVkX19rUAibsfybbMhYBn6TnL1SBf7sQ8ABim+oRYejbD793/AkGrsR8DqS/Sm/lmvHtjnKJRGh35Xa8ao4emorElBc+wQ6lwmne0vPI9dbv99bt34/CRejNw+g4vbl3zlgKedLkPQvToQFTaRkGeC6yNcZzT8/k2+TVIXUCImGJt//pIKP6s3VoWxE5bDS1j/wc4ysooL4YTCwGfBmgLtiw2Kzd3ZmQE798nCoOP9Xpy/f9orEVtj+uKgEUPEeF0OBDd9uJhNb7wJMeJzmv/MPIXmJ5lUgFaryd5Oq23nyqn1aJXnIBJ06U4eKG9EIi9JWGsifH0uvOwGe21/rIJzBU194W5Ywc8KlsPyonhmm3nTakQ7z3FSEaB5V1pl5f1cjOhpekkgkjQT2mE2n2uk46dXHrX5ufV91P9Q3c1KNpJUx5/IVww5dlyC8Lu6f4gujCik3kgPhQxQYjCRdGL8FMDuYdY10uvMtPlM2smqIG7tELWTMijyf7F/ECalonmX+ueoMoDpx3CPWHKCJ8QwnNidFE5zYwO18YEh6/Li/V8wcgSzVW+5mXBxG6O51OYeYs1yHZFjsRP/3g1NN2SvprG4ysskhM3IRaUlaoTqI50k6NgpAA/7PSY0j94nfh65YaOzE0vFO4wqRmCzNYN0AOKqtsWQNWx6bzfZrV7MZ2Yi8a1zdbAuGt/lO3FYslp6Bmuq7yXjp3C2KlNgMzjPJviH9vvlbqKK2WATZsSkgLgadfLfsov4KZU/qXzcSILNNF0N2I0/jS5QIUIKnXuaThXljGKCsfiNurfLA4OiNHJ1Nhx9oM/nGK4SD9iJJI/PKVAB0mtb2z5oljDFp62oI0pUVM64gOWyxBZZx9jw8aH0cB1QZHYDoEWFoB8UdY+1V2ET4PKX4HEKngkENQEGzAEz4KWhKzWu3fqtjCWF7ma1iCXpeu7CICrU6pNre63INlMdfA15x7tk
 7WKnf3qS
 89P2kFn/A1po4Aeo19PNFDPVT//rv7FyDGhwKfA7dFNuzaLFCGeqIwH43MnSNaRtFv3102AdLOX03EIEz0R4ANqDNjhGwC0jSKcj3ZZFLwRyC/XBvwwV0A5B18f/q++5NP5ZD+FH70Me7aP4p9sObbBVDkZyM51g+xV1zyaFuBLykHV6AsCXK3/VmXkk7wSTtQnng8tXSGqFvz/VQf9VcefciMj0ipt8l/Dg+M8uKv/z3Ghyi9sTT6KNEWFGhQi96kvd5ZHdCWnaBJOocOtJoswFCkR3dSZQdQ84ejCg5CfZNVZduAaSis9nxnVu4a4nD4beloOGLhfA9TdlkBg+hLDPIUYrzkepCWOWIHkF29fqWZxF9Bj6pU2vJappGn4ZSaKlN95oF1cVaL00VArSWLUk5FSBt9DfkXzgIGWGPPimpkEIyG40p3dfOmA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend the test module with a new test case (test1) that intentionally
overflows a local u64 buffer to corrupt the stack canary.  This helps
validate KStackWatch's detection of stack corruption under overflow
conditions.

The proc interface is updated to document the new test:

 - test1: stack canary overflow test

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kstackwatch_test.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/mm/kstackwatch/kstackwatch_test.c b/mm/kstackwatch/kstackwatch_test.c
index bba2ab8530ed..138163472b03 100644
--- a/mm/kstackwatch/kstackwatch_test.c
+++ b/mm/kstackwatch/kstackwatch_test.c
@@ -42,6 +42,27 @@ static void canary_test_write(void)
 	pr_info("KSW: test: canary write test completed\n");
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
+	pr_info("KSW: test: starting %s with u64 write\n", __func__);
+	pr_info("KSW: test: buffer 0x%px\n", buffer);
+
+	/* intentionally overflow the u64 buffer. */
+	buffer[BUFFER_SIZE] = 0xdeadbeefdeadbeef;
+
+	/* make sure the compiler do not drop assign action */
+	barrier_data(buffer);
+
+	pr_info("KSW: test: canary overflow test completed\n");
+}
+
 static ssize_t test_proc_write(struct file *file, const char __user *buffer,
 			       size_t count, loff_t *pos)
 {
@@ -65,7 +86,10 @@ static ssize_t test_proc_write(struct file *file, const char __user *buffer,
 			pr_info("KSW: test: triggering canary write test\n");
 			canary_test_write();
 			break;
-
+		case 1:
+			pr_info("KSW: test: triggering canary overflow test\n");
+			canary_test_overflow();
+			break;
 		default:
 			pr_err("KSW: test: Unknown test number %d\n", test_num);
 			return -EINVAL;
@@ -85,7 +109,8 @@ static ssize_t test_proc_read(struct file *file, char __user *buffer,
 		"KStackWatch Simplified Test Module\n"
 		"==================================\n"
 		"Usage:\n"
-		"  echo 'test0' > /proc/kstackwatch_test  - canary write test\n";
+		"  echo 'test0' > /proc/kstackwatch_test  - Canary write test\n"
+		"  echo 'test1' > /proc/kstackwatch_test  - Canary overflow test\n";
 
 	return simple_read_from_buffer(buffer, count, pos, usage,
 				       strlen(usage));
-- 
2.43.0


