Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAB03CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 06:47:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3167E6B008C; Tue, 12 May 2026 02:47:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EF7C6B0092; Tue, 12 May 2026 02:47:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 203806B0093; Tue, 12 May 2026 02:47:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 101206B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:47:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B5E1F1C02A9
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:47:56 +0000 (UTC)
X-FDA: 84757837752.25.D43B82A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0CC3740005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:47:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Y+Vq/+kn";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778568475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I6E5kyBHWqlHf+/Gtc1GVoBswrE2qZRyIkFTH+w3emU=;
	b=qUMXPymE8juFizVQMLXBBofVcxYcgVY8u8K+xXgGHp2xmItDjtZJlPgno0B4LHgKG7W6sC
	4fhrx6cxn2Vpqt4TtFkuAaswwRP/BqrbQefVrCRC4Qc/MGEE9+w9GwW6V87KWo67yVRqEV
	F4wRqNuiXvqG0Muh2qApGdRlXK0E8KI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Y+Vq/+kn";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778568475; a=rsa-sha256;
	cv=none;
	b=sQYjxNpXdvGxyLx/idy1vvPi5dpt6fauTvCnXsA6qILr8D3xNZmldBi2YOdu4Hw/iI5PIk
	l/TfA4iM3nv23a5bBDy+3nfte3+aMzrufgIoW0tkfJ42HxEGwSGB2KGyeHL//Qx0iX3WuM
	0Cp6zjb5Oo/KXFS5zeqhAW57khmj7M0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6EC3A60126;
	Tue, 12 May 2026 06:47:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA01C2BCFA;
	Tue, 12 May 2026 06:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778568474;
	bh=znb+tX+r6T235ZS5HNLK+QxawBsaGf/IdcCTZMqLRqA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Y+Vq/+knyZI4VnnF4ShT+GGtlQMb3D2bGKxc8fSm27jU7wVLLsruEkfmsGoGukU3A
	 pr9bNxaDsYx8Q61wwldFLMUV2owW66wuz1pa9C4YmtwNof4Etd1KvZO2HxObq7iufu
	 gnYr2+cXjig7nuPPG97J6Xtvfw5YoEAMsggfdeI10fMJ3tMtbvt0Gme3zGHU2vNTnU
	 XlxWGAP0M/mJPqtrExlAnkeczmER+kz8VuKgTh6V9CaBX8LdjYhTDinBnO19+mzXi+
	 /omcduC71RkDXFwzkYhs7+KBCwuDmOVvO9ulPNEQ2XHQ9eENh+pKB7NWlY4VCe7c5y
	 YMlm2U2X4nFaQ==
Message-ID: <f7895374-b43f-4ce7-8a26-112ad30c9273@kernel.org>
Date: Tue, 12 May 2026 08:47:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: "alloc_tag was not set" when running mm/ksft_hmm.sh
To: Alistair Popple <apopple@nvidia.com>, Zenghui Yu <zenghui.yu@linux.dev>
Cc: Zenghui Yu <yuzenghui@huawei.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, jgg@ziepe.ca, leon@kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com
References: <be9a8bae-9223-4966-bba9-2cbe39c8f4de@linux.dev>
 <10e4565a-b416-45d9-a8b0-cd32532b2630@kernel.org>
 <2b46241c-158b-c9dd-9b81-a98366b2c9fb@huawei.com>
 <c16350fa-2f74-4517-8d97-4772def97b78@kernel.org>
 <dff84fe1-ae17-410a-93a2-c5fb921e7f8f@linux.dev>
 <agJ9762r0HwKSsb7@nvdebian.thelocal>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <agJ9762r0HwKSsb7@nvdebian.thelocal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0CC3740005
