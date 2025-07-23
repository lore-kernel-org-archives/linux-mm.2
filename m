Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9F29C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 11:44:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56CF86B00B3; Wed, 23 Jul 2025 07:44:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51D676B00B5; Wed, 23 Jul 2025 07:44:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 397386B00B4; Wed, 23 Jul 2025 07:44:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1DE316B00B2
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:44:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B821C133928
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 11:44:42 +0000 (UTC)
X-FDA: 83695347204.05.98103F3
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id E4DE640014
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 11:44:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=RMtYrelA;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf01.hostedemail.com: domain of naresh.kamboju@linaro.org designates 209.85.216.42 as permitted sender) smtp.mailfrom=naresh.kamboju@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753271081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1TM2lXI6LKVFFwwKvZZGZaBeEju7c6SCV2hGX05xnS8=;
	b=3Jwo7L18ygwyK2CU2CLHnCy6H7c7uIjJ7+AaN+9bcVNwPMQq6bs91Ypk3bgbk9AGeCCKxR
	L6vAsE/TfNxL+0TNtv2oqVNyUDjEhpYGbtarFvxFBz8Q7f7rIh8Lafsq1dVp+tft+PVJeu
	mC//MXoKZGU7RkkKlfFbhaWo3e43uuc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753271081; a=rsa-sha256;
	cv=none;
	b=RRIYwNp1/E+pIYdIDFKz0vepB5bJtomL1PuxWFfj1Oszk5JnSP1QKX/hI4pgMpkvYXWWal
	jDm7wFgZTK7JupXL6F04idtggXywpgu/s4cxbFDefCmq484Sk9+0SJQ24KberQ8gZtrcKP
	rmYqWUV5KmuvhIuUm4lkaSL7JS8GZrc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=RMtYrelA;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf01.hostedemail.com: domain of naresh.kamboju@linaro.org designates 209.85.216.42 as permitted sender) smtp.mailfrom=naresh.kamboju@linaro.org
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-313eeb77b1fso5500184a91.1
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 04:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753271080; x=1753875880; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1TM2lXI6LKVFFwwKvZZGZaBeEju7c6SCV2hGX05xnS8=;
        b=RMtYrelAaESSZY2eDAeC1K2Af3hrPfp2kkII77mKj/m1HyHgeXw91Wt5tpB36pTiCz
         h60qSQbZlgZef/FghOIV0VKVL9tWwIzy/mX2DleI393p8x8cGRyxRyxKVH0RR7oZp5Ni
         Dmry6s8uy2gH/W2gstmt6HyR21ZOqTaOwaRWIoFGreh5Fp7DmEIsi7KKpzzrlwQViqTU
         1Iig/Z4fWFXZqXGsuqMwN2h7sOSWmZ5w28mjB3tuHK29Lr3nFxFhYt8t6lJmzaoW+qVA
         bYkHjrzGTSL8Bcs5+/JMEh/TSdvuknbfp4C0MTv8ESK/3HFXMPl4sBL9rS2kOrpgFr12
         FpJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753271080; x=1753875880;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1TM2lXI6LKVFFwwKvZZGZaBeEju7c6SCV2hGX05xnS8=;
        b=Fo6TdmQYyfp7zJ/ttHug7wz5UKv4dAJmddlPkpEj2pWHIybYfcndyPbHDdwepsYYqM
         IsKShyltMWM6sOF5vbG2o0LCqL/QtpEZgeIAa0KllrP4FBpfKgKX71Ai6/cjpRsWNo6c
         qt+sIwl8TReDm1yDKa13xj/d2jKSJJPpuscYUIwT/KPWZUKTtRBOYdrJzEULcMOxSC36
         GyC4h6v04e5/kmrsXLdn2IAQstMNAUXa0i2kcrFyrDJLwAmyru3EGrMaM1arq+ijIU/m
         l1/vEJXQZFqb76bbFxJChgUpG4DXaNPq5WEjjVj5CglZCVJVwA/vxp+bBSZwxDuroZaA
         Vmng==
