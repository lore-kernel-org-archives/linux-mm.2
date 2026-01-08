Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7840D232C6
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 23:03:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1EB66B0005; Thu,  8 Jan 2026 18:03:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECC9D6B0089; Thu,  8 Jan 2026 18:03:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAE6B6B008A; Thu,  8 Jan 2026 18:03:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C6FA76B0005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 18:03:22 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 757D75793B
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 23:03:22 +0000 (UTC)
X-FDA: 84310324644.07.C73E26A
Received: from mail-oo1-f79.google.com (mail-oo1-f79.google.com [209.85.161.79])
	by imf03.hostedemail.com (Postfix) with ESMTP id B529F20006
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 23:03:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf03.hostedemail.com: domain of 3tzdgaQkbAPgx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=3tzdgaQkbAPgx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767913400; a=rsa-sha256;
	cv=none;
	b=QooeEFfBN+uyKz4JqOCUfaG2IjekyGqsxSm6LWdjI2aP976bOskF/d7c25uFdkayQ25hvT
	VhUD0K+DMjjhTT1ZV3HGkZdTMKfjIwLRwIorYMnf2xNGe+uI+K66/jJ2Zxxq1MECqvIJ3t
	85K55dOmBrU5PJ1xL+Q5Q57d561gcLA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf03.hostedemail.com: domain of 3tzdgaQkbAPgx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=3tzdgaQkbAPgx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767913400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=XKETzPrbfJ26mDxbeK5YxjWuHHbtx5euT/7rtsBXr6E=;
	b=KkykqPN+8e8vPBUaZhXaRikfakSC5U1Ahw6rs3QaW4M2mp8IpWWXCWeq4BX7aoy1ERtBbW
	FwzRiLVibkd8SSA2wft/wu/oPCWOU2IJXaUBWRao6XZOfytcnLd7Z5X931wlC2Q+5xe3BS
	h5NDKLvrrd3wvCbNokBykW7qC+y3epk=
Received: by mail-oo1-f79.google.com with SMTP id 006d021491bc7-65744e10b91so4835864eaf.0
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 15:03:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767913399; x=1768518199;
        h=content-transfer-encoding:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XKETzPrbfJ26mDxbeK5YxjWuHHbtx5euT/7rtsBXr6E=;
        b=VCL5q4xwSy/YDKPbj4zab/WHWjU/NOhqiOhKh1YnR1Bsr2/HT9yror3JSybiiwFf5Q
         jbh4RiaTaKmiLSZVcFuFdyp4g91bTpwRzz6KeRJ6iX0YsFB59rLXoRReYzX1aOVY9WsX
         dbi1xgOTy6y1anWIq+u1RFZEukv3XQz0935i5MPsvCzT3XvBBHt3jkX0iWvSUQVHKiQ/
         z15jKs7IVQZxv9nWm/yFI7cX95EyJyBBUXd75I+BQu0i+NGxNbYvunc1F4rrWpTTFhQc
         ZbhP670MUvwYcnNa5Y+CIgnS2c2py0ruOc5nB0bsq0rlQNVc9B5EBn550OEOolvjttjk
         Qiaw==
X-Forwarded-Encrypted: i=1; AJvYcCUToSYC2lZ0m5TF5unGBNCUOTUYpOezRnYH1GuIIpaP08jXhDG1wS+ZhXMOY3dDV7wC/VYjfIWniQ==@kvack.org
X-Gm-Message-State: AOJu0YwM3HGIbnLtm/jRORFQNChfuXegBp0GyEsPIlGC3KaTAkPTTppN
	wfP8XyeaYseOUsaH476/xBRAJ+Z0QkY6roJfjGVR6h6Xm2jOmGkn26t0LAIrd3cp+k9w62Abooh
	Op58s1yv1tz1yUrX3FCdAbxR2Wvq6ZlATORDNX7rxQGW1zEnaPVkWb2k+ayE=
