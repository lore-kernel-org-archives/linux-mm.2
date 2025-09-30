Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A34E6CCA470
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 16:08:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFBC68E0016; Tue, 30 Sep 2025 12:08:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD38A8E0002; Tue, 30 Sep 2025 12:08:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D10EB8E0016; Tue, 30 Sep 2025 12:08:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD3C38E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 12:08:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 82D93BB599
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 16:08:49 +0000 (UTC)
X-FDA: 83946399978.13.59EDF66
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5CFE3180013
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 16:08:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759248527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9ERTZyjeNn7Z1YB3SDvghBvFUsYQLhyFTfcBqZhK0M4=;
	b=tG2SOcMPeYSjOjIfzn0tasaOooUEi881YKcwe0ZqCu2aJcPGW68U1BaFMoa35O9q4SKrkf
	2EXzjBcQt6Ww78Df1yuYctbw9TZiLWFGHrT6Nz3vI9+eXOwVFiAJ/+Ze7qf6XYO8jN2Xn2
	8MN4xwbZVLpKNATuR3bC0rOlq/hdX4Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759248527; a=rsa-sha256;
	cv=none;
	b=31jFXjKhIkfqvh0Hrp71NB/zsEhGvSDVsLBsrwJ2d0Qhfa8WGA9HDAnXKPu5R9wWsDLPlL
	aIsSICGKKNShYs+D0F3PR2Z2ZTk6prYA1k3YbISvP2HapkX2sZ9fICuBaqlCjAfzx7QnlJ
	lNZoX0bvp/cJk7TfH/uSAZPIjtgMxY0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 367021424;
	Tue, 30 Sep 2025 09:08:38 -0700 (PDT)
Received: from [10.163.65.117] (unknown [10.163.65.117])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 880333F66E;
	Tue, 30 Sep 2025 09:08:44 -0700 (PDT)
Message-ID: <3399336c-f08e-479f-aa9d-de6bac9bda61@arm.com>
Date: Tue, 30 Sep 2025 21:38:41 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/ptdump: Replace READ_ONCE() with standard page table
 accessors
To: David Hildenbrand <david@redhat.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20250930025246.1143340-1-anshuman.khandual@arm.com>
 <9736fd6a-8987-4b10-9b05-e03106463c34@arm.com>
 <f0f0479a-fdab-4f42-9600-5d7b44a73f4e@redhat.com>
 <1f3c8fe8-cff0-4e3e-bea8-285b00fc7a5d@arm.com>
 <25653f37-6ba3-442f-9348-d879a8ad4704@redhat.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <25653f37-6ba3-442f-9348-d879a8ad4704@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zj7bkixcra6tidg8wnf4766f84rsdqrb
X-Rspamd-Queue-Id: 5CFE3180013
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759248527-631930
X-HE-Meta: U2FsdGVkX18c0AXlMIcepaY1rZkgH5U5XyYoKN1Op8ERniEtNl0QsSsJiUHwNdqyh5NuyfdNmMweDNjQeQ7zhO8bI6b8qIxNg8LXngjq+gjnItooDCT6Bf5mxSN0wY8ADuNJGjbE/0OBGVkK/YKvME7ATDwFBvIhhnSquhpy9BKoBlPhk61fLCle7DukMj0N/jbDcpi+O7emfp2Rsgx6xG3sQku+f07ckx/9o/OhX/qBlSV3ugHsW0AVcEa/LSoUkVAEfEEPJyv8L3Yg1WkJo3IY+F3E3UdSeVmMsk5GYpCCUJ5xiWuiAg0EmdG6Jb2rfDowELCvcKMEyL/BmUpXc5ySakQ4d7ZFzVTjqp9/ldHWg6WNkVGUfYyW5iAJF4UyrMUznH/PRh1kj8n8LBkybauxIJHMcRxuqToFz2YcQAlffmN9HCJoQ3hPHkl0EtVOjJ2zdE8TF8cztS1e4Pw1eV1fLh0hdelnOmJBSv5z2Bn4wWuIqSC24oZmSSkl6a0TfcZyPebbKv4DYYVnUe53tV2BfzieHV8cpp1nB50NoMahE6uFlqHEQ+eevwfqX2hRyvjkcO5/hTophEH+saO/p10h1LOIqvuEByBcZzf5o22xx+fQzU5dvy7ifJW7YKpD/whYq8uAvhFzeFx+gWfnzEbaQb2yIFs2hcaP0iN20LutDbkUpMnccbI97jCUlPjvQ6x5wy0dLXVvza/FMP6LjCGGUpgNvA1C6W0UjdMe1+u82jnsfX4bBMQpCAxB4Z77jjyE/Rz+Uh1TiDC0hSvI3FBurUNOwytRZk1IQvQFh9+sDZp70ZNkWhVIdJ4abyWe3ic7trpTL97lz3vfsMHVwsM97jZJuV5X0FyVCmcTBrKAlzqwRIvXtnADPBmTFsDzsoMXAQ5+DHJhna8zRQtUlO+LrnkluZEli2WmiaztFYHem7FTzWjM7hNg4MXBmXBrkJAnWEEUMwUUGk01bYM
 U95Bd4E0
 XDLfC6Zum6UtJZzOwhQ2OVzrvJYiI+IQD50PBdRbouMKvokUnq+lYoyQgEIP5ziELGe62LpUsjYkR8waePHZ1rWBSz7VxGejVhyMKsTEk0ddpieFajmJpj3fNRHHeqcc0iaZDo5Vamm7xZCxq1dJLTN3nJh5dSvbzI4gu2PMhrY3c8oROWi5uPbEjFGAv3mXYI0AZF/+3AA1uajENf8HKpStlGChTxg1+yuEm6Ma2A0d1rCrayy/Ji+36oosNK+dS5nPZ41QqWTUxcpkIKig07bmfIXs3wglhGliwaJ80Ug2gwLfLBQrJBly+z/Yh6SLTxszkvxHBf3plLQc1w0qO7+gfchdmOdPeBVg+JyDUVWaljDbUvxerODUsvwB6oniBqC/a0/A7pOvFH8UfAyS0uQ25mjQtEHiu7ASyffrQXNRSAekvhmIT3HnGRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 30/09/25 8:13 pm, David Hildenbrand wrote:
> On 30.09.25 09:00, Anshuman Khandual wrote:
>>
>>
>> On 30/09/25 12:11 PM, David Hildenbrand wrote:
>>> On 30.09.25 06:37, Dev Jain wrote:
>>>>
>>>> On 30/09/25 8:22 am, Anshuman Khandual wrote:
>>>>> Replace READ_ONCE() with standard page table accessors i.e 
>>>>> pxdp_get() which
>>>>> anyways default into READ_ONCE() in cases where platform does not 
>>>>> override.
>>>>>
>>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>> Cc: linux-mm@kvack.org
>>>>> Cc: linux-kernel@vger.kernel.org
>>>>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>>>>> ---
>>>>>     mm/ptdump.c | 8 ++++----
>>>>>     1 file changed, 4 insertions(+), 4 deletions(-)
>>>>>
>>>>> diff --git a/mm/ptdump.c b/mm/ptdump.c
>>>>> index b600c7f864b8..18861501b533 100644
>>>>> --- a/mm/ptdump.c
>>>>> +++ b/mm/ptdump.c
>>>>> @@ -31,7 +31,7 @@ static int ptdump_pgd_entry(pgd_t *pgd, unsigned 
>>>>> long addr,
>>>>>                     unsigned long next, struct mm_walk *walk)
>>>>>     {
>>>>>         struct ptdump_state *st = walk->private;
>>>>> -    pgd_t val = READ_ONCE(*pgd);
>>>>> +    pgd_t val = pgdp_get(pgd);
>>>>>        #if CONFIG_PGTABLE_LEVELS > 4 && \
>>>>>             (defined(CONFIG_KASAN_GENERIC) || 
>>>>> defined(CONFIG_KASAN_SW_TAGS))
>>>>> @@ -54,7 +54,7 @@ static int ptdump_p4d_entry(p4d_t *p4d, unsigned 
>>>>> long addr,
>>>>>                     unsigned long next, struct mm_walk *walk)
>>>>>     {
>>>>>         struct ptdump_state *st = walk->private;
>>>>> -    p4d_t val = READ_ONCE(*p4d);
>>>>> +    p4d_t val = p4dp_get(p4d);
>>>>>        #if CONFIG_PGTABLE_LEVELS > 3 && \
>>>>>             (defined(CONFIG_KASAN_GENERIC) || 
>>>>> defined(CONFIG_KASAN_SW_TAGS))
>>>>> @@ -77,7 +77,7 @@ static int ptdump_pud_entry(pud_t *pud, unsigned 
>>>>> long addr,
>>>>>                     unsigned long next, struct mm_walk *walk)
>>>>>     {
>>>>>         struct ptdump_state *st = walk->private;
>>>>> -    pud_t val = READ_ONCE(*pud);
>>>>> +    pud_t val = pudp_get(pud);
>>>>>        #if CONFIG_PGTABLE_LEVELS > 2 && \
>>>>>             (defined(CONFIG_KASAN_GENERIC) || 
>>>>> defined(CONFIG_KASAN_SW_TAGS))
>>>>> @@ -100,7 +100,7 @@ static int ptdump_pmd_entry(pmd_t *pmd, 
>>>>> unsigned long addr,
>>>>>                     unsigned long next, struct mm_walk *walk)
>>>>>     {
>>>>>         struct ptdump_state *st = walk->private;
>>>>> -    pmd_t val = READ_ONCE(*pmd);
>>>>> +    pmd_t val = pmdp_get(pmd);
>>>>
>>>> I believe this should go through pmdp_get_lockless(). I can see in 
>>>> pgtable.h that
>>>> some magic is required on some arches to decode the pmd correctly 
>>>> in case walking
>>>> without locks.
>>>
>>> pmdp_get_lockless() is a nasty thingy to handle selected 32bit 
>>> architectures.
>>>
>>> But given that we're using ptep_get_lockless() in ptdump_pmd_entry() 
>>> it probably wouldn't hurt to use pmdp_get_lockless() here.
>>>
>>> Staring at ARCH_HAS_PTDUMP, I don't think any 32bit arch would 
>>> actually end up compiling ptdump.c.
>>>
>>> E.g., on x86 only X86_64 ends up selecting ARCH_HAS_PTDUMP.
>>>
>>
>> pxdp_get_lockless() not really required here, let's stick with 
>> pxdp_get() instead.
>
> I'd suggest that we keep it consistent. That is, also removing the 
> ptep_get_lockless() if not really required.

So in theory, the _lockless variant is not required, but surely 
consistency would mean that since we are

dereferencing the pte without the PTL, we should use the _lockless variant?