X-Forwarded-Encrypted: i=1; AJvYcCXmxWwRdrB18E+QCCKZ8luSub7cBhjyd52s9OLehxeq6kkPgvIxE1/B97y8DKn/E1r4va7pgu5Mlg==@kvack.org
X-Gm-Message-State: AOJu0Ywp184z/FmtXT8InAsrTnEx4RnahzLJV7rUypEOntCs1tWvdyPy
	QDtYxbZQJhyLDcx7zCmLmHdQ9EEEU12FiiD6n4iLho+T3Sva2PieGQqXvbLND/veMnaYvaf36Km
	NKjY+55x6ijurESZ5DCh7oR4eLhS1g9pXyK6Pt7jsKA==
X-Gm-Gg: ASbGncuXK9J9l69l1Ns3uODtwVDkwXcwp3rD6w2OEth+lHRrc53M8iHhbRSSh3cO5uy
	dH1VK7wdZ8uWn7G8pAkwa6IO6F7c3A5k37O1qNH64dWWraqNT1kk1Lx5VQJ/Ej56IRXZM7EjSOg
	VlE19VXvbA+dwUDMpgU8ppIlMmbD5PMEly6nlFsLv6CqcmW5k7kAaAtUH7AhQHfPxHIkTDerWKh
	RFLBwaqtE+RK7NhT/UAjV6vf0YIn0Fz3Z/RgJM5
X-Google-Smtp-Source: AGHT+IEhV+0xhpn9zGV2a6sm19XLdd8n4FB96H4yqAPVqOdZG5EnD3iwTpL+ZT5wmT24E8Pvq3yy1m+gGSGTHyCf3PM=
X-Received: by 2002:a17:90b:5488:b0:312:1c83:58e9 with SMTP id
 98e67ed59e1d1-31e50792b7bmr4177595a91.5.1753271079656; Wed, 23 Jul 2025
 04:44:39 -0700 (PDT)
MIME-Version: 1.0
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 23 Jul 2025 17:14:28 +0530
X-Gm-Features: Ac12FXzxMQQLVl4FMvovsrunOOtQXchdTouMHZnPEIiuTGf6k4FuubUp0DfE068
Message-ID: <CA+G9fYs5AdVM-T2Tf3LciNCwLZEHetcnSkHsjZajVwwpM2HmJw@mail.gmail.com>
Subject: next-20250721 arm64 16K and 64K page size WARNING fs fuse file.c at fuse_iomap_writeback_range
To: linux-fsdevel@vger.kernel.org, linux-mm <linux-mm@kvack.org>, 
	linux-xfs@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, 
	lkft-triage@lists.linaro.org, Linux Regressions <regressions@lists.linux.dev>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <liam.howlett@oracle.com>, Arnd Bergmann <arnd@arndb.de>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Anders Roxell <anders.roxell@linaro.org>, 
	Ben Copeland <benjamin.copeland@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: E4DE640014
