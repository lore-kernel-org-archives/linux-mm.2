Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF8DEC43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 13:17:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 888A16B0005; Sun, 12 Jul 2026 09:17:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 812416B0088; Sun, 12 Jul 2026 09:17:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B60C6B008A; Sun, 12 Jul 2026 09:17:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 380796B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 09:17:28 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B668A408CE
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 13:17:27 +0000 (UTC)
X-FDA: 84980176134.30.A1EAF61
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5410420009
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 13:17:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jhlBoNmp;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783862246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=StB1vo6al/Tyq7TQoedlIw1VhPuTVWO8F8r6UHW+pPg=;
	b=D7FD/97jHzgSZvdZzKIwM9Abe7mbiNA/7cFz/T6At82ofNuCszK5nGwJblt5zH+HgwoFKX
	YrnokmPz64h+Pf0CUMH1r1Lbaq6Zy132HSBDDLdjK3+qhsD7cCoTu53PKFnZBhmzUeVgnA
	rbTAX8g1sxFwB3lpwIP6WO1INPauOyc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jhlBoNmp;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783862246;
	b=5wExHInMt648OZM/Njc95HoRo0bEccpDU9LaeMqPIWDKdkYbu+6O2EoIe5bb1ga8kH7vyI
	nNjLLDFGYp69U2iViHsfL1L7hZqR7pXlRrU5SIAzFaywsjlvX2KKsNEZ4ciC2+NmNgQDZO
	dZk1WdsJYIio6MDbX3WxzzirHxud814=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7F7191684;
	Sun, 12 Jul 2026 06:17:19 -0700 (PDT)
Received: from [10.163.128.224] (unknown [10.163.128.224])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 296AC3F85F;
	Sun, 12 Jul 2026 06:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783862243; bh=Hcs/GzepDdIetzHjiaaCoZ2JnUmYACvmukBnUhnWH7o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jhlBoNmp4V+xpb5NnhaUMiVCTOtAElGvdQk7fmpFrcS3v0g3VNy1OuWqR8pPZ36kN
	 Xun5IY8YwezHpllvFoP1/LKdzEH5CvNT0edOT6q7i7+wR+IdF2iMKGDqrG9dMx+IDw
	 FKr3DEZcQp7SsjUU3ircfCWMmXgwcGC/xv4PruhA=
Message-ID: <72e034d9-adcd-4302-93eb-96326846199c@arm.com>
Date: Sun, 12 Jul 2026 18:47:12 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-hotfixes v2 1/4] mm/vmalloc: acquire init_mm lock on
 huge vmap to avoid ptdump UAF
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>
Cc: David Carlier <devnexen@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
 syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
References: <20260712-series-vmap-race-fix-v2-0-ad134cc3a12a@kernel.org>
 <20260712-series-vmap-race-fix-v2-1-ad134cc3a12a@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260712-series-vmap-race-fix-v2-1-ad134cc3a12a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: t5obb98nz43am35yywtof3bcez61coed
