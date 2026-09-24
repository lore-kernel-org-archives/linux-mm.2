Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB35BC98304
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 05:00:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5DB46B0096; Thu, 24 Sep 2026 01:00:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE5976B009B; Thu, 24 Sep 2026 01:00:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 974AC6B0098; Thu, 24 Sep 2026 01:00:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 51EDB6B0095
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 01:00:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C9CABA4D7E
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:00:39 +0000 (UTC)
X-FDA: 85247455398.06.C9F94D6
Received: from mail-oi2-f6.google.com (mail-oi2-f6.google.com [74.125.231.198])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1C7FB1A0002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:00:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf19.hostedemail.com: domain of 3da60agkbAAIu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 74.125.231.198 as permitted sender) smtp.mailfrom=3da60agkbAAIu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790226038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=DGp54yn9mQvzr/7sOgMFt0g4OtQDC+w1VQA3OF641dI=;
	b=esJF0C71DruSxhvsrW4ZMzBHxZmu8mR++c/+bgKy1Niyh7dXCMENeIFNmGCKYblCh1XkGO
	ObbL1a4XV2deRLHFQA1ZH4f57UP8b49lJbRIFd/kFcjMojN/DdsZ5MYPLjIy6r0nIzICxf
	nh2n5nPKJ5w+Qq40AW0kH87A314chrw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf19.hostedemail.com: domain of 3da60agkbAAIu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 74.125.231.198 as permitted sender) smtp.mailfrom=3da60agkbAAIu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790226038;
	b=e3mhTfGs4EQaBox+vTIilW9uPPTkcgUl86YsOJlgoXhiZeLga0rgYYqMrPT8WUrA72VL3t
	g7ThAm4j4KVD5w1TAz5KhkbqhM5g9UozOogB2Naqh78yjvuaxGELNg/ZF3fgGpYuDo9WfU
	lL3ThqFRP2wp3CA8GZq848dv4J6Erus=
Received: by mail-oi2-f6.google.com with SMTP id 46e09a7af769-804795653f9so348761a34.0
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:00:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790226037; x=1790830837;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DGp54yn9mQvzr/7sOgMFt0g4OtQDC+w1VQA3OF641dI=;
        b=2jIZWopsXYf60h5nezBm6slwGwQLZZuwPen2qJPfoFSoQn3Os+IAw6uPlPYeWZjISd
         K2e63Dwtt3HsSsEOUrhaPfkOn9Ok+TkMt0ahIpAeeZ/yZRGaWrK+C3lV7fnR+CwXeH0v
         oXWzOlVghQTzAn7DACf9vAzgB3oTMVvWlwMYffIZw5Nq51MR6cj5+ZQKZksdt40QtYwm
         6z4DwCM62A51zj2eROe9Qn2Xh3NT7VRGHVKk4g09afWfcq2DS2VQkbzBAgfQyu4c2QOf
         MMVK2onLt/t9Xx8t7bnefquPRcosQgAOv9Qj5M2VQc6NlWr4hdmbGzcibV99dC0V2h40
         yAjw==
X-Forwarded-Encrypted: i=1; AKwUvByMW6q1aGGe2oRg8HVeyUWOzra/O5W7gHO+fFzhSB4ZDcIf3DlR06FKphnKGSikF3B5WoOH4zEVoQ==@kvack.org
X-Gm-Message-State: AFuF++kYe9jo7XxXXLngJAaz7YHbeB1lCUsQ6816raiFTXY5U5s+AODn
	D8/X3XDb8dtizkbbX2EMi7Ki08cf7q9k9WmDbbhFNOqVOquexHBTDe95s+u5T/ICCSQDxkZ4gtH
	tUVo5SnFy42/TPrYXg8tQgWeHMt9US9FvrgN9+cpMZYW9u6jwrnhFGF13VUY=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:19a7:b0:4c1:e0c3:9d17 with SMTP id
 5614622812f47-4d728717c0fmr1913863b6e.8.1790226037068; Wed, 23 Sep 2026
 22:00:37 -0700 (PDT)