X-Stat-Signature: eh7jqppwidsyk1kueu1hfhskthqzwmxq
X-HE-Tag: 1778568474-669554
X-HE-Meta: U2FsdGVkX1/LRXbgaaRoO/EyAWflvP4r7D2dlwwLXSlfzQMbxtT1ERxPyouS2DdpeP03DjWJsBT55rRIYH0XLagMShVyhhjGF04TqjN4AED7N0RtRAQRac+BulwKm+uVFWCWHSG4kZQkp3K5e8samEh53B2+otSfiUOSQU3h7SU504aItvq6bRU1sWZONrS5EfsiTR4+OPvqkGQYL31nsap6BZ3if6CkRSQHBgS7RKHude8HlwlJ0u2iozP2k2GmKHDbyNsEEAB2hbG0BRmnGl/99dVg6DTygjHZAYJYgX7sBdVj2AMxjO8bnXdDYmBg1+bfsm7XWeHEoisSMGqc1qjtZQOkIkphfO/r4RTcRzbMFcDGsCYyAq6k19lmmVaB/urar1jWPPLmvvPxOlXfEAycuDzYzch4CaNJcCvUW+9xMSWRaWmbExase4k6RoI0hwjfsxLGkD1rpYYG+rVWOiY1Uh62ogi/ogm/vYdQJNXe1EvLBK1UNi15BIHmG32AT4rzkcM9oy2+W0Eu3ToejeI8eWH+3qIqQA8QqkA573jgT7hMBlYpTozPH/5NalBw6jYrngJzRjQoBaGuUOZJvr3KY8KSfn1ZRox/PFZIF35mSWhgkYO9yr3lPRATsKL30ztHK/fH0VoBoJ8g3dm4/oWOlTTbMW3Mly7ru3uLKzNTL7bKF9yLr9pcYzI/ipJyVPGpXzMvmkwwGZGZhc/Ssjv6D87zUh7gWDHNW1DtJDYaCfOjspaK976e9wFA5SwTtQxSLcSLfdAF0MNC9chL3b8p8GRYUTn0ZlOxdjobj/aIlBLZjw3jpKyRme32SkrtYwvKAhJKrns19GMA9TdaQPz/CrYpKABIwGY9Vqafq2XOGXXM5twQkRQ5QXsFR/4h2GQAF34D7C3kHC4ap7BncMluuoeb7BIlUM5GHKPWuDSqJhM0Y+Vy/JAi9wA7ytqp3YFvxIlavTmwYrzoeQl
 QISBmGBa
 l928rbLgPaMalUZ2AQldGtpDMd95ZJOEQtK9SKz5Vk74gB99NjHGguR5bd+DXX0ztoRJcABp5Sx2Cn9aDtQNqQIy+rLEVwBKrghdEapgiWUuAkObsjLx/Fn8OeynHm3Hn8bBo16JrcMBWTrgQrp2ilnIjWpRXpMqkU8QqYFmLqWpaCU0iUBZuyzR1SyneMrEv2GPQKqXD33h2C4SbwlOqNOzAEw7Re4iovB80S3VxMm7XdKE8OFXftiA4xlBap0al2Klyw/TJhckMVAiyqIEAKir3zp61WpIZPJhicLwtZFOoPlfpNUV28UHIPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 03:28, Alistair Popple wrote:
> On 2026-05-12 at 02:38 +1000, Zenghui Yu <zenghui.yu@linux.dev> wrote...
>> Hi David,
>>
>> On 5/11/26 8:47 PM, David Hildenbrand (Arm) wrote:
> 
> Thanks. I have reproduced it now that my fingers are skinnier.
> 
>>>
>>>
>>> zone_device_private_split_cb(), that ends up calling ->folio_split().
>>>
>>> We do have a call to pgalloc_tag_split() in __split_unmapped_folio(), invoked in
>>> __folio_freeze_and_split_unmapped() before calling
>>> zone_device_private_split_cb() when iterating the folios.
>>
>> If I read the code correctly, pgalloc_tag_split() in
>> __split_unmapped_folio() deals with device private pages' alloc tag. But
>> what alloc_tag_sub_check() warns on are real system memory pages (device
>> page's backing page), which are allocated by
>> dmirror_devmem_alloc_page()/folio_page().
>>
>> static void dmirror_devmem_folio_split(struct folio *head, struct folio
>> *tail)
>> {
>> 	struct page *rpage = BACKING_PAGE(folio_page(head, 0));
>>
>> Thanks,
>> Zenghui
>>
>>> The zone_device_private_split_cb(folio, NULL); is then called on the first folio
>>> after looping over the other (new) folios.
>>>
>>> I would assume that __folio_freeze_and_split_unmapped() would already do the
>>> right thing?
> 
> Well you know what they say about assumptions :) Although in this case
> __folio_freeze_and_split_unmapped() isn't called on the backing page anyway
> (it's called to split the ZONE_DEVICE page, not the page simulating device
> memory). 

Now my brain hurts :)

> The problem is we're not splitting the tag associated with the backing
> page for the simulated memory.
> 
> I came up with the below fix last night, but I suspect it will quite reasonably
> get NACKED on the basis of the symbol export so was looking at other solutions.

I think there are other problems ...

> 
> The simulated memory should just be used like a bare physical address range. So
> there really is no reason for the backing page simulating device memory to be
> allocated as a higher order folio. Using the struct page to store some metadata
> for the simulated device is convenient though to avoid creating a test-specific
> data structure for this. So I am looking at going back to allocating the
> simulated backing memory as always order-0 pages in the test which is what it
> was prior to the introduction of large device pages, but that was causing a
> crash I'm yet to debug.
> 

... such as doing a folio_page(folio_alloc()), followed by a __free_pages().

Why are we even allocating folios here and manually splitting them?

Looking at dmirror_devmem_folio_split(), aren't we using folios here for
something that ... is not a folio?

Likely we really shouldn't be using folios here ... :)

-- 
Cheers,

David

