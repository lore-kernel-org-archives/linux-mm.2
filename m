Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19063CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 23:06:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EFA16B008A; Tue, 19 May 2026 19:06:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 379046B008C; Tue, 19 May 2026 19:06:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 268906B0092; Tue, 19 May 2026 19:06:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0B9CF6B008A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 19:06:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A9692C381D
	for <linux-mm@kvack.org>; Tue, 19 May 2026 23:06:22 +0000 (UTC)
X-FDA: 84785705004.23.B985DAB
Received: from mail-oo1-f79.google.com (mail-oo1-f79.google.com [209.85.161.79])
	by imf21.hostedemail.com (Postfix) with ESMTP id 068F51C0015
	for <linux-mm@kvack.org>; Tue, 19 May 2026 23:06:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of 37OwMagkbAFEBHI3t44xAt881w.z77z4xDBxAv76Cx6C.v75@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=37OwMagkbAFEBHI3t44xAt881w.z77z4xDBxAv76Cx6C.v75@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779231981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=jEyGoxD+7Y7byuEco+I/Cx6c6i9jfy8hRRVOEI++ce4=;
	b=CXLkFFYcBNGDiwFZGvouzNgsGtuPpAJFmPEXufRyaQIw1QR/i1ZfNoHnZlYoImUpkSB+lL
	u7xT8/L2eLb7wkT6F6axAOLZFUyswgD40XSJlCTOVmsA7Jcn0JxiCPOvz5Al658ru4+3Up
	fon+ZESxxnLFwXbEfDzS+E58T6VZnoQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of 37OwMagkbAFEBHI3t44xAt881w.z77z4xDBxAv76Cx6C.v75@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=37OwMagkbAFEBHI3t44xAt881w.z77z4xDBxAv76Cx6C.v75@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779231981; a=rsa-sha256;
	cv=none;
	b=2qj31hiZeu4NFT4pSWk4vbev7kCRlLA1RPyHUMBkp3czkWQA3SEAOgL7nW5ZUPdA+uISAT
	eGpVAGLsirlxUMk5vgvRQ49YHmCE+yGMVaOjaeOaa+88+ms1/lTBX0nvxaCFcfxXCwsv9F
	CFXpEHZ5TYmI5RQnJtZMi18WDPTURLs=
Received: by mail-oo1-f79.google.com with SMTP id 006d021491bc7-69b944f3c0cso9816519eaf.0
        for <linux-mm@kvack.org>; Tue, 19 May 2026 16:06:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779231980; x=1779836780;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jEyGoxD+7Y7byuEco+I/Cx6c6i9jfy8hRRVOEI++ce4=;
        b=fsubiKZFf5KVdezcnWUl7QrlVOGc16mw/mVlQyf4onC1UM/fnu4k2YweRWtTZWqjcT
         0exuuxWrYDxJXReig+ekRXa0OgZRdBVcSWx5s9dl3TG05n6R4ho5RC2iBLdBQEmQh47o
         StRPDZF5In36oh2TU1Z4WCVzT1dVzWc34Bmcmz6Sk05RNKy40R1UFRo2dm5y9OWCmuHW
         bmrsIxV8frIOog5296cTXUQwedpjanx9QWhekhTvvLuQKaJXqf4YO038agVPxtLO5XRP
         MIGH9AGE/nvob0rk6BOwRC2zHp2opqCY1oCq+gv3IIby5+YVYjFqK+5fNmWzPID75P8o
         7Hvg==
X-Forwarded-Encrypted: i=1; AFNElJ8A+LYP/MpPKlqgz11h73xW4+x0Kh15W57S99Lhuk4lxPhrVO+8HsQu4JWjeEuuQpQNftpQxEU3mw==@kvack.org
X-Gm-Message-State: AOJu0YzVbZ6ZojCaHqEvnCIztwDskXUV7Lzc2wSu9avKYUdDKIEU2U+W
	snfdKxSGDz1dbmnAniOzzosgB0xHUPlQMokx8dpVhHBBzbsRk8jmSYGNadYeA16CyNneA3pOHOH
	7Hh5600ZYEkqFO+aGZix5zzjM3WBzBYXyBF7TmaiieypG3WqaieX20oCmGvw=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:16a6:b0:695:818c:e564 with SMTP id
 006d021491bc7-69c94319f7emr13117581eaf.26.1779231980125; Tue, 19 May 2026
 16:06:20 -0700 (PDT)
