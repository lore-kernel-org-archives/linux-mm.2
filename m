Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB347606A337
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 14:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NA1m8gVY
Received: by kanga.kvack.org (Postfix)
	id D28A46B05B2; Fri, 30 Oct 2026 10:49:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD98C6B05CB; Fri, 30 Oct 2026 10:49:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC7F16B05CC; Fri, 30 Oct 2026 10:49:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9268F6B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:49:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8BB05160677
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:49:27 +0000 (UTC)
X-FDA: 85379575974.29.8919040
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id A059212000E
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:49:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NA1m8gVY;
	spf=pass (imf29.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793371765;
	b=ykYJzZdnt0CdTLrYcVJZBfdfCXgk0IjuSuXaFTS5/o0TKdr0frv1YxCvrr7rQrsnLime+8
	V709o0WGW5Man2Wti2pfkjUH0wvd+gmNhJ3McsZ/QsrXVEbkUbuJpY5Qz6eMHp8EOVEMso
	Ia7QmAdNWJEMxDcepvfV5/twt2zugUc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NA1m8gVY;
	spf=pass (imf29.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793371765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0TQjte6CqBgM+wFSxhT/bgRaDtwXwwSO4uSgCgPB3OY=;
	b=FMBLKWLP+WaCJb2TgxIWe+MKrN/rwW6gBtiMdLTDNBvEPQNxTnbjmL60MezXxJlYEAPlYM
	X+M3oOu0lRXUJ5FTMycVuY3r47F2/2f1i/XcsMmLb88KxoPfKmBEcnl7aBVnfmInhjGxiT
	IUBPf9r+iVv8IPmr0y2rBGmv6+Kxm4E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D339943E20
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4E61F00A02
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793371764;
	bh=0TQjte6CqBgM+wFSxhT/bgRaDtwXwwSO4uSgCgPB3OY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=NA1m8gVYHOCdqHGrZ4A/CsTsWNYOnrQL/kvNqYRh855w0eE48qkiEbOD/mUSAQJs8
	 THi9A92uzFqXpL7REevNWMot+i0pxkE0Xz+q3vi9EvINUn3EcRXGZ67OxqbH52OCGj
	 YEqxEc1/aQg9ETlfCD/kkezGO4FD1hN3Al4UcskSYIHPj9LFrLy7b99XqYU4NRSEHD
	 lFunqd0Ki4rXYamLX95N8zKRGOHlg365oDaDLMoe35BHu3j9X+tvaNmY3o6zBj5ImX
	 hTN8QnEdpiUj9nDiIhkAMojiIysBntHAy98ofps5LHCuIWmkrsK3dZP/jqUhOWqi32
	 ofF2caZU1LBfg==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c3f04e0e65fso120670866b.2
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:49:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBypZKxqrECJd6e2VXxeF+4ef0AVJxV+lLvMf4CIwPRSr6RD2hUuzRzM86m1PRV7n94PUKv+7MlERw==@kvack.org
X-Gm-Message-State: AFq9FYJVHpODIRfgqcnx5Y5MB35lya+WgI7w1YqsuVvmSgV+tvTimCJ7
	3mYKf/ND9lEbAhPef+Neq6BNs+bxP3uCTgZAxeJTbG3CRLz0DmIdUX0w8DRLGn/4Qzee0gmSwJH
	puJBXKhejJinbJtE6AAcm8HTPZs48Eq4=
X-Received: by 2002:a17:906:9f92:b0:c29:4915:83cb with SMTP id
 a640c23a62f3a-c4ca7ab09dbmr235759666b.39.1793371763605; Fri, 30 Oct 2026
 07:49:23 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-7-kanchanapsridhar2026@gmail.com> <sashiko-outbox-188658@kernel.org>
 <auQhULh1VTh6lWoe@gondor.apana.org.au> <CACpmpodWMtmE0yNVN656K-8fPZgTj_DSZ0J7qxou+5Asoht+4A@mail.gmail.com>
 <auQwWgMbBuo0YEBI@gondor.apana.org.au> <CACpmpodxvQCkQgXUU6pF8d7onxHvHF7sEYCbTkv81WXyyrFiEg@mail.gmail.com>
In-Reply-To: <CACpmpodxvQCkQgXUU6pF8d7onxHvHF7sEYCbTkv81WXyyrFiEg@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 30 Oct 2026 07:49:11 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNvy7ftXsmLnj4qbQYJ5nyQo=hrio4UQvNrpMbwj9YbMg@mail.gmail.com>
X-Gm-Features: AclHuK_VMB6EZ1UVhDMh9oCJ1ZyT4EAf7VOhmffq_u4OhZNJTl7iN40sgLIywfU
Message-ID: <CAO9r8zNvy7ftXsmLnj4qbQYJ5nyQo=hrio4UQvNrpMbwj9YbMg@mail.gmail.com>
Subject: Re: [PATCH v2 6/8] mm: zswap: Store large folios in batches.
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, sashiko-reviews@lists.linux.dev, 
	hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6ycbysg68qg6r6ywnwunutpqmoeyz4i3
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A059212000E
X-Rspam-User: 
X-HE-Tag: 1793371765-702304
X-HE-Meta: U2FsdGVkX18oNlOxQs7NZCHxkGWUeb3Es8LNg6iWssdhifvdBf+SGBCeB5Vhw0cvUnbVr6wjbbc84PkXjN5J4Z1+3S+26fmadk7yqzuXD8RzdraCC1Yl8WWF4gBZ55WLXHKihpNXk6cB0Fsh6M97B0sU9gRzirAkwSiFN88fkp0hJRBpu3xs+tHvmHXW1S4OKdX3aJCfTL6JUxsihKUSaVSga6duc/ar1r1wV24T2BxBy1u3ogrYGHYJjOeRaeO4smvZyyvi/goYpuD7dLJGEBJfagz89F+Q8UvG6mFiQJ2OhHD1Z0htC+QbkI+BJpxb+gso+aIdaqUCY1AH6R7MWWf9R6vHcEgrJvkNgQOv0BOVxbAFOMbEtvaVGZcgBQpOj8LBxzMteKcDWd0ZmxerTE2GFLk+F8WxtkmO749DjiMag/zk2DPJ48GAZwlAq4kogz3it8vvCzW/HWGNIf3bVmwHBtSli+VspVitlSRjAD/u6pEeeIcs+dhcWGS2skB6D64RchT37th4i75VLbh59VsVu5VdwpBEqDt8Z/qfsBHB3MEltvS4L8GSQQI9a5UqNCCqyUNNLoKGl8rwjFEI0Fl89aLsJWdiiTFUnVh00wJu1Chzl+7wIrUFpsPPf9sMGAY3P6DBidgJVuiJl+7sdA6XQw4XiA9DVs8v/mFCTwrnrdMRaXBa6hpfKyCvC//2aW/pwZmdyZzpnaoPIRSFNCKA1SFFqoFbyAIonf5GMWT92x9jfiflNbWudrJMNfY97RD/xBLNlfunNFyN5i8SCtXYpESyiIEdgpoioCcJZ2VF32nkn0KWYXSlAqJPcLZozrK71RB4i+Gj/f171bz9dhFg9ICXknOA2VAhZeR/3dd0HlVd8hIEJwv3uiLKf38vwxm/cYYKMbsNxDeFE9f08DE8S6LNnDfaxPvEKXa8y/uixsb8+OguMTcVojKxK3rEYRSqV8GvU3i45KosZKE
 73qIhhx0
 DGoeZsewkpOia6iVc7gqqmB2/N95HlJzVDhJYscpInAKMnBp/FO/FgI5sOzkVXfFSAj2zgu1ird/0ur5GwP4oWL8jqOswsOGdJ40rn5f4KvsMzvBQzMWNSP/mm5SH9Mb9p10ybHZVvQA3ce9Jozn6jRHkGFU+hXjEuX++j6gQRi2QuMpAIwj1sIhsYdWwvuAK5EWYGGQPHAtEZhsFTUzqNJZcMauD37XEc+6U646dyIWsdUr/GxeelNqrknt5sNeQVEDIcyBaxOEEXIU+07ldZXzepOWsSVc6vosu6BOybRW/OEpQ/GYNr3x8p2XzfThixblUHAbn2crkD9ggYAE4UMVO146jFocZvX13aLFsXVf+yd58buNR+9G5DQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 11:19=E2=80=AFPM Kanchana P. Sridhar
<kanchanapsridhar2026@gmail.com> wrote:
>
> On Thu, Oct 29, 2026 at 10:51=E2=80=AFPM Herbert Xu <herbert@gondor.apana=
.org.au> wrote:
> >
> > On Thu, Oct 29, 2026 at 10:15:15PM -0700, Kanchana P. Sridhar wrote:
> > >
> > > This is how it is in the current mainline, and has been for as long a=
s
> > > I can remember.. I assumed it was because we need a per-CPU acomp_req
> > > to be allocated for the tfm. Can this be done with a single
> > > crypto_acomp for a given algorithm?
> >
> > The request needs to be per-cpu, but the tfm does not.
>
> Great.. we can save a lot of memory this way.
>
> Yosry, should I go ahead and include this fix in this patch series? I
> am Ok if you want to take this up.

Feel free to send a patch, but I think it doesn't have to be part of the se=
ries.

