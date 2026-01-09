Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82828D232CE
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 02:17:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D90136B0005; Thu,  8 Jan 2026 21:17:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3E386B0089; Thu,  8 Jan 2026 21:17:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1F696B008A; Thu,  8 Jan 2026 21:17:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B0F556B0005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 21:17:27 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5AA2713A9A2
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 02:17:27 +0000 (UTC)
X-FDA: 84310813734.05.236FE7D
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7800540004
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 02:17:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cPCxGldf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767925045; a=rsa-sha256;
	cv=none;
	b=hn+PoVPQpqXRXxsDoDB7T122Tm7Yl+HdH0v2osEqd+GCcAPegW15oXx401+Sd/EXcJZlTE
	2Lp3XGC69jya6+RsWKq6YHp6gzZ9KMk4o3iDVni4dkVd9WbcNyf3rQ+gqtqrUFR9ExIPZG
	lUnGy/TXu/pcALzZZjpTPIPBrj5kYAQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cPCxGldf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767925045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PwRw5BMh44S+CRA0S+aM2X056BQ3MKgakAszDLhEDMA=;
	b=iB0wzVtjvLP2jn5blNCWJCQCAuhUxx3pyYbWJbTvzwZ5ZJ0AkLqGFnY7cNP9zvX0tD5h2w
	3LJehtv2hqbX7kXvENMCwXvo0L8TzzcOjDCnB1K8bUkcmTC+gXtauAQqiEkOPjrcuFhCQE
	RKkrvMhX+38IISKtKc0YHzIJw/h4EX4=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7b7828bf7bcso2718700b3a.2
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 18:17:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767925044; x=1768529844; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PwRw5BMh44S+CRA0S+aM2X056BQ3MKgakAszDLhEDMA=;
        b=cPCxGldfY7rafVQitKFOW0nT/vKILJN5YIqnyLRfa8h3a7qQMpQbDGXDUZrd+4Yg2i
         aaOw06Y4Mfpy08i/X0QQdPP7tysWkF6LS3htfu4fyySsL9NF2kpnAyvVup/+Pzd8IJcc
         zqaZqmKLyql7RMtOASPtrQfY61A9UC29L0bAWw1ZA8bvughQDsd10wRbhV9dOtJmzxxr
         Y53JhFuUvNU5S48nE9K8rIn5XHWw/MSFCaX4Q1WBUKo9iI5O/Qpt54ReBlWHEjazJRK+
         HPqjvbEuyCUt/moMVu3XgYxUREWlJ9SagLj52G5tshsuYzdgWFuRZNA7oyG0BUdewrEJ
         YAHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767925044; x=1768529844;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PwRw5BMh44S+CRA0S+aM2X056BQ3MKgakAszDLhEDMA=;
        b=H5nAf7qnWdg25JwiyHA3q5JrBrP3bn2MXvxTzkEdw2HXQcGvDr2rvFmp94fWGDP4G0
         9sNyeOL9mEIhGYrp2VzZf7f5HNK7PCdAPJYPfXEtekumv1TjXQKhKJ2nWCbNgzmf9dHz
         1fKL/rVXHMHAa/2VtqI82odKJKT2vW8YgGGlHaTzJEEvYn15nJTHuCnBtFQpcZNdqJSn
         SkxlYCJ2yoPpxq2gAIe5cANZHDHirAcW7XaTRnFxzLWL2gHo1tNRWhqJYvF8NbjxVhsl
         4eIk0n9GAWzxC68KEwDZPJdKDM+0PW/UVrf0UztEvC2tNCWzsM5r7jouvGbTBycs74/P
         vrJg==
X-Forwarded-Encrypted: i=1; AJvYcCX5SVfAbvE9O+gkF+vVq46Yz8txgVx/v+loKTkT+fkILBjyCJqCv5A4cgkRbASZ1aGGAq1hSXySMQ==@kvack.org
X-Gm-Message-State: AOJu0Yzphp3g1WQ8ChEup3c1/UqLre/93yMy0mFwzG2bkWyBSvPcL0FI
	TGQlX2ZkZA2JB29fy6RJbQkDB9GyNucCDI4PgG4W2Kah5xUAlr5vqINN
