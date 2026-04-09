Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30809E9DE68
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 09:00:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B52B6B0005; Thu,  9 Apr 2026 05:00:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 766576B0088; Thu,  9 Apr 2026 05:00:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 654B06B008A; Thu,  9 Apr 2026 05:00:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 541F66B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 05:00:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F3C00C1E84
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:00:41 +0000 (UTC)
X-FDA: 84638421882.10.C70CEAA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 14B19A0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:00:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BFnn4XBi;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775725240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a5GCs+NVrlIL3xxuFLyCPrY+ptg/H3J+GCpxvvTNBz8=;
	b=Ja6O7pcJnR3DaiF7tmf3JrphijdYQgiGh7Z1txfZKRui/FqczYbdRijXWiryFm0qlQzsjg
	7UFhLUFYAO8AXVm+K20Oy/j9yk9mzZt3HhMYnCbS3YadyzzcBAE/PHq2WMEVlXX1eihSEC
	UGIx5iGCr7yIPYou6dgX+blLNzbzrZ4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BFnn4XBi;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775725240; a=rsa-sha256;
	cv=none;
	b=2sKTXe8K2XLCgWx+qWs4q4hH/mKO1u0JYbr9cNBHj+3IolFikyXVvkb2qU4ViFjUd+k+VH
	UkNHvDl+ClaajivU6dW0lCwH9AYKa0t61SleuSmiZe5c/jg/4VhloRemSPl/ApU0B/TAy1
	S6qQgNchUx7vMNN4hK+ZbkiZAnTQRuQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CCD5541934;
	Thu,  9 Apr 2026 09:00:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD91C4CEF7;
	Thu,  9 Apr 2026 09:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775725238;
	bh=ZO3gMd5SCYUHW1ze3Rln/U5DdDpUtmeUbd0y31FJ00g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BFnn4XBiag8+7OHUnjbs1qY0QMWJItcBOHJozZYNE2q44bpPythgCsjgUyd/Fz4so
	 1Ol7J4JKhc7cZaa+AQMAbK496bkPWEZyddcGGnm124gXV40HowlO1/fmcVWwdsGSow
	 va3vDSjFrHWqa2iKraxMQQH2ay4VhWYyb8HgskNRYfZzqIjJNn3oM0sh1uzJvbuzpi
	 GpdA/2EPOlPD/Mhf5tWViLM3ha0IPIoNQB4G+0xYmHuTD36VlU8q6S+9xtwREHkVvV
	 /d5qiwZfJlKrt+tHDz8jzTI918+0RF2xi/y9m21TdQ4hOmv7US+v+YjxdmMREnXkDq
	 1IlDwYVnkFe1Q==
Message-ID: <4dd26573-85cc-446a-b2b7-2aeab8aa2417@kernel.org>
Date: Thu, 9 Apr 2026 11:00:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: use batch page clearing in
 kernel_init_pages()
To: "Salunke, Hrushikesh" <hsalunke@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rkodsara@amd.com,
 bharata@amd.com, ankur.a.arora@oracle.com, shivankg@amd.com
References: <20260408092441.435133-1-hsalunke@amd.com>
 <22b6ff3c-9d41-4eb0-9beb-cb92f3ada89f@kernel.org>
 <4e8c218b-ac5e-4674-9e1e-acf750f0a5c8@amd.com>
 <20260408083229.45d1a083f17484d3b2678855@linux-foundation.org>
 <fcc68286-d2ae-4e51-b4b2-886af115ad7c@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <fcc68286-d2ae-4e51-b4b2-886af115ad7c@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 9gfnqbecwg8fyks9aeih3xz6de7rj7jk
