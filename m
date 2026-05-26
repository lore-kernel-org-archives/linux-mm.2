Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 575B9CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:54:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 997CF6B00C2; Tue, 26 May 2026 07:54:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96F526B00C3; Tue, 26 May 2026 07:54:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AC276B00C5; Tue, 26 May 2026 07:54:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 752196B00C2
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:54:10 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 28D1A120398
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:54:10 +0000 (UTC)
X-FDA: 84809412660.28.50A9DBA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 547AE100009
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:54:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gLe2m3Yc;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779796448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hDpo1CN0RJTEn2WPF2oB4CNFhnk25tcXiAZ3ssn8QRk=;
	b=W8E5rG8sYox8kem0nkzqKXIP+F7AoU5C9ickEI9IbhbXe6AaL8YAlRaT8J67LwEI7aNdB0
	OKl+es83XkzNRKj259Dla0sWOB4TZTZXqMX8coKQ71YCKbL37MBn4LdIl++K8rg7hpilgW
	mZ2CwIkoILJWAUBIFoz5W3MsBXSFuFI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gLe2m3Yc;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779796448; a=rsa-sha256;
	cv=none;
	b=etnBVyZ3rngt6yxhVK1lkZ+3yl14OTK6W8vwgB/l9l/FhRNbdpuq7gOLBK22oPE6TRfWUC
	F4GMtY3xAdI/RNdNT9o6ueWiUJKhZw1t1SuPBzBcBF02V7xNs7BMfD6IQDD+YXhhYz3pBv
	CU1fGVQgV1IJSUt5f3P6KTkSD6N8QVQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 51C1E169C;
	Tue, 26 May 2026 04:54:02 -0700 (PDT)
Received: from [10.43.20.71] (e126510-lin.lund.arm.com [10.43.20.71])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F78B3F7D8;
	Tue, 26 May 2026 04:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779796446; bh=HhcY4TG/6pLCS5ZpzHLBZkS5pauDzOZDzxzLR0+SqjQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gLe2m3YcfahXbF6L9I64v0GrkoUwaoSfBtFJPZh1Es69i5BTm8ud5+HoppYSxqF8x
	 xLrCWMqIkpVaBF4B1n5RlLbhQzwDaIwvIOQUNmMRZSZ37egc8hXFdCi7nuyyQJ/M52
	 IpRd39A1PTh7+YKNFNiYx9CT1/TsMBBprazNAgFk=
Message-ID: <92450154-e1ab-46e4-b23d-eaa59c9cdd3b@arm.com>
Date: Tue, 26 May 2026 13:54:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64: mm: call pagetable dtor when freeing hot-removed
 page tables
To: Vishal Moola <vishal.moola@gmail.com>,
 Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Alistair Popple <apopple@nvidia.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, will@kernel.org,
 david@kernel.org
References: <20260521032730.2104017-1-apopple@nvidia.com>
 <20260521153130.d7d5cd060f7522f894252333@linux-foundation.org>
 <ahACfQ6kCfONqz5h@arm.com> <ahAjudlB32VbkKbG@fedora>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <ahAjudlB32VbkKbG@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8zrzjzhoxrrwdzqir3u6uo33n33qqjhe
