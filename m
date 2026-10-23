Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 708E8606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 22:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=XvL8xT9v
Received: by kanga.kvack.org (Postfix)
	id 99F376B008C; Fri, 23 Oct 2026 18:30:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 948F06B0092; Fri, 23 Oct 2026 18:30:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 811336B0095; Fri, 23 Oct 2026 18:30:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 564A06B008C
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 18:30:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9B86AA7578
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 22:30:23 +0000 (UTC)
X-FDA: 85355335926.08.8899E69
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf28.hostedemail.com (Postfix) with ESMTP id A3A90C0006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 22:30:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XvL8xT9v;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792794621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b1vVmrd2o2bhAY35x1Wt33iUoT/bMDNuOnBZV1/6OMk=;
	b=lENgqGZzO8wRycnsjb4J6nuCIBzn6KUXl2mkZ/U1pLmjRzgj4f62kUIU4p+2WkpSOHdGAq
	99TdDHyAC14L7O2fHEjEaI7XyUTOT8JzJ5WoxIvILY68R/+h8bRL9GD7lW2I1HfboWXwd0
	4gul/NEcUkDWysHBNihFzqWc1BFIt9o=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XvL8xT9v;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792794621;
	b=uqdOR8vwfvP0OnBn3ANdIBqgm+JMwIx61nFW7KGYGH64jy0eXWBRHmWWYqkwPXRATQNI4w
	NfVEEucgggqBBWX3fI5nuV2+hQHq70zXoWDUync63g5njUrHifRM1K0hDt3tMfkCkutbk1
	Dyy5H4UVb9HZHvuubRe3mwXbumI4Uio=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-49d05d51553so9447015e9.2
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:30:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792794620; cv=none;
        d=google.com; s=arc-20260327;
        b=k8l0uwoyIbJXEJhC1LS//+sN+XVaCnwPtcYLzEaMPBtaHOgUX8wSBNVqUKveM7YpSc
         sKnnjpwm2P/nYzu+rxVbxFotQjmueSHnXHWqaMUMfLCF4/1lOgyO2KbJyO6+JmTk6Pz7
         SYp6TbbsdzpwBr1RQYbdPfp42xi1OTS1XkZk9YhVRWeFcbChjfz60SP6igCm2SmHlb9o
         N0RHN35YY6u91y8FyppBdLiWkWosIHJClC+oMy8nSXanUdcgFbq0ea6MIgU1Q/SbeCYC
         nvQ1Q/UChVPDTLRjzZ8SKLrD/dTOK+KYIgntoRvgEmacv+G3nxZFbnTTltGJ/5pngS8p
         GF1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=b1vVmrd2o2bhAY35x1Wt33iUoT/bMDNuOnBZV1/6OMk=;
        fh=Mgk41HyKAJervv9vd/WLju9SYEShljxEVEIlSuIYEv8=;
        b=IPCbPYyIkQj7uY0/HPhde7R87tDcDng1/VJ7Z8nHWulwIN5opj4OpTVqF9jpsF8YWG
         f7nEN8GsnWIER/xC50patcZpMSsTOScA3iDSiPR5Z+I35QnQJ/EWwqIP7bO3mkQ5uDEx
         Q3Q+TdTC1fH4BNLaTmKaOg4MWUwtJpIF/IaYe149ZvfKUCOIeG2g0cNeJEQXTd6QThFW
         +OaUGCqizgxAqDBeZGbuAPZ8Dl9B80wCPKhjufOaDJKQVTez9kySOnbG7fIarqZTRvFT
         myJ3Mc8iIQ8n4OQ36lQpQyQXYM+SleROKd2J9f7+hCW2bBghg9jfxyDGrMQyrFO9VOq/
         gIpg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792794620; x=1793399420; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=b1vVmrd2o2bhAY35x1Wt33iUoT/bMDNuOnBZV1/6OMk=;
        b=XvL8xT9vTM7UE4Ii67siwWBgKRyq+1WL2fEWAgQhUavTWXgf1sduRph7xjIsRIzekE
         mtltDYVwu62MlfMyXQuLBGmOa+KMeePmxKJHRdwlaeYWIlafgrPLw7uHmBso09tMmV+j
         o4n+nH0+f2EE/lQGW7+jKk6wizsarnc3xesJmkxn7sYel0AdREhIHFILKURmGWh96voZ
         dPKgbamE5NA+fyQNEyKUAQEwE8ecPkHoHRDvm341XYCG6xRqa6uzmgWGR11cJdRTLIPJ
         oeSocT+61rASXrjlysZPwOG4ycD/XddK/K0mnixrFaktLvl8yQvlqwegaHN34W1zxV1T
         Ei0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792794620; x=1793399420;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b1vVmrd2o2bhAY35x1Wt33iUoT/bMDNuOnBZV1/6OMk=;
        b=2VZX0v5BpUPSldC1LZyG+VKchELpa2Fcp5Z8Uyp0M2gGdMe/gCMIOy42bfUmwOIM8X
         CFGKWsaS+4K7OGazd7ZPK5w8dgUl4PIa1hXYjpuqQEx2jplGYz7YapoofF4hbd8awfXB
         xba1MlMOFWRQCg7fi53+zpiiALJFn8crTKq5M/aCR4+ZLmwlL2rahdqZ+YVaRdGPPRrV
         Mm9hTVZElNF8UGsgxIv42Cyj/MfXWn8SAI7IEZGcPV2m4U1xngOa/yFcMt1GbUjh5Nnw
         hTyM0KWy6n7+tN6CVQe8Mk3eWl5T5aptKRWXXMUHP61oKajFd0RzHLiqo1xv9BmiIeVZ
         84TQ==
