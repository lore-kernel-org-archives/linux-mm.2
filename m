Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A86A8CCF9E3
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 09:16:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7844C8E0141; Sat, 25 Oct 2025 05:16:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 734938E0135; Sat, 25 Oct 2025 05:16:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64A6E8E0141; Sat, 25 Oct 2025 05:16:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3C41F8E0135
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 05:16:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9C0F21A10E0
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 09:16:57 +0000 (UTC)
X-FDA: 84036082074.06.2636F95
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf12.hostedemail.com (Postfix) with ESMTP id BAC2240007
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 09:16:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FqMueDLq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of krishnagopi487@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=krishnagopi487@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761383815; a=rsa-sha256;
	cv=none;
	b=DyHr/uaNyfVvETbDKc0W/bSqY5iX73b/8n/jvtwU/GMTg8WvnZh7tVKQ2KNmJS/XfjNZjc
	qC9nrM1pXX17KTQPDytvGKGWjiGNuQlYide1ZNMMc/P0o8ZIG26lffiNrxRN8UkpYSSlXW
	ky/378ZjYMLnaZU7AJtEEFByaSCMF1g=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FqMueDLq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of krishnagopi487@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=krishnagopi487@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761383815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=njyZZntG8jB9oswagPq+Zbvv0EZXc75W/5WB5yROPws=;
	b=Eg4Ep0/IGlcXwxGziIA8X5XH26PU0olQMOE4JHl6es7wuQ7xG8d36rJmeOxBs8meCpcsuR
	YoG8ZCwrNS8rha2LWLCB0KTjsQEmxerBd7ai8H/FBGY4roa+PC1HBzkdaAG4Vg0AxTux0P
	NRdF+AGogLEeRHlomDmLlQsUL1lNGqg=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b6cf25c9ad5so2257658a12.0
        for <linux-mm@kvack.org>; Sat, 25 Oct 2025 02:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761383814; x=1761988614; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=njyZZntG8jB9oswagPq+Zbvv0EZXc75W/5WB5yROPws=;
        b=FqMueDLqGwlzqBnc9liFZWlJ1a3+f8f9lQSxQRhk9g6A894rj7VOAh8biYQH4vd4vf
         sGJUrKz9WliczTqxnd1UEDyToNq52pZye5t+QnMigoHLzsuxXnGp4Us10LAMYcQeExIh
         PVRduCXmaVUKYpschwee9j9APcub6JsSNw6cgvGFtG6e8Tz1yspbAdgtrglRo+4OUlfW
         vDWFq5SXJtwFB7GK+PZcK0vLBJmHca624M9pV3+f0klMVnVBWu85/7X3hymVsGudHn8V
         dWkl9/w2vL2AUx9zp6WceUxIdukiOHSYF0Q6PtEKg6G3XyFDq1qgoka7p05CCzDAMZ1F
         vzHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761383814; x=1761988614;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=njyZZntG8jB9oswagPq+Zbvv0EZXc75W/5WB5yROPws=;
        b=O3j+Ymthh9/ecf8OXnkeTdjzvqNYvEdJmUDkC3HfWamdFgOJObOLbbkYMQQVW/WbGi
         PR5voRazzhOvDc0cw12vGsgg08fqx7c1maeuM88uUahX7xd137pBwBIjO3dZGWRypW++
         T5yYJftG257twIvq/U4NXceGxPkBg1e13Nq2DoRxD5NNr+750bkz4jwq1RRkzwz86jcx
         e67rOYU7Tx6HUGUfLcn08D7GkLIvqppl68WTACFbxAOjUBMeO8uHWfxJR7Y3L0W6QHrT
         6J3ttVYgEHJ0/RbB2pVRe4lJllu0ZGeJr97u8jaST1JtfMmexyr4NDVga9JMk8uHMZuc
         onHg==
X-Forwarded-Encrypted: i=1; AJvYcCUisqlplE0kHt78WEZ3fla4nm0hjY9kCo0CAdsnF7FRi0WYxJjzKCd2ZTmuD4nTjCBZuKNfdpJsig==@kvack.org
X-Gm-Message-State: AOJu0YxkcdvD9eKHNgW54fpdBtHvUTpXxxDmmEk0RocIC9kFF9tMz8/p
	TPKMcL1rSS+UCCu/PCKwaNmmBi4A0DrSlF6FmdCI+KHA8iNnPqVB2rHn
