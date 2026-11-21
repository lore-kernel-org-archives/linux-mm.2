Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B71E606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 19:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ex6glUQS
Received: by kanga.kvack.org (Postfix)
	id E75526B00EF; Sat, 21 Nov 2026 14:51:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFF006B05B0; Sat, 21 Nov 2026 14:51:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEDA36B05B1; Sat, 21 Nov 2026 14:51:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9BF186B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 14:51:56 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B8A1CC05CF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:51:55 +0000 (UTC)
X-FDA: 85460171790.25.C910882
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 172C11A0004
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:51:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ex6glUQS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795290714;
	b=28tlWbmEzzdZWX+5WzgaLGl5b7bPQ9xmKztgM+NU765c/g9IJttkoorJhNApi2uUl3H2vP
	zNKEItH64MruHmRjTbG3dOJ+IW60yri4B0sswp3TgA73Nyk5qlPsVBUndar9Ff53j3C/xY
	TjfMCEpKHG/37cwUAEDQEK5JRl+stjI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795290714;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NmdadeceNOLsiLh/U2MMuka1iWByYU0/MD+lweCAwNk=;
	b=fBiZtN7dtQzbrJGUE9pVCQ9YCKWkMnc/I7rdC7gpOzV9a3ywKjx4tqx4IyGSKNpDovy97q
	kLGY6s0Aeyo9NpjuN3gzKREdLI9s0UxivERgBcKWUgMOCtPvHFI3jPjml8TehcYlVz4bQr
	4EWVZK4KY2oRFGI4q/9kfHneAijcj4U=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ex6glUQS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C61341829;
	Sat, 21 Nov 2026 19:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFF01F000D0;
	Sat, 21 Nov 2026 19:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795290713;
	bh=NmdadeceNOLsiLh/U2MMuka1iWByYU0/MD+lweCAwNk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ex6glUQSXAv2FH8MzYaf3ZL8P81rzAoP4rVg92Bp2NcjIL4IQRemR/rkQZU3dSlsx
	 +9O+IL5rq8EFqf/1wNwVNgwVAzw2vTbsYn0debzKUO01PsKtbN8Y7wtsAnscWwGbGU
	 fxO21JSZa1eHaPe5+Hg9lAM8FPdkz8sudM81k3KKRXfegiSvSIDbaiO27wkPDxCfEr
	 0lIMYz9e+tGtjCKOkJP5n+DSWsZOFl2NIc1/wGMt08n+nwpA7QO35dt40K1ns/vCL/
	 HVD+axBE5Mg6dR/aIlmaZmfnsOF7g8U2k8NpyIYn/eq5PgH1FNQgrrNi4FyEluRYTf
	 UF0Vu24MjPdAw==
Message-ID: <sashiko-outbox-227325@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/filemap: only drop dropbehind folios on uncached
 reads
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tal Zussman" <tz2294@columbia.edu>, =?utf-8?b?TWF0dGhldyBXaWxjb3gg?=
 =?utf-8?b?KE9yYWNsZSk=?= <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Jens Axboe" <axboe@kernel.dk>
