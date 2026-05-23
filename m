Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DF30CD4F54
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 08:49:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83DC36B0092; Sat, 23 May 2026 04:49:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EEFC6B0095; Sat, 23 May 2026 04:49:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 704A26B0096; Sat, 23 May 2026 04:49:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5CC8D6B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 04:49:12 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EFA69A072E
	for <linux-mm@kvack.org>; Sat, 23 May 2026 08:49:11 +0000 (UTC)
X-FDA: 84798060102.04.6EFB444
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf31.hostedemail.com (Postfix) with ESMTP id 95A0520003
	for <linux-mm@kvack.org>; Sat, 23 May 2026 08:49:09 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=BEyJ5yKD;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf31.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779526150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OIFL42ts8Sf4xjq6jPC8EPpfJjsyni5NkXr7Ls4uWvM=;
	b=6JJpORNzgIbdFtNTHqA7tAJodxGdnMHOkHUxZEdZy/1pmZikZ5a0+/7jljw/6mI3o6g5K1
	VR8XvAn+phV1usC4h5puGDFXdGEED4frH+cjJ5+JvJX3Lw/FnNVbsAfbrmNbBlCbLyEgjq
	RYbSrXk0EoxRTTKO3IMGMgdRHYIJi8M=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=BEyJ5yKD;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf31.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779526150; a=rsa-sha256;
	cv=none;
	b=BwiHlNweRSV4wC3uKWzAvM260k6iuTo92R2SkEQU60KexeZ6WdspLrgIyQ867k5WExh/7x
	KkwKMrzerCve7p0IZEL09vdL4zPb8NgdE5NfwwIMBdHfauvHNQr6kAHmecdZ1opSr3yjsg
	TM1cNAhHgdnxS9VYhOXvisqnsvVXo50=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OIFL42ts8Sf4xjq6jPC8EPpfJjsyni5NkXr7Ls4uWvM=; b=BEyJ5yKDAtQEBSEkgEHomhh/t6
	8g/FUOs39ZYNeN1t/E6qqVQSekVBzPRQrN+8Nb0c5u+ehc2y3QQ1KNx6iMUxzPQWAfonHx02tZjvk
	u1JWmIfYcqbfZxWad7pbTGiZ7ZXYIXjmrBpYkXCZLw/V4QwRWC2d8l/2srSHhZzp4YydCkzRnVpEd
	14Q2RloJ6QyBTs8GioqHDZvsC5LPY+E27c4N4bOvz77qsKIIO/Xf+Ge5xRNJMHXTHWURUM513l0MC
	hFqvZ2eibgsQjDRiihKkgY8hqYGKhH52CYHwsJZJkmRYhLlzuSBJqN3xeQzMgGfQJ3Ee4aQN0EgkZ
	GG52gQiQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wQi2X-00000006BfH-44qK;
	Sat, 23 May 2026 08:49:02 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 3DCB6300462; Sat, 23 May 2026 10:49:01 +0200 (CEST)
Date: Sat, 23 May 2026 10:49:01 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Miguel Ojeda <ojeda@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Marco Elver <elver@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v4 3/4] cleanup: Annotate guard constructors with
 __nonnull()
Message-ID: <20260523084901.GF3102624@noisy.programming.kicks-ass.net>
References: <cover.1779286416.git.d@ilvokhin.com>
 <0ab092c41e18e6a7db703547d87e6b632d6f79b2.1779286416.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ab092c41e18e6a7db703547d87e6b632d6f79b2.1779286416.git.d@ilvokhin.com>
