Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4E52CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 05:32:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C6498E0017; Wed, 10 Sep 2025 01:32:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1768A8E0001; Wed, 10 Sep 2025 01:32:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03E9E8E0017; Wed, 10 Sep 2025 01:32:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E25B88E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:32:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 96FF5BA695
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:32:12 +0000 (UTC)
X-FDA: 83872219704.27.CA78F16
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id A506B40004
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:32:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eTe0qyUk;
	spf=pass (imf27.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757482330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jTX/18/Ng4CVcL/DRFC+Yv752wszrnD9hcMkiFmERzI=;
	b=bbLcmHCK9no7yddfUBZ2OQI6DlcjwKkHRvvJGTknRSfuXa8/nRyl5x5bv0YdUJ1h1Kc17s
	luBbo/a2qOufF8FaJES05PYwrJp6YEhMjO0xP8cUJV0MBfZALD2ZW2W3PgEYjhWnq1mfPn
	DxMUb/yt2iKGcG2Xx73sRC/pcHBC7/U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757482330; a=rsa-sha256;
	cv=none;
	b=EWKRpuC1SzSgnsac7yyjBVnOkoWdaYd3fXThotYoZ/LJd2iLB8QYiFV2zHmn4E9TbcmUld
	WfFskVcSIe/akcWIrir2Zc74PWpb6stKOlV8j/kA0SWo9z6yWRbiLa0bLWZzEhFHPf4Isp
	CDQz7UAP6d4tyIt4QT665wvqfQanAi0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eTe0qyUk;
	spf=pass (imf27.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7724cacc32bso5017200b3a.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 22:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757482329; x=1758087129; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jTX/18/Ng4CVcL/DRFC+Yv752wszrnD9hcMkiFmERzI=;
        b=eTe0qyUkvS9xTDAYdcbG+zspcSiJfGygp6MLfrT55+0UYbf4s/DKiEpxnyYca02Hoe
         2ZaZ2zq4zLHP04z/pY5K2Hwt5Mm4Vz3/wiZJBeBTGN4Mj8MMyMdWIftV/fLImNYHiKQH
         c9Hy50xjLhPnnTiU23iXIkGq4TxyKs/LPFVH/rzYDCFXldO8ABA5u4UVv40rpbAB+z2H
         ff6rX6PjqEQuYfTQ3g62EvHg4bhw03Q7pjl+Wc5KI95tdBuOtMkaLnWn814q+VgtGQei
         OVgTOntQZn+agc9uRelmVXUOWQkgVB4OUzqmAMNsrdE7MGXewh6pSHP2ylyhv/3waMuv
         zOFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757482329; x=1758087129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jTX/18/Ng4CVcL/DRFC+Yv752wszrnD9hcMkiFmERzI=;
        b=Z3+wQIqFO9NeVCGRGSScJvvT0ezpXnNAaKBIa3prYDd5X3A1M8WKK70dvEpV7I0tya
         2EVoLy3I+tUDDVUbL9hW00In7k5QClLMg+13wGQn1sEecQcj+xhO23SeJ/ZpgR3puXiW
         gycmO1yEGR6s2Wv1PFWod7Sib6ejaFlkLbw8zXrI8q5Xw4Vx5OIaEiJiH9b9MjrUDLkM
         82WOPmjaOS/UN2l6aTutkPXi8UM8TiS27tywu1pXTkRri4XtwM+WoGJd/6m8vQfl6Zaf
         WX0yUbFptI/x6WCc8lgMcL7QC+LyM3jiaG1dECxeaXBJBjG9EJ8Fi+9XhuKITfexjSkE
         UQyA==
X-Forwarded-Encrypted: i=1; AJvYcCVPRtWYqKgNkb89QF5bcD7WHlBkbfJcLPshEMqw4e2rQmFghZhp74EM1426H1J3qxW8V/ilm044dg==@kvack.org
X-Gm-Message-State: AOJu0YzCpFxzUZ14Dn4Z1VpA1vPsM4zVabGJd1H7wkjU/Xny6S1YUUrc
	fPXOmcClfJ3mCmJ60uEzbmsSnZRz47+SRQIqmNQDo5yOjO6R23jpZWAd
X-Gm-Gg: ASbGncsKde8K+ads3VZF+UTLyUVfN3jSmni/yTerIeYM0x/1l55YrXVBVOTMFhTUMmy
	lnVuyH94MWHuM59toJ5C0aP9a/g9F02Cbo+tGexvpQLhi9Q7rswpWu767waFYsgn3hxklhPsDV9
	BIe+oC5YDUh42NryOroksnQQr1X8l7W5jRYCeTEiHSJoGi03EoZQc1PQOu/anuZpSsRk5zgQv4A
	yk9Ll+Jz8ehINOvXP8zkGr2glBTZU334cJX92vCBtX72LAQG7T05tcyN6cjGXe5WNu+gTCx35xL
	kHL2ar14tabYW2V/1QrwUrNxpcL4DWd6cryklSP9htKb8K7vKJz2H8gDM7pp065xky9LptRaZmp
	ws95yX/w3Y1evl6nPM2I4L3IOWboF2V4W7h+H1W8zDCZFl8wPHCht8xbNOxHnRIv/lLrSFMs=
X-Google-Smtp-Source: AGHT+IF9kJrtBDYiB4hfn4HCCgf0UorUfbL019zuPVBNsodMy1NJmmuOm2Dva3GcVIGrDCyocRIbhw==
X-Received: by 2002:a05:6a00:13a0:b0:770:579a:bb84 with SMTP id d2e1a72fcca58-7742dca7eb8mr15301351b3a.5.1757482329364;
        Tue, 09 Sep 2025 22:32:09 -0700 (PDT)
Received: from localhost.localdomain ([45.8.220.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7746628ffbesm3870342b3a.66.2025.09.09.22.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 22:32:08 -0700 (PDT)
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
Subject: [PATCH v3 09/19] mm/ksw: add probe management helpers
Date: Wed, 10 Sep 2025 13:31:07 +0800
Message-ID: <20250910053147.1152253-1-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250910052335.1151048-1-wangjinchao600@gmail.com>
References: <20250910052335.1151048-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A506B40004
X-Stat-Signature: ud93tzknwenc1wsczm3h3tdge1dh5a6p
X-Rspam-User: 
X-HE-Tag: 1757482330-534530
X-HE-Meta: U2FsdGVkX19Ogl766WVv/oPx9/VtXFF6+sJXlVhW0ym+FDXQyv+OOzTvR3VhxwDMiRQ9xnS73qQjsKw/DEXDVgHmTADkBwBhHee12PrrcTLwlYD4UwYnS7sBI81LMEDMQnFVhisdddx/tpyuumfRXuGpNCZWH/3zH0Rhh7A4nEu6SyMGx+MYJ5hgXmYtCMdy4c/2UjXpnaFNvFtwNPZC30iJKU6td7EC6FX1ngpAWv9km9XG44/rm4RrZRBPpliGoMaJF59GWPzPi+7UTZgkjNV5Rrd+YIoSIp/TL+cQ1lU8N6PyOESA+K72Hh10lrCEG05IAf+fTh479DvowUVdU9LVBqpUDCcEkJa1lizpEyNVwfdtuTb63PGrdg2fFo7my9wiHZsQP4qbIjEWB5+yko43A3HWFLdsSaL4uZAR2iIruRtehd+azhGo19vt94pVQruIQGBD1R8h+PD4OjGCzn4eUeRJeCRtamhHgGGY6y3RyBiz+mfAB/3OVtjWrX2U9II2di49cTMUsGpPOuONFDV5Jqq1e5SufEHArAtNwwbu90TH9G5kzsS/d47X+8JYNqIrzhCme8z4yfUkPfDgnPJcWXmmofWTh5uB4SaQzwz10StrngBs+8HVr8hEngXBOfZhBkmeSj7cDLz5250NZc1n9s/XJHRZ9M+HS+dOBW9TqgRNXP7djwi45luHXSpE4Zr2r/2+b6xVEkx0kOJQdCFHLsCd/ax6A0CO29HM3XEU7hSr2VufT4tKFoxQOEzB06aEnF13PmLtE0TDqv9DtgUIVX6jyb77nk3LsxnKaz18aDysm0kDOhJhCw76Hah7dekZfrXmVFTtGJ3ivoVEfXjBcOkERfj6uEUlwvuCD+DWdC6T+nwD3CYAPMwdWhwPNtIDiXyQ3H8nA83luCCCRcir8ILnM5OIiBvapu7HjpQl+5F40d7qqE59di4aZBNip1vJmJfqMJ201yzh1N4
 M9oWWtHp
 kVFk5bkEq5ww36NxK3a+F8s/1gP/1/RnhILh8Vs7uxiEXpHBXVgZDu5otpZW/z+pVXv/gNc0J9GyStf/eM6cG4N7AyrYloHUb8hjy6d4BY0E4tEkGITp1Zt1qAHHDnYuQINDUirWLzNPhnzUm1AswVdsCDdmKkQoFn6AFUBaBMEml92zSpl/GlHp23LwlyHo6BfXWMrDNdqG2a3bz4ogUzYeUuukVsJ0UNdLRxWQhKWa+EwIL4OKmt3oKUSZ2HX4jfwQGOFaQRyo0zD8fakN6sjX0JIBWTbusgXbs/ZdSCafPowVWSSLsdCeepAN03nhxFySAIdNThpTOdaAX5iK1bMGW83IcFixL/4T5lFk2IOkBBsjBmqbk0xucKXqGI49lLbNyMcP2WVRSXMTK200+mIqdjsRjpU8G+tVi4OY6MSDKleKZnG3PtnheI+ldDJ72p8U+beN6U4K9/PocLk/O+sAUrpAqruAjgyYrxPbg3266Eef7bhi95SrcuHsBNUCt4dWAS0ro9/mTwVhLJdEXfFm28j1LSsK69i2+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Provide ksw_stack_init() and ksw_stack_exit() to manage entry and
exit probes for the target function from ksw_get_config().
Use atomic PID tracking to ensure singleton watch.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kstackwatch.h |  4 ++
 mm/kstackwatch/stack.c       | 99 ++++++++++++++++++++++++++++++++++++
 2 files changed, 103 insertions(+)

diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index 2fa377843f17..79ca40e69268 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -38,6 +38,10 @@ struct ksw_config {
 // singleton, only modified in kernel.c
 const struct ksw_config *ksw_get_config(void);
 
+/* stack management */
+int ksw_stack_init(void);
+void ksw_stack_exit(void);
+
 /* watch management */
 int ksw_watch_init(void);
 void ksw_watch_exit(void);
diff --git a/mm/kstackwatch/stack.c b/mm/kstackwatch/stack.c
index cec594032515..72409156458f 100644
--- a/mm/kstackwatch/stack.c
+++ b/mm/kstackwatch/stack.c
@@ -1 +1,100 @@
 // SPDX-License-Identifier: GPL-2.0
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/atomic.h>
+#include <linux/fprobe.h>
+#include <linux/kprobes.h>
+#include <linux/printk.h>
+#include <linux/spinlock.h>
+
+#include "kstackwatch.h"
+
+static struct kprobe entry_probe;
+static struct fprobe exit_probe;
+#define INVALID_PID -1
+static atomic_t ksw_stack_pid = ATOMIC_INIT(INVALID_PID);
+
+static int ksw_stack_prepare_watch(struct pt_regs *regs,
+				   const struct ksw_config *config,
+				   u64 *watch_addr, u64 *watch_len)
+{
+	/* implement logic will be added in following patches */
+	*watch_addr = 0;
+	*watch_len = 0;
+	return 0;
+}
+
+static void ksw_stack_entry_handler(struct kprobe *p, struct pt_regs *regs,
+				    unsigned long flags)
+{
+	u64 watch_addr;
+	u64 watch_len;
+	int ret;
+
+	if (atomic_cmpxchg(&ksw_stack_pid, INVALID_PID, current->pid) !=
+	    INVALID_PID)
+		return;
+
+	ret = ksw_stack_prepare_watch(regs, ksw_get_config(), &watch_addr,
+				      &watch_len);
+	if (ret) {
+		atomic_set(&ksw_stack_pid, INVALID_PID);
+		pr_err("failed to prepare watch target: %d\n", ret);
+		return;
+	}
+
+	ret = ksw_watch_on(watch_addr, watch_len);
+	if (ret) {
+		atomic_set(&ksw_stack_pid, INVALID_PID);
+		pr_err("failed to watch on addr:0x%llx len:%llu %d\n",
+		       watch_addr, watch_len, ret);
+		return;
+	}
+}
+
+static void ksw_stack_exit_handler(struct fprobe *fp, unsigned long ip,
+				   unsigned long ret_ip,
+				   struct ftrace_regs *regs, void *data)
+{
+	if (atomic_read(&ksw_stack_pid) != current->pid)
+		return;
+
+	ksw_watch_off();
+
+	atomic_set(&ksw_stack_pid, INVALID_PID);
+}
+
+int ksw_stack_init(void)
+{
+	int ret;
+	char *symbuf = NULL;
+
+	memset(&entry_probe, 0, sizeof(entry_probe));
+	entry_probe.symbol_name = ksw_get_config()->function;
+	entry_probe.offset = ksw_get_config()->ip_offset;
+	entry_probe.post_handler = ksw_stack_entry_handler;
+	ret = register_kprobe(&entry_probe);
+	if (ret) {
+		pr_err("Failed to register kprobe ret %d\n", ret);
+		return ret;
+	}
+
+	memset(&exit_probe, 0, sizeof(exit_probe));
+	exit_probe.exit_handler = ksw_stack_exit_handler;
+	symbuf = (char *)ksw_get_config()->function;
+
+	ret = register_fprobe_syms(&exit_probe, (const char **)&symbuf, 1);
+	if (ret < 0) {
+		pr_err("register_fprobe_syms fail %d\n", ret);
+		unregister_kprobe(&entry_probe);
+		return ret;
+	}
+
+	return 0;
+}
+
+void ksw_stack_exit(void)
+{
+	unregister_fprobe(&exit_probe);
+	unregister_kprobe(&entry_probe);
+}
-- 
2.43.0


