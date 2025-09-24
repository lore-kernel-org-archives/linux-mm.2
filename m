Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 353AECAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 12:00:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 932498E001C; Wed, 24 Sep 2025 08:00:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 909E48E0001; Wed, 24 Sep 2025 08:00:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F8528E001C; Wed, 24 Sep 2025 08:00:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7017F8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:00:32 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E70F51407EB
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:00:31 +0000 (UTC)
X-FDA: 83924001462.18.79F819D
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id F00CFC001E
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:00:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zg3Q9Kyz;
	spf=pass (imf10.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758715230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tQq22tqtHC6AWIlA5VH2udrw6r/hyqmcjV7oYivMnv0=;
	b=UZ6no6FIS1x9FYxZaFfSGjkrwmsXfHoX3Mno/F6MnjvXG8mxvoig49hqDSGXeQq+CvB6Oz
	eTUTsGuXJkOdG2yMLyqWjdHr5rWnKFZW+OZVuWofTerZNkcXbBZI9xSpjz1LMnxBOCA2aw
	y88+nk65G6/E+WJiBUdvmKpzMnL7B+4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758715230; a=rsa-sha256;
	cv=none;
	b=SO8/QhWKAXu1Pi+wE5KHyPAyUG05tXxH0aVBIiVHKQib/FEg8UmRQOVl9wQhy5Pi7ld2Ik
	AhcIDXpiHgb0/yRVwZSi5vfSDi7T82eLZCIKmvno2GJmzQFGerSf1BDQze/UWiINla7IY4
	pY8PxgD2z/xFfZi2iLjYbzpk82c3/GQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zg3Q9Kyz;
	spf=pass (imf10.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-77f605f22easo1358125b3a.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758715229; x=1759320029; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tQq22tqtHC6AWIlA5VH2udrw6r/hyqmcjV7oYivMnv0=;
        b=Zg3Q9KyzPBxRfPNov0507HpIrGghe+OUlputUdRZTXi3xMcte6Eck8gUv4YGN5O5EP
         2HP2IDLkQX6xKTNRr3IH0LGgBwp6VEUpvpUmIsYE4D0BMicxS8SjAYd96HGES0pXBobm
         lehxra5Rji/YPQtEgaMYsXCGsAk293OfM+80ioIMSALk/qup5u7625g+KPLHj+BHFQJY
         elc2yMi6sUHYZ7lmDYFCftOQQlIxc8W+e1mcwa1MtzFBT0J7eI+U0a38NNK6hlktQQzc
         Sj5tdJL5HBzJE3XNkffCZO7Ml7LKieYZqx6GVcfLmEqkYCfd6gmJYMSe3n/ZkmmKkELw
         P7dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758715229; x=1759320029;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tQq22tqtHC6AWIlA5VH2udrw6r/hyqmcjV7oYivMnv0=;
        b=jw9rjjefcpURYI0V3AH7hdAl7YfxNMVod7XSvCbnAEQh3A8uJclxUmEdVMTaVsKrnr
         hquqeDVkcaXNAkRBbwfSOyIjCg/W9LPY/78jYyMK+GbHXZlMtuIgvsGbcqywAjLY1lc8
         tLhelNZ/OKOkj8eLk2ZMSruNix3cMjA3KjJkD8X0cR+ladsGNvrb8Y0eK/IZKQjYRlbe
         XcgRY/QZYZ4eHb5rDAv7rBRKrbV+s5a/F3UOzPTLI3nrlxv+2c/s3vdK2UmXBgpekIrX
         mZzeZ7LijB16sX3GyZjx6Q3ArnU1LOZDq1LCUF18T74MUsRbfts8LtIVk9IZhZyj1Pi/
         AaFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWe0KmXp2dmRsSk//oYfzGhY4qJCLi2QwLsJpQ+SCWZ+HDbkd9RLn3OrveH7S+ch+DCbjQncQ6+3Q==@kvack.org
X-Gm-Message-State: AOJu0Yzh8OARJOkl6j33f+TzdvVW5mIdebxK0wRGvVsiqWQaT5eeN9rI
	FLQvVhT1QUWVdgCi1p4UKurL7Zqc+I+7HaVDXjm116L06fmuIVpcJmqc
X-Gm-Gg: ASbGnctLcLTifi6+TeuXE2oKrEeUDr03PEpeAGH5fjoZ4rcUTQWN0feKhlKVIrdH85z
	8t2bd5sz2zQprl6h9X+TzSZMEM+q5Wer1nEiW+IE2cmUwf1B1wqEW9AyMUSNwwQGPpx98yn/kU/
	Veahffy4+TLuzTlWTItDY6DJgzZ008vMCY9P64TnoPq4NEojJTM1yJpPLxwaGKWlBJlulcKdUHn
	Zu0RFUuyakKIaGMY3X65sTqLKuePtJUpn3EZ2OhQ7zTQCr5OSVex6CiTVdjt31bkw4pUpQ95CtH
	jDAuqx+fwXnmr5+idDKZvSEaAeskgQ5mrGTr2LyohTZ8gTqkp2W//VkwDQriyX/EIPgA38RFB74
	oWXxnAgS3ZgcDNAkCsV4MPpeuXSstTorJqA==
X-Google-Smtp-Source: AGHT+IER+rSrafrjBOU/UPseufgUtgk4gzgFmMfLFbtCFl+/VmATfZlwQN/yKimg3zCqXqji+7ttQw==
X-Received: by 2002:a05:6a21:338a:b0:2b1:c9dc:6dab with SMTP id adf61e73a8af0-2cfef7df0b2mr8342943637.48.1758715228483;
        Wed, 24 Sep 2025 05:00:28 -0700 (PDT)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77f2fdfbffesm9620110b3a.73.2025.09.24.05.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 05:00:27 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
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
Subject: [PATCH v5 18/23] mm/ksw: add stack overflow test
Date: Wed, 24 Sep 2025 19:59:24 +0800
Message-ID: <20250924115931.197077-3-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250924115931.197077-1-wangjinchao600@gmail.com>
References: <20250924115124.194940-1-wangjinchao600@gmail.com>
 <20250924115931.197077-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F00CFC001E
X-Stat-Signature: 98wo1q6uhsk6pbpizpq8tbwqmba4wun5
X-Rspam-User: 
X-HE-Tag: 1758715229-641440
X-HE-Meta: U2FsdGVkX1/o/wclhZDup4uTsJZ/t7Te3JrozEjAKoHTEKDmp4myWIourhnL4zUlCNxdVXN0Q8l7D4lu7NdGu53GyC91AlJVN5p8doRW7k2CtPgiArNguaUf9zye2gaptG3qtPi0S6fYIf0Tj8qEnIv5Gi9CCGIRBP3fj/ILr6xinZzlnUHNjP5DccgnzHcYmJEsU5ksCOR7nO4zSHMx9ptqYL/GuYZ4Q12qLMhTj9XXYNf81uiASvR/AMKAX5sS5mzteOFcdhLpBTCFcV4+nktDMTThpK2Zc4xbnKBTNm7ekcfCRqtli+U6icIAKil5RTRI9EBW66WSsDRlwddJVfBesOSZqykeIgiilxnFjXO/B2lJY6yHlzRdJdITJhBaKJ/dFAJNeL+37zmzw8OFYB+rFn8fa0xtvkjoFlb+pikG4tvWNjdfh2mJtamrGrucGDLG42A+BJBYBF6nvvK/AxGGZ0KQbKJDpooTgdpiOKBTt5tLZ0yGzrVH9be361KArqSAv5lVO+X/VREUo1xafRptARW1mJXmIjp6XnHU8DWwI4ZP4nIwQZV9R1vdDNvyqjYAhrdrdURrb8BpkFTrhu2shchQ6HFzElmEubcsq2vT6UgPQtO54dutyO/4X5IxpF/2mkk6ytW6dQP9nOY534zXtPPB48NZrmMfm9bbf7TwMWBQWoVJIY3VyTDl2dIoKn4y7IZE1S99tyaRu5NStMJZWTRdB7qrMucrSBpxmIn96PanJ9AxXVXbLxLDSaowk0svlKWmSUBhRhql6G7otKXECxGQ47J0Wawn6Dfm0s893w3KRr4EXvM5bTIM7NNZPKIN2xh9y5YkoMgawZtM6aLKWA1us4qVGLQ6w81X1LkQ6A4VYNnv90tVFrN2HL6Ic5P+6TfQ+/4Jwc0dgWB8Gh58EtYu3QMsZvxsQJfohKhuesCOOtUEU2NlFh6ZwGhrj3z/HPtJvyVQMsvgiDv
 BaKD3U62
 tQt+0JPEutfjiM7K7rxlnfZRAJ/Cwhenwc3S4Mv0qGJa9xKEYRBRC7ghSR71kfj7iS9poPTHGib+l205LqgHVSMw0gUqIFUl+ntcYivNKz6OENTLcu7NGD+Ccf/ibPJJznVhV8aY1upqPFGZurkDd6sKBpGS8UJWJ0TctlL4z3phHCoJKFlY3Q2Uxdh3/WER0ZqwXu0nEaqjBBrAnFroReD7omZpiYEzGYkqSUT1IwHSHt320DicDUx+UvmzaZ8tBxNn/7iQExhs8C9g5OzERbNRsAYDr7N+J/aF7Yf6lTF/8haZR+gxO4TH4av91P8V3OZsKZBvs4Q7NmGh4rBp0p26IbbY9cLA5HunTOkttldLDkBZv3U3L9v26BDkkLNhXBQ7utGRKW5wXeG9/VU9ZKu/bJDQ9ZEtHC5PS6ywD2XibjRHdtVt3l3t+iRUbnKUdreUo04Q4NolomucgVJu+CdzC5H4lPlQzr34Q8EfT2I14nBbouJ8/EPPYyrEnDYnTp77X7nB1kYSbqARLah1PbynNfy7HZ0qRQ5gEzmHYW6iQuqU2bcIqUhGIXg==
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
---
 mm/kstackwatch/test.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/mm/kstackwatch/test.c b/mm/kstackwatch/test.c
index 1ed98931cc51..740e3c11b3ef 100644
--- a/mm/kstackwatch/test.c
+++ b/mm/kstackwatch/test.c
@@ -43,6 +43,20 @@ static void test_watch_fire(void)
 	pr_info("exit of %s\n", __func__);
 }
 
+static void test_canary_overflow(void)
+{
+	u64 buffer[BUFFER_SIZE];
+
+	pr_info("entry of %s\n", __func__);
+
+	/* intentionally overflow */
+	for (int i = BUFFER_SIZE; i < BUFFER_SIZE + 10; i++)
+		buffer[i] = 0xdeadbeefdeadbeef;
+	barrier_data(buffer);
+
+	pr_info("exit of %s\n", __func__);
+}
+
 
 static ssize_t test_proc_write(struct file *file, const char __user *buffer,
 			       size_t count, loff_t *pos)
@@ -66,6 +80,9 @@ static ssize_t test_proc_write(struct file *file, const char __user *buffer,
 		case 0:
 			test_watch_fire();
 			break;
+		case 1:
+			test_canary_overflow();
+			break;
 		default:
 			pr_err("Unknown test number %d\n", test_num);
 			return -EINVAL;
@@ -85,7 +102,8 @@ static ssize_t test_proc_read(struct file *file, char __user *buffer,
 				    "============ usage ==============\n"
 				    "Usage:\n"
 				    "echo test{i} > /proc/kstackwatch_test\n"
-				    " test0 - test watch fire\n";
+				    " test0 - test watch fire\n"
+				    " test1 - test canary overflow\n";
 
 	return simple_read_from_buffer(buffer, count, pos, usage,
 				       strlen(usage));
-- 
2.43.0


