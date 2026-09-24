Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A87CC98310
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 06:55:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 989796B00A9; Thu, 24 Sep 2026 02:55:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 960E26B00AA; Thu, 24 Sep 2026 02:55:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89E6E6B00AB; Thu, 24 Sep 2026 02:55:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6220E6B00A9
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:55:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E04E212027C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:55:11 +0000 (UTC)
X-FDA: 85247744022.26.923129D
Received: from mta1.migadu.com (out-193.mta1.migadu.com [95.215.58.193])
	by imf05.hostedemail.com (Postfix) with ESMTP id 85B9A100002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:55:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VCGuzl9i;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.193 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790232910;
	b=LpIJwR2m4TeNnrUB0As8/lvdaF/OLoPttXpjwry1jnhgAe/2fzvaJOH8H7+AQHU9Ijbvw4
	PvVjGbETT6EzEZgcS4HcjiR3hGLCSLi9U5bfB9D65b5C7hrQbTRl0KoPJZymjckFiGLjO8
	qhS0fME8KNr2xca/+Uw4DUqZVAJivQ8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VCGuzl9i;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.193 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790232910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o+nxRNqk4OBgxEszkoR9fxbUBZaLO9aIivBieueXvh4=;
	b=BjHUllPNjLH3tUQrpbzAdtZmTDfZXrhel1xZ00WQC8SzfEpkLWcEVmvKTvb7caTvLHTwEN
	YXebVFpeF8jp7yzyLtGu63D1qXAOgGDnxQzpTYbVBnK/fRgL29I2s24O81DYxZ3GSCDELH
	FkCY5y9xg5N6lD3ZlPCKDEsQiz3s0Vo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=glcjkHLB5beTJmB/ldaaeqGVtDBeDFJY3It48SWNTvg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790232908; v=1; x=1790837708;
 b=VCGuzl9iUVZ6mhBP4R5KF86D/sJRFiw1q0l0bZDxpHoAP0LyPKkVf3RcPByfPfJWPuUVfko+
 MkJjcxj8ljgaPI2gaPAE4qa4giGe/j5U6VitbcA7VkHG23LBCy/NI4cXaij2DluLli5J1ocwzHB
 9QAIN0tKdNaDtGJv2VRbx2wM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 46fe3896734aaa3f;
	Thu, 24 Sep 2026 06:55:06 +0000
X-Mizu-Trace-ID: 46fe3896734aaa3f
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org,
	ljs@kernel.org,
	akpm@linux-foundation.org
Cc: harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	riel@surriel.com,
	syzkaller-bugs@googlegroups.com,
	vbabka@kernel.org,
	syzbot+c181d3198e98f8aef8b9@syzkaller.appspotmail.com
