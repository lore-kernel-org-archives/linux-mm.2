Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7A19606A88C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 01:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LDmVtL2F
Received: by kanga.kvack.org (Postfix)
	id EC2D66B00EF; Wed, 11 Nov 2026 20:56:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9B146B05B0; Wed, 11 Nov 2026 20:56:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD8166B05B1; Wed, 11 Nov 2026 20:56:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C15796B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:56:52 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5CA18A7FCC
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 01:56:52 +0000 (UTC)
X-FDA: 85424803464.28.770B06A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9DFE520003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 01:56:50 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LDmVtL2F;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794448610;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5jotAfjUQKZzmN9NNL+HNgueiGV8Iqsno2VVPILj99I=;
	b=UOd1gAUgrLGGdRib/NwLJgoHcp5vG8piMz2SaSqnmeua3Aody5wvbVJYrx41z3rQ4Q3tNV
	CaxeIX9ubiaqAvjUcOcow7v/URcYNqVDTUIUk/Of+4vVRBObLIXHIzHqNTtWzJfbDwRJxo
	Sh/j6WaHbWBMraBVVb0Zv/lydPcmeHY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794448610;
	b=LJ6bSPh9mWy94HHjFuBVVddAxauk3U926cRsRORAZrGK/4MqwGRo8WHOK5yWMLfD9tp8f0
	9Qaz/o3k7Cscc6wkXyWWqHmKXd6xOvzNJPBu3iYl3WJMRmJZyhYdOSarOKkSs+uLT3js1E
	Z4xbJ07RDXxufoQ54A2hLrHg+2GPQUM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LDmVtL2F;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 67D3F633B8;
	Thu, 12 Nov 2026 01:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9891F00A06;
	Thu, 12 Nov 2026 01:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794448609;
	bh=5jotAfjUQKZzmN9NNL+HNgueiGV8Iqsno2VVPILj99I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LDmVtL2FQOakLI7PWOcytJhp1AAu4emz95L1lKl7oTszbpBbC9KmxqcmSjqxDTgro
	 DV/NMz3+8hXpQcIaET3WvcOB6+YdQ6S+rmmzEDHuYFL9YV4k3kVgcQzQpQM26rErI6
	 aG1pFpwtVyQu6wyb2iUaw2rkSdOJolKu8RzxRSf+GueJR/JVSZsdon3iZ9adcB7VHT
	 AZgRUezIG+j7ifhEQvvqs9zE4Fdlbr1xPcSGEVM6E0HQGenXLmKwBoyoByAeARxfRf
	 Y4NeWqiH7VDB7K1C5g5R968NUGZIxmUa8s9T5G2uK3P29/tIQGXCJ3sjj0UDS/uci8
	 3qXWNTa9w0IXA==
Message-ID: <sashiko-outbox-210121@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 4/7] mm: add folio_mark_dropbehind() to mark a folio
 dropbehind and account it
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mike Snitzer" <snitzer@kernel.org>, "Matthew Wilcox" <willy@infradead.org>, "Jan
 Kara" <jack@suse.cz>, linux-mm@kvack.org, "Christian Brauner" <brauner@kernel.org>
Cc: "Chuck Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <20261111015607.46338-5-snitzer@kernel.org>
References: <20261111015607.46338-1-snitzer@kernel.org>
 <20261111015607.46338-5-snitzer@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 01:56:48 +0000
