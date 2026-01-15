Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6F77D46617
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:31:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C5616B00BA; Thu, 15 Jan 2026 14:31:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27C226B00BF; Thu, 15 Jan 2026 14:31:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 171566B00C0; Thu, 15 Jan 2026 14:31:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 044016B00BA
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:31:56 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9CF1C1A0165
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:31:55 +0000 (UTC)
X-FDA: 84335193390.08.4BA5795
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf29.hostedemail.com (Postfix) with ESMTP id B8059120002
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:31:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DVkAXeGv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=amir73il@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768505513; a=rsa-sha256;
	cv=none;
	b=3lEOGhUnMTEJ+qTJezIvaODWVX4Sw70zb37TcyUKNJFFLKtYFqUblxcHE+Jrg/Pb0RtMvi
	ZnEqljRbZximA67eAidq2I7xR1rBkx/j7rNJaqcfk9MTg1b8/yO6+X0IReIoLAPLbk4KFe
	5RQ+Hrj6JdR/pNBpbdUIN4ONDwkz1mg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DVkAXeGv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=amir73il@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JqDSb07Y8F9mJCkqUS0QQHnJ5q+4REJWbBlGem8BlhI=;
	b=pijCoYickWeFM5aYZGoW2EUnOdgYOH05pVtU1U4RSjtYjmyfqiDGxTT2JiF/CChxA+VIDe
	+qVC+1Vca8kywjwkEfXpGr016+mbo97ab9D+Z0RnJZGFshksZRCQzQTwJMjsUp1Y83OikI
	tJJ553nV5+n4xg1f/7aXto+krjimcl4=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-64b9b0b4d5dso2794223a12.1
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:31:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768505512; x=1769110312; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JqDSb07Y8F9mJCkqUS0QQHnJ5q+4REJWbBlGem8BlhI=;
        b=DVkAXeGvnkn5AjSC2YzI2j3h6UbR/V7HwpcO9mElRfTXiMvkDwzUZCPCpEoyj0h+/J
         f0yv5XSvKgZuhmRT7PxtYs9lccYESVAx4QQ2E5MZ8oHPd7448l7ZUA26cC8emuY6YWJ8
         18zrDDTLwyIZqe7S2afsyIHpv7ZpyHwipBC8xvjlro/CvQkErftJTz3NaAoCT7F/vdRL
         TZRqEzW9glgC8VcfTPod6fBumjwyeCIOFU7SpGNbFZjra3v2aSCGVQFa/DQtcuduJ5Wm
         CBgTpWX2MqZOUGoo3oBfKe7Anvo1bAh+SZbMVHHb0Q1O7jXlAhvfSx4tNw9GAf5P+bdI
         8Xew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768505512; x=1769110312;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JqDSb07Y8F9mJCkqUS0QQHnJ5q+4REJWbBlGem8BlhI=;
        b=HzI2iaazfOZxFTlGgjE82hnIXuglN5mHnPiGkuTl2rpizaXQCNHSPZgng7PlQPTGsH
         my6Z++FoTAChj1c/j11C2ga1rGg+MXfXZemcehgx3Zl4TnYxyHz4nUTnUNzZ9f0CIN/+
         srk9DQCWXW7MkYJM5UoiNuy/BSAkharNOjh/wKyzqRKDQyeHpX7KvqGkbbl5ULLw8P+k
         DwJlLf9vGnWHZfdYlzYKqf99DFBbwBt4ojEgmSkFP+aQhQOmJTv/ACrkah6FKAhQnMzW
         7UhsUlhXO2n26XmVw+8/OBejkdl+MDhhc1pJlUVPimY5QPiKau+tH0cyYBO5me9rN8D1
         RdYw==
X-Forwarded-Encrypted: i=1; AJvYcCW4CaocVVWsHPSL9oVbPORup9gETTwFKSraPSiut5NnYctKQ+Q2SNibWIH6AH3VyZyMK8Bw0I3DIw==@kvack.org
X-Gm-Message-State: AOJu0YzgomUM16LoZEBPnwgJwCZGtT4bTmhkvnWYB5cAPTk9bLP82YrE
	JvFrSL6N3R/KWAjG2ngNuZzGtYJlIfk1pflNTnkB7o5JNayj43vhzr7LSKnjz9bKSOeXITAnXzP
	LKB+yEseHWLmfn2LV4lLVLShly5nOkxY=
