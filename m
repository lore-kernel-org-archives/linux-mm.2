Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C688CC9830D
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 03:28:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 599516B008A; Wed, 23 Sep 2026 23:28:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54A326B008C; Wed, 23 Sep 2026 23:28:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 438416B0092; Wed, 23 Sep 2026 23:28:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 16D8A6B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:28:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E57641201E1
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:28:31 +0000 (UTC)
X-FDA: 85247223222.21.E0ED947
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0F66280005
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:28:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SqLjLK9Z;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790220509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CU0OqDp6nwpS3D+8EJdb+ofEYYwhoXq3LClu7tPE0EE=;
	b=zqQ1EQD80io6QLEUDxwHx+DpMLS/SqZYqvMaZWZxg4LhLozLYpMAyTrZx8AypZ1n5p/ZsQ
	dLNfHCzzZprKAUXZdA01LGHnWSZ+sMTdPtWChD7FLJNbNC5DW3hKfdwemdFtOSXyHJG/lv
	IxMTBR89dBoKF05n5+GvYcUPm2WhL/M=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SqLjLK9Z;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790220509;
	b=uIkgnPLNZXJJ3ICzIYWfWvPtLzQG68RZRoNrWDvVtyZ9TH0u/eDkwA+JNlggpxsI2p78/4
	H+ghLKXw0vTD2dIxmpdg4m8o5YI9vYbbOmkz/8iCvyku5sx+gTNA35YGGPqOEev0RLYVOj
	2OuESLdc7+JQ8At3u3flPCfj7w7Agng=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790220505; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=CU0OqDp6nwpS3D+8EJdb+ofEYYwhoXq3LClu7tPE0EE=;
	b=SqLjLK9Z0Wcr2L9izXx6BcMCftVz6arbpvsMM1LRQtH4jCMYVJElcIlXDevor+hKlvY+EAjegv+QH6gGuEgIlQRD5ahSiL8Hk2/8Uui0osNWt5u7VNpn2EpeV+DGHBeCsnmIgOScTZQuQRKWk0gdu+llY7A27WTkJZQMNe8r89k=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R591e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=98;SR=0;TI=SMTPD_---0XBYP0rj_1790220500;
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XBYP0rj_1790220500 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 24 Sep 2026 11:28:21 +0800
Message-ID: <bd6c18af-68dc-4565-a2e3-04dd21e7ea3a@linux.alibaba.com>
Date: Thu, 24 Sep 2026 11:28:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/12] mm/khugepaged: deposit a newly allocated page
 table on collapse
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Guo Ren <guoren@kernel.org>, Brian Cain <bcain@kernel.org>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Dinh Nguyen
 <dinguyen@kernel.org>, Simon Schuster <schuster.simon@siemens-energy.com>,
 Jonas Bonn <jonas@southpole.se>,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 Stafford Horne <shorne@gmail.com>, Rich Felker <dalias@libc.org>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Russell King <linux@armlinux.org.uk>, Vineet Gupta <vgupta@kernel.org>,
 Michal Simek <monstr@monstr.eu>, Chris Zankel <chris@zankel.net>,
 Max Filippov <jcmvbkbc@gmail.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>, Thomas Gleixner
 <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Arnd Bergmann <arnd@arndb.de>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Yoshinori Sato <ysato@users.sourceforge.jp>,
 Shakeel Butt <shakeel.butt@linux.dev>, Jonathan Corbet <corbet@lwn.net>,
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
 linux-sh@vger.kernel.org, linux-riscv@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-snps-arc@lists.infradead.org,
 linux-arch@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-alpha@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
 linux-um@lists.infradead.org, Hugh Dickins <hughd@google.com>,
 Qi Zheng <qi.zheng@linux.dev>, linux-doc@vger.kernel.org
References: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
 <20260922-rcu-pagetable-freeing-v4-1-fe1ad1f1e303@kernel.org>
 <arN7q5nHz7iebA_e@gremlin>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <arN7q5nHz7iebA_e@gremlin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: frhi9ozaubm3njh4wjrntq7xm4191mk4
