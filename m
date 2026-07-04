Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1BF4C43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:47:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6ED56B00E9; Mon,  6 Jul 2026 02:47:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F7F36B00F1; Mon,  6 Jul 2026 02:47:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90E016B00F2; Mon,  6 Jul 2026 02:47:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A71C6B00E9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:47:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F387416854C
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:47:29 +0000 (UTC)
X-FDA: 84957420618.01.271E9DB
Received: from mout-y-111.mailbox.org (mout-y-111.mailbox.org [91.198.250.236])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5955580003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:47:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of m@mavick.dev designates 91.198.250.236 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783320448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/6om7EqV95b4wafnxbHbtKHtT0Uog57+s8mcXQojkik=;
	b=3x8LkKt3YyhEJ5iQ5wlmua7V+MKvmOsijUflMH//a04n/DQ6WWVIfpTbIK4jXNSKYLzE8C
	W1nWcMsSTvZRvnuYJA77XqzLHwlwDVTf+xl9NZaSuMz26S3+dnXGKDr4gE5yyKwcDwQWML
	aTI7ErzIC+yOGx5R60saWXD7BL3+EwQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of m@mavick.dev designates 91.198.250.236 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783320448;
	b=FoOiJHLngiuB/N3v0s4Wtw2N7x82M5EddMEr/cKAzIMudcDuzwqKus89tpGH2m1lqq6R8F
	laBcYQaq9GkqW6a8CDjGQPuuHhrxXb6pW9sLC0LbVFCtd+HHnRhD+1kbfMs6/3l72Ers7Q
	ufl/FpXbvVlQEm2SuAUcTGRyEYaUPgk=
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-y-111.mailbox.org (Postfix) with ESMTPS id 4gspTr2cybzMldH;
	Sat, 04 Jul 2026 13:36:00 +0200 (CEST)
From: Eugene Mavick <m@mavick.dev>
Date: Sat, 04 Jul 2026 19:34:46 +0800
Subject: [PATCH 3/4] percpu-refcount: add ref_trace_final_put trace
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260704-refcount-final-put-trace-v1-3-b48746da1f27@mavick.dev>
References: <20260704-refcount-final-put-trace-v1-0-b48746da1f27@mavick.dev>
In-Reply-To: <20260704-refcount-final-put-trace-v1-0-b48746da1f27@mavick.dev>
To: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Boqun Feng <boqun@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Gary Guo <gary@garyguo.net>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Eugene Mavick <m@mavick.dev>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1195; i=m@mavick.dev;
 h=from:subject:message-id; bh=/PtvR2dnazpQOJk7UFgwLIewlTHNG+dDvVdArf0En58=;
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFke759u3DTLoJNjhZ1qs6qnb/ur9Vdyg9u09i3ZXX0u6
 UKsscOKjlIWBjEuBlkxRZaarAT3jJWzEo2PTuqBmcPKBDKEgYtTACYitY2RYYVU/EPXZjbNnXfM
 X/W9eRQimHObqZnTk/1zxUZnxpRLqgz/0z6EdFW0F02TerHhhsM1sbl/7h0MU5/iYM/QZ/2K6UE
 +DwA=
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5955580003
X-Stat-Signature: hyfhz4e18g6kmejmmxcz4dybzb8b5cek
X-HE-Tag: 1783320448-122269
X-HE-Meta: U2FsdGVkX1++JysRYwL7QxXhoYt5ezorhmry1brwgnT2YcuoJ0ZqKfm8vXkXzmZpqQVmEy8/krh28FWHQN6G7nvQK8HsSixK8aK+bRtPsRsPGDEW8jdiRgqcJaKeH2JrX4Ry/PNCmmigkuCiSy1nVHxuzGzMhHduiocKd9Ore4XTEudejFxxUwK4Qjus+Zv7Pa/sGnUVtsGuHHpJ6WYINm0GnPsUHS3nSpKQMJNF9151B5YoVvRNEKRbc5qga9zym9Dfn6omH8SDzRjO/PxzQbwLdiENfk0T+eos7MR2zudhvqQsFC2RvWjyGbLCmQeIU65+Cnp/D8/P0adsPvnLlM3gqViJ+EyKGGrkasR/A836BX6UvG6HddsXYJJAb/8wV+fEWaGh6Ze2iKOsyuG2hSTamxdTfEOTFw+bRTpHldz1g5ojyvwFsueM6HARRp8cwNu7i05IAoGJ1A98pvWhWGbIl/RYLfySK1YS1QT6llJZ7dQ8d2oCelPTjXS/Ff67a1vjTB0YZO5OX2hIXnugzZhLtgSNJvPyMYYGJPHmMxpMyD10oSWAVgPBbN44xVysq4nR7ONVxP+X7G45azptZZ38TtBUYgQOS0TJ9R7YY/Dl4TPDPSN3rnKFZXo1qSTMOdq9JEo0EpVsLHUAmKJcRpiue39/LsWsJmTy86DiEYybddvPTkxLpBlf6/N6VcL+fdtn1INiiEfRSGb7QwYH65LCMx5bGA31rQ1qTujT8Al0PzCn+OvFTa6OaqnLkC0GYnQSK4Lqp6+xRgRo5BlocZdLD2CQiw9qIr6v2er82hXhaBXadaUDSyoLHAvkK/gKSAbWc2CiOY5hsvmHk4kalYucllVrOLNeBHD37MoTPvvw4QZLTTfPfWWS4oZG6W0HaoXD6hlTShNcGGdPZc8D/PNS0MZ25OXTJs/a67UYzllSZI6ZLTMMU9LyBgAFm4PFpur29HNenjv17cF54u4
 XnQnaU2x
 eE4h0HiqC5j2+bMblN2qoF6Z+TW++P2JvCLglcvLP08G00M2d7ZahNDYIDeAz3BQOTz/0M1JG5COh45SmdaomiMiME99tPZ2F/DsfTYdoeoZTHnecuWBjpl6wkMhYP4vUdA+GfiRRpwGqIIv3PozdMfP8742zJTxA5DB8tBcalRBu1AnDRVcDb4RSNjtCgCBN55Y7fkpBtyDJD8rrvY49RIGCjnKqguZeqQIIxdESQ8Axd8I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the ref_trace_final_put tracepoint to percpu_ref_put_many().
The tracepoint fires when the atomic counter reaches zero in the
atomic fallback path (after percpu_ref_kill() has been called).

Signed-off-by: Eugene Mavick <m@mavick.dev>
---
 include/linux/percpu-refcount.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index d73a1c08c3e3..55543ecdf60c 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -55,6 +55,7 @@
 #include <linux/rcupdate.h>
 #include <linux/types.h>
 #include <linux/gfp.h>
+#include <linux/ref_trace.h>
 
 struct percpu_ref;
 typedef void (percpu_ref_func_t)(struct percpu_ref *);
@@ -331,8 +332,10 @@ static inline void percpu_ref_put_many(struct percpu_ref *ref, unsigned long nr)
 
 	if (__ref_is_percpu(ref, &percpu_count))
 		this_cpu_sub(*percpu_count, nr);
-	else if (unlikely(atomic_long_sub_and_test(nr, &ref->data->count)))
+	else if (unlikely(atomic_long_sub_and_test(nr, &ref->data->count))) {
+		trace_ref_final_put(ref);
 		ref->data->release(ref);
+	}
 
 	rcu_read_unlock();
 }

-- 
2.51.2


