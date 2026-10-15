Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6811CCCA462
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 21:40:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EDCA6B0098; Thu, 15 Oct 2026 17:39:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49FFE6B0099; Thu, 15 Oct 2026 17:39:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38CF86B009B; Thu, 15 Oct 2026 17:39:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 141BC6B0098
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 17:39:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 944861201B5
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:39:58 +0000 (UTC)
X-FDA: 85326178476.30.EA00D6F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id BDB2C180002
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:39:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LRPVxAtK;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792100396;
	b=axaK164WXP2F65oHAZ/gjL4wouyv6QNnC97F4rVD+uPiLUTXNAlqNWDFCYRbQNKRPybTxm
	DKEObPTFW8LyOEQOkN/83GSdvb3bE0e8jeVKuE8es3OerdiBwCIpYuDThwO6fKciqpzf6s
	XC2F90twdsR3TM0n2KUrXZ8eUhAhtFE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LRPVxAtK;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792100396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gJ+0YN8j089fj2ZV/djvu5s7T0hJNC6kJYYYjsa++Vw=;
	b=5b5/hOwzvqy2mRfrRuiJMiLIktgR57JlfVpLMDl22oXa/oWB+dKNdDVYlqJmq1goWVmOFe
	eC5kyAk8GFPgHLHjrnuNO08pxZWHh3x4gZBvizUzHDbZbUuEZLiMEsj9xFAIksZGmaHXdC
	vQ2OJ0uYSwGWwLQh1hc11qLNOc6nlig=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 603F160A57
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:39:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A33D1F000C5
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792100395;
	bh=gJ+0YN8j089fj2ZV/djvu5s7T0hJNC6kJYYYjsa++Vw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=LRPVxAtKyePwlj7nRCOHozmKtpL5xH7vvA+BiKRv7PZEAPatwvbFpQeosgeOwR2us
	 o9Q/DRB1MWTTAPaNelD42Gmm9i9RAn6GqfrvZgUlPY5gsN7ukVqZyu9NTyPuGI19RI
	 9FBTgEfMeyiF1iIksvC5BcSQYqnsmS4PaAi7pVjuJ7HWzqQjXA5k9RvLoK0sqNGVyL
	 +f6wc01mrWwlfFJfTpkXpbcr1r+hdQoVoFFn+9feJ5ZX85Wn0JZW3r5hudck9E6nXa
	 IrWvri+NKaqq3mA+4Fb1nHUN3MHKdkrgsHXIJyW4VvXE5J/nr4d+NQRqQtEVQ7UuqG
	 gLqesWkMwcD/w==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c4086e892a4so11464166b.2
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:39:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBybRze6nHc2VQ5wAGyoUkjciGOb8tuGB7KuKMZJj+rw7jUuLt/py/KTPuugwOqNOScAHABNgXr6xg==@kvack.org
X-Gm-Message-State: AFq9FYJsnG9TCEn3S734hfBU3Ipnm4slqvKdh99BWcmWrlTzOZnzFnMi
	5O+OQMogDkVCp82COkvBvJkDRNKYLF6W3EvWU7BnObLW4OtTGskhMibKiyXf0ofH++Y25a+Z6XA
	XVNCWQJ/TXLZtL/1sxzJ6pUSzrxwR1T4=
X-Received: by 2002:a17:907:3f12:b0:c21:450d:cd7e with SMTP id
 a640c23a62f3a-c31a9af76e8mr2002892866b.9.1792100393987; Thu, 15 Oct 2026
 14:39:53 -0700 (PDT)
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <20261008182814.27450-6-kanchanapsridhar2026@gmail.com> <as7JC8o2kggiq_ss@google.com>
 <CACpmpofXMGBP70Rn7jHLwOF38GRKMUGoW3rb1Jp2SPH7ygKcfw@mail.gmail.com>
 <CAO9r8zOEcGmg8eVttu41htugnng0ahnVQbubiJfxVH+GfDe47Q@mail.gmail.com> <CACpmpodDA=oqnVa_hsJpyhGt=4zxknYF=QX9L6-sJbxsRxtM2w@mail.gmail.com>
