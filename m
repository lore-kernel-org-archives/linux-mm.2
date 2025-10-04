Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B23ACCCA471
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 01:12:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE81C8E0003; Fri,  3 Oct 2025 21:12:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBFF98E0002; Fri,  3 Oct 2025 21:12:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD5B18E0003; Fri,  3 Oct 2025 21:12:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CD9308E0002
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 21:12:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6DD57BC53D
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 01:12:00 +0000 (UTC)
X-FDA: 83958655200.09.E9615E4
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf11.hostedemail.com (Postfix) with ESMTP id 97AF540009
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 01:11:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Cbv94caI;
	spf=pass (imf11.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759540318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cg/o+1i1wgPcPhnANrnCwbeCVtTSpoAQZ0dnG9C/p9k=;
	b=RSfpkCNWg/DrrLovfz6vpTAwyKSyQn4QUCz/14UNtL4Sf+asXsFceQ8WadDWuWYnWHH6sm
	UGfh45GMOWeCYkEIDAsMT7HEvUooxF0r9MLKdWzXxszofWx4TBEGcoZVmsm1ZdbAxc2gIO
	AmrOpfBbaxDO4xn1e4OxJC4f6Ig2Nqs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759540318; a=rsa-sha256;
	cv=none;
	b=qUf8ErOCnVl4jGMh5v2tGjOdu8GMXBWif8rfgtFxmr6oYRHhr09/2IFMVY1eROATNcmLDS
	qRJAbDpe9PNih8vPLkA3SljBRh5c6FfOgdggA7WJz6NapXcn877XnTt3WlpTETD9XoLsMP
	qRhaMoZthBbjy4Ga0EAJA1IQhwe0V4Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Cbv94caI;
	spf=pass (imf11.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-826311c1774so329916785a.2
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 18:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759540318; x=1760145118; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cg/o+1i1wgPcPhnANrnCwbeCVtTSpoAQZ0dnG9C/p9k=;
        b=Cbv94caIxju2NAWB4UQLdSmiY8r0MJxKplCrL9SFQoXUGRrOi2IR78xW0T7zwtrsBx
         QzinAnpweP9PeXAYeb26Yu3mNd+NmkhnbRoGliGtU7bqgxo5UPChqaD/54y0etFFE3xC
         MfECiR76aXTT8HQeN4grqDakf3Vabgft/lOdN0++ecxKGn+FXl7SY9AktH+g4HP5atlF
         nGOI8WMMrTyjMQ5IP+CuVMzIiJzN6e+zAtvcXrjI2t0bK68szjlhPGsBpV2YDhWf8E+r
         LcTKMp5bm/acvRO+kGRsZeunYgCc5DZ6Fz39m6eI+xsK/dhVoS+5RR0Sk7/Hn9fAwzx5
         62mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759540318; x=1760145118;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cg/o+1i1wgPcPhnANrnCwbeCVtTSpoAQZ0dnG9C/p9k=;
        b=b3KwYsPWE8HjhfNSV8HJqLBWNQ2267OiEsUkwXrMcYn7CJpPd1PSSiePfDQhu1M6qK
         qqhSMHWG0fHzPv6LdiK9bNVUdSk1yx9Zf7Ocxpa1p2JoXlq9p1OnrSHJpLY3A/NEplvm
         CPF9NZmoc8s4LRcYkTLEFtNGx3jTJqO1JDMRsJkZL5+7PIaWcvrWbYv2G63iOgpHOJA0
         Kta6pdIceD5ros/a+NwQ6G1bar7rmeTMKVrXQNlUrlEJjcEFcdJwyZWwGWlZniCswAzD
         9mAzQ5FfGKDgxKWaJ6FsYoLXH8VFK8AyWQyU6dTqHRW7BrBWQ+ieF+0/rk93uwDWWsFK
         RhLA==
X-Forwarded-Encrypted: i=1; AJvYcCWpD6z9eeQND9voHdgSWiKvygLMOPkyEboDdlFESrB5Ia/Et6rrfbaYnOW31P/j6/p/Tr7EV9AbSA==@kvack.org
X-Gm-Message-State: AOJu0Ywk8WriMx1Zik612pKD2cdyik8i5saGRTZgrl3gEHTLY7+nFr0Z
	CXteanLzBlOTJ92lIe8Bn4xj4bn0lUUZLkgvVqtwbTXb427xhwCPwKzMWhK51Eu9Z2Q/Xoa4rQ2
	VZuO+MHhn2ltpTRqs6eS3yNKAaVXuhIc=
X-Gm-Gg: ASbGncu36aPcZD8edwHqssmXKtIkB8Y53gy+pq7jJo3sPZ4SKyn6ewtZbd1jrxgnUuK
	Ef1k0UQKSu23zfGE10+ERUQL7f2GFrfh5GnLCYTlt0cqHq3V3O/T97NjH7Ui3PIqFCddc2qzM9T
	6v8JTnmNz9m4FofjuLkgGUagXtUoKFrruP+8o+BaMdBs0BEOsUqX4l31Ay0To0hdI+NXxsRg64w
	tIHQn7+Q8UyBec67HTwn94XW16gizBTJ8Hwunkceh9PpbxGQg1MHuBXNGYfTrUzaGRbzxnR5g==
X-Google-Smtp-Source: AGHT+IFLvYyMiPRzs9rrQMqs2JnG0v1Bz/iHHaMqXs7Ifgi0InrWOPxE8NIVym22Jcei5iLGhrb8hDuNGJz6rr/Jh4M=
X-Received: by 2002:a05:620a:1729:b0:85e:24c3:a60f with SMTP id
 af79cd13be357-87a3adf2c75mr747203585a.65.1759540317558; Fri, 03 Oct 2025
 18:11:57 -0700 (PDT)
MIME-Version: 1.0
References: <20250829233942.3607248-1-joannelkoong@gmail.com>
 <20250829233942.3607248-11-joannelkoong@gmail.com> <aLiOrcetNAvjvjtk@bfoster>
 <20250903195913.GI1587915@frogsfrogsfrogs> <CAJnrk1ZT8w6p3Mnqx8R3dWUF1NFOYT95tkKFq5LGcS4=01fGsg@mail.gmail.com>
In-Reply-To: <CAJnrk1ZT8w6p3Mnqx8R3dWUF1NFOYT95tkKFq5LGcS4=01fGsg@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 3 Oct 2025 18:11:46 -0700
X-Gm-Features: AS18NWBK4HC9BGpRE6C1zBBeHEWzv0WiMOcZUgcfeGJPNXvBrfXXNYrG_x2NsQA
Message-ID: <CAJnrk1ayPGD5h+zHzHrdW5CvyJuhEZ38DD1+ZqAK3vo46wtd=A@mail.gmail.com>
Subject: Re: [PATCH v2 10/12] iomap: refactor dirty bitmap iteration
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Brian Foster <bfoster@redhat.com>, linux-mm@kvack.org, brauner@kernel.org, 
	willy@infradead.org, jack@suse.cz, hch@infradead.org, jlayton@kernel.org, 
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 97AF540009
X-Stat-Signature: kdnbrxhctgwu9cspmmntruqnr5jq1qe8
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759540318-432536
X-HE-Meta: U2FsdGVkX1+92vFuq1YYI7aB838/x3SlC11kxlpttnw2bKjhPLaMfOzy9c8dsK1CZq17JwD7saf0R0EEvobQXQY/3Pcai1XqeWBK6dQ5cja4oHl40PGABol2tYK4Y1LjF5jC5AlUZ7AYIgKTKcWDYqlZwq7XzsJj9tiIi7yf4uJcskunAJ4zSUxv98QmEdxFJCP4WwMBYMr+MhXm8d5nmAyXExVU/hIhNZL/s5jzaZNzJQ0gVFdoEeKmRMlBfvJr+U0ZojmmYqRH2fUrqgfPKG65MrV8TiZmUFFUUMOq7+4uZzWjmNyd4zyBCBwXNLiz3vv+PYvs7kpFnniBJTjQ4Eo4rPpGKqRk0X9aIcivkx8A+BS5ooHR2BfEwq3CIwYNGt77HE6a/FzhTx4AL2L/UH7IeOFg7HysT3Z5LIcAf28JuOC+Ll7HDbZzcsYiqj79cNoKZqq5HznGRXcvLyRQn1J88PhOrf+Ci4uZSXCYCkjM4/gsQaEHuDEf/wmwwJEDOp9Fv73YFmWMM3jCy32Ny2zw03dvSWBvx2V2T0kMVSempUODhDTakmEi69KMQIFNmrrfDhm35JFdZxgMi5SEhAIJxI0GPaSPZbvs1uKnfMT974v0g/YM9hhwqK9z1x6RChuu8tTg83h4ri0ZSHF9rTzToWU665/SNjEFPlGMTx77E6aJMLyBYJftZU0f2Nif/NuSHX5sVq91lqkPPdmnVnErV55OOiYWIfDIMZcOAfmpN5Ytd58mm+Uti7tjP6ER8xoOILO4JHq2ctrdTp1XB7s/KiexH5sPkNilopIQmZ8rWvzU9lUQ8Gd+sBsAsihI4STK1PG4Lc2mR5M97TI37IUycTRs/TvfpB4DdFiZFpvZMx/VVBmGIrcRm/jeet/KM2h+rXBWniHHWfcprn7K0Fszc6zPI1coJUqEYGN5Fs1Iswr5hH8qCPX3cK/s8Gj9S3RBKQ5a1KM8xVkMbGH
 VleN61RK
 q1jFzCOtd7vas/4r3hfzqDuJ4oYU7+WBBIsJH2RHpkyXWxX0cs7utKF4K2ipfOcJu8RTulZ1zZCaPFlmLk9p77AQfV5xY0ZF7qZNa1aecpw6pUrZMbXTNJE0Pikf0MkPTicQoejo10MMf8M81RsGsDDrNj48vKNKtpUDCJzrSUTNnur7VbdfkH5qD21gumphiaXF6gU4OOgea29Zm5mDIipeR+JBzIYRzZmCTFKtxWTzod/vpM5eMttfBI8Kl11vE1yQD1iUdBpPnAynFIs+HdMsL/eWgfRbf9NRLVPC0ZAQyz4W+MRzWAJU09pMHltWvorO7unwdklDni19gB8vPbYqiX2l7RhFi23Eava2eCVugN5xbii1TzcKPZl8HjRF5gBdEkxKo8Ev6y3J0aV81QvlXOG6oCjy6fY5K72MqAcTdwTGDNnYi0hpZL6rJWXORTAuDMx4rYFUdtYE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 3, 2025 at 3:27=E2=80=AFPM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
> On Wed, Sep 3, 2025 at 12:59=E2=80=AFPM Darrick J. Wong <djwong@kernel.or=
g> wrote:
> >
> > On Wed, Sep 03, 2025 at 02:53:33PM -0400, Brian Foster wrote:
> > > On Fri, Aug 29, 2025 at 04:39:40PM -0700, Joanne Koong wrote:
> > > > Use find_next_bit()/find_next_zero_bit() for iomap dirty bitmap
> > > > iteration. This uses __ffs() internally and is more efficient for
> > > > finding the next dirty or clean bit than manually iterating through=
 the
> > > > bitmap range testing every bit.
> > > >
> > > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > > Suggested-by: Christoph Hellwig <hch@infradead.org>
> > > > ---
> > > >  fs/iomap/buffered-io.c | 67 ++++++++++++++++++++++++++++++--------=
----
> > > >  1 file changed, 48 insertions(+), 19 deletions(-)
> > > >
> > > > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > > > index fd827398afd2..dc1a1f371412 100644
> > > > --- a/fs/iomap/buffered-io.c
> > > > +++ b/fs/iomap/buffered-io.c
>
> Sorry for the late reply on this, I didn't realize you and Brian had
> commented on this.
>
> I'm going to pull this and the next patch (the uptodate bitmap
> refactoring one) out of this series and put them instead on top of
> this other patchset that does some other optimizations.
>
> > > >
> > > >  static unsigned ifs_find_dirty_range(struct folio *folio,
> > > > @@ -92,18 +121,15 @@ static unsigned ifs_find_dirty_range(struct fo=
lio *folio,
> > > >             offset_in_folio(folio, *range_start) >> inode->i_blkbit=
s;
> > > >     unsigned end_blk =3D min_not_zero(
> > > >             offset_in_folio(folio, range_end) >> inode->i_blkbits,
> > > > -           i_blocks_per_folio(inode, folio));
> > > > -   unsigned nblks =3D 1;
> > > > +           i_blocks_per_folio(inode, folio)) - 1;
> > > > +   unsigned nblks;
> > > >
> > > > -   while (!ifs_block_is_dirty(folio, ifs, start_blk))
> > > > -           if (++start_blk =3D=3D end_blk)
> > > > -                   return 0;
> > > > +   start_blk =3D ifs_next_dirty_block(folio, start_blk, end_blk);
> > > > +   if (start_blk > end_blk)
> > > > +           return 0;
> > > >
> > > > -   while (start_blk + nblks < end_blk) {
> > > > -           if (!ifs_block_is_dirty(folio, ifs, start_blk + nblks))
> > > > -                   break;
> > > > -           nblks++;
> > > > -   }
> > > > +   nblks =3D ifs_next_clean_block(folio, start_blk + 1, end_blk)
> > > > +           - start_blk;
> > >
> > > Not a critical problem since it looks like the helper bumps end_blk, =
but
> > > something that stands out to me here as mildly annoying is that we ch=
eck
> > > for (start > end) just above, clearly implying that start =3D=3D end =
is
> > > possible, then go and pass start + 1 and end to the next call. It's n=
ot
> > > clear to me if that's worth changing to make end exclusive, but may b=
e
> > > worth thinking about if you haven't already..
>
> My thinking with having 'end' be inclusive is that it imo makes the
> interface a lot more intuitive.
>
> For example, for
>     next =3D ifs_next_clean_block(folio, start, end);
>
> with end being inclusive, then nothing in that range is clean if next > e=
nd
> Whereas with end being exclusive, that's only true if next >=3D end,
> which imo is more confusing.

Ah I guess for the exclusive case you could just write it as
     next =3D ifs_next_clean_block(folio, start, end + 1);
which would let you make the check "if (next > end)".

I'll play around with both versions and see which one looks better.
You and Darrick may be right that we should just make it exclusive.

Thanks,
Joanne

>
> If you and Darrick still much prefer having end be exclusive though,
> then I'm happy to make that change.
>
> >
> > <nod> I was also wondering if there were overflow possibilities here.
>
> I'm not sure what you had in mind for what would overflow, the end_blk
> being beyond the end of the bitmap? The
> find_next_bit()/find_next_zero_bit() interfaces protect against that.
> Or maybe you're referring to something else?
>
> >
> > > Brian
> > >
> > > >
> > > >     *range_start =3D folio_pos(folio) + (start_blk << inode->i_blkb=
its);
> > > >     return nblks << inode->i_blkbits;
> > > > @@ -1077,7 +1103,7 @@ static void iomap_write_delalloc_ifs_punch(st=
ruct inode *inode,
> > > >             struct folio *folio, loff_t start_byte, loff_t end_byte=
,
> > > >             struct iomap *iomap, iomap_punch_t punch)
> > > >  {
> > > > -   unsigned int first_blk, last_blk, i;
> > > > +   unsigned int first_blk, last_blk;
> > > >     loff_t last_byte;
> > > >     u8 blkbits =3D inode->i_blkbits;
> > > >     struct iomap_folio_state *ifs;
> > > > @@ -1096,10 +1122,13 @@ static void iomap_write_delalloc_ifs_punch(=
struct inode *inode,
> > > >                     folio_pos(folio) + folio_size(folio) - 1);
> > > >     first_blk =3D offset_in_folio(folio, start_byte) >> blkbits;
> > > >     last_blk =3D offset_in_folio(folio, last_byte) >> blkbits;
> > > > -   for (i =3D first_blk; i <=3D last_blk; i++) {
> > > > -           if (!ifs_block_is_dirty(folio, ifs, i))
> > > > -                   punch(inode, folio_pos(folio) + (i << blkbits),
> > > > -                               1 << blkbits, iomap);
> > > > +   while (first_blk <=3D last_blk) {
> > > > +           first_blk =3D ifs_next_clean_block(folio, first_blk, la=
st_blk);
> > > > +           if (first_blk > last_blk)
> > > > +                   break;
> >
> > I was wondering if the loop control logic would be cleaner done as a fo=
r
> > loop and came up with this monstrosity:
> >
> >         for (first_blk =3D ifs_next_clean_block(folio, first_blk, last_=
blk);
> >              first_blk <=3D last_blk;
> >              first_blk =3D ifs_next_clean_block(folio, first_blk + 1, l=
ast_blk)) {
> >                 punch(inode, folio_pos(folio) + (first_blk << blkbits),
> >                       1 << blkbits, iomap);
> >         }
> >
> > Yeah.... better living through macros?
> >
> > #define for_each_clean_block(folio, blk, last_blk) \
> >         for ((blk) =3D ifs_next_clean_block((folio), (blk), (last_blk))=
;
> >              (blk) <=3D (last_blk);
> >              (blk) =3D ifs_next_clean_block((folio), (blk) + 1, (last_b=
lk)))
> >
> > Somewhat cleaner:
> >
> >         for_each_clean_block(folio, first_blk, last_blk)
> >                 punch(inode, folio_pos(folio) + (first_blk << blkbits),
> >                       1 << blkbits, iomap);
> >
>
> Cool, this macro looks nice! I'll use this in the next version.
>
> Thanks,
> Joanne
>
> > <shrug>
> >
> > --D
> >

