Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 421B8CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 12:28:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAF2B8E0040; Mon, 18 Aug 2025 08:28:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C60E48E003F; Mon, 18 Aug 2025 08:28:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4F848E0040; Mon, 18 Aug 2025 08:28:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9EF3F8E003F
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:28:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 695F91608AA
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:28:47 +0000 (UTC)
X-FDA: 83789807094.28.2C86B0C
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7FCCB40003
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:28:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K6IFldaM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755520125; a=rsa-sha256;
	cv=none;
	b=UmxVVSIpia/fXsUs1AWustBZCUfSOmyvFBU1eydFX1HPRfQoE3UQsm2Aw/DQxtIyVWB9P/
	mxXB8D53x/uMAz4bsP3kLAtUYzRGJsbzwzAoVxSDFuoWgchD117ENXDfWmcavtQw+OT8yX
	QntJjGL1GAwACao+AlKEDCs5oVGEeIs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K6IFldaM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755520125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pIPvLPw4y/uoDDSUMecOSmbUAqRxHZwIYoUWaeWEArc=;
	b=lRW6PRxRHwWo8LjrguOEGS/ZzxKgr56i0DC2mmgQnnIP2/spmK7VY/rhOXOoxrRkCq+l0E
	LhvVqno/uaVfJGS/TjFfNwELNUKtLJ3lK9M7FWPbvZT58ceCINKrsUt9alxKcYZ48URhQg
	VwuLGoXGqROzPOKK4Ui+yS32LQSNXSg=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b472fd93ad1so1696410a12.0
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755520124; x=1756124924; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pIPvLPw4y/uoDDSUMecOSmbUAqRxHZwIYoUWaeWEArc=;
        b=K6IFldaMh/KGQjAJ1tWqRjwAlOQKyG3poAsZWzfTentIJ9K1L4xcGbsOsbDEofkmEl
         wuOwghvAe12r5ITtEqYAH+vATZyr9HIM3eNtgzQvRMPIQYwyYhLhe6rN0ZCQgZNjuIPo
         7D1aqZ5Nc6JsAmZ96NgQVwFm2dfo1paE6Yey00La29Ao3LV54v/r7sP6aHM5J30Hx1J5
         fv73z1eGrH9Y1VccikqTfA1IufAiensnF0RmP+78IZm7LkimL0UiKtPLDwOawyd0NP7v
         AFAlmgfEclRXYngclsANC5Z3U0LuxuKyJ7SKgD3nKl4PQiKRVOk0f50qIDB5NziGlhos
         68yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755520124; x=1756124924;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pIPvLPw4y/uoDDSUMecOSmbUAqRxHZwIYoUWaeWEArc=;
        b=JF0HITcVnmwLUB9Fbd0HYe5vNW5ON+b8jZHaTZix9+CImfk+oiKlx4gXpGd2Dmqu7y
         ov7XgYK7tSKz28gmBSI1kXCRPu3IQlh8tBrhKW6uCeyJJlaoiWv5NevkJEdPkCTf6L8a
         +x9aXsKPMHpPCoKOi0w6zGsoT5hIJ1XoKbaQkPek4y/RctVubb7z478+tJ1pybx0BSP9
         uoK3iHTxo8L3H5f1+h1e7AwvgVuXKNI7Y/hxLyNv9MnykNLjx1pKEcnhQZI6d4PaEVpH
         p82vUlu67WOv+sCsnrbLo1FXhkYqchuIqbW04VrO/oeYWEV/t4FeRu1pLwCnjUAnXRRL
         8qbA==
X-Forwarded-Encrypted: i=1; AJvYcCWW2bP3uK6rZIA0HqT03x88Uu4fVBdCq+ymp7IA8JNtaUleecby3ZkT4yoG0UMT/atcW0RgNMPXiQ==@kvack.org
X-Gm-Message-State: AOJu0YygBwtL8AuADy+hNzRqKo+SuCNTE4QTBrd5UTjLRXWpyCfopsFK
	IfKbzsxLoMWaz9YW9EI8Kj1NDkaHrO9893iPs0jo3HJx0xqtYBA5KjhI
X-Gm-Gg: ASbGnctll6HgdZkzf8NirbnsvdvgbhmDCuOqgP+rrWM/3ny2zMC1/C1F9iokHXehjit
	u9dQj0BrYI7HTVqbYeqDfzberW64w31H4aYLUCEFg89l9Jxv3M5lgz1KC4OxXNbcxZygcSDFIeR
	xTN1FyqsmZ9ECiaPR7GF6vKsBAOSXRBmxD9nLlDx7pXWzFXZosuCwtd+PrTWT/UqM9k9M2ugllB
	kxqPI9aIsmcXCypSpssLHt3gJ+EOR3qcpoEb5vtTxfY6xr+pax3zNavEbqz5P09caYs8Yf3YJSz
	GHeGvQjtN7yHXfddZzG7hNzJW9gV4OiKLkbKH+qYwAZWqY0PJq35gQ95qUgTOZrTpUFwNwWQclH
	rM9gUCe8ZavGDAxLYaEd8BbDm6BvIe8LjasdsLo8=
