Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE290CD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 20:34:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D48046B0005; Wed, 13 May 2026 16:34:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF8AF6B0088; Wed, 13 May 2026 16:34:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE7CA6B008A; Wed, 13 May 2026 16:34:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF3EB6B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 16:34:18 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 42121A049C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 20:34:18 +0000 (UTC)
X-FDA: 84763548996.06.F3804BC
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf25.hostedemail.com (Postfix) with ESMTP id 38F75A0004
	for <linux-mm@kvack.org>; Wed, 13 May 2026 20:34:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=meI8XrZ7;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of smfrench@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=smfrench@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778704456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YffvRc4ueiaHAv5vxRd/K/yTD1qBPNZn3LhENW3N4xg=;
	b=Q++R9x7wWNH5ZSLNMkgLCMaJuKwiCHgVeIgcHMoxOrOsWCtxd4echjK8aVSy6pv+afCjXS
	f3wR38G/9ix2sC10n5zUmevmKyeXITqSWXHHli42pRpTy2g2Ema2NpTahqJCLdEbewqI6i
	4J0JcXZyVaoyAbfP3GyvoOQ3+f7XncU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778704456; a=rsa-sha256;
	cv=pass;
	b=H+ogWFuPnP6Sg4L6zBhBiYddBYEXhm87RXXzukpLwbxWnP8jLH2lfeKhi6801G+TLe4Wbp
	X7F0VV9f9I4aVJDMgVEdJeHjEOjY/vESU4SIAo/xlW2AzNDsq+KL1YeDYKGiuhtgaOEtrq
	BJmdZrWK3/YEoeGV9+H0LKes0CGlozw=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=meI8XrZ7;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of smfrench@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=smfrench@gmail.com
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8b4298d271fso115185656d6.3
        for <linux-mm@kvack.org>; Wed, 13 May 2026 13:34:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778704455; cv=none;
        d=google.com; s=arc-20240605;
        b=CaLu+XrRy/F1QoOxS/M7z4PqiDmyGcvM7AQ0GvOgYfRq69xcifly+x4wgFDtBRmwTn
         NX0Ym42X8w1Ro4qFj7+5Xwu960yOoNQxHXdedAf0gnjnn2a5VErbV9Pq3e4tIESE2bj/
         Q44bSM3e1BSqh+sACRVpGA25nt2fSMtH+35L7UmZbcDR3hDHESf5eNthtNAnLShJEtMl
         7LFP1KzXCry27aCJQ78G3hRI+sh4NTfiuur+CCtkVbtmkRccZ1EKjDowlaqf2QJ/Va0S
         z9Xetyzm4mhRY4d7b/VhoOUsbwWvRHKo6N3h66KeAlf7QtgJKjTN6vPkP2SQvvU0uS9X
         EFAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YffvRc4ueiaHAv5vxRd/K/yTD1qBPNZn3LhENW3N4xg=;
        fh=Rc+2qWIb1e2QkVyZw9hoGb3tFZcABcEVrU+69IQC9xQ=;
        b=OY1oDqNQu1+DwOatWj9BwWkTTGp0r8czPXv7xUdxhBHZzIAhx6Zxas+hBpd1o4u3gb
         1IZFGW5wpsYZOLVw0ObJ+PYyUdMbgtvfVfXF2Vz6GLbIJuEH/KkfeRZLLddUfdwXd3R1
         HljJiMeVGMuzD/ei+TU6Zp/JX/Jw3kDPLhHi+FkKx8fcotjV4pbGbquCe6uAYbuaFXpE
         70y7Cvj+gjZ6B9maNBYzbO2NxZ7elGBcPxoXEwuRKB89X0EkoYOgGMbMEA9TpDHFZG9h
         OMyNfg4NEHuHTeR1/Cpz6h3M9dDSAQ7J216p7Jh8me4d7HPTK2SqgwjFuaIu2fnYMT2U
         nhdQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778704455; x=1779309255; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YffvRc4ueiaHAv5vxRd/K/yTD1qBPNZn3LhENW3N4xg=;
        b=meI8XrZ7Tz47OARjYgziY7V5hXXky1TmUV4djxqiVe5oEyD0HF0VAFOHbXuf0xxv8P
         YgfA1UgfCW4CNSUTcMbL6yMZjbX7EKjuIQoX14d6l/LyiJ1SsEwNaMZLS7eALjjXY11C
         I3ZCtqXlt28xb/GaiAwUCBch6C0vHA7ZnEUOfltLbV/meho+40x6oDxAGci28h8gGKEf
         7XGdkDiY2oBg8r7dUiyOGOmJxXubJx/xGH7iZTZYMdLkKGuULny46Ph3AiHtk+r54leM
         NedkVC+9mfhkP7fowx1wQmORLjhhZqR5/KZdJt0rUSDcuHmm9yG+eC/NhmZ5GMFxPkXV
         aCWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778704455; x=1779309255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YffvRc4ueiaHAv5vxRd/K/yTD1qBPNZn3LhENW3N4xg=;
        b=Eha9mLG5aJd+KpUYhTGKo2GeIre3CTP3IWLcEm+xw/rH3/7ORnxfOmJW5UwK6e6d2p
         bAoEbIs2+63/jCUrSHvSX+xHXMvtwvByhfSiSeolObUm3VvEv5DuUM9E1flke77CVajg
         y1CqEuIEQxkqXKUQwz9PfmyVJV5VxQm3HM3BVpgGykGytRjrs4ViV6zOhdRxmgyBAaO7
         t0SHWyKEgxrFsrSm8uHXWhG+KZ3jwpi4XZd5tb3AI1/mQ30XggtqPYLLs7wEKoPeMIgx
         M8j0dWdhgo+Qn3c+/AyfGyFGOcy1vDAEtZjvL2j8q3hcmRzxoM8KP0/RYpO28Uk5D+Sc
         MapA==
