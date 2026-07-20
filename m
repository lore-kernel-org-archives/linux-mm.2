Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 579A5C44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 16:54:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F18C6B0092; Mon, 20 Jul 2026 12:54:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A28D6B0095; Mon, 20 Jul 2026 12:54:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B9636B0099; Mon, 20 Jul 2026 12:54:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E41C36B0092
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:54:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7A4ACA0432
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 16:54:05 +0000 (UTC)
X-FDA: 85009752450.04.B52D254
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9F57520009
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 16:54:03 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QNUV8Spo;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784566443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7AT1fmFCop8IR3V0Q4KON7DzqnonSG1+pmW4Dcgg6CY=;
	b=K6HtzzktPI9DfyqAoHgcuidoV45lBdhb5V02ihoWAKlnr4aI5SGqbHx3LNBxZxD+Q941re
	wOx3YvGBT48clA7N57DxHXXGIvf0hyzTpieC++xhLlPPBBXeJha3dOJDShAmOBzdwNaEhj
	iu6RtBzE3KIaUGzdabpZnWJc9Em1Ms0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QNUV8Spo;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784566443;
	b=oSOhiZLugPc8BYHaOZpttSWXRYu71oMgiNfdTavDRMNqYi4C+egTNNxAtTbjGksb3nMGao
	bR//X6szKbKTbjaTlvMty/12dDXSOndgrynoztTNzw+zjuSGr4b/wMReMN1AQnkvStexEa
	hwhpFp3RwmHzu/IBySH4lo/jwodUdAQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 08A4C60052;
	Mon, 20 Jul 2026 16:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69EFD1F000E9;
	Mon, 20 Jul 2026 16:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784566442;
	bh=7AT1fmFCop8IR3V0Q4KON7DzqnonSG1+pmW4Dcgg6CY=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=QNUV8Spov+ilPWcBhIFLv4ZpUHhHNBYyXdiG/ZLE/HAGwESwXIpBIapJk0hmLqfTJ
	 Layw3ucpYBhUzsUOGfUO7wu/AYaf+DVeXxyKfWBkh37dTiqsHOQOsYOndXkNcsDJlA
	 p0JvI+VmUcu89IpUVry0QKUXBxhK+1EgSYUJ075e6WStlF2SMp2e9Wt8w0DiJlVVOM
	 UeWf3eu9VmhrjRY5qZqIU99Vn+nUEWmR/ud0x1vbc/0f58lyH8whnMLhvIipseScrb
	 WYfQWcKXUezRXmM1dUPQK62tk79W+XDJ+tBuAUDjYeNXegtI/KXQmygJGpRsVSz7w3
	 rLDQKhpfUzYpg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 2/8] mm/khugepaged: factor out page cache folio reading
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260720142913.846902-3-pfalcato@suse.de>
References: <20260720142913.846902-1-pfalcato@suse.de>
 <20260720142913.846902-3-pfalcato@suse.de>
Date: Mon, 20 Jul 2026 17:53:38 +0100
Message-Id: <178456641833.466529.705177494660463357.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=5884; i=ljs@kernel.org;
 h=from:subject:message-id; bh=KFlk4OhorSFm0o7KQsYObbZZiY9XtU55shBwnuM+HY4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLigmZksLHbPdaq0z9vduaN4xxe/+OyjgJqi3eKOQUt/
 hN4fG1rRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACZi8peR4diD0wEreE+civiu
 ZfroRyKTx4INB0tThQWK5ypv8z9yRYPhf05L/3Vu//aLTc52OxtrL9TanL3i53L8FnfqI9VEhuY
 qHgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9F57520009
