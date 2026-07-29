Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 339CCC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 13:53:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3329A6B0093; Wed, 29 Jul 2026 09:52:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 310946B0095; Wed, 29 Jul 2026 09:52:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2212E6B0096; Wed, 29 Jul 2026 09:52:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E6A286B0093
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:52:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7EFE6406C4
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:36:33 +0000 (UTC)
X-FDA: 85041762666.21.DA637C4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id D0369C000C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:36:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RkQgQ1gi;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785328591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gHamDsFTAhL0OIEw2bN/hCgDVSj/oK4JbR47GpwZVmA=;
	b=51rLmAIYxnNB2XX/EL6cCKk1gnwoSDYh8wphgQJgOXXr7ENmSO1Lk4YAmdT4zVPMpFylZQ
	BR9N44ajMbdo/xjW9gkDH31zW8j8VGyHU6rCe6SPPaYVUBFn0W4iAafWbHyWxLlNU4ZJFz
	7d3tWCGyj2sXz8qZtlMOZ78h1fBxNoo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785328591;
	b=as+0UFd03P6Gsq+TxFzW35VHhZw3YbayXWNsKA0Ms6aPp4Vv1bJb+96ysUBFzDPrrSA5b3
	A9XHb2rS38GWg/EKcoH3C0jZ9mLwp6oANazPw/5jDFkM2O/aplCFWJntAfX1RQsKHdh75N
	AMn1LTXT0oWTYucrXNkXdQqNKIr7bVw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RkQgQ1gi;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 64C3860A66;
	Wed, 29 Jul 2026 12:36:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E5C1F000E9;
	Wed, 29 Jul 2026 12:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785328591;
	bh=gHamDsFTAhL0OIEw2bN/hCgDVSj/oK4JbR47GpwZVmA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RkQgQ1giBgyrV+H0vHQxup/Zdx8wGbeHptMqJL3FLtfkKZLx6nUpvlcinkEJdvJny
	 Xh2UXIwhDPt5dSpjPnaVNTyk9qmLb+HFMnoYWrNBqcWZXFXdFBI/CChCRwzTV+zvQn
	 5M9DVqkCkdDD5I8op4BbZjoZ06+0a2rsbynOITiPyT8hzfZK5iK+JKWZtJF97x10dV
	 Bvzj1VfpZfgiEF+AFa9BhhLELz74om9jwUm0UaP7YFYOwEEiGvcucVIU8RBJQ2Y6zj
	 +mD+VILrbd6DnY1SbeYjqTFcfyjVOZk6kfHEQ6wLJH5olBEdMILIPIo+SOvps7fD4D
	 WHeMUB9cmcP2w==
Message-ID: <7d841b27-f60a-496f-81db-84158a0a8f8f@kernel.org>
Date: Wed, 29 Jul 2026 14:36:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] mm/memory: add anonymous mTHP folios to deferred
 split list
To: Usama Arif <usama.arif@linux.dev>, Joanne Koong <joannelkoong@gmail.com>,
 akpm@linux-foundation.org, ljs@kernel.org
Cc: alex@ghiti.fr, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 willy@infradead.org, linux-mm@kvack.org
References: <20260707201735.4113107-1-joannelkoong@gmail.com>
 <20260707201735.4113107-3-joannelkoong@gmail.com>
 <584098de-dd48-4004-8e7e-3d826e60c860@kernel.org>
 <77b3b74d-c1bb-461b-8076-8729cdcf91f5@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <77b3b74d-c1bb-461b-8076-8729cdcf91f5@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D0369C000C
