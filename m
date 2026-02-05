Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D7DDEC1EB2
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 13:52:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61EA96B0089; Thu,  5 Feb 2026 08:52:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 600346B0092; Thu,  5 Feb 2026 08:52:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F54D6B0093; Thu,  5 Feb 2026 08:52:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3CAEF6B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 08:52:39 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0014DB812B
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:52:38 +0000 (UTC)
X-FDA: 84410543238.11.4D57CDE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 449D040003
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:52:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PABi8CWR;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770299557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=klKF5+ynVpsYqGjWD6y8zGhTopTs2YGQECUAQQ5MHSc=;
	b=xZTPU9+QIY2Obx0XbalBu9TlXplHBnt8OKsT9wSVAfXT2t4fjHRl2q8HRbAV0mvpeP/92w
	BXWL3o8hsAQzQm7PWmCtYNA1BJGfly/fEE5pZKS6B7WTi673LuMdW94IrpN4mr+zjNHUEl
	7hsKstlMBC/dcIaPkZGhlhvCnfThh9c=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PABi8CWR;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770299557; a=rsa-sha256;
	cv=none;
	b=aSVczP6s6BagR2PTDOIi42TrQvdI/pKQCmdvyrPyf0qabkJ8lP6SGDsSuE/qMEt5/Kbah3
	eNSR36mHim9Pj+QUPZgLk3Cgj19H4tFulLfgA0xJnbUYM4cnaodhOZzUAgac/aVOpDj52U
	GqNcl6WOWScIjEOVpC1cXzN+ypRFlw0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B077A600AD;
	Thu,  5 Feb 2026 13:52:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A40C4CEF7;
	Thu,  5 Feb 2026 13:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770299556;
	bh=ZKRLdfY8j+3tSCOhu7lXU/4i+dGzR6BqlTNQ2fMayes=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PABi8CWRapGvnWwD6wZA0gWf2kzC85OADNDNQ+5ZsMgQULKe7P+pTF23HBeTY30cO
	 KncdahQa08a9SOtjZiIXcDaq0NA2sMxkMtq3Vx8YJS6VwVo5vg1hX5RPIsKZbe7TER
	 gHSDA6A11s1XLgW1RnDZgeE6tIS0vcfjGeqvQY7P1Apfb+CW9XPlcRH/QVyqUWwWrS
	 p/zLhgjBcOqqzYiOQ7v+xph6zhf1Kd9yvckyXNT4+DjrG0tCeCWk/n1KFI0jzBgM8r
	 YpeBP8DHGBG3KF0r/0gQlrl5i9l0jcR/amYMxz8bYX5bGsWBk7+qINuqHd4b9uJv6K
	 O8YXH7FHEUCEQ==
Message-ID: <460457b0-64c5-48a2-a5e4-d88ecc222884@kernel.org>
Date: Thu, 5 Feb 2026 14:52:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 06/17] LoongArch/mm: Align vmemmap to maximal folio size
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
 <20260202155634.650837-7-kas@kernel.org>
 <2ce0e684-de54-43ec-be7d-c58bbffb3f4e@kernel.org>
 <062900fa-6419-4748-81d1-9128ce6c46d0@kernel.org>
 <aYSdW2YaJdpgXYos@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aYSdW2YaJdpgXYos@thinkstation>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: b1yqh4durzoihjz78kkbb6mfpqi5fn9d
