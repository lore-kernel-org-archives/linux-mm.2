Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D72E3CAC5B0
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 02:45:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B85C8E0035; Mon, 29 Sep 2025 22:45:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33B848E0002; Mon, 29 Sep 2025 22:45:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DC848E0035; Mon, 29 Sep 2025 22:45:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 089038E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:45:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C7B0659917
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:45:57 +0000 (UTC)
X-FDA: 83944376754.02.A13C63E
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id E330180007
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:45:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=c9Vlbw2Z;
	spf=pass (imf02.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759200356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ANupiyfNlS++I01zMHP5Qbsc6Wgfn8wZLgNnwRsiWjA=;
	b=cPuKc4699pEW+pfnNqU8f8xKnz24UMIBctsj4dHZKmKR6IQc2LzvCOyJAX0CgusYwA0SDZ
	QdEKa8ZFdtSOwd2x8pVvnJldXaIy+A+5XUCc/jYjVZq+V8VSkFRFh+Uxq9QlqnnUiJ+HPt
	AT5o5hgZIl07jYrp2/P7OBKMEwP5NgI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=c9Vlbw2Z;
	spf=pass (imf02.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759200356; a=rsa-sha256;
	cv=none;
	b=xgtUQi0SjBTyEaeovL+FZH6vArYUG4MQ65Xh8R8TxA7D6G6gFuEGS8rehfbSN5SPw1Gb/c
	E2TC/tYfd3RcpDGJQGvw7lrSRw7ioT1m4rpXRO+jlVCLmhvQxe/6nQ6Lzl8FBrppU9uemO
	mV2N/0b5LGuuDR1+KOyJShPXCYn/RsE=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7835321bc98so2474376b3a.2
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 19:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759200355; x=1759805155; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ANupiyfNlS++I01zMHP5Qbsc6Wgfn8wZLgNnwRsiWjA=;
        b=c9Vlbw2Zz3NAWXkkGBfPUPAnhYTEvL2nUTqr4ZjpgkcFpRHbHDKID5vKCpac26jVtX
         ljbb240mgFTuhiCzaBGd+13FiiA36/m7tIgMV8g0gTe4H8gq20OXtxJ6pGuFc0bmjjdX
         dLQ9DxEcTFmJG2q3Nub2hLgoSHxOteL58lcDMOPkZULjlO4WkjAC0AaBnXA1Ls+BsrBB
         1y68R68wipZkOkLU22dZwb+DeVCwnyc09ZEdWkIa5BkLwKPgE0iWKrL7NpvflHcISE5C
         Yj0Dc8zotHhVwAbCGQNLlIk1RKBBVntfVU5jzccIzxfJR9SJ+dRN75O4Wslam3OMYEyq
         22Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759200355; x=1759805155;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ANupiyfNlS++I01zMHP5Qbsc6Wgfn8wZLgNnwRsiWjA=;
        b=adw4sJDJenpNhlzzdlm9VY9sG5xcLCdbvX+oFfVYVHgANcpUdBwSYpltRmFVAG5n5+
         8rw4LPJPyBtSmzjeTM284xnELJ564OSgJ4/ZUhlW4Qj2dIScqyP0p0mWO6sLkVrQ0Uxn
         xPmiODQyNWqHC3wJB0MIo9ZZWk9uEPyzfWzma0mPXZfWN+QkXK3ss6OEkJtwe+YiGJsk
         VDWTTnUJLBpTZ+CmiTELjadXZjYJnEY8EhDfM0SfhcCfKQlkMroMdjE9RekV6UdhgXsH
         8G//XFyFrM17a5fKKByhhkX8ScbquEDiiNaX+w9t4k82efccsW6SFS12lMIGbIZfMLDZ
         Y13A==
X-Forwarded-Encrypted: i=1; AJvYcCVGzjdIVETdZgUiRSlcZFQCnJFszZqDaZ20cjHUjwUmFtHdBZWq5fpb/jDexJTszYCvwBbwAAlcQw==@kvack.org
X-Gm-Message-State: AOJu0YyZdyyCVvO2dwyQrZf2GFhnBT77I5beTR9WERQPqsLr9b+lvpef
	6NTFqgwD2FVwropV+wjv1YpeCH6plY0baN3t817JgZPOrJbPUqaOngds
X-Gm-Gg: ASbGncsUQhm7R85QovfgwkaDiu+4egctrS5gJ7mRiffg/Fg6fqY5MVJ/7ZQnJGDh4Qp
	SNJB7VFFgdC62AtaISvQ8cysKg92NtB0COoEg5fwVxmYB4ZuWjZyq+R4MNm3GsxMbIXw8qlBwGD
	wHozNs+85CkCcO+lSjErTO3sajna20dxtc1PqdPdYA30p5bK8jAShi9+wDwKycLCIZvFgCOr2SC
	U/jvMWlNVl5pg+ldgB7kDlIA/4+xGRBNR0aIgW1Pa6CY4GmUeL3RFsyC9bkZKJmFWT83EEg8qdW
	ae3r8+5xUgDd1/uk7IhkV+wgeu2qtjzOK2i+qqXPHxG1l903iFcczTAeUkm22fPCCEs7BqsXk4+
	VIgoMUNfpmpGe2ZP12tlHr91CNEcrvFf+w5qhAGKO64X2FiTTmMNBtGVc4WDNibE3hEiM9Y+5+5
	x2
X-Google-Smtp-Source: AGHT+IFgQx8Uh36EA0aXny7DSw1dXOgHQg+bo/K2OmzhGw1sKK8D6YsVYmNHfsV+5mgUHC/7blvjEg==
X-Received: by 2002:a05:6a00:3cd4:b0:781:261b:7524 with SMTP id d2e1a72fcca58-781261b762bmr11615416b3a.14.1759200354649;
        Mon, 29 Sep 2025 19:45:54 -0700 (PDT)
Received: from localhost ([45.142.167.196])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-78102b2ec47sm12565336b3a.50.2025.09.29.19.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 19:45:54 -0700 (PDT)
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
Subject: [PATCH v6 19/23] mm/ksw: add recursive depth test
Date: Tue, 30 Sep 2025 10:43:40 +0800
Message-ID: <20250930024402.1043776-20-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250930024402.1043776-1-wangjinchao600@gmail.com>
References: <20250930024402.1043776-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E330180007
X-Rspamd-Server: rspam05
X-Stat-Signature: qettwaht9yp5t6x1boz3wn4as74oad3r
X-Rspam-User: 
X-HE-Tag: 1759200355-593510
X-HE-Meta: U2FsdGVkX185u+rqB6nQJgRdkAX4imEcAQcFrI8Rbxx6YpxfNc4inHjFzeh3Gs1xBzDlm7MnZF6PnYMMETUW8KUQLJUL36pAxuvtpXn6woe5uRi4f9IkkFSQHuAOxIIUDpDnun8vw1bNTB3V3sWIeorcX3wLigQE4wtZcjLOh89MfDr3dSUb3Dn/zPEiow+7KRbEDBIQn0SHkDkj2BH7bzW2gIygtGMYJX8bfCCUucXjo3KWnMriZ8F7UplLBX7GfrXmEmuzJLqVHdsZ1oc+wJZULSNVUcAyzlt6ZRIlvBdUmLnspS4Q03eMVMK8nOwPcBBIMXP6LG+Rgzt8NqTcdI4JBQ4gL4bPsf6wkMoHDw3nQgIAKVS8Iv+WeNlts69WXnQEcuDdXbeq6+UJjX1DDtjnVlYxpLObECsjZ166hDvWmz60BWhDSS8NWBIVdk+5u9lXrvhThOgxBmzq8ClGWjfRiryMU7pvr6cgd1uEiLJZMWg2RJNX8RNyoxTy4vLqlcp8/x0TkPtm2Dx7whh7CXn09CNaBWUortNWV6go+QRtr9ruRizT1yMGUkcC3enBSYDl9rsfKAtJWu0NyCecQlPkHp1B13/tQAMtGIbzZs4tFgWB5NRosWgdsG2ulT+p/AUhmqBwG7iwivFB3I84Yhe2X+XUIrxN3CuQFh+HbM5Rdn27NdJ55ZVLE7h+xVMnTPyXndjimWxtpbatDhk2tTv+BzW24KF1/61flOHqeiVG3+s4XrN1eXST0XA8vJrNcWuy0KZ7fMscE9XjDu6wBP6qWsyKvkuUTop7JC15EEwRlPx1nfMi5AwemrOTtQpyZkN9GP7LeXz9Tjz+ypxOso5UhAa2bUIFjpWxkgYDptqv9n5gHtiUVAgc3AxUACHLnTxtTIM0axWFU5zu0KdtO7U9Avg6gODs63BhsIyhyjrageLDmLFmoMuff+pJCV/fdLmm6tHwioaKaMMl7pr
 N7IseAyQ
 AeqK2T714Gd5pcfd26HujXCYMHBFAwpU1n4R80lMbi4N5Lnu9CWzh3m6lfmngCler+++PVDJr3Fyqx/oO3uJj8F1O/HRUbQgmR+vpcoubPQHjXDyMJYDJ+b48Dr6WvuoLa9fdYFGrx7wHJ4lZ2wqrvS5hnlxJjBcvpcZXaEixeqL01Nys5KusqGnSbczokZV1oMVNvQza4qIO7ncoani79i2nopZEwE8GjT+RIqpnRPu0Zil28mVQo9YUdAuCc2AgrufW7LZOAZ4T8DgKizJ2718s+DO6DdX9rDB/pkZ8qphAuZAF740UuMUOmYGLPSjhm59MAPcFymgyNsplQqxfIBoOZI4yw7GUuqxKQk9hhFstmViA1Wlyb+wuTwoXAz33dginR1Q+oHYIlFSxJoC6lS6WagRX5i6+HdRFWE+XnI3bOcu0HND8Gmj4fm7fVb1KmqSwNLHb7czpyKmua+31228c4svX5AlzfwFMJuCozJS1m51ji/gm11tg3Dkuwp66tgbe7m1cdjfEzRzZz83skVUUD+Y3czqeTi4e9VhQV2kF1KqdDaJoFfDaew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a test that performs stack writes in recursive calls to exercise
stack watch at a specific recursion depth.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/test.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/mm/kstackwatch/test.c b/mm/kstackwatch/test.c
index 012692c97a50..203fff4bec92 100644
--- a/mm/kstackwatch/test.c
+++ b/mm/kstackwatch/test.c
@@ -18,6 +18,7 @@
 static struct dentry *test_file;
 
 #define BUFFER_SIZE 32
+#define MAX_DEPTH 6
 
 static void test_watch_fire(void)
 {
@@ -46,6 +47,21 @@ static void test_canary_overflow(void)
 	pr_info("exit of %s\n", __func__);
 }
 
+static void test_recursive_depth(int depth)
+{
+	u64 buffer[BUFFER_SIZE];
+
+	pr_info("entry of %s depth:%d\n", __func__, depth);
+
+	if (depth < MAX_DEPTH)
+		test_recursive_depth(depth + 1);
+
+	buffer[0] = depth;
+	barrier_data(buffer);
+
+	pr_info("exit of %s depth:%d\n", __func__, depth);
+}
+
 static ssize_t test_dbgfs_write(struct file *file, const char __user *buffer,
 				size_t count, loff_t *pos)
 {
@@ -71,6 +87,9 @@ static ssize_t test_dbgfs_write(struct file *file, const char __user *buffer,
 		case 1:
 			test_canary_overflow();
 			break;
+		case 2:
+			test_recursive_depth(0);
+			break;
 		default:
 			pr_err("Unknown test number %d\n", test_num);
 			return -EINVAL;
@@ -92,7 +111,8 @@ static ssize_t test_dbgfs_read(struct file *file, char __user *buffer,
 		"Usage:\n"
 		"echo test{i} > /sys/kernel/debug/kstackwatch/test\n"
 		" test0 - test watch fire\n"
-		" test1 - test canary overflow\n";
+		" test1 - test canary overflow\n"
+		" test2 - test recursive func\n";
 
 	return simple_read_from_buffer(buffer, count, ppos, usage,
 				       strlen(usage));
-- 
2.43.0