X-Stat-Signature: q61yc58gn145guxikuj1uqg5w14jg318
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753271080-240108
X-HE-Meta: U2FsdGVkX19Q2zwWQY8Yzw9Wy9gKAGf9gEREa6X9GStl49p2Rcdr1IVJmzmwrItdwdecics1SCjP6DoavxIPNpzv5RVZI0IK2H2Iv3rwTQLSCAg4ylFOI9dfaiRFKswtV/OcD0CEf8xE785/31qNKRhIlWVyM9h2wrhqbnvTkSBjUSN9e6UtpXvvg56AaHk7aXL2LFas7N0kMmNf77CETOgrStWydRV7NfMdf5K1lv2XWvPQZ/oFOvwY/9vXbyYOwkfx/B1YlkmB8eYThVNq4nTjTUUhuuaa/wXgHHxEGkFZ/OcBK50ti5HpPThrq8NavISeM/GA9VnU1w185mm9lIhJcK/VZU63lCB/C1msFtyQuG+zIqMNbKCRz3A52U4E2wzsgg72/M48jk++aW8q0G7jnCnrlMpdec3zuLkR8Pg6p6Pmm390HvgzsksJAWT8X2yN8y30nJWQh+Me/Teqo8gPbb3WDH2muq9sq3wf2udPxoGBso/yNcos72cZwxQNGFhHRjKXa51JmkfKMc2Z4440MC2M/44+SQcQZbfbS9+U5wUNSpwP0GHyZY+OJaQIt8PsV3N5WnAb1SkGAyE+AECJTziVg03yIPijy9oVcnQzhP8jh/+NKomx0h/1zKq8UdAwk7dZoVY3Sr9fG+qO+9FqFYl9KDfYLEVTw96WynI7PavCcJ6nSTkuTnmSfpBRHzeAGyH+zsk41MFUgB2AjEnxApENwrKNSHS6HTjCUGnkHC8OGkihZLQA43dxrHgmNutIuvRoJnv0d+tMSY6+Xk45RL6Zbfctki4FzINJH2CFk/AvaFvakEkqEoY+SG4Yx0jhc2vAmS53+RTammJ07oAc2oyB/T2mZMylAyNJ3JHsFBMKPnR9iZsXa3JlGwhfDqhs7MpRv0JY91R2TLFZlR79ACBhfI2cT81Lyk7MqeiYJ72QAZ97aXCvOUKC5UK2TkmAyG0f21621AnJDLN
 SdgEZvd0
 E2RRCfHCpsODr6QlvTgEgREUMAmdxBy2GJPJo7IvXmdzYyq1ZPFAXixYczw2GrFXpSAGfyutLCuaFM4L9vXrRBlPbtmYRtYQ5pIdqugELf/A/DWe2YHsoHcSPpnK9q3kBS1eOw32blNQECmoR/oHf/RmOu2m/iIsPoudvkJm867M5zwBwMWTkOjJemWphFaA+Rxx5xklisdI0snOZGy2o3eG68r1tFHDoIBrhQbPrjR5yfUW198k4APs2m85sTUrdnBoNm+49bsrscY1Bhurm9Xmx1yFIXtrwoTatEkfjQSHFvn1WCdotV49TpyOqE+tzb6ZqNCzrwGoHAvHAI3sHU5h3c91dTlNSuSS3izp4xx+oeZYUUdYIzzjvJ0Q7XZE6eVxb8ZZiE+Yh3v3iMBY7Ef+HOZCwM4dIuKNy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Regressions found while running LTP msync04 tests on qemu-arm64 running
Linux next-20250721, next-20250722 and next-20250723 with 16K and 64K
page size enabled builds.

CONFIG_ARM64_64K_PAGES=y ( kernel warning as below )
CONFIG_ARM64_16K_PAGES=y ( kernel warning as below )

No warning noticed with 4K page size.
CONFIG_ARM64_4K_PAGES=y works as expected


First seen on the tag next-20250721.
Good: next-20250718
Bad:  next-20250721 to next-20250723

Regression Analysis:
- New regression? Yes
- Reproducibility? Yes

