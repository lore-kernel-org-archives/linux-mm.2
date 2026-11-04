Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA730606A86C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 21:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BidcTP/5
Received: by kanga.kvack.org (Postfix)
	id 126E46B05D0; Wed,  4 Nov 2026 16:18:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DDB46B05D2; Wed,  4 Nov 2026 16:18:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F10366B05D0; Wed,  4 Nov 2026 16:18:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C024F6B05D0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:18:20 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2AB59C0879
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:18:20 +0000 (UTC)
X-FDA: 85398699960.07.AA3465F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 90D3B40004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:18:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BidcTP/5";
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793827098;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pdvRclRIQJdcmEx+gaHAManRv1uAlybfn5yDzrPAMmc=;
	b=zpxDFtafff3AH0kWjZ1BMMKP8UDu9TIFEBUfDBCmWLhYUVdV2SqAxWtE8n52d71933M95b
	1m820WYEOw5/33wFZ3mmaos7aFMS67U18R+1le3k3KaVGY0mupZGCFiYdmFqpv+loDguIn
	mjfvIe475TXyywMLYfwaTC6ivVqyH64=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793827098;
	b=4eN/VS/NroExNQquoRH17+u49CIlY/uOgz6ckhzR1iCGISmi8HRzxotW3xLUE2+zKF5QRF
	oivSbC5/w0CnNu81seopWqrcj3xcIrHpFcC2rcq7LSCiEZ4IimTkVccnDOH2zY8g7robmr
	nQWqVZxZl5qA2oyGxemOE4vzJp5Sl1c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BidcTP/5";
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 21F43636FD;
	Wed,  4 Nov 2026 21:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473681F0093A;
	Wed,  4 Nov 2026 21:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793827097;
	bh=pdvRclRIQJdcmEx+gaHAManRv1uAlybfn5yDzrPAMmc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BidcTP/5/ITjp7bWup/nsFz6HQcwqBz/m7XDzg17uD24bzBaB8uGf7tMdsdiBG5KU
	 2RXlkclRhX/IGbc/MQVPCGjKtgQvvkz+mahZuXJAgTzirXoO+vTFC7iEt9ouUytfeP
	 YdPUJyfYU8YhDixmg9tPdZASrhquFpMXe4EhFES6ppPSKsz5+J2eqsyGxvCJ/LGY7t
	 csmrpeDVDzG+SPZro6uQcau60MUBT5AjdK9rGic4aSwvT3gq282jP0IAXxKsXBo+j/
	 CnMnmnZ7MZToG4ZbyIvTNsNo0qUAjoNmkbu0o9wqjjlH9XaM+HNAMFajxu+1bmK6Ai
	 4h7eLWY6oZKbw==
Message-ID: <sashiko-outbox-198089@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 6/7] mm, iomap: let an uncached writer complete its
 shared pages itself
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mike Snitzer" <snitzer@kernel.org>, "Matthew Wilcox" <willy@infradead.org>, linux-mm@kvack.org
Cc: "Chuck Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, NeilBrown <neil@brown.name>, "Olga
 Kornievskaia" <okorniev@redhat.com>, "Dai Ngo" <Dai.Ngo@oracle.com>, "Tom
 Talpey" <tom@talpey.com>, "Christoph Hellwig" <hch@lst.de>, "Jens Axboe" <axboe@kernel.dk>, "Jonathan
 Corbet" <corbet@lwn.net>, "Anna Schumaker" <anna@kernel.org>
In-Reply-To: <20261103211754.35352-7-snitzer@kernel.org>
References: <20261103211754.35352-1-snitzer@kernel.org>
 <20261103211754.35352-7-snitzer@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 21:18:16 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: gzqf9hpe6i5ce7rmkkyqewd69z1w75pn
