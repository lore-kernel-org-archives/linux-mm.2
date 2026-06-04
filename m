Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A742CD6E6B
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 07:15:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6683D6B0096; Thu,  4 Jun 2026 03:15:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F2206B0098; Thu,  4 Jun 2026 03:15:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 445386B009B; Thu,  4 Jun 2026 03:15:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1F24C6B0096
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 03:15:34 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B7141120611
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:15:33 +0000 (UTC)
X-FDA: 84841369746.04.1E034C6
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf23.hostedemail.com (Postfix) with ESMTP id D253514000A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:15:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=LQAD3bDw;
	spf=pass (imf23.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780557332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TG6KIx+oIC2b0cGiCH0bSSlQMFTnLC97rQasKVI++8k=;
	b=1GktrZDHOnqciPqhu1JH75AOXSZd5Mv4E3zbbzA2FtPTRVoj2hwAufO6TYx9XZXaHwtQZX
	a9dx07+rnQQBjqKCdd9zLKND7hobp34QRPrqxJM1Gg8LdSBGppjihXgWKcWFkn71xaU6q1
	5HCBuavYa8yoxDAqUv0aeM1YjWlJSdA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=LQAD3bDw;
	spf=pass (imf23.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780557332;
	b=xjge8ot3b03eQCLz/fZL5VngrVGfjP6z5SC2mdALBD4xx3cVK1q5qR5Ot3WXW46pWTu3Qs
	WSmsYoxt7frid3uHZeYM6k1BMUn4WLB2XKmJHtu5tRmZMOEWU6LwoVyXCrg+2PLOiJ1ndK
	BD7G4KmV39JAe69n1ue3nGN96COUPZY=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id B36E6D1155;
	Thu, 04 Jun 2026 07:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1780557330;
	bh=TG6KIx+oIC2b0cGiCH0bSSlQMFTnLC97rQasKVI++8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LQAD3bDwyvsD6e6zgIbTkydrhSi2OY3DrxUPAIxUtBHYRxeboFoyaUhHD3IO7DaQq
	 ltIkn2U67MYXRL0AxGkKCp7OTOw5687ogyaat7n3mlWs9JrYmao80P1bhcDOUUzUke
	 XKqfW8bnYhrMcEGHq8h+JLSI7dBYHmwZ6RQcVGw0=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v7 1/3] tracing/lock: Remove unnecessary linux/sched.h include
Date: Thu,  4 Jun 2026 07:15:05 +0000
Message-ID: <85e14a0685c1d46c3e80de2dc01358a48169b263.1780506267.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1780506267.git.d@ilvokhin.com>
References: <cover.1780506267.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D253514000A
X-Stat-Signature: udgin8t1nty8n7gm1cg3nou1wgn8meaz
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780557331-515678
X-HE-Meta: U2FsdGVkX1/IYmJ5OyreFj7kvyN7sUH8C+LqNpThGGBj+UIXPT74SWzRscANDPOwLeicWkKzUaf9xX2uJUbAtYdkKdIlAsMVdFtQpgekhUrxtLzCW4UXDjQBu1cLfTr6y49DoVK9iU1TcX9MI5FBld1Bc6MZa3KEbHtPXzl06TJ2wjmSk/IQUvEJAFTcLxGmm+Z7oHcgxUue1JkC3coo4xdXRKtQyPjy4I6G1HIUSKyS7B7DNAc1n/KzGZhB2GB0PNbEbhua9UMcuqcI1QIJ4d2KIF3msMqDMlUIXeZ6fDuElQie7BLSVqEgZk+DqJu43cMMS2J6Y8TbTywDNDZh0WucQEEtuH/A7mvEQ9gjsVStca+dJTFXAlkSPwyiKy4DPS8sO08/IfX86hx5+xaavU1wmfxHUe5G2qiQzb72jwhzm8VdB/4R7QdUAtBr6dW6kRihhrVMVcF0tTWayKAA7LzJU1nt48YnNqyCMPMDAqP/soGqdGj5KRfvgCs2oZWkwK5n+HLNK8KsiUgwYTL7TLf6TZBDVpjfLSM8fifHJF5/prYhwYr8QHNSrFokBY17bNf2EDu71RBPxe6CK8zoMTvYMcV5tdXueksBcUDHJiyDijt4O1Alc0o6ZF9hEn5KDt/8/rNS0E3j34YIGiq+NiORD8ELtY5K4Cn2H8+j3b0ksIHgNwdcsgHqzRXRpVjv619p5ADnv/OetSmdZt3nJwk6S2X/wJsbKpSsRBAUJUAJLyAEgafnTJZwVL9fQ1PCsKBzS2a2cw2awzyyYdXCSJytyO5RsJBgX/u07Ok9ZU8KBwMj3KCLInj3dI6KXSjpBwzJfGJRfXiiLwYio9RWWrxq6IxUkG3MfYC8qnmEok9k6us2QCsbH+gWkozDPfLRA9tRFHC6ifSmH/VygNoXmZzcElNoqE17lHPWRTggBFCbC8nwLTJuZSaZqzPL+RA5W+vai+MXDECdpzJUqoA
 IvMwXtyi
 kebJc1i/q/ja1rmi3lQjaSGU31Jc3bUBF6WqzFhzHSzC925r+3tXQv5YnV6sFOm5kFAd23quHFD5YYkFV8DJnoOvAfJtDp1okR3Cu6mytesnp3FaoCgQELuV3ICUnZuPthNQmqb0Txap7OCpP4augtLAXmf7FVAxf27IZuL2FC6Gqh3K0516kKlKW4zUlvHm6nUmHC/bM/sQZ9ktaooiwr38PtTEuy1umiemjznAdugRJI4KLOW2YZlyK4qWpFfNU6ibaZkuheigP6UVqGOucw0kIlcmcxY7HWUOgNmrJOZ6oCqf8FnJOGTnuvs/urXbxbu3U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

None of the trace events in lock.h reference anything from
linux/sched.h. Remove the unnecessary include.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
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
2.53.0-Meta


