Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E72DCD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 08:24:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB6E56B0005; Wed, 27 May 2026 04:24:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C664E6B008A; Wed, 27 May 2026 04:24:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B559D6B008C; Wed, 27 May 2026 04:24:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A3BE16B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 04:24:25 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D7C6E16193E
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:24:24 +0000 (UTC)
X-FDA: 84812512848.06.73BE92B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id F3744100008
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:24:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kfnU3J83;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779870263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sv59KgmPS9YwACthNWBPKz9+XMUx70b0VSrwo1dUH0g=;
	b=Yd09JEkVkSAA1MMQxoSOp1SgUeMd9v5lLGskA4e50jpupUetsyM/OO28FkKA48lMZ17CGU
	RjRDq+HJVGEOuYBWFepqWXG9ybeHRMXQ7ixAphrw5oZUNR5MdF/GMDrCvx6ZTRGsalPRLH
	TLbokvwA9AzcNF8Kp/pdP/DruUMaQKQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kfnU3J83;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779870263; a=rsa-sha256;
	cv=none;
	b=18FdT3dex4Na6OHKB5j3bAYW6ZYa8UbLLauJ+EdVp6G/rNZBLl/eWm3pJy2fCJhkb4QG5c
	Ey5+WVYWA1VXJatukva9Qloe/j4/mQ9wEGDukH2hQTu30RdTFpOxg5OD6dn/PuPJEuNpza
	TrpowJxG4YE3ahVHwAB/vVrmrVo/wBo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BBA6B2880;
	Wed, 27 May 2026 01:24:16 -0700 (PDT)
