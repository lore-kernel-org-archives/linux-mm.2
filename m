Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10F82606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 02:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c0CqUMzk
Received: by kanga.kvack.org (Postfix)
	id DDA2B6B0B88; Fri, 23 Oct 2026 22:46:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8A616B0B89; Fri, 23 Oct 2026 22:46:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC6A96B0B8D; Fri, 23 Oct 2026 22:46:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A59C96B0B88
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 22:46:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 16F9DC0273
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 02:46:43 +0000 (UTC)
X-FDA: 85355981886.26.339EC82
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1DCB210000F
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 02:46:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c0CqUMzk;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792810001;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mvgYWidB2ymkGBMmzsrgwEECDgS3fTU4/TkGk3i0Pvs=;
	b=wfhDNvWCY7jA781a1fkdVBCzlRa4xAmMWxQEAZtmVodIU5YdE4uuWOd7VIYx/eM1djJhDu
	la6d5W+y3xWDlaPqxzIPH5USICMWs6AcGoHeqSGcIf3H8nLfooordlJQ6jl//IAVwX/NJH
	D57iLnJHpAImAymn2oIuH1fM1L2qGoo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c0CqUMzk;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792810001;
	b=vaCIH16X1wtsFWQABb9KhXNFzCGUEMV/X1NephAuJoa9GHeYhY72ZKbUF9SWHjRy10cR+R
	Rg/qrg26Jsf6Wt/PP7RF2yA/PceOjGAW5xb5GmEcpnn6EzOJBmyuw2uHljnvh5d/fzgizf
	Doj8gRf3jLHREXvcYbbOX5Ra93a4zCo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5DC9E43CB4;
	Sat, 24 Oct 2026 02:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81961F01825;
	Sat, 24 Oct 2026 02:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792810000;
	bh=mvgYWidB2ymkGBMmzsrgwEECDgS3fTU4/TkGk3i0Pvs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c0CqUMzk1as9fDwc4UzwnDt71SlqYqj9jbB/CoOnk3E6aus/rbu646ZKkp90Sv3Mt
	 tMMRoHlQKqMU/75/V6NMlMdLhpX6jHv1SrAt5Bud3+4+t/n1fKO1RWhpq8L4Wmgnlf
	 RzOOf5LQ8HnZPkjGm4AggZdN9gmAUXxT/QEuyOzTnWpNyBxvNsH157GYnMS2Kk6Tzs
	 obF8QQhl1/ykKotvV8Hr+Ju3mqct4E69QbTib7fYqwEaJ90XoOdpdA9IncQOsfBqQN
	 QtGwwSI9jwPgIaDPcAuvlU+PXNOEVzJv80Ks3wpnQpJe9O7NBJ7cVg7XMjydh9kbCX
	 yGYg20aZQ48sw==
Message-ID: <sashiko-outbox-183524@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 7/7] NFSD: drop a shared boundary page only once both
 WRITEs have written it
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mike Snitzer" <snitzer@kernel.org>, "Chuck Lever" <cel@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>
Cc: NeilBrown <neil@brown.name>, "Olga Kornievskaia" <okorniev@redhat.com>, "Dai
 Ngo" <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>, "Christoph
 Hellwig" <hch@lst.de>, "Jens Axboe" <axboe@kernel.dk>, "Matthew Wilcox" <willy@infradead.org>, "Jonathan
 Corbet" <corbet@lwn.net>, linux-mm@kvack.org, "Jonathan Flynn" <jonathan.flynn@hammerspace.com>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <20261023024548.71123-8-snitzer@kernel.org>
