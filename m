Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7242C88E40
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 07:23:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F1026B0088; Sun, 13 Sep 2026 03:23:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87CC16B008C; Sun, 13 Sep 2026 03:23:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7432D6B0092; Sun, 13 Sep 2026 03:23:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E3AF6B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 03:23:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 92177A543C
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 07:23:43 +0000 (UTC)
X-FDA: 85207899126.26.1BD6284
Received: from mta0.migadu.com (out-210.mta0.migadu.com [91.218.175.210])
	by imf23.hostedemail.com (Postfix) with ESMTP id 11BE9140007
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 07:23:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gVN42bTL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.210 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789284221;
	b=lyZ5znIiQ5CxbY8SoY1RIiHurTmHXufMGD7QgjLlU9jJ4+4dTQ3clXrxk0C8aBCm+EXRcu
	8ajJg+WruXQ9VATjKd/5ECUi+soY6OQZX2F8sp26dsDeVzm7ZCdOg6+xbV4scbYZGk0oLL
	mmIODPaTtdF4kLR1yjlBesDc7bUeLh0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gVN42bTL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.210 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789284221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DA1a4NsTijrA/0A7Rp40uSGEov9CchZ4qFLhGxWOzlU=;
	b=bjGJ/zaT4wij60r5cyIwIXqEAOa/hTcQcfB4ySZYZrlT9xge3zapkM8mQzXv8wuoSacjdo
	NWrXYP1ONJUSehz6PPn0LM2LCsy9qkCGpBR7c7cqM4FgVZnLjqmwTp7JicOL6XIvs9oGH5
	a195lXlyjkes59vT9Ze45RTxKsj9s+M=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=IxZ5irpoc9Wr9wY2wKWP3i1ANdXlxPv1vjeqCqP4vuI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789284219; v=1; x=1789889019;
 b=gVN42bTLJHEEpg1p4L9bINSm2s8Z5Jm2mwRO2k7kkH5pmlJktgBDF2fp/wnkomQSGNRg19bq
 cLCFQPOk2AEIfyZETjX1ESTKuSCzf55Bak9dHzZknyl+hV10ZGppV1VR6y6Ic8hbcJOxtHCgL6y
 iPK+HKzUwjEl98TmCPSrq5rc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id fc7f62b8527fd901;
	Sun, 13 Sep 2026 07:23:29 +0000
X-Mizu-Trace-ID: fc7f62b8527fd901
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: lance.yang@linux.dev,
	david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	usama.arif@linux.dev,
	kas@kernel.org,
	ljs@kernel.org,
	surenb@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/huge_memory: fix pgtable withdrawal for huge zero PMDs
Date: Sun, 13 Sep 2026 15:23:12 +0800
Message-Id: <20260913072312.52111-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260912234635.db50397364858aa15f58f4d7@linux-foundation.org>
References: <20260912234635.db50397364858aa15f58f4d7@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 11BE9140007
X-Stat-Signature: cn5j3sf8exzotgx7k3yaay48qut57nsm
X-HE-Tag: 1789284220-518531
X-HE-Meta: U2FsdGVkX1+ayq1z01xdPOaTS7VNJsejt8PIvGZbt04BYuwZeoYSUDrsGzfHB9YXPIx5IpR0HS4AugdTeKfhIfFgebnr9uGcMGdfu4OoSSMMNdF4xH7P4Y/9wtehy/YUXggZn32keMyHcDW2Nt3lXD4MAAEPMiD3KXo3iiwZPUfBIl/dycvGAZRRoxMug1G+FMuk4/tL4A0knipBOkbqqZ0ijavn0/wxkFzToIXwVHBm0bYvv+1qJdQhGcQpC9wkvECY25FgnwUjl09eLNoPIoaWuMPaE8pYw1qWdW8G5C3AUY3NH5COYpmENYie+AQTzQiwNMIz968pzsecfEE3lx7i3Gkq14AvtxmNIJe5JmL2vqQyMOf690rkQkXoJNRwAUEp3dhBPHdyEI6kKNQQnH1SoDUipsCqJepVWFXzmRmB7/LPrAI6OsPp8pC1tNefXGw5ZxusxHofYW7FKtnYsUZA7NTwJB/WWnlbo1dIplh54uGXUX7xyzBZkxB/RGIfTFJyEFqfLRbTY5oF9cstixKIx/dkU20A7iY2AUG6enr6mu91LZrdwJV1fc0rpgRodlYqTeJzjMXTCYnc54AliYuCbFbLRearONNpVBaFVclcbClaXwEFUUxs1osPV2Cl6c8i5SvbEXQKjtotaP951HYRSxWGfsIizdjSxDXRpESxQ+1Zhk25tRlUkLgwFH8Jxds43sknCPCPZe6S4gT/xojcN7InL9QaE+tirB3PIhdrZetrFUGyuxWh2JnMGI4z0dnwxuLCuhIFml42+TroehJORU/Iw+CRRz2Qgd+CsvYJWgVp1hRUeWzuDjo9810lXOvWEgZQkFbBsK/kVhj1LgQLNwypCPyKDsXnpI95uKJXjlxiA74ge9+qCVKEX+x5x9ILpHu6UItCGceV8nmG5ZWYr9N8u4JnGp1ePhUhW9nYNHx+U4NKKu8fXE6wwIojzCEmhzz0JCeNpp9XF8m
 xdAdUMFo
 X34n5LTiWEPTpiWZ96g6/m5GANUin32gIg2rSQm5wnpsoJuPwW5QmhI3cVgkmfggu1PgfsNs++YoRYW94MMoIIWNqcPoefcYyZvSpmfQ12l58d0WgWc5h11O06w89Ghf//XlBA79AhhX6+TIALWvlMRXCBNLLC8uPWg6ww5s4lNyOuo/A1PfVuMt8L7Wibm5kI4TMzu4qNd5h861+Firbhev4oNejNNdUv56ckkAVSRpswKTtCCsQgXtoVDEmrIgx9j2vi6uwgOEHC+7wgzTMzvrOeTZYmyNeE8pIiTq7CDQ55NMFiGPRXGx/7YReBmaHPFnq/gpA4G7zbmE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Sat, Sep 12, 2026 at 11:46:35PM -0700, Andrew Morton wrote:
>On Sun, 13 Sep 2026 13:19:42 +0800 Lance Yang <lance.yang@linux.dev> wrote:
>
>> From: Lance Yang <lance.yang@linux.dev>
>> 
>> has_deposited_pgtable() uses !vma_is_dax() to decide whether a huge zero
>> PMD has a deposited PTE page table. That also accepts raw PFN mappings
>> of huge_zero_pfn, although vmf_insert_pfn_pmd() does not deposit a page
>> table on x86.
>> 
>> Zapping such a mapping would call pgtable_trans_huge_withdraw() without
>> a corresponding deposit. With pmd_huge_pte(mm, pmd) == NULL, that causes
>> a NULL pointer dereference.
>
>That's the sort of thing we'd prefer to avoid.
>
>> Use vma_is_anonymous() for the huge zero PMD check. This matches how PTE
>> page tables are allocated, deposited and moved.
>> 
>> - For anonymous page faults that install a huge zero PMD,
>>   do_huge_pmd_anonymous_page() allocates a PTE page table and
>>   set_huge_zero_folio() deposits it before installing the PMD.
>> 
>> - On fork, copy_huge_pmd() allocates and deposits a PTE page table when
>>   copying a huge zero PMD into an anonymous VMA.
>> 
>> - Raw PFN mappings use vmf_insert_pfn_pmd(), and DAX file holes use
>>   vmf_insert_folio_pmd() to map the huge zero folio. Both use insert_pmd(),
>>   which deposits a PTE page table only when arch_needs_pgtable_deposit()
>>   requires it.
>> 
>> - Moving an anonymous huge PMD preserves its deposited PTE page table.
>>   move_huge_pmd() transfers the deposit when necessary. For UFFD MOVE,
>>   both VMAs must be anonymous, and move_pages_huge_pmd() transfers the
>>   deposit as well.
>> 
>> Keep arch_needs_pgtable_deposit() first so architectures that require a
>> deposited PTE page table still return true regardless of the VMA type.
>> 
>> Commit d80a9cb1a64a ("mm/huge_memory: add and use
>> normal_or_softleaf_folio_pmd()") removed the vma_is_special_huge() check
>> in zap_huge_pmd(). That check skipped the huge zero PMD deposit test for
>> non-DAX VM_PFNMAP and VM_MIXEDMAP mappings. Removing it exposed these
>> mappings to the incorrect !vma_is_dax() test.
>> 
>> Fixes: d80a9cb1a64a ("mm/huge_memory: add and use normal_or_softleaf_folio_pmd()")
>> Cc: stable@vger.kernel.org
>
>How real is this?  Is there a reported-by:?  Do you have a reproducer? 

Yes, I reproduced it on x86 with a small test module. It sets
VM_MIXEDMAP | VM_HUGEPAGE and calls vmf_insert_pfn_pmd() with
huge_zero_pfn, without touching the page tables directly. A full-PMD
munmap() crashes before the split series[1] as well.

>Is it a theoretical, LLM-found-this thing which can't really happen?

I found this while reviewing the split series with LLM assistance.

mshv_vtl_low derives the PFN from the mmap offset, and its checks do not
exclude huge_zero_pfn. I haven't tested this on a Hyper-V, though.

[1] https://lore.kernel.org/linux-mm/cover.1787941780.git.yintirui@gmail.com/

>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -2529,11 +2529,11 @@ static bool has_deposited_pgtable(struct vm_area_struct *vma, pmd_t pmdval,
>>  		return true;
>>  
>>  	/*
>> -	 * Huge zero always deposited except for DAX which handles itself, see
>> -	 * set_huge_zero_folio().
>> +	 * Huge zero PMDs have a deposited page table only for anonymous VMAs,
>> +	 * see set_huge_zero_folio().
>>  	 */
>>  	if (is_huge_zero_pmd(pmdval))
>> -		return !vma_is_dax(vma);
>> +		return vma_is_anonymous(vma);
>>  
>>  	/*
>>  	 * Otherwise, only anonymous folios are deposited, see
>
>Thanks, I'll add it for test-n-review.

Thanks!

