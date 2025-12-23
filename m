Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15ECCE6F09F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 16:16:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55BED6B0005; Tue, 23 Dec 2025 11:16:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 509546B0089; Tue, 23 Dec 2025 11:16:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 408156B008A; Tue, 23 Dec 2025 11:16:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2BD656B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 11:16:58 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BF3D913AC68
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 16:16:57 +0000 (UTC)
X-FDA: 84251239674.27.FEF0488
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id A48D840017
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 16:16:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I6qMiaoo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of klourencodev@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=klourencodev@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766506615; a=rsa-sha256;
	cv=none;
	b=uRrFXoQQ3rdxwaIqRaYLZJGUXgagAtdWvFZRyhG+DQH2A7YKo7s0J/TNesIJ3obgcKcncp
	ipLZlmi/jDLS26yQbdfk/50TiErIMNMYuFENJZmt6PQ7j0N5d+bpgHDjmtVSvLm9GxxB2X
	sFCFY+Cq1K7J9ygbTB1I8Z7BjicDtU8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I6qMiaoo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of klourencodev@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=klourencodev@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766506615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yArk9/35qez1fha1SQeGLgHIFgOZiKc4DfDSIjBmQ74=;
	b=M7Bcyjl2BAEZs6mxayuZ1JUCnNRX80EvC7c1VOL1/cGEO1tO2l1mEOyFzu0jtN9K3xzKJ0
	/OLaVot8hDtx5ucczE5EEuABStDUVOa9leSRqw3Y34LKK3dZBdstmwtXawX00gyZVJGNIZ
	MbjXlP8ks0MTR5QC3nbWzb1s/reB+nQ=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b735e278fa1so888114866b.0
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 08:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766506614; x=1767111414; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yArk9/35qez1fha1SQeGLgHIFgOZiKc4DfDSIjBmQ74=;
        b=I6qMiaoo34Mj92fYMvyFFyg1H8qXkzd0/rkQ44aPB5m6lwDPGlLcHsqrdc4rY0vGjZ
         fJMvZS/Rin+0oPiUmYfP1bei+9kd0sKyi9x5c7xwjBtP1B4D2pKjPDgmSpeg+dORIAC0
         4K9Gf7OCY5VJPJ1AoGopbBWZfzRBRRgEDgeKaYYAtB5szAVVtrhX0KDstFq9314/pSX6
         5OoXuZjUUuKbEGmPYMlNgbrW7S9ouX2O6wGJYvF67+CjBYU30F3Lmr2fpWU9+OF+cM+w
         judGtszfuDEJw2mcUQOWExfoEFSJG9Bx7cYnBGO4N5XpOuCGE20+2YHYATvDZ4V5zy9b
         5lgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766506614; x=1767111414;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yArk9/35qez1fha1SQeGLgHIFgOZiKc4DfDSIjBmQ74=;
        b=aB6Hy2mh1vECDgDWIgVPb9JMamhHZABr+eB8JUvVz/YkWuDPPYmbQAA5U8avwr9FIy
         jLqdvhcLMg9MvMQroSLbHH9x54rJzEjKs/DxBIt6YMv/Sz0B450BWQ96kgsu7dsVZDEO
         lZ9U6GI4/Tqc4sNg9l+rA30MBPGX7h0GZs1B74XVlxOkVkU3/gqRXrSaJDLOFuP+AiqH
         9+20Lo8f3AEVntHgofwVFTVp7cTwPyq6iJow3eJF4iffau3gz6NdF0MkvhZZQbuTu8S6
         0nUlpFUg0SbV32Qv7lZyyN80CZ6UOW1J4z8AouDp2ycHeV/6du6bkZTwyg4x8SMe/scf
         Aang==
X-Gm-Message-State: AOJu0Yzy7hcpE6REfcNRrVJQR4cMzSEouEknq6mgIVIljbzjKYLX88b/
	48KEb32dlcxogbsgI4n2oNydNXB2RGWolAnIj+xzjHBdmQFgMMMU+dqQfJYaVGAeDxPnV1ACgFG
	5OmuFyBMUxyUwwzx/GomWYQspFcC5M4U=
X-Gm-Gg: AY/fxX78w4EBcpEKKNR5+PSWgYGv1QgnTpm+iG4NF+DlRScDegKaP1Sp5n20TXA5G86
	R3ydQLXvxOr1aAuChztMnb8Qh7xjXE0yUMDlTavF0kIhBp42D3AuUkNluTdgCs1y4LyBel3d3pG
	Y7DamLse/PJ/EjJZcpigZyvokc7NyNMbRA91tQhs6CGnoSaymxzt92ybP4Tv6SRbhogflhtYwD0
	vBYoWDnitqyA4okn4qyhFVymdkhJWzzUQNGOk0thuzd4yxXPLyfT7TTJ+QVw03VV155onNNU7sh
	ZqVplP9XhJE7FzPvCZ7dII1L0Wwy
