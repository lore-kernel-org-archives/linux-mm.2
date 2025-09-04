Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12E60CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 00:36:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 534848E0005; Wed,  3 Sep 2025 20:36:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E5A78E0003; Wed,  3 Sep 2025 20:36:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D4198E0005; Wed,  3 Sep 2025 20:36:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BA2C8E0003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:36:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CE59A160974
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:36:06 +0000 (UTC)
X-FDA: 83849700732.10.DE636AE
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf21.hostedemail.com (Postfix) with ESMTP id F2F8A1C0004
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:36:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lkrI7+3o;
	spf=pass (imf21.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756946165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QxvKMDBteBaFSXXMAlTTXAOeze6jB8TNVMDDZC5HWuc=;
	b=ahCd0ICMqxdY+81ZbeyRWqOM51lPazT39iCJE8sibrLLHptaN6GZDOAgETkD7mVVrCiH5l
	om8ylDgcY+2leQgH8u+5SnwNdNUfFzd/BqwDkJdRJpjaKaSKfJ573CCjGw6bE1IpilOTms
	VQ5S3Gdu9f30jIkrvE3CNR3BqfzDRb4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lkrI7+3o;
	spf=pass (imf21.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756946165; a=rsa-sha256;
	cv=none;
	b=5/IUPAE2uR9wkJd4BR9FStLGgEpMU76rNbmyECqZP071JQz8GPhIEZ0gC7XVn9jS9EgvgX
	WgSoLBm/0CWhPlEx0NDSNiEbpJ7pvrOPavmzSUz7hXt53MN6Yclt9k1QNJIFibsh8G68ii
	Jc4Fzi0HfK5w+YJHJxf00uJzhr6jbQo=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-7fdddb25854so55182185a.3
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 17:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756946164; x=1757550964; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QxvKMDBteBaFSXXMAlTTXAOeze6jB8TNVMDDZC5HWuc=;
        b=lkrI7+3oQYf98EH5yUxfbq11fmyLDhKoOljNuo0NRrfkrL1HQIBk8cP2Cifpw8B8Uh
         SLPv0DN5jUZGPSHbzaN8vuEg+Lvt/WZLM/cg0TqzWbq469PZDuelw/IC1Bd1RZXu83SE
         H2qoVuaRB8zJwufmmqQAYu7DN4pdnA4dyADDfGP3oexCgXitFaqEFAhIlwhup4N7rmK8
         K7ZD2kamOHZklVslFMy1GIw/KPrS4+AxWYUiozq7e04IYjLoyx0oqntSrByn45wx3lSU
         mnM7Noct4Cgb0dWLK06zg8IIWQRivyhsLS/u/4TndUZ0vJM5oh+IjvE3pxtaVM7OXtOA
         jgaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756946164; x=1757550964;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QxvKMDBteBaFSXXMAlTTXAOeze6jB8TNVMDDZC5HWuc=;
        b=CYR1FcsS73qxNFq+hJhSo1NPFPbaXq86tcTbUoR1SQV1n12lLzxZhUaTu8Ul5rthUc
         VtjfE/vEZh+oAdeG+F622gGbwSPXulzgl3Lm9xxDZFZsniLMPt2hslEp4bpcQVtjtZzK
         RR1q/rc1vHUq/5J2sUX5tkcLKVI0T7F1B6jFj6BN1b7rWXqiH+4GMhUubM1yWJ3LKcB0
         MtWwM9bn0xdP+qnjRa9FQLw80FPCwr72uvsK5Ow/Bvqa8Cx/kd9juFlsfyEkXLeAwNlM
         p4O8I7WY3qBvU6xqY84u/7koZuqefjt1kvhlv+bglRMTzc51YEtds6RLeRqTCZfGbQYW
         d/Mg==
X-Forwarded-Encrypted: i=1; AJvYcCWsg+4oQJwckeVWzUMzdYZj/JIbdUKuu4oYd7VAJnuEW2LXewGYYOY5s8SYJIeAoosq7sqdpqekIA==@kvack.org
X-Gm-Message-State: AOJu0Ywhh4eryQOjXVqTxtBf/b7G7aZ01biKBRKSM3LIWdJhhk/CgxIp
	IrlUuU23fmvXwocYT+77XV/+mYOwn9bBX9lf5pjxFwJfioGjYvwXTJk1ZwkMCih+6++SFu8TaKE
	hPmh8yDXxGdSi9FtYnqTbR4S3lhZBTNM=
X-Gm-Gg: ASbGncuKCBoYCcyPEshyB8Cwja29Z9MHZ0zKFQHM+FtlepHKJ5VFXrPdmLAWmNgTaom
	99R8rRFDITYwihDUTwthsGbzksxUmS29LeYihzmug1+ELiX9hT+nuORyGeyS89UVPn0G3HxdRXP
	NiEX0Ya/LTjxY+Qlic6ZL5Q6peL8pm6AntXyWFL706nCs1cCJLcqNegV29rDj0d9kpRBFw+cqGf
	6v8mCe0gTeJptJBxmM=
X-Google-Smtp-Source: AGHT+IFq/F2Sam+4NOp0z4+zy2UJzABdxTMpBfQMbHdmyiFJ7iPaAvDn2bswJosndms30eVWIDadlwUxUBeZy/kQMIU=
X-Received: by 2002:a05:620a:7101:b0:80a:72d7:f0da with SMTP id
 af79cd13be357-80a72d7f181mr680707085a.73.1756946163875; Wed, 03 Sep 2025
 17:36:03 -0700 (PDT)
MIME-Version: 1.0
References: <20250829233942.3607248-1-joannelkoong@gmail.com>
 <20250829233942.3607248-13-joannelkoong@gmail.com> <20250902234604.GC1587915@frogsfrogsfrogs>
 <aLiNYdLaMIslxySo@bfoster>
In-Reply-To: <aLiNYdLaMIslxySo@bfoster>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 3 Sep 2025 17:35:51 -0700
X-Gm-Features: Ac12FXwY3PDGqO3cWcWewqS3_uvz7ErKO_WyD1D_aUPlmd9OdplVHaXualv0wko
Message-ID: <CAJnrk1Z6qKqkOwHJwaBfE9FEGABGD4JKoEwNbRJTpOWL-VtPrg@mail.gmail.com>
Subject: Re: [PATCH v2 12/12] iomap: add granular dirty and writeback accounting
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-mm@kvack.org, brauner@kernel.org, 
	willy@infradead.org, jack@suse.cz, hch@infradead.org, jlayton@kernel.org, 
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F2F8A1C0004
X-Stat-Signature: xpjaa3ywpag6o4p4gytopy9f9bi5z4s7
X-Rspam-User: 
X-HE-Tag: 1756946164-450256
X-HE-Meta: U2FsdGVkX1/pzc/bdlSFDWMY89+qXt5Mdz2R8ESaA9szSb4PBIVh+ymW6EtTEckm5VzLPuRGnKnN+Txz1JUqWHIllC9X7hFCmzL+5SLAoYrNYTQOfkEXSzkTK65VzyVCuLxF5BCjILpVeWacXcV8voMgIBfKcWiRMtKLH6GjxsMsqFxHkWSDeyMXLAiE5vPvt4CvOJZelgE0Xg+FeWnpF1xVLWVo4mkyHGd4ufDtQDwJCmqIZL0UAkEy6JuRKQeXh+Bw5NtcD8NCJLDidDWJUPYUbxNrvecWgkLrUuEuqNeob/almHihBibF6REUJfSOcAu3qT/9KiWkObx3+iyeng67ZAz33NYedOIYvxVDVsTUIJbheaogoqGcHZ/FJ7ImpI1Y/CR2JaXscN43ayPuA3oml+eWxeZ7iDYddkoiAmV1C6n0FtDJ353h0XIztfNnDL7S6PAw0LFprk512NVynNxc+XLCdVswc3M6vzZXHCl3FjfYgzEVqFmviLgLS11MMTsJc8LI4pVnyLlySZiVi6eg4uE1+VZNdG78dfTde6hzcBJwsDLqy6QrPPzB5ajavgwL9oCIpD/bgqX75VHYHJ3gox7HtPXvx/5BHn95h2j+Mw/W7+yxsGAs5tgCcq/uM4Val5QlDBNF1uaWsYmcrAiRhgbHSJmJKM6R7uIySpQQy1zrtWMi1SQS5+lavlsFWFBPG2LIiQ9wCVBeBC8ShZrj+m+qBiVcgQ/KLGaaG8cn4d7IQTKLaVweQvd1LDT/m52ZQFRvFRizQ/us5q3+L9UQL78NLDssZXumN62aIn3kMvGIpY4SgG2yysWrms45dMa2fU+f5s7UN3fc4j0iGYH4FAiAC4T/eXvK0398R3z9u7dM/MOr5tH6lNRccA8TK50HvzbIgNCVlr/tI7wvIxLuNzXe/hmuxknBC2nUOLIAMI+ylBTMz0OkT1yI6Ar1VQsBe52TasLx+2q46Xw
 hrlZa+Rt
 91i3rO4FAZC3TT2alMgtMFzcHEuCbPXZBeW2troFdUpiSBlv9ujxAHnAiWQr6xYV8c68C0IxZqq2lu7vhIXCcEof58tt8VHEY/WcbsjAn1zSTpzRfEYSQQaMqpdyZd1nDJ3E5yjjn/quuQ9PDN20soLWsU3z0sQjyAsgaf/F/D4k6f+LaQzfxqgOT/u6wSn3zLnE77DiG62C4gv1mqKj/8rDeaN4M5MbKbCm7RMajULCqpLiSb6c0oNzlltiAgcYML6SjNpy5I40IuzXTIMGiO5hz1AP6Iy3e75fF48U0RuBup0+JbW0BnGHyl9uN4j2JrS/+0v0+qb+u4bQOT6WPQxkjt7lg6sO5NrKRv5TE3W66kVX8wSxjdKcBkyvIxLcpjMVMcCKkVoWxj+oPubgpLT87CQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 3, 2025 at 11:44=E2=80=AFAM Brian Foster <bfoster@redhat.com> w=
rote:
>
> On Tue, Sep 02, 2025 at 04:46:04PM -0700, Darrick J. Wong wrote:
> > On Fri, Aug 29, 2025 at 04:39:42PM -0700, Joanne Koong wrote:
> > > Add granular dirty and writeback accounting for large folios. These
> > > stats are used by the mm layer for dirty balancing and throttling.
> > > Having granular dirty and writeback accounting helps prevent
> > > over-aggressive balancing and throttling.
> > >
> > > There are 4 places in iomap this commit affects:
> > > a) filemap dirtying, which now calls filemap_dirty_folio_pages()
> > > b) writeback_iter with setting the wbc->no_stats_accounting bit and
> > > calling clear_dirty_for_io_stats()
> > > c) starting writeback, which now calls __folio_start_writeback()
> > > d) ending writeback, which now calls folio_end_writeback_pages()
> > >
> > > This relies on using the ifs->state dirty bitmap to track dirty pages=
 in