X-Stat-Signature: f1c7e88anz9n7omtadgow3xi6psjywif
X-HE-Tag: 1784566443-810538
X-HE-Meta: U2FsdGVkX18L2Wurmloyo22QPiynsrjo8SqUxUrwF5Q8qYP82/zM48x2nLoeiHKTggMhjpY7nsHgwtkG/adnbMvA/8BnH7KNcGU6HJ8zqh1ibioBuuVKfo78eUF6R3M4vW3mADXMED4tVpGJz4ffElF2EXQirT+Ti0id7+WTFf0NsQD8F3fXty2OQVRASFmrxHnQqWvTYDpNIqYQl1wc52WjQquM2GnDQiFSTDcsuLuxIkx8HuRBvlizplxfFbGNJt1VFxWqOkXJ68QxI1BtQIsDT8AZ55PweWf+N7daZcXkDf+xGGRV/OrXGBpE/v+OrETKsTM687n2TBUlaYYGxUTlsAJIIp0S7gLg6NotF9BVy+xu1EICanMtZxSZPhGOI97loL+OD17Rt7UPrql3FOYu5VUD+FPNmpToLSOPjpShWQJ1Rej/Rl+vu5ZeeMYNRTkmUgMGF5QNFOyx7zcA2RoQt59jn7j6DSNHhs3GiJA3yUKOpZkCimIvEqXsbcu6ltO79tnVyZWl8sd9J6+hDwt+wv/K4BoOfyVbiRDWyu8HMKPZHe0l6g81Da7EQ4XAqBrHjuNAaWeAG7EArtSLcAZf9TX0canCz/7iBgtoHXs5O5WkmN1C7DypI6HaBLnA1sf3lIrz8YWKP5Q3nqHDxlbcEZNRLajabqG4gjLcBjH3DzImq/rX+zvELre85xzs8kOP7d8thdUMrqq39qndLFDYsbUDHFe/eG5lf0QX28W67ndu6T6p/TuqbAGznA07zixUQOnIPGW4PfuMUERR8T29499wkCv+gOy/vjPmKNicUWTgz6qpwk9rX3h5GKg2unv8FWkWbIqHUutLwOY6PVTy13DGspkBoR8UGril+Wq1ZGrgRAVuwNCANP4de8MDJR8BVsw+iyw8JNdXAu8i7zxQApU0KssZ9SjeUyvNmHlNBpN0rpRAgkDPJpdOCEKiBek6z7Fzlkh0a6z89pG
 63BMdZed
 t7skCgUb8UuXJk2SVkie5sicRKqnjZxwS88zo+dVShkF8pYi6UPt+1BLwJtvvM9sPhxos1bPED5FiYy5+QXf/+p8mtkHpEN5I3qY1ZmvdrPtGKBTc5BNqZVRj42eBINuPMMohZ3jG5agxi29BVz794jAuOLGYmX54YrNDs64yjYihi6TqopTyMXykA2KWPuRuk88oRD8XS+Uj6dIXN7DlcOX7iqFzn1BcSH2p+EPLxInUF+4nE8FWkDLcAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Jul 2026 15:29:07 +0100, Pedro Falcato <pfalcato@suse.de> wrote:
> The two mechanisms (shmem, filemap) are quite similar and only change in
> subtleties. There is no need to have two variants. Factor this out into
> its own separate function, shared by both paths.

I think this commit message could have some more detail, it's difficult to
figure out what's new, what's moved, etc. so mentioning that and the broader
purpose of why you're doing this (iteratively improving file collapse in
khugepaged) would be nice.

Also there are multiple subtleties in this patch as noted below, none of which
you've described here.

You should describe every bit of logic you're changing compared to the original
and why that's OK.

Or ideally really, separate out the mechnical changes from the logical ones.

> 
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

It's a little tricky to figure out what's moved, what's new, etc. don't be
afraid to break out into even more commits to help reviewers :)

>
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index d4de507ac001..4cc6917a55c7 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2230,42 +2230,63 @@ struct collapse_file_state {
>  	unsigned int is_shmem : 1;
>  };
>  

It'd be nice to add some comments to these bits!

I noticed that you add them later in the series but it'd be good to add them
earlier and build them out as you go.

> +static struct folio *collapse_read_folio(pgoff_t index, struct collapse_file_state *state)

90 chars here be nice to try to stick to ~80 :) simliar comment to last patch.

Also the name seems to imply you're _always_ reading which isn't the case.

