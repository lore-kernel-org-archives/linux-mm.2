Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABC7C606A337
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 08:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fRiSjGxD
Received: by kanga.kvack.org (Postfix)
	id CBCCA6B05B0; Sat, 28 Nov 2026 03:49:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6E3D6B05B1; Sat, 28 Nov 2026 03:49:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B83086B05B2; Sat, 28 Nov 2026 03:49:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A5786B05B0
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 03:49:21 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C31E5A800A
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 08:49:20 +0000 (UTC)
X-FDA: 85483903680.11.3D2F03D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 27C6FA000B
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 08:49:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fRiSjGxD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795855759;
	b=VR31wwvWNBGNPhE9Qkh3Y3HWIrhrv80PFmNi8YBdulhaA5iC46pMn+rpo6DrN26spTCB3Z
	pBJJjM0hdaqiLMmZV+ovEW1XlUBzxrbdS6L5V/JANffH4aywnsyADeLP/aJr2Xpd/3XSV3
	b+zKOIWBTWMhPW1fZzp/cM8SwoRSI2Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795855759;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9EUy6bu/c2hFeqm2ZEGubMXbqcfKYdYE9PnZab6Bhvw=;
	b=Dfs7T0PKWGApkTZEBx89/LvWqX2B7kImN6R4PZRzRN3eCRkaest+bxyXNfpW6s4jPUfo+r
	pk2RK+4mP4E4TvlF0yCMTwf6I8I7nZyy3yUCRf8r5wK7jt1wEsi/FzHRHE+75m4UZ9tUkj
	/LWyZnuUu/CYgkx9RxYmH6ijqKke0Iw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fRiSjGxD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4E7AC6022E;
	Sat, 28 Nov 2026 08:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807941F00893;
	Sat, 28 Nov 2026 08:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795855758;
	bh=9EUy6bu/c2hFeqm2ZEGubMXbqcfKYdYE9PnZab6Bhvw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fRiSjGxDzt5xO9Kg830stj8bEL8F8pTUCzSAB6pKZqYed0sSIUVJ1n6WpeeGj72p2
	 ktnu0cybQOzwIgdI5epQf/Ss+Wpr+5eESep0WiJSkWN/5j94+nuTGaKwK3X1JHFpnP
	 fj9uZXaGYgbvvE4UeYA57zQq4bvNJEuTvjpoQ8i5opW3OG/KoqA73FsZ4K7E8KYhjs
	 ABjPcXa9phwda4RvCfLdM/aHhDhGKIwQ2RzoWuBj3x89EFOOmxn0IhuJlh8PDmq9o2
	 YW2+1X68tE9aVc4b+09+kmfPHic7EAfTZVN914zwjjh3PKlbwDaB55Z/EsxoYUb+zp
	 MYT70r4NK2P2g==
Message-ID: <sashiko-outbox-238562@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 1/2] f2fs: complete dropbehind write bios in task
 context
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wenjie Qi" <qwjhust@gmail.com>, jaegeuk@kernel.org, chao@kernel.org
Cc: hch@lst.de, jack@suse.cz, axboe@kernel.dk, tz2294@columbia.edu, baohua@kernel.org, linux-mm@kvack.org, qiwenjie@xiaomi.com
In-Reply-To: <323235fbdeb5131f83569541c602ddc88f412b18.1795746008.git.qiwenjie@xiaomi.com>
References: <cover.1788438786.git.qiwenjie@xiaomi.com>
 <cover.1788795700.git.qiwenjie@xiaomi.com>
 <cover.1795746008.git.qiwenjie@xiaomi.com>
 <323235fbdeb5131f83569541c602ddc88f412b18.1795746008.git.qiwenjie@xiaomi.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 28 Nov 2026 08:49:17 +0000
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 27C6FA000B
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: m7s38516w7e6kt3cxnq3xhpqqcw94ehn
X-HE-Tag: 1795855759-572470
X-HE-Meta: U2FsdGVkX18DhDsgwZNlOMxZvZvIWoGDxfKwuIZOEuiiviLEROJ7/ZVdAZh4iSI9sCn+DBIqkufgOlCsN9WRW4vYbJzf6NkbQ74weDTKKJdku1X12xSZRkBX1pqgZzeavT1qFwQ8d0zHtmxa/QvhKGT4eW8vIwZrdWPDthSeT/p0VXvuSM/aglnZqH/uYjp94BDrx31WPqYBAFM1cb2bCgOl3YwrrGIj2kBso6S9R74A7+2mOEsgRVOrA/W0mAr9+DufUN5TGK4615JIhD7uShwmxTYhd8CLgsm2DjPE8enIaBuHcDes8QLFw7zjJq4Dps+VKYmSHiyigxeryWLgUQLihgSq7FBaeIrDF+zT7rqC4o7yTqUU4sc5ZN1FR63RqvbwNRZp9nzieLsaxkI98VZTAk9qQnTaab3YHmRqYLkxQqehvwUBMDxSr4Z1Wa+RcHra8mZudL3D3SE1rg5XxRVNgjA/tdCwbxW/Y4670T1KMIzYY+bCJOc6IQxIJJDYxlN8/ykjPn/0BUS6V2He+0v/muPPuOyijOt51p+0bsnKsiNiQQWZQpvnD7AJLd7wS8A5PZeGBpZopqZhabDNlcOYEsUs9WcMIOwmeag8a9htSzuF9amLklIpm2BueHt9n4ooATBr7DrE1HaImgjxdPyacHMZ6gida6vQ6uOSbAycaW1haeDtB+FckuGKjImzGXNI5WygXzz17njs8QEZUuovlHOL3oXqz9Peydf4C+7JUrIlfJhxnY/z8frQ4sOHgbckwLgQEgEbd8nmZxiAUe9iMwvus5L3fDgdUDVsAwuCddiK/cvbfVUxanuquuEObg+ljcwWO5yodxAJY9N2JeukV1bZTTbDhxfXha0Keb8sBuqm4ktDLOWnfFr3OeWv5ctPDR25C9PjTIOknQZOiNKr4jiSWw5tXdIaOF33pjPRklqyHNSfmhEGoXd9YXmfHySUc9FfQEUhesADZFh
 a0LhmzZd
 DtBLzVBGurumY/ardh91vPNHw1rj3xLKl+rNGWqCtmtx7M8VxERJJ/jHs/RqQfp7JUqTEsXFko//fBVjUQO6MgY0Mi8RDsEqR6jhjzI+HHF0SrkEfJ19Jp60oLNQ9uRY/K/5Am6fpkrWDdBim+DWM736ewGaETVZKpgCShtjaOHytqygCEhiMyTMuXE2yKwaXikwduJPdmZd0z1J8cMySqg4R+XL78V2NFXYU0k7uy1vMLGVTOPbgCEUhcTI8fvHUfB1r8T0jUeExN1iHPqrH5ZOESPForVypdEIqFMLqk5XYVv3gi1hb93CXDVbhP7QEfQRY/h6oXGJE0JLIDM9YqU9AL7MSjZu9xkRHYRqNTPEGdTv1MH0dpEFTNd4tiWsTvyL7xDcmEaoSZTS1TluNilxqmo+YA2L2MkmlNFU/WcapmF0B39dtxhvY5RFRyTF7+GVXilDaRTL7k9Q3obmqFh56ZKJPLR7sU/rl6z4rVG4CiEDACzUWsP5vFNl8IltRtMa7KduDZINm6CcTtQsasEaIP3WsvSqzzrF+QF7oDuGN5Vxz3MnRS/+o+RnqAqiJrMTwlTNpPLBX7JuRCN0qRLmAxSH2r+AcUs3rCqkQn+hSndRdGENEy7O6tgQFrf+kpA2vOJoisjkaoYGEksyihCQ9iK+bIlowwmr7GDzTdbK8sEq9QKxNjyvVgFYj/07ColwXKoOHoOJwAykcVMZRQJSTTLy+mud0DODpOPrk8aXNrpmz+d1f9HInFXvWVFaucacM3SqoQB98XHzLoafeKeg8kiBnGUbna4gqlQfHscIoh48XxJvVS0YbGHPaP26LGbK/4NFy5akMSp4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] f2fs: missed BIO_COMPLETE_IN_TASK for compressed writes in
  __bio_alloc()
