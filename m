Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9A70C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 16:09:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2D726B009E; Wed, 19 Aug 2026 12:09:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E04336B009F; Wed, 19 Aug 2026 12:09:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D41256B00A0; Wed, 19 Aug 2026 12:09:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B272B6B009E
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 12:09:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3F6FB120426
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 16:09:22 +0000 (UTC)
X-FDA: 85118503764.19.37B0B91
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8C5FD40005
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 16:09:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HOJKhE6Q;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787155760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=63V/Ij2B9WrOrIN2e2zHaSp/qasYhzA6FfRA6dqG5dE=;
	b=YHxhmDxhuwNW4j43371bCCX8QglPHfwC6ziZAGmsS8GCd2sG+y4eGClrHtBKGdvqkXwG8v
	QMtMv4W11smY1zfuWspfAaFj3tLBQ1To8qpmW4xnWj5tSM+MWKnWs4PmSFRHN5Il5ic/wL
	o7JWzYHLVpfJC4zaPEr8RKvciiqpHpQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HOJKhE6Q;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787155760;
	b=TKn0anyvJwBFBNqgw5wA1K/O/tRKk61ZXvtP/KsniyYpPVrB21SG4xVNSmqNcatr0tVXwB
	j0VGvqZ0tV3sHtrbNd2kZS5+O781MzuKM4htjNDPe8CBaSFl4GR7larFrKFIq52pSvI2B+
	xDcA3JiROmq7f3Byw2Ja4yGKMhWqsoo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B345641144;
	Wed, 19 Aug 2026 16:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215971F000E9;
	Wed, 19 Aug 2026 16:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787155759;
	bh=63V/Ij2B9WrOrIN2e2zHaSp/qasYhzA6FfRA6dqG5dE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HOJKhE6QS17uYsGjRHWX/10MHY1v1FQtfamHsWROPjC4W1e30OS75ZZhE/FlHuLHk
	 JlA6cbf5GrzAQq1aJE2kXvjz/M3mxFgzeH6hcZy1bg887ih+kWUIH3WEvniS1FUHko
	 f8YGIOhYiEMOuzBgg/da9wIR0wfdVGX9uRtn6A43EsvkQfSSfF9AsfZi03KJ6qA9AP
	 V57RYR+ColbGaPdAWY8sGcIL2XVw1JMdpD2Ue1AuGazkqrgvaG7I6vI4WWh6cmRMvx
	 WUd8LeDNIpmMpgdgOFTk9eXWlfvlOTF6HHD8ezwbFSHAScUReKcXCNxQ1cAR83ZCN1
	 iiub28M0gMLHQ==
Date: Wed, 19 Aug 2026 17:09:13 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com, lance.yang@linux.dev, 
	liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	nico.pache@linux.dev, ryan.roberts@arm.com, ziy@nvidia.com, kas@kernel.org, 
	nphamcs@gmail.com, hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev, 
	kernel-team@meta.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: transfer the pmd dirty bit to the folio
 on zap
Message-ID: <aoXVDppXAxte7Hzl@gremlin>
References: <20260819101222.3732660-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260819101222.3732660-1-usama.arif@linux.dev>
X-Stat-Signature: urhmo9x1ykdbp9zp9ayueqaf5r316hhp
X-Rspamd-Queue-Id: 8C5FD40005
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787155760-569584
X-HE-Meta: U2FsdGVkX18UwqW8TSvnvbqh4cgx+OF8IFHHhDn5N/vxZjaez/53wLrsrjyjBHzRDPl85ak4YLMvmE77K7TXb/wYYykNQwyk9G/SE65JDh12NgfR4qKGKA3zsgSFGJ7hJzOjAFQ6I4bQoaYB1dR9bDlYqFk7AM+9DIldy7cnEaFhzliTW/Sd228H0rTgKEVsc94VRjHmXuql2WurE9WVUeq8F7LiUY+DQrj/DO2EBtE4e1nxJjRXeD6p3AHu4EyrYWpKH9+RhB/ZKa0HKAGMOEz0OLVKJ56xm7biV05aW8DN+195XDuVrRhRCWVBKa3M3XSmORQMS53JjE10UGO4Nk8pN/GkNewawEH/vy09GvM901HM+MOvvhuZtC6uGW2AMQo5J1vZVebzb4LXqnkxAw34qM/BKnIcuUT49c7B0E5pfzVM0FnMK1vs2qFK36D7OwmucahTSV8NXhSMjMO4i32OPMKKhR7M2iOqh0QMUSkO3UwRMRX41mLBTqAwF+LtniunNGIK3/VFOKAEDuWI0lyoc9L3cLPdHF9TvCF1fyfAK3RbP3i6kn4Xi7lEcRypbFSRN6zwcSeYBEV0bi5IUtsxO92xHFeiN+HNUxQuXrrKaS7fUJ1XXEfoW9c5WDabnPAc9BdeCxa0wVnAP57NjrM7zsKuxB+HPsYo+xmNltLDKOpA4pW3QucCx6DTg17q3ktHBMkYXnE5TkcV/84V76UsZ1bwE//Q/EP+ErmZJZKN7Wd8tx7FEbxn6MYLouNW9n3Hi7VGqzjOxb2IQu6Zm/WYM607LtP9dqe356IEXcatFrnPjgER/8oUgO+lE6TJi5Q8LdUqeKmdJc3tKQYjwNKG1seEvFx+b/dR9fRoosHy7Ojw5nLBkGlqcnYfC+pbUfigzBXzC8F+g4p19j0iL6G7sfVZoDvRr25I7U3Y1VxPHwZV5oYfD/KbvmjWWWuObrkT1jMb2kZe1MrAMSd
 yQJKwwZc
 EPrTzrf1Wnm3IXTlOlWdvRm2BeZklMbaGJMsCkcg8xOJGFpVu5LB96DKcPH/H/re7XxOITAjutRVyHCvAE5Q6PJoNPOJwbluZNJ0Qb8CY4ko5x/l/Id1wE/x2rBLnzdLMOVNI545ZX8GHH5JTKDL6HWGuKRdR2/lLvJaAw4mc1M7CC53YWhocsANG36mgfMrchyIS687Of9uFg09NOs9K07iahQqofp5GEdxsJYJ1uOEsKF+Zz2oYREYboiURG1PKPhSATPqgC0yhf6JPIPv7LaZFNMWuFgs2eF55iSeJOAslBF4MNYMS7x4jNzrV2FWKIkdbSI9HZVMlsKI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 19, 2026 at 03:12:22AM -0700, Usama Arif wrote:
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

Good lord.

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

Thanks for this! LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/huge_memory.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index ced400f72d43a..afbb5974bd225 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2449,6 +2449,8 @@ static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
>  		add_mm_counter(mm, mm_counter_file(folio),
>  			       -HPAGE_PMD_NR);
>
> +		if (is_present && pmd_dirty(pmdval))
> +			folio_mark_dirty(folio);
>  		if (is_present && pmd_young(pmdval) &&
>  		    likely(vma_has_recency(vma)))
>  			folio_mark_accessed(folio);
> --
> 2.53.0-Meta
>

--
Cheers, Lorenzo

