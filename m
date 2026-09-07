Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AD9CC79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:05:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4948B6B0093; Mon,  7 Sep 2026 12:05:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46B856B0095; Mon,  7 Sep 2026 12:05:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3826E6B0096; Mon,  7 Sep 2026 12:05:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EDC586B0093
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:05:38 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 52974C01D2
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:05:38 +0000 (UTC)
X-FDA: 85187441556.28.2EE4E66
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9B5A7140002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:05:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tr2FfEF5;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788797136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cOwjWSZU7sqyLauvsyIOoxB+VUvKj3AIMfesn2Gg0Gs=;
	b=6KC2g7t1NcIDYj6aFIAu6q1pUhS7Lu3uHyvYDU+1Pb7pyJ9FOu6oWRafVx+iLcHsbT0jZq
	NpLUfdutIrSk52JRpK8UZ109ePvNg3A890FeBZVo32e6S6P7byLIJ88HPncRqPDO7F6xJz
	o7mTTi3kkgGCpnC9peP7CxuYQmPkxug=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788797136;
	b=rMoBOFV97hi5GWxU7bVsa4zsCEQ1C7A5QK7Mh9hozt6B8XMwOgUBmqVXJJBcLotrCZT6NK
	+cJtxNLqrFmWd3OFLXabSfmlqmcRFaLCtNtXys4LzCAVvNHsipFgKu6e8I4/uHhE2En9Cm
	dILY0IejhDSZ/wGq2Pwa6L3yNciCzbI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tr2FfEF5;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C0AB860AB9;
	Mon,  7 Sep 2026 16:05:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781941F00A3A;
	Mon,  7 Sep 2026 16:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788797135;
	bh=cOwjWSZU7sqyLauvsyIOoxB+VUvKj3AIMfesn2Gg0Gs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Tr2FfEF5/if8uJWKIxG0gE5uW6MrLIgXVkxsnhUy2MNYuwpxXo8H+OjnTjCKewBXJ
	 d79BgOnqHsR7OmNC9i1+jf0O67/1aa8JZWXysbEVcPbVGzNj3oXhcEi6z3SiG7r2JL
	 +4MTKVg3wKoCBfOBFDSppxqsV3QZ7izVPfXUj0eVgtdZ4TkukInO0lmXpZdjKBvD7S
	 PXAVKbo5EjdtEfouYHfLhWvHBmIzWabnoPM7yg2O8bNWZIoRqt9sjWWiixxO1ln/OS
	 MDRbLwpkgPbwt6u54BQApi/TupnPS4tGhC1w8XdKDFKDgxthmAZky7owi8ZMvhDZ+S
	 fhL50r3JSR4UQ==
Message-ID: <5491be7c-1bf1-464f-877d-9bb86155310e@kernel.org>
Date: Mon, 7 Sep 2026 18:05:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v9 13/25] mm: kpkeys: Introduce early page table
 allocator
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-hardening@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>,
 Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, Linus Walleij <linusw@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <20260818-kpkeys-v9-13-743ad31b2c8f@arm.com>
 <1dc8739e-4eb6-4a71-9534-e03a15afd620@kernel.org>
 <7af32e98-f2ab-4961-9e3c-72b8a21416c0@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <7af32e98-f2ab-4961-9e3c-72b8a21416c0@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xx7r9cg3zdkoxpkewnujnmm7n7zicedf
