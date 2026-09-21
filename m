Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1CBAC982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 12:51:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B02F86B008C; Mon, 21 Sep 2026 08:51:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADACD6B00D5; Mon, 21 Sep 2026 08:51:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F00C6B00DD; Mon, 21 Sep 2026 08:51:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F2BB6B008C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:51:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 04B23140161
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:51:24 +0000 (UTC)
X-FDA: 85237755330.10.9155AA1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id F40D3120008
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:51:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ShtSmcPD;
	spf=pass (imf29.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789995083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=61Ma0ewUMnjyMeM1Wq480iH1x1T4S9hRZE82Sqp1OUo=;
	b=YBcwGXxebVGZLqGlI7y37M9SIgoAR2zrvdOoWkEyv0FPORP5irpvoByZX7MWBxqQkgmxtP
	667J7OXhvjJHQz4VAKVh/XJZ0sUFBwYGhao8jke7nOlmRzd9FS6IPHFUiWAQEXnwzhCXwy
	kNqUewQ3L1oTXJeDHUwhdM8U6HjGp9w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789995083;
	b=RS/1Xv0uNK7cvn9jMLnVnwauxAL4uVZOFjPQ7BpvXSU5DRi5EL6bEQCMq8uqWjrXJYgZAU
	YRQwrmDV4A6OJo89SQe+rhoI/NMvUlpyk+jLWTzF3Xv2t/0kw3xFGKB4eG+g8494j8Ok22
	qXElepEd0DojJaOBfeIhzBvZaLuLXds=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ShtSmcPD;
	spf=pass (imf29.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7E855176C;
	Mon, 21 Sep 2026 05:51:18 -0700 (PDT)
Received: from [10.57.6.224] (unknown [10.57.6.224])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 369BE3F86C;
	Mon, 21 Sep 2026 05:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789995082; bh=HXAhdpQuILv12trenzrxa0DxHNLn7f/XIZHr5cv391k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ShtSmcPDUXgPFJquxoISwgyxA0JeEBWLYMWSo5Kp/sAkxe8UArxJYx54OQw5DhKo5
	 91/PuhmUkjC3DEWhdBC9lka/rh0pM3m0nVfSaqpUkfTDsBcvRFYZZSXMBptKHvfkEq
	 2RXCaLm+4k0zuOQBpH3bJ8i8jcHuTYYleBbqAy+A=
Message-ID: <c4a38552-abdd-42e4-8b7d-bb1716888f1f@arm.com>
Date: Mon, 21 Sep 2026 14:51:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/6] set_memory: add number of pages parameter to
 set_direct_map APIs
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 =?UTF-8?Q?Adrian_Barna=C5=9B?= <abarnas@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@kernel.org>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Len Brown <lenb@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 Pavel Machek <pavel@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Sven Schnelle <svens@linux.ibm.com>,
 Thomas Gleixner <tglx@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
 Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>,
 Will Deacon <will@kernel.org>, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 loongarch@lists.linux.dev
References: <20260903-execmem-set-vm-perms-v0-2-v3-0-949b64a9f755@kernel.org>
 <20260903-execmem-set-vm-perms-v0-2-v3-1-949b64a9f755@kernel.org>
 <d299f7c5-6c71-499a-b8cd-aa69c4c81dd1@arm.com> <aqzjBA_101LcKRCD@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <aqzjBA_101LcKRCD@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F40D3120008
X-Stat-Signature: 388q5u9913fsu59dwqks6w8ihsat8nob
X-Rspam-User: 
X-HE-Tag: 1789995082-625792
X-HE-Meta: U2FsdGVkX1+HztiFhqmrJeR4zhn1VgUBgBrvHoGGd27usl5ynDbU3dMY5yvEYrG5P4cf0ZhABxLLnjMIRk60xjXlxXYj6ZdbPVE4tmY7TG6PHFJ+8zUIo3oKaH1Cqch2d7j6k60rg4Qd2kwf8F4SQkWbH3wPR2XaIaZfcjv7IJk4TfJtHxyMzvhY8dOTKfM1l+yjCmLY42ZQD42oZ8Olqp+EIfZpwHkJEzrdefKTPUM4/Zf4RJ5fmq56M63JjOJJfZA6O0JWvJVAPvKDm2Dgzd8g6+9i9fLBcOKIKERyaMrywnYjzMW5nSRmyyw+m5E2yvaYd174I3jW1Gn/GaYCARjoRLow/DFbO/+kqzMi5jsqtY4Pr1f6nvAKuvaRFR9CeJVzzxff1Pg3d8uLfnlDBnoZM9LylKpvFSjg/Q0XlmZjtS1+CjykRULbtz17zuThb/7ziDB7S/DKecXoajHO2s+iR9dS+kX5qein/+Fg4/XP0tLHpPQtWrbnul6AA/mHwATMTPxINC7vcQNff0FIHf82oastAvKUyRH6/yYRtWhrgJRb+boAh/MhVcbH4W5TC3kth+KhFa3XhZgJoxcZs74cHhCaQSOdfzq73qZd7lGpIperJT+0oKh5yk9pEv2RB89Kv+DqeAyUAxQtSdf1E4PT8z+LbGQSJ6oL7T3yl9e2tBVrw1OXZgTbj11plhq/DZRypvTFdE5vVvtEQxoPVLemvaZmT1cwsouMHscpwvKITIaHkja76IZS8EpRm/kxBjLAVfkfwcxZCoqGIe7Y3MddNHdVMek8rwchJ3vkHVhCNCtyCvNK9Nu4JftWdXiYJV5iKvnLh/DIvQNYN+MeTBoPf25H/QEXAk4M1S514TBztqi1tBjG3WmtTtrSR4T404MWzIH6qRkeZHEbBeRH03CoFNZuItmuDnQefCUSxribLJ7dqkrNgHAWbsDYg+vzTHgRxEhPUidP9OMI+3L
 FztQsmfb
 JuhtPfv+K1T87VxV18roSIS7gpz+sqoU6kfbl0tU5C7EQ10q0yoel781cve/j5PcXwZx2vwbRi78+Fjf42+WlMG7ZBUapnRpkQN9GhVr3MogR9RFfltd6K29D/AdRbO1RHWn/ZeVBiPM3+t28gwnhKg/PTV+j4y+ptE9Ki8QqzdIUi35TerkJEkJqrhJrMyxi6Zq9dI0BXVlOSx7rkXqyBlt/LaaNRkegVWBy2IERKwBcN/0vvysJLCt1Y09ef4KT5i8mUoywDb/bwBK9g6KkqiIElvBzdX7fKmtzgalGW8lt4Nc4wciCqxsFqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18/09/2026 09:06, Mike Rapoport wrote:
> On Thu, Sep 17, 2026 at 08:11:22PM +0200, Kevin Brodsky wrote:
>> On 03/09/2026 11:28, Mike Rapoport (Microsoft) wrote:
>>> When set_direct_map APIs were introduced by the commit d253ca0c3865
>>> ("x86/mm/cpa: Add set_direct_map_*() functions") the single page
>>> parameter made sense because the initial callers (vmalloc and
>>> hibernation) had sets of unsorted struct pages that required changes of
>>> their mappings in the direct map.
>>>
>>> Since there is an increasing demand for direct map manipulation and it
>>> is also desirable to be able to update larger physically contiguous
>>> mappings, for example an entire large folio, extend set_direct_map APIs
>>> to receive number of pages parameter.
>>>
>>> As there is still only a handful of callers, change the existing
>>> functions directly and update all the call sites rather than adding
>>> wrappers for single page case.
>>>
>>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>> ---
>>>  arch/arm64/include/asm/set_memory.h     | 4 ++--
>>>  arch/arm64/mm/pageattr.c                | 8 ++++----
>>>  arch/loongarch/include/asm/set_memory.h | 4 ++--
>>>  arch/loongarch/mm/pageattr.c            | 8 ++++----
>>>  arch/riscv/include/asm/set_memory.h     | 4 ++--
>>>  arch/riscv/mm/pageattr.c                | 8 ++++----
>>>  arch/s390/include/asm/set_memory.h      | 4 ++--
>>>  arch/s390/mm/pageattr.c                 | 8 ++++----
>>>  arch/x86/include/asm/set_memory.h       | 4 ++--
>>>  arch/x86/mm/pat/set_memory.c            | 8 ++++----
>>>  include/linux/set_memory.h              | 6 ++++--
>>>  kernel/power/snapshot.c                 | 4 ++--
>>>  mm/secretmem.c                          | 6 +++---
>>>  mm/vmalloc.c                            | 5 +++--
>>>  14 files changed, 42 insertions(+), 39 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
>>> index 90f61b17275e1..b07fd4e026eac 100644
>>> --- a/arch/arm64/include/asm/set_memory.h
>>> +++ b/arch/arm64/include/asm/set_memory.h
>>> @@ -11,8 +11,8 @@ bool can_set_direct_map(void);
>>>  
>>>  int set_memory_valid(unsigned long addr, int numpages, int enable);
>>>  
>>> -int set_direct_map_invalid_noflush(struct page *page);
>>> -int set_direct_map_default_noflush(struct page *page);
>>> +int set_direct_map_invalid_noflush(struct page *page, unsigned int numpages);
>>> +int set_direct_map_default_noflush(struct page *page, unsigned int numpages);
>> I don't have a strong opinion on whether to call the argument nr or
>> numpages, but we might as well be consistent across archs :)
> Well, it's either consistent across archs or consistent within each arch :)
> Or add a churny patch that renames it everywhere to nr_pages :)

Eh fair enough... Clearly not the biggest inconsistency in the
set_direct_map API anyway!

- Kevin

