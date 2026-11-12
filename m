Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85EA3606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 00:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.a=rsa-sha256 header.s=mail header.b=OwAplIni
Received: by kanga.kvack.org (Postfix)
	id 9C6536B05BC; Wed, 11 Nov 2026 19:40:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 977926B05C6; Wed, 11 Nov 2026 19:40:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88D356B05C7; Wed, 11 Nov 2026 19:40:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 515E16B05BC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:40:47 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 94E4440216
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:40:46 +0000 (UTC)
X-FDA: 85424611692.06.4317460
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [213.167.242.64])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8C5EF2000A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:40:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ideasonboard.com header.s=mail header.b=OwAplIni;
	spf=pass (imf03.hostedemail.com: domain of laurent.pinchart@ideasonboard.com designates 213.167.242.64 as permitted sender) smtp.mailfrom=laurent.pinchart@ideasonboard.com;
	dmarc=pass (policy=none) header.from=ideasonboard.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794444045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6xpWvm8FwNjmg+fPN53wD4gkIM4E/p3REBlACqtLvXs=;
	b=O0Fi2QXm7n/fEhRn+ZT57IFgs47Ds4p4rsHI7TYkTnxfGWGT/6yJDrEYVoCPSAD/kd1pN/
	FMnmJm2TnjnBxgwiFQHQ4zCvHPOvPf0jIegQtnqwKBA60GlGYDBJU93r/tQm6N7BUzlGlE
	NHmO9jJKHeo5KRztc+6LsCHhF57kIxE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794444045;
	b=tKmXEs0AnGm7+T9mJ3f5prqde4Ozr06agPHeBBjpm0IeDa6nk19OgCUeaa8k8hmnnAhMzm
	B8Lw/bT2b72LpNpl7lkQVbO/pJlfFXOcNBCDcT1Ic6s5I975htcpkQ6ut7PW2HFRP4aQKz
	8GHZipLk7abIbvphACuiFe0ruOMXcII=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ideasonboard.com header.s=mail header.b=OwAplIni;
	spf=pass (imf03.hostedemail.com: domain of laurent.pinchart@ideasonboard.com designates 213.167.242.64 as permitted sender) smtp.mailfrom=laurent.pinchart@ideasonboard.com;
	dmarc=pass (policy=none) header.from=ideasonboard.com
Received: from killaraus.ideasonboard.com (2001-14ba-7086-3000--a06.rev.dnainternet.fi [IPv6:2001:14ba:7086:3000::a06])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5C75A1F8;
	Thu, 12 Nov 2026 01:38:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
	s=mail; t=1794443897;
	bh=xqfnEjqyHMQl2qHFWowUXzE/Oqfvp6pljb9uxPDED6A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OwAplIniUURguBikb+R/YMs3Bk8BOTl5EYLwv+82bdKT0dPNZJZiMnz9j+W0pHvef
	 FtqWTyR04z/5aW7g+jR/himpZlnP3HJ9YmG522bYVRRYPgmf8uA6/vCIJj0CspD307
	 tAoFk2kEEVq48RsFodiAydmT/svA8mDID9+hwG6E=
Date: Thu, 12 Nov 2026 02:40:39 +0200
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kees Cook <kees@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	driver-core@lists.linux.dev, linux-hardening@vger.kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 2/2] devres: Provide kmalloc_obj*-style API for
 devm_kmalloc
Message-ID: <20261112004039.GA523044@killaraus.ideasonboard.com>
References: <20260914223212.i.829-kees@kernel.org>
 <20260914223219.901347-2-kees@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260914223219.901347-2-kees@kernel.org>
