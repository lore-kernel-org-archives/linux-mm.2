Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31E5A606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 02:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QHg4dvvu
Received: by kanga.kvack.org (Postfix)
	id 28DCB6B0B85; Fri, 23 Oct 2026 22:46:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23EF86B0B87; Fri, 23 Oct 2026 22:46:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 155496B0B88; Fri, 23 Oct 2026 22:46:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C6EF26B0B85
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 22:46:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B4CA11202EE
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 02:46:40 +0000 (UTC)
X-FDA: 85355981760.21.24E32AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0CF411C0007
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 02:46:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QHg4dvvu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792809999;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ErIIUOv+5Ee7X9ERzS3ZEFRvsCNqx8X3HF1eQyws1qY=;
	b=mWJA3APQSlEmKLPaek66lasyqPS3NkgA+EK/Sg6sFiPdWWJCrujOOIjU4LXc6KfYbVmd/L
	eJnswuXpTc1V2dBtJmZWuVydE496H18+FtgH3wu7EY8qSS00Zb3W/heUnl1CnA2x+7J+FN
	71Vs9G03bjkavsHZT2LPXqZfo97m3bs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QHg4dvvu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792809999;
	b=iAGV9Nez2TpUepco4Qcmo37GMtq4S90uernxpaqr0766oPXZPWMfNZJ32nR7b62wLOzIz2
	eeiLx8Xka2SalqMu352E4+A06vHxqHjf//4T28phnHSJlX0Vg/FfCpA2KyZ6NvezrJz2JS
	5mv3CJcDlSKOFG48SEof9f6eevxwYe8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4ED2F43640;
	Sat, 24 Oct 2026 02:46:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43AE1F01825;
	Sat, 24 Oct 2026 02:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792809998;
	bh=ErIIUOv+5Ee7X9ERzS3ZEFRvsCNqx8X3HF1eQyws1qY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QHg4dvvutSUUkVCGU3Xllvl65SAtLa9o4D2jBYlYjI2UXtj75tNQR39N8XIE2b1cl
	 UgIR8dUC2yM/u46k9OyzLv6h7fyoD5IuQthMXP0aac7lRUYOZBIaeyhCbYtHDWOvCG
	 LBxP7I0HBXUF330haIT80kSLI/IctbPROMxcObq3WXHxt86xMrQjCK5BRSVUwBcFm6
	 dGDoKFesZF8xpbpqiRtyR78ZjPVXvwlDQIgeC06UnhirmpsCILfEf8YTNajdePeDLx
	 MWA+QbXNzreMuSqkPNUxpU2pmQYaAg2q6s4QDX7qXz6oBX7YEgBRcyViZ5ry785iNL
	 Fy/Cm/ywaQVJQ==
Message-ID: <sashiko-outbox-183522@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 5/7] mm, iomap: keep a partly covered page until an
 uncached write completes it
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mike Snitzer" <snitzer@kernel.org>, "Chuck Lever" <cel@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>
Cc: NeilBrown <neil@brown.name>, "Olga Kornievskaia" <okorniev@redhat.com>, "Dai
 Ngo" <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>, "Christoph
 Hellwig" <hch@lst.de>, "Jens Axboe" <axboe@kernel.dk>, "Matthew Wilcox" <willy@infradead.org>, "Jonathan
 Corbet" <corbet@lwn.net>, linux-mm@kvack.org, "Anna Schumaker" <anna@kernel.org>
In-Reply-To: <20261023024548.71123-6-snitzer@kernel.org>
References: <20261023024548.71123-1-snitzer@kernel.org>
 <20261023024548.71123-6-snitzer@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 24 Oct 2026 02:46:37 +0000