X-Rspamd-Queue-Id: 9B5A7140002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788797136-12287
X-HE-Meta: U2FsdGVkX1+TPJLq4AoYXzuFwMNIfAmTMvKkvjHJv2WF+Jil4JQSsPz5BCfY7qXQxrBvEF70ocUPoAfX3AA01tXfcIDjf1T7rkdaD4JHOZW5VPCiSDxUEJr4hzgIVw21IRLIyQ44JQFsB/CVOdRzOOnGVbuTczHOWNCDL4KUKZGfIJB/toS6a7yiIi9TPBIMunQXzwDZpDUOh4K6CA/Cik/h03uUH/umfGmz+bXq96hsYgjoG+J8nJquUTFgVham1DUSgZZoRNUWI/cZA/eJmT532JAUxLegL1+rj/HGYBT84Yf8c64oj9JH/pJbapLuPBAKg/KE89F6dmjE0TuxK+rHHcJwCn/LUMebm1ILvSSkqlT1hgmqUHoMH/2IRcDO3gwkdRT50GJkhNMU4Eme4XJZx2gKxap12S+8FCav4AOY7UBDC4wO4VtMH+JowJN7nt+dQkNi16xxyDkfJ8+iyymvw6UAoJmgz8JHHhrY7KpNfYdwyYjKluQ0V63GIjmoVQT4bH80mBpsr257xykOmIt5IuNCYD0k77ewh3IB63Sbx5/nc21YU2d+ht2q/4uv23Q5D0Qmx/xG8pNtTOmqE7kGBU7TMVpHLDiz3r+oXeHcE1JSNX8T+6wRs30bNUrc5ASoZ7VqRTjGE2VWuVVW9FKIs7QVM/eHXqe2JiAMVDVR1ecSRU8hU+4VqW9O6UqWOHxsfelpEtQImCl5jiYOZVv8bIKXOssARzB98+ZX+xCUqPRHGpkBIrLi9ndaVwZloXVtNQU0IWW/lzFB8CxxD0TBja1lYGMdTHlOIPiJdFLPQpjCJZ9NF8UxWmkvwcQnnMSqbTtJ2yE1abBxlDRB459J7OVyN4Sr2eI4K7jxWU3Lov76eumHf/ATmDlK8g+phLUKZpi9nGNueQmkIWHo05aJRRTdUYXNdTPg18Vg/XzvBLYhaQQADndtnHb3UgKMxSlJ1jqN6MB5IYy+wka
 tRDOs8SK
 sqGHMMWdu3hJVkzgGJ6Du7Mmu4NAoEmelAHM8L/aLmcqbgq/fedo8ZcNmF68Jcb+QtT2wLPpoKAbRCC0nz4XXLq/Acw9Y2Sb3KNV6D0ZAlq9+RLNd6/p9fRMCGSxw9iWwjmfn6+MnVI66sTlMc2B5Py6XAZi8FHwum2rEXx3yh/4BOWCGg5Gj6fLw0CCKHdMVSt69DJVWBECYgZ777Z3jleH+wBscnxuXhDWv+/KuqJ849MwlWBa4zv1eWvu4XgiPRe6I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/31/26 17:28, Kevin Brodsky wrote:
> On 27/08/2026 20:08, David Hildenbrand (Arm) wrote:
>> On 8/18/26 16:08, Kevin Brodsky wrote:
>>> The kpkeys_hardened_pgtables feature aims to protect all page table
>>> pages (PTPs) by mapping them with a privileged pkey. This is primarily
>>> handled by kpkeys_pgtable_alloc(), called from pagetable_alloc().
>>> However, this does not cover PTPs allocated early, before the
>>> buddy allocator is available. These PTPs are allocated by architecture
>>> code, either 1. from static pools or 2. using the memblock allocator,
>>> and should also be protected.
>>>
>>> This patch addresses the second category: PTPs allocated via memblock.
>>> Such PTPs are notably used to create the linear map. Protecting them as
>>> soon as they are allocated would require modifying the linear map while
>>> it is being created, which seems at best difficult. Instead, a
>>> simple allocator is introduced, obtaining pages from memblock and
>>> keeping track of all allocated ranges to set their pkey once it is
>>> safe to do so. PTPs allocated at that stage are not freed, so there
>>> is no need to manage a free list.
>> I'm think of ways to avoid remembering these ranges. I guess we get called that
>> early that we don't even have a ptdesc where we could just link the pages.
> 
> Correct, in both the direct map and (early) vmemmap cases we can't rely
> on struct page as storage.
> 
>> If only page tables would be linked in some datastructure where we could find
>> them all ... ;)
>>
>> ... why can't we just scan the page table hierarchy to find all page tables that
>> need protection?
> 
> It makes sense doesn't it :) In fact this is exactly what RFC v5 did [1]
> (a year ago already...). Then in RFC v6 I attempted to support block
> mappings, and things got a lot more complicated. In that case there are
> (at least) two issues with protecting the early page tables by walking them:

Thanks for the background.

> 
> 1. On arm64 with BBML3 we cannot split blocks in the direct map until
> all secondary cores are up. This makes locking pretty difficult if we're
> to walk all page tables at that later stage.
> 
> 2. Without modifying the allocation strategy, early page tables may not
> be contiguous and setting their pkey would generate fragmentation.
> 
> Naturally neither of these issues is relevant to the present series,
> where we force page granularity in the direct map. I still kept the same
> approach as in RFC v6 though, as the goal remains to support block
> mappings eventually.
> 
> That said, as discussed offline it may be sensible to revert to the
> "walk early page tables" approach to start with, even if we would
> probably need to change it later. This allows us to drop quite a few
> patches, since init_pg_dir no longer needs to be explicitly protected.
> 
> One caveat is that in RFC v5, any page table page installed after
> smp_prepare_boot_cpu() is called, and allocated using memblock (or
> anything else but the buddy allocator), won't be protected. Codex can't
> find any such case though so we should be good for now.

Great, that will let us focus on getting the other pkey bits into shape without
having to worry too much about different allocators.

-- 
Cheers,

David

