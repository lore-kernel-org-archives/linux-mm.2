Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D10D606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 02:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XSSbJoaB
Received: by kanga.kvack.org (Postfix)
	id A08BF6B0B80; Fri, 23 Oct 2026 22:46:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B99D6B0B83; Fri, 23 Oct 2026 22:46:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D5F66B0B85; Fri, 23 Oct 2026 22:46:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 64C186B0B80
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 22:46:39 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9EC2B1C33A9
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 02:46:38 +0000 (UTC)
X-FDA: 85355981676.26.C395E02
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 011C0A0009
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 02:46:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XSSbJoaB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792809997;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=il4r3ot3r8yPAmWBcdLW7uTmjL1df7/yIKDl8nkIgx8=;
	b=st5CLBSnDAt0Ub+LoHNM+OULj2CX0lqbPMFHer1oF6BKRL7PLd7tneOkUbjCWQ4pMcV87I
	OA8xTMZZGabRgxmSSoSeeGBITmu9d/7frsIBKefn3KNFG1ND557HjxPjcGRmFDPSi8RJkH
	L9zYVu2R3r0sgAQDU5TROvB5wCq1ItU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XSSbJoaB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792809997;
	b=tzIzEwktUToVfj79AE1+uXJqmiMBKeEIZzoevbG5XNYUG4YY4jVj/namBEUdmc9pK5i+Ff
	DBGQx8cpfv9jKhAXUVStoFjmZtb5Jl7QFLPsKASH4ZRBor0xJbXvKkU3kMckWfBCqNN/VB
	F06+m437lEftkTeDNMA+GlQzrpmqF08=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E5554393E;
	Sat, 24 Oct 2026 02:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 668D01F01825;
	Sat, 24 Oct 2026 02:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792809996;
	bh=il4r3ot3r8yPAmWBcdLW7uTmjL1df7/yIKDl8nkIgx8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XSSbJoaB7cYyHF22n4lIRuaboK528R11x+L85VjckYvT9PuLewmGPKRX/DSwF4yqZ
	 sr/hHlX+wvhUtBSGxaFbrR58jYC32gb08yKQh8QNmVpjf7zmB1dotOqF+MK0hRoEpy
	 NWZEEpIEC/he56CWWWI7FUMfOX2F1ADbRSyECoHi+B+tMMjps9k3HTT9416aiCifxI
	 XxVzjJaVMQbywX0EbvYZIEMfFlZlQ/aFC9YGX0aYDxjWbuiI12z7AxVt4ijmy2AGyI
	 8mA0jyZiQZloTALHZ+3Q/IgJy9lpZ5e3h+9kwm/HyjYJcPZzSfWQFBtfaal+mG4m42
	 34NQmiDvUB/Pw==
Message-ID: <sashiko-outbox-183519@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 2/7] mm: take a folio off WB_DONTCACHE_DIRTY only if
 it was counted there
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mike Snitzer" <snitzer@kernel.org>, "Chuck Lever" <cel@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>
Cc: NeilBrown <neil@brown.name>, "Olga Kornievskaia" <okorniev@redhat.com>, "Dai
 Ngo" <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>, "Christoph
 Hellwig" <hch@lst.de>, "Jens Axboe" <axboe@kernel.dk>, "Matthew Wilcox" <willy@infradead.org>, "Jonathan
 Corbet" <corbet@lwn.net>, linux-mm@kvack.org, "Anna Schumaker" <anna@kernel.org>
