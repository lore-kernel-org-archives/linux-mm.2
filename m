Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5BFFC83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 21:28:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 401716B0088; Mon, 28 Jul 2025 17:28:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3641D6B0089; Mon, 28 Jul 2025 17:28:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 204BE6B008A; Mon, 28 Jul 2025 17:28:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0719B6B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:28:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6510C58EB8
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 21:28:45 +0000 (UTC)
X-FDA: 83714963010.19.E609412
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7DC64180004
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 21:28:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Mk2/KpCy";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753738123; a=rsa-sha256;
	cv=none;
	b=eXIjxo394frMqKSZHWHaF6unYw4iOn7ii62qvo1VhdxcPiSpMtlVAm9rNKODRZbkdNdGz+
	tcvhr6v6Nt9VmpVHaqnpUzGNqsPxgZ9UTTVyHS3SAXOAXkg8p/m/9VojtyZJitpDjqCn07
	TlyCpBkY4GOzsBDtziJxW5QS6LAttDY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Mk2/KpCy";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753738123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZneXYaFQqRFzc5Typc3+x1A+h4NqvmfdYJJXUBl9f5k=;
	b=7ESpvl3xDdfZ3unzHaH2MDUOIljUQddDQ0mdcIjP/193KsZyZdcEZ2bLz6G2/QDOwUtff0
	rvpt7Nek3dPYZHFJasDfJrhn4sMSLVlAai18ygOFN0JBoEdtMSZl3wjF5SrKuW/+uY/XmB
	CrJae4eXrIGqw0yFRCdylpjgaojBdFg=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4ab92d06ddeso65011091cf.3
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 14:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753738122; x=1754342922; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZneXYaFQqRFzc5Typc3+x1A+h4NqvmfdYJJXUBl9f5k=;
        b=Mk2/KpCyLFnhww1FDXgFIjusis6qb4Z9sfLfzOE7gDVROuCudMmNb5grK64UZx/u0c
         xGl+ssEuZuBgCP0RzrAIEpmeYtH9vAzXUdT5owxyrVe8YHpauv8yy7B7e7TnjIIxzKlG
         mHRE0mfwff5QGQu8AhwrxyKf0s93O8criOBXvqTehNQQ8CJkjCD815o8PEky7beg+HGh
         +DUxa+cwKKEmYG0lGafOxh9Fna3S6dd0OtNr+ONnAKPlqouieKRWnj9m1DNo50sN3YZM
         7tJlPCvsJmASNX98q8LhjXL94LpNpjYp0n/K42YSYcMlyOqeMKvKjN3sMEAwt4supjW4
         vx0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753738122; x=1754342922;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZneXYaFQqRFzc5Typc3+x1A+h4NqvmfdYJJXUBl9f5k=;
        b=khNTBxkeMolboprQbfmIXX217oMCfUoDhNBysAyjo/yqSQPesubOxqW3IC4qJiFdz5
         YsHlbSwnfRORY+c7EdMll/fWLusXHWsW8vdKdKL5+UMWv4HIm3nhe2QvhNUzvEuhUoIE
         DTqHlRNjo+7kl+6w2uIb36p+amfUb55G8RYyBCYCHgPovszL0m3OdYRsyGgZp9pFgUMv
         zdqaa18IfumIh9GcPZfB2Hck7Zn0ftLO22hD/fT2JeZdrJoyw7JacfKH6NdgMh3mJxT7
         mVvEfdtonCWuumzCjEKkNCvotPeLHTlyZp9CmpkMLOrvdriQ+nzXjlcMnpvaXjv+W/oQ
         NjkA==
X-Forwarded-Encrypted: i=1; AJvYcCWZVgQCtqOlTwuJyoA52lQLi85tVBTnnvohd4K7RhM+vFQuO6FnxzjRleN4zfEtk1sMu7hybttRcQ==@kvack.org
X-Gm-Message-State: AOJu0YxN/WULLejCSNHrJ745Gv/5G4nRAVQf0UMI/J1Y0L3rtap9OGIN
	8EtZtiUQmn/0zFVfh1I5isv7EmErxIIRg6YZQuhAZg8I48BOjq0QQIG90wr4mxD7S7BUvU1zFr2
	DlLmtmlz7dBCNLQs13CM67dePn9SqtZs=
