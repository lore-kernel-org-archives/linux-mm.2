Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8FABECD994
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 17:45:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F04FE6B0005; Thu,  5 Feb 2026 12:45:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB26F6B0088; Thu,  5 Feb 2026 12:45:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D94286B0089; Thu,  5 Feb 2026 12:45:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C69406B0005
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:45:40 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 672691B2A3C
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 17:45:40 +0000 (UTC)
X-FDA: 84411130440.25.6229F41
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf11.hostedemail.com (Postfix) with ESMTP id 621DE4000F
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 17:45:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dlqj0DnP;
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770313538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h5TqVGLIrAUE8R5UW4/g4MhBNsgiRgWoXjFHS4F8lZw=;
	b=tbZ1uS+JNxFq3bLrCBrIhfoqaZTHRVLcovgkg07gwJcrIFQdqf7N/0B96NJh1rFupMIKrB
	Xg3yXILPFcZDi81HbPsDsXrgCpAD8Q3nf3vsSyT5c+LjIgZCnqAy/wHVnJJWCA13JKlj2e
	PLhsXO+HgfL0aWSjRNd+CkNAK7CSTL0=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dlqj0DnP;
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770313538; a=rsa-sha256;
	cv=pass;
	b=m3pqog9eaHwTADo/LSlMmhcoMgsjZGxOoKHN+m0927OnJ/otzcM7LTINws2lyBAUxaaASy
	wCqQDmGWoBTQFQJaNx0X3oPp46TqrXLPWIzUjobGOjTjag5aRoiAVeUQq0CZCPelbBfs9p
	66O6/6Yvga4q5QpF03Ht+H+cr1ORm0Q=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-4359a316d89so1004675f8f.0
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 09:45:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770313537; cv=none;
        d=google.com; s=arc-20240605;
        b=Ka+VQxww35WbSQ+6aRmh9kgo0UJfXaAnqyGUFWGAzlTSyZ6dqgUBsTcHCcNOf5OdjJ
         nuFk85nA5qOtAXKb8uLsaOUQzLNBRFHeK3E2+lm4KPq9cSLUge0Z8Mw7DvMZyUZJaHZy
         62dDNQ9a8a76ui+Klg8kGnvdTaCdGINOBJyGyWmUSZVFH6v3XU0wmbEh+82f+zaRizpB
         +ul2KtvgDfxBjBaZEKeadOleV8mC6p4wIfBuvFIQfjn32DCYJ43KBttLtaL97cNJTkhq
         EQNLLTDld3J3fJq79i2QCeQet/y2+eb1CESSioWYPvFRnWW32iNlaR/mskmCtNQXWVWA
         D3eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=h5TqVGLIrAUE8R5UW4/g4MhBNsgiRgWoXjFHS4F8lZw=;
        fh=W2h8oEiZRBGhmuuFlJoQZw0Bskx6obR9v4i6pYzyYQs=;
        b=HZJxjcSnUBW8R3wfhNwkUeRaSGtkLviy+ITk+XC43M6fUKQBaxPt8KtwhjCKKLTfgO
         G9qwWVM0uSBguU6c0VivCwhdS+qgRn69necxglYcw1yD/m6Ay5hrjMFcPsCGLH4BaB5q
         s0S4yYRHpNtn7nhB1WZHMckw5E58o9IsmHITyLVAfgaH3VZncJiBjO785YzVOtfQY5Mm
         KaGAAeHoWDjUCoZs+aq5eOzZdHd71spNZfoHQ4JR/mBdTFRDtWlt3a9hN4QCknRCAg41
         tNk5BZ5XiyHhxKWORms86Z/GfpYUra5YlaDW0Wl5n0f4hOv3coZ1/n3hFZVye7ZU6kuV
         4Wdg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770313537; x=1770918337; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h5TqVGLIrAUE8R5UW4/g4MhBNsgiRgWoXjFHS4F8lZw=;
        b=Dlqj0DnPk+09cs0wrm8+60lrbB4e17tFPk6A0lTSNO7Cz1tliBNJeKEuQFrw7/fw+7
         i6oDXcW00pHRoFgCJZGIDeIzPP3vzfMvg2BGAUuP3wuXKwT/sbf//a+LV1f0lEb7T/ww
         GMLeEEGXwgM1FjtRtVoUvoNFt0/trVZjxf+vdFXtTy5KI3uPmgl9Dx4dkC/khBnwqn8S
         MGqc1nvWqLuI/CIbyRoL800+5BlvrqwRyVFGzSIbQ589c+orRxRX6c4KEOIphz7TOdPk
         FjVZnnHIHletCAKbwJpEiFnX4BO8hW+9ZbPyj1jFSoERU3JWy5htjGUlCDuVObbiB1Dw
         QM6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770313537; x=1770918337;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h5TqVGLIrAUE8R5UW4/g4MhBNsgiRgWoXjFHS4F8lZw=;
        b=d6qIsnhqrM/W9EKyXWZiVVHzkqbpI+BxRTZ+wT4z1hriq634KQEvmNS5J5wBnFGRbO
         G6FHFDHBChY3kgzGBOzBH/D55m9GAmLdQy8mdohvWO0yxx/f2K+K/Ji6TF161m7sC5gU
         IKPFHSMihCwH9ehIBGEiBnCAoDGObW3aFsbn8+OuIDSzg2tjWWZ+X3WUQyxm4niEtjX7
         IaOzz2ypITbddooxhIvCMuMUX1JPY2T+a/BtDC9NjO6qm42oWSviwfK/j/k+U7cM46vW
         +kz3mCcBGg6/LMW+xO9GP5EqQwdM/gXNAZRUt/NAauV6u66kp9Mb7J9nSGJdCR3xJYi7
         +PMg==
