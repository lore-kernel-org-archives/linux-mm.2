Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABB6A606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 02:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mS7hWbEt
Received: by kanga.kvack.org (Postfix)
	id C793A6B0B87; Fri, 23 Oct 2026 22:46:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDB736B0B88; Fri, 23 Oct 2026 22:46:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA3086B0B89; Fri, 23 Oct 2026 22:46:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 71E356B0B87
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 22:46:42 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9721040127
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 02:46:41 +0000 (UTC)
X-FDA: 85355981802.02.0B1783A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id E62D4140002
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 02:46:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mS7hWbEt;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792809999;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=36HrZGN0Tj3VWi1scZqce1Srf61LLFDMTN/bt1D8bwk=;
	b=0dWx7fF4lKyaJJxdpUHAQ98szL+Lvyn1vX2/tA3rtV0MqyDQAXDMJtLUOUtJrU9YMgKy7+
	BbT6ggOPhytkBF4mLzzhxvY1h7YI1gFLuxFkOqgTuGfZdyuiMP2h2151rurFdTTTTHsgFo
	vKZvltPSYYeL5qeaO1NNCBLEpitzIew=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792810000;
	b=0wFQSRuDFC/97fRs+0cj+l7LWAYdbfWCYOhhX7rjqWmcIPL/bqpU0iXjzKqmwX9AXUGZNd
	RYyCktz5FeBopGhAYlHvVcWukTnQ+9HQ2NGqamG3YpmVOyXY9Zwb5BYKkGzKBpLAEOU7Ud
	lRIYVP3RVsfHkws5D/8A6drIqkbOeEA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mS7hWbEt;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7FBB260A80;
	Sat, 24 Oct 2026 02:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3EEA1F01825;
	Sat, 24 Oct 2026 02:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792809999;
	bh=36HrZGN0Tj3VWi1scZqce1Srf61LLFDMTN/bt1D8bwk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mS7hWbEt9QXR+refdQd95/p4ww5qHzBdHHzJaJrwE06Vd1srJbGSfwxwVBj6yojU0
	 4o8ZD+jE4Xm70sSeT4b9S5SQ/wRxf3oi/HaWh2RYuCaGcljf+WfdFI6jH4PFop2tje
	 F0HOOeMEhRkpGcxhRrjtqmNQ/FydvCwEGCTBC0DbiT3JvWbXHqFxDrgbQo1jUtLEiO
	 VCHWNOh/8B9cFYw5kj2jLkil6p04aG0T8YJakf1dRC+c45X7mWUpg43VdQkxqAV2uc
	 hjICSzZAUDlinGyIxGVu/N7xGJemXqHNO89T3nwgRt2NBTQAfG+hEu6Q9s1cJBcRpZ
	 7hJAwFHK4AReQ==
Message-ID: <sashiko-outbox-183523@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 6/7] mm, iomap: let an uncached writer complete its
 shared pages itself
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mike Snitzer" <snitzer@kernel.org>, "Chuck Lever" <cel@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>
Cc: NeilBrown <neil@brown.name>, "Olga Kornievskaia" <okorniev@redhat.com>, "Dai
 Ngo" <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>, "Christoph
 Hellwig" <hch@lst.de>, "Jens Axboe" <axboe@kernel.dk>, "Matthew Wilcox" <willy@infradead.org>, "Jonathan
 Corbet" <corbet@lwn.net>, linux-mm@kvack.org, "Anna Schumaker" <anna@kernel.org>
