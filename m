Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86919606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 15:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=QkPGJIg2
Received: by kanga.kvack.org (Postfix)
	id 90EC36B05BE; Wed, 11 Nov 2026 10:19:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E5E36B05BF; Wed, 11 Nov 2026 10:19:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 823876B05C1; Wed, 11 Nov 2026 10:19:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5E12B6B05BE
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:19:04 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DAD22160316
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:19:03 +0000 (UTC)
X-FDA: 85423196166.24.5813E39
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id BA1112000F
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:19:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QkPGJIg2;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794410342;
	b=Gf6leldFXwcw/lZQXpc2hEnbiTsaVeSbuoUL/+296yntjHIJYRcZ9LoWNvP/1P7hb5usG4
	GzTP1T1H4nzXBIpFRC5BuxqmebBKvrzaVGuI4igVEDrbA2q3xrR8swwckwrcItmWuPP9rJ
	NAnMKm845B4III9tNhrIxilxwN5Trf0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QkPGJIg2;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794410342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KRk3hY6OxrgIUUvXnGsk+3o0qrfqVOAaie3G63vpVoQ=;
	b=D1lXySX9kpf2b7DhPMk+XWVpLT9+TRGrTYgUz8DrcTmZTqpRJmmYCCS9GrluqeU1Lum63q
	LLbE5L4ZGSo9j/Ls5aM/ODaR8IR0G3MJh0YFbVSnSKGIT4q1JxSmB/5SzDeyCw3mkLnAf2
	cGBajC8S9594MX14cJ0hgHfGPEEx1ks=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 75D3B1576;
	Wed, 11 Nov 2026 07:18:57 -0800 (PST)
Received: from [10.43.20.72] (e126510-lin.lund.arm.com [10.43.20.72])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4F7853F632;
	Wed, 11 Nov 2026 07:18:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794410340; bh=K/XoUAuP8agS+YAJXtE2UoZzMy+glW6cZvjG+mAtTjI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QkPGJIg2CJOeLzjtVDkULCNadPWNyrorR/1C3mAUX8c/pyOkkWvDHG9G3CGYEhMev
	 qUJgES66VYZtNmeSHicJvJWPKlisEzf+05LgJxfpCQgOaimgsIvi/LnEu/6LHVJoQQ
	 7r13JTYY6omaLAN2C8gYibM2JsE67D2KGh3HWRew=
Message-ID: <fe64be42-03aa-43fc-bdcd-e6b581eb9984@arm.com>
Date: Wed, 11 Nov 2026 16:18:50 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v10 04/22] arm64: Implement asm/kpkeys.h using POE
To: sashiko-reviews@lists.linux.dev
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Ard Biesheuvel <ardb+git@google.com>, Andy Lutomirski <luto@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org, x86@kernel.org,
 Ira Weiny <iweiny@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
 <20261109-kpkeys-v10-4-aa6c4d9603bc@arm.com>
 <sashiko-outbox-207318@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <sashiko-outbox-207318@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ue4beonhs41pq7umdap5djn8kxf8rkm9
