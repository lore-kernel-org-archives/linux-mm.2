Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C005C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 11:30:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E9A76B008A; Tue, 14 Jul 2026 07:30:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C1A56B008C; Tue, 14 Jul 2026 07:30:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECBA36B0092; Tue, 14 Jul 2026 07:30:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B4E646B008A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 07:30:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 322DFA014F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:30:01 +0000 (UTC)
X-FDA: 84987163002.05.B13629E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6009D40004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:29:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LhuMFxlJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784028599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g8Qgu4jCoGJy5UnTxB59TGXgv4KGiLDVpDg5Pc0P6aQ=;
	b=2iMP83THglGHyGJqUtBAiisG/A8FgA7NoYIIB3wGMf+2PGhEzw+X+HmqcozZ9wTYt9R8V1
	1hr3uWUWfpL5rZJEjKL8N2s1BqhvQkOWOCqyIlZDVihl6s8aW2RsCvJR9hLK/wn/2bJbb2
	DLs0n/Q9EbMxcuLlmM+pEBv1ga16m5U=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LhuMFxlJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784028599;
	b=JwgsZVpKstFPffQwVVLRkxXG3yLnyBSQ8cXAtQqtSpOOtzf5AIbK9KHmstRFg1U3/WJm+c
	HC31ttFQGKMuJa/Z9I+5jnpytYLPvlXGPVIKI8rar3IzbbJSvNn1loEBs1RFoD5E+j4zLg
	/zBbu8D0bTlc814Ctobod+LzU9+WPsU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 428784388C;
	Tue, 14 Jul 2026 11:29:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288261F000E9;
	Tue, 14 Jul 2026 11:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784028598;
	bh=g8Qgu4jCoGJy5UnTxB59TGXgv4KGiLDVpDg5Pc0P6aQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LhuMFxlJ+Sn+bK/n3A8CaZEya5rDRDXuzqmH4Rmb+ZzMFIU0N+638mkvPOxKux8T2
	 nenZffcs1R8sZ9OxOmcwysa+CI2hxBCdom0kuSUHZ7lqPAJE7RF408XYroYVuAg8PO
	 5D8mda/rzAPMZ5/+Ft3VnIW3BBFt+9BWUREovn/VKbu1AbvuIoqFRsqBrU4Hmqe/od
	 OdqoUgjrcBhJpd4luZuZ8xTCT7n6yGmf8gQZRYsX9aB1s1bJNyU9xk1YujtizQYbze
	 YLPPvISKdah6CX4SLnZpSVfE2kdhzXINurRtLkYBniUfRDpLegOuJdQCkIPC5XxOG9
	 CKB7mzLajrVdQ==
Message-ID: <1fc81157-824c-4296-ac5f-e8965f64597e@kernel.org>
Date: Tue, 14 Jul 2026 13:29:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: thp: unlock i_mmap before releasing split folios
To: Kiryl Shutsemau <kirill@shutemov.name>, Zi Yan <ziy@nvidia.com>
Cc: Hao Zhang <hao_zhang_kdev@163.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 linux-mm@kvack.org
References: <20260710071344.GA106129@zh-pc> <alDSekC_5t-29vJS@thinkstation>
 <alEWEColDdwQboYX@192.168.1.215> <alEg6ZPc-ao7s6o6@thinkstation>
 <DJXXKH4KOBVQ.2I9NU3EJL88HA@nvidia.com> <alYNlDNMQy0Fl2VB@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <alYNlDNMQy0Fl2VB@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6009D40004
