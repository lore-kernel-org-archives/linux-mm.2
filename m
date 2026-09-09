Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8FB7C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 11:31:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 025356B0096; Wed,  9 Sep 2026 07:31:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F183D6B0098; Wed,  9 Sep 2026 07:31:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E55E96B0099; Wed,  9 Sep 2026 07:31:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C54036B0096
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:31:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 139D8401A6
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:31:17 +0000 (UTC)
X-FDA: 85194007794.08.29E6260
Received: from mta1.migadu.com (out-83.mta1.migadu.com [95.215.58.83])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9DEA61C0009
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:31:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SEzxv1an;
	spf=pass (imf21.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.83 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788953475;
	b=N430LsDQ7pG1lIMv/QPqLQZ/izKJ/HsZ17lio6SVrbtZZNf/J/6NWA1mQoEmFYihUzDHK4
	ITt4W/9linDXLSUblryjATuR63mG4a+MYice02bObT6Qb8MIFLKmloooQBGbQRgYm7t3ox
	lHo35BZUKlDg35O4ncKe0UX2/TWXW6Q=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SEzxv1an;
	spf=pass (imf21.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.83 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788953475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7O1DYKdfpuSYXerAjKYjRazaDbfgp5Jcrp4AJih2MTk=;
	b=ziKXcsa5I25bPWOvfOoZShND2HiYqv5ob0LJub6Sf/vxzVt/HUYeWIHf8nMLLjDSQIL6as
	yZJsJY1hiBcqhIB9MrznyEZQwZ6QnfJFik1cdFk64QOZ5QGfHZRhFvzOfzGR701hyJwq2I
	LzfQqMYmtO1G/P108yiS/TKvmmUwd9M=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9HOsj4bih3CqIQmvANIElp6oKbMbWWKSe38JZT060/w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788953471; v=1; x=1789558271;
 b=SEzxv1anCVqI1MluofqeJQ8J/yYHtOlV/yNwkuWtBtRBNoYo6Gr0mXzmLlWknGgpGwVtFPIj
 t29iNPmlfJvua6EQcuCQF30ndnMZs976/fSPnzVXYj5hKVgClth04uIqODBtQIu+o98kRo172E4
 t8zxOt9mLGccOROEoTst3RN8=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 5a4d81d9a7ca1752;
	Wed, 09 Sep 2026 11:31:11 +0000
X-Mizu-Trace-ID: 5a4d81d9a7ca1752
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v5 03/17] mm/mm_init: skip initializing shared vmemmap
 tail pages
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <c465c8e8-c789-458c-8053-4f0db90069ed@kernel.org>
Date: Wed, 9 Sep 2026 19:30:50 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <3047F607-7A16-4D7E-B0F1-07ED795EC1BD@linux.dev>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
 <20260825084608.47437-4-songmuchun@bytedance.com>
 <c465c8e8-c789-458c-8053-4f0db90069ed@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9DEA61C0009
X-Stat-Signature: 9y1fxeybaotjqk3du9wdiz7i3taqm3pg
X-HE-Tag: 1788953474-105998
X-HE-Meta: U2FsdGVkX1+zLR3o6wiSpUnMonlVBM/X47qPqpw218DRGqMeR4KS2yBrwlXIqmWMQWgASXKkz9oPyU8eqJNinoGOmOLPLaDCLsj08+2eBv+NB8f6uN/OxiGuwbrCHEAPOWLgVLFqvKVZltVVTxCzVve2bCt7IokNdYVjZhWnQ3cKe7UN9wY1g+pJIP22cXGPATIHEREMbAxeC9pnQ90K473yLBRuIqhdGF1/5EzA7kjc6I4zFF2wwNuK+RcxaaGcqpjLWb4csGLIHkDeX4SqSzAcc+O0/Tj2jKaU/2i39dUb8uxJjmS7xQUnpiKCRYV7e8ieNHXUhW6whF6nzqeaqvuQOrak0CgRcWuVz7CJhKmQkpzSZhjZ6F0KU2+9ebWdSePXbABAB/MTmvxGswEYI1Mc+vAI1V5I9Y5+xcK9e6rzUkzY5fy/tHrI5FuwE4rNhWPyRToEoyfavGix+6Dy6yPeehNUNUZ0SePMS8LyCPLjpz7L64y3WWwj55kYTvb28Ar1fLT34PrpgZfl4rtg3Ny0c9rqWxTeZbGC2eqLNJrW+K3x1rQ1rXbcY/YfYrGgrK+4VqzAS7MyNThrx5KYQQGGGtI46uuA0U2g+PaCkBgcscjA5O0yOupd+f80fMNF3pSexnAb9/oPGPG5RVRpXCgNufcKWUokHuPOdAN+ffSzjQDDbmdat9dEFgvAZxs/8yZecqws2G8phI6GeTqD/l0L1//FGF27HcKYJIhLFzlBsc+pgsJq587jFBHQYWanhAkBSpY+Wc3EwaaT/WKseYq1SLU1itEfZeU8Sj2GKJQeyWJkYJVL2b1PtBNdOqduwifNlkNp9noJlYsxfTXH0+hhTVG9iYlMD05jXyfUT6FMurwvsh/Y6ifI5eWPqghkUu7mAAyGbKreAmYN73DGp26STMmthO2iFYcXr5hAFH+gzZ9+jSyJMec6Kr3bBXpI/t1U8UG8a3rps14YBc5
 EgESzCHF
 X81aPajv42z3x1c1cfXKLcWqh2AzbZh5DrqkR927EfPvYZuz7Y67GQ8zzcWspWW3m5SoJaJU1xxipEXzJa//1oapBcBw7zojjkb9zThBt5dW0m7H5GmO7v8ttsic/8KM52AXtpM+2lRmQOoP6iRZiUtNdXoAyIpRdi08auyN8qKuwnI2AvpC+/lhZZaPOfm29+1aSWoLES0Ij7WAM+96/KqvqjAoK37TOGoglWnEt9BM8FMxtyEJGHmJfUKyEGzHeIIOLLJ7AMvTxoGw28knteFrLK5ucHnjXynGindUgoSu6xzq+OguSCUQ2gK1D/xYvc8SxmhvxhTksj3JiR4+30Ky1GBq3CDDIMxvbYBCcgCzA7HZblLcpoussvBoB0Ex+1cHGOal0vHZqXDtLYn7jb45DnSdItAae+iQ1w++P4hIZSSpXu2flcYmlHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 9, 2026, at 17:36, David Hildenbrand (Arm) <david@kernel.org> wrote:
> 
> On 8/25/26 10:45, Muchun Song wrote:
>> memmap_init_range() initializes every struct page in the target range.
>> For compound pages with vmemmap optimization, the tail struct pages are
>> backed by a shared vmemmap page.
>> 
>> Initializing those tail struct pages would overwrite the shared
>> vmemmap page contents, requiring users such as HugeTLB to restore the
>> metadata afterwards.
>> 
>> Track the compound order for HVO-backed sections and use that metadata
>> to detect struct pages that fall into the shared tail vmemmap range.
>> Skip those shared tail pages in memmap_init_range(), then initialize
>> pageblock migratetypes for the processed range with a helper after the
>> per-page initialization loop.
>> 
>> Keep direct mem_section access inside sparse helpers by exposing
>> pfn_to_section_order() to users that only need the order associated with
>> a PFN. This lets memmap_init_range() skip shared tail vmemmap pages
>> without exposing __pfn_to_section() to !SPARSEMEM builds.
>> 
>> This is a preparatory change for consolidating handling across users of
>> vmemmap optimization, and it also avoids redundant initialization of
>> shared tail vmemmap pages during early boot. That early-boot benefit
>> appears only once HugeTLB is switched to this common handling, since
>> HugeTLB is the early-boot user that creates those shared tail vmemmap
>> pages.
>> 
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> v5:
>> - Add comments for pageblock migratetype helper callers and shared
>>  tail vmemmap skipping (suggested by Mike Rapoport)
>> 
>> v4:
>> - Rename pfn_vmemmap_optimizable() to vmemmap_optimizable_pfn()
>>  for consistency with vmemmap_optimizable_order()
>> 
>> v3:
>> - Replace the !SPARSEMEM __pfn_to_section() stub with
>>  pfn_to_section_order() (suggested by Mike Rapoport)
>> 
>> v2:
>> - Fold section order tracking into the first user instead of keeping a
>>  standalone API-only patch (suggested by Mike Rapoport)
>> - Rename page_vmemmap_optimizable() to pfn_vmemmap_optimizable() and
>>  pass a PFN directly (suggested by Mike Rapoport)
>> - Initialize pageblock migratetypes from a helper after the per-page
>>  loop (suggested by Mike Rapoport)
>> - Use a 1G PFN chunk for cond_resched() in the pageblock helper
>>  (suggested by Mike Rapoport)
>> - Guard section_order() with CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP so
>>  it returns 0 when HVO is disabled and lets the compiler optimize the
>>  code as much as possible (suggested by Mike Rapoport)
>> - Explain why the !SPARSEMEM __pfn_to_section() stub belongs here
>>  (suggested by Mike Rapoport)
>> ---
>> include/linux/mmzone.h |  8 ++++++++
>> mm/mm_init.c           | 40 +++++++++++++++++++++++-----------------
>> mm/sparse.h            | 33 +++++++++++++++++++++++++++++++++
>> 3 files changed, 64 insertions(+), 17 deletions(-)
>> 
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index 5fb9b37819d5..df31cac12311 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -2022,6 +2022,14 @@ struct mem_section {
>> unsigned long section_mem_map;
>> 
>> struct mem_section_usage *usage;
>> +#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
>> + /*
>> + * Normally, sections hold regular (order-0) pages. However, for
>> + * sections with HVO enabled, this tracks the compound page order
>> + * to enable deduplication of redundant vmemmap pages.
>> + */
>> + unsigned int order;
> 
> order is a way too generic name for this. page_order? compound_page_order?

compound_page_order is more accurate. I think it is more suitable.

Thanks.

> 
> -- 
> Cheers,
> 
> David


