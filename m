Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B856D606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 16:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HVOuwcSt
Received: by kanga.kvack.org (Postfix)
	id D94056B05B2; Mon, 26 Oct 2026 12:36:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6C8D6B05B3; Mon, 26 Oct 2026 12:36:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C82746B05B4; Mon, 26 Oct 2026 12:36:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A104B6B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:36:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 41A29160803
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:36:30 +0000 (UTC)
X-FDA: 85365330540.18.6E28A0E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id A68E2180003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:36:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HVOuwcSt;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793032588;
	b=YMBzJgL+A51t+XekPjOM5voHgodOXDGA5X5cRiglWRsCLXnlWubH2o9z1dm95RLdMvVXJ/
	lZoidb6r7UYnSu6LThKbImEJR9HVZV1X0tpSWix6+AbTKghGIfDBeKynAUNOZ7C20H0Jaf
	IKjdCrIpja7Ia51dDEUjo192ejRu5pw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HVOuwcSt;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793032588;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jBCfDQL50haxCvgag3QQY2o07r6F39nYDLuILuyPNa0=;
	b=z4g5j0X/Wuq/B+C4iIdccGGBDRRca10/VS9oRbZ7YqmbIUVVUvc6SW35iIKZ6VBM2z0dvJ
	2Xq3CN9dRFCMivVrOZvfkmuFEbDkximgBmWnIE4DtHZOVkXbkOwQbRbXQaEN8QI8qta8hG
	2s8r2ugFjRfydqfioeDuEBZrXsNr3Kw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DEAD4601EF;
	Mon, 26 Oct 2026 16:36:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3063E1F01825;
	Mon, 26 Oct 2026 16:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793032587;
	bh=jBCfDQL50haxCvgag3QQY2o07r6F39nYDLuILuyPNa0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HVOuwcStnA8vbKUJ9eW+Yf3hKn9UEXq9kGvxphdhiYShjCMP/oAwVmaaXOKUqyW6u
	 DiJ1eL6sXVKyujeOb25FSVoHG+LpRKckhtgTBUK/n/atelVN5dmvNVEdNIJolYcXJA
	 rAeNz3l9EmHcvawVYCuhRVeNWK1nbvaKh0hwbyjDcFOUp1vyYhZoWPZaBad0GZF+Qk
	 vgGYwwfYD2+noPRCE/a2WzcvDGT2A2EHpNhdoXzuC/Td/1VC0bsLYnzCVQ9vDl7Lu+
	 43vbbZyJ4rjFQt7qxYTlzMtdLIC/Q2O3H/pfLuD/j2QUaNtniQg5SW1pOPGdUwLKIW
	 cnlOfjvwvc+uQ==