In-Reply-To: <20261023024548.71123-3-snitzer@kernel.org>
References: <20261023024548.71123-1-snitzer@kernel.org>
 <20261023024548.71123-3-snitzer@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 24 Oct 2026 02:46:34 +0000
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 011C0A0009
X-Stat-Signature: kxxus3mjsigx3ku9qafkpnu5h1ka5rwh
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792809996-468480
X-HE-Meta: U2FsdGVkX19vjdkYfG+Fqogkmu+uzExVcSSBPkyrGNOY1u8HZB1DxhMHaJJT71adj7bWVQKAkUg3E4lAFTR/REd45/JL/Hwv8qCntfnkd5BP2nS5Gsic/a7W9eP+E3rUbY/LkWNqkW7neYPRTde15H4Fqg28Kbq6bVP+VUx5yUhyO2uY7cEpSr2HpCroor4nP6hmR8+xHwYzvp55D6HNCTZOLYTBPmJNp67TPrZd9n8AgAHf6PiKqzkOQAvb0C2lXMO848D/JG2hwU3zGNbmu2WAantfxlk5TKXMtQFl9mqfxoLAzUZNRCWfwqndxq595dl0j0q/NExhs+C6hJwbOOu5WFXA1E1kHzW7PAP/xtQoy63BK4MVBK2N4xOOaJDlGMv3HKdSahkKKkZPsQXJkdNaHdLYWvsMt4YhOkRrCytNT5CVbPgBoiIDH7tMElm7wik+dwDvhyAzPWZODQxsmR5bI/8gH5CbEKhy/g8D3vvfK9ADNr+UfFmU6XQsy77pIyAtKZYb4uPF79Pwqi703QekUN0jPX+j6XleSQRP+1VeMhIEhypx3lz+vE17Eqv+9r3t3CTRXP1qG3fFGTqAXxFNoFDXwdPOMJ2gshYd0LL5zEw6t0sufxvcEmdn4T9NOnTwNXcMiqyEIGU6sEo27V7ra6MzltlHu8bHTKl/mBPx/tK5G/9QNSYtVE2w0OmsYx2dpELYr8iCFxyE8zAo2jpQPAxadFVNkwlzNLyRlvEDtJuLhJMuqQzpGiDPv+OgyyuCV4zw6PrSGeeh73fVu1H28MFZBHrHKVUxDWuXcUh2Hi/4J7R9BNqlO3tqIz2pJ2ykmxBv4TTXFUWKeW7lQ+MLvabOz+Ee6bKgC0drj/IWtdgJgopFmC38szjcZkqBvdzp/8e20rU2fRR7SDVeFBKfhNZOS0gEc73hnh7Ekcn+42SXu+DG6QRWC/sgUZ7gWdSzp9UGb2I1g5pOhLg
 1gBEN0ho
 4SkSPVByMCgjb+l6sbW5WaAWU3DUVjuOI9mufR02ZjXfyY/8KV2PvL7vFgQjqH26JeBGTZe4xaJfocj4Q4GyXzYbvLppUZYwdpo4eizUbcqYPmAvH/KabiBQObjnJMV0QiIdBK5h+9spOsmZPIJxOgSADlZjsufU2QfcmNMTNY7MRrylJZTCS11SYbg2QczDLe70qSbshE+e96paerP2Iltms8x08teDIyoh0Y1eOKYAUj1vvs4O/hAj6PoCpS0C4lb9SIpHYbcHb/kUfT0VzNWh1Z4J4n7LIiOWhLb2cx7Km7axho7c7NPIH1X3SPXLu9lQmdbTU0z+jcpFFJEwEQqGTMyyqu62g0tfvlCRdnU0AGblLk+S6hEQcGFtBh2vP1MJwrWoIeL10PQuSxPPLyaq1GMfytKu/Jy7aeoZdH75PFm+ajusFnnTEvxdMXclJIVlDXKZpp38SoYVtWggfuX9+FrYvJsXqNObhBaKcOv92xayVHsXCbGjDIh3qhPY8MKWf03Xw/z5ytpYOzGAYYm8LwgBUASLUSEUQgvV0J+nY8fr+AYdQA7cY2RQQaL7DYDHOOP1WBBPevvgPn2z5R3YW9Jw2naGVrs4CAzEio5wafH9x/9SgxzGvipunoWBUZjgnkgSSw0gddfuKaIH1SkgfGaEChfhAywPxx+0kHlipxjDOoycsDzCiT0/I85bF1ZfaXOZUQ75bTBshpm+c912t8PFEsbA6U6LK6jOW6rctICk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm: double-decrement of WB_DONTCACHE_DIRTY in filemap_clear_drop=
behind()
--

commit 4fb0b9f6bc322dc01cdee84f7076d22537c5bd27
Author: Mike Snitzer <snitzer@kernel.org>

mm: take a folio off WB_DONTCACHE_DIRTY only if it was counted there

This commit introduces filemap_clear_dropbehind() to clear PG_dropbehind
and decrement WB_DONTCACHE_DIRTY under the folio lock and i_pages lock
when a cached lookup without FGP_DONTCACHE finds a dropbehind folio.