X-Stat-Signature: s4w1afrzaau4anqomc4ksnige4jq4hg5
X-Rspamd-Queue-Id: 8C5EF2000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794444044-216299
X-HE-Meta: U2FsdGVkX1+xq5OSvC2rtEnFduIWlF5Nk6IqdcKp61EbSxILThUzofGBB500wum/h5XqXC9yE6Z4wvBNwzQCFt9Tn+VpQ+c/8TQ50yfcRvat11b09pGq0fKZVqw4g1/ooYoeiTF/HjzKh3Uc+K7TwQLuOByZ6TKnQTkZ65/LToUv026myT3hCERUcZm9t3r1sSTsDGXuj3Vpw6Hvq4XpMH3saiV19X0xOrxdYmDGRCtvfe2kFp6hX1aCwjvNhh471HL3PTTuX3k3JI9KqlB6B4Nz1XYu/Xt3aEnD971jlcmr4ye+tB5F6XV2CFC0MAsAuSQg3Lvxwhv/dDil2tB8tpcL10nGmSFydmy5Nnf4ARjIBoZAPAxZ9GT3WS5ik60/PiCexIjIjdJkqt0flOAxRoJQBo9/NBm/Z89dVguAq0rsA62nR+Tgw8V800/izFfzUUNHiE3fFlHWoFq41Bs5OvwZcQ4ngIv+Dv4JsAiosGQj+U74X9SlT1bK/zZ73DCemoQrw7rIa5BsF8WhD4JHkpa7TobKvrDD2C96nI4CJhzcbJPkRb7oIKrgmHyA7a/G9f4B8GuT6bZxql2ZOXOtgj4LawnmnknBz0jCYRf+HNxC33gdnmOdSfiHp4GJe+5oO6n7RWV/foAO2Z3aBFxZVnFOl/Qge9ghQKMT6rnKQbdRhAGF2OGUUzf/cNIzHV9WPVOiBheFmadD8JaT5+/LoxxKH+1nOzl8FA/DhbASlnW+3uyirIWv2iC/zMXm0G26UPaYVws/6dqfNQAXAEoz4X39UZ28KG0kBiU8iw+c5XxEe9QS4Fq/tejxBQiZXPi9AhPcbGhEnDLUhcaPpAdAN4Tfa081+5MIcJ74Lp4rhOSc6uk3u/W8NRb9jErD3oD1HPzUbMY+AUxnemrZEuRaqQZT3BRFRWH/6M8r0COOaCqMrhiWFDhnOuK4PScaCeuZ0i6lCBPyycKxsdjH4fQ
 iSWnymmG
 mB0ghi7tON9RcXd2+NzWG3cuiq7uJl1dhUVR1hpSQymLHksf7W93EYcpHlNjRqSji768esRagBAJeswAJV5XyJ2hxiW8iJOI+jIYSGKm/xEhuQ9H0z9gWlBCWeZCxTAcggvMR9dCY42VTIIU9MgVxY4PQYMIHthBVURCUoiOE7OvtlSAwiRVgQNIbxFjelgdDY7X2IceL5eaf9r3cQ1FP6DSwTtSDVI1wXOASVbBS4B39Ue0Yw98KmsJa9sWGH7ECSkUedMG5xz8DEhpig1LGp3sY59XcIuCRFlWM3om+BBY7FrA7EJ37JJ1xrCOk3D+AWBVtwj53tNyJoHjxkZdCYxBHtpBE28oJcSULkMfyejtsJx90WEcPGLjc52CI20oyHt+i/cr6mJiOeoXXNoc+4boZ24/B+lcL5agEAP0lElMeLsGIn35E7qGYlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Kees,

