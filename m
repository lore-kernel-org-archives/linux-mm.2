Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48EC5C624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 15:34:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C7666B0098; Mon, 31 Aug 2026 11:34:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3522E6B0099; Mon, 31 Aug 2026 11:34:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 219CD6B009B; Mon, 31 Aug 2026 11:34:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8FE16B0098
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:34:01 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6996FA329C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:34:01 +0000 (UTC)
X-FDA: 85161960282.23.8DB8DCD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7C0F120008
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:33:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MFHLjXqz;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788190439;
	b=iVH0gyepMqj0ulNnDICLBgihGO0mr+b20QSXqbavmsUc+Bdp+WsVBmskPXcPlZE/ykZ2Ef
	Z5uIIVq/Ob2kAvVNRSMGxS4ZOtifgetwCaxWHiiDdhwy6bTU++PDbeOZ1ubg9bUK6ltF0S
	yz5qhTLR80rQBZjBGAJemsaNXOOBVZI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MFHLjXqz;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788190439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ExJGhlK8NZ9qSQmWeTV2cgX53bPWaT0Asusz7G6mkI8=;
	b=wr5Ypj4629fWAu/DOVYcj1dhGhbUO9PVK2E06pxnN4G0RW1lDEkI7dHmkJbSfVwbeMMKfB
	34gDkx53CU2ZqUQ08Se6sfUqNgQ1eERl6/7/wv6JCJX+NYlGpaDpWCqgtAIZ9VzJjzlJ+O
	+diB96NDF6FTak5m4UjTUZrGxu4zr6I=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CEB5214BF;
	Mon, 31 Aug 2026 08:33:54 -0700 (PDT)
Received: from [10.57.6.141] (unknown [10.57.6.141])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E05EF3F882;
	Mon, 31 Aug 2026 08:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788190438; bh=X9z6SyVZHNkQL1n6gdutBmZdrQmfESATqJ8v2NavtB4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MFHLjXqzK8YmsGP1D4zZK3RcXzt2oW9+8hlLXOvoV0Fn7AylvgVVKPoBc1U9jHEyU
	 Hg6K/c9dkeMJae718osmui/zp5HMLFDPQccfKI7Zo1sw1M4gobE+XIk7REGXMxLyVl
	 Uvx2AXIqqX+6lvDZTDPUgRGau8g2gMv80e87vdOY=
Message-ID: <51e7acb3-43e4-409e-84ef-d932495d356e@arm.com>
Date: Mon, 31 Aug 2026 17:33:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v9 14/25] mm: kpkeys: Protect vmemmap page tables
To: linux-hardening@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
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
 <20260818-kpkeys-v9-14-743ad31b2c8f@arm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260818-kpkeys-v9-14-743ad31b2c8f@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: dnz6yp6dr8cwa9dkdxgjpq1iqz64o7ih
