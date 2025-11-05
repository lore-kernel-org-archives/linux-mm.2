Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6355CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 18:38:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D01068E0009; Wed,  5 Nov 2025 13:38:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB0418E0002; Wed,  5 Nov 2025 13:38:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9F9E8E0009; Wed,  5 Nov 2025 13:38:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A22CF8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 13:38:38 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3A5C358F8B
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 18:38:38 +0000 (UTC)
X-FDA: 84077414316.04.C8DF41E
Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	by imf09.hostedemail.com (Postfix) with ESMTP id 82BB314001A
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 18:38:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf09.hostedemail.com: domain of 3q5kLaQkbAFwMSTE4FF8L4JJC7.AIIAF8OM8L6IHN8HN.6IG@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.208 as permitted sender) smtp.mailfrom=3q5kLaQkbAFwMSTE4FF8L4JJC7.AIIAF8OM8L6IHN8HN.6IG@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762367916; a=rsa-sha256;
	cv=none;
	b=E4nz/LF6ULFxroEpreNjyf7mQV5c1eDMGjkI7PS+y+PTqMsg6WOTgbc7zO0nQOAykDQyl1
	AlTB61K29BBY2JJouxLM3l/tg8MV92FE6rZC9wZxRoM6gf0H4+tsETbW6scnjTiCEzidFa
	B1Gz6Gm9TJb7K0m4cTSAA6TfcKc1DIU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf09.hostedemail.com: domain of 3q5kLaQkbAFwMSTE4FF8L4JJC7.AIIAF8OM8L6IHN8HN.6IG@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.208 as permitted sender) smtp.mailfrom=3q5kLaQkbAFwMSTE4FF8L4JJC7.AIIAF8OM8L6IHN8HN.6IG@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762367916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=Mn+BtCh3vOD0zyKs8XLSj2XvKwZSbGcteQATczCoPMs=;
	b=TGEjrEhZtq2nb2+1oz2lY8z0d2Eg14mfTQT0SMU6jj5ABz3acUYMAu4b4irYEuWB7MfNfB
	1IgD4xR+D5vgq2t45EfgDfjJMzO7iuOEkeSmLRGNL3TxbAsuC4pfr5xEEbxvDrz8rbN1wE
	0YFPjjkhusR4rcTmb//6S3kLzMp9muY=
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-4331d49b5b3so3131405ab.0
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 10:38:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762367915; x=1762972715;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Mn+BtCh3vOD0zyKs8XLSj2XvKwZSbGcteQATczCoPMs=;
        b=wKNyI3aZ1lV6ZtpO/WVuYsggxux9ESCjqxsY6MlDmLbeAiJUnDhv2lJ0mU7oZGhA41
         +RWxj0AMQ6RetuDo4aHPWFrtbnQOuC4rcIS0ZyoDWdTieVfVOJNi6Uhzco83lBz1LrEw
         XSTTApkfOgjBLQE27AfRCYkHJxhWl0rNSNYAzswOIIPC5iMU3LGI1EhMVdHVxbrSy5IE
         jD7sPavNIXW2ljVCWkutk1d/FOGcfJDNYgTQWWrWrAeDNESEDaBe4j4B+qCYX1XpRerF
         b/1+M+RF4Ku+4e9xZ2PBxK4Qooc4NExDLAVRWrcB0PJO0SC+MT+/vBqfxfWrrEmgFlRZ
         ea7A==
X-Forwarded-Encrypted: i=1; AJvYcCUcLiWTQrBoogMGPc1GWsf+wFGlUnUS/5mA3uXRj3MEw/5jbHCkbx6AHjmVxr1D7la9rwAMdKTjoQ==@kvack.org
X-Gm-Message-State: AOJu0YxEt6KR7cWY09FuYXyqnKYllhOK4AB7KEaCoLP+6pnTgzRBjIr8
	O37rdkzryJs7rmiHsutYRPiGhyaM/NTxdwp8oKQapt+rKegXpKTzbbPIv1zJNRU+Moqr4n91CzE
	M6OOSSmNBDq2Bvxr3Kmnc5uL3DYXTkj3CGV8TAqqqYKzkoaAsEvSOE8EvS/Q=
