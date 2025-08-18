Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA693CA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 12:28:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77E3A8E0039; Mon, 18 Aug 2025 08:28:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72EB68E0003; Mon, 18 Aug 2025 08:28:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61DB08E0039; Mon, 18 Aug 2025 08:28:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4E37F8E0003
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:28:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D3D6D1DE33E
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:28:09 +0000 (UTC)
X-FDA: 83789805498.25.1910C09
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf26.hostedemail.com (Postfix) with ESMTP id 21E29140009
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:28:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ho8G9Zw2;
	spf=pass (imf26.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755520088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5r/rBnlrAz2JUShBcJhJko8UNnWxU7/GIOhEksecdws=;
	b=SpGrrog5su+wQkvGzk1PYHwot8CfssP+Njpa3dAtY7lv8ka7VxIrMzGZO5XKziwkHmcNMK
	TPUOgbfFe6flrt6zMM21g8ZQzF4NL/saYv69qmrY1XhJDAk8SwFwzUItkoDalVXk6gu/tb
	sW0ku1yUDgWjSq7q+6eaC2ml//QUaZU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ho8G9Zw2;
	spf=pass (imf26.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755520088; a=rsa-sha256;
	cv=none;
	b=lkgq2MW3G+pztrKz5IoOfyZl7hYcr0+l+Ep991irCwSypS1XhwrI/VdKMhnoLzIWb0UNTL
	S5YRXSYLdWNHDdg7WanAW56Vot28A0BnmwpgbguK6vm5Fec8EAUoF+CN7HYUzpuxDYZWcg
	XMY0QbK7jwCzqDjF9RWjc6ZS2VByg5c=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b4717563599so3716793a12.3
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755520087; x=1756124887; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5r/rBnlrAz2JUShBcJhJko8UNnWxU7/GIOhEksecdws=;
        b=ho8G9Zw20P49aIEnbx7LWyxz19v8aL5a0dXacSLP7WoM2XZ6mAQN4V1vU3IjYejWFW
         sLPuiO+9uvxM+y9cLl6ZcS2aRMzBdw+nmNjdyCkN6zC+DTco5d/+IJMHnIhdYQhAa2an
         3yXrVs6PbcmQoUzYlPaeU1IcgPNXSvBqdmD6JFSyTmjjxZfEaheGc88J8t/gqqS30f6t
         lOELl10RWBlgx2i+VQ/icH7okToYKkWbAMVPNSdh8Y8Wdc+h9MZB04xSRsOezZnkSOh8
         jTiQAD81tbshq/K8lBsuT/cUTWx1IDTcoS1DhzxBiR6nlhPP/t3qBQpo8PhF2fu1AR9K
         Dkvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755520087; x=1756124887;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5r/rBnlrAz2JUShBcJhJko8UNnWxU7/GIOhEksecdws=;
        b=b+hGSkRnKhbXvcDa7YAOchTvXmQQtIEny6Ipov7zjnblmLVGOLyhgKHJcHGsa9WI32
         0s//PqDznstp0zzv/saYBsOTiApZ9X5UlgEwS1l4wuzbe/cBMCBITfSGM/yX5E1nVgvV
         pCOo908xB0tYrOQ64Qd3vNFE422HgG3CWQAABe+wZy1P98oLKaahaWTcuj28n0vdqA4R
         iPIwHIV1BgjkqsbDDTy6X5xF0XKe0QP86clOwLFZ5F1wbJB4JEqhPhKj7+81XDEWfc0j
         8zcJ4+REw9Qm31KpPm79q9yG7xlvjmI1LMB8IdjZYkhKkZmZNWehTGMK9Z0h2FPNkQTL
         I9Iw==
X-Forwarded-Encrypted: i=1; AJvYcCVAZ88yBuVmXj+sTbeabdLPuCPxdKs87SRDtoqXcneafFesRQIA+3QSJvdEXtaK5E2VJx+xAE7y4g==@kvack.org
X-Gm-Message-State: AOJu0YyPZrE9BvrJnD7/kDxiOth6hFx2dq+6ZZGig2TdCP3X2GKxeVoE
	SZi868YgP5RTtIaiG2Cwvv7ZVy7nbY5r+esvWHV4+1zqcSzr/e0oEcAi
X-Gm-Gg: ASbGncuDQ9BVwmvwf2EBXpcwV0waDaZNoy/f3vZB2otVOsh87TIgdLoD1xSw/Y6Nljo
	i6Azf78HZFAs1gu1HLzGT86Cs812OAfJ182bDvLrNtMHIr9U/MasMiGjZ1JmV6Ijn5wTlIc9O9U
	D26xjoYzV/Yw5roUZzbs+/DROgpD26WMRuVI1CPMeYa65BDcJnxurGpxigg5jCbUZtG8PqlIpCV
	wVx6tIZI76TZWiGcOy+fqyIizG7N9K1SpUg2hnfaY5J5G4V8ipUba8aP6JN9f9yuVu/eS9GdpTP
	JLUPGW03xQkOCWRcW7oVCpG7VasbBQ07T23O2Jig/jdiuVjXJyq+CG320NDTXMvI9OVxVRJvPAV
	ViBUON5ujx65YINZoUzS5CjndeUjGhtQGJQ==
X-Google-Smtp-Source: AGHT+IGHyYvjw3/xjKEbFWxvWOpN+yD20ay733SJj1UymheSVFiMUKAid/csXjqcmpErxiXXOowrqw==
X-Received: by 2002:a17:902:e5cc:b0:235:15f5:cc30 with SMTP id d9443c01a7336-2446d738d05mr145756665ad.16.1755520086807;
        Mon, 18 Aug 2025 05:28:06 -0700 (PDT)
Received: from localhost.localdomain ([2604:a840:3::3008])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446d57f12esm79236705ad.157.2025.08.18.05.28.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 05:28:06 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: akpm@linux-foundation.org
Cc: mhiramat@kernel.org,
	naveen@kernel.org,
	davem@davemloft.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [RFC PATCH 04/13] mm/kstackwatch: Add HWBP pre-allocation infrastructure
Date: Mon, 18 Aug 2025 20:26:09 +0800
Message-ID: <20250818122720.434981-5-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250818122720.434981-4-wangjinchao600@gmail.com>
References: <20250818122720.434981-1-wangjinchao600@gmail.com>
 <20250818122720.434981-2-wangjinchao600@gmail.com>
 <20250818122720.434981-3-wangjinchao600@gmail.com>
 <20250818122720.434981-4-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4yd94qsnzy4rd6qz337wn39u57uap7n9
X-Rspam-User: 
X-Rspamd-Queue-Id: 21E29140009
X-Rspamd-Server: rspam01
X-HE-Tag: 1755520087-552497
X-HE-Meta: U2FsdGVkX1/LBCK9zvfXixqaXGe/RTAdDl3uYr7Jkym/eArnQyWZCj19/+hmj9p0yxdsmlmSWXLu7crZH5lbmUu+UIsrg4JuIjvq59AK3eqIMjlc4zNbZm/ojBTyhgQ4qPDbfrkLmifi5rCEoNoXK/F0apfGSL8ipf2Rij7CxeX8l8yy7PHBZJHuLEEzi8H33f35B465gfhcMXyqpBxAO5PwUjEbvJba+JFBxQ18d4KZmGXnMwh5N7OOEEyibk4RhilpS0p+CZlWkRezXChbJfXZejq8/wSuGI4TRt0SyAxf7KY4nUeZDHcdO67HLIswgSutwWfOadWwdVETgB3GlyxuMpOc40z3avReq44wR2bxrbpzss6GQ9QJtUGWFI84XzZmJ1iylA2fy/Ake10ujTimqgBAqS9TntSkz15y+8+lmzajOWNIoA2TcE6aa3Vl5LwX5BZZuRdazB0a16GGbXD/9ZWfp7s39Rsun3Rkdetbs1zhMj8f1x8qmpS6bxfZAh2l2n3V1m+ZOo3LQKGJyL+NlPEWK4PNIpsUP1UStjMopBOiRV1L8qc8qu8wcZB5R55jUTHunSp9pzcBK8CDBlFcOFX+drsjeYXJklCQeVnQPV1uBDGHmxcYnuEl8xg8WUhR8a7YlrI/6XZGpiJetCkdVvkrvD4OyW5ITNLbM8T/LDmjVGJemmON8IYXsqlHlwGxs54GqgUxG/2aHOXCcyODFQqJ4dlMaixe7d0/24gz1IOzyYK09cj6SHtawOnEOT76FEEJNGHK4qbeFGIGAdZtWHv/eJHPNIZ3tf+osRRhonI2SX1jNrTZCBnzuO42WN6nSQvEKsjVE/0iNXpWoc2viJ0jTcT1KLpjMafje5YlKlgOYxByJa0ruSyZpiaAhUs6z0nBycAl+RvnFn/SbQROHiXcZ04PdV2QTpwnfs/ipHVCy9/Ks+TUfIS6+rDugZ9/3pKnJroTHRl6xXu
 JkmtWssg
 eBqQ/LqKj7i4QFzl5avo7d5WPxrfxvvXlKmhCxw8WttW8mUO5WaH37QojT7w2wdETwHsPRKpMGWYjGNQitYVIKs5ziw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the core HWBP management for kstackwatch with
pre-allocation strategy to enable atomic context operation.

This patch introduces the fundamental breakthrough that allows kstackwatch
to work in atomic contexts: pre-allocating hardware breakpoints across
all CPUs during initialization, then using arch_reinstall_hw_breakpoint()
to atomically update breakpoint targets without allocation overhead.

Key features:
- Pre-allocate per-CPU hardware breakpoints using register_wide_hw_breakpoint()
- Initialize with a dummy marker address that will be dynamically updated
- Comprehensive corruption detection handler with register dumps and
  optional panic trigger
- Clean resource management on module exit

The pre-allocation approach is critical because:
1. Hardware breakpoint allocation can fail or sleep in atomic contexts
2. kprobes run in atomic context where allocation is not permitted
3. Pre-allocated breakpoints can be instantly retargeted using
   arch_reinstall_hw_breakpoint() without any blocking operations

This foundation enables the subsequent kprobe integration to atomically
arm/disarm breakpoints on function entry/exit, providing real-time
stack corruption detection without the limitations of traditional
allocation-based approaches.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kstackwatch.h |  6 ++++
 mm/kstackwatch/watch.c       | 65 ++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+)

diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index f58af36e64a7..256574cd9cb2 100644
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
index e69de29bb2d1..5cc2dfef140b 100644
--- a/mm/kstackwatch/watch.c
+++ b/mm/kstackwatch/watch.c
@@ -0,0 +1,65 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/kprobes.h>
+#include <linux/hw_breakpoint.h>
+#include <linux/perf_event.h>
+#include <linux/sched/debug.h>
+#include <linux/smp.h>
+#include <linux/slab.h>
+#include <asm/hw_breakpoint.h>
+#include <linux/stacktrace.h>
+#include <linux/delay.h>
+
+#include "kstackwatch.h"
+
+struct perf_event *__percpu *watch_events;
+struct ksw_config *watch_config;
+
+static unsigned long long marker;
+
+/* Enhanced breakpoint handler with watch identification */
+static void ksw_watch_handler(struct perf_event *bp,
+			      struct perf_sample_data *data,
+			      struct pt_regs *regs)
+{
+	pr_emerg("========== KStackWatch: Caught stack corruption =======\n");
+	pr_emerg("KSW: config %s\n", watch_config->config_str);
+	show_regs(regs);
+	pr_emerg("========== KStackWatch End ==========\n");
+	mdelay(100);
+
+	if (panic_on_catch)
+		panic("KSW: Stack corruption detected");
+}
+
+/* Initialize hardware breakpoint  */
+int ksw_watch_init(struct ksw_config *config)
+{
+	struct perf_event_attr attr;
+
+	/* Initialize default breakpoint attributes */
+	hw_breakpoint_init(&attr);
+	attr.bp_addr = (unsigned long)&marker;
+	attr.bp_len = HW_BREAKPOINT_LEN_8;
+	attr.bp_type = HW_BREAKPOINT_W;
+	watch_events =
+		register_wide_hw_breakpoint(&attr, ksw_watch_handler, NULL);
+	if (IS_ERR((void *)watch_events)) {
+		int ret = PTR_ERR((void *)watch_events);
+
+		pr_err("KSW: Failed to register wide hw breakpoint: %d\n", ret);
+		return ret;
+	}
+
+	watch_config = config;
+	pr_info("KSW: HWBP  initialized\n");
+	return 0;
+}
+
+/* Cleanup hardware breakpoint  */
+void ksw_watch_exit(void)
+{
+	unregister_wide_hw_breakpoint(watch_events);
+	watch_events = NULL;
+
+	pr_info("KSW: HWBP  cleaned up\n");
+}
-- 
2.43.0


