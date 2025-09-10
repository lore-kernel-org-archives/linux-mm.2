Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC644CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 05:25:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22C608E0014; Wed, 10 Sep 2025 01:25:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 203FC8E0001; Wed, 10 Sep 2025 01:25:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11A028E0014; Wed, 10 Sep 2025 01:25:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 014518E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:25:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A201911AB2C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:25:55 +0000 (UTC)
X-FDA: 83872203870.06.AAB2D44
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf16.hostedemail.com (Postfix) with ESMTP id C387F180002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:25:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JBmyvQGa;
	spf=pass (imf16.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757481953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mOx6p8YhFEr+hG/yZ9Zg64+RQ0caUuIY8LjmjDVRe3w=;
	b=StPVQ6/Efc75QtsNg9i4epBv5hTeA2X4P9l01mE2QP5Os97Yaz/UxllxuNylbZO5Xbq2pv
	i0/Dv1v3atkK1vbvK1HqAU+DIB9c+gqnNy/32WB7wZ4oQt2mikZJan+9mocORrOaynCv9A
	VDFS2tUlqQb3nMjqIt3nDJ690GR7ims=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JBmyvQGa;
	spf=pass (imf16.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757481953; a=rsa-sha256;
	cv=none;
	b=0wb0TvMqn0gFZPT/rZDb0NVm0OuuQTI4yooH9MDFasBIHAd4QbZmdZIjpBxZNAitFVuiHP
	ViFNVUSo9rhhqNHo4yozIQni4nMGvlzEgErUVcS7Xy2+H6D0+NrQ55zky/nQ1cXMYNIA/y
	1VjRPYbGMuF4Ja7+5VKtnYjje5QVUek=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-24c863e852aso57630275ad.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 22:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757481953; x=1758086753; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mOx6p8YhFEr+hG/yZ9Zg64+RQ0caUuIY8LjmjDVRe3w=;
        b=JBmyvQGaWZ66E7201lIbxAroVDBJZylHXOjzozjP3eeo/OaM9M1Mj/UzPHSnBVM82b
         09jMYO3kvov+qq2DK7+/piWYScGihhFTFx1YKOJmg98NidvqIMpuj+9t8exPEQMlZKeI
         lgMesUGRpw6o0mgmIWohMA5dyaDYvKX17YLMNO+xkCOo4srcukHDCzMw1tKcyZeyqgUI
         Z7WW7dx/VTT4rG1vphINyzRihY3vlzIcMJcUqxofGzF9HV4El8BnJZrujeQ5BQfUSIF6
         WF7axiQEuzHCdtH71E9sr3hwIWvZUv+fhznQrX6nFGsJ2Joev6ggQPFZvYXEdTTr4vrG
         ouVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757481953; x=1758086753;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mOx6p8YhFEr+hG/yZ9Zg64+RQ0caUuIY8LjmjDVRe3w=;
        b=tYHOlET9Zr+MuIfWatPMJ6JkBR8OyiIdB0IbBPClFwWwUcF4nHGutCCG4exKtju7FC
         wR0mpF4f5yNg2Zm7iXtusepHLtp+rCLvzlzHkm2bz3ZB1ivsjtpk/h5vEl/FnEjSFuNH
         B5yEwm+66ksXF+zEJY4J/G7O1W62Jp6zNvnt5pUChxUlCuVO6UMZz6V/7/1qCw/WyL3K
         K7hNk6Pm9sdrqiu2A3eGbLff0DWxiqo5svqHZW2ehx77IYsAgIYbbPSKTkADn1YRDW++
         sLOCNsyt48iUkhFrwq+mxP0snQCVE1v926V4YjXp9P3HGKj+l4U+/oAJJ+Mzz41+9w6n
         8Drw==
X-Forwarded-Encrypted: i=1; AJvYcCWWkbIVQAZ8miAMg4ZjDmUjjW+9kSZC8p3GTlvRcwYcjTxu0ImHx7BcPopaApwzkk0cmdscntjSNg==@kvack.org
X-Gm-Message-State: AOJu0YzNDkKwu+BMgmKKMOYhHAP8W5kAQQvswVCFs5TpvzPU1kCppdXR
	ajcNuTu17fkMThiwBrP9ORgx5qSYq9J435qmv2xalGxIYO1QQ2iEqtpN
X-Gm-Gg: ASbGnctlJs+9ac18veAw15ulUVT0y/YdKKKk0vr5rnmbBiMSq4yk0CgGAsE0FJmfT1G
	Ov0O1Nr82ETRk7bPjishs7xQuptJR9bcZfikSv68OpIztclBnCjTM8D3Su9UlKiWgzlVOQvt0Si
	nHZVxd4k9eMG2fjvmd9y15IUflSC0tHvunMvhhpIC9p2ryOSNjYXNGf3fKBI2cOmKeYgylqDIoA
	BVuIa1/0Z11CVF4WKPqX1PRPztZDcGyXPRrq73+T09R7cvs+AlY7AcwXNZg70EH/DzIYXQv+LAY
	G0w+X/fjvdLNDW06u+HlsIWvGWeun+GVku6f/xG1Um9gMmsNOC2PA4GXl/tzvr5V8t8gwhP8g3+
	R6xDW25fM+XQdaj/td4m8gr6UZyl/ZhbteQ==
X-Google-Smtp-Source: AGHT+IE+2ZvUwlvbAD3bNh5YTXYd3TWYyXRPD2VsUudLsG3CxrebrDDY5hB3nLhTzBib0WtkqPJfKw==
X-Received: by 2002:a17:902:ebc6:b0:246:255a:1913 with SMTP id d9443c01a7336-25171cbfd65mr173971245ad.39.1757481952659;
        Tue, 09 Sep 2025 22:25:52 -0700 (PDT)
Received: from localhost.localdomain ([2403:2c80:17::10:4007])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25a27422ebcsm14815125ad.29.2025.09.09.22.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 22:25:52 -0700 (PDT)
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
Subject: [PATCH v3 07/19] mm/ksw: add atomic watch on/off operations
Date: Wed, 10 Sep 2025 13:23:16 +0800
Message-ID: <20250910052335.1151048-8-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250910052335.1151048-1-wangjinchao600@gmail.com>
References: <20250910052335.1151048-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sqtub6ma3b4qu94yksx3owkrqdqmgbza
X-Rspam-User: 
X-Rspamd-Queue-Id: C387F180002
X-Rspamd-Server: rspam04
X-HE-Tag: 1757481953-436234
X-HE-Meta: U2FsdGVkX18i0921GXjpW8JUmemNV5io/hJvOfbFLXrlq/71qDFhasK3BB01MXl1gGq+uqo5aiCeZIRaZ9D1dTxrd0PzonTfcdPFNOvaa+xkmj9Gyr4cFwuKO+R2UarEyEvZ+oXuBD/SUt9A0WYkStBdox4OJb+e+7O10hos8fhnPNAtIKw8O/BJ3nvnd7eVWRWtsr2+pPh9g6qBfxeMq77+fg45dHlb5MRexSu2Yogcrq8DuA3qg7sS3Y8TULcPwpi2bXzaOVBbtWwtPB3LViQsI3CkUbr72VXnHzRXQv7wly+YoVnM+Bwzn8SJN35KOjUSBE9bf3457ozmNW4K6nFw+hMVm5J43oragbbC1ccca3ICjf28jpY9AJroAkvgm1nu39ATCsJv0sHYwPlVUYJV+Cf++gUWNqUZ6C+qCYxbfA2q406og4J2ohOJtfAaYcYM76/Ok10SSMY/ebqZ9iMEzcq54OzpMsECmT9kJRf7LRWKg6SXmYls8GjvB4Dva3QCg9aBKswlgTH3QOvE04/DQYBUx5llzoYEtvIe9MitECmH2VwdOwlIbIouSaUDicfBFTwrYRwmiVE/EkXv29dVT7A3tMERSqCU7rfZrgtid+hKVPcn8zKmtSZVsu2xGyfl4Q7BUDXhyIPalz9kACz8vmfFCtd2k9++fNoadkFOiDUjo1PFhzaqB/y3Z/49jtporO/hox8zjcDG2y8YAQs8JUhMNot3G9NTfplsw3yaHVg57Z3wmqsd7iGw+lf0sIBQhFywamCOnZNWRP+7/GxDpgrzIIeJM0Uk8XfIak/BD+2+Y/240j4+RCQXZGn0pgIESvUqfLTetKojzG2+ouJG4KtBf6LXSSJpq2oQ4lSA84pHzhv4jcJ755fxXS2qzAI07dpoJciGgFwOwb4BgijqxWfD8QZYPsNI66NwKpM+MyiQjFdY+2UbTqFWJ1p82O97aq3qMZrdVb/jnD9
 t6krx+Ub
 eQtaZwMGTM015SykpRSlb58qnyXz2A8xfH5h2c5kj3tuF+p32h+vkhsUFtXzJ0V5sps76lZ49iCyWsXOjEvgeMut/tvdPmZIY5Gl44Z/wLbqdKWJDtsEMaydwn2DEk1/+jltnR/bJ17OBlWX1IhOi1dOFT/rh0QsUAtP1s0P+f+cMkuN26Mq7kQx6iYkksZ2E6frsLGmrw9gyZgzm0EhWYMiXKuFKnyEu0jSe5P/cXTNeExoiua8otx0juNU9CoaC7INYZyMGrMHsDA428yEPMo5vje1cWOrSclb+dtg8dG9mjvrXs2C7yX5L+G1Sdz5BSWc3zGUf/k5DWeN4AzWrzK4XVhmy46LBh+/mQ0qz5w+9JbGO60RF/DqejtnVvIIzMcEil/BfMMzXRJ6qgnBgmYO7neaVaJ9BrXSfvc/scB6T1epo0CZxU6n5Y/ujboWBvVt8nA+ceLAYMwe+6L1I0vlEhcQSFdmdTbU1mIhTmtdXk5xQ8xBLCvFD/T8kdiYugiEBvCJiczzjkNU0MT3gZqdAT0aMG+OrfdgC1b9M1GcmFIGxTfTwaEHhO7okr0CQcABrR67izXe8v88=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support to atomically turn the hardware watch on and off without
allocation overhead.

The watch is pre-allocated and later retargeted.
The current CPU is updated directly, while other CPUs are updated
asynchronously via smp_call_function_single_async().

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kstackwatch.h |  2 +
 mm/kstackwatch/watch.c       | 95 ++++++++++++++++++++++++++++++++++++
 2 files changed, 97 insertions(+)

diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index 3ea191370970..2fa377843f17 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -41,5 +41,7 @@ const struct ksw_config *ksw_get_config(void);
 /* watch management */
 int ksw_watch_init(void);
 void ksw_watch_exit(void);
+int ksw_watch_on(u64 watch_addr, u64 watch_len);
+void ksw_watch_off(void);
 
 #endif /* _KSTACKWATCH_H */
diff --git a/mm/kstackwatch/watch.c b/mm/kstackwatch/watch.c
index d3399ac840b2..e02ffc3231ad 100644
--- a/mm/kstackwatch/watch.c
+++ b/mm/kstackwatch/watch.c
@@ -3,16 +3,23 @@
 
 #include <linux/hw_breakpoint.h>
 #include <linux/perf_event.h>
+#include <linux/preempt.h>
 #include <linux/printk.h>
 
 #include "kstackwatch.h"
 
 static struct perf_event *__percpu *watch_events;
+static DEFINE_SPINLOCK(watch_lock);
 
 static unsigned long watch_holder;
 
 static struct perf_event_attr watch_attr;
 
+static void ksw_watch_on_local_cpu(void *info);
+
+static DEFINE_PER_CPU(call_single_data_t,
+		      watch_csd) = CSD_INIT(ksw_watch_on_local_cpu, NULL);
+
 bool panic_on_catch;
 module_param(panic_on_catch, bool, 0644);
 MODULE_PARM_DESC(panic_on_catch, "panic immediately on corruption catch");
@@ -29,6 +36,94 @@ static void ksw_watch_handler(struct perf_event *bp,
 		panic("Stack corruption detected");
 }
 
+static void ksw_watch_on_local_cpu(void *data)
+{
+	struct perf_event *bp;
+	int cpu;
+	int ret;
+
+	preempt_disable();
+	cpu = raw_smp_processor_id();
+	bp = *per_cpu_ptr(watch_events, cpu);
+	if (!bp) {
+		preempt_enable();
+		return;
+	}
+
+	ret = modify_wide_hw_breakpoint_local(bp, &watch_attr);
+	preempt_enable();
+
+	if (ret) {
+		pr_err("failed to reinstall HWBP on CPU %d ret %d\n", cpu,
+		       ret);
+		return;
+	}
+
+	if (watch_attr.bp_addr == (unsigned long)&watch_holder) {
+		pr_debug("watch off CPU %d\n", cpu);
+	} else {
+		pr_debug("watch on CPU %d at 0x%llx (len %llu)\n", cpu,
+			 watch_attr.bp_addr, watch_attr.bp_len);
+	}
+}
+
+int ksw_watch_on(u64 watch_addr, u64 watch_len)
+{
+	unsigned long flags;
+	int cpu;
+	call_single_data_t *csd;
+
+	if (!watch_addr) {
+		pr_err("watch with invalid address\n");
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&watch_lock, flags);
+
+	/*
+	 * enforce singleton watch:
+	 *   - if a watch is already active (bp_addr != &watch_holder),
+	 *   - and not asking to reset it   (watch_addr != &watch_holder)
+	 * then reject with -EBUSY.
+	 */
+	if (watch_attr.bp_addr != (unsigned long)&watch_holder &&
+	    watch_addr != (unsigned long)&watch_holder) {
+		spin_unlock_irqrestore(&watch_lock, flags);
+		return -EBUSY;
+	}
+
+	watch_attr.bp_addr = watch_addr;
+	watch_attr.bp_len = watch_len;
+
+	/* ensure watchpoint update is visible to other CPUs before IPI */
+	smp_wmb();
+
+	spin_unlock_irqrestore(&watch_lock, flags);
+
+	if (watch_addr == (unsigned long)&watch_holder)
+		pr_debug("watch off starting\n");
+	else
+		pr_debug("watch on starting\n");
+
+	cpus_read_lock();
+	for_each_online_cpu(cpu) {
+		if (cpu == raw_smp_processor_id()) {
+			ksw_watch_on_local_cpu(NULL);
+		} else {
+			csd = &per_cpu(watch_csd, cpu);
+			smp_call_function_single_async(cpu, csd);
+		}
+	}
+	cpus_read_unlock();
+
+	return 0;
+}
+
+void ksw_watch_off(void)
+{
+	ksw_watch_on((unsigned long)&watch_holder, sizeof(watch_holder));
+}
+
 int ksw_watch_init(void)
 {
 	int ret;
-- 
2.43.0


