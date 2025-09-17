Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B2F3CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 00:34:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 735398E0006; Tue, 16 Sep 2025 20:34:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70D2E8E0001; Tue, 16 Sep 2025 20:34:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6227B8E0006; Tue, 16 Sep 2025 20:34:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 50C118E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 20:34:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C12FD1601D8
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 00:34:56 +0000 (UTC)
X-FDA: 83896872192.11.7C01FC8
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf08.hostedemail.com (Postfix) with ESMTP id 022CA160004
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 00:34:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZngmEYMV;
	spf=pass (imf08.hostedemail.com: domain of tweek@google.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=tweek@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758069295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0AF9Zf/ufENcHrKMvHlrpWPSseQ/RzWNQreOKhevrxE=;
	b=XOtU1W1Fl4s9HQI6ACH91wtd07dzMeaRcrbN855Z3jXXyVMO7LYI3GYE0BgG4PmI0tkm4f
	MuKkZkAY4dfxLjK3nGQHZ8KWx8A52nyhsZhu/p0AR18OzmY+Lvh4mwO3UNgXGjYb+yVZKJ
	ULtv/ja5kFO+CAlCB4p19NDuLm7BaTg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758069295; a=rsa-sha256;
	cv=none;
	b=JoJ7FB0wHc9BZTkNEUk6nsZesNN7PuxJoIBk5l1j7xG1LRtwKmcTjJen3dNemBxk7WgYg/
	2ZoiE5D/ThryVqPyVpMF8Swl6JAQlsjeaJkOj/RvvXhjClv6v4egdLK9vU+jpk5VcSI+AK
	6dUtjprno/KecHlAf7kj+PBTAYQex40=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZngmEYMV;
	spf=pass (imf08.hostedemail.com: domain of tweek@google.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=tweek@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5702b63d72bso3992e87.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758069293; x=1758674093; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0AF9Zf/ufENcHrKMvHlrpWPSseQ/RzWNQreOKhevrxE=;
        b=ZngmEYMVTN0fr43jn6izwwGmO9+7gl8kx8+YblWZKP0eH4J8/pZcA26+tEoMK9Fbtn
         Tj1zuEDyD0qKdt0bh3WJC73ciK2wwBuLeM2fV7deuJ+UgE5SzuAvW//sjC8EhGYxmD9k
         P+/t8sIxNwRz6tM16ywDDOicnMUJVIFlNWFH0xbTPuNM/66U4ZZq/OXPzt0uo0sZw1X9
         1dq3cTYt2pE4XMITil7I7mLMZNR8SnHf1Jfnk1xe6IHAzeRVMeZDyqyTouMcExDcJufz
         EdRNvEQr60fxKVj1UAgGj63jPr0yfsH5rlDTz4+ULiGD3IrkZa4Z5+G40w3oTSildo9c
         Vtgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758069293; x=1758674093;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0AF9Zf/ufENcHrKMvHlrpWPSseQ/RzWNQreOKhevrxE=;
        b=pcBuSv/k6QD6w+R3p4tvXNk3Fa462zIMkf30sakN7G0WtDKvMS4rbohIt/qtc6oiC/
         JTw64tIaXncSN1hLc06YRkpXo/jbOx0mhKMi6A9n5Iyk+h4m/mS67kV3SoACPyqocq1l
         dCm81qfF/mq8pfWqGggWbuNmX7Jc0r2HqSincqrDX+GSvpJCaic479lDX0YP+TClcei0
         dCzUbpS7onZGOlcSNc8/fJcZ55Ed9ywROFfc2Km5wTII+DcYDEhnqxnEJ7MBXivU46+A
         hkhSs8m9Dpgl6sW4+Pb3ZijI+kkAnL6wV3ozhjTl21CWVot+D+h83JdcFKTOSX+kkpyU
         NtxQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6XMXB8xbrEsrwiTFcLUWNK24tbIJ2ClCrpp6pNhng8QqXYMAAVJaVqJGMK87m/KA/k8ylJMuyoA==@kvack.org
X-Gm-Message-State: AOJu0Yw7UyxQLZuGQfK3DZMsLQkfad1P11ewsCoRwtu0FYgQ2ULR1pLd
	m3aOHoEBBoO8oLfdP218gLe47DpnevKpScOINJH0+d0LBxlhvvROWgajOOrP4NdpATO66YgcQK1
	yK6NEcOXoJWXb2gO3sA64NUY6oTkmSxg0SVGBp+sT
X-Gm-Gg: ASbGncs33n9n3Mu2N9qwCw8OrwXu66pU8qjXmV6Px/e6JAw3N+a2nbHNesObH7sufQy
	bmmhZ0Ys/PgAMuekcpvSsEUhBqV+x90x3+Z35TBznVrzRysYXZc332D7XfCAqqtNKFiY3A/n7kl
	sN2SpHqnluLg7a8H0/dk6RgYQpMtHBjGBSgKhL9r43uCfTU0BFYdS9XLU8SAMIUZ2buUlSQ27IM
	zGbDKMYTwmuAwv38VZ1okHm959mH/Ti0zNxZlMjjehTMlmQAYM=
X-Google-Smtp-Source: AGHT+IFcyjJzZ4NT9Tir+GT9MJKYCt97IWoZnmQP2gWhP7KEs1D5HqDovMOSpMabAp7PkDXB7hRvrieMLGEHtt4HWvI=
X-Received: by 2002:a05:6512:61d0:10b0:55f:6ac4:c3b2 with SMTP id
 2adb3069b0e04-5774cebae57mr183502e87.0.1758069292874; Tue, 16 Sep 2025
 17:34:52 -0700 (PDT)
MIME-Version: 1.0
References: <20250826031824.1227551-1-tweek@google.com> <6afc91a9f5caef96b2ca335b6d143670@paul-moore.com>
 <92255d5e-7e0a-6ca3-3169-114ae7f6247f@google.com> <CAHC9VhQejS05C8AExkh32GidBdzXjauKPP6T_3eSGZDEwfwDuA@mail.gmail.com>
In-Reply-To: <CAHC9VhQejS05C8AExkh32GidBdzXjauKPP6T_3eSGZDEwfwDuA@mail.gmail.com>
From: =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>
Date: Wed, 17 Sep 2025 10:34:34 +1000
X-Gm-Features: AS18NWBUShakTwgjwy447Q25zdtRhMIo7Iqnzp_7z4P3lmEl_tUSeuf2NkCr0RI
Message-ID: <CA+zpnLe8Z=2qY3rVCyZXyGPOaO2a0V2BVrdMkuwKs789igGCzw@mail.gmail.com>
Subject: Re: [PATCH] memfd,selinux: call security_inode_init_security_anon
To: Paul Moore <paul@paul-moore.com>, Hugh Dickins <hughd@google.com>
Cc: James Morris <jmorris@namei.org>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jeff Vander Stoep <jeffv@google.com>, Nick Kralevich <nnk@google.com>, Jeff Xu <jeffxu@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7jy5otieq9dxd195ty7ndeuukehaii4e
X-Rspamd-Queue-Id: 022CA160004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758069294-639326
X-HE-Meta: U2FsdGVkX1+fN3gdpz7c5aIwfBzWpo6nZ7ixMkIVfR6fwL6BNAYulIAYvgeeX3TO0RYGHGOHFKc/EnJnABjeJJG98s9qoF7+SwUHDvwM9om/JHTDGTe3zld9sEFs+1qRZLQJdptq8pR18fDoC0b9f5pBUlRfGJRznnpzOWnngQddKDIkrnjMyHN+ReXD5PaPUWkTNXa4I4FHh8o2Cop6reJzCBJub8sJe6tzbnVCEizZ7u/TnOsp6owITennkQZSC/a3jq18J4akZg+SKwHev5Q/zpFsTkTEl9Ht0gnw1sQRnq2pTxJ99e73rrwKxR+833PdcQ/ivxE25diUvjSRAApNUsbF43uunUmZI+UXOFm2o4pKR0b2PqsJmx7mFpRIIbFKVEHJqhR0cPsz/gg1/6AtUQNbbH5q2z6CikpRG11VFdZkwm/QDNHz5f/TcOmh0sZ8woNAYEWSjkVZgkqNOVnB/0VbbgucL+sEetNXZqFuPaxt4MSfILLQxr0Csm1mPOMFPQawlVZqqrG+QkecS0ICuWj4hVUSYD1Le85Jc5/zYj1MjpdQDekdHjNvIDWM22okJwkZYWrYdbMALXMLcsMNoZD4/e45ryxQ8ocXCvXjSsSjBe4mEFCvJwcpZWVzRAV21b/qYAwY4PCd9+1Zt0ONQpeBdIBEr8+dlW/PavZKrlAGxhmIBURUpcUAd79bwk6+SZm3RbvGP0ru8CRlgw/TyfGXH+G+KoayHk+PHT0k9XqRXH/278EQTgUVWmIj+b6aC03pV8D4wHOKz4iumLm/ZQ/cJAoeVeyLvgsDAIzNrgJMuSpcNod+R3K8fSWICYkQ8rCaM9KJbIn6CvH1Rp/bF+0R4T3HpPQIqNsn000KTGajvwXABloTnWgtlHL/1RnQfOD9w4Zgn+poReauCw9xqO6Lr+HBLLi4t7olubjKIhY5H1B8p3jsH/Nsw0STUtf9xSsXGD8QkFSxlZf
 +vm3llGa
 SYldaZujYvdxALO8Uy+xqjBAuCx7ttTo0HYH79VOf+qo1f5uR15yajC/Kh7ORggA3ORMETdToUGns8zPWJauR3IKS+KYCFUVW5VvN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 1:26=E2=80=AFAM Paul Moore <paul@paul-moore.com> wr=
ote:
>
> On Tue, Sep 16, 2025 at 1:07=E2=80=AFAM Hugh Dickins <hughd@google.com> w=
rote:
> > On Wed, 3 Sep 2025, Paul Moore wrote:
> > > On Aug 25, 2025 "=3D?UTF-8?q?Thi=3DC3=3DA9baud=3D20Weksteen?=3D" <twe=
ek@google.com> wrote:
> > > >
> > > > Prior to this change, no security hooks were called at the creation=
 of a
> > > > memfd file. It means that, for SELinux as an example, it will recei=
ve
> > > > the default type of the filesystem that backs the in-memory inode. =
In
> > > > most cases, that would be tmpfs, but if MFD_HUGETLB is passed, it w=
ill
> > > > be hugetlbfs. Both can be considered implementation details of memf=
d.
> > > >
> > > > It also means that it is not possible to differentiate between a fi=
le
> > > > coming from memfd_create and a file coming from a standard tmpfs mo=
unt
> > > > point.
> > > >
> > > > Additionally, no permission is validated at creation, which differs=
 from
> > > > the similar memfd_secret syscall.
> > > >
> > > > Call security_inode_init_security_anon during creation. This ensure=
s
> > > > that the file is setup similarly to other anonymous inodes. On SELi=
nux,
> > > > it means that the file will receive the security context of its tas=
k.
> > > >
> > > > The ability to limit fexecve on memfd has been of interest to avoid
> > > > potential pitfalls where /proc/self/exe or similar would be execute=
d
> > > > [1][2]. Reuse the "execute_no_trans" and "entrypoint" access vector=
s,
> > > > similarly to the file class. These access vectors may not make sens=
e for
> > > > the existing "anon_inode" class. Therefore, define and assign a new
> > > > class "memfd_file" to support such access vectors.
> > > >
> > > > Guard these changes behind a new policy capability named "memfd_cla=
ss".
> > > >
> > > > [1] https://crbug.com/1305267
> > > > [2] https://lore.kernel.org/lkml/20221215001205.51969-1-jeffxu@goog=
le.com/
> > > >
> > > > Signed-off-by: Thi=C3=A9baud Weksteen <tweek@google.com>
> > > > Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> > > > Tested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
>
> ...
>
> > > Hugh, Baolin, and shmem/mm folks, are you okay with the changes above=
? If
> > > so it would be nice to get an ACK from one of you.
> >
> > So far as I can tell, seems okay to me:
> > Acked-by: Hugh Dickins <hughd@google.com>
> >
> > If I'd responded earlier (sorry), I would have asked for it just to use
> > &QSTR("[memfd]") directly in the call, rather than indirecting through
> > unnecessary #define MEMFD_ANON_NAME "[memfd]"; never mind, that's all.
> >

Thanks for the review Hugh. In our case, it is necessary to expose
MEMFD_ANON_NAME as there is a string comparison done in
security/selinux/hooks.c (see selinux_inode_init_security_anon
changes).
I would argue it is cleaner to reference the same constant. The
alternative here would be to have 2 copies of it, with the risk of
them being out-of-sync at some point.

> > Please do take this, along with the rest, through your security tree:
> > mm.git contains no conflicting change to mm/memfd.c at present.
>
> Thanks Hugh, it turns out we ended up having a discussion on the
> SELinux side (proper return values for error conditions) and I'm going
> to hold off on this until after the upcoming merge window to give time
> for that discussion to run its course.  The good news is that gives
> Thi=C3=A9baud an opportunity to do the qstr fixup you wanted.
>
> Thi=C3=A9baud, are you okay with making the change Hugh has requested?
>
> --
> paul-moore.com