X-Gm-Gg: ASbGncsRekPHXtwkdHVN/I09Iwb3jkXMIb9agjGIzBvGLeN4/65LEP+toR8fgLDWGca
	CXjLaPuMN0u/FGwQrIjIRJ7o7jFDuSzF/kL1N1oNcbSCUjk0iViIYMwa+YZy8N5nkpmgJ6KfzTI
	9FobfTtx6zXbqhSLOOyt96G8Fw1qEaNJuOgt8oN0yt9waU38x2EjsL+elraLqUCb3UbLNf2R1Oy
	c+E+F7stwEGwzML3jwc0LuxgDRBDMNAYOw8G5EaCtY6yE8gix87R69S4I33ayQcbu2z2wjM8w0V
	eauS8SXWO4duwwxz24M8yWPJS8X6xnhLL4Ddnpo+Oh08orOUwWp88ngwCiGRvdeowJpZUHlMYOk
	MVCwqj9VBWZ4j95K8acaaxRLbQ3kNkGvFLSTdt/H1kkuguD4mo9bGX0yqLgtAlapUZcIFnfM5k3
	cCkbQnLFA3pwQemw==
X-Google-Smtp-Source: AGHT+IFjIxzCSd7vHDr58lswHi+jvMAjnTi6aIc5dM1LQTu8C0HpEJgg0uejHLpsir8p4hJ+muVwUg==
X-Received: by 2002:a17:902:db11:b0:277:71e6:b04d with SMTP id d9443c01a7336-290c9cf35e6mr380792355ad.3.1761383814449;
        Sat, 25 Oct 2025 02:16:54 -0700 (PDT)
Received: from localhost ([103.70.166.143])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498cf359asm17066255ad.12.2025.10.25.02.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Oct 2025 02:16:53 -0700 (PDT)
Date: Sat, 25 Oct 2025 14:46:51 +0530
From: Gopi Krishna Menon <krishnagopi487@gmail.com>
To: syzbot <syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@redhat.com, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, rakie.kim@sk.com, 
	syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com, ziy@nvidia.com
