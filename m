Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A9B4D172DA
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 06:40:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A76A86B008A; Mon,  2 Feb 2026 01:40:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FA636B008C; Mon,  2 Feb 2026 01:40:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 906C06B0092; Mon,  2 Feb 2026 01:40:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7BF1B6B008A
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 01:40:29 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B482713BFB2
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 06:40:28 +0000 (UTC)
X-FDA: 84398567736.25.F149D59
Received: from mail-qv1-f68.google.com (mail-qv1-f68.google.com [209.85.219.68])
	by imf26.hostedemail.com (Postfix) with ESMTP id ED59B140006
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 06:40:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="O/2Lt0Iw";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of coregee2000@gmail.com designates 209.85.219.68 as permitted sender) smtp.mailfrom=coregee2000@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770014427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=uK93w/ShrFqcD+Iz82Mbxt0dMxt6DC+dAP+MF/FCi/w=;
	b=THQyqA5QBYQkCWvwu7qCKzcFnGA/FSoXMIZHdQioR1328tVHHvdhVdzOWrBRibnxZUQouW
	sLvS2z/Ooj03I+ltLVnrJE3TvEzFxQWmJogKHUxsGsEUFNTGUYRqlhyWpzUvrPLwp0uIor
	/eBZmgxtH2/rlItEP2eI/0gcrw4DmWU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770014427; a=rsa-sha256;
	cv=pass;
	b=Mvd75Yvv5WdrJAe7yqKF/Lexv8oX69F6IbwycFm0x5WkyysP/+v9kaHjYsL+GORCykpEVQ
	lC9wZdwarZBIa2/BlMHaisKkl4M8GbNXJFDk+LcwFEv9gXsIfbNxz/LXmdiWH7ZD0NnF7s
	MGaZQCOEifIu8Sr5qFqXv2GwSVrCoYc=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="O/2Lt0Iw";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of coregee2000@gmail.com designates 209.85.219.68 as permitted sender) smtp.mailfrom=coregee2000@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qv1-f68.google.com with SMTP id 6a1803df08f44-8946e0884afso70072146d6.1
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 22:40:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770014426; cv=none;
        d=google.com; s=arc-20240605;
        b=duvpuuQW2vNf1mjLHzXOX1NczNAV71l0JYyGQAJoiaT9YXSxttTzGlaOlkWVPyBNoj
         aJrXtr6MZP9Wo+2g5hw82bilfvjF39uI6AUX1A6R0VV+31ilQjbA/oRsMDUU1Myg0LJ4
         Nh4+giQQcNXDmCjEyPDD97mZQgAH8v6iEqVMoiw0uSpXRxaMMHCdx3ojz30GeO5jJuLi
         h/yysssKoiLhdoOpc6zcvquN1xkBLo6FogpKTTT4FeMYSa16AeRXi7Dk8HptEHR0HD3y
         xTjOYsCau5MjixbueGnrWFM06n4WJtSM5pxbHj9yRmD2R0MMk6ZKUkzBq1enQNsrQzMP
         L7WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=uK93w/ShrFqcD+Iz82Mbxt0dMxt6DC+dAP+MF/FCi/w=;
        fh=v6I/WVy/AZBP7NbLuUP+MPU0Ibj2sUJseccwdOMEeJY=;
        b=iRok6Htnb3RC5g3jEr10pza9yGAi28a3c6y94dlFdTDbU2VZ1kVWvfjaxdd7lvFaDA
         ww6e3hSx1FuvANwiX561ydFtA63UmGoJjjvKp0YaQqlT/nE1pKe2qcgFphBgTDd7tuoU
         M1d54+rj8ZEZuYrC8d+ui50ZI2WRCenaQpHF5dEv8I5By6xoya2VKx01bmfCG1W8vAZ+
         cqE6aek2HHZlvYgTK5NeFBge4JCDS+u9IJ4VpzSVg/5CFr4GyxqiO00UUvb/EZsQEDdn
         O5WdxgYPUvAwDuwuAgvmQ5KUxKywUsEdU1ZSDZHt6W6LxzAUL62475FtAzM1yqLYy1vg
         ktdA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770014426; x=1770619226; darn=kvack.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uK93w/ShrFqcD+Iz82Mbxt0dMxt6DC+dAP+MF/FCi/w=;
        b=O/2Lt0Iw7xQq2V0bP7uGx7tGoqvHJvgruGoGZqwbO75mx7GgY2wNWK2YWqJrk7EoRD
         S6QbRYAc2B65Q589eFCujP+KBmIreIVLER7bvverwuO1txSIMUFDOjD0E4dDZ/C55uXm
         sY7ORGLvcceTXYudkZMCjqzoaasgootsXg9lsbDIAQGA3UV+eJvfdhoFl68CZH94zATB
         PKytybooKWEQE1MyxwW3QOVBFNh9kYKdQm8QJpbzyYUzFgxSE6JPV+AM6R+CbiEDiyqD
         DYWt4zneiIrKWnIfz8oWDIpX1z/aVD7UVLGyM3TUp6PrDinmhpNWsvM88bAgX+kcSEHJ
         /dXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770014426; x=1770619226;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uK93w/ShrFqcD+Iz82Mbxt0dMxt6DC+dAP+MF/FCi/w=;
        b=ZHIVddnp9+IMpgjSLXCeenAiOzAi5FMO0WJlYf0c8YUuhuPmMCI/5O+1foFIixbaiQ
         Xpgl9zfF0bagoHGmZtPEKyfRsV+mKc2bEeLA8uMpJycfDUY9tZX4glBj5rjTSWbQxOJG
         waKsWOKzs+waN0k5fZLSEoPT0XTasyq+zHdcDlITkWG5vUq5BFvRAbSO+ZjVdcX4R3XJ
         gle99ajxihmyJzX7w7MjnFMe2R00AGHMnHXK7yLhnG917fjnsDVCwGXS2mr+pS4P/HWl
         Q5Z9fWl6RnF1cX7y4QBi0HG/dIXv3X22KHuAbFpJk09ujU+fdAKm1Rd+Dtp3HwWYuRSc
         tSxw==
