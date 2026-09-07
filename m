Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF281C79FA1
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 15:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B59376B0092; Mon,  7 Sep 2026 11:52:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B09CE6B0093; Mon,  7 Sep 2026 11:52:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A20366B00AA; Mon,  7 Sep 2026 11:52:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 81A4A6B0092
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:52:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 070D8120185
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:52:45 +0000 (UTC)
X-FDA: 85187409090.13.DA34FA1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 12C5020003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:52:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iW1r4M47;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788796363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uK8qwWRARBfH5Gy9AWfGwymhf1CzcvU1cSkswRjCB3k=;
	b=cAbVpFwdqZkmLX5IdLvNP8/g/pHaD6/LFvjcMDuOO9B8FqWMhegEVOsNrhs/wYUQJTHQ76
	brCEcRcmMTAeWBfSc3xCcZB6o16n69tKKlV8BENK6AmzmcwGfTMI6z0JW4lAUzmb+8b+6S
	1naQgmw6YZCZMx8K2YpgtFDU0iZg3KE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iW1r4M47;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788796363;
	b=Z932+lkrl/ip7owKTkN9Bzt2KragLk1ds0Mnd+Pu2i6pyLL9Ds61zov+LhXVCLYG+bvhqR
	s96Axm/UyWJm4LXmGUYwQO5E24P+Zsax1tOR3wqM0aZZa1owc4zoiS/SiD5bYVrknzew5N
	kAIWhO8Liv1eCa1ydefiRphUXtBsZzM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 55F861477;
	Mon,  7 Sep 2026 08:52:38 -0700 (PDT)
