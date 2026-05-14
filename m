Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75990CD37AC
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 02:16:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9338C6B0088; Wed, 13 May 2026 22:16:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E43F6B008A; Wed, 13 May 2026 22:16:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FA606B008C; Wed, 13 May 2026 22:16:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6DC8B6B0088
	for <linux-mm@kvack.org>; Wed, 13 May 2026 22:16:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 07DCEA027C
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:16:50 +0000 (UTC)
X-FDA: 84764412180.11.E1F32C5
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0D4901C0008
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:16:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NiSJMa8A;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778725008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sfUkHUvFvN9MUTYLegQqMkS5z5gU7HMTPPWfFS0sDNs=;
	b=2f0d3ZW3hjDkoAwUf20zq6uPsOXczprJfiTS98mYJhOGmMUyfY4B+NBxIxxfmw15alJ/AH
	oCsQKGaIdx/+cARYz8e27rNux7tLX1cyQARcGktI2x5Sl/lHxluoNxKuajnVSs8yE7tSo8
	kXQVdhQwK1LNFOYZ3nrnHuciTxC8G00=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778725008; a=rsa-sha256;
	cv=none;
	b=RIezlqzCdbL/bcC5G/rBsKeopmGoRhXVHK2jXleiE+IqiYz6sT8mRXTMMkbduftcENpIny
	gR5CA0EbWneK3LMKrsmSeqCH5n3TagL+Plv9XGe+7UDVWcZhS97qSGxzuHDqI8OV2aBoPf
	hr2AFh8pcs2i/XdlmOcyIpdeJoctgUE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NiSJMa8A;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <5478f96d-277c-46c3-b437-1660706fd784@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778725006;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sfUkHUvFvN9MUTYLegQqMkS5z5gU7HMTPPWfFS0sDNs=;
	b=NiSJMa8AZj6pYNg9iccdQZ5+vV7Wlf4xHw5EyItlN4Uzap+ockOpYSTg+rB5FQHFwKLE9q
	37R8dEt5EQ20J8HrNgu4yVkzNtBvhOyEDYo7mqvXwh6ZTBJIzHPruVplA/f5Z1wtC8L2J1
	PwbFzmSX20hM2/kLwuIJAb3c0sVQDBQ=
Date: Thu, 14 May 2026 10:16:19 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm: make zeropage read-only
To: Yang Shi <shy828301@gmail.com>
Cc: jannh@google.com, rppt@kernel.org, akpm@linux-foundation.org,
 arnd@arndb.de, linux-mm@kvack.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
 ardb@kernel.org, sethjenkins@google.com
References: <CAHbLzkrXXe7r3n3jXgDKtwZhRqj=jDx9E6dLOULohnhBguvi9A@mail.gmail.com>
 <20260513021148.17588-1-lance.yang@linux.dev>
 <CAHbLzkpBB2ia4pUG1khZy1w5G_sq6DD+9OnqjrJ6Yu0KxPAe=A@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <CAHbLzkpBB2ia4pUG1khZy1w5G_sq6DD+9OnqjrJ6Yu0KxPAe=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0D4901C0008
X-Rspam-User: 
X-Stat-Signature: p43ha5yiho7pstuqt7b9fuz4eygb6rti
X-HE-Tag: 1778725007-678691
X-HE-Meta: U2FsdGVkX18v9dvVXaMtaQjQnsiK3o/zMHnKvub7Z2nmU4c0ITXoIDPmIS0nEZ1GHfp3lQ3Z3oNU9LJEP7k6l5gPpvj7jZ6ZuoPI27YYff4yyZFxpxIzPDGtCQRfPk7fVAPSijJ/36a/KPqfvGHujtwR9VMNyMRPL/Pq2hSjePNcBTyiZOWJv4FJl4QKFd+HDEv8wH9d2UaJwUym6kAEGOXOtEdS6TGXXkrHj5N9rz3GYjoupLbIUy5uIPPsvclGDSHGlbdcjxzjZnyJjKqDYRRbaA/3tUoRrLfWHxGhtCure56rQA5mH/3JJdaKdFBMm7vOpHKk/Kp2/vqHtAX9+V8CdFVDov7/+fJrRZlCwWnRoU89evEtZCOIDzArGA/djcAtkRREGQuQAmikw18zVLh2bMU/uC0D0v+7ojEt1/++BWTGX2M+d81U4SwUwicAOiyoxyvi2Ak3VN6951H7RmPB6Y4hYxppn6ilP4fi4Lxt8jRkYWj+RadZGFCwkCGhher9lIePLm4mjDeFQjwG2wiYghYGaEFh2JIYGayiBgxsqyFIZ8rr3VlGZtVobmVlF+vc6K6eRygOOdnmjOWDsr/Ik3pskGkivtIOSF74DNxfM+Dx0DWp0XC4+sL9FyzGw5h78TEkvSxh4coeiqlw2+iPkrEXD1zfyVTfL7sRRBJveyT86qWlTo/fQ6OLBBLlX/fwkXflpmoRXOPHv2oQrz+FB4f5bSuzdlqpIrxM/VrYfPZo5kghKVqOhKExansL0HuaLHW7XCMRvSKDQoOrUh4T5aEtgJjZ6VHu8fM5tObrFY6h0KjPftgE3S5PLz2e2sDRsEQHPfKgPPRW5LzccAlzdfGaiIPrpgpmQvzpsG1iMbvEv+pT8ICxjdcbgyYMH/Sxtle4DkaJSaAt9f7OZkKKIKGJrU/OEkoKjMs7sq1H0+lSTfYvALvjzyIRwE9yCx6pvwi9H+jB3eze9tV
 uU4NCuqa
 aP73KTTw+LRlzGjQlWCzl0+/QF+kV32g1bQvYrSgmxBMVQ4fE+6LmhFG62mhy38ydfmexfXe8Can2/V0j9zJSwHyKLhKtqX0DSrBxz5pAa5/cR5SE0ReMWK+9OCF+5FlgoFPyDtln97MatiNlaQ3R3a8RLJeeDwo/X4UloiBhyu59y5QXTtruHgRG5NGfroKbViGUo2npJty2Apyye/GU3qbTenfMH0taa8K+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/5/14 07:10, Yang Shi wrote:
> On Tue, May 12, 2026 at 7:12 PM Lance Yang <lance.yang@linux.dev> wrote:
>>
>>
>> On Tue, May 12, 2026 at 10:14:01AM -0700, Yang Shi wrote:
>>> On Tue, May 12, 2026 at 6:48 AM Jann Horn <jannh@google.com> wrote:
>>>>
>>>> On Tue, May 12, 2026 at 4:31 AM Lance Yang <lance.yang@linux.dev> wrote:
>>>>> Would it makes sense to apply a similar treatment to huge_zero_folio
>>>>> as well?
>>>>>
>>>>> with CONFIG_PERSISTENT_HUGE_ZERO_FOLIO=y, it is allocated at boot and
>>>>> never freed, so it should never be written after initialization either :)
>>>>
>>>> Oh, neat, I didn't realize that that feature exists.
>>>>
>>>> I guess there are two aspects of making the huge zero folio RO that
>>>> could be problematic:
>>>>
>>>> 1. If the huge zero folio comes from the page allocator, making it
>>>> read-only might require splitting a huge PUD, which could have
>>>> performance implications.
>>>> 2. I vaguely remember arm64 has rules about how PUD/PMD entries in the
>>>> linear mapping can't be split at runtime at all depending on hardware
>>>> capabilities, meaning the entire linear mapping may need to be mapped
>>>> without any huge PUD/PMD entries - IDK if thp_shrinker_init() runs
>>>> early enough to be excepted from that. See can_set_direct_map() and
>>>> force_pte_mapping() in arch/arm64/.
>>>
>>> Yes. First of all, this relies rodata mode. If rodata=on (used to be
>>> called full), the linear mapping may be mapped by PUD/PMD if the
>>> hardware can support BBML2_NOABORT, otherwise it is mapped at PTE
>>> level all the time. But how huge zero folio is mapped in linear
>>> mapping should not matter, you just need to change the linear mapping
>>> permission to RO anyway.
>>>
>>> If the rodata mode is off or noalias (used to be called on), the
>>> linear mapping may be mapped by PUD/PMD, but basically changing linear
>>> mapping permission is not expected by kernel.
>>
>> Ah, right. So for huge_zero_folio the hard part is not just making the
>> backing memory read-only, but also whether we can change the linear
>> mapping permission for that range. That depends on the arm64 rodata mode
>> / direct-map setup.
> 
> An alternative is you can allocate huge zero folio in the early stage
> of boot before linear mapping is set up. Then when setting up linear
> mapping, you can just make that PMD RO. It should work regardless of
> rodata mode.

Cool. Good call. That would avoid changing the linear map permissions at
runtime.

Thanks for pointing that out! I'll take a look when I get a chance :)

Cheers, Lance

> Thanks,
> Yang
> 
>>
>> Thanks Jann and Yang for the explanations!
>> Lance
>>
>>> Thanks,
>>> Yang
>>>
>>>>
>>>> So making the huge zero folio RO in the linear map would probably
>>>> require adding a new config flag, connecting that to
>>>> ARCH_HAS_SET_DIRECT_MAP, and changing one or two places in arm64
>>>> memory management.
>>>>
>>>


