Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E320CFC518
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 19:43:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 743766B0007; Sun, 23 Nov 2025 14:43:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F3A06B002F; Sun, 23 Nov 2025 14:43:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E26B6B0031; Sun, 23 Nov 2025 14:43:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 458F16B002F
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 14:43:51 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 12111C0169
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 19:43:51 +0000 (UTC)
X-FDA: 84142897062.04.83E575A
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id 17BC2A0003
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 19:43:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=S5jrRsfG;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763927029; a=rsa-sha256;
	cv=none;
	b=XPhXQ4Yuy9ZP6f5Rd+xm0a/93L//ipXCgRNFKLA45bGGDyckrDewzsFpDKphZC37lkcxhH
	D/0YuCyEtKjvIdYD+/3VU4pIfZoQvZ1hhMuE0DtYsm8Z7Crac307wgRDqu8AfNcJseuQ9m
	P2qGRwB4XNa9BzL5Kuj/ElPeyCUFwxs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=S5jrRsfG;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763927029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4t1Ki+s+9/qWluhdQjI8hbyhcgBh9iaju0gMHkm8x5A=;
	b=kw3PLqIoIe/uIFL8u73Y+8UcP5r8CVEe96RWhhBrOt3uB9zMsQx1vbFQZL/MLSZYqAr62z
	5vGm0+CJpUTiMB+WjbXvhmz4/zyV3nt85DKKnwqRwlhvVyggLVX1f48pwUB68V5aoxwbYX
	KJj6F/MHSPzR9ZNLTKmzfMwVd1WVIHY=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-644fcafdce9so5575891a12.1
        for <linux-mm@kvack.org>; Sun, 23 Nov 2025 11:43:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763927027; x=1764531827; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4t1Ki+s+9/qWluhdQjI8hbyhcgBh9iaju0gMHkm8x5A=;
        b=S5jrRsfGy5or1vYMOafKVtxnIFSKFjvBvaCwaycX0xm00P8iDwibirT/gmc8HBT4Up
         hPD0kP2ZP8JQ1uV62TVxIJwTYTGV97mBfdLAoe8LouUDeNtdQr7D/v/AbK2lbXs5Dt2J
         UUk2HdnrYw6yeoew4VYkfSldDSk9SMhwm0UW1Tqp9j6vX1gy9U/SZnmb0lp/0OprIqim
         whFlC8hzqMlHwnuBsXsxuJ8aC454/enHl1nLEtUiwnlo9C65/QHcK6qLgsRwcqrKPj14
         dzAWa4adiGBZVcWrtl7nhbLM8Y8u3x12snjijyyzTKaTNC1c6qWoy2LLuomaXtsP0ShB
         P3ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763927027; x=1764531827;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4t1Ki+s+9/qWluhdQjI8hbyhcgBh9iaju0gMHkm8x5A=;
        b=rOwX2x3d1Db23F8wpsuLW3PT+jZIrNbb3WQi944VPWN8LErxGed7VYP6w8tLwnwPCG
         787fLqmlw2/SgrQnH9LZ5+V8hiPp7q9O6cZB2pIXFMBO/pVf7Im2VQwKY3G3eOosLLXh
         HJrTPKP7BXTwgSjBG/zHiR8A0Ukf71YSqVy/8BSY6Z+AkZwZRWr/AygxbZHfrsL3u26k
         awHYAi+yriKvM+T707w1jNo8zcboZIyXNd4HAHUzeCJ122UDgHwVjkwybatEOvhinypp
         uGhVdEoBfDMafs2OQ7BI5UZWYhNVIusyA1Gr6/RbRYB5/qJc6Ay59LTtqjGoht3PwvQm
         yE6A==
X-Forwarded-Encrypted: i=1; AJvYcCXr3XqJYorbvWD2EmcZJxYK+vYgGPoRE/CQAeki+jl3RPCQSJsi8toZ4NaB0DCWkGGQRb+fFRKnag==@kvack.org
X-Gm-Message-State: AOJu0YxKRO6jsmnjvAzE82/8D0U86OFSVZPxkRvCkDa2UJXofS9/XqAc
	Jkwn3IMW3TDyMvgr6eaWoeAnSCHmrLHT9j6slkEH6adYzdPgA6py5jjCCsk/iZrIR6bQZn2WNU0
	q7+VC0ffl9VK40Kd1KPbGfZcTESZD23xHFbpPwAma3Q==