X-Google-Smtp-Source: AGHT+IHXzJWZrBcfPUQBTA8CFaDhfN1gN+ubTm3VPS35j5MVL7+7/Ca6H/QcEcvKVgWMeEKXBh02eQ==
X-Received: by 2002:a17:902:e88b:b0:243:a16:18f2 with SMTP id d9443c01a7336-24478ed53d7mr115333695ad.11.1755520124305;
        Mon, 18 Aug 2025 05:28:44 -0700 (PDT)
Received: from localhost.localdomain ([2604:a840:3::3008])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446d57f12esm79236705ad.157.2025.08.18.05.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 05:28:43 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: akpm@linux-foundation.org
Cc: mhiramat@kernel.org,
	naveen@kernel.org,
	davem@davemloft.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [RFC PATCH 10/13] mm/kstackwatch: Handle nested function calls
Date: Mon, 18 Aug 2025 20:26:15 +0800
Message-ID: <20250818122720.434981-11-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250818122720.434981-10-wangjinchao600@gmail.com>
References: <20250818122720.434981-1-wangjinchao600@gmail.com>
 <20250818122720.434981-2-wangjinchao600@gmail.com>
 <20250818122720.434981-3-wangjinchao600@gmail.com>
 <20250818122720.434981-4-wangjinchao600@gmail.com>
 <20250818122720.434981-5-wangjinchao600@gmail.com>
 <20250818122720.434981-6-wangjinchao600@gmail.com>
 <20250818122720.434981-7-wangjinchao600@gmail.com>
 <20250818122720.434981-8-wangjinchao600@gmail.com>
 <20250818122720.434981-9-wangjinchao600@gmail.com>
 <20250818122720.434981-10-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 7FCCB40003
X-Stat-Signature: cx3gdgawf6gte78sfecpq6cji9ruekmr
X-HE-Tag: 1755520125-522065
X-HE-Meta: U2FsdGVkX199DfypMiJd77h0I0s6n00h3fTHS0AWqI/rNnqNsf1T/rvm3UUlUyL7Xn6ugMSgj0R+cdG8FFLm5hrx+tnbizOa6ajh/XB9OHm3Cbrx7ElO9WjHt9K3+C6/S4viteYdxIG8DD0sis/Rmo61/mhEB1UA3rEvwNigNJ54Cposv7RqLFOdpq9koBxbZMjgt+22kUcof8xrcqy+tHcsfrt+SRF9SS77lH8UEYcFbqpOW5+eqRnxA+tf7a6VJ+mMGcIQbT2HDzZEwNhE18CeabNn1yZMB7ntaxmewYWCtzM7MYc8qsBobxuoldxuM9Rd1jpCzLVGisUg3C1s7doy9ctEMxYu/TRL0KXk9kb9VFzqUR6gJYmpZYrkDrAkpJc80s1vItFdv7otxpYU1OPss4TnmkfjLoN4mXbpt1DGECffqJLenaOzNdzCLPaytal2FEuyQXdMrEuA+XEESUwp/N/xrxX/8T6BkAX6AGyvLxBGOE3ncl1bcojqOEEY36Nt7+tq/nuiFag0cBwgAKclRD0gJh8cXKXF1xM8D3c68yz/iJgR8BAmO6Hxoe6DBsvjiBqlnX8QFrEwwJzCJ22LQGE+YC/2lf+qxT/qUamT9y02Z9VuOrDbCcRix29gI1cfcwJwkRyIjRs37YM6yvMWCKqnSMYmwaFsEA2Msdedd8Vf/PclKUSY8J1FupJGsFHWfDW5SIn80QJ3J5dhRoFSD1WoThjSHu5NF+OMH860U7E2pXDzASzRM/0V1ZDTW+T66VU0KAcMTUKQwuECN1rGA/2R5EnSXq8IBqJaHY+/0yjIATdQ4mtLWzG4N1bY45O+SA8elQGvZWWsD8RU/9jb3ECMlpb3i1sSyNagNJm/LwSpunWVCvwUL3v0OrkfEGj18swYF18m5NeIrmbgwzCTv3dBNvsZRJmnG292jv/NR5KfFby+1KWBLTXa8hFc6YuAzlJl34fr9zDTtMZ
 hu+TmwTG
 BX0VMEE1/yWCR0XD6ehFXTvKn8PwO1bH6YOIacfQGJV4xxbHahuQDdi2ZPKov1OQ06X/Rljd9/zphfm2rYUQ3jLsJJwNkQ+EhjAHgRERL/Dk+M1rWZaBRhsiGDJeWQEN/6lUyuBOC0y5wQAHxdTVONSWlXn+g8jQb9qDg7kyR/T6RjvBIdrAv9UPqKojOuHlUpcslHiomtnycwM1HOEKiOxQJJhWaXC37xAro1CiGYIweBYkOsU8jyn/KG1Iryn7UNZqr/00K0A+6RbkzyFl9ZZi9erQ6EL9MkbAEsMbrwC73DMMIj6nLUo5N8kbcE1RBKZE5amT11lxDE+jsTCSgK3hBR7belK6yRWD/36bTa4QznXOsMNVPix8co9NPx5Qn06bLpRU5SwMBSJW/3hpzus8RuJPS+nLxgzFJchqfKCPLqA+57Qdadd+4msS1lGJK5j8Q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch adds support for watching specific depths of nested function calls.
