Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C7E5606A682
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 16:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W+Q/DLky
Received: by kanga.kvack.org (Postfix)
	id 214016B07C5; Tue, 24 Nov 2026 11:53:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C4E56B07C7; Tue, 24 Nov 2026 11:53:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B3C76B07C8; Tue, 24 Nov 2026 11:53:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD2746B07C5
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:53:53 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2775C1C4230
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:53:53 +0000 (UTC)
X-FDA: 85470609546.21.DADC2D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 745F2C000A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:53:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="W+Q/DLky";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795539231;
	b=QSZMsjem+SyuutPUSWPZHt9mYx3ELzY/kLJ4F66DBIrOnY4LFcaw9ahJVIcao99REhJbUR
	UzB5xNxvDITj58kcC+WtboawA128+V36r/Xqhj1ca1OjibOYdYp3jQjFCMVH+dUW7kQL6s
	ozwAXNKYGayCC/ZuYkDxZNoO+yaZYl8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795539231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TGS0p3l5aUvQSsnJUtozcXV+gafJYP1vaRPZ8q+1yVs=;
	b=QP1IDokFHBcnCsUdKbYeAMCyLmsHVhekqf+KiZar9BMTl7EBx2cumwHGSU9v9nIqecKRpI
	wTMqjMB1VpWySv8l9+xAAyA4pkMbuZpzIBjYI/lvly5wg6TjysIUFJ7SW7p89NW+6sYH2+
	ecN/oOJtd2XS1FaHxVNdFfV/b/cqdCE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="W+Q/DLky";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9808F44D5C;
	Tue, 24 Nov 2026 16:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D721F000EB;
	Tue, 24 Nov 2026 16:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795539230;
	bh=TGS0p3l5aUvQSsnJUtozcXV+gafJYP1vaRPZ8q+1yVs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W+Q/DLkygKoWveglsObwnQuDQHgHhVTLQBYYieM2oxOIAYtQwAL3WEOF2DLCZL2rS
	 SLsGk1yYj0c5ZhKJxzpeyjJzcVtuG2Se1RWtmT4trrESXCTrIN8m7qgE0VbXPKsRE4
	 mdcWRycOFo5nBnfBLfr9yrKwu1fySVR64C0gXTQ28Y4kaOOAsfR/hzNg3tWVrgnBTR
	 l019oR6l78Ai6rXpy1paM+/c2kolkIcYvlIhh8nQz0ome6zV/4CRCET1tE2TVg2AFU
	 6l+uALjhvT1IN939gxT23Xpl+bUli61HeqMiWL/7rK/0tONu2P735MhETaICOWf/ir
	 wcG9si/y7Wosw==
Date: Tue, 24 Nov 2026 16:53:48 +0000
From: Harry Yoo <harry@kernel.org>
To: arina.kharlamova@mbzuai.ac.ae
Cc: Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	workflows@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] slab: fix the kernel-doc of kmalloc_flex() on counter
 overflowy
