Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEAFBCA1010
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 00:24:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A53A8E001B; Wed,  3 Sep 2025 20:24:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47D068E0003; Wed,  3 Sep 2025 20:24:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 392C68E001B; Wed,  3 Sep 2025 20:24:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 29AA78E0003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:24:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E9DE45BCF8
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:24:15 +0000 (UTC)
X-FDA: 83849670870.18.9CB4E6B
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id 13192A0004
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:24:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="MG/FPym6";
	spf=pass (imf15.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756945454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KOiu/GBUWD+aWp2OIEycImwBUVzT2dU285cFy6GfNhs=;
	b=NelrGrJTizjLhGFwQZpD3r+CNt7DD7H9xNqjYPgwg3p+UV9vKrnS5yiSGZdpRzY+ADRmGx
	0autYyfutcTVyDlzmNaJ16Y3N9BJEoyo1ULObnJ/SMSWd9erD5RPOkvSRNZQ/VuGUJnfCJ
	e0RGf7odQkm8C1jUxUxOLTqFG7b8HpM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="MG/FPym6";
	spf=pass (imf15.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756945454; a=rsa-sha256;
	cv=none;
	b=HRf43LXxg4AyZjheSq3tu9aocRaUAS/3XBza+SaXEhuzhoCNoPvdkGwA7B6vTH3c0Cp+yy
	Wl0eqjqNX1uOWACbc9Yerfie6th5o2DXlO/Ru7FJt39PpsIIBT/SLqt95ssGT7vfdMj+Vc
	REnG5h9Gtkq/dHjNg/vOTLSHBTWVoVo=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-248df8d82e2so5044815ad.3
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 17:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756945453; x=1757550253; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KOiu/GBUWD+aWp2OIEycImwBUVzT2dU285cFy6GfNhs=;
        b=MG/FPym6KL4gos1dvl4wsJNZw+4q23fMbAz6vVldoVmiUVzmKjY3m2H26hEJyCMg/7
         E012j/qcXz76N9WAXN7cGkwjA+LzfG7q6A/Ce5jUJ0hnB706RoBnjmIYZUvD2oTvH6m7
         zCbeOuPmIGYDkEVCliietB9vLMhrR06HEqYwmDZsAb1gwtowuAwFXjzFnC2oZxy0Pw2b
         Nn4EDeQZS7NUX+bQmXkwlcSG1zLtW3zx/r4bAtb4r4JL4vV7T2eCzZ63rXZQkwxy1sQL
         +jjAARm5ocMMnI75WbAJ5tjPhL7S3uRbjA+WDpX1oEB0fPuneY44N6/BbwFdbdCZ/Hfk
         XbbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756945453; x=1757550253;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KOiu/GBUWD+aWp2OIEycImwBUVzT2dU285cFy6GfNhs=;
        b=PF9kZxAhVYsC+8u8hqmskoOd5cbHPwhcteTjQvuoyaOcvwNa0a3mCyb/ml//04kejK
         k3QxeG9FrhE0GiOIL3ER/vJtIdhcEooshTUJfg3/fwf6O2n1XRDM1L/AZqTqVh03gEW1
         TWOMnIc8rZYu5CLcW96a88SbaVxlzNCiNofse0ehciJOIH8ySrRLka3yKQPkhVowHISt
         VRBET/qvrKUjUPnG0vwnzPvbOBCW6cjiw1Rni0KRfVntRXnYR16b+SFWrfAlJ0ZY0qmh
         26BpkD4JOV9Yn+wYxkvzDLEDfO32wmv/59khsyxk5nvOMI4Qfx/SURwkAKhXm8kZdnw+
         52NA==
X-Forwarded-Encrypted: i=1; AJvYcCU6JbGQo+aPM+hd13J5rYpj+B+sIo+JVXVkoz3fGjWyaiET4aG9eT6O7UGuRgO/zJBPyMZKciRYzw==@kvack.org
X-Gm-Message-State: AOJu0YzeiIstDUDxK/FwTfbOfrbwPY895Z59ecXg2N5OOUCLl8bGEeKq
	uWHlS05bxDufLD4ARHAmb/nVYp8gQzjWdVlT3IjQv7WnHoA/DoIsoyrW
X-Gm-Gg: ASbGncuS/V+xJGNmLgdwAxuUa+FZ7gkP9xSGHb9iZj3EoNswKwNb5GxyoHCePKtsR2b
	u1cDd8Wk1KpPGP3NifR3NyaVcrKmrpcfJCrIUGb5/y5IaYh9jgNojTvVbNbRGvuSZoOS4lplpi/
	7qjYvSvL/NrQoxLW77Ix/HOjibAw8oUnypj6TqI0wSgkrI11U7J8emnPtU5xO7r/swT4lGtak6E
	bC0kheNcyiFhP8uxUeMo4APvkwJ2BTP3AgN4yNfupZeISY5GIFzQoQQW544qyNMGehimH++aGOZ
	8U4vkwJ0mti72muHAjC1/q4KXrcu4Yule74wt4vhXTFhBgFO3dwRO093t/IObAfn8dJ36JTfsAI
	44iFOyoAYDSpfRzPTFoEs2D98wifaXhZBTIpgRvYWNMXqUvdYdIMLj6VueyrEhVQ=
X-Google-Smtp-Source: AGHT+IGlCKz3wi42oRDwUIR9PQQ4OHO3kKDWN9VDgQVuoZDIBj9URRG5PxCTyk/oUZhJZ+LJU2AQvg==
X-Received: by 2002:a17:902:c40c:b0:24c:b2a4:7089 with SMTP id d9443c01a7336-24cb2a4744fmr36622505ad.31.1756945452858;
        Wed, 03 Sep 2025 17:24:12 -0700 (PDT)
Received: from localhost.localdomain ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4bd2aesm17579551b3a.48.2025.09.03.17.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 17:24:12 -0700 (PDT)
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
Subject: [PATCH v2 16/18] mm/ksw: add recursive corruption test
Date: Thu,  4 Sep 2025 08:21:13 +0800
Message-ID: <20250904002126.1514566-17-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250904002126.1514566-1-wangjinchao600@gmail.com>
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 13192A0004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: g4s3mbbzfja76kj1znjq6xdpw9opx7c9
X-HE-Tag: 1756945453-525237
X-HE-Meta: U2FsdGVkX18Q9V71x9AahWwWIUiloJejnGafAtbzMX++/amD24ibyYnuNuGKOKFmI1bHLwk6Ff7G7HawqX/O6rAo9f/w3EnMFxzxDrryDca8j7od6EBw5g6KCZwYvy2hsXcybFZPT2Db8t6I7pOcm8RagQwuf9wHNiXP40H7x7F58ity2MKnckF+ovxvRkt/wvbzzloRqeDtA4R9ElxEkElNryL+4UbBwFiQ3lSkppfkoNEvN8GYSM404wGz7JNtenf2LJIPWQhOgB8Eh9MF4+zqhIzl6SSskb8uwDPoxaP+5m7E01rdnkLIIvYNY2uMxsoS6ddQi/4aV/rAeFcVL1KTnPPDXcBAY9oJLdMLjMpWUzJ/HKeH4llmbiGmckwx37rbyIijkMwq3LbZtXfSh6c4DDfHl0772WlrCudBsyb48EL3jBiV1V+HSL3YMKYus81MUIBHCjeWHWeIvXVpjkd/rFcxCg37QkoZaEOL+wXN+f/5lefuevxbe1HxhuXTFiQgRXYcv5ZmgHyIC3xXZpyWW7Blrf3G999AmSWxzKXIeJFM3t9q+yQO6a8JD2AJlNJM97s4Dh+wIg2vhxyUouaErHqYH3B4d4A+Wn7XqWAF+kiABdV5CU/RTwNcwTaLK38F+vQox1jx6aW4yVKiQz3hCZY9uwaCupwzoryQw9KYEdQ7pQMF/HE8kLhodk3Q+nwYYemcZeLMO4GW1u7Hu7HiV9KPTPz6FJqBNCL67PlQS5mSf1WzbLQD1joE4SWSLj/xGIaPXM2l2hVKc2rGTkWb7taOsjbDXcMLs9YfCj7G9G+0BO+lgSCBCMr97IDfpAr+dyZEYl6lB6ZnpJZtUgfrfpv4emULifs+6vJi60TYgXcFDwMBwNm/sRAa6xLS/uyOhYlAGH9UiZwY7q/U3UoEQotxoZ9kCu5Lm4jZUAmve9Z1I/I8Hdna1tfUjIq6p7BqX5siEN1dsvEpbi+
 qgbBdbCE
 SYh5C7rtbfnVrsNtV7mkKNYwKlHidfWajolj+sZmWBFjFvPqLyzetnu/IBkiADIjTGhZW2ek/vUswkXfaYhoEFgwez3AWK+0K7gDrX073VpjWTfaBgTMdvmcuJgp8Npo8yqVlLig+daZid60U0ZI8DuWCXJX5jOCv2QM5k9D9HlEq00Vr/bTbxES5IoUhLbFzhADH3sp4+8GtkJ4Z9BYmKZvgJm1750zvr8R/ZVJ0POwf49/bvspp2Q+QhvbRyTXV9YGJMHuqfrbJl8WAQVlwjm19z4smq2gCqg5N7GaaqeN5sV+0Tj+uB+4ZrxiPTGwZmc4W3i/woBsGUzyfq5GZ59tFy2sTcIAuE018fVAfDfW/uIroMIEE5jenImWZlx/3EuyK/tAHCYBxmyRknjouPNMH6SnKDvEOK6vbHwtDO7gsCLdPcDKP+zrIng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a test case simulating stack corruption across recursive calls.
This scenario writes to a local buffer at every recursion depth up to a
configured maximum, allowing validation that KStackWatch can detect
corruption in nested stack frames.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kstackwatch_test.c | 32 ++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/mm/kstackwatch/kstackwatch_test.c b/mm/kstackwatch/kstackwatch_test.c
index 1f0d616db7c5..cb216b6ee5d7 100644
--- a/mm/kstackwatch/kstackwatch_test.c
+++ b/mm/kstackwatch/kstackwatch_test.c
@@ -146,6 +146,30 @@ static void silent_corruption_test(void)
 		silent_corruption_hapless(i);
 }
 
+/*
+ * Test Case 3: Recursive Call Corruption
+ * Check whether KStackWatch can handle corruption in a recursive call
+ * Write the local variable at every depth
+ * Configure /proc/kstackwatch to specify the corruption depth
+ * Verify that the watch is triggered
+ */
+static void recursive_corruption_test(int depth)
+{
+	u64 buffer[BUFFER_SIZE];
+
+	pr_info("KSW: test: recursive call at depth %d\n", depth);
+	pr_info("KSW: test: buffer 0x%px\n", buffer);
+	if (depth <= MAX_DEPTH)
+		recursive_corruption_test(depth + 1);
+
+	buffer[0] = depth;
+
+	/* make sure the compiler do not drop assign action */
+	barrier_data(buffer);
+
+	pr_info("KSW: test: returning from depth %d\n", depth);
+}
+
 static ssize_t test_proc_write(struct file *file, const char __user *buffer,
 			       size_t count, loff_t *pos)
 {
@@ -177,6 +201,11 @@ static ssize_t test_proc_write(struct file *file, const char __user *buffer,
 			pr_info("KSW: test: triggering silent corruption test\n");
 			silent_corruption_test();
 			break;
+		case 3:
+			pr_info("KSW: test: triggering recursive corruption test\n");
+			/* depth start with 0 */
+			recursive_corruption_test(0);
+			break;
 		default:
 			pr_err("KSW: test: Unknown test number %d\n", test_num);
 			return -EINVAL;
@@ -198,7 +227,8 @@ static ssize_t test_proc_read(struct file *file, char __user *buffer,
 		"Usage:\n"
 		"  echo 'test0' > /proc/kstackwatch_test  - Canary write test\n"
 		"  echo 'test1' > /proc/kstackwatch_test  - Canary overflow test\n"
-		"  echo 'test2' > /proc/kstackwatch_test  - Silent corruption test\n";
+		"  echo 'test2' > /proc/kstackwatch_test  - Silent corruption test\n"
+		"  echo 'test3' > /proc/kstackwatch_test  - Recursive corruption test\n";
 
 	return simple_read_from_buffer(buffer, count, pos, usage,
 				       strlen(usage));
-- 
2.43.0