References: <20261023024548.71123-1-snitzer@kernel.org>
 <20261023024548.71123-8-snitzer@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 24 Oct 2026 02:46:39 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1DCB210000F
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: pbduhf1s7bzwhdgiw5rtd89nkonuui68
X-HE-Tag: 1792810000-245808
X-HE-Meta: U2FsdGVkX19UxFBJ5GBVjr/Ov+JkqnIBuipyl7Xt/n0j3nR6hA3oYVUyeR0Bxl/tc0wpIh/aoJ08sRAxV2Fn/DoPT+aL7Ci7i+2hNf8hEEg63I1smfVQYDsCZI3d9vVAZswn6t/BKU6qnI7YfLfxNogU+TMhfIASJnzvl0FpqCazl4gHuy1Av+bcd2YAy5LKgVViHVPaeXScbmaBw9bhD8/cFtTzNUsGoCRty131BMy5APU9QqMRRZn96KZOIYTkBSIzUa3DJut4oGaF2QyrCl6pwHzmz+O8AiVjivRXtqD6c8gkgmwjLEQgfKGHTIDu6qWN1ZPKxgKKLXGGWdT8h+mWAei/GeXaZ1EBXfzFKDyPxODVzGvER/yW9nlFupsbl9lTr4wu1XpjTyCfQnkqMOYyN/zTMPImLmaIsQ8t8z3xMfvC9l0LLpJIS2+vmbU8gPlp0VO7pXQZgVUTdqIIqNKqiNH8Op9J3JktC08I6RbDlqOK+aDklgCWmmq0MtDM6UeXfzMuRlRxWuVnl1vaDPRWAbq2MjQ5QKjP3H0Drx4pWsyZNDm1Uh8epGvyranXNfyBhVJ9zhQjY2w67WNnFy7pe5Q/N99KXpCTn3JRnVLQDLerUH0KfWk1x4WuwHoYgJe5pyfEXICMZeKBdpicCvd74EevHSKdUD772eFLSPyc0d4X0y3eXT3Rr29RW3Ci/aoCJsIQNI8LySMubtoYUCzyQ85Z2EiXJRUeVuDaHipIosU6JLejiL8917OE72YpxGMDHv9kGt4tcmLbpBhQliq+jvLZmtqH2K6tPmGwbUGDJ6PFHwy89LmZr1gEoQBkbgSmGwGKWds/NFdCIrDee0vXvauXtNDhy7BQGbpmnIS0jpPMy2/ceiBJW8x/5785IweWwC/xFaeHL/YwiQO7/VdxWEzKZeB90iMj+0KzvVb55dR+i2g4aaDBXz+IwoHLKsg9IpBLYOPVksFdBv8
 /sWpfYHy
 U6dv++dmzNw5XL7TRJGr167I4RYLVcJ0qih7JRChw2eonfHdhp5H9ZR8jamIkg90o0CzkIdgexyDz2Q0DBrM5rsktd8Gd+HYpE1dW6z5E9BIJyuFLOPhGQ/wX2Y/CKPy5AnZNFNidj3jHjCMlPVlUyMG1Bnoew/5WNYu1IAv5ljJ6+sWchVBEKY7mq5QnAHvqRSQZjW7hfgdEQZn8ugC1PUC+pHcc0dL8AS4jbsoisxblIyIxaH6ojiv40lDfeQIKlVotHqHatXvv41z86ItytFxlxhqEnRbrPewo64XL9EeschEb89fjF9wyrOcOtJb/BquD8phl9bCRwKteyOylpYmL3yobbxSHm63UvBd3wBAHmgDYxUOmWl5Pir/DOOY6gvhn5954i9YfexUixKqjww8PGcuXFtcL//+Vc6NIWdaUeix7OFflGmwqGlJ0pBHHNCgC3nv5NGhi03qDL2D1HkSNZ6MEwPHDQAetncZy0bvBN4kqhv345xYSGTaJO3xlJoz8spyMEGgocAqlyBGOHI33GhhQOQMxQbqCZ+bBHF1eWhkqPS9kfg0UMuRfoBEM5+uaTLYLVhsGxOHw1Q7Vu4LGm/a6AELGLQQZL4U/8/a+CnpeigJhLs6X9H+dvsg0+UCgPL0GUyBf+2vsbvXTq4bkOgO8APlHYs+y
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
- [Medium] nfsd: nfsd_write_dio_seg_hold() uses PAGE_SIZE instead of min fo=
lio size
--

commit 49f26acfa03e4ed2bb366e82b2cb9296ee952e69
Author: Mike Snitzer <snitzer@kernel.org>

NFSD: drop a shared boundary page only once both WRITEs have written it

