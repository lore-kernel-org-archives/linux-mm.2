Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35691CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 11:51:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5958A8E000C; Wed, 15 Oct 2025 07:51:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 545998E0002; Wed, 15 Oct 2025 07:51:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 434A18E000C; Wed, 15 Oct 2025 07:51:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2DB338E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:51:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BEBCA140122
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:51:40 +0000 (UTC)
X-FDA: 84000183960.11.7200ECB
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf29.hostedemail.com (Postfix) with ESMTP id C0D8A120008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:51:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=gyQwnj9D;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760529098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZeT3Illh7u1oVcNtRdXPfMtGGKxc45UajEsrHq4K7Pk=;
	b=AXgeQEPvCqLm5J8lDfeqmACwjGmIaAgAR4pYniFox6Lsbo6VY0IrGb5CVo/Y7dh8nDZz1W
	Sq+8ReKSr8NGEmZ3+Uno3KHIvhSOyvYgpglSMcKjjNzWwsaAJtzRmPMZjF1K946eoi249t
	srQUxJo8E2iKUkxnRExF07DFt793x+o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=gyQwnj9D;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760529098; a=rsa-sha256;
	cv=none;
	b=LQsOChMWZnjOx9FBVfMp8Je5bz/NeuKM4ePiF/skPDXiQremWjKeOHBohGb/bbGpLIHDqM
	4wrEgWe0eFdZGZHKVZSbXnw4OEYCDrnvMyoN29hoMxnJPinG4d61ihVrsOClz0rojb0D4Q
	LoXJi9uCbmjNZ6MleVEu5Uq1ypEQt4g=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-631df7b2dffso2059379a12.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760529097; x=1761133897; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZeT3Illh7u1oVcNtRdXPfMtGGKxc45UajEsrHq4K7Pk=;
        b=gyQwnj9D3Ez6dgQCUAT7zunr/aL4MSWIF+ShbVISiB3MBWCwE4xyfqWVs88FHlyTu9
         mtz5ciTXs1bfvB6qdMP6YCrFhrlZgGjfuAcoNcI1CLlycFpXtEpkTSd1oYRnjLiCYdkp
         xSSn80Inxi6DBK8dvNiZuLJY2SgEf3HHdgreWNY9XAbC8yL0p9wIJ8nrasBSTopwAm/Y
         ubPd6zS7v8G9Fg++BKOEfg6+zehIyQazlC3MU6KgxmNy6C9xs6oF/b9FwE1VyFzya7Yl
         GcyJc1kprYVeh5lbktoHs/hEh81hCm/eNCIQKPxJ+nOzKU1XSWzLH1vaOj2uruaFWcgA
         KTuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760529097; x=1761133897;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZeT3Illh7u1oVcNtRdXPfMtGGKxc45UajEsrHq4K7Pk=;
        b=WnCVkZ33l+Pe5gJoWlCQTjgkWJfnSmtMNbi0GQK0P77qX5PNN+WPhlenaO3DpLJKXl
         h0+VUB8rwyeH8ehwcHKtSsmdfGSztFNthQQq5lPil4i4e5DaVkddOLSu44/1jI5+QYqw
         h7GJNOtuCs9blwSCHKFb968q56wUctciuDvNbsoDTFh2EsRa27FbwY9bNPSos3KcFqSl
         1K9PZQaKnn+j65CL1ADIj5uKP7blTeMRDlEZfkDk87HWCc5qXe4zK5nRpvE6HAUbTnYM
         rKO+u3hPCCoexRK1y7Z4q/s4Xm5km2DaKBejoyrD+9GiIXSWczF0O64dUBpVeeBD9s01
         JPlw==
