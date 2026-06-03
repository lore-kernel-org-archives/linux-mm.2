Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72DFDCD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 12:24:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93C346B008A; Wed,  3 Jun 2026 08:24:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 919216B008C; Wed,  3 Jun 2026 08:24:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 850CC6B0092; Wed,  3 Jun 2026 08:24:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 737426B008A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:24:29 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1328414034B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:24:29 +0000 (UTC)
X-FDA: 84838519458.30.7926F79
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf01.hostedemail.com (Postfix) with ESMTP id AD1C94000E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:24:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HubuBb2q;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780489465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i81FGwAX/vixZ25Q3Ngd8ivvoVTv7aSnS7HWQVQ1K20=;
	b=SzaaL8ttFj8lBR87BsIQUmgVuuxeIrpnrzX3XbcUm1WYj/UKiFiY8MgzEm7/nshYcWCd8z
	eaAXOnxt2/TgzoFbj6JBjoO9zQO3kQjJSOqdHuNTca13gKRdqV6bgoCE9urZod8PXegD1R
	xlIpCHpP7lu+ki+uWYbN3xXqYW//NDU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HubuBb2q;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780489465;
	b=W0j9x3YY0l1QPzS1B0rij1aV47CLDQiSAFMp/GlVQ1by51f8Z0r4/FSL74pL94uN10O4N9
	tbFM4k6y7ZvGXcbeOQn3nzlo6kJ+7eR+CGtwlyKfYABB0wZ5MY0ofECSQodKrjccmUFrfZ
	QqQhz6anK41/VDNcv4NhSY8JaWruJfc=
Message-ID: <f9dd874a-b637-4740-9a63-8da66de323ca@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780489462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i81FGwAX/vixZ25Q3Ngd8ivvoVTv7aSnS7HWQVQ1K20=;
	b=HubuBb2qZb4N9mqtKd+HqBZxa//bXTQ7vqPh0cqo521lhCGrl2arQXZ0egrlgrhMVPjN1w
	58IEh2Vdv9FcCt9r5uDyBa3ErJYP6T7LGb5Df4WMvfpy1qfJaqgAjvA1opfVW8eeXtT4yb
	kc47gaP4MkVI9XYMHI853t/97ZI2r0w=
Date: Wed, 3 Jun 2026 20:24:09 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 15/19] mm/hugetlb_vmemmap: Move bootmem HVO setup to
 early init
To: Usama Arif <usama.arif@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
 linuxppc-dev@lists.ozlabs.org, Muchun Song <songmuchun@bytedance.com>
