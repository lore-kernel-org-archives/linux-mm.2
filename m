Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DB711073C8D
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 10:53:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08A086B008A; Wed,  8 Apr 2026 06:53:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 061DB6B008C; Wed,  8 Apr 2026 06:53:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB97A6B0092; Wed,  8 Apr 2026 06:53:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DBD416B008A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 06:53:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 74E178CB86
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 10:53:48 +0000 (UTC)
X-FDA: 84635078136.01.129F605
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8C43B40005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 10:53:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZiDr7348;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZiDr7348;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775645626; a=rsa-sha256;
	cv=none;
	b=lC7q5bzLkYL+ZfXfzLbHqO6wsostb9466IXqsrdL0dXLUFxf1Jmxq4SBRFdSPaeuz32dyW
	3pAG7mY06bNfuVCxnife2k6Quvz7oDV/wA9WTYbTlqv5gIweKMBqseVDge8LMXpgic0ieY
	JJWCGb8eBAJGy9T5JMvsYKpdXgEulHs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775645626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xn+zdRP0r8p3+OgVHWAaTpshqz9phPSSvl+GlnIV5pQ=;
	b=TpK5cCivIoHFDsqui2yxSAarU0Ad6Cpom8PNecwBfF06D/v0mGQslDGzr3/K2BvDQwoD0b
	dibzYb6DwhKTPTs0TRX4497VIMfZKzaiyIdGDGW9gkMGODA3rZuSKAfjF24pb5loUGHl2Y
	qYM+VTlGoHJzP209xt8PWBiAYO1abYw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 88AED40458;
	Wed,  8 Apr 2026 10:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71A6C19421;
	Wed,  8 Apr 2026 10:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775645625;
	bh=EqVBuNANOIfXlPBV4kr8Pk80hv6q0E3wJgHabswY2OM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZiDr73486p1YnmfGthuYD+1w4b1+ULLCb6M01UyQHxofoW0OBib8tNBZ51vWWy+ph
	 O5X+d/oy+hEJ7nSRQ++IhbYHNWmgDSC8JZWifADqUoZ4cEJO3+QN9OwwzIPdlXgIAC
	 YlWGfzmhHgUkCbJA/NbYdo45DZcP/bN/6nMEtRq/OLPyWmlizAsIdkACZ9rp2Nsdfp
	 fxn4vXFMhg7/nrfWHFvpzuWqyiGX4jJPINcUPoYMtNz3Lf5ZBRbxd7+c/S4SFfoysi
	 6TGmO6D1n+LKyPwgZJ/vOtQerHLBeOXAVt+KgmlSuQ45Cd7pJzJTtTjpPzsiK3Arg2
	 sLgLWVdTwU8eA==
Message-ID: <3f5d6955-e202-44dd-b490-863b7193a0c1@kernel.org>
Date: Wed, 8 Apr 2026 12:53:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: use batch page clearing in
 kernel_init_pages()
To: "Salunke, Hrushikesh" <hsalunke@amd.com>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, akpm@linux-foundation.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rkodsara@amd.com,
 bharata@amd.com, ankur.a.arora@oracle.com, shivankg@amd.com
References: <20260408092441.435133-1-hsalunke@amd.com>
 <22b6ff3c-9d41-4eb0-9beb-cb92f3ada89f@kernel.org>
 <4e8c218b-ac5e-4674-9e1e-acf750f0a5c8@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <4e8c218b-ac5e-4674-9e1e-acf750f0a5c8@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8C43B40005
