Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A7CECD6E5D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 10:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3688A6B0005; Fri,  5 Jun 2026 06:47:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33F276B0088; Fri,  5 Jun 2026 06:47:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27BFD6B008A; Fri,  5 Jun 2026 06:47:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 176036B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 06:47:03 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A0ACA1C215A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 10:47:02 +0000 (UTC)
X-FDA: 84845531484.25.3440A2D
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf06.hostedemail.com (Postfix) with ESMTP id CDE58180006
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 10:47:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=c9a5EEXY;
	spf=pass (imf06.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780656421;
	b=0n8fkrwVkzK8/PWqWJLYQ+GZXzwbFS44YIjmqEbr6mQ1bKnx4Vhd4XihX9LYAtpVJ8Ahsf
	owLS5s99M2+9+ain6IB8RIA49/t/8YFbEMtz4HHftPc7l9vp6IFdk9bkpWKFgy+3cVZOaP
	4FyEf7SwsLMp46qtHpDrdlHIlkI8P4Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=c9a5EEXY;
	spf=pass (imf06.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780656421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+zcuQvJC3/7xOL+Yo+LO6my0PF5BMauyh6lq359XSB0=;
	b=uvtdwGJrAl2ATtvad7hMAzGzAi0NR5OcdKrnISWGSnn5XXgdBX5oM09PvIam/9QQXthuvR
	xHukl/lzvzVgTNPdKz9irvdXS4YqegUmJfiN0pJ337pAK7n22XeQZNBqQBP0FmkKfPNu1h
	GA3KPvZpVcSmDUYduq/JgRuSK8M6DoY=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 27DDED11F7;
	Fri, 05 Jun 2026 10:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1780656419;
	bh=+zcuQvJC3/7xOL+Yo+LO6my0PF5BMauyh6lq359XSB0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=c9a5EEXYxNTUdd/FaPlFU+POGZlR683okhiAIY96m/VfrQD72YA/O2C15wxgYmiVd
	 9oKNkNWf1oklNIzv9f98Tchmgh5WtP/7y4h8L66m0Jg9MTFHyF6EQYnSfgpjYIlNVm
	 Z/mAdNdpLI0ZXQiEpKeNuEth9WAz/j7Nh7yvYqBA=
Date: Fri, 5 Jun 2026 10:46:55 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Miguel Ojeda <ojeda@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Marco Elver <elver@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v5 3/4] cleanup: Annotate guard constructors with nonnull
Message-ID: <aiKpH3cLBEj3TF2Q@shell.ilvokhin.com>
References: <cover.1780064327.git.d@ilvokhin.com>
 <85fee12eec20abfcf711443518e8f0caec982a86.1780064327.git.d@ilvokhin.com>
 <aiJi0WcYE8FZt-jO@stanley.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiJi0WcYE8FZt-jO@stanley.mountain>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CDE58180006
X-Rspam-User: 
X-Stat-Signature: mtp849jfzhdiufeabt45fsef9ad6rz5e
X-HE-Tag: 1780656420-48054
X-HE-Meta: U2FsdGVkX1+WOoEmM4ZR9mbtl1txz9P6qfDQGY9yUvXB9Pvj0idXTF6bfZ7EmR6XN59R94zTvB7LfyionfUcZAFfx965BByJ8eso8/y2ddkLRpIkujkGNAnSHdbVrG3UXk7PP6B3PdsPN8UIHgjbBVONOyZQQQ2mV7B4piRVj0bbBGoLNDWJMBfF5lW2/uInwokB8fCweNFxnv23D/KKUsSR9xuCBGIK+JOcKCvqWZPqqGt3z61Rq8rG5gWBogxT94H2LlCAp+FIFunrKu3ZsEgdElPiRgoDvVal1PWdw5Tw5WJuahNVpMgF/dbI0c7tqdB5j7mBA1iuT5JkE0cQ3A3Sj6Bc2WO2UM0SXHmcpgwHKPZb1hzpwNmwxXaFwKj1t/R2UdeuTYOqsN4y9AituHrgYilWXozvm8l0ihqq2dCm5CyB0N7lgeWjJ82l/43uA1SAj2QnqimWs7FAPNwcBlPnyJu8YpGnHvuC3WgekegNLOjYmbQXFaK/tnWOmcSoYNl697zM16vsw2p9IsBCDskIyeIKhi5a0tMOYDyex74aElzd3Gc1gxm1Y4A9B1Qp8O+b29wE878NBMxqfjIppqfpW+jmzApFWCGMExiNvejlaOSh13/jpvs4md5EO0wxvzTUnh6LBdL/qMlhhq59dSbwOCAZW4VyH+ioSvTJ8lcpzFya3WH87ZE6unVYK3Yv18nyP3/wTLViNijEUrPC3KhcJw7iFLO1K6Gm9NKsXZHeSmzKCbUSTj3O99bA1UaChfu1RNZZm9tyWsTnNcGMjbk+/HwzaBB6m8B1HnvXIbe4ebYYm6iScQtFbCvQd8qWTbDoYqofzj19FAW7GSJ2+NohXRxP9oDLliXdx0N55uGpRuYHd5EZSs2Mh3mY7py1I4tveBdWAQYF9dBLhnBp7GVF20A2t9agRgravNVJL2WnhNefJRD0aT3MfYFRlUVM7VQxjS92v1WPDCBMQPF
 w2ntTTKR
 G3lj6JWWr1GeWxpvChOrg2qiA+YeChGsiwB3pEaAbHsCL5+4qI5+Z7FjMjT/jXu1i8MDG48uLYdOj5+2uQ1Z3ga+jTm4tArp32TavsudnPIH5+QDd9VNQ1Q4f7QheMkigPfr+BO9WgUlGd1tTclqxRBByqc36kNWyfGOZ7Bo+2RRymyKzI56bobVUnVc61XKhLIHjVq13pUSLEltOTvvwJNxpEKxpf9ORJuhHqCF01jJImWLIOvwt8NGCtAnq8jtVzQp/tDv1b7A/yiiZI1npSR+N16kIkZubF+Ngl3snDDghaAYzoZ7BxHrdrvzPKzLSPfRPm5r2JWZPilMqOAFl8NDwag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 05, 2026 at 08:46:57AM +0300, Dan Carpenter wrote:
> On Tue, Jun 02, 2026 at 07:12:52AM +0000, Dmitry Ilvokhin wrote:
> > Add __nonnull_args() to unconditional guard constructors so the compiler
> > warns when NULL is statically known to be passed:
> > 
> > - DEFINE_GUARD(): re-declare the constructor with __nonnull_args().
> > - __DEFINE_LOCK_GUARD_1(): annotate the constructor directly.
> > 
> > DEFINE_LOCK_GUARD_0() needs no annotation: its constructor takes no
> > pointer arguments (.lock is hardcoded to (void *)1).
> > 
> > Define the __nonnull_args() macro in compiler_attributes.h, following
> > the existing convention for attribute wrappers. Deliberately not named
> > '__nonnull', to avoid clashing with glibc's __nonnull() when kernel and
> > userspace headers are combined (User Mode Linux for example).
> > 
> > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> > ---
> > Miguel, I dropped your Acked-by due to the rename. Went with
> > __nonnull_args() (over __knonnull()). Happy to restore your tag if that
> > spelling works for you.
> > 
> 
> Sparse doesn't like an empty __nonnull_args() at all.
> 
> ./include/linux/spinlock.h:608:1: error: an expression is expected before ')'
> ./include/linux/spinlock.h:619:1: error: an expression is expected before ')'
> ./include/linux/spinlock.h:631:1: error: an expression is expected before ')'
> 
> Shouldn't we specify the arguments which are non-NULL?
> __nonnull_args(1)?

Thanks for the report, Dan.

That is interesting, it seems sparse trips over the empty-parens form
the guard macro expands to, nonnull(), but is fine with
__attribute__((nonnull)) without explicit arguments, that a few places
in-tree already use. GCC and clang accept both, so this probably
deserves a fix in sparse too.

Meanwhile, spelling the argument out explicitly is a simple and
reasonable fix (and arguably clearer). Patch below.

From 50f7e7eaad1d33773cee9a278625fdb4b451f53b Mon Sep 17 00:00:00 2001
From: Dmitry Ilvokhin <d@ilvokhin.com>
Date: Fri, 5 Jun 2026 03:06:22 -0700
Subject: [PATCH] cleanup: Specify nonnull argument index

The guard constructors were annotated with an empty __nonnull_args(),
relying on __nonnull__() marking every pointer parameter as non-NULL.
Sparse cannot parse the empty argument list.

Both constructors take the lock pointer as their first parameter, so
specify the index explicitly: __nonnull_args(1).

Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/all/aiJi0WcYE8FZt-jO@stanley.mountain/
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 include/linux/cleanup.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/cleanup.h b/include/linux/cleanup.h
index 65416938e318..b1b5698cbf1b 100644
--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -397,7 +397,7 @@ static __maybe_unused const bool class_##_name##_is_conditional = _is_cond
 	__DEFINE_GUARD_LOCK_PTR(_name, _T)
 
 #define DEFINE_GUARD(_name, _type, _lock, _unlock) \
-	static __always_inline __nonnull_args() _type class_##_name##_constructor(_type _T); \
+	static __always_inline __nonnull_args(1) _type class_##_name##_constructor(_type _T); \
 	DEFINE_CLASS(_name, _type, _unlock, ({ _lock; _T; }), _type _T); \
 	DEFINE_CLASS_IS_GUARD(_name)
 
@@ -498,7 +498,7 @@ static __always_inline void class_##_name##_destructor(class_##_name##_t *_T) \
 __DEFINE_GUARD_LOCK_PTR(_name, &_T->lock)
 
 #define __DEFINE_LOCK_GUARD_1(_name, _type, ...)			\
-static __always_inline __nonnull_args()					\
+static __always_inline __nonnull_args(1)				\
 class_##_name##_t class_##_name##_constructor(_type *l)			\
 	__no_context_analysis						\
 {									\
-- 
2.53.0-Meta