Date: Tue, 19 May 2026 16:06:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a0cecec.a70a0220.1a69d3.0018.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in folio_lruvec_relock_irqsave
From: syzbot <syzbot+c6d89774c5884660f0db@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	bhe@redhat.com, chrisl@kernel.org, kasong@tencent.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, nphamcs@gmail.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	syzkaller-bugs@googlegroups.com, weixugc@google.com, youngjun.park@lge.com, 
	yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 068F51C0015
X-Rspamd-Server: rspam06
X-Stat-Signature: zm4qr66c39pb3hy34xb9nirggupwx5cj
X-HE-Tag: 1779231980-609185
X-HE-Meta: U2FsdGVkX182+j/90ZiBETkrN3AuW62aeDpGiwFSaQ7DOyoB2hqijcBGSj8BHK9z6YZtI3E71Ml729QwniSVn2oxrAq/gDPj8QJ/wKtWdGNFuKYTP3x3qhrxgR9eOdLNZfu3M7tgSPs1gZsZvLHVQTa8Eo3+DWI6ATcoiizK1VRm6bbh+F/y/7n9sSy7ezzeYwr4ZDtJYP9/1k4ELTK4uc9ZCcMx+u7R6gMTxLndzgXCP52cyzZxsLQuwJrk1QzAo/25yyfsWYZzyZMU5ayCS/fYezWNjzCfoSxaIRqMN6M+YRJv/WF4TVVNoMA+uXyOWrl14dpzpYm9hS63svjgaMlnwBc3ovbydAAIXGoV0q0zKBKsZHCOH7vuHmmzjCHnHvV7ZJf6VPwE/7jYuO2lo7l8FZKrJb12/aQLxlhMAlec5akKL+L46qnbjtoYTw1y7QF4T15NSarCykr2X6X8WgPUXweRtz71+qg246KAQml0KbIpvedO8BRfVtpjIB/Ju6sQ+IpGSChh1qFcltZJJgvXYGEwPJvVDYYUfMCFJxcLCQtck/fnrmY83uYwYYN4TLjlpUxONvPRjLv29SYLhevzGAxg2UkufJqaT3AqCmJQrIpGuB99+t/XNve/K2hOBCPhWEYXxdKZevikkq8UrRCAle6Vfkq9OxgRl+w90q5QfdKG/T8Rh1xnLj20NARTlkBO+SdrkVhvSZyIffIwuU2FuFCY4fFTluLFLcHsA3czXMEFCFvZIFJgprRw/l9OtjxaL29lOaqswq1cfpAPUN4qZT9pC6ZSYlIxGM/htapH35M1MXvVNOxB9KvhkFH7jK4o1eVtZK7JenyfNxXI5uZO1IfQKPbBygOdaLu3LtJgjdr+F+4dOIKPf21Z3FkmsPlNyqQRXYQQtzut9knSS3UkP6qpt4RKTSZ2ObMMqp7Og/qTmhTO3qMEXZyBzZxgkzLxTcwTjm+AjUv7Wyr
 cQdvS11V
 6e3MMcN6+8EUceO8RYyLQXIu/9TSRrppi9vq/tbzuaszRO6Mp+ld8VFCdm3OkfK4OC0tJ1TzrDcTnWcfZPKem1pqjuIeXqfmutZyTiH9nj/vKI9Gip0UOvTqhXquOCl1y0ESRA0nbbxf/+Hi6uzZUNC3I1sqkUjwqTr/E6AO+UlV9zN54pkKiX2nv53r73m1sSc/H8kTu2Zabcf6HjkG5V/+M+FJH1B4OGjNe6zuRPgKkb+/Pb1hilcVS+P2Pac66pbUKgL3/ethIcvxuDU9BNkXe1zDU1zlmBScYu6WlD7eeZhNGBb103YjwTdzSjp4jvOtrkUCmszjfK/dA6+OqmIHso1gsyr+7Iydjh7NBByoxSnLIwUggbdYHJZNYtKExmExOg3kYpkB88dXvYe4RSarWEtvN//UECW4kiejEM5aq800UdQazRcAjmzaIDW8xAELfXd+ks3Kb3ZrRNUD4esYrxYInB3BWRwR0YGdAWseXONb0X3ek2edbUKrSRlN1qz0EJDiDqPoE8r9PenqxcroO5A89TjkEiPAXG5VUJd1uLU1QHVbNVlHeuvLDgttb4bil2r5ixvtDUhl2bySMoh3HESbiZAT7dya7dgNPAOVC53O+B7uIqyxzR8LWwmiJkJeRU+qrGQgU+B5WTMoTwIdPEP7trwPAYWnnFD53pS273rWP25evsxHJInB3NgT9RctpAK0FKjSOsPasygIAZSR/9h6wbF6/bZn2RQzvyIWRcgsNCFH4YgvQwyTogkSTzGIjwrVjUb8kF+tF0YZtsRv4IfEnGyiQT8x61xnSlvAUqbU209Yp0Vu8ldmJmfE1q1uRd26jIdSeQj/PSjpBeoIAT2aY6gofOevdPasajnfg6TL6HHgzCn/Cc05D0CUI0D/87pzA95RCep9RnNAyTTt5j5LLnCsjWIGPtVnd/jvaf6x91DwNJS8Jgyh1gn/YPQZX5MiIvefKadB5MBUFzTCJ9T8m
 ZetEhgdi
 DLHyUu83xR69zlL+En2MUZD1A1JRHrvJkiYJrfCSqLFtVPkqulddaJ9YpNKdxtO2X3MOW70zmkWtqZZWguQW1T1WLYGjo2sHClTEdL1w2fVPEJ4wnSTVk+QEGpv6TMTMU7zFxQv0ZAnVvTrRQfEn9BhUl1C/K4tNKuLoNUXsmOO12+cAfqB3X0TpMMZbCTkICqoqEB7QEBJlCYVxgp4k9hVq9GMVlvx8ShLXIxJjkZ4v0gk6JXL8JLG0xHCAv+lCeZFSyOJudSnfEOxyg8djE6kpRNMH80MIJc/cBxFyRpf1rE44tHc/A/eDy+02Rs9rzI+CsnP/Xcg//fA7RCYr0kFHUiAegc/3jp1VM/0kMHWAyHxo4LIhjgfuIU4twJ37fxKtmbljaolUkwvuvESEsZA/us7fav4Uo14fGKAK0iiWNTOONjQEXaDtBO6R1flWRSUupaAuj5cBH7jnv0x4cktXsIw1eeFyu0dK9003kU+DqO0DU+9dGrsyvjSQUZvq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    5cbb61bf4168 arm64/fpsimd: ptrace: zero target's fpsimd_st..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=1068e8a6580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a834c6344141a58b
