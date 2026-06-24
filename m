Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1861ECDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 10:24:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0233D6B0088; Wed, 24 Jun 2026 06:24:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F16EA6B008A; Wed, 24 Jun 2026 06:24:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E06A66B008C; Wed, 24 Jun 2026 06:24:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B2C176B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 06:24:55 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1AB4EA02A2
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:24:55 +0000 (UTC)
X-FDA: 84914422950.19.F7CF7D0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4614840007
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:24:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M3Ze81Ve;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782296693;
	b=7cmpntTwV6BAZnDmjKOkZMl0id3yi3kY0l5S4MTnlSrGi1jePvyAr5YU2gDo97/l3SNvr/
	k6tXwZUg3qQ/dFk3QCTOSp9XfaVMh6yOJGPs5yNpJ78rNloZ9oA5n3ZWl7Qj/5Vaw+r4DA
	7QDKGOkLeA2DXaX+jeS4Ou/Cft55pkM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782296693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dbgZMRyxUhpQ3kzlaU3M0hhk9GF4/29S5UZlvh3+gjs=;
	b=fGsoxsPd7Tt28EbehQJZ39YBv/xowmGPqa2hdBdVqFATS4XSgk2ZVOlL8IFoBGvBnT7Cvt
	GPM05e0P3Amd2RDU/ziCraRyFDsCK77MDR0LQ8ZNLve5aN8SSSz5WInpDvaAOEEnMQwIaa
	7QJvdPrkrWygCxmhuS81zWlgC2JjBls=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M3Ze81Ve;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3369D43779;
	Wed, 24 Jun 2026 10:24:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99EE1F000E9;
	Wed, 24 Jun 2026 10:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782296692;
	bh=dbgZMRyxUhpQ3kzlaU3M0hhk9GF4/29S5UZlvh3+gjs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=M3Ze81Ve0Kwa/dryGMXeQhXmDgrwhoCyK+B5Y5hD3wFt6wncgbaBqE/mDZ8y0jFse
	 NT30GzTzMZeeI4CWpy7Y5G9081RtewnhASHQxJvwpbckO7SNxE1+c59dEol03T6YAX
	 JfRNP8nj6VWjpmX8ORTBYyBoZ/ERSCgrUWUlnSakxefxUKnmDoe/AwB6Y7A0nMb6Qu
	 wlkOZLiGG8BenrqjR7FmkfYGVEJjncKxM25GnFdPv6ChvM4HlV2qC2fU0y5xNPPMxA
	 jYtU+0Lw/MQlPQzWHqzEd8sbynjrY5ELjWSz9qHP9bCeO8TyPMxrCLb/9R+BtxkJ1T
	 VPyqJ1Iy54Uvg==
Message-ID: <e1bba04e-d5a3-4edf-8309-d0b8006fa262@kernel.org>
Date: Wed, 24 Jun 2026 12:24:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/2] mm: improve folio refcount scalability
To: Ilya Gladyshev <ilya.gladyshev@linux.dev>,
 Matthew Wilcox <willy@infradead.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>,
 Andrew Morton <akpm@linux-foundation.org>, ivgorbunov@me.com,
 Liam.Howlett@oracle.com, apopple@nvidia.com, artem.kuzin@huawei.com,
 baolin.wang@linux.alibaba.com, foxido@foxido.dev, harry.yoo@oracle.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev,
 rppt@kernel.org, surenb@google.com, vbabka@suse.cz, yuzhao@google.com,
 ziy@nvidia.com, pfalcato@suse.de, kirill@shutemov.name
References: <df26082871b4c65b2bd38d409026237c08572836@linux.dev>
 <20260608154734.8e4115fde4e2e14a3b6892fb@linux-foundation.org>
 <fe53d9a75f776a5e002a3375d086c5714f558547@linux.dev>
 <CAHk-=wjwdbrwUpTiQef5eAd9pfC3bKig9YpXxoHQinssubRh=w@mail.gmail.com>
 <839a2ea2755fdddf5af773e006237b07c9e261df@linux.dev>
 <ajhcia0BKmTS6FQG@casper.infradead.org>
 <b8b444637f51df57762ddebf8ac3c515d3ba2262@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <b8b444637f51df57762ddebf8ac3c515d3ba2262@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mx7ajficz3i8oyqfk5soet5frocypwd9