X-Rspamd-Queue-Id: BA1112000F
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794410341-624877
X-HE-Meta: U2FsdGVkX1+kkdt5ZdPZZ0upTVDT7sgER9Q76LlxxKM0gCyUlJ7gt80QUvJRh1PWPVHJDYNS3yFR+aw+O+8BDk7myBheEwhh8PGX+xmgdv6cUb+bdUZfEYbxZlss+6/TEE4ZQPMIihAXtOa1CbsefLtIOEQQYpZS1+Ojd1VYnhDGhB8Z3zvMrQ5P7yyQsmP3uU1mUXvrV3ZCzqIZCGYRX/b4P4SePZlo0//lm8rolLbn3a7Wjq2gX29zSJwJ6lJK/F0hY2Ki8pnXWsWuFwuHSbjslXk3niyYFSYo3c/9IhmmVnnxnBJM5MRzurYjQ4IIcoRpLR1yJFYsQ9spzF2OnmriTo2nxwz9syMI2qve6q/Ydl1r3WKEtbNZq5s/Q5pS40YVBq2Sk4pJgrHJVuxTdC43VnVzdwCaGtEJdx+Z01+UqiuLaQWOnSF+2esk26j7jiWA82WfEGqbsH8JUlJFxrYXg+m2aXgN0UBL3Kcu7f/L/AyqT804H3OW88PSWttmw4qC7F/PA1Nf7+z5VeDykGC3XP1hqexMWm9qZWwcpU917WUbwuiVw59tDtOyenolty1vzQJkNEotP5SeoIeKkkqqrRniyCB1EmZi0wmfLFMJvPlGXIlDmTfoMQSyfA4wX+khQvQsNTMjctuQUB4dFtVclV9+95SJ6t5F1xKZWYo2PcUwxezPOGc6Bu4vy5datgB4M6fZi1OKzbSGWOIAheP7fJB9elTP0d1vhMMQkbKPMpsX3rt5ACW564LX/qEVlhMW7qcQIRMpHAyIDdOdZbYYDirKS9gqcY5RoMprk8tH7Y52BhkeTfhJp+wFFD4PLhOMx7hnazSgE/xGQcH/XgsSKyX2UrDbvQgNGJON4VvdVPp65GXioaQHj2tsrBosjXo6eJRTEnolbFaNbS7CcIZAkAQszsVE+FqnTha2fJbsl1bMpQciYUFt4t1j6yaH0jdfImL+1P+P1XCk5Jc
 +uoZyCM+
 deu6dswa2wzxK50G2Fgq+wGZBBfWWZAQx6ZWlBuZDU6mGI61udV4GEFfAdB7Z31g+63oFDuME0tRvwgrOtJJCkIBm8/LZvDzO+VHLwHokLCvViZv9sWP/U4bXgCJUDMZlc6mXG05WVj+SkTvuTwfXyMeoWcVUNhEQJ/cFJhEo6mj9b2fhDRv6QOJ0WpcaIVZe4Yo2TZ10j/ZTx5kOsPeplVwNCAD+uFhWip5nNUDOoqUkB3GWnCfhU47ZdpfayTJyVSF2njnPexDSwZdas4/p19sfrjHZ3Nh0iWfIGsru2/u42RHZE4rjC000YWO2aqcxZS3fLkEJkFOGO5B6HBGN29Fc7E02lACyRX5bK70ZM+7PdC/bwelmseyLYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/11/2026 17:02, sashiko-bot@kernel.org wrote:
>> [...]
>>
>> +#ifdef CONFIG_ARM64_POE
>> +
>> +static inline u64 por_set_kpkeys_context(u64 por, enum kpkeys_ctx ctx)
>> +{
>> +	por = por_elx_set_pkey_perms(por, 0, POE_RWX);
>> +
>> +	return por;
>> +}
>> +
>> +static __always_inline void __kpkeys_set_pkey_reg_nosync(u64 pkey_reg)
>> +{
>> +	/*
>> +	 * Writing to POR_EL1 potentially affects all memory accesses, so
>> +	 * use barrier() to ensure load/store instructions cannot be reordered
>> +	 * past the write.
>> +	 */
>> +	barrier();
>> +	write_sysreg_s(pkey_reg, SYS_POR_EL1);
>> +	barrier();
>> +}
>> +
>> +static __always_inline
>> +bool arch_kpkeys_enter_context(enum kpkeys_ctx ctx,
>> +			       struct arch_kpkeys_state *state)
>> +{
>> +	const u64 prev_por = read_sysreg_s(SYS_POR_EL1);
>> +	const u64 new_por = por_set_kpkeys_context(prev_por, ctx);
>> +
>> +	if (prev_por == new_por)
>> +		return false;
>> +
>> +	state->por = prev_por;
> [Severity: Medium]
> Should this block be guarded by CONFIG_ARCH_HAS_KPKEYS instead of
> CONFIG_ARM64_POE?
>
> include/linux/kpkeys_types.h only includes <asm/kpkeys_types.h> (for
> struct arch_kpkeys_state) and defines enum kpkeys_ctx when
> CONFIG_ARCH_HAS_KPKEYS is enabled:
>
> include/linux/kpkeys_types.h:
>     #ifdef CONFIG_ARCH_HAS_KPKEYS
>     #include <asm/kpkeys_types.h>
>     #endif
>
>     #if defined(CONFIG_ARCH_HAS_KPKEYS) && !defined(__ASSEMBLY__)
>
>     enum kpkeys_ctx {
>     	KPKEYS_CTX_DEFAULT = 0,
>     	KPKEYS_CTX_COUNT,
>     };
>
> Because CONFIG_ARM64_POE is enabled by default on arm64 and does not
> select ARCH_HAS_KPKEYS until the later commit "arm64: Enable kpkeys",
> when commit "arm64: Context-switch POR_EL1" includes <asm/kpkeys.h> in
> arch/arm64/kernel/process.c, the build fails with incomplete type errors
> for enum kpkeys_ctx and struct arch_kpkeys_state, breaking bisection.

Will use CONFIG_ARCH_HAS_KPKEYS instead. The idea was that this
implementation is POE-specific, but in fact another implementation would
likely be runtime-selected so using the generic #ifdef makes more sense.

- Kevin

