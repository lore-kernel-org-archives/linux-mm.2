Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81B42CA0EFF
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:37:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A14D18E0050; Thu, 21 Aug 2025 16:37:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C4EC8E0048; Thu, 21 Aug 2025 16:37:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DB4D8E0050; Thu, 21 Aug 2025 16:37:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7C17B8E0048
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:37:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3617C1A054F
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:37:44 +0000 (UTC)
X-FDA: 83801925648.23.1B71EBF
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf14.hostedemail.com (Postfix) with ESMTP id 60DE0100006
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:37:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=redhat.com (policy=quarantine);
	spf=pass (imf14.hostedemail.com: domain of "SRS0=upZg=3B=redhat.com=david@kernel.org" designates 147.75.193.91 as permitted sender) smtp.mailfrom="SRS0=upZg=3B=redhat.com=david@kernel.org"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755808662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t1nMj8qy4G6kmqXbpOoYTZWHbsQVaS79cwMqjO4h+eg=;
	b=J4OJTQh38YO+FIVwTe2JsNTGPyYWpDQZFyF2GrL4xcITsvmsEE7JykWDRPrs0x5pBvoO/x
	FqZdXEt2pfKqdUnw7pMDMbs7/EWVBzVAzGCD8AcxoMs9LYqc7R7e4dW7NCqTacA6XXmayU
	2O9N/wKtEvbyrdxjpPpwHj2L+ftn2m4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=redhat.com (policy=quarantine);
	spf=pass (imf14.hostedemail.com: domain of "SRS0=upZg=3B=redhat.com=david@kernel.org" designates 147.75.193.91 as permitted sender) smtp.mailfrom="SRS0=upZg=3B=redhat.com=david@kernel.org"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755808662; a=rsa-sha256;
	cv=none;
	b=tPvZNQsI50iHRmTI5ASBRA/cHdwo8P8O9vjQ6HUUTaMRdQ4uhFrnioegVISEDEw1m4PLdO
	AQj78eUVCWvbfCPj4T6ZmNa3EP+K+qlBRyoplV6AkcNpkedmfuqxL6BoMUJ7VSbwnJCLgj
	vJJhzygvih60xeExRZPMX8pXAl2HjEo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id B1F43A58675;
	Thu, 21 Aug 2025 20:37:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F65C4CEEB;
	Thu, 21 Aug 2025 20:37:28 +0000 (UTC)
Message-ID: <0dc9936f-c977-4ff4-98f3-7941b2eba9d3@redhat.com>
Date: Thu, 21 Aug 2025 22:37:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 31/35] crypto: remove nth_page() usage within SG entry
From: David Hildenbrand <david@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev,
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org,
 Zi Yan <ziy@nvidia.com>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-32-david@redhat.com>
 <CAHk-=wjGzyGPgqKDNXM6_2Puf7OJ+DQAXMg5NgtSASN8De1roQ@mail.gmail.com>
 <2926d7d9-b44e-40c0-b05d-8c42e99c511d@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <2926d7d9-b44e-40c0-b05d-8c42e99c511d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 60DE0100006
