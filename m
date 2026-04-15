Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84314F4198B
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 11:04:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B24DC6B0092; Wed, 15 Apr 2026 07:04:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFBD66B0093; Wed, 15 Apr 2026 07:04:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EAAC6B0095; Wed, 15 Apr 2026 07:04:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A6B36B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 07:04:21 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 001C51403DC
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:04:20 +0000 (UTC)
X-FDA: 84660506280.28.867547C
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	by imf13.hostedemail.com (Postfix) with ESMTP id ED66C20003
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:04:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=dUVntqKx;
	spf=pass (imf13.hostedemail.com: domain of mingyu.he@shopee.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=mingyu.he@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776251059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f6JTpcsGEMVePjeNpfTOx+QJp883lRosXuFdBGmCW3k=;
	b=myrcJ/e1/9LOfuAgAXdROA7yZIn09ZHonCEgkfIF+i6oNmK9vJthlbyD4bzqyqXoOWmrH4
	EmjBGpducTkbsR865+Iwz4sFqcs9DwUqcJ6LNWuc8/3dTcrmm4lzfyUV5A1dRxoRw26HF4
	aaoftzsQVKJKSV8iLjSoHA/FwUasC1w=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=dUVntqKx;
	spf=pass (imf13.hostedemail.com: domain of mingyu.he@shopee.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=mingyu.he@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776251059; a=rsa-sha256;
	cv=pass;
	b=2xDPBISsvu/Z59HFBLkmPVjVDaraG2pK9mW6XZIx72Rs73Iu6kBSFHaxJ/IzBaPNeBY36W
	GQk7nRg4nvxqiUEP7+QEjrFCqEZjhi/eUBybpTgFRQ+AgDLXcZjQoPf4wBy5LFYffXItY4
	mW2eWHqKOPxy/N5qaQ9BXaVm9GtD5yY=
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2c15849aa2cso7707483eec.0
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 04:04:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776251057; cv=none;
        d=google.com; s=arc-20240605;
        b=iHtenevUjPbEQrLjakTJ81/Ezjxse0IRjm8O1edKPU/bYdPlabuY4FiPBOiTr58Ql1
         0tN8JGFyHQRy8DZFUpXvTu6VV64d6d9i+09Wqh5P/IVmASTPs9veHzOHr4TFVj900A5l
         bq5r32RkaWf+4GXKnSXyftjHxSRqOVmbYl0HJc7fvsBIBMXCqLcS0b+kDvVE3G8LbA1S
         E0KUe4DOvT2hWBqHLkr0lRxqeo1TJtVY+Fq/krvH0oh1cxvEYAgxD+jBDnXu5jbAR3sk
         ChNbcmwllJs7cUuRzlh5eEZf5JelgFMI7ZeLmYw8W/PxpICQBs/Th086ch7VxJ4E2ewY
         h9qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=f6JTpcsGEMVePjeNpfTOx+QJp883lRosXuFdBGmCW3k=;
        fh=/9bsr3ycSw+l8j7KWsTmIrWFH3EjDJm259lWaljAvnU=;
        b=c91tiWWea6gFQOhLzvg3wHTzIdVX+JXxY0q9M8+lXYA9cwhg3tZLnBrX293HsO0x2K
         mDecdT/t8xqnKONmue31tKksEuSjeTvhfvKIlhgOdBBVw3FwtAA6UrDg9WcDlFR7sSDo
         NvCkipQYqi2HwvEJMfi8jIVfg3m3Gs63kw3MscfXYF8Jn4F/oSvkWCV4RgOZ45LZMVid
         wYKyeSllS+bJ6u8hfDTQY+VcWGLlaUd5woJHC/GOT/c3gEcN/7Ecc2Mz+ZrClnQZcXlH
         5NVgz4oh6Syn3UAKGPFWinoKgHh7P0d3+qpXmDvJHE/QSy+NTK/7p56SR9jyugAeIzVr
         BJxg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1776251057; x=1776855857; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f6JTpcsGEMVePjeNpfTOx+QJp883lRosXuFdBGmCW3k=;
        b=dUVntqKxefG3AeojPK+YbZD8w213T6+OwS7cxA9C9y3D2g0fYRgB8iQDQlvothpeZx
         lGnGLzdcJGlqJgoM10Ui/ymN1kfZJHujFEx+exha9mmyDOJKzTvgDmrpbacAK4zSA9WJ
         nwrzt3vGzZey7BjNm42uifb0FK9vbypbLozbqieaO4GNa1uRqoIIPLbE7H3gosxaNual
         U6d5KAJSSn3RvaMg3ARQEpiqvPbYOhV967O3yQ+Op0HS8v62v/xF6YgIH5b/UmQs1AQo
         DTaFZ/YrOpRbR9XU2A+tq5YbHbsbuU7Bml43yBeNkWhML3Ye46ug2yKD5fc44EESt7J+
         c5HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776251057; x=1776855857;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f6JTpcsGEMVePjeNpfTOx+QJp883lRosXuFdBGmCW3k=;
        b=XnLkZsafhAdntUI47qlFEjGGhCrZkfslT/PmU1b399UTnFA9uHFu3gAvUaGxXFY3UW
         5ULiUcj+KCdXgtsj++cTtgkVJTNLDa6OPIXecvKtlwO20IPXlEKL8ZClUG35ZgiBtbZv
         lu6yXUhOrgrKu50D8YCOXa2M3+fdehv/vN4yog5iK8fVmvAQ0HyrGBK8AwfzwYw8+CSB
         MG/Hh7RK4285Q9347yRXS0kVzA7EqWDx2mtyhFiNWlu1k/WvsXUA2IhGDOosicS1/S0x
         ybshiF8Fht1vemqil0r5JjSstyxPz/K+Ht0ApQ5F1d7V/y4cha0KSzLSqDAFJ+uVq0D1
         hKzA==
X-Gm-Message-State: AOJu0Yx0avLpaqQhSDDVoNgaxoStvpjAfRg90cE9M6jAhHii1Ljbcbfd
	t+btugDq4z37CIwW5FwyJSOlHhchJBPNSOsA2RqiBk6cbJfGo9VaiHuvo7IgBrDHiPGj80v4ZNf
	yhfGyfoDnqcnKLe9mVDmCFbGfq6BF+l2i3/jst3Dezg==
X-Gm-Gg: AeBDiesviojlR2GW0CMawA8E6tInYm5ybZ86WD9kZMeEc9bnKJhwABWwt7xudWDsihA
	74b8txaDrT75B7dxTGoK2Ub0Wskjxq1GosX/eV9SIewLFtmzN2HrpbN3fUVpX8rpnuTCwNKX6th
	5yJAMcvz9/HqFNyQxeDwCxZdvJhHSrNCHr+RF3uEgkDNkjdH2Mxt9tG60dLwVhskUSnYidogbBq
	MeegaMRs58tsGtF+J8PKRsyiV9+TX0VHixgqvUyhMgMlDWIJrnjncklNW9rA3GiZ+rPG+XZVmc3
	oJXcykYkqcI/yq5Acw==
X-Received: by 2002:a05:7022:69a7:b0:123:2d38:928e with SMTP id
 a92af1059eb24-12c34f14f40mr10959780c88.35.1776251057390; Wed, 15 Apr 2026
 04:04:17 -0700 (PDT)
MIME-Version: 1.0
References: <CAAoBcuSK38z5Nh7rGuHDFwpNvtc0W49OZKc1_d1QkCbK_nL7Ew@mail.gmail.com>
 <ad9g22IbYJatwptY@thinkstation>
In-Reply-To: <ad9g22IbYJatwptY@thinkstation>
From: Mingyu He <mingyu.he@shopee.com>
Date: Wed, 15 Apr 2026 19:04:05 +0800
X-Gm-Features: AQROBzD_1BmCvVWLyoIrN-ngV7luGamoR76FKMMdb49dRkFIzjgEBvjaWEbauhw
Message-ID: <CAAoBcuQ9s68HKiFwhqXPc8-bfXYsFXc2SeD01H3d62pyxi4uvQ@mail.gmail.com>
Subject: Re: [ISSUE] Read performance regression when using RWF_DONTCACHE form
 8026e49 "mm/filemap: add read support for RWF_DONTCACHE"
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hannes@cmpxchg.org, 
	clm@meta.com, linux-kernel@vger.kernel.org, willy@infradead.org, 
	bfoster@redhat.com, Jens Axboe <axboe@kernel.dk>, littleswimmingwhale@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: ED66C20003
X-Stat-Signature: igb9tog9hc8zbubacgg4tuyci5ji169p
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776251058-347767
X-HE-Meta: U2FsdGVkX1/rUlyotleNfzTUdJTjdPxIEx458OTbEFpACpoykGpIZb2NT1mfpE94yJFcbWwhujNViOBZ3k3Y8yV3FN4qJzrRwqH+KhjTjZl++rMR6ubUTjXy1DmmTqN4FwiRKKWD2devysak565FVNyt+PHwsj0nOh81Ncv5bQRnAXlO88LZUFEOrz9lwe+YEfPGf36oPEPghAf7H6KzrqpRmuha+O9NcFN6Jy8tlmC+yINtnZGYRDcjj00GJB6MT23fDjSLsWkXHG2enler4JnQUEOaxa2pMzfRldpxOjyVT2/YEuXAGeGkyF0MgM5LwRuMElf1zsDUd9HesvttLUxxJL1Bykk1mXr8iXNx/YQbEQaBE84qKukstuZiQe0K+/kzNbYQyDQjKQugR9PpWz8uSRFrTKngwFAySg+Uk1IG6eQaHCLbfDRqa5h0+lFIPCdZXVoLMSAVIfVYPfqNHnH17jKEGWHt5guEDKruwIPpwAcJnXJ6xAKYRSplJ+aBT8lbKUujW7bsxfJzQX/jGtmp6KIaM3UW9mOEq1q/bmaYtJtbNshps86CmFrPyfxUhbyC1CAcWFZFFTNlKPU1TzrdyDvjv1u2BtsQv+HfaCPXchcjzEvTPtml2I8iH231EMETFSLe9HMohG6EQ8jfe6kMibG9Pi38IoqNTNyDK5POrGTg9e/0oVYhSTn7Tp1UXAGlDDv5+7aODwaZ2+9tK1Y526itECYq18CEgzMQCsT/adZqtFsYr0vsX0BzVDJNYIe+6gk0UhvHmWMfsgzivABA55I6gPanYY6RdtP7hppN1iieEVTOEPccqWOO9vb9b4Kkw0HVbGhToxH7kzspVb9bScaAaJ0lBEXDBC4xSyaCQ+2HG1ZvJ3g8QHgolwpKDw4Q8GvzIlDRgfN5hDmMfINw/IsftXPzh1FsVlX7uSyUh67FhXyAjRT58WyaEMwaLHejzQejOjT+uPb3qDA
 Og+gxNc1
 lMqF8y4zN7+0BWoYXo8T2kvNKZB97ZINKW0pW7iq8tzu6B7R6sL6JsPe+JskQ5GBkMJa90o5ED8tt7GrVohjBfF1rQB96cMKL5828mBAv3sx/dNnrz9XK9rBTGpWhgSLDRdl1yEV09ve1nLWQ1wD+vWyWZSjbNei0UcqAlWhRuIXKlzYWvMbX5RTyTH+qLuAA9nzCCx5QeiovmIIdv9yG2GL0fUuqUtdoKBU9bGxmSA6D5XXTKIfy/DpuVZQTwILA+CGonXBssuQPBVPhQ0U5Ul+3SDkjUX8bkFdqOa3x7Io6ihxlVkEm8OyyzqThwYbR4fQaEwsnjtiKHSng0O8RdXBQ493gMPC5Tzj0bAJCGUghOQ7w9bRMUSBGYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kiryl,

I will list my phy sec and fs block size at the tail of this email.

I have 2 types of hard disk on my Linux. SSD NVME and HDD.
And I tested buffer_size with range from 1k, 4k, 16k, 64k, 128k.  And
also with/without cgroup.

On both type of hard disk I got same output: RWF_DONTCACHE has very
low performance.

Strongly guessing this is due to readahead.   Pages are dropped after
reading. So system need another I/O to get the next part of the data.
However, I dont test the cases with Kswapd strongly working (But this
is not the core of the question.)


I guess this case needs optimization. But I am not sure it needs an
optimization or just I got wrong using cases, as I am not a proficient
kernel developer.
So I need the advice from experts like you to make sure.
If this is a case worth optimizing, I'd like to do that optimization
 ( But I think many people might have noticed this problem, so I'm not
sure I could finish the optimization before those proficient
developers )


RWF_DONTCACHE Performance Comparison (MiB/s)

+--------------+-------------+------------------------+------------------+
| Device Type  | Buffer Size | RWF_DONTCACHE (MiB/s)  | Normal (MiB/s)   |
+--------------+-------------+------------------------+------------------+
| HDD          | 4K          | 119.6                  | 2268.1           |
| HDD          | 16K         | 1568.6                 | 3814.7           |
| HDD          | 64K         | 2351.0                 | 4161.8           |
| HDD          | 128K        | 2951.4                 | 4061.0           |
+--------------+-------------+------------------------+------------------+
| NVMe         | 4K          | 148.7                  | 1556.1           |
| NVMe         | 16K         | 619.0                  | 1601.5           |
| NVMe         | 64K         | 1139.6                 | 1618.6           |
| NVMe         | 128K        | 1725.4                 | 1579.2
  |- NVMe @ 128K is the only case where RWF_DONTCACHE > Normal
+--------------+-------------+------------------------+------------------+







# lsblk -o NAME,FSTYPE,SIZE,FSUSED,FSUSE%,ROTA,MODEL,MOUNTPOINT

NAME    FSTYPE  SIZE FSUSED FSUSE% ROTA MODEL
    MOUNTPOIN
sda             1.1T                  1 PERC H750 Adp
=E2=94=9C=E2=94=80sda1            4M                  1
=E2=94=9C=E2=94=80sda2  vfat    110M   6.1M     6%    1
    /boot/efi
=E2=94=9C=E2=94=80sda3  ext4      2G 517.1M    27%    1                    =
                /boot
=E2=94=94=E2=94=80sda4  xfs     1.1T  70.4G     6%    1                    =
                /
nvme0n1 ext4    1.7T     5G     0%    0 Dell Ent NVMe v2 AGN RI U.2 1.92TB =
/data


# lsblk -o NAME,PHY-SEC,LOG-SEC
NAME    PHY-SEC LOG-SEC
sda         512     512
=E2=94=9C=E2=94=80sda1      512     512
=E2=94=9C=E2=94=80sda2      512     512
=E2=94=9C=E2=94=80sda3      512     512
=E2=94=94=E2=94=80sda4      512     512
nvme0n1     512     512

# dumpe2fs /dev/nvme0n1 | grep "Block size"
dumpe2fs 1.47.0 (5-Feb-2023)
Block size:               4096

# xfs_info /
meta-data=3D/dev/sda4              isize=3D512    agcount=3D566, agsize=3D5=
16864 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, r=
mapbt=3D0
         =3D                       reflink=3D1    bigtime=3D1 inobtcount=3D=
1
data     =3D                       bsize=3D4096   blocks=3D292326651, imaxp=
ct=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D4096   blocks=3D16384, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0


On Wed, Apr 15, 2026 at 6:05=E2=80=AFPM Kiryl Shutsemau <kirill@shutemov.na=
me> wrote:
>
> On Wed, Apr 15, 2026 at 03:28:27PM +0800, Mingyu He wrote:
> > The smaller the buffer_size in the test program, the more the
> > performance dropped. Initially, I used a 4k buffer_size, and the
> > performance decreased significantly. When the buffer_size was
> > increased to 128K, the read performance with RWF_DONTCACHE actually
> > surpassed the non-flagged version by about 10%.
>
> Maybe you have block size larger than 4k? Core-mm will allocate larger
> folios for page cache if filesystem asks it to. And if you try to access
> it with 4k buffer it gets multiple read-discard cycles for the same
> block with RWF_DONTCACHE. Without RWF_DONTCACHE only the first access to
> the block will lead to I/O, following accesses are served from page
> cache.
>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov

