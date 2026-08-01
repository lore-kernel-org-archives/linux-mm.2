Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3875C55172
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 11:01:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93DB96B0095; Sat,  1 Aug 2026 07:01:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EEC66B0096; Sat,  1 Aug 2026 07:01:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DCDE6B0098; Sat,  1 Aug 2026 07:01:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5AAC26B0095
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 07:01:04 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E7928C029D
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 11:01:03 +0000 (UTC)
X-FDA: 85052408406.22.44B07E5
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id 29E62180011
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 11:01:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b=ULv7c+A+;
	spf=pass (imf06.hostedemail.com: domain of m@mavick.dev designates 80.241.56.171 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785582062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+WpDJUffFYkGym8OqsSvgqtunStF+Lue8wI1l/VKbI4=;
	b=xn4g6YDxgdCACo6p88ldc97cr66u7in/UDjaT2O0RyCD8HLJFDbcEwIBEX8njVRVpgL1RJ
	ugYAdp4dkJEScWUunU/B/JNZ7/PcfzcGlWuTCLXmmHTGWS5TMu/Id/Dpz1oziJCYSR+Mm5
	Tym3X5TcuVZOsoOPd1EXRq56/rrWbo0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b=ULv7c+A+;
	spf=pass (imf06.hostedemail.com: domain of m@mavick.dev designates 80.241.56.171 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785582062;
	b=fwVpyvpPKnGH5/02VVwDg91EM0HA1Sw5Ud46sjykm2bkXPx1G+s32f2YzZChBsQB5NJwmn
	yYs8bKA7ltsmrJe1uluWCpykXIZHcijIwaZy2d/XuRCG/44oH5X/si4+cRkJk/3Xa0BH3s
	ZkQITsInfLIOzqUdfTOXCJ4tHfYitCE=
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4hC0NW26qRzMlG2;
	Sat, 01 Aug 2026 13:00:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mavick.dev; s=MBO0001;
	t=1785582059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+WpDJUffFYkGym8OqsSvgqtunStF+Lue8wI1l/VKbI4=;
	b=ULv7c+A+XtrEfThv/Q/aTfNHm4m5vuNp8oaxIEWB+EiIKIi1CZzpbfhTbqY8Xv9fWH53/t
	IApqH1JzM8fgCZN624DOtTl28kZAqS3H0dWz8UnO0Xndus3evT1PK2mNnAnyJN01PWQuaE
	v4ncoSakk3Z6c5TiqRnlYyEFfE25xdTgn/2KbmoY0Fyjy776rxjweSduYTGdhp8Mj/RunU
	7FxUYA4Kgyot1RVQ23atRYHJ3VTRTLugpoaeQ8ZIuQmcDg8Vk2cf97MSndqjd5ejHbP7wa
	tPGw4RL1smhArVOZ1imMzGZjnO8wLiZf9iS4rfN793SR9oMUEB7cxiHNZeiJ4g==
From: Eugene Mavick <m@mavick.dev>
Date: Sat, 01 Aug 2026 18:59:43 +0800
Subject: [PATCH v4 3/5] percpu-refcount: add ref_trace_final_put trace
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260801-refcount-final-put-trace-v4-3-2e58678f0ffd@mavick.dev>
References: <20260801-refcount-final-put-trace-v4-0-2e58678f0ffd@mavick.dev>
In-Reply-To: <20260801-refcount-final-put-trace-v4-0-2e58678f0ffd@mavick.dev>
To: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Boqun Feng <boqun@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Gary Guo <gary@garyguo.net>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Eugene Mavick <m@mavick.dev>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1198; i=m@mavick.dev;
 h=from:subject:message-id; bh=vVWsfTjSGw6e33WP2d/uyqteLjy9dxiqe2AmCt04NhY=;
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFm5FzdyWXXZb8zp+M/n8N/1V8Y3De8Lh26s7SlbfGn56
 /ZHFQ2aHaUsDGJcDLJiiiw1WQnuGStnJRofndQDM4eVCWQIAxenAEzkci3DX0mjUxb3ftbvbzVg
 q/pX+6Ux8RDb/Q4Dt1l8Eic/T2z5VcXwh3PjSvUA/7lmtze/mStzIVOzZsPxdapdMu2Guyu/6x4
 y5AQA
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 29E62180011
X-Stat-Signature: rikk4gj49ycknx6n5b4pmmt3e6f38e7e
X-HE-Tag: 1785582062-119683
X-HE-Meta: U2FsdGVkX1+RWNXjcN35MisO3bPzQcSdLJwKxckKfsyYmRUVeP7SmBnLZnB0Uut0tLTeGnwazuSqjG1xvtSJaJ5VFkWUMOoG7pMti33fFylPtQumBjsSZ+3zggNA/1fpaNddR4S+BxAXvw6bU77L9bcshdJnur3JjsLSEPEN3zrEpLeczCVXOBUpscAs3EcmwOmonbYLM/545w5/pa595bY8iJwPP61ukQgytvU4TIV9qKZQGBWhSVwZDX7/Hzw47lKq5S6FtPvhh/TbtQ5TwvFiGW2OaP5tGlqsoRW5HaKuE69s/3ThBYLdeyRnfk18X2Zg2nTO7HWzyrit0TMFqRNrL8O+Hxs5yBFvfGCsOSuGc5Zei7jvgRdGh3Zs+gx1LKy67tHyTgtsnskSoLQGkPUSQR38ZdPlFphHgbbSazS/eKBIedR39R1U6qlAAx2Kzge1aRtbdXYj6WLprFJfVGtaiisydCLVbEfEWK30mAOVOXWJV8RGzLLDk9fgdPwFBiNvpwsYDQQ6QI4IFlL1mX+upZkTYaTevND8wqr38azVdr5I3GisMYsj8n2T5KBKiLIkqXjWFigdP6VIE64OxG+Qk75a4oisw6YNtJ8B//CmhSP2uitl/HcB7gKaeHgkfGsIfxrKQ7d4wKIgRkJiKFFIDinz0qKRXUd4wIsysnJGE4S+++B/9USMvuWcRyc75aji2/RzkrfyJZB6iDHuD96VSp4M4KvzFaIO2JDzcZSyP4w21LM12TY2/Cs6nNTtaLoyvhxVMM5yZZ5ElOJjz5GOSBA49ZXjRW3oUXpht4JYyWCCF+bfUBurcumzhyoV3xsLoI3BnD5oaI1syWxiQP76P3TUi0TiseqLDzqCmorizhGcuQ8sJyERQeZfXogyZDLLx2ER8bJJqdIKJT3jWiFAZtBUEFemdLxLTL3Ec34/jFkVaFRkJ5kevZX567wyRcapszZ+HZ98eBb+x0S
 F/qMM1hH
 smQTI6I7hUwPWoLTVVv2LXm4VqcwN00wlms7gWUJqLDUg/ZteU5oexqbtgTae590XQviNpmeWj0tuWgWJcM7k2u1DTWGL/oP2QFeleHyXknYh7XMWdNli7Zq8Y8OzaaMPbTJ2Ag8F8Y6oElAOU25/GUYqUww3scaixoHBJRaesk8ZkjIsi18zL0fVyxEg3mK5n+m70k9op7Fs8ENpMbx3+NdDeArGHALdzgcNQTtFRUf0jwDs+6N1r+cDNCBmR0dU6ntQ3LOeXSPjnjsbEKBKBwccpIAaPGSc5xfTIEIdQpY4O+y3DALo/oAuDBFSg69vzAZzYM6w5c0Tcfw=
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
index d73a1c08c3e3..f870ac0e8c06 100644
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
+		do_trace_ref_final_put(ref);
 		ref->data->release(ref);
+	}
 
 	rcu_read_unlock();
 }

-- 
2.51.2