X-Stat-Signature: td68yrcp3momyuqxh9hbjq5oy7nbrr7z
X-Rspamd-Queue-Id: 9DFE520003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794448610-101940
X-HE-Meta: U2FsdGVkX18yrryJllpI+fcyMN8o/7Nw1yS3iL64seM6jMym4o7FS9ppdL8cdDZhWnaBeg1wm+A/uxytyCLI4De7wRtcQtApNvrIHUzR6+bN7NKPY2+2EEqCOjg0ZCtQQh/NzppxI2NeRWgaIlhwAggDcYiJI0IxEwxAgNeWJFjmY/PtU3LBYx07zzBDXZhd4WCYsVbO2vl+6lEXJY+Ou78ZCyxZx89Se8lUfKr1iBslrn3ZxCdjqI7/GVlaamWVFnAyRL5jGpaKB69fFIPAGGKq9p08gHjxLxvzd0zEdB9NHKX+mSw219rt1TK0CFBcLVm8aoOWdALJAnOpx4Txo3uI1Cvgj1r/9qkjqElYX+kxI/3y/7Bb00zar/d2IDzTQjNPlIzVOIXvLyhxwU2rjMoYJIc5gkjgofpyTcz5y6HMFJ746o/EtzvAbWyJziVy/yxQdqjMLWzZstd+eEYaTeW4fjorxpebdH32pD1bMwNZBRxWJZkYPZR4meoNmbJhPtKzb5Txm1jrhk8xPKhH31fYBU/SgigZ/KmonNIsVGOl8rg/waKISF+HCK7atW89MQZ6d2SvGsdRj0chxErlMEQf1GUaGqrEaX+9n5Lscz60XDHNMaj3JXqrOlNFQ7Z8mRcJuM/JKhYRQELua52fLS5zuEn1pu5sUDh6PgSFBEnPPgEv98xDJE88z3ikKTvzoqf4W8nwBs2cy1/6PAQI/9EpLm7MOmbVQN53kCl18XOQWkNCjCQThlM+jsQ1K1/kEwGK8Lkic7JF/tfO8KOhzQek+Du/EBOYFaPYFyrjR4E8wTKAQYZfhNHUlt3GZa1GXMN53is1bbuJanTt2O1smUYswGd5FVCHxzZVMyD9NvfcVT30F6JhotvHD50SMQY7zI0VT1DNBEva0fJJsEtpiVlDwEj5QWtuwAs6viDEf2xt3d+te/uNooXc/OBDvEkFbKyhQkf8bWABTsL9mH9
 8LIs0MaB
 HJkTKK+kRv5epz1KhmGU6gFNCDTUEBP9jDmfjvSzWaIW13Qkpk/xM++uviIYgMvQai21yxpzjR8qqt1vCWTqNVmV6QiNRMAj+pIFRxXo46+iyq2PogIoZUmMi9NRaApnw0DdDtIPLlWvg9ZvsM41nxo4HBjGA23cZDscRmVYlVjN0WOjLXILd9f5/f2GZIENRiaBpMvWSc6e/W+yJWUF0yxVnPHEn5yYz+dMjrmYsdScYOgW0tWnOjQ1SsDWYgydaVCKRpJrZNU38vvVtAhPmZcsutyZlcZMhUt8a9XzOokCc9zq3pLaRl5RvydJM9fBeQEkgmHv4/5cFrndCngioawdUwxOmr4f0GZrA99bS5s5VuUKrtCASNwjSWXjAqSBP33MPu6eE3nx8MqNEMxalQwfejLyR4u1g2yVSY6xChDLb/xjeb7MNxq7REH8r0blIKs5hphJVrvGEMQZU6/17b5NplLqWTlLA6gLCSXKYszFfHx/2BCgTuN52N1QfVUPIUeAS1quUOViVA4tB/4Hi0/IgAETGI48TsWgz+njf/+YG6GlYXe4qQe+7nYfrPuKcfmfEdj/1Z53Ycdo+zvzWC6Zjfet8eQlHG3nbq6hZRSLYdzcUIhRhUMYT4Zx48K1yVtqY
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
- [Medium] mm: double WB_DONTCACHE_DIRTY accounting in
  folio_mark_dropbehind()
--

commit 99c7597afc26e4465bf2ced6117179f389f8476b
Author: Mike Snitzer <snitzer@kernel.org>

mm: add folio_mark_dropbehind() to mark a folio dropbehind and account it

This commit adds folio_mark_dropbehind() to set PG_dropbehind on a locked
folio and account it in WB_DONTCACHE_DIRTY if the folio is already dirty.

> diff --git a/mm/filemap.c b/mm/filemap.c
> index 98ce955404127..a54d0fbd37222 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1654,6 +1654,38 @@ void folio_end_dropbehind(struct folio *folio)
>  }
>  EXPORT_SYMBOL_GPL(folio_end_dropbehind);
> =20
> +/**
> + * folio_mark_dropbehind - mark an existing folio dropbehind
> + * @folio: the folio, locked by the caller
> + *
> + * Mark @folio so that the writeback that cleans it drops it.  If the fo=
lio
> + * is already counted as dirty, which with the i_pages lock held means b=
oth
> + * PG_dirty and the dirty tag are set, add it to WB_DONTCACHE_DIRTY so t=
hat
> + * the clean that subtracts it leaves the counter balanced.
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
> +}
> +EXPORT_SYMBOL_GPL(folio_mark_dropbehind);

[Severity: Medium]
Can this double-account WB_DONTCACHE_DIRTY when racing with an unlocked
dirtier on a folio that still has a leftover PAGECACHE_TAG_DIRTY mark?

__folio_cancel_dirty() clears PG_dirty and uncounts the folio without
clearing PAGECACHE_TAG_DIRTY in mapping->i_pages.  Because callers such as
zap_present_folio_ptes() -> folio_mark_dirty() -> filemap_dirty_folio()
dirty mapped folios under the PTE lock without holding the folio lock,
they can set PG_dirty before acquiring mapping->i_pages.xa_lock:

CPU0 (holds folio lock)           CPU1 (holds PTE lock)
__folio_cancel_dirty(folio)
  folio_test_clear_dirty(folio)
  folio_account_cleaned(folio)
  /* PAGECACHE_TAG_DIRTY stays set */
                                  filemap_dirty_folio(mapping, folio)
                                    folio_test_set_dirty(folio)
folio_mark_dropbehind(folio)
  xa_lock_irqsave(&mapping->i_pages)
  folio_set_dropbehind(folio)
  /* PG_dirty && TAG_DIRTY both set */
  wb_stat_mod(..., WB_DONTCACHE_DIRTY, +nr)
  xa_unlock_irqrestore(&mapping->i_pages)
                                    __folio_mark_dirty(folio, mapping, ...)
                                      xa_lock_irqsave(&mapping->i_pages)
                                      folio_account_dirtied(folio, mapping)
                                        if (folio_test_dropbehind(folio))
                                          wb_stat_mod(...,
                                            WB_DONTCACHE_DIRTY, +nr)
                                            <-- counted twice

When the folio is later cleaned, folio_clear_dirty_for_io() or
folio_account_cleaned() only subtracts folio_nr_pages(folio) once,
leaving WB_DONTCACHE_DIRTY permanently inflated and causing
wb_check_start_dontcache() to trigger extra writeback.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111015607.4633=
8-1-snitzer@kernel.org?part=3D4

