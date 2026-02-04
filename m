Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4C17EA7944
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 21:14:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0F046B008A; Wed,  4 Feb 2026 16:14:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBCAC6B0092; Wed,  4 Feb 2026 16:14:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C74256B0093; Wed,  4 Feb 2026 16:14:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B3D0D6B008A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:14:56 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6B34713A7F8
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:14:56 +0000 (UTC)
X-FDA: 84408028992.09.FF54142
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id B0C6A4000B
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:14:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MmEvGNuS;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770239694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4nLUw54ZQ5pHQ6ZwylItl08lvjGNIMY8JJapJ6me5pM=;
	b=11aEG8IRPXzQS1MIPDXl4x89KDi8qzgzXCf52Ovw5TRjURGaK/ldbsv82KbBzwakFKpJ6+
	1xt12E3wi/enMpWybylTb4BYPG0D8DQRPSlV+A1HGMrIAegnxF13ERRqu/hHSuC1/9NC9V
	pkp2koN4lK9j90SjpYFj0BSqgbyx8W8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MmEvGNuS;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770239694; a=rsa-sha256;
	cv=none;
	b=FioX6atIdP4kFCUSk/mGrOIZtOc+OjI1ATMTfpldW15NKXvgzENKuLO8RrcsKhLVhQntCU
	hS+S+L8ZEiYSnG2b3687CUELo3JnkXOwntLKUAX9EyBMARf8Hjl09mxwW95wZA1Oy6r33z
	QUuEq17FAa/pcLLrVSQxkotxwwqZ3xg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1F37A60054;
	Wed,  4 Feb 2026 21:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11FBC4CEF7;
	Wed,  4 Feb 2026 21:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770239693;
	bh=oAOu0Okr/82bp8yyu+4LQUmMWWVw2RhgAxBYpAn99LI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MmEvGNuS4AFAleo9RH3oaj/4hU71oUjr2weE3X45t3aN5V20ak+iRE+073fXmHpaS
	 cxKzgqeqUZyvdNGdoZnrROTRi8OkMDXivWtnQLjKiwNOBqntm8ZK+4nDOBU+v72uLC
	 mM+ujrNmRkjdDgUO3Vjx2BDKifHrhQ+0fSulbD1rc72dhINtKjt6gett7wZOeMnKAd
	 ksBZsCzgaQpYcSDdW82QiF6cOHx3q8zZxcvXaVM8TuEqr00kmVjm0TaMt/Un1FeVUA
	 xgUgWi3516UfcoIOQ8v0rwKIb5w4nkS7fd9DWKg52v+qZyIsEFKaLiBvr9vAR9+TaU
	 QOKTbv4GzbqLQ==
Message-ID: <29f79411-3ec9-4e03-a1f1-2869164dccd3@kernel.org>
Date: Wed, 4 Feb 2026 22:14:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: WARNING in memory_failure() at include/linux/huge_mm.h:635
 triggered
To: Zi Yan <ziy@nvidia.com>
Cc: =?UTF-8?B?5piv5Y+C5beu?= <shicenci@gmail.com>, linux-mm@kvack.org,
 linmiaohe@huawei.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
References: <PS1PPF7E1D7501F1E4F4441E7ECD056DEADAB98A@PS1PPF7E1D7501F.apcprd02.prod.outlook.com>
 <b9e89c85-807c-4a8b-aa5c-8c1325e75445@kernel.org>
 <1db245a8-f9ab-42e4-8cc6-cc7562961921@kernel.org>
 <48978612-6933-4897-85DD-6740B6C8570B@nvidia.com>
 <25CA4D90-A24E-49C6-92D2-08080EC81466@nvidia.com>
 <032058DC-CD8D-406A-B986-740E41C834B2@nvidia.com>
 <e97d5c0c-b8ec-4da4-b838-7a308f8a6327@kernel.org>
 <9E046323-740A-434A-8B60-B8A32D0955C0@nvidia.com>
 <11399c99-f966-47be-bbb4-a7d4e79c8c38@kernel.org>
 <86002E57-58EB-4940-A7F0-7AE4A60484DF@nvidia.com>
 <7bb98650-cb7a-4230-8868-7da2aab5923a@kernel.org>
 <0BBB65F0-7ED4-40DE-9949-761326993D7D@nvidia.com>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <0BBB65F0-7ED4-40DE-9949-761326993D7D@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wahbunawcdi7xxio7fh7xbramxk1kuz9
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B0C6A4000B
X-HE-Tag: 1770239694-18497
X-HE-Meta: U2FsdGVkX19UB/K76EjW35bKPz1W+wulyIUa4gJT169wNzoitolNKMHk4UJpx2ZxXb8WtvbS8IP8C5klXudSGfGI3qb+hK8T13ahPhXZipbv9HUlRoHdJ0O0F1OqFys7AE5Wo0UWls44PRnboQqhOcEfEW11p3jUi/NM69fYfD2ocK9k/XygR4LzOMZpHRjfS6YuO8/BwnCGZfgzb/Oaca7pz+LjGKA0CTuvzy92Bvt8AoYkRGL9eD3ZkNNkH4LnITLtXzjIMj0qYobHxH9ZkHDF8vctZyQCTyizEq3Q8vX9MGjxLTVuZPqHeWTlrriZ9rsSPHXIkQyTlkg/iaRxRYrwzuYy+pXooH+FQIhF3m1Mw+rHciq7VsTAtzs2rhrjX8HzrOrLPSto96eKKcSku5ot8GtwZtmemKyGdV9nnrzhiW92bCtLB9I+hAxsLTqEO9p1ZD2chAgE4/HJLvu7NsKs1B0KPSFwkOIhpC2OVY1cnKLcq5+9KRD66PAWBsqRqDPrYODMG4ECRB41nSCZULuw17xGeEdlA3YyaogUDmnYf7A1blrhakJnCTNR5omqkQZA1JYxtCXe7brbHhNVRdx77oDpylWJD/67AmRwW/zr9ia8UaGcVXxSC76nW3sqol+IykVuAfPUo85PBJr8/s+0It782pkYDXDsENh++ICklYmYGRWz5DFQwsnOe72OH0CpcZ9JhZGEYJaYZH5oJdDV9Y4M6xSqqO2/ecKhMq45NRx51nGxAdyi9vj1DUQzb3UsEB5Pw1ns2DOFEcZRH9XGvkGao33OqNNlgTMubaUgv1KzofiKnhY1KzyhspbT9XHSq/aqiIpp9kg8RtYsnkn1HCZ3QyiF6aos48KPTNKw5r9NOuS/XX6fgV+GjhiH0jl+awpQBTtiS+c2vDafTlKFFnZ4PYpk3YsIU/uHS9+bbTLlusHq17CRyPF9ghh/EhJCmxo3R5zqEhzJUWu
 +Qm3m8Kn
 Et2uL9U4EB97wwc/7cz7UAPtWs9UYNVrk/uwduEQBNqKydN9+WViMzYOyoASRnbk/jIEslAgYJ88pgevzodXi+dcVlOTmZzB/vTkkeuBYgoe+iUS5OdtQun96ivY4dgwlAkZJjp5rG6SF6egr+uA69TnSHwnX2tRjXqIkvXubHo4FtUYQU72XQsUvMlRdq+w+5WgEApw9/Fa548WZl4kbHqEmt2zzpgtn8pPcjZd3fxHPcggrOprZmA+gudWxkuf1hwyJg4Y42lDLWAk+C/vqRKtk5D1xlfvkvteu7i7GmXn7IY47Qf4QvaxIyjH9qhxrydWPqEj+46xAiUvcdUZCc2fd6pkq4JyTBYvf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/4/26 21:45, Zi Yan wrote:
> On 4 Feb 2026, at 15:31, David Hildenbrand (arm) wrote:
> 
>> On 2/4/26 21:13, Zi Yan wrote:
>>>
>>>
>>> Yes.
>>>
>>>
>>> Right. My patchset[1] is trying to add it, since hugetlb is used as a folio
>>> in most places and large_rmappable is a folio flag.
>>>
>>>
>>> [1] https://lore.kernel.org/all/20260130034818.472804-1-ziy@nvidia.com/
>>
>> Still on my todo list :)
> 
> Sure. Wait for your input there. :)

Hoping I'll be able to dig through that pile in my inbox fairly quickly
throughout the next days.

Thanks for all the review you did why I was not paying a lot of attention.

> 
>>
>>>
>>> Yes, I am thinking about removing mapcount in struct page to achieve that.
>>
>> On my todo list :) Stupid CONFIG_PAGE_MAPCOUNT that is still around and stupid partial-mapping handling.
>>
>> I worked on this after LPC but was distracted by PTO :D
>>
>>> And only pages used for vm_insert_*() and folios need mapcount.
>>
>> vm_insert_*() won't need it for non-folio things. Only folios. We just have to teach the zap code to also leave the mapcount of these non-folio things alone. IOW, identify them when we map/unmap as "not folio" and not touch the mapcount.
> 
> Oh, that sounds great. I thought I would need to convert all drive code
> that does vm_insert_*() to use folio.

Heh, no. We really just have to identify them when mapping and unmapping them.
"these are not folios".

> Basically, I hit
> __folio_large_mapcount_sanity_checks() on _mm_id_mapcount when I moved
> _mm_id_mapcount and friends from prep_compound_page() to page_rmappable_folio().

Yes, exact same issue.

I ran into something similar in the past and documented it in __folio_rmap_sanity_checks():

	/*
	 * TODO: we get driver-allocated folios that have nothing to do with
	 * the rmap using vm_insert_page(); therefore, we cannot assume that
	 * folio_test_large_rmappable() holds for large folios. We should
	 * handle any desired mapcount+stats accounting for these folios in
	 * VM_MIXEDMAP VMAs separately, and then sanity-check here that
	 * we really only get rmappable folios.
	 */

should have been "for these pages" now that it's clear that not all pages
are/will-be folios.

I added an rmappable check in there back then but found out about the other
compound pages.


> IIUC, __folio_add_file_rmap() can just return if a non-folio compound page
> is encountered. Of course, remove part needs to do the same.

We should never call that code, because ... we don't won't really have a folio :)

With Willy's changes, page_folio() will return NULL for things that are not a folio
IIRC.


> 
> 
>>
>>> Code
>>> uses vm_insert_*() on pages would probably have a struct mappable_page
>>> with mapcount.
>>
>> I don't think we'll need a mapcount for them. Only for folios.
>>
>>>
>>>
>>> I think it might the other way around. memdesc does not have mapcount,
>>> if we do not have a separate struct for these mappable pages now,
>>> what do we use at memdesc time? folio?
>>
>> Folios will have mapcount related information, yes. Long term, memdescs will for sure not have any.
>>
>> Real fun begins once we start messing with refcounts. vm_insert_*() will be "fun" on non-folio things.
> 
> Yeah, maybe we will refcounts for every used memdescs. But who knows.

Some of these things should probably be frozen pages and use a different interface
then. A bunch of hard nuts to crack.

-- 
Cheers,

David

