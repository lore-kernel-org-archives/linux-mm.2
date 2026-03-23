Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95D0AF483EF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 20:03:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E785F6B0005; Mon, 23 Mar 2026 16:03:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E29A06B0088; Mon, 23 Mar 2026 16:03:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D16F46B008A; Mon, 23 Mar 2026 16:03:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB73F6B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:03:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 754E71EFC4
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:03:18 +0000 (UTC)
X-FDA: 84578402076.27.73FDFD1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id BE4EE40014
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:03:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V3bPvp4W;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V3bPvp4W;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774296196; a=rsa-sha256;
	cv=none;
	b=qtW19oVhZz1QCcksYchJyTSB2wyrXWrHYVILFv2xfuMwCYMS0P0f2pmSQ1AVD2s19wi16D
	YgH5lZ9zdac95muB0qSm9PYdp6Z/9rbJMKDZLvyT3j8iyUa7OXL/0omCJrJKddK6YmEhDA
	MctByoX+afuaNUM+UF4zE5HkrScyvZM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774296196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LMiD7aGBWRNBc8rw8Ru2feX03FfkuHXnCvx9PhfP2jU=;
	b=rShn9qH0nZgdkENomgW+GIyQFmeF7F3EohAL7q1dcbSvtRXDmToeLhkVNY2atOCxSVgp6t
	uK04EzR0vwrAtE6teEON8a84pi9EPPrO5URgWnYRIDU54Vlg0wpEG+aIuDZ3SdBV5EiuAC
	ZVfm0q6/UZQM+D9QqJnOtQ+ftnpjOVs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 223E0600AC;
	Mon, 23 Mar 2026 20:03:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E24C4CEF7;
	Mon, 23 Mar 2026 20:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774296195;
	bh=Ry9/ThWWm3NaJS9J3iVFhUufSXRZider2VTGGVSZX4U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=V3bPvp4Wdw1HLhSEqO/pabWccNaY498YACGXN3O+FZpo9FjukTwWbpqvcmE2F/XmD
	 QZL5OhTizu5WvdlI7OG0seoyzZnigqpECWskMbvqRy/y9M1XvKD8CVpPFfRAXqSgIl
	 wJpSamxOoYYM2ZKor2b6GB3b1TGRpLT+zL4ApYg01UJVYUzPW2xL6nZSjhiXQAAR8q
	 zmNnMhkLR9hRfdtYqtFizqt3jKTWaNYjU3zTRL4SU+tfgV3N6lW+hTKnChBljDrKTF
	 SKtLZpYwbKPUYVGUAD2OFdab3ZuEmW2XCoCjxgABgbTr1TBT6CmU3SD4Br23pu5BNl
	 fwmW91a7puHAw==
Message-ID: <ad64f739-4cbd-42df-8dfb-2e5f89a96f2a@kernel.org>
Date: Mon, 23 Mar 2026 21:03:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 05/13] mm/page_vma_mapped: Add flag to
 page_vma_mapped_walk::flags to track device private pages
To: Alistair Popple <apopple@nvidia.com>
Cc: Jordan Niethe <jniethe@nvidia.com>, linux-mm@kvack.org,
 balbirs@nvidia.com, matthew.brost@intel.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 ziy@nvidia.com, lorenzo.stoakes@oracle.com, lyude@redhat.com,
 dakr@kernel.org, airlied@gmail.com, simona@ffwll.ch, rcampbell@nvidia.com,
 mpenttil@redhat.com, jgg@nvidia.com, willy@infradead.org,
 linuxppc-dev@lists.ozlabs.org, intel-xe@lists.freedesktop.org, jgg@ziepe.ca,
 Felix.Kuehling@amd.com, jhubbard@nvidia.com, maddy@linux.ibm.com,
 mpe@ellerman.id.au, ying.huang@linux.alibaba.com
References: <20260202113642.59295-1-jniethe@nvidia.com>
 <20260202113642.59295-6-jniethe@nvidia.com>
 <81e7bd1c-54d5-4f88-969a-685177447c51@kernel.org>
 <abzSSHQUnDs_AFoz@nvdebian.thelocal>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <abzSSHQUnDs_AFoz@nvdebian.thelocal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BE4EE40014
