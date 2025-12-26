Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E726E8FDA6
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 11:46:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86E0C6B0088; Fri, 26 Dec 2025 06:46:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81BDD6B0089; Fri, 26 Dec 2025 06:46:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71AA06B008A; Fri, 26 Dec 2025 06:46:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C8506B0088
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 06:46:03 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F243D1410EF
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 11:46:02 +0000 (UTC)
X-FDA: 84261443364.07.BC00C0C
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf07.hostedemail.com (Postfix) with ESMTP id 063FB40002
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 11:46:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GwXrFOYe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of wale.zhang.ftd@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=wale.zhang.ftd@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766749561; a=rsa-sha256;
	cv=none;
	b=PLhSbhPDV9wx4mWg5FpdPdjdJBSH5+ECncH1BN7smrNPyLBEGhpr48aKOJycV6u3pQGyrq
	Y2vSXgHU4hbV9u/LtFr4gcO1Qk2jXoGExjCgyi/ry4LdI7R7hmIQRFfApql9LVlbGFX3tM
	F9OzEeQSk924RvOVhAi6Ov9ObWTNlLU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GwXrFOYe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of wale.zhang.ftd@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=wale.zhang.ftd@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766749561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nWTf6Jy081Mjld70mfd6VuwD4DMHrtkuJq1BgwFcPTg=;
	b=6MXFU75UZva7wJ6uoVB2KLYt5yvoQOHejHf4qntqEgTqBXJ47XJ/RNnqb4czhsazhBVWVQ
	kksS+k6GNlIL+0DUOqA8HUGk3G988y8g9dRIbTTUfFnfYx63j3A5AVLW3wwNeJHmFpkgH3
	tQic5xU7AtrBv97+Kzgo7A4chdggnXA=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b832c65124cso152814566b.0
        for <linux-mm@kvack.org>; Fri, 26 Dec 2025 03:46:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766749559; x=1767354359; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nWTf6Jy081Mjld70mfd6VuwD4DMHrtkuJq1BgwFcPTg=;
        b=GwXrFOYe0E90Re5gSlT0K51HSY0KI9zpMGeSXcmKRRYWiXs1VUdgziQ0Z2wqog3AF8
         oAO8AoUvIYicieB+TzD/HuIp9VpePaRIDicD6jP1Bem9n2jQFWQGE+8ZKOopBIeg4neT
         AOv7nhIonRn+mVUEjmig9cr0LXUykNZQz+1Yy017EE5h2uRIESSmmN5ZBv0J2HuI8a7A
         gWVyHN6q9spYpsgMnHsPLXFiDhJVPgyCIZgzazNK/LF3s9pI+e5ToKV4muwrvdzywK17
         iag4yx946btZ+0l2/gLb9r0pEgfP4NyY+dOItlGw+8czBJEpyylzo+wfrXxqY6ENG177
         dE4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766749559; x=1767354359;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nWTf6Jy081Mjld70mfd6VuwD4DMHrtkuJq1BgwFcPTg=;
        b=mjuJp0noQXJpwcEFHEd2tZ0f2Atk7aJBp1Iu8zGm7+UWE+pCvdhZtUXkYr1VpvE1h2
         QKA3xsA1W/NLYMB6SVtEmWhyygj3E0Hoh1Es093SMQf+9BoBoB3KrAnz9rlif6vV7f/i
         8UjOvfGALWhJpqIUbrK2RxuWsw03Dwp0XNF7lmdEcsz1eih6KUs/u2JXRWp9c7qNFRkD
         jwCtlXC4409oGyTwSoxmzTlXyWo+LBTS2VsAKSQPQoGbeiHhcGFTHmxakaSypfvz8yva
         eB/zr4Q7r15dz6nV8FlLwQPOyZqVhqDUrKM6ujs6dJpTIlvLxPOhhHcagBRBKs8OqcrN
         +maA==
X-Forwarded-Encrypted: i=1; AJvYcCU34wjIROSJiy1EffZ9lyrmrR+3GZPW6v71fN81drfSrsHb7RhmR9rH2qkHm6OEvP1CxmtF0kbq6w==@kvack.org
X-Gm-Message-State: AOJu0YxJ5h0ly+zweD90TeKyoShLhPVBS7audiVsHgIX8OGJTMQHDj7W
	o2cH3GWzOxhtdgVRd0YMAaFe62VAkCLqaW0sifO5hCmZ1sqyQSLMAD8i6CBsUyLmNHASU2FxyGv
	dz/uJzfUODi/lthMibz4u4Xgg1wY9r3E=
