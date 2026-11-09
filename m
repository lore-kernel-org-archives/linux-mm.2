Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35B8C606A325
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 03:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=LfbYkWDk
Received: by kanga.kvack.org (Postfix)
	id 990D06B00EF; Sun,  8 Nov 2026 22:39:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 941BE6B05B0; Sun,  8 Nov 2026 22:39:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E3986B05B1; Sun,  8 Nov 2026 22:39:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 57AC16B00EF
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 22:39:24 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AC473A0571
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 03:39:23 +0000 (UTC)
X-FDA: 85414175406.23.7CB4C8A
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf10.hostedemail.com (Postfix) with ESMTP id 92540C0009
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 03:39:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LfbYkWDk;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794195562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ipzH5qd6kjldVL6ueBW7MvcsKXTNSFLFRFYQ19uyfag=;
	b=s2WIkdQXrXk6C5qIuxwF69qopjLuKaWN/2YkuPJlWQy2vjc+Sjgbbu8nv/Awcm5AaZEOTm
	GeU3fgiXCkCl2KqJVFRlXnO8uCkq/+pRBcdmlefqFPDFkdaDthK5CIf5qa46JU3GaPwdBN
	K14Wtyy/p6/zbzFFQ03x7MyRld4GGro=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LfbYkWDk;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794195562;
	b=A+SwfT7kQb9BFfU5wMKmZ57S4Zi0VEdeiTvfK+GYrK+7U5DnMCf8Fhh47O5g31TXjwsxO2
	EemXzGKbDgVAfmG4VU1DBX3P6e/UHGPlEfkwQWFmGAkq2fA6q1Us5KhSKUJMcJeBCU+zUy
	gLOMsC0JGEpIZAH4slKlTU31AAOCXVk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794195558; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ipzH5qd6kjldVL6ueBW7MvcsKXTNSFLFRFYQ19uyfag=;
	b=LfbYkWDkcY3S9P4Z93eUsjURfPXoHIl3oU9Yt5BYVZ6/K5nhF8hKha1jQJZhyCh16MRcKarc4T3vn5IXNvUIP00BpdNNx8vn5U5sIaAnCrTZsK5B3JQ6MU8S+lusXHOCvUlU6VDK49izY233PZ8oXRZ8YB2R+jt+QPsR52WzyCw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XEIHFYj_1794195554;
