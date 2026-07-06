Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41109C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 13:49:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18AF06B00CD; Mon,  6 Jul 2026 09:49:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 115D86B00CF; Mon,  6 Jul 2026 09:49:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0038A6B00D1; Mon,  6 Jul 2026 09:49:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7BBF6B00CD
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:49:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 19C1C403D0
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:49:30 +0000 (UTC)
X-FDA: 84958484100.05.733306F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 580424000C
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:49:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cfweDhmY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783345768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wK0aCBXBbwqdK294JK8uznzPRp3oLmGuOxio1ftZy3s=;
	b=a528zEyHjLb2hudxD4ZzksgX9vtW/3ZwnLwhyDj+70zw3ggBC2M1nk53XpDSvv/kobaJ20
	Cd5qktTA42ywClh6H1QhDAcY2klS5X/+hjmU5XX6p2QL4nD0qiM2TsdE8/dgcqXIL6xJ5q
	2+pY6+eGXWCZZdgyPZHo7b5nw6vUOl0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cfweDhmY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783345768;
	b=hmAni+miH+3cG2QwHbP8HfuQbkiOqX6XBhmBVbTgWP9VNImQM+qpZaWgEI9kJF+GU7aZc6
	BjN7bVPlnWW+3NFYs6TbvS3cw+YSoOTyoUt6Xh/PfGUlsh4kpiR7/L7iJr9KAqWAjXRK/N
	hMJAfwWXSUb8/WLSJ85/5JzEzArQjno=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DDFDB6138B;
	Mon,  6 Jul 2026 13:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD4A1F000E9;
	Mon,  6 Jul 2026 13:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783345767;
	bh=wK0aCBXBbwqdK294JK8uznzPRp3oLmGuOxio1ftZy3s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cfweDhmY3uzvwT/ivKj11445D9BHzpepvwDhcWWBY0Ax9ECQOnkIy2JdCFBTcQh+O
	 OL5bc+sjjh6g1WZpz3gftwLq3vURxlcGhKoQlk3w1QcGdY5BCWKL3qNxOepmz9mnHw
	 hLf8zsYFvcrlxKTU2kIii7Q9VvyYogkTc9t2AndndPnTcQ+2jYibLpoixg1z4E2qHw
	 3ZKVmPO5NGQEfdRfmdvnPu4KES5JWkbJaMtwRLpstX//I7D3xenCII9qgmhmfLP9zx
	 zh226Qdu3vaRu6SDP2qO8V1dLSuWZZGFYZ3k5Es3tJa5Lf3fTt4n+n4Z/Z+Ijpxi/J
	 QSIKNgtpyQ+zA==
Message-ID: <d5a9c3b7-fa4c-47b7-9417-4c81b21760b8@kernel.org>
Date: Mon, 6 Jul 2026 15:49:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/8] string: introduce memcpy_nt() helpers
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, arnd@arndb.de,
 bp@alien8.de, dave.hansen@linux.intel.com, kees@kernel.org,
 linux-arch@vger.kernel.org, linux-hardening@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, mingo@redhat.com,
 rppt@kernel.org, tglx@kernel.org, x86@kernel.org
References: <c02d8cd6-a3e8-470f-a7ea-a2f2f666b10c@kernel.org>
 <20260706115313.50524-1-lizhe.67@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260706115313.50524-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jb5r15gdfcpoqdts4f38ti189gkr9sxp
