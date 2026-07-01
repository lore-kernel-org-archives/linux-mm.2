Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48142C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 01:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D80B06B00A6; Tue, 30 Jun 2026 21:01:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5E696B00A8; Tue, 30 Jun 2026 21:01:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C474C6B00A9; Tue, 30 Jun 2026 21:01:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9ADC56B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:01:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 27A808B991
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:01:23 +0000 (UTC)
X-FDA: 84938404446.01.532C1B5
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2F890180018
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:01:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=ebuH0fTS;
	spf=pass (imf24.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782867681;
	b=LuWU+A4bMgqZEehOuwQ0x+n1baHq9SmBQkkXMLPvzxfavzAThzhRCu852vXUHrQR65LEHV
	tnMFf3QPAgNpK5RFxqDZYPLm1IraKMIVK46ue8jWPGTwmT0KnQUkXfs3994PLMYYgUet8i
	gpFAWkHLvBAKPQ81FOaRuaJ6Y8I59xo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782867681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ci7gWP2h/xtf3jvVwNd+rFboszO2fpzultsBVkBU2u8=;
	b=ukLPaW45Dc+63DldMafwVIvITBQPbviAa8SEOX7h7yDGD4BmQCQ9gmHEyvXbIQUCuP4TTM
	X9yFYKayjQVqO24Bd4/qIqfvudIgsN8TvELb+GnTi9fhxH6kk4x29MFzprRjMpKmVYUOYt
	MBb/5L/Y50ofTcLhHeMbHJ7Zj6KMwq4=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=ebuH0fTS;
	spf=pass (imf24.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-37df416c44bso56409a91.2
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 18:01:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782867680; cv=none;
        d=google.com; s=arc-20260327;
        b=lXdaDXVAh+NDuR34mHGvuzvUIlOpf3MmQ0jX3tthGLIHv9yGX/kfeh3HxQxjIDobSn
         xZZ8wX73S8oegUqtQd9pExEHDnC0ThFh8hQIYoYAdCjWedGaB/wwZCsaqygUSoKn0n9v
         +op5/7/BexD10Od7RO3IAtlTQ6G5WRkMlPfQczuDPbNl/G/H6csq5C2IlS0PqW8obP68
         mg9aw0tnfLL2rAtEEXY8wlHBwjN0L0wVeK4FyZwqPQGslUjRvEWBkPi2/I60Dkq08+gr
         eBcT/+RyTNXWLMGccGrdSMXW/c/SoTcF6IZr9ya68JtpfnPdNByiLs2ZCpJpHnB7XGBY
         mPkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ci7gWP2h/xtf3jvVwNd+rFboszO2fpzultsBVkBU2u8=;
        fh=Y2lP0ZwpDGBZ+ht3lO+L6wb5yQl6uknjndaCZz5uqZ4=;
        b=qPL8+NYbOkmFQzQtnkla/wJgEOmgENxRYlObuhetFB1gcnMRZdUJoV8Og+7kpuc+Rl
         p4GMFdIaB+Nb7XVLCzbCrMbXm9IjSZ00Z7EQnpdxsyq4LPPgH6rdVSk32WGDLRfs4UbC
         H3CBK90UohcliUljcMSkkhO2xMleYnk3gZvM7ZQd2DBwlB78wg0GLCBR0W774zwDI7oU
         Us8bKQBW5cS3PHGw/zdyD8xfg7P6ujKY0s6jyEeBNj1tPFxzMuLeTG+BI1VlsXKmkpoa
         HuszjUOPljyPFQaNIy8UpNyKp0HNrleT1bjjKRwDlAVDWKozogZ9PKef7O0GrJmS40yN
         oE6g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1782867680; x=1783472480; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ci7gWP2h/xtf3jvVwNd+rFboszO2fpzultsBVkBU2u8=;
        b=ebuH0fTSEkmZAQ2SRBnKtLZBHsEQh6SNbvJ62gfUBLXXcdgMZvdIELiPfmkkHp16jM
         up2i0VhS0u9V3Jy/lTduzAoKL7Ly9amh0U+3oTVLlPJJP9k7FDz8GLjpveFSF2hEg8NQ
         bHBthsjnL8HHQTK62cSiTkel+MK4v8/W1tTU8v+WHMqMVNx1Jr34EQ94yej18xYVqfuK
         dmavn2KV6e6kEdxc5HTTsQINY4LwSbD134la10Wc5IwyuEezgJQI+lFgUGrcBPc+SXFl
         jGIjlPW2CYAfSkKISLUtFazEsXzsuliPE9avJq31GKNEjxWeDt3/nBExre6g6tOgVHku
         cbEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782867680; x=1783472480;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ci7gWP2h/xtf3jvVwNd+rFboszO2fpzultsBVkBU2u8=;
        b=Ny2asN3HLQ11FDwkPXtcrfVllb3lqoqo9h4hUtD4Ne34QDe3vVRnc08aFihti745Bl
         c5YZkkPYLz14Qw3LkBSqsGUnoc+gTUMKwwgFtOyb6fXWC2elqRjM1lTNyRcUSarGSq9b
         GeDyvXcgoDLM5Pdp6Is2AZjA/Wmb4Mmj+9UqbjqM2rKzBWTlwwg9tIzQWemMCGTuISHD
         VJYyHBPyczLXfyp19AYTACXVlQHPz8rduR6KPI8c2kySyANpDSYjzXOgwnitzvn4U+Zt
         vdny5FyZrhW8vQfmEzipYM1nGAC2b+I9auuIgBgSAiWlzcZbBel0qd2FZ4t45I+rBSBM
         AHWw==
X-Forwarded-Encrypted: i=1; AHgh+RoQtb97VzXp9s5aodTaQkLKasyhomQWsBNltKiOrUqKHh+UrsAyIAYSApaQK7NSamabGg1zGSp2LA==@kvack.org
X-Gm-Message-State: AOJu0YxiVnHj3L69yV4XYKg1siz7gY2Cvuz+zmhyrydbn+FiB/E/A3bT
	wrGvy8suqy919087fAOsTR0/1oT2vSU7Toll92c+KdeXteu8qdNw1eDxt/0W86ape2RxkdiWR64
	yWoH34MI6nMKJLYNPZqMl8y5A6BSXPsl8iSrjE6gH
X-Gm-Gg: AfdE7ckXTh1q3tDHOXW4GaCWgXL8GLlRcUgwYyzWmUpaVf2wXRCc46mMu9E94w6kDSl
	qXEaNWmxySoQCLqWY/cQZHuY82J/F2b3HcNo3AABCzyIBclakYyaTAZ+leksc3CtTlTMqgyJgDM
	e9t5gIEGQCcHjCyuhNZLNwMguhumIbeIA5gkjQFs5NeC15zLJedsOXNj6jxKK7nPzqKhYwzSio3
	JbHG161Vvr9fcaPnyYONvT0+xLIgy0QIiT3fwl1SBGOWuQK3OWaR4TQTXvi3d5BSPL+WLa/5H2h
	ZNbWr/U=
X-Received: by 2002:a17:90b:4f4d:b0:37f:caf3:171a with SMTP id
 98e67ed59e1d1-38052559d5emr5595765a91.4.1782867679957; Tue, 30 Jun 2026
 18:01:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260630-security-v2-1-560d33c13ee6@kernel.org> <akOZERjhp302jhut@kernel.org>
In-Reply-To: <akOZERjhp302jhut@kernel.org>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 30 Jun 2026 21:01:08 -0400
X-Gm-Features: AVVi8CdzHGjJVtgP64OlHgyKiOBBF-BFKpTaq8pGUJg-AodsMxNfqrpADS4MUHo
Message-ID: <CAHC9VhSekkkDajeFxpjAvaRyUnrfThX9hB1MD3aYBhYMCoRcTQ@mail.gmail.com>
Subject: Re: [PATCH v2] selinux: hooks: use kmalloc() to allocate path buffer
To: Mike Rapoport <rppt@kernel.org>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>, 
	David Laight <david.laight.linux@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4yzoznmhqdzajg9yzttt1nr1arnxegy8
X-Rspam-User: 
X-Rspamd-Queue-Id: 2F890180018
X-Rspamd-Server: rspam02
X-HE-Tag: 1782867681-743996
X-HE-Meta: U2FsdGVkX1/T23+OmhmFxeJIdeKB4m+bysZdxfiZcjQ+V8QBTwek5YMCFSGrcYPqDP+HqoXvG+lByuvWcXRybzcmc65Pibr1aj/rtYU4MRS8wbYLEoNvHmBhF89E1xKYzhdYKuALVnhhag5Hj8dYQext43keSTY4sdLRFtqCtg4Bs8iUK9St2dqiIQw8GIU4NlF+P3pH/IrzSvlL5lDvXrT+RRRRUn3xKdibI89amttiV3s5+B8sxWT4rnBdCj2wO5cBN8WDDWoWlYYOeq2dlJErNBftPfBBHjvzOeLcvuTlGGIm0i63l4vEOAz1JVitAtieSkDXlyfxmX2fA274akFY/3xPwMw07QEaeJksShby8FebIBsJrsz6f6tJfbXAuEaobwX2EjdEM1x4Lxni8cNMASuBFFDx4jYMgokPgGfUi6TOlsN5K8adggAfa55tioDY8t9QizYaF1ZhZIq7hZCv94v7EuE6IDkeBLGml1NJmdrmA5F5t3Ej8L8L+PZkZBKMW90jyi+TSY9oqzph+lR/I9fTqKVlyfaMM5KesgqdmV3rGTpMuGEw2iW0h4gc3srJHgwtTsDDWxLTc2U49fruw1sLR7a67ZaJjs6kDxzNyubeaGXOGoWHncVDRr0JghKIxOESnLZJrh5vQmr072Fpz7H6LEMO6ICXX/cnW1bDh2Bg8x8ylqcClbwLXis8BxBhJKXqULglNy0hdRoIzbchBO/aHf7Vn0XtG2oeKz+cbFJtVoDb9IFVD/kkn2LaqLxxS2mlic1jGMwScBRasFEuIktFr2CwFc9gVnpo0tCY1UWhiqZlnUgEvXtr/4k5Xv2erEJcMcV/Ti9M+nmhNtmk2VbL2EdaI63wB8hVVkECiSAgvukJ/8frZ+3jwKPuKnP9tNVWDJQDm5/sw5ggmRDsvJup0Zx+9fxsORpf4yAJd9VytfuSDPdz6gHy05/nJNk+jfv4pyjM82h4Yc/
 pljxa58t
 nc0H/nl3DkeqvvZbrCRJO4uIdMNzjethNQKVi7vaUVq4R0t7B46Jt54GMRIVeQQWJMDmD7bjPUyM8TWnmIYIb6aHr084tbJvfjXKoJcO+umjUieSX9CfVeoy67rbr+vl4wBUFDfUMKvPYzH3ZoevVhRd2ICTr0qyk7V27LN0dhMNpt0ZmmSgDxOWTN4+rEAVys8tHGy2l/MUpqUptSbTY5SK+qjv4073XRVuYgXeL/WkGuYuycQavMXo8AyNpns+6jGbGl24js4D7cdNRXJDeo3/cmGqbDOYNxX+sZv07jEkz7pOtfAD5PoDdqmJDS2Mr9DW0Fjj+RWxLBzCzZ7xb30nwNmoXisYcIAviVs8NhsNa5XWq+F03zrrgXSgR/+/WpGGoev4VxzLedaBerTmuKRAUlUQ8w5mk7K+qW9sWDQPFLps=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 6:23=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> Should have been:
>
> Subject: [PATCH v4] selinux: hooks: use kmalloc() to allocate path buffer

No worries, I just merged the v3 patchset, it applied cleanly.

> On Tue, Jun 30, 2026 at 01:15:24PM +0300, Mike Rapoport (Microsoft) wrote=
:
> > selinux_genfs_get_sid() allocates memory for a path with __get_free_pag=
e().
> >
> > Such usage does not require a "page" and the size of the buffer should
> > actually be PATH_MAX which may be less than PAGE_SIZE on some
> > architectures.
> >
> > Replace __get_free_page() for allocation of a path buffer with kmalloc(=
)
> > and make it explicit that the buffer size is PATH_MAX.
> >
> > Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> > This is a (tiny) part of larger work of replacing page allocator calls
> > with kmalloc:
> >
> > Also in git:
> > https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-k=
malloc/security
> > ---
> > v4 changes:
> > * rebase on v7.2-rc1
> >
> > v3: https://lore.kernel.org/all/20260531165852.1478916-1-rppt@kernel.or=
g
> > * get the args in the right order
> >
> > v2: https://lore.kernel.org/all/20260531151502.1467515-1-rppt@kernel.or=
g
> > * explicitly use kmalloc() with PATH_MAX
> > ---
> >  security/selinux/hooks.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > index 1a713d96206f..d1f089917a82 100644
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> > @@ -1336,11 +1336,11 @@ static int selinux_genfs_get_sid(struct dentry =
*dentry,
> >       struct super_block *sb =3D dentry->d_sb;
> >       char *buffer, *path;
> >
> > -     buffer =3D (char *)__get_free_page(GFP_KERNEL);
> > +     buffer =3D kmalloc(PATH_MAX, GFP_KERNEL);
> >       if (!buffer)
> >               return -ENOMEM;
> >
> > -     path =3D dentry_path_raw(dentry, buffer, PAGE_SIZE);
> > +     path =3D dentry_path_raw(dentry, buffer, PATH_MAX);
> >       if (IS_ERR(path))
> >               rc =3D PTR_ERR(path);
> >       else {
> > @@ -1361,7 +1361,7 @@ static int selinux_genfs_get_sid(struct dentry *d=
entry,
> >                       rc =3D 0;
> >               }
> >       }
> > -     free_page((unsigned long)buffer);
> > +     kfree(buffer);
> >       return rc;
> >  }
> >
> >
> > ---
> > base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
> > change-id: 20260520-security-6cdd60da7129
> >
> > Best regards,
> > --
> > Sincerely yours,
> > Mike.
> >
>
> --
> Sincerely yours,
> Mike.



--=20
paul-moore.com

