Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88A49C55173
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 11:00:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8062E6B0092; Sat,  1 Aug 2026 07:00:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78E826B0093; Sat,  1 Aug 2026 07:00:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67E706B0095; Sat,  1 Aug 2026 07:00:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C60F6B0092
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 07:00:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 652AD8027D
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 11:00:56 +0000 (UTC)
X-FDA: 85052408112.01.3FA64AA
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	by imf05.hostedemail.com (Postfix) with ESMTP id 87DF610001A
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 11:00:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b=b7oXTNTj;
	spf=pass (imf05.hostedemail.com: domain of m@mavick.dev designates 80.241.56.151 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785582054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C912dpGQcVcNQokG8z6F9kwSDBoO6n2Gknkhy/XwQHc=;
	b=4PQLc7ceTDBsU1lu81CKxkDx1EfpCPA2EU/uvU4cBdq8c7Eer08abhw9jFDSYlipjbyLAd
	dM5S7OZ20GTN9i6VUorQwS5lpyx2Ojpxrs/PhEbZRjFkSSAE564zQ8yWwXrDzDGAj1S2G+
	GDLImoV+qy/oSzj/nYAdtauL2371qfg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785582054;
	b=o3prO34brwccnqPreEkT9mt2lAgcJB6ZtSZZNW7bXf0IwKctI7jZ2asgrb1WlMuNU/057F
	TrEqh8D70t8zle1a7NHFTtnWFpoV6hHF+NNFtjmVCW8erKnhtHq6iOQA6+4vgq7lYKDFVV
	cFnSwyKCh28KLTDmO7uVxtaoGRavjl8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b=b7oXTNTj;
	spf=pass (imf05.hostedemail.com: domain of m@mavick.dev designates 80.241.56.151 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4hC0NM5NPrz8twy;
	Sat, 01 Aug 2026 13:00:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mavick.dev; s=MBO0001;
	t=1785582051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C912dpGQcVcNQokG8z6F9kwSDBoO6n2Gknkhy/XwQHc=;
	b=b7oXTNTjj2ZCjCrjXH+4onJXBZ6okt7C6WdM+iEtplUoOlZh0An8Gt1LjzqSL5V97xIZT4
	h7Vkq7kXdpBxiePE+e1Oo7O+4aCj4HDTlio+MwKv31V7yZetw03K+6hRotzC1IvPSipcyp
	aO9aKbTG+FscVo4yCU020JW1nEY2VAIATiXBYprDl99x7J7KBELWSUFVGyI5wVOidvM3PI
	ocmxALYuXyiTEcxHaHyxI8wnw5Cc0RQmfx+zteGZobHxeiPopl8XeWsM+Ff54vL8pYq42i
	CXcKgsPMj9LdyKM6HtN1KmZOGa2Wj7TMU2F6OlBg3h7eEY2e2WkTFlT0uUwVwA==
From: Eugene Mavick <m@mavick.dev>
Date: Sat, 01 Aug 2026 18:59:42 +0800
Subject: [PATCH v4 2/5] refcount: add ref_trace_final_put tracepoint
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260801-refcount-final-put-trace-v4-2-2e58678f0ffd@mavick.dev>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1632; i=m@mavick.dev;
 h=from:subject:message-id; bh=6SxDI3lnGUVOqQynlBB5KrL+oi0ZqISwEqlbLLcv/7A=;
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFm5FzdeTp94SLNX3H9W4vWzJQy1ntvEAl8fNlzxQov11
 zxpDbnFHaUsDGJcDLJiiiw1WQnuGStnJRofndQDM4eVCWQIAxenAEzkvyfDP+vKxR8r+V5M/+XX
 EisVfOAMe7m22o3lgjd7ilweRTKZWDAyrBTY4lr+ubyZp1b30KMN1yo+a/4Rmctz5tetDbpGEa1
 8HAA=
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 87DF610001A
X-Stat-Signature: dkg4kxw34xu8t79r3ngszm7dx5z971hk
X-HE-Tag: 1785582054-919552
X-HE-Meta: U2FsdGVkX182li9/miA8B7fUzcGoDBsGWmONbyFHuLYJ/OikcQ9noDBehmNHlVcdcLoyX44w+a+97WLFpDU26mjZPg9WUkyVpliJtg2nUI2ELA90YAbbxIZtgA/oZP3T9famwHFsCJ8tzxjLiiTVbLpi/hNlOjJxL8x8Gj03LPzv0ocuBE7NQSWyxRGk3sg8uZFrBH3z2mlz+mjkgeNX4tmSrxwI6hzaMmxeL6JDjuO0N/mpby+4bFkDJ5+FvM+EmQuttenbAQYGPmJ4/KuaTvvSwI+pQuvHSVeP0RoMNe49Ae3mnppRxzDL97MDZxVAPxpwjwsIRgwDVVrLqMq38On69iv1peFmXQQsAGoKXRMff+Gg/NF1BbKMibJTCadrHycGqbtmui1G/Xe0cD4w8o73IVnayilggp+LZe6SsvJ2dCbNhjqf6pRe9lPGhmNJghwJepqmrDt+EDzicF09B/wZLNG3YeVIQH3BfTygGvT+j8/V1ls/7cqVRzaVnBEonNsOFi3WDJqTdDWTJ3kEBSxoMp4C3gSNYzZ09mdyNMnvH1nDeB6cTtdZiT2oEm9hGYhyWm6F/TGln52oZKTwMWVnZMQ1/QuqB7cERT5BHgbDhSiJb4WmvBn6mwXSm/VweSltIEJOqSxo8KBATvl6u0rXgzCZkVH5vuBvPULsSEtrE2E8yd80ml3+aUrm4EX+Y+WLQv/uIGPuc0ikBszOP1GlWLB7wyq5R0oGMk/PpGUKGj7sGYfD0jhOooFPsH70EGCyKvcyC2pBwlsmlJ8RSFpAf8WEC0kyvnaQ1zUB+9Li22Qndr79jHEaDLrYcOJu1iAvuKBPflOyDQY5mzK2XM5+5dJC1pZKwUJTPZZNZnSkRq1c6xf+Sk3eYlTYKjnjuRD3jV++bF66FzCakfLyQkU6Hzq4TgESkr/yWA1oNtc+XSf/GGW47kjId6n8FgE3Z6pmcrb8DnHktZ5NdiI
 EAVArvjD
 +o1QGiUkBCUsoDG5HNZXJhOD6YXd9pWSUmXze473ieKLT1ljpkspVvNgk5GjEXIDC2PdTwMyrBxsbbL3U2RromG5max24vLSa4DU3JEbJ26BLWDoy9eOIChTirRhEdEf2LLaLdvsEsyIs25aFBpgonQAzLWQ6NGHc65LHyJ1nRROQ/eWs+D1BL0Nj0688RGSmOdNZbNx5lWDGrzxq6zNf9EIz2clo+avYTdTm4XVv/R8J9yGN1Hx6oag1x2tbcJ9zxMRSn8AiurfWILRq2deUVx5MC6bKhU7/Qr5c1BN6DbF0tYBfslv1pZuBy6mAcKgWT1T+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the ref_trace_final_put tracepoint to __refcount_sub_and_test() and
refcount_dec_if_one()

This tracepoint fires when a refcount_t reaches zero, capturing the
caller
address, trace wrapper macro call address, and the refcount_t address.

Signed-off-by: Eugene Mavick <m@mavick.dev>
---
 include/linux/refcount.h | 2 ++
 lib/refcount.c           | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/refcount.h b/include/linux/refcount.h
index ba7657ced281..70d07a462da1 100644
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
+		do_trace_ref_final_put(r);
 		return true;
 	}
 
diff --git a/lib/refcount.c b/lib/refcount.c
index a207a8f22b3c..ab88d4674942 100644
--- a/lib/refcount.c
+++ b/lib/refcount.c
@@ -7,6 +7,7 @@
 #include <linux/refcount.h>
 #include <linux/spinlock.h>
 #include <linux/bug.h>
+#include <linux/ref_trace.h>
 
 #define REFCOUNT_WARN(str)	WARN_ONCE(1, "refcount_t: " str ".\n")
 
@@ -56,7 +57,10 @@ bool refcount_dec_if_one(refcount_t *r)
 {
 	int val = 1;
 
-	return atomic_try_cmpxchg_release(&r->refs, &val, 0);
+	bool ret = atomic_try_cmpxchg_release(&r->refs, &val, 0);
+
+	do_trace_ref_final_put_cond(ret, r);
+	return ret;
 }
 EXPORT_SYMBOL(refcount_dec_if_one);
 

-- 
2.51.2


