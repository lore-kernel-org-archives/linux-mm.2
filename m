Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5C0FCA5FA5
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 07:34:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 782326B0088; Thu,  1 Oct 2026 03:34:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 733996B008A; Thu,  1 Oct 2026 03:34:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D4406B008C; Thu,  1 Oct 2026 03:34:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 25B4A6B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 03:34:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8CA67A0322
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 07:34:00 +0000 (UTC)
X-FDA: 85273243440.10.A3EA5F7
Received: from mail-ed2-f31.google.com (mail-ed2-f31.google.com [74.125.228.95])
	by imf02.hostedemail.com (Postfix) with ESMTP id A19ED80005
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 07:33:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bOv7L9pl;
	spf=pass (imf02.hostedemail.com: domain of amir73il@gmail.com designates 74.125.228.95 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790840038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WTf1zoaT0Wsrc4m5L9oFar53LMEzHBHomKhDhLKQLu0=;
	b=4IcxBPNhBYXaPGloPxqbpjyInSv8bLjFKY6Y79pbfv41mvENsftdlEvpaf6SEKa8JGnXbC
	LWwRwVcUxRqeaDTAYDPz85taRV+5Lt6fCGNw3bh1iA6TSbeY55ONLe2XvxYNu8WnwHyGng
	xxxs8M/zJWvyKXRHMGRcxCXfLZJeSTs=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bOv7L9pl;
	spf=pass (imf02.hostedemail.com: domain of amir73il@gmail.com designates 74.125.228.95 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790840038;
	b=ot/lYLXdNmShW7u/oVqaCHLloCVabcbUU/mT5RrZdgFkRKXHQEGhL/v9m3dE9gdRMJZbZ6
	sDflk7OhRR8rWnjoZVakxZwV4K2JNp6MgJFdT9e6b5ctscPpsBvM2sq7uCTVpGdt4TlVvM
	g1I3HcB84f8iWozqd+dLlYRISfrXqIo=
Received: by mail-ed2-f31.google.com with SMTP id 4fb4d7f45d1cf-6ae3a72e02eso885000a12.3
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 00:33:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790840037; cv=none;
        d=google.com; s=arc-20260327;
        b=jcTRQUk2pPq9bcHh8HR63eMk1BzwaDczZlQZA3bxRYm0IEBjyG6SlPsepv6uyq2JN/
         pfNBzYN0nTnfnut9KXnk745tzH2W4DRSyUXs6vqEEsn2fnFsU0ZOVjVbqc6TiTfgkOZ/
         zDnSkDW+KGz/2TYQ1yxU/CGQJpBQz0YFoRHr36/EmV0TqQjWNAPXs1sjlIl+NaAvY4SC
         sheEraa7Qxh2nk+o8voubl0pfk15MzQCvXyeX4RjXgBMz7axaNNGtQLLFHi6UyvTk6pJ
         z5bqlQxPy/cg1wZjVNMO9GiktIkejrEt7H9q5ClzsujFJAf4b8mzzdlJpacVufS1Cr/D
         gsvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WTf1zoaT0Wsrc4m5L9oFar53LMEzHBHomKhDhLKQLu0=;
        fh=uG2dfcDtYGSFbN7YxizNR3IgVeOZNkCn7W9m4R2mrmE=;
        b=fLwvhw0dds7Z+K7vnjqHC68hYD1nXkS/NLe9hgq3SPX3aKJTfMljHYUkFocDe/CG00
         4pVLdvAS/ibGh7PwGhZyj6So64pDcPmenU0VMr27BL8VNhoKu6k8benl2PfRV6dUoF7j
         hUXInkhxa/YUATU5gvleGLFoTchWWnXLyhFmUhsP+QiphBTgkHglTy3u7S4P82cflYeY
         DL+p2g7LDOjfQun7u0HCXSTXLfPJkXpEUjwewKPdDBNM/C0bRF4Uk0Is/BiiHJurWmsG
         svclUvoh3dDVMH3npEHjTnLbgfXo1vTmqSXEnmrcAn3k1KMUsSENVyoykNOpo5+ad59D
         UPDA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790840037; x=1791444837; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WTf1zoaT0Wsrc4m5L9oFar53LMEzHBHomKhDhLKQLu0=;
        b=bOv7L9plmN98mO64Fik1iTRbXgfvcxSYgeP7vAupkprtJErEFbSwLtGPG+gv3fdMzC
         NBlzU9cGdOcbUGTiukNeWrRFGM03iXAZL7y3o0QWIOUcfBDbxQBvwZN5ZlVbmcZ0ohs3
         +Xi0dNLS4NISniKAXQshtF/xOUl0xmqUrZ6avWxAqaoxqLqVuFNonvsHGfy7YCv0qXtI
         36uxSnqC6QmNHxjIkpJ4QmbVevxTns/MpGCTLoaVDlwTNeaJpnyRjq0Ll6SKJ+fZcCJ5
         tTNWeAjneeM08K/rGcRQEDLb/sverV1Aw4XBdyROlMQMAegf2ZM505So7/kA33RMDS7M
         n2Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790840037; x=1791444837;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WTf1zoaT0Wsrc4m5L9oFar53LMEzHBHomKhDhLKQLu0=;
        b=rsxe8xqdkMvYZwLNlrBwaxe81pe2QQwZMqqF97WfTUqhwEMjoCLeyzXuHPZthbkBPM
         OCdzR6yt+tcqLaASeAWNkymx+H4lvqoCEFk2IDYhVWt9S/1wuTtJhlG7kWCsu/DRQ++G
         mjybgoogK17IKPumJHe/ADKe5/ThA5Osj1ohjkQ0hKphdC+AfR3C5ZvyY5LRW8FWeDYZ
         anym7RqZu/7wHW5tydUEzYnn/vfR12cCyeV9pkUajaZoBLPmPpm9KjF8VSGh3MI2vrC9
         PSH+kVUDEyfOCuvP+CJ/3iQQAHDgCj8SKvL3ZtdVzx76bW7CLxreNB5Lt7OXIBTB1SoF
         39Yw==
X-Forwarded-Encrypted: i=1; AKwUvBymMaOkOUI+kbjBlquqPCYF1xasaFXM8wVHC5UhrYr91HQR30/wgwKtO1eSAk9flepk603rRKI/kg==@kvack.org
X-Gm-Message-State: AFq9FYLzvMWsIXD9I3CrujaT3Vi2sKkF7uUTbYE73zBdk++li4FG8/Ud
	O0vqTuP9NivLefozDdJ57l29KE4mVjFTxntDvAAmKNdxYEfloCAicPNtC1s23zTG8m+5S9I8mCk
	TcYlhLpZIbpLqcEszQbOFpCO6ApEbiVU=
X-Gm-Gg: AYBFou0c9mWF5hRkES6u7YP0BHTejJj4xVcFl+G6qNop9uYLRhZy2zMLzDWSkoDsE5l
	JmaRsSU8tJqql08tnJM5RJl+GrICNEwZlssYKiaBd41eGYsf0+80uBCV0znBZjGutJTFYKIEbuR
	GLebQZqhtjSPFUG/+eBnwtYMKYek/VH8wE2jeuqYuBKe6PkYRpgBT2lj28+tmi5YQ3AUqVbaUJS
	9n92tIoY1PS4DhHx1sYKnjx8omFlfv7ImHY8mcYqOoRfNbwV5TiJ9LTv91FYdYJxeyHqJNmDKI+
	ZY+OokyOQJRfxjKTEr481NRPymsRK8pRhGazGOILuH+pbkgKcBro3oTx
X-Received: by 2002:a05:6402:3227:b0:6ac:9a44:d3ed with SMTP id
 4fb4d7f45d1cf-6ae1986075bmr3067340a12.5.1790840036710; Thu, 01 Oct 2026
 00:33:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260929034158.1455429-1-neilb@ownmail.net> <20260929034158.1455429-8-neilb@ownmail.net>
 <CAOQ4uxjv3Ziqy+CjbCO7noAPse+a0066UO7pkFhStnnW9FFSPg@mail.gmail.com> <179080463287.37859.4262341831478331513@noble.neil.brown.name>
In-Reply-To: <179080463287.37859.4262341831478331513@noble.neil.brown.name>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 1 Oct 2026 09:33:44 +0200
X-Gm-Features: AclHuK9MIhHprf4aDgaMwd_4tZZMvI-V-gvxwkigtEk9UN12WMcOwDyiP913px0
Message-ID: <CAOQ4uxgEG6Wt1z7JO+v2sjs=Aoav0u7eLz+Ge3UqhVG4msBkwA@mail.gmail.com>
Subject: Re: [PATCH 7/7] ovl: stop using lookup_one() in ovl_iterate().
To: NeilBrown <neil@brown.name>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Kees Cook <kees@kernel.org>, 
	Joel Granados <joel.granados@kernel.org>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Breno Leitao <leitao@debian.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Jan Harkes <jaharkes@cs.cmu.edu>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Hyunchul Lee <hyc.lee@gmail.com>, Carlos Maiolino <cem@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-um@lists.infradead.org, 
	codalist@coda.cs.cmu.edu, coda@cs.cmu.edu, linux-mm@kvack.org, 
	ntfs@lists.linux.dev, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A19ED80005
X-Rspam-User: 
X-Stat-Signature: q91xjxps59ffuw14azstfazrhw7jeqzi
X-HE-Tag: 1790840038-751018
X-HE-Meta: U2FsdGVkX19Xq3xP/z/Kj/AjIrzSas3Ut/ZsTlMWcs2njyZKZI6GzeSF4hJpv+7Pl3x3SYMMuqh43PMM8OEn7a4vGg/jzZEHh6Xlbb76bjHc9KSgTXPQY02OWvQImrmjdj3aWoCqyljNnDNl3kZJsoFh3QUogRjIGwFJdjF5ktzuQ+roNHFmDJ+kDGh8mKSotPyLkc+N91UQzAPKnRJ2Mj2vN7SBqw8i8OT+88NhrAgJw0j5EKlZ387Ae6zkWJKS1eELhCNVZhkpGBxJ99kbGZ3o6S7O05jn7Ivph/+6egTvPAXJuHmjNGO9a3Cyg4iI3zjI5rFSRJrPcEJvHu3N5hqGiFBYvZl9gqpawdgH09tj5uJQRUwmYQF4jHo49Ar4Oqhy1Q8F1M7vaB21Krzhj/AeucgidSlzCWrXFi5VNr0a9dZMj9mTUBFfq4mssZBu8z3BveuJ+dLsQPudWmkRKoWZcVTUymYAIjHM6UPHpGB5VrECfXDtwsuQXAgUhBJvh/8I41/drIuuyjmQMTTiZPn3C1YfCC1XKyZCBWC29cbgry85Kk3iqAvbd/aD6yZiHurLxkHDsFbVc3BGaslzDRiMWinZxjSKDeKUpY07MdNjndCZwcORT9s1NkPHFPppUQCUmehFsDfewnM48zrmf4enIkdXucuv9tUGfier3BcMH7DSudGwzkt/J4kr3vo4d0aaD0eLo6bxiPotcptPc+qvZszKpZvQGvtlCZ59kAwhHGHz9Lu9N//RxBK+fHua2wHEJjTIS/rc6JoELc1nu218h2gbdu4d8Ov9SPNCaxFOwocFQvNrc+u6BrNQsxacq19lx8pTTOB78KHMgkTenscDzWYkeT4NM958WjWVg8UagQsCIBI7jpEcc9mCdbK2blryMAEQxyaSj5XHWHz6ViTmT+W66nw2G6f91GFSYS7wsq1i4OooGzkMXjquPNC2pfwpI0LG7TqN91Ex4zu
 ZXW8Uzd3
 nLpLgXteZJJTKrCfkwFT3/a6/VozX7AKYoBa/DwaM4iXVaCjwdCISbMfWHcLSxCdxZJfD74OqFdKQbNkvZ9M3uBLQz4DhyRyz3x6W9Wi2r/++8fKy0EgU56v4FW3JNXzKLMZnzbgA3KWstmFpTqTJTR6CHtWN78vkZKZJy25M/LSv8FrBPAKANjKfu08Hwh6eslFk5KNCrC7kSoK1x2AmD6ZJW318H6JDioBmfYVEvpIO4P3awoeguHAbURjOYjihZWg3X/Q7PreGUCLB9TBQRCMltlb+refTv+iUpLg9GQFiqgusrfIl19/AX0wQjm4NXZ16i30sdVO2iadLOB2pQJ9Pd0YDe7/CyPaX2qA4oWtYqfHmYX0SK+TNhP44wL8fKQrmG4tdCa8h71Kv8VG3wpzARFe505fqlC5CiPVTf2iWtxMsWUQa6kB3nrMkPTUxz7nUXZq0qtMmlZigPZ0Wlz7e3tlyvNwkU4+1duJIAeBQf6P35ZgfCbBwgkp7zkvL5xz+1BIjDL+etM5Q/C4tOOMDXMfRaM6lzziMikvUASZm14COsI9dAck1V2Iz7rxTCgXVGbjs66iQ8nw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 11:44=E2=80=AFPM NeilBrown <neilb@ownmail.net> wrot=
e:
>
> On Wed, 30 Sep 2026, Amir Goldstein wrote:
> > On Tue, Sep 29, 2026 at 5:43=E2=80=AFAM NeilBrown <neilb@ownmail.net> w=
rote:
> > >
> > > From: NeilBrown <neil@brown.name>
> > >
> > > lookup_one() is expected to be removed as it does not fit well with
> > > proposed changes to directory locking.
> > > Specifically d_alloc_parallel() will be ordered outside of i_rwsem
> > > and as iterate_shared() is called with i_rwsem held it is not safe
> > > to call d_alloc_parallel().
> > >
> > > We can instead call d_alloc_trylock() and then call the ->lookup, but
> > > that can fail if there is a lookup attempt concurrent with the
> > > readdir().
> > >
> > > ovl cannot afford for the lookup to fail as that could produce incorr=
ect
> > > results, and it cannot safely drop i_rwsem temporarily as that could
> > > introduce races with handling of the directory cache.
> > >
> > > Instead we rely on the fact that ovl_iterate() has an exclusive lock =
on
> > > the directory, so any concurrent lookup will wait for the ovl_iterate=
()
> > > call to complete.  We allocate a separate dentry and if the lookup is
> > > successful, it is hashed with the result.
> >
> > Please document this assumption with:
> >
> > rwsem_assert_held_write(&dir->d_inode->i_rwsem);
> >
> > and comment in the code. Having it in the git commit message is not
> > enough for future code reviewers.
>
> Yes, I can do that.
>
> >
> > Other than that, I have no further comments, but I would like
> > to have a review from Miklos before this patch lands, because
> > I don't remember him reviewing any of the revisions and this is subtle.
> > I am a bit concerned that we have no test coverage for this subtle code=
.
> >
> > >
> > > When the concurrent lookup gets i_rwsem it mustn't do its own lookup =
-
> > > it must use the existing dentry.  This is found, if it exists, using
> > > try_lookup_noperm().
> > >
> > > Signed-off-by: NeilBrown <neil@brown.name>
> > > ---
> > >  fs/overlayfs/namei.c   | 12 ++++++++++++
> > >  fs/overlayfs/readdir.c | 26 ++++++++++++++++++++++++--
> > >  2 files changed, 36 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> > > index ca899fdfaafd..f56e33fd4d6b 100644
> > > --- a/fs/overlayfs/namei.c
> > > +++ b/fs/overlayfs/namei.c
> > > @@ -1385,6 +1385,7 @@ struct dentry *ovl_lookup(struct inode *dir, st=
ruct dentry *dentry,
> > >         struct ovl_fs *ofs =3D OVL_FS(dentry->d_sb);
> > >         struct ovl_entry *poe =3D OVL_E(dentry->d_parent);
> > >         bool check_redirect =3D (ovl_redirect_follow(ofs) || ofs->num=
datalayer);
> > > +       struct dentry *alias;
> > >         int err;
> > >         struct ovl_lookup_ctx ctx =3D {
> > >                 .dentry =3D dentry,
> > > @@ -1399,6 +1400,17 @@ struct dentry *ovl_lookup(struct inode *dir, s=
truct dentry *dentry,
> > >         if (dentry->d_name.len > ofs->namelen)
> > >                 return ERR_PTR(-ENAMETOOLONG);
> > >
> > > +       /*
> > > +        * The existence of this in-lookup dentry might have forced
> > > +        * readdir to do the lookup with a new dentry.  If so we must
> > > +        * return that one.
> > > +        */
> > > +       alias =3D try_lookup_noperm(&QSTR_LEN(dentry->d_name.name,
> > > +                                           dentry->d_name.len),
> > > +                                 dentry->d_parent);
> > > +       if (alias && !IS_ERR(alias))
> > > +               return alias;
> > > +
> > >         with_ovl_creds(dentry->d_sb)
> > >                 err =3D ovl_lookup_layers(&ctx, &d);
> > >
> > > diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> > > index e7fe29cb6028..bc41da4bace8 100644
> > > --- a/fs/overlayfs/readdir.c
> > > +++ b/fs/overlayfs/readdir.c
> > > @@ -574,8 +574,30 @@ static int ovl_cache_update(const struct path *p=
ath, struct ovl_cache_entry *p,
> > >                 }
> > >         }
> > >         /* This checks also for xwhiteouts */
> > > -       this =3D lookup_one(mnt_idmap(path->mnt), &QSTR_LEN(p->name, =
p->len), dir);
> > > -       if (IS_ERR_OR_NULL(this) || !this->d_inode) {
> > > +       this =3D d_alloc_trylock(dir, &QSTR_LEN(p->name, p->len));
> > > +       if (this =3D=3D ERR_PTR(-EWOULDBLOCK)) {
> > > +               /*
> > > +                * Some other thread is looking up this name and will
> > > +                * block on i_rwsem before it can complete the lookup=
.
> > > +                * We will do the lookup in a new dentry and when tha=
t
> > > +                * lookup gets a turn it will find and return this
> > > +                * dentry.
> > > +                */
> > > +               this =3D d_alloc_name(dir, p->name);
> > > +               if (!this)
> > > +                       this =3D ERR_PTR(-ENOMEM);
> > > +       }
> > > +       if (!IS_ERR(this) && d_unhashed(this)) {
> > > +               /* Either we got an in-lookup or we made our own unha=
shed */
> > > +               struct dentry *alias =3D ovl_lookup(dir->d_inode, thi=
s, 0);
> > > +
> > > +               d_lookup_done(this);
> > > +               if (alias) {
> > > +                       dput(this);
> > > +                       this =3D alias;
> > > +               }
> > > +       }
> > > +       if (IS_ERR(this) || !this->d_inode) {
> > >                 /* Mark a stale entry */
> > >                 p->is_whiteout =3D true;
> > >                 if (IS_ERR(this)) {
> >
> > How do you test your patch set? Do you have tests that exercise
> > parallel create/lookup/readdir?
> >
> > It would be irresponsible to merge code without showing that the `alias=
`
> > branches have been exercised. Do you have an idea how to do that?
>
> I think that to trigger the 'alias' code we would need to instrument the
> code to block and wait.
> e.g.  when readdir sees a particular name it could signal the test
> harness somehow and then wait.  The test harness would trigger a lookup
> of the name which would block on the parent i_rwsem.
> The readdir then continues somehow and gets -EWOULDBLOCK and installs
> the alias dentry.  When it completes the lookup continues and picks up
> the alias.
>
> Is there some way to set a tracepoint to block?
>
> Maybe it would be enough to have something like:
>    if (strcmp(name, "MAGIC_NAME") =3D=3D 0) {
>         printk("waiting for MAGIC_NAME\n");
>         ssleep(15);
>    }
>
> and have the test harness watch dmesg for MAGIC_NAME then trigger the
> lookup.   Then adds some tracing to ovl_lookup() to ensure it picks up
> the right thing...

For this patch I am not asking for instrumentation with CI regression tests=
.
A word from you that you tested all the unexercised alias branches manually
and how (e.g. include printk and sleep test report) is the minimum
that I require
to avoid merging subtle test-compiled-only code.

For your parallel dirops odyssey as a whole, I think that proper
fstests coverage is
a must before the last step of relaxing the dir lock and the sooner you sta=
rt
with this the better the test coverage for all the perp series along the wa=
y.

Thanks,
Amir.

