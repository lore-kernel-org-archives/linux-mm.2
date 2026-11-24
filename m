Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 713F2606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 12:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OPOIiXph
Received: by kanga.kvack.org (Postfix)
	id 8DD186B06A1; Tue, 24 Nov 2026 07:27:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88D8B6B06A3; Tue, 24 Nov 2026 07:27:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 756286B06A4; Tue, 24 Nov 2026 07:27:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 44D8F6B06A1
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:27:00 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CE25B40B7F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:26:59 +0000 (UTC)
X-FDA: 85469936958.30.EE40E15
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2FF5E1C0009
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:26:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OPOIiXph;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795523218;
	b=FVQ+QcMjCprkw2xwyD7kTLK/BYW8k48HmVv8Dl6PYQmL8Z7bvmyl4FYa7C8DCtgPwaHhYb
	N6tdHGZ0WGUcShL1hoUnesj/Duznbzb3FLbnfUeSfX7lpT2fcqVKbkvmFMvLNU0xmuiffc
	jiFAkxqMBHMG6RfPpsYeM30mXtrOdq8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795523218;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WzuIVI+ekCnKdOqeQi3VC7VRdm/iEBnAWTV/aqfS9X8=;
	b=dt0xxhUttSfdAkYURPIGolkNJthAiV7J/21siWzyx54P+WFJ+r+s05um5aSEhusPBX+qUG
	IswxtVEZs+lbfOarYf5e+vD5cFCOijMtS3xNbR4/rUqq8cOc2C08mmhRzrH2DGcZaDu8Mw
	+CvIwYDIt7GPUiS4mZuvdTpfHkI1STc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OPOIiXph;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0442362124;
	Tue, 24 Nov 2026 12:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB7F1F000C0;
	Tue, 24 Nov 2026 12:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795523216;
	bh=WzuIVI+ekCnKdOqeQi3VC7VRdm/iEBnAWTV/aqfS9X8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OPOIiXphl+0XhxlikQvu0/cwULpyJFR4gE23TSHLb8Momyd3a0AjpbvlYPrlXVumh
	 gHb8pR8uFg/MnWVgVJJIoF/OMXhS2J8pvcD+9M3UEMrDtljnCt9hSY/NmKRhFGOO8K
	 JYqOT1En7Si7VL1gpW3635hq/c7Upl+yEPYQgLDkwzNnotFBqQhiA+5TmwFQ/w3Brv
	 7iC0I+YyWF1I+7HA57DX8JTWSicUx0ma0xjySWFcLHn3Rm6wgdC17Oa5RqPoxfMwXM
	 UWjzkmR8lM2tV6IL6vSw4a9OTo1trBb5N8Ggthv3qCpHwvtvIiFYhn8xqWy70u8pZk
	 2t1bfaYWv2/WQ==
Message-ID: <sashiko-outbox-231134@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH] mm: shmem: fix discarded data left intact after
 truncation or hole punching