X-Rspamd-Queue-Id: 14B19A0005
X-Rspamd-Server: rspam09
X-HE-Tag: 1775725239-933595
X-HE-Meta: U2FsdGVkX1+fBeLMqsyj3GPeo+SbytqMw8GCgFvbz27NNSwkp7NH+dbkczAU6zMHgD+vWcv8dc0cQ7YonwYx+I9sSkJJLF+tbgfpF7p1gHJUcs/BzxrL+ifmjiMFRFwReagRkgkYCWf/aDkpN9pP7LEIQ+1DV9QBG5/yeqshx+povrakGqR5snozepNQrKCaMSi16gQEOpZASwq8oH2h17eM+XxfJoGx8Q65+GMmnNPaZmmzJM41pkL7pIxtTv0hef4hqw3MtUzeXDdqkWRQehlUgzPM3Ospg4v5t2GNq0u12iIzJWSwaXs2OUxrzN+bRpLhEItXvf6zxFdfTHDExlU4ekrGAXxJ+vWl9EydO+RZTE9le7udyF7BHlYY/QrPmbwjZxOk3CJn9Qad24vv4sjKVYfoP3HIPPR3yCcDr3RyE9tvjDlWYP7VJoockTbhEJ4KoZHPULk8vlASxNWq0JyhR8bn91MSyqB6pK43wOKH4PBguDaZgb9699vvHQNwY3htKvkx/UnXiMoV7DycGeRroufVNCmILcnhb0S5EXLXo4ljuHyLBjSOOL6VMcGevMW7hXU9zGNl5CWW+T0CdNRrBsm4053ODrnbx+ObBvvSSz9v8KZ5giIzdhYXj/1B7fIQVkel5B08ibPLd85vFMxjU6HRi+Ns3ZjEivzX/hj9vDtIZjxb5CnLbK3hBdlY2eGTVezdR1ul/3jIKmPpD/EVsKdEW39pHZ9y1JSX7V4o0xhVuvOKqxftrF6lKx/IKLRMlNiFThJn0iv45/ikmfAAUjbAvcQP1SxC9RzfRPak9y2YY5QGu7TV0wOUYsnkOkl6uYdTDga1iGoGxElWUVMvdSO7V8am+pJq20DoP3Y3hFM1uaeKc7Heue2uLDjbEOKEGXHrCo2PXkpQwd3zI4D5eO5bW/vAaiTcX9REmylXxCKB2nf4NQot2PkniSlkJsm8oFTw2A0VrY5sxIM
 L7JkC3EU
 75Vf/aAzUqpFYxsE5AqJs8CqMgPbRIFb6fpUnaPxy3FxWKhwsgm7u50ORQJmP0F1AQxECg1EYf2X3thcr+2EnWly/qUV9eLCOrklaSXwUx976UEmBWm/YfIbHFzfUxFi+kpvDEiEuRbKNZxunN6Zb1NAVmZXIFK4kfhaQSR4udRpmOgX8KZ6014wqH9U5PRJu5GY9WOBmjYSZmbafNQ2zFek9E3CwmVrSzWLxQz7wv4he8kY9HjX9CduCfrzlkT74QHXY2C+MGZQJVyxTC4De0eg0YNFqvixmrTDYRpv9Ay3VQfNyS4y345k4Vd5derGJ7EacLg2JUzccpw8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/9/26 10:55, Salunke, Hrushikesh wrote:
> 
> On 08-04-2026 21:02, Andrew Morton wrote:
> 
>> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>>
>>
>> On Wed, 8 Apr 2026 16:14:03 +0530 "Salunke, Hrushikesh" <hsalunke@amd.com> wrote:
>>
>>> kernel_init_pages() runs inside the allocator (post_alloc_hook and
>>> __free_pages_prepare), so it inherits whatever context the caller is in.
>>> Testing with CONFIG_DEBUG_ATOMIC_SLEEP=y and CONFIG_PROVE_LOCKING=y, I
>>> hit this during exit_group() -> exit_mmap() -> __zap_vma_range, where a
>>> page allocation happens while the PTE lock and RCU read lock are held,
>>> making the cond_resched() in the clearing loop illegal:
>>>
>>> [ 1997.353228] BUG: sleeping function called from invalid context at mm/page_alloc.c:1235
>>> [ 1997.353433] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 19725, name: bash
>>> [ 1997.353572] preempt_count: 1, expected: 0
>>> [ 1997.353706] RCU nest depth: 1, expected: 0
>>> [ 1997.353837] 3 locks held by bash/19725:
>>> [ 1997.353839]  #0: ff38cd415971e540 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap+0x6e/0x430
>>> [ 1997.353850]  #1: ffffffffb03d6f60 (rcu_read_lock){....}-{1:3}, at: __pte_offset_map+0x2c/0x220
>>> [ 1997.353855]  #2: ff38cd410deb4618 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}, at: pte_offset_map_lock+0x92/0x170
>>> [ 1997.353868] Call Trace:
>>> [ 1997.353870]  <TASK>
>>> [ 1997.353873]  dump_stack_lvl+0x91/0xb0
>>> [ 1997.353877]  __might_resched+0x15f/0x290
>>> [ 1997.353882]  kernel_init_pages+0x4b/0xa0
>>> [ 1997.353886]  get_page_from_freelist+0x406/0x1e60
>>> [ 1997.353895]  __alloc_frozen_pages_noprof+0x1d8/0x1730
>>> [ 1997.353912]  alloc_pages_mpol+0xa4/0x190
>>> [ 1997.353917]  alloc_pages_noprof+0x59/0xd0
>>> [ 1997.353919]  get_free_pages_noprof+0x11/0x40
>>> [ 1997.353921]  __tlb_remove_folio_pages_size.isra.0+0x7f/0xe0
>>> [ 1997.353923]  __zap_vma_range+0x1bbd/0x1f40
>>> [ 1997.353931]  unmap_vmas+0xd9/0x1d0
>>> [ 1997.353934]  exit_mmap+0x10a/0x430
>>> [ 1997.353943]  __mmput+0x3d/0x130
>>> [ 1997.353947]  do_exit+0x2a7/0xae0
>> tlb_next_batch() is (fortunately) using GFP_NOWAIT.  Perhaps you can
>> alter your patch to not call the cond_resched() if caller is attempting
>> an atomic allocation.
> 
> 
> Thanks Vlastimil, David, Andrew, and Raghu for the reviews.
> 
> After looking into this more, I think adding cond_resched() here was
> overkill. I agree that dropping cond_resched() and 
> PROCESS_PAGES_NON_PREEMPT_BATCH entirely and just calling clear_pages()
> is the right approach. There's no case where cond_resched() in 
> kernel_init_pages() is both necessary and safe:
> 
> - It's unsafe in atomic context, as the BUG shows (tlb_next_batch()
>   allocates under PTE lock + RCU read lock via GFP_NOWAIT).
> - It's unnecessary for common allocations (order-0, mTHP, 2MB) which
>   clear in well under 1ms.
> - For 1 GiB hugepages, kernel_init_pages() only runs during the
>   initial admin-triggered allocation. When processes later fault on
>   those pages, clearing goes through folio_zero_user() ->
>   clear_contig_highpages(), not kernel_init_pages().
> 
> So rather than guarding cond_resched() with GFP flags (as Andrew
> suggested), I'll remove it entirely in v2 to keep things simple and
> same scheduling characteristics as the original code, just with the
> batch clearing performance benefit.
> 
> Regarding the 512 MiB arm64 case that David mentioned the stall from
> clearing that without cond_resched() under PREEMPT_NONE is acceptable,
> or should it be handled differently?

I mean, it would already happen today, because there is no
cond_resched(). So nothing to worry about I guess.

> 
> I can introduce clear_highpages_kasan_tagged() / clear_highpages()
> helpers, or keep v2 minimal with the logic inline in
> kernel_init_pages(). Any preference?

I'd prefer not sprinkling IS_ENABLED(CONFIG_HIGHMEM) around and simply
calling a clear_highpages_kasan_tagged() from kernel_init_pages().

-- 
Cheers,

David