X-Google-Smtp-Source: AGHT+IFQpl8lpWxtSbzVqHE8LKdmISAAPmjAEteuXxAB51ZS87fITIQFSnOHk5W1KhqRM7pMy/U7YUh9m3ZljoGgW5JVcOkArmV1
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:152d:b0:430:bfbf:4e4a with SMTP id
 e9e14a558f8ab-433407c0a59mr61771605ab.16.1762367915570; Wed, 05 Nov 2025
 10:38:35 -0800 (PST)
Date: Wed, 05 Nov 2025 10:38:35 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <690b99ab.050a0220.baf87.0057.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in lock_list_lru_of_memcg (2)
From: syzbot <syzbot+c5b060ce82921a2fd500@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@fromorbit.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, syzkaller-bugs@googlegroups.com, 
	zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 82BB314001A
X-Stat-Signature: kyjd3ty3qnfeyroszwgzwpzcoeb6amj9
X-Rspam-User: 
X-HE-Tag: 1762367916-308841
X-HE-Meta: U2FsdGVkX1++E0S8cN1xqmc91wXw7UznRV03mMpBIPFg6UECguVUlgB3/UXKL5jcZgM/hLYVjJlqmSL6e1VrP1ddo1rFZiOCeSY8Iw/4PwFT6koRFFfP8fshaCL4AWMqcYE15vWsSYz2sjzc7wpnE9kFADnoxivW9RMMfynZTrA3GfESn2e5qvGjTFkH8k3grxxjGeRaBsP6oNrGxEeaLbYKw4JSFrClGO6/aWqgYn+pquqtABCwumEELqC31VvEd4uFxNeSm5YjP2CrRbnwkKpOHTxjWTehWCDsIPalbnO39JOl1qIe51JJf7Drcf5P1ayNTqL2DGsgBfZJBaXOjlmiWuZNhUum/8yhUQl42Nsajdscl1SNPzodux4OvMjuSuO521I1TDiebCuWfpQ5TE+YDPRPQB/Np5dCMDbu+1JR1VgWNL3JvUHWpT1lPSEJe5Fddjd9i0+atN7As2ibqUMom7E6h+x4sIbn5NSgMFx37TKQ4HTmkni0zbLmGSMLH5D94XKWuXUl3a9f8L7A8YJhZWot/p4DiAGiI1tT0YzXOOqqPiXeHPQIf/wG0zkjAgxYVAoknpwXA8krlfB0zsW705SFztPQU1jZ1kgzjVmFph2vYQyNkpN1nsx5xMkV7NawPQfNwcHiLFzEwdYgw2ZhFcGtrsDLOI1TfSDqX4l3ej9WFhYGkotP2IKbTQ37yyvyMFSZ94OQ6MxPCLdYvz5zhIygEeHfBZAFbsXeNGl3y6+lIk1/R0m5N39PEV4/t6TGEgqp6XOFlkix3WplrbtK9KSJhi05VWXY0KbgXgt2YVjDLyMx2M9lgF5rq2PmqruDL4GyuqCqS0EPUNWIIKSNumGrbyboOMxym+Fk32x87PQz3RqoSi9Q9Fxssila1wtMpGhoL0Ul2ksUFVmqmGS6iG8p9Grvn+EKmmZddsF5PRazPgjKB6mbk3IlFlwKTeSZ5i49HTe5K2sJn7a
 emS14Zzx
 /dx26Qmo33zdBoBXdqFYNFMT+XrQCTGWdEMmt6GDdplmJEAZWQbDTaVK/FVJbq00egM3GYYgNJLWgzVrsZ+46OMg1v/khukR5WMz4/Y4TtJ7xsEBwi8ZE0E94Stsr2OhsDNWAcv7ubAS+vrcyiGCsLEJyxkBQPIpNlp3j015ohi3VGlb87tvQ6xJUiSYxFaDwGj2tRJh57nnnqK0PZjnq5y96EsAVv+wl66dw7H0QR4s19/H4rEyD/GdiPSua0U1gMQzG5spB0qjvF+hvWSP7+9GQovb0H5hlmtOpooD53TX0dmU5nGRB3zKriL/cc302VxU600mUw3LRSlpbdMzJ+CZP0n3MtZDKDD01zQ4LZ888rAL3r5rbWbmiMTxYWkx6lGskfYLj4MyVoAD/YJTidP4FeSm/OCWH0x3r5am0RvDDSu0LLXV9eTMciJmoeSZ7z8JGNJ6Qt2e3xOVx11bSkzxsIiXfpflolsrwI35rrlsPNwSZbUVJ0r4raA/Odr0LF6FX+bIVq9Gb6sGU4dXrrun4Pyhe6DgVrYi8hQ8TpPFL+H54i0axCN5aQCwd16YVpV/OW4nMT4qGcAaXZLun5b8x2qQfl9rAOhEONSdNX2sqGzv6o7ztKRXU5DQcnXhDp4yFhIJYKxevmdppLMHucfePV9sQYsYLxE4gZ6bGvnrpaX7juEJOtZOKxMSYKaE56ussOFYx9WBI7NfckY9UjL9mVG8y9x6KkvFRu7USj0hFfVHUlTYBWv+aQXtvmVIKcw4mdGXXdH0vRlzxcZ+few167xAeFFE0iZ09RX/RkRk915+CXz1CMKHLMFmwKyKvPKfMI4A/3swXgD1R3rBAiZ/xR86pZWJWK/T6c7FFSUoRGTrWtVGQAvrI2x1NAxPZbr+FHzdz6lfT6Y2TCwBWPO0ocSeRBPYrR8mGhyFNByndoSQR9S/3yvxFlfQPI0qDrT4sjaR2xW4jw68m2LdCsCct2SsC
 q/ezJsrI
 sLCbYv6hUxZM8Q4shZ7LIypydvnytlV92qKl5mkHLMNVRLxCEkWb6HsIMWA17iHmFVk9tPMCI1+rO14XLdFTc3O7W8QrmBHgmFmcR4YTO78JoVyGHGzmKg1D9lT9owDL5R1JiNJwKhPH5RoFFFtICZImF91nKX66h4BynVMNR2GuxK0KmUtzZX9MzSPL7dYS+J576OnTZXb7g5vPkliqpYxVIPrCczImaAsGVZdMteDmHIVbYPSJVOAAhYKqHtbVBDGeWnkC6GXdVOixGNmqTJrL9am708yKYqMVcHeDITEdcXMXCfA27TwZum6sKHEFsSDp3s7UMG1uIeeQuqDs9BSW4FNCivVpb1Hh18EXvcub6Me34GVjWt8ekn4Y4NRfcahm7yfF/N9Ovi0njC9dKI7QrcFoO4D6p0AZL8/IsWSx6HRemJfVFhFgtXa5ea4oxUvq8t6qmGUHoTPAHLEWJRKRKi+BOXbGW2dTFCeS1o86CF0D1cy+j6SxJajOM+Q54OmhrCZLXNC1hDuEmEOgvg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    ba36dd5ee6fd Merge tag 'bpf-fixes' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16515704580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e46b8a1c645465a9
