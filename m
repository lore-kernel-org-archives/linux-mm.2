Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B88A5606A322
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 22:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R5FjYOcv
Received: by kanga.kvack.org (Postfix)
	id E42576B05B1; Sun, 25 Oct 2026 18:12:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCB716B05B2; Sun, 25 Oct 2026 18:12:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D08626B05B3; Sun, 25 Oct 2026 18:12:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 860A96B05B1
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 18:12:15 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D37DA805FA
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 22:12:14 +0000 (UTC)
X-FDA: 85362547788.22.8FA0E98
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2191640004
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 22:12:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R5FjYOcv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792966333;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YWbxq42hxi+ZRNzF4dCjYVmcYAoQXgJd485ElFkPZis=;
	b=4G0BY2M90ACAjDKoGyWvp5YvW3HdyIRpbmwQLbKTNXfj3terMZmSo9gj4Q/ed7HOx7xS7z
	vydfGHZhQW7a9Q7cHRdurrWVzCdm6uEyFVc6Ju+7saXrIHfIf6tdSWH/D8YJMIZJG6YrNp
	o1bzMrpj3FR3S2kbVWybx2IfRr73n+g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R5FjYOcv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792966333;
	b=ecnjQkGA6CBwvHa7Xe1pGND4SudY2uryzdnLyYpOGJaMsNN3pk2qZfknUdJ+IpNSz+W4od
	yTlCRjikpsf94VGLvog//dokysv7jnRgHcqE9D0cCgmHhJxnbHQ7Zoj00UkyAgV3Adpmcg
	niZpGbTJnTtIjoc1yt5x+dhZcSnNg6s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 013E54142D;
	Sun, 25 Oct 2026 22:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DEBF1F01825;
	Sun, 25 Oct 2026 22:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792966331;
	bh=YWbxq42hxi+ZRNzF4dCjYVmcYAoQXgJd485ElFkPZis=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R5FjYOcvqohSIgPwLI4i+LWeeP5xsuMSFCyDwl4Fs4HT2mExxT/p5ySU+cD/oi6uI
	 z6/y9ul53m/7zUwQLmOdPsj8Py75WT5nx4OAoxj1sWgJiXGHJYfzh2GW4Rthw1tvC+
	 mYiOm/5OU3IFty7A8EL+iAtTca2n40vd3dcSEMZxNTMmD9nEFcDfWugEcGqXxgf+f5
	 G0317IYmzfQA7ElvaoloA0CpbJ8Qo54cOc5iMoQPX5XQPLKgdlhWDeQ2izxqdONNbL
	 RsE++qcMnUNp2m4RQmNVjPbEacyOPEk+tgGIfXCkcw9ii7LzzP4ve6SrXfHJ34ySCY
	 TF2RtPXqI9LKg==
Message-ID: <sashiko-outbox-184467@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 6/6] NFSD: drop a shared boundary page only once both
 WRITEs have written it
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mike Snitzer" <snitzer@kernel.org>, "Matthew Wilcox" <willy@infradead.org>, linux-mm@kvack.org
Cc: "Chuck Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, NeilBrown <neil@brown.name>, "Olga
 Kornievskaia" <okorniev@redhat.com>, "Dai Ngo" <Dai.Ngo@oracle.com>, "Tom
 Talpey" <tom@talpey.com>, "Christoph Hellwig" <hch@lst.de>, "Jens Axboe" <axboe@kernel.dk>, "Jonathan
 Corbet" <corbet@lwn.net>, "Jonathan Flynn" <jonathan.flynn@hammerspace.com>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <20261024221152.6965-7-snitzer@kernel.org>
References: <20261024221152.6965-1-snitzer@kernel.org>
 <20261024221152.6965-7-snitzer@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 25 Oct 2026 22:12:10 +0000
