Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 462B3C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 10:18:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C8806B0093; Fri, 25 Sep 2026 06:18:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 478A66B0095; Fri, 25 Sep 2026 06:18:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36AC56B0096; Fri, 25 Sep 2026 06:18:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 119406B0093
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:18:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 91D5BC05C2
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:18:46 +0000 (UTC)
X-FDA: 85251885852.13.BC90689
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7AAE1C000C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:18:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LgQww5oP;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790331524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MK4ccynJ5njj5EFx9H2JSdGDH5gu2H44HuFl/OTs0co=;
	b=ILyU/aJPLyybl8xPe14v2PDWXkzxvcUxpzyoKQOPm5ukVmt7W4Mj1cMWZ7Vbh6+jwKK5Hp
	xbAT2U825zcTKsVDdQN4QXWadfYee+iY1gb0iVBjYeHAZNdweXyruPLBwk5OWSmH/7RojK
	aMSlt5cXIs6dgGC927lXdgVwlZYQOYQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790331524;
	b=6gnlc+LtarYp00XRfNzrTpn8q7Y6+/GoSvi1UMMH+iDtdgaOrTgMipvrm6EsDaB9Xb7sx4
	R5maabwf/EsTUh/BE+PxaOrOosH0R4XepGbBKJT2gCsEQe7heGmbFL1UykuLgmpOcDUBa0
	qaTtGKceZDXZBD8f6BN4mwqNlIAZqcI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LgQww5oP;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BE7A316F8;
	Fri, 25 Sep 2026 03:18:39 -0700 (PDT)
Received: from [10.164.19.30] (unknown [10.164.19.30])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9179B3F86F;
	Fri, 25 Sep 2026 03:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790331523; bh=CpmxRU9+iKFpg5bvhhGZQGyt3vfrqBdpwbEgHOrLymI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LgQww5oPUbWf6eN1nsr5Vqe8WzyaweKdK4VVcKTQhvjT69wK5zHR+5KHcLt7XF12r
	 TsVecaMJUffvIsSdeTElshKH4e47IB00ch8tZtuwNdRiZcHmvoP+F7hw21x7TMJkp0
	 HtumcBkNgo5CX6e1gbxob2bHp/O9wGSpLN5CjmrQ=
Message-ID: <638cdbef-016a-41f1-986f-7ed6e65e80c4@arm.com>
Date: Fri, 25 Sep 2026 15:48:32 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/9] mm: move anon-exclusive batch helper to rmap.h
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com,
 davem@davemloft.net, andreas@gaisler.com, riel@surriel.com,
 liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, baolin.wang@linux.alibaba.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
 youngjun.park@lge.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, pfalcato@suse.de,
 jgg@ziepe.ca, thuth@redhat.com, sparclinux@vger.kernel.org,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260924131106.1730494-1-dev.jain@arm.com>
 <20260924131106.1730494-4-dev.jain@arm.com>
 <CAGsJ_4yVhXF+-gOrOB+JOK6nZt19SA=LT+gXpmaMpErg6Ra5NQ@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CAGsJ_4yVhXF+-gOrOB+JOK6nZt19SA=LT+gXpmaMpErg6Ra5NQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: p87bf69omea3io7cb7wx94pqqw6hbqta
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7AAE1C000C
X-HE-Tag: 1790331524-286375
X-HE-Meta: U2FsdGVkX18IoKI4ZcUWoIFhPClXmiByJ7r/txGQk1PmoMZCdUKOsN+us40paTbcnMWedhXre7SiwYyLOXgjbYiQyr5ykArEh1y+IIXBOSLw5KyjBTQuepqYVkACg/p1yPX3MQpm8qtC+RgExwPtwHZV0L4RGmpTdF+ieJIkQvvSuhKVgcpl38dRRpsxZLqchlncjTYhwBUDAeat9MneYMvSoKOTxXcCgHLjbWFr7vbRE5h6uoABJC/6wMA4taipNH7r54/qJjav7RtkLrwgH83mSXHT2tT30NYgET3rpM7clNsC8L41LL7dzAfWxqYxo8PCMBVR+IZzabLMQGU7cl5v6j04hZHHjPmUjQnj+6817btiHl02eZg4U0sEEl4vHWqwxXgHbmvJ+9fr3sk4fHsE0f1F3NwB6caB9BVV3FP8DBwxfJQ1t8DOPPvFIo7ojTTHARsUAleJ5tEab3j5Lk7w5usfpzREiLJtVfxWJghixf+ByWXtnDuS4fgiMDlglqNNIL1vr7pfXj84V8wUIhmRIgLYVv4Capqhs168D+QV757SB+LStiZEtHivuYC75ZXB5EQ+36ogJH11LGcYW+ddFGvCEnA7+hNarJ2SruRg2fSfFJiAh0s5NEUVWhbCJoYwWz7f0na3qjDuTjLrfydEyQXrEI688Ptj7S7Sv103HkASTyqTTIsjCxHQJTR6J41a45HLQZxIqkjAC8NB/BBs+8N8rkQSi/CA6VlElHRlQ0GqppdQNEIvSJQMRcgoHl6GU0bUGlAza6fobIo1VJ76F8RYYt7kYpbXG7CuyjDLre4BsVxmQxCaAjojeCGSAGCvQiIHwiE+IK52CzcOERGNnXNh2AnBP2/NArqyIFHTklzgWITODVWKECB4u4scwRZ/mSBkI6d3nhhOxWRrYm3aHoEkmOjZj4AcqQQAgKRYZND78thItWY3WoTwG9AMmNuzXH2LqxfqV2iZpdp
 SVkj0NnB
 8v3F1PwD9GHnuknslsfzy1hqL9j3aFCeubRJMcT4ExVYpTySLSg6qVZCpCt6xZEz0rTp1ZMeIey65FSkIA+pD/2ydL66myUQHutp4KYRr2SlJW0MqUKalpOgyTDWr8kvGZT6x/IVJMGHOTHWOVFSZDGilCP6c8t9rxKLYYMuCzc+TIUrecEyRjtMZ3uxUhMx6sz51lpmjsdLDvU3hq313Vuav7KqYyqDEM0utzbbRANAmfiZ+Ao5yb1C6ghlPhCiNpOmR1tW9yyl/QiAfWCg6CnZBSRdGc+dx3rOjYMpaLpQ9/SH7hf5Hd1fw9RzZb4vgUz6zoAmvasoFEm1tR0ioEb0ZOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 25/09/26 2:32 am, Barry Song wrote:
> On Thu, Sep 24, 2026 at 9:11 PM Dev Jain <dev.jain@arm.com> wrote:
>>
>> In preparation for optimizing large folio unmapping, we need to reuse
>> the page_anon_exclusive_batch helper in rmap.c and rmap.h and obey the
>> existing use in mprotect.c .
>>
>> Therefore, move it from mprotect.c to rmap.h.
>>
>> While at it, change return type, start_idx and max_len to unsigned long
>> type for future proofing against THP support at >= PUD level. Also
>> shorten expected_anon_exclusive -> anon_exclusive.
> 
> I really think the `expected` prefix makes the semantics clearer, so I
> don't think it's necessary to remove it.
> 
> If you really find it too long, maybe just use
> `expected_exclusive`, since we're already in the anon context and
> know that it is definitely anon.
> 
> Another option might be to make `*exclusive` an output parameter.
> Then we wouldn't need to call
> `expected_anon_exclusive = PageAnonExclusive(first_page + batch_idx);`
> in the caller.

Ah nice! This looks much cleaner, thanks.


> 
>  static __always_inline unsigned long
> page_anon_exclusive_batch(unsigned long start_idx,
>                 unsigned long max_len, struct page *first_page, bool *exclusive)
> 
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
> 
> Otherwise, the patch looks good to me.
> 
> Reviewed-by: Barry Song <baohua@kernel.org>

Thanks.

> 
>> ---
>>  include/linux/rmap.h | 17 +++++++++++++++++
>>  mm/mprotect.c        | 18 +-----------------
>>  2 files changed, 18 insertions(+), 17 deletions(-)
>>
>> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
>> index 74cca0e3c7264..62ef511a6175a 100644
>> --- a/include/linux/rmap.h
>> +++ b/include/linux/rmap.h
>> @@ -106,6 +106,23 @@ enum ttu_flags {
>>
>>  #ifdef CONFIG_MMU
>>
>> +/*
>> + * Get max length of consecutive PTEs pointing to PageAnonExclusive() pages or
>> + * !PageAnonExclusive() pages, starting from start_idx. Caller must enforce
>> + * that the PTEs point to consecutive pages of the same anon large folio.
>> + */
>> +static __always_inline unsigned long page_anon_exclusive_batch(unsigned long start_idx,
>> +               unsigned long max_len, struct page *first_page, bool anon_exclusive)
>> +{
>> +       unsigned long idx;
>> +
>> +       for (idx = start_idx + 1; idx < start_idx + max_len; ++idx) {
>> +               if (anon_exclusive != PageAnonExclusive(first_page + idx))
>> +                       break;
>> +       }
>> +       return idx - start_idx;
>> +}
>> +
> 
> Thanks
> Barry