dashboard link: https://syzkaller.appspot.com/bug?extid=c5b060ce82921a2fd500
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/62471ef815ed/disk-ba36dd5e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e7a72af6e621/vmlinux-ba36dd5e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/352eec7dbce0/bzImage-ba36dd5e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c5b060ce82921a2fd500@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 13908 at mm/list_lru.c:100 lock_list_lru_of_memcg+0x30c/0x4c0 mm/list_lru.c:100
Modules linked in:
CPU: 0 UID: 0 PID: 13908 Comm: syz.0.1878 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
RIP: 0010:lock_list_lru_of_memcg+0x30c/0x4c0 mm/list_lru.c:100
Code: 42 80 3c 30 00 74 0b 48 89 fb e8 2f 40 1d 00 48 89 df 48 8b 3f 48 8b 54 24 10 48 8b 74 24 28 e9 0a fe ff ff e8 e5 8a b7 ff 90 <0f> 0b 90 eb be 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c 1e fe ff ff 48
RSP: 0018:ffffc9000fb165c0 EFLAGS: 00010083
RAX: ffffffff82087bab RBX: 0000000000000000 RCX: 0000000000080000
RDX: ffffc9000f013000 RSI: 00000000000127d4 RDI: 00000000000127d5
RBP: 0000000000000001 R08: ffff88801e3b8000 R09: 0000000000000002
R10: 0000000000000406 R11: 0000000000000002 R12: ffffffff997ec9a0
R13: 0000000000000000 R14: dffffc0000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88812613e000(0063) knlGS:00000000f541bb40
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00000000f74089b4 CR3: 000000002ef4a000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 list_lru_add+0x58/0x270 mm/list_lru.c:167
 list_lru_add_obj+0x191/0x270 mm/list_lru.c:190
 workingset_update_node+0x1d5/0x260 mm/workingset.c:629
 xas_update lib/xarray.c:357 [inline]
 update_node lib/xarray.c:765 [inline]
 xas_store+0xac4/0x1880 lib/xarray.c:852
 page_cache_delete mm/filemap.c:141 [inline]
 __filemap_remove_folio+0x3c7/0x500 mm/filemap.c:227
 __remove_mapping+0xb06/0xe40 mm/vmscan.c:811
 shrink_folio_list+0x2896/0x4c70 mm/vmscan.c:1553
 reclaim_folio_list+0xeb/0x500 mm/vmscan.c:2233
 reclaim_pages+0x454/0x520 mm/vmscan.c:2270
 madvise_cold_or_pageout_pte_range+0x1974/0x1d00 mm/madvise.c:565
 walk_pmd_range mm/pagewalk.c:130 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0xfe9/0x1d40 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_vma+0x393/0x440 mm/pagewalk.c:717
 madvise_pageout_page_range mm/madvise.c:624 [inline]
 madvise_pageout mm/madvise.c:649 [inline]
 madvise_vma_behavior+0x311f/0x3a10 mm/madvise.c:1352
 madvise_walk_vmas+0x51c/0xa30 mm/madvise.c:1669
 madvise_do_behavior+0x38e/0x550 mm/madvise.c:1885
 do_madvise+0x1bc/0x270 mm/madvise.c:1978
 __do_sys_madvise mm/madvise.c:1987 [inline]
 __se_sys_madvise mm/madvise.c:1985 [inline]
 __ia32_sys_madvise+0xa7/0xc0 mm/madvise.c:1985
 do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:83 [inline]
 __do_fast_syscall_32+0xb6/0x2b0 arch/x86/entry/syscall_32.c:306
 do_fast_syscall_32+0x34/0x80 arch/x86/entry/syscall_32.c:331
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e
RIP: 0023:0xf706d539
Code: 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000f541b55c EFLAGS: 00000206 ORIG_RAX: 00000000000000db
RAX: ffffffffffffffda RBX: 0000000080000000 RCX: 0000000000600000
RDX: 0000000000000015 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
----------------
Code disassembly (best guess):
   0:	03 74 b4 01          	add    0x1(%rsp,%rsi,4),%esi
   4:	10 07                	adc    %al,(%rdi)
   6:	03 74 b0 01          	add    0x1(%rax,%rsi,4),%esi
   a:	10 08                	adc    %cl,(%rax)
   c:	03 74 d8 01          	add    0x1(%rax,%rbx,8),%esi
  20:	00 51 52             	add    %dl,0x52(%rcx)
  23:	55                   	push   %rbp
  24:	89 e5                	mov    %esp,%ebp
  26:	0f 34                	sysenter
  28:	cd 80                	int    $0x80
* 2a:	5d                   	pop    %rbp <-- trapping instruction
  2b:	5a                   	pop    %rdx
  2c:	59                   	pop    %rcx
  2d:	c3                   	ret
  2e:	90                   	nop
  2f:	90                   	nop
  30:	90                   	nop
  31:	90                   	nop
  32:	90                   	nop
  33:	90                   	nop
  34:	90                   	nop
  35:	90                   	nop
  36:	90                   	nop
  37:	90                   	nop
  38:	90                   	nop
  39:	90                   	nop
  3a:	90                   	nop
  3b:	90                   	nop
  3c:	90                   	nop
  3d:	90                   	nop
  3e:	90                   	nop
  3f:	90                   	nop


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

