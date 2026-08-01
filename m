Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5621C55173
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 18:49:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B19C06B008A; Sat,  1 Aug 2026 14:49:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF23C6B0092; Sat,  1 Aug 2026 14:49:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A08516B0093; Sat,  1 Aug 2026 14:49:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 74F896B008A
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 14:49:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0516B16036B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 18:49:54 +0000 (UTC)
X-FDA: 85053589950.11.68142DF
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf17.hostedemail.com (Postfix) with ESMTP id 44A9840009
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 18:49:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="U9z6m0C/";
	spf=pass (imf17.hostedemail.com: domain of hughd@google.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785610193;
	b=1d4qKIyFjWWbPao1u3UG8h7X3UPde6iJ50c2pF6jCflPKhQRoOwzfOn22uQbAySTdOe9Q0
	Gr62ahORPO2qToZ8DVXObj+vwGm5UOytUZd/6mTmRF/NO+H/QYnz340nWCW9qiZ0nUB6Oc
	s2Oc9AfyylCPafr+2u23H0KzNhNwL0k=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="U9z6m0C/";
	spf=pass (imf17.hostedemail.com: domain of hughd@google.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785610193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NBwyWL5vh2enJmrBMYpGdLkECX4vKqcM+TreBJTlvII=;
	b=moOpjmJ2zaKabLSOrmbL9IitxRuLtZnONDeQIkltcxbWBcskVygqFxZ+dHmRvfX7e9XiyW
	n+b1ZoQ+9/aExyuXw6wfQBX8qlNMw32sX9F/fu8dGIkFzox0NURsGaxXrgvCEhCV3IkOlQ
	0nNu55HaseMnVAvMoFR2ds2JJF5Qrso=
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-81062fdeaf5so44573547b3.0
        for <linux-mm@kvack.org>; Sat, 01 Aug 2026 11:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785610192; x=1786214992; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NBwyWL5vh2enJmrBMYpGdLkECX4vKqcM+TreBJTlvII=;
        b=U9z6m0C/oOoGW0DiVbFJRiBn2Cfc73YMP7Cd14/Bdh67Gem0hTq9C3rZpZCwi+PYR/
         maPIaTmsFpE1vLbCFIKMC9GAZzR2Yuy1L0QXvL2D6x1zES6jNhaVC8JwKckZLDobWxC3
         ebTCzHFI3T6aWqY2NYG9MMiTk1lhohIGuqGktQtwsT7n9A0LB6k4df2qcXK0LGUDKZEu
         +4WSFs3IV/D6losn793V+yq/OuyDle5xeIGelr9mfXbErH9+PpkaGZMousng/FP4rCJR
         Dp8r5sSmvo1BLcjV96c4JeaWZS4EfiN9clR/ayejufRW9OdUicfHGaz6y1UUV9AMYEbS
         MzZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785610192; x=1786214992;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NBwyWL5vh2enJmrBMYpGdLkECX4vKqcM+TreBJTlvII=;
        b=OZBxMoA7Jpwi988lkIxImhpIKYZ6uIQW2qc1r+hr1cCJl1kamvtD8x4ITk4umNxvy/
         uEDyrd5UCrbkYtYTF+pdJ/xcl1nOfkQnVJeEHYDQ0sLpf8/aDi5ImapW5yxI97yBcdnK
         qPj1afftAthFES58GbSlbOGijQd8Xml3jFlcVUG7kUf4L2vY1RVEtYoY5Cu0sf5PNTl6
         0R+wHCv6UDF+FAOwrmAFHDRu3o7thY1qprAv5XAms5vH+Cfj3P6NxFIiZBcamgYD+rEG
         VhJrhpn1y2rTYeXz1xt+MOH68fs03CxGeHy1vJEgnow+d8G0sJKb7qTfIDsCTOYZ0cRQ
         pXrA==
X-Forwarded-Encrypted: i=1; AHgh+Rp9nOA4kMB9Iaj8Lv4kj+X8AocdCrNQSzNqfKE6vUjul+dJn1S6mb3/dRaH7JmcnIR6V4z0eW07Zg==@kvack.org
X-Gm-Message-State: AOJu0Yw1EKueG/aRDxlB8TMtyfn8X8QIYRN+gEQrMUZBOmLGsgGpghtM
	KUdvCLwLF3K+q5gq7WzQreAQz7srQDGnKQC1Nfvgm7yJolaKz/6pDRAAhjoAOOy9rA==
X-Gm-Gg: AR+sD11Eg+Ftxpf/y6lc6lE9sU0yqtt7KmI5eXlqWUEPW0t/0Phc0DTrmtdUnnDbWte
	VXZ505MkDmHs9e56rQlJ3WCb+Tvsym2KXytChSSMBiphYNZJ486CSc4jf7TXshbQQKSmta+N8kL
	kFKTxWJjlbwii6oY4qxYges1Fvx9d+fJRJHiP6M1duoZKd1DzsAdyZ8ZW1tACFkbftAowzTVLBL
	xii+9mWPxY9OOaappZ4ZA6d43HUIrwUVLCfS4SZb2MN4ux21w3KOGqCYMaDVtkg/WLx/MGyeC3+
	zkH0KTlPz5LNrH0sW7vDd328qn2jrcKKqOn2OSExcJrl6kkgNDmPMEy3noBBZiSvtbCWwNyP4b+
	lV2yVwV4B5T64z7JfX1h4OS3+6QWFTrim5WYaCjfQLCZg0d/oixmLGQ5yCfuZX79KR69gYvUrTm
	QAfEOaOwHFj2IhF4d3CQ/yIkIk4JwdCz1j/X8r5YvengJioOCXb+SO8dg442oOT1lTmlDm9aM73
	kLQa7CjrrertglloCc/elFKqgnhizsGqhnWW8iMK3o=
X-Received: by 2002:a05:690c:b86:b0:81e:4acb:c0a with SMTP id 00721157ae682-81fd4d31d4bmr66094927b3.2.1785610191764;
        Sat, 01 Aug 2026 11:49:51 -0700 (PDT)
Received: from [192.168.1.163] (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fccf2e4f5sm28773407b3.3.2026.08.01.11.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 11:49:50 -0700 (PDT)
Date: Sat, 1 Aug 2026 11:49:39 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
    John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Hugh Dickins <hughd@google.com>, 
    Ackerley Tng <ackerleytng@google.com>, 
    Frank van der Linden <fvdl@google.com>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/gup: fix always draining LRU caches in
 collect_longterm_unpinnable_folios()
In-Reply-To: <20260731-check_and_migrate_movable_folios-v1-1-e0002d7b791e@kernel.org>
Message-ID: <f616e9fc-339d-4430-43ea-0ec8810c5f3b@google.com>
References: <20260731-check_and_migrate_movable_folios-v1-1-e0002d7b791e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: y5t7gc1wzqaet93f7tnpt99da5cb1j3a
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 44A9840009
X-Rspam-User: 
X-HE-Tag: 1785610193-922920
X-HE-Meta: U2FsdGVkX1+Fn8/Y/BhQ2VkAUkYIQsX30uIYeRw5amAYplvVFkgHc/yZZg6P/bXs4QQAPKiAma2NEBypNJWnr2XY+nkottvKTI6u9jhq2DkAz8QU+LTb+nihWsCSBFplxMnoyE18j89U8dsv1t/cT2JEQAaVE/ewC3XPKD9ls+muvIvjGj4QBIx9GRsOM6LguqqE2rAiaWOrixFlNMp3xG5P2svSUnUfIRAQk2JDVyvgpdQxMncYWiylxpXHraNXEyoNKFXeeen4DTc1j+DeBE/jvblWwJLsz4a0joTKddIlOjBDj9tu46NRYhBO46iz7wuYWkQWZZprllfWInM5wD8vQAVhUZUVoqhvGFBd6MtAbDi4FQkON07BZrQJdWBsHZLN+29ClVlqVlWqCusSHfNPfri4jmfn14oSXIMIZTABl8ko3nJjyDa1MNu9dLOncCur7qjMesW9Lw7oJRac+hgAT5dmHyFQF1IzXgdsSWhU+nlTE/eJInieWs+UVA16MXlMFV1HRb+6IeyDomnNP6Vv3r/Zs+43Maeuj27Jz0dckV3dgw7lYVAbfyECBopAGuYtLkeUL4ktviRxWvsuAbMbZp4L1gm8PFmeqybxqiCp4Gm1f2ak5qzgmIQ/mPiyDVrZDMLYePZuafJa5TnbAF5rNvd/EcbhiDFXP6u7vRB/CH6UFKjtcKovEX+2oJp4lP7UGE4renbuKlbbXIkjhb+ijsf3PWMdyuRvx4fPhMvWVtaAmtjGSYWTzzWKXUl3avaysl7v//HhXi7dpQLpKJbiRbPFIpeiJjp5+ZxU0V5HW7955WWx4FlsUwHDbagjbjR0tr3jEj0JiiQns6SJEWzotoVnQ+xguLz3u0b/q99ZLjJCjS0HsQi6h56RgEPZAi8kU80rZngEJUH3xI8A03yaYQBI4IYWF7USqrKGFBKUPezmtVAA85Ab7sykJ45rlyRa3EdrX+4h+1TJmTN
 nEDI57X0
 CcahFcedPE/Q9gnaPoP3EzVPxoS4WtoYgniQ6gWcxI5aww1uDLbTZYtMiyDyk6ucNexWDEFaPo0NlK6SAY0+Zp2gcHOqHGu/nGCemLIunmm2Drn1iZe0X6LpHdEGP27clgFQC4gqLYAyN1/1K/9d8ZMK97NSdJ5X+meVCy5Qcw3ZzFSUdHzHhouXpZGKWWw1JQRuUY2CfI2cHzGkWHQ3l8QaL6QE1vZuFQKxFiwbeOwp3ymw6fa+GUbZ0SjuiDXcPB2U+Yd+JkQ1pn3FcLRXeEXoLAgscbeV268W+78+ztqWo3OMT3V6TSNk+lWMXbZmGzMrVnhBymbnb2L0a/d1CoEWkG/resif0PZhEMpTv/sYdPvq/1+BTRvjnrV6OfITRkjwmozFfSh6L3Eq04WdZDA/x6UFvbQqAlnXBQE2uH0v82zU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 31 Jul 2026, David Hildenbrand (Arm) wrote:

> folio_may_be_lru_cached() is currently only true for small folios, and
> for small folios FOLL_PIN adds GUP_PIN_COUNTING_BIAS references instead
> of 1 in try_grab_folio()/try_grab_folio_fast().
> 
> Consequently, our
> 
> 	folio_ref_count(folio) != folio_expected_ref_count(folio) + 1
> 
> check in collect_longterm_unpinnable_folios() will currently always
> identify "reference mismatch" and first drain the local LRU cache to then
> drain the LRU cache on all CPUs, as collect_longterm_unpinnable_folios()
> is really called after pinning the folios with FOLL_PIN.
> 
> Add a comment because the current code is not quite intuitive: we used to
> drain only to make sure the folio_isolate_lru() would succeed. But then we
> also started draining to make later migration more reliable.
> 
> We'll refactor that code soon a bit, to also make it usable in other
> context where we really want to remove any references from LRU caches.
> 
> Let's add CC stable, because having an easy way for excessive LRU cache
> draining on all CPUs does not sound right. In common scenarios we
> don't expect to every have to drain.
> 
> Fixes: 98c6d259319e ("mm/gup: check ref_count instead of lru before migration")
> Fixes: a09a8a1fbb37 ("mm/gup: local lru_add_drain() to avoid lru_add_drain_all()")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Ughh! And I was so proud of it. Now I'm ashamed. It just never
occurred to me, that the unpinnable pages were pinned there.
Thanks for the fix (but please don't tell anyone ;)

Acked-by: Hugh Dickins <hughd@google.com>

> ---
> Found by code inspection. If someone has a testcase that can easily
> trigger this and result in migration problems, please test! But this
> change seems to be "obvious the right thing to do".

Sorry, I don't (as perhaps is too obvious). And I'm a wee bit afraid
that some of the problems which those changes happened to succeed in
fixing, might now reappear once the drains are finely targeted.

Am I arguing for a delay before advancing to stable?  Perhaps, but
I think not: it's probably best to get that working as intended,
then deal with any fallout if it arises: just be on guard.

> ---
>  mm/gup.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 99902c15703b0..41c3317e0f0f4 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2273,6 +2273,7 @@ static unsigned long collect_longterm_unpinnable_folios(
>  
>  	for (folio = pofs_get_folio(pofs, i); folio;
>  	     folio = pofs_next_folio(folio, pofs, &i)) {
> +		const int pin_refs = folio_has_pincount(folio) ? 1 : GUP_PIN_COUNTING_BIAS;
>  
>  		if (folio_is_longterm_pinnable(folio))
>  			continue;
> @@ -2287,15 +2288,20 @@ static unsigned long collect_longterm_unpinnable_folios(
>  			continue;
>  		}
>  
> +		/*
> +		 * We drain not only to make the folio_isolate_lru() succeed,
> +		 * but also to remove any other folio references from LRU
> +		 * caches.
> +		 */
>  		if (drained == 0 && folio_may_be_lru_cached(folio) &&
>  				folio_ref_count(folio) !=
> -				folio_expected_ref_count(folio) + 1) {
> +				folio_expected_ref_count(folio) + pin_refs) {
>  			lru_add_drain();
>  			drained = 1;
>  		}
>  		if (drained == 1 && folio_may_be_lru_cached(folio) &&
>  				folio_ref_count(folio) !=
> -				folio_expected_ref_count(folio) + 1) {
> +				folio_expected_ref_count(folio) + pin_refs) {
>  			lru_add_drain_all();
>  			drained = 2;
>  		}
> 
> ---
> 
> base-commit: e5492213654050379e78ec6f9acfd6c9fe00f334
> 
> change-id: 20260731-check_and_migrate_movable_folios-43500556943d
> 
> --
> 
> Cheers,
> 
> David

