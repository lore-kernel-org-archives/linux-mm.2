Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C76DC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 15:52:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2EA16B009B; Tue, 28 Jul 2026 11:52:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F06776B009D; Tue, 28 Jul 2026 11:52:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E43666B00A0; Tue, 28 Jul 2026 11:52:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B83DE6B009B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:52:34 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4297A403FF
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:52:34 +0000 (UTC)
X-FDA: 85038627828.16.39A9A6E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4BC4620006
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:52:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KwQrC4Hx;
	spf=pass (imf03.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785253952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bMOl0LoZ9OG3r13De5qvfam6hhvkOi91d3jCbtx/GCE=;
	b=Wrsvx6Gpk+G7OAsRcZG2G7WF9Ptjw3hZPLv+nBVZIOho6NUoCDcuWZWTipIlSyHQCU2l/W
	SeunhXBXsQhGukC9PpsSHl7T1GNDQTY0FPjZ6Rzc9J1xneLQ/CIoVHCwvFzBGHRdtJ+Cyc
	YKW4ZGuJXH6HyjSx31MfFRWl3hX1Xi0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KwQrC4Hx;
	spf=pass (imf03.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785253952;
	b=ZTqCZfGyGffaVgPUXTJzVf9FzCh6Lyi8+VdBV9y0LTm7M0m8PnLdDNm/SWP0gj0SpVtlRI
	PeebJIYhqzlU+0xb44naiM2ba2Shfq4icNxrY8gMnIi1d1IDUephFno24OLIZ4/0sSbXDc
	zD1q5uV1MohPOf4o3Kh7UxKMS7LXNwM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C94F43D13
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6476D1F00A3F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785253951;
	bh=bMOl0LoZ9OG3r13De5qvfam6hhvkOi91d3jCbtx/GCE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=KwQrC4HxpZh8eu98lPCEWvADjY35rrDNQdlSq4/4cv+GUa/6oFVY/+nV7CaInlAMm
	 DXxdtQri5w3Z39H9enq5RS8eJyLdgWRRbnJzIgEbZ7uqR9xQ82VNezv7zbqCZflTiZ
	 av2L8MB5oj4OS7nZrlwUdAh2pnMNwSKAqFqB0vWkm+UIkMVIxdSR+pEm3liKMQXdb6
	 NarPWuCCD18M0Vkec+sxLEpTP25v7QNxz10ehYPBKHa8OJ3vPK4tGgCVYyhmqlNRAE
	 /k2nf4liDNWdfVS1E6yu8pWjYf5ZdnnXhdbHNHXemGa2Hbodp19vUsGe18RyKL8vVt
	 fxnhlstLfgVbg==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c1740c36c5cso570221266b.2
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:52:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoFX2eUXxLL8rlDH0cxLKQ8fkGYq6u6zMoxAjDFhZ/6ry5b+i3HdJSQAjukljwX/iz+oR0hwcVR2w==@kvack.org
X-Gm-Message-State: AOJu0YxONleK/NkSmSxR6mu3QfQk97usTRJZobB1g2OQuwPKTGBgeAVB
	rSTRFQxFgovmd+DW4Y9WNktiOeXD/2DujSfih02A2z78vNPUuVsGXz+GU9zMHMOgp62CXb9O6rG
	xvnZyTnZWb2TdLHgciT60GTWMAjgFws8=
X-Received: by 2002:a17:907:1b22:b0:c15:cc30:6c70 with SMTP id
 a640c23a62f3a-c1f7222aad1mr157579366b.42.1785253950068; Tue, 28 Jul 2026
 08:52:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260727143618.1582318-1-alex@ghiti.fr> <20260727143618.1582318-4-alex@ghiti.fr>
 <CAO9r8zNJ1cfCVgxtpqx4Db380bjZ+Z0P842eAxPXw6Mh4XBrww@mail.gmail.com>
 <CAEmasaXR5EmGCv3T5AzM_2908R-VjfMcObrACyVGokY2U=+i+Q@mail.gmail.com> <CAKEwX=P5G=Ckafy6fm9ws3njWP_Zm_AHRKOFERScB9Pkd_KvGw@mail.gmail.com>
In-Reply-To: <CAKEwX=P5G=Ckafy6fm9ws3njWP_Zm_AHRKOFERScB9Pkd_KvGw@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 28 Jul 2026 08:52:18 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNsZUvMknjmH7MvkQ=09DnB9YvtYoA0ei5Hj_cESQAVPg@mail.gmail.com>
X-Gm-Features: AUfX_mw17xHEr87Xj-0eNal-34Y7WD8xyS6pNm9H3A2zMrpBFz_XUx8rLZL9Rcg
Message-ID: <CAO9r8zNsZUvMknjmH7MvkQ=09DnB9YvtYoA0ei5Hj_cESQAVPg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] mm: zswap: drop cold writeback folios via swap dropbehind
To: Nhat Pham <nphamcs@gmail.com>
Cc: Alexandre Ghiti <alexghiti@meta.com>, Alexandre Ghiti <alex@ghiti.fr>, 
	Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kairui Song <ryncsn@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Wei Xu <weixugc@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4BC4620006
X-Rspam-User: 
X-Stat-Signature: p6bypd3khc3dx6656qkt1bmmnrm8exan
X-Rspamd-Server: rspam04
X-HE-Tag: 1785253952-94372
X-HE-Meta: U2FsdGVkX18+kS4eexws58dDnoJXSiO1Hd4207xj2jL9SOUa1YBR5xzQYa01i/qHCgT9ZOmzuLWospxRKyopAm1oBQzYCqIvaCy4fkFggIbyfH1E3pJePIsT2L3wEFMTf6Z3oRvj7kAJ+Wn7HKwpghUTjqf9D421asfg0GaL1OoKMv9IXvXbQrKABE4F10615P/JjIB4Pb+qB5jUrDfsCrfalXtCw0eIN39pM+1AZZer2bwFt9Yl5HbOtuDemluWpo7zqieBYmfnTyZUvfwIhhmbiWx7CJmrFDmg4TfL8vQ1O43xgO7cvoVDzjrnPhz7tWhit/T4TWKitvEMhuok1BgAlvfkVoF6UW2viA6908TSqxqzqNcrZGPtyICjLQ7plioZ2bmRFdfvzV5QW+qZzqppVvXJu2iL7O65hU37PrCpBXmx+S1Ha4wfwl3O+S+oViMvGhMX/hxgWfAs6+Rww43XrWKzCY+1bbtB6fDVDyimwSlW8vbvM8fGJrwaMtNufBkaYJAoSgPF3BjWUqbIV597bxq5a0bGgL0mM0m4l/W8xZ/UdKAFPq2kfxRuqs3Kuo2uN7XbESgxcxNOtfrV8/xHJsd5wJjz6nK7ImdU8Go/tGgO6EFb/y8oGQ0OZbMlCGpWktTs+mNwSn61hPWlIMnaocONlhuPVVKEv4BR2ICbIsu37ofOhu6lW4HI4b18/44Lbv5XIYXDOmoPoUUKIj9QF8h9Stu59Oi3oQq6KE4rO0FfPNQ/6DG+9PUNschnqUyld6QltT+kljGxMj475GNzqlr/6sPHqS3wcyRo9lZHalVDuE2JMQPzjM6LevSzHguIFNfdBhACmSGvecL3rwJqEoUUeUF5l6LdAP51p+6klGdlimdPdmQzmD9WRHg+unkoUrGL6CkoM68Uaqr7fLqR23WJaIxi4Gj3zch2dGy7S2p8cikxex3hXs1yPC/mkSvHDBQgtYtJLTBGN40
 JDNpyxhK
 /SPdRdx8hvQJL1bKqb/B/3QJgjEAu2/rVrj8zYxy9vLt304+8yf+IjkdYSMeFrMn/TvCeowqk8ls5VKaVTSdRPL78IhiCqM/hM38m9gesHSaWV51XhZ9stzLLsi0fXtroRqg5fBVb41Otd9lB7AdmLYztah/fWCYfMfGe6JvFMAnRDUT8Duxcp+Cny0R43vhCBUKgD+fQmZT3f00mLr6q/CTmubMhdIGNJbc2njYVKGCWDatdmsYEPUyI6kwfknrkrXxXEIYCWdCfFFc0RejW3Cd5T3WG06UMxy4ibqG9122NxUH4KZqZrg9oOnFbC41RjuycG67RdPVhysGelOOF1sIv6kFi5P//ybMrIwmbz4irDDJ2g1TN9kjDJd22E3Dw9oPjSCapg3aodzo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 8:48=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Tue, Jul 28, 2026 at 5:58=E2=80=AFAM Alexandre Ghiti <alexghiti@meta.c=
om> wrote:
> >
> > Hi Yosry,
> >
> > On Mon, Jul 27, 2026 at 7:05=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> =
wrote:
> > >
> > > >
> > > On Mon, Jul 27, 2026 at 7:39=E2=80=AFAM Alexandre Ghiti <alex@ghiti.f=
r> wrote:
> > > >
> > > > zswap writeback decompresses an entry into a fresh swap cache folio=
 and
> > > > writes it back. The folio is cold by construction, yet it is left o=
n the
> > > > LRU for reclaim to find and free later, wasting a reclaim scan and =
keeping
> > > > cold memory resident longer than necessary.
> > > >
> > > > Allocate the folio off the LRU and drop it as soon as writeback com=
pletes:
> > > > mark it PG_dropbehind so the swap dropbehind path frees it once wri=
teback
> > > > ends. Synchronous-IO devices complete writeback in this context, so=
 there
> > > > the folio is dropped inline instead.
> > >
> > > Why does this need to be handled in zswap? Doesn't writeback from syn=
c
> > > devices still call folio_end_writeaback() and do the dropbehind
> > > handling?
> >
> > That's an optimization rather than a real need: since we know we are
> > in a sleepable context, we can safely drop the folio from the swap
> > cache here. And since we don't mark the sync folios as dropbehind,
> > they never enter the list handled by the dropbehind workqueue.
>
> It's a bit artificial, but you can try testing zswap writeback to
> zram? :) Likely you'll see some small tput win there?
>
> (TBH I have not seen sync IO swap backends other than zram though so
> idk what's more realistic. We don't have pmem device available for
> testing etc.)

I don't think it's worth optimizing zswap + sync backend tbh.

