Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BBE0C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 02:06:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B1326B0095; Wed, 19 Aug 2026 22:06:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 089916B0098; Wed, 19 Aug 2026 22:06:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE4416B009B; Wed, 19 Aug 2026 22:06:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C0BC36B0095
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 22:06:48 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 28D251A0471
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 02:06:48 +0000 (UTC)
X-FDA: 85120009296.03.F2685A4
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id B89F340004
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 02:06:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=QDDKSnt7;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787191604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9cn1/P/B3zAG2kEeQ3u4Y6BjIR36UHwUo2nuNriXzYk=;
	b=wln6xKXkPhzf/qxHiqUa9fVTe4LJiV++xPlbUk+kvUpcaVTi+WGufQCPx1EcA9xuLAQpO1
	V01tnQVsoJHfrmxfJZI6N1dHcKKAfhv3GW5/bDs3BOFWaYLJOlS6QPujW0NSmXLrkpNefF
	rr2kkXgyw8DBGoLQ04SIh2OocG7kb54=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787191604;
	b=Ps7gm6cRZyARjs23QS8w6pWnYW4gczxIgOP/cIy9U793UyI7lhwrH8klySWnebtLLPfFjB
	lMJ2GRfc+fgxWU7gdWHZuWX+4GCio35uAQ4Jwdq8QP5JwJ6GHGpGrorQvpW09RUzp+szcv
	Df4h7thzMUY1HfdkuPf29H4soMkcB4s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=QDDKSnt7;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787191599; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=9cn1/P/B3zAG2kEeQ3u4Y6BjIR36UHwUo2nuNriXzYk=;
	b=QDDKSnt74/zv3Okcuo8ULBkkVCaG1gFxZAWOtJY5VlkDE0jNAPrZYqKO+h6usmSMtO8LpLBkK37kaJjh4atumVOjShpatDl54BKyQB0uAu5BFxmV0nyg3B8CThlkxTplmzbZUC4yxD4FrkPdz2wZHlAvj6KhpogANczKgFlMM64=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0X9I-64s_1787191597;
