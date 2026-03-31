Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE34BFF60F4
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 18:08:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 096F76B008C; Tue, 31 Mar 2026 14:08:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06F166B0095; Tue, 31 Mar 2026 14:08:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC68B6B0096; Tue, 31 Mar 2026 14:08:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D90246B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:08:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8889816039E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 18:08:31 +0000 (UTC)
X-FDA: 84607143222.17.EF7CCDA
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf01.hostedemail.com (Postfix) with ESMTP id A7DE74000A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 18:08:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y2IMy4FZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of rhkrqnwk98@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=rhkrqnwk98@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774980509; a=rsa-sha256;
	cv=none;
	b=neUzylW7uRkoEyjnVskHEU3zmEvj3r/UpiFG++iZ5DEIdrCgWmI4XS+kPh4itQ6Y7Zq7QW
	40UX3RnRB9ec99FojbUgCEXEPjWaynYoF9eiBGj4F3tkLjAzrxP6nP4kfXGU2VxMAWKYAU
	x4WmZgoCgKR5QC98pf9s40I0YEtLsXk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y2IMy4FZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of rhkrqnwk98@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=rhkrqnwk98@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774980509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9ixODfTNhyekCgLAxcGK9gRDulyUyJjrmwYIdnfzbC4=;
	b=oHCFR7Hws4vk/eD9go9C5PM/t5LBPBmbxn7kYzpHlma65eNSv9xRknlA20rB2WPNZA069y
	ifrPj6AKRAztR3GbVrR8zE9lViLOVHayRLGsGs3qBjcv2q2ZMpI+k6/tICT2ehzDUsciOD
	KzdixDaY60Lc3Dq1O1F9SFTORbufaRU=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-35d965648a2so2367282a91.0
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774980508; x=1775585308; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9ixODfTNhyekCgLAxcGK9gRDulyUyJjrmwYIdnfzbC4=;
        b=Y2IMy4FZUVYE6H8NzlaB6fxOmXv5vZJrECGLzeQ9jplqqXPPDd5LXJGYyWfV1C+/4z
         iDY5BcKx2sRdFkElwXrJREW05zS8d/Xs5neoeEwb0tCh2ilV0exXsqUad5BbKh6oQqoX
         LvI/JpV7GtvMiyOUUEvNmF0NSYf3VMpOAeZLIw2h6SWbOO3jHaHmdpNMpb07Ovg/irs8
         v/kKcHAftIhGfSxavaRrUfnnhNAWjlDLJRHM1WNALS1L4SRFug05ri2PhjOrn4I3+g8u
         x+evkQoqkIGhQSmaXX866Ph86Xfk83bEAP9e7lsc2dXHWBcbHVzdp0iuF7iJ7GVLbTN1
         oqrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774980508; x=1775585308;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ixODfTNhyekCgLAxcGK9gRDulyUyJjrmwYIdnfzbC4=;
        b=Obrg5h7fSw+Rc7T32v2T2XyK68KFtTwsm6tEvuVrGVLED1N2SwtQ9/lKqgxVBkPXs0
         3FZbKF06fiMEYd2ad5HhMu/MiTco+GaRYiC4bCejXT5jfXYsHy7WDAmkRwIMvvD+s+lM
         3hRADYqJ78iYr6MCd9CLIOhqZoabKcp1QO/hE2j7EyPO9nu8veqQZjMCL8IgFLVlhtA6
         yNjp8YjNblb+YQQnpfeyG1NPxJyJgUJAXJJW8Mrax/FpxfxpSOBXVHN9bHT16wcJbeOM
         Lc53ca8xtL7eYzStCF74Y404cguY4Y0MzePhf/UaVQ02iGpW2CTZZuhSLqpjMTz9bF8C
         P5pw==
X-Forwarded-Encrypted: i=1; AJvYcCU0T/4bfksVWddeLCRi6PlUP58ebj+9AZw+qbrz4GU8MTysQmKioL6H520hZ1iE+PZjT/rsUL0b8A==@kvack.org
X-Gm-Message-State: AOJu0Yyatze2YRqHM0mpz7Qmp0VSgPOGaQ8kZDmHaCdf2OnklfKWk9cy
	j2XRRtNDBQcTVPLXhL1Kfkew99o2kJ9gpLvcEAPWRAnFlHBONgtHGPPe1BoWC4ks
X-Gm-Gg: ATEYQzzatcLoBuqUCJflTq08W0mbthw0ZAlOfYBFMVx7dc3j+OZfE5x8//HL01UXs8y
	5WEPZlONZiB3+zO030QGqDukRbkyk/UWfgEMZST6MgDOhDkuYUnNR9/R5jtFyMqusP5HfaWDhNw
	6/P/GstpaO3cr9Je967a9pYPsgDF6tIQMgeKi92iBHnzpQheA27mv/7rYfKOhtcDkG/q7zRR25x
	FyZk1vgQfYpOpov34u0d0F8src1YsklTj+g6KUvEUrYY9W4x6d7yn15VqDcVabG0UTonPod/6jy
	RUI+mog8rk4U8fidO0rhDObmXK+Cxl0dyP1fjfGoD0Xsm7nRX+7BzUjcP1t/1A1DdzCBWaWmcMA
	g7ngOcd/7vXLBQZM7VK3gCAHcNu45eN0orPEZBcFe1mLJpRhnPkDb9JiqSPerdRNMo6BemECLR0
	yJETOmGqxixCc/chNA+PP6sMu0tOXjsWrPyFkzOYdHsQoDWk5pMbyfYohrqeA5J7d/qmyjfJ1L