Test regression: next-20250721 arm64 16K and 64K page size WARNING fs
fuse file.c at fuse_iomap_writeback_range

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Test log
------------[ cut here ]------------
[  343.828105] WARNING: fs/fuse/file.c:2146 at
fuse_iomap_writeback_range+0x478/0x558 [fuse], CPU#0: msync04/4190
[  343.830969] Modules linked in: btrfs blake2b_generic xor xor_neon
raid6_pq zstd_compress sm3_ce sha3_ce drm fuse backlight ip_tables
x_tables
[  343.833830] CPU: 0 UID: 0 PID: 4190 Comm: msync04 Not tainted
6.16.0-rc7-next-20250723 #1 PREEMPT
[  343.834736] Hardware name: linux,dummy-virt (DT)
[  343.835788] pstate: 03402009 (nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
[  343.836455] pc : fuse_iomap_writeback_range+0x478/0x558 fuse
[  343.837294] lr : iomap_writeback_folio (fs/iomap/buffered-io.c:1586
fs/iomap/buffered-io.c:1710)
[  343.838178] sp : ffff80008b26f8d0
[  343.838668] x29: ffff80008b26f8d0 x28: fff00000e7f8c800 x27: 0000000000000000
[  343.839391] x26: fff00000d4b30000 x25: 0000000000000000 x24: 0000000000000000
[  343.840305] x23: 0000000000000000 x22: fffffc1fc0334200 x21: 0000000000001000
[  343.840928] x20: ffff80008b26fa00 x19: 0000000000000000 x18: 0000000000000000
[  343.841782] x17: 0000000000000000 x16: ffffb8d3b90c67c8 x15: 0000000000000000
[  343.842565] x14: ffffb8d3ba91e340 x13: 0000ffff8ff3ffff x12: 0000000000000000
[  343.843002] x11: 1ffe000004b74a21 x10: fff0000025ba510c x9 : ffffb8d3b90c6308
[  343.843962] x8 : ffff80008b26f788 x7 : ffffb8d365830b90 x6 : ffffb8d3bb6c9000
[  343.844718] x5 : 0000000000000000 x4 : 000000000000000a x3 : 0000000000001000
[  343.845333] x2 : fff00000c0b5ecc0 x1 : 000000000000ffff x0 : 0bfffe000000400b
[  343.846323] Call trace:
[  343.846767] fuse_iomap_writeback_range+0x478/0x558 fuse (P)
[  343.847288] iomap_writeback_folio (fs/iomap/buffered-io.c:1586
fs/iomap/buffered-io.c:1710)
[  343.847930] iomap_writepages (fs/iomap/buffered-io.c:1762)
[  343.848494] fuse_writepages+0xa0/0xe8 fuse
[  343.849112] do_writepages (mm/page-writeback.c:2634)
[  343.849614] filemap_fdatawrite_wbc (mm/filemap.c:386 mm/filemap.c:376)
[  343.850202] __filemap_fdatawrite_range (mm/filemap.c:420)
[  343.850791] file_write_and_wait_range (mm/filemap.c:794)
[  343.851108] fuse_fsync+0x6c/0x138 fuse
[  343.851688] vfs_fsync_range (fs/sync.c:188)
[  343.852002] __arm64_sys_msync (mm/msync.c:96 mm/msync.c:32 mm/msync.c:32)
[  343.852197] invoke_syscall.constprop.0
(arch/arm64/include/asm/syscall.h:61 arch/arm64/kernel/syscall.c:54)
[  343.852914] do_el0_svc (include/linux/thread_info.h:135
(discriminator 2) arch/arm64/kernel/syscall.c:140 (discriminator 2)
arch/arm64/kernel/syscall.c:151 (discriminator 2))
[  343.853389] el0_svc (arch/arm64/include/asm/irqflags.h:82
(discriminator 1) arch/arm64/include/asm/irqflags.h:123 (discriminator
1) arch/arm64/include/asm/irqflags.h:136 (discriminator 1)
arch/arm64/kernel/entry-common.c:169 (discriminator 1)
arch/arm64/kernel/entry-common.c:182 (discriminator 1)
arch/arm64/kernel/entry-common.c:880 (discriminator 1))
[  343.853829] el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:899)
[  343.854350] el0t_64_sync (arch/arm64/kernel/entry.S:596)
[  343.854652] ---[ end trace 0000000000000000 ]---



## Source
* Git tree: https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next.git
* Project: https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250723/
* Git sha: a933d3dc1968fcfb0ab72879ec304b1971ed1b9a
* Git describe: 6.16.0-rc7-next-20250723
* kernel version: next-20250723
* Architectures: arm64
* Toolchains: gcc-13
* Kconfigs: defconfig + CONFIG_ARM64_64K_PAGES=y
* Kconfigs: defconfig + CONFIG_ARM64_16K_PAGES=y

## Test
* Test log 1: https://qa-reports.linaro.org/api/testruns/29227309/log_file/
* Test log 2: https://qa-reports.linaro.org/api/testruns/29227074/log_file/
* Test run: https://regressions.linaro.org/lkft/linux-next-master/next-20250723/testruns/1713367/
* Test history:
https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250723/testrun/29227309/suite/log-parser-test/test/exception-warning-fsfusefile-at-fuse_iomap_writeback_range/history/
* Test plan: https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/30G3hpJVVdXkZKnB15v1qoQOL03
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/30G3dvSFyHHQ3E8CvKH7tjU98I6/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/30G3dvSFyHHQ3E8CvKH7tjU98I6/config

--
Linaro LKFT
https://lkft.linaro.org

