Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52C3ACA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 06:23:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4391C6B0088; Tue, 29 Sep 2026 02:23:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 410996B008A; Tue, 29 Sep 2026 02:23:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FF016B008C; Tue, 29 Sep 2026 02:23:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0103E6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:23:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 65440140360
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 06:23:07 +0000 (UTC)
X-FDA: 85265807214.25.2802D43
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf28.hostedemail.com (Postfix) with ESMTP id A231BC0006
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 06:23:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="oW/UjGUp";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=0n50FDTI;
	spf=pass (imf28.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790662985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GdNEg87cU5+xb7cXOD++DHDpoblLKSzYbAs+d70mx6I=;
	b=sKdFWEGM7J/gC74qpstxX6mCGbvZdQKQqxeJFe0t5kQa6nEzL//g4L23sb3RUvSEKVkR3W
	6nMwEPiJjABfqF9fA9Tjo3t4qqXOZmZbuKAnTR0q4433Tn/CNDeDVjLowicLZn9mciWjrv
	EhbOryZnIxb4LaOncwa7OFvcSjYGo+s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="oW/UjGUp";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=0n50FDTI;
	spf=pass (imf28.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790662985;
	b=aXXJnr1G85/uljFZDS84+eJHajKmgMjwRnXLRU0uB+6KeIkN2G1WmHTVWGJWT9YSgC+Stj
	tlkrtKVvbeWP+LPOSeG0t9+0JtoHSV3OS8etOAv8bjPfzjA+S6Hg2qxMJbuZLyd2CgF5Jt
	MTbAPis5/RZ/CoI+ys/3n4jGfx2Y2Kg=
Date: Tue, 29 Sep 2026 08:23:01 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1790662983;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GdNEg87cU5+xb7cXOD++DHDpoblLKSzYbAs+d70mx6I=;
	b=oW/UjGUpOjgWJ91A2k3l5hJ28xjAqb+bgDSVKLkwXH6v+HoDpWc8AFWheJmmnT+54/7yW8
	nzHQDZtlw7buRVlLI4Mgi4YRmhIk/uJNxOiJTUKwIkQlc8dmpN1UHkTZK+vAg2eJ4wDgMy
	XuMS7PKh9Cc8cLFC9QegobY//v4cn8xRunBRzLg2Co2jFwcuFp6x9C0aze/i+JgDKuN8l0
	ye4JT81945lm8w0uW2u2KWxw0IDX9gUcVv9L0i3RZI+rozNzrTCYGQ9jclxcrGVwZZEuhq
	lp6OArdxbJsJL/0ZUrR758EgNSdr886B4xs/ipV8BYYPXoKM4OJ20Q/2a7ACrQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1790662983;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GdNEg87cU5+xb7cXOD++DHDpoblLKSzYbAs+d70mx6I=;
	b=0n50FDTIC6PS0lvXTfWCuXcRCS1DLyNzKvVH27YlIV+E1TVqPmmkbVl9PvUZx7uf8zP2Gg
	oNXeI4YWHJBudrAA==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Bill Wendling <morbo@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] fortify: add KUnit tests for __counted_by and
 __counted_by_ptr
Message-ID: <20260929074930-f1e4add2-f8ca-43db-85fd-83be0e40c676@linutronix.de>
References: <20260928231737.2092716-1-morbo@google.com>
 <20260929010031.2186255-1-morbo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929010031.2186255-1-morbo@google.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A231BC0006
X-Rspam-User: 
X-Stat-Signature: rc7iwbaonyxai971udk1nbfe4hezdtqt
X-HE-Tag: 1790662985-900208
X-HE-Meta: U2FsdGVkX1/rm88dSzpdQ4F6S2XWuNL6o4doWWgONx0ipKPLxP+yRQ9MvcnV+XBevz9Bnbv8FiP6XXojr0krSwhUJLjN2uAt3+ig45rxGzr3lFhqh3w2snK/7KpWbzj2wIrE7I//RPydPN4VDdp+BBwYTThwkL4OaJ+iQSWq29qLjQcAD0AiTNKjxCmMQM/RZ0Hh4tpsyg4ZdVzmy4jHs5IFPa/Lf7QBdtp8GPh7uuwAb32dSGtzoRTDkcpIX2/FVTxSJD7aJIha7h0y9+r4ti4kY5kEFtdZjA55QjW3D2AIjF/84KJfPuReJjiMgi4+V58DlMMrYzE+kOzL7go123skB47UNbft67YeXH0tNrUICyLyCKflsAQhCJELMKo6zNPZ5y69c2GCgbDblf8Q+iPCFJeFvmJ/EIPMpVYurQ3fYZZy2tiMOBPGb+t+7BJBMAgNlxYFRGyETicz82cF8MLJZUP4DDngJN0Y+p37AgRBAytCanJOozjgVAWBbTu/i95GzF4zJCk8FeUMwYtq/SCDAAsvqo2zhJe/fcCZWdzLTkXPw/TrUGCpmbxDxL2njBj+T2aSa6W9PDi7NagmK4Nw3VnhCjmUQIiUDg8Al+OGy0Bmu+9iBlN8m+g22kiWwYB16ykswFVqT6K9qpJ7V6oR+u4PeITrUHd7J3C8KjIxroUsYvRk+BGLrpY74BcUna1Jv61DF1M0xX6TK4u4SEv3PRgbTQe9EH8USrGW7Z7kGFxcXSR8jB2F/0f6dtSN0nnrSJ4nrC52hqYvQhl86g+rdAbN0+9Ma28kvQ7dvtostwd9YZVQD7TQ9CKWCmE2EIvoMd11kEvcoOYNw1CtRSTZaKIBjhbd9Y/FEHdiyyYcBUyEW55r123+ykBOD804HSN1eXCOCg1GzZBTgkJ9NziRieZPyMmKXt6gkps4vrcGTbJaNdNUJWe+fWtJI5v8yp5vXODiNnjtwN82xwB
 rsgio1Ug
 aKoOyXkejZDBIaDRuYjW9gxOvab99eZLggmollmMQMxDgNyUFSWu6/FtV5zcAKuFgrGlgAqaxjSfQdjpseFCJoIMFw7GhCjYTMe68w0K+uEk/9ncI1LHaZUUYVBI6zo2lIbkaN3nPgXpQ9fQ3AB2jlnWmhuUcI189UrkeGBtTz58fgcmZSWg1uZSOJXmp/LMChg+8c6yd0ZwInZMFo6+jLhnBdf3AiO2OWOdtrX8c688/mjYCj5i+p8WAcA6tfqfZBej8BAF9WrBoHeIhboMpR7sqVljlf+9NL8KhevS3LfG4r0SfiV4gKmepHX7k2kaN1ibMNS4HCfrSNeebpevPZ8QYCzcZSvlPb5voVfu13/SXEOPMaN0k2f3QlqF79hEC3DX53CBNSL4DVmQraIG9orHDjOtG0yTYVEn4rcCD6E4WiTlk0dwduddWCeUviY2Av4vLDClj0F4H2GAtIyS75/9EazFzWWOg7DCELGYj8xi6cLEz+KSgvxVuu+1pBRR2OrVYNwTIZqHDLNsE38NviuQ4lUXM1WwbJAk1cI3QnWt+azqfWj998448Ug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Bill,

this looks much better. Thanks for the rework.

On Tue, Sep 29, 2026 at 01:00:31AM +0000, Bill Wendling wrote:
> The '__counted_by' and '__counted_by_ptr' attributes associate a
> flexible array member or pointer member with a struct field that holds
> its element count. Supporting compilers use these annotations to
> compute dynamic object sizes via '__builtin_dynamic_object_size()' for
> runtime bounds checking with CONFIG_FORTIFY_SOURCE.
> 
> Add KUnit tests ('fortify_test_counted_by_flex' and
> 'fortify_test_counted_by_ptr', guarded by CONFIG_CC_HAS_COUNTED_BY and
> CONFIG_CC_HAS_COUNTED_BY_PTR respectively) to verify that:
> 
>  - '__builtin_dynamic_object_size()' (both types 0 and 1) returns the
>    expected logical byte size for annotated flexible array and pointer
>    members.
>  - Fortified operations ('memset()' and 'memchr()') succeed within the
>    logical bounds and detect out-of-bounds read and write accesses
>    beyond the annotated count.
> 
> Allocate the test buffers with extra physical capacity (2 * size) in
> 'noinline' helpers and hide the returned pointers with
> OPTIMIZER_HIDE_VAR() so allocation-size attributes, physical slab
> bounds, and compiler optimizations do not mask the '__counted_by' and
> '__counted_by_ptr' checks.
> 
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
> v2: Move tests to the 'fortify' KUnit tests. It uses UBSAN, which is
>     what gets triggered by 'counted_by'.

v2 is missing in subject.

> ---
>  lib/tests/fortify_kunit.c | 119 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 119 insertions(+)
> 
> diff --git a/lib/tests/fortify_kunit.c b/lib/tests/fortify_kunit.c
> index 413cdbf3dc0d..2335171f84d8 100644
> --- a/lib/tests/fortify_kunit.c
> +++ b/lib/tests/fortify_kunit.c
> @@ -1011,6 +1011,119 @@ static void fortify_test_kmemdup(struct kunit *test)
>  	kfree(copy);
>  }
>  
> +#ifdef CONFIG_CC_HAS_COUNTED_BY

