Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40AD2C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 15:07:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BA636B00A9; Wed, 15 Jul 2026 11:07:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 197976B00AE; Wed, 15 Jul 2026 11:07:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A8496B00B2; Wed, 15 Jul 2026 11:07:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB9DE6B00A9
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:07:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3E6551401F8
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 15:07:21 +0000 (UTC)
X-FDA: 84991339482.17.4214A57
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3B035C000C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 15:07:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Z5zyq2Hj;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784128039;
	b=cTsiSdchEZqFw1qCngEwUThWBf5NZSLyckS98fBBhMsh1JOrrpjdIPP5dt03h4mgXqH10l
	xHrnge/zdjdKKR+ISPwUbDxww+e2Q+kImMtmKkAu5t4V2TOHsX9XFSQ5pzDgHAnzf+1soT
	4FPDjvEGUm58pkYIhSiHDNsRN4jCJLg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Z5zyq2Hj;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784128039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b+Lely55X0Poz5EPTNuVktiWM0m4hYPrz5LTi63N+F4=;
	b=xnZz3zLfyZjspZbSu7piLWFlKSnj/AdKeWUi5gitWIeZbP49Gdi1JHT3ohfCMkJ0rwab9x
	4Y4x2rnaBXbG437hYteJQDcfk6t4Ny/H5xYN8FEXTcioHxZoPVU1QIt2MJNp65gOWuH4ay
	8NxFNiAmkrNVY00GGq4CybNgQ3T5gf0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9F6BE152B;
	Wed, 15 Jul 2026 08:07:13 -0700 (PDT)
Received: from [10.57.82.220] (unknown [10.57.82.220])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 28E1B3F905;
	Wed, 15 Jul 2026 08:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784128037; bh=+jFMWWv220aZ8z/A3E0zhi9BB4H/u0SqqJRjY/UOWiM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Z5zyq2HjC1J3H+2sS3zu5v1h+CSpo+X2JamGTGR0pKplJ+iyMq9LehKG+jacWhbPZ
	 WPUxV70PTchy+e9ITMIQB1lc3Qrkdac2O7M9gEkdlvEpppy6u5k2BxIx/dsQ5U+PV6
	 B4YDMFmLqLte+c5rOhprH1XGuK2zbmrCTYOVdNc8=
Message-ID: <6d167aaa-e9b0-4687-970c-1c67d0df6344@arm.com>
Date: Wed, 15 Jul 2026 17:07:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/22] Simplify special kernel page table handling
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org,
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, linux-s390@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org,
 Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>, linux-um@lists.infradead.org,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Ning Sun <ning.sun@intel.com>,
 x86@kernel.org, tboot-devel@lists.sourceforge.net,
 Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org,
 Vishal Moola <vishal.moola@gmail.com>, Alistair Popple <apopple@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3B035C000C
