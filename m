Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D00D9606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 15:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=vkBqVypx
Received: by kanga.kvack.org (Postfix)
	id F0BEF6B00EF; Tue, 17 Nov 2026 10:35:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE3A76B05B0; Tue, 17 Nov 2026 10:35:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E206A6B05B1; Tue, 17 Nov 2026 10:35:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BE7506B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:35:05 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0936F1204C4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:35:05 +0000 (UTC)
X-FDA: 85445009370.22.4FE87F4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id B7A271C0005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:35:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vkBqVypx;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794929703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tK1jKo+NXSEZ02DFpKPmwfErvG5rQo62s0WEa+kB0nA=;
	b=HEO2DPJuoq+bNLZGHB0/YllnaVFWXsxgG1Fj0H9VMZ7/DDIEbWXv80GUGgrIHbHALXdKHf
	IWdOhKKXZkagFQ/bxPurLDb/FBmXP5gM5POqeW/Fq84sNFSvWSOzqZpzLIR7uNUdTEnpJP
	DfoAW0Ajuu5ba/4vtvDHTKUYNaOMegE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794929703;
	b=r7qBl0OMmBPfwa790HZo4A5OVzicRNtkdDP9XYS/Lb6QLzLKBZ36VVsYzfZM9p4Obv6wDY
	D1N//MhblX8aI/c01xdhlutjQhTsei1b3y06SeLoSRp5J9/hZOMVWBWM7xuoMLXNdAH2LX
	hxZWmqEAOrjPLxD4o4uOi6NWF1fqUhc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vkBqVypx;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 897091A00;
	Tue, 17 Nov 2026 07:34:58 -0800 (PST)