X-Forwarded-Encrypted: i=1; AJvYcCVX+aVVd3bOb2Rsjph8/4dwpgqRZpNQJWnx40mzbm4fEpWMp5td2IdxOEflJr9D3mg9lsUXkNc4fQ==@kvack.org
X-Gm-Message-State: AOJu0YxI+DqqlgAfajcOK8Ab31luXn6M9ribrb14D/rUacerY550A5e0
	bie1s2Gqs9+AgbV+idcx1MUXvCmWJ31EeepxUichjTx4HcwOvv3+06K8KRxMAix4Wf+HPvrs9ZQ
	tCj/J4wvXqYyumd4LmJuz5u/+hkJViRY=
X-Gm-Gg: AZuq6aL8v543h3hG53MN1y9hcFjvke984PR5p5xfCBiS0HgzeAV537uEkZ4CWvThsjA
	xH7SiyvHWE5tqMf0nqBgy5R2bOy9MhQ9QI9IULbzCcYex735S4eIUDRGE/hDRK0OpjHFRKa4wv5
	AgUvxXJPK95jKAmRua9J7NECmBWyqNgVrPdRywx6CqZrmATNPaNbyY1m0nrl46xEXYB1FM7HBH4
	8INu/cH0Ky8tIJ7woa5uzh92GfJlq9u5Ag7CnEtYF1xz0WXKjR9ry7R8k2k9/F5L648Ajbc2x93
	NCLD1I8JUELw+6y6jHuIycOd7zUtmHyp9bAu
X-Received: by 2002:a05:6214:e46:b0:889:7c5b:8134 with SMTP id
 6a1803df08f44-894e9fe8ab7mr148762896d6.27.1770014425583; Sun, 01 Feb 2026
 22:40:25 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?B?5p2O6b6Z5YW0?= <coregee2000@gmail.com>
