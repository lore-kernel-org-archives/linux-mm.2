Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55DB3606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 13:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=P2hAE4pj
Received: by kanga.kvack.org (Postfix)
	id 5328C6B05B3; Thu, 12 Nov 2026 08:03:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50A9A6B05C2; Thu, 12 Nov 2026 08:03:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F9A56B05C3; Thu, 12 Nov 2026 08:03:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0EE886B05B3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:03:39 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 959351A05F6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:03:38 +0000 (UTC)
X-FDA: 85426483716.10.A3F93D9
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9A59210000B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:03:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=P2hAE4pj;
	spf=pass (imf14.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794488616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xxLvafh8oElSW/f5s1DQzYPUCi1n+N6BxV/jYvId0hQ=;
	b=xTZFQoRY1U1AuohPacxm9RuXKBps7TISQlmJd6FYQ98grIFtsCbdTijnyG5Z3Y3HQz4NFC
	MDn/OPKgOaLci6arBJL3kQJNB8HAf9T3P++1BRk9kS3+TCNPC8uVLI8ysDRSKfQKnIaVbD
	sDfFFIf2Jmn1fCGmSE/MYJZJXcZUwd4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794488616;
	b=6BlJ8JnZrf2TeSLq8ZwhMcHz1M6Bgpi/MS06px6yPMCGW/eF290/zdPdXiNK6G+zdUfxCL
	/ZVWSFlFoaazGM5VddpI4YhBT9MOnW54pVR5EL2AD0XVN0gpbTTcguUP3ulWH/nHMVdhS3
	C0bzR8850c9rHrGiutMjldjec9uhy6w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=P2hAE4pj;
	spf=pass (imf14.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4afe2d546f9so51929245e9.3
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794488615; x=1795093415; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xxLvafh8oElSW/f5s1DQzYPUCi1n+N6BxV/jYvId0hQ=;
        b=P2hAE4pjiQgzqrqjMbbAXYiG6KK4TAiLoKuNnLU65SgD75sKqRofiF0NEbUfSu/KLW
         iyL8sJF6x+LlTsjwDMzfyvyno1rfC3mobuIG4+htmAbugIwGvoPzBL4TcEbbwUL1l2Wg
         3StkSWfPzdZOOJ54J8c+7ONgKXfyUIKzGeNqlVMtalo3co3jUJvSRJUD2GLlIaV18p8Q
         +5QWgkVcB7S5Pgw+eJtwDQEFqj1eqt8ngq5SCAeCYkrArZXGhK8lV2kjLFyld7BkYN7Y
         SKBs5LJR3PKfZaQUi2TS1f5P6Sx3a4PgxeVJvDZ92uGz3v6Lu/sz4NPMOeQbNcMj3QZY
         FEGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794488615; x=1795093415;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xxLvafh8oElSW/f5s1DQzYPUCi1n+N6BxV/jYvId0hQ=;
        b=Pxptf/+AsjmCBqXVUJYCt6D+TO/TXdzTUoJcGu2mb6xsPsk49andDnu0jQnrOKTioi
         N2vtfb0hlAHvRk9Al9Q+bm21U/ui+vGVDVfDqRWnhY2F9CdsMblszcm0PGo64QHZtoVk
         A2mLLJc9m5/kYsrzupDjC648VhTRZE6XJgPiiYlXF1MKwbSoR3dGYHYXX9Aea4ChCFaA
         NZuwupW1fmCDhjQ7I+VRrxX3TN+cFBz87ESf85dxqYe8p8WLo7NUSW04JVk47Stxq7nY
         iLhbA/3ezRr/LV4hlDTFzm8/YDyxiz0bkQ7Tzv+WootsCt1uMsV6EH/xsX0Z04yMGW6i
         3MXQ==
X-Forwarded-Encrypted: i=1; AL+hErFohUqLNSNv6EKc4NKrqcf5qHl6764Gtp56m4LPmYkO7y/vuqF2QKBvnhbZvomv3eKqJ6BpeGPt2Q==@kvack.org
X-Gm-Message-State: APuU4Z8DBMdGbPNY7iOmZHqaK+xtpPkYCbL6tPo+0AcEdfoLuBZAn8dD
	y92Dg1VyFrv4BKoL0OUrGc1plLInHteeEG7wN3Meetau3iTYd2xE/Ifp
X-Gm-Gg: AYBFou0L7WW0gNTCH29AqL8b9Jkr8IvP91JeOG/uxk+pnwGZkr1U3DrfjjjP0RCA7Qt
	pB6DBWaavFhAY6RuYnK6Kos/afbYN/fbPI1Nb94Y1/2K7SEV5F9/CrEShQJPu3CTUWdEDFajH2a
	96ncF29zo7K/TmMJJUqA1UoMpEINpkQlUEoSG/sMyHM48JVuUGPSyJQod2RI8E9//RveRZV8+oT
	AMxFURbzzIAQuRL9IlyuJHOh4rkdLAAaAqR54WCLb5o4J2p3JhKT/IFQ8uWcgluDxZ/ALKh+qJu
	nDJFpzM7798uiuSWZS1h3MwHbPscsmeC4u8TWYDTzMh0zf5wzjvq30hm9yRZbce5uYKLCVF1nMT
	w0q4jNzWCXZ9XosMHt/+i2LAfI2byJQvL9KBUlBaPGCVyf/j5F3etiSl7F/o8Fdomu+jlYo5zx+
	gpJBTVRSEViwqcLui2z9oR7bQuu3QDtNiCHp3SPrUGE7wDQcmQCxhailz0BI6KGjDEscRYvNveM
	MTOc4H1gc8SVViQkSyhKPoBEn1gHcdLQB1b8R0Ki6w32yleqpzyHbXw8kOkS8VyvizDWL4w9XKC
	0xMyzMlddnwtcH1iqT8jYCHW
X-Received: by 2002:a05:600c:871b:b0:4a1:fe26:24f0 with SMTP id 5b1f17b1804b1-4ba0938a4cdmr100328715e9.20.1794488614828;
        Thu, 12 Nov 2026 05:03:34 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e26700fsm78144135e9.10.2026.11.12.05.03.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 05:03:33 -0800 (PST)
Message-ID: <e9033159-ffd5-4c84-b355-964687b75226@gmail.com>
Date: Thu, 12 Nov 2026 14:03:31 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] mm/huge_memory: find partially mapped shared
 folios with NO_PAGE_MAPCOUNT
To: "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>
References: <20261111113535.330078-1-azpijr@gmail.com>
 <4411389c-2246-4af6-9b34-10d3f259aeb4@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <4411389c-2246-4af6-9b34-10d3f259aeb4@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: yikdfa1fq7iwwqj7bigsr3fmry14reux
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 9A59210000B
X-Rspam-User: 
X-HE-Tag: 1794488616-404094
X-HE-Meta: U2FsdGVkX18X+rpEZYqyMmEkIBgU10eb46eZOjR6EstXwkBBYNfuvxKGtPof+tp/2VjkWVZngSQbgEfr7s13V9Q0mXow8nI/q8KaCFvlBLamButGvaTEmJrWaHR4tOglcHD5U8PDO0b/eszqfs/OIiyf63TF6bcmdfNfxGyOGpD0Otbh6BwybScqlOR6nqszsDTBrC4HGx0t6X94Mzcqds0jR1GXiO4NPMJCPeYOMZJuSmzdZqC9icL0jHshzNyLf7TxwsfI6YTXo0SeJBe6U83XSM27387YAXUIYpBKcVEoRhClD3Yt4HrCvyiybOLwdnukCKbVjCZ9vmcRodCfvm9S68JixyuBOkgAhpChfJiKcVOngqk/ON6MR99ldQyNa7lfcQhMGuMA9Z1p7igcL6Ay2+wcJSIOFzEZftmbsifR7OpbErBFIGhhx6zO56I8Z+OQwOtwVX0APqnIHQSORF3ZvhK530YgHTf5FvQllMWHNv+kOAbgd78fWd5gxeqbmuEu7g+59A4+hf3ZiTkORCxqWQjULxMbmXtBkXwMenATfvEVb/zi3DThXgU2/BQrEfBVgpHwvJCTelLa1roIlMuBW2/vdpRiZez1jglYsHx5GYCRDuJWAreTdJX8ndgLxVTBNWcGS1b1hMJ9sobpkAWTe5oFzlu+TKfqUox+nUpYSL7iQ68nSvYGnhrtxQElCbnutAN2Cyb2/QKzNMz+iLO8kx8kv6/u4jfaGUSwbgKzUXhqP7jG4Qb2n5PWzPRo7p09VrHmy7lYjVMh6LA8jqaXQY4Mcxc/5wUaUguNLmKud+EpHRuv2JNPFUaYNLlHJ9L2QDJMAhybwE43IiQ2OcfZ/UQvzNWrf79fD/g/fo+vqHn1HC37E4OqTnrZxhW8P6vFPnU9t3l3xmx7VuOCZcH8TuetZEQ9uVRoBLHDx6J/5kdGASKvD5oA7ncjgTiKMJE3zpdZLvLlNcDRiUT
 qFR20f4m
 zMhS3quSCKcW8ZJRCS5JYBwhQo9MrIEiyTbqyo4tmZ0d8I4Oo2WSXpu2pJqe9hsY8SCtJVV3bH9Dlf7zFeLbu2Bdtwtsr3TqIO5sHMsaqHXI3UFlJF1Ydy9HYoM4LpoVpKDWh0RwsJ3Pd81ZDs6wGKjfrYXUiYiD5FRyxZOpVhlbB5Ef26g4saLcRB3iZwQ0gO/5I5x0JGTbHcSgYfV4mGvf0V46C3dudCo0NIzbYz7Gcy8BxgSK9T+ZluCS1jUPmNOm2KesC9aQpIZJR+UcwirNG0Kx+aDO7i9/TdBG2oG+LuyF4bLGgXqprc5Ll+luGjf7Kw8aiv6p3sKXtRBovLxGYWbLnI8bTjXpK6d90lMnH4OlmXRPzQfuAuzbUqxbr884roZNxxT2IXXcvbeCuJ/DdM4ZYVo3TePh7oKDVAwmSoKFO/NfpUBCWIo3w+fFWhynwHUyBNl+FAMkflJ11ymOiXtJrNX9mV3PdVN4dyRfr+Hw1PzQZs72fBPcR2xrCVVSPoUBGbmU+Oy0Rm/r3+DOQsnHQI3ieWQtjUwCOKintG18=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 1:46 PM, David Hildenbrand (Arm) wrote:
> On 11/11/26 12:31, Jose A. Perez de Azpillaga wrote:
>> With CONFIG_NO_PAGE_MAPCOUNT, an anon large folio mapped by several MMs
>> isn't seen as partially mapped while its mapcount stays at or above the
>> number of pages. If parent and child zap the same half of a THP after
>> fork(), that half is mapped by nobody, the folio is never queued for
>> deferred split, and the memory stays allocated until every mapper is
>> gone.
> 
> If you follow the history on this, in e.g., some raised in my talk
> 
> https://share.daveh.de/s/bQsDpD7xigJ6wD8/download?path=&files=LSF_MM%2726_+Deferred_folio_splitting.pdf
> 
> There are a lot of questions around this.
> 
> In particular
> 
> (a) Is it really relevant in practice. The only way you can trigger this if a
> folio becomes partially mapped *after* fork (by parent and child unmapping the
> same pages), and the child stays alive. Once the child is gone, the folio is
> only mapped by one process (e.g., child quit), the folio is properly detected as
> partially mapped.

I don't have any relevant evidence in practice. found it by just reading
and testing in qemu. that is why I sent it as RFC.

> 
> So you need a long-running parent+child, and have them both do questionable things.
> 
> (b) What is the overhead from having way too many folios in the deferred split list.
> 

I don't know yet. I only measured the walk in a TCG guest, nothing on
how long the list gets

>>
>> Patch 1 moves the split_underused_thp check out of
>> deferred_split_folio(). Patch 2 queues such folios as candidates and has
>> the shrinker walk the rmap to see which pages are still mapped.
>>
>> 512 MB of THPs with the same half zapped by every mapper, memory freed
>> by the shrinker:
>>
>>                                 before    after
>>   2M,  2 processes                0 MB   252 MB
>>   2M,  3 processes                0 MB   237 MB
>>   2M,  2 children + parent PMD    0 MB   244 MB
>>   64K, 2 processes                0 MB   252 MB
>>   64K, 3 processes                0 MB   252 MB
>>
> 
> Again, we can create nice scenarios that are likely not relevant in practice
> (such as 512 MB THPs, lol), but so far I doubted that this is relevant in practice.

that's 512 MB in total, not the folio size. maybe I should have
clarified it.

> 
> Do we have any evidence that real applications run into that and it's a problem
> for them?
> 
> The memory is charged to these processes and swapout etc. would still work.
> 
>> With patch 2 the shrinker reads shrink_underused itself, so folios
>> queued for the underused check aren't split anymore once it's turned
>> off.
>>
>> David suggested a check from the shrinker for the opposite case in [1],
>> folios marked partially mapped by a PTE by PTE unmap. The walk in patch 2
>> could clear the flag there too, this series doesn't do it.
>>
>> Questions:
>>
>> - Is an rmap walk from the shrinker fine for this? Every CoW of a page
>>   in a shared PTE-mapped folio queues a candidate, and so does the last
>>   PMD mapper when it splits its PMD.
> 
> You are asking the same question I asked in my LSF/MM session :)
> 
> I don't have a good answer to that, especially, once large folios (smaller than
> most THPs) come into play. Like 64k folios on a 4k kernel.
> 
>>
>> - The walk needs one bit per page, which is too much for the stack with
>>   64K pages, so I used a static bitmap under a mutex. That serializes
>>   the walks of all nodes and memcgs, and the mutex is taken with the
>>   folio locked. Where should the bitmap live?
> 
> Maybe one could track it a bit broader? "any page in this set of 16 pages is
> present". Reclaiming a single 4k page from a 2M folios is barely worth it.
> 

yes, that works. maybe with the group size scaled to the folio, so the
map is one long on the stack and 64K folio still gets one bit per page?

however, maybe if I don't have real evidence, better drop it?

-- 
cheers,
jose a. p-a

