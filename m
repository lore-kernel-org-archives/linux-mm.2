Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B41ECD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:17:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C58F6B00A2; Tue, 26 May 2026 09:17:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 475CC6B00AA; Tue, 26 May 2026 09:17:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33E1B6B00BE; Tue, 26 May 2026 09:17:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C3F96B00A2
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:17:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DA47EA0434
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:17:38 +0000 (UTC)
X-FDA: 84809622996.11.12FECBD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id BBB0D4000D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:17:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ik30zYwS;
	spf=pass (imf07.hostedemail.com: domain of linusw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779801456; a=rsa-sha256;
	cv=none;
	b=rjkUu84K8Is6Z/HlXBPY29PJzDovmuT5cgmIhM6zcM1a245Qx7VVEA08AMG2JeY3c6SX35
	B0GmEZzNA4ugwx5MKD2gIf4vXQbLTbv+/vNnPqWoM8Vwd/18h5hmA/WdESImEsFwlJnqtG
	d52FTRJFUP/mYeS0OSeMVLQ5vIoT2DU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ik30zYwS;
	spf=pass (imf07.hostedemail.com: domain of linusw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779801456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=flib1lT9XACw/dOlXrdz0j3tL1RxjfVbN+h8oDjWYwQ=;
	b=gILChmaT34juF4XcxAmqbgmuBp8ixt4ryyxeXx7KAit+8gpX8yQEYoJt0i1GHVQC3GBlQn
	tcgk0uA3lwIa+KbzvXMUmSgtyZBLFNdQoUFoN+p69qgqbK1zw17Y0d65nDz7gos3/a/ppD
	zcB+yOEiVkX/PymmW6i/cR1cDZ/M44U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 47D7760216
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3FBA1F000E9
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779801456;
	bh=flib1lT9XACw/dOlXrdz0j3tL1RxjfVbN+h8oDjWYwQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ik30zYwSbyOlgfIKiCrnatW9FCRjQf91DbnyOZ7BMieUicoNGhHlLQWlkJfpo8G1C
	 4sABbHGLRZtm28bLle6cFnLCimT0AvzhpdikQfkiBL50FxnpJZzuc6z1MtMHtq+MLh
	 3xAxStio1aD36S7A6+oxhw8kD8PpYyHeJ1gwpZA62ak+GjkqqqqckT4JHMiYFoouJ7
	 GzZsW//OJl/s13+XgN33EyZjp/McvvQwsfuogxXev38mjZbgtldNSyR/p1EJryhlhR
	 9NlzVu68DFp61L2tvcCerO0V4iIYyjjIIqG5KwTOJEvqR99G83LAcOnBMHQ1BqEcp3
	 P43abPhJii5ag==
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5a8ee4b703fso9617905e87.0
        for <linux-mm@kvack.org>; Tue, 26 May 2026 06:17:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9C2dy1eYWGWmuIee0R3mcghtRpFfNvfpT2s1FEIr68koprt/qj4fhyEvYgrpEO1buTWimD7K3hRA==@kvack.org
X-Gm-Message-State: AOJu0YzgWzYfJEC7i2O20axmQUS/IkiDpLxSn8haVyUN14Kz37s0zW6s
	O4AhIYylMhxfpiHMQ1K7YQO5sisyTXw2CFxKhZeo9uJHaAGnNYx0bk/XeNbDkt9rQXGrQrlL+sN
	EaRfKR2KeXIoBjWJK0KBgdF6BmKqAaW8=
X-Received: by 2002:a05:6512:1094:b0:5a8:8222:7fc9 with SMTP id
 2adb3069b0e04-5aa323ab2e4mr7005025e87.13.1779801454669; Tue, 26 May 2026
 06:17:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com> <20260526-kpkeys-v8-1-eaaacdacc67c@arm.com>
In-Reply-To: <20260526-kpkeys-v8-1-eaaacdacc67c@arm.com>
From: Linus Walleij <linusw@kernel.org>
Date: Tue, 26 May 2026 15:17:22 +0200
X-Gmail-Original-Message-ID: <CAD++jLnURXzgAgkWCcYX0dLOLqHQw+gn96V1dzDa_0Aoi3430Q@mail.gmail.com>
X-Gm-Features: AVHnY4Kbg2Xadd_3XEw9WMChJMsoQ29BSR2ziaqWgbvf-NftOZWEkP4UGbMFG7w
Message-ID: <CAD++jLnURXzgAgkWCcYX0dLOLqHQw+gn96V1dzDa_0Aoi3430Q@mail.gmail.com>
Subject: Re: [PATCH RFC v8 01/24] mm: Introduce kpkeys
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-hardening@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Andy Lutomirski <luto@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>, 
	Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Maxwell Bland <mbland@motorola.com>, "Mike Rapoport (IBM)" <rppt@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Pierre Langlois <pierre.langlois@arm.com>, 
	Quentin Perret <qperret@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
	Yang Shi <yang@os.amperecomputing.com>, Yeoreum Yun <yeoreum.yun@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
	Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: BBB0D4000D
X-Rspamd-Server: rspam03
X-Stat-Signature: f7shzkduj61qpt4h1nhyncucu9kqagn6
X-HE-Tag: 1779801456-683493
X-HE-Meta: U2FsdGVkX1/eoZiUBPFOBuRMV7AgFRZLm8X6LfCZ0gLhtDKbCe4+lDX0iEzEUHNA49Z+IdtU7oSaqgMZBu8bf/QSOp3hzLn8krHoQZAXhkpoSDhAd9ZsJzVRiI+IXF7sjG/SBAqhkayr45JHWezi73KSxeKHhRSKazUltNwXAMKLSSdooj3RgD49vMxdoVExg3sjU3SIpV92VPANv0wtzhopnSpZSfm9wYgQpkjiynau4CAW/YhqeSDlYzi+9EaixP41QVcN23MIkyWQuRVgfj4pGesh9nL6aCTpTr/Q/ybPyXoVqSbTT/fUwQvakeTjd3Q61/X9YJNQKRcB0tMpqxE2hXLCN2I+i+B/2tqfxlSHsrEtC+gseI1jS+yKZVkevWhq8EI3M0jdhUTdwqhE7Re95qGkDuIMvMOuRubI0DpzbLcRw/IlKFeYoqcH0XknoYQzeBNMpfntKJtPugwY/GrhPk+bN4cm1UYfz8Xj7yxZaMQFOh8lbEAuP9RMbzAjDwKm00iVWsHiPV0G03RlpE/eSsliw9NlMSZIBXuzNdy3anB3YQoX0Pr82PoGmy139n11hsD4icTq7UbeHd7XOMt4UGsf4obXvWRxA2MG1daqW1k39YkqIVYi0qgBjOn5gReu9DhTSbUfTTWv4qFG9NoJ1I16fQH/V0B7uNmHjpD251V376FoiayfLeI8WOOMLOT+cQDnyFXssGfsbDuZHE2ItWq8e9Cdo/fhHpAvAMlDQVVtipKmFQhJQyDqS55z4Bppta85No2gYrKeGr3pAca46SPg3S62Yonf5cvdK1P3rE9qJ4VMJrWVdGZT+hOW24pv6KXfFrrQI7R9POgbOo3Lbcm8sZ5+sShPXHzTf6raSgIIp6S+AJVYmBsDnvFpM1bz2MwoXmNZ+Zni7lMNiJHOqi30fUSxNc18Ay5na3Q9/0nedOrmCWQzPLxznr6iteLYeK7Z80yzPswJpEA
 NJn9Jx8L
 wJiqpHFwxhOsIraICRph1OrY4ipPnyiIjCPMxD4jCT8WlPH0T3DpYqaw49MoAYBhPQNgf/z+BLeT2txcC/mCukr2V5rRZ1RIXz4FdMA/rhfH+Q5+qmP9WnGspxuNBl6wpKWS82+T1lmZiqCW/HZv8/d8E4HsjITPD1HGSTSOP6JORVdfp3WlVWDyxREwv04O5zxDZssdXKPSiWZLRjWZT/agWg7Lrw1j3CHUTAwbmpkToSO06EJc8O3A9bP6mKxz6pWmKE9Nz8MT0+7/xO/aKWRC7IYcTeRzqyVHeR8ywkIyRC4e4B0ZVae3xIgXS5UzAq0p9jrT0fE9b9D3Robrx8VL28rOPOI2p3yo/alzWP2Pc9fGjfqC1YfB6/+HUT8HJjTP/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kevin,

here is just a few drive-by review comments pertaining to the
API which will be used for all architectures wanting to use
pkeys.

On Tue, May 26, 2026 at 1:17=E2=80=AFPM Kevin Brodsky <kevin.brodsky@arm.co=
m> wrote:

> kpkeys is a simple framework to enable the use of protection keys
> (pkeys) to harden the kernel itself. This patch introduces the basic
> API in <linux/kpkeys.h>: a couple of functions to set and restore
> the pkey register and macros to define guard objects.

It=C3=A4s a nice idea to use guards for this!

> kpkeys introduces a new concept on top of pkeys: the kpkeys context.
> Each context is associated to a set of permissions for the pkeys
> managed by the kpkeys framework. kpkeys_set_context(ctx) sets those
> permissions according to ctx, and returns the original pkey
> register, to be later restored by kpkeys_restore_pkey_reg(). To
> start with, only KPKEYS_CTX_DEFAULT is available, which is meant to
> grant RW access to KPKEYS_PKEY_DEFAULT (i.e. all memory since this
> is the only available pkey for now).

OK!

> Because each architecture implementing pkeys uses a different
> representation for the pkey register, and may reserve certain pkeys
> for specific uses, support for kpkeys must be explicitly indicated
> by selecting ARCH_HAS_KPKEYS and defining the following functions in
> <asm/kpkeys.h>, in addition to the macros provided in
> <asm-generic/kpkeys.h>:
>
> - arch_kpkeys_set_context()
> - arch_kpkeys_restore_pkey_reg()
> - arch_supports_kpkeys()
>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>

I'm following so far.

Is there no need for something like

ctx =3D arch_kpkeys_request_context(KEY_TYPE) ?

I'm just thinking of the scenario that e.g. two architectures want
to request the same type of key for some generic resource, but
the underlying implementation is vastly different for the two
architectures, so relying on hard-coded arch-specific constants
may not work. I'm also thinking about archs supporting different
versions/types of kpkeys in a multi-platform executable kernel
that may execute on several different silicon with the same ISA.

Maybe this is too much upfront design, I understand it needs to
be kept simple.

> +#ifndef KPKEYS_PKEY_DEFAULT
> +#define KPKEYS_PKEY_DEFAULT    0
> +#endif
(...)
> +#define KPKEYS_CTX_DEFAULT     0
> +
> +#define KPKEYS_CTX_MIN         KPKEYS_CTX_DEFAULT
> +#define KPKEYS_CTX_MAX         KPKEYS_CTX_DEFAULT

I was thinking an enum:

enum kpkey_type {
    KPKEY_DEFAULT =3D 0,
    KPKEY_MMU_TABLE =3D 1,
   ....
};

since this is what is used later.

> +/**
> + * kpkeys_set_context() - switch kpkeys context
> + * @ctx: the context to switch to
> + *
> + * Switches to specified kpkeys context. @ctx must be a compile-time
> + * constant. The arch-specific pkey register will be updated accordingly=
, and
> + * the original value returned.
> + *
> + * Return: the original pkey register value if the register was written =
to, or
> + *         KPKEYS_PKEY_REG_INVAL otherwise (no write to the register was
> + *         required).
> + */
> +static __always_inline u64 kpkeys_set_context(int ctx)

Should ctx be unsigned here? I'm nor sure what a negativ context
would mean.
kpkeys_set_context(unsigned int ctx)

And then I was thinking:

unsigned int kpkeys_request_context(enum kpkey_type type) {}...

+ arch_ -prefixed version of the same.

unsigned int ctx;
ctx =3D kpkeys_request_context(KPKEY_MMU_TABLE);
(...)

Constant sinking in the compiler will optimize the arch
function to a constant in the object code so it will still
be fast just a bit more talkative in source form.

Yours,
Linus Walleij