Received: from 30.74.144.123(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9I-64s_1787191597 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 20 Aug 2026 10:06:38 +0800
Message-ID: <955fea9b-7c5a-4646-8116-efd848f71e61@linux.alibaba.com>
Date: Thu, 20 Aug 2026 10:06:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: transfer the pmd dirty bit to the folio
 on zap
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, baohua@kernel.org,
 david@kernel.org, dev.jain@arm.com, lance.yang@linux.dev,
 liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, nico.pache@linux.dev, ryan.roberts@arm.com, ziy@nvidia.com,
 kas@kernel.org, nphamcs@gmail.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kernel-team@meta.com
Cc: stable@vger.kernel.org
References: <20260819101222.3732660-1-usama.arif@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260819101222.3732660-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: hsah8e4419erj7149uhkkppt4ytfeakk
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B89F340004
X-HE-Tag: 1787191602-795999
X-HE-Meta: U2FsdGVkX18/uVKYk54Ugom7BzRzQQgdMnMpCcgKHGfWeOYUam9Artp9RAQUHuAQOMBkdth8rRu24aS1RM7oP9dWI08+ZNj1UX8uypqnDWQLGhBVXeAlUTZqCmmupu9EOqwkij+yU+VJpf+rZHsLYDbf3jEPz6RiwSaVEaIKqwdYXT8DSwIdlpe44b0XoHSHowuB3W6I3LoCj8GGIi3XeJzsDjEizychVZ3n/6aUIJnvbL1ebcQtCt1OChr8ciCxLHHEvsz4Hj7Z3MTAA4yOlci0GP5JnQyLwTxLQ1DkacTTBbDdYeeBGKb8Fwz0PPLcaXQYPjcGK2nS/HsSlFNcNuR/kjWPCsTd7NFRVIGhxHq2byGMHIc0U1lbwKe0kUdzg3CmlHoPwns856B9lExz5Ko4pnSiD0ZHnXm221uh1fPaPsQWigOeaIlECWB/n961trAZGZ7+v6KJHqAEdJRxsLZzpBt75cqUicpAdqt5mZ+7PCcCCEPKVBoV6MTFs/soYJk2lrhyJj+ufva1l8li7/2ZnbVIC9x0ilI3SUWXVKjubmnvRma+mOh80/T/+MhMNpiO77JlxwzNBA8nVE86J5RKowFlC6Eev68oyEbniiIMRrzui1QHboq2puZD6uWctnvx3DFQjXmrCh4L0M2LVIz53KpOIyss+OMWTXo4Ty6hIyWSVepEwyFg3LtVgultJyR7fctCZM3bGw06/liOeZtSiHP+v6ewKGUAWCWH6zixCCrpcVMm5G76+s/Ci/Er/ri3mNHCZxUHEpKfxxPmvtTCdBUKMHYcUgntFeqYrEA26CGUuf9z7766BHF8RuWEqxjbZzM4sx8tDNzkfQw9XuRcwn0p4LHzBQK5U4rwVKOmpXEIfK3gCmVFKD9TSJO4rKMSyd9B/JBfCmJ0w7haX28ZvjC/JQvhmTJR/7/qQJ5XpM4lfeyoQJ4/vVb/p/8+Vf6mXLccJSDeyQOwA15
 hHLEVyDL
 2ZeRZtYXhn+hWKoWz5jS08GAsr2SMr5GjksTVQWCcN+ZvtLLoT2FdtgQvXI3y4K1EjLi8lXgqTduGFT9M+i4BppwqWr1giYg5oN/s8ttrVoIHUnzAOZDmiyvGJJ/qo812fdu7aamT1ER9BaxxYO/vDINDHT0pzXMn1UR8dlvSIn0TjYbzvH3Ehg0F0eMW6nopttc4p+jCstADZb4/QG28Rufno2A5tjOxpvMTwloaf1jcMB4SWYFsrGOgxpTdas4Xsm3R/CiUgnqgLoZ1Q4FXKbQdJ1Q0Cme2kSn+h/EMvDwrqorFTn16LQ1iB5LVsYU9QiELKHEypSdDcR7lZCzGQVdHDqMBN4v6ynW48xjvEaAhILZ3NInOynLVJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/19/26 6:12 PM, Usama Arif wrote:
> zap_huge_pmd_folio() propagates the pmd young bit to the folio for the
> file case, but not the dirty bit.  The pte path does propagate it, in
> zap_present_folio_ptes() and so does the pmd split path, in
> __split_huge_pmd_locked().
> 
> For most file mappings the omission is harmless, because writing to a
> shared file mapping goes through page_mkwrite(), which dirties the
> folio.  tmpfs is different: it has no page_mkwrite(), and
> vma_wants_writenotify() is false for it, so a *read* fault on a
> MAP_SHARED tmpfs mapping installs a writable pmd via do_read_fault().
> do_read_fault() does not call fault_dirty_shared_page(), so subsequent
> stores through that mapping set only the hardware dirty bit in the pmd
> and never call folio_mark_dirty().  A shmem folio allocated by a fault
> is marked uptodate but not dirty (see the clear: block in
> shmem_get_folio_gfp()), so PG_dirty is never set at all.
> 
> Unmapping such a folio - munmap(), or exit_mmap() when the process dies
> - then loses the only record that it was written, because zap_huge_pmd()
> drops the pmd without transferring the dirty bit.  Reclaim afterwards
> sees a clean shmem folio: the whole swap-out block in
> shrink_folio_list() is inside "if (folio_test_dirty(folio))", so
> pageout() is skipped and the folio falls into __remove_mapping().
> There, folio_is_file_lru() is false for a swapbacked folio, so no shadow
> entry is created and __filemap_remove_folio(folio, NULL) simply empties
> the i_pages slot.  The data is freed without ever being written to swap,
> and the next fault on that index returns a freshly zeroed folio.
> 
> This is silent data loss for any process that keeps state in a
> MAP_SHARED tmpfs segment across an unmap - for example a cache handed
> from one process generation to the next through /dev/shm.  It requires
> the folio to be PMD-mapped, so it only shows up once shmem THP is
> enabled (which is what we did in Meta fleet and started noticing crashes);
> with THP off the pte path transfers the dirty bit correctly.
> It also only becomes visible when swap is enabled, because with no swap
> device shmem folios (which are on the anon LRU) are not scanned by
> reclaim at all, so the clean folio is never dropped.
> 
> Reproduced on x86_64 with a tmpfs mounted huge=within_size: read-fault a
> 2MB-backed region, write a known pattern through the resulting mapping,
> munmap, force reclaim of the cgroup, then re-map and read back.  Without
> this patch the region reads back as zeros and vmstat shows zswpout 0 -
> the data was discarded rather than swapped.  With this patch the region
> reads back correctly and the pages are swapped out as expected.  With
> huge=never, or when the first touch is a write, the test passes either
> way.
> 
> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---

Thanks for the fix. Feel free to add:
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

