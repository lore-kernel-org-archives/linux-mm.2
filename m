Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36CE7C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 05:33:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F00D6B008A; Tue, 14 Jul 2026 01:33:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A0F56B008C; Tue, 14 Jul 2026 01:33:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B65A6B0092; Tue, 14 Jul 2026 01:33:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08BE36B008A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:33:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 78A1C14025B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:33:45 +0000 (UTC)
X-FDA: 84986265210.24.67BD4C5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 542821C0002
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:33:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FSOAa8YN;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784007223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mfTl3GQoSyoFUEnmuQBsyrvcEduJvtBv+v98cbpDZBc=;
	b=C3p2pas1dgYE8LuxJDoS4EzJkY8xaaQbF0Dw27tH2AIaxFo8DiZPbL7uaYKyKHQpvmP6mC
	B+cViIVBF85hH2wMYwZmXjl9txZ9YvhZqo+mCE5qbTRuChzrC8dTJ1450tbkj890aHWkYL
	BTfo8r1hgsprbrLFTkE1qYXldb0BoS4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FSOAa8YN;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784007223;
	b=oKaPijLxLtkWJqbnBhdZ5omoY1TSDJGpPq2+SlondcUyrWyYxRz1Dnphj7lusbzqfkGQt0
	OpChznMywJCv5i3l3KIoIU2XsB40dGdScf/0fFTBQCMaAARHgkFzzZ78j3qMg2YJlgR5Pb
	ijk/igebq3zolFXrb8wEZe5Vr+/vrb0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2A4AC339;
	Mon, 13 Jul 2026 22:33:38 -0700 (PDT)
Received: from [10.164.148.52] (unknown [10.164.148.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6FDB83F7D8;
	Mon, 13 Jul 2026 22:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784007222; bh=hccglgIXGsjwDzVnD98+WSP/z7D0qxzcLTBTl50S9mg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FSOAa8YNN3CVVYMjJlByEEDvCp3N6RiO2oahs9L5zy3NLSdL4eotRZOOzLXBgsR6c
	 QeIYYS2MnJjijJddDjToSP50t6vArkTP40fqUyhWbBaoCbjr/zmfwyDXdqfoJjJoEn
	 U6REtT/KH2W5L1HtBWEbunXMgohTA6E6QD/jFSyw=
Message-ID: <a9fe7408-8607-4115-8f2f-75ec9b5a4b21@arm.com>
Date: Tue, 14 Jul 2026 11:03:34 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 5/6] mm/vmalloc: map contiguous pages in batches for
 vmap() if possible
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org,
 urezki@gmail.com, will@kernel.org, Xueyuan.chen21@gmail.com,
 ajd@linux.ibm.com, anshuman.khandual@arm.com, david@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 rppt@kernel.org, ryan.roberts@arm.com,
 "Barry Song (Xiaomi)" <baohua@kernel.org>, Wen Jiang <jiangwen6@xiaomi.com>,
 Leo Yan <leo.yan@arm.com>
References: <20260709073823.6643-1-jiangwen6@xiaomi.com>
 <20260709073823.6643-6-jiangwen6@xiaomi.com>
 <aa5d2aa2-89c8-4b6c-9a28-5c22143277b0@arm.com>
 <CAHKocdG7iO=S+pZLSs+mYO3GmVC_WvpC0V_1Tjj7RZ-YxWVh_w@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CAHKocdG7iO=S+pZLSs+mYO3GmVC_WvpC0V_1Tjj7RZ-YxWVh_w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 542821C0002
X-Stat-Signature: zarn8wwnzqaji37t914x4nee7ojqu6pk
X-HE-Tag: 1784007223-97343
X-HE-Meta: U2FsdGVkX1+yJduriLGk6tWDIGw+otbsZSdmmrELbRwyaUe4KGube3aF4zTppTjPxHiWxkWZklFEItjSoVuZRtNClz/7WFRVx9TRDsTtWLT94MXkyGny+7h15ggg1PIM0yBCs00dR/Hw+n3Jmgi0WYF3dzUggMzoHSfSI6onRh0a/i/ZSXPbfrpSFplq2ySd6Jx6Ox4PAeE8haRpAreys2F7iMfrJrSa8HsTMxOURCsNBIaQ1Zcv9W8xodojRL9ycONl3rm+G+Xjn03a3v1QIeRobBPfRet95wZm0BpwouYw9xNif92LRM4ncUWeLgD4EJnRrsnRXVglohjWhbyCb4lFMjBhn/KTxS3ei1hHUhNs37tHUTjE6luO/y49uqPQooDeAH3h8pnMzu2o/Did6zkTMghADHGKkN5hrZqEXm+xa3G/28wHNiIm3cIYl4R5H3zSSfGqo0A2nN55YNKDUfRKdbRHMjIWkgZsOBLqU862nuzXx9qgNNO5A9J4xMboy1tBp2FsuAB14yeYIyzSCWIkBzwYw5aHayAS6Taf4T3R1qjQJUGjlu03W5jGtxhmf1lL/ksFpWfP76D2cs8kWgftlsOMouyv2ySOXEtUIbnS96PV47vuRfOxPJtU+4mgMseDpauWqjWmKr8NCZ6QEJtAgTd4s0Kfxj8DpOvOhnD8dTZg1Gr8icc3X4cYN6/3mnRBu0Xm9S3DJISMhqflAhqzb2pA+gBO/uBFoqFGHoLM2aBuDVnWd6mthWF9HMwhcdaeDKSmNe1cV9wVHWJ0z+LE/W82+TfuwG9D1bwGfZ+hGWYTS1e0siN1ervMT5BKHkcquD+WRrS/09f5i9HjD8aoZw00Wx0NULNGdIs3tAUI78MPHedvoQLIJm8YL+H4dd29QpDg3ro4fuSsFLFakrvDP1awLzzyN7gq5F2JdXXsDq0TbMLqgP2yqp6u9CBaJq3MFE48sc/cmGviI5F
 EZDw5rkB
 F98TxKGuxxUqwzJaz+xuRbfYyRVARAu3uhPyeYDFjaum71zNtMHYsToijZ7C7lMna7T+NOoCbYfyo2qso8PIKO1V86/+eci/q3Z+V92pOxbPY5OAi+jcEZTG2g072rYJceGcH1hhwpMIjbbB9e96lrWyu32mkEBqTIRbzR8Xiaxhxwf4ahUIemgZ3aT4k3FcQHWRItMz/4jRmfVMOE4r43N+8vWY2FG5PsWPAmAPpkOp0P/XQKevSdtdokUy3gX0oDdMdhpjX2H4ZvZsPp3S/9Z9XaQhCcfkzGvTkqgoWPuTqlorBXh9EI70iG0ZonC6UW9+f13zICG0bte6xsumL7XiAw+iEmKfwppiCdT17eiZHMJY5dpaQPF1DdYmt+TMjgqZFMs+MIckqR0Taaat1iGiwKMmwaPLEdtE6qiEidCD589mpcY/Ip9I/wnpukby36UqMNdJUIRjBqbM0t73vXNbBog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 14/07/26 10:46 am, Wen Jiang wrote:
> On Mon, 13 Jul 2026 at 23:19, Dev Jain <dev.jain@arm.com> wrote:
>>
>>
>>
>> On 09/07/26 1:08 pm, Wen Jiang wrote:
>>> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
>>>
>>> In many cases, the pages passed to vmap() may include high-order
>>> pages. For example, the systemheap often allocates pages in descending
>>> order: order 8, then 4, then 0. Currently, vmap() iterates over every
>>> page individually—even pages inside a high-order block are handled
>>> one by one.
>>>
>>> This patch detects physically contiguous pages (regardless of whether
>>> they are compound or non-compound) by scanning with
>>> num_pages_contiguous(), and maps them as a single contiguous block
>>> whenever possible. The mapping order is determined by taking the
>>> minimum of the contiguous page count and the pfn alignment, allowing
>>> graceful degradation when pfn alignment is less than the contiguous
>>> range.
>>>
>>> Pages with the same page_shift are coalesced and mapped via
>>> vmap_pages_range_noflush_walk() to avoid page table rewalk.
>>>
>>> As users typically allocate memory in descending orders (e.g.
>>> 8 → 4 → 0), once an order-0 page is encountered, we stop scanning
>>> for contiguous pages since subsequent pages are likely order-0 as well.
>>>
>>> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
>>> Co-developed-by: Dev Jain <dev.jain@arm.com>
>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
>>> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
>>> Tested-by: Leo Yan <leo.yan@arm.com>
>>> ---
>>>  mm/vmalloc.c | 87 ++++++++++++++++++++++++++++++++++++++++++++++++++--
>>>  1 file changed, 85 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>>> index d2a4d649af549..db0492151ad08 100644
>>> --- a/mm/vmalloc.c
>>> +++ b/mm/vmalloc.c
>>> @@ -3543,6 +3543,89 @@ void vunmap(const void *addr)
>>>  }
>>>  EXPORT_SYMBOL(vunmap);
>>>
>>> +static inline unsigned int vm_shift(pgprot_t prot, unsigned long size)
>>> +{
>>> +     if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE)
>>> +             return PMD_SHIFT;
>>> +
>>> +     return arch_vmap_pte_supported_shift(size);
>>> +}
>>
>> Need to throw in a preparatory patch for this, which will (in addition to
>> introduction of the vm_shift() function) do:
>>
> 
> Hi Dev,
> 
> Your suggestion is to extract "vm_shift" into a separate patch, say
> Patch 5, to make it a common utility function just like Patch 3. And
> move the existing code that can use vm_shift into this new patch as
> well, correct?