Not sure we need the collapse_ either. Something like 'maybe_read_folio()' with
the state implying what it's used for?

> +{
> +	const bool may_bring_uptodate = state->is_shmem;

It's nice to make this self-documenting, but we could make life easier for
ourselves and avoid the (apparent) inconsistentcy of using this and
state->is_shmem separately by just doing the full check here:

	const bool bring_uptodate = folio && state->is_shmem &&
				    !folio_test_uptodate(folio);

(putting the folio decl before it ofc)

> +	struct folio *folio = state->folio;
> +
> +	if (!folio || xa_is_value(folio) ||
> +	   (may_bring_uptodate && !folio_test_uptodate(folio))) {

This X or Y or (A and B) is confusing, separating out bring_uptodate makes it
easier.

Can make this a guard clause like:

	/* No reason to read the folio. */
	if (folio && !xa_is_value(folio) && !bring_uptodate)
		return folio;

Which becomes its own form of self-documentation.

But I'm concerned whether this is correct.

For the shmem case you're going from (xa_is_value(folio) ||
!folio_test_uptodate(folio)) to (!folio || xa_is_value(folio) ||
!folio_test_uptodate(folio).

Again you do need to justify these changes somewhere.

> +		xas_unlock_irq(state->xas);

Be nice to have a comment as to why we're unlocking this.

> +		if (state->is_shmem) {
> +			/* swap in or instantiate fallocated page */

I know it was in the original code but this comment feels superfluous.

> +			if (shmem_get_folio(state->mapping->host, index, 0,
> +					    &folio, SGP_NOALLOC))
> +				return NULL;

Looking through the logic I see that this returns NULL which gets checked first
below and results in SCAN_FAIL, but it's not obvious when first reading the
patch :)

Argues for more info in commit msg + separation of patches.

> [ ... skip 16 lines ... ]
>  	enum scan_result result = SCAN_SUCCEED;
>  	const int is_shmem = state->is_shmem;
> -	struct folio *folio = state->folio;
> +	struct folio *folio;
> +
> +	folio = collapse_read_folio(index, state);

Again would be nice to have index in state :)

> +	if (!folio)
> +		return SCAN_FAIL;

Previously we always did the LRU drain regardless of whether shmem_get_folio()
or page_cache_sync_readahead() failed or not, now you're not doing that.

If an intentional change, you should explain why.

It'd also be nice to separate out mechnical moves from logic changes, as it's
hard to keep track of the new stuff you're doing vs. the stuff you're just moving around.

> +	if (folio != state->folio) {

Is this always the case when the operation succeeds?

You're going from always doing LRU drain and exit early to - only if folio !=
state->folio which is a logic change AFAICT.

> +		/*
> +		 * collapse_read_folio() got a new folio. This folio is locked
> +		 * and ref'd up. Nothing tricky (dirty, writeback, etc) can
> +		 * happen, so bail now. But before that, drain the local LRU
> +		 * add batch. Otherwise, it's very possible folio_isolate_lru()
> +		 * will not succeed.

Hmm :)

I feel we could collapse this into something more succinct like:

	/*
	 * We read a new folio which is now locked and pinned. Drain so
         * folio_isolate_lru() sees it and bail.
	 */

> +		 */
> +		lru_add_drain();

This is now out of order compared to the code it replaces for the !is_shmem
case. Is that OK?

Another thing that'd be nice to cover in the commit msg, it does need to be
justified.

> [ ... skip 31 lines ... ]
> -			goto xa_unlocked;
> -		} else if (folio_test_dirty(folio)) {
> +		if (folio_test_dirty(folio)) {
>  			/*
>  			 * This page is dirty because it hasn't
>  			 * been flushed since first write.

Th resulting code in prepare_collapse_file_folio() at this point is pretty
horrible, I realise it might be an interim state but I'm sure it could be done
better, for instance separating out the is_shmem vs. !is_shmem logic into helper
functions etc.

Let's definitely try to split this up into more patches so it's easier to follow
on respin please!

Thanks, Lorenzo

-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>

