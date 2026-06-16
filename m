Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 581F1CD98D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:15:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EF736B00EC; Tue, 16 Jun 2026 17:15:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A14D6B00EE; Tue, 16 Jun 2026 17:15:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 368466B00EF; Tue, 16 Jun 2026 17:15:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 07C8E6B00EC
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:15:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 80A531C2C4A
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:19:34 +0000 (UTC)
X-FDA: 84886135068.20.C0E6B3E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id B58F81C0003
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:19:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ck1DRL22;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781623172;
	b=5uFLDmEEOqgYKB4Mb1UVwoB+qcvk6lM2f/SSadqiemC0lSprRH5PjUnBedu1VOytv6zZdt
	QiGOt0qeeb+tIF7mbTx1pt1iWeUGt8/0lbYA0SArXrePjMAc4sHrbiJpLpZAv0QyVH+0Mv
	2hmsaDKgWAhr9fx2DJy9q8FgnyTrOlA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ck1DRL22;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781623172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r4HeNsdpZXcuGDpdJwc1l324i0d9msH0jiY923pAvrc=;
	b=ecWqWH+J0egt+YQCqoLHpqxqCBdDz14bjnFQoEczbOYoCopJrUBdf5Q+UOpka6JJO3yjaN
	X58KO0acnOBZEvn2ATCzWNF3w4cR5En+Ou8i3+CoWRElQzOLGUbUGB7fhViZjOt1gmMey5
	qSJ0mbLEEGqrLDS95sWA0QbYIDiYIeg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E6F116012A;
	Tue, 16 Jun 2026 15:19:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C961F00A3A;
	Tue, 16 Jun 2026 15:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781623169;
	bh=r4HeNsdpZXcuGDpdJwc1l324i0d9msH0jiY923pAvrc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ck1DRL22ljLe93iK/7HgtsYxeBKDxBCFPWNpfgWDBiVxkCWICUXwCIPlsaTKuJuhs
	 biK6K8nc9I2zI8He0La3nV8IU8ak0Atra2CONHCbod28hTjnrKvyEfkj4VfeW53F1f
	 GHQ3vk6KZDZD3RaqEf1baP32aHjSwcsvZMgaYvKICu+3us71lDvpfucBjbXqNpMP3t
	 /QHtweoSA0bIaoRc6cbNqeqGC2oiiptTvR0x2HTdG2GRYQWsjg3jaaiy2CrPP2v0Sn
	 hMxk+u60vSWW3+yjH/D02PCNUyXJ2gH95+b58HXM4lHcsFY1TOkWbafCI2y4I75VyO
	 1xBe5AlPkpqTw==
Message-ID: <70f4dcdf-c45f-47d3-91df-a7897bd86ff4@kernel.org>
Date: Tue, 16 Jun 2026 17:19:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v8 01/24] mm: Introduce kpkeys
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-hardening@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260526-kpkeys-v8-1-eaaacdacc67c@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B58F81C0003
X-Stat-Signature: 1kc7nhorxg591mjz7rdfmumuxepd35xd
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781623172-880166
X-HE-Meta: U2FsdGVkX19NqmG5Kl2KeR7t3m/bTEcNQJs9CLzgsr9yooGgasP7WLl5GBKeXejHRvrFpGl7hJlXl0evCP+qAo9ypg6IDF69Kywgy06XwJowGclUzOTejReCp7CUk50stw8Z87JYwc5Ylwu4f+SBAiuKU5nmInl7/KSo1PPAw2fCeQw7L4gYmzLoLe004/8ANHBz1r1DSZyiMR5wqcthGZ/cupHZGXnB4V0LsBFfEri0+3mh/1GoJmp+ecPbhQr7S+zO95P+nO4p2b63ARMR5U5n0BHiUCWt7HEvFCHslVdJNu+Sge8vAm7+Sgbzn1W902gY5Qvh2jqIc99EvR651yTjLiuO0d5scmmnMb661crw6AdAbgddBc3FKAJBrx3XPwjITB+6wzbCcLjgt775vLWOdgw5+FRWwKmKOrpmvq3P8rQT5KPDl/cBZsoOjY7KlmZ6Cpm4Po5phPd7VsQLhf0k/poNsYyZ5XA37dVHllQJJVJ9FlFdT6ll0qMDEZwaX/LoQtE2j4fik58HfRmcTq/DYTPP6KrfCJp5A19fD1Q+jOxI7eiH2CalOPUluS0T5Cqsz6ChGAM+LlhQsOnL7cg3XZ/avoyEXX/FvTBvTowm86XYlBowbBa4T8fXAmsxvCnbgPSmdJYCktzLunNxj+VLi41QKluKcBIuEQ1DX0IewJ/7PNOW0sNfCdT3qvrVPameGxckmZ99wHJw+idAuAZjg+OdwjBGefandIVhr3ETaorFl+GOG2aX+ppEfqKKgNfHx9NzEz/vOcjuVmULdpxCPc9ExfckGbGxOGgLKzTl8JjsJGkK0dyDOr87FxSqzc8+YUtTrZu6U0bo/66zK9pZnuNYeeUDYlgoHWYihZ1rNn9gdFRKZ8lsmayRerXb+RYXJugdT4U/udOL+pnKAnIYHlMshfKNzfxJBkPI9h3LyHZcdbjsxynuoke62bk4QdQ7w6YX85XUksxNu7G
 f9i8NGid
 wKF8QaCiU56nWvdcijgUJM68o7fWq+kYB3kjqWuK8pBSAgFOAeqwnmCe3PD5wcOtGQ2VE876GUv2qQvgH1aJUPXSZjY39QLIYWsER7iubBXcbQ2DmKu6B4WhM0LmNy6orjuugrBKXoIVAZsDiWT7lbbTuhcu3O+ZJkxinBa+Z9/vK+c6V5rVDV7q1YOj1M6ZiOdyisKG4S2LAAnQndl3VwCg6wUc4isVGzgIDxRpjSWn0fc9Qldts4RzH/SQf8X1MiiShZh/OLRJznU+/0LYVguXJ1TPWa7GVGJyZspDL+nGBBPOddZHBAq7Ydl9UGggEFnHqcsObV1HrEXjqapfj+ttxN6qd+KrcRMtf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 13:15, Kevin Brodsky wrote:
