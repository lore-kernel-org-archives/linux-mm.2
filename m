Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C430CF8875
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:47:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C21046B00AD; Thu, 20 Nov 2025 10:47:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF8486B00BA; Thu, 20 Nov 2025 10:47:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B352E6B00BF; Thu, 20 Nov 2025 10:47:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A42EC6B00AD
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:47:14 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 602681601CF
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:47:14 +0000 (UTC)
X-FDA: 84131414388.28.B91ED35
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8F23C4001E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:47:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E6IinNc8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763653632; a=rsa-sha256;
	cv=none;
	b=lQWclNRot4HJWWx+o6/Abb7tVkdEF+cIN8t34ZQLdF8llomdGqmZbsCJ3pS7DjYJWMZJh3
	dUvQGV77Qsh5HP30KpxhYjqHEua+IMIl1PR2+P1l8yDluH/FwEPPRQhK2jsV5BYcLnsdRD
	AFlizUUdxfx60Wo/SoyVhWrtrvLjv7Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E6IinNc8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763653632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2GdbKKukyS+nukrjjJBz/zos9tr08tfD09dnfCOMI7I=;
	b=NDy09sn0OXy8TE2necuHnqz0dwSXnmFwhBGw0qjG2QD60BxvKx8tWm3HnSAgdQNWZ9VcUh
	GxLhxZp8oaVCaRogMTsruT8lx+Fg6OjTlegLflXfl0lneUaRaK1xsRZQGBUc/Jq8/p3IRI
	xP7wmfFmMZ0iBBcG/lhv30IT8AqehQk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 585094403D;
	Thu, 20 Nov 2025 15:47:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00DD4C4CEF1;
	Thu, 20 Nov 2025 15:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763653631;
	bh=GyakaMWsNirCElnFGlF0PhH2jsCrYzoEa8R31fAqmT8=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=E6IinNc89Ul4bxxUG3YY2rPJ47AElRdBBS9kRLJr8Qxi53o6ng3WYveLEIKspbJnC
	 DxqPiKYqeXae/hu+CbRvbCYZJX8LM3CYD9XIYch3a71HwpDznhzg7YgGtnE+3nZw+j
	 DQBPJngJohjPfyhfxXFiHIgU5YjM6gmOWwLXx+/mc9sVYoIhmQsC+yS3TISwzxJDIa
	 jiWvpL8StdmGQz/KyE/7IlOPWgBv+bPLrrU9+sgVidOweLEvLB/IH7aTOlGyOnlDYm
	 FladlDL1C+y6Mf/OiM5xCshvjNGXCqwQdUXrIoVAh77raTMjuRBFh8vrk8gop5353F
	 ESwg5Tt5E1j5Q==
Message-ID: <8cab934d-4a56-44aa-b641-bfd7e23bd673@kernel.org>
Date: Thu, 20 Nov 2025 16:47:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug: Performance regression in 1013af4f585f: mm/hugetlb: fix
 huge_pmd_unshare() vs GUP-fast race
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Uschakow, Stanislav" <suschako@amazon.de>,
 Prakash Sangappa <prakash.sangappa@oracle.com>
Cc: Jann Horn <jannh@google.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "trix@redhat.com" <trix@redhat.com>, "nathan@kernel.org"
 <nathan@kernel.org>, "akpm@linux-foundation.org"
 <akpm@linux-foundation.org>, "muchun.song@linux.dev"
 <muchun.song@linux.dev>, "mike.kravetz@oracle.com"
 <mike.kravetz@oracle.com>, "liam.howlett@oracle.com"
 <liam.howlett@oracle.com>, "osalvador@suse.de" <osalvador@suse.de>,
 "vbabka@suse.cz" <vbabka@suse.cz>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <CAG48ez2dqOF9mM2bAQv1uDGBPWndwOswB0VAkKG7LGkrTXzmzQ@mail.gmail.com>
 <81d096fb-f2c2-4b26-ab1b-486001ee2cac@lucifer.local>
 <CAG48ez3paQTctuAO1bXWarzvRK33kyLjHbQ6zsQLTWya8Y1=dQ@mail.gmail.com>
 <a317657d-5c4a-4291-9b53-4435012bd590@lucifer.local>
 <CAG48ez0ubDysSygbKjUvjR2JU6_UmFJzzXtQfk0=zQeGMPwDEA@mail.gmail.com>
 <4ebbd082-86e3-4b86-bb01-6325f300fc9c@lucifer.local>
 <CAG48ez1JEerijaUxDRad6RkVm3TLm8bSuWGxQYs+fc_rsJDpAQ@mail.gmail.com>
 <2bff49c4-6292-446b-9cd4-1563358fe3b4@redhat.com>
 <0dabc80e-9c68-41be-b936-8c6e55582c79@lucifer.local>
 <944a09b0-77a6-40c9-8bea-d6b86a438d8a@kernel.org>
 <1d53ef79-c88c-4c5b-af82-1eb22306993b@lucifer.local>
 <968d5458-7d2b-4a8d-a2a6-0931cd87898f@kernel.org>
 <c798628d-9bce-4057-a515-8bc02457f370@kernel.org>