Message-ID: <sashiko-outbox-185541@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] shmem: do not extend i_size when no data was copied
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hungyu Lin" <dennylin0707@gmail.com>, hughd@google.com
Cc: baolin.wang@linux.alibaba.com, akpm@linux-foundation.org, dave.hansen@linux.intel.com, linux-mm@kvack.org
In-Reply-To: <20261025164619.89992-1-dennylin0707@gmail.com>
References: <20261025164619.89992-1-dennylin0707@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 16:36:26 +0000
X-Rspam-User: 
X-Rspamd-Queue-Id: A68E2180003
X-Stat-Signature: gfzpdw99qqxakf935adnt3z3sx3w6y5s
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793032588-929722
X-HE-Meta: U2FsdGVkX18sDaXiJHCv0qPXWAhnj2TC1lXvygQ/Ci2Hd8wOxghduKThAagz4F1HZd+/eYXX0ymjb56g37sPFjuwgsA0eHlExRhpCcpoRYlP4I9mpb/Z9cSLjxQ8FCXs+Hkg9I9mGqSmDyK20tC7H/Fj9ALWGEQ/JuendRijGfd4y676mSAF7H8XYvRnb8merxJrmBPLZqxNgro5C/mjehEvfYIAHvL9SnvBMp/xJxuWYYosEBZfeg2od4zY8prOV2KJecrpzaQNFgqCSD+UjJcTWq1EVId91KKZXlaH8fuOJVn4J1R7MWgIYUxw4duqqYPog+OG7dx/fyqwkcUndO0d7wI/nShRenuNxxeUCWrkVJL3H4Iuu9eB0lAT196xBY+L2aJiOpDMJaxKW4daEQHX9UYm5rW9QhT+ZT5A4s2bDDDkIye3VZXdO6ePiKSdn+uJf2hUadMWqc2FxrBeERkQWh3oYF0oCxudilB4FlS/6LmPn+W9L4psJ/KLomMeI6aNUSLytN+p45PTljJcVGITlMkxTGibxN7kv4RTYOgj755U9FFOwIOtHz8vRqv3jMBU3JsEFn6+CSWBCSZNqB32aDhlZeSKSI8doIp0hVTf+WdbaxGWjVXEOzasw2u9YMcnvICBzolciE8N6P6YBzDgyPlphmfBqLQExh8SUwAiGRZ5Q0VD9KzgxhCDlelsbra3jXHOLRKXK756vPvfTXTl/JV4+Lv/HXrYKV0U7Mb87LicqXhqheRRY/de1BApyAGZuo/quZJUzMYa3Y8pqBqEZWJFqgHEAxYMkrHhVEFCnTNkW/lZuQ0SnXW7o1LSjw29bD54eM/PYqIERr1P3QtAfBhD2SrezRm/yBsGEH93lsBrJrGehoJeQCImRni+KlCzC5vyy9Pnv2prKIM8fZZi8t14DDhW7LB+gIHkd8YpzwaPGeWufFBn92u9qWpGJJI72iH4AI1zZ1q1DVa
 x63SX9hA
 HBR1wqbCxZTSgFCfX620A4XB5rHN1kOdgMx36joaZZJsaA9+JnOqX3ltvAOyaNshNyBvPeEuxGUB/6mbhl4CusiQKcmTdQCeZLKJ9iuYpsN+/EmfBjuC3/HBd6o33YkNekFJVSzfR0tB4X/akBgoA5c/aaow/C8bvwbPPHvUHB+Myt6uhRN0N15TRH+kHkQc4juUmE2Q5sgpSyFr+6umt1abTSFPgSgyW3rXYJUXuHxNul8mENkuNkhMQBE+kzOgWnVHiNISwNhjjUHAIqh0/VX8ogug7TvSC5USNxqcdM1X8mRT9UgwypxeKPujeBd+7dvWAG2icmXAMmVJfkV/TS58n7XiwWdRqq8eRPxYvT3OXJFEu3GIEQJ1vxY96WZvMi1k4SxyoVJL6nKeVaI+vxQXyRfyhz2QtnjK6HVClOLeXrFUKLHvJ23tlff7WUyDLCbV6sZ9qibOTbKhBiZYg6/Z9kmJCv7v5iFJllbF/m7sul9hbDB5AAwawg0kCiwL7PykefLSnl5FVGWtZ3WhCEo6LvPTjWq+YW/6nimOYdYAwsfbbRI4Y2o3drdyqhaLwRFB1L9hzh2bY8BCYG+zBJWPaubht72QmJCHdLq2vGWeNOqW+KLaryka+tIMbsIudM4n/
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
- [High] shmem: shmem_write_end() marks and retains folios when copied is z=
ero
--

commit 8699add3f60dd22c2b86a526ad2c46fc91ebbdec
Author: Hungyu Lin <dennylin0707@gmail.com>

shmem: do not extend i_size when no data was copied

This commit updates shmem_write_end() to only advance inode->i_size when
copied is non-zero, preventing buffered writes that fail to copy data (such
as when faulting in the source buffer fails with -EFAULT) from extending the
file size.