X-Gm-Gg: AY/fxX4+XksnWLApDWN/oNc0UwZfoHcbS/LFvPRphDKqECLVtbwuhllhJkyperUov7m
	QC+HFvB/6l3rKUZ97lmlFOGkkfcXu6kk16ZlIE6sFFwFJL/MkMh+csPz6Dw9zBaqEPnlv9e17xH
	RZfDMgM6Qxca9dFIPELsoyFUqk80oBRQexCzh4f4hipoHgDzj/JTSlI/chZTiHvAQfBpWWTWLu5
	8BYtocAU50ZSp55FZwslHV7S43/YA1Ffk5rylvnUAs5k3ymyNUAFX09NhaCXOpdTi7BVQ9wx3tT
	aAaRJ/EeeJMfzFOOaBKUhQAkpmFA8vKk5M54bIWwJU5zxeIARj+iswbeGyQAazetpMc3w7m83Dd
	mpKM6egFOy8eUS/0yDdRpJYaeK/uaVnV6wfmBLvaZGvb+Ioc0XSu3TGjwTiGL3J0NkDv8mxPP+B
	dBUAQ=
X-Google-Smtp-Source: AGHT+IGy2Z6iLGjL3DNp/CTf0kZT8VLqMc/3PkmnlEsgK70K/KkuQcvlpg+/MgjiWVU0E9PF5h/8+A==
X-Received: by 2002:a05:6a20:244a:b0:35b:b97f:7bd2 with SMTP id adf61e73a8af0-3898f8f5711mr7503947637.10.1767925044125;
        Thu, 08 Jan 2026 18:17:24 -0800 (PST)
Received: from localhost ([2a12:a304:100::205b])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c4cbf28ebe4sm9133374a12.4.2026.01.08.18.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 18:17:23 -0800 (PST)
Date: Fri, 9 Jan 2026 10:17:19 +0800
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com,
	Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH 2/2] Fix an AB-BA deadlock in hugetlbfs_punch_hole()
 involving page migration.
Message-ID: <aWBlFhsivdK1rLTu@ndev>
References: <20260108123957.1123502-1-wangjinchao600@gmail.com>
 <20260108123957.1123502-2-wangjinchao600@gmail.com>
 <aV-6j97kTobFdYwE@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aV-6j97kTobFdYwE@casper.infradead.org>
X-Rspam-User: 
X-Stat-Signature: arpehpbfwfhchibuxwjztc1ud4aqq17q
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7800540004
X-HE-Tag: 1767925045-494424
X-HE-Meta: U2FsdGVkX19dRzXXCYx/QGyBpjoPpTvL8Lxra2te7vsy73DasQM/bq0UKeZN+tz4z5Q73uq/jxDeObHLtI/+Xr4VW7Lwn5CLWCsZD54CrIDFalBCy81Hb0oRulv+LxNwaPRPe8e3yoZtCQR9FfvRfLg944i3rvlPVKqRKDri1KLy+RXG3xGswTTtqe2knQAWBE6q4b6/V1qQ4RC5zGTpMdm0e923T7ktAPPx6eACGkjjBNPknzCozFzpQcsYYn9zivpkNhB3TioKCCeJY0dZKuKVBqaD0Pufc7CFD0WBTX+0UnbiCdRy1AcPnBC7zdxroGCBcr8bjwaUZgNqFfJqK9EtoRBTR/Gz18G/QImrfXD7iKyzyrVjQw8dnzeXH89WRwKAKCgevStXVla917YTPunU9W+avC0Fw5nCEtCXW2A+Ia7/5vMkXuCmyBnaWacyD8QzzPhbuCFFMyeAbEDbIxCIQ9VcHQG5bdw/9N476rCVa4IdyUX8iDvmC/F6ZI3HmNevSusQhiRk1yvh777m2n6OiKG5+HUXqtd7/qJ2j8GVwAtMlX0v3HZ+j4XogYhf0xxZWeCXqlPW0j3OxL0WmMkN47P6+PHsMxOP0eKbiXhc44JQJ3IH8W3icHpqk9PHImRseFQxLo68X/Wsi1bslUcHKbBBVlU7PIoarQ10ioCVKREe8c2uLPOBkJOQP9LONK8vZ5zd1nvAur5EPVL5ISrNvKZrjsKjJXTC1h7pFDdLbqdeq7pfb+qAl0MqgsG9j7LhFg66pssVrjotRWeW+oVddTRvrC9ZED6iiROytDKCryrA6m4t44FRLxRGcHhETGijBaOJdlVJM8tDv7GSoHMxCHM/seRcul0NBh1atFFMSjm0Thz1OYZQNvSKJSWSW7TxpEq4zB6J7947TZI599OiqCwdo4Cbn8X3qWL+j7rJWpbreglqbg/l/Vp5ghfevw2RkIRdj0VCkNKvftv
 63GFWmGI
 GCt11ndudUTNTV57p45xug81b9ZQfOWlNLrB7fo83E9a9diMr48DooWfqML3CQbWlMFY3uTLGTT+X6XSLSS0nUZGR5zj1hlpjTEY6eBANMkeXObWlxfKsVcdOuVjO93Qziv3xBBwKjSkFVV3JowO7t/iaqJFqCMoD9HzpSUb+95atd7cUq9UOeu5XTr5LehQSXfmJINvDHcyIgTpQRqaV9OElhVZ2jpCnkhBpjShkJy80dUnMXuPL0YbZQJX92o20jWV5xlkMiljFBwEujqA1TTIhXh9HScEC+0n9EcJHIaYR/p/sOCTHsmFCOLVqa1WPfcgPAifvNzJWV7GnplLEHNShkEuE7aY8cqJgqlOK9sdYeI/KJrA8AmDxB2gLKoGUurddNyy6TfVttAqCxmCuhdycMdp8KezWg9DebkIIwh29RjDrMWsYuGtPBCAH4UpnADlshXXKg0FY9BsXYSykaONaWdqCAqBmwop2Vam054M7fHt8A/v+cjq/iVrnH1oqnu+zzlX7tUD14Bc3z2fAI/P8WGHS7IdCBJGIlt+FNQm/ZDTTVExRb14w6zJsB52UxLRNdv4qevssUwqqw25qiLuytAjeyrulpLcGs9Nz7Q9Q9xtKRYowzdRsLW5GRvw8il90fOv+8vPAUyQ0XID6GkAWXQUNtQBSVSQJFxEF+QH2pJDjWAIGI/IHtA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026 at 02:09:19PM +0000, Matthew Wilcox wrote:
> On Thu, Jan 08, 2026 at 08:39:25PM +0800, Jinchao Wang wrote:
> > The deadlock occurs due to the following lock ordering:
> > 
> > Task A (punch_hole):             Task B (migration):
> > --------------------             -------------------
> > 1. i_mmap_lock_write(mapping)    1. folio_lock(folio)
> > 2. folio_lock(folio)             2. i_mmap_lock_read(mapping)
> >    (blocks waiting for B)           (blocks waiting for A)
> > 
> > Task A is blocked in the punch-hole path:
> >   hugetlbfs_fallocate
> >     hugetlbfs_punch_hole
> >       hugetlbfs_zero_partial_page
> >         filemap_lock_hugetlb_folio
> >           filemap_lock_folio
> >             __filemap_get_folio
> >               folio_lock
> > 
> > Task B is blocked in the migration path:
> >   migrate_pages
> >     migrate_hugetlbs
> >       unmap_and_move_huge_page
> >         remove_migration_ptes
> >           __rmap_walk_file
> >             i_mmap_lock_read
> > 
> > To break this circular dependency, use filemap_lock_folio_nowait() in
> > the punch-hole path. If the folio is already locked, Task A drops the
> > i_mmap_rwsem and retries. This allows Task B to finish its rmap walk
> > and release the folio lock.
> 
> It looks like you didn't read the lock ordering at the top of mm/rmap.c
> carefully enough:
> 
>  * hugetlbfs PageHuge() take locks in this order:
>  *   hugetlb_fault_mutex (hugetlbfs specific page fault mutex)
>  *     vma_lock (hugetlb specific lock for pmd_sharing)
>  *       mapping->i_mmap_rwsem (also used for hugetlb pmd sharing)
>  *         folio_lock
> 
Thanks for the correction, Matthew.

> So page migration is the one taking locks in the wrong order, not
> holepunch.  Maybe something like this instead?
> 
I will test your suggested change and resend the fix.

> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 5169f9717f60..4688b9e38cd2 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1458,6 +1458,7 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
>  	int page_was_mapped = 0;
>  	struct anon_vma *anon_vma = NULL;
>  	struct address_space *mapping = NULL;
> +	enum ttu_flags ttu = 0;
>  
>  	if (folio_ref_count(src) == 1) {
>  		/* page was freed from under us. So we are done. */
> @@ -1498,8 +1499,6 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
>  		goto put_anon;
>  
>  	if (folio_mapped(src)) {
> -		enum ttu_flags ttu = 0;
> -
>  		if (!folio_test_anon(src)) {
>  			/*
>  			 * In shared mappings, try_to_unmap could potentially
> @@ -1516,16 +1515,17 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
>  
>  		try_to_migrate(src, ttu);
>  		page_was_mapped = 1;
> -
> -		if (ttu & TTU_RMAP_LOCKED)
> -			i_mmap_unlock_write(mapping);
>  	}
>  
>  	if (!folio_mapped(src))
>  		rc = move_to_new_folio(dst, src, mode);
>  
>  	if (page_was_mapped)
> -		remove_migration_ptes(src, !rc ? dst : src, 0);
> +		remove_migration_ptes(src, !rc ? dst : src,
> +				ttu ? RMP_LOCKED : 0);
> +
> +	if (ttu & TTU_RMAP_LOCKED)
> +		i_mmap_unlock_write(mapping);
>  
>  unlock_put_anon:
>  	folio_unlock(dst);

