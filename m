Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68B4FD43369
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 03:36:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6DA26B0005; Thu, 11 Dec 2025 22:36:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1EF26B0006; Thu, 11 Dec 2025 22:36:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A33C46B0007; Thu, 11 Dec 2025 22:36:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8FD876B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 22:36:08 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3157213AD02
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 03:36:08 +0000 (UTC)
X-FDA: 84209405616.11.3A34FA9
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf26.hostedemail.com (Postfix) with ESMTP id 31F33140008
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 03:36:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cMYegf1j;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765510566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ofnmmsc+p8cbk8w5KbuxpSjDMLzqoPAmhlHL6cy9Bx0=;
	b=fDf3DLeOjscdAw1Ayz/NorznhTXt+PWXtsxWseAHNFjFqp20TDQZQSnGBhh28TCCHecZB8
	jVyxb8Pz45kSgO2mQorv9o25ehJWQG63UDE0kNDh6ParPcp/Urg8tAFbYwTxd4q5tJMyUd
	EK00LDIOyRjQDZxTIrHDZDhGExnWTSE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cMYegf1j;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765510566; a=rsa-sha256;
	cv=none;
	b=vAkpfoAYsnnXkYrzxsklRYZGkyKFDOyy0NYCZttcJYHA1/DxzM5eU0Q/qlBsi1cK95yONR
	FkQKsZCt0vsQTKLjDw71/RRpdxXyamY2i/UQe70EsFUzxP+xNPUft3n5pm5Aziw0Ofidhb
	dWsGWOAvxPLuixXjYGogRq6CGyuJJao=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6418738efa0so1491438a12.1
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 19:36:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1765510564; x=1766115364; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ofnmmsc+p8cbk8w5KbuxpSjDMLzqoPAmhlHL6cy9Bx0=;
        b=cMYegf1j0/BHs9nR2QgDWsXBPm1l+/DRcSiegZc78P2t8BmDVA8Ku7NoQlOjy975KJ
         0ROFSGOeFiKhCH4fFb3W4iamJl7A+X6RzTJdlenpD8NwMczY86hfTtZJ8i+vkE34N7Nh
         dUeZya44R8YAy2H+yrQ2mXNbGVqP2xJ1VtBwFj+BmxMzbOWWFEaTK5I8WM//2DSndgXo
         bcqDgvyXduET7qwkJm8AVkm2ArS78evban08mSITI71NptrUIcm5IL6oK4w4QLOP5KQ0
         RqYGbM9wm/+oZsXuC7+hgIJIdFpNpFWwCWzRC4Fu3ls3PFy+AmSf4NEsjAutUHvTuWYY
         /VqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765510564; x=1766115364;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ofnmmsc+p8cbk8w5KbuxpSjDMLzqoPAmhlHL6cy9Bx0=;
        b=uOETYlt0DqE8Ir5QsmGHBFpLRqGvT8mAO70j8jO3koSGX9p/SpN23jNY0vs7yEtm6I
         MBXdW6hUI5Ajf//pKLnCWc4gULZBFMR+MkaSEBnjf+KLQzwGhuCVzcp6XQGFobw2fJso
         L6gi8bBPPiry84iLsmvEvW5hcYRN/EK1vf/4uF0DDjc/mMH18qFEksKulmbfFgm3I/mc
         MfuxL+Abe662fp2ZQCqjVAoa3yfmgv7nOQ3iRh6yCc6eSFMVeVIJ/GCEJ89cU8HtXj/7
         ARo9x1EFZB+jleUUkLslesVd/Kt5+r7xz36ATCfYoMryvgdr8KNeTHMHRJTA45Pxafs8
         35dA==
X-Forwarded-Encrypted: i=1; AJvYcCUOqhWbe6iE198EkmsVDpmaONAJ0tXzUOPUfn6tTTyZpKSRpQSSgffmxfLAWRxLQQY9rv6sCb5vGg==@kvack.org
X-Gm-Message-State: AOJu0YwZzQbX9Ii2oy1+T3p+vwIvFccmQX32XWERJXzmi1448NO0UZYX
	7LSkTNn24xDhxdDW4nHIQxpAtF/Q9IdK5h3XRzltIZn604+B8xT8KKQldRnE0xM6quVbvrc5tbb
	d3UU3tfco6FL9dbCItuWjG4Aw+SfHgS4BNSmkgJ7KEA==
X-Gm-Gg: AY/fxX4i6i0BducBx/bJ6LlfUxZcfbfJXEGoXnoNdY/jL0Yf8H4KVkCY0mHsTTZ7TiU
	tppIOOT1m81iVrdS6AtMXB0+a9lgPROdq2GQ2fFKvR3C2qlzPYxpO4RWR7SsGcEqZfcH14/X8H8
	dT/JlTpiy9FBaq67wogtwdhU3TkqdndI+2Blx/uXSAyvWrtnqB2mzpg/Vbh0/DYvrH5LaIHfbsN
	bwsurRqhljcvd4uVn26///k1RXq3t/vqQkpUSP6E0DKOw6p/4u5dZfnFXrpJXFWJD/GXji1Bt9U
	B0FuxitwDKZEmG+mMQlBEC57pK+tAQ==
X-Google-Smtp-Source: AGHT+IES7BBbTn7tqCPfnDPHjSNdpqaXrpbRG6DqnnJ1DEXLbtMv8wmJUtOWcZP/vd9EsPmBwealpv5uJAbWVaKwNko=
X-Received: by 2002:a17:906:794f:b0:b72:8489:7e65 with SMTP id
 a640c23a62f3a-b7d23c1e339mr40812866b.31.1765510564545; Thu, 11 Dec 2025
 19:36:04 -0800 (PST)
MIME-Version: 1.0
References: <20250909091335.183439-1-ajd@linux.ibm.com> <336c0402c59363956d0c4eefc1b8a059e1fcc8e4.camel@linux.ibm.com>
 <20250925161726.2b34890070e6d8dcf8ad3ba9@linux-foundation.org>
