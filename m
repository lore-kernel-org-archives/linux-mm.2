Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B1C5CD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 08:16:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F8016B02B7; Mon,  1 Jun 2026 04:15:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AA486B02B9; Mon,  1 Jun 2026 04:15:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 898666B02BA; Mon,  1 Jun 2026 04:15:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 761E66B02B7
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 04:15:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2EB6E4056E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:15:59 +0000 (UTC)
X-FDA: 84830635638.05.336EF21
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5B7208000D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:15:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UXqYnVYy;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780301757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Fe6JYGyHSbXJX3O8KSfKT2Vqw40RbPEy7q1vSIqR20=;
	b=nQP2olDKGj40m4xTYZD23I4065bp5N8WS14z6pWRqM7FtLxSZwwmWBtG1L1Jta9PqzAllP
	8+neVivvTaXCagjCQS8/UqcJFiVf1nzgVtWb2IPBE2WfIo4A5Q4fE9t7m6sZ1aOnBvU1n6
	Ik4TkKi1jMlhYNRJS8dy/HVbJOp0g9Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780301757; a=rsa-sha256;
	cv=none;
	b=zkG3sEXe/Mqy8NokrQvU3S1o8QVcRTEnXsoaE6j7ptNYzf20puNLcIRwMnqkRYwFSl17Sv
	nBK4L/kJVPOwpqhOyqql+2+dSH0F1lhTbw9zfKv0+g1xtWrYX/3s55jYmCsmJCr+5ebPsa
	aFWoCCe1Ipf6VbBcsaKlGTxvvicFZYw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UXqYnVYy;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 54D8B419E3;
	Mon,  1 Jun 2026 08:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A701F00893;
	Mon,  1 Jun 2026 08:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780301756;
	bh=7Fe6JYGyHSbXJX3O8KSfKT2Vqw40RbPEy7q1vSIqR20=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UXqYnVYyrTNj3AbXP5FO8iA3F+UJFpvf8kNk4cUVukmp3d14TGCjR24dISkoXzY00
	 Nk13Ahn5ewSSi2UDtW7sIE/fczQu5QcGTaBCfZ09UmsaY7oKSRO4o8tGVZyftEt35h
	 JXOGf+iSgGPslC2095u/u9ChwJsEaPCP2cfP/sTkreHxILwL2IXJ33cPrzhHquvvv/
	 yRrGLIWJXN+3Mu6es5RWGfKWLFRGsoBOa70nea1qIMPCf12OzqsDDL6A0TZ77lwbNA
	 /dvgFUyAop3rVmVWwWohUBBudV4qdXIboac50dBV4llgHHSimEgh5CRgO+uEEHK31b
	 wS2KS6+JZZHwQ==
Message-ID: <1c99294c-9ebe-4856-bfde-09801701d75c@kernel.org>
Date: Mon, 1 Jun 2026 10:15:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v18 06/14] mm/khugepaged: generalize
 collapse_huge_page for mTHP collapse
To: Lance Yang <lance.yang@linux.dev>
Cc: npache@redhat.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, liam@infradead.org, ljs@kernel.org,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com,
 usama.arif@linux.dev
References: <2024af56-5e99-4799-a586-e9ba756cecb9@kernel.org>
 <20260601032804.96122-1-lance.yang@linux.dev>
 <f5d38f64-ab92-496d-afd3-29ccc17fec2b@kernel.org>
 <fb8f24b1-ce8e-4f06-bbd8-f148a9bcaeee@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <fb8f24b1-ce8e-4f06-bbd8-f148a9bcaeee@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B7208000D
