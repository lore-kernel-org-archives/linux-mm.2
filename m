Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 567D8EBFD30
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 10:01:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ED606B0089; Mon, 13 Apr 2026 06:01:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79E856B008A; Mon, 13 Apr 2026 06:01:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DBA36B0092; Mon, 13 Apr 2026 06:01:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5EF216B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 06:01:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD6A086125
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:01:19 +0000 (UTC)
X-FDA: 84653089878.18.D95A6AF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 911651C000A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:01:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Jf/daWju";
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776074478; a=rsa-sha256;
	cv=none;
	b=gAh8/sSy8rMQnSsrDs1LK0JE6L0w/Cfy09ylHAuAgZo414AvMsSuFDDZNE7p3YmfdxHToX
	lzsYLJ7rtMAB7+hsExcpvKrgzhRsoJkvkS7Ze6mGMHS8pL3wobezgvbbwFyea2fznwf7LN
	JGXnJRaMKlqx+i0z4IsLHdAnFiEKsTA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776074478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VfA8RhsAOysYjLUfYem1mhkUwG7Eg8LbTrkQ0B9ZA5I=;
	b=idBHB4BiichZ2tY9t+7MSQ3d0Lcml9tJx4Mqt54B4kj14RvXQ+zTC+Y7/A/H90vQm/uyMV
	roN6uK1LgrM9VSR74rjxw+AW8/b+cOyexs09NHDqiQXaySYT0HLzdEcApeWiNy42lmRQlD
	vulWYmHoNPacEogtM+Ur8fVAF288DHE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Jf/daWju";
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D15DD2BC3;
	Mon, 13 Apr 2026 03:01:10 -0700 (PDT)
Received: from [10.57.62.88] (unknown [10.57.62.88])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 437D63F93E;
	Mon, 13 Apr 2026 03:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776074476; bh=VfA8RhsAOysYjLUfYem1mhkUwG7Eg8LbTrkQ0B9ZA5I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Jf/daWjupLaPbtHP/9QPzRRQx2LsU2h0EnB1m1NdswrK+Tj1s1zcYjBVTmPki3tdM
	 7gY2Gvut4emf1ojyvOanZa1i2jfuUo7ky4CBaE6ouf8gmcuLIGCZjQ2pU3LyrFgzxD
	 XG+KcXKif5eeNFnVo6KqtPcCuD7ql63VM3m8z5HY=
Message-ID: <4ac1d020-9aec-4584-a75c-225c6166c253@arm.com>
Date: Mon, 13 Apr 2026 12:01:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] mm: make lazy MMU mode context-aware
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1774420056.git.agordeev@linux.ibm.com>
 <de89fd353a8dcd5e3bef4d91e9b6682d132ed9a0.1774420057.git.agordeev@linux.ibm.com>
 <44dd86c0-1845-4dd9-b4b4-2cef6d1c6357@kernel.org>
 <e096e88b-f1fe-44a1-bfa6-451eef028203-agordeev@linux.ibm.com>
 <c27cad07-bba4-472d-8853-fc6fc55e951f@arm.com>
 <630ce949-2f9c-43ce-9641-b9a4dc729323-agordeev@linux.ibm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <630ce949-2f9c-43ce-9641-b9a4dc729323-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 911651C000A
