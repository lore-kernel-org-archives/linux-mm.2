Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6346DCD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 08:05:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 947EA6B0005; Thu, 28 May 2026 04:05:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91FD86B0088; Thu, 28 May 2026 04:05:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85D006B008A; Thu, 28 May 2026 04:05:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 754476B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 04:05:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 491D3161D6A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:05:31 +0000 (UTC)
X-FDA: 84816094062.29.6CB0F67
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 110D418000A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:05:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JOBb7fam;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779955529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CvUp2WE4NRfIp2nl9XGNBy0iKarZdKYxJdNZYx9xR2I=;
	b=H6TRp+USsdJTwIjN40xyC3pWwFtTqPcHNobmr+vQ79mGpc5cipsuHA/6Mz/VtIhreLvHXE
	qecb+o2pggQ6ezIsWGa4CtfvoypgOO6m2CZhm4zKlYON8dpQp1ujFSCL3J+fPpTFfuw6On
	eyxmN2AnYbde8kgEDfHYghpMlQoBYvA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JOBb7fam;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779955529; a=rsa-sha256;
	cv=none;
	b=fhVs5RVAXL9WRnVv6TgC0aVLVx0H5lWBCli3vmk+7yhhL+9QQCS7fZV7VlMakzEUO+zhxE
	dkYOHYmAwohd2ANUwduOmh7LCrI2uillhf8EYagGyR0w8wq/nzz7+e8riIIxYpGBPpAgxM
	4reLJnCDIGxYY1sJFSXt+KsbMeYpYxQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C752522EE;
	Thu, 28 May 2026 01:05:22 -0700 (PDT)
Received: from [10.57.93.112] (unknown [10.57.93.112])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7B4D53F905;
	Thu, 28 May 2026 01:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779955527; bh=qc2m1Ro4tsasKKh7m1ERSxkzDtjwNkTw7WOQcFs2l+c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JOBb7famIPNptjHwcOfdiS9+PoHZz/46QZ+nvB6L2cHKpDuU+BPPF+CJCpsgICZ/Q
	 47qo21i6t5dGT5rBtZqk+BMAi2prTImKC4R8XqCQ/zP5HHjZnZRrQR/uBPHSfibHi9
	 d9p1JXouhYK52CpfqUgq2kq9j4Qhl7TleZoeSApM=
Message-ID: <83d168c1-fed9-4301-8d0e-ffd133df90bb@arm.com>
Date: Thu, 28 May 2026 10:05:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64: mm: call pagetable dtor when freeing hot-removed
 page tables
To: Vishal Moola <vishal.moola@gmail.com>,
 Matthew Wilcox <willy@infradead.org>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alistair Popple <apopple@nvidia.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org
References: <20260521032730.2104017-1-apopple@nvidia.com>
 <20260521153130.d7d5cd060f7522f894252333@linux-foundation.org>
 <ahACfQ6kCfONqz5h@arm.com> <ahAjudlB32VbkKbG@fedora>
 <92450154-e1ab-46e4-b23d-eaa59c9cdd3b@arm.com>
 <ahW3QYiYjjVB4Knv@willie-the-truck>
 <423a2656-e1a3-473e-abeb-5e301c6f7c2a@arm.com> <aha5w_WRTmtb6O-B@fedora>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <aha5w_WRTmtb6O-B@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 110D418000A
X-Stat-Signature: ay4tyuwefkjk1r1s1jehz761f9mrgqhd
X-HE-Tag: 1779955528-735479
X-HE-Meta: U2FsdGVkX1/oVWigkym04EP0lTlcnVRfny67kutH42Np/ELHGNQidUox9LCYgAfSFfa2ad0eZi5NzFyztuiHWLahyrfIGATIyl9pOx/oE+hEp5De2Y+hFBsaVA4s75STjyTp2XD1JeJf6zOE6vx2a/G7s9rh4NRx8aww/rHv8QiuDmmumT9T8/xXNZktddln1JPCx03JJ3IsNMRumSPdAt+mCzCBDUYx3L83PyxatqG73UbpZqpr47uicS/zcqt3o8+b4NAI1Gr0aV6rt34vWpZkiLjZerKTupG1h/sFkIFRbZmMlAa88OBS9FbBfgzo/OD4WTNx0PZ2dkLkFDZlvFyvlgNWCMMHjluHSe5Cvudlm4bUT8yFe/d0KQ6by4qcay2jiIpm0eRJ01ZWLvlBB+a0XsczJN+ojHsMZrzOj7fbLdqINI5EixvNhBKF2k8RzY/4znujCxvSux2ILc7iFEsCrOJ/Zr/P+c4B/jRykGipZn+WXNeYGBvZRmnQq+baZ17DqUHxvW1s7IXJ16lM9f2BT8sJF/ljSTHc/bg/O97/aOV8d4hddKid9Gj7MhE/eVuQkqOZdePxOCooTKbv4YYqGWc5qreLEZIjML6Zz9kzrtzRv8/cwEOl5jWexexwS3ctjJJFSZQKrcVr0raJLxJxZbwfjmanpz5HTznhnDW8hYrecJ/F7NmjGjW6GjNsdS4ggpYHxo4oKWZgkIW6SOw1erGhR+rNbBXpIhB1xlS++4DNidyyUr1ZfJcaIefsyXvWQeuyQvovRj9LS2PikEyVbjOb74Px/AgOqaIFLXZY5GztCArFMwi/mACas+h2ewUFmT9onm9AGecA0lTo1fksCbMnKzNKUUVsQkFXI9iWybEctkgs6VX83NwV3ku/YwQTEYyj1auERnSioYTiyqVXazyUr0VMa/Wif7xn7z6b0WKLHjOvtG0X6hZd6q2sWNG1nAVtvNL48THTd7K
 TkEIFxcJ
 0IYGPL2WoSDkYl3GsU2T8oTdjNQIP4QtMAyp0x6okX+HwBucFP6/xXw3sCRvFPnVyzvCUdU6qvvdpUuuKdgptPuWKDKObfQ0yFZ3W+5M9ePGMjyShBMdBc/hp/27b6B2hcmPNGl9QoSYZt4Z35Y1jEfSNq2et3PhSKa5s+xoqS+R5f2J0MGIH5mKCg94R4MhTRxrotdppzw8Sqy0SatHF5yazm7YGc7aS42GIB+koyUkcxhgtYbUDq/AE1Woj3e/gWDgJWAZZlM4c5i/9Wm6sxW6Ba1eWXd36c7tX8dFSq24RPSQBPFzVoVYUCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27/05/2026 11:30, Vishal Moola wrote:
