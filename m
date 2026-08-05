Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8001CC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 09:19:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 963816B00A6; Wed,  5 Aug 2026 05:19:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93B496B00AB; Wed,  5 Aug 2026 05:19:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 804AA6B00AC; Wed,  5 Aug 2026 05:19:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 572D66B00A6
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:19:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EDF141A040F
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:19:36 +0000 (UTC)
X-FDA: 85066667952.12.5E721BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 313C9A0007
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:19:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kmvrLNS5;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785921575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kfnmpr6GEj1FHPYVMIjYF/Kb8wqffAltgYC9c/5TBl4=;
	b=zyn9BfRvqKh3Z4TozyfQGZ9bZzngYRM6sVH9rI3njeE0iCjPBScduopQIQs2ip8RTSKzAS
	KQqLgNi84ssw1Vh3nnRvo73IIxweGX1D0IVH7ty3Q/z5uIToJ+aD/TyiXUgTiqbcrKzyU9
	HoWFlN7Sgm7Hg9OfcsRLbnodj/aKd/Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785921575;
	b=ElnK0RPaaCj6oETMiaos1DDKntgartbxboemnNe5PGS+1UXszlnNvEZOwoYDCooyDijHwN
	w/rP4NZPEqAyGscjyIGQsUjOn+5sX3yaZZ8tNehbDn3E+fh603Q+Lwm7V8G2K1vUX1cNyV
	ghUFjC8DY0RUce8HCC/xUS27Lt0VGZk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kmvrLNS5;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 795BE40AD4;
	Wed,  5 Aug 2026 09:19:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20CBC1F000E9;
	Wed,  5 Aug 2026 09:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785921573;
	bh=Kfnmpr6GEj1FHPYVMIjYF/Kb8wqffAltgYC9c/5TBl4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kmvrLNS5KdvLxuTo6MYs0ioatgHYlqjkCH2yg988Nbq+Ej7STNB35fvcsBn2OUVfd
	 ytCKVqM5Dad0InAD9LOHYshheWB0nLJdGhenQo1oC3MqZn29kVmNaN9aVsUXVLdwjM
	 9Pg1JSSkE5r1owPv1Zty5Wlji1nT21SzRfebUbvZHBIz6eaFEXuCersuJI7Wvs+hr2
	 Gc8XxSJ168m5AaQ/y7i1dQzPKBg/VDBZw7D8OnqO9tqiXO1+y/lM7q/LSb4lH/FPgJ
	 /2+A9WQm9ULYBHY7tmWgURiZn9oQAA9/VyyLPVx7nGEp+FJoUITQkaU1iOEUC+y5+d
	 O3mvPt8ffQeXg==
Message-ID: <aba0e91c-ab9c-4420-9ed4-9e42cf03ecfb@kernel.org>
Date: Wed, 5 Aug 2026 11:19:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/15] mm: propagate VMA anonymous page offset on map,
 remap, split + merge
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-6-e8ecfefea812@kernel.org>
 <4ad4b17b-bae6-4169-8649-bff4a29e7fde@kernel.org> <anB9MWSSITYpDibA@lucifer>
 <6ea7cdad-afb1-45af-a63c-30b760fe160d@kernel.org> <anLyhaI6kW-EWk13@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <anLyhaI6kW-EWk13@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 313C9A0007
X-Stat-Signature: h6s4k3rtynsm5noqfjz3puqfzia18xjk
X-HE-Tag: 1785921575-462567
X-HE-Meta: U2FsdGVkX1+awmdxFQphVeEP+gftG67oBWrlE/zN1mG2EI7CwxPClK0TMGXCnU2LGR/uQEDTMV6GLU/gZPDKr8uHd6ifDSwQF33Fo1L92V8Ymu6rRWXtKQiA3gFBjT47Yqw62fw0uFbjK2kGM7WcO56uubbM+l5mf/KFJcrxCzO80EdQjX1oIz0q2ZWMGpFVvM4XiKBqr8p/JkonAgpOatCmzZzAvO/mtuAEhwI5dBgb5DDzIddyN0IKZsoUyTJ/zcmZXGLMtoZ4vpdbl8qFD8xSopUbfiRSUSBP90sU1G7TAkO44vLrgTiP51kvAqP1b4DWavhl884HjjQSjZKjKvR8UOTSQyam+SKoz5tAtfvbkbMxQMPkPJzF9T+P+bEIt+iNzqsGAAyjOM5yzLa+WMl4pkvyngWRNg9Jrn+U9yNF0c4KWcvFgh7ZXRoWlaiLqCVTXKF3mf144stzqkfzQxdbyyO7wMl0+HHxKiQnFcL4F4yyjWmr4amj1xEm4nUFZhG2fGW6UeWzeoNwiYzxZV/XWd7IjZ87AWHcTPjFH+n3momk78fF77en4C60KxT57Su+aQCEbPU6ivEUXe8lA2uYMMJbTem7Y7pN+fH1NnMql6C1kq2ERRfJrE7q1tiXH08aH1+8zwEUjsxAmRsUtbz7MC9WSicmYIjEpBHIi5Rr5bl0PK2N16n2PDpnUIZlwJZ2LGGg+X8gb19BJZ5CUj4YvjBvXungkCNG63Wrvd41y3cQNzFv35eoT4yA47UrA5iVO5rC7atM5n/Pj2BqAad0+2LAJP/UZGzIV2XfJ560fhiErxjjoTl6E0vv99UhddKhjFQ79OeLWJcutW0YnimxrUjFDQ0ptalKpfeawaUd75LbdVPRLFpuOk+5ZLHaYRApjvaypRohA8Vt0/Og6PIu4RG0wyuk+uV89LFhqnfFmcr9dnccryozdM4e0P9t8R5qoDJQZ3k1jABSmu8
 hz5bYvon
 d5gAJkEJ7S4OvE0UFN1THKZngTJyUzVpHq+KEbf5EWudead/xqtuhWl88LrUETJQP4ei/y2s0nQL/NCluix3X9UI+KmwJ1A76i6Pua1xJvF9Cf2sETH4jdYgDvT1aqZy0k09GBpWcZ1Sb5U3hJWUw8OMIxGiRc7B/f7b2ndWVzRc6ILGKL0m8D/0DrGM5/leucshOL6oMqIALVt3RQA73437Sxr1GYfqYMt+9m2uakkhOh2Lak/1gOiPW1xl9GgcPgUgpmYVaLhoct4PCG0p9aMwehgFpT5sxEXVOmF2XvSp0b/cpb9kb7zIi68gmZmM29dlv7wsLwYbvRb6G2wBoGRECbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/26 10:59, Lorenzo Stoakes (ARM) wrote:
> On Wed, Aug 05, 2026 at 09:35:56AM +0200, David Hildenbrand (Arm) wrote:
>> On 8/3/26 15:46, Lorenzo Stoakes (ARM) wrote:
>>>
>>> No this would be incorrect.
>>>
>>> A read-only mapping would become unmergeable here. So this is something apart
>>> from the rmap aspect,
>>
>> I'd assume that we should never even consider anon_pgoff when merging
>> !is_cow_mapping(), it doesn't make any sense.
>>
>> No anon folios -> no anon_vma -> no anon_pgoff
> 
> You can merge unfaulted ranges is the thing here.
> 
> But anyway I actually wonder whether this whole branch shouldn't be:
> 
> 	if (!vma->anon_vma) {
> 		...
> 	}
> 
> Because that way we keep anon_pgoff updated even for MAP_SHARED mappings. This
> isn't necessary and doesn't impact anything _except_ print_bad_page_map which
> outputs both pgoffs.

Agreed.

> 
> But it'd be consistent, avoid any confusion about gating on VMA_SHARED, and
> simplify the code :)
> 
>>
>> But I think I am missing one detail here:
>>
>>> and it is a contract that upon move of an unfaulted
>>> mapping (which for read-only anon would always be unfaulted) that vma->vm_pgoff
>>> is updated.
>>
>> "read-only anon": I assume you mean an anon mapping that does not have
>> VM_MAYWRITE set?
> 
> A MAP_SHARED mapping of a read-only file becomes a MAP_PRIVATE !VMA_MAYWRITE_BIT
> mapping and must adhere to the same contract.

Right, but that is not an anon mapping, it's a file mapping that similarly
cannot have anon folios, ever.

> 
> Also mmap hooks can clear the VMA_MAYWRITE_BIT.

Right, but again, if we'd have that being done to anon mappings, other things in
MM would already be broken.

We assume that anon folios can only ever end up in cow mappings.

> 
> However:
> 
> - If you're a driver clearing VMA_MAYWRITE_BIT you should only be doing this for
>   'special' mappings anyway (I have a series I've not sent yet that establishes
>   this as an invariant also) - and these are not mergeable anyway.

Jup.

> 
> - If you're a !VMA_MAYWRITE_BIT MAP_PRIVATE-file backed mappings you never set
>   vma->anon_vma and always update anon pgoff so you always have alignment for
>   purposes of merge.

Jup.

> 
> So I think also we can then change needs_adjacent_anon_pgoff() to:
> 
> static bool needs_adjacent_anon_pgoff(const struct vma_merge_struct *vmg)
> {
> 	return vmg->file && is_cow_mapping(...);
> }

Agreed.

> 
> [I have to create a vma_flags_t variant of is_cow_mapping()]
> 
> With those two changes we gate on VMA_SHARED_BIT nowhere :)

That's much clearer.

I was thinking for a second whether to have a more expressive
"mapping_might_have_anon_folio" or sth like that. But it's a bit mouthful.

Most instances of is_cow_mapping() in memory.c want to know exactly that.

> 
>>
>> I recall that that's a combination that cannot be created. While you can create
>> something that does not have VM_WRITE set, IIRC VM_MAYWRITE is always set for
>> anon vmas.
> 
> For pure anon yeah, see above for the MAP_SHARED->MAP_PRIVATE-file backed weird
> case.
> 

Agreed.

>>
>> --
>> Cheers,
>>
>> David
> 
> (It's funny to me that if you want a truly read-only MAP_PRIVATE file-backed
> mapping (no idea why you would but anyway) you have to MAP_SHARED, but an
> actually MAP_PRIVATE file-backed mapping of a read-only file is writable [which
> makes sense obviously] :)
I guess this boils down to

MAP_PRIVATE of a read-only file allows you to COW. Which is usually what you
want when placing breakpoints / letting the debugger go wild.

MAP_SHARED of a read-only file doesn't allow you to COW, and can consequently
never become writable.

It's confusing, yes.

-- 
Cheers,

David

