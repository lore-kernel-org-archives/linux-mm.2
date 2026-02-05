Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7974CECD9AA
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 22:40:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 536DD6B008A; Thu,  5 Feb 2026 17:40:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 517D96B0092; Thu,  5 Feb 2026 17:40:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44E226B0093; Thu,  5 Feb 2026 17:40:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 342F16B008A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 17:40:37 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D399913B924
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 22:40:36 +0000 (UTC)
X-FDA: 84411873672.28.62BBE90
Received: from mail-oo1-f78.google.com (mail-oo1-f78.google.com [209.85.161.78])
	by imf07.hostedemail.com (Postfix) with ESMTP id 30CAC40009
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 22:40:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf07.hostedemail.com: domain of 3YhyFaQkbAAMv12ndoohudsslg.jrrjohxvhufrqwhqw.frp@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.78 as permitted sender) smtp.mailfrom=3YhyFaQkbAAMv12ndoohudsslg.jrrjohxvhufrqwhqw.frp@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770331235; a=rsa-sha256;
	cv=none;
	b=swFZn02zp8f0gO3cU3XBN9K33tFVpV1Y1efJ/OfCWoRYl892hvbhVkITk7Thj+6v5Mccys
	JAwylrqaBUG86jP0cw0Y2tJVD2e74thApPWd5caVCH3NpiFVLq6qNTkn4hQMm03J3hG/Ry
	o1SBfU3FLayPbVcGN6t5sel9wTMtLBI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf07.hostedemail.com: domain of 3YhyFaQkbAAMv12ndoohudsslg.jrrjohxvhufrqwhqw.frp@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.78 as permitted sender) smtp.mailfrom=3YhyFaQkbAAMv12ndoohudsslg.jrrjohxvhufrqwhqw.frp@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770331235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=DuWAEd+N9k1V2CmdDlaOa4SrWIxcBY/M7PymrB9H2NI=;
	b=HomqFTF3F/Xjz3MG0k6xLCqwAimiTa4yTfmybqFU2HXHCfrsMF4J4R39m2CweTaCEy/q+s
	8GrXxZ6TpGeq0uiFjEJ/TTQUCiZRbGm84TEYQghV9hR4if7W745jUDZ5g/wjp4QdO1Lh9o
	vlPcvoiZci6CCqP1CE45rmm4iy+iLek=
Received: by mail-oo1-f78.google.com with SMTP id 006d021491bc7-66304fd62ebso6499057eaf.3
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 14:40:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770331234; x=1770936034;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DuWAEd+N9k1V2CmdDlaOa4SrWIxcBY/M7PymrB9H2NI=;
        b=oZuGgcwwLfgie8yIcBJJOFfr2z7vaTdRbshFXsHtq9dRdFzNcmCjJDzBXGbppJ7mP+
         w2B+1OVuFfKA16wcTHbeyTUoR2meVUQJr8rEsvs9Kgq+VCZuoiBD7uy6CMqF4XKgBEPP
         /dvk+KilbaDWUhARGwnX99+jfpmL9V1DGq5JB7AxdAKkI03MZr8/7nqjtPLrra8VSSqG
         zWNPAZ4N6DL0NLS2sPp7WEe3ofYK/e1YqyCFCSUz8l/Vf1yHKsiFnU0Y85x3lgKUSuBJ
         DcdBPwZ6t0C5BlOSBfPi78tOYoWac6EUgbf9LVpnrE0fS5zMH+SrV9oHLi0rDpzgNQMv
         vnrA==
X-Forwarded-Encrypted: i=1; AJvYcCXzDddgczGb/LVc7ER9Q92SnWNmmmdIbRQ0NfLzd20R20t1Zk1LkedcqP09+l2tH8GyyDB5OSr6Dg==@kvack.org
X-Gm-Message-State: AOJu0YyqlhDbASK4ZatEGoz8CgClaoBmgob+kegEe/d+9wqu3Xr0Nxao
	NaJBB7BRnjSzGcltRbfVHpE7f7NSqT2TcyItnlDKZtWXQZJQOf3HVdpi2d4j1NZLWjWvGBZUvLk
	sJbv7MhbYdeT6lPnBFgjZKD7G6Wu3E/Z2KCslLHcY6ezqmgQBlmnRqM0I8V4=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:611:b0:662:fe0b:d763 with SMTP id
 006d021491bc7-66d334b3eaemr231461eaf.37.1770331234288; Thu, 05 Feb 2026
 14:40:34 -0800 (PST)