X-Stat-Signature: qku7bxo7tqwabftfaee9b95wpdymqidh
X-HE-Tag: 1776074477-139961
X-HE-Meta: U2FsdGVkX18KyLqOyVlpJe+ABxh4DHnyIdtr8e/gVz/XHY5a7fVvHuxL1tNZ0bqgrdh18SRX7iV3+1BsMrJhDOAt/e0VO11TdNkVichV1CgqTUudRmTB7vuIocfQNFlAJIjxxZU5C/SZmy2UFcGA0QeQeKLRk77XXbAfC7DrtL1SSzWZ/s4MmBGJfO9ow6Rpb9dZobP6P/JH7DgViRE3BLy0zHjytBgNRiZvQdvuscDMe/eqv3ljMdMM8EohisQGd/9rgsmc3fv98S1vsoX35tiDXH/p7G1FZdvbhueZHcvmY2+IPRPcVnzxTdZY5+XdGOi9LMYvMvQ/rs4pwBud+Ykv13xmyfG4H4zT/2GMQnPrxJhQGi6yYxa82DcBE06j/YKER/+8Bzeyk5mIQvMzpvRuLn51ul1YrcFhXs+a4lneZbEGpyoqBPQw+EKVxgDsRk/Lnb+a1NwA+YnH40jYTWZ/lbVi22OSGIREbzB0IjqvQRof9aDG/OEIOw09aMwN8k6lw7EaD/COK2Rv2P0FTmPNVlt2EHyygA0XI+L4dvr0EXAp10HhOAZnIHhh9hvj1HH9J7ZpPwjL4M0/sUfDvC/l8HFbo2S/MliV8K5daO/6BBNwrVS/QmweqLmQfxCSM1k9OQQttoJGCWT51wu+CpAtKke5fq0FfJkAgk7d3m7U7y37ZiNJPj6YnddpSa5tSODioI7NVrRfv7o7GEZGN2G7qT1/avDm+efaJjTOIJ/ZXmHsg+vrETWGlx0SDllJW8kw2k/tH6tfP6MrQ/6YtoD2WPnomJUL57UhycaQpqW3Yatn0T+edAHz7n0n4TtyGLIOAa6efu5CZEdcq1ZXIJou5V+rllzU1AoV5gcaOgRR1+YGV9GzjMFQPuxERVp48+OfelpKSmZoR7y+hCLMr1Ze4b4s5CF7AIoTvnTKl/+cH/kG31mo5Lcvcq4dEc6ALemZKIWQEYkC48B0Oaf
 +b+S4cI1
 IMnOVOVuepcBITc7mciaWtkGfY6XdUBYnPvhiFAnOdtnIfBDOjSvY7nJQ+VoQjkQEnK5zZZ7vkLlvXTdWAO1JxRAvXkZta+DUWPNavfWs+xNwexMNxAuM6LQtYqdjluozJrXM5/PfCSCgTGDRcXsvSCKwkTRStPSkTT5zaKGF/39sSsJqSsLPg3Jx+UGBL24XuNw4X9n0vjJNRvQWzFfRqV+zPD2TXoLFKm3y/bw8LL8rDTs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/04/2026 11:31, Alexander Gordeev wrote:
> On Tue, Mar 31, 2026 at 04:15:23PM +0200, Kevin Brodsky wrote:
>> On 25/03/2026 17:20, Alexander Gordeev wrote:
>>> On Wed, Mar 25, 2026 at 10:55:23AM +0100, David Hildenbrand (Arm) wrote:
>>>
>>> Hi David,
>>>
>>>>> +/**
>>>>> + * lazy_mmu_mode_enable_pte() - Enable the lazy MMU mode with parameters
>>>> You have to be a lot clearer about implications. For example, what
>>>> happens if we would bail out and not process all ptes? What are the
>>>> exact semantics.
>>> The only implication is "only this address/PTE range could be updated
>>> and that range may span one page table at most".
>>>
>>> Whether all or portion of PTEs were actually updated is not defined,
>>> just like in case of lazy_mmu_mode_enable_pte().
>>>
>>> Makes sense?
>> I also feel that the comment needs to be much more specific. From a
>> brief glance at patch 2, it seems that __ipte_batch_set_pte() assumes
>> that all PTEs processed after this function is called are contiguous.
> No, this is actually not the case. __ipte_batch_set_pte() just sets
> ceilings for later processing. The PTEs within the range could be
> updated in any order and not necessarily all of them.

Fair enough, I suppose what I tried to say is that all PTEs must be in a
certain range :)

>> This should be documented.
> Will do.
>
>>> I will also change arch_enter_lazy_mmu_mode_pte() to
>>> arch_enter_lazy_mmu_mode_for_pte_range() then.
>> Makes sense. The interface looks reasonable to me with this new name.
>>
>> One more comment though: in previous discussions you mentioned the need
>> for arch_{pause,resume} hooks, is that no longer necessary simply
>> because {pause,resume} are not used on the paths where you make use of
>> the new enable function?
> Yes. I did implement arch_pause|resume_lazy_mmu_mode() for a custom
> KASAN sanitizer to catch direct PTE dereferences - ones that bypass
> ptep_get()/set_pte() in lazy mode.

That sounds pretty useful!

> But that code is not upstreamed and therefore there is no need to
> introduce the hooks just right now.

Ack that makes sense.

>> - Kevin
> Thanks for the review, Kevin!

No problem :)

- Kevin