Reply-To: sashiko-reviews@lists.linux.dev
To: "Baolin Wang" <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org, david@kernel.org, hughd@google.com
Cc: linux-mm@kvack.org
In-Reply-To: <6fcc15c466667f6943c34e130212b891b7471c83.1795436423.git.baolin.wang@linux.alibaba.com>
References: <6fcc15c466667f6943c34e130212b891b7471c83.1795436423.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 12:26:56 +0000
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 2FF5E1C0009
X-Stat-Signature: e5cssmy75njjydtqymbkeu9oxdwgnith
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795523218-526896
X-HE-Meta: U2FsdGVkX1/VJ36LaoU57F/c22JSeLqojKi5NbAFX9FwVHK3oZUOgCLrTYtuTaXiubhqoZ2n/F+8Lv9BgjYtLlFHugCHVip4OJsDg2SZ+w/gxFnLrTtshzywFpJ11pZlvMTn11TelJwv6hxNdFNGa+qqa8szVpg+nMIwN5SxZd2u8XGfHoLWsE0Nttnm8JH172XUup29pGwpWjT8IW/fmvYa6pl5qR2tKxdgi1S/+rks+9IBXE0AkIscdY1SUg2N7f46oUskGeLwQiij+dqrgXvp6upfb8ZxHi+CrxoxLgAM2cDOykRRc9gH6VbnkDv/ZjAG9sn7eaklsmuXyaaD3/3JuDdYepWcx/uC/oiKNOaBSeIUslyxbkTvvUZwIcobDa2fu4KoBvd3woAhdo8Q47Ec2wOpLVU0CUbZRKRNLIwbmNuZmGekrB8FISW0YhNdikFUOuJs65VjhDevChqA2crc3K5UmTByOjyJ9P31Rxib5w1CQQauqBhJoITkIdyW7vJIJsbeDJIicHeaTvP/3NoQbhSnhLjbA8b+iuYvc1xiM7/4ELCXyPW5ZanQMRucM3fsXShgjl86jLp5xZUUD3+6sJMgQz0lPa1F2/E2h/djyxCn72idn+QPvt7/WLia2u+4FIDauaOaOVs/MkUD2jmGi6Kdtb+ZIwGuGRR2b2DsbNwZmPahlscoCTs4B97nRhWd3yBod/Kv0kpl00ByDL58dGVHvLL4kxQS7Hn8fP7J5Kasjr39D3kZYgBscF5PeqD1Ds7JyoNQJEWwoWIZa8UjSLIgRlwx4TzSa7Yim0zeKRDs0Fe7w+wceHWAmqFuF9gY5KUUxGhdVv5yWmVNgY073CJyQUxRPDZpk/OsgAOovObkD7ZV9AH2aZBGyqRh7A6EWi4XV+wesHh362Ej+HVo18Le7M+Rzy4JJn/HqvKdDYGmNoMn1MT0v4GSMlx+GpFj+FIRPk7KIOkic7P
 YK1a0VBX
 DSTIXsXJlAEjc2Vpl+3zmGD6ZRIzAgLPlM/ZRaOwmp/6BJRQwLikk/HGWymYqVHfWGPtcVkH0IrENcOkOLi6db+3+9M3+dnz4WZ9q5dJTHddprP1KimGaoXah9eFhnvyeuRIGcrCc6VlevskJ0SdHZwN3HSnlUEvx6Hdmoit1shbiM7QwV4IXFLbKD2EiLBeQ2TFyYgw+TLGsG6cjS7ivX82oZ2lOgc5zfYrx6f9/URjeQNdJIVUEu2VU1ihkVE6d8ZKZR/xzoG2dZhN6otq5lhDE7DsM+fcOcxemGhEg2eOM8kUG+LtoAGhQRYicpjy/RrTFndDtHRN1drLGmDMbHa+KY/KCC2FeSeSXkGJJDFsAMsI5VMUTfV751I7yIdNMqxudQauBQ+hxKAOqtIUn/JbS9EzYV+0fvfq4yLV7gscIF8o4EbpV3lx2O0AP/OhdhHpxbzysm1Na0rvek7gbkX8aFO8kvgrOFHAnYf7kgu3i6k+ugWza5zkpEcU3QmhEQE7rbgz//p9pf+qu6WyzGwwAyPYTaaFz+3vmF/yTOe3WmzSLqpQMFulzXaiI8udIPS3ndLSyYhBvEETY3rEjZMcePKNCXsKoZuM5avEFWo9HFJNVLycPKP7RorzxClB/sCBbVPKb572W0AwgWze8IsgxIg0W0vE5qiPY8Wal95R8glBlMeu1/rEvHMLLYsvCntCfXmslRyyiik3tUghrAEJSBizEatRsOJ5ZfOSWSvsGWAUWf+p8s6Og0zH//N1RbR1xl9s05qX8Q96V4W8MDSNEuELCzXj0uhvoYyoDhBPP6HuR7Ab0gfswmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] mm: shmem: shmem_get_partial_folio() swaps in whole
  non-straddling entries
- [High] mm: shmem: missing boundary zeroing when hole is faulted in
  during truncate
--

