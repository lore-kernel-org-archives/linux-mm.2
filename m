Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 574711061B2E
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 12:19:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF9316B0092; Tue, 31 Mar 2026 08:19:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD14C6B0095; Tue, 31 Mar 2026 08:19:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE6A56B0096; Tue, 31 Mar 2026 08:19:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9C9466B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:19:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 398DF8784F
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:19:16 +0000 (UTC)
X-FDA: 84606263112.14.056E31A
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6E58540017
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:19:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BVrN1xAO;
	spf=pass (imf07.hostedemail.com: domain of rhkrqnwk98@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=rhkrqnwk98@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774959554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BtAjvvyWXMliCL6lUIkd5Xn2L7jgh7Ti0JdeQLLXF8Q=;
	b=YDaIbtBLiv/nQ2Nm3nFAra86dkH3E4z9qO71LSo1nVveX8W4XDxqq3DgTiGJ8D1YkxcACd
	46n1uxxStNKgcmkF2VnDzyoY8YiocgnXsmW8T5acU7jb7jTcjMfFhqweUxvpZlIGvkx+rJ
	3fgthum10MYu7IxfZmA3vVbJwaKlT+s=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BVrN1xAO;
	spf=pass (imf07.hostedemail.com: domain of rhkrqnwk98@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=rhkrqnwk98@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774959554; a=rsa-sha256;
	cv=none;
	b=qPYch6iN+H2ZTADkyh+djNZxaQejseiroe2bWLemjyVVjn6s/D8NnTlZdjmfLinY5XAxzg
	VBNHKCU2QjqSpznb3S2riDLpOpjTCGFBdDC2TlNQWwAoIhjrvR6uISwP8haK6gJm0EV4EI
	aRWotZbz0ewQQFa3lTr43SJiaghbw+A=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8296dabef74so5323874b3a.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774959553; x=1775564353; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BtAjvvyWXMliCL6lUIkd5Xn2L7jgh7Ti0JdeQLLXF8Q=;
        b=BVrN1xAOYxSLIQzfIOObE6PNmy+xKqxr70giYPQBofTEqcTQKzgi8w14wiE1lMtAdC
         poMxJCdDgags4wrUbr2jejqPnZ7TYQ+OZp4I1ABOVmoM0e4jyg11c4cFkdFxj8wAh1r/
         Zhx8EFcn+S0s3AT4CGPqSZ0/ufeIJ27/wm5P5K/pFmj93ZiyKO9e+0xvXTjU1OmRYGG8
         B/GuPPn2KH/OESFt7mzls/Qff4h5ZN5F0d4f3//WvYFQkAa3JIFxmv6kpalJH1Svr7S8
         qG5WGI9npVOA4/eH4YzNPd09LbUnYnVO8b4wTsY0NhCLne+/i22vTy/2y84ZxHUQ6ZTW
         BIbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774959553; x=1775564353;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BtAjvvyWXMliCL6lUIkd5Xn2L7jgh7Ti0JdeQLLXF8Q=;
        b=lUryIO9N+KkUUapubnuGagVoaTi3N7ovGCtdcrJ56mXgyuiuAn7vSbwE30dYKR+G4B
         W/SFll7dXQb9CKiJJDnRUzYpiAK8KKAvor/ETwLEfSfSQZzqP5BwZyVzpgg2dNCLshVW
         SaQ4ZOhTGXBTlZAZnPGET9fLLkATLUqfWnNh6uSKcRQNdkbe1sDM7zwcO+l4SbxdM0Ru
         AInzuRci87Mt/Djtq2+Eh6ns4F9DfsgmdBgnaY+j0UpGsR2l/q2SU6j0CG45tSQhZ22p
         g9KEZ8avc+7FFLiBaZjH8aKqRCHeNYm88SMFny+jW5NAkEprbvhUlAwtAb/lx6CB51kM
         MzcQ==
X-Forwarded-Encrypted: i=1; AJvYcCVbCoQ7pumahTdlJJVAWjr52cb/CG/8TexzkgW0ZAH1584bXDSVYwMPb0OEyQA18MTVcfC9tP+zMQ==@kvack.org
X-Gm-Message-State: AOJu0YyTcRctN0CmuMAFPc5aH0ZyA4NZlX6WFkOsUqq92sx6pAC4hGpO
	kS39MMB8G9/jRHD2lajyCJ1uTgnylqsZLntzQIniqetZ0UQ6RHdQ2CaZ
X-Gm-Gg: ATEYQzwgYZsr1tMPc7/RniWOY1f1FEfDKwyHn3LnI5SZdoW3onEaWDk/DSuBpwb1kiH
	8WoxNKrRv0C+uzRyLuEEOxFa5TtWlABEPGsrKhPBPgLeHh296lL73mPIxepS+xTV6Gqs5QjM9Mg
	abIYo1IoUtBGTgwfLTTkuyIwRgha92yBRT/02vjyShHre3BEwwK3RnGxDcwkApDKhlWCLLarkFw
	SjH8bKO+FKt81n5LklD6JKDsNRuhpdCiFIq6xJspl2A1ovzN51Syr73v3ZzMlbKGkcTwbclrBeI
	dNKUzWg9z4cPc5UtfTDnK4UYAE5MQ4nNo6CgFWjpSBVeOCZmDjiMFYK6SehhMy7vKSKgZrjUQXv
	p2vDchsXgguxXTTelJWQrgDMuEEGs52P+PR6LrsD17xNqdGjGHU6bGB10rHQZU5+DOY3Gu5qMd9
	38Y2L/XV2l9pOYLHq94bKL+hj/32TQteig3Dkv2ybJhdTvSq3jNbdjIdd79Sp11Q==
X-Received: by 2002:a05:6a00:9517:b0:82c:20ba:1570 with SMTP id d2e1a72fcca58-82c95ed90fdmr16398547b3a.29.1774959553169;
        Tue, 31 Mar 2026 05:19:13 -0700 (PDT)
Received: from cps-manycore-1.. ([143.248.136.81])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82ca85eeea8sm10126828b3a.41.2026.03.31.05.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 05:19:12 -0700 (PDT)
From: Sechang Lim <rhkrqnwk98@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sechang Lim <rhkrqnwk98@gmail.com>
Subject: [PATCH] mm/vma: fix memory leak in __mmap_region()
Date: Tue, 31 Mar 2026 12:19:06 +0000
Message-ID: <20260331121906.1301155-1-rhkrqnwk98@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6E58540017
X-Stat-Signature: h4smea9cbgfghegqi99t983pbnjkuom4
X-Rspam-User: 
X-HE-Tag: 1774959554-192065
X-HE-Meta: U2FsdGVkX18ebJoJDBTGANczkRS+t3sFLbHkzB0bzTwGysIGt6lQp6oikVH3jqodjhfE4rsX30Ltg1XlX1fZ+r3h1vh/kj4cMV9nL3758pY6gcHHeZZLsIww0cwosJvchMxqT9wfcggQtms3o87IKEFldshYyp88dVreH+clA0h70+EOu8CEjZDK+P1BIcSS5aaqncvagppj0mehiIV7nvuF91bjfIUIMnq6dj1bu3iIMJvq2ZamiuwBKpT9rL33lGemm0Oa1vcgeH1L696fjj4w3D+RqpkoKIa1wcDiouRtP369ISQR6Jf0lC6uGx6NA1fWZ76pxIxydLXx0bXipc6eDbyG5Pb+kdNxrrfZt2+K/spuRspAaCiz8efC49177Iz3xGMbVy9LtMiTSqkx/vudrIWOuwl3jNNBaMaUvc6TaJyQ7qichHCksZZJaXiZ+EwshNrXvGNPSSQ2lahiWVaTc8G2hzVVBb319aU2KoPyPCj9Jbfm7pFdsxHKqFsDioJP5pdMb6vOZvnURIPiVP4B/i1YIW5gZ6SCzhvGBA5hCkHwUSDiUNPtSVpKKkcC4ANfvpKwGcor48YB/Ki9ig395D8A1+N+u5oG2MusHRwF9ADhvyHSfjSp7CUvYs8PEI7RUg3CjlhFedMdLLbbBjBYca3McO4kwREl10ZklzQxOR7IIlIK34gtF6Cmx3G9Ymx/+Z2fBAWX4ufQHw4w6xY3cUkJGTpAlUHWAXva9JgEOp4v+Szj5ktHS6VOZaX7RJ2WtyJQmRd1QxTkq6RnuGfOGWTAoDiHoFguCFbhDc4uVH14S85e28SD6xE1DcLi5gBPV+/HL/fuya905m1WUTF7vO1f01zEg9X/khiihdUg8w6/ZpJOrUAuWQfwiqvzD8fL1DOw0zQPLZEmuQhBwalwfvzLJO0SAG/nSsbqUoZ3QWwSGC3NvIVMdZD9v+CNgclRBQF6MhTqHWobcZr
 KElaitf4
 fHtV4tLBe6pOqjGLGV4HltsgmzK0FLmG15byaq2vHPFJ9gHVbA/OUwL3E1mf9owmjZ7noVgNa+mf0sJcP2PLJv2mEMKSzkXpb0saO8DTVxm79EIz9Nf3ww4NxGORrMmXddE3gFmre/P2C1bNIbziycW+Pikp2dTZUKTwAxS0Td9LrgJPYehYk1ni8F1w+hLEPDhyLFqile+D4obPsaTqNxdQIH5j9ZD48UCA9f3P5pYmMQKTGjWRPxsG+bi1OK1TahmmnPT56FCRQF4DEKSse1BXxiCbrtqJ6Ccrf/8DHfU19iVQSi4IDLSkYcZ1+WEj34JiK6ctuhoDtrkrT8AqMfDVMYj8tCDalOYE/CjpPg/GePFAMZKx+iJmETyC+qFwxOv5SKh1t8AlY39q1z+fAhIPXKpace+sZYWOUlctMjNroPV2YxYrqYIuPKW+98GW7/mwKCnJrx2Zh43pu7UI57BMlGuIU0dY5/n/YiwvNnCiCXqk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

commit 605f6586ecf7 ("mm/vma: do not leak memory when .mmap_prepare
swaps the file") handled the success path by skipping get_file() via
file_doesnt_need_get, but missed the error path.

When /dev/zero is mmap'd with MAP_SHARED, mmap_zero_prepare() calls
shmem_zero_setup_desc() which allocates a new shmem file to back the
mapping. If __mmap_new_vma() subsequently fails, this replacement
file is never fput()'d - the original is released by
ksys_mmap_pgoff(), but nobody releases the new one.

Add fput() for the swapped file in the error path.

Reproducible with fault injection.

FAULT_INJECTION: forcing a failure.
name failslab, interval 1, probability 0, space 0, times 1
CPU: 2 UID: 0 PID: 366 Comm: syz.7.14 Not tainted 7.0.0-rc6 #2 PREEMPT(full)
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x164/0x1f0
 should_fail_ex+0x525/0x650
 should_failslab+0xdf/0x140
 kmem_cache_alloc_noprof+0x78/0x630
 vm_area_alloc+0x24/0x160
 __mmap_region+0xf6b/0x2660
 mmap_region+0x2eb/0x3a0
 do_mmap+0xc79/0x1240
 vm_mmap_pgoff+0x252/0x4c0
 ksys_mmap_pgoff+0xf8/0x120
 __x64_sys_mmap+0x12a/0x190
 do_syscall_64+0xa9/0x580
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
 </TASK>

kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
BUG: memory leak
unreferenced object 0xffff8881118aca80 (size 360):
  comm "syz.7.14", pid 366, jiffies 4294913255
  hex dump (first 32 bytes):
    00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
    ff ff ff ff ff ff ff ff c0 28 4d ae ff ff ff ff  .........(M.....
  backtrace (crc db0f53bc):
    kmem_cache_alloc_noprof+0x3ab/0x630
    alloc_empty_file+0x5a/0x1e0
    alloc_file_pseudo+0x135/0x220
    __shmem_file_setup+0x274/0x420
    shmem_zero_setup_desc+0x9c/0x170
    mmap_zero_prepare+0x123/0x140
    __mmap_region+0xdda/0x2660
    mmap_region+0x2eb/0x3a0
    do_mmap+0xc79/0x1240
    vm_mmap_pgoff+0x252/0x4c0
    ksys_mmap_pgoff+0xf8/0x120
    __x64_sys_mmap+0x12a/0x190
    do_syscall_64+0xa9/0x580
    entry_SYSCALL_64_after_hwframe+0x76/0x7e

Found by syzkaller.

Fixes: 605f6586ecf7 ("mm/vma: do not leak memory when .mmap_prepare swaps the file")
Signed-off-by: Sechang Lim <rhkrqnwk98@gmail.com>
---
 mm/vma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/vma.c b/mm/vma.c
index be64f781a3aa..89073980de46 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2781,6 +2781,8 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 	if (map.charged)
 		vm_unacct_memory(map.charged);
 abort_munmap:
+	if (map.file_doesnt_need_get && map.file)
+		fput(map.file);
 	vms_abort_munmap_vmas(&map.vms, &map.mas_detach);
 	return error;
 }
-- 
2.43.0


