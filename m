Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB3F0D4661B
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:47:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 500316B0100; Thu, 15 Jan 2026 14:47:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C0E76B0101; Thu, 15 Jan 2026 14:47:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C3CB6B0102; Thu, 15 Jan 2026 14:47:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 28E346B0100
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:47:43 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF5F7160491
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:47:42 +0000 (UTC)
X-FDA: 84335233164.11.4A8FE79
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf06.hostedemail.com (Postfix) with ESMTP id ED1A1180003
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:47:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ihLVkCZt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=amir73il@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768506461; a=rsa-sha256;
	cv=none;
	b=A24oxf6lmVnPygL0doeCL/Zgd1Db/Rt9ygPYzldwxUwJvZTpH0VdNH0zsKZCD20BxFOWvs
	y/4Z28pLQ8pR3QKdzkmCy+63BqJiNleZdh5rU74HniVJXEorV4/RAYKIkfh8BMiILWHK7z
	CNwFUZ18Sr9y0OVpHmvd3PsgteMwUXA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ihLVkCZt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=amir73il@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768506461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3/OO8RKyY0YoEvp6ZTLVXNCVFpOv1g0hFAjXGWT4AHc=;
	b=7uZpWRjwW7HcBYKf26jbKjzKu97qHhEv9KmQoD3xiW8ryw3sQzBL6E0G3eqX2E8ro2AuqQ
	/v0s2mE5uzQ4GuyzWf/Y06uvKsttKgigQhT+oeFjAGNHoKOFW2310iqTNwNr9rpSHgeneb
	p5vlDG1PK+a7f6A7W3eTDid6Qx9PrZI=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-64b9b0b4d5dso2825322a12.1
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:47:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768506459; x=1769111259; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3/OO8RKyY0YoEvp6ZTLVXNCVFpOv1g0hFAjXGWT4AHc=;
        b=ihLVkCZt0TyPxfANmPYWkKWFIooom15Vi34/vpB/we/TCIrja+XzDFMKXy6wwYTorz
         CFZMz8KSYDKVYbwVT0hKrjuBHrTqJu0rRtmTxs5K1HMGQ9cc5Tc42WfqsaArkt7oWLF8
         kpM0rlpa8IYZu0z6qT5yLKUlicjeMoxwtkzx+ftI4Gw6eEDP7bb2uRQwjGTxNSdJsshs
         IDmjZl92PpjbgVypc7R0WdGx4GNqRWwlCafazaxzbQWE3kt5SEWdhDHbiFXsxHJj9bFI
         a/TdvBICS9Ntyjna7VhajE/IQ3HKe10A04xAVZTe5FV2k+SWTTpdH1jqUZWmbNNYlYjM
         SOkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768506459; x=1769111259;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3/OO8RKyY0YoEvp6ZTLVXNCVFpOv1g0hFAjXGWT4AHc=;
        b=qPIy4mY6hbfaZgOS29K4ltOdDnCj9+lvNf1ZfJ1F6STaO5GUYfHIdUQcNwaJbabG4P
         wk7re5jBd1Sno3Yd3Ujr48MJQy3nxD1NulDKWDofOuCHp6BQNs+VYFFWOrH106EP1T8u
         Gts7LBagrGCN02Tb8vFSVyAe7bZLaSeD3ICPhratbQiAQ9jfoxd+ft/XVcOmRoJqZeJM
         6jEVyWkqoCpvJJQFOpSP9hW4NHXYfh7UbtbOQAmzBP0msBCMocHhyqNm6tq+P3uXShdN
         i1BkpOnm4Zrzj0EVnNYXUr5zIfArh6/6Yovvlj2h9/+xN6dW9B8XWZQi7/8gbfVvLOHV
         HxIA==
X-Forwarded-Encrypted: i=1; AJvYcCUC3uq0e1H1w6r7RiXXimaBlZboAttv/sQzmOLAJM7ZfLNy0SlNvW3N/nIT6/xhbnhGw/JwX0Ns4w==@kvack.org
X-Gm-Message-State: AOJu0Ywa+isVIhbPdH7mf0vuMNk4GfTgjgLYDc8cDpdQip+ZRbUNt1cC
	IyKd5sXRsZfMLLev0Oh+oGkRqcdT6PCDuK0yJo3Nd6azV0PYt4S2NGTwKlDtm46tQ6g01thJMjl
	8hktVj692w4vhau9dRFyQ62q/J9/xc2Q=
