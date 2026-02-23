Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 738E9EA4FB8
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 13:02:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D12E36B0089; Mon, 23 Feb 2026 08:02:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD3816B008A; Mon, 23 Feb 2026 08:02:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE3716B008C; Mon, 23 Feb 2026 08:02:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AC51B6B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 08:02:05 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 68A9D1B4B2B
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 13:02:05 +0000 (UTC)
X-FDA: 84475734210.29.D52E319
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9349680009
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 13:02:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cg4pvRYN;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771851723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NsS/9+HcDTuMdmMEgYfhZzKjBkqLouhjRQsnlSAtlSk=;
	b=edZM/VajrJA9RzTqObWNuFIj+YB3nCYIRhfh3iN2VIS5/qoTRnurM0Wwnir+5Knf6PkuMz
	vCP2esA7NuDEFH2+dSSfpfBbvdxgfk9e7j2WFl7AmB7PzCB9O/iF4H2P0J3xJJM1rG2WY5
	fOD95GCGU9zxgVBiLUxb87T05c0Hlkk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771851723; a=rsa-sha256;
	cv=none;
	b=M2jkes20J86Pc4/jPZDZm0eoMzBT9IXAsKiYSrVSfsq9uDGDa/lJ1bIuRr8UhAickfydk8
	eUkqO+fy7WcV4YxM1M2GnEP9Jz1XfXBFIRCRsf1bKQnJeqVnDsPH+IgilBjb80q0Gog98r
	J1ucJoSKea1yTAnKz5AVuzye+ia15zM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cg4pvRYN;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E80CF60018;
	Mon, 23 Feb 2026 13:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41205C116C6;
	Mon, 23 Feb 2026 13:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771851722;
	bh=uty3zD22JbjBsQ+Hol0jnFAoRmj262IBujSXOGhaqG0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cg4pvRYN/PneO0ZuQ2YEt6S07AB1iVEyGwdOwjUG12NppCtClxN/K5TI5eU/g/XlU
	 wl3U14eFnstmcFS+P30wJUNka+2y7ntRS/aolCXbTmV2hqgiCQm6kzA3FtGjAM+Afm
	 C3e9fBA8VHZGjSJ5LTURTZC297efhP7BqeBEASOElZW1ngkY4kM6AXSXxXbuDNBv8E
	 ekS/QIcNgQKCxuCz9xQ/b9l8gZ7LiIO9Rh+NK9M1PzxI07tDuHG3/Z2PYCXFvutful
	 c3xTzrNUIjID/q/w9Gm6RfxYPTgI3Q/4zui7oVQ2HcCPFFztXblatEv6W5AqjWsCw9
	 TTV1uyJV8nrLQ==
Message-ID: <c338ac80-c680-4a40-a1f5-f5808c816090@kernel.org>
Date: Mon, 23 Feb 2026 14:01:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Per-process page size
To: Pedro Falcato <pfalcato@suse.de>, Dev Jain <dev.jain@arm.com>
Cc: lsf-pc@lists.linux-foundation.org, ryan.roberts@arm.com,
 catalin.marinas@arm.com, will@kernel.org, ardb@kernel.org,
 willy@infradead.org, hughd@google.com, baolin.wang@linux.alibaba.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20260217145026.3880286-1-dev.jain@arm.com>
 <yfe2xbb6qwthg3cf4yr7zszpw5o3mx2v4bv32iwnm7yzxqjsvl@et22s2nuwzzk>
 <a778d249-afea-4488-b045-beff3492a48a@arm.com>
 <fqsd4x5oqavouhwawmsmpanaszvr6xsboc2oeqzs3fafrtovpk@gfnqznoqlabk>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <fqsd4x5oqavouhwawmsmpanaszvr6xsboc2oeqzs3fafrtovpk@gfnqznoqlabk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Stat-Signature: qt3a7xwsdf43w5g6pyxwxmdri9rwffqh
