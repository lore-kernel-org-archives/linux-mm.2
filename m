Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96B0CC44507
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 18:31:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DD9A6B00E3; Tue, 14 Jul 2026 14:31:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68FBD6B00EB; Tue, 14 Jul 2026 14:31:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A54F6B00EC; Tue, 14 Jul 2026 14:31:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2720E6B00E3
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:31:41 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A1EE0160499
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:31:40 +0000 (UTC)
X-FDA: 84988225560.28.425371C
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id CEFD814000B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:31:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BpdmqOo1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784053898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gexNtD7XQMYc5ZpBXX88c2pnTg9Mi5LE1qEYRrtsHvs=;
	b=c/ep0jp19rc3AIduVvd1v5aTXDttyVJdAGfINayyA/oIHmIv1Ag0m3Ka9I75YLx2r4Oil/
	W7kSTkB7CyvoxhntYY5LsN10wdsGQJro1uwUE03AclcituHe/82JvjewWOCC/DyZ+1hffm
	GGJtWEBlhdX2YGXC5Czh7uRdIciyAJ8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BpdmqOo1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784053898;
	b=7TcSCMhXLA9bC8k98OT5fh/IAokxOazPVEP+Ufureq/yR8OKSy6EZvgNxgaugrXoEtHuV8
	rdytvDsW4hryB6m398WXj2H8aUpFpySN8I+5S+PZyMhH4AwrKHFHoNJAaiwfYzAX9oHQ/C
	cOOVs32nhsBOxmLpPxiCMz9V/WXgK80=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-92f03daaa97so252848985a.2
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784053898; x=1784658698; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gexNtD7XQMYc5ZpBXX88c2pnTg9Mi5LE1qEYRrtsHvs=;
        b=BpdmqOo1Ud013S4jhJg5qmpORM7gwBNps1mVClL38jFRq+FeFI2071TDcZm2KHwUNw
         QP14Z59ApAyieq4QqpWf3qzde55do8IntT5zs0o0il3DIuFuiiXZFnPr1FuH+AMi+6kf
         x1jcCrElSVYUgpcvNKyPSnu3abGzbCQlbiqyuY0Y0iNu16wFNuO5WCN2cLpqosi+w6jB
         JDM9DzpDnQUMzGrt8k7opJMHKT/WL8weFDvagWYcDvsL8hyZO/UXypshazzxkWIimYzH
         ANf05Uc2p1LoBZq55DTFYtThIW9ch4a4vrXe3AI1TF73EYtHIaZ7kRMrh9ON7qJf26v6
         FoHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784053898; x=1784658698;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gexNtD7XQMYc5ZpBXX88c2pnTg9Mi5LE1qEYRrtsHvs=;
        b=RVjIE+bFr4OMxgMYcYHbDSSjCorWw+ssnVk1iXruFa1ezVelLwjDPZPYySUeWH3xpg
         CIEkbxFYyWnUziypMAxh/sIuQje76bgYQAZWWMdRL0vbErUqSKw1bElwqNA/hqfxXE4o
         4MDXnKfoGSYt7PuO1wiVat9oo1KtpemfALFoZ5HElPOHfjcfOOpazOGlkVU25gN7bxkP
         NFwpnmK4ql3zwMLVO9FQ1rJPAi0o73QPu7EythfN/P0Rfen0A5HqMwavpsam75ZRp5zR
         9hpGLdr1GFE0dlenwOZPu3Pw1m3jZTtr2QDhj8QdTxLbiLHu8fVK6uUrIylmw6kSuuZm
         kkPA==
X-Forwarded-Encrypted: i=1; AHgh+Rp+96k9cJZZfX3u7WA28zcIxTpaPaO3afUu6q6kitCaEnHRvt59jVTTXiCIq5KA4c+YRckUN9C9+A==@kvack.org
X-Gm-Message-State: AOJu0Yw20HTjNUYIIiLaR/KRF6qzeQFKCWzOKrb7l9AKifhFIZw2dEqo
	ZmVOKUJs66NL/ib/48UoLRl4Y9jtkL8yGlTB988JHfjYw7p236lto7zn
X-Gm-Gg: AfdE7ckwz86CbqoqVeiQrJ0oWnKrQSNiOHqCCmdHebC6ELiYu90IiWg5eH2eva3vgYM
	DG9VgUQIwnD60I6C1epDkR/Wh2Vz8uTzEYZGypnMZgwoEDfTDprLtlyV8RK1BDM3JXhK36Che4G
	jg4p04zy5NdMhpYHWZa6VpTF+RoWcKdYVrS1DLFQ6iiVyoWi4lywQug9QYVX00YucdLKJBMAe+V
	/K1joU3Fytrm3DjwIaJRQ0OgMHy1cnb9aCi7W2jekPoIwMGoFk+OA92Zq4I3PnehHmVrJAHk0KY
	5cw3b76u3vdzZXO5fI28+hn+Twe16aHZM8zvC1U73QrGoWZYJ57x5c35/0e5OGUQOoKIjBX9KFp
	eKShOUMverZSD5qh3fRHheLtEZHKxtIwlLmYdyyunxhnBBK60Zf1k+1HIhIUzDDw0luXY9tfiKg
	JHW2ImMYE8mTTNfngEueWbCGH3ts0Cvtt3c2wBJQsMXjzOiY4QwAfDqiG3wHp+rg==
