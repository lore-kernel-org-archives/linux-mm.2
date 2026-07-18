Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1560BC4451C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 12:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4DF86B0098; Sat, 18 Jul 2026 08:34:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD7536B0099; Sat, 18 Jul 2026 08:34:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 978EE6B009D; Sat, 18 Jul 2026 08:34:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 625196B0098
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 08:34:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A2085C036E
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 12:34:45 +0000 (UTC)
X-FDA: 85001841330.08.5202D9E
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf22.hostedemail.com (Postfix) with ESMTP id E0BC7C0003
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 12:34:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aYwlR3bv;
	spf=pass (imf22.hostedemail.com: domain of liavalb@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=liavalb@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784378083;
	b=gOK4Tr1ojt7TeYqJ5IHC/q90ZEDOiGbdiq1RiQxEibdFd9/gmaEnWhXtNwMeWFgCzsz//G
	yK3khMa/iRjQzGBGaphiYEYU2LnDQWGe0Cmdmv2jKu2voFyCYWfqnGvmmFc5tTP2j1mBJ1
	Rw/E9vFnkLL8XEb59etEp3cjQG/xbuY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aYwlR3bv;
	spf=pass (imf22.hostedemail.com: domain of liavalb@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=liavalb@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784378083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2l4FYWFSpulqsw2d3VOSnee+AYUde051R9WsyPAffPM=;
	b=X7x22M+4I5xLB1OGP4A358oSAL2MEVkmYiHuLdggAeT43UFkUiqiWY+JliTeizTSy6EzdT
	x+zAnj873wyi8x6nmWambTyhccAg7gxrzw293xg7L8HA9j96zQ6xWx2qB8gkefeLOE0BK/
	DRJPHlBJIlU+c4a/4ir7yAGJ/gtTzIM=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49548aebcd8so10542695e9.3
        for <linux-mm@kvack.org>; Sat, 18 Jul 2026 05:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784378082; x=1784982882; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2l4FYWFSpulqsw2d3VOSnee+AYUde051R9WsyPAffPM=;
        b=aYwlR3bv/Udwms0g5O4+Fm9IAQ3zlKRSAtjQA16aicbwr/IRXNj+rhUkpRtvumVTTR
         huXmmlygWbsLpowhGVZa6WJzCWa68HDZ5By/Y7JpeFN4i9fDa7rSQVzMHoz9smGpNJE3
         XzhJOz4Ydl+51lrEaMi7I0EzDeh1wHNQPqTZeHwntTogVfWBSeHnspXzK8aTDGHXB4HV
         4PPaWh7w11hXNxHekDcnwSUEu6n62DU61sRu6dPtI3gx6HEYGzYdC2xmMqvdl6ugECvk
         0wJg6d2QTO82AQmNleOcDjYLVVVlacdbMi7aOxgfyToNRR8As03WmwL4jdy+40PFPEc9
         qx/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784378082; x=1784982882;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2l4FYWFSpulqsw2d3VOSnee+AYUde051R9WsyPAffPM=;
        b=iPR/9fJw5HnHMLSXsT0o94oordmdkpKqOcq7BSMFwbmxOnZPrWJkrVAAJZXg1/aOdZ
         S0LgNqPTOACozE0F3YelFmOhgKXvdDDwHbpSHqMtE9auX/ZkC2Z7peYz4PO6R2FsPKRI
         JzR9Nx69hwt7HGmK14f/UwVFgySPHkidj55x57PDdkr5fInm/609iWzMZHti2hxneOkh
         7VFn3Gze59dhQON4fND6F7nFqM0I4i2wK+Hln9YXaBlx0kff/p5ylhZYoe9HGI5UTz24
         PI2X3aLs4EbpL2G+q2KAU/wWzC/wrLqptsjceQhx0Eekz2Yf4+yJ2XLy6CpuFU6pJ988
         MPvg==
X-Forwarded-Encrypted: i=1; AHgh+RqZhlGXmGlNGCu2xRYx/uCfRfo2vRoUT1XW/oxO1g8+SoRF2JoW6fZiypcqwUiBv4mRkWCDiX/Ysg==@kvack.org
X-Gm-Message-State: AOJu0YwGCAXk6ca85jnfclq5uDvH5uc5idjjNhgAthKL4rEHRtWGU8Et
	3sVNsgcocQT02FnWrv6X+KJOTIQ+PYb9yaeeyVwC6/01C0qqyqHDsGTI
X-Gm-Gg: AfdE7cmKZSxI3csI/ePuVoXT0Acx3i2X3Dpbq3JAHjkHcJrm2waazy4kkLrSYB2AU5D
	fofEp8gDFCHXaOlJjELVXjjX9p05JAz8r4IGD80wSImA6onTFb8JiC9F4pOHYlIlPBoeNM9WDNE
	76GwOgD2J4V7HA6rzLwLI3zDkeIcPDqvSn+yVy6Z1U/q7y/xE3u4k7jhiC/ANJD+oDxeGPyk0ay
	iAZL6c4VBowIFHRJyH3I1qRq67RAZCsHZVxZed1FZZCNcZqkD4xLKiYdoPSPw1NoTAk2JISrIXN
	78rOtZ4bE557SMdr70PsBvpIM9JiS+2t5IkmOHJmOV0o/74v15s0OKgrJY0phZNpnj7i6EKReIF
	6oH/EOGAvZprxIxMwG4Wd//tiQdM+kruaMjV3uDLxaLBaJRNwqU5E4tbm9C9RD70jfEa5aDR58K
	v3fR4WWK+u0Lw2
X-Received: by 2002:a05:600c:6c91:b0:493:c337:db0e with SMTP id 5b1f17b1804b1-4954a402d87mr49546165e9.18.1784378082332;
        Sat, 18 Jul 2026 05:34:42 -0700 (PDT)
Received: from liavpc.localdomain ([2a06:c701:4900:1700:d578:12e4:b9d6:6e36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49549a35830sm129041165e9.3.2026.07.18.05.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2026 05:34:41 -0700 (PDT)
From: Liav Albani <liavalb@gmail.com>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jannh@google.com,
	pfalcato@suse.de,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Liav Albani <liavalb@gmail.com>
Subject: [PATCH 0/1] Fix an imbalanced file ref count in the mmap syscall
Date: Sat, 18 Jul 2026 15:34:16 +0300
Message-ID: <20260718123417.16339-1-liavalb@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E0BC7C0003
X-Stat-Signature: fnytbnz543er318gf41sosu6mcmcfkua
X-HE-Tag: 1784378083-387605
X-HE-Meta: U2FsdGVkX1+LiDr969nydLOjR6+IKn9080hQWdxcY9x3uEM74gGY9Y9GBoRoBnPeOPsevW6z7ty5w6MIA+j5LzaOIqoMGF/xZvtwwgl9CiZRIhiH2B7bKFAcQMqc9OzLuDzVr6LBLxBu99fO+Dog7xMcJ7c9iF4p9AF1i5ptTRdR6sdeOtKVlR7aGrEEn4mshqJcwPqeS8hDc12Ch1GS8GWFqIObVjdLikdcPQ11r9q1HrZLi2VOcHsx/6dgBfwodcmqz6ZG9KYaLvrWA67155wLDc16+x2oR56orVgR1ovCknyLHSngdgp58GTEIYIb7wRI/KLHc5c1Yev9VsIp60l5AP59KyAfockMxrybpcwQHI4yrBXiF3PNbLnbO0wHCNLEKLShit8KYkXYccy1+fhgkog0byVOkc33v2uy8esU3qq6FefptnFdNjKrxG+1Iz/1NJwU32C+7WCPKO9cl0AHRJ+dSkEd7zsno9K6MWI3haSz0KB37ajVnk8v4oyMgVpdzhkcnpfdEOxApoUu3Y7zewVeWZmd4rmF8pEEaE5nXXKOh75NOP47gKwQnllKm0a/0o4BF12xAUqpskp5X3KaB+fp/zzSxLoLUy+xObsdEp32rj5FrXUDFS8F0VRMrz7POrxnrDrXB5DtF3tsY+3fpY2QOdHyQLENVFid73OYDzF979Cg/v6ywlTYRHqLcmIqwUT7VYF3Oa3G3uxbgrBKNu6Mjb7CETKuRPE93LdnRRTOR7yslmbb3llVQVWaSqsVBiohFvxzBZXBS9JMh9sUkAuh/CuYQC5BxGfzT6L+BjB1i+HQEnclxrqyq+sWCKl4tvsbvokHOAcUhgZQWLOTw4Oe4pNDVi1EEw6/KzC7mz9Zd14sFOMSnD9MYoI/jzQ8EzZIXoxsYAFNeDg5jwIlds9d34YzRn0wwTJYo6o66xB8UxR4pFnkXUMAEMqAVfCiAK5NEzgNWb3hM+9
 B6nP6qXj
 YKhqT2pkqHcqcMwYxVl9Omms4Euql9px1xjLZpoNe9Imoi3o6Gh6VreSo7rRLkgbS1mRKCp3NxD5U2SbVX9wzIZoxgIYWkChknpDYl3hjdmjjJW1vtIFBXLhsMha4CR1pptbA7KhU0gMcOXBKs3q3WNsH/lNFQJGcQ7a+8KL4JIrSBT7yFeUFcO9QnXUJ5XMxloh8lO1LOAWRNz1a45wfVTK5Iknxyn+JLnvDQR5ggFJOGWhMhTUbFNCmLY6zvCvDg728ChmVNunbc01AeDVdpizKVboOK4+iwAC6SrrBQZXLj1mjZICa8vd9S8LzdYbHUCJj1ZRASgzP9dIlTzVi6OWIQ5k9QAVU0s/GQRsHZjLeNsEi1TqX7e1OobXkpqggwQQxtFGvhQbU8jSF0f7+gwRDWMDSMHWr/bLkYb0RH8NdsOm1YpnIvh4SwxSa7mpvmQ57dYNtXtSAbQM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi!

This is my first patch that I contribute myself to the Linux kernel.
My apologize if there are issues, I tried to solve this issue in one
evening and understand the call graph and what could go wrong.

I work recently on a project of mine called nfiop, and specifically on a
kernel module called ufedm - https://github.com/nfiop/ufedm .

The project has a driver that allows a userspace implementation to
intervene in the write and read callbacks of an MTD device by spawning
an upper MTD device that sends the data back and forth to userspace, so
userspace can implement its custom ECC engine and send back the results.

So far so good. I started working with kernel 6.18.8 on an Olimex A20
board and then moved to my x86 linux machine with a nandsim simulation.
When I started my project, I implemented a memory backing based on a
shmem file for the shared memory buffer, that is expected to be mmap'ed
from my custom character device.

When I updated my host machine, the new kernel version was 7.x so I
decided to update my module as well.
Many changes were comsetic, but the major change was to implement a
mmap_prepare hook.

I wrote something simple, taking notes on the mmap_prepare rules and
the guide from kernel docs.

Then I started to test that my character device is at least working
fine, so I have my unit tests for ioctls and mmap, and the mmap
unit-test failed after the second-run.

A kernel stack looked like this:
```
imbalanced put on file reference count
WARNING: fs/file.c:36 at __file_ref_put_badval.isra.0+0x3f/0x60, CPU#1: test_proxy_mmap/116
Modules linked in: ufedm(OE) virtio_net net_failover failover nandsim nand nandcore bch mtd
CPU: 1 UID: 0 PID: 116 Comm: test_proxy_mmap Tainted: G           OE       7.2.0-rc3-gaf5e34a41cd6 #1 PREEMPT(full)  bdadc55b51524b311c430c1536a97e7071150fd3
Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.17.0-2-2 04/01/2014
RIP: 0010:__file_ref_put_badval.isra.0+0x3f/0x60
Code: 85 f6 78 05 c3 cc cc cc cc 48 b8 00 00 00 00 00 00 00 a0 48 89 07 c3 cc cc cc cc 48 83 ec 08 48 89 3c 24 48 8d 3d 61 bc 30 02 <67> 48 0f b9 3a 48 ba 00 00 00 00 00 00 00 e0 48 8b 04 24 48 89 10
RSP: 0018:ffffc900006bbae8 EFLAGS: 00010296
RAX: bfffffffffffffff RBX: ffff88810409a180 RCX: 0000000038748000
RDX: ffff888100a44480 RSI: dfffffffffffffff RDI: ffffffff83b12730
RBP: ffffc900006bbbf8 R08: 0000000000000000 R09: 00007f8b49f8f000
R10: ffffc900006bbba0 R11: ffff88810409a208 R12: ffffc900006bbba0
R13: 00007f8b4a179000 R14: ffff888102222440 R15: 0000000000015040
FS:  0000000038726400(0000) GS:ffff8881b77d1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000038728618 CR3: 0000000104a1c006 CR4: 0000000000370ef0
Call Trace:
 <TASK>
 __file_ref_put+0x30/0x40
 fput+0x4f/0x80
 remove_vma+0x42/0x60
 vms_complete_munmap_vmas+0x179/0x230
 do_vmi_align_munmap+0x225/0x2a0
 do_vmi_munmap+0xe6/0x1c0
 __vm_munmap+0x113/0x200
 __x64_sys_munmap+0x1b/0x30
 do_syscall_64+0xaa/0x660
 ? ksys_mmap_pgoff+0x168/0x200
 ? do_syscall_64+0xaa/0x660
 ? vfs_write+0x281/0x560
 ? ksys_write+0x7b/0x110
 ? do_syscall_64+0xaa/0x660
 ? do_syscall_64+0x5f/0x660
 ? clear_bhb_loop+0x30/0x80
 ? clear_bhb_loop+0x30/0x80
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x440bcb
```

I started investigating this, and it became apparent that there's an
issue with ref-counting of the vm_file - I changed it in my mmap_prepare
hook, so it must be the cause, right?

I also tried to artificially increment the ref-count of my shmem file
when I create it (taking another ref), so the second attempt didn't fail
but the third did...

I looked at the stack trace, and the culprit is the fact that we do fput
on a vm_file that we didn't pin - to fix this, I added a flag if we
actually did get_file() on the vm_file or not, on the vma struct.

When testing this patch, I've observed that the problem was completely
gone.

The mmap_prepare hook is still quite new, so presumably fixing corner
cases like this one is a good candidate for upstream, for future drivers
that might do the same as I do in my driver.

Liav Albani (1):
  mm/vma: fix imbalanced file reference count, properly abort
    mmap_prepare

 include/linux/mm_types.h |  1 +
 mm/vma.c                 | 24 +++++++++++++-----------
 2 files changed, 14 insertions(+), 11 deletions(-)

-- 
2.55.0