X-Rspamd-Queue-Id: 0CF411C0007
X-Stat-Signature: zxenftaig843u7z4yr3t1mzrxdna1brs
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792809998-203126
X-HE-Meta: U2FsdGVkX1/53fgZv6yRKeS29T2A/fMJUUUvQqlPrTCYEP9Wb9lt41RPa9EJasS2I090l7K8vdZbccghI+sG0gdXpdP5QoiWwm6CLjk3meR/UrFfE3wcfPzph/hso8OIG+Ub7dO5O++nIcfJz6LVKtxT/IgF0dCQlvLwj1ERessPgTnmEGZy9zVotiWrU0bX4wqegPEsu5YtCLVllJatVlF2qSHW0j+RL4gNWxR6Hh8s2+rmXK3FkGX74e5j5ijeXeJZJtQRrUZc85DLjJxHQS30rMn7U6jzFHr+vKBzbrg60pgLelyOrs+M4tYno0bmxl6Rwvngfxqd6hfdIYmRoETi/0kPPTZX/dRQ1aV7BMpLvtwfX6+GCcWSJolW3LsbuWbw9/JjfWxGRgmSX86yvCPXTcVG5es9SyPE1kUmebQJLEjO02YOhHwJJWj/xmV+AzBIgFTfzrAigx2GTey1XDynHqtGj1xcRmUDGXYcBjNR18CgOhWmqEum4uDJEY4NDOjE8D7A8+DAJnqtKbpISXRCanIyB9YZdixOC1P/JR0fLQfm5w6TMRGC+7PlFeckviNciWMWyeaXcLJpmnz/e+aVK18FtA/jgIgOwmcjP3Py8LJTk8+kfug1aVy0fshnJZNiZ3+8VdZndltRgW5sylL3j6Ag1HkrrmEAvUDp6uGlqpYY0UQrlPzVN2YR2MHIbaimkQ4w9zULIVOTWgbd2g1Kd3QUCKfFw4CIhXtc0Gr6eF32HaeUEa5B1nybggMOqyu6Hr3NHQ/5rwWFhx399U/Lv+9YADeuB6PSAfE27jqPKubxqphe8KHQLZOSOsMBzDdd5/dlveHgdlGPGaGY/C7xQjFgKPicYmg7aU3yFLrxy1XloSLg4X3UtCsx7meccd3uk2SV+3bQ3MT73874K5BhVL2cdkdnGVVZNiPKmWC0osd1UpndXe8bHUOD3UM6wmRno/Gn69zwHEqR6wA
 aoA3T4lH
 m85Uk+Ip4o19iRYJDWRf0Fjh+MAAsA80e7ZDpkEcLJzAKPy96jwLE9CGbJRkmn3/7e5yAqCFPpi8jK8MY4ZXIUqqfXf4pGmaCta/0tKVNhZDrgySe+4iPsw+7cudSEFdnTmJshsKJvN2mqRbBshdenXYtHFVibMb4lrQpLjP7+ZnJX7L07jWxm2hAuZk8zZI97v8a3fKdU4RgwFLhndrfAi0BxnWAg6EeXKNOn1yX/X7DPDU3TMKo/w11opOX3b+94TRMppPt3J/A48QWjnuchh18TYtIv/8Itc94OUrEG/NIWzW9aVbRE97pECQtKtfaBHpakj7rPtfrB5EqTGq9e0Tspg0QGBF542atx5hk9sC3aefgXTpGwJBWG9hTaMHOXczeG/e0WHZs1TzFQYovEQf7KsI+XehvPxPjGnri/KbL0l/jjPYqjjfywdhwUPLAwn0+L7zwr8yGwQMXqB0gKhccSQ6WblGOfaJ3xJz6SlNVU1XSMgY6aXb3zPYcGID2z5vVZwpM5TAsj9ofOVCLYKTLUUMY184rStg39Br4I8NEmZEQ5kmk0ntWJ4nMFXMeKWufVs79umD/JzW7VJe35YQuh7H3aRGmjhpxwGrdEAKpg5G8Kid0UU8J6x4FMXW+MQazD+GRUGpHoVwx6+eKQyaeCw3QtJqZsnSo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] mm, iomap: missing dropbehind in __filemap_get_folio_mpol() for =
sub-page blocks
- [Medium] mm/filemap: WB_DONTCACHE_DIRTY imbalance in folio_mark_dropbehin=
d()
--

commit e20189c53d3ac3e13083b73f222d81bf9ea44e23
Author: Mike Snitzer <snitzer@kernel.org>

mm, iomap: keep a partly covered page until an uncached write completes it

This commit introduces FGP_DONTCACHE_EDGE so that uncached buffered writes
covering only part of a minimum-sized folio leave a newly created folio
without PG_dropbehind, and instead mark PG_dropbehind when a subsequent
neighbouring uncached write finds the folio uptodate and completes it.

> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 0a5ebfda90f12..86f884c9f8f22 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -802,8 +802,22 @@ struct folio *iomap_get_folio(struct iomap_iter *ite=
r, loff_t pos, size_t len)
> =20
>  	if (iter->flags & IOMAP_NOWAIT)
>  		fgp |=3D FGP_NOWAIT;
> -	if (iter->flags & IOMAP_DONTCACHE)
> +	if (iter->flags & IOMAP_DONTCACHE) {
> +		size_t unit =3D mapping_min_folio_nrbytes(iter->inode->i_mapping);
> +		size_t off =3D pos & (unit - 1);
> +
>  		fgp |=3D FGP_DONTCACHE;
> +		/*
> +		 * The smallest folio the mapping allows, a page or a block
> +		 * where the block is larger, that this write covers only
> +		 * partly is shared with a neighbouring write: get it as just
> +		 * that, which is kept until the write that completes it.
> +		 */
> +		if (off || len < unit) {
> +			fgp |=3D FGP_DONTCACHE_EDGE;
> +			len =3D min_t(size_t, len, unit - off);
> +		}
> +	}

[Severity: Medium]
When the filesystem block size is smaller than PAGE_SIZE (for example, 4 KiB
blocks on a 16 KiB or 64 KiB page kernel, or sub-page blocks on a 4 KiB page
kernel), can folios written with RWF_DONTCACHE in sub-page chunks miss
getting marked with PG_dropbehind and remain in the page cache until memory
reclaim?

In iomap_get_folio(), unit is mapping_min_folio_nrbytes(), which is at least
PAGE_SIZE. Any uncached write with off !=3D 0 or len < unit sets
FGP_DONTCACHE_EDGE, so __filemap_get_folio_mpol() allocates the folio
without setting PG_dropbehind.

When i_blocksize(inode) < PAGE_SIZE, __iomap_write_begin() attaches struct
iomap_folio_state and only zeroes or reads blocks outside the block-aligned
range being written. Then __iomap_write_end() calls
iomap_set_range_uptodate():

fs/iomap/buffered-io.c:iomap_set_range_uptodate() {
	if (ifs) {
		spin_lock_irqsave(&ifs->state_lock, flags);
		mark_uptodate =3D ifs_set_range_uptodate(folio, ifs, off, len) &&
				!ifs->read_bytes_pending;
		spin_unlock_irqrestore(&ifs->state_lock, flags);
	}

	if (mark_uptodate)
		folio_mark_uptodate(folio);
}

Whenever at least one sub-page block in the folio remains unwritten after
the first write, ifs_set_range_uptodate() returns false and PG_uptodate
stays clear on the folio.