X-Gm-Gg: ASbGncsF4XruOVeZzo7tKUhMipA2cNorSsV5WvY+cVDKugw89mUpMLUp+ed7dKzZANz
	zOYk69MM9t6gkqWwURUT0VERfI56QRlH9RYHQNmhjxWmASIF7k5sqw+LuNlvm1Z4WLtLNFmxgDe
	0HdsEty0MMzb+Q3IV0xUJE35Ga48eku7Ftp3zxmrlV6Wy2rzA5EcX/xTA0SrIEqustkK2xph5Hj
	S5X1KU=
X-Google-Smtp-Source: AGHT+IGpshBgXQ7U+MDDP9pZt9MZQFWNWDud5gzczcYQsSqnHcLkucfw/67HUIu/F7G55XnBhEoxT9W/2r5VX/Q4DKA=
X-Received: by 2002:a05:622a:a30f:b0:4ae:cc2b:77ce with SMTP id
 d75a77b69052e-4aecc2b839bmr18026601cf.60.1753738122289; Mon, 28 Jul 2025
 14:28:42 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYs5AdVM-T2Tf3LciNCwLZEHetcnSkHsjZajVwwpM2HmJw@mail.gmail.com>
 <20250723144637.GW2672070@frogsfrogsfrogs> <CAJnrk1Z7wcB8uKWcrAuRAZ8B-f8SKnOuwtEr-=cHa+ApR_sgXQ@mail.gmail.com>
 <20250723212020.GY2672070@frogsfrogsfrogs> <CAJnrk1bFWRTGnpNhW_9MwSYZw3qPnPXZBeiwtPSrMhCvb9C3qg@mail.gmail.com>
 <CAJnrk1byTVJtuOyAyZSVYrusjhA-bW6pxBOQQopgHHbD3cDUHw@mail.gmail.com>
 <CAJnrk1ZYR=hM5k90H57tOv=fe6F-r8dO+f3wNuCT_w3j8YNYNQ@mail.gmail.com>
 <20250728171425.GR2672029@frogsfrogsfrogs> <CAJnrk1bBesBijYRD1Wf_01OSBykJ0VzwFZKZFev0wPn9wYc98Q@mail.gmail.com>
 <20250728191117.GE2672070@frogsfrogsfrogs>