X-Gm-Message-State: AOJu0Yy5Tk9QyMIOEUQ8cq4+DmlIhp+YQQz4Nj9bbjT4poxeU/Cq3+pI
	Pyk9cAh7+jHARjHOYl8SciF6Sm7+bgh1naJ9vAhFvwU4NV7F4+T4Ie6Ot0TLP8qPu/a05cUzGdd
	ZeB82iBRhIYVcaOCKt1VVXfwKx812q1Nva3/XaJhGKA==
X-Gm-Gg: AZuq6aJ6zAYPuXKmYhtepvJicoHg+RRbFpZhmCL9rnZUZx/TYA3XmwAhSiIfvFXDMoU
	LlidPftRhPQMG3bB3k6O1DYtRVvKbfnJyZL7XtGR8p/TwPHcWrXZzIYra4XTecRrSOv3NEsLSpX
	xoptqcd9MrY03yA5yRII2ZiLPSV0OrH1mdCrRPe1O7mhXmKvw6sRcBF85fBZcVWPwFizane8CgV
	ryfj/pMKV/ilfigcNFdG9BdwEBMfSHFt1HGK3o5I5iLiYwH8LWSztV/SUAasH7HyH70llq4akfO
	hp8TgAlwUbozzxWqNF4Boe27SDVyBzlYyrvOoAHZ
X-Received: by 2002:a5d:5849:0:b0:432:e00b:8687 with SMTP id
 ffacd0b85a97d-4362934c515mr78377f8f.31.1770313536684; Thu, 05 Feb 2026
 09:45:36 -0800 (PST)
MIME-Version: 1.0
References: <20260205053013.25134-1-jiayuan.chen@linux.dev> <CAKEwX=PMQ1aYWr36XKG7oup3diBXb5vjV=fGZeTmYcx+ebmMtQ@mail.gmail.com>
In-Reply-To: <CAKEwX=PMQ1aYWr36XKG7oup3diBXb5vjV=fGZeTmYcx+ebmMtQ@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 5 Feb 2026 09:45:25 -0800
X-Gm-Features: AZwV_QiTVjMDiQYOXusEpf0PR0me_oBC5l27xMwTMrBI23cf9pS9stnj9eBMkRg
Message-ID: <CAKEwX=PBsuO27n_Vw112Ss2ZCTFqGem8f134cGKbHUQVL0aQ9g@mail.gmail.com>
Subject: Re: [PATCH v1] mm: zswap: add per-memcg stat for incompressible pages
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.com>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Chris Li <chrisl@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: x15yr5pz549g67fipdgdaiphuufzu8j5
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 621DE4000F
X-HE-Tag: 1770313538-355486
X-HE-Meta: U2FsdGVkX1/Yt9WXtNiJbOY4Kr060SQBeyiWklNgGv6YndH0LftbRJmEvGAmSXITe0D2k+X/wDyuBktjRJi7lmvnGPbqdJABuE2mcH/mYOCW6fCL+9aFRy5XpeOSirv0kYtZCA24ZwGCANHzw7nCCRVkPQUY2zs51DVy3TvHGd7rK7//iJo4wcu5GZw9a/MfG0yR72B91uzfQmwU8UGMDltd9THhUDAvqKrSDodoW7VZLrAP7iohrn1gxs+3nVfmUHXjlKrbH6Lmj+GF9jloqsFaky8D4e36zK0CWKLK2kbY+3Q1PUazqFt+aPUyY1P8jgmhd9Wp953428yZzfOoidlOgq98oLSyjCVrFXAid7sp8MdaX14vcUcKUael1F18PmjWi5qDK4kSaoRCO4mFmCOmUul6jwtSGsZGa0EmIoPUIWiDkwYSTX904BMedP1My4vvxW/jVoe7ndtdgL4fpHdW1lT7w9Vmj3g+ugOLhWnciKdD8HBRyFh2uQWuuMOAnC4E/ZRFct2jrwlMebvqedIWaWOQ4YvAltXFbiW7ew7vWGyGYh8RNNxCJ1gqMLneG2Ie9TUeSEAYpl5zTaxWreDwT+zLUArs0i6yfDvz7l/oHeM26me5ryt6hs00zBo7emg8YLSoNchg2mSaEOTP5w+/HC1HvOJsb1/CtdZuQdmLx9VlhmQZS6HBVYvTMnW+26QSqcDOGnVLySgQjkaehm304UC/np41SDxTsNVn9EdHov8ndJ2aMyfngSqgY3gCdpw4FeUQZ9vto+vZitRLvaxKmu9EHjwoqqL0M49V/y2q2SjipwuS39yoFeCa6HZnUnG5xX3/OdVRvAzq5cDb2kz5YpYEcnLuGvfF6lIA5v9JWbEo2bf4BM0HPL1cfutOm6/CrzYAQdiS1MpgHPoKUb5/GOtVxtHgzNyPzhm9EYvNdgTZV7qR1/S5yv0Wvc7APGZRbrndig1g9/Y4YBv
 jLiNvG4N
 yqN6dbCzJRYw3BJOSyDjR9JXG+tyeyWE3W4o2ezKrMmVZrjYX1sdcyfKaOzIYyxps0gjjk+UIXl8NHvdCSQSsdOD4/GPnVP65TB0pvQdHSwgo3bwtNzRCMeT1LW3Xgp3ZESOZsmYJNz8ThCUTrb8MhhTVMcCHY+94vY218LJPr8HeiDeYke02Y2pwVfww7/J7T7dxM5VVxl7sy+5C7/mPPbEZ4Zsqc+wyxF+I6qCJpvaKyRwjUAH17s685+2EGuXQlpw3ysiGkkWskFtGk1iDITWWkTnwYd+/Qphikhaw66EweMnat7mfykZODDTN+0llMerCVm84FMzOPefN5XTP2OyDEsxJVaUYfCo00YKDCizjc2wwKMc0SmKR4hID5VZh55EOb2d/t6HwpE29hdDi5kNCI+WtowVr/JnCO3PZKZEFqXXEoPDNHj1nnOzFxIbgdOBmkq6jWBofMkEbkY5vu0fXq4JZ1Tz72jvas8Kq+/iaRLvEaR/lrS38Fzk/HC48OBWqu0WwAFxUn/NmkaiN1ugVOU1bOj3v1D/HoioNfHhdFo7wJdxQU+rNJcgpOTIQ+pIK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 5, 2026 at 9:31=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote:
>
> On Wed, Feb 4, 2026 at 9:31=E2=80=AFPM Jiayuan Chen <jiayuan.chen@linux.d=
ev> wrote:
> >
> > From: Jiayuan Chen <jiayuan.chen@shopee.com>
> >
> > The global zswap_stored_incompressible_pages counter was added in commi=
t
> > dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page as-is=
")
> > to track how many pages are stored in raw (uncompressed) form in zswap.
> > However, in containerized environments, knowing which cgroup is
> > contributing incompressible pages is essential for effective resource
> > management.
> >
> > Add a new memcg stat 'zswpraw' to track incompressible pages per cgroup=
.
> > This helps administrators and orchestrators to:
> >
> > 1. Identify workloads that produce incompressible data (e.g., encrypted
> >    data, already-compressed media, random data) and may not benefit fro=
m
> >    zswap.
> >
> > 2. Make informed decisions about workload placement - moving
> >    incompressible workloads to nodes with larger swap backing devices
> >    rather than relying on zswap.
> >
> > 3. Debug zswap efficiency issues at the cgroup level without needing to
> >    correlate global stats with individual cgroups.
> >
> > While the compression ratio can be estimated from existing stats
> > (zswap / zswapped * PAGE_SIZE), this doesn't distinguish between
> > "uniformly poor compression" and "a few completely incompressible pages
> > mixed with highly compressible ones". The zswpraw stat provides direct
> > visibility into the latter case.
>

Actually I forgot - can you also update the Documentation:

Documentation/admin-guide/cgroup-v2.rst

to include a short description of the new counter? Thanks!

