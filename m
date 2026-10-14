Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BEF5CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 08:02:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27DEF6B0088; Wed, 14 Oct 2026 04:02:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2557D6B008A; Wed, 14 Oct 2026 04:02:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16B5E6B0098; Wed, 14 Oct 2026 04:02:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A8EB66B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 04:02:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32D86C0479
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:02:49 +0000 (UTC)
X-FDA: 85320490458.25.0423443
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5988740004
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:02:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HBpdrmSu;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791964967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X9ytMwqCWIzw05HboKv/lmzrNih4neXNeq84eInfJtw=;
	b=7+Wmq8lcezOkAm/pWO8HuM1eIAOMW8ZkQlCOA/Y66keG7rQg+g34A6zV81meAewYWTVorK
	UIXQEB3IFU3XrT4UgobHMASylFWxSshZ14ddR/ZHnVvIZ75b6cZVfqmIqHUgpd1my/4AG4
	wvIwLbP8fydAv89XMbx6AP9A0HSX51E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HBpdrmSu;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791964967;
	b=YzaBWPE3uToIQf5nq/ssm/RSXjrlV0+WbTPc2e8YnzUpp+coZYhvwn+Re31JRkIG5Uc5iH
	YpL4mEdP4m0qtatbKiFTYL3tZDcr1Hxr42FUzawAsrrY33x+nRpEc/wlU1rML38BpPVnCY
	zZ5SRNftrojjwzMkw+PeTXL+CGYLYbk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CB8F243483;
	Wed, 14 Oct 2026 08:02:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41CD1F000FF;
	Wed, 14 Oct 2026 08:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791964965;
	bh=X9ytMwqCWIzw05HboKv/lmzrNih4neXNeq84eInfJtw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HBpdrmSuw1yhtNos3sT9tV91CknmD7XQmyevZJ2kCvLr9wL4Ai7tkicw8qI3xv88b
	 WcGTwbsyvZjeXWw8Tt1CIgz99OdwOUzSskNkuWPT2J4HuUlOhCu22SH991wQJRkeUB
	 JmmBAaVOFoQwJNoUzQjbofuUe1Esyw80tPOtyEzj56RMbdFZlPWuoto6Y0uJTaG85l
	 fBFmF2xPxHBAsI68U9XRMUQuVNyw12y9NCl6CsZvodMpCXbONKufSOU2jOfyQ5dkOL
	 aytwcAT4mgsn/uGjeMeJG3qvYL24Rbw9tqsfxUR0sezq+tQ7nsYttUzCLc0Rlgx+W/
	 H2J5w58k0XqOw==
Message-ID: <e9a6d5e4-31ee-4dea-b2fa-1813e7cf69ed@kernel.org>
Date: Wed, 14 Oct 2026 10:02:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: fix address wraparound when scanning large folio PTEs
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Ying Huang <huang.ying.caritas@gmail.com>,
 Barry Song <baohua@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Chuanhua Han <hanchuanhua@oppo.com>, Kiryl Shutsemau <kas@kernel.org>,
 Kyle Zeng <kylebot@openai.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261013-folio_pte_scan_range-v1-1-c50dc30bf6ad@kernel.org>
 <5848db18-9de3-437b-9967-162ced4f8cb9@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <5848db18-9de3-437b-9967-162ced4f8cb9@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5988740004
