Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E7D3FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 14:47:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 572936B0098; Wed, 29 Apr 2026 10:47:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FB146B009D; Wed, 29 Apr 2026 10:47:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EB816B00A3; Wed, 29 Apr 2026 10:47:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 289896B0098
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:47:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AB0FBA02EC
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:47:18 +0000 (UTC)
X-FDA: 84711871356.08.136E3AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 893C3100011
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:47:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pN74wno3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777474036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BOKe62HEKKKWgBcjnuqJwjaBz64blRZ88qadx/8RQEg=;
	b=nhK83Rvilyorms9xlA4vpb0xYduTCq3qOMGYsRg3cRKenKPiWj2GBCEp5+kNkbMOZegbK7
	tZ2PWug3Oj3+ijxDtWrIWGzpOwZfqlckjpRoB91XRNcyzq/JpHMGRefOYOQJo+9dcj7ALo
	7/FTVLO0U2EKVyeU+w4EolSKoKsZ+xA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777474036; a=rsa-sha256;
	cv=none;
	b=qRLuLQJadeHoJppNZLQPuJLGtepzjP9S/OSMfaexhCO887Fvuc7P/a8843m9Ikm9JSxLNN
	xFHYadZO7Rjghnk7v1zbjpV/VkXBFN6Pp860+14hfq+xF8YbNuSZ3/hRdqjpwpm9qbERJG
	nu1JY31I6qRJYiIlbNWx+MZ5F0DULwA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pN74wno3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 928AB419C1;
	Wed, 29 Apr 2026 14:47:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01EE8C4AF0B;
	Wed, 29 Apr 2026 14:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474035;
	bh=7Z35J/ZrfKtRqAQn9Q7Ex+MS9IkQxmcfqwce4UOcZcE=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=pN74wno3T4T6KJdd64tkp31Q7DAQwW2YK1pEmLzaAkq9VGqlb3DOzwq1MdKxYxQYS
	 hdzp0osC0QmRjfCoViwi9+1aNelz9YdkOkY9Hh8hxaz1oiCO+Cm0S7rxGZI/T8aPUH
	 NiQ975nzmPLNNjG1ADiF6SKwkfdqHovXw2O4BzwC7+SCMuoCH7DGdIHha4XYTATWZe
	 lJvAoe+Ql8GWdLQa3eIHz1LZ5xYYWbHWWYaDEeN/alvj7LqtqMbEkPg/aqevGj0xca
	 8MMv7YwaZOYRQjIfZy6ota1FpgDHOEH4Nc1pcO0iJ+SAolEciPWES3IbHeLC/V5P3h
	 JiMxGdRJFtS8Q==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id F22C5F40071;
	Wed, 29 Apr 2026 10:47:13 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Wed, 29 Apr 2026 10:47:14 -0400
X-ME-Sender: <xms:8RnyadBBxdrHCM7yqLvYcm18trsy8qo2fJZIqXxK9lwhXEP70yCBbQ>
    <xme:8RnyaWW5bEY2lce2uVwjp760NyAziTK_0kTYol5NL_8QzOxJ2OwS6_WbQZEg7M1vY
    tEKbwOpWsUfB2729bjsD92wuVo4JacFSCigIJBo0bw8GXnsgmjys5xE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdekgeejvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhguuceu
    ihgvshhhvghuvhgvlhdfuceorghruggssehkvghrnhgvlhdrohhrgheqnecuggftrfgrth
    htvghrnhepvdeuheeitdevtdelkeduudetgffftdelteefteevjeevjeeiheefhfejieej
    fedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrugdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeijedthedttdejledq
    feefvdduieegudehqdgrrhgusgeppehkvghrnhgvlhdrohhrghesfihorhhkohhfrghrug
    drtghomhdpnhgspghrtghpthhtohepudejpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrnhhshhhumhgrnhdrkhhhrghnughurghlsegrrhhmrdgtohhmpdhrtghpthhtoh
    eptggrthgrlhhinhdrmhgrrhhinhgrshesrghrmhdrtghomhdprhgtphhtthhopehkvghv
    ihhnrdgsrhhoughskhihsegrrhhmrdgtohhmpdhrtghpthhtohepmhgrrhhkrdhruhhtlh
    grnhgusegrrhhmrdgtohhmpdhrtghpthhtoheprhihrghnrdhrohgsvghrthhssegrrhhm
    rdgtohhmpdhrtghpthhtoheprghruggsodhgihhtsehgohhoghhlvgdrtghomhdprhgtph
    htthhopehlihiiphhruhgtkhgrsehgohhoghhlvgdrtghomhdprhgtphhtthhopehsvght
    hhhjvghnkhhinhhssehgohhoghhlvgdrtghomhdprhgtphhtthhopegurghvihgusehkvg
    hrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:8RnyacDCA-_xULqEbSEn6qUEKIfcqZmZMgD2vngfLOCaS-7bnXJy8g>
    <xmx:8Rnyaa01FNwVKS3EliWzZ4mey9F9CoOOYXIkrMVxN53h6Bqg3olQpA>
    <xmx:8RnyaRPrRRhxHtTOFw9QjLScU1rhydSF0AulCpbyxA3vqnv-EvzdxA>
    <xmx:8Rnyaf7nwJ9jaH5184hz3DwfsV7DwAGLoAEpEkqmdhAD1e2WLmyo7A>
    <xmx:8RnyaWaXmjpCpPsayF2cXuU48fUOtfHGVFHUoo9an_HSWgc9Do6qSxqP>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id CEE11700065; Wed, 29 Apr 2026 10:47:13 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
