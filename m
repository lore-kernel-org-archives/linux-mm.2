Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B16ACA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 08:30:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E3678E0007; Tue,  9 Sep 2025 04:30:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 494048E0001; Tue,  9 Sep 2025 04:30:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D0FC8E0007; Tue,  9 Sep 2025 04:30:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 27CC18E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 04:30:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A984AB95F3
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 08:30:45 +0000 (UTC)
X-FDA: 83869040850.15.AF726FE
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf07.hostedemail.com (Postfix) with ESMTP id B7B7E40005
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 08:30:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iJXsWSjQ;
	spf=pass (imf07.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757406644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=io6XUAtRaEqzKt03f6FT8cXm/79xlUlznTttZ8UFs5o=;
	b=ZacG86Hl6xqfCDIwJd9zpgqney0p/mqcJd7/OqBr1y5LZbB3Pne+VFq75ZYJWlwwR3+PTX
	pbVicAlIR10y8nYlxDlBwxn8JhvsznKHj1OFsWjXrEkn7vtzqKg8s2OTn/EEhG2wAogyqo
	mV6ErR8afI1/GBADG1dyQ4qmJY0Bqew=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757406644; a=rsa-sha256;
	cv=none;
	b=e9jQdOOb1nPw4VCjNcXN0c/J1KmSoO0Ld4lxRnp9c8tEVgVPMqIhO7jfwjrMnJTeO0uXzT
	eCUHwyoIcKsB0xaYClJtbeTjmhHQbQf0dqZQvbpDK3RtxMgWW8EmmOxhIgiFoL78A7weyU
	HS0poe0NQtV6n5T2jzj0NOnQutcZ65Y=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iJXsWSjQ;
	spf=pass (imf07.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <9a88d32f-b94a-4955-818c-e0848241994d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757406641;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=io6XUAtRaEqzKt03f6FT8cXm/79xlUlznTttZ8UFs5o=;
	b=iJXsWSjQxOnAFV4/FTwlY3LbSXu5dqSYuGTp9o4932zyIK/o5NvSZVvHs6f9AKf4MhguLw
	MsBZlSpcM6G37WcNnytUaAYfThcNpVp6SCTnqxAaUlVkDXn+YzjdK4dEF2L6KAQKE5e6Lh
	NGBWe+6PKyoyYMkK8elIjoDU3fweJ+8=
Date: Tue, 9 Sep 2025 16:30:34 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/slub: Use folio_nr_pages() in __free_slab()
To: Oscar Salvador <osalvador@suse.de>, Hu Song <husong@kylinos.cn>
Cc: Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250909074812.599030-1-husong@kylinos.cn>
 <aL_emHbGN3xA5i_c@localhost.localdomain>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <aL_emHbGN3xA5i_c@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: B7B7E40005
X-Stat-Signature: ns6qgkcrraro1szukhjyxdxji59bahpy
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757406643-626765
X-HE-Meta: U2FsdGVkX19mMJVXx+OJ6Vqra71j/1r7G5XqgIrXGbHt6P7KFq+TviSmDkwqa7NqNrodpCRGBQL9v4JlnTJqiuee4P+ECs5EN2zd0R4PvqWxJXNc6vnIQX2fivMaXZa3zf3i0Llfu5qnhs8irhkcejh4EzthExkMxsLzEmohcCiGZ0VIXmM5EWQv3kgumC4AUKdv5bh5nX7hBRcJ8BtE9gQQsYV88THV2HvZY3vNdU8ntF73+AuPd7Y0PixFsUSJeg6aQj5OXYvcLws8nwbxpJvyL4I2tRlAKj4IB2qbGC62jGJb5raa9NXZ8a4eG04ZM0sgyWy0UfWAZLD+5G8Bu3XFSTpepEPzqsNdogrx2M1hE2yHN15DvAPLqcF8o3nshK/65RShhNGxjuID3yBoGrUpSa5zKpWeJqrg4l3MTLES5WGg0XWY8aLqlVaedqik1GqBFSRmUrAtYCpoQ//YxOydC/w/dP4P57OW9WL2Ch2WMdRHj7pXT0vU3idIsnEDAcsk4h/2A/RSAeNc/c4XdlIzww5sOC0AAQ7bPAsTokT2lVyt+Ld3XVZD/idH6oqMHk4XuaqlPUXlqdONaqlL7O33luYYBZ6ZVSEsnS18S+wA59tshLL5odtqPnJn7ATnD+BlABolTW8MG/GtKg4feXQtroo8aLQGdaO9/4J1hRyMiR8ucbNEemgNFMa5ocuKJPguJGI9R1zuiqR5dE/5q0gr28RWPHygcdm+6VhcA8R8uANIfBVle+ZDsWGj2+MPAh+SEBH5772asfUQQtNy+c+lbdWd3+e0Ru6j9yGrdUA28wNEEwCou+UD6xAwKGxoDqI4+ORNeZ3aF7YEy2XIU/3tFSCObX8U13c5MdT4N7h40kq5Hq/YerryhN6yRy2Bpxd+d03kULaYG9RQX5cL1kDz36gPU/SiI49WOEbynhT6V14DtzFx8ZlkFkHWL3DbQlbqVODa6phVSs6YjBn
 6FsDx09o
 +KhSEpJ+EnSVySwa/B/zGqUcvalHEjpsQXIk7CeAlUP+o8+PAquV0Gdz/dVs4gl41qp/u0i45PLfbvuDXg6aVeGWjCzJl7Dv2CLKiUKLExnUKqXUZTeM7ustwDoVSybISkLVZLMYn2NrhCwzDXKqWhypiJPWWJm5mGMecuLf72cpWyz6aTGaL/NON5if6ZQ+V0KIe7LeRcVgV1/lmePkDAfGbziB1FCB9Fd8/VVfrQIyS/Q4zbJ8R8BhAkDyHymmCQ7IldYPlbc84zUFcFLZYItoy78Zsww9OWCCRALeefFprTxbeJ31IMTpfU/lugYW9EC+T
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/9/9 16:00, Oscar Salvador 写道:
> On Tue, Sep 09, 2025 at 03:48:11PM +0800, Hu Song wrote:
>> Use folio_nr_pages() helper instead of manual calculation (1 << order)
>> for better code readability and maintainability.
>>
>> Signed-off-by: Hu Song <husong@kylinos.cn>
>> ---
>>  mm/slub.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/slub.c b/mm/slub.c
>> index d257141896c9..eba25461641a 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -2719,7 +2719,7 @@ static void __free_slab(struct kmem_cache *s, struct slab *slab)
>>  {
>>  	struct folio *folio = slab_folio(slab);
>>  	int order = folio_order(folio);
>> -	int pages = 1 << order;
>> +	int pages = folio_nr_pages(folio);
> Sure nothing might happen, but I find a bit weird that folio_nr_pages()
> returns a 'long' and we store it in an 'int' type.
> And then sure we handle that to mm_account_reclaimed_pages() which gets
> 'unsigned long', but that's another story.
>
>  
Maybe also correct the int->unsigned long conversion.:)
>
-- 
Thanks,
Ye Liu


