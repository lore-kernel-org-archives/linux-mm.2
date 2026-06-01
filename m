Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E13DFCD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:17:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 524596B036D; Mon,  1 Jun 2026 08:17:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D45E6B036F; Mon,  1 Jun 2026 08:17:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C3766B0370; Mon,  1 Jun 2026 08:17:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 27BDF6B036D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:17:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BBB91C23AD
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:17:34 +0000 (UTC)
X-FDA: 84831244428.05.39C8ABB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id ED8D8100010
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:17:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oBQl7nHC;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780316252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=np0bfKSMDe3FiDWWlMCRS3v0M2dNU+viwLE85S64AOo=;
	b=o+/irlz9m2DJ2WJeWUkd4Ow6lkZetoNdQ4ayn78Np91FwSwwRaG7JR1Qj93qbBz2RD6XvK
	iBDfCxCFMFemqrFwQw2kd4FjKpOKDJD+kqWYoWaYIZNJW4VfphCGG9fvpXt4EC0eOoedMD
	hWcMtQtWMCxGQ3CegG46iZKWQ1gaeJ8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oBQl7nHC;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780316252; a=rsa-sha256;
	cv=none;
	b=LtTHD75U7BPoUSPRkUR9IPKam82MGvX1zBFcv+Hf3Gb9wa4vu+ceIUxVWjTI+lBf07mcw/
	UhSZkS5t3gjL0blT7mMp2X9LitxRY5OkOjfPh0lNNjHW2wO7Nryvsy9bLUOVK+vk26DDUu
	IPBtGIU/0kRxgkFkY1hhxC6Kxt7ms70=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 691D26001A;
	Mon,  1 Jun 2026 12:17:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03BB81F00893;
	Mon,  1 Jun 2026 12:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780316252;
	bh=np0bfKSMDe3FiDWWlMCRS3v0M2dNU+viwLE85S64AOo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oBQl7nHCPZceJPji0pieAO/hWFEw/YPlcwRTVbQVbcdEH0yz5doFvB4mulF2JyTp1
	 l6Lvt1y80010t4gHLsPRuVLIPGHGUUVni3eygodSLRrA3zhdeaJK/msTxU1iFUHcFB
	 YR5WpatULgkp/PLF81JxYqdkZdE2eRtVBqTTavv/SxfP3aAO3+ci5MBcy37AL95c4X
	 eK+Iszru7ofixgMRPWZhEKiFquq3lCqUpqjaPEiGos+a9pXSc9Btv5idSwvcyS88Za
	 4gnbsOMh7S2bJ6x6drhk8dKtfcpRa85UM6OJ6fA5rDTPEExrHTZL/DePKAdNCr4kVv
	 VE6S0sjrANURQ==