> kpkeys is a simple framework to enable the use of protection keys
> (pkeys) to harden the kernel itself. This patch introduces the basic
> API in <linux/kpkeys.h>: a couple of functions to set and restore
> the pkey register and macros to define guard objects.
> 
> kpkeys introduces a new concept on top of pkeys: the kpkeys context.
> Each context is associated to a set of permissions for the pkeys
> managed by the kpkeys framework. kpkeys_set_context(ctx) sets those
> permissions according to ctx, and returns the original pkey
> register, to be later restored by kpkeys_restore_pkey_reg(). To
> start with, only KPKEYS_CTX_DEFAULT is available, which is meant to
> grant RW access to KPKEYS_PKEY_DEFAULT (i.e. all memory since this
> is the only available pkey for now).
> 
> Because each architecture implementing pkeys uses a different
> representation for the pkey register, and may reserve certain pkeys
> for specific uses, support for kpkeys must be explicitly indicated
> by selecting ARCH_HAS_KPKEYS and defining the following functions in
> <asm/kpkeys.h>, in addition to the macros provided in
> <asm-generic/kpkeys.h>:
> 
> - arch_kpkeys_set_context()
> - arch_kpkeys_restore_pkey_reg()

Looking at this, and wondering about "why do we get registers involved in this
API" I would probably have an interface like:

	arch_kpkeys_enter_context()
	arch_kpkeys_leave_context()

Whereby you return a "struct kpkeys_state" or sth like that.

You could either let the architecture define what's in the state, or
alternatively store some generic data in there as well.

struct kpkeys_state {
	bool entered_context;
	struct arch_pkey_state arch;
};

Maybe the "entered_context" or however you would want to call it could avoid the
KPKEYS_PKEY_REG_INVAL (which confuses me ;) )?

But the KPKEYS_PKEY_REG_INVAL usage confuses me. I understand the
KPKEYS_GUARD_COND + kpkeys_restore_pkey_reg() one, but not the one where
arch_kpkeys_set_context() would return that value.


> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>  include/asm-generic/kpkeys.h |  17 ++++++
>  include/linux/kpkeys.h       | 122 +++++++++++++++++++++++++++++++++++++++++++
>  mm/Kconfig                   |   2 +
>  3 files changed, 141 insertions(+)
> 
> diff --git a/include/asm-generic/kpkeys.h b/include/asm-generic/kpkeys.h
> new file mode 100644
> index 000000000000..ab819f157d6a
> --- /dev/null
> +++ b/include/asm-generic/kpkeys.h
> @@ -0,0 +1,17 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef __ASM_GENERIC_KPKEYS_H
> +#define __ASM_GENERIC_KPKEYS_H
> +
> +#ifndef KPKEYS_PKEY_DEFAULT
> +#define KPKEYS_PKEY_DEFAULT	0
> +#endif

Do we currently expect an architecture to overwrite this? How does this interact
with KPKEYS_CTX_DEFAULT?

Nobody in this patch uses it, so maybe it should be added where actually needed.

> +
> +/*
> + * Represents a pkey register value that cannot be used, typically disabling
> + * access to all keys.
> + */
> +#ifndef KPKEYS_PKEY_REG_INVAL
> +#define KPKEYS_PKEY_REG_INVAL	0
> +#endif
> +
> +#endif	/* __ASM_GENERIC_KPKEYS_H */
> diff --git a/include/linux/kpkeys.h b/include/linux/kpkeys.h
> new file mode 100644
> index 000000000000..0ce0db80b4ee
> --- /dev/null
> +++ b/include/linux/kpkeys.h
> @@ -0,0 +1,122 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef _LINUX_KPKEYS_H
> +#define _LINUX_KPKEYS_H
> +
> +#include <linux/bug.h>
> +#include <linux/cleanup.h>
> +
> +#define KPKEYS_CTX_DEFAULT	0


