Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92F1FCA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 13:25:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB5758E0015; Fri,  5 Sep 2025 09:25:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E66948E0009; Fri,  5 Sep 2025 09:25:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA36E8E0015; Fri,  5 Sep 2025 09:25:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C78278E0009
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:25:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5F1B057488
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:25:37 +0000 (UTC)
X-FDA: 83855268714.09.AA1FED7
Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	by imf08.hostedemail.com (Postfix) with ESMTP id A159B16000A
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:25:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of 3zuS6aAkbAM8DJK5v66zCvAA3y.19916zFDzCx98Ez8E.x97@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.205 as permitted sender) smtp.mailfrom=3zuS6aAkbAM8DJK5v66zCvAA3y.19916zFDzCx98Ez8E.x97@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757078735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=/4Elh7QOytx4ZZgIek2zTHwssf7pXDqP3udNq6JZzVo=;
	b=m0xsvEUEgsYm2jr5a+Tl9KDWhIyJ6MtqRn7HKpUrA+KND7Ky0Mdp973D0WiCGIKgov4Beu
	RQkZ8AKOG9FLXkzU9WZGRPZtMXP1AziRbEvEhQhHo89GcpxuhkB86qgXo18QGa++1Z1eY8
	YUJ+4TsBpb82n+X4KeaEhMfn1N5z/Z8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of 3zuS6aAkbAM8DJK5v66zCvAA3y.19916zFDzCx98Ez8E.x97@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.205 as permitted sender) smtp.mailfrom=3zuS6aAkbAM8DJK5v66zCvAA3y.19916zFDzCx98Ez8E.x97@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757078735; a=rsa-sha256;
	cv=none;
	b=KghN7QJe7ZWRtc+uxFdVwPwBsO6Ll0FOw0NVZ1h0Dl4O9HcOwQDKA8PNGP0qs6zz3Aqg2C
	zcx0KdYLHKkKhm/LQBMcR8bL6y348GeD7W5f4ZQQRNOZg3OpnFA+5ODRpvr/obxpBGr09W
	oMHmmjmjtPTy7PE9GqrLg4mRiv4Ozp0=
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3f90a583e07so4613045ab.3
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 06:25:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757078735; x=1757683535;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/4Elh7QOytx4ZZgIek2zTHwssf7pXDqP3udNq6JZzVo=;
        b=SC4MmImyB5vVJKztc4X6hhQy16GuxptwUO9p56wLf1C9rpe52AlxztRWt40CVVL2iu
         tTrvozgFbVFwrAZnmsU833PegdvdxDeNoCO/0D+sIf2n7gWugkG99RGAH7HfkDGHKS8k
         SjNCgwcL7YLZQ2b42YxAOLmyUIQJKqyRyXY/ImwcNUSRUcgccCybbsWMhdfsQCveY0Az
         TZMJ9kQ1xeRCNAi2bBFVqvPYB2kMsK/hRg1OgiSIkUAcZftt+LiCnGYyXjxXvN39ZLTi
         +Yt8H/BXr7UcdWWHWyILEFbT90+gwxtG1sKpMtXppnA9JFxP7es5r08zMcEdVD8n5fov
         fSZg==
X-Forwarded-Encrypted: i=1; AJvYcCXgjtzTJAen4RtJ9fkqW52lQectw6dcudPG0zdwyUxWjNmeAjBLRcF7NvHfXUYN+87hQfcoX1Oidg==@kvack.org
X-Gm-Message-State: AOJu0YwZkWgV2zehgGuCT3LyATRJKw8OFDtlAea+rdKHVqk7I26lMPLS
	RvM9Ks8F7hAJPSVbTm/M8gu5uwPraMdqAmgoUPDS+eZ1Bjm+zWYNcfb197ZpcSS7H9vfIU6zznx
	g8LbaF1OavdAWRJzOqmBjQ0QmYNxmLbqyq9ht9rbuw7sCi3BFyO8CVnfLoG8=