Message-ID: <awWxR-AsjwmkLE1Z@thinkstation>
References: <20261124-slab-doc-v1-1-9f14dfce47c8@mbzuai.ac.ae>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124-slab-doc-v1-1-9f14dfce47c8@mbzuai.ac.ae>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 8im4owxa67wg3cfngmz53tpqezzxzbna
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 745F2C000A
X-Rspam-User:
X-HE-Tag: 1795539231-902348
X-HE-Meta: U2FsdGVkX1/Ul4zP28bi48VMGW0GGKST3SunjoNJnvXjqi7FnXgHH/oAxbeSwgelBgi3rk34DPNvmvyw/TrYem+BPcCqFaLVwPXsBLjM+Ya8o2kXP6Ur9FLnGB4miF6c4Vf2OE4/XBo//PwOjjaMJJL96ttSxxgmrEK+RplibLLh+/yh6Zp9cSTmiOdz6Mgas60BHZIqJX0LFtpqbnuW7810pyeEZlb7NU5vwms5YP9VNApvxp+lJZQBZ7phUjezfxCjxh+IcG//xMWufEt3qb7IzahRifxTsnlMUPV0ZgcmmUTv9FJbDy5IA/xFWgDcShvBuFOuKnP/wwQluP/e9sCSgmn2B6rFErQqngWvXZ1V5pOPZ+iyRVD6eic96dDg8E2omgxwnBc4pcYMkLo2G8FfUth5/TL4UcwniLdLqQ4CikYbH8Fi2XNjJ/fGU508XO6f2cQxTednihm+y7WJ0hnrS+Coumib5uDOGKdcF5e2kIBrEMV6wC+Wl0IDst8U9pBAP85oeqvkNJDRZg4xMz3BrgpXo+pGI6gmLwEz/kK49Janl45pgmx53jsxNzbTixssNAkOwyXZqOYyctruS7UuOiDT/MsdI5OdQwjo/vmeaMw9wCcE6Ikm1+mbdAbgzvAox8OKBjJGFRJ4ZD5yyvupEiHs/twEJqcMBevdqq5FhpLp6SO2VFRgc4q+eD2sl4cpTizW7IFHT1VsaehF2RfUgtFRnNwuftqM/yJHmxwwTmV74syTYDapZB+iAsGnInVLXWqPPfYoDrPDGk1x2BE3NrsAbb9h4X6RiKMT68pLM7SIheAbxA2nDUY3MVp0PBmEqlSvitQGLTebdLMWszRj9ecVGFj4qH+UM5wg4d7/fOVI6Z9XSKl9oawb6lQi2F0uvrS8ZAPatPktSiwtTYBmSdT1ionV1CY1wzr8cPF4Rhj8sOstQBOGREYK+NzNrh3ORwboEzGQaywU6cn
 QtvuZLau
 7BNr9L6vW+QYImmRqxushMsaHFzxhGdXXMW4UzpPbyBfdetQqdmA4waY3/KzguoNoHEoolZ8WQnhcDwdQuT34zcEvQrXnCWVu9Ih4btilB6NcD/shMHVuBYB7DSeKALrZGk7G9+C9alanEZj+bOMlsoAIhjo6ejo2k7egmnyCTodR//83t1Rw8wWbWHb6PrHaoZhxIe+C88epJW5M0fxIVWHdUkk9BmUnZl49WpK+kCtlorJijT1X5nbfrsXNzc8uGyaLkSWO352CmnxQ01i4Vw9GNpEC/IxGjDstyOqBMyAVbsi08CU/jetdZi/pLoeng1GzBp1JHOXWq2QdDMxMX2RoZiZ9FCgBhEmQZG7yhT7FGM0KEABx9BH5cJPvM9dc18muZr3wpemjyPVUx8aTYvlEyarutpdbws9wvyUVk6uL7kKMF0eq1fe4jFOpgGCK35gODcr8QQnYo3kdPgnw1fXqCOzBdSMpAcg6+02o4T1DJQh0e28hpuFM2PPJY4yDWiIwAld/YtmfIh1UPOHT+pSysw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Arina,

On Tue, Nov 24, 2026 at 03:58:53AM +0400, Arina Kharlamova via B4 Relay wrote:
> From: Arina Kharlamova <arina.kharlamova@mbzuai.ac.ae>

Please consider improving readability of the commit message and the
comment. LLMs are good at writing a bunch of "technically correct" texts
that are completely unreadable by human.