Message-ID: <a7060bf8-ec97-4137-a26a-c9defc17dc2f@kernel.org>
Date: Mon, 1 Jun 2026 14:17:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-hotfixes] mm/huge_memory: use correct flags for device
 private PMD entry
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 SeongJae Park <sj@kernel.org>, Balbir Singh <balbirs@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260601083044.57132-1-ljs@kernel.org> <ah1IrfWfJuK3v5lG@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ah1IrfWfJuK3v5lG@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: y5agiej11ks8eo1r8ra8ptzm3qyaucqq
X-Rspam-User: 
X-Rspamd-Queue-Id: ED8D8100010
X-HE-Tag: 1780316252-331660
X-HE-Meta: U2FsdGVkX18VRW+ESkc51TF1lWX8P0zFDWBz5yaUsSEwecj2i93GM24jTTTt0xm1wfNOyXMnTt+JDP6tjhm7wUNwst/nCUaKd7WrA8RlAVJ0qKYPa4IeFe1M4V5TrBT3ZrFLIDbxLhJihcZoQPjtkdY3BjTucMiMFuYlbUWZ8cpFNN+RsGd0di9RjvzUEjz1l0pnnavacov/QupOFLQYBCcXjnl0CLJGearN7I3h8p93nk2wbMTr+ue+FVJ+kuRBcCLCvc+N9CPbSlzbFQcsb0JzuR8CtPeNeWx9s9Rnp0MR3bpcbmPb7EaNHQxjzGII9omSyGbkpX+9KAwWMBEcfy207fVVUzR21RtTAbE0l2gELjoEBEUo2bik74DtdwIeIrj4LEvg9HvD0OEjKuPSSyJxUO/AwZQhrRofke/knCm+EpEfkFmfDt3d7ZCPxKAdC+Yw+W5ENNbiRR/tyU46zg6HBwLF/r6HO6I95tS12jfVm8kuYYfS7NqVAHsofdCnT2Cz0TCntQOy4giJZpW4y8xXUpgkBRWwxvrXAm0UWWo3koBW/bgZPabvtDyF8m6LAPf35OzhTzdUTyPVL/QdIp6yjYVBP62kHtYQYag2HwP5qBnuR9Zrc9QEdbezCObM2KXG7xFe8pI1EMiXriFjC6H5//ozaTah2z+itYX2QHtTtchAGJdhoyZrOCv/kQ9t8yfRfdMWmJKbbjsSgHvKgJfpx9RLXeSz5jxZfA25FwV5PI4hif0IELqmcfNlN4ZNDpiyWfN1dL2csh/aObpOvZ0Ku24ykE+trxSUoypbWUiT+VRTtnRCoKCZIYz/WOkLwSPmUUB6pQHZTfRW60cFaMi1W1y+/cUpDgoN2UsWyXiBxVIRTKYg/k7UwueVavCXsR30HepN/KhPx9SQ8MDFH55Z04u20JHBrmZteyNESl7f55KpNrd6TnnrMIgl3PycOyBT/ZyMRz9+SvMUOvJ
 4w6pIqip
 L2+kr9wd5cSyKddykgmnpvdJz9ih6fWYMre+8dp3IA8Cedot7MnRtpVQwb5L73yA3OIuL15ElT8ubzAFbwa3EkGpSGzCj3Aw5IFCkVUw4GEwbWYXbjA3KjhGl7U4+O52B3VH+G8Prvn3+KbSmeTp8ExY+PXI9qbz5kShwIGa4HBgV1kEyECZz1V4yGBK3VwFF6FMuA1DGllSULHhcHIh+3mTJUR6NOU/U98zMyMAyaR7A3Z+uCraogH67ssLRhMQVFuTpdl7i56RvA8uo/G4Y17K2K5fayJuhN+IY9tN+tLaXu6EtMf0Qi035s/3oq6IOIyWQX8m6aK8XAbJ+QgN07AwUca8T/rzLGUI9PHaXVuW6tcts3UAzCLmc3BUiOCNRNrESus3/MKocTA84glHRD7nmoAQ+B81wa3SVa2pADS9vzT3juhtLczzOuh5ejHquOQ1/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/1/26 10:55, Lorenzo Stoakes wrote:
> On Mon, Jun 01, 2026 at 09:30:44AM +0100, Lorenzo Stoakes wrote:
>>  mm/huge_memory.c | 45 +++++++++++++++++++++++++++++++++------------
>>  1 file changed, 33 insertions(+), 12 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index bf9b480bb3b0..79463c709c98 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -4982,7 +4982,7 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
>>  	struct vm_area_struct *vma = pvmw->vma;
>>  	struct mm_struct *mm = vma->vm_mm;
>>  	unsigned long address = pvmw->address;
>> -	bool anon_exclusive;
>> +	bool anon_exclusive, present, writable, softdirty, uffd_wp;
>>  	pmd_t pmdval;
>>  	swp_entry_t entry;
>>  	pmd_t pmdswp;
>> @@ -4990,12 +4990,26 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
>>  	if (!(pvmw->pmd && !pvmw->pte))
>>  		return 0;
>>
>> -	flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
>> -	if (unlikely(!pmd_present(*pvmw->pmd)))
>> -		pmdval = pmdp_huge_get_and_clear(vma->vm_mm, address, pvmw->pmd);
>> -	else
>> +	present = pmd_present(*pvmw->pmd);
>> +	if (likely(present)) {
>> +		flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
> 
> Oh I forgot to mention in the commit message that I moved
> flush_cache_range() into the present branch, as it's not meaningful for a
> softleaf (i.e. non-present) entry.

Nothing jumped at me, so LGTM

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

