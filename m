Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 535A0CCF9E3
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 13:20:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B05868E0149; Sat, 25 Oct 2025 09:20:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB6638E0135; Sat, 25 Oct 2025 09:20:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97E1D8E0149; Sat, 25 Oct 2025 09:20:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 81CDE8E0135
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 09:20:36 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3EC14B6540
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 13:20:36 +0000 (UTC)
X-FDA: 84036696072.11.28AB939
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5D1AF14000A
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 13:20:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FX1K37C3;
	spf=pass (imf23.hostedemail.com: domain of krishnagopi487@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=krishnagopi487@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761398434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7PKiLH+RjjN646XXCQ4HfAAEe48a7xXF0BXJN5Md6pE=;
	b=saM5u1wNbNkcRdNgDkq1JdNJlYw14q3eJpnH3+L0R7NwooTMfR+gLWUwvu1JCRxWihA3sz
	+ILV881Is60lzlRhNI2pQtniZ38X2yLd5NsWuieDGR5dPuXEXyokAbnFmXDTSNgIgdQb75
	RJTbRlZVjKU3pCPD3xFCJ7syIVpj0E8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FX1K37C3;
	spf=pass (imf23.hostedemail.com: domain of krishnagopi487@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=krishnagopi487@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761398434; a=rsa-sha256;
	cv=none;
	b=cl6IPe2sjRFamHv/w4+X0fUU4ZkyyBbZS4ca13XOjyvzZ0qIl0uolZ5PD96Ywj0WS4Q6LD
	36OP0On/BOj9Fp1VyQjvi7Mf7AkUJAQXs0kP3KCVborzdXz/DYjMQRQzqnlMh2RLsa/wR5
	H/IacOAlb11pIUK6yBEQk03e0lFjEDo=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7a26dab3a97so1866347b3a.0
        for <linux-mm@kvack.org>; Sat, 25 Oct 2025 06:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761398433; x=1762003233; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7PKiLH+RjjN646XXCQ4HfAAEe48a7xXF0BXJN5Md6pE=;
        b=FX1K37C37gmLcDd5qG7VQy1DWkZA0UO4ZH2fIBRUhhxb6vgzbjqFVvoYO+0TbqGrVt
         kOKAtrvbdpT+bGY3Ujy4VteJ6pba1VeD56+no9zvXsgQ7IGMxLz2EF0vJkgRfz4JDC3g
         /PQ+/jYhdAKCNorbKMqc2/iKGt7V/QXRMMEQzU5mbMKRZPJcdMBBCuv95WPLaHfhIAt6
         ua+gI9wq7CshrX350kup8DafF/4/Nxw8IXZcAxyv6v98Qk7kzYVAB2wFl4baOQz+7xT/
         v6x6KPsk6mFjNkTM4OmcvWvCig3GFXNAfPlJ5nVyS0WjFyzd/I56NukQ0KZ15cpxLjY7
         +7ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761398433; x=1762003233;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7PKiLH+RjjN646XXCQ4HfAAEe48a7xXF0BXJN5Md6pE=;
        b=D1YlahoceGPcP72rhBKDADQ4HY/3lrjErpnNA4xBhWCsaCxNnvF3unAZrRqnydbI90
         42C8fVC7yhWPrDVYYuMgmyS1mRwcBzj/L7fSNjJwvQpHSRr0TcoSPZWEX5tw4/QrP+Qn
         tX8OaBIPLO64/ijA2giZZC/f6hUQrcw7CShcmfrcT8+JkCa1yKnbO1OuR85DZeaAmMVa
         SLptXukg5IDP7z8ZflqGamAFyXZqSJlRw4VyY8LwOnXnfPONYB5QUS6AahUfqoPHI0U5
         tj7yjXRzpYylfR0ndcQdAOfhV8Vjou6A/bXToE8xXJkMo5eDPRIMMiHWJyGpo4i9wP/f
         doqg==
X-Forwarded-Encrypted: i=1; AJvYcCWkaxWiybb1zD90B1dk2bJUXT29IdnT3qPsAJ0sN9fSDwJPTnjOnGYHXSOBSxxo6ERZVhmxnHqnwA==@kvack.org
X-Gm-Message-State: AOJu0YzTCe9ZeM99wmjFCUJzRv69g3rFhV3yejgRZl1YiBTR8KSk9fvg
	gf1FWrdyOdk9IdC21E77S8HdmeD1gmYVmbv67S0Gvp6Lo7MXBF1pP8Hi
X-Gm-Gg: ASbGncsKLjb68F/V0Z1dlnv/sh8fu7XnjLOsb72+ODGO5nbm8waoI3J2lsY8O3ECmlK
	TJTkfk3kkZF7fNv0ry1i/XJmjDjOC5LWUHXHZR9Jo/qGleQ80m47JUxlLioEb4q2p98gqRBG1DO
	7Lt2qhbV1OMjrLbu0o7wAyZd633ERxR6J0HpDgFXTCSc1PpfBmlSvcx6Z+OeNRYKkjUuOUkvOwO
	Aw1DprIbRyOGMSI2ZJR+VNsJruGYVVQVk+SgnFmldVbvVtPRCbwUifynxL7+z7BepWLyHTpcf5i
	fEHewGkfAMbBkZlK4USh841gmaOrQoArAq5TPnVyiseYK6KLaE013X4eaCwqajyh2Dn3gTxlGRp
	vaoed5mTlSGjPN37u4bFfyu5RJtJWJQ/vniiNFcRJ2KybbbHI8MAX6aSAT+LEl/ZcFFIHkE50Tf
	Ht8RBUyZzo+XUaBQ==
X-Google-Smtp-Source: AGHT+IHJiC0aj6qmuZfdGIWKqbTfTXS9jpfedjPCPbxhWj8tHI0AEBJvmgejbKLVkiSn6jzWu51Gew==
X-Received: by 2002:a05:6a20:a10c:b0:33f:4e3d:aff3 with SMTP id adf61e73a8af0-33f4e3db2ebmr5654536637.24.1761398433012;
        Sat, 25 Oct 2025 06:20:33 -0700 (PDT)
Received: from localhost ([103.70.166.143])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed80aa48sm2394595a91.13.2025.10.25.06.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Oct 2025 06:20:32 -0700 (PDT)
Date: Sat, 25 Oct 2025 18:50:29 +0530
From: Gopi Krishna Menon <krishnagopi487@gmail.com>
To: syzbot <syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@redhat.com, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, rakie.kim@sk.com, 
	syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com, ziy@nvidia.com
Subject: Re: [syzbot] [mm?] WARNING in raw_ioctl
Message-ID: <eycmv6nwd6yvi4y2xlvqsjfzzoq46tlmqhbdu3bxi7rxfyreov@m2liixvk4ugn>
References: <68fc07a0.a70a0220.3bf6c6.01ab.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68fc07a0.a70a0220.3bf6c6.01ab.GAE@google.com>
X-Stat-Signature: bcbj1xgwkoj5gg36mnm15i3wybjker1h
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5D1AF14000A
X-HE-Tag: 1761398434-834079
X-HE-Meta: U2FsdGVkX1/Zz0E7/Z1tH3ycJrhmo0gtDGWwG2vyCN6IpW5GDhd16iaSW4Mv+73Pf6oFqIj7vVwC08ga3MDr4GUnEy9OH9cKuOoXpw8DmkypcIjoJYw/qtFJ8w4bRqfnI6BI4KedjhKvXkY1CG7bJEyTxB3jtp/+9vXPzfHEyS2ZNFoJsmXK/ytgf/bovTiEix7JlqrULQkm+4V2WkntfGfcDHaAnlgwD0NhBU6/y6SHLxYfN3hT+Yo+CQhKArLVRnraheboneDkVd/f1xCrNW1D2t5XeimEBWIg0YGd/Lx6sIbjsaNsWt1rphR7iPedDjQvhLXCFrT4zONkmKbYs7r5yssTUDuv+AhR13HJUYWvBliKYiSbnwxR/tCo+G6TYlZy3DCPMI0+wM1wDBi4atGe2th5CxRKKhXmn19I+FlObTedn/F6AezqTWKPvFi33K0OofAtu69Z2m42Wxq4ZHHBmo7fgPLftYaw7uFQnF+F0BZFek6nLQm/B6zQBFFIC63EP9rnSa7uzWuDxxibjHviS7gyYb0vR3tKkuAuERu+gvaBzzB+3tuGPPX1pdprO2+7SUBiK/jK+/9/JLCufFNIm8cj2FoRcYzbicv5LsAjcdis6qDGqd1RTl3ADp/e10Pz9ED+AL69PtJ0F15jeL5fQFrcuZnZ5othnR1+V2vlT09BM1XXt1KRYgeQLzJH1FUuL3sX6PGlmS4Uao30TLxihYIbT52A20mRT7vKAMLZNpRRR+CVOVsG1Q//BQBHc9dWcAKqy1ZJB3tqgl7DGgIGNeUj+BsoCYOXcEmZuG+HqDK6FSuMREZFN+KV8GUJgfLq247cwzcR88WIusFT8MNv/Pq6XWOi7+UimJin0TKPM9d5aUgfzmCQGjYDzTBe7sdze1/JMASFc8/mD1X9StsnCbwa5WAwPx33SptZdyJO2Peghh/4byhOqLAP2beuM1Of6EbooQ0NUx6m2/n
 jMwqG3md
 E6qIpjvwaPiYph7XmekHd+UieKJlLwvBAKPRI2GQojzbmqDQFRF3THfeKPQGDHyMW2NtuTEHaxeoGnwdSrLORBB/nyM9GuWITk5Y6mCNRytF8q2QUXNAtkAoEkiFNBDzeE3ZIVLe66AjoBZ5Nq5wOeGMXtUY2stxvLBjWwyeKQXYwhv2n7fjf5vAf2AqF+TtrxH8e/sBpi5bEAcKBfMqVXp0SIuXxrw3bHD3ZxH10Ji/+2gAUhRnhCkClKsEWtCM+v6NDyL8sw4G81EMHzT9Vd4+FmlHSguC4ydZqwk0XHLkpgrpLQMx3Zzrtan/c/aDyU2kkCDN6fnwfvi2ABe/3znF2Y2WwBwo6s85y8kJ+ON9Xe6gSHuJLUmZfJPzgCCUXUBVc+DTVSg7EJRigaoVhou2/blMtmmd5zCKdHYWn1jGKO1xLEia1Mf0g/0NF6cqKD2PCuejjWZEsklcdHUN/89W7q874NZJax32AOIWAXXsU5P499ErnxnTc4VhkksGG6IF+jSYCZhQKiIo0s+PDSdUVJoOS6yPXnTNnmQ586EOHKov711vPsYeZnVgp/VvNLdV9vbrqhf1NQruXgT8RkyxruCYbN5gIUz6exxzG9DIZMm/vsDQ9TkfQG6bW4JCxbgkgjlDzpa3c08KOBKqnY154A8N0+U8j2yG5l63QGgmlXPOaCcMtjvLYFN/YXlfzumZFTYijqw3oLbPIuveWihZ/onoxizH/f9t2JgPZlZUurul926RVknG4zHrVGxeocNdM77BGHmlmVuUqsLx4muywYVqpEIPJSTAkC8fVi/I6NCvWg4FjAUrSCutD4gHoImXl6DIo6g//LyaxjEhARRgJ+hgWRhqBawC+P94/DZcKI5Sc9V5RTgDBlk38numnKDDN6KQRkkHlAEvjFiZpL++66DFnnH3ZNJBwvKCJPuBoJimFZJqEjIMGzTY1U4kp5F32be+aRzTish2uXz2PZLSuaZT4
 /N9/y6Mt
 XGT95vkac94+f1aO2Ynl/ruO2dCx7zgwVbqFrBKMhXup+C/QOwZ1MJVPgk5I9BjcfY13B++Gagd61XTBzEwXAWfiQWQy8XKSucdx9iFUV3yd2J3W4/MoXNm4PFMwoBcBNs8eosY0IQdIIzTqIFESgETTZwa69GiMBvwo6JAaRfxw72BTL+b+tLbuON6xJjE6xFuV5UOeX72/gZCMC8h7CDKGH4VH0zOG1leJanOiMvDL2YBbRFboMlHIwtKIZRmGfeIl7uTsBdCERe+GwLtYV9/tVi3qMEQaevSgeNHbNs+fsqZxSK77d7T2i32vJs9L53Fhm8vdJlPQHmfJMJy/jxahsvEj509L
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

Resend the patch as earlier one was malformed.

#syz test

diff --git a/drivers/usb/gadget/legacy/raw_gadget.c b/drivers/usb/gadget/legacy/raw_gadget.c
index b71680c58de6..00f5e697d321 100644
--- a/drivers/usb/gadget/legacy/raw_gadget.c
+++ b/drivers/usb/gadget/legacy/raw_gadget.c
@@ -667,6 +667,8 @@ static void *raw_alloc_io_data(struct usb_raw_ep_io *io, void __user *ptr,
                return ERR_PTR(-EINVAL);
        if (!usb_raw_io_flags_valid(io->flags))
                return ERR_PTR(-EINVAL);
+       if (io->length > USB_RAW_IO_MAX_LENGTH)
+               return ERR_PTR(-EINVAL);
        if (get_from_user)
                data = memdup_user(ptr + sizeof(*io), io->length);
        else {
diff --git a/include/uapi/linux/usb/raw_gadget.h b/include/uapi/linux/usb/raw_gadget.h
index f0224a8dc858..effe8a543c75 100644
--- a/include/uapi/linux/usb/raw_gadget.h
+++ b/include/uapi/linux/usb/raw_gadget.h
@@ -106,6 +106,9 @@ struct usb_raw_ep_io {
 /* Maximum number of non-control endpoints in struct usb_raw_eps_info. */
 #define USB_RAW_EPS_NUM_MAX    30

+/* Maximum length for raw endpoint IO */
+#define USB_RAW_IO_MAX_LENGTH 65535
+
 /* Maximum length of UDC endpoint name in struct usb_raw_ep_info. */
 #define USB_RAW_EP_NAME_MAX    16