Received: from [10.43.16.26] (e126510-lin.lund.arm.com [10.43.16.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C31583F882;
	Tue, 17 Nov 2026 07:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794929701; bh=rP7KiWPD0Id1yjvR0kzV0PUGClLaAk2UzopsCTR8iXY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vkBqVypxWVEK5LoZ7prlEXUs+182UcWbwJNtHajfHxyCB/ZsPtloSqMts21tJ6+14
	 3BALBcz95wEISSjYK0axlgMbpfdE1rEPWnIt/7JN7JQVTHc/TrM7olVQxruDTfiWSI
	 2KG/AKWkrbBf44WJNNml+uDaICPTdOACqGBdM5Lo=
Message-ID: <bdf0cda1-049e-41cc-a2bc-161a36d269aa@arm.com>
Date: Tue, 17 Nov 2026 16:34:52 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v10 20/22] arm64: kpkeys: Enable
 kpkeys_hardened_pgtables support
To: sashiko-reviews@lists.linux.dev
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Ard Biesheuvel <ardb+git@google.com>, Andy Lutomirski <luto@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
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
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org, x86@kernel.org,
 Ira Weiny <iweiny@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
 <20261109-kpkeys-v10-20-aa6c4d9603bc@arm.com>
 <sashiko-outbox-207334@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <sashiko-outbox-207334@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B7A271C0005
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: nuk3xtq6birrgc5wwcqu9xtsjuqg9uh1
X-Rspam-User: 
X-HE-Tag: 1794929702-837759
X-HE-Meta: U2FsdGVkX19z5n7n3Ukupvtl4nevJ9pLOTyQSLubov4+SLRlhECH2LfOaGbVSBO2M7cJX1KmQ0RwOeCl8umjfylqiEnGcJ9Aw2Nt/00gyi8CyIVBSXN+DaXEb+bHkSxhpNTq+N1+5kQ8f2KAvPhhiccqxGKjnpuJ+jZCpW8lsQ3BNXfeoMHf2qVgmyD8G8mJo6s1GNTCMtyx3MRfJYhKj1l6sk7kIYzD8oY3smEVLiW23ZjzgazTvOjVzyN5S3S8QkcK7Ib2JMYwKep56uYiUIRfvII6puklIMCBIW+Q6+xnVRxr+lxvuQOetdfV9Vnl6DNY9bZFVHbtV+a1YlZfi3ARXkX7tWDJXEFblDBjvRjIotQIDDA5mnQwEoxdXmbzXLE5GuCB98iEUa7RBf4xFHKsjHPxSy5acmIpb9FbD9mwh0CcTHBwiH5HaWhHEaczd90GiHMGUOZa1gsYJ5dr9YBMmYzcpBWYOmb/A1HkRBUUyMN+qi7GnRw4te3vborZ6Ivf7Jby7Rxvbek4Ez1XE0fTG1mYeLooFnOmJ9zHTRH0+zgwpuKLzbSJE0GymC5JfgOWigxbYHe+L+UrOxu9WuJpHpHkgjf3sYGTback+dBFXwiXXZ+QT5KphBKUrOUC4jrnL+ULeQ3UUBzW0+ykW1TgQFHUd/VDmi9m+ICIBGWObHCInmTI/KDA9kI6GRg2k5g0GEmOo8f8QxxCnuTAie7+xFsnyfF5AGqOntm+PyI1IklWh9OaWEGnbqa/F8lSvDrmIR3nbLFpaGeZPbAiofWakq+tyjsJmJ5dP0i8cmNqzj0GW6YUcv08ySOeop//yRcIfgl6QKuIcP5FFQMOM0Zl45lu8wUD9hJPd0LesBYRpEKmHQAwgC5R0Nvma4GMmGB2G68ZRcValxZYmASX30pEf1XvQMlQZlOtZHSATgMFlXBZGnPUiDB6EZR+bwhBFd59ZFkNtZMGK6Apb8X
 mpk+yy24
 mcVJlA5JG2ZA8HE0WcM1VQsdrv8gwDk2pHtGTDIdNOudFF3jxZPEVZFIhiZDB2cLpgQNmdLr2xLSoEh8o4a7PEUaTvj292BM8s+i27eBielXFq3SCq12rWWqVPwRZs22jyVKqmhYxyZokGjLETjbDm3lJwV7PMPe9PhVa38Z8hD+37Rk2x7NqB/77TSS8CdxerTlRKxed96xM5ySiFwSzg00XLgG0aG+4iD+GWfbKn4pRuGJ+AW8PbCHO6KDckBQhJ+Ch+1KS7n+cIKrLAzAtFxBA1aii1T9GJ/dwZVUGAsVb+pmJaakY/giMj/dvOQqjg+H/C5u5yFubK7n4LUInLFv8u9i+n737ovcxRS5BLTtYPbGaErdPHfRS7ErHKPnFyEfAc5zKhqdPpBqpUtgIFFE8y182Gde0bIZw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/11/2026 17:02, sashiko-bot@kernel.org wrote:
> [Severity: High]
> Does enabling CONFIG_KPKEYS_HARDENED_PGTABLES cause hibernation resume and
> kexec relocation to fault when writing through the transitional linear map?
>
> When kpkeys_hardened_pgtables is active, linear-map PTEs for page table
> pages carry KPKEYS_PKEY_PGTABLES, which is read-only under POR_EL1_INIT.
> Both swsusp_arch_resume() and machine_kexec_post_load() call
> trans_pgd_create_copy() to build a writable copy of the linear map so
> swsusp_arch_suspend_exit() and arm64_relocate_new_kernel() can overwrite
> existing kernel memory, including page tables:
>
> arch/arm64/mm/trans_pgd.c:copy_pte() {
> 	...
> 		__set_pte(dst_ptep, pte_mkvalid_k(pte_mkwrite_novma(pte)));
> 	...
> }
>
> Neither pte_mkwrite_novma() nor pte_mkvalid_k() clears PTE_PO_IDX_MASK, and
> POR_EL1 remains set to POR_EL1_INIT during the copy.  Any store in
> swsusp_arch_suspend_exit() or arm64_relocate_new_kernel() to a destination
> page that was a page table when trans_pgd_create_copy() ran will trigger a
> fatal synchronous EL1 Permission Overlay fault with DAIF masked.  Clearing
> PTE_PO_IDX_MASK (or setting the default pkey) in copy_pte() would avoid
> preserving the read-only overlay in the transitional page tables.

Confirmed that issue by getting kexec to reuse the running kernel's
physical pages when loading the new image:

$ kexec -l Image -c --mem-min <addr>

where <addr> is the physical address of the running kernel as reported
by /proc/iomem. This causes a crash as some of the static page table
pages in the kernel's data segment are remapped with POIndex 1 when
walking early page tables (patch 13), and the transitional linear map
inherits the POIndex, preventing writes to these pages with the default
value of POR_EL1.

Agreed that clearing the POIndex in copy_pte() is the right thing to do.
We already make all mappings present and writeable; resetting their
POIndex is another required step to ensure the mapped memory can be
written. Higher level tables should be handled in the same way, in case
we protect whole blocks in the future.

- Kevin