X-Stat-Signature: xohqtkpisfhh915ignmrrfjs39hzoyxp
X-HE-Tag: 1791964967-203969
X-HE-Meta: U2FsdGVkX1/yTUR3qHTCB/QJOTO0/Shjfl5oDVM3gkbOT/QxQKYhH8mjUY75D/7O6xP7SIdPEuBjos+20gpsWyoZjf241Z8SSd6f1ktK6+kvsKrvhxvfsYhl0OjCeEfS0dToSRa9VpbHasMgBlDMbFZBJ7BbtkOV4B4MZ7z2LFYaUiC+fGs+hRDXGIb0kEYA7Cuy05cdPzwiO05xVc6PGaM7e64DRY6g0SRvgwXi1pIDR6f9F1Ux9IgC08UA2YuFHMgYtdRJIAJDFT9ezQ9gSrkk3vD8Y8AWDjx2GnPSZUaAMp6KrqjjuQ77JRZp++9jN5huqxZlkI4TAlkjjr8OgGLicbaL/KHKc0fIi3236s/vtVU5t6a9t8MDOb15ZGZHddKT8ggpPW5rxAALbf80z0lvqa5evT66QXgXiEMqhPcCV3xBz3e3tA3EfuedxwUR/+tcbNhMReFQB6m4FgyeSSqtYYHF3Y+BYUA7TXe2JtXTy895/jf8u0/eA4A2cqHKNZKlzZv6YEazmEJnUhQn4hQEctJ5jbzJx8lWU3KW87xymVeiP7mXcoB6Tn/uxN3uYNS0kXiHNYo8R3OG5XXbCXPeu6NrjtUpPmPfYliQuMSH1bG+yt0hA8lTd/bRL7v8YdXY+W7HKuc4anwRAsK/rRbrK89mutTf+I+G9n37KpcQI7aP+tY4mY/I7onFlpVsW2aM4wbI3ojz6A7KXFfEetOo1DwkjPhAZMaEAqfr0Axu8SlDMNuBTZ/FhkiJY3RYTF8uxOaUu31/86lT7CIFnk5J68RqMdF2rNI2NHE3dxszUDAPIuREyso7aUvxN8x04dY+zFYnsL+cyEDSikBGal8QZbNIf+16Bq1rvGPVWsrSZu7xDqG8iVoaJq5gppu2AUuyhtN2ZBZ1CK4a4sFoWU4sCpaKlKu5hyQlv3OPMUxUVFajo3QxJu4LwFz1+qIDiy2d7Bc1SU9KInvRPiJ
 0P5247E9
 xwn4CsaOxzzTUzT3jXUN6FQWux7J9/FTDciOO66KIe6FtxIAukOlpA/LYYVdeM2ON25rMioSVOxXqhdG8GBMqcERxrP9mYmp573iCa91h+nSixEhZ4CxGjvwItaiTINLpeSGsuSClveTBz8dixhYKfwEM6L2myLgWpZPDfNk3Pib+6XjkbSl1+YDxGdzQg4DIvN4owiKOnnxHxbB/XbrkFaSBoFo+W0ZKdSSPMok6YfG3OUZDmK+B89TYjyUUmpPkNHjqmwcLQcmBLb9kG1iypZQoh5VZfCDxuR7Z4181TMLRZTzQtBhuT7/GlGcRepkWrexfdbiog8aLN8qKaCdyIksyhxSg0fYzJpPytGqnrFTMGLZ2LE5wpg3BZWpOSluy08UeVEE27CFoZydCGPi4O3lLeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/14/26 08:02, Baolin Wang wrote:
> 
> 
> On 10/13/26 8:30 PM, David Hildenbrand (Arm) wrote:
>> numa_rebuild_large_mapping() and do_swap_page() can be tricked into
>> generating an address wraparound, crashing the kernel. All that's required
>> is to map a tail page of a large folio close enough to the start/end of
>> the address space to e.g., make
>>
>>     unsigned long addr_start = addr - (nr << PAGE_SHIFT);
>>
>> to wrap around.
>>
>> Let's fix it by providing a better helper, folio_pte_scan_range(), that
>> takes care of staying within VMA and page table boundaries while
>> handling possible wraparounds.
>>
>> Reported-by: Kyle Zeng <kylebot@openai.com>
>> Fixes: d2136d749d76 ("mm: support multi-size THP numa balancing")
>> Fixes: 508758960b8d ("mm: swap: entirely map large folios found in swapcache")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
> 
> Thanks for the fix.
> 
>>   mm/memory.c | 43 +++++++++++++++++++++++++++++--------------
>>   1 file changed, 29 insertions(+), 14 deletions(-)
>>
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 1f5d5f7d39cd2..a3823010aa981 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -4933,6 +4933,27 @@ static void check_swap_exclusive(struct folio *folio,
>> swp_entry_t entry,
>>       } while (--nr_pages);
>>   }
>>   +/*
>> + * Get the address range in which a folio might be mapped, assuming its pages
>> + * are mapped consecutively and the folio page at the given idx is mapped at
>> + * the given address.
>> + */
>> +static void folio_pte_scan_range(const struct folio *folio,
>> +        const struct vm_area_struct *vma, unsigned long addr,
>> +        unsigned long idx, unsigned long *start, unsigned long *end)
>> +{
>> +    /* Stay within the page table and VMA boundaries. */
>> +    const unsigned long pmd_start = addr & PMD_MASK;
>> +    const unsigned long pmd_end = pmd_start + PMD_SIZE;
>> +    const unsigned long lower = max(pmd_start, vma->vm_start);
>> +    const unsigned long upper = min(pmd_end - 1, vma->vm_end - 1) + 1;
> 
> I also agree with Barry and Lorenzo's suggestion to use the more readable
> pmd_addr_end() helper. 

I had that, then I found that for folded page tables it does something rather
odd, which made me assume "this is not better at all".

-- 
Cheers,

David