X-Stat-Signature: 9zptpqnce7bndj11xakedwrdt4ty7nb8
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784028599-350964
X-HE-Meta: U2FsdGVkX196/BQbd+5KDqF1HZRam0KbhJMqej6K5fjMjIRWgPTiaugFttuS/omTvY1hcCOjqSYbfHjM0+mWJcBLpp6iZm2qvb/SlvrIqrqIFBvBMW5H3fAkm94uzM25lKLECgZke1+kUifWkvVgo1+3x0a9PDAMmgra8rlK3gsZqkcUj+fbDURF3ZdUjH1cj+IiZZQxnjzkCJsQdcmjIjg4lfBlEAxtNlFjuX3tJfbKuJvmp0mVDZ469kg11VWutpOVsojTek8foUa60zRoXFgLyeksl25OaPi63M2Vcg8OkpTzyfcFDJeHjDEhFi8QNbQ/ysM5fUVau0tXdO4/FgwsU50FRfFGd/r7gWtfFN7m3dh/FThKXznsTyXC5hrGcfeh32MMGtuKq3vxUZb/eqhTNINVurFduznUfXQ3gmDrpLqeUZ5AuLkblR+ur2iBH1RH0/1fOFU7FW40hwdnTnzt8uDru+tNgYGuAyNZRrMiREHd1hp9J7TR9tvfcToQBxOV42HR8LDNGU8tr6XTVcwocukdgsONH8nWVciw43RApYiKGk1uqTplz6OFF+WCb+FMrqGO0mPYiwEKWx6ESu70o/8Q9Bj6lsUOs6ku3kRCW17ZiFjh5qP0S58O7oAjuqo2Duh7nOLTIEEvU23Hq1wz9qIHFk0FRyWQzjmhovfBDYvNNPPPohOimP68ExWwtQpXFuYvY7edzg1Tm5lGlqVCL3hcFGHHbbSCVfrOaO/PtIyF6BJy4RlLRES8v3PCXLScHMZm2xhOn1zdHyMaK9FE9Y5UiMZ/lxffHoot0RLBTKqxEg0AzWDDLtwU+N2d8wpHH/WosdsHGlHYJdIn+VKaVMwUa6EB8iiS/mTR8kvnY0ojfAKq9hmwNM18HjBPYd4/T1VxnqA41EcslFZh5eIX+bVAKiVlGpJJkkwM4qcWhMO8gcVO+TCPpjcIO17ht2FYfKC6q63zM6cV2pe
 pwx57Y+O
 fMcwFAdz+rJXIs9AZB5K8FED44Cdr07O5PkD+fR29mcHHrfZCLzJGt6eDQAn/7tQcEjE7aukkHzyMTMmUyic6QXfdStEdjpdhdKBaTLjth4KG6yisE6rLde4TxZ3FGcZvQzw73bjCUMtBW6pF1XUQ+A2eqIOBfBVNzO2j/kcrw+BoOfOZkeeroYr9KIF8ADVh7lWYF2bzJYUEinHXvEJSWgpVk3heJLlBZ9D4GBJuGCg6zatoKMo3RISGXyqWUcgpj3+domy4vn+tUennfH0gObMKHX/lxOtCw5Ve+phfkqEholKnaVHiIurMXfZj7YW/bEweSkqdqOZzvBs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/14/26 12:26, Kiryl Shutsemau wrote:
> On Mon, Jul 13, 2026 at 10:15:40PM -0400, Zi Yan wrote:
>>> This log line confirms my suspicion.
>>>
>>> The UAF fires at i_mmap_unlock_read() while try_to_split_thp_page()
>>> still holds the poisoned page locked. For the inode to be freed at that
>>> point, eviction must have completed truncation, which is impossible
>>> while a locked folio remains in the page cache. So the after-split folio
>>> containing lock_at was no longer in the page cache — and the only way to
>>> remove a locked folio is the split itself: the new_folio->index >= end
>>> drop in __folio_freeze_and_split_unmapped(). It requires lock_at to be a
>>> tail page, which is what memory-failure passes.
>>>
>>>         CPU0                                    CPU1
>>>   i_mmap_lock_read(mapping)
>>>   __folio_freeze_and_split_unmapped()
>>>     __filemap_remove_folio(lock_at)   <-- beyond EOF: leaves cache, stays LOCKED
>>>
>>>   /* no locked folio pins the inode */
>>>                                         evict()
>>>                                           truncate_inode_pages_final()  /* nothing to block on */
>>>                                           call_rcu() -> free inode
>>>
>>>   i_mmap_unlock_read(mapping)          <-- UAF: rwsem in freed inode
>>>
>>> Your fix moves i_mmap_unlock_read() out of the window, but I don't think
>>> it is complete: shmem_uncharge(mapping->host) a few lines up also touches
>>> the inode, and its nr_shmem_dropped guard is exactly the beyond-EOF drop
>>> that triggers this. So it is in the same freed window; the patch just
>>> relocates the one dereference KASAN caught.
>>
>> I was discussing this issue with Codex after I saw Kriyl's patch and the
>> iput() issue raised by Sashiko[1]. Hao's patch might be still valid for
>> shmem_uncharge(), since all after-split folios are locked at
>> shmem_uncharge() and prevents inode from going away. So the rule is no
>> mapping/inode dereferences after the after-split folios unlock loop
>> begins.
> 
> I agree that Hao's fix works, but I don't think "all after-split folios
> are locked" is the right rule: the beyond-EOF folios are locked, yet no
> longer in the page cache, so they don't block eviction. What actually
> pins the inode is @folio itself: the drop loop in
> __folio_freeze_and_split_unmapped() starts at folio_next(folio), so
> @folio always stays in the page cache -- even if it is entirely beyond
> EOF -- and stays locked until the unlock loop.
> 
> But maybe we should sidestep the problem altogether and refuse the
> split with -EBUSY if @lock_at is beyond @end. Then the caller's locked
> folio is guaranteed to stay in the page cache and pins the inode for
> the whole function. No ordering rules needed.
> 
> It is normally only reachable as a race with truncate (or eviction),
> where failing the split is harmless. The exception is a folio left
> straddling EOF by a failed split in truncate_inode_partial_folio():
> memory_failure() on a beyond-EOF subpage of it would now fail to split
> instead of dropping the poisoned page. That range is zeroed and
> unreachable, so I think it is acceptable.
> 
> Any opinions?

I guess a deferred iput through some workqueue is not an option?

I'd prefer if we could keep folio splitting working even when the passed page is
EOF.

-- 
Cheers,

David

