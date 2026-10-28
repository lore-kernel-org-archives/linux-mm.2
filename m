Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01D87606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 11:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YQMV6Jkj
Received: by kanga.kvack.org (Postfix)
	id 2DD016B05B5; Wed, 28 Oct 2026 07:28:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28CC06B05B6; Wed, 28 Oct 2026 07:28:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12E296B05B7; Wed, 28 Oct 2026 07:28:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D89916B05B5
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:28:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BC6F8140C27
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:27:59 +0000 (UTC)
X-FDA: 85371810678.19.1068387
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 307F3180002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:27:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YQMV6Jkj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793186878;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VRtIuarwO46AIwC3Iu8qUA7V/xU1q4sbFqmUaW+gm0o=;
	b=2XupCF8EmHA2qw2l0fIU/dyb3pUXhYIi+r6l2ceAeMXoWWMf31079+ae5hmBWT6U0hjr6H
	rSYybDYIJ00zW4YLLZDdT7pIDr6kKHNNGISW6MyGjYLf1FqU7aoF49hgZHJaSdDCrPnZCJ
	VHkQgUjsnxQTNpIiQSdX92snbO4MQE8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YQMV6Jkj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793186878;
	b=pmDzqpTJer5KZzqmzlHxzEc81aZ85po4ZoyvY8wfwnp1BFBMFOlTYjpI+NytsddMhvBmyX
	XSIASVUHVXKyVuet5HSEeOWFY+Axwf3fCtbLiel0ezMIKApdWi9QsvwhpmophBoSj2zTAh
	qM3JIphto0yWWe1n/vEwdrUcRwUMbpM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B60A1601FA;
	Wed, 28 Oct 2026 11:27:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F421F01828;
	Wed, 28 Oct 2026 11:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793186876;
	bh=VRtIuarwO46AIwC3Iu8qUA7V/xU1q4sbFqmUaW+gm0o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YQMV6Jkjvjel2ClUswoPX6jUEHFZD0nzn2k+5k7/Qk0bGmX71iWbwR/QJOyeByLUJ
	 zFnF8O7DW3HHE7agPFDlghMtv6sgGuxUaVxh+SmnSnswTVhIOZJoRtJZr775tldVPI
	 4PSpmsD2GlcuPJ/JrduNvurbxXd3/vBY78Q9GBP/MZeyDXySH79vZlh6O4wfThwCBn
	 fFPjPJp8fGldHEvhfiurBgWdxmOtnuaVf9+thdDFV9mBIJLIWphXVlofyVd/iGViiq
	 6zxOvIfaOuV55tM8z9qSZwwrjZuiGhx05ab9cwomO6o0wePUDSA0nVqKxrB+7gAr6d
	 p7b9//VEfr/DA==
Message-ID: <sashiko-outbox-187814@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] mm, iomap: account dirty at page granularity for
 per-block dirty folios
