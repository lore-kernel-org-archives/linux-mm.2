Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A06BCCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 18:25:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4F148E00BF; Mon,  3 Nov 2025 13:25:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A26478E00B8; Mon,  3 Nov 2025 13:25:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9627B8E00BF; Mon,  3 Nov 2025 13:25:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 846328E00B8
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 13:25:54 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1479B57AFB
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:25:54 +0000 (UTC)
X-FDA: 84070124628.21.F1B879A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4812440009
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:25:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762194352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6Xh/82epPYCxQQw2FW1rqZLFSQMgbCtmljXqcyGvdlI=;
	b=SWAj3tBYTlmmrYNvGrqnIw5G46SUpNOXmtfC7rQvggjclEDdcfU5+2QqWvmRiiCY0guk/R
	VNiU9IgpKnWXC1PfgNqTUENBQFd5WeeeecRIi92gfOR16iPsc7oVWSlO0iuTtRNh7w3jMJ
	jZI7LTpGYXyuW3vkPdqWAwnMY3gk9a0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762194352; a=rsa-sha256;
	cv=none;
	b=CuDJyy/iAhzHbkc+mdVJmLQ4wpnL88yXjUEgycC6lmOMIkd6Q6lW1XK5wBt4ruthzUp4/1
	0gQOrgmLgdwMAXT7PJZnn/pejDfXPsZT6i3nv28FC2C3BAKXYRtbxzUM9LW9i5sLBnA9pd
	Cq315DLOy9bH7OQYJm7MFIae7yo0Dvk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7EF862A6B;
	Mon,  3 Nov 2025 10:25:43 -0800 (PST)
Received: from [10.1.30.16] (unknown [10.1.30.16])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E06143F694;
	Mon,  3 Nov 2025 10:25:43 -0800 (PST)
Message-ID: <334d6272-a1c2-4075-a956-3f41908371a6@arm.com>
Date: Mon, 3 Nov 2025 18:25:41 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/12] arm64: mm: replace TIF_LAZY_MMU with
 in_lazy_mmu_mode()
To: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>,
 David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-9-kevin.brodsky@arm.com>
 <b6f5b3cc-93a0-408a-b7e0-72462f3fd549@redhat.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <b6f5b3cc-93a0-408a-b7e0-72462f3fd549@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4812440009
X-Stat-Signature: me8t9b9kyz4r97dzuybbek3e9d194y86
X-Rspam-User: 
X-HE-Tag: 1762194352-3702
X-HE-Meta: U2FsdGVkX1+ZzQCBEQr796UAKa3r4DlLAnDAsZnxMEW9rPb21DjuN14R94YCnBT5bAdjyTU+v4xl721BgsuUhivSSd+3V+bwfu/JVTaDB40RwXsNinyi27q3Si/JLXjvrbMkUotqU7ZNNSp094eHi5U9J/mytqiO2uSsbJmWlUkXj4yjT5n4GkO9C2fK8y4xf+17D9Ro2y2WmwayFlNIOeNhBvEONzvhqxa29Tli/Z0L8zzK8N4ngZMT6Bz8MIqX96zw3gVNb6uhcMp7aYPJ8sh2Lk5HuFdTQYS6c9QHTeAfEc4scDSrp/bL/8ctNk4tSDt8R11Mk+bFXpRFK5+2uqndGXXe1onQCka0X289SSn44xOJ1YSBfZaYJOnBdb6p0Z+/U8nwpH6FmNuLOg/em7l0fL7REDat0n4nsMz3Q6EsQDXyjuFcT3UXzG3PujxrUxnT+yi3gFHUR0ZAkE4g7YVTl4bmmuxPpaFvhY3IZXV5CdEBG8vicr9L+pmnEs4aHMuZjoPygf9T7zUUkqpzYbDRq4JiA0CB6slTOZMqdGPFLiyl+LyTTgYWK/JE3MOal+k2ataNPFXoAjpe3r0535qDBHHQw+6LwiT70opDs67j263erDjgrVp6Y07xIRWrTurAGsl4p0g5yjTlk+R1bg4TKEHrBUlO6w4BFNb6DoeXV/DchCWwxbT9yE9sWqLzKLeELKf63zex5K9JqM/febt2Xkd7erqYIU0/HsRqW5cLTKRa+sO0kBucCSuHcpqTofkx7o/pNFeqOC1gG846O9s0S88Vu8Mq1sNADJm/+OPqyHZo7VIswzZhPogfZI8ZoQtNscMMyLZfuxRxXx5Bb1Pq313TI5FF1NBgFKHZAwnmaT9fjC0QGVFFpD3xSdENiynUeqW+9+8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/11/2025 16:03, David Hildenbrand wrote:
> On 29.10.25 11:09, Kevin Brodsky wrote:
>> The generic lazy_mmu layer now tracks whether a task is in lazy MMU
>> mode. As a result we no longer need a TIF flag for that purpose -
>> let's use the new in_lazy_mmu_mode() helper instead.
>>
>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> ---
>>   arch/arm64/include/asm/pgtable.h     | 16 +++-------------
>>   arch/arm64/include/asm/thread_info.h |  3 +--
>>   2 files changed, 4 insertions(+), 15 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/pgtable.h
>> b/arch/arm64/include/asm/pgtable.h
>> index 535435248923..61ca88f94551 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -62,30 +62,21 @@ static inline void emit_pte_barriers(void)
>>     static inline void queue_pte_barriers(void)
>>   {
>> -    unsigned long flags;
>> -
>>       if (in_interrupt()) {
>>           emit_pte_barriers();
>>           return;
>>       }
>>   -    flags = read_thread_flags();
>> -
>> -    if (flags & BIT(TIF_LAZY_MMU)) {
>> -        /* Avoid the atomic op if already set. */
>> -        if (!(flags & BIT(TIF_LAZY_MMU_PENDING)))
>> -            set_thread_flag(TIF_LAZY_MMU_PENDING);
>> -    } else {
>> +    if (in_lazy_mmu_mode())
>> +        test_and_set_thread_flag(TIF_LAZY_MMU_PENDING);
>
> You likely don't want a test_and_set here, which would do a
> test_and_set_bit() -- an atomic rmw.

Ah yes good point, the new version would do an atomic RMW in all cases.
Simpler code but also slower :/

>
> You only want to avoid the atomic write if already set.
>
> So keep the current
>
>     /* Avoid the atomic op if already set. */
>     if (!(flags & BIT(TIF_LAZY_MMU_PENDING)))
>         set_thread_flag(TIF_LAZY_MMU_PENDING); 

Pretty much, since we're now only considering one flag we can simplify
it to:

if (!test_thread_flag(TIF_LAZY_MMU_PENDING))
    set_thread_flag(TIF_LAZY_MMU_PENDING);

- Kevin

