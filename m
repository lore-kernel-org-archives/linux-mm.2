Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91A71EC1EB1
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 12:56:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AAAB6B0005; Thu,  5 Feb 2026 07:56:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 658AF6B0088; Thu,  5 Feb 2026 07:56:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5579E6B0089; Thu,  5 Feb 2026 07:56:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4451B6B0005
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 07:56:47 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E368B160507
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:56:46 +0000 (UTC)
X-FDA: 84410402412.01.1D1095C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3093A18000E
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:56:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AEzNcPow;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770296205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ElIOuLrt/FtR1nkQcSBXTHWXRMi4g6+iAQr4g72yE8=;
	b=oN8UJjljqoThRJ98xne8eePNEHr+WfJzXapnxnIj6/IP9XRsAUroHFcqmJ/hSRVEk5BivM
	T7fUAYlohJd/RriCVRDpRnBcJQN36FTA1KKxnnkgsHq5hQKMv2Z1n4HWbRN3+JltEGKnuk
	L/xsXFvS+x7ue4ivsPq67OvlNuVBM+8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AEzNcPow;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770296205; a=rsa-sha256;
	cv=none;
	b=Hclx48CgXOI2/wBo0Rn+FaACB6i37V2EyMEwjRxvN4vPstwmtj5ZRC+wbQAf63YoBGY0qE
	KFcSpwo9NPr+gAbiwRW7fwBpYN91IIEE5K08KMP4c5/5phKWc050ZO0LJrYsD/TrtR+WTF
	3SQXZg8Z5xzIES/HhfwsLgKBa7M4k8M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 989FC60010;
	Thu,  5 Feb 2026 12:56:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37BABC4CEF7;
	Thu,  5 Feb 2026 12:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770296204;
	bh=e5VyJ5rggvxgVaaTXdiX2bO8uDhtniRYd2c5UWCrvPU=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=AEzNcPowN4BXmt/D6Aou5d8c+1I3HBIPjz0gA7sikgv0Ip1rzk5T6BtqxHkZb5VkE
	 DePut29gHzvT8VyvfG9xbgwY+Kibkxt4Pb5EjnOaeBTV5BMNyVVVLMFUNjpBMd1Ugk
	 mPQBR5np1zulD6HftFxxFg09JX0BLr6DopqBYv2cA87ylu0Mt8qe60WVBtaHupSjIe
	 bLmBOpbkINgrjrAieAMtg9kVh9w4PfCG4/U4g6dxJUvV67RnqoDmVI4M9E6VV8PHBh
	 Kt0gJ+sj6BjoBSDBo0z+ZQb2tH1OkHtkHK+Ki2AyawzNqqsCg9diht8nNeNd/ZXMSg
	 GTBttbb6q2jYQ==
Message-ID: <062900fa-6419-4748-81d1-9128ce6c46d0@kernel.org>
Date: Thu, 5 Feb 2026 13:56:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 06/17] LoongArch/mm: Align vmemmap to maximal folio size
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-7-kas@kernel.org>
 <2ce0e684-de54-43ec-be7d-c58bbffb3f4e@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2ce0e684-de54-43ec-be7d-c58bbffb3f4e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3093A18000E
X-Stat-Signature: yxgk9h6guxi9d34cfdemtmmzrx8wmhq7
X-Rspam-User: 
X-HE-Tag: 1770296205-859903
X-HE-Meta: U2FsdGVkX18PTsKz65Bqky5IXiugLJIZXcaCmOe/mpcm37+1QRXvSf2PNoFr9FBz3u6H3A96IqN7DQbSakt8D+zISvmpXcgpDownFcU75oSSi7rZN4MEL9G3r1tlEFxU76Smvx3OBckn/glkuLiz/7QE3jc8HKd2qscCH+CWS4zKjEhS6AiypTQ+U1xNzx9ynWKsHXGY06d20tekp65DQqFAeXVcDOSwDMXhzqn1XJcs0VsTJ7+ODzjBTw70/aEj0tnQk6soQuFER0bHjlRUiK74RbixZTZdP0t1vGK7YR6gb8DozFzKf/mYPaZ2FgADKYlpdvBcaWuzTP2zcL1osX5m6TqRu5Dou2hBKSazbLhNlLJFv8w9WbwZ9/hbmHnqy+heStF+UfFOpbCG1YJP97CMufUa7i3aDDW+BxXCrwwKrUd0XmPPXSf9uh207RaDpxHWl785K5QhJhauG6ebQ0ThgOpc1wOgPw5EmlnNCUT/HZrmGvKE2U4kpBI7AiABWmXqcnEG3VxVgn0yTQg2/UsVK8q1TeCXKy6pUa/bV6EDWsQLaFleKKnUD1GEWY5Oza4R6ESRCPEKwIA0NGjUSBNftWHDRZ0tTTJ+0vt8a62lyD6tCb3cEXSOkSe0RUs3z0K1KBVHjbT/hNREBYeuKWYMqa6Ijh3JVhebt8kt6TunpBTl30WKLZn7tg/dciZu/3w044uESri9JcfK05PjfHZwLUG+ko96ZRhbdn9oRc+p7iAEPdgVGGFW1p8ev0dt7at+o7HD6OH9N/157ZtHIlHFbPu8TnDbj94huKkCnst8JmmG6+7G4Jogb3nvevSyPq8UvebkrtZ18m2CORRIDmjl5Eq/fRcHUCLs4lsJytCrBXwcYwjV+jeDDQhF3iPGbvpS0S8+7+pbVcwDek2qZukJjqfgAfQVkf1YSASrLEVbzdJr4oeqBpRJrjUCUhi3yZm5iY7/YRzp2t0Lxly
 7zhNFthx
 9sCase84mmZI/qcDzPC6GZwmzi3+U1OJzcq0fp1aMvZULrMOJrLtXEXoQHt3ofRD9Dh4VGLh/oppbuF/tbv2XTlTjBrbFa+gzDW+PiYnDk8/iN1dMn3454W279E6FAgKmq10WOcXPoa0kMPDK1Uskw5QK2XGhK7Ys7OeOuSFQLGhEjR97a+IU5xcswyTDMXYEKeXBQS82LkYcy3cSj3UfKBqrpRIxqUS1qujXoL+sENjg81u2VbcCJOem+W79ZSdUFmhXB6MTGZthwh+Rg5JTillDP1VLv4nvXmotHXPJOOB9TFUkoYLVDNgmhQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/4/26 17:56, David Hildenbrand (arm) wrote:
> On 2/2/26 16:56, Kiryl Shutsemau wrote:
>> The upcoming change to the HugeTLB vmemmap optimization (HVO) requires
>> struct pages of the head page to be naturally aligned with regard to the
>> folio size.
>>
>> Align vmemmap to MAX_FOLIO_NR_PAGES.
>>
>> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
>> ---
>>   arch/loongarch/include/asm/pgtable.h | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/ 
>> include/asm/pgtable.h
>> index c33b3bcb733e..f9416acb9156 100644
>> --- a/arch/loongarch/include/asm/pgtable.h
>> +++ b/arch/loongarch/include/asm/pgtable.h
>> @@ -113,7 +113,8 @@ extern unsigned long empty_zero_page[PAGE_SIZE / 
>> sizeof(unsigned long)];
>>        min(PTRS_PER_PGD * PTRS_PER_PUD * PTRS_PER_PMD * PTRS_PER_PTE * 
>> PAGE_SIZE, (1UL << cpu_vabits) / 2) - PMD_SIZE - VMEMMAP_SIZE - 
>> KFENCE_AREA_SIZE)
>>   #endif
>> -#define vmemmap        ((struct page *)((VMALLOC_END + PMD_SIZE) & 
>> PMD_MASK))
>> +#define VMEMMAP_ALIGN    max(PMD_SIZE, MAX_FOLIO_NR_PAGES * 
>> sizeof(struct page))
>> +#define vmemmap        ((struct page *)(ALIGN(VMALLOC_END, 
>> VMEMMAP_ALIGN)))
> 
> 
> Same comment, the "MAX_FOLIO_NR_PAGES * sizeof(struct page)" is just 
> black magic here
> and the description of the situation is wrong.
> 
> Maybe you want to pull the magic "MAX_FOLIO_NR_PAGES * sizeof(struct 
> page)" into the core and call it
> 
> #define MAX_FOLIO_VMEMMAP_ALIGN    (MAX_FOLIO_NR_PAGES * sizeof(struct 
> page))
> 
> But then special case it base on (a) HVO being configured in an (b) HVO 
> being possible
> 
> #ifdef HUGETLB_PAGE_OPTIMIZE_VMEMMAP && is_power_of_2(sizeof(struct page)
> /* A very helpful comment explaining the situation. */
> #define MAX_FOLIO_VMEMMAP_ALIGN    (MAX_FOLIO_NR_PAGES * sizeof(struct 
> page))
> #else
> #define MAX_FOLIO_VMEMMAP_ALIGN    0
> #endif
> 
> Something like that.
> 

Thinking about this ...

the vmemmap start is always struct-page-aligned. Otherwise we'd be in 
trouble already.

Isn't it then sufficient to just align the start to MAX_FOLIO_NR_PAGES?

Let's assume sizeof(struct page) == 64 and MAX_FOLIO_NR_PAGES = 512 for 
simplicity.

vmemmap start would be multiples of 512 (0x0010000000).

512, 1024, 1536, 2048 ...

Assume we have an 256-pages folio at 1536+256 = 0x111000000

Assume we have the last page of that folio (0x011111111111), we would 
just get to the start of that folio by AND-ing with ~(256-1).

Which case am I ignoring?

-- 
Cheers,

David

