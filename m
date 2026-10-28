Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14DFE606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 08:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ka7GAHpt
Received: by kanga.kvack.org (Postfix)
	id 3F5916B05B9; Wed, 28 Oct 2026 04:44:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CA6C6B05BA; Wed, 28 Oct 2026 04:44:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E2E76B05BB; Wed, 28 Oct 2026 04:44:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0C7036B05B9
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:44:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 15637A0C33
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:44:58 +0000 (UTC)
X-FDA: 85371399876.07.F32CB81
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 53E9740006
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:44:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ka7GAHpt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793177096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f+44Zt08Ec+FbsUxCi2UdL40Z7OhmxVeqHmo7xhynXM=;
	b=aPWdTSWV7ZQGt5zZsxP9hHOT/CNuQU0XudBQuMhkpA9MJ/mOtZkTh0JRj+w/nPyFPtlzq0
	ZMwEgGuHiiy0Mz8WB2xV7UInn35J6OXi8uqJYsPJ3k3B7i/X8U+/Y28b8Fz6+TEBG5gajS
	D1wtiEwNwosqaxz0JHmMRcMIMLG0ujk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ka7GAHpt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793177096;
	b=pzREVdx0DaBx32c4gamGjq57n77Nr8CE9wnXjLuxdW+wgQghq8UB+ZDRGOAXI4GhbTd+qv
	y11G0+K8wbfnL/2Q3sb48kT1OY+Bxr3PT/nqZ1dgjBudY96+CKUgplvk6PCRhtnhH56nxz
	7FUmtRvuKTiS0f+ZN6lIDjDtcw6y20A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D449960136;
	Wed, 28 Oct 2026 08:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813221F01825;
	Wed, 28 Oct 2026 08:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793177095;
	bh=f+44Zt08Ec+FbsUxCi2UdL40Z7OhmxVeqHmo7xhynXM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ka7GAHptCX96Cpin6rN5Z+/BZuap2WQhtZisJyOT39uWcrkTSIbLyZSR4rlLQws7x
	 3Vi0sv2RQDBgdnEQOVD8q+UagGE7udWRxGX4IyNm1bgyK4pP3Wjsnn7nlyqhfdodiO
	 mSVhnlg6HVWKg6M51eoLIQuCNqFAz9kTxhE2OUf93dl4Ejl2HZRzLXY5BgeIs9CXxT
	 I4jjSOggK7qCzQGSwNtBvbB43FQ0SOaRIs8z3eOX1mrAr7qk3MCd/qxjG+wHyDPuhh
	 GyHlIkilY8hvL3RXlzVllsvjSudkQ/a55la4UG6gP5ctAGG+B86KzDpsHtzCPiqFmd
	 dsECo8easr2VA==
Message-ID: <81862da7-21c7-4060-87f5-09650582ea24@kernel.org>
Date: Wed, 28 Oct 2026 09:44:49 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] mm: memory: fix truncation removing mapped folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org
Cc: ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev, jack@suse.cz,
 pfalcato@suse.de, ayushr@modal.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <14ebbd556cc4941f0ebc43da59fa6a2fdca25dc8.1793148609.git.baolin.wang@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <14ebbd556cc4941f0ebc43da59fa6a2fdca25dc8.1793148609.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 53E9740006
X-Stat-Signature: quj7k46ygzw5offsfwkcriykgqfdne1a
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793177096-714742
X-HE-Meta: U2FsdGVkX18Q3jMCYXRQmRvqGaDs3RAIWvQZKZvJhm/kUe9ECpbZrttom5r5nasQYqOSQaK3iJCcsLa6bgDwkhKdYGyqRr+SaTWEvCGaicJe/YcS44R8JFpARH/Y+rtzRlXM0LIn50GWFFgqm7WBP/1s8bNu6E43iY7WsVczM0+PgfHZeKn21XFHD8vAlOOPAoK8asTlJnHW8r52Lyo70QT5UMKRbUsLXKMqkK9IInUfNr5dJQP6mnTKGnxpU/r+CGltR9r1cwhSem2usO05b1FsRxhJGO4XjJMfmX1IYkw8vc8SCdgs5jMCkVsNa7nyg7rzjidUJJVypahFU4FPMdoQVUE6pZsTZ13aXFeWLaTC0mA3SSnhxDl0rhvkt7BCzer5GYsr2z3Y3gEjz6txg21fXYD92ZaLs4x8RN05NQEUAnIetY9q2i8dp6avDYdM0rAxLI9U0EQPHalAj1TM7IJ6sH3p+QAudAaALXxadgZnF+FBGuXO9qN8hR0ndTg5gdV8XUUmr5uEejpNgelt3C1BD+ReQi1hYb6Tr5cwkOxzPpDZWunnbxTF6SD8Ev0GjriRCB1qGVs56qLj8U5gO3N7dlOLO7hfvETDKt0s6A4TQsy3r+w/pTqjO5snUbMk8jdDg7dlxvDtc0oxLZPPbB42rPlj/a3Re2EV48LAKN8cPrJnHkM1zqQI2/JuM8oO7XVTtyeJt56q5Iu1BsLN4G/frKFBqUIH1L+3sU0zCC182Vb+Iskjy85NJRp0nSwBqIOZm4uwpNpxW6Gs+3AotziHAc0R/IzQkd1v1vC78dFYRg05h71s+A2JJ6IWriP5JICD2EOWyzSxksAawjbW61oQwVWzmzIvI+BAWT0OHZMvg7Pa7zUpQ1nPAELHVPvAM+b5ZVqiVPQHxuvfT9D17zy8XM841aCdrE3K6+VU6aKyn/13dwEY0UaeFoZIarkWmsFZM16+BraZ+HovsKA
 uOHDF3LI
 yqVkc4L9iPJTrVHMU2TkPnB5yTvXOkUpB+sLT4xJ9u8bk754pZfYGTvVtnwZ5yxIFPzDBbL6WGrwJtfNkfo8PypH8Tdp5h4bU30BdTMgspXciHNnejHnYibo59FMZ1pn5rWsWW2HgDf6hyvg5FL17vBM/idLxNmW9GMYYpwkOH5QyukmiYRhMallaShAXpgSy/QV/LGQuSck2AVkam1XbYol6JcYWWC89Bxamss2y3DP229M5vMgy52/WipWk091PbS6f3xsiE8vneD2Xb2vQOw2bKOdkgj2q04Kc9+jEs75LfngKwTD9G0KUPTy3LcAAByreh+P17pHNuzmU+K9Urh26S0qiUR7fycnUTP9IMiKO6kVTDX0wdpOzPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/28/26 01:52, Baolin Wang wrote:
> Ayush reported an issue that shmem/tmpfs folios are still mapped when
> truncating them on production:
> "
> BUG: Bad page cache in process ...  pfn:...
> page dumped because: still mapped when deleted
> "
> 
> I reproduced the issue with Ayush's reproducer [1] with the latest mm-unstable
> branch, and I got the following crash info. From the dump message, we can
> see that truncate_inode_folio() is really trying to remove mapped folios,
> which is incorrect.
> 
> "
> [  189.171977] page: refcount:3 mapcount:1 mapping:00000000fe168ee1
> index:0x3880 pfn:0x191647
> [  189.171995] memcg:ffff0000cc073d40
> [  189.171997] aops:shmem_aops ino:3c01 dentry name(?):"memfd:runsc-memory"
> [  189.172006] flags: 0x17fffef0002022d(locked|referenced|uptodate|lru|
> workingset|swapbacked|node=0|zone=2|lastcpupid=0x3ffff)
> .......
> [  189.172017] page dumped because: VM_BUG_ON_FOLIO(folio_mapped(folio))
> [  189.172026] ------------[ cut here ]------------
> [  189.172027] kernel BUG at mm/filemap.c:155!
> [  189.172057] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
> .......
> [  189.177721] CPU: 3 UID: 0 PID: 5521 Comm: repro Kdump: loaded Tainted:
> 7.3.0-rc4+ #277 PREEMPT(lazy)
> .......
> [  189.183986] Call trace:
> [  189.184124]  filemap_unaccount_folio+0xf0/0x1e8 (P)
> [  189.184391]  __filemap_remove_folio+0x34/0x160
> [  189.184633]  filemap_remove_folio+0x4c/0xb0
> [  189.184859]  truncate_inode_folio+0x34/0x58
> [  189.185087]  shmem_undo_range+0x220/0x658
> [  189.185308]  shmem_fallocate+0x2f0/0x470
> [  189.185527]  vfs_fallocate+0x128/0x328
> ......
> [  189.187078]  el0t_64_sync+0x184/0x188
> "
> 
> After analysis, I believe the race exists between truncation and MADV_DONTNEED,
> and shmem's ->map_pages() merely makes the issue easier to reproduce. Since
> MADV_DONTNEED synchronously releases the pagetable page before calling
> tlb_flush_rmaps(), this could cause another thread's truncation to skip
> zap_pte_range() (due to pmd is none) but still observe the folio's mapcount
> as non-zero. A possible race scenario is as follows:
> 
> CPU 0                           CPU 1
> shmem_fallocate                 madvise_dontneed_single_vma
>   unmap_mapping_range            .......
>   ......
>   (filemap_map_pages() remap folios)
> 				  zap_pte_range
>   truncate_inode_folio		    zap_empty_pte_table(pmd clear)
>     unmap_mapping_folio
>     ......
>       zap_pmd_range (saw pmd none, skip)
> 
>   filemap_remove_folio
>     BUG_ON(folio_mapped)
>                                     tlb_flush_rmaps(remove rmaps)
> 
> To fix this issue, we should move the pmd clear operation (via zap_empty_pte_table())
> to after tlb_flush_rmaps() and use sync_with_folio_pmd_zap() to sync with
> concurrent zapping, so that when we find a pmd_none() while unmapping a folio
> without holding the PTL, the folio's mappings are guaranteed to have been
> removed via tlb_flush_rmaps().
> 
> Meanwhile move the second pmd_none() check to where it belongs: if splitting
> zapped the PMD.
> 
> [1] https://lore.kernel.org/all/20260925065013.3682431-1-ayushr@modal.com/
> Reported-by: Ayush Ranjan <ayushr@modal.com>
> Closes: https://lore.kernel.org/all/20260924061708.1645968-1-ayushr@modal.com/
> Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
> Cc: stable@vger.kernel.org
> Acked-by: Qi Zheng <qi.zheng@linux.dev>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
> Andrew, sorry for the trouble caused by the several iterations:).

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Let's see what the fallout from this one will be (performance wise :) )

-- 
Cheers,

David

