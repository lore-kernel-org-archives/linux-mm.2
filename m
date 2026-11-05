Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35F0B606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 11:10:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4880C6B05B2; Thu,  5 Nov 2026 06:10:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45F1F6B05B3; Thu,  5 Nov 2026 06:10:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39E2B6B05B4; Thu,  5 Nov 2026 06:10:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F166C6B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:10:45 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9585F1609BE
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:10:45 +0000 (UTC)
X-FDA: 85400797650.01.CE63014
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by imf09.hostedemail.com (Postfix) with ESMTP id 02D91140007
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:10:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf09.hostedemail.com: domain of 3M2TsagkbAAw4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3M2TsagkbAAw4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793877044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=+L1oAYLc4izPsxQ3ZlEqD/dH2fKKby+GXjbBwuzoShs=;
	b=REXEy0Av8JilGO5/L06etOVOvJsA0jJV5n/oIZEk0wN/u8cn7WyoM0roQflMPUycraWBBo
	j7BCrVWals70lLMMhNFUJQ6PKzJXMRIjPBQ8wLC24uLT3PDWtQftmBfs1SAXLOGziMnPoK
	lW3Szj4GaNMFjmUzMFNRWBwWU/B3KK4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793877044;
	b=VCf5mOmwPF+RD9GnHvhOMIMX/IIRwrHEuiFAEug+t0bZBLzjHpi3T4FjM9dqMo4bqHUxec
	nOnIvpzhMiVgv9u6JtZpVvm+9/+U6yTqjp4M4Ejz4ufwSho65FrQqG2rooLTrKQeBXOTYl
	xjEeZdQQJYei2Lsq0/YEIXTHnARDNBU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf09.hostedemail.com: domain of 3M2TsagkbAAw4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3M2TsagkbAAw4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4dc57e2a3f2so2632012b6e.0
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 03:10:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793877043; x=1794481843;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+L1oAYLc4izPsxQ3ZlEqD/dH2fKKby+GXjbBwuzoShs=;
        b=eAXyQlQ2M2IgPyDRGLdxzrT+vgbbl4/DDDQZm+somtQI7hi2oc7heYsOadISAONX+3
         3RtfMSG5BB3L8+N3NhHzvDp79EnVXnmLSsBtTN/F6PGTsf+i2wz1BukwxShbkmqyviud
         4OKbNRm5pXiGjm79VJI0td8+Nps2HdIp8v/V6qCbmBVePFIvD64Uja/DYqKUTbt+RazQ
         fVyHphQCKCOoLUx5FLXgt8dR/EYZU/UXl4YTaMVc6sR/afDi7FRJ4R/3rbGmNhTaXT1S
         BdDYDPY44MPpfUwvsiZiphzAkHR/+u/NH5T3kk9aGr6pQIVSBo17WhM5Rhn+8empCvX4
         F8NA==
X-Forwarded-Encrypted: i=1; AKwUvByrqTSWZ5zONFKsOj+l6OqoDicPeVyD0dZZYWrcWPEP0vV36hw9vDEAtXD8DVua4QQru3rnebtP+A==@kvack.org
X-Gm-Message-State: APuU4Z+oK0HtaVb68reFzyFxcgnAlrp9hcQU705TeW5R0WSDdAzxX6w0
	zT9WGFYRVQb0fFcLUWqy/QIylD6HbXRLg6XgYltR5a/ksWJiSWT0LI6lhP5xxBF7rIcsbkGAaKs
	BSJ33gRq56Rtgs7pRsVIyskXgTuLKm7ZPqn1szH/OuPFLem4UIhEQb615DzI=
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:148c:b0:4b9:e65b:8c36 with SMTP id
 5614622812f47-5640dddd764mr13267830b6e.36.1793877043177; Thu, 05 Nov 2026
 03:10:43 -0800 (PST)
Date: Thu, 05 Nov 2026 03:10:43 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aec6433.0ce67c00.35143.0001.GAE@google.com>
Subject: [syzbot] [mm?] [fuse?] WARNING in shmem_initxattrs
From: syzbot <syzbot+4324f771847cecb27c54@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, baolin.wang@linux.alibaba.com, 
	fuse-devel@lists.linux.dev, hughd@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: jse85w4y8brxc9x14wu7o3odn8wah6iy
