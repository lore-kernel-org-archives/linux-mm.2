Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E44DFA0C47
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 08:13:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B360E6B0092; Wed, 15 Apr 2026 04:13:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0D686B0093; Wed, 15 Apr 2026 04:13:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A22EF6B0095; Wed, 15 Apr 2026 04:13:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 907A96B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 04:13:17 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 409B0E2B8E
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:13:17 +0000 (UTC)
X-FDA: 84660075234.12.2AE86D1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 756774000A
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:13:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qfDxXJsp;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776240795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+7uJlaUfJQqHdXX77E9kmnN5yQX25mWzs9EOCbz0QMI=;
	b=fTP2Eh9G/Rv/Bc0+2VpaNLGQuYyOB96QwPUtNkNrcMf+orOaGwvBdpvyco7OAMojoXs6DN
	uaQ5dfTKTvTmoaM47gX/inRbIWUz7JhNBl8cxRahS2Ta9fVRkMHbyp1eAWs1H3gcww+fQz
	h1oAx9FCJCT7ez2NcwCNmfUHX2OqpnY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qfDxXJsp;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776240795; a=rsa-sha256;
	cv=none;
	b=7miJtieLFAL7gWfxHmMRmd9y/eIxVEg1usDKgSUhHI6imVO5GkG+SH9XqwV+4WX270DWBD
	VB8/kgjLOCx+1OQg7jsEpPx24INaNgAeQgTlK7X/0fwcn9QaKYhNuKaln4J4z/7u7CxbFz
	Pel29DpNh2AVKkI7GCbumS46uXRn7Yk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CDC0B600AD;
	Wed, 15 Apr 2026 08:13:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F81BC19424;
	Wed, 15 Apr 2026 08:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776240794;
	bh=tABW2aXIM2rHOjCqXJFblXdHqk3XbsVf53PkS+Dy154=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qfDxXJspff7lFWZzIFgIgc/06nA3epYQvHbLxIcOadIfTZ81DX90oolTC50rA4Uqz
	 vnqXJGt5X9uNJ3IP049UTdLvVXLD8UXl39e6VjrrwQbgQedgovW/37zcrvUC2bZJQr
	 e4e/Nchblg5Su9d0xFci5c5kZgKpaUwEcXbySs+kZEEWZjuh5sex1Dv08+rVDjCEyK
	 S54egwSgCY6pvhdpIeWXiexTlwK7SYD8YHyRsY87GrNtGXrreFoH+XA4d0g/TnjeZA
	 tjRK7HIANnMqoRhMW2Mzon3jx4+ykrEonUy/8xu0noRPc5b0/kTpnDGoe+lXHtZrbb
	 WU6VOdJMp4hyg==
Message-ID: <6edde1e9-0f42-4dae-b0d1-3f2895f2111b@kernel.org>
Date: Wed, 15 Apr 2026 10:13:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/13] mm/huge_memory: add and use
 has_deposited_pgtable()
To: Yin Tirui <yintirui@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kiryl Shutsemau <kas@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1774029655.git.ljs@kernel.org>
 <f9db59ca90937e39913d50ecb4f662e2bad17bbb.1774029655.git.ljs@kernel.org>
 <41b1ff54-c120-42ae-8b74-54767abf3554@gmail.com>
 <fe357495-2e45-443a-93b4-52bf21d3bdff@lucifer.local>
 <c6748ac8-6dcf-41b5-a281-2f21069b1f2e@gmail.com> <adTb6_xqQoQqK74Q@lucifer>
 <2f29f66b-46db-4925-b922-4add61b633bf@gmail.com>
 <53d748d3-4150-4e7b-8c1f-4c58587e9183@kernel.org>
 <6125defb-3aa4-494c-abed-982be684f839@gmail.com>
 <6417587a-7e43-4615-9e2c-50a245842f59@kernel.org>
 <f7f26a91-5346-40d6-aee3-3b64c3249ac4@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <f7f26a91-5346-40d6-aee3-3b64c3249ac4@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 756774000A