> On Wed, May 27, 2026 at 09:35:50AM +0200, Kevin Brodsky wrote:
>> On 26/05/2026 17:07, Will Deacon wrote:
>>> On Tue, May 26, 2026 at 01:54:00PM +0200, Kevin Brodsky wrote:
>>>> On 22/05/2026 11:36, Vishal Moola wrote:
>>>>>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>>>>>> index 4c8959153ac4..9d42cbddce27 100644
>>>>>> --- a/arch/arm64/mm/mmu.c
>>>>>> +++ b/arch/arm64/mm/mmu.c
>>>>>> @@ -1441,6 +1441,9 @@ static void free_hotplug_page_range(struct page *page, size_t size,
>>>>>>  
>>>>>>  static void free_hotplug_pgtable_page(struct page *page)
>>>>>>  {
>>>>>> +	if (folio_test_pgtable(page_folio(page)))
>>>>> This should work.
>>>>>
>>>>>> +		pagetable_dtor(page_ptdesc(page));
>>>>>> +
>>>>>>  	free_hotplug_page_range(page, PAGE_SIZE, NULL);
>>>>> In the case we presumably have a page table page (ptdesc) at this
>>>>> point, we should really be freeing it with pagetable_free() as well.
>>>> Agreed, I think this is the right thing to do, something like:
>>>>
>>>> if (folio_test_pgtable(page_folio(page)))
>>>> pagetable_dtor_free(page_ptdesc(page)); else
>>>> free_hotplug_page_range(page, PAGE_SIZE, NULL);
>>>>
>>>>
>>>> Strangely enough x86 calls pagetable_free() in both cases.
>>>>
>>>> My series protecting page tables with pkeys has a patch [1] to get
>>>> vmemmap to allocate page tables with pagetable_alloc(). The diff above
>>>> will require pagetable_*_ctor() to be called as well, but I think that's
>>>> the right thing to do anyway. That could be posted as a separate series,
>>>> but I'm hesitant due to the lack of NUMA awareness in pagetable_alloc().
>>> I agree that calling the ctor()/dtor() functions consistently is the
>>> cleanest approach and that will need something like your patch to call
>>> the constructor from vmemmap_alloc_block_zero(). Trying to elide these
>>> calls for the page-table pages used to map the altmap just feels odd to
>>> me, as there isn't anything particularly special about them afaik.
>> I don't think they're really special either, most likely they just got
>> missed/ignored for the purpose of ctor/dtor like many other kernel page
>> tables (until recently).
>>
>> I'll prepare a series refactoring that code then - that will also
>> require changing most arch implementations of vmemmap_free() to call
>> pagetable_dtor_free().
> Take a look at Matthew's series[1]. I think thats the ideal approach for
> page table accounting. He hasn't had time to iterate on it though. I
> doubt he'd mind if someone picked it up.

I recall this series. Are you suggesting that we would no longer need to
call the ctor/dtor for kernel page tables with this approach? That
leaves us with the weird case of ptdesc_set_kernel(), which is called
from *_alloc_one() while ptdesc_clear_kernel() is called from
pagetable_free(), but that's only an optimisation so we can probably
live with it.

If we go down this route, I would suggest we inline what's left of the
ctor/dtor, i.e. ptlock, in {pte,pmd}_alloc_one() and {pte,pmd}_free().
This way it is clear that everything applicable to all page tables
(kernel+user) should go directly into pagetable_{alloc,free}.

Happy to post something along those lines (patch 2/3 of Matthew's series
+ removing ctor/dtor completely) if that sounds sensible.

- Kevin