X-Gm-Gg: ASbGncukFmPxZ8tDhEuf/80c6t+R7hb5lSisGI02s8tR2ct61MlbWIPRXPo/IzNKqTG
	QjIBs+i5hc6X34LK4/H+GaNSIzPjl/sdwifdMagkSaY3TN3H8FpJN81DolxwQANNjfEmL9VVwAX
	5papZ0fcQpLQ7nCGsay/bNR/MwBipqdHPvrcki2W07Aa0owQAfdvAqlVDMHh2cMCEF1biJAtTI5
	ZVKOUKuFKV0e5bclAebpe1ATy2CjHhUuD077KEb6EbrFvOOaO4UaDAjeqOjpVQZME0u
X-Google-Smtp-Source: AGHT+IGshkG9OIG1LcK7+ITFx82jXeFu0RCBTWszC/GeEm+iNWkEZCqMd0w54WVkq/Ok7uWsEjBmuRSK5/xDmSViJXs=
X-Received: by 2002:a05:6402:5414:b0:63e:405d:579c with SMTP id
 4fb4d7f45d1cf-645546946edmr8066481a12.29.1763927027448; Sun, 23 Nov 2025
 11:43:47 -0800 (PST)
MIME-Version: 1.0
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-12-pasha.tatashin@soleen.com> <aSMoRRtanMkHo9Tr@kernel.org>
In-Reply-To: <aSMoRRtanMkHo9Tr@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sun, 23 Nov 2025 14:43:11 -0500
X-Gm-Features: AWmQ_bk6KdHNR7OHR5DSXBcEBpbGAclOQVNeD6WPZt65m_AQR-D_Xk2E-EHVSsU
Message-ID: <CA+CK2bAVNed-biqAnyMySPuDkQQZPFnWp96vdm0ewVS20H2-Zw@mail.gmail.com>
Subject: Re: [PATCH v7 11/22] mm: shmem: allow freezing inode mapping
To: Mike Rapoport <rppt@kernel.org>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 17BC2A0003
X-Rspamd-Server: rspam07
X-Stat-Signature: 9wfa5jnm94o37y6rdtqmonpdbq7crec9
X-Rspam-User: 
X-HE-Tag: 1763927028-371950
X-HE-Meta: U2FsdGVkX1/T5EUuWMjCHiriNYJCO/RZ4g8cCmEvnbNKYkxe2l9q0GpFWbxJxuPDCnCujyfksrW1iy9AuVwrUp3N01aMVdKeiMo3TLYkQsZiNW8TjRBVtZD9ttyigoPGdATHkwaAOr+oUW57d8milP9MMpOuiHAzP+Z3Ni11q+janjpPaY8fS44lwyfHEwI+VEBvFJ8+mtMPBJUKwXsoGPY4OVcKK2ECDhwfvsmNH/KRye140ZPr86VnKqTb8SEOv42h/nnEf/2N1bhPxSs6rKpW+rB10tUrrdGZ3rvwNqQY4X+8EznsujLKbg/b89qIt/iN/2PxMFK6EBQYwQTCApyq4SPpanXN1I7y0BGcqVuvtpH1f4SIM0oJyu+Rpuco33m+jZ2UNb4eUOw5JqXjz6+vt8epndz2e5ckXNjzxdeTCQcAc4Nl9aXtdPduOJwVwYI8uBR7/1W+NoUqI3o2rs4HjNnUGpRD8jMFwA/AOzR5qI6OVXautMvX5gjSN/CMUobcE+aFZzja4KA/ebP6050SJUV59yY/miC4F+VLmVAVzcvXySAajbnFcr0cvNhS2J8zh3PW6sfs/bcO+wadq+2ROO6Uf/zIOLaVF4SvCvTgfi4TMwDQIRJ4bIUFuJmnl7g0TnyA5d68iho1/qMYhrrvIEJR7xXIONWdlXx7qTKDyQFUIXeP7aCogAhO8zlL9rcJlBlw8wP8KAWTlFt19BpwxSmv5/LzIp+CXCWJQ28oyGLocnt0dlKQxfpp4nkbcmHQ26nB2g1J66cnBY18DnkTBWpGI5ytb2BX1uFJfIzELbhx9pHqcH4DWvakcNgZhTC2/u/yKCb4jo0p27ZuTLJTuk/iwvEGbxixciUF5MqGMzSNNypqw8tOse3HdloMNBiANJ2CEmbqxmMIWiVEFrzrdTOQv/5jPRUGT8WcuyiWevSrKlrOExPRuvS/4F3IDRfPVPsXrBa9Jbf71im
 kq2tp6R5
 mx+Yu0B9SFJlcZej7V+FmKCJFZtDvOp3C2dmoyJWEkFkbAvar+NEEa4vOpS7pawfM5+Be56LX+CcQT3ZmJ06B3JeKwjxLwlb06N5LHFXR+p1GHCP4zsWu/XQBNZQXDR1SBT3ANpF/ND6YsExFFsvP2TSIylBiiiCRnmTOu3ybkRw2I4K1ZcLVGIoLGEcHCEkaXcnmejdoEclm+9vgX9X1ic2hLuG8Z1c/7FULE+M2RSLLSWn2YmS/F+nlja6xxEulVglucP7M95pVCrCkCm8iBSl0JXkahRKyM9en04/aApy1wj6/NEswi0O3B8M//o0xjUPYhSVl6a49N5etVKAjbIqRcg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 23, 2025 at 10:29=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wr=
