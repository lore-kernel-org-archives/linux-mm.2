Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 454EBC5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 08:30:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42C646B0095; Fri, 21 Aug 2026 04:30:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DC976B009B; Fri, 21 Aug 2026 04:30:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CC996B009D; Fri, 21 Aug 2026 04:30:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F13376B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 04:30:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 81B3580394
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:30:48 +0000 (UTC)
X-FDA: 85124605776.15.B245FA1
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9DE08100005
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:30:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KscMHpfr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787301046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lyfcV4Df+65/DQ1eOj+l5WFBcZoPoGdndN3U5MTnEq8=;
	b=QHltB8uiAQfx5aj43XJTDpby8YLakIokXNGhyUZKVlqDk/0+0qf7lIX6I19Fu7ojD4sIL6
	/CbxhE0jJIgmPVw2LtU0+D2z+Z+VGtN/1UWpIiNBkVXPzhsgQOQzV1fyd22Z0/3Il95XPt
	m3L1q7RRs0bfFi8CXJFCTirrEPKwzxw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KscMHpfr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787301046;
	b=ObRQt58VsVNkchnoQzaS7s0JarFVNhxBWRBR83d17akjLapfIvIC+TbTsst8lddLBmcs0A
	iYGtfvnh/QHcWgpnX86ze6lwDvw+c8EUfAln3dmsyAY6nVHmkofE4BByoBXa6mHvtrLKt+
	8Z9eO1RzqXeCiH4Dggf+9+y7AKBBztc=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4998b5a63e2so6198115e9.1
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 01:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787301045; x=1787905845; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lyfcV4Df+65/DQ1eOj+l5WFBcZoPoGdndN3U5MTnEq8=;
        b=KscMHpfrEBQhiyuFCEGEm5+mIjOAE8uDO0gNjl1IjePxsA9jBoF+qvrMpKJkx5UVvJ
         6X/F2Tin1Lg+zP7kYpyA6+CZlvcNN2rRmUBk+GWldoCRC6/UoOMyPKo8/M3s0nEm8UwO
         zRsqiYejdTq1nPIYjC39iqtskw4ECftGepd40Mv/dtgsHMtujscGdn6V5b6i8/dOcWZK
         08WxniwqLK9G1yTs+4VWpOuO8Vn28x0BCDQg4c/fv3qSj6kOHgZyE4JSDkuFH0h5Q73P
         Xs5VhW/QxryjCfZZNj2Ni0yExxveqtlNRlhccZhuvWTbjBryFSbOSKfinn4L3b5KG/Dm
         Hyow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787301045; x=1787905845;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lyfcV4Df+65/DQ1eOj+l5WFBcZoPoGdndN3U5MTnEq8=;
        b=jwemBO0dE6Igtl8Y4tt5V76Qqmnm47gHWVMrtua/spQUjpGSi6bdyFIaZbKD8KY+/X
         GIJgXi/6cjxtX/dUp4YGJ3KNG8Zw4iUxK4zSMm+et5uI5eg3lPQTUut1B3J7kXHJSCCR
         V4IoQXC1Kir+39GkqfQAm9QysRRBxehIU8JdHy1MBjJ/pUo7VzqOzAzP30P8DMbnumVe
         Xna4JhzIHj03qI5iFlKS+ktppcx/xhycm1818ToXADq8t/TxPpTxW/sHRsTo3co7bEoe
         UpXZc39jJU7ZgDIBmfyL9ZnMH80SasJisV8Bc8cd+QrfOXWVHhsgjQmfLEZcspw2oigZ
         1gXA==
X-Forwarded-Encrypted: i=1; AHgh+Rql2lRFWv3mJ8UB5YdknikILga8BBLQWtzRL9bXx2Q8Fgx+a3zIGU1G8MbvqXuKyKR2VSAULYW3aw==@kvack.org
X-Gm-Message-State: AOJu0YyykG+W/bnQ7FvjGlDt+JkYENUBOcY0q9DDexOVs/es3C9CEsKR
	H4lrfTH13vYbV5tkQ9hyJYc78DoZY9+liajZZI8eH2PInQJurYXzrYS0