X-Google-Smtp-Source: AGHT+IF1o3z/CzIaVKDj2130ywIDsosm60YTClo3w4OIqTNNbUuytFUQJEMGpg13ZgUczpkFJqBedobH+3i+otA9TWNV4gcNx2n4
MIME-Version: 1.0
X-Received: by 2002:a4a:dc4c:0:b0:65c:f14f:91de with SMTP id
 006d021491bc7-65f54f367f3mr2360032eaf.34.1767913399725; Thu, 08 Jan 2026
 15:03:19 -0800 (PST)
Date: Thu, 08 Jan 2026 15:03:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <696037b7.050a0220.1c677c.03aa.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in xfs_buf_alloc
From: syzbot <syzbot+941039552756d26f5e8e@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@kernel.org, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, 
	rakie.kim@sk.com, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B529F20006
X-Rspamd-Server: rspam06
X-Stat-Signature: muea66wfx6nja5y1bbuz11xfgsw9x9h6
X-Rspam-User: 
X-HE-Tag: 1767913400-941217
X-HE-Meta: U2FsdGVkX1+V1QZ2gWma7cIwkwsPuqQtFmk2nSpHyGCJC8703qEtb/S9jD6EMOcZEqYMRIaeN+Ws/iBX8rxI/eTHVkH/OMdu3YFVt6fXpss/VkTwAPVU4lfJZCFEI8tvDVGLYfKt06KBL4GoGjgZqe0yy2bCO2UZV6OHLhf2pIkm4Gd6kCHGAjPfCRuni6TVb+AJpO8sB9yEn3W0PMhVdxewCk41RICfJIeb4B+YjxKS/uup/S+rPIyshA50vSW45x2W0mwVFStjv1KcDUGUUVxgdzX4K1MJDVWcNalhv13ZluJp7GkyA2XS2rmRHSTGQbRNLT56GVX+abj048vJC7EwrAwCQhP5kcU9JLSl05iJD+hhQhbkq2Z7GA1ZINLtDa5nH3EHwnXqvSeyBVYJ1NQcwgTZNrtnV1/qTHYtFXZShWpL/LcfzU61SzI5No3j0RJvYC6RPD/cTCkQ9KoOBWYYM8OdyhrDFveVV4slGWkf4bFjNx1eoCuPKNzYDWJHFF+pjovWCfwK+9v6mRCUGgwup2sti9k1Fby8iZk9HPGn84B57DkFBCd8bKIaheTwVLpFk5IfJ/AEb6lx56lKnKmTVEaEMtbAw2TH+Zv3uQe5y3aFUHd3u+7TAuFYWWwxeATyExsweb2JY1g+jczDJ+WmT973FfXU4FjlQL3pz7iAZJ2DAQR2ozvvrXNbX+xYb38/qQIpphwmem1a0DMDNzm3AsIqMSGfpZrVJWe0HUFW48VMIAETWMN43TKzExm1gL3MnkAIB4ThAAjjrk8aepG8+PogUhwwvOAZqd/wAz9GuUlVqSsuAAJkAFbi/iQFM7eEfswGCp96KAWhGNKxn5gFoV/C5+KdywHprPBCncHu8yHKtzEt+Ee3TBvpUjbBd45MiGFc1tqY5AsjgsUDZDSO3hEjGoBB43MCg26ec2DgYv6RClO3NczIIORPheAmDAiAnC/ivKYC6H3ZYV1
 ji9yineg
 vfvHc5L7LGn0n4nQ5ninKTHsYBGmVDQv2ZNR5kiRQkh9mcIUInpdNQLcJShleP86m50rZx+zuC+2qxC+lO7Ogpst6Pgr9KeggZZzuyUwphBNDeMTxtjR9noDRS6Bsnh5xfwMt8JJ1rSZ0EPtMhwo260mWvsZI5VBOvBaMpk55Gz0IVyqIBYpWDChw5WAwBmxzP/Z6Q9npKuYzyih3geF9YLVDo1QHPsPlxzlA0IQgImD4sCJM703Y84vBD/4SDCLUVKPt59Z19P/WTBl2LjGnGImAY3hMwgGubaKUEuHdg25pi0eJkjDIaliEae8wob3hOwstnVEHnm9+fAJsk8Bn9ST5kr3q001jG8exn1TX4jiV/0xJxHSxrYiPAMK/leL4q0CYvmeV4QYrgj4tVpI1msbOnpL7Cjt5ZEnR9SgPZ7jei8aMbwAt1YjiLQCasVSlxITi9US1wNH0wu9Qk60sr8W64RPQGtz/eI/mrgLYA6YL0NrdweGCaWajgoCWBduO/MV8VRAbjmGRw041/g8zAfoRgayJKiWvAiLFloi0atUoSImw+2lC0sZ9eER5qM5cRAOJcGUwH5bZoM4CD8BxJzD2UY/YN9ALHDKAreckaTHGUkWBdH758LkzTZ/xdYg42DIwANqlP6vIr7QR8xFiwQLJMUWX3baMKPd0DgpfVFHc6mpf2XZ1mGFl8y2Ru8NkAREtskHTS/Y9AZuJh09l3p/ZaC/ulMzeRGKFvZMZ0jqmVtjl/ALnMuIxTwLtDWw/TnCs/xMHSS8z7BEQQ9XVSath8rigMe0dBbh6ymujxpkeUt1Ok2vLKmFWNnbZx/xoBMTnyxRhmeAykXvJZNeEgq9yNrDDJJMfSHryYWvaUOXcnrMtOSls3auxAsbEJkiyXemPL1xT2x42tNseZvKjFiSFa//Ykrq0+4KgXP/CAH+kzfTCMb4qN/9hf6U+AlhpuP72FSqk2P9zfR/l2wJ0AyXhGqS8
 Kwdate9W
 l3Jtdt4GAuX2YmN5j4n3Ij1Hcm7zHOsBbP8NOTDFJCbiHqr6nP0JVBkg9jVIx1PpmbWGAt5g6TEb8RhynULo1DtaPab9abVUv0xO54M8hPGDegKeNW0GGG47POS0PEu5O7sJtzLyJx74ISe0Wl0fdRH2bjCBnHofho81vxEdhwwzytTfsjZgsrsBo47h6vnm7wb9Vi9JoogGjG+XMRyDVxWe6VgLHM5+X1gHcrP04LQ5Ewy1nVLbHXlCxuF+7SVL+YTOQsEFMGxcuyPN+/Ff+aMVF5If4cWIEXop+a5L8hwgnmFJlB/TbyTmu6yR3CoDnGrvxYrWYF5r6gcOJaqwNxmHOpKf4U5vcnX+FvPKC6PRZea3w8L3s8SUv/vovt1OwyAucD8d/aOjK+2CgFwjfsoLJUxP6Do0Xzi8/OMnGcRRLhv67IS+dg64AsE3avHKJbSfyPoLN0g7Q36AVfHtjIoGHjazaltraB4cTZuUv7dj8VL90RC0xg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    54e82e93ca93 Merge tag 'core_urgent_for_v6.19_rc4' of git:.=
