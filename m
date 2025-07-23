Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BD34C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 22:37:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46A466B0190; Wed, 23 Jul 2025 18:37:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 441956B0191; Wed, 23 Jul 2025 18:37:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37FDB6B0192; Wed, 23 Jul 2025 18:37:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 25B006B0190
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 18:37:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B9B7160232
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 22:37:16 +0000 (UTC)
X-FDA: 83696991672.09.FE8A561
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf18.hostedemail.com (Postfix) with ESMTP id C04661C000D
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 22:37:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="B/tqkPbs";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753310234; a=rsa-sha256;
	cv=none;
	b=7JsRnL5TGwh9hkZ5hSy1s+V9MDzRbZtFin/4/xARz+I5Cvq64VwuTfmbXkhRsLne6PHt1g
	KjaRwJW2IvkhEbEaad0h9/D3NTbxVi2US7S0gAQPUbzJRGgq+Ly2JTbIW3DAcgGZYf9QPW
	PKTqi5nShBQ0Su+TBTIZgGN+iX//fI4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="B/tqkPbs";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753310234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XT3gZgJcKjgQhhv2BAHSv1vm9Q9R1YzcsGLhzAhjs4M=;
	b=xPnrfAARL7QUsbkE5zWSfWnc1l4Y3vrYbBdPEuxbuIQw29YaQLPzJi2G/3UeIdzkJSHlbb
	cxvO68O7Rp8jDxcgoXbbEx4W426cdVtqDwU3q+TwWrohWlKccSpqPBqAL/d9cEfgpJXiVJ
	utlZKnV9P6WuDd/M2LBThilh9uqLA+w=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4ab39fb71dbso4565741cf.3
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 15:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753310234; x=1753915034; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XT3gZgJcKjgQhhv2BAHSv1vm9Q9R1YzcsGLhzAhjs4M=;
        b=B/tqkPbs+YwyQLK7fexQEM2mz97M+LfE/zB6UwdyuDOlLdDuR61J60ek4dFxAZFKHT
         U0K+5iT0eZFzwkyKmcGMCmNUmzylASIAQeiwg8XGYyBrUn/3y1r/kh9Ouw50Jm9oHiiu
         g+lDPi0DIYE3zcJUWesgEVBzE+TKYxCL9yOLQnPRkskLW6rCWfQMXGYogvQni6CRmD8i
         7dBiP/3PQJ/ykfxSXumS94rtQAznDaCH/CNhkqlOVoKyGhyONxKI6LOOFhqfKHAb5qTv
         amouYz5+CdxxBTerDGtP1oFBNsrcyrzEZp11NS/eyS4moGdDzQn4dCN1GzEdq40Run1Z
         mC4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753310234; x=1753915034;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XT3gZgJcKjgQhhv2BAHSv1vm9Q9R1YzcsGLhzAhjs4M=;
        b=ON5VoyuNCTkYyhKiF976pLuAAZ9SOmw0AjnK4p/meJPEkOlivhlDUVVEvq/8Law6qk
         2C77SA5AptJfSHHpeJ97qJVxCYxsVlHN/opgotUwrOYuUbTfCwCGoLy69G7RPz32nP62
         rah2gjerQPzuc5GXmtYgRWh7Cjg+Fx5441xYb4wuSUL+sEFR3Ji5mW8me7C6IxSOnLhN
         coeADZXhUEzPk/85lRvKInXHTifN3kr+N9JpTTIH/tf54afm+lh3B871vq8CILLSiEts
         j1gNHrToE3gZONNsKkZ2yoHz2j4ORepHXp80A+C8XruFFyi3N16n85usYyO94S2xTJKc
         dUoA==
X-Forwarded-Encrypted: i=1; AJvYcCXQoUkCKOLYjlvXzi+Tk4NwpEk5mbgGFcnI6dwFPzeCM81ptDzCcjWt96Y5exq0IktSqgJWfROBrQ==@kvack.org
X-Gm-Message-State: AOJu0YzzWK75P2Ae7McfoB5ifBAt+28cIvEs2FF6GOd9CWYNhgCNIl+3
	C6ZjtvEUOXcflGkXEPu9oViYr4hn56grwsNLWwBHHiMlKuPv2tIrXzR9AgxxOe+8QGbABlQnnYK
	JLTrfgtsFaNrK4ewc3jO/oUiNSkIp8q4=
