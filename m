Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73C03F42100
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 18:00:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CB846B0005; Wed, 15 Apr 2026 14:00:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57C196B0088; Wed, 15 Apr 2026 14:00:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41C756B0089; Wed, 15 Apr 2026 14:00:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2DD266B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 14:00:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E89BA140586
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 18:00:46 +0000 (UTC)
X-FDA: 84661555692.14.98922CF
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf21.hostedemail.com (Postfix) with ESMTP id A9AD81C0012
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 18:00:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=dilger-ca.20251104.gappssmtp.com header.s=20251104 header.b=H9Urihm9;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of adilger@dilger.ca designates 209.85.216.51 as permitted sender) smtp.mailfrom=adilger@dilger.ca
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776276044; a=rsa-sha256;
	cv=none;
	b=RzdFgndDVRVl+OSXs4EuQZR1dYYDVoygd7lz+Qqlb6JH3Xr2jgmhpD0hLZi00/xKadEwre
	Ax1OKLT8qpSvjftQ4TS3hi53ndUFnTCKHo5B66XPAutR8y9YvokJbwJqIpU8ob+4HMq4+q
	R/2RHzRjTYqYKHKOFm1KhvFgcttsLHo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=dilger-ca.20251104.gappssmtp.com header.s=20251104 header.b=H9Urihm9;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of adilger@dilger.ca designates 209.85.216.51 as permitted sender) smtp.mailfrom=adilger@dilger.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776276044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fyjSIVQggWZv2yuG1S8MJT6ctCYnQ0vE1n2meEvSQNY=;
	b=Bk9Ax/Ip59YjHi9c2HSKHj1jRNpDP2uyj2Oq8ajxQQksbej06ffpqUtD86tmkwIA3NYTEx
	GWTQVw19u/pqEp4dKUUbjaJbM1wiWILysyEoqZVXC2wBdgUblkdXOXh/dbIXzy7ieeOR8h
	EmvsNMu64c3ADJO18oerYa0BKCT4tV0=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-35da9692ec3so6351834a91.1
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1776276043; x=1776880843; darn=kvack.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fyjSIVQggWZv2yuG1S8MJT6ctCYnQ0vE1n2meEvSQNY=;
        b=H9Urihm9wb3zsxTQgfi5gBUgJzKo6zC7lvnJOfsW5aHd1dzHUGot543GCVbnMXZ1So
         jngXSxDvyimztfAaQhiMWZqED30qXpu4udHf4c0f7I6YWrP2TNd650ZCEFKfSQX3Vtw5
         oxJVyhZkeUumty/PZ2CsgqXOQ1WXlJ4Vgr+AV3BYahenk77CsU2HolDnCwBRM/eXmCKy
         X33IQzwI4bHYDe8fHgp539ZUeTq3rbA9BhSLWLC590/PTBektRdiq3osnX5Fo8oElx3v
         4xfTgJcNqvULFl3ZwW4vdAdl3aLdrebRQNyfhp8IsH+2BQ8cQvlsO14CEdbuGDOzgBAA
         RXog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776276043; x=1776880843;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fyjSIVQggWZv2yuG1S8MJT6ctCYnQ0vE1n2meEvSQNY=;
        b=hRieLbTmQK6XJV1yl4/nPa4sbf3VT2vnnIWCDrMGxuSdFDjnMB/ybRJQANaT0VllC7
         kYWM577CwOC8IW3nUQ1wnK6I6OvTVBTk5F8KiiV+8w03YejkJXIx8lU9Brn7RmgMTq5E
         xGhvPI1ckPQYtJoB+pzu/ehu+/czsJarOxpWScEAma3/O5CDVEqsAv1zq+gsio0f0Qf0
         RzK1q5mEJ+dInMBdoXCs6xfhnUJyqT3WyFKBgfmGMUjuZYHYNTGblDpOiA6bH34TcVtG
         7RoKUHWZRgZDjdl9fkVcZJVpfkbtEHZkreq8701ZYHL8JL0zKgHwJ+0s6XLClI6yzf/A
         +EpQ==
X-Forwarded-Encrypted: i=1; AFNElJ/HLvjUJkWGAk7ZElSEeRYbmKE7hgRP8AYQ0QN7uiafwmrc4FtnpD5PVTbmt8wQhkCYzvOwYtCp/g==@kvack.org
X-Gm-Message-State: AOJu0Yzjn9llUfJN5tu3Rbl+qhweSeZzqE51eR02Ewr3JoDm359X+WGo
	LXMPA4lYd0YDT7H2OI3pAinhGjqmcTh1L32IAXK1tekrPl2peM5xY/z21VRKqcso0JQ=