X-Rspam-User: 
X-Rspamd-Queue-Id: 449D040003
X-HE-Tag: 1770299557-767903
X-HE-Meta: U2FsdGVkX18OWRNnGxgEd+cN4BlYqie61Naz89WfcFdo6l3N/48JxMW1TLll+rqxaGDDTtt0C8ueTZUgdhU950LGNB7rLU26k9WpWJpJuJ/y2JyZa0XvFLCf6tbqb+3aNnETpR04LW4CxOlzeCMZrAEVFVZd3kB6vmFtwLp5CX9ASznmnpNn8q9Kfo1QM8J1ic2RMq4kEwQrz4hpfsbKzFOgGLCEfU0k4yDEgJZXDMkorTVMzgSppRDzydEAnCIX08p3Q12TI3cZucrLgYy5Y1yx2ti2WWZMMJxiH8nSb2CeEnKdD47FRePIQRZxQZrrK7CnqyxLy6f4gtExvm++Tt7Z2tXL5ihD2Nu1kqXM+tgCWeKZEH5XoMQCWcNCHxXf8L2UaJ6a5VfdETNaPrm5wk1HW3Iu4Uz9NebAR/VdcmOMZuLpgnFFWxTwB0F4EoWVNFprm4BE/MrhT880MVob2V7pPAz7431NUjq6Sd9IwtciVkjwLNV48SolSfRQ4pEiqL9O4UXtrjEN/2NrLCA/AXkflIr2QSrkoiNvnoyOTAc3Li7xyOGcbp1+44DUUy7jQTFBpqTwR6Tepxj+0uABe+LItW24E7JrLNjy5JBhaus12WmlmJPCXzVeci2kyYtBJX/zSZh3ec0kqyU4Dop7MHDSHAV4MXFaBtnm+nX9nBFHy16PBhP30TDWExXPvpVn03BVzGVvdxOu7pk6brOD6V8pivaHJyQKJ2Fa5setZejRcUC5BP3SgHjojtIOL1dttrXWxbapnlwn6FIO7U2OiNhOM+yPmR1dbJHVAVMx1l4PfHhktnZwNGniUy55qmZ6f7MHTSFjVUmVa4yst4TMjuvsSFBBmIN8XmogSxJl0yJmBEGiOcp3QDToUOgt9VT7ynTTK1EKuIsFeySd2I7Ct1pO6GfleihLD46auqzHvgkYnouvYkUKNBuZoYCj/QLm/i+swgRbKJkamOiLrOY
 tNA8bFgE
 eHF3Kc7Zz/N5CEfpch4qGaspl1d3CmoIa5kM/VlntV6ZjlRIALYpCO6qGZvlCISdDh/K+y1lZky4qLkroOoFkhOJvdzSztOPkLWqD7henjMxis+ArNAOPQ6swuvgkicel/M2P045Fn38OSYGQXtFsPY1vBwdYWFxVxR7xRVvjRWgts77yZcYqle+yQa0cdjCwrRMXjhTjizDgZtf9Hw/e4LBDqdbl8dKZCUpD0E6z6oHbcFo2TvCbxlfBaMHqe/N4tnuOmDL3WWn4e25+sewpaJms3yGgIG6eqU+v
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/5/26 14:43, Kiryl Shutsemau wrote:
> On Thu, Feb 05, 2026 at 01:56:36PM +0100, David Hildenbrand (Arm) wrote:
>> On 2/4/26 17:56, David Hildenbrand (arm) wrote:
>>>
>>>
>>> Same comment, the "MAX_FOLIO_NR_PAGES * sizeof(struct page)" is just
>>> black magic here
>>> and the description of the situation is wrong.
>>>
>>> Maybe you want to pull the magic "MAX_FOLIO_NR_PAGES * sizeof(struct
>>> page)" into the core and call it
>>>
>>> #define MAX_FOLIO_VMEMMAP_ALIGN    (MAX_FOLIO_NR_PAGES * sizeof(struct
>>> page))
>>>
>>> But then special case it base on (a) HVO being configured in an (b) HVO
>>> being possible
>>>
>>> #ifdef HUGETLB_PAGE_OPTIMIZE_VMEMMAP && is_power_of_2(sizeof(struct page)
>>> /* A very helpful comment explaining the situation. */
>>> #define MAX_FOLIO_VMEMMAP_ALIGN    (MAX_FOLIO_NR_PAGES * sizeof(struct
>>> page))
>>> #else
>>> #define MAX_FOLIO_VMEMMAP_ALIGN    0
>>> #endif
>>>
>>> Something like that.
>>>
>>
>> Thinking about this ...
>>
>> the vmemmap start is always struct-page-aligned. Otherwise we'd be in
>> trouble already.
>>
>> Isn't it then sufficient to just align the start to MAX_FOLIO_NR_PAGES?
>>
>> Let's assume sizeof(struct page) == 64 and MAX_FOLIO_NR_PAGES = 512 for
>> simplicity.
>>
>> vmemmap start would be multiples of 512 (0x0010000000).
>>
>> 512, 1024, 1536, 2048 ...
>>
>> Assume we have an 256-pages folio at 1536+256 = 0x111000000
> 
> s/0x/0b/, but okay.

:)

> 
>> Assume we have the last page of that folio (0x011111111111), we would just
>> get to the start of that folio by AND-ing with ~(256-1).
>>
>> Which case am I ignoring?
> 
> IIUC, you are ignoring the actual size of struct page. It is not 1 byte :P

I thought it wouldn't matter but, yeah, that's it.

"Align the vmemmap to the maximum folio metadata size" it is.

Then you can explain the situation also alongside 
MAX_FOLIO_VMEMMAP_ALIGN, and that we expect this to be a power of 2.

-- 
Cheers,

David

