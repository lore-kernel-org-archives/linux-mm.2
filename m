Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D02D3FEEF2D
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 14:44:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 162CD6B009D; Tue,  7 Apr 2026 10:44:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13A296B009F; Tue,  7 Apr 2026 10:44:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 029406B00A0; Tue,  7 Apr 2026 10:44:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E1E936B009D
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:44:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9768213BAC7
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:44:13 +0000 (UTC)
X-FDA: 84632029986.11.F1F9C9B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id A7A43C000E
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:44:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="OPk/0Wse";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775573051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F+uI6OTjdNGqztBt0n2prscGZ7Rv6C1epHgWbD05+lg=;
	b=LU59KJRpHybCrg9qA29nJ8qDkbdNu8cazK85xrQe19Ed5h/+aZGqW2LEFmkoCsz6YH2+6e
	uJOF+6AWznCx/p6LYhdAHK4YGOI1Mmo9jdO1XIcsI68VB5qu0CQ9AB3HTjCDjLG4bSth9e
	SQPwAcUjq5mQBtdehpqGC2SyP8ZoYlI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775573051; a=rsa-sha256;
	cv=none;
	b=YNihT5t+oCbtNiZ+W59GsFFZBUcnUoHCW7y6LxIKuusxylbvrSqMF43YVHI6fNJgNer27O
	C4GI14pjhsjn+4twSvo+Rmj+wAXzytomAodQBebB2Hs8kUJVo39QCwM8hMDqMGWp3DVW9m
	PNkjUTBsiZ6CeRKBSO/da5jXMEkdKiw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="OPk/0Wse";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A400C44434;
	Tue,  7 Apr 2026 14:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87D83C2BCAF;
	Tue,  7 Apr 2026 14:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775573050;
	bh=IS0Hw9PqtMklbf3GWeAwTjwZLCZcdU9hKiZ7Q2p69rA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OPk/0Wse1jxxBZKtv4rcO4Gjx1K+m0MTWP/fTlIwRk1JwHS+5ZAVzLxPrI80dbo7S
	 bt42fl7CaU2LebeROiJebJpvN6ACCEpKFDwoIoilQb7M1A9OPTbmptpMDPXx8/RTgA
	 0aGA+Q5EKLfGNjU0Reaccn6RVpk6KBg2/RfsPEMBiJl6v4M640lUVetpk/JyU6fHji
	 saeKf5dKKqTxmKbyTaXTlSKhX5kABP9Jyhd6bHtOYPgcRiJePsej+US5fQhmP6cNbm
	 eh1go172haGbqz7uIwADtg1yKxzB6OJBSGyXu+KDC9uTDa/IptojjpyCMl9x3acQhS
	 kvl1pKU0QUmrw==
Message-ID: <a77b39a4-c6dd-4a8a-8ea4-2bdc31bd3601@kernel.org>
Date: Tue, 7 Apr 2026 16:44:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 00/16] arm64/mm: Enable 128 bit page table entries
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260224051153.3150613-1-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A7A43C000E
X-Stat-Signature: nwc7g9rpjduoa9nor7xnrmpx9zbqpeuk
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775573051-495169
X-HE-Meta: U2FsdGVkX1+OVPGfN/+0kBjaMVUqUV/OXWiDca6rW6JWeXND7+bJUXGWfcBvP7PR4s4YiNFQ+/h4h5E1faz8mam8wBMmwhz9NI1NP/sk5x8Lig7xAPTfgOgxQZ3B4+KKt0FFqc8qSLG5DF0GIz62D7qewkz5aKO/Xv7yMVKw/DjDllm0VKXRYcpHlta69VHLa75eb6EPUYmHMN0FQSIY/Elp5wBC0tNB4zAarxC8FoM1dY9wVVsvD16NA59gaMwE0nNjJ0OVGdEDG1WPCcea51z4LCMEuQNWDOhDFZ6Q60Z6wwRc7y1+N0QlaVMWLbPNaEtuYD/v5THpush9g3Hr3pr2eFN8YYa3GAb9jAVCy2wifZ6k/sJSWCmv/w7QiQifKmodixI24Rhe+UdeasMv3kZu+CsAU/tjyZu9/jwJC3LCTQ6y5jD3QIQsOQABSlA40aU45LA8pA5NSb7jjpNyYjajJAyDe5gY8TlxvXYMm6mtZ5p2naqgK7VFWuVAuvxXjTAsP+QtK82UPdCmLITAj3NGRotLRoxI0Iz4EuBj8PRSzeG1tqMGklR80sFhnmddhoBhNyZhOOnVmOEfL7aIJglAT6BB0sS3d0j6nVAQ7prMOVqFW8RKPtzB4Hvp2tTKW7zf4C88Rln8DTVQZFtZMw9B/TA2548FGKjbqoY1iJ+cvJo6XMI0ppoLetLUqwu8oLX+0Mj7g7eki3RsfnkPsUeU4phoORy0cexYvW7xSEMdTEXgBf7O3t7RDxu6yjij6XKTdFYgIRJywdN3kw5t1QnNOcbQi/w5r1N8r0U0IWuMbLW9lkoyCV5+Zg06iuilNtrXZSDB9tAw4JOkS+5k6iWJlgYY4CRQnfzFHD3sJ7pEI+2IBmd4foMWqPsnc/+YJ8YHGaQHbczE1N/b69qJAP0FYIX/JPdPOkA5HoZa58G7dvJAf8OJSPDJabgZpCWuvZKQi8jauXIgms7Yn2c
 Umf8EAFw
 2ljlQluliXWETK64hHkoJvhH+akoeE6Dvj7A9nnh4JF8EnZGhOa1qw/OzLH+wMALCTJD+NGwgRY/t3FZYQIwA3ZDCIF5EmKTxEof6M9iOS0lPraljemSaTdRyIUjp8cYeoNOAJ9PEnZLQkICm/6pVCWeYqW99rmAO+knjVpRspTqAM3W9Y67MwmeqZtGWH/l9vRVtsxcDVqaxgKU3uKp8kWIuPL0jUyBUqZ+MgdfhUWCz5tE+sZWw3rFKyKkWiYZ8AMNG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/24/26 06:11, Anshuman Khandual wrote:
> FEAT_D128 is a new arm architecture feature adding support for VMSAv9-128
> translation system. FEAT_D128 is an optional feature from ARMV9.3 onwards.
> So with this feature arm64 platforms could have two different translation
> systems, VMSAv8-64 and VMSAv9-128 could selectively be enabled.
> 
> FEAT_D128 adds 128 bit page table entries, thus supporting larger physical
> and virtual address range while also expanding available room for more MMU
> management feature bits both for HW and SW. 
> 
> This series has been split into two parts. Generic MM changes followed by
> arm64 platform changes, finally enabling D128 with a new config ARM64_D128.
> 
> READ_ONCE() on page table entries get routed via level specific pxdp_get()
> helpers which platforms could then override when required. These accessors
> on arm64 platform help in ensuring page table accesses are performed in an
> atomic manner while reading 128 bit page table entries.
> 
> All ARM64_VA_BITS and ARM64_PA_BITS combinations for all page sizes are now
> supported both on D64 and D128 translation regimes. Although new 56 bits VA
> space is not yet supported. Similarly FEAT_D128 skip level is not supported
> currently.
> 
> Basic page table geometry has been changed with D128 as there are now fewer
> entries per level. Please refer to the following table for leaf entry sizes
> 
>                     D64              D128
> ------------------------------------------------
> | PAGE_SIZE |   PMD  |  PUD  |   PMD  |   PUD  |
> -----------------------------|-----------------|
> |     4K    |    2M  |  1G   |    1M  |  256M  |
> |    16K    |   32M  | 64G   |   16M  |   16G  |
> |    64K    |  512M  |  4T   |  256M  |    1T  |
> ------------------------------------------------
> 

Interesting. That means user space will have it even harder to optimize
for THP sizes.

What's the effect on cont-pte? Do they still span the same number of
entries and there is effectively no change?

> From arm64 kernel features perspective KVM, KASAN and UNMAP_KERNEL_AT_EL0
> are currently not supported as well.
> 
> Open Questions:
> 
> - Do we need to support UNMAP_KERNEL_AT_EL0 with D128
> - Do we need to emulate traditional D64 sizes at PUD, PMD level with D128

It would certainly make user space interaction easier. But then, user
space already has to consider various PMD sizes (and is better of
querying /sys/kernel/mm/transparent_hugepage/hpage_pmd_size instead of
hardcoding it). s390x, for example, also has 1M PMD size.

I guess with "emulating" you mean something simple like always
allocating order-1 page tables that effectively have the same number of
page table entries?

The would be an option, but I recall that the pte_map_* infrastructure
currently expects that leaf page tables only ever span a single page.

So it wouldn't really give us a lot of easy benefit I guess.

-- 
Cheers,

David