> > > the folio. As such, this can only be utilized on filesystems where th=
e
> > > block size >=3D PAGE_SIZE.
> >
> > Er... is this statement correct?  I thought that you wanted the granula=
r
> > dirty page accounting when it's possible that individual sub-pages of a
> > folio could be dirty.
> >
> > If i_blocksize >=3D PAGE_SIZE, then we'll have set the min folio order =
and
> > there will be exactly one (large) folio for a single fsblock.  Writebac=
k

Oh interesting, this is the part I'm confused about. With i_blocksize
>=3D PAGE_SIZE, isn't there still the situation where the folio itself
could be a lot larger, like 1MB? That's what I've been seeing on fuse
where "blocksize" =3D=3D PAGE_SIZE =3D=3D 4096. I see that xfs sets the min
folio order through mapping_set_folio_min_order() but I'm not seeing
how that ensures "there will be exactly one large folio for a single
fsblock"? My understanding is that that only ensures the folio is at
least the size of the fsblock but that the folio size can be larger
than that too. Am I understanding this incorrectly?

> > must happen in units of fsblocks, so there's no point in doing the extr=
a
> > accounting calculations if there's only one fsblock.
> >
> > Waitaminute, I think the logic to decide if you're going to use the
> > granular accounting is:
> >
> >       (folio_size > PAGE_SIZE && folio_size > i_blocksize)
> >