X-Rspamd-Queue-Id: 2191640004
X-Rspam-User: 
X-Stat-Signature: 1sonnx4karaaxbhrj691yfob7meetaey
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792966332-629830
X-HE-Meta: U2FsdGVkX1/CnSeX5rhbOpEb90oJomDrqOF7NOfl4GbdixqSZamP6U1Doe+rx/vaacbj3rH8PBRY5RL5vfqATwkJKaxeeffZFvKYnMoa9KfrXZG4aQURwLxD9Wv1CW4reuf74iomParC3vEWDRms2a+b3kdps/l+DM6vUxBohO3d/UhzF5zo9NYopk1JnQ2lSLwgrXHNokbhFti12sorxw693kiKnWVy6JQDeuFgC5Pvso6+2G3jjRGEKvz/c0G28nMJhoWB5mp8Dw7IvTGGar+pDge+LwXryGYe9qqU1CSuXELRCLfnUFSoGOU0m3h0Mh3h4nMsm3q8/xGoaURFAYSwf8Mk1fBPbYq8ve9/sZO+YF34dFYRTt89ZrvLHELOz536LuruyNFydQ4vEwBkHTpWIxVxHDqvz8KHPXDv9gHf05zGYOe1rUnIKS3Dxky/DygDfGuYENAHWeRz2XxbRL1wgMA7Yzn/swBABa+47lY4olTCFyoKRDa82y2USbFnhbIol5khJ4xn8bIrCFQp/iJR0CyC9xJSJhnXPV1Lex/ly9sQ9RprwZIB4U5NJucRTzQhDEe6ncijzATGJ+7KqgDuhUTYx7wOKyjJBJ1bsLjz1kwFqQcaXi8/YRgETTZiJBTgDcSPhx1kwJvdoAm/lbfm532cR+8X9FaKewqR9wJ3C6TK/XqInChteXksQYQQ3mJ07rIo74B69DzpuuhosMAdRIMgw7ep3bR2xnSfjgOxyb1NNl3I7DOBSprF3aO6JfPHsHheyms/oL3o7wuYv10++54URu/TTiUFrHvxqYOy89/egDGt7G7QDQIqKG2sgNEAzz220FjxKStoq4tp+bRo1iwOtx3QJ9gf2X6uWo1U+o2iLnDC0xtFiILoo68V5MMd09v7gVa8JrHHZ7Uk7FO+ZVRge0Caq6P8Z6T+ldrqkhq8+0qyPftUJv7QrODg4d6Xx3c73TT64+SkVfF
 cJZfaS5C
 ZRcGDtQUgsCCnc7Gmveausys6gHbKF1G2P5USouAy6Y+O6yAXQ3okskl0iddWXAK6z9hq8K6/dWupY2ZZUmN2DLOtTemn/klkeItpVCS8MVmCSr18a243snMvYIbdQzHz7u2xaPMqk/quEQSYJNFQS5uT7hbkWsXQbdm8fj6yHUYTLn1Hw0dRVnFIrLdnHUvoRv36GDFabmhy7xr2M1XkFd69f4bNtFDgq+4+I352WAfcJCNoRLEoDRt29Ay8kPfiwmNGP3hao7C3chUbs3PiSUYU5+/9ecX1V/8zvgCg4bi8AHoCzWeB4coKPnAiXQMkyrCogIDrjnx+khyQa64E7AI4YKCu8DcNrvKy87f4as4SMtIAt7sUhJJq7Y2lbSdoNXxWEixoxczdqhw52jctuvi4HGZ3CVeEINS6dLuCVjIVMG7aS1W0o/Idvht1/9PMk6BlWiaOqFEyTt26hQ7L5yUemEvT5YmeaYhE2U7JlVMMixOxkW++ocUPqRucIUHW5HwXQx7N1+IFyMRbfGiA52FWlo43MN1ZDxxU8l6Wj31XZUcreZ+Pj3kFM4E5lqEslAjhnSv0Lva5N9kEHDXXtqHfN6dbivt8pGHiTNG/gac5rBp0Qu3a+rZhFMHGXg54//YEIPYrZIqPlvlgIfgDH+vXiZMZxgfHpeeP
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
- [Medium] nfsd: cut misaligned segments at min folio size in nfsd_write_di=
o_iters_init()
--

commit 539f478b663513be1ed1736c065becca6e5a5016
Author: Mike Snitzer <snitzer@kernel.org>

NFSD: drop a shared boundary page only once both WRITEs have written it

This commit defers dropping shared boundary units during buffered
segments of direct-mode writes by passing IOCB_DONTCACHE_DEFER and
calling filemap_dontcache_edge_completes() and
filemap_dontcache_edge_complete() around the write and fsync.

> diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
> index 9219f8eb386d0..0b62c4659e547 100644
> --- a/fs/nfsd/vfs.c
> +++ b/fs/nfsd/vfs.c
[ ... ]
> @@ -1406,6 +1407,82 @@ nfsd_write_dio_seg_init(struct nfsd_write_dio_seg =
*segment,
>  		iov_iter_advance(&segment->iter, start);
>  	iov_iter_truncate(&segment->iter, len);
>  	segment->flags =3D iocb->ki_flags;
> +	segment->claim =3D false;
> +}
> +
> +/* The shared pages a segment completes, and how much of it was written.=
 */