X-Stat-Signature: 87j5m3kyjj5gz4f7xsfw5bnsapts8uma
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785328591-776691
X-HE-Meta: U2FsdGVkX18oSUbunzFPDkMr7of2NV5b4IKqJ+bH7A5iRLagQ+hdqtixjDo1MgixVywPOt49u1gATksAEC7bdZ1bN49/iudXb8ai6ulpl3TQaNzmoQdocpTu7CxJoqYX4uLyeeXYXr1rp43FBEJm85yBntYZwQeK9UWv1QsyEklEK8JhZ/annZsvxeAalWSHaSlfnYmoQTG8JlU8uMH40p3rneqM4DjzZRxQpAabd9heZrr7YqeDR4DzZUhDw1dsRQe4HnzbZuuJKmPNp6RoYCzEaMmYPK+MKPPgEwvawGSn0Wb6Q7JFIxkkDXEYxYADj2XBQ32qqT2B88ec+d6rM+hKulL/+lyjD7J1p0tQd2gzqDwbT058MP5zewLooXMVJ2LTV9XAcXWwTPyor8m+CRT3J4Cy6HyEZTKnwaNNXKf1bJ+OK4D3rPkdLUSGwazzplnH7PLNkKHkmvUr3uKSCIdDIUmeiQ1QK0H76CDKdbv2Y7mmqokVGM1VHowPgXRfPF8NAWWCCsZiDOFwglmjjMf3hs7nT832XuX3dovq7FPnr+16EqEx7HFvMx9b5/wYED0NMAw1pkHZQkeTPf5d4gwy+lmP1Ysre6AY2dGSiRlCf6DSLg8cl8wrQvhPywbX9ce66lTljiXVX+uOODXICzeXljo5MNRCc7aNmsR+q29gSAHFcyyl4D7DGorvJntntSJ5OmUV1lE8kOBmQqb4A3wnmeyvM+GK1MupmEt8BzCLRw6VzpyARRQTi/nu9FOyUdLQkUrkl/MHTGu4bcPTeuQkoInaz0RoBp5PFpIyXE4dLe/hEic/7OvMDvo5+wQsAynB92YLGqIqTFnketZ3DWhGP7obiAYqi1tyqxpY2jDfM5InuDldu0ZE94sOL8y0AhA5S3+nn/Trx3PvYWldniNwwSRoNxc8CvRcbwmZDbmc+fy4DYNmlwKqcqjuau/gvGGuQekBqiB9UV05F34
 iUgztmZ8
 eXncvgi2aIfAUxXn9bEOTL8j58aez33kk27OUzKrivhBiXVFjA4rhHxaqykXl5H40RnFnxYkREge90Tzd92da51ie/DKOCmV5xZHTHQ8pY2oVLft/qGrVHjzXBYmRkfAvFXTGF9G5bq0UceeqaC2bbqbOo414cjMP/rm7KeLio6AX0Ljv2JdItPwDb2onqm2ZnPLS8hiQVnZmvQP11tZYqdHynnGctEl9f3Ofn5v0imPuWeXYbfdEenvSN7fFjNhLRlO3hI5GirUhHk+jdrrLw0UZ66ImDtFhvYJ3DIfK+mxHoxyDFNfEoKnkdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/8/26 11:58, Usama Arif wrote:
> 
> 
> On 08/07/2026 08:56, David Hildenbrand (Arm) wrote:
>> On 7/7/26 22:17, Joanne Koong wrote:
>>> Unlike for PMD-sized folios, an anonymous mTHP folio doesn't get added
>>> to the deferred split list at fault or collapse time. As a result, a
>>> fully mapped mTHP folio that is mostly zero-filled doesn't get split by
>>> the deferred split shrinker when the system is under memory pressure.
>>>
>>> Add anonymous mTHP folios to the deferred split list so that if there's
>>> memory pressure, a zero-filled mTHP can be split with its zero pages
>>> remapped to the shared zero page and then reclaimed.
>>>
>>> To minimize overhead on the common order-0 fault path, the
>>> deferred_split_folio() call is guarded by an inline folio_test_large()
>>> check.
>>>
>>> Suggested-by: Usama Arif <usama.arif@linux.dev>
>>> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
>>> ---
>>>  mm/memory.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index 6637c5b13c9b..441d918e3dc0 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -5259,6 +5259,8 @@ void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
>>>  	folio_add_lru_vma(folio, vma);
>>>  	set_ptes(vma->vm_mm, addr, pte, entry, nr_pages);
>>>  	update_mmu_cache_range(NULL, vma, addr, pte, nr_pages);
>>> +	if (folio_test_large(folio))
>>> +		deferred_split_folio(folio, false);
>>>  }
>>>  
>>>  static void map_anon_folio_pte_pf(struct folio *folio, pte_t *pte,
>>
>> I had a session [1] at LSF/MM about having essentially all large anon folios
>> part of the the deferred split queue.
>>
>> (1) I don't think this scales.
>>
> 
> What if we only add the mTHPs for which the policy is set to always.

That doesn't really help lock contention. And the lock contention is indeed a
thing, as we now also want to enable the LRU cache for smaller large folios,
which improves performance:

https://lore.kernel.org/r/20260709081536.82768-1-baohua@kernel.org

> 
> I think it doesn't scale if someone sets all orders to always, but if you only
> set the 2M mTHP sysfs to always, it should be the same as what we have today
> for PMD order?

I don't see a problem with large large folios, only with small large folios :)

> 
> The main motivation for this series is to try and bring the performance for
> ARM on par with x86. One of the differences is TLB misses. I imagine the lower
> churn in kernel by using larger page sizes will help as well. But we will
> run into OOMs without the shrinker.

Can you elaborate how this change helps here? I assume you want to enable mTHP
in production. Which sizes? large large ones? :)


-- 
Cheers,

David