> diff --git a/mm/filemap.c b/mm/filemap.c
> index 00fd89cf6f550..1cc28224d547a 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1927,6 +1927,45 @@ void *filemap_get_entry(struct address_space *mapp=
ing, pgoff_t index)
>  	return folio;
>  }
> =20
> +/*
> + * Clear the uncached flag of a folio a cached lookup found, and take the
> + * folio off WB_DONTCACHE_DIRTY if it is counted there.
> + *
> + * folio_account_dirtied() counts a dropbehind folio under the i_pages l=
ock,
> + * in the section that sets its dirty tag, after PG_dirty has been set
> + * without the folio lock, and every path that uncounts a dirty folio ho=
lds
> + * the folio lock.  So with the folio locked and the i_pages lock held, =
the
> + * dirty tag, not PG_dirty, says whether the folio is counted: a dirtier=
 past
> + * folio_test_set_dirty() but not yet counting finds the flag clear and =
does
> + * not count it.  A folio another task has locked keeps the flag, as it
> + * would have had this lookup not run.
> + */
> +static void filemap_clear_dropbehind(struct address_space *mapping,
> +				     struct folio *folio, bool locked)
> +{
> +	unsigned long flags;
> +
> +	if (!locked) {
> +		if (!folio_trylock(folio))
> +			return;
> +		if (unlikely(folio->mapping !=3D mapping))
> +			goto out;
> +	}
> +	if (!mapping_can_writeback(mapping)) {
> +		folio_clear_dropbehind(folio);
> +		goto out;
> +	}
> +	xa_lock_irqsave(&mapping->i_pages, flags);
> +	if (folio_test_clear_dropbehind(folio) &&
> +	    xa_get_mark(&mapping->i_pages, folio->index, PAGECACHE_TAG_DIRTY))
> +		wb_stat_mod(inode_to_wb(mapping->host), WB_DONTCACHE_DIRTY,
> +			    -folio_nr_pages(folio));
> +	xa_unlock_irqrestore(&mapping->i_pages, flags);

[Severity: Medium]
Can testing only PAGECACHE_TAG_DIRTY without folio_test_dirty(folio) in
filemap_clear_dropbehind() decrement WB_DONTCACHE_DIRTY a second time for
a folio that was already uncounted?

In fs/fs-writeback.c:inode_do_switch_wbs(), the PAGECACHE_TAG_DIRTY walk
checks folio_test_dirty(folio) before moving WB_RECLAIMABLE and
WB_DONTCACHE_DIRTY because PAGECACHE_TAG_DIRTY remains set in
mapping->i_pages after several paths clear PG_dirty and uncount the folio:

	xas_for_each_marked(&xas, folio, ULONG_MAX, PAGECACHE_TAG_DIRTY) {
		if (folio_test_dirty(folio)) {
			long nr =3D folio_nr_pages(folio);
			wb_stat_mod(old_wb, WB_RECLAIMABLE, -nr);
			wb_stat_mod(new_wb, WB_RECLAIMABLE, nr);
			if (folio_test_dropbehind(folio)) {
				wb_stat_mod(old_wb, WB_DONTCACHE_DIRTY, -nr);
				wb_stat_mod(new_wb, WB_DONTCACHE_DIRTY, nr);
			}
		}
	}

For example, during writeback,
writeback_iter()->writeback_get_folio()->folio_prepare_writeback() calls
folio_clear_dirty_for_io(), which clears PG_dirty and subtracts the folio
from WB_DONTCACHE_DIRTY while leaving PAGECACHE_TAG_DIRTY set in
mapping->i_pages (normally cleared later by folio_start_writeback()):

mm/page-writeback.c:folio_clear_dirty_for_io() {
	...
	if (folio_test_clear_dirty(folio)) {
		long nr =3D folio_nr_pages(folio);
		lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
		if (folio_test_dropbehind(folio))
			wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
	...
}

If writeback races with truncate_setsize() lowering i_size, writeback
handlers such as iomap_writepages()->iomap_writeback_folio() see that the
folio is at or past i_size via iomap_writeback_handle_eof() and return
early without calling folio_start_writeback(). The folio is then unlocked
in mapping->i_pages with PG_dirty clear, PG_dropbehind still set, and
PAGECACHE_TAG_DIRTY still set. When truncate_inode_pages_range() or
another non-FGP_DONTCACHE caller subsequently looks up the folio via
__filemap_get_folio_mpol(), filemap_clear_dropbehind() will see
PAGECACHE_TAG_DIRTY set and subtract the folio from WB_DONTCACHE_DIRTY a
second time.

Similarly, mm/page-writeback.c:__folio_cancel_dirty() clears PG_dirty and
calls folio_account_cleaned(), subtracting WB_DONTCACHE_DIRTY without
clearing PAGECACHE_TAG_DIRTY or PG_dropbehind:

mm/page-writeback.c:__folio_cancel_dirty() {
	if (mapping_can_writeback(mapping)) {
		...
		if (folio_test_clear_dirty(folio))
			folio_account_cleaned(folio, wb);
		...
	} else {
		folio_clear_dirty(folio);
	}
}

When folio_cancel_dirty() is called on a folio that stays in the page
cache (for instance via filemap_release_folio()->try_to_free_buffers()
when reclaim or migration fails to remove the folio, or during partial
folio invalidation), PAGECACHE_TAG_DIRTY remains set on the clean
dropbehind folio. Furthermore, if such a folio with a lingering
PAGECACHE_TAG_DIRTY mark is later dirtied without the folio lock via
filemap_dirty_folio(), both PG_dirty and PAGECACHE_TAG_DIRTY are set
before __folio_mark_dirty() takes the i_pages lock to call
folio_account_dirtied().

Should filemap_clear_dropbehind() also require folio_test_dirty(folio), or
should paths that clear PG_dirty and uncount WB_DONTCACHE_DIRTY without
starting writeback also clear PAGECACHE_TAG_DIRTY (or PG_dropbehind)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023024548.7112=
3-1-snitzer@kernel.org?part=3D2