This commit issues buffered DONTCACHE segments of direct-mode WRITEs with
IOCB_DONTCACHE_DEFER so that NFSD can defer marking shared boundary pages
drop-behind until the entire WRITE and its fsync complete. Before writing a
buffered segment, NFSD checks filemap_dontcache_edge_completes() for partly
covered boundary pages and calls filemap_dontcache_edge_complete() once the
WRITE finishes.

> diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
> index ade00dabef187..f151289345c92 100644
> --- a/fs/nfsd/vfs.c
> +++ b/fs/nfsd/vfs.c
[ ... ]
> @@ -1406,6 +1407,65 @@ nfsd_write_dio_seg_init(struct nfsd_write_dio_seg =
*segment,
[ ... ]
> +static void
> +nfsd_write_dio_seg_hold(struct file *file, const struct nfsd_write_dio_s=
eg *seg,
> +			loff_t pos, size_t len, struct nfsd_write_dio_hold *hold)
> +{
> +	struct address_space *mapping =3D file->f_mapping;
> +
> +	hold->first =3D pos;
> +	hold->last =3D pos + len - 1;
> +	hold->complete_first =3D false;
> +	hold->complete_last =3D false;
> +	hold->written =3D 0;
> +	if (seg->claim && len) {
> +		bool one_page =3D (hold->first >> PAGE_SHIFT) =3D=3D
> +				(hold->last >> PAGE_SHIFT);
> +		bool head =3D hold->first & ~PAGE_MASK;
> +		bool tail =3D (hold->last + 1) & ~PAGE_MASK;
> +
> +		/* Only a page the segment covers partly is shared. */
> +		if (head || (one_page && tail))
> +			hold->complete_first =3D
> +				filemap_dontcache_edge_completes(mapping, hold->first);
> +		if (!one_page && tail)
> +			hold->complete_last =3D
> +				filemap_dontcache_edge_completes(mapping, hold->last);
> +	}
> +}

[Severity: Medium]
Should nfsd_write_dio_seg_hold() compute one_page, head, and tail using the
mapping's minimum folio size rather than PAGE_SHIFT and PAGE_MASK?

In nfsd_write_dio_iters_init(), misaligned direct WRITEs are split at
mapping_min_folio_nrbytes(nf->nf_file->f_mapping) boundaries:

	cut =3D max3(offset_align, PAGE_SIZE,
		   mapping_min_folio_nrbytes(nf->nf_file->f_mapping));

And during vfs_iocb_iter_write(), iomap_get_folio() treats a folio as a
partly covered edge unit whenever the write does not cover a full
mapping_min_folio_nrbytes() unit, setting FGP_DONTCACHE_EDGE and
FGP_DONTCACHE_DEFER so the page cache leaves the folio unmarked for the
caller to complete:

	if (iter->flags & IOMAP_DONTCACHE) {
		size_t unit =3D mapping_min_folio_nrbytes(iter->inode->i_mapping);
		size_t off =3D pos & (unit - 1);
		...
		if (off || len < unit) {
			fgp |=3D FGP_DONTCACHE_EDGE;
			if (iter->flags & IOMAP_DONTCACHE_DEFER)
				fgp |=3D FGP_DONTCACHE_DEFER;
			len =3D min_t(size_t, len, unit - off);
		}
	}

Likewise, filemap_dontcache_edge_completes() and
filemap_dontcache_edge_complete() check filemap_dontcache_edge_unit(), which
tests folio_nr_pages(folio) =3D=3D mapping_min_folio_nrpages(mapping).

On a large-block-size filesystem where mapping_min_folio_nrbytes(mapping) is
larger than PAGE_SIZE (for example, 16 KiB blocks with 4 KiB pages), if two
neighbouring WRITEs split a 16 KiB minimum-order folio on a 4 KiB PAGE_SIZE
boundary, iomap_get_folio() defers dropbehind marking on that folio via
FGP_DONTCACHE_DEFER, but head and tail in nfsd_write_dio_seg_hold() both
evaluate to false. Wouldn't that leave the shared folio unmarked in the page
cache until reclaim, or cause a partial segment spanning multiple base pages
within the same minimum-order folio to treat hold->first and hold->last as
two separate pages?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023024548.7112=
3-1-snitzer@kernel.org?part=3D7

