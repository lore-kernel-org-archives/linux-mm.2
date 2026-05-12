Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67B01CD4F25
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:38:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75BCD6B00B6; Tue, 12 May 2026 10:37:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70DA06B00B7; Tue, 12 May 2026 10:37:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 621C26B00B8; Tue, 12 May 2026 10:37:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 467B26B00B6
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:37:32 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 15479120519
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:32 +0000 (UTC)
X-FDA: 84759021144.19.135D3AC
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf11.hostedemail.com (Postfix) with ESMTP id 345B640005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=oxzVwwmU;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf11.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MW3E0b/P8o/cx8sVzzjLUdmNXwzTnFCf0K7UbXufGbc=;
	b=lT3W319yB5tOEagbFUQH/kR+i885IzvPrjjbarPDWpbVeXXLdM6BE2eNGPA2eCnE8NQiAm
	s31nAlFuGG13SJFLI1048fahh5JcuFH9RuvbVeBBMIznKnrhGh+6pEGDnWYghDaLrJ6h0w
	jo9qMQcE6C45MUNZhtwJXYqXyzauL00=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596650; a=rsa-sha256;
	cv=none;
	b=gKmRnk7Ppg7DRvMOaUIkoV7AUe8oY3Etc5FsHzgiaQ97CTpv2NZVLofwHHLMGyplaUTJb4
	fPZtQ7yTfg60NX8N0M55lc8qQMiuAENhJGl1daLrueLh2qwwAWtVg/p7JApkO5obTFFhse
	xBIZlVBeeHrnd5+9jQZqFTw6QaiZrJc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=oxzVwwmU;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf11.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 8429AD041B;
	Tue, 12 May 2026 14:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1778596648;
	bh=MW3E0b/P8o/cx8sVzzjLUdmNXwzTnFCf0K7UbXufGbc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oxzVwwmULOSd0cxBnZNVR3SvxbVbPIUBUE9BWe9ujkDkT/QBd/YkYGERr6HDDSlvs
	 PPiKnNvb82q/+tz7/y1EXV0IDluzQ1vGQzzk9pnLdBrdp2P9bJ85a5u+IJEJ95XzjN
	 XwkuqMz4pYAtUB7Fqiuf0nJUdLtz9tY5AQLh2wFA=
Date: Tue, 12 May 2026 14:37:25 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>, Dan Williams <djbw@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>, Marco Elver <elver@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2] cleanup: Remove NULL check from unconditional guards
Message-ID: <agM7Jekhn3py3sIg@shell.ilvokhin.com>
References: <20260512071510.92451-1-d@ilvokhin.com>
 <20260512124557.GD1889694@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512124557.GD1889694@noisy.programming.kicks-ass.net>
X-Rspam-User: 
X-Rspamd-Queue-Id: 345B640005
X-Rspamd-Server: rspam04
X-Stat-Signature: 1arrfr7ke9g8in38d9sa6nyod8xyskor
X-HE-Tag: 1778596649-495658
X-HE-Meta: U2FsdGVkX1/hK7dgPO8+/QPQkXb/Wxhlh79Iq+Q0eX7WRC2lATNRD7OycX26ef8zwtHueu6w8U/Ix+m061fHUJXZDdBxPzHHk6BSmz/O9LC7jVZUovflKFWRgqgjTWGrV/CMysozNOEoyzn2pejwd6UPuaOrV1Cle+A+uQ3TyeVIxl2Em71NE/i5kuCZbkeMjB6EKLMxVK2QkKpKFqyOXUSBc2aylahR5sPHdfHV0WjQpq2tai4wM5XFezIY0JDnYnP0ObxILRo+7KK8TUJJjdiAFK/Hr/03vrX1JFqLS97OkGS8orNL4nQRwP6TBbiK/PGXANBU1D8kFY4vMdu/+JrtUXTV73W+nPgNrb6WlEO98c2N50d0EV4X6X59CRYEroNWe3G2ZJlNTYlZ5SINSuwzq9hEBrOia1bxizON2Rxu5yYEutuSz6qDQekbr0TKRdby31lqNxrYGwavfNZTdNdPfnJDFeQmPIabaXhdYoy7+aGe8BcjyMxuszzgsj9bNZwyXXTrlRv7Eczq2ODg5qB405yavX5oYfzScoYhqaXWbFGNtDD8JdgIr+PE68urtVNRorg1UpISOSuJfTckWa9/+OKFL0IXECZRg4xOJUYoGwXZmsbMY6M/ecaC6cabOInTHSSlTBd3ZwSvEsd4zzuDtNhB1L5PgSfY45NlqIDHCL+7AaQOSGgJ8QU3t5TZT9gEXBUmjQba9kAINW/NtO0o2ibQFQaHjx8zlJFi6hZr+e5UgbH/rlgh7D8Go+/nBBcQISx507WfphpuNkDkkdQJg/OTgBvN4f6+eUxyFpgLmXBeWYHocRRsMSiKcWmsoMM18jUMXnOyUdR/HmxDr6Ln49U6+oHIAncRVTcEQ2VEYdDBoE3cJAqw9LhZgQK63bT8hv1kHuM72HOacrz/eUWU8rPvgeAT8jwjVIjkAF4MJb7hCLWLOfnw6l7Ba/BSx4S47FLAZ7pOPNVNte8
 BLUEJWrm
 6pfEdX1Oio3LMsjGzjuz2xIDqGWB2KtaNHOBKeuRgSAxNibfPHQ6s7N+9qwBtOvrRPY44FPZRHD4bc6gcFnglJk9qoA9Cr5XlDOYiLVVi5zc9ZM5epXl62a0g6L5kc4H+UeZfr+9EaqvGMLVzHIZ3dSMRGlfj3ERPlJBEhoNo/MYi5wJMR07C/rrstRPLHcs4k1LzDRU1b3EgN3pn4y3plPfBFoDokJna7Amd8bed2cCs6jhm294ZvkJ7Mc2kgtWXMp+RZFZIiOm2tkI9QQNaeXAQsQsTe6B25n29dPjUJHT7T4LLsEJS+5PwovKrv19FeGUo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 02:45:57PM +0200, Peter Zijlstra wrote:
