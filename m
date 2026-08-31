Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2FF5C624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 15:25:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 603866B0096; Mon, 31 Aug 2026 11:25:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B2246B0099; Mon, 31 Aug 2026 11:25:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C8EC6B009B; Mon, 31 Aug 2026 11:25:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F4976B0096
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:25:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 44BE38019F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:25:21 +0000 (UTC)
X-FDA: 85161938442.08.3505396
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 144ED1A0006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:25:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="ERM+z1j/";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788189919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xm7IJp2XIGQfywvQEJWiSm4YcnWVO4DORE2TtOx8jNo=;
	b=YOfzvi91+oMn0pro8aaFGVPGEtFxm8+tNiy0puDwRTpQSIDITX8whpz/zZumHcm3NLlv2I
	TP6TLb2k4QTnF1gRjKE8enNdy/wfYUEB0CuyYChqCqpcBvEIJMWqGosJEl/4GRdj836kTS
	wCOo363tWuE93LpSkb0ZGAyuSF3P5kE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788189919;
	b=5U3Opdq1FgFGiDvbNyTr3NyhMRdmggbjasVfZqenpSWn35uOaS3Ut3C6aZgOXr1TQ9nXz/
	xY9NBJXFFMY9Rcbb1Oq1P/N5TEDyLuZPL7LcvSRQlqzC+Y7ypeuZL0l43AxovEMzV1VhiU
	Sot6+V7AxYXdGHaaLA2A8Gxw10fFz3A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="ERM+z1j/";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 13B0814BF;
	Mon, 31 Aug 2026 08:25:14 -0700 (PDT)
Received: from [10.57.6.141] (unknown [10.57.6.141])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 09D9D3FAA1;
	Mon, 31 Aug 2026 08:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788189917; bh=eK4lq3SDbX0dW+5hYaKysf1ohyjSSfRIS1hTL0ZfAV0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ERM+z1j/JBwlg2fAxsfL8eZW4gRaVWX/j5qdnj1kgq3pJy6J4eZ8K21f5sScC6ngd
	 66BaVsUlLVYQU2k0g7DZbCjiISMySQ9GE19fNRsy0Eu1baoXaH+Cp05TisgpJMke/3
	 R/0L4fm8uy9+eRa96GTQNDL+1cNFc3qZl+uTNaHs=
Message-ID: <25ca0804-f864-4836-a3ed-58e997f265c8@arm.com>
Date: Mon, 31 Aug 2026 17:25:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v9 01/25] mm: Introduce kpkeys
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-hardening@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>,
 Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, Linus Walleij <linusw@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <20260818-kpkeys-v9-1-743ad31b2c8f@arm.com>
 <f082aff3-ec63-48fa-94c5-159ca0c5a33e@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <f082aff3-ec63-48fa-94c5-159ca0c5a33e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 144ED1A0006