.
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=3D16eb4f92580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3D513255d80ab78f2=
b
dashboard link: https://syzkaller.appspot.com/bug?extid=3D941039552756d26f5=
e8e
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-=
1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d90=
0f083ada3/non_bootable_disk-54e82e93.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f3befb5f53a4/vmlinux-=
54e82e93.xz
kernel image: https://storage.googleapis.com/syzbot-assets/92820ca1dbd8/bzI=
mage-54e82e93.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit=
:
Reported-by: syzbot+941039552756d26f5e8e@syzkaller.appspotmail.com

 xfs_fs_fill_super+0x11f1/0x1640 fs/xfs/xfs_super.c:1960
 get_tree_bdev_flags+0x40e/0x4d0 fs/super.c:1691
 vfs_get_tree+0x92/0x2a0 fs/super.c:1751
 fc_mount fs/namespace.c:1199 [inline]
 do_new_mount_fc fs/namespace.c:3636 [inline]
 do_new_mount+0x302/0xa10 fs/namespace.c:3712
 do_mount fs/namespace.c:4035 [inline]
 __do_sys_mount fs/namespace.c:4224 [inline]
 __se_sys_mount+0x313/0x410 fs/namespace.c:4201
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe612590f6a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 =
00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe6134c1e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fe6134c1ef0 RCX: 00007fe612590f6a
RDX: 0000200000009600 RSI: 0000200000009640 RDI: 00007fe6134c1eb0
RBP: 0000200000009600 R08: 00007fe6134c1ef0 R09: 0000000000200800
R10: 0000000000200800 R11: 0000000000000246 R12: 0000200000009640
R13: 00007fe6134c1eb0 R14: 0000000000009606 R15: 0000200000000000
 </TASK>