Received: from [10.57.93.47] (unknown [10.57.93.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4EE113F7D8;
	Wed, 27 May 2026 01:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779870261; bh=bL0SGvpJMA0jKAYtYfSGI2V/YyddodRJo0fhchnToSo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kfnU3J8365dlkSur+Ghyy3KcliIFgbIFf/gzBx99N+i08GclVyKtMVVzUswqs3S9H
	 BbFy3b02pCkmlZFcMYymisrIST9qibyRe//b/zxYjemYcHtRq1ZAzuRlvchaO3WnEr
	 CFON8PFlu+HITiEmjXFYRSAySy6bNgRNL0wPH9wg=
Message-ID: <b4eb4ea8-f4d6-4be2-81b1-4a8a46abe94e@arm.com>
Date: Wed, 27 May 2026 10:24:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v8 01/24] mm: Introduce kpkeys
To: Linus Walleij <linusw@kernel.org>
Cc: linux-hardening@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Ira Weiny
 <ira.weiny@intel.com>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>
References: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
 <20260526-kpkeys-v8-1-eaaacdacc67c@arm.com>
 <CAD++jLnURXzgAgkWCcYX0dLOLqHQw+gn96V1dzDa_0Aoi3430Q@mail.gmail.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <CAD++jLnURXzgAgkWCcYX0dLOLqHQw+gn96V1dzDa_0Aoi3430Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F3744100008
X-Stat-Signature: pyc5oapoqydjunuce3imng6wdaamq3dg
X-Rspam-User: 
X-HE-Tag: 1779870262-534105
X-HE-Meta: U2FsdGVkX1+c7GpeXaJIURZBqvSgNhBHJeHdR1tYdyT85nFucB3SFlrd8M1ll8xgnzdt5UiuURHjaxkV2sI4qDTIrY1fAgzwZPZ8So/5B9Fr0gz5YQ0jz/lW8jXEuNaYqI90H2Zf4fQIwg4eokfSDSSHivB0MI6VMyaK/NKkSy3jIqmmcd6LPzSUnGcuxr+3XOa+vTuKhB4XzyCWTs0dmcrgHdnO53xr1WglqjqHkqC2w8Sdca88nTIRzlZIYQzhYFeWTkoDc5adrYSFW9H5u9H7CfPXhecQfSouiycXDikatQDFGmbL0SlNXro48uDVeia9R5c6i3qzj7m/YqL+SVRbq1z6ULqWomOLAEv5Ai/FwzoD7fLopXKYLZJhn+3Z1rw39GJxus+oLfsrUdaVa4msV5xsF+CFWd1lJxiCbdRHFSg/DW6n6ATuWpOxLb/jSC6nuSDzyBr+nxLjdWMJRzPSSAKdHUmxkLIhETfMWNN4JiWfbWBG+9dJJq5eGANyq1y5KauHSwr3ZI/NeDbFcQzztJLO/vCEC4NEp+ugRZWsrlkXi04BzvbfxnXo1SrOnuFqGwsbaKDAAgdvT8+NoZnyUEGYlBYk9XCX5M8STbeF9i87Kw3neSOAGUiRlx0sgjPyX+wIW8bERHcasLHPNDphJZ/4EO+tcswCyGlpQpM16lSGCK6hxnwPQLZbhqXlv0671to1mMdqxBZgTBp9MtKt5qVMaKdHpYTWcFllHisELV5dTa1km/8kftq1q62S1QTiOMHH2kZhDpXkljbPnAuALU5JiS2RiAK3D4rIWbVIco5y48ollRM6FXf22/RX8t1fD2D6QA8fzF5WzJvUBAKRgGD1VfNeKB0YIhksftdH1BVT6p75pFBQOE4bLCMmtk1Tc9Qa16FZ1ygwDPmtrp6RYpluXCBCJDHYcYIE+wgnMyLETT/y1pJPwj7tesQAFNDBtKn90fl8oHZlhsM
 NRZNhFd3
 w2dVXBJI6Fz3oX82G7Oh4bnpzLVsLnEhBvxtcpqtlInFUxWi0dqdAKcLNbx9Im60X2Rkd3/Sj/R9JmbnkBWOEUsDWdKCs/9O9VUqc5XKj2W5chVJg4uKXhqp/BcR9HoJLIzh2lx230HBAkvDtFyhvRLGg7YCeaHnUG/KipRYsDCa+KWLpKKaajbF4bvwHFV5/OW9PCf03BPrGok99/gb9ADHgQYfMOCg2I67/KZRddQSlp5R5cVIy5KdTS+cCAerXFEkFr/9U8kn+IqeTlB1eZx4NTupXcPAXuq4kiJ5rFG2T7Sokj10HyZpN4mAzlQZIUsYpz5kWUuLC+Hb0nHR0E17B257q5AVqwKb8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/05/2026 15:17, Linus Walleij wrote:
> Hi Kevin,
>
> here is just a few drive-by review comments pertaining to the
> API which will be used for all architectures wanting to use
> pkeys.

Appreciated, thanks!

> [...]
>
>> Because each architecture implementing pkeys uses a different
>> representation for the pkey register, and may reserve certain pkeys
>> for specific uses, support for kpkeys must be explicitly indicated
>> by selecting ARCH_HAS_KPKEYS and defining the following functions in
>> <asm/kpkeys.h>, in addition to the macros provided in
>> <asm-generic/kpkeys.h>:
>>
>> - arch_kpkeys_set_context()
>> - arch_kpkeys_restore_pkey_reg()
>> - arch_supports_kpkeys()
>>
>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> I'm following so far.
>
> Is there no need for something like
>
> ctx = arch_kpkeys_request_context(KEY_TYPE) ?
>
> I'm just thinking of the scenario that e.g. two architectures want
> to request the same type of key for some generic resource, but
> the underlying implementation is vastly different for the two
> architectures, so relying on hard-coded arch-specific constants
> may not work. I'm also thinking about archs supporting different
> versions/types of kpkeys in a multi-platform executable kernel
> that may execute on several different silicon with the same ISA.

I'm not sure I understand what potential limitations this is trying to
address. The only thing that is imposed by the framework is the value of
KPKEYS_CTX_*, which is purely symbolic. Everything else is up to the
architecture, including the value of each key (which could be determined
at runtime if needed) and the permissions associated to each context.

Conceptually a context is a set of permission overlays for all existing
keys, it doesn't have to be tied to just one key.

> Maybe this is too much upfront design, I understand it needs to
> be kept simple.
>
>> +#ifndef KPKEYS_PKEY_DEFAULT
>> +#define KPKEYS_PKEY_DEFAULT    0
>> +#endif
> (...)
>> +#define KPKEYS_CTX_DEFAULT     0
>> +
>> +#define KPKEYS_CTX_MIN         KPKEYS_CTX_DEFAULT
>> +#define KPKEYS_CTX_MAX         KPKEYS_CTX_DEFAULT
> I was thinking an enum:
>
> enum kpkey_type {
>     KPKEY_DEFAULT = 0,
>     KPKEY_MMU_TABLE = 1,
>    ....
> };
>
> since this is what is used later.
>
>> +/**
>> + * kpkeys_set_context() - switch kpkeys context
>> + * @ctx: the context to switch to
>> + *
>> + * Switches to specified kpkeys context. @ctx must be a compile-time
>> + * constant. The arch-specific pkey register will be updated accordingly, and
>> + * the original value returned.
>> + *
>> + * Return: the original pkey register value if the register was written to, or
>> + *         KPKEYS_PKEY_REG_INVAL otherwise (no write to the register was
>> + *         required).
>> + */
>> +static __always_inline u64 kpkeys_set_context(int ctx)
> Should ctx be unsigned here? I'm nor sure what a negativ context
> would mean.
> kpkeys_set_context(unsigned int ctx)

That's a good point, now that we say "context" and not "level" an enum
would be a better representation. I would directly use:

    u64 kpkeys_set_context(enum kpkeys_ctx ctx);

... unless we really need another layer of abstraction.

- Kevin

> And then I was thinking:
>
> unsigned int kpkeys_request_context(enum kpkey_type type) {}...
>
> + arch_ -prefixed version of the same.
>
> unsigned int ctx;
> ctx = kpkeys_request_context(KPKEY_MMU_TABLE);
> (...)
>
> Constant sinking in the compiler will optimize the arch
> function to a constant in the object code so it will still
> be fast just a bit more talkative in source form.
>
> Yours,
> Linus Walleij