X-Received: by 2002:a05:620a:40d6:b0:930:927f:f81f with SMTP id af79cd13be357-930927ff9b4mr130636785a.91.1784053897781;
        Tue, 14 Jul 2026 11:31:37 -0700 (PDT)
Received: from localhost ([48.45.163.146])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5bb3542sm1473718285a.20.2026.07.14.11.31.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 11:31:37 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Matthew Wilcox <willy@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [RFC PATCH 06/13] mm/kwatch: add lockless per-task context pool
Date: Wed, 15 Jul 2026 02:31:29 +0800
Message-ID: <20260714183129.12542-1-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260714182243.10687-1-wangjinchao600@gmail.com>
References: <20260714182243.10687-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CEFD814000B
X-Stat-Signature: xn915u8h45ww6s64c8z61fayi4jjmnqn
X-HE-Tag: 1784053898-157681
X-HE-Meta: U2FsdGVkX1/R9c5NGybPsZZapiMre1V86iJH4N3qjsblSoK5NEoQTv7VoEv69CxS8nXpdxASVS3HwIA/bneEnfK//toeFEsIHEsTS2s3oUeT8b4Tifuo6snVVKflP2+BV8zzklM0QG2W5DfvnuDwicy8YM0/bMNiY2NFtDZIPIOHidyMK9qPaBjiTYJAcdHcZKjGq+wMX9Eev8jQhcDPrRzjIvHRCKY4RkPFAT+xxCTvBsVRFbNnwZkjyGemjaxzb9hhUZblTF6ovSWVa49vpndupYB/hdNPPVQuRZ0B/JQ8pS369sXSNQi6lodk2QRp1GplzSWnaq7oiJSpXh+vRI+HJFNFbmQ/NxWBKUzFja/TF20NRao2lICj15z8YEFussyZdxP63iHheuctCOld+D/nXMPrphcWUvrUg/+bpM0KFXLFXczenPZCQNk1zA8qyHlsec8LAymP7lrYlSiWm7c0ZV0f8J8k7RgTgMl7RU/DmS2RZ00dt67XVnTe6VUySoUh7vgI6n+6gfWWFxh8lkp1PtfKh00yRQBCvzowOG0tdg2o6So5T74/8m/GZePYQMwDr90qlvcXbI42tHo1MJJHqFEnENvheXqVy3DEYR25KbQWai+wmwVgy/M8np59Gpc7JNcnRNQ7tJfKJEI2QE3gkNkYwgYDpZ5WrExMi0ctV+hXl1XqAtpurJNaTtcDRAl8squFdVgQxT5OXeQm9k8rTDR64ysj4b68xuFpUqvzVdrablG48M07H2SbwBjHXCpAaZNgyx5zO/6YKXR3ip1ANK14fwWzfO5DHoCwtR8OVx4/Ii2Te6o7RLb0F2Fe1viuBxFpeTsJ6PiwDNd+u6Bn0MmXJPQadLJ17JBirB6op9wGN814ssXbGn8H1smklGUW4oPn4IoqaQCMvQrEjeeicISAOR5AsEaBNnw6omU+9Rd5kHAwaRsSy39a9ZqGBZmmiqT3cPfKir0XU5k
 q6y2/bFL
 wWbi7HK9jjrs4YE/G7G0NUZLnPbUsPpxVNkQMSk0bzXH6iVI/iwriIVko56zeigJRrF4fMPqZMpOxbvZIU5UkTq+zkQF/PNxpTpYxe9t+vFyQP1WxjuDZ6b2QXt1C76fspAor4JF7rIEecVG3ifsq4Wxzn02HjL3huGV+jGLJzFAQ9SrrHVXi6L0y6qYeXPIi/n2VNPGnd41VjV4fjv9elk8CNpJhy0x/ncpXqi+j5BtjxyYX0Du+XHzl7k55POKT0l8av2/CBRkx58y81OkdloL0IPpY9w/DGmY1cumOqgebFfvon50RVbKTw6xF2B0b7sQ//WtZRpeTafaIjmW5a4F5YqU74JNRrh+s4aBiatl2GU+RFDVjNwDCowcPFEQavpdZzLJPoh+EdJCZh0MWAYgtA8+GfhyeLoRGLX55JIjCIskWdD7+O4ZRcxZfJn8xSEbZI1lYiiGP3MosMtm2puPx83Y6ZEQESy9WYaWOMAD26Ag=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A task that enters the watched function needs somewhere to keep its
