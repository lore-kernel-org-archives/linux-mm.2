Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECCC4C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 10:53:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DAA16B00D5; Mon,  6 Jul 2026 06:53:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B2606B00D7; Mon,  6 Jul 2026 06:53:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C82A6B00D8; Mon,  6 Jul 2026 06:53:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 32AC86B00D5
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:53:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3B2D840372
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:53:01 +0000 (UTC)
X-FDA: 84958039362.24.F656DFF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0186540004
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:52:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Y86LUQ/8";
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783335179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CxElX9YxKbFisNFviTpgkAO3DOkqXKK5V9oY4nfD6fI=;
	b=6kNNOlkA9tefhGW/5Cgj+fxNhlN7VK0HC7UV64yCWAfuEo1CX2IhDMc3GDi56lEAqxULT5
	/2cjB5OS4uI+iIcr1+wU/8RAp9vqH6H1RJlH7Hja46hKOJOsCgUGpS80/VjGBJ6Vggba5L
	+496nDRZ/JWfij93/bizJ3UObDFVQGU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Y86LUQ/8";
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783335179;
	b=NCEPjrJV2Nj4+iBHbzYf6XdaagOo95GWhFjgHMDOnSlw2ac7bD3frhlTVhImnIvgyfrLki
	quUxL3wMbKw59zEVCspKPCPwO3iELavCRz9fInIOQCjiaaiKaK8sx26ZZx4SUyHWpSbWT7
	O6qong+MeG+JL6LNXg9GNUNLODJZzNo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6E9512BC4;
	Mon,  6 Jul 2026 03:52:53 -0700 (PDT)
Received: from [10.164.148.41] (MacBook-Pro.blr.arm.com [10.164.148.41])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F4B13F85F;
	Mon,  6 Jul 2026 03:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783335177; bh=5PDQKPlKrlK5mkq4F/AqOm5P1FJi9r8quvEcLVadPkI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Y86LUQ/88wqr9q+XQgYX5M2rHKMDqwHVd78+V56i28vxi0bJqCg45smjItGSht6vM
	 LhTmj1Ma7QeT9qBKxDeVirPdzgpCOF1LMTwfCAoG4OkTwOZr6+PrXWwP5PvS1/LvOO
	 FD/IYsLJPBEPg9IDaQQJJIuEA9IW1pESzn+k4g/8=
Message-ID: <39a13445-dc6f-4a75-92b8-f4a122c63b89@arm.com>
Date: Mon, 6 Jul 2026 16:22:25 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/6] arm64: make huge_ptep_get handled unaligned
 addresses
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: muchun.song@linux.dev, osalvador@suse.de, ljs@kernel.org,
 liam@infradead.org, riel@surriel.com, vbabka@kernel.org, harry@kernel.org,
 jannh@google.com, lance.yang@linux.dev, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, apopple@nvidia.com, rcampbell@nvidia.com,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, ak@linux.intel.com, nao.horiguchi@gmail.com,
 mel@csn.ul.ie, j-nomura@ce.jp.nec.com, pfalcato@suse.de, tglx@kernel.org,
 dave.hansen@intel.com, jpoimboe@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org
References: <20260703114202.365553-1-dev.jain@arm.com>
 <20260703114202.365553-2-dev.jain@arm.com>
 <20260705003559.8b124d2b94b685cc2e4e77ae@linux-foundation.org>
 <8fdbe0d6-87fd-441c-b6d2-baac380f6fb3@arm.com>
 <4b4e8007-3747-457a-85cc-d1003e1c8fe2@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <4b4e8007-3747-457a-85cc-d1003e1c8fe2@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ad8kd9nmyq8x9mk67kz51fq6d1yierg5
