Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63FA2D41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 10:57:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B025B6B0006; Mon, 15 Dec 2025 05:57:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB3E96B0007; Mon, 15 Dec 2025 05:57:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C9A96B0008; Mon, 15 Dec 2025 05:57:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B24B6B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 05:57:38 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1F932136F48
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:57:38 +0000 (UTC)
X-FDA: 84221404596.19.0D8AA25
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id DEF9720014
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:57:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765796256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O6RPzWqzp7oee1+jRU091cOjstwwj6XRCSIyK33CPW0=;
	b=p83BV+s5DH+mm6cbgjYft5dk7t5xFDfkiFUBfcyhOfvGbhLRScD1kgd15D7yL4VDANHrTb
	LcvkUCbfYzxGYLpjjTTNHlL6K32vML4cmDdBQ54sEJNVQ85desXQhBbN55D3SY1ZJxAtIR
	z7or7bI6L8/A+wRzy9O6M/bsY1SBx9o=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765796256; a=rsa-sha256;
	cv=none;
	b=HHCfBvMjCB1ECt/XL5HTjBzOqcoRx8DBox2Yt4gcHBogn6Eoth9Y6CHkkgQslDGfUxa+1y
	1sxz7PO2Jp3hbE/uPyFXvWDhJPlQRPX4fKRQnwzkIX6o1ydZ5GThbISRi1IUXbcid3y6MH
	5ZNVkAV1ZIV1JfqkPqBLauM0yVeGKQk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 89F03497;
	Mon, 15 Dec 2025 02:57:27 -0800 (PST)
Received: from [10.1.30.155] (XHFQ2J9959.cambridge.arm.com [10.1.30.155])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BC2553F73B;
	Mon, 15 Dec 2025 02:57:32 -0800 (PST)
Message-ID: <6c76b8e6-3e39-41a0-a4fe-9012c3eb8446@arm.com>
Date: Mon, 15 Dec 2025 10:57:31 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/madvise: Use set_pte() to write page tables
Content-Language: en-GB
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Samuel Holland <samuel.holland@sifive.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Anshuman Khandual <anshuman.khandual@arm.com>,
 Gavin Shan <gshan@redhat.com>, Zi Yan <ziy@nvidia.com>
References: <20251211081117.1126521-1-samuel.holland@sifive.com>
 <20251211081117.1126521-3-samuel.holland@sifive.com>
 <1b7e682e-86a4-4573-b423-65f9755f71ea@arm.com>
 <5daa9569-a3a3-40ad-86d4-ad47080fa5aa@lucifer.local>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <5daa9569-a3a3-40ad-86d4-ad47080fa5aa@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DEF9720014
X-Stat-Signature: u8wmzqisagusumyb13dn6y6y3rygm943
X-Rspam-User: 
X-HE-Tag: 1765796255-112428
X-HE-Meta: U2FsdGVkX1/xYiwA9/fllz0QcBVTHvs25z5OObY9wFkvcmYPP8CLcXB3TKMJ+utmjQkPLRxvIg1ldpbGjuEXjUAMD46uUEtu0B9dht2RwrQkeJtm0FxyXtEo4ZWfA5mQ3J9okCuBK7AF92vVVRJzJkcTd/d7gcCDzOhlQXtNmgiLFzXwLpLK5evkP8LIIpUWOy8YyQixJJPidC6xrRXivc+ORVyruy8AMvAA6DwNxa3gtCt2q26FVlD0IO+f42mbkn3dP65QAsrc2C3hkU+56BxYNOixDhVAkBbE/tOGQR6d/hXsOL4WXknVgRHU4QD93C5mb4Yt9ULLrD8ZnHmcnKhn3abZEMtT9qzfe3qxOrAPuh7SSw5atUm2LzCBfhmeeBOruVjWeKk3sgqAevP/z5yUEWB9cpSbeadotj9UR4/ltz8lxIj5bcgF+65t5W7mechAuytMJ6h66yIqc2YoiLk2sKn5iYQW5LzA6T/6OuLarEVZPVSaE0CrK8JdOUmMCIxxVrtzP7l6lM6AcQFGXLRpfq/1uiCwg2wv+MwJtYIbqOj/m7OSFUa9H0LT03cvm0L4WC46dpxYKGeMFGW31QhMjZbjJ+9dWaT9Pl6grDwqhiln409FOL1kEXma951YjMOXMyD6Fpi2Gge6rs3bTegrsEZ6EDQbzbnJenJrqD8piszAVp4fEYrAu7odKI5dcLWihZ0/BOz2Y2M6Q42tqTXQVMYz2f3ZjAq/ao9rYAHSTh3kPDUVbeYskbg+n9fRtWEb0XROhKnoDb0XbkvIOS3vziOR5o9O615PDhhEJmlmNTtSUrmPEi4RX1COE/3cmhRUPEyrjaxBuYulGexe74u3vxLyDqaK/I8SeZTrwMw3VDJMiF4Re+o7mGa/ptnyoKGpXdG4m0IoxyKcDdhXudnrAb5zimcy2RHEcNUP4LeO8BFNSlHJeHC1L6fPtEiJIdZCetHkECEq75q9RP0
 l3OE+tFm
 HTv0NDVZT9o48RIOvAyC2s71IulNpClgRMm4QzrjZsqYRCLqelyfwK07Mjlup65cxCXonuPkHj8WtMasGzXhSkAqymad9CopPWuW+7dBkxO+ofKYvEro8dkXwDAouFZzMO+7LIRRHy1mUR/k7aQ2DWCBWRukiPOAZJNvrvfleGXBkgoCcciN8UY6C3jgWaiRIQ4O+Yj0/drFZS2QW+4ZTPR3gn63T2e28VNt9H27QtAmmArPSggPukoEUvRQy2C2fuCTbcVxqsxYgHdeuaBNzu7mgixg44QLsd4HQBOzPBmvAcOLvQXp6cE3jvWJ5wBmzUgDHdvxDH7yZZmelSuUFlobq4ohDDyjP+s0FI1cvMZux+FDfKy3eMqeIKsPfmD+rpI7SJTh8G9YbOkU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15/12/2025 10:37, Lorenzo Stoakes wrote:
> On Thu, Dec 11, 2025 at 09:43:58AM +0000, Ryan Roberts wrote:
>> On 11/12/2025 08:11, Samuel Holland wrote:
>>> Generic code must always use the architecture-provided helper function
>>> to write page tables.
>>>
>>> Fixes: 662df3e5c376 ("mm: madvise: implement lightweight guard page mechanism")
>>> Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
>>> ---
>>>
>>>  mm/madvise.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/mm/madvise.c b/mm/madvise.c
>>> index b617b1be0f535..4da9c32f8738a 100644
>>> --- a/mm/madvise.c
>>> +++ b/mm/madvise.c
>>> @@ -1114,7 +1114,7 @@ static int guard_install_set_pte(unsigned long addr, unsigned long next,
>>>  	unsigned long *nr_pages = (unsigned long *)walk->private;
>>>
>>>  	/* Simply install a PTE marker, this causes segfault on access. */
>>> -	*ptep = make_pte_marker(PTE_MARKER_GUARD);
>>> +	set_pte(ptep, make_pte_marker(PTE_MARKER_GUARD));
>>
>> No! As I explained in my response on the other thread (which you linked in the
>> cover letter), it is correct as is and should not be changed to set_pte().
> 
> Yup agreed, esp. given this is my code :)
> 
> Also some arches don't define set_pte()... it seems set_xxx() functions not
> really intended to be used outside of arch code - see
> e.g. https://elixir.bootlin.com/linux/v6.18.1/A/ident/set_pte
> 
>>
>> Copy/pasting my explanation:
>>
>> | I tried "fixing" this before. But it's correct as is. ptep is pointing to a
>> | value on the stack. See [2].
>> |
>> | https://lore.kernel.org/linux-mm/2308a4d0-273e-4cf8-9c9f-3008c42b6d18@arm.com/
>>
>> If you go look at where this function is called from, you'll see that it's a
>> pointer to a stack variable:
>>
>>
>> ---8<---
>> static int walk_pte_range_inner(pte_t *pte, unsigned long addr,
>> 				unsigned long end, struct mm_walk *walk)
>> {
>> 	const struct mm_walk_ops *ops = walk->ops;
>> 	int err = 0;
>>
>> 	for (;;) {
>> 		if (ops->install_pte && pte_none(ptep_get(pte))) {
>> 			pte_t new_pte;
>>
>> 			err = ops->install_pte(addr, addr + PAGE_SIZE, &new_pte,
>> 					       walk);
>> ---8<---
>>
>> I agree that it's extremely confusing. Perhaps, at a minimum, we should come up
>> with some kind of naming convention for this and update this and the other
>> couple of places that pass pointers to stack-based pXX_t around?
>>
>> e.g. instead of calling it "ptep", call it "ptevalp" or something like that?
> 
> Not sure that'd clarify, we already have a bit of an inconsistent mess with all
> this :(
> 
> Given it's a stack variable I'm not sure using a helper is in any way helpful
> other than I suppose to account for people grepping around for incorrect page
> table manipulation code?

I've proposed an approach to clean all of this up. I'd appreciate your opinion
if you get a few mins:

https://lore.kernel.org/all/a063f6c5-2785-4a9f-8079-25edb3e54cef@arm.com/

> 
>>
>> Thanks,
>> Ryan
>>
>>
>>>  	(*nr_pages)++;
>>>
>>>  	return 0;
>>
> 
> Cheers, Lorenzo


