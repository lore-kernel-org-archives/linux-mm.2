Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFC46606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 22:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WXWccwxC
Received: by kanga.kvack.org (Postfix)
	id 715DD6B05B0; Sun, 25 Oct 2026 18:12:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C6BD6B05B1; Sun, 25 Oct 2026 18:12:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DD416B05B2; Sun, 25 Oct 2026 18:12:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1FC126B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 18:12:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 65CD5A064A
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 22:12:13 +0000 (UTC)
X-FDA: 85362547746.02.301C927
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id CADFD40003
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 22:12:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WXWccwxC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792966331;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=recYVbsPv5/lH0o+j5UEjyEemFAvWbZkKxi0jqSdTOY=;
	b=Qfs0bdSCeUMqxCBwULyDF9H808Ql1odqZ+QeC1hhUkMDHJkvqv6djmdeqAdK5nSIhlStUq
	pgmKBqpcE6EIk6Qfz0uZMIqwx4elXbSo24Un3YlysjUFN7lNEDz+IiWZ+xUaIf7gKX33tn
	zQZFVVTION3BDvAMYlVElD0T5o2hfhU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WXWccwxC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792966331;
	b=JHnhDyC9PoCFBD0ytBz75di1EYB3EXkSBUJmhU0lufKKe5iEp/supSTf3vOBUxz00PoMAM
	sImFUKO2iFisFy5S8wqVw1XtFTSGHacPhgvSgyb2i9uwARJIigQIWz7y1l+WmFEEkEUH5L
	5p1QDStS5jSaAbKDcgA2cyvaJuRhALY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D4E2600AA;
	Sun, 25 Oct 2026 22:12:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3B01F01825;
	Sun, 25 Oct 2026 22:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792966330;
	bh=recYVbsPv5/lH0o+j5UEjyEemFAvWbZkKxi0jqSdTOY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WXWccwxCW8czBHLYThjTFTRFRi2Y+WxGS81xvQqjoB9lBgqFCVfxmPqXVsdEKcZpl
	 e+dlcTJgqc+UlHgnFI4bISTY9K3pmvTy5iffK7NM2Fg04w3x1rkVDi4z/S6GCgCCyC
	 4gChzrSV8N442CC1m3mUUHwxX4sjxAs0ihI3s3EhEM0hwD3NvHzNXqBuUObVfdCKhu
	 UDdmss0TyudcZIlPsHEjjKK7Xoiph9IzYBCxsisPutu4nMpRNz3y0zl3iLPnOG2GFn
	 l64HRAp5FJ+BCXzm+yDCnix4eFzxO3RTBHWywVkiLB5BgJUZKx9h2dL+PDbMOoBn3F
	 ulHukdNfmskyA==
Message-ID: <sashiko-outbox-184464@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 3/6] mm: add folio_mark_dropbehind() to mark a folio
 dropbehind and account it
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mike Snitzer" <snitzer@kernel.org>, "Matthew Wilcox" <willy@infradead.org>, linux-mm@kvack.org
Cc: "Chuck Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, NeilBrown <neil@brown.name>, "Olga
 Kornievskaia" <okorniev@redhat.com>, "Dai Ngo" <Dai.Ngo@oracle.com>, "Tom
 Talpey" <tom@talpey.com>, "Christoph Hellwig" <hch@lst.de>, "Jens Axboe" <axboe@kernel.dk>, "Jonathan
 Corbet" <corbet@lwn.net>, "Anna Schumaker" <anna@kernel.org>
In-Reply-To: <20261024221152.6965-4-snitzer@kernel.org>
References: <20261024221152.6965-1-snitzer@kernel.org>
 <20261024221152.6965-4-snitzer@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 25 Oct 2026 22:12:09 +0000
