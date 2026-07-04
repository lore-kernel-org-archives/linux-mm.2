Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CA21C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:43:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 678E66B00E4; Mon,  6 Jul 2026 02:43:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F9156B00E8; Mon,  6 Jul 2026 02:43:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FF6E6B00E4; Mon,  6 Jul 2026 02:43:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC0696B00E3
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:43:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 57AB78D072
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:43:24 +0000 (UTC)
X-FDA: 84957410328.13.6EA9190
Received: from mout-y-209.mailbox.org (mout-y-209.mailbox.org [91.198.250.237])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7F266C0006
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:43:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of m@mavick.dev designates 91.198.250.237 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783320202;
	b=jAZplE9+/bH5OeUZG8IJinL0KI37JVU36bNFCNC4guGfmouRkdsUTFdvQaQVNfJpuYVHN7
	r+mmZmMGb0iQ6YIse2sSrTgyp0q4WQRf8kb4AtLqWbSa9jJ3gJPH/TUmEoNbIEQ0nJwRYq
	yb/pvZNjZ+rFEGVwww0j4tnS/TyBx9o=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of m@mavick.dev designates 91.198.250.237 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783320202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q10jfyhsC+ilV5voSAeXf96TIcBRjbPsbwt+QWdyz88=;
	b=p/jGXzDseM8/ugotn/VEVrezDQzaW83TQKynXpZnwpSSvX7dNUQElqGDf7xNqOj7jRuHiQ
	4pMZOmgO0qvZuJ2Y+ot4xD4753tLeohPfOe8Nn51se4e6JjiWAMGvide0WR8OwMVxADhfc
	QmjgvWm8QGh8YLCnbxukWb1IqVwy/dk=
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-y-209.mailbox.org (Postfix) with ESMTPS id 4gt66Y2ggJz7vSb;
	Sun, 05 Jul 2026 01:20:21 +0200 (CEST)
From: Eugene Mavick <m@mavick.dev>
Date: Sun, 05 Jul 2026 07:19:21 +0800
Subject: [PATCH 2/4] refcount: add ref_trace_final_put tracepoint
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260705-refcount-final-put-trace-v1-2-cdd0014626a9@mavick.dev>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=878; i=m@mavick.dev;
 h=from:subject:message-id; bh=oxdQX1dkebrHkQOKFGbMe1L7jn1KmiWYDIa5MeosIJI=;
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFmeU5m0OA0svmvuKZ/+Std+i9ajtrd6j3jWMLTXar6ru
 1Muszy5o5SFQYyLQVZMkaUmK8E9Y+WsROOjk3pg5rAygQxh4OIUgIl8bGL4w8s0o01x7/tJfaoS
 XwI3lcYwPc5IWnOpeM/LT1H1bvb2dYwMv9oPfpIuOfXnQJGxglzshL3PWhhsTCd6XTk/tWSS+IF
 TTAA=
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7F266C0006
X-Stat-Signature: qawyrnazkkwcchb8zzsgumx1789shewy
X-HE-Tag: 1783320202-960619
X-HE-Meta: U2FsdGVkX18Qrk2V+QAHicnHSFZ2IT5vXx1Av4r9NdHUjVwzykMj5RQBTyVEUBG1vTjUIdqp1A3gFqN1ow4JwR/nglbahPx1WnBqml6wbJz0zW32mrTbrMO6HSVeVhVxlq9wRMxgTl8vzmbkncfzSWVw/iLKswnvpPETUqY6YGR2igF0CExn1pvO1W8KvimjUO8uh019w0Fq0UBrg5mpCTHKwBbvr65xsquarkwh3vcX3lmy0K8+syqpA7jddKXEXiO8OLXaQbINS+9rQ38cTZ1juu/vLNqVtDn9SCBuBGfZUOjfMTT2kr2bg/14MhKnCY9ebTkqhHgQVoPhH89F2oB5w7OwIwFST9DN0wt3MqQURmpgZm4G/ByROKRMDz8K3OEFFB50MOZszZ8qgWjvz7umwNKtZicv1dtP+x49Ml/9cxAu6dDk1h4Twqr44wOYmFYYZZ81I12IOUTsJhcO7gE5u50G/vObCpWMexweE+/FFqiJTfTbAujE8+S1quhdBeUd1p0lrVR4uXiyVPwJO6Sc1S51lZB/YGklq0G0FNcIe7uQN0Eux8pXCalMFJb6lmv2E6ILBy9qJuUb7BgKRj+Al8NduVicxeqsQdzaXIRx7LzjopKZZxioz1c5DJ+0ojLzQCq3fWn1NR1wdYb6VARVkirhTNmDLmGsyGkPipqenw5WPouiS9K284Ylh83qeTBlul7q++PmL/ksSPi94f8ZN7tUcuhBniCyr4+wmPFrCErhOcuJz63PWZnOLYcoiEww1ItJsMQiAC13NZsCIeeXTcGDG9F/n9u8nLkc1Fz2D7T70tGqpv5fcz0c/vhWqh5eZjwr1reMh1rA+HqgI/h4cQSBVJOa925S08ERCe8GRHB366tDbngS3KmYi/WXbHHlXfa06bedsfnIqHQ/ocp9/7zinp6tJdarqdR9+xPMsfQT3173KKABXPVvuLvp6WxU1hxQfY3JTY1DG8z
 e4fpSyZl
 9S9UskZS28rq2paYh2VvRVyyhAFeeSrqYN9Fi9NKIPwIKH/qjA60XNqGmQOzE+GSlN6p5Cpb2/OXRCXmkZQR/RfgXOKx8/eYOTiHUJoiWcJ+DfLLuTvUPpzifLL4rckDd9r7JA9uXmRkD3f5hex71bVkQk8D2AZ5fspadUECwrz7F8ilCZq54f2lW5EyaQi/DPnSPz6aJt2TZ9Wm+URkFjNB5cIjF+gMmz0xe84la5An/n7c=
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


