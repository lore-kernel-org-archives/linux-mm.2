Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53F11CD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 07:35:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA7FC6B0005; Wed, 27 May 2026 03:35:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B57B86B008A; Wed, 27 May 2026 03:35:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A95AE6B0096; Wed, 27 May 2026 03:35:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 97DD56B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:35:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3E61016191C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:35:58 +0000 (UTC)
X-FDA: 84812390796.30.1F63130
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 75C7640008
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:35:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=e8mQOnEn;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779867356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LPGqASysxQ9lW9Lpvsz70pXUSRn6+VAlLH7uoaKEAbI=;
	b=DXtvzYAlxHgIwc2Ysnyp1EysUaR5WoD4UQ2CGgi/FgKiylBDSPW1Qwx5R6VYsnNiAQcfTK
	H9ndTfQVrBROlwGuumgocvqKKxf0CSxVheajtFveuyfnOh6ZYTBo/DmCeX6cbvjWLDoHM2
	EGVMgknBO7wCkBkELrhCE+vkedKfLD4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=e8mQOnEn;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779867356; a=rsa-sha256;
	cv=none;
	b=QVxFtBVbXjrws+CqzyG9qCueAfzLeJFaD9o2tO+hWwfeAjSlab7vlods+5prkjdGqpmHR+
	3PBjFSzwRbsf4WN28eXI8GypbNGtoVJPinUtD0O6xsDZdImTexM6OSTpmPalpTh/ANfFPt
	A3NeWZ7mKVrQz25MUARsNnqwN0i9d/8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8FF8027DC;
	Wed, 27 May 2026 00:35:50 -0700 (PDT)
