Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A71ECCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 18:09:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB7668E003D; Mon, 10 Nov 2025 13:09:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8DE68E0003; Mon, 10 Nov 2025 13:09:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CB8B8E003D; Mon, 10 Nov 2025 13:09:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AE768E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:09:32 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 536DE1DCEAE
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 18:09:32 +0000 (UTC)
X-FDA: 84095484984.02.5B1962B
Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	by imf02.hostedemail.com (Postfix) with ESMTP id 816CA8000D
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 18:09:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of 3WSoSaQkbAEY067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.208 as permitted sender) smtp.mailfrom=3WSoSaQkbAEY067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762798170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=SfVHyy3yInLiUbcIqZnocrna0llwjFI7de3HK7K21Js=;
	b=z69DfX1BnmW2TzVG/if85KZqpzQHFOF4dm3cbRl4+iZFQ0wznOdxELiOaP70zbLgo5wdGu
	3AR5njtuSTyURm6OaPFrl6IHZTCM4WmQIV8rehCtUOYy9yPHKltM0tvFFCAe9imdTOHjiI
	2MsB3Ojkl8nK2lN3Lprc67GycMWbmIk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762798170; a=rsa-sha256;
	cv=none;
	b=hCf4wgR8cT/ZZ+u+yhBh7N4RznrO9qQzZX3vz0hczB8IHjevGuZBGY+biBKShMAmKbsphm
	qLB65LJtiOLmjAFxZbDluHpVQO9qc8iFGE+m0mKM4w0P0/lC8DxMUitH9ut2Ho7tO7oyCA
	wGPu93QCcFfx80+kOE92/QqfZcx27F8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of 3WSoSaQkbAEY067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.208 as permitted sender) smtp.mailfrom=3WSoSaQkbAEY067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-432fb58f876so116872855ab.1
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:09:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762798169; x=1763402969;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SfVHyy3yInLiUbcIqZnocrna0llwjFI7de3HK7K21Js=;
        b=P5cOPNdAfBS91Bn3hjpX9OOISl12APxIyYwDtUETMI8i5kJwmWFULlqKSK3WE1cI4p
         42l4FNj3l0FP+2j+W7K9qneUFmCETSICjdouTZaHo3ers2O1oRU5ylsTScGulTf/paJ+
         hqjQzcCa88TdGvSze2M6wJ/On56SW2LQT9GKgUE83zHaMyS+UcUTbHR83vmRMLMdU81y
         OSswi5t10M1Z4+oa4C9tn59g4ZNfGQu24xgnX9pxS340UZRD4fbBt9zcUujWaIef1HD0
         a8Nv17c+C1Ao7MJqqKh49/icqeYLJNdYullnUoVOgoSVM+eVTUKdX1CQYkkaboR+LXAN
         KNOQ==
X-Forwarded-Encrypted: i=1; AJvYcCW9oM8Hxq9UKNXCd6cvfZ34fQDClujZTZ392m0+1Ho3InsEG1uKQSmPPRtpK4u03WLbNhc9fdQklg==@kvack.org
X-Gm-Message-State: AOJu0Yzh0b7LW3EtLcids91wfnRlDksAiYV1vnOj44OV5dF/9EReK0/c
	cbVm0xwBHuTVtfTMd8zSiuOfV+5uJLG87gOIbePZ2K/ZQO1wVlErezwkI49bn5x0rR8AXUQk5M+
	E5po0sTU/deePdyV4u+EaCN0dY/yYmwg1h5okEwfAOJ9V1ObIiPIILS1vTB4=
X-Google-Smtp-Source: AGHT+IEIv86/SSoO/EP6AO48d+5zrweh+PuwtJkgQSpsVtjR0v7vJTjEvDwvpKUi6L+0B5BIcY2f8or9qjw9c9rSoNxLbNJSknPI
MIME-Version: 1.0
X-Received: by 2002:a92:ca4c:0:b0:433:5736:968f with SMTP id
 e9e14a558f8ab-43367df3cd3mr149960695ab.13.1762798169416; Mon, 10 Nov 2025
 10:09:29 -0800 (PST)
Date: Mon, 10 Nov 2025 10:09:29 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69122a59.a70a0220.22f260.00fb.GAE@google.com>
Subject: [syzbot] [fs?] [mm?] KMSAN: kernel-infoleak in hugetlbfs_read_iter
From: syzbot <syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com>
To: david@redhat.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, muchun.song@linux.dev, 
	osalvador@suse.de, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 816CA8000D