X-Forwarded-Encrypted: i=1; AFNElJ8QBwVQ2PDHObNgVwVg5QF+vprbiK3qE0zzL7NNoswVBiBLm4dT3vhVQgQKeaEDjo2ZQ3yGx1pJMg==@kvack.org
X-Gm-Message-State: AOJu0YxsIFt/uANoVXw1pekw9vrdT4+xwCOEJHcbrJ1jkhj0l2jPsn6B
	rgB0uXTzm3/IKSa0UQ3j1J1mi2AELmjYLjDqx5qS0Atn9r+gHN1ABnKFNS7qI7sLmcS694eG+8G
	+n0pdSCzJME62JAD3KFR5lPIfEdfd9s8=
X-Gm-Gg: Acq92OGbIX81SPIo0Ul8pO93hZcBBLTwkCI4mQgtWehvdXMtwqkxHr4xRc98a0X+dvR
	vjf3kgfZWG3ansLTIfu6t621uQXA2EHPUc7fn47WqkGePDGJR9DW23sQh3DRZbeYhMjCTfnCSrH
	J/ohXr+2YWcOldKUrKvnR6u71jAbSauL3Dnd2oSoP6p4NXhUlRprWqueZiWbWqTWJPgW7us3ZuB
	4bObrR3ibuA1bEKgqklOD2z3a1+48scBeZL5esm/yAZZtJt5v6MRuzK7bbmAVR4twQo4+DdnprS
	/9bII40wdUTbtiapvMc7GyPpw14AVRwilE2v1y0CtLvY8DscsB8+XCkMeJqcq+l4BPyWgEl89dH
	ttzyv/VSch9CxEqey0AtWXa+E3QmKZhI7kytzyAXFrSI70zO8wTMHD4brIhJ1pqg/L14yg+1zSi
	40okdoJNkXEO+J11kv3iQgJA==
X-Received: by 2002:a05:6214:8009:b0:8a0:846e:8850 with SMTP id
 6a1803df08f44-8c7b9d6a34dmr79395336d6.20.1778704455206; Wed, 13 May 2026
 13:34:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260512053625.2950900-1-hch@lst.de>
In-Reply-To: <20260512053625.2950900-1-hch@lst.de>
From: Steve French <smfrench@gmail.com>
Date: Wed, 13 May 2026 15:34:03 -0500
X-Gm-Features: AVHnY4LdSaGvyovg6RvG5pKhPWnEZkoZnNgrzQdw3V-htIBym1ah9EOHikjxM8Q
Message-ID: <CAH2r5msnYVb3hhXHwqDVHGGC1h4E6mLCRS4ktCrQoD9zdUW81g@mail.gmail.com>
Subject: Re: improve the swap_activate interface
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>, 
	"Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 38F75A0004