When the completing RWF_DONTCACHE write arrives for the remaining block(s)
of that folio, iomap_write_begin() -> iomap_get_folio() ->
__filemap_get_folio_mpol() (and filemap_dontcache_edge_completes() in the
subsequent commit "mm, iomap: let an uncached writer complete its shared
pages itself") checks folio_test_uptodate(folio) before
__iomap_write_begin() and __iomap_write_end() run for the completing write.
Because the blocks about to be written by the completing write are not yet
uptodate in ifs->state, folio_test_uptodate(folio) is still false when the
folio is looked up, so folio_mark_dropbehind(folio) is skipped before
__iomap_write_end() finally sets PG_uptodate.

> diff --git a/mm/filemap.c b/mm/filemap.c
> index 0c76ee5750b3b..1494e42e609fa 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c

[ ... ]

> @@ -2063,6 +2075,19 @@ struct folio *__filemap_get_folio_mpol(struct addr=
ess_space *mapping,
> =20
>  	if (fgp_flags & FGP_STABLE)
>  		folio_wait_stable(folio);
> +
> +	/*
> +	 * An uncached write that covers this folio only partly, finding it
> +	 * uptodate, is the write that completes it: the neighbouring write
> +	 * that left it here has written its part.  Mark it now, under the
> +	 * folio lock, so the writeback that cleans both writes' data drops it.
> +	 * Not a folio larger than the edge the two writes share, which holds
> +	 * more than they wrote and cannot be dropped in part.
> +	 */
> +	if ((fgp_flags & FGP_DONTCACHE) && (fgp_flags & FGP_DONTCACHE_EDGE) &&
> +	    (fgp_flags & FGP_LOCK) && folio_test_uptodate(folio) &&
> +	    filemap_dontcache_edge_unit(mapping, folio))
> +		folio_mark_dropbehind(folio);

[Severity: Medium]
Can calling folio_mark_dropbehind() here before the caller dirties the folio
cause an imbalance in WB_DONTCACHE_DIRTY when PAGECACHE_TAG_DIRTY is still
set in mapping->i_pages but PG_dirty has already been cleared on the folio?

In folio_mark_dropbehind() (and similarly in filemap_clear_dropbehind()),
the WB_DONTCACHE_DIRTY adjustment checks PAGECACHE_TAG_DIRTY without checki=
ng
folio_test_dirty(folio):

mm/filemap.c:folio_mark_dropbehind() {
	...
	xa_lock_irqsave(&mapping->i_pages, flags);
	folio_set_dropbehind(folio);
	if (xa_get_mark(&mapping->i_pages, folio->index, PAGECACHE_TAG_DIRTY))
		wb_stat_mod(inode_to_wb(mapping->host), WB_DONTCACHE_DIRTY,
			    folio_nr_pages(folio));
	xa_unlock_irqrestore(&mapping->i_pages, flags);
}

By contrast, inode_do_switch_wbs() checks both PAGECACHE_TAG_DIRTY and
folio_test_dirty(folio) under mapping->i_pages.xa_lock, because the paths
that uncount a dirty folio under the folio lock --
folio_clear_dirty_for_io() and __folio_cancel_dirty() ->
folio_account_cleaned() -- clear PG_dirty and decrement WB_DONTCACHE_DIRTY
before PAGECACHE_TAG_DIRTY is cleared.

A folio can be unlocked while remaining resident and uptodate in
mapping->i_pages with PG_dirty =3D=3D 0 and PAGECACHE_TAG_DIRTY =3D=3D 1:

1. In iomap_writepages() -> writeback_get_folio() ->
   folio_prepare_writeback(), folio_clear_dirty_for_io(folio) clears
   PG_dirty and decrements WB_DONTCACHE_DIRTY. Then iomap_writeback_folio()
   checks iomap_writeback_handle_eof(); if the folio is at or beyond i_size
   (for example, dirtied at i_size by xfs_zero_range() -> iomap_zero_range()
   before i_size is updated, or raced with truncate_setsize()),
   iomap_writeback_folio() returns 0 without calling
   folio_start_writeback(), unlocking the folio with PG_dirty =3D=3D 0 and
   PAGECACHE_TAG_DIRTY =3D=3D 1.

2. On block device mappings using iomap buffered writes with buffer heads
   (block/fops.c sets FOP_DONTCACHE and IOMAP_F_BUFFER_HEAD), if a dirty
   folio's buffers are cleaned and try_to_free_buffers() runs,
   folio_cancel_dirty() clears PG_dirty and decrements WB_DONTCACHE_DIRTY
   while leaving PAGECACHE_TAG_DIRTY set.

If an uncached edge write then looks up such a folio (PG_dirty =3D=3D 0,
PAGECACHE_TAG_DIRTY =3D=3D 1, PG_dropbehind =3D=3D 0) in __filemap_get_foli=
o_mpol(),
folio_mark_dropbehind() sees PAGECACHE_TAG_DIRTY and increments
WB_DONTCACHE_DIRTY. When iomap_write_end() subsequently dirties the folio v=
ia
filemap_dirty_folio() or block_dirty_folio(), folio_test_set_dirty(folio)
transitions PG_dirty from 0 to 1 and folio_account_dirtied() sees
PG_dropbehind set, incrementing WB_DONTCACHE_DIRTY a second time for the
same folio (and conversely filemap_clear_dropbehind() would decrement
WB_DONTCACHE_DIRTY a second time if called on a dropbehind folio in that
state).

Should folio_mark_dropbehind() and filemap_clear_dropbehind() also verify
folio_test_dirty(folio) alongside PAGECACHE_TAG_DIRTY under
mapping->i_pages.xa_lock?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023024548.7112=
3-1-snitzer@kernel.org?part=3D5