X-Rspamd-Queue-Id: 5410420009
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783862245-379510
X-HE-Meta: U2FsdGVkX19TzND0VBY3qlwx5im00s9nDky+yvbZcnJQgF5FS9sbeYYhhGv/P++igaCdI0JyqO6Ca8q4YRfpQRDiugvPyYYt8fqj9vyFZh02me4fHH5F/PvaThR92aaW5nBThEyPUYW1bKzo75Az/LEGVg0z1NnZwTHqTXNcrzsSCehywdILpFEK37pfZibO5HJhyPNECXcMK/+bVMelMBfBWJV/T71VEFh/xVdDfmJiHpcSw2Gt2rTmFJleMO0/9IBYJBeuYc3IWnYIZ55OAlkODuPnfjkbXRGUPqDKB54h1Ly1gXdbZeAdM0p5IJX3wZVJHr20HLNVXxyACy94YQ/DqK+UpLV/6nf5n/Xtb+jApBqXnffLqk1/5vh0mvHQD8CxAKV09qHa/pTc0essQFisKqkIYpcbOVeatCbsjj3Zg7YhIZafpIh6R+ScqxmQVEl2MtwR88QPzUABMY/yLUPQVMJpVfc63uRdTYiMBwZrzcGSsgBzCKvjcL8aW2JEXP1Bq4UbuOAzW8psMZspiemGRuHoz10hM8kXbg9jiusQtuR3ghoqvipsZPf3MgxoM/GM9jfYjSSxoPp9Ux3KYKeg61rvjGOJG3UXY2xL4dvO+knXXBYzmsDPJqjUMlzrYAQaSb2uWNnGoQGEV8onWRNbxxdgvmFL1O8KKg6lw8ptptsqGnHTlaUwa8VSB9FuNXzWbNjZw+V0fJVnnkqLllrz4c9xkYAu8rzI2G7mkVgufptvPoYvJE6hMypRx5T0sEeX5NAFQ0DwDLNsRktSMlG8wgHiNodG5j8w5YYyDLA31sIpP0fGM24zVkmr1H9k+elKW1jK5z9kAgb6WWBRtr/kFZx9RNANmgw+7G4pWUGOkYTfYs+bJLxxqX3uZkZW67ija09Om0FOwHsEahwBBVCKVLQmqJeMphVMrHbHi+yBRQ/nWX8MrgRkAVQEWiOesMinWSGXMFQp2ubPwMY
 IJP2hkSv
 QcKkA+OJvmxDH2vTz9fgqBpOtptB6FPap0bMUgvkNHjPFSDRNuaxTmyRG60k9Z1dzyfA3xxmrVWj6KgsuSVtznFrPaunOeS1NlFK9krN/VruGAsxHdmSU2eMHUUCCPw/LpZsPH4QTO33TakjDkepdLFQ1X3DrHI1BnEOhdsIhj3Vvoo1ao8+SYHXQ+HLjSfQiy+ZMSwDgiOAtEae+uf0xuME4g3DckhI5RNZ52orJXu1Ha75Gtj7WxTXBAEe+BhdRGASubj39NF3dMz/m2sGkcPXsWTBlAUyci7PBqhQEt0ws1SNmg6QWNjRY12a2guGX03xd7Ig8Jp1dksdjYEAkeGnITOjQE7s7zmpCx96IKri9Vs7nMJvWJuXrWT5PiJi3aF5fHBvRNcP/SFVTeMCRZqJOozS4cQVrs9ZJRhjiiY5w7t5cyVlzKvG4OgnUXjc1inC5+/HIqItav1rFT0zhheptZ3f/1hsqHctEwxyc+4BZ93INj7Yai5dEn5gKy7R4hpAdggmG5+SoPDqxvlOPwcrdYZdL88ygYBfJZXSYALGH9lh47xJcI51yovGzazfu24bEsSTLX8PL3vrOpv9W4JjooQvMlWtDrjV2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/07/26 4:12 pm, Lorenzo Stoakes wrote:
> Currently there is a nasty race between ptdump and vmap when attempting to
> map a huge P4D, PMD or PUD entry.
> 
> ptdump is invoked by arch code to walk kernel or EFI page tables, either to
> output it for debugging purposes, or to assert that there are no
> W+X (i.e. executable writable pages) exposed in these ranges.
> 
> The feature is enabled generally via CONFIG_PTDUMP (whose implementation is
> in mm/ptdump.c), and expose a debugfs interface for it if
> CONFIG_PTDUMP_DEBUGFS is defined.
> 
> If CONFIG_PTDUMP is enabled, then /sys/kernel/debug/check_wx_pages is
> enabled which checks kernel ranges to perform the W+X check. If
> CONFIG_DEBUG_WX is enabled, this is done on boot.
> 
> (Note that arm32 implements its own page table walker and uses
> CONFIG_ARM_DEBUG_WX and CONFIG_ARM_PTDUMP_DEBUGFS for this.)
> 
> The EFI implementations vary by architecture, but are not relevant to the
> bug, as the issue is when kernel page ranges are walked.
> 
> ptdump_walk_pgd() holds both the mem hotplug lock and the mmap write lock
> before invoking walk_page_range_debug(), however this runs into an issue
> with vmalloc ranges.
> 
> When vmap maps a P4D, PUD or a PMD sized range and encounters an existing
> P4d/PUD/PMD entry pointing to a PUD/PMD/PTE page table, it invokes
> vmap_try_huge_[p4d,pud,pmd]() to try to convert it to a huge page table
> mapping if possible.
> 
> However, when it does this, it holds no meaningful locks against other
> kernel page table walkers, invoking [p4d,pud,pmd]_free_[pud,pmd,pte]_page()
> which calls pagetable_free() and pagetable_free_kernel() in
> turn (pte_fragment_free() for powerpc).
> 
> This means that a use-after-free becomes possible if the ptdump page table
> walker happens to be walking a PUD, PMD or PTE page table after it has been
> freed.
> 
> Since commit 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page
> tables"), if CONFIG_ASYNC_KERNEL_PGTABLE_FREE is set,
> pagetable_free_kernel() will batch the page table freeing operation,
> otherwise it frees the page table directly.
> 
> While the KASAN report that syzbot highlighted indicated that the issue
> arose in a workqueue introduced by this change, this is coincidental and
> the commit did not alter the race which has existed for quite some time.
> 
> This patch resolves the issue by simply having
> vmap_try_huge_[p4d,pud,pmd]() hold the mmap read lock on init_mm while
> invoking [p4d,pud,pmd]_free_[pud,pmd,pte]_page() and
> [p4d,pud,pmd]_set_huge().
> 
> This way, page table walkers either observe a newly promoted huge
> P4D/PUD/PMD leaf entry or the prior PUD/PMD/PTE entry and never get passed
> a dangling pointer, whether the page is freed asynchronously or not.
> 
> All other kernel page table walkers that touch vmalloc ranges either
> exclusively own the memory walked or acquire the mmap lock, so this
> correctly excludes those walkers.
> 
> We acquire the mmap read lock as a trylock, as this is an optimisation that
> is permitted not to succeed, a race is very unlikely, and doing so
> eliminates latency sleeping on the lock would have otherwise caused.
> 
> We also define a guard class for mmap_read_trylock() so we can use
> cleanup.h to make the scope handling cleaner in the implementation.
> 
> One wrinkle here is commit fa93b45fd397 ("arm64: Enable vmalloc-huge with
> ptdump"), which addresses the issue for arm64 only by explicitly acquiring
> the mmap read lock on kernel page table freeing should a concurrent ptdump
> be in progress.
> 
> This is problematic as vmap may acquire the mmap read lock prior to ptdump
> attempting to acquire an mmap write lock, leading to a deadlock when the
> mmap read lock is slept upon on page table freeing due to rwsem
> anti-starvation.
> 
> We work around this by predicating the mmap lock being taken on
> !CONFIG_ARM64 for the time being.
> 
> With this patch applied, a follow up will partially revert commit
> fa93b45fd397 ("arm64: Enable vmalloc-huge with ptdump") and at that stage
> remove the arm64 ifdeffery.
> 
> We also update walk_page_range_debug() to assert the mmap write lock
> unconditionally and update the comment here to reflect this change.
> 
> The issue has existed as long as ptdump was available and vmap freed page
> tables when promoting to a huge leaf entry, that is, since commit
> b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page table") for
> huge ioremap, and commit 121e6f3258fe ("mm/vmalloc: hugepage vmalloc
> mappings") for huge vmalloc.
> 
> Since the former is the earlier of the two we choose that for our Fixes
> tag.
> 
> This patch is based on work by David Carlier (linked), with gratitude!
> 
> Fixes: b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page table")
> Cc: stable@vger.kernel.org
> Reported-by: syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/6a287988.39669fcc.33b062.00a0.GAE@google.com/T/
> Link: https://lore.kernel.org/linux-mm/20260706203128.162335-1-devnexen@gmail.com/
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
Reviewed-by: Dev Jain <dev.jain@arm.com>