X-Rspam-User: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 02D91140007
X-HE-Tag: 1793877043-506702
X-HE-Meta: U2FsdGVkX19LAEsQ1b5qxRv2GT5UJWacdYtbgKi+omkvJCHlkkfT0Hz8KmkCBJzf0GKI5yydRHqZSiGJpNCzTC6J78j7vlOCSe/cars30t4COwWrI29ZWDJZkr2BBVa/9tNkt5YFaQIgLKPTrqEwZzLxWd/HedvVcw277JhGzZK2EhKq9R2K0XAA78+7oyCyb88c5lgqv/r7ytvr4g8U7zE/wd+pY+yaYFXPush3KKMl/Iy2/ybMb38pjsSR8C/trZodApzu5bl2GL7knvAa1upE8QIEtv3tMqsmvTUUKJhKJ03dVjkkwxlcnkPGZOqzdDP04lu+z9pE208IQbFlWhTDtyc78UDDAYYp9fNQ8AuN6jkgGK/ILL56VC9EA+GHauCdmEPirg7mKWv0Cal2TjQ0xTsMd9G9GkIouWfqzcjr1n1d2sMTogyG2QWZG9NhXK8zc0R/XsZhQDuQi9vwTbApUKY5GeSozi4tN2Syx1CBmJqxzjS6nDgXi9/N+5oDDmvMI7In2G1rdzqQiPqWUrS4uWa4oHF9muMY6toi4UxbdyLGr579kizNBHkcv5TnsXNGXTdlEQjZYn2tqjYU3bliPxlgZLo1VrwYycIHAzClVo8s9gSUX5+6gjpxCApgga1zByrZ/eQS3+AwniRUuA2CdeUCbH2aqnu32pEZIrz53kDfam/T1t5xKiI3oCW985nFGyw0L+VtoGp60MFZ4yys4Fwg9bbCQf5AZxnpjnuodLnFyHNp6UcLAy2U2B5Lvx6YZ90F8UkdMncgHWjcffN1QBVZve546xkkcPsLzdg0OzABz/Fn20LOCf1MBGEuq+cl/LH6Uu6gwzTZYMCtwHDFRrvRBDbS1E22tO3sWgbCgxQKDFSd7mA0Le4aRq7vPSUhdihhE5HPWzd3kQcbA7sUm8bhjynXOxFLF7sYwSVtDKmAQcXCLb1E0DumpeYtdeWlQmuYZCAyuKOgVsj
 SosYk8+i
 n8CpkcD+osmBtonPu7XQztMEc2MhrtC+n7CWwV5agedr0KqRq9INLxUlXWros0lt4Cc5tcMmJRbwWo0dkzXLI6ZPpyt/voXZhAyoI8V1+021Uoev8t1w0nrfDIMGxPrxpuparA9fJnosyv+LCITgFTQzuQtU5CjzzlbhdHhM0lVg6IHy1SB+RJ9ydIrgPxxyGFRB5WcyEpa1cbMZLCDFJh/yvDwkVftg4V2pgCgYEksUxk+vDv2DgPP9Z5UqItzPFsPcIr7xZNiCDyhSxtCZrQKp2I1VSBGbibMcHJHoY2Eh7y3W124uRADE9CbCktouZ25Cpyhu7aQiTeAtfg0OZVgf8bCpl21tYQ7CcSeF9fTYtnaYDvqU7WrSS2qZQnxuqcxixcUj1rqa8uns+oM8Qp6sotHYDV02qffgDhqSU0UVULVITQTcAQf/Irooo2aE/zi2eCvW+4jKAihiNYZW/QHhfp2xXaUa12LGE4+zw5CJi1mxNu5oknU7jPfwUHqWyfRLySkJL3AfvZgS5kGXcjYlPXJmAqmKDISxVtEdrauzsl2WqfFnwPug50k3HrluLcWblE+QM1Ydvh0kw78fJ6cwLJSzicKxqae9+3dLYwGJ7UdY2s3SiLAbaFrB2Vw+KcMXpGpY3M7wCatXhSk5vpE75Xk0By0vXfCgzm03OG+GAISw8pge82Ue0iAp2yAZqPlcyJUfi23MK2uEPiyc9F9KkqNEb8l96AtM2GmgSZQGRFR8uLkUSpWzOTKBwqZtH+PXBoHLvkUZ58F98zoEMsYCWVf2ip2vlBxzK+kOcJWjzU6NgyyIX6xR+D/YZdQddcJuA5p5sY9NpYjU0/9CT2OAnlkkT6xKu9KKfd9I4ZedmtLklPSmvha5wchlgWuioOb8V4acY0wImNDqeE8qqAjfl7XG7N9TyQmdxwnad88b0DqsnMZbfNoAsX6ie0f0e4qkUCEmytdZeUwdxHcF0fvV0BDy+
 69LatN9Q
 51oN0rV779eNxiJ/k09Dz3ZRP7oA+d0Kw58LtFFdfB/nilZiADWPLWJP2NnDLz0bfSTRx9fK0gzOGIYAhm+e39jScbgBqnTW01Qd8S3eh1V4FN6w6yskaFSv3s6eiUyei88qqb6X5JMve2cQTEgEsW0vePhdClb/AB9JqS3lvmrJZ9Douk32qiSDKploCSUPXlqwdIQJ9rTNjO/HfP3BW4uUmAQgdEhn353/XnwQrzp41GCUG1HAqQAbK8wfMLAwh4h7gWB967q7gvru5WQGG0+Ak4J61MsqIChZK6VJ90CBBKVMgIkUYGQQGTjnWTN9ZjIhjmMA0rF3CYj8n/45FzKih5G4g0FoplRA/t2XK4ciMTNc4dktnNUb+CUaAU2+CXf49y/ooXOszPHuLdbS+y9y0nqvnwnJICTtZWUQLSnfW7zlGEkwJ+raD0DxlaNZVatuTf/po18=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello,

