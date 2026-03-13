Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6766E107BCE6
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 23:08:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 758096B0088; Fri, 13 Mar 2026 19:08:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 705AD6B0089; Fri, 13 Mar 2026 19:08:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 611E66B008A; Fri, 13 Mar 2026 19:08:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DEBC6B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 19:08:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D3B415859E
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 23:08:35 +0000 (UTC)
X-FDA: 84542580990.12.017C76C
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf15.hostedemail.com (Postfix) with ESMTP id E57C1A0009
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 23:08:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=QMV3pHhR;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.41 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773443314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iQn6r17fR0ZCkH5iTyR5vE7sb4nJUi8kn661lqcNUlc=;
	b=q3dGSWx8h/eV76IHyFibj9/EfPqnEhpuiM8uLNAtUwxPhg5h4NfNV3ypbpYSZS62k7NYy2
	/75eFU4ImR1T3I6eIA32OqqnucoUyM7RBdtqdrHsiDwO2F4Fj7BvkwG0aFhQf9vXkXoADe
	g13DiO0y+ANtcPAK2s+gEHXEey5Hg3M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773443314; a=rsa-sha256;
	cv=none;
	b=62AoqkYbVgomu4pnmoqNNLDXbOJrCYepG8m97pizkAP73rsxUqFP6sea971c6Yp3qRDYvL
	pd5NfCtWPsUEUWItI66ByXxlk/6dhQuq+LRIpOqP15hO3JymiMzVod8x/1R1/ucxrIouDI
	Tf1y0e/N64uycjRikCNyTeh4gt2hOYA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=QMV3pHhR;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.41 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-89a0d53f3d1so35304346d6.3
        for <linux-mm@kvack.org>; Fri, 13 Mar 2026 16:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773443313; x=1774048113; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iQn6r17fR0ZCkH5iTyR5vE7sb4nJUi8kn661lqcNUlc=;
        b=QMV3pHhRWTKFfkZlDHFoGrkTX8tN8o2yPacJDeB/ikHCBJC9WMQuf+wLjqhS9hfGW4
         RnbfQO8hca62JJ4WEX/uPfdQZSLDhvJs9kZKY5TTD43bwv/tR0bk2qd41O8BG//yprmq
         26OJijF01DLEUW0+9Uqels6nR23ZW25mLFC0MuiJ6v7sClGukje97w3bFOwhS1TUARUN
         tndk+s4Sl8qkaaZyt30qCxppzQ6qouWfxy6Dc4pokYVie8tVq06YQ6B6XXs0CZTFgeCl
         JBhZtw4ALnz3BadfT5VZstm2KWZnvWp5VgP1K3gi0Mtl7rxujoh1I8QpfAEIi0bOA1xV
         w7VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773443313; x=1774048113;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iQn6r17fR0ZCkH5iTyR5vE7sb4nJUi8kn661lqcNUlc=;
        b=ly3n7l8F85cBP0UQfC5qTcwBsC+3m0kvVd5Exi3vB7wpOC7NRia46L52Z9mvWgQMiq
         D9dRin33aySzc+8qCTQ7ch09a+mcStHxJGusZm6v+WXLTzv+ieUy739LyNPsvdK4vIwD
         qVHY9vUx6GXRloo6SkN70GYD9eMrMIPk7TEXLnF82tKHtaLnTOiN/OOaiE81NqasZhB7
         VeChOI3m/M+vcO3RqIYTfNsyTioH7BU+oYHrtBHBtMirpvx6P9Da0EZO2JlxCRE/KrXq
         SgHI0wBdkeOxCH4AJCXJ2fxwcyaFJ8z8S8FKecCLz/xA1jdz1kRuBFhGvehrrs4jwi/+
         B7nQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWzIKWPkOMT+spgpKj/kYTm9csWH2U6sW9USxoCzt95aEkrbdvJGtabpKRC2HV2equOnhjE5EpLw==@kvack.org
X-Gm-Message-State: AOJu0Yw49GyL4F5+l0dh6JVPPu73jNIKy8/wdURR+egmE/gg0muUL2rq
	WlxV3x7/pi5L7l4hGuTDAIrarq+CqvGaapRz55IoUUNPjs9H8mcwJWt10BQ8BFTquVU=
