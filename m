Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07F06CA1010
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 00:23:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6022F8E0014; Wed,  3 Sep 2025 20:23:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B2B88E0003; Wed,  3 Sep 2025 20:23:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47B378E0014; Wed,  3 Sep 2025 20:23:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 337B28E0003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:23:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E3A165BCDE
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:23:12 +0000 (UTC)
X-FDA: 83849668224.25.B2A94FD
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf21.hostedemail.com (Postfix) with ESMTP id 061AD1C0004
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:23:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cWJvmYyG;
	spf=pass (imf21.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756945391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eZFeltWH3JIFgXl4IiDP3gNU26ULKF6mUGhK5pmKxrA=;
	b=8kuY7I+rxqjGSsWSwA8wwjT3biqOs/Jxh58ngvtfrH94+16DzncbX7OEChYwKLE2W/ZdZc
	1A9tdQIFWqDRsoJE+MUpCzzR2LwFv1F0SBi8n/sbg8rNw2B03UTENA7ErGB+tJXack2RZ8
	YfodYJtGhw7QD/RW2Zua9s2utEpSKu8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cWJvmYyG;
	spf=pass (imf21.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756945391; a=rsa-sha256;
	cv=none;
	b=3XkgmjAJ1KN04kfe7Hs/tQ2VfBbBDYUSC1WrK+kkvPva2I1ogRYLVh2fKxRehxgDpatPRU
	WWvTvpU9B7oMA9awpaSpjFB9H/UMY1QGvgJrx14gy5fBWnUatGwGDrX7AVf3OZRNIaFhTQ
	4lQys4v0PWx/xEBdFw8iNh6euq2/vdE=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-76e4fc419a9so540686b3a.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 17:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756945390; x=1757550190; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eZFeltWH3JIFgXl4IiDP3gNU26ULKF6mUGhK5pmKxrA=;
        b=cWJvmYyGAkjnDDvoU2TfKgXBAkbIMu2grBC1vcgYgX/Ixek7zT8l9PL9SxVb+b1zQo
         9i7gDso97+uanVmWnUUZK5fbQrDa2YV8PUoy1X2/v4cGnx6NEGG7ZeYG0v7XzaftUd0g
         FQWRXVpSqEZh5xXUzb3hZHhWR4ahpieDuSYUI7v0bKsE54zatbQkqwKquPbchwM7Gus0
         kyzqEwhtg0SQPI2cdIps0qUkIfjjyqDJpyVVKbsWXI9EotVzYe4ksOEVbHpYJ3aIw1xy
         VYujcaFicQTdw3WrnfQ/eF9HcHtlSA6e3Jc8BSQGOM3xyvTWlddWC5aucBcWS2kLRLb/
         Vdrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756945390; x=1757550190;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eZFeltWH3JIFgXl4IiDP3gNU26ULKF6mUGhK5pmKxrA=;
        b=Gx4Yz1eNvrX4mOjA6PkX5D1zC8wFZlYoKrNSTTFLf9eeaeuNTxLMuu/T1im7wxim9m
         wybyokLB20K6QoqwPfZ+kUEVnXgtxOUEEnumBDypMlhl2PqbRwwMB0aW/1yPGrTsGKGJ
         T6SX8BQMgTfFe8ozL1jP4HFYOlUe6iD7N1PBOvjdlsLZVA/MaoXnNkIxAFFtZFQPjnY/
         c+O73GfrfxTjcoAAAYDd4F5eYHHe32YmqCm8qZxXH9IG5GbPti3SgOFl64oGJ/RVumpv
         IA7LvTeRjTAyo+JKmR9zFcpZbcCbrbdYQPZ1ITVA9sxFW2RotzmtYq7lfeAoEqvc6fl+
         O4Ww==
X-Forwarded-Encrypted: i=1; AJvYcCURAaxlWm0m0jsStkgZz9AXBHxGVye8p2/8ilZFGnHOAdXQQbZsjjIBXVVXkrk+GvJUnrgZpX/HcA==@kvack.org
X-Gm-Message-State: AOJu0YyjPnj3/y8cVNwaXb6KciaTrcYiCBy2O6l4FJg3Q+sa/0O6UTg4
	hoiWBOd4jKaePdQ/6GoSJIp07j0A4sXkIKCPnhpfBqcxMLJ8Ydvn47ID
X-Gm-Gg: ASbGncv3ddFtufZBfiUFfUhYLfhsZyrjJOQPK1S9uo66FT10cVpCphDWMjC7gHyfQnc
	MuVJ9lHjiBmLWNiBgBvc6UDXa9FjLQPK6u+MH6LEQBAJ/CkIq62q+OFM2W03edlHTfvg1HMOElN
	odFHiGgEJ1E3huYHhrYUee81HLvlKcz6j1E7z328XhAa5Nx21aIg4iWQrw96YZlgw7YJt+FzZhk
	Mf2BBwilzM0UfOtdIdB7D/MeHNfQCFZa07wPjGMY9T4vCEsODdPIScbUAf75ZQPULAOUXPPWLDA
	ZG2MzFWNVwJaCjMIZDm1gh9NX8qv7dCEOdjftKAFQiiGVSMlNIqtLkBW65Dge1LCgpJpkJK1l/v
	WE6EePPpuxl8dU370WeviGASxF7iU4sBgW9NCdqbE/pUa/gGSfMRpNxJCA70nJJ+FHWvzLzBM3g
	==
X-Google-Smtp-Source: AGHT+IFgl+sw+tmEYUJ4upz5Un2DxoHCv2E7JtarNm7ur8WtEKTrx96zo+yDn11a5xFBTb7wAEqpBg==
X-Received: by 2002:a05:6a00:180a:b0:772:ce8:d894 with SMTP id d2e1a72fcca58-7723e3e3aeamr22624402b3a.29.1756945389846;
        Wed, 03 Sep 2025 17:23:09 -0700 (PDT)
Received: from localhost.localdomain ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4bd2aesm17579551b3a.48.2025.09.03.17.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 17:23:09 -0700 (PDT)
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
Subject: [PATCH v2 09/18] mm/ksw: implement stack canary and local var resolution logic
Date: Thu,  4 Sep 2025 08:21:06 +0800
Message-ID: <20250904002126.1514566-10-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250904002126.1514566-1-wangjinchao600@gmail.com>
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 061AD1C0004
X-Stat-Signature: yebxymce73mqpok79uy94f9f3hgki8c7
X-Rspam-User: 
X-HE-Tag: 1756945390-806596
X-HE-Meta: U2FsdGVkX1/iVUPEdf2TwsMkjIhJsLGlTb6NePt/1NcZk2PdVw6Fis6vcerXa3XwVuLQ/dIp9KwLPtip2qSMrMqbSaWxCEVeGaSr/dgEMjJ2gfEXJoYZbz5uNl2mdbzSsJnxLCnJFu2x9vBxZ2hSkxzLl2FfS7e3Mx16qxfa1+O5SXsONzJwN/nDptkiHWhTsePNTjdzpOV5+AlnBbRIYx9u78qTT6fVRBAQNJDkpdreHGBHvvFpjnIf6FpsUJeHW1nLYqyY/l3QYmW52+lyWoYfThTPPxrHiTHJxFhs6YwIOhUIPQGESEOfaEZ09eWt7IaD9Rfwqk3bd/vP59F02151YVeFpTG0q77xLOd6HQK1Dtv8xGKN/arER0dRlEE7/xrO0wNgCqEPG+/xVnB0HTnYnzG20LNqAEAv3QYKn5ytdUorzLNVX0uYqmSA5gP/PmzTE/YF/YE8JnC/c9lGPs97uauEP+dpeoPDEPdNIGmjwbMrNrRJi9fow1TcGATlOepI/ZA4GQ3m8F+0e+lhXLcJJCAwuUY1Fn+lJUw+Y4tuY+biun0lMU9S3a5yEOnzcGVFKwrKLqCjMHHhzVyaY+HcmRrnTAGLgtjur9PUQWPmCGG9wf1bvC72KHkkQEUN/Ic52+9hb0Qv31o4YF62Lk/EhVCaFkurnx4BHQYtbyLhcsZyEmuOop7o3mBUoB2TFmauH1s40dXr8MkerbMwptvvoeXPG1uCu/LlicPLh0dYC0+WhCCS5Ejiy2Ut9mxSjv5biiVotc40L9OVb+CwO3Hg2kg+x9GZji6q4Uf+Egb0QWL0kn3oZBH8enzNACfjKEyCysclkRVjbIl0tvepDpW7EUH51Pj2rcwS3n5U47VYL2U+ibjyIOJ+jdu917c40/+2CHqo2tbaJg+SPui09FEgIulmtXM2rQqJTMvQNnrOSN8nYa69h3hPGZBlC3LV5D3ngW2iulv1f1e5ELn
 ZzchXwPO
 HJ8xmboZkqZP8MqvGICCZ/UiE/aHRK0K/kg9Hw7UmczAqR3wEBQFfxGPe1E7S+9i5twU2+JQoJI7MIujJvyP7QWnJAhYgmdT7XWrAtdJ/AZhKuUDuDIEgP/UGWPoJBZ1vFR5IooyfXcjRefkm/xpGmS0FuJY5EkuGQ+B2JsR5YHlGniVQa919UafecmzWN2i3lwrwGQKFYSWh42BBJD+QZtx+rC/QJiP0LsZ3AHuxvpYwDulKPdcPdxqyH8eZsLnZELGpMwxsO/DNLrROPCLYFod8kUGBPDVzWTq7oHFJG4szPfihi5EF5WAm2uJTbsZ4KE0qhwsDnrbot+g+P3bq88lmtE3Jn87qWPeA206UBnLvVlzc+o9F48igEWC/XyXNbeuuC3WUpWAMigGQtbw1hmaa1o/N5TngFxgkbU8O2IaZneygJKTzl7eJ+kEcRO6kkjuT/My1th14Im7C/SLBY0OhS2vDcacUNikT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement logic to resolve stack watch target for kstackwatch:
 - Locate the stack canary within the current frame
 - Resolve local variable offsets relative to the stack pointer
 - Validate addresses against current task's stack bounds

This logic prepares watch addr and len for use in kprobe/fprobe handlers,
enabling dynamic stack monitoring.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/stack.c | 99 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 96 insertions(+), 3 deletions(-)

diff --git a/mm/kstackwatch/stack.c b/mm/kstackwatch/stack.c
index 3b72177315cc..00cb38085a9f 100644
--- a/mm/kstackwatch/stack.c
+++ b/mm/kstackwatch/stack.c
@@ -1,22 +1,115 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/fprobe.h>
+#include <linux/interrupt.h>
 #include <linux/kprobes.h>
+#include <linux/percpu.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
+#include <linux/stackprotector.h>
 
 #include "kstackwatch.h"
 
 struct ksw_config *probe_config;
 
+/* Find canary address in current stack frame */
+static unsigned long ksw_stack_find_canary(struct pt_regs *regs)
+{
+	unsigned long *stack_ptr, *stack_end;
+	unsigned long expected_canary;
+	unsigned int i;
+
+	stack_ptr = (unsigned long *)kernel_stack_pointer(regs);
+	stack_end =
+		(unsigned long *)current->stack + THREAD_SIZE / sizeof(long);
+	expected_canary = current->stack_canary;
+
+	for (i = 0; i < MAX_FRAME_SEARCH && &stack_ptr[i] < stack_end; i++) {
+		if (stack_ptr[i] == expected_canary) {
+			pr_info("KSW: canary found i:%d 0x%px\n", i,
+				&stack_ptr[i]);
+			return (unsigned long)&stack_ptr[i];
+		}
+	}
+
+	return 0;
+}
+
+/* Resolve stack offset to actual address */
+static unsigned long ksw_stack_resolve_offset(struct pt_regs *regs,
+					      s64 local_var_offset)
+{
+	unsigned long stack_base;
+	unsigned long target_addr;
+
+	if (!regs)
+		return 0;
+
+	/* Use stack pointer as base for offset calculation */
+	stack_base = kernel_stack_pointer(regs);
+	target_addr = stack_base + local_var_offset;
+
+	pr_debug("KSW: stack resolve offset target: 0x%lx\n", target_addr);
+
+	return target_addr;
+}
+
+/* Validate that address is within current stack bounds */
+static int ksw_stack_validate_addr(unsigned long addr, size_t size)
+{
+	unsigned long stack_start, stack_end;
+
+	if (!addr || !size)
+		return -EINVAL;
+
+	stack_start = (unsigned long)current->stack;
+	stack_end = stack_start + THREAD_SIZE;
+
+	if (addr < stack_start || (addr + size) > stack_end) {
+		pr_warn("KSW: address 0x%lx (size %zu) outside stack bounds [0x%lx-0x%lx]\n",
+			addr, size, stack_start, stack_end);
+		return -ERANGE;
+	}
+
+	return 0;
+}
+
 /* prepare watch_addr and watch_len for watch */
 static int ksw_stack_prepare_watch(struct pt_regs *regs,
 				   struct ksw_config *config, u64 *watch_addr,
 				   u64 *watch_len)
 {
-	/* TODO: implement logic */
-	*watch_addr = 0;
-	*watch_len = 0;
+	u64 addr;
+	u64 len;
+
+	/* Resolve addresses for all active watches */
+	switch (config->type) {
+	case WATCH_CANARY:
+		addr = ksw_stack_find_canary(regs);
+		len = 8;
+		break;
+
+	case WATCH_LOCAL_VAR:
+		addr = ksw_stack_resolve_offset(regs, config->local_var_offset);
+		if (!addr) {
+			pr_err("KSW: invalid stack var offset %u\n",
+			       config->local_var_offset);
+			return -EINVAL;
+		}
+		if (ksw_stack_validate_addr(addr, config->local_var_len)) {
+			pr_err("KSW: invalid stack var len %u\n",
+			       config->local_var_len);
+		}
+		len = config->local_var_len;
+		break;
+
+	default:
+		pr_warn("KSW: Unknown watch type %d\n", config->type);
+		return -EINVAL;
+	}
+
+	*watch_addr = addr;
+	*watch_len = len;
 	return 0;
 }
 
-- 
2.43.0