X-Gm-Gg: ASbGncuY9hCf3oPopnh3NNYrytY3rLT+aNNc99DIhhsJ3uN1Wq3HOQ7J0GZRQMtFmql
	++SLI6PG0ez5peFoOX9U/zgboFkzmJx4X12Y6xdFUW4Vj6XWrIV5xWjNk57F98tl0VuldhmVvp/
	HkhAxS0D3hZjS26TCv0dRGmRjJAE/MV5rUuwqj+otchwxFkhY3BtCSdCHv2rhxKEluY7J8bvGIy
	dhCTHI=
X-Google-Smtp-Source: AGHT+IGOOacVYve6Wp+wqewcosy47JZTFuo3iGif5RJJGfqv8oqYJZjY5NKLG8Zii4YSxCooRAydaaLV3uIN+qEser8=
X-Received: by 2002:a05:622a:591:b0:4a9:c8e3:a38 with SMTP id
 d75a77b69052e-4ae6df7f8a5mr66874731cf.30.1753310233670; Wed, 23 Jul 2025
 15:37:13 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYs5AdVM-T2Tf3LciNCwLZEHetcnSkHsjZajVwwpM2HmJw@mail.gmail.com>
 <20250723144637.GW2672070@frogsfrogsfrogs> <CAJnrk1Z7wcB8uKWcrAuRAZ8B-f8SKnOuwtEr-=cHa+ApR_sgXQ@mail.gmail.com>
 <20250723212020.GY2672070@frogsfrogsfrogs>
In-Reply-To: <20250723212020.GY2672070@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 23 Jul 2025 15:37:02 -0700
X-Gm-Features: Ac12FXxB2nVp9FqI1vea6XZQcEtWGsAFL1VZb8QhxAb5VxOs6Ul814N4-7dsOH4
Message-ID: <CAJnrk1bFWRTGnpNhW_9MwSYZw3qPnPXZBeiwtPSrMhCvb9C3qg@mail.gmail.com>
Subject: Re: next-20250721 arm64 16K and 64K page size WARNING fs fuse file.c
 at fuse_iomap_writeback_range
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, linux-fsdevel@vger.kernel.org, 
	linux-mm <linux-mm@kvack.org>, linux-xfs@vger.kernel.org, 
	open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org, 
	Linux Regressions <regressions@lists.linux.dev>, Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Christian Brauner <brauner@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <liam.howlett@oracle.com>, 
	Arnd Bergmann <arnd@arndb.de>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Anders Roxell <anders.roxell@linaro.org>, Ben Copeland <benjamin.copeland@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: a7zca61bes695r9hkfjpxhotwdj9p3ym