X-Gm-Gg: ATEYQzx8Ior3HLIlE6qNS/lJ5WRf4bIbEWYKmeQhzNYd4x3HM9X1L+2+sfY4V5zT5eR
	/FFOs/+DE8oXFBacqijgM5dOcHywZTv2j6yA7RjPaX4A9b6+A8/p+KS/Ly1EzHFPW2sEgonTB6/
	fiHyguaCuBvg+CbX8jUxLHKCby2cFso9ucKUhDtCJJf/BOdEiZhdA2KOytfx6uM2d53ivRvyXfI
	czCgGTeWCvrNZbyUgP3S6O6cqzgDa0y+RMbL7DdFjiWQU0IAeQB/XlfuROlrkw4D3xvNQ57yk9r
	XKYXRGYCZ57N/fstElB90OF+ZOaVrkVxnCLbUhI2J1y7Eru4mDGLRIEXlj+5Y3jNWcaRMNqgx8H
	YZkLwfdh6z2xoM9aT6SjNsLrMLvqlkofYX+91KWHktDCCbQyWTqGHpS0R9Ac1Qc2dPO1TTb3spJ
	I2RLusLfYOm12L8Mncqzc1Dw==
X-Received: by 2002:ad4:5766:0:b0:89a:c88:1fb6 with SMTP id 6a1803df08f44-89a820283abmr79354466d6.53.1773443312789;
        Fri, 13 Mar 2026 16:08:32 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a65cfc409sm67174226d6.35.2026.03.13.16.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 16:08:31 -0700 (PDT)
Date: Fri, 13 Mar 2026 19:08:27 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: syzbot ci <syzbot+cidbbb79a1260c5a35@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, david@fromorbit.com, david@kernel.org,
	kas@kernel.org, liam.howlett@oracle.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	usama.arif@linux.dev, yosry.ahmed@linux.dev, ziy@nvidia.com,
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: mm: switch THP shrinker to list_lru
Message-ID: <abSY63WnrSv69vw1@cmpxchg.org>
References: <20260312205321.638053-1-hannes@cmpxchg.org>
 <69b44bda.050a0220.36eb34.000d.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69b44bda.050a0220.36eb34.000d.GAE@google.com>
X-Stat-Signature: guroqsq4fwhh7tyzt9r14ctouppaw8px
X-Rspam-User: 
X-Rspamd-Queue-Id: E57C1A0009
X-Rspamd-Server: rspam12
X-HE-Tag: 1773443313-649765
X-HE-Meta: U2FsdGVkX19O1lSa1nrkxDQFh+svmQ/6lsfxy7UDKh2kMotQtq28eGcUqa5WpMLeuDADF4i1YP3UAhny50TrnXzzGVCpOm3pQcnP6l2KngOM9fXp7LfNu/115Vu5BpdBGUYBi64Geb2h6lDSUoI+LcU/15wgXH8kb0HKqeu7PcViaiGrdU2ubni9V1KYpmnGKVjYmB3wzG40H/wG5tzzh0bygfKhj+cm0eaZ3gJB0/MiJ8dR2rsFtcSr8Mf5ikazHy2WAH8t3dEG53lb7j7A7mRy4a52x/gXLb1zgKXoIV0VelvZaQoIPGAMNUoQG65opegwIOjXSXVQDz8w87hsj4PpMBJ19N6n7dsugtPylyo1PVKfv6ZMmQDlGrORjAyDOGlHIwFMOjZbxEFSegLkamEEuPmYsgh0VLM9h0MQqsGwsGXmd1QrIY8/oEdVqudkf321mwy6BYEHNCHopuCNxWtYB4muMhk+HMXSEBhvPVq9HQWtK0dWssblcC/0DWahNovLHutIkKtDdFB9ikiRz9aueJCoIqJRNKLTSZ3M7cFecwnPUctCLN/adTdpa9KZ1pzI2x8OGsCqB0YiJ0lc3F0F0/rn9KlIOuNhgBG/DfpgvklI2wCOVcPq3iDU+wn/gnue4nhFpliBonH0vFUrN1LZjIHjIhCJfHeqa3Rv0whq8t0Dq2R8Vtxmr+HneiKVPUk2jU0eHtVCUR8OfP6bpt7ogwBYEovZG668KJVglQkvq/IAboFaNGGfutWqdgkEnc4+p5tRAlyJNp3UaPsZZqLheN7mdfn3lw4Sm+OOzjmmlND09Gq74lwD8XlFr72NYWoMK81j/6uLLD35+4tzs4W2GPfRlfPtpoJm6ivoKTFTHJnjYRmeF17p8D4m/5lFim7lK+BoawOiB2k/weRazqwfqht/Adnfr/UlhZQnEGn/klY+r+klI9JSuEyVNKGu/SnBCSjLe3YIsWIDwGm
 1Pyb6Fw4
 ualfcAXV9iK1u2flSrbzknHIjYTKdmFogEmZ+3naUEvd8ViW8jZWVD1aUsJZ2fcNO7efa6Wn/INuAuTlzmUKTL6tkN6m2/U7xSd/RuwNoxp36HUKegel0F9xNDGau/I8zJqPoiugXyzAECPL4An7w6FJh4ZiMkbrsFHFFo41FG9IZsII4CqPAoAn7j4zXJoawtvisWB4lUJpJgEC0eL8QgWSMhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 13, 2026 at 10:39:38AM -0700, syzbot ci wrote:
> ------------[ cut here ]------------
> !css_is_dying(&memcg->css)
> WARNING: mm/list_lru.c:110 at lock_list_lru_of_memcg+0x33d/0x470 mm/list_lru.c:110, CPU#0: syz.0.17/5950
> Modules linked in:
> CPU: 0 UID: 0 PID: 5950 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> RIP: 0010:lock_list_lru_of_memcg+0x33d/0x470 mm/list_lru.c:110
> Code: 3c 28 00 74 08 4c 89 e7 e8 b0 02 1d 00 4d 8b 24 24 48 8b 54 24 20 4d 85 e4 0f 85 00 fe ff ff e9 75 fe ff ff e8 d4 df b3 ff 90 <0f> 0b 90 eb c1 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c 06 fe ff ff 48
> RSP: 0018:ffffc90004017110 EFLAGS: 00010093
> RAX: ffffffff8211b3ac RBX: 0000000000000000 RCX: ffff888104f057c0
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffff888104f057c0 R09: 0000000000000002
> R10: 0000000000000406 R11: 0000000000000000 R12: ffff8881026d0d00
> R13: dffffc0000000000 R14: ffffffff9a2de05c R15: 0000000000000002
> FS:  0000555572bfe500(0000) GS:ffff88818de66000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000001000 CR3: 0000000112554000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __folio_freeze_and_split_unmapped+0x2ab/0x34b0 mm/huge_memory.c:3767
>  __folio_split+0xae1/0x1570 mm/huge_memory.c:4033
>  try_folio_split_to_order include/linux/huge_mm.h:411 [inline]
>  try_folio_split_or_unmap+0x5b/0x1e0 mm/truncate.c:189
>  truncate_inode_partial_folio+0x4ab/0x8e0 mm/truncate.c:255

File pages aren't on the deferred_split_lru. We're calling
list_lru_lock() on a nid+memcg combination that doesn't have list_lru
heads allocated. This should either fail gracefully or needs page type
filtering in __folio_freeze_and_split_unmapped(). Needs more thought.

> possible deadlock in __folio_end_writeback
> 
> =====================================================
> WARNING: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected
> syzkaller #0 Not tainted
> -----------------------------------------------------
> syz.0.17/5949 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
> ffff88810c90c240 (&l->lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:341 [inline]
> ffff88810c90c240 (&l->lock){+.+.}-{3:3}, at: lock_list_lru mm/list_lru.c:26 [inline]
> ffff88810c90c240 (&l->lock){+.+.}-{3:3}, at: lock_list_lru_of_memcg+0x268/0x470 mm/list_lru.c:95
> 
> and this task is already holding:
> ffff8881107ad160 (&xa->xa_lock#9){..-.}-{3:3}, at: spin_lock include/linux/spinlock.h:341 [inline]
> ffff8881107ad160 (&xa->xa_lock#9){..-.}-{3:3}, at: __folio_split+0xa2e/0x1570 mm/huge_memory.c:4025
> which would create a new lock dependency:
>  (&xa->xa_lock#9){..-.}-{3:3} -> (&l->lock){+.+.}-{3:3}
> 
> but this new dependency connects a SOFTIRQ-irq-safe lock:
>  (&xa->xa_lock#9){..-.}-{3:3}
> 
> ... which became SOFTIRQ-irq-safe at:
>   lock_acquire+0xf0/0x2e0 kernel/locking/lockdep.c:5868
>   __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:132 [inline]
>   _raw_spin_lock_irqsave+0x40/0x60 kernel/locking/spinlock.c:162
>   __folio_end_writeback+0x157/0x770 mm/page-writeback.c:2946
>
> to a SOFTIRQ-irq-unsafe lock:
>  (&l->lock){+.+.}-{3:3}
> 
> ... which became SOFTIRQ-irq-unsafe at:
> ...
>   lock_acquire+0xf0/0x2e0 kernel/locking/lockdep.c:5868
>   __raw_spin_lock include/linux/spinlock_api_smp.h:158 [inline]
>   _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
>   spin_lock include/linux/spinlock.h:341 [inline]
>   lock_list_lru mm/list_lru.c:26 [inline]
>   lock_list_lru_of_memcg+0x268/0x470 mm/list_lru.c:95
>   list_lru_lock mm/list_lru.c:154 [inline]
>   list_lru_add+0x46/0x260 mm/list_lru.c:208
>   list_lru_add_obj+0x191/0x270 mm/list_lru.c:221
>   d_lru_add+0xd6/0x160 fs/dcache.c:497

Different locks, deferred_split_lru needs its own lockdep key.

