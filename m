Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60F52606A321
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KHG0DSDK
Received: by kanga.kvack.org (Postfix)
	id E3D666B05B9; Mon, 23 Nov 2026 12:27:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEE356B05BE; Mon, 23 Nov 2026 12:27:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D04766B05BF; Mon, 23 Nov 2026 12:27:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7BAF6B05B9
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:27:11 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2913CA8106
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:27:11 +0000 (UTC)
X-FDA: 85467064662.29.38C0A0E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 73405100008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:27:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KHG0DSDK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795454829;
	b=njCZ7n+xJNBsFNbUW032ccmR5rOchEqTQhGcHyl69bDYnxyC0qMIICEOV/t6wtvFwlh0GE
	rTo9G1Biz1PulsTNbKIFRLLQxU3Mzc87xsaAPQnruZKRhfFHWbgW1aUSq4ha+O75KL/kKg
	AkM2pwSa4u1WWf60/cTnwrdReFe5oFU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795454829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rwO0qR/5dA2BfbWBM6Y4o8lfCur4ww/twWJTPGcgLzQ=;
	b=URCDFOcy0kaEn7sImLJmH8/mhqkevn0wnlU+eHmQYrl2gRhlyK8KsTh8MCO1TxP1/nwKJJ
	Ih6kYDxOo3vpwcTDhv3JK3J3a4WU1ts/YsY/298M/PUUONmvdwHzwJM+xn8vF+SGOjnBaP
	FvIjpd7IHYm9pncQR30R3eQmxRHinzI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KHG0DSDK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A69DC44CBC;
	Mon, 23 Nov 2026 17:27:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECDA1F000C0;
	Mon, 23 Nov 2026 17:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795454828;
	bh=rwO0qR/5dA2BfbWBM6Y4o8lfCur4ww/twWJTPGcgLzQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KHG0DSDKmw1s9Nld6eJQBGskQxG8+fGTfS95ZXpiCvzSvsH1WR5GDMuTbP4yuvTqb
	 53THpea6CtIlrN+S8vwrcuVZQbjJTfTwzn15sm4B/NhslGZtmZRvwhi7/PphkfRRgP
	 z4uiJdMAGxS+AsEYtm49AzUp7LCEV2LXBWsuRg9eaoBPyRzuV6Y1Ncx+pJvT1gQW1F
	 +gitMGVoD9V/qvRIdqZHfmk9fmWjQAi5Spjv09gQES9NRAZyFz+N2VxxrT8UpWT9Dj
	 XSQEy+w41yKaJAw7w2hgwyhk6WNnVMGODwVNKEnA02f00qhxSh0HmnV7vYvqrBx8p3
	 5ay1qBdDu4svA==
Date: Mon, 23 Nov 2026 17:26:57 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, William Kucharski <william.kucharski@oracle.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, 
	Joanne Koong <joannelkoong@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, stable@vger.kernel.org, Chris Mason <mason@kernel.org>
Subject: Re: [PATCH 1/2] mm/huge_memory: use NOFS when allocating while
 splitting folios
Message-ID: <awR3IxFld3ms836N@gremlin>
References: <20261122-migrate_reclaim_deadlock-v1-0-83c56185b0fb@kernel.org>
 <20261122-migrate_reclaim_deadlock-v1-1-83c56185b0fb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261122-migrate_reclaim_deadlock-v1-1-83c56185b0fb@kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 73405100008