Date: Wed, 29 Apr 2026 16:46:53 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Kevin Brodsky" <kevin.brodsky@arm.com>,
 "Ard Biesheuvel" <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, "Will Deacon" <will@kernel.org>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Mark Rutland" <mark.rutland@arm.com>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Anshuman Khandual" <anshuman.khandual@arm.com>,
 "Liz Prucka" <lizprucka@google.com>, "Seth Jenkins" <sethjenkins@google.com>,
 "Kees Cook" <kees@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "David Hildenbrand" <david@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-hardening@vger.kernel.org
Message-Id: <9ff1d19d-f3f8-4106-aeeb-66c4c21742b9@app.fastmail.com>
In-Reply-To: <a8740f95-e167-48ae-ae65-97c6701d9c94@arm.com>
References: <20260427153416.2103979-17-ardb+git@google.com>
 <20260427153416.2103979-29-ardb+git@google.com>
 <a8740f95-e167-48ae-ae65-97c6701d9c94@arm.com>
Subject: Re: [PATCH v4 12/15] arm64: mm: Map the kernel data/bss read-only in the
 linear map
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 893C3100011
X-Stat-Signature: oycaa9jwyj36z8m6zzdw4e1pmhkofik9
X-Rspam-User: 
X-HE-Tag: 1777474036-628153
X-HE-Meta: U2FsdGVkX1/dylvJNVPxREThwqxpzMehMkQaMxdkEhlsFWPtl4HNJcFDL79duPLeUUeKbIACKTsqzuja8IJIB9T7bUYCwxxTWKv1WsOy6IXvRnd3hz90jgH/j7uk2kXk4BeKHiftihlQQ3vLxhStqYS6b/TJuhKGxA6v9nClhjc+oYHXzHahVk/xZ8PPWzCIhCMpXQm4dPtB9kMTtULT4wJkz+f8rt7TNxra5uW26t6XLmcqFDTmtP8n49VsX9Q6891llw8i+uxbOz/bG7tizYQhCbT6HWe1r6jZY0HMCWmMuFrwC2mhthxFzkjS4q7daELtTo1hdxUKSBZEfbyp1l1m2dg2xfJC5dOOiWVT/dU5fjG75Fg/h1D3UzvozTB6gVxZ835Fl/YicMrjlFI88MxRB37wwd6nIAt0P6VFa4AjqKuY6gTTd5G9KJ/aS0z+1O7GWm6Z5hVia7UA0c26Whh/mU3Cd3lii2cJf0FHFhZTvUUedfea28ylajkGifvDNHKPPaHc7d7Y9CZwgvN9GSXPhYDQf0Au8CP/nD6qIpP+2mwbIt3DddJJH2v6f7UhEy4sYRW0pNu7KpWlACT8WZ6t6t6AUeIfRW1qedtFDYmb0RgCL1oneCXD6b3cTVUN0l3ZHcRyESbCKdj6BeJQ9W1HlqK+7zqG2tzdDpqIAR2VaZJpJZtf3EHgb2vC5BklI5PECL1r7NDGy6Cw022mZDhq+9noK/9TDVgLKMLQu7v7JAanuW5GVkwTPsI/htxNLwgmfsTqQi5qLhSUxc33tHXcaOikxXmoP81EGzJiPR3IBKlogiER4Hr6g3qVbyJY/lZFfuoPDxeek9ummEo6Uv/YUIhObA9aSF3wm8rX7p/Q/mwJSHnwjZwSgChr4PJe6+nARloLi93zAmrUuVhPpo6ETYvflgYyQk7Q5mLVnjYOq57hjgFa1pY20EeAA10KVgfV2q6euEj13L6LKue
 8ctNjeh7
 CocnI1s7APR9PGIh+UY7koXo62xVcLgzCgh1s3cqAO0E8bMOloW/CltHtwdA41zG/SbYY/3OHJDEe/LTk3D98XmVDfdi1SuGRj4lnpKHDBRPrveBkZYnotIbW5Dtk4T3FrWrUClicwX6blu6Xne+qsBHADi0P7S7RQLTup07EbK0U2CcV5U27wnRd8TSiwXrfJrVHzG8joG3tdhsLkyxIR9EE/b20/tMvAKHl1btJMFUlZm2db+yeBhmLwd6VlFZtw9jUqrQwMHD8yc6vT7a6iType1+GoQ0gks6kmBa/VdXKPmU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Wed, 29 Apr 2026, at 15:54, Kevin Brodsky wrote:
> On 27/04/2026 17:34, Ard Biesheuvel wrote:
>> From: Ard Biesheuvel <ardb@kernel.org>
>>
>> On systems where the bootloader adheres to the original arm64 boot
>> protocol, the placement of the kernel in the physical address space is
>> highly predictable, and this makes the placement of its linear alias in
>> the kernel virtual address space equally predictable, given the lack of
>> randomization of the linear map.
>>
>> The linear aliases of the kernel text and rodata regions are already
>> mapped read-only, but the kernel data and bss are mapped read-write in
>> this region. This is not needed, so map them read-only as well.
>>
>> Note that the statically allocated kernel page tables do need to be
>> modifiable via the linear map, so leave these mapped read-write.
>>
>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>> ---
>>  arch/arm64/include/asm/sections.h |  1 +
>>  arch/arm64/mm/mmu.c               | 16 ++++++++++++++--
>>  2 files changed, 15 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/sections.h
>> index 51b0d594239e..32ec21af0823 100644
>> --- a/arch/arm64/include/asm/sections.h
>> +++ b/arch/arm64/include/asm/sections.h
>> @@ -23,6 +23,7 @@ extern char __irqentry_text_start[], __irqentry_text_end[];
>>  extern char __mmuoff_data_start[], __mmuoff_data_end[];
>>  extern char __entry_tramp_text_start[], __entry_tramp_text_end[];
>>  extern char __relocate_new_kernel_start[], __relocate_new_kernel_end[];
>> +extern char __fixmap_pgdir_start[];
>>  
>>  static inline size_t entry_tramp_text_size(void)
>>  {
>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>> index 1a4b4337d29a..9361b7efb848 100644
>> --- a/arch/arm64/mm/mmu.c
>> +++ b/arch/arm64/mm/mmu.c
>> @@ -1122,7 +1122,9 @@ static void __init map_mem(void)
>>  {
>>  	static const u64 direct_map_end = _PAGE_END(VA_BITS_MIN);
>>  	phys_addr_t kernel_start = __pa_symbol(_text);
>> -	phys_addr_t kernel_end = __pa_symbol(__init_begin);
>> +	phys_addr_t init_begin = __pa_symbol(__init_begin);
>> +	phys_addr_t init_end = __pa_symbol(__init_end);
>> +	phys_addr_t kernel_end = __pa_symbol(__fixmap_pgdir_start);
>
> Using fixmap_pgdir as an anchor seems a bit arbitrary... Couldn't we use
> __bss_end instead?
>
> It could also be helpful to add comments in vmlinux.lds.S clarifying
> which sections are RO/RW in the linear map, it's getting pretty
> difficult to follow.
>

Ack.

>>  	phys_addr_t start, end;
>>  	int flags = NO_EXEC_MAPPINGS;
>>  	u64 i;
>> @@ -1155,7 +1157,11 @@ static void __init map_mem(void)
>>  	 * of the region accessible to subsystems such as hibernate,
>>  	 * but protects it from inadvertent modification or execution.
>>  	 */
>> -	__map_memblock(kernel_start, kernel_end, pgprot_tagged(PAGE_KERNEL),
>> +	__map_memblock(kernel_start, init_begin, pgprot_tagged(PAGE_KERNEL),
>> +		       flags);
>> +
>> +	/* Map the kernel data/bss so it can be remapped later */
>> +	__map_memblock(init_end, kernel_end, pgprot_tagged(PAGE_KERNEL),
>
> Maybe I'm missing something obvious, but considering patch 3/4 couldn't
> we directly map the range RO here?
>

After 3/4, __map_memblock() will no longer combine new mappings with existing
ones into block mappings or contiguous ranges. However, it will still set the
requested type and permission attributes on the entire range, and so the second
invocation is needed to restore the read-only bit.

IOW, we could also map it read-only twice, the result would be the same, but the
second call is still needed.


