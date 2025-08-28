Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BD9BCA0FF2
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 07:34:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 521518E0011; Thu, 28 Aug 2025 03:34:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AAD78E0001; Thu, 28 Aug 2025 03:34:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3724B8E0011; Thu, 28 Aug 2025 03:34:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1DEE38E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:34:41 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C01B8BC57A
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:34:40 +0000 (UTC)
X-FDA: 83825353920.29.7268CF6
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf11.hostedemail.com (Postfix) with ESMTP id E766040011
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:34:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aGDtW+pW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756366479; a=rsa-sha256;
	cv=none;
	b=gZ3ifO78hufZxdENspL6bq/50GT4igi7XjaWrODUAgt3VuFWZSCTZsABx5wTlyfxlVbEHL
	uQlXcsXwUN5VYF+TOyqHuLFxGdR3Z02lg2CXHnA2nhdlWfto6rMYliDIdu1G4yWy8bEkdW
	mIXgfPKHf8pU6kedWDvJkkkmR156J10=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aGDtW+pW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756366479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b3AulfcHa1eTu5KICr74URcMQphKQ/vLHucAGhDPpIY=;
	b=pTGJZ30aj4gPdONeZ4A1OYvTuXuJn2nY0oenK2DPvBBad86uZSinjYjOtLkdnxMtqkpuvN
	CPBYcZR8Zzp0FJaUB8wfky0MnK48JU/iVkRw9sNinq4G33AScXyHYzMEdfvxE1vFnqcoY+
	V3Vp+G99N/xC9zaSeQzL+3CKCqggcE8=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-77057c4d88bso607762b3a.2
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756366478; x=1756971278; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b3AulfcHa1eTu5KICr74URcMQphKQ/vLHucAGhDPpIY=;
        b=aGDtW+pWrtz29eMIeRBpGI6mZZJTWVwKTdzhLOXJzz/94m+Jf9TX8utTrWBBmN8qQY
         uO9F+9PkX7lRE724aih+pW6F+KhbM01pr4sQIlqWhy5X/6zcSrIljsIPF7Vz0QSxBwk7
         VGM936pQv6ZFXRfOLKIizdt1VX238OYf5Qay8zfYkSOXu4IrWTyGn5W+urMUkZcILqOe
         PpBQ+toqlmfi+XAVWBH2JwBRgX8QwLYEMNL2hJLbc1scxaVugl8P8HlA1YMKLPAyg/Bg
         PLYoF4dvK3nUwwdpzHzqrV/oyjBLwZRQICaCX+4krC9v+84HuhumDEMqyKjq2KryKopE
         IZTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756366478; x=1756971278;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b3AulfcHa1eTu5KICr74URcMQphKQ/vLHucAGhDPpIY=;
        b=HbrJn9DDNiqSCWn19VYnz9tvIzexBmnDJatAKs+5xS2C2UBDQblYir81O6sO12LQrK
         vtK3fftC/W40vtBxq8upYvlHIlJfGGUowr1httYFO3nKivaz6HHgfQu2QxQfG/tSRsK5
         3F/O432yzjAZPFGlDEU6e1ydlAjU9dWLMJbRxWzCb/6LZnl6aqD1OgUxIWfHPN3jxtsc
         qO7QLIXQ6Q5OwJanvHOn+t+N/UAoL4QN16cYMtl3xRpl5LQi4Qo0sTEez/MYbxfammV9
         Nbr22CmE3Gsge5J/na7gHhmyMCLO2mYyjz/rmTfj+WmzQTVWNxUo5duKFwekPhiUsVdu
         fXoQ==
X-Forwarded-Encrypted: i=1; AJvYcCUkINFSeEj3Mfh3eghVPPbE89xnvKY/Q100Akijf6U4meXLl3zyxl30LSpebS3xM41uD0jfehQZaQ==@kvack.org
X-Gm-Message-State: AOJu0Yz0K7rFtmNbRROwzU/jpjR2LSLVivtmejyc6xx1jTFRq+q1SnO1
	90aUtQsSPZuBK2Md/vxzcUqTNjAW3lkoKN2WG465OAgmzxxAv0f3SoNP
X-Gm-Gg: ASbGncuTnMKJIkCq1SepMZNsulOY3e/e1+M6/BEcKHgzm0WmD3k7oGwO9JTQDxvsklW
	vf47elIiRkuUOgBB/CkGu0XMQfzwT2lJl9olGtfcmPfi6S4pLw+08/JXwBhlWLKDBPi7HiqT+m4
	abHrvLAFkXZ/pYd4MrjDRq7GX1YIfNT6DDxKbJrpQNYvVI6XfEUzR4HU5Q8V8izqaiFThbkQ7lA
	dFPeGolBIZalYYbUlsEVJDAO0Ivl5RL4lsHLZqsGO/GbzXGJ5n/N543lYVEn8nGT/Kw7RjC8Lgj
	0bJ4UVMHuaqHK7cNzp5zvuyRCrnM/MlOqO+Sq2IUzhRf1WokXhIPyk6b/+rg+JeAp3VFq9uxUpT
	4X53e8+P4S8CPK5w2oTg4/rZ1CGySnLlweyB1wEXNVQiPs9TzgvayxXGyVnYO