window state (nesting depth, owned watchpoint, config epoch). The
lookup runs in kprobe and NMI-like contexts, so it must not allocate
or take locks.

Use a preallocated open-addressing array hashed by task_struct
pointer. Slots are claimed with cmpxchg() and released with
smp_store_release(); lookup is a read-only probe sequence. The pool
size (max_concurrency) bounds how many tasks can be inside watch
windows concurrently; excess tasks are simply not tracked.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kwatch/Makefile   |   2 +-
 mm/kwatch/task_ctx.c | 105 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 106 insertions(+), 1 deletion(-)
 create mode 100644 mm/kwatch/task_ctx.c

diff --git a/mm/kwatch/Makefile b/mm/kwatch/Makefile
index 69c21ae62123..cc6574df0d68 100644
--- a/mm/kwatch/Makefile
+++ b/mm/kwatch/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_KWATCH) += kwatch.o
 
-kwatch-y := deref.o
+kwatch-y := deref.o task_ctx.o
diff --git a/mm/kwatch/task_ctx.c b/mm/kwatch/task_ctx.c
new file mode 100644
index 000000000000..f8e582f0dcfe
--- /dev/null
+++ b/mm/kwatch/task_ctx.c
@@ -0,0 +1,105 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/slab.h>
+#include <linux/hash.h>
+#include <linux/sched.h>
+#include <linux/log2.h>
+#include "kwatch.h"
+
+static u16 kwatch_ctx_pool_size;
+static u16 kwatch_ctx_pool_mask;
+
+static struct kwatch_tsk_ctx *kwatch_ctx_pool;
+
+int kwatch_tsk_ctx_prealloc(u16 max_concurrency)
+{
+	if (!max_concurrency)
+		max_concurrency = 256;
+
+	kwatch_ctx_pool_size = roundup_pow_of_two(max_concurrency);
+	kwatch_ctx_pool_mask = kwatch_ctx_pool_size - 1;
+
+	if (unlikely(!kwatch_ctx_pool)) {
+		kwatch_ctx_pool = kcalloc(kwatch_ctx_pool_size,
+					  sizeof(struct kwatch_tsk_ctx),
+					  GFP_KERNEL);
+		if (!kwatch_ctx_pool)
+			return -ENOMEM;
+	}
+	return 0;
+}
+
+struct kwatch_tsk_ctx *kwatch_tsk_ctx_get(bool can_alloc)
+{
+	int start_idx, i, idx;
+	struct task_struct *t;
+
+	if (unlikely(!kwatch_ctx_pool))
+		return NULL;
+
+	start_idx = hash_ptr(current, ilog2(kwatch_ctx_pool_size));
+
+	for (i = 0; i < kwatch_ctx_pool_size; i++) {
+		idx = (start_idx + i) & kwatch_ctx_pool_mask;
+		t = READ_ONCE(kwatch_ctx_pool[idx].task);
+		if (t == current)
+			return &kwatch_ctx_pool[idx];
+	}
+
+	if (!can_alloc)
+		return NULL;
+
+	for (i = 0; i < kwatch_ctx_pool_size; i++) {
+		idx = (start_idx + i) & kwatch_ctx_pool_mask;
+		t = READ_ONCE(kwatch_ctx_pool[idx].task);
+		if (!t) {
+			if (!cmpxchg(&kwatch_ctx_pool[idx].task, NULL, current))
+				return &kwatch_ctx_pool[idx];
+		}
+	}
+
+	return NULL;
+}
+
+void kwatch_tsk_ctx_reset(struct kwatch_tsk_ctx *ctx, u32 new_epoch)
+{
+	struct kwatch_watchpoint *wp = xchg(&ctx->wp, NULL);
+
+	if (wp)
+		kwatch_hwbp_put(wp);
+	ctx->depth = 0;
+	ctx->epoch = new_epoch;
+}
+
+void kwatch_tsk_ctx_put(void)
+{
+	struct kwatch_tsk_ctx *ctx = kwatch_tsk_ctx_get(false);
+
+	if (unlikely(!ctx))
+		return;
+
+	kwatch_tsk_ctx_reset(ctx, 0);
+
+	/* Pairs with READ_ONCE() in kwatch_tsk_ctx_get() */
+	smp_store_release(&ctx->task, NULL);
+}
+
+void kwatch_tsk_ctx_release_wps(void)
+{
+	int i;
+
+	if (!kwatch_ctx_pool)
+		return;
+
+	for (i = 0; i < kwatch_ctx_pool_size; i++) {
+		struct kwatch_watchpoint *wp = xchg(&kwatch_ctx_pool[i].wp,
+						    NULL);
+		if (wp)
+			kwatch_hwbp_put(wp);
+	}
+}
+
+void kwatch_tsk_ctx_free(void)
+{
+	kfree(kwatch_ctx_pool);
+	kwatch_ctx_pool = NULL;
+}
-- 
2.53.0