X-Google-Smtp-Source: AGHT+IHwnwdRge0T4S8uURmNjM4GphB5kqRkJAS0qTVE25vmjSTY4Dd9PV0NRYsZElZozbPfLsk9iw1nBRpF7YF20+/HvE18CegU
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:228f:b0:3f9:6c36:ca1e with SMTP id
 e9e14a558f8ab-3f96c36cc58mr21575495ab.4.1757078734659; Fri, 05 Sep 2025
 06:25:34 -0700 (PDT)
Date: Fri, 05 Sep 2025 06:25:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68bae4ce.a00a0220.eb3d.0014.GAE@google.com>
Subject: [syzbot] [mm?] general protection fault in unpin_user_page_range_dirty_lock
From: syzbot <syzbot+0d2f32dad7098551e15d@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@redhat.com, jgg@ziepe.ca, 
	jhubbard@nvidia.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	peterx@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: A159B16000A
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: fcj786u6m48k54k6u6ww87xrgjfxetid
X-HE-Tag: 1757078735-884685
X-HE-Meta: U2FsdGVkX1/ob5ZTZiZPl/hD1eCGBTyFwZYw7ocRpbTVZ7bH/tSm2UAYslSihEFzmLH8AElP8OAr7JXqmnQjgireCniOuNMwDSNWoZnxOLL+yHqJZMYdjy/cM2JBtH4n/SJ27A1gKXYyw7RsA+rnT7AG/DKTlQ/g2mpaxC8MxTru2AIogRX8hveQodg6vJ2t3sMokIxwzQseWrC/L4vdo//kuLE4yO9vAUNt1/J9NDxFBmvE5kskWqZGAc08TbGHKFNEFMX4Uz/soQmtYrdOY+aLbpUkqg0HQ/19qQGNzm0lZ2GZpS91eoo0jMdXrzAN95E/OxTSce4NsBuVGg1MMo0+CDAZe5SZzhHqHWHOvIcBlUk3bWM+zCynBjGaDGm4b/gebSxZLyGmlNpF+GDgOjDPhRc/VWgil8xUWPR6DDNw2838josog4l232CfL0tBvQDw6KPUdm/SOBpljybBUdxwLz9GoXHs7297qgp4Q29iXL+QQEW9ya7g5V46fVUv6LxivyJyQQtM9UWtd6lassPQrr4UNyOAYT+7ucBySLg+3zB1Vpff31ycfM312zGlg7ahHd6wBnjwXODrsVeRfltBPFfeOmFPgTiW0s7MJ8IbaomFgTRXKk28xrauBdyysjbSgVv6IgK3qdvjx5PET8il3r3sEVtcAlLgrnPAHyyItZs18g887lhb8o++DC1Xj16cyM6K4fCK2x2Uuum95h57hxhWU2zXWkfFVwFDZf20JI7UFHaruhKFbgsTTR44Lrjs62PRJsijaq/k3kWFRd5pSHjGVZWmYzDWQfeqB0dl5HsYgpR5drLpk7sL60ZroLjBPB1T6oI4yt7soDqB59azVmlN1gVfgc8hSaa4xKmSxuuz7LCwTrtXzpN7o0/iQEZFcogLAagd23ajv0qVpn3VfAxiRZrkaaOkMg+E1inzz/O/Pkw06mHPFtLgd8JmHf4exWG8zv0vknIvlY9
 2a/qeklu
 Fz62zYpAoDS0obKEVciIcYY34nK9hUUGn2LEVRgNqoDquparKj6Fo5nQtpAIt25QkWPC3JfXzMrLHe+0lEK92LEPU8eKCdJspv86tda9LmkdqJbbkZG6j6fAq4YlO/EeEOErrDktiwFQZuQQpWYiF1zOa5PaNFR3bH+bpFPcxlIUllLcyrX+mZ3BBXUwEma84o1y+ju2LT3E04C5yHwWLSe/ogUbP/iCltel6afL8R0lPE1O0zaEi79pnf/PuK7ZAQ2ed7o9q2b0b/xvJvXOrgNBErM6JOQaoY1MJ2QQ5XfPNLzV1NFUZlk4I4neg5VL+Gjf21PmaufnRyJd4eCXxuY2oz2k5b58Sye4V2En3FoBWBg/YmuRSPFcImaPmmBCTByuuDbize0dAb8F47STX/gTKKFTAYPh4C0Q98XkV+3UfEPjgvv9QBPprPzov08Cs+M6bx0sOOLE0yXN8zbesoN5qMZnxFRNhZEDDc4v6cvPwlhObVczl0QelDpt8U36Vkhf2nzcAsllEPYCPM4Npmd0rMP9UBGSMZQG1T4bka+MqpGPIbm/b9K8V5zvyIg+4gskBcN+AUGTsY8lzuNSWMLBtXTKfswjigPQX43jhYG/ef9P4imiO16qnDf73oPWuTnYS02oBGdQS7orpYSRvPucfIhBAFhFbWY7+lq5DoXrj/49chjQ/Nw6Rpu0SL4XItSif4E8y8OSVJuECArbbDFtDfefGK3f8sJs/u60fjKQOveO+n6BfSSkWXVuD4aJ4DjXxJexx4R82VPn3K6dqmMqi/E/vl6cNk7Zag2P4vTj5cOxG7fbQ1WPAPpTg2gA7XLSSnrcTK1bqke6E+eFzfFZKNn/aUYhXmU9eTakY2R4/OUhqsOo7k52W2mRuJPz1e5k/0T9Pwyy0Q21PYhCVO+rsML2zhPqcUW+uQqGP+fqLCAVfv5190U2NhxuME7XwgxkywjdKR2scfD6/ZQdb5MN2Sj9/
 o1AW9Lfv
 XyRCkpZ9pwzqasF4auNWaSGQaEjyY7zFsgvqgERDmTrQrc9zMvsIYVcwZPsdNVBlqTNWeYZTOwxx7wtD7tAK0UZyI7NLlQ+W/RBmQj5ASrRU0aCG0VGacirCWl6wJGzWUNC5DBZrvBPU160yBP/aVA89i27dQF+uiBenW16jIzKEZMBZ9NfW81g/TrjibLtzTOhwnpXcg1ZSfwy6wI+DFlJnRrFJlXTki7D6aBMxWDMiwLvK5NMjKrwK8cAcLwQp3m271MJxLVUARtEn5p0J+jusEjYLPe1boTCzQh+woGVGD8TK/fyHGX6ZMI+flribQjYHO3bL9PryuF8YwE5GUvO4WBuDDdwTT2IYy9xuauSexegzavFvIK49mfGw25kzesWSaljzkFC5+A+S2J9/h/McVYHSrg1Z8fwGdLXHqbj+QyXPjaIphxOuFJ+UooXiZ6u2sE1PaUP7vQLQ9sF9vIXJ0VkTevPhfIrKqaaeI2iWhs2KdTDeXnNne45xvhnz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    4ac65880ebca Add linux-next specific files for 20250904
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=138b087c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fbc16d9faf3a88a4
dashboard link: https://syzkaller.appspot.com/bug?extid=0d2f32dad7098551e15d
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16a8a134580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=159de962580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/36645a51612c/disk-4ac65880.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/bba80d634bef/vmlinux-4ac65880.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e58dd70dfd0f/bzImage-4ac65880.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0d2f32dad7098551e15d@syzkaller.appspotmail.com