> 
> What about class_irqdesc_lock_constructor() ? AFAICT
> __irq_get_desc_lock() can return NULL.

Thanks for taking a look, Peter. Yes, that is actually a very good
catch.

For some reason I naively thought __DEFINE_UNLOCK_GUARD() wouldn't be
used outside of include/linux/cleanup.h, but this is obviously wrong
assumption. There are cases, where DEFINE_LOCK_GUARD_1() doesn't fit
callers needs, so __DEFINE_UNLOCK_GUARD() is used directly.

- kernel/irq/internals.h: the case you pointed out. Can be fixed by
  moving the NULL check into the irqdesc_lock unlock expression
  directly.

- include/linux/tty_port.h: similar use case. NULL check can be moved
  into tty_port_tty as well, similar to previous case.

- kernel/sched/sched.h: lock and lock2 shouldn't be NULL at destructor
  time, since they are dereferenced unconditionally at constructor.

Below is example how this will look like. Does this look reasonable to
you, or would you prefer a different approach?

From 835d6c13caf8169db7bd049c9c549d5988fd0a82 Mon Sep 17 00:00:00 2001
From: Dmitry Ilvokhin <d@ilvokhin.com>
Date: Tue, 12 May 2026 06:59:04 -0700
Subject: [PATCH] cleanup: Move NULL check into conditional guard unlock
 expressions

irqdesc_lock and tty_port_tty use __DEFINE_UNLOCK_GUARD() directly
with custom constructors that can set .lock to NULL. Move the NULL
check from the generic __DEFINE_UNLOCK_GUARD() destructor into their
_unlock expressions, making the NULL handling explicit at the call
site.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 include/linux/tty_port.h | 2 +-
 kernel/irq/internals.h   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/tty_port.h b/include/linux/tty_port.h
index d2a7882c0b58..cbbff6aabdad 100644
--- a/include/linux/tty_port.h
+++ b/include/linux/tty_port.h
@@ -286,7 +286,7 @@ static inline void tty_port_tty_vhangup(struct tty_port *port)
 #ifdef CONFIG_TTY
 void tty_kref_put(struct tty_struct *tty);
 __DEFINE_CLASS_IS_CONDITIONAL(tty_port_tty, true);
-__DEFINE_UNLOCK_GUARD(tty_port_tty, struct tty_struct, tty_kref_put(_T->lock));
+__DEFINE_UNLOCK_GUARD(tty_port_tty, struct tty_struct, if (_T->lock) tty_kref_put(_T->lock));
 static inline class_tty_port_tty_t class_tty_port_tty_constructor(struct tty_port *tport)
 {
 	class_tty_port_tty_t _t = {
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 9412e57056f5..347cb333b9fe 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -171,7 +171,7 @@ void __irq_put_desc_unlock(struct irq_desc *desc, unsigned long flags, bool bus)
 
 __DEFINE_CLASS_IS_CONDITIONAL(irqdesc_lock, true);
 __DEFINE_UNLOCK_GUARD(irqdesc_lock, struct irq_desc,
-		      __irq_put_desc_unlock(_T->lock, _T->flags, _T->bus),
+		      if (_T->lock) __irq_put_desc_unlock(_T->lock, _T->flags, _T->bus),
 		      unsigned long flags; bool bus);
 
 static inline class_irqdesc_lock_t class_irqdesc_lock_constructor(unsigned int irq, bool bus,
-- 
2.53.0-Meta


