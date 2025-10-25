Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3844DCCF9E3
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 13:34:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BB5480007; Sat, 25 Oct 2025 09:34:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6929B8E0135; Sat, 25 Oct 2025 09:34:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D14E80007; Sat, 25 Oct 2025 09:34:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 481488E0135
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 09:34:18 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E5DD1B55DD
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 13:34:17 +0000 (UTC)
X-FDA: 84036730554.06.D929361
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id 29042140012
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 13:34:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cpqO+U1K;
	spf=pass (imf23.hostedemail.com: domain of krishnagopi487@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=krishnagopi487@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761399256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dx8bLilE5AyfEgUYQmzj74VUR7h9rERnsbC+UGQQsjA=;
	b=JB/UxkcDxmXs1k8MxGdZEMnldJjIVr1hKvLTgwWXOtnNV1qGIezo9W99n7UL5ks/wbJgG1
	aI+4StNT4ywUy+HudUYjqBIItex2m7modwfi1uHxCCD/rY75PMK5BS7w4pBxVcbGXA5uwK
	Av86Tq6Fp6ZXMo7a5U/jhOcV+SifKqI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cpqO+U1K;
	spf=pass (imf23.hostedemail.com: domain of krishnagopi487@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=krishnagopi487@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761399256; a=rsa-sha256;
	cv=none;
	b=8Fv6bTKiW+tYZikiC3B9svJvC4H5rpwvU4nwCxbsF+nLanlRmURDGvND/KA6cQ0dfj7xrH
	1b6KnP7i5UcXoFqFfYErAcHSKaPXOPWb9VSAT8ZOQV8sIt4xnnt7lUtVzdCAyuSZpE9yn0
	qjb6QIxIgW9a/nx5FmnFNRl0Iu2+VCo=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-793021f348fso2608803b3a.1
        for <linux-mm@kvack.org>; Sat, 25 Oct 2025 06:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761399255; x=1762004055; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dx8bLilE5AyfEgUYQmzj74VUR7h9rERnsbC+UGQQsjA=;
        b=cpqO+U1KAB3US1+BsQNzvp0jou7TPIYYjO30KuDc+lpCecoiacJT4+os5HezCaONgB
         cpVb49etfuWqS6dLd0WYmHkJnM5XMF501zaUbQ5CQBs4a30n3tg1niI8F7SURdbLsYqZ
         j00uAPvbsvHdAdQobNYtgvSEZE2ORKro78kh+hIdXzxbIELotkzSdNOmPqJ7Mk4J1gAY
         F0A77EjmLIVj4kl2DeFCwzz2uPP98809B6IaiiGdn2ysvP5mItRz3dbNfhvdjFwbFrFa
         1n8ph0/rYP4qg0AYLY2ZDxRjFMehDp9FpAlR+nRT5LBLrXokLcg1p0/paCXhvcuKvecS
         IG4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761399255; x=1762004055;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dx8bLilE5AyfEgUYQmzj74VUR7h9rERnsbC+UGQQsjA=;
        b=GIa+KVOMHEakt0fOgLcX22rizBIhDEa9vJ1HVV0w9ka/mc2qZC9a+RwniDGi8FR2TB
         UbaqTYIvNswAH1IcCEJjsUvziQ2jC/oeLRmsYnOElcz5BFX20vPHmkik0+bmhdOIjL34
         Ulkx89tMcxioD++oBAzds76sD3zBDHI+y6Kfc8ycXzxyyOYOVu3XG1BGpAn6oKbtWfy9
         GelWWij7dR/uRXSWkYBa9OFO6tsjHgcCrYnHv+DLhOXu+YAwMlAyydzA3t6InWQ1ow8/
         dw1Frpw2KZAVwXkunPYuHmlU7U9tU7nSSys0Bxw4YhnRT38ULxFY2pU86r92HRcX+roR
         UxBw==
X-Forwarded-Encrypted: i=1; AJvYcCVcXgTIox+yxww3EqDx5Mqy+e6KBx4gtJOTytpERG/bcAjEOvmC6qWecczuchNlNENWTg6e/J/BgQ==@kvack.org
X-Gm-Message-State: AOJu0Yw0Q267E18m+ANXQgySdTcP1yQhzDJXn8ehe7xglIsqdljSvsvB
	hcF2TLdi1PhwPf8g2VwKrTDDYU56IsHYYBRLMDP4s0ORgbMlXpo1eJ/v
X-Gm-Gg: ASbGncv770WT5WiYVF+cP8CRl9TMNCECZ/Iuct9L6//04JgdrKPpkf+N48oZQIgklPK
	vrk9wjBdPvRBBbGL9Zm2j8jYr/ybaxEiHmq/QE2Pz6uOl0usKLDg9Ygs9xH2Me1RAiDNwx6f5dv
	7A9xYJ9fToiS5Rg4d/glI/oEkRrot7JXcHTTWvlKMJbxCTAAUBtUlJAYIR01luexCpavnwO2QSq
	OeGMPcSnsAZVHXoO/WA3DReq5xz9wl9WxjDBwk7bKYtNAifx3o2MTNW6FZjDi/f7fyROOFv2Exm
	v8sShVk853yUU2SLIPWqwm+B5QvkejFQH9M0DkLk51mjWXcvbKS7j8Du3FZoeJD20YuJN5K4f4r
	y8uVrzxeB1uscB9RJvZmEjlxGHalZ3XT4WKQk0p4sIodMumnSLIBw9xO14FXrfOVHpgNMz+hnGn
	gc+Ss=
X-Google-Smtp-Source: AGHT+IGhs/Ekp+AzXRjB0wL6TWXmgcqOapbbVJ2wCR9I0OD69Zbo9LuhhvTvZT8V2x68503bzppCGA==
X-Received: by 2002:a05:6a21:998f:b0:33e:84f7:94ef with SMTP id adf61e73a8af0-33e84f79f6amr5718010637.11.1761399254900;
        Sat, 25 Oct 2025 06:34:14 -0700 (PDT)
Received: from localhost ([103.70.166.143])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed80aa48sm2430937a91.13.2025.10.25.06.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Oct 2025 06:34:14 -0700 (PDT)
Date: Sat, 25 Oct 2025 19:04:11 +0530
From: Gopi Krishna Menon <krishnagopi487@gmail.com>
To: syzbot <syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@redhat.com, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, rakie.kim@sk.com, 
	syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com, ziy@nvidia.com
Subject: Re: [syzbot] [mm?] WARNING in raw_ioctl
Message-ID: <kwl4tk52z4cl5d5wahcmfh6skff5mypsa2jylyd6ag5nhrad3j@yawn25geajlz>
References: <68fc07a0.a70a0220.3bf6c6.01ab.GAE@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="75h7jlkjzsv2lt4a"
Content-Disposition: inline
In-Reply-To: <68fc07a0.a70a0220.3bf6c6.01ab.GAE@google.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 29042140012
X-Stat-Signature: dic79aeb95c95stpycrhr94h3y1aqbwz
X-Rspam-User: 
X-HE-Tag: 1761399255-476732
X-HE-Meta: U2FsdGVkX1/kZNSBXTM5FMwsnY/oxOenMWXZiH1qIIphP1oyQNV8tGs0uIhlxLpdM5aq1Yrc6qGaCscsLRpouQ1+z+4ScgWiw81Ut+HNpxqlfe9Z9F9gxdvOd01gB+hC9AciJjWaiazfaPmof6POFNtG+HFN2ST8LZC/kgXICycZ/6/oC114rf6LZtgxw6QA/T8Th6PzgVgmf+qzBDd9FgeAjev2SbzgjD8sDrTHW8GWfr7RheCaiKb0GyTQOwDVroom7jwF8aAKHo1pGTCwQxtIeIrlfPHgLc7ILz9e4ijUskhKK3/wrY1IIc/Mrbc2SqP00cN2ZCG4ahBBAKatpjqOVbqair5lzdDhCp3YYRB4ly1U/C/S/SEhu9Xkt0rYD8sZ0DenHIrBSe1rKguHv4E6yfdXIYoIbFqaFgO91qQ08EpeNhPaqcelwQJ3sC1vI41EisFUL7RZZnjGVmb+OIJx/MFbi0xRsbkQ7CBx49d3KgJtIpDujFJT3YpLsEltJLKKVuhiOo7RFhbjvkYGsq0SQwtjbdjIHQc+9LelWmBXdnTbwfxg9dvSMrDZtvVansbWVxKRNq86cg1S0GJdDWXnbUa165gSHSV5HS/dofLvijTgqfYsyx0C77mvF7d3LcPHXaVRpq/qVYwByTkEKfum7ZS8YOIF1f5Ru82fwr93KoVvY71lOK8lESsPt3fMPY4o8O8Tupff+1omWDVRCiiBZlRhKiopuqIcxGJ7AWrt7iDkbO8Se7472k40szHdUAzUywjggmYYasliXvmEsGLclE8cHX/Qb4dCJq9909HXVKZQGGv27gC87d9yRct9A92abPI8UvoWk3DCCvb8j9fFGieooEIvIOatayEPUIp4rA/VdR7pE0FRWRsDnIU1ZFPjW6qCYHngMVGF5ygrA2a4BdZttd9QLP1Y9dU4GCxXeFRaHPQPvhUejS/xMvjh9mTr+mpLGf07jU/vt8b
 y0RBxwnt
 erYCRfkzfOhgk9A3NDvrpRAIaPErSYHoZyEbEecsQS7kR7SUKaWKKw1XZfdS3PFTZonJo7SBz5iS+WHB6tRi9uGb7Nbmx2bqe9sKh0Tv9+P0HZFl/Ioxc/OmhFObtmuy2sBdUjQ2UP+j9dIYk7R4MtLrY0hiaRl0ckx72IXuHFrXwGDOpQM9feRu+sbKc0TuX8dsDjxKxrQW57JWVBEsvC2udkJIJ1SEKBNRu6ZlXjxaHGfpNLGL66YOynM1kb9XbRbf+++LaqRDQtW4KMVXDtYfo0FvHYcrSh9+jaDVFtltLlvvSb950AZQXS228FNw4wUxL/3Tty/L/eXaHdicQbe1NnbcCAUBIOfB9eWQ+6ay7mmdGh1leB4nptCJtmI5Y23J1A34epEccbSvWOzeMs0Bde6eNTWE/DrC5jSTSODq2/ul6wnYYJ+c3QPfdoCq9lx5xhKy1lQCZL9IICux3IPrvSMBFrDMQSmev1SD+Mxi1TPNgaBgkZ8qySDOg6H21vjerO5iecaJapwBaIIUJQNhsOMfQhKPhu8bBUqqVqn+im1YBhL1PLz+86w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--75h7jlkjzsv2lt4a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 24, 2025 at 04:11:28PM -0700, syzbot wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    72fb0170ef1f Add linux-next specific files for 20251024
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=10fd0be2580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e812d103f45aa955
> dashboard link: https://syzkaller.appspot.com/bug?extid=d8fd35fa6177afa8c92b
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=119eae7c580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=140693e2580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/be1fa3d1f761/disk-72fb0170.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/57302bf7af40/vmlinux-72fb0170.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/91c806bb2a2b/bzImage-72fb0170.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: mm/page_alloc.c:5190 at __alloc_frozen_pages_noprof+0x2c8/0x370 mm/page_alloc.c:5190, CPU#1: syz.0.17/6001
> Modules linked in:
> CPU: 1 UID: 0 PID: 6001 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
> RIP: 0010:__alloc_frozen_pages_noprof+0x2c8/0x370 mm/page_alloc.c:5190
> Code: 74 10 4c 89 e7 89 54 24 0c e8 64 b9 0d 00 8b 54 24 0c 49 83 3c 24 00 0f 85 a5 fe ff ff e9 a6 fe ff ff c6 05 b1 7d 70 0d 01 90 <0f> 0b 90 e9 18 ff ff ff a9 00 00 08 00 48 8b 4c 24 10 4c 8d 44 24
> RSP: 0018:ffffc90003017920 EFLAGS: 00010246
> RAX: ffffc90003017900 RBX: 0000000000000013 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90003017988
> RBP: ffffc90003017a18 R08: ffffc90003017987 R09: 0000000000000000
> R10: ffffc90003017960 R11: fffff52000602f31 R12: 0000000000000000
> R13: 1ffff92000602f28 R14: 0000000000040cc0 R15: dffffc0000000000
> FS:  000055558dedb500(0000) GS:ffff888125ddc000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffef4504a80 CR3: 0000000072ffa000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2418
>  ___kmalloc_large_node+0x5f/0x1b0 mm/slub.c:5583
>  __kmalloc_large_node_noprof+0x18/0x90 mm/slub.c:5614
>  __do_kmalloc_node mm/slub.c:5630 [inline]
>  __kmalloc_noprof+0x4c9/0x800 mm/slub.c:5654
>  kmalloc_noprof include/linux/slab.h:961 [inline]
>  raw_alloc_io_data drivers/usb/gadget/legacy/raw_gadget.c:673 [inline]
>  raw_ioctl_ep_read drivers/usb/gadget/legacy/raw_gadget.c:1162 [inline]
>  raw_ioctl+0x18fb/0x3be0 drivers/usb/gadget/legacy/raw_gadget.c:1325
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fccefd8efc9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffef4505ad8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007fcceffe5fa0 RCX: 00007fccefd8efc9
> RDX: 00002000000000c0 RSI: 00000000c0085508 RDI: 0000000000000004
> RBP: 00007fccefe11f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fcceffe5fa0 R14: 00007fcceffe5fa0 R15: 0000000000000003
>  </TASK>
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup

Since the maximum packet size of the endpoint descriptor is a 16 bit
field, we can make sure that the io->length is never greater than 65535
bytes.

Resend the patch as attachement as earlier one got cut off by syzbot.

#syz test


--75h7jlkjzsv2lt4a
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-usb-raw_gadget-validate-io-length-in-raw_alloc_io_da.patch"

From 06149314c2d71c1a6481db9a0fba98d4509cde6a Mon Sep 17 00:00:00 2001
From: Gopi Krishna Menon <krishnagopi487@gmail.com>
Date: Sat, 25 Oct 2025 18:55:45 +0530
Subject: [PATCH] usb: raw_gadget: validate io length in raw_alloc_io_data()

Since the maximum packet size of the endpoint descriptor is a 16 bit
field, we can make sure that the io->length is never greater than 65535
bytes.

For testing in syzbot

Signed-off-by: Gopi Krishna Menon <krishnagopi487@gmail.com>
---
 drivers/usb/gadget/legacy/raw_gadget.c | 2 ++
 include/uapi/linux/usb/raw_gadget.h    | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/drivers/usb/gadget/legacy/raw_gadget.c b/drivers/usb/gadget/legacy/raw_gadget.c
index b71680c58de6..00f5e697d321 100644
--- a/drivers/usb/gadget/legacy/raw_gadget.c
+++ b/drivers/usb/gadget/legacy/raw_gadget.c
@@ -667,6 +667,8 @@ static void *raw_alloc_io_data(struct usb_raw_ep_io *io, void __user *ptr,
 		return ERR_PTR(-EINVAL);
 	if (!usb_raw_io_flags_valid(io->flags))
 		return ERR_PTR(-EINVAL);
+	if (io->length > USB_RAW_IO_MAX_LENGTH)
+		return ERR_PTR(-EINVAL);
 	if (get_from_user)
 		data = memdup_user(ptr + sizeof(*io), io->length);
 	else {
diff --git a/include/uapi/linux/usb/raw_gadget.h b/include/uapi/linux/usb/raw_gadget.h
index f0224a8dc858..effe8a543c75 100644
--- a/include/uapi/linux/usb/raw_gadget.h
+++ b/include/uapi/linux/usb/raw_gadget.h
@@ -106,6 +106,9 @@ struct usb_raw_ep_io {
 /* Maximum number of non-control endpoints in struct usb_raw_eps_info. */
 #define USB_RAW_EPS_NUM_MAX	30
 
+/* Maximum length for raw endpoint IO */
+#define USB_RAW_IO_MAX_LENGTH 65535
+
 /* Maximum length of UDC endpoint name in struct usb_raw_ep_info. */
 #define USB_RAW_EP_NAME_MAX	16
 
-- 
2.43.0


--75h7jlkjzsv2lt4a--