X-Gm-Gg: AR+sD13+Iuq92beMEYZ6YK+Mlp9iZIbPLG+Ly2pwcSp2xg/Snq58vhjiFtV0KSgBQgD
	RzyJAnkdIOyHJaX0p9QZSyB5gH4uN0ikS1KbRMLzWUiwuxlp99wVj7XQuyNyjoEtrp6MYklSh1f
	8Mo2MdAOwVFMQQmxTqk+HmdwzNKn86FLhjIuk7KnNroHyobHtAF3GIfPviUJBNRKqFYe9q+Ir8o
	QmqWNch3CNjFxxNtO5tqrbQw6OYdxq01998OFliIrMqmX9fEx4BrRJ9s5HEdeoYPVH+8tiFbLjV
	q27BUopeMsyQjbIr9P9sEmX5pTV8/p+l3FueswZoapHoLy8ubUK3+a5+p8Rx0OGQaGqzHE3laMY
	AlOpLjwzFlB6vNbR5YeiGSfeCLYL3BwC4065KIVMlp7umjW5MbyfvjpPki6bormImSdcmeJf19F
	vtJXdF1OB75LPFAJfXo4VEY27JdY/1NWujAe1JOFKECF72Qk3/XKdPXpVDXoEnDDVRotDMaCzxd
	eW79Qb3wvurfdk8Ozc+4JkMZw==
X-Received: by 2002:a05:600c:3556:b0:495:48d7:f178 with SMTP id 5b1f17b1804b1-499b8454819mr57213275e9.11.1787301044894;
        Fri, 21 Aug 2026 01:30:44 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499b90d67bfsm19315855e9.3.2026.08.21.01.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 01:30:44 -0700 (PDT)
Date: Fri, 21 Aug 2026 09:30:39 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: syzbot <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com>,
 apopple@nvidia.com, byungchul@sk.com, david@kernel.org, gourry@gourry.net,
 joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 matthew.brost@intel.com, rakie.kim@sk.com, syzkaller-bugs@googlegroups.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org
Subject: Re: [syzbot] [mm?] WARNING in ep_write_iter
Message-ID: <20260821093039.04538795@pumpkin>
In-Reply-To: <20260816135201.98590b17b526dda8c4ec9105@linux-foundation.org>
References: <6a820ebc.9ebadd4d.20b15e.001b.GAE@google.com>
	<20260816135201.98590b17b526dda8c4ec9105@linux-foundation.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: g4pncate4pmnab9kqpdshxrsneakqswj