X-Forwarded-Encrypted: i=1; AKwUvBy4Y6TvZIrEKv02hEsj+6MiEMp+GHS2T3GbZaAhbqQaM98GnKk+v4T96LTkMLMngTFqnFr4T8iYaQ==@kvack.org
X-Gm-Message-State: AFq9FYIjIehZ/eB0KpTNgCTqCbksAvl4iO7hhPDRSIoUqsw4z8Vg7hMS
	JC9CkVqgvNWLItViuNfhpxovohu8bVUD8QElg5EN1lIw+D93uE80CuLa7FLB9Gigcm8/UXApZaU
	zD+7+U1aaUbRHWcExaMbSgnxD8P+AmlM=
X-Gm-Gg: AYBFou2wzuej9i9eMMP0ZynF2ive/28IBDcuveOFTxmUbcsFgXBTlkSQgXosZhtXKqS
	vsF1UjYegHYNnIZRLnjyre0y9PB1yADbk6IYcQIGPWe1XQ7rHzmbYtK5v2dpvz9NDwDlKsiFFFj
	jR9wvHo7iyThFFN61Lohc+EOYvKX98MD2+FKEyyL0oyfN8I0aWGoHlahCh0lzPyoDZyyuqQ/Nph
	G/hyeol2bwpul8V/iuw1b87tBs2CKSYPLk5HC84TCb5Yz54CedtRJq+n1fhBNbbv/S2EOK1jqTn
	Yw05EAku8m7oQfHmi8u12F5w/okYNoX5WBh3hj9FT1Plk7o6GGtFmCqWhI09t17O7jkEL4oPbCi
	g5mpiS3ZirxUFjYLcVKD9KZ9Hk7pwT8uTGnLWsXl3aF8JQqXvASLuLvyPRXpTvjKi8lIh89N8Bv
	/fgKmSxoJkktMk1kmdTDhyBRjm5Uc/ArLDZeTB000bLK+fcrIk3Ojw
X-Received: by 2002:a05:600c:4f41:b0:4a2:150f:1603 with SMTP id
 5b1f17b1804b1-4a35acb3e14mr4128865e9.25.1792794619650; Fri, 23 Oct 2026
 15:30:19 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261021060323.553433-1-nphamcs@gmail.com> <20261021060323.553433-5-nphamcs@gmail.com>
 <sashiko-outbox-181078@kernel.org>
