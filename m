Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D41F4E6F07A
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 09:38:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30EEF6B0005; Tue, 23 Dec 2025 04:38:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2924A6B0089; Tue, 23 Dec 2025 04:38:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1943F6B008A; Tue, 23 Dec 2025 04:38:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0BA356B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 04:38:38 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 951B3B9E71
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 09:38:37 +0000 (UTC)
X-FDA: 84250235874.13.3CABF60
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id ECE1C4000A
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 09:38:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cxwSgqka;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766482715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vio7RoB6OygSz0UI6v9JbQht1GL0YyztG3yaWz/hpUQ=;
	b=l0uEyB+ApfoDrxDqUSOqKcAeT2rEXZCQxDJv0O7xGi+bxkYzcviZKLPugMqnfwmbbWe2Z9
	DJN2VYOgIlmuQPRWwalmPP4jUSJxZh/Hn5gKHpUwiSyYze3WYWLVi9jR83HSgPjSY2s7Ym
	llhIshZXMueQyAy7KmkReJY7jhBRcjQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cxwSgqka;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766482715; a=rsa-sha256;
	cv=none;
	b=mIndhtq148S+0FISuuRAT/SxUDbaem1VLRzoRwYqTg45MjkuhBkpAmqq4+tECGjf+/eDTS
	JzVNjR7QE+AJ93cbbMJ+iQw2Blyf8jdCpH5RAdF9W1Mk+1Gnk4vO+IgJVmslpGBOkQNk68
	dnyhCvu/BBcZ2C44+C/2KA6i21bJnAE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 380916014E;
	Tue, 23 Dec 2025 09:38:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A041C113D0;
	Tue, 23 Dec 2025 09:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766482714;
	bh=0tCAuhor98NX6pArSQFPs+Lf5cNk0Pw64krLvrl0x2A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cxwSgqkadyvZ8pQ4lEyrcLOru5YsUsEv2NvVC5ROuRdVE1PKGXlPNJx+/lAnh5k7r
	 4wIHDfUSqqcksPZptgbYmm0zDUjzZoXQEJVuvpvbMQgstpy0beGMa85LorT1ysXM/9
	 FuddKfdevXD43gk64985bL/4YcO7YToGi0/cGvgyAot3fpvioQ5OPHQGKDYxGVIdFP
	 G6Xcauo/JVei9z0K4O9Ti2oyUj8MM5kPapvbCo8zhWbYCRDcFysiVA60w4N7oDG+Hf
	 dJ2Cg+suxyOWg20fIaKf9s7VuqHEK2YYcJjGhiECepzWUToyvVRDEp6XX5oWHHfLQA
	 HCs8sJVVj0WmA==
Message-ID: <4f82b8ef-77de-422b-a9a5-691c4eca24a3@kernel.org>
Date: Tue, 23 Dec 2025 10:38:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2 02/14] mm/sparse: Check memmap alignment
To: Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>
References: <3b758468-9985-49b8-948a-e5837decf52d@kernel.org>
 <CDAEC896-E3EB-4EAB-9F0F-70BC448B3B9A@linux.dev>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <CDAEC896-E3EB-4EAB-9F0F-70BC448B3B9A@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: z15q5cxo8t6p8j87eip38wxmqbtm4x56