X-Gm-Gg: AeBDieuQwoaPHCjlzrHW18Oaktr5a+jKR/6kiZ7LzYvmKN+ltJwkQWHmcDW77+Smrcr
	KiwofCukcF1u2nH6T9Rtvvl7ANuztTDhj2fSRqP18XR0JuzXHkRZYeJA71Q/Mt4w8kdyJPc3RZ9
	1I3cwiIN8dw2byekS1JSY0vNN4NGkNdeY2nCPsXFX9PmXdUyWYyUF7qjLZy46CWKK2NptCzoXfX
	vRIirQ40JYuCFp8X53s5oKPBGO7wWSj7Bs2upmBrMRkq+g/bKvRfumHDnwk8pKJuBXB26IN7/MD
	wYPLCmoFKBF7wuN+p7dqxms6m7UxSFh+lxc+gCJr2aeMFW9HEUYkA/NkEG95viAwPU7nIhhLq6Y
	LCweNt22jDBZbnhL8zi3t8nUVkJdRiebALLtYX7IhkTP+JQ7dPciTAIZpVhmLRrT0kZyPELikgP
	b7zD8MzIXe55RTjKQpEvZuOJi3v1RpuNOyUSTwNPc993QYc4qB9NqCEwVGfmygDTroJwwhtaBm7
	HRhm8dWtnOYTleu
X-Received: by 2002:a17:90a:38e6:b0:35f:9ab2:a5b4 with SMTP id 98e67ed59e1d1-35f9ab2a8bamr8851412a91.6.1776276038607;
        Wed, 15 Apr 2026 11:00:38 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [70.77.200.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35fd20d0e78sm4093440a91.11.2026.04.15.11.00.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Apr 2026 11:00:38 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [ISSUE] Read performance regression when using RWF_DONTCACHE form
 8026e49 "mm/filemap: add read support for RWF_DONTCACHE"
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <CAAoBcuQ9s68HKiFwhqXPc8-bfXYsFXc2SeD01H3d62pyxi4uvQ@mail.gmail.com>
Date: Wed, 15 Apr 2026 12:00:26 -0600
Cc: Kiryl Shutsemau <kirill@shutemov.name>,
 linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org,
 hannes@cmpxchg.org,
 clm@meta.com,
 linux-kernel@vger.kernel.org,
 willy@infradead.org,
 bfoster@redhat.com,
 Jens Axboe <axboe@kernel.dk>,
 littleswimmingwhale@gmail.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <B0F17C4D-C1E3-4778-A352-AE9CA3434E8F@dilger.ca>
References: <CAAoBcuSK38z5Nh7rGuHDFwpNvtc0W49OZKc1_d1QkCbK_nL7Ew@mail.gmail.com>
 <ad9g22IbYJatwptY@thinkstation>
 <CAAoBcuQ9s68HKiFwhqXPc8-bfXYsFXc2SeD01H3d62pyxi4uvQ@mail.gmail.com>
To: Mingyu He <mingyu.he@shopee.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)
X-Rspamd-Queue-Id: A9AD81C0012
X-Rspamd-Server: rspam12
X-Stat-Signature: t9zuhj997p9zyyan59mjf8i43mupq1ku
X-Rspam-User: 
X-HE-Tag: 1776276044-110045
X-HE-Meta: U2FsdGVkX19fAPsJsO57/iIM/xM6McdDt6AOnFKdE+AdZBqRDDM7c9Chx7kCyqOI0ylNr6ltDO2upz10doxXg0zO5fyZ1gGa64uIPD7ec1gqlXGzHAN8jKhGLlkgbqidZ+daClkgM9AfvM8x5boZjN92YQsdUjRWTonBfAgorU4azZ9zAENJJr58s3gDHCiDHdmOnLwv02M80xJj4x8UV63PwoGUcdhDn6LZwsUaCZIhLZxPORKkTDH7fRnD0UX7pfTSwuqTKrckE8HeFGY3SWD+1pvf9r9UZ724L0UQ3B8IX/gNbhv82+ebH0xFvpnYRYS+vXdj6oSX3Be8Ao1ts+jpbFQ4Qwkkru6N/sHx5+5Yj8cMLAtpTy7JsCBzUgsWV7OSYAzOssMgosF5OY0XmX+XX6BDc5wgeNKJl8Dy1EQ4khPkH6y/2N7AfzoJ994vJ9ZUtHFq9hjShMQfC9l0ibRVyfWkUnqKAsQmz9j0BtDu6PAN9oZecOkQlHLak0TqDBtEAQXTnYZZB4kJ2Z0m7W9mkFKi4dyLm2FQtl1Mjv6krZXt3R2WQMXQrbNNGIJl/mOIdoK/TUY4oAZfNNi0tMh1Nh8zqbRkmpz+6ED/WfkLuY4ExjMAzLacD/mya90T7VleTkSx0eV3VEa9Lr4Ur9Di5lWZGoh4iuX5/turmIY5/uD40Y2HTnsHofWonno574CjXm7/2qdaHo4RQkIsuYFtoNUtKnHZtlDAiQnfkuD8SbEDLx4X02U2349/FDzlfui8eimslhu+3GdhBORqRcluecVEoYISnq/97CYCYLi2YPnIdjQco3WEiiLABN1UnhxNWTzzp/9anlQ/ipHVfd+x4pcSUU+DKIroZGj4U5IQ/OOIuwBzDeRJycqAnUiTPYs557GaoSUITmaxrpIuNJMFVTLmGHTyEPf6+PUaegR7Hkhdp2yRIVqK39tlEhWU2iK3MoOgAStrqaFnCQv
 yimezWij
 ba6amSI2ZWPRitIWfw0W3xV4Ff9xaLA9cKEGOPy0IGRSoGTzvh1YUeRDxfT9TlE14S2DjiZnPzjKDgmKkxWut3ODpSkGqS7P78zKcXA6j5uboSMuFTOSqj1aCJHvvaRyMAvioHRM3sbj2djh3SvB7j7sUCxDbw3Q9arAVPtLFH+w05xBSEEoR2iJB2xsH0NXmWzvc1appuApj4roJcIWYw19QE7HU5Qoiz5o/7r0/50Q8HFb333Skos6brwaNErJZhaEHfvRblTaXT/ycljNF3oVonvTrtaAePsYRdtTz4pSiWpltkvuNg7KsiMVpqXLqSojSn12bwe3qoLtTYirUY8z7CdRTusuI/jzwtJ5ve7Tj3iBUUYQMe9HHYrW8VA+gH7pZ+Md8iy5o/zsFS2PbSpUtD7wC47p264aip7HnB4cmRGAOmzNfLzr3rk3SOYECyaU9P7QgTX9S4d2UTZvG2VMbXziwQfckpj3xSsnJQFr0Dnw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Apr 15, 2026, at 05:04, Mingyu He <mingyu.he@shopee.com> wrote:
>=20
> Hi Kiryl,
>=20
> I will list my phy sec and fs block size at the tail of this email.
>=20
> I have 2 types of hard disk on my Linux. SSD NVME and HDD.
> And I tested buffer_size with range from 1k, 4k, 16k, 64k, 128k.  And
> also with/without cgroup.
>=20
> On both type of hard disk I got same output: RWF_DONTCACHE has very
> low performance.
>=20
> Strongly guessing this is due to readahead.   Pages are dropped after
> reading. So system need another I/O to get the next part of the data.
> However, I dont test the cases with Kswapd strongly working (But this
> is not the core of the question.)
>=20
>=20
> I guess this case needs optimization. But I am not sure it needs an
> optimization or just I got wrong using cases, as I am not a proficient
> kernel developer.
> So I need the advice from experts like you to make sure.
> If this is a case worth optimizing, I'd like to do that optimization
> ( But I think many people might have noticed this problem, so I'm not
> sure I could finish the optimization before those proficient
> developers )
>=20
>=20
> RWF_DONTCACHE Performance Comparison (MiB/s)
>=20
> =
+--------------+-------------+------------------------+------------------+=

> | Device Type  | Buffer Size | RWF_DONTCACHE (MiB/s)  | Normal (MiB/s) =
  |
> =
+--------------+-------------+------------------------+------------------+=

> | HDD          | 4K          | 119.6                  | 2268.1         =
  |
> | HDD          | 16K         | 1568.6                 | 3814.7         =
  |
> | HDD          | 64K         | 2351.0                 | 4161.8         =
  |
> | HDD          | 128K        | 2951.4                 | 4061.0         =
  |
> =
+--------------+-------------+------------------------+------------------+=

