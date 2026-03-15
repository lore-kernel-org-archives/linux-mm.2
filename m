Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00066F30266
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 13:51:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A8376B008A; Sun, 15 Mar 2026 09:51:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15FFB6B008C; Sun, 15 Mar 2026 09:51:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 089966B0092; Sun, 15 Mar 2026 09:51:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA7B06B008A
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 09:51:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 60E1DC30E2
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 13:51:44 +0000 (UTC)
X-FDA: 84548435328.03.5CA5645
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6017F40003
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 13:51:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rp327a0i;
	spf=pass (imf27.hostedemail.com: domain of amir73il@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773582702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LD1Y/Z+QIVaxjTqqF6DEde0TPCIZAs/xYcpmNl5+JUA=;
	b=DzLexW+ZkhNaYjaa4wX/TVO5R3kMdCZRywQeV/HD1OyJTJIxeN6lHVStjgijnIRt+WzcAZ
	f4cbsgj3uC0yXz/xv/hCuCZJxy+0IOt4hpwJ1R+9XNY0w06CRnYadnO8tSHsz3ekLYVkD0
	ogoFXKUxFGE8uc3XMnFHeLWJWuHNF8M=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rp327a0i;
	spf=pass (imf27.hostedemail.com: domain of amir73il@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773582702; a=rsa-sha256;
	cv=pass;
	b=5Qp0syb5cxPfSwl/ziBuz+8J2c5DxhWMN7AkOSlXJMYG7xB/OfKpXKoUu6E1hu50IVXbDL
	2O9orPndHLdM2IOEaYnEluNTZc66Q/SMLOAYH8+BtXEprWetvYPOfIV3539PMnuB3YQrL8
	bUrs5sk3nK02Lx18PvivYNFKX1u5eec=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b94358796a1so519486066b.2
        for <linux-mm@kvack.org>; Sun, 15 Mar 2026 06:51:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773582701; cv=none;
        d=google.com; s=arc-20240605;
        b=PWjT79hbYr2901uixTy6ZPMuOscEtJvsWaF/1ZdJX2K0mJoWdi9T4fYE5oYvnLViZ0
         hDkqmg68yQOI0+ArKYQHuOAp5Q96cJgLKCCNj2BCyY+r29ce2Zw2jCtOrHvKtK5vjh1d
         k08Fyy6gXAuXhiG1Qa13wI8fP26T+BJvOfjciAcLjBbLqhb6s49ac9gvnmT1G8Yz3X2H
         8tZ7C8Y3W19sum3DLGu1n55AS6YtuuTEzt+CGwrzXmGsfWJmYkrIiK8kQMmh1lXUQFWF
         riWATNNRDtPrSOLE3JBCDrub+/glz/Z7hy9A8QVzmRuzsx1f+mIwH1rGOtSXC640VIBx
         9ehA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LD1Y/Z+QIVaxjTqqF6DEde0TPCIZAs/xYcpmNl5+JUA=;
        fh=tJBscfk/fxEfCfXxYFT9mGJChOdH7bg7kq181CsBGHM=;
        b=B0O9eLwVRPu4ixfCez1snOKwqjboJn3+xMIXcvdqE5WC+q4jWmIeQfP1hcLQahlCLv
         pU+5dwqCztOy0wRj5lgf86IODy5Oi6vnOQz89jHfQ5FDOSD1JWh8+FH1+/CmU7CDvEgG
         Y9/bypPJB8J7wZshfbFW5yNa+pLdWHSlFzfAdrfh0TGL2rcHbvgBLUfFO2XYckn1QZ4S
         LB/eHlckXBseK3vMOCeBHaT+si2U0JFOlfhiQgtEeuvnMnyde11cLEacMm88YbyVR0h/
         wngaETrJthe7N4blxzHQXUDeyTntnoVbmLuXmKHL2PrtJN8+eH7hajUn5TYb907/0BMu
         ImPg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773582701; x=1774187501; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LD1Y/Z+QIVaxjTqqF6DEde0TPCIZAs/xYcpmNl5+JUA=;
        b=Rp327a0iTl52efDrrxPFO0wVBOwM66pR/KbCdfGaaFBqTN6svtDdqkRWWKCwRbaE6G
         9rf7CR8VX56LoVXhauRWmbE0gB83zCVZvKAQXDRHax4vmHnaJCBHcEXAT1oV+vRvYRwI
         jUPYAA45RrWUJbhYasoqK7n0x7tWk5nQ/HIG0Eb6uaSZybrAM1M5kCvnONfrDz/ro7Qa
         7GhpdJ9zzqXjpFxIvAca3ULW9AvX9Ul+sVvHE/O+oih1XJRpXVAMkNfEN/qAca8ELxRr
         MECk++wQxw4pAtDBNwG5hP1sDATXqO5my+A63MYcQGbXnBkOe3ZrcAc3UfRPLDyRfXMZ
         HowQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773582701; x=1774187501;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LD1Y/Z+QIVaxjTqqF6DEde0TPCIZAs/xYcpmNl5+JUA=;
        b=I2XdB/kHSF0+j3WPHYmtNv6hbnoAzP6sQdBIRYlWvGoDB6MTMefokE1LYHGvsZYAZM
         2jsn7hl/zmrd//p6uly/PZmXDerF/+osMFVVAZ911GPGTPleQ4M/NVUggQbNsgfITjwX
         PfMNfYSkiWFTJePURcslPctEJ63iqG0cmFpOayZrEInFuod2Z2EVTN0fw8wnGKJp++Cw
         Ce2enaAVx1zPgUW/adVsJIbcW9EmR0LUT590GpW6SZUopRaRE9WVGfOHqs5ICez0XY+o
         /wgiNQVm1NYWZzJO+wQ7BGf02eE+FVp/HhmSFtg1QZ2jmqWeFYenGLlfMGxYKP2u31Ba
         mQig==
X-Forwarded-Encrypted: i=1; AJvYcCXDAJyvipeSr+Exx49QxkOm/BdsvZNxFUZdE7Ir1FEmr1AUwQcByqM3IfbfHdrh+UT/hPs1J/mMDQ==@kvack.org
X-Gm-Message-State: AOJu0YxxHX7ojvKemFgw2ZcbMdJ3hZMaDd6wDg+EjfJ+Smv/56TBbC/7
	nfuapLpFdyiQKFuz2dbVBDvaR1ntzyPbwwybwOD4tu4kQKIwk8miZothlBz2Q31XXDM4oC9W3CI
	+4skc/ZVFVbLmMGv7axZW/QoPaVZaaaQ=
X-Gm-Gg: ATEYQzy0Ys+UarDkhudVtTvnpeL4+DHv5BcDEhYdn9Co3rf4yHo2Z6bjqcUKG4iH+9O
	gUMqIDLopUaQLEH3P8l0+bhm6tK8tGCO7xIj0tiWaqSdYl7jEk1VsRInQqH5fmIjBO9EcNYgDrM
	zBX1N808dFn5RQdSv8MU6O2zqmTY0KXgTNJYfvHyICsBvlRVRvHrataVmae5jL07w7MRGR5Wm+f
	2NKr0RX4la8bkhN2fjeBo8XGhZZqZXTnR6Im4Beu+j6/57SUVNzXdcYJrGfsJzgTn/9Pjhxa3i+
	Z7HtURJ8GeP2ds/CYQq1YFvLgZv5/OAEmANf7vsXQw==
X-Received: by 2002:a17:907:8dcd:b0:b93:c5a9:a5e6 with SMTP id
 a640c23a62f3a-b976507af92mr500109966b.2.1773582699724; Sun, 15 Mar 2026
 06:51:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260312214330.3885211-1-neilb@ownmail.net> <20260312214330.3885211-17-neilb@ownmail.net>
In-Reply-To: <20260312214330.3885211-17-neilb@ownmail.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 15 Mar 2026 14:51:27 +0100
X-Gm-Features: AaiRm50yYPhN2uA9nBAPVNuAVUOhGIEBVS5rPtx5ZlpdDP1j4SB9NhEOC_7KNWo
Message-ID: <CAOQ4uxjmcNxsCmDSVgkTns=3BAuQcT3pVvsQzza+u3iqXqrz5g@mail.gmail.com>
Subject: Re: [PATCH 16/53] ovl: drop dir lock for lookups in impure readdir
To: NeilBrown <neil@brown.name>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Jan Harkes <jaharkes@cs.cmu.edu>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Howells <dhowells@redhat.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Steve French <sfrench@samba.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Breno Leitao <leitao@debian.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, 
	Alex Markuze <amarkuze@redhat.com>, Viacheslav Dubeyko <slava@dubeyko.com>, Tyler Hicks <code@tyhicks.com>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Jeremy Kerr <jk@ozlabs.org>, Ard Biesheuvel <ardb@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, coda@cs.cmu.edu, linux-mm@kvack.org, 
	linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, ceph-devel@vger.kernel.org, 
	ecryptfs@vger.kernel.org, gfs2@lists.linux.dev, linux-um@lists.infradead.org, 
	linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4zb4nh9swrdt551qtb9rbanmyzjwakj1
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 6017F40003
X-HE-Tag: 1773582702-693532
X-HE-Meta: U2FsdGVkX18fcQbDIucnJlSoBjekvQIl4QLcv0+e1eE3S9Vm9eW/r9mB/tq6XV89vrf379upF0IR/OyhtWjxR7DsC0osDGpKV7YQkwuCWsI+jDeH3prlcqhrxceNj22xwfrk5jLN1qSRon9UP+hKdQY6e2NZU0Jo5RCbFRcUBOOpqDiNwEJo+F8LJg/qWMj4RKMlPVeTxvfvw8V2d4QnDFL8+CXc5KShZ2T1RG65FptTryktr5WL+Ft3UDZO4eEReYLF0+RWo07wrARxQuuHfJLsFUB/oBTfcM32IjEbFwLsnAqbpHwaaiF/KfXsEO2UWiOWI99MsPf3IbkCHkAJDITF7CCTZEoeozcc5KIjWTNbn8W/t/Z8brDBQiZXh8Bm4oHmmujxoGcF4gEVzPj1aqShBdBebc3Y7yprlX8B5NR57AMV38nfte0i7RWw2fAWDB+o60lcpNz/C2AduTDjuCG9njHvtICAnPvc7kIGNfFKKMWf7w3UINZr7eINZQreGrcccBPH39GK8e5hgk/wyel5uUxS1USFERPy5u6awDEBGfNe45fq6YOtrQmGtLhhzb21YqGjzLAaCCWhnGMm2iZm2C+guc+iZX0xhxb6MQ1U/y9/Fibfb04KoYWP/LQMLdzA9ZobIXhM5f0MoRe77X8v7PBV+40sMuDdbTpnEN8AUgYjtrQVa0RV3vPiN3QJ0AnYA6FkR2XTffbW0HfgKBAT821Dye6/Iwsm0Y+iaHJKcpt0pR9joj9Q3xiAqNiF6I+1LPilYVO4SBH0EOtOP8apKEgHzqcI6XOI/UieO76tsapkuMdYcnDiaK+E/fS5jhxlRJ7rfwrEqdhiYPNYnXTxa4teoWuVjXwXN+vq8kFPMfwNpW2HJnKhlT369FdsiII3pGi/FwUx4Nivdt0EM9ZUTe4kHQHMzUKUcqyBTN2lqNEbWWXXAR2eShctANN3L0Mo9wOFbNCVOLxM4y1
 Jf1bIwmk
 dXMbmyxoBtCsoMUT8kLjqnxOeuW7mSFr4U8CerZ5DgHpM19P8RcCvXVm3e1ZOcEbM3sEhNyo8PhB2fg9Xxh9r5eIP6HoVCwMcCixi03GMkXAe1ls3GObkzz7KuQUpxz0gpQXI+wiZIGGmKX9wvPWyElV+fqkeIh9+gJlidciSr4g1WojRNnyJk3sX+k+9mMuu+Ozr3CjHS0+qkxJaoudqGLEwFU+vIpttpa5B9p/+hP5zLGgY98LEDrQodTB0lo+441JFSroNYdoXlsLNCJa+vH5e9727WthPz6/yUhU2DE/nL3EshtahHRAvEJ1q2ya1ZmNsIBMrqK1oceMPH4cpQ4tXOd4SvGlid7QRQcXsHRkERSnk/RSwjAne9fudX9XsjY1yMrx7KDf2fe4kjkdoiV25ffo1YHi44haC6vxVOxKPq4x4hIGnC/6BbH46nfGWyurPX1MdBKG96aslogIGQqNIzx8/uQmquTrz4AczVaXVIlYs+y8rN5aq9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 10:49=E2=80=AFPM NeilBrown <neilb@ownmail.net> wrot=
e:
>
> From: NeilBrown <neil@brown.name>
>
> When performing an "impure" readdir, ovl needs to perform a lookup on som=
e
> of the names that it found.
> With proposed locking changes it will not be possible to perform this
> lookup (in particular, not safe to wait for d_alloc_parallel()) while
> holding a lock on the directory.
>
> ovl doesn't really need the lock at this point.

Not exactly. see below.

> It has already iterated
> the directory and has cached a list of the contents.  It now needs to
> gather extra information about some contents.  It can do this without
> the lock.
>
> After gathering that info it needs to retake the lock for API
> correctness.  After doing this it must check IS_DEADDIR() again to
> ensure readdir always returns -ENOENT on a removed directory.
>
> Note that while ->iterate_shared is called with a shared lock, ovl uses
> WRAP_DIR_ITER() so an exclusive lock is held and so we drop and retake
> that exclusive lock.
>
> As the directory is no longer locked in ovl_cache_update() we need
> dget_parent() to get a reference to the parent.
>
> Signed-off-by: NeilBrown <neil@brown.name>
> ---
>  fs/overlayfs/readdir.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
>
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 1dcc75b3a90f..d5123b37921c 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -568,13 +568,12 @@ static int ovl_cache_update(const struct path *path=
, struct ovl_cache_entry *p,
>                         goto get;
>                 }
>                 if (p->len =3D=3D 2) {
> -                       /* we shall not be moved */
> -                       this =3D dget(dir->d_parent);
> +                       this =3D dget_parent(dir);
>                         goto get;
>                 }
>         }
>         /* This checks also for xwhiteouts */
> -       this =3D lookup_one(mnt_idmap(path->mnt), &QSTR_LEN(p->name, p->l=
en), dir);
> +       this =3D lookup_one_unlocked(mnt_idmap(path->mnt), &QSTR_LEN(p->n=
ame, p->len), dir);

ovl_cache_update() is also called from ovl_iterate_merged() where inode
is locked.

>         if (IS_ERR_OR_NULL(this) || !this->d_inode) {
>                 /* Mark a stale entry */
>                 p->is_whiteout =3D true;
> @@ -666,11 +665,12 @@ static int ovl_dir_read_impure(const struct path *p=
ath,  struct list_head *list,
>         if (err)
>                 return err;
>
> +       inode_unlock(path->dentry->d_inode);
>         list_for_each_entry_safe(p, n, list, l_node) {
>                 if (!name_is_dot_dotdot(p->name, p->len)) {
>                         err =3D ovl_cache_update(path, p, true);
>                         if (err)
> -                               return err;
> +                               break;
>                 }
>                 if (p->ino =3D=3D p->real_ino) {
>                         list_del(&p->l_node);
> @@ -680,14 +680,19 @@ static int ovl_dir_read_impure(const struct path *p=
ath,  struct list_head *list,
>                         struct rb_node *parent =3D NULL;
>
>                         if (WARN_ON(ovl_cache_entry_find_link(p->name, p-=
>len,
> -                                                             &newp, &par=
ent)))
> -                               return -EIO;
> +                                                             &newp, &par=
ent))) {
> +                               err =3D -EIO;
> +                               break;
> +                       }
>
>                         rb_link_node(&p->node, parent, newp);
>                         rb_insert_color(&p->node, root);
>                 }
>         }
> -       return 0;
> +       inode_lock(path->dentry->d_inode);
> +       if (IS_DEADDIR(path->dentry->d_inode))
> +               err =3D -ENOENT;
> +       return err;
>  }
>
>  static struct ovl_dir_cache *ovl_cache_get_impure(const struct path *pat=
h)
> --