X-Stat-Signature: d43pbm33bketxzsyi8a1xx5a7f5ixnow
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795454829-408862
X-HE-Meta: U2FsdGVkX19OUDWqkP3Gb8YVzWl+1e4OImeZbA7mhysNUKjO8gX4FvvrteFXDxivdXq7ows6B7w3RHRjrT1QvD7vpnFwUgsnzSTekbOx8y4Fvi+yr1LK16miN75c0uEnb8cv1a9u1IC135D4faSDZU2Mf665uJGp3VD/CFbWd8IgJunc1YdYYO+Xx6/qL2bdde1wWuyQKVvMg1fCkxZAqnnoZOJKyjIULL3meeyZTHVarV3W3Cx2oXQ4r5nelTcQ4xWt1kzVmngStIfsKzQEdwwx0jnaLSAPQKiJuvHz+roCKgzt0O+ihj2KcgID1q0ZG/Kp841pviymucDB2/VjrFFeW0GyaqZKHDBwYrtxDgh/0/5uqWr8PpgbH6LitI/7jIemu/MsbToJVHFcJdkgxndcuIys+9G6/NfeBrAoqneOYcvdrn9RPtdgtb4c6XATx+ha45zA822jeMQxmOqn1e4WNeNUlZiZy95uftVoG5PxyBYyyen/DuzIwgGlGg6EwnwiJIqVYEVOPTIhkajm9AquHzfNUjWfxcl9Qo1YGCEDWXcW3JnvNAaz/YszZGvIGosl42ww+MiFocWK6cgh3u9TpG5GzJRKrCSylxzWnx8lsluSSkp9v0pXXdvjRRxOTNCW1zXICFpJUXl136ZhCMv+/Hal/2L3Aw3vNp/hOf45uLts0VXMstgXNcvxqeqR0jL8zpgH9NIW7Wy70LZyTxOhlsbqhC/P3DQW3OQp9o/5fqgs25j+gtb7CuU7T2dVJOmdj1/a2ICXQn6ZgUHP6xe/UZrUlRn5O2As91XwaZBfwckG2N6v5QSW6xzwBLTaExUXvbYqpq/L61v4mEoKQu8F9iHBptehNIspA4zY5RsHVkSne4UEadpKe7H16J48E/0iu4VUJad50XEtCPQnL2CrN++DR53bbMkrxKxZqsYZQ96RrDjZ+IcCH0YqZBQMYTfQPx2xK43jU4qrU1k
 +Dfayq7H
 QkGBrs3jpiMIT2XroZ5+D54krRexxM3+Dzbzsr89ae5yftsWjZE14+VQEuKXMc7Vn0a6qTTVvAP+0WQbI3yvSIXpGI5resQJXOMLn5D/0jCTx4zPAvlWW+pTerUIunrHqm9SOycnfw+s9yauF5+5vPjhsxW8JCcBCCA9j0qMGoqMSwv/mDByrxlccugU7OGVMNEZ6HiPj9IXMvgKKwgfmMokmsQsRnpRc2lrVZXrZyabdb2dv++yt4nXN9agp1xUdNG9HTjhoTQmHwaWzO+HhjEUarhy2sUfLn3uUwHEuRU4kaLHOgKjJrDWAfruXInf4T6QCOULvh1I86rl2aWgW1cDkLT8tfgm9vu5LGFZ8wl+C/SIui5AjxaWxRuODRkIVyaoLemLevcvSPlQX2ywLpwlRtCnsESj/yxi5e6EF402rxVH88O1tt70K2Ga5/idYiVGYrtf+AYU90cUW6RdnvzRKnNlpxgx7rf5gFIRqy0yRTD1mfS5w5TeqTfRphRvmmszunnxKLVMH8OiF4KL4OVHzlcRnmdOUJwACxnJayj87j8CzbBbAYCj3ImtfZmK+oEdRtCOjBDXS7Z7FnhTNnH5M6VCNuH1K0pkSSlY3/inSeLqHF2dX//3y5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 22, 2026 at 01:42:17PM +0100, David Hildenbrand (Arm) wrote:
> Various callers (migration, memory-failure, s390_wiggle_split_folio) split
> locked folios without holding a reference on the folio's inode.
>
> Splitting a file folio might allocate memory for the xarray and call
> filemap_release_folio(). If either ends up in direct reclaim with
> __GFP_FS, reclaim can evict the inode through the dcache shrinker, and
> wait in truncate_inode_pages_final() for the folio that we hold locked:
>
>     try_split_folio()
>       folio_lock(A)
>       split_folio_to_list(A)
>         xas_split_alloc()
>           try_to_free_pages()
>             super_cache_scan()
>               prune_dcache_sb()
>                 iput_final()
>                   evict()
>                     truncate_inode_pages_final()
>                       folio_lock(A)
>
> This requires that nothing else holds a reference on the inode, and can
> be triggered most easily with FUSE, which evicts inodes on the last
> reference.
>
> Further, xas_split_alloc() charges the XArray nodes to the memcg, and on
> cgroup v1, memcg reclaim waits for file folios under writeback if
> __GFP_FS is set. That can deadlock if writeback waits for a folio lock
> that we hold, for example with ext4.
>
> Let's fix it by splitting folios in a NOFS scope, so callers don't have
> to care. A NOFS scope also covers allocations that filesystems make with
> their own gfp flags, for example in filemap_release_folio().
>
> On NFS, splitting folios with pending writes or ongoing writes to
> fscache might now fail slightly more often, until these writes have
> completed. On netfs, only folios that are being written to fscache are
> affected. All fairly irrelevant.
>
> This has medium urgency.

But medium-rare tests best!

>
> Fixes: 6b24ca4a1a8d ("mm: Use multi-index entries in the page cache")
> Fixes: eef88fe45ac9 ("s390/uv: Split large folios in gmap_make_secure()")
> Fixes: 789763523fb4 ("xarray: honor XA_FLAGS_ACCOUNT in xas_split_alloc()")
> Cc: stable@vger.kernel.org
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/huge_memory.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index e22daf846dbe3..c4f6c642c2620 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4425,11 +4425,20 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  	const bool is_swapcache = folio_test_swapcache(folio);
>  	int old_order = folio_order(folio);
>  	struct folio *new_folio, *next;
> +	unsigned int nofs_flags;
>  	int ret;
>
>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
>
> +	/*
> +	 * We might not hold a reference on a locked folio's inode, but we might
> +	 * allocate memory under the folio lock. Direct reclaim could try
> +	 * evicting the inode, or wait for writeback on cgroup v1, to then

Ahhh. Cgroup v1. Of course.

> +	 * deadlock on folio locks.
> +	 */
> +	nofs_flags = memalloc_nofs_save();
> +
>  	if (folio != page_folio(split_at) || folio != page_folio(lock_at)) {
>  		ret = -EINVAL;
>  		goto out;
> @@ -4478,6 +4487,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  	if (is_pmd_order(old_order))
>  		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
>  	count_mthp_stat(old_order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAILED);
> +	memalloc_nofs_restore(nofs_flags);
>  	return ret;
>  }
>
>
> --
> 2.56.1
>

--
Cheers, Lorenzo

