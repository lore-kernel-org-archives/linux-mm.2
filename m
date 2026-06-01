Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2718ECD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 05:36:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86C476B0260; Mon,  1 Jun 2026 01:36:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81D426B0261; Mon,  1 Jun 2026 01:36:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 731F66B0266; Mon,  1 Jun 2026 01:36:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 600496B0260
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 01:36:32 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 19CA78F0AA
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:36:32 +0000 (UTC)
X-FDA: 84830233824.21.093A918
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3B690180003
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:36:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vm2kSx94;
	spf=pass (imf16.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780292190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vcWE6mDbZONHA9UBQ7OVFkxGgaAMM1rGCH/MHcIvc3U=;
	b=yUBfc1pkP/CPEDceS+GfUUt212ye2jEt7bykPHjJ78y9qj/I8UgYW/mLIebWE+FqcEOD7w
	PIe2eo5na257qibE882nvDOoVDSzCC/KNPQdo7Q9cNPfHvkI6qExvLbTZRC111cUH+lk62
	bZjgWvv2oVtTDUh7Bhk6Xm39HsTXArY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780292190; a=rsa-sha256;
	cv=none;
	b=fJvLaXwUjjy08lgs2oLnRQ21jzdtmBS+wR7sepABIg7/iTAKIAeVteWf77/bEsBl4BkpBJ
	N0nYOf57Y+9ysiDGQB6vDtTWtpkYCfQ7RkYIl058HHZXxAZeFoHeos5uG+Zo6GVr8jKhGw
	hHUA2q3AgS113Ddbb3h/5+JehEj7Nqw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vm2kSx94;
	spf=pass (imf16.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 723D11E8D;
	Sun, 31 May 2026 22:36:24 -0700 (PDT)
Received: from [10.164.18.45] (unknown [10.164.18.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 644843F905;
	Sun, 31 May 2026 22:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780292189; bh=BXihrI+kDpZcwsjIhEFPnSR9hYiTEZguWIRQRr0syf4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vm2kSx94I5qkogPVURWrrhH7aXHNfLmUGrxjiD+wnWosJeMfjbh5y2H7ia0qhyyQG
	 ugqsgzAcfZSIg2Dw6IILnixHWf73Cv9uOSh+8NxrMK4tlJxUtvIMoprfHWx+JwX8Fr
	 iXiG6LVFDVIPWd/sjZBPtJitP/i+ldzWRllI02oY=
Message-ID: <fc7e1e8b-a0fd-4d11-8056-cc9664cdf45e@arm.com>
Date: Mon, 1 Jun 2026 11:06:22 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V2 13/14] arm64/mm: Add an abstraction level for tlbi_op
To: Linu Cherian <linu.cherian@arm.com>, Ryan Roberts <ryan.roberts@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260513044547.4128549-1-anshuman.khandual@arm.com>
 <20260513044547.4128549-14-anshuman.khandual@arm.com>
 <37917d56-ae26-4789-ac4c-15f8ee12398b@arm.com>
 <ahkP7IWLX-0QCoul@a079125.arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <ahkP7IWLX-0QCoul@a079125.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: qzhgny7geu3x9rnoj5o6eat3sosdze7o
X-Rspamd-Queue-Id: 3B690180003
X-Rspam-User: 
X-HE-Tag: 1780292190-558942
X-HE-Meta: U2FsdGVkX1/Xb4WlfjMRKaOBR75WZ1+axrbE/+ibx4n3JObCL//I1o2O1uIFirLcj8NOCvyaKHP5Hvd3Yd9lcPZWBJz1CcGcAVApb6r7pOryz+y/2nx0dJgyCnaBpM6fXZTrM1uw2EfgUbG4pOMj2n6aG9qyRH4JS+t+ta5j8YvQlmhu6UsAcmxuYXM/9EOLjbJL6EIsdOuik1VCAUcApgxUuSGNUftGYtpnBPnp2XQ80tYoFsafCisQxOB5qEN4xYH+Nfw0vKE4lobg7yYSDq+UXDDjUKbeC/3kU/wRun4mF4foKg9ApoVzbf6Shq/l8Epo/asFXoB0ztLGvRRUjGziRPpCI6Sa7WonvLYbh9oVR3DRbbfzwZmjGRuYFCyHHHKb7dKalYY34BxZWQnaJnK1NS1gFeb25IOulXryYpP8X+ItIXFogYvIhSkRzObDiTh8mF0lBmuYqWQAr49dJefr8z7fJF3QZ6SQVlijyJP7y+6MY5c8FnlYs1UevNqAyGh8nnRq1CamuozmXIA+MqjrTVMSQLOE0+3JixM+BJ1mJb9f9wsSGCnpV0mnLWGfznpyvAndbi2nSvCb3tlhRJG4BTNo4z6LscykN4X/NxjG5V+kCs0eN7bVI5h2GAMjnpxWsTs8U1m5MznoCIp7MURvliKuRNJZuAyFSXthT1aAhGVijZVCG1GRHtFUSAmodDztP+KHhM/nAIyYvXLyUnVOmwcg0oqAdTcQ8LySM43XvpJcUpD/3uXgIRfCsos3Powy2kx3iHctadqxTRYfrornx7Yqt7koevm29U73f0W6ANV7aDWuDfUxaxs3rHxqxTM2Khfwz3BkLgaQ5RImCk0KxQ/l4qSrUH34wSS+U2TOcLC2JbcuuWRFiSF5vFZ2bl8Wk1673qLKNulO1Ns3ss8p4clBKrOmCW05Qf3QtjneJPpnLgNZ1my07nd44sn9dGbhynuZimOoDS/sOYR
 5JYGNwaj
 neqjZ8BRjA6cnoQ6GC8uSX5SdBXNZKplMP48MlEs3VXh96mF3lTDSp75e5S/xfnI073ZWt2KCCKpKG5yRwiku4C7hlcxMK1apPG8xOQSAe/yAL6j/w1f4iotu3OjTsBWZISBzqe7Q/FDFxb2IjtlH84lhk28gQPF25dpjvUi22tbolYzHJKKjCMlcHp3sFIqqqofu8wMHluWoXZDf0XTVhzLyLgB9Z2n7vkHQHd9IZ9ZDWxMAwNk4pj2VfUKbZC31FK0qLOQAZvaebq3Ii9/h6FKYZgLJkPr97y96T/OwvZK0DDHSSh/6Gf6gT3U3oPvNJUhu+qsQjLXOtca0RgiwNYSDhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 29/05/26 9:32 AM, Linu Cherian wrote:
> Hi Ryan,
> 
> On Wed, May 27, 2026 at 03:50:10PM +0100, Ryan Roberts wrote:
>> On 13/05/2026 05:45, Anshuman Khandual wrote:
>>> From: Linu Cherian <linu.cherian@arm.com>
>>>
>>> With FEAT_D128, a new instruction aka TLBIP is being introduced for the TLB
>>> range operations which has an argument size of 128 bit.
>>
>> nit: TLB range operations -> TLBI-by-range operations ?
> 
> Ack.
> 
>>
>>>
>>> Add an abstraction level to void (*tlbi_op)(u64 arg) helpers to support the
>>> D128 variations when applicable.
>>>
>>> No functional changes are introduced with this patch.
>>>
>>> Signed-off-by: Linu Cherian <linu.cherian@arm.com>
>>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>>> ---
>>>  arch/arm64/include/asm/tlbflush.h | 70 ++++++++++++++++---------------
>>>  1 file changed, 37 insertions(+), 33 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
>>> index c0bf5b398041..361d74ef8016 100644
>>> --- a/arch/arm64/include/asm/tlbflush.h
>>> +++ b/arch/arm64/include/asm/tlbflush.h
>>> @@ -162,49 +162,53 @@ static inline void sme_dvmsync_batch(struct arch_tlbflush_unmap_batch *batch)
>>>  
>>>  #define TLBI_TTL_UNKNOWN	INT_MAX
>>>  
>>> -typedef void (*tlbi_op)(u64 arg);
>>> +typedef u64 tlbi_args_t;
>>
>> nit: tlbi_args_t -> tlbi_arg_t ?
> 
> Ack.

Accommodated both the changes.