X-Rspamd-Queue-Id: 0F66280005
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790220507-869190
X-HE-Meta: U2FsdGVkX18CnlfHRHB9q5AUd0NbCprsNtt/+3MVJpCeCrJ+lONiAoAJsZsNpErC3KLh+qkSnYDSprMPgcs45vUiYuZGTiBxE+zYSgteMFFxdAS7mi0IpToKv6sLGJD/TU6hHU3OjVscUAaS0D3snilSIOeS7/UCiOyJBl0rltDhTAfPgf8vegbrn5NJhd6ExDBCX18xU4cu0SL4GZaz4kW0c1psdOA5Hzxb3aNQtwRJ5to90fZoLLbiNopu4zGOn1CEDWFzv/lVLZw/AQ2iKX34IHtLY+KR1Np9CCCsOQiZ8ueELq6j1mGAzEKMnIGnGffi+CYmk3CRHQfmt2L5eARVkp6pkjdC/ZsNI5WrDVbw9Qh/iXgOGeVS/1Nr33lnDcmAVK+9CE5/ko+tS18VN4QDchrc0RohglRWmXapmS+JtjcDGirBoRXmBbHo4eKQDZrlV+QgbzwYfnQyqgmlVxIIA7RLCEKT2dN9Zw4A88+v4YhmBd9uSFVamix4L0jpKBszZnbq+qAj402RPmPZWzMuXfRGZGc8ncxozYBLqxZGM9OdKJXqcdH8eURDztgt/iYlPH3h36zz2bF3DhGKxfQG8N6/Hp7naIysivQGorYpY5lfv75LI/LP0Z9rJsNvO52jv5C4gnoCvr7Xw9vgrtdt3sUM9xGVr3GAcPI6ebEvLHizhZEx1vRI6Ty2zvC2VZGl3we5g61PxtVsyDrnyI4PW+pcUpPNxO8DsQh68pSvaMDy+ipVytMus47RodlPz95H3UcbynYHprhIx+h1aqdn+sqiW+iXT0zpswqQgkrjErTVIAILvcSilP/6PMP2wQKw8yd2sGN0gHlXJrjhzzyuM/VdxslO0xFvv+XlSFMNRpFftiauUQweQ87QrTEJL+GrbGFtnIWlymT2a7UFlE2VtyWIVVUNa/e+5LwYS6+rixMQhskafvgz+7VHfXje5+Y9OGsXBh98V/ZUFL3
 ckPEjMdv
 RVfS8pHO8aVV1qOMOK2R4KlAene71dW9aBRZfZRBPHrxcAMozAGSSW3u5S1SHvKc/bYYVUzL9+4flBnRrB+8QhdonKQpRAHzop3NS4DxXK1RAeHATfU0Nzeof46/3eYnvNHIOH6PZPvbtkVvKGXhKavP/DIruJZa3rQ3NLOEfBXZDiIRlMW/hpy5PSsTr8okYPEhTpG0OgylrqBhGHjzIxo3GazJIrfZ5cLMWe2A/ZZ3Z3T0+2W7OPyPSn79uxvqpF7oGCIyc25IxwtrRCMXfehRR0WNzO3loiQ1ri0/P2ouOtTB4I9NhdeqdrZeNy56IpjV7MIp68vn6Q1F18NU5stY7Tq1/erufZoap+FmnF9MYGkyKG8kNRcGi5RdCOWsRsH/ETvZkQmdDf3+7d4kcDth2tg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/23/26 3:14 PM, Lorenzo Stoakes (ARM) wrote:
> Andrew - would it be possible to make one quick fix up below?
> 
> On Tue, Sep 22, 2026 at 04:35:32PM +0100, Lorenzo Stoakes (ARM) wrote:
>> collapse_huge_page() deposits a PTE page table on PMD collapse in order
>> that it can be utilised for subsequent split operations, meaning that those
>> operations do not need to perform an allocation (as they are in a context
>> where it might be unwise).
>>
>> However the PTE page table which is deposited is the one which is currently
>> mapped by the PMD entry that is in the process of being collapsed.
>>
>> Once deposited, the PTE page table may be used in a split of any other
>> unrelated PMD entry.
>>
>> This is currently not an issue as this operation is performed with VMA/mmap
>> write lock + anon rmap locks held, so ordinary page table walkers will
>> never accidentally end up walking the wrong thing, and GUP-fast is
>> protected by an IPI via tlb_remove_table_sync_one().
>>
>> However, the series to which this commit belongs implements RCU-safe page
>> table traversal, at which point this becomes problematic.
>>
>> This can be resolved by using pte_offset_map_lock() which gates on a PTE
>> PTL and a pmd_same() check, but lockless walks are unsafe as things stand.
>>
>> Resolve this by simply allocating a new, zeroed, PTE page table to deposit
>> at the point of collapse.
>>
>> This path is already costly and an allocation has already been performed
>> for the huge folio, so this allocation is statistical noise in terms of
>> performance and memory usage at this point.
>>
>> With this PTE page table deposited, RCU-free the existing PTE page table
>> so it is safe for page table walkers to traverse within a grace period.
>>
>> This also brings this deposit case in line with all other page table
>> deposit logic which deposit a fresh page table.
>>
>> Additionally, this was the only place in the kernel that displaced a page
>> table like this, so eliminating it also helps consistency.
>>
>> An edge case for deposit exists for powerpc and its hash-based MMU - it
>> stores hash slot data in deposited page tables and zeroes them on withdraw,
>> so a zeroed deposited page table works correctly for it.
>>
>> Since khugepaged runs as a kernel thread, do a little dance in
>> alloc_deposit_pte() to correctly charge the allocation.
>>
>> This is already done for the folio allocation via alloc_charge_folio() but
>> no such wrapper exists for a page table allocation.
>>
>> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>> ---
>>   mm/khugepaged.c | 32 ++++++++++++++++++++++++++++++--
>>   1 file changed, 30 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index f49a6710933b..dab421f8233e 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -1278,6 +1278,23 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
>>   	return SCAN_SUCCEED;
>>   }
>>
>> +static pgtable_t alloc_deposit_pte(struct mm_struct *mm)
>> +{
>> +	/*
>> +	 * khugepaged is run from a kernel thread, so need to manually set the
>> +	 * correct memcg so the allocation gets charged correctly.
>> +	 */
>> +	struct mem_cgroup *memcg = get_mem_cgroup_from_mm(mm);
>> +	struct mem_cgroup *old_memcg = set_active_memcg(memcg);
>> +	pgtable_t pgtable;
>> +
>> +	pgtable = pte_alloc_one(mm);
>> +
>> +	set_active_memcg(old_memcg);
>> +	mem_cgroup_put(memcg);
>> +	return pgtable;
>> +}
>> +
>>   /*
>>    * collapse_huge_page() expects the mmap_lock to be unlocked before entering and
>>    * will always return with the lock unlocked, to avoid holding the mmap_lock
>> @@ -1293,7 +1310,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
>>   	LIST_HEAD(compound_pagelist);
>>   	pmd_t *pmd, _pmd;
>>   	pte_t *pte = NULL;
>> -	pgtable_t pgtable;
>> +	pgtable_t pgtable = NULL;
>>   	struct folio *folio;
>>   	spinlock_t *pmd_ptl, *pte_ptl;
>>   	enum scan_result result = SCAN_FAIL;
>> @@ -1310,6 +1327,12 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
>>   		goto out_nolock;
>>   	}
>>
>> +	if (is_pmd_order(order)) {
>> +		pgtable = alloc_deposit_pte(mm);
>> +		if (!pgtable)
>> +			goto out_nolock;
> 
> Fixup is here:
> 
> -		if (!pgtable)
> -			goto out_nolock;
> +		if (!pgtable) {
> +			result = SCAN_ALLOC_HUGE_PAGE_FAIL;
> +			goto out_nolock;
> +		}

With the fix applied, LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