X-Stat-Signature: ioyb9abfwrdrzgk6y7xyohqd9g8mqm61
X-Rspam-User: 
X-HE-Tag: 1775645626-315056
X-HE-Meta: U2FsdGVkX19BVxl3hl1doEhcjZgrkMa9H6dSMUk49CaCjcoYnwKl6a1v1CElqFpm0NU/wLdA3T2nFZ1AlV/0t2YC0jMdndMitKAdECLhYluOu3FnPYqE8uVrFcYMAcDyTEaIGDdnZ0sbgfaVNfm33f2C5i5CI7Q9OwCgZ/E6k60GcEuU8iGKgSPgESc7JuwmP1yZIA/4V0P+u9SI4GbUivgUs9xeO2UXBbG7zQiVuuOPYQHq3xvJlobtG5o+xNlSkBXxzV4eMPGFBJ22gK8BuNdNOEiDbf+yEjFODPCnRNEGzXq6y3iWHWMK454cvSqiB+5SYWTZu9MUspz+7jiN0ut5oYNgH6ZM6Kx64EqqUW/gNcLPHtQ3ajAvX/lzfofb/YO4u6lBJeIl45DAWsiqsipHHiyyVvxMJCCADJxHrqL2XpOz97u3KeCMsgcD7UPdRyY9KPbkVE5uStslmebd1mCuo6Zucy4u6pu8RWEUBgHUQZ6uLTRbg0ma9M7F51vSI1RhRBg8SWQuFS56ueP4Z/s6qdRD9d5dTVW+5L59fOwUW4tWIVWfYBLqvlLft5+14kJdq9I8D3USK4j3W2vpvFhDPer76lAXn68DOlLS2rZTeE4Fv1VftqTruNlNn26FWtkqPx8Z5X9D9SewgfLmV+XOpZSfKmgEGyCRVXYF5HM1X9Z35iTjyA+LS2AZ+xAl22rBspOF/tUHzgsggdjnakIbNi7uk3vP4s6CYv3ZQAXmoZglb6up56Sj3jZZyn9NbZkkKqXUZ0poIII9YLJeisymkwi2hikO4JPF6NXqBEKFB8/NtCplxZ+lDFEWlB6DNHZ/g1Va+5uZkapR6umSXvG+oNk6lKdrvvtEXxwBdw88pBq79dcjLABq73b1pdCuXxpvKJ2anQOj+tcX9gOo1Ntqo5JIujgNK7dSTt2dGjlx5qFQ0JKUBM/J3WnYluvRuvU8Sk+0gCjiqYpWWGo
 d4PRIp8g
 mcVml2bvj89irlsbZYi06syhAGZEH8F46mwswutxofsdmbTM9Yecl09gRFlk8VTC/TIdrSt/BOSNLSDOCmsvIDjKHmHK15SZKDZ0S226NU0+ioIqJmVmiTVADhu9NuOGHfsc9Y7Z8zKyrQcxbqi9rVp12Kkal8YYLtegWP5E2NH2nQC1DuE8gttrxlri34y41mY5qFnw2/otIjN3WU3fqjoFmA3qSNYvDQa6dr7PAS4L8FiQoB42jCNf4qZv4x1Xs02XUpholxnbS8EIPbw3GAiXcFO9V0DyirQxBYY1w6BXmkLuTShWdPC39Zp+7h5EHQAG16Q6nTRRwbkvTq/d6nxTAZDrmT2XqF0NtZmiObtkrEFrXI7JE7gi2FIq/8Xu1JdSa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/8/26 12:44, Salunke, Hrushikesh wrote:
> 
> On 08-04-2026 15:17, Vlastimil Babka (SUSE) wrote:
> 
>> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>>
>>
>> On 4/8/26 11:24, Hrushikesh Salunke wrote:
>>> When init_on_alloc is enabled, kernel_init_pages() clears every page
>>> one at a time, calling clear_page() per page.  This is unnecessarily
>>> slow for large contiguous allocations (mTHPs, HugeTLB) that dominate
>>> real workloads.
>>>
>>> On 64-bit (!HIGHMEM) systems, switch to clearing pages in batch via
>>> clear_pages(), bypassing the per-page kmap_local_page()/kunmap_local()
>>> overhead and allowing the arch clearing primitive to operate on the full
>>> contiguous range in a single invocation.  The batch size is the full
>>> allocation when the preempt model is preemptible (preemption points are
>>> implicit), or PROCESS_PAGES_NON_PREEMPT_BATCH otherwise, with
>>> cond_resched() between batches to limit scheduling latency under
>>> cooperative preemption.
>>>
>>> The HIGHMEM path is kept as-is since those pages require kmap.
>>>
>>> Allocating 8192 x 2MB HugeTLB pages (16GB) with init_on_alloc=1:
>>>
>>>   Before: 0.445s
>>>   After:  0.166s  (-62.7%, 2.68x faster)
>>>
>>> Kernel time (sys) reduction per workload with init_on_alloc=1:
>>>
>>>   Workload            Before       After       Change
>>>   Graph500 64C128T    30m 41.8s    15m 14.8s   -50.3%
>>>   Graph500 16C32T     15m 56.7s     9m 43.7s   -39.0%
>>>   Pagerank 32T         1m 58.5s     1m 12.8s   -38.5%
>>>   Pagerank 128T        2m 36.3s     1m 40.4s   -35.7%
>>>
>>> Signed-off-by: Hrushikesh Salunke <hsalunke@amd.com>
>>> ---
>>> base commit: 1a2fbbe3653f0ebb24af9b306a8a968287344a35
>> Any way to reuse the code added by [1], e.g. clear_user_highpages()?
>>
>> [1]
>> https://lore.kernel.org/linux-mm/20250917152418.4077386-1-ankur.a.arora@oracle.com/
> 
> Thanks for the review. Sure, I will check if code reuse is possible.
> Meanwhile I found another issue with the current patch.
> 
> kernel_init_pages() runs inside the allocator (post_alloc_hook and
> __free_pages_prepare), so it inherits whatever context the caller is in.
> Testing with CONFIG_DEBUG_ATOMIC_SLEEP=y and CONFIG_PROVE_LOCKING=y, I
> hit this during exit_group() -> exit_mmap() -> __zap_vma_range, where a
> page allocation happens while the PTE lock and RCU read lock are held,
> making the cond_resched() in the clearing loop illegal:
> 
> [ 1997.353228] BUG: sleeping function called from invalid context at mm/page_alloc.c:1235
> [ 1997.353433] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 19725, name: bash
> [ 1997.353572] preempt_count: 1, expected: 0
> [ 1997.353706] RCU nest depth: 1, expected: 0
> [ 1997.353837] 3 locks held by bash/19725:
> [ 1997.353839]  #0: ff38cd415971e540 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap+0x6e/0x430
> [ 1997.353850]  #1: ffffffffb03d6f60 (rcu_read_lock){....}-{1:3}, at: __pte_offset_map+0x2c/0x220
> [ 1997.353855]  #2: ff38cd410deb4618 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}, at: pte_offset_map_lock+0x92/0x170
> [ 1997.353868] Call Trace:
> [ 1997.353870]  <TASK>
> [ 1997.353873]  dump_stack_lvl+0x91/0xb0
> [ 1997.353877]  __might_resched+0x15f/0x290
> [ 1997.353882]  kernel_init_pages+0x4b/0xa0
> [ 1997.353886]  get_page_from_freelist+0x406/0x1e60
> [ 1997.353895]  __alloc_frozen_pages_noprof+0x1d8/0x1730
> [ 1997.353912]  alloc_pages_mpol+0xa4/0x190
> [ 1997.353917]  alloc_pages_noprof+0x59/0xd0
> [ 1997.353919]  get_free_pages_noprof+0x11/0x40
> [ 1997.353921]  __tlb_remove_folio_pages_size.isra.0+0x7f/0xe0
> [ 1997.353923]  __zap_vma_range+0x1bbd/0x1f40
> [ 1997.353931]  unmap_vmas+0xd9/0x1d0
> [ 1997.353934]  exit_mmap+0x10a/0x430
> [ 1997.353943]  __mmput+0x3d/0x130
> [ 1997.353947]  do_exit+0x2a7/0xae0
> [ 1997.353951]  do_group_exit+0x36/0xa0
> [ 1997.353953]  __x64_sys_exit_group+0x18/0x20
> [ 1997.353959]  do_syscall_64+0xe1/0x710
> [ 1997.353990]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [ 1997.354003]  </TASK>
> 
> This also means clear_contig_highpages() can't be directly reused here
> since it has an unconditional might_sleep() + cond_resched(). I'll look
> into this. Any suggestions on the right way to handle cond_resched()
> in a context that may or may not be atomic?

clear_contig_highpages() is prepared to handle arbitrary sizes,
including 1 GiB chunks or even larger.

The question is whether you even have to use
PROCESS_PAGES_NON_PREEMPT_BATCH given that we cannot trigger a manual
resched either way (and the assumption is that memory we are clearing is
not that big. Well, on arm64 it can still be 512 MiB).

So I wonder what happens when you just use clear_pages().

Likely you should provide a clear_highpages_kasan_tagged() and a
clear_highpages() ?

So you would be calling clear_highpages_kasan_tagged() here that would
just default to calling clear_highpages() unless kasan applies etc.

-- 
Cheers,

David