X-Stat-Signature: exp99kmuoaaotpqgqm8nrkd7cn5dwbqm
X-Rspam-User: 
X-HE-Tag: 1778704456-578900
X-HE-Meta: U2FsdGVkX18nQKMFxso93CqURgNA4pEra+TIp8HD7U0CPL80S4snMZfizGeZIWmOyZMIgNqZ+cM9c4evHGtR+RGpF2TqCopkCuhI4V6vClKoOwWyd3sjr6/1/I+eroj8dsAyyajR0DjIoXjo3uEd7od22N3sYOZNjStuhla0QJsjMo1zmVyeY7Dus2c9ZARQNKI+OKugFA466RmFaNV2GBw5RIZz9xor2de6ohUMGduEDq2JIuyfxdG4mw3GF8CG9WMgIfDVk+YJhDxbwxnVHPN+WWK/NQS/aF+dVAZSDaes5UHErgSQ8lMkxga8XfKGnu+RzAI5ahvexBK1PlKnHNFZ1cs1JqIbGvtr8VRtGGYqwwWE2ltDI12lwUKe9++s/hKIMDNHOvpgm23L3rapKiEocxSB66TPaD5joNxVZ9ReKI7pQ2YWh3IZNkT3wTJOkfYOofWy/plwDOXJoDUhOo1S28pkr0wDjM+AwNHQM82kPwR7ODGrnLl2dCDPfjNB0l3E8Vuo8r5+YJy0rkLFoLn4dS0+xy5BNylaw8/p34WXPeQ/gIEQzso+JEJ7SFAGuE51tGM3Q2hGSaHj2uRg9MUor1CeW8UrejPHRc7d1ZXEqFs8EXlp78vzBjtlgzxETP/LJorJAeVGvhb3JGEIiHf8FslC6n9m2O98lvA0pUD0VMNCKE/9NAePNSUDsHiiNMeoqpD+/2RHyEYKDYVcZoqkU9B1SvMnMmLCu1f30ZLhJZ2agxVsrCIP/SYryIUzpzk6mHNlG9GcDHcqfh0NTno763pVH/hy0HaGmx2VFZQ1DNLjSs17jYJsE4C685PJNdU6WgDVBk6oESpa1thz2mf+6SCYBODP6q6EvVckfEUbisLGH9fP31+6fnIl1vT0h24hvD4EJh/Uh7kz8rX1gjIzOe83rPOk3G4X7dwUcMACc4XjUG1mFQG4OcYM1DG297b1kiXisGVd75fKOxb
 QmK8LVGJ
 yF8dZ7i17lZdnz+Erem+TmLmftknAOxBNJGkghcT3j5ymtXbcw+9WYDQxN8Gs7jEN5k66AgoI9mCGea0Hi8ma/CgkjoVsVfRUSIhh9BScoW+oGFclJKmZ+PDF30ZdHUUFwX339E6NWaweqtERyYR7Evf1kukPCic8QFR7f3mSVb5pTF7RXh4mZY31wTeJpI/yjLD9ZOs+cXzZ8uYMkfh8APh3FInx1h05Fg4q0ZxN2UTIwfVOqqcDvf2WaWCZVtGPKFslufDTYSE/wWEISZNRudi88P2EO5OMVMdGxPQlEv6Qiht488Ysv024KuquD2ep3qXjdi9NX413iL4SOJ7d9r5RJJnTGCOZYgQX0JhmVn9430XepC4aRF73Rd4IwFHEl1aJiqPQ7VCA9SUkZbzDA4G/A/ugDyR41TNDkEU+06CxmCFiMpAwram+Cf029vDwH5KM73Sep36SjA9GCFLlaKrNRS1a2/69lD1bWujGS8X4LJ4Pebz4PaJF+6W+Qmmj6E81GzwJ+JusEjo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I just tried this on 7.1-rc3 with the swap patches (full kernel build,
on Ubuntu 25,10) and boot failed with out of memory which I had never
seen before.  Any idea how to workaround this with the swap patch
series, or is there a fix for this in the swap series already?

On Tue, May 12, 2026 at 12:41=E2=80=AFAM Christoph Hellwig <hch@lst.de> wro=
te:
>
> Hi all,
>
> Darrick recently posted iomap support for fuse-iomap, which was trivial
> but a bit ugly, which triggered me into looking how this could be done
> in a cleaner way.  The result of that is this fairly big series that
> reworks how the MM code calls into the file system to activate swap
> files to make it much cleaner and easier to use.
>
> I've tested this with swap devices manually, and using the swap tests
> in xfstests on btrfs, ext3, ext4, f2fs and xfs to exercise the different
> implementation.  Out of those all passed, but f2fs actually notruns all
> tests even in the baseline as it requires special preparation for
> swapfiles which never got wired up in xfstests.
>
> Diffstat:
>  Documentation/filesystems/iomap/operations.rst |    3
>  Documentation/filesystems/locking.rst          |   35 +--
>  Documentation/filesystems/vfs.rst              |   40 ++--
>  block/fops.c                                   |   15 +
>  fs/btrfs/btrfs_inode.h                         |    3
>  fs/btrfs/file.c                                |    4
>  fs/btrfs/inode.c                               |   72 -------
>  fs/ext4/file.c                                 |    6
>  fs/ext4/inode.c                                |   11 -
>  fs/f2fs/data.c                                 |   50 -----
>  fs/f2fs/f2fs.h                                 |    2
>  fs/f2fs/file.c                                 |    4
>  fs/iomap/swapfile.c                            |  165 +++---------------
>  fs/nfs/direct.c                                |    1
>  fs/nfs/file.c                                  |   21 --
>  fs/nfs/nfs4file.c                              |    3
>  fs/ntfs/aops.c                                 |    8
>  fs/ntfs/file.c                                 |    6
>  fs/smb/client/cifsfs.c                         |   18 +
>  fs/smb/client/cifsfs.h                         |    3
>  fs/smb/client/file.c                           |   16 -
>  fs/xfs/xfs_aops.c                              |   48 -----
>  fs/xfs/xfs_file.c                              |   39 ++++
>  fs/zonefs/file.c                               |   30 +--
>  include/linux/fs.h                             |   11 -
>  include/linux/iomap.h                          |    5
>  include/linux/nfs_fs.h                         |    3
>  include/linux/swap.h                           |  129 +-------------
>  mm/page_io.c                                   |   45 ----
>  mm/swap.h                                      |   92 ++++++++++
>  mm/swapfile.c                                  |  227 ++++++++++++++----=
-------
>  31 files changed, 471 insertions(+), 644 deletions(-)
>


--=20
Thanks,

Steve