In-Reply-To: <20250925161726.2b34890070e6d8dcf8ad3ba9@linux-foundation.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 12 Dec 2025 12:35:27 +0900
X-Gm-Features: AQt7F2oPlCrCn0vgeBqPFjk6oJGdLPXS9LGfuM7Cqn1iLUHRy15krGx13xCnA8U
Message-ID: <CA+CK2bDDZi0TR9fhAuKpxz+XJU6-rOS_iM-akU=oTb5wVoVxMQ@mail.gmail.com>
Subject: Re: [PATCH v17 00/12] Support page table check on PowerPC
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Donnellan <ajd@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, 
	x86@kernel.org, linux-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	sweettea-kernel@dorminy.me, nicholas@linux.ibm.com, 
	christophe.leroy@csgroup.eu, alexghiti@rivosinc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fkmk79bikg58338gkr4489d3k1xmhenk
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 31F33140008
X-HE-Tag: 1765510565-798782
X-HE-Meta: U2FsdGVkX1/UjzUZ2u4cvXtpkNEAoXAR3Hmb8nWloBfGLkYLVba130Cu5Gkq9ab6cjX4+yrVupxrHc0DXYhnskOyxPHxzvakL09NV8UepT3OnNglVbJytWNue+9loCk08mFUFFXHvkNmLkYbJKCtqslbCzRSdaagSPkgC89H7JbmfXukUC+oYaiBbAWPEijQJgogpKhfkWJMRuFMjkaBHYGhx5dRZbxqNTcTiiyCmxbXMCaK/e5eC7lWjT3HIBnWnM9XrP6sndmBlMJnOuzOHlQDGlgw1YsAgIEEUE6sZNEa7JZybF8BHvftb9YsE4arlIzn1KIdSkx31SQLyfDCms3tFYicz3xA41kctB1+VJWDG48a8WkS0CRrX16OJYh/LD1E8aVz3MVypA2zG7oFJn1mDJMaPwDBTtddEyrwinMOCVp2nRUpN+Khe4et9uq5kdhdXt83KCXLf6yokfVfpmgH5FcfuX6RPONvL3mIPl/43POAiWjjRLUgbK8LJcNDILVkgvcHrHWjlyRzkOCZw0uwtvSdVgC0g4nCEmBUAQfHOxy1yA02e2WkC6DIxK7lBDJmlAgMCF4xxrHYDUirroY7ds8i8tJQmgHA7jdHN3wOQN5tiHpMl7mCxIknHw584fvU3dVOIGVqJ43jPXcOgT0oMCrftxvcqD/qlrqOymwmuHM38g6VuHw43rDl391PNageSTmAYPsHeQLVg5sxuMC2oH80X6lL6AijNhoRxnBVLbh/cZlOkWuMpqvxYnmNJa4kNGpdC/3nW7MP8uEdkzQwOjRBqQC6pRmd7bXu5YQx+qz+/OLZVjjxoa5xvKTJPSz0p3feSjfhdpW5LGeWI6qbo0e20er1Rg2wpuRaNOLY7b+BFhWQL3s8gXo33J+gfYq9HibqAG+aEjW96Ic3amv1RgwKKDzHP2zhj9gurx40bcG0EW6IDZCJ3ZMesoEb24C/fQG5oDh4IWaaUdk
 d5XX3pmm
 qcDpoqIp8lWUsKSvhAWyuuFmgleGo+JgIRlk/GPBW2Lyh+YA76csZ0mW+h70qd+TQOdDP7XJrQKJzqau7gqoQKdBGAz7MAeOmu9nZY9MSYjP2CnVTcIbC5NAB5e8grqTDPPACQYswWDiV6a2tBG4HOoiAC0XP3JzA5W9ET3sWLv+c3KvGmbZVTDgUgSdbJ3YbQSfwh3jx/2QAbsDblray5dy8P3guiwV2SmmdPhgEJih1zsQ429Zz6e1ck+3nH047fkRZJ0IDlkUN0jihpSEXOAOg7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 26, 2025 at 8:17=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Fri, 26 Sep 2025 08:42:35 +1000 Andrew Donnellan <ajd@linux.ibm.com> w=
rote:
>
> > On Tue, 2025-09-09 at 19:13 +1000, Andrew Donnellan wrote:
> > > Support page table check on all PowerPC platforms. This works by seri=
alising
> > > assignments, reassignments and clears of page table entries at each l=
evel in
> > > order to ensure that anonymous mappings have at most one writable con=
sumer,
> > > and likewise that file-backed mappings are not simultaneously also an=
onymous
> > > mappings.
> > >
> > > In order to support this infrastructure, a number of helpers or stubs=
 must be
> > > defined or updated for all powerpc platforms. Additionally, we separa=
te
> > > set_pte_at() and set_pte_at_unchecked(), to allow for internal, unins=
trumented
> > > mappings.
> > >
> > > On some PowerPC platforms, implementing {pte,pmd,pud}_user_accessible=
_page()
> > > requires the address. We revert previous changes that removed the add=
ress
> > > parameter from various interfaces, and add it to some other interface=
s,
> > > in order to allow this.
> > >
> > > Note that on 32 bit systems with CONFIG_KFENCE=3Dy, you need [0] to a=
void
> > > possible failures in init code (this is a code patching/static keys i=
ssue,
> > > which was discovered by a user testing this series but isn't a bug in=
 page
> > > table check).
> > >
> > > (This series was initially written by Rohan McLure, who has left IBM =
and
> > > is no longer working on powerpc.)
> >
> > Is this likely to make it in in time for 6.18, or should I respin it po=
st merge
> > window?
>
> The latter, please.

Andrew Donnelan, looks like the merge window missed again, could you
please re-send this series so we could get it into 6.20?

Thank you,
Pasha