Mem-Info:
active_anon:2919 inactive_anon:35 isolated_anon:0
 active_file:2500 inactive_file:35732 isolated_file:0
 unevictable:1768 dirty:0 writeback:0
 slab_reclaimable:7075 slab_unreclaimable:30729
 mapped:9856 shmem:2274 pagetables:728
 sec_pagetables:289 bounce:0
 kernel_misc_reclaimable:0
 free:35441 free_pcp:552 free_cma:0
Node 0 active_anon:108kB inactive_anon:68kB active_file:452kB inactive_file=
:4kB unevictable:268kB isolated(anon):0kB isolated(file):0kB mapped:324kB d=
irty:0kB writeback:0kB shmem:308kB shmem_thp:0kB shmem_pmdmapped:0kB anon_t=
hp:0kB kernel_stack:3456kB pagetables:812kB sec_pagetables:1084kB all_unrec=
laimable? no Balloon:0kB
Node 1 active_anon:11568kB inactive_anon:72kB active_file:9548kB inactive_f=
ile:142924kB unevictable:6804kB isolated(anon):0kB isolated(file):0kB mappe=
d:39100kB dirty:0kB writeback:0kB shmem:8788kB shmem_thp:0kB shmem_pmdmappe=
d:0kB anon_thp:0kB kernel_stack:7160kB pagetables:2100kB sec_pagetables:72k=
B all_unreclaimable? no Balloon:0kB
Node 0 DMA free:1448kB boost:0kB min:760kB low:948kB high:1136kB reserved_h=
ighatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:8kB active_=
file:0kB inactive_file:0kB unevictable:268kB writepending:0kB zspages:0kB p=
resent:15992kB managed:15360kB mlocked:0kB bounce:0kB free_pcp:132kB local_=
pcp:132kB free_cma:0kB
lowmem_reserve[]: 0 121 121 121 121
Node 0 DMA32 free:7812kB boost:0kB min:4868kB low:6084kB high:7300kB reserv=
ed_highatomic:0KB free_highatomic:0KB active_anon:108kB inactive_anon:76kB =
active_file:452kB inactive_file:4kB unevictable:0kB writepending:0kB zspage=
s:0kB present:770052kB managed:124500kB mlocked:0kB bounce:0kB free_pcp:368=
kB local_pcp:368kB free_cma:0kB
lowmem_reserve[]: 0 0 0 0 0
Node 1 DMA32 free:132488kB boost:0kB min:34308kB low:42884kB high:51460kB r=
eserved_highatomic:0KB free_highatomic:0KB active_anon:11592kB inactive_ano=
n:80kB active_file:9552kB inactive_file:142936kB unevictable:6804kB writepe=
nding:0kB zspages:1756kB present:786288kB managed:690812kB mlocked:0kB boun=
ce:0kB free_pcp:1700kB local_pcp:1700kB free_cma:0kB
lowmem_reserve[]: 0 0 0 0 0
Node 0 DMA: 45*4kB (U) 31*8kB (U) 4*16kB (U) 8*32kB (U) 5*64kB (U) 1*128kB =
(U) 1*256kB (U) 0*512kB 0*1024kB 0*2048kB 0*4096kB =3D 1452kB
Node 0 DMA32: 19*4kB (UME) 17*8kB (UME) 31*16kB (UM) 44*32kB (UME) 21*64kB =
(UME) 16*128kB (UM) 7*256kB (ME) 1*512kB (U) 0*1024kB 0*2048kB 0*4096kB =3D=
 7812kB