Date: Mon, 2 Feb 2026 14:40:14 +0800
X-Gm-Features: AZwV_Qgaw8B5AxJeCN-ynW6mxh99f059KgFB43y3qxaO4uIMlwNDckMSmuezWnk
Message-ID: <CAHPqNmwK9TY5THsXWkJuYCdt7x+mZHPq65AUOLZJeMp-FdAMvA@mail.gmail.com>
Subject: [Kernel Bug] WARNING in mempool_alloc_noprof
To: syzkaller@googlegroups.com, vbabka@suse.cz, akpm@linux-foundation.org, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	harry.yoo@oracle.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: ED59B140006
X-Stat-Signature: fhm4ai9wx9quix75zbkhco55111ktkzw
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770014426-839230
X-HE-Meta: U2FsdGVkX1+REmaLNaUnBA1T7DDOoixQz8qHqpCYJXqkl9LLqyJMVLOmNKenrMbLHBhviaxaW8E0wI5WLSpEOvNG5NvNTG4GpsVZ/9ZQHtrja6T1choR/9Cdjd0Fczt9qVvrIyj0dcVtNDeVE0UolaQdEKz4vpKIkEgUXWxyyB2TBvpVw66ciznGqpO8CaFX0Djg6a99+4gnoEugALE0J5NW8dIC9OENJVrjSJaUQ9bMspBw2e8++IZNMB5fqRue3J6PFJUgbigdEhY3hGpzINFVSNh7JUhsNeyOTnJsAMJF+PhtEMdd63z7pCCbUD1XC38wRWJC2NKScl7rO4LG2WXZk8QOt7CwnVePmEvs2LxIlnfWpZgVJE54ZxFSOXy8EgdisvZOqVs3bmEOlbPBCvdqRuzTAHsqZ1AD0o4naRF0gV1jdHZcLCQvJZwmr4WK4sCM9uVtlY97Rx4eXzltyeeVxnvCEDwglT4Yc39QJlTD4F+CQ6jZskhQJ9xezkO74KNNVy0l8H7fRNYy5iDuUsBbY/lBBxbnN0I/p6+ogX0EFTRWBTmTorpvEYinmZiAHTMmL4O4bnPNYQicTyKN3CFhFSvw2a96mK4IUK3BVFKK2u5irxzaklJ4vUvkiyHDkZVg0QIXAXrHZ4ZDtZ3jCbyW6XmsFnnSWgPuOcX9azKSheGOA4/4/8irH8j4fhP+cIIbYtClpoFnucYJDQzhUoKYqOoBlZm+tdY5tFfPsPiFTsJAjbC2UE43AuqZv6oMHk5kIaLSPoUzlLjq7GXVdCgWHRr5rqW5+Q9ueZT8/PRF3xYKl7Rg4tl/nlKy7cFtutW/BESJ0whYYYzaedA1zTYXfMjzFFPUM57CanfCC3xxbIYAtIMOQoEO+7qKptAnSj7xUbWJJeECY1kNDBrfVW7vty777H8Eu8cUEq8XsIxG0uWwjs5Pn8Z5vhMeT87Ft1CCFxkBfILxQURVXnC
 1A5dSVkn
 N4gCQmN77mpDLJkheMYLwQuRKBJO2DdYjkRLPng2E8nupDAL1s9QafEQ49a6qm9yi8lD5WeZSYXNK+P8Sx8sbFxVIky5KOWJezBMfgo4sWk/8yvMwNuvaBSs+mrdUXVwRLU8a4VFPtdvJUyj+Cb+7Yx7DFb3hxkcg9LTxaZ7260317Q+y9mnqSuWABs8yQaJg0unNQeNPq2IhZuHyWsJEAEqFwv68JxQkFJ0E9zicHZYd2GPJQ751BGU4DfPYpK0/MFd/KJsEeLD35LU4s8g/yHnGaI87Lj0Fi63jLPXgiZ4eKFQTOxRopWT7Vputb6aVi7N5gc0O4dFVBj9pUILHpzeTD8hhCyrO/XfjZVbaTJ+JwVYTfBCdsl+046rR3kNMw/sw1IQq6MMlQk07+pJjq75FFz1pTEOz7cc1rbwj1fHpp36bIFl1M5nPBnk6BbwsoBvM3EGTv+oBaPccY9Ntk32Q9aYGC2Fnmgdu7gwOzn4IDHHW7wulTrEz3nVSXMAF73yvkDluWXCjyZNn42K8it2KIPgkFuDaADlRKGCflGRfUnff35wxP7U2uxXorrTf3qTQEAWcOohzCZSKUcEiYf0W90aaFOJa5AiwgtyUCBHPWnQzHlrvbeIWv4exmLvmskC5mF/6TVVBQOrufzArshXODWfkP+PrNhfc2hfOJSmZhr8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dear Linux kernel developers and maintainers,

We would like to report a new kernel bug found by our tool. WARNING in
mempool_alloc_noprof. Details are as follows.

Kernel commit: v6.12.11
Kernel config: see attachment
report: see attachment

We are currently analyzing the root cause and  working on a
reproducible PoC. We will provide further updates in this thread as
soon as we have more information.

Best regards,
Longxing Li