X-Stat-Signature: 6ddbxa57qsxx8e5ehxhf97fxgny3spmo
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 95A0520003
X-Rspam-User: 
X-HE-Tag: 1779526149-64965
X-HE-Meta: U2FsdGVkX1+ZxaYBawB+X/PZAuxkO6n3+uucSbl5iw77Y9KA8dcXwKgH5WLT7FtBZec0LIT9jdl8paTJ1SykV6SRL4STjn9JD5ruJm4WKdgrzYLElwy3Y8ypKP+aVlis2mPFiubpxiIUYOIkLU044V/41v0BRoVK3r1UJokCZ7yB26S7TBNWSGY/JREpesidPQ9mRtZPLgP1mFmWVttBc41O8FW3eiAicoVvuUdOHR4Y2msal7YbYVAvnFRC2OhubeUplauZBFjfx89fHMu2SPTd6pw6o2scipnCZc/wHUqsAMiER/mXlhDfClQ7RivOWPLwDd8MyPrSxbqqDNXHKQBa9bENpenijdUGu1S5mxJ7GzjcUCygV1ytPdceo79f7OXCwgYpsO8dy32oBh9D2AfoNZcbiiP7wSLXCNsr4KadmzmozP0YbKqbgwEmfvfdPIdByq5sWi/OZu4KDdXdQbxt6e+5BaIpQh2vzbA55eht9tam5pw1eR64/nu/3rIrX9oClpdelpoLEDS27havUzE0oxlRSIbAx7b6VjRHsu13IwWY0SEddp1Bj1DxEP1ZCgAq6wGPFkqtXKC59ImWbd0oPzilYrFOpyfD1pmeQgfYT4UoM2jhVpOEuBwuMcyzCq/maU/8Uj+35tTbxXf32EuI9g4p7G4g+4i+ztIxmILRW60JQ9CXmrauzSzQzdgOlYfen+ADqOgo9sVGTWCi2E6VYOKCNBWNR9/eLKevErDuHUH/lRzxup1XsKFyMbogkAm9+HPqgRxaYnSWN2ZpIpzL9JlZt0nbWd7KjvDXzONjfISu+Ftr12QOUErGh1+j0prO0D6jFlU2mm6v2DRHVV1IDzz6ash40oW914e33TdELOSAHTrFUcHcpg/OPq94gOiERiRw32BDTj7G+tPOH993E1Hv7swf62D2DjbEXvlvw2D2jsw/4RgibD9pK9qWVOgWTxKm8xrVh12P7/s
 jOLlf9DY
 J9NK8fS4qh3+kEDBP623Gl9H+7bmli++l+LoqDZU/uI6W44pElNDmTWwPFO+3Z5rENW4Bi5VHzJGrb2mbq+bX/YOUNL9ocDQmM83sEauW55WDoyhcOgwa1a3+3uAttXLsQmGZS2QknVhgZnIBUK8tEuIsFwNnMwIDanOMMjdvD5xS6vOhOIl6DUJeKXML5qZiXNR5Cs0FoImplFQVINgvZVfLktOFD2s1TuTa64lGr3r5oY78oUl2+oU316s/3rofrTtUGFSlHchM9q/DaESmFP2C4qaVkjNZS+K9+PABSzg619rLcW7n2YzW/WI4G+qajJg0ijgRPsrRoJNgJbTLGP1NrLafSk5O2H01qtP3OzxMLRzRso8OVD8KofOWJ5lc/1TWbUhL2a8QqqljNy6SCW1ps6L4nnOWp2bCRHBptQzgVJUHQ/FrdeBMvnnpQKRZHS32OznJp9xkQ2Eo+hq4akAUAbubIvrgpBON
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 07:18:03AM +0000, Dmitry Ilvokhin wrote:
> Add __nonnull() to unconditional guard constructors so the compiler
> warns when NULL is statically known to be passed:
> 
> - DEFINE_GUARD(): re-declare the constructor with __nonnull().
> - __DEFINE_LOCK_GUARD_1(): annotate the constructor directly.
> 
> DEFINE_LOCK_GUARD_0() needs no annotation: its constructor takes no
> pointer arguments (.lock is hardcoded to (void *)1).
> 
> Define the __nonnull() macro in compiler_attributes.h, following the
> existing convention for attribute wrappers.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> Acked-by: Miguel Ojeda <ojeda@kernel.org>

The build robot found something to hate in this one. I think you're on
Cc there. It looks to me like clang-23 is confused somehow, but who
knows.

> ---
>  include/linux/cleanup.h             | 4 +++-
>  include/linux/compiler_attributes.h | 6 ++++++
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/cleanup.h b/include/linux/cleanup.h
> index ea95ca4bc11c..8f8d588b5595 100644
> --- a/include/linux/cleanup.h
> +++ b/include/linux/cleanup.h
> @@ -397,6 +397,7 @@ static __maybe_unused const bool class_##_name##_is_conditional = _is_cond
>  	__DEFINE_GUARD_LOCK_PTR(_name, _T)
>  
>  #define DEFINE_GUARD(_name, _type, _lock, _unlock) \
> +	static __always_inline __nonnull() _type class_##_name##_constructor(_type _T); \
>  	DEFINE_CLASS(_name, _type, if (_T) { _unlock; }, ({ _lock; _T; }), _type _T); \
>  	DEFINE_CLASS_IS_GUARD(_name)
>  
> @@ -497,7 +498,8 @@ static __always_inline void class_##_name##_destructor(class_##_name##_t *_T) \
>  __DEFINE_GUARD_LOCK_PTR(_name, &_T->lock)
>  
>  #define __DEFINE_LOCK_GUARD_1(_name, _type, ...)			\
> -static __always_inline class_##_name##_t class_##_name##_constructor(_type *l) \
> +static __always_inline __nonnull()					\
> +class_##_name##_t class_##_name##_constructor(_type *l)			\
>  	__no_context_analysis						\
>  {									\
>  	class_##_name##_t _t = { .lock = l }, *_T = &_t;		\
> diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
> index c16d4199bf92..10a1410eb3e2 100644
> --- a/include/linux/compiler_attributes.h
> +++ b/include/linux/compiler_attributes.h
> @@ -230,6 +230,12 @@
>   */
>  #define   noinline                      __attribute__((__noinline__))
>  
> +/*
> + *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Attributes.html#index-nonnull
> + * clang: https://clang.llvm.org/docs/AttributeReference.html#nonnull
> + */
> +#define __nonnull(x...)			__attribute__((__nonnull__(x)))
> +
>  /*
>   * Optional: only supported since gcc >= 8
>   * Optional: not supported by clang
> -- 
> 2.53.0-Meta
> 

