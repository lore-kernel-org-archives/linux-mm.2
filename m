Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AE68D47CAB
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 00:34:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62CBF6B0089; Thu, 15 Jan 2026 19:34:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E2A16B0088; Thu, 15 Jan 2026 19:34:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AFC16B0089; Thu, 15 Jan 2026 19:34:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 38EB96B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:34:04 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C6E8E8BE9A
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 00:34:03 +0000 (UTC)
X-FDA: 84335954766.27.10EF57B
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf15.hostedemail.com (Postfix) with ESMTP id 60EC1A0003
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 00:34:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gYGsE7Dg;
	spf=pass (imf15.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768523641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LuYXJTx9p8g5I9PbL+x4hBzLoIE63ueUkinqkyb6yNs=;
	b=YN9W48qnxTi22PttDudwIUw89cL4IV/ee7hIhGzEqR1REzkwX5HT3sMnpI3pFcSlARxSV7
	hYH4/0y/o8a2AQ3HV5kAoZABRbL/ajBNZaksG3jrjWn1CHeRATHw7GT5XUAuYuX9/psrj+
	DyIBtMsE7tGbzl3GdOygfzKHg0ENaN0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gYGsE7Dg;
	spf=pass (imf15.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768523641; a=rsa-sha256;
	cv=none;
	b=WImF7jAcsCT+RmPrku8svSj78MJftvxgY+EATG9Of2vxI9RQsA2l4bTF2isXr/mSolGkKY
	1sDt7uqyUbws2AWZHv7asWwERpn/dtmj49OwvrYwtQQCkf4Ai9WU5dLe+WEn/AYQxmy7+v
	TjflC9HaGq52FzVRj9/JhgJcKWPZ55k=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6536e4d25e1so2192683a12.1
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768523640; x=1769128440; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LuYXJTx9p8g5I9PbL+x4hBzLoIE63ueUkinqkyb6yNs=;
        b=gYGsE7Dg5O1oITh+ZS2KAY95n/cLS5nxI9Ys6nzk9BTi4CSE9UmejUyRxFL0GHh8RJ
         9canUuK+P+pN2trcGwVlJKzYJfdMBjhwfZRrreydlclHsLxTjn5CuZBkz6grzeNSARUy
         nBseobReSS04lDzWRYElyw9jEptRMkBxayTQQUNrsQCzsPWNK4VMDBMpc/xcJellDifT
         Hyf7ckXpZGV6am+AyXm/CWe/G/zl4efo1u9ZW4BcJhl6nPVDCKsvVrC+U6soVtM+ypZn
         bLUIEWD2rvEdgXmZXBYBlpPkLwD5IW0/GGAeltkBR0xEthHDRfhsaaqbm7GArKCF0Mt0
         Rd/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768523640; x=1769128440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LuYXJTx9p8g5I9PbL+x4hBzLoIE63ueUkinqkyb6yNs=;
        b=raCOr7Z4SUPVXTEJTzG+GkyUgj4pUHsqfgknqtqU+i5TQTgBx+qJyC53pH3egUl2qf
         C10klJzZrF+NhsPvoLu8M4eE9nN5veqqzHe9mf8gFpC2ksBIBN1H+9QemZuQg3M3DUxe
         OgDX4MTXvtoeHHDOd6i33mNgigbMHMycLrjIPB0GPzxdJ8IVsedwH3HeNZ0/GuxZFIZO
         79beXfbyWZvYZ3ln7PQ4oaOcml4eNaSSJGmnAX6WDSzZo9ZLmIMiK7dzHJWCusPL2S9c
         hTrKBTbe4azWYi9fxhRUjFD3/e18P1NDcrM/gliVkT5dH4//0V+Ya0vvtuTKlBC0OhQb
         lhOg==
X-Forwarded-Encrypted: i=1; AJvYcCW3MH52FB7+l1yR6u09OKa62vxrNUGWYU4cmkuJRamFvOq5vA5iNlzlEDVSxX/PSlUH6xCKDzC4cw==@kvack.org
X-Gm-Message-State: AOJu0YztFSYVyRY5m7UJ/uPlE1854pTo4raPO+sp/TEEAYQ5bZTjhPbm
	PPZcuSPSpXAcXUUtYFOuoZk180nxwvlQwzuvGl5Y0mOBeGm1wJVQZdlk
X-Gm-Gg: AY/fxX7xJEOiV0WsXK3Rkz/KmlprLDA+GH18PMAdZaRhI7yinG8EnROhEGhs82i4E9G
	k2d+/swKo3BOMuYMkb+w6oC3vTNCGmMWXN+D/x46DaG+v9Y3DbyEl2olgS6+ataWd2voaNj5Ys7
	x6aLOzoUw5Gyo6YINknWFizgMFb97aXVqfUTb8oKvYNr9AUrVAkipKhsLxI7IlYArWm0BXgJJcm
	FxExRBgiZpE9If0rfhp4fVVKbViVg3N9MYLG0RM5GfwIEqfoCzcgOQKEUBXlg7PNmehkVokL00r
	8P8UdD/iUXGr0QPFSwMQaV5fBdByeZxap082aOM0acb7HRI+6Gm8IyLsOydPaO5SduR/dK7pHiU
	x+QiX2FwXkE6IjbwmoRLs4ceKfL59iK39BzonrOALFnkQA7n5ozKlb3hvkAriwWQk3tTGNw/b7A
	KZUTgq0+6cLIlFtwDvIECgabDV5ofL72d6lcbAsfQcEaazKnqfSUPd
X-Received: by 2002:a05:600d:8445:10b0:480:1a22:fce8 with SMTP id 5b1f17b1804b1-4801e3494acmr11682565e9.26.1768516821247;
        Thu, 15 Jan 2026 14:40:21 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4356996dad0sm1443737f8f.27.2026.01.15.14.40.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 14:40:20 -0800 (PST)
Date: Thu, 15 Jan 2026 22:40:18 +0000
From: David Laight <david.laight.linux@gmail.com>
To: "Chuck Lever" <cel@kernel.org>
Cc: "Dave Chinner" <david@fromorbit.com>, "Amir Goldstein"
 <amir73il@gmail.com>, "Jeff Layton" <jlayton@kernel.org>, "Christian
 Brauner" <brauner@kernel.org>, "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Chuck Lever" <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, "Olga
 Kornievskaia" <okorniev@redhat.com>, "Dai Ngo" <Dai.Ngo@oracle.com>, "Tom
 Talpey" <tom@talpey.com>, "Hugh Dickins" <hughd@google.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Theodore Tso" <tytso@mit.edu>, "Andreas
 Dilger" <adilger.kernel@dilger.ca>, "Jan Kara" <jack@suse.com>, "Gao Xiang"
 <xiang@kernel.org>, "Chao Yu" <chao@kernel.org>, "Yue Hu"
 <zbestahu@gmail.com>, "Jeffle Xu" <jefflexu@linux.alibaba.com>, "Sandeep
 Dhavale" <dhavale@google.com>, "Hongbo Li" <lihongbo22@huawei.com>,
 "Chunhai Guo" <guochunhai@vivo.com>, "Carlos Maiolino" <cem@kernel.org>,
 "Ilya Dryomov" <idryomov@gmail.com>, "Alex Markuze" <amarkuze@redhat.com>,
 "Viacheslav Dubeyko" <slava@dubeyko.com>, "Chris Mason" <clm@fb.com>,
 "David Sterba" <dsterba@suse.com>, "Luis de Bethencourt"
 <luisbg@kernel.org>, "Salah Triki" <salah.triki@gmail.com>, "Phillip
 Lougher" <phillip@squashfs.org.uk>, "Steve French" <sfrench@samba.org>,
 "Paulo Alcantara" <pc@manguebit.org>, "Ronnie Sahlberg"
 <ronniesahlberg@gmail.com>, "Shyam Prasad N" <sprasad@microsoft.com>,
 "Bharath SM" <bharathsm@microsoft.com>, "Miklos Szeredi"
 <miklos@szeredi.hu>, "Mike Marshall" <hubcap@omnibond.com>, "Martin
 Brandenburg" <martin@omnibond.com>, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>,
 "Konstantin Komarov" <almaz.alexandrovich@paragon-software.com>, "Ryusuke
 Konishi" <konishi.ryusuke@gmail.com>, "Trond Myklebust"
 <trondmy@kernel.org>, "Anna Schumaker" <anna@kernel.org>, "Dave Kleikamp"
 <shaggy@kernel.org>, "David Woodhouse" <dwmw2@infradead.org>, "Richard
 Weinberger" <richard@nod.at>, "Jan Kara" <jack@suse.cz>, "Andreas
 Gruenbacher" <agruenba@redhat.com>, "OGAWA Hirofumi"
 <hirofumi@mail.parknet.co.jp>, "Jaegeuk Kim" <jaegeuk@kernel.org>,
 "Christoph Hellwig" <hch@infradead.org>, linux-nfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-ext4@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org,
 ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 linux-unionfs@vger.kernel.org, devel@lists.orangefs.org,
 ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev,
 linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 linux-mtd@lists.infradead.org, gfs2@lists.linux.dev,
 linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 00/29] fs: require filesystems to explicitly opt-in to
 nfsd export support
Message-ID: <20260115224018.2988ca25@pumpkin>
In-Reply-To: <06dcc4b6-7457-4094-a1c6-586ce518020f@app.fastmail.com>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
	<CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>
	<d486fdb8-686c-4426-9fac-49b7dbc28765@app.fastmail.com>
	<CAOQ4uxhnoTC6KBmRVx2xhvTXYg1hRkCJWrq2eoBQGHKC3sv3Hw@mail.gmail.com>
	<4d9967cc-a454-46cf-909b-b8ab2d18358d@kernel.org>
	<aWlXfBImnC_jhTw4@dread.disaster.area>
	<06dcc4b6-7457-4094-a1c6-586ce518020f@app.fastmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 60EC1A0003
X-Stat-Signature: 3mp67haeftagwr4gywrbnx9nkttiacjw
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768523641-202054
X-HE-Meta: U2FsdGVkX18x+yPsc6c3/HQC1hRGwhDaoREeknnQb+ud0IMKQp8eb37/soXPUb38XEoMWYGquvpWBOxMUYsZlUxYh98zcjtMxgC/cT7AV+vdL0Ea8MCcDjq8psFLn8EFZxdoLAgRH+jsgx1uxOXNs705buATrTLahNmK/LwQIVG2vlIzhRFvditXVL/dZntr7p0B3JQhuTSkXP59A/V0lwHBV/IvyQF594X3agEWtx47y3s5fpbvs54Fg1KdE2FqK5TzYaAP6kjLdIjeQ4Dilmk7AsG7UeLzW9f+twDjluHf/SOEF2VRpd7nhbpfub0hDtUbUZHvDbBaj/jLUhw2W+yPxTIDbrC9CcvFDjHHWCY5oz8iRO1wnefQKQPqHncQ4VEVQF4866C5yEJvvn65+pyGLXZMCQKbSNHyMYhBJgtZM9ov5qeVU7a5AoWlT1ACStVppRVR4sJSrcx97epKzt6xo92JZr3PYK2DcCsOWtk/NpgP4uf4AG5s+6+XEK1fRGdd3HgkdLm+RuX9QzsJO4ZV9umQbcgBTMuUUYHsPQaqNd11YkKr4bQNaRfEn7STTnAkshNUHmG1oR0bIum/ERwVDO2ljcJaxXEMShxSVqt9GQHUAJVx3i0Rd6G4kr47QRK0vE4BB5fooF1D+vA1LVZhlP3VNiGSslbSZMuEy2GRLD5MRby9v4Q7P94AzQvIE0AWx5FRgbChJV7ngYqBAG+S9WtwnJJqUH0D/yNkQdQJBHMk8Igpyag3XfEVxi85GvqC8KseKCH0I+vvxxN/4RDP/zHEymAnCVdV1HJIkgi/MteluazNgvp2VV2enU/483+QwKVZH8RsAuYpe7LgJcheuJnz1/ASaKQfD2lYdH9Hy+4fgim64jugjA+iDelcK6+l/YXEfAB0+fmenPNYz3B5nSdX0KwHbhqr3JldVXglze752BDT5UOs1+Ah8Pm7bLDI7uv6qz8vlHtefz8
 SHJpeh6e
 XxN352TWaQHJuYr2N7awISdB5s6Wc2Ld0dCUjjhjxZifUqFyypnfWKy8sMxUCszmUGA4u6mnFUIKAGshCrSrqmmFNntIbtLyNEHK1Ez9cfOdw8krb2BQhqk8xGsgWO2XZq37APPGmI8U2w6zSeoPuADbFmoPAu1WdM9mhfuKshKp9CpmETGpjSbCrhCEztGmLzi9r6nW0sIoit+hd8g/1zzYgQ6yOLTxd7TW2I8nN1vEyv5I76A3V3MlDIPa6E/FbeGGmfWY7UeFvY4LCFuwUTEqA5A4KVn8/etwwdMmPiKTU9e9VhRoAn86YeEKlXWxx2iqFFYCZATC/G/JtiW0mhoeVe2Z57NMPyvZG9c9JNJZCToE6tUm4CG2AAGH4Kjtzm0Z4ps37b8ehJQR5JUkzAlQ360Zz2hPzzeiAKwqAKkbJy/Jfu1FmSXsLnlRBO3MdF46OTVreyYFkF+oV9OBEHgTy0xI88ezY9NmowFVFp3RW53jFgbmehrTAvyRznXUEPfekPpuvZuFM+KqA9DxdhgW7at9Fm2MnqwueQ2VIVCkFCAFqv2amuJyXs7zEF5XXsadNXe6KRXILo1w9d9kxAHqm0/qTW+oRdmvA8A3vNqKwQEO9KAUckMIJaaYwcybobCizT9PUdB9TGx0V/GBs681LI+0rGsusE+S3WN+LsUmzBGvHIcQJPhHwn64Ph2bKvbhJE/QRLnq5n/wVgD/Q5NbEnX6pMesP7iMdUcKtfMfwQ8athehFcRhiGpvxPFZAVILqoXs+JC50G38=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026 16:37:27 -0500
"Chuck Lever" <cel@kernel.org> wrote:

> On Thu, Jan 15, 2026, at 4:09 PM, Dave Chinner wrote:
> > On Thu, Jan 15, 2026 at 02:37:09PM -0500, Chuck Lever wrote: =20
> >> On 1/15/26 2:14 PM, Amir Goldstein wrote: =20
> >> > On Thu, Jan 15, 2026 at 7:32=E2=80=AFPM Chuck Lever <cel@kernel.org>=
 wrote: =20
> >> >>
> >> >>
> >> >>
> >> >> On Thu, Jan 15, 2026, at 1:17 PM, Amir Goldstein wrote: =20
> >> >>> On Thu, Jan 15, 2026 at 6:48=E2=80=AFPM Jeff Layton <jlayton@kerne=
l.org> wrote: =20
> >> >>>>
> >> >>>> In recent years, a number of filesystems that can't present stable
> >> >>>> filehandles have grown struct export_operations. They've mostly d=
one
> >> >>>> this for local use-cases (enabling open_by_handle_at() and the li=
ke).
> >> >>>> Unfortunately, having export_operations is generally sufficient t=
o make
> >> >>>> a filesystem be considered exportable via nfsd, but that requires=
 that
> >> >>>> the server present stable filehandles. =20
> >> >>>
> >> >>> Where does the term "stable file handles" come from? and what does=
 it mean?
> >> >>> Why not "persistent handles", which is described in NFS and SMB sp=
ecs?
> >> >>>
> >> >>> Not to mention that EXPORT_OP_PERSISTENT_HANDLES was Acked
> >> >>> by both Christoph and Christian:
> >> >>>
> >> >>> https://lore.kernel.org/linux-fsdevel/20260115-rundgang-leihgabe-1=
2018e93c00c@brauner/
> >> >>>
> >> >>> Am I missing anything? =20
> >> >>
> >> >> PERSISTENT generally implies that the file handle is saved on
> >> >> persistent storage. This is not true of tmpfs. =20
> >> >=20
> >> > That's one way of interpreting "persistent".
> >> > Another way is "continuing to exist or occur over a prolonged period=
."
> >> > which works well for tmpfs that is mounted for a long time. =20
> >>=20
> >> I think we can be a lot more precise about the guarantee: The file
> >> handle does not change for the life of the inode it represents. It =20
> >
> > <pedantic mode engaged>
> >
> > File handles most definitely change over the life of a /physical/
> > inode. Unlinking a file does not require ending the life of the
> > physical object that provides the persistent data store for the
> > file.
> >
> > e.g. XFS dynamically allocates physical inodes might in a life cycle
> > that looks somewhat life this:
> >
> > 	allocate physical inode
> > 	insert record into allocated inode index
> > 	mark inode as free
> >
> > 	while (don't need to free physical inode) {
> > 		...
> > 		allocate inode for a new file
> > 		update persistent inode metadata to generate new filehandle
> > 		mark inode in use
> > 		...
> > 		unlink file
> > 		mark inode free
> > 	}
> >
> > 	remove inode from allocated inode index
> > 	free physical inode
> >
> > i.e. a free inode is still an -allocated, indexed inode- in the
> > filesystem, and until we physically remove it from the filesystem
> > the inode life cycle has not ended.
> >
> > IOWs, the physical (persistent) inode lifetime can span the lifetime
> > of -many- files. However, the filesystem guarantees that the handle
> > generated for that inode is different for each file it represents
> > over the whole inode life time.
> >
> > Hence I think that file handle stability/persistence needs to be
> > defined in terms of -file lifetimes-, not the lifetimes of the
> > filesystem objects implement the file's persistent data store. =20
>=20
> Fair enough, "inode" is the wrong term to use here.

Usually there is 'generation number' changes when the inode is used for
a new file.
IIRC the original nfs file handle was the major/minor for the disk partitio=
n,
the index into the 'on-disk inode table' (the inode number) and the
'generation number' (but I'm sure the length was a power of 2...).

It's not surprising Unix uses inode number and file handles.
K&R would have used RSM-11/M where 'file directory lookup' was a userspace
operation and the kernel only supported 'open by file handle'.
Although that got lost between there and ntfs.
(Windows IO is definitely based on RSM-11/M though.)

	David