Cc: linux-mm@kvack.org, "Tianyi Chen" <hi@tychen.cc>
In-Reply-To: <20261120-filemap-dropbehind-read-v1-1-a373ac3fd993@columbia.edu>
References: <20261120-filemap-dropbehind-read-v1-1-a373ac3fd993@columbia.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 19:51:52 +0000
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 172C11A0004
X-Stat-Signature: gmk9w8spqa18ibzftucejrgb3sw3krqt
X-HE-Tag: 1795290713-479446
X-HE-Meta: U2FsdGVkX19/s9e9eSdJlMcPqNItboUmAhDrkuAx5o1xBhpqxkIRHwt3zQMkHwLHmyrNWgY4dDDmbSuu6cnrELd6rDoZEDADk/h6/DYHXGv2sknSkj1bpbeDXYyTit6KKD6j9CBT9dDUrTa4O2W/UWZRWeXhnZGVRvBHy56vglMMxQfmcpA47O6wPSrVPU4wHMRs8nN9AzHZkbH+FCh1b5KRuhI4SEAxdsXwfPco+PXOLBsbFyUsRo8BZlMSzWf8FrpPPFRwCM3ZhGAtzE63ztPprMeRe3/qCbp1Jjepz0O8+bQ9VUI2FWKs/3dbRPH3k4KbficQ9T31EIviB+LlOL92/5wBJtLVjYZTnAotiy2A0qRh/N18p9tz6KlMiU+CKM+RQcX17DxuoXcnlA5udfFfrAS+zwP6sgQMUbxMVNa7UY1HtTgYZDn7VaThIqY5wWzAUH0FuvZwJNw9e+xzbskRuWV3HMJa+hZepsHGx1B8KMMkORMzgCqJA1CXfM/HW3QIdF6OvLc1tDk/ZQrGTVPQyicH4v648m47kNFHwLbpZifzD/UqCvBgI1KapA+6WhJ9U88/vfr82g5ah1TJXkCafcqnFghHADgNiUr6iu4P6p+ow9ngAlr9MIHNnyRVpWwS+AIo6hnnbCac0H/4ugmSBHKcMC39BjZDUGeq1tJrd4GDx19PZM3Th35c6hbTaYb2ij2S4urDm9Fo5g/IyZPHypNatYq7IjuzfV3aykXFrDPMVtt6w+1cAQGIiMScA/HnWCaZjSm9Q8+MBx/6JltXHpW3NganI9uQDZOZUioTaHke7eL7Beru5367ubpImnrZx2unOV+FnMirpzrwba0jhC5yzFJH98WdTwjaFBXviGMZgIMqcyZ9eyxyGTrCekeG15jaF2e7E7XFOeUJKpeRJO6DTU3wHRj81aS+nmjivXt3RpsjzHUpxTXDcZlnHp8ujAskLbDxLxV4MXe
 X9caytfo
 WMC+F/UfcFjrInPQ+vgi9J1o2RtKYGnBrfmGj9SgZtf6Br3cmTHJaaoLFtcq9zHwpopZ3cCGf1u8W5e0A3BQbvXeWaK/G5MTU3c/XOKRCkDyPfC03W/LMly4ug0J9hxNqB8DtVMZZMUyCoIiGy3Qe/ZW6pUtD8v2k9pX+3kguK46VKWVM48mZ+LwMHj9qd41+C8bJwe78pJWsvc49sBOE+BxOQK9LK4mtWEYv+eYE6JuM/VZiyaT0ZpD8RJuBJcUsJHU/BDQgPXgcZVj6EfMdIuBCkCpEC1C0NNVVpjDOwDbVbkQMg1Rk7yFfBN9oM8XwyIW6yOQfuWXnqBpkotXm+3TZTS+BSbQ6YK0NfSOOKEc6bYqOvPGY+xizgmELEEN66WWT4PItqwn3ZgVKBEI3scWuzrJLqDwyxpHTRQqP8Ey9NStRexZFtrn/NXiWDvBfZbUUgthCFdB2vZbMwL8R7ropVTuv6T7cfO05x0JBXsbw5xT9As4Bto8Cf4/jb55oWs0KvvZ8qSNDDg99lg77S0Jnip7SRHeeI6QEp8i/uR8yWxkG3i7Jw+4dbBPL3RLTgViHg17ffusyUIkGG3dktIPRL9nuAfzNOmDk3FHXdAObMjrA0prmrr3S7SeqzOwYJBgxWOoTuBm9wtJLAMdF2qt3BiBpVh7UaE4TDoo1Zvvn1w3NwOFHikzHG/+f0K/DKRwRj95O3M0SWPD0CcZceZqC3FLa988DdC6heAy2iLFQJ2mZCMwvLW0LFCsu9I2+OFHOLKvU5qV6gLxeSG6L6UVYF/ngreBfxdslz+0vm+4lOjH51pnj3aXjDAPc8oMeu/T6s493dCQIlNw=
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
- [High] mm/filemap: unlocked filemap_clear_dropbehind() races with
  dirty accounting
- [Medium] mm/filemap: filemap_clear_dropbehind() in filemap_read()
  skips LRU access
--

commit 9ff8c01502e3877207be0dcbfaa0bc2369238702
Author: Tal Zussman <tz2294@columbia.edu>

mm/filemap: only drop dropbehind folios on uncached reads

This commit restricts dropping dropbehind folios in filemap_read() to
IOCB_DONTCACHE reads and extracts a filemap_clear_dropbehind() helper to
clear PG_dropbehind on cached reads and lookups.

> diff --git a/mm/filemap.c b/mm/filemap.c
> index dc0ceaa58a0f7..1bd91ff264e8a 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1632,6 +1632,28 @@ static void filemap_end_dropbehind(struct folio *f=
olio)
>  		folio_unmap_invalidate(mapping, folio, 0);
>  }
> =20
> +/*
> + * Clear the dropbehind flag on a folio so that it stays in the page cac=
he.
> + */
> +static void filemap_clear_dropbehind(struct address_space *mapping,
> +		struct folio *folio)
> +{
> +	struct inode *inode =3D mapping->host;
> +	struct wb_lock_cookie cookie =3D {};
> +	struct bdi_writeback *wb;
> +
> +	if (!folio_test_dropbehind(folio))
> +		return;
> +	if (!folio_test_clear_dropbehind(folio))
> +		return;
> +	if (!folio_test_dirty(folio) || !mapping_can_writeback(mapping))
> +		return;
> +
> +	wb =3D unlocked_inode_to_wb_begin(inode, &cookie);
> +	wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -folio_nr_pages(folio));
> +	unlocked_inode_to_wb_end(inode, &cookie);
> +}