mmap: syz.0.17 (6062) uses deprecated remap_file_pages() syscall. See Documentation/mm/remap_file_pages.rst.
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 UID: 0 PID: 6062 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
RIP: 0010:_compound_head include/linux/page-flags.h:284 [inline]
RIP: 0010:gup_folio_range_next mm/gup.c:241 [inline]
RIP: 0010:unpin_user_page_range_dirty_lock+0x63/0x4e0 mm/gup.c:369
Code: 45 31 ed 4c 89 74 24 18 4c 89 6c 24 10 49 c1 e5 06 4b 8d 1c 2e 48 83 c3 08 48 89 d8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 48 89 df e8 ff 3e 1c 00 4d 01 f5 4c 8b 23 4c 89
RSP: 0018:ffffc9000413f6d0 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000008 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: dffffc0000000000 R08: ffffea0002d10037 R09: 1ffffd40005a2006
R10: dffffc0000000000 R11: fffff940005a2007 R12: 0000000000000002
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000555587af6500(0000) GS:ffff8881259fa000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000000 CR3: 0000000074024000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 batch_unpin+0x3eb/0x560 drivers/iommu/iommufd/pages.c:691
 iopt_pages_unpin_xarray drivers/iommu/iommufd/pages.c:1711 [inline]
 iopt_pages_unfill_xarray+0x813/0xaa0 drivers/iommu/iommufd/pages.c:1747
 iopt_area_remove_access+0x2c4/0x3f0 drivers/iommu/iommufd/pages.c:2196
 iommufd_access_unpin_pages+0x33b/0x4e0 drivers/iommu/iommufd/device.c:1357
 iommufd_test_access_unmap+0x28c/0x300 drivers/iommu/iommufd/selftest.c:1448
 iommufd_test_staccess_release+0x6a/0xb0 drivers/iommu/iommufd/selftest.c:1489
 __fput+0x44c/0xa70 fs/file_table.c:468
 task_work_run+0x1d1/0x260 kernel/task_work.c:227
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop+0xec/0x130 kernel/entry/common.c:43
 exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
 do_syscall_64+0x2bd/0xfa0 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fdd6e78ebe9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd897539d8 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 0000000000019b27 RCX: 00007fdd6e78ebe9
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000789753ccf
R10: 0000001b31420000 R11: 0000000000000246 R12: 00007fdd6e9c5fac
R13: 00007fdd6e9c5fa0 R14: ffffffffffffffff R15: 0000000000000003
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:_compound_head include/linux/page-flags.h:284 [inline]
RIP: 0010:gup_folio_range_next mm/gup.c:241 [inline]
RIP: 0010:unpin_user_page_range_dirty_lock+0x63/0x4e0 mm/gup.c:369
Code: 45 31 ed 4c 89 74 24 18 4c 89 6c 24 10 49 c1 e5 06 4b 8d 1c 2e 48 83 c3 08 48 89 d8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 48 89 df e8 ff 3e 1c 00 4d 01 f5 4c 8b 23 4c 89
RSP: 0018:ffffc9000413f6d0 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000008 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: dffffc0000000000 R08: ffffea0002d10037 R09: 1ffffd40005a2006
R10: dffffc0000000000 R11: fffff940005a2007 R12: 0000000000000002
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000555587af6500(0000) GS:ffff8881259fa000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000000 CR3: 0000000074024000 CR4: 00000000003526f0
----------------
Code disassembly (best guess):
   0:	45 31 ed             	xor    %r13d,%r13d
   3:	4c 89 74 24 18       	mov    %r14,0x18(%rsp)
   8:	4c 89 6c 24 10       	mov    %r13,0x10(%rsp)
   d:	49 c1 e5 06          	shl    $0x6,%r13
  11:	4b 8d 1c 2e          	lea    (%r14,%r13,1),%rbx
  15:	48 83 c3 08          	add    $0x8,%rbx
  19:	48 89 d8             	mov    %rbx,%rax
  1c:	48 c1 e8 03          	shr    $0x3,%rax
  20:	48 b9 00 00 00 00 00 	movabs $0xdffffc0000000000,%rcx
  27:	fc ff df
* 2a:	80 3c 08 00          	cmpb   $0x0,(%rax,%rcx,1) <-- trapping instruction
  2e:	74 08                	je     0x38
  30:	48 89 df             	mov    %rbx,%rdi
  33:	e8 ff 3e 1c 00       	call   0x1c3f37
  38:	4d 01 f5             	add    %r14,%r13
  3b:	4c 8b 23             	mov    (%rbx),%r12
  3e:	4c                   	rex.WR
  3f:	89                   	.byte 0x89


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

