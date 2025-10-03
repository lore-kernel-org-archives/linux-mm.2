Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66F5ACCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 22:28:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AA1F8E0005; Fri,  3 Oct 2025 18:28:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75A498E0002; Fri,  3 Oct 2025 18:28:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66FCF8E0005; Fri,  3 Oct 2025 18:28:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 540D28E0002
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 18:28:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CD7DBC05AD
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 22:28:10 +0000 (UTC)
X-FDA: 83958242340.27.6C1004B
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1EBDC20011
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 22:28:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mc9rYo4w;
	spf=pass (imf03.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759530489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GsrTjFioBDXPrtMuXAmVmhBbhuBxugl8WE75QZEEBM8=;
	b=NKaHfs0hOrFyoIksfCJlskVyDb0nbDbrpq6px8RAiEkhD2uobCtA7KVKqXM1iGs/F+9vqt
	SHSumNxcMzjGsF+7TmGknz31NP/r25E584ks7/E2Jsa0vPCDfKhXRhyP+iaCe3HgByz3JP
	viCWY/NiSeI8IGgTfkxe+lnUPiNRFPY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mc9rYo4w;
	spf=pass (imf03.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759530489; a=rsa-sha256;
	cv=none;
	b=mnMmx6u9DvKBLwMxR4mYFORSYWYohwHLy7QU9iwRIopYtCbAPEHKnOD1UZtKzWo0MsDuFK
	Lh7uSUkktDUW/qYCokGY6bdn0oxxlezlI1KnSOeRMii2TEfostnm6C9ouwq7ti1eTv3ake
	hgj6CjcX6zKxHhB9trpWOLbV+RcEoDM=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4ddabf2ada5so40845501cf.1
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 15:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759530488; x=1760135288; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GsrTjFioBDXPrtMuXAmVmhBbhuBxugl8WE75QZEEBM8=;
        b=mc9rYo4wN8JgjtMMM3/uAAYg+WEacn1h2vNikItCV4NSpxvosq4EZb9aYDX1O4EhST
         NFppQyRtVNUurKUWB3hNtvny8g2+aCjSiXyHukB1zrRwuSMTxsBj8OGZRcAD5ZE3SwY2
         YdvS5o42YNi5xAc2jXYKUd9scFUAv/9HftdIdPlIoJOoKsbXh4Vt6cJWPCrHaXNlepHA
         vh7fsK2RvUCjBsps+K6QkTBBL57VDl5FhVB7qkFVF1zRyIrsbjlGr07ofPF1lNacN1Wh
         XyD0iaHkcW+WJGHDBMhF545qsHOJa/zRKn20tS5/YsdDCpA0Ppd0V3r+VRTvHykuJ9cJ
         R9MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759530488; x=1760135288;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GsrTjFioBDXPrtMuXAmVmhBbhuBxugl8WE75QZEEBM8=;
        b=sxjnWEYqDcivVhHzwNIly14r9MQDbAg4WUzLzmY5UzDeMVwk15bEueltSedtnUhU2w
         L/cOT3goH6GHI0CIe6GBhkYrAPCozidpL3sEsImlvrcYNLNxiA7UZOJv6BVNQUExk5bP
         eeIy/MC7I6GtXNbS+JbZFumPXThofEfUpOz++VFC0uyxqy2Gdnnr5lqOV6NkOPA+YZ+r
         9g4sb4d0K1sD1zoYsZ1h5RQlTjRfAIdciCM+W/K3R4AfwwT7crkKpAQ2+nNBUiocbJgr
         7La9ldFlSsZKa3oehjuDHVwtNC3ETlo61+3Hl2xFuWhiAU7e1A3ovv0kT1E9E56hlHKB
         VUlg==
X-Forwarded-Encrypted: i=1; AJvYcCVt3e14m+MQetQNdvIOK5GwEZ0cCogKVAVjyxM/lFFm2a6zAKo4V9zBGX1hJOuULQMWfIxJjTlGuQ==@kvack.org
X-Gm-Message-State: AOJu0YyCBScJkvg4UmkgMiL/Vj5qEDbb/yM4+URGpRyq6e2/AIqNS3Cp
	j6v5OKDeFUK9CPIyCglzrSNFQNPOtBS2fSYfdbj4fdQsQ3ovvNILU1L6Q8jWIx5F6r8uI5sBB+N
	2k0LC8AccXRZdNFWVGcksHRPGvwAZi6U=
X-Gm-Gg: ASbGncuJAIa0Lbgego7mNXRPufSJ/Zp2OvD+ewJn2H0p7Fu9pJ8Pgq45Dq4IwqcfQmv
	jv4v8Ick4am/r0Rg2qB7wqM19qdY7+nKo9m2ebYB1LVvqY2QgVwrqcBkMdX3tdw0PYqQ2tFlmui
	rmYrWiqILuFvARr9AYbPW42p4jbvA9L0GObW5z4Mj60qxfodJ7fTBSjA2HKFImpuojc2Fi8b7gF
	l6+D92v2dgvp27Clf9y1yrv8jgAGMLqh6ctvg6XoTkt8bzs8IA/cNV2Ep1235BllbGzbJGHAw==
X-Google-Smtp-Source: AGHT+IEZXwB540cqRy8ufe9EvtDcaXb1ZxNBsYiEfhRvJvMgYSfsbmIjKWzMnu3HjZAnRxDOgf8vaW0o0avV6CEzCVs=
X-Received: by 2002:a05:622a:728d:b0:4dd:7572:216f with SMTP id
 d75a77b69052e-4e57e29e758mr27614521cf.32.1759530488122; Fri, 03 Oct 2025
 15:28:08 -0700 (PDT)
MIME-Version: 1.0
References: <20250829233942.3607248-1-joannelkoong@gmail.com>
 <20250829233942.3607248-11-joannelkoong@gmail.com> <aLiOrcetNAvjvjtk@bfoster> <20250903195913.GI1587915@frogsfrogsfrogs>
In-Reply-To: <20250903195913.GI1587915@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 3 Oct 2025 15:27:57 -0700
X-Gm-Features: AS18NWDO6cSZMS7k5N8NjuFZJ24A4w4G8fBvn2duyG_c1N7JYvgnUloVpDvQoYo
Message-ID: <CAJnrk1ZT8w6p3Mnqx8R3dWUF1NFOYT95tkKFq5LGcS4=01fGsg@mail.gmail.com>
Subject: Re: [PATCH v2 10/12] iomap: refactor dirty bitmap iteration
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Brian Foster <bfoster@redhat.com>, linux-mm@kvack.org, brauner@kernel.org, 
	willy@infradead.org, jack@suse.cz, hch@infradead.org, jlayton@kernel.org, 
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1EBDC20011
X-Stat-Signature: zhgfcr3uokttqertqobik3tjjeb85tjm
X-HE-Tag: 1759530488-544609
X-HE-Meta: U2FsdGVkX185XqjB5tAPxDtEqDzDXm6gpkdMUVwnGUdC8LWcBsZfNZmAEIvnzilT9T1YQIxxoWQuBcfTDzzrnhKauchDALEggay3GmlKcC4hVr3X5MmTXluMBxxkgVHOqLqMaD+e3GSs5yuEsTjdvr1I5+G7wovL4nyy7eyYEX25Bb0HyW0++ob5OnsivC4u5KnSMyobPe18zIl9RJx6sNf7COakAle54CcxvamShKuBFzUnl8JEoKxiH+Ypu8vmel3DwU8hwXdNkEIcmRaJ0kbqIy3stCB4MhoimHCKbBkDR44FvWzRHrPAzgieuGcSKRZwZ7a2KcauhbCD5l+8ET8to0ys7otNv2RRKo7rNxe+a+kpWUXUBAUmVH9aVg2HJLbBlEU6dYtSNAjaf4GEso58WbfG3FWlybceWdAAnasEgtELNZ1SxcjWe6GQjCa9l8CBrhhyNMt1dh9nVbhgI1qwFZwVrKq5AamFLxh0iYIFN8BatSR+gawWXs5X44CSsS4DBoEpk7hXq4sOBZeyFAEDUh5WT7kYJXVZSB6NvshnLzIjZ92PGwKrHEg897iTlFyEuRDIw6auCIxjEebkrWrQvN7ebBsh1zwbnJsgCwzB1O5NYOEiKsGoOmM148/YCOVcRr9BjtwKSd/tHEXEdItLDN5NIgC9KBPsgUNy19GFo/GGcUR4py3XH//F6dLJioG0IvEspaTfVr2QXIT9rHJtIhB93qObQYjVFGgJ/JU6VZ/vXBSwb+OJK9jyAjPAbDFKyRsUMuMfqRNPs+BtvWIeIwyO7F/USkRptgIjssLQWn5eczbh2ARJYV8tTgcCIplR9CfEswQhdlWF31gBfCXjqEeD6dvo2cGbAQDV2gg8t96nhhaVULye2a0KpQU8IV4ql8bwYZ3eFZkyp3T9sH4f+G0qBsikZFX0Iv77YCjIPzbUPXuHaFbdVomAhmRdkCS7NUAC+bitdlN9rey
 SmUbM1Ml
 kTUoaVtBlKVop9j8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 3, 2025 at 12:59=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Wed, Sep 03, 2025 at 02:53:33PM -0400, Brian Foster wrote:
> > On Fri, Aug 29, 2025 at 04:39:40PM -0700, Joanne Koong wrote:
> > > Use find_next_bit()/find_next_zero_bit() for iomap dirty bitmap
> > > iteration. This uses __ffs() internally and is more efficient for
> > > finding the next dirty or clean bit than manually iterating through t=
he
> > > bitmap range testing every bit.
> > >
> > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > Suggested-by: Christoph Hellwig <hch@infradead.org>
> > > ---
> > >  fs/iomap/buffered-io.c | 67 ++++++++++++++++++++++++++++++----------=
--
> > >  1 file changed, 48 insertions(+), 19 deletions(-)
> > >
> > > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > > index fd827398afd2..dc1a1f371412 100644
> > > --- a/fs/iomap/buffered-io.c
> > > +++ b/fs/iomap/buffered-io.c

Sorry for the late reply on this, I didn't realize you and Brian had
commented on this.

I'm going to pull this and the next patch (the uptodate bitmap
refactoring one) out of this series and put them instead on top of
this other patchset that does some other optimizations.

> > >
> > >  static unsigned ifs_find_dirty_range(struct folio *folio,
> > > @@ -92,18 +121,15 @@ static unsigned ifs_find_dirty_range(struct foli=
o *folio,
> > >             offset_in_folio(folio, *range_start) >> inode->i_blkbits;
> > >     unsigned end_blk =3D min_not_zero(
> > >             offset_in_folio(folio, range_end) >> inode->i_blkbits,
> > > -           i_blocks_per_folio(inode, folio));
> > > -   unsigned nblks =3D 1;
> > > +           i_blocks_per_folio(inode, folio)) - 1;
> > > +   unsigned nblks;
> > >
> > > -   while (!ifs_block_is_dirty(folio, ifs, start_blk))
> > > -           if (++start_blk =3D=3D end_blk)
> > > -                   return 0;
> > > +   start_blk =3D ifs_next_dirty_block(folio, start_blk, end_blk);
> > > +   if (start_blk > end_blk)
> > > +           return 0;
> > >
> > > -   while (start_blk + nblks < end_blk) {
> > > -           if (!ifs_block_is_dirty(folio, ifs, start_blk + nblks))
> > > -                   break;
> > > -           nblks++;
> > > -   }
> > > +   nblks =3D ifs_next_clean_block(folio, start_blk + 1, end_blk)
> > > +           - start_blk;
> >
> > Not a critical problem since it looks like the helper bumps end_blk, bu=
t
> > something that stands out to me here as mildly annoying is that we chec=
k
> > for (start > end) just above, clearly implying that start =3D=3D end is
> > possible, then go and pass start + 1 and end to the next call. It's not
> > clear to me if that's worth changing to make end exclusive, but may be
> > worth thinking about if you haven't already..

My thinking with having 'end' be inclusive is that it imo makes the
interface a lot more intuitive.

For example, for
    next =3D ifs_next_clean_block(folio, start, end);

with end being inclusive, then nothing in that range is clean if next > end
Whereas with end being exclusive, that's only true if next >=3D end,
which imo is more confusing.

If you and Darrick still much prefer having end be exclusive though,
then I'm happy to make that change.

>
> <nod> I was also wondering if there were overflow possibilities here.

I'm not sure what you had in mind for what would overflow, the end_blk
being beyond the end of the bitmap? The
find_next_bit()/find_next_zero_bit() interfaces protect against that.
Or maybe you're referring to something else?

>
> > Brian
> >
> > >
> > >     *range_start =3D folio_pos(folio) + (start_blk << inode->i_blkbit=
s);
> > >     return nblks << inode->i_blkbits;
> > > @@ -1077,7 +1103,7 @@ static void iomap_write_delalloc_ifs_punch(stru=
ct inode *inode,
> > >             struct folio *folio, loff_t start_byte, loff_t end_byte,
> > >             struct iomap *iomap, iomap_punch_t punch)
> > >  {
> > > -   unsigned int first_blk, last_blk, i;
> > > +   unsigned int first_blk, last_blk;
> > >     loff_t last_byte;
> > >     u8 blkbits =3D inode->i_blkbits;
> > >     struct iomap_folio_state *ifs;
> > > @@ -1096,10 +1122,13 @@ static void iomap_write_delalloc_ifs_punch(st=
ruct inode *inode,
> > >                     folio_pos(folio) + folio_size(folio) - 1);
> > >     first_blk =3D offset_in_folio(folio, start_byte) >> blkbits;
> > >     last_blk =3D offset_in_folio(folio, last_byte) >> blkbits;
> > > -   for (i =3D first_blk; i <=3D last_blk; i++) {
> > > -           if (!ifs_block_is_dirty(folio, ifs, i))
> > > -                   punch(inode, folio_pos(folio) + (i << blkbits),
> > > -                               1 << blkbits, iomap);
> > > +   while (first_blk <=3D last_blk) {
> > > +           first_blk =3D ifs_next_clean_block(folio, first_blk, last=
_blk);
> > > +           if (first_blk > last_blk)
> > > +                   break;
>
> I was wondering if the loop control logic would be cleaner done as a for
> loop and came up with this monstrosity:
>
>         for (first_blk =3D ifs_next_clean_block(folio, first_blk, last_bl=
k);
>              first_blk <=3D last_blk;
>              first_blk =3D ifs_next_clean_block(folio, first_blk + 1, las=
t_blk)) {
>                 punch(inode, folio_pos(folio) + (first_blk << blkbits),
>                       1 << blkbits, iomap);
>         }
>
> Yeah.... better living through macros?
>
> #define for_each_clean_block(folio, blk, last_blk) \
>         for ((blk) =3D ifs_next_clean_block((folio), (blk), (last_blk));
>              (blk) <=3D (last_blk);
>              (blk) =3D ifs_next_clean_block((folio), (blk) + 1, (last_blk=
)))
>
> Somewhat cleaner:
>
>         for_each_clean_block(folio, first_blk, last_blk)
>                 punch(inode, folio_pos(folio) + (first_blk << blkbits),
>                       1 << blkbits, iomap);
>

Cool, this macro looks nice! I'll use this in the next version.

Thanks,
Joanne

> <shrug>
>
> --D
>

