Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4C41C5AC67
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 03:50:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 863A36B01A5; Wed, 12 Aug 2026 23:50:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C6546B01A6; Wed, 12 Aug 2026 23:50:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68E436B01A7; Wed, 12 Aug 2026 23:50:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 38B7E6B01A5
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:50:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BC4241604EA
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:50:39 +0000 (UTC)
X-FDA: 85094869398.08.9AC5737
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	by imf28.hostedemail.com (Postfix) with ESMTP id 00199C0007
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:50:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b=TZqm343h;
	spf=pass (imf28.hostedemail.com: domain of m@mavick.dev designates 80.241.56.161 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786593038;
	b=U812fYQC86nBMW9abBIdyMn9MRdrMyQCNz+jRU83C7wvVa4eoB7Ibxa6bCbpDyX3mxYNre
	YIjPB2ucJ3xozHjiNtFZyOnkcE3l7qr0LQFCBmuKf5r4eoCAycsgsl2R9hln6oVQjYHciD
	9Ea9+I4pKWlF0em0C2O6X7SljR/tqgw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b=TZqm343h;
	spf=pass (imf28.hostedemail.com: domain of m@mavick.dev designates 80.241.56.161 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786593038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p2aTAtzaBo15r45rnzIKt1YFOff3C6zZQXKjs0RwoRE=;
	b=rUHx9qwU/irwekvt6apejl3OEAhc86egMB3U2O8lImKdptZWLHFRXFTx9H6kZzQ9RCvLZv
	0I3Dh7vq5PoPVQ3AuJWHEt2k02ARWhuqnxK7B4xcfYw+QddrY9bcqTCoRniq/gfDGrw332
	V8UxrjvwZsTm8gfE5rOUhN58OflU0eg=
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4hLBGM4VzszKnY1;
	Thu, 13 Aug 2026 05:50:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mavick.dev; s=MBO0001;
	t=1786593035;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p2aTAtzaBo15r45rnzIKt1YFOff3C6zZQXKjs0RwoRE=;
	b=TZqm343hlculBz0/mBe/XsJsfy+PMuEIL3W+5wlpU8uIMlx0O46lcF619P32GunYbacwFs
	TeeUeDLDtFPaezUjj5SBiSJimQy8ZIhi2XdulZ1eImEiZrA/GpMiFSOTRVHNWeyC6QCdx6
	QbO9bt6qfKrjYqUzUjEfz2RRG4Gzs3aOUrHjmMcAdkGiZ0dDFTxTypaf3BSAXcbM6fzCa6
	wR/lbVUE1UkljwahXAQXZGQj/7iSoUEjraQqXJsiEC5i9VsqKAlsmcRscgAvXEqPJmLP+0
	4Nwwba/54kF+8tfVB36DF60kN2PoPSJeGQVkoJQkv3oXfbgifeMzXllaBNrv3w==
From: Eugene Mavick <m@mavick.dev>
Date: Thu, 13 Aug 2026 11:49:08 +0800
Subject: [PATCH v5 2/5] refcount: add refcount_final_put tracepoint
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-refcount-final-put-trace-v5-2-6e8bf8a38b31@mavick.dev>
References: <20260813-refcount-final-put-trace-v5-0-6e8bf8a38b31@mavick.dev>
In-Reply-To: <20260813-refcount-final-put-trace-v5-0-6e8bf8a38b31@mavick.dev>
To: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Boqun Feng <boqun@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Gary Guo <gary@garyguo.net>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-mm@kvack.org, kasan-dev@googlegroups.com, 
 Eugene Mavick <m@mavick.dev>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1864; i=m@mavick.dev;
 h=from:subject:message-id; bh=d7MkGq8H8zm5dfWimycwfqvz6dfqxiscpXO2Kan5j58=;
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFm1dgdz7yiFsoXdCuBP27WwbKaA23lGK6eAT2uWZLFe2
 6Esz7C5o5SFQYyLQVZMkaUmK8E9Y+WsROOjk3pg5rAygQxh4OIUgImk32VkOOZ8vPf03WBZ4UPP
 ZI918QdanD+88ExExZbmxdV3eO8v2cjI8Fl23sdTzSbrHypN7AvnWfM46qyDoZEu1+MnfrGJ253
 28QMA
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Rspamd-Queue-Id: 00199C0007
X-Rspam-User: 
X-Stat-Signature: ayysk4ehec4kz3617giakdfmwz4kuw4f
X-Rspamd-Server: rspam06
X-HE-Tag: 1786593037-243347
X-HE-Meta: U2FsdGVkX18f0OcPnbHdzZsHQMrY9qfOJZB1VOLZLmv7r7cyAILAd2Tl7dQZ3LU+2RQaAUdSzwMvio/bIsEvKg1l/s7slJjsF2jIO7JX6QFagSzCghrUzuZwQIHgkzhPHicX/tlMcS0qP/fKcl0xHtWIVcRZTJ5l37gAfntkXV9zGzB5OWJi/Rqag4CJBbKrAqtRzLyO1Adw3/tAooPbuHuO0D42RarGMaw/hwT45Jr1XhcMbUKkc68RNBI0GtPDvKTNhfcm7Eg2kYPwSP2XyprmGJaLB5d8q8U4USRUWdMOJ3UVRYkuOVxScM5GBzGEUWaz+3ZWiRkPCPYAB/r1ONKSSKk4CCPr3IrozPLUYVY9h76aXQ6iZ1rwnwvu3L5gYxTo9xxHCheaRbdQQqw4wKqR+if6Us1bufzpu+2EAXFZd04WrPkDoUsE158y+or0aqF6UEC2seHxNAMe/qBYthPwQwS0RUkvamnaEFyDyGfNYtbzcrORisya4qmqZSobgKllW7tkEX9PaRBXVbcpkq66Mr+kcgGMVfiuBj4WlRfu9YDgujPbnpMo5yplMjp0TVwFyXb61AeQbu2rQu2IG705hiP2E7oo/KUL7PVI/oZqkZcvFA2LBV1oPkH8ntAmFwCOfDv9fuR5S4dzBpz9DfUce6wZbOXZNTJdA/4wChUUSH4e+2Q9phAckGoIVWAVCE/cn1EZ5s2xSkf3r50k/XopTluVq2H44WZSmLdDpnyNOrNuOBiQDRyZPYrWk8qfv3EW6jdtXyxEXVO+pTzCrgiZJDlVIeOK6CN/prOGEej+zO99UCxPgu3xbVYFmb7MjIMV9V1fX776FiOkv4Ye1j1Pw15b2+ZYL0cTLPeiTMbiKMTfCoud0fcAuPkOrG+q0qvDHGJvJK/tRmffaLObUhd5rbApVnAzEZ9kTFiL3I8EWQ8FBoyZHU6H7yiY0CXGkSSrX98W0SBmUk2Z1dd
 gC6Dda7/
 CmreMeHgDXF0QB1JUHLOXbh76DxHJMLQXkwqwEw5fJkk0UbPn1mpAC/iL55UZAz/8AZDIsTck79om68sm9nLNgvbqEj/LDQR25tcnUfRe8XMyUpmwoaAG5hZy4oZos0ESlHuDRvFJqA6DNT+ntykmRb6bf46fFwqZN8/v7yxCJ5TSJZDYeSL+bDt8VBCrDHrqmES93D+Oqs8aO5UpR7tQDg49vLQ007xUeUfWUjozjNerwgopdT3mKB4Deb8i1Z6BWFPLXdPwOQga0mKAx9DxuQUtLjmjd2go1p1D0CB9x8kmzjH9iNY9n5MetkyBJfxu+iPyQbjzD7P9axtUgrZ7qJadf38Txxnta8XgC8L6e78Jh1w3x85x8TPiyB/eU78JgCBTDsVPMrGKZBiBPUDcBaoRGaQ206SwNC7KYyCxiw9Y7Rc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the refcount_final_put tracepoint to __refcount_sub_and_test()
and refcount_dec_if_one()

refcount_final_put fires when a reference
count reaches zero and the object enters its final release path.

refcount_final_put records three fields:
- caller: function that called the refcounting
  function(refcount_sub_and_test, percpu_ref_put_many)
- ip: return address of trace wrapper macro call
- obj: refcount object(struct percpu_ref, refcount_t)

Signed-off-by: Eugene Mavick <m@mavick.dev>
---
 include/linux/refcount.h | 2 ++
 lib/refcount.c           | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/refcount.h b/include/linux/refcount.h
index ba7657ced281..23291a31d1be 100644
--- a/include/linux/refcount.h
+++ b/include/linux/refcount.h
@@ -107,6 +107,7 @@
 #include <linux/limits.h>
 #include <linux/refcount_types.h>
 #include <linux/spinlock_types.h>
+#include <linux/refcount_trace.h>
 
 struct mutex;
 
@@ -393,6 +394,7 @@ bool __refcount_sub_and_test(int i, refcount_t *r, int *oldp)
 
 	if (old > 0 && old == i) {
 		smp_acquire__after_ctrl_dep();
+		do_trace_refcount_final_put(r);
 		return true;
 	}
 
diff --git a/lib/refcount.c b/lib/refcount.c
index a207a8f22b3c..8b148b576503 100644
--- a/lib/refcount.c
+++ b/lib/refcount.c
@@ -7,6 +7,7 @@
 #include <linux/refcount.h>
 #include <linux/spinlock.h>
 #include <linux/bug.h>
+#include <linux/refcount_trace.h>
 
 #define REFCOUNT_WARN(str)	WARN_ONCE(1, "refcount_t: " str ".\n")
 
@@ -56,7 +57,10 @@ bool refcount_dec_if_one(refcount_t *r)
 {
 	int val = 1;
 
-	return atomic_try_cmpxchg_release(&r->refs, &val, 0);
+	bool ret = atomic_try_cmpxchg_release(&r->refs, &val, 0);
+
+	do_trace_refcount_final_put_cond(ret, r);
+	return ret;
 }
 EXPORT_SYMBOL(refcount_dec_if_one);
 

-- 
2.51.2