--

commit eb035ab3b21d7c6d735daa2773a956fd37b6e545
Author: Wenjie Qi <qwjhust@gmail.com>

f2fs: complete dropbehind write bios in task context

This commit sets BIO_COMPLETE_IN_TASK on write bios containing dropbehind
folios so that bio completion is deferred to task context where the folios
can be invalidated.

> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index cdc9e6e8633c8..37d74afc8b26a 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -624,6 +624,9 @@ static struct bio *__bio_alloc(struct f2fs_io_info *f=
io, int npages)
>  	bio =3D bio_alloc_bioset(bdev, npages,
>  				fio->op | fio->op_flags | f2fs_io_flags(fio),
>  				GFP_NOIO, &f2fs_bioset);
> +	if (!is_read_io(fio->op) && !fio->is_cache &&
> +	    folio_test_dropbehind(fio->folio))
> +		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
>  	bio->bi_iter.bi_sector =3D sector;
>  	F2FS_BIO(bio)->entry =3D NULL;
>  	bio->bi_private =3D NULL;

[ ... ]

> @@ -1359,6 +1364,8 @@ void f2fs_submit_page_write(struct f2fs_io_info *fi=
o)
>  		__submit_merged_bio(io);
>  		goto alloc_new;
>  	}
> +	if (folio_test_dropbehind(fio->folio))
> +		bio_set_flag(io->bio, BIO_COMPLETE_IN_TASK);
> =20
>  	F2FS_BIO(io->bio)->entry_cnt++;

[Severity: Medium]
Can compressed cluster write bios miss BIO_COMPLETE_IN_TASK when only
fio->folio is checked?

In f2fs_write_compressed_pages(), the cluster submission loop skips
f2fs_outplace_write_data() for the cluster header (i =3D=3D 0) and any block
index past cc->valid_nr_cblocks:

fs/f2fs/compress.c:f2fs_write_compressed_pages() {
	...
		if (i =3D=3D 0) {
			...
			goto unlock_continue;
		}
		...
		if (i > cc->valid_nr_cblocks) {
			...
			goto unlock_continue;
		}
	...
}

As a result, cc->rpages[0] and trailing raw folios in cc->rpages[] beyond
cc->valid_nr_cblocks are never passed as fio->folio to
f2fs_submit_page_write() or __bio_alloc().  On completion,
f2fs_compress_write_end_io() calls folio_end_writeback() on all raw folios
in cic->rpages[] when the last compressed block in cic->pending_blocks
finishes.

If PG_dropbehind is set on one of those unsubmitted raw folios (or if a
compressed cluster spans multiple bios and the last bio to complete was not
marked), f2fs_compress_write_end_io() runs in atomic context and
folio_end_dropbehind() skips invalidating the cluster's dropbehind folios.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1795746008.gi=
t.qiwenjie@xiaomi.com?part=3D1

