Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EF44C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 07:24:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 271136B008C; Wed, 23 Sep 2026 03:24:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2218D6B0098; Wed, 23 Sep 2026 03:24:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C2A86B0099; Wed, 23 Sep 2026 03:24:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA0A56B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 03:24:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 60A47806FF
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:24:18 +0000 (UTC)
X-FDA: 85244188596.19.EF90B31
Received: from mta0.migadu.com (out-144.mta0.migadu.com [91.218.175.144])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2530E1C0004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:24:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZitdDEzV;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.144 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790148256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=icLMF+2/Iw8IDBt9dpophh7lbB30Acj6lKTNCi2akZs=;
	b=VGzp3pMlyAEG7cq9Zav/8AXAtW3ivw3b/YMOb8UGYpLmx7y8TznrIYTPLaRMc/aBsbi+vK
	w+cK/zOXb4NH+1Ey6f+CFprL2twhW7qeiDNPbm81ff4x4nIaK79Pe4O3/n8C9cpCfJeBxU
	TFr2hARSncLdTcXDaWehV/AzQ3xPUFU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790148256;
	b=HZERbAUk1M1nV6gDQCesniBfPepksU9AVVd9rLaJvd+Rc6+hFgqtgPDUv4ECwRnN1D+Y6E
	865W8kqSFgdcjApfw95W5V2gW5UtWVu0HuW0DzIvzp3L/Cwv0AUHSpFzcPXf4+bmfpe3yR
	2Jg/IsNdtzxKVF3NkJPTIEI436i9f9M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZitdDEzV;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.144 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jtYR83JV3L8wH6uuzBN56BU8b17HKc/GBiTiWGypKto=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790148251; v=1; x=1790753051;
 b=ZitdDEzVB8mro4S6SKoYLF46N93dHTjFZinvSzB1Tf9JAfw8A0Ns0W8eVy7glk/5tinhIev+
 ZJMzkM1YUd3WJnC3LVSjPGiT0vEQ42MnVITnvnmBHRs2Hqds/vqK+uPltPzqNwHHfJJExQAYCTR
 Vln16SrZK9gLi+f5kAde2HAg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 37f5cbda674b2a55;
	Wed, 23 Sep 2026 07:24:07 +0000
X-Mizu-Trace-ID: 37f5cbda674b2a55
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: ljs@kernel.org,
	akpm@linux-foundation.org
Cc: david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	guoren@kernel.org,
	bcain@kernel.org,
	geert@linux-m68k.org,
	dinguyen@kernel.org,
	schuster.simon@siemens-energy.com,
	jonas@southpole.se,
	stefan.kristiansson@saunalahti.fi,
	shorne@gmail.com,
	dalias@libc.org,
	glaubitz@physik.fu-berlin.de,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	linux@armlinux.org.uk,
	vgupta@kernel.org,
	monstr@monstr.eu,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	davem@davemloft.net,
	andreas@gaisler.com,
	richard.henderson@linaro.org,
	mattst88@gmail.com,
	linmag7@gmail.com,
	catalin.marinas@arm.com,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	tsbogend@alpha.franken.de,
	James.Bottomley@hansenpartnership.com,
	deller@gmx.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	chleroy@kernel.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	richard@nod.at,
	anton.ivanov@cambridgegreys.com,
	johannes@sipsolutions.net,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	ysato@users.sourceforge.jp,
	shakeel.butt@linux.dev,
	corbet@lwn.net,
	rdunlap@infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-csky@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-openrisc@vger.kernel.org,
	linux-sh@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-snps-arc@lists.infradead.org,
	linux-arch@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-alpha@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	linux-um@lists.infradead.org,
	hughd@google.com,
	qi.zheng@linux.dev,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 01/12] mm/khugepaged: deposit a newly allocated page table on collapse
