Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F61AC55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 07:36:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35F656B009D; Wed,  5 Aug 2026 03:36:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3104A6B00A0; Wed,  5 Aug 2026 03:36:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DB9E6B00A1; Wed,  5 Aug 2026 03:36:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E1EAE6B009D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 03:36:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5F95A40408
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:36:13 +0000 (UTC)
X-FDA: 85066407426.02.486A114
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id A554F100007
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:36:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="M/SYiQjD";
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785915371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=78alTOF1FqEo4Ow5pLyKuZcZuxJN46NIcS9bo25EeB0=;
	b=ZhNMVYyQJKAtBYWCRVQQuOScnvXP+Y3ADm34wcMuSgbvgg1wy6NfkbdluCsckNx784KOsN
	v02eAFtBjprXvmeePeTitFD/sKcXoOBZP19dfoj3JfyQMuG1li2iSGpG0CgoJ6DVv19+Da
	iMxA3D7OZmcCPvz+RV/rFb/12feo980=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="M/SYiQjD";
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785915371;
	b=iIsgD3iQgZcdBSESb1UWjvgXCZFfWo/n9hIsZkPPR3OZs2Feqa3o9v4GYEKN1Uk3UyZFVq
	D2JmOjyssO6vRpJ/XyJWrqVC7f1AKLf2B+9QPIEEB6jM8+2sw0N3EG+euXaRCSNkR09R7k
	Yc5dNehrgoVI8agDkVTnen1uE8r3nas=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D2DC60A75;
	Wed,  5 Aug 2026 07:36:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056B71F000E9;
	Wed,  5 Aug 2026 07:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785915370;
	bh=78alTOF1FqEo4Ow5pLyKuZcZuxJN46NIcS9bo25EeB0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=M/SYiQjDmuZSjqnYxXZ95MsY7qnrZNP/2qcBuPFpwww/h3s7augHkh4Qb7sJDNIpI
	 zCJpS8TfaqPSJX9Xkbimbbu/AtEZ+sru5+OWBQ/Dedf7v1HjexBRfOeEGjYJanu+e9
	 0FsoKGiSNpztorzZoQ7tT92Rw9IG2bagJ/XkKGt25a5weYaV5WtIolvU0wS0Pf5Wba
	 41KhCSPLcZ5zeMwwlhwHjZgjPl3lz4ZeEsJq6JwFWgNMdZCgehBh8yfliDC3flvjjZ
	 MmnglQoFHz9Nxe56kAKFbywu//t4JOMZ6MCpDyjIDG9R+oiPQqKLA6VC1fCRrf26D9
	 1xVofBvwKBvPA==
Message-ID: <6ea7cdad-afb1-45af-a63c-30b760fe160d@kernel.org>
Date: Wed, 5 Aug 2026 09:35:56 +0200
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <anB9MWSSITYpDibA@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A554F100007
X-Stat-Signature: kknkj5s3ggzm5y7fkpg88jg7h47ekym1
X-HE-Tag: 1785915371-718075
X-HE-Meta: U2FsdGVkX19FpLg6EQzNYTWzvHo/k3/0NWtAZWQcp7shNjQ8xk6FMPlAwOy9y+0uFlonsTsqrUVhERGjqjXCrW2aLLdoaqDxDu4gIZnnw6cAP5Hi15AaDf2uDsyzksBEdQpoaICTCBRTB4oxbIYQfqpbGSvEto08DnvDq68O9S2fSGYxPZ01e9yMWU4Z7MNUuiDSOVlrSW/AnmT2hvVGl0xgCMV9NKWJLU6bBd4atmpYphjzJTL9nZQvUuSp5Sr++fSUHLAqa1RhzXesw4kAxrCFF2fvN0aySqNboTt9jAHSoVZSRXQxp8wXGOX8bjGEqMtFLsT7P4ldgE057k1yy0dPytLG7NxEGjyfOGSaShXtasXhyXMQ2eSVkbP0LKuZzMIgYvw0dFqHOc3QzKcjH3ms945dJa2hvYct6nDIELioorAbvocIaSd91XeHPsqBmY5ZtUQYchKLr1ZN9wbax7oY6kr/qKL4/GYQMSvGA7Vu5bS0WtbIhu+YsqBahCbDSYHNZ3m0Y44gHGSf0M1vxWzamqiCONEP88x8Ld8xrxWtTgdc7ZT1f3J6Ey3Q+yVCrWeRcyVFCfJdwOTbiHQvo0ZnDKZRw7PMu8vlG2PZL8jewQNpPZtFmgleqkuL3m+t3o6Z/ZIwT+jeZbCi1O+t6ch+ffMLY7onT77tu9lFTPCrPnhqwMe/9xozbZU4FS76eiYnsKrct+kGQQzcSiK7eLyyWDKadS6Xyer3VAbjmO9zWwIc5kn2IogIqSmvRoAHXbwDBbAzLTnuJPdUiJaducSuTY9qp2LwN0r846KiQ4Hz8LVjiCqfHXlgVUXqD3xBa5JOksZbZXWPizWsP31Us5O8/z4+WKn+/RUji5hCbrJ1KoS6YbMiDqKc50D7hQlHXTaMH0yh6CulYsHeBGM3vQK9PrWolqzNsUucvHGVOYg8scIbkAT4VwikPZYMFR/OHbG4jvGpWcDIvlJcNc9
 pWjf8jt0
 fE7bYDECKdd38H8uWipju3nhRlWzGRS/kR8Fx7SGqIPMNc1K4DEOEKhlNEtn0CSCXGVN8u9cen6Y8C1he6keoPxbWzW2IP+Yxv4adRe4CvaSs9y68rD/tfoNvagaMXbrLkWUjYPmBhCHuPy942+OLFQhyL1Egrc2tZR5hBab1L8Vj1YvvoAZzZQJfXS97T/KNS26QSUU/q1HskCg5MxTgYFv8rFD0+RniaXS4to8GyRFPLW5rVonOEnWBsA3a9Ihbltfnjs9UdrAkaaAeahooOFBj0cujxqlN+G+NJA/GYXox5VlvIbi4VO077J2ms8C6/PczERXI0kPqHxYoWAU2IiPz5kHOKm2sD7DqkJy8OZLfuOQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/3/26 15:46, Lorenzo Stoakes (ARM) wrote:
> On Mon, Aug 03, 2026 at 12:52:42PM +0200, David Hildenbrand (Arm) wrote:
>> On 7/29/26 18:48, Lorenzo Stoakes (ARM) wrote:
>>> We must correctly update VMA anonymous page offset state on all VMA
>>> operations that would result in it changing, with special attention given
>>> to remapping.
>>>
>>> We cover most cases by simply updating vma_set_range() to do so (with a new
>>> anonymous page offset parameter), but also notably must update the merging
>>> and mapping logic to propagate this parameter correctly.
>>>
>>> The remap logic remains the same - we may update the anonymous page offset
>>> if the VMA is unfaulted, but now this applies to MAP_PRIVATE file-backed
>>> mappings too, so we update the code to reflect this.
>>>
>>> Note that we use __linear_anon_page_index() upon remap as the VMA may be
>>> shared, in order that we update the field consistently regardless of VMA
>>> type.
>>>
>>> Similarly, pass through anon page offset to the merge logic, updating the
>>> vma_merge_struct struct to propagate it, and also use
>>> __linear_anon_page_index() to obtain the anonymous page index so it can be
>>> safely used for both shared and MAP_PRIVATE file-backed mappings.
>>>
>>> Finally, we update insert_vm_struct() to correctly set the anonymous page
>>> offset on insertion of a VMA.
>>>
>>> We simply ensure state is correctly propagated here, so no functional
>>> changes are intended.
>>>
>>> Also while we're here, replace a VM_BUG_ON_VMA() with a
>>> VM_WARN_ON_ONCE_VMA().
>>>
>>> Also update VMA userland tests to reflect this change.
>>>
>>> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>>
>>
>> [...]
>>
>>>  	struct vm_area_struct *vma = *vmap;
>>>  	unsigned long vma_start = vma->vm_start;
>>> @@ -1919,11 +1929,14 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
>>>  	VMG_VMA_STATE(vmg, &vmi, NULL, vma, addr, addr + len);
>>>
>>>  	/*
>>> -	 * If anonymous vma has not yet been faulted, update new pgoff
>>> -	 * to match new location, to increase its chance of merging.
>>> +	 * If a vma has not yet been faulted, update its anonymous pgoff to
>>> +	 * match the new location to increase its chance of merging.
>>>  	 */
>>> -	if (unlikely(vma_is_anonymous(vma) && !vma->anon_vma)) {
>>> -		pgoff = addr >> PAGE_SHIFT;
>>> +	if (!vma->anon_vma && !vma_test(vma, VMA_SHARED_BIT)) {
>>
>> Could we also use is_cow_mapping() ?
> 
> No this would be incorrect.
> 
> A read-only mapping would become unmergeable here. So this is something apart
> from the rmap aspect,

I'd assume that we should never even consider anon_pgoff when merging
!is_cow_mapping(), it doesn't make any sense.

No anon folios -> no anon_vma -> no anon_pgoff

But I think I am missing one detail here:

> and it is a contract that upon move of an unfaulted
> mapping (which for read-only anon would always be unfaulted) that vma->vm_pgoff
> is updated.

"read-only anon": I assume you mean an anon mapping that does not have
VM_MAYWRITE set?

I recall that that's a combination that cannot be created. While you can create
something that does not have VM_WRITE set, IIRC VM_MAYWRITE is always set for
anon vmas.

-- 
Cheers,

David