X-Received: by 2002:a17:90a:d888:b0:35d:9d28:e897 with SMTP id 98e67ed59e1d1-35dc6ff670emr260259a91.28.1774980508136;
        Tue, 31 Mar 2026 11:08:28 -0700 (PDT)
Received: from cps-manycore-1.. ([143.248.136.81])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dbb8932ecsm1263160a91.5.2026.03.31.11.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 11:08:27 -0700 (PDT)
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
Subject: [PATCH v2] mm/vma: fix memory leak in __mmap_region()
Date: Tue, 31 Mar 2026 18:08:11 +0000
Message-ID: <20260331180811.1333348-1-rhkrqnwk98@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4515spd6qsr1ih5a4ppw8s5uywx1aqze
X-Rspamd-Queue-Id: A7DE74000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774980509-917286
X-HE-Meta: U2FsdGVkX1/ym2MUEZz9alWsve0qxQYVKfsn0TGYdp4VP3iDTl3E3yyyZSyDYWfQKg1D6Tb4cdmwH8/V1Dk9jfjWVM6PRSq22zM8les1C7VKb1Df/mFjC8FTAa9x9ej8jNezhPkoxNFPBirscGfmLVPVwrimqOXcT6HAI8fb6dTTPs8jPt3ttadpce4hrqnqKRBMtzfXJc7gyctjHcm5UEoDnaW0NFHkWDkFnd0PQVnDQruWs1xM/JMgRqHmw56VSxiz8bqI9YYyc3AwC8R/jh7A7jno2XgbBTIrHPxJPpHAqEMVyBfWaeldGS5pxybqbPqMsXwQefqGeDB4TqslxZtIioF0wrIOqGIyx8THxgtuXuuzg6uv59Z6CIfxo2GlRPOp1F4E6RUzJ44qIoyW5Xb9fzHfImQCJE8XNgsiT31CXnYyj4zVtKZKKTOmSmUAVEAK8dpLyf5d3OTPmUZ2bd0OZNSVnn3HDOmH9eh/3zuyZszWGib0c75uFe3w22qWeda93jeGQ4LgZsq+J9HZW88/KT/34KHhTT0WACDylQ/A5t5rla7HlvWI4tPmq4MERYM3L9FWSXRzvikjFNUShCYM4EIYUEySSPIJSR3JdefE2mmnAracuVO8RHtuvsirjNSHg+5lNs1ayia82OIA0Uyn7QeUcUITmwWpTPiSuvio4rAJO5J29bKvC3Jb4pKlvey5AES0g3b1do2wrpBrsYym5RCiQW5XTHvaau+/By+iSvZou2BU3qOtE0SBkgQT+EA3TI1eU5xAr7CGQlANtExJA1+719jhwRNdF4PS8RyfYDzRMdqau38xkQe40Fmfz/uOuxgeDjofnhzNIAu+Nz7OuLt2WTm2PVXVCh35l8ou4LMS5Dn8v9CrNMTLPrC6Sj5dmlWiargmGDJKfIZwwx8bkElafpFeeDcsd7oMKhS2XrB9zN2FCYZddqT8jJNXaqgrDSiiImxRzMlFYVX
 WsqmqKyw
 4LhhweaGSH6O03SxOp+y53KoEFokk49l4H60olAW70m7o+7EsYNakutctiWIahbDSn5mNS/aWSxdAmkFHr8nOHFJ+FMCx6Q0aJwmF9Edbbw24sYwwdp8n7tZcBxFuOXa2iBV0DCJhQrDt7xRLvBk+S5DL5USo8Fvbxbxw5BxBQvKuUyaXvzGQcGrvVgW9fnZUqSvYoNX+fE/SL5ZT9+C+W3yoUoUJoGxtWB9EoxlDnDvXEStHQ6sUFFgDT/9fq3JfkJQrCJw04ZDGwNsMI6eBWwUIYEaIfB7ygapmqj6Qpp3SG2Po5wSq1AuV4dB+kksCije2DJK0WtVk2xhXnGFKh0Xbh91jr4UjFsmfdSm4A38BIxaaOntNcgRVULBiBI/NZ3miM7shn+tPg74kp8al2BW092wZerGQpWp1eWEtwO8NxrvmVxTxj1jitUIjqXN02lH9jJ0BBdq5D6lC/o5rCGKrwkgwir/3jzJqv876mdMn6173yjnlDHO+7arjM/nC+1+2
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
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Sechang Lim <rhkrqnwk98@gmail.com>
-------
v2:
 - Drop redundant map.file NULL check (Lorenzo)
 - Add comment explaining the fput() (Lorenzo)
v1: https://lore.kernel.org/linux-mm/20260331121906.1301155-1-rhkrqnwk98@gmail.com/
 mm/vma.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/vma.c b/mm/vma.c
index be64f781a3aa..c8df5f561ad7 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2781,6 +2781,13 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 	if (map.charged)
 		vm_unacct_memory(map.charged);
 abort_munmap:
+	/*
+	 * This indicates that .mmap_prepare has set a new file, differing from
+	 * desc->vm_file. But since we're aborting the operation, only the
+	 * original file will be cleaned up. Ensure we clean up both.
+	 */
+	if (map.file_doesnt_need_get)
+		fput(map.file);
 	vms_abort_munmap_vmas(&map.vms, &map.mas_detach);
 	return error;
 }
-- 
2.43.0


