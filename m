Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56B7AC83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 17:44:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDF456B0095; Mon, 28 Jul 2025 13:44:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB7516B0096; Mon, 28 Jul 2025 13:44:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCD596B0098; Mon, 28 Jul 2025 13:44:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C997A6B0095
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 13:44:16 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 49B5F588FD
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:44:16 +0000 (UTC)
X-FDA: 83714397312.06.41D81AE
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5428040005
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:44:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gomPqHCI;
	spf=pass (imf12.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753724654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WaNs6TAtiLS9Zn84sgyHz2QFRjPypF9PY+lV+Xzno3c=;
	b=fRrOj8eAt9ZtuA8jGuchEoeuAtSpafwuCxYpQZho9npAxdQj8F9uvJR6WNdtuMapIWbJV7
	p8KLsKQkWIQfK6XvP3/YjSkjD/UhPBBgacqt+XpGky9AnMgjM9HC23Uc2B/KTSLdZt8+aD
	rusdhFFM6s4yHmgW3Urh+FKuTEwI8hk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gomPqHCI;
	spf=pass (imf12.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753724654; a=rsa-sha256;
	cv=none;
	b=yq8vdHsbAmNwwF75ep8TOHYedG/zrNo1aJoCE4oyJnlK4p+Tn0I8+bRYxZlOY+NXXDC6oZ
	0mco6c4lGsCh7Qga2q4Bhi1S4zyv8VtveFImkJss6wGG4CHO4814SAsapw1zggzs6w8pOg
	bTUvKh7EG6cLO+Rbk1yLPi3t1RYxHgc=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ab7082b3f7so56878911cf.3
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 10:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753724653; x=1754329453; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WaNs6TAtiLS9Zn84sgyHz2QFRjPypF9PY+lV+Xzno3c=;
        b=gomPqHCIjY7zG7LtJlsuS8VodzVRsbOTTyCC9NYYL69w4YwmduRiphVWPSfZ0bLfOr
         Cwt2dowA1sZG4nQbR8FtWt9V6tzJ3lbmUZRftU3oBvNW+U29j/af8X4HlABSR+n+zFU4
         DrerFv1xbIVonwo6jk4tGjM6vrt2IWK9XfdHfbXSRged2yAKUu/JJPK6z4NBoOfLRtHH
         ZGZGf4KiDl2Cw/0tAfsuZlzu/9Jr/MGcI6dQ3Tns+iZ2dgO+hE090TjFiRlPFyRu19HH
         CQEpxegxRKpO8kJVBizm6/tSV2jNXpbwaDBFrUGj8G2wFe3dml99gvwix5ag4XqtnMui
         ps6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753724653; x=1754329453;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WaNs6TAtiLS9Zn84sgyHz2QFRjPypF9PY+lV+Xzno3c=;
        b=MrJbqN9WhH06AtIsMRIFSQkMKuVJSobbwVc4AWLl0z84XYsox+hcPm37zIP3YJNe6M
         apNzmw5jnlDJ3INK3z8Z0A+b4G5W0YDA3T9ZtBHqILg+fNEjV1yvVrFUbWdXfUgNdod8
         3DBbVUQGzko8LMAzNgiH9MjywrWclPcihYrkoVkzn+TUENWzSfRPatW1Gac33zchlFlg
         nRB4ZcCE8KMHPSazA4V2y5/FwUPvhN70HBXY303M8NOz8tKB3ImqJ5B9mhOqW9JsZvDB
         xPd9V5/7hov/M/JsxYcPEPWkmXxhTngUCOIbNBnj9uM8pjCX9UmnLfmXPatvB99OmRuQ
         GYIw==
X-Forwarded-Encrypted: i=1; AJvYcCUdfjAAocGM0DR4Wsjz2axZhhE6SkIRwOX1Bs/YO3gq1pCaDy89Yk8Kz4+7+tA66mFs57ut1Is54Q==@kvack.org
X-Gm-Message-State: AOJu0Yyo5Om+ZpKNMvlqLJwFVI0VuNU4ZnL030ATfVvR2o4DO/OhVGR7
	RB8FtB+zLoKWZAsrm59xNSrxOoBB4pH3lf30ehwsf0JGliMMJYvs+2r8p5PTLQFroYWnhGlr0c2
	u6+PUCoa0qt78wHvi9IBzHXcX+Rnmo3U=
X-Gm-Gg: ASbGncuEZuKYsLJfcs0btbQrDsIeKKcH0vAkcXz74bI9LiY+m3LhgqRhZJuyxAgX/8B
	Ce6DFM/YY0cUex9QhmorHrFx6UN/ZkbNrbiGt8QiQW0xFvO467/UrIte3Zd8C9k9FvDvXvBzJIg
	ee0WWCvLli8ZmoR4wRzprOmszGl2RZT19L3X80O0Xmxwg2ZATV5A6Ur6+nQcAhbFUmKUBF2552/
	jlf3wDoxlqMbQXHgA==
X-Google-Smtp-Source: AGHT+IGte50fwChvEi9kJQNzD68kbG1EMNvci8he6MVBVKPQmFhf/9CW//FXjrAlW6QX8pLJYLCknnZzhpsStOhCE6k=
X-Received: by 2002:ac8:5a44:0:b0:4ab:6c75:620 with SMTP id
 d75a77b69052e-4ae8ef62b14mr151522531cf.1.1753724652975; Mon, 28 Jul 2025
 10:44:12 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYs5AdVM-T2Tf3LciNCwLZEHetcnSkHsjZajVwwpM2HmJw@mail.gmail.com>
 <20250723144637.GW2672070@frogsfrogsfrogs> <CAJnrk1Z7wcB8uKWcrAuRAZ8B-f8SKnOuwtEr-=cHa+ApR_sgXQ@mail.gmail.com>
 <20250723212020.GY2672070@frogsfrogsfrogs> <CAJnrk1bFWRTGnpNhW_9MwSYZw3qPnPXZBeiwtPSrMhCvb9C3qg@mail.gmail.com>
 <CAJnrk1byTVJtuOyAyZSVYrusjhA-bW6pxBOQQopgHHbD3cDUHw@mail.gmail.com>
 <CAJnrk1ZYR=hM5k90H57tOv=fe6F-r8dO+f3wNuCT_w3j8YNYNQ@mail.gmail.com> <20250728171425.GR2672029@frogsfrogsfrogs>
In-Reply-To: <20250728171425.GR2672029@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 28 Jul 2025 10:44:01 -0700
X-Gm-Features: Ac12FXwC8Bb-k9tFwYfIA8TgFEpNMPte-Anh_9X52L95AlRm8wPx7oIuVouRTN8
Message-ID: <CAJnrk1bBesBijYRD1Wf_01OSBykJ0VzwFZKZFev0wPn9wYc98Q@mail.gmail.com>
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
X-Stat-Signature: mgkdz8qdh98jw19aftz86qr95no7fryc
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5428040005
X-Rspam-User: 
X-HE-Tag: 1753724654-572012
X-HE-Meta: U2FsdGVkX19sgWl2RKoS8VWi6PZOqo2GONp7x+ekbwhuYJDePatGZBdMmpBNJomy9tk701fKJdCDlgLpthFndPlu60kQUmBJ5ujbU0Z3/PshsP1y07qrXue7mnKlE3DE/zIrenni4G/Qjh3tjRJtbNUGkz8LhhaGFAXdyy9mkmo5NOOwsQHeT+AW/wA9bhe8QP/eLz+msfZXbVlZXbsnuiUAZlyDBlfMf1D5+D/DAvDkwVKVx2U6KdzACS+GcDsCIbcVJaI1Dt8JNBd+/Lv9kXahUMWmBqrOu9h1w79alUrlcaOta99q9S2iItDa+sQmfD5jDoY5/ZBGRDia8IWyohCZ5+66gmb9RrmqhHxyu1OgyKCar9+Yskx2+ntfhw4JJTMdzNvzIoMuEnsvxKfYKvbR7sWvbIX37mmHKnFte34Rqv7GIsbRrKf5J8jbWZ/x58Ch1Vy4uKdaokFcKgLfWI1tKFMZHjmHPd0Mpao+2C4WmgP6qqisV494orWYLZSjAUNE87qhhfKWH4r5sFXQSBjJwRJiZekqzDaGO/AGFrZq0pRExF1dwQFDDidB0bdqsn8JN0Tj9omDtBILspnG8jHe+zVb0wlmtEQhfHik7JY7YvPExPxk3EuIaQEH140Ivne+/ZEhySorr40GVqq/CaJzkihh+iuFeiVShIW/hbbEER98rKqbOTnx6HLcLMV4ayuG1fAOy1i4juuHILVIFH+xt8+wXAK8GW3tdsse809v2Uye8nxGMX4xEFYB9op3phPo1skUfR86zUujD5Qcs00Ef4r4Aiz/A77EuOdRHftBsBXMYVT/ykZQndBAamtkdE/rgOcdDsgJFsATynPk/6S33GahO4gAgfwoP+M9hI+WsMFTLojZ1P/Xm9lX/f/R+DvCaBbX+jONficjIZIbVmf9+YUmGyglB/GOyQMNqzlurXWZPQKo+TZje6setwVwPxfdZFEpVB5/k44qrpV
 lemsitOz
 irtk4N9QvBZQQax8dKVI18LJeM7wv3BshtA9k1S/c+UZczPTvKOZOTYPsCCOlg3B6Jvt47EIlPooKatsJk7AHTreG6QoK71OlexxZgTl0XKYafOMRtZMPuHdPNIyIb3h5Ss6WuaW2CMnQHU96pdggSJUaBcoRAC5mNErDFeHYZDjkeeIV7gD4S1ntIimyvCrVm0nj4kw0VAFx2BQrFsgFxxxF+zOJ4I0RnMpIqrX5T8YX4NJqqFDGqZ33AYPIsWQPtIf7r5uEypTXwebcJ9xxUC7GG8vtec9nETQQ1drzXZJen+KC1B4oJ18X/k/9zwSN7fQTSovn8TyOgGG2LZVuHcT9fuRlsgJeyEXatlhGATtFKbIx1ZjwcQRvmpH9ELp0W36sTPr6bU02HH9bpLHi5yY9+nlNlWZQhxovNfl0odxOcdZNyvFtYLEaN/Wd97GwmP1OIdXI3IZSSz5x3j90YtSZ9oQ1HxupXYOCWixvXgazZUsVqqCsuuzd3bWktkfQDwKn957EvWqrj7htkhjoNebZjQLBflmJoZ43
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 28, 2025 at 10:14=E2=80=AFAM Darrick J. Wong <djwong@kernel.org=
> wrote:
>
> On Fri, Jul 25, 2025 at 06:16:15PM -0700, Joanne Koong wrote:
> > On Thu, Jul 24, 2025 at 12:14=E2=80=AFPM Joanne Koong <joannelkoong@gma=
il.com> wrote:
> > >
> > > On Wed, Jul 23, 2025 at 3:37=E2=80=AFPM Joanne Koong <joannelkoong@gm=
ail.com> wrote:
> > > >
> > > > On Wed, Jul 23, 2025 at 2:20=E2=80=AFPM Darrick J. Wong <djwong@ker=
nel.org> wrote:
> > > > >
> > > > > On Wed, Jul 23, 2025 at 11:42:42AM -0700, Joanne Koong wrote:
> > > > > > On Wed, Jul 23, 2025 at 7:46=E2=80=AFAM Darrick J. Wong <djwong=
@kernel.org> wrote:
> > > > > > >
> > > > > > > [cc Joanne]
> > > > > > >
> > > > > > > On Wed, Jul 23, 2025 at 05:14:28PM +0530, Naresh Kamboju wrot=
e:
> > > > > > > > Regressions found while running LTP msync04 tests on qemu-a=
rm64 running
> > > > > > > > Linux next-20250721, next-20250722 and next-20250723 with 1=
6K and 64K
> > > > > > > > page size enabled builds.
> > > > > > > >
> > > > > > > > CONFIG_ARM64_64K_PAGES=3Dy ( kernel warning as below )
> > > > > > > > CONFIG_ARM64_16K_PAGES=3Dy ( kernel warning as below )
> > > > > > > >
> > > > > > > > No warning noticed with 4K page size.
> > > > > > > > CONFIG_ARM64_4K_PAGES=3Dy works as expected
> > > > > > >
> > > > > > > You might want to cc Joanne since she's been working on large=
 folio
> > > > > > > support in fuse.
> > > > > > >
> > > > > > > > First seen on the tag next-20250721.
> > > > > > > > Good: next-20250718
> > > > > > > > Bad:  next-20250721 to next-20250723
> > > > > >
> > > > > > Thanks for the report. Is there a link to the script that mount=
s the
> > > > > > fuse server for these tests? I'm curious whether this was mount=
ed as a
> > > > > > fuseblk filesystem.
> > > > > >
> > > > > > > >
> > > > > > > > Regression Analysis:
> > > > > > > > - New regression? Yes
> > > > > > > > - Reproducibility? Yes
> > > > > > > >
> > > > > > > > Test regression: next-20250721 arm64 16K and 64K page size =
WARNING fs
> > > > > > > > fuse file.c at fuse_iomap_writeback_range
> > > > > > > >
> > > > > > > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.o=
rg>
> > > > > > > >
> > > > > > > > ## Test log
> > > > > > > > ------------[ cut here ]------------
> > > > > > > > [  343.828105] WARNING: fs/fuse/file.c:2146 at
> > > > > > > > fuse_iomap_writeback_range+0x478/0x558 [fuse], CPU#0: msync=
04/4190
> > > > > > >
> > > > > > >         WARN_ON_ONCE(len & (PAGE_SIZE - 1));
> > > > > > >
> > > > > > > /me speculates that this might be triggered by an attempt to =
write back
> > > > > > > some 4k fsblock within a 16/64k base page?
> > > > > > >
> > > > > >
> > > > > > I think this can happen on 4k base pages as well actually. On t=
he
> > > > > > iomap side, the length passed is always block-aligned and in fu=
se, we
> > > > > > set blkbits to be PAGE_SHIFT so theoretically block-aligned is =
always
> > > > > > page-aligned, but I missed that if it's a "fuseblk" filesystem,=
 that
> > > > > > isn't true and the blocksize is initialized to a default size o=
f 512
> > > > > > or whatever block size is passed in when it's mounted.
> > > > >
> > > > > <nod> I think you're correct.
> > > > >
> > > > > > I'll send out a patch to remove this line. It doesn't make any
> > > > > > difference for fuse_iomap_writeback_range() logic whether len i=
s
> > > > > > page-aligned or not; I had added it as a sanity-check against s=
ketchy
> > > > > > ranges.
> > > > > >
> > > > > > Also, I just noticed that apparently the blocksize can change
> > > > > > dynamically for an inode in fuse through getattr replies from t=
he
> > > > > > server (see fuse_change_attributes_common()). This is a problem=
 since
> > > > > > the iomap uses inode->i_blkbits for reading/writing to the bitm=
ap. I
> > > > > > think we will have to cache the inode blkbits in the iomap_foli=
o_state
> > > > > > struct unfortunately :( I'll think about this some more and sen=
d out a
> > > > > > patch for this.
> > > > >
> > > > > From my understanding of the iomap code, it's possible to do that=
 if you
> > > > > flush and unmap the entire pagecache (whilst holding i_rwsem and
> > > > > mmap_invalidate_lock) before you change i_blkbits.  Nobody *does*=
 this
> > > > > so I have no idea if it actually works, however.  Note that even =
I don't
> > > > > implement the flush and unmap bit; I just scream loudly and do no=
thing:
> > > >
> > > > lol! i wish I could scream loudly and do nothing too for my case.
> > > >
> > > > AFAICT, I think I just need to flush and unmap that file and can le=
ave
> > > > the rest of the files/folios in the pagecache as is? But then if th=
e
> > > > file has active refcounts on it or has been pinned into memory, can=
 I
> > > > still unmap and remove it from the page cache? I see the
> > > > invalidate_inode_pages2() function but my understanding is that the
> > > > page still stays in the cache if it has has active references, and =
if
> > > > the page gets mmaped and there's a page fault on it, it'll end up
> > > > using the preexisting old page in the page cache.
> > >
> > > Never mind, I was mistaken about this. Johannes confirmed that even i=
f
> > > there's active refcounts on the folio, it'll still get removed from
> > > the page cache after unmapping and the page cache reference will get
> > > dropped.
> > >
> > > I think I can just do what you suggested and call
> > > filemap_invalidate_inode() in fuse_change_attributes_common() then if
> > > the inode blksize gets changed. Thanks for the suggestion!
> > >
> >
> > Thinking about this some more, I don't think this works after all
> > because the writeback + page cache removal and inode blkbits update
> > needs to be atomic, else after we write back and remove the pages from
> > the page cache, a write could be issued right before we update the
> > inode blkbits. I don't think we can hold the inode lock the whole time
> > for it either since writeback could be intensive. (also btw, I
> > realized in hindsight that invalidate_inode_pages2_range() would have
> > been the better function to call instead of
> > filemap_invalidate_inode()).
> >
> > > >
> > > > I don't think I really need to have it removed from the page cache =
so
> > > > much as just have the ifs state for all the folios in the file free=
d
> > > > (after flushing the file) so that it can start over with a new ifs.
> > > > Ideally we could just flush the file, then iterate through all the
> > > > folios in the mapping in order of ascending index, and kfree their
> > > > ->private, but I'm not seeing how we can prevent the case of new
> > > > writes / a new ifs getting allocated for folios at previous indexes
> > > > while we're trying to do the iteration/kfreeing.
> > > >
> >
> > Going back to this idea, I think this can work. I realized we don't
> > need to flush the file, it's enough to free the ifs, then update the
> > inode->i_blkbits, then reallocate the ifs (which will now use the
> > updated blkbits size), and if we hold the inode lock throughout, that
> > prevents any concurrent writes.
> > Something like:
> >      inode_lock(inode);
> >      XA_STATE(xas, &mapping->i_pages, 0);
> >      xa_lock_irq(&mapping->i_pages);
> >      xas_for_each_marked(&xas, folio, ULONG_MAX, PAGECACHE_TAG_DIRTY) {
> >           folio_lock(folio);
> >           if (folio_test_dirty(folio)) {
> >                   folio_wait_writeback(folio);
> >                   kfree(folio->private);
> >           }
> >           folio_unlock(folio);
> >      }
> >     inode->i_blkbits =3D new_blkbits_size;
>
> The trouble is, you also have to resize the iomap_folio_state objects
> attached to each folio if you change i_blkbits...

I think the iomap_folio_state objects automatically get resized here,
no? We first kfree the folio->private which kfrees the entire ifs,
then we change inode->i_blkbits to the new size, then when we call
folio_mark_dirty(), it'll create the new ifs which creates a new folio
state object using the new/updated i_blkbits size

>
> >     xas_set(&xas, 0);
> >     xas_for_each_marked(&xas, folio, ULONG_MAX, PAGECACHE_TAG_DIRTY) {
> >           folio_lock(folio);
> >           if (folio_test_dirty(folio) && !folio_test_writeback(folio))
> >                  folio_mark_dirty(folio);
>
> ...because iomap_dirty_folio doesn't know how to reallocate the folio
> state object in response to i_blkbits having changed.
>
> --D
>
> >           folio_unlock(folio);
> >     }
> >     xa_unlock_irq(&mapping->i_pages);
> >     inode_unlock(inode);
> >
> >
> > I think this is the only approach that doesn't require changes to iomap=
.
> >
> > I'm going to think about this some more next week and will try to send
> > out a patch for this then.
> >
> >
> > Thanks,
> > Joanne
> >
> > > > >
> > > > > void fuse_iomap_set_i_blkbits(struct inode *inode, u8 new_blkbits=
)
> > > > > {
> > > > >         trace_fuse_iomap_set_i_blkbits(inode, new_blkbits);
> > > > >
> > > > >         if (inode->i_blkbits =3D=3D new_blkbits)
> > > > >                 return;
> > > > >
> > > > >         if (!S_ISREG(inode->i_mode))
> > > > >                 goto set_it;
> > > > >
> > > > >         /*
> > > > >          * iomap attaches per-block state to each folio, so we ca=
nnot allow
> > > > >          * the file block size to change if there's anything in t=
he page cache.
> > > > >          * In theory, fuse servers should never be doing this.
> > > > >          */
> > > > >         if (inode->i_mapping->nrpages > 0) {
> > > > >                 WARN_ON(inode->i_blkbits !=3D new_blkbits &&
> > > > >                         inode->i_mapping->nrpages > 0);
> > > > >                 return;
> > > > >         }
> > > > >
> > > > > set_it:
> > > > >         inode->i_blkbits =3D new_blkbits;
> > > > > }
> > > > >
> > > > > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.=
git/commit/?h=3Dfuse-iomap-attrs&id=3Dda9b25d994c1140aae2f5ebf10e54d0872f5c=
884
> > > > >
> > > > > --D
> > > > >
> > > > > >
> > > > > > Thanks,
> > > > > > Joanne
> > > > > >
> >

