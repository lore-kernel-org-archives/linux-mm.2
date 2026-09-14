Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7F9FC88E75
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:07:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE6696B00C2; Mon, 14 Sep 2026 11:07:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBE3A6B00C3; Mon, 14 Sep 2026 11:07:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD40C6B00C4; Mon, 14 Sep 2026 11:07:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 851D06B00C2
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:07:53 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 21A061A0189
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:07:53 +0000 (UTC)
X-FDA: 85212697626.15.17DFC61
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 608C31A0006
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:07:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e55MX1V5;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P7Xr18mqT/xG2BwmTSi78wPbmNxPfvS2hbh6FAOvcOE=;
	b=HrHfrytzD48PsEEGQlxdgqXAVfcKILrKP7sk6oAAyxuoWIMywqulOxDP4hNBG/TrNAQATa
	pl6iKovUR/pmZim804OtdZxLnXD1edlxs++GfQUnZR4nJavAsiunr13CS+Z2jBSG35TljA
	OywqBe/IUw+jn59oO+2XhFrh0w0+Itc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e55MX1V5;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398471;
	b=M1w094F9NnmUKGZyiyEaQ8wDSlYDLogli14cerQSJOnEALRxHpDVmhOJ09s4aNnlqMeR6t
	Gvo4urE5BGq/xxqN+QFEfeVA89wfyQREChN3t1+/V8Wws7G9GzYyTZr5wNRrBQZ45oedrp
	mTvNg3fHVbZme0P7gA2OEvs2B47hsTw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EA9DF60142;
	Mon, 14 Sep 2026 15:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7AD1F00893;
	Mon, 14 Sep 2026 15:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398470;
	bh=P7Xr18mqT/xG2BwmTSi78wPbmNxPfvS2hbh6FAOvcOE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=e55MX1V5sDG1Dt4Gvep2OTBDW4dXlx/Q3wg94zi9YVEre4V3820I4vkgsvsU2UwO5
	 VkGgVqzF7DDtgN6/pzAbjOQyqK14HOVvm4jz7JFwEDvhz0iCl0jZHEtZL6+dE4VH4i
	 QLe3emjYlYikI4NLRZbVQnE1fYbJ6dtCJJpwLopNvnCYtvS5XgciKdWjEZ3aYKzJ0p
	 OjOxElV4VyLZrRqsQarO4WppOjLcbFFD/48Wtg/inaNY1pxbXjWhDNf/gY/UcK14lO
	 oypJb5kh6DVYFq2dPZ7hyGOu7nraSVqSvGbbNd0L16xDymOnTv6cn2UFRT6y53zP/Z
	 +DRKZbZVWfeyQ==
Message-ID: <fd179a26-fd69-4b5f-9af1-b3755ba9030a@kernel.org>
Date: Mon, 14 Sep 2026 17:07:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/57] mm/collapse: rebuild collapse on migration
 primitives
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, ljs@kernel.org, nico.pache@linux.dev,
 baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com,
 hughd@google.com, lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com,
 rppt@kernel.org, ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com,
 usama.arif@linux.dev, vbabka@kernel.org, ziy@nvidia.com,
 usama.anjum@arm.com, agordeev@linux.ibm.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 jannh@google.com, willy@infradead.org, pfalcato@suse.de,
 rostedt@goodmis.org, mhiramat@kernel.org,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20260816224609.308019-1-kirill@shutemov.name>
 <9f51ac27-24b2-495b-b397-84865f977d24@kernel.org>
 <aoXRi3ngBhO54Akk@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aoXRi3ngBhO54Akk@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 608C31A0006