Date: Wed, 23 Sep 2026 22:00:37 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab4ae75.80e1c6cc.1e8e5f.000d.GAE@google.com>
Subject: [syzbot] [mm?] [ext4?] WARNING in __folio_set_anon
From: syzbot <syzbot+c181d3198e98f8aef8b9@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@kernel.org, harry@kernel.org, 
	jannh@google.com, lance.yang@linux.dev, liam@infradead.org, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	ljs@kernel.org, riel@surriel.com, syzkaller-bugs@googlegroups.com, 
	vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1C7FB1A0002
X-Stat-Signature: 16619gppuap1uazs1f6k5aureag7qdr3
X-Rspam-User: 
X-HE-Tag: 1790226037-665705
X-HE-Meta: U2FsdGVkX19AvTSt+NCEahYWH9AVreGIeTGoME//qGQA7SyoAdxuW9OJDD+LUTFOaN/6WTZOfb7zs/4DKBCdza7gvB6wJHE3vg2Y/FrplFgTAq9XGhZCpjOcHTwzRN/Jf1aNPlNK6pObqAidd0c1/RycWAkDhhO7fIVt/HdFTXUC7zSrjCaSZkqkaVUDLj+2Tr+U41Y81um2v7KGn34mFYvQy3o/Bvrkl+H4NidluE6RufvND+k1IlfbTOEMC6LBGIdrFWzJ6FQEk/5qcjO/F18sDtWixD2m42+UXHxugt9RgOA6vVJdiLg9whPi9CD9v5+4t+GaVF30Z3epKJvDpQaNnn121cMJexqjquh4Ygxo+VLFz5UWr6X1pAwChRGdHaW09NAqDQ4bAVeCLIbYBny5RM/cmZUxz4Ym23eRMLPXuB0N9dHRMuY4UPGs1bP4ftS2qSo+4o5oD2oKqR8Xn5W4Oxyz7nM3BC623oJPrnX9ct1BtyNVx/TmsRutMZkAhi804dYDMLAlXnGzvgVJEqjPhh8AWx2t4Q/sGvcYqyHwB5+RfDbS0jKIUz0beji2ZR5ySn1F5hvMv1IR0tBxW+Y7GZGv/SAI6WlnndaQc1+A7W1RRZ0X9gaGG8sP6nvOs5VUfeLRTypwzlnY18extle5dJQXccZHlneUma4beZNpO7nWBS1aEwJjFXLPvB+glM70UsRnEsNvXQXHK30ihYLiWYtBef34tsxPcWIr6tYL95O1EXFsofC4SzJ5INnzP90rFXSfavUNLCIij/6Jo+wEu6ynbexCtrx02VdG/DTImCfrMAAxiIe1pXn5tCBLHAOiRMB7Nk/AyA0tPC9GegBGQy/EqTVC7yHlhHDNKlfPBN14dVc/B7ikAn9bZJ/Zz9TBlz6IKyDiypHcM/GQNuGny8CheKadXTnXbK7JQKoZ0aSH/OKnx/AOKZVWDJWI5C2GP1YcMsp6ZrBU8pS
 IrOBzUsS
 OJPqMzrKZaIvIqRbsRA5+ZhZ/5Qfn4fM60O8x9wPQcXr2SYc6/C6dLCoKXKarxCOklE7uJghXnOo7Nuq6i6319xfuyBQ0mxPjvjeQUjdJLofDfltY1UWpCw0v4QHoXg2ls3G3rrzpiy7ucoaq3v3XSA0k0HLHqy6Ozi2oWk+IAhY9JXcNcvcz/+nbZLhDmso4inn9TSWboV/77fIXSv2CPrD4a2cx4Uwa0pOEI55GeakiSAi1TKVP6RuTKV9GZOA7reyH1eHRWlEKBQmHGt9ux19yTzVOXDcyLBDIozfO7jfhQyQToTQJrqfzOwwDttPAV8U8o40/rnYuA3DoqIZIA54pMyuM0gdWDywXJCOh/r/iW+fdH57qee5C1+ADSk2ZBQUFl68OLnFKaFW8UMjpyUebAdyY26ISaXRkUxjH2G2g3vYf8OrT2GVGLvbwyOfAw0qg/TJX5xLYBY1XsNNy7d+Ssftd9jELVw703q5aF4iz1sxtIu1WJSxfANQMisR0deNvEsKw9XOmDz6D6hUWhfJwEPXl2d9i5232KrgZE8wYmlIVJ+NLI7uKNVWuUeCyMTwTs+246fl/MEFcPtvm1H9zMWPQMCOoLLdoM0WqySQlbRN6AACMInzJSKOz3FvdOVH9WUTZH9JElXJN8d5KQ6sGLoXvMH9o9yV8EQX9zsesjUtdxOcxhlo7R9Qi93ReWUaVb8gzvxRoYwii3I7Uh0QLKgKa7eLldc+L01dYcA1gTdD2c9GLWiDMuQPS42Cc5RFzYfIvpv1PCx4ZzXwpFmF4nEFn4f/+qIzrC/AQHPJwtMc02WkvBqtijKkbkdhBRBxBod2AVnnqEFFCDHHE31fhSDx7/rYPVK+c11pHbAV1OSltBH09HbJHjH1VrwO1LUMIY7/OMI+XDaQ65vWiF3M1mizvILOW3ANe2f5bQMXA8lnS1DuOs5vykyc22tAb37us/HsaifM+1aGUv3xO4K9lPskE
 JyFxFuQ/
 X3M1vNkR3/7IuzEXpkjuTFExyL92smhP86fz7zkngqH7qFR0DavUp8Dcwh6RMcSlCt5Q8spz0GyyZwSct/I+3lChahTq2FABKL7VqCAsjm19ubxVAZW7Y3BEZ1evx8xHX5RCD8oEC64awBIdmt8daO/2xGE2U3y0N8xfuJyDxHPO4pEtAS2vGJZvGK8DLLbnaFpx9UeQeQFvpqnF4IAPEsyqdamR8WfFgikiKwbBxGi7vI5urhDTlwVN9ctGG5WukoK6gNooX4hkGNKzreo1j5geUathfioqFqxWU0DSKE3i8plfLpjom83kF0sPGvcC/iVx8xJfPE0x4XLh44xeFXi0V8rpaTuQbrtek0p7/6Gkws/77WCRkXfMQ8+KvloOZv7l+SamLcWydSAYGywsebFsw46/lAHwtUrvR8EpG1ywp5qSx5ftRZtL1FcNdal68hYWMyArWljGaJJUamKjVL5uxqqkKNg4Z6j/0Es8FG+ivkEcoIpoyIH0oGTuodCnM4ebhTO35ZOAN3X9CtxIdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    38872197cae2 Merge branch 'for-next/fixes' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=17a44d25580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=56ed23170c168d4c