X-Rspamd-Queue-Id: CADFD40003
X-Stat-Signature: zidqqgoyngczazwms1r8wak75kqizpq9
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792966331-207457
X-HE-Meta: U2FsdGVkX182XBVC1VMeEWxuZR1CYklg49rdGaZNRRmCHTKzb1xi9TEJ3F0etOctle/nsnvMKzYPR20KqNkYiAXkq99nYfKIPQbuz8Io5AnDTev4fc7uOVr0hL43NPSKlv8GSB7c86wElCUeA/hM9bHVG85lhYKCtqcL+zmnoD1wmPLn0JqRXEnLReHQA0zD+vzjcJIJvDNdKQiDniavvHgMX5XBE3Uw9DjTOEdZ5ypdEIiS6Bd5KoHLPxidcEhHIELFodADqsUKNoj3kok0EfqnsVAzyTdAkp6+nFW2r0+Fx5tUivsbd7+WDffCoIEhBTT67E8rBA8QzBOncznDTHQD//n2wcwFvLeGIo3duFbThZdQ1V2Ws6CMbvpjDBfcQTutVsoRMo2tksHptM/knA/3cwXBkx1HP8sa69VbCoq0vADw0as+YFuzNXjpzPJLhvpjg+dW14bzpNyrtfnqfkB0OUDfjZpy7InrmcGwudBCQYDbFYpbMbiFB/A6z/2IiPKLmG0wvSX9qaK1qLBDnQfLhQ2PcTRDC1EsHq4gIZrx7b0s5Kvs1Av+nyOT8onuQAsSoVTmP/6Zoj3fQK1dY0BrAqfIA68OAemwAa1AjM5nhCiJuSdcKSrhPbDD+eF80RCK+c3gIoyNjlD98reSFlfBAvTZ7JUZVed0Tc/ouKDWm4o8XacEpiW95txnpGMc/DYV6rwZlZgp3kqwcNmZvrZAOR2vqQhDqjFyomz96fRrTZIZQk7DSbLqn8rRznPIE8lcJTN6Mhfb2UkZDgtCoNsZs2G3DrniV7MYUFDZkBPKjLwFxLd7Occa8nEmuaGQ9h+lJJEsItb4TTSgKv0sFOKs7soMfpjsOIzTz3LkglifQP+n4UvQ0jyptV2/xkBVZxTy5PDxLqUhhb6L/OoH4ueYzMohawQTfDFt77ungzhUKirXOY/TVPwLqpqUCm8njvIcyUNxVVpwbY9mlmD
 qkhVKmxj
 H+Cnp9x+LGUvqEB6AVLlOTKEYMLGFq0uup+Nwj9YrWPaAm2x/fLMqqAlvYQjk+Hst4kPrtwbVtCXS62ExAVFeD/6vfDg7S0u2Jzr7O+vCNoT/AcM1UX+0sbHwTl8M1e7wnAuQliKZZoXYpkseb2d/T918cQXwSpjygEEVaXRFmhVluUmwtQUB8qE6btHikpDapIs8RZgaa/HIeT/KIlsObSFva7nbf48j8XZkmuWf+5GbakOhkpY1UinKhC2kCEl2AQNjAu+oB6UAmXmrowJQGP7qe9Utrlq0/Io2o642zhV9wbyWcEkhkg7EUWKxxh+v2cRaGqBWcUuKyWwJxm7Zh1g3Lotlye0Sa5FSOT1DCSsB8sgta6PFLr3jVzvhASfIk2WevnPuipgCWfXiOj8WaceRBa8OduqvZdCNAtj1Xd1RXe7WD1yUoV98Y2RTXju3osM9ROLsr1ycfRtUUC5pX/IbzMpF19VHj6CKGPJLS+4tYtf6lXV1sqN2ulELsOynAcJ3fb26l0JaH0MWHLJYlN78OtIJAWieoETHAIzLopJMwtVkibSnw/wSYO4njPouFK1el5/DAh7zCtM0zC5dj4+xDKnFOiQ4OqqrO5hk9/amjeUK+ue4rc8B7JD3rTYBT/arPkQzIUyOOKfLm16o7yfdj9mZMRxT4iBcLxYkt7LmsFGpAa01/wv938sB8cuu6AzYGLZg6igMCqQ17/kjd+gLyw==
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
- [Medium] mm: double WB_DONTCACHE_DIRTY accounting in folio_mark_dropbehin=
d()
--

commit c61c906e71a09ef6325d33136e8bd76033c66585
Author: Mike Snitzer <snitzer@kernel.org>

mm: add folio_mark_dropbehind() to mark a folio dropbehind and account it

This commit adds folio_mark_dropbehind() to set PG_dropbehind on an existing
locked folio and increment WB_DONTCACHE_DIRTY when the folio is already
counted as dirty. To decide whether the folio has been counted, it checks
both PG_dirty and PAGECACHE_TAG_DIRTY under the mapping->i_pages lock.

