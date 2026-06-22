Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9804ACD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 13:16:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FA9A6B0093; Mon, 22 Jun 2026 09:16:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AB046B0095; Mon, 22 Jun 2026 09:16:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59A676B0096; Mon, 22 Jun 2026 09:16:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B1516B0095
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:16:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B17A21A016B
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:16:21 +0000 (UTC)
X-FDA: 84907597362.23.7BD96E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id F40F4C0002
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:16:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LVFFHQd1;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782134180;
	b=aP86R6d2x8WzRzo1EtUz+KSqbCaANkx9SSNBdHsAmnam2REuvd5shZ9/ZmN90WV5VAjHbL
	G4FJo4ZQVu7TYX542CbUo9zs4MH7ZMeaP21mxO8U+SgrTWVdQQeeOZNS1FpzHoksABHKyh
	4S+tN5a1EWNBSdWJdn4fL0tLDvTEI6I=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LVFFHQd1;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782134180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lgvQzYjbMrpc1MMyior1P3ZPdYtIuPkBiGx7cWNFLN4=;
	b=HueCc6/Odq3fbXAkOatg+M+/DxT0kng8S8zPLmYbGVnqBLniT4dYMSDSkdTA3ovz35JOH8
	01Wk0RSR6HSzQ1lIqmmJGtsEaeA5I5ErbzAfTTtBn87aiNY5Svh/eowVl+KoIuG5BsRwhx
	o6grx6EK2JJsmPcyqpUJ8LPqumrOhLo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 75BB5601F6;
	Mon, 22 Jun 2026 13:16:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC02A1F00A3E;
	Mon, 22 Jun 2026 13:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782134179;
	bh=lgvQzYjbMrpc1MMyior1P3ZPdYtIuPkBiGx7cWNFLN4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LVFFHQd1hVV3xyaHdbvqy1IUptTyefGIMhFmpKHheR2hHi6h8Pupkh+49sWuI7kTB
	 PRd5VH4p0hJ8/a+656aexGPb9vnMnVEhMzYMigNWoV/vj/BFqdF/hmRFySwJJcj+ix
	 TxzLge8swBRCE3yYyAyZ7mSR16RlNyj6gb04oPEb02rgmljsIcP3fU+hgoQLycwk7y
	 38rtzXCtQk/nPDAW1c+OaHFUfiOotUYFisfnzyk46xCBG3mSBC6r97s9nCD0U40zNa
	 tQEOsfzjDo5uayhGH/KCENJxRX+DngaoamEa08AwIJ0JlqEVCOaNIE+BbmJJPHEUoj
	 eDeFxlZqAgW/Q==
Message-ID: <e334c595-92ab-4eb9-a096-35602d57ae6d@kernel.org>
Date: Mon, 22 Jun 2026 15:16:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v8 04/24] arm64: Introduce por_elx_set_pkey_perms()
 helper
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
 <20260526-kpkeys-v8-4-eaaacdacc67c@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260526-kpkeys-v8-4-eaaacdacc67c@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F40F4C0002
X-Stat-Signature: zrs5oyecw7k1ggai7kzaefbezhisdi6p
X-HE-Tag: 1782134179-558366
X-HE-Meta: U2FsdGVkX1+iJ4bvOxZ8ujmCDU6+W+gVIKWHwM4/G6WDOQ53StEyffEjThfvCx/0uI593Jv8Fksw+gOTbLYMK4a3G4MePFmG44jaXmrSw8Dx2toEwyhY74KGbqRe1T1mqcAj1bhLKhI5tehRGMQc0oae0NM2AJvnHyiJ0BGM+BYqwu7s+G72rgHF0/nyQeVBJWul0pRQJ6FyVlD5jQ+C+iqTrNvMAX/G2aQr+3yzJ+VUIAxKa7A6JJ8AQhhZCQEjtyUx2WptQYEE737PinGOutB9qTmlwRXYxtWTxbqNWo/gpWxed0Ln9hkffz4+BOFj0c1KfQ7SmkC9RtWXEy6DaH68a+q9FJYVZBmqK8S7tltZMPxxoMFfeHP9g3mpOITjqbfqiHPUxaa8TEaV+HwsFgWh/RgCwGsjZm9HwIok2RH7PLPTXmJ+sY9DYTj1OCing7Gm7X1GOjvrfzocie19LeaPKsA+/MnKzLbiFxscDq+n29hCn3lz1KOEDpOmb40a++sTBpbgS4rzL6PIae7T+gzx7n/+5N1NmkuA7JJLPNK6CPkxHd6Khp4fs6W/3c/rF8HzmSvU5TKqCprXd5KfjyYXSWKSeYaSeuC8Uh2bcuD8b5HhrF/NwQ55s/R5I+c39lnOEOUu6Z9UZWt2LtO/nc+CU76ZzIZg9mTecZzVzo/WCXIp/7wMjtDaesuj1HIhTTmFb43mT1QzNtJPsT2q8U9UHA+mZoKs4pUQgp74tb4qrnw9mLY2VkYRuBaQ7h7yMrza3+eTxUNk9NpczxKAKxhsrRC+gL2TjWaocfw6rd5TQIuqiDy1kA1fKtb9fymC13cNTaXhIopJAda9Bbj3INElHpRzhNgcjdyZ9+1bA6v6SZ1JO9Lc5Hy/RjJMNXnsEqhBSQoqIUzmyMuEwVPFKUMLqvzPQgGEwV4bSQSQdACOZtqr4VOYJZ5MWaSDddysqJfhyCI2guJrU2cenwT
 5i+pwQSZ
 ZcjYqylyUzAWgKR5OK17zg5+bFGODqmY/cNMItiJfLEP5TNuwD6UP4aS7u1wa7vE/feBI8hWe9Pzpz1GPCCPIUbVjdDt/Xaim4WwQFPYgTkRyJTrp8VnH0HhX4j8kCE23ZNe5E0giSA/0SzoAQjzWV/EmiE4C/732DgWWBSwc/qGqyKzIP7QiH9ieolQNiyh9lzPGTOwlGcTrCjtT0XeAlUxLvH2VO/OlG4HuKKX0osFqxQTPHTzfQtL+HrzKeyca2GxwlVarZWQhj+CSmDhKGdP8oa5/AQMPs4ePBFOYzdUh/QlPQcikJ9tSutmNRC6Aw+cDiqMVy7I2kZUwuDRzMgOFkIQSEUxobOv0Dd9tLZvfS6smpKR5zdPdIkdtHnYAugbm4doWIZNd7QCo6J0dQOIX1bm5Wn1ZKWJ5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 13:15, Kevin Brodsky wrote:
> Introduce a helper that sets the permissions of a given pkey
> (POIndex) in the POR_ELx format, and make use of it in
> arch_set_user_pkey_access().
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>  arch/arm64/include/asm/por.h |  7 +++++++
>  arch/arm64/mm/mmu.c          | 26 ++++++++++----------------
>  2 files changed, 17 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/por.h b/arch/arm64/include/asm/por.h
> index d913d5b529e4..bffb4d2b1246 100644
> --- a/arch/arm64/include/asm/por.h
> +++ b/arch/arm64/include/asm/por.h
> @@ -31,4 +31,11 @@ static inline bool por_elx_allows_exec(u64 por, u8 pkey)
>  	return perm & POE_X;
>  }
>  
> +static inline u64 por_elx_set_pkey_perms(u64 por, u8 pkey, u64 perms)
> +{
> +	u64 shift = POR_ELx_PERM_SHIFT(pkey);
> +
> +	return (por & ~(POE_MASK << shift)) | (perms << shift);
> +}
> +
>  #endif /* _ASM_ARM64_POR_H */
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index dd85e093ffdb..493310cf0486 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -2339,8 +2339,8 @@ void __cpu_replace_ttbr1(pgd_t *pgdp, bool cnp)
>  #ifdef CONFIG_ARCH_HAS_PKEYS
>  int arch_set_user_pkey_access(int pkey, unsigned long init_val)
>  {
> -	u64 new_por;
> -	u64 old_por;
> +	u64 new_perms;

You should spell out the renaming of the variable.

Given that perms is 4bit per key, should we use a u8 for it instead?

> +	u64 por;
>  
>  	if (!system_supports_poe())
>  		return -ENOSPC;
> @@ -2354,25 +2354,19 @@ int arch_set_user_pkey_access(int pkey, unsigned long init_val)
>  		return -EINVAL;
>  
>  	/* Set the bits we need in POR:  */
> -	new_por = POE_RWX;
> +	new_perms = POE_RWX;
>  	if (init_val & PKEY_DISABLE_WRITE)
> -		new_por &= ~POE_W;
> +		new_perms &= ~POE_W;
>  	if (init_val & PKEY_DISABLE_ACCESS)
> -		new_por &= ~POE_RW;
> +		new_perms &= ~POE_RW;
>  	if (init_val & PKEY_DISABLE_READ)
> -		new_por &= ~POE_R;
> +		new_perms &= ~POE_R;
>  	if (init_val & PKEY_DISABLE_EXECUTE)
> -		new_por &= ~POE_X;
> +		new_perms &= ~POE_X;
>  
> -	/* Shift the bits in to the correct place in POR for pkey: */
> -	new_por = POR_ELx_PERM_PREP(pkey, new_por);
> -
> -	/* Get old POR and mask off any old bits in place: */
> -	old_por = read_sysreg_s(SYS_POR_EL0);
> -	old_por &= ~(POE_MASK << POR_ELx_PERM_SHIFT(pkey));
> -
> -	/* Write old part along with new part: */
> -	write_sysreg_s(old_por | new_por, SYS_POR_EL0);
> +	por = read_sysreg_s(SYS_POR_EL0);
> +	por = por_elx_set_pkey_perms(por, pkey, new_perms);
> +	write_sysreg_s(por, SYS_POR_EL0);

Was wondering whether to move reading+writing of the register into the same
helper, but you cannot reuse this exactly the same way for SYS_POR_EL1 as it seems.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

