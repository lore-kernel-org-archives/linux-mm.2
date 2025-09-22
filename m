Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B9E1CAC5AA
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 13:12:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7947A8E000B; Mon, 22 Sep 2025 09:12:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76BB68E0001; Mon, 22 Sep 2025 09:12:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6819C8E000B; Mon, 22 Sep 2025 09:12:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5799D8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 09:12:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E081711AA3D
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 13:12:43 +0000 (UTC)
X-FDA: 83916925806.05.A28B7D0
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf07.hostedemail.com (Postfix) with ESMTP id 034004000F
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 13:12:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WYTjCHwa;
	spf=pass (imf07.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758546762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JFvHbq8BGAwHmjI5XMDiCg9CB8o/Dt308prrHiAcRyI=;
	b=vrjsKpTVl4T3C81VchCRhsbqpsXIBIRaFC/8tnU3l/ZJUuLs1VLBBs/RpIjp6JSTOsosrW
	Fn2dLd0JPOQl2L4qedQPEd7+fI8pO7mC91kC350EfEPiBY9YhBtyf4wMtN8okZw7+gDQR4
	T5SGp8aAWHsacGndtGxQxHKhlMIgPFA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WYTjCHwa;
	spf=pass (imf07.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758546762; a=rsa-sha256;
	cv=none;
	b=1OdakBCptokepvz4B5lmOczefhng4/gkVNcjqX6/Ja6VRlybx3oNLfwLXExytRat2NYMLn
	SH6YsuNsw3DhoBibSPlEYOPTcypCRUXPiSg3Njg9P6fcSVxKPMCJPCiGR8Cz7v0s5PO9m4
	ySzE8RmfZ3Z689uYqvaa8sR20esowJY=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3322e6360bbso1534054a91.0
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758546761; x=1759151561; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JFvHbq8BGAwHmjI5XMDiCg9CB8o/Dt308prrHiAcRyI=;
        b=WYTjCHwavvf/okm6rYYPk1RLHuQ5MntBQbidsE2DAjaf6hJuCzqiYegDx6y52bkbZ/
         LkgNyY+Vm4S4x2DiNwVdT+TpmldAoVJ+SFkR5v7/KkYyloFDAf6qTsu3ZEaPE2mB5sdN
         UgF9b0hKQIUnKf2O4bBdl/YUYz9o1nKTvRSccCC56VH60l6az05F0vQ6dK925w3H0DJP
         7gnGJ6GgidgTOwHnwuzNPJXL1NrUFlKIwYzkPDaFQyvV1wU4fcse9e2onZ7rzxln4Zh/
         /g7vRahdjmdvZhBm8vT7RpLul9vh6qK4fl9wlWUOLCAxKf2HqYfz1Mr9K/Mf+kSkfEkT
         DuWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758546761; x=1759151561;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JFvHbq8BGAwHmjI5XMDiCg9CB8o/Dt308prrHiAcRyI=;
        b=i7Cphbzs5XkKG70o1jDW12wD9LMbfbP4EeKS8eL3hriUBTU4rLi4nqjFmYV3hoHHA0
         IFNi/GfdlPqlADDvgdBEHXxmYX543wBe1iKrkQGjzdW73H+ZhAfKTz0DtN0JCn5JA5f+
         FWf6SqECBfnndLhPlWemofAJiTzRxB19zg1Zd9fTO0vZMWf9aIZHgEdQHI7xzV0xcMUW
         0OBcmnF/UUgxb2ecjW1gUdb0nkna/8MHjJglDTGOke5vf/mgqa/600ua8uqMn3af0dza
         H7Kj8gDclRO7epRCDvq1wnqFFKuumVMEGThIf4eEcay0z0h/fc7ZF7snedrXu61LfKuN
         gnJA==
X-Forwarded-Encrypted: i=1; AJvYcCVK3ven3RrBeHSHThln+ZCC1Ok1A/ekULGWaqnDdqtWbHNAKkMW+1EisKG2jK47SE6S8P3s/a5zrA==@kvack.org
X-Gm-Message-State: AOJu0Yz91lCa4GS2J2QVWTEYI2jMfWw4pnA1AV61dWi/MH8Z6vBnUqug
	tYIUXemgkrTuDKJHHU5lVBaA2akfsXeteUyXvtz4J1YCPQXE9C+qEb9+hdE7Rse5yahZ4JxqdHb
	UYZHPNEaHOGOxUWqUf4p+3KCvmaR96as=
X-Gm-Gg: ASbGncv+EqbL1IN+GS4xaX2Bz3rvYAI/lH4b5IoA5A/C/IGSMrMYkseYUBtgHFJBwnR
	t0upCmXnWo2qgUe9EfwjKQ1Aa+S5bzo4OmTNr6GZmJs+b2MKTcgZjMTJuAkkhU9nDPwZt1W+m0k
	SFwvyWAlHicP41sp9o6Ax7kNag/P3xNAKquoiEWGKgJX3o807JmCA6vNrbNuk5EOu7ZxjJZE2pA
	BJ4Ips=
X-Google-Smtp-Source: AGHT+IErOhD8VYTYiXj/emQEmjvSZJYRDnQiUT71TAsYBNpYKZHlMYedIO8UbMKe7SgXnEyy3ylBN2ENEcWlSiRqsO0=
X-Received: by 2002:a17:90b:33c8:b0:330:6c04:a72b with SMTP id
 98e67ed59e1d1-33097fdd77dmr15212107a91.3.1758546760692; Mon, 22 Sep 2025
 06:12:40 -0700 (PDT)
MIME-Version: 1.0
References: <20250918020434.1612137-1-tweek@google.com> <CAHC9VhSbWJ-8tj5BxSTxznGO8zraKRSE31a+tqdfMHB53ef-MQ@mail.gmail.com>
In-Reply-To: <CAHC9VhSbWJ-8tj5BxSTxznGO8zraKRSE31a+tqdfMHB53ef-MQ@mail.gmail.com>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Mon, 22 Sep 2025 09:12:29 -0400
X-Gm-Features: AS18NWCCoF-gEznmiapevcW7RPAuF_YwrH7AbkG9x3tb1Dsso_FuxRXtaZlxNKU
Message-ID: <CAEjxPJ5GidA9oT_fbKRe_nH1J3mER0ggM-dBW=Nuo765JDuQKg@mail.gmail.com>
Subject: Re: [PATCH v3] memfd,selinux: call security_inode_init_security_anon
To: Paul Moore <paul@paul-moore.com>
Cc: =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	Hugh Dickins <hughd@google.com>, James Morris <jmorris@namei.org>, 
	Jeff Vander Stoep <jeffv@google.com>, Nick Kralevich <nnk@google.com>, Jeff Xu <jeffxu@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Isaac Manjarres <isaacmanjarres@google.com>, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 034004000F
X-Stat-Signature: cxyp5mj4xa6kx5pyzza9etuhcb9sdaoo
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758546761-355973
X-HE-Meta: U2FsdGVkX1/bSxEASHGfSN/t2We97v7bS/D8vRrJLyxewSUVLqpbtnbZ2d6ThzlFvDu2c8FOrPzVEcQskW1z0YPvwe2mk+OZpCunbcTj4PNUUD0QKFcQvJgbFiSlI/KuxnzkRumZdRvH5mW9d4NPljjQI1RwfXnEVGoUPyiwrS8CoP45WUCdDhuIztcfihJBPBZmLPXzCMTqK3AN+AEFNPISjBoPX+tRo9WUM4lgZ7xvKsRu+XbEg3zAMVlrWtO1geTE8JF2Mexc69oxHwVu43hfqtKrF9CLKm3423Ct5ql86fscfPhdxmRtF+stfgUQxqd8drZchTd0UfgEXo8GdZ8O2/JjDh8cEJnJy203wnIo2hrUcBgaIlpofom/ePPjJoE3XJ1yg2961IJ/CTstOlUANviVFXfSmTyPre/O4TuBUGcpbpxSJMWQnVyOE8h56xaZELm3hzo4rVev+G0EVeUYBs406sD6feP3AAzXuS+ssn6JcnT19Fafb/J5brkbl8HfIXyy4zpNKUDY1vuyWsW1TD64R71foQiawXe7F0tsNTyKtbfdn1pwyRgjfn+Fwa6B7xaOIXXmihCE2DdgHoeOgzKVYJlo6Z2Im+O83s4ymacvn5LTn4z0yj0owcPA8LORHHcxEmqGji0I+fn9ZwlMuFddf7L1IinupH8pGSPRWHu7gcX8iCk7sLAXrGY9Fm9h90E9VvWJvPS7Y1tzOc5FHxG7PGQugdPKkC1uSx7vvdA4vHwJ9wJK1N8/YGHSOfHPBSuJIXIlw5bTLP0rNh9LbtqkEm+saIQd92OZqyjGRcOgSptbZn+PhZDr3bJ/TLZER4w/aasF6SrxNJY/GgjH64V5YwjHa8Aa3xYJTeJCObv6Kte9PT0weQJrypHq2sa5Th2ExSnuRb1AMaX8zsY6LbzcoiakA5tz8vKJj223Y6mCwJFoztHyIJnaahVenqkWHEl/yg5wWQd34Lu
 KFrpSLuv
 DjhIOIhV26h/OeO8vUcr75oNbm4f1/eePV48XpEgLdDYgFocvXofgHnXeB1Z1YyTR0IAOS44ZV1kVwDx8zEwkCTOvZl5/1nnozt9aI7i8/ZLW9rCVOSwSuiaJxWkpXGQb1NtaPwxAtrbeZUoz1aW2FtC8n0gJhinE2V/vjhf51i98sCZg9bH8x9sjpSM+A89bWSIKxFC76gy68aDPMdKyA4X5zSUsJZMNntFJwIp+FjV8JMZaVUPVm6eSbAcHca4l4XjwuC3rKoKKZc8lkPWg6VuhV9TNTbaNiLCTQbOQjDKBm7yCHEhVNclXY3e8WkW51SifxQv4aoUe7EOYKBAT+rhlnx7FL53qzxOxe5glUTkbpnjx+2E+jJgcHdPsELTLVcspjhLlPnb3xqyuDYG3lN6KGj8EAstT+dfvBQPuL+9gpBUoqJYpbWRQdiXg0pvPRS+7hnuOpQrN9q5qH9M5PUmm1/nFExgHbd7ONRNUBwfONnI5EQs9/ygp2zZAMyGvRbNQ8pif0faW8INTvNu8OGrTkMUMaB91o4dflILkqYtcYwsc3j8/U/6VFw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 21, 2025 at 2:31=E2=80=AFPM Paul Moore <paul@paul-moore.com> wr=
ote:
>
> On Wed, Sep 17, 2025 at 10:04=E2=80=AFPM Thi=C3=A9baud Weksteen <tweek@go=
ogle.com> wrote:
> >
> > Prior to this change, no security hooks were called at the creation of =
a
> > memfd file. It means that, for SELinux as an example, it will receive
> > the default type of the filesystem that backs the in-memory inode. In
> > most cases, that would be tmpfs, but if MFD_HUGETLB is passed, it will
> > be hugetlbfs. Both can be considered implementation details of memfd.
> >
> > It also means that it is not possible to differentiate between a file
> > coming from memfd_create and a file coming from a standard tmpfs mount
> > point.
> >
> > Additionally, no permission is validated at creation, which differs fro=
m
> > the similar memfd_secret syscall.
> >
> > Call security_inode_init_security_anon during creation. This ensures
> > that the file is setup similarly to other anonymous inodes. On SELinux,
> > it means that the file will receive the security context of its task.
> >
> > The ability to limit fexecve on memfd has been of interest to avoid
> > potential pitfalls where /proc/self/exe or similar would be executed
> > [1][2]. Reuse the "execute_no_trans" and "entrypoint" access vectors,
> > similarly to the file class. These access vectors may not make sense fo=
r
> > the existing "anon_inode" class. Therefore, define and assign a new
> > class "memfd_file" to support such access vectors.
> >
> > Guard these changes behind a new policy capability named "memfd_class".
> >
> > [1] https://crbug.com/1305267
> > [2] https://lore.kernel.org/lkml/20221215001205.51969-1-jeffxu@google.c=
om/
> >
> > Signed-off-by: Thi=C3=A9baud Weksteen <tweek@google.com>
> > ---
> > Changes since v2:
> > - Add WARN_ON when using unexpected class. Return -EACCES instead
> >   of -EPERM
> > - Remove extra new line
> > - Rebase on selinux/dev
> >
> > Changes since v1:
> > - Move test of class earlier in selinux_bprm_creds_for_exec
> > - Remove duplicate call to security_transition_sid
> >
> > Changes since RFC:
> > - Remove enum argument, simply compare the anon inode name
> > - Introduce a policy capability for compatility
> > - Add validation of class in selinux_bprm_creds_for_exec
> >  include/linux/memfd.h                      |  2 ++
> >  mm/memfd.c                                 | 14 ++++++++++--
> >  security/selinux/hooks.c                   | 26 +++++++++++++++++-----
> >  security/selinux/include/classmap.h        |  2 ++
> >  security/selinux/include/policycap.h       |  1 +
> >  security/selinux/include/policycap_names.h |  1 +
> >  security/selinux/include/security.h        |  5 +++++
> >  7 files changed, 44 insertions(+), 7 deletions(-)
>
> Thanks Thi=C3=A9baud, I'm going to merge this into selinux/dev-staging no=
w
> with the plan to move it over to selinux/dev after the upcoming merge
> window closes.
>
> Hugh, since the changes between this patch and the v2 you ACK'd are
> minimal and limited to the SELinux error handling code (see diff
> below), I'm going to carry over your ACK, but if you have any concerns
> or objections please let us know.
>
> Thanks everyone!

When would you recommend that I re-apply the corresponding userspace
patch to reserve this policy capability number for memfd_class?
After it is moved to selinux/dev? Understand that it isn't truly
reserved until it lands in a kernel.org kernel but would prefer to
reapply it sooner than that since there may be other policy capability
requests queueing up (e.g. bpf token) that should be done relative to
it. Can always revert it again if necessary, at least until another
userspace release is made (not sure on timeline for that).

>
> --
> paul-moore.com