X-Forwarded-Encrypted: i=1; AJvYcCXI2Q56DAtGx6rj0CGbHIh3VneY4WAIJSrbpwh2nn/7v89hTvDvcCFW4x9Slvt99JtIBFajVcjwbQ==@kvack.org
X-Gm-Message-State: AOJu0YxFCoVeggc2PxBM/DS593hL00e7S8KBgZLP2AHvG2cXQZ81Ip+K
	yKtNRKkXmCYm2GRhb/oaDissrfNk5+h8TAKlXmjLrqZxn89O8DPA4853E62vsZrB3l05BM1cjtm
	lr8xmgYCYwBgYwfJ9gq/du8RA4bkvF3dpRUgR0udODQ==
X-Gm-Gg: ASbGncsA7gP371JUMJ0uqqqt7W1lts6ucoy2dLvYnZ1SUPOMjORqeGx7wGTyb/SFFD+
	IqHFh9x1z9/JHJlqgFxAn4/SxZ8w0rRtHaPqXeBzhNZbPDrR17yMtSgw7wsuNFrf+mtlBykLlSb
	oFVyPFjJgFoNGmB66sWs3j8y4NJ6lUz3NxutJSihDzGnNZeFHOxufl2tnxi8YQfe2oub1hBqakZ
	BspB8pkAJNOPXcIllheKYne6mkXxDNJ9A==
X-Google-Smtp-Source: AGHT+IG/8dhCCsOd0/KwUpvcxHFj4YxlARVqbw0ANuFg1sGtZK/6OGHoBYZjRNBVqY4UCZqH6zcoIDOBKlsppXGYtBU=
X-Received: by 2002:a05:6402:22ab:b0:631:6acd:fa3a with SMTP id
 4fb4d7f45d1cf-639ba74e058mr23000947a12.4.1760529096051; Wed, 15 Oct 2025
 04:51:36 -0700 (PDT)
MIME-Version: 1.0
References: <20251007033100.836886-1-pasha.tatashin@soleen.com>
 <20251007033100.836886-7-pasha.tatashin@soleen.com> <aO9WvF_WMkKKqYo5@kernel.org>
In-Reply-To: <aO9WvF_WMkKKqYo5@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 15 Oct 2025 07:50:59 -0400
X-Gm-Features: AS18NWBZnQJDAjctj-jgfCdfyiQeHYUPte3YsSfp-LkOjGf7p4zdP8W9aeP6Pbk
Message-ID: <CA+CK2bBC57v_CYdpT-Jcu4LX4MxZZ5CyAJBVTZVXdMnCXR-AmA@mail.gmail.com>
Subject: Re: [PATCH v5 6/7] liveupdate: kho: move to kernel/liveupdate
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net, 
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, pratyush@kernel.org, rdunlap@infradead.org, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8b6jops6xh4epqgsyochjzm11z9sj681
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C0D8A120008
X-HE-Tag: 1760529098-233775
X-HE-Meta: U2FsdGVkX1+HEN7e4GnHSirtuCBhwyOb9bnzmVZ0nxP1f5FeIYGiwX08JG20Z3NMGKCXq3F8AUZ6ujsA4RHcq2Q2Cl7DPNl4ddsrgpet+pGzzDe/CxKyVMkWU3Zc/1gCaTBbj12slDPkNvlabeAq1g5KkprmQlFtifJtSGFNtxBgElyuNo189eYr1X1p9fEEL+I+rBWmRnIVIqULhlmku7BHPwY/0hcf7jRpRKwgc68FVcmhzCppPYQhfgKm6wevuGgiHCet0bIAk6yAuKpqq1SFLK+e8bdIa8GG2gXC+rGQVghZWUH9+IpMnBiCBtbALBKVq9p/CdrmVDqd86ArG4yKTXyr6tDSaf5X1dB2QxofL5GDH/hJMAP3YhfuN0xuqXjIv8nXD83lhRGex9ePIEJmnhrUyOA3a4szi51lLTtci/Cv1EyNva194QkSm1DWHYkOuK+91Delmijs7n9EXZxYZc/ndvD2GbLDe8gLxm7fq5NxLrD5YUhaizSJmqNL1tf7Z/Kq8bZpwYidx+57bZnE9L8kC8hymkZ9BIXkfKdMd67IAs7mctnbfBJSfvy2+ZyIdt4WTORZS0x9WYzGuo8II2gQmgf/ewqg4/xPIfnL7tjiHa87T/Oa1RwSargv31ey81N/MzelNZgGqzhYBH0yS4kb9ye+hYlgCIwbBBdYgMZDSADAIUlmYEEoPYYgSWMVTCYrwXSsd64WB20i6INZM7ylHifKGLjSlRLhITVUk8BBOcW6xPALGQWdUJC0aZ1B5njoF5EDaOBx6jTXJDJbX87reVWkhYstiGI7/YfglJMwyi47oMbqLpQf2Ll4SJA9mFeRb+7kFksAW6OPi2S+2EQfSugS6dqaZUvoaVDfPB6YmoxeQQQ+WKLvNgziiAH24ECx19JVch+BFDE9v34xLT5qRGvKGgq2g+0uo9hLoUfoPzYrhx+QMLd6oheH3m8KbcPGK0xzwmfaDLx
 l5S9yULt
 wLqR4JNpdDsUv9EpEPCbY/tJiy3ygba3ngA+xDwpJfGTnYKqdBN6o7tCDLwnsbZOAfpUfRGeuHNAxQmVqLsDH87kSDeJt63dmX5ry4EhcuwTLx+rCr/12dARP9qaGioeSLmzWWcNghVKzVPdcXbO6r8WZ9y1qJHiCTJaUj2AwkLmsDIMBDw9NRd5Kqlwhy6q83oNds6901JAone80Q7YPR+FRMRHJ4yArgNbWMuQJDrKiCp5ooAnCB5i56mWGmMAZSGOnfnSLxEE1K4y55759sGGwPfE6bMZnXqvxUGLTImkivqc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 4:09=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Tue, Oct 07, 2025 at 03:30:59AM +0000, Pasha Tatashin wrote:
> > Move KHO to kernel/liveupdate/ in preparation of placing all Live Updat=
e
> > core kernel related files to the same place.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thank you.

>
> One comment below.
>
> > ---
> >  Documentation/core-api/kho/concepts.rst       |  2 +-
> >  MAINTAINERS                                   |  2 +-
> >  init/Kconfig                                  |  2 ++
> >  kernel/Kconfig.kexec                          | 25 ----------------
> >  kernel/Makefile                               |  3 +-
> >  kernel/liveupdate/Kconfig                     | 30 +++++++++++++++++++
> >  kernel/liveupdate/Makefile                    |  4 +++
> >  kernel/{ =3D> liveupdate}/kexec_handover.c      |  6 ++--
> >  .../{ =3D> liveupdate}/kexec_handover_debug.c   |  0
> >  .../kexec_handover_internal.h                 |  0
> >  10 files changed, 42 insertions(+), 32 deletions(-)
> >  create mode 100644 kernel/liveupdate/Kconfig
> >  create mode 100644 kernel/liveupdate/Makefile
> >  rename kernel/{ =3D> liveupdate}/kexec_handover.c (99%)
> >  rename kernel/{ =3D> liveupdate}/kexec_handover_debug.c (100%)
> >  rename kernel/{ =3D> liveupdate}/kexec_handover_internal.h (100%)
> >
> > diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
> > new file mode 100644
> > index 000000000000..522b9f74d605
> > --- /dev/null
> > +++ b/kernel/liveupdate/Kconfig
> > @@ -0,0 +1,30 @@
> > +# SPDX-License-Identifier: GPL-2.0-only
> > +
> > +menu "Live Update"
>
> KHO can be used without Live Update, let's make this "Kexec HandOver and
> Live Update"

IMO the current menu name is OK, as it is an option presented only to
users configuring the kernel, my rational for that thinking is that
KHO is an independent module, but it should be enabled as a dependency
by other kernel features that require it.

