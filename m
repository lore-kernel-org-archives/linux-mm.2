Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30A5AC43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:43:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 340BC6B00DC; Mon,  6 Jul 2026 02:43:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C6926B00E8; Mon,  6 Jul 2026 02:43:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 119E06B00E4; Mon,  6 Jul 2026 02:43:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CF3386B00DD
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:43:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 58AA8C19E6
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:43:24 +0000 (UTC)
X-FDA: 84957410328.14.6F6B610
Received: from mout-y-209.mailbox.org (mout-y-209.mailbox.org [91.198.250.237])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8485A100005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:43:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of m@mavick.dev designates 91.198.250.237 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783320202;
	b=4Wx2tNdhv9H9fsG6JUVlPJ+Hm7ZqDSoKrGSkVn2dX2U4nnMDzRfIXa9jD76UEkoGnZGsW0
	zL7K8sKaxN2FjGJk+zog1Hip+Y+60UbQpomjWHMTvxCvsXoGDS0HI5dtRZngZutqnF0N3J
	TCkSqz8m/aPJ4dujZ0opYSXgmbRPpgU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of m@mavick.dev designates 91.198.250.237 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783320202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/6om7EqV95b4wafnxbHbtKHtT0Uog57+s8mcXQojkik=;
	b=IB9XmWd2A6Rn+bakij43MbyfTtVszjk2DebwqWJWatXQg+xzUBqhztqbNOLbiKBxc0dzE8
	2KELViOY1YTelfs6MiXsrTcehy0n+cRGp7tcoi0m8zxXBt4WGDJB6v95ytdAXToyZy9bQR
	wQxVDInK1deeLdqQ1awKdQHHEpk0FMU=
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-y-209.mailbox.org (Postfix) with ESMTPS id 4gt7rH0Bg6z7vVj;
	Sun, 05 Jul 2026 02:38:07 +0200 (CEST)
From: Eugene Mavick <m@mavick.dev>
Date: Sun, 05 Jul 2026 08:36:58 +0800
Subject: [PATCH 3/4] percpu-refcount: add ref_trace_final_put trace
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260705-refcount-final-put-trace-v1-3-a41d3fd0e869@mavick.dev>
References: <20260705-refcount-final-put-trace-v1-0-a41d3fd0e869@mavick.dev>
In-Reply-To: <20260705-refcount-final-put-trace-v1-0-a41d3fd0e869@mavick.dev>
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
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFmey21/Br3O4jVZuJfVyfJm+qyMYq1Vu3treQT3teX/7
 ajx1PrcUcrCIMbFICumyFKTleCesXJWovHRST0wc1iZQIYwcHEKwEQCWRn+ii97dimDqS8gL1g3
 LTT8oL3+hVzz0mVFc8sEDjTsNp04g+G/k/4MZtkrFVZRVyLMc2t38nrvNdt32a4nMnL9n7T/jPa
 cAA==
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8485A100005
X-Stat-Signature: 3ryex1pzythhu5ezzeofxbky8p4jszzr
X-HE-Tag: 1783320202-924330
X-HE-Meta: U2FsdGVkX19bdY1ieeQEUv4LSqSTVW6A/fYbCom3gOuhH1pi/pyiKtuMMz2XC7kXu2p8Y2tXMxUSHuAazXb8Bb6LYKvyiVmj0rYGGDdpbfxIp1pkNkjrWpxQm3annHDUyfxMXZb7YjS/1laTMXxMZBwduQAOPUb3RcCQnOg7vJgM5zNsRYqLUuizI9mMZkPPxb9iUVO45jCV+JLZJJsiGU+KnG7nysUU56u2UDg0H4k1TXXGdkJvrm5dWiDgAOi3EvIIfsuBHsOf2pzJP8+ksKP52i5zqyN1TtH78c+RsKL+J3HVASmnLw1iN0H4h987Dl5QWulKVJ6++Shln+7jfa8pQIh+5Pq8SKiBhU87xZLNmVIYnKngsPgsLpTWiNnkKpsOuudPhScQR1smYfUSpP0qyD7i6wYptIAZKjbFYFdHGZIUxXC5Ef+6fI67YUYkW9r9OjDlnGVKvtWESnVBHYMrjnf4RMx8hBzyx7Dy418DV3e8ewYbqQF8gA/qzR9ZFcu6rBD/tc8T/RSxt3hPWsOWSlD1fPirdqqalGABPytvuYF+boLXIkUDLrgtrEEsr9sY1Yqlo2CKhddVpTRMeRtLO3Z2IFjaIZCOowmiYjUdYZbxV5UazvytG7wiZXQBtvuO3flDVnpbF31op7Lk0FjmAj+REF7ZddN97E+mfy/M4ECIwNEhcaalwoJrcnFnGIh0wAFtI9JuWXXuflBy/dP9GcWSDj+KZOp5CHjGyyplPKw3WBbmdWoL1N20coUPr2KVxHyAKhmUy2s3jnhmH/XRsbOWJTF2LvyjNiiZ5DGLNjGLtQDJTbkwmTkWN1MbSGr+slG95D3sYO+XcGkGM+lEDXl4wbLh5n5p4Ql38QDNFw3Lj6Tgbhm2DfRf6fk0x4cSoEcxzH5e6Noo6Mo8exCi5qPXmgpSf7ApZY0W58ff0C7ncFYcO/KMyh7QdJVDs/bxDAQXZhrGEehkW47
 xNanxEdW
 zN3BO/D/zJ8s7xHh3i94ppRZLMB3CdK1Zv6BGb+3RzkHWFtXHjEldJOos/38R3QkBnslfJszzdTYTt0tIZuX6i7w7AbpQMJHds0HxB8yBZkXDnctZLMvkXt92i5+0X9XWumUXdFC/gK0JS0QWtcVm0Zv0Y/N0kRBxpHMDC2hjRdyM55jGUjl6NNNYUHFteNO9OUf3CP/GSno8o+4PYLUeftBhHR+GD4ppezJcxGhVkKbr0oA=
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