X-Stat-Signature: etnp7bh4577dc7em1ua1sgrha9dgge4s
X-Rspamd-Server: rspam06
X-HE-Tag: 1780301757-487397
X-HE-Meta: U2FsdGVkX19OP6VHs2SogkHLAqV+9MA0W5Y8dBqdrq3ir5M/qzGJxHgxFA/THWTXbFMlgWk0rI0ieZzJvMEsc9jwUnJq0v/2B7LIwDyxwFAaON89Wd5/f9LaU/7ECdtH4qk2rEewl5Yyd80mybQRh1NI7Ey23RiRxkuOrqt8kgKFMVzkM/jXixaxZdQzucsSW+eRgNT7l+3IJY24Y91jwAkJse2ZV5q0BQg+ES+7m1AEWmkVrnyPDevPU4UMHpCHs+dEvx6kVaxmYOTTEP6ZIpv7HXLg9HYboMTa60sgTLMDc0Tc1fM/gEzrTxXEmVWtOdjqyfMT+SO3N/WLx8BTYQu5DL0x15qyVWdBT4Og/l2By2b/EaB5uy3WIt5dF7N3WR7dfYvV00sy4kHWCfqcv9zd7CBjb5aFl+ILOfa8o0HcWj0BulFfjRueQOIOSVfhqBCSPpeeEVeVqXDS0csif/epuNanHIDEV1PbS+rVWe0J1VSWJ1qsLAzeuSr0VRsIZ1levaYzfNzbLrxz9LB3ebplRir5V8ys1yczIogISyLxYyKXarQnxTtuFEOjEuW+dwXwAnqBf9jWmZa5oWwZEUHMi+7ZB5CeOaiMufZt90jg0gaVMjbVyEaFlvZ+xcdOAebywc0pERA6w/ifEbErQvIt+O7dXxfuHzdXCwX81UjBw58D1ol03kesMzGp5MD6VZM+aG45LGJgdlz/hqwcJGSjZP/Pj0XnzZZhgzqIn8SAaJq0ztVWHqFCgXr93YQgubJylw8rcHWrWGzE1hVvzcWvxtRF4pnU66MdeGu9DsG4U3vWOg+Tr4fCQ8Wjqkdd1Y1gACasZ9iyneP1emF+IGOTGKc4mL8/bQ1Ci4ofCYPo4P0lHn3KtoP9Eg2epEITFAzA0sWtT492l3wwjoRAEp9C8mMkoqXDEhzK+wuZpbTDuyAJhTnhFfHPaLPpg9I/M+EKCCBdscK3Xw3P+ia
 U5Qp51R0
 Rbm1+Cw0QhGsNpUcYP1nd5DU2jnmKf0hylg+YwBC9OUQcvd2P50DS0KhQoA/f7oCZWYGXgX/kmbYLAstVnChKk76cThMn1y4nYZuOeE4zKKQgmoBfOq89vePu0lrphb/ODas39aeCRbLhzLyq/7KxvXbqx8qKw5C8YxZO2G6oITAUnxuuSlyc7W28O0kMylJCMcOzZfzF6tJQSufvXnV8XNbNL7bphEHYEb60yrZbKSnOBtxwO92t+ngcDQEursHgD0qimKoPLgtaY3nlFczFujdyRg+I8eThuAFxaKgbcqw6CQBx8UI8HUlmDsKdZEZZ+rotZT1Y5O1ecWQV1csj3xuYz+wvogYhYBcGe9B7N0TIy3pe7ooKePeGuwhS1Ny3O9dnayMcmHd3makAZCSAG18YNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/1/26 09:49, Lance Yang wrote:
> 
> 
> On 2026/6/1 14:54, David Hildenbrand (Arm) wrote:
>> On 6/1/26 05:28, Lance Yang wrote:
>>>
>>>
>>> Ah, fair point.
>>>
>>> I was mostly worried about arch hooks that walk vma->vm_mm again, rather
>>> than only using the pte pointer passed in. For example, mips does:
>>
>> Right, a re-walk would be the real problem.
>>
>>>
>>>    update_mmu_cache_range()
>>>      -> __update_tlb()
>>>        -> pgd_offset(vma->vm_mm, address)
>>>        -> pte_offset_map(...)
>>>
>>> and __update_tlb() has this assumption:
>>>
>>>         /*
>>>          * update_mmu_cache() is called between pte_offset_map_lock()
>>>          * and pte_unmap_unlock(), so we can assume that ptep is not
>>>          * NULL here: and what should be done below if it were NULL?
>>>          */
>>>
>>> So if khugepaged happens to run with current->active_mm == vma->vm_mm
>>> here, could __update_tlb() hit the none PMD, get NULL from
>>> pte_offset_map(), and then dereference it?
>>
>> Likely yes -- that MIPS code is horrible. And the comment in MIPS code
>> even spells that out. :(
>>
>> Do you know about other code like that, or is MIPS the only one doing a
>> re-walk and crossing fingers?
> 
> I had Codex do the boring grep-work through the arch update_mmu_cache*
> code :D
> 
> MIPS doesn't seem to be the only code doing a re-walk, but it is the
> only one I found that appears to assume the PMD/PTE walk cannot fail,
> without checking whether the PMD is none ...

Okay, but likely the other code that tries to handle it is also problematic.

Best to make sure the page table is already installed when updating the entries.

-- 
Cheers,

David

