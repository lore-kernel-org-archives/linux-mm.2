Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 284D2EC1EB2
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 13:55:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C89B6B008A; Thu,  5 Feb 2026 08:55:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A04C6B0098; Thu,  5 Feb 2026 08:55:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79F426B0099; Thu,  5 Feb 2026 08:55:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 64B9F6B008A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 08:55:02 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EDAAB140543
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:55:01 +0000 (UTC)
X-FDA: 84410549202.10.02354C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3F7EDC0002
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:55:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VVxV9842;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770299700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yo9DSR2LUZlbJ6nSls4wEgtWzOahzRwvPpN6s9ILNVU=;
	b=z4Vbn7sXkOOH9Ux4+p8RRfKUU9tDf3mqbwazPYveWCdrwU4r5fRjApFlksIj0G0taBgiVP
	M0Mw7MRa/DjfdShKl+UrBzxdXPB2977BooAwz7b87e88+WYxqHyEpeFonZdtQwYQS1dKuE
	kevs3tOKWXxT7x30R8/wDTfRdLBAOLw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VVxV9842;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770299700; a=rsa-sha256;
	cv=none;
	b=fnwmQJx850Dfsqi66ygkw2cQo5KeylcaXsIyFS/c2I9zmBrpEL5+G2SLC9ffIDq2JA/kVE
	ftLwLIGZyu5BE4YMW0OZS4ZFYTETpRokqRZTaWvFUyAkECnhFvQl+Jtiyy/sSElUYrDF3x
	dVRE1+Zs6mNlT+tNLbR+aQu8xj8h0ZI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 310E343C74;
	Thu,  5 Feb 2026 13:54:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BBDC4CEF7;
	Thu,  5 Feb 2026 13:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770299699;
	bh=sFil3yu86GERvqyxBASqk6D+b92nzCIAxVRDzXFk5IE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VVxV98426Dh4XEprkhO91xKxeVP1Npp1yUwzn3nwz3RVGemzysZC6GWZIpGvjw9jj
	 QmSyc6sxsBqFRjV4mF8OH8LOYc675cgH1vSsOOGBsEvavV8rsZfEdh08n3Z9ny1swQ
	 QIrrQJBoL3WAgulMHMBcV8GaAtZvYTC1wnWKl/Q2N7b1eBQpA+qqvTv5K87WGlWbfA
	 lTFLgWuRrYh1ejR45a70HRnbd+9Sofv5aszwiUMTOB30+16EhwvH4vYVFA+6ES/1QU
	 7VSVmcUn+x1bqVi9f9woMoqXOdgGfGUOTgO90Wsrpw4q6gfowvKjxTh5WSmGQoWPr0
	 VXfHz2EgbE6AA==
Message-ID: <f47be155-8e3c-4bd2-b312-0e7c57620797@kernel.org>
Date: Thu, 5 Feb 2026 14:54:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 05/17] riscv/mm: Align vmemmap to maximal folio size
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
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
 <20260202155634.650837-6-kas@kernel.org>
 <1b80b189-b549-40ba-800c-8037ce12b081@kernel.org>
 <aYSe0TAIzxJ9i1Wy@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aYSe0TAIzxJ9i1Wy@thinkstation>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F7EDC0002
