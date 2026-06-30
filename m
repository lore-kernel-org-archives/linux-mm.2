Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E3CBC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 09:15:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 310636B00FE; Tue, 30 Jun 2026 05:15:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E82A6B0101; Tue, 30 Jun 2026 05:15:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2276C6B0102; Tue, 30 Jun 2026 05:15:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F11826B00FE
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:15:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 75D8CC1B77
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:15:53 +0000 (UTC)
X-FDA: 84936021786.23.9A2F2C2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 821561C0005
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:15:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Hnex8kTI;
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782810951;
	b=6WiCy5oTvG2u+pVD7IGSyHN78HjeM9njJIoXCXEE8AyomUP6uD70vJx5s7Tls/Ch+TO7R6
	uMUKDU0rgJbBBuDN2eT7Dwgw44fEdlH2KXuk6ZKFV47mM9WuVXbOOZ4m83eXKypOawRdMA
	jKF2By4p5UfTVf5hzXx0WlTCmc09Y9Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782810951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cVi0bfnm6CkyWOx2B3ngEmCvXtH++YDEdZa8Kmvr0VI=;
	b=qvyFuPLAipAtVwzQifcbIWoDMaUjJ4s+k16/Wg7kysTSiesSv4ITNa1mztB1p7XOWBQaiR
	N3UyJ5RZyScuH5y6xg3U1P20haskOQxYtFXhcoycPGHS2Ww25JROr6s+V0Rx5Vkgtykr0v
	LBGXKGKAtF3JcXhBwsXSmAxJLcKfU2M=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Hnex8kTI;
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 579662C1C;
	Tue, 30 Jun 2026 02:15:46 -0700 (PDT)
Received: from [10.57.81.132] (unknown [10.57.81.132])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CDA043FAFB;
	Tue, 30 Jun 2026 02:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782810950; bh=sVn7JJGwZOLyL4bxlpoMBgAzZBKKk9c/Cy1C3BZSWug=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Hnex8kTIqJvDaCwWDLDms17GUHLABmXpVlHniMOGFY9lEm0cRriX6yLe9fcG0DQqa
	 qEkiKClZ7FQfIJKCVlnr4qWxNJT3I0hCP27j0vIhDQd78gJFmS9Mr/RG6zkIZ1LeLV
	 d0Td8sQg68FW8THEVVnk5GPM4swe7eEP7w7hlH1k=
Message-ID: <0554305f-d2a1-4727-bada-0fba203a8af6@arm.com>
Date: Tue, 30 Jun 2026 11:15:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v8 04/24] arm64: Introduce por_elx_set_pkey_perms()
 helper
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
 <20260526-kpkeys-v8-4-eaaacdacc67c@arm.com>
 <e334c595-92ab-4eb9-a096-35602d57ae6d@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <e334c595-92ab-4eb9-a096-35602d57ae6d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: f3149d355xhhp58eoaam1ech3q6saixq
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 821561C0005
X-HE-Tag: 1782810951-614442
X-HE-Meta: U2FsdGVkX19iOtNxAT37vFI0dmC1t+hDBglEDLpJa3UC2mOuZovHLM2vFy86sIyU8R4Nx7E9R/Q+1ZoyQACZWEOrdrmSCqY6/CwvLFw/u7oSKFc+PC5wi/fmC7w9Zw/U+p3acFJD3CleeOc/qEjHYer1dtBKGG5nZGqFiCSN4m4c/IYPWe9YSXguWLWrOU245kN/pkylZJIiunXQ76PzIj9u8TVpHZbRgWi4OAB8ljmrWuXBf13U3gQ5X+tJA+K2UMSI3Kn3s20ImqtRonvz+7bQ8et7HLHx/Oy7LqjCMEvjUCu1rRHCjz5kU2om7lh3FU598UazlJ6fEBt6CFmPNVyesw07rn/AFaChKMfEIOU1CDpWNIGeYRhCeX2l3XEp9+GHEXiqIL+vZYqLYwWs0ipck4QkII/UFSZNE5WRLAajH/36FhST9TTeMrlwnR7eKqdbdL6ms45K3xYiZiOrDw67Qi5h/vnuN+YT+VMx3n7exKkJAO8a+QVz0p68i0ABRzs5MGYJIhyQCODhpLoajzeVO1pcNiJsOqBk9GzHy5nUThQUdJ7l8bwQ+6m3BdnZ7BVlvjDx8xEqLmjlynJJhyi2hux1KGZ/gUuytXw/F3EfdXJuPbue1lez2ubEcgPKojwZCJJ2+LC05wBhOrebsDzaK0WMsKxSXPvUpGpB12B5WkAPgGQivVBr1wA7d9kMOuNJClFRWY8yyWvwKOjysdJ6jyQM19mX4Pg8rYFvbv19klf9vwzVq1uh1nEyMOy8HxRCGcAkPf02QFPk/OMERdxt7643QY+nxEYlaR5iPJf5ouKwAKNgeVJcXqY5r1xh2nEvjkgtaGtLDX2+mqjCE7MiJG9c8I7biO31Ax/dxq0XEFX3aYPuhhOC7bRjes0Toh8MINnDtY1nvNhhHNi9fkQuwLfVbk+TUEOy12krUipoQ9S6uw7KHtKV+Q46G/PByEOduPhKxKHmnx3U4J4
 5DUYo8px
 XJEIUEnnH+t+zR12g4Pb3ZDzVXTxAhs3OOBRMzxV0nOr4jhCHpjIi8WQhc0ML8jaYnAM5GC/4yCPL/SGvpMpTU0EmOzexdT/cwXPMavwefmygiD/s0WCYa4ZknNDfkftS0O1ry1KbGg1OOt2kF2xTU+ZCxospnYVoHzvb6BHyEi4OmCf+BSqg+4Pv70TrkgY84TathtTL5WYbwqMSOXWPlN55P78vnNQtX4LHxWepexrim/4nVbigyRac9wT0J/N+QBT+MRE2atzimY5lpG86tXRooaItMSZjzrQwb9m+RF8DWeDjvWNauKILn69ey0JMYBl82JtXTZ/FUJ2NBuKZbz2nGWTH/Nb0eWvHoT/ROVgn0KRuWcbUf2xY8rmptM/ByHNU/Hf5qaagW5o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22/06/2026 15:16, David Hildenbrand (Arm) wrote:
> On 5/26/26 13:15, Kevin Brodsky wrote:
>> Introduce a helper that sets the permissions of a given pkey
>> (POIndex) in the POR_ELx format, and make use of it in
>> arch_set_user_pkey_access().
>>
>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> ---
>>  arch/arm64/include/asm/por.h |  7 +++++++
>>  arch/arm64/mm/mmu.c          | 26 ++++++++++----------------
>>  2 files changed, 17 insertions(+), 16 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/por.h b/arch/arm64/include/asm/por.h
>> index d913d5b529e4..bffb4d2b1246 100644
>> --- a/arch/arm64/include/asm/por.h
>> +++ b/arch/arm64/include/asm/por.h
>> @@ -31,4 +31,11 @@ static inline bool por_elx_allows_exec(u64 por, u8 pkey)
>>  	return perm & POE_X;
>>  }
>>  
>> +static inline u64 por_elx_set_pkey_perms(u64 por, u8 pkey, u64 perms)
>> +{
>> +	u64 shift = POR_ELx_PERM_SHIFT(pkey);
>> +
>> +	return (por & ~(POE_MASK << shift)) | (perms << shift);
>> +}
>> +
>>  #endif /* _ASM_ARM64_POR_H */
>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>> index dd85e093ffdb..493310cf0486 100644
>> --- a/arch/arm64/mm/mmu.c
>> +++ b/arch/arm64/mm/mmu.c
>> @@ -2339,8 +2339,8 @@ void __cpu_replace_ttbr1(pgd_t *pgdp, bool cnp)
>>  #ifdef CONFIG_ARCH_HAS_PKEYS
>>  int arch_set_user_pkey_access(int pkey, unsigned long init_val)
>>  {
>> -	u64 new_por;
>> -	u64 old_por;
>> +	u64 new_perms;
> You should spell out the renaming of the variable.

Sure, will do.

> Given that perms is 4bit per key, should we use a u8 for it instead?

We could, in fact I'm just noticing that this all very inconsistent
right now: the POE_* constants are defined as UL, but por_elx_allows_*
and other functions use u8. I'll clean that up in a separate patch and
use u8 here.

>> +	u64 por;
>>  
>>  	if (!system_supports_poe())
>>  		return -ENOSPC;
>> @@ -2354,25 +2354,19 @@ int arch_set_user_pkey_access(int pkey, unsigned long init_val)
>>  		return -EINVAL;
>>  
>>  	/* Set the bits we need in POR:  */
>> -	new_por = POE_RWX;
>> +	new_perms = POE_RWX;
>>  	if (init_val & PKEY_DISABLE_WRITE)
>> -		new_por &= ~POE_W;
>> +		new_perms &= ~POE_W;
>>  	if (init_val & PKEY_DISABLE_ACCESS)
>> -		new_por &= ~POE_RW;
>> +		new_perms &= ~POE_RW;
>>  	if (init_val & PKEY_DISABLE_READ)
>> -		new_por &= ~POE_R;
>> +		new_perms &= ~POE_R;
>>  	if (init_val & PKEY_DISABLE_EXECUTE)
>> -		new_por &= ~POE_X;
>> +		new_perms &= ~POE_X;
>>  
>> -	/* Shift the bits in to the correct place in POR for pkey: */
>> -	new_por = POR_ELx_PERM_PREP(pkey, new_por);
>> -
>> -	/* Get old POR and mask off any old bits in place: */
>> -	old_por = read_sysreg_s(SYS_POR_EL0);
>> -	old_por &= ~(POE_MASK << POR_ELx_PERM_SHIFT(pkey));
>> -
>> -	/* Write old part along with new part: */
>> -	write_sysreg_s(old_por | new_por, SYS_POR_EL0);
>> +	por = read_sysreg_s(SYS_POR_EL0);
>> +	por = por_elx_set_pkey_perms(por, pkey, new_perms);
>> +	write_sysreg_s(por, SYS_POR_EL0);
> Was wondering whether to move reading+writing of the register into the same
> helper, but you cannot reuse this exactly the same way for SYS_POR_EL1 as it seems.

It wouldn't be useful because the new user of the helper,
por_set_kpkeys_context(), doesn't itself read or write the register.

> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

- Kevin