Yes it will look like the current patch 3. So before the current patch 5,
you can have a patch introducing vm_shift and making the code chunk
in __vmalloc_node_range_noprof() call it.



> 
> Thanks,
> Wen
> 
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index afaa14ebf17bb..dac87e1cd484b 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -4175,10 +4175,7 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
>>                  * supporting them.
>>                  */
>>
>> -               if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE)
>> -                       shift = PMD_SHIFT;
>> -               else
>> -                       shift = arch_vmap_pte_supported_shift(size);
>> +               shift = vm_shift(prot, size);
>>
>>                 align = max(original_align, 1UL << shift);
>>         }
>>
>>
>>
>>> +
>>> +static inline int get_vmap_batch_order(struct page **pages,
>>> +             pgprot_t prot, unsigned int max_steps, unsigned int idx)
>>> +{
>>> +     unsigned int nr_contig;
>>> +     int order;
>>> +
>>> +     if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP))
>>> +             return 0;
>>> +
>>> +     nr_contig = num_pages_contiguous(&pages[idx], max_steps);
>>> +     if (nr_contig < 2)
>>> +             return 0;
>>> +
>>> +     order = ilog2(nr_contig);
>>> +
>>> +     /* Limit order by pfn alignment */
>>> +     order = min_t(int, order, __ffs(page_to_pfn(pages[idx])));
>>
>> You missed Sashiko's point here :) the pfn may be zero and this
>> will blow up. You can just first derive the pfn and do the clamping
>> only when pfn > 0.
>>
>>
> 
> Will fix this.
> 
> Thanks,
> Wen
>>
>>> +
>>> +     if (vm_shift(prot, PAGE_SIZE << order) == PAGE_SHIFT)
>>> +             return 0;
>>> +
>>> +     return order;
>>> +}
>>> +