Agreed with enum.


> +
> +#define KPKEYS_CTX_MIN		KPKEYS_CTX_DEFAULT
> +#define KPKEYS_CTX_MAX		KPKEYS_CTX_DEFAULT
> +
> +/*
> + * ... is used to discard extra arguments - this allows users of this macro
> + * to have set_arg default to void.
> + */
> +#define __KPKEYS_GUARD(name, set_context, restore_pkey_reg, set_arg, ...) \
> +	__DEFINE_CLASS_IS_CONDITIONAL(name, false);			\
> +	DEFINE_CLASS(name, u64,						\
> +		     restore_pkey_reg, set_context, set_arg);		\
> +	static inline void *class_##name##_lock_ptr(u64 *_T)		\
> +	{ return _T; }
> +
> +/**
> + * KPKEYS_GUARD_NOOP() - define a guard type that does nothing
> + * @name: the name of the guard type
> + * @cond_arg: an argument specification (optional)
> + *
> + * Define a guard type that does nothing, useful to match a real guard type
> + * that is defined under an #ifdef. @cond_arg may optionally be passed to match
> + * a guard defined using KPKEYS_GUARD_COND().
> + */
> +#define KPKEYS_GUARD_NOOP(name, ...)					\
> +	__KPKEYS_GUARD(name, 0, (void)_T, ##__VA_ARGS__, void)
> +
> +#ifdef CONFIG_ARCH_HAS_KPKEYS
> +
> +#include <asm/kpkeys.h>
> +
> +/**
> + * KPKEYS_GUARD_COND() - define a guard type that conditionally switches to
> + *                       a given kpkeys context
> + * @name: the name of the guard type
> + * @ctx: the kpkeys context to switch to
> + * @cond: an expression that is evaluated as condition
> + * @cond_arg: an argument specification for the condition (optional)
> + *
> + * Define a guard type that switches to @ctx if @cond evaluates to true,
> + * and does nothing otherwise. @cond_arg may be specified to give access to a
> + * caller-defined argument to @cond.
> + */
> +#define KPKEYS_GUARD_COND(name, ctx, cond, ...)				\
> +	__KPKEYS_GUARD(name,						\
> +		       (cond) ? kpkeys_set_context(ctx)			\
> +			      : KPKEYS_PKEY_REG_INVAL,			\
> +		       kpkeys_restore_pkey_reg(_T),			\
> +		       ##__VA_ARGS__, void)
> +
> +/**
> + * KPKEYS_GUARD() - define a guard type that switches to a given kpkeys context
> + *                  if kpkeys are enabled
> + * @name: the name of the guard type
> + * @ctx: the kpkeys context to switch to
> + *
> + * Define a guard type that switches to @ctx if the system supports kpkeys.
> + */
> +#define KPKEYS_GUARD(name, ctx)						\
> +	KPKEYS_GUARD_COND(name, ctx, kpkeys_enabled())
> +
> +/**
> + * kpkeys_set_context() - switch kpkeys context
> + * @ctx: the context to switch to
> + *
> + * Switches to specified kpkeys context. @ctx must be a compile-time
> + * constant. The arch-specific pkey register will be updated accordingly, and
> + * the original value returned.

Are these arch details and registers relevant? Ideally, we'd keep it very simple
here ...

> + *
> + * Return: the original pkey register value if the register was written to, or
> + *         KPKEYS_PKEY_REG_INVAL otherwise (no write to the register was
> + *         required).

... and here. Not sure if any caller cares about these details. Again, with some
abstract state we could maybe handle that internally.

"Return: the pkey state to pass to kpkeys_restore_pkey_reg" (or however that
function will be called)

> + */
> +static __always_inline u64 kpkeys_set_context(int ctx)
> +{
> +	BUILD_BUG_ON_MSG(!__builtin_constant_p(ctx),
> +			 "kpkeys_set_context() only takes constant values");
> +	BUILD_BUG_ON_MSG(ctx < KPKEYS_CTX_MIN || ctx > KPKEYS_CTX_MAX,
> +			 "Invalid value passed to kpkeys_set_context()");
> +
> +	return arch_kpkeys_set_context(ctx);
> +}
> +
> +/**
> + * kpkeys_restore_pkey_reg() - restores a pkey register value
> + * @pkey_reg: the pkey register value to restore
> + *
> + * This function is meant to be passed the value returned by
> + * kpkeys_set_context(), in order to restore the pkey register to its original
> + * value (thus restoring the original kpkeys context).
> + */
> +static __always_inline void kpkeys_restore_pkey_reg(u64 pkey_reg)
> +{
> +	if (pkey_reg != KPKEYS_PKEY_REG_INVAL)
> +		arch_kpkeys_restore_pkey_reg(pkey_reg);
> +}
> +
> +static inline bool kpkeys_enabled(void)

Is the enabled vs. supported intentional?

> +{
> +	return arch_supports_kpkeys();
> +}
> +



-- 
Cheers,

David

