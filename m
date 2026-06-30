Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7522AC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 09:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3823A6B00FB; Tue, 30 Jun 2026 05:13:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35A266B00FC; Tue, 30 Jun 2026 05:13:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 270616B00FD; Tue, 30 Jun 2026 05:13:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F12616B00FB
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:13:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 725121C6E09
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:13:54 +0000 (UTC)
X-FDA: 84936016788.15.6D44D7C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 892A380002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:13:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=W+spzFSP;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782810832;
	b=dLgDcBtO/2RlxMG7/O7mHnLs+YWRhbEF3Xm/cS1IQNf9V39WD1G9X67kXKnJxP4prQuKxM
	LaEnkH8nKV5FHXa5V1bB/OyibeKSqVsa25xFu+ORgdacdQ+KfVU9iBIic86Z4FX//7HDP0
	4Ldx1nHaha6H0f6xb7D7tGDSb23UqC8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782810832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XawQTOQeMrC2goaYpbqyNPdZ1yS9UOUVP9VgBUrnkUk=;
	b=ph1xh1Exe5NVcIJsOFzL8qX9zlnPaLaVoh7WTscAImGXcVz+IIfaGy8bYxmVi3H8gh3/0x
	xVIjnFVO3rlp4SYBKROOqeON2KvHzj+vxKmUvd05MYT1Vd7Hs60NE3WhxrhS1z/Xj/3TcD
	WMoSOpheXBsW/vQTyVztjRrB+kp39ic=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=W+spzFSP;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1060E2C1C;
	Tue, 30 Jun 2026 02:13:47 -0700 (PDT)
Received: from [10.57.81.132] (unknown [10.57.81.132])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5203D3FAFB;
	Tue, 30 Jun 2026 02:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782810831; bh=xfhzNa7i/skfAP7X8l/W5lXDtIlKtNWwDUgCZO/Necw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=W+spzFSPXCTHtXozMKrEXROXtZhxJU1ZPPwnZbwUuHnyjZLPYrxvGDhFIL3bT4ggq
	 MIMuLnGKJR2VyWXW20lFvLPHd4hXWwG0VjLZkDBmx8IkF/PxK+cQ9Gg40yaSIymMfM
	 rwPOWCXB4qduy/a+rMan2D1x3U+Zv8qM31+xwRAc=
Message-ID: <cc586a87-871e-4b13-a4fd-f7c0757dc602@arm.com>
Date: Tue, 30 Jun 2026 11:13:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v8 01/24] mm: Introduce kpkeys
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-hardening@vger.kernel.org
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
 <70f4dcdf-c45f-47d3-91df-a7897bd86ff4@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <70f4dcdf-c45f-47d3-91df-a7897bd86ff4@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 892A380002
