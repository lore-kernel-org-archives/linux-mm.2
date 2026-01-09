Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 947DED1A623
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 13:50:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1BA96B0089; Fri,  9 Jan 2026 08:50:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9F556B008A; Fri,  9 Jan 2026 08:50:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C82366B008C; Fri,  9 Jan 2026 08:50:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B6DBA6B0089
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:50:35 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6C6B91AC947
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:50:35 +0000 (UTC)
X-FDA: 84312560430.27.EDBE149
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id A02BD40004
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:50:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PhXFGafi;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767966633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4aTRtHQuHNN1JHplXrPj0SqfdShsMzMRKml5/spVXtU=;
	b=xA3C2Ry6xzvGXGBCX7DvErvkjWOsPLpRdjv4VmkyYI32WaaBbFfuzVoFANfXePWjxcsDcQ
	USU0fvo63D7kHV5934SW4nuqoBCwbv6jzJs5hzae01fKZZecLWbEET8G6vREXvQBEUPF3I
	U2o6MRTcB8RuORSH3Cw3A3fG48M6CSM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PhXFGafi;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767966633; a=rsa-sha256;
	cv=none;
	b=05TjWlaRGBtf5ENSIYjxFE1jIEcqtXgYm3R4+gEuWaxxN1cba+iEmuQQd1l416um33puZg
	mAZJa3m7LHZ/k+cipvU4mHwvPyhE5X+coMT8B0zJk/vE0hTYJ79tGAA30Cjrv1D8nY0tZ+
	yTFgI9zngnGVr+KPr3Cwpr08iMKSzVs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 25B6360122;
	Fri,  9 Jan 2026 13:50:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491ACC19423;
	Fri,  9 Jan 2026 13:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767966632;
	bh=QRvCDtIt9FY0lIy6CkBLbcgCIbaVCMHdCdDA4vRtluk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PhXFGafiwpuu6FCohCNJs5NTLwUgruXRPWdi1r+BOSag3o/2zjDcjir3tAqeIOQfY
	 ZPlZc/WFppmbdrSYB7x0FNnZl8btpy9SdOrSllVm5VmOxrJDgKyvibOMiSEHbu4Uoa
	 FKKL1bFxd5wXQJ1E89u9pI1umuSK1FtQEBIoAAfdfUCFydc02HaSLL2571Y8fmh/s4
	 EX/XAR1F8TmMj87g5aCelA2TV0DQsVXTTpq0Sh8L4Wbci3EY70def56ZIZnqY+PVcI
	 vWFA3JXOIVvuep+7DHQYxpbBSgTTQ/2nPN2sHgdEZBKvaMb0txbyyGxYYVjfQLZ9v2
	 DfmbdTDG3o2jQ==
Message-ID: <509ac447-e5a7-4cba-86b8-e9c0e72fc93c@kernel.org>
Date: Fri, 9 Jan 2026 14:50:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] migrate: Correct lock ordering for hugetlb file
 folios
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Rik van Riel <riel@surriel.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,
 Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
 linux-mm@kvack.org, syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com,
 Lance Yang <lance.yang@linux.dev>, stable@vger.kernel.org
References: <20260109041345.3863089-1-willy@infradead.org>
 <20260109041345.3863089-2-willy@infradead.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260109041345.3863089-2-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yqtu6anjwuuktqbnu1asqrwr79otsf7h