X-Rspamd-Queue-Id: 9349680009
X-Rspam-User: 
X-HE-Tag: 1771851723-484385
X-HE-Meta: U2FsdGVkX1/wwxit+ugoXpzII//Nec6uZpZmdbvtwcRaXh2FulUFcdStt/Jf3ucMAoBwI1ZXHTeb+s14AOmQiHJBG9uCScV1Xx8xKxzzdRZEVZjQegGlvz35VaybrWbNCaiyjrJkp9OgoOHFwsj8NYy6QANkOt60eOsrb7Qo6XFrPjqK3mQHh9fi1ZuedPfyCnk6j8IpbIkN5TgaQmQlnH8UxedVrCszgTIVFlEnWJx3CHm5pOoR/fcsLdmBMoxf/xkxGL+8oWys76r2t8ETDNH6ZuXErOzQB3ODD6+4NjlcUthtJOhZ7MJZ25eil/Q/bD9GxJXcafPICw1+92I7U4eJYVuuot9rt4ccRacVFFiwmPwz9VHqoH4k3XuHk1V9xzK8sqbTWR+7GYuqgG0EAqgNrzqyLmGWnFEE/s+z5blGz1ePry3DoVPTjGJ5ZvPGRca80GX15tzK5GYEFyd/hAVRSPaHJbHdek3FISmX61Cd2O2FXpzOOaIE2rxbFVIw2RSiJvtCZTKhLXOjRMD2FfD8LJ1CJx0rOYArZ8Xt0XIiBbz9xQ220jDYJ5efpsp00m+OSSwuxeJasz69eeLtKugufW9FqdpYM4y4Lo2iiBg4m7tBmtshHaMw620cP6IU4uXZrbw+tK2oWiojouzaZyc/o8JSr8ta47m1736RQGoYgRmYnWinYEg8Di+gXNn55aT2+GZbweQF2zcdC9ydD08XoezBX1MXeGgFsmzmkISLI2+tDMjGF47DfrD0O9/vIFv0/uwKok18ObPflprdNYb5BHpWUSsGyzR14R4lwQ2P3SLtG9hU8AfTqHIMzPTcvXa2kAQrLQ655a22otEEaG3XO0xtgXBYIXTh9CAC47T0H9FvpLSjaZCHUrcUiaoHyvavoUrjfmrzfcP1kp9LOuC1XkieMBJJ+zKnlAHCKnUbiiQysBvFnMMDAfyJ175z6AJvR2so8byRqv1Xo2O
 5BUIsHaw
 nK7+RqHNIyOfEfPfyJ4RmSBGdJTszPiXnjuKz9jzao1vaLm6hBd9/rUvt9frKB9gsr8eza9cp64VrbMoPrKGwaQhTYe6J4EFrwdCW/jP358r1vSUsDS7Owsam+nxezRtkK5f1WsRG7fT3ZcMWcx+MSWYRf2qukWJtpIZisibd+Rzdgvy2wWnU3vaeSfXxipzNyJ8SmIh+BIVhkqZzXYap0/HQf5D10eLi0za/IQ5XtCVT4awFOkulC7HTkHQiJl4CzqHh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/23/26 13:49, Pedro Falcato wrote:
> On Mon, Feb 23, 2026 at 10:37:55AM +0530, Dev Jain wrote:
>>> I don't understand. What exactly are you trying to do here? Maintain 2
>>> different paging structures, one for core mm and the other for the arch? As
>>> done in architectures with no radix tree paging structures?
>>
>> The mm->pgd will be the software pagetable. So suppose that do_anonymous_page is
>> doing set_ptes on the PTE table belonging to the software pagetable. We will
>> hook a "native_set_ptes" into set_ptes, which will set the ptes on a different
>> pagetable maintained by arm64 code (probably mm_context_t->native_pgd).
> 
> Traditionally, you do this kind of funky manipulation in update_mmu_cache.
> 
> But this is still an extremely complex and invasive change (that I assume most
> people would not like to see) with dubious benefit.
> 
>>
>>>
>>> If so, that's wildly inefficient, unless you're willing to go into reclaimable
>>> page tables on the arm64 side. And that brings extra problems and extra fun :)
>>
>> I didn't understand the reclaimable reference, but yes we need to make this efficient.
> 
> I'm not talking about CPU runtime efficiency, but memory efficiency. Doing
> this makes you essentially duplicate page tables - not exactly ideal. This is
> a Known Problem in classic UNIX systems which do something similar
> (but not the same): anonymous memory pointers are stored in some intermediary
> structure (SunOS and UVM call it "amap"), and paging structures are entirely
> redundant there. They can freely tear down a page table because they can freely
> put it together from the amap and file mappings (what they call vm_object and
> we call address_space).
> 
> Anyway, I'm boring you with these funny historical details so you can understand
> the similarities: the Linux page table format generally matches hardware, and
> we store anonymous memory "state" there, so you can't ever tear-down a pgtable
> without losing state of whatever was mapped there before. However, if you go
> down the "arm64 now has a separate pgtable structure", the roles switch:
> arm64's internal page table format makes for the real page tables, and linux's
> pgtable structure is nothing more than an "amap". So you could (and perhaps
> should) freely reclaim arm64 MMU page tables once memory pressure hits, because
> they are freely discardable.
> 
> Does this make sense?

I've been thinking about building the 64k page tables similar to how 
HMM/KVM handles it, invalidating them through mmu notifiers etc and 
building them on demand.

Considering the 64k MMU of a process just like a special device that 
builds its own page tables.

This way, they could get reclaimed more easily and most of the core + 
arm64 page able manipulation code could be kept as is.

However, I don't know how much the performance impact of that approach 
would be.

-- 
Cheers,

David