On Mon, Sep 14, 2026 at 03:32:17PM -0700, Kees Cook wrote:
> Mirroring the type-based allocation now in use for the kmalloc family of
> APIs, provide the same for the devm_kmalloc family of APIs. This will
> allow for future plumbing of type information (e.g. alignment) into the
> underlying allocations. This immediately gains type check on return
> values (instead of the prior "void *" return type).
> 
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Cc: <driver-core@lists.linux.dev>
> Cc: <linux-hardening@vger.kernel.org>
> ---
>  include/linux/device/devres.h | 102 ++++++++++++++++++++++++++++++++++
>  1 file changed, 102 insertions(+)
> 
> diff --git a/include/linux/device/devres.h b/include/linux/device/devres.h
> index 14ab9159bdda..7656c9ecd4da 100644
> --- a/include/linux/device/devres.h
> +++ b/include/linux/device/devres.h
> @@ -62,6 +62,108 @@ static inline void *devm_kcalloc(struct device *dev, size_t n, size_t size, gfp_
>  {
>  	return devm_kmalloc_array(dev, n, size, flags | __GFP_ZERO);
>  }
> +
> +/**
> + * __devm_alloc_objs - Device-managed allocation of objects of a given type
> + * @DEVM_ALLOC: which device-managed size-based allocator to use.
> + * @DEV: device to scope the allocation lifetime to.
> + * @GFP: GFP flags for the allocation.
> + * @TYPE: type to allocate space for.
> + * @COUNT: how many @TYPE objects to allocate.
> + *
> + * Device-managed counterpart of __alloc_objs().
> + * @DEVM_ALLOC takes (@DEV, size, gfp).
> + *
> + * Returns: Newly allocated pointer to (first) @TYPE of @COUNT-many allocated
> + * @TYPE objects, or NULL on failure.
> + */
> +#define __devm_alloc_objs(DEVM_ALLOC, DEV, GFP, TYPE, COUNT)		\
> +({									\
> +	const size_t __obj_size = size_mul(sizeof(TYPE), COUNT);	\
> +	(TYPE *)DEVM_ALLOC(DEV, __obj_size, GFP);			\
> +})
> +
> +/**
> + * devm_kmalloc_obj - Device-managed allocation of a single typed object
> + * @DEV: Device to scope the allocation lifetime to.
> + * @VAR_OR_TYPE: Variable or type to allocate.
> + * @GFP: Optional GFP flags (defaults to %GFP_KERNEL).
> + *
> + * Device-managed counterpart of kmalloc_obj(): the allocation is sized from
> + * @VAR_OR_TYPE and returned as a pointer to that type, not void *.
> + *
> + * Returns: newly allocated pointer to a @VAR_OR_TYPE on success, or NULL on
> + * failure.
> + */
> +#define devm_kmalloc_obj(DEV, VAR_OR_TYPE, ...)				\
> +	__devm_alloc_objs(devm_kmalloc, DEV, default_gfp(__VA_ARGS__),	\
> +			  typeof(VAR_OR_TYPE), 1)
> +
> +/**
> + * devm_kmalloc_objs - Device-managed allocation of an array of a typed object
> + * @DEV: Device to scope the allocation lifetime to.
> + * @VAR_OR_TYPE: Variable or type to allocate an array of.
> + * @COUNT: How many elements in the array.
> + * @GFP: Optional GFP flags (defaults to %GFP_KERNEL).
> + *
> + * Returns: newly allocated pointer to an array of @VAR_OR_TYPE on success, or
> + * NULL on failure (including when the total size overflows).
> + */
> +#define devm_kmalloc_objs(DEV, VAR_OR_TYPE, COUNT, ...) \
> +	__devm_alloc_objs(devm_kmalloc, DEV, default_gfp(__VA_ARGS__), \
> +			  typeof(VAR_OR_TYPE), COUNT)
> +
> +/**
> + * __devm_alloc_flex - Device-managed allocation of a trailing-flex-array object
> + * @DEVM_ALLOC: which device-managed allocator to use.
> + * @DEV: device to scope the allocation lifetime to.
> + * @GFP: GFP flags for the allocation.
> + * @TYPE: type of structure to allocate space for.
> + * @FAM: name of the flexible array member of @TYPE.
> + * @COUNT: how many @FAM elements to allocate space for.
> + *
> + * Device-managed counterpart of __alloc_flex().
> + * @DEVM_ALLOC takes (@DEV, size, gfp).
> + *
> + * Returns: Newly allocated pointer to @TYPE with @COUNT-many trailing @FAM
> + * elements, or NULL on failure.
> + */
> +#define __devm_alloc_flex(DEVM_ALLOC, DEV, GFP, TYPE, FAM, COUNT)	\
> +({									\
> +	const size_t __count = (COUNT);					\
> +	const size_t __obj_size = struct_size_t(TYPE, FAM, __count);	\
> +	TYPE *__obj_ptr = DEVM_ALLOC(DEV, __obj_size, GFP);		\
> +	if (__obj_ptr)							\
> +		__set_flex_counter(__obj_ptr->FAM, __count);		\
> +	__obj_ptr;							\
> +})
> +
> +/**
> + * devm_kmalloc_flex - Device-managed allocation of a flexible-array structure
> + * @DEV: Device to scope the allocation lifetime to.
> + * @VAR_OR_TYPE: Variable or type to allocate (with its flexible array).
> + * @FAM: The name of the flexible array member of the structure.
> + * @COUNT: How many flexible array member elements to allocate.
> + * @GFP: Optional GFP flags (defaults to %GFP_KERNEL).
> + *
> + * Returns: newly allocated pointer to @VAR_OR_TYPE on success, or NULL on
> + * failure. If @FAM has been annotated with __counted_by(), its counter is set
> + * to @COUNT.
> + */
> +#define devm_kmalloc_flex(DEV, VAR_OR_TYPE, FAM, COUNT, ...) \
> +	__devm_alloc_flex(devm_kmalloc, DEV, default_gfp(__VA_ARGS__), \
> +			  typeof(VAR_OR_TYPE), FAM, COUNT)
> +
> +/* All devm_kzalloc aliases for devm_kmalloc_(obj|objs|flex). */
> +#define devm_kzalloc_obj(DEV, P, ...) \
> +	__devm_alloc_objs(devm_kzalloc, DEV, default_gfp(__VA_ARGS__), typeof(P), 1)
> +#define devm_kzalloc_objs(DEV, P, COUNT, ...) \
> +	__devm_alloc_objs(devm_kzalloc, DEV, default_gfp(__VA_ARGS__), \
> +			  typeof(P), COUNT)

I was recently made aware by Geert of an unfortunate side effect of the
default GPF_KERNEL argument. I've fixed a memory leak in the imx8-isi
driver by using devm_kzalloc_objs() as follows:

diff --git a/drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c b/drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c
index 0ae5f35e017c..9373a5256224 100644
--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c
@@ -488,7 +488,8 @@ static int mxc_isi_probe(struct platform_device *pdev)

 	isi->pdata = of_device_get_match_data(dev);

-	isi->pipes = kzalloc_objs(isi->pipes[0], isi->pdata->num_channels);
+	isi->pipes = devm_kzalloc_objs(dev, isi->pipes[0],
+				       isi->pdata->num_channels);
 	if (!isi->pipes)
 		return -ENOMEM;

So far, so good. However, the following code also compiles:

	isi->pipes = devm_kzalloc_obj(dev, isi->pipes[0],
				      isi->pdata->num_channels);

(note the *obj* instead of *objs*) because the third argument is
interpreted as gfp flags. It's clearly a bug, but one that the compiler
doesn't catch. The typo is easy to make.

Sparse catches the issue:

drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c:491:22: warning: incorrect type in argument 3 (different base types)
drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c:491:22:    expected restricted gfp_t [usertype] gfp
drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c:491:22:    got unsigned int const num_channels

I'm however not sure if build bots report sparse warnings or only
errors.

Is this an issue you're aware of, and do you think it should be
addressed ?

> +#define devm_kzalloc_flex(DEV, P, FAM, COUNT, ...) \
> +	__devm_alloc_flex(devm_kzalloc, DEV, default_gfp(__VA_ARGS__), \
> +			  typeof(P), FAM, COUNT)
> +
>  static inline __realloc_size(3, 4) void * __must_check
>  devm_krealloc_array(struct device *dev, void *p, size_t new_n, size_t new_size, gfp_t flags)
>  {

-- 
Regards,

Laurent Pinchart

