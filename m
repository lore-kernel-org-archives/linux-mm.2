Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 395CEF5A8AA
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 18:49:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 566B56B0088; Mon, 20 Apr 2026 14:49:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EFBA6B0089; Mon, 20 Apr 2026 14:49:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3906A6B008A; Mon, 20 Apr 2026 14:49:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 238346B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:49:17 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D16981B906A
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 18:49:16 +0000 (UTC)
X-FDA: 84679821912.04.6DEF35E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id D043C8000C
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 18:49:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ozVwLVWt;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776710955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qNcjPWzH/6/oNRqggcjbcb7DOm2Qg8QluDQNeeHntFQ=;
	b=3YYn9L7MQmMOs1h3mQoBu4bTgVDWl1fcLqetVrGTWWOLlAoQUml05IGGF0kvYc8Bc2pQgn
	yKtr1CSyJoJeYirIhdznKfxpsFlC2n6JoGhh0GZGbq2jFMrukdqSgY8Gy1mtcOujlJtENL
	3es7fGXwXhDWk93yujNO2Qax6zouzPE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ozVwLVWt;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776710955; a=rsa-sha256;
	cv=none;
	b=sVdtFQYN76qKqVlD3hJX97GquM2SPQoE/gthOt6GzzZjJJcXbuJd4EwgqnbusyMMLeOcIA
	zLsoS0DjfqfSqqJYXVy8zod4+HXvhcceHfS3ge/at95JChBMkfIdTTX3/XSX3wp2kTZIwP
	kxwnaxznJT9CTSzKqYIb+pTrzIKwNX0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B2B744435A;
	Mon, 20 Apr 2026 18:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FC9C19425;
	Mon, 20 Apr 2026 18:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776710953;
	bh=QHMzHRcLV1R2QvWX77MHFvc7Z/WhIck+SfReGrL2CiA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ozVwLVWtbbv1dAM7yazhYlk9vBe+pKM2xJQmU3CiYqNJsEr7tzkK6TWdMIXiJlWlf
	 Xi0Gr58XdKl+3sujWzhDdtlzNzkBwE5zzpUG2Ql0vQmCymqK/xC5KY3I8Riknd/8pt
	 8lkOHH2ydXVU5JhblmB7Rj/oOzBBE4/+qkTHM0WYQxKgAfsglgKPYf59suelKyClVR
	 cLaIBFMEPbb8ftZykqjauwGJAPzMzHveyDuG+uT4/k8TXjSBUZRmbPtyN98cvN9rky
	 J8QnLPwrNrYd5t51NQFAXwcftF7jzJsXozYUHNaRxaE8Wp4lrmHOUWSN0S7VgKyALv
	 3SQB8ubcc9iuw==
