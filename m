Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32AD8C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 18:42:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDAC26B0181; Wed, 23 Jul 2025 14:42:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B89F06B0182; Wed, 23 Jul 2025 14:42:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A78FE6B0183; Wed, 23 Jul 2025 14:42:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 958516B0181
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:42:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 37284C018F
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 18:42:57 +0000 (UTC)
X-FDA: 83696401194.11.EE5103A
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf08.hostedemail.com (Postfix) with ESMTP id 55C68160011
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 18:42:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KlCyvJkb;
	spf=pass (imf08.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753296175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ZEkdvyrNvf3uivlL8jNNyzaPuqLEPXHJb9U3qGdJAE=;
	b=ig3CvTNlE8UUg2KQjtx+ghzQAAjtPLqsV4hxKyYIWB4QyFpBQTAHKu6XJRFOxMDYJpfT1W
	hHJDPCUH2lAzGs3FUMoALXW12qAFCQDtMEFP1nhgvuca9foKm8VwgsDD/2sp5N8xH3Dzgu
	TSchqnHFR8vQTu0SgiWrLw9RPrCPW34=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753296175; a=rsa-sha256;
	cv=none;
	b=4xIqmQgJnuKWj4ztTEuaaaJdkrqQAW+OnI5Q6/0nH5GPRyJklejXimwGmRt8etTf+ME8Wy
	oVIEvL1sa3KUu+6MbGTGjRI2ijo71IjGKFHGOwZqtaAmgC5CFvFXu8QrH/qDxwyz2OMOQ/
	A0rduh1ZiOISB6i2ONaxRCYlUR0FGY4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KlCyvJkb;
	spf=pass (imf08.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4aaaf1a63c1so1929721cf.3
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 11:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753296174; x=1753900974; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+ZEkdvyrNvf3uivlL8jNNyzaPuqLEPXHJb9U3qGdJAE=;
        b=KlCyvJkbRqlWRONLj8kmsoaFRQs/+JMnIUxwyxF5IsOvNlMbFieO+tgY1Uf+rKFB0C
         A/n9szyp8c588c2zqHNYPhpADif9qUhvDjOjLyp4F/RemE4FbnwflbGSIoXtb44TaN8n
         W4r69Rqn4C7jH69BN+tLOX9qufwAe6YUyOIgu7PowymU5++pIGH7W0aVMJWKue/geA7X
         Be/qH3UJnDqb4pwnhkjwi+7bIcgtHZhNOIQ5TzAyYv6JwuPh+QN/aLfPWVaMGTRByVCJ
         OXkbMKbjDlu+P29d8+IUz2gwU6geyUHoYGv6gJ2eEsdsgawtG2sfzPp6pnwEIYAewLRM
         RO1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753296174; x=1753900974;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+ZEkdvyrNvf3uivlL8jNNyzaPuqLEPXHJb9U3qGdJAE=;
        b=GYmgykD7wlI0PH8opLttQqLBF6CUO3BMnFMDtaZMZIomcbHrIASOV+TsGyYSTmdmig
         BZo2i8hOWYXxFa8sqUVPHAaC18uYu/kOqkFPCZewnRG+QNQCiJYDnM01Z0bjdf1zPrX0
         laV2yc4TLPq64iU6YEmET9LtdI1sba+/nYO5TjzNTa/6whPUr3BdbkUS/W67zTHWhEOK
         524k+H+bYU2LYuutMCI/RqdweAk36LC/siIIMQRfcTA59r2/S8tP9tWyT3G6QP+aNqs+
         sZYrMbqL53hBmknZWie9M8wseEnId7ZzNMhO3zCT4Lm2pWLor/9SWFe1CiNSZMDjNqP9
         V4LQ==
X-Forwarded-Encrypted: i=1; AJvYcCXUJ6H/GU8txdjDT1FNF2v6wmmMkiZTrepeICAeGcyfwhYxbZ2jA7J0rjEURmTk/lXCUKY5CdfVhw==@kvack.org
X-Gm-Message-State: AOJu0YzMhCTW6JxGfYcOkSWYF12uwwTKW+WljNDN/RH0IbAsENozoKU+
	GklOlN7Q4GatNC0QcyolWrJzGBNmBSN6c4GvFZT6g5tvGpM8UwGrfskE1ep5eBHtsjK58+5Ylcv
	kmEeowQsU0moKJ+tfK+q8rpYkFPBp0Dk=
X-Gm-Gg: ASbGnctxrOtW3jlkjXZqUMX3hOE9WYQleGZnbyNyUx6ccN+7YxfcfLn7GoqTI9Ha2Ke
	76inmue9kalkX9zUX6dXoBUB9RyWSHl8jvNDQH32V2YIcxv9wB5lG9IIP7V5DVXtIukBY7jP+eP
	bbCW6TCCUUN5iVtrGjgRjKA2vtpgZdoaJ8l5lhhBbQVoBq0zBPghmfYhtYSRiluM6jDyV6YKg+l
	U26OGk=
X-Google-Smtp-Source: AGHT+IGO7cbVDS21n3Qk88Ct5kAOPIiuVqMX2UidUg7DAriYwXvNqbv8HJfRWnbNGiz7dV8bE3thfN4BQRzFDUCNIPY=
X-Received: by 2002:a05:622a:1485:b0:4ab:37bd:5aa5 with SMTP id
 d75a77b69052e-4ae6df89ae3mr55794021cf.44.1753296174267; Wed, 23 Jul 2025
 11:42:54 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYs5AdVM-T2Tf3LciNCwLZEHetcnSkHsjZajVwwpM2HmJw@mail.gmail.com>
 <20250723144637.GW2672070@frogsfrogsfrogs>
In-Reply-To: <20250723144637.GW2672070@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 23 Jul 2025 11:42:42 -0700
X-Gm-Features: Ac12FXznZ36tjQP__ZBzdOw_HvGQVb_DpY-StSaXMQ3PPkk_2TUI2pMhk5gnmcs
Message-ID: <CAJnrk1Z7wcB8uKWcrAuRAZ8B-f8SKnOuwtEr-=cHa+ApR_sgXQ@mail.gmail.com>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 55C68160011
X-Stat-Signature: fog3pg9iyi4qiurdqfbk4jrw8ss96pia
X-Rspam-User: 
X-HE-Tag: 1753296175-348395
X-HE-Meta: U2FsdGVkX18exzGaXqRU4bi3xakUl1DWTIlPwbZl2UslUOEGW+v0jE74r85Yx5LREA6PNqyga3sDC/hQocbnP4+Y68QVMpK0rabKNCsnoslTvHuKo0UF3ANYQwRYeWheEpAUkJ6q6DpiWBiRBoYFhf7SWPbRQ1ougl8ANxiDgId5hcuIlUZVB3G39qCnioT/FHtXj+0ggsyXHfLKGRC34WJRxwu1Syvoqt8Wqljbc9ue2VhnQxuatcZhLQRVNR8tvjT2G3QWkrb1l9RYA2lEEvXRdZ43LxoyzUk6qtoZr2MpDAUOYAqeB7KrAZQY9gql+GRxvu1VOjUuVy/FYvegwM3XclSoIL1ocYIaAzwTmrJfrGnYXNi78uDUYINw1SrjuflfEdhQWl4WdpvSocu7dNrtPp/o8AMDXchmeJVVnrpvLJjoO+BN8I+7oX6vA3EjjPEyixFX3H/DjzbbZ00dtSxFTAw2SclMhRq2wObppPhVZ3bo2Di7JLvrhlsJtttTQNm/JxJkCHZCBa+f9RJW9dwGzVg7PipS8TaWm1gcAXGiVnMnhEEZ2FjUUik8MqOvDWSsBrN/xeIjki7oIjrgeICOZ7DSl+eAKMQYIIGJJXZWNj8hEjJmZQOBHeCCc3ZIuUECD7LycCpl7Qoy3YzFYLaXp11kSazeZLV8jsiMibG5PVUWMOVgAY3AkQLwrTS3X3iTMU/SZw01T16Ba/D4abBBW+wDeRLLOh3pMmPPRg3HhGp13UizEPzPPLXH5J9F4OYnvM+zl2DkQHbY0fkkNqTN/V7kNGTwb0md43ffdtpFg1geepbDnASyEnfq9Sb4Suom72rC7Q+9l8/8J6ExK/5U8wzQuH2lxaPwU0NX0hSAXaswNXjocYuEhe5/46vrSKOHdi99xQhPFU/kbHlBjS6ADQOWEKBsm4ZjSfIkiCSmsusYiJi/ZoHiFMeYAkHaACbwUiekz5518mTQ8S8
 Bu4jLD3Y
 wE30qLNvHJsMYiPVJkJuhojQ9aRN6Q/Aas3IqCPsJ7XcQ4ZSjbnunMLIjuHGvwvo68bjrX3fy26Ml1TYWHCJ0Y6xhVStWpdFLpzeMCDgHYuVfAR8VV+GySaqKZMZCvejazaWKt9evG3/64Yx8dL1YFCL2dAWUFuHBE/lC0xW/Sezc7mk+NRoRgrioyvO3tSnJmu/23zUud6ohCx9tNEwjJdnZkfm3TnV3ChutVjdF/7JOaXrvDH1FhxJVEWMcjStR1tWEhjc3hZ7EAdknE722e92cx61yAlK0ZF+stWTcOk/cFjVyJyCNVtnzBM5VRtywuryLPHu8krQfq7WZhO5FttzgNe1rNO2ve2lqVlMttbrxDg6CBGsXIE9y2n4TzQcoOXyQcOa4FfwJfkfoPKqjrYu7NsMMPpScoB5oOe/mUt6QPql0DNi0b5JXEEA/y/n8LUy1uTzxf+LtmcSim0VZZR+Z5zna33WYDfhIOcssrL4y4lZYA42lSpI5MHGFuyHeHjQwzlOd0ntgB1Cyv8cb3Pztw90GyT/tPi5VEPPfiXrpDPDkHOTEqnpokyBuiMBLFkuQGwr7lx6cVorE1X0+N/3aOSHtwKJHyxhg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 7:46=E2=80=AFAM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> [cc Joanne]
>
> On Wed, Jul 23, 2025 at 05:14:28PM +0530, Naresh Kamboju wrote:
> > Regressions found while running LTP msync04 tests on qemu-arm64 running
> > Linux next-20250721, next-20250722 and next-20250723 with 16K and 64K
> > page size enabled builds.
> >
> > CONFIG_ARM64_64K_PAGES=3Dy ( kernel warning as below )
> > CONFIG_ARM64_16K_PAGES=3Dy ( kernel warning as below )
> >
> > No warning noticed with 4K page size.
> > CONFIG_ARM64_4K_PAGES=3Dy works as expected
>
> You might want to cc Joanne since she's been working on large folio
> support in fuse.
>
> > First seen on the tag next-20250721.
> > Good: next-20250718
> > Bad:  next-20250721 to next-20250723

Thanks for the report. Is there a link to the script that mounts the
fuse server for these tests? I'm curious whether this was mounted as a
fuseblk filesystem.

> >
> > Regression Analysis:
> > - New regression? Yes
> > - Reproducibility? Yes
> >
> > Test regression: next-20250721 arm64 16K and 64K page size WARNING fs
> > fuse file.c at fuse_iomap_writeback_range
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > ## Test log
> > ------------[ cut here ]------------
> > [  343.828105] WARNING: fs/fuse/file.c:2146 at
> > fuse_iomap_writeback_range+0x478/0x558 [fuse], CPU#0: msync04/4190
>
>         WARN_ON_ONCE(len & (PAGE_SIZE - 1));
>
> /me speculates that this might be triggered by an attempt to write back
> some 4k fsblock within a 16/64k base page?
>

I think this can happen on 4k base pages as well actually. On the
iomap side, the length passed is always block-aligned and in fuse, we
set blkbits to be PAGE_SHIFT so theoretically block-aligned is always
page-aligned, but I missed that if it's a "fuseblk" filesystem, that
isn't true and the blocksize is initialized to a default size of 512
or whatever block size is passed in when it's mounted.

I'll send out a patch to remove this line. It doesn't make any
difference for fuse_iomap_writeback_range() logic whether len is
page-aligned or not; I had added it as a sanity-check against sketchy
ranges.

Also, I just noticed that apparently the blocksize can change
dynamically for an inode in fuse through getattr replies from the
server (see fuse_change_attributes_common()). This is a problem since
the iomap uses inode->i_blkbits for reading/writing to the bitmap. I
think we will have to cache the inode blkbits in the iomap_folio_state
struct unfortunately :( I'll think about this some more and send out a
patch for this.


Thanks,
Joanne

> --D
>
> > [  343.830969] Modules linked in: btrfs blake2b_generic xor xor_neon
> > raid6_pq zstd_compress sm3_ce sha3_ce drm fuse backlight ip_tables
> > x_tables
> > [  343.833830] CPU: 0 UID: 0 PID: 4190 Comm: msync04 Not tainted
> > 6.16.0-rc7-next-20250723 #1 PREEMPT
> > [  343.834736] Hardware name: linux,dummy-virt (DT)
> > [  343.835788] pstate: 03402009 (nzcv daif +PAN -UAO +TCO +DIT -SSBS BT=
YPE=3D--)
> > [  343.836455] pc : fuse_iomap_writeback_range+0x478/0x558 fuse
> > [  343.837294] lr : iomap_writeback_folio (fs/iomap/buffered-io.c:1586
> > fs/iomap/buffered-io.c:1710)
> > [  343.838178] sp : ffff80008b26f8d0
> > [  343.838668] x29: ffff80008b26f8d0 x28: fff00000e7f8c800 x27: 0000000=
000000000
> > [  343.839391] x26: fff00000d4b30000 x25: 0000000000000000 x24: 0000000=
000000000
> > [  343.840305] x23: 0000000000000000 x22: fffffc1fc0334200 x21: 0000000=
000001000
> > [  343.840928] x20: ffff80008b26fa00 x19: 0000000000000000 x18: 0000000=
000000000
> > [  343.841782] x17: 0000000000000000 x16: ffffb8d3b90c67c8 x15: 0000000=
000000000
> > [  343.842565] x14: ffffb8d3ba91e340 x13: 0000ffff8ff3ffff x12: 0000000=
000000000
> > [  343.843002] x11: 1ffe000004b74a21 x10: fff0000025ba510c x9 : ffffb8d=
3b90c6308
> > [  343.843962] x8 : ffff80008b26f788 x7 : ffffb8d365830b90 x6 : ffffb8d=
3bb6c9000
> > [  343.844718] x5 : 0000000000000000 x4 : 000000000000000a x3 : 0000000=
000001000
> > [  343.845333] x2 : fff00000c0b5ecc0 x1 : 000000000000ffff x0 : 0bfffe0=
00000400b
> > [  343.846323] Call trace:
> > [  343.846767] fuse_iomap_writeback_range+0x478/0x558 fuse (P)
> > [  343.847288] iomap_writeback_folio (fs/iomap/buffered-io.c:1586
> > fs/iomap/buffered-io.c:1710)
> > [  343.847930] iomap_writepages (fs/iomap/buffered-io.c:1762)
> > [  343.848494] fuse_writepages+0xa0/0xe8 fuse
> > [  343.849112] do_writepages (mm/page-writeback.c:2634)
> > [  343.849614] filemap_fdatawrite_wbc (mm/filemap.c:386 mm/filemap.c:37=
6)
> > [  343.850202] __filemap_fdatawrite_range (mm/filemap.c:420)
> > [  343.850791] file_write_and_wait_range (mm/filemap.c:794)
> > [  343.851108] fuse_fsync+0x6c/0x138 fuse
> > [  343.851688] vfs_fsync_range (fs/sync.c:188)
> > [  343.852002] __arm64_sys_msync (mm/msync.c:96 mm/msync.c:32 mm/msync.=
c:32)
> > [  343.852197] invoke_syscall.constprop.0
> > (arch/arm64/include/asm/syscall.h:61 arch/arm64/kernel/syscall.c:54)
> > [  343.852914] do_el0_svc (include/linux/thread_info.h:135
> > (discriminator 2) arch/arm64/kernel/syscall.c:140 (discriminator 2)
> > arch/arm64/kernel/syscall.c:151 (discriminator 2))
> > [  343.853389] el0_svc (arch/arm64/include/asm/irqflags.h:82
> > (discriminator 1) arch/arm64/include/asm/irqflags.h:123 (discriminator
> > 1) arch/arm64/include/asm/irqflags.h:136 (discriminator 1)
> > arch/arm64/kernel/entry-common.c:169 (discriminator 1)
> > arch/arm64/kernel/entry-common.c:182 (discriminator 1)
> > arch/arm64/kernel/entry-common.c:880 (discriminator 1))
> > [  343.853829] el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:8=
99)
> > [  343.854350] el0t_64_sync (arch/arm64/kernel/entry.S:596)
> > [  343.854652] ---[ end trace 0000000000000000 ]---
> >
> >
> >
> > ## Source
> > * Git tree: https://kernel.googlesource.com/pub/scm/linux/kernel/git/ne=
xt/linux-next.git
> > * Project: https://qa-reports.linaro.org/lkft/linux-next-master/build/n=
ext-20250723/
> > * Git sha: a933d3dc1968fcfb0ab72879ec304b1971ed1b9a
> > * Git describe: 6.16.0-rc7-next-20250723
> > * kernel version: next-20250723
> > * Architectures: arm64
> > * Toolchains: gcc-13
> > * Kconfigs: defconfig + CONFIG_ARM64_64K_PAGES=3Dy
> > * Kconfigs: defconfig + CONFIG_ARM64_16K_PAGES=3Dy
> >
> > ## Test
> > * Test log 1: https://qa-reports.linaro.org/api/testruns/29227309/log_f=
ile/
> > * Test log 2: https://qa-reports.linaro.org/api/testruns/29227074/log_f=
ile/
> > * Test run: https://regressions.linaro.org/lkft/linux-next-master/next-=
20250723/testruns/1713367/
> > * Test history:
> > https://qa-reports.linaro.org/lkft/linux-next-master/build/next-2025072=
3/testrun/29227309/suite/log-parser-test/test/exception-warning-fsfusefile-=
at-fuse_iomap_writeback_range/history/
> > * Test plan: https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft=
/tests/30G3hpJVVdXkZKnB15v1qoQOL03
> > * Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/30=
G3dvSFyHHQ3E8CvKH7tjU98I6/
> > * Kernel config:
> > https://storage.tuxsuite.com/public/linaro/lkft/builds/30G3dvSFyHHQ3E8C=
vKH7tjU98I6/config
> >
> > --
> > Linaro LKFT
> > https://lkft.linaro.org

