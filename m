Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85E15FED3FC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:17:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A72796B00A1; Fri, 24 Apr 2026 15:17:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9381D6B00A2; Fri, 24 Apr 2026 15:17:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B0FF6B00A3; Fri, 24 Apr 2026 15:17:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B80B6B00A1
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:17:07 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 07DF61402D6
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:17:07 +0000 (UTC)
X-FDA: 84694407294.23.ABA1A45
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf28.hostedemail.com (Postfix) with ESMTP id 43647C000D
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:17:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TWBBTDRI;
	spf=pass (imf28.hostedemail.com: domain of 3r8HraQgKCDgmnYpYhmXaiiafY.Wigfchor-ggepUWe.ila@flex--stevensd.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3r8HraQgKCDgmnYpYhmXaiiafY.Wigfchor-ggepUWe.ila@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777058225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bJ923Ki6R5fPmM4gLIIn14hi8wnIAPg7CegKahU1aFY=;
	b=L0EB+NCPYAu7mF0+ZGlQz2GcmFXeSFx2lazC9lTPRBP7RgHFUcasM5+9GyIUXeOBu7ET1I
	+J9Pi9S8RD0kyJHufjwlFI/uhCdRS6CE+ey93ykOLrLRpZsMKsTjiaDrIq2mnRjJQD+LYL
	ZtHjLM+7B9CuNb1eGkgVrMHfBtq1buo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777058225; a=rsa-sha256;
	cv=none;
	b=LmZmwkmq/sKvDt/w8Pfce/b57HB9VTjAZAYSSmosNitCXt1WavR+I76vz/e9ZsURmczQOJ
	5nn0oeKImgkY3IDG98/xoURhZUm41hzfgp7KxZutsQ23VQY8MvhO+pCYtHqCbqF39MKsBN
	1BRQVEtelfMQmbBjTdvl2Pw2GnTJpJc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TWBBTDRI;
	spf=pass (imf28.hostedemail.com: domain of 3r8HraQgKCDgmnYpYhmXaiiafY.Wigfchor-ggepUWe.ila@flex--stevensd.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3r8HraQgKCDgmnYpYhmXaiiafY.Wigfchor-ggepUWe.ila@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2d93379001eso16843537eec.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777058224; x=1777663024; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bJ923Ki6R5fPmM4gLIIn14hi8wnIAPg7CegKahU1aFY=;
        b=TWBBTDRI7OmKYU9hQEosLzftwTqa1bkhR2JzJvUXpR9lA/okxVEjhbiRlOydGsiQ93
         HREO4D0/j42puFvWpQkjbYktgl8znFbp3f0HzQBPQNgxkvzQ1mnxs4cTvq7w8VjcvLaq
         ETlPXXHlWfZEUaJk0G6Pa79YFgNttVaViNhUuerOWNNkKoZwqnGSwsQj6K4MiOlxGxui
         /6vuJx0YRALl4OpwqKbKn/+sH0OwDfvzR1zoE7y4/3X4J9FpAjoDfp6HMoaZ4MycuTig
         FjxwykD18cD+APFSWHtD1YNafjIBsp9mAEdh1PPZRCN7Hm82NFzLck1rN0HafUSQDMbA
         VWvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777058224; x=1777663024;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bJ923Ki6R5fPmM4gLIIn14hi8wnIAPg7CegKahU1aFY=;
        b=DOs8e1ZOZi5JMnnP9qtLwyk7Qx5V4Sl00te5U+fAmphbFY1mPRSUUjZ2w+rlAvBb69
         Jn1LSKrX3sJg/Hgw8QA1RqJzk5CqdHp+ZaP14YY6DCqTfKG17f7w5sE9gbNjwwSB5lpA
         0u1XfQ02kf5TCMHGSKz6sLAYyu9FLblxWMqjVglxQLZEs652+JAWDfqbNFK5xIDlZ7sG
         rX/P7TJHeSXodvNXIAlZnBqXkk/uAjg3xrrF+O0sMYpmRinE0mqCHM+PL3X0P+K+7t8I
         VdMpSsPQ6Dzb90CniietC/9ElRyoOoQjR+t8Jr2VFjjwOYhkKB5M5gCUGmIVjGVgedPr
         +e3Q==
X-Forwarded-Encrypted: i=1; AFNElJ+AzL0DnsZ16YuKBcWU+nHaXEWa2fEv+R2M10txnH3C/0wWrCJgFarfxGCH+W6bvB9YIc2JUEPvbA==@kvack.org
X-Gm-Message-State: AOJu0Yw2EfbKnlA2V/KddFUnLJhqdMa3yyy53q5lUTpgIXkBqPKl6LMs
	Fs8tXoWoEkEfXrBRgZ3SZ9VC4nUZWzPnc2JE57XBdmppY4hL8WahSv3n4lo8XMEZfzclhF0APnN
	g2rjDW4XGOblwmw==
X-Received: from dycoy24.prod.google.com ([2002:a05:7301:fc18:b0:2e2:488c:4eba])
 (user=stevensd job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:8628:b0:2d8:1efe:51dc with SMTP id 5a478bee46e88-2e464ea8c23mr20065493eec.6.1777058223573;
 Fri, 24 Apr 2026 12:17:03 -0700 (PDT)
Date: Fri, 24 Apr 2026 12:14:51 -0700
In-Reply-To: <20260424191456.2679717-1-stevensd@google.com>
Mime-Version: 1.0
References: <20260424191456.2679717-1-stevensd@google.com>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260424191456.2679717-9-stevensd@google.com>
Subject: [PATCH v2 08/13] task_stack.h: Add stack_not_used() support for
 dynamic stack
From: David Stevens <stevensd@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Linus Walleij <linus.walleij@linaro.org>, 
	Will Deacon <willdeacon@google.com>, Quentin Perret <qperret@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>
Cc: David Stevens <stevensd@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 43647C000D
X-Stat-Signature: dmhgwz83dtcf371ttdbp978a9hw44858
X-Rspam-User: 
X-HE-Tag: 1777058225-588401
X-HE-Meta: U2FsdGVkX1/6xjyUbKhHm0prGdKpbtOWTCto/40BSSVC3LuRBzYMQ4dkORBzdgkJQWhQMxjjJa/1inm5Ks1fRpkSLLyivNq2nEeKwaXyl58SctRiXt6wGTZRf4b6W+99WGDm/DiJ7sKIYE+LQcNEkKSKVJvEHJIYwGRlcxWhFMX2aUAFPaWL9inA7axoPFuuLQbkyYQrSYhRkfzKPHd383TnHGBecdoEMFdJiS0x2VDoUepp7GSsJ1iJnjFfdUzsPVHUWTa8OS5dF97ZCb1DlGe2WGo7s/+cV5TafPA9dbH7gd5nPLGE8u5NHiXx2vGr93QzBsbu7F/wORCq3sWAlFbKlJ8yTr2dnQmeb7ykXP46nCOQxxH1OCck3BmDVIe/WUIWZXYs5uXUbuHR5dyCxq34rm830vqFkXVNuPjYW2p/Mz6r1cRYNIq8vfuJ31JlKxKnA4ADpsmz9G3NLizq3S3EtVJrN8tH8wgl8mHIzlLPtSFHfphPkOYeL1zsKiFWSfYplx21SoVxOgO4/L4cHZadWqtCxTohnPKQ7ffFlqJB30COBti8iUv/2VxmPYF+LEgGgOQ45KA36QWV8Bcgj4+xs9AMDGPoe6PeMjEVbIc4eRq/AJYkJJU/MhquXnZWRIFJniipA+WxPsOUkv1P2PPoKQFbHGvgjS52UzV0ixENfaf0t4466N113sp++ayihYa7KhicyDh2QSTH8OhAIL9s/9wnchBivGU6aXmi3hpeFy5GZ+miEjvkgCJ5e7rHvsZZ7xOBViG0pvOgSMliXCmB4aD999iuHVDZ5g3k7ij9f480cqO45IcMD6/R+3DUs3Sh+1xsBBh6qZytC+lv24EAZZeeijVOc6lSbWdttNNI4vC0QBoHVh/IcOQp0DOcUGZjAEU+AxYBxG+7/mNr32WUyJyTBRzE4Ki5Y0lN3V3KhH97AqABID52IqcC8b9r8EQu0jwvvzSReJOCeDQ
 N1ICOL+3
 doMTkPHVrxTkluz82V/Zv6a1isYIW/zZO/J3djeLj2UTAiC34wtaFGC6TN7gVfgGcBZpxBDIOV6zncqlG78gOPZk67E5nFD+q0Goye7VUe9s29O7pE/LeTUOdl1zaQ3oi5G07AlX+06XYJTvxIiZuQcIVc2/I7LKmF7VaSTK6tQOdRmTSfRMkw/cJJI0X1/cK0Is63BhZUE4jxjedVY78HMvDM5zShY8FsG6zWXLNKN3X4uvZZ0anpKW8NU6UdYQpM8hhTZNalj2m2QEttntB1i4T7iZ7darzZMDY+13NVrxiHaYhLd2ak8xbmMuO44F1TLNqM70ouruDYB5dhE/TxvbjXp0h/oXp/pLngpunVNQblAu+954Vgg8SMgHNgRwi1einhef3a+rLUc7Yz51ehFDQQEoOUPq0oX/DHH7lKA64p1WLaT6+59lCklbJ4CH1V3MJoWdjAN6ugfalVgK+WTXXhxPnibUtH8DDywdJ5Cdo1xtnZKihh8zCGrjJoG1hVbDKPS6ezMyQVt9ZZax2xNCIe6C2eRt3KY85YOT95nQxnghueSm+/Kb6ZuNO7jzHvnIfV1cvgKCXVqNDdmvi6lR+Bol2qwlNyHQbuk/zEgHHYWOKgt+UiR14UA4oYEn2g94KgnGg3fMQZQsSE2TuOsXFBzX7guCQ4/uzT6wyT4TioCQ2NU9OGNZYykgNnTbUxA07p+4ARmWQ6bhyqgJf31uoMeAaJ+1Hmxo1EQOfCtpC7MvhjCOwPANDpnA8fAel7iN1TJR7smlRLgybpehcd6sSeEj8LURimqgGqygJSep6iUiBybJlMdNHYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pasha Tatashin <pasha.tatashin@soleen.com>

CONFIG_DEBUG_STACK_USAGE is enabled by default on most architectures.

Its purpose is to determine and print the maximum stack depth on
thread exit.

The way it works, is it starts from the bottom of the stack and
searches the first non-zero word in the stack. With dynamic stack it
does not work very well, as it means it faults every pages in every
stack.

Instead, add a specific version of stack_not_used() for dynamic stacks
where instead of starting from the bottom of the stack, we start from
the last page mapped in the stack.

In addition to not doing unnecessary page faulting, this search is
optimized by skipping search through zero pages.

Also, because dynamic stack does not end with MAGIC_NUMBER, there is
no need to skip the bottom most word in the stack.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
[Rebased, Kasan oneliner needed preserving, rewrote a bit due to bugs]
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
[Handle init_task's use of init_stack, fix typos]
Signed-off-by: David Stevens <stevensd@google.com>
---
 arch/Kconfig  |  1 -
 kernel/exit.c | 22 ++++++++++++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 95ded79f0825..beffe7e01296 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -1542,7 +1542,6 @@ config DYNAMIC_STACK
 	depends on VMAP_STACK
 	depends on INIT_STACK_ALL_ZERO || INIT_STACK_ALL_PATTERN
 	depends on !KASAN
-	depends on !DEBUG_STACK_USAGE
 	depends on !STACK_GROWSUP
 	depends on !PREEMPT_RT
 	help
diff --git a/kernel/exit.c b/kernel/exit.c
index ede3117fa7d4..6caf4030e8f4 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -71,6 +71,7 @@
 #include <linux/unwind_deferred.h>
 #include <linux/uaccess.h>
 #include <linux/pidfs.h>
+#include <linux/vmalloc.h>
 
 #include <uapi/linux/wait.h>
 
@@ -791,6 +792,26 @@ unsigned long stack_not_used(struct task_struct *p)
 	return (unsigned long)end_of_stack(p) - (unsigned long)n;
 }
 #else /* !CONFIG_STACK_GROWSUP */
+#ifdef CONFIG_DYNAMIC_STACK
+unsigned long stack_not_used(struct task_struct *p)
+{
+	struct vm_struct *vm_area = task_stack_vm_area(p);
+	unsigned long stack = (unsigned long)task_stack_page(p);
+	unsigned long alloc_size, *n;
+
+	/* This is NULL only for init_task, where init_stack is fully allocated. */
+	if (likely(vm_area))
+		alloc_size = vm_area->nr_pages << PAGE_SHIFT;
+	else
+		alloc_size = THREAD_SIZE;
+	n = (unsigned long *)(stack + THREAD_SIZE - alloc_size);
+
+	while (!*n)
+		n++;
+
+	return (unsigned long)n - stack;
+}
+#else
 unsigned long stack_not_used(struct task_struct *p)
 {
 	unsigned long *n = end_of_stack(p);
@@ -801,6 +822,7 @@ unsigned long stack_not_used(struct task_struct *p)
 
 	return (unsigned long)n - (unsigned long)end_of_stack(p);
 }
+#endif /* CONFIG_DYNAMIC_STACK */
 #endif /* CONFIG_STACK_GROWSUP */
 
 /* Count the maximum pages reached in kernel stacks */
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