dashboard link: https://syzkaller.appspot.com/bug?extid=c181d3198e98f8aef8b9
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16a36515580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16dcf4c9580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c5963fdd6790/disk-38872197.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a8c2cab00c45/vmlinux-38872197.xz
kernel image: https://storage.googleapis.com/syzbot-assets/bde15d173380/Image-38872197.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/c81cc2849c33/mount_3.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=11cb4405580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c181d3198e98f8aef8b9@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: ./include/linux/pagemap.h:1130 at vma_flags_is_cow_mapping include/linux/mm.h:2315 [inline], CPU#1: syz.0.17/4884
WARNING: ./include/linux/pagemap.h:1130 at vma_is_cow_mapping include/linux/mm.h:2329 [inline], CPU#1: syz.0.17/4884
WARNING: ./include/linux/pagemap.h:1130 at linear_anon_page_index include/linux/pagemap.h:1130 [inline], CPU#1: syz.0.17/4884
WARNING: ./include/linux/pagemap.h:1130 at __folio_set_anon+0x240/0x298 mm/rmap.c:1491, CPU#1: syz.0.17/4884
Modules linked in:
CPU: 1 UID: 0 PID: 4884 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/14/2026
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : linear_anon_page_index include/linux/mm.h:2315 [inline]
pc : __folio_set_anon+0x240/0x298 mm/rmap.c:1491
lr : vma_flags_is_cow_mapping include/linux/mm.h:2315 [inline]
lr : vma_is_cow_mapping include/linux/mm.h:2329 [inline]
lr : linear_anon_page_index include/linux/pagemap.h:1130 [inline]
lr : __folio_set_anon+0x240/0x298 mm/rmap.c:1491
sp : ffff800095456de0
x29: ffff800095456df0 x28: 0000000000020000 x27: 1fffe00019e1007c
x26: ffff0000cf0803e0 x25: 0000000000020000 x24: dfff800000000000
x23: 0000000020000000 x22: 0000000000000000 x21: 00000000200020d1
x20: ffff0000cf0803c0 x19: fffffdffc3c10000 x18: 00000000ffffffff
x17: 0000000000000003 x16: ffff800088b97000 x15: ffff80008a849000
x14: 000000000062064d x13: 0000000000000001 x12: 0000000000000000
x11: 0000000000000000 x10: 000000000000003d x9 : 0000000000000000
x8 : 0000000000000000 x7 : ffff800080c16020 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000001 x3 : ffff800080ab2d0c
x2 : 0000000000000000 x1 : ffff0000d07a1d80 x0 : 0000000000000000
Call trace:
 vma_flags_is_cow_mapping include/linux/mm.h:2315 [inline] (P)
 vma_is_cow_mapping include/linux/mm.h:2329 [inline] (P)
 linear_anon_page_index include/linux/pagemap.h:1130 [inline] (P)
 __folio_set_anon+0x240/0x298 mm/rmap.c:1491 (P)
 folio_add_new_anon_rmap+0x1a8/0x10ac mm/rmap.c:1663
 map_anon_folio_pmd_nopf+0xfc/0x160 mm/huge_memory.c:1365
 collapse_huge_page mm/khugepaged.c:1438 [inline]
 mthp_collapse mm/khugepaged.c:1532 [inline]
 collapse_scan_pmd mm/khugepaged.c:1781 [inline]
 collapse_single_pmd+0x21e0/0x3748 mm/khugepaged.c:2797
 madvise_collapse+0x2a4/0x6f4 mm/khugepaged.c:3231
 madvise_vma_behavior+0x3e8/0x339c mm/madvise.c:1372
 madvise_walk_vmas+0x4c8/0x9bc mm/madvise.c:1721
 madvise_do_behavior+0x5f0/0x7c0 mm/madvise.c:1916
 do_madvise+0x28c/0x2f0 mm/madvise.c:2014
 __do_sys_madvise mm/madvise.c:2023 [inline]
 __se_sys_madvise mm/madvise.c:2021 [inline]
 __arm64_sys_madvise+0xac/0xc8 mm/madvise.c:2021
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xec/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x4c/0x5c arch/arm64/kernel/syscall.c:140
 el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:758
 el0t_64_sync_handler+0x44/0x104 arch/arm64/kernel/entry-common.c:777
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:590
irq event stamp: 1412
hardirqs last  enabled at (1411): [<ffff8000869b7264>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:210 [inline]
hardirqs last  enabled at (1411): [<ffff8000869b7264>] _raw_spin_unlock_irqrestore+0x38/0x98 kernel/locking/spinlock.c:221
hardirqs last disabled at (1412): [<ffff800086991a8c>] el1_brk64+0x20/0x54 arch/arm64/kernel/entry-common.c:445
softirqs last  enabled at (1120): [<ffff80008013c050>] local_bh_enable include/linux/bottom_half.h:33 [inline]
softirqs last  enabled at (1120): [<ffff80008013c050>] put_cpu_fpsimd_context arch/arm64/kernel/fpsimd.c:251 [inline]
softirqs last  enabled at (1120): [<ffff80008013c050>] fpsimd_restore_current_state+0x39c/0x9c8 arch/arm64/kernel/fpsimd.c:1797
softirqs last disabled at (1118): [<ffff80008013bcf8>] local_bh_disable include/linux/bottom_half.h:20 [inline]
softirqs last disabled at (1118): [<ffff80008013bcf8>] get_cpu_fpsimd_context arch/arm64/kernel/fpsimd.c:234 [inline]
softirqs last disabled at (1118): [<ffff80008013bcf8>] fpsimd_restore_current_state+0x44/0x9c8 arch/arm64/kernel/fpsimd.c:1790
---[ end trace 0000000000000000 ]---


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