In-Reply-To: <20250728191117.GE2672070@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 28 Jul 2025 14:28:31 -0700
X-Gm-Features: Ac12FXwQypfcuflR6PeoeGonrJscLSoGlm7JYS7bzfTRsF2cl4KDjPb0EDDvOeo
Message-ID: <CAJnrk1bTgTcb4aUWqczXEH+7+SWQAdppxYbSAPNCVY6xXb-=hQ@mail.gmail.com>
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
X-Stat-Signature: yt5mbsynqmpnnzinrcgbw4pcuc6y6axo
X-Rspam-User: 
X-Rspamd-Queue-Id: 7DC64180004
X-Rspamd-Server: rspam02
X-HE-Tag: 1753738123-325727
X-HE-Meta: U2FsdGVkX1+Su7YjKyJGxFXqwYmW/Q6I0IfInHZskYoFdS55/uAwLKV7PqdU24OHcrvkest2Mniz2SaElotOJkvgEQHXLbMg954eiGdoy/OLUCzAzt3M5/b1aQw41YzNPMCniW6QCn5ThYO10lUyNVEjP2oVJmAUl6C36uSacY4UmvtB0PE/bp8mL3ErkdTVA/Sy8DyGaU6/3rxaYwE8t0ZF6GtmBASs1Z0ngBQOKQMZ3suy7E7CaGKjx+aeth+I01OkaEg+p+b2LqICxgOjIBeh5LRmlVyU+6FlKQoybBlIwlWwT9CO+a8/EDBcwXmR+8ev14HBFN3vIv04MWspQwY21h7qwTciZNN//hQwDYg+eGM49DdZp9Ygz4Z6LZ8/5VpLq/2CUPjsllKAbQ9FeSuBc/A78+NsR/Zwf/QM+lKpTi4T7pZzyXP4WsbveiMxgFuJ5BFK43sAkcZ9cs7/y8aGjYjMB6K2XvtHzMkDMsz5xgmsMpcgAw5X7FE2rBjZB5ozX0TAXctE2ScgSWc2VPfJop6Q4JPz3pYf/G4eRHrCizz3m+FCq4T8Xfw7EmK+A2ur/l5NiNVcm9pKfUtfJEzym6OcwHQRb6gLq40UI4IjKYb4L/2Nx+XBNJ+X4oKnGhEA2493t2FLpSdb3dFYXvPn141/HMWeIRYAKw/qwtgJGFnGRZC1gveeILKyntJ4chTiPb4k/GdQtv4RzFSpY14H7u1zIILNWy2fAZjuKaAQZDORjgNNOSxcLBn4I2nC2Nk4n+hYYKIDHXrW2v4TaPIa5+3x0RDh15hRBURHmoAiphriTVd+vBJaf1MGepvmRhsQLh157CWGykYaDlB+10ActSS3K+uOXXU9NWf/xoBIxEQzcDCeu42BLkUB858fvqsNymVwEjPSKYHd9cZiSEiXqulP9PD3Gs7y5ZhGPBkpcPnkXr/2b5gfr8m3g2rLl1x+xpWWkYRsHsho6MW
 ghHJs5se
 D2UIPhkIfClhBg0KGEEOedLzp5dLbqory98SlWCE4wdLKx2IG+i/8rQW/otjgmRXPv1IpRcajSd1bltMxuflXZcs1gs+Ybr/VEFw14826arQ3i0BQiW1DGxb7A74E67ZOvU2Cs9A6QNB8MpoQWPtsfTk+IMleV9kVXsCy+x6RTK3Ur+lB/7Q1wYa8jPaAtKQfOKeK1BfxrPdj80x0+/6uNXQL6HXruRBaKiyoubPOo5edscR3kTLVMyKN5NxTnHHcIkF150utsPRXb7qfyKDhdqi6uxOh9Mta7uCMU7gb6DCilHlE8d+/g4CX2Mp13v6HBnfbjVVGkCtJLUgPwIb7daOWhmXEHa+jzG10fjXxiYZFbV1C7qoWPuAcxHLo48pGVM+ZjEP7d8YmTz2ySGJkBzkl/85rkmdPd95XBkUOO7uLcgXc9gs/7dg7Sua6orVLg9qnuDLeKuxOg8TamV5j/4EhM4+gDdZDRpTSJmR0wQd3/TvZcySFG+gdO5M4vTn/EIfmqeIIJXnQLeOZNkjgzOrylFgq7dr9sINj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 28, 2025 at 12:11=E2=80=AFPM Darrick J. Wong <djwong@kernel.org=
> wrote:
>
> On Mon, Jul 28, 2025 at 10:44:01AM -0700, Joanne Koong wrote:
> > On Mon, Jul 28, 2025 at 10:14=E2=80=AFAM Darrick J. Wong <djwong@kernel=
.org> wrote:
> > >
> > > On Fri, Jul 25, 2025 at 06:16:15PM -0700, Joanne Koong wrote:
> > > > On Thu, Jul 24, 2025 at 12:14=E2=80=AFPM Joanne Koong <joannelkoong=
@gmail.com> wrote:
> > > > >
> > > > > On Wed, Jul 23, 2025 at 3:37=E2=80=AFPM Joanne Koong <joannelkoon=
g@gmail.com> wrote:
> > > > > >
> > > > > > On Wed, Jul 23, 2025 at 2:20=E2=80=AFPM Darrick J. Wong <djwong=
@kernel.org> wrote:
> > > > > > >
> > > > > > > On Wed, Jul 23, 2025 at 11:42:42AM -0700, Joanne Koong wrote:
> > > > > > > > On Wed, Jul 23, 2025 at 7:46=E2=80=AFAM Darrick J. Wong <dj=
wong@kernel.org> wrote:
> > > > > > > > >
> > > > > > > > > [cc Joanne]
> > > > > > > > >
> > > > > > > > > On Wed, Jul 23, 2025 at 05:14:28PM +0530, Naresh Kamboju =
wrote:
> > > > > > > > > > Test regression: next-20250721 arm64 16K and 64K page s=
ize WARNING fs
> > > > > > > > > > fuse file.c at fuse_iomap_writeback_range
> > > > > > > > > >
> > > > > > > > > > Reported-by: Linux Kernel Functional Testing <lkft@lina=
ro.org>
> > > > > > > > > >
> > > > > > > > > > ## Test log
> > > > > > > > > > ------------[ cut here ]------------
> > > > > > > > > > [  343.828105] WARNING: fs/fuse/file.c:2146 at
> > > > > > > > > > fuse_iomap_writeback_range+0x478/0x558 [fuse], CPU#0: m=
sync04/4190
> > > > > > > > >
> > > > > > > > >         WARN_ON_ONCE(len & (PAGE_SIZE - 1));
> > > > > > > > >
> > > > > > > > > /me speculates that this might be triggered by an attempt=
 to write back
