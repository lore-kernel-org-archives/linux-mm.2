Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA19DC44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 15:07:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87EDD6B0093; Tue, 21 Jul 2026 11:07:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82F706B0096; Tue, 21 Jul 2026 11:07:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AC0F6B009B; Tue, 21 Jul 2026 11:07:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 408B06B0093
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:07:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B861F1201DC
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 15:07:39 +0000 (UTC)
X-FDA: 85013113038.28.C3C955A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id DBDAE40009
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 15:07:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RN3uJG0M;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784646458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mM22wXNqV+CNPvkdpjW41Isrw3g8nd8xGQ5BFOB02PI=;
	b=MKvzfm3ndFbGMUR6w+SdLpRhlMWNK7zdaG6jrWydHu18S4MYdqEg/VcHUxtxc/Ef5EI+fk
	ab6SEfQlrZ6bTQFq7OobjVasl3idwEvt3YSmxudwZLSx8Q+29QpURDgWnH6WJpSqcKjiJT
	LilwD9RWQt8KzjXQ24DgV296/3TnRs0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RN3uJG0M;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784646458;
	b=tJsVIqIS2UdLJ2zwfQdJYs+EVS6EuXm+YP5DP8LWyMBcNNjKNX2gh61C7rkBxcvf3acUzL
	+6E3gE6teuXbKncCSWECLyA5J+4V3rWgC6f/5Xiv1n9JZyjHc5JJXnA+muQssday5Bixgx
	whxQb1JxA5f9ncJ8Z9FL0NWA+ssWoCs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F2A9042A16;
	Tue, 21 Jul 2026 15:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A151F000E9;
	Tue, 21 Jul 2026 15:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784646456;
	bh=mM22wXNqV+CNPvkdpjW41Isrw3g8nd8xGQ5BFOB02PI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RN3uJG0MKYkntwW4hxDo3qUFPMhpku3GDnQrJrwqiNxB7yZEM6TnuHnBDCWJO90it
	 02gHwiFiCaHCVJOPhX0VNJDXeMofaa0s0BJ2/Drvm9eVZnTluHf4BI+Ddgb6gKi9KX
	 AzFrBF9yts9UMP5t+O0NQcrIuKnhMfh2wM8Yqn1Ej+X0uuOXq0Q0R28VM7PbeIEvI/
	 m0PhFOrHuwevuAEA7lPzJb1FsAYH0FKc5nvki+6pXx7+QRWF7swgYuqaD1KZSwY/wp
	 LYnK2HBN/1j2D2AqEsFiRRHEoPYFEtsrpUEIWiS6UM1lANNVXU6k4KoJt5clL++S4O
	 +vfed+lG/TEOw==
Message-ID: <0d75daa4-a034-4094-bce5-57938d294163@kernel.org>
Date: Tue, 21 Jul 2026 17:07:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/22] mm: use mm_is_kernel() in generic page table code
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
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
 <20260714-remove_pgtable_cdtor-v1-4-44be8a7685d7@arm.com>
 <02565237-d777-4c63-8b17-817df59feac4@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <02565237-d777-4c63-8b17-817df59feac4@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DBDAE40009
X-Rspamd-Server: rspam01
X-Stat-Signature: iw8bu8xdbzh1u79pm4qt43xnfqopjr1x
X-HE-Tag: 1784646457-260872
X-HE-Meta: U2FsdGVkX18VVGYtAg0qa9+wXZnV6ZsiCDWGBqZqcngis4kTHHrrm6nIW961KIWPmZNfgn/nUIoKMLNdMNm2ZdX/PT6k0iOzm1hD0zDh0oo31KkRz/cY5zxhS2UgRLQTlh21kgChOInlxXjt2iSMZ+p8vYRgdBhNhzwsZF/OcoRnttogTt4UF9wNT6lM94voMRNLGNiN4MEs9sBByw26UZDa4yLz0uyIusgepnqzhcmhbJVAZXXN7aEmPBHVP7QHck2hP4U4Jm21OWxHzyeJFepNI4xFCJdtUqZULl9rvr8Gc+HM2B/WZyHPzJZ5glm9Ka5AkUtXD1R4pvXaMo/KcCxUnUzkulvI5JdrHiVydSnFqH4T2WK2GYld3F/qXZ8VTT1tE/SQQrnbbeQ++zgcmo1U2AylEwVHIsX0Phz8iDAaJ9mUY0fu1U3e608eaXAn5guvC02x/2btyuAnRfQ+FsP6CeeE/Iv8MmCrGj691QmHGVYcddn20yUmfY0QdUeFkQGWO2zRPa8Crw7W1OWl0hJrWhLUonbGaLXUoqrZjWKNfLNHLdjB80X3Bm35rL41qV9lsDQpObOp9AcHHpiRaSjPSCcQdwqGThYyjKF9SUZPE7x0PR6iSrbAItXkvqba0NkjMPtchepZu5osZBvdVBno3OQhPdYXp3GC9C//NPQRljT7jXv9NDoWqgCB41qmwhsLb1ROW1evUHolStrSP8ovKPw05axLqBgha0HXF3PM0x0FCPNV25i306zcnz/XVrAttWROhUpvxdlFt9DBosEKrG4jz9RbgIkRsObjLxZF1AFtibjqOCy6qBsbav2IWF/KOziPcLJInWkrK5bmDaCKSip1GXxSdAlenhlH4xcjWaFf4PBBhhcFpGdZc/zRCTNmMR8ltdcmeSJdvSxH4m9IHkx73UU/TOQqNXO6u+t7OhazoiTXI+EkAxe+oMjCt6q+zOUHLdj+CiegZ/d
 u7bjUVLs
 BNYU5z3YSoz9VSP226eTOUpJ7ZFIZ8P7AWO3Hfu+8VIQg2Om9b4+I6VaFXZAFZrt3wBP3EjAwy3NR0alv2LT1qHpleUmaldWQ7nuRkOn9V2rm8AUtMHg46i6EmWsqdItBi8FM7/DRWWP4AIdcTo5tllCSBVBo7GPTqNste0VC42SpEPf6g11zWF/XhycqgPa38J8XQMfd/gaIRFzAkRhtDV6o8Bchr98BcKDeGEredTcZLhkrKv5Dmdiuwp9m+zFge22dUHuG6ROovunBQYsISIvFe3DCwC0YvGNTI9ZzAQwuv6Otf3ZmINyDir+WfpHjefrkqa33kUEOCRiuFlDbHn1+QW0y5b65Seh5YWIXW2bLrDru14XSlVVnvRPtsar+Ysan
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/16/26 11:35, Kevin Brodsky wrote:
> On 14/07/2026 16:03, Kevin Brodsky wrote:
>> diff --git a/mm/memory.c b/mm/memory.c
>> index d5e87624f692..c0244c0b0756 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -3394,13 +3394,13 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
>>  	spinlock_t *ptl;
>>  
>>  	if (create) {
>> - mapped_pte = pte = (mm == &init_mm) ?
>> + mapped_pte = pte = mm_is_kernel(mm) ?
>>  			pte_alloc_kernel_track(pmd, addr, mask) :
>>  			pte_alloc_map_lock(mm, pmd, addr, &ptl);
> 
> As noted by Sashiko, this is a little problematic because if
> apply_to_page_range() is called on efi_mm, then we will end up with
> __pte_alloc_kernel() taking the init_mm lock, since that's hardcoded.
> 
> That probably means we should pass the mm to __pte_alloc_kernel().

Agreed.

I guess we have to audit all existing init_mm usage?

-- 
Cheers,

David