In-Reply-To: <sashiko-outbox-181078@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 23 Oct 2026 15:30:07 -0700
X-Gm-Features: AclHuK9f3EoMXWJVPyND1AFMLPSEq7pySnN5Iv4BK8FN6E0iGCBP-yL0F6SS_5w
Message-ID: <CAKEwX=OBBfF5U+JHDfnugk5KGFEnOPQkkwZRfeii1iEQUNVG4Q@mail.gmail.com>
Subject: Re: [PATCH v6 04/12] mm, swap: support physical swap as a vswap backend
To: sashiko-reviews@lists.linux.dev
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, yosry@kernel.org, david@kernel.org, 
	muchun.song@linux.dev, shikemeng@huaweicloud.com, baoquan.he@linux.dev, 
	baohua@kernel.org, youngjun.park@lge.com, chengming.zhou@linux.dev, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, 
	baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, 
	skhan@linuxfoundation.org, rdunlap@infradead.org, kunwu.chan@linux.dev, 
	kernel-team@meta.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A3A90C0006
X-Stat-Signature: eh88b5yc9p8p67aerfnt1sfm1pih7ps7
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792794621-598086
X-HE-Meta: U2FsdGVkX197lQCwcZsVZehyunW6XjMa9fr0rXld52FQrxQXSQzYXglIICJbQ5kdSgYFS28nyd09qjIRS7HX6wuDw57VexCTTUXIAskD1RKr2+jyPN92DxUxmecRH3Qtbp52bXFWqDlP+Rd5SvF4veLcCUaejuEfFcyiOgLQANMCigTaUbulmMqb2k9Ks2Ayr9j8WiQm1m5ONthhvSzyWHA/M7ayb6vmDnKMY4otBD9vpqSR0DVhbfMKTtDUDOk+A4Awmb4YY2EnVOw7+Ofjp34YrqZy9F8wvouc7asf9WktQqRwVC/jWcUwsoVtPoWZOll6AJBYkQ13/Zoqdzc0eAxwXXTTF6CGG97Axj7/RdGgFIp895I1HCOEzg46OZkNXucOQfutmoRtEOZcMx+D4cRwJkrJMWtRwHsYNZ5NX/1ZGLaZRF+fSB+8wrHnVmRI4Y9dS6TpJAvugpO5UhrIJpB57S7qDdNWd70/9Grak3I4CzKsZqzPGInX1PriZqxdeQwkEWRMmEmtp3tHVQcudDRoXsWmXkhXOGB9vqHeh4Hpjyumv96au03CtidEfIg/De3/aXLnbtlg0s/sGQYTIhEz4ArzIrgi2JWJwuHviTLRs3+feN1fH/KpH/Ub7SV1PLhVrQeKDRbfEtcCZW9V8t5JZtgyDQ8BnQp6elVKOU1F7D6p5Uaoi0YYjYMaYOi4SZKimJpFv+o/AhXvjneaNEvRRh/jPZ465pcHDfgXK8Q3YI6EpLx9UOZYchIbm6gWCC8AsDdKH01TVYfRnT5xESFYIP5Wlbu0jXwqItKDDCvhEDOqWbxlhub0fHN/ERExOHNVxg1A4E6c5OPO8g0OoO1Y0jScxqJ/0EDCueDYtH3sNHD7XQqrOz224SFsuhZO9EoSnNe6nYI0Vut6Yeoh6LQcAV0s6BOSInWK5RkYUIayB87U8H8VNFzwEdneihiSkDUlWvJAhQK/4+OANvu
 IqXBWvWy
 Hg3fQk6LSMVhak13hOnJqqsC43g+mLXnZVZHJu0wCa0l0Hj5p8pJKkSwWzdVF1JVEZA4bYx618rbU083vI/I52SKDHy70CvfC7nXGOlRNDlJcXCh45pkzDG8JSklMLse8gvirugwOyXxaQzbXqVK1CA4N6h31i8ik0dkENgzVjW6ENxvztaCH9TxzpXtQi0y3+wFCmYwa3b7ULF8EbI+dc8z9kH5UlwWC80Qu4GbCcPLWAfKT5U6Gdauu5VRD7UEEzx7iBB5n0RORJgNlzI2O5+NPbkrhikPakKRDt8c1Hfm8KUY+EPyMMWpA4Wo6zRbezN9BybHl1531ibj8RtqkGJSNE6G/H6hIlpv4wNS16WiwCcxIU/Etfj+m3CusVAY2v64HXcsVR4oFIv1tOs6FTS3kmpx+CMLUNL4OjBU4bUMg0IAkFbsXtvUQbpUOsiVMfRGD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 11:19=E2=80=AFPM <sashiko-bot@kernel.org> wrote:

Working through Sashikos list now!

>
> Thank you for your contribution! Sashiko AI review found 3 potential issu=
e(s) to consider:
> - [High] mm: try_to_unuse() dirties unmapped vswap folios rejected by pag=
eout()
> - [High] mm: try_to_unuse() leaks vswap folios and slots when swap count =
is zero
> - [High] mm: large vswap folios declined by zswap fail swapout without sp=
litting

IMHO:

* First issue is a real scenario, but it's rare and the trade-off of
fixing it is nuanced.

* Second issue is real, but we're just adding (a rare) triggers to an
existing problem.

* Third issue is a problem because of the second issue. The fix is a
one-liner though, and is a smart thing to do either way, so I'll just
follow sashiko's recommendations here!

More details below:

> --
>
> commit f1735375be4432e3cb8facdcc6b588e080aeb34c
> Author: Nhat Pham <nphamcs@gmail.com>
>
> mm, swap: support physical swap as a vswap backend
>
> This commit adds physical swapfile support as a backend for virtual swap
> entries when zswap declines a folio during swap_writeout(), tracking the
> reverse mapping via vswap-tagged swap_table entries on the physical clust=
er.
> During swapoff, try_to_unuse() reads vswap-backed physical slots into the
> swap cache and releases their physical backing slots before walking proce=
ss
> and shmem mappings.
>
> > diff --git a/mm/page_io.c b/mm/page_io.c
> > index 61bb5c6e97595..ed8c037e4aa08 100644
> > --- a/mm/page_io.c
> > +++ b/mm/page_io.c
> > @@ -209,6 +209,7 @@ static void swap_zeromap_folio_clear(struct folio *=
folio)
> >   */
> >  int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
> >  {
> > +     swp_entry_t phys =3D folio->swap;
> >       int ret =3D 0;
> >
> >       if (folio_free_swap(folio))
>
> [ ... ]
>
> > @@ -257,13 +264,21 @@ int swap_writeout(struct swap_io_ctx *ctx, struct=
 folio *folio)
> >       }
> >       rcu_read_unlock();
> >
> > -     /* A vswap folio has no physical slot to write to. */
> >       if (is_vswap_entry(folio->swap)) {
> > +             phys =3D folio_realloc_swap(folio);
> > +             if (!phys.val) {
> > +                     folio_mark_dirty(folio);
> > +                     return AOP_WRITEPAGE_ACTIVATE;
> > +             }
> > +     }
>
> [Severity: High]
> What happens here when a large folio (order > 0) with a virtual swap entr=
y
> is declined by zswap_store() and the underlying physical swap cannot sati=
sfy
> a high-order allocation?
>
> During reclaim in shrink_folio_list() or shmem_writeout(), folio_alloc_sw=
ap()
> allocates from vswap_si via vswap_alloc() -> cluster_alloc_swap_entry():
>
> mm/swapfile.c:cluster_alloc_swap_entry() {
>         if (order && !(si->flags & SWP_BLKDEV) && !swap_is_vswap(si))
>                 return 0;
> }
>
> Because swap_is_vswap(vswap_si) is true, vswap_alloc() succeeds for order=
 > 0