X-Google-Smtp-Source: AGHT+IEQPKTDJOGVO2EbTeY/cLoR+hJ9sc+9WFZR9p9/1pqb0apVThZUN4kWnczmM0yNi/O2dtI1UA==
X-Received: by 2002:a05:6a20:748d:b0:243:b144:ad9d with SMTP id adf61e73a8af0-243b144b0b5mr1218934637.6.1756366477661;
        Thu, 28 Aug 2025 00:34:37 -0700 (PDT)
Received: from localhost.localdomain ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b49cb8afb7bsm13182613a12.16.2025.08.28.00.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 00:34:37 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH 08/17] mm/ksw: implement stack canary and local var resolution logic
Date: Thu, 28 Aug 2025 15:32:41 +0800
Message-ID: <20250828073311.1116593-9-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250828073311.1116593-1-wangjinchao600@gmail.com>
References: <20250828073311.1116593-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E766040011
X-Stat-Signature: tdxkmj11nugsg1nqwfsgqizd4qu7rnf1
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756366478-307746
X-HE-Meta: U2FsdGVkX18Y/KIx3SEF8nEr60HBQufRVgUdaVsOCxzyTxRuopOehTqG+P+hc93YZANpgAsqzT0StYs5DKtbtwAvJWCTMHg8cimbGRiDt+msB1IieaVmcoxGwUHi/TZX6v22AXBT2OzO9AoocINI972HVThfPI558rrUqWglK5/yAdT57fFBXdaWEisYdBRB4DnpenoTsvZ2MZ4gqA9dMjdfLjJSKOuHxRiYMyQ+jY+5iFv84YmSZjefbDdQApwhCLJDprU+tN/6dYguIQ2rik4AAeu3DDoos0eB1DVUAy/5nSlDbX8cp/B1lJpaT3A5Op4Wh2fywK0agGHECT70opEaBamVD/ywJHVsIkPwlBmqfEMJq51TsAjMEDw2BTB8ThtXnyc+DFi7lbjeG1/QEpa1vzN4N1ZFEwjsTRRyAzB9+PRTL6zx14T8tmjgrNybx5RvTM4uOpJsrRrsQSxnvg2kgbn5HUprNUhhfa6grCl3y88mbMIyvD4PSu30h+C5qPFGH+lBUXRTULK7sTVpdpsDFSl+202OFA57CMecNU+VRx3ZYV6NxYGUMZpOoCjGNv0IkdfU5RPISfkNVqCwI2JWUq8CRizh2YkYlculu0DljkqzcR43SsUfzDjPCWRvhPa8lvsQkuxsfUdryKTwLXk9/GIkeLGp5IUH+z7BgsldQEFWFk2+kl6afV3qdU2WY6BKkSK15jYKWvagT32s789aDbNZ0cdqJt5/XMzG0Z4oLcy6R9GjoCjIys7Zdz5dNk8x7qbdoV1PRhUrJi/n0FX6FhYmofWzMTq7DJfXoJYMLFKUMdRyUXyLzYPklKdBeXHtvu9BMfFPA7YK2cbIekhUYSvCZsv6c1auj73mqEzJ9MbG+vNHahdPidXM+CYG6rYPYOETiJ6FWRBwmmXHqa2/+q3iLDpSxRf9knIyZBHguWne7tYjryQTlgZPFXf7ULqIYKqwq6lU0/UPmXE
 Fx6g5lvR
 uk6xET1cfcEgyOad5VabOEQAuxcWRW/995XTnEmNC7MWG6b8Z/Pnh6is2xBMHJ9oTr4xPh9iXAViVgP5L44nxKQMrp36v1zZDp0Ylv8/aYV6UEAQrgPDiy8N+d4ia4IMjrLPEIUAZhrHf1dLPeKwn8Url+O8Jy4cQm27Rgb9SNpbtQqkZkY7bJhBMaNYikDsM+h/XnylQ369gbZAAz7q4JiHFJPQ+QI9Z8Iw1gOY0bGk7i8P3VFOzCMNPAsA2mssd9zpTF9YBktCuNUfAnXOqefsxjJF3Vy/tAVxIdm+faN97f+wnRBN3quHY3J09Q4DSNeRSVjs/6fHRYVGrAQTF11gvBu5HjYmJP2sDzOAmX/j8qlchWBHyzA3Vy69VcjwRujTAFxbv8z6WAFNBXsILUyDUjgjjaYfXJ9+gadtpwxmMQyA3rnN37T3EjmpXaz3pTad6YeUkKOKhVl/2229nYBJb9w==
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
 mm/kstackwatch/stack.c | 102 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 99 insertions(+), 3 deletions(-)

diff --git a/mm/kstackwatch/stack.c b/mm/kstackwatch/stack.c
index 3b72177315cc..1d9814a58fde 100644
--- a/mm/kstackwatch/stack.c
+++ b/mm/kstackwatch/stack.c
@@ -1,22 +1,118 @@
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
+	if (!regs || !regs->sp)
+		return 0;
+
+	stack_ptr = (unsigned long *)regs->sp;
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
+	stack_base = regs->sp;
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


