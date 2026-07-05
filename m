Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC020C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 01:21:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65DF46B00A2; Sat,  4 Jul 2026 21:21:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6354C6B00A8; Sat,  4 Jul 2026 21:21:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54ACC6B00AB; Sat,  4 Jul 2026 21:21:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1C16A6B00A2
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 21:21:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 87A38C3920
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 01:21:22 +0000 (UTC)
X-FDA: 84952970004.25.8915D3A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id A6B4B80005
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 01:21:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WmlpUgeC;
	spf=pass (imf02.hostedemail.com: domain of devnull+m.mavick.dev@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+m.mavick.dev@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783214480;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CzuX2odlcsriMWLVatERQ9r8EljYZ7ajptk7jHpfTtM=;
	b=VfmARYPW/09nyXKJMRN9w0fdaynNOmHlxOwVdiMb9Ha/lmtJOUCqUQUu2KCENu35D7SeNV
	yS1XMaL511Pc73Vf0QRi6v8+6jPyImDBhFG3GmiFPBo7Ej9Pecz7ey5aKM1VhtNFhVjo2X
	8bxjop4uJw25kXftMAo38UcI3yZR6mg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WmlpUgeC;
	spf=pass (imf02.hostedemail.com: domain of devnull+m.mavick.dev@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+m.mavick.dev@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783214480;
	b=dp3Ptgx5BKltAnyNLRfBgYY5BtYJ0IOgKITqufyht93po0kHg57BYfAuuNQOThYOhaCwzW
	kgGJ6MgracInmsxIkrelV4ixXupZO1vWr1Dqu9Kyu+d2V7MFUEb/rsGJvZ5pnb01NU9S6A
	FP7/V6MvwvvU117FBkeN/ec3DaIj3EE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9283E43492;
	Sun,  5 Jul 2026 01:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 44C46C2BCF4;
	Sun,  5 Jul 2026 01:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783214479;
	bh=092K+mnM9FfN5yXf2Xs+rcOrwMhZJL4+C3H4p6Evbq0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=WmlpUgeCRJARUH1ajt3DFVXTJPRkqrRt+9nCSIWHQIddmCwDLH7Ljh9bKj1oV/IXE
	 4RtYb6dJH1yDSR1L8HZaDTubKnx9AAWVk9Ecqwz9KFUYUZ1wWBpAQ/SQnxq9A2HMH6
	 YVpOuCaqrmMomf0l9RcBw+R0q5WfnV488IVqEZwEtGCUfZPQrgxbVYu6XmA1IwzUNU
	 IML/rQTL+uD9deU8ShGIYGOH6t2v26/TnECTJSA7QXwEIsrT5jh/UsC5uMpbxaY1Iu
	 4qnKlpjPM5KU6cwdu9V4/iP738OOo+KUfSa7UGqjhkjg7lWuBcs3dae99/gGicjehm
	 mB5lkY60jmiww==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 261D5C43602;
	Sun,  5 Jul 2026 01:21:19 +0000 (UTC)
From: Eugene Mavick via B4 Relay <devnull+m.mavick.dev@kernel.org>
Date: Sun, 05 Jul 2026 09:20:53 +0800
Subject: [PATCH 3/4] percpu-refcount: add ref_trace_final_put trace
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260705-refcount-final-put-trace-v1-3-0ae936edb750@mavick.dev>
References: <20260705-refcount-final-put-trace-v1-0-0ae936edb750@mavick.dev>
In-Reply-To: <20260705-refcount-final-put-trace-v1-0-0ae936edb750@mavick.dev>
To: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Boqun Feng <boqun@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Gary Guo <gary@garyguo.net>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Eugene Mavick <m@mavick.dev>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1195; i=m@mavick.dev;
 h=from:subject:message-id;
 bh=/PtvR2dnazpQOJk7UFgwLIewlTHNG+dDvVdArf0En58=;
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFmeGytPle5IS+VUk5v2rN96d+FJMUZOOe4Ts0+8SM9zi
 r3NKKHYUcrCIMbFICumyFKTleCesXJWovHRST0wc1iZQIYwcHEKwEQymxn++73x0W2tmSwVYj9p
 q39+llGwgofn3hNH3Xd6Vn1I37RdmJHhA2P6wZl9T9xnMTD0z24P2W+2YfGVWrNdB1d4xG85PrW
 EDQA=
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Endpoint-Received: by B4 Relay for m@mavick.dev/default with auth_id=850
X-Original-From: Eugene Mavick <m@mavick.dev>
Reply-To: m@mavick.dev
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A6B4B80005
X-Stat-Signature: 3gsdd6yinu81ic798pnoosq5z1tu4zhg
X-HE-Tag: 1783214480-742620
X-HE-Meta: U2FsdGVkX19fyPlSeWPbx1P/NbsOAXcf53F0VFJYY/LG5VRTWdXKTjJhqznYGP3OsuLW4TeAWxTqjv8NHGwxFewMS4rL7uu0qYYQV8vf8L+SLUzKsRDMka1KeOw/921XS93vzHB58TdWKW3nHjEgnVRYeOT4KkinYxulvjo5XLQya/WE6Gg3mvi9Ip79FIL+Q5R41JltYsPSyjm3DbQD3x5iE0fAuQzZ9xPyH7jcbPl9ZaXOrBvvoHMvKSCQ/zrBsKZwN52WC/atX9d/CbpgfNz4g3xW8i4AYiADLhFzsJoVIatvdnBk9zyg9M6IVno5zyfKpouhPvZUTDozfz67GTbjmH7fpuqpethywT6xS671hpE1C4Gk5MfbaW+Zxh5RYvsTF+4+4K36XIh+qKHauzt7uk7IpgFpyKDVewGYYFWsp2L6RoHrS/dLuM0xijF0lrVeL3UH23LnGqjADNWdnDWYT32iIOCJOwWax1eNuAcT9Uqf5aFUNneWp/vNRsviRism/gA2X/xykz9sJAZos2R+QrBav+KdPcXkHLItrkEzfsQ3gfvViaF6ggMXtrXapzxSCmtbAuI+GYF9ER2dkZFIGPpOjnwoRENYygFZ6mfU+BkMeqvUagA8hGPVkyxSG5HwE57l3HPsfuDjG1S2XddzhxvDib3dVo3XUoq3yPZlrqrNzvtZow0qzNrGtRq11uTWXx1G1oMx+/74a0wL/5jn5+X8mZLHoS5/0obGZB/zztTs+Uuq4LWfA/HuR4BKcaIBWU8V+IS3NWvgrXT58uFptiPTG6IRRkWOZL4Bl/OVgYGkj0z62EqVBvGxfcz5NRrHBHsDn7BmJ/lhNYQVJd2UbFYkGAN2hyfPEAueiSGbicmISZD4110q0L5VoH3PQSN7ZO4r1QcKe5vcSe8UBgqraY0ujSiaFrd43fcUULsbpxkx9R0EXKIR8cPkvurLYLP5xk9BJuXNfQUPOj3
 RUUUGGqC
 81kiJLMCEV3eUd5FbkJWcfCtbU0xrg7IA5Qag767xuC8/vMUsQt4sJEF8DXs7rpmL/yAxEnUxbXUUCu3GE10eUt4ogFeF1kFvH6OGsGRBytWEMapt5FnTrODeu6m2PK0cWObDpRG+jQVs7wKnXf8hJ741lfVe4pjXjyou/q3ObhAma+XuWmQL3LihFqN0d+6nMGEImGyzzEJxpFspsN3v9ZdQ7T7HyP2uBu9JFY+i/U+YnbUT4FIU3Uwsx1ASZz/e0ZSYxQ0yvGcNTQbU6Mrg0OPAQPapG9i6kzEYvmshy5ZS4Sl5QEyZpkAGJ3uTPujcUk8StqlM0dKQ0Ytf5c1eck/xR1vJhWxFzmUtvPKBBsGe2VZ/yRTL63ZugklevIhC1kME9nwNwA2GGhksJjOxVyV+7wlnNZcIBsdo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugene Mavick <m@mavick.dev>

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