X-Stat-Signature: ujbaisurqqdjx8rdsa4d3rcnyne85m8b
X-HE-Tag: 1762798170-787985
X-HE-Meta: U2FsdGVkX18LCshaLgwCpbcrd+8YzINXWTpHITGakq2aeINkvBz1qg8gq1tr3dWvYqFd4fcy0YayM6PmA/1uHJwt9DTsDG3HGBwag8uQF68thRE74JxeZ+2JD8cxu0knE/jLSqnM2TT+PFiGhtIL4uHS6y6BS53E49ApBIUkSWjUX49uEMEmZvAzxmzzc80SetaaS4s/EvDshWYi063diYJN+6RaeotKzm3DVU6h+PAV4NxgmAvqca1HNedIfg/mUt2CLj5MM8bTIq+Fm1c86QKv6RNfHVXDEMEQzYNPam90AJNB4SESwd7aLJOVHJ/Z2rsScRaFjWvSmnkW8eyWOKJqsDVRDNV0HuU2A1W4VGoa72USrgdKtIxqljkydTA+EDQ2g8orLtsCsloeGogd5Q5gnhRoT6QxniQGKTJ4BdLnJTskoYdEXwav31K2aPXN0sgZS2XN0R/DHWqZwzU1ltvwKFmH+ixW3o1jGv2BkYWop4a9pFXSuLv18fjEHzDlAN95ovZ5WV4SptNNkAOcwFYpGN9v5JqyNe/5QXON4j78THeMeDgaIh4EAW8isKKxV75FlT03Lc1n6xx4CfVAHx7iVsvAig2Evz0sBHr9SZfNtcIdJVRHS+snAsFB1rGL6oAJ/4FvpsC10IbAR2j/c/k1317NflDj+EwEgrERKtWyGCMAbfu48cNTkzS3N7ZbLWMmVv0iNbB/4p8ljp2vBGPbk12T/I7lpkH/zBzzX1ncsbQnDleJRXnnEyi2APTpy55m67IomhuyGjtAu0wxzWlBW1IXxJl6rHE3ugAn9LD3GODSx9W2TJ/qGikMCqL2zKcnvQqkwnpPQewiHOXi/3gy9ZskIchSc/Dyewr1RljX5jx7xzZL7Wq4zC+3jY4ZzDKm5WgahyrVExIlYOzVLrVDITDOpifK6rRPeYayk6Qoy3bceAnIDVl0CCaPMebTn1mRQtdiPbBq5Hg6mBp
 AhH6aQJ6
 28y4jK14PgWn3xd1kj+noPz0f2WNi3VX6Z6wl1w6LVE0YkO40umj8MtxhLf/+OoCj/JF6Ly71C/MBHsrTD4T5ZXWu8Jm0OOTrtJLSLaSLZJuuUmY1/uhCf6EHw/HMUCiupo6MrQS0d+6xwoevij+5hLZt5B5nPIW0cEmmWr4ye+N4WYwauh0E7VWI3mGhVt73ImGILtsLGBBtx/nKCEIXd1viJRWLB4MrQEQJJH+J2QuZs6Bl1gMkPSpjv2RhhKx4XKTzcvQVoAnQqKXXCmhT3gEnIf8nI9ib3OimTnZFmePsXjmfJaEQEO2dbSl3yo0nFA0I0PI42Qd17fcSV1XNmzExoIXuUcDqbRFrHhpuuUEyT9EGA4eat02PlOvP4IgFi7v2LnvWxkStTASDZxe52M49Wh/TagJQCfeTwXYESTKu94X3AFLDgLvn8rq2g27PfenWRXUpzgDQhz8Mp/F+J1F9TvW7tKKn9YgTR22cgxMKP3stLd8MIesoNvK6jly2D6MEPrfMXonKRpEXfl2UumJGsXt1/8r4ScHLqZwlgLuIa72FLm49+zniPmFB1GxjrbJMgjx0CNCwYOrxEcrbZDtNmJsf03wUstR8qtsuIjaTYavqWGp1rcj91x6XQqTxVy7b4Pvg9fioF/0xj5VIgjl/V8r8EBct5iLMvKaP9qhM1/7RsvBvMVeEnjdtO1ieiQeGGZbMiBZDLBId41H2iPQcsknw/F1lJP/PsWPEj6H4zRvGSKGDKU584l/ZYQQLj7gUPHy3OvDRWtRqOVoKFtBkUDkXydNrxFznQnNMxOTvfAe/07zAyB1H8vyWia4zEIft+kdYY7/lHPy49wWRfS0KOcTLFL3YgIHXzMCJPebTsJ5XQUX55XEv+A95kTV5ncW9L+YpFvAIG0lhkVGWYMHj2zE73ym/SPdKnAkxez8Ha1UuSD8bdxZ19vDikLw/bfJ2d+G8GI0Lm1YEx+Wjft+4jjsM
 UejGLaGN
 nmLJ+/CgSX+1ZDiwz4hN7QU3Onn9cqGod41gXN3AwT/NTMJpDxIJCXc+S8tzMqYEkh8PryvGviaqt5NsAVak6XAuFhlt2mTQuI10tdyV2LtVvhx103IJ7GDJSBfDq9mv+vp7PKiF9ecJtTKODitoXiQjBwogjibcvYAA22JI54/fD9hPgufNzs1bGwF1Q1opkgKKvMNDCp/m2OtxLHsTcSx8Gj+s/2acriY0bsplpREiCX9bnduQKGeYJ/zAo+L6FRAIC3flJNSDbfW9m9sHWceQ0f5Pf+Ni8hziTuSwKeh38LWcjLOXpclp9B8qM1OtfvIEWLf7Wj/s8ZQwtri5arX6Qff5wbJq0iHDtnILapvSFZNqFjao/OHOjmV6DkqAA92A8THwBgVe6hgFQxjteMjTIcYFTKtXYA6R8PBprUA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    439fc29dfd3b Merge tag 'drm-fixes-2025-11-09' of https://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14c7517c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cbf50e713aaa5cb0