Yeah, you're right about this - I had used "ifs && i_blocksize >=3D
PAGE_SIZE" as the check, which translates to "i_blocks_per_folio > 1
&& i_block_size >=3D PAGE_SIZE", which in effect does the same thing as
what you wrote but has the additional (and now I'm realizing,
unnecessary) stipulation that block_size can't be less than PAGE_SIZE.

> > Hrm?
> >
>
> I'm also a little confused why this needs to be restricted to blocksize
> gte PAGE_SIZE. The lower level helpers all seem to be managing block
> ranges, and then apparently just want to be able to use that directly as
> a page count (for accounting purposes).
>
> Is there any reason the lower level functions couldn't return block
> units, then the higher level code can use a blocks_per_page or some such
> to translate that to a base page count..? As Darrick points out I assume
> you'd want to shortcut the folio_nr_pages() =3D=3D 1 case to use a min pa=
ge
> count of 1, but otherwise ISTM that would allow this to work with
> configs like 64k pagesize and 4k blocks as well. Am I missing something?
>

No, I don't think you're missing anything, it should have been done
like this in the first place.

> Brian
>
> > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > ---
> > >  fs/iomap/buffered-io.c | 140 ++++++++++++++++++++++++++++++++++++++-=
--
> > >  1 file changed, 132 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > > index 4f021dcaaffe..bf33a5361a39 100644
> > > --- a/fs/iomap/buffered-io.c
> > > +++ b/fs/iomap/buffered-io.c
> > > @@ -20,6 +20,8 @@ struct iomap_folio_state {
> > >     spinlock_t              state_lock;
> > >     unsigned int            read_bytes_pending;
> > >     atomic_t                write_bytes_pending;
> > > +   /* number of pages being currently written back */
> > > +   unsigned                nr_pages_writeback;
> > >
> > >     /*
> > >      * Each block has two bits in this bitmap:
> > > @@ -139,6 +141,29 @@ static unsigned ifs_next_clean_block(struct foli=
o *folio,
> > >             blks + start_blk) - blks;
> > >  }
> > >
> > > +static unsigned ifs_count_dirty_pages(struct folio *folio)
> > > +{
> > > +   struct inode *inode =3D folio->mapping->host;
> > > +   unsigned block_size =3D i_blocksize(inode);
> > > +   unsigned start_blk, end_blk;
> > > +   unsigned blks, nblks =3D 0;
> > > +
> > > +   start_blk =3D 0;
> > > +   blks =3D i_blocks_per_folio(inode, folio);
> > > +   end_blk =3D (i_size_read(inode) - 1) >> inode->i_blkbits;
> > > +   end_blk =3D min(end_blk, i_blocks_per_folio(inode, folio) - 1);
> > > +
> > > +   while (start_blk <=3D end_blk) {
> > > +           start_blk =3D ifs_next_dirty_block(folio, start_blk, end_=
blk);
> > > +           if (start_blk > end_blk)
> > > +                   break;
> >
> > Use your new helper?
> >
> >               nblks =3D ifs_next_clean_block(folio, start_blk + 1,
> >                               end_blk) - start_blk?
> > > +           nblks++;
> > > +           start_blk++;
> > > +   }
> > > +
> > > +   return nblks * (block_size >> PAGE_SHIFT);
> >
> > I think this returns the number of dirty basepages in a given large
> > folio?  If that's the case then shouldn't this return long, like
> > folio_nr_pages does?
> >
> > > +}
> > > +
> > >  static unsigned ifs_find_dirty_range(struct folio *folio,
> > >             struct iomap_folio_state *ifs, u64 *range_start, u64 rang=
e_end)
> > >  {
> > > @@ -220,6 +245,58 @@ static void iomap_set_range_dirty(struct folio *=
folio, size_t off, size_t len)
> > >             ifs_set_range_dirty(folio, ifs, off, len);
> > >  }
> > >
> > > +static long iomap_get_range_newly_dirtied(struct folio *folio, loff_=
t pos,
> > > +           unsigned len)
> >
> > iomap_count_clean_pages() ?

Nice, a much clearer name.

I'll make the suggestions you listed above too, thanks for the pointers.

Thanks for taking a look at this, Darrick and Brian!
> >
> > --D
> >