syzbot found the following issue on:

HEAD commit:    05441d697f7f Merge tag 'cocci-7.4-rc1' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17bcaca1580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1cf189394a856f11
dashboard link: https://syzkaller.appspot.com/bug?extid=4324f771847cecb27c54
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14423cbe580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-05441d69.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0edd3964be19/vmlinux-05441d69.xz
kernel image: https://storage.googleapis.com/syzbot-assets/84d6d8dd5648/bzImage-05441d69.xz

AI-generated root cause summary:
In mm/shmem.c:shmem_initxattrs(), the initial reservation of inode xattr space
(ispace) from sbinfo->free_ispace is gated by 'if (sbinfo->max_inodes)', and
subsequent per-xattr subtraction from ispace is also gated by 'if
(sbinfo->max_inodes)'. Because sbinfo->max_inodes is accessed locklessly and can
be concurrently modified to 0 during a remount (shmem_reconfigure() with
nr_inodes=0), ispace can be reserved when max_inodes is non-zero, but fail to be
decremented when max_inodes becomes 0. Consequently, after all security xattrs
are successfully allocated and added, ispace remains non-zero, tripping the
WARN_ON(ispace) assertion.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=4324f771847cecb27c54

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4324f771847cecb27c54@syzkaller.appspotmail.com

------------[ cut here ]------------
ispace
WARNING: mm/shmem.c:4451 at shmem_initxattrs+0x3f5/0x650 mm/shmem.c:4451, CPU#3: syz.1.18954/2882
Modules linked in:
CPU: 3 UID: 0 PID: 2882 Comm: syz.1.18954 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:shmem_initxattrs+0x3f5/0x650 mm/shmem.c:4451
Code: 03 80 3c 02 00 0f 85 5d 02 00 00 48 83 3b 00 0f 85 fd fc ff ff e8 6b 3b ae ff 4c 89 ee 31 ff e8 01 36 ae ff e8 5c 3b ae ff 90 <0f> 0b 90 e9 dd fe ff ff e8 4e 3b ae ff 4d 8d 7e 78 4c 89 ff e8 52
RSP: 0018:ffffc90007eefbb0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff888032b8d818 RCX: 0000000000000000
RDX: ffff888030c3cb00 RSI: ffffffff82602984 RDI: 0000000000000007
RBP: ffff888023be9000 R08: 0000000000000000 R09: 0000000000000053
R10: ffff888037378973 R11: 0000000000000000 R12: dffffc0000000000
R13: 0000000000000053 R14: ffff888054123400 R15: ffff888023be9030
FS:  00007f7a3de3d6c0(0000) GS:ffff8880d477c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7a3ddfaff8 CR3: 000000004e80f000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 security_inode_init_security+0x242/0x370 security/security.c:1384
 shmem_mknod+0x2ce/0x480 mm/shmem.c:4039
 shmem_mkdir+0x31/0x80 mm/shmem.c:4094
 vfs_mkdir+0x36d/0x8a0 fs/namei.c:5428
 filename_mkdirat+0x4c4/0x630 fs/namei.c:5461
 __do_sys_mkdirat fs/namei.c:5482 [inline]
 __se_sys_mkdirat fs/namei.c:5479 [inline]
 __x64_sys_mkdirat+0x89/0xc0 fs/namei.c:5479
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7a3cf9fb19
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7a3de3d028 EFLAGS: 00000246 ORIG_RAX: 0000000000000102
RAX: ffffffffffffffda RBX: 00007f7a3d226270 RCX: 00007f7a3cf9fb19
RDX: 00000000000001ff RSI: 0000200000000800 RDI: ffffffffffffff9c
RBP: 00007f7a3d037b70 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f7a3d226308 R14: 00007f7a3d226270 R15: 00007ffe3809a618
 </TASK>


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