X-Gm-Gg: AY/fxX6nnJYfOC0xO7kaTLkDkpUGtcThNrQA+nX5awltlhZPnt3shgD3K+noog9fC7E
	Q7M56M3BN/3VqLk3hnZTW5IvxQn3EWeiBxWqU/NmJzd6WqIsH2JHOOID9jpW/z+xW6uvoYK/X1l
	CAvsQUbEVV4lQYKwCczyk130Jh+j4JcF4LF21d/5pdQImsEQZOq5IVPl4X6b1VEMdKVuljzmDC7
	yDN+gcOoUCXDkaLOFyu/+eRQ2snXysa04yB7Chf7L+cP4G6ReSfviT13wDuUaVaSg80kY31ZL+L
	P33fDv3N/Y2QX5WAwQ8Poejg76VMdg==
X-Received: by 2002:a05:6402:268e:b0:64b:7231:da3d with SMTP id
 4fb4d7f45d1cf-654b955cf01mr167575a12.9.1768506459177; Thu, 15 Jan 2026
 11:47:39 -0800 (PST)
MIME-Version: 1.0
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>
 <d486fdb8-686c-4426-9fac-49b7dbc28765@app.fastmail.com> <CAOQ4uxhnoTC6KBmRVx2xhvTXYg1hRkCJWrq2eoBQGHKC3sv3Hw@mail.gmail.com>
 <4d9967cc-a454-46cf-909b-b8ab2d18358d@kernel.org>
In-Reply-To: <4d9967cc-a454-46cf-909b-b8ab2d18358d@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 15 Jan 2026 20:47:27 +0100
X-Gm-Features: AZwV_QhMfL4hQaeUnA-dk4TL1Qjc8lTmxpbV_QcnWyLhkyyZFquuhwL6kPGc4Cw
Message-ID: <CAOQ4uxhtorpd6FVsaGO=NdRD72MxeDyabip84ctQYSNufobS8w@mail.gmail.com>
Subject: Re: [PATCH 00/29] fs: require filesystems to explicitly opt-in to
 nfsd export support
To: Chuck Lever <cel@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Chuck Lever <chuck.lever@oracle.com>, 
	NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, 
	Tom Talpey <tom@talpey.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Carlos Maiolino <cem@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>, 
	Andreas Gruenbacher <agruenba@redhat.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org, 
	devel@lists.orangefs.org, ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, 
	linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: ED1A1180003
X-Stat-Signature: 9dqrg1kkwjze74ka69fqdy7huu84ccq6
X-Rspam-User: 
X-HE-Tag: 1768506460-990855
X-HE-Meta: U2FsdGVkX19yN01yZuiR3YUiVNlA74Cb4gIbQiP8ZvStAYWQGhlXfSC5ptmRyttiMZrJrPlbuzIoBhj2+HMool5Dbx/dSp8wTcOCrII1b/rYMJU1bCqb1IwkeukAi+du3Kf493YPf3WlcefjyqjCsM1WCkiDhGEpGwkK/E/7a45skst5NKi1oRLg3fGdpZ8GtZy4+34vc2hET5ZzJ+6c29ptyiu09I5T9K5wGHMSIJTGtAOfVuOH4q+zh1EcjmuQW3zAA0MRuj0FXAeMnfhDecuMzBBn6YPFWJKYcMKHLXhIZR/RZrB0BUpuBlOFk6W6M3sD1Qjzrdtb45LrnXg/F+9wi0bL2nGeB2hGSWXzlMtehDQTsAlhSTX1PJyIF3oJNGs1ZGb8AMl1W+xnV5h4j7J1RjV2tFybchIiUlTgMU5Dnv2BuAA4agSHJizMzuWH26kvqfJ+0IZJPNo4naHC/P9SuKmA3rze3V0eafwjj6Sj2W8/L5N4lZ5tUolQCvoZTKMl9UTeAXEiLI5RyJrcic+IlOYDyElb6LEDzk14oVQzUoV0enaLhwOgtZyHZJNLk/2RPSAwfvj9DYXKVH3SpTsJUBJJApbdQmvEh7390+ektJF8/pNB+O3UsLHNTRvBSDB9SgLCOM0xy3B20U/BzE+GzrTuE9ZeHNHUCTpbX4vT2lQt1S3eNKXA6J/8H23KMVqRg6LKb8FMJcKRIgreT1rlZscFvZuHpPGqHnHISrd+PziCd9FM0pvPZPxBIZkVYFKu7V3NrB8Nd1fMd5gpiLd0Y//dHd51orWlbEjgF61LHHexRInJxfJuuv3pLgh+raNyPiEvV8LSz8stl4AoheEucJ0tprt7Yuvsi6eihFIz1wqMYeW/HmBhD52vVXikEjfiUnJIPOBsjKJWmQAfyeuWZappQRrxXdEj65Z1rM7GLru9JahL5bkjAiv6bCIguFai8TiVGa+6n5vzla9
 DCA+LLtO
 T6QfdFOmQf0iJZFs29X9FyAw56vF3WVkXDfItVYxbMOUn4H8kmO/af9jyWU6orItDyCeDBCneyoBIQ4Fv+4b0rHS06VLiOEdhdeG3ptXY3UZSCdzWWfxcc88gKBjJ16sQ6R4wfdzGVySV1lqZ5yd8eKR8QtVPbg2MIED1GP4JXPjfLDIiRpklJSrSfI9xBtPQljzj8oxWRIN2mpr9oFstatl2d0LaX0/Lw83KBG2HWhVcq8TVLGv/1NixrzO3M2lBE0dH9pB6IwMO4ivaL+pl0qHNRNN5UKXlFnJPmS6lk/DxiUmfpoccB80MbJQ6FJCP0f21fgfYKhYdpWfGgmDJvCPGAaD1H7GPqJpelhYSlg5+E4QTwMm2k/3iamt7BsBUaQQIucyFv5Ix+4U8iHQbRXELUYZuuZvPddqS/eOVu59RyIYWxHKFy2OQ9ZZlpcvd0GI+oVUOEkftxQxy9MwcLfozVEoxtE8bidW7vESxdrEdOwpVqTyL4Vy26/X2mWCsUq+giWeStXmG01xiKZRxsaCSPhJgoih8H+o8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 8:37=E2=80=AFPM Chuck Lever <cel@kernel.org> wrote:
>
> On 1/15/26 2:14 PM, Amir Goldstein wrote:
> > On Thu, Jan 15, 2026 at 7:32=E2=80=AFPM Chuck Lever <cel@kernel.org> wr=
ote:
> >>
> >>
> >>
> >> On Thu, Jan 15, 2026, at 1:17 PM, Amir Goldstein wrote:
> >>> On Thu, Jan 15, 2026 at 6:48=E2=80=AFPM Jeff Layton <jlayton@kernel.o=
rg> wrote:
> >>>>
> >>>> In recent years, a number of filesystems that can't present stable
> >>>> filehandles have grown struct export_operations. They've mostly done
> >>>> this for local use-cases (enabling open_by_handle_at() and the like)=
.
> >>>> Unfortunately, having export_operations is generally sufficient to m=
ake
> >>>> a filesystem be considered exportable via nfsd, but that requires th=
at
> >>>> the server present stable filehandles.
> >>>
> >>> Where does the term "stable file handles" come from? and what does it=
 mean?
> >>> Why not "persistent handles", which is described in NFS and SMB specs=
?
> >>>
> >>> Not to mention that EXPORT_OP_PERSISTENT_HANDLES was Acked
> >>> by both Christoph and Christian:
> >>>
> >>> https://lore.kernel.org/linux-fsdevel/20260115-rundgang-leihgabe-1201=
8e93c00c@brauner/
> >>>
> >>> Am I missing anything?
> >>
> >> PERSISTENT generally implies that the file handle is saved on
> >> persistent storage. This is not true of tmpfs.
> >
> > That's one way of interpreting "persistent".
> > Another way is "continuing to exist or occur over a prolonged period."
> > which works well for tmpfs that is mounted for a long time.
>
> I think we can be a lot more precise about the guarantee: The file
> handle does not change for the life of the inode it represents. It
> has nothing to do with whether the file system is mounted.
>
>
> > But I am confused, because I went looking for where Jeff said that
> > you suggested stable file handles and this is what I found that you wro=
te:
> >
> > "tmpfs filehandles align quite well with the traditional definition
> >  of persistent filehandles. tmpfs filehandles live as long as tmpfs fil=
es do,
> >  and that is all that is required to be considered "persistent".
>
> I changed my mind about the name, and I let Jeff know that privately
> when he asked me to look at these patches this morning.
>
>
> >> The use of "stable" means that the file handle is stable for
> >> the life of the file. This /is/ true of tmpfs.
> >
> > I can live with STABLE_HANDLES I don't mind as much,
> > I understand what it means, but the definition above is invented,
> > whereas the term persistent handles is well known and well defined.
>
> Another reason not to adopt the same terminology as NFS is that
> someone might come along and implement NFSv4's VOLATILE file
> handles in Linux, and then say "OK, /now/ can we export cgroupfs?"
> And then Linux will be stuck with overloaded terminology and we'll
> still want to say "NO, NFS doesn't support cgroupfs".
>
> Just a random thought.

Good argument. I'm fine with stable as well :)

Thanks,
Amir.

