Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE037CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 05:32:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B2D78E001C; Wed, 10 Sep 2025 01:32:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23AAF8E0001; Wed, 10 Sep 2025 01:32:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DCDF8E001C; Wed, 10 Sep 2025 01:32:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E958C8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:32:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B962213BB17
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:32:45 +0000 (UTC)
X-FDA: 83872221090.21.FFC32EC
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf29.hostedemail.com (Postfix) with ESMTP id D06DF120007
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:32:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GsiOvseP;
	spf=pass (imf29.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757482363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6XwqTGxkvpDU8btF6MhrnM15w2tp20A0ZzctuT/hXIw=;
	b=V32BxuwS9p94HqQVQmnN0VSPPZ/TbK88iwgHfy89mkgbWKSYbto1N/bjOxUwhx+JNNU2Ag
	cyIPWNVGChhSfD0tBB9f5hN+87r+HiIpHbXCXdxq9306GJCNUi2cpbCuSACasWIxfX2hGF
	EUH8xqDHR0VpTsP2Yvhxjn07iyDHUFY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757482363; a=rsa-sha256;
	cv=none;
	b=oPVB9KmhEQCshLavh5T4Lob0nPVh71Xx9Z/hphyUUUIOUJ4bB2uoFaOG70jFWn6HnEObYD
	Q+PBQ2v6Ye8zT+JA0oM07jV+rA1s8baUw6baZJGb6eEyuIfFo5OGCvteuOybpUppbjTLWn
	F0FErsqOMkytBfPtJxLtcoYmYmjOIoU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GsiOvseP;
	spf=pass (imf29.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7725de6b57dso7388931b3a.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 22:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757482363; x=1758087163; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6XwqTGxkvpDU8btF6MhrnM15w2tp20A0ZzctuT/hXIw=;
        b=GsiOvseP4lzB7ElmgbrHWfd9zxcoHGpCtQ7XQ3MmbFizJWOYg7TjrO4/8ZKe7iSHy1
         T4jDIITAjN+Nw73B90kGIEdzHLFnMfGWDhEO8KFiVdjqog2+bNZoJisJc5FUVHpKtu44
         1Pss4lgVA3AQP7uoj5I3zAry2GK0fj6gRfrIyjTGBkT6AoabyOkgffM1VBgOKnD0eHpa
         KQcDCx1Pebtv46RAP0FsTmMsu4t9CMzCNr8FIJNdGg1i//mqGJmr3FoEtj0gt8KVrP0Q
         3OJZcoFuKAa4LMwkh94gkCZi+QA5yDomEiBdik6dIXikSvkQItpfTsQdYk8a1L6XZrmp
         E0Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757482363; x=1758087163;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6XwqTGxkvpDU8btF6MhrnM15w2tp20A0ZzctuT/hXIw=;
        b=KNJsR3cUqZnsqOQqvl6rR7CMDuwP60FPgDmSSeGLn1SEEvfj0YfnGoA5DvGOI6jgFv
         ZFGaAjk7pSXEK4C/fIyQpqUOnjJN7WPBmm+mZxYMO5sma8M1VX0R0zq8I0mQ6Dbs4Uwr
         5au4Q93WucJSnSSN4HAcxcxRuZRQtiLVmWgeC1s4WjI4rdcV1lgUpg3CEx3ON6boG2bb
         rZoPvYqJHdvaUl2sVK+HLLinStiA4gl+w9EYDRob9TWWnss6sPbsosSwmLXUbbqFizJG
         SmjgC5I6qYBQCqAt7EpRXwEdO78RczKXNwzTK0ZOzB8fOatDQEOK3Pb2UrvxOnMmQCn5
         4yMQ==
X-Forwarded-Encrypted: i=1; AJvYcCVvbqA9Umi6T6L3yyCw3SEJIv16yKjHSlNJw2jBxYKfS26IKykV2tMJwMDzEBxu6ioKgdB8iGd+8Q==@kvack.org
X-Gm-Message-State: AOJu0YyiIJ1LliJkJaNBP7D47IjwIvnZciPUZjpGAnuJaT2H+02NxAnk
	CCxkhJBectjRwiGpd/+ZaCXfnRZ+iueS3BO+1V2+HVwiDPLdAN5FykHV
X-Gm-Gg: ASbGnctvx7RNwoRzIKERSuu0YcQ5mFNWjjOqPQpgwYuM/DPlxruwsbnJFl3/TYq0Gbe
	wTh39UAkuBXCVY70olR4NMbOeOpSamnoP3E8uYDwWajVZFvsYol6OeBm/+wNeBkP3S1EQgKHI3g
	qyTIl/D7poW7O2vDy7KWn59GRRC+Rd+OtMk79PF4m80ZONHslevUqD/76cV50aPRuCcZBzOHVGr
	2ujibnqhuF4ChPJtzzUFjwH/eiSUmMmAVmwrmj+mlrTYqqdY7K6+46NVmblN4v7S2Gpf0arJAd8
	+Y7VH9CdOmqT1brEK0jqcuYbz+hzxu/likLy86kyIl9DYSi/G1F5zf7umbq5G8zZLJh7YYHT0RU
	cqpAMa/2qEFSRxNdHCWIEfuYLLc25tMwDFzkjTuJ0pLE9eP7a5B7xhZwtF8hK
X-Google-Smtp-Source: AGHT+IFFWwOXHMwIG1yOKL/FCHbxderarjrTNpzkVRvWwcGe50/YwQcLyKjZj1NSxsqGAAEDD2Uygw==
X-Received: by 2002:a05:6a20:3d83:b0:250:429b:9e56 with SMTP id adf61e73a8af0-2533e9476eamr22673752637.8.1757482362704;
        Tue, 09 Sep 2025 22:32:42 -0700 (PDT)
Received: from localhost.localdomain ([45.8.220.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7746628ffbesm3870342b3a.66.2025.09.09.22.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 22:32:42 -0700 (PDT)
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
Subject: [PATCH v3 12/19] mm/ksw: manage start/stop of stack watching
Date: Wed, 10 Sep 2025 13:31:10 +0800
Message-ID: <20250910053147.1152253-4-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250910053147.1152253-1-wangjinchao600@gmail.com>
References: <20250910052335.1151048-1-wangjinchao600@gmail.com>
 <20250910053147.1152253-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D06DF120007
X-Stat-Signature: 7fcgdmtao635xmi58rnfxa87tatahp15
X-Rspam-User: 
X-HE-Tag: 1757482363-389967
X-HE-Meta: U2FsdGVkX1/ORXASCGPKmrKo0CwMJqwmskWOdQ76FGpkRCedV2Qd7PMyEj1kpww9V6MzRX1A7+jxyPQNi18Rv1gMiDYmjbAC80CihkJ5/snj4BaDveLRPqVn7BNxDD7Dzc974U+t+Mde5mGnbrF86E/S0FNthYJfVi/0fD/oCw0wyvCK6wiqlDIeFRk7xvUhBtJaxmtEvZFz5iqL1mxA/Btpvebv5+WGIVmd6EAUVMKQMps+5PgXwEsUVTT5/usA6HK6ev+dZ1twhbmfvULl4AUqPDdge2i9VMv0ADcrBCMjy75/jghDxlz71AlQT2abKB0o0qXLw2KgSOL/AKgJgxF0f6UXoTgh8z9qQ8i8RH9y50twUbnU5n2IeITQ8Ew0fbmdVK8IDO9Mn3Wy5BavDfCt7MoAbVEMswLP2Pj4dVZFF4dkdGXTKCD2o1TRoD+Dfe6MEn7nqN+Dvl2q+no1s+JmHAvj+KcSTfV5r+zhFkGw6ppZcDcAhgCqCcYRb0fW18Q1yHwpmy/Al2i4F9JB+t2gdrTqhhf5wRh5I//w3nCDiOR1RShudvwVEF2yfszhTNfpCFJp96ndLJw5fNyUKYLraKnsT9RhVbxvrrx7tg/uRn2bM9CXIJI0ij85OH7lghmMd4zRXq8nfqIHhZMaVILijlKfepqSKS9iU24Bu5SgvOiSgLLmWasJIFWwa/RmODIzejXpbKYSwjsSeloZ9ZLMAS/ST2ktVOQZXipfrbcU5EHJSavmU4mekgkCLtpSncdp/4CQdgJgoRApa5B1/cG1JmhNwRJfM1oi2oHk05V1q1ptworTdLDT1/9iN/pfCqN6e2VNzcxvGstjviol6Iq556GwIVH05xznTX+B2EqSQ+lnODbYckLs7SnqqlVJVrFQYoqZZB277awTKtjxHEky9DsGa9cBRyye332F3rdwrBSiwZyvBAtNOja7ZRh55Vkkl4Dsy4F1T8qQUB8
 obDASAqv
 33yzq24NIunEda3a8tnlsGZn+UrpluLdz7G8yLL3Ts4Ky/dJNH4mqT6RlCJ9XPBy57ry1+fOX1A+0q1jlkIVdp8zyApVd/pxf9pTG+tNz+QICitV/TSSkmX8D6GvB8jOt5pmAMi8SpcqNY70SAWgJuMDnH5OV5A1ZoMBZOyTrVSzxYPgZ6MSTFW7+Phq9/LqxKCpQGUXyCVpINhlgEluVYS8UdON98/JAMpMMBpMoFiUw9l5K3y42TTC4ONa5kB0Yxq5zE7lwgy5JY+bvoBxLlgtzt+6RetSMaFwd8lEohQWPntb6GlfnL23mI3aU37WIs/Q67uHEYuwE8FXWTJOn6Prw1r7lBTBm/XPzQXw1qkf1BXh+wBP0w8hp0XvLXRnC5924e8GdDULUKCElXZ3Pf977QbdsnoRKa8iFuSaujwSiN3ZQtWERGcRHtaSY1wZM+gXdCQOFmXz+cujFh3vP0uAGLZj1rSSsZhDq/rvQm8NORObmRzTAd+y6Yfw7g1lxvmEV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce helper functions to start and stop watching the configured
function. These handle initialization/cleanup of both stack and watch
components, and maintain a `watching_active` flag to track current state.

Ensure procfs write triggers proper stop/start sequence, and show handler
indicates watching status.

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