Date: Wed, 23 Sep 2026 15:24:00 +0800
Message-ID: <20260923072400.3028-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <arN7q5nHz7iebA_e@gremlin>
References: <arN7q5nHz7iebA_e@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: zzskj6pcx3grny8d7epdr9fz3sriznj4
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2530E1C0004
X-HE-Tag: 1790148255-580110
X-HE-Meta: U2FsdGVkX1+Wb+LB0d30XP8VsEHHoSmju5Q3MCT0sl4tdKM/JH+w33kHTISUYSBL2lhb3s6FVRMxKwDWaRs6SjFMcHmwz1RF2aA08Q8vzBUXEWw5/dK8Qv4KQs2ackyhDwGhVW4YQGMSqECyPaHP2DZwZa3gSvcs31xmvpLLATcMu5BYA3lbIPubcNy5kIawbSpIaTQM1j+C+A+Z4K6Sp0hZIdsuwxcZR5/XHZklImEsOktdQc7Kgt7StvpUz0+cul6n/RhVOvam/IweEtKaYxqKSOo9LK8zRmtORWhQVKW0ikIMGMhaXx7c+n6Z+kE2Z4H333WwIfCPHlvCU02CpnbyXnunrq/v3NmBD7h0yd4Ls+0ecCoUIPTiqTZYiaLhx+1iKWFONVHYmvlUGQKmaMW3fKxM7ToSnO8lwPJ2220UrMwenFpmGvMq9BuVBXFca0EEszSNiBsPjzCqGkM0rnfm7llFtvseOj8ciSKMo1H2snsYks79r0pmhO3qlh5AFOks2qw7mIhXPu8N0giE/ptQ+fjfrb6Sgg/9ivjQIg7SmPSxpGuL3mm14q74NaPYyP8Eto/rC9Jx4n5QCG8VTVspybTjeRiaT+zMEWNR9gyKS7ihWAS41Bva+63JSi99awFTtSNUXYT+Eyse48h4pESAwNXFcOzP6j9kE1itDH7UDvifJod63w2Bsx2dEF5h1OSZi08YE0eMSfir8///UjJISOHkw+TYzcSHnHN0Y8gKJ0oMvJ2v2S4aG8H/8YzgAgeCTk8p2nLZXR1djfFvJNMLrA/HoaAZtkLmlNQHhCzUx6TOkIvcQ5E25T0bMAFqaTxe1CFxIAIUuyKf81F+1uir+Tm7UgxXyGinkhsKyWI5gIbV/ZQNzs9yA/O/6GIVU+0xIzQDrn5dNXLwGW4C8ef9VH7X3oJVzWFSfI59olsygbo1EOWVO3He3PDl6FsG0Xq+aV3FJfbWe8JidDd
 ip9aTgQJ
 FhUXMkfNrKzPZgY77o2Q6xrchwwCe7FHSeQ8P+0mHfn85F35iZRn74SgJOnIIKtY013+5Q0V5DWGgIDmG1ohvdVaPmMW9wFAP4SYBD4CgYMGEt2LTpdPrTCjXF4dt29r11bYlxVxXyDIjR1Q9tXLSJ0Lr6bmIxqoRUIL2yFunJllT6toSsnRkf8rybZLih+I4PbgkyXnzAA2JMKA9hVSE49O6hbp+HKuynxP56bnHlwNU+sGwVJz79zh+aMvY+uBxQAgmIHleysib9Pon7yJ4yGX76ICcW9aAf3+Ffso5NnanGUZdY0sYgrSNyv9beJr9FIym3fg49o/9OKQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Sep 23, 2026 at 08:14:01AM +0100, Lorenzo Stoakes (ARM) wrote:
>Andrew - would it be possible to make one quick fix up below?
>
>On Tue, Sep 22, 2026 at 04:35:32PM +0100, Lorenzo Stoakes (ARM) wrote:
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
>>  mm/khugepaged.c | 32 ++++++++++++++++++++++++++++++--
>>  1 file changed, 30 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index f49a6710933b..dab421f8233e 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -1278,6 +1278,23 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
>>  	return SCAN_SUCCEED;
>>  }
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
>>  /*
>>   * collapse_huge_page() expects the mmap_lock to be unlocked before entering and
>>   * will always return with the lock unlocked, to avoid holding the mmap_lock
>> @@ -1293,7 +1310,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
>>  	LIST_HEAD(compound_pagelist);
>>  	pmd_t *pmd, _pmd;
>>  	pte_t *pte = NULL;
>> -	pgtable_t pgtable;
>> +	pgtable_t pgtable = NULL;
>>  	struct folio *folio;
>>  	spinlock_t *pmd_ptl, *pte_ptl;
>>  	enum scan_result result = SCAN_FAIL;
>> @@ -1310,6 +1327,12 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
>>  		goto out_nolock;
>>  	}
>>
>> +	if (is_pmd_order(order)) {
>> +		pgtable = alloc_deposit_pte(mm);
>> +		if (!pgtable)
>> +			goto out_nolock;
>
>Fixup is here:
>
>-		if (!pgtable)
>-			goto out_nolock;
>+		if (!pgtable) {
>+			result = SCAN_ALLOC_HUGE_PAGE_FAIL;
>+			goto out_nolock;
>+		}
>
>Thanks!

With that applied,

Reviewed-by: Lance Yang <lance.yang@linux.dev>