Received: from [10.57.93.47] (unknown [10.57.93.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 616C73F632;
	Wed, 27 May 2026 00:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779867355; bh=PdNASjHzMFcTuvj2O7glLeKGsNZHbnvtXnjzn6isxgQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=e8mQOnEn2+oYphGx+uDlYnYs9VLRpw312YQn0n6jfNrmHENZB5GLwydumToXyGc+M
	 fs4ywuXgUPm+W9ui68dzf6q+eitrm/9SlD45ExCS+KUh0ulqDpc62NGqrAeQUKDemZ
	 aA9u3+ZbfAXqJdsCwQUVOPcq/KLO2WVJl5clNdDQ=
Message-ID: <423a2656-e1a3-473e-abeb-5e301c6f7c2a@arm.com>
Date: Wed, 27 May 2026 09:35:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64: mm: call pagetable dtor when freeing hot-removed
 page tables
To: Will Deacon <will@kernel.org>
Cc: Vishal Moola <vishal.moola@gmail.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alistair Popple <apopple@nvidia.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org
References: <20260521032730.2104017-1-apopple@nvidia.com>
 <20260521153130.d7d5cd060f7522f894252333@linux-foundation.org>
 <ahACfQ6kCfONqz5h@arm.com> <ahAjudlB32VbkKbG@fedora>
 <92450154-e1ab-46e4-b23d-eaa59c9cdd3b@arm.com>
 <ahW3QYiYjjVB4Knv@willie-the-truck>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <ahW3QYiYjjVB4Knv@willie-the-truck>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8yn9ipzxmfghsjm9quqruww1b4xoxj6a
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 75C7640008
X-HE-Tag: 1779867356-907230
X-HE-Meta: U2FsdGVkX199sJeFegQhMIb7Up7F/3o2ip2I1Yrpdq6UIvQBwBomjO0aSYJRvVWrqfnkU43wf1ZcHmzNN3zT2Y4EvMqjyrHwdhRJCw1ydpssKrvvG0DPVc1s/4eILr2mCZH8nT0oAmVwAAzBlmrwFOHwMPbEaqRjqoD9HxfiktxrZ797+JcKYoowg+6LzbGKdYTXDOHmreAHXgQBI/9c1UbfKk8jvaXqAjJs4pxXudnmT2TmMLGJRCidzgPZuZ1dxIgWjP/Z2bWY0vbYax0fcn4/e4aQHEFnOESq4UkuXKEHnfpMYoBUX6jks2t0exQOLczWzc2WMWQg+vLd5LsP2G82xHrenchkDV0MqIkTXtP3y1Btui2u5ZTUZMgRNZLHw1XQfw25DKNnw787u5clesN9GRZhfMei7CMEo+UaGjvgqOGe1ra5AwvUTzPBr9NNYJ/V45QY/umIolWZa5w0f5mFkaTkXXnBXEk2QD1IRO67RHYpBQNES60H7RbSNUOiM8zY4Sv/GVzp+owoOsYnov0w6xMBrpmoAzFewXg77BKdvTtSiEyc7MvIJM+6fvgMMMgZb6ZjFLhgxr4A0m4hEjUzJySlW1AXl96/XKsnFdsIb0G9PDS/UxzfXwuoqTuoYGfLKswfiT1BobGL7N1iKaIYao/EMUzIJ+7xFaG1wbyLWt07kfc2sS24T0sbdDr1t1zVy/tb+ffYB6Ni18RvZ9F69FaRwMO40+fe0TeDzGEeK5a9Hnupfys4hOAfMf+SefEMU9/Y0vCaj4Xt8waTHDf5lKnaR2+rOr2QICJkeemRULE+IK1K3jJyXk45LeOdc+It5U3DL742KjTjDnoZWg0VUYcg39k3KeDuw737s/qDlAJiTqZnTFlcFykJRpxVuV0BEMKDcUVeM5PmITkofXrraELiaIVlqOFyTr0BKyZBgJ1PvlS/8/CsehEKw6XMhMNu7tobsJ55yAPGr06
 EseOBCX6
 cnkhtmmvnCoJH1+bQGE1Mr17pmOuglAosycv1kkWAvfR8gXLobU7eomE///qYUd7qRTxZEhbmtKzEE0yuF8nB7sVYrxEW2phxOq8EZpsferSr8SBUzS4kOJp3G3OsK+URPyGP4W/5hXi8i8Nu6f2ojMHVDHNufIFl/y2Rk8/6Dv9iose+W3Lm3EQKuBI/ozHJuWnw81F02lSHLs4LYyXdB7pXRCCwoFTO1hBOZLMQ+japvMhWIUs3MOzvXk1fLjHavy0TLsljgm0EtA1TF0OcOTkdMbDujlCgALDbVUgZAKk2rmo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/05/2026 17:07, Will Deacon wrote:
> On Tue, May 26, 2026 at 01:54:00PM +0200, Kevin Brodsky wrote:
>> On 22/05/2026 11:36, Vishal Moola wrote:
>>>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>>>> index 4c8959153ac4..9d42cbddce27 100644
>>>> --- a/arch/arm64/mm/mmu.c
>>>> +++ b/arch/arm64/mm/mmu.c
>>>> @@ -1441,6 +1441,9 @@ static void free_hotplug_page_range(struct page *page, size_t size,
>>>>  
>>>>  static void free_hotplug_pgtable_page(struct page *page)
>>>>  {
>>>> +	if (folio_test_pgtable(page_folio(page)))
>>> This should work.
>>>
>>>> +		pagetable_dtor(page_ptdesc(page));
>>>> +
>>>>  	free_hotplug_page_range(page, PAGE_SIZE, NULL);
>>> In the case we presumably have a page table page (ptdesc) at this
>>> point, we should really be freeing it with pagetable_free() as well.
>> Agreed, I think this is the right thing to do, something like:
>>
>> if (folio_test_pgtable(page_folio(page)))
>> pagetable_dtor_free(page_ptdesc(page)); else
>> free_hotplug_page_range(page, PAGE_SIZE, NULL);
>>
>>
>> Strangely enough x86 calls pagetable_free() in both cases.
>>
>> My series protecting page tables with pkeys has a patch [1] to get
>> vmemmap to allocate page tables with pagetable_alloc(). The diff above
>> will require pagetable_*_ctor() to be called as well, but I think that's
>> the right thing to do anyway. That could be posted as a separate series,
>> but I'm hesitant due to the lack of NUMA awareness in pagetable_alloc().
> I agree that calling the ctor()/dtor() functions consistently is the
> cleanest approach and that will need something like your patch to call
> the constructor from vmemmap_alloc_block_zero(). Trying to elide these
> calls for the page-table pages used to map the altmap just feels odd to
> me, as there isn't anything particularly special about them afaik.

I don't think they're really special either, most likely they just got
missed/ignored for the purpose of ctor/dtor like many other kernel page
tables (until recently).

I'll prepare a series refactoring that code then - that will also
require changing most arch implementations of vmemmap_free() to call
pagetable_dtor_free().

In the meantime we should probably use the logic above to avoid the BUG
that Alistair reported.

- Kevin