dashboard link: https://syzkaller.appspot.com/bug?extid=f64019ba229e3a5c411b
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=107f3084580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10634b42580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/cfc76859b0d7/disk-439fc29d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/1a4aa2e08e02/vmlinux-439fc29d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/24591c797483/bzImage-439fc29d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: kernel-infoleak in instrument_copy_to_user include/linux/instrumented.h:114 [inline]
BUG: KMSAN: kernel-infoleak in copy_to_user_iter lib/iov_iter.c:24 [inline]
BUG: KMSAN: kernel-infoleak in iterate_iovec include/linux/iov_iter.h:52 [inline]
BUG: KMSAN: kernel-infoleak in iterate_and_advance2 include/linux/iov_iter.h:304 [inline]
BUG: KMSAN: kernel-infoleak in iterate_and_advance include/linux/iov_iter.h:330 [inline]
BUG: KMSAN: kernel-infoleak in _copy_to_iter+0x4e4/0x33f0 lib/iov_iter.c:185
 instrument_copy_to_user include/linux/instrumented.h:114 [inline]
 copy_to_user_iter lib/iov_iter.c:24 [inline]
 iterate_iovec include/linux/iov_iter.h:52 [inline]
 iterate_and_advance2 include/linux/iov_iter.h:304 [inline]
 iterate_and_advance include/linux/iov_iter.h:330 [inline]
 _copy_to_iter+0x4e4/0x33f0 lib/iov_iter.c:185
 copy_page_to_iter+0x482/0x910 lib/iov_iter.c:362
 copy_folio_to_iter include/linux/uio.h:204 [inline]
 hugetlbfs_read_iter+0x6cd/0xe10 fs/hugetlbfs/inode.c:281
 do_iter_readv_writev+0x9e1/0xc20 fs/read_write.c:-1
 vfs_readv+0x34a/0xf30 fs/read_write.c:1018
 do_preadv fs/read_write.c:1132 [inline]
 __do_sys_preadv fs/read_write.c:1179 [inline]
 __se_sys_preadv fs/read_write.c:1174 [inline]
 __x64_sys_preadv+0x2a3/0x510 fs/read_write.c:1174
 x64_sys_call+0x3064/0x3e30 arch/x86/include/generated/asm/syscalls_64.h:296
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xd9/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 __alloc_frozen_pages_noprof+0x689/0xf00 mm/page_alloc.c:5206
 alloc_buddy_hugetlb_folio mm/hugetlb.c:1944 [inline]
 only_alloc_fresh_hugetlb_folio+0x2b0/0x1280 mm/hugetlb.c:1984
 alloc_fresh_hugetlb_folio mm/hugetlb.c:2003 [inline]
 alloc_surplus_hugetlb_folio+0x178/0x5c0 mm/hugetlb.c:2223
 gather_surplus_pages mm/hugetlb.c:2415 [inline]
 hugetlb_acct_memory+0x759/0x2420 mm/hugetlb.c:5331
 hugetlb_reserve_pages+0x10d1/0x26f0 mm/hugetlb.c:7347
 memfd_alloc_folio+0x20a/0x7b0 mm/memfd.c:90
 memfd_pin_folios+0x10b3/0x16a0 mm/gup.c:3523
 udmabuf_pin_folios drivers/dma-buf/udmabuf.c:337 [inline]
 udmabuf_create+0x1256/0x1ed0 drivers/dma-buf/udmabuf.c:434
 udmabuf_ioctl_create drivers/dma-buf/udmabuf.c:486 [inline]
 udmabuf_ioctl+0x2eb/0x5b0 drivers/dma-buf/udmabuf.c:517
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0x23c/0x400 fs/ioctl.c:583
 __x64_sys_ioctl+0x97/0xe0 fs/ioctl.c:583
 x64_sys_call+0x1cbc/0x3e30 arch/x86/include/generated/asm/syscalls_64.h:17
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xd9/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Bytes 0-5 of 6 are uninitialized
Memory access of size 6 starts at ffff88804480000f
Data copied to user address 0000200000000080

CPU: 0 UID: 0 PID: 6052 Comm: syz.0.18 Not tainted syzkaller #0 PREEMPT(none) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
=====================================================


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