Subject: Re: [syzbot] [mm?] WARNING in raw_ioctl
Message-ID: <rdrijfoz5apghwj4zpymigdelzza4l3r5yzrwrpggd3nij3x7y@du4lgss3gexp>
References: <68fc07a0.a70a0220.3bf6c6.01ab.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68fc07a0.a70a0220.3bf6c6.01ab.GAE@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BAC2240007
X-Stat-Signature: yzdt86enm6xgf3guwbgf8s4tupbqb1sc
X-HE-Tag: 1761383815-4262
X-HE-Meta: U2FsdGVkX196S/QixV0xRkASdUXkd92T5VdIS5L/ArVg5xN4Im5r5yiKWI7lRuIPkBEJvZ6dW1Dt7OPRanGDz5/KGRDg724f3u1/CCtH9mZ+pzQ39zBWC8n12ykeVei06uUHpvy0n7QsfU2JGWhdPV5OYppFIm/14jtrwmXhKgAEGk418zzvVK4GHOEHm9PU7uUNtNNpyf0n9uYiX0DUpfOz5ZY3xgB/Yu6d8gx+hHZds9llgXvm+f0t7zGddsQRqZurae9gPWbO4bSJK32qtNzui7V1zzEMpTLA8ZX7h3VQkIsfwhIS/xHM150Dw7+q7+SBLJNVa1JQFlmor3PmZboelCxOq5WrFhpzoGrrQcd07Iq9gEVENeXHWimrgNIPDwXn8qIwcILAwMPpocm8CcmAQDecPQBWDFQbndu0hDLIZDy1bPO4V95yObCGpfJAUajcrwhz8wS+D/jopX96boA8bHRL7YPvZY1jEDZRb3HdeSzNIm6Cu02Aa1hNXWgc+qwTI2u6YWfOiNaO+cu0zS5rRE1M1W4KdInKJ8qOtRV7W8vNhk+FdFTXKnFRyi9Kq4PDtd0e6oOXeOEJ2vtg1u0EJ9BAB3kZp/2Valjv2yk1Y+BH/fUMcoa8rV+EX7TRcD62nj4Gs+BTgzeOwEYxt0qXB2RUCYw98wbIUdIfb9eXpc6G9r3SbxTUBE2thEsMtFyi77q1SqRVHrSNI01LIwMPlLQbi2GXoB2K6dvP81FH30LlbRsdbEo0kHYiaaNNffNO0WRR1Pl2B2+WUrP9tUiBRk+DuzeBurDOUHSFxFxe+dfcDbQlq6bMiGPqs8vwHoqBgogXJwCGNXq5pR1hvQyrohVKDrzJVclQxJSl0aPpr8VSDj/YsdEgmF6m+PfrLHl/PRDL88xBUMLIOgkwaXfwKmwH5mA/oCt2qmHJFbQkaq0wSNtjbqcT6Fh1Y8z0OBGu4qy39TTKA61UGiK
 De3pXK5w
 g7zCH8ZIESrFy1FrgxjbYNJLr/Zo7CFXxKsbDfzufGnxNjXrkx++X1URoYzFAb5pL5s8YcCUSBArwqayk7Bn/7DSDIXR8G58DWUeDarVcX9ik1c7zBATUxEura/4pEi4eR4e47D29EHoeZkmEG1tq31kKPGgzo1n9zEGuPzUcOAJ1SS5y4daMvcjCRUfjIU4A4NKFGDARVbUqMcKBADLxSTARw5rD0RIrInhO22dGLJiTFFPkvw4paGdRLQEc0zSyFfmZNMwWowDuPyHRz9Z3hvJhkDsFIEX9l4vFOjXzaDqc4dpx7l7mBoDRXdmTuFtAW/6AGWWpGs/iYtnMB/aoeEbC0gl11wkOY5iB4B5mNGEfDz0yr8ulFpctAlPd2TX1XKFFyWAjdzm2rLL1VJmNcVEAVmiSsC5dqf92tmFKW2H1OLGxSmcloRFVTNNSyMtwYbb33ITS6TwYRD07ifhGLO9pClXMquPIPhJNSK40Dck9EHf5tNClcrU75/iKBbpOCHDOCthjWDEfk3WiQtiZsxSZrDx3VkP5agOdQd1rP+FtkSwx2bwBtsxaR9Al0WRk1vHt3lK0PZx8iNJ+YLJTRBWJFxE7D67tUPdez511U/tNT90S2DV4jjCtf4c/To09kkqoPtGObIaWXFY3Ni6JHOASMw9MlCytFCGg4cOzvnrgWSpxB3tMPhcFa+dLDHyXTnQEvTD6WMTuapB68gu8U7luhESUD+Oo+fi/Zx6HhkgJlrkPxluG6UcjVup5CiTvwn2IgsnU7y62spmeZuhYj1w5GbQPV+pk+HXIvBM6ARe24zxBgxYBHNVX4rBJSg1eADrL1W6qJgzziVs0sUm5DCKA5rfEn6MwjyprOi0tu9aZEoktZM7+S5qU4AQFXIXJfi3xugDESNw6+ubIi608lKMLbQDSmMBJ2Hnt3IB1sVI7Zlc+Ws/fSgYKWQ2t7C7ae3KDMPuoecj5H3XsWwrfDrrA/NoH
 VDKyZX9m
 9SUgHkBDK3l8frVSGGjA9M0ytrsZu/FGUcLJc0XpeXD9PfF73nNstRUKA+zng9MmsO2+2Z8DumxOVsKAyHwDePmXPAWjrrePMTVmZriCoyjtu/uNRjMQsz1O5ZApib0f1F1v4wHRFE0RXfuJR0dLIv7oCWcMfEzR5NceNX/EWHqBcsbkSAWFMifCXzF2Aarp5RbOvAJLp/epj8wbw5vznnKT1Q15CtaHKVe81e5vWrksACqnqLUvLrb9KN5cWwhx9ko82bPvDe55HChE1tgumbVm1H/mSTEFaSbQZoGrAvNiAZCCZMl8GiatcfXPWoPiCjtrNCG9FC1a8sb0crWoyjPHVOTSCcbF
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

Lets first test with KMALLOC_MAX_SIZE as the upper bound for io->length
from userspace and then figure out the appropriate upper bound.

#syz test

diff --git a/drivers/usb/gadget/legacy/raw_gadget.c b/drivers/usb/gadget/legacy/raw_gadget.c
index b71680c58de6..7b579a86c145 100644
--- a/drivers/usb/gadget/legacy/raw_gadget.c
+++ b/drivers/usb/gadget/legacy/raw_gadget.c
@@ -670,6 +670,8 @@ static void *raw_alloc_io_data(struct usb_raw_ep_io *io, void __user *ptr,
        if (get_from_user)
                data = memdup_user(ptr + sizeof(*io), io->length);
        else {
+               if (io->length > KMALLOC_MAX_SIZE)
+                       return ERR_PTR(-EINVAL);
                data = kmalloc(io->length, GFP_KERNEL);
                if (!data)
                        data = ERR_PTR(-ENOMEM);

