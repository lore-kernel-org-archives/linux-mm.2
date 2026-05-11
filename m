Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E82FCD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 14:15:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E0036B00B9; Mon, 11 May 2026 10:15:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6909C6B00DA; Mon, 11 May 2026 10:15:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A6E76B00DC; Mon, 11 May 2026 10:15:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 458E66B00B9
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:15:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DC5CE1C0061
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:15:52 +0000 (UTC)
X-FDA: 84755337744.30.0A966FA
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf12.hostedemail.com (Postfix) with ESMTP id C54464000C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:15:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c29iturH;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778508951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4tgWK5Wl4FOGJuSNplBMEQ6ddYDQpPafYjZfvqpLPLs=;
	b=d3Burl4ZP43z6UP9yQnBiJ0IxvlMLydB2n4KDoc0Tus+87XzJgN2VafrokZFPPB4eg9dxC
	PpHUqcWmlwMYVk9GsQ6nriw8yu1RmwfIy8IlFpjzJQ5Y8iYU3Xjdoq3TD5mpzP+ZmzypKc
	FYq2bvqjA2LgVXln3lnQfa7r5lLpKj0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c29iturH;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778508951; a=rsa-sha256;
	cv=none;
	b=QdT0p/N6LVZ6xRkK/pZMksKBtASxgMTjCYOYG61/KE14Hx6RSrgeVd0k36UdfznSwceAai
	1i1qQDHb198Eb58Ez1DsUPPuC6zYz3B+BujyV7vxM0RM6hNSqTXbbcsd31u3pvYYhZMJdi
	+pIM8s8i9vNy8lUNtYoAMhHZqKj94gk=
Message-ID: <5f287430-23e0-4a0b-8e5c-5cc94bc28654@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778508948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4tgWK5Wl4FOGJuSNplBMEQ6ddYDQpPafYjZfvqpLPLs=;
	b=c29iturHuuFzztW4Ip64ftQ5H+zuwPd00Rs40Co2fpPCamyKC42BMhwcWw3EjC1JKMunVT
	yBBpqjAtyzfx2WH9m3WiIYNsYuSVumwpX5B9RDPpWveRmZHdCwHzPtljvMnnfE+Ia5HB8F
	9+9hymIx8GnMIcEvpW1XlHFia5u1Yds=
Date: Mon, 11 May 2026 15:15:42 +0100
MIME-Version: 1.0
Subject: Re: [RFC] mm: restrict zero-page remapping to underused THP splits
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Nico Pache <npache@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, yuzhao@google.com, usamaarif642@gmail.com,
 lance.yang@linux.dev, baohua@kernel.org, dev.jain@arm.com,
 ryan.roberts@arm.com, liam@infradead.org, baolin.wang@linux.alibaba.com,
 ziy@nvidia.com, ljs@kernel.org, akpm@linux-foundation.org
References: <20260510114001.600681-1-usama.arif@linux.dev>
 <8838114e-5b6a-4f3d-932c-9e97e51216ae@kernel.org>
 <608bef55-44d1-47f1-a201-4a6bd7be137d@linux.dev>
 <574fc329-bf2d-4686-9f15-b1709432326e@kernel.org>
 <bbab2b63-59fd-4f21-b991-53ae22588704@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <bbab2b63-59fd-4f21-b991-53ae22588704@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: kksa3heqhe3mffadax5e5i4f7zgxtdgg