X-Rspamd-Queue-Id: 7C0F120008
X-Rspamd-Server: rspam06
X-HE-Tag: 1788190439-767975
X-HE-Meta: U2FsdGVkX18yV+v3wBu/jsqZajc4o/noJRpYwnJnVtCEUfsXuZlOSeV776cpejEv8ht/m2ll0oSwajRk/xET0k17ao4izR39lVOaz0IWvKr8P0G5J5QmcfVaqyxVot1P4qgfm5aUWOPjs6L7S2vWJTjH5QVIAs6hQ+3w/rhO/Od7my6dlSWbSikmqOBWUBJn+Za68cM/MVitFXy065jtBesSKbb1/ab21L5XbzjLEuRAe7tNBYfnnVjgw55yJ5qpwpk/TyiwCK5gLipO7EV9Isg6QzA9BRihxkSG9nrWYW/E8CYB6lp7vzKaKeMaTcn8mKXVoIvteXdI9v1Lr0SLD31LKhjOg8+A2JNYaE3bwXvR7VIi45ia+gxP7cgXqlZWLsaMkOMdBqU2cRZvtiBn9RX76gUFU/LSl/phqqZqMNnWnTUFoKACqOSjKtUp6e0d8buRJP/nk6ydj7bCGXcUy3suDuEz5uWfd17RygUOARs5WC18r0wHAwdLk2nr9OyDce1Dr7dHvOzSwmTUri0deDryz+RspwAuDiWb+WSdtOFWklFFdmLvDDIwYtulTP/YruZNNPSLUTfUYtAb/f2BDI/xfCJ75eiWUgS77NhaDFzlnltAHd5DhMPwkF0W22fjWBRtC8DqifGNZb0nEBFp+EiAuDIdl4hn387a5VhEp61AJKOInEshq8BnFlCFZyx5h8MPXnWcOqn2L76nOBhskZQXEzTkoZ8+Tl9VtIIbVTrNOAaRcXp9spavoxkxgu2uIn1YZvpT8vL7bwDp1sYylu2o2W59qkU66ACzZd8gt8PzewnDLHuV6jUFJvgoXEB09cl+gBQUPGeZ+XVubBcFGnzIpLW4vKDVmQYujxqH/aWUj9gwQp99d3bpbZegFxFXPXG0fBwTGB3wjGTM/J6JS6S4gxbwJ5M5h67BkjpPnA/nkbghnS53tNcTiUMgQdCqtH2SYt5ttCS6RWvrFUa
 89PE/vgs
 OF+Wx7sD8NDM6wcye/XRc8YWUcme8l6EhAO/O0FwlzE3GowHbQMW6QTpKIx4XRGvF4NEnVQc1iTE6LXkokri+LQtrQq/de5O8nqearCKccwSTESjgspmwJ6EsbKSY3sIi9HKF3yshHVadQ4WPMImP+cWBTnlAUipIMV5yi7sXSbwBsPIUV7DivJxdJjZRS4y4H0Y8+y9Kee/DA6iJg8SqS7hDoR8lRkSb5ZIk5ZXqpwHY9Z0jK7E4q0m8KALKhrWAQNxpzVh3mkn7n8AWx1vv+hhDvhmZz/Mjag157GmD9JlEC2Or5iLiqUWrqgj+KbFu4wq7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18/08/2026 16:08, Kevin Brodsky wrote:
> When the kpkeys_hardened_pgtables feature is enabled, make sure that
> vmemmap page tables are protected by using:
>
> * The standard pagetable_alloc() if the buddy allocator is
>   available, as it already allocates protected memory.
>
> * The memblock-based kpkeys allocator for early allocations.
>
> These allocators are not NUMA-aware, so the page tables may be
> allocated on any node. This could potentially incur some overhead on
> large NUMA systems.
>
> The arm64 hotplug code is also amended to use a matching
> pagetable_free(), ensuring that the pkey is reset when the page
> tables are freed. x86 already uses pagetable_free() on that path.
>
> Unlike in vmemmap_alloc_block(), __GFP_RETRY_MAYFAIL is not used as
> it isn't justified for allocating page tables - this disables the
> OOM and we do not have a fallback if we fail to allocate page
> tables. See previous discussion linked below.
>
> Link: https://lore.kernel.org/all/38d2a358-4146-bfc9-2a4f-68ce02f75c94@suse.cz/
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>
> This is a minimal patch to protect vmemmmap page tables. More work
> may be needed here:

Another issue that my friendly AI identified: using
kpkeys_physmem_pgtable_alloc() for vmemmap breaks the main assumption in
the previous patch, which is that those early page table pages are
contiguous. vmemmap backing pages and the PTPs that map them are
allocated serially, which means that we end up scattering vmemmap PTPs
in the middle of vmemmap backing pages. As a result we could run out of
space to track the early ranges to protect.

This was much less of an issue in RFC v6 [1] as early PTPs were
allocated in PMD-sized chunks. This removed most of the fragmentation
and allowed us to track all these early ranges without extra logic.

That said, allocating these pages in blocks adds complexity that isn't
really justified when we require the direct map to be PTE-mapped.
Considering David's comments on patch 13, the plan for the next version
[2] is instead to revert to the even earlier approach of walking all the
kernel page tables during early boot. This simplifies the whole series,
but it will need to be overhauled when we try to support block mappings
again.

- Kevin

[1]
https://lore.kernel.org/all/20260227175518.3728055-19-kevin.brodsky@arm.com/
[2]
https://lore.kernel.org/all/7af32e98-f2ab-4961-9e3c-72b8a21416c0@arm.com/

