Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 545ADCAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 07:00:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DFBF8E001C; Tue, 30 Sep 2025 03:00:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 942758E0002; Tue, 30 Sep 2025 03:00:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 809928E001C; Tue, 30 Sep 2025 03:00:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C6508E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 03:00:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B4DCE879CD
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 07:00:13 +0000 (UTC)
X-FDA: 83945017506.14.A2C5EE9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id B9FEE4000A
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 07:00:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759215612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p1wips17F6Pis7sLhu50eaAc8bW3bG6wJ4x5ri0JeZs=;
	b=3s34p4WBVYRw8FwdVeaoRl+9QvuVxhspI09JH9WkmCs5aZ7p0+gnip5/yRsCgRXXI/AUd4
	+IeQpw4iOMNSQpu7fPlSan3zd5PNI6ITEg4RXFK2Wh+P3vinip3sSwRNMHp+rG1q0Jli4B
	3SJ3lVy0bU4d9n1dfAOdTnQTp2giUes=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759215612; a=rsa-sha256;
	cv=none;
	b=QljG9XTHIKIHY1/2VWexMO4RBsvMuS/QIhgJy7eQ+xUIrqQVXVpx/RoC21Hpoq2HEbFLsV
	H9h/MPSGx6cptOpn2h3zlUA3fsk40JiJoE1xRlZBVTnvu+8BLXLVVtDMxofrki+SYNOYel
	5brhMXu1u2PUo8fLtoqc1m5nNjOWVtk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B2F21424;
	Tue, 30 Sep 2025 00:00:02 -0700 (PDT)
Received: from [10.164.18.71] (unknown [10.164.18.71])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 277A53F5A1;
	Tue, 30 Sep 2025 00:00:08 -0700 (PDT)
Message-ID: <1f3c8fe8-cff0-4e3e-bea8-285b00fc7a5d@arm.com>
Date: Tue, 30 Sep 2025 12:30:06 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/ptdump: Replace READ_ONCE() with standard page table
 accessors
To: David Hildenbrand <david@redhat.com>, Dev Jain <dev.jain@arm.com>,
 linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20250930025246.1143340-1-anshuman.khandual@arm.com>
 <9736fd6a-8987-4b10-9b05-e03106463c34@arm.com>
 <f0f0479a-fdab-4f42-9600-5d7b44a73f4e@redhat.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <f0f0479a-fdab-4f42-9600-5d7b44a73f4e@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B9FEE4000A
X-Stat-Signature: ns4bopxc6d4s78baxpau3obomrfucbkn
X-Rspam-User: 
X-HE-Tag: 1759215611-7508
X-HE-Meta: U2FsdGVkX199FMJ9/RnKzjqXEbqWpqqEwnZ8/6vizQoBX6Hv00IIRwtFoWkVjalaCjRrD6MucHTCHCTcpwKpAx0XAWjcKmlkrVeyWQGxBmJkn6wMJSz2UZIeKhipAdlY/J/UY6+tvu7bARPxeZJFG8nbLvHZTvzEd5wg6OjjGh69PmUTKx7dLG+yPNev48ObHlNcKOdnAEbDzGuOT/vjDSOPAttQOV4vVWph8+rGlmI+T1DAyIssqkTCw+XoM7F+fJfXnFSxxqcDKPe8zhynwYY2brlfbRnnW5c0//zJyaY0eXar0K4/Jnj3+6+WqPrBLSS0z2ZtnB7KH6NHthwFFjmyZzgJuVDdEGQmSUuZ5HMRa7X+ITBq7EJXE1+Z7SK1Aus0c/KMaIPd8r3NlvPV9qFQSDqaw8vkwF9dNMhr2rXmC6hBFUSKK7PKbXSrLYK/FwmVtHdUiw7Ov4266yewBck8x816uOTQCaZA39Q2GVl++qdQU9AQ8Eiy/R+GJjE/zXnSF4XGIvnxdMya/r98ZSUZp3sufyVZi48yaD8PugngzlYlTMasyAYj8vBHJMQUw06Hr+a0+Zk2LDJE4yabZSKlEF9KOi2HPyn3AO6JM4FUdSOcB+lgjuElSIF9dN06f643mdmroENTwCoRkKKbwdXQpPyq+9/mOisM/f5kF1uNmX/3Up2Euq2I4F13Dxa2caWrzKMGE38EsLObt5p8QzZugXfi7UP9pd4PrxN7jt1CBoOE+Hvdbsv8jGWr8Nzy3jb0dbjiBJ0Y/kPUFE3nrIlCcvGw2vDf/FiaaBctBmjWJ5i17eKvIRTvb3EZlU67L5QyZKb1b3W8Xr0Q7SrMfKl4sg8wReshWoOdIrgzbap1cvg6frs+250wcsBW5dVzb0TnI3Hdb9Xf3ASYaq93dURZRBJLbVbwctliBaRmsDZ2qiLGSkLM2VBSzL1aDRX2/HCDIe+UET34WancjaD
 e8v8ULP/
 6D1RYqrP46wtHh48IoKJpp90QA7fLc0US93toQkcUuwz8Br/nixQUn/Ll5Y/AUPrNusng4OcixmZGORh36PqcUCHj4mgByN4qKO/oIu7nqaXlv01Rs8t2V/yECXU3m8m5oyMIen6nA3ekas8/qBTbQWV0LiFez3WqPcma+5c6lKbKb/C+utPq9/pbMSc34JSx7xXwn5a150PJpQSdrA7cWxEX/HsrxlRm2VUatYOa6sx6FOEXHLgyMqRczpBIyAVm9KI41A4gI2ek14bdFhOnZOTkKSlerRd8FviVldHydJkfocN6DwNGzHvF2CJ94vSd+B6AAk90Emu6R8NfePzH6oRtwhFTTmt37Xc8hRF4eJP5QjqtVCKI2SCBuEWSXRaxLM3cRQfomkc4Di4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 30/09/25 12:11 PM, David Hildenbrand wrote:
