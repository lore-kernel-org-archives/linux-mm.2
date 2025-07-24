Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D604C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 19:14:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFDF48E00B6; Thu, 24 Jul 2025 15:14:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E874B8E007C; Thu, 24 Jul 2025 15:14:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4F9F8E00B6; Thu, 24 Jul 2025 15:14:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C42DD8E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 15:14:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 91FAFB9EFD
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:14:25 +0000 (UTC)
X-FDA: 83700109290.20.62C0CB2
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id E57F7100004
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:14:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G6yIJGbP;
	spf=pass (imf14.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753384463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2jOSnyBDxczFG/IHSIdGMkE63XZ2hP+zlYXbjMuUNLc=;
	b=vH9T5mjqTMJgNktiAHKLqU7BmSWhu6hqshuZ9HY3PzdzW+Lzfy24ClykPynBSh42vyEw7f
	YiG/zYFs++Ky628y2Nu81u8N7rKVBbtxXpBHowiDDecyuIsuT7gmtnCfn3CS1rfypam3mE
	c5aknPwtUfdGP5rWwo86Q5oA1gGTk3I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753384463; a=rsa-sha256;
	cv=none;
	b=6voFKF506AOEXl3gYrfGv4vZbU4FfhEDL1aLrWq1/rslRPMXTNkeJAyFRoVV1LAKfSpdf1
	essE4kjSfLqH8qUF8hBcLYG86ob43J+af6JBXE1Bi1i2b2yVVUyY1DBgvkD3IxF1untYXd
	Akhxdw0KWyH7krvz3+Y0FVVA8rY6IqE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G6yIJGbP;
	spf=pass (imf14.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ab82eb3417so14086201cf.2
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 12:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753384463; x=1753989263; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2jOSnyBDxczFG/IHSIdGMkE63XZ2hP+zlYXbjMuUNLc=;
        b=G6yIJGbPPsiVGN5PRCjGbd3ZB3RiENQ45aTBzYPfJ9JUUHzD4YiI7PkV+0S89453S7
         IqYD0/iTubK456VtJ9ARtN0LfzBcH2HUw+RZuwK6z5Av0NE3IepIcYkA5gLrBmaIG/Tw
         mjTZl5PZdOja4hVR8urvPyedVkd1d6XjgGIGGMr2DrlTP5rA8kppMuVH3GzkjunvbYyX
         /us6wNCGGn0YNFgN0gSi9c1W7VxTb2qm9MSkLWw+0UArfespE1K/lduW3trzIreuRI3X
         gvgsrtw6I8tQUDTboGJj7twbS4QHt3JdYjjczlar8xig5MDLbrkKiLHANq5SW5E1BOVl
         5keQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753384463; x=1753989263;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2jOSnyBDxczFG/IHSIdGMkE63XZ2hP+zlYXbjMuUNLc=;
        b=AI6IqgmwYD0o1rno/ll2Fum1XFLZrxmCVwngk8pcYkx+b5+EyraC7AckE3Ful/ftJw
         eLj/2OpLpNfzNpIV0bUbPhFZOzp+YvdUVmI4Ud3P/F4vXEfxlqGO5CBm0HABOw2aMIZp
         NbKtESE9O4B5kcykoDD8DLgazEZC0zlAhOSb5317+ayh+kM9s0M6krSy2JiNqiXTl+2d
         LmOTn2EAHrIKEFjGyP/+SbMmOyIzZV1UXwiES6tgL8AqnEd0sntq2j9d7uNGI2CQ2qbF
         kgAP0G3kP8Comf7vEJhtz4DxdUVAYB1rSfXzMBLHEquVIuknp9r5wWdjARkXH1OhyzRo
         dV8w==
X-Forwarded-Encrypted: i=1; AJvYcCWrXvH8GjiPEpUsJ+geSGT2WMc67aw0urMW//mPLT0Gl4hSveZ2yEpnqpTdI2FjPGXFY9226n8ikw==@kvack.org
X-Gm-Message-State: AOJu0YyJZGVinxJVF3NanOGpiyZ1I5Aboxs5trE2M89twO85Uu9qkTBa
	yjoVSRj/H1Sjlc8WqvoCYDVqAT09ykh/nzph1njMmF+Wx9n+wxjoJ56KeOkkYCqtmZqvlX/Os7/
	CjW/V03kg3DPMrYV5ZPTwA6Z4RvLsUAA=
X-Gm-Gg: ASbGncu1qaGiq51zzUO7+1o93BgsggPsUYFQXqn/XLbgRxZF3DqpIcPy979xE+WrZpJ
	0YaujnkfUYpwNV5wyeTnUoj2LNK91MHgqiIvSGW2RFfm5Vxkffy9duPjaSgLJrcPIIkB31n7nmX
	aU/UAZhg1eScdcbajfd8g8rkrOoWThOq0v3FrBXDVLqGRB02XBTQKfPNQIMYFUONj69hzVx5fPu
	NjbyMk=
X-Google-Smtp-Source: AGHT+IGm06QE4HAxdtDrbkTCJlc3WBllGjE2CLQfWltUi2scOuGwGhLY9rcqQVvFXqhFOXNUBQN8GPgnjRiXL0ZxnAk=
X-Received: by 2002:a05:622a:2486:b0:4ab:db27:4775 with SMTP id
 d75a77b69052e-4ae6e0370b9mr94057441cf.54.1753384462745; Thu, 24 Jul 2025
 12:14:22 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYs5AdVM-T2Tf3LciNCwLZEHetcnSkHsjZajVwwpM2HmJw@mail.gmail.com>
 <20250723144637.GW2672070@frogsfrogsfrogs> <CAJnrk1Z7wcB8uKWcrAuRAZ8B-f8SKnOuwtEr-=cHa+ApR_sgXQ@mail.gmail.com>
 <20250723212020.GY2672070@frogsfrogsfrogs> <CAJnrk1bFWRTGnpNhW_9MwSYZw3qPnPXZBeiwtPSrMhCvb9C3qg@mail.gmail.com>
In-Reply-To: <CAJnrk1bFWRTGnpNhW_9MwSYZw3qPnPXZBeiwtPSrMhCvb9C3qg@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 24 Jul 2025 12:14:10 -0700
X-Gm-Features: Ac12FXzB5jWOM2jLEHuea3HtXx8QVU4kwGFHqdvioSKikDPZlGiijO3gRX8BQys
Message-ID: <CAJnrk1byTVJtuOyAyZSVYrusjhA-bW6pxBOQQopgHHbD3cDUHw@mail.gmail.com>
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
X-Rspamd-Queue-Id: E57F7100004
X-Stat-Signature: 97bhjqm5urbeps9fdpq8gb6nufuhx5uf
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753384463-565796
X-HE-Meta: U2FsdGVkX18nKclRrhVXKV4+qPsX/lXYYa7+0lyCTymjVmY5saO1NMXQptmF53nruEKKz9gwl/ICZjje1s5sRJ5UXBtHUP8KxB37bgYxKLHG8gsndhjX1l0WMIITwnj4zzQUVxqcwwzLTUtkSlsk//R3a/juD6fMIIM6ovaQGf3QxDQ1V8d4rtqsdVzwtCUy3IBMaP2xtu/cG1WDUJBHKc3t1O9XxsOPlUuBUvVZPArtxMhd1PStdqdn7UJ0dfxOmxXCBKidJqHFo+17B6b3HiBF4OMaPVAChyqxWpy7JD5lL+TphOetXNT67Bv1uMxd/3ZABCXZ2XyX72vkLJGrq3ZRAg+v0euZ3Y1mIgMXY82YG5MlHh7eizHFVVNmVYNyym3PB115e+KeS3rF0NjnHSQk3YHfM+qpm4IIsoNRZMwAYKXFis/FFJ1XtTl0jxpX464BeGvm/pmLBasLqFmIwkbovZQvHINENDqhtmA+gdAKCbDOTO6uCHX/EBk107S+DUM+y0Dllc/MwLA3hAuki7LGLU2ZY6U7ukn7QPsjnuCCRDybJItbmf9orphlaW3I6MpZjpN2ZdBnaZ6WGM7eZdDSFv+pLBsm5fBRThJIapuAqEXfKRUcNFwXiojsMg1SrG8pEX74BlEeKexctjQYglUNWNgB1170ee9eEkpH3yy5w4vGpJoWQtGy7eLFuaLljzr4wRJRSCtdHRmHqFMXpX6GaO0odbFzirYzBipqkJXPX4KHcK0Aux9/9KcvWgPBhPn8fKmsGQvDL8fbQ58fM+vy82kM93XnDMIYgGRt7rYDpP5y1/BdbbK9fa6XX4JrNqTKSO7lk+U5q/1Vo2INpD/Bo5pg3mDEGDoiMfb1FGZB+8KR+2C8G1GiI77QzgcseUzTjgzfYdxVc2wcWHm+sTfVb2fS0rM+rZvkxDD/L3QSL9qjLyd29XSfdzFprbVhqaksVvoWrRtBUG5lCcM
 ipnUoYVH
 udbnjK8ImH0UFktykn2QaNSN6R8x2tf6zAAYR+nPZo/YbTa3WWKN4IMzPtUzI2rvLdNd9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 3:37=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> On Wed, Jul 23, 2025 at 2:20=E2=80=AFPM Darrick J. Wong <djwong@kernel.or=
g> wrote:
> >
> > On Wed, Jul 23, 2025 at 11:42:42AM -0700, Joanne Koong wrote:
> > > On Wed, Jul 23, 2025 at 7:46=E2=80=AFAM Darrick J. Wong <djwong@kerne=
l.org> wrote:
> > > >
> > > > [cc Joanne]
> > > >
> > > > On Wed, Jul 23, 2025 at 05:14:28PM +0530, Naresh Kamboju wrote:
> > > > > Regressions found while running LTP msync04 tests on qemu-arm64 r=
unning
> > > > > Linux next-20250721, next-20250722 and next-20250723 with 16K and=
 64K
> > > > > page size enabled builds.
> > > > >
> > > > > CONFIG_ARM64_64K_PAGES=3Dy ( kernel warning as below )
> > > > > CONFIG_ARM64_16K_PAGES=3Dy ( kernel warning as below )
> > > > >
> > > > > No warning noticed with 4K page size.
> > > > > CONFIG_ARM64_4K_PAGES=3Dy works as expected
> > > >
> > > > You might want to cc Joanne since she's been working on large folio
> > > > support in fuse.
> > > >
> > > > > First seen on the tag next-20250721.
> > > > > Good: next-20250718
> > > > > Bad:  next-20250721 to next-20250723
> > >
> > > Thanks for the report. Is there a link to the script that mounts the
> > > fuse server for these tests? I'm curious whether this was mounted as =
a
> > > fuseblk filesystem.
> > >
> > > > >
> > > > > Regression Analysis:
> > > > > - New regression? Yes
> > > > > - Reproducibility? Yes
> > > > >
> > > > > Test regression: next-20250721 arm64 16K and 64K page size WARNIN=
G fs
> > > > > fuse file.c at fuse_iomap_writeback_range
> > > > >
> > > > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > > > >
> > > > > ## Test log
> > > > > ------------[ cut here ]------------
> > > > > [  343.828105] WARNING: fs/fuse/file.c:2146 at
> > > > > fuse_iomap_writeback_range+0x478/0x558 [fuse], CPU#0: msync04/419=
0
> > > >
> > > >         WARN_ON_ONCE(len & (PAGE_SIZE - 1));
> > > >
> > > > /me speculates that this might be triggered by an attempt to write =
back
> > > > some 4k fsblock within a 16/64k base page?
> > > >
> > >
> > > I think this can happen on 4k base pages as well actually. On the
> > > iomap side, the length passed is always block-aligned and in fuse, we
> > > set blkbits to be PAGE_SHIFT so theoretically block-aligned is always
> > > page-aligned, but I missed that if it's a "fuseblk" filesystem, that
> > > isn't true and the blocksize is initialized to a default size of 512
> > > or whatever block size is passed in when it's mounted.
> >
> > <nod> I think you're correct.
> >
> > > I'll send out a patch to remove this line. It doesn't make any
> > > difference for fuse_iomap_writeback_range() logic whether len is
> > > page-aligned or not; I had added it as a sanity-check against sketchy
> > > ranges.
> > >
> > > Also, I just noticed that apparently the blocksize can change
> > > dynamically for an inode in fuse through getattr replies from the
> > > server (see fuse_change_attributes_common()). This is a problem since
> > > the iomap uses inode->i_blkbits for reading/writing to the bitmap. I
> > > think we will have to cache the inode blkbits in the iomap_folio_stat=
e
> > > struct unfortunately :( I'll think about this some more and send out =
a
> > > patch for this.
> >
> > From my understanding of the iomap code, it's possible to do that if yo=
u
> > flush and unmap the entire pagecache (whilst holding i_rwsem and
> > mmap_invalidate_lock) before you change i_blkbits.  Nobody *does* this
> > so I have no idea if it actually works, however.  Note that even I don'=
t
> > implement the flush and unmap bit; I just scream loudly and do nothing:
>
> lol! i wish I could scream loudly and do nothing too for my case.
>
> AFAICT, I think I just need to flush and unmap that file and can leave
> the rest of the files/folios in the pagecache as is? But then if the
> file has active refcounts on it or has been pinned into memory, can I
> still unmap and remove it from the page cache? I see the
> invalidate_inode_pages2() function but my understanding is that the
> page still stays in the cache if it has has active references, and if
> the page gets mmaped and there's a page fault on it, it'll end up
> using the preexisting old page in the page cache.

Never mind, I was mistaken about this. Johannes confirmed that even if
there's active refcounts on the folio, it'll still get removed from
the page cache after unmapping and the page cache reference will get
dropped.

I think I can just do what you suggested and call
filemap_invalidate_inode() in fuse_change_attributes_common() then if
the inode blksize gets changed. Thanks for the suggestion!

>
> I don't think I really need to have it removed from the page cache so
> much as just have the ifs state for all the folios in the file freed
> (after flushing the file) so that it can start over with a new ifs.
> Ideally we could just flush the file, then iterate through all the
> folios in the mapping in order of ascending index, and kfree their
> ->private, but I'm not seeing how we can prevent the case of new
> writes / a new ifs getting allocated for folios at previous indexes
> while we're trying to do the iteration/kfreeing.
>
> >
> > void fuse_iomap_set_i_blkbits(struct inode *inode, u8 new_blkbits)
> > {
> >         trace_fuse_iomap_set_i_blkbits(inode, new_blkbits);
> >
> >         if (inode->i_blkbits =3D=3D new_blkbits)
> >                 return;
> >
> >         if (!S_ISREG(inode->i_mode))
> >                 goto set_it;
> >
> >         /*
> >          * iomap attaches per-block state to each folio, so we cannot a=
llow
> >          * the file block size to change if there's anything in the pag=
e cache.
> >          * In theory, fuse servers should never be doing this.
> >          */
> >         if (inode->i_mapping->nrpages > 0) {
> >                 WARN_ON(inode->i_blkbits !=3D new_blkbits &&
> >                         inode->i_mapping->nrpages > 0);
> >                 return;
> >         }
> >
> > set_it:
> >         inode->i_blkbits =3D new_blkbits;
> > }
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/co=
mmit/?h=3Dfuse-iomap-attrs&id=3Dda9b25d994c1140aae2f5ebf10e54d0872f5c884
> >
> > --D
> >
> > >
> > > Thanks,
> > > Joanne
> > >