> > > > > > > > > some 4k fsblock within a 16/64k base page?
> > > > > > > > >
> > > > > > > >
> > > > > > > > I think this can happen on 4k base pages as well actually. =
On the
> > > > > > > > iomap side, the length passed is always block-aligned and i=
n fuse, we
> > > > > > > > set blkbits to be PAGE_SHIFT so theoretically block-aligned=
 is always
> > > > > > > > page-aligned, but I missed that if it's a "fuseblk" filesys=
tem, that
> > > > > > > > isn't true and the blocksize is initialized to a default si=
ze of 512
> > > > > > > > or whatever block size is passed in when it's mounted.
> > > > > > >
> > > > > > > <nod> I think you're correct.
> > > > > > >
> > > > > > > > I'll send out a patch to remove this line. It doesn't make =
any
> > > > > > > > difference for fuse_iomap_writeback_range() logic whether l=
en is
> > > > > > > > page-aligned or not; I had added it as a sanity-check again=
st sketchy
> > > > > > > > ranges.
> > > > > > > >
> > > > > > > > Also, I just noticed that apparently the blocksize can chan=
ge
> > > > > > > > dynamically for an inode in fuse through getattr replies fr=
om the
> > > > > > > > server (see fuse_change_attributes_common()). This is a pro=
blem since
> > > > > > > > the iomap uses inode->i_blkbits for reading/writing to the =
bitmap. I
> > > > > > > > think we will have to cache the inode blkbits in the iomap_=
folio_state
> > > > > > > > struct unfortunately :( I'll think about this some more and=
 send out a
> > > > > > > > patch for this.
> > > > > > >
> > > > > > > From my understanding of the iomap code, it's possible to do =
that if you
> > > > > > > flush and unmap the entire pagecache (whilst holding i_rwsem =
and
> > > > > > > mmap_invalidate_lock) before you change i_blkbits.  Nobody *d=
oes* this
> > > > > > > so I have no idea if it actually works, however.  Note that e=
ven I don't
> > > > > > > implement the flush and unmap bit; I just scream loudly and d=
o nothing:
> > > > > >
> > > > > > lol! i wish I could scream loudly and do nothing too for my cas=
e.
> > > > > >
> > > > > > AFAICT, I think I just need to flush and unmap that file and ca=
n leave
> > > > > > the rest of the files/folios in the pagecache as is? But then i=
f the
> > > > > > file has active refcounts on it or has been pinned into memory,=
 can I
> > > > > > still unmap and remove it from the page cache? I see the
> > > > > > invalidate_inode_pages2() function but my understanding is that=
 the
> > > > > > page still stays in the cache if it has has active references, =
and if
> > > > > > the page gets mmaped and there's a page fault on it, it'll end =
up
> > > > > > using the preexisting old page in the page cache.
> > > > >
> > > > > Never mind, I was mistaken about this. Johannes confirmed that ev=
en if
> > > > > there's active refcounts on the folio, it'll still get removed fr=
om
> > > > > the page cache after unmapping and the page cache reference will =
get
> > > > > dropped.
> > > > >
> > > > > I think I can just do what you suggested and call
> > > > > filemap_invalidate_inode() in fuse_change_attributes_common() the=
n if
> > > > > the inode blksize gets changed. Thanks for the suggestion!
> > > > >
> > > >
> > > > Thinking about this some more, I don't think this works after all
> > > > because the writeback + page cache removal and inode blkbits update
> > > > needs to be atomic, else after we write back and remove the pages f=
rom
> > > > the page cache, a write could be issued right before we update the
> > > > inode blkbits. I don't think we can hold the inode lock the whole t=
ime
> > > > for it either since writeback could be intensive. (also btw, I
> > > > realized in hindsight that invalidate_inode_pages2_range() would ha=
ve
> > > > been the better function to call instead of
> > > > filemap_invalidate_inode()).
> > > >
> > > > > >
> > > > > > I don't think I really need to have it removed from the page ca=
che so
> > > > > > much as just have the ifs state for all the folios in the file =
freed
> > > > > > (after flushing the file) so that it can start over with a new =
ifs.
> > > > > > Ideally we could just flush the file, then iterate through all =
the
> > > > > > folios in the mapping in order of ascending index, and kfree th=
eir
> > > > > > ->private, but I'm not seeing how we can prevent the case of ne=
w
> > > > > > writes / a new ifs getting allocated for folios at previous ind=
exes
> > > > > > while we're trying to do the iteration/kfreeing.
> > > > > >
> > > >
> > > > Going back to this idea, I think this can work. I realized we don't
> > > > need to flush the file, it's enough to free the ifs, then update th=
e
> > > > inode->i_blkbits, then reallocate the ifs (which will now use the
> > > > updated blkbits size), and if we hold the inode lock throughout, th=
at
> > > > prevents any concurrent writes.
> > > > Something like:
> > > >      inode_lock(inode);
> > > >      XA_STATE(xas, &mapping->i_pages, 0);
> > > >      xa_lock_irq(&mapping->i_pages);
> > > >      xas_for_each_marked(&xas, folio, ULONG_MAX, PAGECACHE_TAG_DIRT=
Y) {
> > > >           folio_lock(folio);
> > > >           if (folio_test_dirty(folio)) {
> > > >                   folio_wait_writeback(folio);
> > > >                   kfree(folio->private);
> > > >           }
>
> Heh, I didn't even see this chunk, distracted as I am today. :/
>
> So this doesn't actually /initiate/ writeback, it just waits
> (potentially for a long time) for someone else to come along and do it.
> That might not be what you want since the blocksize change will appear
> to stall while nothing else is going on in the system.

I thought if the folio isn't under writeback then
folio_wait_writeback() just returns immediately as a no-op.
I don't think we need/want to initiate writeback, I think we only need
to ensure that if it is already under writeback, that writeback
finishes while it uses the old i_blksize so nothing gets corrupted. As
I understand it (but maybe I'm misjudging this), holding the inode
lock and then initiating writeback is too much given that writeback
can take a long time (eg if the fuse server writes the data over some
network).

>
> Also, unless you're going to put this in buffered-io.c, it's not
> desirable for a piece of code to free something it didn't allocate.
> IOWs, I don't think it's a good idea for *fuse* to go messing with a
> folio->private that iomap set.

Okay, good point. I agree. I was hoping to have this not bleed into
the iomap library but maybe there's no getting around that in a good
way.

>
> > > >           folio_unlock(folio);
> > > >      }
> > > >     inode->i_blkbits =3D new_blkbits_size;
> > >
> > > The trouble is, you also have to resize the iomap_folio_state objects
> > > attached to each folio if you change i_blkbits...
> >
> > I think the iomap_folio_state objects automatically get resized here,
> > no? We first kfree the folio->private which kfrees the entire ifs,
>
> Err, right, it does free the ifs and recreate it later if necessary.
>
> > then we change inode->i_blkbits to the new size, then when we call
> > folio_mark_dirty(), it'll create the new ifs which creates a new folio
> > state object using the new/updated i_blkbits size
> >
> > >
> > > >     xas_set(&xas, 0);
> > > >     xas_for_each_marked(&xas, folio, ULONG_MAX, PAGECACHE_TAG_DIRTY=
) {
> > > >           folio_lock(folio);
> > > >           if (folio_test_dirty(folio) && !folio_test_writeback(foli=
o))
> > > >                  folio_mark_dirty(folio);
> > >
> > > ...because iomap_dirty_folio doesn't know how to reallocate the folio
> > > state object in response to i_blkbits having changed.
>
> Also, what about clean folios that have an ifs?  You'd still need to
> handle the ifs's attached to those.

Ah you're right, there could be clean folios there too that have an
ifs. I think in the above logic, if we iterate through all
mapping->i_pages (not just PAGECACHE_TAG_DIRTY marked ones) and move
the kfree to after the "if (folio_test_dirty(folio))" block, then it
addresses that case. eg something like this:

     inode_lock(inode);
     XA_STATE(xas, &mapping->i_pages, 0);
     xa_lock_irq(&mapping->i_pages);
     xas_for_each(&xas, folio, ULONG_MAX) {
          folio_lock(folio);
          if (folio_test_dirty(folio))
                  folio_wait_writeback(folio);
          kfree(folio->private);
          folio_unlock(folio);
     }
    inode->i_blkbits =3D new_blkbits;
    xas_set(&xas, 0);
    xas_for_each_marked(&xas, folio, ULONG_MAX, PAGECACHE_TAG_DIRTY) {
          folio_lock(folio);
          if (folio_test_dirty(folio) && !folio_test_writeback(folio))
                 folio_mark_dirty(folio);
          folio_unlock(folio);
    }
    xa_unlock_irq(&mapping->i_pages);
    inode_unlock(inode);


>
> So I guess if you wanted iomap to handle a blocksize change, you could
> do something like:
>
> iomap_change_file_blocksize(inode, new_blkbits) {
>         inode_lock()
>         filemap_invalidate_lock()
>
>         inode_dio_wait()
>         filemap_write_and_wait()
>         if (new_blkbits > mapping_min_folio_order()) {
>                 truncate_pagecache()
>                 inode->i_blkbits =3D new_blkbits;
>         } else {
>                 inode->i_blkbits =3D new_blkbits;
>                 xas_for_each(...) {
>                         <create new ifs>
>                         <translate uptodate/dirty state to new ifs>
>                         <swap ifs>
>                         <free old ifs>
>                 }
>         }
>
>         filemap_invalidate_unlock()
>         inode_unlock()
> }

Do you prefer this logic to the one above that walks through
&mapping->i_pages? If so, then I'll go with this way.
The part I'm unsure about is that this logic seems more disruptive (eg
initiating writeback while holding the inode lock and doing work for
unmapping/page cache removal) than the other approach, but I guess
this is also rare enough that it doesn't matter much.


Thanks,
Joanne

>
> --D
>
> > > --D
> > >
> > > >           folio_unlock(folio);
> > > >     }
> > > >     xa_unlock_irq(&mapping->i_pages);
> > > >     inode_unlock(inode);
> > > >
> > > >
> > > > I think this is the only approach that doesn't require changes to i=
omap.
> > > >
> > > > I'm going to think about this some more next week and will try to s=
end
> > > > out a patch for this then.
> > > >
> > > >
> > > > Thanks,
> > > > Joanne
> > > >
> > > > > > >
> > > > > > > void fuse_iomap_set_i_blkbits(struct inode *inode, u8 new_blk=
bits)
> > > > > > > {
> > > > > > >         trace_fuse_iomap_set_i_blkbits(inode, new_blkbits);
> > > > > > >
> > > > > > >         if (inode->i_blkbits =3D=3D new_blkbits)
> > > > > > >                 return;
> > > > > > >
> > > > > > >         if (!S_ISREG(inode->i_mode))
> > > > > > >                 goto set_it;
> > > > > > >
> > > > > > >         /*
> > > > > > >          * iomap attaches per-block state to each folio, so w=
e cannot allow
> > > > > > >          * the file block size to change if there's anything =
in the page cache.
> > > > > > >          * In theory, fuse servers should never be doing this=
.
> > > > > > >          */
> > > > > > >         if (inode->i_mapping->nrpages > 0) {
> > > > > > >                 WARN_ON(inode->i_blkbits !=3D new_blkbits &&
> > > > > > >                         inode->i_mapping->nrpages > 0);
> > > > > > >                 return;
> > > > > > >         }
> > > > > > >
> > > > > > > set_it:
> > > > > > >         inode->i_blkbits =3D new_blkbits;
> > > > > > > }
> > > > > > >
> > > > > > > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-li=
nux.git/commit/?h=3Dfuse-iomap-attrs&id=3Dda9b25d994c1140aae2f5ebf10e54d087=
2f5c884
> > > > > > >
> > > > > > > --D
> > > > > > >
> > > > > > > >
> > > > > > > > Thanks,
> > > > > > > > Joanne
> > > > > > > >
> > > >