X-Rspamd-Queue-Id: A02BD40004
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1767966633-597936
X-HE-Meta: U2FsdGVkX1/8l3NGT2LWziswulC6XBFPn7PZjmQXxBvywLT4UVN3AaGQmdfPXkbzFsF0WgVFjm837WpfXmyTiFzYHV5Qi6+Is5LeaL5uKYoS6YnkC32ZqAfX8da1b/0XloxMun08BTmUG86wy/QPAS/uK9E9O4Lh/Xyf10glXbfp4Qt9HJhnVTPXn2ucOIyxCfuHH0ZD6C3nnFXawY3FG4/5wv2LHs7OuRxdruazP9L1Su1SOYo7BQOOkj2dkHnoaNf0Klaqu42MjYYNof5on/afl0Ysz5EdV2OqgbLSvB/QRqvQDypCm29/SAiGk3s8Qmv4QaQYeAe8FIJZki0rqsETqIwASPvDI5X+Z+kgeNjVFTbPExQMlt096OHcy9NHk6txFyc7uB8Nq9yXt+WEXjklMakM6f8y20B+0fDegnCF9tcJG13HU3P/mHetK24gsPjefd6NKFkMWYxpmw/hmkir6c2Hy3cskMQXXI6OZX6+C9kimYY/Eer0TkkLmrUo7mDhNAJT2R7y0ZZm8aW7Sr0epkqQjW/klYwdJRppoiwDWzbtOH1En/m/nBScopC5f3HMFChNHqI91iwitfXZhfI2oV804dsaIwcTmuLNW5/An1yVMfAB76G69l4UQe4QouSVFcLCCZbjPVyWY1waLlK9vM8IyQFk5n0+/Kfc0iYJWW2y88OTNvjbYAqyctS6xAYFJ6BymPp5MfPrEuS1YTKlDKRWu2EQOVu258WNmlL2M/pMTyM4BDfORTmh+WfpwKLcU5iEAkcrmHWY8uLjGRjO2yQ/KIejhUHjmA9iVIdwtz5w0SlcyCPJAR3iAnV5mEcBnMGmogap+1eg0/8Y1hCWY9W33P2USdZYF2e2IFPzbzPgQQYFHfsBLhOF7h959BAP6p52BUndSJ8eob40R0dM7IXNKqTYLs1Ps3cOKnw83+qJTPBsGpnl6EncLqWjrTkOhoLDqA9nJYKa1VJ
 QGQwnZhz
 ekYxY2ARU5Yq7XuYw+3ZwuLAoA2Gdm4rEtrjJYjS8OZ24pX1Hh2a8486CTwEzSt1KTVpvpixrcmJ8tXYG1RJSUyDjT3lmJNca4CyIGMWAhc0aKP5mKdR641PlUtufVExZfF1bzW1qTZcv6xgJ2p9MgS38BNmVh/4FNWJRF15WvDLzlK/Net4VqU7d/2uOz1m70uigmwIKrT0qMZPZfLl9VTAtgdEQkzMs7uObN1GVxN7DrafExPX2thLH+VNO8FODifiZhjbQh23ODBNgRmt4LbvKmsGUWIn9lF6bR25bd1JgmCy0yyT2+mlNYFEtnQOB7ROxf5egJsdIhQl6lKI+IwWyx9KmJRtpZfy04M7SKBReHuLnOv/sdRJ3a0meObdBIUMwckoXz4hCccp7Ear1KbNjotyBHpe7tvIFhqSqm91AXG3HxdCs+zagsXbyZA/BOYG3dVhlCSbAS0/ntAuU2jg+i1vzIdo9uz9rfdqGcyTWe0xSxCbk6vKrDObwwZAtOMKhtskT4vo5zuM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/9/26 05:13, Matthew Wilcox (Oracle) wrote:
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


As raised in the other patch I stumbled over first:

We now handle file-backed folios correctly I think. Could we somehow
also be in trouble for anon folios? Because there, we'd still take the
rmap lock after grabbing the folio lock.


> 
> The migration path is the one taking locks in the wrong order according
> to the documentation at the top of mm/rmap.c.  So expand the scope of the
> existing i_mmap_lock to cover the calls to remove_migration_ptes() too.
> 
> This is (mostly) how it used to be after commit c0d0381ade79.  That was
> removed by 336bf30eb765 for both file & anon hugetlb pages when it should
> only have been removed for anon hugetlb pages.
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

	(ttu & TTU_RMAP_LOCKED) ? RMP_LOCKED : 0)

Would be cleaner, but I see how you clean that up in #2. :)

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