X-Rspamd-Server: rspam07
X-Stat-Signature: gpp9f71iyrwbk6ez8y335yksyqfx5uqm
X-HE-Tag: 1770299700-212121
X-HE-Meta: U2FsdGVkX1+oMxKb7oty4FKX2fBefS5GUAnce0xmA9f0HN0bsXoj/3KrmX92DpVYrrKCKbC7HEgA4zOJKjlnzrGv+DrM1bUUA+zYV02MmkIP4RZka/aG6rztC79xWn9brUE7VJG74hBbUyqfr+Dh6nlPE4FYDz/Ff+dGMn+tI9kCRklYX3cR+f5E6qV+ck/oVkYmepZzHQ02ZCG+mLSgthCgWs3dQz4M0VE+l6jqrKK0SB0B/qdzRy3b7/u/vp3gn+ajGGOzN/630AFFqGE2P/6aH9mskkbkLSmwkoCOFBI1xCNve4LRQRGNkWveIdLLxQuahd8bSHg0d4w7F7osTsD+PMBs3UIdeztsIaBmlwJqujb+bLQeLkOX3VdHr4EGZuIvrJElt56k5madRzmc66cAaQDTl3ZpHnLa4gzUmr68seJlFa7W8oAywZrfgDtKcxNlfH7nuwbPuW2GJZqCSg/06AIaKIddeKl12ECvUELZvYxYD+mOeqvkYisRSEngq+nOImz42VVNytp4B7jRcZy3u29H0NUnxrUkhW9356J6jn1TuFPF5P3kJFryJn9WFpNqffpbeBR0Ls36NS89YCBAYne8xWw7rQIfb9dVpUrJ+WtbQ4nn3wGYDiGuSy/Kf82ghSfAJqzNDq3jTkbzOvBJqrQWEKAlqi2i2M3b36w+vr5yrJR2NaKeeBUtTlZ9759RXLrAA1IzppTtIIT/JQLWdKunbw5Q2KUzn3pt9ZuUe0r6ltm8betdfchi1IvMBXGuWWbPQpxQY4yxNqmcMLUrcvggOb3vPaILN4+qRRXWmE5pPyhL8uBDyp/ABS3LYgBpbHyjCec+jlW+VPpmq2Y7u6yRVw9HdJwEkCQSm3osHslxb5h/qk60a0BhRZJBjg9mJaKTx1LKHIRvHqnWn5EHY7bVtX6iYhIBbQFjWYoKhiP3sqRZxQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/5/26 14:50, Kiryl Shutsemau wrote:
> On Wed, Feb 04, 2026 at 05:50:23PM +0100, David Hildenbrand (arm) wrote:
>> On 2/2/26 16:56, Kiryl Shutsemau wrote:
>>> The upcoming change to the HugeTLB vmemmap optimization (HVO) requires
>>> struct pages of the head page to be naturally aligned with regard to the
>>> folio size.
>>>
>>> Align vmemmap to MAX_FOLIO_NR_PAGES.
>>
>> I think neither that statement nor the one in the patch description is
>> correct?
>>
>> "MAX_FOLIO_NR_PAGES * sizeof(struct page)" is neither the maximum folio size
>> nor MAX_FOLIO_NR_PAGES.
>>
>> It's the size of the memmap that a large folio could span at maximum.
>>
>>
>> Assuming we have a 16 GiB folio, the calculation would give us
>>
>> 	4194304 * sizeof(struct page)
>>
>> Which could be something like (assuming 80 bytes)
>>
>> 	335544320
>>
>> -> not even a power of 2, weird? (for HVO you wouldn't care as HVO would be
>> disabled, but that aliment is super weird?)
>>
>>
>> Assuming 64 bytes, it would be a power of two (as 64 is a power of two).
>>
>> 	268435456 (1<< 28)
>>
>>
>> Which makes me wonder whether there is a way to avoid sizeof(struct page)
>> here completely.
> 
> I don't think we can. See the other thread.

Agreed. You could only go for something larger (like PAGE_SIZE).

> 
> What about using roundup_pow_of_two(sizeof(struct page)) here.

Better I think.

> 
>> Or limit the alignment to the case where HVO is actually active and
>> sizeof(struct page) makes any sense?
> 
> The annoying part of HVO is that it is unknown at compile-time if it
> will be used. You can compile kernel with HVO that will no be activated
> due to non-power-of-2 sizeof(struct page) because of a debug config option.
Ah, and now I remember that sizeof cannot be used in macros, damnit.

-- 
Cheers,

David