X-Rspamd-Queue-Id: C54464000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778508950-835344
X-HE-Meta: U2FsdGVkX194r9jdC00ZQvTNQ6HExKQ0j5aaD0gG8Bl28PV/MtL7PRDZQrdYwDVPmg+sVGzs8N6jStacxaoyUeiF1is+f/ZWaZzDTcbcytVrvZvvsQmBv5lNKiWN9MmU7RQjWUtbIehP9jgFbs1voe2/SEZYLEtgqiAhmj78Fk7xXACZnVT5vtlbvCjqz0WiJ7F2WNZP4TH9t4UQWmZnyTrct84DaLYMJnZz4jWgVfaKT8RfHhpqMKI0IDcVNdexLQaUed2XNJ5N8muCjYMiEs4IDTsCcA84PScPJwqVHRlJjXyvPTH1ALzK3coyWeCwf7k3XCe3eVr6H3w/ExO7x/G9CpdwYVpbyWVgyu3k4vbeXvsgtTADq2eF5O/YkrB28mLkDYaPZEJ0LE18LuDtQ4TrTABdZSCqd4ntJv5TW8Xfv1oTp3aNXZkTUeCPR4AzFsAhtabqAZ4Nxi+5+femcEmzoc0neO5y43jNQbJ+Hr7AkmS7+WBcGhq3QAi/bK+IF5u7+AhSCBp+4t8g/DhIMQvn6RLJcwM/TFWpzQB2go25OTzLNi4apeLe1Zf1mhVTY5va9NSzv6nO60pGhQNT+KRJ4gLoFUB59OY97NHralV3uTEqhMHu+nrsE2kzX75exuP4lcIDOGwgU4Uyr5k7xJCzfUz2s7mYdMMxDmNjlX9OkJN5dRWejbQFj9kzupsqFq3JJjQ4LNGoyAxCHIEJ7cU30ayOf+Owp9R6/+ao0AnQa+1uxBVEa1oY1IKDI1sfCw0e5/7dfHSf/joIOrCWn8VvI4KZuzPeUvLRMboPdgmFJvBH6WTFrR9Yl/MXEM704Hg7E3vhj77pXJhLTV98zBQ5pzQ8EZDrvjrdxQKnUpMaa6xeeDHTbH4pFxogkfkuPQN8kZ5fcR4nlWPHQR6bQxlZmsUaYgvyKtQRob4+2eeO3yM/lYbrpwJE8GV1x9bGxZAWJJjHG9A23u63Beu
 HuKtKZUQ
 qMREbKSjTpGwt0B3sKOHQZhbGN1dWM5yJijkgpNh1eYSFUqZoDUPcQXntVZJOruB0JLz3oHspKFrr9WSpq7WCVb/n2D/YeZhr5trxdwIjWXAz3BzPTYXAykvNATt99cgLwac6vZgAPvDXogboVm6mgMpp/AduyWFVSQnTGTS4TjFOuzfK6WKLavhb2gcJq5w8uEQxmkaA2M2Gf41a1holmYrGys14ZqcPaSTjnYTSD1/zg5k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/05/2026 14:44, David Hildenbrand (Arm) wrote:
> On 5/11/26 15:42, David Hildenbrand (Arm) wrote:
>> On 5/11/26 15:10, Usama Arif wrote:
>>>
>>>
>>> On 11/05/2026 07:36, David Hildenbrand (Arm) wrote:
>>>>
>>>>
>>>>
>>>> Hi!
>>>>
>>>>
>>>> Yes, but that's what the users ask for: if there is a chance to deduplicate
>>>> memory, it shall be deduplicated asap.
>>>>
>>>>
>>>> Right, the probability is low, and it would change existing semantics, breaking
>>>> existing users.
>>>>
>>>> In addition, we would have to add large folio support for KSM, which I rather
>>>> would avoid.
>>>>
>>>>
>>>> Right, but that's what you get with KSM: bad performance if there is a chance to
>>>> deduplicate :)
>>>>
>>>> (and bad performance from scanning overhead)
>>>>
>>>>
>>>> It's not just the zero page, but really any page content. The zero page is
>>>> currently only "special" after we added conditional support to deduplicate to
>>>> the shared zeropage in KSM. The shrinker doesn't help for any other page content
>>>> besides zero-filled.
>>>>
>>>> Further, the shrinker is something system-wide, whereby KSM is usually only
>>>> enabled for selected VMAs (with some exceptions nowadays).
>>>>
>>>> Also note that KSM deduplicates independent of the folio size: not just THPs,
>>>> but really any (large) folio. Yes, it splits large folios, but that's really
>>>> just to keep the T in THP.
>>>>
>>>>
>>>> Right, and it makes KSM more THP aware. Which is something I would avoid right now.
>>>>
>>>>
>>>> That would change the semantics where, for example, where we expect that memory
>>>> was deduplicated after a KSM run.
>>>>
>>>> VMs (where KSM is usually employed) are expected to be mostly backed by THPs:
>>>> except where we can deduplicate memory. Skipping THPs would essentially break
>>>> the main use case for KSM :)
>>>>
>>>> Does that make sense?
>>>>
>>>
>>> Yes, all of above makes sense. But I feel like this means someone should not
>>> set THP policy to always and enable KSM together. 
>>
>> IIRC, QEMU will, as default, set MADV_HUGEPAGE and MADV_MERGEABLE :)

That is interesting... :)

>>
>> (KSM itself later has to be enabled manually on a system level)
> 
> Digging around, RHEL documents that one might want to consider disabling THPs
> for performance:
> 
> "As KSM can reduce the occurence of transparent huge pages, you may want to
> disable it before enabling THP." [1]
> 
> But that doesn't mean that some people are using that combination.
> 
> In the end "some THPs" is better than "no THPs" :)
> 
> [1]
> https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/6/html/virtualization_tuning_and_optimization_guide/sect-virtualization_tuning_optimization_guide-memory-huge_pages
> 

Thanks for sharing this and the link, its very useful.