X-Rspamd-Queue-Id: 0186540004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783335178-643896
X-HE-Meta: U2FsdGVkX19AjOhvd8Muc1uLZAb0Kk38F6HR7wIhAxZeaWXKeIC4TgffLrsX6UoTEeW7XF/fsjjK3g0olGNtSz0k+DZ4tGTOeaiobiok1Tu1CtH0q88eoXJjvhCMOG+FciB/8H1dvzWt23iam3iiXtk6TTS3c6O2Kkgnd0+N21tJXaRjP69zgSzT05As45haGuDJ5f9rSPbbOhAFYcK9dXEV3IQtN6ZSdMVEseaWm/ON+Mj/e+4V9MKV5UfVuz4kp+0RkolvOusDXuI+GZbmzK5UzcarddJHZ+dxBbwGh0ScaIX26pqx/RgjXXmmbcuIxK9NUBtootuDKiQRZpU/jKUoIpM0G70BP84lw6RrPNUE2W1KTCFJiD9gxo158K2e6LinTyveb1imgNkmsYrdpdFVhpPSE/3QTfS3TM9TASC5GtCSfeaXG99TviybQakoHlx9UsbtgGpU+XaOCFVZ/B9kXOm/48KjzQlB8ulDIaPDZhYG+r2kzL83nCj0hUXwz6vlmH/+iOXBQlQEDEuJviJNAfnAH0Tsvm+0fyAXATe9YbXtAui87ei51zzR46T3WVlBhFG6Ei9Jytaw0oxUdOhdodcPf4VA8TAbAo7/l5souXKLaxkaCziaP7q/XcGH5iiXN8I/g0+DSJXe8ZsZYbgV6v7TWOMLUKdbUNlnkr5fDSTumF6Sjdet4TOSGXmYNK+nkaVZjT3O6m9wsJ1innYXJB1gJa2VfUYN3Br5AO8S+GDCAQwoRGyLY3DY/sOKUa1QHkp3tizQof4II7a44cc/9Ys7SX3v+v/wnosIGfRYTeloGASgzxe1iHv0bCzr/ymFNVh6qvjQ1MFCyaxQ7wmpOvjAmRNpOyvKvHuSYryIpjZKU0LK52AoN7lm34ddIdTXew/jZ0DL/qQ5E7lMankG8a7RRK94IYyt0k4rsPJKR6desmRB9hji0lDzfBxc+ZFF968/l9jQ3tWnQ9t
 w5Nvy2TM
 s/cbt28P6yN3A8r7dJeb0bG7f515GJuibE4GLW7r162utedb0KPtn87mZNNHtPySEGeZnBqKblBai+G0V52iHKfzutKmSqjDhi2M3iZjKmOFcoe4eRKmmqF/IfXKjIjiKPVSlDr3YuLBsVVqzpEADFA7dM1srkRCyn7OYZYxt0nYhmEdq3HOEb0iKVUtWMHyZkylO2sSaf9sPUrT4RG6h7OGRpDF4cCtIFfz+7lWsYYYNg+3rHbiVJ7/8hMDNLZGzCnJh5v6lW9UEt3/3inMxcHfE9fMZygDv9Z/gR49/0EHniI5aO5Dhu91lZimy8SY8hzwPDmanOQEvjpFlQXfSfPpSzVS4wlUmdfeL7NSsW53ZHkcYcgvjFV89PNVn8G6x4AiCIRBf0RH3t/QARHp7+m8C+uNbY+Lu7qG3wooymsURkv1Hs8+78w6HODnFUBE38oe8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 06/07/26 2:15 pm, David Hildenbrand (Arm) wrote:
> On 7/5/26 10:08, Dev Jain wrote:
>>
>>
>> On 05/07/26 1:05 pm, Andrew Morton wrote:
>>> On Fri,  3 Jul 2026 11:41:54 +0000 Dev Jain <dev.jain@arm.com> wrote:
>>>
>>>> huge_ptep_get() can be handed a virtual address pointing to the middle of
>>>> a contpmd/contpte mapped hugetlb folio (examples of callers are
>>>> pagemap_hugetlb_range, page_mapped_in_vma).
>>>>
>>>> The arm64 helper rewalks the pgtables in find_num_contig to answer whether
>>>> the huge pte we have maps a contpmd or a contpte hugetlb folio, and
>>>> returns CONT_PMDS or CONT_PTES, so that it can collect a/d bits over the
>>>> contiguous ptes. We can falsely return CONT_PTES instead of CONT_PMDS
>>>> if the addr is not aligned.
>>>>
>>>> Fix this by aligning the pmdp pointer down to a contpmd base before
>>>> checking equality with the passed huge pte pointer, to correctly answer
>>>> whether the huge pte is the base of a contpmd block.
>>>>
>>>> Fixes: 29cb80519689 ("arm64: hugetlb: Cleanup huge_pte size discovery mechanisms")
>>>> Cc: stable@vger.kernel.org
>>>
>>> Please describe the userspace-visible effects of bugs when fixing them.
>>> Particularly when cc:stable is proposed.  Thanks.
>>
>> Forgot for this one. It should be, on systems where CONT_PTES != CONT_PMDS
>> (meaning page size is 16K) we could collect excess a/d bit state, meaning
>> extra work for the kernel.
> 
> Even worse, right? We could walk 128 entries, when we really should just walk 16
> (IIRC) entries, possibly reading garbage or even worse, into a memory hole at
> the end of memory?

Hmm I was thinking that the checks pte_dirty() and pte_young() wouldn't care whether
the pte is garbage. But, we could actually dereference a ptep pointer not having
backing memory at all.

Does the following sound good?

"On systems where CONT_PTES != CONT_PMDS (meaning page size is 16K), we could collect
excess a/d bit state, meaning extra work for the kernel. Even worse, we may iterate
beyond the PTE table and dereference a garbage ptep pointer to access physical
memory we don't own. Since the ptep pointer is a linear map address, we may run off
the end of the linear map, dereference a VA not mapped into the kernel pgtables and
cause kernel panic."

Although I checked on arm64, there is no case in which there is a hole after the
linear map, but still that assumption shouldn't be made.


> 


