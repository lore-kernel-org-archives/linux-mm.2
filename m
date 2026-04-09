Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 739A4E9DE64
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 08:06:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B82D76B0088; Thu,  9 Apr 2026 04:06:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5A786B008A; Thu,  9 Apr 2026 04:06:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A70476B008C; Thu,  9 Apr 2026 04:06:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 950C66B0088
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 04:06:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 379D48B8D2
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:06:19 +0000 (UTC)
X-FDA: 84638284878.27.CB9EFC0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3823540008
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:06:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jlQnrfmQ;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775721977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uHXzgnqh2gyQCLxHaMTnE589rp095fyAgAkpw7YV2YA=;
	b=S4I9wG1TVCYL+CAdJzGuq46/1w7aWNaR5mIcBqzjiDqhADeqpqbPast4h0x8RfvA8aYO7U
	2uZqAGaCNUUnUnFGGIqTmgOEhnsODmQMHEiUG/llz6MovBh5jKZNv+6swUO2nL5YE6q/28
	/DoY8ZSGdmG3QcvWdVCC0rEz2cuO3EE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jlQnrfmQ;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775721977; a=rsa-sha256;
	cv=none;
	b=GsZLVabQNR1nRPzFd3Rv6WgegU/C6WDTRKpWbK2CRWNrfD9YwcBIBhrocnhzgy7As5+lef
	jIx+wNE4RVTwUWu8bQ7hmAnwscZvdKLbYLKlh5iwLsNFS6fQNEwsyS5lEGfzy9qgaC0icI
	IM+Qe5DVm2S21CJXLTsYINZKQMBuUxw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1FA1642DB8;
	Thu,  9 Apr 2026 08:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70FE0C2BC9E;
	Thu,  9 Apr 2026 08:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775721976;
	bh=jLEAlF9asRf0p90ML/pkrjnRkbSaxZJFSJFg2f/G9q8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jlQnrfmQSWMeleNiNZwA5XqFYrHIjLtel2OJZC7GuBVujsgsK5445C0i9yXbUlWuB
	 evKoEaiAT90C26iweGjXf1+DhgInS4uz0Jrjb6A2/jNAHEbtEbwkChYc5dFwY1+2Zb
	 TikD0yi+X7LqgTlYuurQG2yEFu6kp2TFEwAM/4vlA2vTWF7L3ABy1cFZpKu025duyJ
	 YfZjKK6CTHOOVNizWaIQh3fSYYRvKlboAyeOTOJi0srxCR15HMKielPcXXuog5EPrb
	 fqCfVGnyvRBGKihff0WNznU7Ls7fdOkiCN6hy1WIYiakPAQoo646GR04b4D548yb+u
	 cwzKEkZSrH9lw==
Message-ID: <aa8e148f-252f-4d81-89db-b1702d9b6888@kernel.org>
Date: Thu, 9 Apr 2026 10:06:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Discussion: Targeted memory allocation via
 debugfs
To: Juan Yescas <jyescas@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
 Kalesh Singh <kaleshsingh@google.com>, "T.J. Mercier"
 <tjmercier@google.com>, Isaac Manjarres <isaacmanjarres@google.com>,
 android-mm <android-mm@google.com>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 lsf-pc@lists.linux-foundation.org
References: <CAJDx_rj-fTpKjtsw1jJ0aAaC3a2Rt+zrizqY23ZHvq0Mm56uTA@mail.gmail.com>
 <00ec73d6-11d9-43ab-b1e2-d543425d19c7@kernel.org>
 <CAJDx_rj4DVG2D8ab9O8RWDEF81a5J-fiwtDedubEnsmL-1q+sQ@mail.gmail.com>
 <5c6e3c1a-bae3-4997-b02e-135374d1d6f8@kernel.org>
 <CAJDx_rgYXWNC=0_QZDmMpuZU8aZqRU8OeMBqXT1jjzrpK=BWeQ@mail.gmail.com>
 <e63e0ab9-75bd-4a7f-9400-a8f87c80d1f0@kernel.org>
 <CAJDx_rjk-5pp5Z884bnTBss19Xk0msEayR=GAMG2wWCk+WOZ=A@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJDx_rjk-5pp5Z884bnTBss19Xk0msEayR=GAMG2wWCk+WOZ=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3823540008