In-Reply-To: <CACpmpodDA=oqnVa_hsJpyhGt=4zxknYF=QX9L6-sJbxsRxtM2w@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 15 Oct 2026 14:39:42 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNN6F01icKUFr8q_AgJvhxGw0MkGezKbBuKzFQV0NaAdg@mail.gmail.com>
X-Gm-Features: AclHuK9_U4t1aJcro9clqrnxlUhMU2VGLAoMd7xVc_4UgYJfOHupT3dXjx731Xo
Message-ID: <CAO9r8zNN6F01icKUFr8q_AgJvhxGw0MkGezKbBuKzFQV0NaAdg@mail.gmail.com>
Subject: Re: [PATCH v1 5/8] mm: zswap: Store the folio's node id in the zswap_entry.
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BDB2C180002
X-Rspam-User: 
X-Stat-Signature: 9je4343gk9j7w956h6wupd8wxk1y8pj6
X-HE-Tag: 1792100396-810446
X-HE-Meta: U2FsdGVkX1/mux9mqrH0qvP0Jz6yKOuwkFvNUApiQ+b+emK1ADER3wnNI+1+DjY1ygqNsxDLqFmPfu5o3EiP4Tom50sQfK6JeLSSSgmlNxw8DZakYeDtoIY304c+sQxLGkcbaxFSTbtGI8wfdNzg30x34Z34tqmJww02fJGFnHugb71qGhFdgsV/tn1L0DwKOZXA8Hav0LcnkjLAFgjcE1r66HKfIQBUSpZfbh34F8ISLX93W79n0Ol5fAHGu2VBHTT9I1NjU004xkFUPE3aIu1zNDt//2oflOLGR1wUGcZS3UfQBxahLmPHTGwwKNV19aZde3QQlU9xf0uqbEF5tDs0IipjHLHyGIcdaz1ibHvK/7jP0aaimQ0FAbiaMDySsnFYLm8SDk5NKo7QJy2BG7cNhmrkidbgcfnJVaU6nOY2YUvmKwI4VWW8hCT9AVY+yJ/kTdQV3gZvP80Ts881yuPHOQEIJncDyXE2VzUkdpjpWzVo5WemSFmrP3Qxp5W8+XBCYdZI0+wY6cf8ES8fCn+zSV9LNJKUNiWIEVGHt69+vEn42GqytRr5WAkL7k9nzE98yXqryMspP2ONLQ6V1xc54BdZR3blHCkgAfC2ZTdd/kScdSU4IgbVpxHgoxtfIjHmtOLrFDcsJODoljZipj1bGvCjJEzx/9rt69Da8Oo8TF4nK32CkjS+ueZ9d3pzAtsc54jEMRGIuvqIeJqew3M/L/du/V5/Fg6R+Vbg3E6FCSsDxJL/OFe62pUzs4BylIMPS4q1TWxDjtuvcqgGlAgmarpNS164Twmc+l3DtQ+qPT4XmV1UzdG8PxpRX7+QzUw4xAIcAug7e2BLL8X4ekmnyolqBWdaP9LUIwEyVEH8eLyIjIqAyyOVn/YwS7srZrXdHxK+X//iW0DoueusF6OuzA+cRepfqfokkgjGlSPdXPek3g1Tx3N0EM7GlJ44/T9g6ZnF7vOQiXiXhNQ
 IkUIwLFJ
 t5DIJqcfAUk2tErl2UycKxgb+QjcJ75+GBGAamTBqWOVZxPDjP/k4/QnNyGQL3+ke51SqSC45K6svXx6rmSK5YJg1CUdJNu5c7hAZOfbPgZ7/Xjti+/Yz3Z3YRrH7Pyp6wKtCh+SaXBXjttmOG1sqi+SuYXfKKIcxTeW5gs+JIbnf3ZCgLOKAcjZr3s9C4IKn1pw0UtsNMW/QFRbpoUALlusT5ijatatnu25n7MlLgtH+Txs3QgJ68pfNnT06kQpdoQNtM1hQGRIVj44MafsI6tFdQscG3yoO5cIsF8lEtJakpFgNbOdZkM2tCdTnuzROUTfEym5u3umopNQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > > > @@ -1449,9 +1446,10 @@ static bool zswap_store_page(struct folio *folio, long index,
> > > > >  {
> > > > >       swp_entry_t page_swpentry = folio_swap_entry(folio, index);
> > > > >       struct zswap_entry *entry, *old;
> > > > > +     int nid = folio_nid(folio);
> > > > >
> > > > >       /* allocate entry */
> > > > > -     entry = zswap_entry_cache_alloc(GFP_KERNEL, folio_nid(folio));
> > > > > +     entry = zswap_entry_cache_alloc(GFP_KERNEL, nid);
> > > >
> > > > We don't need to allocate the entry on the same node anymore, should we
> > > > drop this and let the slab allocator handle it as it sees fit?
> > >
> > > Was this a recent change? I see the folio_nid(folio) on my version of
> > > mm-unstable as of 10-3-2026. Let me check, and yes, allowing the slab
> > > allocated handle this is probably a good idea.
> >
> > We allocate the entry on the same node to avoid having to store nid in
> > the zswap entry (see entry_to_nid()). If we store it, then there's no
> > need to allocate on the node.
>
> With patch 0006, we try to bulk allocate all entries for the batch.
> Only if this fails, we call zswap_entry_cache_alloc(gfp, nid). So
> patch 0006 addresses this already, and the nid is used on in the
> fallback case.

If we are storing the nid in the zswap entry, there is no need for
zswap_entry_cache_alloc() to use the nid anymore.

>
> >
> > >
> > > Along the same lines, I have been working on replacing zsmalloc with
> > > direct SLAB allocations for the zswap compressed data storage and see
> > > very promising results: memory savings and latency improvements. I
> > > will submit an RFC shortly.
> >
> > Keep in mind that zsmalloc is movable memory, while slab memory isn't.
> > Zsmalloc may also be less likely to make a new allocation in the store
> > path. There are other considerations beyond memory overhead and
> > latency here.
>
> I realize this means we trade off page migration for writeback for the
> pages representing zswap compressed data. This might not necessarily
> be a bad thing for 2 main reasons, the way I see it in this specific
> context:
>
> 1) Page migration would only be transferring a memory pressure problem
> elsewhere. Not sure how well this would work with memcgs or
> containers. At some point someone would need to do writeback.
> 2) I don't believe there is a zswap specific page migration flow in
> the kernel other than zsmalloc compaction. IOW, memory tiering
> components like CXL are handled directly in the reclaim path. From
> what I understand, things wouldn't break with slab memory for zswap
> compressed storage, but I could be wrong. I hope to include the
> architecture level considerations/trade-offs in the RFC.

Zsmalloc memory is currently movable, so compaction can move it around
to free contiguous blocks (e.g. for THP allocations). Slab memory is
not movable. It can be reclaimable, but writing back memory from zswap
when we are not under memory pressure is also bad.

Note that compressed memory can be very large compared to slab
allocations (or kernel allocations in general), so it can increase
unmovable (or reclaimable but not movable) memory significantly,
causing fragmentation.