X-Rspamd-Queue-Id: 580424000C
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783345768-672179
X-HE-Meta: U2FsdGVkX18WCfrcmT0uw0k04Hejq7pH7cOKR+CcUMPfYbrI2f3+foNADHCd9xm8XRWFMJOLpJ4yWgQUvvXb7z5UvPpUIjlx+O6Kew+RMNhzj2Ie5p4dQ78meoCTr4qEHB/Qfe0FOJk/TzA8j5zBRGIg5l6GQWBvzL8enWzZlv0BqntMyW50Q1RtZIEn9tdLWfDSZ3m/e1WJxuMZHc3VpfNu7vrWDzWpxZLo91vwMOo+FZwWNefVFbJqUtoZ5m6H+j0Vr46GkJQysfV8l5cPlpqcssHixrktICR2Lao2bCvEEU+0uaoKxz6JNKYZSoNZnyiVcUfQ1NLwMz8LB2cVP3WdrWxRBNLo5eVFqkw9RlQqxZlYWdr/7QH8UH2Z0CCHQkykeuMMKwjm89jnQnoeopzxpgU23b15i/MyTb7kDgCAV47z6mQn5Gx4M2+lYd3sW8YiLQSnz3WH+X2wwfnBirM9UME57xs0RI6td7tLxU7ZSF/g7ujuevSejmdMUcYXwmhTWk80Z4cr6+81dNVQw8gUM4jMXS30tWNvE9+1ePpGyDa2ImmXE1yOXn1LoMdOvX//vcHqMrQic2FFULpnGWK4Azhefr6PJjhNSejmOuVCDg+4fUNYohO0KRsUef32A3bXyJRGnZ86edLqpdq7TFCG7IaGUGAjhXKV/WqkvEVDNvAtgbUt93LoXgJhCkBE16EBB5drf5nwZ9/T7GBGjq9/KoJ0WN3mGL4cSogbmVI6O6wEXLC7LRevTkYV6wBGOIbcdyF2Elba3lbX8JAC/3amTIxs9UyIlvvrOuXpjg8eCpoXJuYOqVczZ0aqkWETXRT4e0RcfZ9nvHpAKOySx0hrbv5l/sBxae8JuaN0WcVCqBBP1kuav9iSRTaFBRlT64qteneK/vmFe/CGTTVFI1ylWelCxPCG6TDDB9eFJ3GBaR+FYYMy8sBpbZ0zNb8elq2IXiOR4aXJkw/OWy7
 UOXT7mL+
 Q8+IQuTwAMyLntfZBdHaB09J0BtLtdjNELu1vWv7VLl4GvtSBu5wMhP4d0nBv2ViWBvTN6jH+U4O6gtAYp10tnPUz7ActmHWrwLFGgW1T8IQmCJtnrpNNuzuboDWWEr7GBImAvkC8V7j4C3aCO9rSmfYjDfe3jaHKb4/YJyV4gfKwbcHp7pmiB+hCSHg0lu4+qKnvDrJ/zaX3cQ/aSrFHyZO+Crfxp1MUiKaQAZ9ZDMVnELGjyRPOuDF3b4/0mbJYdWKElvLgPrSU5ahzLnT8sbirsZ6Ci/DSOry0fu8Ph7BHxRQcxvS8B5T6QsPmxC2VSx4S7gwwEeIqfZdnRsIjS6NiOgdmey+3Qw6B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/6/26 13:53, Li Zhe wrote:
> On Mon, Jul 6, 2026 at 11:18:48AM +0200, david@kernel.org wrote:
> 
>>> +
>>> +#define __HAVE_ARCH_MEMCPY_NT 1
>>> +/*
>>> + * Reuse the existing x86 flushcache backend as the nt copy primitive.
>>> + * Callers pair it with memcpy_nt_drain() when later stores must be
>>> + * ordered after the copy.
>>> + */
>>> +static __always_inline void memcpy_nt(void *dst, const void *src, size_t cnt)
>>> +{
>>> +	memcpy_flushcache(dst, src, cnt);
>>> +}
>>
>> In particular if you end up with a single function (that jsut requires a write
>> memory barrier afterwards), please make this
>>
>> #define memcpy_nt memcpy_nt
>>
>> instead.
> 
> Thanks for the review.
> 
> Just to make sure I understood this correctly: do you mean that, rather
> than using a separate __HAVE_ARCH_MEMCPY_NT feature macro, you would
> prefer the usual self-macro override pattern, with
> 
>     #define memcpy_nt memcpy_nt
> 
> in arch/x86/include/asm/string_64.h and the generic fallback kept under
> #ifndef memcpy_nt in include/linux/string.h?

Yes, that's what Linus suggested as the preferred way for single functions when
it came up in different context recently.

-- 
Cheers,

David