Received: from 30.74.144.145(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEIHFYj_1794195554 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Nov 2026 11:39:15 +0800
Message-ID: <a069e3ca-6bbc-481e-acec-5ef21855b9ec@linux.alibaba.com>
Date: Mon, 9 Nov 2026 11:39:14 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: synchronize with PTE table reclaim for all folio
 sizes
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Pedro Falcato <pfalcato@suse.de>
Cc: akpm@linux-foundation.org, ljs@kernel.org, riel@surriel.com,
 liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, qi.zheng@linux.dev, ayushr@modal.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <affd6da4e8d0de1424a4e0b3bafcd1324dfb6c97.1793847060.git.baolin.wang@linux.alibaba.com>
 <auxqWxUfRVvxnk_n@pedro-suse.tail5790ac.ts.net>
 <44740e38-77ae-457e-97db-d6e0a0149dc2@linux.alibaba.com>
 <4a64ea17-6ac2-406e-a432-b82c481a4f84@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <4a64ea17-6ac2-406e-a432-b82c481a4f84@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 92540C0009
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=4.0.1
X-Stat-Signature: mtoyickwsmszbdyycpkkewmgjs5xosm5
X-HE-Tag: 1794195560-42666
X-HE-Meta: U2FsdGVkX1+I3Jz2TQf9hH1+/hKwNwSsGtSys9REmuDzYf65Wpxvh3e4u9pFue6yAYrGkH/g9MqmQAO2YMXypfxCm7YnbYDhzc+iW4K/xITaJfhCrzSo2bhyoQx8ytyJYfOR3Zm2YpdyqSaWMo6gbusX12/TBAhdg77UO6a2HbeHLQqTc9NUzISVxtkn+F/gfrrt+eHxHf5TqrhlFH+fYBfphmL49luVQubDIxDkxh+Oy7TyWl6y0D3I+IH0Rn5LThyRv62pBX7sOJrZk2pLKByhPk84a3gTeUHFmCTUlFYYP6+Z4CzaezBqJ6YQR2fZPBlSoUBp645kv2cbxq+LIcnOttHoLv1p+uNlDX4toiINllzdp+oG1d3tCxHv7Rui7Fb/fsc93oWMJGlEXRsUSUIdKKvjrDN6DB5whw/Y+LF1+IFA/dtfQHS+nSAGU6sNWQGil8ZafoDsAYHfvPOWrf4iayah4iaHJYLpo1rhKJ7XIpylfLxnIgUkd0CIsg1z0AT4f9fv4RhWLxTQqQK75aRVygUc4JrE8BXcwr9hY5dKKLqvOk7GCooZY78Cw01cybwy1LN1n7if16y6ED+ODXsn3mNLQEowyu3aF9VqVBDi5Jk7Z6RIBDZvv5uFn57Gq4wQwOSDlfgC4u8cWsPQrRGGSKep5ZwW6prDVkp/YkqZMNoRUi76xz56nVxi7v/xUtgFcG28M1X1xQstPkCkkd5Pi+ZS5OtC5oGeYWP62kpbUX+keT5u0h5UsGjmPoJOdRH4kZWbzOm9J7KbsAQAON4mjgIbaYFTbYXz1Q562lJbHGMpxUm+C20i/AeVbbE7TB+orFglsfS/JHgOvJ339Z7YUP5N1kxXpCCYlrWZ6EFogAW9zHlBOmBdAfdHtOME5domrO8hotIvFg6XZpRwtaHZtPYG7I58az2t8uZmr2dEzkurfK+aXkY1UEv5wQfCtEQHJEZmjQQivl0/FWU
 svqlvBRa
 FnwxsGPbbOOpF4h6Adf+QClbSgnmvbr7yJOdds8NkNOdkAZpWXCTprHFsKJAPrA8D4Ed278RurpFw/fAU3w5iL7NeYt+tl33QpzOpsqccVAkHgsWTw0mfti5Q2QX5DTwHe2kaePR8C6w1AEhKxdsh/WDtmf1GAxjWIZ69xx5MU3KYNiJUcm4wthOIZ+UEtBEloOQfW7053iRYE5gnjttxvCcK+9JX8Utf2qj3xiFyNu8kbj2q73anhwLtYpqAAHhwKp4qZDfJd3f5ZoRmU4x/legIaalfYVdKWyeNQa147GwuAurlSys2TtnhmNwqUmEoS8gk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/8/26 3:58 AM, David Hildenbrand (Arm) wrote:
> On 11/6/26 03:12, Baolin Wang wrote:
>>
>>
>> On 11/5/26 7:37 PM, Pedro Falcato wrote:
>>> On Thu, Nov 05, 2026 at 10:56:28AM +0800, Baolin Wang wrote:
>>>> Similar to commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped
>>>> folios"), the '!pmd_present()' check in page_vma_mapped_walk() can also race
>>>> with concurrent page table reclamation via zap_empty_pte_table().
>>>>
>>>> page_vma_mapped_walk() is used by many functions including try_to_unmap(),
>>>> try_to_migrate(), folio_mkclean(), pfn_mkclean_range(), remove_migration_ptes(),
>>>> page_mapped_in_vma(), and mapping_wrprotect_range(). Except for try_to_unmap()
>>>> and try_to_migrate(), the other callers do not perform post-walk accounting
>>>> checks, so the race has no observable impact on them.
>>>>
>>>> For migration, the race can cause unnecessary retries. For reclaim via
>>>> try_to_unmap(), the race can cause failure to reclaim a folio that is in
>>>> fact already unmapped (as shown below), which may lead to unexpected OOM
>>>> or increased refaults.
>>>
>>> This is very handwavy. Do you have numbers? Does this actually make sense?
>>
>> This is hard to measure in practice. But in theory, if we can't reclaim
>> cold large folios that are actually unmapped due to the racy checks, it
>> could cause cold/hot inversion (e.g., in MGLRU) and increase refaults.
>> In extreme cases, failing to reclaim unmapped large folios could even
>> cause OOM.
> 
> Yeah, but the question is if it really matters in practice.
> 
> I agree that page_mapped_in_vma() should sync properly, but the current impact
> might not be as severe.

Yes, what I meant is the theoretical impact. In practice, this race is 
not easy to trigger with no real reports so far, or the impact is tolerable.

But I still think the fix is needed, as it matches the purpose of the 
TTU_SYNC flag.