> folios even when the physical swap devices are regular swapfiles without
> SWP_BLKDEV or have fragmented high-order clusters. As a result,
> folio_alloc_swap() returns 0 instead of -E2BIG, bypassing the
> split_folio_to_list() fallback in both shrink_folio_list() and
> shmem_writeout().
>
> Later in swap_writeout(), if zswap_store() declines the large folio,
> folio_realloc_swap() -> folio_alloc_phys_swap() attempts to allocate a
> contiguous physical swap range of folio_order(folio), which always fails =
on
> non-SWP_BLKDEV swapfiles and fails when high-order physical clusters are
> unavailable. swap_writeout() then marks the folio dirty and returns
> AOP_WRITEPAGE_ACTIVATE without splitting it.
>
> On subsequent reclaim passes, an anonymous large folio is already in the =
swap
> cache with PTEs referencing its vswap slots, so shrink_folio_list() skips=
 the
> !folio_test_swapcache(folio) block where split_folio_to_list() is called:
>
> mm/vmscan.c:shrink_folio_list() {
>         if (folio_test_anon(folio) && folio_test_swapbacked(folio) &&
>                         !folio_test_swapcache(folio)) {
>                 ...
>                 ret =3D folio_alloc_swap(folio);
>                 if (ret) {
>                         ...
>                         if (split_folio_to_list(folio, folio_list))
>                                 goto activate_locked;
> }
>
> For a large shmem folio, shmem_writeout() removes the unsplit folio from =
the
> swap cache on AOP_WRITEPAGE_ACTIVATE without reaching its -E2BIG split pa=
th,
> repeating the same vswap_alloc() success and folio_realloc_swap() failure=
 on
> every pass.
>
> Can this cause large vswap folios declined by zswap to never split or swa=
p
> out?

This is quite nuanced. I spent way too much time trying to reason
about this, but seems like my documentation is lacking, so sashiko
can't reason about it. I'll put down my reasoning here first, then
update the documentation later.

Zswap store can "fail" for a couple of reasons:

1. Incompressibility: we'd actually still try to store the folio's
subpages as-is in the zswap pool if zswap writeback is enabled. If
zswap writeback is disabled, then we cycle the page through the LRU.
But note that there is no difference, with or without zswap in the
picture here. We'd just be splitting prematurely, but the
incompressible pages would still remain in memory regardless.

2. Zswap rejects the page due to limits being hit - this one is
trickier. For the cgroup case, I already checked at vswap_alloc()
time. If the cgroup disables zswap, then we go for physical swap
allocation, where we avoid the physical swap backends that do not
support high-order allocation, or split if no such backends are
around.

For the global zswap limit, I thought about also checking it and
bypass vswap based on that limt at vswap_alloc() time, but decided
against it, because I wanted to trigger the global zswap shrinker in
zswap_store() path, and giving zswap opportunity to try again.

(I'm also against capping zswap size as well, but that's another story).


>
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 69fac2d905a4f..be66ac79313ce 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
>
> [ ... ]
>
> > @@ -3087,19 +3287,95 @@ static unsigned int find_next_to_unuse(struct s=
wap_info_struct *si,
> >
> >  static int try_to_unuse(unsigned int type)
> >  {
> > +     struct mempolicy *mpol =3D get_task_policy(current);
> >       struct mm_struct *prev_mm;
> >       struct mm_struct *mm;
> >       struct list_head *p;
> >       int retval =3D 0;
> >       struct swap_info_struct *si =3D swap_info[type];
> >       struct folio *folio;
> > -     swp_entry_t entry;
> > -     unsigned int i;
> > +     struct swap_io_ctx ctx;
> > +     swp_entry_t entry, vswap_entry, phys;
> > +     unsigned long swp_tb;
> > +     unsigned int i, j;
> >
> >       if (!swap_usage_in_pages(si))
> >               goto success;
> >
> >  retry:
> > +     /*
> > +      * Free vswap-backing slots (Vswap-tagged) first. Walk physical
> > +      * clusters, read the vswap entry from the rmap, ensure the data
> > +      * is in the swap cache, and transition PHYS to FOLIO. Freeing th=
e
> > +      * physical backing is enough, so no page table walk is needed.
> > +      */
> > +     i =3D 0;
> > +     while (vswap_is_enabled() &&
> > +            swap_usage_in_pages(si) &&
> > +            !signal_pending(current) &&
> > +            (i =3D find_next_to_unuse(si, i)) !=3D 0) {
> > +             swp_tb =3D swap_table_lookup(swp_entry(si->type, i));
> > +             if (!swp_tb_is_vswap(swp_tb))
> > +                     continue;
> > +
> > +             vswap_entry =3D swp_tb_vswap_to_swp_entry(swp_tb);
> > +
> > +             folio =3D swap_cache_get_folio(vswap_entry);
> > +             if (!folio) {
> > +                     folio =3D __swap_cache_alloc_folio(vswap_entry,
> > +                                                      GFP_HIGHUSER_MOV=
ABLE,
> > +                                                      BIT(0), NULL, mp=
ol,
> > +                                                      NO_INTERLEAVE_IN=
DEX);
> > +                     if (IS_ERR(folio)) {
> > +                             if (PTR_ERR(folio) =3D=3D -ENOMEM)
> > +                                     return -ENOMEM;
> > +                             continue;
> > +                     }
> > +                     folio_add_lru(folio);
> > +                     ctx =3D (struct swap_io_ctx){};
> > +                     swap_read_folio(&ctx, folio);
> > +                     swap_read_submit(&ctx);
> > +             }
> > +             folio_lock(folio);
> > +
> > +             if (!folio_matches_swap_entry(folio, vswap_entry)) {
> > +                     folio_unlock(folio);
> > +                     folio_put(folio);
> > +                     continue;
> > +             }
> > +
> > +             /*
> > +              * Re-validate under folio lock: rmap holds folio->swap +=
 j
> > +              * for some j in [0, nr_pages). Check folio->swap still m=
aps
> > +              * to the contiguous physical run that includes our slot =
i.
> > +              */
> > +             j =3D vswap_entry.val - folio->swap.val;
> > +             phys =3D vswap_to_phys(folio->swap);
> > +             if (!phys.val || swp_type(phys) !=3D type ||
> > +                 swp_offset(phys) + j !=3D i) {
> > +                     folio_unlock(folio);
> > +                     folio_put(folio);
> > +                     continue;
> > +             }
> > +
> > +             folio_wait_writeback(folio);
> > +             folio_release_vswap_backing(folio);
> > +             /*
> > +              * Drop a folio whose read failed rather than dirtying
> > +              * uninitialised memory; the next fault finds no backing =
and
> > +              * gets SIGBUS.
> > +              */
> > +             if (unlikely(!folio_test_uptodate(folio)))
> > +                     swap_cache_del_folio(folio);
> > +             else
> > +                     folio_mark_dirty(folio);
>
> [Severity: High]
> Can pageout() ever write out the unmapped swap-cache folios allocated and
> dirtied by this pre-pass?
>
> When __swap_cache_alloc_folio() -> __swap_cache_alloc() allocates a fresh
> swap-cache folio here, it sets PG_swapbacked and PG_swapcache, but leaves
> folio->mapping as NULL because try_to_unuse() does not map the folio into=
 a
> VMA via folio_add_new_anon_rmap(). Shmem folios in the swap cache also ha=
ve
> folio->mapping set to NULL. As a result, folio_test_anon(folio) is false.
>
> When shrink_folio_list() later scans one of these dirty swap-cache folios=
 on
>  the LRU, folio_mapping(folio) returns &swap_space and shrink_folio_list(=
)
> calls pageout():
>
> mm/vmscan.c:pageout() {
>         if (folio_ref_count(folio) !=3D 1 + folio_nr_pages(folio) || !map=
ping)
>                 return PAGE_KEEP;
>         if (!shmem_mapping(mapping) && !folio_test_anon(folio))
>                 return PAGE_ACTIVATE;
>         if (!folio_clear_dirty_for_io(folio))
>                 return PAGE_CLEAN;
> }
>
> Because mapping is &swap_space (!shmem_mapping(mapping)) and
> folio_test_anon(folio) is false, pageout() unconditionally returns
> PAGE_ACTIVATE before reaching swap_writeout(). Wouldn't this prevent recl=
aim
> from ever writing these dirtied vswap folios out to zswap or another swap
> device until they are faulted in?

I think this a pre-existing issue (which vswap adds a new, rarer
trigger). Readahead of zswap entries gets us into this exact spot...

I think what we need is fixing the check above:

        if (!shmem_mapping(mapping) && !folio_test_anon(folio) &&
            !folio_test_swapcache(folio))
                 return PAGE_ACTIVATE;

So if the page is in swapcache, we still proceed with the pageout...

That will take care of both triggers. But this sounds like a separate
fix from this patch series. I can send an RFC later, but let me double
check first!

> [Severity: High]
> Does this pre-pass leak the folio, its vswap slot, and its memcg swap cha=
rge
> if the vswap entry's swap count is 0 (or drops to 0 concurrently)?
>
> There are two ways the vswap entry can have swap_count =3D=3D 0 when reac=
hing
> folio_release_vswap_backing(folio):
>
> 1. While try_to_unuse() holds the folio lock (during swap_read_folio() IO=
 or
>    before folio_unlock()), the owning process exits or zaps the swap PTE =
via
>    zap_nonpresent_ptes() -> free_swap_and_cache_nr() ->
>    swap_put_entries_cluster(). That path decrements the vswap slot's swap
>    count to 0 and calls __try_to_reclaim_swap(), which fails folio_tryloc=
k()
>    and bails out expecting the folio lock holder to clean up.
>
> 2. A prior read fault in do_swap_page() mapped the folio, decremented the
>    vswap entry's swap count to 0 via folio_put_swap(), and left the folio=
 in
>    the swap cache because should_try_to_free_swap() saw
>    folio_phys_swap_backed(folio) =3D=3D true.
>
> After folio_release_vswap_backing(folio) frees the physical slot,
> folio_phys_swap_backed(folio) becomes false, and try_to_unuse() marks the
> folio dirty without calling folio_free_swap(folio) (unlike the post-pass =
at
> the end of try_to_unuse()).
>
> In the first case, the unlocked folio is unmapped, has folio->mapping =3D=
=3D NULL
> (!folio_test_anon(folio)), has swap_count =3D=3D 0, and is no longer phys=
ically
> backed. pageout() rejects it with PAGE_ACTIVATE before reaching
> swap_writeout() -> folio_free_swap(), and the activate_locked path in
> shrink_folio_list() also skips folio_free_swap() because
> folio_phys_swap_backed(folio) is now false:
>
> mm/vmscan.c:shrink_folio_list() {
> activate_locked:
>         /* Not a candidate for swapping, so reclaim swap space. */
>         if (folio_test_swapcache(folio) &&
>             ((mem_cgroup_swap_full(folio) && folio_phys_swap_backed(folio=
)) ||
>              folio_test_mlocked(folio)))
>                 folio_free_swap(folio);
> }
>
> Should try_to_unuse() check or call folio_free_swap(folio) when releasing=
 the
> vswap backing here?

Ah sure, this is related to the problem above somewhat, but
irregardless of it, it's not a bad idea to eagerly free the swapcached
page when we know swap_count =3D=3D 0 and we have the folio's lock at
hand. I think I actually did it manually in the pre-swap-table version
of vswap!

Will include this eager folio_free_swap() in the next version/as a follow-u=
p!

>
> [ ... ]
>
> =E5=AE=8C=E7=BE=8E (Wait: oops, don't write any extra text after the repo=
rt! Let's make sure the final output has only the report and ends with a bl=
ank line.)
> Let's review the whole text and output it cleanly.commit f1735375be4432e3=
cb8facdcc6b588e080aeb34c

I think the rest is duplicated! Hallucination in the wild :)

