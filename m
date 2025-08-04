Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1086C87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 16:26:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60EE28E0002; Mon,  4 Aug 2025 12:26:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BE9E8E0001; Mon,  4 Aug 2025 12:26:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 487028E0002; Mon,  4 Aug 2025 12:26:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 364BE8E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:26:34 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E0615BB4EE
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 16:26:33 +0000 (UTC)
X-FDA: 83739603066.06.F584460
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf13.hostedemail.com (Postfix) with ESMTP id CAEF420008
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 16:26:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W+bYsi7N;
	spf=pass (imf13.hostedemail.com: domain of jlayton@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754324792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y47xSPelFwOa3thTFhzDwZH/FbeYQuHeI2+BbqjLngA=;
	b=SnFdw6P+BV42LCgg0X5tM46toMhBnlA7R6P9HGDiwDWyaouzhBucKFtd4XQX6b788z6KXK
	6v81Q4I6+LITpiO2E6Szsa/lEg+PUAnCcBf6471qkjSEUNoki7XZyJ4bqF+wd9L6RzVWEb
	atRr8HdomkCPOJklcMItU7kSjQGDghs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W+bYsi7N;
	spf=pass (imf13.hostedemail.com: domain of jlayton@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754324792; a=rsa-sha256;
	cv=none;
	b=X1GREWEQPX5ip7PrjT+t+4p5gKlnvnjNQ9lkV/kEUIejDXpMAq8vQKc0fbk6ggdpKotNw3
	GZYeTCWkmjZxWtzpg/cqkozNuKd5n43PiKb2i7CEtVofwP6p2nU/D5u1ADrK570dBIwGlx
	4QLGKsFHBlkPn0Ni63gp25lCiIpWTAs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id D61005C640B;
	Mon,  4 Aug 2025 16:26:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86D0C4CEE7;
	Mon,  4 Aug 2025 16:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754324790;
	bh=L5ACyzAlA0YlxAF7uYe/Bpae6JGRGz2cx1uIB+/4ZTc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=W+bYsi7NBjs3nD34FDIGMu1pn3rCxNEOgweJjcvVNxgjiYW2/sUWAcgdYh1tRRZWZ
	 GxcToDthAhyDufHnjIqhBh9Dtr60ZrOR0vFR68G/fwmN3+hZkSzMMxsPFUxS0YyY4g
	 z6mWIwGrwoVkG4VNMIn+BgI37IfyBe9NjTLvXmYvQ5GK0/L/XAZtx03I+ohfCDIg6D
	 ObTk9DOyn3tDSq/r/oYP/c9Hy3iLJAJrM7AIzF+dQAiE+0Dr+0CwwRjLqr51Nc634p
	 Qc0Jj8zjQr35qvQ4zSZWfEtu9OTD0CS8MNB03m8Owvrvc29w6LN7I/PHx9T1z5lYWU
	 gb6/Ht7IDBdmw==
Message-ID: <51c6bdaca7b9cde34a3114208283098de827b639.camel@kernel.org>
Subject: Re: [RFC PATCH v1 08/10] mm: refactor clearing dirty stats into
 helper function
From: Jeff Layton <jlayton@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>, linux-mm@kvack.org, 
	brauner@kernel.org
Cc: willy@infradead.org, jack@suse.cz, hch@infradead.org, djwong@kernel.org,
 	linux-fsdevel@vger.kernel.org, kernel-team@meta.com
Date: Mon, 04 Aug 2025 12:26:28 -0400
In-Reply-To: <20250801002131.255068-9-joannelkoong@gmail.com>
References: <20250801002131.255068-1-joannelkoong@gmail.com>
	 <20250801002131.255068-9-joannelkoong@gmail.com>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-1.fc42) 
MIME-Version: 1.0
X-Stat-Signature: 7te6yrfmpiwt6y7tai81spjyduurd1q7
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CAEF420008
X-Rspam-User: 
X-HE-Tag: 1754324791-67094
X-HE-Meta: U2FsdGVkX1+zQn0iuVyzTekJPLUDtS7leZTQdDgoaekbpWRMMwXHYh9X2pzCqaFhKAZ8iuzPsjJT2VA70W7Y6+60y1TNa/chgJrSszrTSuKc6cfFQOtiZmwmDvi12vYdiTtByU6qeAQKqcKuuz8e7sYXgk2JEgomHsLsJLkN81rBKflJUCAxLRwsERDawiUlp5lJVIQNaWR6j7IQQRij3eze193DUzWicjpeGrXys3TOtNW6EJgA1OMwpPM8CtLH2pD3Fz1vBMn1oJWq058E6S+RDjhmVofoSw6xZNc91ztNJ3o6WvLr5+HQam080oLG8GtmKhh5SSI8tZVfN0ox5peyMKMw71wyTWnRh/sAtusmZVxDU/ayTieRVUp0UvIdqcpGOQLaj6G84iB4bBo1V34WEgyh3Af9+y7hpmO5+5y/99d5zvkgWSeppuloL9YB0hRVLvZ9PERfkRBfc9mhV1LSt25EEpxkBqx+DGmmHsAffg+VMLzKbLh8nlf38Jsm2vFFnM3w69KtqUho3Zhvw7aoyn3NMXc2gRO5Q0bTTPzI+a6ACW1c7GuZ9+gJrDoJ+AYsVz3JaHhf6ZmG3nXiygSf9oYVpSRA84XhZRKS1EhWyDiQl4k38bAdYd9GBzFL6lrZ5l7SG49wYVtKJNhzFXcm6i2JLvxxCCjgnkcaFJUo391ehLSAKBkBKIzpNgg5WgEuQGxeshgo933vvIuoD7tw1i36q4jQOhcy/XTOC3aF8zzthXdobIgpPnY+KBq29iCtxiDT3cUrolG4CpNWnWv5KZwL39+fotGn+5fmWKAr765WjJQ3CjiU98MlnblRIcvuM9KiDHE5jebOBelm0qjpzvkHuoRSXBBQIKoJi6V3JboCBGF3YrM3yyKmIRUyLiCvidkKO7HeEq9JO+gIbvkDyfrcldcIlX/Z5AKPBENK6bgOZEURceJGXMADmyKfQWhj6ZoHdgJ53hLorNQ
 EK3xfAWF
 P2oYkje54gHhd54yTZJRYTLnLliTVIGG1+mi+KIF17XwRc8ZWxUC+afYRz0vo0paajF69uKNRazgW0lD488JWx9F1OLWfH8OyMF9TJM4HHLGXfpIZ8fR9PQqggxKEZemN7T8axYk7Z47qgmm17sQTIZanFmNaolYwpZaJV+dDNLOXTsJbbbOgZMAPV4YjrZFbZHvU7c58uy8hghqtVe0j/yBDqZQoXcCSwGdnz3OdIacP35+vSUx6njxSyaTl9Ozp5gg9bg0/ba6Zdav4Ir/IWegZiwaUDlvtW/aP3hm1buLC8Zs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2025-07-31 at 17:21 -0700, Joanne Koong wrote:
> Move logic for clearing dirty stats into a helper function
> both folio_account_cleaned() and __folio_clear_dirty_for_io() invoke.
>=20
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  mm/page-writeback.c | 23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
>=20
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index c1fec76ee869..f5916711db2d 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2703,6 +2703,14 @@ static void folio_account_dirtied(struct folio *fo=
lio,
>  	}
>  }
> =20
> +static void __clear_dirty_for_io_stats(struct folio *folio,
> +			struct bdi_writeback *wb, long nr_pages)
> +{
> +	lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr_pages);
> +	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr_pages);
> +	wb_stat_mod(wb, WB_RECLAIMABLE, -nr_pages);
> +}
> +
>  /*
>   * Helper function for deaccounting dirty page without writeback.
>   *
> @@ -2711,9 +2719,7 @@ void folio_account_cleaned(struct folio *folio, str=
uct bdi_writeback *wb)
>  {
>  	long nr =3D folio_nr_pages(folio);
> =20
> -	lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
> -	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
> -	wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
> +	__clear_dirty_for_io_stats(folio, wb, nr);
>  	task_io_account_cancelled_write(nr * PAGE_SIZE);
>  }
> =20
> @@ -2977,14 +2983,9 @@ static bool __folio_clear_dirty_for_io(struct foli=
o *folio, bool update_stats)
>  		 */
>  		wb =3D unlocked_inode_to_wb_begin(inode, &cookie);
>  		if (folio_test_clear_dirty(folio)) {
> -			if (update_stats) {
> -				long nr =3D folio_nr_pages(folio);
> -				lruvec_stat_mod_folio(folio, NR_FILE_DIRTY,
> -						      -nr);
> -				zone_stat_mod_folio(folio,
> -						    NR_ZONE_WRITE_PENDING, -nr);
> -				wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
> -			}
> +			if (update_stats)
> +				__clear_dirty_for_io_stats(folio, wb,
> +						folio_nr_pages(folio));
>  			ret =3D true;
>  		}
>  		unlocked_inode_to_wb_end(inode, &cookie);


This seems like a nice cleanup that isn't dependent on the rest of the
series.

Reviewed-by: Jeff Layton <jlayton@kernel.org>

