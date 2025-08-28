Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C74ACA0FF2
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 07:34:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 548588E000D; Thu, 28 Aug 2025 03:34:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D1788E0001; Thu, 28 Aug 2025 03:34:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 399938E000D; Thu, 28 Aug 2025 03:34:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1FE878E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:34:26 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D7FABC0A14
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:34:25 +0000 (UTC)
X-FDA: 83825353290.23.D3B790A
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0A3891A0009
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:34:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AYD0iZH1;
	spf=pass (imf19.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756366464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=06EnX4xNHqiA4W3dBLh6+8AEySVO628YRMoxqtZgpzs=;
	b=NeTklsYbuquh5m6XaoREWcpvNkbvDiZw9Q+pXqXEzthMR5JW2tvt6kgqsStyWBfw2QgkwQ
	Xcbl6r09FPhTNAeVNeSkAcRjc0ILx3veAXqtE7UsBwb6zX/Ga5dSDEuUz7lA4jeIqaJ1af
	5xPZfE0UC+LLDahsjQdeoBHwxR3Bx5w=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AYD0iZH1;
	spf=pass (imf19.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756366464; a=rsa-sha256;
	cv=none;
	b=IjMa8Aok7We/ILkCFzYDRzVg9eQ+m2/BVgj318qRjQ/yMcHACkVXFb3bnVkiCwgFQz1IqI
	mfq4FR4SVG8LMlNw3nKHA4sL42nnxWihL3Nuyvw0fMiLtqC3+nkYgdKA8Q1LCiat35xC5c
	vwZDrGMkXEu/TlUBjsYwdQ4CnPVliaU=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-32326e67c95so704528a91.3
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756366463; x=1756971263; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=06EnX4xNHqiA4W3dBLh6+8AEySVO628YRMoxqtZgpzs=;
        b=AYD0iZH1KoecpGZCb6beQCxfu2h6o+6JDbWvDEcCvIo1/J8dHJ2NbXPFKDYPHrsbUG
         +6aX6zfgYqRjxzMnB4plBMPjwytG0ksqxIg33ELsssFMKBT8QiuZC1TxHpt7ECqxhn9K
         9gGFoxOAYZ71KZVVaO6WNhVcaApWV2pe/2wRmGQ5wqIhagSe33czRVyNu3P6GXevyxCh
         QBBZHd3Hvy92j+/Zi+1sZ3/AW2CyG88kzHMgacEV2HsP0JFvYYBoDt7aZS/nPYr+xa4n
         2KQu7euJrEf/hJgrmHeDTcS4ydB36d8xhb2R7jpGbtMF9sAzW31wM/CWT7g2iTTDM3Z9
         F/6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756366463; x=1756971263;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=06EnX4xNHqiA4W3dBLh6+8AEySVO628YRMoxqtZgpzs=;
        b=NzqBxI9HqApCUpjIgT8vyMVDd51rhIeyGZUnaQLn4NW13tB2XIDYJt0SIxLo16jd/E
         yEDxwa1pG+S7JHfT8KJvaFVrYL6aoDUXhb5NB97jyBAJXZK4r83YLaE0XmnxCJ0qTK5F
         SgVp6Br6eTzwWXBZHAW3yRDo68UWsI1EeXT4D5NqPktDcM/k4iuSuc6ii0ENSue3SAVX
         XhI4TENcgy0l3uZdXlUQBVV8g7bRVNZBPE4ehCCATZffm7zr2ilOfnwuHGlOmprb2Ilf
         cMf3yDvy4Ax/3vxfO1mCWiv4Crki1cNf4E2a8xHO6psd04lJD3UQz0d4Y0rWQUcakrH5
         7Hrg==
X-Forwarded-Encrypted: i=1; AJvYcCXqH4UBDVPOZJdWKooWGldpQK60W4bPrn59/Yz1UIx51ZAKaUJhHkExwTNgJl1cyZkHIuott8sSrQ==@kvack.org
X-Gm-Message-State: AOJu0YzH4mX3MgKHohNxd4vz3Hjnwbr0waXWZzT/kk0gFuae0XKoDm2d
	Xi2QQEgcIDfx3EhsUTRv5ibvLS54Sfg0/1ySr8pF9KHmrmAcH8nwvVnXoZeklwSx2K0=
X-Gm-Gg: ASbGnctbdq1LOO9NmLDnclnEhSj1sW8qCLfCsHipmmfXkOZeGj08V3HssWL9v7INKug
	7jFTIw0WSnoNYmqHExNyFP1/YOb6KE8Sfrdg9U6V6grGNPOTWPnAv1Pcp2dMz0anB0zkYnRBmdn
	FBvZjVzteBq/kNoq1ZLkYLkyhpmfGgAMpVm4uh+yslEfQklcxNT9jDlJrkuZnWGrJdMcQoSzLDQ
	qOaMLTAgw+OAr59QPtd56FwXIV5wukf/gyzV0qMzJGDAgKXBVNru+pKpwn4fpRv9jrLl7XBIEbk
	ph4GJl2l7bCtyI51bia6nki+nuO1mIgLoFj6BIh6fC1sZOaO9j+dwxr7KuH1GWTK8xs60ULnGhV
	lFpwGCFKGcHLE7jOiJLP059eYXEm2nS+HJOvHgyONu/BPBPIX6w==
X-Google-Smtp-Source: AGHT+IF3oK1wtDDUKHh7prZzFv/h2WgsQ8uT2JvqKbar3UHoHg6u2L/SgTz5aOR5xgZdGT+bcHmpXA==
X-Received: by 2002:a17:90b:5823:b0:327:50b2:8007 with SMTP id 98e67ed59e1d1-32750b28118mr9705895a91.32.1756366462755;
        Thu, 28 Aug 2025 00:34:22 -0700 (PDT)
Received: from localhost.localdomain ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b49cb8afb7bsm13182613a12.16.2025.08.28.00.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 00:34:22 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH 04/17] mm/ksw: add HWBP pre-allocation support
Date: Thu, 28 Aug 2025 15:32:37 +0800
Message-ID: <20250828073311.1116593-5-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250828073311.1116593-1-wangjinchao600@gmail.com>
References: <20250828073311.1116593-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ajqwauftxgabo7gk44cuh6xnooyop3ro
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A3891A0009
X-Rspamd-Server: rspam01
X-HE-Tag: 1756366463-412196
X-HE-Meta: U2FsdGVkX18N7gslguchMvUsJPFHhi4Py+oNaex51iHk2tFm2h728XP1cEWO723Pildm5ASKgtbLJO2Cf0jlcFnRMkaCRCOxBhxyyxPnIFzXJaIvsXBj+CRlXpxoAkA3RIvv50QuIuVjBASCVJe/ZBtZZSOBFj67LH6YspnEP8Kn9G6rEJT+p5zpKEWKlH6iMUvCb4DZDGcKl/zeXoIoCK3gtGeiDuIoNi4FHpBY6yvKz+9KGX04ykmXElTzOnAwYVbIp6e4TPUNtZXEF//aoCCFtDYs8n3V87EQNbNUhr0uhbQOOw7fO4x7HSiwD2PUQ8c2WDcbu/3sKvme78N3I13UiPMubrHifhuqbtrUIkrJjhYn710Fkd/x3dmvzB3q3OSHeKEk6hskNuKhaaqCL3xqozWKV9BM9b17regxgavUTbZzN+4VGN4zi8AcNJ+tBQ6prrVmOxMOhm8+IRv5WlwN7nfV+Z6mWMAKgV/CucgokQShry7hG8J0t9hnqLMJIehEvRF479rsSkGwyXMUCC8kTYLfAUdYJ77PMk6s2ckegBGmA4Jp0+Wcs2srrTZb709IMdZOoeDXsJ6kVFrW61mYqyMXL85YJJG8VKwiWoRzQpOirM9y6vsYmy7pVbYvo+pgksXXAgDs/fZqGo1ZJ26Sq8vnv1pG4q6sT8zDcQeQ0iW7FpvzpMYNyllgjsk8Tk7bZtNPtIWU+c8WWFFHZfktZdVxzg7VcV6BvlZKEibVUPZoM23Jf8UfTAFYQtXCvDh2SQKxrLI7Pxqne51wyPrKx9+bUP6EuSZjPVxX1HQ+8ziORk7ZW+JfDCUxQuooXW5t8dHgZXnbvNaP53UJNJMcqu3SA10a6eTpYx4lX1Y7CgYIjKTof3qcDGAXmagDZR4iASBHwzjZCXgZ82KrsbFGKl8p+QFUHZdKCvb1NHFpxQL84fSAhGg9mGwQ4G59MtbbyinTVvDn/O1feCh
 UdtIJW3B
 wlzErKeR4roQ9ASFonpkbVpxM5zPzD1nTUgplwhzWdKOvNGAZfwVQ5pxSQOG7eiZYM9qhIKzXgJxzP39hZD7NJ4bQZHZ2baGqINc4KtuPmNhABS5AUkMTZ+618Y6DYq0LkkLzq5II1XHX/DzDMAmfXJZpzQC5fFEqJwdgi12mfA+3g/vv8flogVog0SlHrbqQPY+HW38RNuPhUaeoIIdX3ExLt/mIQtzj2Vol/aLPzZ31H4RV2lsu9Pqxg9oFZpif5/04bx8OA0ACTRODQELMAOegCjB8n0pLZDq1Wuty2YKCtJFvQcIcVn7MGSfV/0Y+qiNuPFaIYwS96wKlJ+ZU9lVdqDD3bgNdHPnPpgrsLQHcPQm8rcg778/FFhCm92gRoG1nwslyVI63/6oEtZERluwnNIEyfocDLRmKn8Jq4SwbRoLjQWL0SLaOZFns8okyH3wCKV56CgzLaY4lY43pbReK48k19oWj86sJxx0PiqEkJdNPhrEhHdnMqcFHyNaENS9j
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pre-allocate per-CPU hardware breakpoints at init with a dummy address,
which will be retargeted dynamically in kprobe handler. This avoids
allocation in atomic contexts.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kstackwatch.h |  6 ++++
 mm/kstackwatch/watch.c       | 62 ++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index b5f1835586c1..2318779bde70 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -36,4 +36,10 @@ struct ksw_config {
 	char config_str[MAX_CONFIG_STR_LEN];
 };
 
+extern bool panic_on_catch;
+
+/* watch management */
+int ksw_watch_init(struct ksw_config *config);
+void ksw_watch_exit(void);
+
 #endif /* _KSTACKWATCH_H */
diff --git a/mm/kstackwatch/watch.c b/mm/kstackwatch/watch.c
index cec594032515..e7ed88700b49 100644
--- a/mm/kstackwatch/watch.c
+++ b/mm/kstackwatch/watch.c
@@ -1 +1,63 @@
 // SPDX-License-Identifier: GPL-2.0
+
+#include <linux/hw_breakpoint.h>
+#include <linux/kern_levels.h>
+#include <linux/kprobes.h>
+#include <linux/printk.h>
+#include <linux/perf_event.h>
+#include <linux/sched/debug.h>
+#include <linux/slab.h>
+#include <linux/smp.h>
+#include <linux/stacktrace.h>
+
+#include "kstackwatch.h"
+
+#define MAX_STACK_ENTRIES 64
+
+struct perf_event *__percpu *watch_events;
+struct ksw_config *watch_config;
+
+static unsigned long long watch_holder;
+
+static void ksw_watch_handler(struct perf_event *bp,
+			      struct perf_sample_data *data,
+			      struct pt_regs *regs)
+{
+	pr_err("========== KStackWatch: Caught stack corruption =======\n");
+	pr_err("KSW: config %s\n", watch_config->config_str);
+	show_regs(regs);
+	pr_err("=================== KStackWatch End ==================\n");
+
+	if (panic_on_catch)
+		panic("KSW: Stack corruption detected");
+}
+
+int ksw_watch_init(struct ksw_config *config)
+{
+	struct perf_event_attr attr;
+
+	hw_breakpoint_init(&attr);
+	attr.bp_addr = (unsigned long)&watch_holder;
+	attr.bp_len = HW_BREAKPOINT_LEN_8;
+	attr.bp_type = HW_BREAKPOINT_W;
+	watch_events =
+		register_wide_hw_breakpoint(&attr, ksw_watch_handler, NULL);
+	if (IS_ERR((void *)watch_events)) {
+		int ret = PTR_ERR((void *)watch_events);
+
+		pr_err("KSW: failed to register wide hw breakpoint: %d\n", ret);
+		return ret;
+	}
+
+	watch_config = config;
+	pr_info("KSW: watch inited\n");
+	return 0;
+}
+
+void ksw_watch_exit(void)
+{
+	unregister_wide_hw_breakpoint(watch_events);
+	watch_events = NULL;
+
+	pr_info("KSW: watch exited\n");
+}
-- 
2.43.0