> diff --git a/mm/shmem.c b/mm/shmem.c
> index fd0953d55fd64..3dc14bc589a48 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3488,7 +3488,7 @@ shmem_write_end(const struct kiocb *iocb, struct ad=
dress_space *mapping,
>  {
>  	struct inode *inode =3D mapping->host;
> =20
> -	if (pos + copied > inode->i_size)
> +	if (copied && pos + copied > inode->i_size)
>  		i_size_write(inode, pos + copied);
> =20
>  	if (!folio_test_uptodate(folio)) {

[Severity: High]
When copied is zero (for example, when generic_perform_write() calls
copy_folio_from_iter_atomic() on an unreadable user buffer and then
fault_in_iov_iter_readable() fails with -EFAULT), skipping i_size_write()
while still running the rest of shmem_write_end() zeroes the folio, marks it
uptodate and dirty, and leaves it in mapping->i_pages:

mm/shmem.c:shmem_write_end() {
	if (copied && pos + copied > inode->i_size)
		i_size_write(inode, pos + copied);

	if (!folio_test_uptodate(folio)) {
		if (copied < folio_size(folio)) {
			size_t from =3D offset_in_folio(folio, pos);
			folio_zero_segments(folio, 0, from,
					from + copied, folio_size(folio));
		}
		folio_mark_uptodate(folio);
	}
	folio_mark_dirty(folio);
}

Can leaving the folio marked uptodate and dirty in mapping->i_pages when
copied is zero cause several regressions?

1. If a write fails on a hole or an unwritten preallocated folio created by
   shmem_fallocate(), shmem_get_folio_gfp() intentionally leaves the folio
   !folio_test_uptodate(folio) so that mapping_seek_hole_data() ->
   folio_seek_hole_data() treats it as a hole:

   mm/filemap.c:folio_seek_hole_data() {
	if (xa_is_value(folio) || folio_test_uptodate(folio))
		return seek_data ? start : end;
	if (!ops->is_partially_uptodate)
		return seek_data ? end : start;
   }

   Does marking the folio uptodate when copied is zero turn unwritten
   fallocated ranges and holes into SEEK_DATA?

2. When a write past i_size fails with copied =3D=3D 0, shmem_write_begin()=
 has
   already allocated and charged a folio at index =3D pos >> PAGE_SHIFT,
   incrementing info->alloced and inode->i_blocks. Because inode->i_size is
   not updated, the file retains allocated dirty blocks beyond EOF (visible
   in st_blocks via shmem_getattr()). If the file is later extended via
   ftruncate(), shmem_setattr() only calls shmem_truncate_range() when
   newsize <=3D oldsize:

   mm/shmem.c:shmem_setattr() {
		if (newsize <=3D oldsize) {
			loff_t holebegin =3D round_up(newsize, PAGE_SIZE);
			if (oldsize > holebegin)
				unmap_mapping_range(inode->i_mapping,
							holebegin, 0, 1);
			if (info->alloced)
				shmem_truncate_range(inode,
							newsize, (loff_t)-1);
   }

   Won't extending i_size with ftruncate() expose those uptodate folios left
   beyond oldsize as SEEK_DATA?

3. When large folios are enabled, shmem_write_begin() can allocate a large
   folio at folio->index >=3D DIV_ROUND_UP(i_size, PAGE_SIZE) (for instance,
   at folio->index =3D=3D 0 when i_size =3D=3D 0) and queue the inode on
   sbinfo->shrinklist via shmem_unused_huge_add(). When i_size remains 0 and
   info->fallocend is 0, shmem_unused_huge_shrink() computes end =3D=3D 0 a=
nd
   bails out without splitting or freeing the folio:

   mm/shmem.c:shmem_unused_huge_shrink() {
		i_size =3D i_size_read(inode);
		folio =3D filemap_get_entry(inode->i_mapping, i_size / PAGE_SIZE);
		if (!folio || xa_is_value(folio))
			goto drop;
		...
		folio_end =3D folio_next_index(folio);
		end =3D shmem_fallocend(inode, DIV_ROUND_UP(i_size, PAGE_SIZE));
		if (end <=3D folio->index || end >=3D folio_end) {
			folio_put(folio);
			goto drop;
		}
   }

   Similarly, shmem_writeout() only splits a large folio if index >
   folio->index:

   mm/shmem.c:shmem_writeout() {
	if (folio_test_large(folio)) {
		index =3D shmem_fallocend(inode,
			DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE));
		if ((index > folio->index && index < folio_next_index(folio)) ||
		    !IS_ENABLED(CONFIG_THP_SWAP))
			split =3D true;
	}
   }

   Doesn't this prevent both shmem_unused_huge_shrink() and shmem_writeout()
   from splitting large folios allocated past i_size when copied is zero?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261025164619.8999=
2-1-dennylin0707@gmail.com?part=3D1

