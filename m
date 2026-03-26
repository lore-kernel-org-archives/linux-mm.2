Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9281F10A3D9A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 15:10:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBE5E6B0005; Thu, 26 Mar 2026 11:10:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C75456B0089; Thu, 26 Mar 2026 11:10:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5EA56B008C; Thu, 26 Mar 2026 11:10:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A1E976B0089
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 11:10:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 416758C84E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:10:23 +0000 (UTC)
X-FDA: 84588550326.03.9D4D57A
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf17.hostedemail.com (Postfix) with ESMTP id A818F40006
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:10:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=Etd0ooBN;
	spf=pass (imf17.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774537821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q0ftc4L2bIqiqI9mtmvfrlvg+trY+mrARU5jBWKEO6Y=;
	b=x1Z7+GG8aZlrWLsSaagaGXXHmCIds8mUr6UcPQOLRgESPABdDbYaYnneKE5iPgVH29ZhX8
	9nFw6An0ujHilcWFPHKpxIVR5s7+ZhbA8lWHyAobbZodlQ1JrqnOnI9f7FB2lxBumnGGqK
	RkdsQ7Jt20I5wZvjjRtPBjJu1ugY4Po=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=Etd0ooBN;
	spf=pass (imf17.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774537821; a=rsa-sha256;
	cv=none;
	b=D8pm/hVMXQoUBTXC+ZxCf7QpncsgEcT3VdcLAX4d+NSe1AvHeYja4PcAHhuSIPScGVpMcr
	jiBz/ESPMfgQQt7Op97JWO0IAt9DGYsZAlrr+ymh45y68NPDkSaqNLOPph+Xtg9xnuTvI0
	htmESI8Bqt7e1aKVKBCKMLqicLv8g4w=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id B0B6CBDE0D;
	Thu, 26 Mar 2026 15:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1774537820;
	bh=q0ftc4L2bIqiqI9mtmvfrlvg+trY+mrARU5jBWKEO6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Etd0ooBNxrOQ9j6oatEyOQw9iAoxoBmvkch5uKfyPqxvX3YYTaZNkAFsROVhyc/03
	 jFcXdR/SkhGHEUFvlFswFCSGvMtct1jFANVvaZs4X+LmWrwLOXx8fb4Rt3aj4qA5FI
	 d0900XPBOCjqfPxEXvlFZQnhEtQLvwXi0da4U4kc=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Juergen Gross <jgross@suse.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org,
	linux-mips@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v4 1/5] tracing/lock: Remove unnecessary linux/sched.h include
Date: Thu, 26 Mar 2026 15:10:00 +0000
Message-ID: <5593ed9718b1a6e4ec51d99772c485734029d4d4.1774536681.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774536681.git.d@ilvokhin.com>
References: <cover.1774536681.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: xewgzbixqkwnqjxj5h3qq8dugrnz8ryc
X-Rspamd-Queue-Id: A818F40006
X-Rspamd-Server: rspam09
X-HE-Tag: 1774537821-450389
X-HE-Meta: U2FsdGVkX1/amfbfJO1q/iSb6NKvZunfbwPXrykzz0zn7oNUjaip98B9kZ16DEF0n6T6CzP14WU/GDRRD+6Inxt8OVraJTw8/blj9I9Cwakt/W5X2DVc0A8u9C07Wl1joQjZS5t+qYD8TzcpcT/OHXsm9tPNt9iXodTbCNBYnb2Y+uLXeV9FhcQh9HRXdOUDoF01lz1J2sne2gczgAVsHgEjRrDyCBx03gnUM3XSXK/3zTRX0deA/WmUtJ7BiVP5E2pljH4P+8F1HJ4BKXbMwFcrxS2fNb977v+8mBcCErXkpMyBQ3P6eU02dthZZceqGSeH8/NwfB9r2bqEBS4H0yYQ5CPvsTULpSTTY7t+GZFdSW9CjEWkSE+iYh5UIsvE+Gf5XIQ3nk4fuJDBeYJ6KGD1ysTLtpHboerXT8GJCBOkCGUmaPiSMcp21SPRJlt9Co3IlVS3giSkM5ENdsQZh9QrWCIhlh8HAwJnBNSa07hCbiQO6OEBPzhawtE+0N9sEYsMdTe5XbpFgOefbfcpnsJ5VAqO7a1J7IbCm80BZM/UriZPaqB7iXAz41mDybh9DeIPk4Ye9pUR0AoGF+JcVqpMHWjuhkohlnSmhEonEp9v8WkUlx1hbJBqpf4dY92qTESk9KADeZsBW+mVErdeJuqO0mLT26WNUQYnkrcLNnKISxPLKNcecmnUITeNR+zAviDfcw6pInBJ7b8Y3pgduXdwtQRHJ2XU0P86IAPaCPSvKz0GTiLuRrgNyvexpAvmpztv3Kct+sV0L41G6NRIB54P2Jwd39JUdHIZGh8ebrGqncVC230szg5s8HYD0mJYr1b2XKNn41Zlr7I0DxDU56ihDqa7Xmb86PMx3ihhv/0yfTHmVWjAeNcNjEmJsHWwzWbM4R7A4heD8UzKu2Sk2VxkyMrAAQaxX0wMN/5m9U5zn2xfnxbKEpD8kewCFZoI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

None of the trace events in lock.h reference anything from
linux/sched.h. Remove the unnecessary include.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 include/trace/events/lock.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
index 8e89baa3775f..da978f2afb45 100644
--- a/include/trace/events/lock.h
+++ b/include/trace/events/lock.h
@@ -5,7 +5,6 @@
 #if !defined(_TRACE_LOCK_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_LOCK_H
 
-#include <linux/sched.h>
 #include <linux/tracepoint.h>
 
 /* flags for lock:contention_begin */
-- 
2.52.0