X-Stat-Signature: sjzbu3urni4qfn3o4cxgt38k7s98wxmp
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Rspam: Yes
X-HE-Tag: 1755808662-316267
X-HE-Meta: U2FsdGVkX1+DhOflvyf19UehoOciEi0LZNvRm/Zovd0lMHPjWfrphQuOtCzkntBQfEnYTPrFAyl5K9puPFxMVIa0NfA6/qK3pw+IMLBuZhE6sA0OBYpgOJSRWGHFYZnI2zC3YXTyU/uYTal84iyEoa9hXVohDqfE47Wo7whEIUtm1GwR21+Xd8PS4VLcQ5DOq9rAh4ugVWRlMOlW5PA6f256cYiUiIyJzfnCjGPoTZi6oeX2PYmyQYSsMn+bORxdWqN3q2vGZ60k4SZ0lWgOnK9Jv9hm3wVSCFVxiBp7uXxFKjfQIuDzrOOq+OI8uqWYg9an3ulrAbVEuzun/EPOqL0wcivG1DND3ViExbHZogtDHGbyvsaCm6cGX2x7d2+TW7gnDzfyshwZAaetncwoE9LRhEnU1gJwCNDOgYSLEWjuD9ezlUj/HZ2/YWqAAPH6YPIZmHe7Iyen9zPVh3Q/cW0urdWOu2sPo4Zm3payOEp5EPj8Ani1GioNaXsDBG2Bcz3B8XDcwjXe+1fzrmu1VgRMf9hsbhuNdMUKvZnic97snO4HdkwX+Ibfe6Uf1BozVSSgZ4luKYY2NiN3Sq4qHaQqZeDU02mN/mdtB/8xlV6LWmfnzV9YWMOOzW4PXEpezS0X6PMhTUHFVlJifcug+GFWGgAfEc+p2dricQSTitVW+dmRXbfVxX2oS0zlo2LAozbfR2MwZ1lgjQcc9aSrxsETEXLXdh/Ubimbpg0cO0+51e1pBc6IqpUhp/zclCuHNVliqfVWJg3wLISaoM7mmwRMUQj2ulxYkYsTwVQ/zR/V0oARUM+MDCS2CRVStrK4TbukctibGtCIH2KTiiVQ4mGhk5FpqN3vzRDE908AFI5PFKoLN/pphAoJZg6+LrVZ/if9t9gzBs+1M7JDQi4XPeLeNGxk45Pz7Ho5CTkJpuMgA0/aglRhRXHuyeaDl+gq3TptlKDarJldJt4sKxV
 20X7ZwWG
 nFjc4+qy1SqIPyZsfOV4KQlsUsczzH8YhXEU1X2arVb65SS95URn3Pt/MvdQDOPrMG+Hh9awPllstRXnJqhlX2pXMUWo3kZALO2npgwV5Wcu9TCHYI8FML5sRp2xWHGgLjD2yTCKMKtsPy6T2KbBtam9yVAbxIQ73yr1OqRPrL/O7Skq8dEe5hjs2L4+e63MA4rouYes0NRW+vtKScokhNPtTZB0+lLX3RLfBW+9wprLuD8aQLs8HHtf9YoGue8usnFi498tZtsdyE6s9G4nLmqelGqoT083hDphdmgXBD/jTN4+RaYN0e03vP5h8sMW5h5mCkFZRiCvPAeCovNYSMyMukVc1h10/a2WPQ6rfF67/4a1s7nEANAZ2XKT1bQ2f1af/1OadnLREwozhPWm6oRUeQOK1HQKh6Q+LEZ7REIMJzeJMkiT+MVO7oIIIFANs/5fo9rwZfYx9gaxUq/NfVVC8SQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.08.25 22:29, David Hildenbrand wrote:
> On 21.08.25 22:24, Linus Torvalds wrote:
>> On Thu, 21 Aug 2025 at 16:08, David Hildenbrand <david@redhat.com> wrote:
>>>
>>> -       page = nth_page(page, offset >> PAGE_SHIFT);
>>> +       page += offset / PAGE_SIZE;
>>
>> Please keep the " >> PAGE_SHIFT" form.
> 
> No strong opinion.
> 
> I was primarily doing it to get rid of (in other cases) the parentheses.
> 
> Like in patch #29
> 
> -	/* Assumption: contiguous pages can be accessed as "page + i" */
> -	page = nth_page(sg_page(sg), (*offset >> PAGE_SHIFT));
> +	page = sg_page(sg) + *offset / PAGE_SIZE;
> 
>>
>> Is "offset" unsigned? Yes it is, But I had to look at the source code
>> to make sure, because it wasn't locally obvious from the patch. And
>> I'd rather we keep a pattern that is "safe", in that it doesn't
>> generate strange code if the value might be a 's64' (eg loff_t) on
>> 32-bit architectures.
>>
>> Because doing a 64-bit shift on x86-32 is like three cycles. Doing a
>> 64-bit signed division by a simple constant is something like ten
>> strange instructions even if the end result is only 32-bit.
> 
> I would have thought that the compiler is smart enough to optimize that?
> PAGE_SIZE is a constant.

It's late, I get your point: if the compiler can't optimize if it's a 
signed value ...

-- 
Cheers

David / dhildenb