X-Stat-Signature: dyxdet3aihnzzekna6mhcsqp13isqsqs
X-Rspam-User: 
X-HE-Tag: 1789398471-71906
X-HE-Meta: U2FsdGVkX1/svQG0251aXXWAKy60Mi00En/qmarvOaRx3+Sc9Ta6YXNzI/NVTerQq8Wt7/CWg8zm82OtvXl3MVCsPGhqSd+CIc77Et/4etx2TF99XbyvCyRlwaE7BAmDZjkwXqvdp4TUTaltVVmr8Qi5sGWi1QqOpj1/2BIX+WJgK27yZG1VcZml5M+lUU4u6bQcR3qDtQ2pVdC/ahGnv1CI6n3luMEaia6UJOvczMVELBUyrn5iGW7gthei5F5OnBQo/6RS81y1HuMGT2DZEdbnohHIbNj5WZjkAD73jymyfRVp2qNyBtGvYl4alJzuF5CkFZ+xZlDboUpC6eC7Nrc9pyZh4cu9Hi1hY1qbqPN+XTGvsmUXH7l37h5cCqUZgtcXRUkVOKBHJskisgOADMr+Ls15Ttj2CFX9jLACAhAFW9eUdOVkfFQTknhitybfJWulfiLfCMy3Nd3EDfaUCgWH9gUPmswY64h1uRrsTmKdE7aYSliK0rOUEUfwHbDOndlvYxytfqEQPvX8thh/4OsaiZZ/n4vaErjFfEOcrukiGr/ERl8Vl2pO62hQy84WaWUrKF4qfnEKEx94XSSpOk85b+sK2jSTN6qCF1/HKthF069td+Dr+AiXhbqwBXDZDPeJRYjxIv+KLTUs/iY6Ah1/wiY8ny4e6OLbjSW7nflHjuMc8aL2Qcbr54pI5O2ei8Li0ZmCRSffm4N/g/dIqa2YysIz/YkRtowFL1KKik0UaRA290jOhAhNeQeQ54ClTntq9HxNFIWcKa/0qJrYS+8Kn36ahf/xOj83nRK6SoxkmzepPOPhf1aSHNLbaOY1nnIo/leQABzEYoHkxgf60Vtyc9E+xqmT3DbAEq/OE7YuBAQgJaKTAaJoOA9YVa3ipzLSyOZ74lRVCKNJnhvv9m1JgYcDbMJibmpaeL0FupAOGRJaOhb45WAZsk/QgIKn3iqMtKTr6VIOa/hrkc5
 cWGTVXjl
 R5swsGGfbQN6ITO7gvEq8nXAfTY/rfy1sT4LrOwM3JPlcgAcEpAvuOEtawuWtbmgNOVinY7YeQAAgBSkOf2gviXMiGgtrXWdMZ1t2KnFQX63BAwOkQNqV255G18xG1s2AQyNcfEgVVlloxERsSufufldPNmbN4jqJEa3F2WhY/zZcRWNRmWKclDV84Rj9pM/EqLJP9OesHEl4iBxBgt8lRHWqUsYPQfE4oW7fnfC17/YIXW2ws1PbraSfjrr0GFzEJJIv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/19/26 19:09, Kiryl Shutsemau wrote:
> On Tue, Aug 18, 2026 at 03:55:55PM +0200, David Hildenbrand (Arm) wrote:
>>> This replaces khugepaged's anonymous collapse with an engine that
>>> can collapse sub-PMD ranges. It is built around migration entries and
>>> frozen folios instead of heavy locking and isolation, aiming for better
>>> scalability and less disruption to the workload being collapsed.
>>
>> I recall us discussing something around using some PTE/PMD markers (e.g.,
>> migration entries) in the past.
>>
>> One thing that needed care is handling concurrent MADV_DONTNEED + faultin after
>> dropping relevant locks.
> 
> Handled at install time.
> 
> I drop the PTL after the freeze to allow allocation and copy, but sample
> the PTE values (see saved_ptes) at freeze time. If something changed
> under us by the time we install the new page table entries, we give up
> on that candidate and roll it back; the rest of the round still
> installs. We allow harmless transitions: zero page to none.

I think there was more to it, and Jann also hinted at some examples in his
reply. But we'll get to that part once it's no longer buried in 39 patches ;)