> | NVMe         | 4K          | 148.7                  | 1556.1         =
  |
> | NVMe         | 16K         | 619.0                  | 1601.5         =
  |
> | NVMe         | 64K         | 1139.6                 | 1618.6         =
  |
> | NVMe         | 128K        | 1725.4                 | 1579.2
>  |- NVMe @ 128K is the only case where RWF_DONTCACHE > Normal
> =
+--------------+-------------+------------------------+------------------+=


If the HDD performance is 4GB/s then it is almost certainly a RAID =
system
with multiple individual spindles.  Reading at 4KB or even 128KB is =
likely
only reading data from 1-2 spindles at a time. The 4KiB read size is
showing that a single spindle has about 120 IOPS, while modern HDDs have
about 250MB/s bandwidth, so you need to read 2MB/IOP *per spindle* to =
get
peak performance.  For an 8+2 RAID that means 16MB reads would be best.

Cheers, Andreas

> # lsblk -o NAME,FSTYPE,SIZE,FSUSED,FSUSE%,ROTA,MODEL,MOUNTPOINT
>=20
> NAME    FSTYPE  SIZE FSUSED FSUSE% ROTA MODEL
>    MOUNTPOIN
> sda             1.1T                  1 PERC H750 Adp
> =E2=94=9C=E2=94=80sda1            4M                  1
> =E2=94=9C=E2=94=80sda2  vfat    110M   6.1M     6%    1
>    /boot/efi
> =E2=94=9C=E2=94=80sda3  ext4      2G 517.1M    27%    1                =
                    /boot
> =E2=94=94=E2=94=80sda4  xfs     1.1T  70.4G     6%    1                =
                    /
> nvme0n1 ext4    1.7T     5G     0%    0 Dell Ent NVMe v2 AGN RI U.2 =
1.92TB /data
>=20
>=20
> # lsblk -o NAME,PHY-SEC,LOG-SEC
> NAME    PHY-SEC LOG-SEC
> sda         512     512
> =E2=94=9C=E2=94=80sda1      512     512
> =E2=94=9C=E2=94=80sda2      512     512
> =E2=94=9C=E2=94=80sda3      512     512
> =E2=94=94=E2=94=80sda4      512     512
> nvme0n1     512     512
>=20
> # dumpe2fs /dev/nvme0n1 | grep "Block size"
> dumpe2fs 1.47.0 (5-Feb-2023)
> Block size:               4096
>=20
> # xfs_info /
> meta-data=3D/dev/sda4              isize=3D512    agcount=3D566, =
agsize=3D516864 blks
>         =3D                       sectsz=3D512   attr=3D2, =
projid32bit=3D1
>         =3D                       crc=3D1        finobt=3D1, sparse=3D1,=
 rmapbt=3D0
>         =3D                       reflink=3D1    bigtime=3D1 =
inobtcount=3D1
> data     =3D                       bsize=3D4096   blocks=3D292326651, =
imaxpct=3D25
>         =3D                       sunit=3D0      swidth=3D0 blks
> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, =
ftype=3D1
> log      =3Dinternal log           bsize=3D4096   blocks=3D16384, =
version=3D2
>         =3D                       sectsz=3D512   sunit=3D0 blks, =
lazy-count=3D1
> realtime =3Dnone                   extsz=3D4096   blocks=3D0, =
rtextents=3D0
>=20
>=20
> On Wed, Apr 15, 2026 at 6:05=E2=80=AFPM Kiryl Shutsemau =
<kirill@shutemov.name> wrote:
>>=20
>> On Wed, Apr 15, 2026 at 03:28:27PM +0800, Mingyu He wrote:
>>> The smaller the buffer_size in the test program, the more the
>>> performance dropped. Initially, I used a 4k buffer_size, and the
>>> performance decreased significantly. When the buffer_size was
>>> increased to 128K, the read performance with RWF_DONTCACHE actually
>>> surpassed the non-flagged version by about 10%.
>>=20
>> Maybe you have block size larger than 4k? Core-mm will allocate =
larger
>> folios for page cache if filesystem asks it to. And if you try to =
access
>> it with 4k buffer it gets multiple read-discard cycles for the same
>> block with RWF_DONTCACHE. Without RWF_DONTCACHE only the first access =
to
>> the block will lead to I/O, following accesses are served from page
>> cache.
>>=20
>> --
>>  Kiryl Shutsemau / Kirill A. Shutemov
>=20


Cheers, Andreas






