Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5840CC87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 22:54:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBFA16B007B; Wed, 30 Jul 2025 18:54:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C70F16B0088; Wed, 30 Jul 2025 18:54:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5F696B008A; Wed, 30 Jul 2025 18:54:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A0E0A6B007B
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 18:54:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D8F1D140538
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 22:54:29 +0000 (UTC)
X-FDA: 83722436658.12.E6F5DA6
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf12.hostedemail.com (Postfix) with ESMTP id ED1744000A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 22:54:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bCBrm0vk;
	spf=pass (imf12.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753916068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t7x2O+/3mlZ+l6d/dEpYOvhMfX3zDYsyk28CoMvKB+w=;
	b=v/poR7uXOOv3my5zkQZb6YFS6P/lO3Qx802E/x1qGpDggjj9fvdWDTHTIb3zIWjuejaoqE
	LNnzuSWJKdTB5rohhTx4g5X2pV4OWt+AfmuaULM/BkUj04W+5KPRnmDbo/SXYSBqTpLnQF
	uN+wl4Wob5cTgSNQktkj1L3hH5pTzdA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753916068; a=rsa-sha256;
	cv=none;
	b=3z/CSbnhFgzLZBx5uY6Mzaj1ih+D9M1YPBnB5jL6RvWdmgBfK3hoVnmUeqMRdN6toms0OA
	FoNZzZdY8610a4ngqyKQxYytvMTjES7b2H198rjxxWwj5I2PW7yRxPXeelTYAnMRdHb/Bk
	RuHQ0ksOZ9/GP7KgE2ahmRUa1N9hdTo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bCBrm0vk;
	spf=pass (imf12.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4abac5b1f28so2862901cf.0
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 15:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753916067; x=1754520867; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t7x2O+/3mlZ+l6d/dEpYOvhMfX3zDYsyk28CoMvKB+w=;
        b=bCBrm0vkWMLFm/KctWl0tYFWj+ACrcmnghpnvo2TkOOQAMkn24mFPAeIvLPDSGHmWi
         avjgdcCJjQWxiRleOKKqfosijWtJzEzFao6iuNxSp8mxsOpKYoeTP4B/tCct6DHLxRPr
         mfQwASfobruIeIE0H5wFkSJMLGL7bbBbVHFiASObflt6enzB7pNtAOsCJ5SfnjVM0qzU
         DsAt5+Y0lWc1bZWQYy0qW+AGeElWSgfI5PbNHmqb7DVC/5y3ep7THOPd0stt/fLr1jvf
         kbYvP5NZoKy4ok3mkBC8h8Ff8ASLVcTACkrKbVLVgeauVBV5DU4Ln82qPeVR6YbIDGtM
         VraA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753916067; x=1754520867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t7x2O+/3mlZ+l6d/dEpYOvhMfX3zDYsyk28CoMvKB+w=;
        b=GIJFHtyf09suzoPKMifqowfNx2oSzMKWoUJdXDy0WqT8Q23DL6h2oSJOPJji51hpBa
         MBnk3wbtdC11klnSUBDP2+PopKlBtZ07pa2Ey9ChtuYTASi/WKtb9ONFid3eMwHeKP6n
         ae/cr3Q6mw5O1ZTf4oOxfdYiz6Nfc/97JbjcArKucWjlWA2QDwCcxMuQFVGdxnIcFsQP
         nkiq7E1Hn+1MxjwtETdnZ3F8CHhPtU0XtRhzc8QOhqvL459Wt6mIWJEJ0jjdGTDal5Dl
         GpgsDTkCiEvQL8cmL70RxyEtcleGnzhD2Ewq27udBe95jVXix6zsKENyW5s+0DIiNPPf
         pdBw==
X-Forwarded-Encrypted: i=1; AJvYcCXXHjUbXtFjl3t3eEo5zYeLhnXr66/vPHQeujJ3UGNhppm4bLQ7HEiZYE/IE67Tum8Js4FVy5pCkw==@kvack.org
X-Gm-Message-State: AOJu0YwgwOO1Evk2A4P0LUSMsSlGCTiRQnniRbk4ZKd2djyzxj5ihhH4
	tUbzW0F+2I7Y7JZKg3Ixfvo/sipHbjgnGSy6d6x0v8lAUHjzvdTCMq20CVMXDKYOLRudwTmpaFB
	+nVeszVxm6e6DCpkhlmUEsJrA/mTrpu2pIfY1nAQ=
X-Gm-Gg: ASbGnctl0mPkZE2YWH9RRgvQc1NAh4IN2vbn7rPF5Bsd2bhryQ1LkylRGc8+WbEzjGC
	rW7oMvAc96oYUhe6Kx/opF1LfqeZiutpvOQOM2MNERkq0Q9ooYrsAgJKSJZlK0RnSn1qvhxbfu9
	AyfvVFBnDThTvAfgOjLXUS72dioZmNb5uHueyiNf6pneocUZ81c+aJ0ItZk2ZkVAAmX2+b/vIKg
	ISLcbG26lIUtZwG+g==
X-Google-Smtp-Source: AGHT+IE3gTZ85BCBwLQ0fCe6kQ6ib21Oo5WSfpehSS1BBczqmefHEgbEcmysVIEVfQKV/+OP8jG24Ai+6x/al/9/eqk=
X-Received: by 2002:ac8:580d:0:b0:4ab:667e:93f1 with SMTP id
 d75a77b69052e-4aedbc4b8aamr92091181cf.48.1753916066703; Wed, 30 Jul 2025
 15:54:26 -0700 (PDT)
MIME-Version: 1.0
References: <20250723212020.GY2672070@frogsfrogsfrogs> <CAJnrk1bFWRTGnpNhW_9MwSYZw3qPnPXZBeiwtPSrMhCvb9C3qg@mail.gmail.com>
 <CAJnrk1byTVJtuOyAyZSVYrusjhA-bW6pxBOQQopgHHbD3cDUHw@mail.gmail.com>
 <CAJnrk1ZYR=hM5k90H57tOv=fe6F-r8dO+f3wNuCT_w3j8YNYNQ@mail.gmail.com>
 <20250728171425.GR2672029@frogsfrogsfrogs> <CAJnrk1bBesBijYRD1Wf_01OSBykJ0VzwFZKZFev0wPn9wYc98Q@mail.gmail.com>
 <20250728191117.GE2672070@frogsfrogsfrogs> <CAJnrk1bTgTcb4aUWqczXEH+7+SWQAdppxYbSAPNCVY6xXb-=hQ@mail.gmail.com>
 <20250729202151.GD2672049@frogsfrogsfrogs> <CAJnrk1ZXN40WEwKXn7ycy2topGTvxFh_UfsM_vwhM+0CtTsJKQ@mail.gmail.com>
 <20250729234018.GW2672029@frogsfrogsfrogs>
In-Reply-To: <20250729234018.GW2672029@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 30 Jul 2025 15:54:15 -0700
X-Gm-Features: Ac12FXzGxWFWHF6oVrKTFLWe0DFHviK4ZwZ4SMKMH5xLKbAvpddy60UsHkq8GcU
Message-ID: <CAJnrk1b691Z3=_V0dU2Vb2qbiQd+0JUMj1ABDMip6vzzGZAf3w@mail.gmail.com>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ED1744000A
X-Stat-Signature: jdbcp6juw4pwd1mi7hc6qsgfn5gh9apn
X-Rspam-User: 
X-HE-Tag: 1753916067-328062
X-HE-Meta: U2FsdGVkX1/yrGQRUzDc807hwCXsuPEbxSpCxTC13Js/tSe0Y8vdkFsqbcS7fERLlr/R4h2o6CpgbLyhUmYMbgTJyL0RtpIeHttqw9g9FomOyTY5UHiT3oQhwtAyKT7PNpxBEWajO9UXdeY4f+F93wAKnkJl5tXel+5Y7WUd67g9R6HXAbcFFE2vdEA+ZzSLM64iNKH542eoPAFYOy/BnPvaTS5nEq36BVS8xn7eRG+5xo7LJo4IWccxMZvleMaHJgcoI12rOY4CBdzwIcB1cegLjz4MJv8RtOKzqbm7TGZWSqqUt6Z1wtxm+INFv3vQfi1GgABL3BPquQdoSuOM47HFA+AVB18CpxAW/McvDyGm4707/Nrf9Ffn35/5Re7tYM1eTQ0H8MDvyYgW79HRoLLniCdv94LP9uom+fO3BKDShG8B/79QTaxqtxY+xiPYj8ixZxtEDCz+tltWLCrkE97HJ6WVDBkDTTL7y1lElqKPXVCLUHnExc+3k/csz3TI3ntOOUiDM+ZqHv2tpgnSH1qwc838vlC9XqP5gjP7Tzibpvxt4FnNhC7ecyUYCJ7fntw9/c5So4DiBImMy0dTnxApip20JP8liaV6SH8MW1jkESt3D7eQ0bKXWuDHHnGYpuvy60k9+6e2UZDwKihV3F+4ailtQzcSCTuBeCY4idftYYZ4TYYSrcL69+Ec/UQokttanc4a0eIEWZBTcCAOwnBFZY9APkRFav/XBKS2iA2yDHm5EDEAFNd2wYDlx3sC05LexpfUP9De5a7BX8tksG8r5N7/ztHfeSnnQHy2pjxGACYglmELy23m9EXp3DEpOGcQHkE1U5wh+hlfHvPTFYCJ+EfUhquqQAQ8HusXlkTZP9U+vD35LMWgx46/EE3tW740Akv/E2N+UO+bgowh4hkdM96qzf441PzrPR8B2eiw7OwFzQTev1GS3VXC6YRMVm4bDHATz5L25x9HDqH
 JW4o+MbD
 dRzSImXrRZ3ELZNr8iKdKoqafvc7ZvF6tAppbZvtMBCPv8YZPx6AIrJwZPkkVwNGe+8IoX38g8a8b+VQnjtkgXsqoxwpi84mB6Q4CEtQmLKVp2Oq6S2rliF2D6K+drCtN+EIN3yoz0+JhbKRF1Fke2D/JPFGVnR9SRWwNASZmVJjAN/juk91mWd3LVVscmiGi5KBrVMCz2D5W5DX3vpywWv5vy458HclHMciit1I0pK6iofqxgBVLEnbEOW78zAqUha/yYdziK9V0AnYugAqNR1Q/D02FkkktqCp2PXeE42XdkzP4BuLJ/1uSHAC/rZV4BipB52NS4me8TKmubSWxJvR9PmIcLGXnUgGEUrAtqy4MD81ZwH/4v26+PLxe8nlWSD7gLvjzUc+gbZozO2qPmEflY8sZ6Ja2DcMhxjOqWvcSPCZF2RgI7TDo339w/ERdjz0Pq6mGLcxC+AOkeqblbKt0RqA6azVdbClwF+PlFc/Eqb7xF9EDcXEKV3s9voZH++63rJsuqUN+AwwMfl9Vg1aYFeqMCKMXWOJR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 4:40=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Tue, Jul 29, 2025 at 04:23:02PM -0700, Joanne Koong wrote:
> > On Tue, Jul 29, 2025 at 1:21=E2=80=AFPM Darrick J. Wong <djwong@kernel.=
org> wrote:
> > >
> > > On Mon, Jul 28, 2025 at 02:28:31PM -0700, Joanne Koong wrote:
> > > > On Mon, Jul 28, 2025 at 12:11=E2=80=AFPM Darrick J. Wong <djwong@ke=
rnel.org> wrote:
> > > > >
> > > > > On Mon, Jul 28, 2025 at 10:44:01AM -0700, Joanne Koong wrote:
> > > > > > On Mon, Jul 28, 2025 at 10:14=E2=80=AFAM Darrick J. Wong <djwon=
g@kernel.org> wrote:
> > > > > > >
> > > > > > > On Fri, Jul 25, 2025 at 06:16:15PM -0700, Joanne Koong wrote:
> > > > > > > > On Thu, Jul 24, 2025 at 12:14=E2=80=AFPM Joanne Koong <joan=
nelkoong@gmail.com> wrote:
> > > > > > > > >
> > > > > > > > > On Wed, Jul 23, 2025 at 3:37=E2=80=AFPM Joanne Koong <joa=
nnelkoong@gmail.com> wrote:
> > > > > > > > > >
> > > > > > > > > > On Wed, Jul 23, 2025 at 2:20=E2=80=AFPM Darrick J. Wong=
 <djwong@kernel.org> wrote:
> > > > > > > > > > >
> > > > > > > > > > > On Wed, Jul 23, 2025 at 11:42:42AM -0700, Joanne Koon=
g wrote:
> > > > > > > > > > > > On Wed, Jul 23, 2025 at 7:46=E2=80=AFAM Darrick J. =
Wong <djwong@kernel.org> wrote:
> > > > > > > > > > > > >
> > > > > > > > > > > > > [cc Joanne]
> > > > > > > > > > > > >
> > > > > > > > > > > > > On Wed, Jul 23, 2025 at 05:14:28PM +0530, Naresh =
Kamboju wrote:
> > > > > > > > > > > > > > Test regression: next-20250721 arm64 16K and 64=
K page size WARNING fs
> > > > > > > > > > > > > > fuse file.c at fuse_iomap_writeback_range
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > Reported-by: Linux Kernel Functional Testing <l=
kft@linaro.org>
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > ## Test log
> > > > > > > > > > > > > > ------------[ cut here ]------------
> > > > > > > > > > > > > > [  343.828105] WARNING: fs/fuse/file.c:2146 at
> > > > > > > > > > > > > > fuse_iomap_writeback_range+0x478/0x558 [fuse], =
CPU#0: msync04/4190
> > > > > > > > > > > > >
> > > > > > > > > > > > >         WARN_ON_ONCE(len & (PAGE_SIZE - 1));
> > > > > > > > > > > > >
> > > > > > > > > > > > > /me speculates that this might be triggered by an=
 attempt to write back
> > > > > > > > > > > > > some 4k fsblock within a 16/64k base page?
> > > > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > > I think this can happen on 4k base pages as well ac=
tually. On the
> > > > > > > > > > > > iomap side, the length passed is always block-align=
ed and in fuse, we
> > > > > > > > > > > > set blkbits to be PAGE_SHIFT so theoretically block=
-aligned is always
> > > > > > > > > > > > page-aligned, but I missed that if it's a "fuseblk"=
 filesystem, that
> > > > > > > > > > > > isn't true and the blocksize is initialized to a de=
fault size of 512
> > > > > > > > > > > > or whatever block size is passed in when it's mount=
ed.
> > > > > > > > > > >
> > > > > > > > > > > <nod> I think you're correct.
> > > > > > > > > > >
> > > > > > > > > > > > I'll send out a patch to remove this line. It doesn=
't make any
> > > > > > > > > > > > difference for fuse_iomap_writeback_range() logic w=
hether len is
> > > > > > > > > > > > page-aligned or not; I had added it as a sanity-che=
ck against sketchy
> > > > > > > > > > > > ranges.
> > > > > > > > > > > >
> > > > > > > > > > > > Also, I just noticed that apparently the blocksize =
can change
> > > > > > > > > > > > dynamically for an inode in fuse through getattr re=
plies from the
> > > > > > > > > > > > server (see fuse_change_attributes_common()). This =
is a problem since
> > > > > > > > > > > > the iomap uses inode->i_blkbits for reading/writing=
 to the bitmap. I
> > > > > > > > > > > > think we will have to cache the inode blkbits in th=
e iomap_folio_state
> > > > > > > > > > > > struct unfortunately :( I'll think about this some =
more and send out a
> > > > > > > > > > > > patch for this.
> > > > > > > > > > >
> > > > > > > > > > > From my understanding of the iomap code, it's possibl=
e to do that if you
> > > > > > > > > > > flush and unmap the entire pagecache (whilst holding =
i_rwsem and
> > > > > > > > > > > mmap_invalidate_lock) before you change i_blkbits.  N=
obody *does* this
> > > > > > > > > > > so I have no idea if it actually works, however.  Not=
e that even I don't
> > > > > > > > > > > implement the flush and unmap bit; I just scream loud=
ly and do nothing:
> > > > > > > > > >
> > > > > > > > > > lol! i wish I could scream loudly and do nothing too fo=
r my case.
> > > > > > > > > >
> > > > > > > > > > AFAICT, I think I just need to flush and unmap that fil=
e and can leave
> > > > > > > > > > the rest of the files/folios in the pagecache as is? Bu=
t then if the
> > > > > > > > > > file has active refcounts on it or has been pinned into=
 memory, can I
> > > > > > > > > > still unmap and remove it from the page cache? I see th=
e
> > > > > > > > > > invalidate_inode_pages2() function but my understanding=
 is that the
> > > > > > > > > > page still stays in the cache if it has has active refe=
rences, and if
> > > > > > > > > > the page gets mmaped and there's a page fault on it, it=
'll end up
> > > > > > > > > > using the preexisting old page in the page cache.
> > > > > > > > >
> > > > > > > > > Never mind, I was mistaken about this. Johannes confirmed=
 that even if
> > > > > > > > > there's active refcounts on the folio, it'll still get re=
moved from
> > > > > > > > > the page cache after unmapping and the page cache referen=
ce will get
> > > > > > > > > dropped.
> > > > > > > > >
> > > > > > > > > I think I can just do what you suggested and call
> > > > > > > > > filemap_invalidate_inode() in fuse_change_attributes_comm=
on() then if
> > > > > > > > > the inode blksize gets changed. Thanks for the suggestion=
!
> > > > > > > > >
> > > > > > > >
> > > > > > > > Thinking about this some more, I don't think this works aft=
er all
> > > > > > > > because the writeback + page cache removal and inode blkbit=
s update
> > > > > > > > needs to be atomic, else after we write back and remove the=
 pages from
> > > > > > > > the page cache, a write could be issued right before we upd=
ate the
> > > > > > > > inode blkbits. I don't think we can hold the inode lock the=
 whole time
> > > > > > > > for it either since writeback could be intensive. (also btw=
, I
> > > > > > > > realized in hindsight that invalidate_inode_pages2_range() =
would have
> > > > > > > > been the better function to call instead of
> > > > > > > > filemap_invalidate_inode()).
> > > > > > > >
> > > > > > > > > >
> > > > > > > > > > I don't think I really need to have it removed from the=
 page cache so
> > > > > > > > > > much as just have the ifs state for all the folios in t=
he file freed
> > > > > > > > > > (after flushing the file) so that it can start over wit=
h a new ifs.
> > > > > > > > > > Ideally we could just flush the file, then iterate thro=
ugh all the
> > > > > > > > > > folios in the mapping in order of ascending index, and =
kfree their
> > > > > > > > > > ->private, but I'm not seeing how we can prevent the ca=
se of new
> > > > > > > > > > writes / a new ifs getting allocated for folios at prev=
ious indexes
> > > > > > > > > > while we're trying to do the iteration/kfreeing.
> > > > > > > > > >
> > > > > > > >
> > > > > > > > Going back to this idea, I think this can work. I realized =
we don't
> > > > > > > > need to flush the file, it's enough to free the ifs, then u=
pdate the
> > > > > > > > inode->i_blkbits, then reallocate the ifs (which will now u=
se the
> > > > > > > > updated blkbits size), and if we hold the inode lock throug=
hout, that
> > > > > > > > prevents any concurrent writes.
> > > > > > > > Something like:
> > > > > > > >      inode_lock(inode);
> > > > > > > >      XA_STATE(xas, &mapping->i_pages, 0);
> > > > > > > >      xa_lock_irq(&mapping->i_pages);
> > > > > > > >      xas_for_each_marked(&xas, folio, ULONG_MAX, PAGECACHE_=
TAG_DIRTY) {
> > > > > > > >           folio_lock(folio);
> > > > > > > >           if (folio_test_dirty(folio)) {
> > > > > > > >                   folio_wait_writeback(folio);
> > > > > > > >                   kfree(folio->private);
> > > > > > > >           }
> > > > >
> > > > > Heh, I didn't even see this chunk, distracted as I am today. :/
> > > > >
> > > > > So this doesn't actually /initiate/ writeback, it just waits
> > > > > (potentially for a long time) for someone else to come along and =
do it.
> > > > > That might not be what you want since the blocksize change will a=
ppear
> > > > > to stall while nothing else is going on in the system.
> > > >
> > > > I thought if the folio isn't under writeback then
> > > > folio_wait_writeback() just returns immediately as a no-op.
> > > > I don't think we need/want to initiate writeback, I think we only n=
eed
> > > > to ensure that if it is already under writeback, that writeback
> > > > finishes while it uses the old i_blksize so nothing gets corrupted.=
 As
> > > > I understand it (but maybe I'm misjudging this), holding the inode
> > > > lock and then initiating writeback is too much given that writeback
> > > > can take a long time (eg if the fuse server writes the data over so=
me
> > > > network).
> > > >
> > > > >
> > > > > Also, unless you're going to put this in buffered-io.c, it's not
> > > > > desirable for a piece of code to free something it didn't allocat=
e.
> > > > > IOWs, I don't think it's a good idea for *fuse* to go messing wit=
h a
> > > > > folio->private that iomap set.
> > > >
> > > > Okay, good point. I agree. I was hoping to have this not bleed into
> > > > the iomap library but maybe there's no getting around that in a goo=
d
> > > > way.
> > >
> > > <shrug> Any other filesystem that has mutable file block size is goin=
g
> > > to need something to enact a change.
> > >
> > > > >
> > > > > > > >           folio_unlock(folio);
> > > > > > > >      }
> > > > > > > >     inode->i_blkbits =3D new_blkbits_size;
> > > > > > >
> > > > > > > The trouble is, you also have to resize the iomap_folio_state=
 objects
> > > > > > > attached to each folio if you change i_blkbits...
> > > > > >
> > > > > > I think the iomap_folio_state objects automatically get resized=
 here,
> > > > > > no? We first kfree the folio->private which kfrees the entire i=
fs,
> > > > >
> > > > > Err, right, it does free the ifs and recreate it later if necessa=
ry.
> > > > >
> > > > > > then we change inode->i_blkbits to the new size, then when we c=
all
> > > > > > folio_mark_dirty(), it'll create the new ifs which creates a ne=
w folio
> > > > > > state object using the new/updated i_blkbits size
> > > > > >
> > > > > > >
> > > > > > > >     xas_set(&xas, 0);
> > > > > > > >     xas_for_each_marked(&xas, folio, ULONG_MAX, PAGECACHE_T=
AG_DIRTY) {
> > > > > > > >           folio_lock(folio);
> > > > > > > >           if (folio_test_dirty(folio) && !folio_test_writeb=
ack(folio))
> > > > > > > >                  folio_mark_dirty(folio);
> > > > > > >
> > > > > > > ...because iomap_dirty_folio doesn't know how to reallocate t=
he folio
> > > > > > > state object in response to i_blkbits having changed.
> > > > >
> > > > > Also, what about clean folios that have an ifs?  You'd still need=
 to
> > > > > handle the ifs's attached to those.
> > > >
> > > > Ah you're right, there could be clean folios there too that have an
> > > > ifs. I think in the above logic, if we iterate through all
> > > > mapping->i_pages (not just PAGECACHE_TAG_DIRTY marked ones) and mov=
e
> > > > the kfree to after the "if (folio_test_dirty(folio))" block, then i=
t
> > > > addresses that case. eg something like this:
> > > >
> > > >      inode_lock(inode);
> > > >      XA_STATE(xas, &mapping->i_pages, 0);
> > > >      xa_lock_irq(&mapping->i_pages);
> > > >      xas_for_each(&xas, folio, ULONG_MAX) {
> > > >           folio_lock(folio);
> > > >           if (folio_test_dirty(folio))
> > > >                   folio_wait_writeback(folio);
> > > >           kfree(folio->private);
> > > >           folio_unlock(folio);
> > > >      }
> > > >     inode->i_blkbits =3D new_blkbits;
> > > >     xas_set(&xas, 0);
> > > >     xas_for_each_marked(&xas, folio, ULONG_MAX, PAGECACHE_TAG_DIRTY=
) {
> > > >           folio_lock(folio);
> > > >           if (folio_test_dirty(folio) && !folio_test_writeback(foli=
o))
> > > >                  folio_mark_dirty(folio);
> > > >           folio_unlock(folio);
> > > >     }
> > > >     xa_unlock_irq(&mapping->i_pages);
> > > >     inode_unlock(inode);
> > > >
> > > >
> > > > >
> > > > > So I guess if you wanted iomap to handle a blocksize change, you =
could
> > > > > do something like:
> > > > >
> > > > > iomap_change_file_blocksize(inode, new_blkbits) {
> > > > >         inode_lock()
> > > > >         filemap_invalidate_lock()
> > > > >
> > > > >         inode_dio_wait()
> > > > >         filemap_write_and_wait()
> > > > >         if (new_blkbits > mapping_min_folio_order()) {
> > > > >                 truncate_pagecache()
> > > > >                 inode->i_blkbits =3D new_blkbits;
> > > > >         } else {
> > > > >                 inode->i_blkbits =3D new_blkbits;
> > > > >                 xas_for_each(...) {
> > > > >                         <create new ifs>
> > > > >                         <translate uptodate/dirty state to new if=
s>
> > > > >                         <swap ifs>
> > > > >                         <free old ifs>
> > > > >                 }
> > > > >         }
> > > > >
> > > > >         filemap_invalidate_unlock()
> > > > >         inode_unlock()
> > > > > }
> > > >
> > > > Do you prefer this logic to the one above that walks through
> > > > &mapping->i_pages? If so, then I'll go with this way.
> > >
> > > Yes.  iomap should not be tightly bound to the pagecache's xarray; I
> > > don't even really like the xas_for_each that I suggested above.
> >
> > Okay, sounds good.
> >
> > >
> > > > The part I'm unsure about is that this logic seems more disruptive =
(eg
> > > > initiating writeback while holding the inode lock and doing work fo=
r
> > > > unmapping/page cache removal) than the other approach, but I guess
> > > > this is also rare enough that it doesn't matter much.
> > >
> > > I hope it's rare enough that doing truncate_pagecache unconditionally
> > > won't be seen as a huge burden.
> > >
> > > iomap_change_file_blocksize(inode, new_blkbits) {
> > >         inode_dio_wait()
> > >         filemap_write_and_wait()
> > >         truncate_pagecache()
> > >
> > >         inode->i_blkbits =3D new_blkbits;
> > > }
> > >
> > > fuse_file_change_blocksize(inode, new_blkbits) {
> > >         inode_lock()
> > >         filemap_invalidate_lock()
> > >
> > >         iomap_change_file_blocksize(inode, new_blkbits);
> > >
> > >         filemap_invalidate_unlock()
> > >         inode_unlock()
> > > }
> > >
> > > Though my question remains -- is there a fuse filesystem that changes
> > > the blocksize at runtime such that we can test this??
> >
> > There's not one currently but I was planning to hack up the libfuse
> > passthrough_hp server to test the change.
>
> Heh, ok.
>
> I guess I could also hack up fuse2fs to change its own blocksize
> randomly to see how many programs that pisses off. :)
>
> (Not right now though, gotta prepare for fossy tomorrow...)
>

What I've been using as a helpful sanity-check so far has been running
fstests generic/750 after adding this line to libfuse:

+++ b/lib/fuse_lowlevel.c
@@ -547,6 +547,8 @@ int fuse_reply_attr(fuse_req_t req, const struct stat *=
attr,
        arg.attr_valid_nsec =3D calc_timeout_nsec(attr_timeout);
        convert_stat(attr, &arg.attr);
+       arg.attr.blksize =3D 4096;
        return send_reply_ok(req, &arg, size);

and modifying the kernel side logic in fuse_change_attributes_common()
to unconditionally execute the page cache removal logic if
attr->blksize !=3D 0.


While running this however, I discovered another problem :/ we can't
grab the inode lock here in the fuse path because the vfs layer that
calls into this logic may already be holding the inode lock (eg the
stack traces I was seeing included path_openat()  ->
inode_permission() -> fuse_permission() which then fetches the
blksize, and the vfs rename path), while there are other call paths
that may not be holding the lock already.

I don't really see a good solution here. The simplest one imo would be
to cache "u8 blkbits" in the iomap_folio_state struct - are you okay
with that or do you think there's a better solution here?


Thanks,
Joanne

> --D
>
> > >
> > > --D
> > >
> > > > Thanks,
> > > > Joanne
> > > >
> > > > >
> > > > > --D
> > > > >
> > > > > > > --D
> > > > > > >
> > > > > > > >           folio_unlock(folio);
> > > > > > > >     }
> > > > > > > >     xa_unlock_irq(&mapping->i_pages);
> > > > > > > >     inode_unlock(inode);
> > > > > > > >
> > > > > > > >
> > > > > > > > I think this is the only approach that doesn't require chan=
ges to iomap.
> > > > > > > >
> > > > > > > > I'm going to think about this some more next week and will =
try to send
> > > > > > > > out a patch for this then.
> > > > > > > >
> > > > > > > >
> > > > > > > > Thanks,
> > > > > > > > Joanne
> > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > void fuse_iomap_set_i_blkbits(struct inode *inode, u8=
 new_blkbits)
> > > > > > > > > > > {
> > > > > > > > > > >         trace_fuse_iomap_set_i_blkbits(inode, new_blk=
bits);
> > > > > > > > > > >
> > > > > > > > > > >         if (inode->i_blkbits =3D=3D new_blkbits)
> > > > > > > > > > >                 return;
> > > > > > > > > > >
> > > > > > > > > > >         if (!S_ISREG(inode->i_mode))
> > > > > > > > > > >                 goto set_it;
> > > > > > > > > > >
> > > > > > > > > > >         /*
> > > > > > > > > > >          * iomap attaches per-block state to each fol=
io, so we cannot allow
> > > > > > > > > > >          * the file block size to change if there's a=
nything in the page cache.
> > > > > > > > > > >          * In theory, fuse servers should never be do=
ing this.
> > > > > > > > > > >          */
> > > > > > > > > > >         if (inode->i_mapping->nrpages > 0) {
> > > > > > > > > > >                 WARN_ON(inode->i_blkbits !=3D new_blk=
bits &&
> > > > > > > > > > >                         inode->i_mapping->nrpages > 0=
);
> > > > > > > > > > >                 return;
> > > > > > > > > > >         }
> > > > > > > > > > >
> > > > > > > > > > > set_it:
> > > > > > > > > > >         inode->i_blkbits =3D new_blkbits;
> > > > > > > > > > > }
> > > > > > > > > > >
> > > > > > > > > > > https://git.kernel.org/pub/scm/linux/kernel/git/djwon=
g/xfs-linux.git/commit/?h=3Dfuse-iomap-attrs&id=3Dda9b25d994c1140aae2f5ebf1=
0e54d0872f5c884
> > > > > > > > > > >
> > > > > > > > > > > --D
> > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > > Thanks,
> > > > > > > > > > > > Joanne
> > > > > > > > > > > >
> > > > > > > >
> > > >
> >

