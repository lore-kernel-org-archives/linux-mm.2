Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F93FC87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 09:38:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDFBE6B0088; Fri,  1 Aug 2025 05:38:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C694D6B008A; Fri,  1 Aug 2025 05:38:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA63A6B008C; Fri,  1 Aug 2025 05:38:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A7B696B0088
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 05:38:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4E82E81C06
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 09:38:20 +0000 (UTC)
X-FDA: 83727687960.30.2516E7A
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf03.hostedemail.com (Postfix) with ESMTP id 82F4C2000D
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 09:38:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=hgmTsZgP;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=x6W3tCG1;
	spf=pass (imf03.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754041098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tGSv6RdaV6X5lnOcQToZWXgwKNlnA4P6z1e4N4UFCfU=;
	b=AeBn93oRjNIpRGrMYL8GWKdVZbyrcxRnQY0oSIJdaMfTe9nRNBS7uX4LrxiUQ8EOfRZrh6
	bNvXhdRPd/0lD5Iv2T25YF27DbBUxIZ5vl4wa0XVPR4XYtwi2QmyaobHgjIRDKXwjsmT5c
	8wPsY4rix3l+VuNc8jet6BZdCNWJhw0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754041098; a=rsa-sha256;
	cv=none;
	b=X3Q+7mkvIhjTT+OVjazLowtew6UpwFRBHjZFQwSTQeWMw4u/E4METbtt6jtf7UcdohbrCJ
	q8cY/JRxwp/01A+o/LSJ+3qJaZ0AfpurrCWSjpPx/v4bx3Hl7sYiPGGj1o1zq6//Z1rD2V
	GkgEKuqGVcVjOnl2u/lMZ3vAaF1hclM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=hgmTsZgP;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=x6W3tCG1;
	spf=pass (imf03.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
Date: Fri, 1 Aug 2025 11:38:15 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1754041096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tGSv6RdaV6X5lnOcQToZWXgwKNlnA4P6z1e4N4UFCfU=;
	b=hgmTsZgPXSrteeoFmNEkplfEl6qJJxsVIWk9IpsP/fyxbExCMaXOmcssOy83GdjGNauUJx
	JiREhtCbsaGWRec/gmxI0KB3Q+4Mugbn+uZYZHJPGaPw3MOGmnLrLR+zO5i1iP7uAym6oh
	ElQiPJBGm46Mw63gvFqtTOVSYkGtvu7OAfUWg3LBstz/Yicry3RM7fuW2a2OpM9n5qKedU
	EifrCwrLAgny0gQO8hvCA11cgsg6u8AQVzp2Er4DeumqMjwqd7QQEWZUT+xDn1zffZSQEi
	TVJ+dmZaGP4KO5Gg5NzaodOJf9FMa38aGKu40DGMrqCUDJA8PEmFw1nGOUYESQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1754041096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tGSv6RdaV6X5lnOcQToZWXgwKNlnA4P6z1e4N4UFCfU=;
	b=x6W3tCG1WSZ31fZLQIPnCK6FNhiBj41QTW8K6f2PAoc7On8q9t8P0NBJHL9ps7hIybF2+e
	pHN/7/wk5EIQz1BQ==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com, 
	dvyukov@google.com, vincenzo.frascino@arm.com, akpm@linux-foundation.org, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] kasan: disable kasan_strings() kunit test when
 CONFIG_FORTIFY_SOURCE enabled
Message-ID: <20250801113228-5a2487e0-0d90-4828-88c7-be2e3c23ad3b@linutronix.de>
References: <20250801092805.2602490-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250801092805.2602490-1-yeoreum.yun@arm.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 82F4C2000D
X-Stat-Signature: rsj5peaga75rime78m388jzstcr77x8n
X-Rspam-User: 
X-HE-Tag: 1754041098-241341
X-HE-Meta: U2FsdGVkX19Zes8rSsB9bE5zeMbyNSsURXPFXt3Z9eJcgqoynfKNwUfOr9cucrtEwD0Y0pEzFzaEZqGhZqdTFS9QSKlnvX2azWtviwCcozVpFPVgY//ZqM9PoGJC+R8JnY2TmyEHcZOdvxIElnR3LeuHkrJmmF7Tlpg7vk2vy1Pg7Wc7FaHbPowWImnK7ANZue86iV3pFk+buRH75RUg1GxPXyVSCe8EATtV85iRIRWQ/h6UGbUyCgZ5Tkz0swVSnM9JYdf78a2I1x3Ig+YhaEsJs6LxP64p3kvG/fnP0786wN7aQCOJQBFzJItrxmBT8oqaKyxfoZTKETeIxZCF3dEqeBeRR5V9SYnMuX836gz0QE1fxzqB+pBXpOjkhMPM64BJx65ebQnIbaNBbxGcbSdiVmyE41LUiLhHAeDHPkL0zu8Tp5D9PraMADbgU6Rbv7SQvNmYBjgbhikQeriAWOqgnwagkAy8DxF5ca7t9vFGTPk8T4zYQt+Z2ioaOBnw7b6SUuZWXeqt1a4W3FrxDq9ZdEnPTHN33qehofWERSU7g+IrezkpMRPKEW3ramip/4reSR98qmEOEYKOtaNwcjckvX7inWQZmOUwQCB5EHhvpiLjYmii/6HSVyDRRajWYu//udSQxT5JzNEMp4EQ+HBU3jCQVFFXNiH+BiWaR+1XMoP+dSS/Bbf+b6HMw+kS/m8S9SKWu/7yDAtNKnS+8kg+x1Tt2Ji2fZFBzcYZEyuon802Y2ipfsy10VtJ0C2+QzOQWncFN1WB06FAOcp5gRrz2j2bEGMhwuMAKagn+yK9i3qv0gCXlKiXIF9GVBqLY9GC9IR75KgnsWVm4TNHmFPFfuTiRgbRZ0knn/WLybfC5T7wkh8k8aLS2fd4XRo0iMQ+IrP3F/0Y9/626iYtuaqgCJ867h2/Wy6ELM39ETiSwrWAeTFdPUFfJQOZcZzET7kqjO/h5ZHeX93iuKj
 l6MA2M/u
 tJuayJ3S3cgr9BWsRGpompfbMtG38aeHKK5PbRSWWsWU2if2tzOxdtIqqZNYOmnbdR3jzXL13RxO73OCWEq6QaFkcD6YiOnjeiRLuUtroB7eGXm1ZNWnni8D7izDc44ij/QFPa1Z8VvBJXR412ZsZQuDZ0af0LmOPTw8UMZ7+KnGjzKkANYLALXSCV1W/xu0Ik4yO3egvFAonaeUtt283LlPCWHfhveGhpCLK8vIbX7oBSvhLiAiK3F3AtpSPkk4bTCV9UNkeP6PyZV1IpCXeGJL/4Q4nMO2s1gQmzJ/ZuzzR3yrmvYgrP+7ck5AhQeC4nv9ouZmwvNGAOt90zbfVLtpsLKkY7Hwm5U+hm8jloI1cfCDvU9kn0rec+SdyPdi+FpR3mCzC7o11Jjg+XhxFWwzYOLSnmUOi0ZNoPd6cBCIGULFEWgjI2GlrPaGwN4hcSUKPQQS+RmwgMVh0FxKzHDtzkKfWEL/7BFgUvj3Xoi+Gcg6BIZoqB0tzeU34PTrHUkPRRVB4v2JRT4iMwkUzkVBy1XXPz8ebraZD+DJ+V/0DtJWZL0+SnVHo0zOSjlGvcwvuB1li+fLn8dTvXRSlr1Eh1Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 01, 2025 at 10:28:05AM +0100, Yeoreum Yun wrote:
> When CONFIG_FORTIFY_SOURCE is enabled, invalid access from source
> triggers __fortify_panic() which kills running task.
> 
> This makes failured of kasan_strings() kunit testcase since the
> kunit-try-cacth kthread running kasan_string() dies before checking the
> fault.

"makes failured" sounds wrong. Maybe this?

"This interferes with kasan_strings(), as CONFIG_FORTIFY_SOURCE will trigger
and kill the test before KASAN can react."

> To address this, add define for __NO_FORTIFY for kasan kunit test.

"To address this" is superfluous. Maybe this?
"Disable CONFIG_FORTIFY_SOURCE through __NO_FORTIFY for the kasan kunit test to
remove the interference."

> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---

Missing link and changelog to v1.

>  mm/kasan/Makefile | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/kasan/Makefile b/mm/kasan/Makefile
> index dd93ae8a6beb..b70d76c167ca 100644
> --- a/mm/kasan/Makefile
> +++ b/mm/kasan/Makefile
> @@ -44,6 +44,10 @@ ifndef CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX
>  CFLAGS_KASAN_TEST += -fno-builtin
>  endif
> 
> +ifdef CONFIG_FORTIFY_SOURCE
> +CFLAGS_KASAN_TEST += -D__NO_FORTIFY
> +endif

The ifdef is unnecessary. If CONFIG_FORITY_SOURCE is not enabled, the define
will be a no-op. This also matches other uses of __NO_FORTIFY.

> +
>  CFLAGS_REMOVE_kasan_test_c.o += $(call cc-option, -Wvla-larger-than=1)
>  CFLAGS_kasan_test_c.o := $(CFLAGS_KASAN_TEST)
>  RUSTFLAGS_kasan_test_rust.o := $(RUSTFLAGS_KASAN)
> --
> LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}
> 

