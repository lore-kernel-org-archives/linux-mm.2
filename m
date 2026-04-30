Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82E47FF886F
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 04:58:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AC296B008C; Thu, 30 Apr 2026 00:58:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95D276B0092; Thu, 30 Apr 2026 00:58:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 872C46B0093; Thu, 30 Apr 2026 00:58:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 74FB26B008C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 00:58:17 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EE670120495
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:58:16 +0000 (UTC)
X-FDA: 84714015792.10.F2AF590
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf17.hostedemail.com (Postfix) with ESMTP id 220B240006
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:58:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nOmkU7+x;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777525095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nOeEENJP1qRQ6oeQfqR7IGsNJOArnz9T4pL66Gjzcg8=;
	b=xAig0xT8kL6DogLCwtUH0uc0XZYlVYC2dmDsB42wik4bJsviwY2LkHeS7K7rZ/HEImqNHC
	hX4x8SrX4NovWExGRTIF7+SRkXdsVxWCILKB2UZ/AYzD8RxI//gbP5+ztxCSREZVCiGBe0
	d4VHEF70RUG4RCjsq5XKyMWoJMQl1fo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777525095; a=rsa-sha256;
	cv=none;
	b=x6mnHtTiwgfZV/luOeI8SJr5VawP/VJVnsFDws5FgfJdM+wktvwDv8c8ad2VVo1arS/rcD
	TJoFm9luI6ZbYiYoc9pb09osVrurf0K6Ig61RdrC7K3Kes1yyeIlKeVjjQ1tneD2Npg2aj
	Ge2eg08ibmGrT11crRQG4Wo575G6iZg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nOmkU7+x;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
Message-ID: <9f9bb7d9-ca9b-4a8b-bb6f-093bc27a63f9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777525092;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nOeEENJP1qRQ6oeQfqR7IGsNJOArnz9T4pL66Gjzcg8=;
	b=nOmkU7+xdE5TInxjcUQxokbTqasETg2shl7eEasMnHfaFBh/zFHzXk+Q8n7hbdB2iUV/hJ
	5WimqGrGeOCPa4rI9bbUHAKjntgr52+2LDhZSrIwAYxEul4UCMZDgBenUKVQAUEJ27xOE1
	2VkLgme0XLOYgJKIxqH9kIlEwdvYK84=
Date: Thu, 30 Apr 2026 12:58:03 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/huge_memory: skip huge_zero_pmd in
 zap_huge_pmd_folio()
Content-Language: en-US
To: maobibo@loongson.cn
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260430041121.2839350-1-maobibo@loongson.cn>
 <20260430042834.80895-1-lance.yang@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260430042834.80895-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 220B240006