Date: Thu, 05 Feb 2026 14:40:34 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69851c62.a00a0220.37c87e.002e.GAE@google.com>
Subject: [syzbot] [mm?] kernel BUG in page_table_check_set (2)
From: syzbot <syzbot+227179d5a8a87e9df90d@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, pasha.tatashin@soleen.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 30CAC40009
X-Stat-Signature: erkdzrh5mkkqegzt7ehq453674hu5z4a
X-HE-Tag: 1770331235-945744
X-HE-Meta: U2FsdGVkX1/qdv5pZEM7M5kY4a2UoZzWZYqJVTEtkfNtUepLCnj8Z8eAKcVLYic9eBoMJ2T+z2R8KSBtlvs475usojcBkWJRRcfIwQMIlstNTu8BEBl0I7rMSYHbVVbv7yUEAxO0z8bPrf/PYDppinxsMgISyYfxjxJFnhWlN/VlBxScR3JU6D38UcjdNBercynJWu+3XoQvKZ3gKd5DhvJppPTk5uYE+Ee/UugScFzThPCEzuFjga7qbHnajzW4c6r4vYFjGcVBvyryo0m1VSuccViUHwIPJELrmNkyLNiV4Mx+A9JicmGnodT6SEovqShn5/HvrZIyMhENsxYF9kS6P9B4LfJNmrL0W5yk694EVlRQLtYhGg7CHrgbyUJkICj9MSWCwv8QVu3W79XGmkW3yfWA1eDlgXz6KVJ7S67DSrjeEh21iRQ6kaRuiFXJ7O8Y2xH2r4RowXPmudF+z2mSzPJDFREEh7iVHe3QGaEwJs5x8IXhF4fPHLHDVo01V63sG+GIb4zJ9xhmdBz9H5qZ7F7+F2cbdBSM6LQ3Q4kX+IrHpHJAX4TyW9KSzZTF2LvCHzMEHe8Zuxc4rNiI8BjFiVI/UPtWXMmxOO0jvz8RTL1CpnIkDb/yD4g7dlNJL5nwrkbtIGYSx2tKYTeOrP4/c8kiEFwhMeeGpZiLrebGTdFIAjKZ2e/COIv9J0icEjY5B0Qt/AMP/os3PxBf9QI2Lh6k/w0+Cczq+Ygqq/4N1SKiYy1VnkWdw6eD4ftJJ8HiNXV6ngaNdA4WtLSWEacMa7ScZ+nShRp77JLNjpvHG1SqBMPm7oCvsa+IM0doCFvwG3N2BF4CmwK+KDp+/3f+MFqAbqNdG7a0/rKne7TlBTUXJdyecnaY0VnwHSjhw/22n3TO58FNB3/8F35//AXRLbtfTfB+KCT6lWjyloWd5dR5oS5eG163lQr0a3R8+ZKApF04QW83U9E1NOP
 paJTlNQo
 O8n07wHbQzPdJq0fECIr1sITMgJb6Tf15RpPaKaXEL12DqeccQAG6YQN9PAFNHmG+yta/N4uGffzgwCr45PgnO58UVpVsXcA39F5GX32hjAF/4fZGy9+Uri/EKAw7xENOVRag1F7feAyMTj1ijq5P96eQimPnezq75cL9Q7v4Clj7gAaDwUte0v9LOPgizWx0+WZ9CHV2pSZIgrAuV1GOxUEgP2hlFtz+LQ2HNX0DBuw5VkgMUObcrDJdJ3QUnd1R0YuH5Q6VGn6rqVYaoAcJ01H87BjxlKaljzwip4mplfYdMCv9mtUgz/TgKM1Iuh/zNSoVb4IwtW9xcX/Q59GpljW26NgMiRo0BjbtOyVoliG0MAttfG5IyKO7nZeDDDm5Qrrn0bLyAOoBRXAosIL/5sJwdFNTeGkEvlZG8+YiBKymVrPtpL3lXUFVTfikxQLBow8vchJsJmb9rMO7dmC+5O7Z4AtlVMcTf5mQJkR5TldQhJlBYGYTEbe3GhaAm/yvSYeOgGAlEhlYPsDN36N+qGa6z0Ieb6HWqZAb8iPrCC7ufJ0EJyHnsx0tiTGYnZ9iF1RQnQ3YRBhlOo8PtYuHba/sLF9CSGQJbkwwe1tK30fN2eOQwu+RLml1sJnwQ2C9JbUmr7asjIQY/zpfYaTrhOMHZjgA8PmLl2A8ogP3nrSxkh7p5diUzK0c0pKxfO5jNfIEzlvTEz7impqlJUxdHoYJjtEkQ4B8LKQkPwBhs8JeGG0Mz2kPoAPc89QT5gjkrvTRnasJbm+a7Ka2kaXM+3Ss79LUDTY3X+jJBC9qj3zO7z3AtNwPvEtMQFI5X4qh4+YLB/EuvE30NpPERcqETNjEyquT2XjdCxTAi1ohm0dCSoP8m1KysUfGXJLuCirGQroRqgZKyEWXUfFwjHk3kiCEk7QVxA5iFH2AcLwtyvqtBj8VwVK6XdY8ze2dwXSXRZove+M6kY99wTwUMuFHA1rEn2kR
 jeJJ5JgD
 Rnrz4o6OtZIsr6vKcZwheD/0JY6kqXckyh1+p+gSk9cXcnnbaZAWr6LQRW/D6te6jJ7qXZcY04Ed+MVDbdRWMSDUYECKfcO8/fDRlVj51iiHUNGeWPX1IMQ1oi+tOM8MZEdWDtEVNHiTSMjALviXfsghv281Hpr8WVeBwMGM63GEP51S+b2Y+a5mC8GyEP/DpEpKLmuFgaqwTlLn2eY+NZ1u2nlFA8PIIyIE1AzU4HlyTiXcnuoDBpTclU9doWBGPd49DL76B7O5g/p/GLKg+nbUKt7wRFgv5luglcvZ3Cmx+es60hoydqx2JlA8qo6jNulrNVJqw+rzLnYOr1CbHgq3LF5ryackMX4osY7h4Nuzbfm4/8w0wL+it+Q+cLHUoRT/aZl3HhzX7M6Co0DaOq43KGgdwuB4PckpUavyx/VTdHTtBONYJIxSeCL5YDvShYMiqS+5vZbBJ4M+DZx1FWI6GYv+kKtyPgd5iKJFcbw4vgIhi3TN9Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    099ba40b1bd9 riscv: lib: optimize strlen loop efficiency
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git for-next
console output: https://syzkaller.appspot.com/x/log.txt?x=158c8b22580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=781a4eb07921464d
dashboard link: https://syzkaller.appspot.com/bug?extid=227179d5a8a87e9df90d
compiler:       riscv64-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
userspace arch: riscv64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/a741b348759c/non_bootable_disk-099ba40b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/38fcde8ce410/vmlinux-099ba40b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9246b4696c47/Image-099ba40b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+227179d5a8a87e9df90d@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at [] mm/page_table_check.c:118!
Kernel BUG [#1]
Modules linked in:
CPU: 0 UID: 0 PID: 7886 Comm: syz.4.1009 Tainted: G             L      syzkaller #0 PREEMPT 
Tainted: [L]=SOFTLOCKUP
Hardware name: riscv-virtio,qemu (DT)
epc : page_table_check_set+0xa74/0xd30 mm/page_table_check.c:118
 ra : page_table_check_set+0xa74/0xd30 mm/page_table_check.c:118
epc : ffffffff80bfcb7c ra : ffffffff80bfcb7c sp : ffff8f8000cb6860
 gp : ffffffff89f9df20 tp : ffffaf801c80b500 t0 : 0000000000000000
 t1 : fffff5ef026b8409 t2 : ffffffff9136c6e8 s0 : ffff8f8000cb68e0
 s1 : 0000000000000001 a0 : 0000000000000001 a1 : 0000000000000000
 a2 : 0000000000080000 a3 : ffffffff80bfcb7c a4 : ffff8f800b83a948
 a5 : 000000000007f948 a6 : 0000000000000003 a7 : ffffaf80135c204b
 s2 : 00000000000b5a00 s3 : 0000000000000000 s4 : ffffaf80135c2000
 s5 : 0000000000000001 s6 : 0000000000000001 s7 : dfffffff00000000
 s8 : 0000000000007fff s9 : ffffffff88825fa0 s10: 0000000000000000
 s11: ffffffff8a0b5d80 t3 : 0000000000000001 t4 : fffff5ef026b8409
 t5 : fffff5ef026b840a t6 : 0000000000000002 ssp : 0000000000000000
status: 0000000200000120 badaddr: ffffffff80bfcb7c cause: 0000000000000003
[<ffffffff80bfcb7c>] page_table_check_set+0xa74/0xd30 mm/page_table_check.c:118
[<ffffffff80bfd300>] __page_table_check_ptes_set+0x264/0x47c mm/page_table_check.c:212
[<ffffffff80b5e6c2>] page_table_check_ptes_set include/linux/page_table_check.h:76 [inline]
[<ffffffff80b5e6c2>] set_ptes arch/riscv/include/asm/pgtable.h:640 [inline]
[<ffffffff80b5e6c2>] remove_migration_pte+0x1136/0x2494 mm/migrate.c:436
[<ffffffff80a0df26>] rmap_walk_anon+0x30e/0x690 mm/rmap.c:2861
[<ffffffff80a27da6>] rmap_walk_locked+0xa6/0xcc mm/rmap.c:2977
[<ffffffff80b69a0a>] remove_migration_ptes+0x18a/0x1bc mm/migrate.c:470
[<ffffffff80b90dc0>] remap_page mm/huge_memory.c:3434 [inline]
[<ffffffff80b90dc0>] __folio_split+0xeb4/0x16f8 mm/huge_memory.c:4069
[<ffffffff80b91ae2>] __split_huge_page_to_list_to_order+0x7e/0x140 mm/huge_memory.c:4200
[<ffffffff80b9554a>] split_huge_page_to_list_to_order include/linux/huge_mm.h:385 [inline]
[<ffffffff80b9554a>] split_folio_to_list+0x22/0x30 mm/huge_memory.c:4264
[<ffffffff80ab469a>] madvise_cold_or_pageout_pte_range+0x1862/0x2400 mm/madvise.c:412
[<ffffffff80a03002>] walk_pmd_range mm/pagewalk.c:130 [inline]
[<ffffffff80a03002>] walk_pud_range mm/pagewalk.c:224 [inline]
[<ffffffff80a03002>] walk_p4d_range mm/pagewalk.c:262 [inline]
[<ffffffff80a03002>] walk_pgd_range+0xcc6/0x1f84 mm/pagewalk.c:303
[<ffffffff80a043f8>] __walk_page_range+0x138/0x7a8 mm/pagewalk.c:410
[<ffffffff80a05cf2>] walk_page_range_vma_unsafe+0x212/0x868 mm/pagewalk.c:714
[<ffffffff80a063a2>] walk_page_range_vma+0x5a/0x84 mm/pagewalk.c:724
[<ffffffff80aadfe8>] madvise_cold_page_range mm/madvise.c:586 [inline]
[<ffffffff80aadfe8>] madvise_cold+0x1a4/0x5f4 mm/madvise.c:606
[<ffffffff80ab66c0>] madvise_vma_behavior+0x1188/0x251c mm/madvise.c:1364
[<ffffffff80ab7c8e>] madvise_walk_vmas+0x23a/0x970 mm/madvise.c:1721
[<ffffffff80ab85ae>] madvise_do_behavior+0x1ea/0x5c0 mm/madvise.c:1937
[<ffffffff80ab94c6>] do_madvise+0x18a/0x22c mm/madvise.c:2030
[<ffffffff80ab95f0>] __do_sys_madvise mm/madvise.c:2039 [inline]
[<ffffffff80ab95f0>] __se_sys_madvise mm/madvise.c:2037 [inline]
[<ffffffff80ab95f0>] __riscv_sys_madvise+0x88/0xdc mm/madvise.c:2037
[<ffffffff80078192>] syscall_handler+0x92/0x114 arch/riscv/include/asm/syscall.h:112
[<ffffffff86391c0a>] do_trap_ecall_u+0x3d2/0x58c arch/riscv/kernel/traps.c:344
[<ffffffff863bb61e>] handle_exception+0x15e/0x16a arch/riscv/kernel/entry.S:232
Code: 7097 ff90 80e7 4580 81e3 e004 8097 ff90 80e7 9380 (9002) 8097 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	ff907097          	auipc	ra,0xff907
   4:	458080e7          	jalr	1112(ra) # 0xff907458
   8:	e00481e3          	beqz	s1,0xfffffffffffffe0a
   c:	ff908097          	auipc	ra,0xff908
  10:	938080e7          	jalr	-1736(ra) # 0xff907944
* 14:	9002                	ebreak <-- trapping instruction
  16:	9780                	.short	0x8097


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

