Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BC54D0C84F
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 11:03:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A9F36B0005; Tue, 13 Jan 2026 06:03:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52E246B0089; Tue, 13 Jan 2026 06:03:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 402606B008A; Tue, 13 Jan 2026 06:03:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 28CC96B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 06:03:54 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C535F57B60
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:03:53 +0000 (UTC)
X-FDA: 84326655546.13.176CC14
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id C7F75140013
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:03:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TbTVetL0;
	spf=pass (imf09.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768302232; a=rsa-sha256;
	cv=none;
	b=ITjTMSALf65P6mH5Amjao2Cour983+2/wki2Inpy0ZPSQg74lBnM+GZRFvutyMOXwa9Z7p
	G4Ip9qQ4YuvF7NZbtfAxiSTzo8llRH5gei+i9EjWdXaoLM4nfv8Uvn6IXRDtI8am1nr5Yy
	VItLw1eh/Bw/o1Y860dloZAT0Zsr73E=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TbTVetL0;
	spf=pass (imf09.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768302232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1yKl/Pgo7Raivop2OmRTYwMbcW+Kn23aOzS6HQ4S0N8=;
	b=gUVNgD3UsxQFeNytcMh5AcBGPFHrtrwbQIU+OE4rtqoX0x4Fm9tPVSvKvE2UTwyaTaglwT
	Ug/1LDiUpeX/x7hf0oVzJMAZ3JFjGKAdxquoJrhwxc1PRNh87vK4G23zZCAJQPEWQvlfWR
	8lajET7TIX/tyrEi+SL0kMELUALN8m4=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6536e4d25e1so458937a12.1
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 03:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768302230; x=1768907030; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1yKl/Pgo7Raivop2OmRTYwMbcW+Kn23aOzS6HQ4S0N8=;
        b=TbTVetL0OPh4KH85rZdzHZR9tIJfr1o+LUym6rP7INapqaX73wstRjl4woAUCUuI6r
         MfQsIyxgp9JIKGdkgVXxwV6JfkzIlqI3W3C9vD0CEMhis42HCA7isLhA6oPNk13s3Euy
         qUrwDMPv1GjuDndF//UnpA13V4udv1/oj8YkYt4QETulOMqDXcbFZswNeqPOlt7dtDGQ
         cL8OeH8lse2ihsct7qqPVn0PT6okwYYy94FxTtyB6LanaOtZ42sjx7GCetd8O68V3Zg6
         Z7QC7V3oaHUaIncy6Ti8KTyiHn386gbjHZoennyDg9s8MGuI0zCK2zp7LiCmxrMjmT9s
         OUZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768302230; x=1768907030;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1yKl/Pgo7Raivop2OmRTYwMbcW+Kn23aOzS6HQ4S0N8=;
        b=pufhdWz9jVpJzyWIp/5c4iA5mVqkZqtHGiqm2qaU51pH61BsZX/BpvFy00hkqrM5DV
         mwMGvB97O0Pn0qkWSVKlw8BTQ64fopXMTK7N1Ry4kAH8Zi5JHhT86rfHT2C72f/fIr4x
         xprhn5rhDFFfEVBqSeSkaocUq8L/1jkkb0WbsYj1sPq20i3W5Bm+zosuJqWC1QHz+GSJ
         l+0uBT8kIQkJZu0JLuZOHG55WciheTF7G1GlwDVf+Sz1ko77mx6D9ee/V/gjGwOe2nc/
         rwlnVtXB3BWugY7zKkQe3q/LVl3wVD+KDCntITUc5N930H8ql4772lIjVi9LEJSuEB1t
         8UaA==
X-Forwarded-Encrypted: i=1; AJvYcCUThU2zAGY1/7WUEnYdup2ofQiYl9cHDcBsQvsBXlmwcaMhcH3nM10PHdsQHjcvp7usELH5wtob2w==@kvack.org
X-Gm-Message-State: AOJu0Yw/0LZK0J0vkcOLuGmon81K5fR91AbJa1KYQvrSCBFjgJ4TNRYl
	bWrolq0j0m7VO+04AYVqNIsBCctf1qnk5szxt2qJizE/Of/X7/anJ3FkXDFpViOroCnLGZ7Lbp1
	dn5ucM5Xh/zSU2KeP0+ilT0T5RIPPgCY=
X-Gm-Gg: AY/fxX7iGx0CwjYOeStjP1X2CrlDgRWe9K8MvHypdAXuROhsSsYQfawm7Af44IkSvMV
	TgdzYivQWfiZ28qNwabpPJj8bSLixX1Svblb4+OvMdVt3ctK9LnumPskgaEFA69yfB/4q3d3Auk
	LzK4MifdF91CPr7LoTNT5/Yz2/wjDo8L51JyaAdN+vqbFxmFzjk1wTB7tmlne6FPtiJb73P6GMF
	uSekXBvxpyY57XHYWA/6lp5EKmLf4Zfe7NH25bmpwohz/rllNI9GQfsxwvlgifP0pxvoAEbFEsh
	CV5WaJbQukSJ/YcfFOziLsVN8O2jt+2Gm2i9am8b
X-Google-Smtp-Source: AGHT+IGHaEgIcl6O956q/oR3KprTKLrAIzwQWNnZW6GHFV/gOuiO6RLC6EZuQAaL35CmbUpNO9gUAoXWjlG3/ZomGCY=
X-Received: by 2002:a05:6402:2110:b0:64d:170:79a3 with SMTP id
 4fb4d7f45d1cf-65097e59bfemr21502908a12.20.1768302229797; Tue, 13 Jan 2026
 03:03:49 -0800 (PST)
MIME-Version: 1.0
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
 <m3mywef74xhcakianlrovrnaadnhzhfqjfusulkcnyioforfml@j2xnk7dzkmv4>
 <8af369636c32b868f83669c49aea708ca3b894ac.camel@kernel.org>
 <CAOQ4uxgD+Sgbbg9K2U0SF9TyUOBb==Z6auShUWc4FfPaDCQ=rg@mail.gmail.com>
 <ec78bf021fa1f6243798945943541ba171e337e7.camel@kernel.org>
 <cb5d2da6-2090-4639-ad96-138342bba56d@oracle.com> <ce700ee20834631eceededc8cd15fc5d00fee28e.camel@kernel.org>
 <20260113-mondlicht-raven-82fc4eb70e9d@brauner>
In-Reply-To: <20260113-mondlicht-raven-82fc4eb70e9d@brauner>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 13 Jan 2026 12:03:37 +0100
X-Gm-Features: AZwV_QgaTvXrJUOdIQ16Jho9rlbp9FwpQ0OxyPEQ1mLXrbEA1iJpt9y0FKtnu9k
Message-ID: <CAOQ4uxhkaGFtQRzTj2xaf2GJucoAY5CGiyUjB=8YA2zTbOtFvw@mail.gmail.com>
Subject: Re: [PATCH 00/24] vfs: require filesystems to explicitly opt-in to
 lease support
To: Christian Brauner <brauner@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, Jan Kara <jack@suse.cz>, 
	Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	Nicolas Pitre <nico@fluxnic.net>, Christoph Hellwig <hch@infradead.org>, Anders Larsen <al@alarsen.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, Jan Kara <jack@suse.com>, 
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Dave Kleikamp <shaggy@kernel.org>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Viacheslav Dubeyko <slava@dubeyko.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Phillip Lougher <phillip@squashfs.org.uk>, 
	Carlos Maiolino <cem@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, Alexander Aring <alex.aring@gmail.com>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Eric Van Hensbergen <ericvh@kernel.org>, 
	Latchesar Ionkov <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>, 
	Christian Schoenebeck <linux_oss@crudebyte.com>, Xiubo Li <xiubli@redhat.com>, 
	Ilya Dryomov <idryomov@gmail.com>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	Hans de Goede <hansg@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, 
	ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org, 
	linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, 
	gfs2@lists.linux.dev, linux-doc@vger.kernel.org, v9fs@lists.linux.dev, 
	ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Content-Type: multipart/mixed; boundary="0000000000004374d1064842f2b9"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C7F75140013
X-Stat-Signature: 1gbt3d9u9h7mdbt5jshgw4we6jgnchg1
X-Rspam-User: 
X-HE-Tag: 1768302231-165136
X-HE-Meta: U2FsdGVkX182ClI76wi8pHrozRFbqM3QYKwHHghCIkQ/dsL4Gyhwit6CH0xMdmQCatgyQUfEtXbqqXQZAwVE2uaRHWkZlSoPLj6Hq/0qikTk8gVhmahjJhtqaOehV9Gb27MwV3/agTnrr1QalzPAZgqIGO63+xTn4MpAyREDmfcTGcgDm64sswOq1jp9hO7X5LJOOTwoc3nphHG6iy47LmG+yg/sHnO2HVh+FcwEjumHD1TvNXTNMQahMG1dJzgepdLWH3FAx+nsAMLQQTI8NsjMaoEoMXGVOzZnvPx9v8l1tlXpAnncXHd2C3NYDYCNFKiprbJVwQwm+Hm+Q8qWJrkP0sjl9j4qAgD1z7jum41e4Hwg2d7jgFrZmjUiZ1ZQYxvoP3AH2BtDcRtHD4sMA4jpZc3BDOAhV6OQTfTkd/Trfg9TR5c0FyOqPnGpejwrxy+qS/d5X+hBrokJyUcmBhEWgqGynYNzGYC7JoNME3lGhrHbutoM39Mo4ATnWs/VC1+tjnbYzeX7Xh7k74nBtWQWLeraLSRPcyXnIs0/ejuVhkFPE0hhLrC7fbygbdpYDmxOtodYkk1Dt6Z8RUVB170pegk1VNR2LuemiscwFCDqy9/KWhUrjLOOsSUkCbmsh3zG9K3ZOPKXCbO5NcCt8T/sua+WqEdmpGJOVP5ez+K1Th/VVxbRnyNwrdvaxebxAPLjMWrQR9Euem5Nz9c3HzAX4FzjSuOApwOQ/ysaDpSZAuUpK3P4mkFymwZI1399zjXSxhv5pmZ1+3N4QqrNWGRzPy0c6g9OXPiO/gwihKiw5vKJSz+UF5W/1k1rj2YeFia3BGCwdiTJ4hBERONSSCTK7m2y46NOfaRDw5/w5aGRu0v17XhSFuFWmGYAdeYvFIussTPe5GPRsO8Gmi3Rp3iUSyvbh1QBCFVcWWY5MlyLmasMVZnZTwnLyjvzzrAZ3QQ3s3ujdptfv3MAjp6
 aqOP1daX
 zc1AsTjl1i+AIPhjaKJOfHHYLNxo8QraAIu2GN6iitNnUk2xf7EvgLl+kC+J8Z3v6T7KZGP7TL66RDquN73VryFiwEH9EyOmyc98Q0iGwTW5+EllhYy+yIUC+8U0wT099gW1eqCvZuUDlh1+tiYl40YDAAmpbROvcTMZAH2c/ikzdF1AY6z1NP5YTZvPgEGo+ssyaIEmxRS14lIVJ0nqbnK//tAYcBVPJy6JVah6ne25VVpS2ETmoaC8Gd40Q7zgi8EjOuZD1iH7jNUn0qgdBoEp3bdq9GpK+sihg9BcJk7Kb1nzc7S7MWqtDMtTtXPCQpr97bneD1CBVhD1ckmg2lMW/+lz0CDvDXYU3B3bChOtI+T0fwHYSdcf4lk5mBZLo7otjNU0qHwQP8lltQq5ymYefd1Y8F5P/cNfZsW5tFLntrFT/Y5LogpQmbXTtYEcJQGoSeQKimKmrQBFMRO0dYlAeJrea5lD2AaJKyky6LnJl6gluvWIyoVOJ9K/Srek57EqYBNo7DLZMiRDIhpdedfs0slJShnDjHxj7GbNh26OdAPqOwo9XdrPPkN6nGIMM7Q5mo1M2xDQ9FT5g15i+cuqOtIkGK+xa8kAEAw9WiUzgITzxlFCtaVoKy8rUDxXUkIQaVzcLVNysTPUutokyEpNEZYfdM46XzY70uI03sjBE6P1Cgvz4Z9PMhsrsLUJ2NUAQgLze6ldMSDHTE41bqkmO3eV6s5LVWCsN1NdFe6TUSg93sZzLIxQebvSFD1jLwUB7Ilr2oU647zTszo0j8teCxmLNNm873YDV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000004374d1064842f2b9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 13, 2026 at 9:54=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Mon, Jan 12, 2026 at 09:50:20AM -0500, Jeff Layton wrote:
> > On Mon, 2026-01-12 at 09:31 -0500, Chuck Lever wrote:
> > > On 1/12/26 8:34 AM, Jeff Layton wrote:
> > > > On Fri, 2026-01-09 at 19:52 +0100, Amir Goldstein wrote:
> > > > > On Thu, Jan 8, 2026 at 7:57=E2=80=AFPM Jeff Layton <jlayton@kerne=
l.org> wrote:
> > > > > >
> > > > > > On Thu, 2026-01-08 at 18:40 +0100, Jan Kara wrote:
> > > > > > > On Thu 08-01-26 12:12:55, Jeff Layton wrote:
> > > > > > > > Yesterday, I sent patches to fix how directory delegation s=
upport is
> > > > > > > > handled on filesystems where the should be disabled [1]. Th=
at set is
> > > > > > > > appropriate for v6.19. For v7.0, I want to make lease suppo=
rt be more
> > > > > > > > opt-in, rather than opt-out:
> > > > > > > >
> > > > > > > > For historical reasons, when ->setlease() file_operation is=
 set to NULL,
> > > > > > > > the default is to use the kernel-internal lease implementat=
ion. This
> > > > > > > > means that if you want to disable them, you need to explici=
tly set the
> > > > > > > > ->setlease() file_operation to simple_nosetlease() or the e=
quivalent.
> > > > > > > >
> > > > > > > > This has caused a number of problems over the years as some=
 filesystems
> > > > > > > > have inadvertantly allowed leases to be acquired simply by =
having left
> > > > > > > > it set to NULL. It would be better if filesystems had to op=
t-in to lease
> > > > > > > > support, particularly with the advent of directory delegati=
ons.
> > > > > > > >
> > > > > > > > This series has sets the ->setlease() operation in a pile o=
f existing
> > > > > > > > local filesystems to generic_setlease() and then changes
> > > > > > > > kernel_setlease() to return -EINVAL when the setlease() ope=
ration is not
> > > > > > > > set.
> > > > > > > >
> > > > > > > > With this change, new filesystems will need to explicitly s=
et the
> > > > > > > > ->setlease() operations in order to provide lease and deleg=
ation
> > > > > > > > support.
> > > > > > > >
> > > > > > > > I mainly focused on filesystems that are NFS exportable, si=
nce NFS and
> > > > > > > > SMB are the main users of file leases, and they tend to end=
 up exporting
> > > > > > > > the same filesystem types. Let me know if I've missed any.
> > > > > > >
> > > > > > > So, what about kernfs and fuse? They seem to be exportable an=
d don't have
> > > > > > > .setlease set...
> > > > > > >
> > > > > >
> > > > > > Yes, FUSE needs this too. I'll add a patch for that.
> > > > > >
> > > > > > As far as kernfs goes: AIUI, that's basically what sysfs and re=
sctrl
> > > > > > are built on. Do we really expect people to set leases there?
> > > > > >
> > > > > > I guess it's technically a regression since you could set them =
on those
> > > > > > sorts of files earlier, but people don't usually export kernfs =
based
> > > > > > filesystems via NFS or SMB, and that seems like something that =
could be
> > > > > > used to make mischief.
> > > > > >
> > > > > > AFAICT, kernfs_export_ops is mostly to support open_by_handle_a=
t(). See
> > > > > > commit aa8188253474 ("kernfs: add exportfs operations").
> > > > > >
> > > > > > One idea: we could add a wrapper around generic_setlease() for
> > > > > > filesystems like this that will do a WARN_ONCE() and then call
> > > > > > generic_setlease(). That would keep leases working on them but =
we might
> > > > > > get some reports that would tell us who's setting leases on the=
se files
> > > > > > and why.
> > > > >
> > > > > IMO, you are being too cautious, but whatever.
> > > > >
> > > > > It is not accurate that kernfs filesystems are NFS exportable in =
general.
> > > > > Only cgroupfs has KERNFS_ROOT_SUPPORT_EXPORTOP.
> > > > >
> > > > > If any application is using leases on cgroup files, it must be so=
me
> > > > > very advanced runtime (i.e. systemd), so we should know about the
> > > > > regression sooner rather than later.
> > > > >
> > > >
> > > > I think so too. For now, I think I'll not bother with the WARN_ONCE=
().
> > > > Let's just leave kernfs out of the set until someone presents a rea=
l
> > > > use-case.
> > > >
> > > > > There are also the recently added nsfs and pidfs export_operation=
s.
> > > > >
> > > > > I have a recollection about wanting to be explicit about not allo=
wing
> > > > > those to be exportable to NFS (nsfs specifically), but I can't se=
e where
> > > > > and if that restriction was done.
> > > > >
> > > > > Christian? Do you remember?
> > > > >
> > > >
> > > > (cc'ing Chuck)
> > > >
> > > > FWIW, you can currently export and mount /sys/fs/cgroup via NFS. Th=
e
> > > > directory doesn't show up when you try to get to it via NFSv4, but =
you
> > > > can mount it using v3 and READDIR works. The files are all empty wh=
en
> > > > you try to read them. I didn't try to do any writes.
> > > >
> > > > Should we add a mechanism to prevent exporting these sorts of
> > > > filesystems?
> > > >
> > > > Even better would be to make nfsd exporting explicitly opt-in. What=
 if
> > > > we were to add a EXPORT_OP_NFSD flag that explicitly allows filesys=
tems
> > > > to opt-in to NFS exporting, and check for that in __fh_verify()? We=
'd
> > > > have to add it to a bunch of existing filesystems, but that's fairl=
y
> > > > simple to do with an LLM.
> > >
> > > What's the active harm in exporting /sys/fs/cgroup ? It has to be don=
e
> > > explicitly via /etc/exports, so this is under the NFS server admin's
> > > control. Is it an attack surface?
> > >
> >
> > Potentially?
> >
> > I don't see any active harm with exporting cgroupfs. It doesn't work
> > right via nfsd, but it's not crashing the box or anything.
> >
> > At one time, those were only defined by filesystems that wanted to
> > allow NFS export. Now we've grown them on filesystems that just want to
> > provide filehandles for open_by_handle_at() and the like. nfsd doesn't
> > care though: if the fs has export operations, it'll happily use them.
> >
> > Having an explicit "I want to allow nfsd" flag see ms like it might
> > save us some headaches in the future when other filesystems add export
> > ops for this sort of filehandle use.
>
> So we are re-hashing a discussion we had a few months ago (Amir was
> involved at least).
>
> I don't think we want to expose cgroupfs via NFS that's super weird.
> It's like remote partial resource management and it would be very
> strange if a remote process suddenly would be able to move things around
> in the cgroup tree. So I would prefer to not do this.
>
> So my preference would be to really sever file handles from the export
> mechanism so that we can allow stuff like pidfs and nsfs and cgroupfs to
> use file handles via name_to_handle_at() and open_by_handle_at() without
> making them exportable.
>
> Somehow I thought that Amir had already done that work a while ago but
> maybe it was really just about name_to_handle_at() and not also
> open_by_handle_at()...

I don't recall doing anything except talking ;)

How about something like this to safeguard against exporting
the new pidfs/nsfs.

Regarding cgroupfs, we could either use a EXPORT_OP_ flag
or maybe it should have a custom open/permission as well?

Thanks,
Amir.

--0000000000004374d1064842f2b9
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-nfsd-do-not-allow-exporting-of-special-kernel-filesy.patch"
Content-Disposition: attachment; 
	filename="0001-nfsd-do-not-allow-exporting-of-special-kernel-filesy.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mkchdddy0>
X-Attachment-Id: f_mkchdddy0

RnJvbSBiYTRjYjhlZTBiYzIwYWZhNzRiZDY4OWVjY2FmMTFiOGQ2MDYyMTNhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29tPgpE
YXRlOiBUdWUsIDEzIEphbiAyMDI2IDExOjQzOjU1ICswMTAwClN1YmplY3Q6IFtSRkNdW1BBVENI
XSBuZnNkOiBkbyBub3QgYWxsb3cgZXhwb3J0aW5nIG9mIHNwZWNpYWwga2VybmVsIGZpbGVzeXN0
ZW1zCgpwaWRmcyBhbmQgbnNmcyByZWNlbnRseSBnYWluZWQgc3VwcG9ydCBmb3IgZW5jb2RlL2Rl
Y29kZSBvZiBmaWxlIGhhbmRsZXMKdmlhIG5hbWVfdG9faGFuZGxlX2F0KDIpL29wYW5fYnlfaGFu
ZGxlX2F0KDIpLgoKVGhlc2Ugc3BlY2lhbCBrZXJuZWwgZmlsZXN5c3RlbXMgaGF2ZSBjdXN0b20g
LT5vcGVuKCkgYW5kIC0+cGVybWlzc2lvbigpCmV4cG9ydCBtZXRob2RzLCB3aGljaCBuZnNkIGRv
ZXMgbm90IHJlc3BlY3QgYW5kIGl0IHdhcyBuZXZlciBtZWFudCB0byBiZQp1c2VkIGZvciBleHBv
cnRpbmcgdGhvc2UgZmlsZXN5c3RlbXMgYnkgbmZzZC4KClRoZXJlZm9yZSwgZG8gbm90IGFsbG93
IG5mc2QgdG8gZXhwb3J0IGZpbGVzeXN0ZW1zIHdpdGggY3VzdG9tIC0+b3BlbigpCm9yIC0+cGVy
bWlzc2lvbigpIG1ldGhvZHMuCgpGaXhlczogYjNjYWJhOGY3YTM0YSAoInBpZGZzOiBpbXBsZW1l
bnQgZmlsZSBoYW5kbGUgc3VwcG9ydCIpCkZpeGVzOiA1MjIyNDcwYjJmYmIzICgibnNmczogc3Vw
cG9ydCBmaWxlIGhhbmRsZXMiKQpTaWduZWQtb2ZmLWJ5OiBBbWlyIEdvbGRzdGVpbiA8YW1pcjcz
aWxAZ21haWwuY29tPgotLS0KIGZzL25mc2QvZXhwb3J0LmMgICAgICAgICB8IDUgKysrLS0KIGlu
Y2x1ZGUvbGludXgvZXhwb3J0ZnMuaCB8IDkgKysrKysrKysrCiAyIGZpbGVzIGNoYW5nZWQsIDEy
IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvbmZzZC9leHBv
cnQuYyBiL2ZzL25mc2QvZXhwb3J0LmMKaW5kZXggMmExNDk5ZjJhZDE5Ni4uOTJhYzhjYjBiZGVj
ZCAxMDA2NDQKLS0tIGEvZnMvbmZzZC9leHBvcnQuYworKysgYi9mcy9uZnNkL2V4cG9ydC5jCkBA
IC00MzcsOCArNDM3LDkgQEAgc3RhdGljIGludCBjaGVja19leHBvcnQoY29uc3Qgc3RydWN0IHBh
dGggKnBhdGgsIGludCAqZmxhZ3MsIHVuc2lnbmVkIGNoYXIgKnV1aWQKIAkJcmV0dXJuIC1FSU5W
QUw7CiAJfQogCi0JaWYgKCFleHBvcnRmc19jYW5fZGVjb2RlX2ZoKGlub2RlLT5pX3NiLT5zX2V4
cG9ydF9vcCkpIHsKLQkJZHByaW50aygiZXhwX2V4cG9ydDogZXhwb3J0IG9mIGludmFsaWQgZnMg
dHlwZS5cbiIpOworCWlmICghZXhwb3J0ZnNfbWF5X25mc19leHBvcnQoaW5vZGUtPmlfc2ItPnNf
ZXhwb3J0X29wKSkgeworCQlkcHJpbnRrKCJleHBfZXhwb3J0OiBleHBvcnQgb2YgaW52YWxpZCBm
cyB0eXBlICglcykuXG4iLAorCQkJaW5vZGUtPmlfc2ItPnNfdHlwZS0+bmFtZSk7CiAJCXJldHVy
biAtRUlOVkFMOwogCX0KIApkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9leHBvcnRmcy5oIGIv
aW5jbHVkZS9saW51eC9leHBvcnRmcy5oCmluZGV4IGYwY2YyNzE0ZWM1MmQuLjNlYzc4MDgwMmMx
NGUgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvZXhwb3J0ZnMuaAorKysgYi9pbmNsdWRlL2xp
bnV4L2V4cG9ydGZzLmgKQEAgLTMxNyw2ICszMTcsMTUgQEAgc3RhdGljIGlubGluZSBib29sIGV4
cG9ydGZzX2Nhbl9kZWNvZGVfZmgoY29uc3Qgc3RydWN0IGV4cG9ydF9vcGVyYXRpb25zICpub3Ap
CiAJcmV0dXJuIG5vcCAmJiBub3AtPmZoX3RvX2RlbnRyeTsKIH0KIAorc3RhdGljIGlubGluZSBi
b29sIGV4cG9ydGZzX21heV9uZnNfZXhwb3J0KGNvbnN0IHN0cnVjdCBleHBvcnRfb3BlcmF0aW9u
cyAqbm9wKQoreworCS8qCisJICogRG8gbm90IGFsbG93IGV4cG9ydGluZyB0byBORlMgZmlsZXN5
c3RlbXMgd2l0aCBjdXN0b20gLT5vcGVuKCkgYW5kCisJICogLT5wZXJtaXNzaW9uKCkgb3BzLCB3
aGljaCBuZnNkIGRvZXMgbm90IHJlc3BlY3QgKGUuZy4gcGlkZnMsIG5zZnMpLgorCSAqLworCXJl
dHVybiBleHBvcnRmc19jYW5fZGVjb2RlX2ZoKG5vcCkgJiYgIW5vcC0+b3BlbiAmJiAhbm9wLT5w
ZXJtaXNzaW9uOworfQorCiBzdGF0aWMgaW5saW5lIGJvb2wgZXhwb3J0ZnNfY2FuX2VuY29kZV9m
aChjb25zdCBzdHJ1Y3QgZXhwb3J0X29wZXJhdGlvbnMgKm5vcCwKIAkJCQkJICBpbnQgZmhfZmxh
Z3MpCiB7Ci0tIAoyLjUyLjAKCg==
--0000000000004374d1064842f2b9--