Message-ID: <baf56e3e-27af-4c9e-9dca-4be82e761f60@kernel.org>
Date: Mon, 20 Apr 2026 20:49:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 01/30] mm: Introduce kpkeys
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yang Shi <yang@os.amperecomputing.com>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
 <20260227175518.3728055-2-kevin.brodsky@arm.com>
 <00b24db8-0063-48d6-8bc4-e8b670d8f0d5@kernel.org>
 <913002a5-e002-4001-ad19-037102d1f97d@arm.com>
 <cd2bcc09-2507-4ed4-bb92-2d53baedaf04@kernel.org>
 <c78a9048-52a0-4a22-ad69-4bb5e84895b8@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <c78a9048-52a0-4a22-ad69-4bb5e84895b8@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bs6xxzr5dmup6obhumhj1cdq5qxpwm9n
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D043C8000C
X-HE-Tag: 1776710954-639075
X-HE-Meta: U2FsdGVkX18fZvZfs9c2qZSWYf/86p28OixZRTRtvUkLoqdqGzA5j0v7DWOoyUUyN55l++lnEPeTfQ6H+jy6YlR9CpYWsK2dV+RE8JUO451fN/134UhI4PesMz5PUYHyL//GVhR4YeEW77e2xKIhZwKURmVhns+p443fdZhKjCxWq+nOVdyspccTX6imnOeQzCGc/olkPFYJuYoI/XKSU7mwZ1utTtKNX7UP4t1+SrMc3HgODEk8poTS036Leo51MfuomaxNiIKLfHXJuCINA+WlLG+eBFzyOdUfAbqumv/gSuK/25AsroIFCT83Sc8zw3cBvPcJghAvJME+GPnvf3QFE5pG2YmBVDfBiD7dIw/TfDHU+GK2EnFnfB2+69ug781Qd+LsaZM1KB/TTWyFJfjUvV4BS/YXjLJSWf66T+NR3w9CLLKynUi0qSQSra6Be+Qtc3N/it1N0PiN8awrTJL5jS2OA/FKoqo+Nm4FL29HHlAqnXuKScmZ/OyewcWrN3tlKsE4qW0+qWS4PvpfNlFMYKjVJBmOibohPUseng2srPRqNvhdM6wcbVFvEYbxDTbEvtKknqVjdhJje07NzO5keK8aDs11YLFpIQA9vJHmnSGr5s7SlzMcj5wfcjAg5WHfcqsx+hMX6tIImuJ29sEotxDZo0WkkRUGwDqj0/bmEOBunIQgry1/gsiOdbm2CyK6gZL/TmlfxoHYf/vd080Abl+QZhKd1dxJ4NfUM66Dy1cCh0algF8dlKDtDhjY7AoeP9/2/7VCEODkIakcnY5vpNC1MlG4F7pb0/RnMKMAcbJnTlt55cmA56oO+hr/dioP+qCiQJ/80Az4TbZW8m/0AcIQJvceQxX+zMCsLCAaQKPqTREzzFHKx/a2r+um1CQPN0n0qgxfhKtc304EAJSlZAIV4PbWcT9bhOscKfZCPIwyOaci3kD/8RnvT/8mRT5QsUMo6KmpCbxzq94
 3bcnfnD1
 TsmACjoLFn1FjaMZfOoicj+04nGagfp3uXJKhK9LmK8muqzBtaOl++kKSOwJzYzHMu0P/HYsIRgtR/O7YSnr3kxvs8mWuAOLsHij9YumWfG3uqL73CTOLJLwJywwbHEfuBWPq4VQ6Uaf7i1NNYRHWhsMSSrIzcocawKSNYNZqs7FxqpzlST0pXIGskpZBcNjbnOUXIWHT1v1KVEsVfx/TmfJXsdSZUROltoh64Gfv+S/YM29yp+k7JR1FpfGKZtU7TDYql47U8HwZDMhTpCDQUeIi9klWdq/jy6x/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/20/26 08:46, Kevin Brodsky wrote:
> On 17/04/2026 19:38, David Hildenbrand (Arm) wrote:
>> On 4/17/26 17:59, Kevin Brodsky wrote:
>>> The first two are not meant to be directly called, they're the
>>> arch-specific implementation of kpkeys_set_level() and
>>> kpkeys_restore_pkey_reg(), and those generic functions handle some
>>> generic logic.
>>>
>>> arch_kpkeys_enabled() is directly used in generic code, so I suppose it
>>> could be renamed to kpkeys_enabled()? It's actually implemented in an
>>> arch header so I wasn't too sure about it.
>> I was skimming over patch #13 and spotted:
>>
>> +void·__init·kpkeys_hardened_pgtables_init(void)
>> +{
>> +›	if·(!arch_kpkeys_enabled())
>> +›	›	return;
>> +
>> +›	static_branch_enable(&kpkeys_hardened_pgtables_key);
>> +}
>>
>> The arch_* there can just go IMHO.
>>
>> I'd also do it for the two ones used by the GUARD macros. If we don't
>> expect common code wrappers (arch_kpkeys_enabled() vs. kpkeys_enabled),
>> then the arch_ is unnecessary information -- IMHO
> 
> Makes sense. I could just rename arch_kpkeys_enabled() to
> kpkeys_enabled(), but I'm thinking having an arch abstraction could be
> clearer, after looking into protecting sparse-vmemmap page tables. The
> new version would look like this:
> 
> * <asm/kpkeys.h>:
>     - arch_supports_kpkeys()
>     - arch_supports_kpkeys_early() [can be called before features have
> been detected]
> 
> * <linux/kpkeys.h> defines:
>     - kpkeys_enabled() -> arch_supports_kpkeys()
>     - kpkeys_hardened_pgtables_enabled() -> static key
>     - kpkeys_hardened_pgtables_early_enabled() ->
> arch_supports_kpkeys_early() [called when setting up sparse-vmemmap,
> linear map, etc.]
> 
> There is extra #ifdef'ing going on in <linux/kpkeys.h>, but
> <asm/kpkeys.h> doesn't need to worry about it. I think this might be
> easier to follow, I don't like too much having an interface function
> like kpkeys_enabled() defined in an arch header (not great for
> kernel-doc comments either). Any thoughts?

No strong opinion on the indirection as long as we don't call arch_
stuff from ordinary pkey user code :)

-- 
Cheers,

David

