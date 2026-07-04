Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4442AC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:47:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FCAE6B0102; Mon,  6 Jul 2026 02:47:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00E7B6B00FF; Mon,  6 Jul 2026 02:47:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF0B66B0101; Mon,  6 Jul 2026 02:47:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ADCE76B00F9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:47:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3F9BA1A02CC
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:47:32 +0000 (UTC)
X-FDA: 84957420744.07.73352E0
Received: from mout-y-111.mailbox.org (mout-y-111.mailbox.org [91.198.250.236])
	by imf08.hostedemail.com (Postfix) with ESMTP id A3743160005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:47:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of m@mavick.dev designates 91.198.250.236 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783320450;
	b=WoZMp1/0Ek2eRPsylZPUEgUpN5UmBL++MZuTIX6Uxp4lLXBr7UuG7QU3usqwVboMAl1mPO
	wPe+Eleg+jXkSybiHcndhVmrb9vD6F2rK2CabbPGdyfTsb9IId4dgmH8DiTob8iXHW4Njk
	zKGJo3XyusMqrPY53C6z69/KJfLqg5k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of m@mavick.dev designates 91.198.250.236 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783320450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/6om7EqV95b4wafnxbHbtKHtT0Uog57+s8mcXQojkik=;
	b=yACYbL5nrHqATMuzEI2TDkCcAOlbGzUwv7j6X4ma1+K0IsPrGsyKLnXTqJdjLzEM/ukwRm
	vjlOiAiA7SfK13xxFMDisru7fUYXsyaiy6I1M4FlJFvaXAONnTffpmvR0EEX6yhYAe9dh8
	4tALDY3eyeHhFtVplxjGiY+nccoSHFk=
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-y-111.mailbox.org (Postfix) with ESMTPS id 4gt66h15Y2zMlf2;
	Sun, 05 Jul 2026 01:20:28 +0200 (CEST)
From: Eugene Mavick <m@mavick.dev>
Date: Sun, 05 Jul 2026 07:19:22 +0800
Subject: [PATCH 3/4] percpu-refcount: add ref_trace_final_put trace
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260705-refcount-final-put-trace-v1-3-cdd0014626a9@mavick.dev>
References: <20260705-refcount-final-put-trace-v1-0-cdd0014626a9@mavick.dev>
In-Reply-To: <20260705-refcount-final-put-trace-v1-0-cdd0014626a9@mavick.dev>
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
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFmeU5lWFh5nbLEtyaku9NspuYY/XsDL2NNow+y1V7ec9
 DrzwjOro5SFQYyLQVZMkaUmK8E9Y+WsROOjk3pg5rAygQxh4OIUgIn0L2H477xezNv04g6u40f2
 lCbH/+CcH5MerNTyTCQ1O351Krv0VoZ/2kLZM/VNEoJ/LDFl4Ig4cjLFZBrDE7H5t23u+r2yn87
 FDAA=
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A3743160005
X-Stat-Signature: wmnt3dnazpcop53zz39bdjmmw4x8j9m3
X-HE-Tag: 1783320450-285509
X-HE-Meta: U2FsdGVkX18AeXHrYd8AXiP4AmQ5KhS2Yptm6vqGrCtWpI8Ggk9hJKn0RSaMZn5nqay/t5FnUgKvjRgA+F8+aTo5BPrdWHwBsMgaA74LYLvbdqawlejfLgq5F9x7V57r4z7eTLWwVv1BDPzyR9TNk5y3i43WUx5yxu28JVKi4ildxnVQ7kUY+yuNKMVFKny8ctR+oyjFv4g9/83JiC0WNFdWHO3Np/9+H3r3ZmCETlglJPRLSUmGxaC1jf3yCovi/box9SWIW5lV2NJWs2wLkWaCYrpGJYiW3cOMwA1Sxc7z8IhbNqvtC/PHR8WqCeujIHTlBdJ+fREoMxbqWJMA7scvqhHI2F3g1i6wO+ZH2V2qAqpbOs/9xI3tHux0ylnBxZ/fa/5Qq44/g4DS/s9l/iGpN/WVtkgJCohaC4BLikvZNDGsyX60LP9mFejNm1VKd/skMiVpBMXjr5PHJCTZY+/5ROfDXy/lGFuo/rHc1aSMJ90lOgPaIJzNPHJ3bIWwwLwjNKyMa1Mmc9ESSZQjzfzMVnR1Nw53nnKVIgBZ6UZfjunzBJpzsdNxnQDGYgpJHgApr+IiBdI2qmTpAuJ5EulSLzcYeSjGaWnOk7HKCVo5DjoE8ZR46y3j57HWjXxEC93TWutuIWAgYJq7KKdm8iXOFBhdaLsMalpg3TnQxTYIztCn+8eCOIILPPjrm2nfPrl2EWa8YXNzG+Fn0I7dxAh3a6nf8pb2LABjSFpJ0rK5ZFhpWFS9bFmi68q85kNVWDV5h4PbuSdqF5PHsarUXW04hc56k9X9Cp70Sl/w/6BEHw3LlaQ9klJkZBJsMDq0JtO+4r2k90NUnY22PlMhWNFfmj0HwTJRtN+uxcGCRB8p8EdwWxUZDGrKZvSPRoXgWSEtm4NV2Tsdr/j2dvBZMpPJvof+wrg7c5bg+oYwpSYJrPzX++ZxCru2fV7bvidV3Ou1Iv31E38b3HpHX2H
 8xKuXcAa
 ICKoaectC1f7yWnFoGR223jHzXhHLF7xdJbxLLvtvioNRW3/2yMFubJKRhS0hUc6JVytV662ae3QyEM8Jl2vFfxzzaqL1Vv0nNe9xmv+A4UZXtdDAkyatte2aE7ERiqPTZzpY32hN4VBX5PP3JEIv4b1XTvCE/8oxFVOs36oJXbH6hMtLqXVMzEUH2cg7JekIzXx2ofidRPd6A8/q61Idg1WcXob/GsldMck2/yt/oyabIJ8=
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