> 
>>> Which is why hugepage_vma_revalidate() demands that the VMA span the
>>> whole PMD even for an mTHP order -- "we'd need to lock all VMAs in the
>>> PMD range to support this", as the comment there puts it.  A PMD-granular
>>> operation is only safe when one VMA owns the PMD, and that is exactly the
>>> restriction in the way.  The alignment is the symptom; the PMD is the
>>> design.
>>
>> I disagree with "A PMD-granular operation is only safe when one VMA owns the
>> PMD". It's safe when all page table walkers can be stopped (see above).
> 
> Fair, the sentence is too strong.  mmap_write_lock plus a VMA write lock on
> every VMA the PMD covers, plus their rmap locks, would make it safe.

Ack.

> 
> But the mechanism still clears the whole PMD, flushes, IPIs and
> repopulates it to collapse each 16-page window. That's very noisy to the
> workload.
> 

Right. khugepaged itself is pretty noise already, though. So one would have to
understand "how much more noisy and who cares".

I can understand why one would want to make khugepaged less noisy, though.

> And I am not sure how to deal with rmap locking here.  Nothing in mm
> holds two unrelated anon_vma rwsems: vma_prepare() takes one for both VMAs
> it touches, because a merge requires them to share the anon_vma, and
> anon_vma_clone() takes one because "all anon_vma's share the same root".
> The lock ordering in mm/rmap.c has a single anon_vma->rwsem level, so a PMD
> spanning unrelated mappings would need an ordering rule that does not exist
> today.

That's a good point. Try-locking would likely work but might have other effects.
Nobody tried this so far.

Lorenzo is on his way to simplify a lot on that anon_vma front (scalable cow),
and IIRC it would also simplify that case.

> 
>>> Between the two, nothing can reach a source, so the copy runs with no
>>> lock held at all -- and the address space is left alone while it does.
>>
>> Right. Concurrent MADV_DONTNEED can zap migration PTEs and other faults even
>> re-fault fresh anon folios. So that must be detected before replacing migration
>> entries again I guess.
> 
> Yes, that is the install-time check above.
> 
> The copy itself is safe: a zap of a migration entry only clears the slot
> and adjusts rss -- see zap_nonpresent_ptes(), which neither puts the
> folio nor drops its rmap -- so a frozen, locked source cannot go away
> under the copy.

I'll have to think about the impact of having these folios frozen for a longer
time, instead of only very briefly during migration.

E.g., these folios will then be unmovable for the entirety of the collapse
operation, because folio_try_get() by memory offlining/cma/compaction will just
fail.

[...]

> 
> There are no PMD-level migration entries here.

That's good.

> 
> The freeze is always at PTE level, so the pmd keeps pointing at the
> table until the last step, and the PMD leaf goes in as the terminal
> layer: verify, pmdp_collapse_flush(), deposit a fresh table, set the
> leaf, all in one section under the pmd lock with the pte ptl nested
> inside.
> 
> A pmd-level walker sees the old table or the leaf and never pmd_none,
> and faults stay held at pte level by the migration entries throughout,
> which is what lets PMD collapse run under a VMA read lock like
> everything else.
> 
>>
>>> Working in windows rather than whole PMDs takes care of the other root.
>>> A sub-PMD window is collapsed under the page table lock, so a collapse
>>> disturbs only the window it collapses, and each candidate is validated
>>
>> I recall us discussing that holding the PT lock for a longer collapse operation
>> (especially on 64k) is problematic. But I don't get all the details from your
>> description here.
> 
> As I mentioned above, we drop the ptl after the freeze. And take it a
> second time for the install.  Allocation and the copy run in between with
> no lock held -- on 64K the copy at PMD order is 512M of it, which is why
> it cannot sit under either lock.

Hold on, are freezing all folios to collapse? That cannot possibly work with
COW-shared folios that are mapped into other address spaces.

We must only freeze a folio if we are sure that no frozen reference can go away
concurrently.

But maybe I misunderstood or you handle this in a special way elsewhere.

-- 
Cheers,

David

