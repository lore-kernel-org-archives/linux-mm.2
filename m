Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD7F7C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 03:50:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99BD16B01A8; Wed, 12 Aug 2026 23:50:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 925A56B01A9; Wed, 12 Aug 2026 23:50:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 814886B01AA; Wed, 12 Aug 2026 23:50:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5495A6B01A8
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:50:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D033640588
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:50:49 +0000 (UTC)
X-FDA: 85094869818.26.20175C4
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1E6E3180005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:50:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b=dYmKnJeS;
	spf=pass (imf16.hostedemail.com: domain of m@mavick.dev designates 80.241.56.151 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786593048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d2nbvdvUXZ2bcKFVdCqAMhlt7dahLAQjc/Eewymj1aE=;
	b=PU7z7QnMl5UgNxSOkudZvFWg0WRpEp9aYeikuwL37KP461ZDruBGjWBbkZaChQKtAhdtW/
	Q6iwK0YIqaUosGnmDkiQwrliKUwf62bb9K5/MR6ius81xCjatymUs7i9jYETHbcg/miESG
	P+WweRiF3EPOX5St3enAHD1yK0H6zEQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786593048;
	b=OWkIpgYtSLe8oanGed6jYL42vhial2oQQA9rm7TXKtPevTa6lHKz6WT319O4UdA2f+NvuX
	XgEK1Ec/JsGjbiE0GY1j0Z3B1O4/hfNkj6dyXP0vdzbIco2Zh+n8vK0kjdy0juebjZ9umk
	TbCuoRcrOnRL63XhvI+Ks6IZuld44MQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b=dYmKnJeS;
	spf=pass (imf16.hostedemail.com: domain of m@mavick.dev designates 80.241.56.151 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4hLBGY1Xvfz8txG;
	Thu, 13 Aug 2026 05:50:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mavick.dev; s=MBO0001;
	t=1786593045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d2nbvdvUXZ2bcKFVdCqAMhlt7dahLAQjc/Eewymj1aE=;
	b=dYmKnJeSbmhsSN8xaUg5TWfGokwgTCmkfyDM1gUK/Mlp6FKTXRupNI3oQLiPnsbQiII28y
	0LOfBc4MCfXuNf2NjXQWo+2cAj7BbqUi+2yzVLQjJJx3YmrhHtylOmmFIb0fi0ckWD8rxJ
	YfV/tTSNIF53624kluAI0Cu3XLw3pVvA0NR4wSdPK/ZY7JcIUnCWeWm3HDv4egOKhmAD7Z
	y15aJY30icZtAFMoqiRChRwSSJnFQNDcmN9RlIq1hwytqzBtuBpnHlw1SnPAjB8+wTzRtc
	Mnp+5T2qi2pgt641Qz4OUqwdzl2JpRW1C41rnfTjFlgb21YIJHdhmpZWR7iUvQ==
From: Eugene Mavick <m@mavick.dev>
Date: Thu, 13 Aug 2026 11:49:09 +0800
Subject: [PATCH v5 3/5] percpu-refcount: add refcount_final_put tracepoint
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-refcount-final-put-trace-v5-3-6e8bf8a38b31@mavick.dev>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1460; i=m@mavick.dev;
 h=from:subject:message-id; bh=h9+L+Ie+ahOzZJ0p77dLgmKslR+819Hu82i3Gm1bQ7c=;
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFm1dgcNpzLPPVhwRDyp4oLsy4zFJmqF/dfzGa5vcz+T9
 7j5WFp8RykLgxgXg6yYIktNVoJ7xspZicZHJ/XAzGFlAhnCwMUpABOZ+ZrhD8ddnQoj44suWa43
 Qt885Hoct+bWshvFt/xddTbxXrD2MWD4Z+yjdXqtQDmfUx3/vT1/kntFjk8Ntq4x23Gynjlk2r/
 rHAA=
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Rspam-User: 
X-Stat-Signature: r4dros1hkyo3ugg65te4chqyejoq8fa4
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1E6E3180005
X-HE-Tag: 1786593047-15287
X-HE-Meta: U2FsdGVkX1/B7ffgkZ1LTkFf+irreEYRCfy/YRe2hQ+bKFwIM+BPaWYMdrGjjneO5nucI+eLTmd2+wnnZyuV2yalQUMu53mNftGVo6lvHT3yZWqEV28Sd+7epoB4uL3Iys4CSTOc1766UGoj9sa2W2931SmoPTE2/hlnQPIaajDnJbDmmW0ZNdVQhaS0GtpL4iI/2KMUiVQp18mdsXsl8kieDnoU0mA5xmNKxzbGkN2QdoZh9flbm85eqmwdJDJ/bhWMAOS2+oBsgCIVTtDaEZHlSFjnCmR50ctIukuwyu+PfK47LSxeYYoNzX++Y3yXKtI8lWyk6Z6JNDk0/HrBhjDlkX0Oe905idQdqEtttmx+EAT71nNA8PiZff3He7BXsqJpzqaswa6nWVHo1+Pb2MQ37GBKy4vWtzb0gcwvT2BHKKQ07kjRebdnZBIKjqPa13ppAtl8HcEt+b250MG3+htCUS0Tp3+KL1plYJYAl0R4+Hcp/pbbtdc6KV0+MlI2C3/6KaZPmmhvIiViEFHoVLveeP19CejO2U+5XDYQyRBueMkNvO1IYzS5SDFZwFYcxdKeTFb1G24bq6Yum+BGFuNtwAHQDV5caWUS6k5z66RaODXzp6m+9RxGV3WtLIQmFApXyfLaJjiK+kO3SYH9XALC04KqChmM8FOY5sOzMxqRwkCHlb0VBMdajr9cUYdvKZTSzIrDzHZZPMCChF/a5MstS/+/Yn7tzca8VXpks2As4bu7XhwVLX7M0CEEzBtjn6iMnDZdWG/Vd1dbfLu/+VRHY6sOToNTRHA+wvZVXVIKILISkyBXrzml9S/dQzbqEfMwgfNcDD543k8I1TsCjnkEDoBAWLDEL+gPqX7ziLY1ub25ScE7+e4kKl7nAql6udbkZcOyikjNHtH3k1ytFK1RxyPaIaNcB6qQkF7QL1XvIXuPRFHfHiwoWd308XjWBbJDpOoJRH0SlyIS1qH
 8kKH6Uhh
 0jZ9XSTlhyq/BPQQL9cN4HBpoXGr1VAhP7OA+prhPEFXt2msv+JxphYrjfSer+c6j9aubZ2MaJIuXhI2x+SkItkIweUdjbmTk3gDsK1IcM4hHtqIrexWjHBtK+SyoBIGi+heqUW6RZp8wIUbD8kou+Htk3Y0vvUv+/LOYLWHi6YhiOJee1MSJ3T5gcKBn0PfBHZGDT3a8f2R82D7BSCmeux5imUTSRkKvouDXn0bV/dus5qko0aWaCCmstesKn+f8juzwnaSHQIXWy0kxMZOpjMYPZtjT3Ux0o6P0JqdE6nc3AAd36jQYs9Ri8jJAAsJINQyCG1ARFxJig7MX74rABtb0aTz0e9VGwuIQ4IixRn2+NSj5/+EL7pnVZQkVaLQ+9ZWY0Jq/s54NzKtqKapks2uZiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the refcount_final_put tracepoint to percpu_ref_put_many().
The tracepoint fires when the atomic counter reaches zero in the
atomic fallback path (after percpu_ref_kill() has been called).

refcount_final_put records three fields:
- caller: function that called the refcounting
  function(refcount_sub_and_test, percpu_ref_put_many)
- ip: return address of trace wrapper macro call
- obj: refcount object(struct percpu_ref, refcount_t)

Signed-off-by: Eugene Mavick <m@mavick.dev>
---
 include/linux/percpu-refcount.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index d73a1c08c3e3..244992b2f746 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -55,6 +55,7 @@
 #include <linux/rcupdate.h>
 #include <linux/types.h>
 #include <linux/gfp.h>
+#include <linux/refcount_trace.h>
 
 struct percpu_ref;
 typedef void (percpu_ref_func_t)(struct percpu_ref *);
@@ -331,8 +332,10 @@ static inline void percpu_ref_put_many(struct percpu_ref *ref, unsigned long nr)
 
 	if (__ref_is_percpu(ref, &percpu_count))
 		this_cpu_sub(*percpu_count, nr);
-	else if (unlikely(atomic_long_sub_and_test(nr, &ref->data->count)))
+	else if (unlikely(atomic_long_sub_and_test(nr, &ref->data->count))) {
+		do_trace_refcount_final_put(ref);
 		ref->data->release(ref);
+	}
 
 	rcu_read_unlock();
 }

-- 
2.51.2