X-Google-Smtp-Source: AGHT+IE+Ln/PmLzFj1/rk8IPbxzhO6GI/QREXPm+mdf0cYJ2sI/6W2ZIt4SViztyR5o75ZzbgMpXyCNvWTteDXYDa4k=
X-Received: by 2002:a17:907:8686:b0:b7c:e5d6:2462 with SMTP id
 a640c23a62f3a-b8036f60923mr1645586166b.28.1766506613648; Tue, 23 Dec 2025
 08:16:53 -0800 (PST)
MIME-Version: 1.0
References: <20251222141817.13335-1-klourencodev@gmail.com> <961095cd-59d2-454a-9b97-493d12f296a1@kernel.org>
In-Reply-To: <961095cd-59d2-454a-9b97-493d12f296a1@kernel.org>
From: Kevin Lourenco <klourencodev@gmail.com>
Date: Tue, 23 Dec 2025 17:16:42 +0100
X-Gm-Features: AQt7F2rg98pEO-p8Wl2qhlP-7DeDAm_fAhZF56_UPm30BKoVkawWDxWFUUCnG9o
Message-ID: <CAFveykO9tAhGnKCnSD-2_wt3QxMTNF3sW20NGwnPK-3yMd__yA@mail.gmail.com>
Subject: Re: [PATCH] mm/fadvise: validate offset in generic_fadvise
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, 
	Kevin Lourenco <k.lourenco@criteo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A48D840017
X-Stat-Signature: ph1gpw5krx7mdfsga64x9tnzbdchjnpk
X-Rspam-User: 
X-HE-Tag: 1766506615-411528
X-HE-Meta: U2FsdGVkX18SeaTXR4DViJyCj2+YFaRv/DG5HZN2asmKsoh9coMybXsJppIFVmQcPa3+BXbhfXzrJA+OxOze9vjKnc8P4B9VnSdc8Im3S6xXXgTSMBcd0DvasmR1Lj1ckpZrm9FKeAyMyv5w1hMDun4w4GIU3oGymjAzjTrSiby+xakV8g7JK71tGOFQ2sr4djngKi1m0W/BEM7FWTNkPWjLy4Df+jsDs28H6SoYEOAMZhZMlSg2uoolfKlEFBUT7HCjyF00Avhj+vQEPZtfkPCQZMyCCSlVMAK/8p8TlZO/kmLjAxxhtitmopq0+qmXNQ/FoQ8QlgdhpMMu004Cbtlri3Pfk1e1h7M7TxlskAiO80ocGJFNTdTC7vPbiYC6S38J9KbMM8D5nIrkXMBKwxwIXjwfA7zBE4+r/LP55/HSt4cbyyFD+Sr9GPxUU0znMMHE8ZrVyVcoiLRXojWLJTyc125dX/EWhfa9XC5EScFInu4Zs3ceAclDridAoLCzH4WYnB89MOP2K/cAH8s9Th+ua8qLYV9brTps2BCCeSxgudtUJGQgziM4cBFmykPmgYvGqnhECs95i4QYuFugvrK+k3mlniWtjInXObfvfEdHv5DJhc+66sAdmtCfchWUSw5azU9xErEaN1KR6p4LOgaGqGtCVOQscBGvS9gyWqnW6SCFFBDBYIBiTiC+MeWOzyjOhrqYUlg/WdDEQy2gd7gtoIBlZmr0ydACB8mF5J/E7GLFms9X0QaigleaaZzdMTFZGAmkZtWO0GQIkAHew9oZsCUwvY2wrKihmUREyiRJ3oZvKpPaFE+eDUlrCMW1h4mSgj6YmKo9kPhjo1HSMRj1SAFHg9gRJJ/AB2ccrnbXiRO+X7QKeqqLp89u8+l/2+1pCRgZvQhiGzK+80+Ox5kOS8D0FFeK7m4krD1NUN5W4JSpF02Fa0nx6o5208ySsIosmsTyvC5NCd/eCGS
 DrWHvgkR
 QKAHJ8jvQyw4SyJjYxZA3QETN1KSz3oIdjc+i2iP2ZXdCNRYpNmKooHT1Hc+wQIXyRNu7m6gUFstqSFEEw89BWNNDAM14DCvhBV0GRzs/+lgailqGjMDFDmtFWL8HQtZNUYsfe9/TsQlcTJapTCQRfnSVHUZ/jL8YkCt8HtRUFwR3E47m9b+uXca6lxdSkv9ZHBAAqKmldZ9wGQtdOw7447FRkdlG7uPAVl4Hrd9CS5xvWlR2WL5mLCUrf+JX+MM28YDTvUGTtInbDCLSZyOnPeJgYvUDtH4kLFFoMToBNTVCGECzqTt/GLYzqw3c6frPU5R4ph+1u4RTIaKLMRTm0kM7a9tarLjyC7iEuDSWZgeRBoUOrZw6VE4xm6D/pWiPYIP5HypmluMas+em7tlxRCfdt73ZB3BMfakMtYu1febiwHdSoC0mlBjtJQ+f0HLyEN0NbFZ638iqi3MihrvJq5ih53ISqXqZzG9M4Fy9rBhZ/BkmpbaPi+JRYYlhwGgEV/5tPa1pz/deKqDz6z7SNX4P3OFhVj+mRYcPY2n6nmlCP2eajrZNWSg8x9ppD+cD262NZxmXH1th60kOBiynOWP3wpJYrLuhlpqNu64aRSZhyT4BmhRpZ+rpvtAUHPyiPVw09WuNUdCbY7NGMs/1pJ5VpafDXo/EVKpuDGVO4c60p6I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

