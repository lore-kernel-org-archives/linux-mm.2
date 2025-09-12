Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03652CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 10:13:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FAD26B00A7; Fri, 12 Sep 2025 06:13:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D2656B00A8; Fri, 12 Sep 2025 06:13:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C1E56B00A9; Fri, 12 Sep 2025 06:13:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C54D6B00A7
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:13:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F127911AC65
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:13:30 +0000 (UTC)
X-FDA: 83880186180.01.4BAC6BC
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf11.hostedemail.com (Postfix) with ESMTP id F159540012
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:13:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fpzk+keC;
	spf=pass (imf11.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757672009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C5u/a2s8j5yqiSFbkPas+Re9l+zCPojPRf0oLtuMcdk=;
	b=V5oSzkO5+sATXWipQDvDP6rj8VVhjkBLvuKcQ5OQwIR+66ZUdmILUDquvtkeOF+7b78Dth
	o5D4UR/a//8uQ/oFSkDTstzNU0a8FZcZ9wSRYfnJ1uJPxa0YfKaaAVe7ObzdKjeoSgK1bj
	lnhXDthicytsGOQr9hfWSEOXfuKtJSU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fpzk+keC;
	spf=pass (imf11.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757672009; a=rsa-sha256;
	cv=none;
	b=i+mmWguxGCqFGL0JIVM4kMd1FCOSjl0ta4nmwmogBMTq0dmSoDRobxp9lcl3EqXf79WoGZ
	SpGXYJUeMJ9yx06qXIisykwiunWfZCcHDUbvw51f7S7VhLk2wPco/hPEc8OhjiFeWPJRDb
	g2jJN+y+kwonBmJYcUn08z7kuOnVLtY=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-25caef29325so11980435ad.2
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757672008; x=1758276808; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C5u/a2s8j5yqiSFbkPas+Re9l+zCPojPRf0oLtuMcdk=;
        b=fpzk+keCyMu0CKjCCsoPf02InhhPH6h3ljU1jX50UKFb3oe0ZRscMERtZ3DL8Hp5WT
         hqhTpb5lfuHotYI216c1LP8BkyEJpiYNKvmA8K2BhEUqnEGCJI0yoX2Rt8r3PVxsVeru
         tk2VvSnf71d1KeIdgH+MZiGqIyvjmx7Se/Lu0UNn2SwZ42AMMS2fEk3CLO2oochllen5
         bi1v9PGmbHHlaP7OHjR/OW1gHi/WFDuEbY+QvMCjmivRxNUkaTJiU8QYv1ZFhFrIC2eL
         92iPU+HVwQMqGi40dIS4KdrDycNT01FhNOGnHPqIDH1wY5vjmSsMBb+n4gprH+x+H9dy
         Qwgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757672008; x=1758276808;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C5u/a2s8j5yqiSFbkPas+Re9l+zCPojPRf0oLtuMcdk=;
        b=sjq1ekF5iRS8fEqSdpxqylFB+GzaWBAmgb7pnRLd1ChAVC1XjFnBTctMUor9nu+UaC
         8xr3MAqDEgw75IlhxxZYXfNAyLWmjKfYHKiPaCyEMlid+9220CgY6J4WcT4Q6SYhbyat
         26rNS3o0fhsQBZ/M/r0Z2kwr2RuXuLtXULGPfAVVB6O3TGdw01I9yb24PNh8N1GjGX4F
         8oX3ttsFXCjlpgA9Dafjch0sBIfH1u265puCVAkR6KiWA3w6p7yLoUFjjbAdr0rBfG7q
         H2a1/GNS+AjE75u9TBwjrP55vVVjV8rjuuAicIivl6aM1eWL1Vy+WgvHCNzpVmMacfvK
         usMQ==
X-Forwarded-Encrypted: i=1; AJvYcCUlhl/zHOphBNyjvt5xewv0HBAj84VpT+wrmtFrwso4YnBNCJa3Xrtk3EfNZvVy9pTETzQKUquH2w==@kvack.org
X-Gm-Message-State: AOJu0YxXdOwA2WoocWUc+oA1SQjkkJToiGq1Zdd1uOuqTxbAv++qu5Sk
	c8ko70kOsXY8ZGvDavvqZ3vx4+akAj57ZrnsrUjoi2guoXPuuv+9FHaJ
X-Gm-Gg: ASbGncu3xKV5rOzPCjd1MFg24d5TsrWpVZ8ccphFHSiXKPL+2u94ee7DwIUkGu18bNv
	YlHeyVfvpd/6OKWbnvfJnWtVw78wqoIR1BW04t/rK22Q+boD7QeZWu09xTcgv4W911mMS5ZUCOW
	nGNZyokAauHD4KOOvEqHoA+AIZReu3+y3xNSKzPPjZJeo1kHbWJYgLoCdsvj8OHYYWjoDQqXv4p
	QdEDjPex04smvTCLB9g5ulmdOFesW+0DBTCmI+uj96n9gVzlP4cHEPpwe9xCdvB0LVRKx2C+4Ty
	iXijAg2+SL2Ri+X3h/DX3zbt4o/xjUx0X3gxnKIczjuLN8j+OG7EktsawmyvFuNYnII90uZmC7R
	e1mv5se8hKZYAk/GdJIsf+je5YiGuns6bYmg=
X-Google-Smtp-Source: AGHT+IHfq4U4MFqDIc6ZxO6yNatWwL7n6+/zPGuAMGcOfOLtnumo4rnkiu74aB1UWkUMdayihYaGMA==
X-Received: by 2002:a17:902:ebc2:b0:24a:ceea:b96f with SMTP id d9443c01a7336-25d24e9dc1dmr34403925ad.24.1757672007735;
        Fri, 12 Sep 2025 03:13:27 -0700 (PDT)
Received: from localhost ([185.49.34.62])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dd9509002sm5179465a91.0.2025.09.12.03.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 03:13:27 -0700 (PDT)
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
Subject: [PATCH v4 18/21] mm/ksw: add recursive stack corruption test
Date: Fri, 12 Sep 2025 18:11:28 +0800
Message-ID: <20250912101145.465708-19-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912101145.465708-1-wangjinchao600@gmail.com>
References: <20250912101145.465708-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F159540012
X-Stat-Signature: iyrujyfsryfxhsz4aucj3c9iu17meske
X-HE-Tag: 1757672008-113827
X-HE-Meta: U2FsdGVkX19r43NP2dcz7Y3HCXzF74U/PsYDykXV8MyYnlYjrHZUVsJ5N2ob0OuftzeZd4ll3kfIG8+W3cA95fmd5WuxR51M2N6Tn4iMmPEGtlpoWGuTC957WHMgvTwBahVMyKogc7f+t0sPyvui4h0QzIV622nzJzcuZlB33PpANZ+zyvjOCd8xTbKsNbL9v79q1qPHgO1lJbPdJv8ltRD+S2R6DvrJVDa4fO+plsjj4OxP11AxV7t6qtqFeQVJsMd1A4kJ1ytWWNwIt+cvQhIodypjCXCySVRB2YPa9ut33ZHRIlCuF8FrnaAqnGl2gaXGBJgQ7HpdTVVBdrvuvFUFqHNm6QIsadkdINQi9WoPK2VAbpmlB50prk/Ua4kn4g+OKBHWs1upxFZ9oTVrEnusDmdhzd7IQiVF5ZA/WF9RHYvwxi3QwMbxR4MTgxrx3jDJuG90xWSuBmSwVQPYgc8KuugA+KP+2xABPwXnEUBy51vAPP+nThEUYyPiJPUkLhHsPtHFGpNYnjKddx150U2w4kGcsqw+C2lZqqeChpUpkdPxeNHGReF3ZglRogz/6mpSDd6DwX7hqm2U4Tw8/CkttYPSwdpBo2sTCpGAzViDtodubfdu8o786ojGjBEUzHiVCWO0b4nKPGaJ+KHUcEly9Fx02+s3wGR3e0sOw/jozJtxhM3njSVx/PDHJ7Re5CFHsDbqEsU515USJaYjajYdZ3ijmmlUKfX9zzbPoaAasyGFkNyZrv0wYVrigW12WUJ7KyhxRPFQqUn+MqyLTNxsrzso5mWfHPF0MGnbtN5m6Af+akrV13ButHhQPdkKcVTUgh7A7ITQlgDBVwT6q81IBgPaKt+6wdKzf0aH6ZeZVId+I38ZFgRImK9v/1D77DlnIXmAhsb/mPY75MzV2r96D0O2OZ8JL6LPb4s7zQLuYfUZJq4TkbQivO0eb14/TJvDpqrBsJrX8NMuWpR
 zk7bt9RA
 M9Wq+W0cqFzp/ZNb7WZtP+UgW4QDP1vsRgbh5UUkM5YV6yJCaGqivOyHpsgUxbAYm31SV6vEIKs2ljrDYOnEbBIcOm8euB5h0m+Bsi2tnUoUC4rEg6W288LwZ585f1i8cIAjhIswvYvpOz0pLIlppCpK9Mb2MGOhg+lU67IypNUnkk5ME+jKgQZdS74u7XNwprFQabBqw9L5Z3Ck7VChjODodNAcnNKrpcSYv62Li5r8ecCWtHMgtOeikSAF+ftjIs2IgY2h1T9pk/t5+3stptd0SyaZgDTo2gE0SmtHnxmGT+Y6PzDGP0ylW7B6r4gfwNs9GnuX0hOeAjuhq0eqvMMHgfXpRbfhd4DUO/ctFcV2Om8c2D8or6Mtq6oXpMopmLEJbv1cqBUn9h3uuE3ymKM4repOwTjerMOghN7zK9XykwJDGwvxfPV1noCbt+jATKkk5e/TEgHele2UCC49zJpTyf/KXuGoVi4BSNMaBMQCKr3mbWWKmFNA8/Ow9HKio2oHBCfqQHIc3ey+kh4o2+BOBS01iAA6ZhgFRHB5BDYn6SelMpB7/PjriyA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a test that triggers stack writes across recursive calls,verifying
detection at specific recursion depths.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/test.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/mm/kstackwatch/test.c b/mm/kstackwatch/test.c
index 2b196f72ffd7..3e867d778e91 100644
--- a/mm/kstackwatch/test.c
+++ b/mm/kstackwatch/test.c
@@ -150,6 +150,27 @@ static void silent_corruption_test(void)
 		silent_corruption_victim(i);
 }
 
+/*
+ * Test Case 3: Recursive Call Corruption
+ * Test corruption detection at specified recursion depth
+ */
+static void recursive_corruption_test(int depth)
+{
+	u64 buffer[BUFFER_SIZE];
+
+	pr_info("recursive call at depth %d\n", depth);
+	pr_info("buffer 0x%lx\n", (unsigned long)buffer);
+	if (depth <= MAX_DEPTH)
+		recursive_corruption_test(depth + 1);
+
+	buffer[0] = depth;
+
+	/* make sure the compiler do not drop assign action */
+	barrier_data(buffer);
+
+	pr_info("returning from depth %d\n", depth);
+}
+
 static ssize_t test_proc_write(struct file *file, const char __user *buffer,
 			       size_t count, loff_t *pos)
 {
@@ -181,6 +202,11 @@ static ssize_t test_proc_write(struct file *file, const char __user *buffer,
 			pr_info("triggering silent corruption test\n");
 			silent_corruption_test();
 			break;
+		case 3:
+			pr_info("triggering recursive corruption test\n");
+			/* depth start with 0 */
+			recursive_corruption_test(0);
+			break;
 		default:
 			pr_err("Unknown test number %d\n", test_num);
 			return -EINVAL;
@@ -202,7 +228,8 @@ static ssize_t test_proc_read(struct file *file, char __user *buffer,
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


