Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7D89CED265
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 10:03:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 037926B002F; Tue, 18 Nov 2025 05:03:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F03276B0030; Tue, 18 Nov 2025 05:03:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA4C16B0031; Tue, 18 Nov 2025 05:03:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C198B6B002F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:03:17 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 89EE658FB1
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:03:17 +0000 (UTC)
X-FDA: 84123290034.06.A07B891
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id DE22D10000B
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:03:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e4NITz2L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763460195; a=rsa-sha256;
	cv=none;
	b=CBE4F6KEmde3xk4YWob1Han9IpfzHEHrHA5VCJpgOc3B1Zc4vIq8KiOuO+/uHTRgnd3EEK
	ZJg0/tM2r4kEV7SK+WaSuMHE8S4vjt5AlPLXL19/YxVb4CDqsCR5Q5CKi7S3XNBjc5gWGY
	8mSAVlovo503DImlU0YtgLg/3a9w598=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e4NITz2L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763460195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VlM6BoOd5gz3mUiQT8K233bF8Q4ne/KhpQRT0tF08Vo=;
	b=7Ny1CA6Qi7BVqcQSakO7uYtNrgLBV2WKk93xKC+x0GPn720mpe943c1YnxKSg4N0iNK+1O
	fAUTx7MErhGplJXVTNsGvEQ5WpWgjKGdhC0B21Kuzl1mZAKKK1MVKKB5/aj5SYq2+LGcB+
	yjkFynff2l6PpMsY4YYCKgMojKO23zQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F429601AA;
	Tue, 18 Nov 2025 10:03:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CAE7C2BCAF;
	Tue, 18 Nov 2025 10:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763460194;
	bh=yN17U6/arJFZbWy7v+5E/AzgDQnFBqjDoOQeqwGAn4g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=e4NITz2L4WhpFnnyGQGlVfOhx1ER8y3eEy0+tVBmYypjVn7vXOyhNliG5FvDbCyR5
	 lxTp0Q1jxhouDc2CwUFz62DVqghmgE2RSmgJITSckOFak9Pf9Ytrqxb3e/YWu9WpPt
	 ajH4UG6vqcsidnfSaKEoknhVBb+pCYkVdU5YxQIvcIilJzfD3fesuYgRmz2d5VZdcC
	 bdvcNL6UhkLQKc5LOGCt/xaqTBl/aUsOzvhG8yV0vTNXyXqquSIxe6KW8HyjzhrUpC
	 NTZi5t3UFIf6emePcwMuRm0xMgv+S+vdfPYFJDY3Bs3fvvTvA3JG4bnSMHYxohnyWW
	 Ku2CTQFctpeVg==
Message-ID: <944a09b0-77a6-40c9-8bea-d6b86a438d8a@kernel.org>
Date: Tue, 18 Nov 2025 11:03:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug: Performance regression in 1013af4f585f: mm/hugetlb: fix
 huge_pmd_unshare() vs GUP-fast race
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
References: <CAG48ez2yrEtEUnG15nbK+hern0gL9W-9hTy3fVY+rdz8QBkSNA@mail.gmail.com>
 <c7fc5bd8-a738-4ad4-9c79-57e88e080b93@redhat.com>
 <CAG48ez2dqOF9mM2bAQv1uDGBPWndwOswB0VAkKG7LGkrTXzmzQ@mail.gmail.com>
 <81d096fb-f2c2-4b26-ab1b-486001ee2cac@lucifer.local>
 <CAG48ez3paQTctuAO1bXWarzvRK33kyLjHbQ6zsQLTWya8Y1=dQ@mail.gmail.com>
 <a317657d-5c4a-4291-9b53-4435012bd590@lucifer.local>
 <CAG48ez0ubDysSygbKjUvjR2JU6_UmFJzzXtQfk0=zQeGMPwDEA@mail.gmail.com>
 <4ebbd082-86e3-4b86-bb01-6325f300fc9c@lucifer.local>
 <CAG48ez1JEerijaUxDRad6RkVm3TLm8bSuWGxQYs+fc_rsJDpAQ@mail.gmail.com>
 <2bff49c4-6292-446b-9cd4-1563358fe3b4@redhat.com>
 <0dabc80e-9c68-41be-b936-8c6e55582c79@lucifer.local>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <0dabc80e-9c68-41be-b936-8c6e55582c79@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DE22D10000B