X-Rspam-User: 
X-Stat-Signature: qd1dztooo3epyqwfo1ysaqororghe31q
X-HE-Tag: 1782810832-371586
X-HE-Meta: U2FsdGVkX18wnEdXbdyJw0JwF2zr1cpTST2YXr9A+mXaZNZ40/T6AMq0I9W9PxlqdifsNXxoEEiIb7h2qPumUqqLkQ3petn79I9aeL3NnL+zy82cglGfZRx+GO0NoMHhZR5BQE4QKrSep4YqcDpG5rkxfOoc+/PUPa6NEFKicd6Icas+TW5NrJqMSp3++lWljt1oL6SjnPka/rft9x5trnSxuToaWeYAWH7c3dF0QJpmPm+gEflvCTlUfMK4HnzhWSRuJcrkM/GbbdGM9SJF2yjXzrD7MlwC1fhoWQxzaSrgz4LK/5ivqsFcbT3XGVFqRn3PUUvcRmoJPEt9CnSeLH6D3IVl8tDkV7XhWvd8USN/ObP+OLLPpWYUplp8HHe3B8FfAvlsa0gMzwS+UeWoW5XcQhkBYkn829EYOwlHEFNB328yLiF+cpR70Q1/I7DuUA2t0YrnnCgzMLSC7sTCSGYQUCaAtWmr1ZxBED2goit+jW70I5d8bmvbjLiWkGv/VJGGTODAv5LJNRwPbuoSzDxPaAQrqUR8moCuBTfrTqiosKiH6vVlteOj83kukYQTV4lEPTA46KQAB6zOIa8JPaX5k4rM5vpSwjj35A7611GIWr8lfDRw3g+vvMqnsUMsM8qKvRh366gxo1wivwMTbny6ay1N3A0jmfibMqVEO20MfEO13+W3gWHs2uL1soQO7avqmVvTP+ZTLjZq0jaySCgC8A+zpTkOj+8Bmgt4BCnB3IpxtTjtx5P/X8hQuEhbwMVgxhUCIVCaB9zPZJCjhCx4v1Rw4kxN5ps0dnKGau761K/pKgYMUri2iiWxHdUas/JR4yZt95wb7a/bs1XrRKXx8hsvwWHUI7IL5fmZAw/LUXsu9+27r46rKJfd7GyloUgBBd6lwWlhOHOzVpMY8JnAq5uGk4w9O31BnlcJozRwO1JPwxSMZn1Qi6SQXODdhFlGpls/N6aQW3wzttY
 YuHYIXgE
 qzgjVWJ/UQg4OG4jgUNrOGyXCpcBPcFH9Lrtuf7lLg+JDYr3B8BnJNnE+MJWSCDo0uaA15QHWHARCy5Qid9Ifp6gu+eRXUc0SJhwb0nGvy1XB5kB37/wrShyxJQp07TKQSetQBrbnW5ry0rdSPHW+v6q0lev2Jrz2QQ9HwVHYo8BDW/0IRr2xqfHlocc4BUAffxpfm3YDaMVQzhmE705fANmdQWfUdmyMfsuEZ+xo4C3lsVqcGEI9ewwmfJU3SDajO5WUoWF3k+6ZXgRh+zsZylzgQhCc42ZDx8ILT8ln43RqsDpohBxjFLRA+oG5DC05Ae3B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16/06/2026 17:19, David Hildenbrand (Arm) wrote:
> On 5/26/26 13:15, Kevin Brodsky wrote:
>> kpkeys is a simple framework to enable the use of protection keys
>> (pkeys) to harden the kernel itself. This patch introduces the basic
>> API in <linux/kpkeys.h>: a couple of functions to set and restore
>> the pkey register and macros to define guard objects.
>>
>> kpkeys introduces a new concept on top of pkeys: the kpkeys context.
>> Each context is associated to a set of permissions for the pkeys
>> managed by the kpkeys framework. kpkeys_set_context(ctx) sets those
>> permissions according to ctx, and returns the original pkey
>> register, to be later restored by kpkeys_restore_pkey_reg(). To
>> start with, only KPKEYS_CTX_DEFAULT is available, which is meant to
>> grant RW access to KPKEYS_PKEY_DEFAULT (i.e. all memory since this
>> is the only available pkey for now).
>>
>> Because each architecture implementing pkeys uses a different
>> representation for the pkey register, and may reserve certain pkeys
>> for specific uses, support for kpkeys must be explicitly indicated
>> by selecting ARCH_HAS_KPKEYS and defining the following functions in
>> <asm/kpkeys.h>, in addition to the macros provided in
>> <asm-generic/kpkeys.h>:
>>
>> - arch_kpkeys_set_context()
>> - arch_kpkeys_restore_pkey_reg()
> Looking at this, and wondering about "why do we get registers involved in this
> API" I would probably have an interface like:
>
> 	arch_kpkeys_enter_context()
> 	arch_kpkeys_leave_context()
>
> Whereby you return a "struct kpkeys_state" or sth like that.
>
> You could either let the architecture define what's in the state, or
> alternatively store some generic data in there as well.
>
> struct kpkeys_state {
> 	bool entered_context;
> 	struct arch_pkey_state arch;
> };
>
> Maybe the "entered_context" or however you would want to call it could avoid the
> KPKEYS_PKEY_REG_INVAL (which confuses me ;) )?

Yep that would do the trick. And would make Sashiko happier too, using a
magic register value isn't great ;)

> But the KPKEYS_PKEY_REG_INVAL usage confuses me. I understand the
> KPKEYS_GUARD_COND + kpkeys_restore_pkey_reg() one, but not the one where
> arch_kpkeys_set_context() would return that value.