X-Gm-Gg: AY/fxX48VDNzgzTV+D2v1yB9vU5dgdkhzLVxaI1DYyZdAfzLg1KQZGCv5HbEV7WgqjB
	nTp0RA5/nxeEO26oHkHUlQr/7bsmrwr65gIe/xBOBtsRSw5ZHzyU+YzmqS56pHMfVB5NYaR0aUQ
	vjCXiIn8DPVIx3Jt5HqoGDPIDSxTncKTJv6FuD21mHxHLe1chyEisY0ee0SGFxjKeLIYtpEBk47
	WqKz3lPfa5b8+bTd5jLspivwtlDCmTVs8mV1U9Zx0FM5YPKDS2uR6Hpjh0MGp1l+vAsjkxeH+xR
	TTXbI2c=
X-Google-Smtp-Source: AGHT+IET7L0EaZIuijXcM5k9u6O+CYDY8dObs/k6Xc6EDGrxS9I4wQWBcrOeUfNftubEK1oRoHfA4k+KY8Til6mP/Xs=
X-Received: by 2002:a17:907:971a:b0:b76:3b69:cb5 with SMTP id
 a640c23a62f3a-b8036f2d2admr2278091566b.21.1766749559100; Fri, 26 Dec 2025
 03:45:59 -0800 (PST)
MIME-Version: 1.0
References: <20251225094057.286954-1-wale.zhang.ftd@gmail.com> <CAGsJ_4yEAOxUmrPvca3Nzc-OB0+xXk5Y5gzszsY5TPqHCGvgcQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4yEAOxUmrPvca3Nzc-OB0+xXk5Y5gzszsY5TPqHCGvgcQ@mail.gmail.com>
From: wale zhang <wale.zhang.ftd@gmail.com>
Date: Fri, 26 Dec 2025 19:45:48 +0800
X-Gm-Features: AQt7F2paHBHaIU6Y5O4YKt0D95zCZK3Je57JqwHk46novyOU42GcpYbxUkArxWw
Message-ID: <CAHrEdetNrGJbogkhMKY-25fgtxupPxKKLkwFGuenV8p5EwzZVQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm,swapops: Fix compile error on set_pmd_migration_entry.
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, chrisl@kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 063FB40002
X-Stat-Signature: g1mo3cebri1x7gcan9sfx5xjnnnx7x6s
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766749560-26442
X-HE-Meta: U2FsdGVkX19ZZJcuPbDunTxJGhWcHoQqlD13NuNdpZlRuT00DB2bRsYpon96qD2l5DRvKZ23q3+3cnpu6ui1fNcreVcV+6U7cYeA+m6D+0adqgXUbRWlfJbzZaB9UotC3Vt5JmH0TqKTuE2qtFL89V/XBQPGVzmtl26pChMYPaWXtn9EIImx7m+d1BetEFTRP0OybRZ3LKTdES7ZiBhovmyCwe7x6sBtCHwxRVUzYODeTevqyzswzYgCJCmSxrxy1RNDHlIW/AZJaVo3MSI6jhcDJENfbb3tFsQHhDFCAH4aAXPuT+C2WNZkYBHM7Y+meyrpD0HWgNMfqjSvKv55FoIYXLZvfPQxxn7IwVNLTz2MJHaMiAEMSRuwYt2nd0ADzga4xlz2P7kRbEp5AUlpdLNtOftE0ZDfSUufDYs9jw+BJucISnCA+HHHZ2NNJBtsfYTb7CadjvI8W2a+xhZN3I5dU2xRm970vaNBdb0tCY4ezimgIlOMY82hTn7PVIxc/0KlKO4hCodQcBoDk6QbIC8EGRe35oYxVRO6SM6RX52a9VzEHsxZSD0vxOGcEEN9Q81dMKMfBQ2t6gUGZkN3lMuC4P9P+QJm+Pjh1gAR/CpNQaMBIdzeuZ35pLJ2T9WkJmzkw+iTwF399U5bRodv+6uedYE77nVqNrJHhJept9BLX5cesWJoIFm1aChvtwzo65cWwX+27ZTVXib9A5ovuM/l2/6BvuU67WylnVy4fu3EQjgsvERYpFEqvecQfadi0lzJXolm5g1/WUAmuFM/vJHfksn3ZL8JthW+0h/465oKef5X00QFoD3Vfp8f3eB6GfKzS0worak9YKHkygEgSo5J/cWZsaNmgmDqby/yz+lCY8tf3t2aRaJ8hu7ae5rhAm5vDRy4SDtgVEHxNqPER0CAPO+BvieAIBgG5CquuQfAYau4jIU1cBmR1JjcEwpL8Rzn2rQGDCzRw2Z/kVG
 M8cHVuEc
 gfLJ8uTuim2gHr1BSDFm0D9vMxNLsacOrSgHaBWKiYpyU3SbWHGr8cOvYGL/MsSe5RgTQKSaIQ/Z/61pqeaoo4mXTAfnFTm80xWXEl677SfNCWEIS+IGr+NJLyIZVk1mJXCLkJ65L3sD0FaYLPkAOtD/D1UA164KKRgsA0q4DSbgYofr5w2fMnincWu1OWWal6PfBinPEOHfTd3p7MIGs0NZOO/vkfVu0l+IZ/LgBKNbdx91iJMgCGp9pcg3G0Qn9C2nG4cd/96My0B02R9e7GaUrFYs/Nr0JDhxwNDfs6EUKwNkd09O4AoZYUZaCRkpmaYEIFjE44VTNZy3Ar2soxUvvYRQLsETPIOco6e3+ky0NJ8FCWtGGbdW9oKSxSyGpXNJCM7WIsewLIcBuXDPnAmV/SDB1+Goi4IeYFHz2xohGtOEp5FohMkgj1zNcQDbnzrp5UxFFaBvVG3PAlvfzQvCHnYEw2ZujUKHhywfrRL3QRBo26wlxBMqSXHskmrVE95YlpuyhRTyRHYc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 25, 2025 at 6:22=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Thu, Dec 25, 2025 at 10:41=E2=80=AFPM Wale Zhang <wale.zhang.ftd@gmail=