Subject: Re: [syzbot] [mm?] [ext4?] WARNING in __folio_set_anon
Date: Thu, 24 Sep 2026 14:54:58 +0800
Message-ID: <20260924065458.49698-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <6ab4ae75.80e1c6cc.1e8e5f.000d.GAE@google.com>
References: <6ab4ae75.80e1c6cc.1e8e5f.000d.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: hymgnppk8qfadwkyiqjkcwnjtohfm5q6
X-Rspam-User: 
X-Rspamd-Queue-Id: 85B9A100002
X-HE-Tag: 1790232909-599538
X-HE-Meta: U2FsdGVkX1/0ZHSAW4RB1TJDyblnV0qT0Q1o69STTh5GRN7AWujVSdNZbnW/bESmYvj0l/uQNEutBN5gsxqqYZiYJuBSWDjnqeaQCkWsrPi9lAR4gdRAiMQdHo0FsJHIlAa0IpcNZnjzdHM/46mnkIxzbINa075qcPa+1J8K5MVLE5WkWZ5mPrtYERbPWihai9JmSRCTLNPHY5UO6Wf1jMppm0O03gLS4zxYwSi+qEx+UaYkSqfYalYBG5xZ352GCVAdEWFSpe4OPERsCs1zNwoHm+r1P/P8GPbQYyoxhCQxCV5QNkLypSbJ388PtpPXHeoHgNexyQw/ZnjoODsW4ihXr/RPPNItbBSadue2RXnNvy9q/bX8QcaMf+ILvVHlRc3exOTux4c+P3bybiUZp6V0OdCviZ5zvhg8Bi9hA99+c66pduXu1FKBlnDusC0WRiVpu1CBVvOtalj9JLrJpxUJRT/OMkv5hJFj4IYJ6xRp+AAcNAhHXK0cn8ECJocVqZx7g+DMLLCLLwuOXaAQkgsjyO3aNUQ8Ypavu/jRlqsk0z3YOnZ4cjc74o8DqUjupKMk85eK4sUE7Qusdua4neQ1raEjOrGsGdGM7pT6s2MlMzMe1+Zkd+ZPfnw1B6e5fVZwYUL5lfzrDQpAphSM7gERUUu6qREdKHhB/xFoxQWL7QW1Qow6YdYUcfZODJjR55Ptl7apnuHyeRQzcmJUk8k7VQsXP5aOFFJtOx7JCSSnTNexG76u5tOH76BonKk1rN9JtPApQ+I2amKWlSePVpZDidtPeJVC1UOdxpjSHYDqZ5agFxr0o9nJj18u6l772eV/zjBLBuvccFEnf6sXAuCLLQegeqWdSAEGzwJxNYWyp6wHaFYdg7zYtUp72zOhWiu2azy6XNRTESpdrELkmvUkzWBovluhKTdl6pH19d9+KfnGwVkPRy7HeY/gXB2WErTtX5XOIa+ISLLXreA
 mwHuaOTs
 yPXHekxGymnAbRgbtwJTzcbxUst916uH4v8dQ/TEwNMPiId8UOvaC5gUQG1zsvR0ot13W3Q+nILDld6me2obZR6uIXMpRK1C7Ozin3c5W5OcDk3cJJ2ktdm6ZRXMzKnfER41cSagCs80GXlG6zYA0m2yfOdwMBZaEM72SM/uOhrhYrPJGw4BVH+qfYovb+mjfYe5bp+fMK4HH5d5PJW4SOdkT9fMfDdyj+yE6R/7dZamIA5IVvSfOVtucaiKSmZV+OY7dyl0Mu8kki8eJjmRaZE2FEWgjewKKHtFv6JPyh4+K6iSv4vUB8GtEf4g3Y+b2bR3U9Odvsh3hzx1g2P/2h+DQc8ZW5hUOdVzFox63vVjYEZwVS+EWT8KxG5F7G7/xpX3SKDlnIKs1FrxtcYNd7cSGvHo0JMtgwuuh9SxysB7Hf7XhbGydmXO/zhFLO4DwJLqJRnXq37XON/deTmDbFjfDP9PXQQfp9uZsJ1MV2gjFp7SE1vqq9d0cw80Mh8VMeuCbW2bgcbD33jcD2zJ6LFL1rN7l/q2pBXH6Dx6vGZAgvHQ5OWgY2+q+XU5V15pBdGfGwHJUyn/jLBtnzEjvbJ+OE/MIVDaAqgxbAqMfIxH1Ghgx3Eed13ucBJY5jyH6CVpBoJ1BPnOUcMilcKs+YbiJtrF54x+Nhh4KuaXHsESBRHONWPEDw0fFB+z21ywC8jhZu55bdO+S3EMgjysHz4eDvrEN+cVns/pBWUlORx2j6QyKnBLXRoUL4f1Ddgi6bCOArv1JUZqHAekZXWoYw2fYWPpsTrFTTquatiikSZotEJkd3dJ66k28jJ8cZy4eWAtS3JRL9HzATF3o7yuDZoSs52b6NJExs+4l1P6zeyXg28brhowFWtxalzaD1JVt0Hfh8xnMyE8FJXEKsNvRKPCnihE3rmYvrYfKBb/inyLuz4XP0wfWYdoSjBsMvMv3dAKXRVoopHuNbFsn0MKR911KwBkF
 sFR+YHYG
 jUVAEXQuP3Se3fBe+Gfr+YtteGeaBTxyNPQNkLWuhQRDExfJpHoj+nA3fQcRo2wE+TZcO0LslzjTvUQObBd7dgKk5ZvvCmj7FTYeWxiELeY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Sep 23, 2026 at 10:00:37PM -0700, syzbot wrote:
>Hello,
>
>syzbot found the following issue on:
>
>HEAD commit:    38872197cae2 Merge branch 'for-next/fixes' into for-kernelci
>git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
>console output: https://syzkaller.appspot.com/x/log.txt?x=17a44d25580000
>kernel config:  https://syzkaller.appspot.com/x/.config?x=56ed23170c168d4c
>dashboard link: https://syzkaller.appspot.com/bug?extid=c181d3198e98f8aef8b9
>compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
>userspace arch: arm64
>syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16a36515580000
>C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16dcf4c9580000

Looking at the repro, emm ... the repro maps an O_RDONLY /dev/zero fd with
MAP_SHARED | PROT_READ. do_mmap() clears VM_SHARED and VM_MAYWRITE, so
mmap_zero_prepare() marks the VMA anonymous. MADV_COLLAPSE then allocates
a new folio and adds an anon rmap, hitting the warning in
linear_anon_page_index().

Can an anonymous VMA without VM_MAYWRITE legitimately have an anon rmap?

Cheers, Lance

>Downloadable assets:
>disk image: https://storage.googleapis.com/syzbot-assets/c5963fdd6790/disk-38872197.raw.xz
>vmlinux: https://storage.googleapis.com/syzbot-assets/a8c2cab00c45/vmlinux-38872197.xz
>kernel image: https://storage.googleapis.com/syzbot-assets/bde15d173380/Image-38872197.gz.xz
>mounted in repro: https://storage.googleapis.com/syzbot-assets/c81cc2849c33/mount_3.gz
>  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=11cb4405580000)
>
>IMPORTANT: if you fix the issue, please add the following tag to the commit:
>Reported-by: syzbot+c181d3198e98f8aef8b9@syzkaller.appspotmail.com
>
>------------[ cut here ]------------
>WARNING: ./include/linux/pagemap.h:1130 at vma_flags_is_cow_mapping include/linux/mm.h:2315 [inline], CPU#1: syz.0.17/4884
>WARNING: ./include/linux/pagemap.h:1130 at vma_is_cow_mapping include/linux/mm.h:2329 [inline], CPU#1: syz.0.17/4884
>WARNING: ./include/linux/pagemap.h:1130 at linear_anon_page_index include/linux/pagemap.h:1130 [inline], CPU#1: syz.0.17/4884
>WARNING: ./include/linux/pagemap.h:1130 at __folio_set_anon+0x240/0x298 mm/rmap.c:1491, CPU#1: syz.0.17/4884
>Modules linked in:
>CPU: 1 UID: 0 PID: 4884 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT 
>Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/14/2026
>pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
>pc : linear_anon_page_index include/linux/mm.h:2315 [inline]
>pc : __folio_set_anon+0x240/0x298 mm/rmap.c:1491
>lr : vma_flags_is_cow_mapping include/linux/mm.h:2315 [inline]
>lr : vma_is_cow_mapping include/linux/mm.h:2329 [inline]
>lr : linear_anon_page_index include/linux/pagemap.h:1130 [inline]
>lr : __folio_set_anon+0x240/0x298 mm/rmap.c:1491
>sp : ffff800095456de0
>x29: ffff800095456df0 x28: 0000000000020000 x27: 1fffe00019e1007c
>x26: ffff0000cf0803e0 x25: 0000000000020000 x24: dfff800000000000
>x23: 0000000020000000 x22: 0000000000000000 x21: 00000000200020d1
>x20: ffff0000cf0803c0 x19: fffffdffc3c10000 x18: 00000000ffffffff
>x17: 0000000000000003 x16: ffff800088b97000 x15: ffff80008a849000
>x14: 000000000062064d x13: 0000000000000001 x12: 0000000000000000
>x11: 0000000000000000 x10: 000000000000003d x9 : 0000000000000000
>x8 : 0000000000000000 x7 : ffff800080c16020 x6 : 0000000000000000
>x5 : 0000000000000000 x4 : 0000000000000001 x3 : ffff800080ab2d0c
>x2 : 0000000000000000 x1 : ffff0000d07a1d80 x0 : 0000000000000000
>Call trace:
> vma_flags_is_cow_mapping include/linux/mm.h:2315 [inline] (P)
> vma_is_cow_mapping include/linux/mm.h:2329 [inline] (P)
> linear_anon_page_index include/linux/pagemap.h:1130 [inline] (P)
> __folio_set_anon+0x240/0x298 mm/rmap.c:1491 (P)
> folio_add_new_anon_rmap+0x1a8/0x10ac mm/rmap.c:1663
> map_anon_folio_pmd_nopf+0xfc/0x160 mm/huge_memory.c:1365
> collapse_huge_page mm/khugepaged.c:1438 [inline]
> mthp_collapse mm/khugepaged.c:1532 [inline]
> collapse_scan_pmd mm/khugepaged.c:1781 [inline]
> collapse_single_pmd+0x21e0/0x3748 mm/khugepaged.c:2797
> madvise_collapse+0x2a4/0x6f4 mm/khugepaged.c:3231
> madvise_vma_behavior+0x3e8/0x339c mm/madvise.c:1372
> madvise_walk_vmas+0x4c8/0x9bc mm/madvise.c:1721
> madvise_do_behavior+0x5f0/0x7c0 mm/madvise.c:1916
> do_madvise+0x28c/0x2f0 mm/madvise.c:2014
> __do_sys_madvise mm/madvise.c:2023 [inline]
> __se_sys_madvise mm/madvise.c:2021 [inline]
> __arm64_sys_madvise+0xac/0xc8 mm/madvise.c:2021
> __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
> invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
> el0_svc_common+0xec/0x23c arch/arm64/kernel/syscall.c:121
> do_el0_svc+0x4c/0x5c arch/arm64/kernel/syscall.c:140
> el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:758
> el0t_64_sync_handler+0x44/0x104 arch/arm64/kernel/entry-common.c:777
> el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:590
>irq event stamp: 1412
>hardirqs last  enabled at (1411): [<ffff8000869b7264>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:210 [inline]
>hardirqs last  enabled at (1411): [<ffff8000869b7264>] _raw_spin_unlock_irqrestore+0x38/0x98 kernel/locking/spinlock.c:221
>hardirqs last disabled at (1412): [<ffff800086991a8c>] el1_brk64+0x20/0x54 arch/arm64/kernel/entry-common.c:445
>softirqs last  enabled at (1120): [<ffff80008013c050>] local_bh_enable include/linux/bottom_half.h:33 [inline]
>softirqs last  enabled at (1120): [<ffff80008013c050>] put_cpu_fpsimd_context arch/arm64/kernel/fpsimd.c:251 [inline]
>softirqs last  enabled at (1120): [<ffff80008013c050>] fpsimd_restore_current_state+0x39c/0x9c8 arch/arm64/kernel/fpsimd.c:1797
>softirqs last disabled at (1118): [<ffff80008013bcf8>] local_bh_disable include/linux/bottom_half.h:20 [inline]
>softirqs last disabled at (1118): [<ffff80008013bcf8>] get_cpu_fpsimd_context arch/arm64/kernel/fpsimd.c:234 [inline]
>softirqs last disabled at (1118): [<ffff80008013bcf8>] fpsimd_restore_current_state+0x44/0x9c8 arch/arm64/kernel/fpsimd.c:1790
>---[ end trace 0000000000000000 ]---
>
>
>---
>This report is generated by a bot. It may contain errors.
>See https://goo.gl/tpsmEJ for more information about syzbot.
>syzbot engineers can be reached at syzkaller@googlegroups.com.
>
>syzbot will keep track of this issue. See:
>https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
>If the report is already addressed, let syzbot know by replying with:
>#syz fix: exact-commit-title
>
>If you want syzbot to run the reproducer, reply with:
>#syz test: git://repo/address.git branch-or-commit-hash
>If you attach or paste a git patch, syzbot will apply it before testing.
>
>If you want to overwrite report's subsystems, reply with:
>#syz set subsystems: new-subsystem
>(See the list of subsystem names on the web dashboard)
>
>If the report is a duplicate of another one, reply with:
>#syz dup: exact-subject-of-another-report
>
>If you want to undo deduplication, reply with:
>#syz undup
>