References: <20260603120246.1572177-1-usama.arif@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260603120246.1572177-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AD1C94000E
X-Stat-Signature: 14wka85paahyot5aj45itissf6f9k464
X-Rspam-User: 
X-HE-Tag: 1780489465-981099
X-HE-Meta: U2FsdGVkX19938LJ5IH9ky2JyM5mx3M7JR9deF58zohzxwF/WS2q7nW/MKfjrUopLmT+LFSslKUb3ztbkDPYgrJCL2HlcgsS27onxNzCUj/AHQ8+SS4SkRBKyoUF9KJqHZFzYg2HFAQQCOZ8mRNIl6a5sm5pQkGDiF1ye1uDhjHmntWCh1uH9JpfMcrxVEsSPD2v66+ILJ1/FZJ6aBjCaj7vP4vaXcV5OCmiHc3qGr5GAtFySmjwgcUIfUFZCJGavVXEJcZb9PAyNKZLJODaA4aboRJG+DDJTFEoiRA0XOtSdfib6qa0HI5LAeLDeP4vWBXovFDe6zMlbb2GlYLaV+58HNXxIInrj8ofVcLKorDXK8FrHTDw13X6gBv0GBOLp/y6B6j74XT1ClSCzrQKKONb6F64Bnm48oFG8L2taLF6RqoJAj/6cNcNKFgzH5g1i/ErtOXL3jOxl8rBjl8dvP3Q+NgpQWnskHl41aa4nrDUJdAcWKAbhihNBLlSGoi1OcxIVyhKmU29V+Qi2cvuGpQbu8BtIj61gqOwW5uNQS5umur3Z2ArJ9pgj4i3pbD/ZQlW2OTDMI4QFxG4WvrP53ZyhjMzMGa87uMxqzIbIjfpnTi2oprmCXtIOZ9U5lEBU6oJ+SeehpaIIVSg7w82jlWvgGSXZNHwI+PoXy/D2mBORuchy54weKG7v2wNpgot/tkFBHsOvT0tNYoY6gRh6qsTVGOSdF88X8BD2j/vGsjLqJTG88IRN3sQvkJlJI89vka1ApoUr3uMtIwg5DgMrMIR76J2wRmzLj7oILh3DsdtrtSI3H5DizBoc48QxaajbAtKixkKjchwUx3oF4nTT1XJd3vjbC3TUJElTqm0dDqpoiooUCLx1WoFMylvvyA5/xPsqWb/PcwKPMArHMtaSpmPgnp0QAMk2QZU7zRrLwDOG0OXvBp1+r1lY19yU/0RJkfKmqO+sBVycR+yuOZ
 0cu+atH2
 vfrg1Mpoei/EimgsfWKuxNxBBHeJIxGZkiyQs6GZC3UXbiYVIqIlycsIT8f2/g9342FoaobBdM6tNk0jdHas7EdwRKPzqOb2RWhgeI182JJWKlDRXAqjnLo16Ky3PxysntcPgxM3PbYkjvNNAJLEn3RZ1hOH1d7mRW1Cl2jS61ty7G9np30ZGbc0lPcFk+7Q7soYaM3Ee98WTF+zughCfIzrM3pNanJtjPkiH6o/u40/94i9fyJk90teot28aiLRMHlYo2ThE8TdROxG+81pCvcy3MmskH8U0s4LxkkQS4H/kXXi9D+6eXIBifHbFgtiTsrMZMql6O3jSRhRB0WQm1HQPJlV+QThDJiMvv80DfICUJVh/VveYuIogPJ9OWmHRT5BO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/3 20:02, Usama Arif wrote:
> On Tue,  2 Jun 2026 18:10:35 +0800 Muchun Song <songmuchun@bytedance.com> wrote:
>
>> Bootmem HugeTLB pages currently defer HVO setup to
>> hugetlb_vmemmap_init_late(), because the optimization needs zone
>> information.
>>
>> Now that zone initialization is available earlier, the bootmem HVO setup
>> can be done directly from hugetlb_vmemmap_init_early(). This lets
>> gigantic HugeTLB pages apply HVO as soon as they are allocated.
>>
>> Bootmem gigantic pages that span multiple zones are now filtered out
>> when they are allocated, so the remaining bootmem gigantic pages seen by
>> later hugetlb initialization are already zone-valid. As a result,
>> hugetlb_vmemmap_init_late() no longer needs to handle bootmem HVO setup.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>>   mm/hugetlb_vmemmap.c | 67 +++++++++-----------------------------------
>>   1 file changed, 13 insertions(+), 54 deletions(-)
>>
>> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
>> index ea6af85bfec1..464578ee246e 100644
>> --- a/mm/hugetlb_vmemmap.c
>> +++ b/mm/hugetlb_vmemmap.c
>> @@ -745,6 +745,8 @@ static bool vmemmap_should_optimize_bootmem_page(struct huge_bootmem_page *m)
>>   	return true;
>>   }
>>   
>> +static struct zone *pfn_to_zone(unsigned nid, unsigned long pfn);
>> +
>>   /*
>>    * Initialize memmap section for a gigantic page, HVO-style.
>>    */
>> @@ -752,6 +754,7 @@ void __init hugetlb_vmemmap_init_early(int nid)
>>   {
>>   	unsigned long psize, paddr, section_size;
>>   	unsigned long ns, i, pnum, pfn, nr_pages;
>> +	unsigned long start, end;
>>   	struct huge_bootmem_page *m = NULL;
>>   	void *map;
>>   
>> @@ -761,6 +764,8 @@ void __init hugetlb_vmemmap_init_early(int nid)
>>   	section_size = (1UL << PA_SECTION_SHIFT);
>>   
>>   	list_for_each_entry(m, &huge_boot_pages[nid], list) {
>> +		struct zone *zone;
>> +
>>   		if (!vmemmap_should_optimize_bootmem_page(m))
>>   			continue;
>>   
>> @@ -769,6 +774,14 @@ void __init hugetlb_vmemmap_init_early(int nid)
>>   		paddr = virt_to_phys(m);
>>   		pfn = PHYS_PFN(paddr);
>>   		map = pfn_to_page(pfn);
>> +		start = (unsigned long)map;
>> +		end = start + hugetlb_vmemmap_size(m->hstate);
>> +		zone = pfn_to_zone(nid, pfn);
>> +
>> +		if (vmemmap_populate_hvo(start, end, huge_page_order(m->hstate),
>> +					 zone, HUGETLB_VMEMMAP_RESERVE_SIZE))
>> +			panic("Failed to allocate memmap for HugeTLB page\n");
> The replaced hugetlb_vmemmap_init_late() path used to fall back to
> vmemmap_populate() if vmemmap_populate_hvo() returned an error and
> just lost the HVO optimization for that page.
>
> The new path panics on any non-zero return.  Is the panic intended,
> given that vmemmap_populate_hvo() returns -ENOMEM on allocation
> failure and HVO is normally treated as an optimization rather than a
> hard requirement?

This is intentional; see patch 6:

     mm/sparse: Panic on memmap and usemap allocation failure

We already panic on OOM anyway.

Muchun,
Thanks.

>
>> +		memmap_boot_pages_add(DIV_ROUND_UP(HUGETLB_VMEMMAP_RESERVE_SIZE, PAGE_SIZE));
>>   
>>   		pnum = pfn_to_section_nr(pfn);
>>   		ns = psize / section_size;
>> @@ -800,60 +813,6 @@ static struct zone *pfn_to_zone(unsigned nid, unsigned long pfn)
>>   
>>   void __init hugetlb_vmemmap_init_late(int nid)
>>   {
>> -	struct huge_bootmem_page *m, *tm;
>> -	unsigned long phys, nr_pages, start, end;
>> -	unsigned long pfn, nr_mmap;
>> -	struct zone *zone = NULL;
>> -	struct hstate *h;
>> -	void *map;
>> -
>> -	if (!READ_ONCE(vmemmap_optimize_enabled))
>> -		return;
>> -
>> -	list_for_each_entry_safe(m, tm, &huge_boot_pages[nid], list) {
>> -		if (!(m->flags & HUGE_BOOTMEM_HVO))
>> -			continue;
>> -
>> -		phys = virt_to_phys(m);
>> -		h = m->hstate;
>> -		pfn = PHYS_PFN(phys);
>> -		nr_pages = pages_per_huge_page(h);
>> -		map = pfn_to_page(pfn);
>> -		start = (unsigned long)map;
>> -		end = start + nr_pages * sizeof(struct page);
>> -
>> -		if (!hugetlb_bootmem_page_zones_valid(nid, m)) {
>> -			/*
>> -			 * Oops, the hugetlb page spans multiple zones.
>> -			 * Remove it from the list, and populate it normally.
>> -			 */
>> -			list_del(&m->list);
>> -
>> -			vmemmap_populate(start, end, nid, NULL);
>> -			nr_mmap = end - start;
>> -			memmap_boot_pages_add(DIV_ROUND_UP(nr_mmap, PAGE_SIZE));
>> -
>> -			memblock_phys_free(phys, huge_page_size(h));
>> -			continue;
>> -		}
>> -
>> -		if (!zone || !zone_spans_pfn(zone, pfn))
>> -			zone = pfn_to_zone(nid, pfn);
>> -		if (WARN_ON_ONCE(!zone))
>> -			continue;
>> -
>> -		if (vmemmap_populate_hvo(start, end, huge_page_order(h), zone,
>> -					 HUGETLB_VMEMMAP_RESERVE_SIZE) < 0) {
>> -			/* Fallback if HVO population fails */
>> -			vmemmap_populate(start, end, nid, NULL);
>> -			nr_mmap = end - start;
>> -		} else {
>> -			m->flags |= HUGE_BOOTMEM_ZONES_VALID;
>> -			nr_mmap = HUGETLB_VMEMMAP_RESERVE_SIZE;
>> -		}
>> -
>> -		memmap_boot_pages_add(DIV_ROUND_UP(nr_mmap, PAGE_SIZE));
>> -	}
>>   }
>>   #endif
>>   
>> -- 
>> 2.54.0
>>
>>