.com> wrote:
> >
> > ../include/linux/swapops.h: In function =E2=80=98set_pmd_migration_entr=
y=E2=80=99:
> > ../include/linux/swapops.h:346:1: error: no return statement in functio=
n returning non-void [-Werror=3Dreturn-type]
> >   346 | }
> >       | ^
> > cc1: some warnings being treated as errors
> >
> > Signed-off-by: Wale Zhang <wale.zhang.ftd@gmail.com>
>
> Sorry. NAK.
>
> This looks odd. We already have a BUILD_BUG(), so no fix is needed.
>
> we should already have:
> ././include/linux/compiler_types.h:631:45: error: call to
> =E2=80=98__compiletime_assert_907=E2=80=99 declared with attribute error:=
 BUILD_BUG
> failed
>   631 |         _compiletime_assert(condition, msg,
> __compiletime_assert_, __COUNTER__)
>       |                                             ^
> ././include/linux/compiler_types.h:612:25: note: in definition of
> macro =E2=80=98__compiletime_assert=E2=80=99
>   612 |                         prefix ## suffix();
>          \
>       |                         ^~~~~~
>
> Do you actually see this being built? If so, please help identify why it
> gets built.

Hello Barry,

I compile the 6.19-rc2 for arm64 with -O0, this kind of error log will appe=
ar.
In file included from /home/wale/repo/linux/master/include/linux/leafops.h:=
11,
                 from
/home/wale/repo/linux/master/include/linux/userfaultfd_k.h:19,
                 from /home/wale/repo/linux/master/include/linux/mm_inline.=
h:10,
                 from /home/wale/repo/linux/master/mm/internal.h:13,
                 from /home/wale/repo/linux/master/mm/fadvise.c:24:
/home/wale/repo/linux/master/include/linux/swapops.h: In function
=E2=80=98set_pmd_migration_entry=E2=80=99:
/home/wale/repo/linux/master/include/linux/swapops.h:346:1: error: no
return statement in function returning non-void [-Werror=3Dreturn-type]
  346 | }
      | ^
cc1: some warnings being treated as errors
make[4]: *** [/home/wale/repo/linux/master/scripts/Makefile.build:287:
mm/fadvise.o] Error 1
make[4]: *** Waiting for unfinished jobs....

There is an example on my
github(https://github.com/wale-ftd/linux/commits/linux-6.12/) that
used -O0 to compile the 6.12 kernel. If you're interested, you can
check them out.

>
> > ---
> >  include/linux/swapops.h | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/include/linux/swapops.h b/include/linux/swapops.h
> > index 8cfc966eae48..84eb36d97212 100644
> > --- a/include/linux/swapops.h
> > +++ b/include/linux/swapops.h
> > @@ -343,6 +343,7 @@ static inline int set_pmd_migration_entry(struct pa=
ge_vma_mapped_walk *pvmw,
> >                 struct page *page)
> >  {
> >         BUILD_BUG();
> > +       return 0;
> >  }
> >
> >  static inline void remove_migration_pmd(struct page_vma_mapped_walk *p=
vmw,
> > --
> > 2.43.0
> >
>
> Thanks
> Barry

--
Thanks
Wale

