Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B2B4CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 13:09:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D53956B008A; Wed,  3 Jun 2026 09:09:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2AE06B00A1; Wed,  3 Jun 2026 09:09:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C69206B00A2; Wed,  3 Jun 2026 09:09:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B3F7E6B008A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:09:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 723C21C099C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:09:32 +0000 (UTC)
X-FDA: 84838632984.09.82EEED3
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4DF271C0008
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:09:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="vm5hSF/2";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780492170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hcqvDrGcHqEyFCLA51sUV4Sc5w37DlSQfxQWt0KZ8ZE=;
	b=M5M+GdUYaouvGpAtSALBs6i2lN5fvAWMNi7xL40cKQZbCsWdKIiZYhFxIIala/REza2HeI
	iG80owlWgTE6177u/yRZzL/jcogCU/lbDDNekJ8c/fywUnsP3vNds7bkKjamMHN5aH+SPc
	Bt8ou2LzenwiDrC74lWKdd9bxrBiep4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="vm5hSF/2";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780492170;
	b=U0cb8ux82UMjJkLW1XkvEBtm+N7y2e6ePJ5WdaGykFWmBCqfXx4qxpahEEIe0B10WM0tDO
	0bVwuXXm0/mAsn7MyRT30z0l+eDtXofUSuUSiv+4FaNR7Ol445eoKn7qZL5cxWGoqjK3yh
	q4d3C1u0vSjH6i+h2c9JMVMoclLC6X8=
Message-ID: <3ec76ffd-2650-4302-87e1-8183029a0553@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780492168;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hcqvDrGcHqEyFCLA51sUV4Sc5w37DlSQfxQWt0KZ8ZE=;
	b=vm5hSF/2NMMHB/9RxcyxVabX5G0pPMxM3MBXwo2hruAmNw8p+8BB7iW6E5Lw1m/Qg3ONqK
	LlehzhHZ+6I1+4kLx4pskZkj9vvEHjEUhmPXkg7HGt+jp0pT0Sow0iX6wGiVHqYuSzn7TX
	YTfqFsFDUmLLFna9cX9Cx5HbP2mv6p8=
Date: Wed, 3 Jun 2026 21:09:18 +0800
MIME-Version: 1.0
Subject: Re: [RFC PATCH 1/2] mm/secretmem: try to restore large page mappings
 in direct map
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, luto@kernel.org, peterz@infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, xueyuan.chen21@gmail.com, ioworker0@gmail.com
References: <aiAJG7gdey4oNr4a@kernel.org>
 <20260603114134.3010-1-lance.yang@linux.dev> <aiAfnw088f3ZT3va@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <aiAfnw088f3ZT3va@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4DF271C0008
X-Stat-Signature: gz19ckcbu797y4ppieuraopjfkjxs5eb
X-Rspam-User: 
X-HE-Tag: 1780492170-571965
X-HE-Meta: U2FsdGVkX19+enmOaZ4wwy1RqpyR6DjFhmYL9GqWeYiDR7+syxWb/2lHj1EnR2s93uwrauutctuWSD7PeXfeiNzuOJGrrNBU4ZfLvceDcKRQTqzpqr4j07TH754R56OypJBH4p6iHO/HGhPO0vWxe5dLlCTuFWykS0UJ/XmOgftGVix7mxG9IPHL5kXGK+7TBz4QWL0Sy/cGr4LvSk0N3ludcbwHNmBojUQg5g+N94GQ2ME7JXEbrlEuXFlraDlDJ4XANVi5aTsyLuvYL8nd4Tf/SH2WJ9P2cZhpceLjhfclOcGgq0swSPRSfKtZTuu2kP9PP2AXoWUCRwoN3snYc7TXiSlgz5QVrhIi0JR03QZO2Z7VxreOpPcNblJ5qE/2gV1SyANbGjTy9ffdSuvba2pNUBpB4pa6YsiP7nQBYos0ZhhCknBY37X8MoblKvQ6MF3XGfAB4nUoX5yjbuHYhd0ixD40V7FHfS8ws4PlUH8R/iEMNT+7amX8CYxOyNAKsOh6BDtyKv+r/aafyNA/XvAagCZnYJGQX/KaRJ7ND6xu1DTE+Mfv050Cye/kavE0UQiHtso432HxPpp2hwRFbGb1MFu9C6QwyKpVENvU46Z6POacFilO6izRIKCIpjAK+7TOOdadPac0C+ikknSXXkfLBVihgDVoxUrTDg5uepfrOgKiMFXgMymT77KB1Msk461gl8AT2TAqzA4915pQ0qQKkH7MresQtdMXrM5qfd5jCkzuEPKkchj/4h4PdVVLA6WpapYGb6VHouKAX5vBDsCDq1sJoDWOJGfGC23u6mshzhY8lSL4a1GqPL/604XfpfLPvZS3OBV+fQgVTGhKqSUD8Imw68/xyxDTWXSUleDn2JMFriJsdH/A/VT0y0Gwlr+mfU/VnsKORML40xBSAg379LZiut3L9cVsEnOVADqqmbCY7yGD8iUGSi94DqEJ7PkF233lQZanySEOpea
 6lpgmDc4
 uaE3307Q8fX1H0bvkSn3VBZUgKrAqvEnftx7vhB5JuNFkHRuEwmUX9XwsueC5rQOMBdZ+xI5lp9E8JVWDpMrpdUB7wFarmxCmnrbzI1+viV1VQkYsVU4ZtdjcE+CycXcJRPZ3YBzT9/zVkF0vnS7SyVbFtbKY0wTJalTpQYjzJcaoCEfTg2SP82nJB+LF1VaBHB43edHGsj1ju8Ux02JY9r9ZBcSJotzbsgqsxnj0N50N5PNI+Tu4PW6zXD9/zFYFnBrGkAwddNd2vKfQPvCx9J81Ca61UdesUAimo2cklOHxjpkmhzVJpvNrVEPQzfKxQfymlmQSRfd8AWQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/3 20:35, Mike Rapoport wrote:
> On Wed, Jun 03, 2026 at 07:41:34PM +0800, Lance Yang wrote:
>> On Wed, Jun 03, 2026 at 01:59:39PM +0300, Mike Rapoport wrote:
>>> On Wed, Jun 03, 2026 at 06:46:23PM +0800, Lance Yang wrote:
>>>> From: Lance Yang <lance.yang@linux.dev>
>>>>
>>>> secretmem removes the pages backing secretmem mappings from the direct map.
>>>>
>>>> Removing one base page from the direct map can split the covering large
>>>> mapping down to PTE mappings. Repeated splits can leave more of the direct
>>>> map mapped with PTEs, meaning more TLB entries for the same range and
>>>> potentially more TLB pressure.
>>>>
>>>> So let's try to restore large page mappings whenever secretmem restores a
>>>> folio to the direct map.
>>>>
>>>> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
>>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>>> ---
>>>>   include/linux/set_memory.h |  6 ++++++
>>>>   mm/secretmem.c             | 12 ++++++++++--
>>>>   2 files changed, 16 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
>>>> index 3030d9245f5a..ad2fa414a22d 100644
>>>> --- a/include/linux/set_memory.h
>>>> +++ b/include/linux/set_memory.h
>>>> @@ -58,6 +58,12 @@ static inline bool can_set_direct_map(void)
>>>>   #endif
>>>>   #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
>>>>   
>>>> +#ifndef arch_try_collapse_direct_map
>>>> +static inline void arch_try_collapse_direct_map(struct page *page)
>>>> +{
>>>> +}
>>>> +#endif
>>>
>>> Did you explore what would it mean to hook collapse_large_pages() into
>>> set_direct_map_default_noflush()?
>>
>> Good point, I kept it separate on purpose :)
>>
>> Putting collapse into set_direct_map_default_noflush() would change the
>> semantics of that helper a bit, IMHO.
> 
> For x86 default means present + rw + PSE, so yuu can look at it as actually
> better enforcing the semantics :)

Yep. One x86 detail though, default seems to miss _PAGE_GLOBAL today. Not
sure if that is intentional or just historical. See patch #02.

>> I would expect arch_try_collapse_direct_map() to also be useful for cases
>> where a direct-map permission change could split a large maping first,
>> and the user wants to try restoring the large mapping after changing it
>> back. One example[1] is making a direct-map range read-only for security,
>> which I am also working on :)
> 
> I don't think users should care. The users care for particular permissions
> of a range in the direct map. It should be up to the architecture to select
> most suitable mapping size. The splits are implicit, I don't see why
> collapses can't be implicit as well.

And agreed, users should not care about the final mapping size, that is
up to the arch.

TBH, my concern is making the collapse cost implicit for every
set_direct_map_default_noflush() caller. I still lean toward keeping
it opt-in, but happy to hear what folks prefer :)

>   
>> [1] https://lore.kernel.org/linux-mm/9979fa87-88ef-4baf-8592-502ff4888085@kernel.org/
>>
>> Cheers, Lance
>>
> 

