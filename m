Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05230C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 23:15:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 798466B0192; Wed, 23 Jul 2025 19:15:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 771786B0193; Wed, 23 Jul 2025 19:15:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ACC06B0194; Wed, 23 Jul 2025 19:15:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5C2AA6B0192
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 19:15:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7A78B1D9371
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 23:15:47 +0000 (UTC)
X-FDA: 83697088734.13.9F25801
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id C5C8A40007
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 23:15:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fBw2mO7Z;
	spf=pass (imf12.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753312545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sxqvVKjKnRdjeHonK2NyXvcj4D2dnGAOtk2uNs8xY1k=;
	b=LU3WdG5xWDqZ/qQWuw+gn5QnPBCDaTkrluo6lSSPUQEVSqgJWr8C+Bf8mR+U5EOk1t0qPA
	+O54yFvHe2ZfFeauDjHXuXA8Ef/3UEsQIOe4nt1jDbpCrH0CW/ya4LXJfThDEL0H0/i86j
	ZEXTDF77l5zFRkMxL8qP7z8pfL+0hhU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fBw2mO7Z;
	spf=pass (imf12.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753312545; a=rsa-sha256;
	cv=none;
	b=EizZxBWMbn/ul67IVHsV4KSV9pzclGrfMQb8IX9yfTDKq20WkxWct/76OwTvYZ0TrqUIIY
	tSIvfY2iH659fW2AIfG6YUk1qPnnWa6hCHu8b7rFw/FnHtls96Y6Ml+Sr2TYlRuV8Xos3J
	SqaVwZmh8HYk+ISO7ssJEXvvuyOKpN4=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ab82eb3417so4342631cf.2
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 16:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753312545; x=1753917345; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sxqvVKjKnRdjeHonK2NyXvcj4D2dnGAOtk2uNs8xY1k=;
        b=fBw2mO7ZZiOs4eBd/alP4ykotBr6t+Amaegbz/Galn1oOReS6N1MCh58rfuCow3jKq
         IAC3ZcTi+pqYrfNc7xs4wBVovr1qe61WYHTNRrxzspjEqKKfks69mZfpUSR7+LPRvJ0+
         mZdXJCx3Oka15YX/my4+OU4x6riKtd4diPa2AsVQVzUlF+R1bdlL9hGJJh54zAL/k2wH
         aGIbClOzANh3l779gYtzowJ4jY0dsyyGJZD04ntdMLkKhSYK6EZYKuxfnL7UBrpPy8Gl
         TRiIcfVcf3cmuZORR/BlFfgVB5oAY7ClhCZBeluq59FmUtTvC+eLkTAbQS6eBTwXYhhU
         boQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753312545; x=1753917345;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sxqvVKjKnRdjeHonK2NyXvcj4D2dnGAOtk2uNs8xY1k=;
        b=Em1vu96abQOzzxhLw/Vz16hoDdmVp89hNs6PPRNNve/G3RLsBO0rxyyseVLwYcncS9
         y7koG0GeDFXCDGZZcsS1Xsq5tcpvLzLcOSP2cLx5fmVj0AbzLRfIgT/aqS1lcs+rKKkY
         j0YgFqXFIV4uU/yfQQfWJWEnsymkbm6rP9q/9QoQh3KMEnG3FDwm/sXfgftUKyB1nqap
         gVMTFVF/SOwX1oqkkD1zOm/6SLj6iYnR9OrlvpfbkcdtXi17lBryzUaF+N0p/+p2vzL1
         DBIObzzJRgeGHg9/r6aVodn4koZ3yzfsSXJRrLMtAL3yHcNceR2pMPErpXpp90tFsBgH
         7mdA==
X-Forwarded-Encrypted: i=1; AJvYcCWAiy0reJsYZifYWxhqt9mX+ZmTNiD8yymq4277FGLZknGKOe4osP5AVbeYVWC3Q5QeMjwqDkAdAw==@kvack.org
X-Gm-Message-State: AOJu0YwpM9ypzCqajlttAGdaJdH4urMTLcYWGC57TzwpcHNJmZSdc4VF
	8wMk8JFWJElIILbF8g5F4B20/QqNyggEeOXXkfQptVUM1YB4xelKAJHBUJvyQtLGjgD7UqFjtzs
	Ya3GM8xU6dIGJLoi7IdJAW2cGrNU1G/w=
X-Gm-Gg: ASbGncv7/25JsbzpHyywIV6kYAfS//p85OY/vcpNOl6TSIrvjFT9GcxtcL1A+/IRFpQ
	Pnaymbe92SerYOB5O44fLSyfl7XHOZo212cQf1tUjdv7r33zcfQvOylDOrGAPw4fjcnfmIzI5Om
	8zWRZznE/Z7uiFeFOovtBb7WIHDNc7By0LltnBkWd1gXhX2ZgVn58XskmSMa8vTBtMMSpkuDbrI
	AVvCrE=
X-Google-Smtp-Source: AGHT+IHlNadpmRVQnR9L5YwWXi/1q37lybj6swrt7fqmXQJSoFTFUz5IAk16c+9UoZdKYXY5a3Cl5vtnEtFqYipHQyY=
X-Received: by 2002:a05:622a:4d1:b0:4a7:a8a:eed with SMTP id
 d75a77b69052e-4ae6dfc2323mr97483581cf.39.1753312544328; Wed, 23 Jul 2025
 16:15:44 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYs5AdVM-T2Tf3LciNCwLZEHetcnSkHsjZajVwwpM2HmJw@mail.gmail.com>
 <20250723144637.GW2672070@frogsfrogsfrogs> <CAJnrk1Z7wcB8uKWcrAuRAZ8B-f8SKnOuwtEr-=cHa+ApR_sgXQ@mail.gmail.com>
In-Reply-To: <CAJnrk1Z7wcB8uKWcrAuRAZ8B-f8SKnOuwtEr-=cHa+ApR_sgXQ@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 23 Jul 2025 16:15:33 -0700
X-Gm-Features: Ac12FXzF2620xp8RVAUCjDRQn0A4HBT9-5mF3yOk4tFXX3gskarUrR9Z58ZmyE8
Message-ID: <CAJnrk1ZREcrd=FNUYLVWwXUeJ3mJz9J+aqyEvoHkyG3RrJ2QkA@mail.gmail.com>
Subject: Re: next-20250721 arm64 16K and 64K page size WARNING fs fuse file.c
 at fuse_iomap_writeback_range
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, linux-fsdevel@vger.kernel.org, 
	linux-mm <linux-mm@kvack.org>, linux-xfs@vger.kernel.org, 
	open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org, 
	Linux Regressions <regressions@lists.linux.dev>, Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Christian Brauner <brauner@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <liam.howlett@oracle.com>, 
	Arnd Bergmann <arnd@arndb.de>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Anders Roxell <anders.roxell@linaro.org>, Ben Copeland <benjamin.copeland@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ipgoea97aia1bydp5tyfazkddhaf5ro6
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C5C8A40007
X-Rspam-User: 
X-HE-Tag: 1753312545-663406
X-HE-Meta: U2FsdGVkX19jwjWYnl4AdJhZjD0A1Y2rpFbY8IuKvDlf/xKXTKlAs36+3kvVqWIFw+LhXfq5KzHhlnb8hXn5zm6kxqQedmBhcD8LRMo0yI3i87Tk52l5xhtu+liyHEP9VdcC4Bqc5owYL1hYQGeF8tBK7VwyaxRyunzamhvMC5bocbhJKWQZm1dgNntDEJ65QokL5twqraTS7O5RT6FnxLoVghfjluidTqNAMvuetSOFW7u2H1RoYNXmCDhRTMO6Jk/Kim6lMBXrROqADqrl70TunndUDPT4wU6nPmwEo1Z14/5Qoqko1KXkvHMnuZHinJdZDFnj8aXEpCFyvuFjy1Oy+ypOEyxQvxO+o9XAhIrdpy3qQn8MJrT1sRUgbOsWGw3HpekE7cFMHVPahlEaluzfEv3jn/P0s9/gABbC4bq8dZj97/Uiz7WpExRcDE2bpWpDqfV3B4umoBIJSc+8adCBQ7vtE+9WtXxbJSJ8SbXHAVptDUQ4M65NJw0i6OiyxTR4GIRZNuS7MqgxfciafPxXQQjnuKu/kHmSvKU1/fH612NIkX7Qh7wjQpvo72FRbBvldziuumK/T/z5gmQZhebAl4ZbPpiq6WbC1hbV2hOTEd22483Lr8NjT/8+q04/b1KpIx/oG8T0DV9ZaPZhuOza8UTcpe83RX6RMq/8PMBQj4vE8DzRCNohODjyKiXo9tTlrNysSeuhiJqTeEMelKAVxxIaISBsqCamVGZmhodkYyo6x6g/UXhlYAszxJJzQ3jIuAWlLHo8ZCdfZnnCf/qvnGhIdfkPW8lVAnRR1uy1AiQgsU5Doi/2tTVu3RSOnXLLQDCcTDTZlBjGjK+XImKFIudMvh7rlIWzAd3zEDAo4YXEj42UFD3OhozbYOR//oGzerP5Jy0CaZNDKxBzDY/5shpQpH/U090p0f9maQ+rGtqJKFhl2zPdPzVU8LZQFith29PaY/MJPSLBaPx
 b5LCMRtu
 xryS+xjX7C3pOI8NS0jNRL7MHdap7y8pP8I7AshUuzNhhaSf3iJ5+YEFd8xdFFDabSRKD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 11:42=E2=80=AFAM Joanne Koong <joannelkoong@gmail.c=
om> wrote:
>
> On Wed, Jul 23, 2025 at 7:46=E2=80=AFAM Darrick J. Wong <djwong@kernel.or=
g> wrote:
> >
> > [cc Joanne]
> >
> > On Wed, Jul 23, 2025 at 05:14:28PM +0530, Naresh Kamboju wrote:
> > > Regressions found while running LTP msync04 tests on qemu-arm64 runni=
ng
> > > Linux next-20250721, next-20250722 and next-20250723 with 16K and 64K
> > > page size enabled builds.
> > >
> > > CONFIG_ARM64_64K_PAGES=3Dy ( kernel warning as below )
> > > CONFIG_ARM64_16K_PAGES=3Dy ( kernel warning as below )
> > >
> > > No warning noticed with 4K page size.
> > > CONFIG_ARM64_4K_PAGES=3Dy works as expected
> >
> > You might want to cc Joanne since she's been working on large folio
> > support in fuse.
> >
> > > First seen on the tag next-20250721.
> > > Good: next-20250718
> > > Bad:  next-20250721 to next-20250723
>
> Thanks for the report. Is there a link to the script that mounts the
> fuse server for these tests? I'm curious whether this was mounted as a
> fuseblk filesystem.
>
> > >
> > > Regression Analysis:
> > > - New regression? Yes
> > > - Reproducibility? Yes
> > >
> > > Test regression: next-20250721 arm64 16K and 64K page size WARNING fs
> > > fuse file.c at fuse_iomap_writeback_range
> > >
> > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > >
> > > ## Test log
> > > ------------[ cut here ]------------
> > > [  343.828105] WARNING: fs/fuse/file.c:2146 at
> > > fuse_iomap_writeback_range+0x478/0x558 [fuse], CPU#0: msync04/4190
> >
> >         WARN_ON_ONCE(len & (PAGE_SIZE - 1));
> >
> > /me speculates that this might be triggered by an attempt to write back
> > some 4k fsblock within a 16/64k base page?
> >
>
> I think this can happen on 4k base pages as well actually. On the
> iomap side, the length passed is always block-aligned and in fuse, we
> set blkbits to be PAGE_SHIFT so theoretically block-aligned is always
> page-aligned, but I missed that if it's a "fuseblk" filesystem, that
> isn't true and the blocksize is initialized to a default size of 512
> or whatever block size is passed in when it's mounted.
>
> I'll send out a patch to remove this line. It doesn't make any
> difference for fuse_iomap_writeback_range() logic whether len is
> page-aligned or not; I had added it as a sanity-check against sketchy
> ranges.
>

https://lore.kernel.org/linux-fsdevel/20250723230850.2395561-1-joannelkoong=
@gmail.com/T/#u
is the patch for removing this

