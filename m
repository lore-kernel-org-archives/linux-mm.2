Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F5E1C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69E9C6B00F6; Mon,  6 Jul 2026 02:47:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 600886B00F9; Mon,  6 Jul 2026 02:47:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42DD96B00F6; Mon,  6 Jul 2026 02:47:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D9FFC6B00F2
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:47:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5F569168783
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:47:30 +0000 (UTC)
X-FDA: 84957420660.27.30CF4B8
Received: from mout-y-111.mailbox.org (mout-y-111.mailbox.org [91.198.250.236])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1DF4EA0003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:47:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of m@mavick.dev designates 91.198.250.236 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783320448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q10jfyhsC+ilV5voSAeXf96TIcBRjbPsbwt+QWdyz88=;
	b=2h4gQDrWKnW+HiOMTwDKlv2Xepy/m2Yv6MdO9wgBHwTd0jhWQGk6v8sxVggOdVYmWU9nkN
	xmHPGnbY987E/6hQNCH7XhmVt5/FRB4M36ybABnKyBG2iOx9MQBvjvG++YeirJlfoP0Scy
	grBity0OWlPdbhsOFqArmzlWo0aGNmU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783320448;
	b=oRtsry3VuYiO5WlnLKA0rJUCtIMXlCZiJjQMDVpYOV8TAsmIj+i2Jq0qLowz1qIAE01WRI
	NLyFVmZySrmkBcr/s89nwxOXzIBZfJHh+3XJPcz9TXBpk/9fo9LYNgDdoP9egnAkmQxf52
	LoIJ3arqBXK4/0b9tGcizXnA3pX1lxk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of m@mavick.dev designates 91.198.250.236 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-y-111.mailbox.org (Postfix) with ESMTPS id 4gspTg3nqMzMlcW;
	Sat, 04 Jul 2026 13:35:51 +0200 (CEST)
From: Eugene Mavick <m@mavick.dev>
Date: Sat, 04 Jul 2026 19:34:45 +0800
Subject: [PATCH 2/4] refcount: add ref_trace_final_put tracepoint
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260704-refcount-final-put-trace-v1-2-b48746da1f27@mavick.dev>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=878; i=m@mavick.dev;
 h=from:subject:message-id; bh=oxdQX1dkebrHkQOKFGbMe1L7jn1KmiWYDIa5MeosIJI=;
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFke758aL9lnslxV2P2gsFSl61zGxY2/PZN+vUh6V2Q3+
 2BpiINMRykLgxgXg6yYIktNVoJ7xspZicZHJ/XAzGFlAhnCwMUpABM5tIOR4WSPfLvtRMfYc3We
 evU750rlF0290+n5za7m8OKyY0vvFDH8FUzgWNJTG+rq8nHfg61NlzpzNv+RNAqaaLfY4V3M8a/
 /mQE=
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1DF4EA0003
X-Stat-Signature: ut87cakctxiph51qwhhgfsuzkhosi4s1
X-HE-Tag: 1783320447-977124
X-HE-Meta: U2FsdGVkX1+b5p9fRu37BoPQd6YWLt4ucIt9HMlTct/ZvmV2O9nQBJflFxke2vFTg+IZdarjpj1CvNwu/wbw/kM71n3BHmdMhJJEVYYBcskuhvaoLQyvg5TPaFmqIOzYuMr/IGKC6Ynb0JaW5WHMqEfPhBdDGUv+g6sGi51wIMlGZouuDFCMe7SRoNzIPWRwyq7A7qnGn087QxOVS809xGRPDDb1ROZZzYpC9YJbJvRXnl9AN6zZgV+MpOGAY1yt8LJa2HA9E3g/F+UUaQ/iWKKVteDOWtdigx+VXq6huZYtOodiDRcHJSJsT+v4HdnDZAcy+S/uav5h5ZG/GtKVeCu4sRLMxZYZho7dmDb8mzgddUiCuMM7zJxymiSkuFEGeHwx843ubDawh3Of9pYMPQZjTdt4TUAzV09pSYovCBQebwbdWWtfcrM6tA/fQLwg4Wkz9YVr4q01DzmQNynFQB0ZlelPh68pSK3yquYjEkHbOMRsm62jsEA5Myx/z73cbh8wN94F+xOcDKwYdja+z3y118WNj8k0QP5mp2YYSMZDQv3jhduOY8cM1Rdcw9GmaDYqMhzCB972H9N+lkmPzMaISm6AvC/98Tez54j2CsNgMkLcjIKK52IqwPQ9m4zjsK1AqP/3vK/YVIWVcm4MgEQz3dm+8asotG7aMvyJkHOsa6VLI8O+AI9s3OyRaWDEFgdFhBp+jNTCfKtLtInLWwiIe9cwLaX68SBHj0MZh5auO64Df2OBCqD6WFWPzNnr1cHOpfFehzP9XSzN/HG/mYgFZDbhcdGWP5rZo6wd7G7Nx3B/f+aIWgGW23Wqc8BD1O0fecaZIYeNYH5GqR4B+P4H36I9zunbgjHmE0e4+Uqlp+gUgFGzztEFyj6tJOuiHOjhC4YJebs8snisZtw4QLoIzMhQvNDfxvKUYlBscAyoXFAZFVJnfZ8AtOxTxJXNF2jJfDOGk3d10WUCQs5
 kGZ7X7ln
 0EsayJWU08XweEWoBuyzHiV3Vp99V32UpmPO5aNa9POkVOfQfZxpUk40oWd4Q1kQg0mpWXNp/KPYWDpEAP9/NQXiiL/zn7IfrwTXIDRU/O9jqI1YtXJarWl/2XOTQ7fkvw7Wjgo7g9dmBaYtwy4U3bh1WUDxlspE4fYvq3gzfQRHUkOJnak0fNT5eEdExrY/isbcRrCbiO+Q9qaL675BkGoSlc8AkSQiqMEaut8+UN1fUfOg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the ref_trace_final_put tracepoint to __refcount_sub_and_test().
This fires when a refcount_t reaches zero, capturing the caller
address, the function name, and the refcount_t address.

Signed-off-by: Eugene Mavick <m@mavick.dev>
---
 include/linux/refcount.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/refcount.h b/include/linux/refcount.h
index ba7657ced281..7b1fbf326a21 100644
--- a/include/linux/refcount.h
+++ b/include/linux/refcount.h
@@ -107,6 +107,7 @@
 #include <linux/limits.h>
 #include <linux/refcount_types.h>
 #include <linux/spinlock_types.h>
+#include <linux/ref_trace.h>
 
 struct mutex;
 
@@ -393,6 +394,7 @@ bool __refcount_sub_and_test(int i, refcount_t *r, int *oldp)
 
 	if (old > 0 && old == i) {
 		smp_acquire__after_ctrl_dep();
+		trace_ref_final_put(r);
 		return true;
 	}
 

-- 
2.51.2