dashboard link: https://syzkaller.appspot.com/bug?extid=c6d89774c5884660f0db
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/04156ec16593/disk-5cbb61bf.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6bfa041e2c79/vmlinux-5cbb61bf.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a92d82d8a79e/Image-5cbb61bf.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c6d89774c5884660f0db@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: ./include/linux/memcontrol.h:380 at obj_cgroup_memcg include/linux/memcontrol.h:380 [inline], CPU#1: dhcpcd/4655
WARNING: ./include/linux/memcontrol.h:380 at folio_memcg include/linux/memcontrol.h:434 [inline], CPU#1: dhcpcd/4655
WARNING: ./include/linux/memcontrol.h:380 at folio_matches_lruvec include/linux/memcontrol.h:1501 [inline], CPU#1: dhcpcd/4655
WARNING: ./include/linux/memcontrol.h:380 at folio_lruvec_relock_irqsave+0x320/0x3a8 include/linux/memcontrol.h:1523, CPU#1: dhcpcd/4655
Modules linked in:
CPU: 1 UID: 0 PID: 4655 Comm: dhcpcd Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/18/2026
pstate: 834000c5 (Nzcv daIF +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : obj_cgroup_memcg include/linux/memcontrol.h:380 [inline]
pc : folio_memcg include/linux/memcontrol.h:434 [inline]
pc : folio_matches_lruvec include/linux/memcontrol.h:1501 [inline]
pc : folio_lruvec_relock_irqsave+0x320/0x3a8 include/linux/memcontrol.h:1523
lr : obj_cgroup_memcg include/linux/memcontrol.h:380 [inline]
lr : folio_memcg include/linux/memcontrol.h:434 [inline]
lr : folio_matches_lruvec include/linux/memcontrol.h:1501 [inline]
lr : folio_lruvec_relock_irqsave+0x320/0x3a8 include/linux/memcontrol.h:1523
sp : ffff8000964373a0
x29: ffff8000964373a0 x28: 1fffffbff86a96a0 x27: 00000000f5000000
x26: ffff0000c1939b00 x25: 1ffff00012c86e97 x24: dfff800000000000
x23: 0000000000000000 x22: ffff0000c1862980 x21: ffff8000964374e0
x20: fffffdffc354b500 x19: ffff8000964374b8 x18: 00000000ffffffff
x17: ffff80008a0cdc80 x16: ffff80008a3b24b8 x15: ffff0000cb5c0b50
x14: ffff0000cb5c0b30 x13: 0000000000000001 x12: 0000000000000000
x11: 0000000000000000 x10: 0000000000ff0100 x9 : 0000000000000001
x8 : 0000000000000000 x7 : ffff800080bce9cc x6 : 0000000000000000
x5 : 0000000000000030 x4 : 0000000000000000 x3 : ffff800080941e90
x2 : 0000000000000000 x1 : ffff0000cb5c0000 x0 : 0000000000000000
Call trace:
 obj_cgroup_memcg include/linux/memcontrol.h:380 [inline] (P)
 folio_memcg include/linux/memcontrol.h:434 [inline] (P)
 folio_matches_lruvec include/linux/memcontrol.h:1501 [inline] (P)
 folio_lruvec_relock_irqsave+0x320/0x3a8 include/linux/memcontrol.h:1523 (P)
 __page_cache_release+0xa8/0x860 mm/swap.c:77
 folios_put_refs+0x57c/0x8dc mm/swap.c:993
 free_pages_and_swap_cache+0x238/0x3e0 mm/swap_state.c:401
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0xf0/0x33c mm/mmu_gather.c:424
 tlb_finish_mmu+0xf4/0x228 mm/mmu_gather.c:549
 exit_mmap+0x3d0/0xaf8 mm/mmap.c:1313
 __mmput+0xe4/0x2f0 kernel/fork.c:1178
 mmput+0x70/0xa8 kernel/fork.c:1201
 exit_mm+0x134/0x1e8 kernel/exit.c:581
 do_exit+0x518/0x1a6c kernel/exit.c:963
 do_group_exit+0x194/0x22c kernel/exit.c:1117
 __do_sys_exit_group kernel/exit.c:1128 [inline]
 __se_sys_exit_group kernel/exit.c:1126 [inline]
 pid_child_should_wake+0x0/0x110 kernel/exit.c:1126
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:140
 el0_svc+0x60/0x25c arch/arm64/kernel/entry-common.c:723
 el0t_64_sync_handler+0x48/0x148 arch/arm64/kernel/entry-common.c:742
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:594
irq event stamp: 1602
hardirqs last  enabled at (1601): [<ffff800086744048>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:178 [inline]
hardirqs last  enabled at (1601): [<ffff800086744048>] _raw_spin_unlock_irqrestore+0x38/0x98 kernel/locking/spinlock.c:198
hardirqs last disabled at (1602): [<ffff800086743e78>] __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:130 [inline]
hardirqs last disabled at (1602): [<ffff800086743e78>] _raw_spin_lock_irqsave+0x2c/0x7c kernel/locking/spinlock.c:166
softirqs last  enabled at (1134): [<ffff800084ab928c>] local_bh_enable+0x10/0x34 include/linux/bottom_half.h:32
softirqs last disabled at (1132): [<ffff800084ab9258>] local_bh_disable+0x10/0x34 include/linux/bottom_half.h:19
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: ./include/linux/memcontrol.h:380 at obj_cgroup_memcg include/linux/memcontrol.h:380 [inline], CPU#1: dhcpcd/4655
WARNING: ./include/linux/memcontrol.h:380 at folio_memcg include/linux/memcontrol.h:434 [inline], CPU#1: dhcpcd/4655
WARNING: ./include/linux/memcontrol.h:380 at folio_matches_lruvec include/linux/memcontrol.h:1501 [inline], CPU#1: dhcpcd/4655
WARNING: ./include/linux/memcontrol.h:380 at lruvec_del_folio include/linux/mm_inline.h:383 [inline], CPU#1: dhcpcd/4655
WARNING: ./include/linux/memcontrol.h:380 at __page_cache_release+0x6ec/0x860 mm/swap.c:78, CPU#1: dhcpcd/4655
Modules linked in:
CPU: 1 UID: 0 PID: 4655 Comm: dhcpcd Tainted: G        W           syzkaller #0 PREEMPT 
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/18/2026
pstate: 834000c5 (Nzcv daIF +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : obj_cgroup_memcg include/linux/memcontrol.h:380 [inline]
pc : folio_memcg include/linux/memcontrol.h:434 [inline]
pc : folio_matches_lruvec include/linux/memcontrol.h:1501 [inline]
pc : lruvec_del_folio include/linux/mm_inline.h:383 [inline]
pc : __page_cache_release+0x6ec/0x860 mm/swap.c:78
lr : obj_cgroup_memcg include/linux/memcontrol.h:380 [inline]
lr : folio_memcg include/linux/memcontrol.h:434 [inline]
lr : folio_matches_lruvec include/linux/memcontrol.h:1501 [inline]
lr : lruvec_del_folio include/linux/mm_inline.h:383 [inline]
lr : __page_cache_release+0x6ec/0x860 mm/swap.c:78
sp : ffff800096437400
x29: ffff800096437420 x28: 1fffffbff86a96a0 x27: dfff800000000000
x26: 1fffffbff86a96a1 x25: 0000000000000000 x24: ffff0000c1862980
x23: ffff0000c18c0c08 x22: 0000000000000000 x21: 1fffe00018318181
x20: fffffdffc354b508 x19: fffffdffc354b500 x18: 00000000ffffffff
x17: ffff80008a0cdc80 x16: ffff80008a3b24b8 x15: ffff0000cb5c0b50
x14: ffff0000cb5c0b30 x13: 0000000000000001 x12: 0000000000000000
x11: 0000000000000000 x10: 0000000000ff0100 x9 : 0000000000000001
x8 : 0000000000000000 x7 : ffff800080bce9cc x6 : 0000000000000000
x5 : 0000000000000030 x4 : 0000000000000000 x3 : ffff800080940708
x2 : 0000000000000000 x1 : ffff0000cb5c0000 x0 : 0000000000000000
Call trace:
 obj_cgroup_memcg include/linux/memcontrol.h:380 [inline] (P)
 folio_memcg include/linux/memcontrol.h:434 [inline] (P)
 folio_matches_lruvec include/linux/memcontrol.h:1501 [inline] (P)
 lruvec_del_folio include/linux/mm_inline.h:383 [inline] (P)
 __page_cache_release+0x6ec/0x860 mm/swap.c:78 (P)
 folios_put_refs+0x57c/0x8dc mm/swap.c:993
 free_pages_and_swap_cache+0x238/0x3e0 mm/swap_state.c:401
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0xf0/0x33c mm/mmu_gather.c:424
 tlb_finish_mmu+0xf4/0x228 mm/mmu_gather.c:549
 exit_mmap+0x3d0/0xaf8 mm/mmap.c:1313
 __mmput+0xe4/0x2f0 kernel/fork.c:1178
 mmput+0x70/0xa8 kernel/fork.c:1201
 exit_mm+0x134/0x1e8 kernel/exit.c:581
 do_exit+0x518/0x1a6c kernel/exit.c:963
 do_group_exit+0x194/0x22c kernel/exit.c:1117
 __do_sys_exit_group kernel/exit.c:1128 [inline]
 __se_sys_exit_group kernel/exit.c:1126 [inline]
 pid_child_should_wake+0x0/0x110 kernel/exit.c:1126
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:140
 el0_svc+0x60/0x25c arch/arm64/kernel/entry-common.c:723
 el0t_64_sync_handler+0x48/0x148 arch/arm64/kernel/entry-common.c:742
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:594
irq event stamp: 1602
hardirqs last  enabled at (1601): [<ffff800086744048>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:178 [inline]
hardirqs last  enabled at (1601): [<ffff800086744048>] _raw_spin_unlock_irqrestore+0x38/0x98 kernel/locking/spinlock.c:198
hardirqs last disabled at (1602): [<ffff800086743e78>] __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:130 [inline]
hardirqs last disabled at (1602): [<ffff800086743e78>] _raw_spin_lock_irqsave+0x2c/0x7c kernel/locking/spinlock.c:166
softirqs last  enabled at (1134): [<ffff800084ab928c>] local_bh_enable+0x10/0x34 include/linux/bottom_half.h:32
softirqs last disabled at (1132): [<ffff800084ab9258>] local_bh_disable+0x10/0x34 include/linux/bottom_half.h:19
---[ end trace 0000000000000000 ]---

=====================================
WARNING: bad unlock balance detected!
syzkaller #0 Tainted: G        W          
-------------------------------------
dhcpcd/4655 is trying to release lock (rcu_read_lock) at:
[<ffff800080941c44>] rcu_lock_release+0x10/0x38 include/linux/rcupdate.h:309
but there are no more locks to release!

other info that might help us debug this:
1 lock held by dhcpcd/4655:
 #0: ffff0000d1fb0d78 (&mm->mmap_lock){++++}-{4:4}, at: mmap_write_lock include/linux/mmap_lock.h:536 [inline]
 #0: ffff0000d1fb0d78 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap+0x228/0xaf8 mm/mmap.c:1308

stack backtrace:
CPU: 1 UID: 0 PID: 4655 Comm: dhcpcd Tainted: G        W           syzkaller #0 PREEMPT 
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/18/2026
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 print_unlock_imbalance_bug+0xf4/0xfc kernel/locking/lockdep.c:5298
 __lock_release kernel/locking/lockdep.c:-1 [inline]
 lock_release+0x1dc/0x3b0 kernel/locking/lockdep.c:5889
 rcu_lock_release+0x2c/0x38 include/linux/rcupdate.h:310
 rcu_read_unlock include/linux/rcupdate.h:869 [inline]
 lruvec_unlock_irqrestore include/linux/memcontrol.h:1493 [inline]
 folios_put_refs+0x7a4/0x8dc mm/swap.c:1000
 free_pages_and_swap_cache+0x238/0x3e0 mm/swap_state.c:401
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0xf0/0x33c mm/mmu_gather.c:424
 tlb_finish_mmu+0xf4/0x228 mm/mmu_gather.c:549
 exit_mmap+0x3d0/0xaf8 mm/mmap.c:1313
 __mmput+0xe4/0x2f0 kernel/fork.c:1178
 mmput+0x70/0xa8 kernel/fork.c:1201
 exit_mm+0x134/0x1e8 kernel/exit.c:581
 do_exit+0x518/0x1a6c kernel/exit.c:963
 do_group_exit+0x194/0x22c kernel/exit.c:1117
 __do_sys_exit_group kernel/exit.c:1128 [inline]
 __se_sys_exit_group kernel/exit.c:1126 [inline]
 pid_child_should_wake+0x0/0x110 kernel/exit.c:1126
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:140
 el0_svc+0x60/0x25c arch/arm64/kernel/entry-common.c:723
 el0t_64_sync_handler+0x48/0x148 arch/arm64/kernel/entry-common.c:742
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:594
------------[ cut here ]------------
WARNING: kernel/rcu/tree_plugin.h:443 at __rcu_read_unlock+0x98/0x104 kernel/rcu/tree_plugin.h:445, CPU#1: dhcpcd/4655
Modules linked in:
CPU: 1 UID: 0 PID: 4655 Comm: dhcpcd Tainted: G        W           syzkaller #0 PREEMPT 
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/18/2026
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : __rcu_read_unlock+0x98/0x104 kernel/rcu/tree_plugin.h:445
lr : rcu_read_unlock include/linux/rcupdate.h:871 [inline]
lr : lruvec_unlock_irqrestore include/linux/memcontrol.h:1493 [inline]
lr : folios_put_refs+0x7a8/0x8dc mm/swap.c:1000
sp : ffff800096437440
x29: ffff800096437450 x28: ffff800096437778 x27: ffff8000964376b8
x26: 000000000000001e x25: fffffdffc76e19c0 x24: ffff8000964375c0
x23: fffffdffc76e19f4 x22: ffff800096437778 x21: dfff800000000000
x20: 1fffe000196b8090 x19: ffff0000cb5c0484 x18: 1fffe00035c25820
x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
x14: 0000000000000000 x13: 0000000000000001 x12: 0000000000000000
x11: 000000000000065a x10: 0000000000000003 x9 : 0000000000000007
x8 : 0000000000000003 x7 : 0000000000000000 x6 : ffff8000804886d0
x5 : 0000000000000000 x4 : 0000000000000000 x3 : ffff80008048c3e0
x2 : 0000000100000000 x1 : ffff0000cb5c0000 x0 : ffff0000cb5c0000
Call trace:
 __rcu_read_unlock+0x98/0x104 kernel/rcu/tree_plugin.h:445 (P)
 rcu_read_unlock include/linux/rcupdate.h:871 [inline]
 lruvec_unlock_irqrestore include/linux/memcontrol.h:1493 [inline]
 folios_put_refs+0x7a8/0x8dc mm/swap.c:1000
 free_pages_and_swap_cache+0x238/0x3e0 mm/swap_state.c:401
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0xf0/0x33c mm/mmu_gather.c:424
 tlb_finish_mmu+0xf4/0x228 mm/mmu_gather.c:549
 exit_mmap+0x3d0/0xaf8 mm/mmap.c:1313
 __mmput+0xe4/0x2f0 kernel/fork.c:1178
 mmput+0x70/0xa8 kernel/fork.c:1201
 exit_mm+0x134/0x1e8 kernel/exit.c:581
 do_exit+0x518/0x1a6c kernel/exit.c:963
 do_group_exit+0x194/0x22c kernel/exit.c:1117
 __do_sys_exit_group kernel/exit.c:1128 [inline]
 __se_sys_exit_group kernel/exit.c:1126 [inline]
 pid_child_should_wake+0x0/0x110 kernel/exit.c:1126
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:140
 el0_svc+0x60/0x25c arch/arm64/kernel/entry-common.c:723
 el0t_64_sync_handler+0x48/0x148 arch/arm64/kernel/entry-common.c:742
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:594
irq event stamp: 1631
hardirqs last  enabled at (1631): [<ffff8000803bd554>] raw_spin_rq_unlock_irq kernel/sched/sched.h:1644 [inline]
hardirqs last  enabled at (1631): [<ffff8000803bd554>] finish_lock_switch+0x160/0x204 kernel/sched/core.c:5124
hardirqs last disabled at (1630): [<ffff80008672f800>] __schedule+0x308/0x2d24 kernel/sched/core.c:7042
softirqs last  enabled at (1628): [<ffff800080309064>] softirq_handle_end kernel/softirq.c:468 [inline]
softirqs last  enabled at (1628): [<ffff800080309064>] handle_softirqs+0xbc4/0xd34 kernel/softirq.c:650
softirqs last disabled at (1605): [<ffff8000800204b0>] __do_softirq+0x14/0x20 kernel/softirq.c:656
---[ end trace 0000000000000000 ]---
BUG: sleeping function called from invalid context at mm/mmu_gather.c:142
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 4655, name: dhcpcd
preempt_count: 0, expected: 0
RCU nest depth: -1, expected: 0
INFO: lockdep is turned off.
CPU: 1 UID: 0 PID: 4655 Comm: dhcpcd Tainted: G        W           syzkaller #0 PREEMPT 
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/18/2026
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 __might_resched+0x350/0x4ac kernel/sched/core.c:9162
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:142 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0x114/0x33c mm/mmu_gather.c:424
 tlb_finish_mmu+0xf4/0x228 mm/mmu_gather.c:549
 exit_mmap+0x3d0/0xaf8 mm/mmap.c:1313
 __mmput+0xe4/0x2f0 kernel/fork.c:1178
 mmput+0x70/0xa8 kernel/fork.c:1201
 exit_mm+0x134/0x1e8 kernel/exit.c:581
 do_exit+0x518/0x1a6c kernel/exit.c:963
 do_group_exit+0x194/0x22c kernel/exit.c:1117
 __do_sys_exit_group kernel/exit.c:1128 [inline]
 __se_sys_exit_group kernel/exit.c:1126 [inline]
 pid_child_should_wake+0x0/0x110 kernel/exit.c:1126
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:140
 el0_svc+0x60/0x25c arch/arm64/kernel/entry-common.c:723
 el0t_64_sync_handler+0x48/0x148 arch/arm64/kernel/entry-common.c:742
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:594


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