> +struct nfsd_write_dio_hold {
> +	loff_t	first, last;
> +	size_t	first_len;	/* the segment's bytes in its first unit */
> +	bool	complete_first, complete_last;
> +	size_t	written;
> +};
> +
> +/*
> + * A page that a buffered DONTCACHE segment covers only partly is shared=
 with
> + * the neighbouring WRITE.  The page cache keeps it, unmarked, for the w=
rite
> + * that completes it; the segment is issued IOCB_DONTCACHE_DEFER so that=
 this
> + * WRITE, not the page cache, marks it, once the whole WRITE, its fsync
> + * included, is complete.  Ask whether the neighbour has already written=
 its
> + * part immediately before writing @seg: asking earlier gives the neighb=
our
> + * time to write its part and find this WRITE's part missing.
> + */
> +static void
> +nfsd_write_dio_seg_hold(struct file *file, const struct nfsd_write_dio_s=
eg *seg,
> +			loff_t pos, size_t len, struct nfsd_write_dio_hold *hold)
> +{
> +	struct address_space *mapping =3D file->f_mapping;
> +	size_t unit, last_len;
> +	loff_t mask, last_unit;
> +	bool one_unit, head, tail;
> +
> +	hold->first =3D pos;
> +	hold->last =3D pos + len - 1;
> +	hold->complete_first =3D false;
> +	hold->complete_last =3D false;
> +	hold->written =3D 0;
> +	if (!seg->claim || !len)
> +		return;
> +
> +	/*
> +	 * The unit two writes share is the smallest folio the mapping allows:
> +	 * a page, or a block where the block is larger.  Only a unit the
> +	 * segment covers partly is shared.
> +	 */
> +	unit =3D mapping_min_folio_nrbytes(mapping);
> +	mask =3D ~(loff_t)(unit - 1);
> +	one_unit =3D (hold->first & mask) =3D=3D (hold->last & mask);
> +	head =3D hold->first & (unit - 1);
> +	tail =3D (hold->last + 1) & (unit - 1);
> +	last_unit =3D hold->last & mask;
> +	last_len =3D (hold->last & (unit - 1)) + 1;
> +
> +	hold->first_len =3D min_t(size_t, len,
> +				unit - (hold->first & (unit - 1)));
> +	if (head || (one_unit && tail))
> +		hold->complete_first =3D
> +			filemap_dontcache_edge_completes(mapping, hold->first,
> +							 hold->first_len);
> +	if (!one_unit && tail)
> +		hold->complete_last =3D
> +			filemap_dontcache_edge_completes(mapping, last_unit,
> +							 last_len);
> +}

[Severity: Medium]
Here in nfsd_write_dio_seg_hold(), the shared page-cache unit size is
computed via mapping_min_folio_nrbytes(mapping) to account for large
block size filesystems where the block size exceeds the base page size.

However, in fs/nfsd/vfs.c:nfsd_write_dio_iters_init(), the boundary
between the buffered prefix or suffix and the direct middle segment is
still cut at max_t(u32, offset_align, PAGE_SIZE):

	cut =3D max_t(u32, offset_align, PAGE_SIZE);
	prefix_end =3D offset;
	if (!IS_ALIGNED(offset, offset_align))
		prefix_end +=3D min_t(loff_t, cut - (offset & (cut - 1)), total);
	middle_end =3D orig_end;
	if (!IS_ALIGNED(orig_end, offset_align))
		middle_end =3D max(round_down(orig_end, cut), prefix_end);

On filesystems with a block size larger than the base page size,
nf->nf_dio_offset_align can still be the underlying block device logical
sector size (for example, 512 or 4096 bytes), such as for non-cow XFS
inodes in fs/xfs/xfs_iops.c:xfs_report_dioalign():

	stat->dio_read_offset_align =3D bdev_logical_block_size(bdev);
	if (xfs_is_cow_inode(ip))
		stat->dio_offset_align =3D xfs_inode_alloc_unitsize(ip);
	else
		stat->dio_offset_align =3D stat->dio_read_offset_align;

When offset_align is smaller than mapping_min_folio_nrbytes(mapping),
nfsd_write_dio_iters_init() cuts prefix_end and middle_end on a base page
boundary inside the minimum-size folio rather than on a unit boundary:

1. The direct middle segment shares the minimum folio with the buffered
   prefix or suffix, so kiocb_invalidate_pages() synchronously writes back
   and evicts the entire minimum folio just written by the prefix (or left
   cached by a neighbouring write for the suffix), and the buffered suffix
   starts at an interior page offset within the unit, forcing iomap to
   read back from disk the bytes just written by the middle segment.

2. If both the buffered prefix and suffix fall within the same minimum
   folio (for example, on a 64 KiB block size filesystem with 4 KiB pages)
   and an earlier write already wrote the leading bytes before the prefix,
   nfsd_write_dio_seg_hold() sets holds[0].complete_first =3D true for the
   prefix. After the middle segment evicts the folio and the suffix
   re-populates only the prefix-through-suffix range for the next
   neighbour, nfsd_write_dio_seg_release() for holds[0] calls
   filemap_dontcache_edge_complete() on that same unit and drops the
   incomplete folio before the following write arrives.

Should cut in nfsd_write_dio_iters_init() also take
mapping_min_folio_nrbytes(nf->nf_file->f_mapping) into account so that
buffered prefix and suffix segments are cut on unit boundaries?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261024221152.6965=
-1-snitzer@kernel.org?part=3D6