X-Rspam-User: 
X-Stat-Signature: au8g5ayz3q3pz79cxd5u8os7acbzt5ub
X-Rspamd-Server: rspam03
X-HE-Tag: 1784128039-604581
X-HE-Meta: U2FsdGVkX1+JTlyqmRxzG/i2/sH8BAnJeGuaeXIxcqXkJSf0FCuSz+/33jidiTgfb3Xztrjrx6gbVMNI2TJuqKzsXBUev/vC7mw2Nw4+wSS6Sz26vn2DdXfhfkOoLFUSZEb6fDGhLLNfx98Tct+/58ignbnuC+rH1K4bMa2nXuI6gsPwQiB2Kytx4pU5mY+y4CVi+dqVaDTixhvRQNDc2NMKwQttf/LpwpqfagQBVXbQ0nWAKO5ntAxS3sCIzOkSoNsc7ASqrzr+NKljNc5ewXalVbmd8xFcYxbXUab0haZs9gYy5OwEm3zx/tPFD7nG+Qebej7/ujcWqRAAdUBWosF8MRRFg0r6zecNTOiO8Qoui2XMINBhd5HKlWAI4kN7ZP5/z4UIfNWc8L/JLFlswxM942zoajSW71X1RvZxcy3LgO4VeueiSJplr75icp0/jeEbOF+seSl1l2O1srfN0o5rtZyOANYHoql2OVujEcUL1DECv6v/C3dWmXT3sXcTW5veysv+Ryh0n4b1gAj8b0eW4mMqjAwrr8zjTVW2DzFEUP4gE/kJs7qCfTBxZOoT8OZXnuTjyJ/JjYyWGGVJ1hG+YUzglUJOxq/0e4Wc6gdEIztIsnbAhKx1Ey2DNVMvs4vQXrewGwRH6Ikzsl9jEJnzS7cIOTRPeatNr2e7UkGOYVecrIfCBnjSAQtQyJivk2FqvQF7wVBHIuWHzJsoEOeVWI9qnICxfOrjtIsDgwvQ0aVprpvBRbUUMtBvXlcxz8YXBJv7PFHoseycgYbAQaj2VPZkcGbpttnEst+W0T9hDJp3TPRIGQ32KRljn01/PJP/rymqXV0bJJZclcxtx2qS2mUyeHhKhRTTtxiQO+4gzDMT60uP9i6MHS9uzKCeghqNFYxtFDNjwl10Dfp/HEd+BxdkG0RbNKqCuVZokPI23wuSKTOJmM2i64HM73dWL1t8p/ReuRYTq7SrpkX
 mAijVbAF
 Kc/GUDdB/mm9NNuPW6uD3HR5Jx/qK0KDdCICaVCVbOTq6LP2h6aceoObITy5S05acQOuavG4kCJ3gRmyHow4dCsC9NQQ8MN9MeFbZiMitD3StFpCpbfhLpK39jrflind0zLjWNFlnO65seOqpcz8dIwA36K/CdCBEH0dFzEUf+fc0NxKaynbVLYaA2VeFnxDDhgP0hHomOsna3YNperX2/zqtqBE4hTdui/YJzhfavog6Ep/Qkubge2ToKxibVwkrx4ub5C8tCaw00DQIAvyJMBY3H++gQPwwE7tkeBhYFmBg065L52GiFjRHpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14/07/2026 16:03, Kevin Brodsky wrote:
> Page table constructors and destructors were originally introduced
> specifically for user PTE pages. Over time, their use became more
> widespread, and starting from v6.16 they are called at all levels
> and for both user and kernel page tables [1]. Or so I thought. Turns
> out, we still have various special kernel page tables where the
> ctor/dtor are not called; vmemmap page tables is one such case.
>
> Looking closer, we do not actually need per-level ctors for kernel
> page tables. In fact we do not need ctors for them at all, because
> nothing is specific to kernel page tables in the ctor/dtor and
> nowadays they should be allocated with pagetable_alloc().
>
> Here's the plan: all the generic page table handling moves to
> pagetable_{alloc,free}(). Whatever is left is specific to user page
> tables; the ctor/dtor are only called for user page tables at the
> required levels (PTE/PMD), and renamed to make that clear.
>
> Doing this will allow us to remove a good amount of special casing,
> but there's quite a bit of churn to get there. Here's what this
> series does:
>
> 1. Introduce the concept of "kernel mm" and replace most comparisons
>    with &init_mm with a flag check (patch 1-12); no functional change
>    so far.
>
> 2. Move the page table accounting/type setting to pagetable_{alloc,free}
>    (patch 13-15). Kernel mm's do not need to call the ctor/dtor any
>    more.

The underlying assumption here is that pagetable_{alloc,free} are used
wherever the ctor/dtor are called, and as Sashiko pointed out there are
counterexamples:

1. sparc32 calls the ctor/dtor for user PTE pages, but uses a custom
allocator.

2. archs that do not select MMU_GATHER_TABLE_FREE do not use
pagetable_free() in tlb_remove_table().

3. arch_remove_memory() and vmemmap_free() are a bit of a mess - some
archs call the dtor and/or use pagetable_free() for freeing the direct
map page tables, some don't.

How I'm thinking to address these:

1. sparc32 does not use split ptlocks, so maybe doing the memory
accounting explicitly? Otherwise, we may need to keep the page type
handling + memory accounting in a separate helper that sparc32 can
explicitly call.

2. Always enable MMU_GATHER_TABLE_FREE. pagetable_free() should always
be used for pages allocated with pagetable_alloc().

3. Go through all the implementations of memory hotplug and vmemmap, and
ensure that pagetable_free() is used for those pages allocated with
pagetable_free() (and only those). That may well call for a separate series.

- Kevin