Reply-To: sashiko-reviews@lists.linux.dev
To: "Salvatore Dipietro" <dipiets@amazon.it>, akpm@linux-foundation.org, linux-mm@kvack.org
Cc: ryan.roberts@arm.com, abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com, dipietro.salvatore@gmail.com, rvvandan@amazon.com, viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, linkinjeon@kernel.org, sj1557.seo@samsung.com, yuezhang.mo@sony.com, miklos@szeredi.hu, agruenba@redhat.com, djwong@kernel.org, hyc.lee@gmail.com, almaz.alexandrovich@paragon-software.com, cem@kernel.org, dlemoal@kernel.org, naohiro.aota@wdc.com, jth@kernel.org, willy@infradead.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, ritesh.list@gmail.com
In-Reply-To: <20261027112702.3747009-3-dipiets@amazon.it>
References: <20261027112702.3747009-1-dipiets@amazon.it>
 <20261027112702.3747009-3-dipiets@amazon.it>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 11:27:54 +0000
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 307F3180002
X-Stat-Signature: 91odsqan41hx1m8c3t3tobk3un1wy6ut
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793186878-744258
X-HE-Meta: U2FsdGVkX1/YO4tRnS+Nwu+bD/XZAtjZOQtbdkMjreT9+ZugD6JLs1wybbbTnDaQm3KWv/tHsOwk1PA1eyscczX8QexTgDEo51QJtt0y53I/wXqtzyvbbLALx5iDwr2c2iBSncf+vm2rvcVGLua8PlujN6o78LSA0kBD18K7z4jW6mYEh0KxvkaL0KK7YafjfBsCrE3c+q67CPB1R9KSaiDezEbKtEf1XK9Zif1V+5CfOICdLDKiCYsYPu7IQRxNVCCmbpkuqEjGCmGT2vbRLbZTn5g1RdCXgaWYw0mQ3VZslmTAeJpPfc+zLKT60jh6LpzU9L7LXXXbDo7ZCJzuku5mCC3gRn5NlO0YpgaKMwi7WHbWzFzK9mMyHM2qLlJNTQTQz/RivwxVgt8CRb6QpMSQQj4X8GinqojzecOXGk8VO8TA1EiNIHpX70FMHtfohsMacoBSm8yC+pEnUP1+mXLU81/rncW9mXWiYPaJv7MaMfE0hiok5lksCwwdXka3/Zi17ssHijJO27B8bk84xlCZMITj0ugc130hCQuOPgewQP7PfOD0gCR1OgX3FM/lxcJxT6xRs/Af0c66BFonFru+oKTiyq149nGmndHYl1c0XLQ73s7HS/LL0CcJdkkALktEVd+kqi5ef4RRFRJGD/84bjTf3gJ0n2DE7wOObetkyuQEAePlyrMFI9RxjZK+JdCwXIr0c2bVJS0LxT1TTjL2iHMOEw11CJgyjXGoWW/507HLIZcTiFALrZGHrk0gIQpPgYfKHZCFTMZ2inOqiIVQQK0f0svgTJ2c6fAm0UljhgYnMdXnHIR8+GCRBVsihWO/3PffYx5oNg4B7wrmrXbx1gUxfHNEP/8FPTbClHS/CQnkV67nVyGYd3FvFGI8MLOykrMSm/RfVnaNJtpb6QKhDBc2qgG37LoszuDgYhF73ouUy9SzQ5THDxYaumOAZ9N21JBjYFJuolDvcQk
 zYhkJyQD
 323BMxXvTbjuCYZDd3AuK0OLA5PGNgtWzBIpKjvuFbwn2x9LL+WQVzzDgcDKTZh1o2U/mkajpZa0hYSucSZmvz9vEa0DN/hl0aJHqNUNG+jvOljo0pdhpvoFTrxu5AbUXjb7zEOO7CHSj7BqnRjhAmeURyjUAJzaLlJtFXWMSMBM3/nAe4qzbGCxT6WUrrJT79yrGPLVOWqAOe/bJryofwA94ZRTcEGtDsGr7rQx37XFMP6d5NdxRiKscscx7MPqzr6Ol6h+v7VYZsTizejXfWMDa5sJWANxgn3A16mJhK5UxWa1KQ5sk4cJHcvBQLUzwaV5jc2htasYazi7HkHntNecOENPNviPf71QESGZq3/tzHUpNtc+dtt2F5d3JMyK74K5Z5CjmCloBfqqy6IAbLbICz6jNwow3k7mP9fx5xx5RiVRMPD1/6puDoPWXO/AQOInmh8ragRp+rkBiG9HjkIM99rc8NnGEPwx3zq4gkESmP4yBvWZdfLgVRQlT6K9752wxXo6sakoo5NCcSvawZ6wk4o5fGsvnbDgj+W2wUvlNGFNJWpZ+VyYlgl81YLJvuFBfujxUegJCgxDQodc00V/XCCaiz2CrihBoUOsuVM5kyU3e1OZ5Nl2Z1w0kZkqKse6J6qkhJ1pI8Ck=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [High] iomap: dirty counter leak on early EOF return in iomap_writeback_f=
olio()
- [High] ntfs, ntfs3: dirty counter leak in ntfs_mft_writepages() and ntfs_=
writepages()
- [High] block: missing iomap per-block dirty callbacks in def_blk_aops
- [Medium] mm: wrong wb stats in inode_do_switch_wbs() and __filemap_get_fo=
lio_mpol()
- [Medium] gfs2: stale AS_DIRTY_PER_BLOCK flag after switching to gfs2_jdat=
a_aops
--