X-Gm-Gg: AY/fxX6AHdMD+DUqfSAdMBifts/o+1jqcaR4B1dak0ijI4g2EAqTiJNZz41WosgkR55
	R9yVhLNXnhaT3RwWpVWR0MRWX7AKu11J0bz/OnrnD5c+3pk3NNST6Bgusfx2MHPUJp69o0ycfFN
	OZ+GT9bJV9flNKBxQ9F45FT/R+p4YdvJPMn21JhNhqlC6myLGRX3JrBVezH8+9e52cv4+FTpKcK
	kzUE6IZ9AqraUbHCzKv5mQqLhqgt2tkjAuSy3oWNxwr5gpEzDBXQ/5ITSthUPClxWEALD230ve1
	QyamLdcTiPjhg1dCNvhCJj8gaIaYFg==
X-Received: by 2002:a17:907:3c87:b0:b87:442:e9b6 with SMTP id
 a640c23a62f3a-b879690c54amr11543766b.17.1768505511676; Thu, 15 Jan 2026
 11:31:51 -0800 (PST)
MIME-Version: 1.0
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>
 <d486fdb8-686c-4426-9fac-49b7dbc28765@app.fastmail.com> <CAOQ4uxhnoTC6KBmRVx2xhvTXYg1hRkCJWrq2eoBQGHKC3sv3Hw@mail.gmail.com>
In-Reply-To: <CAOQ4uxhnoTC6KBmRVx2xhvTXYg1hRkCJWrq2eoBQGHKC3sv3Hw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 15 Jan 2026 20:31:40 +0100
X-Gm-Features: AZwV_QhvHAFd_rX2K5lnQvHY5zGWrCY2L2ECA3-jgjFMNT8gFVUBrqM9bcPeRhY
Message-ID: <CAOQ4uxhnSPoqwws7XW4JU=jjgZJoFgCjcWwbfPaprDCZq=wnKQ@mail.gmail.com>
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
X-Rspam-User: 
X-Stat-Signature: ap9nq7hoymrjn1z1b5ssknxh8odsetfs
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B8059120002
X-HE-Tag: 1768505513-335649
X-HE-Meta: U2FsdGVkX1+3yPGcn0SJ20XoVWaruJTo/NUG4fni9Mtb74NWgMYZ57TmDU2ZtIXZ9sXL8vRAtBgC3/MOSQkNGzTeQl+AgQ7Xg4N2ziyJ//SQij5chxGIPXjAWDbaA7yU5IX5db82AwXT82qyf4YxlwTp7mgahAARQ7FCCnnhljoJ824wBCTjqBhRFqEa85McBKNl7ig2KtOE0dw38BgioTJusrdd5q//ZznX6YdYL9yrHfPMD6QYTHwvcxBG3Vt9ghffJydjRsX3BiunpG1Z50ynpPR2vmeRh9VTFA9DMGVwtpbxFPm4EqzKmj8GOorKwwvhZRzK71+Xyu4+ftoYcUCsT14LI+SPEZmJIM86oQBhEIUYvQCuE/P5iGksRa3/zcnIUvw0/k5JuCzNMM9moIfqUQU7w9ac7cYEU5oDveos9Kq2kATCBpA8yOevPGWaKVL3bzbdnekbdeWKIUdGuQhYBmAimySp2lCId4MFivyNK7bxY721pMeHaLCFv2+6alnHPlVQ6Tp02YAv/RFjTJtCz3Rdb0HYCDwkO/BAi4idQuAdb0eQqugNRGmxLIhhrvJ1amYYr4BKjcklr+VULwIOTQ+UgfaYD5r4S62RokDfrroVicjfOjDuzCxBw6tK+Z08nZ1tpsk9aroThSxHCCtu1othcbfRdlmQ7uj6fmxdtIG26acg/sC0bt+/0r43+hchiOogJbCfYrE1rahZTki3WKoqkOM3VvXDSlZVHbKb3jKHf/BELZs8Kvl4CCGCeYV3U8fVOvDXTKouxDer5H/ujOwMjELs8cG2yEu2PMDSIzw8SOU15QmLZtiTk4VB1n0EcByLv62VbJEtAsPlTDMmWzQxqzdcQrTvlSYdyAswrt9Pm1T+yjYw+IyndmXk19tG6jQ9QmlvkZQ76lI4+mo+KRP/4NYr2KflnL2duhbWze9Fc/AXcOGybDIAnKY8U8C/kDkFYojrr78yG3Q
 g95NdqiC
 uD2UH1cMEguj5htuufP3aN2/ILfDXuCJe0QcENOK0rDyupGijJB4MUVgZwysYtqfjZ7uXfnp5b1DWw/O/CLKotsw9J4bFhZghO+ldRjVd0mfr9oTFqJ/n59gzS6aA06/3w710J5SYEtxMQM4Ri6JeSRK92QzMz3BveWeqymfpSgKQwbhXd4tzNsKFT1gHvMgc6g7kZNf9K8PelEuPzvK2xaMlQb5UDGWOycR33Vdj08snZv1bWgTUCC/LzGecUkJi4zg4WqbSP3QhMEuEevbEIZWFQ+9fQtMl9omyMwO7+NY+9sRatXwb6vqS5AxgAcRyiur/EwisFzttW8iLaVF6G4gKbEnzVLHrAX7g+jdWaySAhUlyTtwEdky8QU6DXr5buV0cBhctJZW2KlwuqaBsM8un+10xyoX3aDhHdG6cNASyWXZYrkLO2VM3vx6Tv15ESTRLHjc1WMdrpcTFZC/Tg15+nLWxegvSWyt3HkFZ/Gwqs46rnNtNyGRJsryHd0XKHE8oN4vZARXpWozIkS49jpaSLqQUU92V6WT2nHThzlCnEHPn/8/ERGUhcw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 8:14=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Thu, Jan 15, 2026 at 7:32=E2=80=AFPM Chuck Lever <cel@kernel.org> wrot=