X-Stat-Signature: ksktufgefymsqmudxettoatuzji1e6ax
X-Rspam-User: 
X-HE-Tag: 1788189918-94629
X-HE-Meta: U2FsdGVkX1/HhwY6GKueCH5XqVoQoeM8e70iXbuVcohtg7cOoxvrOBfEuPAo6T+dEf6qf2LOe//e1XyeUFytKUgiAPQ6gwLlkd8/SHXRcOoUZmJsig9b899a71+J4qtfnQafwZnX4UUgambgWtK30y87TvEAgZR8ISzBO5/ic4srR3+nMPbJHv2p80I7UPtznF0GW1MmYi3VsvOMEG/85cdydpFUP01LrdAKmE3Tf5iVO4k1S7CQQuGRKxOmRvLtGw6YCrq8EP+MKTLHhUEUo4lSBP6vAUZjGaTg/PZKyT9ZgAvYjxATsljWHODthNran/v2OkJGG3m+hYOl3xa7ygkvh/oPSROiHEOpBueDtVBfUFxsWXrohu6FsND7f3WmoDGrVHvxZ1L+kJE81UWzmeOXnHLS99DtlJwHDQmIUr8Ce2xZ/zA0Z6x0T6+2KGPfU33ps70BxL2Xdif3mG6BmdovLA2NHxZR1vNoIcsGw0cew8N4pO0rwUlvyVH5nb24U+/yJD7NeXwgm1eu54fxVdWqMiJIDF1hYRf3j6EO9cqfMjsQ/1l0orOqDTUvUxOmiRCtQSDiqNY0bZbhvuSKq2Ek+yY+R2hXMAytAv9Po5XvtcPMqNGgTlpXlpf/PTOPiAlZAtU4hILKQ1gwsevqOvWRHIfDkLYW5BYwscPeaBiMDRwH+QsX/gIOEdV0S+coJAy3+f5pAjr1miZc+UiWrY5s8OwaTXs6Yu5QRlDmF8Wp6O70JzmvA9qugdS7AKzZV+KXfZXNeUuUz9fD7zqa6KIsbEAa1zKH1RvrO8/53ogNDmpBiSeJxe8Ta7axUigA8kut4TA1OpmLD8wj7clX8HwqhJWddZuwEtYG0N5kU4rynzH1jAc8NpiaEoR8sqRxtb6jidKKzDuP+2jCPsOCshckNoCOdCcYG8dxBZKIXuU84Spz6HC9AWSmMULHOSWCSazapjEYDBnvSrZMmsr
 VfEQeSln
 6vjS6TuAlQMrIW3K2LbuRf6g72U9H7jbxEZwq10LguoGS8FyM2S+GrFlA9yipp31++2OmGQLPBaxyRpMMlsBtYLqSCzmYyM9jxprmdIHTm/fLPmDZJDFefR8dxDEApOy51FgboQyDhKCPI+kZNoTQG3B2fvNRjpQBsEEnb/x1iCGe1TNU7ikrjHGyZCd+XWokrhsw7u7EJRP9fiSXdfJ9CMbHsx6R6LgzbK6+HIxdZgkY83sHuCk50dXGuq7yTj0aIb33
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27/08/2026 20:00, David Hildenbrand (Arm) wrote:
>> [...]
>>
>> +/**
>> + * kpkeys_enter_context() - enter a kpkeys context
>> + * @ctx: the context to switch to
>> + *
>> + * Enters the specified kpkeys context. @ctx must be a compile-time constant.
>> + *
>> + * Return: state to be passed to kpkeys_leave_context().
>> + */
>> +static __always_inline
>> +struct kpkeys_state kpkeys_enter_context(enum kpkeys_ctx ctx)
>> +{
>> +	BUILD_BUG_ON_MSG(!__builtin_constant_p(ctx),
>> +			 "kpkeys_enter_context() only takes constant values");
>> +	BUILD_BUG_ON_MSG(ctx < 0 || ctx >= KPKEYS_CTX_COUNT,
>> +			 "Invalid value passed to kpkeys_enter_context()");
>> +
>> +	return arch_kpkeys_enter_context(ctx);
>> +}
>> +
>> +/**
>> + * kpkeys_leave_context() - leave a kpkeys context
>> + * @state: state returned by kpkeys_enter_context()
>> + *
>> + * Restores the state saved when entering a kpkeys context. If no context was
>> + * entered, this function does nothing.
>> + */
>> +static __always_inline
>> +void kpkeys_leave_context(const struct kpkeys_state *state)
>> +{
>> +	if (state->entered_context)
>> +		arch_kpkeys_leave_context(state);
> state->entered_context is a common code variable, but it's not set by
> commoncode. Is there a reason?

Not a good one, agreed the asymmetry isn't great.

> IOW, should arch_kpkeys_enter_context() only return the arch parts, and
> entered_context would be set in common code?
>
> Also, should entering bail out if the context was already entered.
>
> Last but not least, when would we expect to call kpkeys_leave_context() but the
> context was not entered?

It may be worth clarifying that this is not the same situation as lazy
MMU mode, where the state is thread-global. Here the state is supposed
to be on the stack and you should never have nesting or unmatched
enter/leave calls for a given kpkeys_state. (I could certainly add some
VM_WARN_ON_ONCE() to check these invariants, like in the lazy MMU API.)

The other difference is that only arch code can decide whether we need
to enter that state, as this is based on the value of the
(arch-specific) pkeys register. 

> If this is really arch-specific stuff, probably it should go entirely into arch
> doe. If this is common code stuff, likely it should be maintained entirely in
> common code.

The decision is made by the arch, but I think all architectures would
want this behaviour. So we could have:

    bool arch_kpkeys_enter_context(enum kpkeys_ctx ctx, struct
arch_kpkeys_state *arch_state);
    void arch_kpkeys_leave_context(const struct arch_kpkeys_state
*arch_state);

It's a little less elegant because the state to be set now needs to be
passed as an extra argument, but maybe that's better encapsulation. It
also has the advantage of removing the dependency on struct kpkeys_state
in <asm/kpkeys.h>, so we could get potentially get rid of the separate
<linux/kpkeys_types.h>.

The alternative is to make the entire struct kpkeys_state arch-specific
and move all the handling to the arch helpers. Currently the difference
is academic, but when other architectures implement the interface this
could lead to undesirable discrepancies.

> Overall this looks much cleaner to me compared to what I reviewed the last time
> (was that v8? I don't remember :D )

It was indeed RFC v8, and thanks :D

- Kevin