X-Rspam-User: 
X-Rspamd-Queue-Id: ECE1C4000A
X-HE-Tag: 1766482715-101602
X-HE-Meta: U2FsdGVkX19npl0cxreS3hqOy+8nqkhlAxEwvFjuLPfxWDicqvdCptuiISZpfeaZpsuUKo1akGHkWVHA6pK02JMULd/Lr7b9BE37KIswUbUUoghZcpSgjartZoGC78SnvIk9gZYHI6GXHyJcbur9EXddEQkgnyctAPOMDiLcdP2yzg/ZcgeVfLCSlENi5Bm071RkWoV5xuxIM0YN0tYP8vCDces0A19SPTSWpKt3GCnuze4C/Uqq0Apq+i6iQ4eFC+tGTHl2faffBRU7jqQAu0OJ5KvOJn781rtr2jQF3MCDeAbFcwtbA5RQsnNaynBpm8bCtddf0/gl2EMUpapwzZQv/020aw/NClrLjmtxrb16Hkmi41/tv2Le21A13a7ol5O7rhuyCxG+X4zqVyqsWNe5ePuR6OUl7oECNFlAUIGA1mgU6+PurowocbknRTcK9EmYRIHZXsPXUHeDbMU2oQ0WctmKk986i/1hRMmcn4Slk5ljD09/6im9UwMywurc3nO0+cyokj5iSeJoIZpHnLpwdPiXHxliF9v+kUjawmhQe1UIDOHEU1EReghaMKmPu4HPu/bK5RHlOkR375ShxSL714BLk3Tm3joqYP/t46HrSibTw49MjBiSA9rN53gHYXXUTfXmUk159/989zSXAR4ogN9H7Y36jeuigvYBr08N/NrJopZ71Hz7e/L9BaBmRR4VTTOaHn7nItz/4iIyZQ1D+gfHDcyod87UMZr2qC9B4IyzHKUdNPsyXxoe7STRh0Dt6ElhJf/zwHqnsNKlXfH7i8J+guCVX0pmdAvg5iJ5WRot6oi47No2HP9Vb5G2JVrdGp8UH5RW+696+4WIvPxN5odEhGDUEzzdZGKYR+mlPkD14E1qR90pnQJoR88ogeSdFrT1URO+H2Y3/Vxx2hMfHLbZ3kSg2HjyhTZJ1DdXAwKnI/8tUxygPR2vUX19YtqmRfTSl42ZzCMrCA1
 z3ZH96H0
 thlQCsAp4RwL0Jr60Vjo0ueFA6+9sZbKRIrtCBmVcMHUsWo4ZP4lKmrHP/BFXtbMXDYCaXUWsI7KcPmKYHp/xO8HUjqlkmQ9paGVG70ohdPwDO/gRZpM98TghpNUZbfaYmNHCYvoR9BKJeM4aXS1Mpe+QPGKEe7S+iqTVdVdVL7Y6AP8nKGISqT5enSayc7HJ3E8oH0vnit0nK/O6nqsZoaZ3fjxsXhHbr10snH7p9XcZ7vSvoDRtP//jTyb7w0B1PRjrDBHGn+GszaBUIAdlzoT3C/a0Qq7BzDHrUI6nJuEfAT2xUtzYReuSOcaT9LIHL2B4JqeA1Cz2O84I0wbo9hvQuASpeoK/yc2iNUFCcSkI49M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/22/25 15:55, Muchun Song wrote:
> 
> 
>> On Dec 22, 2025, at 22:18, David Hildenbrand (Red Hat) <david@kernel.org> wrote:
>>
>> ﻿On 12/22/25 15:02, Kiryl Shutsemau wrote:
>>>> On Mon, Dec 22, 2025 at 04:34:40PM +0800, Muchun Song wrote:
>>>>
>>>>
>>>> On 2025/12/18 23:09, Kiryl Shutsemau wrote:
>>>>> The upcoming changes in compound_head() require memmap to be naturally
>>>>> aligned to the maximum folio size.
>>>>>
>>>>> Add a warning if it is not.
>>>>>
>>>>> A warning is sufficient as MAX_FOLIO_ORDER is very rarely used, so the
>>>>> kernel is still likely to be functional if this strict check fails.
>>>>
>>>> Different architectures default to 2 MB alignment (mainly to
>>>> enable huge mappings), which only accommodates folios up to
>>>> 128 MB. Yet 1 GB huge pages are still fairly common, so
>>>> validating 16 GB (MAX_FOLIO_SIZE) alignment seems likely to
>>>> miss the most frequent case.
>>> I don't follow. 16 GB check is more strict that anything smaller.
>>> How can it miss the most frequent case?
>>>> I’m concerned that this might plant a hidden time bomb: it
>>>> could detonate at any moment in later code, silently triggering
>>>> memory corruption or similar failures. Therefore, I don’t
>>>> think a WARNING is a good choice.
>>> We can upgrade it BUG_ON(), but I want to understand your logic here
>>> first.
>>
>> Definitely no BUG_ON(). I would assume this is something we would find early during testing, so even a VM_WARN_ON_ONCE() should be good enough?
>>
>> This smells like a possible problem, though, as soon as some architecture wants to increase the folio size. What would be the expected step to ensure the alignment is done properly?
>>
>> But OTOH, as I raised Willy's work will make all of that here obsolete either way, so maybe not worth worrying about that case too much,
> 
> Hi David,
> 

Hi! :)

> I hope you're doing well. I must admit I have limited knowledge of Willy's work, and I was wondering if you might be kind enough to share any publicly available links where I could learn more about the future direction of this project. I would be truly grateful for your guidance.
> Thank you very much in advance.

There is some information to be had at [1], but more at [2]. Take a look 
at [2] in "After those projects are complete - Then we can shrink struct 
page to 32 bytes:"

In essence, all pages (belonging to a memdesc) will have a "memdesc" 
pointer (that replaces the compound_head pointer).

"Then we make page->compound_head point to the dynamically allocated 
memdesc rather than the first page. Then we can transition to the above 
layout. "

The "memdesc" could be a pointer to a "struct folio" that is allocated 
from the slab.

So in the new memdesc world, all pages part of a folio will point at the 
allocated "struct folio", not the head page where "struct folio" 
currently overlays "struct page".

That would mean that the proposal in this patch set will have to be 
reverted again.


At LPC, Willy said that he wants to have something out there in the 
first half of 2026.

[1] https://kernelnewbies.org/MatthewWilcox/Memdescs
[2] https://kernelnewbies.org/MatthewWilcox/Memdescs/Path

-- 
Cheers

David