X-Rspamd-Queue-Id: 9DE08100005
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787301046-849906
X-HE-Meta: U2FsdGVkX18rs4SD+Fp7Nr+GkC0JoOfeV4fVchgKI4+VT1VhuTSIAj826nA9x1hNXBA1cz05FzlCet5bgwph5XBcDZMscf6ocYCwSnCbznHtIk2+F7djU5dgbwgC8i5QRH8xlE/lIJ4AZoHzhLK+IXTby49ZUEuqhqHfr7qUaNtwSyeg9Epvt3eUEtfNyoWX6i1tKkMs5ChEYu6x8AgpV/syK7JI4BluCjHSl6kUoZlzJ6FpZ6lx0TE3goyVGdoAyEaf277jHfijQBCpkPdkJ1lyb7u/aMNjC/EU/9qUgUevdAOfVnBSs8dC12NvkJwjwBlkQMsPJhInl/wvuT4XsnaZIzxO/6BIVDW3AquY5+RRxGO1Rhip9O9hNuEXz+Mz0/oymCPKWUQsv/GSFaLsjDm8EdbZrO2UBIx/GPcXK7XjY9kIMs8ldWsPwuijup6nvHKcLlSAInp0NbWtTalNNJuYAdkqkqps1wZ2gkWagR3KSwixVrhssVbMq8pe1RFIwvDiBLrPOa+SDIW3JYKaL3Q6XGmJGp9D4FwAvlDeidwVsEPfEVx4JV/bCLuzYKYxZDGTVMKa4f/1km5mgqYzqMz0hVr+mhA64RcfLodkjv3Bo+RpIXYARhQlU7yIonLmYJkYMPM3OYKrVyc5JTaJqe22T4cZjpZwY1RQDB+ajy4PG36gF8FzhOZQrEesztO74GrmQrWHjPwiZetkkf2llqplWlbzDAfWD9nnlsgFF4JkpCIfXH0NkcbuP0cT518S1PBfkZQ15GjCmVzTNxnPuIFB0xxQmrD1pSmJd5He52SSHzVe8KIKQgWpAgZdl1W6nrGbZ8d0d6hrHEb0P1zystr0WdMvw7mQrCJCarhuYbPM7qfF8hSCsxbFPNnoKfadTUOsU8reY5Dh4nsbNvs4JpwZkJhZLDje7L9vG2NmWJ0z/8zFOmZlzuy/syIP6roKxlktrhjq4davW0h45z5
 ozg/JvFT
 t0jRfaUhItXwb8WfqxqcgttFH8trLAjVyugXPc/swkoplG0+k2AcVcffUtp4C9vt5v2Ej8En5wvm5Sn0z4kRhLM7wrFl08cp4F6BavwU+dzBIwkOISToNmcnNm5m49d3uw3TGbSFrXUgbVcglm6RZdp1GgeFX937IzMXTNvqgcpruUEMJ4Gx9tDJCzdAIcoo8MCauf7Lq6PA/G5BA823BAbkTbicTd2oLnxopE6YiX5NoI2gb8MRBiUidpoOZzrhHxjo77VPdgnRyVRuOQOt3AH8GtWaLfJ8Ub4ABJRrQbMk6wJOhmODEzCVZXBm0/B9FDrYsZ1QHM7YF7lkndbFi3CaKgp/1FiMzfptBXyjJl8jcEd0iY0p51JPZ0bTkNBQfZsq6sZIDmKMPEBs7CFz812kznLOscum1aiv8DfLvlcCcFvl2JcsENXGgYosEK110xrraV6yYoxdJOSGqEwLynWsLUHKc6e337Q+zfNfdyXHBTK07TrQ3oDkjTgW8QYIdCzHzMCWlZdyIS6kbBWUpl3oZRJHbkhRVm+ymQvFNN9+ZpT4CKjfRSECJQ+qJ8GovzC8/L07NaLTxwo6l394xhNb/ryMrlNt4t9gmPXmWqZdlUvMp/GgqMikR/2sQ4xzYvbDoXbX0eDWx5PbF1s8QadIe+GsSlLd6b0ZNLK2S7s22fvidpRs1qillleLFhXDdRTFIsCtLTvJ3Q8KMLEtaY5fKIGhhQ/uaM1OcjmtPAuMCVhH8Z4SGq5plsp31VwmMsI/JHSBmpJLBrEx79qswfRox+3Zk4/oWABZ3Aav3xzr4n2GBd39LUyqAwM/rFoVTFK6lS5eJFjmEDY6jH2rTK5WgnWloIu0UzcvUWemDWuw2gNCRe9HJWYKxqrSZ700m4bwRZKDzrez+bVvmR+NReOrr8naoXKwhebpKiv7Ghp6N5S8HNxKf57OfdKJjXs0iehEmAmPF0x7n1Hqcvr8pTPPXKARC
 7EQjGtVx
 mKpt+fHvkFi18+wm914vJfmm9bk8PG5kzDeHTxWqN6aJhEXdG2OxN4ktcsghikAgsxrw2W3FCq3B0OuJbbaoQVKAdr5jY1itYcSvOYoCpsuaWPCbj/Q51vMoBlOKHUYfc0Uh/ObihyQBErMHLcMlOkyanJDbeSYHQPwebmkHNSKOyJvYqXK+ETD8iEGGkciXgijMzzrD4psm16LBKIswNclq3H6zXo8R/9MJbetCHZo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 16 Aug 2026 13:52:01 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 16 Aug 2026 12:25:48 -0700 syzbot <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com> wrote:
> 
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    3d6d817622b0 Merge tag 'scsi-fixes' of git://git.kernel.or..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=15927479580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=a59830cba91a1981
> > dashboard link: https://syzkaller.appspot.com/bug?extid=805630f1453e490427fa
> > compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> > 
> > Unfortunately, I don't have any reproducer for this issue yet.
> > 
> > Downloadable assets:
> > disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-3d6d8176.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/d19e0514c02a/vmlinux-3d6d8176.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/f6da706811f4/bzImage-3d6d8176.xz
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
> > 
> > gadgetfs: bound to dummy_udc driver
> > ------------[ cut here ]------------
> > 1
> > WARNING: mm/page_alloc.c:5280 at __alloc_frozen_pages_noprof+0x2ce/0x380 mm/page_alloc.c:5280, CPU#0: syz.0.0/5319  
> 
> Thanks.  drivers/usb/gadget is the offender.
> 
> Gemini sums it up well.  "ep_write_iter() needs a bounds check prior to
> memory allocation".  https://share.gemini.google/5NzjyttO0ULc
> 
> I expect an easy fix would be
> 
> --- a/drivers/usb/gadget/legacy/inode.c~a
> +++ a/drivers/usb/gadget/legacy/inode.c
> @@ -666,7 +666,7 @@ ep_write_iter(struct kiocb *iocb, struct
>  		return -EBADMSG;
>  	}
>  
> -	buf = kmalloc(len, GFP_KERNEL);
> +	buf = kmalloc(len, GFP_KERNEL|__GFP_NOWARN);
>  	if (unlikely(!buf)) {
>  		mutex_unlock(&epdata->lock);
>  		return -ENOMEM;
> 
> or do what Gemini said.  Me, I'll add some cc's and run away.

Should there be a separate flags for 'request too large' and
'no memory available' ?

Although the errno for 'len too big' should probably be EINVAL
not ENOMEM.

David

> 
> 
> > Modules linked in:
> > CPU: 0 UID: 0 PID: 5319 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> > RIP: 0010:__alloc_frozen_pages_noprof+0x2ce/0x380 mm/page_alloc.c:5280
> > Code: 74 10 4c 89 e7 89 54 24 0c e8 0e 2c 0e 00 8b 54 24 0c 49 83 3c 24 00 0f 85 ab fe ff ff e9 ac fe ff ff c6 05 95 d2 18 0e 01 90 <0f> 0b 90 e9 17 ff ff ff a9 00 00 08 00 48 8b 4c 24 10 4c 8d 44 24
> > RSP: 0018:ffffc9000e13fa20 EFLAGS: 00010246
> > RAX: ffffc9000e13fa00 RBX: 0000000000000013 RCX: 0000000000000000
> > RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc9000e13fa88
> > RBP: ffffc9000e13fb08 R08: ffffc9000e13fa87 R09: 0000000000000000
> > R10: ffffc9000e13fa60 R11: fffff52001c27f51 R12: 0000000000000000
> > R13: 1ffff92001c27f48 R14: 0000000000040cc0 R15: dffffc0000000000
> > FS:  00007f6f4a58c6c0(0000) GS:ffff88808c549000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00002000000010a0 CR3: 000000004323d000 CR4: 0000000000352ef0
> > Call Trace:
> >  <TASK>
> >  alloc_pages_mpol+0x212/0x380 mm/mempolicy.c:2490
> >  ___kmalloc_large_node+0x4c/0x120 mm/slub.c:5274
> >  __kmalloc_large_node_noprof+0x18/0x90 mm/slub.c:5305
> >  __do_kmalloc_node mm/slub.c:5322 [inline]
> >  __kmalloc_noprof+0x405/0x720 mm/slub.c:5359
> >  _kmalloc_noprof include/linux/slab.h:992 [inline]
> >  ep_write_iter+0x1bc/0x500 drivers/usb/gadget/legacy/inode.c:669
> >  new_sync_write fs/read_write.c:595 [inline]
> >  vfs_write+0x612/0xba0 fs/read_write.c:687
> >  ksys_write+0x150/0x270 fs/read_write.c:739
> >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > RIP: 0033:0x7f6f4979e0d9
> > Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007f6f4a58bfe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> > RAX: ffffffffffffffda RBX: 00007f6f49a25fa0 RCX: 00007f6f4979e0d9
> > RDX: 00000000ffffffb9 RSI: 0000000000000000 RDI: 0000000000000004
> > RBP: 00007f6f49835024 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> > R13: 00007f6f49a26038 R14: 00007f6f49a25fa0 R15: 00007ffc6cf49328
> >  </TASK>
> >   
> 
> 