Right, that's used in a follow-up series to protect struct cred, so that
unnecessary switches are avoided in case of nesting [1]. I wonder if I
shouldn't fold that patch into this one. I don't think nesting is likely
to occur in this series, but the extra branch probably doesn't add much
cost either (it's easily predicted).

[1]
https://lore.kernel.org/linux-mm/20250815090000.2182450-2-kevin.brodsky@arm.com/

>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> ---
>>  include/asm-generic/kpkeys.h |  17 ++++++
>>  include/linux/kpkeys.h       | 122 +++++++++++++++++++++++++++++++++++++++++++
>>  mm/Kconfig                   |   2 +
>>  3 files changed, 141 insertions(+)
>>
>> diff --git a/include/asm-generic/kpkeys.h b/include/asm-generic/kpkeys.h
>> new file mode 100644
>> index 000000000000..ab819f157d6a
>> --- /dev/null
>> +++ b/include/asm-generic/kpkeys.h
>> @@ -0,0 +1,17 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +#ifndef __ASM_GENERIC_KPKEYS_H
>> +#define __ASM_GENERIC_KPKEYS_H
>> +
>> +#ifndef KPKEYS_PKEY_DEFAULT
>> +#define KPKEYS_PKEY_DEFAULT	0
>> +#endif
> Do we currently expect an architecture to overwrite this? How does this interact
> with KPKEYS_CTX_DEFAULT?

That's a fair point, pkey 0 being the default is pretty much hardcoded
and I don't see that ever changing.

The value isn't coupled to that of KPKEYS_CTX_DEFAULT, which is purely
symbolic.

> Nobody in this patch uses it, so maybe it should be added where actually needed.

Agreed, the ifdefery can be removed.

>> [...]
>>
>> +/**
>> + * kpkeys_set_context() - switch kpkeys context
>> + * @ctx: the context to switch to
>> + *
>> + * Switches to specified kpkeys context. @ctx must be a compile-time
>> + * constant. The arch-specific pkey register will be updated accordingly, and
>> + * the original value returned.
> Are these arch details and registers relevant? Ideally, we'd keep it very simple
> here ...
>
>> + *
>> + * Return: the original pkey register value if the register was written to, or
>> + *         KPKEYS_PKEY_REG_INVAL otherwise (no write to the register was
>> + *         required).
> ... and here. Not sure if any caller cares about these details. Again, with some
> abstract state we could maybe handle that internally.
>
> "Return: the pkey state to pass to kpkeys_restore_pkey_reg" (or however that
> function will be called)

Yep agreed.

>> + */
>> +static __always_inline u64 kpkeys_set_context(int ctx)
>> +{
>> +	BUILD_BUG_ON_MSG(!__builtin_constant_p(ctx),
>> +			 "kpkeys_set_context() only takes constant values");
>> +	BUILD_BUG_ON_MSG(ctx < KPKEYS_CTX_MIN || ctx > KPKEYS_CTX_MAX,
>> +			 "Invalid value passed to kpkeys_set_context()");
>> +
>> +	return arch_kpkeys_set_context(ctx);
>> +}
>> +
>> +/**
>> + * kpkeys_restore_pkey_reg() - restores a pkey register value
>> + * @pkey_reg: the pkey register value to restore
>> + *
>> + * This function is meant to be passed the value returned by
>> + * kpkeys_set_context(), in order to restore the pkey register to its original
>> + * value (thus restoring the original kpkeys context).
>> + */
>> +static __always_inline void kpkeys_restore_pkey_reg(u64 pkey_reg)
>> +{
>> +	if (pkey_reg != KPKEYS_PKEY_REG_INVAL)
>> +		arch_kpkeys_restore_pkey_reg(pkey_reg);
>> +}
>> +
>> +static inline bool kpkeys_enabled(void)
> Is the enabled vs. supported intentional?

That's a fair point. It is intentional for
kpkeys_hardened_pgtables*_enabled() in patch 11: on arm64,
arch_supports_kpkeys*() always return true if POE is detected, while
kpkeys_hardened_pgtables*_enabled() also require
CONFIG_KPKEYS_HARDENED_PGTABLES=y.

For kpkeys_enabled() the condition is CONFIG_ARCH_HAS_KPKEYS=y, which is
always true if we support POE. So it would be reasonable to rename it to
kpkeys_supported() (and maybe more intuitive, since it doesn't imply any
functional change).


Thanks for the very useful suggestions and sorry for the late replies!

- Kevin

>> +{
>> +	return arch_supports_kpkeys();
>> +}
>> +
>
>