X-Rspamd-Queue-Id: 4614840007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782296693-348164
X-HE-Meta: U2FsdGVkX1/km184Mo+WP/31XMylD371ALn+ROURy7KTgVZbuGStb3+YHGyx1CuPAP7N4R7ygWbEXGdrR9VA3ljx1KucMwjnNw2MIhFQcvJ2vn+ENSYgr+w348WA33DNakR53ceRa+nnRZ3P1uN7HdqCuCwdoCk8dcUqFNqUb+pdSidBZaIikI7e46kG0IFufWiSFO4nAUYpwA0Yw9VZ/oJ8uTGPFMr0MCJM3eD8f4c/PtcaNoCOvOSfqbJMo3FSFujOjxb5OWjZC2CYwMZtvoc4XruZN32bXfUCco8bqvb7ubDkR4wb+xgHG3/UqolrItg2Zezo+4Zkc9b3AH6/AA6dVv8qG1SklWkLxOuLsKfuBLeBT9TkXSHsofnUJCQT6v8rFH7c0ei7UY3x5H0o6f9dmyZfOgHSLDz/j7p9SujM7q5wfs1YB5LZILSYs+HvBdJXLVxGsGrYE69OnTO75I0R1OLGSil/rKCQYH4+ugHj01EHcAsGXO9iQw9sFDL4s51EI0CPNArFv5/xY1Q4pQjRdpZKaPViKHf3NSeZCT7tXYkW8saZGVBiOgNDkcv3mnrW70erySzhDcwiou1K9+h6xzotkeRl3jX160tCkqzdo9EJWT6nBanxi5dxt8CIRo8j5wQdWu7o5SA1cr5+J8ie7ct9Baiosuq2xA29IlmTfg1PNnsLPoFjfW9CD14i9UbxSwJf1Y9ZPM2FULKrnenxAtpLkCWOLkEEUVa18+kt6lYh1M++tySegxetewWDGsP/i5qxMBEBT/yIZWjuXXkNYmVEhGb10h1Ty9/2wYOctNGS4PQh1/V7qxLFLUE9IJBPfaZLLc3cV9YtNiVcVNPJNvedOjWLBTL5zJq2NJ6GOYuDBk/Urlu/2X8dmwjyo0QlwWnVLb2NQ/BWCbdZ4p0BQ1Vaojvr85NcVn41wvOOxO60kbNsHzv2RDfyqNDO3llbA5X/cMY4Z6slzqi
 1rbQrz9J
 zoKBizISkySkcueNz8vqyUXe0+dqHuXD8VZ5GFXzlIBc7fMyJoTKjsiEYXp/izSZIWkaB1uZoh++wMsC1L64ymib+vb4rAS6kUFjLurG7yxXo1bejI0SYJSnrnN6/yc1Fc0X2tdClU5n+3dgJ6vJ8Vp4yns5Fb90FfucK0Nm7YXd5hKyM5xMpbaxiTMQbEHinpK+zUhr1Rc0B3xAr+/+MvTWc4Aduw80ZS9HPmbmNw22MI0xpaVjfchsXnlodU8ZEjS+gvTzjWV4tzHE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/23/26 23:23, Ilya Gladyshev wrote:
>>
>> On Sun, Jun 21, 2026 at 09:34:47PM +0000, Gladyshev Ilya wrote:
>>
>>>
>>> June 21, 2026 at 7:46 AM, Linus Torvalds wrote:
>>>  
>>>  On Sat, 20 Jun 2026 at 11:19, <ilya.gladyshev@linux.dev> wrote:
>>>  
>>>  > 
>>>  > T2: optimistic get() [0 -> 1]
>>>  > T2: put page back [1 -> 0]
>>>  > T2: calls dtor for type X, returns into the allocator
>>>  > 
>>>  Which optimistic getter does this?
>>>  
>>>  If I understood you correctly, you are talking about the scenario where
>>>  an optimistic getter took a refcount on the stolen page, so the validity
>>>  check in the XArray will fail. And this scenario does indeed work normally.
>>>  
>>>  This "ABA" happens if the optimistic getter successfully gets a refcount
>>>  on a valid page, so the full T2 execution looks like this:
>>>  
>>>  T2: optimistic get() [0 -> 1]
>>>  T2: re-checks page [OK]
>>>
>> I don't think that can happen. Or maybe it can and we need to add
>> some barriers. The page is always removed from visibility (whether
>> we're talking about a page cache lookup or a page table lookup), then
>> the refcount is decremented. I hope we have enough barriers in place
>> to ensure that the refcount decrement is observed after the removal of
>> the PTE entry or the XArray entry.
>>
>> But I'm not sure why the folio_put() after a speculative get avoids this
>> problem; why do we need the recheck to be successful to hit this race?
> 
> After additional thought, this race doesn't require speculative gets at all
> and is more about two parallel `folio_puts()`: one successfully deallocates
> the page, and one sleeps for a long time and then calls __folio_put() on a
> "logically new" page.
> 
> And as everybody pointed out, this race isn't something specific to this patch.
> So folio_put() was always ready to be called on non-folio objects due to
> optimistic try_get() + put() in the filecache. We only care about calling
> folio_put() once, and nothing breaks with this patch.
> 
> So thanks to you, Linus, and David, for helping to clarify this :) I'll post
> v5 with more or less cosmetic fixes from the AI review then.

Note that I found an example where I think it might indeed be problematic (the
deconstructor thingy) that might require another look.

-- 
Cheers,

David