Node 1 DMA32: 2278*4kB (UE) 566*8kB (U) 68*16kB (UM) 270*32kB (UME) 239*64k=
B (UME) 57*128kB (UE) 16*256kB (UM) 1*512kB (U) 2*1024kB (U) 3*2048kB (UM) =
18*4096kB (M) =3D 132488kB
Node 0 hugepages_total=3D0 hugepages_free=3D0 hugepages_surp=3D0 hugepages_=
size=3D1048576kB
Node 0 hugepages_total=3D2 hugepages_free=3D2 hugepages_surp=3D0 hugepages_=
size=3D2048kB
Node 1 hugepages_total=3D0 hugepages_free=3D0 hugepages_surp=3D0 hugepages_=
size=3D1048576kB
Node 1 hugepages_total=3D2 hugepages_free=3D2 hugepages_surp=3D0 hugepages_=
size=3D2048kB
40623 total pagecache pages
83 pages in swap cache
Free swap  =3D 106924kB
Total swap =3D 124996kB
393083 pages RAM
0 pages HighMem/MovableOnly
185415 pages reserved
0 pages cma reserved
XFS (loop0): Ending clean mount
------------[ cut here ]------------
WARNING: mm/page_alloc.c:4692 at __alloc_pages_slowpath+0xcad/0xce0 mm/page=
_alloc.c:4692, CPU#0: syz.0.0/5345
Modules linked in:
CPU: 0 UID: 0 PID: 5345 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full=
)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16=
.3-2~bpo12+1 04/01/2014
RIP: 0010:__alloc_pages_slowpath+0xcad/0xce0 mm/page_alloc.c:4692
Code: 48 8b 1c 25 08 c0 80 92 48 83 c3 2c 48 89 d8 48 c1 e8 03 0f b6 04 08 =
84 c0 75 22 f6 43 01 08 48 8b 14 24 0f 84 9d f3 ff ff 90 <0f> 0b 90 e9 94 f=
3 ff ff e8 96 69 40 09 90 0f 0b 90 eb c2 89 d9 80
RSP: 0018:ffffc9000d6e5c90 EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffff88800025002c RCX: dffffc0000000000
RDX: ffffc9000d6e5da0 RSI: 0000000000000000 RDI: 0000000001048c50
RBP: 0000000001048c50 R08: ffff88802fffd9b0 R09: 1ffff1100365ea01
R10: dffffc0000000000 R11: ffffed100365ea02 R12: ffffc9000d6e5da0
R13: 1ffff92001adcbb0 R14: 0000000000000000 R15: dffffc0000000000
FS:  00007fe6134c26c0(0000) GS:ffff88808d414000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6d79d29120 CR3: 0000000035b0b000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 __alloc_frozen_pages_noprof+0x319/0x370 mm/page_alloc.c:5223
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2486
 alloc_slab_page mm/slub.c:3075 [inline]
 allocate_slab+0x134/0x3b0 mm/slub.c:3256
 new_slab mm/slub.c:3302 [inline]
 ___slab_alloc+0xe53/0x1820 mm/slub.c:4656
 __slab_alloc+0x65/0x100 mm/slub.c:4779
 __slab_alloc_node mm/slub.c:4855 [inline]
 slab_alloc_node mm/slub.c:5251 [inline]
 kmem_cache_alloc_noprof+0x40f/0x710 mm/slub.c:5270
 xfs_buf_alloc+0x60/0x1ca0 fs/xfs/xfs_buf.c:265
 xfs_buf_find_insert+0x52/0x1410 fs/xfs/xfs_buf.c:502
 xfs_buf_get_map+0x1225/0x17a0 fs/xfs/xfs_buf.c:606
 xfs_buf_read_map+0x82/0xa30 fs/xfs/xfs_buf.c:699
 xfs_trans_read_buf_map+0x1d7/0x8a0 fs/xfs/xfs_trans_buf.c:304
 xfs_trans_read_buf fs/xfs/xfs_trans.h:210 [inline]
 xfs_imap_to_bp+0x127/0x2f0 fs/xfs/libxfs/xfs_inode_buf.c:139
 xfs_inode_item_precommit+0x729/0xb40 fs/xfs/xfs_inode_item.c:170
 xfs_trans_run_precommits fs/xfs/xfs_trans.c:800 [inline]
 __xfs_trans_commit+0x2e1/0xbe0 fs/xfs/xfs_trans.c:843
 xfs_trans_commit+0x13e/0x1c0 fs/xfs/xfs_trans.c:928
 xfs_fs_dirty_inode+0x18e/0x1e0 fs/xfs/xfs_super.c:740
 __mark_inode_dirty+0x390/0x1330 fs/fs-writeback.c:2587
 mark_inode_dirty_sync include/linux/fs.h:2200 [inline]
 iput+0x3e8/0x1030 fs/inode.c:1984
 __dentry_kill+0x209/0x660 fs/dcache.c:670
 shrink_kill+0xa9/0x2c0 fs/dcache.c:1137
 shrink_dentry_list+0x2e0/0x5e0 fs/dcache.c:1164
 prune_dcache_sb+0x10e/0x180 fs/dcache.c:1246
 super_cache_scan+0x369/0x4b0 fs/super.c:222
 do_shrink_slab+0x6df/0x10d0 mm/shrinker.c:437
 shrink_slab_memcg mm/shrinker.c:550 [inline]
 shrink_slab+0x7ef/0x10d0 mm/shrinker.c:628
 shrink_one+0x2d9/0x720 mm/vmscan.c:4921
 shrink_many mm/vmscan.c:4982 [inline]
 lru_gen_shrink_node mm/vmscan.c:5060 [inline]
 shrink_node+0x2f7d/0x35b0 mm/vmscan.c:6047
 shrink_zones mm/vmscan.c:6300 [inline]
 do_try_to_free_pages+0x668/0x1960 mm/vmscan.c:6362
 try_to_free_pages+0x892/0xd90 mm/vmscan.c:6608
 __perform_reclaim mm/page_alloc.c:4377 [inline]
 __alloc_pages_direct_reclaim+0x144/0x300 mm/page_alloc.c:4399
 __alloc_pages_slowpath+0x60c/0xce0 mm/page_alloc.c:4843
 __alloc_frozen_pages_noprof+0x319/0x370 mm/page_alloc.c:5223
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2486
 alloc_frozen_pages_noprof mm/mempolicy.c:2557 [inline]
 alloc_pages_noprof+0xa9/0x190 mm/mempolicy.c:2577
 vm_area_alloc_pages mm/vmalloc.c:3718 [inline]
 __vmalloc_area_node mm/vmalloc.c:3863 [inline]
 __vmalloc_node_range_noprof+0xc18/0x16a0 mm/vmalloc.c:4051
 __vmalloc_node_noprof mm/vmalloc.c:4111 [inline]
 vzalloc_noprof+0xb2/0xf0 mm/vmalloc.c:4189
 alloc_one_pg_vec_page net/packet/af_packet.c:4372 [inline]
 alloc_pg_vec net/packet/af_packet.c:4397 [inline]
 packet_set_ring+0x6f3/0x2120 net/packet/af_packet.c:4482
 packet_setsockopt+0xc5a/0x12c0 net/packet/af_packet.c:3838
 do_sock_setsockopt+0x25a/0x3e0 net/socket.c:2322
 __sys_setsockopt net/socket.c:2347 [inline]
 __do_sys_setsockopt net/socket.c:2353 [inline]
 __se_sys_setsockopt net/socket.c:2350 [inline]
 __x64_sys_setsockopt+0x18b/0x220 net/socket.c:2350
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe61258f7c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe6134c2038 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00007fe6127e5fa0 RCX: 00007fe61258f7c9
RDX: 000000000000000d RSI: 0000000000000107 RDI: 0000000000000009
RBP: 00007fe612613f91 R08: 000000000000001c R09: 0000000000000000
R10: 0000200000000040 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fe6127e6038 R14: 00007fe6127e5fa0 R15: 00007ffe60227bc8
 </TASK>


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