commit ec03cb36d468351e028d982f93868e296ff14cfc
Author: Salvatore Dipietro <dipiets@amazon.it>

mm, iomap: account dirty at page granularity for per-block dirty folios

This commit updates iomap to account mm and writeback dirty page counters at
page granularity rather than full folio granularity when folios carry
per-block dirty state in struct iomap_folio_state, and wires up
.accounted_dirty_pages =3D iomap_accounted_dirty_pages across iomap-based
filesystems.

> diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
> index 0a7b8076af3a5..ea77af00b111e 100644
> --- a/fs/gfs2/aops.c
> +++ b/fs/gfs2/aops.c
> @@ -713,6 +713,7 @@ static const struct address_space_operations gfs2_aop=
s =3D {
>  	.read_folio =3D gfs2_read_folio,
>  	.readahead =3D gfs2_readahead,
>  	.dirty_folio =3D iomap_dirty_folio,
> +	.accounted_dirty_pages =3D iomap_accounted_dirty_pages,

[Severity: Medium]
What happens if a GFS2 file using gfs2_aops with blocksize < folio_size()
allocates struct iomap_folio_state via ifs_alloc() (which sets
AS_DIRTY_PER_BLOCK on inode->i_mapping), and later has GFS2_DIF_JDATA
enabled via gfs2_fileattr_set() -> do_gfs2_set_flags() -> gfs2_set_aops()?

fs/gfs2/aops.c:gfs2_set_aops() {
	if (gfs2_is_jdata(GFS2_I(inode)))
		inode->i_mapping->a_ops =3D &gfs2_jdata_aops;
	else
		inode->i_mapping->a_ops =3D &gfs2_aops;
}

Switching inode->i_mapping->a_ops to gfs2_jdata_aops leaves
AS_DIRTY_PER_BLOCK set on inode->i_mapping. Subsequent writes in jdata mode
attach struct buffer_head rings to folio->private and charge
folio_nr_pages(folio) via gfs2_jdata_dirty_folio() -> block_dirty_folio().

When gfs2_jdata_writepages() later runs folio_clear_dirty_for_io():

mm/page-writeback.c:folio_clear_dirty_for_io() {
    ...
		if (folio_test_clear_dirty(folio)) {
			if (!mapping_dirty_per_block(mapping) || !folio->private) {
				long nr =3D folio_nr_pages(folio);
    ...
}

Because mapping_dirty_per_block(mapping) is still true and folio->private is
non-NULL (pointing to buffer_heads), won't folio_clear_dirty_for_io() skip
discharging NR_FILE_DIRTY, WB_DONTCACHE_DIRTY, NR_ZONE_WRITE_PENDING, and
WB_RECLAIMABLE on every writeback?

> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 0a5ebfda90f12..75671b29f7cce 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c

[ ... ]

> @@ -180,6 +189,89 @@ static unsigned iomap_find_dirty_range(struct folio =
*folio, u64 *range_start,

[ ... ]

> +static void iomap_account_dirty_pages(struct folio *folio, long nr_pages,
> +		bool new_dirty)
> +{
> +	struct address_space *mapping =3D folio->mapping;
> +	struct inode *inode =3D mapping->host;
> +	struct wb_lock_cookie cookie =3D {};
> +	struct bdi_writeback *wb;
> +	bool dirtied =3D nr_pages > 0 && new_dirty;
> +
> +	if (!nr_pages || !mapping_can_writeback(mapping))
> +		return;
> +
> +	lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, nr_pages);
> +	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr_pages);
> +	if (dirtied)
> +		node_stat_mod_folio(folio, NR_DIRTIED, nr_pages);
> +
> +	/* Pin the wb against a concurrent inode_do_switch_wbs(). */
> +	inode_attach_wb(inode, folio);
> +	wb =3D unlocked_inode_to_wb_begin(inode, &cookie);
> +	wb_stat_mod(wb, WB_RECLAIMABLE, nr_pages);
> +	if (folio_test_dropbehind(folio))
> +		wb_stat_mod(wb, WB_DONTCACHE_DIRTY, nr_pages);
> +	if (dirtied)
> +		wb_stat_mod(wb, WB_DIRTIED, nr_pages);
> +	unlocked_inode_to_wb_end(inode, &cookie);

[Severity: Medium]
Can charging WB_RECLAIMABLE and WB_DONTCACHE_DIRTY by nr_pages here corrupt
per-wb counters when inode_do_switch_wbs() or __filemap_get_folio_mpol()
runs on a partially dirty large folio?

In fs/fs-writeback.c, inode_do_switch_wbs() still transfers
folio_nr_pages(folio) instead of folio_accounted_dirty_pages(folio):

fs/fs-writeback.c:inode_do_switch_wbs() {
    ...
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
    ...
}

When new_wb later writes back or invalidates the folio,
iomap_clear_range_dirty() only subtracts ifs->dirty_pages from new_wb,
leaving old_wb underflowed and new_wb inflated by
folio_nr_pages(folio) - ifs->dirty_pages.

Also, because iomap_account_dirty_pages() updates WB_RECLAIMABLE and
WB_DONTCACHE_DIRTY outside mapping->i_pages.xa_lock before
__filemap_dirty_folio() sets PG_dirty, and because
folio_clear_dirty_for_io() clears PG_dirty while keeping WB_RECLAIMABLE and
WB_DONTCACHE_DIRTY charged until iomap_clear_range_dirty(), can a concurrent
inode_do_switch_wbs() miss or misaccount a folio whose PG_dirty state does
not match its active wb charge?

Similarly, in mm/filemap.c, __filemap_get_folio_mpol() decrements
WB_DONTCACHE_DIRTY by folio_nr_pages(folio) when clearing PG_dropbehind:

mm/filemap.c:__filemap_get_folio_mpol() {
    ...
	if (!(fgp_flags & FGP_DONTCACHE) && folio_test_clear_dropbehind(folio)) {
		if (folio_test_dirty(folio) &&
		    mapping_can_writeback(mapping)) {
			struct inode *inode =3D mapping->host;
			struct bdi_writeback *wb;
			struct wb_lock_cookie cookie =3D {};
			long nr =3D folio_nr_pages(folio);

			wb =3D unlocked_inode_to_wb_begin(inode, &cookie);
			wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
			unlocked_inode_to_wb_end(inode, &cookie);
		}
	}
    ...
}

Won't that underflow WB_DONTCACHE_DIRTY when a partially dirty folio was
only charged ifs->dirty_pages, or leak WB_DONTCACHE_DIRTY if PG_dropbehind
is cleared after folio_clear_dirty_for_io() cleared PG_dirty but before
iomap_clear_range_dirty() runs?

[ ... ]

> @@ -276,9 +396,13 @@ static struct iomap_folio_state *ifs_alloc(struct in=
ode *inode,
>  	spin_lock_init(&ifs->state_lock);
>  	if (folio_test_uptodate(folio))
>  		bitmap_set(ifs->state, 0, nr_blocks);
> -	if (folio_test_dirty(folio))
> +	if (folio_test_dirty(folio)) {
>  		bitmap_set(ifs->state, nr_blocks, nr_blocks);
> +		ifs->dirty_pages =3D folio_nr_pages(folio);
> +	}
>  	folio_attach_private(folio, ifs);
> +	/* The mm dirty counters are now charged per dirty page for this file. =
*/
> +	mapping_set_dirty_per_block(inode->i_mapping);

[Severity: High]
What happens on block devices when !CONFIG_BUFFER_HEAD is enabled?

In block/fops.c, def_blk_aops uses iomap for buffered I/O, writepages,
release_folio, and invalidate_folio when !CONFIG_BUFFER_HEAD:

block/fops.c:
const struct address_space_operations def_blk_aops =3D {
	.dirty_folio	=3D filemap_dirty_folio,
	.release_folio		=3D iomap_release_folio,
	.invalidate_folio	=3D iomap_invalidate_folio,
	.read_folio		=3D blkdev_read_folio,
	.readahead		=3D blkdev_readahead,
	.writepages		=3D blkdev_writepages,
	.is_partially_uptodate  =3D iomap_is_partially_uptodate,
	.error_remove_folio	=3D generic_error_remove_folio,
	.migrate_folio		=3D filemap_migrate_folio,
};

When ifs_alloc() attaches ifs to a block device folio with
i_blocks_per_folio(inode, folio) > 1, it sets AS_DIRTY_PER_BLOCK on the
block device mapping, but def_blk_aops does not set
.accounted_dirty_pages =3D iomap_accounted_dirty_pages or
.dirty_folio =3D iomap_dirty_folio.

When iomap_invalidate_folio(folio, 0, folio_size(folio)) later runs on a
dirty block device folio, it first calls iomap_clear_range_dirty() (which
discharges ifs->dirty_pages and sets ifs->dirty_pages =3D 0) and then calls
folio_cancel_dirty() -> folio_account_cleaned() ->
folio_accounted_dirty_pages(). Because mapping->a_ops->accounted_dirty_pages
is NULL, folio_accounted_dirty_pages() returns folio_nr_pages(folio) instead
of 0, discharging the counters a second time.

Also, if a block device folio that already has ifs attached from a read is
dirtied via mmap (filemap_dirty_folio()), the dirty bits in ifs->state are
not set, so writeback via folio_clear_dirty_for_io() and
iomap_writeback_folio() neither writes the blocks nor discharges the dirty
counters. Should def_blk_aops also use iomap_dirty_folio and
iomap_accounted_dirty_pages when !CONFIG_BUFFER_HEAD?

[ ... ]

> @@ -2001,8 +2151,13 @@ int iomap_writeback_folio(struct iomap_writepage_c=
tx *wpc, struct folio *folio)
> =20
>  	if (i_blocks_per_folio(inode, folio) > 1) {
>  		if (!ifs) {
> +			/*
> +			 * Dirtied before it had per-block state, so charged
> +			 * per-folio.  Re-mark the blocks for the walk below,
> +			 * paired with the clear at the end of this function.
> +			 */
>  			ifs =3D ifs_alloc(inode, folio, 0);
> -			iomap_set_range_dirty(folio, 0, end_pos - pos);
> +			iomap_redirty_range(folio, 0, end_pos - pos);
>  		}
> =20
>  		iomap_writeback_init(inode, folio);

[Severity: High]
Can iomap_writeback_folio() leak the dirty page counters when a folio with
per-block state is at or beyond EOF?

Before calling iomap_writeback_folio() (via writeback_iter() ->
folio_prepare_writeback() or fuse_launder_folio()), the caller invokes
folio_clear_dirty_for_io(folio), which clears PG_dirty without discharging
NR_FILE_DIRTY, WB_DONTCACHE_DIRTY, NR_ZONE_WRITE_PENDING, or WB_RECLAIMABLE
when mapping_dirty_per_block(mapping) && folio->private is true.

However, at the start of iomap_writeback_folio():

fs/iomap/buffered-io.c:iomap_writeback_folio() {
    ...
	if (!iomap_writeback_handle_eof(folio, wpc, &end_pos))
		return 0;
    ...
}

If iomap_writeback_handle_eof() returns false (for instance, when writeback
races with truncate_setsize() after i_size_write() lowers i_size but before
truncate_pagecache() locks the folio, or in folio_unmap_invalidate() ->
fuse_launder_folio()), iomap_writeback_folio() returns 0 without calling
iomap_clear_range_dirty(folio, 0, folio_size(folio)).

That leaves the folio clean (PG_dirty =3D=3D false, PG_writeback =3D=3D fal=
se) while
ifs->dirty_pages remains charged. If filemap_release_folio() ->
iomap_release_folio() then runs (immediately in folio_unmap_invalidate(), or
via reclaim, splitting, or eviction before truncate_cleanup_folio() locks
the folio):

fs/iomap/buffered-io.c:iomap_release_folio() {
    ...
	if (folio_test_dirty(folio))
		return false;
	ifs_free(folio);
	return true;
}

Won't iomap_release_folio() see folio_test_dirty(folio) =3D=3D false and fr=
ee
ifs without ever discharging ifs->dirty_pages?

> diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
> index 517d9a1563e7d..d26ddd5ae1185 100644
> --- a/fs/ntfs/aops.c
> +++ b/fs/ntfs/aops.c
> @@ -308,6 +308,7 @@ const struct address_space_operations ntfs_aops =3D {
>  	.readahead		=3D ntfs_readahead,
>  	.writepages		=3D ntfs_writepages,
>  	.dirty_folio		=3D iomap_dirty_folio,
> +	.accounted_dirty_pages	=3D iomap_accounted_dirty_pages,
>  	.bmap			=3D ntfs_bmap,
>  	.migrate_folio		=3D filemap_migrate_folio,
>  	.is_partially_uptodate	=3D iomap_is_partially_uptodate,
> @@ -322,6 +323,7 @@ const struct address_space_operations ntfs_mft_aops =
=3D {
>  	.readahead		=3D ntfs_readahead,
>  	.writepages		=3D ntfs_mft_writepages,
>  	.dirty_folio		=3D iomap_dirty_folio,
> +	.accounted_dirty_pages	=3D iomap_accounted_dirty_pages,
>  	.bmap			=3D ntfs_bmap,
>  	.migrate_folio		=3D filemap_migrate_folio,
>  	.is_partially_uptodate	=3D iomap_is_partially_uptodate,
> diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
> index 4ac26c80bd34f..509570091e483 100644
> --- a/fs/ntfs3/inode.c
> +++ b/fs/ntfs3/inode.c
> @@ -2301,6 +2301,7 @@ const struct address_space_operations ntfs_aops =3D=
 {
>  	.writepages	=3D ntfs_writepages,
>  	.bmap		=3D ntfs_bmap,
>  	.dirty_folio	=3D iomap_dirty_folio,
> +	.accounted_dirty_pages =3D iomap_accounted_dirty_pages,

[Severity: High]
Does enabling per-block dirty accounting on ntfs_mft_aops (in fs/ntfs) and
resident files using ntfs_aops (in fs/ntfs3) leak dirty page counters during
writeback?

In fs/ntfs, ntfs_mft_aops uses ntfs_mft_writepages(), which iterates with
writeback_iter() and calls ntfs_write_mft_block(folio, wbc) rather than
iomap_writeback_folio():

fs/ntfs/mft.c:ntfs_mft_writepages() {
    ...
	while ((folio =3D writeback_iter(mapping, wbc, folio, &error)))
		error =3D ntfs_write_mft_block(folio, wbc);
    ...
}

Similarly, in fs/ntfs3, ntfs_writepages() handles resident files via
writeback_iter() and attr_data_write_resident(ni, folio) without calling
iomap_writepages():

fs/ntfs3/inode.c:ntfs_writepages() {
    ...
	if (is_resident(ni)) {
		struct folio *folio =3D NULL;
		err =3D 0;

		while ((folio =3D writeback_iter(mapping, wbc, folio, &err))) {
			int err2;

			ni_lock(ni);
			err2 =3D attr_data_write_resident(ni, folio);
			ni_unlock(ni);
    ...
}

When these folios are dirtied via iomap_dirty_folio() (such as
ntfs_mft_mark_dirty() on $MFT or mmap writes on a resident file),
ifs_alloc() attaches ifs and sets AS_DIRTY_PER_BLOCK, and
iomap_set_range_dirty() charges ifs->dirty_pages. During writeback,
writeback_iter() calls folio_clear_dirty_for_io(), which skips discharging
the dirty counters because mapping_dirty_per_block(mapping) &&
folio->private is true, and neither ntfs_write_mft_block() nor
attr_data_write_resident() clears ifs dirty state or discharges
ifs->dirty_pages.

Won't this permanently leak NR_FILE_DIRTY, NR_ZONE_WRITE_PENDING,
WB_RECLAIMABLE, and WB_DONTCACHE_DIRTY on writeback, and prevent subsequent
calls to iomap_dirty_folio() on the same folio from charging the counters
because all dirty bits in ifs->state remain set?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027112702.3747=
009-1-dipiets@amazon.it?part=3D2