X-Rspamd-Queue-Id: 90D3B40004
X-Rspam-User: 
X-HE-Tag: 1793827098-7434
X-HE-Meta: U2FsdGVkX18z2467HRPmCwIExwBSZmEA6mqhcdHiFAG7urie2MWk/MO9hyPZZIUu68KZWCQxOta26j2LOObANyTHO2U3EEa9EieC9yWbAWxZwMnKylKs262KoGYmlI2H7FbxEdV/XHEwXi+0rG8R0C0VKOoJC+kGoo7T/KfBlkUMaEAk3ApQaQw4BZRppVv7UqSQVNaGL+goFP6CjRekHTbBqi+Huhuih1bImPKzvq7xY7m/UX34RGw43jrHBteZAdj3JuOtfNB8pze87Mq2ao8tNUe4tTeQiRpAe3fmUZnkerXys7VipvQbSO3Qd2bP/QLeZwCUIisqzhcMLpygFywDcNJMfGZ3LLtqHzKg7XzNgtMRwjwC/4ZNph68AIAbsvSV+e5D2fe3XwHSU0CZvk5HKp0lcYfqvu/TPdFh1g9ywDihd/UzqC850zD2HUr4iyAuMTfirIap4OtfFkeRRRBk8PAloVqLtLVRkVU+7moVkoeaiVu+NJJ8I5FhyDKkx13prH/fz2wXOeRH/IeItl9dHgSdjs1jbEmP41nSZkxmLp6pzw+OHZJTuo61xnY26AYlMHRhsx9SuW4+ebiOpHsvJdaCsYgPHTjarlasO166NoMTVcUKDJ6REIHtNaq9c8mbimXrST/R/KmY9LlL5+LTdmVDS0A8wuCiYAAHMwdsre8cdMjgW1ZBaTT8ZyAiWJWyWer/QFjcdGlbFU0NrItpbkUxrWDhGRaCOnF7izl7cWXussQWgGGdzyNvJAJdQAzebiXjYvirBcXTogHh2ccPFukiUG8B6SMZneD+PHyqrRgV4NVI0EPFMfQgBgu/VZm6PYMDi2tuRBe72F0tCxYQT351DNIS6IbhxnDFTizF/qpYHjt51E1PvevcjkkQUFvEt5zGeiXICex4idxBLpIszkI28Pf0OSt58RCF24t7Z04RpComDwP8A3hkxdEKrC4LUlgqwtHHzOo0fKW
 JOfgB0hW
 Li3us7yFqo4Z4jg9RHiD/nt1lELKydyHv7s0h21vrZjyCY2Jl6tA+B5Gv90S2y7wamZpAvnblrE3ZJ2EBe6YLkH304vgujC4XXooXL0hgFYeCdjYcfcZr4Bx+m1lMNHLxmm/lgM2nfLNN6MLVYeAI+nB0TVF0jj63opP1ZXaQfUi36t/w1fJalTUxzrI3FiLQJqkupTSuq9SaRC0TZU3xS2awewAalixId2aHHkGd6EV9LiAWKz4AiJwXdm/JuAq50EQ9m3aqddlHDZvz93PhLam9PcZ5lK48NOh8JFS7C9GpYwle9IKliG1Bogtef6jprE8BfsDBzDi5l2zLF13aBqcWnccBz/kdZOVARm+dcvCxWLJrSx7EUKaF5HJbFKJvjuXhoAVpG0tjlaQgJtkQpKuYlT7m0nNSrIlTEhdiO37vADpAXuKF3pjq6OjP+jl+8PBOOo3RXdpEoIqCju3vFbpyQ5Wtg+fqCnL+S1mm72vSRLNGYJfk3oIACb5+tS3sohOkkKO1UDIILRypfz67dQV3By7LGj9zkDEBDn3vJFv4Y2ggCI617XnWxSoTMwAAD4f01KrIEMi0NIluwz7Zsy1adPTDbma+nxVB7Sa8/1w+ljjTCqpRkoWvtu4/yNjIx8MPwTEHA6N1g4Zik6VDm0pfjcT2+7tqf3Jw
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
- [Medium] iomap: iomap_get_folio() leaves full multi-extent folios unmarke=
d on defer
- [Medium] mm: filemap_dontcache_edge_complete() marks already-clean mapped=
 folios
--

commit d5e1d223215324d0e85a0ac810137acfb41ade9f
Author: Mike Snitzer <snitzer@kernel.org>

mm, iomap: let an uncached writer complete its shared pages itself

This commit introduces IOCB_DONTCACHE_DEFER, IOMAP_DONTCACHE_DEFER, and
FGP_DONTCACHE_DEFER along with filemap_dontcache_edge_completes() and
filemap_dontcache_edge_complete() so an uncached writer can defer marking or
dropping shared boundary folios until after its write and sync finish.

> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 919e4d6c3c972..c47fa683aaa8a 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -812,6 +812,8 @@ struct folio *iomap_get_folio(struct iomap_iter *iter=
, loff_t pos, size_t len)
>  		/* A partly covered unit is shared with the neighbour. */
>  		if (off || len < unit) {
>  			fgp |=3D FGP_DONTCACHE_EDGE;
> +			if (iter->flags & IOMAP_DONTCACHE_DEFER)
> +				fgp |=3D FGP_DONTCACHE_DEFER;
>  			len =3D min_t(size_t, len, unit - off);
>  		}
>  	}
> @@ -823,7 +825,7 @@ struct folio *iomap_get_folio(struct iomap_iter *iter=
, loff_t pos, size_t len)
>  	 * With blocks smaller than the folio, an edge is not uptodate
>  	 * until this write completes it.
>  	 */
> -	if ((fgp & FGP_DONTCACHE_EDGE) &&
> +	if ((fgp & FGP_DONTCACHE_EDGE) && !(fgp & FGP_DONTCACHE_DEFER) &&
>  	    !IS_ERR(folio) && !folio_test_uptodate(folio) &&
>  	    folio_dontcache_edge_written(folio, pos, len))
>  		folio_mark_dropbehind(folio);

[Severity: Medium]
Can this leave a newly allocated folio that a single write covers in full
without PG_dropbehind when the folio spans multiple extents or hits a
short-copy retry?

In iomap_file_buffered_write() -> iomap_write_iter() -> iomap_write_begin()
-> __iomap_get_folio() -> iomap_get_folio(), the len passed to
iomap_get_folio() has already been clamped to the current extent length
iomap_length(iter) (or narrowed to copied on a short-copy retry) rather than
the remaining write length iter->len.

When i_blocksize(inode) < mapping_min_folio_nrbytes(mapping) and a unit that
the write covers in full (off =3D=3D 0 and iter->len >=3D unit) spans two e=
xtents:

1. On the first extent, iomap_get_folio() sees len < unit and sets
   FGP_DONTCACHE_EDGE | FGP_DONTCACHE_DEFER, so __filemap_get_folio_mpol()
   allocates the folio without PG_dropbehind.

2. On the subsequent extent covering the rest of the unit, off !=3D 0, so
   iomap_get_folio() again sets FGP_DONTCACHE_EDGE | FGP_DONTCACHE_DEFER.

Previously, iomap_get_folio() called folio_dontcache_edge_written() on the
final extent of the folio, saw that the earlier blocks were uptodate, and
called folio_mark_dropbehind(). With !(fgp & FGP_DONTCACHE_DEFER) skipping
folio_mark_dropbehind(), and because the unit is completely covered by this
single write rather than being a shared boundary edge passed to
filemap_dontcache_edge_complete(), won't the folio stay in the page cache
unmarked until reclaim?

[ ... ]

> diff --git a/mm/filemap.c b/mm/filemap.c
> index ec52e4c960849..d540df29870a9 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1721,6 +1721,76 @@ bool folio_dontcache_edge_written(struct folio *fo=
lio, loff_t pos, size_t len)

[ ... ]

> +void filemap_dontcache_edge_complete(struct address_space *mapping, loff=
_t pos)
> +{
> +	struct folio *folio;
> +	bool kick =3D false;
> +
> +	folio =3D __filemap_get_folio(mapping, pos >> PAGE_SHIFT,
> +				    FGP_LOCK | FGP_DONTCACHE, 0);
> +	if (IS_ERR(folio))
> +		return;
> +	if (!filemap_dontcache_edge_unit(mapping, folio))
> +		goto out;
> +	/* Writeback in flight was submitted unmarked and would not drop it. */
> +	folio_wait_writeback(folio);
> +	if (folio_test_dirty(folio)) {
> +		folio_mark_dropbehind(folio);
> +		kick =3D true;
> +	} else if (folio_mapped(folio)) {
> +		folio_mark_dropbehind(folio);
> +	} else {
> +		/*
> +		 * Drop it now, unmarked: a mark cleared outside the i_pages
> +		 * lock could miss a store that counts the folio.
> +		 */
> +		folio_unmap_invalidate(mapping, folio, 0);
> +	}

[Severity: Medium]
Should filemap_dontcache_edge_complete() really set PG_dropbehind on an
already-clean mapped folio?

After folio_wait_writeback(folio), if folio_test_dirty(folio) is false and
folio_mapped(folio) is true, the folio is already clean and has no writeback
in flight or scheduled for it. Even if it is dirtied later via mmap and
written back, filemap_end_dropbehind() clears PG_dropbehind without
invalidating when the folio is mapped:

mm/filemap.c:filemap_end_dropbehind() {
	...
	if (folio_test_writeback(folio) || folio_test_dirty(folio))
		return;
	if (!folio_test_clear_dropbehind(folio))
		return;
	if (mapping && !folio_mapped(folio))
		folio_unmap_invalidate(mapping, folio, 0);
}

Leaving PG_dropbehind set on a clean mapped folio seems to cause two proble=
ms:

1. If the folio is mapped read-only or never dirtied again, PG_dropbehind
   remains set on the clean folio (suppressing folio_mark_accessed()), and =
if
   the VMA is later unmapped, a subsequent normal cached filemap_read() will
   drop the folio via filemap_end_dropbehind_read() ->
   filemap_end_dropbehind().

2. As noted in the comment right below in filemap_dontcache_edge_complete(),
   clearing PG_dropbehind outside the mapping->i_pages lock can miss a store
   that dirties and counts the folio in WB_DONTCACHE_DIRTY. On a mapped fol=
io,
   zap_pte_range() can call folio_mark_dirty() -> filemap_dirty_folio() ->
   __folio_mark_dirty() under the PTE lock without holding the folio lock. =
If
   filemap_end_dropbehind() runs on this clean folio (for example from a
   concurrent filemap_read() -> filemap_end_dropbehind_read()), can
   zap_pte_range() set PG_dirty and increment WB_DONTCACHE_DIRTY under
   mapping->i_pages lock right after filemap_end_dropbehind() checks
   folio_test_dirty(folio) and before it clears PG_dropbehind with
   folio_test_clear_dropbehind(folio), leaking WB_DONTCACHE_DIRTY?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103211754.3535=
2-1-snitzer@kernel.org?part=3D6