X-Stat-Signature: ohykhpctsi6n1tfi7t11cyisa6inzwo5
X-Rspam-User: 
X-HE-Tag: 1777525094-142365
X-HE-Meta: U2FsdGVkX1+hLbgNHhE5zm5cqx02yEegaz+XEFlZ+OOpGpPJ/dC4y/yiTMK5qjHFgDK+4jIFr4ovbMreCuOLorfYKekthLbhc3BlfXN4ZexU0/h/tIZwnYEKZHmcqmmckErcBM0yRskVi5hbpWmK6Ib5Bh8q1t8m29BXRPTDXCKdAFcFmr+FDIZ1gLg7se8yNsomgkE44Pz7YX1gkkC8gWHBMdcdyachHOgaozHdnR1beYUQe018W2ivttPt2ic4lFn8vTFe1yzgQ3dGHQtKos0a9+P8ZQ55GiCJdGc2P9rhPeIdvGWOjzyMsYJH3KRhNcOx2xfYAv5Hd+H/svYLAf2VT04Yrw/F13wHoRBgae/RzjtGHx8efpFVWqgZLJq7IShC6y4DsJQCeuEAxwnWX0goK7C08QNaB/JZzMKh0cRdJgXZIQkwzuxRdktl67D61HnrsDIwhSbG9pUYbRCBvnJTQBoFpqw/3eFFKSIkIm2ukCOY5jOXFCSuBacIkdVVga6DslQo7DiaBLq3G4sKIKBB7xjr+kTbRZhHr5Y0ni556uJhj5Kq+2LjDKswGZ7tcoFkfA7mA6h1uEjuI1Ac+NENLk7jCNZ/YNGc8/iSvoaUW4aIa/TI4EYXDISXw2jDblMH6pndv3dcmttF8gbN5CR/8AmavmcmKNowev6PJ0T2+EaF7TEL3gErRdLbNJI91aowiMfNBn0vevzVUdlWX5LwjgvtvSr2ShZDeDXZ2xRyeIOc0l2bVrI1Axku55oDovkIeOJ9/PywSTmrxS/KnK5sEdGKBtyUUARu6/glSxeepjOtxLlLaGRtQazd81r7+18RBlSPYkzi249S3UdyeLnPQ88iIb67lkYyucr0FoW/qcHrtow5SiTLbYuZSbr8pbHHbG3IWgKwvsBLXAELJAa9kUsCn0LhHTmLsdF46mKbdPMh6fE8/q8/bKfzIWDYCXvfUx+8r1soBGdbx8T
 v69yjUFe
 HSXAnMTbm72At3H+RYeOQc7YmaaKzMxmI7VewkNt257tIMe0hgbffdlJYtSLpUjSAVePO7u+oRim8W1iw64dBO/Uu3ZHezCiaZZqxqdPrk4cebLbAIN8Mz3EvACP9etn0jCyCuZ3Vly0zSsbXWB/pGN31ARXBFiNb3gMJrmjF1ktOMSk3Nf5EPn9mS+Gqni+KyX8LoNrxzFU8sNXJTijnLj0NyGm3gZocdKuwXdui2XRZLndwXDLm7lCNmEwuAzZvx5zibHdrWOjY8YIIQLmJQiVBfdK83x6r3hRHbdSoMiAKcK4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/30 12:28, Lance Yang wrote:
> 
> On Thu, Apr 30, 2026 at 12:11:20PM +0800, Bibo Mao wrote:
>> when executing command "make check" with qemu software, there is
>> error report like this:
>> BUG: Bad rss-counter state mm:00000000972846bc type:MM_FILEPAGES val:-4096 Comm:bios-tables-tes Pid:27802
>> BUG: Bad rss-counter state mm:00000000752180c5 type:MM_FILEPAGES val:-2048 Comm:worker Pid:27815
>> BUG: Bad rss-counter state mm:000000009c2f6a61 type:MM_FILEPAGES val:-2048 Comm:qom-test Pid:27825
> 
> Good catch!
> 
>> The problem is that when application exits, rss counter is calculated
>> with huge_zero_pmd huge page, instead it should be skipped.
> 
> Looks like the same problem[1] we discussed recently.
> 
> [1] https://lore.kernel.org/linux-mm/74a75b59-2e13-3985-ee99-d5521f39df2a@google.com/
> 
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>> mm/huge_memory.c | 3 +++
>> 1 file changed, 3 insertions(+)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 970e077019b7..3cbea344d4a2 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -2423,6 +2423,9 @@ static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
>> {
>> 	const bool is_device_private = folio_is_device_private(folio);
>>
>> +	if (is_huge_zero_pmd(pmdval))
>> +		return;
>> +
> 
> The huge zero PMD should not be returned by vm_normal_page_pmd() or
> vm_normal_folio_pmd() as a normal folio. If it reaches
> zap_huge_pmd_folio(), we already made the wrong normal-vs-special
> decision ...
> 
> So I don't think we should special-case it in zap_huge_pmd_folio(). That
> only avoids this RSS decrement :)
> 
> Could you please check whether the fix[2] also fixes your QEMU test?

In addition, like x86-32, 64-bit LoongArch selects ARCH_HAS_PTE_SPECIAL,
but not ARCH_SUPPORTS_HUGE_PFNMAP. So CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
is not enabled, and pmd_special() falls back to the generic stub that
always returns false.

So I guess the fix should do the trick :)

> [2] https://lore.kernel.org/linux-mm/ea1453a6-14c9-4334-ac7e-2758586393b2@kernel.org/
> 
> Thanks, Lance

