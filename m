Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF116CD98C5
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 16:06:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C4746B0005; Tue,  9 Jun 2026 12:06:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09CDA6B0088; Tue,  9 Jun 2026 12:06:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1BED6B008A; Tue,  9 Jun 2026 12:06:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E16C16B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 12:06:27 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9CBBF164E86
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 16:06:27 +0000 (UTC)
X-FDA: 84860851614.17.ED62FEB
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id CC0D21A0012
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 16:06:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m9LxCnyI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of yzjaurora@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=yzjaurora@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781021185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iBU9Ms4fKkwnQzVTuseyRGT77WwvNg4b1S3RmLiaprA=;
	b=UeJR4O2y+yjZTVcdTiDB3Edh4+vS8sdJsNwvb3PKx0/n8Lh7VWHWQrPt+ldCTFhXYY7F7y
	DGY7H4zx8+o2kKnoGgQvuFY/pLEL7IqR8+6EN7pYTISaHmx0kD6hQgPG+7kkqo1kyD8JZi
	4HtIsz7tLuIN6sN8idEXcRQE75rlQnk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m9LxCnyI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of yzjaurora@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=yzjaurora@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781021185;
	b=mvDdgjxcjbZvkQLbv9ntbwbft3oJSo/molYuZrR05CAim7ZGNhtNLJcmNTkxpHRv5OzYuJ
	4vPlown04XTszoWURVDG6maaQ72UpzdBl2WZBCVbDmpLu/XDZcYYeLoR+AtAxVMen733ZC
	89IR22DdiQF5jKSYeO14njGFVaBpcXw=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-45ef93a0b0fso384991f8f.2
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 09:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781021184; x=1781625984; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iBU9Ms4fKkwnQzVTuseyRGT77WwvNg4b1S3RmLiaprA=;
        b=m9LxCnyI85zQNQPg8RomQL4wVUrIGvFQcy0Xwa0bepnZ6SY6kr6CHUnjtxQKT4bNNr
         6Y8HTX65BdSt42TxhJ4DZT8xwZvWdaZj9XRpZ6UZ8pbeZdjVCPcxTOpDQK+heFyBD89o
         ERINFtR0U3AjvvffY1NYNLnG4uuzvggBwLmz9xvmesucXXHWy+kXp0jhhqoo7lG1fczW
         OjjaKtPvK2I+ESritWeheHgYaO3taL5tyHP110Yc6TG4j71q5PD5X6swIie7BoSD9H6Z
         3bjkKuY2cbWcdmG0HEqHbYc5ybiUO68J42KjQLhwRNJsrBtl9IYcsdlL+qX3ZX1Cs4zP
         ecXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781021184; x=1781625984;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iBU9Ms4fKkwnQzVTuseyRGT77WwvNg4b1S3RmLiaprA=;
        b=AHA0VI0ZCyH+SN6ZFIIqjLA5Z6deqwKRXQkzqkLHn7UlE6uTGKHuMvn8NimM8QmvTt
         oOgeFQflcXvLAAX8B+njPYF/Gx81bfAbbbFdayjaPraqfsqeGPlIVe9eKVxKZRjlgSli
         C4a9Y4H3G22FaPesX3demhZRHms3lSOYlMgM3IsOLUwoVJ5EUTfaWqGxgrLsl41sB9hT
         fLa9cBmKOAkZxQ2Iinml5b4NujtWhvfAJTCowQeI+5JPEHfEuBArDKPloLJ2xICV0bx3
         V3LE/mu+aD53VFSMAjisw1No1FERRA8IGEpG/hbrlCaX1AWs7DUDsnoKQKad6XniFaIt
         KZ2w==
X-Forwarded-Encrypted: i=1; AFNElJ+ufG3cYPn6elaGrp/hwwaWPYRkq/N/bxqv66b443hDQSw8WJdAJR+em3ZXMiFM6Jz9ox4FSGLWHg==@kvack.org
X-Gm-Message-State: AOJu0YzAQs1ut6Nw+SaIr7LzOeUzfz5BnzfCkeIA0MLMOWum783EDmYp
	C0I1lM3dkd0No+D4ALSCs/L6zeOnGXyggY93/yywOZ8KiEXiLvFLvJnu
