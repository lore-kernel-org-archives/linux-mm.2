Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0963606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 03:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IqC5RpGJ
Received: by kanga.kvack.org (Postfix)
	id 1F7C36B05DD; Thu, 12 Nov 2026 22:39:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A8DA6B05E3; Thu, 12 Nov 2026 22:39:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 070856B0682; Thu, 12 Nov 2026 22:39:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CA39B6B05DD
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:39:33 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 585B6C04DB
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:39:33 +0000 (UTC)
X-FDA: 85428691026.14.DA0215F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id ACDB9A0002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:39:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IqC5RpGJ;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794541171;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/tsShP7r+fZm0+rr71ayj48AEHg+ODsCRzOjg0UC4n0=;
	b=l9cwvmXDOtY2ilbspBzHy1eas4mwLS1R/NcbRW1MyM96/MgFc6ugq2IBVNwenlU/OFxZ0O
	pdRGEodOfQLn5RgipCJeJBMm6bvq5VSBA8eE6a36fRRV+69S1Gb8zLXKvoyPb8ZMYB//h3
	rZSLjyV9HqEw4Zwl2JOh9ucE8IKJYoU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794541171;
	b=v2tF9d3e4l/3aspzfO/dJhGQx3ctt/ASZo6sBXM2NC49KHKJYtolClYXuQ7on/YF2QtNlV
	lhDfQfsl/c66BtW4f+B6IlyksDmg0awrDrbT3PGI0JVm8gKK2bJkXyhZcwq7k7vTd1+gvW
	cUalUBuyGOTTr2uxcAN5S6SntFLW0wE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IqC5RpGJ;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B0559601F1;
	Fri, 13 Nov 2026 03:39:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F052F1F000C4;
	Fri, 13 Nov 2026 03:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794541170;
	bh=/tsShP7r+fZm0+rr71ayj48AEHg+ODsCRzOjg0UC4n0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IqC5RpGJitFjG/3LR+/DSrw7MVFhLm05wsLxPEWZODE04mNI8NFxwq5T/eusZ43WL
	 i+N/Y48nDHzcd1VMuyfcUUqZsof3z14/G4vi82q9Hh5r/joVTeIn+QE7C2tMNCZT2+
	 4cxJAj4Ht5vjsM4pS0t8Ek+CF/Y76rmt/UVQbhRuiHfQIgBw6pKdhO8AU6IqCoEKfF
	 y/IeF92SIVA+7QfN1vZvH+2B+KQ2dZwqZdxIHq4598D3q3ILkWo6wkqbZEZnOuOK4d
	 7MPWWZQCS1BYftMlz2J25A2LH9hslZwHczfy2zseWUt6rvtpLF5KY7F3avfbTzeTU1
	 fe+p5sLWY8PFg==
Message-ID: <sashiko-outbox-212134@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/shmem: drop the second folio batch from
 shmem_undo_range()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qiliang Yuan" <qiliang.yuan@linux.dev>, "Hugh Dickins" <hughd@google.com>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Jan
 Kara" <jack@suse.cz>, "Qiliang Yuan" <odys.yuan@gmail.com>,
 =?utf-8?b?RGF2aWQgSGlsZGVuYnJhbmQgKEFybSk=?= <david@kernel.org>