> Commit fa5c82f4d2bb ("slab.h: disable completely broken overflow handling
> in flex allocations") removed the overflows_flex_counter_type() check from
> __alloc_flex(), but left the kernel-doc of __alloc_flex() and
> kmalloc_flex(), and the text in deprecated.rst, saying that the
> allocation fails when COUNT cannot be represented by the __counted_by()
> counter.

Good catch.

Hmm, commit fa5c82f4d2bb says it needs to be inserted into
__set_flex_counter but conditionally but apparently there is no
follow-up. Kees?

> The code instead allocates COUNT elements and stores COUNT into the
> counter, truncated to the counter's type. With a u8 counter,
> kmalloc_flex(*p, array, 256) returns a 256-element object whose counter
> is 0.

> With compilers that lack __builtin_counted_by_ref() the counter is
> not written at all.

Yup, which is benign as the counter is only used by hardening checks,
right?

And they should be skipped with such a compiler?

> A caller that relies on the documented check and does not bound COUNT
> itself gets an object whose __counted_by() size is smaller than the
> allocation. Accesses inside the allocation are then reported by
> UBSAN_BOUNDS, and readers that loop up to the counter see fewer elements.

Good point but a counter overflow is an obvious bug so this explanation
is unnecessary and verbose.

> Make the documentation describe what the code does, and fix the
> Returns: text of overflows_flex_counter_type(), which still describes
> the inverted logic that the same commit corrected.

Ok.

> Returning NULL, as the old text described, is not done here. Some
> callers allocate one element more than the counter can hold and then set
> the counter themselves: ext4_htree_store_dirent() calls kzalloc_flex()
> with ent_name->len + 1 elements for a struct whose name_len is a __u8,
> so a 255-byte name would then fail with -ENOMEM.

again, this pagraph doesn't add much value in the commit message IMHO.

> Found while checking a summary of the kmalloc_obj() family against the
> v7.0 to v7.4-rc2 text of slab.h with a battery of inputs compiled by
> GCC 15.2, with the help of an AI coding assistant (Claude); I reviewed
> the analysis and the patch. A KUnit case (not part of this patch) that
> calls kmalloc_flex() with a u8 counter and COUNT 256 gets a non-NULL
> object with the counter 0 on v7.4-rc2 (UML, GCC 15.2.0); with
> UBSAN_BOUNDS, writing element 255 of that object reports "index 255 is
> out of range for type 'u32 [*]'". This patch changes comments only;
> scripts/kernel-doc -Wall reports the same warnings for slab.h and
> overflow.h before and after it.

again, we don't really put a paragraph like this in the commit message.

> Fixes: fa5c82f4d2bb ("slab.h: disable completely broken overflow handling in flex allocations")
> Signed-off-by: Arina Kharlamova <arina.kharlamova@mbzuai.ac.ae>
> ---
>  Documentation/process/deprecated.rst |  8 ++++----
>  include/linux/overflow.h             |  5 +++--
>  include/linux/slab.h                 | 15 +++++++++------
>  3 files changed, 16 insertions(+), 12 deletions(-)
> 
> diff --git a/Documentation/process/deprecated.rst b/Documentation/process/deprecated.rst
> index 22a5e62c92ea..f8b7fb6f9629 100644
> --- a/Documentation/process/deprecated.rst
> +++ b/Documentation/process/deprecated.rst
> @@ -405,7 +405,7 @@ become, respectively::
>  	__auto_type ptr = kmalloc_obj(struct foo [, gfp] );
>  
>  The argument gfp is optional, the default value is GFP_KERNEL.
> -If `ptr->flex_member` is annotated with __counted_by(), the allocation
> -will automatically fail if `count` is larger than the maximum
> -representable value that can be stored in the counter member associated
> -with `flex_member`.
> +If `ptr->flex_member` is annotated with __counted_by(), the counter
> +member associated with `flex_member` is set to `count` on compilers that
> +support it. `count` is not checked against the type of the counter, so
> +the caller must make sure it fits.
> diff --git a/include/linux/overflow.h b/include/linux/overflow.h
> index d0f04436343e..6ce610dbc12e 100644
> --- a/include/linux/overflow.h
> +++ b/include/linux/overflow.h
> @@ -566,8 +566,9 @@ static __always_inline size_t __must_check size_sub(size_t minuend, size_t subtr
>   * @FAM: Member name of the FAM within @TYPE.
>   * @COUNT: Value to check against the __counted_by annotated @FAM's counter.
>   *
> - * Returns: true if @COUNT can be represented in the @FAM's counter. When
> - * @FAM is not annotated with __counted_by(), always returns true.
> + * Returns: true if @COUNT cannot be represented in the @FAM's counter.
> + * When @FAM is not annotated with __counted_by(), or the compiler cannot
> + * resolve the counter, @COUNT is checked against size_t.
>   */
>  #define overflows_flex_counter_type(TYPE, FAM, COUNT)		\
>  	(overflows_type(COUNT, typeof_flex_counter(((TYPE *)NULL)->FAM)))
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index ad645967a3ee..69fa9066137f 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -1091,10 +1091,13 @@ void *kmalloc_nolock(size_t size, gfp_t gfp_flags, int node);
>   * @FAM: The name of the flexible array member of @TYPE structure.
>   * @COUNT: how many @FAM elements to allocate space for.
>   *
> + * If @FAM is annotated with __counted_by() and the compiler supports
> + * __builtin_counted_by_ref(), the counter member is set to @COUNT. @COUNT
> + * is not checked against the type of that member: a value it cannot
> + * represent is stored truncated, so the caller must bound @COUNT.
> + *
>   * Returns: Newly allocated pointer to @TYPE with @COUNT-many trailing
> - * @FAM elements, or NULL on failure or if @COUNT cannot be represented
> - * by the member of @TYPE that counts the @FAM elements (annotated via
> - * __counted_by()).
> + * @FAM elements, or NULL on failure.
>   */
>  #define __alloc_flex(KMALLOC, GFP, TYPE, FAM, COUNT)			\
>  ({									\
> @@ -1137,9 +1140,9 @@ void *kmalloc_nolock(size_t size, gfp_t gfp_flags, int node);
>   * @...: optional GFP flags for the allocation (GFP_KERNEL when not specified).
>   *
>   * Returns: newly allocated pointer to @VAR_OR_TYPE on success, NULL on
> - * failure. If @FAM has been annotated with __counted_by(), the allocation
> - * will immediately fail if @COUNT is larger than what the type of the
> - * struct's counter variable can represent.
> + * failure. If @FAM has been annotated with __counted_by(), the struct's
> + * counter variable is set to @COUNT when the compiler supports it. @COUNT
> + * must fit in the type of that variable; it is not checked.
>   */
>  #define kmalloc_flex(VAR_OR_TYPE, FAM, COUNT, ...) \
>  	__alloc_flex(kmalloc, default_gfp(__VA_ARGS__), typeof(VAR_OR_TYPE), FAM, COUNT)
> 
> ---
> base-commit: 9b95c9eeec894e969d590f45f9b760e88ba92876
> change-id: 20261124-slab-doc-1894ca04d006
> 
> Best regards,
> --  
> Arina Kharlamova <arina.kharlamova@mbzuai.ac.ae>

-- 
Cheers,
Harry / Hyeonggon