> diff --git a/mm/filemap.c b/mm/filemap.c
> index 5176c4125a4db..d0e4d1788fd40 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1644,6 +1644,48 @@ void folio_end_dropbehind(struct folio *folio)
>  }
>  EXPORT_SYMBOL_GPL(folio_end_dropbehind);
> =20
> +/**
> + * folio_mark_dropbehind - mark an existing folio dropbehind
> + * @folio: the folio, locked by the caller
> + *
> + * Mark @folio so that the writeback that cleans it drops it.  A folio
> + * already counted as dirty is added to WB_DONTCACHE_DIRTY, as
> + * folio_account_dirtied() would have added it had it been marked when
> + * dirtied, so that the clean that subtracts it leaves the counter balan=
ced.
> + *
> + * folio_account_dirtied() counts a folio under the i_pages lock, in the
> + * section that sets its dirty tag, after PG_dirty has been set without =
the
> + * folio lock.  Every path that uncounts a dirty folio holds the folio l=
ock.
> + * So with the folio locked and the i_pages lock held, the folio is coun=
ted
> + * when both PG_dirty and the dirty tag are set.  PG_dirty alone is not
> + * enough: a dirtier past folio_test_set_dirty() but not yet counting fi=
nds
> + * the flag set and adds the folio itself.  The tag alone is not enough
> + * either: __folio_cancel_dirty() uncounts a folio and clears PG_dirty, =
but
> + * leaves the tag until writeback or truncation clears it.
> + */
> +void folio_mark_dropbehind(struct folio *folio)
> +{
> +	struct address_space *mapping =3D folio->mapping;
> +	unsigned long flags;
> +
> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> +
> +	if (folio_test_dropbehind(folio))
> +		return;
> +	if (!mapping || !mapping_can_writeback(mapping)) {
> +		folio_set_dropbehind(folio);
> +		return;
> +	}
> +	xa_lock_irqsave(&mapping->i_pages, flags);
> +	folio_set_dropbehind(folio);
> +	if (folio_test_dirty(folio) &&
> +	    xa_get_mark(&mapping->i_pages, folio->index, PAGECACHE_TAG_DIRTY))
> +		wb_stat_mod(inode_to_wb(mapping->host), WB_DONTCACHE_DIRTY,
> +			    folio_nr_pages(folio));
> +	xa_unlock_irqrestore(&mapping->i_pages, flags);

[Severity: Medium]
Can WB_DONTCACHE_DIRTY still be double-counted here if a stale
PAGECACHE_TAG_DIRTY coincides with an unlocked dirtier that has just set
PG_dirty?

The comment explains two separate hazards:
1. __folio_cancel_dirty() (or folio_clear_dirty_for_io() when writeback exi=
ts
   early before folio_start_writeback(), such as in
   iomap_writeback_folio() -> iomap_writeback_handle_eof()) clears PG_dirty
   and uncounts the folio while leaving PAGECACHE_TAG_DIRTY set in
   mapping->i_pages.
2. An unlocked dirtier that does not hold folio_lock (for example,
   zap_present_folio_ptes() or follow_page_pte() calling folio_mark_dirty()
   under the PTE lock, or mark_buffer_dirty()) sets PG_dirty before
   acquiring mapping->i_pages.xa_lock:

mm/page-writeback.c:filemap_dirty_folio() {
	folio_Batch /unlocked caller
	if (folio_test_set_dirty(folio))
		return false;

	__folio_mark_dirty(folio, mapping, !folio_test_private(folio));
}

If both happen on the same folio, PAGECACHE_TAG_DIRTY is already set from t=
he
prior __folio_cancel_dirty() or folio_clear_dirty_for_io(), and then an
unlocked dirtier sets PG_dirty via folio_test_set_dirty(folio) before taking
mapping->i_pages.xa_lock in __folio_mark_dirty().

If folio_mark_dropbehind() runs in that window, it acquires
mapping->i_pages.xa_lock, sets PG_dropbehind, sees both
folio_test_dirty(folio) and PAGECACHE_TAG_DIRTY set, and adds
folio_nr_pages(folio) to WB_DONTCACHE_DIRTY.

When the unlocked dirtier then acquires mapping->i_pages.xa_lock in
__folio_mark_dirty() -> folio_account_dirtied():

mm/page-writeback.c:folio_account_dirtied() {
	...
		lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, nr);
		if (folio_test_dropbehind(folio))
			wb_stat_mod(wb, WB_DONTCACHE_DIRTY, nr);
}

it sees folio_test_dropbehind(folio) is now true and adds
folio_nr_pages(folio) to WB_DONTCACHE_DIRTY a second time, while cleaning t=
he
folio will only subtract it once. (And symmetrically, wouldn't
filemap_clear_dropbehind() in the same window subtract WB_DONTCACHE_DIRTY
before folio_account_dirtied() has added it, while folio_account_dirtied()
then sees PG_dropbehind cleared and never adds it back?)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261024221152.6965=
-1-snitzer@kernel.org?part=3D3