X-Rspam-User: 
X-Rspamd-Queue-Id: C04661C000D
X-Rspamd-Server: rspam02
X-HE-Tag: 1753310234-488315
X-HE-Meta: U2FsdGVkX18t0Ip67gWicXuqev8nbR42e+tx/9x1UBJl2Im2BS3X4p/n5BNo4Q7ixMOztU8ZTXq7AmL2Xx4zATUORAYwp6qjYP60vlIyorAoyBmhOuNYN1sB+AcZf7l3EPER4+dD6VLqqBkf0oU9/PjiDa2j6EZdZE2gtmtcva0/X1J6RXZqfsxo/i6OerLnSLiBqItU5ghO6hyN7a8AgtkY8ufme1nkWTPnYrcu07+srAv75HqJ7iPHirixAlqFTqlwM7Z7h7wZlmPiOMsyA+vFeZpFYRBAGSHwihswgqd2kOMORjK0pTF4x/FSR53C8fKhHV2FHH5iQIoEiadxsDZ+lHEMP7i/WM68BL0pqIvf2lGzc9JcEq1vX054EIRLQbY0dVLlQzLlkIoizWclQtmFF993W9IolTFelWtEf/wbHXclmaTxRTY8jQ6+OYcKDxfBL+eOwc3Qqm96+hEs4liY6MvYsNzI7n8l0n8rIRCsrC5E7uqir4JmNzzm/Ch3zZSj3moz/yF1qVWLly4X9TL8zmiVgspjfYs7kCDtC/d5X0wL8ou8vFuaj9OBSQtu++yOBgsjtDwOX1LHfNzMRXbYa6IK5TRZRhJ4RgYwNL1TGBEWmi9iAwQkMDWvVIf3jYFEXN8lzyk7I3f6emuAw+g6XRzltLOsrM85cwiKAPXYKq3mo82wxiF8OSL436/yQiAqsOswv1JUtKpPOfjIGLbZifetiD3eaUQk3w9C2sBe7BLarKfwgw7oSwtbnszpXDHkI6FLNwTGWWVw6fkjYuONIHa33yVSjHOoibDNYbxAjJmxRN3H5iJ9eXEpVsT9krDTo+yUx+0/DX9eICX2hp3T4TRcsPAjHTnBcKZu1SVQepLfvsbSAuREea4mMxHHn6bIEB9C0hPb+ySyUjChbZD0F6m89dz0Rsh7w+zWfloaLviYUh1TJwlek3iZI02JwX/7as02AEC3PdMHfhE
 5U9tYNkN
 epDNurBMxnVgXu9UUeOQ/hV7MdY10zpOngokM8aOrfr2xttlqAyt9U0x9jZTV/2FEn27Ea4Oo3EdxMxDww2il04P1lsWIdweosm9WQdD7wcT0kQwOPqN2Qw18YpoQeKMdrVQ43DTtNCYYnjQxNkibiEaLHElwSkDbGSZ8UGhTmBjbS/Pj4FdvY5p8mY7D3nBjQaStYfwTMGzxM3BJQaMegwNuBNcynd3mYfRunlVrJVdCVCbY0Zz+sC4S8HeueOSwJKtR69tZy+bTp2lB8bV/iBuRAwsDL25mby2lNyfKlV/1dlk9gNwNRCgpIKwEuOLgbRrirw5GHFpBf6mq5v6PS822TlpY8eLeoAJOWQNpj7EvJjf79VOkW7A5HKSIZP/Fx0yOmtoYDoqhFiGNYMlEED1RwceOsDRqNtoDYqGVGdmbk/oPThDgkoZBn1dkAJArDwGvuQ10HL0Ano/mtg4IAPvfLRiiL/TKTzgPSx2vK7+4vwSeZZIq1gKXpUrYmqJFFOJGiqZffJZEtDc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 2:20=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Wed, Jul 23, 2025 at 11:42:42AM -0700, Joanne Koong wrote:
> > On Wed, Jul 23, 2025 at 7:46=E2=80=AFAM Darrick J. Wong <djwong@kernel.=
org> wrote:
> > >
> > > [cc Joanne]
> > >
> > > On Wed, Jul 23, 2025 at 05:14:28PM +0530, Naresh Kamboju wrote:
> > > > Regressions found while running LTP msync04 tests on qemu-arm64 run=
ning
> > > > Linux next-20250721, next-20250722 and next-20250723 with 16K and 6=
4K
> > > > page size enabled builds.
> > > >
> > > > CONFIG_ARM64_64K_PAGES=3Dy ( kernel warning as below )
> > > > CONFIG_ARM64_16K_PAGES=3Dy ( kernel warning as below )
> > > >
> > > > No warning noticed with 4K page size.
> > > > CONFIG_ARM64_4K_PAGES=3Dy works as expected
> > >
> > > You might want to cc Joanne since she's been working on large folio
> > > support in fuse.
> > >
> > > > First seen on the tag next-20250721.
> > > > Good: next-20250718
> > > > Bad:  next-20250721 to next-20250723
> >
> > Thanks for the report. Is there a link to the script that mounts the
> > fuse server for these tests? I'm curious whether this was mounted as a
> > fuseblk filesystem.
> >
> > > >
> > > > Regression Analysis:
> > > > - New regression? Yes
> > > > - Reproducibility? Yes
> > > >
> > > > Test regression: next-20250721 arm64 16K and 64K page size WARNING =
fs
> > > > fuse file.c at fuse_iomap_writeback_range
> > > >
> > > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > > >
> > > > ## Test log
> > > > ------------[ cut here ]------------
> > > > [  343.828105] WARNING: fs/fuse/file.c:2146 at
> > > > fuse_iomap_writeback_range+0x478/0x558 [fuse], CPU#0: msync04/4190
> > >
> > >         WARN_ON_ONCE(len & (PAGE_SIZE - 1));
> > >
> > > /me speculates that this might be triggered by an attempt to write ba=
ck
> > > some 4k fsblock within a 16/64k base page?
> > >
> >
> > I think this can happen on 4k base pages as well actually. On the
> > iomap side, the length passed is always block-aligned and in fuse, we
> > set blkbits to be PAGE_SHIFT so theoretically block-aligned is always
> > page-aligned, but I missed that if it's a "fuseblk" filesystem, that
> > isn't true and the blocksize is initialized to a default size of 512
> > or whatever block size is passed in when it's mounted.
>
> <nod> I think you're correct.
>
> > I'll send out a patch to remove this line. It doesn't make any
> > difference for fuse_iomap_writeback_range() logic whether len is
> > page-aligned or not; I had added it as a sanity-check against sketchy
> > ranges.
> >
> > Also, I just noticed that apparently the blocksize can change
> > dynamically for an inode in fuse through getattr replies from the
> > server (see fuse_change_attributes_common()). This is a problem since
> > the iomap uses inode->i_blkbits for reading/writing to the bitmap. I
> > think we will have to cache the inode blkbits in the iomap_folio_state
> > struct unfortunately :( I'll think about this some more and send out a
> > patch for this.
>
> From my understanding of the iomap code, it's possible to do that if you
> flush and unmap the entire pagecache (whilst holding i_rwsem and
> mmap_invalidate_lock) before you change i_blkbits.  Nobody *does* this
> so I have no idea if it actually works, however.  Note that even I don't
> implement the flush and unmap bit; I just scream loudly and do nothing:

lol! i wish I could scream loudly and do nothing too for my case.

AFAICT, I think I just need to flush and unmap that file and can leave
the rest of the files/folios in the pagecache as is? But then if the
file has active refcounts on it or has been pinned into memory, can I
still unmap and remove it from the page cache? I see the
invalidate_inode_pages2() function but my understanding is that the
page still stays in the cache if it has has active references, and if
the page gets mmaped and there's a page fault on it, it'll end up
using the preexisting old page in the page cache.

I don't think I really need to have it removed from the page cache so
much as just have the ifs state for all the folios in the file freed
(after flushing the file) so that it can start over with a new ifs.
Ideally we could just flush the file, then iterate through all the
folios in the mapping in order of ascending index, and kfree their
->private, but I'm not seeing how we can prevent the case of new
writes / a new ifs getting allocated for folios at previous indexes
while we're trying to do the iteration/kfreeing.

>
> void fuse_iomap_set_i_blkbits(struct inode *inode, u8 new_blkbits)
> {
>         trace_fuse_iomap_set_i_blkbits(inode, new_blkbits);
>
>         if (inode->i_blkbits =3D=3D new_blkbits)
>                 return;
>
>         if (!S_ISREG(inode->i_mode))
>                 goto set_it;
>
>         /*
>          * iomap attaches per-block state to each folio, so we cannot all=
ow
>          * the file block size to change if there's anything in the page =
cache.
>          * In theory, fuse servers should never be doing this.
>          */
>         if (inode->i_mapping->nrpages > 0) {
>                 WARN_ON(inode->i_blkbits !=3D new_blkbits &&
>                         inode->i_mapping->nrpages > 0);
>                 return;
>         }
>
> set_it:
>         inode->i_blkbits =3D new_blkbits;
> }
>
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/comm=
it/?h=3Dfuse-iomap-attrs&id=3Dda9b25d994c1140aae2f5ebf10e54d0872f5c884
>
> --D
>
> >
> > Thanks,
> > Joanne
> >

