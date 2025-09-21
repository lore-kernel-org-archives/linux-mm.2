Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3840CCAC5A7
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 20:44:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A12D8E0002; Sun, 21 Sep 2025 16:44:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 352298E0001; Sun, 21 Sep 2025 16:44:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 240338E0002; Sun, 21 Sep 2025 16:44:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0A9868E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 16:44:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9F9E2119E84
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 20:44:43 +0000 (UTC)
X-FDA: 83914436046.09.F32546C
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5DF39120004
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 20:44:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=ABDASk4L;
	spf=pass (imf29.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758487481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lrp1vYn8+/NUY8DL+Z+wSSTE0867IgQjPinmMLmeavI=;
	b=N9v8qUYDRHfiILsyuL+smPbZFwI2GGDSKPG7MWy3TG+vqk/ErBL4stk9a0fVs46RuVVTPc
	ZMgsSlh4mWZyQJn50G9dWci+REEILPW5Fiw1s6o5mcmCTKniLVdWCVJB0sTXIwbmfAaWtN
	vY7qyzBptKbPkm8n9g1tAxaFgBXIhzY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758487481; a=rsa-sha256;
	cv=none;
	b=zD7tm0Ednys7i7kzTWECvnTy4kSSis+ntShgmpGGE7tACsCNDmNJSexo9y22h9tWn612+C
	JLdHKj6anCNAXoQHlK0U/QEtfQZcYOzdelbyPE0Zy5Qc4M7KXazw22fc4szbtOskM0/P46
	uUlsLvmrO+echKh53hhegPBXDyD4gOU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=ABDASk4L;
	spf=pass (imf29.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-32df5cae0b1so4072127a91.2
        for <linux-mm@kvack.org>; Sun, 21 Sep 2025 13:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1758487480; x=1759092280; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lrp1vYn8+/NUY8DL+Z+wSSTE0867IgQjPinmMLmeavI=;
        b=ABDASk4LWaFAucoC3RNgKlz9m/S2S7XkV5mJbBd0fn+Xosd1KhQSyJFUz7A7Gexxsd
         Cpf4Kib94Zzbx7WkECm+LFgOe/zqwAelQwOcqiOTFJJ3zuEz1dX5zMWEa7TBICqUs0Ui
         yTfXKOthzaZM3Axx7a34y33zBasGxD5djxQAyGnHqa53h2WGlUz2eg+cZsqC293aHhcK
         d4W1tc/fDKKBVuVsCwYvmt0Q7hSkN3kotjas/HSOz1tYNzRvHAXlWLvbc2y2VoSzW0NV
         mPDpNoBHJdmD9AI6H8ZCmsVi7UaSNR+VeChhENC4VmzJA/CWb/LZ6PKlEEgwUHlzyjE+
         dYFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758487480; x=1759092280;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lrp1vYn8+/NUY8DL+Z+wSSTE0867IgQjPinmMLmeavI=;
        b=nvH2b8h9MvnJyQxNlxcsZLeegD/LZaaoDXsuc/RqkOsra1EulLa5Nja9GqoYIpC9ZV
         76xp078SlbmG86e6mXTlEVmFfhbe+zt9oYdoo1U59eJ52my5yKDWN0MxjoDkgYITsYaj
         tGfUtvjEZPgbYm3ZHt0R/Pq6nxCPIEmnXJmPl4jmJ7hdO9HTfF3aqXk5nTARCEVgJ+Tm
         eE2thNocNqwHYWS+q+yNELg8wze47w16aigPm07xStCkbUSdtHb97RxwugsZ8x4drQgm
         5w5JN9VWJ/C8wmyxRNLWTVitP7Z+LiH4EFmyFbl/r4XwiaPvFWMlhsy5jrwHWkN0quMn
         VDQw==
X-Forwarded-Encrypted: i=1; AJvYcCXaMdRjmrQB8co3sB1iir6/lkf6flY7E3AXlROZBHfqwcr/cy+m1z3H7qdOKCZWXelXyhQQji/KdA==@kvack.org
X-Gm-Message-State: AOJu0YwRxgF3PtZfyTbHski0vXFvhQNkM4TUvo5I3QjATmXsYx85N9BN
	L5r692hs/XUhgt//ulRYtholNR1LdCtx08Osz0q3hXO34y7e8B+Q9I/VEsvd9e6WCC7B0enzGTn
	w179r3eZQ2niQ8jeLo5WhZoodFgsdGiPTDcilq4Sq
X-Gm-Gg: ASbGncuT28zUXW8TSYF0cYxqxDd8WabVLRo3Rokx8A3DjSMi+IWPOC8InbgsPijLKWy
	y32QP5AzZjPlJ8KPwtdjVipaFq7N10xSkIFlVmCE7Tv7FZJ4xQCuIk0Mwb4ZE0kFNQakRjrYYTv
	LyTZdR3fL/pjTqaygbnCyw9r4ZT699O8kmswFbGZDwid5fiEaYyha+OLlfpMXodxCDj0zjdwCdC
	TNPKsg=
X-Google-Smtp-Source: AGHT+IHAbyCRLo/SSuvdFEQRy5JpOpl0NDRXzF/3drghYuhCInE4K6vDNKt06XHhxx3gZXaSMmGzjnpjA/kIMwyAfV0=
X-Received: by 2002:a17:90b:3c06:b0:32d:17ce:49d5 with SMTP id
 98e67ed59e1d1-33098245d63mr11380894a91.23.1758487480037; Sun, 21 Sep 2025
 13:44:40 -0700 (PDT)
MIME-Version: 1.0
References: <20250920074156.GK39973@ZenIV> <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
 <20250920074759.3564072-31-viro@zeniv.linux.org.uk>
In-Reply-To: <20250920074759.3564072-31-viro@zeniv.linux.org.uk>
From: Paul Moore <paul@paul-moore.com>
Date: Sun, 21 Sep 2025 16:44:28 -0400
X-Gm-Features: AS18NWAIN9lhY1WlDGBZGFYNywlyC9vJx6yZK1w_BS23ADZS6YvZADa5RlquZNs
Message-ID: <CAHC9VhTRsQtncKx4bkbkSqVXpZyQLHbvKkcaVO-ss21Fq36r+Q@mail.gmail.com>
Subject: Re: [PATCH 31/39] convert selinuxfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, raven@themaw.net, miklos@szeredi.hu, 
	a.hindborg@kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, kees@kernel.org, rostedt@goodmis.org, 
	gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, casey@schaufler-ca.com, 
	linuxppc-dev@lists.ozlabs.org, borntraeger@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5DF39120004
X-Stat-Signature: qkgrn9uuwx1f17t3yxsa8qx6yqh444un
X-Rspam-User: 
X-HE-Tag: 1758487481-317057
X-HE-Meta: U2FsdGVkX1/hCouEUPMQSjcsjdlJkvtVbvpLBDl430dakrT6XirzQGBqaVhI2vxEh2UaO7WVpnpFyCrd74KHOLo9q/4to592UiFxg27G9ENoBOE+PIamM22Hk7X71rLgC5hGwhddL4rE2nAtEoPlRXgC+FSmFvoUSSJH9l4cMu0KBfV0iagQRW1GJYfj9EncYK/HWvBtkSAO8vlrudGW2mc1xzdWIRCIPVS6WBME296MYoGhAp9vCLBjXws8y5qgLDiUYcWMLPiWeKga+GdcMQp3k9dChMdLaVkzJCNPCkAc3PekM3g4QCqiMDgYbPzB/En5ia9JnjIRMIeVonSj0JIoo4FV+1glH/0aSgvYxPm0dnhWsAXpkM7AAYKbh8O3DVnHPVhnFuALkAUTx8c7tOMkHGWNN+IdeYm9VClpKrt+lt/F/2PSnwS69Yk+Klzg4GeDuMSmXnP6eJ0obmu1MaUNFWYoFAFArEHFQRelBNBaygtPAU+441Pb86Ezo4VAHDi2F/8RObCxrTDaOLc53uR0ESXg3tBRNyxT/ipo/4Eg/K0v5EuBDZ/saJI6vtNiFukg8X2ZT88O3KTLoUJWUE4ordvxKWNA0Am8fIxfolBFoMQjrIxoO/IG0Ayq/5PLB735fMQA/LONcPVxsz0xxt9eSI7WUz6QV8eT6RRVIYTqbnAShdiQ/p3j8TNImpfMBp0h2X+fENNRPTiioKIMus0+U/2evNobZaFXtfmjXCMJ2pVi6NUwzAYz0t61ugmfn1kcCwO9VOSe6EExM/8KZjadlh+KQJd/yq+JwrnfN5/0UJBuKn1e5ZkOacNAa+zUJoh3GoN4udBBGkm/3eCie6Cwm7lYA/80G58ZqzeS9tqq0GeUIM/TUHCo5/HiP7xzHlrWYxDXkx3kN1Lko4M8JHpKCnRDjLLNuTspssiAzUBA/9HamOhsrGo7vIhK0cFuP5tSd9HLcub2kJngFCX
 DftEiK6Y
 JZVPsAaXmBjIHdflUyrSuQSIdsWlyfILN/FQnrGzCgBHVt5+jmjst0p5TEuXj9nBxVzb/OrxFqkGNZRDmcPLysDL/tkHT+MekuZjII4P5Zq5ooytgal13qCTBqnRTTLsFEEhFCWbN/vr68jJZignwOqQIoE5AL02uFwGF9h9X7wo7nUtAnHNbVkAXnmQEwh46AIv6Y5svM25usNRfJqdWxJP+NGDKYNS/WrE/d0LkVdosGklaowtzPPOOnRpoMK9YpiwhzG30e+ZIty8BpiuSK+gzEETHTUZP1xWM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 20, 2025 at 3:48=E2=80=AFAM Al Viro <viro@zeniv.linux.org.uk> w=
rote:
>
> Tree has invariant part + two subtrees that get replaced upon each
> policy load.  Invariant parts stay for the lifetime of filesystem,
> these two subdirs - from policy load to policy load (serialized
> on lock_rename(root, ...)).
>
> All object creations are via d_alloc_name()+d_add() inside selinuxfs,
> all removals are via simple_recursive_removal().
>
> Turn those d_add() into d_make_persistent()+dput() and that's mostly it.
> Don't bother to store the dentry of /policy_capabilities - it belongs
> to invariant part of tree and we only use it to populate that directory,
> so there's no reason to keep it around afterwards.

Minor comment on that below, as well as a comment style nitpick, but
overall no major concerns from me.

Acked-by: Paul Moore <paul@paul-moore.com>

> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  security/selinux/selinuxfs.c | 52 +++++++++++++++++++++---------------
>  1 file changed, 30 insertions(+), 22 deletions(-)

...

> diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
> index 9aa1d03ab612..dc1bb49664f2 100644
> --- a/security/selinux/selinuxfs.c
> +++ b/security/selinux/selinuxfs.c
> @@ -1966,10 +1973,11 @@ static struct dentry *sel_make_swapover_dir(struc=
t super_block *sb,
>         /* directory inodes start off with i_nlink =3D=3D 2 (for "." entr=
y) */
>         inc_nlink(inode);
>         inode_lock(sb->s_root->d_inode);
> -       d_add(dentry, inode);
> +       d_make_persistent(dentry, inode);
>         inc_nlink(sb->s_root->d_inode);
>         inode_unlock(sb->s_root->d_inode);
> -       return dentry;
> +       dput(dentry);
> +       return dentry;  // borrowed
>  }

Prefer C style comments on their own line:

  dput(dentry);
  /* borrowed dentry */
  return dentry;

> @@ -2079,15 +2088,14 @@ static int sel_fill_super(struct super_block *sb,=
 struct fs_context *fc)
>                 goto err;
>         }
>
> -       fsi->policycap_dir =3D sel_make_dir(sb->s_root, POLICYCAP_DIR_NAM=
E,
> +       dentry =3D sel_make_dir(sb->s_root, POLICYCAP_DIR_NAME,
>                                           &fsi->last_ino);

I'd probably keep fsi->policycap_dir in this patch simply to limit the
scope of this patch to just the DCACHE_PERSISTENT related changes, but
I'm not going to make a big fuss about that.

> -       if (IS_ERR(fsi->policycap_dir)) {
> -               ret =3D PTR_ERR(fsi->policycap_dir);
> -               fsi->policycap_dir =3D NULL;
> +       if (IS_ERR(dentry)) {
> +               ret =3D PTR_ERR(dentry);
>                 goto err;
>         }
>
> -       ret =3D sel_make_policycap(fsi);
> +       ret =3D sel_make_policycap(fsi, dentry);
>         if (ret) {
>                 pr_err("SELinux: failed to load policy capabilities\n");
>                 goto err;

--=20
paul-moore.com