X-Stat-Signature: 5zboomt1hbkcjwrapa5o7bzmtq4bnxg8
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776240795-674358
X-HE-Meta: U2FsdGVkX1/JEFCTAQZ6um40GkCpEpTs0tFo1AzILbfxh6RfCJzS/7wEhrgBvSCwNB7kl/kBE/vUdtgaiX2VRRmJevUeAqjJfFhmPDDtjKEk4XStev5ghEdvI7fds2ykGxQ7xhvh3btLlskhexJ2L87zppyI520olqxA8smvlpBRS+J5HfJUEDcC4L+5jcYvsia+RJhlEb3j5xp/F3aNtUDT6GlGLoghwiwbGgbT9tjinvyEfrpRn9c7JjCgQr+p9BqxR6qB+B9rNLbdQXnZRa3q+sik8cxEYB2T9dfiZm6dR5ukf5oVwDToEYknjFPYI2j+5HsjY3/jT/JH/SUufupRFYBxWe0jwl/HaJOE+1W3Ai0BjNrAwh7nmqfQTX4LJJc3tRvaV7ApiNtyBt4fzjr6TNDIE6CUy2vXq+YgsMEzNiphOkFo2IHKVzKXb+7jaFYAZ9vz0CtHJecBx6MOv10F+lm9ezbxkwlRbqr146p+0Qc1ThESmHT3tSHe5HKV9n5/DwXRvC/b+hclV/RrPBElNMo0CG7hHRmibBmn4wcHt+RymnRQn2iwE2gZjeyqzyjxyaP5C3JjS7ZQBMukYNnYQO+0ONY7LRcRUPyMCmOt1vmZ7mG/wptUsFYyM8WuAaC7D+SgvmVGFxusr+YACfuUe4e4rOM6kK7aJmhlrK8LvWgHdkGAZDnBmS8QRbv6Oig0tMIyHdRd0ALC7KhMLAQZT0G9Wmp8TcXJzSlrsEF3VnmnEh6X+qDTe8eGa6QKgW8LftbhH2EbYGY3S7PzSk4eeLdRS05bu2ktspJYhSpuTz9htRKJLWLSRrNPWVyGEBLWHQY4KuHkHOQcSrgcf6wXDQauywz5LO1ZAgl7vi75uDLHGZnm6emVaDEJD81eT/Cr628YqsXVmtX0xkPmVviNmTYUhTk9n/aWfS+/jPanJ2B/VtGPL5Li7uEtmK7AS6rlaMPrTiAYCUU42UM
 jpaemhFL
 Kx6RW8ijgp7WYlJmm1XFqZjNaFZDmCHuWWLjZHpjEoR2sKd+C8JKR7CJMqQD7Nxr7AtBzCtqNNigec3rY+iwm6bYcjRm1Hu+NC23psKtPn7nSjsT1MRI7S9lllBsNQ7zF80jrkfy+W5YOm8Jb33FmNh2So+WsscEKp7ueoMO/nV3+yFGTU504UyfyJ3tEGGuWG2cpfbWa5Li69w6lGQmWxBVr0xnyLO5XWEglDOIQ4WeQVqDXljVN4tEyzz/iCb+rzVdrb210jJmAAxEhKTQUW1+nyhb+gYuHLoUZwXgZtUDIr0WTM+XpfmdbvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/15/26 05:50, Yin Tirui wrote:
> Hi David,
> 
> On 4/15/26 02:15, David Hildenbrand (Arm) wrote:
>> On 4/14/26 17:14, Yin Tirui wrote:
>>>
>>> I did a quick tree-wide grep:
>>> $ git grep -l "remap_pfn_range" | xargs grep -l "\.fault\s*="
>>> arch/powerpc/platforms/book3s/vas-api.c
>>> drivers/infiniband/hw/hfi1/file_ops.c
>>> drivers/uio/uio.c
>>> drivers/vfio/pci/vfio_pci_core.c
>>> fs/proc/vmcore.c
>>> security/selinux/selinuxfs.c
>>>
>>> It turns out there are two users of this "hybrid" approach in the kernel:
>>> 1. fs/proc/vmcore.c: It pre-maps via remap_pfn_range() but registers
>>> mmap_vmcore_fault().
>>> 2. arch/powerpc/platforms/book3s/vas-api.c: It pre-maps via
>>> remap_pfn_range(), but registers vas_mmap_fault().
>>>
>>>
>>> How would you suggest we proceed here?
>>
>> How about we populate PMDs in remap_pfn_range() only if !fault?
> 
> Doing this would at most prevent VMAs with a ->fault() handler from
> getting huge mappings, which seems to have little negative impact.
> 
> But wait, dynamic huge mappings are actually created through ->huge_fault().

If my memory serves me right, also fault() can nowadays install PMD
mappings.

For example, shmem only implements ->fault through shmem_fault()

finish_fault() after __do_fault() takes care of that (mapping through a
PMD if possible).

> 
> I did a quick grep:
> $ git grep -l "remap_pfn_range" | xargs grep -l "\.huge_fault\s*="
> drivers/vfio/pci/vfio_pci_core.c
> 
> This is a false positive. There is no case in the kernel that mixes
> remap_pfn_range() and ->huge_fault() on the same VMA.
> 
> What if we use !huge_fault instead, disallowing remap_pfn_range() from
> populating PMDs if ->huge_fault() is provided?

I think we should just disallow any PMD mappings if we either have
->fault or ->huge_fault.

I would assume that ->huge_fault implies >fault, but let's rather be
save than sorry.

> 
> Then, when we encounter a huge PMD, we know for sure whether it was
> installed through remap_pfn_range() (needs a deposited pgtable) or
> ->huge_fault() (no deposit needed, can be refaulted).
> 
>>
>> Then, if we have !fault, we know that the PMD is from remap_pfn_range()
>> and has a disposed page table.
>>
>> Would that work?
>>
> 
> So for Lorenzo's `has_deposited_pgtable()` helper, we could simply use:
> 
> 	/* Huge PFN map without a huge_fault handler must deposit */
> 	if (vma_test(vma, VMA_PFNMAP_BIT))
> 		return !vma->vm_ops || !vma->vm_ops->huge_fault;

As mentioned above, also considering vma->vm_ops->fault;

> 
> 
> By the way, while auditing this, I noticed that
> drivers/gpu/drm/drm_gem_shmem_helper.c calls vmf_insert_pfn_pmd()
> directly from its normal ->fault() handler instead of implementing
> ->huge_fault().
> If we adopt the `!huge_fault` check above, this DRM driver would be
> wrongly classified as needing a deposit. It seems that DRM driver needs
> a minor refactoring to properly use ->huge_fault() to keep the MM
> semantics clean.
No, it's doing something that's allowed. If we call ->fault and there is
not PTE table, it may insert a PMD.

-- 
Cheers,

David