The ugly ifdeffery can be replaced by IS_ENABLED():

if (!IS_ENABLED(CONFIG_FOO))
	kunit_skip(test, "Not built with CONFIG_FOO=y");

It makes the code cleaner and gives some useful feedback at runtime.

> +struct counted_by_flex_struct {
> +	size_t size;
> +	int array[] __counted_by(size);
> +};
> +
> +/*
> + * Allocate the struct out-of-line with extra physical capacity so that
> + * __alloc_size() and physical slab bounds do not mask the __counted_by()
> + * logical bounds check.
> + */
> +static noinline struct counted_by_flex_struct *
> +alloc_counted_by_flex_struct(struct kunit *test, size_t size)
> +{
> +	struct counted_by_flex_struct *s;
> +
> +	s = kzalloc(sizeof(*s) + 2 * size * sizeof(s->array[0]), GFP_KERNEL);

kunit_kzalloc() to automatically free the allocation again.
struct_size() for the size calculation.

> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, s);
> +
> +	s->size = size;
> +	return s;
> +}
> +
> +static void fortify_test_counted_by_flex(struct kunit *test)
> +{
> +	size_t size = 128;
> +	struct counted_by_flex_struct *s;
> +	size_t elem_bytes = size * sizeof(s->array[0]);
> +
> +	s = alloc_counted_by_flex_struct(test, size);
> +
> +	OPTIMIZER_HIDE_VAR(s);
> +	OPTIMIZER_HIDE_VAR(elem_bytes);
> +
> +	/* __builtin_dynamic_object_size() should return the logical length. */
> +	KUNIT_EXPECT_EQ(test, elem_bytes,
> +			__builtin_dynamic_object_size(s->array, 0));
> +	KUNIT_EXPECT_EQ(test, elem_bytes,
> +			__builtin_dynamic_object_size(s->array, 1));
> +
> +	/* Within-bounds write and read succeed. */
> +	memset(s->array, 0x42, elem_bytes);
> +	KUNIT_EXPECT_EQ(test, fortify_write_overflows, 0);
> +	KUNIT_EXPECT_NOT_NULL(test, memchr(s->array, 0x42, elem_bytes));
> +	KUNIT_EXPECT_EQ(test, fortify_read_overflows, 0);
> +
> +	/* Out-of-bounds write and read past logical size are caught. */
> +	memset(s->array, 0x42, elem_bytes + 1);
> +	KUNIT_EXPECT_EQ(test, fortify_write_overflows, 1);
> +	KUNIT_EXPECT_NULL(test, memchr(s->array, 0x42, elem_bytes + 1));
> +	KUNIT_EXPECT_EQ(test, fortify_read_overflows, 1);
> +
> +	kfree(s);
> +}
> +
> +#ifdef CONFIG_CC_HAS_COUNTED_BY_PTR
> +struct counted_by_ptr_struct {
> +	char *ptr __counted_by_ptr(size);
> +	size_t size;
> +};