commit 44fc5f1a0ce8be88e4d2e1f2173306d27462ff3d
Author: Baolin Wang <baolin.wang@linux.alibaba.com>

mm: shmem: fix discarded data left intact after truncation or hole punching

This commit swaps in and locks boundary folios before updating i_size or
unmapping the range during truncation and hole punching, propagating swapin
errors to the syscall callers and passing the locked boundary folios to
shmem_undo_range().

> diff --git a/mm/shmem.c b/mm/shmem.c
> index 2b2b78dd24975..1e1d741e50dc2 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1306,6 +1306,7 @@ static struct folio *shmem_get_partial_folio(struct=
 inode *inode, pgoff_t index)
>  {
>  	const gfp_t gfp =3D mapping_gfp_mask(inode->i_mapping);
>  	struct folio *folio;
> +	int error;
> =20
>  retry:
>  	folio =3D filemap_get_entry(inode->i_mapping, index);
> @@ -1324,17 +1325,22 @@ static struct folio *shmem_get_partial_folio(stru=
ct inode *inode, pgoff_t index)
>  	 * Truncation can look up a large swap entry at or beyond i_size.
>  	 * Swap it in directly to bypass the size check in shmem_get_folio().
>  	 */
> -	if (shmem_swapin_folio(inode, index, &folio, SGP_READ, gfp, NULL, NULL)=
 =3D=3D -EEXIST)
> +	error =3D shmem_swapin_folio(inode, index, &folio, SGP_READ, gfp, NULL,=
 NULL);
> +	if (error =3D=3D -EEXIST)
>  		goto retry;
> +	if (error)
> +		return ERR_PTR(error);
>  	return folio;
>  }
> =20
>  /*
>   * Remove range of pages and swap entries from page cache, and free them.
>   * If !unfalloc, truncate or punch hole; if unfalloc, undo failed falloc=
ate.
> + * Boundary folios are locked and referenced. Zero them, split large one=
s,
> + * then unlock and put them. NULL means there is no boundary folio.
>   */
>  static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t =
lend,
> -								 bool unfalloc)
> +		struct folio *start_folio, struct folio *end_folio, bool unfalloc)
>  {
>  	struct address_space *mapping =3D inode->i_mapping;
>  	struct shmem_inode_info *info =3D SHMEM_I(inode);
> @@ -1392,25 +1398,19 @@ static void shmem_undo_range(struct inode *inode,=
 loff_t lstart, uoff_t lend,
>  	if (unfalloc)
>  		goto whole_folios;
> =20
> -	same_folio =3D (lstart >> PAGE_SHIFT) =3D=3D (lend >> PAGE_SHIFT);
> -	folio =3D shmem_get_partial_folio(inode, lstart >> PAGE_SHIFT);
> -	if (folio) {
> -		same_folio =3D lend < folio_next_pos(folio);
> -		folio_mark_dirty(folio);
> -		truncate_inode_partial_folio(folio, lstart, lend, &start,
> +	if (start_folio) {
> +		same_folio =3D lend < folio_next_pos(start_folio);
> +		folio_mark_dirty(start_folio);
> +		truncate_inode_partial_folio(start_folio, lstart, lend, &start,
>  					     same_folio ? &end : NULL);
> -		folio_unlock(folio);
> -		folio_put(folio);
> -		folio =3D NULL;
> +		folio_unlock(start_folio);
> +		folio_put(start_folio);
>  	}
> -
> -	if (!same_folio)
> -		folio =3D shmem_get_partial_folio(inode, lend >> PAGE_SHIFT);
> -	if (folio) {
> -		folio_mark_dirty(folio);
> -		truncate_inode_partial_folio(folio, lstart, lend, NULL, &end);
> -		folio_unlock(folio);
> -		folio_put(folio);
> +	if (end_folio && end_folio !=3D start_folio) {
> +		folio_mark_dirty(end_folio);
> +		truncate_inode_partial_folio(end_folio, lstart, lend, NULL, &end);
> +		folio_unlock(end_folio);
> +		folio_put(end_folio);
>  	}
> =20
>  whole_folios:
> @@ -1513,12 +1513,39 @@ static void shmem_undo_range(struct inode *inode,=
 loff_t lstart, uoff_t lend,
>  	shmem_recalc_inode(inode, 0, -nr_swaps_freed);
>  }
> =20
> -void shmem_truncate_range(struct inode *inode, loff_t lstart, uoff_t len=
d)
> +/* Check whether the end page of [lstart, lend] lies in the start folio.=
 */
> +static bool is_same_boundary_folio(struct folio *start_folio,
> +		loff_t lstart, uoff_t lend)
>  {
> -	shmem_undo_range(inode, lstart, lend, false);
> +	if (start_folio)
> +		return folio_next_index(start_folio) > lend >> PAGE_SHIFT;
> +	return (lstart >> PAGE_SHIFT) =3D=3D (lend >> PAGE_SHIFT);
> +}
> +
> +static void shmem_truncate_range_partial(struct inode *inode, loff_t lst=
art, loff_t lend,
> +		struct folio *start_folio, struct folio *end_folio)
> +{
> +	shmem_undo_range(inode, lstart, lend, start_folio, end_folio, false);
>  	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
>  	inode_inc_iversion(inode);
>  }
> +
> +void shmem_truncate_range(struct inode *inode, loff_t lstart, uoff_t len=
d)
> +{
> +	struct folio *start_folio =3D NULL, *end_folio =3D NULL;
> +
> +	/* This void interface retains best-effort handling of boundary errors.=
 */
> +	start_folio =3D shmem_get_partial_folio(inode, lstart >> PAGE_SHIFT);
> +	if (IS_ERR(start_folio))
> +		start_folio =3D NULL;
> +
> +	if (lend !=3D -1 && !is_same_boundary_folio(start_folio, lstart, lend))=
 {
> +		end_folio =3D shmem_get_partial_folio(inode, lend >> PAGE_SHIFT);
> +		if (IS_ERR(end_folio))
> +			end_folio =3D NULL;
> +	}
> +	shmem_truncate_range_partial(inode, lstart, lend, start_folio, end_foli=
o);
> +}
>  EXPORT_SYMBOL_GPL(shmem_truncate_range);
> =20
>  static int shmem_getattr(const struct mnt_idmap *idmap,
> @@ -1578,19 +1605,30 @@ static int shmem_setattr(const struct mnt_idmap *=
idmap,
>  	if (S_ISREG(inode->i_mode) && (attr->ia_valid & ATTR_SIZE)) {
>  		loff_t oldsize =3D inode->i_size;
>  		loff_t newsize =3D attr->ia_size;
> +		struct folio *folio =3D NULL;
> =20
>  		/* protected by i_rwsem */
>  		if ((newsize < oldsize && (info->seals & F_SEAL_SHRINK)) ||
>  		    (newsize > oldsize && (info->seals & F_SEAL_GROW)))
>  			return -EPERM;
> =20
> +		if (newsize !=3D oldsize && (info->flags & SHMEM_F_MAPPING_FROZEN))
> +			return -EPERM;
> +		if (newsize <=3D oldsize) {
> +			folio =3D shmem_get_partial_folio(inode, newsize >> PAGE_SHIFT);
> +			if (IS_ERR(folio))
> +				return PTR_ERR(folio);
> +		}

[Severity: High]
Does calling shmem_get_partial_folio() before shmem_undo_range() swap in
whole swap entries at lstart >> PAGE_SHIFT and lend >> PAGE_SHIFT even when
they do not straddle the range boundaries?

Previously, shmem_get_partial_folio() ran after the first
find_lock_entries() pass in shmem_undo_range(), which had already freed
non-straddling swap entries in [start, end - 1] via shmem_free_swap().
Looking up the boundary indices upfront means a page-aligned truncate (such
as ftruncate(fd, 0)), page-aligned hole punch, or shmem_truncate_range()
swaps in the entry at the boundary index only for
truncate_inode_partial_folio() to immediately discard the entire folio.

As a result, page-aligned ftruncate() and fallocate(FALLOC_FL_PUNCH_HOLE)
fail with -ENOMEM when a cgroup at its memory limit tries to free
swapped-out pages, and fail with -EIO if the boundary index holds a
swapin-error poison marker (regressing 59511d630a69 ("mm/shmem: fix
truncation of files containing only swapin-error markers")).

[ ... ]

> @@ -3911,7 +3949,9 @@ static long shmem_fallocate(struct file *file, int =
mode, loff_t offset,
>  		struct address_space *mapping =3D file->f_mapping;
>  		loff_t unmap_start =3D round_up(offset, PAGE_SIZE);
>  		loff_t unmap_end =3D round_down(offset + len, PAGE_SIZE);
> +		loff_t lend =3D offset + len - 1;
>  		DECLARE_WAIT_QUEUE_HEAD_ONSTACK(shmem_falloc_waitq);
> +		struct folio *start_folio =3D NULL, *end_folio =3D NULL;
> =20
>  		/* protected by i_rwsem */
>  		if (info->seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE)) {
> @@ -3919,6 +3959,23 @@ static long shmem_fallocate(struct file *file, int=
 mode, loff_t offset,
>  			goto out;
>  		}
> =20
> +		start_folio =3D shmem_get_partial_folio(inode, offset >> PAGE_SHIFT);
> +		if (IS_ERR(start_folio)) {
> +			error =3D PTR_ERR(start_folio);
> +			goto out;
> +		}
> +		if (!is_same_boundary_folio(start_folio, offset, lend)) {
> +			end_folio =3D shmem_get_partial_folio(inode, lend >> PAGE_SHIFT);
> +			if (IS_ERR(end_folio)) {
> +				error =3D PTR_ERR(end_folio);
> +				if (start_folio) {
> +					folio_unlock(start_folio);
> +					folio_put(start_folio);
> +				}
> +				goto out;
> +			}
> +		}
> +
>  		shmem_falloc.waitq =3D &shmem_falloc_waitq;
>  		shmem_falloc.start =3D (u64)unmap_start >> PAGE_SHIFT;
>  		shmem_falloc.next =3D unmap_end >> PAGE_SHIFT;
> @@ -3929,7 +3986,8 @@ static long shmem_fallocate(struct file *file, int =
mode, loff_t offset,
>  		if ((u64)unmap_end > (u64)unmap_start)
>  			unmap_mapping_range(mapping, unmap_start,
>  					    unmap_end - unmap_start, 0);
> -		shmem_truncate_range(inode, offset, offset + len - 1);
> +		shmem_truncate_range_partial(inode, offset, lend,
> +					     start_folio, end_folio);

[Severity: High]
Can a concurrent page fault populate an initially empty boundary page after
shmem_get_partial_folio() returns NULL, causing shmem_undo_range() to skip
zeroing it?

CPU0                                    CPU1
shmem_setattr() / shmem_fallocate()
  start_folio =3D shmem_get_partial_folio()
    -> NULL (hole)
                                        shmem_fault()
                                          allocates and maps folio at
                                          boundary index, writes data
  i_size_write() / unmap_mapping_range()
  shmem_undo_range(..., NULL, ...)
    find_lock_entries(mapping, start, ...)
    if (start_folio) -> skipped         <-- unaligned boundary not zeroed

When the boundary index starts as a hole, start_folio (or end_folio) is
NULL and no folio lock is held across the subsequent swapin of end_folio,
i_size_write(), unmap_mapping_range(), or the first find_lock_entries()
loop in shmem_undo_range().  Because both loops in shmem_undo_range() scan
only [start, end - 1] (where start =3D (lstart + PAGE_SIZE - 1) >> PAGE_SHI=
FT
and end =3D (lend + 1) >> PAGE_SHIFT) and shmem_undo_range() no longer
re-checks the boundary indices when start_folio or end_folio is NULL, a
folio faulted into an unaligned boundary page during that window is left
with non-zero bytes in the truncated tail or punched hole.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/6fcc15c466667f6943c=
34e130212b891b7471c83.1795436423.git.baolin.wang@linux.alibaba.com?part=3D1