X-Stat-Signature: wqp4oytrcirwjwskarwd3oauag3gnas7
X-HE-Tag: 1763460195-645804
X-HE-Meta: U2FsdGVkX1/pMmQKws1NHK9kgbucHy348YOixF5qKZGjBSHW6usNlTFGgreUFBDAzSfQRnY3dkBXisXu64fvIpkM3eFje9ufQ/dJHupUAhBKr27d7hHKUjmRsjnyJlPZ2/1d6Pbh8MITHk+Q7/SH+A4Ou1QBgCcvJap2PQOcTNZB1m0G+LvXWRWaV/GkrpPT2NHDXxCt6HZBf+v9F+VkbQb3DY5NUdaWbJkyZJ5auuFAtnoRkB+K7OBPglnTRp2tCd25dfdLV1gfiUuTrUqPKCkUttaM3r3YkZHZrTGim48q1y8NsJgYNuEFLzbLdluPP0p6vh0dyVJX/oR6KvLqqTYgRRlkUgLAGdaQp1hTgkBoEaNz5u5G5SZ/QeC+AWQ22VXPK7hiCPFX6vd3DqujiCGowOaw37gpBnyzPSz3vVb7AAMKoGJEqO9y/927SyB8TttefEmXoTHa5gGLsvan09BVs1rfNUJ7sBBZOcEoF+VAQIZ3aJoSWW5n7U19rwLKj+qSinCxrzNkQofXOumtLWIAc49BKQT1Re0OTJl4Ow0/IKmIAKZtqvLCpzHfiDR7RQNOjslMNPZQ5fOsDFpRHdC0LZfi4+8D7vA+CX7wtSr3jkzuTULG0bYjMARmSvyOHb488BFklb/leX5+Wr384Fbqp754pEBfXzvkAfZdjSsg4uHp83+boRM3COd0df/l8PdootzFG0dxHU0eG3A+WOjIg0623W+ommZI7XFm0kvSCC7y0yrbTiZOoRYV7e7QiIcOVwtLSx96DmpggXIYEdXVa2hJKyghGkVbdBxYnr+eday7IH/R7+0dXoYLJ+ljHpKy4vxv2Yo1AdnKxSE5P9hXnxnJMjp7MOz0JWihLBbw9ttxVc+8EDXCr4Po+q0Quoj+URlfGEpSnEyEF8znhmMBCPkPOfPkWF/aeFAZAIuMc9VIkeEOYttoEJ/q+PZOmIBuitPIPbOYWoHjZWj
 PpGeVo4O
 0EprVUeJiVQ9EIGnTkwHfOcHgXGQmoEH4wzdW1muAUf9D2Cek4dtHUi5O+lwln3wAqIBl00NtJP54vGyfuvf7EEbD5rouNHhS1EwEgYLZIVwp6dv461cB2w69DWG4XhHZyQdX4wxxbc9koZqUjF8d3eaytz6qSC8wI+xgJy+AAazMCGxLj2LTx6lQHgPuActl1dvihSfEVrjQfIKzt33QLCXWtWM6fmn3dqNVr62/PntoZPh3jruGEnhhGaI6sPAWeCmw8LVcwZSPtAK8c9SorHJsAzS1SaMbhz842rGJob+cqbaxh96cvR75C8lqgJnK+dALpFIFBKk6WbrTC5mVJ6MlJ+2NfehJ5wky
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.10.25 19:02, Lorenzo Stoakes wrote:
> On Wed, Oct 29, 2025 at 05:19:54PM +0100, David Hildenbrand wrote:
>>>>>> Why is a tlb_remove_table_sync_one() needed in huge_pmd_unshare()?
>>>>>
>>>>> Because nothing else on that path is guaranteed to send any IPIs
>>>>> before the page table becomes reusable in another process.
>>>>
>>>> I feel that David's suggestion of just disallowing the use of shared page
>>>> tables like this (I mean really does it actually come up that much?) is the
>>>> right one then.
>>>
>>> Yeah, I also like that suggestion.
>>
>> I started hacking on this (only found a bit of time this week), and in
>> essence, we'll be using the mmu_gather when unsharing to collect the pages
>> and handle the TLB flushing etc.
>>
>> (TLB flushing in that hugetlb area is a mess)
>>
>> It almost looks like a cleanup.
>>
>> Having that said, it will take a bit longer to finish it and, of course, I
>> first have to test it then to see if it even works.
>>
>> But it looks doable. :)
> 
> Ohhhh nice :)
> 
> I look forward to it!

As shared offline already, it looked simple, but there is one nasty 
corner case: if we never reuse a shared page table, who will take care 
of unmapping all pages?

I played with various ideas, but it just ended up looking more 
complicated and possibly even slower.

So what I am currently looking into is simply reducing (batching) the 
number of IPIs.

In essence, we only have to send one IPI when unsharing multiple page 
tables, and we only have to send one when we are the last one sharing 
the page table (before it can get reused).

While at it, I'm looking into making also the TLB flushing easier to 
understand here.

I'm hacking on a prototype and should likely have something to test this 
week.

[I guess what I am doing now is aligned with Jann's initial ideas to 
optimize this ]

-- 
Cheers

David