X-Stat-Signature: oy8jqcw88uuf1q5tekm634pqt31aydxo
X-Rspam-User: 
X-HE-Tag: 1774296196-636568
X-HE-Meta: U2FsdGVkX18M1GFLNe86SbtD6HDdcFzGROsENv7qQlMPUETs0jeL377WQKxumkfTBgIM+OIEz2s6nmB8XqG/l2Xir0NzJkJ62Zhs/awd3FNy/TLpj0NeCo1Gi7Mr4NHdlKv2TAdZTkOSgoyWHHXReex3dYJALSFKpqMoej0nug38qOd4aeKUuPr2XYNh8zuIUu5EfGPLS/07M3T/U/HInhoA3LF9Wjfq+MgOUZFShq7cBPWz2AdihQqHZQgUssv0yNwaUyRJPhV/t7dTY8Xu3XrLdF2laobhPWYWPQSFdOSWZ/kyHHUUhQR52Ulv+3zQ5zcFedXOV9Sgs9EqQl+kkE2iW5Q+EvKKdCyX2iNL7bmV0zvIkNL1NYGXCVRG83VkxYDVvgdeG19R9sVrNv/BvBR0KacVKNeDFu7NKdpX9trcA994roWpTp3G4AEWFPrYCfEtRr8p3XdKAJ7gmr+RUJw9g5TE8LZdU3GuRRKOuuVKe6BwMlPaTxb3zkZQaoTjb6LpIs/ZScIhLfBjQERPNtYsIwGuaoEZwRmd2HwiHkza3xdNR9VuGRryZ61I7F2uCizHFEZxYYRdGmGc5gWqVeek0YbaBClTQN8ZVQbvQNxK1U/QEZNiWHQk2JMMLYEWxK1jQAW6rEW7H+w4zmKz43S8156kMssepQ3Q80AQFmVYhzoTEb/yf9thBarnNB1HXTdDw6W46EHy1hR+/cBYVdF0CNv/Z9Ds7A1h9dnropAoEJEhaRnrcWZgRaUW6H07//K6ahyZa0Abf2rGeN7N70pqVjtNGXQ86PPQ1rltzZDfkGj1dzSQ1JF/lILGRF/sIiY9WRLrwRhyp7OurniukByTLMsf2HyONOSdbcYr/hwxIYUp3zx8+obUL6B5r3lEYB+dAIc16O1cRp072vuHOmH4uO0VX8oOqTTeEybpDC0M4X6I0gtsOXIg9Xi8OYBl/Fllmd1+m2/2eL7UjZP
 WJbTLLDb
 5d8eaHVtOaqG5s0fjOmgRHHz/lACp9XQwJhCId9NrzqwyUDiX37U1EKrVR5ibZM78njdTU+UyrPsHrb/Wnu9GO0mblPkDPWKfZoG9Z806guSXTYLr3yjrHnSYOUtL8nd/SgDK6AehqNYgEgYNcP6fxVbtp6y8VtO/cVfhkvsI+h+kobjHxyotKVwpPVGD3no02aAJj1Tw39Jnt/iRl6OMj6a3SGuMeb1puzXQ4BrIrZ1IS9LZ78oOUkd2OSY8ksB4qaPbnVdPDEafpwF+hLpfIZgQ/zOGlmQr+Dr4BZ/frNjkKQVR8gN6TiPU9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>>  #define DEFINE_FOLIO_VMA_WALK(name, _folio, _vma, _address, _flags)	\
>>>  	struct page_vma_mapped_walk name = {				\
>>> -		.pfn = folio_pfn(_folio),				\
>>> +		.pfn = folio_page_vma_walk_pfn(_folio),			\
>>>  		.nr_pages = folio_nr_pages(_folio),			\
>>>  		.pgoff = folio_pgoff(_folio),				\
>>>  		.vma = _vma,						\
>>>  		.address = _address,					\
>>> -		.flags = _flags,					\
>>> +		.flags = page_vma_walk_flags(_folio, _flags),		\
>>>  	}
>>
>> That's all rather horrible ...
>>
>>
>> I was asking myself recently, why something that is called
>> "page_vma_mapped_walk" consume a pfn. It's just a horrible interface.
> 
> I don't disagree, and in fact it used to consume a page until 2aff7a4755be ("mm:
> Convert page_vma_mapped_walk to work on PFNs"). If this was a page it would
> basically resolve all the hackiness of this patch because we would no longer
> have to pass PFN context around. So I wonder if there would be any opposition to
> changing this back to taking a page?

Are there cases where we pass a struct-page-less PFN?

The offenders are pfn_mkclean_range() and mapping_wrprotect_range().

pfn_mkclean_range() is only used by fs/dax.c

At least the caller immediately does a

	dax_flush(dax_dev, page_address(pfn_to_page(pfn)), count * PAGE_SIZE);

Afterwards where, apparently, a page for the PFN exists? :)


mapping_wrprotect_range() is only used by drivers/video/fbdev/core/fb_defio.c

fb_deferred_io_work() just calls page_to_pfn(page). Huh?

Best to explore the history what's going on there.


My best guess is that they don't want to modify page state. But that can
be expressed by the helper functions and doesn't require us to have such
a weird implementation.

> 
>>
>>
>> * DEFINE_FOLIO_VMA_WALK() users obviously receive a folio.
>> * mm/migrate_device.c just abuses page_vma_mapped_walk() to make
>>   set_pmd_migration_entry() work. But we have a folio.
>> * page_mapped_in_vma() has a page/folio.
>>
>> mapping_wrprotect_range_one() and pfn_mkclean_range() are the real
>> issues. They all end up calling page_vma_mkclean_one(), which does not
>> operate on pages/folios.
>>
>> Ideally, the odd pfn case would use it's own simplified infrastructure.
>>
>>
>> So, could we simply add a folio+page pointer in case we have one, and
>> use that one if set, leaving leaving the pfn unset?
>>
>> Then, the pfn would only be set for the
>> mapping_wrprotect_range_one/pfn_mkclean_range case. I don't think
>> device-private folios would ever have to mess with that.
>>
>>
>> Then, you just always have a folio+page and don't even have to worry
>> about the pfn?
> 
> That sounds reasonable to me. We were hesitant to add a page back to the
> interface given it had been removed previously but lets try implementing this to
> see what it looks like.

Thanks!

-- 
Cheers,

David

