Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5313CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 16:28:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 276678017B; Tue, 28 Oct 2025 12:28:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 226198013F; Tue, 28 Oct 2025 12:28:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1161F8017B; Tue, 28 Oct 2025 12:28:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F02888013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 12:28:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8928C160519
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:28:05 +0000 (UTC)
X-FDA: 84048054930.09.E467499
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id 997E220010
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:28:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mKSYeRFx;
	spf=pass (imf13.hostedemail.com: domain of krishnagopi487@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=krishnagopi487@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761668883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IpH4OZPnfyyaGId/GUkqaK3YoVR6iNW7qBGDUd27apA=;
	b=3HNaKsh243EEX+V2GJLfAcORO/hSRiEkPKkO5MU23vOVVF3b1aVJ8+oVqbjc9VoOamW/Nu
	q5Wh/Xuctyd2u42azo2+nxL7eK5NA8fLPB+lsVXu2C7UEfQ8dH0EwnQm9bYKruzNfNpTOU
	QqsNAPWpfaU+I60qCxaSjRkSJam4YbM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mKSYeRFx;
	spf=pass (imf13.hostedemail.com: domain of krishnagopi487@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=krishnagopi487@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761668883; a=rsa-sha256;
	cv=none;
	b=H/+8/52LWQj4/WY6yG3frfk64/x2B03IwPwP1ZCHhyfCa8wcxfpLLXigEknIqM3VlUpLlS
	FHPwXyxZDXFn9tcke6pilslq6esHbR7k0tOGDjn/Wztp55brqUH2k9UT8ucrzFftCUJdM9
	TBH+JEzI6VRRX4p6rWrgCTNg1wSmoZw=
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b4755f37c3eso5159272a12.3
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761668882; x=1762273682; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IpH4OZPnfyyaGId/GUkqaK3YoVR6iNW7qBGDUd27apA=;
        b=mKSYeRFxteydJOJR/c9ks/yZIlx2WVwgRNHPUWumToDnenH9WvyW+aS7ElV33Kgttf
         EwwELYSHDKn49icD3GUjHlbLopRaXjHL7+0hjgDYeXjkw3D61YOI6fWAYhSgixLMZNkX
         KLbdrZU4q7VFMTtr0zmv2nLhnTcgvrPbDnHNd1Rxv9obdzP+pV8IJ9RfrUpLhdP56fG7
         i2+sm0RBLlAk/yxP4UblA3eaBdD2mOx4Ttxk1W/7vLzt4EB6REsrjnAJBtCOtbNHKyJa
         0GTI9cXur1ROPvHwtfLI2wLD9UV5UgZAAIUCJBrDdwObPAQQXHK8JaMW3m/qkwYNb6mE
         u2DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761668882; x=1762273682;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IpH4OZPnfyyaGId/GUkqaK3YoVR6iNW7qBGDUd27apA=;
        b=ZJTUwb3OM0jhfqxWOHH1pEbflNb/JwhGXVh3tVrVpRiAmzr6kTbO3EwREzbzmEvapj
         mvy0MDjnGc4uj70DBNQ9GcIMuQBtvyeskNkalOeYIkVnIh6TwZ3JZV5JRacaYnwHqptK
         Ns1/ONmrLlTULyNZFErklOK3oHP/VozZyWd2JU3M4rUZktK8e0zcAqTK/uIqDYCqvmfy
         IeUTtEfugE8wc9jwd5NeBZBy8RASLfvJZ9G2YwmZG/svgr6uEr9/2dGk0IVq5YOR+d1O
         BTmb0PPiYOEI63umSGUrjW4/khRrE5u9LbG5ul0Xm9FetheOYtnc++LEVv2o3EX4tgvq
         maZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZMelbkQK1TacTxLLnnpkzqSYTuJ1m+imSFyE7Aq2ZfzrdMm3c7jxh4eQAolsfB8sQoO670aXtTg==@kvack.org
X-Gm-Message-State: AOJu0YwIcfwZPDjafEumnWXCJShOo9QnZxrxRwEPEwgtC1joBoRyt2mn
	9htJyNR5KVkmzQ0+z3guS2aKEsXNpL67V3M9OIW0RK7Xyez9MYRhW54o
X-Gm-Gg: ASbGncsC1bBeblYeN9H0cv9TN2r79zu95aklaca2Dz0Nx+mxxfwowrQrVXUFbY+8toE
	lizGtx4iuOvpx5CjIfzwuBRK8EAhwSHS7tnZaQJqQraBBh0nwyQxHC9zTCBSIuoBUs1oMqM5KK5
	0taG1/dDEKQd21pugwTP05CO0qxkK5X0UyKJ1T4NTYgq+dHVQEKMuIxHE8h57WsAy0ONFgrA1+7
	Qh85c5JTgj9B1eLG7ZOhF+QB7gL3rj3poW4gU2WkXxvJIaK5Y+hK1jEDuQE5bWl5F4f4+O8hQg5
	qJYIRra6NfA3y6qb+6nmCJvzhOmpu/xS6IvjVUygPlp/7Ac7Nhb0BsKYeRLpSLf+T4Qc0j9DSuG
	XzAJELpZZDHXAhII77rC5EX1nER3/23HN9/b3LJyt+aGyQmXe/VmXbwgnWNf7ebehsQ2haS7huK
	K08Zo=
X-Google-Smtp-Source: AGHT+IG1DvQPt8gv7ypNW4eJAFL+/pZTY2Li7wlh6Z99CzzF1GPSYmRMS1mrHhgQN4o7AoaWMw4ELg==
X-Received: by 2002:a17:902:e5c4:b0:273:1516:3ed2 with SMTP id d9443c01a7336-294cb51bec5mr51970185ad.50.1761668882078;
        Tue, 28 Oct 2025 09:28:02 -0700 (PDT)
Received: from localhost ([103.70.166.143])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498cf3405sm124241585ad.2.2025.10.28.09.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 09:28:01 -0700 (PDT)
Date: Tue, 28 Oct 2025 21:57:58 +0530
From: Gopi Krishna Menon <krishnagopi487@gmail.com>
To: syzbot <syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@redhat.com, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, rakie.kim@sk.com, 
	syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com, ziy@nvidia.com
Subject: Re: [syzbot] [mm?] WARNING in raw_ioctl
Message-ID: <njddimio6m6pi3bcfyixizrfzjfflqvqe32xlfwn24vtzk67j4@3cijvucydtb5>
References: <68fc07a0.a70a0220.3bf6c6.01ab.GAE@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xmwrvot3vihfxbiv"
Content-Disposition: inline
In-Reply-To: <68fc07a0.a70a0220.3bf6c6.01ab.GAE@google.com>
X-Stat-Signature: gk4d6oo6pa4b8qkdfhn6zoucng57zuq7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 997E220010
X-HE-Tag: 1761668883-1257
X-HE-Meta: U2FsdGVkX1/cSguhn3E0LE0C5d6nTkKgTCIJ+Eq9RlTpFpSmPPQbgG/07OxAbn7YCQ5LoWUZGrzW71o3qU2A/d8GZR9s0ev0mY5KxS0sMjKXjkrljwDnW//wMoP2zWiWaHumdqHDMydp76Z/7EtyaAlBOIDmpp5YTogo8LhzZHLGDKhPMyrA+ZbCb+zFqwzADjpBozGwP3N+HUYS3Xf35ChqTasFtQfa1C3kJUXgjb9corh9wlizcpbcUtHxHJi9POslpTLOvYMitNUqhvp3j5vHPfnNFu50727bO3sNngktHIcWo+OcG0TwIxnY4dEpMBQCVnIWU25GC2lME/KKZL/46ZDJ6iIjzFphBDnI5SLVRG2484ZhNvHEfEvWFtk0Wxm2dP1kXqwrKw6kaV/sKamK/WlqXfzLJF4/PkukUrTRjk8Ektdo6Ja1w6Cqw8PK1fh5L9GJfTlB0Trm24yzvCX0qYIJ8OueOOMcjz6zpwVvIYbTSfmePpE7mchKjP7Y4HFhdeosr2u2S9p4E/pr0ravAXKboHqk5/iahNKJi87YAz9pnjB3r4kzkqM9RH72LdZpCa8XjP9yZnkdzicMW20qXqJqRCJn2p6fJ9dCdMKv8I+X+zQyHvLQfgu8k/Hpb90PfRNlXNufn5Zz3CfNDplwRm/ndJBHcp3oW63f3ptjrO75p+ICG2Z8W7D2FwGGAvsya0S3D4ka4E0eCh2zd94op/3N8ogf1n976GjyKB2A5DOl8gnIwxuVlC3esWUevmlXeDl8LI/eFpGWlYXHAv6+k+imLJEZ7BNAtBlKCO+KvkJyJlD4aFTnqsD7KA75Y8nEEJiPDSKt7QU9xfckF9P75PigcfDjHVNbwAxJtYujWKNkMDOVA5qJ8/qWOr5Hdui9un8DzsgazYzOLNJ9In2zDpI2n/tg6CpbTsGMt78nKPgHaviBoAHKd75uHg8AHkEOAJTdtOKsZrZtbrR
 ls2Xzezl
 rRxY0NXNLAqXIzJYMr9bT2me3FpPSia/DRLLpUCCaCfzhEMUYuCZnsobbk20eMYBxZ4oolXpnKyTG5gdF6seQ2Sd2Ne/TV5sPnucoJLtT9MEmO/Qjdikg/tNYEe3dmWQP/tsOvRNCTOcwZMGd7yAUaIc6dcEZukxjakWUzFo4XOf3cX/3wRVuNe1fzESw0b3E9bd/dnAnsWKRoEHGrrPMsmWo0BP7DtPGoLMqi4l5GTWQNWewSYC9VDr+FP4MVNNA946HKsL0IVknHnJ4Mf3uYRe4YL6guHqvbsIfU/t8h6UJ4PdO/VLU8S7H/rTFYLzLm1HzpUZHfdYmYnnN/CKNJAVyb3KvRWfmuuLVLNYJ+cFTScVHuNoomF2lCVQTIFSwQSKi0SKfp+Jy+/JEdPLHKnqMP5Njx69/BaxGu6fS01goNHSmp0XiEUP3Wy0Z/6lGNDPAD8jQKt6lKU/DMloOosBxJehfxQCpS0PUPy0vcV03ldOgCD+OZj6297q2nCK8n0qRdT2HTkvcl/gjh2cMyd+8icp74Iq7SKFpL5959LWsUcIXDtHg0lpMDqcnunnbB31oK94XMYRekDXTOijteX+z/4uSBwq4q5S750FuYYlf51Esuz2H3GwYN5tzTygg0OJ1Z4Pa2IHPxxc6uCT5RuSEYhN+2wu6i0KLGdptRD27lYe8LvvQ0tJkwQLl9X7vjVb9nD8LmnB9uHMkAgKYF3z2qtmm7qYFooirPvQBlAc9XOX9zXjQYW2nnt9A9kw5bLsBDk2W2MvH6HxoSQOoARJssbdvlMEH2Gj6fzRd2AJ+jl4Qwp5cmLWcz8BMggYEmlZjSi58YPVKka7NhIgyvwCOD5X/1P1hIdlAlIqGRtum/qJVSaYxVS3qaQVcfxTFdGN9L7YYgsqahoXoOaiwRKv6wyk8UEcRhbFuFyCci14KLIsrhmtlr9Oe4gYKfOd8DkeEjPHDeXFB6Zs4svYvcqz37AkI
 fHqj9xUN
 UjXDHJJoctpWruvcY2Y56Uo2wa+yZNg/dksJn878Dr78D2gPR2ZQUakokCkKLZ1BMKvDUWrvvMD3srBmqTVirA5B4+0nx5fL9W99xeMfo4Ib0TlR7crx6G97nhatmyXwXKci8ry6gOYfHPTRdbTfkL+bgJLstI6P1Wvr/tM/srcxfyYxWgT3EshjI0ZclgU7rgFHruDOg9aeAkubXnD6gtrsUm7VhGjkbPEuQWkZyby+r3lVRD2rwv2JwdY3jqQiKmmknhaCn/dwSPRFOHEt6N2F9rUip2sYgmfZnfjAcmnRl9/EZnPDd1sX7Mk+QgSOi+b/lFcyQ07qImNMjL3oU5rAzVsECv21UqJVh6ocJ8z8yLQCt8fb7+iBapakghZpTPwKRGc2ioTOGrWi1r13I4Y/JImJ//0DkfQ3xsjuiCXcudFjwuwknh/ijsX2oUygRvAvvDuALNqNm3T9a1no5i8TbMdqlD3nM8N6sRLGzIw2XepTvEyK1vPyPBR7DFhdU+BpSHyN27yW1AsK03affX+JkSP4M2Dd0Liqy3VvFh+F4aL+AfHEqjgxmWhcvNio
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--xmwrvot3vihfxbiv
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

#syz test

--xmwrvot3vihfxbiv
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-usb-raw-gadget-cap-raw_io-transfer-length-to-KMALLOC.patch"

From a483c5673cef7995e74dc3556196e25344b5e434 Mon Sep 17 00:00:00 2001
From: Gopi Krishna Menon <krishnagopi487@gmail.com>
Date: Tue, 28 Oct 2025 20:18:04 +0530
Subject: [PATCH] usb: raw-gadget: cap raw_io transfer length to
 KMALLOC_MAX_SIZE
To: andreyknvl@gmail.com,
    gregkh@linuxfoundation.org
Cc: snovitoll@gmail.com,
    linux-usb@vger.kernel.org,
    linux-kernel@vger.kernel.org,
    skhan@linuxfoundation.org,
    david.hunter.linux@gmail.com,
    khalid@kernel.org,
    linux-kernel-mentees@lists.linux.dev,
    syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com

The previous commit removed the PAGE_SIZE limit on transfer length of
raw_io buffer in order to avoid any problems with emulating USB devices
whose full configuration descriptor exceeds PAGE_SIZE in length. However
this also removes the upperbound on user supplied length, allowing very
large values to be passed to the allocator.

syzbot on fuzzing the transfer length with very large value (1.81GB)
results in kmalloc() to fall back to the page allocator, which triggers
a kernel warning as the page allocator cannot handle allocations more
than MAX_PAGE_ORDER/KMALLOC_MAX_SIZE.

Since there is no limit imposed on the size of buffer for both control
and non control transfers, cap the raw_io transfer length to
KMALLOC_MAX_SIZE and return -EINVAL for larger transfer length to
prevent any warnings from the page allocator.

Fixes: 37b9dd0d114a ("usb: raw-gadget: do not limit transfer length")
Tested-by: syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com
Reported-by: syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68fc07a0.a70a0220.3bf6c6.01ab.GAE@google.com/
Signed-off-by: Gopi Krishna Menon <krishnagopi487@gmail.com>
---
 drivers/usb/gadget/legacy/raw_gadget.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/gadget/legacy/raw_gadget.c b/drivers/usb/gadget/legacy/raw_gadget.c
index b71680c58de6..46f343ba48b3 100644
--- a/drivers/usb/gadget/legacy/raw_gadget.c
+++ b/drivers/usb/gadget/legacy/raw_gadget.c
@@ -40,6 +40,7 @@ MODULE_LICENSE("GPL");
 
 static DEFINE_IDA(driver_id_numbers);
 #define DRIVER_DRIVER_NAME_LENGTH_MAX	32
+#define USB_RAW_IO_LENGTH_MAX KMALLOC_MAX_SIZE
 
 #define RAW_EVENT_QUEUE_SIZE	16
 
@@ -667,6 +668,8 @@ static void *raw_alloc_io_data(struct usb_raw_ep_io *io, void __user *ptr,
 		return ERR_PTR(-EINVAL);
 	if (!usb_raw_io_flags_valid(io->flags))
 		return ERR_PTR(-EINVAL);
+	if (io->length > USB_RAW_IO_LENGTH_MAX)
+		return ERR_PTR(-EINVAL);
 	if (get_from_user)
 		data = memdup_user(ptr + sizeof(*io), io->length);
 	else {
-- 
2.43.0


--xmwrvot3vihfxbiv--