Cc: linux-mm@kvack.org, "kernel test robot" <lkp@intel.com>
In-Reply-To: <20261111-bug-mm-shmem-undo-frame-v1-1-e50a95b8f9b2@linux.dev>
References: <20261111-bug-mm-shmem-undo-frame-v1-1-e50a95b8f9b2@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 03:39:29 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: o8cembottq1mtccy9wbhqozgfn4s5tuk
X-Rspamd-Queue-Id: ACDB9A0002
X-Rspam-User: 
X-HE-Tag: 1794541171-853952
X-HE-Meta: U2FsdGVkX1/QYsaRGTw2YzbZzDuoU9Q29BgG9yl5gGWZsy79PmdG2lhXNBafc7dbPYeSw4x8LAVAkVMi5l/d0FZHWuypwSTKf0fgPgnYa3hZoQskCDuUXqT0KqmDPvpYooTEytvF3X4i872P7roLpzqXUY37SRGz7axddA936pfuaEPGQ24WDxr/ZCQWa7SywV/BfF+qlyIAvT+aF3Kwa6v+pgd+K6V/wnf9AIwGxcgz+yQAuhpCVjzxh8sO+RWr94ZaFso55NUg3v20viNNDJMQG78k2QheUpspDvRKGVwp9bxprkL9yhXFxjlRgkD3obZmoX5ZO2IQjq/7JFMqxrnCYSIdx66UsIq9/JQ0vNoVc3kNpRKfiWLiAOd8dTd3ytoEkBx7pYZypDkuP8stIFeWWucpJFcVAmA9lMl/nV1nTDw58jKDirs0R3kAH8mBomUlHiZ4THjj1Zb9thUqOC5Hbp/G9QGsYz2jTNgi9lPIa9XdUMMWCF0txwkJgSmUlyz6nbaGcHtDDxH95cQRkD4RiMcT+Sal91DoosOACBecxusz9wl24KuFru+7XCcchDMukSG8sVD8oylaoUuO1USdnpg6aZhhGoSmSOA4dx/fDSyzRcPz3Y32JocNYFNGbBsRm6WVm+35p6WhNM+KSsM0siz2DMhTJuRHw/2QMaaA7/WnTV7yKVfGG2TsSXx6CAl9AUqgYcfR3gEn2o1/pYrWeEVoWDO25WdfNpK37UEZbCFZ3VTwAV3K9NU3XGZZPb6BSvNDBXQd7VqmUA0GGH0yvY+hWgJR4XeZTUUN6iYaO3fleZr5G6rMp7VJ1Qdfp4y6V9g60s6Nor9Ey6PqvbONg6n1doBQAVnQaEuNkVNsDeT/GDPax/eSpdzHqsmwuICTu/qIVzQ8ROEiMeFmGGkjJmfrDcQ71oWtLIvadIYiBIOL+HcWJ4al5s0gphT1uU/2Eb66qj3AR1Q8ocE
 iP/lDdO6
 kuKGubNuYpy7+cwb4qHyLXKji5wcV8arFf/fM8787vE++Tmjc1QSrD7SX4K4Vz2Mgtu/8qrL/tVhKcmdGimQ88Ah7BH5xgdCQY3dLHm115jAzJG9FND1KxjlOldES/6HtxKEm9fOWvAsfK2Hrbkqc5wd/jCn28vndKrNC2UzEpYDhz89Taywwem/M+FHqmHOtEoaO6dhG2yNOPJgP0aEDAYnNcTuG9ccBZGY4rO8dWCbykkohIRZ5ODt/jobneuhWEgnyXDyKj4Nw5uRQKCaPd6RJczfGnB6tweJBtQAOPrudDO3COKntIhya055E7PpT1xTkBH438B6vwOb0/WZDxOCWLs9B9WslUCiF1bysR+lcbeSNfCreFOXP2ZlaApybAupBObiRD7+vEgraQeOWYF/A8pgdSRMaqhWAcJSKcQM6NmAf51p1xGWJkVTlmCL7tBQxJCYoiY2jM/KXu3WdVEC5SviWRae5UMysYz7IF4xEKO1FNWV0w+6kBxtXwRpSw4ycryGUWSIYvj69oE0NXNIf3yclgy1e14oXWpD9YVEJhJuHjAltUzgTsYBtuvCKTnU3BC2NDnH4+A+Czxtfnaj7Tv2/rtjcPN3nB1QGJfIyQPjJ7SOxe2XdXkBQc3ehwdd58XiamKkcNAV7MTQJaLvJv8nQ450VngNOQXOBWOL1qhn26krP5xceMtHdbUoZ6KkPgKYYLZ7FLpATdWpMZhbvwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Critical] mm/shmem: skipped boundary zeroing on swapin failure in
  shmem_undo_range() [1]