You missed the fact that overlayfs uses the dir inode lock
to protect the readdir inode cache, so your patch introduces
a risk for storing a stale readdir cache when dir modify operations
invalidate the readdir cache version while lock is dropped
and also introduces memory leak when cache is stomped
without freeing cache created by a competing thread.
I think something like the untested patch below should fix this.

I did not look into ovl_iterate_merged() to see if it has a simple
fix and I am not 100% sure that this fix for impure dir is enough.

Thanks,
Amir.

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index d5123b37921c8..9e90064b252ce 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -702,15 +702,13 @@ static struct ovl_dir_cache
*ovl_cache_get_impure(const struct path *path)
        struct inode *inode =3D d_inode(dentry);
        struct ovl_fs *ofs =3D OVL_FS(dentry->d_sb);
        struct ovl_dir_cache *cache;
+       /* Snapshot version before ovl_dir_read_impure() drops i_rwsem */
+       u64 version =3D ovl_inode_version_get(inode);

        cache =3D ovl_dir_cache(inode);
-       if (cache && ovl_inode_version_get(inode) =3D=3D cache->version)
+       if (cache && version =3D=3D cache->version)
                return cache;

-       /* Impure cache is not refcounted, free it here */
-       ovl_dir_cache_free(inode);
-       ovl_set_dir_cache(inode, NULL);
-
        cache =3D kzalloc_obj(struct ovl_dir_cache);
        if (!cache)
                return ERR_PTR(-ENOMEM);
@@ -721,6 +719,14 @@ static struct ovl_dir_cache
*ovl_cache_get_impure(const struct path *path)
                kfree(cache);
                return ERR_PTR(res);
        }
+
+       /*
+        * Impure cache is not refcounted, free it here.
+        * Also frees cache stored by concurrent readdir during i_rwsem dro=
p.
+        */
+       ovl_dir_cache_free(inode);
+       ovl_set_dir_cache(inode, NULL);
+
        if (list_empty(&cache->entries)) {
                /*
                 * A good opportunity to get rid of an unneeded "impure" fl=
ag.
@@ -736,7 +742,7 @@ static struct ovl_dir_cache
*ovl_cache_get_impure(const struct path *path)
                return NULL;
        }

-       cache->version =3D ovl_inode_version_get(inode);
+       cache->version =3D version;
        ovl_set_dir_cache(inode, cache);

        return cache;