Received: from [10.57.6.26] (unknown [10.57.6.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A60473F7B4;
	Mon,  7 Sep 2026 08:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788796362; bh=1M0VbCBYRIVwvuz1Ziz5LEHR5vyGozoVj/HRYFkUpHQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iW1r4M47ZzYRpwxcxdOYtGK95O9RFQq3qSOfQBkbNtQb6iyGGZJq1Qq7WyOSdxPQS
	 tiShrG7ZcImz3k48GHsbWe18tgI+V91qts8G+Ozl/c1K/FnMZbBAW99fxzFgwYDpeM
	 ak7fGiCiqqU5MYmeGM83AcxJymFeIBMfc/qcUG8k=
Message-ID: <bdba5b54-8733-4d47-952d-e1bd958a1ead@arm.com>
Date: Mon, 7 Sep 2026 17:52:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v9 12/25] mm: kpkeys: Protect regular page tables
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-hardening@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, Peter Zijlstra <peterz@infradead.org>,
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
 <20260818-kpkeys-v9-12-743ad31b2c8f@arm.com>
 <178877845406.3691569.12554855722197968629.b4-review@b4>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <178877845406.3691569.12554855722197968629.b4-review@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1dxagtbfo9ekh745bp7q4c9sduzoma5i
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 12C5020003
X-Rspam-User: 
X-HE-Tag: 1788796362-12496
X-HE-Meta: U2FsdGVkX1/N+0Cp9mhdRmax3Tx2URJPB15oV7Xb8tD8WtoPz8v+QDVMYePoPXm6gC9KrwuOSIaWn8zx+6CDsiYh6pMDmp9zMTe7czy98IwFtECaSijPr7zSsSRRt1jTOIzZFHEdP+DDycj0uugqcZu1TnL3TdPRuUNRyK5gpQm4g+ojUEFroBKmsy7fR0ITRTgI4ulOQbgMQ9qtVLmqxStGhc24WcektfLAKHkJwwq6ApQxAUXHdnRV43C97HOPQzA3VPmnlnu69wDcGj3Hja5KP8Q/7/fKQ0v3oweJZgX/Ivu1fIC46tkyyF5ojzLyWUfK+tHnP/6TgCuNA4jLhP+9DPQxgCkUjwDjSA2gq1sdxKQPUiA4IWVRYpe6i3txi5m6bMUrxwqvB18U4Hy6Tg/XiftrH0JWui870nE9r2ScQeehfv/aeKbLmM2EvKPa0B3cxfYaXc9uytBSJNx4h/Q2Gxf8AHyxWgJgooXojGpGMfxAb1xQiFblcBSthwY2R04arkvBhbHaRNn2fY1UjtfDxB9HiENlejN6zGdZo5DujudJXyz0CWO6rPu9msTwKZnbqnZVDBLhcqOsjtQp7JcGMc5drql1uIyR04Boblgsqg5e0KJlK/dBDXruWdZw6PlpdJrTK3mtR4b0LxPsPyn67EyBZ6vh+2dkuw3evCT33fCo5GRCsI20fOwjngaxEoIW+rM7b0Ywx/70tlAshmVLHF1nClr2jDH3wCfQp5us3XdKKCe9yBvUBz7NtYXSlYXh8X4AmsUQ9oVzmD720QME+rmyfWCJXE+Qi5ZK59KWF7ZM9q9kTo7M87idAlTdlu4zas5yjSK6cF6ONWjdu8K6DfmaKqe+gpuxM+/8upvdpMxEcFMaD2TzMsmuI0yY7YD5/cQhigX5Yf55s9arUC9z1av6+wS8AthgRKHXG+sWuuHW9RDxtin6qOPFKGlf7LJgjoeJ78IWhbdwr9g
 zrum9zFD
 gUrdf8g5pxQNBODYsAYRjfNmP8ycCxANt7nCMj6hG+hmmIzn+oKpypx29fYop3LAZcYl/VuUj2QSHPJQFS3nVOqYlBKRnj9t3wgf3UaODxuYRvIKTeJWQXWwubEjgFxhPlXx1vSJgF8VVyxKExzinkD7McMCalzWoStIcQ9e9xUlERqHuJrxYiQ/agKCNT5QzlK6eqWlNCHlRRbuUh3MxN0nMbp+MY6Ac41tB3jHFVKC8ZBSdnXUxPGj354be5G2Quy0+ilUG05ZglpztMUW9TIQIY4of5Jb1a9m6sNo8IMaiyBJ3MCQhNoQK5VeAyec8vs8B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/09/2026 12:54, Mike Rapoport wrote:
>> [...]
>>
>>  static inline struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int order)
>>  {
>> -	struct page *page = alloc_pages_noprof(gfp | __GFP_COMP, order);
>> +	struct page *page;
>> +
>> +	if (kpkeys_hardened_pgtables_enabled())
>> +		page = kpkeys_pgtable_alloc(gfp | __GFP_COMP, order);
>> +	else
>> +		page = alloc_pages_noprof(gfp | __GFP_COMP, order);
> Can we make it a sequence rahter than a branch?
>
> kpkeys_pgtable_alloc() does alloc_pages and then sets their pkeys, so I
> think something like this should work:
>
> 	page = alloc_pages_noprof(gfp | __GFP_COMP, order);
> 	if (!page)
> 		return NULL;
> 	err = kpkeys_pgtable_alloc(page);
> 	if (err) {
> 		__free_pages(page, order);
> 		return NULL;
>
> with if (kpkeys_hardened_pgtables_enabled()) folded into
> kpkeys_pgtable_alloc().

I agree this would be less ugly. In fact this is pretty much what this
series did up to RFC v5 (albeit in the ctor/dtor instead of alloc/free).
We could go back to this API, *but* the big issue is that it makes it
impossible to use a smarter allocation strategy for protected pages.
Patch 14 in RFC v6 [1] will give you an idea of what such an allocator
(with support for large blocks and splitting) would look like.

As discussed with David H we're first trying to land this feature
without large block support (fully PTE-mapped direct map), but we do
want to support large blocks eventually [2] and I would prefer the core
API to be already compatible with that objective. Very happy to hear
about suggestions as to how to avoid the explicit condition in
pagetable_alloc() though!

- Kevin

[1]
https://lore.kernel.org/linux-hardening/20260227175518.3728055-15-kevin.brodsky@arm.com/
[2] https://lore.kernel.org/all/aMwd7IJVECEy8mzf@willie-the-truck/