X-Rspamd-Queue-Id: 547AE100009
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779796448-831236
X-HE-Meta: U2FsdGVkX193wWy90Obzx6SuCv9zVFtA+KvzQbZn4Dxpe2p32oK2DyeHcde7zixv9VVAOsP31GeI4ZCqkw361F6qomM1Vw01iD3oawx8ulh3p+czpw5yPr0MdNlH60mADMNI/uznRHZO5YFwBzxp/t5SvGU8kkrYl95Itocvytnn859gLjIqRI9H7Qb9JOx9ykvNManzilLbd+8rAcLOFxXM3N84RXyztaIjKMyRHa/c1r2DE6kmdlepTWTmwln3EoosksNPRJhbN4toX/jj1kzICdglfF8fzazyi0FeMPW9dFhyMhS2Xnhyvp46bTp13cH3JGZfXLw6hPmWisoiOK4rF5rmiVk0yJ6GMwBv5OB4LAMhWTNtkf0JHyXyQWWFfmdRuj0giuiYjoiLVPuKd8biZBEUXceaXMy88Cz6SR6c6TCz36w9rVf6SjGhQYwzOvoQ6JDq3q2BH4caCGITSKJQWMLl5mp8PnT07BG5RoGF/sXfEYZCGjqejVLSCmHv8pdgijgfMa2LpqDR4W5AuUgCdxpcK82DwjBR98zk5Wx3O3sYNKZHTDZgDq9S2V6z8w9T1mJJ//gKAihKKdPn8tFMsHlTzdRNDAWyBB89dyNk4pj73VFzbsjFa9+NN3m6G8a0jNHmtviI52YkFi4b+5TYLnTh3kU0b2GBsmiMJ0B+/sGXAF152nojfbUFgp4EUzZUj5MJ9D6PH8pNWEs6r62Cu2lnNFP+3YiIDVgMKjWVLgncDBF/MRnL7zGFad3FYFYpqeM9W3k8rnysufsc871+b0U7BXSw+erZGgrDr1fa+7ABn+ZWTLTYJY5kMONa6OTE01XrOawpFle1S6TIiqNtuNmytkbC8mQ5zqp+2VXpVNsuGHAhXDwTfgoHijATK3UtW1pC2ZOHj4mrSeyRmLJLDhEL775dZrXuC8bfanV7wABm21Pc8wocBaNhbzbsxZTcf/8AkTWQ3amRVQe
 3tWh4YhR
 FPytRNO4Aw9kIHrH5pwQnPYtZH9HZ3/6JuU8OaeVw3fC6pyxTF24zTIiw3cTU8FXj6BUML41SyaBv0XeiHeYh7CnueWXu6azUn0eP2Kqx+wUvKQro/6VNkNDIG3eiZLuPkvxjvB7ctK9ANJRl7oSpSCvn0hkbV868xI9UXwB6hjCGlsd7kASjiKv7ZMsZU1S0trK39yU0X0jHYGhGKwlld6iXMg59OJ19uzDg0PV8iYMLXbivdBnFzUFW9ETDrYIvKxX9tBgs0k2X5DEekqnndw35AFMHQaO4/ipZpp3xilDh5jB8INuCXkN6eI0FM9r260rpvfA9fhPQKSnu2m6rK2VcHELVWrr2UJqW2L6ad2bz+TULjkLaTJB1N7b8RcR6nLQL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22/05/2026 11:36, Vishal Moola wrote:
>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>> index 4c8959153ac4..9d42cbddce27 100644
>> --- a/arch/arm64/mm/mmu.c
>> +++ b/arch/arm64/mm/mmu.c
>> @@ -1441,6 +1441,9 @@ static void free_hotplug_page_range(struct page *page, size_t size,
>>  
>>  static void free_hotplug_pgtable_page(struct page *page)
>>  {
>> +	if (folio_test_pgtable(page_folio(page)))
> This should work.
>
>> +		pagetable_dtor(page_ptdesc(page));
>> +
>>  	free_hotplug_page_range(page, PAGE_SIZE, NULL);
> In the case we presumably have a page table page (ptdesc) at this
> point, we should really be freeing it with pagetable_free() as well.

Agreed, I think this is the right thing to do, something like:

if (folio_test_pgtable(page_folio(page)))
pagetable_dtor_free(page_ptdesc(page)); else
free_hotplug_page_range(page, PAGE_SIZE, NULL);


Strangely enough x86 calls pagetable_free() in both cases.

My series protecting page tables with pkeys has a patch [1] to get
vmemmap to allocate page tables with pagetable_alloc(). The diff above
will require pagetable_*_ctor() to be called as well, but I think that's
the right thing to do anyway. That could be posted as a separate series,
but I'm hesitant due to the lack of NUMA awareness in pagetable_alloc().

- Kevin

[1] https://lore.kernel.org/all/20260526-kpkeys-v8-14-eaaacdacc67c@arm.com/

> Its not a big deal that we don't right now, but losing track of the
> matching allocation/free sites will become a headache when separately
> allocating from struct page.
>
>>  }