In-Reply-To: <20261023024548.71123-7-snitzer@kernel.org>
References: <20261023024548.71123-1-snitzer@kernel.org>
 <20261023024548.71123-7-snitzer@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 24 Oct 2026 02:46:38 +0000
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E62D4140002
X-Stat-Signature: n8o8u6y1x8tyg6h4b5mdgr4gq4kyxrin
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792809999-402351
X-HE-Meta: U2FsdGVkX19slqlvDMbvxwtxrVC3Efs8LI5MJRyOiQEGBjsbiH76mUrpmwSCuM38DjxmgCrRIIaVAFOSqeO6ZZNIJbkZl/FG4Z6t2zgkgZ+GKbNuOP+3sr+9aP6+FoWJM+2P9LIWui90x4Rsc3xjW9qVtkGdEwrhFt1hqOwYs5NlaC316aZmaW0wLIYIVbTZ8d798zYrs0HeqYOEBwVj2R1hx554qdf8daURwXvi94PKI9tRFXZF7zQFLxYHQfkwn4Kr24WxNgkSdMaziSVBlE7LKObAJqDVKGa5aiLu92OWLY02YewFIbLFAfXkrDQaKkMbdKmKQN9/pZXrGriM3Bu9NcpFPsTAFkQSl9IYO4yW2qJNDdRO7vTjuBqkKir3R2xBmUVQjI1u98iMSeq5lz6taG/VtqpkfQv2TRU1FuSwdtvOwPuav9zcuuP//MqnKpON1sha2egkh1B8NEkOeRSgKrrpKsF26PCku3O0Md7yQ8FvazpYdHJLnLvS4hzKEQkx1ic6EC52ZcMmqBvE14MeegsuKvxIHAt6DjNQWJOFpYeXEY38YWDZPR0B04uJ/VAeVW/m69gkWCNGHOK+u2gwji2CZvBYZ5aTClVRcXBFbl5vLtN0B8Gsz2bLSzZIGSINU25WLu0aPjZ6edd1q48RTnsE6h0GA1tJenJNi2k8z1npVHpkgjAequVP+38u+hPXtQp+G+MqnPD4zQkdatKwebATlctTE3W4i8hzlMBSg0i91fjDZ0jLAT93gBsYc1Sbqi/Y0rsDzHABbMgc99h7QmAcL4dd656jqtZXuKN+WeseDdnloi/5rq0AetQEud/DFSkvkz2uecNJC8jEksMZ+JP0TNSWuIeUM9irdCa5kVhCqEiClnMbfXWmO0EU7zFda936K0gZMxfGDSoN+z+PTOeyNxzfEg/HyW/Ikj4A3ZqYTEohyyFVSnZ7lftS1vPOqRrjTA8Gubzaqgh
 FZ9X865C
 tq9lLrGFb2u5gOM0HdTuxDvVFY1O+/ZDpx1ABwB/bTn1oWk/Gp793CcsG93BfNDmAA/fmNUep5Rlye9bS7CGPqs1+1DRgVeziHX313Ra1hEfJ4Lw1cSuVhd5//diLIiMUT5L7QzL1KPzVeow/LOiesXt03kD4YX0vBFl32Xw+csrGH693cVcPUQwPw67Xxxcy9yjKGesF86i5K8nzvCrAeW4lZ5JRVBDWXejEdGb8m7jOIaSfeNCVOW7Md9IRTJTZNCb4tAyY/+0wuPD2mlqX5Wx50TGsJulZpsFhRiVkpxFwDUK630Zfj4XWzHsmH2YP9+OXCQP8mtU/TfGxqvojODSkFwlzBApRJ+xf8VZXBJINtPZvpeP5zkcFgSMe3aEHa09jC3EpeMInvnwgzImQ54PmkuLTVn5Pgiph0dUKlUji0Q9O6q4ZR9ykoes1SoKvyjx16bI3bQJ6mvo2SlVUlOkKhM2Dqb7FLdATU4FL4WO+bhrrZUuFU/qX2IAEsYiq6sZ9+NxEuKBBCxq1y2Ursnr8EMK/kIvJXEpoVGnZz1gGhNolnWfHsMJFaayBENbtP5Taz61NrSg91iQPd3FOqQlUu65ua9z5RJNCYRv4emarnlCjzEb+A3XYXkgs04ICjQOuLcWBc6e0dl42Zh08yoew8iSIul7nyVPV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] mm: filemap_dontcache_edge_completes() misses partially uptodate=
 iomap folios
- [Medium] mm: filemap_dontcache_edge_complete() misses writeback kick and =
racing bio drop
- [Medium] mm: WB_DONTCACHE_DIRTY leak in filemap_dontcache_edge_complete()
--

commit 7d2a5aea41a384cd5ec593563dbc8bd144b6bcce
Author: Mike Snitzer <snitzer@kernel.org>

mm, iomap: let an uncached writer complete its shared pages itself

This commit introduces IOCB_DONTCACHE_DEFER, IOMAP_DONTCACHE_DEFER, and
FGP_DONTCACHE_DEFER along with filemap_dontcache_edge_completes() and
filemap_dontcache_edge_complete() so that an uncached writer that syncs
its own writes can defer marking and dropping partially covered edge
folios until after the write and sync complete.

