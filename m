Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48BC6CF3957
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 16:31:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAFA56B00B8; Wed, 19 Nov 2025 11:31:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5FCA6B00B9; Wed, 19 Nov 2025 11:31:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94F106B00BB; Wed, 19 Nov 2025 11:31:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8084A6B00B8
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 11:31:43 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1C72D8988B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:31:43 +0000 (UTC)
X-FDA: 84127897686.30.7948B64
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 52B4214000E
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:31:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TmaDy11S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763569901; a=rsa-sha256;
	cv=none;
	b=L0GMP4kZ9U29CwG010NhNLeQXXb2VYXVUsLSwyTU8Aw0BOvFR6F4kLng3341n8poJ0UpZo
	IDHErW8bI9gTysfzIl4a1nnc7cwzih5iVCWNlX/wVcvRySEzHaH1JfmYCPB7SzJsg2C5gv
	v5XzpSwDacsjX7FYI3nmENpSE1GYcgU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TmaDy11S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763569901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I6tJ7N+O4Reyq/I/W7RccspruMluwoElC460abNGDbc=;
	b=kvLE8UiQuSWLKJoG4QegnQbD8Xo0rKViMLQs1UJMOWBLHoVF2dYZy2rAMkN57ULR8AC2q0
	xtUomDu1ygadBIycWHR4XB240tTrBA3nRbZ6LvgleYtF8wRitCG4jEWS7Hm6S//czK6wJC
	APRFJZH4rwomzWqRHaqFiO4TmqAWvzc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3591843E74;
	Wed, 19 Nov 2025 16:31:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3EEC4CEF5;
	Wed, 19 Nov 2025 16:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763569900;
	bh=1l5JKzzB/X/aOY4SRfPTDUqyy1NGJefVlVFQlGnGZ6Y=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=TmaDy11SGNssyolc2WtbIKKTe8xhNDd843YXydYaEuj9vMLmiZt6HRZ6k7ozQkAN0
	 THsHhXPKb8i7tuV7KStL6maJD0F78ec3xLR/MjRdHCDmerCpvjmmNdLXnB26znxqKT
	 i/419SDSuqqkWRlZjx4MgJNqBG74vpICCIecuAOZ+x9eZ+fCccmbf4Mvj4Qyt7cmiM
	 si/X0tYEDwx7i4ZbCJqbkledCQlFl1yJ/aWhTOEANUKnJzei581xkiWCYKLagHsJAD
	 p5B1s7Dnda+d57w57xauHyHAoJHyNGI4RlyAyr0kC9frMbAIo1MxGh2SvSj3a9azcG
	 Wc9Pa1Tg8spUg==