e:
> >
> >
> >
> > On Thu, Jan 15, 2026, at 1:17 PM, Amir Goldstein wrote:
> > > On Thu, Jan 15, 2026 at 6:48=E2=80=AFPM Jeff Layton <jlayton@kernel.o=
rg> wrote:
> > >>
> > >> In recent years, a number of filesystems that can't present stable
> > >> filehandles have grown struct export_operations. They've mostly done
> > >> this for local use-cases (enabling open_by_handle_at() and the like)=
.
> > >> Unfortunately, having export_operations is generally sufficient to m=
ake
> > >> a filesystem be considered exportable via nfsd, but that requires th=
at
> > >> the server present stable filehandles.
> > >
> > > Where does the term "stable file handles" come from? and what does it=
 mean?
> > > Why not "persistent handles", which is described in NFS and SMB specs=
?
> > >
> > > Not to mention that EXPORT_OP_PERSISTENT_HANDLES was Acked
> > > by both Christoph and Christian:
> > >
> > > https://lore.kernel.org/linux-fsdevel/20260115-rundgang-leihgabe-1201=
8e93c00c@brauner/
> > >
> > > Am I missing anything?
> >
> > PERSISTENT generally implies that the file handle is saved on
> > persistent storage. This is not true of tmpfs.
>
> That's one way of interpreting "persistent".
> Another way is "continuing to exist or occur over a prolonged period."
> which works well for tmpfs that is mounted for a long time.
>
> But I am confused, because I went looking for where Jeff said that
> you suggested stable file handles and this is what I found that you wrote=
:
>
> "tmpfs filehandles align quite well with the traditional definition
>  of persistent filehandles. tmpfs filehandles live as long as tmpfs files=
 do,
>  and that is all that is required to be considered "persistent".
>
> >
> > The use of "stable" means that the file handle is stable for
> > the life of the file. This /is/ true of tmpfs.
>
> I can live with STABLE_HANDLES I don't mind as much,
> I understand what it means, but the definition above is invented,
> whereas the term persistent handles is well known and well defined.
>

And also forgot to mention - STABLE HANDLES is very lexicographically
close to STALE HANDLES :-/

Thanks,
Amir.