ote:
>
> On Sat, Nov 22, 2025 at 05:23:38PM -0500, Pasha Tatashin wrote:
> > From: Pratyush Yadav <ptyadav@amazon.de>
> >
> > To prepare a shmem inode for live update, its index -> folio mappings
> > must be serialized. Once the mappings are serialized, they cannot chang=
e
> > since it would cause the serialized data to become inconsistent. This
> > can be done by pinning the folios to avoid migration, and by making sur=
e
> > no folios can be added to or removed from the inode.
> >
> > While mechanisms to pin folios already exist, the only way to stop
> > folios being added or removed are the grow and shrink file seals. But
> > file seals come with their own semantics, one of which is that they
> > can't be removed. This doesn't work with liveupdate since it can be
> > cancelled or error out, which would need the seals to be removed and th=
e
> > file's normal functionality to be restored.
> >
> > Introduce SHMEM_F_MAPPING_FROZEN to indicate this instead. It is
> > internal to shmem and is not directly exposed to userspace. It function=
s
> > similar to F_SEAL_GROW | F_SEAL_SHRINK, but additionally disallows hole
> > punching, and can be removed.
> >
> > Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  include/linux/shmem_fs.h | 17 +++++++++++++++++
> >  mm/shmem.c               | 19 ++++++++++++++++---
> >  2 files changed, 33 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
> > index 650874b400b5..d34a64eafe60 100644
> > --- a/include/linux/shmem_fs.h
> > +++ b/include/linux/shmem_fs.h
> > @@ -24,6 +24,14 @@ struct swap_iocb;
> >  #define SHMEM_F_NORESERVE    BIT(0)
> >  /* Disallow swapping. */
> >  #define SHMEM_F_LOCKED               BIT(1)
> > +/*
> > + * Disallow growing, shrinking, or hole punching in the inode. Combine=
d with
> > + * folio pinning, makes sure the inode's mapping stays fixed.
> > + *
> > + * In some ways similar to F_SEAL_GROW | F_SEAL_SHRINK, but can be rem=
oved and
> > + * isn't directly visible to userspace.
> > + */
> > +#define SHMEM_F_MAPPING_FROZEN       BIT(2)
> >
> >  struct shmem_inode_info {
> >       spinlock_t              lock;
> > @@ -186,6 +194,15 @@ static inline bool shmem_file(struct file *file)
> >       return shmem_mapping(file->f_mapping);
> >  }
> >
> > +/* Must be called with inode lock taken exclusive. */
> > +static inline void shmem_freeze(struct inode *inode, bool freeze)
> > +{
> > +     if (freeze)
> > +             SHMEM_I(inode)->flags |=3D SHMEM_F_MAPPING_FROZEN;
> > +     else
> > +             SHMEM_I(inode)->flags &=3D ~SHMEM_F_MAPPING_FROZEN;
> > +}
> > +
> >  /*
> >   * If fallocate(FALLOC_FL_KEEP_SIZE) has been used, there may be pages
> >   * beyond i_size's notion of EOF, which fallocate has committed to res=
erving:
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index 1d5036dec08a..cb74a5d202ac 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -1292,9 +1292,13 @@ static int shmem_setattr(struct mnt_idmap *idmap=
,
> >               loff_t newsize =3D attr->ia_size;
> >
> >               /* protected by i_rwsem */
> > -             if ((newsize < oldsize && (info->seals & F_SEAL_SHRINK)) =
||
> > -                 (newsize > oldsize && (info->seals & F_SEAL_GROW)))
> > -                     return -EPERM;
> > +             if (newsize !=3D oldsize) {
> > +                     if (info->flags & SHMEM_F_MAPPING_FROZEN)
> > +                             return -EPERM;
> > +                     if ((newsize < oldsize && (info->seals & F_SEAL_S=
HRINK)) ||
> > +                         (newsize > oldsize && (info->seals & F_SEAL_G=
ROW)))
> > +                             return -EPERM;
> > +             }
> >
> >               if (newsize !=3D oldsize) {
>
> I'd stick
>
>                         if (info->flags & SHMEM_F_MAPPING_FROZEN)
>                                 return -EPERM;
>
> here and leave the seals check alone.

Done.

>
> Other than than
>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks.

>
> --
> Sincerely yours,
> Mike.