Content-Language: en-US
In-Reply-To: <c798628d-9bce-4057-a515-8bc02457f370@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8F23C4001E
X-Stat-Signature: 5yz7og81ryiood74hq1hgoqg5rgdwend
X-Rspam-User: 
X-HE-Tag: 1763653632-306610
X-HE-Meta: U2FsdGVkX1/kjBTJ8fjPfoDpvVjvkx3UfqKlhU9jGg+j6eaCDaVjGb3PFqjuIYmjgtmmaUqnIycX8flfVUQmhYrYIomtWzmCn0+gJlf2qzYcw6PpeXdlCSCHx56corkFDKIFKpZnmfrac1q27UxLrWWZpYxlMAIRi3qE5dn+MPnD4PvVSxiyTvacm/jLfIhW6W0usQwfjLt6de/GGjJggFK5gJHGhxGbwDcoz8+PGCiUGUHZr/Jtod6s5Kbc5lPlkjvq/q3NNDiL/BEbG9ayySgVPHYQMsg49Rlxxvw133cbjoeZnYwTc7MOZfEuFlZE7A+zA4n05oH1rPsVLIKJeJCkx9GG0uTdLxZssFWWhKlbkfalk+JWIpRazSdLjlSu4/iQcT4qNKn55TKV4R7c5opOrWOae+7n0K9in53ZEOUenAGIx3EK1BE7IhtYAPW/Oi1rKC26FrtqaND9LSzTbmqDVJpDmkW/Ev/ltIoKrvO2i65thUzwuNA/L7HdWG92E0hi+kdNQNlBbyFb+5rINp6d8LbO+yIUpJonhayg8gtoPkjREeAWrjkfC04lEzBSh/KWR8fsf0qDDDqitHK2ljsQqqS+vlEWjK+6AIYUkx29tu3zHnwraxvlSE+qmFOzkyD2YPOm0KbTdlgY4RoWnVaUS+GsRTlAHYVKX+4YKGTjxX9TgaOJ5oMOQ76e9iux06s15QdfgVbazx6I6xLpIt1eOzQSZU/t4f+sfW3u3218uLqPsRZfoAIo1Vvxljpbct2yJNgkhKlhQdLPo++cZDauOrnpU2Uv4NkOB+VAEK5cIT9LMAJT2arJMBmstuaSXDAfCw9ZGSBihlCCT3mvepxmSVfLFu92ZUHy3xVimRRISHM/HZCtWE44udIgTc6ltxBAzV6hnaJs3bHy0gkdtG+xSp7Zb3+gew2Fyki5ZfaKVtNdsU+iYiMz7tiZQUgPSC95yiKIvFlJaT5qYrH
 1XDesU3v
 nmjRa6sTz38V4ZQCK3viQAkMHJACVHDQNTbOMvXDsvW0zi1ig0HAeJ/Uc9aAHQjv5j+o3zhNiSd8m9Zcnzs3WRqaDx8D0tPj7zDVIsQrosVhw0akPwd9uhqDJ7PPxdTnyvw4uVMpnWfqRdZI558TZ5KvnHUUEu27/kqQyoCldpRa+awUqKtgUoU/BNko56u8HFe9wp/kDZrHpE+UF/M52ksaRUXbMvWSOd1XWOoFI7fxm57ODlPgjioVHTYxspZdu4rxfbZMpDgZRdKdnRHG6I4vtE2I64fAlAdhpUtpQoF/5D6Z9KKVqYM8SqZLoe5Y6Ou0WmhbthbYzUyBoO7hrK9JMhWVtP2VqiTQ6wdOaGfCzwk55g1rA+zGdOQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/19/25 17:31, David Hildenbrand (Red Hat) wrote:
> On 19.11.25 17:29, David Hildenbrand (Red Hat) wrote:
>>>>
>>>> So what I am currently looking into is simply reducing (batching) the number
>>>> of IPIs.
>>>
>>> As in the IPIs we are now generating in tlb_remove_table_sync_one()?
>>>
>>> Or something else?
>>
>> Yes, for now. I'm essentially reducing the number of
>> tlb_remove_table_sync_one() calls.
>>
>>>
>>> As this bug is only an issue when we don't use IPIs for pgtable freeing right
>>> (e.g. CONFIG_MMU_GATHER_RCU_TABLE_FREE is set), as otherwise
>>> tlb_remove_table_sync_one() is a no-op?
>>
>> Right. But it's still confusing: I think for page table unsharing we
>> always need an IPI one way or the other to make sure GUP-fast was called.
>>
>> At least for preventing that anybody would be able to reuse the page
>> table in the meantime.
>>
>> That is either:
>>
>> (a) The TLB shootdown implied an IPI
>>
>> (b) We manually send one
>>
>> But that's where it gets confusing: nowadays x86 also selects
>> MMU_GATHER_RCU_TABLE_FREE, meaning we would get a double IPI?
>>
>> This is so complicated, so I might be missing something.
>>
>> But it's the same behavior we have in collapse_huge_page() where we first
> 
> ... flush and then call tlb_remove_table_sync_one().
> 

Okay, I pushed something to

https://github.com/davidhildenbrand/linux.git hugetlb_unshare

I did a quick test and my house did not burn down. But I don't have a 
beefy machine to really stress+benchmark PMD table unsharing.

Could one of the original reporters (Stanislav? Prakash?) try it out to 
see if that would help fix the regression or if it would be a dead end?

-- 
Cheers

David