X-Gm-Gg: Acq92OHslbVThr2M1lahqCGvMVa6hw+VxgnY5nA3aaadfFYqB6zS7JqyRWiRxB7SZFe
	6PlFd2ZogrqV7phrgP1pRrDF9K5xBDxrZf6Usn2Bryk/mjHZmiSj/oJjMuAq7PONTtqRYjcXoGe
	bnfo9su+oEu9CxPgqMsdJPZ72UxS7Tac00iG5gwWzDNZxaFfulrN0bOjUZFxz19i151F3Ya1zb3
	dbL/MBuN+UwOyVvwXJtWsJJnwlCzzWiDpL+Ka51nXZdP1cfYZUm7n+o2WXuUqKOOME4Thch13AW
	gj89Vz6yDsp0Y6QkCEUJ/hHV1P6E7V9NJmddoyipjlQ8vdltp1n4q6Jcnh7tvVxrQlyJkZ2DZ2Q
	3lpWPvWmOOQOaUtPJU/1qkuE0Bq75gobYN9D4LsebznOr2Mtn/WwmHK8xqr3N+EVsVZ2aJU4soq
	dD2I+sx2muSNDdL6FmCVOQiyoBb0XDFJN+85nFZ0e4ImtoJVZVJLq3pLOBtoIgwmyCMakYNTF34
	xkTLZKxbpQan7poEQ==
X-Received: by 2002:adf:fcc9:0:b0:45e:91ec:d4c4 with SMTP id ffacd0b85a97d-4603065c0d9mr10167020f8f.7.1781021183902;
        Tue, 09 Jun 2026 09:06:23 -0700 (PDT)
Received: from ast-epyc5.inf.ethz.ch (ast-epyc4.inf.ethz.ch. [129.132.161.179])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2ec711sm61761615f8f.12.2026.06.09.09.06.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 09:06:23 -0700 (PDT)
From: Zijing Yin <yzjaurora@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Zijing Yin <yzjaurora@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: general protection fault in stack_depot_save_flags
Date: Tue,  9 Jun 2026 09:06:18 -0700
Message-ID: <20260609160620.500322-1-yzjaurora@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 6jk8ratof915dw3xjux4mnsrk14zxjye
X-Rspamd-Queue-Id: CC0D21A0012
X-HE-Tag: 1781021185-523602
X-HE-Meta: U2FsdGVkX18VCCi3oubKW+mXjpBykXsPsDXetK2NmHRINsOB32EgXqqGaWEkcSXMoyl0N5kTP7rm734tcUhgye/+my+frObbaA72adU3Qjbg4JZQsW6Ri8s2f/kKYJ8H4yiO98e8m101e6PRK2yNT3PNkxil/wI5I61DJ/EvZ+O2PG9O4RtjYOBdb0jjtXn864JWq5n+7d3NGxxWuzLmTmTPRJdN9E7FIbmNOd35Vg52JVnE5jsXoGwPD1sE/CZV0VjmHDwtBec+YyVl5BGOE7oq/9ySSMm84+945jnKvzR2qKF10oeXW4z3t3TIQqMrLKm9w+qx7mSKbhZgGDbx7Kaqqg8bteHpPXtxAFYfp1wriyNrf3OnUVUANSOr3rPZ50cai5IJThq0zUyaMV4KfPI5v5gnmyKH7+rygml9ylhU8SuOPX38jELl2ByDq+NUxqiuCLskTEmrVnUca5zqlj7OPttBlY1XT9Ex6ysdyMfhHyRdSnoC1JBTMRp+nTC0oY/3HhnavBFp1IfIU9tloVpoI5SDuUAKxexNzuMpZcJeyZOYbCz4Q4DVilEO/VWTXC4GEMT3SZD+1BHSfH6buecwzUzkro2uOcsu14Lqgi5HUqDJ88N37mNDBgGQViDMbRLnEBgSEfEhfLAd/WwQ3imzql045nJLzSmfFARxYslK0h6tGUYMaTQ9p6QXFIigW1NV27HWCacuIEDIyXEcwO8+5X5bvSAo7SnzLeF6053W3qbqRHK++1BZiTTITvPG0XGkIPvcRaFf4hILNKW8vVP/tsSEUZSeQuEsSaSp5mO0yio3h6aPaP47xqpGIcF2KynboJkzjQddWarIjuDBIwYq18+Yx8JVvAGXH2MCF4aCN9SxI+P2p/0m6AMkAfdghncjRkcDyeeKIhUR2ukSxL0FvWjJOPkwenPUWZ7loY8fBGVtBeA2E7AGxPNSGHkoQMaj1Pel8jskyGjLGcC
 KyTCb4iM
 ZI+mBc5Mrki7dciKHl8RWW+g+6YXiXFFsa7Mbj7PLBL1+U/FcOQsl6X+Qu7bDbHQOLycQXmNSDA2Q5TK3QMUnpmS7aPMeKPp85JbmY9Ytebf/Hx+lpRVK6s9utyuAakkYhnoTDo+iflrzHDinsYJHE4Xn1yODxfeRd+lr7IkPwtvZS46YTPU5u9dE9Y5FhIfgAfME7hxFCqnhS9DOeDIvK3QIODnWEs6jRhGxYNehOFP7yI5y5rxJTHorIztrRhBKMoJAfKsiNpZy2/C+y5lywkqkVcrkmyWijQTr4CRrYrX+4+ULJyyUq/rlNteSe8rPFa6dx39x6fqHdFgNuhxJOmPT7+vf/ONysfNo85R9N367xDTzlSuHcKDMbFHORbwcUv1pqK2bOdwZ07o12zYCqR/96p4Hx8tGjTMtCoh+sQMG7oj8TU3gkOH3TEudvJrl3dWJdu8ujI6+L34AA7FS+XEHULLNQEJhPpdkUQv7/I0l9N8gBnwu3n0tVIfkGQAQRaRg/gfi6YdbF8D/CIQBgtzztgVWKaDDVYesTvMXIVRREfb7OSbCHTZj7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Fuzzing v7.1-rc1 (98878ed91b68) with syzkaller on a KASAN build, I hit
