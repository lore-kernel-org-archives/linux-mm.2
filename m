Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46DA2CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 07:34:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE23D6B0093; Wed, 27 May 2026 03:34:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB96A6B0095; Wed, 27 May 2026 03:34:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F6C96B0096; Wed, 27 May 2026 03:34:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D4DD6B0093
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:34:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3CA0D40525
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:34:28 +0000 (UTC)
X-FDA: 84812387016.24.BD10CFF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0A98A10000F
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:34:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lhpGYhy9;
	spf=pass (imf14.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779867266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AWcI+z0XH0AfAPpv/XGcENdcfelIfuJvkL3Jp4qgI2o=;
	b=d7IJwbrItI6JwZXEOqLoTgAS3anBMhnRYTHaYI/ObRnqk9h+KgavA3YxvpC2AAxRY1ni6m
	g019mSFMOs5ID6lDMWfx/pxdTLV3SNG/UzHmieYyDsFLVQ26dAk7PDyah4JBcVTOhY3otK
	Ld15Zyte3SBh4VxoqGxCPNxyfrt855o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lhpGYhy9;
	spf=pass (imf14.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779867266; a=rsa-sha256;
	cv=none;
	b=w/nzVcrxWCCbyXwTJRKUqvhLbPkog9FMi6e17kCWm+UFLkMn6M9PgiSCXVMSARDCpW2EWw
	BYuKziu/EAacP1TYOTIANJV6WSWmDjMq3iubhiDo5uDxuNmaO7gwpzqVg2Mx7ulAHXTBO8
	uuSgDN7SE3jgy0jbd5Hmgp/9L3IjGnE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BCDA827DC;
	Wed, 27 May 2026 00:34:19 -0700 (PDT)
Received: from [10.57.93.47] (unknown [10.57.93.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8928C3F632;
	Wed, 27 May 2026 00:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779867264; bh=HVqcxI1GFbCS7c35naKWqhplQ5379bUFtfju52VKNUI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lhpGYhy9mzLM0aQ1LmEdrgC7rB9SgaM2E0euQSb2IyT0zWRqzHJdbHCQvPWYTWPEz
	 P7TxGZIzx/4bnsXReJ1v8DM+/x5k4r9aS3DnmQY5y6dTDxqa0kFbXyRop06qe/gjVs
	 u16UwYDXRXQBF7Yv8VbCdByU0IIzdtVpVZ2FuHmg=
Message-ID: <db11078b-a283-4717-bed2-da56e77c7132@arm.com>
Date: Wed, 27 May 2026 09:34:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64: mm: call pagetable dtor when freeing hot-removed
 page tables
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Vishal Moola <vishal.moola@gmail.com>,
 Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Alistair Popple <apopple@nvidia.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, will@kernel.org
References: <20260521032730.2104017-1-apopple@nvidia.com>
 <20260521153130.d7d5cd060f7522f894252333@linux-foundation.org>
 <ahACfQ6kCfONqz5h@arm.com> <ahAjudlB32VbkKbG@fedora>
 <92450154-e1ab-46e4-b23d-eaa59c9cdd3b@arm.com>
 <1be38262-53de-4a27-9841-393e12fc1475@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <1be38262-53de-4a27-9841-393e12fc1475@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 7jneykk9eoaghx4g31ha7tfwpbfqkth8
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A98A10000F
X-HE-Tag: 1779867265-515124
X-HE-Meta: U2FsdGVkX1/sawoE2j+zjfJctXCrc7vNkWGkEtaeH7rxe81VxOK/Z1rPejbP+gB8GIhl5f6KheHggv9l6Z8jCIQgQpZHH4b6i8nJas3oJVaAwSS5i3KfpTD2QnpZ8UkRgD3lD+OJ/V4SCxTKANHj493dVqIHG+4wFEalk0mZ+rI+Yjngq9Q6s/5Ji0SlGEkU7HbJqNxWoBAj9sR7bYelwWMPClR8bLNS7L5RixFuQNqp8tXLEJ6TXszbRr/k+/m6n68nFwtoQ+FvBUWllXAUslHLLaH4qS21kcpR8HYRV9134LdDJXJcgYcmhtxPry6ZYQEdNIZHe2DaO0uyqEO4VKazh+8akwSjCWYGPs3tgsf6oIE1oea8O9FCTey1qOYCy4wDBqamJDoEAaumT2bd6a7YjD8xmU5K72lMlZ/jStj6d4zQaGLifERKKst9wzaWYJvCEKBdNUlkgbcvfXdKBMmiTkObd5/g8pJwEBBy4kLQvj4kcn6yhIkb8g2/i0WkZVpmVBGdcFFUPi07T+4lU1vrrNzedZBBYhvy416Ez6P3LZC8W7NFj/j91Dvkv/Ro/GYxSs0V1k8hH3nk9nD3okXXodPfsH7A/3zmKbpoWVsg0dtdmV4StArptIXfwZfv7Yo0fxaxU1hxFkRDRR6o9oyZYM6CFJ4Rm7+03PSQlcwa1MBAhnQW4t048Iu/oIt2TZY5VcYrkh6ZVnNnva0zvsd2PIgnjlKp6zyeMpsNns5sAA6Vx00aqpUlCfqH+ozk/v/eLNPdgANnDZrUmdSY2cvZFJX5kCN8Yknuw5CnwluyvQL43xcoU5aSP3mE6SBrC94yCopCZJ8/tIlbI3xJQPpi3U5hRmIsKTRXhHyma4f8J+cJyrHkMXOZTqkn5maxNrrjyyakGyUOM26P97HFw4PfIn4lRDQ19UatL8h5gQCJd8QZo8EcXARYPYjU0GVpuHMzCpSif5Sffr4Zpql
 73YEqOLV
 CTyUkdGK58sYIAaGYG0eW3JHWKiV4hKLSd0DdV+qIuKxu1owLrWf+iRy2gncr6ajFPcDwpX+eDWj/7nwLn5EYSDNzUOWJCRhSqhy/i1mueRM4zKeRom0hyoaHeGN7cIGfLW2ChSizyqBHeid5Z6kEkHV0qyrIpTtLl1Saw6jzt5vW5/Y/2a1bL69Uo51fi/ncKpDjbqEN+wnEqMMibgZNpDUGuyB7envFToSdEVmlO2J+UGJLpowc61WlOvBR6ZAIgfIugC5yOxXIDsPosEhkwluyFI1cIeq/rH4kBUllVhsHM2opQZsMB4oK/P/RjAWivlBQjWy3pVB3hkTjfawX6o+rkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/05/2026 14:31, David Hildenbrand (Arm) wrote:
> On 5/26/26 13:54, Kevin Brodsky wrote:
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
> That code pattern is wrong.
>
> folio_test_pgtable() shouldn't exist.
>
> In the future, something is either a pgtable or a folio, not both.
>
> So check the type against the page, not the folio.

In other words use PageTable(page) instead? Interestingly I can see a
few calls to folio_test_pgtable() across the kernel but none to
PageTable(), maybe just an antipattern then? The ctor/dtor also use
__folio_{set,clear}_pgtable().

- Kevin