> diff --git a/mm/filemap.c b/mm/filemap.c
> index 1494e42e609fa..890913f38c65f 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1695,6 +1695,72 @@ static bool filemap_dontcache_edge_unit(struct add=
ress_space *mapping,
>  	return folio_nr_pages(folio) =3D=3D mapping_min_folio_nrpages(mapping);
>  }
> =20
> +/**
> + * filemap_dontcache_edge_completes - will this write complete a shared =
page?
> + * @mapping: the file's mapping
> + * @pos: any byte offset within the page
> + *
> + * For an uncached writer that completes the pages it covers only partly
> + * itself (IOCB_DONTCACHE_DEFER).  Call right before writing such a page=
: it
> + * is in the page cache and uptodate when the neighbouring write has alr=
eady
> + * written its part, and this write then completes it.  Two writes that
> + * arrive together may both find it absent; the page is then left cached,
> + * unmarked, until reclaim.
> + *
> + * Return: true if the caller is to call filemap_dontcache_edge_complete=
()
> + * once its write, including any sync of it, is done.
> + */
> +bool filemap_dontcache_edge_completes(struct address_space *mapping, lof=
f_t pos)
> +{
> +	struct folio *folio;
> +	bool ret;
> +
> +	/* FGP_DONTCACHE: a plain lookup would clear a drop-behind mark. */
> +	folio =3D __filemap_get_folio(mapping, pos >> PAGE_SHIFT, FGP_DONTCACHE=
, 0);
> +	if (IS_ERR(folio))
> +		return false;
> +	ret =3D folio_test_uptodate(folio) &&
> +	      filemap_dontcache_edge_unit(mapping, folio);
> +	folio_put(folio);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(filemap_dontcache_edge_completes);

[Severity: Medium]
What happens here (and in __filemap_get_folio_mpol()) on iomap filesystems
when the filesystem block size is smaller than the minimum folio size, i.e.
i_blocksize(inode) < PAGE_SIZE (for example, 4 KiB XFS blocks on a 16 KiB or
64 KiB PAGE_SIZE kernel, or sub-page block sizes on a 4 KiB PAGE_SIZE
kernel)?

When the first partial uncached write allocates the shared folio via
iomap_get_folio(), i_blocks_per_folio(inode, folio) is greater than 1, so
__iomap_write_begin() and __iomap_write_end() attach a struct
iomap_folio_state (ifs) and only mark the blocks within
[round_down(pos, block_size), round_up(pos + len, block_size)) uptodate in
ifs->state:

fs/iomap/buffered-io.c:iomap_set_range_uptodate() {
		mark_uptodate =3D ifs_set_range_uptodate(folio, ifs, off, len) &&
				!ifs->read_bytes_pending;
		spin_unlock_irqrestore(&ifs->state_lock, flags);
	}

	if (mark_uptodate)
		folio_mark_uptodate(folio);
}

Because the remaining blocks in the folio are not uptodate yet,
folio_mark_uptodate() is not called after the first partial write.

When the neighbouring write arrives to write the rest of the page and calls
filemap_dontcache_edge_completes() before writing (or looks up the folio in
__filemap_get_folio_mpol() before __iomap_write_end() runs),
folio_test_uptodate(folio) is still false.  Won't
filemap_dontcache_edge_completes() return false and leave the completed edge
folio cached until reclaim?

> +
> +/**
> + * filemap_dontcache_edge_complete - drop a shared page both writes have=
 written
> + * @mapping: the file's mapping
> + * @pos: any byte offset within the page
> + *
> + * Mark the page drop-behind.  If it is already written back, drop it no=
w;
> + * otherwise the writeback that cleans it drops it.  A dirty page marked=
 here
> + * counts as DONTCACHE dirty and wakes the DONTCACHE writeback kick, so a
> + * caller that syncs its write calls this after the sync.  A folio larger
> + * than the smallest the mapping allows is left as it is: it holds more =
than
> + * the two writes' page, and it cannot be dropped in part.
> + */
> +void filemap_dontcache_edge_complete(struct address_space *mapping, loff=
_t pos)
> +{
> +	struct folio *folio;
> +
> +	folio =3D __filemap_get_folio(mapping, pos >> PAGE_SHIFT,
> +				    FGP_LOCK | FGP_DONTCACHE, 0);
> +	if (IS_ERR(folio))
> +		return;
> +	if (filemap_dontcache_edge_unit(mapping, folio)) {
> +		folio_mark_dropbehind(folio);
> +		/*
> +		 * Drop it now if it is already clean, with the lock still
> +		 * held: folio_end_dropbehind() would take it again with a
> +		 * trylock, and a folio another task locks in between would
> +		 * be left for reclaim, no writeback being left to drop it.
> +		 */
> +		filemap_end_dropbehind(folio);
> +	}
> +	folio_unlock(folio);
> +	folio_put(folio);
> +}
> +EXPORT_SYMBOL_GPL(filemap_dontcache_edge_complete);

[Severity: Medium]
There appear to be a few issues in filemap_dontcache_edge_complete() with
how writeback kicking and in-flight writeback are handled:

1. The kernel-doc states that a dirty page marked here counts as DONTCACHE
dirty and wakes the DONTCACHE writeback kick, and that an uncached writer
using IOCB_DONTCACHE_DEFER avoids per-segment writeback kicks.  However,
generic_write_sync() is not updated for IOCB_DONTCACHE_DEFER:

include/linux/fs.h:generic_write_sync() {
	if (iocb_is_dsync(iocb)) {
		...
	} else if (iocb->ki_flags & IOCB_DONTCACHE) {
		filemap_dontcache_kick_writeback(iocb->ki_filp->f_mapping);
	}
}

During vfs_iocb_iter_write(), generic_write_sync() runs before
filemap_dontcache_edge_complete() is called, while FGP_DONTCACHE_DEFER has
kept the edge folio unmarked.  Then, when filemap_dontcache_edge_complete()
later marks a dirty folio via folio_mark_dropbehind(), it increments
WB_DONTCACHE_DIRTY and filemap_end_dropbehind() returns early because
folio_test_dirty(folio) is true, without calling
filemap_dontcache_kick_writeback(mapping).  If WB_start_dontcache was
already consumed while WB_DONTCACHE_DIRTY was 0, what wakes writeback after
filemap_dontcache_edge_complete() marks the dirty folio?  And shouldn't
generic_write_sync() skip filemap_dontcache_kick_writeback() when
IOCB_DONTCACHE_DEFER is set?

2. If writeback on the shared folio has already started before
filemap_dontcache_edge_complete() locks it, PG_dropbehind was not set when
iomap_add_to_ioend() (or submit_bh_wbc()) submitted the bio:

fs/iomap/ioend.c:iomap_add_to_ioend() {
	if (folio_test_dropbehind(folio))
		bio_set_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
}

Because filemap_dontcache_edge_complete() does not wait for PG_writeback,
it sets PG_dropbehind while the bio is in flight and filemap_end_dropbehind=
()
returns early because folio_test_writeback(folio) is true.  When that bio
completes in IRQ or softirq context (!in_task()), folio_end_dropbehind()
cannot invalidate the folio; or if the bio completes in task context while
filemap_dontcache_edge_complete() still holds the folio lock,
folio_end_dropbehind()'s folio_trylock() fails.  Won't the folio be left in
the page cache until reclaim in both cases?

[Severity: Medium]
Can calling folio_mark_dropbehind(folio) followed immediately by
filemap_end_dropbehind(folio) in filemap_dontcache_edge_complete() leak
WB_DONTCACHE_DIRTY?

In filemap_dontcache_edge_complete(), folio_mark_dropbehind() is called
unconditionally even when the folio is already clean after the caller's
sync, setting PG_dropbehind under mapping->i_pages.  Immediately after,
filemap_end_dropbehind() checks folio_test_dirty() and clears PG_dropbehind
without holding mapping->i_pages or adjusting WB_DONTCACHE_DIRTY:

mm/filemap.c:filemap_end_dropbehind() {
	if (folio_test_writeback(folio) || folio_test_dirty(folio))
		return;
	if (!folio_test_clear_dropbehind(folio))
		return;
	if (mapping && !folio_mapped(folio))
		folio_unmap_invalidate(mapping, folio, 0);
}

If a concurrent path that dirties a mapped folio without holding the folio
lock (such as zap_present_folio_ptes(), try_to_unmap_one(), or
follow_page_pte() calling folio_mark_dirty() -> filemap_dirty_folio() under
the PTE lock) runs after filemap_end_dropbehind() sees
!folio_test_dirty(folio) but before folio_test_clear_dropbehind(folio):

1. folio_account_dirtied() runs under mapping->i_pages xa_lock, sees
folio_test_dropbehind(folio) is true, and increments WB_DONTCACHE_DIRTY.

2. filemap_end_dropbehind() clears PG_dropbehind via
folio_test_clear_dropbehind(folio) without decrementing WB_DONTCACHE_DIRTY
(unlike filemap_clear_dropbehind()).

3. The folio is not invalidated (either because folio_mapped(folio) is true
or folio_unmap_invalidate() sees folio_test_dirty(folio) under xa_lock), and
when the folio is later cleaned or truncated, PG_dropbehind is already clear
so WB_DONTCACHE_DIRTY is never decremented.

A similar mismatch occurs if PAGECACHE_TAG_DIRTY is still set in
mapping->i_pages while PG_dirty and PG_writeback are clear (for instance,
after folio_clear_dirty_for_io() when writeback bails out early past EOF, or
after folio_cancel_dirty()): folio_mark_dropbehind() sees PAGECACHE_TAG_DIR=
TY
and increments WB_DONTCACHE_DIRTY, and then filemap_end_dropbehind() sees
!folio_test_writeback(folio) && !folio_test_dirty(folio) and clears
PG_dropbehind without decrementing WB_DONTCACHE_DIRTY.

Should filemap_dontcache_edge_complete() avoid setting PG_dropbehind on an
already-clean folio (or use filemap_clear_dropbehind() under xa_lock when
clearing it)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023024548.7112=
3-1-snitzer@kernel.org?part=3D6