In the other structure the arguments where swapped, intentional?

> +
> +/*
> + * Allocate the struct out-of-line with extra physical capacity so that
> + * __alloc_size() and physical slab bounds do not mask the __counted_by_ptr()
> + * logical bounds check.
> + */
> +static noinline struct counted_by_ptr_struct *
> +alloc_counted_by_ptr_struct(struct kunit *test, size_t size)
> +{
> +	struct counted_by_ptr_struct *s;
> +
> +	s = kmalloc_obj(struct counted_by_ptr_struct);

We should probably also get kunit_kmalloc_obj() at some point.

> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, s);
> +
> +	s->size = size;
> +	s->ptr = kzalloc(2 * size, GFP_KERNEL);
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, s->ptr);
> +
> +	return s;
> +}
> +
> +static void fortify_test_counted_by_ptr(struct kunit *test)
> +{
> +	size_t size = 128;
> +	struct counted_by_ptr_struct *s;
> +
> +	s = alloc_counted_by_ptr_struct(test, size);
> +
> +	OPTIMIZER_HIDE_VAR(s);
> +	OPTIMIZER_HIDE_VAR(size);
> +
> +	/* __builtin_dynamic_object_size() should return the logical length. */
> +	KUNIT_EXPECT_EQ(test, size, __builtin_dynamic_object_size(s->ptr, 0));
> +	KUNIT_EXPECT_EQ(test, size, __builtin_dynamic_object_size(s->ptr, 1));

Is this builtin guaranteed to be available?
We have a wrapper KUNIT_EXPECT_BDOS() above.

> +
> +	/* Within-bounds write and read succeed. */
> +	memset(s->ptr, 0x42, size);
> +	KUNIT_EXPECT_EQ(test, fortify_write_overflows, 0);
> +	KUNIT_EXPECT_NOT_NULL(test, memchr(s->ptr, 0x42, size));
> +	KUNIT_EXPECT_EQ(test, fortify_read_overflows, 0);
> +
> +	/* Out-of-bounds write and read past logical size are caught. */
> +	memset(s->ptr, 0x42, size + 1);
> +	KUNIT_EXPECT_EQ(test, fortify_write_overflows, 1);
> +	KUNIT_EXPECT_NULL(test, memchr(s->ptr, 0x42, size + 1));
> +	KUNIT_EXPECT_EQ(test, fortify_read_overflows, 1);
> +
> +	kfree(s->ptr);
> +	kfree(s);
> +}
> +#endif /* CONFIG_CC_HAS_COUNTED_BY_PTR */
> +#endif /* CONFIG_CC_HAS_COUNTED_BY */
> +
>  static int fortify_test_init(struct kunit *test)
>  {
>  	if (!IS_ENABLED(CONFIG_FORTIFY_SOURCE))
> @@ -1054,6 +1167,12 @@ static struct kunit_case fortify_test_cases[] = {
>  	KUNIT_CASE(fortify_test_memchr_inv),
>  	KUNIT_CASE(fortify_test_memcmp),
>  	KUNIT_CASE(fortify_test_kmemdup),
> +#ifdef CONFIG_CC_HAS_COUNTED_BY
> +	KUNIT_CASE(fortify_test_counted_by_flex),
> +#ifdef CONFIG_CC_HAS_COUNTED_BY_PTR

The nesting of these conditionals looks unnecessary.

> +	KUNIT_CASE(fortify_test_counted_by_ptr),
> +#endif /* CONFIG_CC_HAS_COUNTED_BY_PTR */
> +#endif /* CONFIG_CC_HAS_COUNTED_BY */
>  	{}
>  };
>  
> -- 
> 2.56.0.rc1.315.gc6ed9934b7-goog
> 

