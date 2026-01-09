Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73FCFD232D5
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 04:32:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A96486B0088; Thu,  8 Jan 2026 23:32:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1A356B0089; Thu,  8 Jan 2026 23:32:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 926696B008A; Thu,  8 Jan 2026 23:32:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7E72D6B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 23:32:50 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1D1CE5884C
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 04:32:50 +0000 (UTC)
X-FDA: 84311154900.24.3DC0D01
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id 69F23180009
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 04:32:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DaWBXmAw;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767933168; a=rsa-sha256;
	cv=none;
	b=SblwAJqwJV/36fKIuzoQxVQ9/WVnd8YNpbUnxXJSOsxfO8baaK50Gj7d5l1tAFTlk2DhwI
	nXDnxm79TOxvF2bkxSkHxHgZUuvbDDZ55mMZdL0TaadBiBh36VW/IobT1zR9Kuu86EmpD6
	86OdhV9p1GmuuKZA/0D/Hp+vI+VQ7jA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DaWBXmAw;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767933168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/JXzEUi2PNnrcw0JJqHt09/EBNofffg/9tanxUTmX1o=;
	b=QLX1enDbgGtCb8jWZV4yk8XAtD2/60fwbGd9RrO7+0Op+QoQ+1/x9T8MJFCL8ShrRgbYfJ
	WOkGX1QA1oMbzWy/cW3GA+TmNHb+s596pEZgV2GZp1pzEIfPZqITldr8RJfZhPs18GC1wR
	TcfFo2ZFJMwTYL/Tv+lJOgiSeuaUiSU=
Message-ID: <0cd1362b-ebb4-4c62-bc18-026209777acb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767933164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/JXzEUi2PNnrcw0JJqHt09/EBNofffg/9tanxUTmX1o=;
	b=DaWBXmAw0xDY/7DK4M5ajxWnvQ7aJvdkJQ+uZzkmmFOCjGolT9NnkEaWdhjM12Qg3DlOmb
	Nul5yjEDBlqihotvNs7HO2mP57DE9hKpe6pyd63SCVNA4DQJqZf/She5WLp0AG4hF+33Ww
	SOPcUuWIc+WrGVuRueI1ddMHXrxoypw=
Date: Fri, 9 Jan 2026 12:32:35 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] migrate: Correct lock ordering for hugetlb file
 folios
Content-Language: en-US
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Rik van Riel
 <riel@surriel.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
 Jann Horn <jannh@google.com>, linux-mm@kvack.org,
 syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com,
 stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20260109041345.3863089-1-willy@infradead.org>
 <20260109041345.3863089-2-willy@infradead.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260109041345.3863089-2-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 6pd5rx796u9ngknfuxs9rp6ky5tgy699
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 69F23180009
X-Rspam-User: 
X-HE-Tag: 1767933166-420052
X-HE-Meta: U2FsdGVkX19aQcOzRk+lF+ypqFPoWqm5fVUXe4XCFGcSih9zhNAdhCCtURh/k0c1wuBpiX2Klx0DKJqe8N9TeCTK+N18Aq7QZtHjramdtmqTjP+9XhUhGSNPoUptJqiqdf9iSDZhn9U/tCl0bXKAExmwmaq2FFOTKDPFPAHhC3IBvUvYRVfvt/ZjI1Muua7e88GDt9LlJUYu336B3O4c654JIe6AruPIWgnf7/qkOikMJddTVlIJXoYGytbngvfCJDagcZGN3ue+fDWU5Qo5LrwixiyxHPjLUn1deNNGeMHhikOZxX5cKr+QGiIZPvxLFwbJdeUxdax8CEa3Z00ouhMLnMmt2h5iCw+dFDm62FQczpyNMWUXebrogvq3kF9JFo6ZE1JsgIXZzBHbpCy5BTalyNmdPys6BHnwNAjIs90ABQLqXThrOsShoUPo36eUwOQLlMtO8tJnYkhOZyTuM/xlSGY2299YQx1S265f5/nGNZaDtsHfNPXIOcj2LK3CLQLBs2MLMFCgjqYi9ijyqJXtfJuwycWEBvo8+tFs/96efZ3NNDDjYFvgfNZ/aZYSsU+MUbxIpHs6etiHgjORXbzF2clIOGoOpO+RVCRCXkOW6OK5V0UGCH1+ETOBZexFV0h9+yOhMiJSlwWOxJZ8/uTJfBReIQYu+5vidzO9SxwvWfVjqwyhwq8kpd4LhBY4ZTRqje65OSnGoMIdXp2sOO+ynMoEvlLzzkTGAo/8/jc1aXOCZzny1woLglqhw57Ru7hhXPjFdoPaAt7Tlwwj9Zln6gzD/f7T+GIJph3bGXaLGEHPatPcdkPbPRkBo/e3CqHgErJMQXWgNxqa+9ln9nALfg2OS+PZVPSmPc/kpWJkSB6W+NSO6sGAd1zMnvNeJs4JClXuauUAXPUFDo1wKfECQHxLktUiTyb7I9IEG/QMVqesiMjjen6ps03xrnlyaL+epIXJfcDrKvvJCC2
 rfQpIkpJ
 I4FaLv0+RFg2YYkDaYb8aSm/MJ5TKDspZ16VYlQtBBvtSBGkTQHcGzkuPek8gDDyn1/sAbBqk0fdeAUe78YQQXnut9lm4y0IKkLKTlLDpLYh9YHZzIdDfJmXW+6VqXGsurkdCKhONFmB1GaS+WMiJP4eFmLiKs8naA6M2SZ1b8qXeTS41YLeknZDcpNs4ia1Z78AudptSPsi8oJn8kl+M5ECZHgu/QKnh8Ox3XGdR/BlRZ/asgbfVnMm+yiNPFXhpNtmieL3MiG3H3SUHndM8r2RfOrr3slu9AyKnFJymrerolIEhGWiVGgopbfOYRWsh9vIEVpz1MS3ULdT5oIna36SlAGWeAIntg5qWW7ox84YJmLk1QZ5azpurorYc3uItvtneMFCZY7DBZG1aOoDPGMEBc91/WOnGAV6Zg14UieCDIhGQsU/UcoF4i+U31amPyXCP0X7UXG8FDyOqXvWNhqBp4LCkwQlCpHfe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/9 12:13, Matthew Wilcox (Oracle) wrote:
> Syzbot has found a deadlock (analyzed by Lance Yang):
> 
> 1) Task (5749): Holds folio_lock, then tries to acquire i_mmap_rwsem(read lock).
> 2) Task (5754): Holds i_mmap_rwsem(write lock), then tries to acquire
> folio_lock.
> 
> migrate_pages()
>    -> migrate_hugetlbs()
>      -> unmap_and_move_huge_page()     <- Takes folio_lock!
>        -> remove_migration_ptes()
>          -> __rmap_walk_file()
>            -> i_mmap_lock_read()       <- Waits for i_mmap_rwsem(read lock)!
> 
> hugetlbfs_fallocate()
>    -> hugetlbfs_punch_hole()           <- Takes i_mmap_rwsem(write lock)!
>      -> hugetlbfs_zero_partial_page()
>       -> filemap_lock_hugetlb_folio()
>        -> filemap_lock_folio()
>          -> __filemap_get_folio        <- Waits for folio_lock!
> 
> The migration path is the one taking locks in the wrong order according
> to the documentation at the top of mm/rmap.c.  So expand the scope of the
> existing i_mmap_lock to cover the calls to remove_migration_ptes() too.
> 
> This is (mostly) how it used to be after commit c0d0381ade79.  That was
> removed by 336bf30eb765 for both file & anon hugetlb pages when it should
> only have been removed for anon hugetlb pages.

Cool. Thanks for the fix!

As someone new to hugetlb, learned something about the lock ordering here.

Cheers,
Lance

> 
> Fixes: 336bf30eb765 (hugetlbfs: fix anon huge page migration race)
> Reported-by: syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/all/68e9715a.050a0220.1186a4.000d.GAE@google.com
> Debugged-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: stable@vger.kernel.org
> ---
>   mm/migrate.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 5169f9717f60..4688b9e38cd2 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1458,6 +1458,7 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
>   	int page_was_mapped = 0;
>   	struct anon_vma *anon_vma = NULL;
>   	struct address_space *mapping = NULL;
> +	enum ttu_flags ttu = 0;
>   
>   	if (folio_ref_count(src) == 1) {
>   		/* page was freed from under us. So we are done. */
> @@ -1498,8 +1499,6 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
>   		goto put_anon;
>   
>   	if (folio_mapped(src)) {
> -		enum ttu_flags ttu = 0;
> -
>   		if (!folio_test_anon(src)) {
>   			/*
>   			 * In shared mappings, try_to_unmap could potentially
> @@ -1516,16 +1515,17 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
>   
>   		try_to_migrate(src, ttu);
>   		page_was_mapped = 1;
> -
> -		if (ttu & TTU_RMAP_LOCKED)
> -			i_mmap_unlock_write(mapping);
>   	}
>   
>   	if (!folio_mapped(src))
>   		rc = move_to_new_folio(dst, src, mode);
>   
>   	if (page_was_mapped)
> -		remove_migration_ptes(src, !rc ? dst : src, 0);
> +		remove_migration_ptes(src, !rc ? dst : src,
> +				ttu ? RMP_LOCKED : 0);
> +
> +	if (ttu & TTU_RMAP_LOCKED)
> +		i_mmap_unlock_write(mapping);
>   
>   unlock_put_anon:
>   	folio_unlock(dst);