--

commit 785bd3384006f8bb06c3c8f9b1b5d455eba3d449
Author: Qiliang Yuan <qiliang.yuan@linux.dev>

mm/shmem: drop the second folio batch from shmem_undo_range()

This commit removes the second folio_batch from shmem_undo_range() by
passing fbatch directly to delete_from_page_cache_batch() after removing
swap entries, and using truncate_inode_folio() when undoing a failed
fallocate().

> diff --git a/mm/shmem.c b/mm/shmem.c
> index 156469423a866..5bcbdd6078a73 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1352,9 +1352,6 @@ static void shmem_undo_range(struct inode *inode, l=
off_t lstart, uoff_t lend,
>  	index =3D start;
>  	while (index < end && find_lock_entries(mapping, &index, end - 1,
>  			&fbatch, indices)) {
> -		struct folio_batch remove;
> -
> -		folio_batch_init(&remove);
>  		for (i =3D 0; i < folio_batch_count(&fbatch); i++) {
>  			folio =3D fbatch.folios[i];
> =20
> @@ -1366,13 +1363,14 @@ static void shmem_undo_range(struct inode *inode,=
 loff_t lstart, uoff_t lend,
>  				continue;
>  			}
> =20
> -			if (!unfalloc || !folio_test_uptodate(folio)) {
> +			if (!unfalloc)
>  				truncate_cleanup_folio(folio);
> -				folio_batch_add(&remove, folio);
> -			}
> +			else if (!folio_test_uptodate(folio))
> +				truncate_inode_folio(mapping, folio);
>  		}
> -		delete_from_page_cache_batch(mapping, &remove);
>  		folio_batch_remove_exceptionals(&fbatch);
> +		if (!unfalloc)
> +			delete_from_page_cache_batch(mapping, &fbatch);
>  		for (i =3D 0; i < folio_batch_count(&fbatch); i++)
>  			folio_unlock(fbatch.folios[i]);
>  		folio_batch_release(&fbatch);

[Severity: Critical]
This problem wasn't introduced by this patch, but can shmem_undo_range()
leave partial boundary ranges unzeroed when swapping in a boundary folio
fails [1]?

Later in shmem_undo_range(), shmem_get_partial_folio() is called to fault
in boundary folios at lstart >> PAGE_SHIFT and lend >> PAGE_SHIFT before
passing them to truncate_inode_partial_folio():

mm/shmem.c:shmem_get_partial_folio() {
	...
	folio =3D NULL;
	shmem_get_folio(inode, index, 0, &folio, SGP_READ);
	return folio;
}

mm/shmem.c:shmem_undo_range() {
	...
	folio =3D shmem_get_partial_folio(inode, lstart >> PAGE_SHIFT);
	if (folio) {
		same_folio =3D lend < folio_next_pos(folio);
		folio_mark_dirty(folio);
		truncate_inode_partial_folio(folio, lstart, lend, &start,
					     same_folio ? &end : NULL);
	...
}

If the boundary falls inside a swapped-out entry and shmem_swapin_folio()
fails with -ENOMEM under memory pressure, shmem_get_partial_folio() ignores
the error from shmem_get_folio() and returns NULL.  shmem_undo_range() then
skips truncate_inode_partial_folio() for that boundary while the subsequent
whole_folios loop skips any swap entry crossing start or end, leaving stale
non-zero data in the swap entry that becomes visible on later reads or file
extensions.

[1] https://sashiko.dev/#/bug/linux-c8b370f0-7820-4bcf-bfc3-a27db7a7ba48

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111-bug-mm-shm=
em-undo-frame-v1-1-e50a95b8f9b2@linux.dev?part=3D1