the general protection fault below in stack_depot_save_flags(). 

The syzkaller reproducer (repro.prog) and the kernel .config
(repro.config) are attached.  It reproduces when the reproducer is
replayed on a KASAN kernel, though not on every run (roughly 1 VM in 4
within a few minutes); the crash is still reachable on the current
mainline tip.  I can send the full dmesg, the disk image, or test a
debugging patch on request.

Repro: https://bugzilla.kernel.org/attachment.cgi?id=310286
Config: https://bugzilla.kernel.org/attachment.cgi?id=310285

Full splat:

Oops: general protection fault, probably for non-canonical address 0xf4da3160ff110011: 0000 [#1] KASAN NOPTI
KASAN: maybe wild-memory-access in range [0xa6d1ab07f8880088-0xa6d1ab07f888008f]
CPU: 0 UID: 0 PID: 10953 Comm: syz.0.1921 Tainted: G S  B               7.1.0-rc1-g98878ed91b68-dirty #3 PREEMPT(lazy)
Tainted: [S]=CPU_OUT_OF_SPEC, [B]=BAD_PAGE
Hardware name: QEMU Ubuntu 24.04 PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:stack_depot_save_flags+0x1ac/0x820 lib/stackdepot.c:610
Code: 00 00 31 f6 4c 89 45 c0 4c 89 55 b8 e8 cd e5 fd ff 4c 8b 55 b8 4c 8b 45 c0 8b 75 d0 45 85 e4 75 67 4d 8b 6d 00 4d 39 c5 74 5b <41> 39 5d 10 75 f1 45 39 55 14 75 eb 31 c0 49 8b 0c c7 49 3b 4c c5
RSP: 0018:ffffffff89a12a10 EFLAGS: 00010287
RAX: ff110001f4140000 RBX: 000000006b5c6315 RCX: 0000000000c63150
RDX: 00000000c41db1cd RSI: 0000000000000001 RDI: 00000000e8904c26
RBP: ffffffff89a12a60 R08: ff110001f4da3150 R09: 00000000b77a3f78
R10: 000000000000000c R11: ffffffff81415390 R12: 0000000000000000
R13: f4da3160ff110001 R14: 000000000000000c R15: ffffffff89a12a70
FS:  00007f45dee1d6c0(0000) GS:0000000000000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f13f3f33950 CR3: 0000000131132002 CR4: 0000000000771ef0
PKRU: 80000000
Call Trace:
 <IRQ>
 kasan_save_stack mm/kasan/common.c:58 [inline]
 kasan_save_track+0x40/0x70 mm/kasan/common.c:78
 kasan_save_free_info+0x4a/0x60 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x47/0x70 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2689 [inline]
 __rcu_free_sheaf_prepare+0x11d/0x2b0 mm/slub.c:2940
 rcu_free_sheaf+0x32/0x170 mm/slub.c:5845
 rcu_core+0x7de/0x1760 kernel/rcu/tree.c:2617
 rcu_core_si+0xd/0x20 kernel/rcu/tree.c:2886
 handle_softirqs+0x202/0x700 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0x4b/0xf0 kernel/softirq.c:735
 irq_exit_rcu+0xd/0x20 kernel/softirq.c:752
 sysvec_apic_timer_interrupt+0x77/0x90 arch/x86/kernel/apic/apic.c:1061
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1f/0x30 arch/x86/include/asm/idtentry.h:697
RIP: 0010:memmove+0x1e/0x1b0 arch/x86/lib/memmove_64.S:45
Code: 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 48 89 f8 48 39 fe 7d 0f 49 89 f0 49 01 d0 49 39 f8 0f 8f b5 00 00 00 48 89 d1 <f3> a4 e9 96 ac d3 f8 66 2e 0f 1f 84 00 00 00 00 00 48 81 fa a8 02
RSP: 0018:ff11000111b768c8 EFLAGS: 00000206
RAX: ff11000189893ea4 RBX: fffffffffffffff0 RCX: ffffffff946612ec
RDX: fffffffffffffff0 RSI: ff110001f5232bbc RDI: ff110001f5232ba8
RBP: ff11000111b768f8 R08: ff11000189893e94 R09: 0000000000000000
R10: 00000000ffffffc3 R11: 0000000000000002 R12: 0000000000000000
R13: ffffffff82759003 R14: ff11000189893eb8 R15: ff11000189893ea4
 ext4_xattr_set_entry+0xc13/0x2390 fs/ext4/xattr.c:1763
 ext4_xattr_ibody_set+0x29e/0x740 fs/ext4/xattr.c:2275
 ext4_destroy_inline_data_nolock+0x24b/0x630 fs/ext4/inline.c:472
 ext4_destroy_inline_data+0x87/0x100 fs/ext4/inline.c:1806
 ext4_do_writepages+0x5c7/0x4e40 fs/ext4/inode.c:2827
 ext4_writepages+0x213/0x390 fs/ext4/inode.c:3042
 do_writepages+0x389/0x5c0 mm/page-writeback.c:2575
 file_write_and_wait_range+0x2f6/0x390 mm/filemap.c:388
 mmb_fsync_noflush+0x87/0x240 fs/buffer.c:645
 ext4_sync_file+0x3aa/0xba0 fs/ext4/fsync.c:92
 vfs_fsync_range+0x168/0x190 fs/sync.c:186
 ext4_buffered_write_iter+0x752/0x8a0 include/linux/fs.h:2654
 ext4_file_write_iter+0x707/0x1bf0
 aio_write+0x597/0x830 fs/aio.c:1688
 io_submit_one+0xa8c/0x16d0
 __se_sys_io_submit+0x1a7/0x340 fs/aio.c:2166
 __x64_sys_io_submit+0x7f/0x90 fs/aio.c:2136
 x64_sys_call+0x19e8/0x3030 arch/x86/include/generated/asm/syscalls_64.h:210
 do_syscall_64+0xf7/0x3e0 arch/x86/entry/syscall_64.c:63
 entry_SYSCALL_64_after_hwframe+0x74/0x7c
RIP: 0033:0x7f45e0c20a3d
RSP: 002b:00007f45dee1d048 EFLAGS: 00000212 ORIG_RAX: 00000000000000d1
RAX: ffffffffffffffda RBX: 00007f45e0ca065a RCX: 00007f45e0c20a3d
RDX: 0000200000002680 RSI: 0000000000000001 RDI: 00007f45ded79000
RBP: 00007f45dee1d080 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000212 R12: 00007f45dee1d6c0
R13: ffffffffffffffb0 R14: 000000000000006e R15: 00007ffe972c9960
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---

Thanks,
Zijing Yin <yzjaurora@gmail.com>