The Kernel Stack Watch tool currently watchs the first entry of a probed
function, but this is insufficient for functions that are called recursively or
that call themselves indirectly.

To address this, a per-CPU variable `monitor_depth` is introduced to track
the nesting level of the function being watched. When a function's entry
handler is triggered, the depth is incremented, and the tool only arms the
hardware breakpoint if the current depth matches the configured `depth`.
The exit handler decrements the depth, disarming the breakpoint on the
correct return.

This ensures the watch mechanism only activates at the desired nesting level,
making the tool more precise and versatile for debugging complex stack issues.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/stack.c | 36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/mm/kstackwatch/stack.c b/mm/kstackwatch/stack.c
index ba5280787e8f..86847c2e4506 100644
--- a/mm/kstackwatch/stack.c
+++ b/mm/kstackwatch/stack.c
@@ -6,6 +6,8 @@
 
 #include "kstackwatch.h"
 
+/* Per-CPU watching state */
+static DEFINE_PER_CPU(int, monitor_depth);
 struct ksw_config *probe_config;
 
 /* Find canary address in current stack frame */
@@ -120,10 +122,22 @@ static struct kretprobe exit_probe;
 static void ksw_stack_entry_handler(struct kprobe *p, struct pt_regs *regs,
 				    unsigned long flags)
 {
+	int *depth, cur_depth;
 	int ret;
 	u64 watch_addr;
 	u64 watch_len;
 
+	/* Handle nested calls - only monitor outermost */
+	depth = this_cpu_ptr(&monitor_depth);
+	cur_depth = (*depth)++;
+
+	if (cur_depth != probe_config->depth) {
+		/* depth start from 0 */
+		pr_info("KSW: config_depth:%u cur_depth:%d skipping %s\n",
+			probe_config->depth, cur_depth, __func__);
+		return;
+	}
+
 	/* Setup breakpoints for all active watches */
 	ret = ksw_stack_prepare_watch(regs, probe_config, &watch_addr,
 				      &watch_len);
@@ -136,14 +150,25 @@ static void ksw_stack_entry_handler(struct kprobe *p, struct pt_regs *regs,
 		pr_err("KSW: Failed to arm hwbp: %d\n", ret);
 		return;
 	}
-	pr_info("KSW: Armed for %s at addr:0x%llx len:%llu\n",
-		probe_config->function, watch_addr, watch_len);
+	pr_info("KSW: Armed for %s at depth %d addr:0x%llx len:%llu\n",
+		probe_config->function, cur_depth, watch_addr, watch_len);
 }
 
 /* Function exit handler */
 static int ksw_stack_exit_handler(struct kretprobe_instance *ri,
 				  struct pt_regs *regs)
 {
+	int *depth, cur_depth;
+
+	depth = this_cpu_ptr(&monitor_depth);
+	cur_depth = --(*depth);
+	if (cur_depth != probe_config->depth) {
+		/* depth start from 0 */
+		pr_info("KSW: %s config depth:%u cur_depth:%d skipping\n",
+			__func__, probe_config->depth, cur_depth);
+		return 0;
+	}
+
 	ksw_watch_off();
 	pr_info("KSW: Disarmed for %s\n", probe_config->function);
 
@@ -153,6 +178,13 @@ static int ksw_stack_exit_handler(struct kretprobe_instance *ri,
 int ksw_stack_init(struct ksw_config *config)
 {
 	int ret;
+	int cpu;
+	int *depth;
+
+	for_each_possible_cpu(cpu) {
+		depth = per_cpu_ptr(&monitor_depth, cpu);
+		WRITE_ONCE(*depth, 0);
+	}
 
 	/* Setup entry probe */
 	memset(&entry_probe, 0, sizeof(entry_probe));
-- 
2.43.0


