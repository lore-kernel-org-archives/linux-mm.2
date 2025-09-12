Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF535CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 10:13:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3257E6B0011; Fri, 12 Sep 2025 06:13:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D6726B0022; Fri, 12 Sep 2025 06:13:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 177026B0023; Fri, 12 Sep 2025 06:13:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03BF86B0011
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:13:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 931581DF749
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:13:05 +0000 (UTC)
X-FDA: 83880185130.30.0895BB6
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id B2119160002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:13:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KSQSxu+U;
	spf=pass (imf08.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757671983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Mx/ZUXbIMqKSHkTbty4rSJVQCBlfpfdQjz++MJLD94=;
	b=IOl4Wm9ozDlGXwonWi+pgC1cYwaEcTclQvLLs4rHoiNp27UESQMhmfFNKSDdZLbk2+ShJI
	iAbDc5apVrRxIHY4WEc6qKkqsMl2cH0wtF+2FbGTtiMUusdtSam+BwmEGN6k0quKayNxDl
	rSwUjNVfoh6lLEl+aYyPz4S1KXfgB24=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757671983; a=rsa-sha256;
	cv=none;
	b=4q9jK4thiuUWBegt8LOE9XWg7U8Pyf4RLgTttq59qXb00So3NQgFLdiZygJqWPnADVojUT
	fcqlF3DoojZlbJF4tB9+qAIDQRRFL+zjhQ7qB1hCb5IqQzTpENEUrHiKQ2v1aUk1fWVy14
	erMU/7OntkCtqiuCVOCe9t/h6hayl+k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KSQSxu+U;
	spf=pass (imf08.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b5229007f31so1089760a12.2
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757671982; x=1758276782; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Mx/ZUXbIMqKSHkTbty4rSJVQCBlfpfdQjz++MJLD94=;
        b=KSQSxu+UuQTKlTYRNIQgwiVc4IriWvvZWJvuIxjklg19zIMznaJTSFsa+qCVNXSz1L
         yPJOxMcYOKPJInO84ZTMV2Uu5AoYHFL41SzUG394MMnkYGB1xF/TA1wKxnL3qMIhf+t2
         U2I4+Tn0h+5ve9ies/l98DMw4OBt/u64xKWRufqi8lnU26XfR0s3Ag5ayKYdoK3how5R
         p18dcyFWa4N8GmNmEGLNHgVwp7EYrYM6UZVfHibHS1EW4VUiCT5+K7XTngccQI/RGdV6
         jt+1bLgdbXaKUJU9bOGGLiBRkdiJljiBswFwlB53GCPmXyi1cBvBv6IWD7dVwT6fgY0B
         gWxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757671982; x=1758276782;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2Mx/ZUXbIMqKSHkTbty4rSJVQCBlfpfdQjz++MJLD94=;
        b=npjX6CrERBdDYPivNTbac2AKDlEWu7fOrklFSM1tpy2AsnaCZGufg4SnDJOOJU3q0+
         /7BPE/KX1MWocaZBbntmRUWVahLXbuAylgH4UoN5dZpneEgsLYokivTJeU11cySwXC29
         mnguzH3dRW9MOG0HQiG6vlgL2QMpvTx2TiLwOIv77DVcdHRBW0KUX4dtG6mOO/QtfIP/
         4ToqiyBHCGN4J8RtP4CtH1Ap5r+A2SLDoiwWQr9G9TU6Di1Mh4iOdrgjCnIR+VGMwh8w
         6gnssRVzqgTjfyGyI5sz4PhsQn97EVV2nRJFtSzCobtixaHBiSek7kbP3p3UBso46qqg
         pk0w==
X-Forwarded-Encrypted: i=1; AJvYcCWReSrzxKvalWWjP5Bd0SSKoigABo+sfXkKa0WpHTK9MSKh6LaSYWDOKBc7pO8hauS/x7Rkm3MHAQ==@kvack.org
X-Gm-Message-State: AOJu0YyzV+ryK2Ozuz2A5gwAjHxNrTBWxzc5DMf5z2zq2aJ1Z9MReqY3
	KrH7nKIaDgzqu2+7McQvvtkzdXgjo13Ne9Tt7H0VOWdV0pXoBNi7sRQp
X-Gm-Gg: ASbGnctk6X+FyFdWbW+MdfzjP050HdNmqYCrJzPdxiNk0KVh+4Pkc3GWNzKLCOzxCh9
	7qOYn31y6WW+VpV/Ft1VAM5Ie9Wpc6UHWYGOBhOpkxPdYOusF78J/QQwkex092cWpWjFg3m+frb
	s9qBLy1P+nWH9CXi40YOsmS3zXcENBsiqVjA70GSgwbl49Lor7fXos4NtMrAJmDWZcKgRAcRASs
	8Ii4cVCaQgyVoQqWiPlaTh7omraV3qo2/a2+b6J9c8vcLC5hprnAyOF7t17sm4h76hv/BI/RBbm
	39kAHqcYrll0Id3wG91KKVcSxjKVvB7JYFv++BL8dkWLyya85JKMrFD/ifsqcqjl2vBFVNm7D0R
	GFHgrKLRQ7Lg8raDj7J4+xy4OzajcrT01TFC9h9Mt2TgXwT67+A==
X-Google-Smtp-Source: AGHT+IE+4u/LnZqfy4mSwj4sJkJVx6sl0nYi/VrPz9wqHW9cd8FRDoTWUsuOoKihHmm7ZzWEk3p2jA==
X-Received: by 2002:a17:902:cecf:b0:251:493c:43e9 with SMTP id d9443c01a7336-25d243e79cdmr29426295ad.3.1757671982485;
        Fri, 12 Sep 2025 03:13:02 -0700 (PDT)
Received: from localhost ([185.49.34.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25c37295f9dsm44540355ad.55.2025.09.12.03.13.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 03:13:01 -0700 (PDT)
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
Subject: [PATCH v4 13/21] mm/ksw: manage probe and HWBP lifecycle via procfs
Date: Fri, 12 Sep 2025 18:11:23 +0800
Message-ID: <20250912101145.465708-14-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912101145.465708-1-wangjinchao600@gmail.com>
References: <20250912101145.465708-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B2119160002
X-Stat-Signature: r1tkud6botxse97e9iqfc6oj9ymfkrkq
X-Rspam-User: 
X-HE-Tag: 1757671983-452313
X-HE-Meta: U2FsdGVkX190UFEXabkIkChRgoqN/++28TYSW3zlfR57zOIv8Se/lV8BVPpEt4ZYkhYYAS7qvZXm0mq5eysGFMRBIy+/xa8ShoThLld01NHZPosv0FKfC/jQIqcyM6THDGV/JsI81CJe0Rtfxv4gzlVD6Q5YED6p+3ZpgVGeJgY7R9kZBJbSn0vLNMIb8dX9iRHSutszRFB+KzYhqJwFrseMUPETpobzOljX3+o3GN249S3LX/KMsp2oWedEmfG5YiRnvwMN90PyegWhqDWQtNhIDk2srn4HG6nnPW065qHw6l8qi5IkPEBv3vyHp4dCkPRfnbY4QfWsVgaeoZwvYLL+5KaeM0SWk3v7mIcYhFUGAz2dceO9TupPbOBtDztkIHFliKGMG1i/TyvNGk2iBdqgASkDZrtV0WB3QtI0rSThSHkqy2aPfliVHjYtMui84SyTrwRkxDH9/veMMSevPXZWDiumWIRVDcnrS2BXyTTRJKMU9Hzxi186hlZQJH8Ot5+a5WC1rWgxOQ2mKmB4PxY0qLbOl9M/Dc9U1iZaMwrMSqON4g160xkFwRujiInQvOXfDBfhAVOBbTUsA019sKUGOe6dctOXMXySaNlWI/4/4deFW9LtdLtaKfkW3qHiiBEFUq/RFxDF5kHirWhyRA0OAEDgPpziJz03M4yegNX3JxFYas6arxOo5x6KlcFfu8w75pZht2ZoGffC16x7vL2sBrXl0EKw625XmeV2n6F0EzCrkLMj3LYLspsYKdKf7Bt9sGmgsaAU/h7TGCltL0rqgwmBQ/0Gh+E9IBZmYw2q1RGnNNLwE6P2W4zwlSZiwa8HvYD7LpwfA5jEHXN+iJpLWCS3Lr0yObjfEQb3P3HnJD63Ls1MyPWd78EUo1R9tfgKM+yytajnw8Eti2LlHneQoQ4S7ePIRH9WTPxShxzYjcfL0bb/TnjNDOBKxnHYmCtybxIhC6Z/Jjx9BoV
 R6J6kSGN
 fRRreACYoLIYGQzZoS3GYU8rM7VH4zXBHVveR9G+c1JOlayiWbDsLjMGVvdDk9+F96u26KXlatbkhrlILPygQjQaVVd0ej4Z0xEOv/LTEPyahkDFUudp66ibYI1JRUsFLaaZk9JJ1jsLRAOoCPZO0IRZ+akp5bkuMZMp15iU3afUWD63ZodenuU3+Qbqvzu83a5d6hL/TdfsUjefxXPh8Vn65rDq6TQFj5TEFmSL2D9jIkDMxf86v0HGL3ChEUC++Q6qmCjSCvObdIqF13etF2x5SZoFVej4D8GEiOXTmZwldZnCUySpu8/BPhFm8Z5SYN5E6ct12cliRD/aMb51ZAq5VWUvkcNGClsg57VzreOykLvnGGp9uS8/LXhzW9PoQW4ycU+z8854Hm9lHYV6Nt9AjH6stD9sDqnGVsj4SQgaCBzVDir8WQMfxihjNa81sB7041uR7vZ/P/z3Y1ehkT1m6YC9IjLhT7BTb6B0SYQ6C3SBn+ZW6nBJdcIjDsjRV+Jc3oQp46L7DOWuvfaNcQ73rANAF/FfsToN9hUC0NpFg23emt8KUlg1a+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow dynamic enabling/disabling of kstackwatch through user input of proc.
With this patch, the entire system becomes functional.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kernel.c | 55 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 54 insertions(+), 1 deletion(-)

diff --git a/mm/kstackwatch/kernel.c b/mm/kstackwatch/kernel.c
index 8e1dca45003e..9ef969f28e29 100644
--- a/mm/kstackwatch/kernel.c
+++ b/mm/kstackwatch/kernel.c
@@ -17,6 +17,43 @@ MODULE_LICENSE("GPL");
 static struct ksw_config *ksw_config;
 static atomic_t config_file_busy = ATOMIC_INIT(0);
 
+static bool watching_active;
+
+static int ksw_start_watching(void)
+{
+	int ret;
+
+	/*
+	 * Watch init will preallocate the HWBP,
+	 * so it must happen before stack init
+	 */
+	ret = ksw_watch_init();
+	if (ret) {
+		pr_err("ksw_watch_init ret: %d\n", ret);
+		return ret;
+	}
+
+	ret = ksw_stack_init();
+	if (ret) {
+		pr_err("ksw_stack_init ret: %d\n", ret);
+		ksw_watch_exit();
+		return ret;
+	}
+	watching_active = true;
+
+	pr_info("start watching: %s\n", ksw_config->config_str);
+	return 0;
+}
+
+static void ksw_stop_watching(void)
+{
+	ksw_stack_exit();
+	ksw_watch_exit();
+	watching_active = false;
+
+	pr_info("stop watching: %s\n", ksw_config->config_str);
+}
+
 /*
  * Format of the configuration string:
  *    function+ip_offset[+depth] [local_var_offset:local_var_len]
@@ -109,6 +146,9 @@ static ssize_t kstackwatch_proc_write(struct file *file,
 	if (copy_from_user(input, buffer, count))
 		return -EFAULT;
 
+	if (watching_active)
+		ksw_stop_watching();
+
 	input[count] = '\0';
 	strim(input);
 
@@ -123,12 +163,22 @@ static ssize_t kstackwatch_proc_write(struct file *file,
 		return ret;
 	}
 
+	ret = ksw_start_watching();
+	if (ret) {
+		pr_err("Failed to start watching with %d\n", ret);
+		return ret;
+	}
+
 	return count;
 }
 
 static int kstackwatch_proc_show(struct seq_file *m, void *v)
 {
-	seq_printf(m, "%s\n", ksw_config->config_str);
+	if (watching_active)
+		seq_printf(m, "%s\n", ksw_config->config_str);
+	else
+		seq_puts(m, "not watching\n");
+
 	return 0;
 }
 
@@ -176,6 +226,9 @@ static int __init kstackwatch_init(void)
 
 static void __exit kstackwatch_exit(void)
 {
+	if (watching_active)
+		ksw_stop_watching();
+
 	remove_proc_entry("kstackwatch", NULL);
 	kfree(ksw_config);
 
-- 
2.43.0