[Severity: High]
Can calling filemap_clear_dropbehind() on an unlocked folio race with
folio dirtying and writeback to dereference a NULL wb or corrupt
WB_DONTCACHE_DIRTY?

In filemap_read(), the folios in fbatch are not locked when
filemap_clear_dropbehind() runs.  When a concurrent write dirties a
dropbehind folio, filemap_dirty_folio() sets PG_dirty before
__folio_mark_dirty() takes mapping->i_pages.xa_lock and calls
folio_account_dirtied():

CPU0                                  CPU1
filemap_dirty_folio()
  folio_test_set_dirty(folio)
                                      filemap_read()
                                        filemap_clear_dropbehind()
                                          folio_test_clear_dropbehind()
                                          folio_test_dirty(folio) =3D=3D tr=
ue
                                          wb =3D unlocked_inode_to_wb_begin=
()
                                          wb_stat_mod(wb, ...)
                                            <-- NULL pointer dereference
  __folio_mark_dirty()
    folio_account_dirtied()
      inode_attach_wb(inode, folio)
      if (folio_test_dropbehind(folio))
        wb_stat_mod(wb, WB_DONTCACHE_DIRTY, nr)

Under CONFIG_CGROUP_WRITEBACK, inode->i_wb is NULL on an inode being
dirtied for the first time until inode_attach_wb() attaches it inside
folio_account_dirtied(), so wb_stat_mod() on CPU1 dereferences NULL.
When inode->i_wb is already attached, CPU1 decrements WB_DONTCACHE_DIRTY
and CPU0 then sees PG_dropbehind clear and skips the increment,
underflowing the counter.

Because PG_dropbehind and PG_dirty are cleared in opposite orders without
the folio lock, filemap_clear_dropbehind() also races with
folio_clear_dirty_for_io() (and __folio_cancel_dirty()):

CPU0                                  CPU1
folio_clear_dirty_for_io()            filemap_clear_dropbehind()
  folio_test_clear_dirty(folio)         folio_test_clear_dropbehind(folio)
  folio_test_dropbehind(folio)          folio_test_dirty(folio)
    --> false                             --> false

Neither side decrements WB_DONTCACHE_DIRTY, leaking the count and causing
wb_check_start_dontcache() to over-flush unrelated dirty pages on later
RWF_DONTCACHE writes.  In addition, clearing PG_dropbehind before
unlocked_inode_to_wb_begin() lets a concurrent inode_do_switch_wbs() see
PG_dropbehind already clear and skip migrating the folio's count from
old_wb to new_wb, after which filemap_clear_dropbehind() decrements
new_wb.

[ ... ]

> @@ -2918,7 +2929,14 @@ ssize_t filemap_read(struct kiocb *iocb, struct io=
v_iter *iter,
>  		for (i =3D 0; i < folio_batch_count(&fbatch); i++) {
>  			struct folio *folio =3D fbatch.folios[i];
> =20
> -			filemap_end_dropbehind_read(folio);
> +			/*
> +			 * An uncached read drops the folio. Any other read
> +			 * keeps it in the page cache.
> +			 */
> +			if (iocb->ki_flags & IOCB_DONTCACHE)
> +				filemap_end_dropbehind_read(folio);
> +			else
> +				filemap_clear_dropbehind(mapping, folio);
>  			folio_put(folio);
>  		}
>  		folio_batch_init(&fbatch);

[Severity: Medium]
Does clearing PG_dropbehind in the put_folios loop skip marking the folio
as accessed on the LRU?

filemap_read() calls folio_mark_accessed() before copying data to the
iterator, while PG_dropbehind is still set on a readahead folio left by an
earlier RWF_DONTCACHE read:

mm/folio.c:folio_mark_accessed() {
	if (folio_test_dropbehind(folio))
		return;
    ...
}

Because folio_mark_accessed() returns early when PG_dropbehind is set, the
folio is kept in the page cache without being marked referenced or
activated on the LRU, leaving it cold for reclaim.

Also, because put_folios iterates over the entire fbatch, an early exit
from the copy loop (such as iocb->ki_pos >=3D isize, end_offset <
folio_pos(folio), or a short copy_folio_to_iter()) will clear
PG_dropbehind on folios in the batch that were never read.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120-filemap-dr=
opbehind-read-v1-1-a373ac3fd993@columbia.edu?part=3D1