------------[ cut here ]------------
WARNING: CPU: 1 PID: 362734 at mm/page_alloc.c:4234
__alloc_pages_slowpath mm/page_alloc.c:4234 [inline]
WARNING: CPU: 1 PID: 362734 at mm/page_alloc.c:4234
__alloc_pages_noprof+0x2025/0x25a0 mm/page_alloc.c:4766
Modules linked in:
CPU: 1 UID: 0 PID: 362734 Comm: syz-executor.5 Not tainted 6.12.11 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
RIP: 0010:__alloc_pages_slowpath mm/page_alloc.c:4234 [inline]
RIP: 0010:__alloc_pages_noprof+0x2025/0x25a0 mm/page_alloc.c:4766
Code: 10 00 00 00 44 8b 74 24 48 41 89 c5 0f b6 c0 44 8b a4 24 84 00
00 00 89 44 24 28 e9 e5 f6 ff ff 90 0f 0b 90 e9 f1 f6 ff ff 90 <0f> 0b
90 e9 1e fb ff ff e8 2e a4 38 09 e9 5e ed ff ff 4c 89 f7 e8
RSP: 0000:ffffc9003ce9e7d0 EFLAGS: 00010246
RAX: 0000000000008000 RBX: 0000000000000000 RCX: ffffc9003ce9e8fc
RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffff88813fff99c8
RBP: 0000000000000000 R08: 000000000000028d R09: 0000000000000000
R10: ffff88807fffbc17 R11: 0000000000000000 R12: 000000000009a800
R13: 000000000009a800 R14: 1ffff920079d3d0e R15: 0000000000000001
FS:  00007f1784eff640(0000) GS:ffff888135e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055bb25a85a28 CR3: 0000000096938000 CR4: 0000000000752ef0
PKRU: 55555554
Call Trace:
 <TASK>
 alloc_pages_mpol_noprof+0x2c9/0x610 mm/mempolicy.c:2269
 mempool_alloc_noprof+0x176/0x390 mm/mempool.c:402
 fscrypt_alloc_bounce_page+0x28/0x60 fs/crypto/crypto.c:59
 fscrypt_encrypt_pagecache_blocks.cold+0x567/0x6da fs/crypto/crypto.c:202
 f2fs_encrypt_one_page+0x187/0x630 fs/f2fs/data.c:2516
 f2fs_do_write_data_page+0x7b4/0x1900 fs/f2fs/data.c:2706
 f2fs_write_single_data_page+0x1454/0x1c30 fs/f2fs/data.c:2872
 f2fs_write_cache_pages+0xd6e/0x24e0 fs/f2fs/data.c:3166
 __f2fs_write_data_pages fs/f2fs/data.c:3321 [inline]
 f2fs_write_data_pages+0x4af/0xdd0 fs/f2fs/data.c:3348
 do_writepages+0x1a3/0x7f0 mm/page-writeback.c:2683
 filemap_fdatawrite_wbc mm/filemap.c:398 [inline]
 filemap_fdatawrite_wbc+0x148/0x1c0 mm/filemap.c:388
 __filemap_fdatawrite_range+0xb3/0xf0 mm/filemap.c:431
 file_write_and_wait_range+0xca/0x140 mm/filemap.c:788
 f2fs_do_sync_file+0x2dc/0x1ed0 fs/f2fs/file.c:278
 f2fs_sync_file+0x13a/0x1a0 fs/f2fs/file.c:395
 vfs_fsync_range+0x136/0x220 fs/sync.c:188
 generic_write_sync include/linux/fs.h:2871 [inline]
 f2fs_file_write_iter+0x12ba/0x2370 fs/f2fs/file.c:5057
 new_sync_write fs/read_write.c:590 [inline]
 vfs_write+0x5ae/0x1150 fs/read_write.c:683
 ksys_write+0x12f/0x260 fs/read_write.c:736
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x471ecd
Code: c3 e8 17 28 00 00 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1784eff058 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 000000000059bf80 RCX: 0000000000471ecd
RDX: 0000000000000002 RSI: 00000000200003c0 RDI: 0000000000000004
RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000059bf8c
R13: 000000000000000b R14: 000000000059bf80 R15: 00007f1784edf000
 </TASK>

https://drive.google.com/file/d/17HbDTI_iPjA72SkV5MnO-_w7IQZ9HIHW/view?usp=drive_link

https://drive.google.com/file/d/19pMiWedcVz8nFrj9jiJXuCjyPbNjYQqq/view?usp=drive_link