X-Stat-Signature: 9fnoercrx9cp1g3hn4sap3a3cxkibq1h
X-Rspam-User: 
X-HE-Tag: 1775721977-60793
X-HE-Meta: U2FsdGVkX19IpAdwSxqP0IxN2q9A6JCRvpzU/aP7HO9mRTjq3IlnMWdPut2tdIwd7jxhLVbnhuDCqtnK3i40Fh4D5sFbXP+ASbBAlEABjLPlvtMJjeptR0xVFCW3tmwRETXt+76g1+URLyXW3NtL3DQHoLekEpKx7byh/eVeoCNviOUCujXfp0G2kdTopt2SaLduNcAGbH0anHoxKsEBZHTFL4MQYAMMKFhW9v99nfEcVfwJeTrYOb/TIjuUwr60JRNSQOJsErAbkt5Dw2U+89k5FN+nhsgEV9eH9xi2cIghuuAyKwWN2F76ORgiLG4zf2prdGYAQDUd/RVTjpPicKAG9JAA1fXn8/oHhI+NJsGvK5jpN3SKErRj05O7ukP/v6EsbFpkOfB1Q7II821ORHXpbP1pM/jFgQTu+TEVMV/CnuS53Y3aPWEiLnurMSAThOSY/foSn35su9HxnrNeqk27lOOewRCdb0mo9MH3K6lS0XHJ2gWx5s8Zw3paGHum9mE/L5hAg5Mtadc1ATmr9UjbFxu/YONRVr3S3/b3L8v6JgoE+MzVQnyRtn/iSszNUbzxbspnUIhFjQnUeoPT6IcwTUnaAcJ28EKm/t4N2L0SfEiWenjrapSduZdRNM4XWb8IBclwjb8VIEuwQ15tJIPmX48Dlx8vICWkLAu+189K8Pxvy0gUckmyR23g2JHorahOFHYVriW08NkFtPXPGiWTkd2rlPXXKc8ZtggdxfbRppX7LPh1LcOduTiNYnUTE7AVdBGa140Tn06J5qF9gZakg/GEBPEOWKvWFxobSq7yj38bqXzEqOmZGlRAbfw9+x9O43ipbFm1lvQ38gkftWJBeLfC7q/lCGv3dgHC0ly2dFIAxs8qiW/VAK6cIQi4tCVHE2MuozwHUBm41/PGDUkZYWMnrJFjaEf3ML0vT104hybp2lK2dVxNafNQLQma2RbyWqXnKfQ+SwUayn8
 rMlnEzLw
 tEaFcrscoj7ISmxDRfwkFDnbPmhGEADxqhGcaz+E6qlE0iierM7VjuT2K78AHyjlmI03uoyJUA9QYTbfF/tCX1t/RT3erdlfewqxIUZh5w6tcD1aUHTwgH+r5d3m0QLlOtODB8Vg0tQIbN7WaIZGzYRaha7bFFdNQqxXVPAjIkiIks3sXtl2ZtxvUlQPf6akAxZVIYMmOQWuL1OliV/AIQ+57psbfjpHSwPqOY9aPppGpwSJC1ezcTo9a+8csV5m/gt6x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> echo 1 >
>> /sys/kernel/debug/mm/node-1/zone-movable/order-10/migrate-Movable/alloc
>>
>> You are just breaking ZONE_MOVABLE guarantees. Or what am I missing?
> 
> I see. How should the ZONE_MOVABLE allocations be handled? Should they
> be excluded?

Well, the same applies to MIGRATE_CMA: if you end up placing unmovable
allocations in these areas, you will break these scenarios.

Your driver would have to support page migration, but that's not
trivial. For example, movable_ops pages currently only support order-0
pages.

> 
>>
>>>
>>>
>>> We could use a "nr_pages" variable, but we would also need to set the
>>> node, zone and migrate type.
>>>
>>> It would be cumbersome and error prone to have something like this:
>>>
>>> echo "Node1/zone-Normal/MIGRATE_RECLAIMABLE/8" > /proc/kernel/debug/mm/nr_pages
>>
>> I meant something like:
>>
>> echo 1 >
>> /sys/kernel/debug/mm/node-1/zone-Normal/order-10/migrate-Umovable/nr_pages
> 
> Got it, we can do something like that. It makes more sense.
> 
>>
>> (not sure if we really want to specify the migratetype)
>>
> 
> The migrate type is important because we want to make both MIGRATE_CMA
> and MIGRATE_RECLAIMABLE allocations.

See above regarding MIGRATE_CMA.

But in general, bypassing the page allocator and just allocating random
pages is not really nice, not even for a debug feature.

In particular for the scenarios you mentioned:

	- CMA allocation failures due to pinned MIGRATE_MOVABLE pages.

I think some decent user-space reproducers might be a lot more elegant.

I guess for CMA, you'd want a way to allocate some ordinary *user space*
(anonymous) memory and be able to check whether the memory was allocated
on CMA memory, to then fire up a page pinning storm and concurrently
trying to allocate the memory.

So maybe you really want a debug mechanism to migrate a (movable) user
space page into a CMA area?

-- 
Cheers,

David