Message-ID: <c798628d-9bce-4057-a515-8bc02457f370@kernel.org>
Date: Wed, 19 Nov 2025 17:31:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug: Performance regression in 1013af4f585f: mm/hugetlb: fix
 huge_pmd_unshare() vs GUP-fast race
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>, "Uschakow, Stanislav" <suschako@amazon.de>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, "trix@redhat.com"
 <trix@redhat.com>, "ndesaulniers@google.com" <ndesaulniers@google.com>,
 "nathan@kernel.org" <nathan@kernel.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "muchun.song@linux.dev" <muchun.song@linux.dev>,
 "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>,
 "liam.howlett@oracle.com" <liam.howlett@oracle.com>,
 "osalvador@suse.de" <osalvador@suse.de>, "vbabka@suse.cz" <vbabka@suse.cz>,
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
Content-Language: en-US
In-Reply-To: <968d5458-7d2b-4a8d-a2a6-0931cd87898f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 52B4214000E
X-Stat-Signature: thbwbwtrdmrep6xw7ewqi7hb3y9beacb
X-HE-Tag: 1763569901-849960
X-HE-Meta: U2FsdGVkX1/aiHxg4E5vbwYz7q7tIpmTbu8rZ2IKDET/tOpCE60ZYglHQ8yi5jqDpzm5WKHLmexe0B2NHLM0SRLDiJ5tDhzLg9vNWTGXg+Gsdk4a9Pg3I4R/jemaEgYEbfWeyxoUDVbV0lPusDigIwo5mZ9xJGFGc1PKDH1Fwj0iGJg/OQMYcitxUkyjiDEVfL/kiCnDe6dt/oFOwT9T7RoB6PhtFRUk7Eqyjopm0DbsDacOQakDmkVbxe3Vjr2Lsqm01i6caCkGQ/wrNBGJMcQl6rj3MzO2TWydJ1QQ5IBL2rOhpE0VEfxCLsweGY7Op7nJKHsOc5OMtgiL+MtRadGb6LvGOaTNt0EpOoyj6WFgveDStWIkCs/o1zONhxwb4Kc3oUJ4mma1+TfHyAK+Sk2A1TYd0XCIfxi7O7p4FWcIpnhtUu2Hv705JJ1TjVKDYdHdRwDKdEsn4lnNXm9ipyGjH5rKlc/5xac614f53YLy1z1V/LGFaDCkbA8DnELsjX2R0OVFsXIfNpUcsaCahTQ8/piTsg0LZ81F9d3ctU+fGk/BGvwEsx7MmaH5oe2HRcMNPG2oWbzpKEowo++bXsh8fOPx4CNbkVWyOv97IbhQruv65Om4P1kWnQE8olKSsPMj1ch5PXeXv6PcU52Nspl3xhEn1YQEDgsI4bcwsbnFVA4gD17zLcUj9cSS90UHZnfX8JZrOLXSXwMPsSifcScyM1CfrwRW9vPxSc08rvoW7GFiTGNCrZyAL02Jowwel1NAEjN0KZL7nb00F8jUXl8X/aM/OYAz1xydXbICN1ojN4Uo1udTcwYKHO/bnnVmBAfVeFNDjgdjYOTXFG8IMEJ7sGy9mgUBSz1ib0mEtnPHU8Hb06XczyPVtpRngsIJVB27AoC2Wk6q7eoB9bazEfzszQXkh1OOdJrMbgBhvjBtTwUbjlM49rSbkv5BtYhoMiAuUgOKWnP9+n/sBmA
 /BOESxmp
 0wXmZU46AGLFHg/fzNBujfSklvGaF0lCzzyog1e/eS3dZrkXdTaQ+rGlDI7tezDuZ5z9/NKLb2L5LsuS5IPU+cduXjs4RyqQFfS5Gzvdn1dF4j9I3Bm9BMLm4b4FB3eCAQpiZuTLNP2GRFangud1f0oG8HccValZKoLR16+dfry+Y1Y1MtP9j/aQufEzITKmdYwt6y2ol2KUSjrym5DItcJ8g8ybPevdTNGrqf1eE8is9aT7/pUHMAjGMpxN9JRWquSDIxrAapjkZ81eF1xTF2xJ7tQCYPNbQRo+lNuQF60gq4LAvBnPTgtvyXdrJDnnIw839Y6F9rwTlumCsf5+z5O2mkwEd8eO9u0E1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.11.25 17:29, David Hildenbrand (Red Hat) wrote:
>>>
>>> So what I am currently looking into is simply reducing (batching) the number
>>> of IPIs.
>>
>> As in the IPIs we are now generating in tlb_remove_table_sync_one()?
>>
>> Or something else?
> 
> Yes, for now. I'm essentially reducing the number of
> tlb_remove_table_sync_one() calls.
> 
>>
>> As this bug is only an issue when we don't use IPIs for pgtable freeing right
>> (e.g. CONFIG_MMU_GATHER_RCU_TABLE_FREE is set), as otherwise
>> tlb_remove_table_sync_one() is a no-op?
> 
> Right. But it's still confusing: I think for page table unsharing we
> always need an IPI one way or the other to make sure GUP-fast was called.
> 
> At least for preventing that anybody would be able to reuse the page
> table in the meantime.
> 
> That is either:
> 
> (a) The TLB shootdown implied an IPI
> 
> (b) We manually send one
> 
> But that's where it gets confusing: nowadays x86 also selects
> MMU_GATHER_RCU_TABLE_FREE, meaning we would get a double IPI?
> 
> This is so complicated, so I might be missing something.
> 
> But it's the same behavior we have in collapse_huge_page() where we first

... flush and then call tlb_remove_table_sync_one().

-- 
Cheers

David