Thank you for your thoughts and recommendations. Well noted, I will
now start limiting the commit message to those specifications :)

For point (1):

I see POSIX definition like this: "The byte position in the file where
the next I/O operation begins."
(https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html?u=
tm_source=3Dchatgpt.com),
so what is almost certain is that a negative offset makes no sense /
there is no hidden mechanism or anything. I don't think we can
accidentally break users, my intuition is that nobody ever
intentionally passes a negative offset (probably the same for len).

We could rely exclusively on the user to ensure the offset is positive
and follow POSIX recommendation. But since errors can occur, I think
it can be hard to debug where a simple test, the same for len, could
have made their experience easier. I think this is also the path
FreeBSD chose: https://github.com/freebsd/freebsd-src/blob/main/sys/kern/vf=
s_syscalls.c#L4918

For point (2):

Since I think nobody intentionally passes negative values and since
that makes no sense semantically speaking, I think we can consider it
unnecessary to update the man page right now and only think about it
in the future if a negative offset gains a new meaning, for example.

Wdyt?

Le mar. 23 d=C3=A9c. 2025 =C3=A0 10:45, David Hildenbrand (Red Hat)
<david@kernel.org> a =C3=A9crit :
>
> On 12/22/25 15:18, klourencodev@gmail.com wrote:
> > From: Kevin Lourenco <klourencodev@gmail.com>
> >
> > When converted to (u64) for page calculations, a negative offset
> > can produce extremely large page indices. This may lead to issues in ce=
rtain advice modes (excessive readahead or
> > cache invalidation)
> >
> > offsets are normally non-negative, but the API does not guarantee this.=
 Since 'len' is already
> > validated, checking 'offset' here is reasonable to prevent potential sy=
stem instability.
>
> Hi,
>
> we tend to break lines as 72 chars in the patch description. I assume
> Andrew will fix that up or already did it :)
>
> >
> > Signed-off-by: Kevin Lourenco <k.lourenco@criteo.com>
> > ---
> >   mm/fadvise.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/fadvise.c b/mm/fadvise.c
> > index 67028e30aa91..b63fe21416ff 100644
> > --- a/mm/fadvise.c
> > +++ b/mm/fadvise.c
> > @@ -43,7 +43,7 @@ int generic_fadvise(struct file *file, loff_t offset,=
 loff_t len, int advice)
> >               return -ESPIPE;
> >
> >       mapping =3D file->f_mapping;
> > -     if (!mapping || len < 0)
> > +     if (!mapping || len < 0 || offset < 0)
> >               return -EINVAL;
> >
> >       bdi =3D inode_to_bdi(mapping->host);
>
> The man page of fadvise64()/posix_madvise() is a bit unclear. It doesn't
> really specify what's supposed to happen on negative size or offset.
>
> Staring at test cases in LTP, we seem to have:
>
> * Check the value that posix_fadvise returns for wrong ADVISE value
> * Check the value that posix_fadvise returns for wrong file descriptor
> * Check the value that posix_fadvise returns for wrong ADVISE value
> * Check the value that posix_fadvise returns for pipe descriptor
>
> And we primarily only seem to test what's documented in the man page to
> fail.
>
> Which raises the questions:
> (1) Could we accidentally break some users out there?
> (2) Should we update the man page to document what is supposed to happen
>      with negative size or offset.
>
> --
> Cheers
>
> David

