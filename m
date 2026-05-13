Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28D66CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 20:12:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F50A6B0005; Wed, 13 May 2026 16:12:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A5806B0088; Wed, 13 May 2026 16:12:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E2DE6B008A; Wed, 13 May 2026 16:12:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5FE646B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 16:12:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9626F8C786
	for <linux-mm@kvack.org>; Wed, 13 May 2026 20:12:13 +0000 (UTC)
X-FDA: 84763493346.01.82BC54E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id A7609160011
	for <linux-mm@kvack.org>; Wed, 13 May 2026 20:12:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NMNNBUG+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778703131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sXs02Mhsl/MJMXpBFo+WgtRHMPFfsBVqPbqmMN2Nyuc=;
	b=tdN7M7I4D7SFz0DpvwpPPgJNgROC8P/6h8i9LC9qRKugVD5Bg8MSqiS8mPirTtXllvyR8L
	4k5jWGyeK6RHBU1weyI4aOqe7x1UHMiYYcBEWKA4Rsm1CwLrd8eSN/zcbEADjQ/+cexjgw
	eB02Jy2qmNVxJbEE5BcdIGIcbHUxtQc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778703131; a=rsa-sha256;
	cv=none;
	b=vm03tcXFlxRPmIRWCQFosVksNRqrWMAeodxXc4GMQddY5K5I8y8p3KJYjLEUBHZGwrh8vL
	cELj0vEIk8/6Q9o/pZ5CdaokdF7nPQJTwdGx84KLFn1vt7ypMdEoiP7o+X6bhPJA2HUNZQ
	Ah3t8FocR3d8A9HzfguDak5QAuypzEQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NMNNBUG+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F189C60121
	for <linux-mm@kvack.org>; Wed, 13 May 2026 20:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7BDCC2BCC7
	for <linux-mm@kvack.org>; Wed, 13 May 2026 20:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778703130;
	bh=S3JYwDQ5Zw0QXTjT9Ls8ZqesVm0lwasL3LMymr3KShE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=NMNNBUG+41S55u5AJoyD5JlsFjXVQPW9oqZbV8dttcZo//ANaGAcyE6CCWCW1/pNq
	 2U0ehQi7wkaI4f/SNYLfg//LQTmwGdopg6dgyoEOwqgqDl/qTga01ToC6QEKiAF5iQ
	 EZbDj2WPu+gXVs9taRxX02oI4HYRpZ7ok27OvghhYv0BrTVAi8HtbRhuGdjh9z3LD0
	 vhTToPfz/ZvXKjrnM5ggyXJlaczpc3DCQ0dbWR6+h0Gl9J9J0VTrOx5lLvB1sjGl1o
	 ZxGl/OaskJw1tMYMOI8Vbw621y0CTrzMy7iwQZgfSPqdgEbVxUmM1Hq1/xt02lSlEg
	 rrz+qBGUqTaCg==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-bd0fc4c336eso651671866b.3
        for <linux-mm@kvack.org>; Wed, 13 May 2026 13:12:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9b1UJkpaJM1U3Tcca+4QAPDfF4XdHBhgsVkwfGMdvxTwWZhqauH747pW4fHzcvi2UlV5OqetDaZw==@kvack.org
X-Gm-Message-State: AOJu0YyDtes/O8uJVbjs8bmd81Gj84Zy1SeOqEImsued4CEOcnUhVepu
	19bPDi4xL0vFBu/+4+D5j4XBPvT75/Hrv50zzGz2VVTbj8VaRdEYuzwlGU/I4UFPeOZ+I9FW8Js
	J+07KWH/iu23snATzIjHC0T3+DbHMOWk=
X-Received: by 2002:a17:907:1b1c:b0:ba7:7f6d:be4a with SMTP id
 a640c23a62f3a-bd3c11fbe11mr344342966b.26.1778703129433; Wed, 13 May 2026
 13:12:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260511213658.25273-1-contact.kartikn@gmail.com>
 <20260512144733.9132c83e392a109743e92f71@linux-foundation.org> <agPjfGO6zh9HLPBE@google.com>
In-Reply-To: <agPjfGO6zh9HLPBE@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 13 May 2026 13:11:56 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNtM0X8ednF_YosWa_GjvrW5OmR2Ysj2svYKfBrRwxxqg@mail.gmail.com>
X-Gm-Features: AVHnY4KyNis_hOAinTuXLQ5Lt2LFbFkkisDzSWFgyjGcEZGZ_X3VOmiWuR3gZ_c
Message-ID: <CAO9r8zNtM0X8ednF_YosWa_GjvrW5OmR2Ysj2svYKfBrRwxxqg@mail.gmail.com>
Subject: Re: [PATCH] zsmalloc: zero-initialize zspage memory to prevent KMSAN
 uninit reads
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Kartik Nair <contact.kartikn@gmail.com>, minchan@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+8f77ff6144a73f0cf71b@syzkaller.appspotmail.com, 
	Nhat Pham <nphamcs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A7609160011
X-Stat-Signature: 6spz4o495wde4qpeqayjdtsmrwbmjuup
X-Rspam-User: 
X-HE-Tag: 1778703131-812572
X-HE-Meta: U2FsdGVkX1+HWiw3T9QxpXglKcbgLhpDMW1Mbuu+9w2qMkiWe4ewncRwNWYqw87gUVeosRezB7GMM6qTKUybUpqkOxfXyr3METuHJh7u4vcY3jgYR4ggQ2X4NtznqxbiToW2OErbts4D8t4i9jCt0llG7OdYaCpvPK6dKCsoK0qL7mTiZBB575oD1kDXDWqBclyT+Hbd29YmegP/L5qBAIoz8eNm5hNbbm7n7+3FCFBkxDxCVAHXda5Is5vW1tNhmCoba8uRnrB5IiLmk4stO4nkxRl5EDhwSG/qjzPkLzBedDFFszqnBgFFileRkg1PCJbMeSrUBcjBwskpLrh/bYR3pIaVDBwxH7gQekLPSISFkXIY8TbJh7yWp5WWKQ3K5oP+Ytu3Pe9MCTtqaCslnE7w6T5nwKHVNCxXmf1PHrBVSXR5AZzYbf8N18RMbAqgY4xff5vmXqsEnAH6+Z9vLa6JbZHGDTlovDMW7Jv9SZElSLA6zLT/R0IBk/rsSm3bMlK8z9SCk7Ja7J3DPPM3IqEBlyC3Ypdd2l6AFORR2TIcEVulC1RXPHW3y8PDX1AhRk2Mkb6VZ6TI7Xlok8wA9lvcpOUd+kcDYex7a7fexDzExDwjEcRGAR9toIGs0s/4thPk5xxvwJN2kjTe0xRvGp/lnsVUL8ep5xykxbtyeN1IpzsDUOCpee8ZNqkSwoY6np9Gsy5hL2YNS3E1uvT9cNWsAwPnZ5lstgJNag/XtkvaCc20YsowqwvSgnMp1fXAKuqF+xe9BBoea63UzywNhBJKfjtVKNfYKxqV3o4BbvjDWiqY+LJA7zOa1CgS03ion5lWqFqn3/uIJXh4OA7tln3T6nBRkGD0sekfUqf8VKEll9BcNQ4v1jhcn3HVbxm8MTDr1sNWYUp5Q/eSZNczhxyguPrkDlAy5HI/OuZ0D+eoi8BIH7Vr89XRzc3fxXkIB3CWWEev/k22emg4Mh/
 SbavFr2C
 qF2OFGqKbyFXYcGdOKE+pnjK5NsdBfHo0qNJo6TZJupeIDJo1ENEB9qH2XdBDg8RbEm1+BYE6+D0+zCZKhKzS6tYDnimgWHj9ZO9joc4W7bbqqpuDhGrS+kvnSEzUsQhUiQR6GxfBiZKoDgRChaAAaFg+xRpM7nSlYh0VcpnH6diGlBXUnErJ5klCJEuorTmOpJ2vHp7kx+rY6NSWZuXT4Unjl4jDtPdAQpHfKP96J6HOzs28eGWgpJEwF5sC63Tui6Bs4VujvupwakMuqsiXwzdEk7ZklFreGXdlUUwulBI1TI6ciypeIu6MdVgI+nN909qalw6nLAlKSByJPMwCid/4+bFYgG9QggOXopgg2mK7lZMZpLzJiKBD4b22qhkMpEvWfTmmmk/uV8OAu5VlOB+0uvlJgU++qdAj4xJ/Payr4ZX8bAyeOeq1cvEdWFCEkjhTIBNDGt55cgQJ6GAht0pSwLuAsr7TWaYpQw+jDqJMa6OU5X0sanUi4cZYcXcnGMOA8AjJ5OSMY6SEoYVHYRAcpIHC4XQzRZf/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 7:47=E2=80=AFPM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> Adding Yosry and Herbert,
>
> On (26/05/12 14:47), Andrew Morton wrote:
> > > Pages allocated via alloc_zpdesc() use alloc_pages_node() without
> > > __GFP_ZERO, leaving physical memory uninitialized. When a compressed
> > > object spans two physical pages in a zspage, zs_obj_read_sg_begin()
> > > sets up a scatterlist pointing directly at the raw second page. If th=
e
> > > second page was freshly allocated and never written beyond the object
> > > boundary, KMSAN detects reads of uninitialized memory downstream in
> > > the decompressor (e.g. sw842_decompress reading the CRC trailer).
>
> I don't get this.  How can sw842_decompress() read more bytes than
> it's told to decompress.  We first compress and store the object,
> before we load and decompress, reading past the known compressed
> object size (which we pass to decompress function) should not happen.
> Yosry, Herbert, any ideas?

I agree it's weird that sw842_decompress() is reading past the
compressed length. I didn't look at the code but maybe it's ready in
chunks of N bytes (e.g. 8 bytes) so it's reading a few bytes past the
end of the compressed length?

Not sure if we should add __GFP_ZERO in zsmalloc just in case, or if
that can hide other problems.

>
> > > Fix this by passing __GFP_ZERO to alloc_zpdesc() in alloc_zspage() so
> > > all pages backing a zspage are zero-initialized at allocation time.
> > >
> > > Reported-by: syzbot+8f77ff6144a73f0cf71b@syzkaller.appspotmail.com
> > > Closes: https://syzkaller.appspot.com/bug?extid=3D8f77ff6144a73f0cf71=
b
> > > Signed-off-by: Kartik Nair <contact.kartikn@gmail.com>
> >
> > Thanks.
> >
> > > --- a/mm/zsmalloc.c
> > > +++ b/mm/zsmalloc.c
> > > @@ -951,7 +951,7 @@ static struct zspage *alloc_zspage(struct zs_pool=
 *pool,
> > >     for (i =3D 0; i < class->pages_per_zspage; i++) {
> > >             struct zpdesc *zpdesc;
> > >
> > > -           zpdesc =3D alloc_zpdesc(gfp, nid);
> > > +           zpdesc =3D alloc_zpdesc(gfp | __GFP_ZERO, nid);
> > >             if (!zpdesc) {
> > >                     while (--i >=3D 0) {
> > >                             zpdesc_dec_zone_page_state(zpdescs[i]);
> >
> > Decompressing uninitialized memory sounds rather bad, so I'll add a
> > cc:stable to this.
> [..]
> > I think the Fixes: target is 56e5a103a721 ("zsmalloc: prefer the the
> > original page's node for compressed data").  Can people please check
> > this when reviewing?
>
> If we need to pick a zsmalloc commit, then this probably can be related
> to zs_obj_read_sg_begin() API (which is used only by zswap at the moemnt)=
,
> so probably the Fixes: tag be dc2e4982cb018 (zsmalloc: introduce SG-list
> based object read API).

Agreed.