> On 30.09.25 06:37, Dev Jain wrote:
>>
>> On 30/09/25 8:22 am, Anshuman Khandual wrote:
>>> Replace READ_ONCE() with standard page table accessors i.e pxdp_get() which
>>> anyways default into READ_ONCE() in cases where platform does not override.
>>>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: David Hildenbrand <david@redhat.com>
>>> Cc: linux-mm@kvack.org
>>> Cc: linux-kernel@vger.kernel.org
>>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>>> ---
>>>    mm/ptdump.c | 8 ++++----
>>>    1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/mm/ptdump.c b/mm/ptdump.c
>>> index b600c7f864b8..18861501b533 100644
>>> --- a/mm/ptdump.c
>>> +++ b/mm/ptdump.c
>>> @@ -31,7 +31,7 @@ static int ptdump_pgd_entry(pgd_t *pgd, unsigned long addr,
>>>                    unsigned long next, struct mm_walk *walk)
>>>    {
>>>        struct ptdump_state *st = walk->private;
>>> -    pgd_t val = READ_ONCE(*pgd);
>>> +    pgd_t val = pgdp_get(pgd);
>>>       #if CONFIG_PGTABLE_LEVELS > 4 && \
>>>            (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS))
>>> @@ -54,7 +54,7 @@ static int ptdump_p4d_entry(p4d_t *p4d, unsigned long addr,
>>>                    unsigned long next, struct mm_walk *walk)
>>>    {
>>>        struct ptdump_state *st = walk->private;
>>> -    p4d_t val = READ_ONCE(*p4d);
>>> +    p4d_t val = p4dp_get(p4d);
>>>       #if CONFIG_PGTABLE_LEVELS > 3 && \
>>>            (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS))
>>> @@ -77,7 +77,7 @@ static int ptdump_pud_entry(pud_t *pud, unsigned long addr,
>>>                    unsigned long next, struct mm_walk *walk)
>>>    {
>>>        struct ptdump_state *st = walk->private;
>>> -    pud_t val = READ_ONCE(*pud);
>>> +    pud_t val = pudp_get(pud);
>>>       #if CONFIG_PGTABLE_LEVELS > 2 && \
>>>            (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS))
>>> @@ -100,7 +100,7 @@ static int ptdump_pmd_entry(pmd_t *pmd, unsigned long addr,
>>>                    unsigned long next, struct mm_walk *walk)
>>>    {
>>>        struct ptdump_state *st = walk->private;
>>> -    pmd_t val = READ_ONCE(*pmd);
>>> +    pmd_t val = pmdp_get(pmd);
>>
>> I believe this should go through pmdp_get_lockless(). I can see in pgtable.h that
>> some magic is required on some arches to decode the pmd correctly in case walking
>> without locks.
> 
> pmdp_get_lockless() is a nasty thingy to handle selected 32bit architectures.
> 
> But given that we're using ptep_get_lockless() in ptdump_pmd_entry() it probably wouldn't hurt to use pmdp_get_lockless() here.
> 
> Staring at ARCH_HAS_PTDUMP, I don't think any 32bit arch would actually end up compiling ptdump.c.
> 
> E.g., on x86 only X86_64 ends up selecting ARCH_HAS_PTDUMP.
> 

pxdp_get_lockless() not really required here, let's stick with pxdp_get() instead.

