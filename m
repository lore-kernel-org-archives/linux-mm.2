Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23330CA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 12:28:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4F268E003A; Mon, 18 Aug 2025 08:28:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B26BD8E0003; Mon, 18 Aug 2025 08:28:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3C898E003A; Mon, 18 Aug 2025 08:28:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8FCDA8E0003
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:28:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 553481391E5
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:28:16 +0000 (UTC)
X-FDA: 83789805792.20.87739EB
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id 75E8480011
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:28:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K2mYf5kA;
	spf=pass (imf30.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755520094; a=rsa-sha256;
	cv=none;
	b=YAK9rULCj+rm9mzuk7qvqRiQi79eZT7QpiPTy143vopHefKThJy0ZxQVvCI5buQTNdu5h8
	CaqoiJvf4rB6R/0S1cF4QU2C6JOBe0WsOXAl4dL4/2U/SF7zpulWxi2PFNeyefMnc6cJMs
	uLsB4TEItVy6Hrxv9Ccp+7VPxf/NH0k=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K2mYf5kA;
	spf=pass (imf30.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755520094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F3whJbVs1RtzB6J09uoknRyw25Li/I301mnKhoaueOI=;
	b=YOX1dowaG4+ic/RD8eb2TTEMpMkp7N4ju29qfMphQv6qj0aGiehlAdlrc7QU3EiijmnPZH
	IJk8H5EBP9Dp+5Ur1tAHdsPgB5B23YIcVsY44HCcCX0iB0d9czC8aLLSujUTYZYaWXcU3l
	Bru/IJvNojJnBBABpE2DAnVAmXNyZik=
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b472da8ff0eso1870552a12.3
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755520093; x=1756124893; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F3whJbVs1RtzB6J09uoknRyw25Li/I301mnKhoaueOI=;
        b=K2mYf5kA9aIA3vzt0VRU21BHctff170VOBEGwwwtrNM1GQjRg+25Sahak8uNAI84zl
         SVYW6MJzDS4pLE/RUAQgsxNtGPY5LS66qF6TPj4guhSFYfB62Aj9pq26onj9ZoY6E056
         MgXYUS1sK0YU+EV8joX7+WApN7uZ44OTUrvuKJFMAXqE/4ia/gTGv4w8bAwCSH5lMAJi
         CfKGjQI1g7bFdMjlzeW0ehCdaAbFiEYylHIWZ48EYInBPBYldbJuE7k8gMKdPRQxxJil
         xhtjoHlWwOPfcDkVVhVY773OwYtyLhp0GpJOHxESMVfGeAxeWia+DWfNIscsOVgZ/SzZ
         FFaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755520093; x=1756124893;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F3whJbVs1RtzB6J09uoknRyw25Li/I301mnKhoaueOI=;
        b=nVemv9m9ndy2JHqNcPPzzgs75tj0UAaFIdPNr1wuELv6DwGysZFj20RZxbru5qsIdO
         v7WPdzvg+kcwnltbhtXTeFdrC+XoAE5e3aH1Oevcf78JmR3dGD7EZOFO6YFZriuE9LX/
         cA9HEJ9kw3J0RTwA13EBP4wnHzGgcLgbZ4jH5DiKLplWi+JiA7Ogzr0k8ESd8MEDTWvt
         9bjmuE1mrnZpeYyxzQejoDDPL5MqPUC5MIGoe/l1KgqXlILvwGPVQRySHmXAmMQuLNFr
         FD4D8zAo7c4+RJSPgIdv31SeabZIDoEvymBW/WEjdC8wxSFG+GJMLpYMS6Zd6Gb8EKrh
         aLSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWziRwmURCihrr7fNuE5kFfzKyyhFgKNKqXM+B6bGvt1gePextzn3kj+/a6YtNEUR1/XvMHVtIbzQ==@kvack.org
X-Gm-Message-State: AOJu0Ywf/TNaII5oN+ANRmYwkgEqIBjTQOBbRDRFQSk8paJxbv7dwrFx
	XdFgYBaJnqQYbGyrGfQQvVk0yqcavk+u+JpNL3FR8rSwbBDbgRuzsDoD
X-Gm-Gg: ASbGncshKg+nJn3XjpkKGvoU7usFykRx2VL6z1hUMRGZoThy5iph85FDjeeU3Viq2Al
	X5TXa2ZwXdMsM3o/TRiB4mhlsVnlYJA06oSDXeUJt9ydJxKWfpViKcN3N7wA4XwA/gsGo+9O3dA
	z+Qnx6steSscToztx19xe1svrOrw7DoaHP5jk78TlWLlnDfG9IzWxJUttKcVmmJC+9NdXF1dcNu
	F4/oT+bf8H2WYLByjDK1P45GEnL5NfZnJEalF+etHRBlu3klPNt5Wz08/5aw+LNps5Fh2zc6tLo
	v1Q7e2/oDPcyVFThOTIbTQ2gKz+pECIxaowmCpaFlAj38P0js2zTATV4N0zVfPSr4GAkepiWzEN
	vuEkiUyqurbBEaKqa5el0Em+6NAZ01E2uGQ==
X-Google-Smtp-Source: AGHT+IGxA0E5xL2osqL27bjm0GUQZLO/NaRbdp5NYm8Z6D4qUp3F2l3VtGBaNY4j32I343W5VA3Y3w==
X-Received: by 2002:a17:903:1ce:b0:240:79ef:ae80 with SMTP id d9443c01a7336-24478ed7625mr116941915ad.8.1755520093352;
        Mon, 18 Aug 2025 05:28:13 -0700 (PDT)
Received: from localhost.localdomain ([2604:a840:3::3008])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446d57f12esm79236705ad.157.2025.08.18.05.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 05:28:12 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: akpm@linux-foundation.org
Cc: mhiramat@kernel.org,
	naveen@kernel.org,
	davem@davemloft.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [RFC PATCH 05/13] mm/kstackwatch: Add atomic HWBP arm/disarm operations
Date: Mon, 18 Aug 2025 20:26:10 +0800
Message-ID: <20250818122720.434981-6-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250818122720.434981-5-wangjinchao600@gmail.com>
References: <20250818122720.434981-1-wangjinchao600@gmail.com>
 <20250818122720.434981-2-wangjinchao600@gmail.com>
 <20250818122720.434981-3-wangjinchao600@gmail.com>
 <20250818122720.434981-4-wangjinchao600@gmail.com>
 <20250818122720.434981-5-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 75E8480011
X-Stat-Signature: trp7qei4e7z5mbzyst3831behhbdoyzg
X-Rspam-User: 
X-HE-Tag: 1755520094-443143
X-HE-Meta: U2FsdGVkX19yWuLs0SplwGwIrN0Y6526IUvt6LEyrug3kbp0G07EeVNY19z1f8cb+J+HA+KZCnCGu/+d2QR91KnwbGyloip/JAoOLPfLsLZiKn7i+Qm2O9Mv9a33CsfK2tuJ1puWkclMxiHGIznYMJkMvJYYD/IeJFlPjpHKQ74c262SWrOD0CtssY2cr7r2do+HYK6qXYk5Pe7/5xZpz6dlQg3Pv9Ka3uC9Aizk+8gmfWsri47UKaNczbUsjxWUY4yJ4W+Te2lxybusn3dOhr6yJf/TbgjLFrezxShbnNISRBMeV9e9Vckt/Sd2eqX+KIh+1fo5eVEqGEqqqlDYsqkdcet1DlEuSxtFRbAgfHtxBzd1WMf2dpeLaxC11RoEjtSBU9enbc7pC90sA8HP1UidEtnHPT3E7RjUP50/m1hS4DAMojjQTp431HNSjVDyq4wMdNwR1mkpv6+gM9gdvSxCOaldSvhiWTB8QAWn5mq9vH0O7Wdd9EmiuswoiDkYIfnxmQfFP3sAObpDLruuyhe/7dLe/bYtgPId65ESzbsNzihjyg2PvjiqeF0aYjD+GUpJTuVmY5wTzW8t9VoF2pmCc9iikakPIbiX8Hc+WJT5N8uW+kfEaiIA2dsiaTCk8eiiokm899heKZLO+XYVsck68X9IPl8n+4YA+lb55eNv5tPr3AXvGmBJ/ID3OLJ0i6ubC4iEY5Te8GbUr8J4x9e+VYska1OePW0X9XbZOR8qG042Fxhz4srf67LUQYQ6jBDbFFD4eLcUQ8XT3Ep+6hgYCMYeSJrgzPwykIifNEMckkiIiET+G+uh3TwyeZG6P6ZN/ceugNEGqquDaG7MJ7ddjbeBsPtJMvKR9s+8rhW3xVscVLQMob0tNh2NLJ2qsxzeTSilS98zlxu4U0cplpCnOzDr8OhAZETD/xS3W78F7onh+Zq8UvvEuCR8cirhyJI/AGVJGifn/p1PrRi
 Y733oUgq
 hUXom3ubXNsdczG/lXm94BsaEKs67E58G/jf08CecKIOeOtyVu/M252EN6quXv4sjmbK5OCrCfRN5nL2R+a4OFLiV2V+k3LOBgOZ2aJ86IY1LgkdFb6cHtz8srq1pajTDeGn2ozXHKOPdDYRRjYUM66+QKyWQ3nVW9zQRq/pDFIBn1BopPzxZPyZz+qo4Nq0BcQsKMmqTJ2qdDx+Nu81zoSGjH2bk5WQijhYcQfm51m8VZek3/g9H/GT26R8jWzF/dqOPYpjCcR5LLwDWAy9h52TwfivRDxoXqYT+Excen86R7UlPO4n+0km2LRtEsdrmNOEF4OS56bOIKfqM37ycIwvATRI1Xu4Q1NxJc/m7ExSgNwBKVeJN69MxYUlJfjAslWPxqLVQHuZAv0oCjqiSGIF9zUFDRW3hUnnXcIssX/zCdGQ+CS5jokhq4jo2+fRnkUR1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the critical atomic operations for dynamically arming and
disarming hardware breakpoints across all CPUs without allocation
overhead.

This patch adds the core functionality that enables kstackwatch to
operate in atomic contexts (such as kprobe handlers):

Key features:
1. ksw_watch_on() - Atomically arm breakpoints on all CPUs with
   specified address and length
2. ksw_watch_off() - Disarm all breakpoints by resetting to dummy marker
3. HWBP updates using arch_reinstall_hw_breakpoint()
4. SMP-safe coordination using work queues and async function calls

The implementation uses a hybrid approach for SMP coordination:
- Current CPU: Direct function call for immediate effect
- Other CPUs: Asynchronous smp_call_function_single_async() for
  non-blocking operation in queue worker

This enables the kprobe handlers (added in subsequent patches) to
instantly arm breakpoints on function entry and disarm on exit,
providing real-time stack corruption detection without the performance
penalties or atomic context limitations of traditional approaches.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kstackwatch.h |   2 +
 mm/kstackwatch/watch.c       | 118 +++++++++++++++++++++++++++++++++++
 2 files changed, 120 insertions(+)

diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index 256574cd9cb2..910f49014715 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -41,5 +41,7 @@ extern bool panic_on_catch;
 /* watch management */
 int ksw_watch_init(struct ksw_config *config);
 void ksw_watch_exit(void);
+int ksw_watch_on(u64 watch_addr, u64 watch_len);
+void ksw_watch_off(void);
 
 #endif /* _KSTACKWATCH_H */
diff --git a/mm/kstackwatch/watch.c b/mm/kstackwatch/watch.c
index 5cc2dfef140b..7ab247531961 100644
--- a/mm/kstackwatch/watch.c
+++ b/mm/kstackwatch/watch.c
@@ -1,4 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
+
+#include "linux/printk.h"
 #include <linux/kprobes.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/perf_event.h>
@@ -11,11 +13,24 @@
 
 #include "kstackwatch.h"
 
+#define MAX_STACK_ENTRIES 64
+
 struct perf_event *__percpu *watch_events;
 struct ksw_config *watch_config;
+static DEFINE_SPINLOCK(watch_lock);
 
 static unsigned long long marker;
 
+struct watch_worker {
+	struct work_struct work;
+	int original_cpu;
+} myworker;
+
+static void ksw_watch_on_local_cpu(void *useless);
+
+static DEFINE_PER_CPU(call_single_data_t,
+		      hwbp_csd) = CSD_INIT(ksw_watch_on_local_cpu, NULL);
+
 /* Enhanced breakpoint handler with watch identification */
 static void ksw_watch_handler(struct perf_event *bp,
 			      struct perf_sample_data *data,
@@ -31,6 +46,59 @@ static void ksw_watch_handler(struct perf_event *bp,
 		panic("KSW: Stack corruption detected");
 }
 
+/* Setup single hardware breakpoint on current CPU */
+static void ksw_watch_on_local_cpu(void *useless)
+{
+	struct perf_event *bp;
+	int cpu = smp_processor_id();
+	int ret;
+
+	bp = *per_cpu_ptr(watch_events, cpu);
+	if (!bp)
+		return;
+
+	/* Update breakpoint address */
+	ret = hw_breakpoint_arch_parse(bp, &bp->attr, counter_arch_bp(bp));
+	if (ret) {
+		pr_err("KSW: Failed to parse HWBP for CPU %d ret %d\n", cpu,
+		       ret);
+		return;
+	}
+	ret = arch_reinstall_hw_breakpoint(bp);
+	if (ret) {
+		pr_err("KSW: Failed to install HWBP on CPU %d ret %d\n", cpu,
+		       ret);
+		return;
+	}
+
+	if (bp->attr.bp_addr == (unsigned long)&marker) {
+		pr_info("KSW: HWBP disarmed on CPU %d\n", cpu);
+	} else {
+		pr_info("KSW: HWBP armed on CPU %d at 0x%px (len %llu)\n", cpu,
+			(void *)bp->attr.bp_addr, bp->attr.bp_len);
+	}
+}
+
+static void ksw_watch_on_work_fn(struct work_struct *work)
+{
+	struct watch_worker *worker =
+		container_of(work, struct watch_worker, work);
+	int original_cpu = READ_ONCE(worker->original_cpu);
+	int local_cpu = smp_processor_id();
+	call_single_data_t *csd;
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		if (cpu == original_cpu)
+			continue;
+		if (cpu == local_cpu)
+			continue;
+		csd = &per_cpu(hwbp_csd, cpu);
+		smp_call_function_single_async(cpu, csd);
+	}
+	ksw_watch_on_local_cpu(NULL);
+}
+
 /* Initialize hardware breakpoint  */
 int ksw_watch_init(struct ksw_config *config)
 {
@@ -50,6 +118,8 @@ int ksw_watch_init(struct ksw_config *config)
 		return ret;
 	}
 
+	/* Initialize work structure */
+	INIT_WORK(&myworker.work, ksw_watch_on_work_fn);
 	watch_config = config;
 	pr_info("KSW: HWBP  initialized\n");
 	return 0;
@@ -63,3 +133,51 @@ void ksw_watch_exit(void)
 
 	pr_info("KSW: HWBP  cleaned up\n");
 }
+
+/* Legacy API: Arm single hardware breakpoint (backward compatibility) */
+int ksw_watch_on(u64 watch_addr, u64 watch_len)
+{
+	struct perf_event *bp;
+	unsigned long flags;
+	int cpu;
+
+	if (!watch_addr) {
+		pr_err("KSW: Invalid address for arming HWBP\n");
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&watch_lock, flags);
+
+	/* Check if already armed - only need to check one CPU since all share same addr */
+	bp = *this_cpu_ptr(watch_events);
+	if (bp->attr.bp_addr != 0 &&
+	    bp->attr.bp_addr != (unsigned long)&marker && // installted
+	    watch_addr != (unsigned long)&marker) { //restore
+		spin_unlock_irqrestore(&watch_lock, flags);
+		return -EBUSY;
+	}
+
+	/* Update address in all minimal breakpoint structures */
+	for_each_possible_cpu(cpu) {
+		bp = *per_cpu_ptr(watch_events, cpu);
+		WRITE_ONCE(bp->attr.bp_addr, watch_addr);
+		WRITE_ONCE(bp->attr.bp_len, watch_len);
+	}
+
+	WRITE_ONCE(myworker.original_cpu, smp_processor_id());
+
+	spin_unlock_irqrestore(&watch_lock, flags);
+
+	/* Then install on all CPUs */
+	/* Run on current CPU directly */
+	queue_work(system_highpri_wq, &myworker.work);
+	ksw_watch_on_local_cpu(NULL);
+	return 0;
+}
+
+void ksw_watch_off(void)
+{
+	pr_info("KSW: Disarming all HWBPs\n");
+	ksw_watch_on((unsigned long)&marker, sizeof(marker));
+	pr_info("KSW: All HWBPs disarmed\n");
+}
-- 
2.43.0


