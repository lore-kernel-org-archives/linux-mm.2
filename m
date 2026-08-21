Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1182C5DF93
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 15:13:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C753B6B009D; Fri, 21 Aug 2026 11:13:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C26126B009F; Fri, 21 Aug 2026 11:13:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B16A76B00A0; Fri, 21 Aug 2026 11:13:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 870EF6B009D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:13:16 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1DCB0C017E
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:13:16 +0000 (UTC)
X-FDA: 85125619992.06.32E9272
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3F07E40002
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:13:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XAP7sxlA;
	spf=pass (imf12.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787325194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pQVfUZyrHFxSk6Ytf8Px1CPoPWnrAzt+d/q0DUGzeh0=;
	b=hTWfG6NZVCXx71mh8F9Rmo3DEWQ+AjEPCOLLg3UWSOaifpQIGV+NplHWBFRgAZcq4dnnXB
	xGa4dDXzeuGWduitHJbep/l4ezZ3zQcLEfUAPg+nNIg1BQsKWXcpevMOc+W9pKtO3RFqW2
	Bmx9ImRN+KzmYC6diUNp55vkkGimbqU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787325194;
	b=tR9POMJM3/3A44VGyvVdS9kGz65CHGPuHmPiMdXOwQRGiKQourryI+R9SvIT9UxyNcMtj2
	YoSAQjak6n/a8mekbTyzEsY3CQ55RvoAXrohEq/hhm4DvAmssoF2lKg2EmgjrxOrU5L43A
	BN33jHiuJDrNnw7jc4RyHppt0ZtiCIE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XAP7sxlA;
	spf=pass (imf12.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-47f92e3c14bso955011f8f.0
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787325193; x=1787929993; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pQVfUZyrHFxSk6Ytf8Px1CPoPWnrAzt+d/q0DUGzeh0=;
        b=XAP7sxlAjHhkAiLcvQAy/30U5A430eKLMDnk7NmFstEDgqxnnHdikJ07UGuqJCS4FB
         5RXTg8Rt9MmCHCQwQkF3ibMIZu5BiGxENGDhrgS19Onaa9zWeNbKfi8z54MFVewdw7QZ
         zLFo+haaC8g25f/peSpWtTdN78gLNHX+GOsHRWflWnbGqVP5TzkW3DrWV3QABCBbQ2Jk
         ZJL2pu+aNHl1LXYFJnLA3rT6G1dnLX+F4VOanV0YzkVrK7ZsNguo0kf3zva6vE8DtCZQ
         Yrl5ZBZxzHacb/sO8jI1ZcsaE0D/LRzLlzo71lvey03KNI21xhRAuhJdmCdurKsvFsrE
         EsQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787325193; x=1787929993;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pQVfUZyrHFxSk6Ytf8Px1CPoPWnrAzt+d/q0DUGzeh0=;
        b=SKG1JJwOCjQeBsWx0HZY2EhYTl6xn5ObIem4KdmIRzzy/SmFuponjio2wqhAgySxEO
         MIbql7Lw7O+r404e5M/xLi8zxmQF/VI1IViohFhjk7+nDxx3VM0FmBQ/XkmiRiL0E0gt
         niVgVZoCG6dyBph+tKxMdZ3VhiFYQ+saU5mxx1gleaM3vw48KbIKootc/PBMgzkm1upq
         pGkhJe06EFV8v5DnuApfx5u+OovebGyBBFoxC2kx0tkWTlGlo+P/HBGkbSoWJgVzEgZu
         Ik9q6Wdbc6yiEPwv6Xnm48i/fE6buiHDA+QKHenGmzOorwPn9u6qNx1zMYehJgBQpQK0
         7ZvA==
X-Forwarded-Encrypted: i=1; AHgh+RpSgVUUCsW/C2FomqcZ9nnLE/y2nkgkDPy4KeEm5S1ty2gz2EdUDQx1vtZQVPjmkC86nR+AeuyTYA==@kvack.org
X-Gm-Message-State: AOJu0YzOv/BIVEnFzNGAn0I8CBIigdCPXPDROom1LLX2Ag2PrcpxHxn/
	zW8uYeAhVSxV5whffIfUAdqMCkzmZJtu2diDhG5yz3pi1AOEIHxu0UlQ
X-Gm-Gg: AR+sD11z+u9OB99eXIDOk0QgJkZmF2RG2c8eCbtDz1j1Rj3+z0fuYweNQd1l/Pjvwap
	z8KJ1Q0B8ldJxj33jPkHBvEqn4ptZsVFD+IaFEt+SVGJPrG9UWjU6QxY3m4k1ed4V7RhBEjeRh0
	EON+e04I+1D+ykjzWJCpOwnApi/V/FOTYaDa5mcKViaGrdUbAO5ZoAs5Vdx3JQe9QK54c4+7eAE
	gseYL8NUsEW3W/x9Uh8f2ay8N3GAss8uPYIGjnbsF2Nm1gd46E4iusuuOb/2r934XziJaQTNcsW
	deVttwFnNBf/NgUX9jRkhg0G9DFfbkkUtcKTf/l8sx752S82dY4HnLa8dt+qQB/1H31PbpKYAS2
	AXe3hKI6sXR8PmTij1lKm0nTZi0taGsD0d43CrLjHv0culaa262fwKd4hvXgPRwKmxJxuX2ETyQ
	Iw/piq6r3VCJ6z82uWh6PsYcKRVCsJRAPePasxFwCgxjuTYfEXIkhHvIBbJXBcaE/RIzcVFI4qh
	Toyz2XDfR/13dApN/0hwYSIBQtcTa89necG
X-Received: by 2002:a05:600c:3b08:b0:499:b402:6c0 with SMTP id 5b1f17b1804b1-499b830d671mr93768145e9.3.1787325192330;
        Fri, 21 Aug 2026 08:13:12 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499b90e3170sm36283225e9.5.2026.08.21.08.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 08:13:12 -0700 (PDT)
Date: Fri, 21 Aug 2026 16:13:10 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "Zi Yan" <ziy@nvidia.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "syzbot"
 <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com>,
 <apopple@nvidia.com>, <byungchul@sk.com>, <david@kernel.org>,
 <gourry@gourry.net>, <joshua.hahnjy@gmail.com>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <matthew.brost@intel.com>, <rakie.kim@sk.com>,
 <syzkaller-bugs@googlegroups.com>, <ying.huang@linux.alibaba.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>
Subject: Re: [syzbot] [mm?] WARNING in ep_write_iter
Message-ID: <20260821161310.28255793@pumpkin>
In-Reply-To: <DKUOVAQ3T03S.14GFWAHY0I6HO@nvidia.com>
References: <6a820ebc.9ebadd4d.20b15e.001b.GAE@google.com>
	<20260816135201.98590b17b526dda8c4ec9105@linux-foundation.org>
	<20260821093039.04538795@pumpkin>
	<DKUOVAQ3T03S.14GFWAHY0I6HO@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 1ubg1it5xwaomp6kojpg1in66nmedfky
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3F07E40002
X-HE-Tag: 1787325194-355105
X-HE-Meta: U2FsdGVkX1/z8LAzCj8k4Im5rGrERyxVQG17u0LZKcPiBfQH9COhDGLTteOL5aV8Ya40h4oN5P5QNoy1VixmlSPptFj0CN6JNRT6tGK0d4CWGNGnfMQMcSqmOhKz9Ak94A5r5ycoWKHkKMlgJujtXgaQebeCqQgxAQIXyAmgNV3zz44ALVWQXYsKf40Fc8hB0uuct7Aoo6XFlyXO7GIe6CdUhcAvhN6rnekrGUGDjJZSkOTqsE5AduerzeW3ZxCVOHwizgJZjT0j1WbVvaRHzmOe1h2ts7+by/eHx9ImZxmrvxrsgU1iQwG3EV4qzfHz2SYLOusBZ8XrYe8nwafV37m5+g0SAc2JZz0hfAgMIkqUQzOT57rUocSaOizCDp3okkH7HLCskyYDma3AT2lZutZAsk2WbbGvO47uuO6dM0pbhVuT1res29IpHyrAKzbdMqAQdje9NuAukFUY00Z+gQQXWsKSp0ms2DpNs8FB6U3X8MfBz7tb+H/lyduu7wNuA9lpzBp80WGTh6EmHepeQkcwGWOerSb5ajmqSnjfHjuvgaLR0rOSoF10lJYbMMZY8W+YKrSFOu/NHe/x2lUd6XMNR4EihmXWzTgAM+r/eseHT4naaBPtqRIKe9B0/mI1GJ4nkjAhB50KEnHVIjc48scoRHiet7LsJ9TJFMxorNeQ5l2/CiPrHuQQk495xC8ea0Qwdl7kM/84eYv9B6pjrtifjQsxsW00ovAqkS8imEg7/tl4F/1THOzZ6BTkwMD2GCuhQEja63anryaFj+G2SMhzcdqz2XY94m2uYIPQke3kg8f2hQQ5+ndhy3vn943e5H64TDaI1nElGO9pYksJSsYh+HmngzhxygnNjYZWh/oqV0ruCr8g4j2jUA+pYuh6AV82Myqb89/fJDDzqyK5it4RShlQ/ukj37wyf9sZMyN7lnKSiEmdv/xBihfkPSUrMur9NDh89LjlYzIpuG6
 p9cV8E2l
 Zvp0BCmWD4UnjmDi+URWkh3zPxfNcFqohQeNO+rsN2ilklra/vGWiviPgLtNoibPRL2KxkXwWO8O+Ag/5cfWlbgeczj213YDkoESO2w85Rj2PBQQ8bmhrR6ZSH8cfGnLrAYUVyF47MVYdy2AOkWeuS4H0TgAUzgk/EqYoRA8KhGXKB/5KZhauwNh98/QH6SKSFoERABzH4SjIf0YR0ERG3clqx1UCt+7HirSDV1KpHp7M7IVULRPJ5yWID7xX6HVIETRIsKnAhdCjowhTjj84Km8f+acsrOz1FC7iIb6ml/CzTcq4OHDigjKkmtoLG9p5WcF1OmGWjvbbOS0Twyg8zO/fA1KK7PR15aPs2raw5DsFDwoO52Orie0mXZ4UXasvVGuBsDoLebtVdvkKL0jkBDcF3sqPgnflcvgvCJV1aXO2IGJCk6Bfr+NbSfpNLbDYUnbBi3OcK3RnsFORwKpaFbc1tc8//FO8BYVib9aql+16i4EYEKYctAzUp9SUzOXYryNRzHja7MMqOLDjEp8Vx4XGdLB9wOOM/WAlYtgkLZsUKNhtbTC6n3en1sZN3nevXmeyR6T6adrqv4XRRSdEZuXhHs/ZB9IjMKpU63q6HsYzcVVTX6ooKQkAUfjfQp8zNLrXq3ivUQgM3bDzQITVuQrueHv/6/KPI4c/jq4UyewrGQXndAhrOG+dxHy9Cc6SMPmy6odygUa+vzyjwmWteNjuvUwjCEhhTq0mtD7v7j46ZwWqTasTtY1oB+gIDKI8bULeAR6pmjGkXzd30xDtwEv0UadWd6RaBK8RrigPx8UjQUuFR6PubBOMfTOZ1bFmyd8vlHcYRQDGUFP7rewVc53npXwkom8uGhitj96Pvzk3tjPzQvS1jecTKJ19KZ8vYlqrQ2sCGAu4zNx2rSBvuE8c06imhJuuIBPOrsVFGSEbV+GDobqnmUTTyyBJGrNE+z8vnnpt3I1/2FDOcycmWQt0jjKI
 rzsiubxb
 L8ryiLNhD3zieKJrMafsClo9YDqDQnljss0JB0tF1pSoe+fYajwSRkxef4Oe1a7qfSH1NCOBDTjhwuaVedK/wSadtsM2zaymdfpATGvKQDAcbwKkZjJiBiwD/hGhc/VAPhNxD8SRzvzKeK+O07JKixdMmtfCdUlMe6LlRffaJa2sjdnFZuuJdS1eLov4I7AuZRjgM9lFZTG8G0pv5CeflIh6dQZQ1BxXaTj6xQl74Zebg3KGODKZbAZ6rZPFepUq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 21 Aug 2026 10:24:36 -0400
"Zi Yan" <ziy@nvidia.com> wrote:

> On Fri Aug 21, 2026 at 4:30 AM EDT, David Laight wrote:
> > On Sun, 16 Aug 2026 13:52:01 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> >  
> >> On Sun, 16 Aug 2026 12:25:48 -0700 syzbot <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com> wrote:
> >>   
> >> > Hello,
> >> > 
> >> > syzbot found the following issue on:
> >> > 
> >> > HEAD commit:    3d6d817622b0 Merge tag 'scsi-fixes' of git://git.kernel.or..
> >> > git tree:       upstream
> >> > console output: https://syzkaller.appspot.com/x/log.txt?x=15927479580000
> >> > kernel config:  https://syzkaller.appspot.com/x/.config?x=a59830cba91a1981
> >> > dashboard link: https://syzkaller.appspot.com/bug?extid=805630f1453e490427fa
> >> > compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> >> > 
> >> > Unfortunately, I don't have any reproducer for this issue yet.
> >> > 
> >> > Downloadable assets:
> >> > disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-3d6d8176.raw.xz
> >> > vmlinux: https://storage.googleapis.com/syzbot-assets/d19e0514c02a/vmlinux-3d6d8176.xz
> >> > kernel image: https://storage.googleapis.com/syzbot-assets/f6da706811f4/bzImage-3d6d8176.xz
> >> > 
> >> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> >> > Reported-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
> >> > 
> >> > gadgetfs: bound to dummy_udc driver
> >> > ------------[ cut here ]------------
> >> > 1
> >> > WARNING: mm/page_alloc.c:5280 at __alloc_frozen_pages_noprof+0x2ce/0x380 mm/page_alloc.c:5280, CPU#0: syz.0.0/5319    
> >> 
> >> Thanks.  drivers/usb/gadget is the offender.
> >> 
> >> Gemini sums it up well.  "ep_write_iter() needs a bounds check prior to
> >> memory allocation".  https://share.gemini.google/5NzjyttO0ULc
> >> 
> >> I expect an easy fix would be
> >> 
> >> --- a/drivers/usb/gadget/legacy/inode.c~a
> >> +++ a/drivers/usb/gadget/legacy/inode.c
> >> @@ -666,7 +666,7 @@ ep_write_iter(struct kiocb *iocb, struct
> >>  		return -EBADMSG;
> >>  	}
> >>  
> >> -	buf = kmalloc(len, GFP_KERNEL);
> >> +	buf = kmalloc(len, GFP_KERNEL|__GFP_NOWARN);
> >>  	if (unlikely(!buf)) {
> >>  		mutex_unlock(&epdata->lock);
> >>  		return -ENOMEM;
> >> 
> >> or do what Gemini said.  Me, I'll add some cc's and run away.  
> >
> > Should there be a separate flags for 'request too large' and
> > 'no memory available' ?  
> 
> What flags? Are you suggesting kmalloc should return an ERR_PTR to
> distinguish different error types?

That would break to much...
I was thinking of a GFP_NOWARN_TOOBIG.

That isn't enough to change the errno though.
But a smaller sanity limit may make sense anyway.

David

> 
> >
> > Although the errno for 'len too big' should probably be EINVAL
> > not ENOMEM.
> >
> > David
> >  
> >> 
> >>   
> >> > Modules linked in:
> >> > CPU: 0 UID: 0 PID: 5319 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
> >> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> >> > RIP: 0010:__alloc_frozen_pages_noprof+0x2ce/0x380 mm/page_alloc.c:5280
> >> > Code: 74 10 4c 89 e7 89 54 24 0c e8 0e 2c 0e 00 8b 54 24 0c 49 83 3c 24 00 0f 85 ab fe ff ff e9 ac fe ff ff c6 05 95 d2 18 0e 01 90 <0f> 0b 90 e9 17 ff ff ff a9 00 00 08 00 48 8b 4c 24 10 4c 8d 44 24
> >> > RSP: 0018:ffffc9000e13fa20 EFLAGS: 00010246
> >> > RAX: ffffc9000e13fa00 RBX: 0000000000000013 RCX: 0000000000000000
> >> > RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc9000e13fa88
> >> > RBP: ffffc9000e13fb08 R08: ffffc9000e13fa87 R09: 0000000000000000
> >> > R10: ffffc9000e13fa60 R11: fffff52001c27f51 R12: 0000000000000000
> >> > R13: 1ffff92001c27f48 R14: 0000000000040cc0 R15: dffffc0000000000
> >> > FS:  00007f6f4a58c6c0(0000) GS:ffff88808c549000(0000) knlGS:0000000000000000
> >> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >> > CR2: 00002000000010a0 CR3: 000000004323d000 CR4: 0000000000352ef0
> >> > Call Trace:
> >> >  <TASK>
> >> >  alloc_pages_mpol+0x212/0x380 mm/mempolicy.c:2490
> >> >  ___kmalloc_large_node+0x4c/0x120 mm/slub.c:5274
> >> >  __kmalloc_large_node_noprof+0x18/0x90 mm/slub.c:5305
> >> >  __do_kmalloc_node mm/slub.c:5322 [inline]
> >> >  __kmalloc_noprof+0x405/0x720 mm/slub.c:5359
> >> >  _kmalloc_noprof include/linux/slab.h:992 [inline]
> >> >  ep_write_iter+0x1bc/0x500 drivers/usb/gadget/legacy/inode.c:669
> >> >  new_sync_write fs/read_write.c:595 [inline]
> >> >  vfs_write+0x612/0xba0 fs/read_write.c:687
> >> >  ksys_write+0x150/0x270 fs/read_write.c:739
> >> >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >> >  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
> >> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >> > RIP: 0033:0x7f6f4979e0d9
> >> > Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> >> > RSP: 002b:00007f6f4a58bfe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> >> > RAX: ffffffffffffffda RBX: 00007f6f49a25fa0 RCX: 00007f6f4979e0d9
> >> > RDX: 00000000ffffffb9 RSI: 0000000000000000 RDI: 0000000000000004
> >> > RBP: 00007f6f49835024 R08: 0000000000000000 R09: 0000000000000000
> >> > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> >> > R13: 00007f6f49a26038 R14: 00007f6f49a25fa0 R15: 00007ffc6cf49328
> >> >  </TASK>
> >> >     
> >> 
> >>   
> 
> 
> 
> 


